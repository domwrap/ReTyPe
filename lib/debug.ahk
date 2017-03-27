#Include AHK-Lib-JSON\JSON_FromObj.ahk
#Include AHK-Lib-JSON\JSON_ToObj.ahk

class Debug {

	static strFileLog	= "debug.log"

	__New() {
		; @todo Do we need headers?
		; @todo Maybe store in JSON
		FileAppend, Headers, this.strFileLog
	}


	log( e ) {
		if ( isObject( e ) ) {
			strDebug := this.jsonEncode( e ) "`n"
			;~ strDebug := % "Exception thrown{when:" A_Now "|what:" e.what "|file:" e.file "|line:" e.line "|message:" e.message "|extra:" e.extra "}`n"
			strFile := this.strFileLog
			FileAppend, %strDebug%, %strFile%
		} else {
			; @todo some array shit
		}
	}

; @todo abstract json in to its own class
	jsonDecode( strJSON ) {
		return json_toobj( strJSON )
	}


	jsonEncode( objObject ) {
		return json_fromobj( objObject )
	}

}