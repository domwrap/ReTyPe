/**
 * Here be object for facilitating message popup boxes
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

#Include %A_ScriptDir%\lib_ahk\mgbox.ahk

 /**
 * ReTyPe extension of library MgBox class
 * Also does some fancy stuff to center the message against the parent window, which
 *		is particilarly nice on 39" 4K screens like we use as small windows are easily lost
 *
 * @category	Automation
 * @package		ReTyPe
 * @author		Dominic Wrapson <hwulex[åt]gmail[dõt]com>
 * @copyright	2014 Dominic Wrapson
 */
class MsgBox extends MgBox {

	static strFileConf	:= A_AppData "\ReTyPe\app.ini"

	/**
	 * Shows a message box
	 * Over-rides parent method so we can insert onMessage to centre msgbox within parent RTP window
	 */
	show( strMessage, intType=0, strTitle="", intTimeout=0 ) {
		; Some pre-built stuff
		this.p_conf()

		; Build title
		strTitle := ( 0 < StrLen( strTitle ) ) ? this.strTitle ": " strTitle : this.strTitle
		; Allows repositioning of msgbox
		OnMessage(0x44, "WM_COMMNOTIFY")

		; Make popups always on top
		intType += 4096

		; Show the actual box
		MsgBox, % intType, %strTitle%, % strMessage	
		return ErrorLevel
	}

}

/**
 * Allows MsgBox to be moved from center of screen to center of parent window
 */
WM_COMMNOTIFY(wParam) {
	global objRetype

    if (wParam = 1027) { ; AHK_DIALOG
        Process, Exist
        DetectHiddenWindows, On
        if WinExist("ahk_class #32770 ahk_pid " . ErrorLevel) {
            WinGetPos,,,w,h
			intX := objRetype.objRTP.getPos("X") + ( objRetype.objRTP.getPos("W") / 2 ) - ( w / 2 )
			intY := objRetype.objRTP.getPos("Y") + ( objRetype.objRTP.getPos("H") / 2 ) - ( h / 2 )
            WinMove, %intX%, %intY%
        }
    }
}