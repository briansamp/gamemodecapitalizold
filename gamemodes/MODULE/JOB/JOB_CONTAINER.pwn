CreateContainerPoint()
{
	new strings[200];
	CreateDynamicPickup(1239, 23, -591.8328, -550.5755, 25.5296, -1);
	format(strings, sizeof(strings), "[Take Container]\n{FFFFFF}Point Of Take The Trailer Container");
	CreateDynamic3DTextLabel(strings, COLOR_PINK, -591.8328, -550.5755, 25.5296, 3.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1);
}

CMD:container(playerid, params[])
{
	if(pData[playerid][pJob] == 4 || pData[playerid][pJob2] == 4)
	{
		if(pData[playerid][pSedangContainer] > 0)
		{
			Error(playerid, "Anda sedang dalam pengiriman container.");
			return 1;
		}
		if(GetVehicleModel(GetPlayerVehicleID(playerid)) == 578)
		{
			new S3MP4K[10000], String[10000];
			strcat(S3MP4K, "Order\tPrice\n");
			format(String, sizeof(String), ""WHITE_E"Ocean Dock Imports\t%s\n", (DialogHauling[0] == true) ? (""RED_E"Taken") : (""GREEN_E"$710"));
			strcat(S3MP4K, String);
			format(String, sizeof(String), ""WHITE_E"Angel Pine Exports\t%s\n", (DialogHauling[1] == true) ? (""RED_E"Taken") : (""GREEN_E"$400"));
			strcat(S3MP4K, String);
			format(String, sizeof(String), ""WHITE_E"Chilliad Deport\t%s\n", (DialogHauling[2] == true) ? (""RED_E"Taken") : (""GREEN_E"$550"));
			strcat(S3MP4K, String);
			format(String, sizeof(String), ""WHITE_E"Easter Import\t%s\n", (DialogHauling[3] == true) ? (""RED_E"Taken") : (""GREEN_E"$410"));
			strcat(S3MP4K, String);
			format(String, sizeof(String), ""WHITE_E"Blueberry Export\t%s\n", (DialogHauling[4] == true) ? (""RED_E"Taken") : (""GREEN_E"$120"));
			strcat(S3MP4K, String);
			format(String, sizeof(String), ""WHITE_E"Las Venturas Deport\t%s\n", (DialogHauling[5] == true) ? (""RED_E"Taken") : (""GREEN_E"$520"));
			strcat(S3MP4K, String);
			format(String, sizeof(String), ""WHITE_E"Las Venturas Fuel & Gas\t%s", (DialogHauling[6] == true) ? (""RED_E"Taken") : (""GREEN_E"$625"));
			strcat(S3MP4K, String);
			ShowPlayerDialog(playerid, DIALOG_CONTAINER, DIALOG_STYLE_TABLIST_HEADERS, "Container Missions", S3MP4K, "Select", "Cancel");
			return 1;
		}
		Error(playerid, "You are not in the Truck.");
		return 1;
	}
	Error(playerid, "Anda bukan trucker job.");
	return 1;
}