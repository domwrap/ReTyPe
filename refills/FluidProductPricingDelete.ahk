/**
 * File containing Refill class to facilitate deleting multiple pricing rows from a product header
 * Class will add itself to the parent retype instance
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
 * @copyright	2015 Dominic Wrapson
 * @license		Creative Commons Attribution-ShareAlike 4.0 International License http://creativecommons.org/licenses/by-sa/4.0/deed.en_US
 */


; Trigger my damn self (in a horrible way due to AHK limitations)
objRetype.refill( new FluidProductPricingDelete() )


/**
 * Refill to automatically delete X pricing rows from a product header
 *
 * @category	Automation
 * @package		ReTyPe
 * @author		Dominic Wrapson <dwrapson@whistlerblackcomb.com>
 * @copyright	2015 Dominic Wrapson
 */
class FluidProductPricingDelete extends Fluid {

	strHotkey		:= "^!+x"
	strMenuPath		:= "/Admin/Product"
	strMenuText		:= "Pricing Delete"
	intMenuIcon		:= 132 ;272

	/**
	 * Setup controls, window group, etc
	 */
	__New() {
		global objRetype
		base.__New()

		strGroup 	:= this.id
		strRTP		:= % objRetype.objRTP.classNN()
		GroupAdd, %strGroup%, Add ahk_class %strRTP%, Sales Report Group
		GroupAdd, %strGroup%, Update ahk_class %strRTP%, Sales Report Group
	}

	/**
	 * Where the magic happens
	 */
	pour() {
		global objRetype
		static intIterate := 1

		; Activate RTP (after toolbar has been clicked)
		objRetype.objRTP.Activate()
; @todo Check needs to be removed once I've managed to wall-in shortcuts in to the RTP only window
		; Run if it's ready!
		strGroup := this.__Class
		IfWinActive, ahk_group %strGroup%
		{
			; Did you execute from an RTP window?
			if ( objRetype.objRTP.isActive() ) {
				idWinRTP	:= WinActive("A")

				; Check which control has focus.  If it's not the pricing ListView then don't proceed
				if ( Window.CheckControlFocus( objRetype.objRTP.formatClassNN( "SysListView32", this.getConf( "ListPricing", 11 ) ), "Pricing ListView" ) ) {
					ControlGetFocus, strControlFocus

					; Prompt for iteration count
					intIterate := InputBox.show( "How many pricing entries do you wish to delete?`n`nEnter ALL to delete all remaining entries`nEnter DOWN to delete everything beneath selected row", 1 )
					; Allow entering ALL to delete all remaining items in the listview
					if ( "ALL" = intIterate ) {
						; Get how many are left
						ControlGet, intItems, List, Count, %strControlFocus%, A
						; Set the iteration to row total
						intIterate := intItems
						Sleep 200
					}
					if ( "DOWN" = intIterate ) {
						ControlGet, intItems, List, Count, %strControlFocus%, A
						ControlGet, intPos, List, Count Focused, %strControlFocus%, A
						intIterate := intItems - intPos + 1
						Sleep 100
						; listitems - listposn
					}
					; Input validation
					If intIterate not between 1 and 999
					{
						MsgBox.Stop( "You must enter a numerical value between 1 and 999.`n`nYou entered: " . intIterate )
					}
					; Confirmation message for massive delete requests
					if ( 10 < intIterate ) {
						MsgBox.YesNo( "You've asked to delete [" . intIterate . "] entries which seems like a lot. Continue?" )
						IfMsgBox, No
							return
					}
					; If we made it this far, let's nuke some stuff
					Loop %intIterate%
					{
						WinActivate, ahk_id %idWinRTP%
						SendInput {Space}{AppsKey}d{Space}
					}
				}
			}
		}
	}

}