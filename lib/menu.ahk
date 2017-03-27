class Menu {

	objToolbar := {}
	strParent := "MenuParent"
	strTarget := "Menu"
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
		this.arrMenus.Insert( objMenu )
	}

	render() {
		Menu, % this.strName, Add, % this.strText, % this.strTarget
	}

}