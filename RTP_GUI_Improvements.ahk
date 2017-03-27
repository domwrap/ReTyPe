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


!^F12::
	strControl = WindowsForms10.STATIC.app.0.30495d1_r11_ad15

	;PostMessage, 0x132, #FF0,, %strControl%, A
	;PostMessage, 0x133, #FF0,, %strControl%, A
	;PostMessage, 0x134, #FF0,, %strControl%, A
	;PostMessage, 0x135, #FF0,, %strControl%, A
	;PostMessage, 0x136, #FF0,, %strControl%, A
	;PostMessage, 0x137, #FF0,, %strControl%, A
	;PostMessage, 0x138, #FF0,, %strControl%, A

	ControlGetText, strLabel, %strControl%, A
	IfNotInString, strLabel, DEV
		ControlSetText, %strControl%, DEV - %strLabel%, A
	Control, Style, ^0x800000, %strControl%, A
	;WinSet, Redraw,, A
return

!^F11::
MsgBox Trying
	strControl = WindowsForms10.Window.8.app.0.30495d1_r11_ad18
	;PostMessage, 0x132, #FF0,, %strControl%, A
	;PostMessage, 0x133, #FF0,, %strControl%, A
	;PostMessage, 0x134, #FF0,, %strControl%, A
	;PostMessage, 0x135, #FF0,, %strControl%, A
	;PostMessage, 0x136, #FF0,, %strControl%, A
	;PostMessage, 0x137, #FF0,, %strControl%, A
	;PostMessage, 0x138, #FF0,, %strControl%, A
	Control, Style, 0x9, %strControl%, A
	;WinSet, Redraw,, A
	;WinMove, 0,0
	WinHide, A
	WinShow, A
return



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
MsgBox Applyin!
	; http://www.autohotkey.com/docs/misc/Styles.htm
	; I've played with these a lot, and I cannot make the headers sort
	;Control, Style, +0x1, %strControl%, A ; LVS_REPORT
	;Control, Style, -0x4000, %strControl%, A ; LVS_NOCOLUMNHEADER
	;Control, Style, -0x8000, %strControl%, A ; LVS_NOSORTHEADER
	;Control, Style, +0x20, %strControl%, A ; LVS_SORTDESCENDING

	PostMessage, 0x8000

	;Control, Style, ^0x4, %strControl%, A ; LVS_SINGLESEL
	;ControlMove, %strControl%, 420, , ,

	WinSet, Redraw,, A
	;WinMove, 0, 0
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



;@todo Right-click copy on product code box in update window
;@todo make tree navigation window box for header and component bigger
;@todo Move discount column in Sales Tran
;@todo Select specific 



; MUST BE LAST LINE IN FILE
; Close this stuff off, otherwise no other macros work
#IfWinActive