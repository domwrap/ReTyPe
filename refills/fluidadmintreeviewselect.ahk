/**
 * File containing Refill class to make Administration treeviews larger and more useable
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
objRetype.refill( new FluidAdminTreeViewSelect() )


/**
 * Refill to make Administration treeview menus larger
 *
 * @category	Automation
 * @package		ReTyPe
 * @author		Dominic Wrapson <dwrapson@whistlerblackcomb.com>
 * @copyright	2014 Dominic Wrapson
 */
class FluidAdminTreeViewSelect extends Fluid {

	static intTimer		:= 500

	pour() {
		global objRetype
; @todo Goes a bit nuts if you open the Go Menu (and always thereafter even if you close it again)
; @todo Change "Browse" to "Browse Bigger" to be an indicator it's already been changed?
		; Administration select listview
		strGroup	:= this.__Class
		strRTP		:= % objRetype.objRTP.classNN()
		GroupAdd, %strGroup%, ahk_class %strRTP%, Browse

		IfWinActive, ahk_group %strGroup%
		{
			; WinActive check isn't good enough in this case, so need to make a visual search too
			ImageSearch intActiveX, intActiveY, 554, 65, 725, 105, %A_ScriptDir%\img\search_fluidadmintreeviewselect_active.png
			ImageSearch intInactiveX, intInactiveY, 554, 65, 725, 105, %A_ScriptDir%\img\search_fluidadmintreeviewselect_inactive.png
			;ImageSearch intBrowseX, intBrowseY, 550, 90, 800, 130, %A_ScriptDir%\img\search_fluidadmintreeviewselect_browse.png
			ImageSearch intMenuX, intMenuY, 150, 400, 300, 550, %A_ScriptDir%\img\search_fluidadmintreeviewselect_gomenu.png
;msgbox % intMenuX " - " intMenuY
			strControlTreeview := objRetype.objRTP.formatClassNN( "SysTreeView32", this.getConf( "Treeview", 11 ) )
			;strControlTreeview := "WindowsForms10.SysTreeView32.app.0.30495d1_r9_ad11"
			ControlGetPos, , , intTreeW, intTreeH, %strControlTreeview%, A
			;ControlGetPos, , , intTreeW, intTreeH, WindowsForms10.SysTreeView32.app.0.30495d1_r9_ad111, A
;msgbox % intTreeW " - " intTreeH
			; Make sure it's been found
			;if ( ( ( 0 < intActiveX & 0 < intActiveY ) OR ( 0 < intInactiveX & 0 < intInactiveY ) ) AND ( 0 < intBrowseX & 0 < intBrowseY ) )  {
			if ( ( 300 > intTreeH ) AND ( ( 0 < intActiveX & 0 < intActiveY ) OR ( 0 < intInactiveX & 0 < intInactiveY ) ) AND ( !intMenuX & !intMenuY ) )  {
			;if ( ( 0 < intActiveX & 0 < intActiveY ) OR ( 0 < intInactiveX & 0 < intInactiveY ) ) {
				; Get RTP window size and resize relative
				WinGetPos, , , intRtpW, intRtpH, A

				; Array of controls that all need to be resized, with their sizes relative to RTP window (75%)
				arrControls := {}
				strControlButton := objRetype.objRTP.formatClassNN( "Window.8", this.getConf( "Button", 19 ) )
				arrControls.Insert( { strControl:strControlButton, intWx:291, intHx:16 } ) ; X button
				; strControlTreeview already defined above
				arrControls.Insert( { strControl:strControlTreeview, intWx:275, intHx:Floor((intRtpH*0.7)-25) } ) ; Product treeview
				strControlFieldset := objRetype.objRTP.formatClassNN( "Window.8", this.getConf( "Fieldset", 111 ) )
				arrControls.Insert( { strControl:strControlFieldset, intWx:285, intHx:((intRtpH*0.7)) } ) ; Browse Fieldset

				; Loop controls and action width and height changes
				for intIndex, objControl in arrControls {
;MSgBox % objControl.strControl " - " objControl.intWx " - " objControl.intHx
					ControlMove, % objControl.strControl, , , % objControl.intWx, % objControl.intHx, A
				}

			}

		}
	}

}



