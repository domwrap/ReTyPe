/**
 * ReTyPe
 * RTP: Emending Your Errors
 *
 * AHK script that creates a Toolbar within the active RTP Window's titlebar
 *
 * Buttons on the toolbar are used to access sub-menus, from which each option
 * will execute an automation script (or some such)
 * The scripts run from menus are (mostly) just UI accessors to macros already
 * accessible by keystrokes
 *
 * USE THIS SCRIPT AND THESE MACROS AT YOUR OWN RISK!
 * Understand that this only emulates keystrokes and that in RTP {Enter} is SAVE so
 * _always_ use alternatives {Tab}{Space} where possible
 *
 * ALWAYS test your scripts on a Training environment before running on Live
 *
 * For scripting help, see http://www.autohotkey.com/docs/
 * For help with hotkeys and modifiers http://www.autohotkey.com/docs/Hotkeys.htm
 *
 * AutoHotKey v1.1.13.01+
 *
 * LICENSE: This work is licensed under a version 4.0 of the
 * Creative Commons Attribution-ShareAlike 4.0 International License
 * that is available through the world-wide-web at the following URI:
 * http://creativecommons.org/licenses/by-sa/4.0/deed.en_US
 *
 * @category   UI
 * @package    ReTyPe
 * @author     Dominic Wrapson <dwrapson@whistlerblackcomb.com>
 * @copyright  2014 Dominic Wrapson
 * @license    Creative Commons Attribution-ShareAlike 4.0 International License http://creativecommons.org/licenses/by-sa/4.0/deed.en_US
 */
 

; Avoids checking empty variables to see if they are environment variables (recommended for all new scripts).
#NoEnv
; Stick around after initial execution
#Persistent
; Only allow one copy to run at once.  More would be bad
#SingleInstance Force

#Include lib\debug.ahk
; This include must be last as it changes the include path
#Include lib\retype.ahk


; UI changes
Menu, tray, icon, retype.ico
Menu, Tray, Tip, ReTyPe


; Build the retype!
objRetype := new Retype()

; #Include can't recurse or accept loop parameters (apparently?!)
; Therefore we must iterate the refill dir, and append each
; filename to an refills.ahk file, which is then included here
; Not forgetting first we've got to delete the old copy.
; I would love to have this code within the Retype::__New() method
; but apparently defining a new class whilst still technically
; defining one isn't liked very much by AHK
FileDelete, %A_ScriptDir%\refills.ahk
Loop, %A_ScriptDir%\refills\*.ahk
{
	FileAppend, #Include refills\%A_LoopFileName%`n, %A_ScriptDir%\refills.ahk
}
#Include %A_ScriptDir%\refills.ahk

; Make stuff happen!
objRetype.go()
