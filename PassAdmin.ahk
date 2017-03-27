	
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
; RTP
idIPCode = 
idIPCodeSearchLastMatched =
strUsername := A_UserName
; Stats
blnStats = true
intStatClicks = 0


SysGet, intResX, 16
intGuiW = 150
intGuiX := intResX - intGuiW
intIconX := intGuiW - 26

Gui, Add, Text,, RTP:
Gui, Add, Text,, Excel:
Gui, Add, Text,, IP Code:
Gui, Add, Text,,
; Macro buttons
Gui, Add, Button,  x25 w100, Process &Report
Gui, Add, Text,,
Gui, Add, Button, vbtnAutoCharge w100 gfnAutoCharge, &Autocharge
Gui, Add, Button, vbtnComment w100 gfnMenuComment, &Comment
Gui, Add, Button, vbtnHotlist w100 gfnHotlist, &Hotlist
Gui, Add, Text,,
Gui, Add, Text,, Click Stats:
Gui, Add, Button,  w30 gfnStatStart, Star&t
Gui, Add, Text, vlblStatClicks x92 y268 w30 Right, 0
Gui, Add, Button, x60 y287 w30 gfnStatStop, Sto&p
Gui, Add, Button, x95 y287 w30 gfnStatReset -wrap, R&eset
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
Menu, MenuComment, Add, Guest Voicemail, fnCommentGuestVoicemail
Menu, MenuComment, Add, Guest Emailed, fnCommentGuestEmailed
Menu, MenuComment, Add, Guest Contacted, fnCommentGuestSpokeTo

; Create a submenu in the first menu (a right-arrow indicator). When the user selects it, the second menu is displayed.
;Menu, MenuCommentContact, Add, Guest Voicemail, MenuHandler
;Menu, MenuComment, Add, Contact Comments, :MenuCommentContact

Menu, MenuComment, Add  ; Add a separator line below the submenu.
Menu, MenuComment, Add, Item3, MenuHandler  ; Add another menu item beneath the submenu.

; Control the button availability
SetTimer, guiUpdate, 250
return



guiUpdate:
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

GuiControl,,lblStatClicks,%intStatClicks%

return



GuiClose:
ExitApp



; Capture click event for stat counting
~*LButton::
~*RButton::
	If ( true = blnStats ) {
		intStatClicks++
	}
return

;========================================================
fnStatStart:
	blnStats := true
return

fnStatStop:
	blnStats := false
return

fnStatReset:
	blnStats := false
	intStatClicks = 0
return


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
	idWinExcel = 

	; Locate Excel window ID
	Loop {
		intWinExcel := _windowGetID( "Microsoft Excel -", "Excel", "XLMAIN" )
		clipboard = 

		WinActivate, ahk_id %intWinExcel%
		Send ^{Home}{Up 2}
		Send {F2}+{Home}^c{Tab}

		if ( clipboard != "Failed Auto Charge Report With CC Update" ) {
			MsgBox, 69, %strProgramName%, That doesn't look like the correct Excel report.  Would you like to try again?
			IfMsgBox Cancel
				break

			continue
		}

		; if we get to here we must've found it
		idWinExcel := intWinExcel
		; sneaky little goto
		break
	}

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

	strSubject = Owes %intAmountOwed% (DTL charge)
	strComment = For %intSaleDate%. Need to check CC %strCreditCard% on file.  Emailed guest.  %strUsername% x7055
	_rtpCustomerAddComment( strSubject, strComment )
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

	strSubject = Owes %intAmountOwed% (RC charge)
	strComment = For %intSaleDate%. Need to check CC %strCreditCard% on file.  Emailed guest.  %strUsername% x7055
	_rtpCustomerAddComment( strSubject, strComment )
return


;========================================================
fnCommentGuestVoicemail:
	_windowActivateRestore( idWinRTP )
	_rtpCustomerSearchAndSelect( idIPCode )

	strSubject = Phoned guest, left msg
	strComment = Re: DTL charge owing and hotlist.  %strUsername% x7055
	_rtpCustomerAddComment( strSubject, strComment )
return


;========================================================
fnCommentGuestEmailed:
	_windowActivateRestore( idWinRTP )
	_rtpCustomerSearchAndSelect( idIPCode )

	strSubject = Emailed guest
	strComment = Re: RC/DTL charges owing.  %strUsername% x7055
	_rtpCustomerAddComment( strSubject, strComment )
return


;========================================================
fnCommentGuestSpokeTo:
	strGuest := _InputBox( "With whom did you speak?" )
; @todo Check for blank input

	_windowActivateRestore( idWinRTP )
	_rtpCustomerSearchAndSelect( idIPCode )

	strSubject = Phoned guest, spoke to %strGuest%
	strComment = Re: RC charge owing.  Guest says they will contact their CC company and remove the hold.  Will call us back when we can retry CC.  %strUsername% x7055
	_rtpCustomerAddComment( strSubject, strComment )
return


;========================================================
fnHotlist:
	; Hunt down the customer
	_rtpCustomerSearchAndSelect( idIPCode )

; @todo SOME CHECKS: Make sure customer is an adult, etc, if PassAdmin want to, else let them decide first and just hit hotlist as appropriate

	blnLoadedPassMediaProfile := _screenImageSearch( 100, 100, 500, 200, "search_images\customermanager_passmediaprofile.png" )
; WHY ISN'T THIS WORKING!?
;MsgBox % ErrorLevel
;return
	if ( !blnLoadedPassMediaProfile )
	{
		_rtpCustomerResetTreeview()

		; Navigate to Pass Media Profile
		SendInput {Down 3}{Right}{Down}
		; Wait for the damn thing to finish
		Loop {
			Sleep 500

			ControlFocus, WindowsForms10.BUTTON.app.0.30495d1_r11_ad14, ahk_id %idWinRTP%
			If ErrorLevel
			{
				SB_SetText( "Still cannot focus" )
				continue
			}

			If ( "Wait" = %A_Cursor% ) {
				SB_SetText( "Cursor is still wait!" )
				continue
			}

			if ( !_screenImageSearch( 290, 110, 460, 150, "search_images/customermanager_passmediaprofile.png" ) )
			{
				SB_SetText( "Search still active!" )
				continue
			}

			SB_SetText( "Waiting..." )
			break
		}
	} else {
		ControlFocus, WindowsForms10.BUTTON.app.0.30495d1_r11_ad14, ahk_id %idWinRTP%
	}

	; Move to first pass in list
	Send {Tab 2}
	; Find out which control it is so we can click it (neither space nor enter will click open the profile)
	ControlGetFocus, strControlFocus, ahk_id %idWinRTP%
	Sleep 500
	;ControlClick, %strControlFocus%, ahk_id %idWinRTP%

; @todo check pass number begins with "(50" otherwise tab to next, check, repeat

	; Seeing as apparently Control Click doesn't work either (RTP controls are such shit)
	; we're instead going to have to literally click on it
	ControlGetPos, intX, intY,,, %strControlFocus%, ahk_id %idWinRTP%
	intX := intX+5
	intY := intY+5
	Click %intX%, %intY%

	; Wait for it to open
	WinWait, Pass Media Profile, 5

	; Now the damn thing is finally open
	;
	; Select hotlist reason
	Control, ChooseString, Autocharge Problem, WindowsForms10.COMBOBOX.app.0.30495d1_r11_ad11

	;intTomorrow := A_MM . "/" . A_DD+1 . "/" . A_YYYY
	;SendInput {Tab 5}%intTomorrow%

	SendInput {Tab 5}{Right}{Up}
	SendInput {Tab}Pass hotlisted – problem processing charges – please see comments on file.  %strUsername% x7055


; @todo Add timeout 5? seconds, if no input, close and save
	SendInput {Tab}{Space}
	; Auto apply hotlist?
	SendInput {Tab 2}{Space}
return



; @todo add Hostrings for comments
; http://www.autohotkey.com/docs/Hotstrings.htm