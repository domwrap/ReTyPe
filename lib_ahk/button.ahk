/**
 * File containing class for building and rendering UI toolbar buttons
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

/**
 * Class for building and rendering UI toolbar buttons
 *
 * @category	Automation
 * @package		ReTyPe
 * @author		Dominic Wrapson <dwrapson@whistlerblackcomb.com>
 * @copyright	2014 Dominic Wrapson
 */
class Button {

	objToolbar := {}
	strName := "Button"
	strTarget := "Button"
	strText := "Button"
	arrMenus := {}
	arrMenuOrder := {}

	/**
	 * Constructor and defaults
	 * @param String Button name
	 * @param String Target for button
	 * @param String Button text
	 * @param Toolbar Toolbar object to which to add
	 */
	__New( strName, strTarget, strText, objToolbar=false ) {
		this.strName := strName
		this.strTarget := strTarget
		this.strText := strText

		; Why doesn't obj.haskey work here?
		if ( false != objToolbar ) {
			this.setToolbar( objToolbar )
		}
	}

	/**
	 * Assign button to toolbar by setting toolbar on button
	 * @return void
	 */
	setToolbar( objToolbar ) {
		this.objToolbar := objToolbar
	}

	/**
	 * Add a menu to show when the button is clicked
	 * @param Menu Menu object
	 * @return void
	 */
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

	/**
	 * Draw the button
	 * @param String AHK button options
	 * @link http://www.autohotkey.com/docs/commands/GuiControls.htm#Button
	 * @return void
	 */
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