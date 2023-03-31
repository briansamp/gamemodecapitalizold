function Robb(playerid)
{
    if(!IsValidTimer(pData[playerid][pActivity])) return 0;
	{
	    if(pData[playerid][pActivityTime] >= 100)
	    {
	    	InfoTD_MSG(playerid, 8000, "Robbing done!");
	    	TogglePlayerControllable(playerid, 1);
	    	HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
			PlayerTextDrawHide(playerid, ActiveTD[playerid]);
			KillTimer(pData[playerid][pActivity]);
			pData[playerid][pEnergy] -= 15;
			pData[playerid][pActivityTime] = 0;
			ClearAnimations(playerid);
	    	InRob[playerid] = 0;
	    	GiveMoneyRob(playerid, 1, 428500);
	    	SetPVarInt(playerid, "Robb", gettime() + 3000);
	    	return 1;
		}
 		else if(pData[playerid][pActivityTime] < 100)
		{
	    	pData[playerid][pActivityTime] += 5;
			SetPlayerProgressBarValue(playerid, pData[playerid][activitybar], pData[playerid][pActivityTime]);
	    	PlayerPlaySound(playerid, 1053, 0.0, 0.0, 0.0);
		}
	}
	return 1;
}

CMD:robbery(playerid, params[])
{
    new id = -1;
	id = GetClosestATM(playerid);
	new Float:x, Float:y, Float:z;
	GetPlayerPos(playerid, x, y, z);
	
	if(pData[playerid][pLevel] < 5)
			return Error(playerid, "You must level 5 to use this!");

	if(IsPlayerConnected(playerid))
	{
        if(isnull(params))
		{
            Usage(playerid, "USAGE: /robbery [name]");
            Info(playerid, "Names: atm, biz, bank");
            return 1;
        }
		if(strcmp(params,"biz",true) == 0)
		{
            if(pData[playerid][pInBiz] >= 0 && IsPlayerInRangeOfPoint(playerid, 2.5, bData[pData[playerid][pInBiz]][bPointX], bData[pData[playerid][pInBiz]][bPointY], bData[pData[playerid][pInBiz]][bPointZ]))
			{
	    		if(GetPVarInt(playerid, "Robb") > gettime())
					return Error(playerid, "Delays Rob, please wait.");
                if(GetPlayerWeapon(playerid) != WEAPON_SHOTGUN) return Error(playerid, "You Need Shotgun.");

				Info(playerid, "You're in robbery please wait...");
				SendAdminMessage(COLOR_RIKO, "* %s Has Robbery Bisnis Pliss Admin Spec", pData[playerid][pName]);
				foreach(new i : Player)
				{
					if(pData[i][pPhone] == bData[pData[playerid][pInBiz]][bPh])
					{
						SCM(i, COLOR_RED, "[WARNING]"WHITE_E" Alarm Berbunyi Di bisnis anda!");
					}
				}
                SendFactionMessage(1, COLOR_RED, "**[Warning]{FFFFFF} Alarm Berbunyi Di bisnis ID: %d Di Rob oleh Ph: ["GREEN_E"%d"WHITE_E"] ", GetPlayerVirtualWorld(playerid), pData[playerid][pPhone]);
				
				pData[playerid][pActivity] = SetTimerEx("Robb", 1300, true, "i", playerid);
    			
				PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Robbing...");
				PlayerTextDrawShow(playerid, ActiveTD[playerid]);
				ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
				TogglePlayerControllable(playerid, 0);
				ApplyAnimation(playerid, "BOMBER", "BOM_Plant",	4.0, 1, 0, 0, 0, 0, 1);
				InRob[playerid] = 1;
			}
        }
		else if(strcmp(params,"atm",true) == 0)
		{
			if(id > -1)
			{
				if(GetPVarInt(playerid, "Robb") > gettime())
					return Error(playerid, "Delays Rob, please wait.");
                if(GetPlayerWeapon(playerid) != WEAPON_BAT) return Error(playerid, "You Need baseball.");
				Info(playerid, "You're in robbery please wait...");
				SendAdminMessage(COLOR_RIKO, "* %s Has Robbery Atm Pliss Admin Spec", pData[playerid][pName]);
				SendFactionMessage(1, COLOR_RED, "**[Warning]{FFFFFF} Telah Terjadi Pembobolan Atm Oleh Ph: ["GREEN_E"%d"WHITE_E"] di Location: %s",  pData[playerid][pPhone], GetLocation(x, y, z));

				pData[playerid][pActivity] = SetTimerEx("Robb", 1300, true, "i", playerid);
    			
				PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Robbing...");
				PlayerTextDrawShow(playerid, ActiveTD[playerid]);
				ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
				TogglePlayerControllable(playerid, 0);
				ApplyAnimation(playerid,"SWORD", "sword_4", 4.0, 1, 0, 0, 0, 0, 1);
				InRob[playerid] = 1;
			}
		}
		if(strcmp(params,"bank",true) == 0)
		{
            if(IsPlayerInRangeOfPoint(playerid, 2.5, 2255.92, -1747.33, 1014.77))
			{
	    		if(GetPVarInt(playerid, "Robb") > gettime())
					return Error(playerid, "Delays Rob, please wait.");
                if(GetPlayerWeapon(playerid) != WEAPON_SHOTGUN) return Error(playerid, "You Need Shotgun.");

				Info(playerid, "You're in robbery please wait...");
				SendAdminMessage(COLOR_RIKO, "* %s Has Robbery Bank Pliss Admin Spec", pData[playerid][pName]);
				
                SendFactionMessage(playerid, COLOR_RED, "**[Warning]{FFFFFF} Telah Terjadi Perampokan diBank!");
                SendClientMessageToAll(COLOR_RED, "**[Warning]{FFFFFF} Telah Terjadi Perampokan diBank harap menjauh!");

				pData[playerid][pActivity] = SetTimerEx("Robb", 1300, true, "i", playerid);
				Server_MinMoney(1000000);

				PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Robbing...");
				PlayerTextDrawShow(playerid, ActiveTD[playerid]);
				ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
				TogglePlayerControllable(playerid, 0);
				ApplyAnimation(playerid, "BOMBER", "BOM_Plant",	4.0, 1, 0, 0, 0, 0, 1);
				InRob[playerid] = 1;
			}
        }
	}
	return 1;
}
