/**
 * File containing Refill class to facilitate cloning product discounts
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
objRetype.refill( new FluidProductDiscountClone() )


/**
 * Refill to automatically clone X product discounts
 *
 * @category	Automation
 * @package		ReTyPe
 * @author		Dominic Wrapson <dwrapson@whistlerblackcomb.com>
 * @copyright	2015 Dominic Wrapson
 */
class FluidProductDiscountClone extends Fluid {


	strHotkey		:= "^!+g"
	strMenuPath		:= "/Admin/Discount"
	strMenuText		:= "Discount Clone"
	intMenuIcon		:= 66

	/**
	 * Where the magic happens
	 */
	pour() {
		global objRetype
		static intEffective 	:= 
		static intExpiration 	:= 
		static intIterate 		:= 1

		strGroup	:= this.__Class
		strRTP		:= % objRetype.objRTP.classNN()
		GroupAdd, %strGroup%, Add A Discount ahk_class %strRTP%, Added Product Discounts
		GroupAdd, %strGroup%, Update ahk_class %strRTP%, Added Product Discounts

		; Activate RTP (after toolbar has been clicked)
		objRetype.objRTP.Activate()

; @todo Check needs to be removed once I've managed to wall-in shortcuts in to the RTP only window
		; Run if it's ready!
		IfWinActive, ahk_group %strGroup%
		{
			; Did you execute from an RTP window?
			if ( objRetype.objRTP.isActive() ) {
				idWinRTP	:= WinActive("A")

				; Check that appropriate form control is focused before continuing
				strControlList := objRetype.objRTP.formatClassNN( "SysListView32", this.getConf( "ListDiscountProducts", 11 ) )
				if ( Window.CheckControlFocus( strControlList, "Add Product Discounts listview" ) ) {
					; Prompt for input parameters
					intEffective	:= InputBox.Show( "Effective date`n`nFormat: mm/dd/yyyy", intEffective )
					intExpiration	:= InputBox.Show( "Expiration date`n`nFormat: mm/dd/yyyy", intExpiration )
					intDiscount 	:= InputBox.Show( "Discount value?`n`n(Leave BLANK to clone)" )
					intMethod 		:= InputBox.Show( "Calculation method?`n`n(1=Fixed/2=Percent/BLANK to clone existing)" )
					intIterate 		:= InputBox.Show( "Clone how many discounts?", intIterate )

					; Input validation before proceeding
					if ( !intEffective && !intExpiration ) {
						MsgBox.stop( "You must specify Effective Date and Expiration Date")
					}

					Loop %intIterate%
					{
						; Re-activate most recently active window in the group (the one in which we're meant to be working) in case user clicked away
						GroupActivate, %strGroup%, R

						; Open copy window
						Send {Tab}{space}
						; Move to effective input
						Send {Tab}
						; Enter user-defined effective date
						objRetype.objRTP.dateInput( intEffective )
						; Move to expiry input
						Send {Tab}
						; Enter user-defined expiry date
						objRetype.objRTP.dateInput( intExpiration )
						; Move to discount Amount
						Send {Tab}
						if ( intDiscount )
						{
							; Select all existing text, and overwrite
							Send ^a%intDiscount%
						}
						Send {Tab}
						; Choose appropriate discount method
						if ( intMethod = 1 ) {
							Send {Up}
						} else if ( intMethod = 2 ) {
							Send {Down}
						}
						; Move to Update button and press it
						Send {Tab}{Space}

						; RTP might chuck an error if dates overlap, so deal with it
						if (  WinActive( "Alert", "overlapping date range") ) {
							; Prompt user if they want to ignore and keep going, or exit
							MsgBox.yesno( "Error encountered, skip and continue?" )
							IfMsgBox, Yes
							{
								; Focus the error box and close it
								WinActivate, Alert, overlapping date range
								ControlClick, OK
							} else {
								; User opts-out, so quit
								return
							}
						}

						; Now back on parent window, shift+tab back to lsit view and move down a row
						Send +{Tab}{Down}
					}

				}
 

			}
		}
	}


}