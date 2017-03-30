/**
 * File containing Refill class to facilitate updating multiple display orders on a product header category
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
 * @author		Dominic Wrapson <dwrapson@whistlerblackcomb.com>
 * @copyright	2014 Dominic Wrapson
 * @license		GNU AFFERO GENERAL PUBLIC LICENSE Version 3, 19 November 2007 http://www.gnu.org/licenses/
 */


; Trigger my damn self (in a horrible way due to AHK limitations)
objRetype.refill( new FluidProductCategoryOrdering() )


/**
 * Refill to automatically update X display orders on a product header category
 *
 * @category	Automation
 * @package		ReTyPe
 * @author		Dominic Wrapson <dwrapson@whistlerblackcomb.com>
 * @copyright	2015 Dominic Wrapson
 */
class FluidProductCategoryOrdering extends Fluid {


	strHotkey		:= "^!o"
	strMenuPath		:= "/Admin/Product"
	strMenuText		:= "Category Display Ordering"
	intMenuIcon		:= 214

	/**
	 * Where the magic happens
	 */
	pour() {
		global objRetype
		; Static variable that maintains its value between executions, so can be used as the new default value in the Iterate prompt
		static intIterate 		:= 1
		static intIncrement 	:= 10

		strGroup	:= this.__Class
		strRTP		:= % objRetype.objRTP.classNN()
		GroupAdd, %strGroup%, Create A Display Category ahk_class %strRTP%, eStore Display Type
		GroupAdd, %strGroup%, Update ahk_class %strRTP%, eStore Display Type

		; Activate RTP (after toolbar has been clicked)
		objRetype.objRTP.Activate()

; @todo Check needs to be removed once I've managed to wall-in shortcuts in to the RTP only window
		; Run if it's ready!
		IfWinActive, ahk_group %strGroup%
		{
			; Did you execute from an RTP window?
			if ( objRetype.objRTP.isActive() ) {
				idWinRTP	:= WinActive("A")

				; Check that appropriate form control is focused before continuing
				strControlList := objRetype.objRTP.formatClassNN( "Window.8", this.getConf( "ListProductHeaders", 12 ) )
				if ( Window.CheckControlFocus( strControlList, "Product Headers listview" ) ) {

					intIterate 		:= InputBox.Show( "Update how many headers?", 1 )
					intIncrement	:= InputBox.Show( "Increment each Display Order by?", 10 )
					intDisplayOrder := InputBox.Show( "Starting from what value?", intIncrement )

					Send ^{Space 2}{Space}{Right 2}

					Loop %intIterate%
					{
						Send %intDisplayOrder%{Down}
						intDisplayOrder += intIncrement
					}

				}
 
			}
		}
	}


}