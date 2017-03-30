/**
 * File containing Refill class to facilitate updating multiple pricing rows on a product header
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
objRetype.refill( new FluidProductPricingUpdate() )


/**
 * Refill to automatically update X pricing rows on a product header
 *
 * @category	Automation
 * @package		ReTyPe
 * @author		Dominic Wrapson <dwrapson@whistlerblackcomb.com>
 * @copyright	2015 Dominic Wrapson
 */
class FluidProductPricingUpdate extends Fluid {


	strHotkey		:= "^!u"
	strMenuPath		:= "/Admin/Product"
	strMenuText		:= "Pricing Update"
	intMenuIcon		:= 147


	/**
	 * Where the magic happens
	 */
	pour() {
		global objRetype
		static intIterate := 1

		strGroup	:= this.__Class
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

				; Are we in the pricing tab of a product header?
				if ( Window.CheckVisibleTextContains( "sales report group", "pricing" ) ) {
					; Check which control has focus.  If it's not the pricing ListView then don't proceed
					if ( Window.CheckControlFocus( objRetype.objRTP.formatClassNN( "SysListView32", this.getConf( "PricingList", 11 ) ), "Pricing ListView" ) ) {

						; Detect PriceType selection for how we update the pricing with keystrokes
						 ;WindowsForms10.COMBOBOX.app.0.30495d1_r11_ad18
						strControlListPricing := objRetype.objRTP.formatClassNN( "COMBOBOX", this.getConf( "PricingType", 18 ) )
						ControlGet, strSelected, Choice, , %strControlListPricing%, A
						; Check if we can actually find the pricing type combo, and exit with error if not
						if ( 0 = StrLen( strSelected ) ) {
							MsgBox.Stop( "Could not determine pricing type, exiting" )
						}

						; Prompt for iteration count
						intPrice := InputBox.Show( "What's the NEW price?", 9999 )
						intIterate := InputBox.Show( "How many rows are we updating?", intIterate )

						; Loop around the specified number of times
						Loop %intIterate%
						{
							; Select row in ListView, right-click, choose Update
							SendInput {Space}{AppsKey}u
							; Wait for Pricing update window to load, max of 2 seconds then continue
							WinWait, Pricing, , 5
							; Send extra tabs for price by date
							if ( strSelected = "By Date") {
								SendInput {Tab 2}
							}
							; Send the new price for both unit and price
							SendInput %intPrice%{Tab}%intPrice%
							; Get to OK button, press it, move down a row
							SendInput {Tab 4}{space}{Down}
						}
					}
				}
			}
		}
	}


}