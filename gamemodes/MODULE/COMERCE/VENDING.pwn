#define MAX_VENDING 50

enum VendingVariabel
{
	VendingOwner[MAX_PLAYER_NAME],
	VendingName[128],
	VendingPrice,
	VendingType,
	VendingStock,
	VendingRestock,
	VendingLock,
	VendingMoney,
	VendingItemPrice[5],
	Float:VendingPosX,
	Float:VendingPosY,
	Float:VendingPosZ,
	Float:VendingPosA,
	Float:VendingPosRX,
	Float:VendingPosRY,
	Float:VendingPosRZ,
	VendingInterior,
	VendingWorld,

	// Hooked to LoadVending and Refresh
	VendingObjectID,
	Text3D:VendingLabel
};

new VendingData[MAX_VENDING][VendingVariabel];
new Iterator:Vending<MAX_VENDING>;

/* =======================[ Command goes here ]======================= */

CMD:createvending(playerid, params[])
{
	if(pData[playerid][pAdmin] < 6)
		return PermissionError(playerid);
	
	new query[512];
	new vendingid = Iter_Free(Vending), address[128];

	new price, type;
	if(sscanf(params, "dd", price, type))
		return Usage(playerid, "/createvending [price] [type 1. Frozen Food 2. Soda]");

	if(vendingid == -1) 
		return Error(playerid, "You cant create more Vending");

	if((vendingid < 0 || vendingid >= MAX_VENDING))
        return Error(playerid, "You have already input 15 Vending in this server.");

	if(type > 2 || type < 0)
		return Error(playerid, "Invalid Vending Type");

	format(VendingData[vendingid][VendingOwner], 128, "-");
	GetPlayerPos(playerid, VendingData[vendingid][VendingPosX], VendingData[vendingid][VendingPosY], VendingData[vendingid][VendingPosZ]);
	GetPlayerFacingAngle(playerid, VendingData[vendingid][VendingPosA]);

	VendingData[vendingid][VendingPrice] = price;
	VendingData[vendingid][VendingType] = type;

	address = GetLocation(VendingData[vendingid][VendingPosX], VendingData[vendingid][VendingPosY], VendingData[vendingid][VendingPosZ]);
	format(VendingData[vendingid][VendingName], 128, address);

	format(query, sizeof(query), "[ID: %d]\n"WHITE_E"This Vending Machine is for sell\nLocation: %s\nPrice: "GREEN_E"%s\n"WHITE_E"Type: "YELLOW_E"%s", vendingid, GetLocation(VendingData[vendingid][VendingPosX], VendingData[vendingid][VendingPosY], VendingData[vendingid][VendingPosZ]), FormatMoney(VendingData[vendingid][VendingPrice]), type);
	VendingData[vendingid][VendingLabel] = CreateDynamic3DTextLabel(query, COLOR_YELLOW, VendingData[vendingid][VendingPosX], VendingData[vendingid][VendingPosY], VendingData[vendingid][VendingPosZ]+1.0, 10.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, VendingData[vendingid][VendingWorld], VendingData[vendingid][VendingInterior], -1, 10.0);
	VendingData[vendingid][VendingObjectID] = CreateDynamicObject(1209, VendingData[vendingid][VendingPosX], VendingData[vendingid][VendingPosY], VendingData[vendingid][VendingPosZ], VendingData[vendingid][VendingPosRX], VendingData[vendingid][VendingPosRY], VendingData[vendingid][VendingPosRZ], VendingData[vendingid][VendingWorld], VendingData[vendingid][VendingInterior]);
    

	VendingData[vendingid][VendingLock] = 1;
	VendingData[vendingid][VendingMoney] = 0;
	VendingData[vendingid][VendingStock] = 100;
	VendingData[vendingid][VendingRestock] = 0;

	Iter_Add(Vending, vendingid);

	mysql_format(g_SQL, query, sizeof(query), "INSERT INTO vending SET ID='%d', owner='%s', price='%d', type='%d', posx='%f', posy='%f', posz='%f', posa='%f', name='%s'", vendingid, VendingData[vendingid][VendingOwner], VendingData[vendingid][VendingPrice], VendingData[vendingid][VendingType], VendingData[vendingid][VendingPosX], VendingData[vendingid][VendingPosY], VendingData[vendingid][VendingPosZ], VendingData[vendingid][VendingPosA], VendingData[vendingid][VendingName]);
	mysql_tquery(g_SQL, query, "OnVendingCreated", "i", vendingid);
	return 1;
}

CMD:gotovending(playerid, params[])
{
	new id;
	if(pData[playerid][pAdmin] < 4)
        return PermissionError(playerid);
		
	if(sscanf(params, "d", id))
		return Usage(playerid, "/gotovending [id]");
	if(!Iter_Contains(Vending, id)) return Error(playerid, "That Vending ID is not exists");
	
	SetPlayerPos(playerid, VendingData[id][VendingPosX], VendingData[id][VendingPosY], VendingData[id][VendingPosZ]);
	SetPlayerFacingAngle(playerid, VendingData[id][VendingPosA]);
    SetPlayerInterior(playerid, VendingData[id][VendingInterior]);
    SetPlayerVirtualWorld(playerid, VendingData[id][VendingWorld]);
	SendClientMessageEx(playerid, COLOR_LBLUE, "{FFFF00}You has teleport to Vending ID %d", id);
	return 1;
}

CMD:deletevending(playerid, params[])
{
    if(pData[playerid][pAdmin] < 6)
		return PermissionError(playerid);
		
	new id, query[512];
	if(sscanf(params, "i", id)) return Usage(playerid, "/deletevending [id]");
	if(!Iter_Contains(Vending, id)) return Error(playerid, "Invalid Vending ID.");
	
	DestroyDynamicObject(VendingData[id][VendingObjectID]);
	DestroyDynamic3DTextLabel(VendingData[id][VendingLabel]);
	
	VendingData[id][VendingPosX] = VendingData[id][VendingPosY] = VendingData[id][VendingPosZ] = VendingData[id][VendingPosRX] = VendingData[id][VendingPosRY] = VendingData[id][VendingPosRZ] = 0.0;
	VendingData[id][VendingInterior] = VendingData[id][VendingWorld] = 0;
	VendingData[id][VendingObjectID] = -1;
	VendingData[id][VendingLabel] = Text3D: -1;
	Iter_Remove(Vending, id);

	VendingReset(id);
	
	mysql_format(g_SQL, query, sizeof(query), "DELETE FROM vending WHERE id=%d", id);
	mysql_tquery(g_SQL, query);
	SendAdminMessage(COLOR_RED, "Admin %s has deleted Vending ID %d", pData[playerid][pAdminname], id);
	return 1;
}

alias:editvendingpos("evp")
CMD:editvendingpos(playerid, params[])
{
    if(pData[playerid][pAdmin] < 6)
		return PermissionError(playerid);
	
	new id;
	if(sscanf(params, "i", id)) return Usage(playerid, "/editvendingpos [id]");
	if(!Iter_Contains(Vending, id)) return Error(playerid, "Invalid ID.");
	if(!IsPlayerInRangeOfPoint(playerid, 30.0, VendingData[id][VendingPosX], VendingData[id][VendingPosY], VendingData[id][VendingPosZ])) return Error(playerid, "You're not near the Vending you want to edit.");
	pData[playerid][EditingVending] = id;
	EditDynamicObject(playerid, VendingData[id][VendingObjectID]);
	return 1;
}

CMD:buyvending(playerid, params[])
{
	foreach(new bid : Vending)
	{
		if(IsPlayerInRangeOfPoint(playerid, 2.5, VendingData[bid][VendingPosX], VendingData[bid][VendingPosY], VendingData[bid][VendingPosZ]))
		{
			if(VendingData[bid][VendingPrice] > GetPlayerMoney(playerid)) 
				return Error(playerid, "Not enough money, you can't afford this Vending.");

			if(strcmp(VendingData[bid][VendingOwner], "-")) 
				return Error(playerid, "Someone already owns this Vending.");

			/*if(pData[playerid][pVip] == 1)
			{
			    #if LIMIT_PER_PLAYER > 0
				if(Player_VendingCount(playerid) + 1 > 1) return Error(playerid, "You can't buy any more Vending.");
				#endif
			}
			else if(pData[playerid][pVip] == 2)
			{
			    #if LIMIT_PER_PLAYER > 0
				if(Player_VendingCount(playerid) + 1 > 1) return Error(playerid, "You can't buy any more Vending.");
				#endif
			}
			else if(pData[playerid][pVip] == 3)
			{
			    #if LIMIT_PER_PLAYER > 0
				if(Player_VendingCount(playerid) + 1 > 1) return Error(playerid, "You can't buy any more Vending.");
				#endif
			}
			else
			{
				#if LIMIT_PER_PLAYER > 0
				if(Player_VendingCount(playerid) + 1 > 1) return Error(playerid, "You can't buy any more Vending.");
				#endif
			}*/

			SendClientMessageEx(playerid, COLOR_WHITE, "You has teleport to vending id %d", bid);
			GivePlayerMoneyEx(playerid, -VendingData[bid][VendingPrice]);
			Server_AddMoney(VendingData[bid][VendingPrice]);
			GetPlayerName(playerid, VendingData[bid][VendingOwner], MAX_PLAYER_NAME);
			
			VendingRefresh(bid);
			VendingSave(bid);
		}
	}
	return 1;
}

alias:vendingmanage("venmanage")
CMD:vendingmanage(playerid, params[])
{
	foreach(new vid : Vending)
	{
		if(IsPlayerInRangeOfPoint(playerid, 2.5, VendingData[vid][VendingPosX], VendingData[vid][VendingPosY], VendingData[vid][VendingPosZ]))
		{
			if(!PlayerOwnVending(playerid, vid)) return Error(playerid, "Vending ini bukan milik anda!");
			ShowPlayerDialog(playerid, DIALOG_VENDING_MANAGE, DIALOG_STYLE_LIST, "Vending Manage", "Vending Information\nVending Change Name\nVending Vault\nVending Modify\nRequest Stock", "Select", "Cancel");
		}
	}
	return 1;
}

/* =======================[ Stock goes here ]======================= */

PlayerOwnVending(playerid, id)
{
	if(!IsPlayerConnected(playerid)) return 0;
	if(id == -1) return 0;
	if(!strcmp(VendingData[id][VendingOwner], pData[playerid][pName], true)) return 1;
	return 0;
}

VendingReset(id)
{
	format(VendingData[id][VendingOwner], MAX_PLAYER_NAME, "-");
	VendingData[id][VendingLock] = 1;
    VendingData[id][VendingMoney] = 0;
	VendingData[id][VendingStock] = 0;
	VendingData[id][VendingRestock] = 0;
	VendingRefresh(id);
}

VendingRefresh(id)
{
	if(id != -1)
	{		
		if(IsValidDynamic3DTextLabel(VendingData[id][VendingLabel]))
            DestroyDynamic3DTextLabel(VendingData[id][VendingLabel]);

		if(IsValidDynamicObject(VendingData[id][VendingObjectID]))
			DestroyDynamicObject(VendingData[id][VendingObjectID]);

        new type[128];
		if(VendingData[id][VendingType] == 1)
		{
			type = "Frozen Food";
		}
		else if(VendingData[id][VendingType] == 2)
		{
			type = "Soda";
		}
		else
		{
			type = "Unknown";
		}
		
		new tstr[218];
		if(VendingData[id][VendingPosX] != 0 && VendingData[id][VendingPosY] != 0 && VendingData[id][VendingPosZ] != 0 && strcmp(VendingData[id][VendingOwner], "-"))
		{
			format(tstr, sizeof(tstr), "[ID: %d]\n"WHITE_E"Vending Name: "YELLOW_E"%s\n"WHITE_E"Owned by %s\nStock: "YELLOW_E"%d\n"WHITE_E"Type: "YELLOW_E"%s\n"WHITE_E"Type "RED_E"/buy "WHITE_E"to buy in this vending machine", id, VendingData[id][VendingName], VendingData[id][VendingOwner], VendingData[id][VendingStock],type);
			VendingData[id][VendingLabel] = CreateDynamic3DTextLabel(tstr, COLOR_YELLOW, VendingData[id][VendingPosX], VendingData[id][VendingPosY], VendingData[id][VendingPosZ]+1.0, 10.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, VendingData[id][VendingWorld], VendingData[id][VendingInterior], -1, 10.0);
			VendingData[id][VendingObjectID] = CreateDynamicObject(1209, VendingData[id][VendingPosX], VendingData[id][VendingPosY], VendingData[id][VendingPosZ], VendingData[id][VendingPosRX], VendingData[id][VendingPosRY], VendingData[id][VendingPosRZ], VendingData[id][VendingWorld], VendingData[id][VendingInterior]);
		}
		else if(VendingData[id][VendingPosX] != 0 && VendingData[id][VendingPosY] != 0 && VendingData[id][VendingPosZ] != 0)
		{
			format(tstr, sizeof(tstr), "[ID: %d]\n"WHITE_E"This Vending Machine is for sell\nLocation: %s\nPrice: "GREEN_E"%s\n"WHITE_E"Type: "YELLOW_E"%s", id, GetLocation(VendingData[id][VendingPosX], VendingData[id][VendingPosY], VendingData[id][VendingPosZ]), FormatMoney(VendingData[id][VendingPrice]), type);
			VendingData[id][VendingLabel] = CreateDynamic3DTextLabel(tstr, COLOR_YELLOW, VendingData[id][VendingPosX], VendingData[id][VendingPosY], VendingData[id][VendingPosZ]+1.0, 10.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, VendingData[id][VendingWorld], VendingData[id][VendingInterior], -1, 10.0);
			VendingData[id][VendingObjectID] = CreateDynamicObject(1209, VendingData[id][VendingPosX], VendingData[id][VendingPosY], VendingData[id][VendingPosZ], VendingData[id][VendingPosRX], VendingData[id][VendingPosRY], VendingData[id][VendingPosRZ], VendingData[id][VendingWorld], VendingData[id][VendingInterior]);
        }
		//printf("DEBUG: VendingRefresh Called on Vending ID %d", id);
	}
}

VendingSave(id)
{
    new cQuery[2248];
    format(cQuery, sizeof(cQuery), "UPDATE vending SET owner='%s', name='%s', price='%d', type='%d', money='%d', stock='%d', vprice0='%d', vprice1='%d', vprice2='%d', vprice3='%d', posx='%f', posy='%f', posz='%f', posa='%f', posrx='%f', posry='%f', posrz='%f', restock='%d' WHERE ID='%d'",
    VendingData[id][VendingOwner],
    VendingData[id][VendingName],
    VendingData[id][VendingPrice],
    VendingData[id][VendingType],
    VendingData[id][VendingMoney],
    VendingData[id][VendingStock],
    VendingData[id][VendingItemPrice][0],
	VendingData[id][VendingItemPrice][1],
	VendingData[id][VendingItemPrice][2],
	VendingData[id][VendingItemPrice][3],
    VendingData[id][VendingPosX],
    VendingData[id][VendingPosY],
    VendingData[id][VendingPosZ],
    VendingData[id][VendingPosA],
    VendingData[id][VendingPosRX],
    VendingData[id][VendingPosRY],
    VendingData[id][VendingPosRZ],
    VendingData[id][VendingRestock],
    id
    );
    return mysql_tquery(g_SQL, cQuery);
}

VendingProductMenu(playerid, id)
{
	if(id <= -1)
		return 0;

	static
		string[512];

	switch(VendingData[id][VendingType])
	{
		case 1:
		{
			format(string, sizeof(string), "Kaviar - %s\nSalad - %s\nCheetos - %s",
				FormatMoney(VendingData[id][VendingItemPrice][0]),
				FormatMoney(VendingData[id][VendingItemPrice][1]),
				FormatMoney(VendingData[id][VendingItemPrice][2])
			);
			ShowPlayerDialog(playerid, DIALOG_VENDING_EDITPROD, DIALOG_STYLE_LIST, VendingData[id][VendingName], string, "Buy", "Cancel");
		}
		case 2:
		{
			format(string, sizeof(string), "Soda - %s\nPepsi - %s",
				FormatMoney(VendingData[id][VendingItemPrice][0]),
				FormatMoney(VendingData[id][VendingItemPrice][1])
			);
			ShowPlayerDialog(playerid, DIALOG_VENDING_EDITPROD, DIALOG_STYLE_LIST, VendingData[id][VendingName], string, "Buy", "Cancel");
		}
	}
	return 1;
}

VendingBuyMenu(playerid, id)
{
	if(id <= -1)
		return 0;

	static
		string[512];

	switch(VendingData[id][VendingType])
	{
		case 1:
		{
			format(string, sizeof(string), "Kaviar - {3BBD44}%s(+16)\n{FFFFFF}Salad - {3BBD44}%s(+26)\n{FFFFFF}Frozen Snack - {3BBD44}%s(+38)",
				FormatMoney(VendingData[id][VendingItemPrice][0]),
				FormatMoney(VendingData[id][VendingItemPrice][1]),
				FormatMoney(VendingData[id][VendingItemPrice][2])
			);
			ShowPlayerDialog(playerid, DIALOG_VENDING_BUYPROD, DIALOG_STYLE_LIST, VendingData[id][VendingName], string, "Buy", "Cancel");
		}
		case 2:
		{
			format(string, sizeof(string), "Soda - {3BBD44}%s(+18)\n{FFFFFF}Pepsi - {3BBD44}%s(+33)",
				FormatMoney(VendingData[id][VendingItemPrice][0]),
				FormatMoney(VendingData[id][VendingItemPrice][1])
			);
			ShowPlayerDialog(playerid, DIALOG_VENDING_BUYPROD, DIALOG_STYLE_LIST, VendingData[id][VendingName], string, "Buy", "Cancel");
		}
	}
	return 1;
}

/* =======================[ Function, Hook goes here ]======================= */

function LoadVending()
{
    static bid;
	
	new rows = cache_num_rows(), owner[128], name[128];
 	if(rows)
  	{
		for(new i; i < rows; i++)
		{
			cache_get_value_name_int(i, "ID", bid);
			cache_get_value_name(i, "owner", owner);
			format(VendingData[bid][VendingOwner], 128, owner);
			cache_get_value_name(i, "name", name);
			format(VendingData[bid][VendingName], 128, name);
			cache_get_value_name_int(i, "type", VendingData[bid][VendingType]);
			cache_get_value_name_int(i, "price", VendingData[bid][VendingPrice]);
			cache_get_value_name_int(i, "money", VendingData[bid][VendingMoney]);
			cache_get_value_name_int(i, "stock", VendingData[bid][VendingStock]);
			cache_get_value_name_int(i, "vprice0", VendingData[bid][VendingItemPrice][0]);
			cache_get_value_name_int(i, "vprice1", VendingData[bid][VendingItemPrice][1]);
			cache_get_value_name_int(i, "vprice2", VendingData[bid][VendingItemPrice][2]);
			cache_get_value_name_int(i, "vprice3", VendingData[bid][VendingItemPrice][3]);
			cache_get_value_name_int(i, "restock", VendingData[bid][VendingRestock]);
			cache_get_value_name_float(i, "posx", VendingData[bid][VendingPosX]);
			cache_get_value_name_float(i, "posy", VendingData[bid][VendingPosY]);
			cache_get_value_name_float(i, "posz", VendingData[bid][VendingPosZ]);
			cache_get_value_name_float(i, "posa", VendingData[bid][VendingPosA]);
			cache_get_value_name_float(i, "posrx", VendingData[bid][VendingPosRX]);
			cache_get_value_name_float(i, "posry", VendingData[bid][VendingPosRY]);
			cache_get_value_name_float(i, "posrz", VendingData[bid][VendingPosRZ]);
			VendingRefresh(bid);
			Iter_Add(Vending, bid);
		}
		printf("[MySQL Vending] Number of Loaded: %d.", rows);
	}
}

function OnVendingCreated(id)
{
	VendingRefresh(id);
	VendingSave(id);
	return 1;
}

hook OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
	if(dialogid == DIALOG_VENDING_BUYPROD)
	{
		static
        vid = -1,
        price;

		if((vid = pData[playerid][pInVending]) != -1 && response)
		{
			price = VendingData[vid][VendingItemPrice][listitem];

			if(GetPlayerMoney(playerid) < price)
				return Error(playerid, "Not enough money!");

			if(VendingData[vid][VendingStock] < 1)
				return Error(playerid, "This vending is out of stock product.");
				
			/*new Float:health;
			GetPlayerHealth(playerid,health);*/
			if(VendingData[vid][VendingType] == 1)
			{
				switch(listitem)
				{
					case 0:
					{
						GivePlayerMoneyEx(playerid, -price);
						/*SetPlayerHealthEx(playerid, health+30);*/
						pData[playerid][pHunger] += 16;
						SendClientMessageEx(playerid, COLOR_LBLUE, "VENDING: {FFFFFF}You have purchased Kaviar for %s", FormatMoney(price));
						VendingData[vid][VendingStock]--;
						VendingData[vid][VendingMoney] += price;						
						VendingSave(vid);
						VendingRefresh(vid);
					}
					case 1:
					{
						GivePlayerMoneyEx(playerid, -price);
						pData[playerid][pHunger] += 26;
						SendClientMessageEx(playerid, COLOR_LBLUE, "VENDING: {FFFFFF}You have purchased Salad for %s", FormatMoney(price));
						VendingData[vid][VendingStock]--;
						VendingData[vid][VendingMoney] += price;			
						VendingSave(vid);
						VendingRefresh(vid);
					}
					case 2:
					{
						GivePlayerMoneyEx(playerid, -price);
						pData[playerid][pHunger] += 38;
						SendClientMessageEx(playerid, COLOR_LBLUE, "VENDING: {FFFFFF}You have purchased Cheetos for %s", FormatMoney(price));
						VendingData[vid][VendingStock]--;
						VendingData[vid][VendingMoney] += price;
						VendingSave(vid);
						VendingRefresh(vid);
					}
				}
			}
			else if(VendingData[vid][VendingType] == 2)
			{
				switch(listitem)
				{
					case 0:
					{
						GivePlayerMoneyEx(playerid, -price);
						pData[playerid][pEnergy] += 18;
						SendClientMessageEx(playerid, COLOR_LBLUE, "VENDING: {FFFFFF}You have purchased Soda for %s", FormatMoney(price));
						VendingData[vid][VendingStock]--;
						VendingData[vid][VendingMoney] += price;
						VendingSave(vid);
						VendingRefresh(vid);
					}
					case 1:
					{
						GivePlayerMoneyEx(playerid, -price);
						pData[playerid][pEnergy] += 33;
						SendClientMessageEx(playerid, COLOR_LBLUE, "VENDING: {FFFFFF}You have purchased Pepsi for %s", FormatMoney(price));
						VendingData[vid][VendingStock]--;
						VendingData[vid][VendingMoney] += price;
						VendingSave(vid);
						VendingRefresh(vid);
					}
				}
			}
		}
		return 1;
	}
	if(dialogid == DIALOG_VENDING_MANAGE)
	{
		new vid = pData[playerid][pInVending];
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
					new string[258];
					format(string, sizeof(string), "Vending ID: %d\nVending Name : %s\nVending Location: %s\nVending Vault: %s",
					vid, VendingData[vid][VendingName], GetLocation(VendingData[vid][VendingPosX], VendingData[vid][VendingPosY], VendingData[vid][VendingPosZ]), FormatMoney(VendingData[vid][VendingMoney]));

					ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_LIST, "Vending Information", string, "Cancel", "");
				}
				case 1:
				{
					new string[218];
					format(string, sizeof(string), "Tulis Nama Vending baru yang anda inginkan : ( Nama Vending Lama %s )", VendingData[vid][VendingName]);
					ShowPlayerDialog(playerid, DIALOG_VENDING_NAME, DIALOG_STYLE_INPUT, "Vending Change Name", string, "Select", "Cancel");
				}
				case 2:
				{
					ShowPlayerDialog(playerid, DIALOG_VENDING_VAULT, DIALOG_STYLE_LIST,"Vending Vault","Vending Deposit\nVending Withdraw","Select","Cancel");
				}
				case 3:
				{
					VendingProductMenu(playerid, vid);
				}
				case 4:
				{
					if(VendingData[vid][VendingStock] > 100)
						return Error(playerid, "Vending ini masih memiliki cukup produck.");
					if(VendingData[vid][VendingMoney] < 1000)
						return Error(playerid, "Setidaknya anda mempunyai uang dalamam vending anda senilai $1000 untuk merestock product.");
					VendingData[vid][VendingRestock] = 1;
					Info(playerid, "Anda berhasil request untuk mengisi stock product kepada trucker, harap tunggu sampai pekerja trucker melayani.");
				}
			}
		}
		return 1;
	}
	if(dialogid == DIALOG_VENDING_NAME)
	{
		if(response)
		{
			new bid = pData[playerid][pInVending];

			if(!PlayerOwnVending(playerid, pData[playerid][pInVending])) return Error(playerid, "You don't own this Vending Machine.");
			
			if (isnull(inputtext))
			{
				new mstr[512];
				format(mstr,sizeof(mstr),""RED_E"NOTE: "WHITE_E"Nama Vending tidak di perbolehkan kosong!\n\n"WHITE_E"Nama Vending sebelumnya: %s\n\nMasukkan nama Vending yang kamu inginkan\nMaksimal 32 karakter untuk nama Vending", VendingData[bid][VendingName]);
				ShowPlayerDialog(playerid, DIALOG_VENDING_NAME, DIALOG_STYLE_INPUT,"Vending Change Name", mstr,"Done","Back");
				return 1;
			}
			if(strlen(inputtext) > 32 || strlen(inputtext) < 5)
			{
				new mstr[512];
				format(mstr,sizeof(mstr),""RED_E"NOTE: "WHITE_E"Nama Vending harus 5 sampai 32 kata.\n\n"WHITE_E"Nama Vending sebelumnya: %s\n\nMasukkan nama Vending yang kamu inginkan\nMaksimal 32 karakter untuk nama Vending", VendingData[bid][VendingName]);
				ShowPlayerDialog(playerid, DIALOG_VENDING_NAME, DIALOG_STYLE_INPUT,"Vending Change Name", mstr,"Done","Back");
				return 1;
			}
			format(VendingData[bid][VendingName], 32, ColouredText(inputtext));

			VendingRefresh(bid);
			VendingSave(bid);

			SendClientMessageEx(playerid, COLOR_LBLUE,"Vending name set to: \"%s\".", VendingData[bid][VendingName]);
		}
		else return callcmd::vendingmanage(playerid, "\0");
		return 1;
	}
	if(dialogid == DIALOG_VENDING_VAULT)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
					new mstr[512];
					format(mstr,sizeof(mstr),"Uang kamu: %s.\n\nMasukkan berapa banyak uang yang akan kamu simpan di dalam Vending ini", FormatMoney(GetPlayerMoney(playerid)));
					ShowPlayerDialog(playerid, DIALOG_VENDING_DEPOSIT, DIALOG_STYLE_INPUT, "Vending Deposit Input", mstr, "Deposit", "Cancel");
				}
				case 1:
				{
					new mstr[512];
					format(mstr,sizeof(mstr),"Vending Vault: %s\n\nMasukkan berapa banyak uang yang akan kamu ambil di dalam Vending ini", FormatMoney(VendingData[pData[playerid][pInVending]][VendingMoney]));
					ShowPlayerDialog(playerid, DIALOG_VENDING_WITHDRAW, DIALOG_STYLE_INPUT,"Vending Withdraw Input", mstr, "Withdraw","Cancel");
				}
			}
		}
	}
	if(dialogid == DIALOG_VENDING_WITHDRAW)
	{
		if(response)
		{
			new bid = pData[playerid][pInVending];
			new amount = floatround(strval(inputtext));
			if(amount < 1 || amount > VendingData[bid][VendingMoney])
				return Error(playerid, "Invalid amount specified!");

			VendingData[bid][VendingMoney] -= amount;
			VendingSave(bid);

			GivePlayerMoneyEx(playerid, amount);

			Info(playerid, "You have withdrawn %s from the Vending vault.", FormatMoney(strval(inputtext)));
		}
		else
			ShowPlayerDialog(playerid, DIALOG_VENDING_VAULT, DIALOG_STYLE_LIST,"Vending Vault","Vending Deposit\nVending Withdraw","Next","Back");
		return 1;
	}
	if(dialogid == DIALOG_VENDING_DEPOSIT)
	{
		if(response)
		{
			new bid = pData[playerid][pInVending];
			new amount = floatround(strval(inputtext));
			if(amount < 1 || amount > GetPlayerMoney(playerid))
				return Error(playerid, "Invalid amount specified!");

			VendingData[bid][VendingMoney] += amount;
			VendingSave(bid);

			GivePlayerMoneyEx(playerid, -amount);
			
			Info(playerid, "You have deposit %s into the Vending vault.", FormatMoney(strval(inputtext)));
		}
		else
			ShowPlayerDialog(playerid, DIALOG_VENDING_VAULT, DIALOG_STYLE_LIST,"Vending Vault","Vending Deposit\nVending Withdraw","Next","Back");
		return 1;
	}
	if(dialogid == DIALOG_VENDING_EDITPROD)
	{
		if(PlayerOwnVending(playerid, pData[playerid][pInVending]))
		{
			if(response)
			{
				static
					item[40],
					str[128];

				strmid(item, inputtext, 0, strfind(inputtext, "-") - 1);
				strpack(pData[playerid][pEditingVendingItem], item, 40 char);

				pData[playerid][pVendingProductModify] = listitem;
				format(str,sizeof(str), "Please enter the new product price for %s:", item);
				ShowPlayerDialog(playerid, DIALOG_VENDING_PRICESET, DIALOG_STYLE_INPUT, "Vending: Set Price", str, "Modify", "Back");
			}
			else
				return callcmd::vendingmanage(playerid, "\0");
		}
		return 1;
	}
	if(dialogid == DIALOG_VENDING_PRICESET)
	{
		static
        item[40];
		new vid = pData[playerid][pInVending];
		if(PlayerOwnVending(playerid, pData[playerid][pInVending]))
		{
			if(response)
			{
				strunpack(item, pData[playerid][pEditingVendingItem]);

				if(isnull(inputtext))
				{
					new str[128];
					format(str,sizeof(str), "Please enter the new product price for %s:", item);
					ShowPlayerDialog(playerid, DIALOG_VENDING_PRICESET, DIALOG_STYLE_INPUT, "Vending: Set Price", str, "Modify", "Back");
					return 1;
				}
				if(strval(inputtext) < 1 || strval(inputtext) > 5000)
				{
					new str[128];
					format(str,sizeof(str), "Please enter the new product price for %s ($1 to $5,000):", item);
					ShowPlayerDialog(playerid, DIALOG_VENDING_PRICESET, DIALOG_STYLE_INPUT, "Vending: Set Price", str, "Modify", "Back");
					return 1;
				}
				VendingData[vid][VendingItemPrice][pData[playerid][pVendingProductModify]] = strval(inputtext);
				VendingSave(vid);

				SendClientMessageEx(playerid, COLOR_LBLUE, "You have adjusted the price of %s to: %s!", item, FormatMoney(strval(inputtext)));
				VendingProductMenu(playerid, vid);
			}
			else
			{
				VendingProductMenu(playerid, vid);
			}
		}
	}
	if(dialogid == DIALOG_VENDING_RESTOCK)
	{
		if(response)
		{
			new id = ReturnRestockVendingID((listitem + 1)), vehicleid = GetPlayerVehicleID(playerid);
			if(VendingData[id][VendingMoney] < 1000)
				return Error(playerid, "Maaf, Vending ini kehabisan uang product.");
			
			if(pData[playerid][pRestock] == 1)
				return Error(playerid, "Anda sudah sedang melakukan restock!");
			
			if(GetPlayerState(playerid) != PLAYER_STATE_DRIVER && !IsATruck(vehicleid)) return Error(playerid, "Anda harus mengendarai truck.");
				
			pData[playerid][pRestock] = id;
			VendingData[id][VendingRestock] = 0;
			
			new line9[900];
			new type[128];
			if(VendingData[id][VendingType] == 1)
			{
				type = "Froozen Snack";

			}
			else if(VendingData[id][VendingType] == 2)
			{
				type = "Soda";
			}
			else
			{
				type = "Unknown";
			}
			format(line9, sizeof(line9), "Silahkan anda membeli stock Vending di gudang!\n\nVending ID: %d\nVending Owner: %s\nVending Name: %s\nVending Type: %s\n\nSetelah itu ikuti checkpoint dan antarkan ke vending mission anda!",
			id, VendingData[id][VendingOwner], VendingData[id][VendingName], type);
			SetPlayerRaceCheckpoint(playerid,1, -279.67, -2148.42, 28.54, 0.0, 0.0, 0.0, 3.5);
			//SetPlayerCheckpoint(playerid, -279.67, -2148.42, 28.54, 3.5);
			ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_MSGBOX, "Restock Info", line9, "Close","");
		}
	}
	return 1;
}

/* =======================[ Timer goes here ]======================= */

ptask PlayerVendingUpdate[1000](playerid)
{
	foreach(new vid : Vending)
	{
		if(IsPlayerInRangeOfPoint(playerid, 3.0, VendingData[vid][VendingPosX], VendingData[vid][VendingPosY], VendingData[vid][VendingPosZ]))
		{
			pData[playerid][pInVending] = vid;
			//Info(playerid, "DEBUG MESSAGE: Kamu berada di dekat Vending ID %d", vid);
		}
	}
	return 1;
}
