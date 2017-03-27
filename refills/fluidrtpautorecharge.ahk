
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

	pour() {
		global objRetype

		; Activate RTP (after toolbar has been clicked)
		objRTP := objRetype.objRTP
		objRTP.Activate()

		strGroup := this.__Class
		IfWinActive, ahk_group %strGroup%
		{

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
				objRTP.Activate()
				strControl := Window.getControlFromContents( "Autocharge Recovery", objRTP.getID() )

				if ErrorLevel
				{
					MsgBox, 70, %strProgramName%, Failed to find AutoCharge Recovery button, this is usually because ONE|Resort has not been loaded`n`nWould you like to`n[Cancel] Quit`n[Try Again] Load ONE|Resort manually and retry`n[Continue] Attempt to automatically resolve this issue
					IfMsgBox, Cancel
						return
					IfMsgBox, TryAgain
						continue
					IfMsgBox, Continue
					{
						objRTP.WindowSwitch( "ONE|Resort" )
; @todo Some kind of a message here to say we're waiting
						Sleep 10000
						if ErrorLevel
						{
							MsgBox, 69, %strProgramName%, Failed to automatically switch windows.`nPlease load ONE|Resort manually and press Retry, or cancel to quit
							IfMsgBox, Retry
								continue
							IfMsgBox, Cancel
								return
						}
					}
				}

				ControlFocus, strControl, A
				SendInput, {Enter}
				WinWait, AutoCharge Recovery,,10
				If ErrorLevel
				{
					MsgBox, 69, %strProgramName%, Script timed out waiting for AutoCharge Recovery window to load.  Retry?
					IfMsgBox, Cancel
						return
					IfMsgBox, Retry
						Continue
				}
				break
			}

			; Set focus to search text box
			ControlFocus, WindowsForms10.EDIT.app.0.30495d1_r11_ad11, A
			Send %idIPCode%{Enter}

			; Catch not-found error
			WinWaitNotActive, AutoCharge Recovery,,5
			if ( 0 = ErrorLevel )
			{
				Send {Space}
				ControlFocus, Cancel, A
				Send {Space}
				MsgBox, 48, %strProgramName%, Customer not found or no search results for customer.  Exiting.
				return
			}
			; Otherwise we found some stuff, keep on trucking!
			ControlFocus, OK, A
		}
	}

}