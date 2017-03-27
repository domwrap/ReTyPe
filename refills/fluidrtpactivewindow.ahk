
objRetype.refill( new FluidRTPActiveWindow() )

class FluidRTPActiveWindow extends Fluid {

	static intTimer	:= 50
	intComboBox		:=


	__New() {
		global objRetype
		base.__New()

		strClassRTP		:= % objRetype.objRTP.classNN()
		strTitleRTP		:= % objRetype.objRTP.strTitle
		strGroup		:= this.id
		GroupAdd, %strGroup%, ahk_class %strClassRTP%
		;GroupAdd, %strGroup%, %strTitleRTP% ahk_class %strClassRTP%
	}


	fill() {

	}


	pour() {
		global objRetype

		strGroup := this.__Class
		IfWinActive, ahk_group %strGroup%
		{
			objRetype.objRTP.setID( WinActive( ahk_group %strGroup% ) )
		}
	}

}