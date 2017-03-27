/**
 * File containing Refill class to find a customer image
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
objRetype.refill( new FluidCustomerImageLookup() )


/**
 * Refill to load a customer's image in a browser, searching by IP code
 *
 * @category	Automation
 * @package		ReTyPe
 * @author		Dominic Wrapson <dwrapson@whistlerblackcomb.com>
 * @copyright	2015 Dominic Wrapson
 */
class FluidCustomerImageLookup extends Fluid {

	;strHotkey		:= "^+i"
	strMenuPath		:= "/CusMan"
	strMenuText		:= "Customer Image"
	intMenuIcon		:= 265 ;272

	/**
	 * Setup controls, window group, etc
	 */
	__New() {
		base.__New()
	}

	/**
	 * Where the magic happens
	 */
	pour() {
		intIP := InputBox.show( "Enter IP code to find image" )
		Run, http://wbwebapps/wbphonelist/grabimage.aspx?RTPImage=True&ID=%intIP%
	}

}