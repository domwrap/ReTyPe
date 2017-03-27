
objRetype.refill( new FluidCommentAddChargeDeclineRC() )

; @todo Make generic commenting class (with prompt), and extend to pass admin / config file editable sub-class
class FluidCommentAddChargeDeclineRC extends Fluid {

	strMenuPath		:= "/CusMan/Comments"
	strMenuText		:= "Declined Resort Charge"
	intMenuIcon		:= 66

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

				; Get sale date, format (mm/dd/yyyy)
				intSaleDate		:= InputBox.show( "Enter charge date", "mm/dd/yyyy" )
				; isDate( )

				; Get total owed (decimal)
				intAmountOwed	:= InputBox.show( "Enter charge amount (without $ prefix)" )

				objRetype.objRTP.Activate()
				objRetype.objRTP.CustomerSearchAndSelect( intIP )

				strSubject = Owes $%intAmountOwed% (RC charge)
				strComment = For %intSaleDate%. Need to check CC on file. Emailed guest. %A_UserName% x7055
				objRetype.objRTP.CustomerAddComment( strSubject, strComment )
			}
		}
	}

}