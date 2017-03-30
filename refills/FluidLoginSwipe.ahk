/**
 * File containing Refill class to enable "swipe" type logins for QSR/TSR/Manager for RFID
 * Class will add itself to the parent retype instance
 *
 * AutoHotKey v1.1.13.01+
 *
 * LICENSE:
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Affero General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.

 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Affero General Public License for more details.

 * You should have received a copy of the GNU Affero General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 *
 * @category  	Automation
 * @package   	ReTyPe
 * @author    	Dominic Wrapson <dwrapson@whistlerblackcomb.com>
 * @copyright	Copyright (C) 2015 Dominic Wrapson
 * @license 	GNU AFFERO GENERAL PUBLIC LICENSE http://www.gnu.org/licenses/agpl-3.0.txt
 */

;#NoTrayIcon
#Include %A_ScriptDir%\lib_ahk\adosql.ahk

; Trigger my damn self (in a horrible way due to AHK limitations)
objRetype.refill( new FluidLoginSwipe() )


/**
 * Refill to allow "swipe" logins but using RFID
 *
 * @category	Automation
 * @package		ReTyPe
 * @author		Dominic Wrapson <dwrapson@whistlerblackcomb.com>
 * @copyright	2015 Dominic Wrapson
 */
class FluidLoginSwipe extends Fluid {

	strHotkey		:= "$Enter,$NumpadEnter"
	strMenuPath		:= ""
	strMenuText		:= ""
	intMenuIcon		:= ""

	pour() {
		global objRetype

		; Create window group for places we want this hotkey active
		strGroup	:= this.__Class
		strRTP		:= % objRetype.objRTP.classNN()
		GroupAdd, %strGroup%, On-Screen Keyboard ahk_class %strRTP%, Login

		; On-Screen login keyboard is active
		IfWinActive, ahk_group %strGroup%
		{
			; Text control on the login page
			strControl := objRetype.objRTP.formatClassNN( "EDIT", this.getConf( "Login", 11 ) )

			; Get contents of text box
			ControlGetText, strLogin, %strControl%, A

			; Check if it's a DTA number (starting 161* and 20 chars long)
			;if ( 20 = StrLen( strLogin ) AND 161 = SubStr( strLogin, 1, 3 ) ) {
			; Check if it's not a login swipe (no % symbol)
			If ( "%" != SubStr( StrLogin, 1, 1 ) ) {
				; SQL Server Connection string
; @todo move to config file
				strConnect := "Provider=SQLOLEDB.1;Password=***PASSWORD***;Persist Security Info=True;User ID=***USERID***;Initial Catalog=***DBNAME***;Data Source=***DBSERVER***;Use Procedure for Prepare=1;Auto Translate=True;Packet Size=4096;Use Encryption for Data=False;Tag with column collation when possible=False"

				; Query to execute stored procedure to lookup USERID from DTA
				strQuery = EXEC [dbo].[iwb_proc_publicGetUserIDFromDTANumber] @SearchValue = N'%strLogin%'

				; Execute query against connection string with ADO
				objReturn := ADOSQL(strConnect, strQuery)
				;msgbox, % ADOSQL_LastError "`n`n" ADOSQL_LastQuery

				; If SP chucks an error, handle it
				If ( ADOSQL_LastError ) {
					; Extract error and display to user
					MsgBox.Error( SubStr( ADOSQL_LastError, 1, InStr( ADOSQL_LastError, "`n" )-1 ) )
					ADOSQL_LastError := 
					; Blank out the text box ready for new entry
					ControlSetText, %strControl%,
				} else {
					; Extract result
					Loop, % objReturn.MaxIndex()
						idUser .= objReturn[2,A_Index]
					;msgbox, % row

					if ( idUser ) {
						; Overwrite DTA number in text entry with the returned user id
						ControlSetText, %strControl%, %idUser%
						; Click the OK button to proceed
						;ControlClick, OK
						Send {Enter}
					} else {
						ControlSetText, %strControl%,
					}
				}
			} else {
				; If it's a swipe card, continue with ENTER keystroke
				Send {Enter}
			}
		} else {
			; If we're not in desired window, continue with ENTER keystroke
			Send {Enter}
		}

	}


}
