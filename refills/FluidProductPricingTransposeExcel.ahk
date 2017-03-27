/**
 * File containing class for transposing Pricing
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
 * @copyright	2013 Dominic Wrapson
 * @license		Creative Commons Attribution-ShareAlike 4.0 International License http://creativecommons.org/licenses/by-sa/4.0/deed.en_US
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

	/**
	 * Setup controls, window group, etc
	 */
	__New() {
		global objRetype
		base.__New()

		strGroup	:= this.id
		strRTP		:= % objRetype.objRTP.classNN()
		GroupAdd, %strGroup%, Product Header Pricing Bulk Update ahk_class %strRTP%, Selected Price Update Details
	}

	pour() {
		global objRetype
		static intIterate := 1
		static intChannels := 3

		; Activate RTP (after toolbar has been clicked)
		objRetype.objRTP.Activate()

		; Run if it's ready!
		strGroup := this.__Class
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
