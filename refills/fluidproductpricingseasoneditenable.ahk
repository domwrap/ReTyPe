
objRetype.refill( new FluidProductPricingSeasonEditEnable() )

class FluidProductPricingSeasonEditEnable extends Fluid {

	static intTimer		:= 500


	__New() {
		strGroup := this.id
		GroupAdd, %strGroup%, Pricing ahk_class WindowsForms10.Window.8.app.0.30495d1_r11_ad1, Price Allocation
	}


	fill() {

	}


	pour() {
return
; DISABLE THIS REFILL UNTIL WE KNOW ENABLING THE COMBO AND SAVING DOESN'T BREAK A HEAP OF STUFF



		; BULK PRICING:	Resize the pricing season drop-down
		strGroup := this.__Class

		IfWinActive, ahk_group %strGroup%
		{
			strControl = WindowsForms10.COMBOBOX.app.0.30495d1_r11_ad11
			ControlGet, blnCtl, Enabled,, %strControl%
			if ( !blnCtl ) {
				WinGetPos, intWinX, intWinY,,,
				ControlGetPos, intCtlX, intCtlY,,, %strControl%,
				intGuiX := intWinX + intCtlX -53
				intGuiY := intWinY + intCtlY -1
				Gui, Pricing:Add, Button, x0 y0 gfnEnablePricingSeasonCombo, Enable?
				Gui, Pricing:Margin, 0, 0
				Gui, Pricing:-SysMenu +ToolWindow -Caption -Border +AlwaysOnTop
				Gui, Pricing:Show, NA x%intGuiX% y%intGuiY%
			}
		}
		IfWinNotExist, ahk_group %strGroup%
		{
			Gui, Pricing:Hide
		}
		return

		/**
		 * Adds a border-less UI with a single button next to the disabled Pricing combobox
		 * Appears to "add" a button to the UI when in fact it floats above it but never steals focus
		 * Now that's MAGIC!
		 */
		fnEnablePricingSeasonCombo:
			WinGet, idWin, ID, Pricing ahk_class WindowsForms10.Window.8.app.0.30495d1_r11_ad1, Price Allocation

			strControl = WindowsForms10.COMBOBOX.app.0.30495d1_r11_ad11
			Control, Enable, , %strControl%, ahk_id %idWin%
			WinActivate, Pricing ahk_id %idWin%

			Gui, Pricing:Hide
		return
	}

}