/**
 * File containing Refill class to facilitate updating multiple expiry dates on discounts
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
objRetype.refill( new FluidProductDiscountUpdate() )


/**
 * Refill to automatically update X expiry dates on discounts
 *
 * @category	Automation
 * @package		ReTyPe
 * @author		Dominic Wrapson <hwulex[åt]gmail[dõt]com>
 * @copyright	2015 Dominic Wrapson
 */
class FluidProductDiscountUpdate extends Fluid {


	strHotkey		:= "^!g"
	strMenuPath		:= "/Admin/Discount"
	strMenuText		:= "Discount Update"
	intMenuIcon		:= 214


	/**
	 * Setup controls, window group, etc
	 */
	__New() {
		global objRetype
		base.__New()

		strGroup 	:= this.id
		strRTP		:= % objRetype.objRTP.classNN()
		GroupAdd, %strGroup%, Add A Discount ahk_class %strRTP%, Added Product Discounts
		GroupAdd, %strGroup%, Update ahk_class %strRTP%, Added Product Discounts
	}


	/**
	 * Where the magic happens
	 */
	pour() {
		global objRetype
		; Static variable that maintains its value between executions, so can be used as the new default value in the Iterate prompt
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

				; Check that appropriate form control is focused before continuing
				strControlList := objRetype.objRTP.formatClassNN( "SysListView32", this.getConf( "ListDiscountProducts", 11 ) )
				if ( Window.CheckControlFocus( strControlList, "Add Product Discounts listview" ) ) {
					; Prompt for new date, and qty to change
					intExpiration 	:= InputBox.Show( "New expiration date`n`nFormat: mm/dd/yyyy, or BLANK to skip" )
					intDiscount 	:= InputBox.Show( "New discount amount`n`nBLANK to skip" )
					intMethod 		:= InputBox.Show( "Calculation method?`n`n[1=Fixed/2=Percent/BLANK to skip]" )
					intIterate 		:= InputBox.Show( "Update how many rows?", intIterate )

					; Input validation before proceeding
					if ( !intExpiration && !intDiscount && !intMethod ) {
						MsgBox.stop( "No input for Expiration, Amount, or Method. Please specify any or all")
					}

					; Loop X times and change expiration dates
					Loop %intIterate%
					{
						; Re-activate most recently active window in the group (the one in which we're meant to be working) in case user clicked away
						GroupActivate, %strGroup%, R

						; Open Update dialog
						Send {Tab 2}{space}
						; If set, update Expiration
						if ( intExpiration ) {
							objRetype.objRTP.dateInput( intExpiration )
						}
						; Move to Amount field
						Send {Tab}
						; If set, update discount amount
						if ( intDiscount ) {
							Send ^a%intDiscount%
						}
						; Move to method combo box
						Send {Tab}
						; If set, update method
						if ( intMethod = 1 ) {
							Send {Up}
						} else if ( intMethod = 2 ) {
							Send {Down}
						}
						; Move to Update button and press
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
						; Move back to listview, and shift it down a row
						Send +{Tab 2}{Down}
					}

				}
 
			}
		}
	}


}