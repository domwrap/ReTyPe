/**
 * File containing Refill class to facilitate deleting multiple entries from a list view
 * Class will add itself to the parent retype instance
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


; Trigger my damn self (in a horrible way due to AHK limitations)
objRetype.refill( new FluidListItemDelete() )


/**
 * Refill to automatically delete X entries in a listview
 *
 * @category	Automation
 * @package		ReTyPe
 * @author		Dominic Wrapson <dwrapson@whistlerblackcomb.com>
 * @copyright	2015 Dominic Wrapson
 */
class FluidListItemDelete extends Fluid {


	strHotkey		:= "^!x"
	strMenuPath		:= "/Admin/"
	strMenuText		:= "Delete List Item"
	intMenuIcon		:= 132

	/**
	 * Where the magic happens
	 * 
	 * WARNING: Certain listview types that accept keystrokes (like ones with display order built in) when they are re-focused
	 * 		after a delete default to the first item in that list. I can't tell the position from which a delete was started
	 * 		so there's a good chance if you delete from anywhere other than the top item in one of these lists then you
	 * 		will delete unexepcted items
	 */
	pour() {
		global objRetype
		; Static variable that maintains its value between executions, so can be used as the new default value in the Iterate prompt
		static intIterate 		:= 1

		strGroup	:= this.__Class
		strRTP		:= % objRetype.objRTP.classNN()
		GroupAdd, %strGroup%, Add ahk_class %strRTP%
		GroupAdd, %strGroup%, Update ahk_class %strRTP%

		; Activate RTP (after toolbar has been clicked)
		objRetype.objRTP.Activate()

; @todo Check needs to be removed once I've managed to wall-in shortcuts in to the RTP only window
		; Run if it's ready!
		IfWinActive, ahk_group %strGroup%
		{
			; Did you execute from an RTP window?
			if ( objRetype.objRTP.isActive() ) {
				idWinRTP	:= WinActive("A")

				; Get the ID of the window we're in for later use
				idWin := WinExist("A")
				; Get dimensions for later image searches
				WinGetPos, , , intWw, intHw, ahk_id %idWin%

				; Check they user is only trying to delete list items
				ControlGetFocus, strControlFocus
				if ( !InStr( strControlFocus, "SysListView32" ) AND !InStr( strControlFocus, "Window.8" ) ) {
					MsgBox.stop( "Can only be used to delete items in list views" )
				}

				; Make a visual match for the remove button to prevent off-panel buttons being hit when they shouldn't
				; This is to prevent someone using this hotkey in the pricing panel of a product header, but actually removing things from, say, prompts unknowingly
				; Unfortunately again, RTP, of course, appears to have SLIGHTLY different styling on different delete buttons so we have to make four matches
				; (two per theme style) instead of two total. Thanks again, Active.
				ImageSearch, intXa, intYa, 500, 100, %intWw%, %intHw%, *100 img\search_fluidlistitemdelete_button_aero.png
				ImageSearch, intXas, intYas, 500, 100, %intWw%, %intHw%, *100 img\search_fluidlistitemdelete_button_aero_spaced.png
				ImageSearch, intXf, intYf, 500, 100, %intWw%, %intHw%, *100 img\search_fluidlistitemdelete_button_flat.png
				ImageSearch, intXfs, intYfs, 500, 100, %intWw%, %intHw%, *100 img\search_fluidlistitemdelete_button_flat_spaced.png
				if ( !intXa AND !intXf AND ! intXas AND !intXfs ) {
					MsgBox.Stop( "Could not locate Remove button on this panel, exiting" )
				}

				; Find the remove button, if there is one
				strControlRemove := Window.getControlFromContents( "Remove", idWin )
				; Now check if it's enabled, else there's no point trying to click it
				ControlGet, blnEnabled, Enabled,, %strControlRemove%, ahk_id %idWin%
				; Previous check seems to shift focus, so put it back again
				;ControlFocus, %strControlFocus%, ahk_id %idWin%
				if ( !blnEnabled ) {
					MsgBox.Stop( "Remove button disabled. Make sure the list item is selected first, or perhaps RTP just won't let you delete that" )
				}
				; Prompt for delete count
				intIterate := InputBox.Show( "Delete how many items?`n`nEnter ALL to delete all remaining entries`nEnter DOWN to delete everything beneath selected row", 1 )
				; Allows entry of ALL to delete all remining listview items
				if ( "ALL" = intIterate ) {
					; Get number of list items
					ControlGet, intItems, List, Count, %strControlFocus%, A
					; Set the iteration counter to the list count
					intIterate := intItems
					Sleep 100
				}
				if ( "DOWN" = intIterate ) {
					ControlGet, intItems, List, Count, %strControlFocus%, A
					ControlGet, intPos, List, Count Focused, %strControlFocus%, A
					intIterate := intItems - intPos + 1
					Sleep 100
					; listitems - listposn
				}
				; Input validation: we want a number please
				If intIterate not between 1 and 999
				{
					ControlFocus, %strControlFocus%, ahk_id %idWin%
					MsgBox.Stop( "You must enter a numerical value between 1 and 999.`n`nYou entered: " . intIterate )
				}
				; Confirmation message for massive delete requests
				if ( 10 < intIterate ) {
					MsgBox.YesNo( "You've asked to delete [" . intIterate . "] entries which seems like a lot. Continue?" )
					IfMsgBox, No
					{
						ControlFocus, %strControlFocus%, ahk_id %idWin%
						return
					}
				}

				; If we've made it this far, we're good to hit that button so let's do it X times
				Loop, %intIterate% {
					; Set focus to the listview again before we proceed
					ControlFocus, %strControlFocus%, ahk_id %idWin%
					; Spend some key-strokes to ensure an item is actually selected in the list
					Send ^{Space 2}{Space}


					ControlFocus, %strControlRemove%, ahk_id %idWin%
					Send {Space}
					WinWaitActive, ,Are you sure you want to delete the, 2
					if ( 0 != ErrorLevel ) {
						MsgBox.Stop( "Timed out waiting for the delete prompt, something else is probably wrong. Exiting" )
					}
; Was causing double-iterations so deleting too many entries.
/*
					; Wait around for the delete prompt
					intWait := 0
					while intWait < 4 {
						;ControlClick, Remove, ahk_id %idWin%,,,1
						ControlFocus, %strControlRemove%, ahk_id %idWin%
						Send {Space}

						;WinWaitNotActive, ahk_id %idWin%,, 3
						WinWaitActive, ,Are you sure you want to delete the, 1
						if ( 0 = ErrorLevel ) {
							break
						}

						if ( intWait = 3 ) {
							MsgBox.Error( "Timed out waiting for the delete prompt, something else is probably wrong. Exiting" )
							return
						}

						intWait++
					}
*/
					; Hit that button, delete that stuff!
					;ControlClick, Yes
					Send {Space}
					Sleep 300
				}

				; Set focus back to the list view so command can be instantly run again with no user interruption
				ControlFocus, %strControlFocus%, ahk_id %idWin%
				Send {Space}
			}
		}
	}


}
