/**
 * Class to encapsulate InputBox funtionality
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

#include _returnableclass.ahk

/**
 * Class to encapsulate InputBox funtionality
 *
 * @category	Automation
 * @package		ReTyPe
 * @author		Dominic Wrapson <dwrapson@whistlerblackcomb.com>
 * @copyright	2014 Dominic Wrapson
 */
class InputBox extends _returnableClass {

	static title := "ReTyPe"

	/**
	 * Displays an input box to ask the user to enter a string
	 * 
	 * @param string strMessage The message to display on the input dialogue
	 * @param mixed mixDefault The default value in the input box
	 * @param bool blnExit Control whether to return or exit on user-cancel
	 *
	 * @return mixed Mixed value of user-input
	 */
	show( strMessage, mixDefault="" ) {
		strTitle := % this.title
		InputBox, mixVar, %strTitle%, %strMessage%, , , , , , , , %mixDefault%

		if ErrorLevel {
			if ( True != this._RETURN_ON_USER_CANCEL() )
				Exit
			else
				return False
		} else {
			return %mixVar%
		}
	}

}