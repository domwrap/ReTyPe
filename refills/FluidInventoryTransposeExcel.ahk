/**
 * File containing Refill class to transpose Inventory
 * Class will add itself to the parent retype instance
 *
 * AutoHotKey v1.1.13.01+
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Affero General Public License as published
 * by the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 * 
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Affero General Public License for more details.
 * 
 * You should have received a copy of the GNU Affero General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 *
 * @category	Automation
 * @package		ReTyPe
 * @author		Dominic Wrapson <dwrapson@whistlerblackcomb.com>
 * @copyright	2014 Dominic Wrapson
 * @license		GNU AFFERO GENERAL PUBLIC LICENSE Version 3, 19 November 2007 http://www.gnu.org/licenses/
 */


; Trigger my damn self (in a horrible way due to AHK limitations)
objRetype.refill( new FluidInventoryTransposeExcel() )


/**
 * Refill to transpose Inventory setup from Excel spreadsheet
 *
 * @category	Automation
 * @package		ReTyPe
 * @author		Dominic Wrapson <dwrapson@whistlerblackcomb.com>
 * @copyright	2013 Dominic Wrapson
 */
class FluidInventoryTransposeExcel extends Fluid {

	strHotkey		:= "^!i"
	strMenuPath		:= "/Admin/Inventory"
	strMenuText		:= "Transpose from Excel"
	intMenuIcon		:= 250 ;134

	/**
	 *
	 */
	pour() {
		global objRetype

		strGroup	:= this.__Class
		strRTP		:= % objRetype.objRTP.classNN()
		GroupAdd, %strGroup%, Update ahk_class %strRTP%, Inventory Pool Type

		; Activate RTP (after toolbar has been clicked)
		objRetype.objRTP.Activate()

		IfWinActive, ahk_group %strGroup%
		{
			if ( objRetype.objRTP.isActive() ) {
; @todo ImageSearch?
				; Variable setup
				idWinUpdate		:= WinActive("A")
				strWinInvAdd	= Add Inventory Pool Location
				;strWinInvUpd	= Update
				;~ idWinExcel	:= Window.GetID( "Excel", "Excel", "XLMAIN" )

				; Grab active Excel window
; @todo Detect Excel windows, if more than one provide means of selecting which to use
				try {
					objExcel := ComObjActive( "Excel.Application" )
				} catch e {
					Debug.log( e )
					MsgBox.stop( "Could not attach to Excel spreadsheet" )
				}

				; Prompt for rows (eventually maybe detect?)
				intIterate := InputBox.show( "Transpose how many Excel rows?", 1 )
; @todo Input:0 to iterate until finds a blank row

				; Make sure we're on the Inventory Pool window
				WinActivate, ahk_id %idWinUpdate%
				; Set it up ready for looping
				ControlFocus, WindowsForms10.SysTreeView32.app.0.30495d1_r11_ad11, A
				Send {End}{Tab}{Right 5}{Tab}

				; Reset Excel to colA, and if row1 then make it row2 (to ignore titles)
				intActiveRow := ( 1 = objExcel.ActiveCell.Row ) ? 2 : objExcel.ActiveCell.Row
				objExcel.ActiveSheet.Cells( intActiveRow, 1 ).Select

				; Iterate
				Loop %intIterate%
				{
					WinActivate, %idWinUpdate%
					Send {Space}
					;idWinAdd := WinActive("A")

					; Only one built-in counter variable so must set in outer loop
					intRow := A_Index -1

					; Input dates
					Loop 2
					{
						; Column set in inner loop so we get two columns for every one row	
						intCol := A_Index -1
;msgbox % "Row: " intRow "`nCol: " intCol "`nInd: " A_Index
						; Get date from Excel
						dtDate := objExcel.ActiveCell.Offset( intRow, intCol ).Value
						StringReplace, dtDate, dtDate, `r`n, , All
						;WinActivate, %idWinAdd%
						blnDate := Send.date( dtDate )
						if ( !blnDate ) {
							MsgBox.stop( "Invalid date [" dtDate "] found in cell: " objExcel.ActiveCell.Offset( intRow, intCol ).Address )
; @todo show "blank" if blank date
						}
						SendInput {Tab}
					}
					; Input warning values
					Loop 2
					{
						intCol += 1
						intLevel := objExcel.ActiveCell.Offset( intRow, intCol ).Value
						if intLevel is not number
							MsgBox.stop( "Invalid Level detected (non integer/decimal) in cell: " objExcel.ActiveCell.Offset( intRow, intCol ).Address )
						intLevel := SubStr( intLevel, 1, InStr( intLevel, "." ) -1 )
						;WinActivate, %idWinAdd%
						SendInput %intLevel%{Tab}
					}
					; Tick some boxes
					Loop 2
					{
						;WinActivate, %idWinAdd%
						SendInput {Space}{Tab}
					}
					SendInput 99{Tab}
					SendInput {Space}{Tab}
					SendInput {Space}
				}
			} else { 
				SplashImage, %A_ScriptDir%\img\uhuhuh_sub.gif, b
				SoundPlay, %A_ScriptDir%\img\uhuhuh.mp3
				Sleep, 3000
				SplashImage, Off
			}
		}
	}

}