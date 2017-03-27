
objRetype.refill( new FluidRTPCommentAddDeclineChargeGuestSpoken() )

; @todo Make generic commenting class (with prompt), and extend to pass admin / config file editable sub-class
class FluidRTPCommentAddDeclineChargeGuestSpoken extends Fluid {

	strMenuPath		:= "/CusMan/Comments"
	strMenuText		:= "Guest Spoken To"
	;intMenuIcon		:= 217

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
				; ( "Nothing happening here yet" )
return
/*
	strGuest := _InputBox( "With whom did you speak?" )
; @todo Check for blank input

	_windowActivateRestore( idWinRTP )
	_rtpCustomerSearchAndSelect( idIPCode )

	strSubject = Phoned guest, spoke to %strGuest%
	strComment = Re: RC charge owing.  Guest says they will contact their CC company and remove the hold.  Will call us back when we can retry CC.  %strUsername% x7055
	_rtpCustomerAddComment( strSubject, strComment )
*/
			}
		}
	}

}