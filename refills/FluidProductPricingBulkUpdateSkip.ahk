/**
 * File containing Refill class to facilitate bulk-pricing product headers
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
objRetype.refill( new FluidProductPricingBulkUpdateSkip() )


/**
 * Refill to automatically update X pricing rows in bulk pricing
 *
 * @category	Automation
 * @package		ReTyPe
 * @author		Dominic Wrapson <dwrapson@whistlerblackcomb.com>
 * @copyright	2015 Dominic Wrapson
 */
class FluidProductPricingBulkUpdateSkip extends FluidProductPricingBulkUpdate {


	strHotkey		:= "^!+p"
	strMenuPath		:= "/Admin/Product"
	strMenuText		:= "Bulk Pricing Update (with skip)"
	intMenuIcon		:= 299


	/**
	 * Class is just an extension of its parent, but with a flag to loop X rows down afterward (useful when there's components to skip, like P2P)
	 * @param bool blnDown Determines whether we move down X rows after updating pricing
	 */
	pour() {
		base.pour( true )
	}


}