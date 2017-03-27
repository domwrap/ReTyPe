
objRetype.refill( new FluidProductPricingBulkUI() )

class FluidProductPricingBulkUI {

	static id			:= "FluidProductPricingBulkUI"
	static intTimer		:= 500

	pour() {
		; BULK PRICING:	Resize the pricing season drop-down
		IfWinActive, Product Header Pricing Bulk Update ahk_class WindowsForms10.Window.8.app.0.30495d1_r11_ad1, Selected Price Update Details
		{
			if ( Window.CheckActiveProcess( "rtponecontainer" ) ) {
				strControl = WindowsForms10.COMBOBOX.app.0.30495d1_r11_ad11
				ControlMove, %strControl%, , , 400, , A
			}
		}
	}

}