; DEBUG CRAP HERE!



#F8::
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
	ControlGetText, strText, %strControl%, ahk_id %idWindow%
	ControlGet, blnChecked, Checked,, %A_LoopField%, ahk_id %idWindow%
	ControlGet, blnEnabled, Enabled,, %A_LoopField%, ahk_id %idWindow%
	ControlGet, blnVisible, Visible,, %A_LoopField%, ahk_id %idWindow%

	MsgBox, , , Contents of control`n%strControl%`n`n%strList%`n`n%strText%`nChecked: %blnChecked%`nEnabled: %blnEnabled%`nVisible: %blnVisible%
return


#F5::
	strControl = WindowsForms10.SysListView32.app.0.30495d1_r11_ad11
	Gui, TreeView, strControl
	MsgBox % TV_GetCount()
return


#F4::

return


#F3::
	ControlGetFocus, strFocus, A
	MsgBox % strFocus
return


#F12::
	#Persistent
	SetTimer, WatchActiveWindow, 200
	return
	WatchActiveWindow:
	WinGet, ControlList, ControlList, A
	ToolTip, %ControlList%
return



