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
 * @package		ReTyPe
 * @author		Dominic Wrapson <dwrapson@whistlerblackcomb.com>
 * @copyright	2014 Dominic Wrapson
 * @license		GNU AFFERO GENERAL PUBLIC LICENSE Version 3, 19 November 2007 http://www.gnu.org/licenses/
 */

#Include %A_ScriptDir%\lib_ahk\AHK-Lib-JSON\JSON_FromObj.ahk
#Include %A_ScriptDir%\lib_ahk\AHK-Lib-JSON\JSON_ToObj.ahk

 /**
 * Class for debug information and writing to log file
 *
 * @category	Automation
 * @package		ReTyPe
 * @author		Dominic Wrapson <dwrapson@whistlerblackcomb.com>
 * @copyright	2014 Dominic Wrapson
 */
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
			; @todo some array stuff
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