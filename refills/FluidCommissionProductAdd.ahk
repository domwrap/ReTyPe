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
objRetype.refill( new FluidCommissionProductAdd() )


/**
 * Refill to automatically add multiple products to a commission class, or multiple commissions to a product
 *
 * @category	Automation
 * @package		ReTyPe
 * @author		Dominic Wrapson <dwrapson@whistlerblackcomb.com>
 * @copyright	2015 Dominic Wrapson
 */
class FluidCommissionProductAdd extends Fluid {

	strHotkey		:= "^!c"
	strMenuPath		:= "/Admin/Commission"
	strMenuText		:= "Commission Add"
	intMenuIcon		:= 29

	/**
	 * Where the magic happens
	 */
	pour() {
		global objRetype
		static intIterate := 1
		static intCommission := 25

		strGroup	:= this.__Class
		strRTP		:= % objRetype.objRTP.classNN()
		GroupAdd, %strGroup%, Create a Commission Class ahk_class %strRTP%
		GroupAdd, %strGroup%, Update ahk_class %strRTP%, Receipt Label
		GroupAdd, %strGroup%, Add Product Header ahk_class %strRTP% Receipt Label

		; Activate RTP (after toolbar has been clicked)
		objRetype.objRTP.Activate()

; @todo Check needs to be removed once I've managed to wall-in shortcuts in to the RTP only window
		; Run if it's ready!
		IfWinActive, ahk_group %strGroup%
		{
			; Did you execute from an RTP window?
			if ( objRetype.objRTP.isActive() ) {
				idWinRTP	:= WinActive("A")

				; Prompt for iteration count
				intIterate := InputBox.show( "How many products/commission classes?", intIterate )
				intCommission := InputBox.show( "What commission rate?", intCommission )

				Loop %intIterate%
				{
					this._updateCommission( intCommission )
				}

			}
		}
	}


	/**
	 * Function to update per-product commissions
	 */
	_updateCommission( intCommission, dtExpiry="12/31/2020", dtEffective=0 ) {
		global objRetype

	;MsgBox %dtEffective% %dtExpiry%
		; Date checking
		FormatTime, dtNow, %A_Now%, MM/dd/yyyy
		;FormatTime, dtExpiry, %dtExpiry%, MM/dd/yyyy
		;FormatTime, dtEffective, %dtEffective%, MM/dd/yyyy
		if !dtEffective
			dtEffective := dtNow
	;MsgBox %dtNow% %dtEffective% %dtExpiry%
	;	If dtExpiry < dtNow
	;	{
	;		MsgBox Expiry date %dtExpiry% is in the past.  Exiting.
	;		Exit
	;	}

		; Input the data
		Send {Tab}{Space}
		Sleep 100
		objRetype.objRTP.dateInput( dtEffective )
		Send {Tab}
		objRetype.objRTP.dateInput( dtExpiry )
		Send {Tab}%intCommission%
		Send {Tab 2}{Space}
		Send +{Tab}
		Send {Down}
	}

}