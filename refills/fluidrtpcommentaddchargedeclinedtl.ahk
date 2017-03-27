
objRetype.refill( new FluidRTPCommentAddChargeDeclineDTL() )

; @todo Make generic commenting class (with prompt), and extend to pass admin / config file editable sub-class
class FluidRTPCommentAddChargeDeclineDTL extends Fluid {

	;strHotkey		:= "^!+c"
	strMenuPath		:= "/CusMan/Comments"
	strMenuText		:= "Declined DTL"
	;intMenuIcon		:= 217 ; or 133

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
idIPCode = 2993249

				objRetype.objRTP.Activate()
				objRetype.objRTP.CustomerSearchAndSelect( idIPCode )
/*
				Window.ActivateRestore( idWinExcel )

				; Reset row
				Send {Home}
				; Grab info
				Send {Right 7}^c
				StringReplace, intSaleDate, clipboard, `r`n
				Send {Right}^c
				StringReplace, intAmountOwed, clipboard, `r`n
				Send {Right}^c
				StringReplace, strCreditCard, clipboard, `r`n
*/
				objRetype.objRTP.Activate()
				objRetype.objRTP.CustomerSearchAndSelect( idIPCode )

				strSubject = Owes %intAmountOwed% (DTL charge)
				strComment = For %intSaleDate%. Need to check CC %strCreditCard% on file.  Emailed guest.  %strUsername% x7055
				objRetype.objRTP.CustomerAddComment( strSubject, strComment )
			}
		}
	}

}