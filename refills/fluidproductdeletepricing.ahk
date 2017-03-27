
objRetype.refill( new FluidProductDeletePricing() )

class FluidProductDeletePricing extends Fluid {


	;strHotkey := "!^x"


	__New() {
		strGroup := this.id
		GroupAdd, %strGroup%, Add ahk_class WindowsForms10.Window.8.app.0.30495d1_r11_ad1, Available Offline
		GroupAdd, %strGroup%, Update ahk_class WindowsForms10.Window.8.app.0.30495d1_r11_ad1, Available Offline
; @todo Hotkey, IfWinActive, Update ahk_class % Rtp.ClassNN, Available Offline

	;~ ; Group the RTP and Retype windows together as it's the only way !WinActive will work
	;~ GroupAdd, grpWinRtp, ahk_id %idWinRTP%
	;~ GroupAdd, grpWinRtp, ahk_id %idWinRetype%
	;~ If !WinActive("ahk_group grpWinRtp")
	;~ {
	}


	pour() {
; @todo if rtp.window( "visible text" )
; Can also check process (rtpone.exe), abstract more code

		; BULK PRICING:	Resize the pricing season drop-down
		strGroup := this.__Class
		IfWinActive, ahk_group %strGroup%
		{
			if ( Window.CheckActiveProcess( "rtponecontainer" ) ) {
msgbox pour
			}
		}
	}

}