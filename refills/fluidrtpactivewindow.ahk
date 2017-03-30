/**
 * File containing Refill class to track current RTP instance
 * Class will add itself to the parent retype instance
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


; Trigger my damn self (in a horrible way due to AHK limitations)
objRetype.refill( new FluidRTPActiveWindow() )


/**
 * Refill for tracking the active RTP instance
 *
 * @category	Automation
 * @package		ReTyPe
 * @author		Dominic Wrapson <hwulex[åt]gmail[dõt]com>
 * @copyright	2014 Dominic Wrapson
 */
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

	pour() {
		global objRetype

		; BULK PRICING:	Resize the pricing season drop-down
		strGroup := this.id
		IfWinActive, ahk_group %strGroup%
		{
			objRetype.objRTP.setID( WinActive( ahk_group %strGroup% ) )
		}
	}

}