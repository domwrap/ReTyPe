#NoEnv
#Persistent
#SingleInstance Force


#Include RTP_Functions.ahk

; Stop functions exiting on fail
RETURN_ON_USER_CANCEL := True

; Load timer
SetTimer, fnTimer, 100

OnExit,fnExit



; @todo Need to figure out how it focuses on the CURRENT RTP window
;)()#$%()ERF()ZSE(T)W$(%)WESF()SD(F)SD(FZS(%)#$(%)(T)(E)SDZ



fnTimer:
	; Get RTP window for later reference
	WinGet, idWinRTP, ID, RTP|ONE Container ahk_class WindowsForms10.Window.8.app.0.30495d1_r11_ad1

	; Hide the RTP toolbar if window is minimized
	WinGet, intWinRtpMinMax, MinMax, ahk_id %idWinRTP%
	If ( -1 = intWinRtpMinMax ) {
		Gui, RtpToolbar:Hide
	} else {
		IfWinActive, ahk_id %idWinRTP%
		{
			; Find window position
			WinGetPos, intWinX, intWinY, intWinW, intWinH
			intGuiX := intWinX + intWinW - ( intWinW / 2 ) + 50
			intGuiY := intWinY + 2
			;PixelGetColor, rgbRtpTitle, % intGuiX-3, %intGuiY%, RGB

			Gui, RtpToolbar:Margin, 0, 0
			Gui, RtpToolbar:Add, Button, x0 y0, G
			Gui, RtpToolbar:Add, Button, ym, P
			Gui, RtpToolbar:Add, Button, ym, C
			Gui, RtpToolbar:Add, Button, ym, D
			Gui, RtpToolbar:Add, Button, ym, U
			;Gui, Color, %rgbRtpTitle%
			WinSet, Transparent, 150, RtpToolbar
			;WinSet, TransColor, %rgbRtpTitle% 150, RtpToolbar
			Gui, RtpToolbar:-SysMenu +ToolWindow -Caption -Border +AlwaysOnTop
			Gui, RtpToolbar:Show, NA x%intGuiX% y%intGuiY%, RtpToolbar

			;Gui, Submit, NoHide
		}
	}
	IfWinNotExist, ahk_id %idWinRTP%
	{
		Gui, RtpToolbar:Hide
	}
	IfWinNotActive, ahk_id %idWinRTP%
	{
		Gui, RtpToolbar:Hide
	}



	; BULK PRICING:	Resize the pricing season drop-down
	IfWinActive, Product Header Pricing Bulk Update ahk_class WindowsForms10.Window.8.app.0.30495d1_r11_ad1, Selected Price Update Details
	{
		if ( _windowCheckActiveProcess( "rtponecontainer" ) ) {
			strControl = WindowsForms10.COMBOBOX.app.0.30495d1_r11_ad11
			ControlMove, %strControl%, , , 400, , A
		}
	}



	; PRICING UPDATE:	Enable the pricing season dropdown
	IfWinActive, Pricing ahk_class WindowsForms10.Window.8.app.0.30495d1_r11_ad1, Price Allocation
	{
		strControl = WindowsForms10.COMBOBOX.app.0.30495d1_r11_ad11
		ControlGet, blnCtl, Enabled,, %strControl%
		if ( !blnCtl ) {
			WinGetPos, intWinX, intWinY,,,
			ControlGetPos, intCtlX, intCtlY,,, %strControl%,
			intGuiX := intWinX + intCtlX -53
			intGuiY := intWinY + intCtlY -1
			Gui, Pricing:Add, Button, x0 y0 gfnEnablePricingSeasonCombo, Enable?
			Gui, Pricing:Margin, 0, 0
			Gui, Pricing:-SysMenu +ToolWindow -Caption -Border +AlwaysOnTop
			Gui, Pricing:Show, NA x%intGuiX% y%intGuiY%
		}
	}
	IfWinNotExist, Pricing ahk_class WindowsForms10.Window.8.app.0.30495d1_r11_ad1, Price Allocation
	{
		Gui, Pricing:Hide
	}


return



fnEnablePricingSeasonCombo:
	WinGet, idWin, ID, Pricing ahk_class WindowsForms10.Window.8.app.0.30495d1_r11_ad1, Price Allocation

	strControl = WindowsForms10.COMBOBOX.app.0.30495d1_r11_ad11
	Control, Enable, , %strControl%, ahk_id %idWin%
	WinActivate, Pricing ahk_id %idWin%

	Gui, Pricing:Hide
return



fnCancel:
	Gui, Pricing:Destroy
	Gui, RtpToolbar:Destroy
	; Hide anything made hidden further down
return


fnExit:
	Gosub, fnCancel
	ExitApp