
class Progress {

	strFileConf		:= "conf\app.ini"
	strTitle 		:= "Progress"
	strMainText 	:= ""
	strSubText 		:= ""
	strFont 		:= "FS1"
	intStart		:= 0
	intEnd 			:= 0
	intProgress 	:= 0

	__New( intStart, intEnd, strSubText, strMainText=false, strFont=false, intX=false, intY=false, strColor=false ) {
		IniRead, strTitle, % this.strFileConf, Conf, Title, % this.strTitle
		this.strTitle 		:= strTitle

		this.strMainText 	:= ( false = strMainText ) ? strTitle : ( 0 = StrLen( strMainText ) ) ? " " : strMainText
		this.strSubText 	:= strSubText
		this.strFont 		:= strFont
		this.intStart		:= intStart
		this.intEnd 		:= intEnd

		intX 				:= intX ? "X" intX : ""
		intY 				:= intY ? "X" intY : ""
		strColor			:= strColor ? "CB" strColor : ""

		this.p_progress( "b R" intStart "-" intEnd " " intX " " intY " " strColor, strSubText, strMainText, false, strFont )
	}

	__Delete() {
		; Loop to stick it to the end before closing so it at least looks like it finished
		intProgress := this.intEnd - this.intProgress
		Loop, % intProgress +1 {
			this.update( intProgress++, "Finishing" )
			Sleep 10
		}
		Sleep 300

		SplashImage,Off
		Progress, Off
	}

	update( intProgress, strText=false ) {
		this.intProgress := intProgress
		this.p_progress( intProgress, strText )
	}

	finish() {
		;this.__Delete()
	}

	p_progress( mixParam, strSubText=false, strMainText=false, strTitle=false, strFont=false ) {
		strSubText	:= ( false = strSubText )	? this.strSubText 	: ( 0 = StrLen( strSubText ) ) ? " " : strSubText
		strMainText := ( false = strMainText )	? this.strMainText 	: strMainText
		strTitle 	:= ( false = strTitle )		? this.strTitle 	: strTitle
		strFont 	:= ( false = strFont )		? this.strFont 		: strFont

		; Draw stuff
		Progress, %mixParam%, %strSubText%, %strMainText%, %strTitle%, %strFont%
	}

}