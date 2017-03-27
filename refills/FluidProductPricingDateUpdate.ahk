/**
 * File containing Refill class to facilitate updating multiple pricing dates on a product header
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
objRetype.refill( new FluidProductPricingDateUpdate() )


/**
 * Refill to automatically update X price-by-date effective and expiry dates
 *
 * @category	Automation
 * @package		ReTyPe
 * @author		Dominic Wrapson <dwrapson@whistlerblackcomb.com>
 * @copyright	2015 Dominic Wrapson
 */
class FluidProductPricingDateUpdate extends Fluid {


	strHotkey		:= "^!d"
	strMenuPath		:= "/Admin/Product"
	strMenuText		:= "Pricing Effective/Expiry Dates"
	intMenuIcon		:= 214


	/**
	 * Setup controls, window group, etc
	 */
	__New() {
		global objRetype
		base.__New()

		strGroup 	:= this.id
		strRTP		:= % objRetype.objRTP.classNN()
		GroupAdd, %strGroup%, Add ahk_class %strRTP%, Sales Report Group
		GroupAdd, %strGroup%, Update ahk_class %strRTP%, Sales Report Group
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

				; Detect PriceType selection for how we update the pricing with keystrokes
				 ;WindowsForms10.COMBOBOX.app.0.30495d1_r11_ad18
				strControlListPricing := objRetype.objRTP.formatClassNN( "COMBOBOX", this.getConf( "PricingType", 18 ) )
				ControlGet, strSelected, Choice, , %strControlListPricing%, A
				; Check if we can actually find the pricing type combo, and exit with error if not
				if ( 0 = StrLen( strSelected ) ) {
					MsgBox.Stop( "Could not determine pricing type, exiting" )
				}

				; Only change if price-by-date
				if ( strSelected = "By Date") {

					intEffective	:= InputBox.Show( "New Effective date`n`nFormat: mm/dd/yyyy, or leave blank to skip" )
					intExpiration	:= InputBox.Show( "New Expiration date`n`nFormat: mm/dd/yyyy, or leave blank to skip" )
					intIterate 		:= InputBox.Show( "Update how many rows?", intIterate )

					Loop %intIterate%
					{
						Send {AppsKey}u
						if intEffective
						{
							objRetype.objRTP.dateInput( intEffective, 0 )
						}
						Send {Tab}
						if intExpiration
						{
							objRetype.objRTP.dateInput( intExpiration )
						}
						Send {Tab 6}{Space}
						Send {Down}
					}
				}

			}
		}
	}


}