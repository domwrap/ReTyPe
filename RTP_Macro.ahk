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
 * @category   Automation
 * @package    RTP_Macro
 * @author     Dominic Wrapson <dwrapson@whistlerblackcomb.com>
 * @copyright  2013 Dominic Wrapson
 * @license    Creative Commons Attribution-ShareAlike 4.0 International License http://creativecommons.org/licenses/by-sa/4.0/deed.en_US
 */


; Avoids checking empty variables to see if they are environment variables (recommended for all new scripts).
#NoEnv
; Fastest send mode
; BREAKS things like media output it's TOO FAST!
; http://www.autohotkey.com/docs/commands/Send.htm#SendInput
;SendMode, Input

/*
 * 1: A window's title must start with the specified WinTitle to be a match.
 * 2: A window's title can contain WinTitle anywhere inside it to be a match. 
 * 3: A window's title must exactly match WinTitle to be a match.
 */
SetTitleMatchMode 1

/*
 * True: Return from functions where user cancels and decide flow within program
 * False: Issue exit command when user cancels or function fails
 */
RETURN_ON_USER_CANCEL = False

; Includes that mean we can keep things separated and tidy
#Include debug.ahk
#Include RTP_GUI_Improvements.ahk
#Include RTP_Functions.ahk
#Include RTP_Macro_Specifics.ahk


;=========================================================
^!x:: ; PRICING:		This will DELETE the following X component pricing

; Did you execute from an RTP window?
_windowCheckActiveProcess( "rtponecontainer" )
; Do we only have one instance of RTP Update?
;_windowContinueSingleOnly( "Update" )
; Are we in the pricing tab of a product header?
_windowCheckVisibleTextContains( "sales report group", "pricing" )
; Check which control has focus.  If it's not the pricing ListView then don't proceed
_windowCheckControlFocus( "WindowsForms10.SysListView32.app.0.30495d1_r11_ad11", "Pricing ListView" )

; Prompt for iteration count
intDelete := _InputBox( "How many pricing entries do you wish to delete?", 1 )

Loop %intDelete%
{
	WinActivate, Update
	SendInput {Space}{AppsKey}d{Space}
}
return


;=========================================================
^!u:: ; PRICING:	This will UPDATE the next X listed components with PRICE (detects by Season or by Date)

; Did you execute from an RTP window?
_windowCheckActiveProcess( "rtponecontainer" )
; Do we only have one instance of RTP Update?
;_windowContinueSingleOnly( "Update" )
; Are we in the pricing tab of a product header?
_windowCheckVisibleTextContains( "sales report group", "pricing" )
; Check which control has focus.  If it's not the pricing ListView then don't proceed
_windowCheckControlFocus( "WindowsForms10.SysListView32.app.0.30495d1_r11_ad11", "Pricing ListView" )

; Prompt for iteration count
intPrice := _InputBox( "What's the NEW price?", 9999 )
intIterate := _InputBox( "How many rows are we updating?", 1 )

; Detect PriceType selection for how we update the pricing with keystrokes
ControlGet, strSelected, Choice, , WindowsForms10.COMBOBOX.app.0.30495d1_r11_ad18, A

Loop %intIterate%
{
	; Select row in ListView, right-click, choose Update
	SendInput {Space}{AppsKey}u
	; Wait for Pricing update window to load, max of 2 seconds then continue
	WinWait, Pricing, , 5
	; Send extra tabs for price by date
	if ( strSelected = "By Date") {
		SendInput {Tab 2}
	}
	; Send the new price for both unit and price
	SendInput %intPrice%{Tab}%intPrice%
	; Get to OK button, press it, move down a row
	SendInput {Tab 4}{space}{Down}
}
return


;=========================================================
^!p:: ; BULK PRICING:	This will UPDATE the next X listed components with PRICE
InputBox, intPrice, Price, What's the NEW product price?, , , , , , , ,9999
InputBox, intIterate, How many, How many components are we updating?, , , , , , , ,3
if ErrorLevel
{
	; user pressed cancel
	return
}
else
{
	Loop %intIterate%
	{
		SendInput %intPrice%
		SendInput {Down}
	}
}
return


;=========================================================
^!+p:: ; BULK PRICING:	This will UPDATE the next X listed components with PRICE, then move down X rows
InputBox, intPrice, Price, What's the NEW product price?, , , , , , , ,9999
InputBox, intIterate, How many, How many components are we updating?, , , , , , , ,3
if ErrorLevel
{
	; user pressed cancel
	return
}
else
{
	Loop %intIterate%
	{
		SendInput %intPrice%
		SendInput {Down}
	}
	SendInput {Down %intIterate%}
}
return


;=========================================================
^!h:: ; 	BULK PRICING:	Copy pricing from Excel grid in to RTP bulk pricing, assuming all components are sequential
; Variable setup
strWinBulk		= Product Header Pricing Bulk Update

; Did you execute from an Excel window?
_windowCheckActiveProcess( "excel" )
WinGet, idExcel, ID, A

; Do we only have one instance of RTP bulk update?
; Cannot enforce rule as both the parent and child windows are called the same (DAMMIT RTP!)
;_windowContinueSingleOnly( strWinBulk )
WinGet, idPricing, ID, %strWinBulk%

; Prep bulk pricing window for entry
WinActivate, ahk_id %idPricing%
; Check we also have RTP bulk update window
_windowCheckVisibleTextContains( "product header filter", "selected price update details" )
; Get us to the first pricing entry
ControlFocus, OK, ahk_id %idPricing%
Send {Tab}{Home}{Right 6}

; Prompt for components and channels
intIterate := _InputBox( "Transpose how many Excel rows?", 1 )
intChannels := _InputBox( "How many Sales Channels do we have?", 3 )

; DO SOME STUFF
Loop %intIterate% {
	WinActivate, ahk_id %idExcel%
		Send {F2}+{Home}^c{Tab}+{Tab}
		; Check for formulae
		if ( InStr( Clipboard, "=" ) ) {
			MsgBox, 48, RTP Macro Error, Formula in pricing input.  Exiting!
			Send {F2}
			exit
		}
		Send ^c
		Sleep 10
		StringReplace, clipboard, clipboard, $,, All
		Send {Down}
		Sleep 10
	WinActivate, ahk_id %idPricing%			
		Loop %intChannels% {
			Send ^v{Down}
		}
}
WinActivate, ahk_id %idExcel%
;Send {down 7}
return


;=========================================================
^!i:: ; INVENTORY: 	Copy pools from Excel in to RTP inventory administration
; Variable setup
strWinExcel		= Microsoft Excel - Inventory Pool Automated Entry Official Spreadsheet
strWinInvAdd	= Add Inventory Pool Location
strWinInvUpd	= Update

; Prompt for rows (eventually maybe detect?)
InputBox, intIterate, How many, How many rows ya got in Excel?, , , , , , , ,1
if ErrorLevel
{
	; user pressed cancel
	return
}
else
{
	; Make sure we're on the Inventory Pool window
	WinActivate, %strWinInvUpd%
	; Set it up ready for looping
	Send {End}{Tab}{Right 5}{Tab}
	; Switch to Excel and reset to A1, then to first entry
	WinActivate, %strWinExcel%
	Send ^{Home}

	; Iterate
	Loop %intIterate%
	{
		WinActivate, %strWinExcel%
		Send {Home}{Down}
		WinActivate, %strWinInvUpd%
		Send {Space}
		Loop 2
		{
			WinActivate, %strWinExcel%
			;Send {F2}+{Home}^c{Tab}
			Send ^c{Tab}
			StringReplace, clipboard, clipboard, `r`n, , All
			WinActivate, %strWinInvAdd%
			; Bump year by two to circumnavigate RTP's date naziism
			Send {right 2}{Up 2}{left 2}
			Loop, parse, Clipboard, /
			{
				Send %A_LoopField%
				Send {Right}
			}
			Send {Tab}
		}
		Loop 2
		{
			WinActivate, %strWinExcel%
			Send ^c{Tab}
			WinActivate, %strWinInvAdd%
			Send ^v{Tab}
		}
		Loop 2
		{
			Send {Space}{Tab}
		}
		Send 99{Tab}
		Send {Space}{Tab}
		Send {Space}
	}
}
return

;MsgBox, 4, , Split %A_Index% is %A_LoopField%.`n`nContinue?
;IfMsgBox, No, break


;=========================================================
^!m:: ; MEDIA:		Duplicate text from first output entry to following X entries
; 256 CHAR LIMIT PER FIELD
; Max usable 20 chars per ticket line

; Did you execute from an RTP window?
_windowCheckActiveProcess( "rtponecontainer" )
; Do we only have one instance of RTP Update?
_windowContinueSingleOnly( "Update" )
; Are we in the output tab of a component?
; @todo This does not work as well as we would like because of the way RTP overlays all GUI components
;		as it loads them so if you switch to voucher then back to Output, it breaks
_windowCheckVisibleTextContains( "deferral", "output" )
; Fortunately however, this is a lot more effective!  This searches the screen for a VISUAL match against an image to check it can be seen!
ImageSearch intX, intY, 170, 20, 260, 70, search_images\component_tab_output.png
if ( !intX or !intY ) {
	MsgBox, 48, RTP Macro Information,Execution error: Macro attempted in wrong window or panel.
	return
}

; Botch around the fact that I cannot seem to apply focus to a SysListView32 control
ControlFocus, Add, A
Send {Down}{Home}

; Prompt for components and channels
intIterate := _InputBox( "To how many more Sales Channels will we copy the first?", 4 )


; Clear the Clipboard
clipboard = 

; Open update window, get to Label 1
Send {Home}{Tab}{Space}{Tab 5}
; Copy box and pre-pend to next then copy again
Loop 8
{
	; Copy contents of text input
	Send ^a^c{Tab}{Home}
	; Prepend to next field, separate by field delimeter
	SendInput %clipboard%
	Sleep 5
	Send |
}
Send ^a^c{Tab 2}{Space}
; Update next X sales channels
Loop %intIterate%
{
	; Open update window
	Send +{Tab}{Down}{Tab}{Space}
	; Give it half a second to render
	Sleep 500
	; Tab to first label
	Send {Tab 5}
	; Iterate delimited clipboard and paste per label
	Loop, parse, clipboard, |
	{
		SendInput ^a{BackSpace}%A_LoopField%{Tab}
	}
	; Final tab on loop puts us on Update button, hit space to confirm
	Send {Space}
}
return


;=========================================================
^!v:: ; VOUCHER:		Duplicate text from first output entry to next X entries
; 256 CHAR LIMIT PER FIELD
; Max usable 20 chars per ticket line

; Did you execute from an RTP window?
_windowCheckActiveProcess( "rtponecontainer" )
; Do we only have one instance of RTP Update?
_windowContinueSingleOnly( "Update" )
; Are we in the voucher tab of a component?
_windowCheckVisibleTextContains( "deferral", "voucher quantity", "output" )
; Visual search for correct header in the correct place
ImageSearch intX, intY, 170, 20, 350, 70, search_images\component_tab_voucherproduct.png
if ( !intX or !intY ) {
	MsgBox, 48, RTP Macro Information,Execution error: Macro attempted in wrong window or panel.
	return
}

; Botch around the fact that I cannot seem to apply focus to a SysListView32 control
ControlFocus, Add, A
Send {Up}{Space}

; Prompt for components and channels
intIterate := _InputBox( "To how many more Sales Channels will we copy the first?", 4 )

; Open update window, get to Label 1
Send {Home}{Tab 2}{Space}{Tab 4}
; Copy box and pre-pend to next then copy again
Loop 8
{
	; Copy contents of text input
	Send ^a^c{Tab}{Home}
	; Prepend to next field, separate by field delimeter
	SendInput %clipboard%
	Sleep 5
	Send |
}
Send ^a^c{Tab 2}{Space}
; Update next X sales channels
Loop %intIterate%
{
	; Open update window
	Send +{Tab 2}{Down}{Tab 2}{Space}
	; Give it half a second to render
	Sleep 500
	; Tab to first label
	Send {Tab 4}
	; Iterate delimited clipboard and paste per label
	Loop, parse, clipboard, |
	{
		SendInput ^a{BackSpace}%A_LoopField%{Tab}
	}
	; Final tab on loop puts us on Update button, hit space to confirm
	Send {Space}
}
return


;=========================================================
^!c:: ; COMMISSION:	Populate per-product commission class
;
; COLUMN LISTING MUST BE ACTIVE AREA
InputBox, intCommission, Commission, What commission rate?, , , , , , , ,25
InputBox, intIterate, Products, How many products?, , , , , , , ,1
if ErrorLevel
{
	; user pressed cancel
	return
}
else
{
	Loop %intIterate%
	{
		_updateCommission( intCommission )
	}
}
return


;=========================================================
^!a:: ; ACCOUNTING:	Copy Earned to Override
Loop 7
{
	Send ^a^c{Tab}{Home}^v
	; Field delimeter
	Send |
}
Send ^a^c
Send +{Tab 7}
Loop 2
{
	Loop, parse, clipboard, |
	{
		Send ^a{BackSpace}%A_LoopField%{Tab}
	}
}
return


;=========================================================
^!+a:: ; ACCOUNTING:	Copy Earned to Override X times
InputBox, intIterate, Accounting, Duplicate this row how many times down (not including the source line)?, , , , , , , ,1
if ErrorLevel
{
	; user pressed cancel
	return
}
else
{
	Loop 3
	{
		Send ^a^c{Tab}{Home}^v
		; Field delimeter
		Send |
	}
	Send ^a^c
	Send +{Tab 3}

	; increase Iterate count by one to account for pipe-separated row being copied
	intLoop := intIterate+1
	Loop %intLoop%
	{
		Loop, parse, clipboard, |
		{
			Send ^a{BackSpace}%A_LoopField%{Tab}
		}
	}
}
return


;=========================================================
^!d:: ; PRICE-BY-DATE:	Update next X Effective and Expiry dates
InputBox, intEffective, Effective Date, Change Effective to what date mm/dd/yyyy (leave blank to skip)?, , , , , , , ,
InputBox, intExpiration, Expsiration Date, Change Expiration to what date mm/dd/yyyy (leave blank to skip)?, , , , , , , ,
InputBox, intIterate, Pricing, Update how many rows?, , , , , , , ,1
if ErrorLevel
{
	; user pressed cancel
	return
}
else
{
	Loop %intIterate%
	{
		Send {AppsKey}u
		if intEffective
		{
			_dateInput( intEffective, 0 )
		}
		Send {Tab}
		if intExpiration
		{
			_dateInput( intExpiration )
		}
		Send {Tab 6}{Space}
		Send {Down}
	}
} 
return


;=========================================================
^!g:: ; DISCOUNT:		Update next X Expiry dates
InputBox, intExpiration, Expiration Date, Set Expiration to what date mm/dd/yyyy?, , , , , , , ,
InputBox, intIterate, Pricing, Update how many rows?, , , , , , , ,1
if ErrorLevel
{
	; user pressed cancel
	return
}
else
{
	Loop %intIterate%
	{
		Send {Tab 2}{space}
		_dateInput( intExpiration )
		Send {Tab 3}{Space}
		Send +{Tab 2}{Down}
	}
} 
return


;=========================================================
^!+g:: ; DISCOUNT:		Copy next X discounts with EFFECTIVE and EXPIRY dates
InputBox, intEffective, Effective Date, Set Effective to what date [mm/dd/yyyy]?, , , , , , , ,%intEffective%
InputBox, intExpiration, Expiration Date, Set Expiration to what date [mm/dd/yyyy]?, , , , , , , ,%intExpiration%
InputBox, intDiscount, Discount Amount, Set discount to what value? (leave BLANK to clone), , , , , , , ,
InputBox, intMethod, Discount Method, What discount calculation method? (1=Fixed/2=Percent/BLANK to clone existing), , , , , , , ,
InputBox, intIterate, Pricing, Clone how many discounts?, , , , , , , ,1
if ErrorLevel
{
	; user pressed cancel
	return
}
else
{
	Loop %intIterate%
	{
		Send {Tab}{space} ; Open copy window
		Send {Tab} ; Move to effective input
		_dateInput( intEffective ) ; Enter user-defined effective date
		Send {Tab} ; Move to expiry input
		_dateInput( intExpiration ) ; Enter user-defined expiry date
		Send {Tab} ; Move to discount Amount
		if intDiscount
		{
			Send ^a%intDiscount%
		}
		Send {Tab}
		if intMethod = 1
		{
			Send {Up}
		}
		else if intMethod = 2
		{
			Send {Down}
		}
		Send {Tab}{Space}
		Send +{Tab}{Down}
	}
} 
return


;=========================================================
!+g:: ; DISCOUNT:		Update next X rows to DISCOUNT
InputBox, intDiscount, Discount Amount, Set discount to what value? (leave BLANK to clone), , , , , , , ,
InputBox, intIterate, Pricing, Update how many rows?, , , , , , , ,1
if ErrorLevel
{
	; user pressed cancel
	return
}
else
{
	Loop %intIterate%
	{
		; Open Update dialog
		Send {Tab 2}{space}
		; Move to Amount box
		Send {Tab}
		; Input discount am ount
		Send %intDiscount%
		; Move to Update button and press
		Send {Tab 2}{Space}
		; Shift-tab back to listing, move down to next entry
		Send +{Tab 2}{Down}
	}
} 
return


;=========================================================
^!o:: ; DISPLAY CATEGORY:	Re-number X display category product headers by increment X
InputBox, intIterate, Headers, Update how many headers?, , , , , , , ,1
InputBox, intIncrement, Increment, Increment each Display Order by?, , , , , , , ,10
InputBox, intDisplayOrder, Start Value, Starting from what value?, , , , , , , ,%intIncrement%
if ErrorLevel
{
	; user pressed cancel
	return
}
else
{
	Loop %intIterate%
	{
		send %intDisplayOrder%{down}
		intDisplayOrder += intIncrement
	}
}
return


;=========================================================
^!r:: ; PRODUCT RETURN:	Return X items in RTP ONE|Resort Tools (must have already searched by TranID with focus still in text box)

; Did you execute from an RTP window?
_windowCheckActiveProcess( "rtponecontainer" )
; Do we only have one instance of RTP Update?
_windowContinueSingleOnly( "Return Refund Tool" )
; Prompt for iteration count
intIterate := _InputBox( "Return how many items?", 1 ) ; Detect tree items possible?

; Move control to the search text box before proceeding
ControlFocus, WindowsForms10.EDIT.app.0.30495d1_r11_ad11, A

Send {tab 3}{Home}{down 3}
Loop %intIterate% {
	SendInput {tab 3}{space}+{tab 3}{down}
}
; Move to last item in treeview so next piece works if not refunded 100% of items in order
Send {End}
; Send to next listview for checking
Send {Tab 3}

; Botch loop to detect when RTP's slow-ass has finished returning products
Loop {
	ControlGetFocus, strFocus, Return Refund Tool
	if ( strFocus = "WindowsForms10.Window.8.app.0.30495d1_r11_ad11" ) {
		break
	} else {
		Sleep 300
	}
}

; Auto apply items returned?
; @todo inconsitently (normally first use) doesn't reach correct box to tick
MsgBox, 68, RTP Macro Information, Auto "Apply" items refunded?
IfMsgBox, No
	exit
Else {
	Send ^{Space}
	Send {Tab 4}
	Loop %intIterate% {
		Send {Space}{Down}{Tab}+{Tab}
	}
}
; Shift focus to OK button
ControlFocus, OK, A

; IDEA: Tab to treeview, down three (to first item), on each item down check if RETURN button is Enabled and if so, return it
return


;=========================================================
^!b:: ; B-STORE:		Add seasonal Lift and Rental products to bStore with option for KSF
WinGetTitle, strBstore, A
;strBill := SubStr( strBstore, InStr(strBstore, "(")+1, InStr(strBstore, ")"-1 ) )
StringReplace, strBstore, strBstore, %A_SPACE%,, All
strBill := SubStr( strBstore, InStr(strBstore, "(")+1, (InStr(strBstore, ")" )-InStr(strBstore, "("))-1 )
if ( 0 < InStr( strBill, "," ) )
{
	strBillLift := SubStr( strBill, 1, 2 )
	strBillRent := SubStr( strBill, InStr( strBill, "," )+1, 2 )
}
else if ( 0 < InStr( strBill, "/" ) )
{
	strBillLift := SubStr( strBill, 1, 2 )
	strBillRent := SubStr( strBill, InStr( strBill, "/" )+1, 2 )
}
else
{
	strBillLift := strBill
	strBillRent := strBill
}

; Add Rental PB
Send {Tab}{space}{PGDN}{Up 7}{Tab}
_paymentMethod( strBillRent )
; Add Lift IS
Sleep 200
Send {Tab}{Space 2}
if ( 0 < inStr( strBstore, "Property") )
{
	blnProp := True
	Send {PgDn 2}{Down 8}
}
Else
{
	blnProp := False
	Send {PgDn}{Down 11}
}
Send {Tab}
_paymentMethod( strBillLift )
Send {Tab}{Space}
; Add KSF
if ( blnProp = False )
{
	MsgBox, 292, KSF?, Include KSF products?
	IfMsgBox Yes
	{
		; Lift
		Send {Space}{PgDn}{Down 12}{Tab}
		_paymentMethod( strBillLift )
		Send {Tab}{Space}
		; Rental
		Send {space}{PGDN}{Up 6}{Tab}
		_paymentMethod( strBillRent )

		Send {Tab}{Space}
	}
}


;=========================================================
^!e:: ; COMPONENT:	Process component names. If it contains P2P, prefix z, else add 0 to day number for natural ordering
Send {Tab 3}^a^c{Home}
;if InStr( clipboard, "Audit" )
;	Send ^{Right 2}0
;Else {
;	Send z
;	return
;}

if InStr( clipboard, "P2P" )
	Send {Home}z
Else
	Send ^{Right 2}0
	;Send {right}{backspace}
	;Send 0{end}{backspace 3}(HST)
;else
return


^!1:: ; DELETE:		1-Tab Delete (Product: Sales Location/Sales Channel/Component entry)
; update discount entry
	Send {tab}{space 2}
return

^!2:: ; DELETE:		2-Tab Delete (Component Output)
; update discount entry
	Send {tab 2}{space 2}+{Tab}{Space}
return

^!3:: ; DELETE:		3-Tab Delete (Discount/bStore entry)
	Send {tab 3}{space 2}
	Sleep 100
	Send {space}
return


;=========================================================
;=========================================================


^+1:: ; Reserved for quick throw-away macros to save 5 mins
	Send {Tab 3}{Home}^{Right}{Left}.
return

^+2:: ; Reserved for quick throw-away macros to save 5 mins
return


;=========================================================
;=========================================================
;=========================================================


; http://www.autohotkey.com/board/topic/56946-is-there-a-universal-abort-method-for-ahk-commands/



!^F8::
	