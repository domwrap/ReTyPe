/**
 * Here be object wrapper for AHK send command
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
 * @author		Dominic Wrapson <hwulex[åt]gmail[dõt]com>
 * @copyright	2014 Dominic Wrapson
 * @license		GNU AFFERO GENERAL PUBLIC LICENSE Version 3, 19 November 2007 http://www.gnu.org/licenses/
 */

 /**
 * Class wrapper for AHK send command
 * Includes methods for different send types (allowing interaction with RTP's notoriously fussy date fields)
 *
 * @category	Automation
 * @package		ReTyPe
 * @author		Dominic Wrapson <hwulex[åt]gmail[dõt]com>
 * @copyright	2014 Dominic Wrapson
 */
class Send {

	static mode := 0

	__New( strInput, intMode ) {
; @todo Test if this allows Send( "text" )
		this.input( strInput, intMode )
	}

	; Bump year by two (up or down) to circumvent RTP's date naziism
; @todo Make this work for leap years, which will make Terry very happy
	date( dtDate, blnUp=1 ) {
		intValid := RegExMatch( dtDate, "^(0?[1-9]|1[012])[- /.](0?[1-9]|[12][0-9]|3[01])[- /.](19|20)\d\d$" )
		if ( 1 > intValid ) {
			return False
		}

		Send {right 2}
		If blnUp
			Send {Up 2}
		else
			Send {Down 2}
		Send {left 2}
		Loop, parse, dtDate, /
		{
			Send %A_LoopField%{right}
		}
		return True
	}

	input( strInput, intMode=false ) {
		if ( false = intMode ) {
			intMode := this.mode
		}

		if ( 1 = intMode ) {
			SendInput %strInput%
		} else if ( 2 = intMode ) {
			SendRaw %strInput%
		} else if ( 3 = intMode ) {
			SendPlay %strInput%
		} else {
			Send %strInput%
		}
	}

}