class Menu {

	objToolbar := {}
	strTarget := "fnHeaderNull"
	strText := "Menu"
	strName := "Menu"
	arrMenus := {}

	__New( strName="", strTarget="", strText="", objToolbar=false ) {
		this.strName := strName
		this.strTarget := strTarget
		this.strText := strText

		if ( objToolbar.HasKey( "strToolbar" ) ) {
			this.setToolbar( objToolbar )
		}
	}

	setToolbar( objToolbar ) {
		this.objToolbar := objToolbar
	}

	addMenu( objMenu ) {
		objMenu.strName := this.strName objMenu.strName
		this.arrMenus.Insert( objMenu )
	}

; @todo shortcut key display
	render() {
		strName := "Menu" this.strName

		if ( 0 < this.arrMenus.MaxIndex() ) {
			for intMenu, objMenu in this.arrMenus {
				objMenu.render()
				strTarget := ":Menu" objMenu.strName
				Menu, %strName%, Add, % this.strText, % strTarget
			}
		} else {
			Menu, %strName%, Add, % this.strText, % this.strTarget
		}
	}

}


;Menu, MenuAdminProduct, Add, Bulk Pricing, fnRtpGuiCancel
;Menu, MenuAdmin, Add, Product, :MenuAdminProduct