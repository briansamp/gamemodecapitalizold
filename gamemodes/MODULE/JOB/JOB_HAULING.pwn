CMD:work(playerid)
{
	ShowPlayerDialog(playerid, DIALOG_WORK, DIALOG_STYLE_LIST, "Start Work", "MechDuty\nTaxiDuty\nHauling Cargo\nHauling Trailer", "Enter", "Back");
	return 1;
}
CMD:hauls(playerid)
{
    new H4NT0T[10000], String[10000];
	if(pData[playerid][pJob] == 4 || pData[playerid][pJob2] == 4)
	{
	    if(pData[playerid][pTruckerTime] > 0)
		{
	    	Error(playerid, "Anda harus menunggu "GREY2_E"%d "WHITE_E"detik lagi.", pData[playerid][pTruckerTime]);
	    	return 1;
		}
		if(SedangHauling[playerid] >= 1) { SendClientMessageEx(playerid,COLOR_WHITE,"Kamu sedang dalam pengiriman."); return 1; }
		//if(pData[playerid][pTruckingSkill] < 32) { SendClientMessageEx(playerid,COLOR_WHITE,"Skills anda kurang untuk melakukan Hauling Missions."); return 1; }
	    if(GetVehicleModel(GetPlayerVehicleID(playerid)) == 403 || GetVehicleModel(GetPlayerVehicleID(playerid)) == 514 || GetVehicleModel(GetPlayerVehicleID(playerid)) == 515)
		{
			strcat(H4NT0T, "Order\tPrice\n");
			format(String, sizeof(String), "Ocean Dock Export\t%s\n", (DialogHauling[0] == true) ? ("{FF0000}Taken") : ("{33AA33}$500"));
			strcat(H4NT0T, String);
			format(String, sizeof(String), "Ocean Dock Imports\t%s\n", (DialogHauling[1] == true) ? ("{FF0000}Taken") : ("{33AA33}$500"));
			strcat(H4NT0T, String);
			format(String, sizeof(String), "Angel Pine Exports\t%s\n", (DialogHauling[2] == true) ? ("{FF0000}Taken") : ("{33AA33}$500"));
			strcat(H4NT0T, String);
			format(String, sizeof(String), "Angel Pine Exports\t%s\n", (DialogHauling[3] == true) ? ("{FF0000}Taken") : ("{33AA33}$500"));
			strcat(H4NT0T, String);
			format(String, sizeof(String), "Chilliad Deport\t%s\n", (DialogHauling[4] == true) ? ("{FF0000}Taken") : ("{33AA33}$500"));
			strcat(H4NT0T, String);
			format(String, sizeof(String), "Chilliad Deport\t%s\n", (DialogHauling[5] == true) ? ("{FF0000}Taken") : ("{33AA33}$500"));
			strcat(H4NT0T, String);
			format(String, sizeof(String), "Easter Import\t%s\n", (DialogHauling[6] == true) ? ("{FF0000}Taken") : ("{33AA33}$500"));
			strcat(H4NT0T, String);
			format(String, sizeof(String), "Blueberry Export\t%s\n", (DialogHauling[7] == true) ? ("{FF0000}Taken") : ("{33AA33}$500"));
			strcat(H4NT0T, String);
			format(String, sizeof(String), "Las Venturas Deport\t%s\n", (DialogHauling[8] == true) ? ("{FF0000}Taken") : ("{33AA33}$500"));
			strcat(H4NT0T, String);
			format(String, sizeof(String), "Las Venturas Fuel & Gas\t%s", (DialogHauling[9] == true) ? ("{FF0000}Taken") : ("{33AA33}$500"));
			strcat(H4NT0T, String);
			ShowPlayerDialog(playerid, DIALOG_HAULINGTR, DIALOG_STYLE_TABLIST_HEADERS, "Hauling Missions", H4NT0T, "Select", "Cancel");
			return 1;
		}
		return Error(playerid, "You are not in the Truck.");
	}
	return Error(playerid, "You are not Trucker.");
}

