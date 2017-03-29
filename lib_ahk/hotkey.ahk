/**
 * File containing class for registering hotkeys in ReTyPe framework
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
 * Class that registers hotkeys for Fluid objects
 *
 * @category	Automation
 * @package		ReTyPe
 * @author		Dominic Wrapson <dwrapson@whistlerblackcomb.com>
 * @copyright	2014 Dominic Wrapson
 */
class Hotkey {

	; Solution implemented from this reference
	; @see http://stackoverflow.com/questions/12851677/dynamically-create-autohotkey-hotkey-to-function-subroutine
	add(objFluid, arg*) {
		If ( InStr( objFluid.strHotkey, "," ) ) {
			strHotkey := objFluid.strHotkey
			Loop, Parse, strHotkey, `,
			{
				objFluid.strHotkey := A_LoopField
				this.add( objFluid, "" )
			}
		} else {
			; Define class properties to work with label below
			Static funs := {}, args := {}
			; populate properties with method parameters
			funs[objFluid.strHotkey] := objFluid.id, args[objFluid.strHotkey] := arg
			; Restrict hotkey to group of windows as defined in objFluid constructor
			;strGroup := objFluid.id
	; @TODO Figure out how to restrict hotkeys to their window groups, also @see _fluid.ahk
			;Hotkey, IfWinActive ahk_group %strGroup%
	;#If WinActive( "ahk_group " strGroup )
			;#IfWinActive, ahk_group %strGroup%
			; Define hotkey with single-access label
			Hotkey, % objFluid.strHotkey, Hotkey_Handle
			; reset hotkey context in case one was set before call
			Hotkey, IfWinActive
			;#IfWinActive
	;#If
		}

		; get out now before label
		return

		; labels are defined at run-time so this is still found,
		; and better yet kept within class namespace
		Hotkey_Handle:
; @todo BLOCK INPUT!
; Consider inputbox and msgbox when blocking input else user
; may not be able to do anything with them when blocked

; @todo #UseHook On
; http://www.autohotkey.com/docs/commands/_UseHook.htm
; This may help me have a global-abort

; @todo Implement global-abort

			; Execute desired hotkey
			; ...
			; Grab object from array
			obj := funs[A_ThisHotkey]
			; Construct params object with object as first parameter to enable
			; instance based method calls (otherwise can only call static)
			arg := [ %obj%, args[A_ThisHotkey] ]
			; Call the instance method on the object with (empty) params
			; that contains copy of the object on which you are making
			; the call (so in otherwords, you're passing $this)
			%obj%["pour"].( arg* )

; @todo UNBLOCK input
		Return
	}

}