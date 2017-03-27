
#Include toolbar.ahk


class ToolbarRetype extends Toolbar {

	__New() {

	}

	p_prerender() {
		this.add( new Button( "fnMenuGeneral", "G" ) )
		this.add( new Button( "fnMenuAdmin", "A" ) )
		this.add( new Button( "", "C" ) )
		this.add( new Button( "", "O" ) )
		this.add( new Button( "", "V" ) )
		this.add( new Button( "fnMenuHelp", "?" ) )


		; ------- Build the menus -------
		; --- GENERAL Menu
		this.add( new Menu( "General", "fnMenuGeneral", "Menu Item" ) )
		; --- ADMIN Menu
		this.add( new Menu( "Admin", "fnHeaderNull", "Administration" ) )
		this.add( new Menu( "Admin", "fnHeaderNull" ) )
		objMenuAdminProduct := new Menu( "Admin", "fnMenuAdmin", "Product" )
		objMenuAdminProduct.addMenu( new Menu( "Product", "fnAbout", "Bulk Pricing" ) )
		objMenuAdminProduct.addMenu( new Menu( "Product", "fnHeaderNull", "Bulk Update" ) )
		this.add( objMenuAdminProduct )
		objMenuAdminComponent := new Menu( "Admin", "fnAbout", "Component" )
		objSub := new Menu( "Component", "fnHeaderNull", "Testing11" )
		objSub.addMenu( new Menu( "Component", "fnHeaderNull", "Third Level" ) )
		objMenuAdminComponent.addMenu( objSub )
		this.add( objMenuAdminComponent )
		; --- HELP Menu
		this.add( new Menu( "Help", "fnHeaderNull", "&F1 Help" ) )
		this.add( new Menu( "Help" ) )
		this.add( new Menu( "Help", "fnAbout", "About ReTyPe" ) )

		; Get out now before we start activating menus
		return

		fnMenuGeneral:
;msgbox % A_GuiControl " : " A_Gui " : " A_GuiEvent " : " A_EventInfo
			Menu, MenuGeneral, Show
		return

		fnMenuAdmin:
			;Menu, MenuAdmin, Disable, Administration
			Menu, MenuAdmin, Show
		return

		fnMenuHelp:
; @todo Singleton accessor on Toolbar to disable menu items by object
			Menu, MenuHelp, Show
		return

		fnAbout:
;msgbox % A_ThisMenu ":" A_ThisMenuItem
			MsgBox % "ReTyPe`nRTP: Emending Your Errors`n`n" . chr(169) . " Dominic Wrapson, 2014"
		return

	}


	p_postrender() {
		Menu, MenuAdmin, Disable, Administration
		Menu, MenuHelp, Disable, &F1 Help
	}

	/**
	 * Check if menu being added to exists in list and exception if not
	 */
	p_addMenu( objMenu ) {
		base.p_addMenu( objMenu )
	}


	render() {
		this.p_prerender()
		; Do the parent's stuff first
		base.render()

		; Load timer
		SetTimer, fnToolbarRetype, 100
		; return here so we don't drop in to the label beneath it (that's for the timer only)

		this.p_postrender()
		return

		fnToolbarRetype:
			strToolbar := ToolbarRetype.strToolbar

			; Get RTP window for later reference
			WinGet, idWinRTP, ID, RTP|ONE Container ahk_class WindowsForms10.Window.8.app.0.30495d1_r11_ad1

			; Hide the toolbar if window is minimized
			WinGet, intWinRtpMinMax, MinMax, ahk_id %idWinRTP%
			If ( -1 = intWinRtpMinMax ) {
				Gui, Retype:Hide
			} else {
; @todo change to process check (rtp.exe) so works with child windows
				IfWinActive, ahk_id %idWinRTP%
				{
					; Find window position and calculate toolbar position
					WinGetPos, intWinX, intWinY, intWinW, intWinH
					intGuiX := intWinX + intWinW - ( intWinW / 2 ) + 50
					intGuiY := intWinY + 2
					; Either of these appear to work, though the latter doesn't actually color anything
					WinSet, Transparent, 175, Retype
					;WinSet, TransColor, %rgbRtpTitle% 150, Retype
					; Render!
					Gui, Retype:Show, NA x%intGuiX% y%intGuiY%, Retype
					WinGet, idWinRetype, ID, Retype ahk_class AutoHotkeyGUI
				}
			}

			IfWinNotExist, ahk_id %idWinRTP%
			{
				; If RTP don't exist, don't needs no toolbar
				Gui, %strToolbar%:Hide
			}

			; Group the RTP and Retype windows together as it's the only way !WinActive will work
			GroupAdd, grpWinRtp, ahk_id %idWinRTP%
			GroupAdd, grpWinRtp, ahk_id %idWinRetype%
			If !WinActive("ahk_group grpWinRtp")
			{
				; This code stops toolbar showing in other apps
				Gui, %strToolbar%:Hide
			}
		return
	}

}
