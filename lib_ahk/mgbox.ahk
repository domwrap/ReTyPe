/**
 * Here be object for facilitating message popup boxes
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

 /**
 * Class wrapper for AHK msgbox
 * Facilitates message boxes for certain types (error, retry, yes/no, etc)
 * Whether program should exit after a stop error
 * Also does some fancy stuff to center the message against the parent window, which
 *		is particilarly nice on 39" 4K screens like we use as small windows are easily lost
 *
 * @category	Automation
 * @package		lib_ahk
 * @author		Dominic Wrapson <hwulex[åt]gmail[dõt]com>
 * @copyright	2014 Dominic Wrapson
 */
class MgBox {

	static blnConf		:= false
	static strTitle 	:= "Message"
	static strFileConf	:= "conf\app.ini"

	/**
	 * Display critical error dialog
	 * Exit if requested
	 */
	stop( strMessage, blnExit=True ) {
		; Add period at end of message if not sent
		strMessage := ( "." != SubStr( strMessage, StrLen( strMessage ), 1 ) ) ? strMessage "." : strMessage
		; If exiting, add message to say so
		;strMessage := ( True = blnExit ) ? strMessage " Exiting" : strMessage

		; Do the actual msgbox
		ErrorLevel := this.show( strMessage, 16, "Fatal Error" )

		; Exit if requested, else return status
		if ( True = blnExit ) {
			exit
		} else {
			return ErrorLevel
		}
	}

	error( strMessage ) {
		return this.show( strMessage, 48, "Error!" )
	}

	retry( strMessage ) {
		return this.show( strMessage, 69, "Retry?" )
	}

	yesno( strMessage ) {
		return this.show( strMessage, 36, "Continue?" )
	}

	info( strMessage ) {
		return this.show( strMessage, 32, "Info" )
	}

	tryagain( strMessage ) {
		return this.show( strMessage, 70, "Try Again?" )
	}

	show( strMessage, intType=0, strTitle="", intTimeout=0 ) {
		; Some pre-built stuff
		this.p_conf()

		; Build title
		strTitle := ( 0 < StrLen( strTitle ) ) ? this.strTitle ": " strTitle : this.strTitle

		; Make popups always on top
		intType += 4096

		; Show the actual box
		MsgBox, % intType, %strTitle%, % strMessage	
		return ErrorLevel
	}

	p_conf() {
		this.blnConf := true
		IniRead, strTitle, % this.strFileConf, Conf, Title, % this.strTitle
		this.strTitle := strTitle
	}

}

; Message icon use 
; http://ux.stackexchange.com/questions/52727/what-are-the-the-best-error-message-icons-to-use-for-each-type-of-error-in-net
