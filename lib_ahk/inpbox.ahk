/**
 * Class to encapsulate InputBox funtionality
 *
 * AutoHotKey v1.1.13.01+
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Affero General Public License as published
 * by the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 * 
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Affero General Public License for more details.
 * 
 * You should have received a copy of the GNU Affero General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 *
 * @category	Automation
 * @package		ReTyPe
 * @author		Dominic Wrapson <dwrapson@whistlerblackcomb.com>
 * @copyright	2014 Dominic Wrapson
 * @license		GNU AFFERO GENERAL PUBLIC LICENSE Version 3, 19 November 2007 http://www.gnu.org/licenses/
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
class InpBox extends _returnableClass {

	static title := "InputBox"

	/**
	 * Displays an input box to ask the user to enter a string
	 * 
	 * @param string strMessage The message to display on the input dialogue
	 * @param mixed mixDefault The default value in the input box
	 * @param bool blnExit Control whether to return or exit on user-cancel
	 *
	 * @return mixed Mixed value of user-input
	 */
	show( strMessage, mixDefault="", blnHide=0 ) {
		mixHide := ( 1 = blnHide ) ? "HIDE" : ""

		; Show the actual box
		strTitle := % this.title
		InputBox, mixVar, %strTitle%, %strMessage%, %mixHide%, , , , , , , %mixDefault%

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