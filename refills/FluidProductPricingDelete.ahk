/**
 * File containing Refill class to facilitate deleting multiple pricing rows from a product header
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
objRetype.refill( new FluidProductPricingDelete() )


/**
 * Refill to automatically delete X pricing rows from a product header
 *
 * @category	Automation
 * @package		ReTyPe
 * @author		Dominic Wrapson <dwrapson@whistlerblackcomb.com>
 * @copyright	2015 Dominic Wrapson
 */
class FluidProductPricingDelete extends Fluid {

	strHotkey		:= "^!+x"
	strMenuPath		:= "/Admin/Product"
	strMenuText		:= "Pricing Delete"
	intMenuIcon		:= 132 ;272

	/**
	 * Where the magic happens
	 */
	pour() {
		global objRetype
		static intIterate := 1

		; Add current RTP instance to group
		strGroup 	:= this.__Class
		strRTP		:= % objRetype.objRTP.classNN()
		GroupAdd, %strGroup%, Add ahk_class %strRTP%, Sales Report Group
		GroupAdd, %strGroup%, Update ahk_class %strRTP%, Sales Report Group

		; Activate RTP (after toolbar has been clicked)
		objRetype.objRTP.Activate()
; @todo Check needs to be removed once I've managed to wall-in shortcuts in to the RTP only window
		; Run if it's ready!
		IfWinActive, ahk_group %strGroup%
		{
			; Did you execute from an RTP window?
			if ( objRetype.objRTP.isActive() ) {
				idWinRTP	:= WinActive("A")

				; Check which control has focus.  If it's not the pricing ListView then don't proceed
				if ( Window.CheckControlFocus( objRetype.objRTP.formatClassNN( "SysListView32", this.getConf( "ListPricing", 11 ) ), "Pricing ListView" ) ) {
					ControlGetFocus, strControlFocus

					; Prompt for iteration count
					intIterate := InputBox.show( "How many pricing entries do you wish to delete?`n`nEnter ALL to delete all remaining entries`nEnter DOWN to delete everything beneath selected row", 1 )
					; Allow entering ALL to delete all remaining items in the listview
					if ( "ALL" = intIterate ) {
						; Get how many are left
						ControlGet, intItems, List, Count, %strControlFocus%, A
						; Set the iteration to row total
						intIterate := intItems
						Sleep 200
					}
					if ( "DOWN" = intIterate ) {
						ControlGet, intItems, List, Count, %strControlFocus%, A
						ControlGet, intPos, List, Count Focused, %strControlFocus%, A
						intIterate := intItems - intPos + 1
						Sleep 100
						; listitems - listposn
					}
					; Input validation
					If intIterate not between 1 and 999
					{
						MsgBox.Stop( "You must enter a numerical value between 1 and 999.`n`nYou entered: " . intIterate )
					}
					; Confirmation message for massive delete requests
					if ( 10 < intIterate ) {
						MsgBox.YesNo( "You've asked to delete [" . intIterate . "] entries which seems like a lot. Continue?" )
						IfMsgBox, No
							return
					}

					; If we made it this far, let's nuke some stuff
					Loop %intIterate%
					{
						WinActivate, ahk_id %idWinRTP%
						SendInput {Space}{AppsKey}d{Space}
					}
				}
			}
		}
	}

}
