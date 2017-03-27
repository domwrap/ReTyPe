/**
 * ReTyPe engine.  This is the object to which all refills are automatically added
 * and depending on the configuration, added to toolbar menus, hotkeys registered,
 * and timers configured for UI alterations
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
 * @copyright	2013 Dominic Wrapson
 * @license		Creative Commons Attribution-ShareAlike 4.0 International License http://creativecommons.org/licenses/by-sa/4.0/deed.en_US
 */

; Dependencies
#Include %A_ScriptDir%\lib_ahk
#include window.ahk
#Include msgbox.ahk
#Include inputbox.ahk
#Include hotkey.ahk
#Include send.ahk
#Include %A_ScriptDir%\lib
#Include rtp.ahk
#Include toolbarretype.ahk

; Global variables so they can be used within labels
;arrTimers := {}
intTimerBase := 100
intTimerCount := 0

/**
 * Entry in to the framework that rounds up Fluid objects, refills them in
 * to the ReTyPe bottle, and either presents them for use or triggers them
 * by timer
 *
 * @category	Automation
 * @package		ReTyPe
 * @author		Dominic Wrapson <dwrapson@whistlerblackcomb.com>
 * @copyright	2013 Dominic Wrapson
 */
class Retype {
; @todo abstract main functionality, extend to RTP specific version

	;static objRetype	= 
	; Config
	strFileConf		:= "conf\retype.ini"
	blnToolbar		:= false
	; Variables
	arrTimers		:= {}
	arrHotkeys		:= {}
	objToolbar		:= {}
	objRTP			:= {}

	__New() {
		;global arrTimers
		; @todo Singleton?

		; @todo Load ini conf
		IniRead, blnToolbar, % this.strFileConf, Conf, Toolbar, 1
		this.blnToolbar := blnToolbar ? 1 : 0

		; iniread intTreeCustomerCommon
		; iniread intTreeCustomerAccess

; @todo Iterate over refills.ahk instantiate and register each automatically
; LoopFile, refills.ahk {
;	strRefill := SubStr( A_LoopValue, /, . )
; 	this.refill( new %strRefill% )
; }


		this.objRTP := new RTP()
	}


	__Delete() {
		; Some destruction stuff here
	}

	/**
	 * Kick things off to start timers and hotkeys
	 */
	go() {
		global intTimerCount, intTimerBase

		; @todo build toolbar and menus
		if ( this.blnToolbar ) {
			; build toolbar
			this.objToolbar := new ToolbarRetype()

			for idFluid, objFluid in this.arrHotkeys {
				;msgbox % objFluid.strMenuPath
				;this.toolbar.add( new MenuFluid( objFluid ) )

				; Add to button/menu
; @todo figure out if non-sub-menus work
				; Get text and hotkey, and make human friendly for menu
				strMenuText := objFluid.strMenuText "`t" objFluid.strHotKey
				StringReplace, strMenuText, strMenuText, +, Shift+
				StringReplace, strMenuText, strMenuText, !, Alt+
				StringReplace, strMenuText, strMenuText, ^, Ctrl+
				; Fetch and split path to find where to add menu
				strMenuPath := objFluid.strMenuPath
				StringSplit, arrPath, strMenuPath, /
				; Create and add object in specified position
				objMenu := new Menu( "fnMenu_Handle", strMenuText )
				this.objToolbar.arrButtons[arrPath2].arrMenus[arrPath3].addChild( objMenu )
			}

			this.objToolbar.render()
		}

		; Register hotkeys
		;for idFluid, objFluid in arrHotkeys {

		;}
;msgbox % debug.exploreObj( this )

		; Master timer for all refills
		setTimer, lblTimerRefill, %intTimerBase%
		return

		; Label for refill timer which checks when to activate each
		; registered refill timer by mod calculation as this was
		; the only way I could get this model working
		lblTimerRefill:
			global objRetype
			for idFluid, objFluid in objRetype.arrTimers {
				if ( 0 = Mod( intTimerCount, objFluid.intTimer ) ) {
					objFluid.pour()
				}
			}
			intTimerCount += intTimerBase
		return
	}

	/**
	 * Add (refill) a hotkey (fluid) to the retype class (bottle)
	 * @param object _Fluid instance Fluid object to be refilled
	 * @throws Exception
	 * @return void
	 */
	refill( objFluid ) {
		;global arrTimers

		try {
			; There is no instanceOf so this will do
			if ( objFluid.intTimer ) {
				this.arrTimers[objFluid.id] := objFluid
			} else if ( ObjHasKey( objFluid, "strHotkey" ) ) {
				this.arrHotkeys[objFluid.id] := objFluid
			} else {
				throw new Exception( "Invalid fluid type" )
; @todo Extend Exception to different sub-classes
			}

			; method that does menus, hotkey, any setup, etc
			objFluid.fill()

; @todo Make buttons on the toolbar flash (bold) and menu items highlighted (bold)
; when they open a relevant window/area to prompt users to use available macros
		} catch e {
			; http://www.autohotkey.com/docs/commands/_ErrorStdOut.htm
			Debug.write( e )
		}
	}


}

