class Menu {

	strTarget := "fnNull"
	strText := ""
	strName := ""
	arrMenus := {}
	blnEnabled := true
	objButton := {}

; @todo variadic
	__New( strTarget, strText, blnEnabled=true ) {
		this.strTarget := strTarget
		this.strText := strText
		this.blnEnabled := blnEnabled
	}

	addChild( objMenu ) {
		; This line makes sub-menus distinct.  Without it, all child menus appear under all possible parents
		; Renaming to the text-entry prevents duplicates, and continues the hierarchical naming
		this.strName := this.strText
		; Construct name of child menu
		objMenu.strName := this.objButton.strName this.strName
;msgbox % this.strName " : " objMenu.strName " : " objMenu.strText
		; Add to array of child menus
		this.arrMenus.Insert( objMenu )
	}

; NOT SURE if this works yet (can't test easily without hierarchy in place)
	toggleEnabled() {
		this.blnEnabled := !this.blnEnabled
		strToggle := ( this.blnEnabled ) ? "Enable" : "Disable"
		Menu, %strName%, %strToggle%, % this.strText
	}

; @todo shortcut key display
	render() {
		strName := "Menu" this.objButton.strName

		if ( 0 < this.arrMenus.MaxIndex() ) {
			for intMenu, objMenu in this.arrMenus {
				objMenu.render()
				strTarget := ":Menu" objMenu.strName
				Menu, %strName%, Add, % this.strText, % strTarget
			}
		} else {
			strName := "Menu" this.strName
			Menu, %strName%, Add, % this.strText, % this.strTarget

			if ( false = this.blnEnabled ) {
				Menu, %strName%, Disable, % this.strText
			}
		}
	}

}


;Menu, MenuAdminProduct, Add, Bulk Pricing, fnRtpGuiCancel
;Menu, MenuAdmin, Add, Product, :MenuAdminProduct