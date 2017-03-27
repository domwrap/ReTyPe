
class Send {

	static mode := 0

	__New( strInput, intMode ) {
; @todo Test if this allows Send( "text" )
		this.input( strInput, intMode )
	}

	; Bump year by two (up or down) to circumvent RTP's date naziism
	date( dtDate, blnUp=1 ) {
		intValid := RegExMatch( dtDate, "^(0?[1-9]|1[012])[- /.](0?[1-9]|[12][0-9]|3[01])[- /.](19|20)\d\d$" )
		if ( 1 > intValid ) {
			return False
		}

		Send {right 2}
		If blnUp
			Send {Up 2}
		else
			Send {Down 2}
		Send {left 2}
		Loop, parse, dtDate, /
		{
			Send %A_LoopField%{right}
		}
		return True
	}

	input( strInput, intMode=false ) {
		if ( false = intMode ) {
			intMode := this.mode
		}

		if ( 1 = intMode ) {
			SendInput %strInput%
		} else if ( 2 = intMode ) {
			SendRaw %strInput%
		} else if ( 3 = intMode ) {
			SendPlay %strInput%
		} else {
			Send %strInput%
		}
	}

}