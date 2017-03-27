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

	; Control definition (in case they change later because let's be honest, they probably will!)
	strCustomerListView		= WindowsForms10.SysListView32.app.0.30495d1_r11_ad11 ; Well yeah, or is it actually the comments.  Who the fuck knows
	strCustomerTab			= WindowsForms10.SysTabControl32.app.0.30495d1_r11_ad11
	strSearchEdit			= WindowsForms10.EDIT.app.0.30495d1_r11_ad11
	strSearchRefineEdit		= WindowsForms10.EDIT.app.0.30495d1_r11_ad12
	strSearchRefineCombo	= WindowsForms10.COMBOBOX.app.0.30495d1_r11_ad11

	; Switch to customer search tab
	; OH MY GOD!  So if a comment (or other such item) has recently been added or accessed, the Search Results
	; ListView is actualy somehow overpopulated with the list of the item you just accessed, thence stealing
	; the Search Results ListView ID (yes, identifier!) even if that list doesn't ACTUALLY exist as a ListView
	; in the first place.  WHAT THE BALLS, RTP!?
	; So, today's workaround of the day is to switch to the search results tab to REMIND RTP which one I'm
	; actually referring to when I use its unique identifier.  Later on we'll switch back to the View Details tab
	; I need a drink
	SendMessage, 0x1330, 0,, %strCustomerTab%, ahk_id %idWinRTP%  ; 0x1330 is TCM_SETCURFOCUS

	; Get IP value of first entry in search results
	ControlGet, intCustomerSearchCount, List, Count, %strCustomerListView%, ahk_id %idWinRTP%
	ControlGet, arrCustomerLoaded, List, Col3, %strCustomerListView%, ahk_id %idWinRTP%
	; Pop first one off the listing, depending on how many there are as the parse-loop doesn't work if there's only one result
	if ( 2 >  intCustomerSearchCount ) {
		ControlGet, intCustomerLoaded, List, Col3, %strCustomerListView%, ahk_id %idWinRTP%
	} else {
		Loop, Parse, arrCustomerLoaded, `n
		{
			intCustomerLoaded := A_LoopField
			break
		}
	}

; @todo Verify which profile is loaded in case searched and then opened dependent.  Thanks to RTP's usual skullfuckery of
; a GUI, we cannot directly reference the IP: xxxxxx field on a profile, instead must search EVERY visible control for text
; IP: xxxxxxx and if we get a match, then it's loaded, else re-search.  Yeah, thanks.
; write to intCustomerIP
	;StringMid, intCustomerIP, intCustomerIP, 5

;MsgBox intCustomerSearchCount: %intCustomerSearchCount%`nintIP: %intIP%`nintCustomerIP: %intCustomerIP%`nintCustomerLoaded: %intCustomerLoaded%`nidIPCodeSearchLastMatched: %idIPCodeSearchLastMatched%`nblnForceSearch: %blnForceSearch%
;exit
	; This if logic is kinda square peg round hole to get RTP to fuck off and do what I want it to
	; It could probably be normalised but right now it works, so screw it
	; Is customer loaded, and if so is it the one we want, and is it the one actually loaded, and is it the last searched for, or do it anyway
	if ( !intCustomerLoaded OR intIP != intCustomerLoaded OR blnForceSearch ) {
;msgbox Reload it!
;exit
		; Always default back to the customer search tab (tabindex starts at 0)
		SendMessage, 0x1330, 0,, %strCustomerTab%, ahk_id %idWinRTP%  ; 0x1330 is TCM_SETCURFOCUS

		; Activate search box and empty so doesn't mess with IP search
		ControlFocus, %strSearchEdit%, ahk_id %idWinRTP%
		Send {Del}

		; Move to Refine Criteria box and input there
		Control, ChooseString, IP Code, %strSearchRefineCombo%, ahk_id %idWinRTP%
		ControlFocus, %strSearchRefineEdit%, ahk_id %idWinRTP%
		Send %intIP%{Enter}

		Loop {
			Sleep 500
			;Focus refine criteria box
			ControlFocus, %strSearchEdit%, ahk_id %idWinRTP%
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

		; Update global
		idIPCodeSearchLastMatched := intIP

		; @todo Pull column 3 (IP) match entry against input incase shorter IP matchers multiple people
		; Open first entry in search result list
		ControlFocus, %strCustomerListView%, ahk_id %idWinRTP%
		SendInput {Home}{Space}{Enter}
	}

	; Switch to customer detail tab
	SendMessage, 0x1330, 1,, %strCustomerTab%, ahk_id %idWinRTP%  ; 0x1330 is TCM_SETCURFOCUS
}


_rtpCustomerAddComment( strSubject, strComment, blnSave=True ) {

	_rtpCustomerResetTreeview()

	; Move to comments
	Send {Right}{Down 3}
	; Hit add button
	Send {Tab 5}{Space}
	; Enter subject
	SendInput {Tab}%strSubject%
	; Enter comment
	SendInput {Tab}%strComment%

; @todo Add timeout 5? seconds, if no input, close and save
	if ( blnSave ) {
		; Save it
		Send {Tab}{Space}
	}
}


_rtpCustomerResetTreeview() {
	global idWinRTP
	strCustomerTreeView		= WindowsForms10.SysTreeView32.app.0.30495d1_r11_ad12

	; Focus the treeview
	ControlFocus, %strCustomerTreeView%, ahk_id %idWinRTP%
	; Reset tree
	Send {End}
	Loop 6 {
		Send {Left 2}{Up}
	}
}