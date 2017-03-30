/**
 * File containing class for transposing Pricing
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
objRetype.refill( new FluidProductPricingTransposeExcel() )


/**
 * Refill that transposes pricing from Excel spreadsheet in to RTP Bulk Pricing Window
 *
 * @category	Automation
 * @package		ReTyPe
 * @author		Dominic Wrapson <dwrapson@whistlerblackcomb.com>
 * @copyright	2013 Dominic Wrapson
 */
class FluidProductPricingTransposeExcel extends Fluid {

	strHotkey		:= "^!h"
	strMenuPath		:= "/Admin/Product"
	strMenuText		:= "Transpose from Excel"
	intMenuIcon		:= 250

	pour() {
		global objRetype
		static intIterate := 1
		static intChannels := 3

		strGroup	:= this.__Class
		strRTP		:= % objRetype.objRTP.classNN()
		GroupAdd, %strGroup%, Product Header Pricing Bulk Update ahk_class %strRTP%, Selected Price Update Details

		; Activate RTP (after toolbar has been clicked)
		objRetype.objRTP.Activate()

		; Run if it's ready!
		IfWinActive, ahk_group %strGroup%
		{
			if ( objRetype.objRTP.isActive() ) {
				idWinRTP	:= WinActive("A")

				; Grab active Excel window
; @todo Detect Excel windows, if more than one provide means of selecting which to use
				try {
					objExcel := ComObjActive("Excel.Application")
				} catch e {
					Debug.log( e )
					MsgBox.stop( "Could not attach to Excel spreadsheet" )
				}
				; @see http://www.autohotkey.com/board/topic/56987-com-object-reference-autohotkey-l/page-4#entry381256
				; @see http://msdn.microsoft.com/en-us/library/bb257110(v=office.12).aspx

				; Prompt for components and channels
				intIterate := InputBox.show( "Transpose how many Excel rows?", intIterate )
				intChannels := InputBox.show( "How many Sales Channels do we have?", intChannels )

; @todo Additional input to accept up to four column letters to automate entry for productsXchannelsXpricecolumns
;strColumns := InputBox.show( "Which columns contain pricing?`n`nComma separated list: F,N,N,U", "" )

				; Get us to the pricing entry for selected row
				ControlFocus, OK, ahk_id %idWinRTP%
				Send {Tab}{Home}{Right 6}

				Loop %intIterate% {
					; If first iteration, don't offset as using currently selected cell
					intOffset := ( 1 = A_Index ) ? 0 : 1

					; Select cell we're going to grab (shift this down each time so can keep track)
					objExcel.ActiveCell.Offset( intOffset, 0).Select
					; Grab value from Excel (formula value to detect bad grid)
					mixValue := objExcel.ActiveCell.Formula

					; Check for formulae
					if ( InStr( mixValue, "=" ) ) {
						MsgBox.stop( "Formula in pricing input cell: " objExcel.ActiveCell.Address )
; @todo Change to continue:yes/no and if yes, skip next %intChannels% and continue
					}
					; Check value contents (should be an integer number!)
					if mixValue is not number
						MsgBox.stop( "Invalid pricing detected, (non integer/decimal) in cell: " objExcel.ActiveCell.Address )

					; If we're here we're good, input pricing
					Loop %intChannels% {
						SendInput %mixValue%{Down}
					}
				}
			} else {
; @todo change this
				msgbox not for you!
			}
		}
	}

}
