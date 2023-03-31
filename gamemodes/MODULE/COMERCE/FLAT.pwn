//Flat System
#define MAX_FLATS	500
#define LIMIT_PER_PLAYER 3
#define Loop(%0,%1,%2) for(new %0 = %2; %0 < %1; %0++)

enum flatinfo
{
	flOwner[MAX_PLAYER_NAME],
	flAddress[128],
	flPrice,
	flType,
	flLocked,
	flMoney,
	flWeapon[10],
	flAmmo[10],
	flInt,
	Float:flExtposX,
	Float:flExtposY,
	Float:flExtposZ,
	Float:flExtposA,
	Float:flIntposX,
	Float:flIntposY,
	Float:flIntposZ,
	Float:flIntposA,
	flVisit,
	//Not Saved
	flPickup,
	flCP,
	Text3D:flLabel
};

new flData[MAX_FLATS][flatinfo],
	Iterator: Flats<MAX_FLATS>;
	
Player_OwnsFlat(playerid, flatid)
{
	if(flatid == -1) return 0;
	if(!IsPlayerConnected(playerid)) return 0;
	if(!strcmp(flData[flatid][flOwner], pData[playerid][pName], true)) return 1;
	return 0;
}

Player_FlatCount(playerid)
{
	#if LIMIT_PER_PLAYER != 0
    new count;
	foreach(new i : Flats)
	{
		if(Player_OwnsFlat(playerid, i)) count++;
	}

	return count;
	#else
	return 0;
	#endif
}

FlatReset(flatid)
{
	format(flData[flatid][flOwner], MAX_PLAYER_NAME, "-");
	flData[flatid][flLocked] = 1;
    flData[flatid][flMoney] = 0;
	flData[flatid][flWeapon] = 0;
	flData[flatid][flAmmo] = 0;
	flData[flatid][flVisit] = 0;
	Flat_Type(flatid);
	
	for (new i = 0; i < 10; i ++)
    {
        flData[flatid][flWeapon][i] = 0;

		flData[flatid][flAmmo][i] = 0;
    }
}
	
/*GetFlatOwnerID(flatid)
{
	foreach(new i : Player)
	{
		if(!strcmp(flData[flatid][flOwner], pData[i][pName], true)) return i;
	}
	return INVALID_PLAYER_ID;
}*/

Flat_WeaponStorage(playerid, flatid)
{
    if(flatid == -1)
        return 0;

    static
        string[320];

    string[0] = 0;

    for (new i = 0; i < 5; i ++)
    {
        if(!flData[flatid][flWeapon][i])
            format(string, sizeof(string), "%sEmpty Slot\n", string);

        else
            format(string, sizeof(string), "%s%s (Ammo: %d)\n", string, ReturnWeaponName(flData[flatid][flWeapon][i]), flData[flatid][flAmmo][i]);
    }
    ShowPlayerDialog(playerid, FLAT_WEAPONS, DIALOG_STYLE_LIST, "Weapon Storage", string, "Select", "Cancel");
    return 1;
}

Flat_OpenStorage(playerid, flatid)
{
    if(flatid == -1)
        return 0;

    new
        items[1],
        string[10 * 32];

    for (new i = 0; i < 5; i ++) if(flData[flatid][flWeapon][i]) 
	{
        items[0]++;
    }
    if(!Player_OwnsFlat(playerid, flatid))
        format(string, sizeof(string), "Weapon Storage (%d/5)", items[0]);

    else
        format(string, sizeof(string), "Weapon Storage (%d/5)\nMoney Safe (%s)", items[0], FormatMoney(flData[flatid][flMoney]));

    ShowPlayerDialog(playerid, FLAT_STORAGE, DIALOG_STYLE_LIST, "Flat Storage", string, "Select", "Cancel");
    return 1;
}

GetOwnedFlats(playerid)
{
	new tmpcount;
	foreach(new hid : Flats)
	{
	    if(!strcmp(flData[hid][flOwner], pData[playerid][pName], true))
	    {
     		tmpcount++;
		}
	}
	return tmpcount;
}
ReturnPlayerFlatsID(playerid, hslot)
{
	new tmpcount;
	if(hslot < 1 && hslot > LIMIT_PER_PLAYER) return -1;
	foreach(new hid : Flats)
	{
	    if(!strcmp(pData[playerid][pName], flData[hid][flOwner], true))
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

Flat_Save(flatid)
{
	new cQuery[1536];
	format(cQuery, sizeof(cQuery), "UPDATE flats SET owner='%s', address='%s', price='%d', type='%d', locked='%d', money='%d'",
	flData[flatid][flOwner],
	flData[flatid][flAddress],
	flData[flatid][flPrice],
	flData[flatid][flType],
	flData[flatid][flLocked],
	flData[flatid][flMoney]
	);
	
	for (new i = 0; i < 10; i ++) 
	{
        format(cQuery, sizeof(cQuery), "%s, flatWeapon%d='%d', flatAmmo%d='%d'", cQuery, i + 1, flData[flatid][flWeapon][i], i + 1, flData[flatid][flAmmo][i]);
    }
	
	format(cQuery, sizeof(cQuery), "%s, flatint='%d', extposx='%f', extposy='%f', extposz='%f', extposa='%f', intposx='%f', intposy='%f', intposz='%f', intposa='%f', visit='%d' WHERE ID='%d'",
        cQuery,
        flData[flatid][flInt],
        flData[flatid][flExtposX],
        flData[flatid][flExtposY],
		flData[flatid][flExtposZ],
		flData[flatid][flExtposA],
		flData[flatid][flIntposX],
		flData[flatid][flIntposY],
		flData[flatid][flIntposZ],
		flData[flatid][flIntposA],
		flData[flatid][flVisit],
        flatid
    );
	return mysql_tquery(g_SQL, cQuery);
}

Flat_Type(flatid)
{
	if(flData[flatid][flType] == 1)
	{
	    switch(random(1))
		{
			case 0://apart
			{
				flData[flatid][flIntposX] = 1430.3279;
				flData[flatid][flIntposY] = -1221.1814;
				flData[flatid][flIntposZ] = 152.8182;
				flData[flatid][flIntposA] = 259.8793;
				flData[flatid][flInt] = 1;
			}
		}
	}
	if(flData[flatid][flType] == 2)
	{
	    switch(random(3))
		{
			case 0:
			{
				flData[flatid][flIntposX] = 736.03;
				flData[flatid][flIntposY] = 1672.08;
				flData[flatid][flIntposZ] = 501.08;
				flData[flatid][flIntposA] = 356.23;
				flData[flatid][flInt] = 1;
			}
			case 1:
			{
				flData[flatid][flIntposX] = 338.78;
				flData[flatid][flIntposY] = 1734.95;
				flData[flatid][flIntposZ] = 1002.08;
				flData[flatid][flIntposA] = 268.46;
				flData[flatid][flInt] = 1;
			}
			case 2:
			{
				flData[flatid][flIntposX] = 351.59;
				flData[flatid][flIntposY] = 1669.31;
				flData[flatid][flIntposZ] = 1002.17;
				flData[flatid][flIntposA] = 176.03;
				flData[flatid][flInt] = 1;
			}
			/*case 0:
			{
				flData[flatid][flIntposX] = 235.25;
				flData[flatid][flIntposY] = 1186.68;
				flData[flatid][flIntposZ] = 1080.25;
				flData[flatid][flIntposA] = 10.63;
				flData[flatid][flInt] = 3;
			}
			case 1:
			{
				flData[flatid][flIntposX] = 295.04;
				flData[flatid][flIntposY] = 1472.60;
				flData[flatid][flIntposZ] = 1080.25;
				flData[flatid][flIntposA] = 3.49;
				flData[flatid][flInt] = 15;
			}
			case 2:
			{
				flData[flatid][flIntposX] = 24.13;
				flData[flatid][flIntposY] = 1340.47;
				flData[flatid][flIntposZ] = 1084.37;
				flData[flatid][flIntposA] = 0.72;
				flData[flatid][flInt] = 10;
			}
			case 3:
			{
				flData[flatid][flIntposX] = -260.73;
				flData[flatid][flIntposY] = 1456.78;
				flData[flatid][flIntposZ] = 1084.36;
				flData[flatid][flIntposA] = 97.64;
				flData[flatid][flInt] = 4;
			}
			case 4:
			{
				flData[flatid][flIntposX] = 83.28;
				flData[flatid][flIntposY] = 1322.48;
				flData[flatid][flIntposZ] = 1083.86;
				flData[flatid][flIntposA] = 354.73;
				flData[flatid][flInt] = 9;
			}*/
		}
	}
	if(flData[flatid][flType] == 3)
	{
	    switch(random(4))
		{
			case 0:
			{
				flData[flatid][flIntposX] = 1855.38;
				flData[flatid][flIntposY] = -1709.12;
				flData[flatid][flIntposZ] = 1720.06;
				flData[flatid][flIntposA] = 273.58;
				flData[flatid][flInt] = 1;
			}
			case 1:
			{
				flData[flatid][flIntposX] = 4577.82;
				flData[flatid][flIntposY] = -2527.82;
				flData[flatid][flIntposZ] = 5.28;
				flData[flatid][flIntposA] = 262.63;
				flData[flatid][flInt] = 1;
			}
			case 2:
			{
				flData[flatid][flIntposX] = 1263.68;
				flData[flatid][flIntposY] = -605.30;
				flData[flatid][flIntposZ] = 1001.08;
				flData[flatid][flIntposA] = 189.50;
				flData[flatid][flInt] = 1;
			}
			case 3:
			{
				flData[flatid][flIntposX] = 1224.34;
				flData[flatid][flIntposY] = -749.22;
				flData[flatid][flIntposZ] = 1085.72;
				flData[flatid][flIntposA] = 265.59;
				flData[flatid][flInt] = 1;
			}
			/*case 0:
			{
				flData[flatid][flIntposX] = 226.70;
				flData[flatid][flIntposY] = 1114.22;
				flData[flatid][flIntposZ] = 1080.99;
				flData[flatid][flIntposA] = 267.25;
				flData[flatid][flInt] = 5;
			}
			case 1:
			{
				flData[flatid][flIntposX] = 2323.84;
				flData[flatid][flIntposY] = -1149.33;
				flData[flatid][flIntposZ] = 1050.71;
				flData[flatid][flIntposA] = 8.92;
				flData[flatid][flInt] = 12;
			}
			case 2:
			{
				flData[flatid][flIntposX] = 139.83;
				flData[flatid][flIntposY] = 1366.16;
				flData[flatid][flIntposZ] = 1083.85;
				flData[flatid][flIntposA] = 354.86;
				flData[flatid][flInt] = 5;
			}
			case 3:
			{
				flData[flatid][flIntposX] = 234.04;
				flData[flatid][flIntposY] = 1063.92;
				flData[flatid][flIntposZ] = 1084.21;
				flData[flatid][flIntposA] = 351.12;
				flData[flatid][flInt] = 6;
			}*/
		}
	}
}

Flat_Refresh(flatid)
{
    if(flatid != -1)
    {
        if(IsValidDynamic3DTextLabel(flData[flatid][flLabel]))
            DestroyDynamic3DTextLabel(flData[flatid][flLabel]);

        if(IsValidDynamicPickup(flData[flatid][flPickup]))
            DestroyDynamicPickup(flData[flatid][flPickup]);
			
		if(IsValidDynamicCP(flData[flatid][flCP]))
            DestroyDynamicCP(flData[flatid][flCP]);

        static
        string[255];
		
		new type[128];
		if(flData[flatid][flType] == 1)
		{
			type= "Small";
		}
		else if(flData[flatid][flType] == 2)
		{
			type= "Medium";
		}
		else if(flData[flatid][flType] == 3)
		{
			type= "Large";
		}
		else
		{
			type= "Unknow";
		}

        if(strcmp(flData[flatid][flOwner], "-"))
		{
			format(string, sizeof(string), "[ID: %d]\n{FFFFFF}Flat Location {FFFF00}%s\n{FFFFFF}Flat Type {FFFF00}%s\n"WHITE_E"Owned by %s\nPress '{FF0000}F{FFFFFF}' To Enter", flatid, GetLocation(flData[flatid][flExtposX], flData[flatid][flExtposY], flData[flatid][flExtposZ]), type, flData[flatid][flOwner]);
			flData[flatid][flPickup] = CreateDynamicPickup(1272, 23, flData[flatid][flExtposX], flData[flatid][flExtposY], flData[flatid][flExtposZ]+0.2, 0, 0, _, 10.0);
			//flData[flatid][flCP] = CreateDynamicCP(flData[flatid][flExtposX], flData[flatid][flExtposY], flData[flatid][flExtposZ], 3.0, flatid);
        }
        else
        {
            format(string, sizeof(string), "[ID: %d]\n{FFFFFF}This flat for sell\n{FFFFFF}Flat Location: {FFFF00}%s\n{FFFFFF}Flat Type: {FFFF00}%s\n{FFFFFF}Flat Price: {FFFF00}%s\n"WHITE_E"Type /buy to purchase", flatid, GetLocation(flData[flatid][flExtposX], flData[flatid][flExtposY], flData[flatid][flExtposZ]), type, FormatMoney(flData[flatid][flPrice]));
            flData[flatid][flPickup] = CreateDynamicPickup(1272, 23, flData[flatid][flExtposX], flData[flatid][flExtposY], flData[flatid][flExtposZ]+0.2, 0, 0, _, 10.0);
            //flData[flatid][flCP] = CreateDynamicCP(flData[flatid][flExtposX], flData[flatid][flExtposY], flData[flatid][flExtposZ], 3.0, flatid);
        }
        flData[flatid][flLabel] = CreateDynamic3DTextLabel(string, COLOR_LBLUE, flData[flatid][flExtposX], flData[flatid][flExtposY], flData[flatid][flExtposZ]+0.5, 2.5, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1, 0, 0);
    }
    return 1;
}

function LoadFlats()
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
			format(flData[hid][flOwner], 128, owner);
			cache_get_value_name(i, "address", address);
			format(flData[hid][flAddress], 128, address);
			cache_get_value_name_int(i, "price", flData[hid][flPrice]);
			cache_get_value_name_int(i, "type", flData[hid][flType]);
			cache_get_value_name_float(i, "extposx", flData[hid][flExtposX]);
			cache_get_value_name_float(i, "extposy", flData[hid][flExtposY]);
			cache_get_value_name_float(i, "extposz", flData[hid][flExtposZ]);
			cache_get_value_name_float(i, "extposa", flData[hid][flExtposA]);
			cache_get_value_name_float(i, "intposx", flData[hid][flIntposX]);
			cache_get_value_name_float(i, "intposy", flData[hid][flIntposY]);
			cache_get_value_name_float(i, "intposz", flData[hid][flIntposZ]);
			cache_get_value_name_float(i, "intposa", flData[hid][flIntposA]);
			cache_get_value_name_int(i, "flatint", flData[hid][flInt]);
			cache_get_value_name_int(i, "money", flData[hid][flMoney]);
			cache_get_value_name_int(i, "locked", flData[hid][flLocked]);
			cache_get_value_name_int(i, "visit", flData[hid][flVisit]);

			for (new j = 0; j < 10; j ++)
			{
				format(str, 24, "flatWeapon%d", j + 1);
				cache_get_value_name_int(i, str, flData[hid][flWeapon][j]);

				format(str, 24, "flatAmmo%d", j + 1);
				cache_get_value_name_int(i, str, flData[hid][flAmmo][j]);
			}
			Flat_Refresh(hid);
			Iter_Add(Flats, hid);
		}
		printf("[Flats] Number of Loaded: %d.", rows);
	}
}

//----------[ Flat Commands ]--------
//Flat System
CMD:createflat(playerid, params[])
{
	if(pData[playerid][pAdmin] < 1)
		return PermissionError(playerid);
	
	new hid = Iter_Free(Flats), address[128];
	if(hid == -1) return Error(playerid, "You Can Create More Flat!");
	new price, type, query[512];
	if(sscanf(params, "dd", price, type)) return Usage(playerid, "/createflat [price] [type, 1.small 2.medium 3.Big]");
	format(flData[hid][flOwner], 128, "-");
	GetPlayerPos(playerid, flData[hid][flExtposX], flData[hid][flExtposY], flData[hid][flExtposZ]);
	GetPlayerFacingAngle(playerid, flData[hid][flExtposA]);
	flData[hid][flPrice] = price;
	flData[hid][flType] = type;
	address = GetLocation(flData[hid][flExtposX], flData[hid][flExtposY], flData[hid][flExtposZ]);
	format(flData[hid][flAddress], 128, address);
	flData[hid][flLocked] = 1;
	flData[hid][flMoney] = 0;
	flData[hid][flInt] = 0;
	flData[hid][flIntposX] = 0;
	flData[hid][flIntposY] = 0;
	flData[hid][flIntposZ] = 0;
	flData[hid][flIntposA] = 0;
	flData[hid][flVisit] = 0;
	Flat_Type(hid);
	
	for (new i = 0; i < 10; i ++) 
	{
        flData[hid][flWeapon][i] = 0;
        flData[hid][flAmmo][i] = 0;
    }
    Flat_Refresh(hid);
	Iter_Add(Flats, hid);

	mysql_format(g_SQL, query, sizeof(query), "INSERT INTO flats SET ID='%d', owner='%s', price='%d', type='%d', extposx='%f', extposy='%f', extposz='%f', extposa='%f', address='%s'", hid, flData[hid][flOwner], flData[hid][flPrice], flData[hid][flType], flData[hid][flExtposX], flData[hid][flExtposY], flData[hid][flExtposZ], flData[hid][flExtposA], flData[hid][flAddress]);
	mysql_tquery(g_SQL, query, "OnFlatsCreated", "i", hid);
	return 1;
}

function OnFlatsCreated(hid)
{
	Flat_Save(hid);
	return 1;
}

CMD:gotoflat(playerid, params[])
{
	new hid;
	if(pData[playerid][pAdmin] < 2)
        return PermissionError(playerid);
		
	if(sscanf(params, "d", hid))
		return Usage(playerid, "/gotoflat [id]");
	if(!Iter_Contains(Flats, hid)) return Error(playerid, "The doors you specified ID of doesn't exist.");
	SetPlayerPosition(playerid, flData[hid][flExtposX], flData[hid][flExtposY], flData[hid][flExtposZ], flData[hid][flExtposA]);
    SetPlayerInterior(playerid, 0);
    SetPlayerVirtualWorld(playerid, 0);
	SendClientMessageEx(playerid, COLOR_WHITE, "You has teleport to flat id %d", hid);
	pData[playerid][pInDoor] = -1;
	pData[playerid][pInFlat] = -1;
	pData[playerid][pInBiz] = -1;
	return 1;
}

CMD:typeflats(playerid, params[])
{
	if(pData[playerid][pAdmin] < 6)
        return PermissionError(playerid);
	
	new count = 0;
	foreach(new hid : Flats)
	{
		if(flData[hid][flType] == 1)
		{
			Flat_Type(hid);
			Flat_Refresh(hid);
			Flat_Save(hid);
		}
		if(flData[hid][flType] == 2)
		{
			Flat_Type(hid);
			Flat_Refresh(hid);
			Flat_Save(hid);
		}
		if(flData[hid][flType] == 3)
		{
			Flat_Type(hid);
			Flat_Refresh(hid);
			Flat_Save(hid);
		}
		count++;
	}
	Servers(playerid, "Anda telah me reset flat interior type sebanyak %d rumah.", count);
	return 1;
}

CMD:editflat(playerid, params[])
{
    static
        hid,
        type[24],
        string[128];

    if(pData[playerid][pAdmin] < 6)
        return PermissionError(playerid);

    if(sscanf(params, "ds[24]S()[128]", hid, type, string))
    {
        Usage(playerid, "/editflat [id] [name]");
        SendClientMessage(playerid, COLOR_YELLOW, "[NAMES]:{FFFFFF} location, interior, locked, owner, price, type, reset, delete");
        return 1;
    }
    if((hid < 0 || hid >= MAX_FLATS))
        return Error(playerid, "You have specified an invalid ID.");
	if(!Iter_Contains(Flats, hid)) return Error(playerid, "The doors you specified ID of doesn't exist.");

    if(!strcmp(type, "location", true))
    {
		GetPlayerPos(playerid, flData[hid][flExtposX], flData[hid][flExtposY], flData[hid][flExtposZ]);
		GetPlayerFacingAngle(playerid, flData[hid][flExtposA]);
        Flat_Save(hid);
		Flat_Refresh(hid);

        SendAdminMessage(COLOR_LOGS, "%s Changes Location Of The Flat ID: %d.", pData[playerid][pAdminname], hid);
    }
    else if(!strcmp(type, "interior", true))
    {
        GetPlayerPos(playerid, flData[hid][flIntposX], flData[hid][flIntposY], flData[hid][flIntposZ]);
		GetPlayerFacingAngle(playerid, flData[hid][flIntposA]);
		flData[hid][flInt] = GetPlayerInterior(playerid);

        Flat_Save(hid);
		Flat_Refresh(hid);

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
        SendAdminMessage(COLOR_LOGS, "%s Changes Interior Of The FLAT ID: %d.", pData[playerid][pAdminname], hid);
    }
    else if(!strcmp(type, "locked", true))
    {
        new locked;

        if(sscanf(string, "d", locked))
            return Usage(playerid, "/editflat [id] [locked] [0/1]");

        if(locked < 0 || locked > 1)
            return Error(playerid, "You must specify at least 0 or 1.");

        flData[hid][flLocked] = locked;
        Flat_Save(hid);
		Flat_Refresh(hid);

        if(locked) {
            SendAdminMessage(COLOR_LOGS, "%s Has Locked Of The Flat ID: %d.", pData[playerid][pAdminname], hid);
        }
        else {
            SendAdminMessage(COLOR_LOGS, "%s Has Unclocked Of The Flat ID: %d.", pData[playerid][pAdminname], hid);
        }
    }
    else if(!strcmp(type, "price", true))
    {
        new price;

        if(sscanf(string, "d", price))
            return Usage(playerid, "/editflat [id] [Price] [Amount]");

        flData[hid][flPrice] = price;

        Flat_Save(hid);
		Flat_Refresh(hid);
        SendAdminMessage(COLOR_LOGS, "%s Changes Price Of The Flat ID: %d to %d.", pData[playerid][pAdminname], hid, price);
    }
	else if(!strcmp(type, "type", true))
    {
        new fltype;

        if(sscanf(string, "d", fltype))
            return Usage(playerid, "/editflat [id] [Type] [1.small 2.medium 3.Big]");

        flData[hid][flType] = fltype;
		Flat_Type(hid);
        Flat_Save(hid);
		Flat_Refresh(hid);
        SendAdminMessage(COLOR_LOGS, "%s Changes Type Of The Flat ID: %d to %d.", pData[playerid][pAdminname], hid, fltype);
    }
    else if(!strcmp(type, "owner", true))
    {
        new owners[MAX_PLAYER_NAME];

        if(sscanf(string, "s[32]", owners))
            return Usage(playerid, "/editflat [id] [owner] [player name] (use '-' to no owner)");

        format(flData[hid][flOwner], MAX_PLAYER_NAME, owners);
  
        Flat_Save(hid);
		Flat_Refresh(hid);
        SendAdminMessage(COLOR_LOGS, "%s Changes Owner Of The Flat ID: %d to %s", pData[playerid][pAdminname], hid, owners);
    }
    else if(!strcmp(type, "reset", true))
    {
        FlatReset(hid);
		Flat_Save(hid);
		Flat_Refresh(hid);
        SendAdminMessage(COLOR_LOGS, "%s Has Reset Of The Flat ID: %d.", pData[playerid][pAdminname], hid);
    }
	else if(!strcmp(type, "delete", true))
	{
		FlatReset(hid);
		
		DestroyDynamic3DTextLabel(flData[hid][flLabel]);
        DestroyDynamicPickup(flData[hid][flPickup]);
        DestroyDynamicCP(flData[hid][flCP]);
		
		flData[hid][flExtposX] = 0;
		flData[hid][flExtposY] = 0;
		flData[hid][flExtposZ] = 0;
		flData[hid][flExtposA] = 0;
		flData[hid][flPrice] = 0;
		flData[hid][flInt] = 0;
		flData[hid][flIntposX] = 0;
		flData[hid][flIntposY] = 0;
		flData[hid][flIntposZ] = 0;
		flData[hid][flIntposA] = 0;
		flData[hid][flLabel] = Text3D: INVALID_3DTEXT_ID;
		flData[hid][flPickup] = -1;
		
		Iter_Remove(Flats, hid);
		new query[128];
		mysql_format(g_SQL, query, sizeof(query), "DELETE FROM flats WHERE ID=%d", hid);
		mysql_tquery(g_SQL, query);
        SendAdminMessage(COLOR_LOGS, "%s Has Delete Of The Flat ID: %d.", pData[playerid][pAdminname], hid);
	}
    return 1;
}

CMD:lockflat(playerid, params[])
{
	foreach(new hid : Flats)
	{
		if(IsPlayerInRangeOfPoint(playerid, 2.5, flData[hid][flExtposX], flData[hid][flExtposY], flData[hid][flExtposZ]))
		{
			if(!Player_OwnsFlat(playerid, hid)) return Error(playerid, "You don't own this flat.");
			if(!flData[hid][flLocked])
			{
				flData[hid][flLocked] = 1;
				Flat_Save(hid);

				InfoTD_MSG(playerid, 4000, "You have ~r~locked~w~ your flat!");
				PlayerPlaySound(playerid, 1145, 0.0, 0.0, 0.0);
			}
			else
			{
				flData[hid][flLocked] = 0;
				Flat_Save(hid);

				InfoTD_MSG(playerid, 4000,"You have ~g~unlocked~w~ your flat!");
				PlayerPlaySound(playerid, 1145, 0.0, 0.0, 0.0);
			}
		}
	}
	return 1;
}

CMD:giveflat(playerid, params[])
{
	new hid, otherid;
	if(sscanf(params, "ud", otherid, hid)) return Usage(playerid, "/giveflat [playerid/name] [id] | /myflat - for show info");
	if(hid == -1) return Error(playerid, "Invalid id");
	
	if(!IsPlayerConnected(otherid) || !NearPlayer(playerid, otherid, 4.0))
        return Error(playerid, "The specified player is disconnected or not near you.");
	
	if(!Player_OwnsFlat(playerid, hid)) return Error(playerid, "You dont own this id flat.");
	
	if(pData[otherid][pVip] == 1)
	{
		#if LIMIT_PER_PLAYER > 0
		if(Player_FlatCount(otherid) + 1 > 2) return Error(playerid, "Target player cant own any more flats.");
		#endif
	}
	else if(pData[otherid][pVip] == 2)
	{
		#if LIMIT_PER_PLAYER > 0
		if(Player_FlatCount(otherid) + 1 > 3) return Error(playerid, "Target player cant own any more flats.");
		#endif
	}
	else if(pData[otherid][pVip] == 3)
	{
		#if LIMIT_PER_PLAYER > 0
		if(Player_FlatCount(otherid) + 1 > 4) return Error(playerid, "Target player cant own any more flats.");
		#endif
	}
	else
	{
		#if LIMIT_PER_PLAYER > 0
		if(Player_FlatCount(otherid) + 1 > 1) return Error(playerid, "Target player cant own any more flats.");
		#endif
	}
	GetPlayerName(otherid, flData[hid][flOwner], MAX_PLAYER_NAME);
	flData[hid][flVisit] = gettime();
	
	Flat_Refresh(hid);
	Flat_Save(hid);
	Info(playerid, "Anda memberikan rumah id: %d kepada %s", hid, ReturnName(otherid));
	Info(otherid, "%s memberikan rumah id: %d kepada anda", hid, ReturnName(playerid));
	return 1;
}

CMD:sellflat(playerid, params[])
{
	if(!IsPlayerInRangeOfPoint(playerid, 3.0, 1392.77, -22.25, 1000.97)) return Error(playerid, "Anda harus berada di City Hall!");
	if(GetOwnedFlats(playerid) == -1) return Error(playerid, "You don't have a flats.");
	//if(!Player_OwnsBusiness(playerid, id)) return Error(playerid, "You don't own this business.");
	new hid, _tmpstring[128], count = GetOwnedFlats(playerid), CMDSString[1024];
	CMDSString = "";
	new lock[128];
	Loop(itt, (count + 1), 1)
	{
	    hid = ReturnPlayerFlatsID(playerid, itt);
		if(flData[hid][flLocked] == 1)
		{
			lock = "{FF0000}Locked";
		
		}
		else
		{
			lock = "{00FF00}Unlocked";
		}
		if(itt == count)
		{
		    format(_tmpstring, sizeof(_tmpstring), ""LB_E"%d.\t{FFFF2A}%s   (%s{FFFF2A})\n", itt, flData[hid][flAddress], lock);
		}
		else format(_tmpstring, sizeof(_tmpstring), ""LB_E"%d.\t{FFFF2A}%s  (%s{FFFF2A})\n", itt, flData[hid][flAddress], lock);
		strcat(CMDSString, _tmpstring);
	}
	ShowPlayerDialog(playerid, DIALOG_SELL_FLATS, DIALOG_STYLE_LIST, "Sell Flats", CMDSString, "Sell", "Cancel");
	return 1;
}

CMD:myflat(playerid)
{
	if(GetOwnedFlats(playerid) == -1) return Error(playerid, "You don't have a flats.");
	//if(!Player_OwnsBusiness(playerid, id)) return Error(playerid, "You don't own this business.");
	new hid, _tmpstring[128], count = GetOwnedFlats(playerid), CMDSString[1024];
	CMDSString = "";
	new lock[128];
	Loop(itt, (count + 1), 1)
	{
	    hid = ReturnPlayerFlatsID(playerid, itt);
		if(flData[hid][flLocked] == 1)
		{
			lock = "{FF0000}Locked";
		
		}
		else
		{
			lock = "{00FF00}Unlocked";
		}
		if(itt == count)
		{
		    format(_tmpstring, sizeof(_tmpstring), ""LB_E"%d.\t{FFFF2A}%s   (%s)\n", itt, flData[hid][flAddress], lock);
		}
		else format(_tmpstring, sizeof(_tmpstring), ""LB_E"%d.\t{FFFF2A}%s  (%s)\n", itt, flData[hid][flAddress], lock);
		strcat(CMDSString, _tmpstring);
	}
	ShowPlayerDialog(playerid, DIALOG_MY_FLATS, DIALOG_STYLE_LIST, "{FF0000}HBPR:RP: {0000FF}Flats", CMDSString, "Select", "Cancel");
	return 1;
}

CMD:flm(playerid, params[])
{
	if(!Player_OwnsFlat(playerid, pData[playerid][pInFlat])) 
		if(pData[playerid][pFaction] != 1)
			return Error(playerid, "You don't own this flat.");
	Flat_OpenStorage(playerid, pData[playerid][pInFlat]);
    return 1;
}

//--------------[ Flat Dialog ]----------
