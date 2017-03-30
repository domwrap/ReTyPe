/**
 * File containing Refill class to facilitate copying accounting on a product
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
objRetype.refill( new FluidProductAccountingCopy() )


/**
 * Refill to automatically copy earned and unearned accounting segments to override discount
 *
 * @category	Automation
 * @package		ReTyPe
 * @author		Dominic Wrapson <hwulex[åt]gmail[dõt]com>
 * @copyright	2015 Dominic Wrapson
 */
class FluidProductAccountingCopy extends Fluid {

	strHotkey		:= "^!a"
	strMenuPath		:= "/Admin/Product"
	strMenuText		:= "Accounting Copy"
	intMenuIcon		:= 167

	/**
	 * Setup controls, window group, etc
	 */
	__New() {
		global objRetype
		base.__New()

		strGroup 	:= this.id
		strRTP		:= % objRetype.objRTP.classNN()
		GroupAdd, %strGroup%, Accounting ahk_class %strRTP%, Revenue Business Unit
	}

	/**
	 * Where the magic happens
	 */
	pour() {
		global objRetype

		; Activate RTP (after toolbar has been clicked)
		objRetype.objRTP.Activate()
; @todo Check needs to be removed once I've managed to wall-in shortcuts in to the RTP only window
		; Run if it's ready!
		strGroup := this.__Class
		IfWinActive, ahk_group %strGroup%
		{
			; Did you execute from an RTP window?
			if ( objRetype.objRTP.isActive() ) {
				idWinRTP	:= WinActive("A")

				; New code which no longer uses clipboard
				; Loop through and build delimited string of accounting
				Loop 7
				{
					; Get ID of focused field (which must be first segment on row)
					ControlGetFocus, strControl, A
					; Get contents of that field
					ControlGetText, strSegment, %strControl%, A
					; Add to string store, with delimiting character
					strSegments := strSegments . strSegment . "|"
					; Move to next field
					Send {Tab}
					; rinse, repeat (inside loop)
				}

				; Move to first field of next set
				Send {Tab}

				; Loop through our now pipe-delimited clipboard text
				Loop, parse, strSegments, |
				{
					; Select all, clear field, paste in text, move to next
					Send ^a{BackSpace}%A_LoopField%{Tab}
				}

			}
		}
	}

}