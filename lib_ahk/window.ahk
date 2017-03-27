/**
 * Here be useful functions for checking and acting on windows
 *
 * AutoHotKey v1.1.13.01+
 *
 * LICENSE: This work is licensed under a version 4.0 of the
 * Creative Commons Attribution-ShareAlike 4.0 International License
 * that is available through the world-wide-web at the following URI:
 * http://creativecommons.org/licenses/by-sa/4.0/deed.en_US
 *
 * @category	Automation
 * @package		ReTyPe
 * @author		Dominic Wrapson <dwrapson@whistlerblackcomb.com>
 * @copyright	2013 Dominic Wrapson
 * @license		Creative Commons Attribution-ShareAlike 4.0 International License http://creativecommons.org/licenses/by-sa/4.0/deed.en_US
 */

class Window extends _returnableClass {


	__New() {
		; Nothing to see here
	}


	__Delete() {
		; Nor here
	}


	/**
	 * Returns number of instances of a window specified by name
	 * 
	 * @param string strWindow Title of the window to check (can be partial match, as per WinGet)
	 *
	 * @return int Returns count of windows that match string input
	 *
	 * @see WinGet
	 */
	CheckMultiple( strWindow ) {
		; Check only one bulk pricing window and error if multiple
		WinGet, id, list, %strWindow%
		return %id%
	}


	/**
	 * Checks that only one-instance of the specified window exists, otherwise aborts
	 * 
	 * @param string strWindow Title of the window to check (can be partial match, as per WinGet)
	 * @param bool blnExit Control whether to return or exit on user-cancel
	 *
	 * @return void This function does not return a value
	 *
	 * @see WinGet
	 */
	ContinueSingleOnly( strWindow ) {
		win := this.CheckMultiple( strWindow )
		WinGet, strActive, ProcessName, A
		StringTrimRight, strActive, strActive, 4

		if ( 0 = win ) {
			MsgBox, 16, RTP Macro Error, Window "%strWindow%" not found
			if ( True != this._RETURN_ON_USER_CANCEL() )
				Exit
			else
				return False
		} else if ( 1 < win ) {
			MsgBox, 16, RTP Macro Error, More than one instance found of window:`n"%strWindow%"`n`nPlease close any additional windows and try again`n`nError Info: %win%
			if ( True != this._RETURN_ON_USER_CANCEL() )
				Exit
			else
				return %win%
		}

		return True
	}


	/**
	 * Validates the window from which the macro was executed matches the specified process
	 * 
	 * @param string strProcess Name of the process (lowercase and without .exe) for comparison with active window
	 *
	 * @return void This function does not return a value
	 */
	CheckActiveProcess( strProcess ) {
		Loop {
			WinGet, strActive, ProcessName, A
			StringTrimRight, strActive, strActive, 4
			if ( strProcess != strActive ) {
				StringUpper, strActive, strActive, T
				StringUpper strProcessU, strProcess, T
				MsgBox, 69, RTP Macro Information,This macro can only be started from within "%StrProcessU%".`nPlease ensure %StrProcessU% is the active-window before starting.`n`nMacro started from within: %strActive%.
				IfMsgBox, Cancel
				{
					if ( True != this._RETURN_ON_USER_CANCEL() )
						Exit
					else
						return False
				}
			} else {
				break
			}
		}

		return True
	}


	/**
	 * Validates the window from which the macro was executed matches the specified process
	 * 
	 * @param string strTitle Title of the window for comparison with active window
	 *
	 * @return void This function does not return a value
	 */
	CheckActiveTitle( strTitle ) {
		Loop {
			WinGetTitle, strActive, A
			if ( strTitle != strActive ) {
				MsgBox, 69, RTP Macro Information,This macro can only be started from within "%StrTitle%".`nPlease ensure this is the active-window before starting.`n`nMacro started from within: %strActive%.
				IfMsgBox, Cancel
				{
					if ( True != this._RETURN_ON_USER_CANCEL() )
						Exit
					else
						return False
				}
			} else {
				break
			}
		}

		return True
	}


	/**
	 * Checks visibility of up to four strings are ALL in the active window
	 * 
	 * @param mixed strFirst First string to match
	 * @param mixed strSecond Second string to match
	 * @param mixed strThird Third string to match
	 * @param mixed strFourth Fourth string to match
	 *
	 * @return bool True or false for successful match
	 */
	CheckVisibleTextContains( strFirst, strSecond="", strThird="", strFourth="" ) {
		DetectHiddenText, off
		Loop {
			WinGetText, strVisible, A
			If ( !InStr( strVisible, strFirst ) OR !InStr( strVisible, strSecond ) OR !InStr( strVisible, strThird ) OR !InStr( strVisible, strFourth ) ) {
				MsgBox, 69, RTP Macro Information,Execution error: Attempted execution in wrong window or panel.`n`nError info: %strFirst%, %strSecond%, %strThird%, %strFourth%.
				IfMsgBox, Cancel
				{
					if ( True != this._RETURN_ON_USER_CANCEL() )
						Exit
					else
						return False
				}
			} else {
				break
			}
		}
		return True
	}


	/**
	 * Checks up to four strings ARE NOT visible in the active window
	 * 
	 * @param mixed strFirst First string to match
	 * @param mixed strSecond Second string to match
	 * @param mixed strThird Third string to match
	 * @param mixed strFourth Fourth string to match
	 *
	 * @return bool True or false for success
	 */
	CheckVisibleTextDoesNotContain( strFirst, strSecond="thisisnevergoingtobefoundanywhere", strThird="thisisnevergoingtobefoundanywhere", strFourth="thisisnevergoingtobefoundanywhere" ) {
		DetectHiddenText, off

		WinGetText, strVisible, A
		If ( InStr( strVisible, strFirst ) OR InStr( strVisible, strSecond ) OR InStr( strVisible, strThird ) OR InStr( strVisible, strFourth ) ) {
			MsgBox, 48, RTP Macro Information,Execution error: Macro attempted in wrong window or panel.

			if ( True != this._RETURN_ON_USER_CANCEL() )
				Exit
			else
				return False
		}

		return True
	}


	/**
	 * Checks the required control has focus
	 * 
	 * @param string strTargetFocus ClassNN of the control requiring focus
	 *
	 * @return bool Success (or exit on global setting)
	 */
	CheckControlFocus( strTargetFocus, strTargetFriendly ) {
		Loop {
			ControlGetFocus, strControlFocus, A
			if ( strControlFocus != strTargetFocus ) {
				MsgBox, 69, RTP Macro Information,Execution error: %strTargetFriendly% must have focus before continuing.
				IfMsgBox, Cancel
				{
					if ( True != this._RETURN_ON_USER_CANCEL() )
						Exit
					else
						return False
				}
			} else {
				break
			}
		}

		return True
	}

	/**
	 * Gets ID of specified window
	 * 
	 * @param string strWinTitle Window title of target
	 * @Param string strWinFriendly Friendly name for use in messaging
	 * @param string strWinClass ahk_class to help identify window
	 *
	 * @return int ID of window
	 */
	GetID( strWinTitle, strWinFriendly, strWinClass="" ) {
		global strProgramName
		idWin = 

		; If Window class provided, use it!
		if ( 0 < StrLen(strWinClass) ) {
			WinGet, arrWin, List, %strWinTitle% ahk_class %strWinClass%
		} Else {
			WinGet, arrWin, List, %strWinTitle%
		}

		; If only one window found, use it!
		if ( arrWin = 1 ) {
			Loop %arrWin% {
				idWin := arrWin%A_Index%
				MsgBox, 64, %strProgramName%, %strWinFriendly% Window located.  Thanks!
			}
		} else {
		; Otherwise, ask them to pick one!
; @todo instead of msgbox, use Tooltip at cursor position and change cursor to target (like WinSpy)
; http://www.autohotkey.com/docs/commands/ToolTip.htm
			MsgBox, 64, %strProgramName%, Multiple instances of %strWinFriendly% found, please activate the window you wish to use with %strProgramName%
			; If Window class provided, use it!
			if ( 0 < StrLen(strWinClass) )
				WinWaitActive,%strWinTitle% ahk_class %strWinClass%,, 5
			Else {
				WinWaitActive,%strWinTitle%,, 5
			}

			; Did we find one?
			if ErrorLevel {
				MsgBox, 48, %strProgramName%, Timed-out waiting for %strWinFriendly% window
				return
			} else {
				MsgBox, 64, %strProgramName%, %strWinFriendly% Window located.  Thanks!
				idWin := WinExist("A")
			}
		}

		return %idWin%
	}

	/**
	 * Restores a window (from minimized) and activates
	 * @return void
	 */
	ActivateRestore( idWin ) {
		WinActivate, ahk_id %idWin%
		WinGet, intState, MinMax, ahk_id %idWin%
		if ( -1 = intState ) {
			WinRestore, ahk_id %idWin%
		}
	}

	/**
	 * Returns a control based on text-matching its contents
	 * ErrorLevel set to 1 if control not found
	 *
	 * This function is HORRIBLY SLOW as it has to parse each control on a page looking for a match
	 * RTP has dynamically named gui elements so we currently have no other choice
	 *
	 * @param String strSearch Text to find within desired control
	 * @param String idWindow Unique ID of window in which to search for control
	 *
	 * @return String strControl string of matched control, if found
	 */
	getControlFromContents( strSearch, idWindow ) {
		;if ( !idWindow ) {
			;WinGet, arrControls, ControlList, A
		;} else {
			WinGet, arrControls, ControlList, ahk_id %idWindow%
		;}

		Loop, Parse, arrcontrols, `n
		{
			ControlFocus %A_LoopField%, ahk_id %idWindow%
			ControlGet, strList, List, , %A_LoopField%, ahk_id %idWindow%

			if ( 0 = StrLen(strList) ) {
				ControlGetText, strText, %A_LoopField%, ahk_id %idWindow%
				IfNotInString, strText, %strSearch%
					Continue
			} else {
				IfNotInString, strList, %strSearch%
					Continue
			}
			strControl = %A_LoopField%
			break
		}

		; ErrorLevel set to 1 if control not found
		if ( !strControl ) {
			ErrorLevel = 1
		}

		return strControl
	}

}