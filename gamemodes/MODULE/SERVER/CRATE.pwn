#include <YSI\y_hooks>

// --
// Definition list
// --

#define MAX_CARGO			(200)
#define MAX_CARGO_LOADED	(10)

//Variable list
new ListedCargo[MAX_PLAYERS][MAX_CARGO_LOADED];

//Enum list

enum E_CARGO {
	//saved
	cargoID,
	cargoType,
	cargoVehicle,
	cargoExpired,

	Float:cargoX,
	Float:cargoY,
	Float:cargoZ,
	Float:cargoA,

	//temp
	cargoExists,
	cargoPickup,
	cargoObject,
	Text3D:cargoLabel
};

enum    _:E_CARGO_TYPE {
	CARGO_NONE = 0,
	CARGO_BUSINESS,
	CARGO_COMPONENT,
	CARGO_MATERIAL,
	CARGO_FISH
}

new CargoData[MAX_CARGO][E_CARGO];

hook OnPlayerDisconnect(playerid, reason)
{
	for(new i = 0; i != MAX_CARGO; i++) if (CargoData[i][cargoExists] && CargoData[i][cargoPickup] == pData[playerid][pID]) {
		GetPlayerPos(playerid, CargoData[i][cargoX], CargoData[i][cargoY], CargoData[i][cargoZ]);
		GetPlayerFacingAngle(playerid, CargoData[i][cargoA]);

		CargoData[i][cargoPickup] = 0;
		Cargo_Sync(i);
	}
}

//Load list
function Cargo_Load()
{
	new rows = cache_num_rows();
	if(rows)
  	{
		for(new i; i < rows; i++)	 if(i < MAX_CARGO)
		{
			cache_get_value_name_int(i, "ID", CargoData[i][cargoID]);
			cache_get_value_name_int(i, "Type", CargoData[i][cargoType]);
			cache_get_value_name_int(i, "Vehicle", CargoData[i][cargoVehicle]);
			cache_get_value_name_int(i, "time", CargoData[i][cargoExpired]);

			CargoData[i][cargoPickup] = 0;
			
			cache_get_value_name_float(i, "X", CargoData[i][cargoX]);
			cache_get_value_name_float(i, "Y", CargoData[i][cargoY]);
			cache_get_value_name_float(i, "Z", CargoData[i][cargoZ]);
			cache_get_value_name_float(i, "A", CargoData[i][cargoA]);
			
			CargoData[i][cargoExists] = true;

        	Cargo_Sync(i);
		}
	}
    return 1;
}

//Save List
function Cargo_Save(i)
{
	if (!CargoData[i][cargoExists])
		return printf("[Cargo System] Can't save crate id %d", i), 0;

	new string[128];

	format(string, sizeof(string), "UPDATE cargo SET Type='%d', Vehicle='%d', X='%.2f', Y='%.2f', Z='%.2f', A='%.2f', time=%d WHERE ID='%d'", 
		CargoData[i][cargoType],
		CargoData[i][cargoVehicle],
		CargoData[i][cargoX],
		CargoData[i][cargoY],
		CargoData[i][cargoZ],
		CargoData[i][cargoA],
		CargoData[i][cargoExpired],
		CargoData[i][cargoID]
	);
	return mysql_tquery(g_SQL, string);
}

//Sync function
stock Cargo_Sync(i)
{
	if (!CargoData[i][cargoExists])
		return printf("[Cargo System] Can't desync crate id %d", i), 0;

	if (IsValidDynamicObject(CargoData[i][cargoObject]))
		DestroyDynamicObject(CargoData[i][cargoObject]);

	if (IsValidDynamic3DTextLabel(CargoData[i][cargoLabel]))
		DestroyDynamic3DTextLabel(CargoData[i][cargoLabel]);

	if (!CargoData[i][cargoPickup] && !CargoData[i][cargoVehicle])
	{
		CargoData[i][cargoLabel] = CreateDynamic3DTextLabel(sprintf("%s", Cargo_TypeName(i)), 0xC0C0C0EE, CargoData[i][cargoX], CargoData[i][cargoY], CargoData[i][cargoZ], 3);
		CargoData[i][cargoObject] = CreateDynamicObject(1271, CargoData[i][cargoX], CargoData[i][cargoY], CargoData[i][cargoZ]-0.6, 0, 0, CargoData[i][cargoA], _, _, _, 40);
	}
	Cargo_Save(i);
	return 1;
}

//other function
stock Cargo_TypeName(id)
{
	new name[32];
	switch(CargoData[id][cargoType])
	{
		case CARGO_BUSINESS: name="Business Crate";
		case CARGO_COMPONENT: name="Raw Component Crate";
		case CARGO_MATERIAL: name=" Raw Material Crate";
		case CARGO_FISH: name="Fish Crate";
	}
	return name;
}

stock Cargo_Name(id)
{
	new name[32];
	switch(id)
	{
		case 1: name="Business Crate";
		case 2: name="Raw Component Crate";
		case 3: name=" Raw Material Crate";
		case 4: name="Fish Crate";
	}
	return name;
}

stock Cargo_TypeAmount(id, type=0, types=0)
{
	new amount, price;

//	#define C_TYPE types
	if(!types) {
		switch(CargoData[id][cargoType])
		{
			case CARGO_BUSINESS: amount=10, price=ProductPrice*amount;
			case CARGO_COMPONENT: amount=10, price=0;
			case CARGO_MATERIAL: amount=10, price=0;
			case CARGO_FISH: amount=10, price=0;    // gratis soalnya raw/ mentah
		}
	}
	else {
		switch(types)
		{
			case CARGO_BUSINESS: amount=10, price=ProductPrice*amount;
			case CARGO_COMPONENT: amount=10, price=0;
			case CARGO_MATERIAL: amount=10, price=0;
			case CARGO_FISH: amount=10, price=0;
		}
	}
	if (!type)
		return amount;
	else
		return price;
}

stock Cargo_Nearest(playerid, Float:range = 2.0)
{
    for(new i = 0; i != MAX_CARGO; i++) if(IsPlayerInRangeOfPoint(playerid, range, CargoData[i][cargoX], CargoData[i][cargoY], CargoData[i][cargoZ]) && !CargoData[i][cargoPickup] && !CargoData[i][cargoVehicle]) {
        return i;
    }
    return -1;
}

stock Cargo_GetCount(id)
{
    new count;

    for(new i = 0; i != MAX_CARGO; i++) if(CargoData[i][cargoVehicle] == pvData[id][cID]) {
        count++;
    }
    return count;
}

stock Cargo_Destroy(id)
{
	if (IsValidDynamicObject(CargoData[id][cargoObject])) DestroyDynamicObject(CargoData[id][cargoObject]);
	if (IsValidDynamic3DTextLabel(CargoData[id][cargoLabel])) DestroyDynamic3DTextLabel(CargoData[id][cargoLabel]);

	CargoData[id][cargoExists] = false;
	CargoData[id][cargoType] = CARGO_NONE;
	CargoData[id][cargoVehicle] = 0;
	CargoData[id][cargoPickup] = 0;

	CargoData[id][cargoObject] = INVALID_STREAMER_ID;
	CargoData[id][cargoLabel] = Text3D:INVALID_STREAMER_ID;


	mysql_tquery(g_SQL, sprintf("DELETE FROM cargo WHERE ID='%d'", CargoData[id][cargoID]));
	CargoData[id][cargoID] = 0;
	return 1;
}

stock Cargo_FreeID()
{
	for(new i = 0; i != MAX_CARGO; i++) if (!CargoData[i][cargoExists]) {
		return i;
	}
	return -1;
}

stock Cargo_Create(playerid, type)
{
	new 
		id = Cargo_FreeID();

	if (id != -1) 
	{
		CargoData[id][cargoExists] = true;

		CargoData[id][cargoType] = type;
		CargoData[id][cargoVehicle] = 0;
		CargoData[id][cargoExpired] = gettime();
		CargoData[id][cargoPickup] = 0;

		static 
			Float:x, Float:y, Float:z, Float:angle;
				
		GetPlayerPos(playerid, x, y, z);
	    GetPlayerFacingAngle(playerid, angle);

	    x += 0.7 * floatsin(-angle, degrees);
	    y += 0.7 * floatcos(-angle, degrees);

		CargoData[id][cargoX] = x;
		CargoData[id][cargoY] = y;
		CargoData[id][cargoZ] = z;
		CargoData[id][cargoA] = angle;

		mysql_tquery(g_SQL, sprintf("INSERT INTO `cargo` (`Type`) VALUES(%d)", CargoData[id][cargoType]), "Cargo_Created", "d", id);
	}
	return id;
}

function Cargo_Created(id)
{
	CargoData[id][cargoID] = cache_insert_id();

	Cargo_Sync(id);
	return 1;
}

stock Cargo_Hold(playerid)
{
	for(new i = 0; i != MAX_CARGO; i++) if (CargoData[i][cargoPickup] == pData[playerid][pID]) {
		return i;
	}	
	return -1;
}

stock Cargo_AnimPlay(playerid)
{
	if(IsPlayerAttachedObjectSlotUsed(playerid, 9))
		RemovePlayerAttachedObject(playerid, 9);

	SetPlayerAttachedObject(playerid, 9, 1271, 1,0.237980,0.473312,-0.066999, 1.099999,88.000007,-177.400085, 0.716000,0.572999,0.734000);
	SetPlayerSpecialAction(playerid, SPECIAL_ACTION_CARRY);
	ApplyAnimation(playerid, "CARRY", "liftup", 4.1, 0, 0, 0, 0, 0, 1);
	return 1;
}

stock Cargo_AnimStop(playerid)
{
	ApplyAnimation(playerid, "CARRY", "putdwn", 4.0, 0, 0, 0, 0, 0);
	SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
	RemovePlayerAttachedObject(playerid, 9);
	return 1;
}

//=============================================================================================================================================================

Dialog:CargoList(playerid, response, listitem, inputtext[])
{
	if(response)
	{
		new id = ListedCargo[playerid][listitem];
		CargoData[id][cargoVehicle] = 0;
		CargoData[id][cargoPickup] = pData[playerid][pID];

		GetPlayerPos(playerid, CargoData[id][cargoX], CargoData[id][cargoY], CargoData[id][cargoZ]);
		GetPlayerFacingAngle(playerid, CargoData[id][cargoA]);

		Cargo_AnimPlay(playerid);

		Servers(playerid, "You've pick up {ffff00}%s {ffffff}from this vehicle.", Cargo_TypeName(id));
	}
	return 1;
}

CMD:cargo(playerid, params[])
{
	static
		opsi[16],
		string[128],
		id;

	if(pData[playerid][pJob] != 4 && pData[playerid][pJob2] != 4) return Error(playerid, "You're not a trucker.");
	if (sscanf(params, "s[16]S()[128]", opsi, string)) return Usage(playerid, "/cargo [buy/sell/list/place/putdown/pickup]");

	if(!strcmp(opsi, "buy")) {
		new crate = CARGO_NONE;

		if (Cargo_Hold(playerid) != -1) return Error(playerid, "You're holding a cargo, putdown it first.");
		if (GetPlayerMoney(playerid) < Cargo_TypeAmount(crate)) return Error(playerid, "You don't have enough money.");

		if(IsPlayerInRangeOfPoint(playerid, 2.5, -279.67, -2148.42, 28.54)) crate = 1;
		else return Error(playerid, "You're not in any cargo factory.");

        if(crate == CARGO_BUSINESS)
        {
            id = Cargo_Create(playerid, crate);
            GivePlayerMoneyEx(playerid, -Cargo_TypeAmount(id, 1));
            Servers(playerid, "You've buy {ffff00}%s {ffffff}for {00ff00}%s.", Cargo_TypeName(id), FormatMoney(Cargo_TypeAmount(id, 1)));
            CargoData[id][cargoVehicle] = 0;
            CargoData[id][cargoPickup] = pData[playerid][pID];
            Cargo_AnimPlay(playerid);
        }
	}
	else if(!strcmp(opsi, "get")) {
		new crate = CARGO_NONE;

		if (Cargo_Hold(playerid) != -1) return Error(playerid, "You're holding a cargo, putdown it first.");

		if(IsPlayerInRangeOfPoint(playerid, 2.5, 331.1737, 920.4896, 20.4063)) crate = 2;//component
		else if(IsPlayerInRangeOfPoint(playerid, 2.5, -23.3818, -270.3624, 5.4297)) crate = 3;//material
		else if(IsPlayerInRangeOfPoint(playerid, 2.5, 1352.4987, 356.0309, 19.8482)) crate = 4;//fish
		else return Error(playerid, "You're not in any cargo factory.");

        if(crate != CARGO_BUSINESS)
        {
            id = Cargo_Create(playerid, crate);
            Servers(playerid, "You've pickup {ffff00}%s", Cargo_TypeName(id));
            CargoData[id][cargoVehicle] = 0;
            CargoData[id][cargoPickup] = pData[playerid][pID];
            Cargo_AnimPlay(playerid);
        }
	}
	else if(!strcmp(opsi, "list")) {
		if((id = Vehicle_Nearest(playerid, 5.5)) != -1)
        {
            if(IsPlayerInAnyVehicle(playerid)) return Error(playerid, "You must exit the vehicle first.");
            //if(!IsPlayerNearBoot(playerid, pvData[id][cVeh])) return Error(playerid, "You're not near vehicle trunk.");
            //if(!IsLoadableVehicle(pvData[id][cVeh])) return Error(playerid, "This is not loaded able vehicle.");
            if (Cargo_Hold(playerid) != -1) return Error(playerid, "You're holding a cargo, putdown it first.");

            new str[128], count = 0;

            format(str, sizeof(str), "#\tProduct\tpcs\n");
            for(new i = 0; i != MAX_CARGO; i++) if (CargoData[i][cargoVehicle] == pvData[id][cID]) {
            	format(str, sizeof(str), "%s{000000}%d\t{00FF00}%s\t%d\n", str, i, Cargo_TypeName(i), Cargo_TypeAmount(i));
            	ListedCargo[playerid][count++] = i;
            }
            if(!count) Error(playerid, "This vehicle not loaded any cargo.");
            else Dialog_Show(playerid, CargoList, DIALOG_STYLE_TABLIST_HEADERS, "Cargo List", str, "Pick Up", "Close");
            return 1;
        }
        Error(playerid, "You are not in range of any vehicle.");
	}
	else if(!strcmp(opsi, "place")) {
		if((id = Vehicle_Nearest(playerid, 5.5)) != -1)
        {
            if(IsPlayerInAnyVehicle(playerid)) return Error(playerid, "You must exit the vehicle first.");
            if(!IsPlayerNearBoot(playerid, pvData[id][cVeh])) return Error(playerid, "You're not near vehicle trunk.");
            if(!IsLoadableVehicle(pvData[id][cVeh])) return Error(playerid, "This is not loaded able vehicle.");
            if(pvData[id][cLocked]) return Error(playerid, "The vehicle's is locked.");

            static 
            	i = -1;

            if ((i = Cargo_Hold(playerid)) != -1)
            {
            	if(Cargo_GetCount(id) >= MAX_CARGO_LOADED) return Error(playerid, "This vehicle reached limit to save a cargo (max %d).", MAX_CARGO_LOADED);

            	CargoData[i][cargoPickup] = 0;
            	CargoData[i][cargoVehicle] = pvData[id][cID];
            	CargoData[i][cargoExpired] = gettime();

            	Cargo_Sync(i);

            	Cargo_AnimStop(playerid);
            	Servers(playerid, "You have loaded {ffff00}%s {ffffff}to this vehicle.", Cargo_TypeName(i));
            }
            else Error(playerid, "You are not holding a cargo.");
        }
        else Error(playerid, "This is static vehicle, can't put on this vehicle.");
	}
	else if(!strcmp(opsi, "putdown")) {
		if ((id = Cargo_Hold(playerid)) != -1) {
			if(Cargo_Nearest(playerid, 1.5) != -1) return Error(playerid, "Can't putdown in nearest other cargo."); 

			static 
				Float:x, Float:y, Float:z, Float:angle;

			GetPlayerPos(playerid, x, y, z);
	        GetPlayerFacingAngle(playerid, angle);

            x += 0.7 * floatsin(-angle, degrees);
            y += 0.7 * floatcos(-angle, degrees);

			CargoData[id][cargoPickup] = 0;
			CargoData[id][cargoX] = x;
			CargoData[id][cargoY] = y;
			CargoData[id][cargoZ] = z;
			CargoData[id][cargoA] = angle;

			CargoData[id][cargoExpired] = gettime();

			Cargo_Sync(id);

			Cargo_AnimStop(playerid);
			return 1;
		}
		Error(playerid, "You are not holding a cargo.");	
	}
	else if(!strcmp(opsi, "pickup")) {
		if((id = Cargo_Nearest(playerid)) != -1) {
			if (Cargo_Hold(playerid) != -1) return Error(playerid, "You're holding a cargo.");
			CargoData[id][cargoPickup] = pData[playerid][pID];
			CargoData[id][cargoExpired] = gettime();
			//CargoData[id][cargoExists] = false;
			CargoData[id][cargoX] = 0.0;
			CargoData[id][cargoY] = 0.0;
			CargoData[id][cargoZ] = 0.0;
			CargoData[id][cargoA] = 0.0;
			
			
			Servers(playerid, "You've pick up {ffff00}%s{ffffff}.", Cargo_TypeName(id));
			Cargo_AnimPlay(playerid);
			Cargo_Sync(id);
			return 1;
		}
		Error(playerid, "You're not nearest with any cargo.");
	}
	else if(!strcmp(opsi, "sell")) {

		new 
			confirm[8], i = Cargo_Hold(playerid);

		if((id = Business_PointCargo(playerid)) != -1) {
			if (i == -1) return Error(playerid, "You're not holding a cargo.");
			if(bData[id][bRestock] != 1)	return Error(playerid, "Business ini tidak memesan cargo!");
			if(sscanf(string, "s[8]", confirm)) return Usage(playerid, "/cargo sell [confirm]"), Info(playerid,"This business only pay you {00ff00}%s {ffffff}for one cargo!.", FormatMoney(bData[id][bCargo]));

			if(!strcmp(confirm, "confirm", false))
			{
				if (bData[id][bType] != CargoData[i][cargoType]) return Error(playerid, "This cargo not for this business.");
				if (bData[id][bMoney] < bData[id][bCargo]) return Error(playerid, "This business don't have money.");
				if (bData[id][bProd] > 100) return Error(playerid, "This business full of products.");

				GivePlayerMoneyEx(playerid, bData[id][bCargo]);
				bData[id][bMoney] -= bData[id][bCargo];
				bData[id][bProd] += Cargo_TypeAmount(i);

				Dialog_Show(playerid, ShowOnlu, DIALOG_STYLE_MSGBOX, "Information", "{ffffff}You've selling one cargo: {00ff00}%s\n\
					{ffffff}Cargo package: {ffff00}%d pcs\n\
					\n{ffffff}NOTE: Thanks for sell to this business", "Close", "", 
					FormatMoney(bData[id][bCargo]), 
					Cargo_TypeAmount(i)
				);

				if(bData[id][bProd] >= 100)	bData[id][bRestock] = 0;
				else bData[id][bRestock] = 1;

				pData[playerid][pMission] = -1;
				Cargo_Destroy(Cargo_Hold(playerid));
				Cargo_AnimStop(playerid);
				Bisnis_Save(id);
				Bisnis_Refresh(id);
				return 1;
			}
			return 1;
		}
		return Error(playerid, "You're not in near business delivery.");
	}
	else if(!strcmp(opsi, "create")) {
		static 
			type;

   		if(pData[playerid][pAdmin] < 6)
        	return PermissionError(playerid);

		if (sscanf(string, "d", type)) return Usage(playerid, "/cargo create [type 1-8 (line business on /createbiz)]");
		if (type < 1 || type > 8) return Error(playerid, "Invalid cargo type.");

		new cargo = Cargo_Create(playerid, type);

		if(cargo == -1)
        	return Error(playerid, "The server has reached the limit for cargo.");

    	Servers(playerid, "You have successfully created cargo ID: %d.", cargo);
	}
	else if(!strcmp(opsi, "destroy")) {

   		if(pData[playerid][pAdmin] < 7)
        	return PermissionError(playerid);


		if((id = Cargo_Nearest(playerid)) != -1) {
			Cargo_Destroy(id);
			return 1;
		}
		Error(playerid, "You're not near with any cargo.");
	}
	else Usage(playerid, "/cargo [get/buy/list/place/putdown/pickup/sell/create]");
	return 1;
}

task cargoExpiredUpdate[900000]()
{
	for(new i = 0; i != MAX_CARGO; i++) if (CargoData[i][cargoExists] && (gettime()-CargoData[i][cargoExpired]) > (86400*3))
	{
		Cargo_Destroy(i);
	}
	return 1;
}

