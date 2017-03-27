/**
 * ReTyPe
 * RTP: Emending Your Errors
 *
 * AHK-written software that creates a toolbar within the active RTP Window's titlebar to activate various UI changes and automation
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
; Ensure coord mode correct
CoordMode, Pixel, Relative

#Include %A_ScriptDir%
#Include lib_ahk\debug.ahk
#Include lib\retype.ahk
; This include must be last as it changes the include path
#Include %A_ScriptDir%\refills\_fluid.ahk


; UI changes
Menu, tray, icon, %A_ScriptDir%\retype.ico, , 1
Menu, Tray, Tip, ReTyPe
;Menu, tray, NoStandard
;Menu, tray, add, RetypeExit


; Build the retype!
objRetype := new Retype()

; Only do all the following if we're not compiled
if ( !A_IsCompiled ) {
	; #Include can't recurse or accept loop parameters (apparently?!)
	; Therefore we must iterate the refill dir, and append each
	; filename to an refills.ahk file, which is then included here
	; Not forgetting first we've got to delete the old copy.
	; I would love to have this code within the Retype::__New() method
	; but apparently defining a new class whilst still technically
	; defining one isn't liked very much by AHK
	; @see http://ahkscript.org/docs/commands/LoopFile.htm
	; @todo change to File object? http://ahkscript.org/docs/commands/FileOpen.htm
	FileDelete, %A_ScriptDir%\refills.ahk
	FileAppend, #Include %A_ScriptDir%`n, %A_ScriptDir%\refills.ahk
	Loop, %A_ScriptDir%\refills\*.ahk
	{
		FileAppend, #Include refills\%A_LoopFileName%`n, %A_ScriptDir%\refills.ahk
	}
	; This include is actually evaluated before any other code (all Include commands are)
	; meaning that if you change the name of a refill, you must empty the existing file
	; rather than deleting it else it will try to be included before it is created
	; The first execution after an empty refills.ahk will be broken as it would have
	; been included empty.  The second execution will work as expected as the file will
	; have been populated with the correct files on execution one.  Comprendes?
	#Include %A_ScriptDir%\refills.ahk
}

; Make stuff happen!
objRetype.go()
