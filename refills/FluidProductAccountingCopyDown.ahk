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
 * @author		Dominic Wrapson <dwrapson@whistlerblackcomb.com>
 * @copyright	2014 Dominic Wrapson
 * @license		GNU AFFERO GENERAL PUBLIC LICENSE Version 3, 19 November 2007 http://www.gnu.org/licenses/
 */


; Trigger my damn self (in a horrible way due to AHK limitations)
objRetype.refill( new FluidProductAccountingCopyDown() )


/**
 * Refill to automatically copy earned and unearned accounting segments to following segments X times
 *
 * @category	Automation
 * @package		ReTyPe
 * @author		Dominic Wrapson <dwrapson@whistlerblackcomb.com>
 * @copyright	2015 Dominic Wrapson
 */
class FluidProductAccountingCopyDown extends Fluid {

	strHotkey		:= "^!+a"
	strMenuPath		:= "/Admin/Product"
	strMenuText		:= "Accounting Copy Down"
	intMenuIcon		:= 167 ; 151

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
		static intIterate := 3

		; Activate RTP (after toolbar has been clicked)
		objRetype.objRTP.Activate()
; @todo Check needs to be removed once I've managed to wall-in shortcuts in to the RTP only window
		; Run if it's ready!
		strGroup := this.__Class
		IfWinActive, ahk_group %strGroup%
		{
			; Clear segment store
			strSegments := 

			; How many times we copying?
			intIterate := InputBox.show( "Duplicate this row how many times down (not including the source line)?`n`nFocus must be in left-most segment.", intIterate )

			; Loop through and build delimited string of accounting
			Loop 3
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

			Loop %intIterate%
			{
				; Loop through our now pipe-delimited clipboard text
				Loop, parse, strSegments, |
				{
					; Select all, clear field, paste in text, move to next
					Send ^a{BackSpace}%A_LoopField%{Tab}
				}
			}

			; Restore clipboard to previous value
			;Clipboard := mixStore
		}
	}

}