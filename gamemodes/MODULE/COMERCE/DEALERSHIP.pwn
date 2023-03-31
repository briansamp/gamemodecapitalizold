//Dealership Merpati Roleplay | Burton
#include <YSI_Coding\y_hooks>

#define MAX_DEALERSHIPVEHICLES 10
#define MAX_CARDEALERSHIPS 12



enum cdInfo
{
	cdOwned,
	cdOwnerID,
	cdOwner[MAX_PLAYER_NAME],
	Float: cdEntranceX,
	Float: cdEntranceY,
	Float: cdEntranceZ,
	Float: cdExitX,
	Float: cdExitY,
	Float: cdExitZ,
	cdMessage[128],
	cdTill,
	cdInterior,
	Float: cdRadius,
	cdPrice,
	cdType,
	cdPickupID,
	Text3D:cdTextLabel,
	Text3D:cdVehicleLabel[MAX_DEALERSHIPVEHICLES],
	cdVehicleModel[MAX_DEALERSHIPVEHICLES],
	cdVehicleCost[MAX_DEALERSHIPVEHICLES],
	cdVehicleId[MAX_DEALERSHIPVEHICLES],
	Float: cdVehicleSpawnX[MAX_DEALERSHIPVEHICLES],
	Float: cdVehicleSpawnY[MAX_DEALERSHIPVEHICLES],
	Float: cdVehicleSpawnZ[MAX_DEALERSHIPVEHICLES],
	Float: cdVehicleSpawnAngle[MAX_DEALERSHIPVEHICLES],
	Float: cdVehicleSpawn[4],
};
new CarDealershipInfo[MAX_CARDEALERSHIPS][cdInfo];
new Iterator:CarDealership<MAX_CARDEALERSHIPS>;

ReturnAnyDealer(slot)
{
	new tmpcount;
	if(slot < 1 && slot > MAX_CARDEALERSHIPS) return -1;
	foreach(new id : CarDealership)
	{
		tmpcount++;
		if(tmpcount == slot)
		{
			return id;
		}
	}
	return -1;
}

GetAnyDealer()
{
	new tmpcount;
	foreach(new id : CarDealership)
	{
		tmpcount++;
	}
	return tmpcount;
}

hook OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
	if(dialogid == DIALOG_CDEDIT)
	{ // car dealership dialog
		new str[1280];
		if(response && GetPVarInt(playerid, "editingcd") != -1)
		{
            if(listitem == 0) // New Vehicle
			{
				format(str, sizeof(str),"Masukan Model id vehicles\nSesuai type vehicles");
		        ShowPlayerDialog(playerid,DIALOG_CDNEWVEH,DIALOG_STYLE_INPUT,"Stock Vehicles",str,"Enter","Cancel");
			}
			else if(listitem == 1) // My Vehicles
			{
				new vehicles;
                for(new i=0; i<MAX_DEALERSHIPVEHICLES; i++)
	            {
					if(CarDealershipInfo[GetPVarInt(playerid, "editingcd")][cdVehicleModel][i] != 0)
					{
						vehicles++;
		                Servers(playerid, "Vehicle %d| Name: %s | Price: %s.",i+1,GetVehicleName(CarDealershipInfo[GetPVarInt(playerid, "editingcd")][cdVehicleId][i]),FormatMoney(CarDealershipInfo[GetPVarInt(playerid, "editingcd")][cdVehicleCost][i]));

					}
				}
				if(vehicles)
				{
				    ShowPlayerDialog(playerid, DIALOG_CDEDITCARS, DIALOG_STYLE_INPUT, "Car Dealership:", " Choose a vehicle to edit:", "Edit", "Back");
				}
				else
				{
					Error(playerid, "This car dealership doesn't have any cars.");
				}
			}
			else if(listitem == 2) // Upgrade
			{
				new listitems[] = "Vehicle Set Spawn\nRange\nDealership Name";
			    ShowPlayerDialog(playerid,DIALOG_CDUPGRADE,DIALOG_STYLE_LIST,"Dealership Edit", listitems,"Select","Cancel");
			}
			else if(listitem == 3) // Till
			{
				new listitems[] = "Withdraw\nDeposit";
			    ShowPlayerDialog(playerid,DIALOG_CDTILL,DIALOG_STYLE_LIST,"Choose an item to continue", listitems,"Select","Cancel");
			}
			else if(listitem == 4)
			{
				foreach(new cid : CarDealership)
				{
			        if(IsPlayerInRangeOfPoint(playerid, CarDealershipInfo[cid][cdRadius], CarDealershipInfo[cid][cdEntranceX], CarDealershipInfo[cid][cdEntranceY], CarDealershipInfo[cid][cdEntranceZ])) {
			            if(IsPlayerOwnerOfCDEx(playerid, cid))
						{
						    new string[2500];
						    if(CarDealershipInfo[cid][cdType] == 1)
						    {
							    strcat(string, "{FFFFFF}_____________________________________________________________\n");
								strcat(string, "{FFFF00}Vehicle ID(461)\t{ffffff}Vehicle Name: PCJ-600\n");
								strcat(string, "{FFFF00}Vehicle ID(462)\t{ffffff}Vehicle Name: Faggio\n");
								strcat(string, "{FFFF00}Vehicle ID(463)\t{ffffff}Vehicle Name: Freeway\n");
								strcat(string, "{FFFF00}Vehicle ID(468)\t{ffffff}Vehicle Name: Sanchez\n");
								strcat(string, "{FFFF00}Vehicle ID(481)\t{ffffff}Vehicle Name: BMX\n");
								strcat(string, "{FFFF00}Vehicle ID(509)\t{ffffff}Vehicle Name: Bike\n");
								strcat(string, "{FFFF00}Vehicle ID(510)\t{ffffff}Vehicle Name: Mountain Bike\n");
								strcat(string, "{FFFF00}Vehicle ID(521)\t{ffffff}Vehicle Name: FCR-900\n");
								strcat(string, "{FFFF00}Vehicle ID(581)\t{ffffff}Vehicle Name: BF-400\n");
								strcat(string, "{FFFF00}Vehicle ID(586)\t{ffffff}Vehicle Name: Wayfarer\n");
								strcat(string, "{FFFFFF}_____________________________________________________________");
								ShowPlayerDialog(playerid, 0, DIALOG_STYLE_MSGBOX, "{FFFFFF}Type Vehicle To Your Dealer", string,"Ok", "");
								return 1;
							}
							else if(CarDealershipInfo[cid][cdType] == 2)
						    {
							    strcat(string, "{FFFFFF}_____________________________________________________________\n");
								strcat(string, "{FFFF00}Vehicle ID(403)\t{ffffff}Vehicle Name: Linerunner\n");//
								strcat(string, "{FFFF00}Vehicle ID(422)\t{ffffff}Vehicle Name: Bobcat\n");//
								strcat(string, "{FFFF00}Vehicle ID(455)\t{ffffff}Vehicle Name: Flatbead\n");//
								strcat(string, "{FFFF00}Vehicle ID(499)\t{ffffff}Vehicle Name: Benson\n");//Done alll
								strcat(string, "{FFFF00}Vehicle ID(525)\t{ffffff}Vehicle Name: Towtruck\n");//
								strcat(string, "{FFFF00}Vehicle ID(543)\t{ffffff}Vehicle Name: Sadler\n");//
								strcat(string, "{FFFF00}Vehicle ID(515)\t{ffffff}Vehicle Name: Roadtrain\n");//
								strcat(string, "{FFFF00}Vehicle ID(414)\t{ffffff}Vehicle Name: Mule\n");//
								strcat(string, "{FFFF00}Vehicle ID(456)\t{ffffff}Vehicle Name: Yankee\n");
								strcat(string, "{FFFF00}Vehicle ID(554)\t{ffffff}Vehicle Name: Yosemite\n");
								strcat(string, "{FFFF00}Vehicle ID(609)\t{ffffff}Vehicle Name: Boxville\n");
								strcat(string, "{FFFFFF}_____________________________________________________________");
								ShowPlayerDialog(playerid, 0, DIALOG_STYLE_MSGBOX, "{FFFFFF}Type Vehicle To Your Dealer", string,"Ok", "");
								return 1;
							}
							else if(CarDealershipInfo[cid][cdType] == 3)
						    {
							    strcat(string, "{FFFFFF}_____________________________________________________________\n");
								strcat(string, "{FFFF00}Vehicle ID(401)\t{ffffff}Vehicle Name: Bravura\n");
								strcat(string, "{FFFF00}Vehicle ID(405)\t{ffffff}Vehicle Name: Sentinel\n");
								strcat(string, "{FFFF00}Vehicle ID(410)\t{ffffff}Vehicle Name: Manana\n");
								strcat(string, "{FFFF00}Vehicle ID(419)\t{ffffff}Vehicle Name: Esperanto\n");
								strcat(string, "{FFFF00}Vehicle ID(421)\t{ffffff}Vehicle Name: Washington\n");
								strcat(string, "{FFFF00}Vehicle ID(426)\t{ffffff}Vehicle Name: Premier\n");
								strcat(string, "{FFFF00}Vehicle ID(436)\t{ffffff}Vehicle Name: Previon\n");
								strcat(string, "{FFFF00}Vehicle ID(445)\t{ffffff}Vehicle Name: Admiral\n");
								strcat(string, "{FFFF00}Vehicle ID(466)\t{ffffff}Vehicle Name: Glendale\n");
								strcat(string, "{FFFF00}Vehicle ID(467)\t{ffffff}Vehicle Name: Oceanic\n");
								strcat(string, "{FFFF00}Vehicle ID(474)\t{ffffff}Vehicle Name: Hermes\n");
								strcat(string, "{FFFF00}Vehicle ID(491)\t{ffffff}Vehicle Name: Virgo\n");
								strcat(string, "{FFFF00}Vehicle ID(492)\t{ffffff}Vehicle Name: Greenwood\n");
								strcat(string, "{FFFF00}Vehicle ID(507)\t{ffffff}Vehicle Name: Elegant\n");
								strcat(string, "{FFFF00}Vehicle ID(516)\t{ffffff}Vehicle Name: Nebula\n");
								strcat(string, "{FFFF00}Vehicle ID(517)\t{ffffff}Vehicle Name: Majestic\n");
								strcat(string, "{FFFF00}Vehicle ID(518)\t{ffffff}Vehicle Name: Buccaneer\n");
								strcat(string, "{FFFF00}Vehicle ID(526)\t{ffffff}Vehicle Name: Fortune\n");
								strcat(string, "{FFFF00}Vehicle ID(527)\t{ffffff}Vehicle Name: Cadrona\n");
								strcat(string, "{FFFF00}Vehicle ID(529)\t{ffffff}Vehicle Name: Willard\n");
								strcat(string, "{FFFF00}Vehicle ID(540)\t{ffffff}Vehicle Name: Vincent\n");
								strcat(string, "{FFFF00}Vehicle ID(542)\t{ffffff}Vehicle Name: Clover\n");
								strcat(string, "{FFFF00}Vehicle ID(546)\t{ffffff}Vehicle Name: Intruder\n");
								strcat(string, "{FFFF00}Vehicle ID(547)\t{ffffff}Vehicle Name: Primo\n");
								strcat(string, "{FFFF00}Vehicle ID(549)\t{ffffff}Vehicle Name: Tampa\n");
								strcat(string, "{FFFF00}Vehicle ID(550)\t{ffffff}Vehicle Name: Sunrise\n");
								strcat(string, "{FFFF00}Vehicle ID(551)\t{ffffff}Vehicle Name: Merit\n");
								strcat(string, "{FFFF00}Vehicle ID(560)\t{ffffff}Vehicle Name: Sultan\n");
								strcat(string, "{FFFF00}Vehicle ID(562)\t{ffffff}Vehicle Name: Elegy\n");
								strcat(string, "{FFFFFF}_____________________________________________________________");
								ShowPlayerDialog(playerid, 0, DIALOG_STYLE_MSGBOX, "{FFFFFF}Type Vehicle To Your Dealer", string,"Ok", "");
								return 1;
							}
							else
							{
							    Error(playerid, "This type of dealership is unknown");
							    return 1;
							}
						}
			            else
						{
			                Error(playerid, "You do not own that Car Dealership.");
			                return 1;
			            }
			        }
			    }
			    Error(playerid, "You must be standing inside the radius of the Car Dealership.");
			}
		}
		else
		{
			SavecDealership(GetPVarInt(playerid, "editingcd"));
            SetPVarInt(playerid, "editingcd", -1);
		}
	}
	if(dialogid == DIALOG_CDTILL)
	{ // car dealership dialog
	    if(response && GetPVarInt(playerid, "editingcd") != -1)
		{
  			new string[580];
            if(listitem == 0) // Withdraw
			{
				format(string, sizeof(string), "{FFFFFF}You have {00FF00}$%s {FFFFFF}in your till account.\nHow much money to withdraw?", FormatMoney(CarDealershipInfo[GetPVarInt(playerid, "editingcd")][cdTill]));
				ShowPlayerDialog(playerid,DIALOG_CDWITHDRAW,DIALOG_STYLE_INPUT,"Withdraw", string,"Select","Cancel");
			}
			else if(listitem == 1) // Deposit
			{
				format(string, sizeof(string), "{FFFFFF}You have {00FF00}$%s {FFFFFF}in your till account.\nHow much money to deposit?", FormatMoney(CarDealershipInfo[GetPVarInt(playerid, "editingcd")][cdTill]));
				ShowPlayerDialog(playerid,DIALOG_CDDEPOSIT,DIALOG_STYLE_INPUT,"Deposit", string,"Select","Cancel");
			}
		}
		else
		{
            SavecDealership(GetPVarInt(playerid, "editingcd"));
            SetPVarInt(playerid, "editingcd", -1);
		}
	}
	if(dialogid == DIALOG_CDWITHDRAW)
	{ // car dealership dialog
		if(response && GetPVarInt(playerid, "editingcd") != -1)
		{
	    	new str[1280];
		    if(IsNumeric(inputtext))
	        {
	             new money = strval(inputtext);
	             if(CarDealershipInfo[GetPVarInt(playerid, "editingcd")][cdTill] < money)
	             {
                     format(str, sizeof(str), "You don't have that much in your till!\n\nYou have $%d in your till account.\n\nHow much money to withdraw?", CarDealershipInfo[GetPVarInt(playerid, "editingcd")][cdTill]);
				     ShowPlayerDialog(playerid,DIALOG_CDWITHDRAW,DIALOG_STYLE_INPUT,"Withdraw", str,"Select","Cancel");
                     return 1;
	             }
	             CarDealershipInfo[GetPVarInt(playerid, "editingcd")][cdTill] -= money;

	             GivePlayerMoneyEx(playerid, money);
	             Servers(playerid, "You have successfully withdrawn $%d from your till, new balance: $%d", money, CarDealershipInfo[GetPVarInt(playerid, "editingcd")][cdTill]);
	             SavecDealership(GetPVarInt(playerid, "editingcd"));
                 SetPVarInt(playerid, "editingcd", -1);
			}
        }
		else
		{
             SavecDealership(GetPVarInt(playerid, "editingcd"));
             SetPVarInt(playerid, "editingcd", -1);
		}
	}
	if(dialogid == DIALOG_CDSELL)
	{
		if(response)
		{
			if(GetPVarInt(playerid, "editingcd") == -1) return 1;
            GivePlayerMoneyEx(playerid, CarDealershipInfo[GetPVarInt(playerid, "editingcd")][cdPrice]);
			SellCarDealership(GetPVarInt(playerid, "editingcd"));
			Servers(playerid, "Car Dealership successfully sold for %s!", FormatMoney(CarDealershipInfo[GetPVarInt(playerid, "editingcd")][cdPrice]));
		}
		else
		{
            SetPVarInt(playerid, "editingcd", -1);
			return 1;
		}
	}
	if(dialogid == DIALOG_CDDEPOSIT)
	{ // car dealership dialog
		if(response && GetPVarInt(playerid, "editingcd") != -1)
		{
	    	new str[1280];
		    if(IsNumeric(inputtext))
	        {
	             new money = strval(inputtext);
	             if(GetPlayerMoney(playerid) < money)
	             {
                     format(str, sizeof(str), "You don't have that much in your wallet!\n\nYou have $%d in your till account.\n\n\tHow much money to deposit?", CarDealershipInfo[GetPVarInt(playerid, "editingcd")][cdTill]);
				     ShowPlayerDialog(playerid,DIALOG_CDDEPOSIT,DIALOG_STYLE_INPUT,"Deposit", str,"Select","Cancel");
                     return 1;
	             }
	             CarDealershipInfo[GetPVarInt(playerid, "editingcd")][cdTill] += money;

	             GivePlayerMoneyEx(playerid, -money);
	             Servers(playerid, "You have successfully deposited $%d to your till, new balance: $%d", money, CarDealershipInfo[GetPVarInt(playerid, "editingcd")][cdTill]);
	             SavecDealership(GetPVarInt(playerid, "editingcd"));
                 SetPVarInt(playerid, "editingcd", -1);
			}
		}
		else
		{
             SavecDealership(GetPVarInt(playerid, "editingcd"));
             SetPVarInt(playerid, "editingcd", -1);
		}
	}

	if(dialogid == DIALOG_VEH_SPAWN)
	{
	    new cid;
	    if(response)
	    {
	        new Float:x, Float:y, Float:z, Float:angle;
		    GetPlayerPos(playerid, x, y, z);
		    cid = GetPVarInt(playerid, "editingcd");
		    GetPlayerFacingAngle(playerid, angle);
			CarDealershipInfo[cid][cdVehicleSpawn][0] = x;
			CarDealershipInfo[cid][cdVehicleSpawn][1] = y;
			CarDealershipInfo[cid][cdVehicleSpawn][2] = z;
			CarDealershipInfo[cid][cdVehicleSpawn][3] = angle;
			SetPVarInt(playerid, "editingcdvehpos", 0);
			Servers(playerid, "You have succesfully adjust vehicle spawn pos");
			SavecDealership(cid);
		}
	}

	if(dialogid == DIALOG_CDUPGRADE)
	{ // car dealership dialog
		if(response && GetPVarInt(playerid, "editingcd") != -1)
		{
            if(listitem == 0) // Vehicle Spawn
			{
				new Float:x, Float:y, Float:z, Float:angle;
			    GetPlayerPos(playerid, x, y, z);
			    new cid = GetPVarInt(playerid, "editingcd");
			    GetPlayerFacingAngle(playerid, angle);
				CarDealershipInfo[cid][cdVehicleSpawn][0] = x;
				CarDealershipInfo[cid][cdVehicleSpawn][1] = y;
				CarDealershipInfo[cid][cdVehicleSpawn][2] = z;
				CarDealershipInfo[cid][cdVehicleSpawn][3] = angle;

				Servers(playerid, "You have succesfully adjust vehicle spawn pos");
				SavecDealership(cid);
			}
            if(listitem == 1) // Radius
			{
				ShowPlayerDialog(playerid, DIALOG_CDRADIUS, DIALOG_STYLE_INPUT, "Car Dealership:", "Choose the new radius:", "Edit", "Back");
			}
			else if(listitem == 2) // Dealership Name
			{
				ShowPlayerDialog(playerid, DIALOG_CDNAME, DIALOG_STYLE_INPUT, "Car Dealership:", "Choose the new name:", "Edit", "Back");
			}
		}
		else
		{
            SavecDealership(GetPVarInt(playerid, "editingcd"));
            SetPVarInt(playerid, "editingcd", -1);
		}
	}
	if(dialogid == DIALOG_CDRADIUS)
	{ // car dealership dialog
		if(response && GetPVarInt(playerid, "editingcd") != -1)
		{
			new cid;
 			new str[580];
			cid = GetPVarInt(playerid, "editingcd");
			new Float:radius = floatstr(inputtext);
			new Float:radiusex = CarDealershipInfo[cid][cdRadius];
			new test = floatround(radius), test1 = floatround(radiusex);
            if(CarDealershipInfo[cid][cdRadius] < radius && radius < 250)
	        {
				 new cost = ( test - test1 ) * ( test1 * 1000 );
				 if(GetPlayerMoney(playerid) < cost)
				 {
                     Error(playerid, "You do not have enough money for this upgrade ($%s).", FormatMoney(cost));

                     return 1;
				 }
				 Servers(playerid, "Car Dealership radius upgraded from %.1f to %.1f for $%s.",radiusex, radius, FormatMoney(cost));
	             CarDealershipInfo[cid][cdRadius] = radius;
	             GivePlayerMoneyEx(playerid, -cost);
	             format(str,128,"ID: %d\n{FFFF00}Sponsored: %s\n{FFFFFF}Owner: {00FF00}%s",cid, CarDealershipInfo[cid][cdMessage], CarDealershipInfo[cid][cdOwner]);
	             UpdateDynamic3DTextLabelText(CarDealershipInfo[cid][cdTextLabel], COLOR_WHITE, str);
	             new listitems[] = "Vehicle Set Spawn\nRange\nDealership Name";
			     ShowPlayerDialog(playerid,DIALOG_CDUPGRADE,DIALOG_STYLE_LIST,"Choose an item to continue", listitems,"Select","Cancel");
			     SavecDealership(GetPVarInt(playerid, "editingcd"));
	        }
	        else
	        {
	            Servers(playerid, "Upgrade Radius Harus Lebih Besar Dari Radius Sekarang Dan Tidak Boleh Lebih Dari 250.0");
		 	}
		}
		else
		{
		    new listitems[] = "Vehicle Set Spawn\nRange\nDealership Name";
			ShowPlayerDialog(playerid,DIALOG_CDUPGRADE,DIALOG_STYLE_LIST,"Choose an item to continue", listitems,"Select","Cancel");
		}
	}
	if(dialogid == DIALOG_CDNAME)
	{ // car dealership dialog
	    new string[580];
		if(response && GetPVarInt(playerid, "editingcd") != -1)
		{
			new cid;
			cid = GetPVarInt(playerid, "editingcd");
            if(!strlen(inputtext))
			{
    	        ShowPlayerDialog(playerid, DIALOG_CDNAME, DIALOG_STYLE_INPUT, "Car Dealership:", " Choose the new name:", "Edit", "Back");
		        return 1;
			}
			new cost = strlen(inputtext) * 100;
			Servers(playerid, " Car Dealership name upgraded from %s to %s for $%s.", CarDealershipInfo[cid][cdMessage], inputtext, FormatMoney(cost));

            GivePlayerMoneyEx(playerid, -cost);
	        strmid(CarDealershipInfo[cid][cdMessage], inputtext, 0, strlen(inputtext), 255);
	        format(string,128,"ID: %d\n{FFFF00}Sponsored: %s\n{FFFFFF}Owner: {00FF00}%s", cid, CarDealershipInfo[cid][cdMessage], CarDealershipInfo[cid][cdOwner]);
	        UpdateDynamic3DTextLabelText(CarDealershipInfo[cid][cdTextLabel], COLOR_WHITE, string);
			SavecDealership(GetPVarInt(playerid, "editingcd"));
		}
		else
		{
            new listitems[] = "1 Vehicle Spawn\n2 Radius\n3 Dealership Name\n4 Change Dealer Type";
			ShowPlayerDialog(playerid,DIALOG_CDUPGRADE,DIALOG_STYLE_LIST,"Choose an item to continue", listitems,"Select","Cancel");
		}
	}
	if(dialogid == DIALOG_CDEDITCARS)
	{
		if(response && GetPVarInt(playerid, "editingcd") != -1)
		{
			new cdvid;
            if(IsNumeric(inputtext))
	        {
	             cdvid = strval(inputtext);
	             if(CarDealershipInfo[GetPVarInt(playerid, "editingcd")][cdVehicleModel][cdvid-1])
	             {
	                 SetPVarInt(playerid, "editingcdveh", cdvid-1);
	                 new listitems[] = "Edit Vehicles ID\nEdit Price Vehicles\nEdit Park Position\nDelete Vehicle";
			         ShowPlayerDialog(playerid,DIALOG_CDEDITONE,DIALOG_STYLE_LIST,"Car Dealership:", listitems,"Select","Cancel");
				 }
	        }
		}
		else
		{
		    new listitems[] = "Buy Vehicles\nDealership Vehicles\nEdit Vehicle Spawn\nDealership";
			ShowPlayerDialog(playerid,DIALOG_CDEDIT,DIALOG_STYLE_LIST,"Choose an item to continue", listitems,"Select","Cancel");
		}
	}
	if(dialogid == DIALOG_CDEDITONE)
	{ // car dealership dialog
		if(response && GetPVarInt(playerid, "editingcd") != -1 && GetPVarInt(playerid, "editingcdveh") != -1)
		{
			new str[1280];
            if(listitem == 0) // Edit Model
			{
	             ShowPlayerDialog(playerid, DIALOG_CDEDITMODEL, DIALOG_STYLE_INPUT, "Car Dealership:", " Choose the new model id:", "Edit", "Back");
	        }
	        else if(listitem == 1) // Edit Cost
			{
			        
	             ShowPlayerDialog(playerid, DIALOG_CDEDITCOST, DIALOG_STYLE_INPUT, "Car Dealership:", " Choose the new price of the car:", "Edit", "Back");
	        }
	        else if(listitem == 2) // Edit Park
			{
			    new v = GetPVarInt(playerid, "editingcdveh");
			    new cid = GetPVarInt(playerid, "editingcd");
				new Float:x, Float:y, Float:z, Float:a;
				GetPlayerPos(playerid, x, y, z);
				GetPlayerFacingAngle(playerid, a);
				CarDealershipInfo[cid][cdVehicleSpawnX][v] = x;
    			CarDealershipInfo[cid][cdVehicleSpawnY][v] = y;
       			CarDealershipInfo[cid][cdVehicleSpawnZ][v] = z;
          		CarDealershipInfo[cid][cdVehicleSpawnAngle][v] = a;
				Servers(playerid, "You have succesfully adjust vehicle %d spawn.", v);
				SetPVarInt(playerid, "editingcdvehpos", 0);
				DestroyDynamic3DTextLabel(CarDealershipInfo[cid][cdVehicleLabel][v]);
				DestroyVehicle(CarDealershipInfo[cid][cdVehicleId][v]);
				new carcreated;
   //ID: %d\n{FFFF00}%s\n{FFFFFF}Price: {00FF00}%s\n{ffff00}Health: {ffffff}1000.0\n{ffff00}Fuel: {ffffff}100.0
				carcreated = CreateVehicle(CarDealershipInfo[cid][cdVehicleModel][v], CarDealershipInfo[cid][cdVehicleSpawnX][v], CarDealershipInfo[cid][cdVehicleSpawnY][v], CarDealershipInfo[cid][cdVehicleSpawnZ][v], CarDealershipInfo[cid][cdVehicleSpawnAngle][v], 0, 0, 6);
				format(str, sizeof(str), "ID: %d\n{FFFF00}%s\n{FFFFFF}Price: {00FF00}%s\n{ffff00}Health: {ffffff}1000.0\n{ffff00}Fuel: {ffffff}100.0",v, GetVehicleName(carcreated), FormatMoney(CarDealershipInfo[cid][cdVehicleCost][v]));
				CarDealershipInfo[cid][cdVehicleLabel][v] = CreateDynamic3DTextLabel(str,COLOR_WHITE,0.0, 0.0, 0.0,8.0,INVALID_PLAYER_ID,carcreated);
				CarDealershipInfo[cid][cdVehicleId][v] = carcreated;
				SavecDealership(cid);
	        }
	        else if(listitem == 3) // Delete Vehicle
			{
	             format(str, sizeof(str), "Are you sure you want to delete this %s?\nNote: You will not get any refounds.", GetVehicleName(CarDealershipInfo[GetPVarInt(playerid, "editingcd")][cdVehicleId][GetPVarInt(playerid, "editingcdveh")]));
		         ShowPlayerDialog(playerid,DIALOG_CDDELVEH,DIALOG_STYLE_MSGBOX,"Warning:",str,"Ok","Cancel");
	        }
		}
		else
		{
            SavecDealership(GetPVarInt(playerid, "editingcd"));
            SetPVarInt(playerid, "editingcdveh", -1);
		}
	}
    if(dialogid == DIALOG_CDEDITMODEL)
	{ // car dealership dialog
		if(response && GetPVarInt(playerid, "editingcd") != -1 && GetPVarInt(playerid, "editingcdveh") != -1)
		{
	    	new str[1280];
			new modelid, cid, v;
			cid = GetPVarInt(playerid, "editingcd");
			v = GetPVarInt(playerid, "editingcdveh");
            if(IsNumeric(inputtext))
	        {
				modelid = strval(inputtext);

         		if(modelid < 400||modelid > 611||modelid == 411||modelid == 415||modelid == 424||modelid == 434||modelid == 451||modelid == 494||modelid == 502||modelid == 503||modelid == 495||modelid == 506||modelid == 503)
		 		{
		 			Servers(playerid, "ID Kendaraan tidak diperbolehkan!");
				 	return 1;
		 		}
				CarDealershipInfo[cid][cdVehicleModel][v] = modelid;
				DestroyDynamic3DTextLabel(CarDealershipInfo[cid][cdVehicleLabel][v]);
				DestroyVehicle(CarDealershipInfo[cid][cdVehicleId][v]);
				new carcreated;
				carcreated = CreateVehicle(CarDealershipInfo[cid][cdVehicleModel][v], CarDealershipInfo[cid][cdVehicleSpawnX][v], CarDealershipInfo[cid][cdVehicleSpawnY][v], CarDealershipInfo[cid][cdVehicleSpawnZ][v], CarDealershipInfo[cid][cdVehicleSpawnAngle][v], 0, 0, 6);
				format(str, sizeof(str),"ID: %d\n{FFFF00}%s\n{FFFFFF}Price: {00FF00}%s\n{ffff00}Health: {ffffff}1000.0\n{ffff00}Fuel: {ffffff}100.0",v, GetVehicleName(carcreated), FormatMoney(CarDealershipInfo[cid][cdVehicleCost][v]));
				CarDealershipInfo[cid][cdVehicleLabel][v] = CreateDynamic3DTextLabel(str,COLOR_WHITE,0.0, 0.0, 0.0,8.0,INVALID_PLAYER_ID,carcreated);
				CarDealershipInfo[cid][cdVehicleId][v] = carcreated;
				new listitems[] = "Edit Vehicles ID\nEdit Vehicles Price\nEdit Set Spawn\nDelete Vehicle";
				ShowPlayerDialog(playerid,DIALOG_CDEDITONE,DIALOG_STYLE_LIST,"Car Dealership:", listitems,"Select","Cancel");
				SavecDealership(cid);
	        }
		}
		else
		{
		    new listitems[] = "Edit Vehicles ID\nEdit Vehicles Price\nEdit Set Spawn\nDelete Vehicle";
			ShowPlayerDialog(playerid,DIALOG_CDEDITONE,DIALOG_STYLE_LIST,"Car Dealership:", listitems,"Select","Cancel");
		}
	}
	if(dialogid == DIALOG_CDEDITCOST)
	{ // car dealership dialog

		if(pData[playerid][pAdmin] < 10)
	        return Error(playerid, "Fitur sedang di nonaktifkan");
	        
		if(response && GetPVarInt(playerid, "editingcd") != -1 && GetPVarInt(playerid, "editingcdveh") != -1)
		{
	    	new string[1280];
			new price, cid, v;
			cid = GetPVarInt(playerid, "editingcd");
			v = GetPVarInt(playerid, "editingcdveh");
            if(IsNumeric(inputtext))
	        {
	             price = strval(inputtext);
	             CarDealershipInfo[cid][cdVehicleCost][v] = price;
	             //GivePlayerMoneyEx(playerid, -price/3);
				 format(string, sizeof(string), "ID: %d\n{FFFF00}%s\n{FFFFFF}Price: {00FF00}%s\n{ffff00}Health: {ffffff}1000.0\n{ffff00}Fuel: {ffffff}100.0",v, GetVehicleName(CarDealershipInfo[cid][cdVehicleId][v]), FormatMoney(CarDealershipInfo[cid][cdVehicleCost][v]));
	             UpdateDynamic3DTextLabelText(CarDealershipInfo[cid][cdVehicleLabel][v], COLOR_WHITE, string);
			     SavecDealership(cid);
	        }
		}
		else
		{
		    new listitems[] = "Edit Vehicles ID\nEdit Vehicles Price\nEdit Set Spawn\nDelete Vehicle";
			ShowPlayerDialog(playerid,DIALOG_CDEDITONE,DIALOG_STYLE_LIST,"Dealership", listitems,"Select","Cancel");
		}
	}
	if(dialogid == DIALOG_CDDELVEH)
	{ // car dealership dialog
		if(response && GetPVarInt(playerid, "editingcd") != -1 && GetPVarInt(playerid, "editingcdveh") != -1)
		{
			DestroyCarDealershipVehicle(GetPVarInt(playerid, "editingcd"), GetPVarInt(playerid, "editingcdveh"));
			SavecDealership(GetPVarInt(playerid, "editingcd"));
		}
		else
		{
		    new listitems[] = "Edit Vehicles ID\nEdit Vehicles Price\nEdit Set Spawn\nDelete Vehicle";
			ShowPlayerDialog(playerid,DIALOG_CDEDITONE,DIALOG_STYLE_LIST,"Car Dealership:", listitems,"Select","Cancel");
		}
	}
	if(dialogid == DIALOG_CDEDITPARK)
	{ // car dealership dialog
	    new string[1280];
		if(response && GetPVarInt(playerid, "editingcd") != -1 && GetPVarInt(playerid, "editingcdveh") != -1 &&  GetPVarInt(playerid, "editingcdvehpos") == 1 || GetPVarInt(playerid, "editingcdvehnew"))
		{
			new Float: x, Float: y, Float: z, Float: a;
			new cid, v;
			cid = GetPVarInt(playerid, "editingcd");
			v = GetPVarInt(playerid, "editingcdveh");
			GetVehiclePos(CarDealershipInfo[cid][cdVehicleId][v], x, y, z);
	        GetVehicleZAngle(CarDealershipInfo[cid][cdVehicleId][v], a);
			if(IsPlayerInRangeOfPoint(playerid, CarDealershipInfo[cid][cdRadius], CarDealershipInfo[cid][cdEntranceX], CarDealershipInfo[cid][cdEntranceY], CarDealershipInfo[cid][cdEntranceZ]))
		    {
			     CarDealershipInfo[cid][cdVehicleSpawnX][v] = x;
                 CarDealershipInfo[cid][cdVehicleSpawnY][v] = y;
                 CarDealershipInfo[cid][cdVehicleSpawnZ][v] = z;
                 CarDealershipInfo[cid][cdVehicleSpawnAngle][v] = a;
                 SetPVarInt(playerid, "editingcdvehpos", 0);
                 SetPVarInt(playerid, "editingcdvehnew", 0);
                 DestroyDynamic3DTextLabel(CarDealershipInfo[cid][cdVehicleLabel][v]);
	             DestroyVehicle(CarDealershipInfo[cid][cdVehicleId][v]);
	             new carcreated;
	             carcreated = CreateVehicle(CarDealershipInfo[cid][cdVehicleModel][v], CarDealershipInfo[cid][cdVehicleSpawnX][v], CarDealershipInfo[cid][cdVehicleSpawnY][v], CarDealershipInfo[cid][cdVehicleSpawnZ][v], CarDealershipInfo[cid][cdVehicleSpawnAngle][v], 0, 0, 6);
		         format(string, sizeof(string), "ID: %d\n{FFFF00}%s\n{FFFFFF}Price: {00FF00}%s\n{ffff00}Health: {ffffff}1000.0\n{ffff00}Fuel: {ffffff}100.0",v, GetVehicleName(carcreated), FormatMoney(CarDealershipInfo[cid][cdVehicleCost][v]));
                 CarDealershipInfo[cid][cdVehicleLabel][v] = CreateDynamic3DTextLabel(string,COLOR_WHITE,0.0, 0.0, 0.0,8.0,INVALID_PLAYER_ID,carcreated);
	             CarDealershipInfo[cid][cdVehicleId][v] = carcreated;
	             TogglePlayerControllable(playerid, true);
			     SavecDealership(cid);
			}
			else
			{
                 Error(playerid, "You are out of this Car Dealership radius, please try again.");
                 TogglePlayerControllable(playerid, true);
			}
		}
		else if(response && GetPVarInt(playerid, "editingcd") != -1 && GetPVarInt(playerid, "editingcdvehpos") == 2)
		{
			new Float: x, Float: y, Float: z, Float: a;
			new cid;
			GetPlayerPos(playerid,x,y,z);
	        GetPlayerFacingAngle(playerid, a);
			cid = GetPVarInt(playerid, "editingcd");
			if(IsPlayerInRangeOfPoint(playerid, CarDealershipInfo[cid][cdRadius], CarDealershipInfo[cid][cdEntranceX], CarDealershipInfo[cid][cdEntranceY], CarDealershipInfo[cid][cdEntranceZ]))
		    {
			     CarDealershipInfo[cid][cdVehicleSpawn][0] = x;
                 CarDealershipInfo[cid][cdVehicleSpawn][1] = y;
                 CarDealershipInfo[cid][cdVehicleSpawn][2] = z;
                 CarDealershipInfo[cid][cdVehicleSpawn][3] = a;
                 SetPVarInt(playerid, "editingcdvehpos", 0);
	             TogglePlayerControllable(playerid, true);
	             new listitems[] = "Vehicle Set Spawn\nRange\nDealership Name";
			     ShowPlayerDialog(playerid,DIALOG_CDUPGRADE,DIALOG_STYLE_LIST,"Choose an item to continue", listitems,"Select","Cancel");
			     SavecDealership(cid);
			}
			else
			{
                 Error(playerid, "You are out of this Car Dealership radius, please try again.");
                 TogglePlayerControllable(playerid, true);
			}
		}
		else if(!response && GetPVarInt(playerid, "editingcd") != -1 && GetPVarInt(playerid, "editingcdvehpos") == 1)
		{
            new listitems[] = "Edit Vehicles ID\nEdit Vehicles Price\nEdit Set Spawn\nDelete Vehicle";
			ShowPlayerDialog(playerid,DIALOG_CDEDITONE,DIALOG_STYLE_LIST,"Car Dealership:", listitems,"Select","Cancel");
			TogglePlayerControllable(playerid, true);
			SetPVarInt(playerid, "editingcdvehpos", 0);
		}
		else if(!response && GetPVarInt(playerid, "editingcd") != -1 && GetPVarInt(playerid, "editingcdvehpos") == 2)
		{
            new listitems[] = "Vehicle Set Spawn\nRange\nDealership Name";
		    ShowPlayerDialog(playerid,DIALOG_CDUPGRADE,DIALOG_STYLE_LIST,"Choose an item to continue", listitems,"Select","Cancel");
			TogglePlayerControllable(playerid, true);
			SetPVarInt(playerid, "editingcdvehpos", 0);
		}
	}
	if(dialogid == DIALOG_CDNEWVEH)
	{ // car dealership dialog
		if(response && GetPVarInt(playerid, "editingcd") != -1)
		{
			new modelid, cid;
			new Float: x, Float: y, Float: z, Float: a;
			new harga;
			new buyveh;
			cid = GetPVarInt(playerid, "editingcd");
			GetPlayerPos(playerid,x,y,z);
	        GetPlayerFacingAngle(playerid, a);
	        if(!IsNumeric(inputtext)) return Error(playerid, "Model ID must be numbers.");
            if(IsPlayerInRangeOfPoint(playerid, CarDealershipInfo[cid][cdRadius], CarDealershipInfo[cid][cdEntranceX], CarDealershipInfo[cid][cdEntranceY], CarDealershipInfo[cid][cdEntranceZ]))
	        {
         		modelid = strval(inputtext);

         		if(modelid < 400||modelid > 611||modelid == 411||modelid == 415||modelid == 424||modelid == 434||modelid == 451||modelid == 494||modelid == 502||modelid == 503||modelid == 495||modelid == 506||modelid == 503)
		 		{
		 			Servers(playerid, "ID Kendaraan tidak diperbolehkan!");
				 	return 1;
		 		}
				switch(modelid)
				{
				    //Bravura
				    case 401:
				    {
            			if(CarDealershipInfo[cid][cdType] == 3)
            			{
	                        if(GetPlayerMoney(playerid) >= 20000)
	                        {
	                            buyveh = 20000;
	                            harga = 150000;
							}
							else
							{
	                            Error(playerid, "Anda harus mempunyai modal sebesar $20.000!");
	                            return 1;
							}
						}
						else
						{
						    Error(playerid, "Kendaraan ini tidak cocok dengan tipe dealer anda!");
						    return 1;
						}
					}
					//Emperor
					case 585:
					{
					    if(CarDealershipInfo[cid][cdType] == 3) {

	                        if(GetPlayerMoney(playerid) >= 20000)
	                        {
	                            buyveh = 20000;
	                            harga = 240500;
							}
							else
							{
	                            Error(playerid, "Anda harus mempunyai modal sebesar $20.000!");
	                            return 1;
							}
                        }
						else
						{
						    Error(playerid, "Kendaraan ini tidak cocok dengan tipe dealer anda!");
						    return 1;
						}
					}
					//Intruder
					case 546:
					{
					    if(CarDealershipInfo[cid][cdType] == 3) {
	                        if(GetPlayerMoney(playerid) >= 25000)
	                        {
	                            buyveh = 25000;
	                            harga = 310000;
							}
							else
							{
	                            Error(playerid, "Anda harus mempunyai modal sebesar $25.000!");
	                            return 1;
							}
                        }
						else
						{
						    Error(playerid, "Kendaraan ini tidak cocok dengan tipe dealer anda!");
						    return 1;
						}
					}
					//Primo
					case 547:
					{
					    if(CarDealershipInfo[cid][cdType] == 3) {
	                        if(GetPlayerMoney(playerid) >= 24000)
	                        {
	                            buyveh = 24000;
	                            harga = 320000;
							}
							else
							{
	                            Error(playerid, "Anda harus mempunyai modal sebesar $24.000!");
	                            return 1;
							}
                        }
						else
						{
						    Error(playerid, "Kendaraan ini tidak cocok dengan tipe dealer anda!");
						    return 1;
						}
					}
					//Tampa
					case 549:
					{
					    if(CarDealershipInfo[cid][cdType] == 3) {
	                        if(GetPlayerMoney(playerid) >= 20000)
	                        {
	                            buyveh = 20000;
	                            harga = 285000;
							}
							else
							{
	                            Error(playerid, "Anda harus mempunyai modal sebesar $20.000!");
	                            return 1;
							}
                        }
						else
						{
						    Error(playerid, "Kendaraan ini tidak cocok dengan tipe dealer anda!");
						    return 1;
						}
					}
					//Sultan
					case 560:
					{
					    if(CarDealershipInfo[cid][cdType] == 3) {
	                        if(GetPlayerMoney(playerid) >= 80000)
	                        {
	                            buyveh = 80000;
	                            harga = 800000;
							}
							else
							{
	                            Error(playerid, "Anda harus mempunyai modal sebesar $80.000!");
	                            return 1;
							}
						}
						else
						{
						    Error(playerid, "Kendaraan ini tidak cocok dengan tipe dealer anda!");
						    return 1;
						}
					}
					//Sunrise
					case 550:
					{
					    if(CarDealershipInfo[cid][cdType] == 3) {
	                        if(GetPlayerMoney(playerid) >= 30000)
	                        {
	                            buyveh = 30000;
	                            harga = 420000;
							}
							else
							{
	                            Error(playerid, "Anda harus mempunyai modal sebesar $30.000!");
	                            return 1;
							}
                        }
						else
						{
						    Error(playerid, "Kendaraan ini tidak cocok dengan tipe dealer anda!");
						    return 1;
						}
					}
					//Merit
					case 551:
					{
					    if(CarDealershipInfo[cid][cdType] == 3) {
	                        if(GetPlayerMoney(playerid) >= 20000)
	                        {
	                            buyveh = 20000;
	                            harga = 330000;
							}
							else
							{
	                            Error(playerid, "Anda harus mempunyai modal sebesar $20.000!");
	                            return 1;
							}
                        }
						else
						{
						    Error(playerid, "Kendaraan ini tidak cocok dengan tipe dealer anda!");
						    return 1;
						}
					}
					//Elegy
					case 562:
					{
					    if(CarDealershipInfo[cid][cdType] == 3) {
	                        if(GetPlayerMoney(playerid) >= 60000)
	                        {
	                            buyveh = 60000;
	                            harga = 600000;
							}
							else
							{
	                            Error(playerid, "Anda harus mempunyai modal sebesar $60.000!");
	                            return 1;
							}
                        }
						else
						{
						    Error(playerid, "Kendaraan ini tidak cocok dengan tipe dealer anda!");
						    return 1;
						}
					}
					//Vincent
					case 540:
					{
					    if(CarDealershipInfo[cid][cdType] == 3) {
	                        if(GetPlayerMoney(playerid) >= 30000)
	                        {
	                            buyveh = 30000;
	                            harga = 600000;
							}
							else
							{
	                            Error(playerid, "Anda harus mempunyai modal sebesar $30.000!");
	                            return 1;
							}
                        }
						else
						{
						    Error(playerid, "Kendaraan ini tidak cocok dengan tipe dealer anda!");
						    return 1;
						}
					}
					//Clover
					case 542:
					{
					    if(CarDealershipInfo[cid][cdType] == 3) {
	                        if(GetPlayerMoney(playerid) >= 30000)
	                        {
	                            buyveh = 30000;
	                            harga = 520000;
							}
							else
							{
	                            Error(playerid, "Anda harus mempunyai modal sebesar $30.000!");
	                            return 1;
							}
                        }
						else
						{
						    Error(playerid, "Kendaraan ini tidak cocok dengan tipe dealer anda!");
						    return 1;
						}
					}
					//Willard
					case 529:
					{
					    if(CarDealershipInfo[cid][cdType] == 3) {
	                        if(GetPlayerMoney(playerid) >= 26000)
	                        {
	                            buyveh = 26000;
	                            harga = 460000;
							}
							else
							{
	                            Error(playerid, "Anda harus mempunyai modal sebesar $26.000!");
	                            return 1;
							}
                        }
						else
						{
						    Error(playerid, "Kendaraan ini tidak cocok dengan tipe dealer anda!");
						    return 1;
						}
					}
					//Fortune
					case 526:
					{
					    if(CarDealershipInfo[cid][cdType] == 3) {
	                        if(GetPlayerMoney(playerid) >= 21000)
	                        {
	                            buyveh = 21000;
	                            harga = 370000;
							}
							else
							{
	                            Error(playerid, "Anda harus mempunyai modal sebesar $21.000!");
	                            return 1;
							}
                        }
						else
						{
						    Error(playerid, "Kendaraan ini tidak cocok dengan tipe dealer anda!");
						    return 1;
						}
					}
					//Cadrona
					case 527:
					{
					    if(CarDealershipInfo[cid][cdType] == 3) {
	                        if(GetPlayerMoney(playerid) >= 20000)
	                        {
	                            buyveh = 20000;
	                            harga = 350000;
							}
							else
							{
	                            Error(playerid, "Anda harus mempunyai modal sebesar $20.000!");
	                            return 1;
							}
                        }
						else
						{
						    Error(playerid, "Kendaraan ini tidak cocok dengan tipe dealer anda!");
						    return 1;
						}
					}
					//Majestic
					case 517:
					{
					    if(CarDealershipInfo[cid][cdType] == 3) {
	                        if(GetPlayerMoney(playerid) >= 20000)
	                        {
	                            buyveh = 20000;
	                            harga = 325000;
							}
							else
							{
	                            Error(playerid, "Anda harus mempunyai modal sebesar $20.000!");
	                            return 1;
							}
                        }
						else
						{
						    Error(playerid, "Kendaraan ini tidak cocok dengan tipe dealer anda!");
						    return 1;
						}
					}
					//Buccaneer
					case 518:
					{
					    if(CarDealershipInfo[cid][cdType] == 3) {
	                        if(GetPlayerMoney(playerid) >= 22000)
	                        {
	                            buyveh = 22000;
	                            harga = 430000;
							}
							else
							{
	                            Error(playerid, "Anda harus mempunyai modal sebesar $22.000!");
	                            return 1;
							}
                        }
						else
						{
						    Error(playerid, "Kendaraan ini tidak cocok dengan tipe dealer anda!");
						    return 1;
						}
					}
					//Elegant
					case 507:
					{
					    if(CarDealershipInfo[cid][cdType] == 3) {
	                        if(GetPlayerMoney(playerid) >= 20000)
	                        {
	                            buyveh = 20000;
	                            harga = 300000;
							}
							else
							{
	                            Error(playerid, "Anda harus mempunyai modal sebesar $20.000!");
	                            return 1;
							}
                        }
						else
						{
						    Error(playerid, "Kendaraan ini tidak cocok dengan tipe dealer anda!");
						    return 1;
						}
					}
					//Nebula
					case 516:
					{
					    if(CarDealershipInfo[cid][cdType] == 3) {
	                        if(GetPlayerMoney(playerid) >= 21000)
	                        {
	                            buyveh = 21000;
	                            harga = 370000;
							}
							else
							{
	                            Error(playerid, "Anda harus mempunyai modal sebesar $21.000!");
	                            return 1;
							}
                        }
						else
						{
						    Error(playerid, "Kendaraan ini tidak cocok dengan tipe dealer anda!");
						    return 1;
						}
					}
					//Greenwood
					case 492:
					{
					    if(CarDealershipInfo[cid][cdType] == 3) {
	                        if(GetPlayerMoney(playerid) >= 22000)
	                        {
	                            buyveh = 22000;
	                            harga = 395000;
							}
							else
							{
	                            Error(playerid, "Anda harus mempunyai modal sebesar $22.000!");
	                            return 1;
							}
                        }
						else
						{
						    Error(playerid, "Kendaraan ini tidak cocok dengan tipe dealer anda!");
						    return 1;
						}
					}
					//Virgo
					case 491:
					{
					    if(CarDealershipInfo[cid][cdType] == 3) {
	                        if(GetPlayerMoney(playerid) >= 20000)
	                        {
	                            buyveh = 20000;
	                            harga = 340000;
							}
							else
							{
	                            Error(playerid, "Anda harus mempunyai modal sebesar $20.000!");
	                            return 1;
							}
                        }
						else
						{
						    Error(playerid, "Kendaraan ini tidak cocok dengan tipe dealer anda!");
						    return 1;
						}
					}
					//Hermes
					case 474:
					{
					    if(CarDealershipInfo[cid][cdType] == 3) {
	                        if(GetPlayerMoney(playerid) >= 21000)
	                        {
	                            buyveh = 21000;
	                            harga = 370000;
							}
							else
							{
	                            Error(playerid, "Anda harus mempunyai modal sebesar $21.000!");
	                            return 1;
							}
                        }
						else
						{
						    Error(playerid, "Kendaraan ini tidak cocok dengan tipe dealer anda!");
						    return 1;
						}
					}
					//Previon
					case 436:
					{
					    if(CarDealershipInfo[cid][cdType] == 3) {
	                        if(GetPlayerMoney(playerid) >= 20000)
	                        {
	                            buyveh = 20000;
	                            harga = 360000;
							}
							else
							{
	                            Error(playerid, "Anda harus mempunyai modal sebesar $20.000!");
	                            return 1;
							}
                        }
						else
						{
						    Error(playerid, "Kendaraan ini tidak cocok dengan tipe dealer anda!");
						    return 1;
						}
					}
					//Admiral
					case 445:
					{
					    if(CarDealershipInfo[cid][cdType] == 3) {
	                        if(GetPlayerMoney(playerid) >= 20000)
	                        {
	                            buyveh = 20000;
	                            harga = 520000;
							}
							else
							{
	                            Error(playerid, "Anda harus mempunyai modal sebesar $20.000!");
	                            return 1;
							}
                        }
						else
						{
						    Error(playerid, "Kendaraan ini tidak cocok dengan tipe dealer anda!");
						    return 1;
						}
					}
					//Esperanto
					case 419:
					{
					    if(CarDealershipInfo[cid][cdType] == 3) {
	                        if(GetPlayerMoney(playerid) >= 20000)
	                        {
	                            buyveh = 20000;
	                            harga = 350000;
							}
							else
							{
	                            Error(playerid, "Anda harus mempunyai modal sebesar $20.000!");
	                            return 1;
							}
                        }
						else
						{
						    Error(playerid, "Kendaraan ini tidak cocok dengan tipe dealer anda!");
						    return 1;
						}
					}
					//Premier
					case 426:
					{
					    if(CarDealershipInfo[cid][cdType] == 3) {
	                        if(GetPlayerMoney(playerid) >= 20000)
	                        {
	                            buyveh = 20000;
	                            harga = 520000;
							}
							else
							{
	                            Error(playerid, "Anda harus mempunyai modal sebesar $20.000!");
	                            return 1;
							}
                        }
						else
						{
						    Error(playerid, "Kendaraan ini tidak cocok dengan tipe dealer anda!");
						    return 1;
						}
					}
					//Washington
					case 421:
					{
					    if(CarDealershipInfo[cid][cdType] == 3) {
	                        if(GetPlayerMoney(playerid) >= 20000)
	                        {
	                            buyveh = 20000;
	                            harga = 540000;
							}
							else
							{
	                            Error(playerid, "Anda harus mempunyai modal sebesar $20.000!");
	                            return 1;
							}
                        }
						else
						{
						    Error(playerid, "Kendaraan ini tidak cocok dengan tipe dealer anda!");
						    return 1;
						}
					}
					//Manana
					case 410:
					{
					    if(CarDealershipInfo[cid][cdType] == 3) {
	                        if(GetPlayerMoney(playerid) >= 20000)
	                        {
	                            buyveh = 20000;
	                            harga = 480000;
							}
							else
							{
	                            Error(playerid, "Anda harus mempunyai modal sebesar $20.000!");
	                            return 1;
							}
                        }
						else
						{
						    Error(playerid, "Kendaraan ini tidak cocok dengan tipe dealer anda!");
						    return 1;
						}
					}
					//Sentinel
					case 405:
					{
					    if(CarDealershipInfo[cid][cdType] == 3) {
	                        if(GetPlayerMoney(playerid) >= 31000)
	                        {
	                            buyveh = 31000;
	                            harga = 630000;
							}
							else
							{
	                            Error(playerid, "Anda harus mempunyai modal sebesar $31.000!");
	                            return 1;
							}
                        }
						else
						{
						    Error(playerid, "Kendaraan ini tidak cocok dengan tipe dealer anda!");
						    return 1;
						}
					}
					//Glendale
					case 466:
					{
					    if(CarDealershipInfo[cid][cdType] == 3) {
	                        if(GetPlayerMoney(playerid) >= 25000)
	                        {
	                            buyveh = 25000;
	                            harga = 580000;
							}
							else
							{
	                            Error(playerid, "Anda harus mempunyai modal sebesar $25.000!");
	                            return 1;
							}
						}
						else
						{
						    Error(playerid, "Kendaraan ini tidak cocok dengan tipe dealer anda!");
						    return 1;
						}
					}
					//Oceanic
					case 467:
					{
					    if(CarDealershipInfo[cid][cdType] == 3) {

	                        if(GetPlayerMoney(playerid) >= 31000)
	                        {
	                            buyveh = 31000;
	                            harga = 630000;
							}
							else
							{
	                            Error(playerid, "Anda harus mempunyai modal sebesar $31.000!");
	                            return 1;
							}
						}
						else
						{
						    Error(playerid, "Kendaraan ini tidak cocok dengan tipe dealer anda!");
						    return 1;
						}
					}
					//BF-400
					case 581:
					{
					    if(CarDealershipInfo[cid][cdType] == 1) {
                        if(GetPlayerMoney(playerid) >= 5000)
                        {
                        	buyveh = 50000;
                            harga = 100000;
						}
						else
						{
                            Servers(playerid, "Anda harus mempunyai modal sebesar $5.000!");
                            return 1;
						}
						}
						else
						{
						    Error(playerid, "Kendaraan ini tidak cocok dengan tipe dealer anda!");
						    return 1;
						}
					}
					//Wayfarer
					case 586:
					{
					    if(CarDealershipInfo[cid][cdType] == 1) {
                        if(GetPlayerMoney(playerid) >= 4000)
                        {
                        	buyveh = 40000;
                            harga = 200000;
						}
						else
						{
                            Servers(playerid, "Anda harus mempunyai modal sebesar $4.000!");
                            return 1;
						}
						}
						else
						{
						    Error(playerid, "Kendaraan ini tidak cocok dengan tipe dealer anda!");
						    return 1;
						}
					}
					//FCR-900
					case 521:
					{
					    if(CarDealershipInfo[cid][cdType] == 1) {
                        if(GetPlayerMoney(playerid) >= 21000)
                        {
                        	buyveh = 21000;
                            harga = 400000;
						}
						else
						{
                            Servers(playerid, "Anda harus mempunyai modal sebesar $21.000!");
                            return 1;
						}
						}
						else
						{
						    Error(playerid, "Kendaraan ini tidak cocok dengan tipe dealer anda!");
						    return 1;
						}
					}
					//NRG-500
					case 522:
					{
					    if(CarDealershipInfo[cid][cdType] == 100) {
                        if(GetPlayerMoney(playerid) >= 1000)
                        {
                        	buyveh = 50000;
                            harga = 10000;
						}
						else
						{
                            Servers(playerid, "Anda harus mempunyai modal sebesar $10,000.00!");
                            return 1;
						}
						}
						else
						{
						    Error(playerid, "Kendaraan ini tidak cocok dengan tipe dealer anda!");
						    return 1;
						}
					}
					//Sanchez
					case 468:
					{
					    if(CarDealershipInfo[cid][cdType] == 1) {
                        if(GetPlayerMoney(playerid) >= 7000)
                        {
                        	buyveh = 70000;
                            harga = 100000;
						}
						else
						{
                            Servers(playerid, "Anda harus mempunyai modal sebesar $7.000!");
                            return 1;
						}
						}
						else
						{
						    Error(playerid, "Kendaraan ini tidak cocok dengan tipe dealer anda!");
						    return 1;
						}
					}
					//Quad
					case 471:
					{
					    if(CarDealershipInfo[cid][cdType] == 44) {
                        if(GetPlayerMoney(playerid) >= 50000)
                        {
                            buyveh = 10000;
                            harga = 100000;
						}
						else
						{
                            Servers(playerid, "Anda harus mempunyai modal sebesar $1.000.00!");
                            return 1;
						}
						}
						else
						{
						    Error(playerid, "Kendaraan ini tidak cocok dengan tipe dealer anda!");
						    return 1;
						}
					}
					//BMX
					case 481:
					{
					    if(CarDealershipInfo[cid][cdType] == 1) {
                        if(GetPlayerMoney(playerid) >= 300)
                        {
                        	buyveh = 300;
                            harga = 5000;
						}
						else
						{
                            Servers(playerid, "Anda harus mempunyai modal sebesar $300!");
                            return 1;
						}
						}
						else
						{
						    Error(playerid, "Kendaraan ini tidak cocok dengan tipe dealer anda!");
						    return 1;
						}
					}
					//Faggio
					case 462:
					{
					    if(CarDealershipInfo[cid][cdType] == 1) {
                        if(GetPlayerMoney(playerid) >= 1000)
                        {
                        	buyveh = 1000;
                            harga = 50000;
						}
						else
						{
                            Servers(playerid, "Anda harus mempunyai modal sebesar $2.000!");
                            return 1;
						}
						}
						else
						{
						    Error(playerid, "Kendaraan ini tidak cocok dengan tipe dealer anda!");
						    return 1;
						}
					}
					//Freeway
					case 463:
					{
					    if(CarDealershipInfo[cid][cdType] == 1) {
                        if(GetPlayerMoney(playerid) >= 8000)
                        {
                        	buyveh = 80000;
                            harga = 160000;
						}
						else
						{
                            Servers(playerid, "Anda harus mempunyai modal sebesar $8.000!");
                            return 1;
						}
						}
						else
						{
						    Error(playerid, "Kendaraan ini tidak cocok dengan tipe dealer anda!");
						    return 1;
						}
					}
					//PCJ-600
					case 461:
					{
					    if(CarDealershipInfo[cid][cdType] == 1) {
                        if(GetPlayerMoney(playerid) >= 10000)
                        {
                        	buyveh = 100000;
                            harga = 180000;
						}
						else
						{
                            Servers(playerid, "Anda harus mempunyai modal sebesar $10.000!");
                            return 1;
						}
						}
						else
						{
						    Error(playerid, "Kendaraan ini tidak cocok dengan tipe dealer anda!");
						    return 1;
						}
					}
					//Bike
					case 509:
					{
					    if(CarDealershipInfo[cid][cdType] == 1) {
                        if(GetPlayerMoney(playerid) >= 500)
                        {
                        	buyveh = 500;
                            harga = 10000;
						}
						else
						{
                            Servers(playerid, "Anda harus mempunyai modal sebesar $500!");
                            return 1;
						}
						}
						else
						{
						    Error(playerid, "Kendaraan ini tidak cocok dengan tipe dealer anda!");
						    return 1;
						}
					}
					//Mountain Bike
					case 510:
					{
					    if(CarDealershipInfo[cid][cdType] == 1) {
                        if(GetPlayerMoney(playerid) >= 800)
                        {
                        	buyveh = 600;
                            harga = 6000;
						}
						else
						{
                            Servers(playerid, "Anda harus mempunyai modal sebesar $7.000!");
                            return 1;
						}
						}
						else
						{
						    Error(playerid, "Kendaraan ini tidak cocok dengan tipe dealer anda!");
						    return 1;
						}
					}
					//Perenniel
					case 404:
					{
					    if(CarDealershipInfo[cid][cdType] == 3) {
                        if(GetPlayerMoney(playerid) >= 5000)
                        {
                        	buyveh = 5000;
                            harga = 300000;
						}
						else
						{
                            Servers(playerid, "Anda harus mempunyai modal sebesar $5.000!");
                            return 1;
						}
						}
						else
						{
						    Error(playerid, "Kendaraan ini tidak cocok dengan tipe dealer anda!");
						    return 1;
						}
					}
					//Solair
					case 458:
					{
					    if(CarDealershipInfo[cid][cdType] == 3) {
                        if(GetPlayerMoney(playerid) >= 7000)
                        {
                        	buyveh = 7000;
                            harga = 150000;
						}
						else
						{
                            Servers(playerid, "Anda harus mempunyai modal sebesar $7.000!");
                            return 1;
						}
						}
						else
						{
						    Error(playerid, "Kendaraan ini tidak cocok dengan tipe dealer anda!");
						    return 1;
						}
					}
					//Stringatum
					case 561:
					{
					    if(CarDealershipInfo[cid][cdType] == 3) {
                        if(GetPlayerMoney(playerid) >= 15000)
                        {
                        	buyveh = 15000;
                            harga = 300000;
						}
						else
						{
                            Servers(playerid, "Anda harus mempunyai modal sebesar $15.000!");
                            return 1;
						}
						}
						else
						{
						    Error(playerid, "Kendaraan ini tidak cocok dengan tipe dealer anda!");
						    return 1;
						}
					}
					//Regina
					case 479:
					{
					    if(CarDealershipInfo[cid][cdType] == 3) {
                        if(GetPlayerMoney(playerid) >= 7000)
                        {
                        	buyveh = 7000;
                            harga = 170000;
						}
						else
						{
                            Servers(playerid, "Anda harus mempunyai modal sebesar $7.000!");
                            return 1;
						}
						}
						else
						{
						    Error(playerid, "Kendaraan ini tidak cocok dengan tipe dealer anda!");
						    return 1;
						}
					}
					//Remington
					case 534:
					{
					    if(CarDealershipInfo[cid][cdType] == 4) {
                        if(GetPlayerMoney(playerid) >= 20000)
                        {
                            buyveh = 7000;
                            harga = 200000;
                        }
						else
						{
                            Servers(playerid, "Anda harus mempunyai modal sebesar $2.000.00!");
                            return 1;
						}
						}
						else
						{
						    Error(playerid, "Kendaraan ini tidak cocok dengan tipe dealer anda!");
						    return 1;
						}
					}
					//Slamvan
					case 535:
					{
					    if(CarDealershipInfo[cid][cdType] == 4) {
                        if(GetPlayerMoney(playerid) >= 25000)
                        {
                            buyveh = 7000;
                            harga = 250000;
						}
						else
						{
                            Servers(playerid, "Anda harus mempunyai modal sebesar $2.500.00!");
                            return 1;
						}
						}
						else
						{
						    Error(playerid, "Kendaraan ini tidak cocok dengan tipe dealer anda!");
						    return 1;
						}
					}
					//Blade
					case 536:
					{
					    if(CarDealershipInfo[cid][cdType] == 4) {
                        if(GetPlayerMoney(playerid) >= 20000)
                        {
                            buyveh = 100000;
                            harga = 200000;
						}
						else
						{
                            Servers(playerid, "Anda harus mempunyai modal sebesar $2.000.00!");
                            return 1;
						}
						}
						else
						{
						    Error(playerid, "Kendaraan ini tidak cocok dengan tipe dealer anda!");
						    return 1;
						}
					}
					//Tahoma
					case 566:
					{
                        if(GetPlayerMoney(playerid) >= 25000)
                        {
                            buyveh = 10000;
                            harga = 250000;
						}
						else
						{
                            Servers(playerid, "Anda harus mempunyai modal sebesar $2.500.00!");
                            return 1;
						}
					}
					//Savanna
					case 567:
					{
					    if(CarDealershipInfo[cid][cdType] == 4) {
                        if(GetPlayerMoney(playerid) >= 23000)
                        {
                            buyveh = 10000;
                            harga = 230000;
						}
						else
						{
                            Servers(playerid, "Anda harus mempunyai modal sebesar $2.300.00!");
                            return 1;
						}
						}
						else
						{
						    Error(playerid, "Kendaraan ini tidak cocok dengan tipe dealer anda!");
						    return 1;
						}
					}
					//Broadway
					case 575:
					{
					    if(CarDealershipInfo[cid][cdType] == 4) {
                        if(GetPlayerMoney(playerid) >= 18000)
                        {
                            buyveh = 10000;
                            harga = 180000;
						}
						else
						{
                            Servers(playerid, "Anda harus mempunyai modal sebesar $1.800.00!");
                            return 1;
						}
						}
						else
						{
						    Error(playerid, "Kendaraan ini tidak cocok dengan tipe dealer anda!");
						    return 1;
						}
					}
					//Tornado
					case 576:
					{
                        if(CarDealershipInfo[cid][cdType] == 4) {
                        if(GetPlayerMoney(playerid) >= 9000)
                        {
                            buyveh = 10000;
                            harga = 250000;
						}
						else
						{
                            Servers(playerid, "Anda harus mempunyai modal sebesar $950.00!");
                            return 1;
						}
						}
						else
						{
						    Error(playerid, "Kendaraan ini tidak cocok dengan tipe dealer anda!");
						    return 1;
						}
					}
					//Voodoo
					case 412:
					{
					    if(CarDealershipInfo[cid][cdType] == 4) {
                        if(GetPlayerMoney(playerid) >= 7000)
                        {
                            buyveh = 10000;
                            harga = 750000;
						}
						else
						{
                            Servers(playerid, "Anda harus mempunyai modal sebesar $750.00!");
                            return 1;
						}
						}
						else
						{
						    Error(playerid, "Kendaraan ini tidak cocok dengan tipe dealer anda!");
						    return 1;
						}
					}
					//Landstalker
					case 400:
					{
					    if(CarDealershipInfo[cid][cdType] == 3) {
                        if(GetPlayerMoney(playerid) >= 25000)
                        {
                            buyveh = 10000;
                            harga = 250000;
						}
						else
						{
                            Servers(playerid, "Anda harus mempunyai modal sebesar $2.500.00!");
                            return 1;
						}
						}
						else
						{
						    Error(playerid, "Kendaraan ini tidak cocok dengan tipe dealer anda!");
						    return 1;
						}
					}
					//Mesa
					case 500:
					{
					    if(CarDealershipInfo[cid][cdType] == 3) {
                        if(GetPlayerMoney(playerid) >= 27000)
                        {
                            buyveh = 10000;
                            harga = 270000;
						}
						else
						{
                            Servers(playerid, "Anda harus mempunyai modal sebesar $2.700.00!");
                            return 1;
						}
						}
						else
						{
						    Error(playerid, "Kendaraan ini tidak cocok dengan tipe dealer anda!");
						    return 1;
						}
					}
					//Huntley
					case 579:
					{
					    if(CarDealershipInfo[cid][cdType] == 3) {
	                        if(GetPlayerMoney(playerid) >= 30000)
	                        {
	                            buyveh = 10000;
	                            harga = 300000;
							}
							else
							{
	                            Servers(playerid, "Anda harus mempunyai modal sebesar $3.000.00!");
	                            return 1;
							}
						}
						else
						{
						    Error(playerid, "Kendaraan ini tidak cocok dengan tipe dealer anda!");
						    return 1;
						}
					}
					//YoErrorite
					//Tow Truck
					case 525:
					{
					    if(CarDealershipInfo[cid][cdType] == 2) {
	                        if(GetPlayerMoney(playerid) >= 5000)
	                        {
                        		buyveh = 5000;
	                            harga = 130000;
							}
							else
							{
	                            Servers(playerid, "Anda harus mempunyai modal sebesar $10.000!");
	                            return 1;
							}
						}
						else
						{
						    Error(playerid, "Kendaraan ini tidak cocok dengan tipe dealer anda!");
						    return 1;
						}
					}
					//benson
					case 499:
					{
					    if(CarDealershipInfo[cid][cdType] == 2) {
	                        if(GetPlayerMoney(playerid) >= 10000)
	                        {
                        		buyveh = 10000;
	                            harga = 170000;
							}
							else
							{
	                            Servers(playerid, "Anda harus mempunyai modal sebesar $10.000!");
	                            return 1;
							}
						}
						else
						{
						    Error(playerid, "Kendaraan ini tidak cocok dengan tipe dealer anda!");
						    return 1;
						}
					}
					//Hustler
					case 545:
					{
                        if(GetPlayerMoney(playerid) >= 9000)
                        {
                            buyveh = 10000;
                            harga = 350000;
						}
						else
						{
                            Servers(playerid, "Anda harus mempunyai modal sebesar $950.00!");
                            return 1;
						}
					}
					//Camper
					case 483:
					{
					    if(CarDealershipInfo[cid][cdType] == 3) {
                        if(GetPlayerMoney(playerid) >= 7000)
                        {
                            buyveh = 10000;
                            harga = 750000;
						}
						else
						{
                            Servers(playerid, "Anda harus mempunyai modal sebesar $750.00!");
                            return 1;
						}
						}
						else
						{
						    Error(playerid, "Kendaraan ini tidak cocok dengan tipe dealer anda!");
						    return 1;
						}
					}
					//Journey
					case 508:
					{
                        if(GetPlayerMoney(playerid) >= 14000)
                        {
                            buyveh = 10000;
                            harga = 140000;
						}
						else
						{
                            Servers(playerid, "Anda harus mempunyai modal sebesar $1.400.00!");
                            return 1;
						}
					}
					//Caddy
					case 457:
					{
                        if(GetPlayerMoney(playerid) >= 10000)
                        {
                            buyveh = 10000;
                            harga = 100000;
						}
						else
						{
                            Servers(playerid, "Anda harus mempunyai modal sebesar $1.000.00!");
                            return 1;
						}
					}
					//Comet
					case 480:
					{
                        if(GetPlayerMoney(playerid) >= 35000)
                        {
                            buyveh = 10000;
                            harga = 350000;
						}
						else
						{
                            Servers(playerid, "Anda harus mempunyai modal sebesar $3.500.00!");
                            return 1;
						}
					}
					//Stallion
					case 439:
					{
                        if(GetPlayerMoney(playerid) >= 12000)
                        {
                            buyveh = 10000;
                            harga = 120000;
						}
						else
						{
                            Servers(playerid, "Anda harus mempunyai modal sebesar $1.200.00!");
                            return 1;
						}
					}
					//Feltzer
					case 533:
					{
                        if(GetPlayerMoney(playerid) >= 15000)
                        {
                            buyveh = 10000;
                            harga = 150000;
						}
						else
						{
                            Servers(playerid, "Anda harus mempunyai modal sebesar $1.500.00!");
                            return 1;
						}
					}
					//Pony
					case 413:
					{
					    if(CarDealershipInfo[cid][cdType] == 3) {
                        if(GetPlayerMoney(playerid) >= 12000)
                        {
                            buyveh = 10000;
                            harga = 120000;
						}
						else
						{
                            Servers(playerid, "Anda harus mempunyai modal sebesar $1.200.00!");
                            return 1;
						}
						}
						else
						{
						    Error(playerid, "Kendaraan ini tidak cocok dengan tipe dealer anda!");
						    return 1;
						}
					}
					//Sadler
					case 543:
					{
					    if(CarDealershipInfo[cid][cdType] == 2) {
                        if(GetPlayerMoney(playerid) >= 5000)
                        {
      						buyveh = 50000;
                            harga = 150000;
						}
						else
						{
                            Servers(playerid, "Anda harus mempunyai modal sebesar $10.000!");
                            return 1;
						}
						}
						else
						{
						    Error(playerid, "Kendaraan ini tidak cocok dengan tipe dealer anda!");
						    return 1;
						}
					}
					case 609:
					{
					    if(CarDealershipInfo[cid][cdType] == 2) {
                        if(GetPlayerMoney(playerid) >= 5000)
                        {
      						buyveh = 50000;
                            harga = 165000;
						}
						else
						{
                            Servers(playerid, "Anda harus mempunyai modal sebesar $10.000!");
                            return 1;
						}
						}
						else
						{
						    Error(playerid, "Kendaraan ini tidak cocok dengan tipe dealer anda!");
						    return 1;
						}
					}
					case 554:
					{
					    if(CarDealershipInfo[cid][cdType] == 2) {
	                        if(GetPlayerMoney(playerid) >= 10000)
	                        {
      							buyveh = 10000;
	                            harga = 170000;
							}
							else
							{
	                            Servers(playerid, "Anda harus mempunyai modal sebesar $10.000!");
	                            return 1;
							}
						}
						else
						{
						    Error(playerid, "Kendaraan ini tidak cocok dengan tipe dealer anda!");
						    return 1;
						}
					}
					//Yanke
					case 456:
					{
					    if(CarDealershipInfo[cid][cdType] == 2) {
                        if(GetPlayerMoney(playerid) >= 10000)
                        {
      						buyveh = 10000;
                            harga = 160000;
						}
						else
						{
                            Servers(playerid, "Anda harus mempunyai modal sebesar $10.000!");
                            return 1;
						}
						}
						else
						{
						    Error(playerid, "Kendaraan ini tidak cocok dengan tipe dealer anda!");
						    return 1;
						}
					}
					//Mule
					case 414:
					{
					    if(CarDealershipInfo[cid][cdType] == 2) {
                        if(GetPlayerMoney(playerid) >= 10000)
                        {
      						buyveh = 10000;
                            harga = 160000;
						}
						else
						{
                            Servers(playerid, "Anda harus mempunyai modal sebesar $10.000!");
                            return 1;
						}
						}
						else
						{
						    Error(playerid, "Kendaraan ini tidak cocok dengan tipe dealer anda!");
						    return 1;
						}
					}
					//Road
					case 515:
					{
					    if(CarDealershipInfo[cid][cdType] == 2) {
	                        if(GetPlayerMoney(playerid) >= 13000)
	                        {
      							buyveh = 130000;
	                            harga = 250000;
							}
							else
							{
	                            Servers(playerid, "Anda harus mempunyai modal sebesar $10.000!");
	                            return 1;
							}
						}
						else
						{
						    Error(playerid, "Kendaraan ini tidak cocok dengan tipe dealer anda!");
						    return 1;
						}
					}
					//Flet
					case 455:
					{
					    if(CarDealershipInfo[cid][cdType] == 2) {
                        if(GetPlayerMoney(playerid) >= 6000)
                        {
      						buyveh = 60000;
                            harga = 140000;
						}
						else
						{
                            Servers(playerid, "Anda harus mempunyai modal sebesar $10.000!");
                            return 1;
						}
						}
						else
						{
						    Error(playerid, "Kendaraan ini tidak cocok dengan tipe dealer anda!");
						    return 1;
						}
					}
					//Lum
					case 403:
					{
					    if(CarDealershipInfo[cid][cdType] == 2) {
                        if(GetPlayerMoney(playerid) >= 10000)
                        {
      						buyveh = 100000;
                            harga = 180000;
						}
						else
						{
                            Servers(playerid, "Anda harus mempunyai modal sebesar $10.000!");
                            return 1;
						}
						}
						else
						{
						    Error(playerid, "Kendaraan ini tidak cocok dengan tipe dealer anda!");
						    return 1;
						}
					}
					//Bobcat
					case 422:
					{
					    if(CarDealershipInfo[cid][cdType] == 2) {
                        if(GetPlayerMoney(playerid) >= 6000)
                        {
      						buyveh = 60000;
                            harga = 120000;
						}
						else
						{
                            Servers(playerid, "Anda harus mempunyai modal sebesar $10.000!");
                            return 1;
						}
						}
						else
						{
						    Error(playerid, "Kendaraan ini tidak cocok dengan tipe dealer anda!");
						    return 1;
						}
					}
					//Walton
					case 478:
					{
					    if(CarDealershipInfo[cid][cdType] == 4) {
                        if(GetPlayerMoney(playerid) >= 5000)
                        {
      						buyveh = 50000;
                            harga = 50000;
						}
						else
						{
                            Servers(playerid, "Anda harus mempunyai modal sebesar $500.00!");
                            return 1;
						}
						}
						else
						{
						    Error(playerid, "Kendaraan ini tidak cocok dengan tipe dealer anda!");
						    return 1;
						}
					}
					//Burrito
					case 482:
					{
					    if(CarDealershipInfo[cid][cdType] == 4) {
                        if(GetPlayerMoney(playerid) >= 15000)
                        {
                            buyveh = 100000;
                            harga = 150000;
						}
						else
						{
                            Servers(playerid, "Anda harus mempunyai modal sebesar $1.500.00!");
                            return 1;
						}
						}
						else
						{
						    Error(playerid, "Kendaraan ini tidak cocok dengan tipe dealer anda!");
						    return 1;
						}
					}
					//Picador
					case 600:
					{
					    if(CarDealershipInfo[cid][cdType] == 4) {
                        if(GetPlayerMoney(playerid) >= 10000)
                        {
                            buyveh = 10000;
                            harga = 100000;
						}
						else
						{
                            Servers(playerid, "Anda harus mempunyai modal sebesar $1.000.00!");
                            return 1;
						}
						}
						else
						{
						    Error(playerid, "Kendaraan ini tidak cocok dengan tipe dealer anda!");
						    return 1;
						}
					}
					//Alpha
					case 602:
					{
					    if(CarDealershipInfo[cid][cdType] == 6) {
                        if(GetPlayerMoney(playerid) >= 28000)
                        {
                            buyveh = 10000;
                            harga = 280000;
						}
						else
						{
                            Servers(playerid, "Anda harus mempunyai modal sebesar $2.800.00!");
                            return 1;
						}
						}
						else
						{
						    Error(playerid, "Kendaraan ini tidak cocok dengan tipe dealer anda!");
						    return 1;
						}
					}
					//Euros
					case 587:
					{
					    if(CarDealershipInfo[cid][cdType] == 6) {
                        if(GetPlayerMoney(playerid) >= 27000)
                        {
                            buyveh = 10000;
                            harga = 270000;
						}
						else
						{
                            Servers(playerid, "Anda harus mempunyai modal sebesar $2.700.00!");
                            return 1;
						}
						}
						else
						{
						    Error(playerid, "Kendaraan ini tidak cocok dengan tipe dealer anda!");
						    return 1;
						}
					}
					//Club
					case 589:
					{
					    if(CarDealershipInfo[cid][cdType] == 6) {
                        if(GetPlayerMoney(playerid) >= 15000)
                        {
                            buyveh = 10000;
                            harga = 150000;
						}
						else
						{
                            Servers(playerid, "Anda harus mempunyai modal sebesar $1.500.00!");
                            return 1;
						}
						}
						else
						{
						    Error(playerid, "Kendaraan ini tidak cocok dengan tipe dealer anda!");
						    return 1;
						}
					}
					//Flash
					case 565:
					{
					    if(CarDealershipInfo[cid][cdType] == 6) {
                        if(GetPlayerMoney(playerid) >= 25000)
                        {
                            buyveh = 10000;
                            harga = 250000;
						}
						else
						{
                            Servers(playerid, "Anda harus mempunyai modal sebesar $2.500.00!");
                            return 1;
						}
						}
						else
						{
						    Error(playerid, "Kendaraan ini tidak cocok dengan tipe dealer anda!");
						    return 1;
						}
					}
					//Jester
					case 559:
					{
					    if(CarDealershipInfo[cid][cdType] == 6) {
                        if(GetPlayerMoney(playerid) >= 25000)
                        {
                            buyveh = 10000;
                            harga = 250000;
						}
						else
						{
                            Servers(playerid, "Anda harus mempunyai modal sebesar $2.500.00!");
                            return 1;
						}
						}
						else
						{
						    Error(playerid, "Kendaraan ini tidak cocok dengan tipe dealer anda!");
						    return 1;
						}
					}
					//Uranus
					case 558:
					{
					    if(CarDealershipInfo[cid][cdType] == 6) {
                        if(GetPlayerMoney(playerid) >= 25000)
                        {
                            buyveh = 10000;
                            harga = 700000;
						}
						else
						{
                            Servers(playerid, "Anda harus mempunyai modal sebesar $2.500.00!");
                            return 1;
						}
						}
						else
						{
						    Error(playerid, "Kendaraan ini tidak cocok dengan tipe dealer anda!");
						    return 1;
						}
					}
					//Bullet
					case 541:
					{
					    if(CarDealershipInfo[cid][cdType] == 6) {
                        if(GetPlayerMoney(playerid) >= 95000)
                        {
                            buyveh = 10000;
                            harga = 950000;
						}
						else
						{
                            Servers(playerid, "Anda harus mempunyai modal sebesar $9.500.00!");
                            return 1;
						}
						}
						else
						{
						    Error(playerid, "Kendaraan ini tidak cocok dengan tipe dealer anda!");
						    return 1;
						}
					}
					//Banshee
					case 429:
					{
					    if(CarDealershipInfo[cid][cdType] == 6) {
                        if(GetPlayerMoney(playerid) >= 85000)
                        {
                            buyveh = 10000;
                            harga = 850000;
						}
						else
						{
                            Servers(playerid, "Anda harus mempunyai modal sebesar $8.500.00!");
                            return 1;
						}
						}
						else
						{
						    Error(playerid, "Kendaraan ini tidak cocok dengan tipe dealer anda!");
						    return 1;
						}
					}
					//Bufallo
					case 402:
					{
             			if(CarDealershipInfo[cid][cdType] == 6) {
                        if(GetPlayerMoney(playerid) >= 35000)
                        {
                            buyveh = 10000;
                            harga = 350000;
						}
						else
						{
                            Servers(playerid, "Anda harus mempunyai modal sebesar $3.500.00!");
                            return 1;
						}
						}
						else
						{
						    Error(playerid, "Kendaraan ini tidak cocok dengan tipe dealer anda!");
						    return 1;
						}
					}
					//Cheetah
					case 415:
					{
					    if(CarDealershipInfo[cid][cdType] == 6) {
                        if(GetPlayerMoney(playerid) >= 45000)
                        {
                            buyveh = 10000;
                            harga = 450000;
						}
						else
						{
                            Servers(playerid, "Anda harus mempunyai modal sebesar $4.500.00!");
                            return 1;
						}
						}
						else
						{
						    Error(playerid, "Kendaraan ini tidak cocok dengan tipe dealer anda!");
						    return 1;
						}
					}
					//Sabre
					case 475:
					{
					    if(CarDealershipInfo[cid][cdType] == 6) {
                        if(GetPlayerMoney(playerid) >= 9000)
                        {
                            buyveh = 10000;
                            harga = 95000;
						}
						else
						{
                            Servers(playerid, "Anda harus mempunyai modal sebesar $950.00!");
                            return 1;
						}
						}
						else
						{
						    Error(playerid, "Kendaraan ini tidak cocok dengan tipe dealer anda!");
						    return 1;
						}
					}
					//ZR-350
					case 477:
					{
					    if(CarDealershipInfo[cid][cdType] == 6) {
                        if(GetPlayerMoney(playerid) >= 30000)
                        {
                            buyveh = 10000;
                            harga = 300000;
						}
						else
						{
                            Servers(playerid, "Anda harus mempunyai modal sebesar $3.000.00!");
                            return 1;
						}
						}
						else
						{
						    Error(playerid, "Kendaraan ini tidak cocok dengan tipe dealer anda!");
						    return 1;
						}
					}
					//Blista Compact
					case 496:
					{
					    if(CarDealershipInfo[cid][cdType] == 6) {
                        if(GetPlayerMoney(playerid) >= 15000)
                        {
                            buyveh = 10000;
                            harga = 150000;
						}
						else
						{
                            Servers(playerid, "Anda harus mempunyai modal sebesar $1.500.00!");
                            return 1;
						}
						}
						else
						{
						    Error(playerid, "Kendaraan ini tidak cocok dengan tipe dealer anda!");
						    return 1;
						}
					}
					//Reefer
					case 453:
					{
					    if(CarDealershipInfo[cid][cdType] == 7) {
                        if(GetPlayerMoney(playerid) >= 5000)
                        {
                            buyveh = 10000;
                            harga = 500000;
						}
						else
						{
                            Servers(playerid, "Anda harus mempunyai modal sebesar $500.00!");
                            return 1;
						}
						}
						else
						{
						    Error(playerid, "Kendaraan ini tidak cocok dengan tipe dealer anda!");
						    return 1;
						}
					}
					//Tropic
					case 454:
					{
					    if(CarDealershipInfo[cid][cdType] == 7) {
                        if(GetPlayerMoney(playerid) >= 9000)
                        {
                            buyveh = 10000;
                            harga = 95000;
						}
						else
						{
                            Servers(playerid, "Anda harus mempunyai modal sebesar $950.00!");
                            return 1;
						}
						}
						else
						{
						    Error(playerid, "Kendaraan ini tidak cocok dengan tipe dealer anda!");
						    return 1;
						}
					}
					//Squalo
					case 446:
					{
					    if(CarDealershipInfo[cid][cdType] == 7) {
                        if(GetPlayerMoney(playerid) >= 40000)
                        {
                            buyveh = 10000;
                            harga = 400000;
						}
						else
						{
                            Servers(playerid, "Anda harus mempunyai modal sebesar $4.000.00!");
                            return 1;
						}
						}
						else
						{
						    Error(playerid, "Kendaraan ini tidak cocok dengan tipe dealer anda!");
						    return 1;
						}
					}
					//Marquis
					case 484:
					{
					    if(CarDealershipInfo[cid][cdType] == 7) {
                        if(GetPlayerMoney(playerid) >= 95000)
                        {
                            buyveh = 10000;
                            harga = 950000;
						}
						else
						{
                            Servers(playerid, "Anda harus mempunyai modal sebesar $9.500.00!");
                            return 1;
						}
						}
						else
						{
						    Error(playerid, "Kendaraan ini tidak cocok dengan tipe dealer anda!");
						    return 1;
						}
					}
					//Dinghy
					case 473:
					{
					    if(CarDealershipInfo[cid][cdType] == 7) {
                        if(GetPlayerMoney(playerid) >= 5000)
                        {
                            buyveh = 10000;
                            harga = 50000;
						}
						else
						{
                            Servers(playerid, "Anda harus mempunyai modal sebesar $500.00!");
                            return 1;
						}
						}
						else
						{
						    Error(playerid, "Kendaraan ini tidak cocok dengan tipe dealer anda!");
						    return 1;
						}
					}
					//Jetmax
					case 493:
					{
					    if(CarDealershipInfo[cid][cdType] == 7) {
                        if(GetPlayerMoney(playerid) >= 15000)
                        {
                            buyveh = 10000;
                            harga = 150000;
						}
						else
						{
                            Servers(playerid, "Anda harus mempunyai modal sebesar $1.500.00!");
                            return 1;
						}
						}
						else
						{
						    Error(playerid, "Kendaraan ini tidak cocok dengan tipe dealer anda!");
						    return 1;
						}
					}
					//Maverick
					case 487:
					{
                        if(GetPlayerMoney(playerid) >= 100000)
                        {
                            buyveh = 10000;
                            harga = 100000;
						}
						else
						{
                            Servers(playerid, "Anda harus mempunyai modal sebesar $10.000.00!");
                            return 1;
						}
					}
					default:
					{
						return 1;
					}
				}
				new cdvehicleid = CreateCarDealershipVehicle(cid, modelid, x, y, z, a, harga);
				if(cdvehicleid == -1)
				{
				 	Error(playerid, "Car couldn't be created.");
				}
				else
				{
				 	PutPlayerInVehicle(playerid, CarDealershipInfo[cid][cdVehicleId][cdvehicleid], 0);
				 	Servers(playerid, "Car Dealership Vehicle created with Vehicle ID %d.", cdvehicleid);
				 	GivePlayerMoneyEx(playerid, -buyveh);
				 	Servers(playerid, "Please stand where you want to add your new vehicle.");
				 	Servers(playerid, "Once ready press the fire button.");
				 	SetPVarInt(playerid, "editingcdvehnew", 1);
				 	SetPVarInt(playerid, "editingcdveh", cdvehicleid);
				}
	        }
	        else
	        {
                 Error(playerid, "You are out of this Car Dealership radius, please try again.");
                 TogglePlayerControllable(playerid, true);
	        }
		}
		else
		{
            TogglePlayerControllable(playerid, true);
			SetPVarInt(playerid, "editingcd", -1);
		}
	}
	if(dialogid == DIALOG_CDBUY)
	{
	    // Account Eating Bug Fix
	    if(!IsPlayerInAnyVehicle(playerid))
		{
		    TogglePlayerControllable(playerid, 1);
			Servers(playerid, "You need to be in the vehicle you wish to purchase.");
			DeletePVar(playerid, "buycar_dialog");
			return 1;
		}

		new vehicleid = GetPlayerVehicleID(playerid);
		new v = GetCarDealershipVehicleId(vehicleid);
		new cid = GetCarDealershipId(vehicleid);
		if(response)
		{
            if(CarDealershipInfo[cid][cdVehicleSpawn][0] == 0.0 && CarDealershipInfo[cid][cdVehicleSpawn][1] == 0.0 && CarDealershipInfo[cid][cdVehicleSpawn][2] == 0.0)
            {
				Error(playerid, "The owner of this Car Dealership hasn't set the purchased vehicles spawn point.");
				RemovePlayerFromVehicle(playerid);
				new Float:slx, Float:sly, Float:slz;
				GetPlayerPos(playerid, slx, sly, slz);
				SetPlayerPos(playerid, slx, sly, slz+1.2);
				TogglePlayerControllable(playerid, 1);
				DeletePVar(playerid, "buycar_dialog");
				return 1;
            }
			if(pData[playerid][pMoney] < CarDealershipInfo[cid][cdVehicleCost][v])
			{
				Error(playerid, "Uang anda tidak mencukupi.!");
				DeletePVar(playerid, "buycar_dialog");
				RemovePlayerFromVehicle(playerid);
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
				DeletePVar(playerid, "buycar_dialog");
				RemovePlayerFromVehicle(playerid);

				return 1;
			}
			SetPlayerPos(playerid, CarDealershipInfo[cid][cdVehicleSpawn][0], CarDealershipInfo[cid][cdVehicleSpawn][1], CarDealershipInfo[cid][cdVehicleSpawn][2]+2);
		    TogglePlayerControllable(playerid, 1);
		    DeletePVar(playerid, "buycar_dialog");

	        if(GetPlayerMoney(playerid) < CarDealershipInfo[cid][cdVehicleCost][v])
	        {
				Error(playerid, "You don't have enough money to buy this.");
				RemovePlayerFromVehicle(playerid);
				DeletePVar(playerid, "buycar_dialog");
				return 1;
			}
			Servers(playerid, "Thank you for buying at {FFFF00}%s.", CarDealershipInfo[cid][cdMessage]);
		    GivePlayerMoneyEx(playerid, -CarDealershipInfo[cid][cdVehicleCost][v]);

		    new Float:x = CarDealershipInfo[cid][cdVehicleSpawn][0];
		    new Float:y = CarDealershipInfo[cid][cdVehicleSpawn][1];
		    new Float:z = CarDealershipInfo[cid][cdVehicleSpawn][2];
		    new Float:a = CarDealershipInfo[cid][cdVehicleSpawn][3];

		    foreach(new did : CarDealership)
			{
		        if(IsPlayerInRangeOfPoint(playerid, CarDealershipInfo[did][cdRadius], CarDealershipInfo[did][cdEntranceX], CarDealershipInfo[did][cdEntranceY], CarDealershipInfo[did][cdEntranceZ])) {
		            if(!IsPlayerOwnerOfCDEx(playerid, did))
					{
		    			CarDealershipInfo[did][cdTill] += CarDealershipInfo[did][cdVehicleCost][v];
					}
				}
			}
			new cQuery[1024];
			new color1, color2;
			color1 = 1;
			color2 = 1;

			mysql_format(g_SQL, cQuery, sizeof(cQuery), "INSERT INTO `vehicle` (`owner`, `model`, `color1`, `color2`, `price`, `x`, `y`, `z`, `a`) VALUES (%d, %d, %d, %d, %d, '%f', '%f', '%f', '%f')", pData[playerid][pID], CarDealershipInfo[cid][cdVehicleModel][v], color1, color2, CarDealershipInfo[cid][cdVehicleCost][v], x, y, z, a);
			mysql_tquery(g_SQL, cQuery, "OnVehDealer", "ddddddffff", playerid, pData[playerid][pID], CarDealershipInfo[cid][cdVehicleModel][v], color1, color2, CarDealershipInfo[cid][cdVehicleCost][v], x, y, z, a);

			DestroyCarDealershipVehicle(cid, v);
            SavecDealership(cid);
		}
		else
		{
		    DeletePVar(playerid, "buycar_dialog");
            RemovePlayerFromVehicle(playerid);
            TogglePlayerControllable(playerid, 1);
			return 1;
		}
	}
	return 1;
}

function OnVehDealer(playerid, pid, model, color1, color2, cost, Float:x, Float:y, Float:z, Float:a)
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
	pvData[i][cInsu] = 1;
	pvData[i][cClaim] = 0;
	pvData[i][cClaimTime] = 0;
	pvData[i][cImpound] = 0;
	pvData[i][cImpoundTime] = 0;
	pvData[i][cTicket] = 0;
	pvData[i][cPrice] = cost;
	pvData[i][cHealth] = 2000;
	pvData[i][cFuel] = 1000;
	format(pvData[i][cPlate], 16, "JAVA");
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
	pvData[i][cPark] = 0;
	pvData[i][cRent] = 0;
	pvData[i][cMesinUpgrade] = 0;
	pvData[i][cBodyUpgrade] = 0;
	for(new j = 0; j < 17; j++)
	pvData[i][cMod][j] = 0;
	Iter_Add(PVehicles, i);
	OnPlayerVehicleRespawn(i);
	Servers(playerid, "Anda telah membeli kendaraan %s", GetVehicleModelName(model));
	pData[playerid][pBuyPvModel] = 0;
	SetPlayerVirtualWorld(playerid, 0);
	return 1;
}

DealershipRefresh(cid)
{
	if(cid != -1)
	{
		if(IsValidDynamic3DTextLabel(CarDealershipInfo[cid][cdTextLabel]))
            DestroyDynamic3DTextLabel(CarDealershipInfo[cid][cdTextLabel]);

        if(IsValidDynamicPickup(CarDealershipInfo[cid][cdPickupID]))
            DestroyDynamicPickup(CarDealershipInfo[cid][cdPickupID]);


        new type[128];
		if(CarDealershipInfo[cid][cdType] == 1)
		{
			type= "Motorcycle";
		}
		else if(CarDealershipInfo[cid][cdType] == 2)
		{
			type= "Cars Job";
		}
		else if(CarDealershipInfo[cid][cdType] == 3)
		{
			type= "Cars";
		}
		else
		{
			type= "Unknown";
		}

		new string[558];
		if(CarDealershipInfo[cid][cdEntranceX] != 0 && CarDealershipInfo[cid][cdEntranceY] != 0 && CarDealershipInfo[cid][cdEntranceX] != 0 && strcmp(CarDealershipInfo[cid][cdOwner], "-"))
		{
	        format(string, sizeof(string),"{FFFF00}ID: %d\n{FFFFFF}Type:{ffff00} %s\n{ffffff}Sponsored: {FFFF00}%s\n{FFFFFF}Owner: {FFFF00}%s", cid, type, CarDealershipInfo[cid][cdMessage], CarDealershipInfo[cid][cdOwner]);
	        CarDealershipInfo[cid][cdTextLabel] = CreateDynamic3DTextLabel(string,-1,CarDealershipInfo[cid][cdEntranceX], CarDealershipInfo[cid][cdEntranceY], CarDealershipInfo[cid][cdEntranceZ], 4.0);
			CarDealershipInfo[cid][cdPickupID] = CreateDynamicPickup(1239, 1, CarDealershipInfo[cid][cdEntranceX], CarDealershipInfo[cid][cdEntranceY], CarDealershipInfo[cid][cdEntranceZ], 0);
		}
		else if(CarDealershipInfo[cid][cdEntranceX] != 0 && CarDealershipInfo[cid][cdEntranceY] != 0 && CarDealershipInfo[cid][cdEntranceZ] != 0)
		{
			format(string, sizeof(string),"{FFFF00}ID: %d\n{ffffff}Type: {ffff00}%s\n{ffffff}dealership for sale\n{FFFFFF}Price: {00FF00}%s\n{ff0000}'/buydealership' to buy this dealership", cid, type, FormatMoney(CarDealershipInfo[cid][cdPrice]));
	        CarDealershipInfo[cid][cdTextLabel] = CreateDynamic3DTextLabel(string,-1,CarDealershipInfo[cid][cdEntranceX], CarDealershipInfo[cid][cdEntranceY], CarDealershipInfo[cid][cdEntranceZ], 4.0);
            CarDealershipInfo[cid][cdPickupID] = CreateDynamicPickup(1239, 1, CarDealershipInfo[cid][cdEntranceX], CarDealershipInfo[cid][cdEntranceY], CarDealershipInfo[cid][cdEntranceZ], 0);
   		}
	}
}

function LoadCarDealership()
{
	static cid;
	new rows = cache_num_rows(), owner[128], mss[128];

	if(rows)
  	{
		for(new i; i < rows; i++)
		{
			cache_get_value_name_int(i, "id", cid);
			cache_get_value_name(i, "owner", owner);
			format(CarDealershipInfo[cid][cdOwner], 128, owner);
			cache_get_value_name_int(i, "till", CarDealershipInfo[cid][cdTill]);
			cache_get_value_name_int(i, "interior", CarDealershipInfo[cid][cdInterior]);
			cache_get_value_name_int(i, "price", CarDealershipInfo[cid][cdPrice]);
			cache_get_value_name_int(i, "type", CarDealershipInfo[cid][cdType]);
			cache_get_value_name(i, "message", mss);
			format(CarDealershipInfo[cid][cdMessage], 128, mss);
			cache_get_value_name_float(i, "entrance_x", CarDealershipInfo[cid][cdEntranceX]);
			cache_get_value_name_float(i, "entrance_y", CarDealershipInfo[cid][cdEntranceY]);
			cache_get_value_name_float(i, "entrance_z", CarDealershipInfo[cid][cdEntranceZ]);
			cache_get_value_name_float(i, "radius", CarDealershipInfo[cid][cdRadius]);

			cache_get_value_name_float(i, "vehicle_spawnx", CarDealershipInfo[cid][cdVehicleSpawn][0]);
			cache_get_value_name_float(i, "vehicle_spawny", CarDealershipInfo[cid][cdVehicleSpawn][1]);
			cache_get_value_name_float(i, "vehicle_spawnz", CarDealershipInfo[cid][cdVehicleSpawn][2]);
			cache_get_value_name_float(i, "vehicle_spawna", CarDealershipInfo[cid][cdVehicleSpawn][3]);

			cache_get_value_name_float(i, "exit_x", CarDealershipInfo[cid][cdExitX]);
			cache_get_value_name_float(i, "exit_y", CarDealershipInfo[cid][cdExitY]);
			cache_get_value_name_float(i, "exit_z", CarDealershipInfo[cid][cdExitZ]);


			cache_get_value_name_float(i, "buyspawnx0", CarDealershipInfo[cid][cdVehicleSpawnX][0]);
			cache_get_value_name_float(i, "buyspawny0", CarDealershipInfo[cid][cdVehicleSpawnY][0]);
			cache_get_value_name_float(i, "buyspawnz0", CarDealershipInfo[cid][cdVehicleSpawnZ][0]);
			cache_get_value_name_float(i, "buyspawnangle0", CarDealershipInfo[cid][cdVehicleSpawnAngle][0]);

			cache_get_value_name_float(i, "buyspawnx1", CarDealershipInfo[cid][cdVehicleSpawnX][1]);
			cache_get_value_name_float(i, "buyspawny1", CarDealershipInfo[cid][cdVehicleSpawnY][1]);
			cache_get_value_name_float(i, "buyspawnz1", CarDealershipInfo[cid][cdVehicleSpawnZ][1]);
			cache_get_value_name_float(i, "buyspawnangle1", CarDealershipInfo[cid][cdVehicleSpawnAngle][1]);

			cache_get_value_name_float(i, "buyspawnx2", CarDealershipInfo[cid][cdVehicleSpawnX][2]);
			cache_get_value_name_float(i, "buyspawny2", CarDealershipInfo[cid][cdVehicleSpawnY][2]);
			cache_get_value_name_float(i, "buyspawnz2", CarDealershipInfo[cid][cdVehicleSpawnZ][2]);
			cache_get_value_name_float(i, "buyspawnangle2", CarDealershipInfo[cid][cdVehicleSpawnAngle][2]);

			cache_get_value_name_float(i, "buyspawnx3", CarDealershipInfo[cid][cdVehicleSpawnX][3]);
			cache_get_value_name_float(i, "buyspawny3", CarDealershipInfo[cid][cdVehicleSpawnY][3]);
			cache_get_value_name_float(i, "buyspawnz3", CarDealershipInfo[cid][cdVehicleSpawnZ][3]);
			cache_get_value_name_float(i, "buyspawnangle3", CarDealershipInfo[cid][cdVehicleSpawnAngle][3]);

			cache_get_value_name_float(i, "buyspawnx4", CarDealershipInfo[cid][cdVehicleSpawnX][4]);
			cache_get_value_name_float(i, "buyspawny4", CarDealershipInfo[cid][cdVehicleSpawnY][4]);
			cache_get_value_name_float(i, "buyspawnz4", CarDealershipInfo[cid][cdVehicleSpawnZ][4]);
			cache_get_value_name_float(i, "buyspawnangle4", CarDealershipInfo[cid][cdVehicleSpawnAngle][4]);

			cache_get_value_name_float(i, "buyspawnx5", CarDealershipInfo[cid][cdVehicleSpawnX][5]);
			cache_get_value_name_float(i, "buyspawny5", CarDealershipInfo[cid][cdVehicleSpawnY][5]);
			cache_get_value_name_float(i, "buyspawnz5", CarDealershipInfo[cid][cdVehicleSpawnZ][5]);
			cache_get_value_name_float(i, "buyspawnangle5", CarDealershipInfo[cid][cdVehicleSpawnAngle][5]);

			cache_get_value_name_float(i, "buyspawnx6", CarDealershipInfo[cid][cdVehicleSpawnX][6]);
			cache_get_value_name_float(i, "buyspawny6", CarDealershipInfo[cid][cdVehicleSpawnY][6]);
			cache_get_value_name_float(i, "buyspawnz6", CarDealershipInfo[cid][cdVehicleSpawnZ][6]);
			cache_get_value_name_float(i, "buyspawnangle6", CarDealershipInfo[cid][cdVehicleSpawnAngle][6]);

			cache_get_value_name_float(i, "buyspawnx7", CarDealershipInfo[cid][cdVehicleSpawnX][7]);
			cache_get_value_name_float(i, "buyspawny7", CarDealershipInfo[cid][cdVehicleSpawnY][7]);
			cache_get_value_name_float(i, "buyspawnz7", CarDealershipInfo[cid][cdVehicleSpawnZ][7]);
			cache_get_value_name_float(i, "buyspawnangle7", CarDealershipInfo[cid][cdVehicleSpawnAngle][7]);

			cache_get_value_name_float(i, "buyspawnx8", CarDealershipInfo[cid][cdVehicleSpawnX][8]);
			cache_get_value_name_float(i, "buyspawny8", CarDealershipInfo[cid][cdVehicleSpawnY][8]);
			cache_get_value_name_float(i, "buyspawnz8", CarDealershipInfo[cid][cdVehicleSpawnZ][8]);
			cache_get_value_name_float(i, "buyspawnangle8", CarDealershipInfo[cid][cdVehicleSpawnAngle][8]);

			cache_get_value_name_float(i, "buyspawnx9", CarDealershipInfo[cid][cdVehicleSpawnX][9]);
			cache_get_value_name_float(i, "buyspawny9", CarDealershipInfo[cid][cdVehicleSpawnY][9]);
			cache_get_value_name_float(i, "buyspawnz9", CarDealershipInfo[cid][cdVehicleSpawnZ][9]);
			cache_get_value_name_float(i, "buyspawnangle9", CarDealershipInfo[cid][cdVehicleSpawnAngle][9]);

			cache_get_value_name_int(i, "vehiclecost0", CarDealershipInfo[cid][cdVehicleCost][0]);
			cache_get_value_name_int(i, "vehicletype0", CarDealershipInfo[cid][cdVehicleModel][0]);

			cache_get_value_name_int(i, "vehiclecost1", CarDealershipInfo[cid][cdVehicleCost][1]);
			cache_get_value_name_int(i, "vehicletype1", CarDealershipInfo[cid][cdVehicleModel][1]);

			cache_get_value_name_int(i, "vehiclecost2", CarDealershipInfo[cid][cdVehicleCost][2]);
			cache_get_value_name_int(i, "vehicletype2", CarDealershipInfo[cid][cdVehicleModel][2]);

			cache_get_value_name_int(i, "vehiclecost3", CarDealershipInfo[cid][cdVehicleCost][3]);
			cache_get_value_name_int(i, "vehicletype3", CarDealershipInfo[cid][cdVehicleModel][3]);

			cache_get_value_name_int(i, "vehiclecost4", CarDealershipInfo[cid][cdVehicleCost][4]);
			cache_get_value_name_int(i, "vehicletype4", CarDealershipInfo[cid][cdVehicleModel][4]);

			cache_get_value_name_int(i, "vehiclecost5", CarDealershipInfo[cid][cdVehicleCost][5]);
			cache_get_value_name_int(i, "vehicletype5", CarDealershipInfo[cid][cdVehicleModel][5]);

			cache_get_value_name_int(i, "vehiclecost6", CarDealershipInfo[cid][cdVehicleCost][6]);
			cache_get_value_name_int(i, "vehicletype6", CarDealershipInfo[cid][cdVehicleModel][6]);

			cache_get_value_name_int(i, "vehiclecost7", CarDealershipInfo[cid][cdVehicleCost][7]);
			cache_get_value_name_int(i, "vehicletype7", CarDealershipInfo[cid][cdVehicleModel][7]);

			cache_get_value_name_int(i, "vehiclecost8", CarDealershipInfo[cid][cdVehicleCost][8]);
			cache_get_value_name_int(i, "vehicletype8", CarDealershipInfo[cid][cdVehicleModel][8]);

			cache_get_value_name_int(i, "vehiclecost9", CarDealershipInfo[cid][cdVehicleCost][9]);
			cache_get_value_name_int(i, "vehicletype9", CarDealershipInfo[cid][cdVehicleModel][9]);

			new string[528];
			for(new v = 0; v < MAX_DEALERSHIPVEHICLES; v++)
		    {
				if(CarDealershipInfo[cid][cdVehicleModel][v] != 0)
				{
			        new carcreated = AddStaticVehicleEx(CarDealershipInfo[cid][cdVehicleModel][v], CarDealershipInfo[cid][cdVehicleSpawnX][v], CarDealershipInfo[cid][cdVehicleSpawnY][v], CarDealershipInfo[cid][cdVehicleSpawnZ][v], CarDealershipInfo[cid][cdVehicleSpawnAngle][v], -1, -1, 0);
			        format(string, sizeof(string), "ID: %d\n{FFFF00}%s\n{FFFFFF}Price: {00FF00}%s\n{ffff00}Health: {ffffff}1000.0\n{ffff00}Fuel: {ffffff}100.0",v, GetVehicleName(carcreated), FormatMoney(CarDealershipInfo[cid][cdVehicleCost][v]));
		            CarDealershipInfo[cid][cdVehicleLabel][v] = CreateDynamic3DTextLabel(string,0x00B6FFFF,0.0, 0.0, 0.0,8.0,INVALID_PLAYER_ID,carcreated);
		            CarDealershipInfo[cid][cdVehicleId][v] = carcreated;
		            SetVehicleNumberPlate(carcreated,"{00FFFF}Dealership");
				}
			}
			DealershipRefresh(cid);
			Iter_Add(CarDealership, i);
	    }
	    printf( "Dealership Loaded: %d", rows);
	}
	return 1;
}

stock CreateCarDealership(Float: enx, Float: eny, Float: enz, Float: radius, price, type, message[])
{
	new dealershipid = GetFreeCarDealership();
	if(dealershipid == -1) return -1;
	new string[512];
	CarDealershipInfo[dealershipid][cdEntranceX] = enx;
	CarDealershipInfo[dealershipid][cdEntranceY] = eny;
	CarDealershipInfo[dealershipid][cdEntranceZ] = enz;
	CarDealershipInfo[dealershipid][cdRadius] = radius;
	CarDealershipInfo[dealershipid][cdPrice] = price;
	CarDealershipInfo[dealershipid][cdType] = type;
	strmid(CarDealershipInfo[dealershipid][cdMessage], message, 0, strlen(message), 255);
	CarDealershipInfo[dealershipid][cdPickupID] = CreateDynamicPickup(1239, 1, CarDealershipInfo[dealershipid][cdEntranceX], CarDealershipInfo[dealershipid][cdEntranceY], CarDealershipInfo[dealershipid][cdEntranceZ]);
	format(string, sizeof(string), "{FFFF00}ID: %d\n{ffffff}Type: {ffff00}%s\n{ffffff}dealership for sale\n{FFFFFF}Price: {00FF00}%s\n{ff0000}'/buydealership' to buy this dealership",dealershipid, RDT(dealershipid), FormatMoney(CarDealershipInfo[dealershipid][cdPrice]));
    CarDealershipInfo[dealershipid][cdTextLabel] = CreateDynamic3DTextLabel(string,-1,CarDealershipInfo[dealershipid][cdEntranceX], CarDealershipInfo[dealershipid][cdEntranceY], CarDealershipInfo[dealershipid][cdEntranceZ]+0.75,3.0,INVALID_PLAYER_ID,INVALID_VEHICLE_ID,1);
    SavecDealership(dealershipid);
    return dealershipid;
}
stock DestroyCarDealership(dealershipid)
{
	new string[30];
	CarDealershipInfo[dealershipid][cdEntranceX] = 0.0;
	CarDealershipInfo[dealershipid][cdEntranceY] = 0.0;
	CarDealershipInfo[dealershipid][cdEntranceZ] = 0.0;
	CarDealershipInfo[dealershipid][cdRadius] = 0.0;
	CarDealershipInfo[dealershipid][cdTill] = 0;
	CarDealershipInfo[dealershipid][cdOwned] = 0;
	CarDealershipInfo[dealershipid][cdPrice] = 0;
	CarDealershipInfo[dealershipid][cdType] = 0;
	format(string, sizeof(string), "None");
	strmid(CarDealershipInfo[dealershipid][cdOwner], string, 0, strlen(string), 255);
	format(string, sizeof(string), "None");
	strmid(CarDealershipInfo[dealershipid][cdMessage], string, 0, strlen(string), 255);
	DestroyDynamic3DTextLabel(CarDealershipInfo[dealershipid][cdTextLabel]);
	DestroyDynamicPickup(CarDealershipInfo[dealershipid][cdPickupID]);
	CarDealershipInfo[dealershipid][cdPickupID] = 0;
	CarDealershipInfo[dealershipid][cdTextLabel] = Text3D:INVALID_3DTEXT_ID;
	CarDealershipInfo[dealershipid][cdVehicleSpawn][0] = 0.0;
    CarDealershipInfo[dealershipid][cdVehicleSpawn][1] = 0.0;
    CarDealershipInfo[dealershipid][cdVehicleSpawn][2] = 0.0;
    CarDealershipInfo[dealershipid][cdVehicleSpawn][3] = 0.0;
	for(new v = 0; v < MAX_DEALERSHIPVEHICLES; v++)
	{
		if(CarDealershipInfo[dealershipid][cdVehicleModel][v] != 0)
		{
	        DestroyCarDealershipVehicle(dealershipid, v);
		}
	}
}
stock GetFreeCarDealership()
{
    new
		cid = 0;
	while (cid < MAX_CARDEALERSHIPS && CarDealershipInfo[cid][cdEntranceX] != 0.0 && CarDealershipInfo[cid][cdEntranceY] != 0.0)
	{
		cid++;
	}
	if(cid == MAX_CARDEALERSHIPS) return -1;
	return cid;

}
stock SetPlayerOwnerOfCD(playerid, dealershipid)
{
	new owner[MAX_PLAYER_NAME];
	CarDealershipInfo[dealershipid][cdOwned] = 1;
	GetPlayerName(playerid, owner, sizeof(owner));
	strmid(CarDealershipInfo[dealershipid][cdOwner], owner, 0, strlen(owner), 255);
	new string[512];
	format(string, sizeof(string), "ID: %d\n{FFFF00}Sponsored: %s\n{FFFFFF}Owner: {00FF00}%s",dealershipid, CarDealershipInfo[dealershipid][cdMessage], CarDealershipInfo[dealershipid][cdOwner]);
	UpdateDynamic3DTextLabelText(CarDealershipInfo[dealershipid][cdTextLabel], -1, string);
	SavecDealership(dealershipid);
}
stock SellCarDealership(dealershipid)
{
	CarDealershipInfo[dealershipid][cdOwned] = 0;
	CarDealershipInfo[dealershipid][cdVehicleSpawn][0] = 0.0;
	CarDealershipInfo[dealershipid][cdVehicleSpawn][1] = 0.0;
	CarDealershipInfo[dealershipid][cdVehicleSpawn][2] = 0.0;
	CarDealershipInfo[dealershipid][cdVehicleSpawn][3] = 0.0;
	strmid(CarDealershipInfo[dealershipid][cdOwner], "No-one", 0, MAX_PLAYER_NAME, 255);
	new string[1024];
	format(string, sizeof(string), "{FFFF00}ID: %d\n{ffffff}Type: {ffff00}%s\n{ffffff}dealership for sale\n{FFFFFF}Price: {00FF00}%s\n{ff0000}'/buydealership' to buy this dealership",dealershipid, RDT(dealershipid), FormatMoney(CarDealershipInfo[dealershipid][cdPrice]));
	//format(String, sizeof(String), "{00FFFF}[Car Dealership - ID:%d]\n{F81414}[Type:%s]\n{00ff00}this dealership for sale\n{FFFFFF}Price: {00FF00}%s\nuse '/buydealership' for purchase this dealer", dealershipid, RDT(dealershipid), FormatMoney(CarDealershipInfo[dealershipid][cdPrice]));
	UpdateDynamic3DTextLabelText(CarDealershipInfo[dealershipid][cdTextLabel], -1, string);
	SavecDealership(dealershipid);
}
stock IsPlayerOwnerOfCD(playerid)
{
	new owner[MAX_PLAYER_NAME];
	GetPlayerName(playerid, owner, sizeof(owner));
	foreach(new cid : CarDealership)
    {
	    if(Stringcmp(CarDealershipInfo[cid][cdOwner],owner, true ) == 0)
	    {
			return i;
		}
	}
	return -1;
}


stock IsPlayerOwnerOfCDEx(playerid, dealershipid)
{
	if(strcmp(CarDealershipInfo[dealershipid][cdOwner], pData[playerid][pName], true ) == 0)
	{
	    return 1;
	}
	return 0;
}
stock CreateCarDealershipVehicle(dealershipid, modelid, Float: x, Float: y, Float: z, Float: a, price)
{
    new cdvehicleid = GetFreeCarDealershipVehicleId(dealershipid);
    if(cdvehicleid == -1) return -1;
    new string[1024];
    CarDealershipInfo[dealershipid][cdVehicleModel][cdvehicleid] = modelid;
    CarDealershipInfo[dealershipid][cdVehicleCost][cdvehicleid] = price;
    CarDealershipInfo[dealershipid][cdVehicleSpawnX][cdvehicleid] = x;
    CarDealershipInfo[dealershipid][cdVehicleSpawnY][cdvehicleid] = y;
    CarDealershipInfo[dealershipid][cdVehicleSpawnZ][cdvehicleid] = z;
    CarDealershipInfo[dealershipid][cdVehicleSpawnAngle][cdvehicleid] = a;
    new carcreated = CreateVehicle(modelid, x, y, z, a, -1, -1, 6);
    format(string, sizeof(string), "ID: %d\n{FFFF00}%s\n{FFFFFF}Price: {00FF00}%s\n{ffff00}Health: {ffffff}1000.0\n{ffff00}Fuel: {ffffff}100.0",cdvehicleid, GetVehicleName(carcreated), FormatMoney(CarDealershipInfo[dealershipid][cdVehicleCost][cdvehicleid]));
    CarDealershipInfo[dealershipid][cdVehicleLabel][cdvehicleid] = CreateDynamic3DTextLabel(string,-1,0.0, 0.0, 0.0,5.0,INVALID_PLAYER_ID,carcreated,1);
	CarDealershipInfo[dealershipid][cdVehicleId][cdvehicleid] = carcreated;
	SavecDealership(cdvehicleid);
    return cdvehicleid;
}
stock DestroyCarDealershipVehicle(dealershipid, cdvehicleid)
{
    CarDealershipInfo[dealershipid][cdVehicleModel][cdvehicleid] = 0;
    CarDealershipInfo[dealershipid][cdVehicleCost][cdvehicleid] = 0;
    CarDealershipInfo[dealershipid][cdVehicleSpawnX][cdvehicleid] = 0.0;
    CarDealershipInfo[dealershipid][cdVehicleSpawnY][cdvehicleid] = 0.0;
    CarDealershipInfo[dealershipid][cdVehicleSpawnZ][cdvehicleid] = 0.0;
    CarDealershipInfo[dealershipid][cdVehicleSpawnAngle][cdvehicleid] = 0.0;
    DestroyDynamic3DTextLabel(CarDealershipInfo[dealershipid][cdVehicleLabel][cdvehicleid]);
    DestroyVehicle(CarDealershipInfo[dealershipid][cdVehicleId][cdvehicleid]);
    CarDealershipInfo[dealershipid][cdVehicleLabel][cdvehicleid] = Text3D:INVALID_3DTEXT_ID;
    CarDealershipInfo[dealershipid][cdVehicleId][cdvehicleid] = 0;
}
stock GetFreeCarDealershipVehicleId(dealershipid)
{
    new
		i = 0;
	while (i < MAX_DEALERSHIPVEHICLES && CarDealershipInfo[dealershipid][cdVehicleModel][i] != 0)
	{
		i++;
	}
	if(i == MAX_DEALERSHIPVEHICLES) return -1;
	return i;

}

stock GetCarDealershipVehicleId(vehicleid)
{
    foreach(new cid : CarDealership)
    {
        for(new v = 0; v < MAX_DEALERSHIPVEHICLES; v++)
        {
            if(CarDealershipInfo[cid][cdVehicleId][v] == vehicleid)
            {
                return v;
            }
		}
    }
    return -1;
}
stock GetCarDealershipId(vehicleid)
{
    foreach(new cid : CarDealership)
    {
        for(new v = 0; v < MAX_DEALERSHIPVEHICLES; v++)
        {
            if(CarDealershipInfo[cid][cdVehicleId][v] == vehicleid)
            {
                return cid;
            }
		}
    }
    return -1;
}

stock RDT(id)
{
	new dealertype[128];
	if(CarDealershipInfo[id][cdType] > 0)
	{
  		if(CarDealershipInfo[id][cdType] == 1) format(dealertype, 128, "Motorcycle");
  		if(CarDealershipInfo[id][cdType] == 3) format(dealertype, 128, "Job Cars");
  		if(CarDealershipInfo[id][cdType] == 3) format(dealertype, 128, "Cars");
  		/*if(CarDealershipInfo[id][cdType] == 4) format(dealertype, 128, "Lowriders");
  		if(CarDealershipInfo[id][cdType] == 3) format(dealertype, 128, "Saloons");
  		if(CarDealershipInfo[id][cdType] == 6) format(dealertype, 128, "Sport");
  		if(CarDealershipInfo[id][cdType] == 7) format(dealertype, 128, "Boat");*/
	}
	else
	{
        format(dealertype, 128, "Unknown");
	}
	return dealertype;
}


SavecDealership(dealershipid)
{
	new query[12080];
	mysql_format(g_SQL, query, sizeof(query), "UPDATE `dealership` SET ");
	mysql_format(g_SQL, query, sizeof(query), "%s`owned` = '%d', ", query, CarDealershipInfo[dealershipid][cdOwned]);
	mysql_format(g_SQL, query, sizeof(query), "%s`owner` = '%s', ", query, CarDealershipInfo[dealershipid][cdOwner]);

	mysql_format(g_SQL, query, sizeof(query), "%s`entrance_x` = '%f', ", query, CarDealershipInfo[dealershipid][cdEntranceX]);
	mysql_format(g_SQL, query, sizeof(query), "%s`entrance_y` = '%f', ", query, CarDealershipInfo[dealershipid][cdEntranceY]);
	mysql_format(g_SQL, query, sizeof(query), "%s`entrance_z` = '%f', ", query, CarDealershipInfo[dealershipid][cdEntranceZ]);

	mysql_format(g_SQL, query, sizeof(query), "%s`exit_x` = '%f', ", query, CarDealershipInfo[dealershipid][cdExitX]);
	mysql_format(g_SQL, query, sizeof(query), "%s`exit_y` = '%f', ", query, CarDealershipInfo[dealershipid][cdExitY]);
	mysql_format(g_SQL, query, sizeof(query), "%s`exit_z` = '%f', ", query, CarDealershipInfo[dealershipid][cdExitZ]);

	mysql_format(g_SQL, query, sizeof(query), "%s`message` = '%s', ", query, CarDealershipInfo[dealershipid][cdMessage]);
	mysql_format(g_SQL, query, sizeof(query), "%s`till` = '%d', ", query, CarDealershipInfo[dealershipid][cdTill]);
	mysql_format(g_SQL, query, sizeof(query), "%s`interior` = '%d', ", query, CarDealershipInfo[dealershipid][cdInterior]);
	mysql_format(g_SQL, query, sizeof(query), "%s`type` = '%d', ", query, CarDealershipInfo[dealershipid][cdType]);

	mysql_format(g_SQL, query, sizeof(query), "%s`vehicle_spawnx` = '%f', ", query, CarDealershipInfo[dealershipid][cdVehicleSpawn][0]);
	mysql_format(g_SQL, query, sizeof(query), "%s`vehicle_spawny` = '%f', ", query, CarDealershipInfo[dealershipid][cdVehicleSpawn][1]);
	mysql_format(g_SQL, query, sizeof(query), "%s`vehicle_spawnz` = '%f', ", query, CarDealershipInfo[dealershipid][cdVehicleSpawn][2]);
	mysql_format(g_SQL, query, sizeof(query), "%s`vehicle_spawna` = '%f', ", query, CarDealershipInfo[dealershipid][cdVehicleSpawn][3]);

	mysql_format(g_SQL, query, sizeof(query), "%s`buyspawnx0` = '%f', ", query, CarDealershipInfo[dealershipid][cdVehicleSpawnX][0]);
	mysql_format(g_SQL, query, sizeof(query), "%s`buyspawny0` = '%f', ", query, CarDealershipInfo[dealershipid][cdVehicleSpawnY][0]);
	mysql_format(g_SQL, query, sizeof(query), "%s`buyspawnz0` = '%f', ", query, CarDealershipInfo[dealershipid][cdVehicleSpawnZ][0]);
	mysql_format(g_SQL, query, sizeof(query), "%s`buyspawnangle0` = '%f', ", query, CarDealershipInfo[dealershipid][cdVehicleSpawnAngle][0]);
	mysql_format(g_SQL, query, sizeof(query), "%s`buyspawnx1` = '%f', ", query, CarDealershipInfo[dealershipid][cdVehicleSpawnX][1]);
	mysql_format(g_SQL, query, sizeof(query), "%s`buyspawny1` = '%f', ", query, CarDealershipInfo[dealershipid][cdVehicleSpawnY][1]);
	mysql_format(g_SQL, query, sizeof(query), "%s`buyspawnz1` = '%f', ", query, CarDealershipInfo[dealershipid][cdVehicleSpawnZ][1]);
	mysql_format(g_SQL, query, sizeof(query), "%s`buyspawnangle1` = '%f', ", query, CarDealershipInfo[dealershipid][cdVehicleSpawnAngle][1]);
	mysql_format(g_SQL, query, sizeof(query), "%s`buyspawnx2` = '%f', ", query, CarDealershipInfo[dealershipid][cdVehicleSpawnX][2]);
	mysql_format(g_SQL, query, sizeof(query), "%s`buyspawny2` = '%f', ", query, CarDealershipInfo[dealershipid][cdVehicleSpawnY][2]);
	mysql_format(g_SQL, query, sizeof(query), "%s`buyspawnz2` = '%f', ", query, CarDealershipInfo[dealershipid][cdVehicleSpawnZ][2]);
	mysql_format(g_SQL, query, sizeof(query), "%s`buyspawnangle2` = '%f', ", query, CarDealershipInfo[dealershipid][cdVehicleSpawnAngle][2]);
	mysql_format(g_SQL, query, sizeof(query), "%s`buyspawnx3` = '%f', ", query, CarDealershipInfo[dealershipid][cdVehicleSpawnX][3]);
	mysql_format(g_SQL, query, sizeof(query), "%s`buyspawny3` = '%f', ", query, CarDealershipInfo[dealershipid][cdVehicleSpawnY][3]);
	mysql_format(g_SQL, query, sizeof(query), "%s`buyspawnz3` = '%f', ", query, CarDealershipInfo[dealershipid][cdVehicleSpawnZ][3]);
	mysql_format(g_SQL, query, sizeof(query), "%s`buyspawnangle3` = '%f', ", query, CarDealershipInfo[dealershipid][cdVehicleSpawnAngle][3]);
	mysql_format(g_SQL, query, sizeof(query), "%s`buyspawnx4` = '%f', ", query, CarDealershipInfo[dealershipid][cdVehicleSpawnX][4]);
	mysql_format(g_SQL, query, sizeof(query), "%s`buyspawny4` = '%f', ", query, CarDealershipInfo[dealershipid][cdVehicleSpawnY][4]);
	mysql_format(g_SQL, query, sizeof(query), "%s`buyspawnz4` = '%f', ", query, CarDealershipInfo[dealershipid][cdVehicleSpawnZ][4]);
	mysql_format(g_SQL, query, sizeof(query), "%s`buyspawnangle4` = '%f', ", query, CarDealershipInfo[dealershipid][cdVehicleSpawnAngle][4]);
	mysql_format(g_SQL, query, sizeof(query), "%s`buyspawnx5` = '%f', ", query, CarDealershipInfo[dealershipid][cdVehicleSpawnX][5]);
	mysql_format(g_SQL, query, sizeof(query), "%s`buyspawny5` = '%f', ", query, CarDealershipInfo[dealershipid][cdVehicleSpawnY][5]);
	mysql_format(g_SQL, query, sizeof(query), "%s`buyspawnz5` = '%f', ", query, CarDealershipInfo[dealershipid][cdVehicleSpawnZ][5]);
	mysql_format(g_SQL, query, sizeof(query), "%s`buyspawnangle5` = '%f', ", query, CarDealershipInfo[dealershipid][cdVehicleSpawnAngle][5]);
	mysql_format(g_SQL, query, sizeof(query), "%s`buyspawnx6` = '%f', ", query, CarDealershipInfo[dealershipid][cdVehicleSpawnX][6]);
	mysql_format(g_SQL, query, sizeof(query), "%s`buyspawny6` = '%f', ", query, CarDealershipInfo[dealershipid][cdVehicleSpawnY][6]);
	mysql_format(g_SQL, query, sizeof(query), "%s`buyspawnz6` = '%f', ", query, CarDealershipInfo[dealershipid][cdVehicleSpawnZ][6]);
	mysql_format(g_SQL, query, sizeof(query), "%s`buyspawnangle6` = '%f', ", query, CarDealershipInfo[dealershipid][cdVehicleSpawnAngle][6]);
	mysql_format(g_SQL, query, sizeof(query), "%s`buyspawnx7` = '%f', ", query, CarDealershipInfo[dealershipid][cdVehicleSpawnX][7]);
	mysql_format(g_SQL, query, sizeof(query), "%s`buyspawny7` = '%f', ", query, CarDealershipInfo[dealershipid][cdVehicleSpawnY][7]);
	mysql_format(g_SQL, query, sizeof(query), "%s`buyspawnz7` = '%f', ", query, CarDealershipInfo[dealershipid][cdVehicleSpawnZ][7]);
	mysql_format(g_SQL, query, sizeof(query), "%s`buyspawnangle7` = '%f', ", query, CarDealershipInfo[dealershipid][cdVehicleSpawnAngle][7]);
	mysql_format(g_SQL, query, sizeof(query), "%s`buyspawnx8` = '%f', ", query, CarDealershipInfo[dealershipid][cdVehicleSpawnX][8]);
	mysql_format(g_SQL, query, sizeof(query), "%s`buyspawny8` = '%f', ", query, CarDealershipInfo[dealershipid][cdVehicleSpawnY][8]);
	mysql_format(g_SQL, query, sizeof(query), "%s`buyspawnz8` = '%f', ", query, CarDealershipInfo[dealershipid][cdVehicleSpawnZ][8]);
	mysql_format(g_SQL, query, sizeof(query), "%s`buyspawnangle8` = '%f', ", query, CarDealershipInfo[dealershipid][cdVehicleSpawnAngle][8]);
	mysql_format(g_SQL, query, sizeof(query), "%s`buyspawnx9` = '%f', ", query, CarDealershipInfo[dealershipid][cdVehicleSpawnX][9]);
	mysql_format(g_SQL, query, sizeof(query), "%s`buyspawny9` = '%f', ", query, CarDealershipInfo[dealershipid][cdVehicleSpawnY][9]);
	mysql_format(g_SQL, query, sizeof(query), "%s`buyspawnz9` = '%f', ", query, CarDealershipInfo[dealershipid][cdVehicleSpawnZ][9]);
	mysql_format(g_SQL, query, sizeof(query), "%s`buyspawnangle9` = '%f', ", query, CarDealershipInfo[dealershipid][cdVehicleSpawnAngle][9]);

	mysql_format(g_SQL, query, sizeof(query), "%s`vehiclecost0` = '%d', ", query, CarDealershipInfo[dealershipid][cdVehicleCost][0]);
	mysql_format(g_SQL, query, sizeof(query), "%s`vehicletype0` = '%d', ", query, CarDealershipInfo[dealershipid][cdVehicleModel][0]);
	mysql_format(g_SQL, query, sizeof(query), "%s`vehiclecost1` = '%d', ", query, CarDealershipInfo[dealershipid][cdVehicleCost][1]);
	mysql_format(g_SQL, query, sizeof(query), "%s`vehicletype1` = '%d', ", query, CarDealershipInfo[dealershipid][cdVehicleModel][1]);
	mysql_format(g_SQL, query, sizeof(query), "%s`vehiclecost2` = '%d', ", query, CarDealershipInfo[dealershipid][cdVehicleCost][2]);
	mysql_format(g_SQL, query, sizeof(query), "%s`vehicletype2` = '%d', ", query, CarDealershipInfo[dealershipid][cdVehicleModel][2]);
	mysql_format(g_SQL, query, sizeof(query), "%s`vehiclecost3` = '%d', ", query, CarDealershipInfo[dealershipid][cdVehicleCost][3]);
	mysql_format(g_SQL, query, sizeof(query), "%s`vehicletype3` = '%d', ", query, CarDealershipInfo[dealershipid][cdVehicleModel][3]);
	mysql_format(g_SQL, query, sizeof(query), "%s`vehiclecost4` = '%d', ", query, CarDealershipInfo[dealershipid][cdVehicleCost][4]);
	mysql_format(g_SQL, query, sizeof(query), "%s`vehicletype4` = '%d', ", query, CarDealershipInfo[dealershipid][cdVehicleModel][4]);
	mysql_format(g_SQL, query, sizeof(query), "%s`vehiclecost5` = '%d', ", query, CarDealershipInfo[dealershipid][cdVehicleCost][5]);
	mysql_format(g_SQL, query, sizeof(query), "%s`vehicletype5` = '%d', ", query, CarDealershipInfo[dealershipid][cdVehicleModel][5]);
	mysql_format(g_SQL, query, sizeof(query), "%s`vehiclecost6` = '%d', ", query, CarDealershipInfo[dealershipid][cdVehicleCost][6]);
	mysql_format(g_SQL, query, sizeof(query), "%s`vehicletype6` = '%d', ", query, CarDealershipInfo[dealershipid][cdVehicleModel][6]);
	mysql_format(g_SQL, query, sizeof(query), "%s`vehiclecost7` = '%d', ", query, CarDealershipInfo[dealershipid][cdVehicleCost][7]);
	mysql_format(g_SQL, query, sizeof(query), "%s`vehicletype7` = '%d', ", query, CarDealershipInfo[dealershipid][cdVehicleModel][7]);
	mysql_format(g_SQL, query, sizeof(query), "%s`vehiclecost8` = '%d', ", query, CarDealershipInfo[dealershipid][cdVehicleCost][8]);
	mysql_format(g_SQL, query, sizeof(query), "%s`vehicletype8` = '%d', ", query, CarDealershipInfo[dealershipid][cdVehicleModel][8]);
	mysql_format(g_SQL, query, sizeof(query), "%s`vehiclecost9` = '%d', ", query, CarDealershipInfo[dealershipid][cdVehicleCost][9]);
	mysql_format(g_SQL, query, sizeof(query), "%s`vehicletype9` = '%d', ", query, CarDealershipInfo[dealershipid][cdVehicleModel][9]);

	mysql_format(g_SQL, query, sizeof(query), "%s`radius` = '%f', ", query, CarDealershipInfo[dealershipid][cdRadius]);
	mysql_format(g_SQL, query, sizeof(query), "%s`price` = '%d' WHERE `id` = '%d' ", query, CarDealershipInfo[dealershipid][cdPrice], dealershipid);

	mysql_tquery(g_SQL, query);


	DealershipRefresh(dealershipid);
	printf("Car Dealership ID - %d saved successfully", dealershipid);

	return 1;
}


CMD:deletedealership(playerid, params[])
{

    if(pData[playerid][pAdmin] < 7)
        return PermissionError(playerid);
    extract params -> new dealershipid; else return Usage(playerid, "/deletedealership [dealership id]");

    if(dealershipid > MAX_CARDEALERSHIPS) return Error(playerid, "Wrong Dealership ID");
    if(dealershipid < 0) return Error(playerid, "Wrong Dealership ID");

	DestroyCarDealership(dealershipid);
	new query[1280];
	Servers(playerid, "Car Dealership deleted with ID %d.", dealershipid);
	Iter_Remove(CarDealership, dealershipid);
	mysql_format(g_SQL, query, sizeof(query), "DELETE FROM dealership WHERE id=%d", dealershipid);
	mysql_tquery(g_SQL, query);
    return 1;
}

CMD:editcar(playerid, params[])
{
    if(pData[playerid][pAdmin] < 7)
        return PermissionError(playerid);
    new vehicleid = GetPlayerVehicleID(playerid);
    new v, i;
    v = GetCarDealershipVehicleId(vehicleid);
    i = GetCarDealershipId(vehicleid);
    if(!IsPlayerInAnyVehicle(playerid)) return Error(playerid, "You are not in any car.");
    if(v != -1 && i != -1)
	{
        if(IsPlayerOwnerOfCDEx(playerid, i))
		{
            SetPVarInt(playerid, "editingcd", i);
            SetPVarInt(playerid, "editingcdveh", v);
            SetPVarInt(playerid, "editingcdvehpos", 0);
            SetPVarInt(playerid, "editingcdvehnew", 0);
            new listitems[] = "1 Edit Model\n2 Edit Cost\n3 Edit Park\n4 Delete Vehicle";
            ShowPlayerDialog(playerid, DIALOG_CDEDITONE,DIALOG_STYLE_LIST,"Car Dealership:", listitems,"Select","Cancel");
            return 1;
        }
        else
		{
            Error(playerid, "You do not own that Car Dealership.");
        }
    }
    else
	{
        Error(playerid, "Car is not part of a Car Dealership.");
    }
    return 1;
}


CMD:createcdveh(playerid, params[])
{
    if(pData[playerid][pAdmin] < 7)
        return PermissionError(playerid);
    new price, dealershipid, modelid;
    if(sscanf(params, "ddd", price, dealershipid, modelid)) return SendClientMessageEx(playerid, COLOR_WHITE, "USAGE: /createcdveh [price] [dealership] [modelid]");

    new Float:X,Float:Y,Float:Z,Float:A;
    GetPlayerPos(playerid,X,Y,Z);
    GetPlayerFacingAngle(playerid, A);
    new cdvehicleid = CreateCarDealershipVehicle(dealershipid, modelid, X, Y, Z, A, price);
    if(cdvehicleid == -1)
	{
        Error(playerid, "cdVehicles limit reached.");
    }
    else
	{
        Servers(playerid, "Car Dealership Vehicle created with ID %d.", cdvehicleid);

    }
    return 1;
}

CMD:deletedealershipveh(playerid, params[])
{
    if(pData[playerid][pAdmin] < 7)
        return PermissionError(playerid);

    new vehid;
    if(sscanf(params, "d", vehid)) return Usage(playerid, "/deletedealersipveh [vehicleid]");
    DestroyCarDealershipVehicle(GetCarDealershipId(vehid), GetCarDealershipVehicleId(vehid));
    //SavecDealership(GetCarDealershipId(vehid));
    Servers(playerid, "Car Dealership Vehicle deleted with ID %d.", vehid);
    return 1;
}

CMD:createdealership(playerid, params[])
{
    if(pData[playerid][pAdmin] < 7)
        return PermissionError(playerid);

    new cid = Iter_Free(CarDealership);
    new Cache:result;
    new price, type, radius, message[64];
    if(sscanf(params, "ddds[64]", price, type, radius, message))
	{
		Usage(playerid, "/createdealership [price] [type] [radius] [message]");
		Servers(playerid, "1 Bike | 2 Cars Job | 3 Caes");
		return 1;
	}
    new Float:X,Float:Y,Float:Z;
    format(CarDealershipInfo[cid][cdMessage], 567, "%s", message);
    GetPlayerPos(playerid,X,Y,Z);
    new fmt_text[1280];
	format
	(
		fmt_text, sizeof fmt_text,
		"INSERT INTO dealership \
		(id, owned, entrance_x, entrance_y, entrance_z, price)\
		VALUES ('%d', '0', '%f', '%f', '%f', '%d')",
		cid,
		X,
		Y,
		Z,
		price
	);

	result = mysql_query(g_SQL, fmt_text, true);

	cache_delete(result);

    new dealershipid = CreateCarDealership(X, Y, Z, radius, price, type, message);
    Iter_Add(CarDealership, cid);
    if(dealershipid == -1)
	{
        Error(playerid, "Car Dealerships limit reached.");
    }
    else
	{
        Servers(playerid, "Car Dealership created with ID %d.", dealershipid);
	}
    return 1;
}

CMD:checkvehdealership(playerid, params[])
{
    foreach(new cid : CarDealership)
	{
        if(IsPlayerInRangeOfPoint(playerid, CarDealershipInfo[cid][cdRadius], CarDealershipInfo[cid][cdEntranceX], CarDealershipInfo[cid][cdEntranceY], CarDealershipInfo[cid][cdEntranceZ])) {
            if(IsPlayerOwnerOfCDEx(playerid, cid))
			{
			    new string[2500];
			    if(CarDealershipInfo[cid][cdType] == 1)
			    {
				    strcat(string, "{FFFFFF}_____________________________________________________________\n");
					strcat(string, "{FFFF00}Vehicle ID(461)\t{ffffff}Vehicle Name: PCJ-600\n");
					strcat(string, "{FFFF00}Vehicle ID(462)\t{ffffff}Vehicle Name: Faggio\n");
					strcat(string, "{FFFF00}Vehicle ID(463)\t{ffffff}Vehicle Name: Freeway\n");
					strcat(string, "{FFFF00}Vehicle ID(468)\t{ffffff}Vehicle Name: Sanchez\n");
					strcat(string, "{FFFF00}Vehicle ID(481)\t{ffffff}Vehicle Name: BMX\n");
					strcat(string, "{FFFF00}Vehicle ID(509)\t{ffffff}Vehicle Name: Bike\n");
					strcat(string, "{FFFF00}Vehicle ID(510)\t{ffffff}Vehicle Name: Mountain Bike\n");
					strcat(string, "{FFFF00}Vehicle ID(521)\t{ffffff}Vehicle Name: FCR-900\n");
					strcat(string, "{FFFF00}Vehicle ID(522)\t{ffffff}Vehicle Name: NRG-500\n");
					strcat(string, "{FFFF00}Vehicle ID(581)\t{ffffff}Vehicle Name: BF-400\n");
					strcat(string, "{FFFF00}Vehicle ID(586)\t{ffffff}Vehicle Name: Wayfarer\n");
					strcat(string, "{FFFFFF}_____________________________________________________________");
					ShowPlayerDialog(playerid, 0, DIALOG_STYLE_MSGBOX, "{FFFFFF}Type Vehicle To Your Dealer", string,"Ok", "");
					return 1;
				}
				else if(CarDealershipInfo[cid][cdType] == 3)
			    {
				    strcat(string, "{FFFFFF}_____________________________________________________________\n");
					strcat(string, "{FFFF00}Vehicle ID(413)\t{ffffff}Vehicle Name: Pony\n");
					strcat(string, "{FFFF00}Vehicle ID(482)\t{ffffff}Vehicle Name: Burrito\n");
					strcat(string, "{FFFF00}Vehicle ID(400)\t{ffffff}Vehicle Name: Landstalker\n");
					strcat(string, "{FFFF00}Vehicle ID(579)\t{ffffff}Vehicle Name: Huntley\n");
					strcat(string, "{FFFF00}Vehicle ID(500)\t{ffffff}Vehicle Name: Mesa\n");
					strcat(string, "{FFFF00}Vehicle ID(404)\t{ffffff}Vehicle Name: Perenniel\n");
					strcat(string, "{FFFF00}Vehicle ID(418)\t{ffffff}Vehicle Name: Moonbeam\n");
					strcat(string, "{FFFF00}Vehicle ID(458)\t{ffffff}Vehicle Name: Solair\n");
					strcat(string, "{FFFF00}Vehicle ID(479)\t{ffffff}Vehicle Name: Regina\n");
					strcat(string, "{FFFF00}Vehicle ID(561)\t{ffffff}Vehicle Name: Stratum\n");
					strcat(string, "{FFFF00}Vehicle ID(483)\t{ffffff}Vehicle Name: Camper\n");
					strcat(string, "{FFFFFF}_____________________________________________________________");
					ShowPlayerDialog(playerid, 0, DIALOG_STYLE_MSGBOX, "{FFFFFF}Type Vehicle To Your Dealer", string,"Ok", "");
					return 1;
				}
				else if(CarDealershipInfo[cid][cdType] == 3)
			    {
				    strcat(string, "{FFFFFF}_____________________________________________________________\n");
					strcat(string, "{FFFF00}Vehicle ID(600)\t{ffffff}Vehicle Name: Picador\n");
					strcat(string, "{FFFF00}Vehicle ID(554)\t{ffffff}Vehicle Name: YoErrorite\n");
					strcat(string, "{FFFF00}Vehicle ID(543)\t{ffffff}Vehicle Name: Sadler\n");
					strcat(string, "{FFFF00}Vehicle ID(478)\t{ffffff}Vehicle Name: Walton\n");
					strcat(string, "{FFFF00}Vehicle ID(422)\t{ffffff}Vehicle Name: Bobcat\n");
					strcat(string, "{FFFF00}Vehicle ID(525)\t{ffffff}Vehicle Name: Tow Truck\n");
					strcat(string, "{FFFFFF}_____________________________________________________________");
					ShowPlayerDialog(playerid, 0, DIALOG_STYLE_MSGBOX, "{FFFFFF}Type Vehicle To Your Dealer", string,"Ok", "");
					return 1;
				}
				else if(CarDealershipInfo[cid][cdType] == 4)
			    {
				    strcat(string, "{FFFFFF}_____________________________________________________________\n");
					strcat(string, "{FFFF00}Vehicle ID(412)\t{ffffff}Vehicle Name: Voodoo\n");
					strcat(string, "{FFFF00}Vehicle ID(534)\t{ffffff}Vehicle Name: Remington\n");
					strcat(string, "{FFFF00}Vehicle ID(535)\t{ffffff}Vehicle Name: Slamvan\n");
					strcat(string, "{FFFF00}Vehicle ID(536)\t{ffffff}Vehicle Name: Blade\n");
					strcat(string, "{FFFF00}Vehicle ID(567)\t{ffffff}Vehicle Name: Savanna\n");
					strcat(string, "{FFFF00}Vehicle ID(575)\t{ffffff}Vehicle Name: Broadway\n");
					strcat(string, "{FFFF00}Vehicle ID(576)\t{ffffff}Vehicle Name: Tornado\n");
					strcat(string, "{FFFFFF}_____________________________________________________________");
					ShowPlayerDialog(playerid, 0, DIALOG_STYLE_MSGBOX, "{FFFFFF}Type Vehicle To Your Dealer", string,"Ok", "");
					return 1;
				}
				else if(CarDealershipInfo[cid][cdType] == 3)
			    {
				    strcat(string, "{FFFFFF}_____________________________________________________________\n");
					strcat(string, "{FFFF00}Vehicle ID(401)\t{ffffff}Vehicle Name: Bravura\n");
					strcat(string, "{FFFF00}Vehicle ID(405)\t{ffffff}Vehicle Name: Sentinel\n");
					strcat(string, "{FFFF00}Vehicle ID(410)\t{ffffff}Vehicle Name: Manana\n");
					strcat(string, "{FFFF00}Vehicle ID(419)\t{ffffff}Vehicle Name: Esperanto\n");
					strcat(string, "{FFFF00}Vehicle ID(421)\t{ffffff}Vehicle Name: Washington\n");
					strcat(string, "{FFFF00}Vehicle ID(426)\t{ffffff}Vehicle Name: Premier\n");
					strcat(string, "{FFFF00}Vehicle ID(436)\t{ffffff}Vehicle Name: Previon\n");
					strcat(string, "{FFFF00}Vehicle ID(445)\t{ffffff}Vehicle Name: Admiral\n");
					strcat(string, "{FFFF00}Vehicle ID(466)\t{ffffff}Vehicle Name: Glendale\n");
					strcat(string, "{FFFF00}Vehicle ID(467)\t{ffffff}Vehicle Name: Oceanic\n");
					strcat(string, "{FFFF00}Vehicle ID(474)\t{ffffff}Vehicle Name: Hermes\n");
					strcat(string, "{FFFF00}Vehicle ID(491)\t{ffffff}Vehicle Name: Virgo\n");
					strcat(string, "{FFFF00}Vehicle ID(492)\t{ffffff}Vehicle Name: Greenwood\n");
					strcat(string, "{FFFF00}Vehicle ID(507)\t{ffffff}Vehicle Name: Elegant\n");
					strcat(string, "{FFFF00}Vehicle ID(516)\t{ffffff}Vehicle Name: Nebula\n");
					strcat(string, "{FFFF00}Vehicle ID(517)\t{ffffff}Vehicle Name: Majestic\n");
					strcat(string, "{FFFF00}Vehicle ID(518)\t{ffffff}Vehicle Name: Buccaneer\n");
					strcat(string, "{FFFF00}Vehicle ID(526)\t{ffffff}Vehicle Name: Fortune\n");
					strcat(string, "{FFFF00}Vehicle ID(527)\t{ffffff}Vehicle Name: Cadrona\n");
					strcat(string, "{FFFF00}Vehicle ID(529)\t{ffffff}Vehicle Name: Willard\n");
					strcat(string, "{FFFF00}Vehicle ID(540)\t{ffffff}Vehicle Name: Vincent\n");
					strcat(string, "{FFFF00}Vehicle ID(542)\t{ffffff}Vehicle Name: Clover\n");
					strcat(string, "{FFFF00}Vehicle ID(546)\t{ffffff}Vehicle Name: Intruder\n");
					strcat(string, "{FFFF00}Vehicle ID(547)\t{ffffff}Vehicle Name: Primo\n");
					strcat(string, "{FFFF00}Vehicle ID(549)\t{ffffff}Vehicle Name: Tampa\n");
					strcat(string, "{FFFF00}Vehicle ID(550)\t{ffffff}Vehicle Name: Sunrise\n");
					strcat(string, "{FFFF00}Vehicle ID(551)\t{ffffff}Vehicle Name: Merit\n");
					strcat(string, "{FFFF00}Vehicle ID(560)\t{ffffff}Vehicle Name: Sultan\n");
					strcat(string, "{FFFF00}Vehicle ID(562)\t{ffffff}Vehicle Name: Elegy\n");
					strcat(string, "{FFFF00}Vehicle ID(585)\t{ffffff}Vehicle Name: Emperor\n");
					strcat(string, "{FFFFFF}_____________________________________________________________");
					ShowPlayerDialog(playerid, 0, DIALOG_STYLE_MSGBOX, "{FFFFFF}Type Vehicle To Your Dealer", string,"Ok", "");
					return 1;
				}
				else if(CarDealershipInfo[cid][cdType] == 6)
			    {
					strcat(string, "{FFFFFF}_____________________________________________________________\n");
					strcat(string, "{FFFF00}Vehicle ID(402)\t{ffffff}Vehicle Name: Buffalo\n");
					strcat(string, "{FFFF00}Vehicle ID(415)\t{ffffff}Vehicle Name: Cheetah\n");
					strcat(string, "{FFFF00}Vehicle ID(429)\t{ffffff}Vehicle Name: Banshee\n");
					strcat(string, "{FFFF00}Vehicle ID(475)\t{ffffff}Vehicle Name: Sabre\n");
					strcat(string, "{FFFF00}Vehicle ID(477)\t{ffffff}Vehicle Name: ZR-350\n");
					strcat(string, "{FFFF00}Vehicle ID(496)\t{ffffff}Vehicle Name: Blista Compact\n");
					strcat(string, "{FFFF00}Vehicle ID(541)\t{ffffff}Vehicle Name: Bullet\n");
					strcat(string, "{FFFF00}Vehicle ID(558)\t{ffffff}Vehicle Name: Uranus\n");
					strcat(string, "{FFFF00}Vehicle ID(559)\t{ffffff}Vehicle Name: Jester\n");
					strcat(string, "{FFFF00}Vehicle ID(565)\t{ffffff}Vehicle Name: Flash\n");
					strcat(string, "{FFFF00}Vehicle ID(587)\t{ffffff}Vehicle Name: Euros\n");
					strcat(string, "{FFFF00}Vehicle ID(589)\t{ffffff}Vehicle Name: Club\n");
					strcat(string, "{FFFF00}Vehicle ID(602)\t{ffffff}Vehicle Name: Alpha\n");
					strcat(string, "{FFFFFF}_____________________________________________________________");
					ShowPlayerDialog(playerid, 0, DIALOG_STYLE_MSGBOX, "{FFFFFF}Type Vehicle To Your Dealer", string,"Ok", "");
					return 1;
				}
				else if(CarDealershipInfo[cid][cdType] == 7)
			    {
					strcat(string, "{FFFFFF}_____________________________________________________________\n");
					strcat(string, "{FFFF00}Vehicle ID(446)\t{ffffff}Vehicle Name: Squalo\n");
					strcat(string, "{FFFF00}Vehicle ID(453)\t{ffffff}Vehicle Name: Reefer\n");
					strcat(string, "{FFFF00}Vehicle ID(454)\t{ffffff}Vehicle Name: Tropic\n");
					strcat(string, "{FFFF00}Vehicle ID(473)\t{ffffff}Vehicle Name: Dinghy\n");
					strcat(string, "{FFFF00}Vehicle ID(484)\t{ffffff}Vehicle Name: Marquis\n");
					strcat(string, "{FFFF00}Vehicle ID(493)\t{ffffff}Vehicle Name: Jetmax\n");
					strcat(string, "{FFFFFF}_____________________________________________________________");
					ShowPlayerDialog(playerid, 0, DIALOG_STYLE_MSGBOX, "{FFFFFF}Type Vehicle To Your Dealer", string,"Ok", "");
					return 1;
				}
				else
				{
				    Error(playerid, "This type of dealership is unknown");
				    return 1;
				}
			}
            else
			{
                Error(playerid, "You do not own that Car Dealership.");
                return 1;
            }
        }
    }
    Error(playerid, "You must be standing inside the radius of the Car Dealership.");
    return 1;
}


CMD:dealership(playerid, params[])
{
    foreach(new cid : CarDealership)
    {
        if(IsPlayerInRangeOfPoint(playerid, CarDealershipInfo[cid][cdRadius], CarDealershipInfo[cid][cdEntranceX], CarDealershipInfo[cid][cdEntranceY], CarDealershipInfo[cid][cdEntranceZ])) {
            if(IsPlayerOwnerOfCDEx(playerid, cid))
            {
                SetPVarInt(playerid, "editingcd", cid);
                SetPVarInt(playerid, "editingcdveh", -1);
                SetPVarInt(playerid, "editingcdvehpos", 0);
                SetPVarInt(playerid, "editingcdvehnew", 0);
                new listitems[] = "Buy Vehicles\nDealership Vehicles\nEdit Vehicle Dealership\nDealership Money\nCheck Vehicles ID";
                ShowPlayerDialog(playerid, DIALOG_CDEDIT, DIALOG_STYLE_LIST,"Choose an item to continue", listitems,"Select","Cancel");
                return 1;
            }
            else
            {
                Error(playerid, "You do not own that Car Dealership.");
                return 1;
            }
        }
    }
    Error(playerid, "You must be standing inside the radius of the Car Dealership.");
    return 1;
}


CMD:buydealership(playerid, params[])
{
    foreach(new cid : CarDealership)
    {
        if(IsPlayerInRangeOfPoint(playerid, 5.0, CarDealershipInfo[cid][cdEntranceX], CarDealershipInfo[cid][cdEntranceY], CarDealershipInfo[cid][cdEntranceZ]))
        {
            if(CarDealershipInfo[cid][cdOwned] == 0)
            {
                if(GetPlayerMoney(playerid) < CarDealershipInfo[cid][cdPrice]) return Error(playerid, "Uang anda kurang untuk membeli WorkShop ini");
                GivePlayerMoneyEx(playerid, -CarDealershipInfo[cid][cdPrice]);
                new owner[MAX_PLAYER_NAME];
                CarDealershipInfo[cid][cdOwned] = 1;
                GetPlayerName(playerid, owner, sizeof(owner));
                format(CarDealershipInfo[cid][cdOwner], 228, "%s", pData[playerid][pName]);
                new query[1280];
                mysql_format(g_SQL, query, sizeof query, "UPDATE dealership SET owner='%s', owned='1' WHERE id=%d", CarDealershipInfo[cid][cdOwner], cid);
                mysql_query(g_SQL, query);

                new str[512];
                format(str, sizeof(str), "ID: %d\n{FFFF00}Sponsored: %s\n{FFFFFF}Owner: {00FF00}%s", cid, CarDealershipInfo[cid][cdMessage], CarDealershipInfo[cid][cdOwner]);
                UpdateDynamic3DTextLabelText(CarDealershipInfo[cid][cdTextLabel], -1, str);
                Servers(playerid, "You have successfully purchased a dealership {ffff00}`/dealership`");
                SavecDealership(cid);
            }
        }
    }
    return 1;
}