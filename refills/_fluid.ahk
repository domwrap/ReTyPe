/**
 * File containing abstract class for all Refill Fluids
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


/**
 * Abstract class for all Fluid classes that contains reusable methods
 * and reduces code duplication
 *
 * @category	Automation
 * @package		ReTyPe
 * @author		Dominic Wrapson <dwrapson@whistlerblackcomb.com>
 * @copyright	2014 Dominic Wrapson
 */
class Fluid {

	fill() {
		; abstract out code for:
		; - dynamic method
		; - Hotkey scope (ifwinactive)
		; - Hotkey add

		; Should the abstracted code be in the constructor?
		; Prob not as there are validity checks before fill() is called
	}

	id() {
		return this.__Class
	}

}