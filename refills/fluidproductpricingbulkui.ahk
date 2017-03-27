
objRetype.refill( new FluidProductPricingBulkUI() )

class FluidProductPricingBulkUI extends Fluid {

	static intTimer	:= 500
	intComboBox		:=


	__New() {
		global objRetype
		base.__New()

		strRTP		:= % objRetype.objRTP.classNN()
		strGroup	:= this.id
		GroupAdd, %strGroup%, Product Header Pricing Bulk Update ahk_class %strRTP%, Selected Price Update Details

		this.intComboBox := this.getConf( "ComboBox", 11 )
	}


	fill() {

	}


	pour() {
		global objRetype

		; BULK PRICING:	Resize the pricing season drop-down
		strGroup := this.__Class
		IfWinActive, ahk_group %strGroup%
		{
			if ( Window.CheckActiveProcess( "rtponecontainer" ) ) {
				strControl := objRetype.objRTP.formatClassNN( "COMBOBOX", this.intComboBox )
				ControlMove, %strControl%, , , 400, , A
			}
		}
	}

}