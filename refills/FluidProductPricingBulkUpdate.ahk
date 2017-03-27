/**
 * File containing Refill class to facilitate bulk-pricing product headers
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
objRetype.refill( new FluidProductPricingBulkUpdate() )


/**
 * Refill to automatically update X pricing rows in bulk pricing
 *
 * @category	Automation
 * @package		ReTyPe
 * @author		Dominic Wrapson <dwrapson@whistlerblackcomb.com>
 * @copyright	2015 Dominic Wrapson
 */
class FluidProductPricingBulkUpdate extends Fluid {


	strHotkey		:= "^!p"
	strMenuPath		:= "/Admin/Product"
	strMenuText		:= "Bulk Pricing Update"
	intMenuIcon		:= 306


	/**
	 * Setup controls, window group, etc
	 */
	__New() {
		global objRetype
		base.__New()

		strGroup 	:= this.id
		strRTP		:= % objRetype.objRTP.classNN()
		GroupAdd, %strGroup%, Product Header Pricing Bulk Update ahk_class %strRTP%
	}


	/**
	 * Where the magic happens
	 * @param bool blnDown Determines whether we move down X rows after updating pricing (useful when there's components to skip, like P2P)
	 */
	pour( blnDown=false ) {
		global objRetype
		static intIterate := 3

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

				; Check they user is only trying to delete list items
				ControlGetFocus, strControlFocus
				if ( !InStr( strControlFocus, "Window.8" ) ) {
					MsgBox.stop( "Bulk Pricing: Prices listview must be active" )
				}

				intPrice := InputBox.show( "What's the NEW product price?", 9999 )
				intIterate := InputBox.show( "How many components are we updating?", intIterate )
; @todo: Calculate how many rows are remaining to use as default value by doing
; remaining = listviewrows - listviewposition
; @todo: If a high-number entered (>10), ask "Are you sure, you crazy bitch?"

				; Get us to the pricing entry for selected row
				Send ^{Space 2}{Right 6}

				; Go around X times
				Loop %intIterate%
				{
					; Send the entered price
					SendInput %intPrice%
					; Move down a line
					SendInput {Down}
				}

				; Extra condition in place for extended (Child) class which does exactly the same thing, but then moves down X rows after the last price change
				; Which is (was) useful for skipping things like P2P pricing
				if ( true=blnDown ) {
					SendInput {Down %intIterate%}
				}

				SendInput {Left 2}
			}
		}
	}


}