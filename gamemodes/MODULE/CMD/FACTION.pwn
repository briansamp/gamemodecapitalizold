//-----------[ Faction Commands ]------------
CMD:factionhelp(playerid)
{
	if(pData[playerid][pFaction] == 1)
	{
		new str[3500];
		strcat(str, ""BLUE_E"SAPD: /locker /or (/r)adio /od /d(epartement) (/gov)ernment (/m)egaphone /pinvite /puninvite /psetrank\n");
		strcat(str, ""WHITE_E"SAPD: /sapdonline /(un)cuff /tazer /detain /arrest /release /flare /destroyflare /revokelic /checkveh /takedl\n");
		strcat(str, ""BLUE_E"SAPD: /takemarijuana /takeweapon /takecard /spike /destroyspike /destroyallspike\n");
		strcat(str, ""WHITE_E"NOTE: Lama waktu duty anda akan menjadi gaji anda pada saat paycheck!\n");
		ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_MSGBOX, ""RED_E"SAPD", str, "Close", "");
	}
	else if(pData[playerid][pFaction] == 2)
	{
		new str[3500];
		strcat(str, ""LB_E"SAGS: /locker /or (/r)adio /od /d(epartement) (/gov)ernment (/m)egaphone /invite /uninvite /setrank\n");
		strcat(str, ""WHITE_E"SAGS: /sagsonline /takecard /(un)cuff\n");
		strcat(str, ""WHITE_E"NOTE: Lama waktu duty anda akan menjadi gaji anda pada saat paycheck!\n");
		ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_MSGBOX, ""RED_E"SAGS", str, "Close", "");
	}
	else if(pData[playerid][pFaction] == 3)
	{
		new str[3500];
		strcat(str, ""PINK_E"SAMD: /locker /or (/r)adio /od /d(epartement) (/gov)ernment (/m)egaphone /invite /uninvite /setrank\n");
		strcat(str, ""WHITE_E"SAMD: /samdonline /loadinjured /dropinjured /ems /findems /rescue /salve\n");
		strcat(str, ""WHITE_E"NOTE: Lama waktu duty anda akan menjadi gaji anda pada saat paycheck!\n");
		ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_MSGBOX, ""RED_E"SAMD", str, "Close", "");
	}
	else if(pData[playerid][pFaction] == 4)
	{
		new str[3500];
		strcat(str, ""ORANGE_E"SANA: /locker /or (/r)adio /od /d(epartement) (/gov)ernment (/m)egaphone /invite /uninvite /setrank\n");
		strcat(str, ""WHITE_E"SANA: /sanaonline /broadcast /bc /live /inviteguest /removeguest\n");
		strcat(str, ""WHITE_E"NOTE: Lama waktu duty anda akan menjadi gaji anda pada saat paycheck!\n");
		ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_MSGBOX, ""RED_E"SANA", str, "Close", "");
	}
	else if(pData[playerid][pFaction] == 5)
	{
		new str[3500];
		strcat(str, ""ORANGE_E"GOJEK: /locker /or (/r)adio (/m)egaphone /invite /uninvite /setrank\n");
		strcat(str, ""WHITE_E"GOJEK: /gojekonline /price /offer\n");
		strcat(str, ""WHITE_E"NOTE: Lama waktu duty anda akan menjadi gaji anda pada saat paycheck!\n");
		ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_MSGBOX, ""RED_E"GOJEK", str, "Close", "");
	}
	else if(pData[playerid][pFamily] != -1)
	{
		new str[3500];
		strcat(str, ""WHITE_E"Family: /fsave /f(amily) /finvite /funinvite /fsetrank\n");
		ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_MSGBOX, ""RED_E"Family", str, "Close", "");
	}
	else
	{
		Error(playerid, "Anda tidak bergabung dalam faction/family manapun!");
	}
	return 1;
}

CMD:faction(playerid, params[])
{
	new duty[16], lstr[1024];
	format(lstr, sizeof(lstr), "Name\tRank\tStatus\tDuty Time\n");
	foreach(new i: Player)
	{
		if(pData[i][pFaction] == 1)
		{
			switch(pData[i][pOnDuty])
			{
				case 0:
				{
					duty = "Off Duty";
				}
				case 1:
				{
					duty = ""BLUE_E"On Duty";
				}
			}
			format(lstr, sizeof(lstr), "%s%s(%d)\t%s(%d)\t%s", lstr, pData[i][pName], i, GetFactionRank(i), pData[i][pFactionRank], duty);
			format(lstr, sizeof(lstr), "%s\n", lstr);
		}
		else if(pData[i][pFaction] == 2)
		{
			switch(pData[i][pOnDuty])
			{
				case 0:
				{
					duty = "Off Duty";
				}
				case 1:
				{
					duty = ""BLUE_E"On Duty";
				}
			}
			format(lstr, sizeof(lstr), "%s%s(%d)\t%s(%d)\t%s", lstr, pData[i][pName], i, GetFactionRank(i), pData[i][pFactionRank], duty);
			format(lstr, sizeof(lstr), "%s\n", lstr);
		}
		else if(pData[i][pFaction] == 3)
		{
			switch(pData[i][pOnDuty])
			{
				case 0:
				{
					duty = "Off Duty";
				}
				case 1:
				{
					duty = ""BLUE_E"On Duty";
				}
			}
			format(lstr, sizeof(lstr), "%s%s(%d)\t%s(%d)\t%s", lstr, pData[i][pName], i, GetFactionRank(i), pData[i][pFactionRank], duty);
			format(lstr, sizeof(lstr), "%s\n", lstr);
		}
		else if(pData[i][pFaction] == 4)
		{
			switch(pData[i][pOnDuty])
			{
				case 0:
				{
					duty = "Off Duty";
				}
				case 1:
				{
					duty = ""BLUE_E"On Duty";
				}
			}
			format(lstr, sizeof(lstr), "%s%s(%d)\t%s(%d)\t%s", lstr, pData[i][pName], i, GetFactionRank(i), pData[i][pFactionRank], duty);
			format(lstr, sizeof(lstr), "%s\n", lstr);
		}
		else if(pData[i][pFaction] == 5)
		{
			switch(pData[i][pOnDuty])
			{
				case 0:
				{
					duty = "Off Duty";
				}
				case 1:
				{
					duty = ""BLUE_E"On Duty";
				}
			}
			format(lstr, sizeof(lstr), "%s%s(%d)\t%s(%d)\t%s", lstr, pData[i][pName], i, GetFactionRank(i), pData[i][pFactionRank], duty);
			format(lstr, sizeof(lstr), "%s\n", lstr);
		}
	}
	format(lstr, sizeof(lstr), "%s\n", lstr);
	ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_TABLIST_HEADERS, "Faction Online", lstr, "Close", "");

	return 1;
}

CMD:or(playerid, params[])
{
    new text[128];
    
    if(pData[playerid][pFaction] == 0)
        return Error(playerid, "You must in faction member to use this command");

    if(pData[playerid][pInjured] != 0)
		return Error(playerid, "You cant do that in this time.");
            
    if(sscanf(params,"s[128]",text))
        return Usage(playerid, "/or(OOC radio) [text]");

    if(strval(text) > 128)
        return Error(playerid,"Text too long.");

    if(pData[playerid][pFaction] == 1) {
        SendFactionMessage(1, COLOR_RADIO, "* (( %s: %s ))", pData[playerid][pName], text);
		//format(mstr, sizeof(mstr), "[<RADIO>]\n* %s *", text);
		//SetPlayerChatBubble(playerid, mstr, COLOR_RADIO, 10.0, 3000);
    }
    else if(pData[playerid][pFaction] == 2) {
        SendFactionMessage(2, COLOR_RADIO, "* (( %s: %s ))", pData[playerid][pName], text);
		//format(mstr, sizeof(mstr), "[<RADIO>]\n* %s *", text);
		//SetPlayerChatBubble(playerid, mstr, COLOR_RADIO, 10.0, 3000);
    }
    else if(pData[playerid][pFaction] == 3) {
        SendFactionMessage(3, COLOR_RADIO, "* (( %s: %s ))", pData[playerid][pName], text);
		//format(mstr, sizeof(mstr), "[<RADIO>]\n* %s *", text);
		//SetPlayerChatBubble(playerid, mstr, COLOR_RADIO, 10.0, 3000);
    }
    else if(pData[playerid][pFaction] == 4) {
        SendFactionMessage(4, COLOR_RADIO, "* (( %s: %s ))", pData[playerid][pName], text);
		//format(mstr, sizeof(mstr), "[<RADIO>]\n* %s *", text);
		//SetPlayerChatBubble(playerid, mstr, COLOR_RADIO, 10.0, 3000);
    }
	else if(pData[playerid][pFaction] == 5) {
        SendFactionMessage(5, COLOR_RADIO, "* (( %s: %s ))", pData[playerid][pName], text);
		//format(mstr, sizeof(mstr), "[<RADIO>]\n* %s *", text);
		//SetPlayerChatBubble(playerid, mstr, COLOR_RADIO, 10.0, 3000);
    }
    else
            return Error(playerid, "You are'nt in any faction");
    return 1;
}

CMD:r(playerid, params[])
{
    new text[128], mstr[512];
    
    if(pData[playerid][pFaction] == 0)
        return Error(playerid, "You must in faction member to use this command");

    if(pData[playerid][pInjured] != 0)
		return Error(playerid, "You cant do that in this time.");
            
    if(sscanf(params,"s[128]",text))
        return Usage(playerid, "/r(adio) [text]");

    if(strval(text) > 128)
        return Error(playerid,"Text too long.");

    if(pData[playerid][pFaction] == 1) {
        SendFactionMessage(1, COLOR_RADIO, "** [SAPD Radio] %s [%d] [%s] %s: %s", GetFactionRank(playerid), pData[playerid][pFactionRank], GetFactionDivisi(playerid), pData[playerid][pName], text);
		format(mstr, sizeof(mstr), "[<RADIO>]\n* %s *", text);
		SetPlayerChatBubble(playerid, mstr, COLOR_RADIO, 10.0, 3000);
    }
    else if(pData[playerid][pFaction] == 2) {
        SendFactionMessage(2, COLOR_RADIO, "** [SAGS Radio] %s(%d) %s: %s", GetFactionRank(playerid),  pData[playerid][pFactionRank], pData[playerid][pName], text);
		format(mstr, sizeof(mstr), "[<RADIO>]\n* %s *", text);
		SetPlayerChatBubble(playerid, mstr, COLOR_RADIO, 10.0, 3000);
    }
    else if(pData[playerid][pFaction] == 3) {
        SendFactionMessage(3, COLOR_RADIO, "** [SAMD Radio] %s(%d) %s: %s", GetFactionRank(playerid),  pData[playerid][pFactionRank], pData[playerid][pName], text);
		format(mstr, sizeof(mstr), "[<RADIO>]\n* %s *", text);
		SetPlayerChatBubble(playerid, mstr, COLOR_RADIO, 10.0, 3000);
    }
    else if(pData[playerid][pFaction] == 4) {
        SendFactionMessage(4, COLOR_RADIO, "** [SANA Radio] %s(%d) %s: %s", GetFactionRank(playerid),  pData[playerid][pFactionRank], pData[playerid][pName], text);
		format(mstr, sizeof(mstr), "[<RADIO>]\n* %s *", text);
		SetPlayerChatBubble(playerid, mstr, COLOR_RADIO, 10.0, 3000);
    }
	else if(pData[playerid][pFaction] == 5) {
        SendFactionMessage(5, COLOR_RADIO, "** [GOJEK Radio] %s(%d) %s: %s", GetFactionRank(playerid),  pData[playerid][pFactionRank], pData[playerid][pName], text);
		format(mstr, sizeof(mstr), "[<RADIO>]\n* %s *", text);
		SetPlayerChatBubble(playerid, mstr, COLOR_RADIO, 10.0, 3000);
    }
    else
            return Error(playerid, "You are'nt in any faction");
    return 1;
}

CMD:od(playerid, params[])
{
    new text[128];
    
    if(pData[playerid][pFaction] == 0)
        return Error(playerid, "You must in faction member to use this command");

    if(pData[playerid][pInjured] != 0)
		return Error(playerid, "You cant do that in this time.");
            
    if(sscanf(params,"s[128]",text))
        return Usage(playerid, "/od(OOC departement) [text]");

    if(strval(text) > 128)
        return Error(playerid,"Text too long.");
	
	for(new fid = 1; fid < 5; fid++)
	{
		if(pData[playerid][pFaction] == 1) {
			SendFactionMessage(fid, 0xFFD7004A, "** (( %s: %s ))", pData[playerid][pName], text);
			//format(mstr, sizeof(mstr), "[<DEPARTEMENT>]\n* %s *", text);
			//SetPlayerChatBubble(playerid, mstr, 0xFFD7004A, 10.0, 3000);
		}
		else if(pData[playerid][pFaction] == 2) {
			SendFactionMessage(fid, 0xFFD7004A, "** (( %s: %s ))", pData[playerid][pName], text);
			//format(mstr, sizeof(mstr), "[<DEPARTEMENT>]\n* %s *", text);
			//SetPlayerChatBubble(playerid, mstr, 0xFFD7004A, 10.0, 3000);
		}
		else if(pData[playerid][pFaction] == 3) {
			SendFactionMessage(fid, 0xFFD7004A, "** (( %s: %s ))", pData[playerid][pName], text);
			//format(mstr, sizeof(mstr), "[<DEPARTEMENT>]\n* %s *", text);
			//SetPlayerChatBubble(playerid, mstr, 0xFFD7004A, 10.0, 3000);
		}
		else if(pData[playerid][pFaction] == 4) {
			SendFactionMessage(fid, 0xFFD7004A, "** (( %s: %s ))", pData[playerid][pName], text);
			//format(mstr, sizeof(mstr), "[<DEPARTEMENT>]\n* %s *", text);
			//SetPlayerChatBubble(playerid, mstr, 0xFFD7004A, 10.0, 3000);
		}
		else
				return Error(playerid, "You are'nt in any faction");
	}
    return 1;
}

CMD:d(playerid, params[])
{
    new text[128], mstr[512];
    
    if(pData[playerid][pFaction] == 0)
        return Error(playerid, "You must in faction member to use this command");

    if(pData[playerid][pInjured] != 0)
		return Error(playerid, "You cant do that in this time.");
            
    if(sscanf(params,"s[128]",text))
        return Usage(playerid, "/d(epartement) [text]");

    if(strval(text) > 128)
        return Error(playerid,"Text too long.");
	
	for(new fid = 1; fid < 5; fid++)
	{
		if(pData[playerid][pFaction] == 1) 
		{
			SendFactionMessage(fid, 0xFFD7004A, "** [SAPD Departement] %s [%d] [%s] %s: %s", GetFactionRank(playerid), pData[playerid][pFactionRank],  GetFactionDivisi(playerid), pData[playerid][pName], text);
			format(mstr, sizeof(mstr), "[<DEPARTEMENT>]\n* %s *", text);
			SetPlayerChatBubble(playerid, mstr, 0xFFD7004A, 10.0, 3000);
		}
		else if(pData[playerid][pFaction] == 2) 
		{
			SendFactionMessage(fid, 0xFFD7004A, "** [SAGS Departement] %s(%d) %s: %s", GetFactionRank(playerid),  pData[playerid][pFactionRank], pData[playerid][pName], text);
			format(mstr, sizeof(mstr), "[<DEPARTEMENT>]\n* %s *", text);
			SetPlayerChatBubble(playerid, mstr, 0xFFD7004A, 10.0, 3000);
		}
		else if(pData[playerid][pFaction] == 3) 
		{
			SendFactionMessage(fid, 0xFFD7004A, "** [SAMD Departement] %s(%d) %s: %s", GetFactionRank(playerid),  pData[playerid][pFactionRank], pData[playerid][pName], text);
			format(mstr, sizeof(mstr), "[<DEPARTEMENT>]\n* %s *", text);
			SetPlayerChatBubble(playerid, mstr, 0xFFD7004A, 10.0, 3000);
		}
		else if(pData[playerid][pFaction] == 4) 
		{
			SendFactionMessage(fid, 0xFFD7004A, "** [SANA Departement] %s(%d) %s: %s", GetFactionRank(playerid),  pData[playerid][pFactionRank], pData[playerid][pName], text);
			format(mstr, sizeof(mstr), "[<DEPARTEMENT>]\n* %s *", text);
			SetPlayerChatBubble(playerid, mstr, 0xFFD7004A, 10.0, 3000);
		}
		else
				return Error(playerid, "You are'nt in any faction");
	}
    return 1;
}

CMD:m(playerid, params[])
{
	new facname[16];
	if(pData[playerid][pFaction] <= 0)
		return Error(playerid, "You are not faction!");
		
	if(isnull(params)) return Usage(playerid, "/m(egaphone) [text]");
	
	if(pData[playerid][pFaction] == 1)
	{
		facname = "SAPD";
	}
	else if(pData[playerid][pFaction] == 2)
	{
		facname = "SAGS";
	}
	else if(pData[playerid][pFaction] == 3)
	{
		facname = "SAMD";
	}
	else if(pData[playerid][pFaction] == 4)
	{
		facname = "SANA";
	}
	else if(pData[playerid][pFaction] == 5)
	{
		facname = "GOJEK";
	}
	else
	{
		facname ="Unknown";
	}
	
	if(strlen(params) > 64) {
        SendNearbyMessage(playerid, 60.0, COLOR_YELLOW, "[%s Megaphone] %s says: %.64s", facname, ReturnName(playerid), params);
        SendNearbyMessage(playerid, 60.0, COLOR_YELLOW, "...%s", params[64]);
    }
    else {
        SendNearbyMessage(playerid, 60.0, COLOR_YELLOW, "[%s Megaphone] %s says: %s", facname, ReturnName(playerid), params);
    }
	return 1;
}

CMD:gov(playerid, params[])
{
	if(pData[playerid][pFaction] <= 0)
		return Error(playerid, "You are not faction!");
	
	if(pData[playerid][pFactionRank] < 5)
		return Error(playerid, "Only faction level 5-6");
		
	if(pData[playerid][pFaction] == 1)
	{
		new lstr[1024];
		format(lstr, sizeof(lstr), "** SAPD: %s(%d) %s: %s **", GetFactionRank(playerid), pData[playerid][pFactionRank], pData[playerid][pName], params);
		SendClientMessageToAll(COLOR_PINK, "|___________ Government News Announcement ___________|");
		SendClientMessageToAll(COLOR_BLUE, lstr);
	}
	else if(pData[playerid][pFaction] == 2)
	{
		new lstr[1024];
		format(lstr, sizeof(lstr), "** SAGS: %s(%d) %s: %s **", GetFactionRank(playerid), pData[playerid][pFactionRank], pData[playerid][pName], params);
		SendClientMessageToAll(COLOR_PINK, "|___________ Government News Announcement ___________|");
		SendClientMessageToAll(COLOR_LBLUE, lstr);
	}
	else if(pData[playerid][pFaction] == 3)
	{
		new lstr[1024];
		format(lstr, sizeof(lstr), "** SAMD: %s(%d) %s: %s **", GetFactionRank(playerid), pData[playerid][pFactionRank], pData[playerid][pName], params);
		SendClientMessageToAll(COLOR_PINK, "|___________ Government News Announcement ___________|");
		SendClientMessageToAll(COLOR_PINK2, lstr);
	}
	else if(pData[playerid][pFaction] == 4)
	{
		new lstr[1024];
		format(lstr, sizeof(lstr), "** SANA: %s(%d) %s: %s **", GetFactionRank(playerid), pData[playerid][pFactionRank], pData[playerid][pName], params);
		SendClientMessageToAll(COLOR_PINK, "|___________ Government News Announcement ___________|");
		SendClientMessageToAll(COLOR_ORANGE2, lstr);
	}
	return 1;
}
CMD:siren2(playerid, params[])
{
	if(pData[playerid][pFaction] != 1)
        return Error(playerid, "You must be a police officer.");
	if(pData[playerid][pFactionRank] < 1)
		return Error(playerid, "You must be high rank!");

	new vehicleid = GetPlayerVehicleID(playerid);

	if (!IsPlayerInAnyVehicle(playerid))
	    return Error(playerid, "You must be inside a vehicle.");

	switch (pvData[vehicleid][vehSirenOn])
	{
	    case 0:
	    {
			static
        		Float:fSize[3],
        		Float:fSeat[3];

		    GetVehicleModelInfo(GetVehicleModel(vehicleid), VEHICLE_MODEL_INFO_SIZE, fSize[0], fSize[1], fSize[2]); // need height (z)
    		GetVehicleModelInfo(GetVehicleModel(vehicleid), VEHICLE_MODEL_INFO_FRONTSEAT, fSeat[0], fSeat[1], fSeat[2]); // need pos (x, y)

            pvData[vehicleid][vehSirenOn] = 1;
			pvData[vehicleid][vehSirenObject] = CreateDynamicObject(18646, 0.0, 0.0, 1000.0, 0.0, 0.0, 0.0);

		    AttachDynamicObjectToVehicle(pvData[vehicleid][vehSirenObject], vehicleid, -fSeat[0], fSeat[1], fSize[2] / 2.0, 0.0, 0.0, 0.0);
			SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s attaches a portable siren to the vehicle.", ReturnName(playerid));
		}
		case 1:
		{
		    pvData[vehicleid][vehSirenOn] = 0;

			DestroyDynamicObject(pvData[vehicleid][vehSirenObject]);
			SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s detaches a portable siren from the vehicle.", ReturnName(playerid));
		}
	}
	return 1;
}
CMD:setdivisi(playerid, params[])
{
	new divisi, otherid;
	if(pData[playerid][pFaction] != 1)
		return Error(playerid, "Kamu harus di SAPD.");
	if(pData[playerid][pFactionRank] < 10)
		return Error(playerid, "You must be 10 rank sapd or high!");

	if(sscanf(params, "ud", otherid, divisi))
        return Usage(playerid, "/setdivisi [playerid/PartOfName] [1.CI 2.SWAT 3.ASV]");

	if(otherid == INVALID_PLAYER_ID)
		return Error(playerid, "Invalid ID.");

	if(pData[otherid][pFaction] != pData[playerid][pFaction])
		return Error(playerid, "This player is not in your devision!");

	if(divisi < 1 || divisi > 3)
		return Error(playerid, "rank must 1 - 3 only");

	pData[otherid][pDivisi] = divisi;
	Servers(playerid, "You has set %s faction divisi to %d", pData[otherid][pName], divisi);
	Servers(otherid, "%s has set your faction divisi to %d", pData[playerid][pName], divisi);
	return 1;
}
CMD:setrank(playerid, params[])
{
	new rank, otherid;
	if(pData[playerid][pFaction] == 1)
		return Error(playerid, "Kamu tidak bisa melakukan ini.");

	if(pData[playerid][pFactionRank] < 5)
		return Error(playerid, "You must faction level 5 - 6!");

	if(sscanf(params, "ud", otherid, rank))
        return Usage(playerid, "/setrank [playerid/PartOfName] [rank 1-6]");

	if(otherid == INVALID_PLAYER_ID)
		return Error(playerid, "Invalid ID.");

	if(otherid == playerid)
		return Error(playerid, "Invalid ID.");

	if(pData[otherid][pFaction] != pData[playerid][pFaction])
		return Error(playerid, "This player is not in your devision!");

	if(rank < 1 || rank > 6)
		return Error(playerid, "rank must 1 - 6 only");

	pData[otherid][pFactionRank] = rank;
	Servers(playerid, "You has set %s faction rank to level %d", pData[otherid][pName], rank);
	Servers(otherid, "%s has set your faction rank to level %d", pData[playerid][pName], rank);
	return 1;
}

CMD:uninvite(playerid, params[])
{
	if(pData[playerid][pFaction] <= 0)
		return Error(playerid, "You are not faction!");

	if(pData[playerid][pFaction] == 1)
        return Error(playerid, "Kamu tidak bisa melakukan ini.");
		
	if(pData[playerid][pFactionRank] < 5)
		return Error(playerid, "You must faction level 5 - 6!");
	
	if(!pData[playerid][pOnDuty])
        return Error(playerid, "You must on duty!.");
	new otherid;
    if(sscanf(params, "u", otherid))
        return Usage(playerid, "/uninvite [playerid/PartOfName]");
		
	if(!IsPlayerConnected(otherid))
		return Error(playerid, "Invalid ID.");
	
	if(otherid == playerid)
		return Error(playerid, "Invalid ID.");
	
	if(pData[otherid][pFactionRank] > pData[playerid][pFactionRank])
		return Error(playerid, "You cant kick him.");
		
	pData[otherid][pFactionRank] = 0;
	pData[otherid][pFaction] = 0;
	Servers(playerid, "Anda telah mengeluarkan %s dari faction.", pData[otherid][pName]);
	Servers(otherid, "%s telah mengkick anda dari faction.", pData[playerid][pName]);
	return 1;
}

CMD:invite(playerid, params[])
{
	if(pData[playerid][pFaction] <= 0)
		return Error(playerid, "You are not faction!");

	if(pData[playerid][pFaction] == 1)
        return Error(playerid, "Kamu tidak bisa melakukan ini.");
		
	if(pData[playerid][pFactionRank] < 5)
		return Error(playerid, "You must faction level 5 - 6!");
	
	if(!pData[playerid][pOnDuty])
        return Error(playerid, "You must on duty!.");
	new otherid;
    if(sscanf(params, "u", otherid))
        return Usage(playerid, "/invite [playerid/PartOfName]");
		
	if(!IsPlayerConnected(otherid))
		return Error(playerid, "Invalid ID.");
	
	if(otherid == playerid)
		return Error(playerid, "Invalid ID.");
	
	if(!NearPlayer(playerid, otherid, 5.0))
        return Error(playerid, "You must be near this player.");
	
	if(pData[otherid][pFamily] != -1)
		return Error(playerid, "Player tersebut sudah bergabung family");
		
	if(pData[otherid][pFaction] != 0)
		return Error(playerid, "Player tersebut sudah bergabung faction!");
		
	pData[otherid][pFacInvite] = pData[playerid][pFaction];
	pData[otherid][pFacOffer] = playerid;
	Servers(playerid, "Anda telah menginvite %s untuk menjadi faction.", pData[otherid][pName]);
	Servers(otherid, "%s telah menginvite anda untuk menjadi faction. Type: /accept faction or /deny faction!", pData[playerid][pName]);
	return 1;
}

CMD:getloc(playerid, params[])
{
	if(pData[playerid][pFaction] != 1)
		return Error(playerid, "Kamu harus menjadi police officer.");

	new otherid;
	if(sscanf(params, "u", otherid))
	{
	    Usage(playerid, "/getloc <ID/Name>");
	    return true;
	}
	
    if(otherid == INVALID_PLAYER_ID)
        return Error(playerid, "Player tersebut belum masuk!");

   	if(pData[otherid][pFaction] != 1)
		return Error(playerid, "Orang Tersebut bukan bagian dari police departement.");

	if(otherid == playerid)
		return Error(playerid, "You cant getloc yourself!");

	if(pData[otherid][pPhone] == 0) return Error(playerid, "Player tersebut belum memiliki Ponsel");

    new zone[MAX_ZONE_NAME];
	GetPlayer3DZone(otherid, zone, sizeof(zone));
	new Float:sX, Float:sY, Float:sZ;
	GetPlayerPos(otherid, sX, sY, sZ);
	SetPlayerCheckpoint(playerid, sX, sY, sZ, 5.0);
	pData[playerid][pSuspectTimer] = 25;
	Info(playerid, "Target Nama : %s", pData[otherid][pName]);
	Info(playerid, "Divisi : %s", GetFactionDivisi(otherid));
	Info(playerid, "Rank : %s", GetFactionRank(otherid));
	Info(playerid, "Lokasi : %s", zone);
	Info(playerid, "Nomer Telepon : %d", pData[otherid][pPhone]);
	return 1;
}

CMD:locker(playerid, params[])
{
	if(pData[playerid][pFaction] < 1)
		if(pData[playerid][pVip] < 1)
			return Error(playerid, "You cant use this commands!");
		
	foreach(new lid : Lockers)
	{
		if(IsPlayerInRangeOfPoint(playerid, 2.5, lData[lid][lPosX], lData[lid][lPosY], lData[lid][lPosZ]))
		{
			if(pData[playerid][pVip] > 0 && lData[lid][lType] == 6)
			{
				ShowPlayerDialog(playerid, DIALOG_LOCKERVIP, DIALOG_STYLE_LIST, "VIP Locker", "Health\nWeapons\nClothing\nVip Toys", "Okay", "Cancel");
			}
			else if(pData[playerid][pFaction] == 1 && pData[playerid][pFaction] == lData[lid][lType])
			{
				ShowPlayerDialog(playerid, DIALOG_LOCKERSAPD, DIALOG_STYLE_LIST, "SAPD Lockers", "Toggle Duty\nHealth\nArmour\nWeapons\nClothing\nClothing War", "Proceed", "Cancel");
			}
			else if(pData[playerid][pFaction] == 2 && pData[playerid][pFaction] == lData[lid][lType])
			{
				ShowPlayerDialog(playerid, DIALOG_LOCKERSAGS, DIALOG_STYLE_LIST, "SAGS Lockers", "Toggle Duty\nHealth\nArmour\nWeapons\nClothing", "Proceed", "Cancel");
			}
			else if(pData[playerid][pFaction] == 3 && pData[playerid][pFaction] == lData[lid][lType])
			{
				ShowPlayerDialog(playerid, DIALOG_LOCKERSAMD, DIALOG_STYLE_LIST, "SAMD Lockers", "Toggle Duty\nHealth\nArmour\nWeapons\nClothing", "Proceed", "Cancel");
			}
			else if(pData[playerid][pFaction] == 4 && pData[playerid][pFaction] == lData[lid][lType])
			{
				ShowPlayerDialog(playerid, DIALOG_LOCKERSANEW, DIALOG_STYLE_LIST, "SANA Lockers", "Toggle Duty\nHealth\nArmour\nWeapons\nClothing", "Proceed", "Cancel");
			}
			else if(pData[playerid][pFaction] == 5 && pData[playerid][pFaction] == lData[lid][lType])
			{
				ShowPlayerDialog(playerid, DIALOG_LOCKERGOJEK, DIALOG_STYLE_LIST, "GOJEK Lockers", "Toggle Duty\nHealth\nArmour\nClothing", "Proceed", "Cancel");
			}
			else if(pData[playerid][pFaction] == 6 && lData[lid][lType] == 7)
			{
				ShowPlayerDialog(playerid, DIALOG_LOCKERPEDAGANG, DIALOG_STYLE_LIST, "PEDAGANG Lockers", "Toggle Duty\nHealth\nArmour\nClothing", "Proceed", "Cancel");
			}
			else return Error(playerid, "You are not in this faction type!");
		}
	}
	/*if(pData[playerid][pFaction] == 1)
	{
		if(IsPlayerInRangeOfPoint(playerid, 4.0, 1573.26, -1652.93, -40.59))
    	{
     		ShowPlayerDialog(playerid, LockerSAPD, DIALOG_STYLE_LIST, "SAPD Lockers", "Toggle Duty\nHealth\nArmour\nWeapons\nClothing\nClothing War", "Proceed", "Cancel");
     	}
 		else
   		{
     		Error(playerid, "You aren't in range in area lockers.");
			return 1;
     	}
	}
	else if(pData[playerid][pFaction] == 2)
	{
		if(IsPlayerInRangeOfPoint(playerid, 4.0, 1464.10, -1790.31, 2349.68))
    	{
     		ShowPlayerDialog(playerid, LockerSAGS, DIALOG_STYLE_LIST, "SAGS Lockers", "Toggle Duty\nHealth\nArmour\nWeapons\nClothing", "Proceed", "Cancel");
     	}
 		else
   		{
     		Error(playerid, "You aren't in range in area lockers.");
			return 1;
     	}
	}
	else if(pData[playerid][pFaction] == 3)
	{
		if(IsPlayerInRangeOfPoint(playerid, 4.0, -1100.25, 1980.02, -58.91) || IsPlayerInRangeOfPoint(playerid, 4.0, -196.35, -1748.86, 675.76))
    	{
     		ShowPlayerDialog(playerid, LockerSAMD, DIALOG_STYLE_LIST, "SAMD Lockers", "Toggle Duty\nHealth\nArmour\nWeapons\nClothing", "Proceed", "Cancel");
     	}
 		else
   		{
     		Error(playerid, "You aren't in range in area lockers.");
			return 1;
     	}
	}
	else if(pData[playerid][pFaction] == 4)
	{
		if(IsPlayerInRangeOfPoint(playerid, 4.0, 256.14, 1776.99, 701.08))
    	{
     		ShowPlayerDialog(playerid, LockerSANEW, DIALOG_STYLE_LIST, "SANEW Lockers", "Toggle Duty\nHealth\nArmour\nWeapons\nClothing", "Proceed", "Cancel");
     	}
 		else
   		{
     		Error(playerid, "You aren't in range in area lockers.");
			return 1;
     	}
	}
	else return Error(playerid, "You are not faction!");*/
	return 1;
}

//SAPD Commands
CMD:sapdonline(playerid, params[])
{
	if(pData[playerid][pFaction] != 1)
        return Error(playerid, "You must be a police officer.");
	if(pData[playerid][pFactionRank] < 1)
		return Error(playerid, "You must be high rank!");
		
	new duty[16], lstr[1024];
	format(lstr, sizeof(lstr), "Name\tRank\tStatus\tDuty Time\n");
	foreach(new i: Player)
	{
		if(pData[i][pFaction] == 1)
		{
			switch(pData[i][pOnDuty])
			{
				case 0:
				{
					duty = "Off Duty";
				}
				case 1:
				{
					duty = ""BLUE_E"On Duty";
				}
			}
			format(lstr, sizeof(lstr), "%s%s(%d)\t%s(%d)\t%s\t%d detik", lstr, pData[i][pName], i, GetFactionRank(i), pData[i][pFactionRank], duty, pData[i][pOnDutyTime]);
			format(lstr, sizeof(lstr), "%s\n", lstr);
		}
	}
	format(lstr, sizeof(lstr), "%s\n", lstr);
	ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_TABLIST_HEADERS, "SAPD Online", lstr, "Close", "");
	return 1;
}
CMD:pickupsapd(playerid, params[])
{
	if(pData[playerid][pFaction] != 1)
		return Error(playerid, "Kamu tidak bisa melakukan ini");

	new lstr[512];
	new status1[80], status2[80], status3[80], status4[80], status5[80];
	new status6[80], status7[80], status8[80];
	if(IsValidVehicle(SAPDVehicles[0]))
    {
    	status1 = "{FF0000}Not Ready";
    }
    else
   	{
   		status1 = "{00FF11}Ready";
   	}
   	if(IsValidVehicle(SAPDVehicles[1]))
    {
    	status2 = "{FF0000}Not Ready";
    }
    else
   	{
   		status2 = "{00FF11}Ready";
   	}
   	if(IsValidVehicle(SAPDVehicles[2]))
    {
    	status3 = "{FF0000}Not Ready";
    }
    else
   	{
   		status3 = "{00FF11}Ready";
   	}
   	if(IsValidVehicle(SAPDVehicles[3]))
    {
    	status4 = "{FF0000}Not Ready";
    }
    else
   	{
   		status4 = "{00FF11}Ready";
   	}
   	if(IsValidVehicle(SAPDVehicles[4]))
    {
    	status5 = "{FF0000}Not Ready";
    }
    else
   	{
   		status5 = "{00FF11}Ready";
   	}
   	if(IsValidVehicle(SAPDVehicles[5]))
    {
    	status6 = "{FF0000}Not Ready";
    }
    else
   	{
   		status6 = "{00FF11}Ready";
   	}
   	if(IsValidVehicle(SAPDVehicles[6]))
    {
    	status7 = "{FF0000}Not Ready";
    }
    else
   	{
   		status7 = "{00FF11}Ready";
   	}
   	if(IsValidVehicle(SAPDVehicles[7]))
    {
    	status8 = "{FF0000}Not Ready";
    }
    else
   	{
   		status8 = "{00FF11}Ready";
   	}
   	if(IsPlayerInRangeOfPoint(playerid, 10.0, 1561.4852, -1694.3168, 5.8906))
   	{
	   	format(lstr, sizeof(lstr), "%s\tVehicle\tStatus\n", lstr);
		format(lstr, sizeof(lstr), "%s\t{3498db}» {FFFFFF}Adam/Licoln - [1]\tStatus %s\n", lstr, status1);
		format(lstr, sizeof(lstr), "%s\t{3498db}» {FFFFFF}Adam/Licoln - [2]\tStatus %s\n", lstr, status2);
		format(lstr, sizeof(lstr), "%s\t{3498db}» {FFFFFF}Adam/Licoln - [3]\tStatus %s\n", lstr, status3);
		format(lstr, sizeof(lstr), "%s\t{3498db}» {FFFFFF}Adam/Licoln - [4]\tStatus %s\n", lstr, status4);
		format(lstr, sizeof(lstr), "%s\t{3498db}» {FFFFFF}Staff/Sultan - [1]\tStatus %s\n", lstr, status5);
		format(lstr, sizeof(lstr), "%s\t{3498db}» {FFFFFF}Staff/Sultan - [2]\tStatus %s\n", lstr, status6);
		format(lstr, sizeof(lstr), "%s\t{3498db}» {FFFFFF}Rapid/NRG-500 - [1]\tStatus %s\n", lstr, status7);
		format(lstr, sizeof(lstr), "%s\t{3498db}» {FFFFFF}Rapid/NRG-500 - [2]\tStatus %s\n", lstr, status8);
		format(lstr, sizeof(lstr), "%s\t                                              \n", lstr);
		ShowPlayerDialog(playerid, DIALOG_FACTION, DIALOG_STYLE_TABLIST_HEADERS, "{FFFFFF}Veh : Menu", lstr, "Oke", "Exit");
	}
	else return Error(playerid, "Kamu tidak berada di area pickup veh");
	return 1;
}
CMD:pickupsapd1(playerid, params[])
{
	if(pData[playerid][pFaction] != 1)
		return Error(playerid, "Kamu tidak bisa melakukan ini");

	new lstr[512];
	new status1[80], status2[80], status3[80], status4[80], status5[80];
	new status6[80], status7[80], status8[80];
	if(IsValidVehicle(SAPDVehicles[10]))
    {
    	status1 = "{FF0000}Not Ready";
    }
    else
   	{
   		status1 = "{00FF11}Ready";
   	}
   	if(IsValidVehicle(SAPDVehicles[11]))
    {
    	status2 = "{FF0000}Not Ready";
    }
    else
   	{
   		status2 = "{00FF11}Ready";
   	}
   	if(IsValidVehicle(SAPDVehicles[12]))
    {
    	status3 = "{FF0000}Not Ready";
    }
    else
   	{
   		status3 = "{00FF11}Ready";
   	}
   	if(IsValidVehicle(SAPDVehicles[13]))
    {
    	status4 = "{FF0000}Not Ready";
    }
    else
   	{
   		status4 = "{00FF11}Ready";
   	}
   	if(IsValidVehicle(SAPDVehicles[14]))
    {
    	status5 = "{FF0000}Not Ready";
    }
    else
   	{
   		status5 = "{00FF11}Ready";
   	}
   	if(IsValidVehicle(SAPDVehicles[15]))
    {
    	status6 = "{FF0000}Not Ready";
    }
    else
   	{
   		status6 = "{00FF11}Ready";
   	}
   	if(IsValidVehicle(SAPDVehicles[16]))
    {
    	status7 = "{FF0000}Not Ready";
    }
    else
   	{
   		status7 = "{00FF11}Ready";
   	}
   	if(IsValidVehicle(SAPDVehicles[17]))
    {
    	status8 = "{FF0000}Not Ready";
    }
    else
   	{
   		status8 = "{00FF11}Ready";
   	}
   	if(IsPlayerInRangeOfPoint(playerid, 10.0, 1561.4852, -1694.3168, 5.8906))
   	{
	   	format(lstr, sizeof(lstr), "%s\tVehicle\tStatus\n", lstr);
		format(lstr, sizeof(lstr), "%s\t{3498db}» {FFFFFF}Air/Maverick - [1]\tStatus %s\n", lstr, status1);
		format(lstr, sizeof(lstr), "%s\t{3498db}» {FFFFFF}Air/Maverick - [2]\tStatus %s\n", lstr, status2);
		format(lstr, sizeof(lstr), "%s\t{3498db}» {FFFFFF}Hotel/Infernus - [1]\tStatus %s\n", lstr, status3);
		format(lstr, sizeof(lstr), "%s\t{3498db}» {FFFFFF}Hotel/Infernus - [2]\tStatus %s\n", lstr, status4);
		format(lstr, sizeof(lstr), "%s\t{3498db}» {FFFFFF}Panzer/Truck - [1]\tStatus %s\n", lstr, status5);
		format(lstr, sizeof(lstr), "%s\t{3498db}» {FFFFFF}Marry/HPV - [2]\tStatus %s\n", lstr, status6);
		format(lstr, sizeof(lstr), "%s\t{3498db}» {FFFFFF}Resistor/SWAT - [1]\tStatus %s\n", lstr, status7);
		format(lstr, sizeof(lstr), "%s\t{3498db}» {FFFFFF}Resistor/SWAT - [2]\tStatus %s\n", lstr, status8);
		format(lstr, sizeof(lstr), "%s\t                                              \n", lstr);
		ShowPlayerDialog(playerid, DIALOG_FACTION1, DIALOG_STYLE_TABLIST_HEADERS, "{FFFFFF}Veh : Menu", lstr, "Oke", "Exit");
	}
	else return Error(playerid, "Kamu tidak berada di area pickup veh");
	return 1;
}

/*CMD:storesapd(playerid, params[])
{
	if(pData[playerid][pFaction] != 1)
		return Error(playerid, "Kamu tidak bisa melakukan ini.");

	if(pData[playerid][IsLoggedIn] == false) return Error(playerid, "Kamu harus login!");
	if(pData[playerid][pInjured] >= 1) return Error(playerid, "Kamu tidak bisa melakukan ini!");

	if(IsPlayerInRangeOfPoint(playerid, 10.0, 1561.4852, -1694.3168, 5.8906))
   	{
		PlayerPlaySound(playerid, 1145, 0.0, 0.0, 0.0);
		InfoTD_MSG(playerid, 4000, "All Vehicle ~g~Despawned");
		for(new x;x<sizeof(SAPDVehicles);x++)
		DestroyVehicle(SAPDVehicles[playerid]);
	}
	else return Error(playerid, "Kamu tidak berada di area store/pickup veh");
	return 1;
}*/
CMD:storesapd(playerid, params[])
{
	//if(pData[playerid][pAdmin] < 1) return Error(playerid, "You dont have Admin!");
	if(pData[playerid][pInjured] >= 1) return Error(playerid, "Kamu tidak bisa melakukan ini!");
	if(pData[playerid][pFaction] != 1)
	   return Error(playerid, "You dont have Faction Sapd!");
	if(!IsPlayerInAnyVehicle(playerid)) return Error(playerid, "You must be in Vehicle");
	if(!IsPlayerInRangeOfPoint(playerid, 3.0, 1561.4852, -1694.3168, 5.8906)) return Error(playerid, "Anda harus berada di garasi sapd!");
    new vehicleid = GetPlayerVehicleID(playerid);
    DestroyVehicle(vehicleid);
    return 1;
}
CMD:psetrank(playerid, params[])
{
	new rank, otherid;
	if(pData[playerid][pFaction] != 1)
		return Error(playerid, "Kamu tidak bisa melakukan ini.");

	if(pData[playerid][pFactionRank] < 10)
		return Error(playerid, "You must faction level 10 - 11!");

	if(sscanf(params, "ud", otherid, rank))
        return Usage(playerid, "/setrank [playerid/PartOfName] [rank 1-11]");

	if(otherid == INVALID_PLAYER_ID)
		return Error(playerid, "Invalid ID.");

	if(otherid == playerid)
		return Error(playerid, "Invalid ID.");

	if(pData[otherid][pFaction] != pData[playerid][pFaction])
		return Error(playerid, "This player is not in your devision!");

	if(rank < 1 || rank > 11)
		return Error(playerid, "rank must 1 - 11 only");

	pData[otherid][pFactionRank] = rank;
	Servers(playerid, "You has set %s faction rank to level %d", pData[otherid][pName], rank);
	Servers(otherid, "%s has set your faction rank to level %d", pData[playerid][pName], rank);
	return 1;
}
CMD:pinvite(playerid, params[])
{
	if(pData[playerid][pFaction] != 1)
		return Error(playerid, "Kamu harus di SAPD!");
		
	if(pData[playerid][pFactionRank] < 10)
		return Error(playerid, "You must faction level 10 - 11!");
	
	if(!pData[playerid][pOnDuty])
        return Error(playerid, "You must on duty!.");
	new otherid;
    if(sscanf(params, "u", otherid))
        return Usage(playerid, "/invite [playerid/PartOfName]");
		
	if(!IsPlayerConnected(otherid))
		return Error(playerid, "Invalid ID.");
	
	if(otherid == playerid)
		return Error(playerid, "Invalid ID.");
	
	if(!NearPlayer(playerid, otherid, 5.0))
        return Error(playerid, "You must be near this player.");
	
	if(pData[otherid][pFamily] != -1)
		return Error(playerid, "Player tersebut sudah bergabung family");
		
	if(pData[otherid][pFaction] != 0)
		return Error(playerid, "Player tersebut sudah bergabung faction!");
		
	pData[otherid][pFacInvite] = pData[playerid][pFaction];
	pData[otherid][pFacOffer] = playerid;
	Servers(playerid, "Anda telah menginvite %s untuk menjadi faction.", pData[otherid][pName]);
	Servers(otherid, "%s telah menginvite anda untuk menjadi faction. Type: /accept faction or /deny faction!", pData[playerid][pName]);
	return 1;
}
CMD:puninvite(playerid, params[])
{
	if(pData[playerid][pFaction] != 1)
		return Error(playerid, "Kamu harus di SAPD!");
		
	if(pData[playerid][pFactionRank] < 10)
		return Error(playerid, "You must faction level 10 - 11!");
	
	if(!pData[playerid][pOnDuty])
        return Error(playerid, "You must on duty!.");
	new otherid;
    if(sscanf(params, "u", otherid))
        return Usage(playerid, "/uninvite [playerid/PartOfName]");
		
	if(!IsPlayerConnected(otherid))
		return Error(playerid, "Invalid ID.");
	
	if(otherid == playerid)
		return Error(playerid, "Invalid ID.");
	
	if(pData[otherid][pFactionRank] > pData[playerid][pFactionRank])
		return Error(playerid, "You cant kick him.");
		
	pData[otherid][pFactionRank] = 0;
	pData[otherid][pFaction] = 0;
	Servers(playerid, "Anda telah mengeluarkan %s dari faction.", pData[otherid][pName]);
	Servers(otherid, "%s telah mengkick anda dari faction.", pData[playerid][pName]);
	return 1;
}
CMD:flare(playerid, params[])
{
	if(pData[playerid][pFaction] != 1)
        return Error(playerid, "Kamu harus menjadi police officer.");

    new Float:x, Float:y, Float:z, Float:a;
    GetPlayerPos(playerid, x, y, z);
	GetPlayerFacingAngle(playerid, a);

	if(IsValidDynamicObject(pData[playerid][pFlare]))
		DestroyDynamicObject(pData[playerid][pFlare]);

	pData[playerid][pFlare] = CreateDynamicObject(18728, x, y, z-2.8, 0, 0, a-90);
	Info(playerid, "Flare: request backup is actived! /destroyflare to delete flare.");
	SetPlayerCheckpoint(playerid, x, y, z, 5.0);
	SendFactionMessage(1, COLOR_RADIO, "[FLARE] "WHITE_E"Officer %s has request a backup in near (%s).", ReturnName(playerid), GetLocation(x, y, z));
	SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "* %s deployed a flare on the ground.", ReturnName(playerid));
    return 1;
}

CMD:destroyflare(playerid, params[])
{
	if(pData[playerid][pFaction] != 1)
        return Error(playerid, "Kamu harus menjadi police officer.");

	if(IsValidDynamicObject(pData[playerid][pFlare]))
		DestroyDynamicObject(pData[playerid][pFlare]);
	Info(playerid, "Your flare is deleted.");
	DisablePlayerCheckpoint(playerid);
	return 1;
}

CMD:revokelic(playerid, params[])
{
	if(pData[playerid][pFaction] != 1)
        return Error(playerid, "Kamu harus menjadi police officer.");

	if(IsPlayerConnected(playerid))
	{
		new name[24], otherid;
        if(sscanf(params, "us[24]d", otherid, name))
		{
			Usage(playerid, "/revokelic [playerid] [name]");
			Info(playerid, "Names: DriveLic, BoatLic, FlyLic");
			return 1;
		}

		if(strcmp(name,"DriveLic",true) == 0)
		{
			pData[otherid][pDriveLic] = 0;
			pData[playerid][pDriveLicTime] = 0;
			Info(playerid, "Anda telah berhasil menilang DriveLic milik %s", ReturnName(otherid));
			Info(otherid, "Officer %s telah berhasil menilang DriveLic milik anda.", pData[playerid][pName]);
		}
		else if(strcmp(name,"BoatLic",true) == 0)
		{
			pData[otherid][pBoatLic] = 0;
			pData[playerid][pBoatLicTime] = 0;
			Info(playerid, "Anda telah berhasil menilang BoatLic milik %s.", ReturnName(otherid));
			Info(otherid, "Officer %s telah berhasil menilang BoatLic milik anda.", pData[playerid][pName]);
		}
		else if(strcmp(name,"FlyLic",true) == 0)
		{
			pData[otherid][pFlyLic] = 0;
			pData[playerid][pFlyLicTime] = 0;
			Info(playerid, "Anda telah berhasil menilang FlyLic milik %s.", ReturnName(otherid));
			Info(otherid, "Officer %s telah berhasil menilang FlyLic milik anda.", pData[playerid][pName]);
		}
	}
	return 1;
}

alias:detain("undetain")
CMD:detain(playerid, params[])
{
    new vehicleid = GetNearestVehicleToPlayer(playerid, 3.0, false), otherid;

    if(pData[playerid][pFaction] != 1)
        return Error(playerid, "You must be a police officer.");
	
    if(sscanf(params, "u", otherid))
        return Usage(playerid, "/detain [playerid/PartOfName]");

    if(otherid == INVALID_PLAYER_ID)
        return Error(playerid, "That player is disconnected.");

    if(otherid == playerid)
        return Error(playerid, "You cannot detained yourself.");

    if(!NearPlayer(playerid, otherid, 5.0))
        return Error(playerid, "You must be near this player.");

    if(!pData[otherid][pCuffed])
        return Error(playerid, "The player is not cuffed at the moment.");

    if(vehicleid == INVALID_VEHICLE_ID)
        return Error(playerid, "You are not near any vehicle.");

    if(GetVehicleMaxSeats(vehicleid) < 2)
        return Error(playerid, "You can't detain that player in this vehicle.");

    if(IsPlayerInVehicle(otherid, vehicleid))
    {
        TogglePlayerControllable(otherid, 1);

        RemoveFromVehicle(otherid);
        SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "* %s opens the door and pulls %s out the vehicle.", ReturnName(playerid), ReturnName(otherid));
    }
    else
    {
        new seatid = GetAvailableSeat(vehicleid, 2);

        if(seatid == -1)
            return Error(playerid, "There are no more seats remaining.");

        new
            string[64];

        format(string, sizeof(string), "You've been ~r~detained~w~ by %s.", ReturnName(playerid));
        TogglePlayerControllable(otherid, 0);

        //StopDragging(otherid);
        PutPlayerInVehicle(otherid, vehicleid, seatid);

        SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "* %s opens the door and places %s into the vehicle.", ReturnName(playerid), ReturnName(otherid));
        InfoTD_MSG(otherid, 3500, string);
    }
    return 1;
}

CMD:deploycade(playerid, params[])
{
  	if(pData[playerid][pFaction] >= 1)
  	{
	    if(IsPlayerInAnyVehicle(playerid))
	    {
	      	Error(playerid, "You must be on foot to use this command.");
	      	return 1;
	    }
	    if(pData[playerid][pFactionRank] < 2)
	    {
	      	Error(playerid, "You need to be at least rank 2 to use this command.");
	      	return 1;
	    }

	    new String[10000], Float:BerPosition[4];
	    for(new i; i<MAX_BARRICADES; i++)
	    {
	      	if(Barricade[i] == 0)
	      	{
		        GetPlayerPos(playerid, BerPosition[0], BerPosition[1], BerPosition[2]);
		        GetPlayerFacingAngle(playerid, BerPosition[3]);
		        Barricade[i] = CreateDynamicObject(981, BerPosition[0], BerPosition[1], BerPosition[2], 0.0, 0.0, BerPosition[3]+180.0, -1, -1, -1, 200.0);
		        SetPlayerPos(playerid, BerPosition[0], BerPosition[1], BerPosition[2]+5);
		        new zone[MAX_ZONE_NAME];
		        GetPlayer3DZone(playerid, zone, sizeof(zone));
		        format(String, sizeof(String), "HQ: A barricade has been deployed by %s at %s.", pData[playerid][pName], zone);
		        foreach(new x : Player)
		        {
		          	if(pData[playerid][pFaction] >= 1)
		          	{
		            	SendClientMessageEx(x, TEAM_BLUES_COLOR, String);
			            if (pData[x][pFactionRank] >= 2)
			            {
			              	Usage(x, "You can remove a barricade by typing /destroycade.");
			            }
	        		}
	      		}
	      		return 1;
	      	}
	    }
	    SendClientMessageEx(playerid, COLOR_GREYJG, "All available barriers have been deployed.");
	}
	else
	{
	   	Error(playerid, "You are not an LEO.");
	}
 	return 1;
}

CMD:destroycade(playerid, params[])
{
  	if(pData[playerid][pFaction] >= 1)
  	{
	    if(IsPlayerInAnyVehicle(playerid))
	    {
	      	Error(playerid, "You must be on foot to use this command.");
	      	return 1;
	    }
	    if(pData[playerid][pFactionRank] < 2)
	    {
	      	Error(playerid, "You need to be at least rank 2 to use this command.");
	      	return 1;
	    }
	    new String[1000], Float:BerPosition[3];
	    for(new i; i<MAX_BARRICADES; i++)
	    {
	      	GetDynamicObjectPos(Barricade[i], BerPosition[0], BerPosition[1], BerPosition[2]);

	      	if(IsPlayerInRangeOfPoint(playerid, 5.0, BerPosition[0], BerPosition[1], BerPosition[2]))
	      	{
	        	DestroyDynamicObject(Barricade[i]);
	        	Barricade[i] = 0;
	        	new zone[MAX_ZONE_NAME];
        		GetPlayer3DZone(playerid, zone, sizeof(zone));
	        	format(String, sizeof(String), "HQ: A barricade has been destroyed by %s at %s.", pData[playerid][pName], zone);
	        	foreach(new x : Player)
	        	{
		          	if(pData[x][pFaction] >= 1)
		          	{
		            	SendClientMessageEx(x, TEAM_BLUES_COLOR, String);
		          	}
	        	}
	        	return 1;
	      	}
    	}
    	SendClientMessageEx(playerid, COLOR_GREYJG, "You are not near any barricades.");
  	}
  	else
  	{
    	SendClientMessageEx(playerid, COLOR_GREYJG, "You are not an LEO.");
  	}
  	return 1;
}

CMD:cuff(playerid, params[])
{
	if(pData[playerid][pFaction] == 1 || pData[playerid][pFaction] == 2)
	{
		if(!pData[playerid][pOnDuty])
			return Error(playerid, "You must on duty to use cuff.");
		
		new otherid;
		if(sscanf(params, "u", otherid))
			return Usage(playerid, "/cuff [playerid/PartOfName]");

		if(otherid == INVALID_PLAYER_ID)
			return Error(playerid, "That player is disconnected.");

		if(otherid == playerid)
			return Error(playerid, "You cannot handcuff yourself.");

		if(!NearPlayer(playerid, otherid, 5.0))
			return Error(playerid, "You must be near this player.");

		if(GetPlayerState(otherid) != PLAYER_STATE_ONFOOT)
			return Error(playerid, "The player must be onfoot before you can cuff them.");

		if(pData[otherid][pCuffed])
			return Error(playerid, "The player is already cuffed at the moment.");

		pData[otherid][pCuffed] = 1;
		SetPlayerSpecialAction(otherid, SPECIAL_ACTION_CUFFED);
		//TogglePlayerControllable(otherid, 0);
		
		new mstr[128];
		format(mstr, sizeof(mstr), "You've been ~r~cuffed~w~ by %s.", ReturnName(playerid));
		InfoTD_MSG(otherid, 3500, mstr);

		SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "* %s tightens a pair of handcuffs on %s's wrists.", ReturnName(playerid), ReturnName(otherid));
	}
	else
	{
		return Error(playerid, "You not police/gov.");
	}
    return 1;
}

CMD:uncuff(playerid, params[])
{
	if(pData[playerid][pFaction] == 1 || pData[playerid][pFaction] == 2)
	{
	
		if(!pData[playerid][pOnDuty])
			return Error(playerid, "You must on duty to use cuff.");
		
		new otherid;
		if(sscanf(params, "u", otherid))
			return Usage(playerid, "/uncuff [playerid/PartOfName]");

		if(otherid == INVALID_PLAYER_ID)
			return Error(playerid, "That player is disconnected.");

		if(otherid == playerid)
			return Error(playerid, "You cannot uncuff yourself.");

		if(!NearPlayer(playerid, otherid, 5.0))
			return Error(playerid, "You must be near this player.");

		if(!pData[otherid][pCuffed])
			return Error(playerid, "The player is not cuffed at the moment.");

		static
			string[64];

		pData[otherid][pCuffed] = 0;
		SetPlayerSpecialAction(otherid, SPECIAL_ACTION_NONE);
		TogglePlayerControllable(otherid, true);

		format(string, sizeof(string), "You've been ~g~uncuffed~w~ by %s.", ReturnName(playerid));
		InfoTD_MSG(otherid, 3500, string);

		SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "* %s loosens the pair of handcuffs on %s's wrists.", ReturnName(playerid), ReturnName(otherid));
	}
	else
	{
		return Error(playerid, "You not police/gov.");
	}
    return 1;
}


CMD:release(playerid, params[])
{
	if(pData[playerid][pFaction] != 1)
        return Error(playerid, "You must be a police officer.");
	
	if(!IsPlayerInRangeOfPoint(playerid, 3.0, 1583.8820, -1672.9263, 2982.2800))
		return Error(playerid, "You must be near an arrest point.");

	new otherid;
	if(sscanf(params, "u", otherid))
	{
	    Usage(playerid, "/release <ID/Name>");
	    return true;
	}

    if(otherid == INVALID_PLAYER_ID)
        return Error(playerid, "Player not connected!");
	
	if(otherid == playerid)
		return Error(playerid, "You cant release yourself!");

	if(pData[otherid][pArrest] == 0)
	    return Error(playerid, "The player isn't in arrest!");

	pData[otherid][pArrest] = 0;
	pData[otherid][pArrestTime] = 0;
	SetPlayerInterior(otherid, 0);
	SetPlayerVirtualWorld(otherid, 0);
	SetPlayerPositionEx(otherid, 1555.3, -1675.69, 16.1953, 87.1144, 2000);
	SetPlayerSpecialAction(otherid, SPECIAL_ACTION_NONE);

	SendClientMessageToAllEx(COLOR_BLUE, "[PRISON]"WHITE_E"Officer %s telah membebaskan %s dari penjara.", ReturnName(playerid), ReturnName(otherid));
	return true;
}


CMD:arrest(playerid, params[])
{
    static
        denda,
		cellid,
        times,
		otherid;

    if(pData[playerid][pFaction] != 1)
        return Error(playerid, "You must be a police officer.");
		
	if(!IsPlayerInRangeOfPoint(playerid, 3.0, 1583.8820, -1672.9263, 2982.2800))
		return Error(playerid, "You must be near an arrest point.");

    if(sscanf(params, "uddd", otherid, cellid, times, denda))
        return Usage(playerid, "/arrest [playerid/PartOfName] [cell id] [minutes] [denda]");

    if(otherid == INVALID_PLAYER_ID || !NearPlayer(playerid, otherid, 5.0))
        return Error(playerid, "The player is disconnected or not near you.");
		
	/*if(otherid == playerid)
		return Error(playerid, "You cant arrest yourself!");*/

    if(times < 1 || times > 120)
        return Error(playerid, "The specified time can't be below 1 or above 120.");
		
	if(cellid < 1 || cellid > 2)
        return Error(playerid, "The specified cell id can't be below 1 or above 2.");
		
	if(denda < 100 || denda > 1000000)
        return Error(playerid, "The specified denda can't be below 100 or above 10,000.00.");

    /*if(!IsPlayerNearArrest(playerid))
        return Error(playerid, "You must be near an arrest point.");*/

	GivePlayerMoneyEx(otherid, -denda);
    pData[otherid][pArrest] = cellid;
    pData[otherid][pArrestTime] = times * 60;
	
	SetPlayerArrest(otherid, cellid);

    
    SendClientMessageToAllEx(COLOR_BLUE, "[PRISON]"WHITE_E" %s telah ditangkap dan dipenjarakan oleh polisi selama %d hari dengan denda "GREEN_E"%s.", ReturnName(otherid), times, FormatMoney(denda));
    return 1;
}

/*
CMD:su(playerid, params[])
{
	new crime[64];
	if(sscanf(params, "us[64]", otherid, crime)) return Usage(playerid, "(/su)spect [playerid] [crime discription]");

	if (pData[playerid][pFaction] == 1 || pData[playerid][pFaction] == 2)
	{
		if(IsPlayerConnected(otherid))
		{
			if(otherid != INVALID_PLAYER_ID)
			{
				if(otherid == playerid)
				{
					Error(playerid, COLOR_GREY, "You cannot suspect yourself!");
					return 1;
				}
				if(pData[playerid][pFaction] > 0)
				{
					Error(playerid, COLOR_GREY, "You cannot /su an faction!");
					return 1;
				}
				if (WantedPoints[otherid]>=6)
				{
					Error(playerid, "Target is already most wanted.");
					return 1;
				}
				WantedPoints[otherid] += 1;
				SetPlayerCriminal(otherid,playerid, crime);
				return 1;
			}
		}
		else
		{
			Error(playerid, "Invalid player specified.");
			return 1;
		}
	}
	else
	{
		Error(playerid, "   You are not a Cop/Gov!");
	}
	return 1;
}
*/
CMD:gtaser(playerid, params[])
{
	if(pData[playerid][pFaction] != 1)
			return Error(playerid, "You must be a sapd officer.");

    new weapon, ammo;
    GetPlayerWeaponData(playerid, TASER_WEAPON_SLOT, weapon, ammo);
    GivePlayerWeaponEx(playerid, weapon, -ammo);
 
    if (taser[playerid])
    {
        taser[playerid] = false;
        if (GiveTaserAgainTimer[playerid]) KillTimer(GiveTaserAgainTimer[playerid]);
        if (IsPlayerAttachedObjectSlotUsed(playerid, 0)) 
        {
            new skin = GetPlayerSkin(playerid);
            SetPlayerSkin(playerid, skin);
            ClearAnimations(playerid, 1);
            RemovePlayerAttachedObject(playerid, 0);
        }
    }
    else 
    {
        taser[playerid] = true;
        GivePlayerWeaponEx(playerid, TASER_WEAPON, 1);
    }
    return 1;
}
CMD:ticket(playerid, params[])
{
	if(pData[playerid][pFaction] != 1)
			return Error(playerid, "You must be a sapd officer.");
	
	new vehid, ticket;
	if(sscanf(params, "dd", vehid, ticket))
		return Usage(playerid, "/ticket [vehid] [ammount] | /checkveh - for find vehid");
	
	if(vehid == INVALID_VEHICLE_ID || !IsValidVehicle(vehid))
		return Error(playerid, "Invalid id");
	
	if(ticket < 0 || ticket > 100000)
		return Error(playerid, "Ammount max of ticket is $1 - $1.000.00!");
	
	new nearid = GetNearestVehicleToPlayer(playerid, 5.0, false);
	
	foreach(new ii : PVehicles)
	{
		if(vehid == pvData[ii][cVeh])
		{
			if(vehid == nearid)
			{
				if(pvData[ii][cTicket] >= 2000)
					return Error(playerid, "Kendaraan ini sudah mempunyai terlalu banyak ticket!");
					
				pvData[ii][cTicket] += ticket;
				Info(playerid, "Anda telah menilang kendaraan %s(id: %d) dengan denda sejumlah "RED_E"%s", GetVehicleName(vehid), vehid, FormatMoney(ticket));
				return 1;
			}
			else return Error(playerid, "Anda harus berada dekat dengan kendaraan tersebut!");
		}
	}
	return 1;
}

CMD:checkveh(playerid, params[])
{
	if(pData[playerid][pFaction] != 1)
		if(pData[playerid][pAdmin] < 1)
			return Error(playerid, "You must be a sapd officer.");
		
	static carid = -1;
	new vehicleid = GetNearestVehicleToPlayer(playerid, 3.0, false);

	if(vehicleid == INVALID_VEHICLE_ID || !IsValidVehicle(vehicleid))
		return Error(playerid, "You not in near any vehicles.");
	
	if((carid = Vehicle_Nearest(playerid)) != -1)
	{
		new query[128];
		mysql_format(g_SQL, query, sizeof(query), "SELECT username FROM players WHERE reg_id='%d'", pvData[carid][cOwner]);
		mysql_query(g_SQL, query);
		new rows = cache_num_rows();
		if(rows) 
		{
			new owner[32];
			cache_get_value_index(0, 0, owner);
			
			if(strcmp(pvData[carid][cPlate], "NoHave"))
			{
				Info(playerid, "ID: %d | Model: %s | Owner: %s | Plate: %s | Plate Time: %s", vehicleid, GetVehicleName(vehicleid), owner, pvData[carid][cPlate], ReturnTimelapse(gettime(), pvData[carid][cPlateTime]));
			}
			else
			{
				Info(playerid, "ID: %d | Model: %s | Owner: None | Plate: None | Plate Time: None", vehicleid, GetVehicleName(vehicleid));
			}
		}
		else
		{
			Error(playerid, "This vehicle no owned found!");
			return 1;
		}
	}
	else
	{
		Error(playerid, "You are not in near owned private vehicle.");
		return 1;
	}	
	return 1;
}

CMD:takeweapon(playerid, params[])
{
	if(pData[playerid][pFaction] != 1)
        return Error(playerid, "Kamu harus menjadi police officer.");
	{
		new otherid;
		if(sscanf(params, "u", playerid)) return Usage(playerid, "USAGE: /takeweapon [playerid/partofname]");

		if(IsPlayerConnected(playerid))
		{
			ResetPlayerWeaponsEx(playerid);
			Info(playerid, "You has taken gun from %s", pData[otherid][pName]);
			Info(otherid, "Officer %s has taken your gun.", pData[playerid][pName]);
		}
	}
	return 1;
}

CMD:blskit(playerid, params[])
{
	if(pData[playerid][pFaction] != 1)
 		return Error(playerid, "You must be a sapd officer.");
	        
	if(pData[playerid][pFactionRank] < 10)
		return Error(playerid, "You must be 10 rank sapd or high!");

	new otherid;
    if(sscanf(params, "u", otherid))
        return Usage(playerid, "/blskit [playerid/PartOfName]");
        
    if(pData[playerid][pBandage] < 5) return Error(playerid, "You need 5 Bandage.");

    if(otherid == INVALID_PLAYER_ID || !NearPlayer(playerid, otherid, 5.0))
        return Error(playerid, "That player is disconnected or not near you.");

    if(otherid == playerid)
        return Error(playerid, "You can't resalve yourself.");

    if(!pData[otherid][pInjured])
        return Error(playerid, "You can't revive a player that's not injured.");

    SetPlayerHealthEx(otherid, 100.0);
    pData[playerid][pBandage]--;
    pData[otherid][pInjured] = 0;
    pData[otherid][pHunger] = 20;
    pData[otherid][pEnergy] = 20;
	pData[otherid][pHospital] = 0;
	pData[otherid][pSick] = 0;
    ClearAnimations(otherid);
    
    SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "* %s has given blskit to %s with the right hand.", ReturnName(playerid), ReturnName(otherid));
    Info(otherid, "Officer %s has resalve your injured character.", ReturnName(playerid));
	return 1;
}

CMD:takecard(playerid, params[])
{
	if(pData[playerid][pFaction] == 1 || pData[playerid][pFaction] == 2)
	{
		if(!pData[playerid][pOnDuty])
			return Error(playerid, "You must on duty to take ID Card");

		new otherid;
		if(sscanf(params, "u", otherid))
			return Usage(playerid, "/takecard [playerid/PartOfName]");

		if(otherid == INVALID_PLAYER_ID)
			return Error(playerid, "That player is disconnected.");

		if(!NearPlayer(playerid, otherid, 5.0))
			return Error(playerid, "You must be near this player.");

		pData[otherid][pIDCard] = 0;
		pData[playerid][pIDCardTime] = 0;
		Servers(playerid, "Kamu telah berhasil menyita ID Card milik %s", ReturnName(otherid));
		Servers(otherid, "Officer %s telah berhasil menyita ID Card milik anda", pData[playerid][pName]);
	}
	else
	{
		return Error(playerid, "You not Police/Gov");
	}
	return 1;
}

CMD:takemarijuana(playerid, params[])
{
	if(pData[playerid][pFaction] != 1)
        return Error(playerid, "You must be a sapd officer.");
	if(pData[playerid][pFactionRank] < 1)
		return Error(playerid, "You must be 1 rank level!");

	new otherid;
	if(sscanf(params, "u", otherid))
	{
	    Usage(playerid, "/takemarijuana <ID/Name> | Melenyapkan Marijuana");
	    return true;
	}

	if(!IsPlayerConnected(otherid) || otherid == INVALID_PLAYER_ID)
        return Error(playerid, "Player not connected!");

 	if(!NearPlayer(playerid, otherid, 4.0))
        return Error(playerid, "The specified player is disconnected or not near you.");
		
	pData[otherid][pMarijuana] = 0;
	Info(playerid, "Anda telah mengambil semua marijuana milik %s.", ReturnName(otherid));
	Info(otherid, "Officer %s telah mengambil semua marijuana milik anda", ReturnName(playerid));
	return 1;
}

CMD:takeborax(playerid, params[])
{
	if(pData[playerid][pFaction] != 1)
        return Error(playerid, "You must be a sapd officer.");
	if(pData[playerid][pFactionRank] < 1)
		return Error(playerid, "You must be 1 rank level!");

	new otherid;
	if(sscanf(params, "u", otherid))
	{
	    Usage(playerid, "/takeborax <ID/Name> | Melenyapkan Borax");
	    return true;
	}

	if(!IsPlayerConnected(otherid) || otherid == INVALID_PLAYER_ID)
        return Error(playerid, "Player not connected!");

 	if(!NearPlayer(playerid, otherid, 4.0))
        return Error(playerid, "The specified player is disconnected or not near you.");
		
	pData[otherid][pBorax] = 0;
	Info(playerid, "Anda telah mengambil semua borax milik %s.", ReturnName(otherid));
	Info(otherid, "Officer %s telah mengambil semua borax milik anda", ReturnName(playerid));
	return 1;
}
CMD:takepaketborax(playerid, params[])
{
	if(pData[playerid][pFaction] != 1)
        return Error(playerid, "You must be a sapd officer.");
	if(pData[playerid][pFactionRank] < 1)
		return Error(playerid, "You must be 1 rank level!");

	new otherid;
	if(sscanf(params, "u", otherid))
	{
	    Usage(playerid, "/takeborax <ID/Name> | Melenyapkan Borax");
	    return true;
	}

	if(!IsPlayerConnected(otherid) || otherid == INVALID_PLAYER_ID)
        return Error(playerid, "Player not connected!");

 	if(!NearPlayer(playerid, otherid, 4.0))
        return Error(playerid, "The specified player is disconnected or not near you.");
		
	pData[otherid][pPaketBorax] = 0;
	Info(playerid, "Anda telah mengambil semua borax milik %s.", ReturnName(otherid));
	Info(otherid, "Officer %s telah mengambil semua borax milik anda", ReturnName(playerid));
	return 1;
}
CMD:takeredmoney(playerid, params[])
{
	if(pData[playerid][pFaction] != 1)
        return Error(playerid, "You must be a sapd officer.");
	if(pData[playerid][pFactionRank] < 1)
		return Error(playerid, "You must be 1 rank level!");

	new otherid;
	if(sscanf(params, "u", otherid))
	{
	    Usage(playerid, "/takeredmoney <ID/Name> | Melenyapkan Red Money.");
	    return true;
	}

	if(!IsPlayerConnected(otherid) || otherid == INVALID_PLAYER_ID)
        return Error(playerid, "Player not connected!");

 	if(!NearPlayer(playerid, otherid, 4.0))
        return Error(playerid, "The specified player is disconnected or not near you.");
		
	pData[otherid][pRedMoney] = 0;
	Info(playerid, "Anda telah mengambil semua borax milik %s.", ReturnName(otherid));
	Info(otherid, "Officer %s telah mengambil semua borax milik anda", ReturnName(playerid));
	return 1;
}
CMD:takeskck(playerid, params[])
{
	if(pData[playerid][pFaction] != 1)
        return Error(playerid, "You must be a sapd officer.");
	if(pData[playerid][pFactionRank] < 3)
		return Error(playerid, "You must be 3 rank level!");

	new otherid;
	if(sscanf(params, "u", otherid))
	{
	    Usage(playerid, "/takeskck <ID/Name> | Menarik Surat SKCK");
	    return true;
	}

	if(!IsPlayerConnected(otherid) || otherid == INVALID_PLAYER_ID)
        return Error(playerid, "Player not connected!");

 	if(!NearPlayer(playerid, otherid, 4.0))
        return Error(playerid, "The specified player is disconnected or not near you.");

	pData[otherid][pSkck] = 0;
	pData[otherid][pSkckTime] = 0;
	Info(playerid, "Anda telah mengambil SKCK milik %s.", ReturnName(otherid));
	Info(otherid, "Officer %s telah mengambil SKCK milik anda", ReturnName(playerid));
	return 1;
}
CMD:taketrucker(playerid, params[])
{
	if(pData[playerid][pFaction] != 1)
        return Error(playerid, "You must be a sapd officer.");
	if(pData[playerid][pFactionRank] < 3)
		return Error(playerid, "You must be 3 rank level!");

	new otherid;
	if(sscanf(params, "u", otherid))
	{
	    Usage(playerid, "/taketrucker <ID/Name> | Menarik License Trucker");
	    return true;
	}

	if(!IsPlayerConnected(otherid) || otherid == INVALID_PLAYER_ID)
        return Error(playerid, "Player not connected!");

 	if(!NearPlayer(playerid, otherid, 4.0))
        return Error(playerid, "The specified player is disconnected or not near you.");

	pData[otherid][pTruckerLic] = 0;
	pData[otherid][pTruckerLicTime] = 0;
	Info(playerid, "Anda telah mengambil Lic Trucker milik %s.", ReturnName(otherid));
	Info(otherid, "Officer %s telah mengambil Lic Trucker milik anda", ReturnName(playerid));
	return 1;
}
CMD:takepenebang(playerid, params[])
{
	if(pData[playerid][pFaction] != 1)
        return Error(playerid, "You must be a sapd officer.");
	if(pData[playerid][pFactionRank] < 3)
		return Error(playerid, "You must be 3 rank level!");

	new otherid;
	if(sscanf(params, "u", otherid))
	{
	    Usage(playerid, "/takepenebang <ID/Name> | Menarik License Penebang");
	    return true;
	}

	if(!IsPlayerConnected(otherid) || otherid == INVALID_PLAYER_ID)
        return Error(playerid, "Player not connected!");

 	if(!NearPlayer(playerid, otherid, 4.0))
        return Error(playerid, "The specified player is disconnected or not near you.");

	pData[otherid][pPenebangs] = 0;
	pData[otherid][pPenebangsTime] = 0;
	Info(playerid, "Anda telah mengambil Lic Penebang milik %s.", ReturnName(otherid));
	Info(otherid, "Officer %s telah mengambil Lic Penebang milik anda", ReturnName(playerid));
	return 1;
}

CMD:takedl(playerid, params[])
{
	if(pData[playerid][pFaction] != 1)
        return Error(playerid, "You must be a sapd officer.");
	if(pData[playerid][pFactionRank] < 2)
		return Error(playerid, "You must be 2 rank level!");

	new otherid;
	if(sscanf(params, "u", otherid))
	{
	    Usage(playerid, "/takedl <ID/Name> | Tilang Driving License(SIM)");
	    return true;
	}

	if(!IsPlayerConnected(otherid) || otherid == INVALID_PLAYER_ID)
        return Error(playerid, "Player not connected!");

 	if(!NearPlayer(playerid, otherid, 4.0))
        return Error(playerid, "The specified player is disconnected or not near you.");
		
	pData[otherid][pDriveLic] = 0;
	pData[otherid][pDriveLicTime] = 0;
	Info(playerid, "Anda telah menilang Driving License milik %s.", ReturnName(otherid));
	Info(otherid, "Officer %s telah menilang Driving License milik anda", ReturnName(playerid));
	return 1;
}

CMD:atakedl(playerid, params[])
{
	if(pData[playerid][pAdmin] < 5)
		return PermissionError(playerid);
		
	pData[playerid][pDriveLic] = 0;
	pData[playerid][pDriveLicTime] = 0;
	//Info(playerid, "Anda telah menilang Driving License milik );
	//Info(otherid, "Officer %s telah menilang Driving License milik anda", ReturnName(playerid));
	return 1;
}


CMD:impound(playerid, params[])
{
	if(pData[playerid][pFaction] != 1)
        return Error(playerid, "You must be a sapd officer.");
	if(pData[playerid][pFactionRank] < 1)
		return Error(playerid, "You must be 1 rank level!");

	if(!pData[playerid][pOnDuty])
        return Error(playerid, "You must on duty!.");

    new x = GetNearestVehicleToPlayer(playerid, 3.5, false);

   	if(x == INVALID_VEHICLE_ID)
		return Error(playerid, "You not in near any vehicles.");

	static carid = -1;

	if((carid = Vehicle_Nearest(playerid)) != -1)
	{
		foreach(new i: PVehicles)
		if(x == pvData[i][cVeh])
		{
			new vehid = pvData[i][cVeh];

			pvData[carid][cImpound] = 1;
			pvData[carid][cImpoundTime] = gettime() + (1 * 1800);
			foreach(new pid : Player) if (pvData[carid][cOwner] == pData[pid][pID])
        	{
            	Info(pid, "Kendaraan anda telah di {FFFF00}Impound{FFFFFF}, silahkan ambil di kantor SAPD HQ setelah 30 menit.");
			}
			if(IsValidVehicle(vehid))
				DestroyVehicle(vehid);

			pvData[vehid][cVeh] = 0;
			Info(playerid, "Anda berhasil untuk impound kendaran tersebut.");
		}
	}
	else 
	{
		Error(playerid, "Kamu tidak dekat dengan kendaraan apa pun yang ingin di impound.");
    }
    return 1;
}
CMD:tablet(playerid, params[])
{
	if(pData[playerid][pFaction] != 1)
        return Error(playerid, "You must be a sapd officer.");
	if(pData[playerid][pFactionRank] < 1)
		return Error(playerid, "You must be 1 rank level!");

	PlayerTextDrawShow(playerid, MDCTD0[playerid]);
	PlayerTextDrawShow(playerid, MDCTD1[playerid]);
	PlayerTextDrawShow(playerid, MDCTD2[playerid]);
	PlayerTextDrawShow(playerid, MDCTD3[playerid]);
	PlayerTextDrawShow(playerid, MDCTD4[playerid]);
	PlayerTextDrawShow(playerid, CLICKPH[playerid]);
	PlayerTextDrawShow(playerid, MDCTD6[playerid]);
	PlayerTextDrawShow(playerid, MDCTD7[playerid]);
	PlayerTextDrawShow(playerid, MDCTD8[playerid]);
	PlayerTextDrawShow(playerid, MDCTD9[playerid]);
	PlayerTextDrawShow(playerid, MDCTD10[playerid]);
	PlayerTextDrawShow(playerid, MDCTD11[playerid]);
	PlayerTextDrawShow(playerid, MDCTD12[playerid]);
	PlayerTextDrawShow(playerid, MDCTD13[playerid]);
	PlayerTextDrawShow(playerid, CLICKNAME[playerid]);
	PlayerTextDrawShow(playerid, MDCTD16[playerid]);
	PlayerTextDrawShow(playerid, CLICKCLOSE[playerid]);
	PlayerTextDrawShow(playerid, MDCTD20[playerid]);
	PlayerTextDrawShow(playerid, MDCTD21[playerid]);
	PlayerTextDrawShow(playerid, MDCTD22[playerid]);
	PlayerTextDrawShow(playerid, MDCTD23[playerid]);
	PlayerTextDrawShow(playerid, MDCTD24[playerid]);
	PlayerTextDrawShow(playerid, MDCTD25[playerid]);
	PlayerTextDrawShow(playerid, MDCTD26[playerid]);
	PlayerTextDrawShow(playerid, MDCTD27[playerid]);
	SelectTextDraw(playerid, 0xFFA500FF);
	return 1;
}
//SAGS Commands
CMD:givebizlic(playerid, params[])
{

    if(pData[playerid][pFaction] != 2)
        return Error(playerid, "You must be part of a Goverments.");
	new to_player;
    if(sscanf(params, "u", to_player))
        return Usage(playerid, "/givebizlic [playerid/PartOfName]");

    if(!NearPlayer(playerid, to_player, 6.0))
		return SendClientMessage(playerid, 0xCECECEFF, "Pemainnya terlalu jauh");

	if(pData[to_player][pLicBiz] != 0) return Error(playerid, "Orang ini sudah mempunyai Licenses Business");
	new sext[40], lstr[128], mstr[128];
	if(pData[to_player][pGender] == 1) { sext = "Laki-Laki"; } else { sext = "Perempuan"; }
	format(lstr, sizeof(lstr), "Licenses Business %s", pData[to_player][pName]);
	format(mstr,sizeof(mstr), "{FFFFFF}Nama: %s\nNegara: San Andreas\nTgl Lahir: %s\nJenis Kelamin: %s\nBerlaku hingga 14 hari!", pData[to_player][pName], pData[to_player][pAge], sext);
	ShowPlayerDialog(to_player, DIALOG_UNUSED, DIALOG_STYLE_MSGBOX, lstr, mstr, "Tutup", "");
	Info(to_player, "Anda mendapatkan surat	License Business dari departemen Goverments");
	SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s Memberikan Surat Licenses Business Kepada %s", ReturnName(playerid), ReturnName(to_player));
	pData[to_player][pLicBiz] = 1;
	pData[to_player][pLicBizTime] = gettime() +  (15 * 86400);
	Info(playerid, "Anda Telah Memberikan Surat Licenses Business kepada %s", ReturnName(to_player));

    return 1;
}
CMD:sagsonline(playerid, params[])
{
	if(pData[playerid][pFaction] != 2)
        return Error(playerid, "You must be a sags officer.");
	if(pData[playerid][pFactionRank] < 1)
		return Error(playerid, "You must be high rank!");
		
	new duty[16], lstr[1024];
	format(lstr, sizeof(lstr), "Name\tRank\tStatus\tDuty Time\n");
	foreach(new i: Player)
	{
		if(pData[i][pFaction] == 2)
		{
			switch(pData[i][pOnDuty])
			{
				case 0:
				{
					duty = "Off Duty";
				}
				case 1:
				{
					duty = ""BLUE_E"On Duty";
				}
			}
			format(lstr, sizeof(lstr), "%s%s(%d)\t%s(%d)\t%s\t%d detik", lstr, pData[i][pName], i, GetFactionRank(i), pData[i][pFactionRank], duty, pData[i][pOnDutyTime]);
			format(lstr, sizeof(lstr), "%s\n", lstr);
		}
	}
	format(lstr, sizeof(lstr), "%s\n", lstr);
	ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_TABLIST_HEADERS, "SAGS Online", lstr, "Close", "");
	return 1;
}
CMD:pickupsags(playerid, params[])
{
	if(pData[playerid][pFaction] != 2)
        return Error(playerid, "You must be a sags officer.");

   	new lstr[512];
	new status1[80], status2[80], status3[80], status4[80], status5[80];
	new status6[80], status7[80], status8[80];
	if(IsValidVehicle(SAGSVehicles[0]))
    {
    	status1 = "{FF0000}Not Ready";
    }
    else
   	{
   		status1 = "{00FF11}Ready";
   	}
   	if(IsValidVehicle(SAGSVehicles[1]))
    {
    	status2 = "{FF0000}Not Ready";
    }
    else
   	{
   		status2 = "{00FF11}Ready";
   	}
   	if(IsValidVehicle(SAGSVehicles[2]))
    {
    	status3 = "{FF0000}Not Ready";
    }
    else
   	{
   		status3 = "{00FF11}Ready";
   	}
   	if(IsValidVehicle(SAGSVehicles[3]))
    {
    	status4 = "{FF0000}Not Ready";
    }
    else
   	{
   		status4 = "{00FF11}Ready";
   	}
   	if(IsValidVehicle(SAGSVehicles[4]))
    {
    	status5 = "{FF0000}Not Ready";
    }
    else
   	{
   		status5 = "{00FF11}Ready";
   	}
   	if(IsValidVehicle(SAGSVehicles[5]))
    {
    	status6 = "{FF0000}Not Ready";
    }
    else
   	{
   		status6 = "{00FF11}Ready";
   	}
   	if(IsValidVehicle(SAGSVehicles[6]))
    {
    	status7 = "{FF0000}Not Ready";
    }
    else
   	{
   		status7 = "{00FF11}Ready";
   	}
   	if(IsValidVehicle(SAGSVehicles[7]))
    {
    	status8 = "{FF0000}Not Ready";
    }
    else
   	{
   		status8 = "{00FF11}Ready";
   	}
   	if(IsPlayerInRangeOfPoint(playerid, 10.0, 1453.8130, -1749.3013, 13.5469))
   	{
	   	format(lstr, sizeof(lstr), "%s\tVehicle\tStatus\n", lstr);
		format(lstr, sizeof(lstr), "%s\t{3498db}» {FFFFFF}Sentinel - [1]\tStatus %s\n", lstr, status1);
		format(lstr, sizeof(lstr), "%s\t{3498db}» {FFFFFF}Sentinel - [2]\tStatus %s\n", lstr, status2);
		format(lstr, sizeof(lstr), "%s\t{3498db}» {FFFFFF}Infernus - [3]\tStatus %s\n", lstr, status3);
		format(lstr, sizeof(lstr), "%s\t{3498db}» {FFFFFF}Infernus - [4]\tStatus %s\n", lstr, status4);
		format(lstr, sizeof(lstr), "%s\t{3498db}» {FFFFFF}Infernus - [1]\tStatus %s\n", lstr, status5);
		format(lstr, sizeof(lstr), "%s\t{3498db}» {FFFFFF}FCR-900 - [2]\tStatus %s\n", lstr, status6);
		format(lstr, sizeof(lstr), "%s\t{3498db}» {FFFFFF}Coach/Bus - [1]\tStatus %s\n", lstr, status7);
		format(lstr, sizeof(lstr), "%s\t{3498db}» {FFFFFF}Coach/Bus - [2]\tStatus %s\n", lstr, status8);
		format(lstr, sizeof(lstr), "%s\t                                              \n", lstr);
		ShowPlayerDialog(playerid, DIALOG_FACTION2, DIALOG_STYLE_TABLIST_HEADERS, "{FFFFFF}Veh : Menu", lstr, "Oke", "Exit");
	}
	else return Error(playerid, "Kamu tidak berada di area pickup veh");
	return 1;
}
/*
CMD:storesags(playerid, params[])
{
	if(pData[playerid][pFaction] != 2)
		return Error(playerid, "Kamu tidak bisa melakukan ini.");

	if(pData[playerid][IsLoggedIn] == false) return Error(playerid, "Kamu harus login!");
	if(pData[playerid][pInjured] >= 1) return Error(playerid, "Kamu tidak bisa melakukan ini!");

	if(IsPlayerInRangeOfPoint(playerid, 10.0, 1453.8130, -1749.3013, 13.5469))
   	{
		PlayerPlaySound(playerid, 1145, 0.0, 0.0, 0.0);
		InfoTD_MSG(playerid, 4000, "Vehicle ~g~Despawned");
		for(new x;x<sizeof(SAGSVehicles);x++)
		{
			if(IsVehicleEmpty(SAGSVehicles[x]))
			{
				SetVehicleToRespawn(SAGSVehicles[x]);
				SetValidVehicleHealth(SAGSVehicles[x], 2000);
				SetVehicleFuel(SAGSVehicles[x], 1000);
				SwitchVehicleDoors(SAGSVehicles[x], false);
				if(IsValidVehicle(SAGSVehicles[x]))
					DestroyVehicle(SAGSVehicles[x]);
			}
		}
	}
	else return Error(playerid, "Kamu tidak berada di area store/pickup veh");
	return 1;
}*/
CMD:takems(playerid, params[])
{
	if(pData[playerid][pFaction] != 2)
        return Error(playerid, "You must be a sags officer.");
	if(pData[playerid][pFactionRank] < 6)
		return Error(playerid, "You must be high rank!");

	new cash;
	if(sscanf(params, "s[32]", cash)) 
		return SendClientMessage(playerid, COLOR_RIKO, "USAGE: /takems [amount]");

	Server_MinMoney(cash);
	GivePlayerMoneyEx(playerid, cash);
	Info(playerid, "Anda Mengambil Uang Negara Sebesar %s", cash);
	return 1;
}

CMD:depoms(playerid, params[])
{
	if(pData[playerid][pFaction] != 2)
        return Error(playerid, "You must be a sags officer.");
	if(pData[playerid][pFactionRank] < 6)
		return Error(playerid, "You must be high rank!");

	new cash;
	if(sscanf(params, "s[32]", cash)) 
		return SendClientMessage(playerid, COLOR_RIKO, "USAGE: /depoms [amount]");

	GivePlayerMoneyEx(playerid, -cash);
	Server_AddMoney(cash);
	Info(playerid, "Anda Deposit ke berangkas Negara Sebesar %s", cash);
	return 1;
}
//SAMD Commands
CMD:loadinjured(playerid, params[])
{
    static
        seatid,
		otherid;

    if(pData[playerid][pFaction] != 3)
        return Error(playerid, "You must be part of a medical faction.");

    if(sscanf(params, "u", otherid))
        return Usage(playerid, "/loadinjured [playerid/PartOfName]");

    if(otherid == INVALID_PLAYER_ID || !NearPlayer(playerid, otherid, 10.0))
        return Error(playerid, "That player is disconnected or not near you.");

    if(otherid == playerid)
        return Error(playerid, "You can't load yourself into an ambulance.");

    if(!pData[otherid][pInjured])
        return Error(playerid, "That player is not injured.");
	
	if(!IsPlayerInAnyVehicle(playerid))
	{
	    Error(playerid, "You must be in a Ambulance to load patient!");
	    return true;
	}
		
	new i = GetPlayerVehicleID(playerid);
    if(GetVehicleModel(i) == 416)
    {
        seatid = GetAvailableSeat(i, 2);

        if(seatid == -1)
            return Error(playerid, "There is no room for the patient.");

        ClearAnimations(otherid);
        pData[otherid][pInjured] = 2;

        PutPlayerInVehicle(otherid, i, seatid);
        SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "* %s opens up the ambulance and loads %s on the stretcher.", ReturnName(playerid), ReturnName(otherid));

        TogglePlayerControllable(otherid, 0);
        SetPlayerHealth(otherid, 100.0);
        Info(otherid, "You're injured ~r~now you're on ambulance.");
        return 1;
    }
    else Error(playerid, "You must be in an ambulance.");
    return 1;
}

CMD:dropinjured(playerid, params[])
{

    if(pData[playerid][pFaction] != 3)
        return Error(playerid, "You must be part of a medical faction.");
	new otherid;
    if(sscanf(params, "u", otherid))
        return Usage(playerid, "/dropinjured [playerid/PartOfName]");

    if(otherid == INVALID_PLAYER_ID || !IsPlayerInVehicle(playerid, GetPlayerVehicleID(playerid)))
        return Error(playerid, "That player is disconnected or not near you.");

    if(otherid == playerid)
        return Error(playerid, "You can't deliver yourself to the hospital.");

    if(pData[otherid][pInjured] != 2)
        return Error(playerid, "That player is not injured.");

    if(IsPlayerInRangeOfPoint(playerid, 5.0, 1142.38, -1330.74, 13.62))
    {
		RemovePlayerFromVehicle(otherid);
		pData[otherid][pHospital] = 1;
		pData[otherid][pHospitalTime] = 0;
		pData[otherid][pInjured] = 1;
		ResetPlayerWeaponsEx(otherid);
        Info(playerid, "You have delivered %s to the hospital.", ReturnName(otherid));
        Info(otherid, "You have recovered at the nearest hospital by officer %s.", ReturnName(playerid));
    }
    else Error(playerid, "You must be near a hospital deliver location.");
    return 1;
}

CMD:samdonline(playerid, params[])
{
	if(pData[playerid][pFaction] != 3)
        return Error(playerid, "You must be a samd officer.");
	if(pData[playerid][pFactionRank] < 1)
		return Error(playerid, "You must be high rank!");
		
	new duty[16], lstr[1024];
	format(lstr, sizeof(lstr), "Name\tRank\tStatus\tDuty Time\n");
	foreach(new i: Player)
	{
		if(pData[i][pFaction] == 3)
		{
			switch(pData[i][pOnDuty])
			{
				case 0:
				{
					duty = "Off Duty";
				}
				case 1:
				{
					duty = ""BLUE_E"On Duty";
				}
			}
			format(lstr, sizeof(lstr), "%s%s(%d)\t%s(%d)\t%s\t%d detik", lstr, pData[i][pName], i, GetFactionRank(i), pData[i][pFactionRank], duty, pData[i][pOnDutyTime]);
			format(lstr, sizeof(lstr), "%s\n", lstr);
		}
	}
	format(lstr, sizeof(lstr), "%s\n", lstr);
	ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_TABLIST_HEADERS, "SAMD Online", lstr, "Close", "");
	return 1;
}
CMD:pickupsafd(playerid, params[])
{
	if(pData[playerid][pFaction] != 3)
        return Error(playerid, "You must be a samd officer.");

   	new lstr[512];
	new status1[80], status2[80], status3[80], status4[80], status5[80];
	new status6[80], status7[80], status8[80];
	if(IsValidVehicle(SAMDVehicles[0]))
    {
    	status1 = "{FF0000}Not Ready";
    }
    else
   	{
   		status1 = "{00FF11}Ready";
   	}
   	if(IsValidVehicle(SAMDVehicles[1]))
    {
    	status2 = "{FF0000}Not Ready";
    }
    else
   	{
   		status2 = "{00FF11}Ready";
   	}
   	if(IsValidVehicle(SAMDVehicles[2]))
    {
    	status3 = "{FF0000}Not Ready";
    }
    else
   	{
   		status3 = "{00FF11}Ready";
   	}
   	if(IsValidVehicle(SAMDVehicles[3]))
    {
    	status4 = "{FF0000}Not Ready";
    }
    else
   	{
   		status4 = "{00FF11}Ready";
   	}
   	if(IsValidVehicle(SAMDVehicles[4]))
    {
    	status5 = "{FF0000}Not Ready";
    }
    else
   	{
   		status5 = "{00FF11}Ready";
   	}
   	if(IsValidVehicle(SAMDVehicles[5]))
    {
    	status6 = "{FF0000}Not Ready";
    }
    else
   	{
   		status6 = "{00FF11}Ready";
   	}
   	if(IsValidVehicle(SAMDVehicles[6]))
    {
    	status7 = "{FF0000}Not Ready";
    }
    else
   	{
   		status7 = "{00FF11}Ready";
   	}
   	if(IsValidVehicle(SAMDVehicles[7]))
    {
    	status8 = "{FF0000}Not Ready";
    }
    else
   	{
   		status8 = "{00FF11}Ready";
   	}
   	if(IsPlayerInRangeOfPoint(playerid, 10.0, 1176.6984, -1308.9498, 13.9363))
   	{
	   	format(lstr, sizeof(lstr), "%s\tVehicle\tStatus\n", lstr);
		format(lstr, sizeof(lstr), "%s\t{3498db}» {FFFFFF}Firetruck - [1]\tStatus %s\n", lstr, status1);
		format(lstr, sizeof(lstr), "%s\t{3498db}» {FFFFFF}Firetruck - [2]\tStatus %s\n", lstr, status2);
		format(lstr, sizeof(lstr), "%s\t{3498db}» {FFFFFF}FiretrLS - [3]\tStatus %s\n", lstr, status3);
		format(lstr, sizeof(lstr), "%s\t{3498db}» {FFFFFF}Ambulance - [4]\tStatus %s\n", lstr, status4);
		format(lstr, sizeof(lstr), "%s\t{3498db}» {FFFFFF}Ambulance - [1]\tStatus %s\n", lstr, status5);
		format(lstr, sizeof(lstr), "%s\t{3498db}» {FFFFFF}Ambulance - [2]\tStatus %s\n", lstr, status6);
		format(lstr, sizeof(lstr), "%s\t{3498db}» {FFFFFF}Romero - [1]\tStatus %s\n", lstr, status7);
		format(lstr, sizeof(lstr), "%s\t{3498db}» {FFFFFF}Premier - [2]\tStatus %s\n", lstr, status8);
		format(lstr, sizeof(lstr), "%s\t                                              \n", lstr);
		ShowPlayerDialog(playerid, DIALOG_FACTION3, DIALOG_STYLE_TABLIST_HEADERS, "{FFFFFF}Veh : Menu", lstr, "Oke", "Exit");
	}
	else return Error(playerid, "Kamu tidak berada di area pickup veh");
	return 1;
}
/*
CMD:storesafd(playerid, params[])
{
	if(pData[playerid][pFaction] != 3)
		return Error(playerid, "Kamu tidak bisa melakukan ini.");

	if(pData[playerid][IsLoggedIn] == false) return Error(playerid, "Kamu harus login!");
	if(pData[playerid][pInjured] >= 1) return Error(playerid, "Kamu tidak bisa melakukan ini!");
	if(!IsPlayerInAnyVehicle(playerid)) return Error(playerid, "You must be in Vehicle");

	if(IsPlayerInRangeOfPoint(playerid, 10.0, 1176.6984, -1308.9498, 13.9363))
   	{
		PlayerPlaySound(playerid, 1145, 0.0, 0.0, 0.0);
		InfoTD_MSG(playerid, 4000, "Vehicle ~g~Despawned");
		for(new x;x<sizeof(SAMDVehicles);x++)
		{
			if(IsVehicleEmpty(SAMDVehicles[x]))
			{
				SetVehicleToRespawn(SAMDVehicles[x]);
				SetValidVehicleHealth(SAMDVehicles[x], 2000);
				SetVehicleFuel(SAMDVehicles[x], 1000);
				SwitchVehicleDoors(SAMDVehicles[x], false);
				if(IsValidVehicle(SAMDVehicles[x]))
					DestroyVehicle(SAMDVehicles[x]);
			}
		}
	}
	else return Error(playerid, "Kamu tidak berada di area store/pickup veh");
	return 1;
}*/
CMD:changegender(playerid, params[])
{
	if(pData[playerid][pFaction] != 3)
        return Error(playerid, "You must be a samd officer.");

    new otherid;
    if(sscanf(params, "u", otherid))
	    return Usage(playerid, "/changegender <ID/Name>");

	if(!IsPlayerConnected(otherid))
        return Error(playerid, "Player not connected!");

    if(!NearPlayer(playerid, otherid, 6.0))//
    {
    	if(pData[otherid][pGender] == 1)
    	{
    		pData[otherid][pGender] = 2;
    	}
    	else
    	{
    		pData[otherid][pGender] = 1;
    	}
    }
    else 
    {
    	Error(playerid, "Anda tidak berada dekat dengan Player tersebut.");
    }
    return 1;
}
CMD:ems(playerid, params[])
{
	if(pData[playerid][pFaction] != 3)
        return Error(playerid, "You must be a samd officer.");
	
	foreach(new ii : Player)
	{
		if(pData[ii][pInjured])
		{
			SendClientMessageEx(playerid, COLOR_PINK2, "EMS Player: "WHITE_E"%s(id: %d)", ReturnName(ii), ii);
		}
	}
	Info(playerid, "/findems [id] to search injured player!");
	return 1;
}

CMD:findems(playerid, params[])
{
	if(pData[playerid][pFaction] != 3)
        return Error(playerid, "You must be a samd officer.");
		
	new otherid;
	if(sscanf(params, "u", otherid))
        return Usage(playerid, "/findems [playerid/PartOfName]");
	
	if(!IsPlayerConnected(otherid)) return Error(playerid, "Player is not connected");
	
	if(otherid == playerid)
        return Error(playerid, "You can't find yourself.");
	
	if(!pData[otherid][pInjured]) return Error(playerid, "You can't find a player that's not injured.");
	
	new Float:x, Float:y, Float:z;
	GetPlayerPos(otherid, x, y, z);
	SetPlayerCheckpoint(playerid, x, y, x, 4.0);
	pData[playerid][pFindEms] = otherid;
	Info(otherid, "SAMD Officer %s sedang menuju ke lokasi anda. harap tunggu!", ReturnName(playerid));
	return 1;
}

CMD:rescue(playerid, params[])
{
	if(pData[playerid][pFaction] != 3)
        return Error(playerid, "You must be a samd officer.");

	if(pData[playerid][pMedkit] < 1) return Error(playerid, "You need medkit.");
	new otherid;
	if(sscanf(params, "u", otherid))
        return Usage(playerid, "/rescue [playerid/PartOfName]");

    if(otherid == INVALID_PLAYER_ID || !NearPlayer(playerid, otherid, 5.0))
        return Error(playerid, "That player is disconnected or not near you.");

    if(otherid == playerid)
        return Error(playerid, "You can't rescue yourself.");

    if(!pData[otherid][pInjured])
        return Error(playerid, "That player is not injured.");
	
	pData[playerid][pMedkit]--;
	
	SetPlayerHealthEx(otherid, 50.0);
    pData[otherid][pInjured] = 0;
	pData[otherid][pHospital] = 0;
	pData[otherid][pSick] = 0;
    ClearAnimations(otherid);
	
	SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "* %s has rescuered %s with medkit tools.", ReturnName(playerid), ReturnName(otherid));
    Info(otherid, "Officer %s has rescue your character.", ReturnName(playerid));
	return 1;
}
CMD:healbone(playerid, params[])
{
	if(pData[playerid][pFaction] != 3)
        return Error(playerid, "You must be a samd officer.");

	new otherid, name[24];
    if(sscanf(params, "us[24]", otherid, name))
	{
        Usage(playerid, "/healbone [playerid] [name]");
        Info(playerid, "Names: groin, torso, ra, la, rl, ll");
        return 1;
    }
    if(otherid == playerid)
        return Error(playerid, "You can't healbone yourself.");

    if(otherid == INVALID_PLAYER_ID || !NearPlayer(playerid, otherid, 5.0))
        return Error(playerid, "That player is disconnected or not near you.");

	if(strcmp(name,"groin",true) == 0)
	{
		if(pData[otherid][pStockBodyCondition][0] == 2)
		{
			if(pData[playerid][pBandage] <= 3)
				return Error(playerid, "Kamu harus mempunyai 3 bandage ");

			if(pData[playerid][pMedkit] <= 2)
				return Error(playerid, "Kamu harus mempunyai 2 Medkit");

			pData[otherid][pBodyCondition][0] = 100;
			pData[playerid][pBandage] -= 3;
			pData[playerid][pMedkit] -= 2;
			Info(playerid, "Kamu Sudah memulihkan BodyCondition sebesar 100");
		}
		else if(pData[otherid][pStockBodyCondition][0] == 3)
		{
			if(pData[playerid][pBandage] <= 4)
				return Error(playerid, "Kamu harus mempunyai 4 bandage ");

			if(pData[playerid][pMedkit] <= 3)
				return Error(playerid, "Kamu harus mempunyai 3 Medkit");

			pData[otherid][pBodyCondition][0] = 100;
			pData[playerid][pBandage] -= 4;
			pData[playerid][pMedkit] -= 3;
			Info(playerid, "Kamu Sudah memulihkan BodyCondition sebesar 100");
		}
		else if(pData[otherid][pStockBodyCondition][0] == 4)
		{
			if(pData[playerid][pBandage] <= 5)
				return Error(playerid, "Kamu harus mempunyai 5  bandage ");

			if(pData[playerid][pMedkit] <= 4)
				return Error(playerid, "Kamu harus mempunyai 4 Medkit");

			pData[otherid][pBodyCondition][0] = 100;
			pData[playerid][pBandage] -= 5;
			pData[playerid][pMedkit] -= 4;
			Info(playerid, "Kamu Sudah memulihkan BodyCondition sebesar 100");
		}
	}
	else if(strcmp(name,"torso",true) == 0)
	{

		if(pData[otherid][pStockBodyCondition][1] == 2)
		{
			if(pData[playerid][pBandage] <= 3)
				return Error(playerid, "Kamu harus mempunyai 3 bandage ");

			if(pData[playerid][pMedkit] <= 2)
				return Error(playerid, "Kamu harus mempunyai 2 Medkit");

			pData[otherid][pBodyCondition][1] = 100;
			pData[playerid][pBandage] -= 3;
			pData[playerid][pMedkit] -= 2;
			Info(playerid, "Kamu Sudah memulihkan BodyCondition sebesar 100");
		}
		else if(pData[otherid][pStockBodyCondition][1] == 3)
		{
			if(pData[playerid][pBandage] <= 4)
				return Error(playerid, "Kamu harus mempunyai 4 bandage ");

			if(pData[playerid][pMedkit] <= 3)
				return Error(playerid, "Kamu harus mempunyai 3 Medkit");

			pData[otherid][pBodyCondition][1] = 100;
			pData[playerid][pBandage] -= 4;
			pData[playerid][pMedkit] -= 3;
			Info(playerid, "Kamu Sudah memulihkan BodyCondition sebesar 100");
		}
		else if(pData[otherid][pStockBodyCondition][1] == 4)
		{
			if(pData[playerid][pBandage] <= 5)
				return Error(playerid, "Kamu harus mempunyai 5 bandage ");

			if(pData[playerid][pMedkit] <= 4)
				return Error(playerid, "Kamu harus mempunyai 4 Medkit");

			pData[otherid][pBodyCondition][1] = 100;
			pData[playerid][pBandage] -= 5;
			pData[playerid][pMedkit] -= 4;
			Info(playerid, "Kamu Sudah memulihkan BodyCondition sebesar 100");
		}
	}
	else if(strcmp(name,"ra",true) == 0)
	{

		if(pData[otherid][pStockBodyCondition][2] == 2)
		{
			if(pData[playerid][pBandage] <= 3)
				return Error(playerid, "Kamu harus mempunyai 3 bandage ");

			if(pData[playerid][pMedkit] <= 2)
				return Error(playerid, "Kamu harus mempunyai 2 Medkit");

			pData[otherid][pBodyCondition][2] = 100;
			pData[playerid][pBandage] -= 3;
			pData[playerid][pMedkit] -= 2;
			Info(playerid, "Kamu Sudah memulihkan BodyCondition sebesar 100");
		}
		else if(pData[otherid][pStockBodyCondition][2] == 3)
		{
			if(pData[playerid][pBandage] <= 4)
				return Error(playerid, "Kamu harus mempunyai 4 bandage ");

			if(pData[playerid][pMedkit] <= 3)
				return Error(playerid, "Kamu harus mempunyai 3 Medkit");

			pData[otherid][pBodyCondition][2] = 100;
			pData[playerid][pBandage] -= 4;
			pData[playerid][pMedkit] -= 3;
			Info(playerid, "Kamu Sudah memulihkan BodyCondition sebesar 100");
		}
		else if(pData[otherid][pStockBodyCondition][2] == 4)
		{
			if(pData[playerid][pBandage] <= 5)
				return Error(playerid, "Kamu harus mempunyai 5 bandage ");

			if(pData[playerid][pMedkit] <= 4)
				return Error(playerid, "Kamu harus mempunyai 4 Medkit");

			pData[otherid][pBodyCondition][2] = 100;
			pData[playerid][pBandage] -= 5;
			pData[playerid][pMedkit] -= 4;
			Info(playerid, "Kamu Sudah memulihkan BodyCondition sebesar 100");
		}
	}
	else if(strcmp(name,"la",true) == 0)
	{
		if(pData[otherid][pStockBodyCondition][3] == 2)
		{
			if(pData[playerid][pBandage] <= 3)
				return Error(playerid, "Kamu harus mempunyai 3 bandage ");

			if(pData[playerid][pMedkit] <= 2)
				return Error(playerid, "Kamu harus mempunyai 2 Medkit");

			pData[otherid][pBodyCondition][3] = 100;
			pData[playerid][pBandage] -= 3;
			pData[playerid][pMedkit] -= 2;
			Info(playerid, "Kamu Sudah memulihkan BodyCondition sebesar 100");
		}
		else if(pData[otherid][pStockBodyCondition][3] == 3)
		{
			if(pData[playerid][pBandage] <= 4)
				return Error(playerid, "Kamu harus mempunyai 4 bandage ");

			if(pData[playerid][pMedkit] <= 3)
				return Error(playerid, "Kamu harus mempunyai 3 Medkit");

			pData[otherid][pBodyCondition][3] = 100;
			pData[playerid][pBandage] -= 4;
			pData[playerid][pMedkit] -= 3;
			Info(playerid, "Kamu Sudah memulihkan BodyCondition sebesar 100");
		}
		else if(pData[otherid][pStockBodyCondition][3] == 4)
		{
			if(pData[playerid][pBandage] <= 5)
				return Error(playerid, "Kamu harus mempunyai 5 bandage ");

			if(pData[playerid][pMedkit] <= 4)
				return Error(playerid, "Kamu harus mempunyai 4 Medkit");

			pData[otherid][pBodyCondition][3] = 100;
			pData[playerid][pBandage] -= 5;
			pData[playerid][pMedkit] -= 4;
			Info(playerid, "Kamu Sudah memulihkan BodyCondition sebesar 100");
		}
	}
	else if(strcmp(name,"rl",true) == 0)
	{
		if(pData[otherid][pStockBodyCondition][4] == 2)
		{
			if(pData[playerid][pBandage] <= 3)
				return Error(playerid, "Kamu harus mempunyai 3 bandage ");

			if(pData[playerid][pMedkit] <= 2)
				return Error(playerid, "Kamu harus mempunyai 2 Medkit");

			pData[otherid][pBodyCondition][2] = 100;
			pData[playerid][pBandage] -= 3;
			pData[playerid][pMedkit] -= 2;
			Info(playerid, "Kamu Sudah memulihkan BodyCondition sebesar 100");
		}
		else if(pData[otherid][pStockBodyCondition][4] == 3)
		{
			if(pData[playerid][pBandage] <= 4)
				return Error(playerid, "Kamu harus mempunyai 4 bandage ");

			if(pData[playerid][pMedkit] <= 3)
				return Error(playerid, "Kamu harus mempunyai 3 Medkit");

			pData[otherid][pBodyCondition][2] = 100;
			pData[playerid][pBandage] -= 4;
			pData[playerid][pMedkit] -= 3;
			Info(playerid, "Kamu Sudah memulihkan BodyCondition sebesar 100");
		}
		else if(pData[otherid][pStockBodyCondition][4] == 4)
		{
			if(pData[playerid][pBandage] <= 5)
				return Error(playerid, "Kamu harus mempunyai 5 bandage ");

			if(pData[playerid][pMedkit] <= 4)
				return Error(playerid, "Kamu harus mempunyai 4 Medkit");

			pData[otherid][pBodyCondition][4] = 100;
			pData[playerid][pBandage] -= 5;
			pData[playerid][pMedkit] -= 4;
			Info(playerid, "Kamu Sudah memulihkan BodyCondition sebesar 100");
		}
	}
	else if(strcmp(name,"ll",true) == 0)
	{
		if(pData[otherid][pStockBodyCondition][5] == 2)
		{
			if(pData[playerid][pBandage] <= 3)
				return Error(playerid, "Kamu harus mempunyai 3 bandage ");

			if(pData[playerid][pMedkit] <= 2)
				return Error(playerid, "Kamu harus mempunyai 2 Medkit");

			pData[otherid][pBodyCondition][5] = 100;
			pData[playerid][pBandage] -= 3;
			pData[playerid][pMedkit] -= 2;
			Info(playerid, "Kamu Sudah memulihkan BodyCondition sebesar 100");
		}
		else if(pData[otherid][pStockBodyCondition][5] == 3)
		{
			if(pData[playerid][pBandage] <= 4)
				return Error(playerid, "Kamu harus mempunyai 4 bandage ");

			if(pData[playerid][pMedkit] <= 3)
				return Error(playerid, "Kamu harus mempunyai 3 Medkit");

			pData[otherid][pBodyCondition][5] = 100;
			pData[playerid][pBandage] -= 4;
			pData[playerid][pMedkit] -= 3;
			Info(playerid, "Kamu Sudah memulihkan BodyCondition sebesar 100");
		}
		else if(pData[otherid][pStockBodyCondition][5] == 4)
		{
			if(pData[playerid][pBandage] <= 5)
				return Error(playerid, "Kamu harus mempunyai 5 bandage ");

			if(pData[playerid][pMedkit] <= 4)
				return Error(playerid, "Kamu harus mempunyai 4 Medkit");

			pData[otherid][pBodyCondition][3] = 100;
			pData[playerid][pBandage] -= 5;
			pData[playerid][pMedkit] -= 4;
			Info(playerid, "Kamu Sudah memulihkan BodyCondition sebesar 100");
		}
	}
	return 1;
}
CMD:heal(playerid, params[])
{
	if(pData[playerid][pFaction] != 3)
        return Error(playerid, "You must be a samd officer.");

	if(pData[playerid][pMedkit] < 1) return Error(playerid, "You need Medkit.");
	new otherid;
	if(sscanf(params, "u", otherid))
        return Usage(playerid, "/heal [playerid/PartOfName]");

    if(otherid == INVALID_PLAYER_ID || !NearPlayer(playerid, otherid, 5.0))
        return Error(playerid, "That player is disconnected or not near you.");

    if(otherid == playerid)
        return Error(playerid, "You can't heal yourself.");

	pData[playerid][pMedkit]--;

	SetPlayerHealthEx(otherid, 100.0);

	SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "* %s has given medkit to %s with the right hand.", ReturnName(playerid), ReturnName(otherid));
    Info(otherid, "Officer %s has Recovery your character.", ReturnName(playerid));
	return 1;
}
/*
CMD:salve(playerid, params[])
{
	if(pData[playerid][pFaction] != 3)
        return Error(playerid, "You must be a samd officer.");
	
	if(pData[playerid][pMedicine] < 1) return Error(playerid, "You need Medicine.");
	new otherid;
	if(sscanf(params, "u", otherid))
        return Usage(playerid, "/salve [playerid/PartOfName]");

    if(otherid == INVALID_PLAYER_ID || !NearPlayer(playerid, otherid, 5.0))
        return Error(playerid, "That player is disconnected or not near you.");

    if(otherid == playerid)
        return Error(playerid, "You can't resalve yourself.");

    if(pData[otherid][pSick] == 0)
        return Error(playerid, "That player is not sick.");
	
	pData[playerid][pMedicine]--;
	
	//SetPlayerHealthEx(otherid, 50.0);
    //pData[otherid][pInjured] = 0;
	//pData[otherid][pHospital] = 0;
	pData[otherid][pHunger] += 20;
	pData[otherid][pEnergy] += 20;
	pData[otherid][pBladder] += 20;
	pData[otherid][pSick] = 0;
	pData[otherid][pSickTime] = 0;
    ClearAnimations(otherid);
	SetPlayerDrunkLevel(otherid, 0);
	
	SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "* %s has given medicine to %s with the right hand.", ReturnName(playerid), ReturnName(otherid));
    Info(otherid, "Officer %s has resalve your sick character.", ReturnName(playerid));
	return 1;
}*/

//SANEW Commands
CMD:sanaonline(playerid, params[])
{
	if(pData[playerid][pFaction] != 4)
        return Error(playerid, "You must be a sanew officer.");
	if(pData[playerid][pFactionRank] < 1)
		return Error(playerid, "You must be high rank!");
		
	new duty[16], lstr[1024];
	format(lstr, sizeof(lstr), "Name\tRank\tStatus\tDuty Time\n");
	foreach(new i: Player)
	{
		if(pData[i][pFaction] == 4)
		{
			switch(pData[i][pOnDuty])
			{
				case 0:
				{
					duty = "Off Duty";
				}
				case 1:
				{
					duty = ""BLUE_E"On Duty";
				}
			}
			format(lstr, sizeof(lstr), "%s%s(%d)\t%s(%d)\t%s\t%d detik", lstr, pData[i][pName], i, GetFactionRank(i), pData[i][pFactionRank], duty, pData[i][pOnDutyTime]);
			format(lstr, sizeof(lstr), "%s\n", lstr);
		}
	}
	format(lstr, sizeof(lstr), "%s\n", lstr);
	ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_TABLIST_HEADERS, "SANA Online", lstr, "Close", "");
	return 1;
}/*
CMD:oncam(playerid, params[])
{
	if(pData[playerid][pFaction] != 4)
        return Error(playerid, "You must be part of a news faction.");
    if(pData[playerid][pFaction] != 1)
        return Error(playerid, "You must be a sapd officer.");

    if(IsPlayerWatchingCamera(playerid))
    	return Error(playerid, "Kamu tidak bisa melakukan saat ini.");

    GivePlayerCamera(playerid);
    return 1;
}
CMD:offcam(playerid, params[])
{
	if(pData[playerid][pFaction] != 4)
        return Error(playerid, "You must be part of a news faction.");
    if(pData[playerid][pFaction] != 1)
        return Error(playerid, "You must be a sapd officer.");

    if(IsPlayerRecording(playerid))
    {
    	RemovePlayerCamera(playerid);
    }
    return 1;
}
CMD:viewcam(playerid, params[])
{
	if(pData[playerid][pFaction] != 4)
        return Error(playerid, "You must be part of a news faction.");
    if(pData[playerid][pFaction] != 1)
        return Error(playerid, "You must be a sapd officer.");

    if(IsPlayerRecording(playerid))
    	return Error(playerid, "Kmau tidak bsia melakukan itu saat ini.");

    if(IsPlayerWatchingPlayerCamera(playerid , cameraman))
    {
    	StartPlayerWatchingCamera(playerid, cameraman);
    }
  	return 1;
}*/
CMD:playradio(playerid, params[])
{
	if(pData[playerid][pFaction] != 4)
        return Error(playerid, "You must be part of a news faction.");

	new songname[128], tmp[512], Float:x, Float:y, Float:z;
	if(sscanf(params, "s[128]", songname))
		return Usage(playerid, "/playradio <link>");

	GetPlayerPos(playerid, x, y, z);
	format(tmp, sizeof(tmp), "%s", songname);
	format(ServerSong, 128, tmp);
	Song_Save();
	PlayAudioStreamForPlayer(playerid, ServerSong, x, y, z, 5.0, false);

	Info(playerid, "You Play Song %s.", songname);
	return 1;
}

CMD:broadcast(playerid, params[])
{
    if(pData[playerid][pFaction] != 4)
        return Error(playerid, "You must be part of a news faction.");

    //if(!IsSANEWCar(GetPlayerVehicleID(playerid)) || !IsPlayerInRangeOfPoint(playerid, 5, 255.63, 1757.39, 701.09))
    //    return Error(playerid, "You must be inside a news van or chopper or in sanew studio.");

    if(!pData[playerid][pBroadcast])
    {
        pData[playerid][pBroadcast] = true;

        SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "* %s has started a news broadcast.", ReturnName(playerid));
        Servers(playerid, "You have started a news broadcast (use \"/bc [broadcast text]\" to broadcast).");
    }
    else
    {
        pData[playerid][pBroadcast] = false;

        foreach (new i : Player) if(pData[i][pNewsGuest] == playerid) 
		{
            pData[i][pNewsGuest] = INVALID_PLAYER_ID;
        }
        SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "* %s has stopped a news broadcast.", ReturnName(playerid));
        Servers(playerid, "You have stopped the news broadcast.");
    }
    return 1;
}


CMD:bc(playerid, params[])
{
    if(pData[playerid][pFaction] != 4)
        return Error(playerid, "You must be part of a news faction.");

    if(isnull(params))
        return Usage(playerid, "/bc [broadcast text]");

    //if(!IsSANEWCar(GetPlayerVehicleID(playerid)) || !IsPlayerInRangeOfPoint(playerid, 5, 255.63, 1757.39, 701.09))
    //    return Error(playerid, "You must be inside a news van or chopper or in sanew studio.");

    if(!pData[playerid][pBroadcast])
        return Error(playerid, "You must be broadcasting to use this command.");

    if(strlen(params) > 64) {
        foreach (new i : Player) /*if(!pData[i][pDisableBC])*/ {
            SendClientMessageEx(i, COLOR_ORANGE, "[SANA] Reporter %s: %.64s", ReturnName(playerid), params);
            SendClientMessageEx(i, COLOR_ORANGE, "...%s", params[64]);
        }
    }
    else {
        foreach (new i : Player) /*if(!pData[i][pDisableBC])*/ {
            SendClientMessageEx(i, COLOR_ORANGE, "[SANA] Reporter %s: %s", ReturnName(playerid), params);
        }
    }
    return 1;
}

CMD:live(playerid, params[])
{
    static
        livechat[128];
        
    if(sscanf(params, "s[128]", livechat))
        return Usage(playerid, "/live [live chat]");

    if(pData[playerid][pNewsGuest] == INVALID_PLAYER_ID)
        return Error(playerid, "You're now invite by sanew member to live!");

    /*if(!IsNewsVehicle(GetPlayerVehicleID(playerid)) || !IsPlayerInRangeOfPoint(playerid, 5, 255.63, 1757.39, 701.09))
        return Error(playerid, "You must in news chopper or in studio to live.");*/

    if(pData[pData[playerid][pNewsGuest]][pFaction] == 4)
    {
        foreach (new i : Player) /*if(!pData[i][pDisableBC])*/ {
            SendClientMessageEx(i, COLOR_LIGHTGREEN, "[SANA] Guest %s: %s", ReturnName(playerid), livechat);
        }
    }
    return 1;
}

CMD:inviteguest(playerid, params[])
{
    if(pData[playerid][pFaction] != 4)
        return Error(playerid, "You must be part of a news faction.");
		
	new otherid;
    if(sscanf(params, "u", otherid))
        return Usage(playerid, "/inviteguest [playerid/PartOfName]");

    if(!pData[playerid][pBroadcast])
        return Error(playerid, "You must be broadcasting to use this command.");

    if(otherid == INVALID_PLAYER_ID || !NearPlayer(playerid, otherid, 5.0))
        return Error(playerid, "That player is disconnected or not near you.");

    if(otherid == playerid)
        return Error(playerid, "You can't add yourself as a guest.");

    if(pData[otherid][pNewsGuest] == playerid)
        return Error(playerid, "That player is already a guest of your broadcast.");

    if(pData[otherid][pNewsGuest] != INVALID_PLAYER_ID)
        return Error(playerid, "That player is already a guest of another broadcast.");

    pData[otherid][pNewsGuest] = playerid;

    Info(playerid, "You have added %s as a broadcast guest.", ReturnName(otherid));
    Info(otherid, "%s has added you as a broadcast guest ((/live to start broadcast)).", ReturnName(otherid));
    return 1;
}

CMD:removeguest(playerid, params[])
{

    if(pData[playerid][pFaction] != 4)
        return Error(playerid, "You must be part of a news faction.");
	new otherid;
    if(sscanf(params, "u", otherid))
        return Usage(playerid, "/removeguest [playerid/PartOfName]");

    if(!pData[playerid][pBroadcast])
        return Error(playerid, "You must be broadcasting to use this command.");

    if(otherid == INVALID_PLAYER_ID || !NearPlayer(playerid, otherid, 5.0))
        return Error(playerid, "That player is disconnected or not near you.");

    if(otherid == playerid)
        return Error(playerid, "You can't remove yourself as a guest.");

    if(pData[otherid][pNewsGuest] != playerid)
        return Error(playerid, "That player is not a guest of your broadcast.");

    pData[otherid][pNewsGuest] = INVALID_PLAYER_ID;

    Info(playerid, "You have removed %s from your broadcast.", ReturnName(otherid));
    Info(otherid, "%s has removed you from their broadcast.", ReturnName(otherid));
    return 1;
}
//GOJEK Commands
CMD:gojekonline(playerid, params[])
{
	if(pData[playerid][pFaction] != 5)
        return Error(playerid, "You must be a gojek driver.");
	if(pData[playerid][pFactionRank] < 1)
		return Error(playerid, "You must be high rank!");
		
	new duty[16], lstr[1024];
	format(lstr, sizeof(lstr), "Name\tRank\tStatus\tDuty Time\n");
	foreach(new i: Player)
	{
		if(pData[i][pFaction] == 5)
		{
			switch(pData[i][pOnDuty])
			{
				case 0:
				{
					duty = "Off Duty";
				}
				case 1:
				{
					duty = ""BLUE_E"On Duty";
				}
			}
			format(lstr, sizeof(lstr), "%s%s(%d)\t%s(%d)\t%s\t%d detik", lstr, pData[i][pName], i, GetFactionRank(i), pData[i][pFactionRank], duty, pData[i][pOnDutyTime]);
			format(lstr, sizeof(lstr), "%s\n", lstr);
		}
	}
	format(lstr, sizeof(lstr), "%s\n", lstr);
	ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_TABLIST_HEADERS, "GOJEK Online", lstr, "Close", "");
	return 1;
}

forward OnLightFlash(vehicleid);
public OnLightFlash(vehicleid)
{
    new panels, doors, lights, tires;
    GetVehicleDamageStatus(vehicleid, panels, doors, lights, tires);

	switch(Flash[vehicleid])
 	{
  		case 0: UpdateVehicleDamageStatus(vehicleid, panels, doors, 2, tires);

		case 1: UpdateVehicleDamageStatus(vehicleid, panels, doors, 5, tires);

		case 2: UpdateVehicleDamageStatus(vehicleid, panels, doors, 2, tires);

		case 3: UpdateVehicleDamageStatus(vehicleid, panels, doors, 4, tires);

		case 4: UpdateVehicleDamageStatus(vehicleid, panels, doors, 5, tires);

		case 5: UpdateVehicleDamageStatus(vehicleid, panels, doors, 4, tires);
  	}
  	if(Flash[vehicleid] >=5) Flash[vehicleid] = 0;
	else Flash[vehicleid] ++;
  	return 1;
}
//PEDAGANG COMMAND
CMD:ponline(playerid, params[])
{
	new duty[16], lstr[1024];
	format(lstr, sizeof(lstr), "Name\tRank\tStatus\tDuty Time\n");
	foreach(new i: Player)
	{
		if(pData[i][pFaction] == 5)
		{
			switch(pData[i][pOnDuty])
			{
				case 0:
				{
					duty = "Off Duty";
				}
				case 1:
				{
					duty = ""BLUE_E"On Duty";
				}
			}
			format(lstr, sizeof(lstr), "%s%s(%d)\t%s(%d)\t%s\t%d detik", lstr, pData[i][pName], i, GetFactionRank(i), pData[i][pFactionRank], duty, pData[i][pOnDutyTime]);
			format(lstr, sizeof(lstr), "%s\n", lstr);
		}
	}
	format(lstr, sizeof(lstr), "%s\n", lstr);
	ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_TABLIST_HEADERS, "PEDAGANG Online", lstr, "Close", "");
	return 1;
}
