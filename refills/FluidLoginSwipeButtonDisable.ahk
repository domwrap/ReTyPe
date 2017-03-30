/**
 * File containing Refill class to disable ENTER and OK buttons for swipe logins
 * Class will add itself to the parent retype instance
 *
 * AutoHotKey v1.1.13.01+
 *
 * LICENSE:
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Affero General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.

 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Affero General Public License for more details.

 * You should have received a copy of the GNU Affero General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 *
 * @category  	Automation
 * @package   	ReTyPe
 * @author    	Dominic Wrapson <dwrapson@whistlerblackcomb.com>
 * @copyright	Copyright (C) 2015 Dominic Wrapson
 * @license 	GNU AFFERO GENERAL PUBLIC LICENSE http://www.gnu.org/licenses/agpl-3.0.txt
 */


; Trigger my damn self (in a horrible way due to AHK limitations)
objRetype.refill( new FluidLoginSwipeButtonDisable() )


/**
 * Refill to disable ENTER and OK buttons for swipe logins
 *
 * @category	Automation
 * @package		ReTyPe
 * @author		Dominic Wrapson <dwrapson@whistlerblackcomb.com>
 * @copyright	2015 Dominic Wrapson
 */
class FluidLoginSwipeButtonDisable extends Fluid {

	intTimer := 100

	pour() {
		global objRetype

		; Create window group for places we want this hotkey active
		strGroup	:= this.__Class
		strRTP		:= % objRetype.objRTP.classNN()
		GroupAdd, %strGroup%, On-Screen Keyboard ahk_class %strRTP%, Login

		; On-Screen login keyboard is active
		IfWinActive, ahk_group %strGroup%
		{
			; Hide ENTER and OK buttons so they can't be used to manually enter logins
			Control, Hide, , Enter
			Control, Hide, , OK

			; Text control on the login page
			strControl := objRetype.objRTP.formatClassNN( "EDIT", this.getConf( "Login", 11 ) )
			; Get contents of text box
			ControlGetText, strLogin, %strControl%, A

			arrLogins := {111144: 1,222288: 1,336666: 1,443333: 1,444999: 1,555444: 1,866666: 1,888884: 1}
			if ( arrLogins.HasKey( strLogin ) ) {
				ControlFocus, %strControl%, A
				;SendInput {Enter}

				objRetype.arrHotKeys["FluidLoginSwipe"].pour()
			}

; Works but not necessary
; Disable asterisk masking
;SendMessage, 0x00cc, 0, 0, %strControl%
; Re-enable masking
;SendMessage, 0x00cc, 42, 0, %strControl%


; Works but not necessary
; Disable asterisk masking
;foo := this.Edit_IsStyle( strControl, 0x20 )
;msgbox.show( foo )
;this.Edit_SetPasswordChar( strControl, "*" )
;Msgbox.show( ErrorLevel )
;bar := this.Edit_IsStyle( strControl, 0x20 )
;msgbox.show( bar )
		}

	}


}
