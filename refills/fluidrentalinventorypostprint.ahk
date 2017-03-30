/**
 * File containing Refill class to modify button behaviour in Rental Inventory Transfer
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
objRetype.refill( new FluidRentalInventoryPostPrint() )


/**
 * Refill for Rental Inventory Transfer to remove print button and change Post button to Post and Print
 *
 * @category	Automation
 * @package		ReTyPe
 * @author		Dominic Wrapson <dwrapson@whistlerblackcomb.com>
 * @copyright	2014 Dominic Wrapson
 */
class FluidRentalInventoryPostPrint extends Fluid {

	static intTimer		:= 200
	strRTP 				:= 
	idWinRTP 			:=
	strTitle 			:= "Choose an Inventory Transfer Task"

	/**
	 * Destructor
	 */
	__Delete() {
		
	}


	/**
	 * Add text-searching for access codes to components
	 */
	pour() {
		Global ; all vars are global

		strGroup		:= this.__Class
		strRTP			:= % objRetype.objRTP.classNN()
		this.strRTP 	:= strRTP
		strTitle 	 	:= % this.strTitle
		GroupAdd, %strGroup%, ahk_class %strRTP%, %strTitle%

		; Build the GUI and do stuff
		IfWinActive, ahk_group %strGroup%
		{
			; WinActive check isn't good enough in this case, so need to make a visual search too
			ImageSearch intActiveX, intActiveY, 40, 60, 370, 100, *100 %A_ScriptDir%\img\search_icon_rentalinventorytransfer.png
			If ( !ErrorLevel ) {
				idWinRTP := WinExist("A")
				this.idWinRTP := idWinRTP

				; Hide the Print button as it doesn't work anyway
				Control, Hide, , Print, ahk_id %idWinRTP%
				; Hide the Post button so it can't be clicked unintentionally
				Control, Hide, , Post, ahk_id %idWinRTP%

				; Find Post button so we can lay a new one over the top
				WinGetPos, intWinX, intWinY,,,
				ControlGetPos, intCtlX, intCtlY, intCtlW, intCtlH, View/Edit,
				; Calculate X and Y for button based on window width + position of existing button (Same for Y)
				intGuiX := intWinX + intCtlX + intCtlW + 5
				intGuiY := intWinY + intCtlY

				; If we can find the View/Edit button, draw our button next to it
				if ( 0 < intCtlX && 0 < intCtlY ) {
					; Check if button window has been made before
					IfWinExist, PostPrint ahk_class AutoHotkeyGUI
					{
						; If it has, show it
						Gui, PostPrint:Show, NA x%intGuiX% y%intGuiY%, PostPrint
					} else {
						; Otherwise create it first, then show it
						Gui, PostPrint:Add, Button, x0 y0 w%intCtlW% gfnSearchInventoryPrintPost -wrap, Post && Print
						Gui, PostPrint:Margin, 0, 0
						Gui, PostPrint:-SysMenu +ToolWindow -Caption -Border +AlwaysOnTop
						Gui, PostPrint:Show, NoActivate x%intGuiX% y%intGuiY%, PostPrint
						WinGet, idWinRetype, ID, PostPrint ahk_class AutoHotkeyGUI
					}
					; Now activate it as well
					WinActivate, ahk_group %strGroup%
				} else {
					; If View/Edit wasn't found, hide our button
					;debug.msg( "CtlX: " intCtlX  "`nCtlY: " intCtlY "`nWinX: " intWinX "`nWinY: " intWinY "`nGuiX: " intGuiX "`nGuiY: " intGuiY )
					Gui, PostPrint:Hide
				}
			} else {
				; If we don't find ourselves in the rental inventory screen, destroy the GUI
				Gui, PostPrint:Destroy
			}
		}

		; Can't find a relevant window to display the button? Hide it
		IfWinNotExist, ahk_group %strGroup%
		{
			Gui, PostPrint:Hide
		}

		; Group the RTP and Retype windows together as it's the only way !WinActive will work
		GroupAdd, grpWinPostPrint, ahk_id %idWinRTP%
		GroupAdd, grpWinPostPrint, ahk_id %idWinRetype%
		If !WinActive("ahk_group grpWinPostPrint")
		{
			 ;This code stops button showing in other apps
			Gui, PostPrint:Destroy
		}

		; AHK-hack to GTFO before the label here below, which actually gets called by a timer event
		return



		/**
		 * Adds a border-less UI with a single button next to the disabled PostPrint combobox.
		 * Appears to "add" a button to the UI when in fact it floats above it but never steals focus.
		 * Now that's MAGIC!
		 */
		fnSearchInventoryPrintPost:
			; Get RTP window for later reference
			strClassRTP := % objRetype.objRTP.classNN()
			strTitleRTP := "Choose an Inventory Transfer Task"
			WinGet, idWinRTP, ID, ahk_class %strClassRTP%, %strTitleRTP%
			WinActivate, ahk_id %idWinRTP%

			; Focus View/Edit button as it's the only one visible left on screen
			ControlFocus, View/Edit, ahk_id %idWinRTP%
			/*
			if ( ErrorLevel ) {
				msgbox.error( "Could not locate button" )
				return
			}
			*/

			; Reverse tab in to the list control, then space to re-select un-selected item
			Send +{Tab}{Space}

			; Get selected transferid from list view
			ControlGetFocus, strControlList, A
			ControlGet, idTransfer, List, Selected Col1, %strControlList%, ahk_id %idWinRTP%
			if ( 0 = strLen( idTransfer ) ) {
				msgbox.error( "No batch to transfer" )
				return
			}

			; Click the Post button
			WinActivate, ahk_id %idWinRTP%
			ControlFocus, %strControlList%, ahk_id %idWinRTP%
			Control, Show, , Post, ahk_id %idWinRTP%
			Send {Tab 2}{Space}
			Control, Hide, , Post, ahk_id %idWinRTP%

			; Wait for the posting confirmation window to be closed (either OK or Cancel)
			WinWaitNotActive, Post Confirmation
			if ( 1 = ErrorLevel ) {
				msgbox.error( "Timed out waiting for Batch Post" )
			}

			; Grab teh RTP id here again as it seems to get lost, even though the other vars are just fine!
			WinGet, idWinRTP, ID, ahk_class %strClassRTP%, %strTitleRTP%

			; Wait for focus to return to RTP (may have clicked elsewhere first)
			WinWaitActive, ahk_id %idWinRTP%
			if ( 1 = ErrorLevel ) {
				msgbox.error( "Timed out waiting for RTP" )
			} else

			; Get list of batches IDs still listed
			ControlGet, arrTransfer, List, Col1, %strControlList%, ahk_id %idWinRTP%
			blnPosted := true
			; See if the posted ID is still in the list and if it was they can't have clicked OK so batch cancelled
			Loop, Parse, arrTransfer, `n
			{
				if ( idTransfer = A_LoopField ) {
					blnPosted := false
					break
				}
			}

			; Did user actually post the batch?
			if ( blnPosted ) {
				; If so, open the report, the whole point of this lengthy exercise
				;Run, http://rtp_reporting/ReportServer/Pages/ReportViewer.aspx?/Custom+Reports/Rental+Reports/Rental+Inventory+Reports/Rental+Inventory+-+Transfer+PickList&TransferId=%idTransfer%
				Run, http://rtp_reporting/ReportServer/Pages/ReportViewer.aspx?/Custom+Reports+-+RTP+Container/Rental+Inventory+Reports/Rental+Inventory+-+Transfer+PickList&rs:Command=Render&TransferId=%idTransfer%
			} else {
				; Otherwise tell them what they did, because duh
				msgbox.info( "Batch post cancelled" )
			}

		return ; fnSearchInventoryPrintPost

	} ; pour()

 } ; class
