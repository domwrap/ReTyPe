/**
 * Abstract (if it was supported) base class for objects that will make a decision
 * as to whether or not they will return a false on failure or just exit the thread
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

class _returnableClass {
;Abstract keyword not supported, therefore underscore _prefix signifies internally

	static RETURN_ON_USER_CANCEL := False

	_RETURN_ON_USER_CANCEL() {
		return this.RETURN_ON_USER_CANCEL
	}

}