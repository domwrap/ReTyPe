
objRetype.refill( new FluidProductDeletePricing() )

class FluidProductDeletePricing {

	static id			:= "FluidProductDeletePricing"

	fill() {
		; build class.method to pass through (cannot do it inline)
		strMethod := % this.id ".pour"

		; Bind and add the hotkey
Hotkey, IfWinActive, Update ahk_class Rtp.getClassNN(), Available Offline
		Hotkey.add( "!^x", strMethod, "" )
		Hotkey, IfWinActive, Add ahk_class WindowsForms10.Window.8.app.0.30495d1_r11_ad1, Available Offline
		Hotkey.add( "!^x", strMethod, "" )


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
		If WinActive( Update ahk_class WindowsForms10.Window.8.app.0.30495d1_r11_ad1, Available Offline )
			OR WinActive ( Add ahk_class WindowsForms10.Window.8.app.0.30495d1_r11_ad1, Available Offline )
		{
			if ( Window.CheckActiveProcess( "rtponecontainer" ) ) {
msgbox pour
			}
		}
	}

}