/**
 * Here be some debug functions for ReTyPe framework
 *
 * AutoHotKey v1.1.13.01+
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Affero General Public License as published
 * by the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 * 
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Affero General Public License for more details.
 * 
 * You should have received a copy of the GNU Affero General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 *
 * @category	Automation
 * @package		lib_ahk
 * @author		Dominic Wrapson <hwulex[åt]gmail[dõt]com>
 * @copyright	2014 Dominic Wrapson
 * @license		GNU AFFERO GENERAL PUBLIC LICENSE Version 3, 19 November 2007 http://www.gnu.org/licenses/
 */

#Include %A_ScriptDir%\lib_ahk\AHK-Lib-JSON\JSON_FromObj.ahk
#Include %A_ScriptDir%\lib_ahk\AHK-Lib-JSON\JSON_ToObj.ahk
#Include %A_ScriptDir%\lib_ahk\Class_Console\Class_Console.ahk

 /**
 * Class for debug information and writing to log file
 *
 * @category	Automation
 * @package		lib_ahk
 * @author		Dominic Wrapson <hwulex[åt]gmail[dõt]com>
 * @copyright	2014 Dominic Wrapson
 */
class Debug extends console {

	; static _env 	:= "dev"
	; static _strFileLog	= "debug.log"
	; static _d :=

	__New() {
		; @todo use ini environment parameter (dev/prod)

		; @todo Do we need headers?
		; @todo Maybe store in JSON
		FileAppend, Headers, this._strFileLog


		; Build console
		; if ( "dev" = this._env AND 1 != A_IsCompiled ) {
			; d.new console("title", 100, 100, 500, 300, 1)
		; }

		return this._d()
	}



	_d() {
		; if ( IsObject( this._d ) = 0 ) {
Class_Console("VariableList",100,100,400,600,"Variable List")
VariableList.log("Variable List:This is working")
VariableList.show()
		; }
msgbox.show( "ere")
		return VariableList
	}


/*

	log( e ) {
		if ( isObject( e ) ) {
			; Add Date and Time to exception to log
			e.date := Date

			; Encode exception
			strDebug := this.jsonEncode( e ) "`n"
			;~ strDebug := % "Exception thrown{when:" A_Now "|what:" e.what "|file:" e.file "|line:" e.line "|message:" e.message "|extra:" e.extra "}`n"
			strFile := this._strFileLog
			FileAppend, %strDebug%, %strFile%
		} else {
			; @todo some array shit
		}
	}
*/



/*
	out( mixVar ) {
		this.d().log( mixVar )
	}
*/


	/**
	 * Environment dependant debug message output that will also show stack-trace of from where it was called
	 * @see https://gist.github.com/hoppfrosch/7672038
	 *
	 * @param String strMessage Debug message to be displayed along with stack-trace
	 * @return void
	 */
	msg( strMessage="" ) {
		; Should we read and display line of code in output?
		blnCode := false

		; Only do this if we're in a dev environment otherwise we don't want debug info (like in Prod)
		; And if we're running in a non-compiled environment (which we can infer is dev/testing)
		if ( "dev" = this._env AND 1 != A_IsCompiled ) {
			; Instantiate exceptions to grab necessary stack-trace info
			objTrace := Exception("", -1)
			objTracePrev := Exception("", -2)

			; Only read-file for code if required
			if ( blnCode ) {
				FileReadLine, strLine, % objTrace.file, % objTrace.line
				StringReplace, strLine, strLine, `t, 
			}

			; Strip full-path leaving just sub-directory and filename
			strFile := SubStr( objTrace.file, StrLen( A_ScriptDir )+2, 100 )

			; Concatenate together for stack trace
			strStack := "File:`t" strfile "`nLine:`t" objTrace.line (objTracePrev.What = -2 ? "" : "`nIn:`t" objTracePrev.What) (blnCode ? "`nCode:`t" strLine : "") "`n`n"

			; Display trace and message
			msgbox % strStack strMessage
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