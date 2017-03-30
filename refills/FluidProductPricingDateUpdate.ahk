/**
 * File containing Refill class to facilitate updating multiple pricing dates on a product header
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
objRetype.refill( new FluidProductPricingDateUpdate() )


/**
 * Refill to automatically update X price-by-date effective and expiry dates
 *
 * @category	Automation
 * @package		ReTyPe
 * @author		Dominic Wrapson <hwulex[åt]gmail[dõt]com>
 * @copyright	2015 Dominic Wrapson
 */
class FluidProductPricingDateUpdate extends Fluid {


	strHotkey		:= "^!d"
	strMenuPath		:= "/Admin/Product"
	strMenuText		:= "Pricing Effective/Expiry Dates"
	intMenuIcon		:= 214


	/**
	 * Setup controls, window group, etc
	 */
	__New() {
		global objRetype
		base.__New()

		strGroup 	:= this.id
		strRTP		:= % objRetype.objRTP.classNN()
		GroupAdd, %strGroup%, Add ahk_class %strRTP%, Sales Report Group
		GroupAdd, %strGroup%, Update ahk_class %strRTP%, Sales Report Group
	}


	/**
	 * Where the magic happens
	 */
	pour() {
		global objRetype
		static intEffective 	:= 
		static intExpiration 	:= 
		static intIterate 		:= 1

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

				; Detect PriceType selection for how we update the pricing with keystrokes
				 ;WindowsForms10.COMBOBOX.app.0.30495d1_r11_ad18
				strControlListPricing := objRetype.objRTP.formatClassNN( "COMBOBOX", this.getConf( "PricingType", 18 ) )
				ControlGet, strSelected, Choice, , %strControlListPricing%, A
				; Check if we can actually find the pricing type combo, and exit with error if not
				if ( 0 = StrLen( strSelected ) ) {
					MsgBox.Stop( "Could not determine pricing type, exiting" )
				}

				; Only change if price-by-date
				if ( strSelected = "By Date") {

					intEffective	:= InputBox.Show( "New Effective date`n`nFormat: mm/dd/yyyy, or leave blank to skip" )
					intExpiration	:= InputBox.Show( "New Expiration date`n`nFormat: mm/dd/yyyy, or leave blank to skip" )
					intIterate 		:= InputBox.Show( "Update how many rows?", intIterate )

					Loop %intIterate%
					{
						Send {AppsKey}u
						if intEffective
						{
							objRetype.objRTP.dateInput( intEffective, 0 )
						}
						Send {Tab}
						if intExpiration
						{
							objRetype.objRTP.dateInput( intExpiration )
						}
						Send {Tab 6}{Space}
						Send {Down}
					}
				}

			}
		}
	}


}