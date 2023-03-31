#include <YSI_Coding\y_hooks>

#define MAX_RENTAL 20

enum RentalVariabel
{
	Float:rentalPosX,
	Float:rentalPosY,
	Float:rentalPosZ,
	Float:rentalPosA,

	// Hooked by RentalRefresh
	rentalPickup,
	Text3D:rentalLabel,
};

new RentalData[MAX_RENTAL][RentalVariabel];
new Iterator:Rental<MAX_RENTAL>;

CMD:editrental(playerid, params[])
{
    static
        did,
        type[24],
        string[128];

    if(pData[playerid][pAdmin] < 6)
        return PermissionError(playerid);

    if(sscanf(params, "ds[24]S()[128]", did, type, string))
    {
        Usage(playerid, "/editrental [id] [name]");
        SendClientMessage(playerid, COLOR_YELLOW, "[NAMES]:{FFFFFF} location");
        return 1;
    }
    if((did < 0 || did > MAX_RENTAL))
        return Error(playerid, "You have specified an invalid ID.");

	if(!Iter_Contains(Rental, did)) return Error(playerid, "The rent you specified ID of doesn't exist.");

    if(!strcmp(type, "location", true))
    {
		GetPlayerPos(playerid, RentalData[did][rentalPosX], RentalData[did][rentalPosY], RentalData[did][rentalPosZ]);
		GetPlayerFacingAngle(playerid, RentalData[did][rentalPosA]);
        RentalSave(did);
		RentalRefresh(did);

        SendAdminMessage(COLOR_RED, "%s Changes Location Rental ID: %d.", pData[playerid][pAdminname], did);
    }
    return 1;
}

CMD:createrental(playerid, params[])
{
	if(pData[playerid][pAdmin] < 6)
		return PermissionError(playerid);
	
	new query[512];
	new rentalid = Iter_Free(Rental);

	if(rentalid == -1)
		return Error(playerid, "You cant create more rental point");

	if((rentalid < 0 || rentalid >= MAX_RENTAL))
        return Error(playerid, "You have already input 15 rental point in this server.");


	GetPlayerPos(playerid, RentalData[rentalid][rentalPosX], RentalData[rentalid][rentalPosY], RentalData[rentalid][rentalPosZ]);
	GetPlayerFacingAngle(playerid, RentalData[rentalid][rentalPosA]);

	Iter_Add(Rental, rentalid);

	mysql_format(g_SQL, query, sizeof(query), "INSERT INTO rental SET ID='%d', posx='%f', posy='%f', posz='%f', posa='%f'", rentalid, RentalData[rentalid][rentalPosX], RentalData[rentalid][rentalPosY], RentalData[rentalid][rentalPosZ], RentalData[rentalid][rentalPosA]);
	mysql_tquery(g_SQL, query, "OnRentalCreated", "i", rentalid);
	return 1;
}

CMD:deleterental(playerid, params[])
{
	if(pData[playerid][pAdmin] < 6)
		return PermissionError(playerid);

	new bid;

	if(sscanf(params, "d", bid))
		return Usage(playerid, "/deleterental [id]");

	if(bid < 0 || bid >= MAX_RENTAL)
        return Error(playerid, "You have specified an invalid ID.");

	if(!Iter_Contains(Rental, bid))
		return Error(playerid, "The rental point you specified ID of doesn't exist.");

	RentalReset(bid);
		
	DestroyDynamic3DTextLabel(RentalData[bid][rentalLabel]);

    DestroyDynamicPickup(RentalData[bid][rentalPickup]);
		
	RentalData[bid][rentalPosX] = 0;
	RentalData[bid][rentalPosY] = 0;
	RentalData[bid][rentalPosZ] = 0;
	RentalData[bid][rentalPosA] = 0;
	RentalData[bid][rentalLabel] = Text3D:INVALID_3DTEXT_ID;
	RentalData[bid][rentalPickup] = -1;
		
	Iter_Remove(Rental, bid);
	new query[128];
	mysql_format(g_SQL, query, sizeof(query), "DELETE FROM rental WHERE ID=%d", bid);
	mysql_tquery(g_SQL, query);
    SendAdminMessage(COLOR_RED, "%s has delete rental point ID: %d.", pData[playerid][pAdminname], bid);
    return 1;
}

CMD:gotorental(playerid, params[])
{
	if(pData[playerid][pAdmin] < 6)
		return PermissionError(playerid);

	new bid;

	if(sscanf(params, "d", bid))
		return Usage(playerid, "/gotorental [id]");

	if(bid < 0 || bid >= MAX_RENTAL)
        return Error(playerid, "You have specified an invalid ID.");

	if(!Iter_Contains(Rental, bid))
		return Error(playerid, "The rental point you specified ID of doesn't exist.");

	SetPlayerPos(playerid, RentalData[bid][rentalPosX], RentalData[bid][rentalPosY], RentalData[bid][rentalPosZ]);
	SetPlayerFacingAngle(playerid, RentalData[bid][rentalPosA]);
		
    SendClientMessageEx(playerid, COLOR_WHITE, "You has teleport to rental point id %d", bid);
    return 1;
}

CMD:rentveh(playerid, params[])
{
	if(!IsPlayerInRangeOfPoint(playerid, 3.0, RentalData[rentalid][rentalPosX], RentalData[rentalid][rentalPosY], RentalData[rentalid][rentalPosZ])) return Error(playerid, "Anda harus berada di Rental Point!");
	{
		new str[1024];
		format(str, sizeof(str), ""WHITE_E"%s\t"LG_E"$50.00 / one days\n%s\t"LG_E"$80.00 / one days\n%s\t"LG_E"$100.00 / one days\n%s\t"LG_E"$150.00 / one days\n%s\t"LG_E"$200.00 / one days",
		GetVehicleModelName(414),
		GetVehicleModelName(462),
		GetVehicleModelName(586),
		GetVehicleModelName(426),
		GetVehicleModelName(547)
		);

		ShowPlayerDialog(playerid, DIALOG_RENT_VEHICLE, DIALOG_STYLE_LIST, "Rent Job Cars", str, "Rent", "Close");
	}
	return 1;
}

/* ============ [ Stock goes here ] ============ */

RentalSave(id)
{
	new cQuery[2248];
	format(cQuery, sizeof(cQuery), "UPDATE rental SET posx='%f', posy='%f', posz='%f', posa='%f' WHERE ID='%d'",
	RentalData[id][rentalPosX],
	RentalData[id][rentalPosY],
	RentalData[id][rentalPosZ],
	RentalData[id][rentalPosA],
	id
	);
	return mysql_tquery(g_SQL, cQuery);
}

RentalRefresh(id)
{
	if(id != -1)
	{		
		if(IsValidDynamic3DTextLabel(RentalData[id][rentalLabel]))
            DestroyDynamic3DTextLabel(RentalData[id][rentalLabel]);

        if(IsValidDynamicPickup(RentalData[id][rentalPickup]))
            DestroyDynamicPickup(RentalData[id][rentalPickup]);
		
		new tstr[218];
		if(RentalData[id][rentalPosX] != 0 && RentalData[id][rentalPosY] != 0 && RentalData[id][rentalPosZ] != 0))
		{
			format(tstr, sizeof(tstr), "[ID: %d]\n"WHITE_E"Rental Point\n"WHITE_E"Use "YELLOW_E"/rentveh\n"WHITE_E"to Rental vehicle", id);
			RentalData[id][rentalLabel] = CreateDynamic3DTextLabel(tstr, COLOR_RIKO, RentalData[id][rentalPosX], RentalData[id][rentalPosY], RentalData[id][rentalPosZ], 5.0);
            RentalData[id][rentalPickup] = CreateDynamicPickup(1239, 23, RentalData[id][rentalPosX], RentalData[id][rentalPosY], RentalData[id][rentalPosZ]);
		}
		printf("DEBUG: RentalRefresh Called on Rental Point ID %d", id);
	}
}

RentalReset(id)
{
	DestroyDynamicPickup(RentalData[id][rentalPickup]);
	RentalRefresh(id);
}

GetRentalVehicleCost(carid)
{
	//RENT VEHICLE
    if(carid == 481) return 5000;  //Bmx
	if(carid == 586) return 8000; //Wayfare
	if(carid == 462) return 8000; //Faggio
	if(carid == 426) return 8000; //Premier
	if(carid == 547) return 8000; //Primo
 	return -1;
}

/* ============ [ Hook, Function goes here ] ============ */

hook OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
	if(dialogid == DIALOG_RENT_VEHICLE)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
					new modelid = 481;
					new tstr[128];
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan menyewa kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"$80.00 / one days", GetVehicleModelName(modelid));
					ShowPlayerDialog(playerid, DIALOG_RENT_VEHICLECONFIRM, DIALOG_STYLE_MSGBOX, "Rental Vehicles", tstr, "Rental", "Batal");
				}
				case 1:
				{
					new modelid = 462;
					new tstr[128];
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan menyewa kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"$80.00 / one days", GetVehicleModelName(modelid));
					ShowPlayerDialog(playerid, DIALOG_RENT_VEHICLECONFIRM, DIALOG_STYLE_MSGBOX, "Rental Vehicles", tstr, "Rental", "Batal");
				}
				case 2:
				{
					new modelid = 586;
					new tstr[128];
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan menyewa kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"$80.00 / one days", GetVehicleModelName(modelid));
					ShowPlayerDialog(playerid, DIALOG_RENT_VEHICLECONFIRM, DIALOG_STYLE_MSGBOX, "Rental Vehicles", tstr, "Rental", "Batal");
				}
				case 3:
				{
					new modelid = 426;
					new tstr[128];
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan menyewa kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"$80.00 / one days", GetVehicleModelName(modelid));
					ShowPlayerDialog(playerid, DIALOG_RENT_VEHICLECONFIRM, DIALOG_STYLE_MSGBOX, "Rental Vehicles", tstr, "Rental", "Batal");
				}
				case 4:
				{
					new modelid = 547;
					new tstr[128];
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan menyewa kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"$80.00 / one days", GetVehicleModelName(modelid));
					ShowPlayerDialog(playerid, DIALOG_RENT_VEHICLECONFIRM, DIALOG_STYLE_MSGBOX, "Rental Vehicles", tstr, "Rental", "Batal");
				}
			}
		}
	}
	if(dialogid == DIALOG_RENT_VEHICLECONFIRM)
	{
		new modelid = pData[playerid][pBuyPvModel];
		if(response)
		{
			if(modelid <= 0) return Error(playerid, "Invalid model id.");
			new cost = GetRentalVehicleCost(modelid);
			if(pData[playerid][pMoney] < 8000)
			{
				Error(playerid, "Uang anda tidak mencukupi.!");
				return 1;
			}
			new count = 0, limit = MAX_PLAYER_VEHICLE + pData[playerid][pVip];
			foreach(new ii : PVehicles)
			{
				if(pvData[ii][cOwner] == pData[playerid][pID])
					count++;
			}
			if(count >= limit)
			{
				Error(playerid, "Slot kendaraan anda sudah penuh, silahkan jual beberapa kendaraan anda terlebih dahulu!");
				return 1;
			}
			GivePlayerMoneyEx(playerid, -8000);
			new cQuery[1024];
			new Float:x,Float:y,Float:z, Float:a;
			new model, color1, color2, rental;
			color1 = 1;
			color2 = 1;
			model = modelid;
			x = RentalData[rentalid][rentalPosX];
			y = RentalData[rentalid][rentalPosY];
			z = RentalData[rentalid][rentalPosZ];
			rental = gettime() + (1 * 86400);
			mysql_format(g_SQL, cQuery, sizeof(cQuery), "INSERT INTO `vehicle` (`owner`, `model`, `color1`, `color2`, `price`, `x`, `y`, `z`, `a`, `rental`) VALUES (%d, %d, %d, %d, %d, '%f', '%f', '%f', '%f', '%d')", pData[playerid][pID], model, color1, color2, cost, x, y, z, a, rental);
			mysql_tquery(g_SQL, cQuery, "OnRentVehPV", "ddddddffffd", playerid, pData[playerid][pID], model, color1, color2, cost, x, y, z, a, rental);
			return 1;
		}
		else
		{
			pData[playerid][pBuyPvModel] = 0;
		}
	}

function OnRentVehPV(playerid, pid, model, color1, color2, cost, Float:x, Float:y, Float:z, Float:a)
{
	new i = Iter_Free(PVehicles);
	pvData[i][cID] = cache_insert_id();
	pvData[i][cOwner] = pid;
	pvData[i][cModel] = model;
	pvData[i][cColor1] = color1;
	pvData[i][cColor2] = color2;
	pvData[i][cPaintJob] = -1;
	pvData[i][cNeon] = 0;
	pvData[i][cTogNeon] = 0;
	pvData[i][cLocked] = 0;
	pvData[i][cInsu] = 3;
	pvData[i][cClaim] = 0;
	pvData[i][cClaimTime] = 0;
	pvData[i][cTicket] = 0;
	pvData[i][cPrice] = cost;
	pvData[i][cHealth] = 1000;
	pvData[i][cFuel] = 1000;
	format(pvData[i][cPlate], 16, "NoHave");
	pvData[i][cPlateTime] = 0;
	pvData[i][cPosX] = x;
	pvData[i][cPosY] = y;
	pvData[i][cPosZ] = z;
	pvData[i][cPosA] = a;
	pvData[i][cInt] = 0;
	pvData[i][cVw] = 0;
	pvData[i][cLumber] = -1;
	pvData[i][cMetal] = 0;
	pvData[i][cCoal] = 0;
	pvData[i][cProduct] = 0;
	pvData[i][cGasOil] = 0;
	for(new j = 0; j < 17; j++)
		pvData[i][cMod][j] = 0;
	Iter_Add(PVehicles, i);
	OnVehicleRentalRespawn(i);
	Servers(playerid, "Anda telah membeli kendaraan %s dengan harga %s", GetVehicleModelName(model), FormatMoney(GetRentalVehicleCost(model)));
	pData[playerid][pBuyPvModel] = 0;
	SetPlayerVirtualWorld(playerid, 0);
	return 1;
}

function OnVehicleRentalRespawn(i)
{
	pvData[i][cVeh] = CreateVehicle(pvData[i][cModel], pvData[i][cPosX], pvData[i][cPosY], pvData[i][cPosZ], pvData[i][cPosA], pvData[i][cColor1], pvData[i][cColor2], 60000);
	SetVehicleNumberPlate(pvData[i][cVeh], pvData[i][cPlate]);
	SetVehicleVirtualWorld(pvData[i][cVeh], pvData[i][cVw]);
	LinkVehicleToInterior(pvData[i][cVeh], pvData[i][cInt]);
	SetVehicleFuel(pvData[i][cVeh], pvData[i][cFuel]);
	if(pvData[i][cHealth] < 350.0)
	{
		SetValidVehicleHealth(pvData[i][cVeh], 350.0);
	}
	else
	{
		SetValidVehicleHealth(pvData[i][cVeh], pvData[i][cHealth]);
	}
	UpdateVehicleDamageStatus(pvData[i][cVeh], pvData[i][cDamage0], pvData[i][cDamage1], pvData[i][cDamage2], pvData[i][cDamage3]);
	if(pvData[i][cVeh] != INVALID_VEHICLE_ID)
    {
        if(pvData[i][cPaintJob] != -1)
        {
            ChangeVehiclePaintjob(pvData[i][cVeh], pvData[i][cPaintJob]);
        }
		for(new z = 0; z < 17; z++)
		{
			if(pvData[i][cMod][z]) AddVehicleComponent(pvData[i][cVeh], pvData[i][cMod][z]);
		}
		if(pvData[i][cLocked] == 1)
		{
			SwitchVehicleDoors(pvData[i][cVeh], true);
		}
		else
		{
			SwitchVehicleDoors(pvData[i][cVeh], false);
		}
	}
	return 1;
}

function OnRentalCreated(rentalid)
{
	RentalRefresh(rentalid);
	RentalSave(rentalid);
	return 1;
}

function LoadRental()
{
    static bid;
	
	new rows = cache_num_rows();
 	if(rows)
  	{
		for(new i; i < rows; i++)
		{
			cache_get_value_name_int(i, "ID", bid);
			cache_get_value_name_float(i, "posx", RentalData[bid][rentalPosX]);
			cache_get_value_name_float(i, "posy", RentalData[bid][rentalPosY]);
			cache_get_value_name_float(i, "posz", RentalData[bid][rentalPosZ]);
			cache_get_value_name_float(i, "posa", RentalData[bid][rentalPosA]);
			RentalRefresh(bid);
			Iter_Add(Rental, bid);
		}
		printf("[Dynamic Rental] Number of Loaded: %d.", rows);
	}
}


ptask PlayerRentalUpdate[1000](playerid)
{
	foreach(new vid : Rental)
	{
		if(IsPlayerInRangeOfPoint(playerid, 2.5, RentalData[vid][rentalPosX], RentalData[vid][rentalPosY], RentalData[vid][rentalPosZ]))
		{
			pData[playerid][pInRental] = vid;
			/*Info(playerid, "DEBUG MESSAGE: Kamu berada di dekat Dealer ID %d", vid);*/
		}
	}
	return 1;
}
