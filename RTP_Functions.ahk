/**
 * Here be useful functions shared between RTP Macros
 *
 * AutoHotKey v1.1.13.01+
 *
 * LICENSE: This work is licensed under a version 4.0 of the
 * Creative Commons Attribution-ShareAlike 4.0 International License
 * that is available through the world-wide-web at the following URI:
 * http://creativecommons.org/licenses/by-sa/4.0/deed.en_US
 *
 * @category   Automation
 * @package    RTP_Macro
 * @author     Dominic Wrapson <dwrapson@whistlerblackcomb.com>
 * @copyright  2013 Dominic Wrapson
 * @license    Creative Commons Attribution-ShareAlike 4.0 International License http://creativecommons.org/licenses/by-sa/4.0/deed.en_US
 */


;*****************************************************
; Function to update per-product commissions
_updateCommission( intCommission, dtExpiry="12/31/2020", dtEffective=0 )
{
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
	_dateInput( dtEffective )
	Send {Tab}
	_dateInput( dtExpiry )
	Send {Tab}%intCommission%
	Send {Tab 2}{Space}
	Send +{Tab}
	Send {Down}
}


/**
 * Updates a date input with specified date (mm/dd/yyyy)
 *
 * Takes a specified date (mm/dd/yyyy) and transposes to a date input.
 * Due to RTP's inherent date-validity checking, if there are start-and-end
 * inputs the year must be either incremented or decremented by an amount
 * before a new date can be entered.
 * Depending on if you are changing an effective-date or an expiration date,
 * you will need to specify either to increment or decrement the year first
 * 
 * 
 * @param bool blnUp Control whether to increment or decrement a date input year before transposing
 *
 * @return void This function does not return a value
 */
_dateInput( dtDate, blnUp=1 )
{
	Send {right 2}
	If blnUp
		Send {Up 2}
	else
		Send {Down 2}
	Send {left 2}
	Loop, parse, dtDate, /
	{
		Send %A_LoopField%{right}
	}
}


/*****************************************************
 * 
 *
 */
_paymentMethod( chrMethod ) {
	Send {Home}
	If ( chrMethod = "AR" )
		Send {PGDN}{Up 4}
	Else If ( chrMethod = "CC" )
		Send {End}{Up 11}
	Else If ( chrMethod = "GC" )
		Send {Down 2}
	Else
		MsgBox, 16, Error, Payment Method not matched
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
_windowCheckMultiple( strWindow ) {
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
_windowContinueSingleOnly( strWindow ) {
	win := _windowCheckMultiple( strWindow )
	WinGet, strActive, ProcessName, A
	StringTrimRight, strActive, strActive, 4

	if ( 0 = win ) {
		MsgBox, 16, RTP Macro Error, Window "%strWindow%" not found
		if ( True != _RETURN_ON_USER_CANCEL() )
			Exit
		else
			return False
	} else if ( 1 < win ) {
		MsgBox, 16, RTP Macro Error, More than one instance found of window:`n"%strWindow%"`n`nPlease close any additional windows and try again`n`nError Info: %win%
		if ( True != _RETURN_ON_USER_CANCEL() )
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
_windowCheckActiveProcess( strProcess ) {
	Loop {
		WinGet, strActive, ProcessName, A
		StringTrimRight, strActive, strActive, 4
		if ( strProcess != strActive ) {
			StringUpper, strActive, strActive, T
			StringUpper strProcessU, strProcess, T
			MsgBox, 69, RTP Macro Information,This macro can only be started from within "%StrProcessU%".`nPlease ensure %StrProcessU% is the active-window before starting.`n`nMacro started from within: %strActive%.
			IfMsgBox, Cancel
			{
				if ( True != _RETURN_ON_USER_CANCEL() )
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
_windowCheckActiveTitle( strTitle ) {
	Loop {
		WinGetTitle, strActive, A
		if ( strTitle != strActive ) {
			MsgBox, 69, RTP Macro Information,This macro can only be started from within "%StrTitle%".`nPlease ensure this is the active-window before starting.`n`nMacro started from within: %strActive%.
			IfMsgBox, Cancel
			{
				if ( True != _RETURN_ON_USER_CANCEL() )
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
_windowCheckVisibleTextContains( strFirst, strSecond="", strThird="", strFourth="" ) {
	DetectHiddenText, off
	Loop {
		WinGetText, strVisible, A
		If ( !InStr( strVisible, strFirst ) OR !InStr( strVisible, strSecond ) OR !InStr( strVisible, strThird ) OR !InStr( strVisible, strFourth ) ) {
			MsgBox, 69, RTP Macro Information,Execution error: Attempted execution in wrong window or panel.`n`nError info: %strFirst%, %strSecond%, %strThird%, %strFourth%.
			IfMsgBox, Cancel
			{
				if ( True != _RETURN_ON_USER_CANCEL() )
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
_windowCheckVisibleTextDoesNotContain( strFirst, strSecond="thisisnevergoingtobefoundanywhere", strThird="thisisnevergoingtobefoundanywhere", strFourth="thisisnevergoingtobefoundanywhere" ) {
	DetectHiddenText, off

	WinGetText, strVisible, A
	If ( InStr( strVisible, strFirst ) OR InStr( strVisible, strSecond ) OR InStr( strVisible, strThird ) OR InStr( strVisible, strFourth ) ) {
		MsgBox, 48, RTP Macro Information,Execution error: Macro attempted in wrong window or panel.

		if ( True != _RETURN_ON_USER_CANCEL() )
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
_windowCheckControlFocus( strTargetFocus, strTargetFriendly ) {
	Loop {
		ControlGetFocus, strControlFocus, A
		if ( strControlFocus != strTargetFocus ) {
			MsgBox, 69, RTP Macro Information,Execution error: %strTargetFriendly% must have focus before continuing.
			IfMsgBox, Cancel
			{
				if ( True != _RETURN_ON_USER_CANCEL() )
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


_screenImageSearch( topX, topY, botX, botY, strImagePath ) {

}


/**
 * Displays an input box to ask the user to enter a string
 * 
 * @param string strMessage The message to display on the input dialogue
 * @param mixed mixDefault The default value in the input box
 * @param bool blnExit Control whether to return or exit on user-cancel
 *
 * @return mixed Mixed value of user-input
 */
_InputBox( strMessage, mixDefault="" ) {
	InputBox, mixVar, RTP Macro Input, %strMessage%, , , , , , , , %mixDefault%
	if ErrorLevel {
		if ( True != _RETURN_ON_USER_CANCEL() )
			Exit
		else
			return False
	}
	return %mixVar%
}




_RETURN_ON_USER_CANCEL() {
	global RETURN_ON_USER_CANCEL
	return %RETURN_ON_USER_CANCEL%
}