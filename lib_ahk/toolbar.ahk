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

	static strToolbar := "toolbar"
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
	}


	show() {
		strToolbar := this.strToolbar
		Gui, %strToolbar%:show
	}

}
