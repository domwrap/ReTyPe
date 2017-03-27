class Button {

	objToolbar := {}
	strName := "Button"
	strTarget := "Button"
	strText := "Button"
	arrMenus := {}
	arrMenuOrder := {}

	__New( strName, strTarget, strText, objToolbar=false ) {
		this.strName := strName
		this.strTarget := strTarget
		this.strText := strText

		; Why doesn't obj.haskey work here?
		if ( false != objToolbar ) {
			this.setToolbar( objToolbar )
		}
	}

	setToolbar( objToolbar ) {
		this.objToolbar := objToolbar
	}

	addMenu( ByRef objMenu ) {
		; This is required by child menu for correct gui name
		; Allegedly parent.toolbar should work, but I failed
		objMenu.objButton := this
		; Copy name of button in to name of menu for correct hierarchical naming
		objMenu.strName := this.strName
		; Add to array of menus
		strMenu := ( objMenu.strText ) ? objMenu.strText : this.arrMenuOrder.MaxIndex()
		this.arrMenuOrder.insert( strMenu )
		this.arrMenus[strMenu] := objMenu
;msgbox % debug.exploreObj( this.arrMenus )
	}

	render( strOptions ) {
		global
		local strToolbar := this.objToolbar.strToolbar
		local strTarget := "g" this.strTarget
		local strName := "v" this.strName

		; Render menu first so it can be attached to the button
		;for intMenu, objMenu in this.arrMenus {
		for intOrder, strMenu in this.arrMenuOrder {
			this.arrMenus[strMenu].render()
			;objMenu.render()
		}

		Gui, %strToolbar%:Add, Button, %strOptions% %strName% %strTarget%, % this.strText
	}

}