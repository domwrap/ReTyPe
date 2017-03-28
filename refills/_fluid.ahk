/**
 * File containing abstract class for all Refill Fluids
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


/**
 * Abstract class for all Fluid classes that contains reusable methods
 * and reduces code duplication
 *
 * @category	Automation
 * @package		ReTyPe
 * @author		Dominic Wrapson <dwrapson@whistlerblackcomb.com>
 * @copyright	2014 Dominic Wrapson
 * @abstract
 */
class Fluid {

	id				:= this.__Class
	strHotKey		:=
	strMenuPath		:=
	strMenutext		:=
	intMenuIcon		:=
	strFileConf		:=

	__New() {
		global objRetype

		this.id := this.__Class

		; Build config filename based on classname
		strFileConf			:= objRetype.strDirConf this.id ".ini"
		this.strFileConf	:= strFileConf
	}

	/**
	 * Prepares the Fluid for use (being "refilled")
	 *
	 * This method prepares the Fluid object before its use for refill by
	 * the ReTyPe framework.  Code in here could theoretically go in the
	 * constructor, but validation is performed before refilling that would
	 * make this harder to achieve.
	 *
	 * Though the code here is inherited by all child Fluids, it is not yet
	 * necessary nor useful for Timer-based Fluids, only Hotkey-based.  This
	 * may change at a later date, and, if different enough, may be further
	 * separated in to two further child classes, presenting:
	 *     __ Fluid __
	 *    /           \
	 * FluidTimer   FluidHotkey
	 *    |            |
	 *  UITimer     SendHotkey
	 */
	fill() {
		global objRetype

		; Checks to see if we will be using a hotkey to activate refill
		if ( this.strHotKey ) {
			; build class.method to pass through (cannot do it inline)
			strMethod := this.id ".pour"
			; Bind the hotkey about to be created to particular window, therefore
			; it doesn't get run somewhere it shouldn't and also allows us to use
			; the same hotkey in multiple places but for different things
			; Restrict access to hotkey by defined window group
			strGroup := this.id
			; Add the Retype Toolbar to the allowed group otherwise it'll never
			; allow hotkey activation from menu clicks
			; ACTUALLY don't do this as it should have already been done in the refill constructor
			;GroupAdd, %strGroup%, Retype ahk_class AutoHotkeyGUI
; @TODO Figure out how to restrict hotkeys to their window groups, also @see hotkey.ahk
			; Restrict the hotkey usage to the specified group
			; @todo This doesn't work!  Can run hotkey with keyboard from toolbar, but not from menu click
			;#IfWinActive, ahk_group %strGroup%
			;Hotkey, IfWinActive, ahk_group %strGroup%

			; Adds hotkey [The last "" param appears to be required otherwise the dynamic class.method call doesn't work]
			Hotkey.add( this, "" )
		}
	}

	/**
	 * Return Fluid ID (which is it's name)
	 */
	getID() {
		return this.id
	}

	/**
	 * Return Hotkey used to activate Fluid
	 */
	getHotkey() {
		return this.strHotkey
	}

	/**
	 * Read key value from ini file, with default on fail
	 * @param String Key name
	 * @param Mixed Default value for failure
	 * @return Mixed Read value on success, or default on failure
	 */
	getConf( strKey, mixDefault ) {
		IniRead, mixValue, % this.strFileConf, Conf, %strKey%, %mixDefault%
		return %mixValue%
	}

}