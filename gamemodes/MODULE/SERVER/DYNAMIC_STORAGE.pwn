#define MAX_STORAGE 200

enum StorageVariabel
{
	StorageOwner[MAX_PLAYER_NAME],
	StoragePrice,
	StorageMoney,
	StorageRedMoney,
	SMarjun,
	SCom,
	SMate,
	sGun[3],
	sAmmo[3],
	Float:StoragePosX,
	Float:StoragePosY,
	Float:StoragePosZ,
	StorageInterior,
	StorageWorld,
	StoragePickup,
	Text3D:StorageLabel
};
new StgData[MAX_STORAGE][StorageVariabel];
new Iterator:Storage<MAX_STORAGE>;

stock ResetStorageMoney()
{
	new count;
	for(new i; i < MAX_STORAGE; i++)
	{
	    StgData[i][StorageRedMoney] = 0;
	    StgData[i][StorageMoney] = 0;
		StorageSave(i);
		StorageRefresh(i);
		count++;
	}
	return count;
}

CMD:resetmoneystorage(playerid,params[])
{
	if(pData[playerid][pAdmin] < 10)
        return PermissionError(playerid);

	ResetStorageMoney();
	Servers(playerid, "done");
	return true;
}
/* =======================[ Command goes here ]======================= */
CMD:gotostorage(playerid, params[])
{
	new lid;
	if(pData[playerid][pAdmin] < 2)
        return PermissionError(playerid);

	if(sscanf(params, "d", lid))
		return Usage(playerid, "/gotostorage [id]");
	if(!Iter_Contains(Storage, lid)) return Error(playerid, "The locker you specified ID of doesn't exist.");
	SetPlayerPosition(playerid, StgData[lid][StoragePosX], StgData[lid][StoragePosY], StgData[lid][StoragePosZ], 2.0);
    SetPlayerVirtualWorld(playerid, 0);
	Servers(playerid, "You has teleport to storage id %d", lid);
	return 1;
}

CMD:setposstorage(playerid, params[])
{
	new sid;
	if(sscanf(params, "d", sid))
		return Usage(playerid, "/setposstorage [ID]");
	GetPlayerPos(playerid, StgData[sid][StoragePosX], StgData[sid][StoragePosY], StgData[sid][StoragePosZ]);
    StorageSave(sid);
	StorageRefresh(sid);

    SendAdminMessage(COLOR_RED, "%s has adjusted the location of storage ID: %d.", pData[playerid][pAdminname], sid);
    return 1;
}

CMD:createstorage(playerid, params[])
{
	if(pData[playerid][pAdmin] < 6)
		return PermissionError(playerid);

	new query[512];
	new sid = Iter_Free(Storage);

	new price;
	if(sscanf(params, "d", price))
		return Usage(playerid, "/createStorage [price]");

	if(sid == -1)
		return Error(playerid, "You cant create more Storage");

	if((sid < 0 || sid >= MAX_STORAGE))
        return Error(playerid, "You have already input 15 Storage in this server.");

	format(StgData[sid][StorageOwner], 128, "-");
	GetPlayerPos(playerid, StgData[sid][StoragePosX], StgData[sid][StoragePosY], StgData[sid][StoragePosZ]);

	StgData[sid][StoragePrice] = price;

	format(query, sizeof(query), "ID: %d\n"WHITE_E"Privete Storage Sell\nLocation: %s\nPrice: "GREEN_E"%s", sid, GetLocation(StgData[sid][StoragePosX], StgData[sid][StoragePosY], StgData[sid][StoragePosZ]), FormatMoney(StgData[sid][StoragePrice]));
	StgData[sid][StorageLabel] = CreateDynamic3DTextLabel(query, COLOR_YELLOW, StgData[sid][StoragePosX], StgData[sid][StoragePosY], StgData[sid][StoragePosZ]+1.0, 10.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, StgData[sid][StorageWorld], StgData[sid][StorageInterior], -1, 10.0);

	StgData[sid][StorageMoney] = 0;
	StgData[sid][StorageRedMoney] = 0;
	StgData[sid][SMarjun] =0;
	StgData[sid][SCom] =0;
	StgData[sid][SMate] =0;

	Iter_Add(Storage, sid);
	StorageRefresh(sid);
	mysql_format(g_SQL, query, sizeof(query), "INSERT INTO storage SET ID='%d', owner='%s', price='%d', posx='%f', posy='%f', posz='%f'", sid, StgData[sid][StorageOwner], StgData[sid][StoragePrice], StgData[sid][StoragePosX], StgData[sid][StoragePosY], StgData[sid][StoragePosZ]);
	mysql_tquery(g_SQL, query, "OnStorageCreated", "i", sid);
	return 1;
}


CMD:removestorage(playerid, params[])
{
    new lid;

    if(pData[playerid][pAdmin] < 4)
        return PermissionError(playerid);

	if(sscanf(params, "i", lid)) return Usage(playerid, "/removestorage [id]");
	if(!Iter_Contains(Storage, lid)) return Error(playerid, "Invalid ID.");
    if((lid < 0 || lid >= MAX_STORAGE))
        return Error(playerid, "You have specified an invalid ID.");

	new query[128];
	DestroyDynamic3DTextLabel(StgData[lid][StorageLabel]);
	DestroyDynamicPickup(StgData[lid][StoragePickup]);
	StgData[lid][StoragePosX] = 0;
	StgData[lid][StoragePosY] = 0;
	StgData[lid][StoragePosZ] = 0;
	StgData[lid][StorageLabel] = Text3D: INVALID_3DTEXT_ID;
	StgData[lid][StoragePickup] = -1;
	Iter_Remove(Storage, lid);
	mysql_format(g_SQL, query, sizeof(query), "DELETE FROM storage WHERE id=%d", lid);
	mysql_tquery(g_SQL, query);
    SendAdminMessage(COLOR_RED, "%s has delete storage ID: %d.", pData[playerid][pAdminname], lid);
    return 1;
}

CMD:buystorage(playerid, params[])
{
	foreach(new bid : Storage)
	{
		if(IsPlayerInRangeOfPoint(playerid, 2.5, StgData[bid][StoragePosX], StgData[bid][StoragePosY], StgData[bid][StoragePosZ]))
		{
			if(StgData[bid][StoragePrice] > pData[playerid][pMoney])
				return Error(playerid, "Not enough money, you can't afford this Storage.");

			if(strcmp(StgData[bid][StorageOwner], "-"))
				return Error(playerid, "Someone already owns this Storage.");


			pData[playerid][pEMoney] -= StgData[bid][StoragePrice];
			Server_AddMoney(StgData[bid][StoragePrice]);
			GetPlayerName(playerid, StgData[bid][StorageOwner], MAX_PLAYER_NAME);

			StorageRefresh(bid);
			StorageSave(bid);
		}
	}
	return 1;
}

CMD:storage(playerid, params[])
{
    new fid = pData[playerid][pInStorage];
	foreach(new vid : Storage)
	{
		if(IsPlayerInRangeOfPoint(playerid, 2.5, StgData[vid][StoragePosX], StgData[vid][StoragePosY], StgData[vid][StoragePosZ]))
		{
			if(!PlayerOwnStorage(playerid, vid)) return Error(playerid, "Storage ini bukan milik anda!");

			new str[128];
			format(str, sizeof(str), "Weapon\nMoney\nRedMoney [ {ff0000}%s {ffffff}]\nMarijuana\nComponent\nMaterial", FormatMoney(StgData[fid][StorageRedMoney]));
			ShowPlayerDialog(playerid, DIALOG_STORAGE_MENU, DIALOG_STYLE_LIST, "Storage Menu", str, "Select", "Cancel");
			//ShowPlayerDialog(playerid, DIALOG_STORAGE_MENU, DIALOG_STYLE_LIST, "Storage Menu", "Weapon\nMoney [ {00ff00%s{ffffff} ]\nRedMoney [ {ff0000}%s {ffffff}]", "Select", "Cancel");
		}
	}
	return 1;
}

/* =======================[ Stock goes here ]======================= */

PlayerOwnStorage(playerid, id)
{
	if(!IsPlayerConnected(playerid)) return 0;
	if(id == -1) return 0;
	if(!strcmp(StgData[id][StorageOwner], pData[playerid][pName], true)) return 1;
	return 0;
}
S_WeaponStorage(playerid, fid)
{
    if(fid == -1)
        return 0;

    static
        string[320];

    string[0] = 0;

    for (new i = 0; i < 3; i ++)
    {
        if(!StgData[fid][sGun][i])
            format(string, sizeof(string), "%sEmpty\n", string);

        else
            format(string, sizeof(string), "%s%s (Ammo: %d)\n", string, ReturnWeaponName(StgData[fid][sGun][i]), StgData[fid][sAmmo][i]);
    }
    ShowPlayerDialog(playerid, S_WEAPONS, DIALOG_STYLE_LIST, "Weapon Storage", string, "Select", "Cancel");
    return 1;
}

StorageRefresh(id)
{
	if(id != -1)
	{
		if(IsValidDynamic3DTextLabel(StgData[id][StorageLabel]))
            DestroyDynamic3DTextLabel(StgData[id][StorageLabel]);

        if(IsValidDynamicPickup(StgData[id][StoragePickup]))
            DestroyDynamicPickup(StgData[id][StoragePickup]);

		new tstr[218];
		if(StgData[id][StoragePosX] != 0 && StgData[id][StoragePosY] != 0 && StgData[id][StoragePosZ] != 0 && strcmp(StgData[id][StorageOwner], "-"))
		{
			StgData[id][StoragePickup] = CreateDynamicPickup(1276, 23, StgData[id][StoragePosX], StgData[id][StoragePosY], StgData[id][StoragePosZ]+0.2, -1, -1, -1, 10.0);
			format(tstr, sizeof(tstr), "ID: %d\n"WHITE_E"%s\n"RED_E"/storage "WHITE_E"Opend privete storage", id, StgData[id][StorageOwner]);
			StgData[id][StorageLabel] = CreateDynamic3DTextLabel(tstr, COLOR_YELLOW, StgData[id][StoragePosX], StgData[id][StoragePosY], StgData[id][StoragePosZ]+1.0, 10.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, StgData[id][StorageWorld], StgData[id][StorageInterior], -1, 10.0);
		}
		else if(StgData[id][StoragePosX] != 0 && StgData[id][StoragePosY] != 0 && StgData[id][StoragePosZ] != 0)
		{
			StgData[id][StoragePickup] = CreateDynamicPickup(1276, 23, StgData[id][StoragePosX], StgData[id][StoragePosY], StgData[id][StoragePosZ]+0.2, -1, -1, -1, 10.0);
			format(tstr, sizeof(tstr), "{ffff00}ID: %d\n{ffffff}Privete Storage Sell\n{ffffff}Location: {ffff00}%s\nPrice: {00ff00}%s\n/buystorage {ffffff}To buy privete storage", id, GetLocation(StgData[id][StoragePosX], StgData[id][StoragePosY], StgData[id][StoragePosZ]), FormatMoney(StgData[id][StoragePrice]));
			StgData[id][StorageLabel] = CreateDynamic3DTextLabel(tstr, COLOR_YELLOW, StgData[id][StoragePosX], StgData[id][StoragePosY], StgData[id][StoragePosZ]+1.0, 10.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, StgData[id][StorageWorld], StgData[id][StorageInterior], -1, 10.0);
        }
	}
}

StorageSave(id)
{
    new cQuery[2248];
    format(cQuery, sizeof(cQuery), "UPDATE storage SET owner='%s', price='%d', money='%d'",
    StgData[id][StorageOwner],
    StgData[id][StoragePrice]);

	for (new i = 0; i < 3; i ++)
	{
        format(cQuery, sizeof(cQuery), "%s, weapon%d='%d', ammo%d='%d'", cQuery, i + 1, StgData[id][sGun][i], i + 1, StgData[id][sAmmo][i]);
    }
    
	format(cQuery, sizeof(cQuery), "%s, money='%d', redmoney='%d', marjun='%d', component='%d', material='%d',  posx='%f', posy='%f', posz='%f' WHERE ID='%d'",
	cQuery,
    StgData[id][StorageMoney],
    StgData[id][StorageRedMoney],
    StgData[id][SMarjun],
    StgData[id][SCom],
    StgData[id][SMate],
    StgData[id][StoragePosX],
    StgData[id][StoragePosY],
    StgData[id][StoragePosZ],
    id);
    return mysql_tquery(g_SQL, cQuery);
}



function LoadStorages()
{
    static bid;

	new rows = cache_num_rows(), owner[128];
 	if(rows)
  	{
		for(new i; i < rows; i++)
		{
			cache_get_value_name_int(i, "ID", bid);
			cache_get_value_name(i, "owner", owner);
			format(StgData[bid][StorageOwner], 128, owner);
			cache_get_value_name_int(i, "price", StgData[bid][StoragePrice]);
			cache_get_value_name_int(i, "money", StgData[bid][StorageMoney]);//SMarjun
			cache_get_value_name_int(i, "redmoney", StgData[bid][StorageRedMoney]);
			cache_get_value_name_int(i, "marjun", StgData[bid][SMarjun]);
			cache_get_value_name_int(i, "component", StgData[bid][SCom]);
			cache_get_value_name_int(i, "material", StgData[bid][SMate]);
			cache_get_value_name_float(i, "posx", StgData[bid][StoragePosX]);
			cache_get_value_name_float(i, "posy", StgData[bid][StoragePosY]);
			cache_get_value_name_float(i, "posz", StgData[bid][StoragePosZ]);
			
			cache_get_value_name_int(i, "weapon1", StgData[bid][sGun][0]);
			cache_get_value_name_int(i, "weapon2", StgData[bid][sGun][1]);
			cache_get_value_name_int(i, "weapon3", StgData[bid][sGun][2]);

			cache_get_value_name_int(i, "ammo1", StgData[bid][sAmmo][0]);
			cache_get_value_name_int(i, "ammo2", StgData[bid][sAmmo][1]);
			cache_get_value_name_int(i, "ammo3", StgData[bid][sAmmo][2]);
			StorageRefresh(bid);
			Iter_Add(Storage, bid);
		}
		printf("[MySQL Storage] Number of Loaded: %d.", rows);
	}
}

function OnStorageCreated(id)
{
	StorageRefresh(id);
	StorageSave(id);
	return 1;
}


/* =======================[ Timer goes here ]======================= */
ptask PlayerStorageUpdate[1000](playerid)
{
	foreach(new vid : Storage)
	{
		if(IsPlayerInRangeOfPoint(playerid, 3.0, StgData[vid][StoragePosX], StgData[vid][StoragePosY], StgData[vid][StoragePosZ]))
		{
			pData[playerid][pInStorage] = vid;
		}
	}
	return 1;
}
