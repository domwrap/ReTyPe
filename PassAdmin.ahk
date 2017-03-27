
#NoEnv

#Include RTP_Functions.ahk
#Include PassAdmin_Functions.ahk



/** IDEAS
- Specify target spreadsheet and RTP windows at teh start of the process (And verify)
	carry them through all continuing macros unless one is closed (timeout check)
- INI file for configuration (position in menus, tabs, window names, etc)

*/


; Global definitions
strProgramName = Pass Admin Macro
idWinRTP = 
idWinExcel = 
idIPCode = 
idIPCodeSearchLastMatched =
strUsername := A_UserName


SysGet, intResX, 16
intGuiW = 150
intGuiX := intResX - intGuiW
intIconX := intGuiW - 26

Gui, Add, Text,, RTP:
Gui, Add, Text,, Excel:
Gui, Add, Text,, IP Code:
Gui, Add, Text,,
; Macro buttons
Gui, Add, Button, vbtnAutoCharge x25 w100 gfnAutoCharge, &Autocharge
Gui, Add, Button, vbtnComment w100 gfnMenuComment, &Comment
Gui, Add, Button, vbtnHotlist w100 gfnHotlist, &Hotlist
Gui, Add, Text,,
; Target buttons
Gui, Add, Button, w16 h18 x%intIconX% y5 gTargetRTP, +
Gui, Add, Button, w16 h18 x%intIconX% y30 gTargetExcel, +
Gui, Add, Button, vbtnTargetIPCode w16 h18 x%intIconX% y55 gTargetIPCode, +
; Disable buttons immediately after adding
GuiControl, Disable, btnAutoCharge
GuiControl, Disable, btnComment
GuiControl, Disable, btnHotlist
GuiControl, Disable, btnTargetIPCode
; Target windows
Gui, Add, Text, vlblWinRTP x55 y6, Unassigned
Gui, Add, Text, vlblWinExcel x55 y33, Unassigned
Gui, Add, Text, vlblIPCode x55 y60 w70, None
; Status bar
Gui, Add, StatusBar, vlblStatusBar,Waiting...

; Make it be!
Gui, Show, x%intGuiX% y100 w%intGuiW%, %strProgramName%
WinSet, AlwaysOnTop, On, A
; Maketh the system area more friendly
Menu, Tray, Icon, pass_admin.ico
Menu, Tray, Tip, Pass Admin


; Create the popup menu by adding some items to it.
Menu, MenuComment, Add, Edge DTL Decline, fnCommentDeclineEdgeDTL
Menu, MenuComment, Add, Resort Charge Decline, fnCommentDeclineResortCharge
Menu, MenuComment, Add  ; Add a separator line.

; Create another menu destined to become a submenu of the above menu.
Menu, MenuComment, Add, Guest Voicemail, MenuHandler
Menu, MenuComment, Add, Guest Emailed, MenuHandler
Menu, MenuComment, Add, Guest Contacted, MenuHandler

; Create a submenu in the first menu (a right-arrow indicator). When the user selects it, the second menu is displayed.
;Menu, MenuCommentContact, Add, Guest Voicemail, MenuHandler
;Menu, MenuComment, Add, Contact Comments, :MenuCommentContact

Menu, MenuComment, Add  ; Add a separator line below the submenu.
Menu, MenuComment, Add, Item3, MenuHandler  ; Add another menu item beneath the submenu.


#Persistent
SetTimer, buttonDisable, 250
return



buttonDisable:
; Check if the targetted windows still exist
IfWinNotExist, ahk_id %idWinRTP%
{
	GuiControl,,lblWinRTP,Unassigned
	idWinRTP :=
}
IfWinNotExist, ahk_id %idWinExcel%
{
	GuiControl,,lblWinExcel,Unassigned
	idWinExcel :=
}
; Disable all automation buttons until required criteria found
if ( !idWinRTP OR !idWinExcel OR !idIPCode ) {
	GuiControl, Disable, btnAutoCharge
	GuiControl, Disable, btnComment
	GuiControl, Disable, btnHotlist
} else {
	GuiControl, Enable, btnAutoCharge
	GuiControl, Enable, btnComment
	GuiControl, Enable, btnHotlist
}
; Disable the IP target button if Excel is not locked
if ( !idWinExcel ) {
	GuiControl, Disable, btnTargetIPCode
} else {
	GuiControl, Enable, btnTargetIPCode
}

return



GuiClose:
ExitApp




TargetRTP:
	; THERE IS SOMETHING weird going on with this when a non-focused window is
	; selected, sometimes a different ID is found and stores which doesn't
	; then work through the rest of the script.  No idea what's going on at this time

	; Locate RTP window ID
	idWinRTP := _windowGetID( "RTP|ONE", "RTP" )
	; Update GUI with window ID
	GuiControl,,lblWinRTP,%idWinRTP%

	; Retrieve name from RTP for use in comments
	;ControlGetText, strRTPName, WindowsForms10.STATIC.app.0.30495d1_r11_ad14, %idWinRTP%
return

TargetExcel:
	; Locate Excel window ID
	idWinExcel := _windowGetID( "Microsoft Excel -", "Excel", "XLMAIN" )
	; Update GUI with window ID
	GuiControl,,lblWinExcel,%idWinExcel%
return

TargetIPCode:
	idIP := _getIpFromExcel()
	if ErrorLevel
		return

	idIPCode := idIP
	GuiControl,,lblIPCode,%idIPCode%
return




fnMenuComment:
	Menu, MenuComment, Show
return  ; End of script's auto-execute section.

MenuHandler:
	MsgBox You selected %A_ThisMenuItem% from the menu %A_ThisMenu%.
return

;GuiClose:
;ExitApp








;========================================================
fnAutoCharge:
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
		_windowActivateRestore( idWinRTP )
		strControl := _controlGetFromContents( "Autocharge Recovery", idWinRTP )
		if ErrorLevel
		{
			MsgBox, 70, %strProgramName%, Failed to find AutoCharge Recovery button, this is usually because ONE|Resort has not been loaded`n`nWould you like to`n[Cancel] Quit`n[Try Again] Load ONE|Resort manually and retry`n[Continue] Attempt to automatically resolve this issue
			IfMsgBox, Cancel
				return
			IfMsgBox, TryAgain
				continue
			IfMsgBox, Continue
			{
				_rtpWindowSwitch( "ONE|Resort" )
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
return


;========================================================
fnCommentDeclineEdgeDTL:
	_windowActivateRestore( idWinExcel )
	; Reset row
	Send {Home}
	; Grab info
	Send {Right 7}^c
	StringReplace, intSaleDate, clipboard, `r`n
	Send {Right}^c
	StringReplace, intAmountOwed, clipboard, `r`n
	Send {Right}^c
	StringReplace, strCreditCard, clipboard, `r`n

	_windowActivateRestore( idWinRTP )
	_rtpCustomerSearchAndSelect( idIPCode )

	; Move to comments
	SendInput {Down 2}
	; Hit add button
	SendInput {Tab 5}{Space}
	; Enter subject
	SendInput {Tab}Owes %intAmountOwed% (DTL charge)
	; Enter comment
	SendInput {Tab}For %intSaleDate%. Need to check CC %strCreditCard% on file.  %strUsername% x7055
	; Save it
	SendInput {Tab}{Space}
return


;========================================================
fnCommentDeclineResortCharge:
	_windowActivateRestore( idWinExcel )
	; Reset row
	Send {Home}
	; Grab info
	Send {Right 7}^c
	StringReplace, intSaleDate, clipboard, `r`n
	Send {Right}^c
	StringReplace, intAmountOwed, clipboard, `r`n
	Send {Right}^c
	StringReplace, strCreditCard, clipboard, `r`n

	_windowActivateRestore( idWinRTP )
	_rtpCustomerSearchAndSelect( idIPCode )

	; Move to comments
	SendInput {Down 2}
	; Hit add button
	SendInput {Tab 5}{Space}
	; Enter subject
	SendInput {Tab}Owes %intAmountOwed% (RC charge)
	; Enter comment
	SendInput {Tab}For %intSaleDate%. Need to check CC %strCreditCard% on file.  %strUsername% x7055
	; Save it
	SendInput {Tab}{Space}
return


;========================================================
fnHotlist:
	_rtpCustomerSearchAndSelect( idIPCode )

	MsgBox I don't do anything yet!
return



