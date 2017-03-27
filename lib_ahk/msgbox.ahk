/**

Function	Decimal Value	Hex Value
OK (that is, only an OK button is displayed)	0	0x0
OK/Cancel	1	0x1
Abort/Retry/Ignore	2	0x2
Yes/No/Cancel	3	0x3
Yes/No	4	0x4
Retry/Cancel	5	0x5
Cancel/Try Again/Continue (2000/XP+)	6	0x6
Adds a Help button (see remarks below)	16384	0x4000
 	 	 
Icon Hand (stop/error)	16	0x10
Icon Question	32	0x20
Icon Exclamation	48	0x30
Icon Asterisk (info)	64	0x40
 	 	 
Makes the 2nd button the default	256	0x100
Makes the 3rd button the default	512	0x200
 	 	 
System Modal (always on top)	4096	0x1000
Task Modal	8192	0x2000
Shows the MsgBox on default desktop
(Windows NT/2000/XP or later)	131072	0x20000
Always-on-top (style WS_EX_TOPMOST)
(like System Modal but omits title bar icon)	262144	0x40000
 	 	 
Make the text right-justified	524288	0x80000
Right-to-left reading order for Hebrew/Arabic	1048576	0x100000
*/
class MsgBox {

	static blnConf		:= false
	static strTitle 	:= "Message"
	static strFileConf	:= "conf\app.ini"

	/**
	 * Display critical error dialog
	 * Exit if requested
	 */
	stop( strMessage, blnExit=True ) {
		; Add period at end of message if not sent
		strMessage := ( "." != SubStr( strMessage, StrLen( strMessage ), 1 ) ) ? strMessage "." : strMessage
		; If exiting, add message to say so
		;strMessage := ( True = blnExit ) ? strMessage " Exiting" : strMessage

		; Do the actual msgbox
		ErrorLevel := this.show( strMessage, 16, "Fatal Error" )

		; Exit if requested, else return status
		if ( True = blnExit ) {
			exit
		} else {
			return ErrorLevel
		}
	}

	error( strMessage ) {
		return this.show( strMessage, 48, "Error!" )
	}

	retry( strMessage ) {
		return this.show( strMessage, 69, "Retry?" )
	}

	yesno( strMessage ) {
		return this.show( strMessage, 36, "Continue?" )
	}

	info( strMessage ) {
		return this.show( strMessage, 32, "Info" )
	}

	tryagain( strMessage ) {
		return this.show( strMessage, 70, "Try Again?" )
	}

	show( strMessage, intType=0, strTitle="" ) {
		; Some pre-built stuff
		this.p_conf()

		; Build title
		strTitle := ( 0 < StrLen( strTitle ) ) ? this.strTitle ": " strTitle : this.strTitle
		; Allows repositioning of msgbox
		OnMessage(0x44, "WM_COMMNOTIFY")
		; Show the actual box
		MsgBox, % intType, %strTitle%, % strMessage	
		return ErrorLevel
	}

	p_conf() {
		this.blnConf := true
		IniRead, strTitle, % this.strFileConf, Conf, Title, % this.strTitle
		this.strTitle := strTitle
	}

}


/**
 * Allows MsgBox to be moved from center of screen to center of parent window
 */
WM_COMMNOTIFY(wParam) {
	global objRetype

    if (wParam = 1027) { ; AHK_DIALOG
        Process, Exist
        DetectHiddenWindows, On
        if WinExist("ahk_class #32770 ahk_pid " . ErrorLevel) {
            WinGetPos,,,w,h
			intX := objRetype.objRTP.getPos("X") + ( objRetype.objRTP.getPos("W") / 2 ) - ( w / 2 )
			intY := objRetype.objRTP.getPos("Y") + ( objRetype.objRTP.getPos("H") / 2 ) - ( h / 2 )
            WinMove, %intX%, %intY%
        }
    }
}


; Message icon use 
; http://ux.stackexchange.com/questions/52727/what-are-the-the-best-error-message-icons-to-use-for-each-type-of-error-in-net
