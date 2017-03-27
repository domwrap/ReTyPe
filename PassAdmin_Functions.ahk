;========================================================
;Functions
_getIpFromExcel() {
	global idWinExcel

	WinActivate, ahk_id %idWinExcel%
	Loop {
		Send {Home}{Right 2}{F2}+{Home}^c{Tab}
		intIP := clipboard
		if ( ( 6 != StrLen( intIP ) AND 7 != StrLen( intIP ) ) OR intIP is not integer ) {
			MsgBox, 69, %strProgramName%, Captured data does not look like an IP Code.  Are we on the correct row in Excel?`n`nTry again?
			IfMsgBox, Cancel
			{
				ErrorLevel = 1
				return false
			}
		} else {
			break
		}
	}
	return %intIP%
}


_windowGetID( strWinTitle, strWinFriendly, strWinClass="" ) {
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


_windowActivateRestore( idWin ) {
	WinActivate, ahk_id %idWin%
	WinGet, intState, MinMax, ahk_id %idWin%
	if ( -1 = intState ) {
		WinRestore, ahk_id %idWin%
	}
}

; This function is HORRIBLY SLOW as it has to parse each control on a page looking for a match
; RTP has dynamically named gui elements so we currently have no other choice
_controlGetFromContents( strSearch, idWindow ) {
	WinGet, arrControls, ControlList, ahk_id %idWindow%

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

	if ( !strControl ) {
		ErrorLevel = 1
	}

	return strControl
}


_rtpWindowCheck( strTarget ) {
	global idWinRTP
	; Check for presence of %strTarget% address as it seems to be the ONLY identifying thing on the screen (AAAARGH!)
	strControl := _controlGetFromContents("rtp://", idWinRTP)
	ControlGetText, strAddress, %strControl%, A
	strTargetAddress = % "rtp://" . strTarget . "/"

	if ( strAddress != strTargetAddress ) {
		MsgBox, 48, %strProgramName%, You don't appear to be in %strTarget%.`nPlease switch to %strTarget% and try again
		ErrorLevel = 1
		return false
	}

	return true
}


_mouseClickAndReturn( strButton, intX, intY ) {
	MouseGetPos, nowX, nowY
	MouseClick, %strButton%, %intX%, %intY%
	MouseMove, %nowX%, %nowY%
}


; @todo Figure out WTF this only works every-other call!?!?!?!
_rtpWindowSwitch( strWindow ) {
	global idWinRTP
	intRow = 
	strControl = WindowsForms10.SysListView32.app.0.30495d1_r11_ad11

	_windowActivateRestore( idWinRTP )

	ControlGet, arrMenu, List,, %strControl%, ahk_id %idWinRTP%
	Loop, Parse, arrMenu, `n
	{
		if ( A_LoopField = strWindow ) {
			intRow := A_Index
			break
		}
	}
	if ( 0 = intRow )
	{
		ErrorLevel = 1
		return False
	}
	intDown := ((intRow-1)*23)+110

	Send, {Escape}
	MouseClick, Left, 40, 40
	Send, {Tab}
	MouseClick, Left, 45, %intDown%

	return %intRow%
}


_rtpCustomerSearchAndSelect( intIP, blnForceSearch=False ) {
	global idWinRTP
	global idIPCodeSearchLastMatched

	;_rtpWindowSwitch( "Customer Manager" )
	;_rtpWindowCheck( "Customer Manager" )
	;if ErrorLevel
		;return

; @todo check value of customer manager IP: box against current

	if ( intIP != idIPCodeSearchLastMatched OR True = blnForceSearch ) {
		; Always default back to the customer search tab (tabindex starts at 0)
		SendMessage, 0x1330, 0,, WindowsForms10.SysTabControl32.app.0.30495d1_r11_ad11, ahk_id %idWinRTP%  ; 0x1330 is TCM_SETCURFOCUS.

		; Activate search box, paste, and find
		ControlFocus, WindowsForms10.EDIT.app.0.30495d1_r11_ad11, ahk_id %idWinRTP%
		Send {Del}

		; Move to Refine Criteria box and input there
		; @todo find position of IP in list and move X rows on that in case order changes
		Control, Choose, 9, WindowsForms10.COMBOBOX.app.0.30495d1_r11_ad11, ahk_id %idWinRTP%
		ControlFocus, WindowsForms10.EDIT.app.0.30495d1_r11_ad12, ahk_id %idWinRTP%
		Send %intIP%{Enter}

		Loop {
			Sleep 500
			;Focus refine criteria box
			ControlFocus, WindowsForms10.EDIT.app.0.30495d1_r11_ad11, ahk_id %idWinRTP%
			If ErrorLevel
			{
				SB_SetText( "Still cannot focus" )
				continue
			}
			If ( "Wait" = %A_Cursor% ) {
				SB_SetText( "Cursor is still wait!" )
				continue
			}
			IfWinActive, Cancel Customer Search
			{
				SB_SetText( "Search still active!" )
				continue
			}

			SB_SetText( "Waiting..." )
			break
		}
	}

	; Update global
	idIPCodeSearchLastMatched := intIP

; @todo collapse treeview before traversing (WindowsForms10.SysTreeView32.app.0.30495d1_r11_ad12)

	; @todo Pull column 3 (IP) match entry against input incase shorter IP matchers multiple people
	; Open first entry in search result list
	ControlFocus, WindowsForms10.SysListView32.app.0.30495d1_r11_ad12, ahk_id %idWinRTP%
	SendInput {Home}{Space}{Enter}
}