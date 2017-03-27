/**
 * File containing class for building and rendering UI menus
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