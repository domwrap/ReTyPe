
objRetype.refill( new FluidProductDeletePricing() )

class FluidProductDeletePricing extends Fluid {

	strHotkey := "^!x"
	strMenuPath		:= "/Admin/Product"
	strMenuText		:= "Pricing Delete"
	intMenuIcon		:= 272

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

		; Run if it's ready!
		strGroup := this.__Class
		IfWinActive, ahk_group %strGroup%
		{
			; Did you execute from an RTP window?
			if ( objRetype.objRTP.isActive() ) {
				idWinRTP	:= WinActive("A")

				; Check which control has focus.  If it's not the pricing ListView then don't proceed
				Window.CheckControlFocus( objRetype.objRTP.formatClassNN( "SysListView32", this.getConf( "ListPricing", 11 ) ), "Pricing ListView" )

				; Prompt for iteration count
				intIterate := InputBox.show( "How many pricing entries do you wish to delete?", 1 )

				Loop %intIterate%
				{
					WinActivate, ahk_id %idWinRTP%
					SendInput {Space}{AppsKey}d{Space}
				}
			}
		}
	}

}