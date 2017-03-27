/**
 * File containing Refill class to facilitate cloning product discounts
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
objRetype.refill( new FluidProductDiscountClone() )


/**
 * Refill to automatically clone X product discounts
 *
 * @category	Automation
 * @package		ReTyPe
 * @author		Dominic Wrapson <dwrapson@whistlerblackcomb.com>
 * @copyright	2015 Dominic Wrapson
 */
class FluidProductDiscountClone extends Fluid {


	strHotkey		:= "^!+g"
	strMenuPath		:= "/Admin/Discount"
	strMenuText		:= "Discount Clone"
	intMenuIcon		:= 66


	/**
	 * Setup controls, window group, etc
	 */
	__New() {
		global objRetype
		base.__New()

		strGroup 	:= this.id
		strRTP		:= % objRetype.objRTP.classNN()
		GroupAdd, %strGroup%, Add A Discount ahk_class %strRTP%, Added Product Discounts
		GroupAdd, %strGroup%, Update ahk_class %strRTP%, Added Product Discounts
	}


	/**
	 * Where the magic happens
	 */
	pour() {
		global objRetype
		static intEffective 	:= 
		static intExpiration 	:= 
		static intIterate 		:= 1

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

				; Check that appropriate form control is focused before continuing
				strControlList := objRetype.objRTP.formatClassNN( "SysListView32", this.getConf( "ListDiscountProducts", 11 ) )
				if ( Window.CheckControlFocus( strControlList, "Add Product Discounts listview" ) ) {
					; Prompt for input parameters
					intEffective	:= InputBox.Show( "Effective date`n`nFormat: mm/dd/yyyy", intEffective )
					intExpiration	:= InputBox.Show( "Expiration date`n`nFormat: mm/dd/yyyy", intExpiration )
					intDiscount 	:= InputBox.Show( "Discount value?`n`n(Leave BLANK to clone)" )
					intMethod 		:= InputBox.Show( "Calculation method?`n`n(1=Fixed/2=Percent/BLANK to clone existing)" )
					intIterate 		:= InputBox.Show( "Clone how many discounts?", intIterate )

					; Input validation before proceeding
					if ( !intEffective && !intExpiration ) {
						MsgBox.stop( "You must specify Effective Date and Expiration Date")
					}

					Loop %intIterate%
					{
						; Re-activate most recently active window in the group (the one in which we're meant to be working) in case user clicked away
						GroupActivate, %strGroup%, R

						; Open copy window
						Send {Tab}{space}
						; Move to effective input
						Send {Tab}
						; Enter user-defined effective date
						objRetype.objRTP.dateInput( intEffective )
						; Move to expiry input
						Send {Tab}
						; Enter user-defined expiry date
						objRetype.objRTP.dateInput( intExpiration )
						; Move to discount Amount
						Send {Tab}
						if ( intDiscount )
						{
							; Select all existing text, and overwrite
							Send ^a%intDiscount%
						}
						Send {Tab}
						; Choose appropriate discount method
						if ( intMethod = 1 ) {
							Send {Up}
						} else if ( intMethod = 2 ) {
							Send {Down}
						}
						; Move to Update button and press it
						Send {Tab}{Space}

						; RTP might chuck an error if dates overlap, so deal with it
						if (  WinActive( "Alert", "overlapping date range") ) {
							; Prompt user if they want to ignore and keep going, or exit
							MsgBox.yesno( "Error encountered, skip and continue?" )
							IfMsgBox, Yes
							{
								; Focus the error box and close it
								WinActivate, Alert, overlapping date range
								ControlClick, OK
							} else {
								; User opts-out, so quit
								return
							}
						}

						; Now back on parent window, shift+tab back to lsit view and move down a row
						Send +{Tab}{Down}
					}

				}
 

			}
		}
	}


}