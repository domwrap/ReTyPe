
objRetype.refill( new FluidRTPHotlistAdd() )

; @todo Make generic commenting class (with prompt), and extend to pass admin / config file editable sub-class
class FluidRTPHotlistAdd extends Fluid {

	;strHotkey		:= "^!+c"
	strMenuPath		:= "/CusMan"
	strMenuText		:= "Add Hotlist"
	intMenuIcon		:= 272

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
		objRetype.objRTP.Activate()

		strGroup := this.__Class
		IfWinActive, ahk_group %strGroup%
		{
			; WinActive check isn't good enough in this case, so need to make a visual search too
			ImageSearch intActiveX, intActiveY, 20, 60, 60, 100, %A_ScriptDir%\img\search_icon_customermanager.png
			if ( ErrorLevel ) {
				; At this point we are not in customer manager
				MsgBox.error( "Can only be run from within Customer Manager" )
			} else {
				; In customer manager, let's rock

				; Hunt down the customer
				objRetype.objRTP.CustomerSearchAndSelect( idIPCode )
return
; @todo SOME CHECKS: Make sure customer is an adult, etc, if PassAdmin want to, else let them decide first and just hit hotlist as appropriate
/*
				blnLoadedPassMediaProfile := _screenImageSearch( 100, 100, 500, 200, "img\search_cusman_passmediaprofile.png" )
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

						if ( !_screenImageSearch( 290, 110, 460, 150, "img\cussearch_cusman_smediaprofile.png" ) )
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
*/
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
				strControl := objRetype.objRTP.formatClassNN( "COMBOBOX", this.getConf( "ComboBox", 16 ) )
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
			}
		}
	}

}