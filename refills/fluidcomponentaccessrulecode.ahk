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
objRetype.refill( new FluidComponentAccessRuleCode() )


/**
 * Refill to add text-search box to components for access codes
 *
 * @category	Automation
 * @package		ReTyPe
 * @author		Dominic Wrapson <dwrapson@whistlerblackcomb.com>
 * @copyright	2014 Dominic Wrapson
 */
class FluidComponentAccessRuleCode extends Fluid {

	static intTimer		:= 200


	__New() {
		strGroup := this.id
		GroupAdd, %strGroup%, ahk_class WindowsForms10.Window.8.app.0.30495d1_r11_ad1, Access Code Procedure
	}


	fill() {
	}


	; BULK PRICING:	Resize the pricing season drop-down
	pour() {
		Global

		strGroup := this.id

		; Get RTP window for later reference
		WinGet, idWinRTP, ID, ahk_class WindowsForms10.Window.8.app.0.30495d1_r11_ad1, Access Code Procedure
; @todo VISUAL SEARCH for Access Product dark gray box
		; Build the GUI and do stuff
		IfWinActive, ahk_group %strGroup%
		{
			strControl = WindowsForms10.COMBOBOX.app.0.30495d1_r11_ad16

				WinGetPos, intWinX, intWinY,,,
				ControlGetPos, intCtlX, intCtlY,,, %strControl%,
				intGuiX := intWinX + intCtlX -43
				intGuiY := intWinY + intCtlY

			IfWinExist, AccessCode ahk_class AutoHotkeyGUI
			{
				Gui, AccessCode:Show, NA x%intGuiX% y%intGuiY%, AccessCode
			} else {
				Gui, AccessCode:Add, Edit, x0 y0 w40 gfnSearchAccessRuleTextbox Limit5 Uppercase vFind
				Gui, AccessCode:Margin, 0, 0
				Gui, AccessCode:-SysMenu +ToolWindow -Caption -Border +AlwaysOnTop
				Gui, AccessCode:Show, NA x%intGuiX% y%intGuiY%, AccessCode
				WinGet, idWinRetype, ID, AccessCode ahk_class AutoHotkeyGUI
			}
			WinActivate, ahk_group %strGroup%
		}

		IfWinNotExist, ahk_group %strGroup%
		{
			Gui, AccessCode:Hide
		}

		; Group the RTP and Retype windows together as it's the only way !WinActive will work
		GroupAdd, grpWinAccessCode, ahk_id %idWinRTP%
		GroupAdd, grpWinAccessCode, ahk_id %idWinRetype%
		If !WinActive("ahk_group grpWinAccessCode")
		{
			; This code stops toolbar showing in other apps
			Gui, AccessCode:Destroy
		}

		; GTFO before the label here below
		return

		/**
		 * Adds a border-less UI with a single button next to the disabled AccessCode combobox
		 * Appears to "add" a button to the UI when in fact it floats above it but never steals focus
		 * Now that's MAGIC!
		 */
		fnSearchAccessRuleTextbox:
			WinGet, idWin, ID, ahk_class WindowsForms10.Window.8.app.0.30495d1_r11_ad1, Access Code Procedure

			GuiControlGet, strFind,, Find
			strControl = WindowsForms10.COMBOBOX.app.0.30495d1_r11_ad16
			Control, ChooseString, %strFind% , %strControl%, ahk_id %idWin%
			;WinActivate, Update ahk_id %idWin%

			;Gui, AccessCode:Hide
		return
	}

}