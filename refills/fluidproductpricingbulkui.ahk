/**
 * File containing Refill class to add text-searching for access codes to components
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
objRetype.refill( new FluidProductPricingBulkUI() )

/**
 * Refill that resizes combo-box in bulk pricing window to make pricing seasons legible
 *
 * @category	Automation
 * @package		ReTyPe
 * @author		Dominic Wrapson <dwrapson@whistlerblackcomb.com>
 * @copyright	2014 Dominic Wrapson
 */
class FluidProductPricingBulkUI extends Fluid {

	static intTimer	:= 500

	/**
	 * Setup controls, window group, etc
	 */
	__New() {
		global objRetype
		base.__New()

		strRTP		:= % objRetype.objRTP.classNN()
		strGroup	:= this.id
		GroupAdd, %strGroup%, Product Header Pricing Bulk Update ahk_class %strRTP%, Selected Price Update Details
	}

	/**
	 * Triggered when appropriate window conditions met
	 */
	pour() {
		global objRetype

		; BULK PRICING:	Resize the pricing season drop-down
		strGroup := this.__Class
		IfWinActive, ahk_group %strGroup%
		{
			if ( Window.CheckActiveProcess( "rtponecontainer" ) ) {
				strControl := objRetype.objRTP.formatClassNN( "COMBOBOX", this.getConf( "ComboBox", 11 ) )
				ControlMove, %strControl%, , , 400, , A
			}
		}
	}

}