/**
 * File containing class for building and rendering UI menus
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

/**
 * Class for building and rendering UI menus
 *
 * @category	Automation
 * @package		ReTyPe
 * @author		Dominic Wrapson <dwrapson@whistlerblackcomb.com>
 * @copyright	2014 Dominic Wrapson
 */
class Menu {

	strTarget	:= "fnNull"
	strText		:= ""
	strName		:= ""
	arrMenus	:= {}
	blnEnabled	:= true
	objButton	:= {}
	strIcon		:= ""

; @todo variadic
; @todo CONVERT THIS WHOLE THING TO http://www.autohotkey.com/board/topic/85512-class-menuahk-work-easily-with-custom-menus/
; @see http://www.autohotkey.com/board/topic/85789-menu-creator-easily-build-menus-for-your-scripts/
	__New( strTarget, strText, blnEnabled=true ) {
		this.strTarget		:= strTarget
		this.strText		:= strText
		this.blnEnabled		:= blnEnabled
	}

	/**
	 * Add child menu
	 * @return void
	 */
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
	/**
	 * Enable and disable a menu item
	 * @return void
	 */
	toggleEnabled() {
		this.blnEnabled := !this.blnEnabled
		strToggle := ( this.blnEnabled ) ? "Enable" : "Disable"
; @todo Wtf does strName come from?
		Menu, %strName%, %strToggle%, % this.strText
	}


	setIcon( strPath, intIcon=0 ) {
		this.strIcon := strPath
		this.intIcon := intIcon
	}


	/**
	 * Render the menu
	 * @return void
	 */
	render() {
; @todo shortcut key display
		strName := "Menu" this.objButton.strName

		if ( 0 < this.arrMenus.MaxIndex() ) {
			for intMenu, objMenu in this.arrMenus {
				objMenu.render()
				strTarget := ":Menu" objMenu.strName
				Menu, %strName%, Add, % this.strText , % strTarget
			}
		} else {
			strName := "Menu" this.strName
			Menu, %strName%, Add, % this.strText , % this.strTarget

			if ( false = this.blnEnabled ) {
				Menu, %strName%, Disable, % this.strText
			}

			if ( 0 < StrLen( this.strIcon ) ) {
				Menu, %strName%, Icon, % this.strText , % this.strIcon , % this.intIcon
			}
		}
	}

}


;Menu, MenuAdminProduct, Add, Bulk Pricing, fnRtpGuiCancel
;Menu, MenuAdmin, Add, Product, :MenuAdminProduct