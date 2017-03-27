
class Hotkey {

	; Solution implemented from this reference
	; @see http://stackoverflow.com/questions/12851677/dynamically-create-autohotkey-hotkey-to-function-subroutine
	; @todo As I'm never(?) going to pass a parameter to a refill.pour, I should
	; change last arg to a dynamically passed object and move the IfWinActive element
	; inside this function to further abstract code from refill child
	; For reference:
	; http://www.autohotkey.com/board/topic/62504-variadic-functions/?hl=%2Bdynamic+%2Bmethod#entry619126
	add(hk, fun, arg*) {
		; Define class properties to work with label below
		Static funs := {}, args := {}
		; populate properties with method parameters
		funs[hk] := Func(fun), args[hk] := arg
		; Define hotkey with single-access label
		Hotkey, %hk%, Hotkey_Handle
		; reset hotkey context in case one was set before call
		Hotkey, IfWinActive
		; get out now before label
		return

		; labels are defined at run-time so this is still found
		; and better yet kept within class namespace
		Hotkey_Handle:
; @todo BLOCK INPUT!
; Consider inputbox and msgbox when blocking input else user
; may not be able to do anything with them when blocked

; @todo #UseHook On
; http://www.autohotkey.com/docs/commands/_UseHook.htm
; This may help me have a global-abort

; @todo Implement global-abort

			; execute desired hotkey
			funs[A_ThisHotkey].(args[A_ThisHotkey]*)

; @todo UNBLOCK input
		Return
	}

}