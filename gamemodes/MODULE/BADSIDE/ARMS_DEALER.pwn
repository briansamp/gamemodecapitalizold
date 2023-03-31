//-3807.89, 1312.56, 75.82

CreateArmsPoint()
{
	//JOBS
	new strings[128];
	CreateDynamicPickup(1239, 23, 497.8915, -2577.5542, 3.5439, -1);
	format(strings, sizeof(strings), "[TOOLS]\n{FFFFFF}/creategun");
	CreateDynamic3DTextLabel(strings, COLOR_GREY, 497.8915, -2577.5542, 3.5439, 3.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1); //

	new stringss[128];
	CreateDynamicPickup(1239, 23, 524.9838, -2567.2510, 4.2118, -1);
	format(stringss, sizeof(stringss), "[TOOLS]\n{FFFFFF}/createammo");
	CreateDynamic3DTextLabel(stringss, COLOR_GREY, 524.9838, -2567.2510, 4.2118, 3.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1); //

	new stringsss[128];
	CreateDynamicPickup(1239, 23, 524.4753, -2557.9805, 4.2118, -1);
	format(stringsss, sizeof(stringsss), "[TOOLS]\n{FFFFFF}/createmegazine");
	CreateDynamic3DTextLabel(stringsss, COLOR_GREY, 524.4753, -2557.9805, 4.2118, 3.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1); //
}

CMD:creategun(playerid, params[])
{
	if(IsPlayerInRangeOfPoint(playerid, 3.5,  497.8915, -2577.5542, 3.5439) || IsPlayerInRangeOfPoint(playerid, 3.5, 968.8442, -44.0716, 1001.1172) || IsPlayerInRangeOfPoint(playerid, 3.5, 2251.3003, -1158.2786, 1029.7969))
	{
		if(pData[playerid][pFamily] != -1)
		{
			new Dstring[512];
			format(Dstring, sizeof(Dstring), "Weapon\tMats & Comps & Price\n\
			Silenced Pistol\t20 & 20 / $200.00\n");
			format(Dstring, sizeof(Dstring), "%sColt45 9MM\t30 & 30 & $300.00\n", Dstring);
			format(Dstring, sizeof(Dstring), "%sDesert Eagle\t40 & 40 & $400.00\n", Dstring);
			format(Dstring, sizeof(Dstring), "%sShotgun\t50 & 50 & $500.00\n", Dstring);
			format(Dstring, sizeof(Dstring), "%sMp5\t60 & 60 & $600.00\n", Dstring);
			format(Dstring, sizeof(Dstring), "%sAK-47\t70 & 70 & $700.00\n", Dstring);
			ShowPlayerDialog(playerid, DIALOG_ARMS_GUN, DIALOG_STYLE_TABLIST_HEADERS, "Create Gun", Dstring, "Create", "Cancel");	
		}
		else
		{
			Error(playerid, "You don't have permission to create gun!");
		}
	}
	else
	{
		return Error(playerid, "You must in Tools Point!");
	}
	return 1;
}
CMD:createammo(playerid, params[])
{
	if(!IsPlayerInRangeOfPoint(playerid, 35, 524.9838, -2567.2510, 4.2118)) return Error(playerid, "You Must in House CreateAmmo!");
	if(pData[playerid][pFamily] != -1)
	{
		new Dstring[512];
		format(Dstring, sizeof(Dstring), "Ammo\tMats & Comps & Price\n\
		Desert Eagle = ammo 70)\t14 & 14 & $40.00\n");
		format(Dstring, sizeof(Dstring), "%sShotgun = ammo 50)\t15 & 15 & $50.00\n", Dstring);
		format(Dstring, sizeof(Dstring), "%sAK-47 = ammo 100)\t20 & 20 & $50.00\n", Dstring);
		ShowPlayerDialog(playerid, DIALOG_ARMS_AMMO, DIALOG_STYLE_TABLIST_HEADERS, "Create Ammo", Dstring, "Create", "Cancel");
	}
	else
	{
		Error(playerid, "You don't have permission to create gun!");
	}
	return 1;
}
CMD:createmegazine(playerid, params[])
{
	if(!IsPlayerInRangeOfPoint(playerid, 35, 524.4753, -2557.9805, 4.2118)) return Error(playerid, "You Must in House CreateAmmo!");
	if(pData[playerid][pFamily] != -1)
	{
		new Dstring[512];
		format(Dstring, sizeof(Dstring), "Megazine\tMats & Comps & Price\n\
		1 Megazine\t20 & 20 & $100.00\n");
		//format(Dstring, sizeof(Dstring), "%s3 Megazine\t60 & 60 & $250.00\n", Dstring);
		ShowPlayerDialog(playerid, DIALOG_ARMS_MEGAZINE, DIALOG_STYLE_TABLIST_HEADERS, "Create Megazine", Dstring, "Create", "Cancel");
	}
	else
	{
		Error(playerid, "You don't have permission to create megazine!");
	}
	return 1;
}
