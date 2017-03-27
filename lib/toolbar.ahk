

class Toolbar {

	

}



; Build a UI
Gui, Retype:Margin, 0, 0
Gui, Retype:Add, Button, x0 y0 gfnMenuGeneral, G
Gui, Retype:Add, Button, ym gfnMenuAdmin, A
Gui, Retype:Add, Button, ym, C
Gui, Retype:Add, Button, ym, O
Gui, Retype:Add, Button, ym, V
Gui, Retype:Add, Button, ym gfnMenuHelp, ?
; Strip off some crap from the ui we don't want, like titlebar, buttons, border, etc, and keep it up front (own dialogs doesn't seem to be working)
Gui, Retype:-SysMenu +ToolWindow -Caption -Border +AlwaysOnTop +OwnDialogs
; @todo +OwnDialogs (make dialogs modal)
; ------- Build the menus -------
; --- GENERAL Menu
; First add all the menu items
Menu, MenuGeneral, Add, First section, fnRtpGuiCancel
Menu, MenuGeneral, Add  ; Add a separator line.
Menu, MenuGeneralSub, Add, Second section, fnRtpGuiCancel
; Then string them all together
Menu, MenuGeneral, Add, Second item, :MenuGeneralSub
; --- ADMIN Menu
; First add all the menu items
; ------ Product
Menu, MenuAdminProduct, Add, Bulk Pricing, fnRtpGuiCancel
; ------ Component
Menu, MenuAdminComponent, Add, First section, fnRtpGuiCancel
; ------ Discount
Menu, MenuAdminDiscount, Add, First section, fnRtpGuiCancel
; ------ Inventory
Menu, MenuAdminInventory, Add, Auto-populate, fnRtpGuiCancel
; ------ bStore
Menu, MenuAdminBstore, Add, Second section, fnRtpGuiCancel
; Then string them all together
Menu, MenuAdmin, Add, Product, :MenuAdminProduct
Menu, MenuAdmin, Add, Component, :MenuAdminComponent
Menu, MenuAdmin, Add, Discount, :MenuAdminDiscount
Menu, MenuAdmin, Add, Inventory, :MenuAdminInventory
Menu, MenuAdmin, Add, Bstore, :MenuAdminBstore
; --- HELP menu
Menu, MenuHelp, Add, Help, fnRtpGuiCancel
Menu, MenuHelp, Add  ; Add a separator line.
Menu, MenuHelp, Add, About ReTyPe, fnAbout
