
objRetype.refill( new FluidEmailPreviewEnterOverride() )

class FluidEmailPreviewEnterOverride extends Fluid {

	strHotkey		:= "$Enter"
	strMenuPath		:= ""
	strMenuText		:= ""
	intMenuIcon		:= ""

	/**
	 * Setup controls, window group, etc
	 */
	__New() {
		global objRetype
		base.__New()

		strGroup 	:= this.id
		strRTP		:= % objRetype.objRTP.classNN()
		GroupAdd, %strGroup%, Send Email ahk_class %strRTP%, PDF attachment
	}

	/**
	 * Where the magic happens
	 */
	pour() {
		global objRetype

		; Only run if we're in the appropriate window
		strGroup := this.__Class
		IfWinActive, ahk_group %strGroup%
		{
			; Did you execute from an RTP window?
			if ( objRetype.objRTP.isActive() ) {
				idWinRTP	:= WinActive("A")

				; Clipboard manipulation a-go-go!
				; I attempted several different ways to get a carriage-return in to
				; the email preview window, each one was immediately interpreted
				; by RTP as an ENTER command and would attempt to send the email.
				; The only way I could get it to work manually was to paste a CRLF
				; from notepad in to the editor, so that's exactly what I do here.
				; Clipboard is preserved through temp var either side of sending
				; the CRLF through the clipboard

				; Store current clipboard in temp var
				var := clipboard
				; Overwrite clipboard with CRLF
				clipboard = `r`n
				; Paste the clipboard in to the editor
				Send ^v
				; Restore previously stored contents back in to the clipboard
				; so process is invisible to the end-user
				clipboard := var
			} else {
				; If we're not in RTP, continue with regular enter
				Send {Enter}
				;Send Nope1{Enter}
			}
		} else {
			; If we're not in RTP, continue with regular enter
			Send {Enter}
			;Send Nope2{Enter}
		}
	}

}