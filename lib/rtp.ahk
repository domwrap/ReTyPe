/**
 * RTP Handler
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
 * @author		Dominic Wrapson <hwulex[åt]gmail[dõt]com>
 * @copyright	2014 Dominic Wrapson
 * @license		GNU AFFERO GENERAL PUBLIC LICENSE Version 3, 19 November 2007 http://www.gnu.org/licenses/
 */

/**
 * Class for handling RTP and all its nuances
 *
 * @category	Automation
 * @package		ReTyPe
 * @author		Dominic Wrapson <hwulex[åt]gmail[dõt]com>
 * @copyright	2014 Dominic Wrapson
 */
class RTP {
	; Config file
	strDirConf		:= A_AppData "\ReTyPe\"
	strFileConf		:= this.strDirConf "RTP.ini"

	; Instance config
	strProcess		:= "rtponecontainer"
	idProcess		:=

	; Window config defaults
	strPrefix		:= "WindowsForms10"
	strType			:= "Window.8"
	strSuffix		:= "app.0.30495d1"
	intWindow		:= 11
	intElement		:= 1
	strTitle		:= "RTP|ONE Container"

	; Implemenatation variables
	idIPCodeSearchLastMatched :=


	/**
	 * Constructor
	 * Reads INI config file and builds RTP ClassNN identifier
	 * @return rtp
	 */
	__New() {
		; Class NN elements
		IniRead, strPrefix, % this.strFileConf, Conf, Prefix, WindowsForms10
		this.strPrefix := strPrefix
		IniRead, strType, % this.strFileConf, Conf, Type, Window.8
		this.strType := strType
		IniRead, strSuffix, % this.strFileConf, Conf, Suffix, app.0.30495d1
		this.strSuffix := strSuffix
		IniRead, intWindow, % this.strFileConf, Conf, Window, 11
		this.intWindow := intWindow
		IniRead, intElement, % this.strFileConf, Conf, Element, 1
		this.intElement := intElement
		; Window Title to match
		IniRead, strTitle, % this.strFileConf, Conf, Title, RTP|ONE Container
		this.strTitle := strTitle
		; Construction for RTP identification
		strRTP := this.ClassNN()
		WinGet, idWinRTP, ID, ahk_class %strRTP%
		this.idProcess := idWinRTP

		; Treeview config
		; iniread intTreeCustomerCommon
		; iniread intTreeCustomerAccess
	}

	setID( idWin ) {
		this.idProcess := idWin
	}

	getID() {
		return this.idProcess
	}

	/**
	 * Returns ClassNN identifier of RTP window
	 *
	 * @uses formatClassNN
	 * @return string ClassNN for RTP
	 */
	ClassNN() {
		return this.formatClassNN( this.strType, this.intElement )
	}

	/**
	 * Returns Formatted ClassNN identifier for a RTP UI element
	 *
	 * @param string Type Element type (static, combobox, etc)
	 * @param int Element Integer identifier of RTP UI element
	 *
	 * @return string ClassNN for element
	 */
	formatClassNN( strType, intElement ) {
		return % this.strPrefix "." strType "." this.strSuffix "_r" this.intWindow "_ad" intElement
	}

	/**
	 * Restore (if needed) and activate RTP window
	 *
	 * @return void
	 */
	Activate() {
		Window.ActivateRestore( this.idProcess )
	}

	/**
	 * Checks if RTP is the active process
	 *
	 * @return bool
	 */
	isActive() {
		return Window.checkActiveProcess( this.strProcess )
	}

	getPos( chrDimension ) {
		if ( ( chrDimension != "X" ) AND ( chrDimension != "Y" ) AND ( chrDimension != "W" ) AND ( chrDimension != "H" ) ) {
			; ( "Invalid dimension requested" )
		}

		;if ( idRTP ) {
			; For some reason, this doesn't work as expected, even though ID is valid
			;WinGetPos, intX, intY, intW, intH, ahk_id %idRTP%
		;} else {
			strTitle := this.strTitle
			strClass := this.ClassNN()
			WinGetPos, intX, intY, intW, intH, %strTitle% ahk_class %strClass%
		;}

		if ( chrDimension = "X" ) {
			intReturn := intX
		} else if ( chrDimension = "Y" ) {
			intReturn := intY
		} else if ( chrDimension = "W" ) {
			intReturn := intW
		} else if ( chrDimension = "H" ) {
			intReturn := intH
		}

		return intReturn
	}

	/**
	 * Search for a customer by IP Code and open the matching profile
	 *
	 * @param integer intIP IP code to search
	 * @param bool blnForceSearch Force a research in case current profile may have changed since last time
	 *
	 * @return void
	 */
	CustomerSearchAndSelect( intIP, blnForceSearch=False ) {
		idIPCodeSearchLastMatched := this.idIPCodeSearchLastMatched
		idWinRTP := this.idProcess

		; Control definition (in case they change later because let's be honest, they probably will!)
		IniRead, strCustomerListViewControl, % this.strFileConf, Controls, CustomerListView, 11
		strCustomerListView := this.formatClassNN( "SysListView32", strCustomerListViewControl ) ; Well yeah, or is it actually the comments? Who the hell knows
		IniRead, strCustomerTabControl, % this.strFileConf, Controls, CustomerTab, 11
		strCustomerTab := this.formatClassNN( "SysTabControl32", strCustomerTabControl )
		IniRead, strSearchEditControl, % this.strFileConf, Controls, SearchEdit, 11
		strSearchEdit := this.formatClassNN( "EDIT", strSearchEditControl )
		IniRead, strSearchRefineEditControl, % this.strFileConf, Controls, SearchRefineEdit, 12
		strSearchRefineEdit := this.formatClassNN( "EDIT", strSearchRefineEditControl )
		IniRead, strSearchRefineComboControl, % this.strFileConf, Controls, SearchRefineCombo, 11
		strSearchRefineCombo := this.formatClassNN( "COMBOBOX", strSearchRefineComboControl )

		; Switch to customer search tab
		; OH MY GOD!  So if a comment (or other such item) has recently been added or accessed, the Search Results
		; ListView is actualy somehow overpopulated with the list of the item you just accessed, thence stealing
		; the Search Results ListView ID (yes, identifier!) even if that list doesn't ACTUALLY exist as a ListView
		; in the first place.  WHAT THE BALLS, RTP!?
		; So, today's workaround of the day is to switch to the search results tab to REMIND RTP which one I'm
		; actually referring to when I use its unique identifier.  Later on we'll switch back to the View Details tab.
		; I need a drink
		SendMessage, 0x1330, 0,, %strCustomerTab%, ahk_id %idWinRTP%  ; 0x1330 is TCM_SETCURFOCUS

		; Get IP value of first entry in search results
		ControlGet, intCustomerSearchCount, List, Count, %strCustomerListView%, ahk_id %idWinRTP%
		ControlGet, arrCustomerLoaded, List, Col3, %strCustomerListView%, ahk_id %idWinRTP%
		; Pop first one off the listing, depending on how many there are as the parse-loop doesn't work if there's only one result
		if ( 2 >  intCustomerSearchCount ) {
			ControlGet, intCustomerLoaded, List, Col3, %strCustomerListView%, ahk_id %idWinRTP%
		} else {
			Loop, Parse, arrCustomerLoaded, `n
			{
				intCustomerLoaded := A_LoopField
				break
			}
		}

; @todo Verify which profile is loaded in case searched and then opened dependent.  Thanks to RTP's usual mess of
; a GUI, we cannot directly reference the IP: xxxxxx field on a profile, instead must search EVERY visible control for text
; IP: xxxxxxx and if we get a match, then it's loaded, else re-search.  Yeah, thanks.
; write to intCustomerIP
	;StringMid, intCustomerIP, intCustomerIP, 5

;MsgBox intCustomerSearchCount: %intCustomerSearchCount%`nintIP: %intIP%`nintCustomerIP: %intCustomerIP%`nintCustomerLoaded: %intCustomerLoaded%`nidIPCodeSearchLastMatched: %idIPCodeSearchLastMatched%`nblnForceSearch: %blnForceSearch%
;exit
		; This IF logic is kinda square peg round hole to get RTP to do what I want it to.
		; It could probably be normalised but right now it works, so screw it.
		; Is customer loaded, and if so is it the one we want, and is it the one actually loaded, and is it the last searched for, or do it anyway
		if ( !intCustomerLoaded OR intIP != intCustomerLoaded OR blnForceSearch ) {
;msgbox Reload it!
;exit
			; Always default back to the customer search tab (tabindex starts at 0)
			SendMessage, 0x1330, 0,, %strCustomerTab%, ahk_id %idWinRTP%  ; 0x1330 is TCM_SETCURFOCUS

			; Activate search box and empty so doesn't mess with IP search
			ControlFocus, %strSearchEdit%, ahk_id %idWinRTP%
			Send {Del}

			; Move to Refine Criteria box and input there
			Control, ChooseString, IP Code, %strSearchRefineCombo%, ahk_id %idWinRTP%
			ControlFocus, %strSearchRefineEdit%, ahk_id %idWinRTP%
			Send %intIP%{Enter}

			intPosX := this.getPos( "X" ) + ( this.getPos( "W" ) / 2 ) - 150 ; progress w300/2
			objProgress := new Progress( 1, 10, "Searching...", , , intPosX )
			intProgress = 0
			Loop {
				Sleep 500
				objProgress.update( ++intProgress, "Waiting..." )

				;Focus refine criteria box
				ControlFocus, %strSearchEdit%, ahk_id %idWinRTP%
				If ErrorLevel
				{
					objProgress.update( ++intProgress, "Still cannot focus, retrying..." )
					continue
				}
				If ( "Wait" = %A_Cursor% ) {
					objProgress.update( ++intProgress, "Waiting for RTP (busy)" )
					continue
				}
				IfWinActive, Cancel Customer Search
				{
					objProgress.update( ++intProgress, "Search still active" )
					continue
				}

				break
			}

			; Update global
			idIPCodeSearchLastMatched := intIP

			; @todo Pull column 3 (IP) match entry against input incase shorter IP matchers multiple people
			; Open first entry in search result list
			ControlFocus, %strCustomerListView%, ahk_id %idWinRTP%
			SendInput {Home}{Space}{Enter}
		}

		; Switch to customer detail tab
		SendMessage, 0x1330, 1,, %strCustomerTab%, ahk_id %idWinRTP%  ; 0x1330 is TCM_SETCURFOCUS
	}

	/**
	 * Add Comment to customer profile
	 *
	 * @return void
	 */
	CustomerAddComment( strSubject, strComment, blnSave=true ) {
		; Switch to comment view
		While !blnComments AND A_Index < 5 {
			if ( A_Index < 4 ) {
				; Make three attempts at switching using the shortcut key Alt+C
				Send !c
			} else {
				; If that didn't work, do the ghetto treeview traverse
				this.CustomerResetTreeview()

				; Get tree position of CommonProfiles from config file
				IniRead, intTreeCommon, % this.strFileConf, TreeCustomer, Common, 4
				; Reduce it by one as the first one in the tree is the 0th position
				intTreeCommon--

				; Traverse the tree to comments
				Send {Down %intTreeCommon%}{Right}{Down}
			}

			; Make an image search for Comment Profile header to ensure we're in the correct place
			ImageSearch blnComments, , 300, 120, 440, 140, *100 %A_ScriptDir%\img\search_cusman_commentprofile.png

			; Momentary pause so RTP doesn't crap the bed
			Sleep 100
		}

		; Hit add button
		ControlClick, Add New
		; Enter subject
		SendInput {Tab}%strSubject%
		; Enter comment
		SendInput {Tab}%strComment%

; @todo Add timeout 5? seconds, if no input, close and save
		if ( blnSave ) {
			; Save it
			Send {Tab}{Space}
		}
	}

	/**
	 * As there is no good way for AHK to interact with treeview controls, this method will
	 * start from the last node in a tree and work its way upward, closing each leaf along the way
	 *
	 * @return void
	 */
	CustomerResetTreeview() {
		idWinRTP := this.idProcess

		IniRead, intCustomerTreeView, % this.strFileConf, Controls, CustomerTreeView, 12
		strCustomerTreeView := this.formatClassNN( "SysTreeView32", intCustomerTreeView )

		; Focus the treeview
		ControlFocus, %strCustomerTreeView%, ahk_id %idWinRTP%

		; Progress box config
		intPosX := this.getPos( "X" ) + ( this.getPos( "W" ) / 2 ) - 150 ; progress w300/2
		objProgress := new Progress( 1, 10, "Resetting treeview", , , intPosX )
		intProgress := 0

		; Set to end of tree and work out way back up, closing each branch
		Send {End}
		intLoop := 0
		While intLoop <= 6 {
			Sleep 500

			If ( "Wait" = %A_Cursor% ) {
				objProgress.update( ++intProgress, "Waiting for RTP (busy)" )
				continue
			}

			Send {Left 2}{Up}
			intLoop++
			objProgress.update( ++intProgress )
		}
		objProgress.update( ++intProgress )
	}

	/**
	 * Switch RTP to another section (voucher tools, etc)
	 * 
	 * @param String Window to which you want to switch
	 * @return int Row number
	 */
	WindowSwitch( strWindow ) {
; @todo Figure out WTF this only works every-other call!?!?!?!
; @todo change to "constants" instead of string-based
		global idWinRTP
		intRow = 

		IniRead, intGoMenu, % this.strFileConf, Controls, GoMenu, 11
		strcontrol := this.formatClassNN( "SysListView32", intGoMenu )

		this.Activate()
		ControlGet, arrMenu, List,, %strControl%, ahk_id %idWinRTP%
		Loop, Parse, arrMenu, `n
		{
			if ( A_LoopField = strWindow ) {
				intRow := A_Index
				break
			}
		}
		if ( 0 = intRow )
		{
			ErrorLevel = 1
			return False
		}
		intDown := ((intRow-1)*23)+110

		Send, {Escape}
		MouseClick, Left, 40, 40
		Send, {Tab}
		MouseClick, Left, 45, %intDown%

		return %intRow%
	}

	/**
	 * Updates a date input with specified date (mm/dd/yyyy)
	 *
	 * Takes a specified date (mm/dd/yyyy) and transposes to a date input.
	 * Due to RTP's inherent date-validity checking, if there are start-and-end
	 * inputs the year must be either incremented or decremented by an amount
	 * before a new date can be entered.
	 * Depending on if you are changing an effective-date or an expiration date,
	 * you will need to specify either to increment or decrement the year first
	 * 
	 * @todo leap year handling
	 * @todo also see send class for input dates
	 * 
	 * @param bool blnUp Control whether to increment or decrement a date input year before transposing
	 *
	 * @return void This function does not return a value
	 */
	dateInput( dtDate, blnUp=1 ) {
		Send {right 2}
		If blnUp
			Send {Up 2}
		else
			Send {Down 2}
		Send {left 2}
		Loop, parse, dtDate, /
		{
			Send %A_LoopField%{right}
		}
	}

}
