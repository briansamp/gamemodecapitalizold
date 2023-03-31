/********************* PARKING METER BY JAKE ELITE (2017) *********************/
/******** COMMANDS: /createparkmeter, /eraseparkmeter, /insertparkmeter *******/
/********************* PARKING METER BY JAKE ELITE (2017) *********************/

#include <a_samp>
#include <zcmd>
#include <sscanf2>
#include <streamer>

native 				IsValidVehicle(vehicleid);

new 				DB: pmeter;

new VehicleNames[212][] = {
	{"Landstalker"},{"Bravura"},{"Buffalo"},{"Linerunner"},{"Perrenial"},{"Sentinel"},{"Dumper"},
	{"Firetruck"},{"Trashmaster"},{"Stretch"},{"Manana"},{"Infernus"},{"Voodoo"},{"Pony"},{"Mule"},
	{"Cheetah"},{"Ambulance"},{"Leviathan"},{"Moonbeam"},{"Esperanto"},{"Taxi"},{"Washington"},
	{"Bobcat"},{"Mr Whoopee"},{"BF Injection"},{"Hunter"},{"Premier"},{"Enforcer"},{"Securicar"},
	{"Banshee"},{"Predator"},{"Bus"},{"Rhino"},{"Barracks"},{"Hotknife"},{"Trailer 1"},{"Previon"},
	{"Coach"},{"Cabbie"},{"Stallion"},{"Rumpo"},{"RC Bandit"},{"Romero"},{"Packer"},{"Monster"},
	{"Admiral"},{"Squalo"},{"Seasparrow"},{"Pizzaboy"},{"Tram"},{"Trailer 2"},{"Turismo"},
	{"Speeder"},{"Reefer"},{"Tropic"},{"Flatbed"},{"Yankee"},{"Caddy"},{"Solair"},{"Berkley's RC Van"},
	{"Skimmer"},{"PCJ-600"},{"Faggio"},{"Freeway"},{"RC Baron"},{"RC Raider"},{"Glendale"},{"Oceanic"},
	{"Sanchez"},{"Sparrow"},{"Patriot"},{"Quad"},{"Coastguard"},{"Dinghy"},{"Hermes"},{"Sabre"},
	{"Rustler"},{"ZR-350"},{"Walton"},{"Regina"},{"Comet"},{"BMX"},{"Burrito"},{"Camper"},{"Marquis"},
	{"Baggage"},{"Dozer"},{"Maverick"},{"News Chopper"},{"Rancher"},{"FBI Rancher"},{"Virgo"},{"Greenwood"},
	{"Jetmax"},{"Hotring"},{"Sandking"},{"Blista Compact"},{"Police Maverick"},{"Boxville"},{"Benson"},
	{"Mesa"},{"RC Goblin"},{"Hotring Racer A"},{"Hotring Racer B"},{"Bloodring Banger"},{"Rancher"},
	{"Super GT"},{"Elegant"},{"Journey"},{"Bike"},{"Mountain Bike"},{"Beagle"},{"Cropdust"},{"Stunt"},
	{"Tanker"}, {"Roadtrain"},{"Nebula"},{"Majestic"},{"Buccaneer"},{"Shamal"},{"Hydra"},{"FCR-900"},
	{"NRG-500"},{"HPV1000"},{"Cement Truck"},{"Tow Truck"},{"Fortune"},{"Cadrona"},{"FBI Truck"},
	{"Willard"},{"Forklift"},{"Tractor"},{"Combine"},{"Feltzer"},{"Remington"},{"Slamvan"},
	{"Blade"},{"Freight"},{"Streak"},{"Vortex"},{"Vincent"},{"Bullet"},{"Clover"},{"Sadler"},
	{"Firetruck LA"},{"Hustler"},{"Intruder"},{"Primo"},{"Cargobob"},{"Tampa"},{"Sunrise"},{"Merit"},
	{"Utility"},{"Nevada"},{"Yosemite"},{"Windsor"},{"Monster A"},{"Monster B"},{"Uranus"},{"Jester"},
	{"Sultan"},{"Stratum"},{"Elegy"},{"Raindance"},{"RC Tiger"},{"Flash"},{"Tahoma"},{"Savanna"},
	{"Bandito"},{"Freight Flat"},{"Streak Carriage"},{"Kart"},{"Mower"},{"Duneride"},{"Sweeper"},
	{"Broadway"},{"Tornado"},{"AT-400"},{"DFT-30"},{"Huntley"},{"Stafford"},{"BF-400"},{"Newsvan"},
	{"Tug"},{"Trailer 3"},{"Emperor"},{"Wayfarer"},{"Euros"},{"Hotdog"},{"Club"},{"Freight Carriage"},
	{"Trailer 3"},{"Andromada"},{"Dodo"},{"RC Cam"},{"Launch"},{"Police Car (LSPD)"},{"Police Car (SFPD)"},
	{"Police Car (LVPD)"},{"Police Ranger"},{"Picador"},{"S.W.A.T. Van"},{"Alpha"},{"Phoenix"},{"Glendale"},
	{"Sadler"},{"Luggage Trailer A"},{"Luggage Trailer B"},{"Stair Trailer"},{"Boxville"},{"Farm Plow"},
	{"Utility Trailer"}
};

#define			 	MAX_METERS 					100 	// Maximum Parking Meters that can be made in the server.
#define 			CASH_PER_MINUTES        	10    	// $10 per minutes

enum ParkingMeters
{
	parkObject,
	parkVehicle,
	parkSeconds,
	Text3D:parkLabel,
	parkID,
	Float:parkX,
	Float:parkY,
	Float:parkZ,
	Float:parkA,
	bool:parkAvailable
};
new pMeter[MAX_METERS][ParkingMeters];

////////////////////////////////////////////////////////////////////////////////

public OnFilterScriptInit()
{
	SetTimer("MeterCheck", 1000, true);

    pmeter = db_open("parkingmeters.db");
	db_query(pmeter, "CREATE TABLE IF NOT EXISTS `pmeters` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `x` FLOAT, `y` FLOAT, `z` FLOAT, `angle` FLOAT)");

	for(new i; i < MAX_METERS; i++)
	{
		pMeter[i][parkID] = -1;
		pMeter[i][parkX] = 0.0;
		pMeter[i][parkY] = 0.0;
		pMeter[i][parkZ] = 0.0;
		pMeter[i][parkA] = 0.0;
		pMeter[i][parkVehicle] = 0;
		pMeter[i][parkAvailable] = false;
	}
	LoadParkMeters();
	return 1;
}

public OnFilterScriptExit()
{
	db_close(pmeter);
	return 1;
}

forward MeterCheck();
public MeterCheck()
{
	new string[128], vid;

	for(new i; i < MAX_METERS; i++)
	{
	    if(pMeter[i][parkID] > -1)
	    {
	        vid = GetClosestVehicleInObject(pMeter[i][parkObject]);
	    
	        switch(pMeter[i][parkAvailable])
	        {
	            case true:
				{
				    format(string, sizeof(string), "# (%d)\nAVAILABLE FOR PARKING\nTime: None", i);
				    UpdateDynamic3DTextLabelText(pMeter[i][parkLabel], 0x33AA33FF, string);
	            }
	            case false:
				{
				    if(pMeter[i][parkVehicle] != vid)
				    {
				        pMeter[i][parkSeconds] = 0;
				        pMeter[i][parkAvailable] = true;
				        pMeter[i][parkVehicle] = 0;
				    }
				    else
				    {
					    pMeter[i][parkSeconds] --;
					    if(pMeter[i][parkSeconds] < 1)
					    {
					        pMeter[i][parkSeconds] = 0;
					        pMeter[i][parkAvailable] = true;
					        pMeter[i][parkVehicle] = 0;
					    }
					}
					    
				    format(string, sizeof(string), "# %d\nNOT AVAILABLE FOR PARKING\nTime: %d", i, pMeter[i][parkSeconds]);
				    UpdateDynamic3DTextLabelText(pMeter[i][parkLabel], 0xFF6347FF, string);
				    if(vid != pMeter[i][parkVehicle])
				    {
				        pMeter[i][parkSeconds] = 0;
				        pMeter[i][parkAvailable] = true;
				        pMeter[i][parkVehicle] = 0;
				    }
	            }
	        }
	    }
	}
	return 1;
}

public OnPlayerConnect(playerid)
{
	return 1;
}

public OnPlayerDisconnect(playerid, reason)
{
	return 1;
}

////////////////////////////////////////////////////////////////////////////////

CMD:createparkmeter(playerid, params[])
{
	if(IsPlayerAdmin(playerid))
	{
	    new id = -1, string[128];
	
		if(IsPlayerNearParkMeter(playerid) != -1)
			return SendClientMessage(playerid, -1, "* There are another parking meter next to you, Move a little bit.");

		new Float:x, Float:y, Float:z, Float:a;
		GetPlayerPos(playerid, x, y, z);
		GetPlayerFacingAngle(playerid, a);
		id = InsertParkMeters(x, y, z, a);
		
		if(id == -1)
		    return SendClientMessage(playerid, -1, "* The server cannot create a new parking meter, it has reached the limit of "#MAX_METERS" parking meters.");
		
		format(string, sizeof(string), "* You have inserted a new parking meter # %d", id);
		SendClientMessage(playerid, 0xFFFF00FF, string);
	}
	else
	{
	    SendClientMessage(playerid, -1, "* You need to be an admin to use this command.");
	}
	return 1;
}

CMD:eraseparkmeter(playerid, params[])
{
	if(IsPlayerAdmin(playerid))
	{
	    new id, string[128];

		if(sscanf(params, "d", id))
		    return SendClientMessage(playerid, -1, "[?] /eraseparkmeter [ID]");

		if(id < 0 || pMeter[id][parkID] < 0 || id >= MAX_METERS)
		    return SendClientMessage(playerid, -1, "* Invalid ID.");

		format(string, sizeof(string), "* You have erased the parking meter # %d", id);
		SendClientMessage(playerid, 0xFFFF00FF, string);
		
		EraseParkMeter(id);
	}
	else
	{
	    SendClientMessage(playerid, -1, "* You need to be an admin to use this command.");
	}
	return 1;
}

CMD:insertparkmeter(playerid, params[])
{
	new id = -1, vid = -1, Float:x, Float:y, Float:z, cash, string[128];
	
	if(IsPlayerInAnyVehicle(playerid))
	    return SendClientMessage(playerid, -1, "* You must be on foot when using this command.");
	
	if((id = IsPlayerNearParkMeter(playerid)) != -1)
	{
		if(sscanf(params, "d", cash))
		    return SendClientMessage(playerid, -1, "[?] /insertparkmeter [minutes] = $"#CASH_PER_MINUTES" per minutes");

		if(cash < 1 || cash > 30)
		    return SendClientMessage(playerid, -1, "[!] You can only set 1 minute up to 30 minutes on the park meter.");

		if(GetPlayerMoney(playerid) < cash * CASH_PER_MINUTES)
		{
		    format(string, sizeof(string), "* You don't have $%d to set the park meter to %d minute(s).", cash * CASH_PER_MINUTES, cash);
		    return SendClientMessage(playerid, -1, string);
		}

		for(new i = 1; i < MAX_VEHICLES; i++)
		{
			if(IsValidVehicle(i))
			{
	            GetVehiclePos(i, x, y, z);
				if(IsPlayerInRangeOfPoint(playerid, 6.0, x, y, z))
				{
					vid = i;
					break;
				}
			}
		}

		if(vid != -1)
		{
		    format(string, sizeof(string), "* You have paid $%d and set the parking meter's minute to (%d), Your %s is now legally parked.", cash * CASH_PER_MINUTES, cash, VehicleNames[GetVehicleModel(vid)-400]);
		    SendClientMessage(playerid, 0x33AA33FF, string);
		
		    GivePlayerMoney(playerid, - cash * CASH_PER_MINUTES);
		
		    pMeter[id][parkSeconds] = cash * 60;
		    pMeter[id][parkVehicle] = vid;
		    pMeter[id][parkAvailable] = false;
		}
		else
		{
		    SendClientMessage(playerid, -1, "* No vehicles are near by the park meter!");
		}
	}
	else
	{
	    SendClientMessage(playerid, -1, "* You are not near in any parking meter.");
	}
	return 1;
}

////////////////////////////////////////////////////////////////////////////////

stock InsertParkMeters(Float:x, Float:y, Float:z, Float:angle)
{
	new nextid = -1, query[128];

	for(new i; i < MAX_METERS; i++)
	{
	    if(pMeter[i][parkID] == -1)
	    {
	        nextid = i;
	        break;
	    }
	}
	
	if(nextid < 0)
	{
	    print("* Can't insert a new parking meter, no IDs are vacant for use - pmeter.amx");
	}
	else
	{
	    printf("* A new parking meter has been inserted to ID %d - pmeter.amx", nextid);

		pMeter[nextid][parkID] = nextid;
		pMeter[nextid][parkX] = x;
		pMeter[nextid][parkY] = y;
		pMeter[nextid][parkZ] = z;
		pMeter[nextid][parkA] = angle;
		pMeter[nextid][parkAvailable] = true;
		pMeter[nextid][parkVehicle] = 0;
		pMeter[nextid][parkSeconds] = 0;

		format(query, sizeof(query), "INSERT INTO `pmeters` (`x`, `y`, `z`, `angle`) VALUES(%.4f, %.4f, %.4f, %.4f)", pMeter[nextid][parkX], pMeter[nextid][parkY], pMeter[nextid][parkZ], pMeter[nextid][parkA]);
		db_query(pmeter, query);

		if(IsValidDynamicObject(pMeter[nextid][parkObject]))
		    DestroyDynamicObject(pMeter[nextid][parkObject]);

		if(IsValidDynamic3DTextLabel(pMeter[nextid][parkLabel]))
		    DestroyDynamic3DTextLabel(pMeter[nextid][parkLabel]);

		pMeter[nextid][parkObject] = CreateDynamicObject(1269, pMeter[nextid][parkX], pMeter[nextid][parkY], pMeter[nextid][parkZ] - 0.50, 0.0, 0.0, pMeter[nextid][parkA]);
		pMeter[nextid][parkLabel] = CreateDynamic3DTextLabel("PARK METER CREATED", 0xFF6347AA, pMeter[nextid][parkX], pMeter[nextid][parkY], pMeter[nextid][parkZ], 15.0);
	}
	return nextid;
}

stock EraseParkMeter(id)
{
	new query[92];

	if(pMeter[id][parkID] > - 1)
	{
		if(IsValidDynamicObject(pMeter[id][parkObject]))
		    DestroyDynamicObject(pMeter[id][parkObject]);

		if(IsValidDynamic3DTextLabel(pMeter[id][parkLabel]))
		    DestroyDynamic3DTextLabel(pMeter[id][parkLabel]);

		format(query, sizeof(query), "DELETE FROM `pmeters` WHERE `id` = %d", pMeter[id][parkID]);
		db_query(pmeter, query);

		pMeter[id][parkID] = -1;
		pMeter[id][parkX] = 0.0;
		pMeter[id][parkY] = 0.0;
		pMeter[id][parkZ] = 0.0;
		pMeter[id][parkA] = 0.0;
		pMeter[id][parkAvailable] = true;
		pMeter[id][parkVehicle] = 0;
		pMeter[id][parkSeconds] = 0;
	}
	return 1;
}

stock LoadParkMeters()
{
    new
        DBResult:dbresult,
        idx
	;

	dbresult = db_query(pmeter, "SELECT * FROM `pmeters` ORDER BY `id`");

    for (new i, j = db_num_rows(dbresult); i != j; i++)
    {
		pMeter[i][parkID] = db_get_field_assoc_int(dbresult, "id");
		pMeter[i][parkX] = db_get_field_assoc_int(dbresult, "x");
		pMeter[i][parkY] = db_get_field_assoc_int(dbresult, "y");
		pMeter[i][parkZ] = db_get_field_assoc_int(dbresult, "z");
		pMeter[i][parkA] = db_get_field_assoc_int(dbresult, "angle");
		pMeter[i][parkAvailable] = true;
		pMeter[i][parkVehicle] = 0;
		pMeter[i][parkSeconds] = 0;

		if(IsValidDynamicObject(pMeter[i][parkObject]))
		    DestroyDynamicObject(pMeter[i][parkObject]);

		if(IsValidDynamic3DTextLabel(pMeter[i][parkLabel]))
		    DestroyDynamic3DTextLabel(pMeter[i][parkLabel]);

		pMeter[i][parkObject] = CreateDynamicObject(1269, pMeter[i][parkX], pMeter[i][parkY], pMeter[i][parkZ] - 0.50, 0.0, 0.0, pMeter[i][parkA]);
		pMeter[i][parkLabel] = CreateDynamic3DTextLabel("_", 0xFF6347AA, pMeter[i][parkX], pMeter[i][parkY], pMeter[i][parkZ], 15.0);

		idx++;

		db_next_row(dbresult);
	}
    db_free_result(dbresult);

	printf("* There are %d parking meters loaded from pmeter.amx", idx);
	return 1;
}

stock IsPlayerNearParkMeter(playerid)
{
	new id = -1;

	for(new i; i < MAX_METERS; i++)
	{
		if(pMeter[i][parkID] > -1 && IsPlayerInRangeOfPoint(playerid, 3.0, pMeter[i][parkX], pMeter[i][parkY], pMeter[i][parkZ]))
		{
		    return i;
		}
	}
	return id;
}

stock GetClosestVehicleInObject(objectid)
{
	new vid, Float:x, Float:y, Float:z, Float:distance;
	GetDynamicObjectPos(objectid, x, y, z);
	for(new i; i < MAX_VEHICLES; i++)
	{
	    if(IsValidVehicle(i))
	    {
	        distance = GetVehicleDistanceFromPoint(i, x, y, z);
	        if(distance <= 6)
	        {
				vid = i;
				break;
	        }
	    }
	}
	return vid;
}