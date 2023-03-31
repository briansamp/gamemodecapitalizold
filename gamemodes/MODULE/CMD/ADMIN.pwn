CMD:acmds(playerid)
{
	if(pData[playerid][pAdmin] < 1)
		return PermissionError(playerid);

	new line3[2480];
	strcat(line3, ""WHITE_E"Administrator Commands:"LB2_E"\n\
 	/aduty /a /h /asay /togooc /o /goto /sendto /gethere /freeze /unfreeze /revive /spec /slap\n\
 	/caps /peject /astats /ostats /acuff /auncuff /jetpack /getip /aka /akaip /jail /unjail\n\
	/kick /ban /unban /respawnsapd /respawnsags /respawnsamd /respawnsana /respawnjobs\n\
	/reports /ar /vmodels /vehname /apv /aveh /gotoveh /getveh /respawnveh /respawnrad");

	strcat(line3, "\n\n"WHITE_E"Senior Admin Commands:"LB2_E"\n\
 	/sethp /clearreports /afix /setskin /akill /ann /cd /settime /setweather\n\
    /ojail /owarn /setam");

	strcat(line3, "\n\n"WHITE_E"Admin Commands:"LB2_E"\n\
	/oban /banip /unbanip /reloadweap /resetweap /sethbe\n\
 	/createdoor /editdoor");
 	
	strcat(line3, ""WHITE_E"\n\nHead Admin Commands:"LB2_E"\n\
	/setname /setvip /setfarm /setfam /fcreate /setfaction /setleader /takemoney /takegold /giveweap\n\
	/veh /destroyveh");
	
    strcat(line3, "\n\n"WHITE_E"Server Owner Commands:"LB2_E"\n\
	/sethelperlevel /setadminname /setmoney /givemoney /setbankmoney /givebankmoney\n\
	/setmaterial /setcomponent /createpv /destroypv /explode");

	strcat(line3, "\n\n"WHITE_E"Developer:"LB2_E"\n\
	/setadminlevel /setgold /givegold /sound /song /playsong /stopsong /playnearsong /setstock /setprice /setwhitelist\n\
	/setpassword /createhouse /edithouse /createflat /editflat /createhotel /edithotel /creategym /editmachine /createmachine\n\
	/dr /it /rt /bt /up /ft gotoco /gotohouse /gotoflat /gotohotel /gotobisnis /gotodoor /gotolocker /gotobank /gotols /gotogs /gotoflint /gotohq\n\
	/enterveh /genterveh /mark /gotomark /gotosf /gotolv /setfighstyle /createbisnis /editbisnis /gotosamd /setint\n\
	/createdealer /createvending /createws /editws /setws /editdealer /gotodealer /editvending /gotovending /deletedealer /deletevending /setvw /gmx");
 	
	strcat(line3, "\n\n"BLUE_E"CP:PR "WHITE_E"- Anti-Cheat is actived.\n\
	"PINK_E"NOTE: All admin commands log is saved in database! | Abuse Commands? Kick And Demote Permanent!.");
	ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_MSGBOX, ""ORANGE_E"CP:PR: "YELLOW_E"Staff Commands", line3, "OK","");
	return true;
}

CMD:givemoneyall(playerid, params[])
{
	if(pData[playerid][pAdmin] < 6)
		return PermissionError(playerid);
		
	new money;
	new str[150];
	if(sscanf(params, "d", money))
	{
	    Usage(playerid, "/givemoneyall <money>");
	    return true;
	}

	foreach(new pid : Player)
	{
		GivePlayerMoneyEx(pid, money);
		Servers(pid, "Admin %s telah mengedotensei uang %s kepada semua player online", pData[playerid][pAdminname], FormatMoney(money));
		new str[150];
		format(str,sizeof(str),"Admin: %s mengedotensei uang kesemua player sejumlah %s", GetRPName(playerid), FormatMoney(money));
		//LogServer("Admin", str);
	}

	//PlayerTextDrawShow(playerid, TEXTSUCCESS[playerid][0]);
	format(str, sizeof(str), "Money_Player_Added");
	//PlayerTextDrawSetString(playerid, TEXTSUCCESS[playerid][0], str);
	for(new i = 0; i < 7; i++)
	{
		//TextDrawShowForPlayer(playerid, NOTIFSUCCESS[i]);
	}
	SetTimerEx("notifitems", 5000, false, "i", playerid);
	
	return 1;
}

CMD:givebmoneyall(playerid, params[])
{
	if(pData[playerid][pAdmin] < 6)
		return PermissionError(playerid);

	new bmoney;
	if(sscanf(params, "d", bmoney))
	{
	    Usage(playerid, "/givebmoneyall <money>");
	    return true;
	}

	foreach(new pid : Player)
	{
		pData[pid][pBankMoney] += bmoney;
		Servers(pid, "Admin %s telah mengedotensei uang %s kepada semua player online", pData[playerid][pAdminname], FormatMoney(bmoney));
		new str[150];
		format(str,sizeof(str),"Admin: %s mengedotensei uang di bank semua player sejumlah %s", GetRPName(playerid), FormatMoney(bmoney));
		//LogServer("Admin", str);
	}

	return 1;
}

CMD:setfamilly(playerid, params[])
{
	new famid, otherid;
    if(pData[playerid][pAdmin] < 4)
        return PermissionError(playerid);

	//if(!pData[playerid][pAdminDuty]) return PermissionErrorDuty(playerid);

    if(sscanf(params, "ud", otherid, famid))
        return Usage(playerid, "/setfamilly [playerid/PartOfName] [-1 = untuk reset]");

    if(!IsPlayerConnected(otherid))
        return Error(playerid, "Player not connected!");

	if(famid == 0)
	{
		pData[otherid][pFamily] = 0;
		//pData[otherid][fLeader] = 0;
		pData[otherid][pFamilyRank] = 0;
		Servers(playerid, "You have removed %s's from family.", pData[otherid][pName]);
		Servers(otherid, "%s has removed your family stats.", pData[playerid][pName]);
	}
	else
	{
		pData[otherid][pFamily] = famid;
		pData[otherid][pFamilyRank] = 6;
		Servers(playerid, "You have set %s's family ID %d with Member.", pData[otherid][pName], famid);
		Servers(otherid, "%s has set your family ID to %d with Member.", pData[playerid][pName], famid);
	}
    return 1;
}

CMD:hcmds(playerid)
{
	if(pData[playerid][pAdmin] < 1)
		if(pData[playerid][pHelper] == 0)
		return PermissionError(playerid);

	new line3[2480];
	strcat(line3, ""WHITE_E"Junior Helper Commands:"LB2_E"\n\
 	/aduty /h /asay /o /goto /sendto /gethere /freeze /unfreeze\n\
	/kick /slap /caps /acuff /auncuff /reports /ar /dr");

	strcat(line3, "\n\n"WHITE_E"Senior Helper Commands:"LB2_E"\n\
 	/spec /peject /astats /ostats /jetpack\n\
    /jail /unjail");

	strcat(line3, "\n\n"WHITE_E"Head Helper Commands:"LB2_E"\n\
	/respawnsapd /respawnsags /respawnsamd /respawnsana /respawnjobs\n");
 	
	strcat(line3, "\n"BLUE_E"CP:PR "WHITE_E"- Anti-Cheat is actived.\n\
	"PINK_E"NOTE: All admin commands log is saved in database! | Abuse Commands? Kick And Demote Premanent!.");
	ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_MSGBOX, ""ORANGE_E"CP:PR: "YELLOW_E"Staff Commands", line3, "OK","");
	return true;
}

/*CMD:admins(playerid, params[])
{
	new count = 0, line3[512];
	if(pData[playerid][pAdmin] > 0)
	{
		foreach(new i:Player)
		{
			if(pData[i][pAdmin] > 0 || pData[i][pHelper] > 0)
			{
				format(line3, sizeof(line3), "%s\n"WHITE_E"[%s"WHITE_E"] %s(%s) (ID: %i)", line3, GetStaffRank(i), pData[i][pName], pData[i][pAdminname], i);
				count++;
			}
		}
		if(count > 0)
		{
			ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_MSGBOX, ""RED_E"Staff Online", line3, "Close", "");
		}
		else return ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_MSGBOX, ""RED_E"Staff Online", "There are no admin online!", "Close", "");
	}
	else
	{
		foreach(new i:Player)
		{
			if(pData[i][pAdmin] > 0 || pData[i][pHelper] > 0)
			{
				if(pData[i][pAdminDuty] == 1)
				{
					format(line3, sizeof(line3), "%s\n"WHITE_E"[%s"WHITE_E"] %s (ID: %i)", line3, GetStaffRank(i), pData[i][pAdminname], i);
					count++;
				}
			}
		}
		if(count > 0)
		{
			ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_MSGBOX, ""RED_E"Staff Online", line3, "Close", "");
		}
		else return ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_MSGBOX, ""RED_E"Staff Online", "There are no admin online duty!", "Close", "");
	}
	return 1;
}
*/
CMD:admins(playerid, params[])
{
    new count = 0;
	if(pData[playerid][pAdmin] > 0)
	{
	    SendClientMessage(playerid, COLOR_PINK, "{ffff00}=========={ffffff}[{ff0000}Capitaliz Staff Online{ffffff}]{ffff00}==========");

		foreach(new i:Player)
		{
			if(pData[i][pAdmin] > 0 || pData[i][pHelper] > 0)
			{
			    //SendClientMessage(playerid, COLOR_PINK, "{ffff00}=========={ffffff}[{ff0000}Staff Online{ffffff}]{ffff00}==========");
			    if(pData[i][pAdminDuty] == 0)
				{
			  	    //SendClientMessageEx(playerid, COLOR_PINK, "{ffff00}=========={ffffff}[{ff0000}Staff Online{ffffff}]{ffff00}==========");
			  	    SendClientMessageEx(playerid, COLOR_PINK, ""WHITE_E"[%s"WHITE_E"] %s (%s) (ID: %i) ["GREEN_E"Roleplaying"WHITE_E"]", GetStaffRank(i), pData[i][pAdminname], pData[i][pName], i);
			        count++;
				}
				if(pData[i][pAdminDuty] == 1)
				{
			  	    //SendClientMessageEx(playerid, COLOR_PINK, "{ffff00}=========={ffffff}[{ff0000}Staff Online{ffffff}]{ffff00}==========");
			  	    SendClientMessageEx(playerid, COLOR_PINK, ""WHITE_E"[%s"WHITE_E"] %s (%s) (ID: %i) ["RED_E"On Duty"WHITE_E"]", GetStaffRank(i), pData[i][pAdminname], pData[i][pName], i);
			        count++;
				}
			}
		}
		if(count > 0)
		{
			SendClientMessageEx(playerid, COLOR_PINK, "Anda bisa {ffff00}'/report' {ffffff}saat admin sedang online");
		}
		else return SendClientMessageEx(playerid, COLOR_PINK, "Tidak ada admin yang online saat ini"); //ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_MSGBOX, ""RED_E"Staff Online", "There are no admin online!", "Close", "");
	}
	else
	{
		foreach(new i:Player)
		{
			if(pData[i][pAdmin] > 0 || pData[i][pHelper] > 0)
			{
				SendClientMessage(playerid, COLOR_PINK, "{ffff00}=========={ffffff}[{ff0000}Capitaliz Staff Online{ffffff}]{ffff00}==========");

			    if(pData[i][pAdminDuty] == 0)
				{
				    //SendClientMessageEx(playerid, COLOR_PINK, "{ffff00}=========={ffffff}[{ff0000}Staff Online{ffffff}]{ffff00}==========");
					SendClientMessageEx(playerid, COLOR_PINK, ""WHITE_E"[%s"WHITE_E"] %s (%s) (ID: %i) ["GREEN_E"Roleplaying"WHITE_E"]", GetStaffRank(i), pData[i][pAdminname], pData[i][pName], i);
					count++;
				}
				if(pData[i][pAdminDuty] == 1)
				{
				    //SendClientMessageEx(playerid, COLOR_PINK, "{ffff00}=========={ffffff}[{ff0000}Staff Online{ffffff}]{ffff00}==========");
					SendClientMessageEx(playerid, COLOR_PINK, ""WHITE_E"[%s"WHITE_E"] %s (%s) (ID: %i) ["RED_E"On Duty"WHITE_E"]", GetStaffRank(i), pData[i][pAdminname], pData[i][pName], i);
				}
			}
		}
		if(count > 0)
		{
			SendClientMessageEx(playerid, COLOR_PINK, "Anda bisa {ffff00}'/report' {ffffff}saat admin sedang online");
		}
		else return SendClientMessageEx(playerid, COLOR_PINK, "Tidak ada admin yang online kalau ada kendala bisa report di Merpati discord");
	}
	return 1;
}

CMD:veh(playerid, params[])
{
    static
        model[32],
        color1,
        color2;

    if(pData[playerid][pAdmin] < 2)
        return PermissionError(playerid);

    if(sscanf(params, "s[32]I(0)I(0)", model, color1, color2))
        return Usage(playerid, "/veh [model id/name] <color 1> <color 2>");

    if((model[0] = GetVehicleModelByName(model)) == 0)
        return Error(playerid, "Invalid model ID.");

    static
        Float:x,
        Float:y,
        Float:z,
        Float:a,
        vehicleid;

    GetPlayerPos(playerid, x, y, z);
    GetPlayerFacingAngle(playerid, a);

    vehicleid = CreateVehicle(model[0], x, y, z, a, color1, color2, 600);
	AdminVehicle{vehicleid} = true;

    if(GetPlayerInterior(playerid) != 0)
        LinkVehicleToInterior(vehicleid, GetPlayerInterior(playerid));

    if(GetPlayerVirtualWorld(playerid) != 0)
        SetVehicleVirtualWorld(vehicleid, GetPlayerVirtualWorld(playerid));

    if(IsABoat(vehicleid) || IsAPlane(vehicleid) || IsAHelicopter(vehicleid))
        PutPlayerInVehicle(playerid, vehicleid, 0);

    SetVehicleNumberPlate(vehicleid, "STATIC");
    Servers(playerid, "Anda memunculkan %s (%d, %d).", GetVehicleModelName(model[0]), color1, color2);
    return 1;
}

CMD:destroyveh(playerid, params[])
{
	new vehicleid = GetPlayerVehicleID(playerid);

    if(pData[playerid][pAdmin] < 2)
	{
	    return PermissionError(playerid);
	}
	if(AdminVehicle{vehicleid})
	{
	    DestroyVehicle(vehicleid);
	    AdminVehicle{vehicleid} = false;
	    return Servers(playerid, "Kendaraan admin dihancurkan.");
	}

	for(new i = 1; i < MAX_VEHICLES; i ++)
	{
	    if(AdminVehicle{i})
	    {
	        DestroyVehicle(i);
	        AdminVehicle{i} = false;
		}
	}

	SendStaffMessage(COLOR_PINK, "%s menghancurkan semua kendaraan yang dispawn admin.", pData[playerid][pAdminname]);
	return 1;
}
//---------------------------[ Admin Level 1 ]--------------------
/*CMD:aduty(playerid, params[])
{
	if(pData[playerid][pAdmin] < 1)
		if(pData[playerid][pHelper] == 0)
			return PermissionError(playerid);
			
	if(!strcmp(pData[playerid][pAdminname], "None"))
		return Error(playerid, "You must set your admin name to owner!");
	
	if(!pData[playerid][pAdminDuty])
    {
		if(pData[playerid][pAdmin] > 0)
		{
			SetPlayerColor(playerid, 0xFF000000);
			pData[playerid][pAdminDuty] = 1;
			SetPlayerName(playerid, pData[playerid][pAdminname]);
			SendStaffMessage(COLOR_RIKO, "{FFF000}%s {FFFFFF} %s Has "GREEN_E"Onduty {FFFFFF} Admins", GetStaffRank(playerid), pData[playerid][pName]);
		}
		else
		{
			SetPlayerColor(playerid, COLOR_GREEN);
			pData[playerid][pAdminDuty] = 1;
			SetPlayerName(playerid, pData[playerid][pAdminname]);
			SendStaffMessage(COLOR_RIKO, "{FFFFFF} %s Has "PURPLE_E"Onduty {FFFFFF} Helper", pData[playerid][pName]);
		}
    }
    else
    {
        if(pData[playerid][pFaction] != -1 && pData[playerid][pOnDuty]) 
            SetFactionColor(playerid);
        else 
            SetPlayerColor(playerid, COLOR_PINK);
                
        SetPlayerName(playerid, pData[playerid][pName]);
        pData[playerid][pAdminDuty] = 0;
        SendStaffMessage(COLOR_RIKO, "{FFF000}%s {FFFFFF} %s Has "YELLOW_E"Offduty {FFFFFF} Admins", GetStaffRank(playerid), pData[playerid][pName]);
    }
	return 1;*/
//}

CMD:aduty(playerid, params[])
{
	if(pData[playerid][pAdmin] < 1)
		if(pData[playerid][pHelper] == 0)
			return PermissionError(playerid);
	if(pData[playerid][pSkin] == 1) SetPlayerSkin(playerid,0);//cowok
    //else SetPlayerSkin(playerid,217);// wanita
			
	if(!strcmp(pData[playerid][pAdminname], "None"))
		return Error(playerid, "Kamu harus setting Nama Admin mu!");
	
	if(!pData[playerid][pAdminDuty])
    {
		if(pData[playerid][pAdmin] > 0)
		{
			SetPlayerColor(playerid, 0xFF000000);
			pData[playerid][pAdminDuty] = 1;
			SetPlayerName(playerid, pData[playerid][pAdminname]);
			SendStaffMessage(COLOR_PINK, "* %s telah on duty admin.", pData[playerid][pName]);
		}
		else
		{
			SetPlayerColor(playerid, COLOR_GREEN);
			pData[playerid][pAdminDuty] = 1;
			SetPlayerName(playerid, pData[playerid][pAdminname]);
			SendStaffMessage(COLOR_PINK, "* %s telah on helper duty.", pData[playerid][pName]);
		}
    }
    else
    {
        if(pData[playerid][pFaction] != -1 && pData[playerid][pOnDuty]) 
            SetFactionColor(playerid);
        else 
            SetPlayerColor(playerid, COLOR_PINK);

                
        SetPlayerName(playerid, pData[playerid][pName]);
        SetPlayerSkin(playerid, pData[playerid][pSkin]);
        pData[playerid][pAdminDuty] = 0;
        SendStaffMessage(COLOR_PINK, "* %s telah off admin duty.", pData[playerid][pName]);
    }
	return 1;
}

/*CMD:ans(playerid, params[])
{
	if(pData[playerid][pAdmin] < 1)
		if(pData[playerid][pHelper] == 0)
			return PermissionError(playerid);

	if(!strlen(params))
		return Usage(playerid, "/ans [id pemain] [teks]");

	extract params -> new to_player, string: message[144 + 1];

	if(!IsPlayerConnected(to_player))
		return Error(playerid, "This player is not conect");

	if(!strlen(message))
		return Error(playerid, "Masukkan Pesan");

	new fmt_str[128];

	format(fmt_str, sizeof fmt_str, "[ANSWER] %s[%d] |{FFFFFF} %s", pData[playerid][pAdminname], playerid, message);
	SendClientMessage(to_player, 0xFFFF00FF, fmt_str);
	PlayerPlaySound(to_player, 1085, 0.0, 0.0, 0.0);

	SendStaffMessage(COLOR_PINK, ""YELLOW_E"Admin %s[%d] To %s[%d]:{FFFFFF} | %s", pData[playerid][pAdminname], playerid, pData[to_player][pName], to_player, message);
	return 1;
}
*/
CMD:asay(playerid, params[]) 
{
    new text[225];

    if(pData[playerid][pAdmin] < 1)
		if(pData[playerid][pHelper] == 0)
			return PermissionError(playerid);

    if(sscanf(params,"s[225]",text))
        return Usage(playerid, "/asay [text]");
        
    SendClientMessageToAllEx(COLOR_PINK,"**[STAFF]** (%s) "YELLOW_E"%s: "LG_E"%s", GetStaffRank(playerid), pData[playerid][pAdminname], ColouredText(text));
    return 1;
}
CMD:countobjects(playerid)
{
    new object_count;
    for (new i; i < MAX_OBJECTS; i++)
    {
        if (IsValidObject(i))
        {
            object_count++;
        }
    }
    SendClientMessageEx(playerid, -1, "[DEBUG] Amount of objects: %i", object_count);

    SendClientMessageEx(playerid, -1, "[DEBUG] Amount of cdynamic objects: %i", Streamer_CountItems(STREAMER_TYPE_OBJECT));
    return 1;
}
CMD:h(playerid, params[])
{
    if(pData[playerid][pAdmin] < 1)
		if(pData[playerid][pHelper] == 0)
			return PermissionError(playerid);

	if(isnull(params))
	{
	    Usage(playerid, "/h <text>");
	    return true;
	}

    // Decide about multi-line msgs
	new i = -1;
	new line[512];
	if(strlen(params) > 70)
	{
		i = strfind(params, " ", false, 60);
		if(i > 80 || i == -1) i = 70;

		// store the second line text
		line = " ";
		strcat(line, params[i]);

		// delete the rest from msg
		params[i] = EOS;
	}
	new mstr[512];
	format(mstr, sizeof(mstr), ""SBLUE_E"[Helper Chat] (%s) "WHITEP_E"%s(%i): "LB_E"%s", GetStaffRank(playerid), pData[playerid][pAdminname], playerid, params);
	foreach(new ii : Player) 
	{
		if(pData[ii][pAdmin] > 0 || pData[ii][pHelper] > 1)
		{
			SendClientMessage(ii, COLOR_LB, mstr);	
		}
	}
	if(i != -1)
	{
		foreach(new ii : Player)
		{
			if(pData[ii][pAdmin] > 0 || pData[ii][pHelper] > 1)
			{
				SendClientMessage(ii, COLOR_LB, line);
			}
		}
	}
	return 1;
}

CMD:a(playerid, params[])
{
    if(pData[playerid][pAdmin] < 1)
			return PermissionError(playerid);

	if(isnull(params))
	{
	    Usage(playerid, "/a <text>");
	    return true;
	}

    // Decide about multi-line msgs
	new i = -1;
	new line[512];
	if(strlen(params) > 70)
	{
		i = strfind(params, " ", false, 60);
		if(i > 80 || i == -1) i = 70;

		// store the second line text
		line = " ";
		strcat(line, params[i]);

		// delete the rest from msg
		params[i] = EOS;
	}
	new mstr[512];
	format(mstr, sizeof(mstr), "[A] {007FFF}%s {00FF00}%s(%i): {ffffff}%s", GetStaffRank(playerid), pData[playerid][pAdminname], playerid, params);
	ABroadCast(0x99cc00FF, mstr, 1);
	return true;
}

CMD:togooc(playerid, params[])
{
    if(pData[playerid][pAdmin] < 1)
        return PermissionError(playerid);

    if(TogOOC == 0)
    {
        SendClientMessageToAllEx(COLOR_PINK, "SERVERS: "WHITE_E"Admin {FF0000}%s {FFFFFF}has {FFFF00}disabled {FFFFFF}global OOC chat.", pData[playerid][pAdminname]);
        TogOOC = 1;
    }
    else
    {
        SendClientMessageToAllEx(COLOR_PINK, "SERVERS: "WHITE_E"Admin {FF0000}%s {FFFFFF}has {FFFF00}enabled {FFFFFF}global OOC chat (DON'T SPAM).", pData[playerid][pAdminname]);
        TogOOC = 0;
    }
    return 1;
}

CMD:o(playerid, params[])
{
    if(TogOOC == 1 && pData[playerid][pAdmin] < 1 && pData[playerid][pHelper] < 1) 
            return Error(playerid, "An administrator has disabled global OOC chat.");

    if(isnull(params))
        return Usage(playerid, "/o [global OOC]");

    new VipRank[30];
	if(pData[playerid][pVip] == 1)
	{
		VipRank = "Premium(1)";
	}
	else if(pData[playerid][pVip] == 2)
	{
		VipRank = "Regular(2)";
	}
	else if(pData[playerid][pVip] == 3)
	{
		VipRank = "VIP(3)";
	}
	else
	{
		VipRank = "Player";
	}
    if(strlen(params) < 90)
    {
        foreach (new i : Player) if(pData[i][IsLoggedIn] == true && pData[i][pSpawned] == 1)
        {
            if(pData[playerid][pAdmin] > 1)
			{
                SendClientMessageEx(i, COLOR_PINK, "(( {FF0000}[STAFF] %s{FFFFFF}: %s {FFFFFF}))", pData[playerid][pAdminname], ColouredText(params));
			}
			else if(pData[playerid][pHelper] > 0 && pData[playerid][pAdmin] == 0)
			{
				SendClientMessageEx(i, COLOR_PINK, "(( {00FF00}[SUPPORT] %s{FFFFFF}: %s {FFFFFF}))", pData[playerid][pAdminname], ColouredText(params));
			}
            else
            {
                SendClientMessageEx(i, COLOR_PINK, "(( {33FFCC}%s (%s) %s{FFFFFF} (%d): %s ))", PlayerRank(playerid), VipRank, pData[playerid][pName], playerid, params);
            }
        }
    }
    else
        return Error(playerid, "The text to long, maximum character is 90");

    return 1;
}

CMD:id(playerid, params[])
{
	/*if(pData[playerid][pAdmin] < 1)
   		if(pData[playerid][pHelper] == 0)
     		return PermissionError(playerid);*/
	new otherid;
	if(sscanf(params, "u", otherid))
        return Usage(playerid, "/id [playerid/PartOfName]");
	
	if(!IsPlayerConnected(otherid))
		return Error(playerid, "No player online or name is not found!");
		
	Servers(playerid, "(ID:%d) %s - (Level:%d) - (Ping:%d) - Version (%s)", otherid, pData[otherid][pName], pData[otherid][pLevel], GetPlayerPing(playerid));
	return 1;
}

CMD:goto(playerid, params[])
{
	if(pData[playerid][pAdmin] < 1)
   		if(pData[playerid][pHelper] == 0)
     		return PermissionError(playerid);
			
	new otherid;
	new string[300];
	if(sscanf(params, "u", otherid))
        return Usage(playerid, "/goto [playerid/PartOfName]");

    if(!IsPlayerConnected(otherid))
        return Error(playerid, "Player not connected!");
		
	SendPlayerToPlayer(playerid, otherid);
	Servers(playerid, "You has teleport to %s position.", pData[otherid][pName]);
	Servers(otherid, "%s has teleport to you.", pData[playerid][pName]);
	SendAdminMessage(COLOR_PINK, "%s has teleport to player ID: %d.", pData[playerid][pAdminname], otherid);
	format(string, sizeof string, "```Admins: %s has teleport to player ID: %d.``` ", pData[playerid][pAdminname], otherid);
    DCC_SendChannelMessage(g_discord_admins, string);
	return 1;
}

CMD:sendto(playerid, params[])
{
    static
        type[24],
		otherid;

    if(pData[playerid][pAdmin] < 1)
   		if(pData[playerid][pHelper] == 0)
     		return PermissionError(playerid);

    if(sscanf(params, "us[32]", otherid, type))
    {
        Usage(playerid, "/send [player] [name]");
        Info(playerid, "[NAMES]:{FFFFFF} ls, lv, sf");
        return 1;
    }
	
	if(!IsPlayerConnected(otherid))
        return Error(playerid, "Player not connected!");

	if(!strcmp(type,"ls")) 
	{
        if(GetPlayerState(otherid) == PLAYER_STATE_DRIVER) 
		{
            SetVehiclePos(GetPlayerVehicleID(otherid),1482.0356,-1724.5726,13.5469);
        }
        else 
		{
            SetPlayerPosition(otherid,1482.0356,-1724.5726,13.5469,750);
        }
        SetPlayerFacingAngle(otherid,179.4088);
        SetPlayerInterior(otherid, 0);
        SetPlayerVirtualWorld(otherid, 0);
		Servers(playerid, "Player %s telah berhasil di teleport", pData[otherid][pName]);
		Servers(otherid, "Admin %s telah mengirim anda ke teleport spawn", pData[playerid][pAdminname]);
		pData[otherid][pInDoor] = -1;
		pData[otherid][pInHouse] = -1;
		pData[otherid][pInFlat] = -1;
		pData[otherid][pInHotel] = -1;
		pData[otherid][pInBiz] = -1;
    }
    else if(!strcmp(type,"sf")) 
	{
        if(GetPlayerState(otherid) == PLAYER_STATE_DRIVER) 
		{
            SetVehiclePos(GetPlayerVehicleID(otherid),-1425.8307,-292.4445,14.1484);
        }
        else 
		{
            SetPlayerPosition(otherid,-1425.8307,-292.4445,14.1484,750);
        }
        SetPlayerFacingAngle(otherid,179.4088);
        SetPlayerInterior(otherid, 0);
        SetPlayerVirtualWorld(otherid, 0);
		Servers(playerid, "Player %s telah berhasil di teleport", pData[otherid][pName]);
		Servers(otherid, "Admin %s telah mengirim anda ke teleport spawn", pData[playerid][pAdminname]);
		pData[otherid][pInDoor] = -1;
		pData[otherid][pInHouse] = -1;
		pData[otherid][pInFlat] = -1;
		pData[otherid][pInHotel] = -1;
		pData[otherid][pInBiz] = -1;
    }
    else if(!strcmp(type,"lv")) 
	{
        if(GetPlayerState(otherid) == PLAYER_STATE_DRIVER) 
		{
            SetVehiclePos(GetPlayerVehicleID(otherid),1686.0118,1448.9471,10.7695);
        }
        else 
		{
            SetPlayerPosition(otherid,1686.0118,1448.9471,10.7695,750);
        }
        SetPlayerFacingAngle(otherid,179.4088);
        SetPlayerInterior(otherid, 0);
        SetPlayerVirtualWorld(otherid, 0);
		Servers(playerid, "Player %s telah berhasil di teleport", pData[otherid][pName]);
		Servers(otherid, "Admin %s telah mengirim anda ke teleport spawn", pData[playerid][pAdminname]);
		pData[otherid][pInDoor] = -1;
		pData[otherid][pInHouse] = -1;
		pData[otherid][pInFlat] = -1;
		pData[otherid][pInHotel] = -1;
		pData[otherid][pInBiz] = -1;
    }
    return 1;
}

CMD:gethere(playerid, params[])
{
    new otherid;

	if(pData[playerid][pAdmin] < 1)
   		if(pData[playerid][pHelper] == 0)
     		return PermissionError(playerid);
			
    if(sscanf(params, "u", otherid))
        return Usage(playerid, "/gethere [playerid/PartOfName]");

    if(!IsPlayerConnected(otherid))
        return Error(playerid, "The specified user(s) are not connected.");
	
	if(pData[playerid][pSpawned] == 0 || pData[otherid][pSpawned] == 0)
		return Error(playerid, "Player/Target sedang tidak spawn!");
		
	if(pData[playerid][pJail] > 0 || pData[otherid][pJail] > 0)
		return Error(playerid, "Player/Target sedang di jail");
		
	if(pData[playerid][pArrest] > 0 || pData[otherid][pArrest] > 0)
		return Error(playerid, "Player/Target sedang di arrest");

    SendPlayerToPlayer(otherid, playerid);

    Servers(playerid, "You have get %s.", pData[otherid][pName]);
    Servers(otherid, "%s has get you.", pData[playerid][pName]);
    SendAdminMessage(COLOR_PINK, "%s has get player ID: %d.", pData[playerid][pAdminname], otherid);
    return 1;
}
CMD:togreport(playerid)
{
	if(pData[playerid][pAdmin] < 1)
		return PermissionError(playerid);

	if(pData[playerid][pTogReports] != 1)
	{
		pData[playerid][pTogReports] = 1;
		Info(playerid, "You Disable Report");
	}
	else
	{
		pData[playerid][pTogReports] = 0;
		Info(playerid, "You Enable Report");
	}	
	return 1;
}
CMD:agetloc(playerid, params[])
{
	new otherid;

	if(pData[playerid][pAdmin] < 6)
		return Error(playerid, "the command not registered on the server see '(/help)'.");

	if(sscanf(params, "u", otherid))
        return Usage(playerid, "/getloc [playerid/PartOfName]");

    Info(playerid, "Succes");

    new
		Float: X,
		Float: Y,
		Float: Z;

	GetPlayerPos(otherid, X, Y, Z);
	SetPlayerCheckpoint(playerid, X, Y, Z, 5.0);
	return 1;
}
CMD:freeze(playerid, params[])
{
	if(pData[playerid][pAdmin] < 1)
   		if(pData[playerid][pHelper] == 0)
     		return PermissionError(playerid);
			
	new otherid;
    if(sscanf(params, "u", otherid))
        return Usage(playerid, "/freeze [playerid/PartOfName]");

    if(!IsPlayerConnected(otherid))
        return Error(playerid, "Player not connected!");

    pData[playerid][pFreeze] = 1;

    TogglePlayerControllable(otherid, 0);
    Servers(playerid, "You have frozen %s's movements.", ReturnName(otherid));
	Servers(otherid, "You have been frozen movements by admin %s.", pData[playerid][pAdminname]);
    return 1;
}
CMD:unfreeze(playerid, params[])
{
	if(pData[playerid][pAdmin] < 1)
   		if(pData[playerid][pHelper] == 0)
     		return PermissionError(playerid);
			
	new otherid;
    if(sscanf(params, "u", otherid))
        return Usage(playerid, "/unfreeze [playerid/PartOfName]");

    if(!IsPlayerConnected(otherid))
        return Error(playerid, "Player not connected!");

    pData[playerid][pFreeze] = 0;

    TogglePlayerControllable(otherid, 1);
    Servers(playerid, "You have unfrozen %s's movements.", ReturnName(otherid));
	Servers(otherid, "You have been unfrozen movements by admin %s.", pData[playerid][pAdminname]);
    return 1;
}

CMD:fixstuck(playerid)
{
	/*if(pData[playerid][pAdmin] < 1)
   		if(pData[playerid][pHelper] == 0)
     		return PermissionError(playerid);*/
    if(pData[playerid][pInjured] != 0|| pData[playerid][pCuffed] != 0|| pData[playerid][pHospital] != 0)
      	return Error(playerid, "You cannot do this at this time.");

    if(GetPVarInt(playerid, "fixstuck") > gettime())
        return Error(playerid, "Mohon Tunggu 60 Detik Untuk Menggunakan kembali (Don't Abuse).");

    pData[playerid][pFreeze] = 0;

    TogglePlayerControllable(playerid, 1);
    SetPVarInt(playerid, "fixstuck", gettime() + 60);
	Servers(playerid, "You have been unfreeze your character.");
    return 1;
}

CMD:cursor(playerid)
{
	SelectTextDraw(playerid, 0xFFA500FF);
	Usage(playerid, "/uncursor | Untuk menghilangkan cursor kembali");
	return 1;
}

CMD:uncursor(playerid)
{
	CancelSelectTextDraw(playerid);
	return 1;
}

CMD:fine(playerid, params[])
{
	if(pData[playerid][pAdmin] < 1)
		if(pData[playerid][pHelper] < 2)
     		return PermissionError(playerid);

    new id, cash[32], string[1024], reason[1024];
    new dollars, cents, totalcash[25];
    new year, month,day;
    getdate(year, month, day);
    if(sscanf(params, "us[32]s[32]", id, cash, reason)) return SendClientMessage(playerid, COLOR_GREY, "/fine [playerid] [Jumlah(dollar.cents)] [reason]");
	
	if(strfind(cash, ".", true) != -1)
    {
    	sscanf(cash, "p<.>dd", dollars, cents);
        format(totalcash, sizeof(totalcash), "%d%02d", dollars, cents);
        if(IsPlayerConnected(id) && id != playerid)
        {
              if(strval(totalcash) < 0) return SendClientMessageEx(playerid, COLOR_GREY, "Tidak bisa dibawah $0.00");
              GivePlayerMoneyEx(id, -strval(totalcash));
              format(string, sizeof(string), "AdmCmd: %s has fined %s for $%s",  pData[playerid][pAdminname], pData[playerid][pName], FormatMoney(strval(totalcash)));
              SendClientMessageToAllEx(COLOR_LIGHTRED, string);
              format(string, sizeof(string), "Reason: %s", reason);
              SendClientMessageToAllEx(COLOR_LIGHTRED, string);
        }
    }
    else
    {
        sscanf(cash, "d", dollars);
        format(totalcash, sizeof(totalcash), "%d00", dollars);
        if(IsPlayerConnected(id) && id != playerid)
        {
              if(strval(totalcash) < 0) return SendClientMessageEx(playerid, COLOR_GREY, "Tidak bisa dibawah $0.00");
              GivePlayerMoneyEx(id, -strval(totalcash));
              format(string, sizeof(string), "AdmCmd: %s has fined %s for $%s", pData[playerid][pAdminname], pData[playerid][pName], FormatMoney(strval(totalcash)));
              SendClientMessageToAllEx(COLOR_LIGHTRED, string);
              format(string, sizeof(string), "Reason: %s", reason);
              SendClientMessageToAllEx(COLOR_LIGHTRED, string);
        }
    }
	return 1;
}
CMD:revive(playerid, params[])
{

    if(pData[playerid][pAdmin] < 1)
		if(pData[playerid][pHelper] < 2)
     		return PermissionError(playerid);
			
	new otherid;
    if(sscanf(params, "u", otherid))
        return Usage(playerid, "/revive [playerid/PartOfName]");

    if(!IsPlayerConnected(otherid))
        return Error(playerid, "Player not connected!");

    if(!pData[otherid][pInjured])
        return Error(playerid, "You can't revive a player that's not injured.");

    SetPlayerHealthEx(otherid, 100.0);
    pData[otherid][pInjured] = 0;
	pData[otherid][pHospital] = 0;
	pData[otherid][pSick] = 0;
    ClearAnimations(otherid);

    SendStaffMessage(COLOR_PINK, "Staff %s have revived player %s.", pData[playerid][pAdminname], ReturnName(otherid));
    Info(otherid, "Staff %s has revived your character.", pData[playerid][pAdminname]);
    return 1;
}

CMD:spec(playerid, params[])
{
    if(pData[playerid][pAdmin] < 1)
		if(pData[playerid][pHelper] < 2)
			return PermissionError(playerid);

    if(!isnull(params) && !strcmp(params, "off", true))
    {
        if(GetPlayerState(playerid) != PLAYER_STATE_SPECTATING)
            return Error(playerid, "You are not spectating any player.");

		pData[pData[playerid][pSpec]][playerSpectated]--;
        PlayerSpectatePlayer(playerid, INVALID_PLAYER_ID);
        PlayerSpectateVehicle(playerid, INVALID_VEHICLE_ID);

        SetSpawnInfo(playerid, 0, pData[playerid][pSkin], pData[playerid][pPosX], pData[playerid][pPosY], pData[playerid][pPosZ], pData[playerid][pPosA], 0, 0, 0, 0, 0, 0);
        TogglePlayerSpectating(playerid, false);
		pData[playerid][pSpec] = -1;

        return Servers(playerid, "You are no longer in spectator mode.");
    }
	new otherid;
    if(sscanf(params, "u", otherid))
        return Usage(playerid, "/spectate [playerid/PartOfName] - Type '/spec off' to stop spectating.");

    if(!IsPlayerConnected(otherid))
        return Error(playerid, "Player not connected!");
		
	if(otherid == playerid)
		return Error(playerid, "You can't spectate yourself bro..");

    if(pData[playerid][pAdmin] < pData[otherid][pAdmin])
        return Error(playerid, "You can't spectate admin higher than you.");
		
	if(pData[otherid][pSpawned] == 0)
	{
	    Error(playerid, "%s(%i) isn't spawned!", pData[otherid][pName], otherid);
	    return true;
	}

    if(GetPlayerState(playerid) != PLAYER_STATE_SPECTATING)
    {
        GetPlayerPos(playerid, pData[playerid][pPosX], pData[playerid][pPosY], pData[playerid][pPosZ]);
        GetPlayerFacingAngle(playerid, pData[playerid][pPosA]);

        pData[playerid][pInt] = GetPlayerInterior(playerid);
        pData[playerid][pWorld] = GetPlayerVirtualWorld(playerid);
    }
    SetPlayerInterior(playerid, GetPlayerInterior(otherid));
    SetPlayerVirtualWorld(playerid, GetPlayerVirtualWorld(otherid));

    TogglePlayerSpectating(playerid, 1);

    if(IsPlayerInAnyVehicle(otherid))
	{
		new vID = GetPlayerVehicleID(otherid);
        PlayerSpectateVehicle(playerid, GetPlayerVehicleID(otherid));
		if(GetPlayerState(otherid) == PLAYER_STATE_DRIVER)
	    {
	    	Servers(playerid, "You are now spectating %s(%i) who is driving a %s(%d).", pData[otherid][pName], otherid, GetVehicleModelName(GetVehicleModel(vID)), vID);
		}
		else
		{
		    Servers(playerid, "You are now spectating %s(%i) who is a passenger in %s(%d).", pData[otherid][pName], otherid, GetVehicleModelName(GetVehicleModel(vID)), vID);
		}
	}
    else
	{
        PlayerSpectatePlayer(playerid, otherid);
	}
	pData[otherid][playerSpectated]++;
    SendStaffMessage(COLOR_PINK, "%s now spectating %s (ID: %d).", pData[playerid][pAdminname], pData[otherid][pName], otherid);
    Servers(playerid, "You are now spectating %s (ID: %d).", pData[otherid][pName], otherid);
    pData[playerid][pSpec] = otherid;
    return 1;
}

CMD:slap(playerid, params[])
{
	if(pData[playerid][pAdmin] < 1)
		if(pData[playerid][pHelper] == 0)
			return PermissionError(playerid);
			
	new Float:POS[3], otherid;
	if(sscanf(params, "u", otherid))
	{
	    Usage(playerid, "/slap <ID>");
	    return true;
	}

	if(!IsPlayerConnected(otherid))
        return Error(playerid, "Player not connected!");

	GetPlayerPos(otherid, POS[0], POS[1], POS[2]);
	SetPlayerPos(otherid, POS[0], POS[1], POS[2] + 9.0);
	if(IsPlayerInAnyVehicle(otherid)) 
	{
		RemovePlayerFromVehicle(otherid);
		//OnPlayerExitVehicle(otherid, GetPlayerVehicleID(otherid));
	}
	SendStaffMessage(COLOR_PINK, "Admin %s telah men-slap player %s", pData[playerid][pAdminname], pData[otherid][pName]);

	PlayerPlaySound(otherid, 1130, 0.0, 0.0, 0.0);
	return 1;
}

CMD:caps(playerid, params[])
{
	if(pData[playerid][pAdmin] < 1)
		if(pData[playerid][pHelper] == 0)
			return PermissionError(playerid);
			
	new otherid;
 	if(sscanf(params, "u", otherid))
	{
	    Usage(playerid, "/caps <ID>");
	    Info(playerid, "Function: Will disable caps for the player, type again to enable caps.");
	    return 1;
	}
	if(!IsPlayerConnected(otherid))
        return Error(playerid, "Player not connected!");

	if(!GetPVarType(otherid, "Caps"))
	{
	    // Disable Caps
	    SetPVarInt(otherid, "Caps", 1);
		SendClientMessageToAllEx(COLOR_PINK, "Server: "GREY2_E"Admin %s telah menon-aktifkan anti caps kepada player %s", pData[playerid][pAdminname], pData[playerid][pName]);
	}
	else
	{
	    // Enable Caps
		DeletePVar(otherid, "Caps");
		SendClientMessageToAllEx(COLOR_PINK, "Server: "GREY2_E"Admin %s telah meng-aktifkan anti caps kepada player %s", pData[playerid][pAdminname], pData[playerid][pName]);
	}
	return 1;
}

CMD:peject(playerid, params[])
{
	if(pData[playerid][pAdmin] < 1)
		if(pData[playerid][pHelper] < 2)
			return PermissionError(playerid);
	new otherid;
	if(sscanf(params, "u", otherid))
	{
	    Usage(playerid, "/peject <ID>");
	    return 1;
	}

	if(!IsPlayerConnected(otherid))
        return Error(playerid, "Player not connected!");

	if(!IsPlayerInAnyVehicle(otherid))
	{
		Error(playerid, "Player tersebut tidak berada dalam kendaraan!");
		return 1;
	}

	new vv = GetVehicleModel(GetPlayerVehicleID(otherid));
	Servers(playerid, "You have successfully ejected %s(%i) from their %s.", pData[otherid][pName], otherid, GetVehicleModelName(vv - 400));
	Servers(otherid, "%s(%i) has ejected you from your %s.", pData[playerid][pName], playerid, GetVehicleModelName(vv));
	RemovePlayerFromVehicle(otherid);
	return 1;
}

CMD:aitems(playerid, params[])
{
	if(pData[playerid][pAdmin] < 1)
		if(pData[playerid][pHelper] < 2)
			return PermissionError(playerid);
			
	new otherid;
	if(sscanf(params, "u", otherid))
        return Usage(playerid, "/aitems [playerid/PartOfName]");
	
	if(!IsPlayerConnected(otherid))
        return Error(playerid, "Player not connected!");

	if(pData[otherid][IsLoggedIn] == false)
        return Error(playerid, "That player is not logged in yet.");
		
	DisplayItems(playerid, otherid);
	return 1;
}
CMD:profile(playerid,params[])
{
	if(pData[playerid][pAdmin] < 1)
		if(pData[playerid][pHelper] < 2)
			return PermissionError(playerid);
	new id;
    if(sscanf(params, "u",id))
	    return Usage(playerid, "Usage:/profile [PlayerID/Name]");

    new allshots,hitshots,max_cont_shots,out_of_range_warns,random_aim_warns,proaim_tele_warns;
    BustAim::GetPlayerProfile(id,allshots,hitshots,max_cont_shots,out_of_range_warns,random_aim_warns,proaim_tele_warns);
	new str[144],name[MAX_PLAYER_NAME];
	GetPlayerName(id,name,MAX_PLAYER_NAME);
	format(str,144,"BustAim Profile of %s(%d):Complete Profile:Stats of all weapons",name,id);
	SendClientMessage(playerid,COLOR_GREEN,str);
	format(str,144,"Fired:%d Hits:%d HitPercentage:%.2f MaxContinousShots:%d Bullets OutOfRangeWarns:%d AimWarns:%d TeleportWarns:%d",allshots,hitshots,((hitshots*100.0)/allshots),max_cont_shots,out_of_range_warns,random_aim_warns,proaim_tele_warns);
	SendClientMessage(playerid,COLOR_GREEN,str);
	return 1;
}
CMD:astats(playerid, params[])
{
	if(pData[playerid][pAdmin] < 1)
		if(pData[playerid][pHelper] < 2)
			return PermissionError(playerid);
	new otherid;
	if(sscanf(params, "u", otherid))
        return Usage(playerid, "/check [playerid/PartOfName]");
		
	if(!IsPlayerConnected(otherid))
        return Error(playerid, "Player not connected!");

	if(pData[otherid][IsLoggedIn] == false)
        return Error(playerid, "That player is not logged in yet.");

	DisplayStats(playerid, otherid);
	return 1;
}

CMD:ostats(playerid, params[])
{
	if(pData[playerid][pAdmin] < 1)
		if(pData[playerid][pHelper] < 2)
			return PermissionError(playerid);
			
	new name[24], PlayerName[24];
	if(sscanf(params, "s[24]", name))
	{
	    Usage(playerid, "/ostats <player name>");
 		return 1;
 	}

 	foreach(new ii : Player)
	{
		GetPlayerName(ii, PlayerName, MAX_PLAYER_NAME);

		if(!strcmp(PlayerName, name, true))
		{
			Error(playerid, "Player is online, you can use /stats on them.");
	  		return 1;
	  	}
	}

	// Load User Data
    new cVar[500];
    new cQuery[600];

	strcat(cVar, "email,admin,helper,level,levelup,vip,vip_time,gold,reg_date,last_login,money,bmoney,brek,hours,minutes,seconds,");
	strcat(cVar, "gender,age,faction,family,warn,job,job2,interior,world");

	mysql_format(g_SQL, cQuery, sizeof(cQuery), "SELECT %s FROM players WHERE username='%e' LIMIT 1", cVar, name);
	mysql_tquery(g_SQL, cQuery, "LoadStats", "is", playerid, name);
	return true;
}

CMD:acuff(playerid, params[])
{
	if(pData[playerid][pAdmin] < 1)
   		if(pData[playerid][pHelper] == 0)
     		return PermissionError(playerid);
			
	new otherid, mstr[128];		
    if(sscanf(params, "u", otherid))
        return Usage(playerid, "/acuff [playerid/PartOfName]");

    if(!IsPlayerConnected(otherid))
        return Error(playerid, "Player not connected!");

    //if(otherid == playerid)
        //return Error(playerid, "You cannot handcuff yourself.");

    if(!NearPlayer(playerid, otherid, 5.0))
        return Error(playerid, "You must be near this player.");

    if(GetPlayerState(otherid) != PLAYER_STATE_ONFOOT)
        return Error(playerid, "The player must be onfoot before you can cuff them.");

    if(pData[otherid][pCuffed])
        return Error(playerid, "The player is already cuffed at the moment.");

    pData[otherid][pCuffed] = 1;
	SetPlayerSpecialAction(otherid, SPECIAL_ACTION_CUFFED);

    format(mstr, sizeof(mstr), "You've been ~r~cuffed~w~ by %s.", pData[playerid][pName]);
    InfoTD_MSG(otherid, 3500, mstr);

    Servers(playerid, "Player %s telah berhasil di cuffed.", pData[otherid][pName]);
    Servers(otherid, "Admin %s telah mengcuffed anda.", pData[playerid][pName]);
    return 1;
}

CMD:auncuff(playerid, params[])
{
	if(pData[playerid][pAdmin] < 1)
   		if(pData[playerid][pHelper] == 0)
     		return PermissionError(playerid);
			
	new otherid;		
    if(sscanf(params, "u", otherid))
        return Usage(playerid, "/auncuff [playerid/PartOfName]");

    if(!IsPlayerConnected(otherid))
        return Error(playerid, "Player not connected!");

    //if(otherid == playerid)
        //return Error(playerid, "You cannot uncuff yourself.");

    if(!NearPlayer(playerid, otherid, 5.0))
        return Error(playerid, "You must be near this player.");

    if(!pData[otherid][pCuffed])
        return Error(playerid, "The player is not cuffed at the moment.");

    static
        string[64];

    pData[otherid][pCuffed] = 0;
    SetPlayerSpecialAction(otherid, SPECIAL_ACTION_NONE);

    format(string, sizeof(string), "You've been ~g~uncuffed~w~ by %s.", pData[playerid][pName]);
    InfoTD_MSG(otherid, 3500, string);
	Servers(playerid, "Player %s telah berhasil uncuffed.", pData[otherid][pName]);
    Servers(otherid, "Admin %s telah uncuffed tangan anda.", pData[playerid][pName]);
    return 1;
}

CMD:jetpack(playerid, params[])
{
	if(pData[playerid][pAdmin] < 1)
   		if(pData[playerid][pHelper] < 2)
     		return PermissionError(playerid);
			
	new otherid;		
    if(sscanf(params, "u", otherid))
    {
        //pData[playerid][pJetpack] = 1;
        SetPlayerSpecialAction(playerid, SPECIAL_ACTION_USEJETPACK);
    }
    else
    {
        //pData[playerid][pJetpack] = 1;
        SetPlayerSpecialAction(otherid, SPECIAL_ACTION_USEJETPACK);
        Servers(playerid, "You have spawned a jetpack for %s.", pData[otherid][pName]);
    }
    return 1;
}

CMD:getip(playerid, params[])
{
	if(pData[playerid][pAdmin] < 1)
     	return PermissionError(playerid);
		
	new otherid, PlayerIP[16], giveplayer[24];
	if(sscanf(params, "u", otherid))
 	{
  		Usage(playerid, "/getip <ID>");
		return 1;
	}
	
	if(!IsPlayerConnected(otherid))
        return Error(playerid, "Player not connected!");
		
	if(pData[otherid][pAdmin] == 5)
 	{
  		Error(playerid, "You can't get the server owners ip!");
  		Servers(otherid, "%s(%i) tried to get your IP!", pData[playerid][pName], playerid);
  		return 1;
    }
	GetPlayerName(otherid, giveplayer, sizeof(giveplayer));
	GetPlayerIp(otherid, PlayerIP, sizeof(PlayerIP));

	Servers(playerid, "%s(%i)'s IP: %s", giveplayer, otherid, PlayerIP);
	return 1;
}

CMD:aka(playerid, params[])
{
	if(pData[playerid][pAdmin] < 1)
     	return PermissionError(playerid);
	new otherid, PlayerIP[16], query[128];
	if(sscanf(params, "u", otherid))
	{
	    Usage(playerid, "/aka <ID/Name>");
	    return true;
	}
	
	if(!IsPlayerConnected(otherid))
        return Error(playerid, "Player not connected!");
		
	if(pData[otherid][pAdmin] == 5)
 	{
  		Error(playerid, "You can't AKA the server owner!");
  		Servers(otherid, "%s(%i) tried to AKA you!", pData[playerid][pName], playerid);
  		return 1;
    }
	GetPlayerIp(otherid, PlayerIP, sizeof(PlayerIP));
	mysql_format(g_SQL, query, sizeof(query), "SELECT username FROM players WHERE IP='%s'", PlayerIP);
	mysql_tquery(g_SQL, query, "CheckPlayerIP", "is", playerid, PlayerIP);
	return true;
}

CMD:akaip(playerid, params[])
{
	if(pData[playerid][pAdmin] < 1)
     	return PermissionError(playerid);
	new query[128];
	if(isnull(params))
	{
	    Usage(playerid, "/akaip <IP>");
		return true;
	}

	mysql_format(g_SQL, query, sizeof(query), "SELECT username FROM players WHERE IP='%s'", params);
	mysql_tquery(g_SQL, query, "CheckPlayerIP2", "is", playerid, params);
	return true;
}
CMD:checkip(playerid, params[])
{
	if(pData[playerid][pAdmin] < 1)
     	return PermissionError(playerid);

    new otherid;
    if(sscanf(params, "u", otherid))
	    return Usage(playerid, "/checkip <ID/Name>");


	new str[1500], PlayerIP[15];
	new Float:playerpackets = NetStats_PacketLossPercent(otherid);
	new string[24];
    GetPlayerVersion(otherid, string, sizeof(string));
	GetPlayerIp(otherid, PlayerIP, sizeof(PlayerIP));
	format(str, sizeof(str), "| {C2A2DA}===[IP INFO PLAYERS]===\n");
	format(str, sizeof str, "%s"WHITE_E"NickName: %s\n", str, pData[otherid][pName]);
	format(str, sizeof(str), "%sIP: %s\n", str, PlayerIP);
	format(str, sizeof(str), "%sCountry: %s\n", str, GetPlayerCountry(otherid));
	format(str, sizeof(str), "%sCity: %s\n", str, GetPlayerCity(otherid));
	format(str, sizeof(str), "%sLatitude: %s\n", str, GetPlayerLatitude(otherid));
	format(str, sizeof(str), "%sLongtitude: %s\n", str, GetPlayerLongtitude(otherid));
	format(str, sizeof(str), "%sPacket Loss: %.2f\n", str, playerpackets);
	format(str, sizeof(str), "%sProvider: %s\n", str, GetPlayerProvider(otherid));
	format(str, sizeof(str), "%sProxy: %s\n", str, GetPlayerProxyStatus(otherid));
	format(str, sizeof(str), "%sSamp Version: %s", str, string);
	ShowPlayerDialog(playerid, 0, DIALOG_STYLE_MSGBOX, "Players IP", str, "Close", "");
	return 1;
}
CMD:vmodels(playerid, params[])
{
    new string[3500];

    if(pData[playerid][pAdmin] < 1)
     	return PermissionError(playerid);

    for (new i = 0; i < sizeof(g_arrVehicleNames); i ++)
    {
        format(string,sizeof(string), "%s%d - %s\n", string, i+400, g_arrVehicleNames[i]);
    }
    ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_LIST, "Vehicle Models", string, "Close", "");
    return 1;
}

CMD:vehname(playerid, params[]) {

	if(pData[playerid][pAdmin] >= 1) 
	{
		SendClientMessageEx(playerid, COLOR_PINK, "--------------------------------------------------------------------------------------------------------------------------------");
		SendClientMessageEx(playerid, COLOR_PINK, "Vehicle Search:");

		new
			string[128];

		if(isnull(params)) return Error(playerid, "No keyword specified.");
		if(!params[2]) return Error(playerid, "Search keyword too short.");

		for(new v; v < sizeof(g_arrVehicleNames); v++) 
		{
			if(strfind(g_arrVehicleNames[v], params, true) != -1) {

				if(isnull(string)) format(string, sizeof(string), "%s (ID %d)", g_arrVehicleNames[v], v+400);
				else format(string, sizeof(string), "%s | %s (ID %d)", string, g_arrVehicleNames[v], v+400);
			}
		}

		if(!string[0]) Error(playerid, "No results found.");
		else if(string[127]) Error(playerid, "Too many results found.");
		else SendClientMessageEx(playerid, COLOR_PINK, string);

		SendClientMessageEx(playerid, COLOR_PINK, "--------------------------------------------------------------------------------------------------------------------------------");
	}
	else
	{
		PermissionError(playerid);
	}
	return 1;
}

CMD:owarn(playerid, params[])
{
	if(pData[playerid][pAdmin] < 2)
	    return PermissionError(playerid);
	
	new player[24], tmp[50], PlayerName[MAX_PLAYER_NAME];
	if(sscanf(params, "s[24]s[50]", player, tmp))
		return Usage(playerid, "/owarn <name> <reason>");

	if(strlen(tmp) > 50) return Error(playerid, "Reason must be shorter than 50 characters.");

	foreach(new ii : Player)
	{
		GetPlayerName(ii, PlayerName, MAX_PLAYER_NAME);

	    if(strfind(PlayerName, player, true) != -1)
		{
			Error(playerid, "Player is online, you can use /warn on him.");
	  		return 1;
	  	}
	}
	new query[512];
	mysql_format(g_SQL, query, sizeof(query), "SELECT reg_id,warn FROM players WHERE username='%e'", player);
	mysql_tquery(g_SQL, query, "OWarnPlayer", "iss", playerid, player, tmp);
	return 1;
}

function OWarnPlayer(adminid, NameToWarn[], warnReason[])
{
	if(cache_num_rows() < 1)
	{
		return Error(adminid, "Account "YELLOW_E"'%s' "WHITE_E"does not exist.", NameToWarn);
	}
	else
	{
	    new RegID, warn;
		cache_get_value_index_int(0, 0, RegID);
		cache_get_value_index_int(0, 1, warn);
		SendClientMessageToAllEx(COLOR_BAN, "AdmCmd: Admin %s telah memberi warning(offline) player %s. [Reason: %s]", pData[adminid][pAdminname], NameToWarn, warnReason);
		new query[512];
		mysql_format(g_SQL, query, sizeof(query), "UPDATE players SET warn=%d WHERE reg_id=%d", warn+1, RegID);
		mysql_tquery(g_SQL, query);
	}
	return 1;
}

CMD:ojail(playerid, params[])
{
	if(pData[playerid][pAdmin] < 2)
	    return PermissionError(playerid);

	new player[24], datez, tmp[50], PlayerName[MAX_PLAYER_NAME];
	if(sscanf(params, "s[24]ds[50]", player, datez, tmp))
		return Usage(playerid, "/ojail <name> <time in minutes)> <reason>");

	if(strlen(tmp) > 50) return Error(playerid, "Reason must be shorter than 50 characters.");
	if(datez < 1 || datez > 60)
	{
 		if(pData[playerid][pAdmin] < 5)
   		{
			Error(playerid, "Jail time must remain between 1 and 60 minutes");
  			return 1;
   		}
	}
	foreach(new ii : Player)
	{
		GetPlayerName(ii, PlayerName, MAX_PLAYER_NAME);

	    if(strfind(PlayerName, player, true) != -1)
		{
			Error(playerid, "Player is online, you can use /jail on him.");
	  		return 1;
	  	}
	}
	new query[512];
	mysql_format(g_SQL, query, sizeof(query), "SELECT reg_id FROM players WHERE username='%e'", player);
	mysql_tquery(g_SQL, query, "OJailPlayer", "issi", playerid, player, tmp, datez);
	return 1;
}

function OJailPlayer(adminid, NameToJail[], jailReason[], jailTime)
{
	if(cache_num_rows() < 1)
	{
		return Error(adminid, "Account "YELLOW_E"'%s' "WHITE_E"does not exist.", NameToJail);
	}
	else
	{
	    new RegID, JailMinutes = jailTime * 60;
		cache_get_value_index_int(0, 0, RegID);

		SendClientMessageToAllEx(COLOR_BAN, "AdmCmd: Admin %s telah menjail(offline) player %s selama %d menit. [Reason: %s]", pData[adminid][pAdminname], NameToJail, jailTime, jailReason);
		new query[512];
		mysql_format(g_SQL, query, sizeof(query), "UPDATE players SET jail=%d WHERE reg_id=%d", JailMinutes, RegID);
		mysql_tquery(g_SQL, query);
	}
	return 1;
}

CMD:jail(playerid, params[])
{
   	if(pData[playerid][pAdmin] < 1)
   		if(pData[playerid][pHelper] < 2)
     		return PermissionError(playerid);

	new reason[60], timeSec, otherid;
	new string[300];
	if(sscanf(params, "uD(15)S(*)[60]", otherid, timeSec, reason))
	{
	    Usage(playerid, "/jail <ID/Name> <time in minutes> <reason>)");
	    return true;
	}

	if(!IsPlayerConnected(otherid))
        return Error(playerid, "Player not connected!");

	if(pData[otherid][pJail] > 0)
	{
	    Servers(playerid, "%s(%i) is already jailed (gets out in %d minutes)", pData[otherid][pName], otherid, pData[otherid][pJailTime]);
	    Info(playerid, "/unjail <ID/Name> to unjail.");
	    return true;
	}
	if(pData[otherid][pSpawned] == 0)
	{
	    Error(playerid, "%s(%i) isn't spawned!", pData[otherid][pName], otherid);
	    return true;
	}
	if(reason[0] != '*' && strlen(reason) > 60)
	{
	 	Error(playerid, "Reason too long! Must be smaller than 60 characters!");
	   	return true;
	}
	if(timeSec < 1 || timeSec > 60)
	{
	    if(pData[playerid][pAdmin] < 1)
	 	{
			Error(playerid, "Jail time must remain between 1 and 60 minutes");
	    	return 1;
	  	}
	}
	pData[otherid][pJail] = 1;
	pData[otherid][pJailTime] = timeSec * 60;
	JailPlayer(otherid);
	if(reason[0] == '*')
	{
		SendClientMessageToAllEx(COLOR_BAN, "AdmCmd: %s Has Jailed Player %s For %d Minute.", pData[playerid][pAdminname], pData[otherid][pName], timeSec);
	 	format(string, sizeof string, "```JAIL: Admin %s telah menjail player %s selama %d menit. ```", pData[playerid][pAdminname], pData[otherid][pName], timeSec);
    	DCC_SendChannelMessage(g_discord_admins, string);
	}
	else
	{
		SendClientMessageToAllEx(COLOR_BAN, "AdmCmd: %s Has Jailed Player %s For %d Minute.", pData[playerid][pAdminname], pData[otherid][pName], timeSec);
		SendClientMessageToAllEx(COLOR_BAN, "Reason: %s ", reason);
		format(string, sizeof string, "```JAIL: Admin %s telah menjail player %s selama %d menit. REASON: %s  ```", pData[playerid][pAdminname], pData[otherid][pName], timeSec, reason);
    	DCC_SendChannelMessage(g_discord_admins, string);
	}
	return 1;
}


CMD:unjail(playerid, params[])
{
	if(pData[playerid][pAdmin] < 1)
   		if(pData[playerid][pHelper] < 2)
     		return PermissionError(playerid);

	new otherid;
	new string[300];
	if(sscanf(params, "u", otherid))
	{
	    Usage(playerid, "/unjail <ID/Name>");
	    return true;
	}

    if(!IsPlayerConnected(otherid))
        return Error(playerid, "Player not connected!");

	if(pData[otherid][pJail] == 0)
	    return Error(playerid, "The player isn't in jail!");

	pData[otherid][pJail] = 0;
	pData[otherid][pJailTime] = 0;
	SetPlayerInterior(otherid, 0);
	SetPlayerVirtualWorld(otherid, 0);
	SetPlayerPos(otherid, 1529.6,-1691.2,13.3);
	SetPlayerSpecialAction(otherid, SPECIAL_ACTION_NONE);

	SendClientMessageToAllEx(COLOR_BAN, "AdmCmd: %s Unjailed Player %s", pData[playerid][pAdminname], pData[otherid][pName]);
	format(string, sizeof string, "```JAIL: Admin %s elah unjailed %s  ```", pData[playerid][pAdminname], pData[otherid][pName]);
	DCC_SendChannelMessage(g_discord_admins, string);
	return true;
}

CMD:kick(playerid, params[])
{
    static
        reason[128];

	if(pData[playerid][pAdmin] < 1)
		if(pData[playerid][pHelper] == 0)
			return PermissionError(playerid);
			
	new otherid;
	new string[300];
    if(sscanf(params, "us[128]", otherid, reason))
        return Usage(playerid, "/kick [playerid/PartOfName] [reason]");

    if(!IsPlayerConnected(otherid))
        return Error(playerid, "Player not connected!");

    if(pData[otherid][pAdmin] > pData[playerid][pAdmin])
        return Error(playerid, "The specified player has higher authority.");

    SendClientMessageToAllEx(COLOR_BAN, "AdmCmd: %s Has Been Kicked By Admin %s.", pData[otherid][pName], pData[playerid][pAdminname]);
    SendClientMessageToAllEx(COLOR_BAN, "Reason: %s ", reason);
    format(string, sizeof string, "```KICK: %s was kicked by admin %s. REASON: %s ```", pData[otherid][pName], pData[playerid][pAdminname], reason);
	DCC_SendChannelMessage(g_discord_admins, string);
    //Log_Write("logs/kick_log.txt", "[%s] %s has kicked %s for: %s.", ReturnTime(), ReturnName(otherid, 0), ReturnName(otherid, 0), reason);
	//SetPlayerPosition(otherid, 227.46, 110.0, 999.02, 360.0000, 10);
    KickEx(otherid);
    return 1;
}
CMD:aakick(playerid, params[])
{
    static
        reason[128];

	if(pData[playerid][pAdmin] < 1)
		return Error(playerid, "the command not registered on the server see '(/help)'.");
			
	new otherid;
    if(sscanf(params, "us[128]", otherid, reason))
        return Usage(playerid, "the command not registered on the server see '(/help)'.");

    if(!IsPlayerConnected(otherid))
        return Error(playerid, "Player not connected!");

    if(pData[otherid][pAdmin] > pData[playerid][pAdmin])
        return Error(playerid, "The specified player has higher authority.");

    SendClientMessageToAllEx(COLOR_BAN, "BotCmd: %s Has Been Kicked By MasDicky.", pData[otherid][pName], pData[playerid][pAdminname]);
    SendClientMessageToAllEx(COLOR_BAN, "Reason: %s ", reason);
    KickEx(otherid);
    return 1;
}
CMD:ban(playerid, params[])
{
	if(pData[playerid][pAdmin] < 1)
			return PermissionError(playerid);

	new ban_time, datez, tmp[60], otherid;
	if(sscanf(params, "uds[60]", otherid, datez, tmp))
	{
	    Usage(playerid, "/tempban <ID/Name> <time (in days) 0 for permanent> <reason> ");
	    return true;
	}
	
	if(!IsPlayerConnected(otherid))
        return Error(playerid, "Player not connected!");
	
 	if(datez < 0) Error(playerid, "Please input a valid ban time.");

	if(otherid == playerid)
	    return Error(playerid, "You are not able to ban yourself!");
	
	if(pData[otherid][pAdmin] > pData[playerid][pAdmin])
	{
		Servers(otherid, "** %s(%i) has just tried to ban you!", pData[playerid][pName], playerid);
 		Error(playerid, "You are not able to ban a admin with a higher level than you!");
 		return true;
   	}
	new PlayerIP[16], giveplayer[24];
	new string[300];
	
   	//SetPlayerPosition(otherid, 405.1100,2474.0784,35.7369,360.0000);
	GetPlayerName(otherid, giveplayer, sizeof(giveplayer));
	GetPlayerIp(otherid, PlayerIP, sizeof(PlayerIP));

	if(!strcmp(tmp, "ab", true)) tmp = "Airbreak";
	else if(!strcmp(tmp, "ad", true)) tmp = "Advertising";
	else if(!strcmp(tmp, "ads", true)) tmp = "Advertising";
	else if(!strcmp(tmp, "hh", true)) tmp = "Health Hacks";
	else if(!strcmp(tmp, "wh", true)) tmp = "Weapon Hacks";
	else if(!strcmp(tmp, "sh", true)) tmp = "Speed Hacks";
	else if(!strcmp(tmp, "mh", true)) tmp = "Money Hacks";
	else if(!strcmp(tmp, "rh", true)) tmp = "Ram Hacks";
	else if(!strcmp(tmp, "ah", true)) tmp = "Ammo Hacks";
	if(datez != 0)
	{
		SendClientMessageToAllEx(COLOR_BAN, "AdmCmd: %s Has Been Banned Player %s selama %d Days.", pData[playerid][pAdminname], giveplayer, datez);
		SendClientMessageToAllEx(COLOR_BAN, "Reason: %s ", tmp);
	 	format(string, sizeof string, "```Banned: %s Has Been Banned Player %s. REASON: %s ```",  pData[playerid][pAdminname], giveplayer, datez, tmp);
		DCC_SendChannelMessage(g_discord_ban, string);
	}
	else
	{
		SendClientMessageToAllEx(COLOR_BAN, "AdmCmd: %s Has Been Permanently Banned Player %s.", pData[playerid][pAdminname], giveplayer);
		SendClientMessageToAllEx(COLOR_BAN, "Reason: %s ", tmp);
		format(string, sizeof string, "```Banned: %s Has Been Permanently Banned %s. REASON: %s ```",  pData[playerid][pAdminname], giveplayer, tmp);
		DCC_SendChannelMessage(g_discord_ban, string);
	}
	//SetPlayerPosition(otherid, 227.46, 110.0, 999.02, 360.0000, 10);
	BanPlayerMSG(otherid, playerid, tmp);
 	if(datez != 0)
    {
		Servers(otherid, "This is a "RED_E"TEMP-BAN "GREY2_E"that will last for %d days.", datez);
		ban_time = gettime() + (datez * 86400);
	}
	else
	{
		Servers(otherid, "This is a "RED_E"Permanent Banned "GREY2_E"please contack admin for unbanned!.", datez);
		ban_time = datez;
	}
	new query[248];
	mysql_format(g_SQL, query, sizeof(query), "INSERT INTO banneds(name, ip, admin, reason, ban_date, ban_expire) VALUES ('%s', '%s', '%s', '%s', %i, %d)", giveplayer, PlayerIP, pData[playerid][pAdminname], tmp, gettime(), ban_time);
	mysql_tquery(g_SQL, query);
	KickEx(otherid);
	return true;
}

CMD:unban(playerid, params[])
{
   	if(pData[playerid][pAdmin] < 1)
			return PermissionError(playerid);
	
	new tmp[24];
	if(sscanf(params, "s[24]", tmp))
	{
	    Usage(playerid, "/unban <ban name>");
	    return true;
	}
	new query[128];
	mysql_format(g_SQL, query, sizeof(query), "SELECT name,ip FROM banneds WHERE name = '%e'", tmp);
	mysql_tquery(g_SQL, query, "OnUnbanQueryData", "is", playerid, tmp);
	return 1;
}

function OnUnbanQueryData(adminid, BannedName[])
{
	if(cache_num_rows() > 0)
	{
		new banIP[16], query[128];
		new string[100];
		cache_get_value_name(0, "ip", banIP);
		mysql_format(g_SQL, query, sizeof(query), "DELETE FROM banneds WHERE ip = '%s'", banIP);
		mysql_tquery(g_SQL, query);

		SendClientMessageToAllEx(COLOR_BAN, "AdmCmd: %s(%i) Has Unbanned %s From This Server.", pData[adminid][pAdminname], adminid, BannedName);
		format(string, sizeof string, "```Banned: %s(%i) Has Unbanned %s. From This Server```",  pData[adminid][pAdminname], adminid, BannedName);
		DCC_SendChannelMessage(g_discord_ban, string);
	}
	else
	{
		Error(adminid, "No player named '%s' found on the ban list.", BannedName);
	}
	return 1;
}

CMD:warn(playerid, params[])
{
    static
        reason[32];

    if(pData[playerid][pAdmin] < 1)
        if(pData[playerid][pHelper] < 3)
			return PermissionError(playerid);
	new otherid;
    if(sscanf(params, "us[32]", otherid, reason))
        return Usage(playerid, "/warn [playerid/PartOfName] [reason]");

    if(!IsPlayerConnected(otherid))
        return Error(playerid, "Player not connected!");

    if(pData[otherid][pAdmin] > pData[playerid][pAdmin])
        return Error(playerid, "The specified player has higher authority.");

	pData[otherid][pWarn]++;
	SendClientMessageToAllEx(COLOR_BAN, "AdmCmd: %s has been warned by %s, Total warning: %d", pData[playerid][pAdminname], pData[otherid][pName], pData[otherid][pWarn]);
	SendClientMessageToAllEx(COLOR_BAN, "Reason: %s", reason);
    return 1;
}

CMD:unwarn(playerid, params[])
{
    if(pData[playerid][pAdmin] < 1)
		if(pData[playerid][pHelper] < 3)
			return PermissionError(playerid);
	new otherid;
    if(sscanf(params, "u", otherid))
        return Usage(playerid, "/unwarn [playerid/PartOfName]");

    if(!IsPlayerConnected(otherid))
        return Error(playerid, "Player not connected!");

    pData[otherid][pWarn] -= 1;
    Servers(playerid, "You have unwarned 1 point %s's warnings.", pData[otherid][pName]);
	Servers(otherid, "%s has unwarned 1 point your warnings.", pData[playerid][pAdminname]);
    SendStaffMessage(COLOR_PINK, "Admin %s has unwarned 1 point to %s's warnings.", pData[playerid][pAdminname], pData[otherid][pName]);
    return 1;
}

CMD:respawnsapd(playerid, params[])
{
	if(pData[playerid][pAdmin] < 1)
		if(pData[playerid][pHelper] < 3)
			return PermissionError(playerid);
			
	for(new x;x<sizeof(SAPDVehicles);x++)
	{
		if(IsVehicleEmpty(SAPDVehicles[x]))
		{
			SetVehicleToRespawn(SAPDVehicles[x]);
			SetValidVehicleHealth(SAPDVehicles[x], 2000);
			SetVehicleFuel(SAPDVehicles[x], 1000);
			SwitchVehicleDoors(SAPDVehicles[x], false);
		}
	}
	SendStaffMessage(COLOR_PINK, "%s has respawned SAPD vehicles.", pData[playerid][pAdminname]);
	return 1;
}

CMD:respawnsags(playerid, params[])
{
	if(pData[playerid][pAdmin] < 1)
		if(pData[playerid][pHelper] < 3)
			return PermissionError(playerid);
			
	for(new x;x<sizeof(SAGSVehicles);x++)
	{
		if(IsVehicleEmpty(SAGSVehicles[x]))
		{
			SetVehicleToRespawn(SAGSVehicles[x]);
			SetValidVehicleHealth(SAGSVehicles[x], 2000);
			SetVehicleFuel(SAGSVehicles[x], 1000);
			SwitchVehicleDoors(SAGSVehicles[x], false);
		}
	}
	SendStaffMessage(COLOR_PINK, "%s has respawned SAGS vehicles.", pData[playerid][pAdminname]);
	return 1;
}

CMD:respawnsamd(playerid, params[])
{
	if(pData[playerid][pAdmin] < 1)
		if(pData[playerid][pHelper] < 3)
			return PermissionError(playerid);
			
	for(new x;x<sizeof(SAMDVehicles);x++)
	{
		if(IsVehicleEmpty(SAMDVehicles[x]))
		{
			SetVehicleToRespawn(SAMDVehicles[x]);
			SetValidVehicleHealth(SAMDVehicles[x], 2000);
			SetVehicleFuel(SAMDVehicles[x], 1000);
			SwitchVehicleDoors(SAMDVehicles[x], false);
		}
	}
	SendStaffMessage(COLOR_PINK, "%s has respawned SAMD vehicles.", pData[playerid][pAdminname]);
	return 1;
}

CMD:respawnsana(playerid, params[])
{
	if(pData[playerid][pAdmin] < 1)
		if(pData[playerid][pHelper] < 3)
			return PermissionError(playerid);
			
	for(new x;x<sizeof(SANAVehicles);x++)
	{
		if(IsVehicleEmpty(SANAVehicles[x]))
		{
			SetVehicleToRespawn(SANAVehicles[x]);
			SetValidVehicleHealth(SANAVehicles[x], 2000);
			SetVehicleFuel(SANAVehicles[x], 1000);
			SwitchVehicleDoors(SANAVehicles[x], false);
		}
	}
	SendStaffMessage(COLOR_PINK, "Admin %s has respawned SANA vehicles.", pData[playerid][pAdminname]);
	return 1;
}

CMD:respawnjobs(playerid, params[])
{
	if(pData[playerid][pAdmin] < 1)
		if(pData[playerid][pHelper] < 3)
			return PermissionError(playerid);
			
	for(new x;x<sizeof(SweepVeh);x++)
	{
		if(IsVehicleEmpty(SweepVeh[x]))
		{
			SetVehicleToRespawn(SweepVeh[x]);
			SetValidVehicleHealth(SweepVeh[x], 2000);
			SetVehicleFuel(SweepVeh[x], 1000);
			SwitchVehicleDoors(SweepVeh[x], false);
		}
	}
	for(new xx;xx<sizeof(BusVeh);xx++)
	{
		if(IsVehicleEmpty(BusVeh[xx]))
		{
			SetVehicleToRespawn(BusVeh[xx]);
			SetValidVehicleHealth(BusVeh[xx], 2000);
			SetVehicleFuel(BusVeh[xx], 1000);
			SwitchVehicleDoors(BusVeh[xx], false);
		}
	}
	for(new xx;xx<sizeof(KurirCar);xx++)
	{
		if(IsVehicleEmpty(KurirCar[xx]))
		{
			SetVehicleToRespawn(KurirCar[xx]);
			SetValidVehicleHealth(KurirCar[xx], 2000);
			SetVehicleFuel(KurirCar[xx], 1000);
			SwitchVehicleDoors(KurirCar[xx], false);
		}
	}
	for(new xx;xx<sizeof(TrashCar);xx++)
	{
		if(IsVehicleEmpty(TrashCar[xx]))
		{
			SetVehicleToRespawn(TrashCar[xx]);
			SetValidVehicleHealth(TrashCar[xx], 2000);
			SetVehicleFuel(TrashCar[xx], 1000);
			SwitchVehicleDoors(TrashCar[xx], false);
		}
	}
	for(new xx;xx<sizeof(ForCar);xx++)
	{
		if(IsVehicleEmpty(ForCar[xx]))
		{
			SetVehicleToRespawn(ForCar[xx]);
			SetValidVehicleHealth(ForCar[xx], 2000);
			SetVehicleFuel(ForCar[xx], 1000);
			SwitchVehicleDoors(ForCar[xx], false);
		}
	}
    for(new x;x<sizeof(PizzaVeh);x++)
	{
		if(IsVehicleEmpty(PizzaVeh[x]))
		{
			SetVehicleToRespawn(PizzaVeh[x]);
			SetValidVehicleHealth(PizzaVeh[x], 2000);
			SetVehicleFuel(PizzaVeh[x], 1000);
			SwitchVehicleDoors(PizzaVeh[x], false);
		}
	}
	SendStaffMessage(COLOR_PINK, "Admin %s has respawned Jobs vehicles.", pData[playerid][pAdminname]);
	return 1;
}

RespawnNearbyVehicles(playerid, Float:radi)
{
    new Float:x, Float:y, Float:z;
    GetPlayerPos(playerid, x, y, z);
    for(new i=1; i<MAX_VEHICLES; i++)
    {
        if(GetVehicleModel(i))
        {
            new Float:posx, Float:posy, Float:posz;
            new Float:tempposx, Float:tempposy, Float:tempposz;
            GetVehiclePos(i, posx, posy, posz);
            tempposx = (posx - x);
            tempposy = (posy - y);
            tempposz = (posz - z);
            if (((tempposx < radi) && (tempposx > -radi)) && ((tempposy < radi) && (tempposy > -radi)) && ((tempposz < radi) && (tempposz > -radi)))
            {
				if(IsVehicleEmpty(i))
				{
					//SetVehicleToRespawn(i);
					SetTimerEx("RespawnPV", 3000, false, "d", i);
					SendClientMessageToAllEx(COLOR_BAN, "AdmCmd: Admin %s telah merespawn kendaraan disekitar dengan radius %d.", pData[playerid][pAdminname], radi);
					SendClientMessageToAllEx(COLOR_BAN, "AdmCmd: Jika kendaraan lumber pribadi anda terkena respawn admin gunakan /v park untuk meload kembali lumber anda!");
				}
			}
        }
    }
}

CMD:respawnrad(playerid, params[])
{
	if(pData[playerid][pAdmin] < 1)
		return PermissionError(playerid);
		
	new rad;
	if(sscanf(params, "d", rad)) return Usage(playerid, "/respawnrad [radius] | respawn vehicle nearest");
	
	if(rad > 50) return Error(playerid, "Maximal 50 radius");
	RespawnNearbyVehicles(playerid, rad);
	return 1;
}

//----------------------------[ Admin Level 2 ]-----------------------
CMD:sethp(playerid, params[])
{
	if(pData[playerid][pAdmin] < 2)
        return PermissionError(playerid);
	
	new jumlah, otherid;
	if(sscanf(params, "ud", otherid, jumlah))
        return Usage(playerid, "/sethp [playerid id/name] <jumlah>");
	
	if(!IsPlayerConnected(otherid))
        return Error(playerid, "Player not connected!");
		
	SetPlayerHealthEx(otherid, jumlah);
	SendStaffMessage(COLOR_PINK, "%s telah men set jumlah hp player %s", pData[playerid][pAdminname], pData[otherid][pName]);
	Servers(otherid, "Admin %s telah men set hp anda", pData[playerid][pAdminname]);
	return 1;
}

CMD:setam(playerid, params[])
{
	if(pData[playerid][pAdmin] < 2)
        return PermissionError(playerid);
	
	new jumlah, otherid;
	if(sscanf(params, "ud", otherid, jumlah))
        return Usage(playerid, "/setam [playerid id/name] <jumlah>");
	
	if(!IsPlayerConnected(otherid))
        return Error(playerid, "Player not connected!");
	
	if(jumlah > 95)
	{
		SetPlayerArmourEx(otherid, 98);
	}
	else
	{
		SetPlayerArmourEx(otherid, jumlah);
	}
	SendStaffMessage(COLOR_PINK, "%s telah men set jumlah armor player %s", pData[playerid][pAdminname], pData[otherid][pName]);
	Servers(otherid, "Admin %s telah men set armor anda", pData[playerid][pAdminname]);
	return 1;
}
CMD:setbone(playerid, params[])
{
	if(pData[playerid][pAdmin] < 2)
     		return PermissionError(playerid);

    pData[playerid][pHead] = 100;
	pData[playerid][pPerut] = 100;
	pData[playerid][pRHand] = 100;
	pData[playerid][pLHand] = 100;
	pData[playerid][pRFoot] = 100;
	pData[playerid][pLFoot] = 100;
	return 1;
}
CMD:afix(playerid, params[])
{
	if(pData[playerid][pAdmin] < 2)
     		return PermissionError(playerid);
	
    if(IsPlayerInAnyVehicle(playerid)) 
	{
        SetValidVehicleHealth(GetPlayerVehicleID(playerid), 1000);
		SetVehicleFuel(GetPlayerVehicleID(playerid), 1000);
		ValidRepairVehicle(GetPlayerVehicleID(playerid));
        Servers(playerid, "Vehicle Fixed!");
    }
	else
	{
		Error(playerid, "Kamu tidak berada didalam kendaraan apapun!");
	}
	return 1;
}

CMD:setjob1(playerid, params[])
{
	if(pData[playerid][pAdmin] < 2)
        return PermissionError(playerid);
	
	new
        jobid,
		otherid;
	
	if(sscanf(params, "ud", otherid, jobid))
        return Usage(playerid, "/setjob1 [playerid/PartOfName] [jobid]");
	
	if(!IsPlayerConnected(otherid))
        return Error(playerid, "Player not connected!");
	
	if(jobid < 0 || jobid > 11)
        return Error(playerid, "Invalid ID. 0 - 11.");
		
	pData[otherid][pJob] = jobid;
	pData[otherid][pExitJob] = 0;
	
	Servers(playerid, "Anda telah menset job1 player %s(%d) menjadi %s(%d).", pData[otherid][pName], otherid, GetJobName(jobid), jobid);
	Servers(otherid, "Admin %s telah menset job1 anda menjadi %s(%d)", pData[playerid][pAdminname], GetJobName(jobid), jobid);
	return 1;
}

CMD:setjob2(playerid, params[])
{
	if(pData[playerid][pAdmin] < 2)
        return PermissionError(playerid);
	
	new
        jobid,
		otherid;
	
	if(sscanf(params, "ud", otherid, jobid))
        return Usage(playerid, "/setjob2 [playerid/PartOfName] [jobid]");
	
	if(!IsPlayerConnected(otherid))
        return Error(playerid, "Player not connected!");
	
	if(jobid < 0 || jobid > 11)
        return Error(playerid, "Invalid ID. 0 - 11.");
		
	pData[otherid][pJob2] = jobid;
	pData[otherid][pExitJob] = 0;
	
	Servers(playerid, "Anda telah menset job2 player %s(%d) menjadi %s(%d).", pData[otherid][pName], otherid, GetJobName(jobid), jobid);
	Servers(otherid, "Admin %s telah menset job2 anda menjadi %s(%d)", pData[playerid][pAdminname], GetJobName(jobid), jobid);
	return 1;
}

CMD:setskin(playerid, params[])
{
    new
        skinid,
		otherid;

    if(pData[playerid][pAdmin] < 2)
        return PermissionError(playerid);

    if(sscanf(params, "ud", otherid, skinid))
        return Usage(playerid, "/skin [playerid/PartOfName] [skin id]");

    if(!IsPlayerConnected(otherid))
        return Error(playerid, "Player not connected!");

    if(skinid < 0 || skinid > 299)
        return Error(playerid, "Invalid skin ID. Skins range from 0 to 299.");

    SetPlayerSkin(otherid, skinid);
	pData[otherid][pSkin] = skinid;

    Servers(playerid, "You have set %s's skin to ID: %d.", ReturnName(otherid), skinid);
    Servers(otherid, "%s has set your skin to ID: %d.", ReturnName(playerid), skinid);
    return 1;
}

CMD:akill(playerid, params[])
{
    if(pData[playerid][pAdmin] < 2)
        return PermissionError(playerid);
	new reason[60], otherid;
	if(sscanf(params, "uS(*)[60]", otherid, reason))
	{
	    Usage(playerid, "/akill <ID/Name> <optional: reason>");
	    return 1;
	}

    if(!IsPlayerConnected(otherid))
        return Error(playerid, "Player not connected!");

	SetPlayerHealth(otherid, 0.0);

	if(reason[0] != '*')
	{
		SendClientMessageToAllEx(COLOR_PINK, "AdmCmd: Admin %s has killed %s. "GREY_E"[Reason: %s]", pData[playerid][pAdminname], pData[otherid][pName], reason);
	}
	else
	{
		SendClientMessageToAllEx(COLOR_PINK, "AdmCmd: Admin %s has killed %s.", pData[playerid][pAdminname], pData[otherid][pName]);
	}
	return 1;
}

CMD:akillknife(playerid, params[])
{
	if(pData[playerid][pAdmin] < 6)
       return PermissionError(playerid);

	new otherid;
	if(sscanf(params, "u", otherid))
	{
	    Usage(playerid, "/akill <ID/Name>");
	    return 1;
	}

    if(!IsPlayerConnected(otherid))
        return Error(playerid, "Player not connected!");

	SetPlayerHealth(otherid, 0.0);
	return 1;
}

CMD:ann(playerid, params[])
{
	if(pData[playerid][pAdmin] < 2)
        return PermissionError(playerid);

 	if(isnull(params))
    {
	    Usage(playerid, "/announce <msg>");
	    return 1;
	}
	// Check for special trouble-making input
   	if(strfind(params, "~x~", true) != -1)
		return Error(playerid, "~x~ is not allowed in announce.");
	if(strfind(params, "#k~", true) != -1)
		return Error(playerid, "The constant key is not allowed in announce.");
	if(strfind(params, "/q", true) != -1)
		return Error(playerid, "You are not allowed to type /q in announcement!");

	// Count tildes (uneven number = faulty input)
	new iTemp = 0;
	for(new i = (strlen(params)-1); i != -1; i--)
	{
		if(params[i] == '~')
			iTemp ++;
	}
	if(iTemp % 2 == 1)
		return Error(playerid, "You either have an extra ~ or one is missing in the announcement!");
	
	new str[512];
	format(str, sizeof(str), "~w~%s", params);
	GameTextForAll(str, 6500, 3);
	return true;
}

CMD:settime(playerid, params[])
{
    if(pData[playerid][pAdmin] < 2)
        return PermissionError(playerid);

	new time, mstr[128];
	if(sscanf(params, "d", time))
	{
		Usage(playerid, "/time <time ID>");
		return true;
	}

	SendClientMessageToAllEx(COLOR_PINK, "SERVERS: Admin {FF0000}%s(%i) {FFFFFF}has changed the time to: "YELLOW_E"%d", pData[playerid][pAdminname], playerid, time);

	format(mstr, sizeof(mstr), "~r~Time changed: ~b~%d", time);
	GameTextForAll(mstr, 3000, 5);

	SetWorldTime(time);
	WorldTime = time;
	foreach(new ii : Player)
	{
		SetPlayerTime(ii, time, 0);
	}
	return 1;
}

CMD:setweather(playerid, params[])
{
    new weatherid;

    if(pData[playerid][pAdmin] < 2)
        return PermissionError(playerid);

    if(sscanf(params, "d", weatherid))
        return Usage(playerid, "/setweather [weather ID]");

    SetWeather(weatherid);
	WorldWeather = weatherid;
	foreach(new ii : Player)
	{
		SetPlayerWeather(ii, weatherid);
	}
    SetGVarInt("g_Weather", weatherid);
    SendClientMessageToAllEx(COLOR_PINK,"SERVERS: Admin "RED_E"%s {FFFFFF}have changed the weather ID", pData[playerid][pAdminname]);
    Servers(playerid, "You have changed the weather to ID: %d.", weatherid);
    return 1;
}

CMD:gotoco(playerid, params[])
{
	if(pData[playerid][pAdmin] < 2)
		return PermissionError(playerid);
		
	new Float: pos[3], int;
	if(sscanf(params, "fffd", pos[0], pos[1], pos[2], int)) return Usage(playerid, "/gotoco [x coordinate] [y coordinate] [z coordinate] [interior]");

	Servers(playerid, "You have been teleported to the coordinates specified.");
	SetPlayerPos(playerid, pos[0], pos[1], pos[2]);
	SetPlayerInterior(playerid, int);
	return 1;
}

CMD:cd(playerid)
{
	if(pData[playerid][pAdmin] < 2)
        return PermissionError(playerid);
		
	if(Count != -1) return Error(playerid, "There is already a countdown in progress, wait for it to end!");

	Count = 6;
	countTimer = SetTimer("pCountDown", 1000, 1);

	foreach(new ii : Player)
	{
		showCD[ii] = 1;
	}
	SendClientMessageToAllEx(COLOR_PINK, "[SERVER] "LB_E"Admin %s has started a global countdown!", pData[playerid][pAdminname]);
	return 1;
}

//---------------[ Admin Level 3 ]------------
CMD:oban(playerid, params[])
{
	if(pData[playerid][pAdmin] < 3)
	    return PermissionError(playerid);

	new player[24], datez, reason[50];
	if(sscanf(params, "s[24]D(0)s[50]", player, datez, reason))
	{
	    Usage(playerid, "/oban <ban name> <time in days (0 for permanent ban)> <reason>");
	    Info(playerid, "Will ban a player while he is offline. If time isn't specified it will be a perm ban.");
	    return true;
	}
	if(strlen(reason) > 50) return Error(playerid, "Reason must be shorter than 50 characters.");

	foreach(new ii : Player)
	{
		new PlayerName[24];
		GetPlayerName(ii, PlayerName, MAX_PLAYER_NAME);

	    if(strfind(PlayerName, player, true) != -1)
		{
			Error(playerid, "Player is online, you can use /ban on him.");
	  		return true;
	  	}
	}

	new query[128];

	mysql_format(g_SQL, query, sizeof(query), "SELECT ip FROM players WHERE username='%e'", player);
	mysql_tquery(g_SQL, query, "OnOBanQueryData", "issi", playerid, player, reason, datez);
	return true;
}

CMD:banip(playerid, params[])
{
    if(pData[playerid][pAdmin] < 3)
     	return PermissionError(playerid);

	if(isnull(params))
	{
	    Usage(playerid, "/banip <IP Address>");
		return true;
	}
	if(strfind(params, "*", true) != -1 && pData[playerid][pAdmin] != 5)
	{
		Error(playerid, "You are not authorized to ban ranges.");
  		return true;
  	}

	SendClientMessageToAllEx(COLOR_PINK, "Server: "GREY2_E"Admin %s(%d) IP banned address %s.", pData[playerid][pAdminname], playerid, params);
	
	new tstr[128];
	format(tstr, sizeof(tstr), "banip %s", params);
	SendRconCommand(tstr);
	return 1;
}

CMD:unbanip(playerid, params[])
{
    if(pData[playerid][pAdmin] < 3)
     	return PermissionError(playerid);

	if(isnull(params))
	{
	    Usage(playerid, "/unbanip <IP Address>");
		return true;
	}
	new mstr[128];
	format(mstr, sizeof(mstr), "unbanip %s", params);
	SendRconCommand(mstr);
	format(mstr, sizeof(mstr), "reloadbans");
	SendRconCommand(mstr);
	Servers(playerid, "You have unbanned IP address %s.", params);
	return 1;
}

CMD:reloadweap(playerid, params[])
{
    if(pData[playerid][pAdmin] < 3)
        return PermissionError(playerid);
	new otherid;
    if(sscanf(params, "u", otherid))
        return Usage(playerid, "/reloadweps [playerid/PartOfName]");

    if(!IsPlayerConnected(otherid))
        return Error(playerid, "Player not connected!");

    SetWeapons(otherid);
    Servers(playerid, "You have reload %s's weapons.", pData[otherid][pName]);
    Servers(otherid, "Admin %s have reload your weapons.", pData[playerid][pAdminname]);
    return 1;
}

CMD:resetweap(playerid, params[])
{
    if(pData[playerid][pAdmin] < 3)
        return PermissionError(playerid);
	new otherid;
    if(sscanf(params, "u", otherid))
        return Usage(playerid, "/resetweps [playerid/PartOfName]");

    if(!IsPlayerConnected(otherid))
        return Error(playerid, "Player not connected!");

    ResetPlayerWeaponsEx(otherid);
    Servers(playerid, "You have reset %s's weapons.", pData[otherid][pName]);
    Servers(otherid, "Admin %s have reset your weapons.", pData[playerid][pAdminname]);
    return 1;
}

CMD:sethbe(playerid, params[])
{
	if(pData[playerid][pAdmin] < 3)
        return PermissionError(playerid);
	
	new jumlah, otherid;
	if(sscanf(params, "ud", otherid, jumlah))
        return Usage(playerid, "/sethbe [playerid id/name] <jumlah>");
	
	if(!IsPlayerConnected(otherid))
        return Error(playerid, "Player not connected!");
		
	pData[otherid][pHunger] = jumlah;
	pData[otherid][pEnergy] = jumlah;
	pData[otherid][pSick] = 0;
	SetPlayerDrunkLevel(playerid, 0);
	SendStaffMessage(COLOR_PINK, "%s telah men set jumlah hbe player %s", pData[playerid][pAdminname], pData[otherid][pName]);
	Servers(otherid, "Admin %s telah men set HBE anda", pData[playerid][pAdminname]);
	return 1;
}

//----------------------------[ Admin Level 4 ]---------------
CMD:setname(playerid, params[])
{
	if(pData[playerid][pAdmin] < 4)
		return PermissionError(playerid);
	new otherid, tmp[20];
	if(sscanf(params, "is[20]", otherid, tmp))
	{
	   	Usage(playerid, "/setname <ID/Name> <newname>");
	    return 1;
	}
	if(!IsPlayerConnected(otherid)) return Error(playerid, "Player not connected!");
	if(pData[otherid][IsLoggedIn] == false)	return Error(playerid, "That player is not logged in.");
	
	if(strlen(tmp) < 4) return Error(playerid, "New name can't be shorter than 4 characters!");
	if(strlen(tmp) > 20) return Error(playerid, "New name can't be longer than 20 characters!");

	if(!IsValidName(tmp)) return Error(playerid, "Name contains invalid characters, please doublecheck!");
	new query[248];
	mysql_format(g_SQL, query, sizeof(query), "SELECT username FROM players WHERE username='%s'", tmp);
	mysql_tquery(g_SQL, query, "SetName", "iis", otherid, playerid, tmp);
	return 1;
}

// SetName Callback
function SetName(otherplayer, playerid, nname[])
{
	if(!cache_num_rows())
	{
		new oldname[24], newname[24], query[248];
		GetPlayerName(otherplayer, oldname, sizeof(oldname));
		
		mysql_format(g_SQL, query, sizeof(query), "UPDATE players SET username='%s' WHERE reg_id=%d", nname, pData[otherplayer][pID]);
		mysql_tquery(g_SQL, query);
		
		Servers(otherplayer, "Admin %s telah mengganti nickname anda menjadi (%s)", pData[playerid][pAdminname], nname);
		Info(otherplayer, "Pastikan anda mengingat dan mengganti nickname anda pada saat login kembali!");
		SendStaffMessage(COLOR_PINK, "Admin %s telah mengganti nickname player %s(%d) menjadi %s", pData[playerid][pAdminname], oldname, otherplayer, nname);
		
		SetPlayerName(otherplayer, nname);
		GetPlayerName(otherplayer, newname, sizeof(newname));
		pData[otherplayer][pName] = newname;
		// House
		foreach(new h : Houses)
		{
			if(!strcmp(hData[h][hOwner], oldname, true))
   			{
   			    // Has House
   			    format(hData[h][hOwner], 24, "%s", newname);
          		mysql_format(g_SQL, query, sizeof(query), "UPDATE houses SET owner='%s' WHERE ID=%d", newname, h);
				mysql_tquery(g_SQL, query);
				House_Refresh(h);
				House_Save(h);
			}
		}
		// Flat
		foreach(new h : Flats)
		{
			if(!strcmp(flData[h][flOwner], oldname, true))
   			{
   			    // Has Flat
   			    format(flData[h][flOwner], 24, "%s", newname);
          		mysql_format(g_SQL, query, sizeof(query), "UPDATE flats SET owner='%s' WHERE ID=%d", newname, h);
				mysql_tquery(g_SQL, query);
				Flat_Refresh(h);
				Flat_Save(h);
			}
		}
		// Hotel
		foreach(new ht : Hotels)
		{
			if(!strcmp(htData[ht][htOwner], oldname, true))
   			{
   			    // Has Hotel
   			    format(htData[ht][htOwner], 24, "%s", newname);
          		mysql_format(g_SQL, query, sizeof(query), "UPDATE hotels SET owner='%s' WHERE ID=%d", newname, ht);
				mysql_tquery(g_SQL, query);
				Hotel_Refresh(ht);
				Hotel_Save(ht);
			}
		}
		// Bisnis
		foreach(new b : Bisnis)
		{
			if(!strcmp(bData[b][bOwner], oldname, true))
   			{
   			    // Has Business
   			    format(bData[b][bOwner], 24, "%s", newname);
          		mysql_format(g_SQL, query, sizeof(query), "UPDATE bisnis SET owner='%s' WHERE ID=%d", newname, b);
				mysql_tquery(g_SQL, query);
				Bisnis_Refresh(b);
				Bisnis_Save(b);
			}
		}
		if(pData[otherplayer][PurchasedToy] == true)
		{
			mysql_format(g_SQL, query, sizeof(query), "UPDATE toys SET Owner='%s' WHERE Owner='%s'", newname, oldname);
			mysql_tquery(g_SQL, query);
		}
		/*// Update Family
		if(pGroupRank[otherplayer] == 6)
		{
			format(query, sizeof(query), "UPDATE groups SET gFounder='%s' WHERE gFounder='%s'", newname, oldname);
			MySQL_updateQuery(query);
		}*/
	}
	else
	{
	    // Name Exists
		Error(playerid, "The name "DARK_E"'%s' "WHITE_E"already exists in the database, please use a different name!", nname);
	}
    return 1;
}

function ChangeName(playerid, nname[])
{
	if(!cache_num_rows())
	{
		if(pData[playerid][pGold] < 500) return Error(playerid, "Not enough gold!");
		pData[playerid][pGold] -= 500;
		
		new oldname[24], newname[24], query[248];
		GetPlayerName(playerid, oldname, sizeof(oldname));
		
		mysql_format(g_SQL, query, sizeof(query), "UPDATE players SET username='%s' WHERE reg_id=%d", nname, pData[playerid][pID]);
		mysql_tquery(g_SQL, query);
		
		Servers(playerid, "Anda telah mengganti nickname anda menjadi (%s)", nname);
		Info(playerid, "Pastikan anda mengingat dan mengganti nickname anda pada saat login kembali!");
		SendStaffMessage(COLOR_PINK, "Player %s(%d) telah mengganti nickname menjadi %s(%d)", oldname, playerid, nname, playerid);
		
		SetPlayerName(playerid, nname);
		GetPlayerName(playerid, newname, sizeof(newname));
		pData[playerid][pName] = newname;
		// House
		foreach(new h : Houses)
		{
			if(!strcmp(hData[h][hOwner], oldname, true))
   			{
   			    // Has House
   			    format(hData[h][hOwner], 24, "%s", newname);
          		mysql_format(g_SQL, query, sizeof(query), "UPDATE houses SET owner='%s' WHERE ID=%d", newname, h);
				mysql_tquery(g_SQL, query);
				House_Refresh(h);
				House_Save(h);
			}
		}
		// Flat
		foreach(new h : Flats)
		{
			if(!strcmp(flData[h][flOwner], oldname, true))
   			{
   			    // Has Flat
   			    format(flData[h][flOwner], 24, "%s", newname);
          		mysql_format(g_SQL, query, sizeof(query), "UPDATE flats SET owner='%s' WHERE ID=%d", newname, h);
				mysql_tquery(g_SQL, query);
				Flat_Refresh(h);
				Flat_Save(h);
			}
		}
		// Hotel
		foreach(new ht : Hotels)
		{
			if(!strcmp(htData[ht][htOwner], oldname, true))
   			{
   			    // Has Hotel
   			    format(hData[ht][hOwner], 24, "%s", newname);
          		mysql_format(g_SQL, query, sizeof(query), "UPDATE hotels SET owner='%s' WHERE ID=%d", newname, ht);
				mysql_tquery(g_SQL, query);
				Hotel_Refresh(ht);
				Hotel_Save(ht);
			}
		}
		// Bisnis
		foreach(new b : Bisnis)
		{
			if(!strcmp(bData[b][bOwner], oldname, true))
   			{
   			    // Has Business
   			    format(bData[b][bOwner], 24, "%s", newname);
          		mysql_format(g_SQL, query, sizeof(query), "UPDATE bisnis SET owner='%s' WHERE ID=%d", newname, b);
				mysql_tquery(g_SQL, query);
				Bisnis_Refresh(b);
				Bisnis_Save(b);
			}
		}
		if(pData[playerid][PurchasedToy] == true)
		{
			mysql_format(g_SQL, query, sizeof(query), "UPDATE toys SET Owner='%s' WHERE Owner='%s'", newname, oldname);
			mysql_tquery(g_SQL, query);
		}
		/*// Update Family
		if(pGroupRank[otherplayer] == 6)
		{
			format(query, sizeof(query), "UPDATE groups SET gFounder='%s' WHERE gFounder='%s'", newname, oldname);
			MySQL_updateQuery(query);
		}*/
	}
	else
	{
	    // Name Exists
		Error(playerid, "The name "DARK_E"'%s' "WHITE_E"already exists in the database, please use a different name!", nname);
		return 1;
	}
    return 1;
}
CMD:givetw(playerid, params[])
{
    if(pData[playerid][pAdmin] < 1)
		return PermissionError(playerid);
	new otherid;
	if(sscanf(params, "is[20]", otherid))
	{
	   	Usage(playerid, "/givetw <ID/Name>");
	    return 1;
	}
	if(!IsPlayerConnected(otherid)) return Error(playerid, "Player not connected!");
	if(pData[otherid][IsLoggedIn] == false)	return Error(playerid, "That player is not logged in.");
	
	
	Info(playerid, "Anda Telah Memberikan akun Twitter kepada %s", ReturnName(otherid));
	Info(otherid, "Admin telah memberikan Anda akun Twitter");
	pData[otherid][pTweet] = 1;
	return 1;
}
CMD:taketw(playerid, params[])
{
    if(pData[playerid][pAdmin] < 1)
		return PermissionError(playerid);
	new otherid;
	if(sscanf(params, "is[20]", otherid))
	{
	   	Usage(playerid, "/taketw <ID/Name>");
	    return 1;
	}
	if(!IsPlayerConnected(otherid)) return Error(playerid, "Player not connected!");
	if(pData[otherid][IsLoggedIn] == false)	return Error(playerid, "That player is not logged in.");


	Info(playerid, "Anda Telah Menarik akun Twitter %s", ReturnName(otherid));
	Info(otherid, "Akun Tweet anda telah di tarik Admin!");
	pData[otherid][pTweet] = 0;
	
	return 1;
}
CMD:setvip(playerid, params[])
{
	if(pData[playerid][pAdmin] < 7)
		return PermissionError(playerid);
	
	new alevel, dayz, otherid, tmp[64];
	if(sscanf(params, "udd", otherid, alevel, dayz))
	{
	    Usage(playerid, "/setvip <ID/Name> <level 0 - 3> <time (in days) 0 for permanent>");
	    return true;
	}
	if(!IsPlayerConnected(otherid))
        return Error(playerid, "Player not connected!");
	if(alevel > 3)
		return Error(playerid, "Level can't be higher than 3!");
	if(alevel < 0)
		return Error(playerid, "Level can't be lower than 0!");
	if(dayz < 0)
		return Error(playerid, "Time can't be lower than 0!");
		
	if(pData[otherid][IsLoggedIn] == false)
	{
		Error(playerid, "Player %s(%i) isn't logged in!", pData[otherid][pName], otherid);
		return true;
	}
	
	if(pData[playerid][pAdmin] < 5 && dayz > 7)
		return Error(playerid, "Anda hanya bisa menset 1 - 7 hari!");
	
	pData[otherid][pVip] = alevel;
	if(dayz == 0)
	{
		pData[otherid][pVipTime] = 0;
		SendAdminMessage(COLOR_PINK, "Server: "GREY2_E"Admin %s(%d) telah menset VIP kepada %s(%d) ke level %s permanent time!", pData[playerid][pAdminname], playerid, pData[otherid][pName], otherid, GetVipRank(otherid));
	}
	else
	{
		pData[otherid][pVipTime] = gettime() + (dayz * 86400);
		SendAdminMessage(COLOR_PINK, "Server: "GREY2_E"Admin %s(%d) telah menset VIP kepada %s(%d) selama %d hari ke level %s!", pData[playerid][pAdminname], playerid, pData[otherid][pName], otherid, dayz, GetVipRank(otherid));
	}

	format(tmp, sizeof(tmp), "%d(%d days)", alevel, dayz);
	StaffCommandLog("SETVIP", playerid, otherid, tmp);
	return 1;
}

CMD:givegun(playerid, params[])
{
    static
        weaponid,
        ammo;
		
	new otherid;
    if(pData[playerid][pAdmin] < 4)
        return PermissionError(playerid);

    if(sscanf(params, "udI(250)", otherid, weaponid, ammo))
        return Usage(playerid, "/givewep [playerid/PartOfName] [weaponid] [ammo]");

    if(otherid == INVALID_PLAYER_ID)
        return Error(playerid, "You cannot give weapons to disconnected players.");


    if(weaponid <= 0 || weaponid > 46 || (weaponid >= 19 && weaponid <= 21))
        return Error(playerid, "You have specified an invalid weapon.");

    if(ammo < 1 || ammo > 500)
        return Error(playerid, "You have specified an invalid weapon ammo, 1 - 500");

    GivePlayerWeaponEx(otherid, weaponid, ammo);
    Servers(playerid, "You have give %s a %s with %d ammo.", pData[otherid][pName], ReturnWeaponName(weaponid), ammo);
    return 1;
}

CMD:setfaction(playerid, params[])
{
	new fid, rank, otherid, tmp[64];
    if(pData[playerid][pAdmin] < 4)
        return PermissionError(playerid);

    if(sscanf(params, "udd", otherid, fid, rank))
        return Usage(playerid, "/setfaction [playerid/PartOfName] [0.None 1.SAPD, 2.SAGS, 3.SAMD, 4.SANEW, 5.GOJEK, 6.PEDAGANG] [rank 1-6]");

    if(!IsPlayerConnected(otherid))
        return Error(playerid, "Player not connected!");
	
	if(pData[otherid][pFamily] != -1)
		return Error(playerid, "Player tersebut sudah bergabung family");

    if(fid < 0 || fid > 6)
        return Error(playerid, "You have specified an invalid faction ID 0 - 6.");
		
	if(rank < 1 || rank > 6)
        return Error(playerid, "You have specified an invalid rank 1 - 6.");

	if(fid == 0)
	{
		pData[otherid][pFaction] = 0;
		pData[otherid][pFactionRank] = 0;
		Servers(playerid, "You have removed %s's from faction.", pData[otherid][pName]);
		Servers(otherid, "%s has removed your faction.", pData[playerid][pName]);
	}
	else if(fid == 1)
	{
		Error(playerid, "Silahkan Menggunakan CMD /psetfaction, untuk set faction SAPD.");
	}
	else
	{
		pData[otherid][pFaction] = fid;
		pData[otherid][pFactionRank] = rank;
		Servers(playerid, "You have set %s's faction ID %d with rank %d.", pData[otherid][pName], fid, rank);
		Servers(otherid, "%s has set your faction ID to %d with rank %d.", pData[playerid][pName], fid, rank);
	}
	
	format(tmp, sizeof(tmp), "%d(%d rank)", fid, rank);
	StaffCommandLog("SETFACTION", playerid, otherid, tmp);
    return 1;
}
CMD:psetfaction(playerid, params[])
{
	new fid, rank, otherid, tmp[64];
    if(pData[playerid][pAdmin] < 4)
        return PermissionError(playerid);

    if(sscanf(params, "udd", otherid, fid, rank))
        return Usage(playerid, "/psetfaction [playerid/PartOfName] [0.None, 1.SAPD] [RANK 1-11]");

    if(!IsPlayerConnected(otherid))
        return Error(playerid, "Player not connected!");
	
	if(pData[otherid][pFamily] != -1)
		return Error(playerid, "Player tersebut sudah bergabung family");

    if(fid < 0 || fid > 1)
        return Error(playerid, "You have specified an invalid faction ID 0 - 1.");
		
	if(rank < 1 || rank > 11)
        return Error(playerid, "You have specified an invalid rank 1 - 6.");

	if(fid == 0)
	{
		pData[otherid][pFaction] = 0;
		pData[otherid][pFactionRank] = 0;
		Servers(playerid, "You have removed %s's from faction.", pData[otherid][pName]);
		Servers(otherid, "%s has removed your faction.", pData[playerid][pName]);
	}
	else if(fid == 1)
	{
		pData[otherid][pFaction] = fid;
		pData[otherid][pFactionRank] = rank;
		Servers(playerid, "You have set %s's faction ID %d with rank %d.", pData[otherid][pName], fid, rank);
		Servers(otherid, "%s has set your faction ID to %d with rank %d.", pData[playerid][pName], fid, rank);
	}
	
	format(tmp, sizeof(tmp), "%d(%d rank)", fid, rank);
	StaffCommandLog("SETFACTION", playerid, otherid, tmp);
    return 1;
}
CMD:setleader(playerid, params[])
{
	new fid, otherid, tmp[64];
    if(pData[playerid][pAdmin] < 4)
        return PermissionError(playerid);

    if(sscanf(params, "ud", otherid, fid))
        return Usage(playerid, "/setleader [playerid/PartOfName] [0.None, 1.SAPD, 2.SAGS, 3.SAMD, 4.SANEW, 5.GOJEK, 6.PEDAGANG]");

    if(!IsPlayerConnected(otherid))
        return Error(playerid, "Player not connected!");

	/*if(pData[otherid][pFamily] != -1)
		return Error(playerid, "Player tersebut sudah bergabung family");*/

    if(fid < 0 || fid > 6)
        return Error(playerid, "You have specified an invalid faction ID 0 - 6.");

	if(fid == 0)
	{
		pData[otherid][pFaction] = 0;
		pData[otherid][pFactionLead] = 0;
		pData[otherid][pFactionRank] = 0;
		Servers(playerid, "You have removed %s's from faction leader.", pData[otherid][pName]);
		Servers(otherid, "%s has removed your faction leader.", pData[playerid][pName]);
	}
	else if(fid == 1)
	{
		pData[otherid][pFaction] = fid;
		pData[otherid][pFactionLead] = fid;
		pData[otherid][pFactionRank] = 11;
		Servers(playerid, "You have set %s's faction ID %d with leader.", pData[otherid][pName], fid);
		Servers(otherid, "%s has set your faction ID to %d with leader.", pData[playerid][pName], fid);
	}
	else
	{
		pData[otherid][pFaction] = fid;
		pData[otherid][pFactionLead] = fid;
		pData[otherid][pFactionRank] = 6;
		Servers(playerid, "You have set %s's faction ID %d with leader.", pData[otherid][pName], fid);
		Servers(otherid, "%s has set your faction ID to %d with leader.", pData[playerid][pName], fid);
	}
	
	format(tmp, sizeof(tmp), "%d", fid);
	StaffCommandLog("SETLEADER", playerid, otherid, tmp);
    return 1;
}
/*
CMD:psetleader(playerid, params[])
{
	new fid, otherid, tmp[64];
    if(pData[playerid][pAdmin] < 4)
        return PermissionError(playerid);

    if(sscanf(params, "ud", otherid, fid))
        return Usage(playerid, "/setleader [playerid/PartOfName] [0.None, 1.SAPD]");

    if(!IsPlayerConnected(otherid))
        return Error(playerid, "Player not connected!");
	
	if(pData[otherid][pFamily] != -1)
		return Error(playerid, "Player tersebut sudah bergabung family");

    if(fid < 0 || fid > 1)
        return Error(playerid, "You have specified an invalid faction ID 0 - 1.");

	if(fid == 0)
	{
		pData[otherid][pFaction] = 0;
		pData[otherid][pFactionLead] = 0;
		pData[otherid][pFactionRank] = 0;
		Servers(playerid, "You have removed %s's from faction leader.", pData[otherid][pName]);
		Servers(otherid, "%s has removed your faction leader.", pData[playerid][pName]);
	}
	else
	{
		pData[otherid][pFaction] = fid;
		pData[otherid][pFactionLead] = fid;
		pData[otherid][pFactionRank] = 6;
		Servers(playerid, "You have set %s's faction ID %d with leader.", pData[otherid][pName], fid);
		Servers(otherid, "%s has set your faction ID to %d with leader.", pData[playerid][pName], fid);
	}
	
	format(tmp, sizeof(tmp), "%d", fid);
	StaffCommandLog("SETLEADER", playerid, otherid, tmp);
    return 1;
}*/

CMD:setfam(playerid, params[])
{
	new famid, otherid;
    if(pData[playerid][pAdmin] < 4)
        return PermissionError(playerid);

    if(sscanf(params, "ud", otherid, famid))
        return Usage(playerid, "/setfam [playerid/PartOfName] [-1 = untuk reset]");

    if(!IsPlayerConnected(otherid))
        return Error(playerid, "Player not connected!");

	if(famid == 0)
	{
		pData[otherid][pFamily] = 0;
		//pData[otherid][fLeader] = 0;
		pData[otherid][pFamilyRank] = 0;
		Servers(playerid, "You have removed %s's from family.", pData[otherid][pName]);
		Servers(otherid, "%s has removed your family stats.", pData[playerid][pName]);
	}
	else
	{
		pData[otherid][pFamily] = famid;
		pData[otherid][pFamilyRank] = 6;
		Servers(playerid, "You have set %s's family ID %d with Member.", pData[otherid][pName], famid);
		Servers(otherid, "%s has set your family ID to %d with Member.", pData[playerid][pName], famid);
	}
    return 1;
}

CMD:setfarm(playerid, params[])
{
	new famid, otherid;
    if(pData[playerid][pAdmin] < 4)
        return PermissionError(playerid);

    if(sscanf(params, "ud", otherid, famid))
        return Usage(playerid, "/setfarm [playerid/PartOfName] [-1 = untuk reset]");

    if(!IsPlayerConnected(otherid))
        return Error(playerid, "Player not connected!");

	if(famid == -1)
	{
		pData[otherid][pFarm] = -1;
		pData[otherid][pFarmRank] = -1;
		Servers(playerid, "You have removed %s's from farm.", pData[otherid][pName]);
		Servers(otherid, "%s has removed your farm stats.", pData[playerid][pName]);
	}
	else
	{
		pData[otherid][pFarm] = famid;
		pData[otherid][pFarmRank] = 6;
		Servers(playerid, "You have set %s's farm ID %d with Member.", pData[otherid][pName], famid);
		Servers(otherid, "%s has set your farm ID to %d with Member.", pData[playerid][pName], famid);
	}
    return 1;
}

CMD:setws(playerid, params[])
{
	new famid, otherid;
    if(pData[playerid][pAdmin] < 4)
        return PermissionError(playerid);

    if(sscanf(params, "ud", otherid, famid))
        return Usage(playerid, "/setws [playerid/PartOfName] [-1 = untuk reset]");

    if(!IsPlayerConnected(otherid))
        return Error(playerid, "Player not connected!");

	if(famid == -1)
	{
		pData[otherid][pWsEmplooye] = -1;
		Servers(playerid, "You have removed %s's from farm.", pData[otherid][pName]);
		Servers(otherid, "%s has removed your farm stats.", pData[playerid][pName]);
	}
	else
	{
		pData[otherid][pWsEmplooye] = famid;
		Servers(playerid, "You have set %s's farm ID %d with Member.", pData[otherid][pName], famid);
		Servers(otherid, "%s has set your farm ID to %d with Member.", pData[playerid][pName], famid);
	}
    return 1;
}

CMD:takemoney(playerid, params[])
{
	if(pData[playerid][pAdmin] < 4)
		return PermissionError(playerid);
		
	new money, otherid;
	if(sscanf(params, "ud", otherid, money))
	{
	    Usage(playerid, "/takemoney <ID/Name> <amount>");
	    return true;
	}

	if(!IsPlayerConnected(otherid))
        return Error(playerid, "Player belum masuk!");

 	if(money > pData[otherid][pMoney])
		return Error(playerid, "Player doesn't have enough money to deduct from!");

	GivePlayerMoneyEx(otherid, -money);
	SendClientMessageToAllEx(COLOR_PINK, "Server: {ffff00}Admin %s(%i) has taken away money "RED_E"%s {ffff00}from %s", pData[playerid][pAdminname], FormatMoney(money), pData[otherid][pName]);
	return true;
}

CMD:takegold(playerid, params[])
{
	if(pData[playerid][pAdmin] < 4)
		return PermissionError(playerid);
		
	new gold, otherid;
	if(sscanf(params, "ud", otherid, gold))
	{
	    Usage(playerid, "/takegold <ID/Name> <amount>");
	    return true;
	}

	if(!IsPlayerConnected(otherid))
        return Error(playerid, "Player not connected!");

 	if(gold > pData[otherid][pGold])
		return Error(playerid, "Player doesn't have enough gold to deduct from!");

	pData[otherid][pGold] -= gold;
	SendClientMessageToAllEx(COLOR_PINK, "Server: "GREY2_E"Admin %s(%i) has taken away gold "RED_E"%d "GREY2_E"from %s", pData[playerid][pAdminname], gold, pData[otherid][pName]);
	return 1;
}

CMD:janganabuseveh(playerid, params[])
{
    static
        model[32],
        color1,
        color2;

    if(pData[playerid][pAdmin] < 4)
        return PermissionError(playerid);
	new string[300];
    if(sscanf(params, "s[32]I(0)I(0)", model, color1, color2))
        return Usage(playerid, "/mobil [model id/name] <color 1> <color 2>");

    if((model[0] = GetVehicleModelByName(model)) == 0)
        return Error(playerid, "Invalid model ID.");

    static
        Float:x,
        Float:y,
        Float:z,
        Float:a,
        vehicleid;

    GetPlayerPos(playerid, x, y, z);
    GetPlayerFacingAngle(playerid, a);

    vehicleid = CreateVehicle(model[0], x, y, z, a, color1, color2, 0);

    if(GetPlayerInterior(playerid) != 0)
        LinkVehicleToInterior(vehicleid, GetPlayerInterior(playerid));

    if(GetPlayerVirtualWorld(playerid) != 0)
        SetVehicleVirtualWorld(vehicleid, GetPlayerVirtualWorld(playerid));

    if(IsABoat(vehicleid) || IsAPlane(vehicleid) || IsAHelicopter(vehicleid))
        PutPlayerInVehicle(playerid, vehicleid, 0);

    SetVehicleNumberPlate(vehicleid, "STATIC");
    Servers(playerid, "You have spawned a %s (%d, %d).", GetVehicleModelName(model[0]), color1, color2);
    format(string, sizeof string, "```VEH: %s Has Spawned Vehicle %s (%d, %d).```", pData[playerid][pName], GetVehicleModelName(model[0]), color1, color2);
    DCC_SendChannelMessage(g_discord_admins, string);
    return 1;
}


//-----------------------------[ Admin Level 5 ]------------------
CMD:sethelperlevel(playerid, params[])
{
	if(pData[playerid][pAdmin] < 5)
		return PermissionError(playerid);
	
	new alevel, otherid, tmp[64];
	if(sscanf(params, "ud", otherid, alevel))
	{
	    Usage(playerid, "/sethelperlevel <ID/Name> <level 0 - 3>");
	    return true;
	}
	if(!IsPlayerConnected(otherid))
        return Error(playerid, "Player not connected!");
	if(alevel > 3)
		return Error(playerid, "Level can't be higher than 3!");
	if(alevel < 0)
		return Error(playerid, "Level can't be lower than 0!");
	
	if(pData[otherid][IsLoggedIn] == false)
	{
		Error(playerid, "Player %s(%i) isn't logged in!", pData[otherid][pName], otherid);
		return true;
	}
	pData[otherid][pHelper] = alevel;
	Servers(playerid, "You has set helper level %s(%d) to level %d", pData[otherid][pName], otherid, alevel);
	Servers(otherid, "%s(%d) has set your helper level to %d", pData[otherid][pName], playerid, alevel);
	SendStaffMessage(COLOR_PINK, "Admin %s telah menset %s(%d) sebagai staff helper level %s(%d)",  pData[playerid][pAdminname], pData[otherid][pName], otherid, GetStaffRank(playerid), alevel);
	
	format(tmp, sizeof(tmp), "%d", alevel);
	StaffCommandLog("SETHELPERLEVEL", playerid, otherid, tmp);
	return 1;
}

CMD:setadminname(playerid, params[])
{
	if(pData[playerid][pAdmin] < 5)
		return PermissionError(playerid);
	
	new aname[128], otherid, query[128];
	if(sscanf(params, "us[128]", otherid, aname))
	{
	    Usage(playerid, "/setadminname <ID/Name> <admin name>");
	    return true;
	}
	
	mysql_format(g_SQL, query, sizeof(query), "SELECT adminname FROM players WHERE adminname='%s'", aname);
	mysql_tquery(g_SQL, query, "a_ChangeAdminName", "iis", otherid, playerid, aname);
	return 1;
}

CMD:setmoney(playerid, params[])
{
	if(pData[playerid][pAdmin] < 7)
		return PermissionError(playerid);
		
	new money, otherid, tmp[64];
	if(sscanf(params, "ud", otherid, money))
	{
	    Usage(playerid, "/setmoney <ID/Name> <money>");
	    return true;
	}

    if(!IsPlayerConnected(otherid))
        return Error(playerid, "Player not connected!");
	
	ResetPlayerMoneyEx(otherid);
	GivePlayerMoneyEx(otherid, money);
	
	Servers(playerid, "Kamu telah mengset uang %s(%d) menjadi %s!", pData[otherid][pName], otherid, FormatMoney(money));
	Servers(otherid, "Admin %s telah mengset uang anda menjadi %s!",pData[playerid][pAdminname], FormatMoney(money));
	
	format(tmp, sizeof(tmp), "%d", money);
	StaffCommandLog("SETMONEY", playerid, otherid, tmp);
	return 1;
}

CMD:givemoney(playerid, params[])
{
	if(pData[playerid][pAdmin] < 7)
		return PermissionError(playerid);
		
	new money, otherid, tmp[64];
	if(sscanf(params, "ud", otherid, money))
	{
	    Usage(playerid, "/givemoney <ID/Name> <money>");
	    return true;
	}

    if(!IsPlayerConnected(otherid))
        return Error(playerid, "Player not connected!");
	
	GivePlayerMoneyEx(otherid, money);
	
	Servers(playerid, "Kamu telah memberikan uang %s(%d) dengan jumlah %s!", pData[otherid][pName], otherid, FormatMoney(money));
	Servers(otherid, "Admin %s telah memberikan uang kepada anda dengan jumlah %s!", pData[playerid][pAdminname], FormatMoney(money));
	
	format(tmp, sizeof(tmp), "%d", money);
	StaffCommandLog("GIVEMONEY", playerid, otherid, tmp);
	return 1;
}

CMD:setbankmoney(playerid, params[])
{
	if(pData[playerid][pAdmin] < 7)
		return PermissionError(playerid);
		
	new money, otherid, tmp[64];
	if(sscanf(params, "ud", otherid, money))
	{
	    Usage(playerid, "/setbankmoney <ID/Name> <money>");
	    return true;
	}

    if(!IsPlayerConnected(otherid))
        return Error(playerid, "Player not connected!");
	
	pData[otherid][pBankMoney] = money;
	
	Servers(playerid, "Kamu telah mengset uang rekening banki %s(%d) menjadi %s!", pData[otherid][pName], otherid, FormatMoney(money));
	Servers(otherid, "Admin %s telah mengset uang rekening bank anda menjadi %s!",pData[playerid][pAdminname], FormatMoney(money));
	
	format(tmp, sizeof(tmp), "%d", money);
	StaffCommandLog("SETBANKMONEY", playerid, otherid, tmp);
	return 1;
}

CMD:givebankmoney(playerid, params[])
{
	if(pData[playerid][pAdmin] < 7)
		return PermissionError(playerid);
		
	new money, otherid, tmp[64];
	if(sscanf(params, "ud", otherid, money))
	{
	    Usage(playerid, "/givebankmoney <ID/Name> <money>");
	    return true;
	}

    if(!IsPlayerConnected(otherid))
        return Error(playerid, "Player not connected!");
	
	pData[otherid][pBankMoney] += money;
	
	Servers(playerid, "Kamu telah memberikan uang rekening bank %s(%d) dengan jumlah %s!", pData[otherid][pName], otherid, FormatMoney(money));
	Servers(otherid, "Admin %s telah memberikan uang rekening bank kepada anda dengan jumlah %s!", pData[playerid][pAdminname], FormatMoney(money));
	
	format(tmp, sizeof(tmp), "%d", money);
	StaffCommandLog("GIVEBANKMONEY", playerid, otherid, tmp);
	return 1;
}

CMD:setmaterial(playerid, params[])
{
	if(pData[playerid][pAdmin] < 5)
		return PermissionError(playerid);
		
	new money, otherid, tmp[64];
	if(sscanf(params, "ud", otherid, money))
	{
	    Usage(playerid, "/setmaterial <ID/Name> <amount>");
	    return true;
	}

    if(!IsPlayerConnected(otherid))
        return Error(playerid, "Player not connected!");
	
	pData[otherid][pMaterial] = money;
	
	Servers(playerid, "Kamu telah menset material %s(%d) dengan jumlah %d!", pData[otherid][pName], otherid, money);
	Servers(otherid, "Admin %s telah menset material kepada anda dengan jumlah %d!", pData[playerid][pAdminname], money);
	
	format(tmp, sizeof(tmp), "%d", money);
	StaffCommandLog("SETMATERIAL", playerid, otherid, tmp);
	return 1;
}

CMD:setcomponent(playerid, params[])
{
	if(pData[playerid][pAdmin] < 5)
		return PermissionError(playerid);
		
	new money, otherid, tmp[64];
	if(sscanf(params, "ud", otherid, money))
	{
	    Usage(playerid, "/setcomponent <ID/Name> <amount>");
	    return true;
	}

    if(!IsPlayerConnected(otherid))
        return Error(playerid, "Player not connected!");
	
	pData[otherid][pComponent] = money;
	
	Servers(playerid, "Kamu telah menset component %s(%d) dengan jumlah %d!", pData[otherid][pName], otherid, money);
	Servers(otherid, "Admin %s telah menset component kepada anda dengan jumlah %d!", pData[playerid][pAdminname], money);
	
	format(tmp, sizeof(tmp), "%d", money);
	StaffCommandLog("SETCOMPONENT", playerid, otherid, tmp);
	return 1;
}
CMD:setmarijuana(playerid, params[])
{
	if(pData[playerid][pAdmin] < 5)
		return PermissionError(playerid);

	new money, otherid, tmp[64];
	if(sscanf(params, "ud", otherid, money))
	{
	    Usage(playerid, "/setmarijuana <ID/Name> <amount>");
	    return true;
	}

    if(!IsPlayerConnected(otherid))
        return Error(playerid, "Player not connected!");

	pData[otherid][pMarijuana] = money;

	Servers(playerid, "Kamu telah menset marijuana %s(%d) dengan jumlah %d!", pData[otherid][pName], otherid, money);
	Servers(otherid, "Admin %s telah menset marijuana kepada anda dengan jumlah %d!", pData[playerid][pAdminname], money);

	format(tmp, sizeof(tmp), "%d", money);
	StaffCommandLog("SETCOMPONENT", playerid, otherid, tmp);
	return 1;
}

CMD:setbandage(playerid, params[])
{
	if(pData[playerid][pAdmin] < 5)
		return PermissionError(playerid);

	new money, otherid, tmp[64];
	if(sscanf(params, "ud", otherid, money))
	{
	    Usage(playerid, "/setbandage <ID/Name> <amount>");
	    return true;
	}

    if(!IsPlayerConnected(otherid))
        return Error(playerid, "Player not connected!");

	pData[otherid][pBandage] = money;

	Servers(playerid, "Kamu telah menset bandage %s(%d) dengan jumlah %d!", pData[otherid][pName], otherid, money);
	Servers(otherid, "Admin %s telah menset bandage kepada anda dengan jumlah %d!", pData[playerid][pAdminname], money);

	format(tmp, sizeof(tmp), "%d", money);
	//StaffCommandLog("SETCOMPONENT", playerid, otherid, tmp);
	return 1;
}

CMD:setmedkit(playerid, params[])
{
	if(pData[playerid][pAdmin] < 5)
		return PermissionError(playerid);

	new money, otherid, tmp[64];
	if(sscanf(params, "ud", otherid, money))
	{
	    Usage(playerid, "/setmedkit <ID/Name> <amount>");
	    return true;
	}

    if(!IsPlayerConnected(otherid))
        return Error(playerid, "Player not connected!");

	pData[otherid][pMedkit] = money;

	Servers(playerid, "Kamu telah menset medkit %s(%d) dengan jumlah %d!", pData[otherid][pName], otherid, money);
	Servers(otherid, "Admin %s telah menset medkit kepada anda dengan jumlah %d!", pData[playerid][pAdminname], money);

	format(tmp, sizeof(tmp), "%d", money);
	//StaffCommandLog("SETCOMPONENT", playerid, otherid, tmp);
	return 1;
}
CMD:setlevel(playerid, params[])
{
	if(pData[playerid][pAdmin] < 5)
		return PermissionError(playerid);

	new level, otherid, tmp[64];
	if(sscanf(params, "ud", otherid, level))
	{
	    Usage(playerid, "/setlevel <ID/Name> <Level>");
	    return true;
	}

    if(!IsPlayerConnected(otherid))
        return Error(playerid, "Player not connected!");

	pData[otherid][pLevel] = level;

	Servers(playerid, "Kamu telah menset level %s(%d) dengan jumlah %d!", pData[otherid][pName], otherid, level);
	Servers(otherid, "Admin %s telah menset level kepada anda dengan jumlah %d!", pData[playerid][pAdminname], level);

	format(tmp, sizeof(tmp), "%d", level);
	StaffCommandLog("SETLEVEL", playerid, otherid, tmp);
	return 1;
}

CMD:explode(playerid, params[])
{
    if(pData[playerid][pAdmin] < 5)
        return PermissionError(playerid);
	new Float:POS[3], otherid, giveplayer[24];
	if(sscanf(params, "u", otherid))
	{
		Usage(playerid, "/explode <ID/Name>");
		return true;
	}

	if(!IsPlayerConnected(otherid))
        return Error(playerid, "Player not connected!");

	GetPlayerName(otherid, giveplayer, sizeof(giveplayer));

	Servers(playerid, "You have exploded %s(%i).", giveplayer, otherid);
	GetPlayerPos(otherid, POS[0], POS[1], POS[2]);
	CreateExplosion(POS[0], POS[1], POS[2], 7, 5.0);
	return true;
}

//--------------------------[ Admin Level 6 ]-------------------
CMD:setadminlevel(playerid, params[])
{
	if(pData[playerid][pAdmin] < 6)
		return PermissionError(playerid);
	
	new alevel, otherid, tmp[64];
	if(sscanf(params, "ud", otherid, alevel))
	{
	    Usage(playerid, "/setadminlevel <ID/Name> <level 0 - 4>");
	    return true;
	}
	if(!IsPlayerConnected(otherid))
        return Error(playerid, "Player not connected!");
	if(alevel > 6)
		return Error(playerid, "Level can't be higher than 6!");
	if(alevel < 0)
		return Error(playerid, "Level can't be lower than 0!");
	
	if(pData[otherid][IsLoggedIn] == false)
	{
		Error(playerid, "Player %s(%i) isn't logged in!", pData[otherid][pName], otherid);
		return true;
	}
	pData[otherid][pAdmin] = alevel;
	Servers(playerid, "You has set admin level %s(%d) to level %d", pData[otherid][pName], otherid, alevel);
	Servers(otherid, "%s(%d) has set your admin level to %d", pData[otherid][pName], playerid, alevel);
	
	format(tmp, sizeof(tmp), "%d", alevel);
	StaffCommandLog("SETADMINLEVEL", playerid, otherid, tmp);
	return 1;
}

CMD:mintagolddicky(playerid, params[])
{
	if(pData[playerid][pAdmin] < 6)
		return PermissionError(playerid);
		
	new gold, otherid, tmp[64];
	if(sscanf(params, "ud", otherid, gold))
	{
	    Usage(playerid, "/gold <ID/Name> <gold>");
	    return true;
	}

    if(!IsPlayerConnected(otherid))
        return Error(playerid, "Player not connected!");
	
	pData[otherid][pGold] = gold;
	
	Servers(playerid, "Kamu telah menset gold %s(%d) dengan jumlah %d!", pData[otherid][pName], otherid, gold);
	Servers(otherid, "Admin %s telah menset gold kepada anda dengan jumlah %d!", pData[playerid][pAdminname], gold);
	
	format(tmp, sizeof(tmp), "%d", gold);
	StaffCommandLog("SETGOLD", playerid, otherid, tmp);
	return 1;
}

CMD:givegold(playerid, params[])
{
	if(pData[playerid][pAdmin] < 6)
		return PermissionError(playerid);
		
	new gold, otherid, tmp[64];
	if(sscanf(params, "ud", otherid, gold))
	{
	    Usage(playerid, "/givegold <ID/Name> <gold>");
	    return true;
	}

    if(!IsPlayerConnected(otherid))
        return Error(playerid, "Player not connected!");
	
	pData[otherid][pGold] += gold;
	
	Servers(playerid, "Kamu telah memberikan gold %s(%d) dengan jumlah %d!", pData[otherid][pName], otherid, gold);
	Servers(otherid, "Admin %s telah memberikan gold kepada anda dengan jumlah %d!", pData[playerid][pAdminname], gold);
	
	format(tmp, sizeof(tmp), "%d", gold);
	StaffCommandLog("GIVEGOLD", playerid, otherid, tmp);
	return 1;
}


CMD:setprice(playerid, params[])
{
	if(pData[playerid][pAdmin] < 6)
        return PermissionError(playerid);
		
	new name[64], string[128];
	if(sscanf(params, "s[64]S()[128]", name, string))
    {
        Usage(playerid, "/setprice [name] [price]");
        SendClientMessage(playerid, COLOR_PINK, "[NAMES]:{FFFFFF} [MaterialPrice], [LumberPrice], [ComponentPrice], [MetalPrice], [GasOilPrice], [CoalPrice], [ProductPrice]");
		SendClientMessage(playerid, COLOR_PINK, "[NAMES]:{FFFFFF} [FoodPrice], [FishPrice], [GsPrice]");
        return 1;
    }
	if(!strcmp(name, "materialprice", true))
    {
		new price;
        if(sscanf(string, "d", price))
            return Usage(playerid, "/setprice [materialprice] [price]");

        if(price < 0 || price > 10000)
            return Error(playerid, "You must specify at least 0 or 10000.");

        MaterialPrice = price;
		Server_Save();
        SendAdminMessage(COLOR_PINK, "%s set material price to %s.", pData[playerid][pAdminname], FormatMoney(price));
    }
    if(!strcmp(name, "marijuanaprice", true))
    {
		new price;
        if(sscanf(string, "d", price))
            return Usage(playerid, "/setprice [marijuanaprice] [price]");

        MarijuanaPrice = price;
		Server_Save();
        SendAdminMessage(COLOR_PINK, "%s set marijuana price to %s.", pData[playerid][pAdminname], FormatMoney(price));
    }
	else if(!strcmp(name, "lumberprice", true))
    {
		new price;
        if(sscanf(string, "d", price))
            return Usage(playerid, "/setprice [lumberprice] [price]");

        if(price < 0 || price > 10000)
            return Error(playerid, "You must specify at least 0 or 10000.");

        LumberPrice = price;
		Server_Save();
        SendAdminMessage(COLOR_PINK, "%s set lumber price to %s.", pData[playerid][pAdminname], FormatMoney(price));
    }
	else if(!strcmp(name, "componentprice", true))
    {
		new price;
        if(sscanf(string, "d", price))
            return Usage(playerid, "/setprice [componentprice] [price]");

        if(price < 0 || price > 10000)
            return Error(playerid, "You must specify at least 0 or 10000.");

        ComponentPrice = price;
		Server_Save();
        SendAdminMessage(COLOR_PINK, "%s set component price to %s.", pData[playerid][pAdminname], FormatMoney(price));
    }
	else if(!strcmp(name, "metalprice", true))
    {
		new price;
        if(sscanf(string, "d", price))
            return Usage(playerid, "/setprice [metalprice] [price]");

        if(price < 0 || price > 10000)
            return Error(playerid, "You must specify at least 0 or 10000.");

        MetalPrice = price;
		Server_Save();
        SendAdminMessage(COLOR_PINK, "%s set metal price to %s.", pData[playerid][pAdminname], FormatMoney(price));
    }
	else if(!strcmp(name, "gasoilprice", true))
    {
		new price;
        if(sscanf(string, "d", price))
            return Usage(playerid, "/setprice [gasoilprice] [price]");

        if(price < 0 || price > 10000)
            return Error(playerid, "You must specify at least 0 or 10000.");

        GasOilPrice = price;
		Server_Save();
        SendAdminMessage(COLOR_PINK, "%s set gasoil price to %s.", pData[playerid][pAdminname], FormatMoney(price));
    }
	else if(!strcmp(name, "coalprice", true))
    {
		new price;
        if(sscanf(string, "d", price))
            return Usage(playerid, "/setprice [coalprice] [price]");

        if(price < 0 || price > 10000)
            return Error(playerid, "You must specify at least 0 or 10000.");

        CoalPrice = price;
		Server_Save();
        SendAdminMessage(COLOR_PINK, "%s set coal price to %s.", pData[playerid][pAdminname], FormatMoney(price));
    }
	else if(!strcmp(name, "productprice", true))
    {
		new price;
        if(sscanf(string, "d", price))
            return Usage(playerid, "/setprice [productprice] [price]");

        if(price < 0 || price > 10000)
            return Error(playerid, "You must specify at least 0 or 10000.");

        ProductPrice = price;
		Server_Save();
        SendAdminMessage(COLOR_PINK, "%s set product price to %s.", pData[playerid][pAdminname], FormatMoney(price));
    }
	else if(!strcmp(name, "medicineprice", true))
    {
		new price;
        if(sscanf(string, "d", price))
            return Usage(playerid, "/setprice [medicineprice] [price]");

        if(price < 0 || price > 10000)
            return Error(playerid, "You must specify at least 0 or 10000.");

        MedicinePrice = price;
		Server_Save();
        SendAdminMessage(COLOR_PINK, "%s set medicine price to %s.", pData[playerid][pAdminname], FormatMoney(price));
    }
	else if(!strcmp(name, "medkitprice", true))
    {
		new price;
        if(sscanf(string, "d", price))
            return Usage(playerid, "/setprice [medkitprice] [price]");

        if(price < 0 || price > 10000)
            return Error(playerid, "You must specify at least 0 or 10000.");

        MedkitPrice = price;
		Server_Save();
        SendAdminMessage(COLOR_PINK, "%s set medkit price to %s.", pData[playerid][pAdminname], FormatMoney(price));
    }
	else if(!strcmp(name, "foodprice", true))
    {
		new price;
        if(sscanf(string, "d", price))
            return Usage(playerid, "/setprice [foodprice] [price]");

        if(price < 0 || price > 10000)
            return Error(playerid, "You must specify at least 0 or 10000.");

        FoodPrice = price;
		Server_Save();
        SendAdminMessage(COLOR_PINK, "%s set food price to %s.", pData[playerid][pAdminname], FormatMoney(price));
    }
	else if(!strcmp(name, "fishprice", true))
    {
		new price;
        if(sscanf(string, "d", price))
            return Usage(playerid, "/setprice [fishprice] [price]");

        if(price < 0 || price > 10000)
            return Error(playerid, "You must specify at least 0 or 10000.");

        FishPrice = price;
		Server_Save();
        SendAdminMessage(COLOR_PINK, "%s set fish price to %s.", pData[playerid][pAdminname], FormatMoney(price));
    }
    else if(!strcmp(name, "wheatrice", true))
    {
		new price;
        if(sscanf(string, "d", price))
            return Usage(playerid, "/setprice [fishprice] [price]");

        if(price < 0 || price > 10000)
            return Error(playerid, "You must specify at least 0 or 10000.");

        WheatPrice = price;
		Server_Save();
        SendAdminMessage(COLOR_PINK, "%s set wheat price to %s.", pData[playerid][pAdminname], FormatMoney(price));
    }
    else if(!strcmp(name, "potatoprice", true))
    {
		new price;
        if(sscanf(string, "d", price))
            return Usage(playerid, "/setprice [fishprice] [price]");

        if(price < 0 || price > 10000)
            return Error(playerid, "You must specify at least 0 or 10000.");

        PotatoPrice = price;
		Server_Save();
        SendAdminMessage(COLOR_PINK, "%s set potato price to %s.", pData[playerid][pAdminname], FormatMoney(price));
    }
    else if(!strcmp(name, "orangeprice", true))
    {
		new price;
        if(sscanf(string, "d", price))
            return Usage(playerid, "/setprice [fishprice] [price]");

        if(price < 0 || price > 10000)
            return Error(playerid, "You must specify at least 0 or 10000.");

        OrangePrice = price;
		Server_Save();
        SendAdminMessage(COLOR_PINK, "%s set orange price to %s.", pData[playerid][pAdminname], FormatMoney(price));
    }
	else if(!strcmp(name, "gsprice", true))
    {
		new price;
        if(sscanf(string, "d", price))
            return Usage(playerid, "/setprice [gsprice] [price]");

        if(price < 0 || price > 10000)
            return Error(playerid, "You must specify at least 0 or 10000.");

        GStationPrice = price;
		foreach(new gsid : GStation)
		{
			if(Iter_Contains(GStation, gsid))
			{
				GStation_Save(gsid);
				GStation_Refresh(gsid);
			}
		}
		Server_Save();
        SendAdminMessage(COLOR_PINK, "%s set gs price to %s.", pData[playerid][pAdminname], FormatMoney(price));
    }
	return 1;
}

CMD:setstock(playerid, params[])
{
	if(pData[playerid][pAdmin] < 6)
        return PermissionError(playerid);
		
	new name[64], string[128];
	if(sscanf(params, "s[64]S()[128]", name, string))
    {
        Usage(playerid, "/setstock [name] [stock]");
        SendClientMessage(playerid, COLOR_PINK, "[NAMES]:{FFFFFF} [material], [component], [product], [gasoil], [food], [cargomeat], [cargoseed]");
        return 1;
    }
	if(!strcmp(name, "material", true))
    {
		new stok;
        if(sscanf(string, "d", stok))
            return Usage(playerid, "/setstok [material] [stok]");

        if(stok < 0 || stok > 50000)
            return Error(playerid, "You must specify at least 0 or 5000.");

        Material = stok;
		Server_Save();
        SendAdminMessage(COLOR_PINK, "%s set material to %d.", pData[playerid][pAdminname], stok);
    }
	else if(!strcmp(name, "component", true))
    {
		new stok;
        if(sscanf(string, "d", stok))
            return Usage(playerid, "/setstok [component] [stok]");

        if(stok < 0 || stok > 50000)
            return Error(playerid, "You must specify at least 0 or 5000.");

        Component = stok;
		Server_Save();
        SendAdminMessage(COLOR_PINK, "%s set component to %d.", pData[playerid][pAdminname], stok);
    }
	else if(!strcmp(name, "product", true))
    {
		new stok;
        if(sscanf(string, "d", stok))
            return Usage(playerid, "/setstok [product] [stok]");

        if(stok < 0 || stok > 5000)
            return Error(playerid, "You must specify at least 0 or 5000.");

        Product = stok;
		Server_Save();
        SendAdminMessage(COLOR_PINK, "%s set product to %d.", pData[playerid][pAdminname], stok);
    }
	else if(!strcmp(name, "gasoil", true))
    {
		new stok;
        if(sscanf(string, "d", stok))
            return Usage(playerid, "/setstok [gasoil] [stok]");

        if(stok < 0 || stok > 5000)
            return Error(playerid, "You must specify at least 0 or 5000.");

        GasOil = stok;
		Server_Save();
        SendAdminMessage(COLOR_PINK, "%s set gasoil to %d.", pData[playerid][pAdminname], stok);
    }
	else if(!strcmp(name, "apotek", true))
    {
		new stok;
        if(sscanf(string, "d", stok))
            return Usage(playerid, "/setstok [apotek] [stok]");

        if(stok < 0 || stok > 5000)
            return Error(playerid, "You must specify at least 0 or 5000.");

        Apotek = stok;
		Server_Save();
        SendAdminMessage(COLOR_PINK, "%s set apotek stok to %d.", pData[playerid][pAdminname], stok);
    }
	else if(!strcmp(name, "food", true))
    {
		new stok;
        if(sscanf(string, "d", stok))
            return Usage(playerid, "/setstok [food] [stok]");

        if(stok < 0 || stok > 5000)
            return Error(playerid, "You must specify at least 0 or 5000.");

        Food = stok;
		Server_Save();
        SendAdminMessage(COLOR_PINK, "%s set food stok to %d.", pData[playerid][pAdminname], stok);
    }
    else if(!strcmp(name, "cargomeat", true))
    {
		new stok;
        if(sscanf(string, "d", stok))
            return Usage(playerid, "/setstok [cargomeat] [stok]");

        if(stok < 0 || stok > 50000)
            return Error(playerid, "You must specify at least 0 or 5000.");

        ServerCargoMeat = stok;
		Server_Save();
        SendAdminMessage(COLOR_PINK, "%s set cargomeat stok to %d.", pData[playerid][pAdminname], stok);
    }
    else if(!strcmp(name, "cargoseed", true))
    {
		new stok;
        if(sscanf(string, "d", stok))
            return Usage(playerid, "/setstok [cargoseed] [stok]");

        if(stok < 0 || stok > 50000)
            return Error(playerid, "You must specify at least 0 or 5000.");

        ServerCargoSeed = stok;
		Server_Save();
        SendAdminMessage(COLOR_PINK, "%s set cargoseed stok to %d.", pData[playerid][pAdminname], stok);
    }
	return 1;
}

CMD:giveallm(playerid, params[])
{
	if(pData[playerid][pAdmin] < 6)
		return PermissionError(playerid);

	extract params -> new money; else return Usage(playerid, "/giveallm <ammount>");
	foreach(new pid : Player)
	{
		if(pid != playerid)
		{
			GivePlayerMoneyEx(pid, money);
			Info(pid, "Anda Mendapatkan Uang Dari Dewa sebesar %s", FormatMoney(money));
		}
	}
	return 1;
}

CMD:kickall(playerid, params[])
{
	if(pData[playerid][pAdmin] < 6)
		return PermissionError(playerid);
		
	foreach(new pid : Player)
	{
		if(pid != playerid)
		{
			UpdateWeapons(playerid);
			UpdatePlayerData(playerid);
			Servers(pid, "Sorry, server will be restarted and your data have been saved.");
			KickEx(pid);
		}
	}
	return 1;
}
CMD:stuckevent(playerid, params[])
{
	if(pData[playerid][pAdmin] < 6)
		return PermissionError(playerid);
		
	foreach(new pid : Player)
	{
		if(pid != playerid)
		{
			pData[pid][pFreeze] = 0;
			Servers(pid, "Event started, Gas baku hantam!.");
		}
	}
	return 1;
}
CMD:setphone(playerid, params[])
{
	if(pData[playerid][pAdmin] < 6)
		return PermissionError(playerid);

	new number, otherid;
	if(sscanf(params, "ud", otherid, number))
		return Usage(playerid, "/setphone [playerid/PartOfName] [Number Phone]");

	if(!IsPlayerConnected(otherid))
		return Error(playerid, "Player belum masuk!");

	pData[playerid][pPhone] = number;
	SendStaffMessage(COLOR_PINK, "Admin %s telah menset nomor phonsel milik player %s", pData[playerid][pAdminname], pData[otherid][pName]);
	Servers(otherid, "Admin %s telah menset nomor phonse kamu menjadi %d", pData[playerid][pAdminname], number);
	return 1;
}
CMD:setrek(playerid, params[])
{
	if(pData[playerid][pAdmin] < 6)
		return PermissionError(playerid);

	new rek, otherid;
	if(sscanf(params, "ud", otherid, rek))
		return Usage(playerid, "/setrek [playerid/PartOfName] [ Number Rek ]");

	if(!IsPlayerConnected(otherid))
		return Error(playerid, "Player belum masuk!");

	pData[playerid][pBankRek] = rek;
	SendStaffMessage(COLOR_PINK, "Admin %s telah menset nomor rekening player %s", pData[playerid][pAdminname], pData[otherid][pName]);
	Servers(otherid, "Admin %s telah menset nomor rekening kamu menjadi %d", pData[playerid][pAdminname], rek);
	return 1;
}
CMD:setpassword(playerid, params[])
{
	if(pData[playerid][pAdmin] < 1)
		return PermissionError(playerid);

	new cname[21], query[128], pass[65], tmp[64];
	if(sscanf(params, "s[21]s[20]", cname, pass))
	{
	    Usage(playerid, "/setpassword <name> <new password>");
	    Info(playerid, "Make sure you enter the players name and not ID!");
	   	return 1;
	}

	mysql_format(g_SQL, query, sizeof(query), "SELECT password FROM players WHERE username='%s'", cname);
	mysql_tquery(g_SQL, query, "ChangePlayerPassword", "iss", playerid, cname, pass);
	
	format(tmp, sizeof(tmp), "%s", pass);
	StaffCommandLog("SETPASSWORD", playerid, INVALID_PLAYER_ID, tmp);
	return 1;
}

// SetPassword Callback
function ChangePlayerPassword(admin, cPlayer[], newpass[])
{
	if(cache_num_rows() > 0)
	{
		new query[512], pass[65], salt[16];
		Servers(admin, "Password for %s has been set to \"%s\"", cPlayer, newpass);
		
		for (new i = 0; i < 16; i++) salt[i] = random(94) + 33;
		SHA256_PassHash(newpass, salt, pass, 65);

		mysql_format(g_SQL, query, sizeof(query), "UPDATE players SET password='%s', salt='%e' WHERE username='%s'", pass, salt, cPlayer);
		mysql_tquery(g_SQL, query);
	}
	else
	{
	    // Name Exists
		Error(admin, "The name"DARK_E"'%s' "WHITE_E"doesn't exist in the database!", cPlayer);
	}
    return 1;
}


CMD:playsong(playerid, params[])
{
	if(pData[playerid][pAdmin] < 5)
		return PermissionError(playerid);

	new songname[128], tmp[512], Float:x, Float:y, Float:z;
	if (sscanf(params, "s[128]", songname))
	{
		Usage(playerid, "/playsong <link>");
		return 1;
	}
	
	GetPlayerPos(playerid, x, y, z);
	format(tmp, sizeof(tmp), "%s", songname);
	foreach(new ii : Player)
	{
		if(IsPlayerInRangeOfPoint(ii, 35.0, x, y, z))
		{
			PlayAudioStreamForPlayer(ii, tmp);
			Servers(ii, "/stopsong, /togsong");
		}
	}
	return 1;
}

CMD:playnearsong(playerid, params[])
{
	if(pData[playerid][pAdmin] < 5)
		return PermissionError(playerid);

	new songname[128], tmp[512], Float:x, Float:y, Float:z;
	if (sscanf(params, "s[128]", songname))
	{
		Usage(playerid, "/playnearsong <link>");
		return 1;
	}
	
	GetPlayerPos(playerid, x, y, z);
	format(tmp, sizeof(tmp), "%s", songname);
	foreach(new ii : Player)
	{
		if(IsPlayerInRangeOfPoint(ii, 35.0, x, y, z))
		{
			PlayAudioStreamForPlayer(ii, tmp, x, y, z, 35.0, 1);
			Servers(ii, "/stopsong, /togsong");
		}
	}
	return 1;
}
CMD:setfightstyle(playerid, params[])
{
	//if(pData[playerid][pAdmin] < 6)
	{
		new String[10000], giveplayerid, fightstyle;
		if(sscanf(params, "ud", giveplayerid, fightstyle))
		{
			Usage(playerid, "</setfightstyle [playerid] [fightstyle]");
			Info(playerid, "INFO: Available fighting styles: 4, 5, 6, 7, 15, 26.");
			return 1;
		}

		if(fightstyle > 3 && fightstyle < 8 || fightstyle == 15 || fightstyle == 26)
		{
			format(String, sizeof(String), " Your fighting style has been changed to %d.", fightstyle);
			SendClientMessageEx(giveplayerid,COLOR_PINK,String);
			format(String, sizeof(String), " You have changed 's fighting style to %d.", fightstyle);
			SendClientMessageEx(playerid,COLOR_PINK,String);
			SetPlayerFightingStyle(giveplayerid, fightstyle);
			//pData[playerid][pFightStyle] = fightstyle;
			return 1;
		}
	}
	
	return 1;
}
CMD:stopsong(playerid)
{
	StopAudioStreamForPlayer(playerid);
	Servers(playerid, "Song stop!");
	return 1;
}

CMD:exitjob1(playerid, params[])
{
    if(pData[playerid][pAdmin] < 2)
		return PermissionError(playerid);
		
	extract params -> new to_player; else return Usage(playerid, "/exitjob1 <PartOfName/ID>");
	pData[to_player][pJob] = 0;
	pData[playerid][pExitJob] = 0;
	return 1;
}

CMD:exitjob2(playerid, params[])
{
    if(pData[playerid][pAdmin] < 2)
		return PermissionError(playerid);
		
	extract params -> new to_player; else return Usage(playerid, "/exitjob2 <PartOfName/ID>");
	pData[to_player][pJob2] = 0;
	return 1;
}

alias:setwhitelist("setwl", "swl")
CMD:setwhitelist(playerid, params[])
{
	if(pData[playerid][pAdmin] < 1)
	    return PermissionError(playerid);

	new player[24], PlayerName[MAX_PLAYER_NAME];
	if(sscanf(params, "s[24]", player))
		return Usage(playerid, "/swl <Name>");

	foreach(new ii : Player)
	{
		GetPlayerName(ii, PlayerName, MAX_PLAYER_NAME);

	    if(strfind(PlayerName, player, true) != -1)
		{
			Error(playerid, "Player is online, you can use /jail on him.");
	  		return 1;
	  	}
	}
	new query[512];
	mysql_format(g_SQL, query, sizeof(query), "SELECT reg_id FROM players WHERE username='%e'", player);
	mysql_tquery(g_SQL, query, "WhitelistPlayer", "is", playerid, player);
	return 1;
}

function WhitelistPlayer(adminid, NameToJail[])
{
	if(cache_num_rows() < 1)
	{
		return Error(adminid, "Account "GREY2_E"'%s' "WHITE_E"does not exist.", NameToJail);
	}
	else
	{
	    new RegID;
		cache_get_value_index_int(0, 0, RegID);

		foreach(new i : Player)
		{
		    if(pData[i][pAdmin] > 0)
		    {
		        SendClientMessageEx(i, COLOR_PINK, "Server: "GREY2_E"Admin %s telah men-whitelist player %s", pData[adminid][pAdminname], NameToJail);
		    }
		}
		new query[512];
		mysql_format(g_SQL, query, sizeof(query), "UPDATE players SET WhiteList=1 WHERE reg_id=%d", RegID);
		mysql_tquery(g_SQL, query);
	}
	return 1;
}
CMD:genterveh(playerid,params[])
{
    if(pData[playerid][pAdmin] < 1)
        return PermissionError(playerid);

	new vehicleid, Float:pos[3];
	if (sscanf(params,"d",vehicleid))
	    return Usage(playerid,"/gentercar [vehicle id]");

	GetPlayerPos(playerid,pos[0],pos[1],pos[2]);
	SetVehiclePos(vehicleid,pos[0]+2,pos[1],pos[2]);

	if (GetPlayerVirtualWorld(playerid) != 0)
		SetVehicleVirtualWorld(vehicleid,GetPlayerVirtualWorld(playerid));

	if (GetPlayerInterior(playerid) != 0)
		LinkVehicleToInterior(vehicleid,GetPlayerInterior(playerid));

	PutPlayerInVehicle(playerid,vehicleid,0);
	Info(playerid,"You've get vehicle id %d.",vehicleid);
	return 1;
}
CMD:enterveh(playerid,params[])
{
    if(pData[playerid][pAdmin] < 1)
        return PermissionError(playerid);

	new vehicleid;
	if (sscanf(params,"d",vehicleid))
	    return Usage(playerid,"/entercar [vehicle id]");

	PutPlayerInVehicle(playerid,vehicleid,0);
	Info(playerid,"You've enter car id %d.",vehicleid);
	return 1;
}
CMD:lt(playerid,params[])
{
	new Float:cDistance = 2.0;
	if(pData[playerid][pAdmin] < 1)
	{
	    return PermissionError(playerid);
	}
	if(!IsNull(params))
    {
        cDistance = floatstr(params);
    }
    new Float:cPos[4];
    GetPlayerPos(playerid,cPos[0],cPos[1],cPos[2]);
    GetPlayerFacingAngle(playerid,cPos[3]);
    GetXYLeftOfPoint(cPos[0],cPos[1],cPos[0],cPos[1],cPos[3],cDistance);
    SetPlayerPos(playerid,cPos[0],cPos[1],cPos[2]);
	return 1;
}
CMD:rt(playerid,params[])
{
    new Float:cDistance = 2.0;
	if(pData[playerid][pAdmin] < 1)
	{
	    return PermissionError(playerid);
	}
    if(!IsNull(params))
    {
        cDistance = floatstr(params);
    }
    new Float:cPos[4];
    GetPlayerPos(playerid,cPos[0],cPos[1],cPos[2]);
    GetPlayerFacingAngle(playerid,cPos[3]);
    GetXYRightOfPoint(cPos[0],cPos[1],cPos[0],cPos[1],cPos[3],cDistance);
    SetPlayerPos(playerid,cPos[0],cPos[1],cPos[2]);
	return 1;
}
CMD:ft(playerid,params[])
{
    new Float:cDistance = 2.0;
	if(pData[playerid][pAdmin] < 1)
	{
	    return PermissionError(playerid);
	}
    if(!IsNull(params))
    {
        cDistance = floatstr(params);
    }
    new Float:cPos[4];
    GetPlayerPos(playerid,cPos[0],cPos[1],cPos[2]);
    GetPlayerFacingAngle(playerid,cPos[3]);
    GetXYInFrontOfPoint11(cPos[0],cPos[1],cPos[0],cPos[1],cPos[3],cDistance);
    SetPlayerPos(playerid,cPos[0],cPos[1],cPos[2]);
	return 1;
}
CMD:bt(playerid,params[])
{
    new Float:cDistance = 2.0;
	if(pData[playerid][pAdmin] < 1)
	{
	    return PermissionError(playerid);
	}
    if(!IsNull(params))
    {
        cDistance = floatstr(params);
    }
    new Float:cPos[4];
    GetPlayerPos(playerid,cPos[0],cPos[1],cPos[2]);
    GetPlayerFacingAngle(playerid,cPos[3]);
    GetXYBehindPoint11(cPos[0],cPos[1],cPos[0],cPos[1],cPos[3],cDistance);
    SetPlayerPos(playerid,cPos[0],cPos[1],cPos[2]);
	return 1;
}
CMD:up(playerid,params[])
{
    new Float:cDistance = 2.0;
	if(pData[playerid][pAdmin] < 1)
	{
	    return PermissionError(playerid);
	}
    if(!IsNull(params))
    {
        cDistance = floatstr(params);
    }
    new Float:cPos[3];
    GetPlayerPos(playerid,cPos[0],cPos[1],cPos[2]);
    SetPlayerPos(playerid,cPos[0],cPos[1],(cPos[2]+cDistance));
	return 1;
}
CMD:dn(playerid,params[])
{
    new Float:cDistance = 2.0;
	if(pData[playerid][pAdmin] < 1)
	{
	    return PermissionError(playerid);
	}
    if(!IsNull(params))
    {
        cDistance = floatstr(params);
    }
    new Float:cPos[3];
    GetPlayerPos(playerid,cPos[0],cPos[1],cPos[2]);
    SetPlayerPos(playerid,cPos[0],cPos[1],(cPos[2]-cDistance));
	return 1;
}
CMD:mark(playerid,params[])
{
	new Float:cPos[4],string[128];
	if(pData[playerid][pAdmin] < 2)
	{
	    return SEM(playerid, "You don't have the privilege to use this command!");
	}
	if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
	{
	    new vehid = GetPlayerVehicleID(playerid);
	    GetVehiclePos(vehid,cPos[0],cPos[1],cPos[2]);
		GetVehicleZAngle(vehid,cPos[3]);
	}
	else
	{
		GetPlayerPos(playerid,cPos[0],cPos[1],cPos[2]);
		GetPlayerFacingAngle(playerid,cPos[3]);
	}
	format(string,sizeof(string),"%.2f,%.2f,%.2f,%.2f",cPos[0],cPos[1],cPos[2],cPos[3]);
	if(IsNull(params))
	{
	    SetPVarString(playerid,"Mark",string);
	    SendClientMessage(playerid,COLOR_RIKO,"MARKER: {FFFFFF}Location marked!");
	}
	else
	{
	    new markerid = strval(string);
	    if(10 >= markerid > 0)
	    {
	        new var[16];
	        format(var,16,"Mark_%d",markerid);
	        SetPVarString(playerid,"MarkedPos",string);
	        format(string,sizeof(string),"MARKER: {FFFFFF}Location {FFFF00}slot %d {FFFFFF}marked!",markerid);
	    	SendClientMessage(playerid,COLOR_RIKO,string);
	    }
	    else SEM(playerid,"ERROR: Markerid cannot go under 1 or over 10!");
	}
	return 1;
}
CMD:gotomark(playerid,params[])
{
    new Float:cPos[4],string[128];
	if(pData[playerid][pAdmin] < 2)
	{
	    return SEM(playerid, "You don't have the privilege to use this command!");
	}
	if(IsNull(params))
	{
	    if(GetPVarType(playerid,"Mark") > 0)
	    {
		    GetPVarString(playerid,"Mark",string,sizeof(string));
		    unformat(string,"e<p<,>ffff>",cPos);
		    Streamer_UpdateEx(playerid,cPos[0],cPos[1],cPos[2]);
		    if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
		    {
		        new vehid = GetPlayerVehicleID(playerid);
		        SetVehiclePos(vehid,cPos[0],cPos[1],cPos[2]);
		        SetVehicleZAngle(vehid,cPos[3]);
		    }
		    else
		    {
		    	SetPlayerPos(playerid,cPos[0],cPos[1],cPos[2]);
		    	SetPlayerFacingAngle(playerid,cPos[3]);
		    	SetCameraBehindPlayer(playerid);
			}
		    SendClientMessage(playerid,COLOR_RIKO,"MARKER: {FFFFFF}Teleported to marker!");
		}
		else SEM(playerid,"ERROR: {FFFFFF}You have no marked location!");
	}
	else
	{
	    new markerid = strval(string);
	    if(10 >= markerid > 0)
	    {
	        new var[16];
	        format(var,16,"Mark_%d",markerid);
	        if(GetPVarType(playerid,var) > 0)
	        {
		        GetPVarString(playerid,var,string,64);
			    unformat(string,"e<p<,>ffff>",cPos);
			    Streamer_UpdateEx(playerid,cPos[0],cPos[1],cPos[2]);
			    if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
			    {
			        new vehid = GetPlayerVehicleID(playerid);
			        SetVehiclePos(vehid,cPos[0],cPos[1],cPos[2]);
			        SetVehicleZAngle(vehid,cPos[3]);
			    }
			    else
			    {
			    	SetPlayerPos(playerid,cPos[0],cPos[1],cPos[2]);
			    	SetPlayerFacingAngle(playerid,cPos[3]);
			    	SetCameraBehindPlayer(playerid);
				}
			    format(string,sizeof(string),"MARKER: {FFFFFF}Teleported to markerid {FFFF00}slot %d",markerid);
			    SendClientMessage(playerid,COLOR_RIKO,string);
			}
			else SEM(playerid,"ERROR: You have no marked location!");
	    }
	    else SEM(playerid,"ERROR: Markerid cannot go under 1 or over 10!");
	}
	return 1;
}
CMD:gotosapd(playerid,params[])
{
	if(pData[playerid][pAdmin] < 1)
	if(pData[playerid][pHelper] < 1)
	{
	    return PermissionError(playerid);
	}
	if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER) SetVehiclePos(GetPlayerVehicleID(playerid),1529.6,-1691.2,13.3);
    else SetPlayerPos(playerid,1529.6,-1691.2,13.3);
	SendClientMessage(playerid,COLOR_RIKO,"TELEPORT: {FFFFFF}You have been teleported!");
	return 1;
}
CMD:gotosf(playerid,params[])
{
	if(pData[playerid][pAdmin] < 1)
	if(pData[playerid][pHelper] < 1)
	{
	    return PermissionError(playerid);
	}
	if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER) SetVehiclePos(GetPlayerVehicleID(playerid), -2015.261108, 154.379516, 27.687500);
    else SetPlayerPos(playerid, -2015.261108, 154.379516, 27.687500);
	SendClientMessage(playerid,COLOR_RIKO,"TELEPORT: {FFFFFF}You have been teleported!");
	return 1;
}
CMD:gotolv(playerid,params[])
{
	if(pData[playerid][pAdmin] < 1)
	if(pData[playerid][pHelper] < 1)
	{
	    return PermissionError(playerid);
	}
	if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER) SetVehiclePos(GetPlayerVehicleID(playerid), 1699.2,1435.1, 10.7);
    else SetPlayerPos(playerid, 1699.2,1435.1, 10.7);
	SendClientMessage(playerid,COLOR_RIKO,"TELEPORT: {FFFFFF}You have been teleported!");
	return 1;
}
CMD:gotohq(playerid,params[])
{
	if(pData[playerid][pAdmin] < 1)
	if(pData[playerid][pHelper] < 1)
	{
	    return PermissionError(playerid);
	}
	if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER) SetVehiclePos(GetPlayerVehicleID(playerid), 216.2500, 1822.8402, 6.4141);
    else SetPlayerPos(playerid, 216.2500, 1822.8402, 6.4141);
	SendClientMessage(playerid,COLOR_RIKO,"TELEPORT: {FFFFFF}You have been teleported!");
	return 1;
}
CMD:gotoflint(playerid,params[])
{
	if(pData[playerid][pAdmin] < 1)
	if(pData[playerid][pHelper] < 1)
	{
	    return PermissionError(playerid);
	}
	if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER) SetVehiclePos(GetPlayerVehicleID(playerid), -105.5101, -1168.4785, 2.8906);
    else SetPlayerPos(playerid, -105.5101, -1168.4785, 2.8906);
	SendClientMessage(playerid,COLOR_RIKO,"TELEPORT: {FFFFFF}You have been teleported!");
	return 1;
}
CMD:setvw(playerid,params[])
{
    if(pData[playerid][pAdmin] < 1)
        return PermissionError(playerid);

	new otherid,world;
	if (sscanf(params,"ud",otherid,world))
	    return Usage(playerid,"/setvw [playerid/name] [world id]");

	SetPlayerVirtualWorld(otherid, world);
	pData[otherid][pWorld] = world;
	Info(playerid,"You've set virtual world %d to player %s.",world,pData[otherid][pName]);
	Info(otherid,"Administrator %s has set your virtual world to %d.",pData[playerid][pAdminname],world);
	return 1;
}
CMD:setint(playerid,params[])
{
    if(pData[playerid][pAdmin] < 1)
        return PermissionError(playerid);

	new otherid,interior;
	if (sscanf(params,"ud",otherid,interior))
	    return Usage(playerid,"/setint [playerid/name] [interior id]");

    SetPlayerInterior(otherid, interior);
    pData[otherid][pInt] = interior;
	Info(playerid,"You've set interior %d to player %s.",interior,pData[otherid][pName]);
	Info(otherid,"Administrator %s has set your interior to %d.",pData[playerid][pAdminname],interior);
	return 1;
}
CMD:sound(playerid, params[])
{
	if(pData[playerid][pAdmin] < 6)
        return PermissionError(playerid);

	extract params -> new soundid; else return Info(playerid, "/sound [sound id]");

	PlayerPlaySound(playerid, soundid, 0.0, 0.0, 0.0);
	new String[1280];
	format(String, sizeof String, "Now playing sound ID %d", soundid);
	Info(playerid, "SOUND", String);
	return 1;
}
CMD:gotobank(playerid,params[])
{
	if(pData[playerid][pAdmin] < 1)
	if(pData[playerid][pHelper] < 1)
	{
		return PermissionError(playerid);
	}
	if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER) SetVehiclePos(GetPlayerVehicleID(playerid), 1457.5571, -1040.2914, 23.8281);
	else SetPlayerPos(playerid, 1457.5571, -1040.2914, 23.8281);
	SendClientMessage(playerid, COLOR_LBLUE, "TELEPORT: {FFFFFF}You have been teleported!");
	return 1;
}
CMD:gotosamd(playerid,params[])
{
	if(pData[playerid][pAdmin] < 1)
	if(pData[playerid][pHelper] < 1)
	{
		return PermissionError(playerid);
	}
	if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER) SetVehiclePos(GetPlayerVehicleID(playerid), 1212.5688,-1328.3711,13.5602);
	else SetPlayerPos(playerid, 1212.5688,-1328.3711,13.5602);
	SendClientMessage(playerid, COLOR_LBLUE, "TELEPORT: {FFFFFF}You have been teleported!");
	return 1;
}
CMD:setskillweapon(playerid)
{
	if(pData[playerid][pAdmin] >= 6)
	{
		SetPlayerSkillLevel(playerid, WEAPON_COLT45, 999);
		SetPlayerSkillLevel(playerid, WEAPON_SILENCED, 999);
		SetPlayerSkillLevel(playerid, WEAPON_DEAGLE, 999);
		SetPlayerSkillLevel(playerid, WEAPON_SHOTGUN, 999);
		SetPlayerSkillLevel(playerid, WEAPON_SAWEDOFF, 999);
		SetPlayerSkillLevel(playerid, WEAPON_SHOTGSPA, 999);
		SetPlayerSkillLevel(playerid, WEAPON_UZI, 999);
		SetPlayerSkillLevel(playerid, WEAPON_MP5, 999);
		SetPlayerSkillLevel(playerid, WEAPON_AK47, 999);
		SetPlayerSkillLevel(playerid, WEAPON_M4, 999);
		SetPlayerSkillLevel(playerid, WEAPON_TEC9, 999);
		SetPlayerSkillLevel(playerid, WEAPON_RIFLE, 999);
		SetPlayerSkillLevel(playerid, WEAPON_SNIPER, 999);
	}
	return 1;
}
CMD:gmx(playerid, params[])
{
		new String[256];
        if(pData[playerid][pAdmin] >= 6)
	    {
	    	if(CurGMX == 0)
	    	{
	    		format(String, sizeof(String), "GMX:"RED_E" %s "WHITE_E"has initiated a server restart, it will occur in the next "YELLOW_E"30 seconds.", pData[playerid][pAdminname]);
				SendClientMessageToAll(COLOR_RIKO, String);
				SetTimer("DoGMX", 30000, false);
				CurGMX = 1;
	    	}
	    	else
	    	{
	        	SendClientMessage(playerid, COLOR_PINK, "There already is a current GMX in execution.");
	    	}
	    }
		return 1;
}
