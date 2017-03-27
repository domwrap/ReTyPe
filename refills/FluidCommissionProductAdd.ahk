/**
 * File containing Refill class to facilitate deleting multiple pricing rows from a product header
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
 * @copyright	2015 Dominic Wrapson
 * @license		Creative Commons Attribution-ShareAlike 4.0 International License http://creativecommons.org/licenses/by-sa/4.0/deed.en_US
 */


; Trigger my damn self (in a horrible way due to AHK limitations)
objRetype.refill( new FluidCommissionProductAdd() )


/**
 * Refill to automatically add multiple products to a commission class, or multiple commissions to a product
 *
 * @category	Automation
 * @package		ReTyPe
 * @author		Dominic Wrapson <dwrapson@whistlerblackcomb.com>
 * @copyright	2015 Dominic Wrapson
 */
class FluidCommissionProductAdd extends Fluid {

	strHotkey		:= "^!c"
	strMenuPath		:= "/Admin/Commission"
	strMenuText		:= "Commission Add"
	intMenuIcon		:= 29

	/**
	 * Setup controls, window group, etc
	 */
	__New() {
		global objRetype
		base.__New()

		strGroup 	:= this.id
		strRTP		:= % objRetype.objRTP.classNN()
		GroupAdd, %strGroup%, Create a Commission Class ahk_class %strRTP%
		GroupAdd, %strGroup%, Update ahk_class %strRTP%, Receipt Label
		GroupAdd, %strGroup%, Add Product Header ahk_class %strRTP% Receipt Label
	}

	/**
	 * Where the magic happens
	 */
	pour() {
		global objRetype
		static intIterate := 1
		static intCommission := 25

		; Activate RTP (after toolbar has been clicked)
		objRetype.objRTP.Activate()
; @todo Check needs to be removed once I've managed to wall-in shortcuts in to the RTP only window
		; Run if it's ready!
		strGroup := this.__Class
		IfWinActive, ahk_group %strGroup%
		{
			; Did you execute from an RTP window?
			if ( objRetype.objRTP.isActive() ) {
				idWinRTP	:= WinActive("A")

				; Prompt for iteration count
				intIterate := InputBox.show( "How many products/commission classes?", intIterate )
				intCommission := InputBox.show( "What commission rate?", intCommission )

				Loop %intIterate%
				{
					this._updateCommission( intCommission )
				}

			}
		}
	}


	/**
	 * Function to update per-product commissions
	 */
	_updateCommission( intCommission, dtExpiry="12/31/2020", dtEffective=0 ) {
		global objRetype

	;MsgBox %dtEffective% %dtExpiry%
		; Date checking
		FormatTime, dtNow, %A_Now%, MM/dd/yyyy
		;FormatTime, dtExpiry, %dtExpiry%, MM/dd/yyyy
		;FormatTime, dtEffective, %dtEffective%, MM/dd/yyyy
		if !dtEffective
			dtEffective := dtNow
	;MsgBox %dtNow% %dtEffective% %dtExpiry%
	;	If dtExpiry < dtNow
	;	{
	;		MsgBox Expiry date %dtExpiry% is in the past.  Exiting.
	;		Exit
	;	}

		; Input the data
		Send {Tab}{Space}
		Sleep 100
		objRetype.objRTP.dateInput( dtEffective )
		Send {Tab}
		objRetype.objRTP.dateInput( dtExpiry )
		Send {Tab}%intCommission%
		Send {Tab 2}{Space}
		Send +{Tab}
		Send {Down}
	}

}