/**
 * File containing class for merging old P2P component pricing in to current relevant component
 * Though could technically be used to merge any two pieces of component pricing, spaced by X
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
 * @copyright	2013 Dominic Wrapson
 * @license		Creative Commons Attribution-ShareAlike 4.0 International License http://creativecommons.org/licenses/by-sa/4.0/deed.en_US
 */


; Trigger my damn self (in a horrible way due to AHK limitations)
objRetype.refill( new FluidProductPricingMerge() )


/**
 * Merge old P2P component pricing in to current relevant component
 *
 * @category	Automation
 * @package		ReTyPe
 * @author		Dominic Wrapson <dwrapson@whistlerblackcomb.com>
 * @copyright	2013 Dominic Wrapson
 */
class FluidProductPricingMerge extends Fluid {

	strHotkey		:= "^!f"
	strMenuPath		:= "/Admin/Product"
	strMenuText		:= "Pricing Merge"
	intMenuIcon		:= 81 ;25 ; 88 ; 306

	/**
	 * Setup controls, window group, etc
	 */
	__New() {
		global objRetype
		base.__New()

		strGroup	:= this.id
		strRTP		:= % objRetype.objRTP.classNN()
		GroupAdd, %strGroup%, Update ahk_class %strRTP%, Sales Report Group
	}

	/**
	 * Where the magic happens
	 */
	pour() {
		global objRetype
		static intIterate := 1
		static intChannels := 3

		; Activate RTP (after toolbar has been clicked)
		objRetype.objRTP.Activate()

		; Detect PriceType selection for how we update the pricing with keystrokes
		strSelected := objRetype.objRTP.formatClassNN( "COMBOBOX", this.getConf( "ComboPriceType", 18 ) )

		; Run if it's ready!
		strGroup := this.__Class
		IfWinActive, ahk_group %strGroup%
		{
			if ( objRetype.objRTP.isActive() ) {
				idWinRTP	:= WinActive("A")

				; Prompt for components and channels
				intIterate := InputBox.show( "Merge how many sets of pricing?", intIterate )
				intChannels := InputBox.show( "How many Sales Channels do we have?", intChannels )

				Loop %intIterate% {
					strListPricing := objRetype.objRTP.formatClassNN( "SysListView32", this.getConf( "ListPricing", 11 ) )
					ControlFocus, %strListPricing%, ahk_id %idWinRTP%

					; Move from start point down X channels to extract price
					Send {Down %intChannels%}
					; Select row in ListView, right-click, choose Update
					Send {Space}{AppsKey}u
					; Wait for Pricing update window to load, max of 2 seconds then continue
					WinWait, Pricing, , 5
					; Send extra tabs for price by date
					if ( strSelected = "By Date") {
						Send {Tab 2}
					}
					Send {Tab}
					; Get text from control
					ControlGetFocus, strControlPrice1, A
					ControlGetText, intPrice1, %strControlPrice1%, A
					; Close update window
					ControlClick, Cancel, A
					Send {Space}

					; Then move back up to add it on
					Send {Up %intChannels%}

					Loop %intChannels% {
						; Select row in ListView, right-click, choose Update
						Send {Space}{AppsKey}u
						; Wait for Pricing update window to load, max of 2 seconds then continue
						WinWait, Pricing, , 5
						; Send extra tabs for price by date
						if ( strSelected = "By Date") {
							Send {Tab 2}
						}
						; Get current price, add on first price, put total back in control
						Send {Tab}
						ControlGetFocus, strControlPrice2, A
						ControlGetText, intPrice2, %strControlPrice2%, A
						Send +{Tab}%intPrice2%{Tab}
						intPriceTotal := intPrice1 + intPrice2
						Send {BackSpace}%intPriceTotal%
						ControlClick, OK, A
						Send {Space}{Down}
					}

					; Then move back down to delete the unwanted ones
					Loop %intChannels% {
						SendInput {Space}{AppsKey}d{Space}
					}

					; Now highlight the next starting point, and go again!
					Send {Space}
				}
			} else {
; @todo change this
				msgbox not for you!
			}
		}
	}

}
