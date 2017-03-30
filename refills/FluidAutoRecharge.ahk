/**
 * File containing Refill class to automate recharges in RTP ONE|Resort
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
objRetype.refill( new FluidAutoRecharge() )


/**
 * Refill to automate recharges in RTP ONE|Resort
 *
 * @category	Automation
 * @package		ReTyPe
 * @author		Dominic Wrapson <hwulex[åt]gmail[dõt]com>
 * @copyright	2014 Dominic Wrapson
 */
class FluidAutoRecharge extends Fluid {
; @todo Make generic commenting class (with prompt), and extend to pass admin / config file editable sub-class

	;strHotkey		:= "^!+c"
	strMenuPath		:= "/OneResort"
	strMenuText		:= "Auto Recharge"
	intMenuIcon		:= 166

	/**
	 * Setup controls, window group, etc
	 */
	__New() {
		global objRetype
		base.__New()

		strRTP		:= % objRetype.objRTP.classNN()
		strGroup	:= this.id

		GroupAdd, %strGroup%, ahk_class %strRTP%
	}

	/**
	 * 
	 */
	pour() {
		global objRetype

		; Activate RTP (after toolbar has been clicked)
		objRTP := objRetype.objRTP
		objRTP.Activate()

		strGroup := this.__Class
		IfWinActive, ahk_group %strGroup%
		{
			; Get IP code input
			intIP := InputBox.show( "Enter IP code for which to search" )

			; Find auto-recharge link and open
			this.windowRechargeOpen()
			; Search by IP
			this.findRecharge( intIP )
		}
	}

	/**
	 * Open recharge window in ONE|Resort
	 * @return void
	 */
	 windowRechargeOpen() {
		global objRetype

		; Stop user from messing everything up whilst executing
		;BlockInput, On
		; BEFORE ENABLING: make _MsgBox function that automatically turns BlockInput Off

		; Autocharge search
		;_windowActivateRestore( idWinRTP )
		; Thanks to RTP's AMAZING design, you can actually activate the
		; ONE|Resort Tools from ANY software tab making this check unecessary
		; AS LONG AS ONE|Resort has been loaded once, which is the default
		; startup page for most clients, so shouldn't be an issue
		;_rtpWindowCheck( "ONE|Resort" )
		;if ErrorLevel
			;return

; @todo Actually we do need to be in ONE|Resort for recharge as if charges are found and added to transaction, we want to be able to see this happening.
; Also only in Sales Tran can we actually activate the payment method and amount
; We could then switch only IF we find charges and add them, at that point attempt to switch manually, otherwise prompt to move to ONE|Resort

		; This is really horrible and slow, but the element IDs are not persistent through RTP instances so we haveth no choice!
		Loop {
			objRetype.objRTP.Activate()
			strControl := Window.getControlFromContents( "Autocharge Recovery", objRetype.objRTP.getID() )
			if ErrorLevel
			{
				MsgBox.tryagain( "Failed to find AutoCharge Recovery button, this is usually because ONE|Resort has not been loaded`n`nWould you like to`n[Cancel]`t`tQuit`n[Try Again]`tLoad ONE|Resort manually and retry`n[Continue]`tAttempt to automatically resolve this issue" )
				IfMsgBox, Cancel
					Exit
				IfMsgBox, TryAgain
					continue
				IfMsgBox, Continue
				{
					objRTP.WindowSwitch( "ONE|Resort" )
; @todo Some kind of a message here to say we're waiting
					Sleep 10000
					if ErrorLevel
					{
						MsgBox.retry( "Failed to automatically switch windows.`nPlease load ONE|Resort manually and press Retry, or cancel to quit" )
						IfMsgBox, Retry
							continue
						IfMsgBox, Cancel
							Exit
					}
				}
			}

			ControlFocus, strControl, A
			SendInput, {Enter}
			WinWait, AutoCharge Recovery,,10
			If ErrorLevel
			{
				MsgBox.retry( "Script timed out waiting for AutoCharge Recovery window to load. Retry?" )
				IfMsgBox, Cancel
					Exit
				IfMsgBox, Retry
					Continue
			}
			break
		}
	 }

	 findRecharge( intIP ) {
	 	global objRetype
; @todo PROGRESS bar dialogue and input locking
; @see rtp.CustomerSearchAndSelect

		WinWaitActive, AutoCharge Recovery,,3
		if ( 0 != ErrorLevel ) {
			Msgbox.stop( "AutoCharge Recovery taking too long to load, exiting")
		}

	 	idACR := WinExist( "AutoCharge Recovery" )

		; Set focus to search text box
		strEditSearch := objRetype.objRTP.formatClassNN( "EDIT", this.getConf( "EditSearch", 11 ) )
		ControlFocus, %strEditSearch%, ahk_id %idACR%
		Send %intIP%{Enter}

		; Catch not-found error
		WinWaitNotActive, AutoCharge Recovery,,3
		if ( 0 = ErrorLevel ) {
			; Eventuality detection
			If ( WinExist( ,"Customer not found" ) ) {
; @todo Change {space} to ControlClick
				Send {Space}
				ControlClick, Cancel, A
				MsgBox.stop( "Customer not found. Automation halted" )
			} else if ( WinExist( "Search Results", "Your Quick Search returned" ) ) {
				Send {Space}
				ControlClick, Cancel, A
				MsgBox.stop( "Ambiguous search term, more than one result returned. Please only search by unique IP Code. Automation halted" )
			} else if ( WinExist( ,"No failed autocharges" ) ) {
				Send {Space}
				ControlClick, Cancel, A
				MsgBox.stop( "No failed autocharges were found for the selected customer. Automation halted" )
			} else {
				Msgbox.error( "Unknown fork in logic" )
				exit
			}
		}
		; Otherwise we found some stuff, keep on trucking!

		; Charges list control
		strListResult := objRetype.objRTP.formatClassNN( "SysListView32", this.getConf( "ListResult", 11 ) )

		; Check to see if charges open on another client
		ControlGet, strList, List, , %strListResult%, ahk_id %idACR%
		IfInString, strList, Client
		{
			; Leave out Cancel click until can pick out client info to display with error message
			;ControlClick, Cancel
			MsgBox.stop( "Charges already being recovered on another client")
		}

		; Otherwise focus charges list and select all avaialble
		ControlFocus, %strListResult%, ahk_id %idACR%
		Send {Home}+{End}

		; Open charges in Sales Transaction
		ControlClick, OK

		/* ===== No need to get this complicated, we'll just use the QuickPayment option as requested by Kristen @ PassAdmin

		; Switch to Payment tab
		Sleep 500
	 	idRTP := objRetype.objRTP.getID()
		strTabPayment := objRetype.objRTP.formatClassNN( "SysTabControl32", this.getConf( "TabPayment", 11 ) )
		SendMessage, 0x1330, 3,, %strTabPayment%, ahk_id %idRTP% ; 0x1330 is TCM_SETCURFOCUS

		; Select payment type Credit Card
		strListPayment := objRetype.objRTP.formatClassNN( "SysListView32", this.getConf( "ListPayment", 13 ) )
		ControlFocus, %strListPayment%, ahk_id %idRTP%
		Send Credit{Tab}{Enter}

		; Retrieve customer card on file
		WinWaitActive,Payment Details,, 2
		idPay := WinExist("Payment Details")
		strRetrieveCard := Window.getControlFromContents( "Retrieve", idPay )
		ControlFocus, %strRetrieveCard%, ahk_id %idPay%
		Send {Enter}
		*/

		; Use QuickPayment option
		;strControlQuickPay := Window.getControlFromContents( "Quick Payment", idPay )
		Sleep 500
		ControlClick, Select a Quick Payment, A
		Send {Up 2}
	 }

}

; WindowsForms10.SysListView32.app.0.30495d1_r11_ad13

