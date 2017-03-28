/**
 * File containing Refill class to facilitate bulk-pricing product headers
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
objRetype.refill( new FluidProductPricingBulkUpdate() )


/**
 * Refill to automatically update X pricing rows in bulk pricing
 *
 * @category	Automation
 * @package		ReTyPe
 * @author		Dominic Wrapson <dwrapson@whistlerblackcomb.com>
 * @copyright	2015 Dominic Wrapson
 */
class FluidProductPricingBulkUpdate extends Fluid {


	strHotkey		:= "^!p"
	strMenuPath		:= "/Admin/Product"
	strMenuText		:= "Bulk Pricing Update"
	intMenuIcon		:= 306


	/**
	 * Setup controls, window group, etc
	 */
	__New() {
		global objRetype
		base.__New()

		strGroup 	:= this.id
		strRTP		:= % objRetype.objRTP.classNN()
		GroupAdd, %strGroup%, Product Header Pricing Bulk Update ahk_class %strRTP%
	}


	/**
	 * Where the magic happens
	 * @param bool blnDown Determines whether we move down X rows after updating pricing (useful when there's components to skip, like P2P)
	 */
	pour( blnDown=false ) {
		global objRetype
		static intIterate := 3

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

				; Check they user is only trying to delete list items
				ControlGetFocus, strControlFocus
				if ( !InStr( strControlFocus, "Window.8" ) ) {
					MsgBox.stop( "Bulk Pricing: Prices listview must be active" )
				}

				intPrice := InputBox.show( "What's the NEW product price?", 9999 )
				intIterate := InputBox.show( "How many components are we updating?", intIterate )
; @todo: Calculate how many rows are remaining to use as default value by doing
; remaining = listviewrows - listviewposition
; @todo: If a high-number entered (>10), ask "Are you sure, you crazy bitch?"

				; Get us to the pricing entry for selected row
				Send ^{Space 2}{Right 6}

				; Go around X times
				Loop %intIterate%
				{
					; Send the entered price
					SendInput %intPrice%
					; Move down a line
					SendInput {Down}
				}

				; Extra condition in place for extended (Child) class which does exactly the same thing, but then moves down X rows after the last price change
				; Which is (was) useful for skipping things like P2P pricing
				if ( true=blnDown ) {
					SendInput {Down %intIterate%}
				}

				SendInput {Left 2}
			}
		}
	}


}