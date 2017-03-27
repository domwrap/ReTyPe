#include lib\window.ahk
#Include lib\msgbox.ahk
#Include lib\inputbox.ahk
#Include lib\hotkey.ahk

arrFluidTimers := {}
intTimerBase := 100
intTimerCount := 0

class Retype {


	;static objRetype	= 
	; Config
	strFileConf			:= "retype.ini"
	blnToolbar			:= false
	; Variables
	arrFluidTimers		:= 
	arrFluidHotkeys		:= 


	__New() {
		global arrFluidTimers
		; @todo Singleton?

		; @todo Load ini conf
		IniRead, blnToolbar, this.strFileConf, Conf, Toolbar, 1
		this.blnToolbar := blnToolbar ? 1 : 0
		; iniread intTreeCustomerCommon
		; iniread intTreeCustomerAccess
	}


	__Delete() {
		; Some destruction stuff here
	}


	go() {
		global arrFluidTimers, intTimerCount, intTimerBase

		; @todo build toolbar and menus
		; if ( blnToolbar ) {
			; build toolbar
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


	Refill( objFluid ) {
		global arrFluidTimers

		try {
			; There is no instanceOf so this will do
			if ( false != objFluid.intTimer ) {
				arrFluidTimers[objFluid.id] := objFluid
			} else if ( ObjHasKey( objFluid, "strHotkey" ) ) {
				arrFluidHotkeys[objFluid.id] := objFluid
			} else {
				throw new Exception( "Invalid fluid type" )
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

