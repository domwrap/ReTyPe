/**
 * File containing class for building and rendering UI toolbars
 *
 * AutoHotKey v1.1.13.01+
 *
 * LICENSE: This work is licensed under a version 4.0 of the
 * Creative Commons Attribution-ShareAlike 4.0 International License
 * that is available through the world-wide-web at the following URI:
 * http://creativecommons.org/licenses/by-sa/4.0/deed.en_US
 *
 * @category	Automation
 * @package		ReTyPe
 * @author		Dominic Wrapson <dwrapson@whistlerblackcomb.com>
 * @copyright	2014 Dominic Wrapson
 * @license		Creative Commons Attribution-ShareAlike 4.0 International License http://creativecommons.org/licenses/by-sa/4.0/deed.en_US
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
	static arrMenus := {}
	arrButtons := {}

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
		try {
			objMixed.setToolbar( this )

			if ( objMixed.HasKey( "strParent" ) ) {
				this.p_addMenu( objMixed )
			} else if ( objMixed.HasKey( "strTarget" ) ) {
				this.p_addButton( objMixed )
			} else {
				throw new Exception( "Invalid toolbar child")
			}
		} catch e {
			Debug.log( e )
		}
	}	


	/**
	 * Add a menu to the toolbar
	 * @protected
	 * @param object Button Instance of Button class
	 */
	p_addButton( objButton ) {
		this.arrButtons.insert( objButton )
	}


	/**
	 * Add a menu to the toolbar
	 * @protected
	 * @param object Menu Instance of Menu class
	 */
	p_addMenu( objMenu ) {
		; Ensure sub-menus are added after higher level menus
		if ( false != objMenu.strParent ) {
; @todo count appearances of "Sub" and put in that level array, then go 0-down to draw
			this.arrMenus[1].insert( objMenu )
		} else {
			this.arrMenus[0].insert( objMenu )
		}
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

		; Add menus before buttons else cannot attach
		; Iterate the top level menu array (separates parents, from children)
		for intDepth, arrMenu in this.arrMenus {
			; Next iterate over respective arrays of menus
			for objMenu in arrMenu {
				; Create menu item
				Menu, objMenu.strMenu, Add, % objMenu.strText, Menu_Handle
				; If it's a sub-menu, add it to its parent
				if ( 1 > intDepth) {
					Menu, objMenu.strParent, Add, Second item, :objMenu.strMenu
				}
			}
		}

		; Add buttons that can now point to menus
		for intButton, objButton in this.arrButtons {
			strOptions := ( 1 = A_Index ) ? "x0, y0" : "ym"
			objButton.render( strOptions )
		}

		; Strip off some crap from the ui we don't want, like titlebar, buttons, border, etc, and keep it up front (own dialogs doesn't seem to be working)
		Gui, %strToolbar%:-SysMenu +ToolWindow -Caption -Border +AlwaysOnTop +OwnDialogs
		; @todo +OwnDialogs (make dialogs modal)

		return


		Menu_Handle:
			Toolbar.arrMenus()
			;A_ThisMenuItem
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
;; ------ Component
;Menu, MenuAdminComponent, Add, First section, fnRtpGuiCancel
;; ------ Discount
;Menu, MenuAdminDiscount, Add, First section, fnRtpGuiCancel
;; ------ Inventory
;Menu, MenuAdminInventory, Add, Auto-populate, fnRtpGuiCancel
;; ------ bStore
;Menu, MenuAdminBstore, Add, Second section, fnRtpGuiCancel
;; Then string them all together
;Menu, MenuAdmin, Add, Product, :MenuAdminProduct
;Menu, MenuAdmin, Add, Component, :MenuAdminComponent
;Menu, MenuAdmin, Add, Discount, :MenuAdminDiscount
;Menu, MenuAdmin, Add, Inventory, :MenuAdminInventory
;Menu, MenuAdmin, Add, Bstore, :MenuAdminBstore
;; --- HELP menu

