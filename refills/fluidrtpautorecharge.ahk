
objRetype.refill( new FluidRTPAutoRecharge() )

; @todo Make generic commenting class (with prompt), and extend to pass admin / config file editable sub-class
class FluidRTPAutoRecharge extends Fluid {

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

		; Set focus to search text box
		strControl := objRetype.objRTP.formatClassNN( "EDIT", this.getConf( "EditSearch", 11 ) )

		ControlFocus, %srtControl%, A
		Send +{Tab 2}
		Send %intIP%{Enter}

		; Catch not-found error
		WinWaitNotActive, AutoCharge Recovery,,5
		if ( 0 = ErrorLevel )
		{
			; Eventuality detection
			IfWinExist, , Customer not found
			{
; @todo Change {space} to ControlClick
				Send {Space}
				ControlClick, Cancel, A
				MsgBox.stop( "Customer not found, discontinuing automation" )
			} else {
				IfWinExist, Search Results, Your Quick Search returned
				{
					Send {Space}
					ControlClick, Cancel, A
					MsgBox.stop( "Ambiguous search term, more than one result returned. Please only search by unique IP Code" )
				} else {
; No failed autocharges were found for the selected customer
					Msgbox.error( "Unknown fork in logic" )
					exit
				}
			}
		}

		; Otherwise we found some stuff, keep on trucking!
		;ControlFocus, OK, A
		ControlClick, OK
	 }  

}
