/**
 * File containing Refill class to transpose Inventory
 * Class will add itself to the parent retype instance
 *
 * AutoHotKey v1.1.13.01+
 *
 * LICENSE: This work is licensed under a version 4.0 of the
 * Creative Commons Attribution-ShareAlike 4.0 International License
 * that is available through the world-wide-web at the following URI:
 * http://creativecommons.org/licenses/by-sa/4.0/deed.en_US
 *
 * @category	Automation
 * @package		ReTyPe
 * @author		Dominic Wrapson <dwrapson@whistlerblackcomb.com>
 * @copyright	2014 Dominic Wrapson
 * @license		Creative Commons Attribution-ShareAlike 4.0 International License http://creativecommons.org/licenses/by-sa/4.0/deed.en_US
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

	;strHotkey		:= "^!i"
	strMenuPath		:= "/Admin/Product"
	strMenuText		:= "Inventory Transpose"
	intMenuIcon		:= 250

	/**
	 * Setup controls, window group, etc
	 */
	__New() {
		global objRetype
		base.__New()

		strGroup	:= this.id
		strRTP		:= % objRetype.objRTP.classNN()
		GroupAdd, %strGroup%, Update ahk_class %strRTP%, Inventory Pool Type
		;GroupAdd, %strGroup%, Retype ahk_class AutoHotkeyGUI
	}

	/**
	 *
	 */
	pour() {
		global objRetype

		; Activate RTP (after toolbar has been clicked)
		objRetype.objRTP.Activate()

		strGroup := this.__Class
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