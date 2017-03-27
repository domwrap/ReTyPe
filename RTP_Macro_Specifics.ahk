

; GoSub Label
goUpdateCommission:
	Send {Tab}{Space}
	Sleep 100
	Send 7{right}1
	Send {Tab}12{right}31{right}2020
	Send {Tab}15
	Send {Tab 2}{Space}
	Send +{Tab}
	Send {Down}
return


;=========================================================
^!+c:: ; COMMISSION:	LATIN per-product commission rates
;
; COLUMN LISTING MUST BE ACTIVE AREA
MsgBox 4, Continue?, Do you wish to update LATIN commission rates?
IfMSgBox No
{
	; user pressed cancel
	return
}
else
{
	Send {Right 4}
	Loop 10 {
		Send {Tab}{Space}
		Sleep 100
		Send {Tab}12{right}31{right}2020
		Send {Tab}25
		Send {Tab 2}{Space}
		Send +{Tab}{Down}
	}
	Loop 2 {
		Send {Tab}{Space}
		Sleep 100
		Send {Tab}12{right}31{right}2020
		Send {Tab}20
		Send {Tab 2}{Space}
		Send +{Tab}{Down}
	}
	Send {Tab}{Space}
	Sleep 100
	Send {Tab}12{right}31{right}2020
	Send {Tab}25
	Send {Tab 2}{Space}
	Send +{Tab}{Down}

	Loop 3
	{
		Send {Right 2}
		Loop 2 {
			Send {Tab}{Space}
			Sleep 100
			Send {Tab}12{right}31{right}2020
			Send {Tab}20
			Send {Tab 2}{Space}
			Send +{Tab}{Down}
		}
		Loop 11 {
			Send {Tab}{Space}
			Sleep 100
			Send {Tab}12{right}31{right}2020
			Send {Tab}25
			Send {Tab 2}{Space}
			Send +{Tab}{Down}
		}
	}

	Send {Right 4}
	Loop 10 {
		Send {Tab}{Space}
		Sleep 100
		Send {Tab}12{right}31{right}2020
		Send {Tab}25
		Send {Tab 2}{Space}
		Send +{Tab}{Down}
	}
	Loop 2 {
		Send {Tab}{Space}
		Sleep 100
		Send {Tab}12{right}31{right}2020
		Send {Tab}20
		Send {Tab 2}{Space}
		Send +{Tab}{Down}
	}
	Send {Tab}{Space}
	Sleep 100
	Send {Tab}12{right}31{right}2020
	Send {Tab}25
	Send {Tab 2}{Space}
	Send +{Tab}{Down}

}
return



;=========================================================
^!+k:: ; COMMISSION:	JAC per-product commission rates
;
; COLUMN LISTING MUST BE ACTIVE AREA
MsgBox 4, Continue?, Do you wish to update JAC commission rates?
IfMSgBox No
{
	; user pressed cancel
	return
}
else
{
	Send {Home} ; reset to start of tree
	; -- Daycare
	Send {Down 11}{Right}{Down 5}{Right}{Down 3}
	Loop 3 {
		Gosub goUpdateCommission
	}
	; -- Damage Protection
	Send {Down 5}{Right}{Down}{Right}{Down 2}
	Loop 2 {
		Gosub goUpdateCommission
	}
	Send {Down 3}
	Loop 7 {
		Gosub goUpdateCommission
	}
	Send {Left 2}
	; -- Biking Programs - 7 day adv
	; ---- Adult
	Send {Down 8}{Right}{Down 2}{Right}{Down 2}
	Loop 5 {
		Loop 3 {
			Gosub goUpdateCommission
		}
		Send {Down}
	}
	Loop 9 {
		Gosub, goUpdateCommission
	}
	; ---- Youth
	Send {Down}{Right}{Down 2}
	Loop 2 {
		Loop 3 {
			Gosub goUpdateCommission
		}
		Send {Down}
	}
	Loop 18 {
		Gosub, goUpdateCommission
	}
	; ---- 101
	Send {Right}{Down}
	Loop 4 {
		gosub goUpdateCommission
	}
	; -- Biking Programs
	; ---- Adult
	Send {Right}{Down 3}{Right}{Down 2}
	Loop 3 {
		gosub goUpdateCommission
	}
	Send {Down 3}
	Loop 3 {
		gosub goUpdateCommission
	}
	Send {Down}
	Loop 4 {
		gosub goUpdateCommission
	}
	Send {Down}
	Loop 4 {
		gosub goUpdateCommission
	}
	Send {Down}
	Loop 10 {
		gosub goUpdateCommission
	}
	; ---- Youth
	Send {Right}{Down 4}
	Loop 3 {
		gosub goUpdateCommission
	}
	Send {Down}
	Loop 21 {
		gosub goUpdateCommission
	}
	; ---- 101
	Send {Right}{Down}
	Loop 4 {
		gosub goUpdateCommission
	}
	; -- Mtn Bike - XC Bike Tours
	Send {Down 3}{Right}{Down}
	Loop 6 {
		gosub goUpdateCommission
	}
	Send {Down 2}
	gosub goUpdateCommission
	; -- Bike - Road Bike Tours
	Send {Down}{Right}{Down}
	Loop 4 {
		gosub goUpdateCommission
	}
	; -- Mtn Bike - DFX Daily
	Send {Down}{Right}{Down 4}
	Loop 9 {
		gosub goUpdateCommission
	}
	Send {Down 2}
	Loop 3 {
		gosub goUpdateCommission
	}
	; -- Lift Tickets - Tour Op Sightsee Summer
	Send {Left 2}{Down 29}{Right}{Down}{Right}{Down 8}
	Loop 3 {
		gosub goUpdateCommission
	}
	Send {Down 7}
	gosub goUpdateCommission
	; -- Lift Tickets - Special Summer Offers
	Send {Down 3}{Right}{Down}{Right}{Down}
	Loop 3 {
		gosub goUpdateCommission
	}
	Send {Down 3}
	gosub goUpdateCommission
	; -- TP - Bike Park, Glacier, AZone, BBQ
	; ---- Adult
	Send {Left 4}{Down 24}{Right 4}
	Loop 2 {
		gosub goUpdateCommission
	}
	Send {Down 31}
	Loop 7 {
		gosub goUpdateCommission
	}
	; ---- Youth
	Send {Right 2}
	Loop 2 {
		gosub goUpdateCommission
	}
	Send {Down 18}
	Loop 7 {
		gosub goUpdateCommission
	}
	; ---- Senior
	Send {Left 2}{Down}{Right 2}
	Loop 2 {
		gosub goUpdateCommission
	}
	Send {Down 21}
	Loop 7 {
		gosub goUpdateCommission
	}
	; ---- Child
	Send {Right 2}
	Loop 2 {
		gosub goUpdateCommission
	}
	Send {Down 31}
	Loop 7 {
		gosub goUpdateCommission
	}
	; -- Tickets - TP Adventure Pass
	Send {Right 2}
	Loop 5 {
		gosub goUpdateCommission
	}
	; -- Travel Partner - Bear Viewing Tours
	;Send {Down 2}{Right}{Down}{Right}{Down}
	;Loop 4 {
	;	gosub goUpdateCommission
	;}
	;Send {Down}{Right 2}
	;Loop 4 {
	;	gosub goUpdateCommission
	;}
}
return
