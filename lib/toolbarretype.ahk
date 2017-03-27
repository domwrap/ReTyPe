
#Include toolbar.ahk


class ToolbarRetype extends Toolbar {

	__New() {

	}

	p_prerender() {
		objBtnGeneral := new Button( "General", "fnButton_Menu_Handle", "G" )
		objBtnGeneral.addMenu( new Menu( "fnNull", "Menu Item" ) )
		this.addButton( objBtnGeneral )
		objBtnAdmin := new Button( "Admin", "fnButton_Menu_Handle", "A" )
		this.addButton( objBtnAdmin )

		objBtnAdmin.addMenu( new Menu( "fnNull", "Administration", false ) )
		objBtnAdmin.addMenu( new Menu( "fnNull", "" ) )

		objMenuAdminProduct := new Menu( "fnMenu_Handle", "Product" )
		objBtnAdmin.addMenu( objMenuAdminProduct )
		;objMenuAdminProduct.addChild( new Menu( "fnAbout", "Bulk Pricing" ) )
		;objMenuAdminProduct.addChild( new Menu( "fnAbout", "Bulk Update", false ) )
		;objMenuAdminProduct.addChild( new Menu( "fnAbout", "Bulk Third" ) )

		objMenuAdminComponent := new Menu( "fnMenu_Handle", "Component" )
		objBtnAdmin.addMenu( objMenuAdminComponent )
		;objSub := new Menu( "fnNull", "Testing11" )
		;objMenuAdminComponent.addChild( objSub )
		; Depending on order of addMenu added cannot do third level menus
		; They either just overwrite all previously added, or sub-menu not defined
		;objSub.addChild( new Menu( "fnNull", "Third Level" ) )
		;objMenuAdminComponent.addChild( objSub )

		this.addButton( new Button( "Component", "", "C" ) )
		this.addButton( new Button( "OneResort", "", "O" ) )
		this.addButton( new Button( "Voucher", "", "V" ) )

		objBtnHelp := new Button( "Help", "fnButton_Menu_Handle", "?" )
		objBtnHelp.addMenu( new Menu( "fnNull", "&F1 Help", false ) )
		objBtnHelp.addMenu( new Menu( "", "" ) )
		objBtnHelp.addMenu( new Menu( "fnAbout", "About ReTyPe" ) )
		this.addButton( objBtnHelp )





		;; ------- Build the menus -------
		;; --- GENERAL Menu
		;this.add( new Menu( "General", "fnNull", "Menu Item" ) )
		;; --- ADMIN Menu



		;; --- HELP Menu
		;this.add( new Menu( "Help", "fnNull", "&F1 Help" ) )
		;this.add( new Menu( "Help" ) )
		;this.add( new Menu( "Help", "fnAbout", "About ReTyPe" ) )

		; Get out now before we start activating menus
		return

		fnAbout:
;msgbox % A_ThisMenu ":" A_ThisMenuItem
			MsgBox % "ReTyPe`nRTP: Emending Your Errors`n`n" . chr(169) . " Dominic Wrapson, 2014"
		return

	}


	p_postrender() {
		;Menu, MenuAdmin, Disable, Administration
		;Menu, MenuHelp, Disable, &F1 Help
	}

	/**
	 * Check if menu being added to exists in list and exception if not
	 */
	addMenu( objMenu ) {
		; Figure out hierarchy of button/menu and add to end
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
