/**
 * File containing class for building and rendering ReTyPe UI toolbars
 *
 * AutoHotKey v1.1.13.01+
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Affero General Public License as published
 * by the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 * 
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Affero General Public License for more details.
 * 
 * You should have received a copy of the GNU Affero General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 *
 * @category	Automation
 * @package		ReTyPe
 * @author		Dominic Wrapson <dwrapson@whistlerblackcomb.com>
 * @copyright	2014 Dominic Wrapson
 * @license		GNU AFFERO GENERAL PUBLIC LICENSE Version 3, 19 November 2007 http://www.gnu.org/licenses/
 */

#Include %A_ScriptDir%\lib_ahk
#Include toolbar.ahk

/**
 * Class for building and rendering ReTyPe UI toolbars
 *
 * @category	Automation
 * @package		ReTyPe
 * @author		Dominic Wrapson <dwrapson@whistlerblackcomb.com>
 * @copyright	2014 Dominic Wrapson
 */
class ToolbarRetype extends Toolbar {

	static strToolbar := "retype"

	/**
	 * Constructor
	 */
	__New( strButtons="" ) {

		EnvGet, RootDirectory, SystemDrive
		RootDirectory := RootDirectory "\Windows"

		; BUTTON: General
		If ( InStr( strButtons, "G" ) ) {
			objBtnGeneral := new Button( "General", "fnButton_Menu_Handle", "G" )
			this.addButton( objBtnGeneral )
			objMenuGeneral := new Menu( "fnNull", "General", false )
			objMenuGeneral.setIcon( RootDirectory "\System32\shell32.dll", 22 )
			objBtnGeneral.addMenu( objMenuGeneral )
			objBtnGeneral.addMenu( new Menu( "fnNull", "" ) )
		}
		; BUTTON: OneResort
		If ( InStr( strButtons, "O" ) ) {
			objButtonOneResort := new Button( "OneResort", "fnButton_Menu_Handle", "O" )
			this.addButton( objButtonOneResort )
			objMenuOneResort := new Menu( "fnNull", "ONE|Resort", false )
			objMenuOneResort.setIcon( RootDirectory "\System32\shell32.dll", 16 )
			objButtonOneResort.addMenu( objMenuOneResort )
			objButtonOneResort.addMenu( new Menu( "fnNull", "" ) )
		}
		; BUTTON: Customer Manager
		If ( InStr( strButtons, "C" ) ) {
			objBtnCustomer := new Button( "CusMan", "fnButton_Menu_Handle", "C" )
			this.addButton( objBtnCustomer )
			objMenuCustomer := new Menu( "fnNull", "Customer Manager", false )
			objMenuCustomer.setIcon( RootDirectory "\System32\shell32.dll", 161 )
			objBtnCustomer.addMenu( objMenuCustomer )
			objBtnCustomer.addMenu( new Menu( "fnNull", "" ) )
			; Sub menus
			objMenuCusManComment := new Menu( "fnMenu_Handle", "Comments" )
			objBtnCustomer.addMenu( objMenuCusManComment )
		}
		; BUTTON: Admin
		If ( InStr( strButtons, "A" ) ) {
			objBtnAdmin := new Button( "Admin", "fnButton_Menu_Handle", "A" )
			this.addButton( objBtnAdmin )
			objMenuAdmin := new Menu( "fnNull", "Administration", false )
			objMenuAdmin.setIcon( RootDirectory "\System32\shell32.dll", 166 )
			objBtnAdmin.addMenu( objMenuAdmin )
			objBtnAdmin.addMenu( new Menu( "fnNull", "" ) )
			; sub menus
			objMenuAdminProduct := new Menu( "fnMenu_Handle", "Product" )
			objBtnAdmin.addMenu( objMenuAdminProduct )
			objMenuAdminComponent := new Menu( "fnMenu_Handle", "Component" )
			objBtnAdmin.addMenu( objMenuAdminComponent )
			objMenuAdminInventory := new Menu( "fnMenu_Handle", "Inventory" )
			objBtnAdmin.addMenu( objMenuAdminInventory )
			objMenuAdminDiscount := new Menu( "fnMenu_Handle", "Discount" )
			objBtnAdmin.addMenu( objMenuAdminDiscount )
			objMenuAdminCommission := new Menu( "fnMenu_Handle", "Commission" )
			objBtnAdmin.addMenu( objMenuAdminCommission )
		}
		; BUTTON: Voucher
		If ( InStr( strButtons, "V" ) ) {
			objButtonVoucher := new Button( "Voucher", "fnButton_Menu_Handle", "V" )
			this.addButton( objButtonVoucher )
			objMenuVoucher := new Menu( "fnNull", "Voucher Tools", false )
			objMenuVoucher.setIcon( RootDirectory "\System32\shell32.dll", 55 )
			objButtonVoucher.addMenu( objMenuVoucher )
			objButtonVoucher.addMenu( new Menu( "fnNull", "" ) )
		}
		; BUTTON: UAT
		If ( InStr( strButtons, "U" ) ) {
			objButtonUAT := new Button( "UAT", "fnButton_Menu_Handle", "U" )
			this.addButton( objButtonUAT )
			objMenuUAT := new Menu( "fnNull", "User Acceptance Testing", false )
			objMenuUAT.setIcon( RootDirectory "\System32\shell32.dll", 81 )
			objButtonUAT.addMenu( objMenuUAT )
			objButtonUAT.addMenu( new Menu( "fnNull", "" ) )
		}
		; BUTTON: DEBUG
		If ( InStr( strButtons, "D" ) ) {
			objButtonDebug := new Button( "Debug", "fnButton_Menu_Handle", "D" )
			this.addButton( objButtonDebug )
			objMenuDebug := new Menu( "fnNull", "Debug Tools", false )
			objMenuDebug.setIcon( RootDirectory "\System32\shell32.dll", 91 )
			objButtonDebug.addMenu( objMenuDebug )
			objButtonDebug.addMenu( new Menu( "fnNull", "" ) )
		}

		; BUTTON: Help
		objBtnHelp := new Button( "Help", "fnButton_Menu_Handle", "?" )
		objMenuHelp := new Menu( "fnNull", "&Help`tWin+F1", false )
		objMenuHelp.setIcon( RootDirectory "\System32\shell32.dll", 24 )
		objBtnHelp.addMenu( objMenuHelp )
		objMenuAbout := new Menu( "fnAbout", "&About ReTyPe" )
		objMenuAbout.setIcon( RootDirectory "\System32\shell32.dll", 278 )
		objBtnHelp.addMenu( objMenuAbout )
		objBtnHelp.addMenu( new Menu( "", "" ) )
		objMenuUpdate := new Menu( "fnNull", "Check for &Updates", false )
		objMenuUpdate.setIcon( RootDirectory "\System32\shell32.dll", 123 ) ;Alt icons 81,163,167,239,280
		objBtnHelp.addMenu( objMenuUpdate )
		objMenuReload := new Menu( "fnReload", "&Reload ReTyPe" )
		objMenuReload.setIcon( RootDirectory "\System32\shell32.dll", 152 )
		objBtnHelp.addMenu( objMenuReload )
		objMenuExit := new Menu( "fnExit", "E&xit" )
		objMenuExit.setIcon( RootDirectory "\System32\shell32.dll", 28 )
		objBtnHelp.addMenu( objMenuExit )
		;A_WinDir
		this.addButton( objBtnHelp )
	}

	/**
	 * Method executed before the main render pass
	 * @return void
	 */
	p_prerender() {
	}

	/**
	 * Method executed after the main render pass
	 * @return void
	 */
	p_postrender() {
	}

	/**
	 * Check if menu being added to exists in list and exception if not
	 */
	addMenu( objMenu ) {
		; Figure out hierarchy of button/menu and add to end
	}

	/**
	 * Main render pass
	 * @return void
	 */
	render() {
		; Pre-render stuff
		this.p_prerender()

		; Do the parent's stuff first
		base.render()

		; Load timer
		SetTimer, fnToolbarRetype, 1000

		; Any post-rendering stuff
		this.p_postrender()

		; return here so we don't drop in to the label beneath it (that's for the timer only)
		return

		; Label declaration to handle above timer
		; Declared after the method return so as to be compiled, but not executed automatically
		fnToolbarRetype:
			global objRetype
			strRTP := % objRetype.objRTP.classNN()
			strToolbar := ToolbarRetype.strToolbar

			; Get RTP window for later reference
			;WinGet, idWinRTP, ID, RTP|ONE Container ahk_class %strRTP%
			idWinRTP := objRetype.objRTP.getID()

			; Hide the toolbar if window is minimized
			WinGet, intWinRtpMinMax, MinMax, ahk_id %idWinRTP%
			If ( -1 = intWinRtpMinMax ) {
				Gui, Retype:Hide
			} else {
				; Changed check so works with child windows
				;IfWinActive, ahk_id %idWinRTP%
				IfWinActive, ahk_class %strRTP%
				{
					; Find window position and calculate toolbar position
					strParentTitle := objRetype.objRTP.strTitle
					strParentClass := objRetype.objRTP.ClassNN()
					WinGet, idWinRTPParent, ID, %strParentTitle% ahk_class %strParentClass%

					WinGetPos, intWinX, intWinY, intWinW, intWinH, ahk_id %idWinRTPParent%
					intGuiX := intWinX + intWinW - ( intWinW / 4 ) ;+ 50
					intGuiY := intWinY + 2

					; Either of these appear to work, though the latter doesn't actually color anything
					WinSet, Transparent, 175, Retype
					;WinSet, TransColor, %rgbRtpTitle% 150, Retype

					; Additional check needed as sometimes window was closed between passing the IfWinActive
					; but before getting to the render here where X and Y are used
					IfWinExist, ahk_id %idWinRTP%
					{
						; Render!
						Gui, Retype:Show, NA x%intGuiX% y%intGuiY%, Retype
					}
					WinGet, idWinRetype, ID, Retype ahk_class AutoHotkeyGUI
				}
			}

			; If RTP don't exist, don't needs no toolbar
			IfWinNotExist, ahk_id %idWinRTP%
			{
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
