
objRetype.refill( new FluidCommentAddDeclineChargeGuestSpoken() )

; @todo Make generic commenting class (with prompt), and extend to pass admin / config file editable sub-class
class FluidCommentAddDeclineChargeGuestSpoken extends Fluid {

	strMenuPath		:= "/CusMan/Comments"
	strMenuText		:= "Guest Spoken To"
	intMenuIcon		:= 161

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
			ImageSearch intActiveX, intActiveY, 20, 60, 60, 100, *50 %A_ScriptDir%\img\search_icon_customermanager.png
			if ( ErrorLevel ) {
				; At this point we are not in customer manager
				MsgBox.error( "Can only be run from within Customer Manager" )
			} else {
				; In customer manager, let's get IP code input
				intIP 			:= InputBox.show( "Enter IP code on which to comment" )
				; IP Validation
; @todo Validation
				; 6 <= Len( IP ) <= 7

				; Name of contact
				strGuest		:= InputBox.show( "With whom did you speak?" )
				; Check for blank input

				; Make sure in RTP, then find customer
				objRetype.objRTP.Activate()
				objRetype.objRTP.CustomerSearchAndSelect( intIP )

				; Construct subject and comment
				strSubject = Phoned guest, spoke to %strGuest%
				strComment = Re: RC charge owing. Guest says they will contact their CC company and remove the hold. Will call us back when we can retry CC. %A_UserName% x7055

				; Add comment to profile
				objRetype.objRTP.CustomerAddComment( strSubject, strComment )
/*
	strSubject = Phoned guest, spoke to %strGuest%
	strComment = Re: RC charge owing.  Guest says they will contact their CC company and remove the hold.  Will call us back when we can retry CC.  %strUsername% x7055
*/
			}
		}
	}

}