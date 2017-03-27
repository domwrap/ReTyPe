/**
 * Here be RTP Macros
 *
 * USE THIS SCRIPT AND THESE MACROS AT YOUR OWN RISK!
 * Understand that this only emulates keystrokes and that in RTP {Enter} is SAVE so
 * _always_ use alternatives {Tab}{Space} where possible
 *
 * ALWAYS test your scripts on a Training environment before running on Live
 *
 * For scripting help, see http://www.autohotkey.com/docs/
 * For help with hotkeys and modifiers http://www.autohotkey.com/docs/Hotkeys.htm
 *
 * AutoHotKey v1.1.13.01+
 *
 * LICENSE: This work is licensed under a version 4.0 of the
 * Creative Commons Attribution-ShareAlike 4.0 International License
 * that is available through the world-wide-web at the following URI:
 * http://creativecommons.org/licenses/by-sa/4.0/deed.en_US
 *
 * @category   Improvements
 * @package    RTP_Macro
 * @author     Dominic Wrapson <dwrapson@whistlerblackcomb.com>
 * @copyright  2013 Dominic Wrapson
 * @license    Creative Commons Attribution-ShareAlike 4.0 International License http://creativecommons.org/licenses/by-sa/4.0/deed.en_US
 */


; Possible win hooks?
; http://stackoverflow.com/questions/9176757/autohotkey-window-appear-event


;=========================================================
#IfWinActive Product Header Pricing Bulk Update, Selected Price Update Details
>!i:: ; 	BULK PRICING:	Resize the pricing season drop-down

	strWinBulk		= Product Header Pricing Bulk Update

	_windowCheckActiveProcess( "rtponecontainer" )
	_windowCheckActiveTitle( strWinBulk )
	WinGet, idPricing, ID, A

	strControl = WindowsForms10.COMBOBOX.app.0.30495d1_r11_ad11
	ControlMove, %strControl%, , , 400, , ahk_id %idPricing%
return


;=========================================================
#IfWinActive Update the Pricing Season, Selected Pricing Season Dates
>!i:: ; 	PRICING SEASONS:	Resize the stupid date view box
	strControl = WindowsForms10.SysListView32.app.0.30495d1_r11_ad11

	WinGet, idWindow, ID, A
	WinGetPos, intWx, intWy, intWw, intWh, A

	;ControlGetPos, intCx, intCy, intCw, intCh, %strControl%, ahk_id %idWindow%
	;intCxX := intWw - 390
	ControlMove, %strControl%, 420, , ,
	;ControlMove, %strControl%, , , 250, 
return


;=========================================================
#IfWinActive Pricing, Price Allocation
>!i:: ; 	PRICING UPDATE:	Enable the pricing season dropdown
	strControl = WindowsForms10.COMBOBOX.app.0.30495d1_r11_ad11
	WinGet, idWindow, ID, A
	Control, Enable, , %strControl%, ahk_id %idWindow%
return


;=========================================================
#IfWinActive Update, Products and Payments
>!i:: ; 	PRICING SEASONS:	Enable sorting in bStore window (IN PROGRESS)
	strControl = WindowsForms10.SysListView32.app.0.30495d1_r11_ad11
	WinGet, idWindow, ID, A
MsgBox hello
	Control, Style, ^LVS_NOCOLUMNHEADER, %strControl%, ahk_id %idWindow%
	;ControlMove, %strControl%, 420, , ,
return


;=========================================================
#IfWinActive RTP|ONE Container, Extend Price Reduction on Product Change
>!i:: ; 	VOUCHER TOOLS:	Resize the product list box (CANNOT BE DONE)
	;strControl = WindowsForms10.COMBOBOX.app.0.30495d1_r11_ad14
	strControl = WindowsForms10.SysListView32.app.0.30495d1_r11_ad11

	WinGet, idWindow, ID, A
	WinGetPos, intWx, intWy, intWw, intWh, A

	ControlGetPos, intCx, intCy, intCw, intCh, %strControl%, ahk_id %idWindow%
MsgBox % intCh
	;intCxX := intWw - 390
	ControlMove, %strControl%, 10, 10, 400, 400
	;ControlMove, %strControl%, , , 250, 
	ControlGetPos, intCx, intCy, intCw, intCh, %strControl%, ahk_id %idWindow%
MsgBox % intCh
return


;=========================================================
#IfWinActive
>!i:: ;		CONTEXTUAL: Makes small 'changes' to the RTP UI relevent to the current window
	MsgBox, 16, Macro Information, Not in RTP or not an area that has programmed modifications
return


; MUST BE LAST LINE IN FILE
; Close this stuff off, otherwise no other macros work
#IfWinActive