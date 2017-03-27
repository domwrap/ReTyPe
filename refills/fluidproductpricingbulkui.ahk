
objRetype.refill( new FluidProductPricingBulkUI() )

class FluidProductPricingBulkUI extends Fluid {

	static intTimer		:= 500


	__New() {
		strGroup := this.id
		GroupAdd, %strGroup%, Product Header Pricing Bulk Update ahk_class WindowsForms10.Window.8.app.0.30495d1_r11_ad1, Selected Price Update Details
	}


	fill() {

	}


	pour() {
		; BULK PRICING:	Resize the pricing season drop-down
		strGroup := this.__Class
		IfWinActive, ahk_group %strGroup%
		{
			if ( Window.CheckActiveProcess( "rtponecontainer" ) ) {
				strControl = WindowsForms10.COMBOBOX.app.0.30495d1_r11_ad11
				ControlMove, %strControl%, , , 400, , A
			}
		}
	}

}