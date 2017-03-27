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
 * @abstract
 */
class Fluid {

	id				:= this.__Class
	strHotKey		:= 
	strMenu			:=
	strMenutext		:= 
	strFileConf		:=

	__New() {
		global objRetype

		strFileConf := A_ScriptDir "\refills\" this.id ".ini"
		StringLower, strFileConf, strFileConf
		this.strFileConf := strFileConf
	}

	/**
	 * Prepares the Fluid for use (being "refilled")
	 *
	 * This method prepares the Fluid object before it use use for refill by
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
			if ( objRetype.blnToolbar ) {
	; @todo remove this once the rtp.activate code works in the toolbar
				GroupAdd, %strGroup%, Retype ahk_class AutoHotkeyGUI
			}
			; Restruct the hotkey usage to the specified group
	; @todo This doesn't work!  Can run hotkey with keyboard from toolbar, but not from menu click
			Hotkey, IfWinActive, ahk_group %strGroup%
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

}