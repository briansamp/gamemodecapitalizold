CreateJoinKurirPoint()
{
	//JOBS
	new strings[128];
	CreateDynamicPickup(1239, 23, 1613.6221,-1892.9106,13.5469, -1, -1, -1, 5.0);
	format(strings, sizeof(strings), "[COURIER JOBS]\n{ffffff}Jadilah Pekerja Kurir disini\n{7fffd4}/getjob /accept job");
	CreateDynamic3DTextLabel(strings, COLOR_YELLOW, 1613.6221,-1892.9106,13.5469, 3.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1); // kurir

	CreateDynamicPickup(1239, 23, 1654.9298,-1862.5781,13.5344, -1, -1, -1, 5.0);
	format(strings, sizeof(strings), "[COURIER JOBS]\n{ffffff}loadpoint untuk Kurir disini\n{7fffd4}/buy");
	CreateDynamic3DTextLabel(strings, COLOR_YELLOW, 1654.9298,-1862.5781,13.5344, 3.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1); // kurir
}

new KurirCar[3];

AddKurirVehicle()
{
	new strings[128];
    KurirCar[0] = AddStaticVehicle(482, 1626.305,-1894.327,13.677,357.347, 6, 6);
    KurirCar[1] = AddStaticVehicle(482, 1622.707,-1894.286,13.667,358.932, 6, 6);
    KurirCar[2] = AddStaticVehicle(482, 1618.893,-1894.399,13.671,0.044, 6, 6);

    for(new x;x<sizeof(KurirCar);x++)
	{
	    format(strings, sizeof(strings), "DMV-%d", KurirCar[x]);
	    SetVehicleNumberPlate(KurirCar[x], strings);
	    SetVehicleToRespawn(KurirCar[x]);
	}
}

function KurirStart(playerid)
{
    if(!IsValidTimer(pData[playerid][pActivity])) return 0;
	{
		if(pData[playerid][pActivityTime] >= 100)
		{
			InfoTD_MSG(playerid, 8000, "Done!");
			KillTimer(pData[playerid][pActivity]);
			pData[playerid][pActivityTime] = 0;
			HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
			PlayerTextDrawHide(playerid, ActiveTD[playerid]);
			pData[playerid][pEnergy] -= 5;
			TogglePlayerControllable(playerid, 1);
			return 1;
		}
		else if(pData[playerid][pActivityTime] < 100)
		{
			pData[playerid][pActivityTime] += 5;
			SetPlayerProgressBarValue(playerid, pData[playerid][activitybar], pData[playerid][pActivityTime]);
		}
	}
	return 1;
}

function KurirDone(playerid)
{
    if(!IsValidTimer(pData[playerid][pActivity])) return 0;
	{
		if(pData[playerid][pActivityTime] >= 100)
		{
			InfoTD_MSG(playerid, 8000, "Done!");
			KillTimer(pData[playerid][pActivity]);
			pData[playerid][pActivityTime] = 0;
			HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
			PlayerTextDrawHide(playerid, ActiveTD[playerid]);
			pData[playerid][pEnergy] -= 5;
			TogglePlayerControllable(playerid, 1);
			return 1;
		}
		else if(pData[playerid][pActivityTime] < 100)
		{
			pData[playerid][pActivityTime] += 5;
			SetPlayerProgressBarValue(playerid, pData[playerid][activitybar], pData[playerid][pActivityTime]);
		}
	}
	return 1;
}
