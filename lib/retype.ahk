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
#Include %A_ScriptDir%\Lib
#include window.ahk
#Include msgbox.ahk
#Include inputbox.ahk
#Include hotkey.ahk
#Include send.ahk
#Include toolbarretype.ahk

; Global variables so they can be used within labels
arrFluidTimers := {}
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
 * @copyright	2014 Dominic Wrapson
 */
class Retype {


	;static objRetype	= 
	; Config
	strFileConf			:= "retype.ini"
	blnToolbar			:= false
	idRtpClassNN		:= 
	; Variables
	;arrFluidTimers		:= {}
	arrFluidHotkeys		:= {}
	objToolbar			:= {}

	__New() {
		global arrFluidTimers
		; @todo Singleton?

		; @todo Load ini conf
		IniRead, blnToolbar, this.strFileConf, Conf, Toolbar, 1
		this.blnToolbar := blnToolbar ? 1 : 0
		; iniread intTreeCustomerCommon
		; iniread intTreeCustomerAccess

; @todo Iterate over refills.ahk instantiate and register each automatically
; LoopFile, refills.ahk {
;	strRefill := SubStr( A_LoopValue, /, . )
; 	this.refill( new %strRefill% )
; }

; @todo Move to RTP class
; Not currently being used anyway
		IniRead, idRtpClassNN, this.strFileConf, Conf, RtpClassNN, WindowsForms10.Window.8.app.0.30495d1_r11_ad1
		this.idRtpClassNN := idRtpClassNN
	}


	__Delete() {
		; Some destruction stuff here
	}

	/**
	 * Kick things off to start timers and hotkeys
	 */
	go() {
		global arrFluidTimers, intTimerCount, intTimerBase

		; @todo build toolbar and menus
		; if ( blnToolbar ) {
			; build toolbar
			this.objToolbar := new ToolbarRetype()
			this.objToolbar.render()

			;for idFluid, objFluid in arrFluidHotkeys {
			;	this.toolbar.add( new MenuFluid( objFluid ) )
			;}
		;}

		; Register hotkeys
		;for idFluid, objFluid in arrFluidHotkeys {

		;}

		; Master timer for all refills
		setTimer, lblTimerRefill, %intTimerBase%
		return

		; Label for refill timer which checks when to activate each
		; registered refill timer by mod calculation as this was
		; the only way I could get this model working
		lblTimerRefill:
			for idFluid, objFluid in arrFluidTimers {
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
		global arrFluidTimers

		try {
			; There is no instanceOf so this will do
			if ( false != objFluid.intTimer ) {
				arrFluidTimers[objFluid.id] := objFluid
			} else if ( ObjHasKey( objFluid, "strHotkey" ) ) {
				this.arrFluidHotkeys[objFluid.id] := objFluid
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
			Debug.log( e )
		}
	}


}

