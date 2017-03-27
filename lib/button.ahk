class Button {

	objToolbar := {}
	strTarget := "Button"
	strText := "Button"

	__New( strTarget, strText, objToolbar=false ) {
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

	render( strOptions ) {
		strToolbar := this.objToolbar.strToolbar
		strTarget := "g" this.strTarget
		Gui, %strToolbar%:Add, Button, %strOptions% %strTarget%, % this.strText
	}

}