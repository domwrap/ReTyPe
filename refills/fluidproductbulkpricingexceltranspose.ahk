
objRetype.refill( new FluidProductBulkPricingExcelTranspose )

class FluidProductBulkPricingExcelTranspose {

	static id			:= "FluidProductBulkPricingExcelTranspose"

	fill() {
		; @todo code here to register menu

		; ### Register hotkey
		; build class.method to pass through (cannot do it inline)
		strMethod := % this.id ".pour"
		; Bind the hotkey about to be created to particular window, therefore it doesn't get run somewhere it shouldn't
		; and also allows us to use the same hotkey in multiple places but for different things
		Hotkey, IfWinActive, Product Header Pricing Bulk Update ahk_class WindowsForms10.Window.8.app.0.30495d1_r11_ad1, Selected Price Update Details
		; Adds hotkey [The last "" param appears to be required otherwise the dynamic class.method call doesn't work]
		Hotkey.add( "!^h", strMethod, "" )
	}


	pour() {
		; BULK PRICING:	Resize the pricing season drop-down
		IfWinActive, Product Header Pricing Bulk Update ahk_class WindowsForms10.Window.8.app.0.30495d1_r11_ad1, Selected Price Update Details
		{

			if ( Window.CheckActiveProcess( "rtponecontainer" ) ) {
				idWinRTP	:= WinActive("A")
				;~ idWinExcel	:= Window.GetID( "Excel", "Excel", "XLMAIN" )

				; Grab active Excel window
				try {
					objExcel := ComObjActive("Excel.Application")
				} catch e {
					Debug.log( e )
					MsgBox.stop( "Could not attach to Excel spreadsheet" )
				}
				; @see http://www.autohotkey.com/board/topic/56987-com-object-reference-autohotkey-l/page-4#entry381256
				; @see http://msdn.microsoft.com/en-us/library/bb257110(v=office.12).aspx

				; Prompt for components and channels
				intIterate := InputBox.show( "Transpose how many Excel rows?", 1 )
				intChannels := InputBox.show( "How many Sales Channels do we have?", 3 )

; @todo Detect Excel windows, if more than one provide means of selecting which to use

				; Get us to the pricing entry for selected row
				ControlFocus, OK, ahk_id %idWinRTP%
				Send {Tab}{Home}{Right 6}

				Loop %intIterate% {
					; If first iteration, don't offset as using currently selected cell
					intOffset := ( 1 = A_Index ) ? 0 : 1

					; Select cell we're going to grab (shift this down each time so can keep track)
					objExcel.ActiveCell.Offset( intOffset, 0).Select
					; Grab value from Excel (formula value to detect bad grid)
					mixValue := objExcel.ActiveCell.Formula

					; Check for formulae
					if ( InStr( mixValue, "=" ) ) {
						MsgBox.stop( "Formula in pricing input cell " objExcel.ActiveCell.Address )
; @todo Change to continue:yes/no and if yes, skip next %intChannels% and continue
					}
					; Check value contents (should be an integer number!)
					if mixValue is not number
						MsgBox.stop( "Invalid pricing detected (non integer/decimal) in cell " objExcel.ActiveCell.Address )

					; If we're here we're good, input pricing
					Loop %intChannels% {
						Send %mixValue%{Down}
					}
				}
			}
		}
	}

}
