/**
 * File containing Refill class to facilitate updating multiple display orders on a product header category
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
 * @copyright	2015 Dominic Wrapson
 * @license		Creative Commons Attribution-ShareAlike 4.0 International License http://creativecommons.org/licenses/by-sa/4.0/deed.en_US
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
	 * Setup controls, window group, etc
	 */
	__New() {
		global objRetype
		base.__New()

		strGroup 	:= this.id
		strRTP		:= % objRetype.objRTP.classNN()
		GroupAdd, %strGroup%, Create A Display Category ahk_class %strRTP%, eStore Display Type
		GroupAdd, %strGroup%, Update ahk_class %strRTP%, eStore Display Type
	}


	/**
	 * Where the magic happens
	 */
	pour() {
		global objRetype
		; Static variable that maintains its value between executions, so can be used as the new default value in the Iterate prompt
		static intIterate 		:= 1
		static intIncrement 	:= 10

		; Activate RTP (after toolbar has been clicked)
		objRetype.objRTP.Activate()
; @todo Check needs to be removed once I've managed to wall-in shortcuts in to the RTP only window
		; Run if it's ready!
		strGroup := this.__Class
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