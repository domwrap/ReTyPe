/**
 * File containing Refill class to add text-searching for access codes to components
 * Class will add itself to the parent retype instance
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
 * @author		Dominic Wrapson <hwulex[åt]gmail[dõt]com>
 * @copyright	2014 Dominic Wrapson
 * @license		GNU AFFERO GENERAL PUBLIC LICENSE Version 3, 19 November 2007 http://www.gnu.org/licenses/
 */


; Trigger my damn self (in a horrible way due to AHK limitations)
objRetype.refill( new FluidComponentAccessRuleCode() )


/**
 * Refill to add text-search box to components for access codes
 *
 * @category	Automation
 * @package		ReTyPe
 * @author		Dominic Wrapson <hwulex[åt]gmail[dõt]com>
 * @copyright	2014 Dominic Wrapson
 */
class FluidComponentAccessRuleCode extends Fluid {

	static intTimer		:= 200

	/**
	 * Setup controls, window group, etc
	 */
	__New() {
		global objRetype
		base.__New()

		strGroup	:= this.id
		strRTP		:= % objRetype.objRTP.classNN()
		GroupAdd, %strGroup%, ahk_class %strRTP%, Access Code Procedure
	}

	/**
	 * Add text-searching for access codes to components
	 */
	pour() {
		Global

		; Get RTP window for later reference
		strRTP		:= % objRetype.objRTP.classNN()
		WinGet, idWinRTP, ID, ahk_class %strRTP%, Access Code Procedure

		; Build the GUI and do stuff
		strGroup := this.__Class
		IfWinActive, ahk_group %strGroup%
		{
			; WinActive check isn't good enough in this case, so need to make a visual search too
			ImageSearch intActiveX, intActiveY, 180, 30, 280, 60, *50 %A_ScriptDir%\img\search_fluidcomponentaccessrulecode_accessproduct.png
			If ( !ErrorLevel ) {
				strControl := objRetype.objRTP.formatClassNN( "COMBOBOX", this.getConf( "ComboBox", 16 ) )
				WinGetPos, intWinX, intWinY,,,
				ControlGetPos, intCtlX, intCtlY,,, %strControl%,
				intGuiX := intWinX + intCtlX -43
				intGuiY := intWinY + intCtlY
; @todo check x/y values before proceeding in case config or combo not found and fails
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
			} else {
				Gui, AccessCode:Destroy
			}
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
			; Get RTP window for later reference
			strRTP		:= % objRetype.objRTP.classNN()
			WinGet, idWin, ID, ahk_class %strRTP%, Access Code Procedure

			GuiControlGet, strFind,, Find
			strControl := objRetype.objRTP.formatClassNN( "COMBOBOX", FluidComponentAccessRuleCode.getConf( "ComboBox", 16 ) )
			Control, ChooseString, %strFind% , %strControl%, ahk_id %idWin%
			;WinActivate, Update ahk_id %idWin%

			;Gui, AccessCode:Hide
		return
	}

}