/**
 * Here be object for building and displaying progress splash screens
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
 * Class for making pretty progress bars
 *
 * @category	Automation
 * @package		ReTyPe
 * @author		Dominic Wrapson <hwulex[åt]gmail[dõt]com>
 * @copyright	2014 Dominic Wrapson
 */
class Progress {

	strFileConf		:= "conf\app.ini"
	strTitle 		:= "Progress"
	strMainText 	:= ""
	strSubText 		:= ""
	strFont 		:= "FS1"
	intStart		:= 0
	intEnd 			:= 0
	intProgress 	:= 0

	/**
	 * Constructor: Initialise all required parameters, which also kicks-off the progress dialog
	 */
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

	/**
	 * Destructor: if the progress class is no longer being used, make sure we wrap things up and destroy it
	 */
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

	/**
	 * Progress the bar, with optional message
	 */
	update( intProgress, strText=false ) {
		this.intProgress := intProgress
		this.p_progress( intProgress, strText )
	}

	/**
	 * Manually finish the dialogue
	 * @deprecated for automagical finishing
	 */
	finish() {
		;this.__Delete()
	}

	/**
	 * Internal-only method that makes the update magic happen
	 * AHK has no visibility scope so p_ prefix for private
	 */
	p_progress( mixParam, strSubText=false, strMainText=false, strTitle=false, strFont=false ) {
		strSubText	:= ( false = strSubText )	? this.strSubText 	: ( 0 = StrLen( strSubText ) ) ? " " : strSubText
		strMainText := ( false = strMainText )	? this.strMainText 	: strMainText
		strTitle 	:= ( false = strTitle )		? this.strTitle 	: strTitle
		strFont 	:= ( false = strFont )		? this.strFont 		: strFont

		; Draw stuff
		Progress, %mixParam%, %strSubText%, %strMainText%, %strTitle%, %strFont%
	}

}