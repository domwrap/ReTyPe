/**
 * File containing Refill class to en/dis-able toolbar buttons based on RTP availability
 *
 * AutoHotKey v1.1.13.01+
 *
 * LICENSE:
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Affero General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.

 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Affero General Public License for more details.

 * You should have received a copy of the GNU Affero General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 *
 * @category  	Automation
 * @package   	ReTyPe
 * @author    	Dominic Wrapson <dwrapson@whistlerblackcomb.com>
 * @copyright	Copyright (C) 2016 Dominic Wrapson
 * @license 	GNU AFFERO GENERAL PUBLIC LICENSE http://www.gnu.org/licenses/agpl-3.0.txt
 */


; Trigger my damn self (in a horrible way due to AHK limitations)
objRetype.refill( new FluidToolbarButtonContext() )


/**
 * Refill contextually en/dis-able toolbar buttons
 *
 * @category	Automation
 * @package		ReTyPe
 * @author		Dominic Wrapson <dwrapson@whistlerblackcomb.com>
 * @copyright	2016 Dominic Wrapson
 */
class FluidToolbarButtonContext extends Fluid {

	intTimer := 1000

	pour() {
		global objRetype, _d

		for strFluid, objFluid in objRetype.arrHotkeys {
strFluid := objFluid.__Class
WinGet, list, List, ahk_group %strFluid%
; ListVars
			IfWinActive, ahk_group %strFluid%
			{
;msgbox, list(%list%)
			}
		}

	}


}
