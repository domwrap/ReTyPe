/**
 * File containing Refill class to make Administration treeviews larger and more useable
 * Class will add itself to the parent retype instance
 *
 * AutoHotKey v1.1.13.01+
 *
 * LICENSE: This work is licensed under a version 4.0 of the
 * Creative Commons Attribution-ShareAlike 4.0 International License
 * that is available through the world-wide-web at the following URI:
 * http://creativecommons.org/licenses/by-sa/4.0/deed.en_US
 *
 * @category	Automation
 * @package		ReTyPe
 * @author		Dominic Wrapson <dwrapson@whistlerblackcomb.com>
 * @copyright	2014 Dominic Wrapson
 * @license		Creative Commons Attribution-ShareAlike 4.0 International License http://creativecommons.org/licenses/by-sa/4.0/deed.en_US
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

	/**
	 * Setup controls, window group, etc
	 */
	__New() {
		global objRetype
		base.__New()

		strGroup := this.id
		strRTP		:= % objRetype.objRTP.classNN()
		GroupAdd, %strGroup%, ahk_class %strRTP%, Browse
	}


	pour() {
; @todo Goes a bit nuts if you open the Go Menu (and always thereafter even if you close it again)
; @todo Change "Browse" to "Browse Bigger" to be an indicator it's already been changed?
		; Administration select listview
		strGroup := this.__Class
		IfWinActive, ahk_group %strGroup%
		{
			; WinActive check isn't good enough in this case, so need to make a visual search too
			ImageSearch intActiveX, intActiveY, 554, 65, 725, 105, %A_ScriptDir%\img\search_fluidadmintreeviewselect_active.png
			ImageSearch intInactiveX, intInactiveY, 554, 65, 725, 105, %A_ScriptDir%\img\search_fluidadmintreeviewselect_inactive.png
			;ImageSearch intBrowseX, intBrowseY, 550, 90, 800, 130, %A_ScriptDir%\img\search_fluidadmintreeviewselect_browse.png
			ImageSearch intMenuX, intMenuY, 150, 400, 300, 550, %A_ScriptDir%\img\search_fluidadmintreeviewselect_gomenu.png
;msgbox % intMenuX " - " intMenuY
			ControlGetPos, , , intTreeW, intTreeH, WindowsForms10.SysTreeView32.app.0.30495d1_r11_ad111, A
;msgbox % intTreeW " - " intTreeH
			; Make sure it's been found
			;if ( ( ( 0 < intActiveX & 0 < intActiveY ) OR ( 0 < intInactiveX & 0 < intInactiveY ) ) AND ( 0 < intBrowseX & 0 < intBrowseY ) )  {
			if ( ( 300 > intTreeH ) AND ( ( 0 < intActiveX & 0 < intActiveY ) OR ( 0 < intInactiveX & 0 < intInactiveY ) ) AND ( !intMenuX & !intMenuY ) )  {
			;if ( ( 0 < intActiveX & 0 < intActiveY ) OR ( 0 < intInactiveX & 0 < intInactiveY ) ) {
				; Array of controls that all need to be resized, with their sizes
				; Original code was existing-width + 100 but that just happened
				; repeatedly so need to hard-code numbers
				arrControls := {}
				arrControls.Insert( { strControl:"WindowsForms10.Window.8.app.0.30495d1_r11_ad19", intWx:291, intHx:16 } ) ; X button
				arrControls.Insert( { strControl:"WindowsForms10.Window.8.app.0.30495d1_r11_ad111", intWx:285, intHx:560 } ) ; Browse Fieldset
				arrControls.Insert( { strControl:"WindowsForms10.SysTreeView32.app.0.30495d1_r11_ad11", intWx:275, intHx:535 } ) ; Product treeview
				; Loop controls and action width and height changes
				for intIndex, objControl in arrControls {
					ControlMove, % objControl.strControl, , , % objControl.intWx, % objControl.intHx, A
				}
			}
		}
	}

}