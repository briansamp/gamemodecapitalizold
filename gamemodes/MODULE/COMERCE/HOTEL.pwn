//Hotel System
#define MAX_HOTELS	500
#define LIMIT_PER_PLAYER 3
#define Loop(%0,%1,%2) for(new %0 = %2; %0 < %1; %0++)

enum hotelinfo
{
	htOwner[MAX_PLAYER_NAME],
	htAddress[128],
	htPrice,
	htType,
	htLocked,
	htMoney,
	htWeapon[10],
	htAmmo[10],
	htInt,
	Float:htExtposX,
	Float:htExtposY,
	Float:htExtposZ,
	Float:htExtposA,
	Float:htIntposX,
	Float:htIntposY,
	Float:htIntposZ,
	Float:htIntposA,
	htVisit,
	//Not Saved
	htPickup,
	htCP,
	Text3D:htLabel
};

new htData[MAX_HOTELS][hotelinfo],
	Iterator: Hotels<MAX_HOTELS>;
	
Player_OwnsHotel(playerid, hotelid)
{
	if(hotelid == -1) return 0;
	if(!IsPlayerConnected(playerid)) return 0;
	if(!strcmp(htData[hotelid][htOwner], pData[playerid][pName], true)) return 1;
	return 0;
}

Player_HotelCount(playerid)
{
	#if LIMIT_PER_PLAYER != 0
    new count;
	foreach(new i : Hotels)
	{
		if(Player_OwnsHotel(playerid, i)) count++;
	}

	return count;
	#else
	return 0;
	#endif
}

HotelReset(hotelid)
{
	format(htData[hotelid][htOwner], MAX_PLAYER_NAME, "-");
	htData[hotelid][htLocked] = 1;
    htData[hotelid][htMoney] = 0;
	htData[hotelid][htWeapon] = 0;
	htData[hotelid][htAmmo] = 0;
	htData[hotelid][htVisit] = 0;
	Hotel_Type(hotelid);
	
	for (new i = 0; i < 10; i ++)
    {
        htData[hotelid][htWeapon][i] = 0;

		htData[hotelid][htAmmo][i] = 0;
    }
}
	
/*GetHotelOwnerID(hotelid)
{
	foreach(new i : Player)
	{
		if(!strcmp(htData[hotelid][htOwner], pData[i][pName], true)) return i;
	}
	return INVALID_PLAYER_ID;
}*/

Hotel_WeaponStorage(playerid, hotelid)
{
    if(hotelid == -1)
        return 0;

    static
        string[320];

    string[0] = 0;

    for (new i = 0; i < 5; i ++)
    {
        if(!htData[hotelid][htWeapon][i])
            format(string, sizeof(string), "%sEmpty Slot\n", string);

        else
            format(string, sizeof(string), "%s%s (Ammo: %d)\n", string, ReturnWeaponName(htData[hotelid][htWeapon][i]), htData[hotelid][htAmmo][i]);
    }
    ShowPlayerDialog(playerid, HOTEL_WEAPONS, DIALOG_STYLE_LIST, "Weapon Storage", string, "Select", "Cancel");
    return 1;
}

Hotel_OpenStorage(playerid, hotelid)
{
    if(hotelid == -1)
        return 0;

    new
        items[1],
        string[10 * 32];

    for (new i = 0; i < 5; i ++) if(htData[hotelid][htWeapon][i]) 
	{
        items[0]++;
    }
    if(!Player_OwnsHotel(playerid, hotelid))
        format(string, sizeof(string), "Weapon Storage (%d/5)", items[0]);

    else
        format(string, sizeof(string), "Weapon Storage (%d/5)\nMoney Safe (%s)", items[0], FormatMoney(htData[hotelid][htMoney]));

    ShowPlayerDialog(playerid, HOTEL_STORAGE, DIALOG_STYLE_LIST, "Hotel Storage", string, "Select", "Cancel");
    return 1;
}

GetOwnedHotels(playerid)
{
	new tmpcount;
	foreach(new hid : Hotels)
	{
	    if(!strcmp(htData[hid][htOwner], pData[playerid][pName], true))
	    {
     		tmpcount++;
		}
	}
	return tmpcount;
}
ReturnPlayerHotelsID(playerid, hslot)
{
	new tmpcount;
	if(hslot < 1 && hslot > LIMIT_PER_PLAYER) return -1;
	foreach(new hid : Hotels)
	{
	    if(!strcmp(pData[playerid][pName], htData[hid][htOwner], true))
	    {
     		tmpcount++;
       		if(tmpcount == hslot)
       		{
        		return hid;
  			}
	    }
	}
	return -1;
}

Hotel_Save(hotelid)
{
	new cQuery[1536];
	format(cQuery, sizeof(cQuery), "UPDATE hotels SET owner='%s', address='%s', price='%d', type='%d', locked='%d', money='%d'",
	htData[hotelid][htOwner],
	htData[hotelid][htAddress],
	htData[hotelid][htPrice],
	htData[hotelid][htType],
	htData[hotelid][htLocked],
	htData[hotelid][htMoney]
	);
	
	for (new i = 0; i < 10; i ++) 
	{
        format(cQuery, sizeof(cQuery), "%s, hotelWeapon%d='%d', hotelAmmo%d='%d'", cQuery, i + 1, htData[hotelid][htWeapon][i], i + 1, htData[hotelid][htAmmo][i]);
    }
	
	format(cQuery, sizeof(cQuery), "%s, hotelint='%d', extposx='%f', extposy='%f', extposz='%f', extposa='%f', intposx='%f', intposy='%f', intposz='%f', intposa='%f', visit='%d' WHERE ID='%d'",
        cQuery,
        htData[hotelid][htInt],
        htData[hotelid][htExtposX],
        htData[hotelid][htExtposY],
		htData[hotelid][htExtposZ],
		htData[hotelid][htExtposA],
		htData[hotelid][htIntposX],
		htData[hotelid][htIntposY],
		htData[hotelid][htIntposZ],
		htData[hotelid][htIntposA],
		htData[hotelid][htVisit],
        hotelid
    );
	return mysql_tquery(g_SQL, cQuery);
}

Hotel_Type(hotelid)
{
	if(htData[hotelid][htType] == 1)
	{
        htData[hotelid][htIntposX] = 1400.98;
        htData[hotelid][htIntposY] = -1205.21;
        htData[hotelid][htIntposZ] = 130.18;
        htData[hotelid][htIntposA] = 266.68;
        htData[hotelid][htInt] = 0;
	}
}
  
Hotel_Refresh(hotelid)
{
    if(hotelid != -1)
    {
        if(IsValidDynamic3DTextLabel(htData[hotelid][htLabel]))
            DestroyDynamic3DTextLabel(htData[hotelid][htLabel]);

        if(IsValidDynamicPickup(htData[hotelid][htPickup]))
            DestroyDynamicPickup(htData[hotelid][htPickup]);
			
		if(IsValidDynamicCP(htData[hotelid][htCP]))
            DestroyDynamicCP(htData[hotelid][htCP]);

        static
        string[255];
		
		new type[128];
		if(htData[hotelid][htType] == 1)
		{
			type= "Small";
		}
		/*else if(htData[hotelid][htType] == 2)
		{
			type= "Medium";
		}
		else if(htData[hotelid][htType] == 3)
		{
			type= "Large";
		}*/
		else
		{
			type= "Unknow";
		}

        if(strcmp(htData[hotelid][htOwner], "-"))
		{
			format(string, sizeof(string), "[ID: %d]\n{FFFFFF}Hotel Location {FFFF00}%s\n{FFFFFF}Hotel Type {FFFF00}%s\n"WHITE_E"Owned by %s\nPress '{FF0000}F{FFFFFF}' To Enter", hotelid, GetLocation(htData[hotelid][htExtposX], htData[hotelid][htExtposY], htData[hotelid][htExtposZ]), type, htData[hotelid][htOwner]);
			htData[hotelid][htPickup] = CreateDynamicPickup(1272, 23, htData[hotelid][htExtposX], htData[hotelid][htExtposY], htData[hotelid][htExtposZ]+0.2, 0, 0, _, 10.0);
			//htData[hotelid][htCP] = CreateDynamicCP(htData[hotelid][htExtposX], htData[hotelid][htExtposY], htData[hotelid][htExtposZ], 3.0, hotelid);
        }
        else
        {
            format(string, sizeof(string), "[ID: %d]\n{FFFFFF}This hotel for sell\n{FFFFFF}Hotel Location: {FFFF00}%s\n{FFFFFF}Hotel Type: {FFFF00}%s\n{FFFFFF}Hotel Price: {FFFF00}%s\n"WHITE_E"Type /buy to purchase", hotelid, GetLocation(htData[hotelid][htExtposX], htData[hotelid][htExtposY], htData[hotelid][htExtposZ]), type, FormatMoney(htData[hotelid][htPrice]));
            htData[hotelid][htPickup] = CreateDynamicPickup(1272, 23, htData[hotelid][htExtposX], htData[hotelid][htExtposY], htData[hotelid][htExtposZ]+0.2, 0, 0, _, 10.0);
            //htData[hotelid][htCP] = CreateDynamicCP(htData[hotelid][htExtposX], htData[hotelid][htExtposY], htData[hotelid][htExtposZ], 3.0, hotelid);
        }
        htData[hotelid][htLabel] = CreateDynamic3DTextLabel(string, COLOR_LBLUE, htData[hotelid][htExtposX], htData[hotelid][htExtposY], htData[hotelid][htExtposZ]+0.5, 2.5, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1, 0, 0);
    }
    return 1;
}

function LoadHotels()
{
    static
        str[128],
		hid;
		
	new rows = cache_num_rows(), owner[128], address[128];
 	if(rows)
  	{
		for(new i; i < rows; i++)
		{
			cache_get_value_name_int(i, "ID", hid);
			cache_get_value_name(i, "owner", owner);
			format(htData[hid][htOwner], 128, owner);
			cache_get_value_name(i, "address", address);
			format(htData[hid][htAddress], 128, address);
			cache_get_value_name_int(i, "price", htData[hid][htPrice]);
			cache_get_value_name_int(i, "type", htData[hid][htType]);
			cache_get_value_name_float(i, "extposx", htData[hid][htExtposX]);
			cache_get_value_name_float(i, "extposy", htData[hid][htExtposY]);
			cache_get_value_name_float(i, "extposz", htData[hid][htExtposZ]);
			cache_get_value_name_float(i, "extposa", htData[hid][htExtposA]);
			cache_get_value_name_float(i, "intposx", htData[hid][htIntposX]);
			cache_get_value_name_float(i, "intposy", htData[hid][htIntposY]);
			cache_get_value_name_float(i, "intposz", htData[hid][htIntposZ]);
			cache_get_value_name_float(i, "intposa", htData[hid][htIntposA]);
			cache_get_value_name_int(i, "hotelint", htData[hid][htInt]);
			cache_get_value_name_int(i, "money", htData[hid][htMoney]);
			cache_get_value_name_int(i, "locked", htData[hid][htLocked]);
			cache_get_value_name_int(i, "visit", htData[hid][htVisit]);

			for (new j = 0; j < 10; j ++)
			{
				format(str, 24, "hotelWeapon%d", j + 1);
				cache_get_value_name_int(i, str, htData[hid][htWeapon][j]);

				format(str, 24, "hotelAmmo%d", j + 1);
				cache_get_value_name_int(i, str, htData[hid][htAmmo][j]);
			}
			Hotel_Refresh(hid);
			Iter_Add(Hotels, hid);
		}
		printf("[Hotels] Number of Loaded: %d.", rows);
	}
}

//----------[ Hotel Commands ]--------
//Hotel System
CMD:createhotel(playerid, params[])
{
	if(pData[playerid][pAdmin] < 1)
		return PermissionError(playerid);
	
	new hid = Iter_Free(Hotels), address[128];
	if(hid == -1) return Error(playerid, "You Can Create More Hotel!");
	new price, type, query[512];
	if(sscanf(params, "dd", price, type)) return Usage(playerid, "/createhotel [price] [type, 1.small 2.medium 3.Big]");
	format(htData[hid][htOwner], 128, "-");
	GetPlayerPos(playerid, htData[hid][htExtposX], htData[hid][htExtposY], htData[hid][htExtposZ]);
	GetPlayerFacingAngle(playerid, htData[hid][htExtposA]);
	htData[hid][htPrice] = price;
	htData[hid][htType] = type;
	address = GetLocation(htData[hid][htExtposX], htData[hid][htExtposY], htData[hid][htExtposZ]);
	format(htData[hid][htAddress], 128, address);
	htData[hid][htLocked] = 1;
	htData[hid][htMoney] = 0;
	htData[hid][htInt] = 0;
	htData[hid][htIntposX] = 0;
	htData[hid][htIntposY] = 0;
	htData[hid][htIntposZ] = 0;
	htData[hid][htIntposA] = 0;
	htData[hid][htVisit] = 0;
	Hotel_Type(hid);
	
	for (new i = 0; i < 10; i ++) 
	{
        htData[hid][htWeapon][i] = 0;
        htData[hid][htAmmo][i] = 0;
    }
    Hotel_Refresh(hid);
	Iter_Add(Hotels, hid);

	mysql_format(g_SQL, query, sizeof(query), "INSERT INTO hotels SET ID='%d', owner='%s', price='%d', type='%d', extposx='%f', extposy='%f', extposz='%f', extposa='%f', address='%s'", hid, htData[hid][htOwner], htData[hid][htPrice], htData[hid][htType], htData[hid][htExtposX], htData[hid][htExtposY], htData[hid][htExtposZ], htData[hid][htExtposA], htData[hid][htAddress]);
	mysql_tquery(g_SQL, query, "OnHotelsCreated", "i", hid);
	return 1;
}

function OnHotelsCreated(hid)
{
	Hotel_Save(hid);
	return 1;
}

CMD:gotohotel(playerid, params[])
{
	new hid;
	if(pData[playerid][pAdmin] < 2)
        return PermissionError(playerid);
		
	if(sscanf(params, "d", hid))
		return Usage(playerid, "/gotohotel [id]");
	if(!Iter_Contains(Hotels, hid)) return Error(playerid, "The doors you specified ID of doesn't exist.");
	SetPlayerPosition(playerid, htData[hid][htExtposX], htData[hid][htExtposY], htData[hid][htExtposZ], htData[hid][htExtposA]);
    SetPlayerInterior(playerid, 0);
    SetPlayerVirtualWorld(playerid, 0);
	SendClientMessageEx(playerid, COLOR_WHITE, "You has teleport to hotel id %d", hid);
	pData[playerid][pInDoor] = -1;
	pData[playerid][pInHotel] = -1;
	pData[playerid][pInBiz] = -1;
	return 1;
}

/*CMD:typehotels(playerid, params[])
{
	if(pData[playerid][pAdmin] < 6)
        return PermissionError(playerid);
	
	new count = 0;
	foreach(new hid : Hotels)
	{
		if(htData[hid][htType] == 1)
		{
			Hotel_Type(hid);
			Hotel_Refresh(hid);
			Hotel_Save(hid);
		}
		if(htData[hid][htType] == 2)
		{
			Hotel_Type(hid);
			Hotel_Refresh(hid);
			Hotel_Save(hid);
		}
		if(htData[hid][htType] == 3)
		{
			Hotel_Type(hid);
			Hotel_Refresh(hid);
			Hotel_Save(hid);
		}
		count++;
	}
	Servers(playerid, "Anda telah me reset hotel interior type sebanyak %d rumah.", count);
	return 1;
}*/

CMD:edithotel(playerid, params[])
{
    static
        hid,
        type[24],
        string[128];

    if(pData[playerid][pAdmin] < 6)
        return PermissionError(playerid);

    if(sscanf(params, "ds[24]S()[128]", hid, type, string))
    {
        Usage(playerid, "/edithotel [id] [name]");
        SendClientMessage(playerid, COLOR_YELLOW, "[NAMES]:{FFFFFF} location, interior, locked, owner, price, type, reset, delete");
        return 1;
    }
    if((hid < 0 || hid >= MAX_HOTELS))
        return Error(playerid, "You have specified an invalid ID.");
	if(!Iter_Contains(Hotels, hid)) return Error(playerid, "The doors you specified ID of doesn't exist.");

    if(!strcmp(type, "location", true))
    {
		GetPlayerPos(playerid, htData[hid][htExtposX], htData[hid][htExtposY], htData[hid][htExtposZ]);
		GetPlayerFacingAngle(playerid, htData[hid][htExtposA]);
        Hotel_Save(hid);
		Hotel_Refresh(hid);

        SendAdminMessage(COLOR_LOGS, "%s Changes Location Of The Hotel ID: %d.", pData[playerid][pAdminname], hid);
    }
    else if(!strcmp(type, "interior", true))
    {
        GetPlayerPos(playerid, htData[hid][htIntposX], htData[hid][htIntposY], htData[hid][htIntposZ]);
		GetPlayerFacingAngle(playerid, htData[hid][htIntposA]);
		htData[hid][htInt] = GetPlayerInterior(playerid);

        Hotel_Save(hid);
		Hotel_Refresh(hid);

       /*foreach (new i : Player)
        {
            if(pData[i][pEntrance] == EntranceData[id][entranceID])
            {
                SetPlayerPos(i, EntranceData[id][entranceInt][0], EntranceData[id][entranceInt][1], EntranceData[id][entranceInt][2]);
                SetPlayerFacingAngle(i, EntranceData[id][entranceInt][3]);

                SetPlayerInterior(i, EntranceData[id][entranceInterior]);
                SetCameraBehindPlayer(i);
            }
        }*/
        SendAdminMessage(COLOR_LOGS, "%s Changes Interior Of The HOTEL ID: %d.", pData[playerid][pAdminname], hid);
    }
    else if(!strcmp(type, "locked", true))
    {
        new locked;

        if(sscanf(string, "d", locked))
            return Usage(playerid, "/edithotel [id] [locked] [0/1]");

        if(locked < 0 || locked > 1)
            return Error(playerid, "You must specify at least 0 or 1.");

        htData[hid][htLocked] = locked;
        Hotel_Save(hid);
		Hotel_Refresh(hid);

        if(locked) {
            SendAdminMessage(COLOR_LOGS, "%s Has Locked Of The Hotel ID: %d.", pData[playerid][pAdminname], hid);
        }
        else {
            SendAdminMessage(COLOR_LOGS, "%s Has Unclocked Of The Hotel ID: %d.", pData[playerid][pAdminname], hid);
        }
    }
    else if(!strcmp(type, "price", true))
    {
        new price;

        if(sscanf(string, "d", price))
            return Usage(playerid, "/edithotel [id] [Price] [Amount]");

        htData[hid][htPrice] = price;

        Hotel_Save(hid);
		Hotel_Refresh(hid);
        SendAdminMessage(COLOR_LOGS, "%s Changes Price Of The Hotel ID: %d to %d.", pData[playerid][pAdminname], hid, price);
    }
	else if(!strcmp(type, "type", true))
    {
        new httype;

        if(sscanf(string, "d", httype))
            return Usage(playerid, "/edithotel [id] [Type] [1.small 2.medium 3.Big]");

        htData[hid][htType] = httype;
		Hotel_Type(hid);
        Hotel_Save(hid);
		Hotel_Refresh(hid);
        SendAdminMessage(COLOR_LOGS, "%s Changes Type Of The Hotel ID: %d to %d.", pData[playerid][pAdminname], hid, httype);
    }
    else if(!strcmp(type, "owner", true))
    {
        new owners[MAX_PLAYER_NAME];

        if(sscanf(string, "s[32]", owners))
            return Usage(playerid, "/edithotel [id] [owner] [player name] (use '-' to no owner)");

        format(htData[hid][htOwner], MAX_PLAYER_NAME, owners);
  
        Hotel_Save(hid);
		Hotel_Refresh(hid);
        SendAdminMessage(COLOR_LOGS, "%s Changes Owner Of The Hotel ID: %d to %s", pData[playerid][pAdminname], hid, owners);
    }
    else if(!strcmp(type, "reset", true))
    {
        HotelReset(hid);
		Hotel_Save(hid);
		Hotel_Refresh(hid);
        SendAdminMessage(COLOR_LOGS, "%s Has Reset Of The Hotel ID: %d.", pData[playerid][pAdminname], hid);
    }
	else if(!strcmp(type, "delete", true))
	{
		HotelReset(hid);
		
		DestroyDynamic3DTextLabel(htData[hid][htLabel]);
        DestroyDynamicPickup(htData[hid][htPickup]);
        DestroyDynamicCP(htData[hid][htCP]);
		
		htData[hid][htExtposX] = 0;
		htData[hid][htExtposY] = 0;
		htData[hid][htExtposZ] = 0;
		htData[hid][htExtposA] = 0;
		htData[hid][htPrice] = 0;
		htData[hid][htInt] = 0;
		htData[hid][htIntposX] = 0;
		htData[hid][htIntposY] = 0;
		htData[hid][htIntposZ] = 0;
		htData[hid][htIntposA] = 0;
		htData[hid][htLabel] = Text3D: INVALID_3DTEXT_ID;
		htData[hid][htPickup] = -1;
		
		Iter_Remove(Hotels, hid);
		new query[128];
		mysql_format(g_SQL, query, sizeof(query), "DELETE FROM hotels WHERE ID=%d", hid);
		mysql_tquery(g_SQL, query);
        SendAdminMessage(COLOR_LOGS, "%s Has Delete Of The Hotel ID: %d.", pData[playerid][pAdminname], hid);
	}
    return 1;
}

CMD:lockhotel(playerid, params[])
{
	foreach(new hid : Hotels)
	{
		if(IsPlayerInRangeOfPoint(playerid, 2.5, htData[hid][htExtposX], htData[hid][htExtposY], htData[hid][htExtposZ]))
		{
			if(!Player_OwnsHotel(playerid, hid)) return Error(playerid, "You don't own this hotel.");
			if(!htData[hid][htLocked])
			{
				htData[hid][htLocked] = 1;
				Hotel_Save(hid);

				InfoTD_MSG(playerid, 4000, "You have ~r~locked~w~ your hotel!");
				PlayerPlaySound(playerid, 1145, 0.0, 0.0, 0.0);
			}
			else
			{
				htData[hid][htLocked] = 0;
				Hotel_Save(hid);

				InfoTD_MSG(playerid, 4000,"You have ~g~unlocked~w~ your hotel!");
				PlayerPlaySound(playerid, 1145, 0.0, 0.0, 0.0);
			}
		}
	}
	return 1;
}

CMD:givehotel(playerid, params[])
{
	new hid, otherid;
	if(sscanf(params, "ud", otherid, hid)) return Usage(playerid, "/givehotel [playerid/name] [id] | /myhotel - for show info");
	if(hid == -1) return Error(playerid, "Invalid id");
	
	if(!IsPlayerConnected(otherid) || !NearPlayer(playerid, otherid, 4.0))
        return Error(playerid, "The specified player is disconnected or not near you.");
	
	if(!Player_OwnsHotel(playerid, hid)) return Error(playerid, "You dont own this id hotel.");
	
	if(pData[otherid][pVip] == 1)
	{
		#if LIMIT_PER_PLAYER > 0
		if(Player_HotelCount(otherid) + 1 > 2) return Error(playerid, "Target player cant own any more hotels.");
		#endif
	}
	else if(pData[otherid][pVip] == 2)
	{
		#if LIMIT_PER_PLAYER > 0
		if(Player_HotelCount(otherid) + 1 > 3) return Error(playerid, "Target player cant own any more hotels.");
		#endif
	}
	else if(pData[otherid][pVip] == 3)
	{
		#if LIMIT_PER_PLAYER > 0
		if(Player_HotelCount(otherid) + 1 > 4) return Error(playerid, "Target player cant own any more hotels.");
		#endif
	}
	else
	{
		#if LIMIT_PER_PLAYER > 0
		if(Player_HotelCount(otherid) + 1 > 1) return Error(playerid, "Target player cant own any more hotels.");
		#endif
	}
	GetPlayerName(otherid, htData[hid][htOwner], MAX_PLAYER_NAME);
	htData[hid][htVisit] = gettime();
	
	Hotel_Refresh(hid);
	Hotel_Save(hid);
	Info(playerid, "Anda memberikan rumah id: %d kepada %s", hid, ReturnName(otherid));
	Info(otherid, "%s memberikan rumah id: %d kepada anda", hid, ReturnName(playerid));
	return 1;
}

CMD:sellhotel(playerid, params[])
{
	if(!IsPlayerInRangeOfPoint(playerid, 3.0, 1392.77, -22.25, 1000.97)) return Error(playerid, "Anda harus berada di City Hall!");
	if(GetOwnedHotels(playerid) == -1) return Error(playerid, "You don't have a hotels.");
	//if(!Player_OwnsBusiness(playerid, id)) return Error(playerid, "You don't own this business.");
	new hid, _tmpstring[128], count = GetOwnedHotels(playerid), CMDSString[1024];
	CMDSString = "";
	new lock[128];
	Loop(itt, (count + 1), 1)
	{
	    hid = ReturnPlayerHotelsID(playerid, itt);
		if(htData[hid][htLocked] == 1)
		{
			lock = "{FF0000}Locked";
		
		}
		else
		{
			lock = "{00FF00}Unlocked";
		}
		if(itt == count)
		{
		    format(_tmpstring, sizeof(_tmpstring), ""LB_E"%d.\t{FFFF2A}%s   (%s{FFFF2A})\n", itt, htData[hid][htAddress], lock);
		}
		else format(_tmpstring, sizeof(_tmpstring), ""LB_E"%d.\t{FFFF2A}%s  (%s{FFFF2A})\n", itt, htData[hid][htAddress], lock);
		strcat(CMDSString, _tmpstring);
	}
	ShowPlayerDialog(playerid, DIALOG_SELL_HOTELS, DIALOG_STYLE_LIST, "Sell Hotels", CMDSString, "Sell", "Cancel");
	return 1;
}

CMD:myhotel(playerid)
{
	if(GetOwnedHotels(playerid) == -1) return Error(playerid, "You don't have a hotels.");
	//if(!Player_OwnsBusiness(playerid, id)) return Error(playerid, "You don't own this business.");
	new hid, _tmpstring[128], count = GetOwnedHotels(playerid), CMDSString[1024];
	CMDSString = "";
	new lock[128];
	Loop(itt, (count + 1), 1)
	{
	    hid = ReturnPlayerHotelsID(playerid, itt);
		if(htData[hid][htLocked] == 1)
		{
			lock = "{FF0000}Locked";
		
		}
		else
		{
			lock = "{00FF00}Unlocked";
		}
		if(itt == count)
		{
		    format(_tmpstring, sizeof(_tmpstring), ""LB_E"%d.\t{FFFF2A}%s   (%s)\n", itt, htData[hid][htAddress], lock);
		}
		else format(_tmpstring, sizeof(_tmpstring), ""LB_E"%d.\t{FFFF2A}%s  (%s)\n", itt, htData[hid][htAddress], lock);
		strcat(CMDSString, _tmpstring);
	}
	ShowPlayerDialog(playerid, DIALOG_MY_HOTELS, DIALOG_STYLE_LIST, "{FF0000}HBPR:RP: {0000FF}Hotels", CMDSString, "Select", "Cancel");
	return 1;
}

CMD:htm(playerid, params[])
{
	if(!Player_OwnsHotel(playerid, pData[playerid][pInHotel])) 
		if(pData[playerid][pFaction] != 1)
			return Error(playerid, "You don't own this hotel.");
	Hotel_OpenStorage(playerid, pData[playerid][pInHotel]);
    return 1;
}

//--------------[ Hotel Dialog ]----------
