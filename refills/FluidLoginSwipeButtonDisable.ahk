/**
 * File containing Refill class to disable ENTER and OK buttons for swipe logins
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
objRetype.refill( new FluidLoginSwipeButtonDisable() )


/**
 * Refill to disable ENTER and OK buttons for swipe logins
 *
 * @category	Automation
 * @package		ReTyPe
 * @author		Dominic Wrapson <dwrapson@whistlerblackcomb.com>
 * @copyright	2015 Dominic Wrapson
 */
class FluidLoginSwipeButtonDisable extends Fluid {

	intTimer := 100

	/**
	 * Setup controls, window group, etc
	 */
	__New() {
		global objRetype
		base.__New()

		; Create window group for places we want this hotkey active
		strGroup := this.id
		strRTP		:= % objRetype.objRTP.classNN()
		GroupAdd, %strGroup%, On-Screen Keyboard ahk_class %strRTP%, Login
	}


	pour() {
		global objRetype

		; On-Screen login keyboard is active
		strGroup := this.__Class
		IfWinActive, ahk_group %strGroup%
		{
			; Hide ENTER and OK buttons so they can't be used to manually enter logins
			Control, Hide, , Enter
			Control, Hide, , OK

			; Text control on the login page
			strControl := objRetype.objRTP.formatClassNN( "EDIT", this.getConf( "Login", 11 ) )
			; Get contents of text box
			ControlGetText, strLogin, %strControl%, A

			arrLogins := {111144: 1,222288: 1,336666: 1,443333: 1,444999: 1,555444: 1,866666: 1,888884: 1}
			if ( arrLogins.HasKey( strLogin ) ) {
				ControlFocus, %strControl%, A
				;SendInput {Enter}

				objRetype.arrHotKeys["FluidLoginSwipe"].pour()
			}

; Works but not necessary
; Disable asterisk masking
;SendMessage, 0x00cc, 0, 0, %strControl%
; Re-enable masking
;SendMessage, 0x00cc, 42, 0, %strControl%


; Works but not necessary
; Disable asterisk masking
;foo := this.Edit_IsStyle( strControl, 0x20 )
;msgbox.show( foo )
;this.Edit_SetPasswordChar( strControl, "*" )
;Msgbox.show( ErrorLevel )
;bar := this.Edit_IsStyle( strControl, 0x20 )
;msgbox.show( bar )
		}

	}


}
