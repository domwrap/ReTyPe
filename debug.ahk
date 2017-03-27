; DEBUG CRAP HERE!


#F12::
	#Persistent
	SetTimer, WatchActiveWindow, 200
	return
	WatchActiveWindow:
	WinGet, ControlList, ControlList, A
	ToolTip, %ControlList%
return


#F11::
	WinGet, id, list,,, Program Manager

	Loop, %id%
	{
	    this_id := id%A_Index%
	    WinActivate, ahk_id %this_id%
	    WinGetClass, this_class, ahk_id %this_id%
	    WinGetTitle, this_title, ahk_id %this_id%
	    MsgBox, 4, , Visiting All Windows`n%a_index% of %id%`nahk_id %this_id%`nahk_class %this_class%`n%this_title%`n`nContinue?
	    IfMsgBox, NO, break
	}
return


#F10::
	MsgBox unused
return


#F9::
	MouseGetPos, intX, intY, idWindow, strControl
	ControlGet, strList, List, , %strControl%, A
	ControlGetText, strText, %strControl%, A
	ControlGet, blnChecked, Checked,, %A_LoopField%, A
	ControlGet, blnEnabled, Enabled,, %A_LoopField%, A
	ControlGet, blnVisible, Visible,, %A_LoopField%, A

	MsgBox X: %intX% Y: %intY%`nWindow: %idWindow%`nControl: %strControl%`n`nList: %strList%`nText: %strText%`n`nChecked: %blnChecked%`nEnabled: %blnEnabled%`nVisible: %blnVisible%
return


#F8::
SendMessage, 0x1304,,, WindowsForms10.SysTabControl32.app.0.30495d1_r11_ad11, A  ; 0x1304 is TCM_GETITEMCOUNT.
TabCount = %ErrorLevel%
msgbox % TabCount
return


#F7::
	WinGet, idWindow, ID, A
	WinGet, arrControls, ControlList, ahk_id %idWindow%
	find := _InputBox( "Search for specific value in control (blank for all)","" )

	Loop, Parse, arrcontrols, `n
	{
		ControlFocus %A_LoopField%, ahk_id %idWindow%
		ControlGet, strList, List, , %A_LoopField%, ahk_id %idWindow%

		if ( 0 = StrLen(strList) ) {
			ControlGetText, strText, %A_LoopField%, ahk_id %idWindow%
			ControlGet, blnChecked, Checked,, %A_LoopField%, ahk_id %idWindow%
			ControlGet, blnEnabled, Enabled,, %A_LoopField%, ahk_id %idWindow%
			ControlGet, blnVisible, Visible,, %A_LoopField%, ahk_id %idWindow%

			IfNotInString, strText, %find%
				Continue
			MsgBox, 4, , Properties of control %A_LoopField%`nText: "%strText%"`nChecked: %blnChecked%`nEnabled: %blnEnabled%`nVisible: %blnVisible%`n`nContinue?
		} else {
			IfNotInString, strList, %find%
				Continue
			MsgBox, 4, , Contents of control`n%A_LoopField%`n`n%strList%`n`nContinue?
		}
	    IfMsgBox, NO, break
	}
	MsgBox End
return


#F6::
	;strControl = WindowsForms10.SysListView32.app.0.30495d1_r11_ad11
	;strControl = WindowsForms10.SysTreeView32.app.0.30495d1_r11_ad12
	;strControl = WindowsForms10.COMBOBOX.app.0.30495d1_r11_ad17
	;strControl = WindowsForms10.COMBOBOX.app.0.30495d1_r11_ad18
	strControl := _InputBox( "What control are we looking for?", "" )
	WinGet, idWindow, ID, A

	ControlGet, strList, List, , %strControl%, ahk_id %idWindow%
	ControlGet, intListCount, List, Count, %strControl%, A
	ControlGetText, strText, %strControl%, ahk_id %idWindow%
	ControlGet, blnChecked, Checked,, %A_LoopField%, ahk_id %idWindow%
	ControlGet, blnEnabled, Enabled,, %A_LoopField%, ahk_id %idWindow%
	ControlGet, blnVisible, Visible,, %A_LoopField%, ahk_id %idWindow%
	ControlGet, intTab, Tab,, %A_LoopField%, ahk_id %idWindow%

	MsgBox, , , Contents of control`nControl: %strControl%`n`nList: %strList%`nList Count: %intListCount%`n`nText: %strText%`n`nChecked: %blnChecked%`nEnabled: %blnEnabled%`nVisible: %blnVisible%`nTab: %intTab%
return


#F5::
	strList = 
	intListCount = 
	strText = 
	blnChecked = 
	blnEnabled = 
	blnVisible = 
	intTab = 

	ControlGetFocus, strControl, A

	ControlGet, strList, List, , %strControl%, A
	ControlGet, intListCount, List, Count, %strControl%, A
	ControlGetText, strText, %strControl%, A
	ControlGet, blnChecked, Checked,, %A_LoopField%, A
	ControlGet, blnEnabled, Enabled,, %A_LoopField%, A
	ControlGet, blnVisible, Visible,, %A_LoopField%, A
	ControlGet, intTab, Tab,, %A_LoopField%, A

	MsgBox, , , Contents of control`nControl: %strControl%`n`nList: %strList%`nList Count: %intListCount%`n`nText: %strText%`n`nChecked: %blnChecked%`nEnabled: %blnEnabled%`nVisible: %blnVisible%`nTab: %intTab%
return


#F4::
	MsgBox % WinActive("A")
return


#F3::
	MsgBox % A_Cursor
return







;TREEVIEW FAIL
;	#Include TreeView/Const_TreeView.ahk
;	#Include TreeView/Const_Process.ahk
;	#Include TreeView/Const_Memory.ahk
;	#Include TreeView/RemoteTreeViewClass.ahk

;	strControl = WindowsForms10.SysListView32.app.0.30495d1_r11_ad113
;	WinGet, idWindow, ID, A

;	ControlGet, TVid, Hwnd, , %strControl%, ahk_id %idWindow%

;	MyTV := new RemoteTreeView(TVId)
;	hItem = 0  ; Causes the loop's first iteration to start the search at the top of the tree.
;	Loop
;	{
;		hItem := MyTV.GetNext(hItem, "Full")
;		if not hItem  ; No more items in tree.
;			break
;		ItemText := MyTV.GetText(hItem)
;		MsgBox, 4, ,The next Item is %hItem%, whose text is "%ItemText%"`n`nContinue?
;		IfMsgBox, No, Break
;	}