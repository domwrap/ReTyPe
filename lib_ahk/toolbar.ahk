/**
 * File containing class for building and rendering UI toolbars
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

#Include button.ahk
#Include menu.ahk

/**
 * Class for building and rendering UI toolbars
 *
 * @category	Automation
 * @package		ReTyPe
 * @author		Dominic Wrapson <dwrapson@whistlerblackcomb.com>
 * @copyright	2014 Dominic Wrapson
 */
class Toolbar {

	static strToolbar := "retype"
	static arrButtons := {}
	arrButtonOrder := {}

	/**
	 * Constructor
	 */
	__New() {
	}


	/**
	 * Destructor
	 */
	__Delete() {
		strToolbar := this.strToolbar
		Gui, %strToolbar%:Destroy
	}


	/**
	 * Add child element to toolbar
	 * Must be of type menu or button
	 */
	add( objMixed ) {
; @todo make add variadic so can accept multiple buttons and menus at once
		try {
			objMixed.setToolbar( this )

			if ( objMixed.HasKey( "arrMenus" ) ) {
				this.p_addMenu( objMixed )
			} else if ( objMixed.HasKey( "strTarget" ) ) {
				this.p_addButton( objMixed )
			} else {
				throw new Exception( "Invalid toolbar child")
			}
		} catch e {
			Debug.write( e )
		}
	}	


	/**
	 * Add a menu to the toolbar
	 * @protected
	 * @param object Button Instance of Button class
	 */
	addButton( objButton ) {
		objButton.setToolbar( this )
		this.arrButtons[objButton.strName] := objButton
		this.arrButtonOrder.Insert( objButton.strName )
	}


	p_prerender() {

	}


	p_postrender() {

	}


	/**
	 * Create the toolbar with buttons and menus
	 * 
	 * Once all information is gathered, render menu with correct order of
	 * code as syntax is very order-specific
	 */
	render() {
		strToolbar := this.strToolbar

		; Set margins
		Gui, %strToolbar%:Margin, 0, 0

		; Add buttons that can now point to menus
		for intOrder, strButton in this.arrButtonOrder {
			strOptions := ( 1 = A_Index ) ? "x0, y0" : "ym"
			this.arrButtons[strButton].render( strOptions )
		}

		; Strip off some crap from the ui we don't want, like titlebar, buttons, border, etc, and keep it up front (own dialogs doesn't seem to be working)
		Gui, %strToolbar%:-SysMenu +ToolWindow -Caption -Border +AlwaysOnTop +OwnDialogs
; @todo +OwnDialogs (make dialogs modal)

		return

		/*
*		 * MENU HANDLE
		 */
		fnMenu_Handle:
			global objRetype

			strTab := "`t"
			strMenuItem := A_ThisMenu SubStr( A_ThisMenuItem, 1, InStr( A_ThisMenuItem, strTab )-1 )
			StringReplace, strMenuItem, strMenuItem, %A_Space%,, All
			StringReplace, strMenuItem, strMenuItem, Menu
; @todo Make < and > hotkey modifiers work
			;strHotkey := objRetype.arrMenuHotkeys[strMenuItem].strHotKey
			;Send %strHotkey%
			objRetype.arrMenuHotkeys[strMenuItem].pour()
		return

		/**
		 * BUTTON MENU HANDLE
		 */
		fnButton_Menu_Handle:
			Menu, % "Menu" A_GuiControl, Show, 0, 23
			;A_GuiControl
		return

		/**
		 * NULL HANDLER
		 */
		fnNull:
			; Nothing here, placeholder for disabled menu items
		return
	}


	show() {
		strToolbar := this.strToolbar
		Gui, %strToolbar%:show
	}

}












;button = new Button( "name", "label" )
;menu = new Menu( "btnName", "mnuGroup", "lblMenu" )
;fmenu = new MenuFluid( objFluid )
;;?button.addItem(  )
;toolbar.add( button )
;toolbar.add( menu )

;new fToolbar.add( objFluid )



;; Build a UI
;Gui, Retype:Margin, 0, 0
;Gui, Retype:Add, Button, x0 y0 gfnMenuGeneral, G
;Gui, Retype:Add, Button, ym gfnMenuAdmin, A
;Gui, Retype:Add, Button, ym, C
;Gui, Retype:Add, Button, ym, O
;Gui, Retype:Add, Button, ym, V
;Gui, Retype:Add, Button, ym gfnMenuHelp, ?
;; Strip off some crap from the ui we don't want, like titlebar, buttons, border, etc, and keep it up front (own dialogs doesn't seem to be working)
;Gui, Retype:-SysMenu +ToolWindow -Caption -Border +AlwaysOnTop +OwnDialogs
;; @todo +OwnDialogs (make dialogs modal)
;; ------- Build the menus -------
;; --- GENERAL Menu
;; First add all the menu items
;Menu, MenuGeneral, Add, First section, fnRtpGuiCancel
;Menu, MenuGeneral, Add  ; Add a separator line.
;Menu, MenuGeneralSub, Add, Second section, fnRtpGuiCancel
;; Then string them all together
;Menu, MenuGeneral, Add, Second item, :MenuGeneralSub
;; --- ADMIN Menu
;; First add all the menu items
;; ------ Product
;Menu, MenuAdminProduct, Add, Bulk Pricing, fnRtpGuiCancel
;Menu, MenuAdmin, Add, Product, :MenuAdminProduct
;Menu, MenuAdmin, Add, Component, :MenuAdminComponent
;Menu, MenuAdmin, Add, Discount, :MenuAdminDiscount
;Menu, MenuAdmin, Add, Inventory, :MenuAdminInventory
;Menu, MenuAdmin, Add, Bstore, :MenuAdminBstore
;; ------ Component
;Menu, MenuAdminComponent, Add, First section, fnRtpGuiCancel
;; ------ Discount
;Menu, MenuAdminDiscount, Add, First section, fnRtpGuiCancel
;; ------ Inventory
;Menu, MenuAdminInventory, Add, Auto-populate, fnRtpGuiCancel
;; ------ bStore
;Menu, MenuAdminBstore, Add, Second section, fnRtpGuiCancel
;; --- HELP menu

