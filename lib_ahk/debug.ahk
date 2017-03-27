#Include AHK-Lib-JSON\JSON_FromObj.ahk
#Include AHK-Lib-JSON\JSON_ToObj.ahk

class Debug {

	static env 	:= "dev"
	static strFileLog	= "debug.log"

	__New() {
		; @todo use ini environment parameter (dev/prod)

		; @todo Do we need headers?
		; @todo Maybe store in JSON
		FileAppend, Headers, this.strFileLog
	}

	log( e ) {
		if ( isObject( e ) ) {
			; Add Date and Time to exception to log
			e.date := Date

			; Encode exception
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

	exploreObj(Obj, NewRow="`n", Equal="  =  ", Indent="`t", Depth=12, CurIndent="") { 
		for k,v in Obj
			ToReturn .= CurIndent . "[ " . k . " ]" . (IsObject(v) && depth>1 ? NewRow . this.exploreObj(v, NewRow, Equal, Indent, Depth-1, CurIndent . Indent) : Equal . v) . NewRow
		return RTrim(ToReturn, NewRow)
	}

}