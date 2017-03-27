/**
 * File containing class for registering hotkeys in ReTyPe framework
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
		; Define class properties to work with label below
		Static funs := {}, args := {}
		; populate properties with method parameters
		funs[objFluid.hotkey] := objFluid.id, args[objFluid.hotkey] := arg
		; Define hotkey with single-access label
		Hotkey, % objFluid.hotkey, Hotkey_Handle
		; reset hotkey context in case one was set before call
		Hotkey, IfWinActive
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