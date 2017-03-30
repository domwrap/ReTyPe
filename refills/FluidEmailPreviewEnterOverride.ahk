/**
 * File containing Refill class to improve email preview Ux
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
 * @author		Dominic Wrapson <dwrapson@whistlerblackcomb.com>
 * @copyright	2014 Dominic Wrapson
 * @license		GNU AFFERO GENERAL PUBLIC LICENSE Version 3, 19 November 2007 http://www.gnu.org/licenses/
 */


; Trigger my damn self (in a horrible way due to AHK limitations)
objRetype.refill( new FluidEmailPreviewEnterOverride() )


/**
 * Refill to prevent RTP auto-sending an email every time enter key is pressed in email preview
 * Ux. We've heard of it!
 *
 * @category	Automation
 * @package		ReTyPe
 * @author		Dominic Wrapson <dwrapson@whistlerblackcomb.com>
 * @copyright	2015 Dominic Wrapson
 */
class FluidEmailPreviewEnterOverride extends Fluid {

	strHotkey		:= "$Enter"
	strMenuPath		:= ""
	strMenuText		:= ""
	intMenuIcon		:= ""

	/**
	 * Where the magic happens
	 */
	pour() {
		global objRetype

		strGroup	:= this.__Class
		strRTP		:= % objRetype.objRTP.classNN()
		GroupAdd, %strGroup%, Send Email ahk_class %strRTP%, PDF attachment

		; Only run if we're in the appropriate window
		IfWinActive, ahk_group %strGroup%
		{
			; Did you execute from an RTP window?
			if ( objRetype.objRTP.isActive() ) {
				idWinRTP	:= WinActive("A")

				; Clipboard manipulation a-go-go!
				; I attempted several different ways to get a carriage-return in to
				; the email preview window, each one was immediately interpreted
				; by RTP as an ENTER command and would attempt to send the email.
				; The only way I could get it to work manually was to paste a CRLF
				; from notepad in to the editor, so that's exactly what I do here.
				; Clipboard is preserved through temp var either side of sending
				; the CRLF through the clipboard

				; Store current clipboard in temp var
				var := clipboard
				; Overwrite clipboard with CRLF
				clipboard = `r`n
				; Paste the clipboard in to the editor
				Send ^v
				; Restore previously stored contents back in to the clipboard
				; so process is invisible to the end-user
				clipboard := var
			} else {
				; If we're not in RTP, continue with regular enter
				Send {Enter}
				;Send Nope1{Enter}
			}
		} else {
			; If we're not in RTP, continue with regular enter
			Send {Enter}
			;Send Nope2{Enter}
		}
	}

}