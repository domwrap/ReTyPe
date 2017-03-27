/**
 * File containing Refill class to facilitate updating multiple expiry dates on discounts
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
objRetype.refill( new FluidProductDiscountUpdate() )


/**
 * Refill to automatically update X expiry dates on discounts
 *
 * @category	Automation
 * @package		ReTyPe
 * @author		Dominic Wrapson <dwrapson@whistlerblackcomb.com>
 * @copyright	2015 Dominic Wrapson
 */
class FluidProductDiscountUpdate extends Fluid {


	strHotkey		:= "^!g"
	strMenuPath		:= "/Admin/Discount"
	strMenuText		:= "Discount Update"
	intMenuIcon		:= 214


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
		; Static variable that maintains its value between executions, so can be used as the new default value in the Iterate prompt
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
					; Prompt for new date, and qty to change
					intExpiration 	:= InputBox.Show( "New expiration date`n`nFormat: mm/dd/yyyy, or BLANK to skip" )
					intDiscount 	:= InputBox.Show( "New discount amount`n`nBLANK to skip" )
					intMethod 		:= InputBox.Show( "Calculation method?`n`n[1=Fixed/2=Percent/BLANK to skip]" )
					intIterate 		:= InputBox.Show( "Update how many rows?", intIterate )

					; Input validation before proceeding
					if ( !intExpiration && !intDiscount && !intMethod ) {
						MsgBox.stop( "No input for Expiration, Amount, or Method. Please specify any or all")
					}

					; Loop X times and change expiration dates
					Loop %intIterate%
					{
						; Re-activate most recently active window in the group (the one in which we're meant to be working) in case user clicked away
						GroupActivate, %strGroup%, R

						; Open Update dialog
						Send {Tab 2}{space}
						; If set, update Expiration
						if ( intExpiration ) {
							objRetype.objRTP.dateInput( intExpiration )
						}
						; Move to Amount field
						Send {Tab}
						; If set, update discount amount
						if ( intDiscount ) {
							Send ^a%intDiscount%
						}
						; Move to method combo box
						Send {Tab}
						; If set, update method
						if ( intMethod = 1 ) {
							Send {Up}
						} else if ( intMethod = 2 ) {
							Send {Down}
						}
						; Move to Update button and press
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
						; Move back to listview, and shift it down a row
						Send +{Tab 2}{Down}
					}

				}
 
			}
		}
	}


}