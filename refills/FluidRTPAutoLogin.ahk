/**
 * File containing Refill class to auto-login to locked RTP sessions
 * No persistent password storage, user has to enter first time
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
objRetype.refill( new FluidRTPAutoLogin() )


/**
 * Auto login to locked RTP sessions
 *
 * @category	Automation
 * @package		ReTyPe
 * @author		Dominic Wrapson <dwrapson@whistlerblackcomb.com>
 * @copyright	2015 Dominic Wrapson
 */
class FluidRTPAutoLogin extends Fluid {

	intTimer	:= 100
	blnShow		:= true
	strPassword	:= false

	/**
	 * Fluid setup
	 */
	__New() {
		base.__New()
	}

	/**
	 * If lock-out window appears in RTP, prompt user to enter their password the first-time
	 * Use this non-persistent password thereon to auto-unlock RTP after timeout
	 */
	pour() {
		global objRetype

		; Login screen exists and is active which is important as it means it won't
		; work in the background, only once you actually activate the window
		strRTP	:= % objRetype.objRTP.classNN()
		WinID 	:= WinActive( "Reenter Login Information ahk_class " . strRTP, "Enter your User Name and Password to Log On:" )
		If %WinID%
		{
			; Check if user has previously cancelled
			If this.blnShow = false
			{
				Return
			}

			; Prompt for user-password first time and store only in memory for future logins
			if this.strPassword = false
			{
				this.strPassword := InputBox.Show( "Enter your password once only and press OK to auto-login locked sessions, or press Cancel to not see this again (this session)", "", 1 )
				IfMsgBox, Cancel
				{
					this.blnShow := false
					Return
				}
			}

			; Password control on the login page
			strControl	:= objRetype.objRTP.formatClassNN( "EDIT", this.getConf( "Password", 11 ) )
			strPassword := this.strPassword

			; Input Password and unlock
			ControlSetText, %strControl%, %strPassword%, ahk_id %WinID%
			ControlClick, Log On

; Remove input masking
; strControl := objRetype.objRTP.formatClassNN( "EDIT", 11 )
; SendMessage, 0x00cc, 0, 0, %strControl%
		}

	}


}
