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
 * @category   UI
 * @package    ReTyPe
 * @author     Dominic Wrapson <hwulex[åt]gmail[dõt]com>
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
; Ensure title match mode set
SetTitleMatchMode, 1

#Include %A_ScriptDir%
#Include lib_ahk\debug.ahk
#Include lib\retype.ahk
; This include must be last as it changes the include path
#Include %A_ScriptDir%\refills\_fluid.ahk


; SysTray and menu config
Menu, tray, NoStandard
Menu, tray, icon, %A_ScriptDir%\retype.ico, , 1
Menu, Tray, Tip, ReTyPe
Menu, tray, add, &Reload, fnReload
Menu, tray, add, &About, fnAbout
Menu, tray, add  ; Creates a separator line.
Menu, tray, add, E&xit, fnExit


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
}
; This include is actually evaluated before any other code (all Include commands are)
; meaning that if you change the name of a refill, you must empty the existing file
; rather than deleting it else it will try to be included before it is created
; The first execution after an empty refills.ahk will be broken as it would have
; been included empty.  The second execution will work as expected as the file will
; have been populated with the correct files on execution one.  Comprendes?
#Include %A_ScriptDir%\refills.ahk


; Make stuff happen!
objRetype.go()

Return

fnAbout:
	MsgBox % "ReTyPe`nRTP: Emending Your Errors`n`n" . chr(169) . " Dominic Wrapson, 2014"
return

fnReload:
	Reload
return

fnExit:
	ExitApp
return