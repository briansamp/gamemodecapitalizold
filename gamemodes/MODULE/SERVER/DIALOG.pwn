//----------------[ Dialog System ]--------------

//----------[ Dialog Login Register]----------
public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
	printf("[OnDialogResponse]: %s(%d) has used dialog id: %d Listitem: %d", pData[playerid][pName], playerid, dialogid, listitem);
    if(dialogid == DIALOG_LOGIN)
    {
        if(!response) return SelectTextDraw(playerid, 0xFFA500FF);

		new hashed_pass[65];
		SHA256_PassHash(inputtext, pData[playerid][pSalt], hashed_pass, 65);

		if (strcmp(hashed_pass, pData[playerid][pPassword]) == 0)
		{
			new query[512], query1[512];
			new count = random(1500);
			mysql_format(g_SQL, query, sizeof(query), "SELECT * FROM `players` WHERE `username` = '%e' LIMIT 1", pData[playerid][pName]);
			mysql_tquery(g_SQL, query, "AssignPlayerData", "d", playerid);
			printf("[LOGS] %s(%d) Succesfuly Login With Password(%s)", pData[playerid][pName], playerid, inputtext);
			SendClientMessage(playerid, -1, "");
			SendClientMessage(playerid, -1, "");
			SendClientMessage(playerid, -1, "");
			SendClientMessage(playerid, -1, "");
			SendMessage(playerid, ""WHITE_E" Selamat Datang {FF0000}%s {FFFFFF} Di Server Capitaliz Roleplay!", pData[playerid][pName]);
			SendMessage(playerid, ""WHITE_E" Dear {FF0000}%s{FFFFFF},Happy Roleplaying dikota Capitaliz Roleplay!", pData[playerid][pName]);
			SendMessage(playerid, ""WHITE_E" Jangan Lupa Ikuti Rules Server!");
			SendMessage(playerid, ""WHITE_E" Player Saat ini {FF0000}%d {FFFFFF}Yuk Ramaikan lagi!", online);
			SendMessage(playerid, ""WHITE_E" Server memerlukan waktu "YELLOW_E"%d miliseconds "WHITE_E"untuk memuat data char anda", count);
			SendMessage(playerid, ""WHITE_E" Jangan lupa untuk selalu bersyukur!");
			for(new i =0 ; i < 15; i++)
			{	
				PlayerTextDrawHide(playerid, LOGINTD[i][playerid]);
			}
			CancelSelectTextDraw(playerid);
			
			TotalLogin++;
			mysql_format(g_SQL, query1, sizeof(query1), "INSERT INTO loglogin (username,reg_id,password,time) VALUES('%s','%d','%s',CURRENT_TIMESTAMP())", pData[playerid][pName], pData[playerid][pID], inputtext);
			mysql_tquery(g_SQL, query1);
		}
		else
		{
			pData[playerid][LoginAttempts]++;

			if (pData[playerid][LoginAttempts] >= 3)
			{
				ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_MSGBOX, "Login", "You have mistyped your password too often (3 times).", "Okay", "");
				KickEx(playerid);
			}
			else ShowPlayerDialog(playerid, DIALOG_LOGIN, DIALOG_STYLE_PASSWORD, "Login", "Wrong password!\nPlease enter your password in the field below:", "Login", "Abort");
		}
        return 1;
    }
    /*if(dialogid == DIALOG_GARAGE)
	{
	    new carid, garid = pData[playerid][pGarage];
	    if(response)
	    {
			if(listitem == 0)
			{
			    if(Garage_IsOwner(playerid, garid))
			    {
				    if(GetPlayerState(playerid) != PLAYER_STATE_DRIVER)
				        return Error(playerid, "You must be the driver of your own vehicle.");

					if((carid =IsPlayerInAnyVehicle(playerid)) != -1)
					{
						if(Vehicle_IsOwner(playerid, carid))
						{
						    Vehicle_GetStatus(carid);
							pvData[carid][cGaraged] = garid;
							pvData[carid][cFuel] = pvData[carid][cFuel];
							if(IsValidVehicle(pvData[carid][cVeh]))
								DestroyVehicle(pvData[carid][cVeh]);

							pvData[carid][cVeh] = 0;

							Servers(playerid, "You've successfully stored your vehicle.");
							Trunk_Save(carid);
						}
					}
			    }
			    else
			    {
				    if(pData[playerid][pMoney] < GarageData[garid][garageFee])
				        return Error(playerid, "You don't have enough money to paid garage fee!");

				    if(GetPlayerState(playerid) != PLAYER_STATE_DRIVER)
				        return Error(playerid, "You must be the driver of your own vehicle.");

					if((carid =IsPlayerInAnyVehicle(playerid)) != -1)
					{
						if(Vehicle_IsOwner(playerid, carid))
						{
						    Vehicle_GetStatus(carid);
							pvData[carid][cGaraged] = garid;
							GarageData[garid][garageVault] += GarageData[garid][garageFee];
							pvData[carid][cFuel] = pvData[carid][cFuel];
							if(IsValidVehicle(pvData[carid][cVeh]))
								DestroyVehicle(pvData[carid][cVeh]);

							pvData[carid][cVeh] = 0;
							GivePlayerMoney(playerid, -GarageData[garid][garageFee]);
							Servers(playerid, "You've successfully stored your vehicle and paid {009000}$%d", GarageData[garid][garageFee]);
							Trunk_Save(carid);
						}
					}
				}
			}
			if(listitem == 1)
			{
				ShowGaragedVehicle(playerid);
			}
		}
	}
	if(dialogid == DIALOG_GARAGEOWNER)
	{
	    new id = pData[playerid][pGarage];
		if(response)
		{
		    if(listitem == 0)
		    {
		        if(GarageData[id][garageVault] < 1)
		        	return Error(playerid, "Tidak ada uang dalam Garage ini!");

		        GivePlayerMoneyEx(playerid, GarageData[id][garageVault]);
		        Servers(playerid, "Kamu berhasil mengambil $%d dari Garage Vault!", GarageData[id][garageVault]);
		        GarageData[id][garageVault] = 0;
			}
			if(listitem == 1)
			{
			    ShowPlayerDialog(playerid, DIALOG_GARAGENAME, DIALOG_STYLE_INPUT, "Garage Name", "Masukan nama garage:", "Confirm", "Cancel");
			}
			if(listitem == 2)
			{
			    ShowPlayerDialog(playerid, DIALOG_GARAGEFEE, DIALOG_STYLE_INPUT, "Garage Fee", "Masukan Fee untuk garage:", "Confirm", "Cancel");
			}
		}
	}
	if(dialogid == DIALOG_GARAGETAKE)
	{
	    new id = Garage_Nearest(playerid);
	    if(response)
	    {
	        new count;
         	foreach(new i : PVehicles)
	        {
 				if(pvData[i][cGaraged] == id)
				{
	            	if(pvData[i][cOwner] == pData[playerid][pID] && count++ == listitem)
	            	{
	                	new
		                    Float:x,
		                    Float:y,
		                    Float:z;

		                GetPlayerPos(playerid, x, y, z);
						pvData[i][cVeh] = CreateVehicle(pvData[i][cModel], x, y, z, pvData[i][cPosA], pvData[i][cColor1], pvData[i][cColor2], 60000);
						SetVehicleNumberPlate(pvData[i][cVeh], pvData[i][cPlate]);
						SetVehicleVirtualWorld(pvData[i][cVeh], pvData[i][cVw]);
						LinkVehicleToInterior(pvData[i][cVeh], pvData[i][cInt]);
						pvData[i][cFuel] = pvData[i][cFuel];
						if(pvData[i][cHealth] < 350.0)
						{
							SetVehicleHealth(pvData[i][cVeh], 350.0);
						}
						else
						{
							SetVehicleHealth(pvData[i][cVeh], pvData[i][cHealth]);
						}
						UpdateVehicleDamageStatus(pvData[i][cVeh], pvData[i][cDamage0], pvData[i][cDamage1], pvData[i][cDamage2], pvData[i][cDamage3]);
						if(pvData[i][cVeh] != INVALID_VEHICLE_ID)
						{
							if(pvData[i][cPaintJob] != -1)
							{
								ChangeVehiclePaintjob(pvData[i][cVeh], pvData[i][cPaintJob]);
							}
							for(new sz = 0; sz < 17; sz++)
							{
								if(pvData[i][cMod][sz])
								{
									AddVehicleComponent(pvData[i][cVeh], pvData[i][cMod][sz]);
								}
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
						pvData[i][cGaraged] = -1;
						pvData[i][cBreaken] = INVALID_PLAYER_ID;
						pvData[i][cBreaking] = 0;
						PutPlayerInVehicle(playerid, pvData[i][cVeh], 0);
						SetTimer("OnLoadVehicleStorage", 1000, false);
						MySQL_LoadVehicleStorage(i);
						Servers(playerid, "Anda telah berhasil mengambil kendaraan Anda dari garasi.");
					}
				}
			}
		}
	}
	if(dialogid == DIALOG_GARAGEFEE)
	{
	    new id = pData[playerid][pGarage];
		if(response)
		{
		    if(strval(inputtext) < 3 || strval(inputtext) > 50)
		        return ShowPlayerDialog(playerid, DIALOG_GARAGEFEE, DIALOG_STYLE_INPUT, "Garage Fee", "ERROR: Fee tidak bisa dibawah $3 atau diatas $50\nMasukan Fee untuk garage:", "Confirm", "Cancel");

			GarageData[id][garageFee] = strval(inputtext);
			Garage_Refresh(id);
			Garage_Save(id);
			Servers(playerid, "Berhasil mengubah Fee garage menjadi $%d", strval(inputtext));
		}
	}
	if(dialogid == DIALOG_GARAGENAME)
	{
	    new id = pData[playerid][pGarage];
	    if(response)
	    {
	        if(strlen(inputtext) < 3 || strlen(inputtext) > GARAGE_NAME_SIZE)
	            return ShowPlayerDialog(playerid, DIALOG_GARAGENAME, DIALOG_STYLE_INPUT, "Garage Name", "Masukan nama garage:", "Confirm", "Cancel");

			format(GarageData[id][garageName], GARAGE_NAME_SIZE, inputtext);
			Garage_Refresh(id);
			Garage_Save(id);
			Servers(playerid, "Berhasil mengubah garage name menjadi %s", inputtext);
		}
	}
	*/
    if(dialogid == DIALOG_STORAGE_MENU)
	{
		new vid = pData[playerid][pInStorage];
		if(response)
		{
			switch(listitem)
			{
				case 0: S_WeaponStorage(playerid, vid);
				case 1:
				{
					ShowPlayerDialog(playerid, DIALOG_STORAGE_M, DIALOG_STYLE_LIST,"Storage Money","Deposit\nWithdraw","Select","Cancel");
				}
				case 2:
				{
				    ShowPlayerDialog(playerid, DIALOG_STORAGE_RM, DIALOG_STYLE_LIST, "Storage Red Money", "Withdraw\nDeposit", "Select", "Back");
				}
				case 3:
				{
				    ShowPlayerDialog(playerid, DIALOG_STORAGE_MRJ, DIALOG_STYLE_LIST, "Storage Marijuana", "Withdraw\nDeposit", "Select", "Back");
				}
				case 4:
				{
				    ShowPlayerDialog(playerid, DIALOG_STORAGE_CMP, DIALOG_STYLE_LIST, "Storage Component", "Withdraw\nDeposit", "Select", "Back");
				}
				case 5:
				{
				    ShowPlayerDialog(playerid, DIALOG_STORAGE_MTR, DIALOG_STYLE_LIST, "Storage Material", "Withdraw\nDeposit", "Select", "Back");
				}
			}
		}
		return 1;
	}
	if(dialogid == DIALOG_STORAGE_MTR)
	{
		if(response)
		{
			new fid = pData[playerid][pInStorage];
			if(response)
			{
				switch (listitem)
				{
					case 0:
					{
						new str[128];
						format(str, sizeof(str), "Material: %d", StgData[fid][SMate]);
						ShowPlayerDialog(playerid, S_MTR_WT, DIALOG_STYLE_INPUT, "Withdraw Menu", str, "Withdraw", "Back");
					}
					case 1:
					{
						new str[128];
						format(str, sizeof(str), "Material: %d", StgData[fid][SMate]);
						ShowPlayerDialog(playerid, S_MTR_DP, DIALOG_STYLE_INPUT, "Deposit Menu", str, "Deposit", "Back");
					}
				}
			}
		}
		return 1;
	}

	if(dialogid == S_MTR_WT)
	{
		new fid = pData[playerid][pInStorage];

		if(response)
		{
			new amount = strval(inputtext);

			if(isnull(inputtext))
			{
				new str[128];
				format(str, sizeof(str), "Material: %d", StgData[fid][SMate]);
				ShowPlayerDialog(playerid, S_MTR_WT, DIALOG_STYLE_INPUT, "Withdraw from Storage", str, "Withdraw", "Back");
				return 1;
			}
			if(amount < 1 || amount > StgData[fid][SMate])
			{
				new str[128];
				format(str, sizeof(str), "Error: Insufficient funds.\n\nMaterial: %d\n\nPlease enter how much Material you wish to withdraw from the Storage:", StgData[fid][SMate]);
				ShowPlayerDialog(playerid, S_MTR_WT, DIALOG_STYLE_INPUT, "Withdraw from Storage", str, "Withdraw", "Back");
				return 1;
			}
			StgData[fid][SMate] -= amount;
			pData[playerid][pMaterial] += amount;

			StorageSave(fid);
			SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s has withdrawn %d Material from their storage.", ReturnName(playerid), amount);
			return 1;
		}
		return 1;
	}
	if(dialogid == S_MTR_DP)
	{
		new fid = pData[playerid][pInStorage];
		if(response)
		{
			new amount = strval(inputtext);

			if(isnull(inputtext))
			{
				new str[128];
				format(str, sizeof(str), "Material: %d", StgData[fid][SMate]);
				ShowPlayerDialog(playerid, S_MTR_DP, DIALOG_STYLE_INPUT, "Deposit Into Storage", str, "Deposit", "Back");
				return 1;
			}
			if(amount < 1 || amount > pData[playerid][pMaterial])
			{
				new str[128];
				format(str, sizeof(str), "Error: Insufficient funds.\n\nMaterial Balance: %d\n\nPlease enter how much Material you wish to deposit into the storage:", StgData[fid][SMate]);
				ShowPlayerDialog(playerid, S_MTR_DP, DIALOG_STYLE_INPUT, "Deposit Into Storage", str, "Deposit", "Back");
				return 1;
			}
			StgData[fid][SMate] += amount;
			pData[playerid][pMaterial] -= amount;

			StorageSave(fid);
			SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s has deposited %s Material into their storage.", ReturnName(playerid), amount);
		}
		return 1;
	}
	if(dialogid == DIALOG_STORAGE_CMP)
	{
		if(response)
		{
			new fid = pData[playerid][pInStorage];
			if(response)
			{
				switch (listitem)
				{
					case 0:
					{
						new str[128];
						format(str, sizeof(str), "Component: %d", StgData[fid][SCom]);
						ShowPlayerDialog(playerid, S_CMP_WT, DIALOG_STYLE_INPUT, "Withdraw Menu", str, "Withdraw", "Back");
					}
					case 1:
					{
						new str[128];
						format(str, sizeof(str), "Component: %d", StgData[fid][SCom]);
						ShowPlayerDialog(playerid, S_CMP_DP, DIALOG_STYLE_INPUT, "Deposit Menu", str, "Deposit", "Back");
					}
				}
			}
		}
		return 1;
	}

	if(dialogid == S_CMP_WT)
	{
		new fid = pData[playerid][pInStorage];

		if(response)
		{
			new amount = strval(inputtext);

			if(isnull(inputtext))
			{
				new str[128];
				format(str, sizeof(str), "Component: %d", StgData[fid][SCom]);
				ShowPlayerDialog(playerid, S_CMP_WT, DIALOG_STYLE_INPUT, "Withdraw from Storage", str, "Withdraw", "Back");
				return 1;
			}
			if(amount < 1 || amount > StgData[fid][SCom])
			{
				new str[128];
				format(str, sizeof(str), "Error: Insufficient funds.\n\nComponent: %d\n\nPlease enter how much Component you wish to withdraw from the Storage:", StgData[fid][SCom]);
				ShowPlayerDialog(playerid, S_CMP_WT, DIALOG_STYLE_INPUT, "Withdraw from Storage", str, "Withdraw", "Back");
				return 1;
			}
			StgData[fid][SCom] -= amount;
			pData[playerid][pComponent] += amount;

			StorageSave(fid);
			SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s has withdrawn %d Component from their storage.", ReturnName(playerid), amount);
			return 1;
		}
		return 1;
	}
	if(dialogid == S_CMP_DP)
	{
		new fid = pData[playerid][pInStorage];
		if(response)
		{
			new amount = strval(inputtext);

			if(isnull(inputtext))
			{
				new str[128];
				format(str, sizeof(str), "Component: %d", StgData[fid][SCom]);
				ShowPlayerDialog(playerid, S_CMP_DP, DIALOG_STYLE_INPUT, "Deposit Into Storage", str, "Deposit", "Back");
				return 1;
			}
			if(amount < 1 || amount > pData[playerid][pComponent])
			{
				new str[128];
				format(str, sizeof(str), "Error: Insufficient funds.\n\nComponent Balance: %d\n\nPlease enter how much Component you wish to deposit into the storage:", StgData[fid][SCom]);
				ShowPlayerDialog(playerid, S_CMP_DP, DIALOG_STYLE_INPUT, "Deposit Into Storage", str, "Deposit", "Back");
				return 1;
			}
			StgData[fid][SCom] += amount;
			pData[playerid][pComponent] -= amount;

			StorageSave(fid);
			SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s has deposited %s Component into their storage.", ReturnName(playerid), amount);
		}
		return 1;
	}
	if(dialogid == DIALOG_STORAGE_MRJ)
	{
		if(response)
		{
			new fid = pData[playerid][pInStorage];
			if(response)
			{
				switch (listitem)
				{
					case 0:
					{
						new str[128];
						format(str, sizeof(str), "Marijuana: %d", StgData[fid][SMarjun]);
						ShowPlayerDialog(playerid, S_MRJ_WT, DIALOG_STYLE_INPUT, "Withdraw Menu", str, "Withdraw", "Back");
					}
					case 1:
					{
						new str[128];
						format(str, sizeof(str), "Marijuana: %d", StgData[fid][SMarjun]);
						ShowPlayerDialog(playerid, S_MRJ_DP, DIALOG_STYLE_INPUT, "Deposit Menu", str, "Deposit", "Back");
					}
				}
			}
		}
		return 1;
	}

	if(dialogid == S_MRJ_WT)
	{
		new fid = pData[playerid][pInStorage];

		if(response)
		{
			new amount = strval(inputtext);

			if(isnull(inputtext))
			{
				new str[128];
				format(str, sizeof(str), "Marijuana: %d", StgData[fid][SMarjun]);
				ShowPlayerDialog(playerid, S_MRJ_WT, DIALOG_STYLE_INPUT, "Withdraw from Storage", str, "Withdraw", "Back");
				return 1;
			}
			if(amount < 1 || amount > StgData[fid][SMarjun])
			{
				new str[128];
				format(str, sizeof(str), "Error: Insufficient funds.\n\nMarijuana: %d\n\nPlease enter how much marijuana you wish to withdraw from the Storage:", StgData[fid][SMarjun]);
				ShowPlayerDialog(playerid, S_MRJ_WT, DIALOG_STYLE_INPUT, "Withdraw from Storage", str, "Withdraw", "Back");
				return 1;
			}
			StgData[fid][SMarjun] -= amount;
			pData[playerid][pMarijuana] += amount;

			StorageSave(fid);
			SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s has withdrawn %d marijuana from their storage.", ReturnName(playerid), amount);
			return 1;
		}
		return 1;
	}
	if(dialogid == S_MRJ_DP)
	{
		new fid = pData[playerid][pInStorage];
		if(response)
		{
			new amount = strval(inputtext);

			if(isnull(inputtext))
			{
				new str[128];
				format(str, sizeof(str), "Marijuana: %d", StgData[fid][SMarjun]);
				ShowPlayerDialog(playerid, S_MRJ_DP, DIALOG_STYLE_INPUT, "Deposit Into Storage", str, "Deposit", "Back");
				return 1;
			}
			if(amount < 1 || amount > pData[playerid][pMarijuana])
			{
				new str[128];
				format(str, sizeof(str), "Error: Insufficient funds.\n\nMarijuana Balance: %d\n\nPlease enter how much marijuana you wish to deposit into the storage:", StgData[fid][SMarjun]);
				ShowPlayerDialog(playerid, S_MRJ_DP, DIALOG_STYLE_INPUT, "Deposit Into Storage", str, "Deposit", "Back");
				return 1;
			}
			StgData[fid][SMarjun] += amount;
			pData[playerid][pMarijuana] -= amount;
			//GivePlayerMoneyEx(playerid, -amount);

			StorageSave(fid);
			SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s has deposited %s marijuana into their storage.", ReturnName(playerid), amount);
		}
		return 1;
	}
	
	if(dialogid == DIALOG_STORAGE_RM)
	{
		if(response)
		{
			new fid = pData[playerid][pInStorage];
			if(response)
			{
				switch (listitem)
				{
					case 0:
					{
						new str[128];
						format(str, sizeof(str), "Red Money: %s", FormatMoney(StgData[fid][StorageRedMoney]));
						ShowPlayerDialog(playerid, S_RM_WT, DIALOG_STYLE_INPUT, "Withdraw Menu", str, "Withdraw", "Back");
					}
					case 1:
					{
						new str[128];
						format(str, sizeof(str), "Red Money: %s", FormatMoney(StgData[fid][StorageRedMoney]));
						ShowPlayerDialog(playerid, S_RM_DP, DIALOG_STYLE_INPUT, "Deposit Menu", str, "Deposit", "Back");
					}
				}
			}
		}
		return 1;
	}

	if(dialogid == S_RM_WT)
	{
		new fid = pData[playerid][pInStorage];

		if(response)
		{
			new amount = strval(inputtext);

			if(isnull(inputtext))
			{
				new str[128];
				format(str, sizeof(str), "Red Money: %s", FormatMoney(StgData[fid][StorageRedMoney]));
				ShowPlayerDialog(playerid, S_RM_WT, DIALOG_STYLE_INPUT, "Withdraw from Storage", str, "Withdraw", "Back");
				return 1;
			}
			if(amount < 1 || amount > StgData[fid][StorageRedMoney])
			{
				new str[128];
				format(str, sizeof(str), "Error: Insufficient funds.\n\nRed Money: %s\n\nPlease enter how much red money you wish to withdraw from the Storage:", FormatMoney(StgData[fid][StorageRedMoney]));
				ShowPlayerDialog(playerid, S_RM_WT, DIALOG_STYLE_INPUT, "Withdraw from Storage", str, "Withdraw", "Back");
				return 1;
			}
			StgData[fid][StorageRedMoney] -= amount;
			pData[playerid][pRedMoney] += amount;
			//GivePlayerMoneyEx(playerid, amount);

			StorageSave(fid);
			SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s has withdrawn %s red money from their storage.", ReturnName(playerid), FormatMoney(amount));
			return 1;
		}
		return 1;
	}
	if(dialogid == S_RM_DP)
	{
		new fid = pData[playerid][pInStorage];
		if(response)
		{
			new amount = strval(inputtext);

			if(isnull(inputtext))
			{
				new str[128];
				format(str, sizeof(str), "Red Money: %s", FormatMoney(StgData[fid][StorageRedMoney]));
				ShowPlayerDialog(playerid, S_RM_DP, DIALOG_STYLE_INPUT, "Deposit Into Storage", str, "Deposit", "Back");
				return 1;
			}
			if(amount < 1 || amount > pData[playerid][pRedMoney])
			{
				new str[128];
				format(str, sizeof(str), "Error: Insufficient funds.\n\nRed Money Balance: %s\n\nPlease enter how much red money you wish to deposit into the storage:", FormatMoney(StgData[fid][StorageRedMoney]));
				ShowPlayerDialog(playerid, S_RM_WT, DIALOG_STYLE_INPUT, "Deposit Into Storage", str, "Deposit", "Back");
				return 1;
			}
			StgData[fid][StorageRedMoney] += amount;
			pData[playerid][pRedMoney] -= amount;
			//GivePlayerMoneyEx(playerid, -amount);

			StorageSave(fid);
			SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s has deposited %s red money into their storage.", ReturnName(playerid), FormatMoney(amount));
		}
		return 1;
	}
	if(dialogid == DIALOG_STORAGE_M)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
					new mstr[512];
					format(mstr,sizeof(mstr),"Money: %s", FormatMoney(GetPlayerMoney(playerid)));
					ShowPlayerDialog(playerid, DIALOG_S_DEPOSIT, DIALOG_STYLE_INPUT, "Deposit Input", mstr, "Deposit", "Cancel");
				}
				case 1:
				{
					new mstr[512];
					format(mstr,sizeof(mstr),"Money: %s", FormatMoney(StgData[pData[playerid][pInStorage]][StorageMoney]));
					ShowPlayerDialog(playerid, DIALOG_S_WITHDRAW, DIALOG_STYLE_INPUT,"Withdraw Input", mstr, "Withdraw","Cancel");
				}
			}
		}
	}
	if(dialogid == DIALOG_S_WITHDRAW)
	{
		if(response)
		{
			new bid = pData[playerid][pInStorage];
			new amount = floatround(strval(inputtext));
			if(amount < 1 || amount > StgData[bid][StorageMoney])
				return Error(playerid, "Invalid amount specified!");

			StgData[bid][StorageMoney] -= amount;
			StorageSave(bid);

			GivePlayerMoneyEx(playerid, amount);

			Info(playerid, "You have withdrawn %s from the storage vault.", FormatMoney(strval(inputtext)));
		}
		else
			ShowPlayerDialog(playerid, DIALOG_STORAGE_M, DIALOG_STYLE_LIST,"Storage Money","Deposit\nWithdraw","Select","Cancel");
		return 1;
	}
	if(dialogid == DIALOG_S_DEPOSIT)
	{
		if(response)
		{
			new bid = pData[playerid][pInStorage];
			new amount = floatround(strval(inputtext));
			if(amount < 1 || amount > GetPlayerMoney(playerid))
				return Error(playerid, "Invalid amount specified!");

			StgData[bid][StorageMoney] += amount;
			StorageSave(bid);

			GivePlayerMoneyEx(playerid, -amount);

			Info(playerid, "You have deposit %s into the storage vault.", FormatMoney(strval(inputtext)));
		}
		else
			ShowPlayerDialog(playerid, DIALOG_STORAGE_M, DIALOG_STYLE_LIST,"Storage Money","Deposit\nWithdraw","Select","Cancel");
		return 1;
	}
	if(dialogid == DIALOG_REGISTER)
    {
		if (!response) return Kick(playerid);

		if (strlen(inputtext) <= 5) return ShowPlayerDialog(playerid, DIALOG_REGISTER, DIALOG_STYLE_PASSWORD, "Registration", "Your password must be longer than 5 characters!\nPlease enter your password in the field below:", "Register", "Abort");

		if(!IsValidPassword(inputtext))
		{
			Error(playerid, "Password can contain only A-Z, a-z, 0-9, _, [ ], ( )");
			ShowPlayerDialog(playerid, DIALOG_REGISTER, DIALOG_STYLE_PASSWORD, "Registration", "Your password must be valid characters!\nPlease enter your password in the field below:", "Register", "Abort");
			return 1;
		}

		for (new i = 0; i < 16; i++) pData[playerid][pSalt][i] = random(94) + 33;
		SHA256_PassHash(inputtext, pData[playerid][pSalt], pData[playerid][pPassword], 65);

		new query[842], PlayerIP[16];
		GetPlayerIp(playerid, PlayerIP, sizeof(PlayerIP));
		mysql_format(g_SQL, query, sizeof query, "INSERT INTO `players` (`username`, `password`, `salt`, `ip`, `reg_date`, `last_login`) VALUES ('%e', '%s', '%e', '%s', CURRENT_TIMESTAMP(), CURRENT_TIMESTAMP())", pData[playerid][pName], pData[playerid][pPassword], pData[playerid][pSalt], PlayerIP);
		mysql_tquery(g_SQL, query, "OnPlayerRegister", "i", playerid);
		return 1;
	}
	if(dialogid == DIALOG_AGE)
    {
		if(!response) return ShowPlayerDialog(playerid, DIALOG_AGE, DIALOG_STYLE_INPUT, "Tanggal Lahir", "Masukan tanggal lahir (Tgl/Bulan/Tahun): 15/04/1998", "Pilih", "Batal");
		if(response)
		{
			new
				iDay,
				iMonth,
				iYear,
				day,
				month,
				year;

			getdate(year, month, day);

			static const
					arrMonthDays[] = {31, 29, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31};

			if(sscanf(inputtext, "p</>ddd", iDay, iMonth, iYear)) {
				ShowPlayerDialog(playerid, DIALOG_AGE, DIALOG_STYLE_INPUT, "Tanggal Lahir", "Error! Invalid Input\nMasukan tanggal lahir (Tgl/Bulan/Tahun): 15/04/1998", "Pilih", "Batal");
			}
			else if(iYear < 1900 || iYear > year) {
				ShowPlayerDialog(playerid, DIALOG_AGE, DIALOG_STYLE_INPUT, "Tahun Lahir", "Error! Invalid Input\nMasukan tanggal lahir (Tgl/Bulan/Tahun): 15/04/1998", "Pilih", "Batal");
			}
			else if(iMonth < 1 || iMonth > 12) {
				ShowPlayerDialog(playerid, DIALOG_AGE, DIALOG_STYLE_INPUT, "Bulan Lahir", "Error! Invalid Input\nMasukan tanggal lahir (Tgl/Bulan/Tahun): 15/04/1998", "Pilih", "Batal");
			}
			else if(iDay < 1 || iDay > arrMonthDays[iMonth - 1]) {
				ShowPlayerDialog(playerid, DIALOG_AGE, DIALOG_STYLE_INPUT, "Tanggal Lahir", "Error! Invalid Input\nMasukan tanggal lahir (Tgl/Bulan/Tahun): 15/04/1998", "Pilih", "Batal");
			}
			else
			{
				format(pData[playerid][pAge], 50, inputtext);
				ShowPlayerDialog(playerid, DIALOG_GENDER, DIALOG_STYLE_LIST, "Gender", "1. Male/Laki-Laki\n2. Female/Perempuan", "Pilih", "Batal");
			}
		}
		else ShowPlayerDialog(playerid, DIALOG_AGE, DIALOG_STYLE_INPUT, "Tanggal Lahir", "Masukan tanggal lahir (Tgl/Bulan/Tahun): 15/04/1998", "Pilih", "Batal");
		return 1;
	}
	if(dialogid == DIALOG_GENDER)
    {
		if(!response) return ShowPlayerDialog(playerid, DIALOG_GENDER, DIALOG_STYLE_LIST, "Gender", "1. Male/Laki-Laki\n2. Female/Perempuan", "Pilih", "Batal");
		if(response)
		{
			pData[playerid][pGender] = listitem + 1;
			switch (listitem)
			{
				case 0:
				{
					SendClientMessageEx(playerid,COLOR_WHITE,"Server : "YELLOW_E"Register Succesfuly! Thanks To You After Register And join to server!");
					SendClientMessageEx(playerid,COLOR_WHITE,"Server : Tanggal Lahir : "YELLOW_E"%s | "WHITE_E"Gender : "BLUE_E"Male/Laki-Laki", pData[playerid][pAge]);
					SendClientMessageEx(playerid,COLOR_YELLOW,"Info : "WHITE_E"Follow Checkpoint To Get Starerpack Use '/claimsp'");
					SendClientMessageEx(playerid,COLOR_RED,"NewPlayer : "WHITE_E" Use '/help' for more info and '/settings'");
					SendClientMessageEx(playerid,COLOR_RED, ""WHITE_E"Use '/cursor' Jika cursor mu hilang saat memilih baju.");
					SetPlayerCheckpoint(playerid, 1642.3374,-2326.3716,13.5469, 2.0);
					switch (pData[playerid][pGender])
					{
						case 1: ShowModelSelectionMenu(playerid, SpawnMale, "Choose your skin");
						case 2: ShowModelSelectionMenu(playerid, SpawnFemale, "Choose your skin");
					}
				}
				case 1:
				{
					SendClientMessageEx(playerid,COLOR_WHITE,"Server : "YELLOW_E"Register Succesfuly! Thanks To You After Register And join to server!");
					SendClientMessageEx(playerid,COLOR_WHITE,"Server : "YELLOW_E"%s | "WHITE_E"Gender : "BLUE_E"Female/Perempuan", pData[playerid][pAge]);
					SendClientMessageEx(playerid,COLOR_YELLOW,"Info : "WHITE_E"Follow Checkpoint To Get Starerpack Use '/claimstarterpack'");
					SendClientMessageEx(playerid,COLOR_RED,"NewPlayer : "WHITE_E" Use '/help' for more info and '/settings'");
					SendClientMessageEx(playerid,COLOR_RED, ""WHITE_E"Use '/cursor' Jika cursor mu hilang saat memilih baju.");
					SetPlayerCheckpoint(playerid, 1642.3374,-2326.3716,13.5469, 2.0);
					switch (pData[playerid][pGender])
					{
						case 1: ShowModelSelectionMenu(playerid, SpawnMale, "Choose your skin");
						case 2: ShowModelSelectionMenu(playerid, SpawnFemale, "Choose your skin");
					}
				}
			}
			pData[playerid][pSkin] = (listitem) ? (233) : (98);
			SetPlayerSkin(playerid,pData[playerid][pSkin]);
			SetSpawnInfo(playerid, 0, pData[playerid][pSkin], 1132.4504, -2037.0957, 69.0078, 269.9846, 0, 0, 0, 0, 0, 0);
			SpawnPlayer(playerid);
		}
		else ShowPlayerDialog(playerid, DIALOG_GENDER, DIALOG_STYLE_LIST, "Gender", "1. Male/Laki-Laki\n2. Female/Perempuan", "Pilih", "Batal");
		return 1;
	}
	if(dialogid == DIALOG_EMAIL)
	{
		if(response)
		{
			if(isnull(inputtext))
			{
				Error(playerid, "This field cannot be left empty!");
				callcmd::email(playerid);
				return 1;
			}
			if(!(2 < strlen(inputtext) < 40))
			{
				Error(playerid, "Please insert a valid email! Must be between 3-40 characters.");
				callcmd::email(playerid);
				return 1;
			}
			if(!IsValidPassword(inputtext))
			{
				Error(playerid, "Email can contain only A-Z, a-z, 0-9, _, [ ], ( )  and @");
				callcmd::email(playerid);
				return 1;
			}
			new query[512];
			mysql_format(g_SQL, query, sizeof(query), "UPDATE players SET email='%e' WHERE reg_id='%d'", inputtext, pData[playerid][pID]);
			mysql_tquery(g_SQL, query);
			Servers(playerid, "Your e-mail has been set to "YELLOW_E"%s!"WHITE_E"(relogin for /stats update)", inputtext);
			return 1;
		}
	}
	if(dialogid == DIALOG_PASSWORD)
	{
		if(response)
		{
			if(!(3 < strlen(inputtext) < 20))
			{
				Error(playerid, "Please insert a valid password! Must be between 4-20 characters.");
				callcmd::changepass(playerid);
				return 1;
			}
			if(!IsValidPassword(inputtext))
			{
				Error(playerid, "Password can contain only A-Z, a-z, 0-9, _, [ ], ( )");
				callcmd::changepass(playerid);
				return 1;
			}
			new query[512];
			for (new i = 0; i < 16; i++) pData[playerid][pSalt][i] = random(94) + 33;
			SHA256_PassHash(inputtext, pData[playerid][pSalt], pData[playerid][pPassword], 65);

			mysql_format(g_SQL, query, sizeof(query), "UPDATE players SET password='%s', salt='%e' WHERE reg_id='%d'", pData[playerid][pPassword], pData[playerid][pSalt], pData[playerid][pID]);
			mysql_tquery(g_SQL, query);
			Servers(playerid, "Your password has been updated to "YELLOW_E"'%s'", inputtext);
		}
	}
	if(dialogid == DIALOG_STATS)
	{
		if(response)
		{
			return callcmd::settings(playerid);
		}
	}
	if(dialogid == DIALOG_SETTINGS)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
					return callcmd::email(playerid);
				}
				case 1:
				{
					return callcmd::changepass(playerid);
				}
				case 2:
				{
					ShowPlayerDialog(playerid, DIALOG_HBEMODE, DIALOG_STYLE_LIST, "HBE Mode", ""LG_E"Simple\n"LG_E"Modern\n"LG_E"Modern 2\n"RED_E"Disable", "Set", "Close");
				}
				case 3:
				{
					ShowPlayerDialog(playerid, DIALOG_TDMODE, DIALOG_STYLE_LIST, "Textdraw Mode", ""LG_E"Simple\n"LG_E"Bar\n"RED_E"Disable", "Set", "Close");
				}
				case 4:
				{
					return callcmd::togpm(playerid);
				}
				case 5:
				{
					return callcmd::toglog(playerid);
				}
				case 6:
				{
					return callcmd::togads(playerid);
				}
				case 7:
				{
					return callcmd::togwt(playerid);
				}
				case 8:
				{
					return callcmd::togdamage(playerid);
				}
			}
		}
	}
	if(dialogid == DIALOG_HBEMODE)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
					pData[playerid][pHBEMode] = 1;

					HidePlayerProgressBar(playerid, pData[playerid][hungrybar]);
					HidePlayerProgressBar(playerid, pData[playerid][energybar]);
					for(new txd; txd < 4; txd++)
					{
						TextDrawHideForPlayer(playerid, HudChar[txd]);
					}
                    TextDrawHideForPlayer(playerid, CharBox);
					PlayerTextDrawHide(playerid,  DPname[playerid]);
					PlayerTextDrawHide(playerid,  DPcoin[playerid]);
					PlayerTextDrawHide(playerid,  DPmoney[playerid]);
					PlayerTextDrawHide(playerid,  HBEO[playerid]);
					HideHUD(playerid);
					
					ShowSimplePlayerTetxdraw(playerid);
					if(IsPlayerInAnyVehicle(playerid) && GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
					{
						HidePlayerVehicleModern(playerid);
					}
					if(IsPlayerInAnyVehicle(playerid) && GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
					{
						ShowPlayerVelocimetro(playerid);
					}
				}
				case 1:
				{
					pData[playerid][pHBEMode] = 2;

				    HideSimplePlayerTetxdraw(playerid);
				    HidePlayerVelocimetro(playerid);
					HideHUD(playerid);

					PlayerTextDrawSetPreviewModel(playerid, HBEO[playerid], GetPlayerSkin(playerid));
					PlayerTextDrawShow(playerid, HBEO[playerid]);
                    TextDrawShowForPlayer(playerid, CharBox);

					ShowPlayerProgressBar(playerid, pData[playerid][hungrybar]);
					ShowPlayerProgressBar(playerid, pData[playerid][energybar]);
					TextDrawShowForPlayer(playerid, CharBox);
					for(new txd; txd < 4; txd++)
					{
						TextDrawShowForPlayer(playerid, HudChar[txd]);
					}
					if(IsPlayerInAnyVehicle(playerid) && GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
					{
						ShowPlayerVehicleModern(playerid);
					}
				}
				case 2:
				{
					pData[playerid][pHBEMode] = 3;

					HideSimplePlayerTetxdraw(playerid);
				    HidePlayerVelocimetro(playerid);
				    HidePlayerVehicleModern(playerid);

					HidePlayerProgressBar(playerid, pData[playerid][hungrybar]);
					HidePlayerProgressBar(playerid, pData[playerid][energybar]);
					for(new txd; txd < 4; txd++)
					{
						TextDrawHideForPlayer(playerid, HudChar[txd]);
					}
					PlayerTextDrawHide(playerid, HBEO[playerid]);
					TextDrawHideForPlayer(playerid, CharBox);
					PlayerTextDrawHide(playerid,  DPname[playerid]);
					PlayerTextDrawHide(playerid,  DPcoin[playerid]);
					PlayerTextDrawHide(playerid,  DPmoney[playerid]);

					HideHUD(playerid);
					ShowHUD(playerid);
				}
				case 3:
				{
					pData[playerid][pHBEMode] = 0;

				    HideSimplePlayerTetxdraw(playerid);
				    HidePlayerVelocimetro(playerid);
				    HidePlayerVehicleModern(playerid);

					HidePlayerProgressBar(playerid, pData[playerid][hungrybar]);
					HidePlayerProgressBar(playerid, pData[playerid][energybar]);
					for(new txd; txd < 4; txd++)
					{
						TextDrawHideForPlayer(playerid, HudChar[txd]);
					}
					PlayerTextDrawHide(playerid, HBEO[playerid]);
					TextDrawHideForPlayer(playerid, CharBox);
					PlayerTextDrawHide(playerid,  DPname[playerid]);
					PlayerTextDrawHide(playerid,  DPcoin[playerid]);
					PlayerTextDrawHide(playerid,  DPmoney[playerid]);
					HideHUD(playerid);
				}
			}
		}
	}
	new updates = GetPVarInt(playerid, "UID");
  	if(dialogid == DIALOG_UPDATE)
	{
	    if(response)
	    {
     		if(isnull(inputtext)) return ShowPlayerDialog(playerid, DIALOG_UPDATE, DIALOG_STYLE_INPUT, "adding update", "please write your update below", "Add", "Cancel");
		    for(new x=1 ; x<560 ; x++)
		    {
		        new s[256];
		        format(s, sizeof(s), "update%d", x);
		        if(!dini_Isset("updates.ini", s))
		        {
		            new year, month, day;
		            getdate(year, month, day);
		            new utext[1024];
		            format(utext, sizeof(utext), "%d/%d/%d", day, month, year);
		            format(s, sizeof(s), "date%d", x);
		        	dini_Set("updates.ini", s, utext);
		        	format(utext, sizeof(utext), "%s", inputtext);
		        	format(s, sizeof(s), "update%d", x);
		        	dini_Set("updates.ini", s, utext);
		        	new dd = dini_Int("updates.ini", "MAX");
		        	dini_IntSet("updates.ini", "MAX", dd+1);
					format(s, sizeof(s), "Added update id %d. Your Update: '%s', and Date: %d/%d/%d.", x, inputtext, day, month, year);
					SendClientMessage(playerid, COLOR_YELLOW, s);
		        	break;
				}
		    }
	        return 1;
	    }
	    return 1;
   	}
    if(dialogid == DIALOG_UE)
	{
	    if(response)
	    {
     		if(isnull(inputtext)) return ShowPlayerDialog(playerid, DIALOG_UE, DIALOG_STYLE_INPUT, "editing your update", "please write your update below", "Edit", "Cancel");
			new s[256];
			format(s, sizeof(s), "update%d", updates);
		    if(dini_Isset("updates.ini", s))
      		{
		    	new year, month, day;
       			getdate(year, month, day);
		        new utext[1024];
		        format(utext, sizeof(utext), "%d/%d/%d", day, month, year, inputtext);
		        format(s, sizeof(s), "date%d", updates);
	        	dini_Set("updates.ini", s, utext);
	        	format(s, sizeof(s), "update%d", updates);
	        	format(utext, sizeof(utext), "%s", inputtext);
	        	dini_Set("updates.ini", s, utext);
				format(s, sizeof(s), "Update editted '%s'", inputtext);
				SendClientMessage(playerid, COLOR_YELLOW, s);
		    }
		    else return SendClientMessage(playerid, COLOR_RED, "Error: Update Doesnt Exist!");
	        return 1;
	    }
	    return 1;
	}
	if(dialogid == DIALOG_CONTAINER)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0://Ocean Dock 1
				{
					if(pData[playerid][pJobTime] > 0)
					{
						Error(playerid, "Anda masih mempunyai delays job untuk "RED_E"%d"WHITE_E"Detik", pData[playerid][pJobTime]);
						return 1;
					}

				    if(DialogHauling[0] == false) // Kalau False atau tidak dipilih
				    {
					    DialogHauling[0] = true; // Dialog 0 telah di pilih
					    DialogSaya[playerid][0] = true;
						SendClientMessage(playerid, COLOR_ARWIN,"CONTAINER: {FFFFFF}Go to marked checkpoint on your map");
						SetPlayerRaceCheckpoint(playerid, 1, -591.8328, -550.5755, 25.5296, 0.0, 0.0, 0.0, 10.0);
						pData[playerid][pSedangContainer] = 1;
					}
					else
					    Error(playerid, "Container Missions already taken by Someone");
				}
				case 1://Ocean Dock 1
				{
					if(pData[playerid][pJobTime] > 0)
					{
						Error(playerid, "Anda masih mempunyai delays job untuk "RED_E"%d"WHITE_E"Detik", pData[playerid][pJobTime]);
						return 1;
					}

				    if(DialogHauling[1] == false) // Kalau False atau tidak dipilih
				    {
					    DialogHauling[1] = true; // Dialog 0 telah di pilih
					    DialogSaya[playerid][1] = true;
						SendClientMessage(playerid, COLOR_ARWIN,"CONTAINER: {FFFFFF}Go to marked checkpoint on your map");
						SetPlayerRaceCheckpoint(playerid, 1, -591.8328, -550.5755, 25.5296, 0.0, 0.0, 0.0, 10.0);
						pData[playerid][pSedangContainer] = 3;
					}
					else
					    Error(playerid, "Container Missions already taken by Someone");
				}
				case 2://Ocean Dock 1
				{
					if(pData[playerid][pJobTime] > 0)
					{
						Error(playerid, "Anda masih mempunyai delays job untuk "RED_E"%d"WHITE_E"Detik", pData[playerid][pJobTime]);
						return 1;
					}

				    if(DialogHauling[2] == false) // Kalau False atau tidak dipilih
				    {
					    DialogHauling[2] = true; // Dialog 0 telah di pilih
					    DialogSaya[playerid][2] = true;
						SendClientMessage(playerid, COLOR_ARWIN,"CONTAINER: {FFFFFF}Go to marked checkpoint on your map");
						SetPlayerRaceCheckpoint(playerid, 1, -591.8328, -550.5755, 25.5296, 0.0, 0.0, 0.0, 10.0);
						pData[playerid][pSedangContainer] = 5;
					}
					else
					    Error(playerid, "Container Missions already taken by Someone");
				}
				case 3://Ocean Dock 1
				{
					if(pData[playerid][pJobTime] > 0)
					{
						Error(playerid, "Anda masih mempunyai delays job untuk "RED_E"%d"WHITE_E"Detik", pData[playerid][pJobTime]);
						return 1;
					}

				    if(DialogHauling[3] == false) // Kalau False atau tidak dipilih
				    {
					    DialogHauling[3] = true; // Dialog 0 telah di pilih
					    DialogSaya[playerid][3] = true;
						SendClientMessage(playerid, COLOR_ARWIN,"CONTAINER: {FFFFFF}Go to marked checkpoint on your map");
						SetPlayerRaceCheckpoint(playerid, 1, -591.8328, -550.5755, 25.5296, 0.0, 0.0, 0.0, 10.0);
						pData[playerid][pSedangContainer] = 7;
					}
					else
					    Error(playerid, "Container Missions already taken by Someone");
				}
				case 4://Ocean Dock 1
				{
					if(pData[playerid][pJobTime] > 0)
					{
						Error(playerid, "Anda masih mempunyai delays job untuk "RED_E"%d"WHITE_E"Detik", pData[playerid][pJobTime]);
						return 1;
					}

				    if(DialogHauling[4] == false) // Kalau False atau tidak dipilih
				    {
					    DialogHauling[4] = true; // Dialog 0 telah di pilih
					    DialogSaya[playerid][4] = true;
						SendClientMessage(playerid, COLOR_ARWIN,"CONTAINER: {FFFFFF}Go to marked checkpoint on your map");
						SetPlayerRaceCheckpoint(playerid, 1, -591.8328, -550.5755, 25.5296, 0.0, 0.0, 0.0, 10.0);
						pData[playerid][pSedangContainer] = 9;
					}
					else
					    Error(playerid, "Container Missions already taken by Someone");
				}
				case 5://Ocean Dock 1
				{
					if(pData[playerid][pJobTime] > 0)
					{
						Error(playerid, "Anda masih mempunyai delays job untuk "RED_E"%d"WHITE_E"Detik", pData[playerid][pJobTime]);
						return 1;
					}

				    if(DialogHauling[5] == false) // Kalau False atau tidak dipilih
				    {
					    DialogHauling[5] = true; // Dialog 0 telah di pilih
					    DialogSaya[playerid][5] = true;
						SendClientMessage(playerid, COLOR_ARWIN,"CONTAINER: {FFFFFF}Go to marked checkpoint on your map");
						SetPlayerRaceCheckpoint(playerid, 1, -591.8328, -550.5755, 25.5296, 0.0, 0.0, 0.0, 10.0);
						pData[playerid][pSedangContainer] = 11;
					}
					else
					    Error(playerid, "Container Missions already taken by Someone");
				}
				case 6://Ocean Dock 1
				{
					if(pData[playerid][pJobTime] > 0)
					{
						Error(playerid, "Anda masih mempunyai delays job untuk "RED_E"%d"WHITE_E"Detik", pData[playerid][pJobTime]);
						return 1;
					}

				    if(DialogHauling[6] == false) // Kalau False atau tidak dipilih
				    {
					    DialogHauling[6] = true; // Dialog 0 telah di pilih
					    DialogSaya[playerid][6] = true;
						SendClientMessage(playerid, COLOR_ARWIN,"CONTAINER: {FFFFFF}Go to marked checkpoint on your map");
						SetPlayerRaceCheckpoint(playerid, 1, -591.8328, -550.5755, 25.5296, 0.0, 0.0, 0.0, 10.0);
						pData[playerid][pSedangContainer] = 13;
					}
					else
					    Error(playerid, "Container Missions already taken by Someone");
				}
			}
		}
	}
	if(dialogid == DIALOG_TDMODE)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
					TextDrawHideForPlayer(playerid, TextDate);
					TextDrawHideForPlayer(playerid, TextTime);
					TextDrawHideForPlayer(playerid, TDTime[0]);
					TextDrawHideForPlayer(playerid, TDTime[1]);
					for(new txd; txd < 5; txd++)
					{
						PlayerTextDrawHide(playerid, LogoB[playerid][txd]);
					}

					TextDrawShowForPlayer(playerid, TextDate);
					TextDrawShowForPlayer(playerid, TextTime);
					TextDrawShowForPlayer(playerid, TDTime[0]);
					TextDrawShowForPlayer(playerid, TDTime[1]);
					for(new txd; txd < 5; txd++)
					{
						PlayerTextDrawShow(playerid, LogoB[playerid][txd]);
					}
					pData[playerid][pTDMode] = 1;
				}
				case 1:
				{
					TextDrawHideForPlayer(playerid, TextDate);
					TextDrawHideForPlayer(playerid, TextTime);
					TextDrawHideForPlayer(playerid, TDTime[0]);
					TextDrawHideForPlayer(playerid, TDTime[1]);
					for(new txd; txd < 5; txd++)
					{
						PlayerTextDrawHide(playerid, LogoB[playerid][txd]);
					}

					TextDrawShowForPlayer(playerid, TextDate);
					TextDrawShowForPlayer(playerid, TextTime);
					TextDrawShowForPlayer(playerid, TDTime[0]);
					TextDrawShowForPlayer(playerid, TDTime[1]);
					for(new txd; txd < 5; txd++)
					{
						PlayerTextDrawShow(playerid, LogoB[playerid][txd]);
					}
					pData[playerid][pTDMode] = 2;
				}
				case 2:
				{
					//Hide server td
					TextDrawHideForPlayer(playerid, TextDate);
					TextDrawHideForPlayer(playerid, TextTime);
					TextDrawHideForPlayer(playerid, TDTime[0]);
					TextDrawHideForPlayer(playerid, TDTime[1]);
					for(new txd; txd < 5; txd++)
					{
						PlayerTextDrawHide(playerid, LogoB[playerid][txd]);
					}
					pData[playerid][pTDMode] = 0;
				}
			}
		}
	}
	if(dialogid == DIALOG_CHANGEAGE)
    {
		if(response)
		{
			new
				iDay,
				iMonth,
				iYear,
				day,
				month,
				year;

			getdate(year, month, day);

			static const
					arrMonthDays[] = {31, 29, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31};

			if(sscanf(inputtext, "p</>ddd", iDay, iMonth, iYear)) {
				ShowPlayerDialog(playerid, DIALOG_CHANGEAGE, DIALOG_STYLE_INPUT, "Tanggal Lahir", "Error! Invalid Input\nMasukan tanggal lahir (Tgl/Bulan/Tahun): 15/04/1998", "Pilih", "Batal");
			}
			else if(iYear < 1900 || iYear > year) {
				ShowPlayerDialog(playerid, DIALOG_CHANGEAGE, DIALOG_STYLE_INPUT, "Tahun Lahir", "Error! Invalid Input\nMasukan tanggal lahir (Tgl/Bulan/Tahun): 15/04/1998", "Pilih", "Batal");
			}
			else if(iMonth < 1 || iMonth > 12) {
				ShowPlayerDialog(playerid, DIALOG_CHANGEAGE, DIALOG_STYLE_INPUT, "Bulan Lahir", "Error! Invalid Input\nMasukan tanggal lahir (Tgl/Bulan/Tahun): 15/04/1998", "Pilih", "Batal");
			}
			else if(iDay < 1 || iDay > arrMonthDays[iMonth - 1]) {
				ShowPlayerDialog(playerid, DIALOG_CHANGEAGE, DIALOG_STYLE_INPUT, "Tanggal Lahir", "Error! Invalid Input\nMasukan tanggal lahir (Tgl/Bulan/Tahun): 15/04/1998", "Pilih", "Batal");
			}
			else
			{
				format(pData[playerid][pAge], 50, inputtext);
				Info(playerid, "New Age for your character is "YELLOW_E"%s.", pData[playerid][pAge]);
				GivePlayerMoneyEx(playerid, -300);
				Server_AddMoney(300);
			}
		}
		return 1;
	}
	if(dialogid == DIALOG_PICKUPVEH)
	{
		if(response)
		{
			new id = ReturnAnyVehiclePark((listitem + 1), pData[playerid][pPark]);

			if(pvData[id][cOwner] != pData[playerid][pID]) return Error(playerid, "This is not your Vehicle!");
			pvData[id][cPark] = -1;
			SetVehicleVirtualWorld(pvData[id][cVeh], GetPlayerVirtualWorld(playerid));
			LinkVehicleToInterior(pvData[id][cVeh], GetPlayerInterior(playerid));
			SendClientMessageEx(playerid, COLOR_ARWIN, "GARAGE: "WHITE_E"Your vehicle was successfully removed from the garage.");
			PutPlayerInVehicle(playerid, pvData[id][cVeh], 0);
		}
	}
	if(dialogid == DIALOG_FACTION)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
					new strings[128];
					if(IsValidVehicle(SAPDVehicles[0]))
						return Error(playerid, "Vehicle Sudah Di Spawn");

					SAPDVehicles[0] = CreateVehicle(596,1602.0660,-1683.9678,5.6124,90.3080,0,1, VEHICLE_RESPAWN, 1); // Cruiser
					format(strings, sizeof(strings), "Adam-0");
					SetVehicleNumberPlate(SAPDVehicles[0], strings);
					SetVehicleToRespawn(SAPDVehicles[0]);
					PutPlayerInVehicle(playerid, SAPDVehicles[0], 0);
				}
				case 1:
				{
					new strings[128];
					if(IsValidVehicle(SAPDVehicles[1]))
						return Error(playerid, "Vehicle Sudah Di Spawn");

					SAPDVehicles[1] = CreateVehicle(596,1602.1194,-1687.9663,5.6107,90.5233,0,1, VEHICLE_RESPAWN, 1); // Cruiser
					format(strings, sizeof(strings), "Adam-1");
					SetVehicleNumberPlate(SAPDVehicles[1], strings);
					SetVehicleToRespawn(SAPDVehicles[1]);
					PutPlayerInVehicle(playerid, SAPDVehicles[1], 0);
				}
				case 2:
				{
					new strings[128];
					if(IsValidVehicle(SAPDVehicles[2]))
						return Error(playerid, "Vehicle Sudah Di Spawn");

					SAPDVehicles[2] = CreateVehicle(596,1602.1680,-1692.0110,5.6113,89.5516,0,1, VEHICLE_RESPAWN, 1); // Cruiser
					format(strings, sizeof(strings), "Adam-2");
					SetVehicleNumberPlate(SAPDVehicles[2], strings);
					SetVehicleToRespawn(SAPDVehicles[2]);
					PutPlayerInVehicle(playerid, SAPDVehicles[2], 0);
				}
				case 3:
				{
					new strings[128];
					if(IsValidVehicle(SAPDVehicles[3]))
						return Error(playerid, "Vehicle Sudah Di Spawn");

					SAPDVehicles[3] = CreateVehicle(596,1602.1666,-1696.1469,5.6123,90.4002,0,1, VEHICLE_RESPAWN, 1); // Cruiser
					format(strings, sizeof(strings), "Adam-3");
					SetVehicleNumberPlate(SAPDVehicles[3], strings);
					SetVehicleToRespawn(SAPDVehicles[3]);
					PutPlayerInVehicle(playerid, SAPDVehicles[3], 0);
				}
				case 4:
				{
					new strings[128];
					if(IsValidVehicle(SAPDVehicles[4]))
						return Error(playerid, "Vehicle Sudah Di Spawn");

					SAPDVehicles[4] = CreateVehicle(560,1584.7515,-1667.5281,5.5974,270.7136,0,0, VEHICLE_RESPAWN, 1); // Sultan
					format(strings, sizeof(strings), "Staff-1");
					SetVehicleNumberPlate(SAPDVehicles[4], strings);
					SetVehicleToRespawn(SAPDVehicles[4]);
					PutPlayerInVehicle(playerid, SAPDVehicles[4], 0);
				}
				case 5:
				{
					new strings[128];
					if(IsValidVehicle(SAPDVehicles[5]))
						return Error(playerid, "Vehicle Sudah Di Spawn");

					SAPDVehicles[5] = CreateVehicle(560,1584.7291,-1671.6987,5.5982,268.7675,0,0, VEHICLE_RESPAWN, 1); // Sultan
					format(strings, sizeof(strings), "Staff-2");
					SetVehicleNumberPlate(SAPDVehicles[5], strings);
					SetVehicleToRespawn(SAPDVehicles[5]);
					PutPlayerInVehicle(playerid, SAPDVehicles[5], 0);
				}
				case 6:
				{
					new strings[128];
					if(IsValidVehicle(SAPDVehicles[6]))
						return Error(playerid, "Vehicle Sudah Di Spawn");

					SAPDVehicles[6] = CreateVehicle(522,1562.4324,-1710.7955,5.8906,0.0933,0,1, VEHICLE_RESPAWN, 1); // NRG-500
					format(strings, sizeof(strings), "Rapid-1");
					SetVehicleNumberPlate(SAPDVehicles[6], strings);
					SetVehicleToRespawn(SAPDVehicles[6]);
					PutPlayerInVehicle(playerid, SAPDVehicles[6], 0);
				}
				case 7:
				{
					new strings[128];
					if(IsValidVehicle(SAPDVehicles[7]))
						return Error(playerid, "Vehicle Sudah Di Spawn");

					SAPDVehicles[7] = CreateVehicle(522,1566.4917,-1710.3234,5.8906,0.8341,0,1, VEHICLE_RESPAWN, 1); // NRG-500
					format(strings, sizeof(strings), "Rapid-2");
					SetVehicleNumberPlate(SAPDVehicles[7], strings);
					SetVehicleToRespawn(SAPDVehicles[7]);
					PutPlayerInVehicle(playerid, SAPDVehicles[7], 0);
				}
			}
		}
		return 1;
	}
	if(dialogid == DIALOG_FACTION1)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
					new strings[128];
					if(IsValidVehicle(SAPDVehicles[10]))
						return Error(playerid, "Vehicle Sudah Di Spawn");

					SAPDVehicles[10] = CreateVehicle(497,1569.1587,-1641.0361,28.5788,89.5537,0,1, VEHICLE_RESPAWN, 1); // Maverick
					format(strings, sizeof(strings), "Air-1");
					SetVehicleNumberPlate(SAPDVehicles[10], strings);
					SetVehicleToRespawn(SAPDVehicles[10]);
					PutPlayerInVehicle(playerid, SAPDVehicles[10], 0);
				}
				case 1:
				{
					new strings[128];
					if(IsValidVehicle(SAPDVehicles[11]))
						return Error(playerid, "Vehicle Sudah Di Spawn");

					SAPDVehicles[11] = CreateVehicle(497,1547.7992,-1643.6317,28.5923,91.2595,0,1, VEHICLE_RESPAWN, 1); // Maverick
					format(strings, sizeof(strings), "Air-2");
					SetVehicleNumberPlate(SAPDVehicles[11], strings);
					SetVehicleToRespawn(SAPDVehicles[11]);
					PutPlayerInVehicle(playerid, SAPDVehicles[11], 0);
				}
				case 2:
				{
					new strings[128];
					if(IsValidVehicle(SAPDVehicles[12]))
						return Error(playerid, "Vehicle Sudah Di Spawn");

					SAPDVehicles[12] = CreateVehicle(411,1578.5643,-1710.6968,5.6112,0.0933,0,1, VEHICLE_RESPAWN, 1); // Infernus
					format(strings, sizeof(strings), "Adam-1");
					SetVehicleNumberPlate(SAPDVehicles[12], strings);
					SetVehicleToRespawn(SAPDVehicles[12]);
					PutPlayerInVehicle(playerid, SAPDVehicles[12], 0);
				}
				case 3:
				{
					new strings[128];
					if(IsValidVehicle(SAPDVehicles[13]))
						return Error(playerid, "Vehicle Sudah Di Spawn");

					SAPDVehicles[13] = CreateVehicle(411,1574.3217,-1710.7924,5.6117,0.8341,0,1, VEHICLE_RESPAWN, 1); // Infernus
					format(strings, sizeof(strings), "Hotel-2");
					SetVehicleNumberPlate(SAPDVehicles[13], strings);
					SetVehicleToRespawn(SAPDVehicles[13]);
					PutPlayerInVehicle(playerid, SAPDVehicles[13], 0);
				}
				case 4:
				{
					new strings[128];
					if(IsValidVehicle(SAPDVehicles[14]))
						return Error(playerid, "Vehicle Sudah Di Spawn");

					SAPDVehicles[14] = CreateVehicle(528,1527.6542,-1655.9646,5.9339,270.1992,0,0, VEHICLE_RESPAWN, 1); // SWAT Van
					format(strings, sizeof(strings), "Panzer-1");
					SetVehicleNumberPlate(SAPDVehicles[14], strings);
					SetVehicleToRespawn(SAPDVehicles[14]);
					PutPlayerInVehicle(playerid, SAPDVehicles[14], 0);
				}
				case 5:
				{
					new strings[128];
					if(IsValidVehicle(SAPDVehicles[15]))
						return Error(playerid, "Vehicle Sudah Di Spawn");

					SAPDVehicles[15] = CreateVehicle(523,1584.7783,-1675.3850,5.4639,270.6620,0,0, VEHICLE_RESPAWN, 1); // Police Bike
					format(strings, sizeof(strings), "Marry-1");
					SetVehicleNumberPlate(SAPDVehicles[15], strings);
					SetVehicleToRespawn(SAPDVehicles[15]);
					PutPlayerInVehicle(playerid, SAPDVehicles[15], 0);
				}
				case 6:
				{
					new strings[128];
					if(IsValidVehicle(SAPDVehicles[16]))
						return Error(playerid, "Vehicle Sudah Di Spawn");

					SAPDVehicles[16] = CreateVehicle(601,1526.5850,-1644.1801,5.6494,180.3210,1,1, VEHICLE_RESPAWN, 1); // Splashy
					format(strings, sizeof(strings), "Rapid-1");
					SetVehicleNumberPlate(SAPDVehicles[16], strings);
					SetVehicleToRespawn(SAPDVehicles[16]);
					PutPlayerInVehicle(playerid, SAPDVehicles[16], 0);
				}
				case 7:
				{
					new strings[128];
					if(IsValidVehicle(SAPDVehicles[17]))
						return Error(playerid, "Vehicle Sudah Di Spawn");

					SAPDVehicles[17] = CreateVehicle(601,1530.7244,-1644.2538,5.6494,179.6148,1,1, VEHICLE_RESPAWN, 1); // Splashy
					format(strings, sizeof(strings), "Rapid-2");
					SetVehicleNumberPlate(SAPDVehicles[17], strings);
					SetVehicleToRespawn(SAPDVehicles[17]);
					PutPlayerInVehicle(playerid, SAPDVehicles[17], 0);
				}
			}
		}
		return 1;
	}
	if(dialogid == DIALOG_FACTION2)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
					new strings[128];
					if(IsValidVehicle(SAGSVehicles[0]))
						return Error(playerid, "Vehicle Sudah Di Spawn");

					SAGSVehicles[0] = CreateVehicle(405, 1507.6377, -1747.9199, 13.5757, 0.0000, 0, 0, VEHICLE_RESPAWN);
					format(strings, sizeof(strings), "SAGS-0");
					SetVehicleNumberPlate(SAGSVehicles[0], strings);
					SetVehicleToRespawn(SAGSVehicles[0]);
					PutPlayerInVehicle(playerid, SAGSVehicles[0], 0);
				}
				case 1:
				{
					new strings[128];
					if(IsValidVehicle(SAGSVehicles[1]))
						return Error(playerid, "Vehicle Sudah Di Spawn");

					SAGSVehicles[1] = CreateVehicle(405, 1455.3049, -1748.5181, 13.3789, 0.0000, 0, 0, VEHICLE_RESPAWN);
					format(strings, sizeof(strings), "SAGS-1");
					SetVehicleNumberPlate(SAGSVehicles[1], strings);
					SetVehicleToRespawn(SAGSVehicles[1]);
					PutPlayerInVehicle(playerid, SAGSVehicles[1], 0);
				}
				case 2:
				{
					new strings[128];
					if(IsValidVehicle(SAGSVehicles[2]))
						return Error(playerid, "Vehicle Sudah Di Spawn");

					SAGSVehicles[2] = CreateVehicle(411, 1524.1866, -1846.0491, 13.3714, 0.0000, 0, 0, VEHICLE_RESPAWN);
					format(strings, sizeof(strings), "SAGS-2");
					SetVehicleNumberPlate(SAGSVehicles[2], strings);
					SetVehicleToRespawn(SAGSVehicles[2]);
					PutPlayerInVehicle(playerid, SAGSVehicles[2], 0);
				}
				case 3:
				{
					new strings[128];
					if(IsValidVehicle(SAGSVehicles[3]))
						return Error(playerid, "Vehicle Sudah Di Spawn");

					SAGSVehicles[3] = CreateVehicle(411, 1534.8187, -1845.9094, 13.3714, 0.0000, 0, 0, VEHICLE_RESPAWN);
					format(strings, sizeof(strings), "SAGS-3");
					SetVehicleNumberPlate(SAGSVehicles[3], strings);
					SetVehicleToRespawn(SAGSVehicles[3]);
					PutPlayerInVehicle(playerid, SAGSVehicles[3], 0);
				}
				case 4:
				{
					new strings[128];
					if(IsValidVehicle(SAGSVehicles[4]))
						return Error(playerid, "Vehicle Sudah Di Spawn");

					SAGSVehicles[4] = CreateVehicle(411, 1529.4353, -1845.9347, 13.3714, 0.0000, 0, 0, VEHICLE_RESPAWN);
					format(strings, sizeof(strings), "SAGS-4");
					SetVehicleNumberPlate(SAGSVehicles[4], strings);
					SetVehicleToRespawn(SAGSVehicles[4]);
					PutPlayerInVehicle(playerid, SAGSVehicles[4], 0);
				}
				case 5:
				{
					new strings[128];
					if(IsValidVehicle(SAGSVehicles[5]))
						return Error(playerid, "Vehicle Sudah Di Spawn");

					SAGSVehicles[5] = CreateVehicle(521, 1512.8479, -1846.1010, 13.0548, 0.0000, 0, 0, VEHICLE_RESPAWN);
					format(strings, sizeof(strings), "SAGS-5");
					SetVehicleNumberPlate(SAGSVehicles[5], strings);
					SetVehicleToRespawn(SAGSVehicles[5]);
					PutPlayerInVehicle(playerid, SAGSVehicles[5], 0);
				}
				case 6:
				{
					new strings[128];
					if(IsValidVehicle(SAGSVehicles[6]))
						return Error(playerid, "Vehicle Sudah Di Spawn");

					SAGSVehicles[6] = CreateVehicle(521, 1519.4961, -1846.0326, 13.0548, 0.0000, 0, 0, VEHICLE_RESPAWN);
					format(strings, sizeof(strings), "SAGS-6");
					SetVehicleNumberPlate(SAGSVehicles[6], strings);
					SetVehicleToRespawn(SAGSVehicles[6]);
					PutPlayerInVehicle(playerid, SAGSVehicles[6], 0);
				}
				case 7:
				{
					new strings[128];
					if(IsValidVehicle(SAGSVehicles[7]))
						return Error(playerid, "Vehicle Sudah Di Spawn");

					SAGSVehicles[7] = CreateVehicle(437, 1494.1495, -1845.1425, 13.5694, -91.0000, 0, 0, VEHICLE_RESPAWN);
					format(strings, sizeof(strings), "SAGS-7");
					SetVehicleNumberPlate(SAGSVehicles[7], strings);
					SetVehicleToRespawn(SAGSVehicles[7]);
					PutPlayerInVehicle(playerid, SAGSVehicles[7], 0);
				}
			}
		}
		return 1;
	}
	if(dialogid == DIALOG_FACTION3)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
					new strings[128];
					if(IsValidVehicle(SAMDVehicles[0]))
						return Error(playerid, "Vehicle Sudah Di Spawn");

					SAMDVehicles[0] = CreateVehicle(407, 1111.0358, -1328.3903, 13.6102, 0.0000, -1, 3, VEHICLE_RESPAWN, 1);
					format(strings, sizeof(strings), "SAFD-0");
					SetVehicleNumberPlate(SAMDVehicles[0], strings);
					SetVehicleToRespawn(SAMDVehicles[0]);
					PutPlayerInVehicle(playerid, SAMDVehicles[0], 0);
				}
				case 1:
				{
					new strings[128];
					if(IsValidVehicle(SAMDVehicles[1]))
						return Error(playerid, "Vehicle Sudah Di Spawn");

					SAMDVehicles[1] = CreateVehicle(407, 1098.1630, -1328.7020, 13.7072, 0.0000, -1, 3, VEHICLE_RESPAWN, 1);
					format(strings, sizeof(strings), "SAFD-1");
					SetVehicleNumberPlate(SAMDVehicles[1], strings);
					SetVehicleToRespawn(SAMDVehicles[1]);
					PutPlayerInVehicle(playerid, SAMDVehicles[1], 0);
				}
				case 2:
				{
					new strings[128];
					if(IsValidVehicle(SAMDVehicles[2]))
						return Error(playerid, "Vehicle Sudah Di Spawn");

					SAMDVehicles[2] = CreateVehicle(544, 1124.4944, -1327.0439, 13.9194, 0.0000, -1, 3, VEHICLE_RESPAWN, 1);
					format(strings, sizeof(strings), "SAFD-2");
					SetVehicleNumberPlate(SAMDVehicles[2], strings);
					SetVehicleToRespawn(SAMDVehicles[2]);
					PutPlayerInVehicle(playerid, SAMDVehicles[2], 0);
				}
				case 3:
				{
					new strings[128];
					if(IsValidVehicle(SAMDVehicles[3]))
						return Error(playerid, "Vehicle Sudah Di Spawn");

					SAMDVehicles[3] = CreateVehicle(416, 1116.0294, -1296.6489, 13.6160, 179.4438, 1, 3, VEHICLE_RESPAWN, 1);
					format(strings, sizeof(strings), "SAFD-3");
					SetVehicleNumberPlate(SAMDVehicles[3], strings);
					SetVehicleToRespawn(SAMDVehicles[3]);
					PutPlayerInVehicle(playerid, SAMDVehicles[3], 0);
				}
				case 4:
				{
					new strings[128];
					if(IsValidVehicle(SAMDVehicles[4]))
						return Error(playerid, "Vehicle Sudah Di Spawn");

					SAMDVehicles[4] = CreateVehicle(416, 1125.8785, -1296.2780, 13.6160, 179.4438, 1, 3, VEHICLE_RESPAWN, 1);
					format(strings, sizeof(strings), "SAFD-4");
					SetVehicleNumberPlate(SAMDVehicles[4], strings);
					SetVehicleToRespawn(SAMDVehicles[4]);
					PutPlayerInVehicle(playerid, SAMDVehicles[4], 0);
				}
				case 5:
				{
					new strings[128];
					if(IsValidVehicle(SAMDVehicles[5]))
						return Error(playerid, "Vehicle Sudah Di Spawn");

					SAMDVehicles[5] = CreateVehicle(416, 1121.1556, -1296.4138, 13.6160, 179.4438, 1, 3, VEHICLE_RESPAWN, 1);
					format(strings, sizeof(strings), "SAFD-5");
					SetVehicleNumberPlate(SAMDVehicles[5], strings);
					SetVehicleToRespawn(SAMDVehicles[5]);
					PutPlayerInVehicle(playerid, SAMDVehicles[5], 0);
				}
				case 6:
				{
					new strings[128];
					if(IsValidVehicle(SAMDVehicles[6]))
						return Error(playerid, "Vehicle Sudah Di Spawn");

					SAMDVehicles[6] = CreateVehicle(442, 1111.1719, -1296.7606, 13.4886, 185.0000, 0, 1, VEHICLE_RESPAWN, 1);
					format(strings, sizeof(strings), "SAFD-6");
					SetVehicleNumberPlate(SAMDVehicles[6], strings);
					SetVehicleToRespawn(SAMDVehicles[6]);
					PutPlayerInVehicle(playerid, SAMDVehicles[6], 0);
				}
				case 7:
				{
					new strings[128];
					if(IsValidVehicle(SAMDVehicles[7]))
						return Error(playerid, "Vehicle Sudah Di Spawn");

					SAMDVehicles[7] = CreateVehicle(426, 1136.0360, -1341.2158, 13.3050, 0.0000, 0, 1, VEHICLE_RESPAWN, 1);
					format(strings, sizeof(strings), "SAFD-7");
					SetVehicleNumberPlate(SAMDVehicles[7], strings);
					SetVehicleToRespawn(SAMDVehicles[7]);
					PutPlayerInVehicle(playerid, SAMDVehicles[7], 0);
				}
			}
		}
		return 1;
	}
	if(dialogid == DIALOG_GOLDSHOP)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
					if(pData[playerid][pGold] < 500) return Error(playerid, "Not enough gold!");
					ShowPlayerDialog(playerid, DIALOG_GOLDNAME, DIALOG_STYLE_INPUT, "Change Name", "Input new nickname:\nExample: Charles_Sanders\n", "Change", "Cancel");
				}
				case 1:
				{
					if(pData[playerid][pGold] < 1000) return Error(playerid, "Not enough gold!");
					pData[playerid][pGold] -= 1000;
					pData[playerid][pWarn] = 0;
					Info(playerid, "Warning have been reseted for 1000 gold. Total Warning: 0");
				}
				case 2:
				{
					Info(playerid, "Belum ada.");
				}
				case 3:
				{
					if(pData[playerid][pGold] < 150) return Error(playerid, "Not enough gold!");
					pData[playerid][pGold] -= 150;
					pData[playerid][pVip] = 1;
					pData[playerid][pVipTime] = gettime() + (7 * 86400);
					Info(playerid, "You has bought VIP level 1 for 150 gold(7 days).");
				}
				case 4:
				{
					if(pData[playerid][pGold] < 250) return Error(playerid, "Not enough gold!");
					pData[playerid][pGold] -= 250;
					pData[playerid][pVip] = 2;
					pData[playerid][pVipTime] = gettime() + (7 * 86400);
					Info(playerid, "You has bought VIP level 2 for 250 gold(7 days).");
				}
				case 5:
				{
					if(pData[playerid][pGold] < 500) return Error(playerid, "Not enough gold!");
					pData[playerid][pGold] -= 500;
					pData[playerid][pVip] = 3;
					pData[playerid][pVipTime] = gettime() + (7 * 86400);
					Info(playerid, "You has bought VIP level 3 for 500 gold(7 days).");
				}
			}
		}
		return 1;
	}
	/*
	if(dialogid == DIALOG_GOLDNAME)
	{
		if(response)
		{
			if(strlen(inputtext) < 4) return Error(playerid, "New name can't be shorter than 4 characters!"),  ShowPlayerDialog(playerid, DIALOG_GOLDNAME, DIALOG_STYLE_INPUT, ""WHITE_E"Change Name", "Enter your new name:", "Enter", "Exit");
			if(strlen(inputtext) > 20) return Error(playerid, "New name can't be longer than 20 characters!"),  ShowPlayerDialog(playerid, DIALOG_GOLDNAME, DIALOG_STYLE_INPUT, ""WHITE_E"Change Name", "Enter your new name:", "Enter", "Exit");
			if(!IsValidRoleplayName(inputtext))
			{
				Error(playerid, "Name contains invalid characters, please doublecheck!");
				ShowPlayerDialog(playerid, DIALOG_GOLDNAME, DIALOG_STYLE_INPUT, ""WHITE_E"Change Name", "Enter your new name:", "Enter", "Exit");
				return 1;
			}
			new query[512];
			mysql_format(g_SQL, query, sizeof(query), "SELECT username FROM players WHERE username='%s'", inputtext);
			mysql_tquery(g_SQL, query, "ChangeName", "is", playerid, inputtext);
		}
		return 1;
	}
	if(dialogid == WS_MENU)
	{
		if(response)
		{
			new id = pData[playerid][pInWs];
			switch(listitem)
			{
				case 0:
				{
					if(!IsWorkshopOwner(playerid, id))
						return Error(playerid, "Only Workshop Owner who can use this");

					new str[256];
					format(str, sizeof str,"Current Workshop Name:\n%s\n\nInput new name to Change Workshop Name", wsData[id][wName]);
					ShowPlayerDialog(playerid, WS_SETNAME, DIALOG_STYLE_INPUT, "Change Workshop Name", str,"Change","Cancel");
				}
				case 1:
				{
					new str[556];
					format(str, sizeof str,"Name\tRank\n(%s)\tOwner\n",wsData[id][wOwner]);
					for(new z = 0; z < MAX_WORKSHOP_EMPLOYEE; z++)
					{
						format(str, sizeof str,"%s(%s)\tEmploye\n", str, wsEmploy[id][z]);
					}
					ShowPlayerDialog(playerid, WS_SETEMPLOYE, DIALOG_STYLE_TABLIST_HEADERS, "Employe Menu", str, "Change","Cancel");
				}
				case 2:
				{
					ShowPlayerDialog(playerid, WS_COMPONENT, DIALOG_STYLE_LIST, "Workshop Component", "Withdraw\nDeposit", "Select","Cancel");
				}
				case 3:
				{
					ShowPlayerDialog(playerid, WS_MATERIAL, DIALOG_STYLE_LIST, "Workshop Material", "Withdraw\nDeposit", "Select","Cancel");
				}
				case 4:
				{
					ShowPlayerDialog(playerid, WS_MONEY, DIALOG_STYLE_LIST, "Workshop Money", "Withdraw\nDeposit", "Select","Cancel");
				}
			}
		}
	}
	if(dialogid == WS_SETNAME)
	{
		if(response)
		{
			new id = pData[playerid][pInWs];

			if(!IsWorkshopOwner(playerid, id))
				return Error(playerid, "Only Workshop Owner who can use this");

			if(strlen(inputtext) > 24) 
				return Error(playerid, "Maximal 24 Character");

			if(strfind(inputtext, "'", true) != -1)
				return Error(playerid, "You can't put ' in Workshop Name");
			
			SendClientMessageEx(playerid, ARWIN, "WORKSHOP: {ffffff}You've successfully set Workshop Name from {ffff00}%s{ffffff} to {7fffd4}%s", wsData[id][wName], inputtext);
			format(wsData[id][wName], 24, inputtext);
			Workshop_Save(id);
			Workshop_Refresh(id);
		}
	}
	if(dialogid == WS_SETEMPLOYE)
	{
		if(response)
		{
			new id = pData[playerid][pInWs], str[256];

			if(!IsWorkshopOwner(playerid, id))
				return Error(playerid, "Only Workshop Owner who can use this");

			switch(listitem)
			{
				case 0:
				{
					pData[playerid][pMenuType] = 0;
					format(str, sizeof str, "Current Owner:\n%s\n\nInput Player ID/Name to Change Ownership", wsData[id][wOwner]);
				}
				case 1:
				{
					pData[playerid][pMenuType] = 1;
					format(str, sizeof str, "Current Employe:\n%s\n\nInput Player ID/Name to Change", wsEmploy[id][0]);
				}
				case 2:
				{
					pData[playerid][pMenuType] = 2;
					format(str, sizeof str, "Current Employe:\n%s\n\nInput Player ID/Name to Change", wsEmploy[id][1]);
				}
				case 3:
				{
					pData[playerid][pMenuType] = 3;
					format(str, sizeof str, "Current Employe:\n%s\n\nInput Player ID/Name to Change", wsEmploy[id][2]);
				}
			}
			ShowPlayerDialog(playerid, WS_SETEMPLOYEE, DIALOG_STYLE_INPUT, "Employe Menu", str, "Change", "Cancel");
		}
	}
	if(dialogid == WS_SETEMPLOYEE)
	{
		if(response)
		{
			new otherid, id = pData[playerid][pInWs], eid = pData[playerid][pMenuType];
			if(!strcmp(inputtext, "-", true))
			{
				SendClientMessageEx(playerid, ARWIN, "WORKSHOP: {ffffff}You've successfully removed %s from Workshop", wsEmploy[id][(eid - 1)]);
				format(wsEmploy[id][(eid - 1)], MAX_PLAYER_NAME, "-");
				Workshop_Save(id);
				return 1;
			}

			if(sscanf(inputtext,"u", otherid))
				return Error(playerid, "You must put Player ID/Name");

			if(!IsWorkshopOwner(playerid, id))
				return Error(playerid, "Only Workshop Owner who can use this");

			if(otherid == INVALID_PLAYER_ID || !NearPlayer(playerid, otherid, 5.0))
				return Error(playerid, "Player itu Disconnect or not near you.");

			if(otherid == playerid)
				return Error(playerid, "You can't set to yourself as owner.");

			if(eid == 0)
			{
				new str[128];
				pData[playerid][pTransferWS] = otherid;
				format(str, sizeof str,"Are you sure want to transfer ownership to %s?", ReturnName(otherid));
				ShowPlayerDialog(playerid, WS_SETOWNERCONFIRM, DIALOG_STYLE_MSGBOX, "Transfer Ownership", str,"Confirm","Cancel");
			}
			else if(eid > 0 && eid < 4)
			{
				format(wsEmploy[id][(eid - 1)], MAX_PLAYER_NAME, pData[otherid][pName]);
				SendClientMessageEx(playerid, ARWIN, "WORKSHOP: {ffffff}You've successfully add %s to Workshop", pData[otherid][pName]);
				SendClientMessageEx(otherid, ARWIN, "WORKSHOP: {ffffff}You've been hired in Workshop %s by %s", wsData[id][wName], pData[playerid][pName]);
				Workshop_Save(id);
			}
			Workshop_Save(id);
			Workshop_Refresh(id);
		}
	}
	if(dialogid == WS_SETOWNERCONFIRM)
	{
		if(!response) 
			pData[playerid][pTransferWS] = INVALID_PLAYER_ID;

		new otherid = pData[playerid][pTransferWS], id = pData[playerid][pInWs];
		if(response)
		{
			if(otherid == INVALID_PLAYER_ID || !NearPlayer(playerid, otherid, 5.0))
				return Error(playerid, "Player itu Disconnect or not near you.");

			SendClientMessageEx(playerid, ARWIN, "WORKSHOP: {ffffff}You've successfully transfered %s Workshop to %s",wsData[id][wName], pData[otherid][pName]);
			SendClientMessageEx(otherid, ARWIN, "WORKSHOP: {ffffff}You've been transfered to owner in %s Workshop by %s", wsData[id][wName], pData[playerid][pName]);
			format(wsData[id][wOwner], MAX_PLAYER_NAME, pData[otherid][pName]);
			Workshop_Save(id);
			Workshop_Refresh(id);
		}
	}
	if(dialogid == WS_COMPONENT)
	{
		if(response)
		{
			new str[256], id = pData[playerid][pInWs];
			switch(listitem)
			{
				case 0:
				{
					pData[playerid][pMenuType] = 1;
					format(str, sizeof str,"Current Component: %d\n\nPlease Input amount to Withdraw", wsData[id][wComp]);
				}
				case 1:
				{
					pData[playerid][pMenuType] = 2;
					format(str, sizeof str,"Current Component: %d\n\nPlease Input amount to Deposit", wsData[id][wComp]);
				}
			}
			ShowPlayerDialog(playerid, WS_COMPONENT2, DIALOG_STYLE_INPUT, "Component Menu", str, "Input","Cancel");
		}
	}
	if(dialogid == WS_COMPONENT2)
	{
		if(response)
		{
			new amount = strval(inputtext), id = pData[playerid][pInWs];
			if(pData[playerid][pMenuType] == 1)
			{
				if(amount < 1)
					return Error(playerid, "Minimum amount is 1");

				if(wsData[id][wComp] < amount) return Error(playerid, "Not Enough Workshop Component");

				if((pData[playerid][pComponent] + amount) >= 510)
					return Error(playerid, "You've reached maximum of Component");

				pData[playerid][pComponent] += amount;
				wsData[id][wComp] -= amount;
				Workshop_Save(id);
				Info(playerid, "You've successfully withdraw %d Component from Workshop", amount);
			}
			else if(pData[playerid][pMenuType] == 2)
			{
				if(amount < 1)
					return Error(playerid, "Minimum amount is 1");

				if(pData[playerid][pComponent] < amount) return Error(playerid, "Not Enough Component");

				if((wsData[id][wComp] + amount) >= MAX_WORKSHOP_INT)
					return Error(playerid, "You've reached maximum of Component");

				pData[playerid][pComponent] -= amount;
				wsData[id][wComp] += amount;
				Workshop_Save(id);
				Info(playerid, "You've successfully deposit %d Component to Workshop", amount);
			}
		}
	}
	if(dialogid == WS_MATERIAL)
	{
		if(response)
		{
			new str[256], id = pData[playerid][pInWs];
			switch(listitem)
			{
				case 0:
				{
					pData[playerid][pMenuType] = 1;
					format(str, sizeof str,"Current Material: %d\n\nPlease Input amount to Withdraw", wsData[id][wMat]);
				}
				case 1:
				{
					pData[playerid][pMenuType] = 2;
					format(str, sizeof str,"Current Material: %d\n\nPlease Input amount to Deposit", wsData[id][wMat]);
				}
			}
			ShowPlayerDialog(playerid, WS_MATERIAL2, DIALOG_STYLE_INPUT, "Material Menu", str, "Input","Cancel");
		}
	}
	if(dialogid == WS_MATERIAL2)
	{
		if(response)
		{
			new amount = strval(inputtext), id = pData[playerid][pInWs];
			if(pData[playerid][pMenuType] == 1)
			{
				if(amount < 1)
					return Error(playerid, "Minimum amount is 1");

				if(wsData[id][wMat] < amount) return Error(playerid, "Not Enough Workshop Material");

				if((pData[playerid][pMaterial] + amount) >= 500)
					return Error(playerid, "You've reached maximum of Material");

				pData[playerid][pMaterial] += amount;
				wsData[id][wMat] -= amount;
				Workshop_Save(id);
				Info(playerid, "You've successfully withdraw %d Material from Workshop", amount);
			}
			else if(pData[playerid][pMenuType] == 2)
			{
				if(amount < 1)
					return Error(playerid, "Minimum amount is 1");

				if(pData[playerid][pMaterial] < amount) return Error(playerid, "Not Enough Material");

				if((wsData[id][wMat] + amount) >= MAX_WORKSHOP_INT)
					return Error(playerid, "You've reached maximum of Material");

				pData[playerid][pMaterial] -= amount;
				wsData[id][wMat] += amount;
				Workshop_Save(id);
				Info(playerid, "You've successfully deposit %d Material to Workshop", amount);
			}
		}
	}
	if(dialogid == WS_MONEY)
	{
		if(response)
		{
			new id = pData[playerid][pInWs];
			switch(listitem)
			{
				case 0:
				{
					if(!IsWorkshopOwner(playerid, id))
						return Error(playerid, "Only Workshop Owner who can use this");

					//format(str, sizeof str, "Input Amount to Withdraw");
					ShowPlayerDialog(playerid, WS_WITHDRAWMONEY, DIALOG_STYLE_INPUT, "Withdraw Workshop Money","Input Amount to Withdraw","Withdraw","Cancel");
				}
				case 1:
				{
					//format(str, sizeof str, "Input Amount to Deposit");
					ShowPlayerDialog(playerid, WS_DEPOSITMONEY, DIALOG_STYLE_INPUT, "Deposit Workshop Money","Input Amount to Deposit","Deposit","Cancel");
				}
			}
		}
	}
	if(dialogid == WS_WITHDRAWMONEY)
	{
		if(response)
		{
			new amount = strval(inputtext), id = pData[playerid][pInWs];

			if(amount < 1)
				return Error(playerid, "Minimum amount is $1");

			if(wsData[id][wMoney] < amount)
				return Error(playerid, "Not Enough Workshop Money");

			GivePlayerMoneyEx(playerid, amount);
			wsData[id][wMoney] -= amount;
			Workshop_Save(id);
		}
	}
	if(dialogid == WS_DEPOSITMONEY)
	{
		if(response)
		{
			new amount = strval(inputtext), id = pData[playerid][pInWs];
			
			if(amount < 1)
				return Error(playerid, "Minimum amount is $1");

			if(pData[playerid][pMoney] < amount)
				return Error(playerid, "Not Enough Money");

			GivePlayerMoneyEx(playerid, -amount);
			wsData[id][wMoney] += amount;
			Workshop_Save(id);
		}
	}
	if(dialogid == DIALOG_TRACKWS)
	{
		if(response)
		{
			new wid = ReturnWorkshopID((listitem + 1));

			pData[playerid][pLoc] = wid;
			SetPlayerRaceCheckpoint(playerid,1, wsData[wid][wX], wsData[wid][wY], wsData[wid][wZ], 0.0, 0.0, 0.0, 3.5);
			Info(playerid, "Workshop Checkpoint targeted! (%s)", GetLocation(wsData[wid][wX], wsData[wid][wY], wsData[wid][wZ]));
		}
	}
	if(dialogid == DIALOG_MY_WS)
	{
		if(!response) return true;
		new id = ReturnPlayerWorkshopID(playerid, (listitem + 1));
		SetPlayerRaceCheckpoint(playerid,1, wsData[id][wX], wsData[id][wY], wsData[id][wZ], 0.0, 0.0, 0.0, 3.5);
		Info(playerid, "Ikuti checkpoint untuk menemukan Business anda!");
		return 1;
	}
	*/
	//-----------[ Bisnis Dialog ]------------
	if(dialogid == DIALOG_SELL_BISNISS)
	{
		if(!response) return 1;
		new str[248];
		SetPVarInt(playerid, "SellingBisnis", ReturnPlayerBisnisID(playerid, (listitem + 1)));
		format(str, sizeof(str), "Are you sure you will sell bisnis id: %d", GetPVarInt(playerid, "SellingBisnis"));

		ShowPlayerDialog(playerid, DIALOG_SELL_BISNIS, DIALOG_STYLE_MSGBOX, "Sell Bisnis", str, "Sell", "Cancel");
	}
	if(dialogid == DIALOG_SELL_BISNIS)
	{
		if(response)
		{
			new bid = GetPVarInt(playerid, "SellingBisnis"), price;
			price = bData[bid][bPrice] / 2;
			GivePlayerMoneyEx(playerid, price);
			Info(playerid, "Anda berhasil menjual bisnis id (%d) dengan setengah harga("LG_E"%s"WHITE_E") pada saat anda membelinya.", bid, FormatMoney(price));
			Bisnis_Reset(bid);
			Bisnis_Save(bid);
			Bisnis_Refresh(bid);
		}
		DeletePVar(playerid, "SellingBisnis");
		return 1;
	}
	if(dialogid == DIALOG_MY_BISNIS)
	{
		if(!response) return true;
		SetPVarInt(playerid, "ClickedBisnis", ReturnPlayerBisnisID(playerid, (listitem + 1)));
		ShowPlayerDialog(playerid, BISNIS_INFO, DIALOG_STYLE_LIST, "{FF0000}Capitaliz Roleplay {0000FF}Bisnis", "Show Information\nTrack Bisnis", "Select", "Cancel");
		return 1;
	}
	if(dialogid == BISNIS_INFO)
	{
		if(!response) return true;
		new bid = GetPVarInt(playerid, "ClickedBisnis");
		switch(listitem)
		{
			case 0:
			{
				new line9[900];
				new lock[128], type[128];
				if(bData[bid][bLocked] == 1)
				{
					lock = "{FF0000}Locked";

				}
				else
				{
					lock = "{00FF00}Unlocked";
				}
				if(bData[bid][bType] == 1)
				{
					type = "Fast Food";

				}
				else if(bData[bid][bType] == 2)
				{
					type = "Market";
				}
				else if(bData[bid][bType] == 3)
				{
					type = "Clothes";
				}
				else if(bData[bid][bType] == 4)
				{
					type = "Equipment";
				}
				else if(bData[bid][bType] == 5)
				{
					type = "Bar";
				}
				else
				{
					type = "Unknow";
				}
				format(line9, sizeof(line9), "Bisnis ID: %d\nBisnis Owner: %s\nBisnis Name: %s\nBisnis Price: %s\nBisnis Type: %s\nBisnis Status: %s\nBisnis Product: %d",
				bid, bData[bid][bOwner], bData[bid][bName], FormatMoney(bData[bid][bPrice]), type, lock, bData[bid][bProd]);

				ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_MSGBOX, "Bisnis Info", line9, "Close","");
			}
			case 1:
			{
				pData[playerid][pTrackBisnis] = 1;
				SetPlayerRaceCheckpoint(playerid,1, bData[bid][bExtposX], bData[bid][bExtposY], bData[bid][bExtposZ], 0.0, 0.0, 0.0, 3.5);
				//SetPlayerCheckpoint(playerid, bData[bid][bExtpos][0], bData[bid][bExtpos][1], bData[bid][bExtpos][2], 4.0);
				Info(playerid, "Ikuti checkpoint untuk menemukan bisnis anda!");
			}
		}
		return 1;
	}
	if(dialogid == BISNIS_MENU)
	{
		new bid = pData[playerid][pInBiz];
		new lock[128];
		if(bData[bid][bLocked] == 1)
		{
			lock = "Locked";
		}
		else
		{
			lock = "Unlocked";
		}
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
					new mstr[248], lstr[512];
					format(mstr,sizeof(mstr),"Bisnis ID %d", bid);
					format(lstr,sizeof(lstr),"Bisnis Name:\t%s\nBisnis Locked:\t%s\nBisnis Product:\t%d\nBisnis Vault:\t%s", bData[bid][bName], lock, bData[bid][bProd], FormatMoney(bData[bid][bMoney]));
					ShowPlayerDialog(playerid, BISNIS_INFO, DIALOG_STYLE_TABLIST, mstr, lstr,"Back","Close");
				}
				case 1:
				{
					new mstr[248];
					format(mstr,sizeof(mstr),"Nama sebelumnya: %s\n\nMasukkan nama bisnis yang kamu inginkan\nMaksimal 32 karakter untuk nama bisnis", bData[bid][bName]);
					ShowPlayerDialog(playerid, BISNIS_NAME, DIALOG_STYLE_INPUT,"Bisnis Name", mstr,"Done","Back");
				}
				case 2: ShowPlayerDialog(playerid, BISNIS_VAULT, DIALOG_STYLE_LIST,"Bisnis Vault","Deposit\nWithdraw","Next","Back");
				case 3:
				{
					Bisnis_ProductMenu(playerid, bid);
				}
				case 4:
				{
					if(bData[bid][bProd] > 100)
						return Error(playerid, "Bisnis ini masih memiliki cukup produck.");
					if(bData[bid][bMoney] < 1000)
						return Error(playerid, "Setidaknya anda mempunyai uang dalam bisnis anda senilai $1.000 untuk merestock product.");
					bData[bid][bRestock] = 1;
					Info(playerid, "Anda berhasil request untuk mengisi stock product kepada trucker, harap tunggu sampai pekerja trucker melayani.");
				}
				case 5:
				{
					new mstr[248];
					format(mstr,sizeof(mstr),"Masukkan lagu untuk bisnis yang kamu inginkan\nMaksimal 40 karakter", bData[bid][bSong]);
					ShowPlayerDialog(playerid, BISNIS_SONG, DIALOG_STYLE_INPUT,"Bisnis Song", mstr,"Done","Back");
				}
				case 6:
				{
					new mstr[248];
					format(mstr,sizeof(mstr),"Masukkan nomor telepon untuk bisnis anda", bData[bid][bSong]);
					ShowPlayerDialog(playerid, BISNIS_PH, DIALOG_STYLE_INPUT,"Bisnis Song", mstr,"Done","Back");
				}
				case 7:
				{
					ShowPlayerDialog(playerid, BUSINESS_SETCARGO, DIALOG_STYLE_INPUT, "Cargo Price", sprintf("{00ff00}%s{ffffff}/ Cargo\n\n{ff0000}Masukkan harga yang mau anda ubah!", FormatMoney(bData[bid][bCargo])), "Ubah", "Tutup");
				}
			}
		}
		return 1;
	}
	if(dialogid == BISNIS_INFO)
	{
		if(response)
		{
			return callcmd::bm(playerid, "\0");
		}
		return 1;
	}
	if(dialogid == BISNIS_NAME)
	{
		if(response)
		{
			new bid = pData[playerid][pInBiz];

			if(!Player_OwnsBisnis(playerid, pData[playerid][pInBiz])) return Error(playerid, "You don't own this bisnis.");

			if (isnull(inputtext))
			{
				new mstr[512];
				format(mstr,sizeof(mstr),""RED_E"NOTE: "WHITE_E"Nama Bisnis tidak di perbolehkan kosong!\n\n"WHITE_E"Nama sebelumnya: %s\n\nMasukkan nama Bisnis yang kamu inginkan\nMaksimal 32 karakter untuk nama Bisnis", bData[bid][bName]);
				ShowPlayerDialog(playerid, BISNIS_NAME, DIALOG_STYLE_INPUT,"Bisnis Name", mstr,"Done","Back");
				return 1;
			}
			if(strlen(inputtext) > 32 || strlen(inputtext) < 5)
			{
				new mstr[512];
				format(mstr,sizeof(mstr),""RED_E"NOTE: "WHITE_E"Nama Bisnis harus 5 sampai 32 karakter.\n\n"WHITE_E"Nama sebelumnya: %s\n\nMasukkan nama Bisnis yang kamu inginkan\nMaksimal 32 karakter untuk nama Bisnis", bData[bid][bName]);
				ShowPlayerDialog(playerid, BISNIS_NAME, DIALOG_STYLE_INPUT,"Bisnis Name", mstr,"Done","Back");
				return 1;
			}
			format(bData[bid][bName], 32, ColouredText(inputtext));

			Bisnis_Refresh(bid);
			Bisnis_Save(bid);

			Servers(playerid, "Bisnis name set to: \"%s\".", bData[bid][bName]);
		}
		else return callcmd::bm(playerid, "\0");
		return 1;
	}
	if(dialogid == BISNIS_VAULT)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
					new mstr[512];
					format(mstr,sizeof(mstr),"Uang kamu: %s.\n\nMasukkan berapa banyak uang yang akan kamu simpan di dalam bisnis ini", FormatMoney(GetPlayerMoney(playerid)));
					ShowPlayerDialog(playerid, BISNIS_DEPOSIT, DIALOG_STYLE_INPUT, "Deposit", mstr, "Deposit", "Back");
				}
				case 1:
				{
					new mstr[512];
					format(mstr,sizeof(mstr),"Business Vault: %s\n\nMasukkan berapa banyak uang yang akan kamu ambil di dalam bisnis ini", FormatMoney(bData[pData[playerid][pInBiz]][bMoney]));
					ShowPlayerDialog(playerid, BISNIS_WITHDRAW, DIALOG_STYLE_INPUT,"Withdraw", mstr,"Withdraw","Back");
				}
			}
		}
		return 1;
	}
	if(dialogid == BISNIS_WITHDRAW)
	{
		if(response)
		{
			new bid = pData[playerid][pInBiz];
			new amount = floatround(strval(inputtext));
			if(amount < 1 || amount > bData[bid][bMoney])
				return Error(playerid, "Invalid amount specified!");

			bData[bid][bMoney] -= amount;
			Bisnis_Save(bid);

			GivePlayerMoneyEx(playerid, amount);

			SendClientMessageEx(playerid, COLOR_LBLUE,"BUSINESS: "WHITE_E"You have withdrawn "GREEN_E"%s "WHITE_E"from the business vault.", FormatMoney(strval(inputtext)));
		}
		else
			ShowPlayerDialog(playerid, BISNIS_VAULT, DIALOG_STYLE_LIST,"Business Vault","Deposit\nWithdraw","Next","Back");
		return 1;
	}
	if(dialogid == BISNIS_DEPOSIT)
	{
		if(response)
		{
			new bid = pData[playerid][pInBiz];
			new amount = floatround(strval(inputtext));
			if(amount < 1 || amount > GetPlayerMoney(playerid))
				return Error(playerid, "Invalid amount specified!");

			bData[bid][bMoney] += amount;
			Bisnis_Save(bid);

			GivePlayerMoneyEx(playerid, -amount);

			SendClientMessageEx(playerid, COLOR_LBLUE,"BUSINESS: "WHITE_E"You have deposit "GREEN_E"%s "WHITE_E"into the business vault.", FormatMoney(strval(inputtext)));
		}
		else
			ShowPlayerDialog(playerid, BISNIS_VAULT, DIALOG_STYLE_LIST,"Business Vault","Deposit\nWithdraw","Next","Back");
		return 1;
	}
	if(dialogid == BISNIS_BUYPROD)
	{
		static
        bizid = -1,
        price;

		if((bizid = pData[playerid][pInBiz]) != -1 && response)
		{
			price = bData[bizid][bP][listitem];

			if(GetPlayerMoney(playerid) < price)
				return Error(playerid, "Not enough money!");

			if(bData[bizid][bProd] < 1)
				return Error(playerid, "This business is out of stock product.");

			new Float:health;
			GetPlayerHealth(playerid,health);
			if(bData[bizid][bType] == 1)
			{
				switch(listitem)
				{
					case 0:
					{
						GivePlayerMoneyEx(playerid, -price);
						//SetPlayerHealthEx(playerid, health+30);
						pData[playerid][pHunger] += 35;
						pData[playerid][pTrash] += 1;
						SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s telah membeli makanan seharga %s dan langsung memakannya.", ReturnName(playerid), FormatMoney(price));
						bData[bizid][bProd]--;
						bData[bizid][bMoney] += price;
						Server_AddPercent(price);
						Bisnis_Save(bizid);
						if(health > 95)
						{
							SetPlayerHealthEx(playerid, 100);
						}
						else
						{
							SetPlayerHealthEx(playerid, health+30);
						}
					}
					case 1:
					{
						GivePlayerMoneyEx(playerid, -price);
						//SetPlayerHealthEx(playerid, health+45);
						pData[playerid][pHunger] += 50;
						pData[playerid][pTrash] += 1;
						SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s telah membeli makanan seharga %s dan langsung memakannya.", ReturnName(playerid), FormatMoney(price));
						bData[bizid][bProd]--;
						bData[bizid][bMoney] += price;
						Server_AddPercent(price);
						Bisnis_Save(bizid);
						if(health > 95)
						{
							SetPlayerHealthEx(playerid, 100);
						}
						else
						{
							SetPlayerHealthEx(playerid, health+45);
						}
					}
					case 2:
					{
						GivePlayerMoneyEx(playerid, -price);
						//SetPlayerHealthEx(playerid, health+70);
						pData[playerid][pHunger] += 75;
						pData[playerid][pTrash] += 1;
						SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s telah membeli makanan seharga %s dan langsung memakannya.", ReturnName(playerid), FormatMoney(price));
						bData[bizid][bProd]--;
						bData[bizid][bMoney] += price;
						Server_AddPercent(price);
						Bisnis_Save(bizid);
						if(health > 95)
						{
							SetPlayerHealthEx(playerid, 100);
						}
						else
						{
							SetPlayerHealthEx(playerid, health+70);
						}
					}
					case 3:
					{
						GivePlayerMoneyEx(playerid, -price);
						bData[bizid][bProd]--;
						bData[bizid][bMoney] += price;
						Server_AddPercent(price);
						Bisnis_Save(bizid);
						pData[playerid][pEnergy] += 60;
						pData[playerid][pTrash] += 1;
						//SetPlayerSpecialAction(playerid,SPECIAL_ACTION_DRINK_SPRUNK);
						SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s telah membeli minuman seharga %s.", ReturnName(playerid), FormatMoney(price));
						//SetPVarInt(playerid, "UsingSprunk", 1);
					}
					case 4:
					{
						GivePlayerMoneyEx(playerid, -price);
						bData[bizid][bProd]--;
						bData[bizid][bMoney] += price;
						Server_AddPercent(price);
						Bisnis_Save(bizid);
						pData[playerid][pFrozenPizza] += 1;
						//SetPlayerSpecialAction(playerid,SPECIAL_ACTION_DRINK_SPRUNK);
						SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s telah membeli frozen pizza seharga %s.", ReturnName(playerid), FormatMoney(price));
						//SetPVarInt(playerid, "UsingSprunk", 1);
					}
				}
			}
			else if(bData[bizid][bType] == 2)
			{
				switch(listitem)
				{
					case 0:
					{
						GivePlayerMoneyEx(playerid, -price);
						pData[playerid][pSnack]++;
						SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s telah membeli snack seharga %s.", ReturnName(playerid), FormatMoney(price));
						bData[bizid][bProd]--;
						bData[bizid][bMoney] += price;
						Server_AddPercent(price);
						Bisnis_Save(bizid);
					}
					case 1:
					{
						GivePlayerMoneyEx(playerid, -price);
						pData[playerid][pSprunk]++;
						SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s telah membeli Sprunk seharga %s.", ReturnName(playerid), FormatMoney(price));
						bData[bizid][bProd]--;
						bData[bizid][bMoney] += price;
						Server_AddPercent(price);
						Bisnis_Save(bizid);
					}
					case 2:
					{
						GivePlayerMoneyEx(playerid, -price);
						pData[playerid][pGas]++;
						SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s telah membeli Gas Fuel seharga %s.", ReturnName(playerid), FormatMoney(price));
						bData[bizid][bProd]--;
						bData[bizid][bMoney] += price;
						Server_AddPercent(price);
						Bisnis_Save(bizid);
					}
					case 3:
					{
						GivePlayerMoneyEx(playerid, -price);
						pData[playerid][pBandage]++;
						SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s telah membeli Perban seharga %s.", ReturnName(playerid), FormatMoney(price));
						bData[bizid][bProd]--;
						bData[bizid][bMoney] += price;
						Server_AddPercent(price);
						Bisnis_Save(bizid);
					}
					case 4:
					{
						GivePlayerMoneyEx(playerid, -price);
						pData[playerid][pGPS] = 1;
						SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s telah membeli GPS seharga %s.", ReturnName(playerid), FormatMoney(price));
						bData[bizid][bProd]--;
						bData[bizid][bMoney] += price;
						Server_AddPercent(price);
						Bisnis_Save(bizid);
					}
					case 5:
					{
						GivePlayerMoneyEx(playerid, -price);
						new query[128], rand = RandomEx(1111, 9888);
						new phone = rand+pData[playerid][pID];
						mysql_format(g_SQL, query, sizeof(query), "SELECT phone FROM players WHERE phone='%d'", phone);
						mysql_tquery(g_SQL, query, "PhoneNumber", "id", playerid, phone);
						//pData[playerid][pPhone] = ;
						SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s telah membeli phone seharga %s.", ReturnName(playerid), FormatMoney(price));
						bData[bizid][bProd]--;
						bData[bizid][bMoney] += price;
						Server_AddPercent(price);
						Bisnis_Save(bizid);
					}
					case 6:
					{
						GivePlayerMoneyEx(playerid, -price);
						pData[playerid][pPhoneCredit] += 5;
						SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s telah membeli 5 phone credit seharga %s.", ReturnName(playerid), FormatMoney(price));
						bData[bizid][bProd]--;
						bData[bizid][bMoney] += price;
						Server_AddPercent(price);
						Bisnis_Save(bizid);
					}
					case 7:
					{
						GivePlayerMoneyEx(playerid, -price);
						pData[playerid][pPhoneBook] = 1;
						SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s telah membeli sebuah phone book seharga %s.", ReturnName(playerid), FormatMoney(price));
						bData[bizid][bProd]--;
						bData[bizid][bMoney] += price;
						Server_AddPercent(price);
						Bisnis_Save(bizid);
					}
					case 8:
					{
						GivePlayerMoneyEx(playerid, -price);
						pData[playerid][pWT] = 1;
						SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s telah membeli sebuah walkie talkie seharga %s.", ReturnName(playerid), FormatMoney(price));
						bData[bizid][bProd]--;
						bData[bizid][bMoney] += price;
						Server_AddPercent(price);
						Bisnis_Save(bizid);
					}
					case 9:
					{
						GivePlayerMoneyEx(playerid, -price);
						pData[playerid][pBoombox] += 1;
						SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s telah membeli sebuah boombox seharga %s.", ReturnName(playerid), FormatMoney(price));
						bData[bizid][bProd]--;
						bData[bizid][bMoney] += price;
						Server_AddPercent(price);
						Bisnis_Save(bizid);
					}
				}
			}
			else if(bData[bizid][bType] == 3)
			{
				switch(listitem)
				{
					case 0:
					{
						switch(pData[playerid][pGender])
						{
							case 1: ShowPlayerSelectionMenu(playerid, SHOP_SKIN_MALE, "Choose Your Skin", ShopSkinMale, sizeof(ShopSkinMale));
							case 2: ShowPlayerSelectionMenu(playerid, SHOP_SKIN_FEMALE, "Choose Your Skin", ShopSkinFemale, sizeof(ShopSkinFemale));
						}
					}
					case 1:
					{
						new string[248];
						if(pToys[playerid][0][toy_model] == 0)
						{
							strcat(string, ""dot"Slot 1\n");
						}
						else strcat(string, ""dot"Slot 1 "RED_E"(Used)\n");

						if(pToys[playerid][1][toy_model] == 0)
						{
							strcat(string, ""dot"Slot 2\n");
						}
						else strcat(string, ""dot"Slot 2 "RED_E"(Used)\n");

						if(pToys[playerid][2][toy_model] == 0)
						{
							strcat(string, ""dot"Slot 3\n");
						}
						else strcat(string, ""dot"Slot 3 "RED_E"(Used)\n");

						if(pToys[playerid][3][toy_model] == 0)
						{
							strcat(string, ""dot"Slot 4\n");
						}
						else strcat(string, ""dot"Slot 4 "RED_E"(Used)\n");

						ShowPlayerDialog(playerid, DIALOG_TOYBUY, DIALOG_STYLE_LIST, ""RED_E"Capitaliz Roleplay: "WHITE_E"Player Toys", string, "Select", "Cancel");
					}
					case 2:
					{
						if(pData[playerid][pMask] != 1)
						{
							GivePlayerMoneyEx(playerid, -price);
							pData[playerid][pMask] = 1;
							pData[playerid][pMaskID] = random(9999)+1000+pData[playerid][pMask];
							SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s telah membeli mask seharga %s.", ReturnName(playerid), FormatMoney(price));
							bData[bizid][bProd]--;
							bData[bizid][bMoney] += price;
							Server_AddPercent(price);
							Bisnis_Save(bizid);
						}
						else
						{
							Error(playerid, "Anda sudah memiliki mask");
						}
						
					}
					case 3:
					{
						if(pData[playerid][pHelmet] != 1)
						{
							GivePlayerMoneyEx(playerid, -price);
							pData[playerid][pHelmet] = 1;
							SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s telah membeli Helmet seharga %s.", ReturnName(playerid), FormatMoney(price));
							bData[bizid][bProd]--;
							bData[bizid][bMoney] += price;
							Server_AddPercent(price);
							Bisnis_Save(bizid);
						}
						else
						{
							Error(playerid, "Anda sudah memiliki helmet.");
						}
						
					}
				}
			}
			else if(bData[bizid][bType] == 4)
			{
				switch(listitem)
				{
					case 0:
					{
						GivePlayerMoneyEx(playerid, -price);
						GivePlayerWeaponEx(playerid, 1, 1);
						SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s telah membeli Brass Knuckles seharga %s.", ReturnName(playerid), FormatMoney(price));
						bData[bizid][bProd]--;
						bData[bizid][bMoney] += price;
						Server_AddPercent(price);
						Bisnis_Save(bizid);
					}
					case 1:
					{
						if(pData[playerid][pJob] == 7 || pData[playerid][pJob2] == 7)
						{
							GivePlayerMoneyEx(playerid, -price);
							GivePlayerWeaponEx(playerid, 4, 1);
							SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s telah membeli Knife seharga %s.", ReturnName(playerid), FormatMoney(price));
							bData[bizid][bProd]--;
							bData[bizid][bMoney] += price;
							Server_AddPercent(price);
							Bisnis_Save(bizid);
						}
						else return Error(playerid, "Job farmer only!");
					}
					case 2:
					{
						GivePlayerMoneyEx(playerid, -price);
						GivePlayerWeaponEx(playerid, 5, 1);
						SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s telah membeli Baseball Bat seharga %s.", ReturnName(playerid), FormatMoney(price));
						bData[bizid][bProd]--;
						bData[bizid][bMoney] += price;
						Server_AddPercent(price);
						Bisnis_Save(bizid);
					}
					case 3:
					{
						if(pData[playerid][pJob] == 5 || pData[playerid][pJob2] == 5)
						{
							GivePlayerMoneyEx(playerid, -price);
							GivePlayerWeaponEx(playerid, 6, 1);
							SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s telah membeli Shovel seharga %s.", ReturnName(playerid), FormatMoney(price));
							bData[bizid][bProd]--;
							bData[bizid][bMoney] += price;
							Server_AddPercent(price);
							Bisnis_Save(bizid);
						}
						else return Error(playerid, "Job miner only!");
					}
					case 4:
					{
						if(pData[playerid][pJob] == 3 || pData[playerid][pJob2] == 3)
						{
							GivePlayerMoneyEx(playerid, -price);
							GivePlayerWeaponEx(playerid, 9, 1);
							SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s telah membeli Chainsaw seharga %s.", ReturnName(playerid), FormatMoney(price));
							bData[bizid][bProd]--;
							bData[bizid][bMoney] += price;
							Server_AddPercent(price);
							Bisnis_Save(bizid);
						}
						else return Error(playerid, "Job lumber jack only!");
					}
					case 5:
					{
						GivePlayerMoneyEx(playerid, -price);
						GivePlayerWeaponEx(playerid, 15, 1);
						SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s telah membeli Cane seharga %s.", ReturnName(playerid), FormatMoney(price));
						bData[bizid][bProd]--;
						bData[bizid][bMoney] += price;
						Server_AddPercent(price);
						Bisnis_Save(bizid);
					}
					case 6:
					{
						if(pData[playerid][pPancingan] > 0) 
							return Error(playerid, "Kamu masih mempunyai pancingan!");

						GivePlayerMoneyEx(playerid, -price);
						pData[playerid][pPancingan] = 100;
						SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s telah membeli pancingan seharga %s.", ReturnName(playerid), FormatMoney(price));
						bData[bizid][bProd]--;
						bData[bizid][bMoney] += price;
						Server_AddPercent(price);
						Bisnis_Save(bizid);
					}
					case 7:
					{
						GivePlayerMoneyEx(playerid, -price);
                        pData[playerid][pCleanTools] += 50;
						SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s telah membeli Cleaning Tools seharga %s.", ReturnName(playerid), FormatMoney(price));
						bData[bizid][bProd]--;
						bData[bizid][bMoney] += price;
						Server_AddPercent(price);
						Bisnis_Save(bizid);
					}
					case 8:
					{
						GivePlayerMoneyEx(playerid, -price);
						pData[playerid][pCacing] += 10;
						SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s telah membeli 10 umpan cacing seharga %s.", ReturnName(playerid), FormatMoney(price));
						bData[bizid][bProd]--;
						bData[bizid][bMoney] += price;
						Server_AddPercent(price);
						Bisnis_Save(bizid);
					}
				}
			}
			else if(bData[bizid][bType] == 5)
			{
				switch(listitem)
				{
					case 0:
					{
						GivePlayerMoneyEx(playerid, -price);
						SetPlayerHealthEx(playerid, health+30);
						pData[playerid][pEnergy] += 30;
						pData[playerid][pTrash] += 1;
						SetPlayerSpecialAction(playerid,SPECIAL_ACTION_DRINK_WINE);
						SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s telah membeli Wine seharga %s.", ReturnName(playerid), FormatMoney(price));
						bData[bizid][bProd]--;
						bData[bizid][bMoney] += price;
						Server_AddPercent(price);
						Bisnis_Save(bizid);
					}
					case 1:
					{
						GivePlayerMoneyEx(playerid, -price);
						SetPlayerHealthEx(playerid, health+45);
						pData[playerid][pEnergy] += 30;
						pData[playerid][pTrash] += 1;
						SetPlayerDrunkLevel(playerid, 4000);
						SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s telah membeli Beer Alcohol seharga %s dan langsung memakannya.", ReturnName(playerid), FormatMoney(price));
						bData[bizid][bProd]--;
						bData[bizid][bMoney] += price;
						Server_AddPercent(price);
						Bisnis_Save(bizid);
					}
					case 2:
					{
						GivePlayerMoneyEx(playerid, -price);
						SetPlayerHealthEx(playerid, health+70);
						pData[playerid][pEnergy] += 30;
						pData[playerid][pTrash] += 1;
						SetPlayerDrunkLevel(playerid, 4000);
						SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s telah membeli Vodka seharga %s dan langsung memakannya.", ReturnName(playerid), FormatMoney(price));
						bData[bizid][bProd]--;
						bData[bizid][bMoney] += price;
						Server_AddPercent(price);
						Bisnis_Save(bizid);
					}
					case 3:
					{
						GivePlayerMoneyEx(playerid, -price);
						bData[bizid][bProd]--;
						bData[bizid][bMoney] += price;
						Server_AddPercent(price);
						Bisnis_Save(bizid);
						pData[playerid][pEnergy] += 30;
						pData[playerid][pTrash] += 1;
						SetPlayerDrunkLevel(playerid, 4000);
						//SetPlayerSpecialAction(playerid,SPECIAL_ACTION_DRINK_SPRUNK);
						SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s telah membeli Rum seharga %s.", ReturnName(playerid), FormatMoney(price));
						//SetPVarInt(playerid, "UsingSprunk", 1);
					}
				}
			}
		}
		return 1;
	}
	if(dialogid == BISNIS_EDITPROD)
	{
		if(Player_OwnsBisnis(playerid, pData[playerid][pInBiz]))
		{
			if(response)
			{
				static
					item[40],
					str[128];

				strmid(item, inputtext, 0, strfind(inputtext, "-") - 1);
				strpack(pData[playerid][pEditingItem], item, 40 char);

				pData[playerid][pProductModify] = listitem;
				format(str,sizeof(str), "Please enter the new product price for %s:", item);
				ShowPlayerDialog(playerid, BISNIS_PRICESET, DIALOG_STYLE_INPUT, "Business: Set Price", str, "Modify", "Back");
			}
			else
				return callcmd::bm(playerid, "\0");
		}
		return 1;
	}
	if(dialogid == BISNIS_PRICESET)
	{
		static
        item[40];
		new bizid = pData[playerid][pInBiz];
		if(Player_OwnsBisnis(playerid, pData[playerid][pInBiz]))
		{
			if(response)
			{
				strunpack(item, pData[playerid][pEditingItem]);

				if(isnull(inputtext))
				{
					new str[128];
					format(str,sizeof(str), "Please enter the new product price for %s:", item);
					ShowPlayerDialog(playerid, BISNIS_PRICESET, DIALOG_STYLE_INPUT, "Business: Set Price", str, "Modify", "Back");
					return 1;
				}
				if(strval(inputtext) < 1 || strval(inputtext) > 10000)
				{
					new str[128];
					format(str,sizeof(str), "Please enter the new product price for %s ($1 to $100.00):", item);
					ShowPlayerDialog(playerid, BISNIS_PRICESET, DIALOG_STYLE_INPUT, "Business: Set Price", str, "Modify", "Back");
					return 1;
				}
				bData[bizid][bP][pData[playerid][pProductModify]] = strval(inputtext);
				Bisnis_Save(bizid);

				Servers(playerid, "You have adjusted the price of %s to: %s!", item, FormatMoney(strval(inputtext)));
				Bisnis_ProductMenu(playerid, bizid);
			}
			else
			{
				Bisnis_ProductMenu(playerid, bizid);
			}
		}
		return 1;
	}
	if(dialogid == BISNIS_SONG)
	{
		if(response)
		{
			new bid = pData[playerid][pInBiz];

			if(!Player_OwnsBisnis(playerid, pData[playerid][pInBiz])) return Error(playerid, "You don't own this bisnis.");

			if (isnull(inputtext))
			{
				new mstr[512];
				format(mstr,sizeof(mstr),""RED_E"Error: "WHITE_E"Masukkan URL lagu untuk bisnis anda!\n", bData[bid][bSong]);
				ShowPlayerDialog(playerid, BISNIS_SONG, DIALOG_STYLE_INPUT,"Bisnis Song", mstr,"Done","Back");
				return 1;
			}
			if(strlen(inputtext) > 70 || strlen(inputtext) < 5)
			{
				new mstr[512];
				format(mstr,sizeof(mstr),""RED_E"Error: "WHITE_E"URL lagu harus 5 sampai 70 karakter.", bData[bid][bSong]);
				ShowPlayerDialog(playerid, BISNIS_SONG, DIALOG_STYLE_INPUT,"Bisnis Song", mstr,"Done","Back");
				return 1;
			}
			format(bData[bid][bSong], 40, ColouredText(inputtext));

			Bisnis_Refresh(bid);
			Bisnis_Save(bid);

			Servers(playerid, "Bisnis song set to: \"%s\".", bData[bid][bSong]);
		}
		else return callcmd::bm(playerid, "\0");
		return 1;
	}
	if(dialogid == BISNIS_PH)
	{
		if(response)
		{
			new bid = pData[playerid][pInBiz];

			if(!Player_OwnsBisnis(playerid, pData[playerid][pInBiz])) return Error(playerid, "You don't own this bisnis.");

			if (isnull(inputtext))
			{
				ShowPlayerDialog(playerid, BISNIS_PH, DIALOG_STYLE_INPUT,"Bisnis Phone Number", ""RED_E"Error: "WHITE_E"Masukkan Nomor Telepon untuk bisnis anda!","Done","Back");
				return 1;
			}

			bData[bid][bPh] = strval(inputtext);
			Bisnis_Refresh(bid);
			Bisnis_Save(bid);

			Servers(playerid, "Bisnis Phone Number set to: \"%d\".", bData[bid][bPh]);
		}
		else return callcmd::bm(playerid, "\0");
		return 1;
	}
	//-----------[ House Dialog ]------------------
	if(dialogid == DIALOG_SELL_HOUSES)
	{
		if(!response) return 1;
		new str[248];
		SetPVarInt(playerid, "SellingHouse", ReturnPlayerHousesID(playerid, (listitem + 1)));
		format(str, sizeof(str), "Are you sure you will sell house id: %d", GetPVarInt(playerid, "SellingHouse"));

		ShowPlayerDialog(playerid, DIALOG_SELL_HOUSE, DIALOG_STYLE_MSGBOX, "Sell House", str, "Sell", "Cancel");
	}
	if(dialogid == DIALOG_SELL_HOUSE)
	{
		if(response)
		{
			new hid = GetPVarInt(playerid, "SellingHouse"), price;
			price = hData[hid][hPrice] / 2;
			GivePlayerMoneyEx(playerid, price);
			Info(playerid, "Anda berhasil menjual rumah id (%d) dengan setengah harga("LG_E"%s"WHITE_E") pada saat anda membelinya.", hid, FormatMoney(price));
			HouseReset(hid);
			House_Save(hid);
			House_Refresh(hid);
		}
		DeletePVar(playerid, "SellingHouse");
		return 1;
	}
	if(dialogid == DIALOG_MY_HOUSES)
	{
		if(!response) return 1;
		SetPVarInt(playerid, "ClickedHouse", ReturnPlayerHousesID(playerid, (listitem + 1)));
		ShowPlayerDialog(playerid, HOUSE_INFO, DIALOG_STYLE_LIST, "{FF0000}Capitaliz Roleplay {0000FF}Houses", "Show Information\nTrack House", "Select", "Cancel");
		return 1;
	}
	if(dialogid == HOUSE_INFO)
	{
		if(!response) return 1;
		new hid = GetPVarInt(playerid, "ClickedHouse");
		switch(listitem)
		{
			case 0:
			{
				new line9[900];
				new lock[128], type[128];
				if(hData[hid][hLocked] == 1)
				{
					lock = "{FF0000}Locked";

				}
				else
				{
					lock = "{00FF00}Unlocked";
				}
				if(hData[hid][hType] == 1)
				{
					type = "Small";

				}
				else if(hData[hid][hType] == 2)
				{
					type = "Medium";
				}
				else if(hData[hid][hType] == 3)
				{
					type = "Big";
				}
				else
				{
					type = "Unknow";
				}
				format(line9, sizeof(line9), "House ID: %d\nHouse Owner: %s\nHouse Address: %s\nHouse Price: %s\nHouse Type: %s\nHouse Status: %s",
				hid, hData[hid][hOwner], hData[hid][hAddress], FormatMoney(hData[hid][hPrice]), type, lock);

				ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_MSGBOX, "House Info", line9, "Close","");
			}
			case 1:
			{
				pData[playerid][pTrackHouse] = 1;
				SetPlayerRaceCheckpoint(playerid,1, hData[hid][hExtposX], hData[hid][hExtposY], hData[hid][hExtposZ], 0.0, 0.0, 0.0, 3.5);
				//SetPlayerCheckpoint(playerid, hData[hid][hExtpos][0], hData[hid][hExtpos][1], hData[hid][hExtpos][2], 4.0);
				Info(playerid, "Ikuti checkpoint untuk menemukan rumah anda!");
			}
		}
		return 1;
	}
	if(dialogid == HOUSE_STORAGE)
	{
		new hid = pData[playerid][pInHouse];
		if(!Player_OwnsHouse(playerid, pData[playerid][pInHouse]))
			if(pData[playerid][pFaction] != 1)
				return Error(playerid, "You don't own this house.");
		if(response)
		{
			if(listitem == 0)
			{
				House_WeaponStorage(playerid, hid);
			}
			else if(listitem == 1)
			{
				ShowPlayerDialog(playerid, HOUSE_MONEY, DIALOG_STYLE_LIST, "Money Safe", "Withdraw from safe\nDeposit into safe", "Select", "Back");
			}
		}
		return 1;
	}
	if(dialogid == HOUSE_WEAPONS)
	{
		new houseid = pData[playerid][pInHouse];
		if(!Player_OwnsHouse(playerid, pData[playerid][pInHouse]))
			if(pData[playerid][pFaction] != 1)
				return Error(playerid, "You don't own this house.");

		if(response)
		{
			if(hData[houseid][hWeapon][listitem] != 0)
			{
				GivePlayerWeaponEx(playerid, hData[houseid][hWeapon][listitem], hData[houseid][hAmmo][listitem]);

				SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s has taken a \"%s\" from their weapon storage.", ReturnName(playerid), ReturnWeaponName(hData[houseid][hWeapon][listitem]));

				hData[houseid][hWeapon][listitem] = 0;
				hData[houseid][hAmmo][listitem] = 0;

				House_Save(houseid);
				House_WeaponStorage(playerid, houseid);
			}
			else
			{
				new
					weaponid = GetPlayerWeaponEx(playerid),
					ammo = GetPlayerAmmoEx(playerid);

				if(!weaponid)
					return Error(playerid, "You are not holding any weapon!");

				/*if(weaponid == 23 && pData[playerid][pTazer])
					return Error(playerid, "You can't store a tazer into your safe.");

				if(weaponid == 25 && pData[playerid][pBeanBag])
					return Error(playerid, "You can't store a beanbag shotgun into your safe.");*/

				ResetWeapon(playerid, weaponid);
				SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s has stored a \"%s\" into their weapon storage.", ReturnName(playerid), ReturnWeaponName(weaponid));

				hData[houseid][hWeapon][listitem] = weaponid;
				hData[houseid][hAmmo][listitem] = ammo;

				House_Save(houseid);
				House_WeaponStorage(playerid, houseid);
			}
		}
		else
		{
			House_OpenStorage(playerid, houseid);
		}
		return 1;
	}
	if(dialogid == HOUSE_MONEY)
	{
		new houseid = pData[playerid][pInHouse];
		if(!Player_OwnsHouse(playerid, pData[playerid][pInHouse])) return Error(playerid, "You don't own this house.");
		if(response)
		{
			switch (listitem)
			{
				case 0:
				{
					new str[128];
					format(str, sizeof(str), "Safe Balance: %s\n\nPlease enter how much money you wish to withdraw from the safe:", FormatMoney(hData[houseid][hMoney]));
					ShowPlayerDialog(playerid, HOUSE_WITHDRAWMONEY, DIALOG_STYLE_INPUT, "Withdraw from safe", str, "Withdraw", "Back");
				}
				case 1:
				{
					new str[128];
					format(str, sizeof(str), "Safe Balance: %s\n\nPlease enter how much money you wish to deposit into the safe:", FormatMoney(hData[houseid][hMoney]));
					ShowPlayerDialog(playerid, HOUSE_DEPOSITMONEY, DIALOG_STYLE_INPUT, "Deposit into safe", str, "Deposit", "Back");
				}
			}
		}
		else House_OpenStorage(playerid, houseid);
		return 1;
	}
	if(dialogid == HOUSE_WITHDRAWMONEY)
	{
		new houseid = pData[playerid][pInHouse];
		if(!Player_OwnsHouse(playerid, pData[playerid][pInHouse])) return Error(playerid, "You don't own this house.");

		if(response)
		{
			new amount = strval(inputtext);

			if(isnull(inputtext))
			{
				new str[128];
				format(str, sizeof(str), "Safe Balance: %s\n\nPlease enter how much money you wish to withdraw from the safe:", FormatMoney(hData[houseid][hMoney]));
				ShowPlayerDialog(playerid, HOUSE_WITHDRAWMONEY, DIALOG_STYLE_INPUT, "Withdraw from safe", str, "Withdraw", "Back");
				return 1;
			}
			if(amount < 1 || amount > hData[houseid][hMoney])
			{
				new str[128];
				format(str, sizeof(str), "Error: Insufficient funds.\n\nSafe Balance: %s\n\nPlease enter how much money you wish to withdraw from the safe:", FormatMoney(hData[houseid][hMoney]));
				ShowPlayerDialog(playerid, HOUSE_WITHDRAWMONEY, DIALOG_STYLE_INPUT, "Withdraw from safe", str, "Withdraw", "Back");
				return 1;
			}
			hData[houseid][hMoney] -= amount;
			GivePlayerMoneyEx(playerid, amount);

			House_Save(houseid);
			House_OpenStorage(playerid, houseid);

			SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s has withdrawn %s from their house safe.", ReturnName(playerid), FormatMoney(amount));
		}
		else ShowPlayerDialog(playerid, HOUSE_MONEY, DIALOG_STYLE_LIST, "Money Safe", "Withdraw from safe\nDeposit into safe", "Select", "Back");
		return 1;
	}
	if(dialogid == HOUSE_DEPOSITMONEY)
	{
		new houseid = pData[playerid][pInHouse];
		if(!Player_OwnsHouse(playerid, pData[playerid][pInHouse])) return Error(playerid, "You don't own this house.");
		if(response)
		{
			new amount = strval(inputtext);

			if(isnull(inputtext))
			{
				new str[128];
				format(str, sizeof(str), "Safe Balance: %s\n\nPlease enter how much money you wish to deposit into the safe:", FormatMoney(hData[houseid][hMoney]));
				ShowPlayerDialog(playerid, HOUSE_DEPOSITMONEY, DIALOG_STYLE_INPUT, "Deposit into safe", str, "Deposit", "Back");
				return 1;
			}
			if(amount < 1 || amount > GetPlayerMoney(playerid))
			{
				new str[128];
				format(str, sizeof(str), "Error: Insufficient funds.\n\nSafe Balance: %s\n\nPlease enter how much money you wish to deposit into the safe:", FormatMoney(hData[houseid][hMoney]));
				ShowPlayerDialog(playerid, HOUSE_DEPOSITMONEY, DIALOG_STYLE_INPUT, "Deposit into safe", str, "Deposit", "Back");
				return 1;
			}
			hData[houseid][hMoney] += amount;
			GivePlayerMoneyEx(playerid, -amount);

			House_Save(houseid);
			House_OpenStorage(playerid, houseid);

			SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s has deposited %s into their house safe.", ReturnName(playerid), FormatMoney(amount));
		}
		else ShowPlayerDialog(playerid, HOUSE_MONEY, DIALOG_STYLE_LIST, "Money Safe", "Withdraw from safe\nDeposit into safe", "Select", "Back");
		return 1;
	}
	//-----------[ Flat Dialog ]------------------
	if(dialogid == DIALOG_SELL_FLATS)
	{
		if(!response) return 1;
		new str[248];
		SetPVarInt(playerid, "SellingFlat", ReturnPlayerFlatsID(playerid, (listitem + 1)));
		format(str, sizeof(str), "Are you sure you will sell flat id: %d", GetPVarInt(playerid, "SellingFlat"));

		ShowPlayerDialog(playerid, DIALOG_SELL_FLAT, DIALOG_STYLE_MSGBOX, "Sell Flat", str, "Sell", "Cancel");
	}
	if(dialogid == DIALOG_SELL_FLAT)
	{
		if(response)
		{
			new flid = GetPVarInt(playerid, "SellingFlat"), price;
			price = flData[flid][flPrice] / 2;
			GivePlayerMoneyEx(playerid, price);
			Info(playerid, "Anda berhasil menjual rumah id (%d) dengan setengah harga("LG_E"%s"WHITE_E") pada saat anda membelinya.", flid, FormatMoney(price));
			FlatReset(flid);
			Flat_Save(flid);
			Flat_Refresh(flid);
		}
		DeletePVar(playerid, "SellingFlat");
		return 1;
	}
	if(dialogid == DIALOG_MY_FLATS)
	{
		if(!response) return 1;
		SetPVarInt(playerid, "ClickedFlat", ReturnPlayerFlatsID(playerid, (listitem + 1)));
		ShowPlayerDialog(playerid, FLAT_INFO, DIALOG_STYLE_LIST, "{FF0000}Capitaliz Roleplay {0000FF}Flats", "Show Information\nTrack Flat", "Select", "Cancel");
		return 1;
	}
	if(dialogid == FLAT_INFO)
	{
		if(!response) return 1;
		new flid = GetPVarInt(playerid, "ClickedFlat");
		switch(listitem)
		{
			case 0:
			{
				new line9[900];
				new lock[128], type[128];
				if(flData[flid][flLocked] == 1)
				{
					lock = "{FF0000}Locked";

				}
				else
				{
					lock = "{00FF00}Unlocked";
				}
				if(flData[flid][flType] == 1)
				{
					type = "Small";

				}
				else if(flData[flid][flType] == 2)
				{
					type = "Medium";
				}
				else if(flData[flid][flType] == 3)
				{
					type = "Big";
				}
				else
				{
					type = "Unknow";
				}
				format(line9, sizeof(line9), "Flat ID: %d\nFlat Owner: %s\nFlat Address: %s\nFlat Price: %s\nFlat Type: %s\nFlat Status: %s",
				flid, flData[flid][flOwner], flData[flid][flAddress], FormatMoney(flData[flid][flPrice]), type, lock);

				ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_MSGBOX, "Flat Info", line9, "Close","");
			}
			case 1:
			{
				pData[playerid][pTrackFlat] = 1;
				SetPlayerRaceCheckpoint(playerid,1, flData[flid][flExtposX], flData[flid][flExtposY], flData[flid][flExtposZ], 0.0, 0.0, 0.0, 3.5);
				//SetPlayerCheckpoint(playerid, flData[flid][flExtpos][0], flData[flid][flExtpos][1], flData[flid][flExtpos][2], 4.0);
				Info(playerid, "Ikuti checkpoint untuk menemukan rumah anda!");
			}
		}
		return 1;
	}
	if(dialogid == FLAT_STORAGE)
	{
		new flid = pData[playerid][pInFlat];
		if(!Player_OwnsFlat(playerid, pData[playerid][pInFlat]))
			if(pData[playerid][pFaction] != 1)
				return Error(playerid, "You don't own this flat.");
		if(response)
		{
			if(listitem == 0)
			{
				Flat_WeaponStorage(playerid, flid);
			}
			else if(listitem == 1)
			{
				ShowPlayerDialog(playerid, FLAT_MONEY, DIALOG_STYLE_LIST, "Money Safe", "Withdraw from safe\nDeposit into safe", "Select", "Back");
			}
		}
		return 1;
	}
	if(dialogid == FLAT_WEAPONS)
	{
		new flatid = pData[playerid][pInFlat];
		if(!Player_OwnsFlat(playerid, pData[playerid][pInFlat]))
			if(pData[playerid][pFaction] != 1)
				return Error(playerid, "You don't own this flat.");

		if(response)
		{
			if(flData[flatid][flWeapon][listitem] != 0)
			{
				GivePlayerWeaponEx(playerid, flData[flatid][flWeapon][listitem], flData[flatid][flAmmo][listitem]);

				SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s has taken a \"%s\" from their weapon storage.", ReturnName(playerid), ReturnWeaponName(flData[flatid][flWeapon][listitem]));

				flData[flatid][flWeapon][listitem] = 0;
				flData[flatid][flAmmo][listitem] = 0;

				Flat_Save(flatid);
				Flat_WeaponStorage(playerid, flatid);
			}
			else
			{
				new
					weaponid = GetPlayerWeaponEx(playerid),
					ammo = GetPlayerAmmoEx(playerid);

				if(!weaponid)
					return Error(playerid, "You are not holding any weapon!");

				/*if(weaponid == 23 && pData[playerid][pTazer])
					return Error(playerid, "You can't store a tazer into your safe.");

				if(weaponid == 25 && pData[playerid][pBeanBag])
					return Error(playerid, "You can't store a beanbag shotgun into your safe.");*/

				ResetWeapon(playerid, weaponid);
				SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s has stored a \"%s\" into their weapon storage.", ReturnName(playerid), ReturnWeaponName(weaponid));

				flData[flatid][flWeapon][listitem] = weaponid;
				flData[flatid][flAmmo][listitem] = ammo;

				Flat_Save(flatid);
				Flat_WeaponStorage(playerid, flatid);
			}
		}
		else
		{
			Flat_OpenStorage(playerid, flatid);
		}
		return 1;
	}
	if(dialogid == FLAT_MONEY)
	{
		new flatid = pData[playerid][pInFlat];
		if(!Player_OwnsFlat(playerid, pData[playerid][pInFlat])) return Error(playerid, "You don't own this flat.");
		if(response)
		{
			switch (listitem)
			{
				case 0:
				{
					new str[128];
					format(str, sizeof(str), "Safe Balance: %s\n\nPlease enter how much money you wish to withdraw from the safe:", FormatMoney(flData[flatid][flMoney]));
					ShowPlayerDialog(playerid, FLAT_WITHDRAWMONEY, DIALOG_STYLE_INPUT, "Withdraw from safe", str, "Withdraw", "Back");
				}
				case 1:
				{
					new str[128];
					format(str, sizeof(str), "Safe Balance: %s\n\nPlease enter how much money you wish to deposit into the safe:", FormatMoney(flData[flatid][flMoney]));
					ShowPlayerDialog(playerid, FLAT_DEPOSITMONEY, DIALOG_STYLE_INPUT, "Deposit into safe", str, "Deposit", "Back");
				}
			}
		}
		else Flat_OpenStorage(playerid, flatid);
		return 1;
	}
	if(dialogid == FLAT_WITHDRAWMONEY)
	{
		new flatid = pData[playerid][pInFlat];
		if(!Player_OwnsFlat(playerid, pData[playerid][pInFlat])) return Error(playerid, "You don't own this flat.");

		if(response)
		{
			new amount = strval(inputtext);

			if(isnull(inputtext))
			{
				new str[128];
				format(str, sizeof(str), "Safe Balance: %s\n\nPlease enter how much money you wish to withdraw from the safe:", FormatMoney(flData[flatid][flMoney]));
				ShowPlayerDialog(playerid, FLAT_WITHDRAWMONEY, DIALOG_STYLE_INPUT, "Withdraw from safe", str, "Withdraw", "Back");
				return 1;
			}
			if(amount < 1 || amount > flData[flatid][flMoney])
			{
				new str[128];
				format(str, sizeof(str), "Error: Insufficient funds.\n\nSafe Balance: %s\n\nPlease enter how much money you wish to withdraw from the safe:", FormatMoney(flData[flatid][flMoney]));
				ShowPlayerDialog(playerid, FLAT_WITHDRAWMONEY, DIALOG_STYLE_INPUT, "Withdraw from safe", str, "Withdraw", "Back");
				return 1;
			}
			flData[flatid][flMoney] -= amount;
			GivePlayerMoneyEx(playerid, amount);

			Flat_Save(flatid);
			Flat_OpenStorage(playerid, flatid);

			SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s has withdrawn %s from their flat safe.", ReturnName(playerid), FormatMoney(amount));
		}
		else ShowPlayerDialog(playerid, FLAT_MONEY, DIALOG_STYLE_LIST, "Money Safe", "Withdraw from safe\nDeposit into safe", "Select", "Back");
		return 1;
	}
	if(dialogid == FLAT_DEPOSITMONEY)
	{
		new flatid = pData[playerid][pInFlat];
		if(!Player_OwnsFlat(playerid, pData[playerid][pInFlat])) return Error(playerid, "You don't own this flat.");
		if(response)
		{
			new amount = strval(inputtext);

			if(isnull(inputtext))
			{
				new str[128];
				format(str, sizeof(str), "Safe Balance: %s\n\nPlease enter how much money you wish to deposit into the safe:", FormatMoney(flData[flatid][flMoney]));
				ShowPlayerDialog(playerid, FLAT_DEPOSITMONEY, DIALOG_STYLE_INPUT, "Deposit into safe", str, "Deposit", "Back");
				return 1;
			}
			if(amount < 1 || amount > GetPlayerMoney(playerid))
			{
				new str[128];
				format(str, sizeof(str), "Error: Insufficient funds.\n\nSafe Balance: %s\n\nPlease enter how much money you wish to deposit into the safe:", FormatMoney(flData[flatid][flMoney]));
				ShowPlayerDialog(playerid, FLAT_DEPOSITMONEY, DIALOG_STYLE_INPUT, "Deposit into safe", str, "Deposit", "Back");
				return 1;
			}
			flData[flatid][flMoney] += amount;
			GivePlayerMoneyEx(playerid, -amount);

			Flat_Save(flatid);
			Flat_OpenStorage(playerid, flatid);

			SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s has deposited %s into their flat safe.", ReturnName(playerid), FormatMoney(amount));
		}
		else ShowPlayerDialog(playerid, FLAT_MONEY, DIALOG_STYLE_LIST, "Money Safe", "Withdraw from safe\nDeposit into safe", "Select", "Back");
		return 1;
	}
	//-----------[ Hotel Dialog ]------------------
	if(dialogid == DIALOG_SELL_HOTELS)
	{
		if(!response) return 1;
		new str[248];
		SetPVarInt(playerid, "SellingHotel", ReturnPlayerHotelsID(playerid, (listitem + 1)));
		format(str, sizeof(str), "Are you sure you will sell hotel id: %d", GetPVarInt(playerid, "SellingHotel"));

		ShowPlayerDialog(playerid, DIALOG_SELL_HOTEL, DIALOG_STYLE_MSGBOX, "Sell Hotel", str, "Sell", "Cancel");
	}
	if(dialogid == DIALOG_SELL_HOTEL)
	{
		if(response)
		{
			new htid = GetPVarInt(playerid, "SellingHotel"), price;
			price = htData[htid][htPrice] / 2;
			GivePlayerMoneyEx(playerid, price);
			Info(playerid, "Anda berhasil menjual hotel id (%d) dengan setengah harga("LG_E"%s"WHITE_E") pada saat anda membelinya.", htid, FormatMoney(price));
			HotelReset(htid);
			Hotel_Save(htid);
			Hotel_Refresh(htid);
		}
		DeletePVar(playerid, "SellingHotel");
		return 1;
	}
	if(dialogid == DIALOG_MY_HOTELS)
	{
		if(!response) return 1;
		SetPVarInt(playerid, "ClickedHotel", ReturnPlayerHotelsID(playerid, (listitem + 1)));
		ShowPlayerDialog(playerid, HOTEL_INFO, DIALOG_STYLE_LIST, "{FF0000}Capitaliz Roleplay {0000FF}Hotels", "Show Information\nTrack Hotel", "Select", "Cancel");
		return 1;
	}
	if(dialogid == HOTEL_INFO)
	{
		if(!response) return 1;
		new htid = GetPVarInt(playerid, "ClickedHotel");
		switch(listitem)
		{
			case 0:
			{
				new line9[900];
				new lock[128], type[128];
				if(htData[htid][htLocked] == 1)
				{
					lock = "{FF0000}Locked";

				}
				else
				{
					lock = "{00FF00}Unlocked";
				}
				if(htData[htid][htType] == 1)
				{
					type = "Small";

				}
				else
				{
					type = "Unknow";
				}
				format(line9, sizeof(line9), "Hotel ID: %d\nHotel Owner: %s\nHotel Address: %s\nHotel Price: %s\nHotel Type: %s\nHotel Status: %s",
				htid, htData[htid][htOwner], htData[htid][htAddress], FormatMoney(htData[htid][htPrice]), type, lock);

				ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_MSGBOX, "Hotel Info", line9, "Close","");
			}
			case 1:
			{
				pData[playerid][pTrackHotel] = 1;
				SetPlayerRaceCheckpoint(playerid,1, htData[htid][htExtposX], htData[htid][htExtposY], htData[htid][htExtposZ], 0.0, 0.0, 0.0, 3.5);
				//SetPlayerCheckpoint(playerid, htData[htid][htExtpos][0], htData[htid][htExtpos][1], htData[htid][htExtpos][2], 4.0);
				Info(playerid, "Ikuti checkpoint untuk menemukan hotel anda!");
			}
		}
		return 1;
	}
	if(dialogid == HOTEL_STORAGE)
	{
		new htid = pData[playerid][pInHotel];
		if(!Player_OwnsHotel(playerid, pData[playerid][pInHotel]))
			if(pData[playerid][pFaction] != 1)
				return Error(playerid, "You don't own this hotel.");
		if(response)
		{
			if(listitem == 0)
			{
				Hotel_WeaponStorage(playerid, htid);
			}
			else if(listitem == 1)
			{
				ShowPlayerDialog(playerid, HOTEL_MONEY, DIALOG_STYLE_LIST, "Money Safe", "Withdraw from safe\nDeposit into safe", "Select", "Back");
			}
		}
		return 1;
	}
	if(dialogid == HOTEL_WEAPONS)
	{
		new hotelid = pData[playerid][pInHotel];
		if(!Player_OwnsHotel(playerid, pData[playerid][pInHotel]))
			if(pData[playerid][pFaction] != 1)
				return Error(playerid, "You don't own this hotel.");

		if(response)
		{
			if(htData[hotelid][htWeapon][listitem] != 0)
			{
				GivePlayerWeaponEx(playerid, htData[hotelid][htWeapon][listitem], htData[hotelid][htAmmo][listitem]);

				SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s has taken a \"%s\" from their weapon storage.", ReturnName(playerid), ReturnWeaponName(htData[hotelid][htWeapon][listitem]));

				htData[hotelid][htWeapon][listitem] = 0;
				htData[hotelid][htAmmo][listitem] = 0;

				Hotel_Save(hotelid);
				Hotel_WeaponStorage(playerid, hotelid);
			}
			else
			{
				new
					weaponid = GetPlayerWeaponEx(playerid),
					ammo = GetPlayerAmmoEx(playerid);

				if(!weaponid)
					return Error(playerid, "You are not holding any weapon!");

				/*if(weaponid == 23 && pData[playerid][pTazer])
					return Error(playerid, "You can't store a tazer into your safe.");

				if(weaponid == 25 && pData[playerid][pBeanBag])
					return Error(playerid, "You can't store a beanbag shotgun into your safe.");*/

				ResetWeapon(playerid, weaponid);
				SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s has stored a \"%s\" into their weapon storage.", ReturnName(playerid), ReturnWeaponName(weaponid));

				htData[hotelid][htWeapon][listitem] = weaponid;
				htData[hotelid][htAmmo][listitem] = ammo;

				Hotel_Save(hotelid);
				Hotel_WeaponStorage(playerid, hotelid);
			}
		}
		else
		{
			Hotel_OpenStorage(playerid, hotelid);
		}
		return 1;
	}
	if(dialogid == HOTEL_MONEY)
	{
		new hotelid = pData[playerid][pInHotel];
		if(!Player_OwnsHotel(playerid, pData[playerid][pInHotel])) return Error(playerid, "You don't own this hotel.");
		if(response)
		{
			switch (listitem)
			{
				case 0:
				{
					new str[128];
					format(str, sizeof(str), "Safe Balance: %s\n\nPlease enter how much money you wish to withdraw from the safe:", FormatMoney(htData[hotelid][htMoney]));
					ShowPlayerDialog(playerid, HOTEL_WITHDRAWMONEY, DIALOG_STYLE_INPUT, "Withdraw from safe", str, "Withdraw", "Back");
				}
				case 1:
				{
					new str[128];
					format(str, sizeof(str), "Safe Balance: %s\n\nPlease enter how much money you wish to deposit into the safe:", FormatMoney(htData[hotelid][htMoney]));
					ShowPlayerDialog(playerid, HOTEL_DEPOSITMONEY, DIALOG_STYLE_INPUT, "Deposit into safe", str, "Deposit", "Back");
				}
			}
		}
		else Hotel_OpenStorage(playerid, hotelid);
		return 1;
	}
	if(dialogid == HOTEL_WITHDRAWMONEY)
	{
		new hotelid = pData[playerid][pInHotel];
		if(!Player_OwnsHotel(playerid, pData[playerid][pInHotel])) return Error(playerid, "You don't own this hotel.");

		if(response)
		{
			new amount = strval(inputtext);

			if(isnull(inputtext))
			{
				new str[128];
				format(str, sizeof(str), "Safe Balance: %s\n\nPlease enter how much money you wish to withdraw from the safe:", FormatMoney(htData[hotelid][htMoney]));
				ShowPlayerDialog(playerid, HOTEL_WITHDRAWMONEY, DIALOG_STYLE_INPUT, "Withdraw from safe", str, "Withdraw", "Back");
				return 1;
			}
			if(amount < 1 || amount > htData[hotelid][htMoney])
			{
				new str[128];
				format(str, sizeof(str), "Error: Insufficient funds.\n\nSafe Balance: %s\n\nPlease enter how much money you wish to withdraw from the safe:", FormatMoney(htData[hotelid][htMoney]));
				ShowPlayerDialog(playerid, HOTEL_WITHDRAWMONEY, DIALOG_STYLE_INPUT, "Withdraw from safe", str, "Withdraw", "Back");
				return 1;
			}
			htData[hotelid][htMoney] -= amount;
			GivePlayerMoneyEx(playerid, amount);

			Hotel_Save(hotelid);
			Hotel_OpenStorage(playerid, hotelid);

			SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s has withdrawn %s from their hotel safe.", ReturnName(playerid), FormatMoney(amount));
		}
		else ShowPlayerDialog(playerid, HOTEL_MONEY, DIALOG_STYLE_LIST, "Money Safe", "Withdraw from safe\nDeposit into safe", "Select", "Back");
		return 1;
	}
	if(dialogid == HOTEL_DEPOSITMONEY)
	{
		new hotelid = pData[playerid][pInHotel];
		if(!Player_OwnsHotel(playerid, pData[playerid][pInHotel])) return Error(playerid, "You don't own this hotel.");
		if(response)
		{
			new amount = strval(inputtext);

			if(isnull(inputtext))
			{
				new str[128];
				format(str, sizeof(str), "Safe Balance: %s\n\nPlease enter how much money you wish to deposit into the safe:", FormatMoney(htData[hotelid][htMoney]));
				ShowPlayerDialog(playerid, HOTEL_DEPOSITMONEY, DIALOG_STYLE_INPUT, "Deposit into safe", str, "Deposit", "Back");
				return 1;
			}
			if(amount < 1 || amount > GetPlayerMoney(playerid))
			{
				new str[128];
				format(str, sizeof(str), "Error: Insufficient funds.\n\nSafe Balance: %s\n\nPlease enter how much money you wish to deposit into the safe:", FormatMoney(htData[hotelid][htMoney]));
				ShowPlayerDialog(playerid, HOTEL_DEPOSITMONEY, DIALOG_STYLE_INPUT, "Deposit into safe", str, "Deposit", "Back");
				return 1;
			}
			htData[hotelid][htMoney] += amount;
			GivePlayerMoneyEx(playerid, -amount);

			Hotel_Save(hotelid);
			Hotel_OpenStorage(playerid, hotelid);

			SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s has deposited %s into their hotel safe.", ReturnName(playerid), FormatMoney(amount));
		}
		else ShowPlayerDialog(playerid, HOTEL_MONEY, DIALOG_STYLE_LIST, "Money Safe", "Withdraw from safe\nDeposit into safe", "Select", "Back");
		return 1;
	}
	//------------[ Private Player Vehicle Dialog ]--------
	if(dialogid == DIALOG_FINDVEH)
	{
		if(response)
		{
			ShowPlayerDialog(playerid, DIALOG_TRACKVEH, DIALOG_STYLE_INPUT, "Find Veh", "Enter your own vehicle id:", "Find", "Close");
		}
		return 1;
	}
	if(dialogid == DIALOG_TRACKVEH)
	{
		if(response)
		{
			new Float:posisiX, Float:posisiY, Float:posisiZ,
				carid = strval(inputtext);

			foreach(new veh : PVehicles)
			{
				if(pvData[veh][cVeh] == carid)
				{
					if(IsValidVehicle(pvData[veh][cVeh]))
					{
						if(pvData[veh][cOwner] == pData[playerid][pID])
						{
							GetVehiclePos(carid, posisiX, posisiY, posisiZ);
							pData[playerid][pTrackCar] = 1;
							//SetPlayerCheckpoint(playerid, posisi[0], posisi[1], posisi[2], 4.0);
							SetPlayerRaceCheckpoint(playerid,1, posisiX, posisiY, posisiZ, 0.0, 0.0, 0.0, 3.5);
							Info(playerid, "Your car waypoint was set to \"%s\" (marked on radar).", GetLocation(posisiX, posisiY, posisiZ));
						}
						else return Error(playerid, "Id kendaraan ini bukan milik anda!");
					}
				}
			}
		}
		return 1;
	}
	if(dialogid == DIALOG_GOTOVEH)
	{
		if(response)
		{
			new Float:posisiX, Float:posisiY, Float:posisiZ,
				carid = strval(inputtext);

			GetVehiclePos(carid, posisiX, posisiY, posisiZ);
			Servers(playerid, "Your teleport to %s (vehicle id: %d).", GetLocation(posisiX, posisiY, posisiZ), carid);
			SetPlayerPosition(playerid, posisiX, posisiY, posisiZ+3.0, 4.0, 0);
		}
		return 1;
	}
	if(dialogid == DIALOG_INSURANCE)
	{
		if(response)
		{
			if(pvData[listitem][cClaim] == 1)
			{
				if(pvData[listitem][cClaimTime] != 0)
				{
					Error(playerid, "Sekarang belum saat nya untuk claim kendaraan mu.");
				}
				else
				{
					pvData[listitem][cClaim] = 0;

					OnPlayerVehicleRespawn(listitem);
					pvData[listitem][cPosX] = 1082.3927;
					pvData[listitem][cPosY] = -1772.6974;
					pvData[listitem][cPosZ] = 13.3508;
					pvData[listitem][cPosA] = 90.0956;
					SetValidVehicleHealth(pvData[listitem][cVeh], 1500);
					SetVehiclePos(pvData[listitem][cVeh], 1082.3927, -1772.6974, 13.3508);
					SetVehicleZAngle(pvData[listitem][cVeh], 268.6917);
					SetVehicleFuel(pvData[listitem][cVeh], 1000);
					Info(playerid, "Anda telah mengclaim kendaraan %s anda.", GetVehicleModelName(pvData[listitem][cModel]));
				}
			}	
		}
		return 1;
	}
	if(dialogid == DIALOG_GETVEH)
	{
		if(response)
		{
			new Float:posisiX, Float:posisiY, Float:posisiZ,
				carid = strval(inputtext);

			GetPlayerPos(playerid, posisiX, posisiY, posisiZ);
			Servers(playerid, "Your get spawn vehicle to %s (vehicle id: %d).", GetLocation(posisiX, posisiY, posisiZ), carid);
			SetVehiclePos(carid, posisiX, posisiY, posisiZ+0.5);
		}
		return 1;
	}
	if(dialogid == DIALOG_DELETEVEH)
	{
		if(response)
		{
			new carid = strval(inputtext);

			//for(new i = 0; i != MAX_PRIVATE_VEHICLE; i++) if(Iter_Contains(PVehicles, i))
			foreach(new i : PVehicles)
			{
				if(carid == pvData[i][cVeh])
				{
					new query[128];
					mysql_format(g_SQL, query, sizeof(query), "DELETE FROM vehicle WHERE id = '%d'", pvData[i][cID]);
					mysql_tquery(g_SQL, query);
					DestroyVehicle(pvData[i][cVeh]);
					Iter_SafeRemove(PVehicles, i, i);
					Servers(playerid, "Your deleted private vehicle id %d (database id: %d).", pvData[i][cVeh], pvData[i][cID]);
				}
			}
		}
		return 1;
	}
	if(dialogid == DIALOG_BUYPLATE)
	{
		if(response)
		{
			new carid = strval(inputtext);

			//for(new i = 0; i != MAX_PRIVATE_VEHICLE; i++) if(Iter_Contains(PVehicles, i))
			foreach(new i : PVehicles)
			{
				if(carid == pvData[i][cVeh])
				{
					if(GetPlayerMoney(playerid) < 500) return Error(playerid, "Anda butuh $500 untuk membeli Plate baru.");
					GivePlayerMoneyEx(playerid, -500);
					new rand = RandomEx(1111, 9999);
					format(pvData[i][cPlate], 32, "FI-%d", rand);
					SetVehicleNumberPlate(pvData[i][cVeh], pvData[i][cPlate]);
					pvData[i][cPlateTime] = gettime() + (15 * 86400);
					Info(playerid, "Model: %s || New plate: %s || Plate Time: %s || Plate Price: $500", GetVehicleModelName(pvData[i][cModel]), pvData[i][cPlate], ReturnTimelapse(gettime(), pvData[i][cPlateTime]));
				}
			}
		}
		return 1;
	}
	//--------------[ Vehicle Toy Dialog ]-------------
	if(dialogid == DIALOG_VTOY)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0: //slot 1
				{
					new x = pData[playerid][VehicleID];
					pvData[x][vtoySelected] = 0;
					if(vtData[x][0][vtoy_modelid] == 0)
					{

					}
					else
					{
						new string[512];
						format(string, sizeof(string), ""dot""GREY_E"Edit Vehicle Toys(PC only)\n"dot"Edit Toy Position(Andoid & Pc)\n"dot"Remove Object\n"dot"Show/Hide Object\n"dot"Change Colour\n"dot"Share Position\nPosX: %f\nPosY: %f\nPosZ: %f\nPosRX: %f\nPosRY: %f\nPosRZ: %f",
						vtData[x][pvData[x][vtoySelected]][vtoy_x], vtData[x][pvData[x][vtoySelected]][vtoy_y], vtData[x][pvData[x][vtoySelected]][vtoy_z],
						vtData[x][pvData[x][vtoySelected]][vtoy_rx], vtData[x][pvData[x][vtoySelected]][vtoy_ry], vtData[x][pvData[x][vtoySelected]][vtoy_rz]);
						ShowPlayerDialog(playerid, DIALOG_VTOYEDIT, DIALOG_STYLE_LIST, ""RED_E"Capotaliz Roleplay "WHITE_E"Vehicle Toys", string, "Select", "Cancel");
					}
				}
				case 1: //slot 2
				{
					new x = pData[playerid][VehicleID];
					pvData[x][vtoySelected] = 1;
					if(vtData[x][1][vtoy_modelid] == 0)
					{

					}
					else
					{
						new string[512];
						format(string, sizeof(string), ""dot""GREY_E"Edit Vehicle Toys(PC only)\n"dot"Edit Toy Position(Andoid & Pc)\n"dot"Remove Object\n"dot"Show/Hide Object\n"dot"Change Colour\n"dot"Share Position\nPosX: %f\nPosY: %f\nPosZ: %f\nPosRX: %f\nPosRY: %f\nPosRZ: %f",
						vtData[x][pvData[x][vtoySelected]][vtoy_x], vtData[x][pvData[x][vtoySelected]][vtoy_y], vtData[x][pvData[x][vtoySelected]][vtoy_z],
						vtData[x][pvData[x][vtoySelected]][vtoy_rx], vtData[x][pvData[x][vtoySelected]][vtoy_ry], vtData[x][pvData[x][vtoySelected]][vtoy_rz]);
						ShowPlayerDialog(playerid, DIALOG_VTOYEDIT, DIALOG_STYLE_LIST, ""RED_E"Capitaliz Roleplay "WHITE_E"Vehicle Toys", string, "Select", "Cancel");
					}
				}
				case 2: //slot 3
				{
					new x = pData[playerid][VehicleID];
					pvData[x][vtoySelected] = 2;
					if(vtData[x][2][vtoy_modelid] == 0)
					{

					}
					else
					{
						new string[512];
						format(string, sizeof(string), ""dot""GREY_E"Edit Vehicle Toys(PC only)\n"dot"Edit Toy Position(Andoid & Pc)\n"dot"Remove Object\n"dot"Show/Hide Object\n"dot"Change Colour\n"dot"Share Position\nPosX: %f\nPosY: %f\nPosZ: %f\nPosRX: %f\nPosRY: %f\nPosRZ: %f",
						vtData[x][pvData[x][vtoySelected]][vtoy_x], vtData[x][pvData[x][vtoySelected]][vtoy_y], vtData[x][pvData[x][vtoySelected]][vtoy_z],
						vtData[x][pvData[x][vtoySelected]][vtoy_rx], vtData[x][pvData[x][vtoySelected]][vtoy_ry], vtData[x][pvData[x][vtoySelected]][vtoy_rz]);
						ShowPlayerDialog(playerid, DIALOG_VTOYEDIT, DIALOG_STYLE_LIST, ""RED_E"Capitaliz Roleplay "WHITE_E"Vehicle Toys", string, "Select", "Cancel");
					}
				}
				case 3: //slot 4
				{
					new x = pData[playerid][VehicleID];
					pvData[x][vtoySelected] = 3;
					if(vtData[x][3][vtoy_modelid] == 0)
					{

					}
					else
					{
						new string[512];
						format(string, sizeof(string), ""dot""GREY_E"Edit Vehicle Toys(PC only)\n"dot"Edit Toy Position(Andoid & Pc)\n"dot"Remove Object\n"dot"Show/Hide Object\n"dot"Change Colour\n"dot"Share Position\nPosX: %f\nPosY: %f\nPosZ: %f\nPosRX: %f\nPosRY: %f\nPosRZ: %f",
						vtData[x][pvData[x][vtoySelected]][vtoy_x], vtData[x][pvData[x][vtoySelected]][vtoy_y], vtData[x][pvData[x][vtoySelected]][vtoy_z],
						vtData[x][pvData[x][vtoySelected]][vtoy_rx], vtData[x][pvData[x][vtoySelected]][vtoy_ry], vtData[x][pvData[x][vtoySelected]][vtoy_rz]);
						ShowPlayerDialog(playerid, DIALOG_VTOYEDIT, DIALOG_STYLE_LIST, ""RED_E"Capitaliz Roleplay "WHITE_E"Vehicle Toys", string, "Select", "Cancel");
					}
				}
				case 4:
				{
					new x = pData[playerid][VehicleID];
					if(pvData[x][PurchasedvToy] == true)
					{
						for(new i = 0; i < 4; i++)
						{
							vtData[x][i][vtoy_modelid] = 0;
							vtData[x][i][vtoy_x] = 0.0;
							vtData[x][i][vtoy_y] = 0.0;
							vtData[x][i][vtoy_z] = 0.0;
							vtData[x][i][vtoy_rx] = 0.0;
							vtData[x][i][vtoy_ry] = 0.0;
							vtData[x][i][vtoy_rz] = 0.0;
							DestroyDynamicObject(vtData[x][i][vtoy_model]);
						}
						new string[128];
						mysql_format(g_SQL, string, sizeof(string), "DELETE FROM vtoys WHERE Owner = '%d'", pvData[x][cID]);
						mysql_tquery(g_SQL, string);
						pvData[x][PurchasedvToy] = false;

						GameTextForPlayer(playerid, "~r~~h~All Toy Rested!~y~!", 3000, 4);
					}
				}
				case 5:
				{
					new vehid = pData[playerid][VehicleID];
					for(new i = 0; i < 4; i++)
					{
						DestroyDynamicObject(vtData[vehid][i][vtoy_model]);

						vtData[vehid][pvData[vehid][vtoySelected]][vtoy_model] = CreateDynamicObject(vtData[vehid][i][vtoy_modelid], 0.0, 0.0, -14.0, 0.0, 0.0, 0.0);
						AttachDynamicObjectToVehicle(vtData[vehid][i][vtoy_model],
						vehid,
						vtData[vehid][i][vtoy_x],
						vtData[vehid][i][vtoy_y],
						vtData[vehid][i][vtoy_z],
						vtData[vehid][i][vtoy_rx],
						vtData[vehid][i][vtoy_ry],
						vtData[vehid][i][vtoy_rz]);
					}
					GameTextForPlayer(playerid, "~r~~h~Refresh All Object!~y~!", 3000, 4);
				}
			}
		}
		return 1;
	}
	if(dialogid == DIALOG_VTOYBUY)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0: //slot 1
				{
					new x = pData[playerid][VehicleID];
					pvData[x][vtoySelected] = 0;
					if(vtData[x][0][vtoy_modelid] == 0)
					{
						ShowModelSelectionMenu(playerid, vtoylist, "Select Toy", 0x4A5A6BBB, 0x282828FF, 0x4A5A6BBB);
					}
					else
					{
						ShowPlayerDialog(playerid, DIALOG_VTOYEDIT, DIALOG_STYLE_LIST, ""RED_E"Capitaliz Roleplay "WHITE_E"Vehicle Toys", ""dot"Edit Toy Position\n"dot""GREY_E"Remove Toy", "Select", "Cancel");
					}
				}
				case 1: //slot 2
				{
					new x = pData[playerid][VehicleID];
					pvData[x][vtoySelected] = 1;
					if(vtData[x][1][vtoy_modelid] == 0)
					{
						ShowModelSelectionMenu(playerid, vtoylist, "Select Toy", 0x4A5A6BBB, 0x282828FF, 0x4A5A6BBB);
					}
					else
					{
						ShowPlayerDialog(playerid, DIALOG_VTOYEDIT, DIALOG_STYLE_LIST, ""RED_E"Capitaliz Roleplay "WHITE_E"Vehicle Toys", ""dot"Edit Toy Position\n"dot""GREY_E"Remove Toy", "Select", "Cancel");
					}
				}
				case 2: //slot 3
				{
					new x = pData[playerid][VehicleID];
					pvData[x][vtoySelected] = 2;
					if(vtData[x][2][vtoy_modelid] == 0)
					{
						ShowModelSelectionMenu(playerid, vtoylist, "Select Toy", 0x4A5A6BBB, 0x282828FF, 0x4A5A6BBB);
					}
					else
					{
						ShowPlayerDialog(playerid, DIALOG_VTOYEDIT, DIALOG_STYLE_LIST, ""RED_E"Capitaliz Roleplay "WHITE_E"Vehicle Toys", ""dot"Edit Toy Position\n"dot""GREY_E"Remove Toy", "Select", "Cancel");
					}
				}
				case 3: //slot 4
				{
					new x = pData[playerid][VehicleID];
					pvData[x][vtoySelected] = 3;
					if(vtData[x][3][vtoy_modelid] == 0)
					{
						ShowModelSelectionMenu(playerid, vtoylist, "Select Toy", 0x4A5A6BBB, 0x282828FF, 0x4A5A6BBB);
					}
					else
					{
						ShowPlayerDialog(playerid, DIALOG_VTOYEDIT, DIALOG_STYLE_LIST, ""RED_E"Capitaliz Roleplay "WHITE_E"Vehicle Toys", ""dot"Edit Toy Position\n"dot""GREY_E"Remove Toy", "Select", "Cancel");
					}
				}
			}
		}
		return 1;
	}
	if(dialogid == DIALOG_VTOYEDIT)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0: // edit
				{
					new vehid = pData[playerid][EditingVtoys];
	        		new idxs = pvData[vehid][vtoySelected];
					Info(playerid,"Fungsi ini untuk mengatur berapa jumlah float pos vehicle toys (PC Only)(COMINGSOON)");
					EditDynamicObject(playerid, vtData[vehid][idxs][vtoy_modelid]);
					GetDynamicObjectPos(vtData[vehid][idxs][vtoy_model], vtData[vehid][idxs][vtoy_x], vtData[vehid][idxs][vtoy_y], vtData[vehid][idxs][vtoy_z]);
					GetDynamicObjectRot(vtData[vehid][idxs][vtoy_model], vtData[vehid][idxs][vtoy_rx], vtData[vehid][idxs][vtoy_ry], vtData[vehid][idxs][vtoy_rz]);
					pData[playerid][EditingVtoys] = vehid;
				}
				case 1: // edit
				{
					Info(playerid,"Fungsi ini untuk mengatur berapa jumlah float pos +/- untuk sekali click pada textdraw.");
					ShowPlayerDialog(playerid, VTOYSET_VALUE, DIALOG_STYLE_INPUT, "Vehicle Toy PosX", "Set current float value\nNormal Value = 0.05\n\nEnter Float NudgeValue in here:", "Select", "Back");
				}
				case 2: // remove toy
				{
					new vehid = GetPlayerVehicleID(playerid);
		    		foreach(new i: PVehicles)
					{
						if(vehid == pvData[i][cVeh])
						{
		    				new x = pvData[i][cVeh];
							vtData[x][pvData[x][vtoySelected]][vtoy_modelid] = 0;
							DestroyDynamicObject(vtData[x][pvData[x][vtoySelected]][vtoy_model]);
							GameTextForPlayer(playerid, "~r~~h~Vehicle Toy Removed~y~!", 3000, 4);
							TogglePlayerControllable(playerid, true);
							MySQL_SaveVehicleToys(i);
		    			}
		    		}
				}
				case 3:	//hide/show
				{
					new vehid = pData[playerid][VehicleID];
					if(IsValidObject(vtData[vehid][pvData[vehid][vtoySelected]][vtoy_model]))
					{
						DestroyDynamicObject(vtData[vehid][pvData[vehid][vtoySelected]][vtoy_model]);
						GameTextForPlayer(playerid, "~r~~h~Object Hide~y~!", 3000, 4);
					}
					else
					{
					    vtData[vehid][pvData[vehid][vtoySelected]][vtoy_model] = CreateDynamicObject(vtData[vehid][pvData[vehid][vtoySelected]][vtoy_modelid], 0.0, 0.0, -14.0, 0.0, 0.0, 0.0);
						AttachDynamicObjectToVehicle(vtData[vehid][pvData[vehid][vtoySelected]][vtoy_model],
						vehid,
						vtData[vehid][pvData[vehid][vtoySelected]][vtoy_x],
						vtData[vehid][pvData[vehid][vtoySelected]][vtoy_y],
						vtData[vehid][pvData[vehid][vtoySelected]][vtoy_z],
						vtData[vehid][pvData[vehid][vtoySelected]][vtoy_rx],
						vtData[vehid][pvData[vehid][vtoySelected]][vtoy_ry],
						vtData[vehid][pvData[vehid][vtoySelected]][vtoy_rz]);
						GameTextForPlayer(playerid, "~r~~h~Object Show~y~!", 3000, 4);
					}
				}
				case 4:	//change toy colour
				{
					Servers(playerid,"Fungsi ini belum permanent");
					ShowPlayerDialog(playerid, VTOYSET_COLOUR, DIALOG_STYLE_LIST, "Select Object Colour", "White\nBlack\nRed\nBlue\nYellow", "Select", "Back");
				}
				case 5:	//share toy pos
				{
					new x = pData[playerid][VehicleID];
					SendNearbyMessage(playerid, 10.0, COLOR_GREEN, "[VTOY BY %s] "WHITE_E"PosX: %.3f | PosY: %.3f | PosZ: %.3f | PosRX: %.3f | PosRY: %.3f | PosRZ: %.3f",
					ReturnName(playerid), vtData[x][pvData[x][vtoySelected]][vtoy_x], vtData[x][pvData[x][vtoySelected]][vtoy_y], vtData[x][pvData[x][vtoySelected]][vtoy_z],
					vtData[x][pvData[x][vtoySelected]][vtoy_rx], vtData[x][pvData[x][vtoySelected]][vtoy_ry], vtData[x][pvData[x][vtoySelected]][vtoy_rz]);
				}
				case 6: //Pos X
				{
					new x = pData[playerid][VehicleID];
					new mstr[128];
					format(mstr, sizeof(mstr), ""WHITE_E"Current vehicle Toy PosX: %f\nInput new Toy PosX:(Float)", vtData[x][pvData[x][vtoySelected]][vtoy_x]);
					ShowPlayerDialog(playerid, DIALOG_VTOYPOSX, DIALOG_STYLE_INPUT, "vehicle Toy PosX", mstr, "Edit", "Cancel");
				}
				case 7: //Pos Y
				{
					new x = pData[playerid][VehicleID];
					new mstr[128];
					format(mstr, sizeof(mstr), ""WHITE_E"Current vehicle Toy PosY: %f\nInput new Toy PosY:(Float)", vtData[x][pvData[x][vtoySelected]][vtoy_y]);
					ShowPlayerDialog(playerid, DIALOG_VTOYPOSY, DIALOG_STYLE_INPUT, "vehicle Toy PosY", mstr, "Edit", "Cancel");
				}
				case 8: //Pos Z
				{
					new x = pData[playerid][VehicleID];
					new mstr[128];
					format(mstr, sizeof(mstr), ""WHITE_E"Current vehicle Toy PosZ: %f\nInput new Toy PosZ:(Float)", vtData[x][pvData[x][vtoySelected]][vtoy_z]);
					ShowPlayerDialog(playerid, DIALOG_VTOYPOSZ, DIALOG_STYLE_INPUT, "vehicle Toy PosZ", mstr, "Edit", "Cancel");
				}
				case 9: //Pos RX
				{
					new x = pData[playerid][VehicleID];
					new mstr[128];
					format(mstr, sizeof(mstr), ""WHITE_E"Current vehicle Toy PosRX: %f\nInput new Toy PosRX:(Float)", vtData[x][pvData[x][vtoySelected]][vtoy_rx]);
					ShowPlayerDialog(playerid, DIALOG_VTOYPOSRX, DIALOG_STYLE_INPUT, "vehicle Toy PosRX", mstr, "Edit", "Cancel");
				}
				case 10: //Pos RY
				{
					new x = pData[playerid][VehicleID];
					new mstr[128];
					format(mstr, sizeof(mstr), ""WHITE_E"Current vehicle Toy PosRY: %f\nInput new Toy PosRY:(Float)", vtData[x][pvData[x][vtoySelected]][vtoy_ry]);
					ShowPlayerDialog(playerid, DIALOG_VTOYPOSRY, DIALOG_STYLE_INPUT, "Toy PosRY", mstr, "Edit", "Cancel");
				}
				case 11: //Pos RZ
				{
					new x = pData[playerid][VehicleID];
					new mstr[128];
					format(mstr, sizeof(mstr), ""WHITE_E"Current vehicle Toy PosRZ: %f\nInput new Toy PosRZ:(Float)", vtData[x][pvData[x][vtoySelected]][vtoy_rz]);
					ShowPlayerDialog(playerid, DIALOG_VTOYPOSRZ, DIALOG_STYLE_INPUT, "Toy PosRZ", mstr, "Edit", "Cancel");
				}
			}
		}
		return 1;
	}
	if(dialogid == VTOY_ACCEPT)
	{
		if(response)
		{
			new x = GetPlayerVehicleID(playerid);
			foreach(new i: PVehicles)
			{
				if(x == pvData[i][cVeh])
				{
					MySQL_SaveVehicleToys(i);
					pvData[pvData[i][cVeh]][PurchasedvToy] = true;
					GivePlayerMoneyEx(playerid, -5000);
					Servers(playerid, "Succes Save This Object and paying "LG_E"$50.00");
				}
			}
		}
		else
		{
			new vehid = GetPlayerVehicleID(playerid);
    		foreach(new i: PVehicles)
			{
				if(vehid == pvData[i][cVeh])
				{
    				new x = pvData[i][cVeh];
					vtData[x][pvData[x][vtoySelected]][vtoy_modelid] = 0;
					DestroyDynamicObject(vtData[x][pvData[x][vtoySelected]][vtoy_model]);
					GameTextForPlayer(playerid, "~r~~h~Vehicle Toy Removed~y~!", 3000, 4);
					pvData[pvData[i][cVeh]][PurchasedvToy] = true;
    			}
    		}
		}
	}
	if(dialogid == VTOYSET_VALUE)
	{
		if(response)
		{
			if(isnull(inputtext))
			{
				NudgeVal[playerid] = 0.05;
				ShowPlayerDialog(playerid, VSELECT_POS, DIALOG_STYLE_LIST, "Select Editing Pos", "Position X\nPosition Y\nPosition Z\nPosition RX\nPosition RY\nPosition RZ", "Select", "Back");
			}
			else
			{
				NudgeVal[playerid] = floatstr(inputtext);
				ShowPlayerDialog(playerid, VSELECT_POS, DIALOG_STYLE_LIST, "Select Editing Pos", "Position X\nPosition Y\nPosition Z\nPosition RX\nPosition RY\nPosition RZ", "Select", "Back");
			}
		}
	}
	if(dialogid == VTOYSET_COLOUR)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0: //White
				{
					new x = pData[playerid][VehicleID];
					SetObjectMaterial(vtData[x][pvData[x][vtoySelected]][vtoy_model], 0, 18955, "Jester", "wall6", 0xFFFFFFAA);
					Servers(playerid, "Anda Telah berhasil mengubah warna object");
					SCM(playerid, 0xFFFFFFAA, "White");
				}
				case 1: //Black
				{
					new x = pData[playerid][VehicleID];
					SetObjectMaterial(vtData[x][pvData[x][vtoySelected]][vtoy_model], 0, 18955, "Jester", "wall6", 0xFF000000);
					SCM(playerid, 0xFF000000, "Black");
				}
				case 2: //Red
				{
					new x = pData[playerid][VehicleID];
					SetObjectMaterial(vtData[x][pvData[x][vtoySelected]][vtoy_model], 0, 18955, "Jester", "wall6", 0xFF0000FF);
					SCM(playerid, 0xFF0000FF, "Red");
				}
				case 3: //Blue
				{
					new x = pData[playerid][VehicleID];
					SetObjectMaterial(vtData[x][pvData[x][vtoySelected]][vtoy_model], 0, 18955, "Jester", "wall6", 0x004BFFFF);
					SCM(playerid, 0x004BFFFF, "Blue");
				}
				case 4: //Yellow
				{
					new x = pData[playerid][VehicleID];
					SetObjectMaterial(vtData[x][pvData[x][vtoySelected]][vtoy_model], 0, 18955, "Jester", "wall6", 0xFFFF00FF);
					SCM(playerid, 0xFFFF00FF, "Yellow");
				}
			}
		}
	}
	if(dialogid == VSELECT_POS)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0: //Pos X
				{
					pData[playerid][EditStatus] = FloatX;
					ShowEditVehicleTD(playerid);
					Servers(playerid, "You are now editing vehicle toys position 'X', one click to add %f", NudgeVal[playerid]);
				}
				case 1: //Pos Y
				{
					pData[playerid][EditStatus] = FloatY;
					ShowEditVehicleTD(playerid);
					Servers(playerid, "You are now editing vehicle toys position 'Y', one click to add %f", NudgeVal[playerid]);
				}
				case 2: //Pos Z
				{
					pData[playerid][EditStatus] = FloatZ;
					ShowEditVehicleTD(playerid);
					Servers(playerid, "You are now editing vehicle toys position 'Z', one click to add %f", NudgeVal[playerid]);
				}
				case 3: //Pos RX
				{
					pData[playerid][EditStatus] = FloatRX;
					ShowEditVehicleTD(playerid);
					Servers(playerid, "You are now editing vehicle toys position 'RX', one click to add %f", NudgeVal[playerid]);
				}
				case 4: //Pos RY
				{
					pData[playerid][EditStatus] = FloatRY;
					ShowEditVehicleTD(playerid);
					Servers(playerid, "You are now editing vehicle toys position 'RY', one click to add %f", NudgeVal[playerid]);
				}
				case 5: //Pos RZ
				{
					pData[playerid][EditStatus] = FloatRZ;
					ShowEditVehicleTD(playerid);
					Servers(playerid, "You are now editing vehicle toys position 'RZ', one click to add %f", NudgeVal[playerid]);
				}
			}
		}
	}
	if(dialogid == DIALOG_VTOYPOSX)
	{
		if(response)
		{
			new Float:posisi = floatstr(inputtext), vehid = pData[playerid][VehicleID], idxs = pvData[pData[playerid][VehicleID]][vtoySelected];

			AttachDynamicObjectToVehicle(vtData[vehid][idxs][vtoy_model],
			vehid,
			posisi,
			vtData[vehid][idxs][vtoy_y],
			vtData[vehid][idxs][vtoy_z],
			vtData[vehid][idxs][vtoy_rx],
			vtData[vehid][idxs][vtoy_ry],
			vtData[vehid][idxs][vtoy_rz]);

			vtData[vehid][idxs][vtoy_x] = posisi;
			new x = GetPlayerVehicleID(playerid);
			foreach(new i: PVehicles)
			{
				if(x == pvData[i][cVeh])
				{
					MySQL_SaveVehicleToys(i);
				}
			}
			new string[512];
			format(string, sizeof(string), ""dot""GREY_E"Edit Toy Position(Andoid & Pc)\n"dot"Remove vtoy\n"dot"Show/Hide Object\n"dot"Share Position\nPosX: %f\nPosY: %f\nPosZ: %f\nPosRX: %f\nPosRY: %f\nPosRZ: %f",
			vtData[vehid][idxs][vtoy_x], vtData[vehid][idxs][vtoy_y], vtData[vehid][idxs][vtoy_z],
			vtData[vehid][idxs][vtoy_rx], vtData[vehid][idxs][vtoy_ry], vtData[vehid][idxs][vtoy_rz]);
			ShowPlayerDialog(playerid, DIALOG_VTOYEDIT, DIALOG_STYLE_LIST, ""RED_E"Capitaliz Roleplay "WHITE_E"Vehicle Toys", string, "Select", "Cancel");
		}
	}
	if(dialogid == DIALOG_VTOYPOSY)
	{
		if(response)
		{
			new Float:posisi = floatstr(inputtext), vehid = pData[playerid][VehicleID], idxs = pvData[pData[playerid][VehicleID]][vtoySelected];

			AttachDynamicObjectToVehicle(vtData[vehid][idxs][vtoy_model],
			vehid,
			vtData[vehid][idxs][vtoy_x],
			posisi,
			vtData[vehid][idxs][vtoy_z],
			vtData[vehid][idxs][vtoy_rx],
			vtData[vehid][idxs][vtoy_ry],
			vtData[vehid][idxs][vtoy_rz]);

			vtData[vehid][idxs][vtoy_y] = posisi;
			new x = GetPlayerVehicleID(playerid);
			foreach(new i: PVehicles)
			{
				if(x == pvData[i][cVeh])
				{
					MySQL_SaveVehicleToys(i);
				}
			}

			new string[512];
			format(string, sizeof(string), ""dot""GREY_E"Edit Toy Position(Andoid & Pc)\n"dot"Remove vtoy\n"dot"Show/Hide Object\n"dot"Share Position\nPosX: %f\nPosY: %f\nPosZ: %f\nPosRX: %f\nPosRY: %f\nPosRZ: %f",
			vtData[vehid][idxs][vtoy_x], vtData[vehid][idxs][vtoy_y], vtData[vehid][idxs][vtoy_z],
			vtData[vehid][idxs][vtoy_rx], vtData[vehid][idxs][vtoy_ry], vtData[vehid][idxs][vtoy_rz]);
			ShowPlayerDialog(playerid, DIALOG_VTOYEDIT, DIALOG_STYLE_LIST, ""RED_E"Capitaliz Roleplay "WHITE_E"Vehicle Toys", string, "Select", "Cancel");
		}
	}
	if(dialogid == DIALOG_VTOYPOSZ)
	{
		if(response)
		{
			new Float:posisi = floatstr(inputtext), vehid = pData[playerid][VehicleID], idxs = pvData[pData[playerid][VehicleID]][vtoySelected];

			AttachDynamicObjectToVehicle(vtData[vehid][idxs][vtoy_model],
			vehid,
			vtData[vehid][idxs][vtoy_x],
			vtData[vehid][idxs][vtoy_y],
			posisi,
			vtData[vehid][idxs][vtoy_rx],
			vtData[vehid][idxs][vtoy_ry],
			vtData[vehid][idxs][vtoy_rz]);

			vtData[vehid][idxs][vtoy_z] = posisi;
			new x = GetPlayerVehicleID(playerid);
			foreach(new i: PVehicles)
			{
				if(x == pvData[i][cVeh])
				{
					MySQL_SaveVehicleToys(i);
				}
			}

			new string[512];
			format(string, sizeof(string), ""dot""GREY_E"Edit Toy Position(Andoid & Pc)\n"dot"Remove vtoy\n"dot"Show/Hide Object\n"dot"Share Position\nPosX: %f\nPosY: %f\nPosZ: %f\nPosRX: %f\nPosRY: %f\nPosRZ: %f",
			vtData[vehid][idxs][vtoy_x], vtData[vehid][idxs][vtoy_y], vtData[vehid][idxs][vtoy_z],
			vtData[vehid][idxs][vtoy_rx], vtData[vehid][idxs][vtoy_ry], vtData[vehid][idxs][vtoy_rz]);
			ShowPlayerDialog(playerid, DIALOG_VTOYEDIT, DIALOG_STYLE_LIST, ""RED_E"Capitaliz Roleplay "WHITE_E"Vehicle Toys", string, "Select", "Cancel");
		}
	}
	if(dialogid == DIALOG_VTOYPOSRX)
	{
		if(response)
		{
			new Float:posisi = floatstr(inputtext), vehid = pData[playerid][VehicleID], idxs = pvData[pData[playerid][VehicleID]][vtoySelected];

			AttachDynamicObjectToVehicle(vtData[vehid][idxs][vtoy_model],
			vehid,
			vtData[vehid][idxs][vtoy_x],
			vtData[vehid][idxs][vtoy_y],
			vtData[vehid][idxs][vtoy_z],
			posisi,
			vtData[vehid][idxs][vtoy_ry],
			vtData[vehid][idxs][vtoy_rz]);

			vtData[vehid][idxs][vtoy_rx] = posisi;
			new x = GetPlayerVehicleID(playerid);
			foreach(new i: PVehicles)
			{
				if(x == pvData[i][cVeh])
				{
					MySQL_SaveVehicleToys(i);
				}
			}

			new string[512];
			format(string, sizeof(string), ""dot""GREY_E"Edit Toy Position(Andoid & Pc)\n"dot"Remove vtoy\n"dot"Show/Hide Object\n"dot"Share Position\nPosX: %f\nPosY: %f\nPosZ: %f\nPosRX: %f\nPosRY: %f\nPosRZ: %f",
			vtData[vehid][idxs][vtoy_x], vtData[vehid][idxs][vtoy_y], vtData[vehid][idxs][vtoy_z],
			vtData[vehid][idxs][vtoy_rx], vtData[vehid][idxs][vtoy_ry], vtData[vehid][idxs][vtoy_rz]);
			ShowPlayerDialog(playerid, DIALOG_VTOYEDIT, DIALOG_STYLE_LIST, ""RED_E"Capitaliz Roleplay "WHITE_E"Vehicle Toys", string, "Select", "Cancel");
		}
	}
	if(dialogid == DIALOG_VTOYPOSRY)
	{
		if(response)
		{
			new Float:posisi = floatstr(inputtext), vehid = pData[playerid][VehicleID], idxs = pvData[pData[playerid][VehicleID]][vtoySelected];

			AttachDynamicObjectToVehicle(vtData[vehid][idxs][vtoy_model],
			vehid,
			vtData[vehid][idxs][vtoy_x],
			vtData[vehid][idxs][vtoy_y],
			vtData[vehid][idxs][vtoy_z],
			vtData[vehid][idxs][vtoy_rx],
			posisi,
			vtData[vehid][idxs][vtoy_rz]);

			vtData[vehid][idxs][vtoy_ry] = posisi;
			new x = GetPlayerVehicleID(playerid);
			foreach(new i: PVehicles)
			{
				if(x == pvData[i][cVeh])
				{
					MySQL_SaveVehicleToys(i);
				}
			}

			new string[512];
			format(string, sizeof(string), ""dot""GREY_E"Edit Toy Position(Andoid & Pc)\n"dot"Remove vtoy\n"dot"Show/Hide Object\n"dot"Share Position\nPosX: %f\nPosY: %f\nPosZ: %f\nPosRX: %f\nPosRY: %f\nPosRZ: %f",
			vtData[vehid][idxs][vtoy_x], vtData[vehid][idxs][vtoy_y], vtData[vehid][idxs][vtoy_z],
			vtData[vehid][idxs][vtoy_rx], vtData[vehid][idxs][vtoy_ry], vtData[vehid][idxs][vtoy_rz]);
			ShowPlayerDialog(playerid, DIALOG_VTOYEDIT, DIALOG_STYLE_LIST, ""RED_E"Capitaliz Roleplay "WHITE_E"Vehicle Toys", string, "Select", "Cancel");
		}
	}
	if(dialogid == DIALOG_VTOYPOSRZ)
	{
		if(response)
		{
			new Float:posisi = floatstr(inputtext), vehid = pData[playerid][VehicleID], idxs = pvData[pData[playerid][VehicleID]][vtoySelected];

			AttachDynamicObjectToVehicle(vtData[vehid][idxs][vtoy_model],
			vehid,
			vtData[vehid][idxs][vtoy_x],
			vtData[vehid][idxs][vtoy_y],
			vtData[vehid][idxs][vtoy_z],
			vtData[vehid][idxs][vtoy_rx],
			vtData[vehid][idxs][vtoy_ry],
			posisi);

			vtData[vehid][idxs][vtoy_rz] = posisi;
			new x = GetPlayerVehicleID(playerid);
			foreach(new i: PVehicles)
			{
				if(x == pvData[i][cVeh])
				{
					MySQL_SaveVehicleToys(i);
				}
			}

			new string[512];
			format(string, sizeof(string), ""dot""GREY_E"Edit Toy Position(Andoid & Pc)\n"dot"Remove vtoy\n"dot"Show/Hide Object\n"dot"Share Position\nPosX: %f\nPosY: %f\nPosZ: %f\nPosRX: %f\nPosRY: %f\nPosRZ: %f",
			vtData[vehid][idxs][vtoy_x], vtData[vehid][idxs][vtoy_y], vtData[vehid][idxs][vtoy_z],
			vtData[vehid][idxs][vtoy_rx], vtData[vehid][idxs][vtoy_ry], vtData[vehid][idxs][vtoy_rz]);
			ShowPlayerDialog(playerid, DIALOG_VTOYEDIT, DIALOG_STYLE_LIST, ""RED_E"Capitaliz Roleplay "WHITE_E"Vehicle Toys", string, "Select", "Cancel");
		}
	}
	if(dialogid == DIALOG_RADIO_SONG)//RADIO
	{
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
					new vehicleid = GetNearestVehicleToPlayer(playerid, 5.0, false);
					GetVehiclePos(vehicleid, pvData[vehicleid][cPosX], pvData[vehicleid][cPosY], pvData[vehicleid][cPosZ]);
					foreach(new i : Player)
					{
						if(IsPlayerInAnyVehicle(i) && GetPlayerVehicleID(i) == GetPlayerVehicleID(playerid))
						{
							pvData[vehicleid][cRadio] = 1;
							PlayAudioStreamForPlayer(i, "https://s7.alhastream.com/radio/8350/radio?16018459773", pvData[vehicleid][cPosX], pvData[vehicleid][cPosY], pvData[vehicleid][cPosZ], 5.0, false);
							Servers(playerid, "Lagu Radio Sannews Sudah Di Nyalakan.");
						}
					}
				}
				case 1:
				{
					new vehicleid = GetNearestVehicleToPlayer(playerid, 5.0, false);
					GetVehiclePos(vehicleid, pvData[vehicleid][cPosX], pvData[vehicleid][cPosY], pvData[vehicleid][cPosZ]);
					foreach(new i : Player)
					{
						if(IsPlayerInAnyVehicle(i) && GetPlayerVehicleID(i) == GetPlayerVehicleID(playerid))
						{
							pvData[vehicleid][cRadio] = 3;
							PlayAudioStreamForPlayer(i, "https://powerhitz.com/1power.pls", pvData[vehicleid][cPosX], pvData[vehicleid][cPosY], pvData[vehicleid][cPosZ], 5.0, false);
							Servers(playerid, "Lagu Radio PowerHitz Sudah Di Nyalakan.");
						}
					}
				}
				case 2:
				{
					new vehicleid = GetNearestVehicleToPlayer(playerid, 5.0, false); 
					new mstr[248];
					format(mstr,sizeof(mstr),"Masukkan lagu untuk mobil yang kamu inginkan\nMaksimal 40 karakter", pvData[vehicleid][cSong]);
					ShowPlayerDialog(playerid, DIALOG_RADIO_SERVER, DIALOG_STYLE_INPUT,"Private Song", mstr,"Done","Back");
				}
			}
		}
		return 1;
	}
	if(dialogid == DIALOG_RADIO_SERVER)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
					if (isnull(inputtext))
					{
						new vehicleid = GetNearestVehicleToPlayer(playerid, 5.0, false);
						new mstr[512];
						format(mstr,sizeof(mstr),""RED_E"Error: "WHITE_E"Masukkan URL lagu untuk kendaraan anda!\n", pvData[vehicleid][cSong]);
						ShowPlayerDialog(playerid, DIALOG_RADIO_SERVER, DIALOG_STYLE_INPUT,"Private Song", mstr,"Done","Back");
						return 1;
					}
					if(strlen(inputtext) > 70 || strlen(inputtext) < 5)
					{
						new vehicleid = GetNearestVehicleToPlayer(playerid, 5.0, false);
						new mstr[512];
						format(mstr,sizeof(mstr),""RED_E"Error: "WHITE_E"URL lagu harus 5 sampai 70 karakter.", pvData[vehicleid][cSong]);
						ShowPlayerDialog(playerid, DIALOG_RADIO_SERVER, DIALOG_STYLE_INPUT,"Private Song", mstr,"Done","Back");
						return 1;
					}
					new vehicleid = GetNearestVehicleToPlayer(playerid, 5.0, false);
					format(pvData[vehicleid][cSong], 40, ColouredText(inputtext));

					Servers(playerid, "Vehicle song set to: \"%s\", nyalakan lagu nya di /radio private > togglesong", pvData[vehicleid][cSong]);
				}
				case 1:
				{
					new vehicleid = GetNearestVehicleToPlayer(playerid, 5.0, false);
					GetVehiclePos(vehicleid, pvData[vehicleid][cPosX], pvData[vehicleid][cPosY], pvData[vehicleid][cPosZ]);
					foreach(new i : Player)
					{
						if(IsPlayerInAnyVehicle(i) && GetPlayerVehicleID(i) == GetPlayerVehicleID(playerid))
						{
							pvData[vehicleid][cRadio] = 2;
							PlayAudioStreamForPlayer(i, pvData[vehicleid][cSong], pvData[vehicleid][cPosX], pvData[vehicleid][cPosY], pvData[vehicleid][cPosZ], 5.0, false);
							Servers(playerid, "Lagu Private Sudah Di Nyalakan.");
						}
					}
				}
			}
		}
		return 1;
	}
	//--------------[ Player Toy Dialog ]-------------
	if(dialogid == DIALOG_TOY)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0: //slot 1
				{
					pData[playerid][toySelected] = 0;
					if(pToys[playerid][0][toy_model] == 0)
					{
						//ShowModelSelectionMenu(playerid, toyslist, "Select Toy", 0x4A5A6BBB, 0x282828FF, 0x4A5A6BBB);
					}
					else
					{
						new string[512];
						format(string, sizeof(string), ""dot"Edit Toy Position(PC)\n"dot"Edit Toy Position(Android)\n"dot"Change Bone\n"dot""GREY_E"Remove Toy\n"dot"Hide/Show Toy\n"dot"Share Toy Pos\nPosX: %f\nPosY: %f\nPosZ: %f\nPosRX: %f\nPosRY: %f\nPosRZ: %f\nScaleX: %f\nScaleY: %f\nScaleZ: %f",
						pToys[playerid][pData[playerid][toySelected]][toy_x], pToys[playerid][pData[playerid][toySelected]][toy_y], pToys[playerid][pData[playerid][toySelected]][toy_z],
						pToys[playerid][pData[playerid][toySelected]][toy_rx], pToys[playerid][pData[playerid][toySelected]][toy_ry], pToys[playerid][pData[playerid][toySelected]][toy_rz],
						pToys[playerid][pData[playerid][toySelected]][toy_sx], pToys[playerid][pData[playerid][toySelected]][toy_sy], pToys[playerid][pData[playerid][toySelected]][toy_sz]);
						ShowPlayerDialog(playerid, DIALOG_TOYEDIT, DIALOG_STYLE_LIST, ""RED_E"HB:PR "WHITE_E"Player Toys", string, "Select", "Cancel");
					}
				}
				case 1: //slot 2
				{
					pData[playerid][toySelected] = 1;
					if(pToys[playerid][1][toy_model] == 0)
					{
						//ShowModelSelectionMenu(playerid, toyslist, "Select Toy", 0x4A5A6BBB, 0x282828FF, 0x4A5A6BBB);
					}
					else
					{
						new string[512];
						format(string, sizeof(string), ""dot"Edit Toy Position(PC)\n"dot"Edit Toy Position(Android)\n"dot"Change Bone\n"dot""GREY_E"Remove Toy\n"dot"Hide/Show Toy\n"dot"Share Toy Pos\nPosX: %f\nPosY: %f\nPosZ: %f\nPosRX: %f\nPosRY: %f\nPosRZ: %f\nScaleX: %f\nScaleY: %f\nScaleZ: %f",
						pToys[playerid][pData[playerid][toySelected]][toy_x], pToys[playerid][pData[playerid][toySelected]][toy_y], pToys[playerid][pData[playerid][toySelected]][toy_z],
						pToys[playerid][pData[playerid][toySelected]][toy_rx], pToys[playerid][pData[playerid][toySelected]][toy_ry], pToys[playerid][pData[playerid][toySelected]][toy_rz],
						pToys[playerid][pData[playerid][toySelected]][toy_sx], pToys[playerid][pData[playerid][toySelected]][toy_sy], pToys[playerid][pData[playerid][toySelected]][toy_sz]);
						ShowPlayerDialog(playerid, DIALOG_TOYEDIT, DIALOG_STYLE_LIST, ""RED_E"HB:PR "WHITE_E"Player Toys", string, "Select", "Cancel");
					}
				}
				case 2: //slot 3
				{
					pData[playerid][toySelected] = 2;
					if(pToys[playerid][2][toy_model] == 0)
					{
						//ShowModelSelectionMenu(playerid, toyslist, "Select Toy", 0x4A5A6BBB, 0x282828FF, 0x4A5A6BBB);
					}
					else
					{
						new string[512];
						format(string, sizeof(string), ""dot"Edit Toy Position(PC)\n"dot"Edit Toy Position(Android)\n"dot"Change Bone\n"dot""GREY_E"Remove Toy\n"dot"Hide/Show Toy\n"dot"Share Toy Pos\nPosX: %f\nPosY: %f\nPosZ: %f\nPosRX: %f\nPosRY: %f\nPosRZ: %f\nScaleX: %f\nScaleY: %f\nScaleZ: %f",
						pToys[playerid][pData[playerid][toySelected]][toy_x], pToys[playerid][pData[playerid][toySelected]][toy_y], pToys[playerid][pData[playerid][toySelected]][toy_z],
						pToys[playerid][pData[playerid][toySelected]][toy_rx], pToys[playerid][pData[playerid][toySelected]][toy_ry], pToys[playerid][pData[playerid][toySelected]][toy_rz],
						pToys[playerid][pData[playerid][toySelected]][toy_sx], pToys[playerid][pData[playerid][toySelected]][toy_sy], pToys[playerid][pData[playerid][toySelected]][toy_sz]);
						ShowPlayerDialog(playerid, DIALOG_TOYEDIT, DIALOG_STYLE_LIST, ""RED_E"HB:PR "WHITE_E"Player Toys", string, "Select", "Cancel");
					}
				}
				case 3: //slot 4
				{
					pData[playerid][toySelected] = 3;
					if(pToys[playerid][3][toy_model] == 0)
					{
						//ShowModelSelectionMenu(playerid, toyslist, "Select Toy", 0x4A5A6BBB, 0x282828FF, 0x4A5A6BBB);
					}
					else
					{
						new string[512];
						format(string, sizeof(string), ""dot"Edit Toy Position(PC)\n"dot"Edit Toy Position(Android)\n"dot"Change Bone\n"dot""GREY_E"Remove Toy\n"dot"Hide/Show Toy\n"dot"Share Toy Pos\nPosX: %f\nPosY: %f\nPosZ: %f\nPosRX: %f\nPosRY: %f\nPosRZ: %f\nScaleX: %f\nScaleY: %f\nScaleZ: %f",
						pToys[playerid][pData[playerid][toySelected]][toy_x], pToys[playerid][pData[playerid][toySelected]][toy_y], pToys[playerid][pData[playerid][toySelected]][toy_z],
						pToys[playerid][pData[playerid][toySelected]][toy_rx], pToys[playerid][pData[playerid][toySelected]][toy_ry], pToys[playerid][pData[playerid][toySelected]][toy_rz],
						pToys[playerid][pData[playerid][toySelected]][toy_sx], pToys[playerid][pData[playerid][toySelected]][toy_sy], pToys[playerid][pData[playerid][toySelected]][toy_sz]);
						ShowPlayerDialog(playerid, DIALOG_TOYEDIT, DIALOG_STYLE_LIST, ""RED_E"HB:PR "WHITE_E"Player Toys", string, "Select", "Cancel");
					}
				}
				case 4:
				{
					if(pData[playerid][PurchasedToy] == true)
					{
						for(new i = 0; i < 4; i++)
						{
							pToys[playerid][i][toy_model] = 0;
							pToys[playerid][i][toy_bone] = 1;
							pToys[playerid][i][toy_x] = 0.0;
							pToys[playerid][i][toy_y] = 0.0;
							pToys[playerid][i][toy_z] = 0.0;
							pToys[playerid][i][toy_rx] = 0.0;
							pToys[playerid][i][toy_ry] = 0.0;
							pToys[playerid][i][toy_rz] = 0.0;
							pToys[playerid][i][toy_sx] = 1.0;
							pToys[playerid][i][toy_sy] = 1.0;
							pToys[playerid][i][toy_sz] = 1.0;

							if(IsPlayerAttachedObjectSlotUsed(playerid, i))
							{
								RemovePlayerAttachedObject(playerid, i);
							}
						}
						new string[128];
						mysql_format(g_SQL, string, sizeof(string), "DELETE FROM toys WHERE Owner = '%s'", pData[playerid][pName]);
						mysql_tquery(g_SQL, string);
						pData[playerid][PurchasedToy] = false;
						GameTextForPlayer(playerid, "~r~~h~All Toy Rested!~y~!", 3000, 4);
					}
				}
			}
		}
		return 1;
	}
	if(dialogid == DIALOG_TOYEDIT)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0: // edit
				{
					//if(IsPlayerAndroid(playerid))
					//	return Error(playerid, "You're connected from android. This feature only for PC users!");

					EditAttachedObject(playerid, pData[playerid][toySelected]);
					InfoTD_MSG(playerid, 4000, "~b~~h~You are now editing your toy.");
				}
				case 1: // td edit
				{
					Info(playerid,"Fungsi ini untuk mengatur berapa jumlah float pos +/- untuk sekali click pada textdraw.");
					ShowPlayerDialog(playerid, TOYSET_VALUE, DIALOG_STYLE_INPUT, "Vehicle Toy PosX", "Set current float value\nNormal Value = 0.01\n\nEnter Float NudgeValue in here:", "Select", "Back");
				}
				case 2: // change bone
				{
					new finstring[750];

					strcat(finstring, ""dot"Spine\n"dot"Head\n"dot"Left upper arm\n"dot"Right upper arm\n"dot"Left hand\n"dot"Right hand\n"dot"Left thigh\n"dot"Right tigh\n"dot"Left foot\n"dot"Right foot");
					strcat(finstring, "\n"dot"Right calf\n"dot"Left calf\n"dot"Left forearm\n"dot"Right forearm\n"dot"Left clavicle\n"dot"Right clavicle\n"dot"Neck\n"dot"Jaw");

					ShowPlayerDialog(playerid, DIALOG_TOYPOSISI, DIALOG_STYLE_LIST, ""RED_E"FIRP: "WHITE_E"Player Toys", finstring, "Select", "Cancel");
				}
				case 3: // remove toy
				{
					if(IsPlayerAttachedObjectSlotUsed(playerid, pData[playerid][toySelected]))
					{
						RemovePlayerAttachedObject(playerid, pData[playerid][toySelected]);
					}
					pToys[playerid][pData[playerid][toySelected]][toy_model] = 0;
					GameTextForPlayer(playerid, "~r~~h~Toy Removed~y~!", 3000, 4);
					SetPVarInt(playerid, "UpdatedToy", 1);
					TogglePlayerControllable(playerid, true);
				}
				case 4:
				{
				    if(IsPlayerAttachedObjectSlotUsed(playerid, pData[playerid][toySelected]))
					{
						RemovePlayerAttachedObject(playerid, pData[playerid][toySelected]);
						GameTextForPlayer(playerid, "~r~~h~Toy Hide~y~!", 3000, 4);
					}
					else
					{
					    SetPlayerAttachedObject(playerid, pData[playerid][toySelected],
						pToys[playerid][pData[playerid][toySelected]][toy_model],
						pToys[playerid][pData[playerid][toySelected]][toy_bone],
						pToys[playerid][pData[playerid][toySelected]][toy_x],
						pToys[playerid][pData[playerid][toySelected]][toy_y],
						pToys[playerid][pData[playerid][toySelected]][toy_z],
						pToys[playerid][pData[playerid][toySelected]][toy_rx],
						pToys[playerid][pData[playerid][toySelected]][toy_ry],
						pToys[playerid][pData[playerid][toySelected]][toy_rz],
						pToys[playerid][pData[playerid][toySelected]][toy_sx],
						pToys[playerid][pData[playerid][toySelected]][toy_sy],
						pToys[playerid][pData[playerid][toySelected]][toy_sz]);
						GameTextForPlayer(playerid, "~r~~h~Toy Show~y~!", 3000, 4);
					}
				}
				case 5:	//share toy pos
				{
					SendNearbyMessage(playerid, 10.0, COLOR_GREEN, "[TOY BY %s] "WHITE_E"PosX: %.3f | PosY: %.3f | PosZ: %.3f | PosRX: %.3f | PosRY: %.3f | PosRZ: %.3f | ScaleX: %.3f | ScaleY: %.3f | ScaleZ: %.3f",
					ReturnName(playerid), pToys[playerid][pData[playerid][toySelected]][toy_x], pToys[playerid][pData[playerid][toySelected]][toy_y], pToys[playerid][pData[playerid][toySelected]][toy_z],
					pToys[playerid][pData[playerid][toySelected]][toy_rx], pToys[playerid][pData[playerid][toySelected]][toy_ry], pToys[playerid][pData[playerid][toySelected]][toy_rz],
					pToys[playerid][pData[playerid][toySelected]][toy_sx], pToys[playerid][pData[playerid][toySelected]][toy_sy], pToys[playerid][pData[playerid][toySelected]][toy_sz]);
				}
				case 6: //Pos X
				{
					new mstr[128];
					format(mstr, sizeof(mstr), ""WHITE_E"Current Toy PosX: %f\nInput new Toy PosX:(Float)", pToys[playerid][pData[playerid][toySelected]][toy_x]);
					ShowPlayerDialog(playerid, DIALOG_TOYPOSX, DIALOG_STYLE_INPUT, "Toy PosX", mstr, "Edit", "Cancel");
				}
				case 7: //Pos Y
				{
					new mstr[128];
					format(mstr, sizeof(mstr), ""WHITE_E"Current Toy PosY: %f\nInput new Toy PosY:(Float)", pToys[playerid][pData[playerid][toySelected]][toy_y]);
					ShowPlayerDialog(playerid, DIALOG_TOYPOSY, DIALOG_STYLE_INPUT, "Toy PosY", mstr, "Edit", "Cancel");
				}
				case 8: //Pos Z
				{
					new mstr[128];
					format(mstr, sizeof(mstr), ""WHITE_E"Current Toy PosZ: %f\nInput new Toy PosZ:(Float)", pToys[playerid][pData[playerid][toySelected]][toy_z]);
					ShowPlayerDialog(playerid, DIALOG_TOYPOSZ, DIALOG_STYLE_INPUT, "Toy PosZ", mstr, "Edit", "Cancel");
				}
				case 9: //Pos RX
				{
					new mstr[128];
					format(mstr, sizeof(mstr), ""WHITE_E"Current Toy PosRX: %f\nInput new Toy PosRX:(Float)", pToys[playerid][pData[playerid][toySelected]][toy_rx]);
					ShowPlayerDialog(playerid, DIALOG_TOYPOSRX, DIALOG_STYLE_INPUT, "Toy PosRX", mstr, "Edit", "Cancel");
				}
				case 10: //Pos RY
				{
					new mstr[128];
					format(mstr, sizeof(mstr), ""WHITE_E"Current Toy PosRY: %f\nInput new Toy PosRY:(Float)", pToys[playerid][pData[playerid][toySelected]][toy_ry]);
					ShowPlayerDialog(playerid, DIALOG_TOYPOSRY, DIALOG_STYLE_INPUT, "Toy PosRY", mstr, "Edit", "Cancel");
				}
				case 11: //Pos RZ
				{
					new mstr[128];
					format(mstr, sizeof(mstr), ""WHITE_E"Current Toy PosRZ: %f\nInput new Toy PosRZ:(Float)", pToys[playerid][pData[playerid][toySelected]][toy_rz]);
					ShowPlayerDialog(playerid, DIALOG_TOYPOSRZ, DIALOG_STYLE_INPUT, "Toy PosRZ", mstr, "Edit", "Cancel");
				}
				case 12: //Scale X
				{
					new mstr[128];
					format(mstr, sizeof(mstr), ""WHITE_E"Current Toy ScaleX: %f\nInput new Toy ScaleX:(Float)", pToys[playerid][pData[playerid][toySelected]][toy_sx]);
					ShowPlayerDialog(playerid, DIALOG_SCALEX, DIALOG_STYLE_INPUT, "Toy PosRX", mstr, "Edit", "Cancel");
				}
				case 13: //Scale Y
				{
					new mstr[128];
					format(mstr, sizeof(mstr), ""WHITE_E"Current Toy ScaleY: %f\nInput new Toy ScaleY:(Float)", pToys[playerid][pData[playerid][toySelected]][toy_sy]);
					ShowPlayerDialog(playerid, DIALOG_SCALEY, DIALOG_STYLE_INPUT, "Toy PosRY", mstr, "Edit", "Cancel");
				}
				case 14: //Scale Z
				{
					new mstr[128];
					format(mstr, sizeof(mstr), ""WHITE_E"Current Toy ScaleZ: %f\nInput new Toy ScaleZ:(Float)", pToys[playerid][pData[playerid][toySelected]][toy_sz]);
					ShowPlayerDialog(playerid, DIALOG_SCALEZ, DIALOG_STYLE_INPUT, "Toy PosRZ", mstr, "Edit", "Cancel");
				}
			}
		}
		return 1;
	}
	if(dialogid == TOYSET_VALUE)
	{
		if(response)
		{
			if(isnull(inputtext))
			{
				TNudgeVal[playerid] = 0.01;
				ShowPlayerDialog(playerid, TSELECT_POS, DIALOG_STYLE_LIST, "Select Editing Pos", "Position X\nPosition Y\nPosition Z\nPosition SX\nPosition SY\nPosition SZ", "Select", "Back");
			}
			else
			{
				TNudgeVal[playerid] = floatstr(inputtext);
				ShowPlayerDialog(playerid, TSELECT_POS, DIALOG_STYLE_LIST, "Select Editing Pos", "Position X\nPosition Y\nPosition Z\nPosition SX\nPosition SY\nPosition SZ", "Select", "Back");
			}
		}
	}
	if(dialogid == TSELECT_POS)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0: //Pos X
				{
					pData[playerid][TEditStatus] = TFloatX;
					ShowEditToysTD(playerid);
					Servers(playerid, "You are now editing toys position 'X', one click to add %f", TNudgeVal[playerid]);
				}
				case 1: //Pos Y
				{
					pData[playerid][TEditStatus] = TFloatY;
					ShowEditToysTD(playerid);
					Servers(playerid, "You are now editing toys position 'Y', one click to add %f", TNudgeVal[playerid]);
				}
				case 2: //Pos Z
				{
					pData[playerid][TEditStatus] = TFloatZ;
					ShowEditToysTD(playerid);
					Servers(playerid, "You are now editing toys position 'Z', one click to add %f", TNudgeVal[playerid]);
				}
				case 3: //Pos SX
				{
					pData[playerid][TEditStatus] = TFloatSX;
					ShowEditToysTD(playerid);
					Servers(playerid, "You are now editing toys position 'SX', one click to add %f", TNudgeVal[playerid]);
				}
				case 4: //Pos SY
				{
					pData[playerid][TEditStatus] = TFloatSY;
					ShowEditToysTD(playerid);
					Servers(playerid, "You are now editing toys position 'SY', one click to add %f", TNudgeVal[playerid]);
				}
				case 5: //Pos SZ
				{
					pData[playerid][TEditStatus] = TFloatSZ;
					ShowEditToysTD(playerid);
					Servers(playerid, "You are now editing toys position 'SZ', one click to add %f", TNudgeVal[playerid]);
				}
			}
		}
	}
	if(dialogid == DIALOG_TOYPOSISI)
	{
		if(response)
		{
			listitem++;
			pToys[playerid][pData[playerid][toySelected]][toy_bone] = listitem;
			if(IsPlayerAttachedObjectSlotUsed(playerid, pData[playerid][toySelected]))
			{
				RemovePlayerAttachedObject(playerid, pData[playerid][toySelected]);
			}
			listitem = pData[playerid][toySelected];
			SetPlayerAttachedObject(playerid,
					listitem,
					pToys[playerid][listitem][toy_model],
					pToys[playerid][listitem][toy_bone],
					pToys[playerid][listitem][toy_x],
					pToys[playerid][listitem][toy_y],
					pToys[playerid][listitem][toy_z],
					pToys[playerid][listitem][toy_rx],
					pToys[playerid][listitem][toy_ry],
					pToys[playerid][listitem][toy_rz],
					pToys[playerid][listitem][toy_sx],
					pToys[playerid][listitem][toy_sy],
					pToys[playerid][listitem][toy_sz]);
			GameTextForPlayer(playerid, "~g~~h~Bone Changed~y~!", 3000, 4);
			SetPVarInt(playerid, "UpdatedToy", 1);
		}
		return 1;
	}
	if(dialogid == DIALOG_TOYPOSISIBUY)
	{
		if(response)
		{
			listitem++;
			pToys[playerid][pData[playerid][toySelected]][toy_bone] = listitem;
			SetPlayerAttachedObject(playerid, pData[playerid][toySelected], pToys[playerid][pData[playerid][toySelected]][toy_model], listitem);
			//EditAttachedObject(playerid, pData[playerid][toySelected]);
			InfoTD_MSG(playerid, 5000, "~g~~h~Object Attached!");
		}
		return 1;
	}
	if(dialogid == DIALOG_TOYBUY)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0: //slot 1
				{
					pData[playerid][toySelected] = 0;
					if(pToys[playerid][0][toy_model] == 0)
					{
						ShowPlayerSelectionMenu(playerid, TOYS_MODEL, "Choose Your Skin", ToysModel, sizeof(ToysModel));
					}
					else
					{
						ShowPlayerDialog(playerid, DIALOG_TOYEDIT, DIALOG_STYLE_LIST, ""WHITE_E"Player Toys", ""dot"Edit Toy Position\n"dot"Change Bone\n"dot""GREY_E"Remove Toy", "Select", "Cancel");
					}
				}
				case 1: //slot 2
				{
					pData[playerid][toySelected] = 1;
					if(pToys[playerid][1][toy_model] == 0)
					{
						ShowPlayerSelectionMenu(playerid, TOYS_MODEL, "Choose Your Skin", ToysModel, sizeof(ToysModel));
					}
					else
					{
						ShowPlayerDialog(playerid, DIALOG_TOYEDIT, DIALOG_STYLE_LIST, ""WHITE_E"Player Toys", ""dot"Edit Toy Position\n"dot"Change Bone\n"dot""GREY_E"Remove Toy", "Select", "Cancel");
					}
				}
				case 2: //slot 3
				{
					pData[playerid][toySelected] = 2;
					if(pToys[playerid][2][toy_model] == 0)
					{
						ShowPlayerSelectionMenu(playerid, TOYS_MODEL, "Choose Your Skin", ToysModel, sizeof(ToysModel));
					}
					else
					{
						ShowPlayerDialog(playerid, DIALOG_TOYEDIT, DIALOG_STYLE_LIST, ""WHITE_E"Player Toys", ""dot"Edit Toy Position\n"dot"Change Bone\n"dot""GREY_E"Remove Toy", "Select", "Cancel");
					}
				}
				case 3: //slot 4
				{
					pData[playerid][toySelected] = 3;
					if(pToys[playerid][3][toy_model] == 0)
					{
						ShowPlayerSelectionMenu(playerid, TOYS_MODEL, "Choose Your Skin", ToysModel, sizeof(ToysModel));
					}
					else
					{
						ShowPlayerDialog(playerid, DIALOG_TOYEDIT, DIALOG_STYLE_LIST, ""WHITE_E"Player Toys", ""dot"Edit Toy Position\n"dot"Change Bone\n"dot""GREY_E"Remove Toy", "Select", "Cancel");
					}
				}
				case 4: //slot 5
				{
					pData[playerid][toySelected] = 4;
					if(pToys[playerid][4][toy_model] == 0)
					{
						ShowPlayerSelectionMenu(playerid, TOYS_MODEL, "Choose Your Skin", ToysModel, sizeof(ToysModel));
					}
					else
					{
						ShowPlayerDialog(playerid, DIALOG_TOYEDIT, DIALOG_STYLE_LIST, ""WHITE_E"Player Toys", ""dot"Edit Toy Position\n"dot"Change Bone\n"dot""GREY_E"Remove Toy", "Select", "Cancel");
					}
				}
				case 5: //slot 6
				{
					pData[playerid][toySelected] = 5;
					if(pToys[playerid][5][toy_model] == 0)
					{
						ShowPlayerSelectionMenu(playerid, TOYS_MODEL, "Choose Your Skin", ToysModel, sizeof(ToysModel));
					}
					else
					{
						ShowPlayerDialog(playerid, DIALOG_TOYEDIT, DIALOG_STYLE_LIST, ""WHITE_E"Player Toys", ""dot"Edit Toy Position\n"dot"Change Bone\n"dot""GREY_E"Remove Toy", "Select", "Cancel");
					}
				}
			}
		}
		return 1;
	}
	if(dialogid == DIALOG_TOYVIP)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0: //slot 1
				{
					pData[playerid][toySelected] = 0;
					if(pToys[playerid][0][toy_model] == 0)
					{
						ShowPlayerSelectionMenu(playerid, VIPTOYS_MODEL, "Choose Your Skin", VipToysModel, sizeof(VipToysModel));
					}
					else
					{
						ShowPlayerDialog(playerid, DIALOG_TOYEDIT, DIALOG_STYLE_LIST, ""WHITE_E"Player Toys", ""dot"Edit Toy Position\n"dot"Change Bone\n"dot""GREY_E"Remove Toy", "Select", "Cancel");
					}
				}
				case 1: //slot 2
				{
					pData[playerid][toySelected] = 1;
					if(pToys[playerid][1][toy_model] == 0)
					{
						ShowPlayerSelectionMenu(playerid, VIPTOYS_MODEL, "Choose Your Skin", VipToysModel, sizeof(VipToysModel));
					}
					else
					{
						ShowPlayerDialog(playerid, DIALOG_TOYEDIT, DIALOG_STYLE_LIST, ""WHITE_E"Player Toys", ""dot"Edit Toy Position\n"dot"Change Bone\n"dot""GREY_E"Remove Toy", "Select", "Cancel");
					}
				}
				case 2: //slot 3
				{
					pData[playerid][toySelected] = 2;
					if(pToys[playerid][2][toy_model] == 0)
					{
						ShowPlayerSelectionMenu(playerid, VIPTOYS_MODEL, "Choose Your Skin", VipToysModel, sizeof(VipToysModel));
					}
					else
					{
						ShowPlayerDialog(playerid, DIALOG_TOYEDIT, DIALOG_STYLE_LIST, ""WHITE_E"Player Toys", ""dot"Edit Toy Position\n"dot"Change Bone\n"dot""GREY_E"Remove Toy", "Select", "Cancel");
					}
				}
				case 3: //slot 4
				{
					pData[playerid][toySelected] = 3;
					if(pToys[playerid][3][toy_model] == 0)
					{
						ShowPlayerSelectionMenu(playerid, VIPTOYS_MODEL, "Choose Your Skin", VipToysModel, sizeof(VipToysModel));
					}
					else
					{
						ShowPlayerDialog(playerid, DIALOG_TOYEDIT, DIALOG_STYLE_LIST, ""WHITE_E"Player Toys", ""dot"Edit Toy Position\n"dot"Change Bone\n"dot""GREY_E"Remove Toy", "Select", "Cancel");
					}
				}
				case 4: //slot 5
				{
					pData[playerid][toySelected] = 4;
					if(pToys[playerid][4][toy_model] == 0)
					{
						ShowPlayerSelectionMenu(playerid, VIPTOYS_MODEL, "Choose Your Skin", VipToysModel, sizeof(VipToysModel));
					}
					else
					{
						ShowPlayerDialog(playerid, DIALOG_TOYEDIT, DIALOG_STYLE_LIST, ""WHITE_E"Player Toys", ""dot"Edit Toy Position\n"dot"Change Bone\n"dot""GREY_E"Remove Toy", "Select", "Cancel");
					}
				}
				case 5: //slot 6
				{
					pData[playerid][toySelected] = 5;
					if(pToys[playerid][5][toy_model] == 0)
					{
						ShowPlayerSelectionMenu(playerid, VIPTOYS_MODEL, "Choose Your Skin", VipToysModel, sizeof(VipToysModel));
					}
					else
					{
						ShowPlayerDialog(playerid, DIALOG_TOYEDIT, DIALOG_STYLE_LIST, ""WHITE_E"Player Toys", ""dot"Edit Toy Position\n"dot"Change Bone\n"dot""GREY_E"Remove Toy", "Select", "Cancel");
					}
				}
			}
		}
		return 1;
	}
	if(dialogid == DIALOG_TOYPOSX)
	{
		if(response)
		{
			new Float:posisi = floatstr(inputtext);

			SetPlayerAttachedObject(playerid,
				pData[playerid][toySelected],
				pToys[playerid][pData[playerid][toySelected]][toy_model],
				pToys[playerid][pData[playerid][toySelected]][toy_bone],
				posisi,
				pToys[playerid][pData[playerid][toySelected]][toy_y],
				pToys[playerid][pData[playerid][toySelected]][toy_z],
				pToys[playerid][pData[playerid][toySelected]][toy_rx],
				pToys[playerid][pData[playerid][toySelected]][toy_ry],
				pToys[playerid][pData[playerid][toySelected]][toy_rz],
				pToys[playerid][pData[playerid][toySelected]][toy_sx],
				pToys[playerid][pData[playerid][toySelected]][toy_sy],
				pToys[playerid][pData[playerid][toySelected]][toy_sz]);

			pToys[playerid][pData[playerid][toySelected]][toy_x] = posisi;
			//SetPVarInt(playerid, "UpdatedToy", 1);
			MySQL_SavePlayerToys(playerid);

			new string[512];
			format(string, sizeof(string), ""dot"Edit Toy Position(PC)\n"dot"Edit Toy Position(Android)\n"dot"Change Bone\n"dot""GREY_E"Remove Toy\n"dot"Share Toy Pos\nPosX: %f\nPosY: %f\nPosZ: %f\nPosRX: %f\nPosRY: %f\nPosRZ: %f",
			pToys[playerid][pData[playerid][toySelected]][toy_x], pToys[playerid][pData[playerid][toySelected]][toy_y], pToys[playerid][pData[playerid][toySelected]][toy_z],
			pToys[playerid][pData[playerid][toySelected]][toy_rx], pToys[playerid][pData[playerid][toySelected]][toy_ry], pToys[playerid][pData[playerid][toySelected]][toy_rz]);
			ShowPlayerDialog(playerid, DIALOG_TOYEDIT, DIALOG_STYLE_LIST, ""RED_E"Capitaliz Roleplay "WHITE_E"Player Toys", string, "Select", "Cancel");
		}
	}
	if(dialogid == DIALOG_TOYPOSY)
	{
		if(response)
		{
			new Float:posisi = floatstr(inputtext);

			SetPlayerAttachedObject(playerid,
				pData[playerid][toySelected],
				pToys[playerid][pData[playerid][toySelected]][toy_model],
				pToys[playerid][pData[playerid][toySelected]][toy_bone],
				pToys[playerid][pData[playerid][toySelected]][toy_x],
				posisi,
				pToys[playerid][pData[playerid][toySelected]][toy_z],
				pToys[playerid][pData[playerid][toySelected]][toy_rx],
				pToys[playerid][pData[playerid][toySelected]][toy_ry],
				pToys[playerid][pData[playerid][toySelected]][toy_rz],
				pToys[playerid][pData[playerid][toySelected]][toy_sx],
				pToys[playerid][pData[playerid][toySelected]][toy_sy],
				pToys[playerid][pData[playerid][toySelected]][toy_sz]);

			pToys[playerid][pData[playerid][toySelected]][toy_y] = posisi;
			SetPVarInt(playerid, "UpdatedToy", 1);
			//MySQL_SavePlayerToys(playerid);

			new string[512];
			format(string, sizeof(string), ""dot"Edit Toy Position(PC)\n"dot"Edit Toy Position(Android)\n"dot"Change Bone\n"dot""GREY_E"Remove Toy\n"dot"Share Toy Pos\nPosX: %f\nPosY: %f\nPosZ: %f\nPosRX: %f\nPosRY: %f\nPosRZ: %f",
			pToys[playerid][pData[playerid][toySelected]][toy_x], pToys[playerid][pData[playerid][toySelected]][toy_y], pToys[playerid][pData[playerid][toySelected]][toy_z],
			pToys[playerid][pData[playerid][toySelected]][toy_rx], pToys[playerid][pData[playerid][toySelected]][toy_ry], pToys[playerid][pData[playerid][toySelected]][toy_rz]);
			ShowPlayerDialog(playerid, DIALOG_TOYEDIT, DIALOG_STYLE_LIST, ""RED_E"Capitaliz Roleplay "WHITE_E"Player Toys", string, "Select", "Cancel");
		}
	}
	if(dialogid == DIALOG_TOYPOSZ)
	{
		if(response)
		{
			new Float:posisi = floatstr(inputtext);

			SetPlayerAttachedObject(playerid,
				pData[playerid][toySelected],
				pToys[playerid][pData[playerid][toySelected]][toy_model],
				pToys[playerid][pData[playerid][toySelected]][toy_bone],
				pToys[playerid][pData[playerid][toySelected]][toy_x],
				pToys[playerid][pData[playerid][toySelected]][toy_y],
				posisi,
				pToys[playerid][pData[playerid][toySelected]][toy_rx],
				pToys[playerid][pData[playerid][toySelected]][toy_ry],
				pToys[playerid][pData[playerid][toySelected]][toy_rz],
				pToys[playerid][pData[playerid][toySelected]][toy_sx],
				pToys[playerid][pData[playerid][toySelected]][toy_sy],
				pToys[playerid][pData[playerid][toySelected]][toy_sz]);

			pToys[playerid][pData[playerid][toySelected]][toy_z] = posisi;
			SetPVarInt(playerid, "UpdatedToy", 1);
			//MySQL_SavePlayerToys(playerid);

			new string[512];
			format(string, sizeof(string), ""dot"Edit Toy Position(PC)\n"dot"Edit Toy Position(Android)\n"dot"Change Bone\n"dot""GREY_E"Remove Toy\n"dot"Share Toy Pos\nPosX: %f\nPosY: %f\nPosZ: %f\nPosRX: %f\nPosRY: %f\nPosRZ: %f",
			pToys[playerid][pData[playerid][toySelected]][toy_x], pToys[playerid][pData[playerid][toySelected]][toy_y], pToys[playerid][pData[playerid][toySelected]][toy_z],
			pToys[playerid][pData[playerid][toySelected]][toy_rx], pToys[playerid][pData[playerid][toySelected]][toy_ry], pToys[playerid][pData[playerid][toySelected]][toy_rz]);
			ShowPlayerDialog(playerid, DIALOG_TOYEDIT, DIALOG_STYLE_LIST, ""RED_E"Capitaliz Roleplay "WHITE_E"Player Toys", string, "Select", "Cancel");
		}
	}
	if(dialogid == DIALOG_TOYPOSRX)
	{
		if(response)
		{
			new Float:posisi = floatstr(inputtext);

			SetPlayerAttachedObject(playerid,
				pData[playerid][toySelected],
				pToys[playerid][pData[playerid][toySelected]][toy_model],
				pToys[playerid][pData[playerid][toySelected]][toy_bone],
				pToys[playerid][pData[playerid][toySelected]][toy_x],
				pToys[playerid][pData[playerid][toySelected]][toy_y],
				pToys[playerid][pData[playerid][toySelected]][toy_z],
				posisi,
				pToys[playerid][pData[playerid][toySelected]][toy_ry],
				pToys[playerid][pData[playerid][toySelected]][toy_rz],
				pToys[playerid][pData[playerid][toySelected]][toy_sx],
				pToys[playerid][pData[playerid][toySelected]][toy_sy],
				pToys[playerid][pData[playerid][toySelected]][toy_sz]);

			pToys[playerid][pData[playerid][toySelected]][toy_rx] = posisi;
			SetPVarInt(playerid, "UpdatedToy", 1);
			//MySQL_SavePlayerToys(playerid);

			new string[512];
			format(string, sizeof(string), ""dot"Edit Toy Position(PC)\n"dot"Edit Toy Position(Android)\n"dot"Change Bone\n"dot""GREY_E"Remove Toy\n"dot"Share Toy Pos\nPosX: %f\nPosY: %f\nPosZ: %f\nPosRX: %f\nPosRY: %f\nPosRZ: %f",
			pToys[playerid][pData[playerid][toySelected]][toy_x], pToys[playerid][pData[playerid][toySelected]][toy_y], pToys[playerid][pData[playerid][toySelected]][toy_z],
			pToys[playerid][pData[playerid][toySelected]][toy_rx], pToys[playerid][pData[playerid][toySelected]][toy_ry], pToys[playerid][pData[playerid][toySelected]][toy_rz]);
			ShowPlayerDialog(playerid, DIALOG_TOYEDIT, DIALOG_STYLE_LIST, ""RED_E"Capitaliz Roleplay "WHITE_E"Player Toys", string, "Select", "Cancel");
		}
	}
	if(dialogid == DIALOG_TOYPOSRY)
	{
		if(response)
		{
			new Float:posisi = floatstr(inputtext);

			SetPlayerAttachedObject(playerid,
				pData[playerid][toySelected],
				pToys[playerid][pData[playerid][toySelected]][toy_model],
				pToys[playerid][pData[playerid][toySelected]][toy_bone],
				pToys[playerid][pData[playerid][toySelected]][toy_x],
				pToys[playerid][pData[playerid][toySelected]][toy_y],
				pToys[playerid][pData[playerid][toySelected]][toy_z],
				pToys[playerid][pData[playerid][toySelected]][toy_rx],
				posisi,
				pToys[playerid][pData[playerid][toySelected]][toy_rz],
				pToys[playerid][pData[playerid][toySelected]][toy_sx],
				pToys[playerid][pData[playerid][toySelected]][toy_sy],
				pToys[playerid][pData[playerid][toySelected]][toy_sz]);

			pToys[playerid][pData[playerid][toySelected]][toy_ry] = posisi;
			SetPVarInt(playerid, "UpdatedToy", 1);
			//MySQL_SavePlayerToys(playerid);

			new string[512];
			format(string, sizeof(string), ""dot"Edit Toy Position(PC)\n"dot"Edit Toy Position(Android)\n"dot"Change Bone\n"dot""GREY_E"Remove Toy\n"dot"Share Toy Pos\nPosX: %f\nPosY: %f\nPosZ: %f\nPosRX: %f\nPosRY: %f\nPosRZ: %f",
			pToys[playerid][pData[playerid][toySelected]][toy_x], pToys[playerid][pData[playerid][toySelected]][toy_y], pToys[playerid][pData[playerid][toySelected]][toy_z],
			pToys[playerid][pData[playerid][toySelected]][toy_rx], pToys[playerid][pData[playerid][toySelected]][toy_ry], pToys[playerid][pData[playerid][toySelected]][toy_rz]);
			ShowPlayerDialog(playerid, DIALOG_TOYEDIT, DIALOG_STYLE_LIST, ""RED_E"Capitaliz Roleplay "WHITE_E"Player Toys", string, "Select", "Cancel");
		}
	}
	if(dialogid == DIALOG_TOYPOSRZ)
	{
		if(response)
		{
			new Float:posisi = floatstr(inputtext);

			SetPlayerAttachedObject(playerid,
				pData[playerid][toySelected],
				pToys[playerid][pData[playerid][toySelected]][toy_model],
				pToys[playerid][pData[playerid][toySelected]][toy_bone],
				pToys[playerid][pData[playerid][toySelected]][toy_x],
				pToys[playerid][pData[playerid][toySelected]][toy_y],
				pToys[playerid][pData[playerid][toySelected]][toy_z],
				pToys[playerid][pData[playerid][toySelected]][toy_rx],
				pToys[playerid][pData[playerid][toySelected]][toy_ry],
				posisi,
				pToys[playerid][pData[playerid][toySelected]][toy_sx],
				pToys[playerid][pData[playerid][toySelected]][toy_sy],
				pToys[playerid][pData[playerid][toySelected]][toy_sz]);

			pToys[playerid][pData[playerid][toySelected]][toy_rz] = posisi;
			SetPVarInt(playerid, "UpdatedToy", 1);
			//MySQL_SavePlayerToys(playerid);

			new string[512];
			format(string, sizeof(string), ""dot"Edit Toy Position(PC)\n"dot"Edit Toy Position(Android)\n"dot"Change Bone\n"dot""GREY_E"Remove Toy\n"dot"Share Toy Pos\nPosX: %f\nPosY: %f\nPosZ: %f\nPosRX: %f\nPosRY: %f\nPosRZ: %f",
			pToys[playerid][pData[playerid][toySelected]][toy_x], pToys[playerid][pData[playerid][toySelected]][toy_y], pToys[playerid][pData[playerid][toySelected]][toy_z],
			pToys[playerid][pData[playerid][toySelected]][toy_rx], pToys[playerid][pData[playerid][toySelected]][toy_ry], pToys[playerid][pData[playerid][toySelected]][toy_rz]);
			ShowPlayerDialog(playerid, DIALOG_TOYEDIT, DIALOG_STYLE_LIST, ""RED_E"Capitaliz Roleplay "WHITE_E"Player Toys", string, "Select", "Cancel");
		}
	}
	if(dialogid == DIALOG_SCALEX)
	{
		if(response)
		{
			new Float:posisi = floatstr(inputtext);

			SetPlayerAttachedObject(playerid,
				pData[playerid][toySelected],
				pToys[playerid][pData[playerid][toySelected]][toy_model],
				pToys[playerid][pData[playerid][toySelected]][toy_bone],
				pToys[playerid][pData[playerid][toySelected]][toy_x],
				pToys[playerid][pData[playerid][toySelected]][toy_y],
				pToys[playerid][pData[playerid][toySelected]][toy_z],
				pToys[playerid][pData[playerid][toySelected]][toy_rx],
				pToys[playerid][pData[playerid][toySelected]][toy_ry],
				pToys[playerid][pData[playerid][toySelected]][toy_rz],
				posisi,
				pToys[playerid][pData[playerid][toySelected]][toy_sy],
				pToys[playerid][pData[playerid][toySelected]][toy_sz]);

			pToys[playerid][pData[playerid][toySelected]][toy_sx] = posisi;
			SetPVarInt(playerid, "UpdatedToy", 1);
			//MySQL_SavePlayerToys(playerid);

			new string[512];
			format(string, sizeof(string), ""dot"Edit Toy Position(PC Only)\n"dot"Change Bone\n"dot""GREY_E"Remove Toy\n"dot"Share Toy Pos\nPosX: %f\nPosY: %f\nPosZ: %f\nPosRX: %f\nPosRY: %f\nPosRZ: %f\nScaleX: %f\nScaleY: %f\nScaleZ: %f",
			pToys[playerid][pData[playerid][toySelected]][toy_x], pToys[playerid][pData[playerid][toySelected]][toy_y], pToys[playerid][pData[playerid][toySelected]][toy_z],
			pToys[playerid][pData[playerid][toySelected]][toy_rx], pToys[playerid][pData[playerid][toySelected]][toy_ry], pToys[playerid][pData[playerid][toySelected]][toy_rz],
			pToys[playerid][pData[playerid][toySelected]][toy_sx], pToys[playerid][pData[playerid][toySelected]][toy_sy], pToys[playerid][pData[playerid][toySelected]][toy_sz]);
			ShowPlayerDialog(playerid, DIALOG_TOYEDIT, DIALOG_STYLE_LIST, ""RED_E"SOI:RP "WHITE_E"Player Toys", string, "Select", "Cancel");
		}
	}
	if(dialogid == DIALOG_SCALEY)
	{
		if(response)
		{
			new Float:posisi = floatstr(inputtext);

			SetPlayerAttachedObject(playerid,
				pData[playerid][toySelected],
				pToys[playerid][pData[playerid][toySelected]][toy_model],
				pToys[playerid][pData[playerid][toySelected]][toy_bone],
				pToys[playerid][pData[playerid][toySelected]][toy_x],
				pToys[playerid][pData[playerid][toySelected]][toy_y],
				pToys[playerid][pData[playerid][toySelected]][toy_z],
				pToys[playerid][pData[playerid][toySelected]][toy_rx],
				pToys[playerid][pData[playerid][toySelected]][toy_ry],
				pToys[playerid][pData[playerid][toySelected]][toy_rz],
				pToys[playerid][pData[playerid][toySelected]][toy_sx],
				posisi,
				pToys[playerid][pData[playerid][toySelected]][toy_sz]);

			pToys[playerid][pData[playerid][toySelected]][toy_sy] = posisi;
			SetPVarInt(playerid, "UpdatedToy", 1);
			//MySQL_SavePlayerToys(playerid);

			new string[512];
			format(string, sizeof(string), ""dot"Edit Toy Position(PC Only)\n"dot"Change Bone\n"dot""GREY_E"Remove Toy\n"dot"Share Toy Pos\nPosX: %f\nPosY: %f\nPosZ: %f\nPosRX: %f\nPosRY: %f\nPosRZ: %f\nScaleX: %f\nScaleY: %f\nScaleZ: %f",
			pToys[playerid][pData[playerid][toySelected]][toy_x], pToys[playerid][pData[playerid][toySelected]][toy_y], pToys[playerid][pData[playerid][toySelected]][toy_z],
			pToys[playerid][pData[playerid][toySelected]][toy_rx], pToys[playerid][pData[playerid][toySelected]][toy_ry], pToys[playerid][pData[playerid][toySelected]][toy_rz],
			pToys[playerid][pData[playerid][toySelected]][toy_sx], pToys[playerid][pData[playerid][toySelected]][toy_sy], pToys[playerid][pData[playerid][toySelected]][toy_sz]);
			ShowPlayerDialog(playerid, DIALOG_TOYEDIT, DIALOG_STYLE_LIST, ""RED_E"SOI:RP "WHITE_E"Player Toys", string, "Select", "Cancel");
		}
	}
	if(dialogid == DIALOG_SCALEZ)
	{
		if(response)
		{
			new Float:posisi = floatstr(inputtext);

			SetPlayerAttachedObject(playerid,
				pData[playerid][toySelected],
				pToys[playerid][pData[playerid][toySelected]][toy_model],
				pToys[playerid][pData[playerid][toySelected]][toy_bone],
				pToys[playerid][pData[playerid][toySelected]][toy_x],
				pToys[playerid][pData[playerid][toySelected]][toy_y],
				pToys[playerid][pData[playerid][toySelected]][toy_z],
				pToys[playerid][pData[playerid][toySelected]][toy_rx],
				pToys[playerid][pData[playerid][toySelected]][toy_ry],
				pToys[playerid][pData[playerid][toySelected]][toy_rz],
				pToys[playerid][pData[playerid][toySelected]][toy_sx],
				pToys[playerid][pData[playerid][toySelected]][toy_sy],
				posisi);

			pToys[playerid][pData[playerid][toySelected]][toy_sz] = posisi;
			SetPVarInt(playerid, "UpdatedToy", 1);
			//MySQL_SavePlayerToys(playerid);
			new string[512];
			format(string, sizeof(string), ""dot"Edit Toy Position(PC Only)\n"dot"Change Bone\n"dot""GREY_E"Remove Toy\n"dot"Share Toy Pos\nPosX: %f\nPosY: %f\nPosZ: %f\nPosRX: %f\nPosRY: %f\nPosRZ: %f\nScaleX: %f\nScaleY: %f\nScaleZ: %f",
			pToys[playerid][pData[playerid][toySelected]][toy_x], pToys[playerid][pData[playerid][toySelected]][toy_y], pToys[playerid][pData[playerid][toySelected]][toy_z],
			pToys[playerid][pData[playerid][toySelected]][toy_rx], pToys[playerid][pData[playerid][toySelected]][toy_ry], pToys[playerid][pData[playerid][toySelected]][toy_rz],
			pToys[playerid][pData[playerid][toySelected]][toy_sx], pToys[playerid][pData[playerid][toySelected]][toy_sy], pToys[playerid][pData[playerid][toySelected]][toy_sz]);
			ShowPlayerDialog(playerid, DIALOG_TOYEDIT, DIALOG_STYLE_LIST, ""RED_E"HB:PR "WHITE_E"Player Toys", string, "Select", "Cancel");
		}
	}
	//-----------[ Player Commands Dialog ]----------
	if(dialogid == DIALOG_HELP)
    {
		if(!response) return 1;
		switch(listitem)
		{
			case 0:
			{
				new str[3500];
				strcat(str, ""LG_E"PLAYER: /help /salary /time /afk /drag /undrag /pay /stats /items /frisk /use /give /ktp /sim\n");
				strcat(str, ""LB_E"PLAYER: /weapon /settings /mask /helmet /death /accept /deny /buy /tweet /cook /twlist\n");
				ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_MSGBOX, ""RED_E"Player", str, "Close", "");
			}
			case 1:
			{
				new str[3500];
				strcat(str, "/b\tOOC Chat\n");
				strcat(str, "/l\tLow Chat\n");
				strcat(str, "/s\tHigh Chat\n");
				strcat(str, "/pm\tPrivate Message (OOC)\n");
				strcat(str, "/togpm\tTurn On/Off Pm\n");
				strcat(str, "/w\tBerbisik\n");
				strcat(str, "/o\tGlobal OOC\n");
				strcat(str, "/me\tMemberitahu Apa Yang Sedang Character Kita Lakukan.\n");
				strcat(str, "/ado\tMemberitahu Suatu Keadaaan Di Sekitar Character Kita Atau Juga Keadaan Character Kita.\n");
				strcat(str, "/try\tMemberitahu Apa Yang Sedang Kita Coba/Mencoba Melakukan\n");
				ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_TABLIST, ""RED_E"Chat", str, "Close", "");
			}
			case 2:
			{
				new str[3500];
				strcat(str, "/v en\tToggle Engine\n");
				strcat(str, "/v hood\tToggle Hood\n");
				strcat(str, "/v lock\tToggle Lock\n");
				strcat(str, "/v unlock\tToggle Unlock\n");
				strcat(str, "/v tow\tTow Vehicle\n");
				strcat(str, "/v park\tSave Park\n");
				strcat(str, "/v insu\tVehicle Insurance\n");
				strcat(str, "/v li\tToggle lights\n");
				strcat(str, "/v trunk\tToggle Trunk\n");
				strcat(str, "/v untow\tUntow Vehicle\n");
				strcat(str, "/v para\tUse vehicle parasute\n");
				strcat(str, "/v my(/mypv)\tList Private Vehicle\n");
				strcat(str, "/claimpv\tClaim Insurance\n");
				strcat(str, "/buyinsu\tBuy Insurance\n");
				strcat(str, "/givepv\tGiven pv\n");
				strcat(str, "/buyplate\tBuy Plate\n");
				strcat(str, "/sellpv\tSell pv\n");
				strcat(str, "/vtoys\tEdit object modshop\n");
				strcat(str, "/limitspeed\tSpeedlimit\n");
				ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_TABLIST, ""RED_E"Vehicle", str, "Close", "");
			}
			case 3:
			{
				return callcmd::jobhelp(playerid);
			}
			case 4:
			{
				return callcmd::factionhelp(playerid);
			}
			case 5:
			{
				new str[3500];
				strcat(str, ""LG_E"FAMILY: /finfo /fsafe /f\n");
				ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_MSGBOX, ""RED_E"Family", str, "Close", "");
			}
			case 6:
			{
				new str[3500];
				strcat(str, ""LG_E"BISNIS: /buy /bm /lockbisnis /unlockbisnis /mybis\n");
				ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_MSGBOX, ""RED_E"Business", str, "Close", "");
			}
			case 7:
			{
				new str[3500];
				strcat(str, ""LG_E"HOUSE: /buy /storage /lockhouse /unlockhouse /myhouse\n");
				ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_MSGBOX, ""RED_E"House", str, "Close", "");
			}
			case 8:
			{
				new str[3500];
				strcat(str, ""LG_E"FLAT: /buy /storage /lockflat /unlockflat /myflat\n");
				ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_MSGBOX, ""RED_E"Flat", str, "Close", "");
			}
			case 9:
			{
				new str[3500];
				strcat(str, ""LG_E"HOTEL: /buy /storage /lockhotel /unlockhotel /myhotel\n");
				ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_MSGBOX, ""RED_E"Hotel", str, "Close", "");
			}
			case 10:
			{
				new str[3500];
				strcat(str, ""LG_E"WORKSHOP: /buy /ws /workshop /wsinfo /wstorage\n");
				ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_MSGBOX, ""RED_E"Business", str, "Close", "");
			}
			case 11:
			{
				new str[3500];
				strcat(str, ""LG_E"DEALERSHIP: /buydealer /dealermanage /buypv\n");
				ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_MSGBOX, ""RED_E"Business", str, "Close", "");
			}
			case 12:
			{
				return callcmd::credits(playerid);
			}
		}
		return 1;
	}
	if(dialogid == DIALOG_AYAM)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
					SetPlayerRaceCheckpoint(playerid,1, 921.4352,-1297.6184,14.0938, 0.0,0.0,0.0, 3.5);
					Info(playerid, "GPS active! follow the checkpoint.");
				}
				case 1:
				{
					SetPlayerRaceCheckpoint(playerid,1, -2100.5037,-2407.3142,30.6250, 0.0, 0.0, 0.0, 3.5);
					Info(playerid, "GPS active! follow the checkpoint.");
				}
			}
		}
	}
    if(dialogid == DIALOG_JOBHELP)
    {
		if(!response) return 1;
		switch(listitem)
		{
			case 0:
			{
				new str[3500];
				strcat(str, ""LB_E"GUIDE: Taxi Job berada diarea unity station\nCari Penumpang dan Antarkan Ketempat Tujuan!\n");
				strcat(str, ""LB_E"");
				strcat(str, ""WHITE_E"COMMAND: /taxiduty /fare \n");
				ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_MSGBOX, ""WHITE_E"Taxi Jobs", str, "Close", "");
			}
			case 1:
			{
			    new str[3500];
				strcat(str, ""LB_E"GUIDE: Mechanic Job berada didekat oceandocks\nMemperbaiki Atau Modifikasi Kendaraan Player!\n");
				strcat(str, ""LB_E"");
				strcat(str, ""WHITE_E"COMMAND: /mechduty /service \n");
				ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_MSGBOX, ""WHITE_E"Mechanic Jobs", str, "Close", "");
			}
			case 2:
			{
				new str[3500];
				strcat(str, ""LB_E"GUIDE: Production Job berada didaerah Angel Pine\nBeli Barang Kebutuhan untuk memproduksi lalu '/createproduct'\n");
				strcat(str, ""LB_E"");
				strcat(str, ""WHITE_E"COMMAND: /createproduct /buy \n");
				ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_MSGBOX, ""WHITE_E"Production Jobs", str, "Close", "");
			}
			case 3:
			{
				new str[3500];
				strcat(str, ""LB_E"GUIDE: Lumberjack Job berada didaerah Angel Pine\nCari pohon untuk ditebang lalu jual pohon tersebut!\n");
				strcat(str, ""LB_E"");
				strcat(str, ""WHITE_E"COMMAND: /buychainsaw /lumber /lum \n");
				ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_MSGBOX, ""WHITE_E"Lumberjack Jobs", str, "Close", "");
				return 1;
			}
			case 4:
			{
				new str[3500];
				strcat(str, ""LB_E"GUIDE: Farmers Job berada didaerah Flint Country\nBeli Bibit Tanaman lalu Tanam bibit tersebut\nJika tanaman sudah tumbuh panen tanaman lalu jual!\n");
				strcat(str, ""LB_E"");
				strcat(str, ""WHITE_E"COMMAND: /plant /buy (seeds) /berry (press N) \n");
				ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_MSGBOX, ""WHITE_E"Farmers Jobs", str, "Close", "");
			}
			case 5:
			{
				new str[3500];
				strcat(str, ""LB_E"GUIDE: Miner Job berada didaerah Las Venturas\nBeli Sekop dan siapkan truck anda\nlalu tambang lah batu tersebut jika sudah sampai maximal kalian jual hasil tambang!\n");
				strcat(str, ""LB_E"");
				strcat(str, ""WHITE_E"COMMAND: /ore \n");
				ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_MSGBOX, ""WHITE_E"Miner Jobs", str, "Close", "");
			}
			case 6:
			{
				new str[3500];
				strcat(str, ""LB_E"GUIDE: Trucker Job berada didaerah Flint Country\nBeli Truck lalu /mission untuk merestock bisnis\nDan beli product di Tempat Job Production!\n");
				strcat(str, ""LB_E"");
				strcat(str, ""WHITE_E"COMMAND: /mission /hauling /dealermission /buy /storeproduct /storegas /storeveh \n");
				ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_MSGBOX, ""WHITE_E"Trucker Jobs", str, "Close", "");
			}
			case 7:
			{
				new str[3500];
				strcat(str, ""LB_E"GUIDE: Sweeper Sidejob berada didekat Unity Station\nIkuti Checkpoint dan Bersihkan Jalanan dengan kendaraan sweeper!\n");
				strcat(str, ""LB_E"");
				strcat(str, ""WHITE_E"COMMAND: -\n");
				ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_MSGBOX, ""WHITE_E"Sweeper Sidejobs", str, "Close", "");
			}
			case 8:
			{
				new str[3500];
				strcat(str, ""LB_E"GUIDE: Bus Sidejob berada didaerah Commerce\nIkuti Checkpoint dan Angkut Penumpang!\n");
				strcat(str, ""LB_E"");
				strcat(str, ""WHITE_E"COMMAND: -\n");
				ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_MSGBOX, ""WHITE_E"Bus Sidejobs", str, "Close", "");
			}
			case 9:
			{
				new str[3500];
				strcat(str, ""LB_E"GUIDE: Trashmaster Sidejob berada didekat Ocean docks\nCari lah tempat sampah dikota dan angkut\nJika sudah penuh Jual Sampah tersebut!\n");
				strcat(str, ""LB_E"");
				strcat(str, ""WHITE_E"COMMAND: /pickup \n");
				ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_MSGBOX, ""WHITE_E"Trash Sidejobs", str, "Close", "");
			}
            case 10:
			{
				new str[3500];
				strcat(str, ""LB_E"GUIDE: Pizza Boy Sidejob berada diidlewood Pizza Stack\nAntar Pizza Selagu Hangat Lalu Antarkan kesetiap Rumah\n");
				strcat(str, ""LB_E"");
				strcat(str, ""WHITE_E"COMMAND: /getpizza \n");
				ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_MSGBOX, ""WHITE_E"Pizza Sidejobs", str, "Close", "");
			}
			case 11:
			{
				new str[3500];
				strcat(str, ""LB_E"GUIDE: DrugSmugller Job berada didaerah blackmarket\nAmbil Packet dan jual ke Blackmarket!\n");
				strcat(str, ""LB_E"");
				strcat(str, ""WHITE_E"COMMAND: /takepacket /findpacket /droppacket /enablecp \n");
				ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_MSGBOX, ""WHITE_E"Smuggler Ilegall", str, "Close", "");
			}
			case 12:
			{
				new str[3500];
				strcat(str, "{ffffff}Pekerjaan ini dapat anda dapatkan di tempat pemotongan ayam\n\n{7fffd4}CMDS: /aboutayam /potongayam /ambilayam /packingayam /jualayam\n");
				ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_MSGBOX, ""RED_E"Pemotong Ayam Job", str, "Close", "");
			}
			case 13:
			{
				new str[3500];
				strcat(str, ""LB_E"GUIDE: Borax Job berada didaerah terpencil di dekat ladang\nAmbil Borax di lokasi tersebut lalu proses borax agar bisa di jual!\n");
				strcat(str, ""LB_E"");
				strcat(str, ""WHITE_E"COMMAND: /borax (untuk mengambil borax) /prosesborax (agar jadi beberapa packed) /jualborax \n");
				ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_MSGBOX, ""WHITE_E"borax Ilegall", str, "Close", "");
			}
		}
		return 1;
	}
    if(dialogid == DIALOG_TAKEHAULING)
    {
		if(!response) return 1;
		switch(listitem)
		{
			case 0:
			{
				return callcmd::haulingmission(playerid);
			}
			
		}
		return 1;
	}
	if(dialogid == DIALOG_SELL_FISH)
	{
		if(response)
    	{
    		new String[10000];
        	Food += pData[playerid][pBeratIkan] / 25;
      		GivePlayerMoneyEx(playerid, pData[playerid][pBeratIkan] * FishPrice / 2);
          	format(String, sizeof(String), "{FF0000}[Information] : {FFFF00}Kamu mendapat uang sebesar {FF0000}$%s {FFFF00}dari menjual ikan", FormatMoney(pData[playerid][pBeratIkan] * FishPrice / 2));
      		SendClientMessageEx(playerid, COLOR_WHITE, String);
      		pData[playerid][pFTime] = 300;
      		pData[playerid][pFMax] = 0;
      		pData[playerid][pBeratIkan] = 0;
    	}
	}
	if(dialogid == DIALOG_GPS)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
					DisablePlayerCheckpoint(playerid);
					DisablePlayerRaceCheckpoint(playerid);
				}
				case 1:
				{
					ShowPlayerDialog(playerid, DIALOG_GPS_FACTION, DIALOG_STYLE_LIST, "Faction", "Goverment\nPolice Dapartment\nMedic(Hospital)\nJournalist\nCity Hall Los Santos\nBank Los Santos\nInsurance Office\nGojek Office", "Select", "Close");
				}
				case 2:
				{
					ShowPlayerDialog(playerid, DIALOG_GPS_PUBLIC, DIALOG_STYLE_LIST, "Public Gps", "Find Business\nFind Dealership\nFind Atm\nFind Trees\nGanton Gym\nWillowfield Gym\nArea Industry(Jual Ayam)\nCargo(Meat)\nCargo(Seed)\nFind Workshop", "Select", "Close");
				}
				case 3:
				{
					ShowPlayerDialog(playerid, DIALOG_GPS_JOB, DIALOG_STYLE_LIST, "GPS JOB", "Taxi Driver\nMechanic Service\nLumber Jack\nTrucker\nHauling Trailer\nHauling Box\nMiner\nProduction\nFarmer\nSweeper(Side Job)\nBus Driver(Side Job)\nTrashmaster(Side Job)\nForklift(Side Job)\nPizzaboy(Side Job)\nCouriers\nMower(Side Job)\nPemotong Ayam\nMenara Minyak\nBisnis cleaner", "Select", "Close");
				}
				case 4:
				{
					ShowPlayerDialog(playerid, DIALOG_GPS_PROPERTY, DIALOG_STYLE_LIST, "Property", "My House\nMy Bisnis\nMy Vehicle\nMy Mission(Trucker)\nMy Hauling(Trucker)\nMy Dealer(Restock)\nMeat Factory\nSeed Warehouse", "Select", "Close");
				}
				case 5:
				{
					SetPlayerRaceCheckpoint(playerid,1, dData[29][dExtposX], dData[29][dExtposY], dData[29][dExtposZ], 0.0,0.0,0.0, 3.5);
					Info(playerid, "GPS active! follow the checkpoint.");
				}
				case 6:
				{
					ShowPlayerDialog(playerid, DIALOG_GPS_TRUCKER, DIALOG_STYLE_LIST, "Only Trucker", "Component Factory\nMaterial Factory\nFish Factory\nProduct Factory\nComponent Warehouse\nMaterial Warehouse\nFish Warehouse\n", "Select", "Close");
				}
			}
		}
	}
	if(dialogid == DIALOG_GPS_TRUCKER)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
					SetPlayerRaceCheckpoint(playerid,1, 331.1737,920.4896,20.4063, 0.0,0.0,0.0, 3.5);
					Info(playerid, "GPS active! follow the checkpoint.");
				}
				case 1:
				{
					SetPlayerRaceCheckpoint(playerid,1, -23.3818, -270.3624, 5.4297, 0.0,0.0,0.0, 3.5);
					Info(playerid, "GPS active! follow the checkpoint.");
				}
				case 2:
				{
					SetPlayerRaceCheckpoint(playerid,1, 1352.4987, 356.0309, 19.8482, 0.0,0.0,0.0, 3.5);
					Info(playerid, "GPS active! follow the checkpoint.");
				}
				case 3:
				{
					SetPlayerRaceCheckpoint(playerid,1, -279.67, -2148.42, 28.54, 0.0,0.0,0.0, 3.5);
					Info(playerid, "GPS active! follow the checkpoint.");
				}
				case 4:
				{
					SetPlayerRaceCheckpoint(playerid,1, 797.8308,-617.3008,16.0409, 0.0,0.0,0.0, 3.5);
					Info(playerid, "GPS active! follow the checkpoint.");
				}
				case 5:
				{
					SetPlayerRaceCheckpoint(playerid,1, 2281.7327,64.0160,26.4844, 0.0,0.0,0.0, 3.5);
					Info(playerid, "GPS active! follow the checkpoint.");
				}
				case 6:
				{
					SetPlayerRaceCheckpoint(playerid,1, -535.4600,-502.9689,25.2238, 0.0,0.0,0.0, 3.5);
					Info(playerid, "GPS active! follow the checkpoint.");
				}
			}
		}
	}
	if(dialogid == BUSINESS_SETCARGO)
	{
		if(response)
		{
			new i = pData[playerid][pInBiz];
			if(response)
			{
				if(!IsNumeric(inputtext) || isnull(inputtext))
					return Error(playerid, "Masukkan sebuah angka!");
				
				if(strval(inputtext) < 80)
					return Error(playerid, "Harga per cargo minimal $80.00!");
				
				bData[i][bCargo] = strval(inputtext);
				Info(playerid, "Anda berhasil mengubah harga per cargo menjadi %s", FormatMoney(strval(inputtext)));
			}
		}
	}
	if(dialogid == DIALOG_TRACKDEALER)
	{
		if(response)
		{
			new id = ReturnAnyDealer((listitem + 1));

			pData[playerid][pLoc] = id;
			SetPlayerRaceCheckpoint(playerid,1, CarDealershipInfo[id][cdEntranceX], CarDealershipInfo[id][cdEntranceY], CarDealershipInfo[id][cdEntranceZ], 0.0, 0.0, 0.0, 3.5);
			Info(playerid, "Dealership Checkpoint targeted! (%s)", GetLocation(CarDealershipInfo[id][cdEntranceX], CarDealershipInfo[id][cdEntranceY], CarDealershipInfo[id][cdEntranceZ]));
		}
	}
	if(dialogid == DIALOG_GPS_PUBLIC)
	{
		if(response)
		{
			switch(listitem)
			{
			    case 0:
				{
					return callcmd::gpsbis(playerid);
				}
				case 1:
				{
					if(GetAnyDealer() <= 0) return Error(playerid, "Tidak ada Workshop.");
					new id, count = GetAnyDealer(), location[4096], lstr[596];
					strcat(location,"No\tName\tDistance\n",sizeof(location));
					Loop(itt, (count + 1), 1)
					{
						id = ReturnAnyDealer(itt);
						if(itt == count)
						{
							format(lstr,sizeof(lstr), "%d\t%s{ffffff}\t%0.2fm\n", itt, CarDealershipInfo[id][cdMessage], GetPlayerDistanceFromPoint(playerid, CarDealershipInfo[id][cdEntranceX], CarDealershipInfo[id][cdEntranceY], CarDealershipInfo[id][cdEntranceZ]));
						}
						else format(lstr,sizeof(lstr), "%d\t%s{ffffff}\t%0.2fm\n", itt, CarDealershipInfo[id][cdMessage], GetPlayerDistanceFromPoint(playerid, CarDealershipInfo[id][cdEntranceX], CarDealershipInfo[id][cdEntranceY], CarDealershipInfo[id][cdEntranceZ]));
						strcat(location,lstr,sizeof(location));
					}
					ShowPlayerDialog(playerid, DIALOG_TRACKDEALER, DIALOG_STYLE_TABLIST_HEADERS,"Track Dealership",location,"Track","Cancel");
				}
				case 2:
				{
					return callcmd::findatm(playerid);
				}
				case 3:
				{
					return callcmd::findtree(playerid);
				}
				case 4:
				{
					SetPlayerRaceCheckpoint(playerid,1, 2493.0403,-1957.7141,13.5899, 0.0,0.0,0.0, 3.5);
					Info(playerid, "GPS active! follow the checkpoint.");
				}
				case 5:
				{
					SetPlayerRaceCheckpoint(playerid,1, 2229.8333,-1721.2175,13.5608, 0.0, 0.0, 0.0, 3.5);
					Info(playerid, "GPS active! follow the checkpoint.");
				}
				case 6:
				{
					SetPlayerRaceCheckpoint(playerid,1,921.7545,-1299.1313,14.0938, 0.0, 0.0, 0.0, 3.5);
					Info(playerid, "GPS active! follow the checkpoint.");
				}
				case 7:
				{
					SetPlayerRaceCheckpoint(playerid,1,163.5530,-54.8748,1.5781, 0.0, 0.0, 0.0, 3.5);
					Info(playerid, "GPS active! follow the checkpoint.");
				}
				case 8:
				{
					SetPlayerRaceCheckpoint(playerid,1,-383.0497,-1438.9336,26.3277, 0.0, 0.0, 0.0, 3.5);
					Info(playerid, "GPS active! follow the checkpoint.");
				}
				
			}
		}
	}
	if(dialogid == DIALOG_GPS_FACTION)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
					SetPlayerRaceCheckpoint(playerid,1, 1481.3364, -1769.2994, 18.7958, 0.0,0.0,0.0, 3.5);
					Info(playerid, "GPS active! follow the checkpoint.");
				}
				case 1:
				{
					SetPlayerRaceCheckpoint(playerid,1, 1553.0017, -1675.6652, 16.1953, 0.0, 0.0, 0.0, 3.5);
					Info(playerid, "GPS active! follow the checkpoint.");
				}
				case 2:
				{
					SetPlayerRaceCheckpoint(playerid,1, 1174.4111, -1321.4529, 14.7891, 0.0, 0.0, 0.0, 3.5);
					Info(playerid, "GPS active! follow the checkpoint.");

				}
				case 3:
				{
					SetPlayerRaceCheckpoint(playerid,1, 647.6296, -1360.6936, 13.5962, 0.0, 0.0, 0.0, 3.5);
					Info(playerid, "GPS active! follow the checkpoint.");
				}
				case 4:
				{
					SetPlayerRaceCheckpoint(playerid,1, 1124.9160, -2036.8865, 69.8828, 0.0, 0.0, 0.0, 3.5);
					Info(playerid, "GPS active! follow the checkpoint.");

				}
				case 5:
				{
					SetPlayerRaceCheckpoint(playerid,1, 1462.4114, -1012.2354, 26.8531, 0.0, 0.0, 0.0, 3.5);
					Info(playerid, "GPS active! follow the checkpoint.");

				}
				case 6:
				{
					SetPlayerRaceCheckpoint(playerid,1, dData[29][dExtposX], dData[29][dExtposY], dData[29][dExtposZ], 0.0, 0.0, 0.0, 3.5);
					Info(playerid, "GPS active! follow the checkpoint.");

				}
				case 7:
				{
					SetPlayerRaceCheckpoint(playerid,1, 1274.82, -1663.07, 19.7344, 0.0, 0.0, 0.0, 3.5);
					Info(playerid, "GPS active! follow the checkpoint.");

				}
			}
		}
	}
	if(dialogid == DIALOG_GPS_DEALERSHIP)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
					SetPlayerRaceCheckpoint(playerid,1, 531.3663, -1292.3771, 17.3201, 0.0,0.0,0.0, 3.5);
					Info(playerid, "GPS active! follow the checkpoint.");
				}
				case 1:
				{
					SetPlayerRaceCheckpoint(playerid,1, 1261.6554, -1263.1903, 13.5234, 0.0, 0.0, 0.0, 3.5);
					Info(playerid, "GPS active! follow the checkpoint.");
				}
				case 2:
				{
					SetPlayerRaceCheckpoint(playerid,1, 131.4957, -1804.2651, 4.3699, 0.0, 0.0, 0.0, 3.5);
					Info(playerid, "GPS active! follow the checkpoint.");
				}
			}
		}
	}
	if(dialogid == DIALOG_FIND_ATM)
	{
	    if(response)
	    {

            SetPlayerRaceCheckpoint(playerid,1, AtmData[listitem][atmX], AtmData[listitem][atmY], AtmData[listitem][atmZ], 0.0, 0.0, 0.0, 3.5);


			SendClientMessage(playerid, COLOR_RIKO, "GPS: {FFFFFF}The Atm You Selected Is Marked On You Map");
		}
	}
    if(dialogid == DIALOG_FIND_TREES)
	{
	    if(response)
	    {

            SetPlayerRaceCheckpoint(playerid,1, TreeData[listitem][treeX], TreeData[listitem][treeY], TreeData[listitem][treeZ], 0.0, 0.0, 0.0, 3.5);


			SendClientMessage(playerid, COLOR_RIKO, "GPS: {FFFFFF}The Trees You Selected Is Marked On You Map");
		}
	}
	if(dialogid == DIALOG_FIND_BISNIS)
	{
	    if(response)
	    {

            SetPlayerRaceCheckpoint(playerid,1, bData[listitem][bExtposX], bData[listitem][bExtposY], bData[listitem][bExtposZ], 0.0, 0.0, 0.0, 3.5);


			SendClientMessage(playerid, COLOR_RIKO, "GPS: {FFFFFF}The Bisnis You Selected Is Marked On You Map");
		}
	}
	if(dialogid == DIALOG_GPS_PROPERTY)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
					return callcmd::myhouse(playerid);
				}
				case 1:
				{
					return callcmd::mybis(playerid);
				}
				case 2:
				{
					return callcmd::v(playerid, "my");
				}
				case 3:
				{
					if(pData[playerid][pMission] == -1) return Error(playerid, "You dont have mission.");
					new bid = pData[playerid][pMission];
					Info(playerid, "Follow the mission checkpoint to find your bisnis mission location.");
					//SetPlayerCheckpoint(playerid, bData[bid][bExtpos][0], bData[bid][bExtpos][1], bData[bid][bExtpos][2], 3.5);
					SetPlayerRaceCheckpoint(playerid,1, bData[bid][bExtposX], bData[bid][bExtposY], bData[bid][bExtposZ], 0.0, 0.0, 0.0, 3.5);
				}
				case 4:
				{
					if(pData[playerid][pHauling] == -1) return Error(playerid, "You dont have hauling.");
					new id = pData[playerid][pHauling];
					Info(playerid, "Follow the hauling checkpoint to find your gas station location.");
					//SetPlayerCheckpoint(playerid, bData[bid][bExtpos][0], bData[bid][bExtpos][1], bData[bid][bExtpos][2], 3.5);
					SetPlayerRaceCheckpoint(playerid,1, gsData[id][gsPosX], gsData[id][gsPosY], gsData[id][gsPosZ], 0.0, 0.0, 0.0, 3.5);
				}
				case 5:
				{
					return Error(playerid, "Belum tersedia");
				}
				case 6:
				{
					if(pPurchaseCargoMeat[playerid]  == 0) return Error(playerid, "You not have a cargo");
					SetPlayerRaceCheckpoint(playerid,1, 1466.4801,1039.0343,10.0313, 0.0, 0.0, 0.0, 3.5);
					Info(playerid, "GPS active! follow the checkpoint.");
				}
				case 7:
				{
					if(pPurchaseCargoSeed[playerid]  == 0) return Error(playerid, "You not have a cargo");
					SetPlayerRaceCheckpoint(playerid,1, 2790.7275,-2417.8015,13.6329, 0.0, 0.0, 0.0, 3.5);
					Info(playerid, "GPS active! follow the checkpoint.");
				}
			}
		}
	}
	if(dialogid == DIALOG_GPS_JOB)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
					SetPlayerRaceCheckpoint(playerid,1, 1753.46, -1893.96, 13.55, 0.0,0.0,0.0, 3.5); //Taxi
					Info(playerid, "GPS active! follow the checkpoint.");
				}
				case 1:
				{
					SetPlayerRaceCheckpoint(playerid,1, 2190.04150, -2203.62280, 12.59942, 0.0, 0.0, 0.0, 3.5); //Mechanic
					Info(playerid, "GPS active! follow the checkpoint.");
				}
				case 2:
				{
					SetPlayerRaceCheckpoint(playerid,1, -265.81, -2213.57, 29.04, 0.0, 0.0, 0.0, 3.5); //Lumber
					Info(playerid, "GPS active! follow the checkpoint.");

				}
				case 3:
				{
					SetPlayerRaceCheckpoint(playerid,1, -77.38, -1136.52, 1.07, 0.0, 0.0, 0.0, 3.5); //Trucker
					Info(playerid, "GPS active! follow the checkpoint.");
				}
				case 4:
				{
					SetPlayerRaceCheckpoint(playerid,1, -77.38, -1136.52, 1.07, 0.0, 0.0, 0.0, 3.5); //hauling trailer
					Info(playerid, "GPS active! follow the checkpoint(Hauling Trailer).");
				}
				case 5:
				{
					SetPlayerRaceCheckpoint(playerid,1, -77.38, -1136.52, 1.07, 0.0, 0.0, 0.0, 3.5); //hauling box
					Info(playerid, "GPS active! follow the checkpoint(Hauling Box).");
				}
				case 6:
				{
					SetPlayerRaceCheckpoint(playerid,1, 319.94, 874.77, 20.39, 0.0, 0.0, 0.0, 3.5); //Miner
					Info(playerid, "GPS active! follow the checkpoint.");
				}
				case 7:
				{
					SetPlayerRaceCheckpoint(playerid,1, -283.02, -2174.36, 28.66, 0.0, 0.0, 0.0, 3.5); //Production
					Info(playerid, "GPS active! follow the checkpoint.");
				}
				case 8:
				{
					SetPlayerRaceCheckpoint(playerid,1, -382.68, -1438.80, 26.13, 0.0, 0.0, 0.0, 3.5); //Farmer
					Info(playerid, "GPS active! follow the checkpoint.");
				}
				case 9:
				{
					SetPlayerRaceCheckpoint(playerid,1, 1295.81, -1867.30, 13.54, 0.0, 0.0, 0.0, 3.5); //Swpper
					Info(playerid, "GPS active! follow the checkpoint.");

				}
				case 10:
				{
					SetPlayerRaceCheckpoint(playerid,1, 1699.25, -1513.80, 13.38, 0.0, 0.0, 0.0, 3.5); //Bus
					Info(playerid, "GPS active! follow the checkpoint.");

				}
				case 11:
				{
					SetPlayerRaceCheckpoint(playerid,1, 2230.26, -2185.97, 13.54, 0.0, 0.0, 0.0, 3.5); //Trasher
					Info(playerid, "GPS active! follow the checkpoint.");

				}
				case 12:
				{
					SetPlayerRaceCheckpoint(playerid,1, 2736.760009, -2385.711669, 13.395622, 0.0, 0.0, 0.0, 3.5); //forklift
					Info(playerid, "GPS active! follow the checkpoint.");

				}
                case 13:
				{
					SetPlayerRaceCheckpoint(playerid,1, 2108.7407,-1785.5049,13.3868, 0.0, 0.0, 0.0, 3.5); //pizza
					Info(playerid, "GPS active! follow the checkpoint.");
				}
				case 14:
				{
					SetPlayerRaceCheckpoint(playerid,1, 1622.707,-1894.286,13.667, 0.0, 0.0, 0.0, 3.5); //COURIR
					Info(playerid, "GPS active! follow the checkpoint.");
				}
				case 15:
				{
					SetPlayerRaceCheckpoint(playerid,1,2053.07, -1243.93, 23.71, 0.0, 0.0, 0.0, 3.5); //MOWER
					Info(playerid, "GPS active! follow the checkpoint.");
				}
				case 16:
				{
					SetPlayerRaceCheckpoint(playerid,1, -2097.61, -2409.77, 30.62, 0.0, 0.0, 0.0, 3.5); //pemotong ayam
					Info(playerid, "GPS active! follow the checkpoint.");
				}
				case 17:
				{
					SetPlayerRaceCheckpoint(playerid,1, 2726.67,-2567.84,3.00, 0.0, 0.0, 0.0, 3.5); //menara minyak
					Info(playerid, "GPS active! follow the checkpoint.");
				}
				case 18:
				{
					SetPlayerRaceCheckpoint(playerid,1, 2070.6267,-1793.8580,13.5469, 0.0, 0.0, 0.0, 3.5); //menara minyak
					Info(playerid, "GPS active! follow the checkpoint.");

				}
			}
		}
	}
	if(dialogid == DIALOG_PAY)
	{
		if(response)
		{
			new mstr[128];
			new otherid = GetPVarInt(playerid, "gcPlayer");
			new money = GetPVarInt(playerid, "gcAmount");

			if(otherid == INVALID_PLAYER_ID)
				return Error(playerid, "Player not connected!");
			GivePlayerMoneyEx(otherid, money);
			GivePlayerMoneyEx(playerid, -money);

			format(mstr, sizeof(mstr), "PAYINFO: {ffffff} You've given %s(%i) {ffff00}$%s", ReturnName(otherid), otherid, FormatMoney(money));
			SendClientMessage(playerid, COLOR_GREY, mstr);
			format(mstr, sizeof(mstr), "PAYINFO: {ffffff}You've received {00ff00}$%s {ffffff}from {ffff00}%s [id:%d]", FormatMoney(money), ReturnName(playerid), playerid);
			SendClientMessage(otherid, COLOR_GREY, mstr);
			InfoTD_MSG(playerid, 3500, "~g~~h~Money Sent!");
			InfoTD_MSG(otherid, 3500, "~g~~h~Money received!");
			ApplyAnimation(playerid, "DEALER", "DEALER_DEAL", 4.0, 0, 0, 0, 0, 0);
   			ApplyAnimation(otherid, "DEALER", "DEALER_DEAL", 4.0, 0, 0, 0, 0, 0);

			new query[512];
			mysql_format(g_SQL, query, sizeof(query), "INSERT INTO logpay (player,playerid,toplayer,toplayerid,ammount,time) VALUES('%s','%d','%s','%d','%d',UNIX_TIMESTAMP())", pData[playerid][pName], pData[playerid][pID], pData[otherid][pName], pData[otherid][pID], money);
			mysql_tquery(g_SQL, query);
		}
		return 1;
	}
	//-------------[ Player Weapons Atth ]-----------
	if(dialogid == DIALOG_EDITBONE)
	{
		if(response)
		{
			new weaponid = EditingWeapon[playerid], weaponname[18], string[150];

			GetWeaponName(weaponid, weaponname, sizeof(weaponname));

			WeaponSettings[playerid][weaponid - 22][Bone] = listitem + 1;

			Servers(playerid, "You have successfully changed the bone of your %s.", weaponname);

			mysql_format(g_SQL, string, sizeof(string), "INSERT INTO weaponsettings (Owner, WeaponID, Bone) VALUES ('%d', %d, %d) ON DUPLICATE KEY UPDATE Bone = VALUES(Bone)", pData[playerid][pID], weaponid, listitem + 1);
			mysql_tquery(g_SQL, string);
		}
		EditingWeapon[playerid] = 0;
	}
	//------------[ Family Dialog ]------------
	if(dialogid == FAMILY_SAFE)
	{
		if(!response) return 1;
		new fid = pData[playerid][pFamily];
		switch(listitem)
		{
			case 0: Family_OpenStorage(playerid, fid);
			case 1:
			{
				//Marijuana
				ShowPlayerDialog(playerid, FAMILY_MARIJUANA, DIALOG_STYLE_LIST, "Marijuana", "Withdraw from safe\nDeposit into safe", "Select", "Back");
			}
			case 2:
			{
				//Component
				ShowPlayerDialog(playerid, FAMILY_COMPONENT, DIALOG_STYLE_LIST, "Component", "Withdraw from safe\nDeposit into safe", "Select", "Back");
			}
			case 3:
			{
				//Material
				ShowPlayerDialog(playerid, FAMILY_MATERIAL, DIALOG_STYLE_LIST, "Material", "Withdraw from safe\nDeposit into safe", "Select", "Back");
			}
			case 4:
			{
				//Money
				ShowPlayerDialog(playerid, FAMILY_MONEY, DIALOG_STYLE_LIST, "Money", "Withdraw from safe\nDeposit into safe", "Select", "Back");
			}
		}
		return 1;
	}
	if(dialogid == S_WEAPONS)
	{
		new fid = pData[playerid][pInStorage];
		if(response)
		{
			if(StgData[fid][sGun][listitem] != 0)
			{
				GivePlayerWeaponEx(playerid, StgData[fid][sGun][listitem], StgData[fid][sAmmo][listitem]);

				SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s has taken a \"%s\" from their weapon storage.", ReturnName(playerid), ReturnWeaponName(StgData[fid][sGun][listitem]));

				StgData[fid][sGun][listitem] = 0;
				StgData[fid][sAmmo][listitem] = 0;

				StorageSave(fid);
				S_WeaponStorage(playerid, fid);
			}
			else
			{
				new
					weaponid = GetPlayerWeaponEx(playerid),
					ammo = GetPlayerAmmoEx(playerid);

				if(!weaponid)
					return Error(playerid, "You are not holding any weapon!");

				/*if(weaponid == 23 && pData[playerid][pTazer])
					return Error(playerid, "You can't store a tazer into your safe.");

				if(weaponid == 25 && pData[playerid][pBeanBag])
					return Error(playerid, "You can't store a beanbag shotgun into your safe.");*/

				ResetWeapon(playerid, weaponid);
				SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s has stored a \"%s\" into their weapon storage.", ReturnName(playerid), ReturnWeaponName(weaponid));

				StgData[fid][sGun][listitem] = weaponid;
				StgData[fid][sAmmo][listitem] = ammo;

				StorageSave(fid);
				S_WeaponStorage(playerid, fid);
			}
		}
		return 1;
	}
	if(dialogid == FAMILY_STORAGE)
	{
		new fid = pData[playerid][pFamily];
		if(response)
		{
			if(listitem == 0)
			{
				Family_WeaponStorage(playerid, fid);
			}
		}
		return 1;
	}
	if(dialogid == FAMILY_WEAPONS)
	{
		new fid = pData[playerid][pFamily];
		if(response)
		{
			if(fData[fid][fGun][listitem] != 0)
			{
				if(pData[playerid][pFamilyRank] < 1)
					return Error(playerid, "You No Member");

				GivePlayerWeaponEx(playerid, fData[fid][fGun][listitem], fData[fid][fAmmo][listitem]);

				SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s has taken a \"%s\" from their weapon storage.", ReturnName(playerid), ReturnWeaponName(fData[fid][fGun][listitem]));

				fData[fid][fGun][listitem] = 0;
				fData[fid][fAmmo][listitem] = 0;

				Family_Save(fid);
				Family_WeaponStorage(playerid, fid);
			}
			else
			{
				new
					weaponid = GetPlayerWeaponEx(playerid),
					ammo = GetPlayerAmmoEx(playerid);

				if(!weaponid)
					return Error(playerid, "You are not holding any weapon!");

				/*if(weaponid == 23 && pData[playerid][pTazer])
					return Error(playerid, "You can't store a tazer into your safe.");

				if(weaponid == 25 && pData[playerid][pBeanBag])
					return Error(playerid, "You can't store a beanbag shotgun into your safe.");*/

				ResetWeapon(playerid, weaponid);
				SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s has stored a \"%s\" into their weapon storage.", ReturnName(playerid), ReturnWeaponName(weaponid));

				fData[fid][fGun][listitem] = weaponid;
				fData[fid][fAmmo][listitem] = ammo;

				Family_Save(fid);
				Family_WeaponStorage(playerid, fid);
			}
		}
		else
		{
			Family_OpenStorage(playerid, fid);
		}
		return 1;
	}
	if(dialogid == FAMILY_MARIJUANA)
	{
		if(response)
		{
			new fid = pData[playerid][pFamily];
			if(fid == -1) return Error(playerid, "You don't have family.");
			if(response)
			{
				switch (listitem)
				{
					case 0:
					{
						/*if(pData[playerid][pFamilyRank] < 5)
							return Error(playerid, "Only boss can withdraw marijuana!");*/

						new str[128];
						format(str, sizeof(str), "Marijuana Balance: %d\n\nPlease enter how much marijuana you wish to withdraw from the safe:", fData[fid][fMarijuana]);
						ShowPlayerDialog(playerid, FAMILY_WITHDRAWMARIJUANA, DIALOG_STYLE_INPUT, "Withdraw from safe", str, "Withdraw", "Back");
					}
					case 1:
					{
						new str[128];
						format(str, sizeof(str), "Marijuana Balance: %d\n\nPlease enter how much marijuana you wish to deposit into the safe:", fData[fid][fMarijuana]);
						ShowPlayerDialog(playerid, FAMILY_DEPOSITMARIJUANA, DIALOG_STYLE_INPUT, "Deposit into safe", str, "Deposit", "Back");
					}
				}
			}
			else callcmd::fsafe(playerid);
		}
		return 1;
	}
	if(dialogid == FAMILY_WITHDRAWMARIJUANA)
	{
		new fid = pData[playerid][pFamily];
		if(fid == -1) return Error(playerid, "You don't have family.");

		if(response)
		{
			new amount = strval(inputtext);

			if(isnull(inputtext))
			{
				new str[128];
				format(str, sizeof(str), "Marijuana Balance: %d\n\nPlease enter how much marijuana you wish to withdraw from the safe:", fData[fid][fMarijuana]);
				ShowPlayerDialog(playerid, FAMILY_WITHDRAWMARIJUANA, DIALOG_STYLE_INPUT, "Withdraw from safe", str, "Withdraw", "Back");
				return 1;
			}
			if(amount < 1 || amount > fData[fid][fMarijuana])
			{
				new str[128];
				format(str, sizeof(str), "Error: Insufficient funds.\n\nMarijuana Balance: %d\n\nPlease enter how much marijuana you wish to withdraw from the safe:", fData[fid][fMarijuana]);
				ShowPlayerDialog(playerid, FAMILY_WITHDRAWMARIJUANA, DIALOG_STYLE_INPUT, "Withdraw from safe", str, "Withdraw", "Back");
				return 1;
			}
			fData[fid][fMarijuana] -= amount;
			pData[playerid][pMarijuana] += amount;

			Family_Save(fid);
			SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s has withdrawn %d marijuana from their family safe.", ReturnName(playerid), amount);
			callcmd::fsafe(playerid);
			return 1;
		}
		else callcmd::fsafe(playerid);
		return 1;
	}
	if(dialogid == FAMILY_DEPOSITMARIJUANA)
	{
		new fid = pData[playerid][pFamily];
		if(fid == -1) return Error(playerid, "You don't have family.");
		if(response)
		{
			new amount = strval(inputtext);

			if(isnull(inputtext))
			{
				new str[128];
				format(str, sizeof(str), "Marijuana Balance: %d\n\nPlease enter how much marijuana you wish to deposit into the safe:", fData[fid][fMarijuana]);
				ShowPlayerDialog(playerid, FAMILY_DEPOSITMARIJUANA, DIALOG_STYLE_INPUT, "Deposit into safe", str, "Deposit", "Back");
				return 1;
			}
			if(amount < 1 || amount > pData[playerid][pMarijuana])
			{
				new str[128];
				format(str, sizeof(str), "Error: Insufficient funds.\n\nMarijuana Balance: %d\n\nPlease enter how much marijuana you wish to deposit into the safe:", fData[fid][fMarijuana]);
				ShowPlayerDialog(playerid, FAMILY_DEPOSITMARIJUANA, DIALOG_STYLE_INPUT, "Deposit into safe", str, "Deposit", "Back");
				return 1;
			}
			fData[fid][fMarijuana] += amount;
			pData[playerid][pMarijuana] -= amount;

			Family_Save(fid);
			SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s has deposited %d marijuana into their family safe.", ReturnName(playerid), amount);
		}
		else callcmd::fsafe(playerid);
		return 1;
	}
	if(dialogid == FAMILY_COMPONENT)
	{
		if(response)
		{
			new fid = pData[playerid][pFamily];
			if(fid == -1) return Error(playerid, "You don't have family.");
			if(response)
			{
				switch (listitem)
				{
					case 0:
					{
						/*if(pData[playerid][pFamilyRank] < 5)
							return Error(playerid, "Only boss can withdraw component!");*/

						new str[128];
						format(str, sizeof(str), "Component Balance: %d\n\nPlease enter how much component you wish to withdraw from the safe:", fData[fid][fComponent]);
						ShowPlayerDialog(playerid, FAMILY_WITHDRAWCOMPONENT, DIALOG_STYLE_INPUT, "Withdraw from safe", str, "Withdraw", "Back");
					}
					case 1:
					{
						new str[128];
						format(str, sizeof(str), "Component Balance: %d\n\nPlease enter how much component you wish to deposit into the safe:", fData[fid][fComponent]);
						ShowPlayerDialog(playerid, FAMILY_DEPOSITCOMPONENT, DIALOG_STYLE_INPUT, "Deposit into safe", str, "Deposit", "Back");
					}
				}
			}
			else callcmd::fsafe(playerid);
		}
		return 1;
	}
	if(dialogid == FAMILY_WITHDRAWCOMPONENT)
	{
		new fid = pData[playerid][pFamily];
		if(fid == -1) return Error(playerid, "You don't have family.");

		if(response)
		{
			new amount = strval(inputtext);

			if(isnull(inputtext))
			{
				new str[128];
				format(str, sizeof(str), "Component Balance: %d\n\nPlease enter how much component you wish to withdraw from the safe:", fData[fid][fComponent]);
				ShowPlayerDialog(playerid, FAMILY_WITHDRAWCOMPONENT, DIALOG_STYLE_INPUT, "Withdraw from safe", str, "Withdraw", "Back");
				return 1;
			}
			if(amount < 1 || amount > fData[fid][fComponent])
			{
				new str[128];
				format(str, sizeof(str), "Error: Insufficient funds.\n\nComponent Balance: %d\n\nPlease enter how much component you wish to withdraw from the safe:", fData[fid][fComponent]);
				ShowPlayerDialog(playerid, FAMILY_WITHDRAWCOMPONENT, DIALOG_STYLE_INPUT, "Withdraw from safe", str, "Withdraw", "Back");
				return 1;
			}
			fData[fid][fComponent] -= amount;
			pData[playerid][pComponent] += amount;

			Family_Save(fid);
			SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s has withdrawn %d component from their family safe.", ReturnName(playerid), amount);
			callcmd::fsafe(playerid);
			return 1;
		}
		else callcmd::fsafe(playerid);
		return 1;
	}
	if(dialogid == FAMILY_DEPOSITCOMPONENT)
	{
		new fid = pData[playerid][pFamily];
		if(fid == -1) return Error(playerid, "You don't have family.");
		if(response)
		{
			new amount = strval(inputtext);

			if(isnull(inputtext))
			{
				new str[128];
				format(str, sizeof(str), "Component Balance: %d\n\nPlease enter how much component you wish to deposit into the safe:", fData[fid][fComponent]);
				ShowPlayerDialog(playerid, FAMILY_DEPOSITCOMPONENT, DIALOG_STYLE_INPUT, "Deposit into safe", str, "Deposit", "Back");
				return 1;
			}
			if(amount < 1 || amount > pData[playerid][pComponent])
			{
				new str[128];
				format(str, sizeof(str), "Error: Insufficient funds.\n\nComponent Balance: %d\n\nPlease enter how much component you wish to deposit into the safe:", fData[fid][fComponent]);
				ShowPlayerDialog(playerid, FAMILY_DEPOSITCOMPONENT, DIALOG_STYLE_INPUT, "Deposit into safe", str, "Deposit", "Back");
				return 1;
			}
			fData[fid][fComponent] += amount;
			pData[playerid][pComponent] -= amount;

			Family_Save(fid);
			SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s has deposited %d component into their family safe.", ReturnName(playerid), amount);
		}
		else callcmd::fsafe(playerid);
		return 1;
	}
	if(dialogid == FAMILY_MATERIAL)
	{
		if(response)
		{
			new fid = pData[playerid][pFamily];
			if(fid == -1) return Error(playerid, "You don't have family.");
			if(response)
			{
				switch (listitem)
				{
					case 0:
					{
						/*if(pData[playerid][pFamilyRank] < 5)
							return Error(playerid, "Only boss can withdraw material!");*/

						new str[128];
						format(str, sizeof(str), "Material Balance: %d\n\nPlease enter how much material you wish to withdraw from the safe:", fData[fid][fMaterial]);
						ShowPlayerDialog(playerid, FAMILY_WITHDRAWMATERIAL, DIALOG_STYLE_INPUT, "Withdraw from safe", str, "Withdraw", "Back");
					}
					case 1:
					{
						new str[128];
						format(str, sizeof(str), "Material Balance: %d\n\nPlease enter how much material you wish to deposit into the safe:", fData[fid][fMaterial]);
						ShowPlayerDialog(playerid, FAMILY_DEPOSITMATERIAL, DIALOG_STYLE_INPUT, "Deposit into safe", str, "Deposit", "Back");
					}
				}
			}
			else callcmd::fsafe(playerid);
		}
		return 1;
	}
	if(dialogid == FAMILY_WITHDRAWMATERIAL)
	{
		new fid = pData[playerid][pFamily];
		if(fid == -1) return Error(playerid, "You don't have family.");

		if(response)
		{
			new amount = strval(inputtext);

			if(isnull(inputtext))
			{
				new str[128];
				format(str, sizeof(str), "Material Balance: %d\n\nPlease enter how much material you wish to withdraw from the safe:", fData[fid][fMaterial]);
				ShowPlayerDialog(playerid, FAMILY_WITHDRAWMATERIAL, DIALOG_STYLE_INPUT, "Withdraw from safe", str, "Withdraw", "Back");
				return 1;
			}
			if(amount < 1 || amount > fData[fid][fMaterial])
			{
				new str[128];
				format(str, sizeof(str), "Error: Insufficient funds.\n\nMaterial Balance: %d\n\nPlease enter how much material you wish to withdraw from the safe:", fData[fid][fMaterial]);
				ShowPlayerDialog(playerid, FAMILY_WITHDRAWMATERIAL, DIALOG_STYLE_INPUT, "Withdraw from safe", str, "Withdraw", "Back");
				return 1;
			}
			fData[fid][fMaterial] -= amount;
			pData[playerid][pMaterial] += amount;

			Family_Save(fid);
			SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s has withdrawn %d material from their family safe.", ReturnName(playerid), amount);
			callcmd::fsafe(playerid);
			return 1;
		}
		else callcmd::fsafe(playerid);
		return 1;
	}
	if(dialogid == FAMILY_DEPOSITMATERIAL)
	{
		new fid = pData[playerid][pFamily];
		if(fid == -1) return Error(playerid, "You don't have family.");
		if(response)
		{
			new amount = strval(inputtext);

			if(isnull(inputtext))
			{
				new str[128];
				format(str, sizeof(str), "Material Balance: %d\n\nPlease enter how much material you wish to deposit into the safe:", fData[fid][fMaterial]);
				ShowPlayerDialog(playerid, FAMILY_DEPOSITMATERIAL, DIALOG_STYLE_INPUT, "Deposit into safe", str, "Deposit", "Back");
				return 1;
			}
			if(amount < 1 || amount > pData[playerid][pMaterial])
			{
				new str[128];
				format(str, sizeof(str), "Error: Insufficient funds.\n\nMaterial Balance: %d\n\nPlease enter how much material you wish to deposit into the safe:", fData[fid][fMaterial]);
				ShowPlayerDialog(playerid, FAMILY_DEPOSITMATERIAL, DIALOG_STYLE_INPUT, "Deposit into safe", str, "Deposit", "Back");
				return 1;
			}
			fData[fid][fMaterial] += amount;
			pData[playerid][pMaterial] -= amount;

			Family_Save(fid);
			SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s has deposited %d material into their family safe.", ReturnName(playerid), amount);
		}
		else callcmd::fsafe(playerid);
		return 1;
	}
	if(dialogid == FAMILY_MONEY)
	{
		if(response)
		{
			new fid = pData[playerid][pFamily];
			if(fid == -1) return Error(playerid, "You don't have family.");
			if(response)
			{
				switch (listitem)
				{
					case 0:
					{
						/*if(pData[playerid][pFamilyRank] < 5)
							return Error(playerid, "Only boss can withdraw money!");*/

						new str[128];
						format(str, sizeof(str), "Money Balance: %s\n\nPlease enter how much money you wish to withdraw from the safe:", FormatMoney(fData[fid][fMoney]));
						ShowPlayerDialog(playerid, FAMILY_WITHDRAWMONEY, DIALOG_STYLE_INPUT, "Withdraw from safe", str, "Withdraw", "Back");
					}
					case 1:
					{
						new str[128];
						format(str, sizeof(str), "Money Balance: %s\n\nPlease enter how much money you wish to deposit into the safe:", FormatMoney(fData[fid][fMoney]));
						ShowPlayerDialog(playerid, FAMILY_DEPOSITMONEY, DIALOG_STYLE_INPUT, "Deposit into safe", str, "Deposit", "Back");
					}
				}
			}
			else callcmd::fsafe(playerid);
		}
		return 1;
	}
	if(dialogid == FAMILY_WITHDRAWMONEY)
	{
		new fid = pData[playerid][pFamily];
		if(fid == -1) return Error(playerid, "You don't have family.");

		if(response)
		{
			new amount = strval(inputtext);

			if(isnull(inputtext))
			{
				new str[128];
				format(str, sizeof(str), "Money Balance: %s\n\nPlease enter how much money you wish to withdraw from the safe:", FormatMoney(fData[fid][fMoney]));
				ShowPlayerDialog(playerid, FAMILY_WITHDRAWMONEY, DIALOG_STYLE_INPUT, "Withdraw from safe", str, "Withdraw", "Back");
				return 1;
			}
			if(amount < 1 || amount > fData[fid][fMoney])
			{
				new str[128];
				format(str, sizeof(str), "Error: Insufficient funds.\n\nMoney Balance: %s\n\nPlease enter how much money you wish to withdraw from the safe:", FormatMoney(fData[fid][fMoney]));
				ShowPlayerDialog(playerid, FAMILY_WITHDRAWMONEY, DIALOG_STYLE_INPUT, "Withdraw from safe", str, "Withdraw", "Back");
				return 1;
			}
			fData[fid][fMoney] -= amount;
			GivePlayerMoneyEx(playerid, amount);

			Family_Save(fid);
			SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s has withdrawn %s money from their family safe.", ReturnName(playerid), FormatMoney(amount));
			callcmd::fsafe(playerid);
			return 1;
		}
		else callcmd::fsafe(playerid);
		return 1;
	}
	if(dialogid == FAMILY_DEPOSITMONEY)
	{
		new fid = pData[playerid][pFamily];
		if(fid == -1) return Error(playerid, "You don't have family.");
		if(response)
		{
			new amount = strval(inputtext);

			if(isnull(inputtext))
			{
				new str[128];
				format(str, sizeof(str), "Money Balance: %s\n\nPlease enter how much money you wish to deposit into the safe:", FormatMoney(fData[fid][fMoney]));
				ShowPlayerDialog(playerid, FAMILY_DEPOSITMATERIAL, DIALOG_STYLE_INPUT, "Deposit into safe", str, "Deposit", "Back");
				return 1;
			}
			if(amount < 1 || amount > GetPlayerMoney(playerid))
			{
				new str[128];
				format(str, sizeof(str), "Error: Insufficient funds.\n\nMoney Balance: %s\n\nPlease enter how much money you wish to deposit into the safe:", FormatMoney(fData[fid][fMoney]));
				ShowPlayerDialog(playerid, FAMILY_DEPOSITMATERIAL, DIALOG_STYLE_INPUT, "Deposit into safe", str, "Deposit", "Back");
				return 1;
			}
			fData[fid][fMoney] += amount;
			GivePlayerMoneyEx(playerid, -amount);

			Family_Save(fid);
			SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s has deposited %s money into their family safe.", ReturnName(playerid), FormatMoney(amount));
		}
		else callcmd::fsafe(playerid);
		return 1;
	}
	if(dialogid == FAMILY_INFO)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
					if(pData[playerid][pFamily] == -1)
						return Error(playerid, "You dont have family!");
					new query[512];
					mysql_format(g_SQL, query, sizeof(query), "SELECT name,leader,marijuana,component,material,money FROM familys WHERE ID = %d", pData[playerid][pFamily]);
					mysql_tquery(g_SQL, query, "ShowFamilyInfo", "i", playerid);
				}
				case 1:
				{
					if(pData[playerid][pFamily] == -1)
						return Error(playerid, "You dont have family!");

					new lstr[1024];
					format(lstr, sizeof(lstr), "Rank\tName\n");
					foreach(new i: Player)
					{
						if(pData[i][pFamily] == pData[playerid][pFamily])
						{
							format(lstr, sizeof(lstr), "%s%s\t%s(%d)", lstr, GetFamilyRank(i), pData[i][pName], i);
							format(lstr, sizeof(lstr), "%s\n", lstr);
						}
					}
					format(lstr, sizeof(lstr), "%s\n", lstr);
					ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_TABLIST_HEADERS, "Family Online", lstr, "Close", "");

				}
				case 2:
				{
					if(pData[playerid][pFamily] == -1)
						return Error(playerid, "You dont have family!");
					new query[512];
					mysql_format(g_SQL, query, sizeof(query), "SELECT username,familyrank FROM players WHERE family = %d", pData[playerid][pFamily]);
					mysql_tquery(g_SQL, query, "ShowFamilyMember", "i", playerid);
				}
			}
		}
		return 1;
	}
	//[Farm]
	if(dialogid == FARM_INFO)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
					if(pData[playerid][pFarm] == -1)
						return Error(playerid, "You dont have farm!");
					new query[512];
					mysql_format(g_SQL, query, sizeof(query), "SELECT name,leader,potato,wheat,orange,money FROM farm WHERE ID = %d", pData[playerid][pFarm]);
					mysql_tquery(g_SQL, query, "ShowFarmInfo", "i", playerid);
				}
				case 1:
				{
					if(pData[playerid][pFarm] == -1)
						return Error(playerid, "You dont have farm!");

					new lstr[1024];
					format(lstr, sizeof(lstr), "Rank\tName\n");
					foreach(new i: Player)
					{
						if(pData[i][pFarm] == pData[playerid][pFarm])
						{
							format(lstr, sizeof(lstr), "%s%s\t%s(%d)", lstr, GetFamilyRank(i), pData[i][pName], i);
							format(lstr, sizeof(lstr), "%s\n", lstr);
						}
					}
					format(lstr, sizeof(lstr), "%s\n", lstr);
					ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_TABLIST_HEADERS, "Farm Emplooye Online", lstr, "Close", "");

				}
				case 2:
				{
					if(pData[playerid][pFarm] == -1)
						return Error(playerid, "You dont have farm!");
					new query[512];
					mysql_format(g_SQL, query, sizeof(query), "SELECT username,familyrank FROM players WHERE farm = %d", pData[playerid][pFarm]);
					mysql_tquery(g_SQL, query, "ShowFarmMember", "i", playerid);
				}
			}
		}
		return 1;
	}
	if(dialogid == FARM_STORAGE)
	{
		if(!response) return 1;
		switch(listitem)
		{
			case 0:
			{
				//Potato
				ShowPlayerDialog(playerid, FARM_POTATO, DIALOG_STYLE_LIST, "Potato", "Withdraw from storage\nDeposit into storage", "Select", "Back");
			}
			case 1:
			{
				//Wheat
				ShowPlayerDialog(playerid, FARM_WHEAT, DIALOG_STYLE_LIST, "Wheat", "Withdraw from storage\nDeposit into storage", "Select", "Back");
			}
			case 2:
			{
				//Orange
				ShowPlayerDialog(playerid, FARM_ORANGE, DIALOG_STYLE_LIST, "Orange", "Withdraw from storage\nDeposit into storage", "Select", "Back");
			}
			case 3:
			{
				//Money
				ShowPlayerDialog(playerid, FARM_MONEY, DIALOG_STYLE_LIST, "Money", "Withdraw from storage\nDeposit into storage", "Select", "Back");
			}
		}
		return 1;
	}
	if(dialogid == FARM_POTATO)
	{
		if(response)
		{
			new fid = pData[playerid][pFarm];
			if(fid == -1) return Error(playerid, "You don't have farm.");
			if(response)
			{
				switch (listitem)
				{
					case 0:
					{
						new str[128];
						format(str, sizeof(str), "Potato Balance: %d\n\nPlease enter how much Potato you wish to withdraw from the safe:", farmData[fid][farmPotato]);
						ShowPlayerDialog(playerid, FARM_WITHDRAWPOTATO, DIALOG_STYLE_INPUT, "Withdraw from safe", str, "Withdraw", "Back");
					}
					case 1:
					{
						new str[128];
						format(str, sizeof(str), "Potato Balance: %d\n\nPlease enter how much Potato you wish to deposit into the safe:", farmData[fid][farmPotato]);
						ShowPlayerDialog(playerid, FARM_DEPOSITPOTATO, DIALOG_STYLE_INPUT, "Deposit into safe", str, "Deposit", "Back");
					}
				}
			}
			else callcmd::fstorage(playerid);
		}
		return 1;
	}
	if(dialogid == FARM_WITHDRAWPOTATO)
	{
		new fid = pData[playerid][pFarm];
		if(fid == -1) return Error(playerid, "You don't have farm.");

		if(response)
		{
			new amount = strval(inputtext);

			if(isnull(inputtext))
			{
				new str[128];
				format(str, sizeof(str), "Potato Balance: %d\n\nPlease enter how much Potato you wish to withdraw from the safe:", farmData[fid][farmPotato]);
				ShowPlayerDialog(playerid, FARM_WITHDRAWPOTATO, DIALOG_STYLE_INPUT, "Withdraw from safe", str, "Withdraw", "Back");
				return 1;
			}
			if(amount < 1 || amount > farmData[fid][farmPotato])
			{
				new str[128];
				format(str, sizeof(str), "Error: Insufficient funds.\n\nPotato Balance: %d\n\nPlease enter how much Potato you wish to withdraw from the safe:", farmData[fid][farmPotato]);
				ShowPlayerDialog(playerid, FARM_WITHDRAWPOTATO, DIALOG_STYLE_INPUT, "Withdraw from safe", str, "Withdraw", "Back");
				return 1;
			}
			farmData[fid][farmPotato] -= amount;
			pData[playerid][pPotato] += amount;

			SaveFarm(fid);
			SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s has withdrawn %d Potato from their farm safe.", ReturnName(playerid), amount);
			callcmd::fsafe(playerid);
			return 1;
		}
		else callcmd::fstorage(playerid);
		return 1;
	}
	if(dialogid == FARM_DEPOSITPOTATO)
	{
		new fid = pData[playerid][pFarm];
		if(fid == -1) return Error(playerid, "You don't have farm.");
		if(response)
		{
			new amount = strval(inputtext);

			if(isnull(inputtext))
			{
				new str[128];
				format(str, sizeof(str), "Potato Balance: %d\n\nPlease enter how much Potato you wish to deposit into the safe:", farmData[fid][farmPotato]);
				ShowPlayerDialog(playerid, FARM_DEPOSITPOTATO, DIALOG_STYLE_INPUT, "Deposit into safe", str, "Deposit", "Back");
				return 1;
			}
			if(amount < 1 || amount > pData[playerid][pPotato])
			{
				new str[128];
				format(str, sizeof(str), "Error: Insufficient funds.\n\nPotato Balance: %d\n\nPlease enter how much Potato you wish to deposit into the safe:", farmData[fid][farmPotato]);
				ShowPlayerDialog(playerid, FARM_DEPOSITPOTATO, DIALOG_STYLE_INPUT, "Deposit into safe", str, "Deposit", "Back");
				return 1;
			}
			farmData[fid][farmPotato] += amount;
			pData[playerid][pPotato] -= amount;

			SaveFarm(fid);
			SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s has deposited %d Potato into their farm safe.", ReturnName(playerid), amount);
		}
		else callcmd::fstorage(playerid);
		return 1;
	}
	if(dialogid == FARM_WHEAT)
	{
		if(response)
		{
			new fid = pData[playerid][pFarm];
			if(fid == -1) return Error(playerid, "You don't have farm.");
			if(response)
			{
				switch (listitem)
				{
					case 0:
					{
						new str[128];
						format(str, sizeof(str), "Wheat Balance: %d\n\nPlease enter how much wheat you wish to withdraw from the safe:", farmData[fid][farmWheat]);
						ShowPlayerDialog(playerid, FARM_WITHDRAWWHEAT, DIALOG_STYLE_INPUT, "Withdraw from safe", str, "Withdraw", "Back");
					}
					case 1:
					{
						new str[128];
						format(str, sizeof(str), "Wheat Balance: %d\n\nPlease enter how much wheat you wish to deposit into the safe:", farmData[fid][farmWheat]);
						ShowPlayerDialog(playerid, FARM_DEPOSITWHEAT, DIALOG_STYLE_INPUT, "Deposit into safe", str, "Deposit", "Back");
					}
				}
			}
			else callcmd::fstorage(playerid);
		}
		return 1;
	}
	if(dialogid == FARM_WITHDRAWWHEAT)
	{
		new fid = pData[playerid][pFarm];
		if(fid == -1) return Error(playerid, "You don't have farm.");

		if(response)
		{
			new amount = strval(inputtext);

			if(isnull(inputtext))
			{
				new str[128];
				format(str, sizeof(str), "Wheat Balance: %d\n\nPlease enter how much wheat you wish to withdraw from the safe:", farmData[fid][farmWheat]);
				ShowPlayerDialog(playerid, FARM_WITHDRAWWHEAT, DIALOG_STYLE_INPUT, "Withdraw from safe", str, "Withdraw", "Back");
				return 1;
			}
			if(amount < 1 || amount > farmData[fid][farmWheat])
			{
				new str[128];
				format(str, sizeof(str), "Error: Insufficient funds.\n\nWheat Balance: %d\n\nPlease enter how much wheat you wish to withdraw from the safe:", farmData[fid][farmWheat]);
				ShowPlayerDialog(playerid, FARM_WITHDRAWWHEAT, DIALOG_STYLE_INPUT, "Withdraw from safe", str, "Withdraw", "Back");
				return 1;
			}
			farmData[fid][farmWheat] -= amount;
			pData[playerid][pWheat] += amount;

			SaveFarm(fid);
			SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s has withdrawn %d wheat from their farm safe.", ReturnName(playerid), amount);
			callcmd::fsafe(playerid);
			return 1;
		}
		else callcmd::fstorage(playerid);
		return 1;
	}
	if(dialogid == FARM_DEPOSITWHEAT)
	{
		new fid = pData[playerid][pFarm];
		if(fid == -1) return Error(playerid, "You don't have farm.");
		if(response)
		{
			new amount = strval(inputtext);

			if(isnull(inputtext))
			{
				new str[128];
				format(str, sizeof(str), "Wheat Balance: %d\n\nPlease enter how much wheat you wish to deposit into the safe:", farmData[fid][farmWheat]);
				ShowPlayerDialog(playerid, FARM_DEPOSITWHEAT, DIALOG_STYLE_INPUT, "Deposit into safe", str, "Deposit", "Back");
				return 1;
			}
			if(amount < 1 || amount > pData[playerid][pWheat])
			{
				new str[128];
				format(str, sizeof(str), "Error: Insufficient funds.\n\nWheat Balance: %d\n\nPlease enter how much wheat you wish to deposit into the safe:", farmData[fid][farmWheat]);
				ShowPlayerDialog(playerid, FARM_DEPOSITWHEAT, DIALOG_STYLE_INPUT, "Deposit into safe", str, "Deposit", "Back");
				return 1;
			}
			farmData[fid][farmWheat] += amount;
			pData[playerid][pWheat] -= amount;

			SaveFarm(fid);
			SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s has deposited %d wheat into their farm safe.", ReturnName(playerid), amount);
		}
		else callcmd::fstorage(playerid);
		return 1;
	}
	if(dialogid == FARM_ORANGE)
	{
		if(response)
		{
			new fid = pData[playerid][pFarm];
			if(fid == -1) return Error(playerid, "You don't have farm.");
			if(response)
			{
				switch (listitem)
				{
					case 0:
					{
						if(pData[playerid][pFarmRank] < 5)
							return Error(playerid, "Only boss can withdraw orange!");

						new str[128];
						format(str, sizeof(str), "Orange Balance: %d\n\nPlease enter how much orange you wish to withdraw from the safe:", farmData[fid][farmOrange]);
						ShowPlayerDialog(playerid, FARM_WITHDRAWORANGE, DIALOG_STYLE_INPUT, "Withdraw from safe", str, "Withdraw", "Back");
					}
					case 1:
					{
						new str[128];
						format(str, sizeof(str), "Orange Balance: %d\n\nPlease enter how much orange you wish to deposit into the safe:", farmData[fid][farmOrange]);
						ShowPlayerDialog(playerid, FARM_DEPOSITORANGE, DIALOG_STYLE_INPUT, "Deposit into safe", str, "Deposit", "Back");
					}
				}
			}
			else callcmd::fstorage(playerid);
		}
		return 1;
	}
	if(dialogid == FARM_WITHDRAWORANGE)
	{
		new fid = pData[playerid][pFarm];
		if(fid == -1) return Error(playerid, "You don't have farm.");

		if(response)
		{
			new amount = strval(inputtext);

			if(isnull(inputtext))
			{
				new str[128];
				format(str, sizeof(str), "Orange Balance: %d\n\nPlease enter how much orange you wish to withdraw from the safe:", farmData[fid][farmOrange]);
				ShowPlayerDialog(playerid, FARM_WITHDRAWORANGE, DIALOG_STYLE_INPUT, "Withdraw from safe", str, "Withdraw", "Back");
				return 1;
			}
			if(amount < 1 || amount > farmData[fid][farmOrange])
			{
				new str[128];
				format(str, sizeof(str), "Error: Insufficient funds.\n\nOrange Balance: %d\n\nPlease enter how much orange you wish to withdraw from the safe:", farmData[fid][farmOrange]);
				ShowPlayerDialog(playerid, FARM_WITHDRAWORANGE, DIALOG_STYLE_INPUT, "Withdraw from safe", str, "Withdraw", "Back");
				return 1;
			}
			farmData[fid][farmOrange] -= amount;
			pData[playerid][pOrange] += amount;

			SaveFarm(fid);
			SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s has withdrawn %d orange from their farm safe.", ReturnName(playerid), amount);
			callcmd::fsafe(playerid);
			return 1;
		}
		else callcmd::fstorage(playerid);
		return 1;
	}
	if(dialogid == FARM_DEPOSITORANGE)
	{
		new fid = pData[playerid][pFarm];
		if(fid == -1) return Error(playerid, "You don't have farm.");
		if(response)
		{
			new amount = strval(inputtext);

			if(isnull(inputtext))
			{
				new str[128];
				format(str, sizeof(str), "Orange Balance: %d\n\nPlease enter how much orange you wish to deposit into the safe:", farmData[fid][farmOrange]);
				ShowPlayerDialog(playerid, FARM_DEPOSITORANGE, DIALOG_STYLE_INPUT, "Deposit into safe", str, "Deposit", "Back");
				return 1;
			}
			if(amount < 1 || amount > pData[playerid][pOrange])
			{
				new str[128];
				format(str, sizeof(str), "Error: Insufficient funds.\n\nOrange Balance: %d\n\nPlease enter how much orange you wish to deposit into the safe:", farmData[fid][farmOrange]);
				ShowPlayerDialog(playerid, FARM_DEPOSITORANGE, DIALOG_STYLE_INPUT, "Deposit into safe", str, "Deposit", "Back");
				return 1;
			}
			farmData[fid][farmOrange] += amount;
			pData[playerid][pOrange] -= amount;

			SaveFarm(fid);
			SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s has deposited %d orange into their farm safe.", ReturnName(playerid), amount);
		}
		else callcmd::fstorage(playerid);
		return 1;
	}
	if(dialogid == FARM_MONEY)
	{
		if(response)
		{
			new fid = pData[playerid][pFarm];
			if(fid == -1) return Error(playerid, "You don't have farm.");
			if(response)
			{
				switch (listitem)
				{
					case 0:
					{
						if(pData[playerid][pFarmRank] < 5)
							return Error(playerid, "Only boss can withdraw money!");

						new str[128];
						format(str, sizeof(str), "Money Balance: %s\n\nPlease enter how much money you wish to withdraw from the safe:", FormatMoney(farmData[fid][farmMoney]));
						ShowPlayerDialog(playerid, FARM_WITHDRAWMONEY, DIALOG_STYLE_INPUT, "Withdraw from safe", str, "Withdraw", "Back");
					}
					case 1:
					{
						new str[128];
						format(str, sizeof(str), "Money Balance: %s\n\nPlease enter how much money you wish to deposit into the safe:", FormatMoney(farmData[fid][farmMoney]));
						ShowPlayerDialog(playerid, FARM_DEPOSITMONEY, DIALOG_STYLE_INPUT, "Deposit into safe", str, "Deposit", "Back");
					}
				}
			}
			else callcmd::fstorage(playerid);
		}
		return 1;
	}
	if(dialogid == FARM_WITHDRAWMONEY)
	{
		new fid = pData[playerid][pFarm];
		if(fid == -1) return Error(playerid, "You don't have farm.");

		if(response)
		{
			new amount = strval(inputtext);

			if(isnull(inputtext))
			{
				new str[128];
				format(str, sizeof(str), "Money Balance: %s\n\nPlease enter how much money you wish to withdraw from the safe:", FormatMoney(farmData[fid][farmMoney]));
				ShowPlayerDialog(playerid, FARM_WITHDRAWMONEY, DIALOG_STYLE_INPUT, "Withdraw from safe", str, "Withdraw", "Back");
				return 1;
			}
			if(amount < 1 || amount > farmData[fid][farmMoney])
			{
				new str[128];
				format(str, sizeof(str), "Error: Insufficient funds.\n\nMoney Balance: %s\n\nPlease enter how much money you wish to withdraw from the safe:", FormatMoney(farmData[fid][farmMoney]));
				ShowPlayerDialog(playerid, FARM_WITHDRAWMONEY, DIALOG_STYLE_INPUT, "Withdraw from safe", str, "Withdraw", "Back");
				return 1;
			}
			farmData[fid][farmMoney] -= amount;
			GivePlayerMoneyEx(playerid, amount);

			SaveFarm(fid);
			SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s has withdrawn %s money from their farm safe.", ReturnName(playerid), FormatMoney(amount));
			callcmd::fsafe(playerid);
			return 1;
		}
		else callcmd::fstorage(playerid);
		return 1;
	}
	if(dialogid == FARM_DEPOSITMONEY)
	{
		new fid = pData[playerid][pFarm];
		if(fid == -1) return Error(playerid, "You don't have farm.");
		if(response)
		{
			new amount = strval(inputtext);

			if(isnull(inputtext))
			{
				new str[128];
				format(str, sizeof(str), "Money Balance: %s\n\nPlease enter how much money you wish to deposit into the safe:", FormatMoney(farmData[fid][farmMoney]));
				ShowPlayerDialog(playerid, FARM_DEPOSITORANGE, DIALOG_STYLE_INPUT, "Deposit into safe", str, "Deposit", "Back");
				return 1;
			}
			if(amount < 1 || amount > GetPlayerMoney(playerid))
			{
				new str[128];
				format(str, sizeof(str), "Error: Insufficient funds.\n\nMoney Balance: %s\n\nPlease enter how much money you wish to deposit into the safe:", FormatMoney(farmData[fid][farmMoney]));
				ShowPlayerDialog(playerid, FARM_DEPOSITORANGE, DIALOG_STYLE_INPUT, "Deposit into safe", str, "Deposit", "Back");
				return 1;
			}
			farmData[fid][farmMoney] += amount;
			GivePlayerMoneyEx(playerid, -amount);

			SaveFarm(fid);
			SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s has deposited %s money into their farm safe.", ReturnName(playerid), FormatMoney(amount));
		}
		else callcmd::fstorage(playerid);
		return 1;
	}
	//------------[ VIP Locker Dialog ]----------
	if(dialogid == DIALOG_LOCKERVIP)
	{
		if(response)
		{
			switch (listitem)
			{
				case 0:
				{
					SetPlayerHealthEx(playerid, 100);
				}
				case 1:
				{
					GivePlayerWeaponEx(playerid, 1, 1);
					GivePlayerWeaponEx(playerid, 7, 1);
					GivePlayerWeaponEx(playerid, 15, 1);
				}
				case 2:
				{
					switch (pData[playerid][pGender])
					{
						case 1: ShowModelSelectionMenu(playerid, VIPMaleSkins, "Choose your skin");
						case 2: ShowModelSelectionMenu(playerid, VIPFemaleSkins, "Choose your skin");
					}
				}
				case 3:
				{
					new string[248];
					if(pToys[playerid][0][toy_model] == 0)
					{
						strcat(string, ""dot"Slot 1\n");
					}
					else strcat(string, ""dot"Slot 1 "RED_E"(Used)\n");

					if(pToys[playerid][1][toy_model] == 0)
					{
						strcat(string, ""dot"Slot 2\n");
					}
					else strcat(string, ""dot"Slot 2 "RED_E"(Used)\n");

					if(pToys[playerid][2][toy_model] == 0)
					{
						strcat(string, ""dot"Slot 3\n");
					}
					else strcat(string, ""dot"Slot 3 "RED_E"(Used)\n");

					if(pToys[playerid][3][toy_model] == 0)
					{
						strcat(string, ""dot"Slot 4\n");
					}
					else strcat(string, ""dot"Slot 4 "RED_E"(Used)\n");

					/*if(pToys[playerid][4][toy_model] == 0)
					{
						strcat(string, ""dot"Slot 5\n");
					}
					else strcat(string, ""dot"Slot 5 "RED_E"(Used)\n");

					if(pToys[playerid][5][toy_model] == 0)
					{
						strcat(string, ""dot"Slot 6\n");
					}
					else strcat(string, ""dot"Slot 6 "RED_E"(Used)\n");*/

					ShowPlayerDialog(playerid, DIALOG_TOYVIP, DIALOG_STYLE_LIST, ""RED_E"Capitaliz Roleplay "WHITE_E"VIP Toys", string, "Select", "Cancel");
				}
			}
		}
	}
	//-------------[ Faction Commands Dialog ]-----------
	if(dialogid == DIALOG_LOCKERSAPD)
	{
		if(response)
		{
			switch (listitem)
			{
				case 0:
				{
					if(pData[playerid][pOnDuty] == 1)
					{
						pData[playerid][pOnDuty] = 0;
						SetPlayerColor(playerid, COLOR_WHITE);
						SetPlayerSkin(playerid, pData[playerid][pSkin]);
						SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "* %s places their badge and gun in their locker.", ReturnName(playerid));
						ResetWeapon(playerid, 25);
						ResetWeapon(playerid, 27);
						ResetWeapon(playerid, 29);
						ResetWeapon(playerid, 31);
						ResetWeapon(playerid, 33);
						ResetWeapon(playerid, 34);
					}
					else
					{
						pData[playerid][pOnDuty] = 1;
						SetFactionColor(playerid);
						if(pData[playerid][pGender] == 1)
						{
							SetPlayerSkin(playerid, 300);
							pData[playerid][pFacSkin] = 300;
						}
						else
						{
							SetPlayerSkin(playerid, 306);
							pData[playerid][pFacSkin] = 306;
						}
						SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "* %s withdraws their badge and on duty from their locker", ReturnName(playerid));
					}
				}
				case 1:
				{
					SetPlayerHealthEx(playerid, 100);
					SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "* %s telah mengambil medical kit dari locker", ReturnName(playerid));
				}
				case 2:
				{
					SetPlayerArmourEx(playerid, 97);
					SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "* %s telah mengambil armour pelindung dari locker", ReturnName(playerid));
				}
				case 3:
				{
					if(pData[playerid][pOnDuty] <= 0)
						return Error(playerid, "Kamu harus On duty untuk mengambil barang!");

					ShowPlayerDialog(playerid, DIALOG_WEAPONSAPD, DIALOG_STYLE_LIST, "SAPD Weapons", "SPRAYCAN\nPARACHUTE\nNITE STICK\nKNIFE\nCOLT45\nSILENCED\nDEAGLE\nSHOTGUN\nSHOTGSPA\nMP5\nM4\nRIFLE\nSNIPER", "Pilih", "Batal");
				}
				case 4:
				{
					if(pData[playerid][pOnDuty] <= 0)
						return Error(playerid, "Kamu harus On duty untuk mengambil barang!");

					switch (pData[playerid][pGender])
					{
						case 1: ShowPlayerSelectionMenu(playerid, SAPD_SKIN_MALE, "Choose Your Skin", SAPDSkinMale, sizeof(SAPDSkinMale));
						case 2: ShowPlayerSelectionMenu(playerid, SAPD_SKIN_FEMALE, "Choose Your Skin", SAPDSkinFemale, sizeof(SAPDSkinFemale));
					}
				}
				case 5:
				{
					if(pData[playerid][pOnDuty] <= 0)
						return Error(playerid, "Kamu harus On duty untuk mengambil barang!");
					if(pData[playerid][pFactionRank] < 3)
						return Error(playerid, "You are not allowed!");

					switch (pData[playerid][pGender])
					{
						case 1: ShowPlayerSelectionMenu(playerid, SAPD_SKIN_WAR, "Choose Your Skin", SAPDSkinWar, sizeof(SAPDSkinWar));
						case 2: ShowPlayerSelectionMenu(playerid, SAPD_SKIN_FEMALE, "Choose Your Skin", SAPDSkinFemale, sizeof(SAPDSkinFemale));
					}
				}
			}
		}
		return 1;
	}
	if(dialogid == DIALOG_WEAPONSAPD)
	{
		if(response)
		{
			switch (listitem)
			{
				case 0:
				{
					GivePlayerWeaponEx(playerid, 41, 200);
					SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s reaches inside the locker and equips a %s.", ReturnName(playerid), ReturnWeaponName(41));
				}
				case 1:
				{
					GivePlayerWeaponEx(playerid, 46, 1);
					SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s reaches inside the locker and equips a %s.", ReturnName(playerid), ReturnWeaponName(46));
				}
				case 2:
				{
					GivePlayerWeaponEx(playerid, 3, 200);
					SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s reaches inside the locker and equips a %s.", ReturnName(playerid), ReturnWeaponName(3));
				}
				case 3:
				{
					GivePlayerWeaponEx(playerid, 4, 200);
					SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s reaches inside the locker and equips a %s.", ReturnName(playerid), ReturnWeaponName(4));
				}
				case 4:
				{
					GivePlayerWeaponEx(playerid, 22, 200);
					SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s reaches inside the locker and equips a %s.", ReturnName(playerid), ReturnWeaponName(22));
				}
				case 5:
				{
					if(pData[playerid][pFactionRank] < 1)
						return Error(playerid, "You are not allowed!");

					GivePlayerWeaponEx(playerid, 23, 200);
					SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s reaches inside the locker and equips a %s.", ReturnName(playerid), ReturnWeaponName(23));
				}
				case 6:
				{
					if(pData[playerid][pFactionRank] < 1)
						return Error(playerid, "You are not allowed!");

					GivePlayerWeaponEx(playerid, 24, 200);
					SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s reaches inside the locker and equips a %s.", ReturnName(playerid), ReturnWeaponName(24));
				}
				case 7:
				{
					if(pData[playerid][pFactionRank] < 1)
						return Error(playerid, "You are not allowed!");
					GivePlayerWeaponEx(playerid, 25, 200);
					SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s reaches inside the locker and equips a %s.", ReturnName(playerid), ReturnWeaponName(25));
				}
				case 8:
				{
					if(pData[playerid][pFactionRank] < 1)
						return Error(playerid, "You are not allowed!");
					GivePlayerWeaponEx(playerid, 27, 200);
					SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s reaches inside the locker and equips a %s.", ReturnName(playerid), ReturnWeaponName(27));
				}
				case 9:
				{
					if(pData[playerid][pFactionRank] < 1)
						return Error(playerid, "You are not allowed!");
					GivePlayerWeaponEx(playerid, 29, 200);
					SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s reaches inside the locker and equips a %s.", ReturnName(playerid), ReturnWeaponName(29));
				}
				case 10:
				{
					if(pData[playerid][pFactionRank] < 1)
						return Error(playerid, "You are not allowed!");
					GivePlayerWeaponEx(playerid, 31, 200);
					SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s reaches inside the locker and equips a %s.", ReturnName(playerid), ReturnWeaponName(31));
				}
				case 11:
				{
					if(pData[playerid][pFactionRank] < 1)
						return Error(playerid, "You are not allowed!");
					GivePlayerWeaponEx(playerid, 33, 200);
					SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s reaches inside the locker and equips a %s.", ReturnName(playerid), ReturnWeaponName(33));
				}
				case 12:
				{
					if(pData[playerid][pFactionRank] < 1)
						return Error(playerid, "You are not allowed!");
					GivePlayerWeaponEx(playerid, 34, 200);
					SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s reaches inside the locker and equips a %s.", ReturnName(playerid), ReturnWeaponName(34));
				}
			}
		}
		return 1;
	}
	if(dialogid == DIALOG_LOCKERSAGS)
	{
		if(response)
		{
			switch (listitem)
			{
				case 0:
				{
					if(pData[playerid][pOnDuty] == 1)
					{
						pData[playerid][pOnDuty] = 0;
						SetPlayerColor(playerid, COLOR_WHITE);
						SetPlayerSkin(playerid, pData[playerid][pSkin]);
						SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "* %s places their badge and gun in their locker.", ReturnName(playerid));
					}
					else
					{
						pData[playerid][pOnDuty] = 1;
						SetFactionColor(playerid);
						if(pData[playerid][pGender] == 1)
						{
							SetPlayerSkin(playerid, 295);
							pData[playerid][pFacSkin] = 295;
						}
						else
						{
							SetPlayerSkin(playerid, 141);
							pData[playerid][pFacSkin] = 141;
						}
						SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "* %s withdraws their badge and on duty from their locker", ReturnName(playerid));
					}
				}
				case 1:
				{
					SetPlayerHealthEx(playerid, 100);
					SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "* %s telah mengambil medical kit dari locker", ReturnName(playerid));
				}
				case 2:
				{
					SetPlayerArmourEx(playerid, 97);
					SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "* %s telah mengambil armour pelindung dari locker", ReturnName(playerid));
				}
				case 3:
				{
					if(pData[playerid][pOnDuty] <= 0)
						return Error(playerid, "Kamu harus On duty untuk mengambil barang!");

					ShowPlayerDialog(playerid, DIALOG_WEAPONSAGS, DIALOG_STYLE_LIST, "SAGS Weapons", "SPRAYCAN\nPARACHUTE\nNITE STICK\nKNIFE\nCOLT45\nSILENCED\nDEAGLE\nMP5", "Pilih", "Batal");
				}
				case 4:
				{
					if(pData[playerid][pOnDuty] <= 0)
						return Error(playerid, "Kamu harus On duty untuk mengambil barang!");
					switch (pData[playerid][pGender])
					{
						case 1: ShowPlayerSelectionMenu(playerid, SAGS_SKIN_MALE, "Choose Your Skin", SAGSSkinMale, sizeof(SAGSSkinMale));
						case 2: ShowPlayerSelectionMenu(playerid, SAGS_SKIN_FEMALE, "Choose Your Skin", SAGSSkinFemale, sizeof(SAGSSkinFemale));
					}
				}
			}
		}
		return 1;
	}
	if(dialogid == DIALOG_WEAPONSAGS)
	{
		if(response)
		{
			switch (listitem)
			{
				case 0:
				{
					GivePlayerWeaponEx(playerid, 41, 200);
					SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s reaches inside the locker and equips a %s.", ReturnName(playerid), ReturnWeaponName(41));
				}
				case 1:
				{
					GivePlayerWeaponEx(playerid, 46, 1);
					SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s reaches inside the locker and equips a %s.", ReturnName(playerid), ReturnWeaponName(46));
				}
				case 2:
				{
					GivePlayerWeaponEx(playerid, 3, 200);
					SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s reaches inside the locker and equips a %s.", ReturnName(playerid), ReturnWeaponName(3));
				}
				case 3:
				{
					GivePlayerWeaponEx(playerid, 4, 200);
					SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s reaches inside the locker and equips a %s.", ReturnName(playerid), ReturnWeaponName(4));
				}
				case 4:
				{
					GivePlayerWeaponEx(playerid, 22, 200);
					SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s reaches inside the locker and equips a %s.", ReturnName(playerid), ReturnWeaponName(22));
				}
				case 5:
				{
					if(pData[playerid][pFactionRank] < 2)
						return Error(playerid, "You are not allowed!");

					GivePlayerWeaponEx(playerid, 23, 200);
					SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s reaches inside the locker and equips a %s.", ReturnName(playerid), ReturnWeaponName(23));
				}
				case 6:
				{
					if(pData[playerid][pFactionRank] < 3)
						return Error(playerid, "You are not allowed!");

					GivePlayerWeaponEx(playerid, 24, 200);
					SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s reaches inside the locker and equips a %s.", ReturnName(playerid), ReturnWeaponName(24));
				}
				case 7:
				{
					if(pData[playerid][pFactionRank] < 4)
						return Error(playerid, "You are not allowed!");
					GivePlayerWeaponEx(playerid, 29, 200);
					SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s reaches inside the locker and equips a %s.", ReturnName(playerid), ReturnWeaponName(29));
				}
			}
		}
		return 1;
	}
	if(dialogid == DIALOG_LOCKERSAMD)
	{
		if(response)
		{
			switch (listitem)
			{
				case 0:
				{
					if(pData[playerid][pOnDuty] == 1)
					{
						pData[playerid][pOnDuty] = 0;
						SetPlayerColor(playerid, COLOR_WHITE);
						SetPlayerSkin(playerid, pData[playerid][pSkin]);
						SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "* %s places their badge and gun in their locker.", ReturnName(playerid));
					}
					else
					{
						pData[playerid][pOnDuty] = 1;
						SetFactionColor(playerid);
						if(pData[playerid][pGender] == 1)
						{
							SetPlayerSkin(playerid, 276);
							pData[playerid][pFacSkin] = 276;
						}
						else
						{
							SetPlayerSkin(playerid, 308);
							pData[playerid][pFacSkin] = 308;
						}
						SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "* %s withdraws their badge and on duty from their locker", ReturnName(playerid));
					}
				}
				case 1:
				{
					SetPlayerHealthEx(playerid, 100);
					SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "* %s telah mengambil medical kit dari locker", ReturnName(playerid));
				}
				case 2:
				{
					SetPlayerArmourEx(playerid, 97);
					SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "* %s telah mengambil armour pelindung dari locker", ReturnName(playerid));
				}
				case 3:
				{
					if(pData[playerid][pOnDuty] <= 0)
						return Error(playerid, "Kamu harus On duty untuk mengambil barang!");

					ShowPlayerDialog(playerid, DIALOG_WEAPONSAMD, DIALOG_STYLE_LIST, "SAMD Weapons", "FIREEXTINGUISHER\nSPRAYCAN\nPARACHUTE\nNITE STICK\nKNIFE\nCOLT45\nSILENCED\nDEAGLE", "Pilih", "Batal");
				}
				case 4:
				{
					if(pData[playerid][pOnDuty] <= 0)
						return Error(playerid, "Kamu harus On duty untuk mengambil barang!");
					switch (pData[playerid][pGender])
					{
						case 1: ShowPlayerSelectionMenu(playerid, SAMD_SKIN_MALE, "Choose Your Skin", SAMDSkinMale, sizeof(SAMDSkinMale));
						case 2: ShowPlayerSelectionMenu(playerid, SAMD_SKIN_FEMALE, "Choose Your Skin", SAMDSkinFemale, sizeof(SAMDSkinFemale));
					}
				}
			}
		}
		return 1;
	}
	if(dialogid == DIALOG_WEAPONSAMD)
	{
		if(response)
		{
			switch (listitem)
			{
				case 0:
				{
					GivePlayerWeaponEx(playerid, 42, 200);
					SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s reaches inside the locker and equips a %s.", ReturnName(playerid), ReturnWeaponName(42));
				}
				case 1:
				{
					GivePlayerWeaponEx(playerid, 41, 200);
					SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s reaches inside the locker and equips a %s.", ReturnName(playerid), ReturnWeaponName(41));
				}
				case 2:
				{
					GivePlayerWeaponEx(playerid, 46, 1);
					SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s reaches inside the locker and equips a %s.", ReturnName(playerid), ReturnWeaponName(46));
				}
				case 3:
				{
					//GivePlayerWeaponEx(playerid, 3, 200);
					//SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s reaches inside the locker and equips a %s.", ReturnName(playerid), ReturnWeaponName(3));
				}
				case 4:
				{
					//GivePlayerWeaponEx(playerid, 4, 200);
					//SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s reaches inside the locker and equips a %s.", ReturnName(playerid), ReturnWeaponName(4));
				}
				case 5:
				{
					if(pData[playerid][pFactionRank] < 3)
						return Error(playerid, "You are not allowed!");

					//GivePlayerWeaponEx(playerid, 22, 200);
					//SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s reaches inside the locker and equips a %s.", ReturnName(playerid), ReturnWeaponName(22));
				}
				case 6:
				{
					if(pData[playerid][pFactionRank] < 3)
						return Error(playerid, "You are not allowed!");

					//GivePlayerWeaponEx(playerid, 23, 200);
					//SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s reaches inside the locker and equips a %s.", ReturnName(playerid), ReturnWeaponName(23));
				}
				case 7:
				{
					if(pData[playerid][pFactionRank] < 3)
						return Error(playerid, "You are not allowed!");

					//GivePlayerWeaponEx(playerid, 24, 200);
					//SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s reaches inside the locker and equips a %s.", ReturnName(playerid), ReturnWeaponName(24));
				}
			}
		}
		return 1;
	}
	if(dialogid == DIALOG_LOCKERSANEW)
	{
		if(response)
		{
			switch (listitem)
			{
				case 0:
				{
					if(pData[playerid][pOnDuty] == 1)
					{
						pData[playerid][pOnDuty] = 0;
						SetPlayerColor(playerid, COLOR_WHITE);
						SetPlayerSkin(playerid, pData[playerid][pSkin]);
						SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "* %s places their badge and gun in their locker.", ReturnName(playerid));
					}
					else
					{
						pData[playerid][pOnDuty] = 1;
						SetFactionColor(playerid);
						if(pData[playerid][pGender] == 1)
						{
							SetPlayerSkin(playerid, 189);
							pData[playerid][pFacSkin] = 189;
						}
						else
						{
							SetPlayerSkin(playerid, 150); //194
							pData[playerid][pFacSkin] = 150; //194
						}
						SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "* %s withdraws their badge and on duty from their locker", ReturnName(playerid));
					}
				}
				case 1:
				{
					SetPlayerHealthEx(playerid, 100);
					SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "* %s telah mengambil medical kit dari locker", ReturnName(playerid));
				}
				case 2:
				{
					SetPlayerArmourEx(playerid, 97);
					SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "* %s telah mengambil armour pelindung dari locker", ReturnName(playerid));
				}
				case 3:
				{
					if(pData[playerid][pOnDuty] <= 0)
						return Error(playerid, "Kamu harus On duty untuk mengambil barang!");

					ShowPlayerDialog(playerid, DIALOG_WEAPONSANEW, DIALOG_STYLE_LIST, "SAPD Weapons", "CAMERA\nSPRAYCAN\nPARACHUTE\nNITE STICK\nKNIFE\nCOLT45", "Pilih", "Batal");
				}
				case 4:
				{
					if(pData[playerid][pOnDuty] <= 0)
						return Error(playerid, "Kamu harus On duty untuk mengambil barang!");
					switch (pData[playerid][pGender])
					{
						case 1: ShowPlayerSelectionMenu(playerid, SANA_SKIN_MALE, "Choose Your Skin", SANASkinMale, sizeof(SANASkinMale));
						case 2: ShowPlayerSelectionMenu(playerid, SANA_SKIN_FEMALE, "Choose Your Skin", SANASkinFemale, sizeof(SANASkinFemale));
					}
				}
			}
		}
		return 1;
	}
	if(dialogid == DIALOG_LOCKERGOJEK)
	{
		if(response)
		{
			switch (listitem)
			{
				case 0:
				{
					if(pData[playerid][pOnDuty] == 1)
					{
						pData[playerid][pOnDuty] = 0;
						SetPlayerColor(playerid, COLOR_WHITE);
						SetPlayerSkin(playerid, pData[playerid][pSkin]);
						SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "* %s places their badge and gun in their locker.", ReturnName(playerid));
					}
					else
					{
						pData[playerid][pOnDuty] = 1;
						SetFactionColor(playerid);
						if(pData[playerid][pGender] == 1)
						{
							SetPlayerSkin(playerid, 189);
							pData[playerid][pFacSkin] = 189;
						}
						else
						{
							SetPlayerSkin(playerid, 150); //194
							pData[playerid][pFacSkin] = 150; //194
						}
						SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "* %s withdraws their badge and on duty from their locker", ReturnName(playerid));
					}
				}
				case 1:
				{
					SetPlayerHealthEx(playerid, 100);
					SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "* %s telah mengambil medical kit dari locker", ReturnName(playerid));
				}
				case 2:
				{
					SetPlayerArmourEx(playerid, 97);
					SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "* %s telah mengambil armour pelindung dari locker", ReturnName(playerid));
				}
				case 3:
				{
					if(pData[playerid][pOnDuty] <= 0)
						return Error(playerid, "Kamu harus On duty untuk mengambil barang!");
					switch (pData[playerid][pGender])
					{
						case 1: ShowModelSelectionMenu(playerid, GOJEKMale, "Choose your skin");
						case 2: ShowModelSelectionMenu(playerid, GOJEKFemale, "Choose your skin");
					}
				}
			}
		}
		return 1;
	}
	if(dialogid == DIALOG_LOCKERPEDAGANG)
	{
		if(response)
		{
			switch (listitem)
			{
				case 0:
				{
					if(pData[playerid][pOnDuty] == 1)
					{
						pData[playerid][pOnDuty] = 0;
						SetPlayerColor(playerid, COLOR_WHITE);
						SetPlayerSkin(playerid, pData[playerid][pSkin]);
						SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "* %s places their badge and gun in their locker.", ReturnName(playerid));
					}
					else
					{
						pData[playerid][pOnDuty] = 1;
						SetFactionColor(playerid);
						if(pData[playerid][pGender] == 1)
						{
							SetPlayerSkin(playerid, 189);
							pData[playerid][pFacSkin] = 189;
						}
						else
						{
							SetPlayerSkin(playerid, 150); //194
							pData[playerid][pFacSkin] = 150; //194
						}
						SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "* %s withdraws their badge and on duty from their locker", ReturnName(playerid));
					}
				}
				case 1:
				{
					SetPlayerHealthEx(playerid, 100);
					SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "* %s telah mengambil medical kit dari locker", ReturnName(playerid));
				}
				case 2:
				{
					SetPlayerArmourEx(playerid, 97);
					SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "* %s telah mengambil armour pelindung dari locker", ReturnName(playerid));
				}
				case 3:
				{
					if(pData[playerid][pOnDuty] <= 0)
						return Error(playerid, "Kamu harus On duty untuk mengambil barang!");
					switch (pData[playerid][pGender])
					{
						case 1: ShowModelSelectionMenu(playerid, PEDAGANGMale, "Choose your skin");
						case 2: ShowModelSelectionMenu(playerid, PEDAGANGFemale, "Choose your skin");
					}
				}
			}
		}
		return 1;
	}
	if(dialogid == DIALOG_MECH_LEVEL)
	{
	    if(response)
	    {
			ShowPlayerDialog
			(
				playerid, -1, DIALOG_STYLE_MSGBOX,
				"Mechanic Skill Info",
				"{FFDC33}[LEVEL 0]\n{ffffff}Fix Engine\n\n"\
				"{FFDC33}[LEVEL 1]\n{ffffff}Fix Body-Spray-PaintJob\n\n"\
				"{FFDC33}[LEVEL 2]\n{ffffff}Wheels-Spoiler-Hoods-Vents\n\n"\
				"{FFDC33}[LEVEL 3]\n{ffffff}Lights-Exhausts-FrontBumper-RearBumper\n\n"\
				"{FFDC33}[LEVEL 4]\n{ffffff}Roofs-Sideskirts-Bullbars-Stereo\n\n"\
				"{FFDC33}[LEVEL 5]\n{ffffff}Hydraulics-Nitro(1-3)-Neon\n\n"\
				"Info : Level Akan Naik Jika Exp Mencapai Level Tertentu",
				"Ok", ""
			);
	    }
	}
	if(dialogid == TRAININGSKILL)
  	{
  		new String[512];
      	if(!response) return 1;
    	if(response)
    	{
        	if(listitem == 0)
        	{
            	if(pData[playerid][pSilincedSkill] < 10)
            	{
          			if(GetPlayerCash(playerid) >= 1500*pData[playerid][pSilincedSkill])
              		{
                  		if(pData[playerid][pFaction] != 0)
                  		{
                  			pData[playerid][pTrainingTime] = 15*60;
                  			format(String, sizeof(String), "SKILL: Sekarang skill Silinced Pistol anda sudah memasuki Level %d", pData[playerid][pSilincedSkill]);
                  			SendClientMessage(playerid, COLOR_GREYJG, String);
                  			format(String, sizeof(String), "SKILL: Anda harus menunggu %d Menit untuk melakukan latihan lagi", pData[playerid][pTrainingTime]/60);
                  			SendClientMessage(playerid, COLOR_GREYJG, String);
                  			GivePlayerMoneyEx(playerid, -1500*pData[playerid][pSilincedSkill]/2);
                  			Tax += 1500*pData[playerid][pSilincedSkill]/2;
                  			pData[playerid][pSilincedSkill] ++;
                  			SetPlayerSkillLevel(playerid, WEAPONSKILL_PISTOL_SILENCED, pData[playerid][pSilincedSkill] * 100);
                  		}
                  		else
                  		{
                  			pData[playerid][pTrainingTime] = 25*60;
                  			format(String, sizeof(String), "SKILL: Sekarang skill Silinced Pistol anda sudah memasuki Level %d", pData[playerid][pSilincedSkill]);
                  			SendClientMessage(playerid, COLOR_GREYJG, String);
                  			format(String, sizeof(String), "SKILL: Anda harus menunggu %d Menit untuk melakukan latihan lagi", pData[playerid][pTrainingTime]/60);
                  			SendClientMessage(playerid, COLOR_GREYJG, String);
                  			GivePlayerMoneyEx(playerid, -1500*pData[playerid][pSilincedSkill]);
                  			Tax += 1500*pData[playerid][pSilincedSkill];
                  			pData[playerid][pSilincedSkill] ++;
                  			SetPlayerSkillLevel(playerid, WEAPONSKILL_PISTOL_SILENCED, pData[playerid][pSilincedSkill] * 100);
                		}
              		}
              		else Error(playerid, "Kamu tidak mempunyai uang yang cukup untuk melakukan latihan");
        		}
            	else SendClientMessage(playerid, COLOR_GREYJG, "SKILL: Skill anda sudah mencapai level Max");
            	return 1;
      		}
      		if(listitem == 1)
      		{
	        	if(pData[playerid][pDesertEagleSkill] < 10)
	        	{
	          		if(GetPlayerCash(playerid) >= 5000*pData[playerid][pDesertEagleSkill])
	              	{
	                  	if(pData[playerid][pFaction] != 0)
	                  	{
	                  		pData[playerid][pTrainingTime] = 15*60;
	                  		format(String, sizeof(String), "SKILL: Sekarang skill Desert Eagle Pistol anda sudah memasuki Level %d", pData[playerid][pDesertEagleSkill]);
	                  		SendClientMessage(playerid, COLOR_GREYJG, String);
	                  		format(String, sizeof(String), "SKILL: Anda harus menunggu %d Menit untuk melakukan latihan lagi", pData[playerid][pTrainingTime]/60);
	                  		SendClientMessage(playerid, COLOR_GREYJG, String);
	                  		GivePlayerMoneyEx(playerid, -5000*pData[playerid][pDesertEagleSkill]/2);
	                  		Tax += 5000*pData[playerid][pDesertEagleSkill]/2;
	                  		pData[playerid][pDesertEagleSkill] ++;
	                  		SetPlayerSkillLevel(playerid, WEAPONSKILL_DESERT_EAGLE, pData[playerid][pDesertEagleSkill]* 100);
	                  	}
	                  	else
	                  	{
	                  		pData[playerid][pTrainingTime] = 25*60;
	                  		format(String, sizeof(String), "SKILL: Sekarang skill Desert Eagle Pistol anda sudah memasuki Level %d", pData[playerid][pDesertEagleSkill]);
	                  		SendClientMessage(playerid, COLOR_GREYJG, String);
	                  		format(String, sizeof(String), "SKILL: Anda harus menunggu %d Menit untuk melakukan latihan lagi", pData[playerid][pTrainingTime]/60);
	                  		SendClientMessage(playerid, COLOR_GREYJG, String);
	                  		GivePlayerMoneyEx(playerid, -5000*pData[playerid][pDesertEagleSkill]);
	                  		Tax += 5000*pData[playerid][pDesertEagleSkill];
	                  		pData[playerid][pDesertEagleSkill] ++;
	                  		SetPlayerSkillLevel(playerid, WEAPONSKILL_DESERT_EAGLE, pData[playerid][pDesertEagleSkill]* 100);
	            		}
	              	}
	              	else Error(playerid, "Kamu tidak mempunyai uang yang cukup untuk melakukan latihan");
	            }
	            else SendClientMessage(playerid, COLOR_GREYJG, "SKILL: Skill anda sudah mencapai level Max");
	            return 1;
	      	}
	      	if(listitem == 2)
	      	{
	        	if(pData[playerid][pShotgunSkill] < 10)
	        	{
	          		if(GetPlayerCash(playerid) >= 2500*pData[playerid][pShotgunSkill])
	          		{
	              		if(pData[playerid][pFaction] != 0)
	                  	{
	                      	pData[playerid][pTrainingTime] = 15*60;
	                  		format(String, sizeof(String), "SKILL: Sekarang skill Shotgun anda sudah memasuki Level %d", pData[playerid][pShotgunSkill]);
	                  		SendClientMessage(playerid, COLOR_GREYJG, String);
	                  		format(String, sizeof(String), "SKILL: Anda harus menunggu %d Menit untuk melakukan latihan lagi", pData[playerid][pTrainingTime]/60);
	                  		SendClientMessage(playerid, COLOR_GREYJG, String);
	                 	 	GivePlayerMoneyEx(playerid, -2500*pData[playerid][pShotgunSkill]/2);
	                  		Tax += 2500*pData[playerid][pShotgunSkill]/2;
	                  		pData[playerid][pShotgunSkill] ++;
	                  		SetPlayerSkillLevel(playerid, WEAPONSKILL_SHOTGUN, pData[playerid][pShotgunSkill]* 100);
	                  	}
	                  	else
	                  	{
	                		pData[playerid][pTrainingTime] = 25*60;
	                  		format(String, sizeof(String), "SKILL: Sekarang skill Shotgun anda sudah memasuki Level %d", pData[playerid][pShotgunSkill]);
	                  		SendClientMessage(playerid, COLOR_GREYJG, String);
	                  		format(String, sizeof(String), "SKILL: Anda harus menunggu %d Menit untuk melakukan latihan lagi", pData[playerid][pTrainingTime]/60);
	                  		SendClientMessage(playerid, COLOR_GREYJG, String);
	                  		GivePlayerMoneyEx(playerid, -2500*pData[playerid][pShotgunSkill]);
	                  		Tax += 2500*pData[playerid][pShotgunSkill];
	                 		pData[playerid][pShotgunSkill] ++;
	                  		SetPlayerSkillLevel(playerid, WEAPONSKILL_SHOTGUN, pData[playerid][pShotgunSkill]* 100);
	                	}
	          		}
	                else Error(playerid, "Kamu tidak mempunyai uang yang cukup untuk melakukan latihan");
	        	}
	            else SendClientMessage(playerid, COLOR_GREYJG, "SKILL: Skill anda sudah mencapai level Max");
	            return 1;
	      	}
	      	if(listitem == 3)
	      	{
		        if(pData[playerid][pSpassSkill] < 10)
		        {
		         	if(GetPlayerCash(playerid) >= 7500*pData[playerid][pSpassSkill])
		            {
	                  	if(pData[playerid][pFaction] != 0)
	                  	{
	                      	pData[playerid][pTrainingTime] = 15*60;
	                  		format(String, sizeof(String), "SKILL: Sekarang skill Spas-12 anda sudah memasuki Level %d", pData[playerid][pSpassSkill]);
	                  		SendClientMessage(playerid, COLOR_GREYJG, String);
	                  		format(String, sizeof(String), "SKILL: Anda harus menunggu %d Menit untuk melakukan latihan lagi", pData[playerid][pTrainingTime]/60);
	                  		SendClientMessage(playerid, COLOR_GREYJG, String);
	                  		GivePlayerMoneyEx(playerid, -7500*pData[playerid][pSpassSkill]/2);
	                  		Tax += 7500*pData[playerid][pSpassSkill]/2;
	                  		pData[playerid][pSpassSkill] ++;
	                  		SetPlayerSkillLevel(playerid, WEAPONSKILL_SPAS12_SHOTGUN, pData[playerid][pSpassSkill]* 100);
	                  	}
	                  	else
	                  	{
	                  		pData[playerid][pTrainingTime] = 25*60;
	                  		format(String, sizeof(String), "SKILL: Sekarang skill Spas-12 anda sudah memasuki Level %d", pData[playerid][pSpassSkill]);
	                  		SendClientMessage(playerid, COLOR_GREYJG, String);
	                  		format(String, sizeof(String), "SKILL: Anda harus menunggu %d Menit untuk melakukan latihan lagi", pData[playerid][pTrainingTime]/60);
	                  		SendClientMessage(playerid, COLOR_GREYJG, String);
	                  		GivePlayerMoneyEx(playerid, -7500*pData[playerid][pSpassSkill]);
	                  		Tax += 7500*pData[playerid][pSpassSkill];
	                  		pData[playerid][pSpassSkill] ++;
	                  		SetPlayerSkillLevel(playerid, WEAPONSKILL_SPAS12_SHOTGUN, pData[playerid][pSpassSkill]* 100);
	                	}
	              	}
	              	else Error(playerid, "Kamu tidak mempunyai uang yang cukup untuk melakukan latihan");
	        	}
	            else SendClientMessage(playerid, COLOR_GREYJG, "SKILL: Skill anda sudah mencapai level Max");
	            return 1;
	      	}	
	      	if(listitem == 4)
	      	{
	        	if(pData[playerid][pMP5Skill] < 10)
	        	{	
	          		if(GetPlayerCash(playerid) >= 10000*pData[playerid][pMP5Skill])
	              	{
	                  	if(pData[playerid][pFaction] != 0)
	                  	{
	                      	pData[playerid][pTrainingTime] = 15*60;
	                  		format(String, sizeof(String), "SKILL: Sekarang skill MP5 anda sudah memasuki Level %d", pData[playerid][pMP5Skill]);
	                  		SendClientMessage(playerid, COLOR_GREYJG, String);
	                  		format(String, sizeof(String), "SKILL: Anda harus menunggu %d Menit untuk melakukan latihan lagi", pData[playerid][pTrainingTime]/60);
	                  		SendClientMessage(playerid, COLOR_GREYJG, String);
	                  		GivePlayerMoneyEx(playerid, -10000*pData[playerid][pMP5Skill]/2);
	                  		Tax += 10000*pData[playerid][pMP5Skill]/2;
	                  		pData[playerid][pMP5Skill] ++;
	                 		SetPlayerSkillLevel(playerid, WEAPONSKILL_MP5, pData[playerid][pMP5Skill]* 100);
	                  	}
	                  	else
	                  	{
	                  		pData[playerid][pTrainingTime] = 25*60;
	                  		format(String, sizeof(String), "SKILL: Sekarang skill MP5 anda sudah memasuki Level %d", pData[playerid][pMP5Skill]);
	                  		SendClientMessage(playerid, COLOR_GREYJG, String);
	                  		format(String, sizeof(String), "SKILL: Anda harus menunggu %d Menit untuk melakukan latihan lagi", pData[playerid][pTrainingTime]/60);
	                  		SendClientMessage(playerid, COLOR_GREYJG, String);
	                  		GivePlayerMoneyEx(playerid, -10000*pData[playerid][pMP5Skill]);
	                  		Tax += 10000*pData[playerid][pMP5Skill];
	                  		pData[playerid][pMP5Skill] ++;
	                  		SetPlayerSkillLevel(playerid, WEAPONSKILL_MP5, pData[playerid][pMP5Skill]* 100);
	                	}
	              	}
	              	else Error(playerid, "Kamu tidak mempunyai uang yang cukup untuk melakukan latihan");
	        	}
	            else SendClientMessage(playerid, COLOR_GREYJG, "SKILL: Skill anda sudah mencapai level Max");
	            return 1;
	     	}
	      	if(listitem == 5)
	      	{
	        	if(pData[playerid][pAK47Skill] < 10)
	        	{
	          		if(GetPlayerCash(playerid) >= 12500*pData[playerid][pAK47Skill])
	              	{
	                  	if(pData[playerid][pFaction] != 0)
	                  	{
	                      	pData[playerid][pTrainingTime] = 15*60;
	                  		format(String, sizeof(String), "SKILL: Sekarang skill AK47 anda sudah memasuki Level %d", pData[playerid][pAK47Skill]);
	                  		SendClientMessage(playerid, COLOR_GREYJG, String);
	                  		format(String, sizeof(String), "SKILL: Anda harus menunggu %d Menit untuk melakukan latihan lagi", pData[playerid][pTrainingTime]/60);
	                  		SendClientMessage(playerid, COLOR_GREYJG, String);
	                  		GivePlayerMoneyEx(playerid, -12500*pData[playerid][pAK47Skill]/2);
	                  		Tax += 12500*pData[playerid][pAK47Skill]/2;
	                  		pData[playerid][pAK47Skill] ++;
	                  		SetPlayerSkillLevel(playerid, WEAPONSKILL_AK47, pData[playerid][pAK47Skill]* 100);
	                  	}
	                  	else
	                  	{
	                  		pData[playerid][pTrainingTime] = 25*60;
	                  		format(String, sizeof(String), "SKILL: Sekarang skill AK47 anda sudah memasuki Level %d", pData[playerid][pAK47Skill]);
	                  		SendClientMessage(playerid, COLOR_GREYJG, String);
	                  		format(String, sizeof(String), "SKILL: Anda harus menunggu %d Menit untuk melakukan latihan lagi", pData[playerid][pTrainingTime]/60);
	                  		SendClientMessage(playerid, COLOR_GREYJG, String);
	                  		GivePlayerMoneyEx(playerid, -12500*pData[playerid][pAK47Skill]);
	                  		Tax += 12500*pData[playerid][pAK47Skill];
	                  		pData[playerid][pAK47Skill] ++;
	                  		SetPlayerSkillLevel(playerid, WEAPONSKILL_AK47, pData[playerid][pAK47Skill]* 100);
	                	}
	              	}
	              	else Error(playerid, "Kamu tidak mempunyai uang yang cukup untuk melakukan latihan");
	        	}
	            else SendClientMessage(playerid, COLOR_GREYJG, "SKILL: Skill anda sudah mencapai level Max");
	            return 1;
	      	}
	      	if(listitem == 6)
	      	{
	        	if(pData[playerid][pM4Skill] < 10)
	        	{
	          		if(GetPlayerCash(playerid) >= 15000*pData[playerid][pM4Skill])
	              	{
	                  	if(pData[playerid][pFaction] != 0)
	                  	{
	                      	pData[playerid][pTrainingTime] = 15*60;
	                  		format(String, sizeof(String), "SKILL: Sekarang skill M4 anda sudah memasuki Level %d", pData[playerid][pM4Skill]);
	                  		SendClientMessage(playerid, COLOR_GREYJG, String);
	                  		format(String, sizeof(String), "SKILL: Anda harus menunggu %d Menit untuk melakukan latihan lagi", pData[playerid][pTrainingTime]/60);
	                  		SendClientMessage(playerid, COLOR_GREYJG, String);
	                  		GivePlayerMoneyEx(playerid, -15000*pData[playerid][pM4Skill]/2);
	                  		Tax += 15000*pData[playerid][pM4Skill]/2;
	                  		pData[playerid][pM4Skill] ++;
	                  		SetPlayerSkillLevel(playerid, WEAPONSKILL_M4, pData[playerid][pM4Skill]* 100);
	                  	}
	                  	else
	                  	{
	                  		pData[playerid][pTrainingTime] = 25*60;
	                  		format(String, sizeof(String), "SKILL: Sekarang skill M4 anda sudah memasuki Level %d", pData[playerid][pM4Skill]);
	                  		SendClientMessage(playerid, COLOR_GREYJG, String);
	                  		format(String, sizeof(String), "SKILL: Anda harus menunggu %d Menit untuk melakukan latihan lagi", pData[playerid][pTrainingTime]/60);
	                  		SendClientMessage(playerid, COLOR_GREYJG, String);
	                  		GivePlayerMoneyEx(playerid, -15000*pData[playerid][pM4Skill]);
	                  		Tax += 15000*pData[playerid][pM4Skill];
	                  		pData[playerid][pM4Skill] ++;
	                  		SetPlayerSkillLevel(playerid, WEAPONSKILL_M4, pData[playerid][pM4Skill]* 100);
	                	}
	              	}
	              	else Error(playerid, "Kamu tidak mempunyai uang yang cukup untuk melakukan latihan");
	        	}
	            else SendClientMessage(playerid, COLOR_GREYJG, "SKILL: Skill anda sudah mencapai level Max");
	            return 1;
	      	}
	      	if(listitem == 7)
	      	{
	        	if(pData[playerid][pSniperSkill] < 10)
	        	{
	          		if(GetPlayerCash(playerid) >= 16500*pData[playerid][pSniperSkill])
	            	{
	               		if(pData[playerid][pFaction] != 0)
	               		{
	                   		pData[playerid][pTrainingTime] = 15*60;
	                		format(String, sizeof(String), "SKILL: Sekarang skill Sniper Rifle anda sudah memasuki Level %d", pData[playerid][pSniperSkill]);
	                  		SendClientMessage(playerid, COLOR_GREYJG, String);
	                  		format(String, sizeof(String), "SKILL: Anda harus menunggu %d Menit untuk melakukan latihan lagi", pData[playerid][pTrainingTime]/60);
	                  		SendClientMessage(playerid, COLOR_GREYJG, String);
	                  		GivePlayerMoneyEx(playerid, -16500*pData[playerid][pSniperSkill]/2);
	                  		Tax += 16500*pData[playerid][pSniperSkill]/2;
	                  		pData[playerid][pSniperSkill] ++;
	                  		SetPlayerSkillLevel(playerid, WEAPONSKILL_SNIPERRIFLE, pData[playerid][pSniperSkill]* 100);
	                  	}
	                  	else
	                  	{
	                  		pData[playerid][pTrainingTime] = 25*60;
	                  		format(String, sizeof(String), "SKILL: Sekarang skill Sniper Rifle anda sudah memasuki Level %d", pData[playerid][pSniperSkill]);
	                  		SendClientMessage(playerid, COLOR_GREYJG, String);
	                  		format(String, sizeof(String), "SKILL: Anda harus menunggu %d Menit untuk melakukan latihan lagi", pData[playerid][pTrainingTime]/60);
	                  		SendClientMessage(playerid, COLOR_GREYJG, String);
	                  		GivePlayerMoneyEx(playerid, -16500*pData[playerid][pSniperSkill]);
	                  		Tax += 16500*pData[playerid][pSniperSkill];
	                  		pData[playerid][pSniperSkill] ++;
	                  		SetPlayerSkillLevel(playerid, WEAPONSKILL_SNIPERRIFLE, pData[playerid][pSniperSkill]* 100);
	                	}
	              	}
	              	else Error(playerid, "Kamu tidak mempunyai uang yang cukup untuk melakukan latihan");
	        	}
	            else SendClientMessage(playerid, COLOR_GREYJG, "SKILL: Skill anda sudah mencapai level Max");
	            return 1;
	    	}
	    }
  	}
	if(dialogid == DIALOG_WEAPONSANEW)
	{
		if(response)
		{
			switch (listitem)
			{
				case 0:
				{
					GivePlayerWeaponEx(playerid, 43, 200);
					SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s reaches inside the locker and equips a %s.", ReturnName(playerid), ReturnWeaponName(43));
				}
				case 1:
				{
					GivePlayerWeaponEx(playerid, 41, 200);
					SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s reaches inside the locker and equips a %s.", ReturnName(playerid), ReturnWeaponName(41));
				}
				case 2:
				{
					GivePlayerWeaponEx(playerid, 46, 1);
					SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s reaches inside the locker and equips a %s.", ReturnName(playerid), ReturnWeaponName(46));
				}
				case 3:
				{
					//GivePlayerWeaponEx(playerid, 3, 200);
					//SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s reaches inside the locker and equips a %s.", ReturnName(playerid), ReturnWeaponName(3));
				}
				case 4:
				{
					//GivePlayerWeaponEx(playerid, 4, 200);
					//SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s reaches inside the locker and equips a %s.", ReturnName(playerid), ReturnWeaponName(4));
				}
				case 5:
				{
					if(pData[playerid][pFactionRank] < 3)
						return Error(playerid, "You are not allowed!");

					//GivePlayerWeaponEx(playerid, 22, 200);
					//SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s reaches inside the locker and equips a %s.", ReturnName(playerid), ReturnWeaponName(22));
				}
			}
		}
		return 1;
	}
	//--------[ DIALOG JOB ]--------
	if(dialogid == DIALOG_SERVICE)
	{
		new id = GetNearestWorkshop(playerid, 10);
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
					if(pData[playerid][pActivityTime] > 5) return Error(playerid, "You already checking vehicle!");
					if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
					{
						new Float:health, comp;
						GetVehicleHealth(pData[playerid][pMechVeh], health);
						if(health > 1000.0) health = 1000.0;
						if(health > 0.0) health *= -1;
						comp = floatround(health, floatround_round) / 10 + 100;

						if(pData[playerid][pComponent] < comp) return Error(playerid, "Component anda kurang!");
						if(comp <= 0) return Error(playerid, "This vehicle can't be fixing.");
						pData[playerid][pComponent] -= comp;
						Info(playerid, "Anda memperbaiki mesin kendaraan dengan "RED_E"%d component.", comp);
						pData[playerid][pMechanic] = SetTimerEx("EngineFix", 1000, true, "id", playerid, pData[playerid][pMechVeh]);
						PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Fixing Engine...");
						PlayerTextDrawShow(playerid, ActiveTD[playerid]);
						ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
					}
					else
					{
						KillTimer(pData[playerid][pMechanic]);
						HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
						PlayerTextDrawHide(playerid, ActiveTD[playerid]);
						pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
						pData[playerid][pActivityTime] = 0;
						Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
						return 1;
					}
				}
				case 1:
				{
				    if(pData[playerid][pActivityTime] > 5) return Error(playerid, "You already checking vehicle!");
					if(GetNearestVehicleToPlayer(playerid, 3.8, false)== pData[playerid][pMechVeh])
					{
						new panels, doors, light, tires, comp;

						GetVehicleDamageStatus(pData[playerid][pMechVeh], panels, doors, light, tires);
						new cpanels = panels / 1000000;
						new lights = light / 2;
						new pintu;
						if(doors != 0) pintu = 5;
						if(doors == 0) pintu = 0;
						comp = cpanels + lights + pintu + 20;

						if(pData[playerid][pComponent] < comp) return Error(playerid, "Component anda kurang!");
						if(comp <= 0) return Error(playerid, "This vehicle can't be fixing.");
						pData[playerid][pComponent] -= comp;
						Info(playerid, "Anda memperbaiki body kendaraan dengan "RED_E"%d component.", comp);
						pData[playerid][pMechanic] = SetTimerEx("BodyFix", 1000, true, "id", playerid, pData[playerid][pMechVeh]);
						PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Fixing Body...");
						PlayerTextDrawShow(playerid, ActiveTD[playerid]);
						ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
					}
					else
					{
						KillTimer(pData[playerid][pMechanic]);
						HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
						PlayerTextDrawHide(playerid, ActiveTD[playerid]);
						pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
						pData[playerid][pActivityTime] = 0;
						Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
						return 1;
					}
				}
                case 2:
				{
				    if(pData[playerid][pActivityTime] > 5) return Error(playerid, "You already checking vehicle!");
					if(GetNearestVehicleToPlayer(playerid, 3.8, false)== pData[playerid][pMechVeh])
					{
						new panels, doors, light, tires, comp;

						GetVehicleDamageStatus(pData[playerid][pMechVeh], panels, doors, light, tires);
						new velg;
						if(tires != 0) velg = 4;
						if(tires == 0) velg = 0;
						comp = velg + 30;

						if(pData[playerid][pComponent] < comp) return Error(playerid, "Component anda kurang!");
						if(comp <= 0) return Error(playerid, "This vehicle can't be fixing.");
						pData[playerid][pComponent] -= comp;
						Info(playerid, "Anda menambal ban kendaraan dengan "RED_E"%d component.", comp);
						pData[playerid][pMechanic] = SetTimerEx("BodyFix", 1000, true, "id", playerid, pData[playerid][pMechVeh]);
						PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Fixing Body...");
						PlayerTextDrawShow(playerid, ActiveTD[playerid]);
						ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
					}
					else
					{
						KillTimer(pData[playerid][pMechanic]);
						HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
						PlayerTextDrawHide(playerid, ActiveTD[playerid]);
						pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
						pData[playerid][pActivityTime] = 0;
						Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
						return 1;
					}
				}
				case 3:
				{
				    if(IsPlayerInRangeOfPoint(playerid, 50.0, wsData[id][WsRepX], wsData[id][WsRepY], wsData[id][WsRepZ]))
					{
						if(pData[playerid][pActivityTime] > 5) return Error(playerid, "You already checking vehicle!");
						if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
						{
							if(pData[playerid][pComponent] < 40) return Error(playerid, "Component anda kurang!");
							ShowPlayerDialog(playerid, DIALOG_SERVICE_COLOR, DIALOG_STYLE_INPUT, "Color ID 1", "Enter the color id 1:(0 - 255)", "Next", "Close");
						}
						else
						{
							KillTimer(pData[playerid][pMechanic]);
							HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
							PlayerTextDrawHide(playerid, ActiveTD[playerid]);
							pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
							pData[playerid][pActivityTime] = 0;
							Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
							return 1;
						}
					}
					else return Error(playerid, "You must in Mechanic Center Area!");
				}
				case 4:
				{
				    if(IsPlayerInRangeOfPoint(playerid, 50.0, wsData[id][WsRepX], wsData[id][WsRepY], wsData[id][WsRepZ]))
					{

						if(pData[playerid][pActivityTime] > 5) return Error(playerid, "You already checking vehicle!");
						if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
						{
							if(pData[playerid][pComponent] < 100) return Error(playerid, "Component anda kurang!");
							ShowPlayerDialog(playerid, DIALOG_SERVICE_PAINTJOB, DIALOG_STYLE_INPUT, "Paintjob", "Enter the vehicle paintjob id:(0 - 2 | 3 - Remove paintJob)", "Paintjob", "Close");
						}
						else
						{
							KillTimer(pData[playerid][pMechanic]);
							HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
							PlayerTextDrawHide(playerid, ActiveTD[playerid]);
							pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
							pData[playerid][pActivityTime] = 0;
							Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
							return 1;
						}
					}
					else return Error(playerid, "You must in Mechanic/Workshop Area!");
				}
				case 5:
				{
				    if(IsPlayerInRangeOfPoint(playerid, 50.0, wsData[id][WsRepX], wsData[id][WsRepY], wsData[id][WsRepZ]))
					{

						if(pData[playerid][pActivityTime] > 5) return Error(playerid, "You already checking vehicle!");
						if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
						{
							if(pData[playerid][pComponent] < 85) return Error(playerid, "Component anda kurang!");
							ShowPlayerDialog(playerid, DIALOG_SERVICE_WHEELS, DIALOG_STYLE_LIST, "Wheels", "Offroad\nMega\nWires\nTwist\nGrove\nImport\nAtomic\nAhab\nVirtual\nAccess\nTrance\nShadow\nRimshine\nClassic\nCutter\nSwitch\nDollar", "Confirm", "back");
						}
						else
						{
							KillTimer(pData[playerid][pMechanic]);
							HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
							PlayerTextDrawHide(playerid, ActiveTD[playerid]);
							pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
							pData[playerid][pActivityTime] = 0;
							Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
							return 1;
						}
					}
					else return Error(playerid, "You must in Mechanic/Workshop Area!");
				}
				case 6:
				{
				    if(IsPlayerInRangeOfPoint(playerid, 50.0, wsData[id][WsRepX], wsData[id][WsRepY], wsData[id][WsRepZ]))
					{

						if(pData[playerid][pActivityTime] > 5) return Error(playerid, "You already checking vehicle!");
						if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
						{
							if(pData[playerid][pComponent] < 70) return Error(playerid, "Component anda kurang!");
							ShowPlayerDialog(playerid, DIALOG_SERVICE_SPOILER,DIALOG_STYLE_LIST,"Choose below","Wheel Arc. Alien Spoiler\nWheel Arc. X-Flow Spoiler\nTransfender Win Spoiler\nTransfender Fury Spoiler\nTransfender Alpha Spoiler\nTransfender Pro Spoiler\nTransfender Champ Spoiler\nTransfender Race Spoiler\nTransfender Drag Spoiler\n","Choose","back");
						}
						else
						{
							KillTimer(pData[playerid][pMechanic]);
							HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
							PlayerTextDrawHide(playerid, ActiveTD[playerid]);
							pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
							pData[playerid][pActivityTime] = 0;
							Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
							return 1;
						}
					}
					else return Error(playerid, "You must in Mechanic/Workshop Area!");
				}
				case 7:
				{
				    if(IsPlayerInRangeOfPoint(playerid, 50.0, wsData[id][WsRepX], wsData[id][WsRepY], wsData[id][WsRepZ]))
					{

						if(pData[playerid][pActivityTime] > 5) return Error(playerid, "You already checking vehicle!");
						if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
						{
							if(pData[playerid][pComponent] < 70) return Error(playerid, "Component anda kurang!");
							ShowPlayerDialog(playerid, DIALOG_SERVICE_HOODS, DIALOG_STYLE_LIST, "Hoods", "Fury\nChamp\nRace\nWorx\n", "Confirm", "back");
						}
						else
						{
							KillTimer(pData[playerid][pMechanic]);
							HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
							PlayerTextDrawHide(playerid, ActiveTD[playerid]);
							pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
							pData[playerid][pActivityTime] = 0;
							Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
							return 1;
						}
					}
					else return Error(playerid, "You must in Mechanic/Workshop Area!");
				}
				case 8:
				{

					if(IsPlayerInRangeOfPoint(playerid, 50.0, wsData[id][WsRepX], wsData[id][WsRepY], wsData[id][WsRepZ]))
					{

						if(pData[playerid][pActivityTime] > 5) return Error(playerid, "You already checking vehicle!");
						if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
						{
							if(pData[playerid][pComponent] < 70) return Error(playerid, "Component anda kurang!");
							ShowPlayerDialog(playerid, DIALOG_SERVICE_VENTS, DIALOG_STYLE_LIST, "Vents", "Oval\nSquare\n", "Confirm", "back");
						}
						else
						{
							KillTimer(pData[playerid][pMechanic]);
							HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
							PlayerTextDrawHide(playerid, ActiveTD[playerid]);
							pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
							pData[playerid][pActivityTime] = 0;
							Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
							return 1;
						}
					}
					else return Error(playerid, "You must in Mechanic/Workshop Area!");
				}
				case 9:
				{

					if(IsPlayerInRangeOfPoint(playerid, 50.0, wsData[id][WsRepX], wsData[id][WsRepY], wsData[id][WsRepZ]))
					{

						if(pData[playerid][pActivityTime] > 5) return Error(playerid, "You already checking vehicle!");
						if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
						{
							if(pData[playerid][pComponent] < 50) return Error(playerid, "Component anda kurang!");
							ShowPlayerDialog(playerid, DIALOG_SERVICE_LIGHTS, DIALOG_STYLE_LIST, "Lights", "Round\nSquare\n", "Confirm", "back");
						}
						else
						{
							KillTimer(pData[playerid][pMechanic]);
							HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
							PlayerTextDrawHide(playerid, ActiveTD[playerid]);
							pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
							pData[playerid][pActivityTime] = 0;
							Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
							return 1;
						}
					}
					else return Error(playerid, "You must in Mechanic/Workshop Area!");
				}
				case 10:
				{

					if(IsPlayerInRangeOfPoint(playerid, 50.0, wsData[id][WsRepX], wsData[id][WsRepY], wsData[id][WsRepZ]))
					{

						if(pData[playerid][pActivityTime] > 5) return Error(playerid, "You already checking vehicle!");
						if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
						{
							if(pData[playerid][pComponent] < 80) return Error(playerid, "Component anda kurang!");
							ShowPlayerDialog(playerid, DIALOG_SERVICE_EXHAUSTS, DIALOG_STYLE_LIST, "Exhausts", "Wheel Arc. Alien exhaust\nWheel Arc. X-Flow exhaust\nLow Co. Chromer exhaust\nLow Co. Slamin exhaust\nTransfender Large exhaust\nTransfender Medium exhaust\nTransfender Small exhaust\nTransfender Twin exhaust\nTransfender Upswept exhaust", "Confirm", "back");
						}
						else
						{
							KillTimer(pData[playerid][pMechanic]);
							HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
							PlayerTextDrawHide(playerid, ActiveTD[playerid]);
							pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
							pData[playerid][pActivityTime] = 0;
							Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
							return 1;
						}
					}
					else return Error(playerid, "You must in Mechanic/Workshop Area!");
				}
				case 11:
				{

					if(IsPlayerInRangeOfPoint(playerid, 50.0, wsData[id][WsRepX], wsData[id][WsRepY], wsData[id][WsRepZ]))
					{

						if(pData[playerid][pActivityTime] > 5) return Error(playerid, "You already checking vehicle!");
						if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
						{
							if(pData[playerid][pComponent] < 100) return Error(playerid, "Component anda kurang!");
							ShowPlayerDialog(playerid, DIALOG_SERVICE_FRONT_BUMPERS, DIALOG_STYLE_LIST, "Front bumpers", "Wheel Arc. Alien Bumper\nWheel Arc. X-Flow Bumper\nLow co. Chromer Bumper\nLow co. Slamin Bumper", "Confirm", "back");
						}
						else
						{
							KillTimer(pData[playerid][pMechanic]);
							HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
							PlayerTextDrawHide(playerid, ActiveTD[playerid]);
							pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
							pData[playerid][pActivityTime] = 0;
							Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
							return 1;
						}
					}
					else return Error(playerid, "You must in Mechanic/Workshop Area!");
				}
				case 12:
				{

					if(IsPlayerInRangeOfPoint(playerid, 50.0, wsData[id][WsRepX], wsData[id][WsRepY], wsData[id][WsRepZ]))
					{

						if(pData[playerid][pActivityTime] > 5) return Error(playerid, "You already checking vehicle!");
						if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
						{
							if(pData[playerid][pComponent] < 100) return Error(playerid, "Component anda kurang!");
							ShowPlayerDialog(playerid, DIALOG_SERVICE_REAR_BUMPERS, DIALOG_STYLE_LIST, "Rear bumpers", "Wheel Arc. Alien Bumper\nWheel Arc. X-Flow Bumper\nLow co. Chromer Bumper\nLow co. Slamin Bumper", "Confirm", "back");
						}
						else
						{
							KillTimer(pData[playerid][pMechanic]);
							HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
							PlayerTextDrawHide(playerid, ActiveTD[playerid]);
							pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
							pData[playerid][pActivityTime] = 0;
							Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
							return 1;
						}
					}
					else return Error(playerid, "You must in Mechanic/Workshop Area!");
				}
				case 13:
				{

					if(IsPlayerInRangeOfPoint(playerid, 50.0, wsData[id][WsRepX], wsData[id][WsRepY], wsData[id][WsRepZ]))
					{

						if(pData[playerid][pActivityTime] > 5) return Error(playerid, "You already checking vehicle!");
						if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
						{
							if(pData[playerid][pComponent] < 70) return Error(playerid, "Component anda kurang!");
							ShowPlayerDialog(playerid, DIALOG_SERVICE_ROOFS, DIALOG_STYLE_LIST, "Roofs", "Wheel Arc. Alien\nWheel Arc. X-Flow\nLow Co. Hardtop Roof\nLow Co. Softtop Roof\nTransfender Roof Scoop", "Confirm", "back");
						}
						else
						{
							KillTimer(pData[playerid][pMechanic]);
							HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
							PlayerTextDrawHide(playerid, ActiveTD[playerid]);
							pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
							pData[playerid][pActivityTime] = 0;
							Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
							return 1;
						}
					}
					else return Error(playerid, "You must in Mechanic/Workshop Area!");
				}
				case 14:
				{

					if(IsPlayerInRangeOfPoint(playerid, 50.0, wsData[id][WsRepX], wsData[id][WsRepY], wsData[id][WsRepZ]))
					{

						if(pData[playerid][pActivityTime] > 5) return Error(playerid, "You already checking vehicle!");
						if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
						{
							if(pData[playerid][pComponent] < 90) return Error(playerid, "Component anda kurang!");
							ShowPlayerDialog(playerid, DIALOG_SERVICE_SIDE_SKIRTS, DIALOG_STYLE_LIST, "Side skirts", "Wheel Arc. Alien Side Skirt\nWheel Arc. X-Flow Side Skirt\nLocos Chrome Strip\nLocos Chrome Flames\nLocos Chrome Arches \nLocos Chrome Trim\nLocos Wheelcovers\nTransfender Side Skirt", "Confirm", "back");
						}
						else
						{
							KillTimer(pData[playerid][pMechanic]);
							HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
							PlayerTextDrawHide(playerid, ActiveTD[playerid]);
							pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
							pData[playerid][pActivityTime] = 0;
							Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
							return 1;
						}
					}
					else return Error(playerid, "You must in Mechanic/Workshop Area!");
					Info(playerid, "Side blm ada.");
				}
				case 15:
				{

					if(IsPlayerInRangeOfPoint(playerid, 50.0, wsData[id][WsRepX], wsData[id][WsRepY], wsData[id][WsRepZ]))
					{

						if(pData[playerid][pActivityTime] > 5) return Error(playerid, "You already checking vehicle!");
						if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
						{
							if(pData[playerid][pComponent] < 50) return Error(playerid, "Component anda kurang!");
							ShowPlayerDialog(playerid, DIALOG_SERVICE_BULLBARS, DIALOG_STYLE_LIST, "Bull bars", "Locos Chrome Grill\nLocos Chrome Bars\nLocos Chrome Lights \nLocos Chrome Bullbar", "Confirm", "back");
						}
						else
						{
							KillTimer(pData[playerid][pMechanic]);
							HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
							PlayerTextDrawHide(playerid, ActiveTD[playerid]);
							pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
							pData[playerid][pActivityTime] = 0;
							Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
							return 1;
						}
					}
					else return Error(playerid, "You must in Mechanic/Workshop Area!");
				}
				case 16:
				{

					if(IsPlayerInRangeOfPoint(playerid, 50.0, wsData[id][WsRepX], wsData[id][WsRepY], wsData[id][WsRepZ]))
					{

						pData[playerid][pMechColor1] = 1086;
						pData[playerid][pMechColor2] = 0;

						if(pData[playerid][pActivityTime] > 5) return Error(playerid, "You already checking vehicle!");
						if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
						{
							if(pData[playerid][pComponent] < 150) return Error(playerid, "Component anda kurang!");
							pData[playerid][pComponent] -= 150;
							Info(playerid, "Anda memodif kendaraan dengan "RED_E"150 component.");
							pData[playerid][pMechanic] = SetTimerEx("ModifCar", 1000, true, "id", playerid, pData[playerid][pMechVeh]);
							PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Modif Car...");
							PlayerTextDrawShow(playerid, ActiveTD[playerid]);
							ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
						}
						else
						{
							KillTimer(pData[playerid][pMechanic]);
							HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
							PlayerTextDrawHide(playerid, ActiveTD[playerid]);
							pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
							pData[playerid][pMechColor1] = 0;
							pData[playerid][pMechColor2] = 0;
							pData[playerid][pActivityTime] = 0;
							Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
							return 1;
						}
					}
					else return Error(playerid, "You must in Mechanic/Workshop Area!");
				}
				case 17:
				{
					if(IsPlayerInRangeOfPoint(playerid, 50.0, wsData[id][WsRepX], wsData[id][WsRepY], wsData[id][WsRepZ]))
					{

						pData[playerid][pMechColor1] = 1087;
						pData[playerid][pMechColor2] = 0;

						if(pData[playerid][pActivityTime] > 5) return Error(playerid, "You already checking vehicle!");
						if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
						{
							if(pData[playerid][pComponent] < 150) return Error(playerid, "Component anda kurang!");
							pData[playerid][pComponent] -= 150;
							Info(playerid, "Anda memodif kendaraan dengan "RED_E"150 component.");
							pData[playerid][pMechanic] = SetTimerEx("ModifCar", 1000, true, "id", playerid, pData[playerid][pMechVeh]);
							PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Modif Car...");
							PlayerTextDrawShow(playerid, ActiveTD[playerid]);
							ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
						}
						else
						{
							KillTimer(pData[playerid][pMechanic]);
							HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
							PlayerTextDrawHide(playerid, ActiveTD[playerid]);
							pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
							pData[playerid][pMechColor1] = 0;
							pData[playerid][pMechColor2] = 0;
							pData[playerid][pActivityTime] = 0;
							Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
							return 1;
						}
					}
					else return Error(playerid, "You must in Mechanic/Workshop Area!");
				}
				case 18:
				{
					if(IsPlayerInRangeOfPoint(playerid, 50.0, wsData[id][WsRepX], wsData[id][WsRepY], wsData[id][WsRepZ]))
					{
						pData[playerid][pMechColor1] = 1009;
						pData[playerid][pMechColor2] = 0;

						if(pData[playerid][pActivityTime] > 5) return Error(playerid, "You already checking vehicle!");
						if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
						{
							if(pData[playerid][pComponent] < 250) return Error(playerid, "Component anda kurang!");
							pData[playerid][pComponent] -= 250;
							Info(playerid, "Anda memodif kendaraan dengan "RED_E"250 component.");
							pData[playerid][pMechanic] = SetTimerEx("ModifCar", 1000, true, "id", playerid, pData[playerid][pMechVeh]);
							PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Modif Car...");
							PlayerTextDrawShow(playerid, ActiveTD[playerid]);
							ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
						}
						else
						{
							KillTimer(pData[playerid][pMechanic]);
							HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
							PlayerTextDrawHide(playerid, ActiveTD[playerid]);
							pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
							pData[playerid][pMechColor1] = 0;
							pData[playerid][pMechColor2] = 0;
							pData[playerid][pActivityTime] = 0;
							Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
							return 1;
						}
					}
					else return Error(playerid, "You must in Mechanic/Workshop Area!");
				}
				case 19:
				{

					if(IsPlayerInRangeOfPoint(playerid, 50.0, wsData[id][WsRepX], wsData[id][WsRepY], wsData[id][WsRepZ]))
					{

						pData[playerid][pMechColor1] = 1008;
						pData[playerid][pMechColor2] = 0;

						if(pData[playerid][pActivityTime] > 5) return Error(playerid, "You already checking vehicle!");
						if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
						{
							if(pData[playerid][pComponent] < 375) return Error(playerid, "Component anda kurang!");
							pData[playerid][pComponent] -= 375;
							Info(playerid, "Anda memodif kendaraan dengan "RED_E"375 component.");
							pData[playerid][pMechanic] = SetTimerEx("ModifCar", 1000, true, "id", playerid, pData[playerid][pMechVeh]);
							PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Modif Car...");
							PlayerTextDrawShow(playerid, ActiveTD[playerid]);
							ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
						}
						else
						{
							KillTimer(pData[playerid][pMechanic]);
							HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
							PlayerTextDrawHide(playerid, ActiveTD[playerid]);
							pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
							pData[playerid][pMechColor1] = 0;
							pData[playerid][pMechColor2] = 0;
							pData[playerid][pActivityTime] = 0;
							Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
							return 1;
						}
					}
					else return Error(playerid, "You must in Mechanic/Workshop Area!");
				}
				case 20:
				{

					if(IsPlayerInRangeOfPoint(playerid, 50.0, wsData[id][WsRepX], wsData[id][WsRepY], wsData[id][WsRepZ]))
					{
						pData[playerid][pMechColor1] = 1010;
						pData[playerid][pMechColor2] = 0;

						if(pData[playerid][pActivityTime] > 5) return Error(playerid, "You already checking vehicle!");
						if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
						{
							if(pData[playerid][pComponent] < 500) return Error(playerid, "Component anda kurang!");
							pData[playerid][pComponent] -= 500;
							Info(playerid, "Anda memodif kendaraan dengan "RED_E"500 component.");
							pData[playerid][pMechanic] = SetTimerEx("ModifCar", 1000, true, "id", playerid, pData[playerid][pMechVeh]);
							PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Modif Car...");
							PlayerTextDrawShow(playerid, ActiveTD[playerid]);
							ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
						}
						else
						{
							KillTimer(pData[playerid][pMechanic]);
							HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
							PlayerTextDrawHide(playerid, ActiveTD[playerid]);
							pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
							pData[playerid][pMechColor1] = 0;
							pData[playerid][pMechColor2] = 0;
							pData[playerid][pActivityTime] = 0;
							Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
							return 1;
						}
					}
					else return Error(playerid, "You must in Mechanic/Workshop Area!");
				}
				case 21:
				{

					if(IsPlayerInRangeOfPoint(playerid, 50.0, wsData[id][WsRepX], wsData[id][WsRepY], wsData[id][WsRepZ]))
					{
						if(pData[playerid][pActivityTime] > 5) return Error(playerid, "You already checking vehicle!");
						if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
						{
							if(pData[playerid][pComponent] < 450) return Error(playerid, "Component anda kurang!");
							ShowPlayerDialog(playerid, DIALOG_SERVICE_NEON,DIALOG_STYLE_LIST,"Neon","RED\nBLUE\nGREEN\nYELLOW\nPINK\nWHITE\nREMOVE","Choose","back");
						}
						else
						{
							KillTimer(pData[playerid][pMechanic]);
							HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
							PlayerTextDrawHide(playerid, ActiveTD[playerid]);
							pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
							pData[playerid][pActivityTime] = 0;
							Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
							return 1;
						}
					}
					else return Error(playerid, "You must in Mechanic/Workshop Area!");
				}
			}
		}
	}
	if(dialogid == DIALOG_UPGRADE)
	{
		//new id = GetNearestWorkshop(playerid, 10);
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
					if(pData[playerid][pActivityTime] > 5) return Error(playerid, "You already checking vehicle!");
					if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
					{
						if(pData[playerid][pComponent] < 500) return Error(playerid, "Component anda kurang!");
						//if(500 <= 0) return Error(playerid, "This vehicle can't be fixing.");
						pData[playerid][pComponent] -= 500;
						Info(playerid, "Anda memperbaiki mesin kendaraan dengan "RED_E"500 component.");
						pData[playerid][pMechanic] = SetTimerEx("UpgradeEngine", 1000, true, "id", playerid, pData[playerid][pMechVeh]);
						PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Upgrade Engine...");
						PlayerTextDrawShow(playerid, ActiveTD[playerid]);
						ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
					}
					else
					{
						KillTimer(pData[playerid][pMechanic]);
						HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
						PlayerTextDrawHide(playerid, ActiveTD[playerid]);
						pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
						pData[playerid][pActivityTime] = 0;
						Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
						return 1;
					}
				}
				case 1:
				{
				    if(pData[playerid][pActivityTime] > 5) return Error(playerid, "You already checking vehicle!");
					if(GetNearestVehicleToPlayer(playerid, 3.8, false)== pData[playerid][pMechVeh])
					{
						if(pData[playerid][pComponent] < 500) return Error(playerid, "Component anda kurang!");
						//if(500 <= 0) return Error(playerid, "This vehicle can't be fixing.");
						pData[playerid][pComponent] -= 500;
						Info(playerid, "Anda memperbaiki mesin kendaraan dengan "RED_E"500 component.");
						pData[playerid][pMechanic] = SetTimerEx("UpgradeBody", 1000, true, "id", playerid, pData[playerid][pMechVeh]);
						PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Upgrade Engine...");
						PlayerTextDrawShow(playerid, ActiveTD[playerid]);
						ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
					}
					else
					{
						KillTimer(pData[playerid][pMechanic]);
						HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
						PlayerTextDrawHide(playerid, ActiveTD[playerid]);
						pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
						pData[playerid][pActivityTime] = 0;
						Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
						return 1;
					}
				}
			}
		}	
	}
	if(dialogid == DIALOG_SERVICE_COLOR)
	{
		if(response)
		{
			pData[playerid][pMechColor1] = floatround(strval(inputtext));

			if(pData[playerid][pMechColor1] < 0 || pData[playerid][pMechColor1] > 255)
				return ShowPlayerDialog(playerid, DIALOG_SERVICE_COLOR, DIALOG_STYLE_INPUT, "Color ID 1", "Enter the color id 1:(0 - 255)", "Next", "Close");

			ShowPlayerDialog(playerid, DIALOG_SERVICE_COLOR2, DIALOG_STYLE_INPUT, "Color ID 2", "Enter the color id 2:(0 - 255)", "Next", "Close");
		}
		return 1;
	}
	if(dialogid == DIALOG_SERVICE_COLOR2)
	{
		if(response)
		{
			pData[playerid][pMechColor2] = floatround(strval(inputtext));

			if(pData[playerid][pMechColor2] < 0 || pData[playerid][pMechColor2] > 255)
				return ShowPlayerDialog(playerid, DIALOG_SERVICE_COLOR2, DIALOG_STYLE_INPUT, "Color ID 2", "Enter the color id 2:(0 - 255)", "Next", "Close");

			if(pData[playerid][pActivityTime] > 5) return Error(playerid, "You already checking vehicle!");
			if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
			{
				if(pData[playerid][pComponent] < 40) return Error(playerid, "Component anda kurang!");
				pData[playerid][pComponent] -= 40;
				Info(playerid, "Anda mengganti warna kendaraan dengan "RED_E"30 component.");
				pData[playerid][pMechanic] = SetTimerEx("SprayCar", 1000, true, "id", playerid, pData[playerid][pMechVeh]);
				PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Spraying Car...");
				PlayerTextDrawShow(playerid, ActiveTD[playerid]);
				ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
			}
			else
			{
				KillTimer(pData[playerid][pMechanic]);
				HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
				PlayerTextDrawHide(playerid, ActiveTD[playerid]);
				pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
				pData[playerid][pMechColor1] = 0;
				pData[playerid][pMechColor2] = 0;
				pData[playerid][pActivityTime] = 0;
				Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
				return 1;
			}
		}
		return 1;
	}
	if(dialogid == DIALOG_SERVICE_PAINTJOB)
	{
		if(response)
		{
			pData[playerid][pMechColor1] = floatround(strval(inputtext));

			if(pData[playerid][pMechColor1] < 0 || pData[playerid][pMechColor1] > 3)
				return ShowPlayerDialog(playerid, DIALOG_SERVICE_PAINTJOB, DIALOG_STYLE_INPUT, "Paintjob", "Enter the vehicle paintjob id:(0 - 2 | 3 - Remove paintJob)", "Paintjob", "Close");

			if(pData[playerid][pActivityTime] > 5) return Error(playerid, "You already checking vehicle!");
			if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
			{
				if(pData[playerid][pComponent] < 100) return Error(playerid, "Component anda kurang!");
				pData[playerid][pComponent] -= 100;
				Info(playerid, "Anda mengganti paintjob kendaraan dengan "RED_E"50 component.");
				pData[playerid][pMechanic] = SetTimerEx("PaintjobCar", 1000, true, "id", playerid, pData[playerid][pMechVeh]);
				PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Painting Car...");
				PlayerTextDrawShow(playerid, ActiveTD[playerid]);
				ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
			}
			else
			{
				KillTimer(pData[playerid][pMechanic]);
				HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
				PlayerTextDrawHide(playerid, ActiveTD[playerid]);
				pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
				pData[playerid][pMechColor1] = 0;
				pData[playerid][pMechColor2] = 0;
				pData[playerid][pActivityTime] = 0;
				Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
				return 1;
			}
		}
		return 1;
	}
	if(dialogid == DIALOG_SERVICE_WHEELS)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
					pData[playerid][pMechColor1] = 1025;
					pData[playerid][pMechColor2] = 0;

					if(pData[playerid][pActivityTime] > 5) return Error(playerid, "You already checking vehicle!");
					if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
					{
						if(pData[playerid][pComponent] < 85) return Error(playerid, "Component anda kurang!");
						pData[playerid][pComponent] -= 85;
						Info(playerid, "Anda memodif kendaraan dengan "RED_E"60 component.");
						pData[playerid][pMechanic] = SetTimerEx("ModifCar", 1000, true, "id", playerid, pData[playerid][pMechVeh]);
						PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Modif Car...");
						PlayerTextDrawShow(playerid, ActiveTD[playerid]);
						ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
					}
					else
					{
						KillTimer(pData[playerid][pMechanic]);
						HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
						PlayerTextDrawHide(playerid, ActiveTD[playerid]);
						pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
						pData[playerid][pMechColor1] = 0;
						pData[playerid][pMechColor2] = 0;
						pData[playerid][pActivityTime] = 0;
						Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
						return 1;
					}
				}
				case 1:
				{
					pData[playerid][pMechColor1] = 1074;
					pData[playerid][pMechColor2] = 0;

					if(pData[playerid][pActivityTime] > 5) return Error(playerid, "You already checking vehicle!");
					if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
					{
						if(pData[playerid][pComponent] < 60) return Error(playerid, "Component anda kurang!");
						pData[playerid][pComponent] -= 60;
						Info(playerid, "Anda memodif kendaraan dengan "RED_E"60 component.");
						pData[playerid][pMechanic] = SetTimerEx("ModifCar", 1000, true, "id", playerid, pData[playerid][pMechVeh]);
						PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Modif Car...");
						PlayerTextDrawShow(playerid, ActiveTD[playerid]);
						ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
					}
					else
					{
						KillTimer(pData[playerid][pMechanic]);
						HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
						PlayerTextDrawHide(playerid, ActiveTD[playerid]);
						pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
						pData[playerid][pMechColor1] = 0;
						pData[playerid][pMechColor2] = 0;
						pData[playerid][pActivityTime] = 0;
						Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
						return 1;
					}
				}
				case 2:
				{
					pData[playerid][pMechColor1] = 1076;
					pData[playerid][pMechColor2] = 0;

					if(pData[playerid][pActivityTime] > 5) return Error(playerid, "You already checking vehicle!");
					if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
					{
						if(pData[playerid][pComponent] < 60) return Error(playerid, "Component anda kurang!");
						pData[playerid][pComponent] -= 60;
						Info(playerid, "Anda memodif kendaraan dengan "RED_E"60 component.");
						pData[playerid][pMechanic] = SetTimerEx("ModifCar", 1000, true, "id", playerid, pData[playerid][pMechVeh]);
						PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Modif Car...");
						PlayerTextDrawShow(playerid, ActiveTD[playerid]);
						ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
					}
					else
					{
						KillTimer(pData[playerid][pMechanic]);
						HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
						PlayerTextDrawHide(playerid, ActiveTD[playerid]);
						pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
						pData[playerid][pMechColor1] = 0;
						pData[playerid][pMechColor2] = 0;
						pData[playerid][pActivityTime] = 0;
						Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
						return 1;
					}
				}
				case 3:
				{
					pData[playerid][pMechColor1] = 1078;
					pData[playerid][pMechColor2] = 0;

					if(pData[playerid][pActivityTime] > 5) return Error(playerid, "You already checking vehicle!");
					if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
					{
						if(pData[playerid][pComponent] < 60) return Error(playerid, "Component anda kurang!");
						pData[playerid][pComponent] -= 60;
						Info(playerid, "Anda memodif kendaraan dengan "RED_E"60 component.");
						pData[playerid][pMechanic] = SetTimerEx("ModifCar", 1000, true, "id", playerid, pData[playerid][pMechVeh]);
						PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Modif Car...");
						PlayerTextDrawShow(playerid, ActiveTD[playerid]);
						ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
					}
					else
					{
						KillTimer(pData[playerid][pMechanic]);
						HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
						PlayerTextDrawHide(playerid, ActiveTD[playerid]);
						pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
						pData[playerid][pMechColor1] = 0;
						pData[playerid][pMechColor2] = 0;
						pData[playerid][pActivityTime] = 0;
						Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
						return 1;
					}
				}
				case 4:
				{
					pData[playerid][pMechColor1] = 1081;
					pData[playerid][pMechColor2] = 0;

					if(pData[playerid][pActivityTime] > 5) return Error(playerid, "You already checking vehicle!");
					if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
					{
						if(pData[playerid][pComponent] < 60) return Error(playerid, "Component anda kurang!");
						pData[playerid][pComponent] -= 60;
						Info(playerid, "Anda memodif kendaraan dengan "RED_E"60 component.");
						pData[playerid][pMechanic] = SetTimerEx("ModifCar", 1000, true, "id", playerid, pData[playerid][pMechVeh]);
						PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Modif Car...");
						PlayerTextDrawShow(playerid, ActiveTD[playerid]);
						ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
					}
					else
					{
						KillTimer(pData[playerid][pMechanic]);
						HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
						PlayerTextDrawHide(playerid, ActiveTD[playerid]);
						pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
						pData[playerid][pMechColor1] = 0;
						pData[playerid][pMechColor2] = 0;
						pData[playerid][pActivityTime] = 0;
						Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
						return 1;
					}
				}
				case 5:
				{
					pData[playerid][pMechColor1] = 1082;
					pData[playerid][pMechColor2] = 0;

					if(pData[playerid][pActivityTime] > 5) return Error(playerid, "You already checking vehicle!");
					if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
					{
						if(pData[playerid][pComponent] < 60) return Error(playerid, "Component anda kurang!");
						pData[playerid][pComponent] -= 60;
						Info(playerid, "Anda memodif kendaraan dengan "RED_E"60 component.");
						pData[playerid][pMechanic] = SetTimerEx("ModifCar", 1000, true, "id", playerid, pData[playerid][pMechVeh]);
						PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Modif Car...");
						PlayerTextDrawShow(playerid, ActiveTD[playerid]);
						ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
					}
					else
					{
						KillTimer(pData[playerid][pMechanic]);
						HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
						PlayerTextDrawHide(playerid, ActiveTD[playerid]);
						pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
						pData[playerid][pMechColor1] = 0;
						pData[playerid][pMechColor2] = 0;
						pData[playerid][pActivityTime] = 0;
						Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
						return 1;
					}
				}
				case 6:
				{
					pData[playerid][pMechColor1] = 1085;
					pData[playerid][pMechColor2] = 0;

					if(pData[playerid][pActivityTime] > 5) return Error(playerid, "You already checking vehicle!");
					if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
					{
						if(pData[playerid][pComponent] < 60) return Error(playerid, "Component anda kurang!");
						pData[playerid][pComponent] -= 60;
						Info(playerid, "Anda memodif kendaraan dengan "RED_E"60 component.");
						pData[playerid][pMechanic] = SetTimerEx("ModifCar", 1000, true, "id", playerid, pData[playerid][pMechVeh]);
						PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Modif Car...");
						PlayerTextDrawShow(playerid, ActiveTD[playerid]);
						ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
					}
					else
					{
						KillTimer(pData[playerid][pMechanic]);
						HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
						PlayerTextDrawHide(playerid, ActiveTD[playerid]);
						pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
						pData[playerid][pMechColor1] = 0;
						pData[playerid][pMechColor2] = 0;
						pData[playerid][pActivityTime] = 0;
						Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
						return 1;
					}
				}
				case 7:
				{
					pData[playerid][pMechColor1] = 1096;
					pData[playerid][pMechColor2] = 0;

					if(pData[playerid][pActivityTime] > 5) return Error(playerid, "You already checking vehicle!");
					if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
					{
						if(pData[playerid][pComponent] < 60) return Error(playerid, "Component anda kurang!");
						pData[playerid][pComponent] -= 60;
						Info(playerid, "Anda memodif kendaraan dengan "RED_E"60 component.");
						pData[playerid][pMechanic] = SetTimerEx("ModifCar", 1000, true, "id", playerid, pData[playerid][pMechVeh]);
						PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Modif Car...");
						PlayerTextDrawShow(playerid, ActiveTD[playerid]);
						ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
					}
					else
					{
						KillTimer(pData[playerid][pMechanic]);
						HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
						PlayerTextDrawHide(playerid, ActiveTD[playerid]);
						pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
						pData[playerid][pMechColor1] = 0;
						pData[playerid][pMechColor2] = 0;
						pData[playerid][pActivityTime] = 0;
						Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
						return 1;
					}
				}
				case 8:
				{
					pData[playerid][pMechColor1] = 1097;
					pData[playerid][pMechColor2] = 0;

					if(pData[playerid][pActivityTime] > 5) return Error(playerid, "You already checking vehicle!");
					if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
					{
						if(pData[playerid][pComponent] < 60) return Error(playerid, "Component anda kurang!");
						pData[playerid][pComponent] -= 60;
						Info(playerid, "Anda memodif kendaraan dengan "RED_E"60 component.");
						pData[playerid][pMechanic] = SetTimerEx("ModifCar", 1000, true, "id", playerid, pData[playerid][pMechVeh]);
						PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Modif Car...");
						PlayerTextDrawShow(playerid, ActiveTD[playerid]);
						ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
					}
					else
					{
						KillTimer(pData[playerid][pMechanic]);
						HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
						PlayerTextDrawHide(playerid, ActiveTD[playerid]);
						pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
						pData[playerid][pMechColor1] = 0;
						pData[playerid][pMechColor2] = 0;
						pData[playerid][pActivityTime] = 0;
						Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
						return 1;
					}
				}
				case 9:
				{
					pData[playerid][pMechColor1] = 1098;
					pData[playerid][pMechColor2] = 0;

					if(pData[playerid][pActivityTime] > 5) return Error(playerid, "You already checking vehicle!");
					if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
					{
						if(pData[playerid][pComponent] < 60) return Error(playerid, "Component anda kurang!");
						pData[playerid][pComponent] -= 60;
						Info(playerid, "Anda memodif kendaraan dengan "RED_E"60 component.");
						pData[playerid][pMechanic] = SetTimerEx("ModifCar", 1000, true, "id", playerid, pData[playerid][pMechVeh]);
						PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Modif Car...");
						PlayerTextDrawShow(playerid, ActiveTD[playerid]);
						ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
					}
					else
					{
						KillTimer(pData[playerid][pMechanic]);
						HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
						PlayerTextDrawHide(playerid, ActiveTD[playerid]);
						pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
						pData[playerid][pMechColor1] = 0;
						pData[playerid][pMechColor2] = 0;
						pData[playerid][pActivityTime] = 0;
						Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
						return 1;
					}
				}
				case 10:
				{
					pData[playerid][pMechColor1] = 1084;
					pData[playerid][pMechColor2] = 0;

					if(pData[playerid][pActivityTime] > 5) return Error(playerid, "You already checking vehicle!");
					if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
					{
						if(pData[playerid][pComponent] < 60) return Error(playerid, "Component anda kurang!");
						pData[playerid][pComponent] -= 60;
						Info(playerid, "Anda memodif kendaraan dengan "RED_E"60 component.");
						pData[playerid][pMechanic] = SetTimerEx("ModifCar", 1000, true, "id", playerid, pData[playerid][pMechVeh]);
						PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Modif Car...");
						PlayerTextDrawShow(playerid, ActiveTD[playerid]);
						ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
					}
					else
					{
						KillTimer(pData[playerid][pMechanic]);
						HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
						PlayerTextDrawHide(playerid, ActiveTD[playerid]);
						pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
						pData[playerid][pMechColor1] = 0;
						pData[playerid][pMechColor2] = 0;
						pData[playerid][pActivityTime] = 0;
						Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
						return 1;
					}
				}
				case 11:
				{
					pData[playerid][pMechColor1] = 1073;
					pData[playerid][pMechColor2] = 0;

					if(pData[playerid][pActivityTime] > 5) return Error(playerid, "You already checking vehicle!");
					if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
					{
						if(pData[playerid][pComponent] < 60) return Error(playerid, "Component anda kurang!");
						pData[playerid][pComponent] -= 60;
						Info(playerid, "Anda memodif kendaraan dengan "RED_E"60 component.");
						pData[playerid][pMechanic] = SetTimerEx("ModifCar", 1000, true, "id", playerid, pData[playerid][pMechVeh]);
						PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Modif Car...");
						PlayerTextDrawShow(playerid, ActiveTD[playerid]);
						ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
					}
					else
					{
						KillTimer(pData[playerid][pMechanic]);
						HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
						PlayerTextDrawHide(playerid, ActiveTD[playerid]);
						pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
						pData[playerid][pMechColor1] = 0;
						pData[playerid][pMechColor2] = 0;
						pData[playerid][pActivityTime] = 0;
						Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
						return 1;
					}
				}
				case 12:
				{
					pData[playerid][pMechColor1] = 1075;
					pData[playerid][pMechColor2] = 0;

					if(pData[playerid][pActivityTime] > 5) return Error(playerid, "You already checking vehicle!");
					if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
					{
						if(pData[playerid][pComponent] < 60) return Error(playerid, "Component anda kurang!");
						pData[playerid][pComponent] -= 60;
						Info(playerid, "Anda memodif kendaraan dengan "RED_E"60 component.");
						pData[playerid][pMechanic] = SetTimerEx("ModifCar", 1000, true, "id", playerid, pData[playerid][pMechVeh]);
						PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Modif Car...");
						PlayerTextDrawShow(playerid, ActiveTD[playerid]);
						ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
					}
					else
					{
						KillTimer(pData[playerid][pMechanic]);
						HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
						PlayerTextDrawHide(playerid, ActiveTD[playerid]);
						pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
						pData[playerid][pMechColor1] = 0;
						pData[playerid][pMechColor2] = 0;
						pData[playerid][pActivityTime] = 0;
						Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
						return 1;
					}
				}
				case 13:
				{
					pData[playerid][pMechColor1] = 1077;
					pData[playerid][pMechColor2] = 0;

					if(pData[playerid][pActivityTime] > 5) return Error(playerid, "You already checking vehicle!");
					if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
					{
						if(pData[playerid][pComponent] < 60) return Error(playerid, "Component anda kurang!");
						pData[playerid][pComponent] -= 60;
						Info(playerid, "Anda memodif kendaraan dengan "RED_E"60 component.");
						pData[playerid][pMechanic] = SetTimerEx("ModifCar", 1000, true, "id", playerid, pData[playerid][pMechVeh]);
						PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Modif Car...");
						PlayerTextDrawShow(playerid, ActiveTD[playerid]);
						ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
					}
					else
					{
						KillTimer(pData[playerid][pMechanic]);
						HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
						PlayerTextDrawHide(playerid, ActiveTD[playerid]);
						pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
						pData[playerid][pMechColor1] = 0;
						pData[playerid][pMechColor2] = 0;
						pData[playerid][pActivityTime] = 0;
						Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
						return 1;
					}
				}
				case 14:
				{
					pData[playerid][pMechColor1] = 1079;
					pData[playerid][pMechColor2] = 0;

					if(pData[playerid][pActivityTime] > 5) return Error(playerid, "You already checking vehicle!");
					if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
					{
						if(pData[playerid][pComponent] < 60) return Error(playerid, "Component anda kurang!");
						pData[playerid][pComponent] -= 60;
						Info(playerid, "Anda memodif kendaraan dengan "RED_E"60 component.");
						pData[playerid][pMechanic] = SetTimerEx("ModifCar", 1000, true, "id", playerid, pData[playerid][pMechVeh]);
						PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Modif Car...");
						PlayerTextDrawShow(playerid, ActiveTD[playerid]);
						ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
					}
					else
					{
						KillTimer(pData[playerid][pMechanic]);
						HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
						PlayerTextDrawHide(playerid, ActiveTD[playerid]);
						pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
						pData[playerid][pMechColor1] = 0;
						pData[playerid][pMechColor2] = 0;
						pData[playerid][pActivityTime] = 0;
						Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
						return 1;
					}
				}
				case 15:
				{
					pData[playerid][pMechColor1] = 1080;
					pData[playerid][pMechColor2] = 0;

					if(pData[playerid][pActivityTime] > 5) return Error(playerid, "You already checking vehicle!");
					if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
					{
						if(pData[playerid][pComponent] < 60) return Error(playerid, "Component anda kurang!");
						pData[playerid][pComponent] -= 60;
						Info(playerid, "Anda memodif kendaraan dengan "RED_E"60 component.");
						pData[playerid][pMechanic] = SetTimerEx("ModifCar", 1000, true, "id", playerid, pData[playerid][pMechVeh]);
						PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Modif Car...");
						PlayerTextDrawShow(playerid, ActiveTD[playerid]);
						ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
					}
					else
					{
						KillTimer(pData[playerid][pMechanic]);
						HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
						PlayerTextDrawHide(playerid, ActiveTD[playerid]);
						pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
						pData[playerid][pMechColor1] = 0;
						pData[playerid][pMechColor2] = 0;
						pData[playerid][pActivityTime] = 0;
						Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
						return 1;
					}
				}
				case 16:
				{
					pData[playerid][pMechColor1] = 1083;
					pData[playerid][pMechColor2] = 0;

					if(pData[playerid][pActivityTime] > 5) return Error(playerid, "You already checking vehicle!");
					if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
					{
						if(pData[playerid][pComponent] < 60) return Error(playerid, "Component anda kurang!");
						pData[playerid][pComponent] -= 60;
						Info(playerid, "Anda memodif kendaraan dengan "RED_E"60 component.");
						pData[playerid][pMechanic] = SetTimerEx("ModifCar", 1000, true, "id", playerid, pData[playerid][pMechVeh]);
						PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Modif Car...");
						PlayerTextDrawShow(playerid, ActiveTD[playerid]);
						ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
					}
					else
					{
						KillTimer(pData[playerid][pMechanic]);
						HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
						PlayerTextDrawHide(playerid, ActiveTD[playerid]);
						pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
						pData[playerid][pMechColor1] = 0;
						pData[playerid][pMechColor2] = 0;
						pData[playerid][pActivityTime] = 0;
						Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
						return 1;
					}
				}
			}
		}
		return 1;
	}
	if(dialogid == DIALOG_SERVICE_SPOILER)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
					new VehicleModel = GetVehicleModel(pData[playerid][pMechVeh]);

					if(pData[playerid][pActivityTime] > 5) return Error(playerid, "You already checking vehicle!");
					if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
					{
						if(pData[playerid][pComponent] < 70) return Error(playerid, "Component anda kurang!");
						if(VehicleModel == 562 ||
						VehicleModel == 565 ||
						VehicleModel == 559 ||
						VehicleModel == 561 ||
						VehicleModel == 558 ||
						VehicleModel == 560)
						{
							if(VehicleModel == 562)
							{
								pData[playerid][pMechColor1] = 1147;
								pData[playerid][pMechColor2] = 0;
							}
							if(VehicleModel == 565)
							{
								pData[playerid][pMechColor1] = 1049;
								pData[playerid][pMechColor2] = 0;
							}
							if(VehicleModel == 559)
							{
								pData[playerid][pMechColor1] = 1162;
								pData[playerid][pMechColor2] = 0;
							}
							if(VehicleModel == 561)
							{
								pData[playerid][pMechColor1] = 1058;
								pData[playerid][pMechColor2] = 0;
							}
							if(VehicleModel == 558)
							{
								pData[playerid][pMechColor1] = 1164;
								pData[playerid][pMechColor2] = 0;
							}
							if(VehicleModel == 560)
							{
								pData[playerid][pMechColor1] = 1138;
								pData[playerid][pMechColor2] = 0;
							}
							pData[playerid][pComponent] -= 70;
							Info(playerid, "Anda memodif kendaraan dengan "RED_E"70 component.");
							pData[playerid][pMechanic] = SetTimerEx("ModifCar", 1000, true, "id", playerid, pData[playerid][pMechVeh]);
							PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Modif Car...");
							PlayerTextDrawShow(playerid, ActiveTD[playerid]);
							ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
						}
						else return Error(playerid, "This vehicle is not supported!");
					}
					else
					{
						KillTimer(pData[playerid][pMechanic]);
						HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
						PlayerTextDrawHide(playerid, ActiveTD[playerid]);
						pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
						pData[playerid][pMechColor1] = 0;
						pData[playerid][pMechColor2] = 0;
						pData[playerid][pActivityTime] = 0;
						Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
						return 1;
					}
				}
				case 1:
				{
					new VehicleModel = GetVehicleModel(pData[playerid][pMechVeh]);

					if(pData[playerid][pActivityTime] > 5) return Error(playerid, "You already checking vehicle!");
					if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
					{
						if(pData[playerid][pComponent] < 70) return Error(playerid, "Component anda kurang!");
						if(VehicleModel == 562 ||
						VehicleModel == 565 ||
						VehicleModel == 559 ||
						VehicleModel == 561 ||
						VehicleModel == 558 ||
						VehicleModel == 560)
						{
							if(VehicleModel == 562)
							{
								pData[playerid][pMechColor1] = 1146;
								pData[playerid][pMechColor2] = 0;
							}
							if(VehicleModel == 565)
							{
								pData[playerid][pMechColor1] = 1050;
								pData[playerid][pMechColor2] = 0;
							}
							if(VehicleModel == 559)
							{
								pData[playerid][pMechColor1] = 1158;
								pData[playerid][pMechColor2] = 0;
							}
							if(VehicleModel == 561)
							{
								pData[playerid][pMechColor1] = 1060;
								pData[playerid][pMechColor2] = 0;
							}
							if(VehicleModel == 558)
							{
								pData[playerid][pMechColor1] = 1163;
								pData[playerid][pMechColor2] = 0;
							}
							if(VehicleModel == 560)
							{
								pData[playerid][pMechColor1] = 1139;
								pData[playerid][pMechColor2] = 0;
							}
							pData[playerid][pComponent] -= 70;
							Info(playerid, "Anda memodif kendaraan dengan "RED_E"70 component.");
							pData[playerid][pMechanic] = SetTimerEx("ModifCar", 1000, true, "id", playerid, pData[playerid][pMechVeh]);
							PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Modif Car...");
							PlayerTextDrawShow(playerid, ActiveTD[playerid]);
							ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
						}
						else return Error(playerid, "This vehicle is not supported!");
					}
					else
					{
						KillTimer(pData[playerid][pMechanic]);
						HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
						PlayerTextDrawHide(playerid, ActiveTD[playerid]);
						pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
						pData[playerid][pMechColor1] = 0;
						pData[playerid][pMechColor2] = 0;
						pData[playerid][pActivityTime] = 0;
						Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
						return 1;
					}
				}
				case 2:
				{
					new VehicleModel = GetVehicleModel(pData[playerid][pMechVeh]);

					if(pData[playerid][pActivityTime] > 5) return Error(playerid, "You already checking vehicle!");
					if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
					{
						if(pData[playerid][pComponent] < 70) return Error(playerid, "Component anda kurang!");
						if(VehicleModel == 401 ||
						VehicleModel == 518 ||
						VehicleModel == 527 ||
						VehicleModel == 415 ||
						VehicleModel == 546 ||
						VehicleModel == 603 ||
						VehicleModel == 426 ||
						VehicleModel == 436 ||
						VehicleModel == 405 ||
						VehicleModel == 477 ||
						VehicleModel == 580 ||
						VehicleModel == 550 ||
						VehicleModel == 549)
						{

							pData[playerid][pMechColor1] = 1001;
							pData[playerid][pMechColor2] = 0;

							pData[playerid][pComponent] -= 70;
							Info(playerid, "Anda memodif kendaraan dengan "RED_E"70 component.");
							pData[playerid][pMechanic] = SetTimerEx("ModifCar", 1000, true, "id", playerid, pData[playerid][pMechVeh]);
							PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Modif Car...");
							PlayerTextDrawShow(playerid, ActiveTD[playerid]);
							ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
						}
						else return Error(playerid, "This vehicle is not supported!");
					}
					else
					{
						KillTimer(pData[playerid][pMechanic]);
						HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
						PlayerTextDrawHide(playerid, ActiveTD[playerid]);
						pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
						pData[playerid][pMechColor1] = 0;
						pData[playerid][pMechColor2] = 0;
						pData[playerid][pActivityTime] = 0;
						Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
						return 1;
					}
				}
				case 3:
				{
					new VehicleModel = GetVehicleModel(pData[playerid][pMechVeh]);

					if(pData[playerid][pActivityTime] > 5) return Error(playerid, "You already checking vehicle!");
					if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
					{
						if(pData[playerid][pComponent] < 70) return Error(playerid, "Component anda kurang!");
						if(VehicleModel == 518 ||
						VehicleModel == 415 ||
						VehicleModel == 546 ||
						VehicleModel == 517 ||
						VehicleModel == 603 ||
						VehicleModel == 405 ||
						VehicleModel == 477 ||
						VehicleModel == 580 ||
						VehicleModel == 550 ||
						VehicleModel == 549)
						{

							pData[playerid][pMechColor1] = 1023;
							pData[playerid][pMechColor2] = 0;

							pData[playerid][pComponent] -= 70;
							Info(playerid, "Anda memodif kendaraan dengan "RED_E"70 component.");
							pData[playerid][pMechanic] = SetTimerEx("ModifCar", 1000, true, "id", playerid, pData[playerid][pMechVeh]);
							PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Modif Car...");
							PlayerTextDrawShow(playerid, ActiveTD[playerid]);
							ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
						}
						else return Error(playerid, "This vehicle is not supported!");
					}
					else
					{
						KillTimer(pData[playerid][pMechanic]);
						HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
						PlayerTextDrawHide(playerid, ActiveTD[playerid]);
						pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
						pData[playerid][pMechColor1] = 0;
						pData[playerid][pMechColor2] = 0;
						pData[playerid][pActivityTime] = 0;
						Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
						return 1;
					}
				}
				case 4:
				{
					new VehicleModel = GetVehicleModel(pData[playerid][pMechVeh]);

					if(pData[playerid][pActivityTime] > 5) return Error(playerid, "You already checking vehicle!");
					if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
					{
						if(pData[playerid][pComponent] < 70) return Error(playerid, "Component anda kurang!");
						if(VehicleModel == 518 ||
						VehicleModel == 415 ||
						VehicleModel == 401 ||
						VehicleModel == 517 ||
						VehicleModel == 426 ||
						VehicleModel == 436 ||
						VehicleModel == 477 ||
						VehicleModel == 547 ||
						VehicleModel == 550 ||
						VehicleModel == 549)
						{

							pData[playerid][pMechColor1] = 1003;
							pData[playerid][pMechColor2] = 0;

							pData[playerid][pComponent] -= 70;
							Info(playerid, "Anda memodif kendaraan dengan "RED_E"70 component.");
							pData[playerid][pMechanic] = SetTimerEx("ModifCar", 1000, true, "id", playerid, pData[playerid][pMechVeh]);
							PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Modif Car...");
							PlayerTextDrawShow(playerid, ActiveTD[playerid]);
							ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
						}
						else return Error(playerid, "This vehicle is not supported!");
					}
					else
					{
						KillTimer(pData[playerid][pMechanic]);
						HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
						PlayerTextDrawHide(playerid, ActiveTD[playerid]);
						pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
						pData[playerid][pMechColor1] = 0;
						pData[playerid][pMechColor2] = 0;
						pData[playerid][pActivityTime] = 0;
						Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
						return 1;
					}
				}
				case 5:
				{
					new VehicleModel = GetVehicleModel(pData[playerid][pMechVeh]);

					if(pData[playerid][pActivityTime] > 5) return Error(playerid, "You already checking vehicle!");
					if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
					{
						if(pData[playerid][pComponent] < 70) return Error(playerid, "Component anda kurang!");
						if(VehicleModel == 589 ||
						VehicleModel == 492 ||
						VehicleModel == 547 ||
						VehicleModel == 405)
						{

							pData[playerid][pMechColor1] = 1000;
							pData[playerid][pMechColor2] = 0;

							pData[playerid][pComponent] -= 70;
							Info(playerid, "Anda memodif kendaraan dengan "RED_E"70 component.");
							pData[playerid][pMechanic] = SetTimerEx("ModifCar", 1000, true, "id", playerid, pData[playerid][pMechVeh]);
							PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Modif Car...");
							PlayerTextDrawShow(playerid, ActiveTD[playerid]);
							ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
						}
						else return Error(playerid, "This vehicle is not supported!");
					}
					else
					{
						KillTimer(pData[playerid][pMechanic]);
						HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
						PlayerTextDrawHide(playerid, ActiveTD[playerid]);
						pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
						pData[playerid][pMechColor1] = 0;
						pData[playerid][pMechColor2] = 0;
						pData[playerid][pActivityTime] = 0;
						Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
						return 1;
					}
				}
				case 6:
				{
					new VehicleModel = GetVehicleModel(pData[playerid][pMechVeh]);

					if(pData[playerid][pActivityTime] > 5) return Error(playerid, "You already checking vehicle!");
					if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
					{
						if(pData[playerid][pComponent] < 70) return Error(playerid, "Component anda kurang!");
						if(VehicleModel == 527 ||
						VehicleModel == 542 ||
						VehicleModel == 405)
						{

							pData[playerid][pMechColor1] = 1014;
							pData[playerid][pMechColor2] = 0;

							pData[playerid][pComponent] -= 70;
							Info(playerid, "Anda memodif kendaraan dengan "RED_E"70 component.");
							pData[playerid][pMechanic] = SetTimerEx("ModifCar", 1000, true, "id", playerid, pData[playerid][pMechVeh]);
							PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Modif Car...");
							PlayerTextDrawShow(playerid, ActiveTD[playerid]);
							ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
						}
						else return Error(playerid, "This vehicle is not supported!");
					}
					else
					{
						KillTimer(pData[playerid][pMechanic]);
						HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
						PlayerTextDrawHide(playerid, ActiveTD[playerid]);
						pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
						pData[playerid][pMechColor1] = 0;
						pData[playerid][pMechColor2] = 0;
						pData[playerid][pActivityTime] = 0;
						Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
						return 1;
					}
				}
				case 7:
				{
					new VehicleModel = GetVehicleModel(pData[playerid][pMechVeh]);

					if(pData[playerid][pActivityTime] > 5) return Error(playerid, "You already checking vehicle!");
					if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
					{
						if(pData[playerid][pComponent] < 70) return Error(playerid, "Component anda kurang!");
						if(VehicleModel == 527 ||
						VehicleModel == 542)
						{

							pData[playerid][pMechColor1] = 1015;
							pData[playerid][pMechColor2] = 0;

							pData[playerid][pComponent] -= 70;
							Info(playerid, "Anda memodif kendaraan dengan "RED_E"70 component.");
							pData[playerid][pMechanic] = SetTimerEx("ModifCar", 1000, true, "id", playerid, pData[playerid][pMechVeh]);
							PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Modif Car...");
							PlayerTextDrawShow(playerid, ActiveTD[playerid]);
							ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
						}
						else return Error(playerid, "This vehicle is not supported!");
					}
					else
					{
						KillTimer(pData[playerid][pMechanic]);
						HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
						PlayerTextDrawHide(playerid, ActiveTD[playerid]);
						pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
						pData[playerid][pMechColor1] = 0;
						pData[playerid][pMechColor2] = 0;
						pData[playerid][pActivityTime] = 0;
						Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
						return 1;
					}
				}
				case 8:
				{
					new VehicleModel = GetVehicleModel(pData[playerid][pMechVeh]);

					if(pData[playerid][pActivityTime] > 5) return Error(playerid, "You already checking vehicle!");
					if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
					{
						if(pData[playerid][pComponent] < 70) return Error(playerid, "Component anda kurang!");
						if(VehicleModel == 546 ||
						VehicleModel == 517)
						{

							pData[playerid][pMechColor1] = 1002;
							pData[playerid][pMechColor2] = 0;

							pData[playerid][pComponent] -= 70;
							Info(playerid, "Anda memodif kendaraan dengan "RED_E"70 component.");
							pData[playerid][pMechanic] = SetTimerEx("ModifCar", 1000, true, "id", playerid, pData[playerid][pMechVeh]);
							PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Modif Car...");
							PlayerTextDrawShow(playerid, ActiveTD[playerid]);
							ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
						}
						else return Error(playerid, "This vehicle is not supported!");
					}
					else
					{
						KillTimer(pData[playerid][pMechanic]);
						HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
						PlayerTextDrawHide(playerid, ActiveTD[playerid]);
						pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
						pData[playerid][pMechColor1] = 0;
						pData[playerid][pMechColor2] = 0;
						pData[playerid][pActivityTime] = 0;
						Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
						return 1;
					}
				}
			}
		}
	}
	if(dialogid == DIALOG_SERVICE_HOODS)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
					new VehicleModel = GetVehicleModel(pData[playerid][pMechVeh]);

					if(pData[playerid][pActivityTime] > 5) return Error(playerid, "You already checking vehicle!");
					if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
					{
						if(pData[playerid][pComponent] < 70) return Error(playerid, "Component anda kurang!");
						if(
						VehicleModel == 401 ||
						VehicleModel == 518 ||
						VehicleModel == 589 ||
						VehicleModel == 492 ||
						VehicleModel == 426 ||
						VehicleModel == 550)
						{

							pData[playerid][pMechColor1] = 1005;
							pData[playerid][pMechColor2] = 0;

							pData[playerid][pComponent] -= 70;
							Info(playerid, "Anda memodif kendaraan dengan "RED_E"70 component.");
							pData[playerid][pMechanic] = SetTimerEx("ModifCar", 1000, true, "id", playerid, pData[playerid][pMechVeh]);
							PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Modif Car...");
							PlayerTextDrawShow(playerid, ActiveTD[playerid]);
							ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
						}
						else return Error(playerid, "This vehicle is not supported!");
					}
					else
					{
						KillTimer(pData[playerid][pMechanic]);
						HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
						PlayerTextDrawHide(playerid, ActiveTD[playerid]);
						pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
						pData[playerid][pMechColor1] = 0;
						pData[playerid][pMechColor2] = 0;
						pData[playerid][pActivityTime] = 0;
						Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
						return 1;
					}
				}
				case 1:
				{
					new VehicleModel = GetVehicleModel(pData[playerid][pMechVeh]);

					if(pData[playerid][pActivityTime] > 5) return Error(playerid, "You already checking vehicle!");
					if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
					{
						if(pData[playerid][pComponent] < 70) return Error(playerid, "Component anda kurang!");
						if(
						VehicleModel == 401 ||
						VehicleModel == 402 ||
						VehicleModel == 546 ||
						VehicleModel == 426 ||
						VehicleModel == 550)
						{

							pData[playerid][pMechColor1] = 1004;
							pData[playerid][pMechColor2] = 0;

							pData[playerid][pComponent] -= 70;
							Info(playerid, "Anda memodif kendaraan dengan "RED_E"70 component.");
							pData[playerid][pMechanic] = SetTimerEx("ModifCar", 1000, true, "id", playerid, pData[playerid][pMechVeh]);
							PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Modif Car...");
							PlayerTextDrawShow(playerid, ActiveTD[playerid]);
							ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
						}
						else return Error(playerid, "This vehicle is not supported!");
					}
					else
					{
						KillTimer(pData[playerid][pMechanic]);
						HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
						PlayerTextDrawHide(playerid, ActiveTD[playerid]);
						pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
						pData[playerid][pMechColor1] = 0;
						pData[playerid][pMechColor2] = 0;
						pData[playerid][pActivityTime] = 0;
						Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
						return 1;
					}
				}
				case 2:
				{
					new VehicleModel = GetVehicleModel(pData[playerid][pMechVeh]);

					if(pData[playerid][pActivityTime] > 5) return Error(playerid, "You already checking vehicle!");
					if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
					{
						if(pData[playerid][pComponent] < 70) return Error(playerid, "Component anda kurang!");
						if(VehicleModel == 401)
						{

							pData[playerid][pMechColor1] = 1011;
							pData[playerid][pMechColor2] = 0;

							pData[playerid][pComponent] -= 70;
							Info(playerid, "Anda memodif kendaraan dengan "RED_E"70 component.");
							pData[playerid][pMechanic] = SetTimerEx("ModifCar", 1000, true, "id", playerid, pData[playerid][pMechVeh]);
							PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Modif Car...");
							PlayerTextDrawShow(playerid, ActiveTD[playerid]);
							ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
						}
						else return Error(playerid, "This vehicle is not supported!");
					}
					else
					{
						KillTimer(pData[playerid][pMechanic]);
						HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
						PlayerTextDrawHide(playerid, ActiveTD[playerid]);
						pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
						pData[playerid][pMechColor1] = 0;
						pData[playerid][pMechColor2] = 0;
						pData[playerid][pActivityTime] = 0;
						Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
						return 1;
					}
				}
				case 3:
				{
					new VehicleModel = GetVehicleModel(pData[playerid][pMechVeh]);

					if(pData[playerid][pActivityTime] > 5) return Error(playerid, "You already checking vehicle!");
					if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
					{
						if(pData[playerid][pComponent] < 70) return Error(playerid, "Component anda kurang!");
						if(VehicleModel == 549)
						{

							pData[playerid][pMechColor1] = 1012;
							pData[playerid][pMechColor2] = 0;

							pData[playerid][pComponent] -= 70;
							Info(playerid, "Anda memodif kendaraan dengan "RED_E"70 component.");
							pData[playerid][pMechanic] = SetTimerEx("ModifCar", 1000, true, "id", playerid, pData[playerid][pMechVeh]);
							PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Modif Car...");
							PlayerTextDrawShow(playerid, ActiveTD[playerid]);
							ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
						}
						else return Error(playerid, "This vehicle is not supported!");
					}
					else
					{
						KillTimer(pData[playerid][pMechanic]);
						HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
						PlayerTextDrawHide(playerid, ActiveTD[playerid]);
						pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
						pData[playerid][pMechColor1] = 0;
						pData[playerid][pMechColor2] = 0;
						pData[playerid][pActivityTime] = 0;
						Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
						return 1;
					}
				}
			}
		}
		return 1;
	}
	if(dialogid == DIALOG_SERVICE_VENTS)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
					new VehicleModel = GetVehicleModel(pData[playerid][pMechVeh]);

					if(pData[playerid][pActivityTime] > 5) return Error(playerid, "You already checking vehicle!");
					if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
					{
						if(pData[playerid][pComponent] < 70) return Error(playerid, "Component anda kurang!");
						if(VehicleModel == 401 ||
						VehicleModel == 518 ||
						VehicleModel == 546 ||
						VehicleModel == 517 ||
						VehicleModel == 603 ||
						VehicleModel == 547 ||
						VehicleModel == 439 ||
						VehicleModel == 550 ||
						VehicleModel == 549)
						{

							pData[playerid][pMechColor1] = 1142;
							pData[playerid][pMechColor2] = 1143;

							pData[playerid][pComponent] -= 70;
							Info(playerid, "Anda memodif kendaraan dengan "RED_E"70 component.");
							pData[playerid][pMechanic] = SetTimerEx("ModifCar", 1000, true, "id", playerid, pData[playerid][pMechVeh]);
							PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Modif Car...");
							PlayerTextDrawShow(playerid, ActiveTD[playerid]);
							ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
						}
						else return Error(playerid, "This vehicle is not supported!");
					}
					else
					{
						KillTimer(pData[playerid][pMechanic]);
						HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
						PlayerTextDrawHide(playerid, ActiveTD[playerid]);
						pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
						pData[playerid][pMechColor1] = 0;
						pData[playerid][pMechColor2] = 0;
						pData[playerid][pActivityTime] = 0;
						Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
						return 1;
					}
				}
				case 1:
				{
					new VehicleModel = GetVehicleModel(pData[playerid][pMechVeh]);

					if(pData[playerid][pActivityTime] > 5) return Error(playerid, "You already checking vehicle!");
					if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
					{
						if(pData[playerid][pComponent] < 70) return Error(playerid, "Component anda kurang!");
						if(VehicleModel == 401 ||
						VehicleModel == 518 ||
						VehicleModel == 589 ||
						VehicleModel == 546 ||
						VehicleModel == 517 ||
						VehicleModel == 603 ||
						VehicleModel == 439 ||
						VehicleModel == 550 ||
						VehicleModel == 549)
						{

							pData[playerid][pMechColor1] = 1144;
							pData[playerid][pMechColor2] = 1145;

							pData[playerid][pComponent] -= 70;
							Info(playerid, "Anda memodif kendaraan dengan "RED_E"70 component.");
							pData[playerid][pMechanic] = SetTimerEx("ModifCar", 1000, true, "id", playerid, pData[playerid][pMechVeh]);
							PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Modif Car...");
							PlayerTextDrawShow(playerid, ActiveTD[playerid]);
							ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
						}
						else return Error(playerid, "This vehicle is not supported!");
					}
					else
					{
						KillTimer(pData[playerid][pMechanic]);
						HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
						PlayerTextDrawHide(playerid, ActiveTD[playerid]);
						pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
						pData[playerid][pMechColor1] = 0;
						pData[playerid][pMechColor2] = 0;
						pData[playerid][pActivityTime] = 0;
						Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
						return 1;
					}
				}
			}
		}
	}
	if(dialogid == DIALOG_SERVICE_LIGHTS)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
					new VehicleModel = GetVehicleModel(pData[playerid][pMechVeh]);

					if(pData[playerid][pActivityTime] > 5) return Error(playerid, "You already checking vehicle!");
					if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
					{
						if(pData[playerid][pComponent] < 70) return Error(playerid, "Component anda kurang!");
						if(VehicleModel == 401 ||
						VehicleModel == 518 ||
						VehicleModel == 589 ||
						VehicleModel == 400 ||
						VehicleModel == 436 ||
						VehicleModel == 439)
						{

							pData[playerid][pMechColor1] = 1013;
							pData[playerid][pMechColor2] = 0;

							pData[playerid][pComponent] -= 70;
							Info(playerid, "Anda memodif kendaraan dengan "RED_E"70 component.");
							pData[playerid][pMechanic] = SetTimerEx("ModifCar", 1000, true, "id", playerid, pData[playerid][pMechVeh]);
							PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Modif Car...");
							PlayerTextDrawShow(playerid, ActiveTD[playerid]);
							ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
						}
						else return Error(playerid, "This vehicle is not supported!");
					}
					else
					{
						KillTimer(pData[playerid][pMechanic]);
						HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
						PlayerTextDrawHide(playerid, ActiveTD[playerid]);
						pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
						pData[playerid][pMechColor1] = 0;
						pData[playerid][pMechColor2] = 0;
						pData[playerid][pActivityTime] = 0;
						Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
						return 1;
					}
				}
				case 1:
				{
					new VehicleModel = GetVehicleModel(pData[playerid][pMechVeh]);

					if(pData[playerid][pActivityTime] > 5) return Error(playerid, "You already checking vehicle!");
					if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
					{
						if(pData[playerid][pComponent] < 70) return Error(playerid, "Component anda kurang!");
						if(VehicleModel == 589 ||
						VehicleModel == 603 ||
						VehicleModel == 400)
						{

							pData[playerid][pMechColor1] = 1024;
							pData[playerid][pMechColor2] = 0;

							pData[playerid][pComponent] -= 70;
							Info(playerid, "Anda memodif kendaraan dengan "RED_E"70 component.");
							pData[playerid][pMechanic] = SetTimerEx("ModifCar", 1000, true, "id", playerid, pData[playerid][pMechVeh]);
							PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Modif Car...");
							PlayerTextDrawShow(playerid, ActiveTD[playerid]);
							ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
						}
						else return Error(playerid, "This vehicle is not supported!");
					}
					else
					{
						KillTimer(pData[playerid][pMechanic]);
						HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
						PlayerTextDrawHide(playerid, ActiveTD[playerid]);
						pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
						pData[playerid][pMechColor1] = 0;
						pData[playerid][pMechColor2] = 0;
						pData[playerid][pActivityTime] = 0;
						Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
						return 1;
					}
				}
			}
		}
		return 1;
	}
	if(dialogid == DIALOG_SERVICE_EXHAUSTS)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
					new VehicleModel = GetVehicleModel(pData[playerid][pMechVeh]);

					if(pData[playerid][pActivityTime] > 5) return Error(playerid, "You already checking vehicle!");
					if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
					{
						if(pData[playerid][pComponent] < 80) return Error(playerid, "Component anda kurang!");
						if(VehicleModel == 562 ||
						VehicleModel == 565 ||
						VehicleModel == 559 ||
						VehicleModel == 558 ||
						VehicleModel == 561 ||
						VehicleModel == 560)
						{
							if(VehicleModel == 562)
							{
								pData[playerid][pMechColor1] = 1034;
								pData[playerid][pMechColor2] = 0;
							}
							if(VehicleModel == 565)
							{
								pData[playerid][pMechColor1] = 1046;
								pData[playerid][pMechColor2] = 0;
							}
							if(VehicleModel == 559)
							{
								pData[playerid][pMechColor1] = 1065;
								pData[playerid][pMechColor2] = 0;
							}
							if(VehicleModel == 561)
							{
								pData[playerid][pMechColor1] = 1064;
								pData[playerid][pMechColor2] = 0;
							}
							if(VehicleModel == 560)
							{
								pData[playerid][pMechColor1] = 1028;
								pData[playerid][pMechColor2] = 0;
							}
							if(VehicleModel == 558)
							{
								pData[playerid][pMechColor1] = 1089;
								pData[playerid][pMechColor2] = 0;
							}
							pData[playerid][pComponent] -= 80;
							Info(playerid, "Anda memodif kendaraan dengan "RED_E"80 component.");
							pData[playerid][pMechanic] = SetTimerEx("ModifCar", 1000, true, "id", playerid, pData[playerid][pMechVeh]);
							PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Modif Car...");
							PlayerTextDrawShow(playerid, ActiveTD[playerid]);
							ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
						}
						else return Error(playerid, "This vehicle is not supported!");
					}
					else
					{
						KillTimer(pData[playerid][pMechanic]);
						HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
						PlayerTextDrawHide(playerid, ActiveTD[playerid]);
						pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
						pData[playerid][pMechColor1] = 0;
						pData[playerid][pMechColor2] = 0;
						pData[playerid][pActivityTime] = 0;
						Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
						return 1;
					}
				}
				case 1:
				{
					new VehicleModel = GetVehicleModel(pData[playerid][pMechVeh]);

					if(pData[playerid][pActivityTime] > 5) return Error(playerid, "You already checking vehicle!");
					if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
					{
						if(pData[playerid][pComponent] < 80) return Error(playerid, "Component anda kurang!");
						if(VehicleModel == 562 ||
						VehicleModel == 565 ||
						VehicleModel == 559 ||
						VehicleModel == 558 ||
						VehicleModel == 561 ||
						VehicleModel == 560)
						{
							if(VehicleModel == 562)
							{
								pData[playerid][pMechColor1] = 1037;
								pData[playerid][pMechColor2] = 0;
							}
							if(VehicleModel == 565)
							{
								pData[playerid][pMechColor1] = 1045;
								pData[playerid][pMechColor2] = 0;
							}
							if(VehicleModel == 559)
							{
								pData[playerid][pMechColor1] = 1066;
								pData[playerid][pMechColor2] = 0;
							}
							if(VehicleModel == 561)
							{
								pData[playerid][pMechColor1] = 1059;
								pData[playerid][pMechColor2] = 0;
							}
							if(VehicleModel == 560)
							{
								pData[playerid][pMechColor1] = 1029;
								pData[playerid][pMechColor2] = 0;
							}
							if(VehicleModel == 558)
							{
								pData[playerid][pMechColor1] = 1092;
								pData[playerid][pMechColor2] = 0;
							}
							pData[playerid][pComponent] -= 80;
							Info(playerid, "Anda memodif kendaraan dengan "RED_E"80 component.");
							pData[playerid][pMechanic] = SetTimerEx("ModifCar", 1000, true, "id", playerid, pData[playerid][pMechVeh]);
							PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Modif Car...");
							PlayerTextDrawShow(playerid, ActiveTD[playerid]);
							ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
						}
						else return Error(playerid, "This vehicle is not supported!");
					}
					else
					{
						KillTimer(pData[playerid][pMechanic]);
						HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
						PlayerTextDrawHide(playerid, ActiveTD[playerid]);
						pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
						pData[playerid][pMechColor1] = 0;
						pData[playerid][pMechColor2] = 0;
						pData[playerid][pActivityTime] = 0;
						Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
						return 1;
					}
				}
				case 2:
				{
					new VehicleModel = GetVehicleModel(pData[playerid][pMechVeh]);

					if(pData[playerid][pActivityTime] > 5) return Error(playerid, "You already checking vehicle!");
					if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
					{
						if(pData[playerid][pComponent] < 80) return Error(playerid, "Component anda kurang!");
						if(VehicleModel == 575 ||
						VehicleModel == 534 ||
						VehicleModel == 567 ||
						VehicleModel == 536 ||
						VehicleModel == 576 ||
						VehicleModel == 535)
						{
							if(VehicleModel == 575)
							{
								pData[playerid][pMechColor1] = 1044;
								pData[playerid][pMechColor2] = 0;
							}
							if(VehicleModel == 534)
							{
								pData[playerid][pMechColor1] = 1126;
								pData[playerid][pMechColor2] = 0;
							}
							if(VehicleModel == 567)
							{
								pData[playerid][pMechColor1] = 1129;
								pData[playerid][pMechColor2] = 0;
							}
							if(VehicleModel == 536)
							{
								pData[playerid][pMechColor1] = 1104;
								pData[playerid][pMechColor2] = 0;
							}
							if(VehicleModel == 576)
							{
								pData[playerid][pMechColor1] = 1113;
								pData[playerid][pMechColor2] = 0;
							}
							if(VehicleModel == 535)
							{
								pData[playerid][pMechColor1] = 1136;
								pData[playerid][pMechColor2] = 0;
							}
							pData[playerid][pComponent] -= 80;
							Info(playerid, "Anda memodif kendaraan dengan "RED_E"80 component.");
							pData[playerid][pMechanic] = SetTimerEx("ModifCar", 1000, true, "id", playerid, pData[playerid][pMechVeh]);
							PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Modif Car...");
							PlayerTextDrawShow(playerid, ActiveTD[playerid]);
							ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
						}
						else return Error(playerid, "This vehicle is not supported!");
					}
					else
					{
						KillTimer(pData[playerid][pMechanic]);
						HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
						PlayerTextDrawHide(playerid, ActiveTD[playerid]);
						pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
						pData[playerid][pMechColor1] = 0;
						pData[playerid][pMechColor2] = 0;
						pData[playerid][pActivityTime] = 0;
						Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
						return 1;
					}
				}
				case 3:
				{
					new VehicleModel = GetVehicleModel(pData[playerid][pMechVeh]);

					if(pData[playerid][pActivityTime] > 5) return Error(playerid, "You already checking vehicle!");
					if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
					{
						if(pData[playerid][pComponent] < 80) return Error(playerid, "Component anda kurang!");
						if(VehicleModel == 575 ||
						VehicleModel == 534 ||
						VehicleModel == 567 ||
						VehicleModel == 536 ||
						VehicleModel == 576 ||
						VehicleModel == 535)
						{
							if(VehicleModel == 575)
							{
								pData[playerid][pMechColor1] = 1043;
								pData[playerid][pMechColor2] = 0;
							}
							if(VehicleModel == 534)
							{
								pData[playerid][pMechColor1] = 1127;
								pData[playerid][pMechColor2] = 0;
							}
							if(VehicleModel == 567)
							{
								pData[playerid][pMechColor1] = 1132;
								pData[playerid][pMechColor2] = 0;
							}
							if(VehicleModel == 536)
							{
								pData[playerid][pMechColor1] = 1105;
								pData[playerid][pMechColor2] = 0;
							}
							if(VehicleModel == 576)
							{
								pData[playerid][pMechColor1] = 1135;
								pData[playerid][pMechColor2] = 0;
							}
							if(VehicleModel == 535)
							{
								pData[playerid][pMechColor1] = 1114;
								pData[playerid][pMechColor2] = 0;
							}
							pData[playerid][pComponent] -= 80;
							Info(playerid, "Anda memodif kendaraan dengan "RED_E"80 component.");
							pData[playerid][pMechanic] = SetTimerEx("ModifCar", 1000, true, "id", playerid, pData[playerid][pMechVeh]);
							PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Modif Car...");
							PlayerTextDrawShow(playerid, ActiveTD[playerid]);
							ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
						}
						else return Error(playerid, "This vehicle is not supported!");
					}
					else
					{
						KillTimer(pData[playerid][pMechanic]);
						HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
						PlayerTextDrawHide(playerid, ActiveTD[playerid]);
						pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
						pData[playerid][pMechColor1] = 0;
						pData[playerid][pMechColor2] = 0;
						pData[playerid][pActivityTime] = 0;
						Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
						return 1;
					}
				}
				case 4:
				{
					new VehicleModel = GetVehicleModel(pData[playerid][pMechVeh]);

					if(pData[playerid][pActivityTime] > 5) return Error(playerid, "You already checking vehicle!");
					if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
					{
						if(pData[playerid][pComponent] < 80) return Error(playerid, "Component anda kurang!");
						if(
						VehicleModel == 401 ||
						VehicleModel == 518 ||
						VehicleModel == 527 ||
						VehicleModel == 542 ||
						VehicleModel == 589 ||
						VehicleModel == 400 ||
						VehicleModel == 517 ||
						VehicleModel == 603 ||
						VehicleModel == 426 ||
						VehicleModel == 547 ||
						VehicleModel == 405 ||
						VehicleModel == 580 ||
						VehicleModel == 550 ||
						VehicleModel == 549 ||
						VehicleModel == 477)
						{

							pData[playerid][pMechColor1] = 1020;
							pData[playerid][pMechColor2] = 0;

							pData[playerid][pComponent] -= 80;
							Info(playerid, "Anda memodif kendaraan dengan "RED_E"80 component.");
							pData[playerid][pMechanic] = SetTimerEx("ModifCar", 1000, true, "id", playerid, pData[playerid][pMechVeh]);
							PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Modif Car...");
							PlayerTextDrawShow(playerid, ActiveTD[playerid]);
							ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
						}
						else return Error(playerid, "This vehicle is not supported!");
					}
					else
					{
						KillTimer(pData[playerid][pMechanic]);
						HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
						PlayerTextDrawHide(playerid, ActiveTD[playerid]);
						pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
						pData[playerid][pMechColor1] = 0;
						pData[playerid][pMechColor2] = 0;
						pData[playerid][pActivityTime] = 0;
						Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
						return 1;
					}
				}
				case 5:
				{
					new VehicleModel = GetVehicleModel(pData[playerid][pMechVeh]);

					if(pData[playerid][pActivityTime] > 5) return Error(playerid, "You already checking vehicle!");
					if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
					{
						if(pData[playerid][pComponent] < 80) return Error(playerid, "Component anda kurang!");
						if(
						VehicleModel == 527 ||
						VehicleModel == 542 ||
						VehicleModel == 400 ||
						VehicleModel == 426 ||
						VehicleModel == 436 ||
						VehicleModel == 547 ||
						VehicleModel == 405 ||
						VehicleModel == 477)
						{

							pData[playerid][pMechColor1] = 1021;
							pData[playerid][pMechColor2] = 0;

							pData[playerid][pComponent] -= 80;
							Info(playerid, "Anda memodif kendaraan dengan "RED_E"80 component.");
							pData[playerid][pMechanic] = SetTimerEx("ModifCar", 1000, true, "id", playerid, pData[playerid][pMechVeh]);
							PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Modif Car...");
							PlayerTextDrawShow(playerid, ActiveTD[playerid]);
							ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
						}
						else return Error(playerid, "This vehicle is not supported!");
					}
					else
					{
						KillTimer(pData[playerid][pMechanic]);
						HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
						PlayerTextDrawHide(playerid, ActiveTD[playerid]);
						pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
						pData[playerid][pMechColor1] = 0;
						pData[playerid][pMechColor2] = 0;
						pData[playerid][pActivityTime] = 0;
						Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
						return 1;
					}
				}
				case 6:
				{
					new VehicleModel = GetVehicleModel(pData[playerid][pMechVeh]);

					if(pData[playerid][pActivityTime] > 5) return Error(playerid, "You already checking vehicle!");
					if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
					{
						if(pData[playerid][pComponent] < 80) return Error(playerid, "Component anda kurang!");
						if(VehicleModel == 436)
						{

							pData[playerid][pMechColor1] = 1022;
							pData[playerid][pMechColor2] = 0;

							pData[playerid][pComponent] -= 80;
							Info(playerid, "Anda memodif kendaraan dengan "RED_E"80 component.");
							pData[playerid][pMechanic] = SetTimerEx("ModifCar", 1000, true, "id", playerid, pData[playerid][pMechVeh]);
							PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Modif Car...");
							PlayerTextDrawShow(playerid, ActiveTD[playerid]);
							ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
						}
						else return Error(playerid, "This vehicle is not supported!");
					}
					else
					{
						KillTimer(pData[playerid][pMechanic]);
						HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
						PlayerTextDrawHide(playerid, ActiveTD[playerid]);
						pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
						pData[playerid][pMechColor1] = 0;
						pData[playerid][pMechColor2] = 0;
						pData[playerid][pActivityTime] = 0;
						Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
						return 1;
					}
				}
				case 7:
				{
					new VehicleModel = GetVehicleModel(pData[playerid][pMechVeh]);

					if(pData[playerid][pActivityTime] > 5) return Error(playerid, "You already checking vehicle!");
					if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
					{
						if(pData[playerid][pComponent] < 80) return Error(playerid, "Component anda kurang!");
						if(
						VehicleModel == 518 ||
						VehicleModel == 415 ||
						VehicleModel == 542 ||
						VehicleModel == 546 ||
						VehicleModel == 400 ||
						VehicleModel == 517 ||
						VehicleModel == 603 ||
						VehicleModel == 426 ||
						VehicleModel == 436 ||
						VehicleModel == 547 ||
						VehicleModel == 405 ||
						VehicleModel == 550 ||
						VehicleModel == 549 ||
						VehicleModel == 477)
						{

							pData[playerid][pMechColor1] = 1019;
							pData[playerid][pMechColor2] = 0;

							pData[playerid][pComponent] -= 80;
							Info(playerid, "Anda memodif kendaraan dengan "RED_E"80 component.");
							pData[playerid][pMechanic] = SetTimerEx("ModifCar", 1000, true, "id", playerid, pData[playerid][pMechVeh]);
							PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Modif Car...");
							PlayerTextDrawShow(playerid, ActiveTD[playerid]);
							ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
						}
						else return Error(playerid, "This vehicle is not supported!");
					}
					else
					{
						KillTimer(pData[playerid][pMechanic]);
						HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
						PlayerTextDrawHide(playerid, ActiveTD[playerid]);
						pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
						pData[playerid][pMechColor1] = 0;
						pData[playerid][pMechColor2] = 0;
						pData[playerid][pActivityTime] = 0;
						Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
						return 1;
					}
				}
				case 8:
				{
					new VehicleModel = GetVehicleModel(pData[playerid][pMechVeh]);

					if(pData[playerid][pActivityTime] > 5) return Error(playerid, "You already checking vehicle!");
					if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
					{
						if(pData[playerid][pComponent] < 80) return Error(playerid, "Component anda kurang!");
						if(
						VehicleModel == 401 ||
						VehicleModel == 518 ||
						VehicleModel == 415 ||
						VehicleModel == 542 ||
						VehicleModel == 546 ||
						VehicleModel == 400 ||
						VehicleModel == 517 ||
						VehicleModel == 603 ||
						VehicleModel == 426 ||
						VehicleModel == 415 ||
						VehicleModel == 547 ||
						VehicleModel == 405 ||
						VehicleModel == 550 ||
						VehicleModel == 549 ||
						VehicleModel == 477)
						{

							pData[playerid][pMechColor1] = 1018;
							pData[playerid][pMechColor2] = 0;

							pData[playerid][pComponent] -= 80;
							Info(playerid, "Anda memodif kendaraan dengan "RED_E"80 component.");
							pData[playerid][pMechanic] = SetTimerEx("ModifCar", 1000, true, "id", playerid, pData[playerid][pMechVeh]);
							PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Modif Car...");
							PlayerTextDrawShow(playerid, ActiveTD[playerid]);
							ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
						}
						else return Error(playerid, "This vehicle is not supported!");
					}
					else
					{
						KillTimer(pData[playerid][pMechanic]);
						HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
						PlayerTextDrawHide(playerid, ActiveTD[playerid]);
						pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
						pData[playerid][pMechColor1] = 0;
						pData[playerid][pMechColor2] = 0;
						pData[playerid][pActivityTime] = 0;
						Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
						return 1;
					}
				}
			}
		}
		return 1;
	}
	if(dialogid == DIALOG_SERVICE_FRONT_BUMPERS)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
					new VehicleModel = GetVehicleModel(pData[playerid][pMechVeh]);

					if(pData[playerid][pActivityTime] > 5) return Error(playerid, "You already checking vehicle!");
					if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
					{
						if(pData[playerid][pComponent] < 100) return Error(playerid, "Component anda kurang!");
						if(VehicleModel == 562 ||
						VehicleModel == 565 ||
						VehicleModel == 559 ||
						VehicleModel == 561 ||
						VehicleModel == 558 ||
						VehicleModel == 560)
						{
							if(VehicleModel == 562)
							{
								pData[playerid][pMechColor1] = 1171;
								pData[playerid][pMechColor2] = 0;
							}
							if(VehicleModel == 565)
							{
								pData[playerid][pMechColor1] = 1153;
								pData[playerid][pMechColor2] = 0;
							}
							if(VehicleModel == 559)
							{
								pData[playerid][pMechColor1] = 1160;
								pData[playerid][pMechColor2] = 0;
							}
							if(VehicleModel == 561)
							{
								pData[playerid][pMechColor1] = 1155;
								pData[playerid][pMechColor2] = 0;
							}
							if(VehicleModel == 558)
							{
								pData[playerid][pMechColor1] = 1166;
								pData[playerid][pMechColor2] = 0;
							}
							if(VehicleModel == 560)
							{
								pData[playerid][pMechColor1] = 1169;
								pData[playerid][pMechColor2] = 0;
							}

							pData[playerid][pComponent] -= 100;
							Info(playerid, "Anda memodif kendaraan dengan "RED_E"100 component.");
							pData[playerid][pMechanic] = SetTimerEx("ModifCar", 1000, true, "id", playerid, pData[playerid][pMechVeh]);
							PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Modif Car...");
							PlayerTextDrawShow(playerid, ActiveTD[playerid]);
							ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
						}
						else return Error(playerid, "This vehicle is not supported!");
					}
					else
					{
						KillTimer(pData[playerid][pMechanic]);
						HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
						PlayerTextDrawHide(playerid, ActiveTD[playerid]);
						pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
						pData[playerid][pMechColor1] = 0;
						pData[playerid][pMechColor2] = 0;
						pData[playerid][pActivityTime] = 0;
						Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
						return 1;
					}
				}
				case 1:
				{
					new VehicleModel = GetVehicleModel(pData[playerid][pMechVeh]);

					if(pData[playerid][pActivityTime] > 5) return Error(playerid, "You already checking vehicle!");
					if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
					{
						if(pData[playerid][pComponent] < 100) return Error(playerid, "Component anda kurang!");
						if(VehicleModel == 562 ||
						VehicleModel == 565 ||
						VehicleModel == 559 ||
						VehicleModel == 561 ||
						VehicleModel == 558 ||
						VehicleModel == 560)
						{
							if(VehicleModel == 562)
							{
								pData[playerid][pMechColor1] = 1172;
								pData[playerid][pMechColor2] = 0;
							}
							if(VehicleModel == 565)
							{
								pData[playerid][pMechColor1] = 1152;
								pData[playerid][pMechColor2] = 0;
							}
							if(VehicleModel == 559)
							{
								pData[playerid][pMechColor1] = 1173;
								pData[playerid][pMechColor2] = 0;
							}
							if(VehicleModel == 561)
							{
								pData[playerid][pMechColor1] = 1157;
								pData[playerid][pMechColor2] = 0;
							}
							if(VehicleModel == 558)
							{
								pData[playerid][pMechColor1] = 1165;
								pData[playerid][pMechColor2] = 0;
							}
							if(VehicleModel == 560)
							{
								pData[playerid][pMechColor1] = 1170;
								pData[playerid][pMechColor2] = 0;
							}

							pData[playerid][pComponent] -= 100;
							Info(playerid, "Anda memodif kendaraan dengan "RED_E"100 component.");
							pData[playerid][pMechanic] = SetTimerEx("ModifCar", 1000, true, "id", playerid, pData[playerid][pMechVeh]);
							PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Modif Car...");
							PlayerTextDrawShow(playerid, ActiveTD[playerid]);
							ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
						}
						else return Error(playerid, "This vehicle is not supported!");
					}
					else
					{
						KillTimer(pData[playerid][pMechanic]);
						HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
						PlayerTextDrawHide(playerid, ActiveTD[playerid]);
						pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
						pData[playerid][pMechColor1] = 0;
						pData[playerid][pMechColor2] = 0;
						pData[playerid][pActivityTime] = 0;
						Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
						return 1;
					}
				}
				case 2:
				{
					new VehicleModel = GetVehicleModel(pData[playerid][pMechVeh]);

					if(pData[playerid][pActivityTime] > 5) return Error(playerid, "You already checking vehicle!");
					if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
					{
						if(pData[playerid][pComponent] < 100) return Error(playerid, "Component anda kurang!");
						if(VehicleModel == 575 ||
						VehicleModel == 534 ||
						VehicleModel == 567 ||
						VehicleModel == 536 ||
						VehicleModel == 576 ||
						VehicleModel == 535)
						{
							if(VehicleModel == 575)
							{
								pData[playerid][pMechColor1] = 1174;
								pData[playerid][pMechColor2] = 0;
							}
							if(VehicleModel == 534)
							{
								pData[playerid][pMechColor1] = 1179;
								pData[playerid][pMechColor2] = 0;
							}
							if(VehicleModel == 567)
							{
								pData[playerid][pMechColor1] = 1189;
								pData[playerid][pMechColor2] = 0;
							}
							if(VehicleModel == 536)
							{
								pData[playerid][pMechColor1] = 1182;
								pData[playerid][pMechColor2] = 0;
							}
							if(VehicleModel == 576)
							{
								pData[playerid][pMechColor1] = 1191;
								pData[playerid][pMechColor2] = 0;
							}
							if(VehicleModel == 535)
							{
								pData[playerid][pMechColor1] = 1115;
								pData[playerid][pMechColor2] = 0;
							}

							pData[playerid][pComponent] -= 100;
							Info(playerid, "Anda memodif kendaraan dengan "RED_E"100 component.");
							pData[playerid][pMechanic] = SetTimerEx("ModifCar", 1000, true, "id", playerid, pData[playerid][pMechVeh]);
							PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Modif Car...");
							PlayerTextDrawShow(playerid, ActiveTD[playerid]);
							ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
						}
						else return Error(playerid, "This vehicle is not supported!");
					}
					else
					{
						KillTimer(pData[playerid][pMechanic]);
						HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
						PlayerTextDrawHide(playerid, ActiveTD[playerid]);
						pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
						pData[playerid][pMechColor1] = 0;
						pData[playerid][pMechColor2] = 0;
						pData[playerid][pActivityTime] = 0;
						Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
						return 1;
					}
				}
				case 3:
				{
					new VehicleModel = GetVehicleModel(pData[playerid][pMechVeh]);

					if(pData[playerid][pActivityTime] > 5) return Error(playerid, "You already checking vehicle!");
					if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
					{
						if(pData[playerid][pComponent] < 100) return Error(playerid, "Component anda kurang!");
						if(VehicleModel == 575 ||
						VehicleModel == 534 ||
						VehicleModel == 567 ||
						VehicleModel == 536 ||
						VehicleModel == 576 ||
						VehicleModel == 535)
						{
							if(VehicleModel == 575)
							{
								pData[playerid][pMechColor1] = 1175;
								pData[playerid][pMechColor2] = 0;
							}
							if(VehicleModel == 534)
							{
								pData[playerid][pMechColor1] = 1185;
								pData[playerid][pMechColor2] = 0;
							}
							if(VehicleModel == 567)
							{
								pData[playerid][pMechColor1] = 1188;
								pData[playerid][pMechColor2] = 0;
							}
							if(VehicleModel == 536)
							{
								pData[playerid][pMechColor1] = 1181;
								pData[playerid][pMechColor2] = 0;
							}
							if(VehicleModel == 576)
							{
								pData[playerid][pMechColor1] = 1190;
								pData[playerid][pMechColor2] = 0;
							}
							if(VehicleModel == 535)
							{
								pData[playerid][pMechColor1] = 1116;
								pData[playerid][pMechColor2] = 0;
							}

							pData[playerid][pComponent] -= 100;
							Info(playerid, "Anda memodif kendaraan dengan "RED_E"100 component.");
							pData[playerid][pMechanic] = SetTimerEx("ModifCar", 1000, true, "id", playerid, pData[playerid][pMechVeh]);
							PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Modif Car...");
							PlayerTextDrawShow(playerid, ActiveTD[playerid]);
							ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
						}
						else return Error(playerid, "This vehicle is not supported!");
					}
					else
					{
						KillTimer(pData[playerid][pMechanic]);
						HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
						PlayerTextDrawHide(playerid, ActiveTD[playerid]);
						pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
						pData[playerid][pMechColor1] = 0;
						pData[playerid][pMechColor2] = 0;
						pData[playerid][pActivityTime] = 0;
						Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
						return 1;
					}
				}
			}
		}
		return 1;
	}
	if(dialogid == DIALOG_SERVICE_REAR_BUMPERS)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
					new VehicleModel = GetVehicleModel(pData[playerid][pMechVeh]);

					if(pData[playerid][pActivityTime] > 5) return Error(playerid, "You already checking vehicle!");
					if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
					{
						if(pData[playerid][pComponent] < 100) return Error(playerid, "Component anda kurang!");
						if(VehicleModel == 562 ||
						VehicleModel == 565 ||
						VehicleModel == 559 ||
						VehicleModel == 561 ||
						VehicleModel == 558 ||
						VehicleModel == 560)
						{
							if(VehicleModel == 562)
							{
								pData[playerid][pMechColor1] = 1149;
								pData[playerid][pMechColor2] = 0;
							}
							if(VehicleModel == 565)
							{
								pData[playerid][pMechColor1] = 1150;
								pData[playerid][pMechColor2] = 0;
							}
							if(VehicleModel == 559)
							{
								pData[playerid][pMechColor1] = 1159;
								pData[playerid][pMechColor2] = 0;
							}
							if(VehicleModel == 561)
							{
								pData[playerid][pMechColor1] = 1154;
								pData[playerid][pMechColor2] = 0;
							}
							if(VehicleModel == 558)
							{
								pData[playerid][pMechColor1] = 1168;
								pData[playerid][pMechColor2] = 0;
							}
							if(VehicleModel == 560)
							{
								pData[playerid][pMechColor1] = 1141;
								pData[playerid][pMechColor2] = 0;
							}

							pData[playerid][pComponent] -= 100;
							Info(playerid, "Anda memodif kendaraan dengan "RED_E"100 component.");
							pData[playerid][pMechanic] = SetTimerEx("ModifCar", 1000, true, "id", playerid, pData[playerid][pMechVeh]);
							PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Modif Car...");
							PlayerTextDrawShow(playerid, ActiveTD[playerid]);
							ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
						}
						else return Error(playerid, "This vehicle is not supported!");
					}
					else
					{
						KillTimer(pData[playerid][pMechanic]);
						HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
						PlayerTextDrawHide(playerid, ActiveTD[playerid]);
						pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
						pData[playerid][pMechColor1] = 0;
						pData[playerid][pMechColor2] = 0;
						pData[playerid][pActivityTime] = 0;
						Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
						return 1;
					}
				}
				case 1:
				{
					new VehicleModel = GetVehicleModel(pData[playerid][pMechVeh]);

					if(pData[playerid][pActivityTime] > 5) return Error(playerid, "You already checking vehicle!");
					if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
					{
						if(pData[playerid][pComponent] < 100) return Error(playerid, "Component anda kurang!");
						if(VehicleModel == 562 ||
						VehicleModel == 565 ||
						VehicleModel == 559 ||
						VehicleModel == 561 ||
						VehicleModel == 558 ||
						VehicleModel == 560)
						{
							if(VehicleModel == 562)
							{
								pData[playerid][pMechColor1] = 1148;
								pData[playerid][pMechColor2] = 0;
							}
							if(VehicleModel == 565)
							{
								pData[playerid][pMechColor1] = 1151;
								pData[playerid][pMechColor2] = 0;
							}
							if(VehicleModel == 559)
							{
								pData[playerid][pMechColor1] = 1161;
								pData[playerid][pMechColor2] = 0;
							}
							if(VehicleModel == 561)
							{
								pData[playerid][pMechColor1] = 1156;
								pData[playerid][pMechColor2] = 0;
							}
							if(VehicleModel == 558)
							{
								pData[playerid][pMechColor1] = 1167;
								pData[playerid][pMechColor2] = 0;
							}
							if(VehicleModel == 560)
							{
								pData[playerid][pMechColor1] = 1140;
								pData[playerid][pMechColor2] = 0;
							}

							pData[playerid][pComponent] -= 100;
							Info(playerid, "Anda memodif kendaraan dengan "RED_E"100 component.");
							pData[playerid][pMechanic] = SetTimerEx("ModifCar", 1000, true, "id", playerid, pData[playerid][pMechVeh]);
							PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Modif Car...");
							PlayerTextDrawShow(playerid, ActiveTD[playerid]);
							ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
						}
						else return Error(playerid, "This vehicle is not supported!");
					}
					else
					{
						KillTimer(pData[playerid][pMechanic]);
						HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
						PlayerTextDrawHide(playerid, ActiveTD[playerid]);
						pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
						pData[playerid][pMechColor1] = 0;
						pData[playerid][pMechColor2] = 0;
						pData[playerid][pActivityTime] = 0;
						Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
						return 1;
					}
				}
				case 2:
				{
					new VehicleModel = GetVehicleModel(pData[playerid][pMechVeh]);

					if(pData[playerid][pActivityTime] > 5) return Error(playerid, "You already checking vehicle!");
					if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
					{
						if(pData[playerid][pComponent] < 100) return Error(playerid, "Component anda kurang!");
						if(VehicleModel == 575 ||
						VehicleModel == 534 ||
						VehicleModel == 567 ||
						VehicleModel == 536 ||
						VehicleModel == 576 ||
						VehicleModel == 535)
						{
							if(VehicleModel == 575)
							{
								pData[playerid][pMechColor1] = 1176;
								pData[playerid][pMechColor2] = 0;
							}
							if(VehicleModel == 534)
							{
								pData[playerid][pMechColor1] = 1180;
								pData[playerid][pMechColor2] = 0;
							}
							if(VehicleModel == 567)
							{
								pData[playerid][pMechColor1] = 1187;
								pData[playerid][pMechColor2] = 0;
							}
							if(VehicleModel == 536)
							{
								pData[playerid][pMechColor1] = 1184;
								pData[playerid][pMechColor2] = 0;
							}
							if(VehicleModel == 576)
							{
								pData[playerid][pMechColor1] = 1192;
								pData[playerid][pMechColor2] = 0;
							}
							if(VehicleModel == 535)
							{
								pData[playerid][pMechColor1] = 1109;
								pData[playerid][pMechColor2] = 0;
							}

							pData[playerid][pComponent] -= 100;
							Info(playerid, "Anda memodif kendaraan dengan "RED_E"100 component.");
							pData[playerid][pMechanic] = SetTimerEx("ModifCar", 1000, true, "id", playerid, pData[playerid][pMechVeh]);
							PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Modif Car...");
							PlayerTextDrawShow(playerid, ActiveTD[playerid]);
							ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
						}
						else return Error(playerid, "This vehicle is not supported!");
					}
					else
					{
						KillTimer(pData[playerid][pMechanic]);
						HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
						PlayerTextDrawHide(playerid, ActiveTD[playerid]);
						pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
						pData[playerid][pMechColor1] = 0;
						pData[playerid][pMechColor2] = 0;
						pData[playerid][pActivityTime] = 0;
						Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
						return 1;
					}
				}
				case 3:
				{
					new VehicleModel = GetVehicleModel(pData[playerid][pMechVeh]);

					if(pData[playerid][pActivityTime] > 5) return Error(playerid, "You already checking vehicle!");
					if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
					{
						if(pData[playerid][pComponent] < 100) return Error(playerid, "Component anda kurang!");
						if(VehicleModel == 575 ||
						VehicleModel == 534 ||
						VehicleModel == 567 ||
						VehicleModel == 536 ||
						VehicleModel == 576 ||
						VehicleModel == 535)
						{
							if(VehicleModel == 575)
							{
								pData[playerid][pMechColor1] = 1177;
								pData[playerid][pMechColor2] = 0;
							}
							if(VehicleModel == 534)
							{
								pData[playerid][pMechColor1] = 1178;
								pData[playerid][pMechColor2] = 0;
							}
							if(VehicleModel == 567)
							{
								pData[playerid][pMechColor1] = 1186;
								pData[playerid][pMechColor2] = 0;
							}
							if(VehicleModel == 536)
							{
								pData[playerid][pMechColor1] = 1183;
								pData[playerid][pMechColor2] = 0;
							}
							if(VehicleModel == 576)
							{
								pData[playerid][pMechColor1] = 1193;
								pData[playerid][pMechColor2] = 0;
							}
							if(VehicleModel == 535)
							{
								pData[playerid][pMechColor1] = 1110;
								pData[playerid][pMechColor2] = 0;
							}

							pData[playerid][pComponent] -= 100;
							Info(playerid, "Anda memodif kendaraan dengan "RED_E"100 component.");
							pData[playerid][pMechanic] = SetTimerEx("ModifCar", 1000, true, "id", playerid, pData[playerid][pMechVeh]);
							PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Modif Car...");
							PlayerTextDrawShow(playerid, ActiveTD[playerid]);
							ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
						}
						else return Error(playerid, "This vehicle is not supported!");
					}
					else
					{
						KillTimer(pData[playerid][pMechanic]);
						HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
						PlayerTextDrawHide(playerid, ActiveTD[playerid]);
						pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
						pData[playerid][pMechColor1] = 0;
						pData[playerid][pMechColor2] = 0;
						pData[playerid][pActivityTime] = 0;
						Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
						return 1;
					}
				}
			}
		}
		return 1;
	}
	if(dialogid == DIALOG_SERVICE_ROOFS)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
					new VehicleModel = GetVehicleModel(pData[playerid][pMechVeh]);

					if(pData[playerid][pActivityTime] > 5) return Error(playerid, "You already checking vehicle!");
					if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
					{
						if(pData[playerid][pComponent] < 70) return Error(playerid, "Component anda kurang!");
						if(VehicleModel == 562 ||
						VehicleModel == 565 ||
						VehicleModel == 559 ||
						VehicleModel == 561 ||
						VehicleModel == 558 ||
						VehicleModel == 560)
						{
							if(VehicleModel == 562)
							{
								pData[playerid][pMechColor1] = 1038;
								pData[playerid][pMechColor2] = 0;
							}
							if(VehicleModel == 565)
							{
								pData[playerid][pMechColor1] = 1054;
								pData[playerid][pMechColor2] = 0;
							}
							if(VehicleModel == 559)
							{
								pData[playerid][pMechColor1] = 1067;
								pData[playerid][pMechColor2] = 0;
							}
							if(VehicleModel == 561)
							{
								pData[playerid][pMechColor1] = 1055;
								pData[playerid][pMechColor2] = 0;
							}
							if(VehicleModel == 558)
							{
								pData[playerid][pMechColor1] = 1088;
								pData[playerid][pMechColor2] = 0;
							}
							if(VehicleModel == 560)
							{
								pData[playerid][pMechColor1] = 1032;
								pData[playerid][pMechColor2] = 0;
							}

							pData[playerid][pComponent] -= 70;
							Info(playerid, "Anda memodif kendaraan dengan "RED_E"70 component.");
							pData[playerid][pMechanic] = SetTimerEx("ModifCar", 1000, true, "id", playerid, pData[playerid][pMechVeh]);
							PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Modif Car...");
							PlayerTextDrawShow(playerid, ActiveTD[playerid]);
							ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
						}
						else return Error(playerid, "This vehicle is not supported!");
					}
					else
					{
						KillTimer(pData[playerid][pMechanic]);
						HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
						PlayerTextDrawHide(playerid, ActiveTD[playerid]);
						pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
						pData[playerid][pMechColor1] = 0;
						pData[playerid][pMechColor2] = 0;
						pData[playerid][pActivityTime] = 0;
						Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
						return 1;
					}
				}
				case 1:
				{
					new VehicleModel = GetVehicleModel(pData[playerid][pMechVeh]);

					if(pData[playerid][pActivityTime] > 5) return Error(playerid, "You already checking vehicle!");
					if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
					{
						if(pData[playerid][pComponent] < 70) return Error(playerid, "Component anda kurang!");
						if(VehicleModel == 562 ||
						VehicleModel == 565 ||
						VehicleModel == 559 ||
						VehicleModel == 561 ||
						VehicleModel == 558 ||
						VehicleModel == 560)
						{
							if(VehicleModel == 562)
							{
								pData[playerid][pMechColor1] = 1038;
								pData[playerid][pMechColor2] = 0;
							}
							if(VehicleModel == 565)
							{
								pData[playerid][pMechColor1] = 1053;
								pData[playerid][pMechColor2] = 0;
							}
							if(VehicleModel == 559)
							{
								pData[playerid][pMechColor1] = 1068;
								pData[playerid][pMechColor2] = 0;
							}
							if(VehicleModel == 561)
							{
								pData[playerid][pMechColor1] = 1061;
								pData[playerid][pMechColor2] = 0;
							}
							if(VehicleModel == 558)
							{
								pData[playerid][pMechColor1] = 1091;
								pData[playerid][pMechColor2] = 0;
							}
							if(VehicleModel == 560)
							{
								pData[playerid][pMechColor1] = 1033;
								pData[playerid][pMechColor2] = 0;
							}

							pData[playerid][pComponent] -= 70;
							Info(playerid, "Anda memodif kendaraan dengan "RED_E"70 component.");
							pData[playerid][pMechanic] = SetTimerEx("ModifCar", 1000, true, "id", playerid, pData[playerid][pMechVeh]);
							PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Modif Car...");
							PlayerTextDrawShow(playerid, ActiveTD[playerid]);
							ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
						}
						else return Error(playerid, "This vehicle is not supported!");
					}
					else
					{
						KillTimer(pData[playerid][pMechanic]);
						HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
						PlayerTextDrawHide(playerid, ActiveTD[playerid]);
						pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
						pData[playerid][pMechColor1] = 0;
						pData[playerid][pMechColor2] = 0;
						pData[playerid][pActivityTime] = 0;
						Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
						return 1;
					}
				}
				case 2:
				{
					new VehicleModel = GetVehicleModel(pData[playerid][pMechVeh]);

					if(pData[playerid][pActivityTime] > 5) return Error(playerid, "You already checking vehicle!");
					if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
					{
						if(pData[playerid][pComponent] < 70) return Error(playerid, "Component anda kurang!");
						if(VehicleModel == 567 ||
						VehicleModel == 536)
						{
							if(VehicleModel == 567)
							{
								pData[playerid][pMechColor1] = 1130;
								pData[playerid][pMechColor2] = 0;
							}
							if(VehicleModel == 536)
							{
								pData[playerid][pMechColor1] = 1128;
								pData[playerid][pMechColor2] = 0;
							}

							pData[playerid][pComponent] -= 70;
							Info(playerid, "Anda memodif kendaraan dengan "RED_E"70 component.");
							pData[playerid][pMechanic] = SetTimerEx("ModifCar", 1000, true, "id", playerid, pData[playerid][pMechVeh]);
							PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Modif Car...");
							PlayerTextDrawShow(playerid, ActiveTD[playerid]);
							ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
						}
						else return Error(playerid, "This vehicle is not supported!");
					}
					else
					{
						KillTimer(pData[playerid][pMechanic]);
						HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
						PlayerTextDrawHide(playerid, ActiveTD[playerid]);
						pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
						pData[playerid][pMechColor1] = 0;
						pData[playerid][pMechColor2] = 0;
						pData[playerid][pActivityTime] = 0;
						Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
						return 1;
					}
				}
				case 3:
				{
					new VehicleModel = GetVehicleModel(pData[playerid][pMechVeh]);

					if(pData[playerid][pActivityTime] > 5) return Error(playerid, "You already checking vehicle!");
					if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
					{
						if(pData[playerid][pComponent] < 70) return Error(playerid, "Component anda kurang!");
						if(VehicleModel == 567 ||
						VehicleModel == 536)
						{
							if(VehicleModel == 567)
							{
								pData[playerid][pMechColor1] = 1131;
								pData[playerid][pMechColor2] = 0;
							}
							if(VehicleModel == 536)
							{
								pData[playerid][pMechColor1] = 1103;
								pData[playerid][pMechColor2] = 0;
							}

							pData[playerid][pComponent] -= 70;
							Info(playerid, "Anda memodif kendaraan dengan "RED_E"70 component.");
							pData[playerid][pMechanic] = SetTimerEx("ModifCar", 1000, true, "id", playerid, pData[playerid][pMechVeh]);
							PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Modif Car...");
							PlayerTextDrawShow(playerid, ActiveTD[playerid]);
							ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
						}
						else return Error(playerid, "This vehicle is not supported!");
					}
					else
					{
						KillTimer(pData[playerid][pMechanic]);
						HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
						PlayerTextDrawHide(playerid, ActiveTD[playerid]);
						pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
						pData[playerid][pMechColor1] = 0;
						pData[playerid][pMechColor2] = 0;
						pData[playerid][pActivityTime] = 0;
						Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
						return 1;
					}
				}
				case 4:
				{
					new VehicleModel = GetVehicleModel(pData[playerid][pMechVeh]);

					if(pData[playerid][pActivityTime] > 5) return Error(playerid, "You already checking vehicle!");
					if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
					{
						if(pData[playerid][pComponent] < 70) return Error(playerid, "Component anda kurang!");
						if(
						VehicleModel == 401 ||
						VehicleModel == 518 ||
						VehicleModel == 589 ||
						VehicleModel == 492 ||
						VehicleModel == 546 ||
						VehicleModel == 603 ||
						VehicleModel == 426 ||
						VehicleModel == 436 ||
						VehicleModel == 580 ||
						VehicleModel == 550 ||
						VehicleModel == 477)
						{

							pData[playerid][pMechColor1] = 1006;
							pData[playerid][pMechColor2] = 0;

							pData[playerid][pComponent] -= 70;
							Info(playerid, "Anda memodif kendaraan dengan "RED_E"70 component.");
							pData[playerid][pMechanic] = SetTimerEx("ModifCar", 1000, true, "id", playerid, pData[playerid][pMechVeh]);
							PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Modif Car...");
							PlayerTextDrawShow(playerid, ActiveTD[playerid]);
							ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
						}
						else return Error(playerid, "This vehicle is not supported!");
					}
					else
					{
						KillTimer(pData[playerid][pMechanic]);
						HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
						PlayerTextDrawHide(playerid, ActiveTD[playerid]);
						pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
						pData[playerid][pMechColor1] = 0;
						pData[playerid][pMechColor2] = 0;
						pData[playerid][pActivityTime] = 0;
						Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
						return 1;
					}
				}
			}
		}
		return 1;
	}
	if(dialogid == DIALOG_SERVICE_SIDE_SKIRTS)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
					new VehicleModel = GetVehicleModel(pData[playerid][pMechVeh]);

					if(pData[playerid][pActivityTime] > 5) return Error(playerid, "You already checking vehicle!");
					if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
					{
						if(pData[playerid][pComponent] < 90) return Error(playerid, "Component anda kurang!");
						if(VehicleModel == 562 ||
						VehicleModel == 565 ||
						VehicleModel == 559 ||
						VehicleModel == 561 ||
						VehicleModel == 558 ||
						VehicleModel == 560)
						{
							if(VehicleModel == 562)
							{
								pData[playerid][pMechColor1] = 1036;
								pData[playerid][pMechColor2] = 1040;
							}
							if(VehicleModel == 565)
							{
								pData[playerid][pMechColor1] = 1047;
								pData[playerid][pMechColor2] = 1051;
							}
							if(VehicleModel == 559)
							{
								pData[playerid][pMechColor1] = 1069;
								pData[playerid][pMechColor2] = 1071;
							}
							if(VehicleModel == 561)
							{
								pData[playerid][pMechColor1] = 1056;
								pData[playerid][pMechColor2] = 1062;
							}
							if(VehicleModel == 558)
							{
								pData[playerid][pMechColor1] = 1090;
								pData[playerid][pMechColor2] = 1094;
							}
							if(VehicleModel == 560)
							{
								pData[playerid][pMechColor1] = 1026;
								pData[playerid][pMechColor2] = 1027;
							}

							pData[playerid][pComponent] -= 90;
							Info(playerid, "Anda memodif kendaraan dengan "RED_E"90 component.");
							pData[playerid][pMechanic] = SetTimerEx("ModifCar", 1000, true, "id", playerid, pData[playerid][pMechVeh]);
							PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Modif Car...");
							PlayerTextDrawShow(playerid, ActiveTD[playerid]);
							ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
						}
						else return Error(playerid, "This vehicle is not supported!");
					}
					else
					{
						KillTimer(pData[playerid][pMechanic]);
						HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
						PlayerTextDrawHide(playerid, ActiveTD[playerid]);
						pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
						pData[playerid][pMechColor1] = 0;
						pData[playerid][pMechColor2] = 0;
						pData[playerid][pActivityTime] = 0;
						Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
						return 1;
					}
				}
				case 1:
				{
					new VehicleModel = GetVehicleModel(pData[playerid][pMechVeh]);

					if(pData[playerid][pActivityTime] > 5) return Error(playerid, "You already checking vehicle!");
					if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
					{
						if(pData[playerid][pComponent] < 90) return Error(playerid, "Component anda kurang!");
						if(VehicleModel == 562 ||
						VehicleModel == 565 ||
						VehicleModel == 559 ||
						VehicleModel == 561 ||
						VehicleModel == 558 ||
						VehicleModel == 560)
						{
							if(VehicleModel == 562)
							{
								pData[playerid][pMechColor1] = 1039;
								pData[playerid][pMechColor2] = 1041;
							}
							if(VehicleModel == 565)
							{
								pData[playerid][pMechColor1] = 1048;
								pData[playerid][pMechColor2] = 1052;
							}
							if(VehicleModel == 559)
							{
								pData[playerid][pMechColor1] = 1070;
								pData[playerid][pMechColor2] = 1072;
							}
							if(VehicleModel == 561)
							{
								pData[playerid][pMechColor1] = 1057;
								pData[playerid][pMechColor2] = 1063;
							}
							if(VehicleModel == 558)
							{
								pData[playerid][pMechColor1] = 1093;
								pData[playerid][pMechColor2] = 1095;
							}
							if(VehicleModel == 560)
							{
								pData[playerid][pMechColor1] = 1031;
								pData[playerid][pMechColor2] = 1030;
							}

							pData[playerid][pComponent] -= 90;
							Info(playerid, "Anda memodif kendaraan dengan "RED_E"90 component.");
							pData[playerid][pMechanic] = SetTimerEx("ModifCar", 1000, true, "id", playerid, pData[playerid][pMechVeh]);
							PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Modif Car...");
							PlayerTextDrawShow(playerid, ActiveTD[playerid]);
							ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
						}
						else return Error(playerid, "This vehicle is not supported!");
					}
					else
					{
						KillTimer(pData[playerid][pMechanic]);
						HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
						PlayerTextDrawHide(playerid, ActiveTD[playerid]);
						pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
						pData[playerid][pMechColor1] = 0;
						pData[playerid][pMechColor2] = 0;
						pData[playerid][pActivityTime] = 0;
						Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
						return 1;
					}
				}
				case 2:
				{
					new VehicleModel = GetVehicleModel(pData[playerid][pMechVeh]);

					if(pData[playerid][pActivityTime] > 5) return Error(playerid, "You already checking vehicle!");
					if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
					{
						if(pData[playerid][pComponent] < 90) return Error(playerid, "Component anda kurang!");
						if(VehicleModel == 575 ||
						VehicleModel == 536 ||
						VehicleModel == 576 ||
						VehicleModel == 567)
						{
							if(VehicleModel == 575)
							{
								pData[playerid][pMechColor1] = 1042;
								pData[playerid][pMechColor2] = 1099;
							}
							if(VehicleModel == 536)
							{
								pData[playerid][pMechColor1] = 1108;
								pData[playerid][pMechColor2] = 1107;
							}
							if(VehicleModel == 576)
							{
								pData[playerid][pMechColor1] = 1134;
								pData[playerid][pMechColor2] = 1137;
							}
							if(VehicleModel == 567)
							{
								pData[playerid][pMechColor1] = 1102;
								pData[playerid][pMechColor2] = 1133;
							}

							pData[playerid][pComponent] -= 90;
							Info(playerid, "Anda memodif kendaraan dengan "RED_E"90 component.");
							pData[playerid][pMechanic] = SetTimerEx("ModifCar", 1000, true, "id", playerid, pData[playerid][pMechVeh]);
							PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Modif Car...");
							PlayerTextDrawShow(playerid, ActiveTD[playerid]);
							ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
						}
						else return Error(playerid, "This vehicle is not supported!");
					}
					else
					{
						KillTimer(pData[playerid][pMechanic]);
						HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
						PlayerTextDrawHide(playerid, ActiveTD[playerid]);
						pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
						pData[playerid][pMechColor1] = 0;
						pData[playerid][pMechColor2] = 0;
						pData[playerid][pActivityTime] = 0;
						Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
						return 1;
					}
				}
				case 3:
				{
					new VehicleModel = GetVehicleModel(pData[playerid][pMechVeh]);

					if(pData[playerid][pActivityTime] > 5) return Error(playerid, "You already checking vehicle!");
					if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
					{
						if(pData[playerid][pComponent] < 90) return Error(playerid, "Component anda kurang!");
						if(VehicleModel == 534)
						{

							pData[playerid][pMechColor1] = 1102;
							pData[playerid][pMechColor2] = 1101;

							pData[playerid][pComponent] -= 90;
							Info(playerid, "Anda memodif kendaraan dengan "RED_E"90 component.");
							pData[playerid][pMechanic] = SetTimerEx("ModifCar", 1000, true, "id", playerid, pData[playerid][pMechVeh]);
							PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Modif Car...");
							PlayerTextDrawShow(playerid, ActiveTD[playerid]);
							ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
						}
						else return Error(playerid, "This vehicle is not supported!");
					}
					else
					{
						KillTimer(pData[playerid][pMechanic]);
						HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
						PlayerTextDrawHide(playerid, ActiveTD[playerid]);
						pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
						pData[playerid][pMechColor1] = 0;
						pData[playerid][pMechColor2] = 0;
						pData[playerid][pActivityTime] = 0;
						Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
						return 1;
					}
				}
				case 4:
				{
					new VehicleModel = GetVehicleModel(pData[playerid][pMechVeh]);

					if(pData[playerid][pActivityTime] > 5) return Error(playerid, "You already checking vehicle!");
					if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
					{
						if(pData[playerid][pComponent] < 90) return Error(playerid, "Component anda kurang!");
						if(VehicleModel == 534)
						{

							pData[playerid][pMechColor1] = 1106;
							pData[playerid][pMechColor2] = 1124;

							pData[playerid][pComponent] -= 90;
							Info(playerid, "Anda memodif kendaraan dengan "RED_E"90 component.");
							pData[playerid][pMechanic] = SetTimerEx("ModifCar", 1000, true, "id", playerid, pData[playerid][pMechVeh]);
							PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Modif Car...");
							PlayerTextDrawShow(playerid, ActiveTD[playerid]);
							ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
						}
						else return Error(playerid, "This vehicle is not supported!");
					}
					else
					{
						KillTimer(pData[playerid][pMechanic]);
						HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
						PlayerTextDrawHide(playerid, ActiveTD[playerid]);
						pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
						pData[playerid][pMechColor1] = 0;
						pData[playerid][pMechColor2] = 0;
						pData[playerid][pActivityTime] = 0;
						Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
						return 1;
					}
				}
				case 5:
				{
					new VehicleModel = GetVehicleModel(pData[playerid][pMechVeh]);

					if(pData[playerid][pActivityTime] > 5) return Error(playerid, "You already checking vehicle!");
					if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
					{
						if(pData[playerid][pComponent] < 90) return Error(playerid, "Component anda kurang!");
						if(VehicleModel == 535)
						{

							pData[playerid][pMechColor1] = 1118;
							pData[playerid][pMechColor2] = 1120;

							pData[playerid][pComponent] -= 90;
							Info(playerid, "Anda memodif kendaraan dengan "RED_E"90 component.");
							pData[playerid][pMechanic] = SetTimerEx("ModifCar", 1000, true, "id", playerid, pData[playerid][pMechVeh]);
							PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Modif Car...");
							PlayerTextDrawShow(playerid, ActiveTD[playerid]);
							ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
						}
						else return Error(playerid, "This vehicle is not supported!");
					}
					else
					{
						KillTimer(pData[playerid][pMechanic]);
						HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
						PlayerTextDrawHide(playerid, ActiveTD[playerid]);
						pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
						pData[playerid][pMechColor1] = 0;
						pData[playerid][pMechColor2] = 0;
						pData[playerid][pActivityTime] = 0;
						Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
						return 1;
					}
				}
				case 6:
				{
					new VehicleModel = GetVehicleModel(pData[playerid][pMechVeh]);

					if(pData[playerid][pActivityTime] > 5) return Error(playerid, "You already checking vehicle!");
					if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
					{
						if(pData[playerid][pComponent] < 90) return Error(playerid, "Component anda kurang!");
						if(VehicleModel == 535)
						{

							pData[playerid][pMechColor1] = 1119;
							pData[playerid][pMechColor2] = 1121;

							pData[playerid][pComponent] -= 90;
							Info(playerid, "Anda memodif kendaraan dengan "RED_E"90 component.");
							pData[playerid][pMechanic] = SetTimerEx("ModifCar", 1000, true, "id", playerid, pData[playerid][pMechVeh]);
							PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Modif Car...");
							PlayerTextDrawShow(playerid, ActiveTD[playerid]);
							ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
						}
						else return Error(playerid, "This vehicle is not supported!");
					}
					else
					{
						KillTimer(pData[playerid][pMechanic]);
						HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
						PlayerTextDrawHide(playerid, ActiveTD[playerid]);
						pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
						pData[playerid][pMechColor1] = 0;
						pData[playerid][pMechColor2] = 0;
						pData[playerid][pActivityTime] = 0;
						Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
						return 1;
					}
				}
				case 7:
				{
					new VehicleModel = GetVehicleModel(pData[playerid][pMechVeh]);

					if(pData[playerid][pActivityTime] > 5) return Error(playerid, "You already checking vehicle!");
					if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
					{
						if(pData[playerid][pComponent] < 90) return Error(playerid, "Component anda kurang!");
						if(
						VehicleModel == 401 ||
						VehicleModel == 518 ||
						VehicleModel == 527 ||
						VehicleModel == 415 ||
						VehicleModel == 589 ||
						VehicleModel == 546 ||
						VehicleModel == 517 ||
						VehicleModel == 603 ||
						VehicleModel == 436 ||
						VehicleModel == 439 ||
						VehicleModel == 580 ||
						VehicleModel == 549 ||
						VehicleModel == 477)
						{

							pData[playerid][pMechColor1] = 1007;
							pData[playerid][pMechColor2] = 1017;

							pData[playerid][pComponent] -= 90;
							Info(playerid, "Anda memodif kendaraan dengan "RED_E"90 component.");
							pData[playerid][pMechanic] = SetTimerEx("ModifCar", 1000, true, "id", playerid, pData[playerid][pMechVeh]);
							PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Modif Car...");
							PlayerTextDrawShow(playerid, ActiveTD[playerid]);
							ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
						}
						else return Error(playerid, "This vehicle is not supported!");
					}
					else
					{
						KillTimer(pData[playerid][pMechanic]);
						HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
						PlayerTextDrawHide(playerid, ActiveTD[playerid]);
						pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
						pData[playerid][pMechColor1] = 0;
						pData[playerid][pMechColor2] = 0;
						pData[playerid][pActivityTime] = 0;
						Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
						return 1;
					}
				}
			}
		}
		return 1;
	}
	if(dialogid == DIALOG_SERVICE_BULLBARS)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
					new VehicleModel = GetVehicleModel(pData[playerid][pMechVeh]);

					if(pData[playerid][pActivityTime] > 5) return Error(playerid, "You already checking vehicle!");
					if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
					{
						if(pData[playerid][pComponent] < 50) return Error(playerid, "Component anda kurang!");
						if(VehicleModel == 534)
						{

							pData[playerid][pMechColor1] = 1100;
							pData[playerid][pMechColor2] = 0;

							pData[playerid][pComponent] -= 50;
							Info(playerid, "Anda memodif kendaraan dengan "RED_E"50 component.");
							pData[playerid][pMechanic] = SetTimerEx("ModifCar", 1000, true, "id", playerid, pData[playerid][pMechVeh]);
							PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Modif Car...");
							PlayerTextDrawShow(playerid, ActiveTD[playerid]);
							ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
						}
						else return Error(playerid, "This vehicle is not supported!");
					}
					else
					{
						KillTimer(pData[playerid][pMechanic]);
						HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
						PlayerTextDrawHide(playerid, ActiveTD[playerid]);
						pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
						pData[playerid][pMechColor1] = 0;
						pData[playerid][pMechColor2] = 0;
						pData[playerid][pActivityTime] = 0;
						Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
						return 1;
					}
				}
				case 1:
				{
					new VehicleModel = GetVehicleModel(pData[playerid][pMechVeh]);

					if(pData[playerid][pActivityTime] > 5) return Error(playerid, "You already checking vehicle!");
					if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
					{
						if(pData[playerid][pComponent] < 50) return Error(playerid, "Component anda kurang!");
						if(VehicleModel == 534)
						{

							pData[playerid][pMechColor1] = 1123;
							pData[playerid][pMechColor2] = 0;

							pData[playerid][pComponent] -= 50;
							Info(playerid, "Anda memodif kendaraan dengan "RED_E"50 component.");
							pData[playerid][pMechanic] = SetTimerEx("ModifCar", 1000, true, "id", playerid, pData[playerid][pMechVeh]);
							PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Modif Car...");
							PlayerTextDrawShow(playerid, ActiveTD[playerid]);
							ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
						}
						else return Error(playerid, "This vehicle is not supported!");
					}
					else
					{
						KillTimer(pData[playerid][pMechanic]);
						HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
						PlayerTextDrawHide(playerid, ActiveTD[playerid]);
						pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
						pData[playerid][pMechColor1] = 0;
						pData[playerid][pMechColor2] = 0;
						pData[playerid][pActivityTime] = 0;
						Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
						return 1;
					}
				}
				case 2:
				{
					new VehicleModel = GetVehicleModel(pData[playerid][pMechVeh]);

					if(pData[playerid][pActivityTime] > 5) return Error(playerid, "You already checking vehicle!");
					if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
					{
						if(pData[playerid][pComponent] < 50) return Error(playerid, "Component anda kurang!");
						if(VehicleModel == 534)
						{

							pData[playerid][pMechColor1] = 1125;
							pData[playerid][pMechColor2] = 0;

							pData[playerid][pComponent] -= 50;
							Info(playerid, "Anda memodif kendaraan dengan "RED_E"50 component.");
							pData[playerid][pMechanic] = SetTimerEx("ModifCar", 1000, true, "id", playerid, pData[playerid][pMechVeh]);
							PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Modif Car...");
							PlayerTextDrawShow(playerid, ActiveTD[playerid]);
							ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
						}
						else return Error(playerid, "This vehicle is not supported!");
					}
					else
					{
						KillTimer(pData[playerid][pMechanic]);
						HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
						PlayerTextDrawHide(playerid, ActiveTD[playerid]);
						pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
						pData[playerid][pMechColor1] = 0;
						pData[playerid][pMechColor2] = 0;
						pData[playerid][pActivityTime] = 0;
						Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
						return 1;
					}
				}
				case 3:
				{
					new VehicleModel = GetVehicleModel(pData[playerid][pMechVeh]);

					if(pData[playerid][pActivityTime] > 5) return Error(playerid, "You already checking vehicle!");
					if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
					{
						if(pData[playerid][pComponent] < 50) return Error(playerid, "Component anda kurang!");
						if(VehicleModel == 534)
						{

							pData[playerid][pMechColor1] = 1117;
							pData[playerid][pMechColor2] = 0;

							pData[playerid][pComponent] -= 50;
							Info(playerid, "Anda memodif kendaraan dengan "RED_E"50 component.");
							pData[playerid][pMechanic] = SetTimerEx("ModifCar", 1000, true, "id", playerid, pData[playerid][pMechVeh]);
							PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Modif Car...");
							PlayerTextDrawShow(playerid, ActiveTD[playerid]);
							ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
						}
						else return Error(playerid, "This vehicle is not supported!");
					}
					else
					{
						KillTimer(pData[playerid][pMechanic]);
						HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
						PlayerTextDrawHide(playerid, ActiveTD[playerid]);
						pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
						pData[playerid][pMechColor1] = 0;
						pData[playerid][pMechColor2] = 0;
						pData[playerid][pActivityTime] = 0;
						Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
						return 1;
					}
				}
			}
		}
		return 1;
	}
	if(dialogid == DIALOG_SERVICE_NEON)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
					pData[playerid][pMechColor1] = RED_NEON;

					if(pData[playerid][pActivityTime] > 5) return Error(playerid, "You already checking vehicle!");
					if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
					{
						if(pData[playerid][pComponent] < 450) return Error(playerid, "Component anda kurang!");
						pData[playerid][pComponent] -= 450;
						Info(playerid, "Anda memodif kendaraan dengan "RED_E"450 component.");
						pData[playerid][pMechanic] = SetTimerEx("NeonCar", 1000, true, "id", playerid, pData[playerid][pMechVeh]);
						PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Neon Car...");
						PlayerTextDrawShow(playerid, ActiveTD[playerid]);
						ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
					}
					else
					{
						KillTimer(pData[playerid][pMechanic]);
						HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
						PlayerTextDrawHide(playerid, ActiveTD[playerid]);
						pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
						pData[playerid][pMechColor1] = 0;
						pData[playerid][pMechColor2] = 0;
						pData[playerid][pActivityTime] = 0;
						Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
						return 1;
					}
				}
				case 1:
				{
					pData[playerid][pMechColor1] = BLUE_NEON;

					if(pData[playerid][pActivityTime] > 5) return Error(playerid, "You already checking vehicle!");
					if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
					{
						if(pData[playerid][pComponent] < 450) return Error(playerid, "Component anda kurang!");
						pData[playerid][pComponent] -= 450;
						Info(playerid, "Anda memodif kendaraan dengan "RED_E"450 component.");
						pData[playerid][pMechanic] = SetTimerEx("NeonCar", 1000, true, "id", playerid, pData[playerid][pMechVeh]);
						PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Neon Car...");
						PlayerTextDrawShow(playerid, ActiveTD[playerid]);
						ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
					}
					else
					{
						KillTimer(pData[playerid][pMechanic]);
						HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
						PlayerTextDrawHide(playerid, ActiveTD[playerid]);
						pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
						pData[playerid][pMechColor1] = 0;
						pData[playerid][pMechColor2] = 0;
						pData[playerid][pActivityTime] = 0;
						Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
						return 1;
					}
				}
				case 2:
				{
					pData[playerid][pMechColor1] = GREEN_NEON;

					if(pData[playerid][pActivityTime] > 5) return Error(playerid, "You already checking vehicle!");
					if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
					{
						if(pData[playerid][pComponent] < 450) return Error(playerid, "Component anda kurang!");
						pData[playerid][pComponent] -= 450;
						Info(playerid, "Anda memodif kendaraan dengan "RED_E"450 component.");
						pData[playerid][pMechanic] = SetTimerEx("NeonCar", 1000, true, "id", playerid, pData[playerid][pMechVeh]);
						PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Neon Car...");
						PlayerTextDrawShow(playerid, ActiveTD[playerid]);
						ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
					}
					else
					{
						KillTimer(pData[playerid][pMechanic]);
						HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
						PlayerTextDrawHide(playerid, ActiveTD[playerid]);
						pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
						pData[playerid][pMechColor1] = 0;
						pData[playerid][pMechColor2] = 0;
						pData[playerid][pActivityTime] = 0;
						Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
						return 1;
					}
				}
				case 3:
				{
					pData[playerid][pMechColor1] = YELLOW_NEON;

					if(pData[playerid][pActivityTime] > 5) return Error(playerid, "You already checking vehicle!");
					if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
					{
						if(pData[playerid][pComponent] < 450) return Error(playerid, "Component anda kurang!");
						pData[playerid][pComponent] -= 450;
						Info(playerid, "Anda memodif kendaraan dengan "RED_E"450 component.");
						pData[playerid][pMechanic] = SetTimerEx("NeonCar", 1000, true, "id", playerid, pData[playerid][pMechVeh]);
						PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Neon Car...");
						PlayerTextDrawShow(playerid, ActiveTD[playerid]);
						ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
					}
					else
					{
						KillTimer(pData[playerid][pMechanic]);
						HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
						PlayerTextDrawHide(playerid, ActiveTD[playerid]);
						pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
						pData[playerid][pMechColor1] = 0;
						pData[playerid][pMechColor2] = 0;
						pData[playerid][pActivityTime] = 0;
						Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
						return 1;
					}
				}
				case 4:
				{
					pData[playerid][pMechColor1] = PINK_NEON;

					if(pData[playerid][pActivityTime] > 5) return Error(playerid, "You already checking vehicle!");
					if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
					{
						if(pData[playerid][pComponent] < 450) return Error(playerid, "Component anda kurang!");
						pData[playerid][pComponent] -= 450;
						Info(playerid, "Anda memodif kendaraan dengan "RED_E"450 component.");
						pData[playerid][pMechanic] = SetTimerEx("NeonCar", 1000, true, "id", playerid, pData[playerid][pMechVeh]);
						PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Neon Car...");
						PlayerTextDrawShow(playerid, ActiveTD[playerid]);
						ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
					}
					else
					{
						KillTimer(pData[playerid][pMechanic]);
						HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
						PlayerTextDrawHide(playerid, ActiveTD[playerid]);
						pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
						pData[playerid][pMechColor1] = 0;
						pData[playerid][pMechColor2] = 0;
						pData[playerid][pActivityTime] = 0;
						Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
						return 1;
					}
				}
				case 5:
				{
					pData[playerid][pMechColor1] = WHITE_NEON;

					if(pData[playerid][pActivityTime] > 5) return Error(playerid, "You already checking vehicle!");
					if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
					{
						if(pData[playerid][pComponent] < 450) return Error(playerid, "Component anda kurang!");
						pData[playerid][pComponent] -= 450;
						Info(playerid, "Anda memodif kendaraan dengan "RED_E"450 component.");
						pData[playerid][pMechanic] = SetTimerEx("NeonCar", 1000, true, "id", playerid, pData[playerid][pMechVeh]);
						PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Neon Car...");
						PlayerTextDrawShow(playerid, ActiveTD[playerid]);
						ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
					}
					else
					{
						KillTimer(pData[playerid][pMechanic]);
						HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
						PlayerTextDrawHide(playerid, ActiveTD[playerid]);
						pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
						pData[playerid][pMechColor1] = 0;
						pData[playerid][pMechColor2] = 0;
						pData[playerid][pActivityTime] = 0;
						Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
						return 1;
					}
				}
				case 6:
				{
					pData[playerid][pMechColor1] = 0;

					if(pData[playerid][pActivityTime] > 5) return Error(playerid, "You already checking vehicle!");
					if(GetNearestVehicleToPlayer(playerid, 3.8, false) == pData[playerid][pMechVeh])
					{
						if(pData[playerid][pComponent] < 450) return Error(playerid, "Component anda kurang!");
						pData[playerid][pComponent] -= 450;
						Info(playerid, "Anda memodif kendaraan dengan "RED_E"450 component.");
						pData[playerid][pMechanic] = SetTimerEx("NeonCar", 1000, true, "id", playerid, pData[playerid][pMechVeh]);
						PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Neon Car...");
						PlayerTextDrawShow(playerid, ActiveTD[playerid]);
						ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
					}
					else
					{
						KillTimer(pData[playerid][pMechanic]);
						HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
						PlayerTextDrawHide(playerid, ActiveTD[playerid]);
						pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
						pData[playerid][pMechColor1] = 0;
						pData[playerid][pMechColor2] = 0;
						pData[playerid][pActivityTime] = 0;
						Info(playerid, "Kendaraan pelanggan anda yang sebelumnya sudah terlalu jauh.");
						return 1;
					}
				}
			}
		}
		return 1;
	}
	//ARMS Dealer
	if(dialogid == DIALOG_ARMS_GUN)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0: //slc pistol
				{
					if(pData[playerid][pActivityTime] > 5) return Error(playerid, "Anda masih memiliki activity progress!");
					if(pData[playerid][pMaterial] < 20) return Error(playerid, "Material tidak cukup!(Butuh: 20).");
					if(pData[playerid][pComponent] < 20) return Error(playerid, "Component tidak cukup!(Butuh: 20).");
					if(GetPlayerMoney(playerid) < 200) return Error(playerid, "Not enough money!");

					pData[playerid][pMaterial] -= 20;
					pData[playerid][pComponent] -= 20;
					GivePlayerMoneyEx(playerid, -20000);
					pData[playerid][pActivityTime] = 0;

					TogglePlayerControllable(playerid, 0);
					Info(playerid, "Anda membuat senjata ilegal dengan 20 material dan 20 component dengan harga $200.00!");
					ApplyAnimation(playerid, "BD_FIRE", "wash_up", 4.1, 0, 0, 0, 0, 0, 1);
					pData[playerid][pArmsDealer] = SetTimerEx("CreateGun", 1000, true, "idd", playerid, WEAPON_SILENCED, 70);
					for(new i =0 ; i < 3; i++)
					{
						PlayerTextDrawShow(playerid, Loading[i][playerid]);
					}
					PlayerTextDrawSetString(playerid, Loading[2][playerid], "Creating..");
				}
				case 1: //colt45 9mm
				{
					if(pData[playerid][pActivityTime] > 5) return Error(playerid, "Anda masih memiliki activity progress!");
					if(pData[playerid][pMaterial] < 30) return Error(playerid, "Material tidak cukup!(Butuh: 30).");
					if(pData[playerid][pComponent] < 30) return Error(playerid, "Component tidak cukup!(Butuh: 30).");
					if(GetPlayerMoney(playerid) < 300) return Error(playerid, "Not enough money!");

					pData[playerid][pMaterial] -= 30;
					pData[playerid][pComponent] -= 30;
					GivePlayerMoneyEx(playerid, -30000);
					pData[playerid][pActivityTime] = 0;

					TogglePlayerControllable(playerid, 0);
					Info(playerid, "Anda membuat senjata ilegal dengan 30 material dan 30 component dengan harga $300.00!");
					ApplyAnimation(playerid, "BD_FIRE", "wash_up", 4.1, 0, 0, 0, 0, 0, 1);
					pData[playerid][pArmsDealer] = SetTimerEx("CreateGun", 1000, true, "idd", playerid, WEAPON_COLT45, 70);
					for(new i =0 ; i < 3; i++)
					{
						PlayerTextDrawShow(playerid, Loading[i][playerid]);
					}
					PlayerTextDrawSetString(playerid, Loading[2][playerid], "Creating..");
				}
				case 2: //deagle
				{
					if(pData[playerid][pActivityTime] > 5) return Error(playerid, "Anda masih memiliki activity progress!");
					if(pData[playerid][pMaterial] < 40) return Error(playerid, "Material tidak cukup!(Butuh: 40).");
					if(pData[playerid][pComponent] < 40) return Error(playerid, "Component tidak cukup!(Butuh: 40).");
					if(GetPlayerMoney(playerid) < 400) return Error(playerid, "Not enough money!");

					pData[playerid][pMaterial] -= 40;
					pData[playerid][pComponent] -= 40;
					GivePlayerMoneyEx(playerid, -40000);
					pData[playerid][pActivityTime] = 0;

					TogglePlayerControllable(playerid, 0);
					Info(playerid, "Anda membuat senjata ilegal dengan 40 material dan 40 component dengan harga $400.00!");
					ApplyAnimation(playerid, "BD_FIRE", "wash_up", 4.1, 0, 0, 0, 0, 0, 1);
					pData[playerid][pArmsDealer] = SetTimerEx("CreateGun", 1000, true, "idd", playerid, WEAPON_DEAGLE, 1);
					for(new i =0 ; i < 3; i++)
					{
						PlayerTextDrawShow(playerid, Loading[i][playerid]);
					}
					PlayerTextDrawSetString(playerid, Loading[2][playerid], "Creating..");
				}
				case 3: //shotgun
				{
					if(pData[playerid][pActivityTime] > 5) return Error(playerid, "Anda masih memiliki activity progress!");
					if(pData[playerid][pMaterial] < 50) return Error(playerid, "Material tidak cukup!(Butuh: 50).");
					if(pData[playerid][pComponent] < 50) return Error(playerid, "Component tidak cukup!(Butuh: 50).");
					if(GetPlayerMoney(playerid) < 500) return Error(playerid, "Not enough money!");

					pData[playerid][pMaterial] -= 50;
					pData[playerid][pComponent] -= 50;
					GivePlayerMoneyEx(playerid, -50000);
					pData[playerid][pActivityTime] = 0;

					TogglePlayerControllable(playerid, 0);
					Info(playerid, "Anda membuat senjata ilegal dengan 50 material dan 50 component dengan harga $500.00!");
					ApplyAnimation(playerid, "BD_FIRE", "wash_up", 4.1, 0, 0, 0, 0, 0, 1);
					pData[playerid][pArmsDealer] = SetTimerEx("CreateGun", 1000, true, "idd", playerid, WEAPON_SHOTGUN, 1);
					for(new i =0 ; i < 3; i++)
					{
						PlayerTextDrawShow(playerid, Loading[i][playerid]);
					}
					PlayerTextDrawSetString(playerid, Loading[2][playerid], "Creating..");
				}
				case 4: //mp 5
				{
					if(pData[playerid][pActivityTime] > 5) return Error(playerid, "Anda masih memiliki activity progress!");
					if(pData[playerid][pMaterial] < 60) return Error(playerid, "Material tidak cukup!(Butuh: 60).");
					if(pData[playerid][pComponent] < 60) return Error(playerid, "Component tidak cukup!(Butuh: 60).");
					if(GetPlayerMoney(playerid) < 600) return Error(playerid, "Not enough money!");

					pData[playerid][pMaterial] -= 60;
					pData[playerid][pComponent] -= 60;
					GivePlayerMoneyEx(playerid, -60000);
					pData[playerid][pActivityTime] = 0;

					TogglePlayerControllable(playerid, 0);
					Info(playerid, "Anda membuat senjata ilegal dengan 60 material dan 60 component dengan harga $600.00!");
					ApplyAnimation(playerid, "BD_FIRE", "wash_up", 4.1, 0, 0, 0, 0, 0, 1);
					pData[playerid][pArmsDealer] = SetTimerEx("CreateGun", 1000, true, "idd", playerid, 29, 200);
					for(new i =0 ; i < 3; i++)
					{
						PlayerTextDrawShow(playerid, Loading[i][playerid]);
					}
					PlayerTextDrawSetString(playerid, Loading[2][playerid], "Creating..");
				}
				case 5: //ak-47
				{
					if(pData[playerid][pActivityTime] > 5) return Error(playerid, "Anda masih memiliki activity progress!");
					if(pData[playerid][pMaterial] < 70) return Error(playerid, "Material tidak cukup!(Butuh: 70).");
					if(pData[playerid][pComponent] < 70) return Error(playerid, "Component tidak cukup!(Butuh: 70).");
					if(GetPlayerMoney(playerid) < 700) return Error(playerid, "Not enough money!");

					pData[playerid][pMaterial] -= 70;
					pData[playerid][pComponent] -= 70;
					GivePlayerMoneyEx(playerid, -70000);
					pData[playerid][pActivityTime] = 0;

					TogglePlayerControllable(playerid, 0);
					Info(playerid, "Anda membuat senjata ilegal dengan 70 material dan 70 component dengan harga $700.00!");
					ApplyAnimation(playerid, "BD_FIRE", "wash_up", 4.1, 0, 0, 0, 0, 0, 1);
					pData[playerid][pArmsDealer] = SetTimerEx("CreateGun", 1000, true, "idd", playerid, WEAPON_AK47, 1);
					for(new i =0 ; i < 3; i++)
					{
						PlayerTextDrawShow(playerid, Loading[i][playerid]);
					}
					PlayerTextDrawSetString(playerid, Loading[2][playerid], "Creating..");
				}
			}
		}
		return 1;
	}
	if(dialogid == DIALOG_ARMS_AMMO)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0: //deagle
				{
					//new weaponid = GetPlayerWeaponEx(playerid);
					if(pData[playerid][pActivityTime] > 5) return Error(playerid, "Anda masih memiliki activity progress!");
					if(pData[playerid][pMaterial] < 14) return Error(playerid, "Material tidak cukup!(Butuh: 5).");
					if(pData[playerid][pComponent] < 14) return Error(playerid, "Component tidak cukup!(Butuh: 5).");
					if(GetPlayerMoney(playerid) < 60) return Error(playerid, "Not enough money!");
					if(GetPlayerWeapon(playerid) == 24)
					{
						pData[playerid][pMaterial] -= 14;
						pData[playerid][pComponent] -= 14;
						GivePlayerMoneyEx(playerid, -6000);
						pData[playerid][pActivityTime] = 0;

						TogglePlayerControllable(playerid, 0);
						Info(playerid, "Anda membuat 70 ammo dengan 5 material dan 5 component dengan harga $40.00!");
						ApplyAnimation(playerid, "BD_FIRE", "wash_up", 4.1, 0, 0, 0, 0, 0, 1);
						pData[playerid][pArmsDealer] = SetTimerEx("CreateAmmo", 1000, true, "idd", playerid, WEAPON_DEAGLE, 70);
						for(new i =0 ; i < 3; i++)
						{
							PlayerTextDrawShow(playerid, Loading[i][playerid]);
						}
						PlayerTextDrawSetString(playerid, Loading[2][playerid], "Creating..");
					}
					else
					{
						Error(playerid, "Kamu Tidak Memegang Deagle!");
					}
				}
				case 1: //shotgun
				{
					//new weaponid = GetPlayerWeaponEx(playerid);
					if(pData[playerid][pActivityTime] > 5) return Error(playerid, "Anda masih memiliki activity progress!");
					if(pData[playerid][pMaterial] < 15) return Error(playerid, "Material tidak cukup!(Butuh: 50).");
					if(pData[playerid][pComponent] < 15) return Error(playerid, "Component tidak cukup!(Butuh: 50).");
					if(GetPlayerMoney(playerid) < 50) return Error(playerid, "Not enough money!");
					if(GetPlayerWeapon(playerid) == 25)
					{
						pData[playerid][pMaterial] -= 15;
						pData[playerid][pComponent] -= 15;
						GivePlayerMoneyEx(playerid, -5000);
						pData[playerid][pActivityTime] = 0;

						TogglePlayerControllable(playerid, 0);
						Info(playerid, "Anda membuat 50 ammo dengan 15 material dan 15 component dengan harga $50.00!");
						ApplyAnimation(playerid, "BD_FIRE", "wash_up", 4.1, 0, 0, 0, 0, 0, 1);
						pData[playerid][pArmsDealer] = SetTimerEx("CreateAmmo", 1000, true, "idd", playerid, WEAPON_SHOTGUN, 50);
						for(new i =0 ; i < 3; i++)
						{
							PlayerTextDrawShow(playerid, Loading[i][playerid]);
						}
						PlayerTextDrawSetString(playerid, Loading[2][playerid], "Creating..");
					}
					else
					{
						Error(playerid, "Kamu Tidak Memegang Shotgun!");
					}
					
				}
				case 2: //ak-47
				{
					//new weaponid = GetPlayerWeaponEx(playerid);
					if(pData[playerid][pActivityTime] > 5) return Error(playerid, "Anda masih memiliki activity progress!");
					if(pData[playerid][pMaterial] < 20) return Error(playerid, "Material tidak cukup!(Butuh: 70).");
					if(pData[playerid][pComponent] < 20) return Error(playerid, "Component tidak cukup!(Butuh: 70).");
					if(GetPlayerMoney(playerid) < 50) return Error(playerid, "Not enough money!");
					if(GetPlayerWeapon(playerid) == 30)
					{
						pData[playerid][pMaterial] -= 20;
						pData[playerid][pComponent] -= 20;
						GivePlayerMoneyEx(playerid, -7000);
						pData[playerid][pActivityTime] = 0;

						TogglePlayerControllable(playerid, 0);
						Info(playerid, "Anda membuat 100 ammo dengan 20 material dan 20 component dengan harga $70.00!");
						ApplyAnimation(playerid, "BD_FIRE", "wash_up", 4.1, 0, 0, 0, 0, 0, 1);
						pData[playerid][pArmsDealer] = SetTimerEx("CreateAmmo", 1000, true, "idd", playerid, WEAPON_AK47, 100);
						for(new i =0 ; i < 3; i++)
						{
							PlayerTextDrawShow(playerid, Loading[i][playerid]);
						}
						PlayerTextDrawSetString(playerid, Loading[2][playerid], "Creating..");
					}
					else
					{
						Error(playerid, "Kamu Tidak Memegang Ak-47!");
					}
				}
			}
		}
		return 1;
	}
	if(dialogid == DIALOG_ARMS_MEGAZINE)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
					if(pData[playerid][pActivityTime] > 5) return Error(playerid, "Anda masih memiliki activity progress!");
					if(pData[playerid][pMaterial] < 20) return Error(playerid, "Material tidak cukup!(Butuh: 20).");
					if(pData[playerid][pComponent] < 20) return Error(playerid, "Component tidak cukup!(Butuh: 20).");
					if(GetPlayerMoney(playerid) < 100) return Error(playerid, "Not enough money!");

					pData[playerid][pMaterial] -= 20;
					pData[playerid][pComponent] -= 20;
					GivePlayerMoneyEx(playerid, -10000);
					pData[playerid][pActivityTime] = 0;

					TogglePlayerControllable(playerid, 0);
					Info(playerid, "Anda membuat megazine dengan 20 material dan 20 component dengan harga $100.00!");
					ApplyAnimation(playerid, "BD_FIRE", "wash_up", 4.1, 0, 0, 0, 0, 0, 1);
					pData[playerid][pArmsDealer] = SetTimerEx("CreateMegazine", 1000, true, "idd", playerid);
					for(new i =0 ; i < 3; i++)
					{
						PlayerTextDrawShow(playerid, Loading[i][playerid]);
					}
					PlayerTextDrawSetString(playerid, Loading[2][playerid], "Creating..");
				}
			}
		}
	}
	if(dialogid == DIALOG_PLANT)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
					if(pData[playerid][pSeed] < 5) return Error(playerid, "Not enough seed!");
					new pid = GetNearPlant(playerid);
					if(pid != -1) return Error(playerid, "You too closes with other plant!");

					new id = Iter_Free(Plants), idx = pData[playerid][pFarm];
					if(id == -1) return Error(playerid, "Cant plant any more plant!");

					if(pData[playerid][pPlantTime] > 0) return Error(playerid, "You must wait 10 minutes for plant again!");

					if(IsPlayerInRangeOfPoint(playerid, 80.0, -237.43, -1357.56, 8.52) || IsPlayerInRangeOfPoint(playerid, 100.0, -475.43, -1343.56, 28.14)
					|| IsPlayerInRangeOfPoint(playerid, 50.0, -265.43, -1511.56, 5.49) || IsPlayerInRangeOfPoint(playerid, 30.0, -419.43, -1623.56, 18.87)
					|| IsPlayerInRangeOfPoint(playerid, 400.0, farmData[idx][FarmRepX], farmData[idx][FarmRepY], farmData[idx][FarmRepZ]))
					{

						pData[playerid][pSeed] -= 5;
						new Float:x, Float:y, Float:z, query[512];
						GetPlayerPos(playerid, x, y, z);

						PlantData[id][PlantType] = 1;
						PlantData[id][PlantTime] = 1800;
						PlantData[id][PlantX] = x;
						PlantData[id][PlantY] = y;
						PlantData[id][PlantZ] = z;
						PlantData[id][PlantHarvest] = false;
						PlantData[id][PlantTimer] = SetTimerEx("PlantGrowup", 1000, true, "i", id);
						Iter_Add(Plants, id);
						mysql_format(g_SQL, query, sizeof(query), "INSERT INTO plants SET id='%d', type='%d', time='%d', posx='%f', posy='%f', posz='%f'", id, PlantData[id][PlantType], PlantData[id][PlantTime], x, y, z);
						mysql_tquery(g_SQL, query, "OnPlantCreated", "di", playerid, id);
						pData[playerid][pPlant]++;
						Info(playerid, "Planting Potato.");
					}
					else return Error(playerid, "You must in farmer flint area or your own farm!");
				}
				case 1:
				{
					if(pData[playerid][pSeed] < 18) return Error(playerid, "Not enough seed!");
					new pid = GetNearPlant(playerid);
					if(pid != -1) return Error(playerid, "You too closes with other plant!");

					new id = Iter_Free(Plants);
					if(id == -1) return Error(playerid, "Cant plant any more plant!");

					if(pData[playerid][pPlantTime] > 0) return Error(playerid, "You must wait 10 minutes for plant again!");

					if(IsPlayerInRangeOfPoint(playerid, 80.0, -237.43, -1357.56, 8.52) || IsPlayerInRangeOfPoint(playerid, 100.0, -475.43, -1343.56, 28.14)
					|| IsPlayerInRangeOfPoint(playerid, 50.0, -265.43, -1511.56, 5.49) || IsPlayerInRangeOfPoint(playerid, 30.0, -419.43, -1623.56, 18.87))
					{

						pData[playerid][pSeed] -= 18;
						new Float:x, Float:y, Float:z, query[512];
						GetPlayerPos(playerid, x, y, z);

						PlantData[id][PlantType] = 2;
						PlantData[id][PlantTime] = 3600;
						PlantData[id][PlantX] = x;
						PlantData[id][PlantY] = y;
						PlantData[id][PlantZ] = z;
						PlantData[id][PlantHarvest] = false;
						PlantData[id][PlantTimer] = SetTimerEx("PlantGrowup", 1000, true, "i", id);
						Iter_Add(Plants, id);
						mysql_format(g_SQL, query, sizeof(query), "INSERT INTO plants SET id='%d', type='%d', time='%d', posx='%f', posy='%f', posz='%f'", id, PlantData[id][PlantType], PlantData[id][PlantTime], x, y, z);
						mysql_tquery(g_SQL, query, "OnPlantCreated", "di", playerid, id);
						pData[playerid][pPlant]++;
						Info(playerid, "Planting Wheat.");
					}
					else return Error(playerid, "You must in farmer flint area or your own farm!");
				}
				case 2:
				{
					if(pData[playerid][pSeed] < 11) return Error(playerid, "Not enough seed!");
					new pid = GetNearPlant(playerid);
					if(pid != -1) return Error(playerid, "You too closes with other plant!");

					new id = Iter_Free(Plants);
					if(id == -1) return Error(playerid, "Cant plant any more plant!");

					if(pData[playerid][pPlantTime] > 0) return Error(playerid, "You must wait 10 minutes for plant again!");

					if(IsPlayerInRangeOfPoint(playerid, 80.0, -237.43, -1357.56, 8.52) || IsPlayerInRangeOfPoint(playerid, 100.0, -475.43, -1343.56, 28.14)
					|| IsPlayerInRangeOfPoint(playerid, 50.0, -265.43, -1511.56, 5.49) || IsPlayerInRangeOfPoint(playerid, 30.0, -419.43, -1623.56, 18.87))
					{

						pData[playerid][pSeed] -= 11;
						new Float:x, Float:y, Float:z, query[512];
						GetPlayerPos(playerid, x, y, z);

						PlantData[id][PlantType] = 3;
						PlantData[id][PlantTime] = 2700;
						PlantData[id][PlantX] = x;
						PlantData[id][PlantY] = y;
						PlantData[id][PlantZ] = z;
						PlantData[id][PlantHarvest] = false;
						PlantData[id][PlantTimer] = SetTimerEx("PlantGrowup", 1000, true, "i", id);
						Iter_Add(Plants, id);
						mysql_format(g_SQL, query, sizeof(query), "INSERT INTO plants SET id='%d', type='%d', time='%d', posx='%f', posy='%f', posz='%f'", id, PlantData[id][PlantType], PlantData[id][PlantTime], x, y, z);
						mysql_tquery(g_SQL, query, "OnPlantCreated", "di", playerid, id);
						pData[playerid][pPlant]++;
						Info(playerid, "Planting Orange.");
					}
					else return Error(playerid, "You must in farmer flint area or your own farm!");
				}
				case 3:
				{
					if(pData[playerid][pSeed] < 50) return Error(playerid, "Not enough seed!");
					new pid = GetNearPlant(playerid);
					if(pid != -1) return Error(playerid, "You too closes with other plant!");

					new id = Iter_Free(Plants);
					if(id == -1) return Error(playerid, "Cant plant any more plant!");

					if(pData[playerid][pPlantTime] > 0) return Error(playerid, "You must wait 10 minutes for plant again!");

					if(IsPlayerInRangeOfPoint(playerid, 80.0, -237.43, -1357.56, 8.52) || IsPlayerInRangeOfPoint(playerid, 100.0, -475.43, -1343.56, 28.14)
					|| IsPlayerInRangeOfPoint(playerid, 50.0, -265.43, -1511.56, 5.49) || IsPlayerInRangeOfPoint(playerid, 30.0, -419.43, -1623.56, 18.87))
					{

						pData[playerid][pSeed] -= 50;
						new Float:x, Float:y, Float:z, query[512];
						GetPlayerPos(playerid, x, y, z);

						PlantData[id][PlantType] = 4;
						PlantData[id][PlantTime] = 4500;
						PlantData[id][PlantX] = x;
						PlantData[id][PlantY] = y;
						PlantData[id][PlantZ] = z;
						PlantData[id][PlantHarvest] = false;
						PlantData[id][PlantTimer] = SetTimerEx("PlantGrowup", 1000, true, "i", id);
						Iter_Add(Plants, id);
						mysql_format(g_SQL, query, sizeof(query), "INSERT INTO plants SET id='%d', type='%d', time='%d', posx='%f', posy='%f', posz='%f'", id, PlantData[id][PlantType], PlantData[id][PlantTime], x, y, z);
						mysql_tquery(g_SQL, query, "OnPlantCreated", "di", playerid, id);
						pData[playerid][pPlant]++;
						Info(playerid, "Planting Marijuana.");
					}
					else return Error(playerid, "You must in farmer flint area or your own farm!");
				}
			}
		}
	}
	//pb
	if(dialogid == DIALOG_PB)
	{
		switch(listitem)
		{
			case 0:
			{
                SendClientMessage(playerid,COLOR_YELLOW,"you Have Voted Deagle sucsessfully !");
                DeagleVote++;
                SetTimer("PaintBallStarting",100,false);
			}
			case 1:
			{
                SendClientMessage(playerid,COLOR_YELLOW,"you Have Voted Shotgun sucsessfully !");
                ShotgunVote++;
                SetTimer("PaintBallStarting",100,false);
			}
			case 2:
			{
                SendClientMessage(playerid,COLOR_YELLOW,"you Have Voted M4 sucsessfully !");
                M4Vote++;
                SetTimer("PPaintBallStarting",100,false);
			}
			case 3:
			{
                SendClientMessage(playerid,COLOR_YELLOW,"you Have Voted Mp5 sucsessfully !");
                Mp5Vote++;
                SetTimer("PaintBallStarting",100,false);
			}
			case 4:
			{
                SendClientMessage(playerid,COLOR_YELLOW,"you Have Voted Snipe sucsessfully !");
                SnipeVote++;
                SetTimer("PaintBallStarting",100,false);
			}
		}
	}
	//end
	if(dialogid == DIALOG_TDC)
	{
 		switch(listitem)
		{
			case 0:
			{
				ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_MSGBOX, "General", "", "Okay","");
			}
			case 1:
			{
				/*new string[1000];
				format(string, sizeof(string), "Name:%s\nTrucker License:%d\nTrucker Level:%d", pData[playerid][pName], pData[playerid][pTruckLic], pData[playerid][pTruckLevel])
				ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_MSGBOX, "My Data", string, "Oke","");*/
			}
			case 2:
			{
				ShowPlayerDialog(playerid, DIALOG_TDC_PLACE, DIALOG_STYLE_LIST, "Industri Place", "Las Venturas\nSan Fierro\nLos Santos", "Select","Back");
			}
		}
	}
	if(dialogid == DIALOG_TDC_PLACE)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
					SetPlayerCheckpoint(playerid, 2846.0537,955.7325,10.7500,2.0); //lv
	 				SendClientMessage(playerid, -1, "Lokasi tempat itu ditandai di peta");
				}
				case 1:
				{
					SetPlayerCheckpoint(playerid, -1873.7448,1417.5586,7.1763,2.0); //sf
					SendClientMessage(playerid, -1, "Lokasi tempat itu ditandai di peta");
				}
				case 2:
				{
					SetPlayerCheckpoint(playerid, 163.5530,-54.8748,1.5781,2.0); //ls
	 				SendClientMessage(playerid, -1, "Lokasi tempat itu ditandai di peta");
				}
				case 3:
				{
					SetPlayerCheckpoint(playerid, 1466.4801,1039.0343,10.0313,2.0); //pusat
	 				SendClientMessage(playerid, -1, "Lokasi tempat itu ditandai di peta");
				}
			}
		}
		else
		{
			ShowPlayerDialog(playerid, DIALOG_TDC, DIALOG_STYLE_LIST, "Box Hauling","General\nCommand\nTempat Pengambilan Box", "Select", "Back");
		}
	}
	/*if(dialogid == DIALOG_HAULING)
	{
		if(response)
		{
			new id = ReturnRestockGStationID((listitem + 1)), vehicleid = GetPlayerVehicleID(playerid);

			if(pData[playerid][pMission] > -1 || pData[playerid][pHauling] > -1 || pData[playerid][pDealerMission] > -1)
				return Error(playerid, "Anda sudah sedang melakukan mission/hauling/dealermission!");

			if(GetPlayerState(playerid) != PLAYER_STATE_DRIVER && !IsATruck(vehicleid)) return Error(playerid, "Anda harus mengendarai truck.");

			pData[playerid][pHauling] = id;

			new line9[900];

			format(line9, sizeof(line9), "Silahkan anda membeli stock gasoil di gudang miner!\n\nGas Station ID: %d\nLocation: %s\n\nSetelah itu ikuti checkpoint dan antarkan ke Gas Station tujuan hauling anda!",
			id, GetLocation(gsData[id][gsPosX], gsData[id][gsPosY], gsData[id][gsPosZ]));
			SetPlayerRaceCheckpoint(playerid, 1, 336.70, 895.54, 20.40, 0.0, 0.0, 0.0, 3.5);
			SendClientMessage(playerid, COLOR_JOB,"TRUCKING: {FFFFFF}Silahkan Membeli Gasoil di gudang miner Lalu Kaitkan Trailer ke truck anda!");
			TrailerHauling[playerid] = CreateVehicle(584, 322.5988,856.0931,20.4063,290.4297, 1, 1, -1);
			//SetPlayerCheckpoint(playerid, -279.67, -2148.42, 28.54, 3.5);
			ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_MSGBOX, "Hauling Info", line9, "Close","");
		}
		return 1;
	}
	*/
	if(dialogid == DIALOG_HAULING)
	{
		if(response)
		{
			new id = ReturnRestockGStationID((listitem + 1)), vehicleid = GetPlayerVehicleID(playerid);

			if(IsValidVehicle(pData[playerid][pTrailer]))
			{
				DestroyVehicle(pData[playerid][pTrailer]);
				pData[playerid][pTrailer] = INVALID_VEHICLE_ID;
			}
			
			if(pData[playerid][pHauling] > -1 || pData[playerid][pMission] > -1)
				return Error(playerid, "Anda sudah sedang melakukan Mission/hauling!");
			
			if(GetPlayerState(playerid) != PLAYER_STATE_DRIVER && !IsATruck(vehicleid)) return Error(playerid, "Anda harus mengendarai truck.");

			pData[playerid][pHauling] = id;
			
			new line9[900];

			format(line9, sizeof(line9), "Silahkan anda mengambil trailer gas oil di gudang miner!\n\nGas Station ID: %d\nLocation: %s\n\nSetelah itu ikuti checkpoint dan antarkan ke Gas Station tujuan hauling anda!",
				id, GetLocation(gsData[id][gsPosX], gsData[id][gsPosY], gsData[id][gsPosZ]));
			SetPlayerRaceCheckpoint(playerid, 1, 335.66, 861.02, 21.01, 0, 0, 0, 5.5);
			pData[playerid][pTrailer] = CreateVehicle(584, 326.57, 857.31, 20.40, 290.67, -1, -1, -1, 0);
			ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_MSGBOX, "Hauling Info", line9, "Close","");
		}
		return 1;
	}
	if(dialogid == DIALOG_GASOIL)
	{
		if(response)
		{
			new amount = floatround(strval(inputtext));
			new value = amount * GasOilPrice;
			new vehicleid = GetPlayerVehicleID(playerid), carid = -1;
			new total = VehGasOil[vehicleid] + amount;
			
			if(amount < 0 || amount > 1000) return Error(playerid, "amount maximal 0 - 1000.");
			if(GetPlayerMoney(playerid) < value) return Error(playerid, "Uang anda kurang.");
			if(GasOil < amount) return Error(playerid, "GasOil stock tidak mencukupi.");
			if(total > 1000) return Error(playerid, "Gas Oil Maximal 1000 liter in your vehicle tank!");
			GivePlayerMoneyEx(playerid, -value);
			VehGasOil[vehicleid] += amount;
			if((carid = Vehicle_Nearest2(playerid)) != -1)
			{
				pvData[carid][cGasOil] += amount;
			}
			
			GasOil -= amount;
			Server_AddMoney(value);
			Info(playerid, "Anda berhasil membeli "GREEN_E"%d "WHITE_E"liter gas oil seharga "RED_E"%s.", amount, FormatMoney(value));
		}
	}
	if(dialogid == DIALOG_RESTOCK)
	{
		if(response)
		{
			new id = ReturnRestockBisnisID((listitem + 1)), vehicleid = GetPlayerVehicleID(playerid);
			if(bData[id][bMoney] < 1000)
				return Error(playerid, "Maaf, Bisnis ini kehabisan uang product.");

			if(pData[playerid][pMission] > -1 || pData[playerid][pHauling] > -1 || pData[playerid][pDealerMission] > -1)
				return Error(playerid, "Anda sudah sedang melakukan mission/hauling/dealermission!");

			if(GetPlayerState(playerid) != PLAYER_STATE_DRIVER && !IsATruck(vehicleid)) return Error(playerid, "Anda harus mengendarai truck.");

			pData[playerid][pMission] = id;
			bData[id][bRestock] = 0;

			new line9[900];
			new type[128];
			if(bData[id][bType] == 1)
			{
				type = "Fast Food";

			}
			else if(bData[id][bType] == 2)
			{
				type = "Market";
			}
			else if(bData[id][bType] == 3)
			{
				type = "Clothes";
			}
			else if(bData[id][bType] == 4)
			{
				type = "Equipment";
			}
			else if(bData[id][bType] == 5)
			{
				type = "Bar";
			}
			else
			{
				type = "Unknow";
			}
			format(line9, sizeof(line9), "Silahkan anda membeli stock product di gudang!\n\nBisnis ID: %d\nBisnis Owner: %s\nBisnis Name: %s\nBisnis Type: %s\n\nSetelah itu ikuti checkpoint dan antarkan ke bisnis mission anda!",
			id, bData[id][bOwner], bData[id][bName], type);
			SetPlayerRaceCheckpoint(playerid,1, -279.67, -2148.42, 28.54, 0.0, 0.0, 0.0, 3.5);
			//SetPlayerCheckpoint(playerid, -279.67, -2148.42, 28.54, 3.5);
			ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_MSGBOX, "Mission Info", line9, "Close","");
		}
	}
	if(dialogid == DIALOG_PRODUCT)
	{
		if(response)
		{
			new amount = floatround(strval(inputtext));
			new value = amount * ProductPrice;
			new vehicleid = GetPlayerVehicleID(playerid), carid = -1;
			new total = VehProduct[vehicleid] + amount;
			if(amount < 0 || amount > 150) return Error(playerid, "amount maximal 0 - 150.");
			if(GetPlayerMoney(playerid) < value) return Error(playerid, "Uang anda kurang.");
			if(Product < amount) return Error(playerid, "Product stock tidak mencukupi.");
			if(total > 150) return Error(playerid, "Product Maximal 150 in your vehicle tank!");
			GivePlayerMoneyEx(playerid, -value);
			VehProduct[vehicleid] += amount;
			if((carid = Vehicle_Nearest2(playerid)) != -1)
			{
				pvData[carid][cProduct] += amount;
			}

			Product -= amount;
			Server_AddMoney(value);
			Info(playerid, "Anda berhasil membeli "GREEN_E"%d "WHITE_E"product seharga "RED_E"%s.", amount, FormatMoney(value));
		}
	}
	/*if(dialogid == DIALOG_GASOIL)
	{
		if(response)
		{
			new amount = floatround(strval(inputtext));
			new value = amount * GasOilPrice;
			new vehicleid = GetPlayerVehicleID(playerid), carid = -1;
			new total = VehGasOil[vehicleid] + amount;

			if(amount < 0 || amount > 100) return Error(playerid, "amount maximal 0 - 100.");
			if(GetPlayerMoney(playerid) < value) return Error(playerid, "Uang anda kurang.");
			if(GasOil < amount) return Error(playerid, "Gasoil stock tidak mencukupi.");
			if(total > 1000) return Error(playerid, "Gas Oil Maximal 100 liter in your vehicle tank!");
			GivePlayerMoneyEx(playerid, -value);
			VehGasOil[vehicleid] += amount;
			if((carid = Vehicle_Nearest2(playerid)) != -1)
			{
				pvData[carid][cGasOil] += amount;
			}

			GasOil -= amount;
			Server_AddMoney(value);
			Info(playerid, "Anda berhasil membeli "GREEN_E"%d "WHITE_E"liter gas oil seharga "RED_E"%s.", amount, FormatMoney(value));
		}
	}
	*/
	if(dialogid == DIALOG_MATERIAL)
	{
		if(response)
		{
			new amount = floatround(strval(inputtext));
			new total = pData[playerid][pMaterial] + amount;
			new value = amount * MaterialPrice;
			if(amount < 0 || amount > 500) return Error(playerid, "amount maximal 0 - 500.");
			if(total > 500) return Error(playerid, "Material too full in your inventory! Maximal 500.");
			if(GetPlayerMoney(playerid) < value) return Error(playerid, "Uang anda kurang.");
			if(Material < amount) return Error(playerid, "Material stock tidak mencukupi.");
			GivePlayerMoneyEx(playerid, -value);
			pData[playerid][pMaterial] += amount;
			Material -= amount;
			Server_AddMoney(value);
			Info(playerid, "Succesfuly Buy "GREEN_E"%d "WHITE_E"Material For Price "RED_E"%s.", amount, FormatMoney(value));
		}
	}
	if(dialogid == DIALOG_COMPONENT)
	{
		if(response)
		{
			new amount = floatround(strval(inputtext));
			new total = pData[playerid][pComponent] + amount;
			new value = amount * ComponentPrice;
			if(amount < 0 || amount > 500) return Error(playerid, "amount maximal 0 - 500.");
			if(total > 500) return Error(playerid, "Component too full in your inventory! Maximal 500.");
			if(GetPlayerMoney(playerid) < value) return Error(playerid, "Uang anda kurang.");
			if(Component < amount) return Error(playerid, "Component stock tidak mencukupi.");
			GivePlayerMoneyEx(playerid, -value);
			pData[playerid][pComponent] += amount;
			Component -= amount;
			Server_AddMoney(value);
			Info(playerid, "Succesfuly Buy "GREEN_E"%d "WHITE_E"Component For Price"RED_E"%s.", amount, FormatMoney(value));
		}
	}
	if(dialogid == DIALOG_DRUGS)
	{
		if(response)
		{
			new amount = floatround(strval(inputtext));
			new total = pData[playerid][pMarijuana] + amount;
			new value = amount * MarijuanaPrice;
			if(amount < 0 || amount > 100) return Error(playerid, "amount maximal 0 - 100.");
			if(total > 100) return Error(playerid, "Marijuana full in your inventory! max: 100 kg.");
			if(GetPlayerMoney(playerid) < value) return Error(playerid, "Uang anda kurang.");
			if(Marijuana < amount) return Error(playerid, "Marijuana stock tidak mencukupi.");
			GivePlayerMoneyEx(playerid, -value);
			pData[playerid][pMarijuana] += amount;
			Marijuana -= amount;
			Server_AddMoney(value);
			Info(playerid, "Anda berhasil membeli "GREEN_E"%d "WHITE_E"Marijuana seharga "RED_E"%s.", amount, FormatMoney(value));
		}
	}
	if(dialogid == DIALOG_FOOD)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
					//buy food
					if(pData[playerid][pFood] > 500) return Error(playerid, "Anda sudah membawa 500 Food!");
					new mstr[128];
					format(mstr, sizeof(mstr), ""WHITE_E"Masukan jumlah Food:\nFood Stock: "GREEN_E"%d\n"WHITE_E"Food Price"GREEN_E"%s /item", Food, FormatMoney(FoodPrice));
					ShowPlayerDialog(playerid, DIALOG_FOOD_BUY, DIALOG_STYLE_INPUT, "Buy Food", mstr, "Buy", "Cancel");
				}
				case 1:
				{
					//buy seed
					if(pData[playerid][pSeed] > 100) return Error(playerid, "Anda sudah membawa 100 Seed!");
					new mstr[128];
					format(mstr, sizeof(mstr), ""WHITE_E"Masukan jumlah Seed:\nFood Stock: "GREEN_E"%d\n"WHITE_E"Seed Price"GREEN_E"%s /item", Food, FormatMoney(SeedPrice));
					ShowPlayerDialog(playerid, DIALOG_SEED_BUY, DIALOG_STYLE_INPUT, "Buy Seed", mstr, "Buy", "Cancel");
				}
			}
		}
	}
	if(dialogid == DIALOG_FOOD_BUY)
	{
		if(response)
		{
			new amount = floatround(strval(inputtext));
			new total = pData[playerid][pFood] + amount;
			new value = amount * FoodPrice;
			if(amount < 0 || amount > 500) return Error(playerid, "amount maximal 0 - 500.");
			if(total > 500) return Error(playerid, "Food too full in your inventory! Maximal 500.");
			if(GetPlayerMoney(playerid) < value) return Error(playerid, "Uang anda kurang.");
			if(Food < amount) return Error(playerid, "Food stock tidak mencukupi.");
			GivePlayerMoneyEx(playerid, -value);
			pData[playerid][pFood] += amount;
			Food -= amount;
			Server_AddMoney(value);
			Info(playerid, "Anda berhasil membeli "GREEN_E"%d "WHITE_E"Food seharga "RED_E"%s.", amount, FormatMoney(value));
		}
	}
	if(dialogid == DIALOG_SEED_BUY)
	{
		if(response)
		{
			new amount = floatround(strval(inputtext));
			new total = pData[playerid][pSeed] + amount;
			new value = amount * SeedPrice;
			if(amount < 0 || amount > 100) return Error(playerid, "amount maximal 0 - 100.");
			if(total > 100) return Error(playerid, "Seed too full in your inventory! Maximal 100.");
			if(GetPlayerMoney(playerid) < value) return Error(playerid, "Uang anda kurang.");
			if(Food < amount) return Error(playerid, "Food stock tidak mencukupi.");
			GivePlayerMoneyEx(playerid, -value);
			pData[playerid][pSeed] += amount;
			Food -= amount;
			Server_AddMoney(value);
			Info(playerid, "Anda berhasil membeli "GREEN_E"%d "WHITE_E"Seed seharga "RED_E"%s.", amount, FormatMoney(value));
		}
	}
	if(dialogid == DIALOG_EDIT_PRICE)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
					new mstr[128];
					format(mstr, sizeof(mstr), ""WHITE_E"Masukan harga Sprunk(1 - 500):\nPrice 1(Sprunk): "GREEN_E"%s", FormatMoney(pData[playerid][pPrice1]));
					ShowPlayerDialog(playerid, DIALOG_EDIT_PRICE1, DIALOG_STYLE_INPUT, "Price 1", mstr, "Edit", "Cancel");
				}
				case 1:
				{
					new mstr[128];
					format(mstr, sizeof(mstr), ""WHITE_E"Masukan harga Snack(1 - 500):\nPrice 2(Snack): "GREEN_E"%s", FormatMoney(pData[playerid][pPrice2]));
					ShowPlayerDialog(playerid, DIALOG_EDIT_PRICE2, DIALOG_STYLE_INPUT, "Price 2", mstr, "Edit", "Cancel");
				}
				case 2:
				{
					new mstr[128];
					format(mstr, sizeof(mstr), ""WHITE_E"Masukan harga Ice Cream Orange(1 - 500):\nPrice 3(Ice Cream Orange): "GREEN_E"%s", FormatMoney(pData[playerid][pPrice3]));
					ShowPlayerDialog(playerid, DIALOG_EDIT_PRICE3, DIALOG_STYLE_INPUT, "Price 3", mstr, "Edit", "Cancel");
				}
				case 3:
				{
					new mstr[128];
					format(mstr, sizeof(mstr), ""WHITE_E"Masukan harga Hotdog(1 - 500):\nPrice 4(Hotdog): "GREEN_E"%s", FormatMoney(pData[playerid][pPrice4]));
					ShowPlayerDialog(playerid, DIALOG_EDIT_PRICE4, DIALOG_STYLE_INPUT, "Price 4", mstr, "Edit", "Cancel");
				}
			}
		}
	}
	if(dialogid == DIALOG_EDIT_PRICE1)
	{
		if(response)
		{
			new amount = floatround(strval(inputtext));

			if(amount < 0 || amount > 500) return Error(playerid, "Invalid price! 1 - 500.");
			pData[playerid][pPrice1] = amount;
			Info(playerid, "Anda berhasil mengedit price 1(Sprunk) ke "GREEN_E"%s.", FormatMoney(amount));
			return 1;
		}
	}
	if(dialogid == DIALOG_EDIT_PRICE2)
	{
		if(response)
		{
			new amount = floatround(strval(inputtext));

			if(amount < 0 || amount > 500) return Error(playerid, "Invalid price! 1 - 500.");
			pData[playerid][pPrice2] = amount;
			Info(playerid, "Anda berhasil mengedit price 2(Snack) ke "GREEN_E"%s.", FormatMoney(amount));
			return 1;
		}
	}
	if(dialogid == DIALOG_EDIT_PRICE3)
	{
		if(response)
		{
			new amount = floatround(strval(inputtext));

			if(amount < 0 || amount > 500) return Error(playerid, "Invalid price! 1 - 500.");
			pData[playerid][pPrice3] = amount;
			Info(playerid, "Anda berhasil mengedit price 3(Ice Cream Orange) ke "GREEN_E"%s.", FormatMoney(amount));
			return 1;
		}
	}
	if(dialogid == DIALOG_EDIT_PRICE4)
	{
		if(response)
		{
			new amount = floatround(strval(inputtext));

			if(amount < 0 || amount > 500) return Error(playerid, "Invalid price! 1 - 500.");
			pData[playerid][pPrice4] = amount;
			Info(playerid, "Anda berhasil mengedit price 4(Hotdog) ke "GREEN_E"%s.", FormatMoney(amount));
			return 1;
		}
	}
	if(dialogid == DIALOG_OFFER)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
					new id = pData[playerid][pOffer];
					if(!IsPlayerConnected(id) || !NearPlayer(playerid, id, 4.0))
						return Error(playerid, "You not near with offer player!");

					if(GetPlayerMoney(playerid) < pData[id][pPrice1])
						return Error(playerid, "Not enough money!");

					if(pData[id][pFood] < 5)
						return Error(playerid, "Food stock empty!");

					GivePlayerMoneyEx(id, pData[id][pPrice1]);
					pData[id][pFood] -= 5;

					GivePlayerMoneyEx(playerid, -pData[id][pPrice1]);
					pData[playerid][pSprunk] += 1;

					SendNearbyMessage(playerid, 10.0, COLOR_PURPLE, "** %s telah membeli sprunk seharga %s.", ReturnName(playerid), FormatMoney(pData[id][pPrice1]));
				}
				case 1:
				{
					new id = pData[playerid][pOffer];
					if(!IsPlayerConnected(id) || !NearPlayer(playerid, id, 4.0))
						return Error(playerid, "You not near with offer player!");

					if(GetPlayerMoney(playerid) < pData[id][pPrice2])
						return Error(playerid, "Not enough money!");

					if(pData[id][pFood] < 5)
						return Error(playerid, "Food stock empty!");

					GivePlayerMoneyEx(id, pData[id][pPrice2]);
					pData[id][pFood] -= 5;

					GivePlayerMoneyEx(playerid, -pData[id][pPrice2]);
					pData[playerid][pSnack] += 1;

					SendNearbyMessage(playerid, 10.0, COLOR_PURPLE, "** %s telah membeli snack seharga %s.", ReturnName(playerid), FormatMoney(pData[id][pPrice2]));
				}
				case 2:
				{
					new id = pData[playerid][pOffer];
					if(!IsPlayerConnected(id) || !NearPlayer(playerid, id, 4.0))
						return Error(playerid, "You not near with offer player!");

					if(GetPlayerMoney(playerid) < pData[id][pPrice3])
						return Error(playerid, "Not enough money!");

					if(pData[id][pFood] < 10)
						return Error(playerid, "Food stock empty!");

					GivePlayerMoneyEx(id, pData[id][pPrice3]);
					pData[id][pFood] -= 10;

					GivePlayerMoneyEx(playerid, -pData[id][pPrice3]);
					pData[playerid][pEnergy] += 30;

					SendNearbyMessage(playerid, 10.0, COLOR_PURPLE, "** %s telah membeli ice cream orange seharga %s.", ReturnName(playerid), FormatMoney(pData[id][pPrice3]));
				}
				case 3:
				{
					new id = pData[playerid][pOffer];
					if(!IsPlayerConnected(id) || !NearPlayer(playerid, id, 4.0))
						return Error(playerid, "You not near with offer player!");

					if(GetPlayerMoney(playerid) < pData[id][pPrice4])
						return Error(playerid, "Not enough money!");

					if(pData[id][pFood] < 10)
						return Error(playerid, "Food stock empty!");

					GivePlayerMoneyEx(id, pData[id][pPrice4]);
					pData[id][pFood] -= 10;

					GivePlayerMoneyEx(playerid, -pData[id][pPrice4]);
					pData[playerid][pHunger] += 30;

					SendNearbyMessage(playerid, 10.0, COLOR_PURPLE, "** %s telah membeli hotdog seharga %s.", ReturnName(playerid), FormatMoney(pData[id][pPrice4]));
				}
			}
		}
		pData[playerid][pOffer] = -1;
	}
	if(dialogid == DIALOG_APOTEK)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
					if(Apotek < 1) return Error(playerid, "Product out of stock!");
					if(GetPlayerMoney(playerid) < MedicinePrice) return Error(playerid, "Not enough money.");
					pData[playerid][pMedicine]++;
					Apotek--;
					GivePlayerMoneyEx(playerid, -MedicinePrice);
					Server_AddMoney(MedicinePrice);
					Info(playerid, "Anda membeli painkiller seharga "RED_E"%s,"WHITE_E" /use untuk menggunakannya.", FormatMoney(MedicinePrice));
				}
				case 1:
				{
					if(Apotek < 1) return Error(playerid, "Product out of stock!");
					if(pData[playerid][pFaction] != 3) return Error(playerid, "You are not a medical member.");
					if(GetPlayerMoney(playerid) < MedkitPrice) return Error(playerid, "Not enough money.");
					pData[playerid][pMedkit]++;
					Apotek--;
					GivePlayerMoneyEx(playerid, -MedkitPrice);
					Server_AddMoney(MedkitPrice);
					Info(playerid, "Anda membeli medkit seharga "RED_E"%s", FormatMoney(MedkitPrice));
				}
				case 2:
				{
					if(Apotek < 1) return Error(playerid, "Product out of stock!");
					if(pData[playerid][pFaction] != 3) return Error(playerid, "You are not a medical member.");
					if(GetPlayerMoney(playerid) < 100) return Error(playerid, "Not enough money.");
					pData[playerid][pBandage]++;
					Apotek--;
					GivePlayerMoneyEx(playerid, -100);
					Server_AddMoney(100);
					Info(playerid, "Anda membeli bandage seharga "RED_E"$100");
				}
				case 3:
				{
					if(Apotek < 1) return Error(playerid, "Product out of stock!");
					if(pData[playerid][pFaction] != 3) return Error(playerid, "You are not a medical member.");
					if(GetPlayerMoney(playerid) < 150) return Error(playerid, "Not enough money.");
					pData[playerid][pParacetamol]++;
					Apotek--;
					GivePlayerMoneyEx(playerid, -150);
					Server_AddMoney(1000);
					Info(playerid, "Anda membeli Paracetamol seharga "RED_E"$150");
				}
				case 4:
				{
					if(Apotek < 1) return Error(playerid, "Product out of stock!");
					if(pData[playerid][pFaction] != 3) return Error(playerid, "You are not a medical member.");
					if(GetPlayerMoney(playerid) < 200) return Error(playerid, "Not enough money.");
					pData[playerid][pAmoxicilin]++;
					Apotek--;
					GivePlayerMoneyEx(playerid, -200);
					Server_AddMoney(1000);
					Info(playerid, "Anda membeli Amoxicilin seharga "RED_E"$200");
				}
				case 5:
				{
					if(Apotek < 1) return Error(playerid, "Product out of stock!");
					if(pData[playerid][pFaction] != 3) return Error(playerid, "You are not a medical member.");
					if(GetPlayerMoney(playerid) < 120) return Error(playerid, "Not enough money.");
					pData[playerid][pAntasida]++;
					Apotek--;
					GivePlayerMoneyEx(playerid, -120);
					Server_AddMoney(1000);
					Info(playerid, "Anda membeli Antasida seharga "RED_E"$120");
				}
			}
		}
	}
	if(dialogid == DIALOG_MEDICINE)
  	{
    	if(response)
    	{
        	new Float: hp;
	      	if(listitem == 0)
	      	{
	        	if(pData[playerid][pParacetamol] > 0)
	        	{
	            	GetPlayerHealth(playerid, hp);
	            	SetPlayerHealthEx(playerid, hp+10);
	            	pData[playerid][pHealth] += 10;
	            	if(pData[playerid][pSick] == 3)
	            	{
	            		SetTimerEx("ParacetamolTime", 9000, false, "i", playerid);
	            	}
	            	pData[playerid][pParacetamol] -= 1;
	            	SendClientMessage(playerid, COLOR_ARWIN, "MEDICINEINFO: {FFff00}You've use Paracetamol");
	        	}	
	      	}
	      	if(listitem == 1)
	      	{
	        	if(pData[playerid][pAmoxicilin] > 0)
	        	{
	            	GetPlayerHealth(playerid, hp);
	            	SetPlayerHealthEx(playerid, hp+15);
	            	pData[playerid][pHealth] += 15;
	            	if(pData[playerid][pSick] == 2)
	            	{
	            		SetTimerEx("ParacetamolTime", 9600, false, "i", playerid);
	            	}
	            	else
	            	{
	            		pData[playerid][pSick] = 3;
	            	}
	            	pData[playerid][pAmoxicilin] -= 1;
	            	SendClientMessage(playerid, COLOR_ARWIN, "MEDICINEINFO: {FFff00}You've use Amoxicilin");
	        	}
	      	}
	        if(listitem == 2)
	      	{
	        	if(pData[playerid][pAntasida] > 0)
	        	{
	            	GetPlayerHealth(playerid, hp);
	            	SetPlayerHealthEx(playerid, hp+30);
	            	pData[playerid][pHealth] += 30;
	            	if(pData[playerid][pSick] == 3)
	            	{
	            		SetTimerEx("ParacetamolTime", 9700, false, "i", playerid);
	            	}
	            	else
	            	{
	            		pData[playerid][pSick] = 3;
	            	}
	            	pData[playerid][pAntasida] -= 1;
	            	SendClientMessage(playerid, COLOR_ARWIN, "MEDICINEINFO: {FFff00}You've use Antasida");
	        	}
	      	}
    	}
  	}
	if(dialogid == DIALOG_ATM)
	{
		if(!response) return 1;
		switch(listitem)
		{
			case 0: // Check Balance
			{
				new mstr[512];
				format(mstr, sizeof(mstr), "{F6F6F6}You have "LB_E"%s {F6F6F6}in your bank account.", FormatMoney(pData[playerid][pBankMoney]));
				ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_MSGBOX, ""LB_E"Bank", mstr, "Close", "");
			}
			case 1: // Withdraw
			{
				new mstr[128];
				format(mstr, sizeof(mstr), ""WHITE_E"My Balance: "LB_E"%s", FormatMoney(pData[playerid][pBankMoney]));
				ShowPlayerDialog(playerid, DIALOG_ATMWITHDRAW, DIALOG_STYLE_LIST, mstr, "$50.00\n$200.00\n$500.00\n$1.000.00\n$5.000.00", "Withdraw", "Cancel");
			}
			case 2: // Transfer Money
			{
				ShowPlayerDialog(playerid, DIALOG_BANKREKENING, DIALOG_STYLE_INPUT, ""LB_E"Bank", "Input Number Of The Money:", "Transfer", "Cancel");
			}
			case 3: //Paycheck
			{
				DisplayPaycheck(playerid);
			}
		}
	}
	if(dialogid == DIALOG_ATMWITHDRAW)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
					if(pData[playerid][pBankMoney] < 5000)
						return Error(playerid, "Not enough balance!");

					GivePlayerMoneyEx(playerid, 5000);
					pData[playerid][pBankMoney] -= 5000;
					Info(playerid, "ATM withdraw "LG_E"$50.00");
				}
				case 1:
				{
					if(pData[playerid][pBankMoney] < 20000)
						return Error(playerid, "Not enough balance!");

					GivePlayerMoneyEx(playerid, 20000);
					pData[playerid][pBankMoney] -= 20000;
					Info(playerid, "ATM withdraw "LG_E"$200.00");
				}
				case 2:
				{
					if(pData[playerid][pBankMoney] < 50000)
						return Error(playerid, "Not enough balance!");

					GivePlayerMoneyEx(playerid, 50000);
					pData[playerid][pBankMoney] -= 50000;
					Info(playerid, "ATM withdraw "LG_E"$500.00");
				}
				case 3:
				{
					if(pData[playerid][pBankMoney] < 100000)
						return Error(playerid, "Not enough balance!");

					GivePlayerMoneyEx(playerid, 100000);
					pData[playerid][pBankMoney] -= 100000;
					Info(playerid, "ATM withdraw "LG_E"$1,000.00");
				}
				case 4:
				{
					if(pData[playerid][pBankMoney] < 500000)
						return Error(playerid, "Not enough balance!");

					GivePlayerMoneyEx(playerid, 500000);
					pData[playerid][pBankMoney] -= 500000;
					Info(playerid, "ATM withdraw "LG_E"$5,000.00");
				}
			}
		}
	}
	if(dialogid == DIALOG_BANK)
	{
		if(!response) return true;
		switch(listitem)
		{
			case 0: // Deposit
			{
				new mstr[512];
				format(mstr, sizeof(mstr), "{F6F6F6}You have "LB_E"%s {F6F6F6}in bank account.\n\nType in the amount you want to deposit below:", FormatMoney(pData[playerid][pBankMoney]));
				ShowPlayerDialog(playerid, DIALOG_BANKDEPOSIT, DIALOG_STYLE_INPUT, ""LB_E"Bank", mstr, "Deposit", "Cancel");
			}
			case 1: // Withdraw
			{
				new mstr[512];
				format(mstr, sizeof(mstr), "{F6F6F6}You have "LB_E"%s {F6F6F6}in your bank account.\n\nType in the amount you want to withdraw below:", FormatMoney(pData[playerid][pBankMoney]));
				ShowPlayerDialog(playerid, DIALOG_BANKWITHDRAW, DIALOG_STYLE_INPUT, ""LB_E"Bank", mstr, "Withdraw", "Cancel");
			}
			case 2: // Check Balance
			{
				new mstr[512];
				format(mstr, sizeof(mstr), "{F6F6F6}You have "LB_E"%s {F6F6F6}in your bank account.", FormatMoney(pData[playerid][pBankMoney]));
				ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_MSGBOX, ""LB_E"Bank", mstr, "Close", "");
			}
			case 3: //Transfer Money
			{
				ShowPlayerDialog(playerid, DIALOG_BANKREKENING, DIALOG_STYLE_INPUT, ""LB_E"Bank", "Masukan jumlah uang:", "Transfer", "Cancel");
			}
			case 4:
			{
				DisplayPaycheck(playerid);
			}
		}
	}
	if(dialogid == DIALOG_BANKDEPOSIT)
	{
		if(!response) return true;
		new amount = floatround(strval(inputtext));
		if(amount > pData[playerid][pMoney]) return Error(playerid, "You do not have the sufficient funds to make this transaction.");
		if(amount < 1) return Error(playerid, "You have entered an invalid amount!");

		else
		{
			new query[512], lstr[512];
			pData[playerid][pBankMoney] = (pData[playerid][pBankMoney] + amount);
			GivePlayerMoneyEx(playerid, -amount);
			mysql_format(g_SQL, query, sizeof(query), "UPDATE players SET bmoney=%d,money=%d WHERE reg_id=%d", pData[playerid][pBankMoney], pData[playerid][pMoney], pData[playerid][pID]);
			mysql_tquery(g_SQL, query);
			format(lstr, sizeof(lstr), "{F6F6F6}You have successfully deposited "LB_E"%s {F6F6F6}into your bank account.\n"LB_E"Current Balance: {F6F6F6}%s", FormatMoney(amount), FormatMoney(pData[playerid][pBankMoney]));
			ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_MSGBOX, ""ORANGE_E"HBPR: "LB_E"Bank", lstr, "Close", "");
		}
	}
	if(dialogid == DIALOG_BANKWITHDRAW)
	{
		if(!response) return true;
		new amount = floatround(strval(inputtext));
		if(amount > pData[playerid][pBankMoney]) return Error(playerid, "You do not have the sufficient funds to make this transaction.");
		if(amount < 1) return Error(playerid, "You have entered an invalid amount!");
		else
		{
			new query[128], lstr[512];
			pData[playerid][pBankMoney] = (pData[playerid][pBankMoney] - amount);
			GivePlayerMoneyEx(playerid, amount);
			mysql_format(g_SQL, query, sizeof(query), "UPDATE players SET bmoney=%d,money=%d WHERE reg_id=%d", pData[playerid][pBankMoney], pData[playerid][pMoney], pData[playerid][pID]);
			mysql_tquery(g_SQL, query);
			format(lstr, sizeof(lstr), "{F6F6F6}You have successfully withdrawed "LB_E"%s {F6F6F6}from your bank account.\n"LB_E"Current Balance: {F6F6F6}%s", FormatMoney(amount), FormatMoney(pData[playerid][pBankMoney]));
			ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_MSGBOX, ""ORANGE_E"HBPR: "LB_E"Bank", lstr, "Close", "");
		}
	}
	if(dialogid == DIALOG_BANKREKENING)
	{
		if(!response) return true;
		new amount = floatround(strval(inputtext));
		if(amount > pData[playerid][pBankMoney]) return Error(playerid, "Uang dalam rekening anda kurang.");
		if(amount < 1) return Error(playerid, "You have entered an invalid amount!");

		else
		{
			pData[playerid][pTransfer] = amount;
			ShowPlayerDialog(playerid, DIALOG_BANKTRANSFER, DIALOG_STYLE_INPUT, ""LB_E"Bank", "Masukan nomor rekening target:", "Transfer", "Cancel");
		}
	}
	if(dialogid == DIALOG_BANKTRANSFER)
	{
		if(!response) return true;
		new rek = floatround(strval(inputtext)), query[128];

		mysql_format(g_SQL, query, sizeof(query), "SELECT brek FROM players WHERE brek='%d'", rek);
		mysql_tquery(g_SQL, query, "SearchRek", "id", playerid, rek);
		return 1;
	}
	if(dialogid == DIALOG_BANKCONFIRM)
	{
		if(response)
		{
			new query[128], mstr[248];
			mysql_format(g_SQL, query, sizeof(query), "UPDATE players SET bmoney=bmoney+%d WHERE brek=%d", pData[playerid][pTransfer], pData[playerid][pTransferRek]);
			mysql_tquery(g_SQL, query);

			foreach(new ii : Player)
			{
				if(pData[ii][pBankRek] == pData[playerid][pTransferRek])
				{
					pData[ii][pBankMoney] += pData[playerid][pTransfer];
				}
			}

			pData[playerid][pBankMoney] -= pData[playerid][pTransfer];

			format(mstr, sizeof(mstr), ""WHITE_E"No Rek Target: "YELLOW_E"%d\n"WHITE_E"Nama Target: "YELLOW_E"%s\n"WHITE_E"Jumlah: "GREEN_E"%s\n\n"WHITE_E"Anda telah berhasil mentransfer!", pData[playerid][pTransferRek], pData[playerid][pTransferName], FormatMoney(pData[playerid][pTransfer]));
			ShowPlayerDialog(playerid, DIALOG_BANKSUKSES, DIALOG_STYLE_MSGBOX, ""LB_E"Transfer Sukses", mstr, "Sukses", "");
		}
	}
	if(dialogid == DIALOG_BANKSUKSES)
	{
		if(response)
		{
			pData[playerid][pTransfer] = 0;
			pData[playerid][pTransferRek] = 0;
		}
	}
	/*if(dialogid == DIALOG_ASKS)
	{
		if(response)
		{
			//new i = strval(inputtext);
			new i = listitem;
			new tstr[64], mstr[128], lstr[512];

			strunpack(mstr, AskData[i][askText]);
			format(tstr, sizeof(tstr), ""GREEN_E"Ask Id: #%d", i);
			format(lstr,sizeof(lstr),""WHITE_E"Asked: "GREEN_E"%s\n"WHITE_E"Question: "RED_E"%s.", pData[AskData[i][askPlayer]][pName], mstr);
			ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_MSGBOX,tstr,lstr,"Close","");
		}
	}
	*/
	/*if(dialogid == DIALOG_REPORTS)
	{
		if(response)
		{
			//new i = strval(inputtext);
			new i = listitem;
			new tstr[64], mstr[128], lstr[512];

			strunpack(mstr, ReportData[i][rText]);
			format(tstr, sizeof(tstr), ""GREEN_E"Report Id: #%d", i);
			format(lstr,sizeof(lstr),""WHITE_E"Reported: "GREEN_E"%s\n"WHITE_E"Reason: "RED_E"%s.", pData[ReportData[i][rPlayer]][pName], mstr);
			ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_MSGBOX,tstr,lstr,"Close","");
		}
	}
	*/
	if(dialogid == DIALOG_REPORTS)
	{
		if(response) 
		{
			new i = ListItemReportId[playerid][listitem];
			if(pData[playerid][pAdmin] < 1)
				if(pData[playerid][pHelper] == 0)
					return PermissionError(playerid);
			new String[212];
			
			format(String, sizeof(String), "RESPOND: {FF0000}%s {FFFFFF}has accepted the report from {00FFFF}%s[id:%d].", pData[playerid][pAdminname], pData[Reports[i][ReportFrom]][pName],Reports[i][ReportFrom]);
			SendStaffMessage(COLOR_ARWIN, String, 1);
			format(String, sizeof(String), "RESPOND: {FF0000}%s {FFFFFF}has responded to your report", pData[playerid][pAdminname]);
			SendClientMessageEx(Reports[i][ReportFrom], COLOR_ARWIN, String);
		    Reports[i][BeingUsed] = 0;
			Reports[i][ReportFrom] = 999;
			Reports[i][CheckingReport] = 999;
			Reports[i][CheckingReport] = playerid;
			Reports[i][BeingUsed] = 0;
			Reports[i][TimeToExpire] = 0;
			strmid(Reports[i][Report], "None", 0, 4, 4);
		}
	}
	if(dialogid == BUGGED)
  	{
  		new String[512];
      	if(!response) return 1;
    	if(response)
    	{
        	if(listitem == 0)
        	{
        		if(GetPVarInt(playerid, "IsFrozen") == 1) return SendClientMessageEx(playerid, COLOR_GREYJG, "Anda tidak bisa melakukannya saat terkena Tazer");
        		format(String,sizeof(String), "[STUCK]%s[id:%d] Freeze bug while Spawn or Death.", pData[playerid][pName], playerid);
        		ABroadCast(COLOR_REPORT, String, 1);
        		SendClientMessage(playerid, COLOR_YELLOW, "REPORTINFO: Report anda telah dikirim ke Administrator yang online");
        		return 1;
      		}
      		if(listitem == 1)
      		{
        		format(String,sizeof(String), "[STUCK]%s[id:%d] Wrong World ID (WWID) (vw: %d, int: %d, jailed: %d)", pData[playerid][pName], playerid, pData[playerid][pWorld], pData[playerid][pInt], pData[playerid][pJail]);
                ABroadCast(COLOR_REPORT, String, 1);
                SendClientMessage(playerid, COLOR_YELLOW, "REPORTINFO: Report anda telah dikirim ke Administrator yang online");
        		return 1;
      		}
      		if(listitem == 2)
      		{
        		format(String,sizeof(String), "[STUCK]%s[id:%d] Stuck at someone property or entraance (vw: %d, int: %d, jailed: %d)", pData[playerid][pName], playerid, pData[playerid][pWorld], pData[playerid][pInt], pData[playerid][pJail]);
        		ABroadCast(COLOR_REPORT, String, 1);
        		SendClientMessage(playerid, COLOR_YELLOW, "REPORTINFO: Report anda telah dikirim ke Administrator yang online");
        		return 1;
      		}
      		if(listitem == 3)
      		{
        		format(String,sizeof(String), "[STUCK]%s[id:%d] Spawn at Blueberry (vw: %d, int: %d, jailed: %d)",GetName(playerid), playerid, playerid, pData[playerid][pWorld], pData[playerid][pInt], pData[playerid][pJail]);
        		ABroadCast(COLOR_REPORT, String, 1);
        		SendClientMessage(playerid, COLOR_YELLOW, "REPORTINFO: Report anda telah dikirim ke Administrator yang online");
        		return 1;
      		}
    	}
  	}
	if(dialogid == LIST_JOB)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
					if(pData[playerid][pJob] == 0 || pData[playerid][pJob2] == 0)
					{
						if(pData[playerid][pJob] == 0)
						{
							pData[playerid][pGetJob] = 1;
							Info(playerid, "Anda telah berhasil mendaftarkan job Taxi. /accept job untuk konfirmasi.");
						}
						else if(pData[playerid][pJob2] == 0)
						{
							pData[playerid][pGetJob2] = 1;
							Info(playerid, "Anda telah berhasil mendaftarkan job Taxi. /accept job untuk konfirmasi.");
						}
					}
					else return Error(playerid, "Anda sudah memiliki 2 pekerjaan!");
				}
				case 1:
				{
					if(pData[playerid][pJob] == 0 || pData[playerid][pJob2] == 0)
					{
						if(pData[playerid][pJob] == 0)
						{
							pData[playerid][pGetJob] = 2;
							Info(playerid, "Anda telah berhasil mendaftarkan job Mechanic. /accept job untuk konfirmasi.");
						}
						else if(pData[playerid][pJob2] == 0)
						{
							pData[playerid][pGetJob2] = 2;
							Info(playerid, "Anda telah berhasil mendaftarkan job Mechanic. /accept job untuk konfirmasi.");
						}
					}
					else return Error(playerid, "Anda sudah memiliki 2 pekerjaan!");
				}
				case 2:
				{
					if(pData[playerid][pJob] == 0 || pData[playerid][pJob2] == 0)
					{
						if(pData[playerid][pJob] == 0)
						{
							pData[playerid][pGetJob] = 3;
							Info(playerid, "Anda telah berhasil mendaftarkan job Lumber Jack. /accept job untuk konfirmasi.");
						}
						else if(pData[playerid][pJob2] == 0)
						{
							pData[playerid][pGetJob2] = 3;
							Info(playerid, "Anda telah berhasil mendaftarkan job Lumber Jack. /accept job untuk konfirmasi.");
						}
					}
					else return Error(playerid, "Anda sudah memiliki 2 pekerjaan!");
				}
				case 3:
				{
					if(pData[playerid][pJob] == 0 || pData[playerid][pJob2] == 0)
					{
						if(pData[playerid][pJob] == 0)
						{
							pData[playerid][pGetJob] = 4;
							Info(playerid, "Anda telah berhasil mendaftarkan job Trucker. /accept job untuk konfirmasi.");
						}
						else if(pData[playerid][pJob2] == 0)
						{
							pData[playerid][pGetJob2] = 4;
							Info(playerid, "Anda telah berhasil mendaftarkan job Trucker. /accept job untuk konfirmasi.");
						}
					}
					else return Error(playerid, "Anda sudah memiliki 2 pekerjaan!");
				}
				case 4:
				{
					if(pData[playerid][pJob] == 0 || pData[playerid][pJob2] == 0)
					{
						if(pData[playerid][pJob] == 0)
						{
							pData[playerid][pGetJob] = 5;
							Info(playerid, "Anda telah berhasil mendaftarkan job Miner. /accept job untuk konfirmasi.");
						}
						else if(pData[playerid][pJob2] == 0)
						{
							pData[playerid][pGetJob2] = 5;
							Info(playerid, "Anda telah berhasil mendaftarkan job Miner. /accept job untuk konfirmasi.");
						}
					}
					else return Error(playerid, "Anda sudah memiliki 2 pekerjaan!");
				}
				case 5:
				{
					if(pData[playerid][pJob] == 0 || pData[playerid][pJob2] == 0)
					{
						if(pData[playerid][pJob] == 0)
						{
							pData[playerid][pGetJob] = 6;
							Info(playerid, "Anda telah berhasil mendaftarkan job Production. /accept job untuk konfirmasi.");
						}
						else if(pData[playerid][pJob2] == 0)
						{
							pData[playerid][pGetJob2] = 6;
							Info(playerid, "Anda telah berhasil mendaftarkan job Production. /accept job untuk konfirmasi.");
						}
					}
					else return Error(playerid, "Anda sudah memiliki 2 pekerjaan!");
				}
				case 6:
				{
					if(pData[playerid][pJob] == 0 || pData[playerid][pJob2] == 0)
					{
						if(pData[playerid][pJob] == 0)
						{
							pData[playerid][pGetJob] = 7;
							Info(playerid, "Anda telah berhasil mendaftarkan job Farmer. /accept job untuk konfirmasi.");
						}
						else if(pData[playerid][pJob2] == 0)
						{
							pData[playerid][pGetJob2] = 7;
							Info(playerid, "Anda telah berhasil mendaftarkan job Farmer. /accept job untuk konfirmasi.");
						}
					}
					else return Error(playerid, "Anda sudah memiliki 2 pekerjaan!");
				}
				case 7:
				{
					if(pData[playerid][pJob] == 0 || pData[playerid][pJob2] == 0)
					{
						if(pData[playerid][pJob] == 0)
						{
							pData[playerid][pGetJob] = 8;
							Info(playerid, "Anda telah berhasil mendaftarkan job Pemotong Ayam. /accept job untuk konfirmasi.");
						}
						else if(pData[playerid][pJob2] == 0)
						{
							pData[playerid][pGetJob2] = 8;
							Info(playerid, "Anda telah berhasil mendaftarkan job Pemotong Ayam. /accept job untuk konfirmasi.");
						}
					}
					else return Error(playerid, "Anda sudah memiliki 2 pekerjaan!");
				}
			}
		}
	}
	if(dialogid == DIALOG_BUYPV)
	{
		new vehicleid = GetPlayerVehicleID(playerid);
		if(response)
		{
			if(!IsPlayerInAnyVehicle(playerid))
			{
				TogglePlayerControllable(playerid, 1);
				Error(playerid,"Anda harus berada di dalam kendaraan untuk membelinya.");
				return 1;
			}
			new cost = GetVehicleCost(GetVehicleModel(vehicleid));
			if(pData[playerid][pMoney] < cost)
			{
				Error(playerid, "Uang anda tidak mencukupi.!");
				RemovePlayerFromVehicle(playerid);
				//new Float:slx, Float:sly, Float:slz;
				//GetPlayerPos(playerid, slx, sly, slz);
				//SetPlayerPos(playerid, slx, sly+1.2, slz+1.3);
				//TogglePlayerControllable(playerid, 1);
				//SetVehicleToRespawn(vehicleid);
				SetTimerEx("RespawnPV", 3000, false, "d", vehicleid);
				return 1;
			}
			//if(playerid == INVALID_PLAYER_ID) return Error(playerid, "Invalid player ID!");
			new count = 0, limit = MAX_PLAYER_VEHICLE + pData[playerid][pVip];
			foreach(new ii : PVehicles)
			{
				if(pvData[ii][cOwner] == pData[playerid][pID])
					count++;
			}
			if(count >= limit)
			{
				Error(playerid, "Slot kendaraan anda sudah penuh, silahkan jual beberapa kendaraan anda terlebih dahulu!");
				RemovePlayerFromVehicle(playerid);
				//new Float:slx, Float:sly, Float:slz;
				//GetPlayerPos(playerid, slx, sly, slz);
				//SetPlayerPos(playerid, slx, sly, slz+1.3);
				//TogglePlayerControllable(playerid, 1);
				//SetVehicleToRespawn(vehicleid);
				SetTimerEx("RespawnPV", 3000, false, "d", vehicleid);
				return 1;
			}
			GivePlayerMoneyEx(playerid, -cost);
			new cQuery[1024];
			new Float:x,Float:y,Float:z, Float:a;
			new model, color1, color2;
			color1 = 1;
			color2 = 1;
			model = GetVehicleModel(GetPlayerVehicleID(playerid));
			x = 1805.93;
			y = -1791.19;
			z = 13.54;
			a = 2.22;
			mysql_format(g_SQL, cQuery, sizeof(cQuery), "INSERT INTO `vehicle` (`owner`, `model`, `color1`, `color2`, `price`, `x`, `y`, `z`, `a`) VALUES (%d, %d, %d, %d, %d, '%f', '%f', '%f', '%f')", pData[playerid][pID], model, color1, color2, cost, x, y, z, a);
			mysql_tquery(g_SQL, cQuery, "OnVehBuyPV", "ddddddffff", playerid, pData[playerid][pID], model, color1, color2, cost, x, y, z, a);
			/*new cQuery[1024], model = GetVehicleModel(GetPlayerVehicleID(playerid)), color1 = 0, color2 = 0,
			Float:x = 1805.13, Float:y = -1708.09, Float:z = 13.54, Float:a = 179.23, price = GetVehicleCost(GetVehicleModel(GetPlayerVehicleID(playerid)));
			format(cQuery, sizeof(cQuery), "INSERT INTO `vehicle` (`owner`, `model`, `color1`, `color2`, `price`, `x`, `y`, `z`, `a`) VALUES (%d, %d, %d, %d, '%f', '%f', '%f', '%f')", pData[playerid][pID], model, color1, color2, price, x, y, z, a);
			MySQL_query(cQuery, false, "OnVehBuyed", "ddddddffff", playerid, pData[playerid][pID], model, color1, color2, price, x, y, z, a);
			Servers(playerid, "harusnya bisaa");*/
			return 1;
		}
		else
		{
			RemovePlayerFromVehicle(playerid);
			//new Float:slx, Float:sly, Float:slz;
			//GetPlayerPos(playerid, slx, sly, slz);
			//SetPlayerPos(playerid, slx, sly, slz+1.3);
			//TogglePlayerControllable(playerid, 1);
			//SetVehicleToRespawn(vehicleid);
			SetTimerEx("RespawnPV", 3000, false, "d", vehicleid);
			return 1;
		}
	}
	if(dialogid == DIALOG_BUYVIPPV)
	{
		new vehicleid = GetPlayerVehicleID(playerid);
		if(response)
		{
			if(!IsPlayerInAnyVehicle(playerid))
			{
				TogglePlayerControllable(playerid, 1);
				Error(playerid,"Anda harus berada di dalam kendaraan untuk membelinya.");
				return 1;
			}
			new gold = GetVipVehicleCost(GetVehicleModel(vehicleid));
			new cost = GetVehicleCost(GetVehicleModel(vehicleid));
			if(pData[playerid][pGold] < gold)
			{
				Error(playerid, "gold anda tidak mencukupi!");
				RemovePlayerFromVehicle(playerid);
				//new Float:slx, Float:sly, Float:slz;
				//GetPlayerPos(playerid, slx, sly, slz);
				//SetPlayerPos(playerid, slx, sly, slz+1.3);
				//TogglePlayerControllable(playerid, 1);
				//SetVehicleToRespawn(vehicleid);
				SetTimerEx("RespawnPV", 3000, false, "d", vehicleid);
				return 1;
			}
			//if(playerid == INVALID_PLAYER_ID) return Error(playerid, "Invalid player ID!");
			new count = 0, limit = MAX_PLAYER_VEHICLE + pData[playerid][pVip];
			foreach(new ii : PVehicles)
			{
				if(pvData[ii][cOwner] == pData[playerid][pID])
					count++;
			}
			if(count >= limit)
			{
				Error(playerid, "Slot kendaraan anda sudah penuh, silahkan jual beberapa kendaraan anda terlebih dahulu!");
				RemovePlayerFromVehicle(playerid);
				//new Float:slx, Float:sly, Float:slz;
				//GetPlayerPos(playerid, slx, sly, slz);
				//SetPlayerPos(playerid, slx, sly, slz+1.3);
				//TogglePlayerControllable(playerid, 1);
				//SetVehicleToRespawn(vehicleid);
				SetTimerEx("RespawnPV", 3000, false, "d", vehicleid);
				return 1;
			}
			pData[playerid][pGold] -= gold;
			new cQuery[1024];
			new Float:x,Float:y,Float:z, Float:a;
			new model, color1, color2;
			color1 = 0;
			color2 = 0;
			model = GetVehicleModel(GetPlayerVehicleID(playerid));
			x = 1805.93;
			y = -1791.19;
			z = 13.54;
			a = 2.22;
			mysql_format(g_SQL, cQuery, sizeof(cQuery), "INSERT INTO `vehicle` (`owner`, `model`, `color1`, `color2`, `price`, `x`, `y`, `z`, `a`) VALUES (%d, %d, %d, %d, %d, '%f', '%f', '%f', '%f')", pData[playerid][pID], model, color1, color2, cost, x, y, z, a);
			mysql_tquery(g_SQL, cQuery, "OnVehBuyVIPPV", "ddddddffff", playerid, pData[playerid][pID], model, color1, color2, cost, x, y, z, a);
			/*new cQuery[1024], model = GetVehicleModel(GetPlayerVehicleID(playerid)), color1 = 0, color2 = 0,
			Float:x = 1805.13, Float:y = -1708.09, Float:z = 13.54, Float:a = 179.23, price = GetVehicleCost(GetVehicleModel(GetPlayerVehicleID(playerid)));
			format(cQuery, sizeof(cQuery), "INSERT INTO `vehicle` (`owner`, `model`, `color1`, `color2`, `price`, `x`, `y`, `z`, `a`) VALUES (%d, %d, %d, %d, '%f', '%f', '%f', '%f')", pData[playerid][pID], model, color1, color2, price, x, y, z, a);
			MySQL_query(cQuery, false, "OnVehBuyed", "ddddddffff", playerid, pData[playerid][pID], model, color1, color2, price, x, y, z, a);
			Servers(playerid, "harusnya bisaa");*/
			return 1;
		}
		else
		{
			RemovePlayerFromVehicle(playerid);
			//new Float:slx, Float:sly, Float:slz;
			//GetPlayerPos(playerid, slx, sly, slz);
			//SetPlayerPos(playerid, slx, sly, slz+1.3);
			//TogglePlayerControllable(playerid, 1);
			//SetVehicleToRespawn(vehicleid);
			SetTimerEx("RespawnPV", 3000, false, "d", vehicleid);
			return 1;
		}
	}
	if(dialogid == DIALOG_BUYPVCP)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
					//Bikes
					new str[1024];
					/*format(str, sizeof(str), "%s"WHITE_E"%s\t"LG_E"%s\n", str, GetVehicleModelName(481), FormatMoney(GetVehicleCost(481)));
					format(str, sizeof(str), "%s"WHITE_E"%s\t"LG_E"%s\n", str, GetVehicleModelName(509), FormatMoney(GetVehicleCost(509)));
					format(str, sizeof(str), "%s"WHITE_E"%s\t"LG_E"%s\n", str, GetVehicleModelName(510), FormatMoney(GetVehicleCost(510)));
					format(str, sizeof(str), "%s"WHITE_E"%s\t"LG_E"%s\n", str, GetVehicleModelName(462), FormatMoney(GetVehicleCost(462)));
					format(str, sizeof(str), "%s"WHITE_E"%s\t"LG_E"%s\n", str, GetVehicleModelName(586), FormatMoney(GetVehicleCost(586)));
					format(str, sizeof(str), "%s"WHITE_E"%s\t"LG_E"%s\n", str, GetVehicleModelName(581), FormatMoney(GetVehicleCost(581)));
					format(str, sizeof(str), "%s"WHITE_E"%s\t"LG_E"%s\n", str, GetVehicleModelName(461), FormatMoney(GetVehicleCost(461)));
					format(str, sizeof(str), "%s"WHITE_E"%s\t"LG_E"%s\n", str, GetVehicleModelName(521), FormatMoney(GetVehicleCost(521)));
					format(str, sizeof(str), "%s"WHITE_E"%s\t"LG_E"%s\n", str, GetVehicleModelName(463), FormatMoney(GetVehicleCost(463)));
					format(str, sizeof(str), "%s"WHITE_E"%s\t"LG_E"%s\n", str, GetVehicleModelName(468), FormatMoney(GetVehicleCost(468)));*/

					format(str, sizeof(str), ""WHITE_E"%s\t\t"LG_E"%s\n%s\t\t"LG_E"%s\n%s\t"LG_E"%s\n%s\t\t"LG_E"%s\n%s\t"LG_E"%s\n%s\t\t"LG_E"%s\n%s\t"LG_E"%s\n%s\t"LG_E"%s\n%s\t"LG_E"%s\n%s\t"LG_E"%s\n",
					GetVehicleModelName(481), FormatMoney(GetVehicleCost(481)),
					GetVehicleModelName(509), FormatMoney(GetVehicleCost(509)),
					GetVehicleModelName(510), FormatMoney(GetVehicleCost(510)),
					GetVehicleModelName(462), FormatMoney(GetVehicleCost(462)),
					GetVehicleModelName(586), FormatMoney(GetVehicleCost(586)),
					GetVehicleModelName(581), FormatMoney(GetVehicleCost(581)),
					GetVehicleModelName(461), FormatMoney(GetVehicleCost(461)),
					GetVehicleModelName(521), FormatMoney(GetVehicleCost(521)),
					GetVehicleModelName(463), FormatMoney(GetVehicleCost(463)),
					GetVehicleModelName(468), FormatMoney(GetVehicleCost(468))
					);

					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_BIKES, DIALOG_STYLE_LIST, "Bikes", str, "Buy", "Close");
				}
				case 1:
				{
					//Cars
					new str[1024];
					format(str, sizeof(str), ""WHITE_E"%s\t\t"LG_E"%s\n%s\t"LG_E"%s\n%s\t"LG_E"%s\n%s\t"LG_E"%s\n%s\t"LG_E"%s\n%s\t"LG_E"%s\n%s\t"LG_E"%s\n%s\t"LG_E"%s\n%s\t"LG_E"%s\n%s\t"LG_E"%s\n%s\t"LG_E"%s\n%s\t"LG_E"%s\n%s\t"LG_E"%s\n%s\t"LG_E"%s\n%s\t"LG_E"%s\n%s\t"LG_E"%s\n%s\t"LG_E"%s\n%s\t"LG_E"%s\n%s\t"LG_E"%s\n%s\t"LG_E"%s\n",
					GetVehicleModelName(400), FormatMoney(GetVehicleCost(400)),
					GetVehicleModelName(412), FormatMoney(GetVehicleCost(412)),
					GetVehicleModelName(419), FormatMoney(GetVehicleCost(419)),
					GetVehicleModelName(426), FormatMoney(GetVehicleCost(426)),
					GetVehicleModelName(436), FormatMoney(GetVehicleCost(436)),
					GetVehicleModelName(466), FormatMoney(GetVehicleCost(466)),
					GetVehicleModelName(467), FormatMoney(GetVehicleCost(467)),
					GetVehicleModelName(474), FormatMoney(GetVehicleCost(474)),
					GetVehicleModelName(475), FormatMoney(GetVehicleCost(475)),
					GetVehicleModelName(480), FormatMoney(GetVehicleCost(480)),
					GetVehicleModelName(603), FormatMoney(GetVehicleCost(603)),
					GetVehicleModelName(421), FormatMoney(GetVehicleCost(421)),
					GetVehicleModelName(602), FormatMoney(GetVehicleCost(602)),
					GetVehicleModelName(492), FormatMoney(GetVehicleCost(492)),
					GetVehicleModelName(545), FormatMoney(GetVehicleCost(545)),
					GetVehicleModelName(489), FormatMoney(GetVehicleCost(489)),
					GetVehicleModelName(405), FormatMoney(GetVehicleCost(405)),
					GetVehicleModelName(445), FormatMoney(GetVehicleCost(445)),
					GetVehicleModelName(579), FormatMoney(GetVehicleCost(579)),
					GetVehicleModelName(507), FormatMoney(GetVehicleCost(507))
					);

					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_CARS, DIALOG_STYLE_LIST, "Cars", str, "Buy", "Close");
				}
				case 2:
				{
					//Unique Cars
					new str[1024];
					format(str, sizeof(str), ""WHITE_E"%s\t\t"LG_E"%s\n%s\t"LG_E"%s\n%s\t"LG_E"%s\n%s\t"LG_E"%s\n%s\t"LG_E"%s\n%s\t"LG_E"%s\n%s\t"LG_E"%s\n%s\t"LG_E"%s\n%s\t"LG_E"%s\n%s\t"LG_E"%s\n%s\t"LG_E"%s\n%s\t"LG_E"%s\n%s\t"LG_E"%s\n",
					GetVehicleModelName(483), FormatMoney(GetVehicleCost(483)),
					GetVehicleModelName(534), FormatMoney(GetVehicleCost(534)),
					GetVehicleModelName(535), FormatMoney(GetVehicleCost(535)),
					GetVehicleModelName(536), FormatMoney(GetVehicleCost(536)),
					GetVehicleModelName(558), FormatMoney(GetVehicleCost(558)),
					GetVehicleModelName(559), FormatMoney(GetVehicleCost(559)),
					GetVehicleModelName(560), FormatMoney(GetVehicleCost(560)),
					GetVehicleModelName(561), FormatMoney(GetVehicleCost(561)),
					GetVehicleModelName(562), FormatMoney(GetVehicleCost(562)),
					GetVehicleModelName(565), FormatMoney(GetVehicleCost(565)),
					GetVehicleModelName(567), FormatMoney(GetVehicleCost(567)),
					GetVehicleModelName(575), FormatMoney(GetVehicleCost(575)),
					GetVehicleModelName(576), FormatMoney(GetVehicleCost(576))
					);

					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_UCARS, DIALOG_STYLE_LIST, "Unique Cars", str, "Buy", "Close");
				}
				case 3:
				{
					//Job Cars
					new str[1024];
					format(str, sizeof(str), ""WHITE_E"%s\t"LG_E"%s\n%s\t"LG_E"%s\n%s\t"LG_E"%s\n%s\t"LG_E"%s\n%s\t"LG_E"%s\n%s\t"LG_E"%s\n%s\t"LG_E"%s\n%s\t"LG_E"%s\n%s\t"LG_E"%s\n%s\t"LG_E"%s\n%s\t"LG_E"%s\n%s\t"LG_E"%s\n%s\t"LG_E"%s\n%s\t"LG_E"%s\n%s\t"LG_E"%s\n%s\t"LG_E"%s\n%s\t"LG_E"%s\n%s\t"LG_E"%s\n%s\t"LG_E"%s\n%s\t"LG_E"%s\n%s\t"LG_E"%s\n%s\t"LG_E"%s",
					GetVehicleModelName(420), FormatMoney(GetVehicleCost(420)),
					GetVehicleModelName(438), FormatMoney(GetVehicleCost(438)),
					GetVehicleModelName(403), FormatMoney(GetVehicleCost(403)),
					GetVehicleModelName(413), FormatMoney(GetVehicleCost(413)),
					GetVehicleModelName(414), FormatMoney(GetVehicleCost(414)),
					GetVehicleModelName(422), FormatMoney(GetVehicleCost(422)),
					GetVehicleModelName(440), FormatMoney(GetVehicleCost(440)),
					GetVehicleModelName(455), FormatMoney(GetVehicleCost(455)),
					GetVehicleModelName(456), FormatMoney(GetVehicleCost(456)),
					GetVehicleModelName(478), FormatMoney(GetVehicleCost(478)),
					GetVehicleModelName(482), FormatMoney(GetVehicleCost(482)),
					GetVehicleModelName(498), FormatMoney(GetVehicleCost(498)),
					GetVehicleModelName(499), FormatMoney(GetVehicleCost(499)),
					GetVehicleModelName(423), FormatMoney(GetVehicleCost(423)),
					GetVehicleModelName(588), FormatMoney(GetVehicleCost(588)),
					GetVehicleModelName(524), FormatMoney(GetVehicleCost(524)),
					GetVehicleModelName(525), FormatMoney(GetVehicleCost(525)),
					GetVehicleModelName(543), FormatMoney(GetVehicleCost(543)),
					GetVehicleModelName(552), FormatMoney(GetVehicleCost(552)),
					GetVehicleModelName(554), FormatMoney(GetVehicleCost(554)),
					GetVehicleModelName(578), FormatMoney(GetVehicleCost(578)),
					GetVehicleModelName(609), FormatMoney(GetVehicleCost(609))
					//GetVehicleModelName(530), FormatMoney(GetVehicleCost(530)) //fortklift
					);

					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_JOBCARS, DIALOG_STYLE_LIST, "Job Cars", str, "Buy", "Close");
				}
				case 4:
				{
					// VIP Cars
					new str[1024];
					format(str, sizeof(str), ""WHITE_E"%s\t\t"YELLOW_E"%d gold\n%s\t"YELLOW_E"%d gold\n%s\t"YELLOW_E"%d gold\n%s\t"YELLOW_E"%d gold\n%s\t"YELLOW_E"%d gold\n%s\t"YELLOW_E"%d gold\n%s\t"YELLOW_E"%d gold\n%s\t"YELLOW_E"%d gold\n%s\t"YELLOW_E"%d gold\n%s\t"YELLOW_E"%d gold\n%s\t"YELLOW_E"%d gold\n%s\t"YELLOW_E"%d gold\n%s\t"YELLOW_E"%d gold\n",
					GetVehicleModelName(522), GetVipVehicleCost(522),
					GetVehicleModelName(411), GetVipVehicleCost(411),
					GetVehicleModelName(451), GetVipVehicleCost(451),
					GetVehicleModelName(415), GetVipVehicleCost(415),
					GetVehicleModelName(402), GetVipVehicleCost(402),
					GetVehicleModelName(541), GetVipVehicleCost(541),
					GetVehicleModelName(429), GetVipVehicleCost(429),
					GetVehicleModelName(506), GetVipVehicleCost(506),
					GetVehicleModelName(494), GetVipVehicleCost(494),
					GetVehicleModelName(502), GetVipVehicleCost(502),
					GetVehicleModelName(503), GetVipVehicleCost(503),
					GetVehicleModelName(409), GetVipVehicleCost(409),
					GetVehicleModelName(477), GetVipVehicleCost(477)
					);

					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_VIPCARS, DIALOG_STYLE_LIST, "Vip Cars", str, "Buy", "Close");
				}
			}
		}
	}
	if(dialogid == DIALOG_BUYPVCP_BIKES)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
					new modelid = 481;
					new tstr[128], price = GetVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"%s", GetVehicleModelName(modelid), FormatMoney(price));
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_CONFIRM, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
				}
				case 1:
				{
					new modelid = 509;
					new tstr[128], price = GetVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"%s", GetVehicleModelName(modelid), FormatMoney(price));
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_CONFIRM, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
				}
				case 2:
				{
					new modelid = 510;
					new tstr[128], price = GetVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"%s", GetVehicleModelName(modelid), FormatMoney(price));
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_CONFIRM, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
				}
				case 3:
				{
					new modelid = 462;
					new tstr[128], price = GetVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"%s", GetVehicleModelName(modelid), FormatMoney(price));
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_CONFIRM, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
				}
				case 4:
				{
					new modelid = 586;
					new tstr[128], price = GetVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"%s", GetVehicleModelName(modelid), FormatMoney(price));
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_CONFIRM, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
				}
				case 5:
				{
					new modelid = 581;
					new tstr[128], price = GetVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"%s", GetVehicleModelName(modelid), FormatMoney(price));
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_CONFIRM, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
				}
				case 6:
				{
					new modelid = 461;
					new tstr[128], price = GetVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"%s", GetVehicleModelName(modelid), FormatMoney(price));
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_CONFIRM, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
				}
				case 7:
				{
					new modelid = 521;
					new tstr[128], price = GetVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"%s", GetVehicleModelName(modelid), FormatMoney(price));
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_CONFIRM, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
				}
				case 8:
				{
					new modelid = 463;
					new tstr[128], price = GetVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"%s", GetVehicleModelName(modelid), FormatMoney(price));
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_CONFIRM, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
				}
				case 9:
				{
					new modelid = 468;
					new tstr[128], price = GetVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"%s", GetVehicleModelName(modelid), FormatMoney(price));
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_CONFIRM, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
				}
			}
		}
	}
	if(dialogid == DIALOG_BUYPVCP_CARS)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
					new modelid = 400;
					new tstr[128], price = GetVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"%s", GetVehicleModelName(modelid), FormatMoney(price));
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_CONFIRM, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
				}
				case 1:
				{
					new modelid = 412;
					new tstr[128], price = GetVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"%s", GetVehicleModelName(modelid), FormatMoney(price));
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_CONFIRM, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
				}
				case 2:
				{
					new modelid = 419;
					new tstr[128], price = GetVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"%s", GetVehicleModelName(modelid), FormatMoney(price));
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_CONFIRM, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
				}
				case 3:
				{
					new modelid = 426;
					new tstr[128], price = GetVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"%s", GetVehicleModelName(modelid), FormatMoney(price));
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_CONFIRM, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
				}
				case 4:
				{
					new modelid = 436;
					new tstr[128], price = GetVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"%s", GetVehicleModelName(modelid), FormatMoney(price));
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_CONFIRM, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
				}
				case 5:
				{
					new modelid = 466;
					new tstr[128], price = GetVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"%s", GetVehicleModelName(modelid), FormatMoney(price));
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_CONFIRM, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
				}
				case 6:
				{
					new modelid = 467;
					new tstr[128], price = GetVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"%s", GetVehicleModelName(modelid), FormatMoney(price));
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_CONFIRM, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
				}
				case 7:
				{
					new modelid = 474;
					new tstr[128], price = GetVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"%s", GetVehicleModelName(modelid), FormatMoney(price));
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_CONFIRM, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
				}
				case 8:
				{
					new modelid = 475;
					new tstr[128], price = GetVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"%s", GetVehicleModelName(modelid), FormatMoney(price));
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_CONFIRM, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
				}
				case 9:
				{
					new modelid = 480;
					new tstr[128], price = GetVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"%s", GetVehicleModelName(modelid), FormatMoney(price));
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_CONFIRM, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
				}
				case 10:
				{
					new modelid = 603;
					new tstr[128], price = GetVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"%s", GetVehicleModelName(modelid), FormatMoney(price));
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_CONFIRM, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
				}
				case 11:
				{
					new modelid = 421;
					new tstr[128], price = GetVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"%s", GetVehicleModelName(modelid), FormatMoney(price));
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_CONFIRM, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
				}
				case 12:
				{
					new modelid = 602;
					new tstr[128], price = GetVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"%s", GetVehicleModelName(modelid), FormatMoney(price));
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_CONFIRM, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
				}
				case 13:
				{
					new modelid = 492;
					new tstr[128], price = GetVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"%s", GetVehicleModelName(modelid), FormatMoney(price));
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_CONFIRM, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
				}
				case 14:
				{
					new modelid = 545;
					new tstr[128], price = GetVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"%s", GetVehicleModelName(modelid), FormatMoney(price));
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_CONFIRM, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
				}
				case 15:
				{
					new modelid = 489;
					new tstr[128], price = GetVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"%s", GetVehicleModelName(modelid), FormatMoney(price));
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_CONFIRM, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
				}
				case 16:
				{
					new modelid = 405;
					new tstr[128], price = GetVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"%s", GetVehicleModelName(modelid), FormatMoney(price));
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_CONFIRM, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
				}
				case 17:
				{
					new modelid = 445;
					new tstr[128], price = GetVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"%s", GetVehicleModelName(modelid), FormatMoney(price));
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_CONFIRM, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
				}
				case 18:
				{
					new modelid = 579;
					new tstr[128], price = GetVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"%s", GetVehicleModelName(modelid), FormatMoney(price));
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_CONFIRM, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
				}
				case 19:
				{
					new modelid = 507;
					new tstr[128], price = GetVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"%s", GetVehicleModelName(modelid), FormatMoney(price));
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_CONFIRM, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
				}
			}
		}
	}
	if(dialogid == DIALOG_BUYPVCP_UCARS)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
					new modelid = 483;
					new tstr[128], price = GetVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"%s", GetVehicleModelName(modelid), FormatMoney(price));
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_CONFIRM, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
				}
				case 1:
				{
					new modelid = 534;
					new tstr[128], price = GetVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"%s", GetVehicleModelName(modelid), FormatMoney(price));
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_CONFIRM, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
				}
				case 2:
				{
					new modelid = 535;
					new tstr[128], price = GetVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"%s", GetVehicleModelName(modelid), FormatMoney(price));
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_CONFIRM, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
				}
				case 3:
				{
					new modelid = 536;
					new tstr[128], price = GetVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"%s", GetVehicleModelName(modelid), FormatMoney(price));
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_CONFIRM, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
				}
				case 4:
				{
					new modelid = 558;
					new tstr[128], price = GetVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"%s", GetVehicleModelName(modelid), FormatMoney(price));
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_CONFIRM, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
				}
				case 5:
				{
					new modelid = 559;
					new tstr[128], price = GetVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"%s", GetVehicleModelName(modelid), FormatMoney(price));
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_CONFIRM, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
				}
				case 6:
				{
					new modelid = 560;
					new tstr[128], price = GetVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"%s", GetVehicleModelName(modelid), FormatMoney(price));
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_CONFIRM, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
				}
				case 7:
				{
					new modelid = 561;
					new tstr[128], price = GetVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"%s", GetVehicleModelName(modelid), FormatMoney(price));
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_CONFIRM, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
				}
				case 8:
				{
					new modelid = 562;
					new tstr[128], price = GetVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"%s", GetVehicleModelName(modelid), FormatMoney(price));
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_CONFIRM, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
				}
				case 9:
				{
					new modelid = 565;
					new tstr[128], price = GetVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"%s", GetVehicleModelName(modelid), FormatMoney(price));
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_CONFIRM, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
				}
				case 10:
				{
					new modelid = 567;
					new tstr[128], price = GetVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"%s", GetVehicleModelName(modelid), FormatMoney(price));
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_CONFIRM, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
				}
				case 11:
				{
					new modelid = 575;
					new tstr[128], price = GetVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"%s", GetVehicleModelName(modelid), FormatMoney(price));
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_CONFIRM, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
				}
				case 12:
				{
					new modelid = 576;
					new tstr[128], price = GetVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"%s", GetVehicleModelName(modelid), FormatMoney(price));
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_CONFIRM, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
				}
			}
		}
	}
	if(dialogid == DIALOG_BUYPVCP_JOBCARS)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
					new modelid = 420;
					new tstr[128], price = GetVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"%s", GetVehicleModelName(modelid), FormatMoney(price));
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_CONFIRM, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
				}
				case 1:
				{
					new modelid = 438;
					new tstr[128], price = GetVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"%s", GetVehicleModelName(modelid), FormatMoney(price));
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_CONFIRM, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
				}
				case 2:
				{
					new modelid = 403;
					new tstr[128], price = GetVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"%s", GetVehicleModelName(modelid), FormatMoney(price));
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_CONFIRM, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
				}
				case 3:
				{
					new modelid = 413;
					new tstr[128], price = GetVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"%s", GetVehicleModelName(modelid), FormatMoney(price));
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_CONFIRM, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
				}
				case 4:
				{
					new modelid = 414;
					new tstr[128], price = GetVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"%s", GetVehicleModelName(modelid), FormatMoney(price));
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_CONFIRM, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
				}
				case 5:
				{
					new modelid = 422;
					new tstr[128], price = GetVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"%s", GetVehicleModelName(modelid), FormatMoney(price));
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_CONFIRM, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
				}
				case 6:
				{
					new modelid = 440;
					new tstr[128], price = GetVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"%s", GetVehicleModelName(modelid), FormatMoney(price));
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_CONFIRM, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
				}
				case 7:
				{
					new modelid = 455;
					new tstr[128], price = GetVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"%s", GetVehicleModelName(modelid), FormatMoney(price));
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_CONFIRM, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
				}
				case 8:
				{
					new modelid = 456;
					new tstr[128], price = GetVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"%s", GetVehicleModelName(modelid), FormatMoney(price));
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_CONFIRM, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
				}
				case 9:
				{
					new modelid = 478;
					new tstr[128], price = GetVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"%s", GetVehicleModelName(modelid), FormatMoney(price));
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_CONFIRM, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
				}
				case 10:
				{
					new modelid = 482;
					new tstr[128], price = GetVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"%s", GetVehicleModelName(modelid), FormatMoney(price));
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_CONFIRM, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
				}
				case 11:
				{
					new modelid = 498;
					new tstr[128], price = GetVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"%s", GetVehicleModelName(modelid), FormatMoney(price));
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_CONFIRM, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
				}
				case 12:
				{
					new modelid = 499;
					new tstr[128], price = GetVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"%s", GetVehicleModelName(modelid), FormatMoney(price));
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_CONFIRM, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
				}
				case 13:
				{
					new modelid = 423;
					new tstr[128], price = GetVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"%s", GetVehicleModelName(modelid), FormatMoney(price));
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_CONFIRM, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
				}
				case 14:
				{
					new modelid = 588;
					new tstr[128], price = GetVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"%s", GetVehicleModelName(modelid), FormatMoney(price));
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_CONFIRM, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
				}
				case 15:
				{
					new modelid = 524;
					new tstr[128], price = GetVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"%s", GetVehicleModelName(modelid), FormatMoney(price));
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_CONFIRM, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
				}
				case 16:
				{
					new modelid = 525;
					new tstr[128], price = GetVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"%s", GetVehicleModelName(modelid), FormatMoney(price));
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_CONFIRM, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
				}
				case 17:
				{
					new modelid = 543;
					new tstr[128], price = GetVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"%s", GetVehicleModelName(modelid), FormatMoney(price));
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_CONFIRM, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
				}
				case 18:
				{
					new modelid = 552;
					new tstr[128], price = GetVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"%s", GetVehicleModelName(modelid), FormatMoney(price));
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_CONFIRM, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
				}
				case 19:
				{
					new modelid = 554;
					new tstr[128], price = GetVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"%s", GetVehicleModelName(modelid), FormatMoney(price));
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_CONFIRM, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
				}
				case 20:
				{
					new modelid = 578;
					new tstr[128], price = GetVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"%s", GetVehicleModelName(modelid), FormatMoney(price));
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_CONFIRM, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
				}
				case 21:
				{
					new modelid = 609;
					new tstr[128], price = GetVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"%s", GetVehicleModelName(modelid), FormatMoney(price));
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_CONFIRM, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
				}
			}
		}
	}
	if(dialogid == DIALOG_BUYPVCP_VIPCARS)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
					new modelid = 522;
					new tstr[128], price = GetVipVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "YELLOW_E"%d gold", GetVehicleModelName(modelid), price);
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_VIPCONFIRM, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
				}
				case 1:
				{
					new modelid = 411;
					new tstr[128], price = GetVipVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "YELLOW_E"%d gold", GetVehicleModelName(modelid), price);
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_VIPCONFIRM, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
				}
				case 2:
				{
					new modelid = 451;
					new tstr[128], price = GetVipVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "YELLOW_E"%d gold", GetVehicleModelName(modelid), price);
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_VIPCONFIRM, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
				}
				case 3:
				{
					new modelid = 415;
					new tstr[128], price = GetVipVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "YELLOW_E"%d gold", GetVehicleModelName(modelid), price);
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_VIPCONFIRM, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
				}
				case 4:
				{
					new modelid = 502;
					new tstr[128], price = GetVipVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "YELLOW_E"%d gold", GetVehicleModelName(modelid), price);
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_VIPCONFIRM, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
				}
				case 5:
				{
					new modelid = 541;
					new tstr[128], price = GetVipVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "YELLOW_E"%d gold", GetVehicleModelName(modelid), price);
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_VIPCONFIRM, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
				}
				case 6:
				{
					new modelid = 429;
					new tstr[128], price = GetVipVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "YELLOW_E"%d gold", GetVehicleModelName(modelid), price);
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_VIPCONFIRM, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
				}
				case 7:
				{
					new modelid = 506;
					new tstr[128], price = GetVipVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "YELLOW_E"%d gold", GetVehicleModelName(modelid), price);
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_VIPCONFIRM, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
				}
				case 8:
				{
					new modelid = 494;
					new tstr[128], price = GetVipVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "YELLOW_E"%d gold", GetVehicleModelName(modelid), price);
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_VIPCONFIRM, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
				}
				case 9:
				{
					new modelid = 502;
					new tstr[128], price = GetVipVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "YELLOW_E"%d gold", GetVehicleModelName(modelid), price);
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_VIPCONFIRM, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
				}
				case 10:
				{
					new modelid = 503;
					new tstr[128], price = GetVipVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "YELLOW_E"%d gold", GetVehicleModelName(modelid), price);
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_VIPCONFIRM, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
				}
				case 11:
				{
					new modelid = 409;
					new tstr[128], price = GetVipVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "YELLOW_E"%d gold", GetVehicleModelName(modelid), price);
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_VIPCONFIRM, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
				}
				case 12:
				{
					new modelid = 477;
					new tstr[128], price = GetVipVehicleCost(modelid);
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "YELLOW_E"%d gold", GetVehicleModelName(modelid), price);
					ShowPlayerDialog(playerid, DIALOG_BUYPVCP_VIPCONFIRM, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
				}
			}
		}
	}
	if(dialogid == DIALOG_RENT_JOBCARS)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
					new modelid = 414;
					new tstr[128];
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan menyewa kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"$500 / one days", GetVehicleModelName(modelid));
					ShowPlayerDialog(playerid, DIALOG_RENT_JOBCARSCONFIRM, DIALOG_STYLE_MSGBOX, "Rental Vehicles", tstr, "Rental", "Batal");
				}
				case 1:
				{
					new modelid = 455;
					new tstr[128];
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan menyewa kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"$500 / one days", GetVehicleModelName(modelid));
					ShowPlayerDialog(playerid, DIALOG_RENT_JOBCARSCONFIRM, DIALOG_STYLE_MSGBOX, "Rental Vehicles", tstr, "Rental", "Batal");
				}
				case 2:
				{
					new modelid = 456;
					new tstr[128];
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan menyewa kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"$500 / one days", GetVehicleModelName(modelid));
					ShowPlayerDialog(playerid, DIALOG_RENT_JOBCARSCONFIRM, DIALOG_STYLE_MSGBOX, "Rental Vehicles", tstr, "Rental", "Batal");
				}
				case 3:
				{
					new modelid = 498;
					new tstr[128];
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan menyewa kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"$500 / one days", GetVehicleModelName(modelid));
					ShowPlayerDialog(playerid, DIALOG_RENT_JOBCARSCONFIRM, DIALOG_STYLE_MSGBOX, "Rental Vehicles", tstr, "Rental", "Batal");
				}
				case 4:
				{
					new modelid = 499;
					new tstr[128];
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan menyewa kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"$500 / one days", GetVehicleModelName(modelid));
					ShowPlayerDialog(playerid, DIALOG_RENT_JOBCARSCONFIRM, DIALOG_STYLE_MSGBOX, "Rental Vehicles", tstr, "Rental", "Batal");
				}
				case 5:
				{
					new modelid = 609;
					new tstr[128];
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan menyewa kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"$500 / one days", GetVehicleModelName(modelid));
					ShowPlayerDialog(playerid, DIALOG_RENT_JOBCARSCONFIRM, DIALOG_STYLE_MSGBOX, "Rental Vehicles", tstr, "Rental", "Batal");
				}
				case 6:
				{
					new modelid = 478;
					new tstr[128];
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan menyewa kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"$500 / one days", GetVehicleModelName(modelid));
					ShowPlayerDialog(playerid, DIALOG_RENT_JOBCARSCONFIRM, DIALOG_STYLE_MSGBOX, "Rental Vehicles", tstr, "Rental", "Batal");
				}
				case 7:
				{
					new modelid = 422;
					new tstr[128];
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan menyewa kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"$500 / one days", GetVehicleModelName(modelid));
					ShowPlayerDialog(playerid, DIALOG_RENT_JOBCARSCONFIRM, DIALOG_STYLE_MSGBOX, "Rental Vehicles", tstr, "Rental", "Batal");
				}
				case 8:
				{
					new modelid = 543;
					new tstr[128];
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan menyewa kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"$500 / one days", GetVehicleModelName(modelid));
					ShowPlayerDialog(playerid, DIALOG_RENT_JOBCARSCONFIRM, DIALOG_STYLE_MSGBOX, "Rental Vehicles", tstr, "Rental", "Batal");
				}
				case 9:
				{
					new modelid = 554;
					new tstr[128];
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan menyewa kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"$500 / one days", GetVehicleModelName(modelid));
					ShowPlayerDialog(playerid, DIALOG_RENT_JOBCARSCONFIRM, DIALOG_STYLE_MSGBOX, "Rental Vehicles", tstr, "Rental", "Batal");
				}
				case 10:
				{
					new modelid = 525;
					new tstr[128];
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan menyewa kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"$500 / one days", GetVehicleModelName(modelid));
					ShowPlayerDialog(playerid, DIALOG_RENT_JOBCARSCONFIRM, DIALOG_STYLE_MSGBOX, "Rental Vehicles", tstr, "Rental", "Batal");
				}
				case 11:
				{
					new modelid = 438;
					new tstr[128];
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan menyewa kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"$500 / one days", GetVehicleModelName(modelid));
					ShowPlayerDialog(playerid, DIALOG_RENT_JOBCARSCONFIRM, DIALOG_STYLE_MSGBOX, "Rental Vehicles", tstr, "Rental", "Batal");
				}
				case 12:
				{
					new modelid = 420;
					new tstr[128];
					pData[playerid][pBuyPvModel] = modelid;
					format(tstr, sizeof(tstr), ""WHITE_E"Anda akan menyewa kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"$500 / one days", GetVehicleModelName(modelid));
					ShowPlayerDialog(playerid, DIALOG_RENT_JOBCARSCONFIRM, DIALOG_STYLE_MSGBOX, "Rental Vehicles", tstr, "Rental", "Batal");
				}
			}
		}
	}
	if(dialogid == DIALOG_RENT_JOBCARSCONFIRM)
	{
		new modelid = pData[playerid][pBuyPvModel];
		if(response)
		{
			if(modelid <= 0) return Error(playerid, "Invalid model id.");
			new cost = GetVehicleCost(modelid);
			if(pData[playerid][pMoney] < 500)
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
			GivePlayerMoneyEx(playerid, -500);
			new cQuery[1024];
			new Float:x,Float:y,Float:z, Float:a;
			new model, color1, color2, rental;
			color1 = 1;
			color2 = 1;
			model = modelid;
			x = 1232.4928;//spawn pv
			y = -1274.0288;
			z = 13.1768;
			a = 178.3809;
			rental = gettime() + (1 * 86400);
			mysql_format(g_SQL, cQuery, sizeof(cQuery), "INSERT INTO `vehicle` (`owner`, `model`, `color1`, `color2`, `price`, `x`, `y`, `z`, `a`, `rental`) VALUES (%d, %d, %d, %d, %d, '%f', '%f', '%f', '%f', '%d')", pData[playerid][pID], model, color1, color2, cost, x, y, z, a, rental);
			mysql_tquery(g_SQL, cQuery, "OnVehRentPV", "ddddddffffd", playerid, pData[playerid][pID], model, color1, color2, cost, x, y, z, a, rental);
			return 1;
		}
		else
		{
			pData[playerid][pBuyPvModel] = 0;
		}
	}
	if(dialogid == DIALOG_BUYPVCP_CONFIRM)
	{
		new modelid = pData[playerid][pBuyPvModel];
		if(response)
		{
			if(modelid <= 0) return Error(playerid, "Invalid model id.");
			new cost = GetVehicleCost(modelid);
			if(pData[playerid][pMoney] < cost)
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
			GivePlayerMoneyEx(playerid, -cost);
			new cQuery[1024];
			new Float:x,Float:y,Float:z, Float:a;
			new model, color1, color2;
			color1 = 1;
			color2 = 1;
			model = modelid;
			x = 1240.2491;//spawn pv
			y = -1273.4016;
			z = 13.2111;
			a = 180.0904;
			mysql_format(g_SQL, cQuery, sizeof(cQuery), "INSERT INTO `vehicle` (`owner`, `model`, `color1`, `color2`, `price`, `x`, `y`, `z`, `a`) VALUES (%d, %d, %d, %d, %d, '%f', '%f', '%f', '%f')", pData[playerid][pID], model, color1, color2, cost, x, y, z, a);
			mysql_tquery(g_SQL, cQuery, "OnVehBuyPV", "ddddddffff", playerid, pData[playerid][pID], model, color1, color2, cost, x, y, z, a);
			return 1;
		}
		else
		{
			pData[playerid][pBuyPvModel] = 0;
		}
	}
	if(dialogid == DIALOG_BUYPVS_CONFIRM)
	{
		new modelid = pData[playerid][pBuyPvModel];
		if(response)
		{
			if(modelid <= 0) return Error(playerid, "Invalid model id.");
			new cost = GetVehicleCost(modelid);
			if(pData[playerid][pMoney] < cost)
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
			GivePlayerMoneyEx(playerid, -cost);
			new cQuery[1024];
			new Float:x,Float:y,Float:z, Float:a;
			new model, color1, color2;
			color1 = 1;
			color2 = 1;
			model = modelid;
			x = 561.5816;//spawn pv
			y = -1278.3395;
			z = 16.8809;
			a = 359.4295;
			mysql_format(g_SQL, cQuery, sizeof(cQuery), "INSERT INTO `vehicle` (`owner`, `model`, `color1`, `color2`, `price`, `x`, `y`, `z`, `a`) VALUES (%d, %d, %d, %d, %d, '%f', '%f', '%f', '%f')", pData[playerid][pID], model, color1, color2, cost, x, y, z, a);
			mysql_tquery(g_SQL, cQuery, "OnVehBuyPVS", "ddddddffff", playerid, pData[playerid][pID], model, color1, color2, cost, x, y, z, a);
			return 1;
		}
		else
		{
			pData[playerid][pBuyPvModel] = 0;
		}
	}
	if(dialogid == DIALOG_BUYBOAT_CONFIRM)
	{
		new modelid = pData[playerid][pBuyPvModel];
		if(response)
		{
			if(modelid <= 0) return Error(playerid, "Invalid model id.");
			new cost = GetVehicleCost(modelid);
			if(pData[playerid][pMoney] < cost)
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
			GivePlayerMoneyEx(playerid, -cost);
			new cQuery[1024];
			new Float:x,Float:y,Float:z, Float:a;
			new model, color1, color2;
			color1 = 1;
			color2 = 1;
			model = modelid;
			x = 132.6285;//spawn pv
			y = -1884.1550;
			z = -0.4371;
			a = 90.7067;
			mysql_format(g_SQL, cQuery, sizeof(cQuery), "INSERT INTO `vehicle` (`owner`, `model`, `color1`, `color2`, `price`, `x`, `y`, `z`, `a`) VALUES (%d, %d, %d, %d, %d, '%f', '%f', '%f', '%f')", pData[playerid][pID], model, color1, color2, cost, x, y, z, a);
			mysql_tquery(g_SQL, cQuery, "OnVehBuyBoat", "ddddddffff", playerid, pData[playerid][pID], model, color1, color2, cost, x, y, z, a);
			return 1;
		}
		else
		{
			pData[playerid][pBuyPvModel] = 0;
		}
	}
	if(dialogid == DIALOG_BUYPVCP_VIPCONFIRM)
	{
		new modelid = pData[playerid][pBuyPvModel];
		if(response)
		{
			if(modelid <= 0) return Error(playerid, "Invalid model id.");
			new cost = GetVipVehicleCost(modelid);
			if(pData[playerid][pGold] < cost)
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
			pData[playerid][pGold] -= cost;
			new cQuery[1024];
			new Float:x,Float:y,Float:z, Float:a;
			new model, color1, color2;
			color1 = 0;
			color2 = 0;
			model = modelid;
			x = 1270.8617;//spawn pv
			y = -1435.2208;
			z = 13.3073;
			a = 0.2137;
			mysql_format(g_SQL, cQuery, sizeof(cQuery), "INSERT INTO `vehicle` (`owner`, `model`, `color1`, `color2`, `price`, `x`, `y`, `z`, `a`) VALUES (%d, %d, %d, %d, %d, '%f', '%f', '%f', '%f')", pData[playerid][pID], model, color1, color2, cost, x, y, z, a);
			mysql_tquery(g_SQL, cQuery, "OnVehBuyVIPPV", "ddddddffff", playerid, pData[playerid][pID], model, color1, color2, cost, x, y, z, a);
			return 1;
		}
		else
		{
			pData[playerid][pBuyPvModel] = 0;
		}
	}
	if(dialogid == DIALOG_GMENU)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
					pData[playerid][pGymVip] = 1;
					Info(playerid, "You've buy Gym Vip Membership");
				}
				case 1:
				{
					return callcmd::fstyle(playerid, "");
				}
			}
		}
	}
	if(dialogid == DIALOG_MMENU)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
					return callcmd::vacc(playerid);
				}
				case 1:
				{
					return callcmd::v(playerid, "para");
				}
				case 2:
				{
				    static 
				        vehicle;
				    
				    vehicle = Vehicle_Nearest(playerid);
					//if
				    if(vehicle != INVALID_VEHICLE_ID) 
				    {
				    	Vehicle_TextAdd(playerid, vehicle, 18661, OBJECT_TYPE_TEXT);
				    	return 1;
				    } 
				    else Error(playerid, "Invalid vehicle id.");
				}
			}
		}
	}
	if(dialogid == DIALOG_FSTYLE)
	{
		if(response)
		{
			if(GetPlayerMoney(playerid) >= 20000)
			{
				if(listitem == 0)
				{
			    	pData[playerid][pFightStyle] = FIGHT_STYLE_BOXING;
					SetPlayerFightingStyle (playerid, FIGHT_STYLE_BOXING);
					Info(playerid, "You are now using the boxing fighting style!");

    				if(pData[playerid][pGymVip] >= 1)
				    {
				    	GivePlayerMoney(playerid, -20000);
        				SendClientMessageEx(playerid, COLOR_YELLOW, "GYM MEMBERSHIP:"WHITE_E" You have received 20 percent off this product. Instead of paying $20000, you paid $20000.");
					}
					else
					{
						GivePlayerMoney(playerid, -20000);
					}
				}
				if(listitem == 1)
				{
					pData[playerid][pFightStyle] = FIGHT_STYLE_ELBOW;
					SetPlayerFightingStyle (playerid, FIGHT_STYLE_ELBOW);
					Info(playerid, "You are now using the elbow fighting style!");

 					if(pData[playerid][pGymVip] >= 1)
				    {
				    	GivePlayerMoney(playerid, -30000);
        				SendClientMessageEx(playerid, COLOR_YELLOW, "GYM MEMBERSHIP:"WHITE_E" You have received 20 percent off this product. Instead of paying $300.00, you paid $300.00.");
					}
					else
					{
						GivePlayerMoney(playerid, -30000);
					}
				}
				if(listitem == 2)
				{
			    	pData[playerid][pFightStyle] = FIGHT_STYLE_KNEEHEAD;
				    SetPlayerFightingStyle (playerid, FIGHT_STYLE_KNEEHEAD);
				    Info(playerid, "You are now using the kneehead fighting style!");

    				if(pData[playerid][pGymVip] >= 1)
				    {
				    	GivePlayerMoney(playerid, -40000);
        				SendClientMessageEx(playerid, COLOR_YELLOW, "GYM MEMBERSHIP:"WHITE_E" You have received 20 percent off this product. Instead of paying $400.00, you paid $400.00.");
					}
					else
					{
						GivePlayerMoney(playerid, -40000);
					}
				}
				if(listitem == 3)
				{
   					pData[playerid][pFightStyle] = FIGHT_STYLE_KUNGFU;
					SetPlayerFightingStyle (playerid, FIGHT_STYLE_KUNGFU);
					Info(playerid, "You are now using the kungfu fighting style!");

 					if(pData[playerid][pGymVip] >= 1)
				    {
				    	GivePlayerMoney(playerid, -40000);
        				SendClientMessageEx(playerid, COLOR_YELLOW, "GYM MEMBERSHIP:"WHITE_E" You have received 20 percent off this product. Instead of paying $400.00, you paid $400.00.");
					}
					else
					{
						GivePlayerMoney(playerid, -40000);
					}
				}
				if(listitem == 4)
				{
					pData[playerid][pFightStyle] = FIGHT_STYLE_GRABKICK;
	    			SetPlayerFightingStyle (playerid, FIGHT_STYLE_GRABKICK);
			  	  	Info(playerid, "You are now using the grabkick fighting style!");

    				if(pData[playerid][pGymVip] >= 1)
				    {
				    	GivePlayerMoney(playerid, -40000);
        				SendClientMessageEx(playerid, COLOR_YELLOW, "GYM MEMBERSHIP:"WHITE_E" You have received 20 percent off this product. Instead of paying $400.00, you paid $400.00.");
					}
					else
					{
						GivePlayerMoney(playerid, -40000);
					}
				}
			}
			else
			{
				SendClientMessageEx(playerid, COLOR_GREY, "You do not have the cash for that!");
				return 1;
			}
			if(listitem == 5)
			{
				pData[playerid][pFightStyle] = FIGHT_STYLE_NORMAL;
				SetPlayerFightingStyle (playerid, FIGHT_STYLE_NORMAL);
	  			Info(playerid, "You are now using the normal fighting style!");
				return 1;
			}
		}
	}
	if(dialogid == DIALOG_PAYCHECK)
	{
		if(response)
		{
			if(pData[playerid][pPaycheck] < 3600) return Error(playerid, "Sekarang belum waktunya anda mengambil paycheck.");

			new query[512];
			mysql_format(g_SQL, query, sizeof(query), "SELECT * FROM salary WHERE owner='%d' ORDER BY id ASC LIMIT 30", pData[playerid][pID]);
			mysql_query(g_SQL, query);
			new rows = cache_num_rows();
			if(rows)
			{
				new list[2000], date[30], info[16], money, totalduty, gajiduty, totalsal, total, pajak, hasil;

				totalduty = pData[playerid][pOnDutyTime] + pData[playerid][pTaxiTime];
				for(new i; i < rows; ++i)
				{
					cache_get_value_name(i, "info", info);
					cache_get_value_name(i, "date", date);
					cache_get_value_name_int(i, "money", money);
					totalsal += money;
				}

				if(totalduty > 600)
				{
					gajiduty = 600;
				}
				else
				{
					gajiduty = totalduty;
				}
				total = gajiduty + totalsal;
				pajak = total / 100 * 10;
				hasil = total - pajak;

				format(list, sizeof(list), "Total gaji yang masuk ke rekening bank anda adalah: "LG_E"%s", FormatMoney(hasil));
				ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_MSGBOX, "Paycheck", list, "Close", "");
				pData[playerid][pBankMoney] += hasil;
				Server_MinMoney(hasil);
				pData[playerid][pPaycheck] = 0;
				pData[playerid][pOnDutyTime] = 0;
				pData[playerid][pTaxiTime] = 0;
				mysql_format(g_SQL, query, sizeof(query), "DELETE FROM salary WHERE owner='%d'", pData[playerid][pID]);
				mysql_query(g_SQL, query);
			}
			else
			{
				new list[2000], totalduty, gajiduty, total, pajak, hasil;

				totalduty = pData[playerid][pOnDutyTime] + pData[playerid][pTaxiTime];

				if(totalduty > 600)
				{
					gajiduty = 600;
				}
				else
				{
					gajiduty = totalduty;
				}
				total = gajiduty;
				pajak = total / 100 * 10;
				hasil = total - pajak;

				format(list, sizeof(list), "Total gaji yang masuk ke rekening bank anda adalah: "LG_E"%s", FormatMoney(hasil));
				ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_MSGBOX, "Paycheck", list, "Close", "");
				pData[playerid][pBankMoney] += hasil;
				Server_MinMoney(hasil);
				pData[playerid][pPaycheck] = 0;
				pData[playerid][pOnDutyTime] = 0;
				pData[playerid][pTaxiTime] = 0;
			}
		}
	}
	if(dialogid == DIALOG_TRASH)
	{
		new vehicleid = GetPlayerVehicleID(playerid);
		if(response)
		{
			/*if(pData[playerid][pSideJobTime] > 0)
			{
				Error(playerid, "Anda harus menunggu "GREY2_E"%d "WHITE_E"detik lagi.", pData[playerid][pSideJobTime]);
				RemovePlayerFromVehicle(playerid);
				SetTimerEx("RespawnPV", 3000, false, "d", vehicleid);
				return 1;
			}*/
			SendClientMessage(playerid,COLOR_RIKO, "TRASHMASTER SIDEJOB: {ffffff}Cari tong sampah dan letakan di kendaraan truck mu, dan hati hati dijalan!.");
			InfoTD_MSG(playerid, 3000, "Find a Trash.!");
		}
		else
		{
			RemovePlayerFromVehicle(playerid);
			SetTimerEx("RespawnPV", 3000, false, "d", vehicleid);
		}
	}
    if(dialogid == DIALOG_PIZZA)
	{
		new vehicleid = GetPlayerVehicleID(playerid);
		if(response)
		{
			/*if(pData[playerid][pSideJobTime] > 0)
			{
				Error(playerid, "Anda harus menunggu "GREY2_E"%d "WHITE_E"detik lagi.", pData[playerid][pSideJobTime]);
				RemovePlayerFromVehicle(playerid);
				SetTimerEx("RespawnPV", 3000, false, "d", vehicleid);
				return 1;
			}*/
			SendClientMessage(playerid,COLOR_RIKO, "PIZZA SIDEJOB: {ffffff}Ikuti checkpoint pada map dan hati hati dijalan!.");
			InfoTD_MSG(playerid, 3000, "Antarkan Pizza!");
		}
		else
		{
			RemovePlayerFromVehicle(playerid);
			SetTimerEx("RespawnPV", 3000, false, "d", vehicleid);
		}
	}
	if(dialogid == DIALOG_SWEEPER)
	{
		new vehicleid = GetPlayerVehicleID(playerid);
		if(response)
		{
			if(pData[playerid][pSweeperTime] > 0)
			{
				Error(playerid, "Anda harus menunggu "YELLOW_E"%d "WHITE_E"detik lagi.", pData[playerid][pSweeperTime]);
				RemovePlayerFromVehicle(playerid);
				SetTimerEx("RespawnPV", 3000, false, "d", vehicleid);
				return 1;
			}

			pData[playerid][pSideJob] = 1;
			SetPlayerCheckpoint(playerid, sweperpoint1, 3.0);
			SendClientMessage(playerid,COLOR_RIKO, "SWEEPER SIDEJOB: {ffffff}Ikuti checkpoint pada map dan hati hati dijalan!.");
			InfoTD_MSG(playerid, 3000, "Follow the checkpoint!");
		}
		else
		{
			RemovePlayerFromVehicle(playerid);
			SetTimerEx("RespawnPV", 3000, false, "d", vehicleid);
		}
	}
	if(dialogid == DIALOG_MOWER)
	{
		new vehicleid = GetPlayerVehicleID(playerid);
		if(response)
		{
			if(pData[playerid][pSideJobTime] > 0)
			{
				Error(playerid, "Anda harus menunggu "GREY2_E"%d "WHITE_E"detik lagi.", pData[playerid][pSideJobTime]);
				RemovePlayerFromVehicle(playerid);
				SetTimerEx("RespawnPV", 3000, false, "d", vehicleid);
				return 1;
			}
			pData[playerid][pSideJob] = 4;
			SetPlayerCheckpoint(playerid, mowpoint1, 3.0);
			InfoTD_MSG(playerid, 3000, "Follow the checkpoint!");
		}
		else
		{
			RemovePlayerFromVehicle(playerid);
			SetTimerEx("RespawnPV", 3000, false, "d", vehicleid);
		}
	}
	if(dialogid == DIALOG_BUS)
	{
		new vehicleid = GetPlayerVehicleID(playerid);
		if(response)
		{
			switch(listitem)
			{
			    case 0:
			    {
					if(pData[playerid][pBusTime] > 0)
					{
						Error(playerid, "Anda harus menunggu "YELLOW_E"%d "WHITE_E"detik lagi.", pData[playerid][pBusTime]);
						RemovePlayerFromVehicle(playerid);
						SetTimerEx("RespawnPV", 3000, false, "d", vehicleid);
						return 1;
					}
					else if(pData[playerid][pBusTime] == 0)
					{
						pData[playerid][pSideJob] = 2;
						SetPlayerCheckpoint(playerid, buspoint1, 7.0);
						SendClientMessage(playerid,COLOR_RIKO, "BUS SIDEJOB: {ffffff}Ikuti checkpoint pada map dan hati hati dijalan!.");
						InfoTD_MSG(playerid, 3000, "Follow the checkpoint!");
					}
				}
                case 1:
			    {
					if(pData[playerid][pBusTime] > 0)
					{
						Error(playerid, "Anda harus menunggu "YELLOW_E"%d "WHITE_E"detik lagi.", pData[playerid][pBusTime]);
						RemovePlayerFromVehicle(playerid);
						SetTimerEx("RespawnPV", 3000, false, "d", vehicleid);
						return 1;
					}
					else if(pData[playerid][pBusTime] == 0)
					{
						pData[playerid][pSideJob] = 2;
						SetPlayerCheckpoint(playerid, cpbus1, 7.0);
						SendClientMessage(playerid,COLOR_RIKO, "BUS SIDEJOB: {ffffff}Ikuti checkpoint pada map dan hati hati dijalan!.");
						InfoTD_MSG(playerid, 3000, "Follow the checkpoint!");
					}
				}
				case 2:
			    {
					if(pData[playerid][pBusTime] > 0)
					{
						Error(playerid, "Anda harus menunggu "YELLOW_E"%d "WHITE_E"detik lagi.", pData[playerid][pBusTime]);
						RemovePlayerFromVehicle(playerid);
						SetTimerEx("RespawnPV", 3000, false, "d", vehicleid);
						return 1;
					}
					else if(pData[playerid][pBusTime] == 0)
					{
						pData[playerid][pSideJob] = 2;
						SetPlayerCheckpoint(playerid, buscp1, 7.0);
						SendClientMessage(playerid,COLOR_RIKO, "BUS SIDEJOB: {ffffff}Ikuti checkpoint pada map dan hati hati dijalan!.");
						InfoTD_MSG(playerid, 3000, "Follow the checkpoint!");
					}
				}
			}
		}
		else
		{
			RemovePlayerFromVehicle(playerid);
			SetTimerEx("RespawnPV", 3000, false, "d", vehicleid);
		}
	}
	if(dialogid == DIALOG_MY_WORKSHOP)
	{
		if(response)
		{
			SetPVarInt(playerid, "ClickedWorkshop", ReturnPlayerWorkshopID(playerid, (listitem + 1)));
			ShowPlayerDialog(playerid, WORKSHOP_INFO, DIALOG_STYLE_LIST, "{FF0000}Capitaliz Roleplay {0000FF}Workshop", "Show Information\nTrack Workshop", "Select", "Cancel");
		}
	}
	if(dialogid == WORKSHOP_INFO)
	{
		if(response)
		{
			new wid = GetPVarInt(playerid, "ClickedWorkshop");

			SetPlayerRaceCheckpoint(playerid, 1, wsData[wid][W_X_POS], wsData[wid][W_Y_POS], wsData[wid][W_Z_POS], 0.0, 0.0, 0.0, 3.5);
			Info(playerid, "Ikuti checkpoint untuk menemukan bisnis anda!");
		}
	}
	if(dialogid == DIALOG_FORKLIFT)
	{
		new vehicleid = GetPlayerVehicleID(playerid);
		if(response)
		{
			if(pData[playerid][pForkliftTime] > 0)
			{
				Error(playerid, "Anda harus menunggu "YELLOW_E"%d "WHITE_E"detik lagi.", pData[playerid][pForkliftTime]);
				RemovePlayerFromVehicle(playerid);
				SetTimerEx("RespawnPV", 3000, false, "d", vehicleid);
				return 1;
			}

			pData[playerid][pSideJob] = 3;
			SetPlayerCheckpoint(playerid, forpoint1, 4.0);
			SendClientMessage(playerid,COLOR_RIKO, "FORKLIFT SIDEJOB: {ffffff}Ikuti checkpoint pada map dan hati hati dijalan!.");
			InfoTD_MSG(playerid, 3000, "Ikuti Checkpoint!");
		}
		else
		{
			RemovePlayerFromVehicle(playerid);
			SetTimerEx("RespawnPV", 3000, false, "d", vehicleid);
		}
	}
    /*if(dialogid == DIALOG_CONTAINER)
	{
	    new modelid = GetVehicleModel(GetPlayerVehicleID(playerid));

		if(modelid != 578)
			return Error(playerid, "You must be inside a dft-30.");
			
		if(response)
		{
			if(pData[playerid][pJobTime] > 0)
			{
				Error(playerid, "Anda harus menunggu "GREY2_E"%d "WHITE_E"detik lagi.", pData[playerid][pJobTime]);
				return 1;
			}

			SetPlayerCheckpoint(playerid, containerpoint1, 3.0);
			InfoTD_MSG(playerid, 3000, "Ikuti Checkpoint!");
			SendClientMessage(playerid, COLOR_JOB, "TRUCKING: {FFFFFF}Anda memulai Container Delivery Hati hati di jalan!");
		}
		else
		{
			Info(playerid, "Anda membatalkan Hauling Container!.");
		}
	}*/
	if(dialogid == DIALOG_DMV1)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
					Info(playerid, "Jawaban mu salah");
				}
				case 1:
				{
					Info(playerid, "Jawaban mu benar");
					ShowPlayerDialog(playerid,DIALOG_DMV2,DIALOG_STYLE_LIST,"Jika Anda berniat belok kiri, apakah Anda harus memberi sinyal?","Ya, jika lampu sein dipasang pada kendaraan Anda.\nTidak, jika belok kiri dari lajur yang bertanda belok kiri saja.\nTidak, jika panah ditandai di jalan raya","Oke","Cancel");
				}
				case 2:
				{
					Info(playerid, "Jawaban mu salah");
				}
			}
		}
		return 1;
	}
	if(dialogid == DIALOG_DMV2)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
					Info(playerid, "Jawaban mu benar");
					ShowPlayerDialog(playerid,DIALOG_DMV3,DIALOG_STYLE_LIST,"Jika tidak ada jalur yang ditandai di jalan, Mengemudi","Dekat dengan sisi kiri jalan.\nDi mana saja di sisi jalan Anda.\nSepanjang tengah jalan.","Oke","Cancel");
				}
				case 1:
				{
					Info(playerid, "Jawaban mu salah");
				}
				case 2:
				{
					Info(playerid, "Jawaban mu salah");
				}
			}
		}
		return 1;
	}
	if(dialogid == DIALOG_DMV3)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
					Info(playerid, "Jawaban mu benar");
					PutPlayerInVehicle(playerid, DmvVeh[0], 0);
	    			Global[SKM] = 1;
	    			pData[playerid][pSekolahSim] = 1;
	    			SetPlayerCheckpoint(playerid, dmvpoint1, 3.0);
				}
				case 1:
				{
					Info(playerid, "Jawaban mu salah");
				}
				case 2:
				{
					Info(playerid, "Jawaban mu salah");
				}
			}
		}
		return 1;
	}
	/*if(dialogid == DIALOG_HAULINGTR)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0://Ocean Dock 1
				{
				    if(DialogHauling[0] == false) // Kalau False atau tidak dipilih
				    {
					    DialogHauling[0] = true; // Dialog 0 telah di pilih
					    DialogSaya[playerid][0] = true;
						SendClientMessage(playerid, COLOR_JOB,"TRUCKING: {FFFFFF}Go to marked checkpoint on your map");
						SetPlayerRaceCheckpoint(playerid, 1, 2791.4016, -2494.5452, 14.2522, 2791.4016, -2494.5452, 14.2522, 10.0);
						TrailerHauling[playerid] = CreateVehicle(435, 2791.4016, -2494.5452, 14.2522, 89.5366, 1, 1, -1);
						SedangHauling[playerid] = 1;
					}
					else
					    SendClientMessage(playerid,-1,"ERROR: Trucking Missions already taken by Someone");
				}
				case 1://Ocean Dock 2
				{
				    if(DialogHauling[1] == false) // Kalau False atau tidak dipilih
				    {
					    DialogHauling[1] = true; // Dialog 1 telah di pilih
					    DialogSaya[playerid][1] = true;
						SendClientMessage(playerid, COLOR_JOB,"TRUCKING: {FFFFFF}Go to marked checkpoint on your map");
						SetPlayerRaceCheckpoint(playerid, 1, 2784.3132, -2456.6299, 14.2415, 2784.3132, -2456.6299, 14.2415, 10.0);
						TrailerHauling[playerid] = CreateVehicle(591, 2784.3132, -2456.6299, 14.2415, 89.4938, 1, 1, -1);
						SedangHauling[playerid] = 3;
					}
					else
					    SendClientMessage(playerid,-1,"ERROR: Trucking Missions already taken by Someone");
				}
				case 2://Angel Pine 1
				{
				    if(DialogHauling[2] == false) // Kalau False atau tidak dipilih
				    {
					    DialogHauling[2] = true; // Dialog 2 telah di pilih
					    DialogSaya[playerid][3] = true;
						SendClientMessage(playerid, COLOR_JOB,"TRUCKING: {FFFFFF}Go to marked checkpoint on your map");
						SetPlayerRaceCheckpoint(playerid, 1,-1963.0142, -2436.3079, 31.2311, -1963.0142, -2436.3079, 31.2311, 10.0);
						TrailerHauling[playerid] = CreateVehicle(450, -1963.0142, -2436.3079, 31.2311, 226.1548, 1, 1, -1);
						SedangHauling[playerid] = 5;
					}
					else
					    SendClientMessage(playerid,-1,"ERROR: Trucking Missions already taken by Someone");
				}
				case 3://Angel Pine 2
				{
				    if(DialogHauling[3] == false) // Kalau False atau tidak dipilih
				    {
					    DialogHauling[3] = true; // Dialog 0 telah di pilih
					    DialogSaya[playerid][3] = true;
						SendClientMessage(playerid, COLOR_JOB,"TRUCKING: {FFFFFF}Go to marked checkpoint on your map");
						SetPlayerRaceCheckpoint(playerid, 1, -1966.5603, -2439.9380, 31.2306, -1966.5603, -2439.9380, 31.2306, 10.0);
						TrailerHauling[playerid] = CreateVehicle(450, -1966.5603, -2439.9380, 31.2306, 225.5799, 1, 1, -1);
						SedangHauling[playerid] = 7;
					}
					else
					    SendClientMessage(playerid,-1,"ERROR: Trucking Missions already taken by Someone");
				}
				case 4://Dekat Jembatan Montgomery 1
				{
				    if(DialogHauling[4] == false) // Kalau False atau tidak dipilih
				    {
					    DialogHauling[4] = true; // Dialog 1 telah di pilih
					    DialogSaya[playerid][4] = true;
						SendClientMessage(playerid, COLOR_JOB,"TRUCKING: {FFFFFF}Go to marked checkpoint on your map");
						SetPlayerRaceCheckpoint(playerid, 1, -1863.1541, -1720.5603, 22.3558, -1863.1541, -1720.5603, 22.3558, 10.0);
						TrailerHauling[playerid] = CreateVehicle(450, -1863.1541, -1720.5603, 22.3558, 122.1463, 1, 1, -1);
						SedangHauling[playerid] = 9;
					}
					else
					    SendClientMessage(playerid,-1,"ERROR: Trucking Missions already taken by Someone");
				}
				case 5://Dekat Jembatan Montgomery 2
				{
				    if(DialogHauling[5] == false) // Kalau False atau tidak dipilih
				    {
					    DialogHauling[5] = true; // Dialog 2 telah di pilih
					    DialogSaya[playerid][5] = true;
						SendClientMessage(playerid, COLOR_JOB,"TRUCKING: {FFFFFF}Go to marked checkpoint on your map");
						SetPlayerRaceCheckpoint(playerid, 1, -1855.7255, -1726.0389, 22.3566, -1855.7255, -1726.0389, 22.3566, 10.0);
						TrailerHauling[playerid] = CreateVehicle(450, -1855.7255, -1726.0389, 22.3566, 124.4187, 1, 1, -1);
						SedangHauling[playerid] = 11;
					}
					else
					    SendClientMessage(playerid,-1,"ERROR: Trucking Missions already taken by Someone");
				}
				case 6://Pabrik Easter Egg
				{
				    if(DialogHauling[6] == false) // Kalau False atau tidak dipilih
				    {
					    DialogHauling[6] = true; // Dialog 0 telah di pilih
					    DialogSaya[playerid][6] = true;
						SendClientMessage(playerid, COLOR_JOB,"TRUCKING: {FFFFFF}Go to marked checkpoint on your map");
						SetPlayerRaceCheckpoint(playerid, 1, -1053.6145, -658.6473, 32.6319, -1053.6145, -658.6473, 32.6319, 10.0);
						TrailerHauling[playerid] = CreateVehicle(584, -1053.6145, -658.6473, 32.6319, 260.6392, 1, 1, -1);
						SedangHauling[playerid] = 13;
					}
					else
					    SendClientMessage(playerid,-1,"ERROR: Trucking Missions already taken by Someone");
				}
				case 7://Blueberry Atas
				{
				    if(DialogHauling[7] == false) // Kalau False atau tidak dipilih
				    {
					    DialogHauling[7] = true; // Dialog 1 telah di pilih
					    DialogSaya[playerid][7] = true;
						SendClientMessage(playerid, COLOR_JOB,"TRUCKING: {FFFFFF}Go to marked checkpoint on your map");
						SetPlayerRaceCheckpoint(playerid, 1, -459.3511, -48.3457, 60.5507, -459.3511, -48.3457, 60.5507, 10.0);
						TrailerHauling[playerid] = CreateVehicle(450, -459.3511, -48.3457, 60.5507, 182.7280, 1, 1, -1);
						SedangHauling[playerid] = 15;
					}
					else
					    SendClientMessage(playerid,-1,"ERROR: Trucking Missions already taken by Someone");
				}
				case 8://LV Tanah
				{
				    if(DialogHauling[8] == false) // Kalau False atau tidak dipilih
				    {
					    DialogHauling[8] = true; // Dialog 2 telah di pilih
					    DialogSaya[playerid][8] = true;
						SendClientMessage(playerid, COLOR_JOB,"TRUCKING: {FFFFFF}Go to marked checkpoint on your map");
						SetPlayerRaceCheckpoint(playerid, 1, 847.0450, 921.0422, 13.9579, 847.0450, 921.0422, 13.9579, 10.0);
						TrailerHauling[playerid] = CreateVehicle(450, 847.0450, 921.0422, 13.9579, 201.2555, 1, 1, -1);
						SedangHauling[playerid] = 17;
					}
					else
					    SendClientMessage(playerid,-1,"ERROR: Trucking Missions already taken by Someone");
				}
				case 9://LV Pabrik
				{
				    if(DialogHauling[9] == false) // Kalau False atau tidak dipilih
				    {
					    DialogHauling[9] = true; // Dialog 2 telah di pilih
					    DialogSaya[playerid][9] = true;
						SendClientMessage(playerid, COLOR_JOB,"TRUCKING: {FFFFFF}Go to marked checkpoint on your map");
						SetPlayerRaceCheckpoint(playerid, 1, 249.6713, 1395.7150, 11.1923, 249.6713, 1395.7150, 11.1923, 10.0);
						TrailerHauling[playerid] = CreateVehicle(584, 249.6713, 1395.7150, 11.1923, 269.0699, 1, 1, -1);
						SedangHauling[playerid] = 19;
					}
					else
					    SendClientMessage(playerid,-1,"ERROR: Trucking Missions already taken by Someone");
				}
			}
		}
	}*/
	if(dialogid == DIALOG_TDM)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
					if(GetPlayerTeam(playerid) == 1)
						return Error(playerid, "Anda sudah bergabung ke Tim ini");

					if(RedTeam >= MaxRedTeam)
						return Error(playerid, "Pemain didalam tim ini sudah terlalu penuh");

					SetPlayerTeam(playerid, 1);
					SetPlayerPos(playerid, RedX, RedY, RedZ);
					IsAtEvent[playerid] = 1;
					SetPlayerVirtualWorld(playerid, EventWorld);
					SetPlayerInterior(playerid, EventInt);
					SetPlayerHealthEx(playerid, EventHP);
					SetPlayerArmourEx(playerid, EventArmour);
					ResetPlayerWeapons(playerid);
					GivePlayerWeaponEx(playerid, EventWeapon1, 150);
					GivePlayerWeaponEx(playerid, EventWeapon2, 150);
					GivePlayerWeaponEx(playerid, EventWeapon3, 150);
					GivePlayerWeaponEx(playerid, EventWeapon4, 150);
					GivePlayerWeaponEx(playerid, EventWeapon5, 150);
					TogglePlayerControllable(playerid, 0);
					SetPlayerColor(playerid, COLOR_RED);
					Servers(playerid, "Berhasil bergabung kedalam Tim, Harap tunggu Admin memulai Event");
					RedTeam += 1;
				}
				case 1:
				{
					if(GetPlayerTeam(playerid) == 2)
						return Error(playerid, "Anda sudah bergabung ke Tim ini");

					if(BlueTeam >= MaxBlueTeam)
						return Error(playerid, "Pemain didalam tim ini sudah terlalu penuh");

					SetPlayerTeam(playerid, 2);
					SetPlayerPos(playerid, BlueX, BlueY, BlueZ);
					IsAtEvent[playerid] = 1;
					SetPlayerVirtualWorld(playerid, EventWorld);
					SetPlayerInterior(playerid, EventInt);
					SetPlayerHealthEx(playerid, EventHP);
					SetPlayerArmourEx(playerid, EventArmour);
					ResetPlayerWeapons(playerid);
					GivePlayerWeaponEx(playerid, EventWeapon1, 150);
					GivePlayerWeaponEx(playerid, EventWeapon2, 150);
					GivePlayerWeaponEx(playerid, EventWeapon3, 150);
					GivePlayerWeaponEx(playerid, EventWeapon4, 150);
					GivePlayerWeaponEx(playerid, EventWeapon5, 150);
					TogglePlayerControllable(playerid, 0);
					SetPlayerColor(playerid, COLOR_BLUE);
					Servers(playerid, "Berhasil bergabung kedalam Tim, Harap tunggu Admin memulai Event");
					BlueTeam += 1;
				}
			}
		}
	}
	//trunk
	if(dialogid == TRUNK_STORAGE)
	{
	   	new x = GetNearestVehicleToPlayer(playerid, 3.5, false);

		if(x == INVALID_VEHICLE_ID)
			return Error(playerid, "You not in near any vehicles.");

	    foreach(new i: PVehicles)
		if(x == pvData[i][cVeh])
		{
			new carid = pvData[i][cVeh];
			if(response)
			{
				if(listitem == 0)
				{
					Trunk_WeaponStorage(playerid, carid);
				}
				else if(listitem == 1)
				{
					ShowPlayerDialog(playerid, TRUNK_MONEY, DIALOG_STYLE_LIST, "Money Safe", "Withdraw from safe\nDeposit into safe", "Select", "Back");
				}
				else if(listitem == 2)
				{
					ShowPlayerDialog(playerid, TRUNK_COMP, DIALOG_STYLE_LIST, "Component Safe", "Withdraw from safe\nDeposit into safe", "Select", "Back");
				}
				else if(listitem == 3)
				{
					ShowPlayerDialog(playerid, TRUNK_MATS, DIALOG_STYLE_LIST, "Material Safe", "Withdraw from safe\nDeposit into safe", "Select", "Back");
				}
			}
		}
		return 1;
	}
	if(dialogid == TRUNK_WEAPONS)
	{
       	new x = GetNearestVehicleToPlayer(playerid, 3.5, false);

		if(x == INVALID_VEHICLE_ID)
			return Error(playerid, "You not in near any vehicles.");

	    foreach(new i: PVehicles)
		if(x == pvData[i][cVeh])
		{
			new carid = pvData[i][cVeh];
			if(response)
			{
				if(vsData[carid][tWeapon][listitem] != 0)
				{
					GivePlayerWeaponEx(playerid, vsData[carid][tWeapon][listitem], vsData[carid][tAmmo][listitem]);

					SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s has taken a \"%s\" from their weapon storage.", ReturnName(playerid), ReturnWeaponName(vsData[carid][tWeapon][listitem]));

					vsData[carid][tWeapon][listitem] = 0;
					vsData[carid][tAmmo][listitem] = 0;
					Trunk_Save(i);
					Trunk_WeaponStorage(playerid, carid);
				}
				else
				{
					new
						weaponid = GetPlayerWeaponEx(playerid),
						ammo = GetPlayerAmmoEx(playerid);

					if(!weaponid)
						return Error(playerid, "You are not holding any weapon!");

					ResetWeapon(playerid, weaponid);
					SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s has stored a \"%s\" into their weapon storage.", ReturnName(playerid), ReturnWeaponName(weaponid));

					vsData[carid][tWeapon][listitem] = weaponid;
					vsData[carid][tAmmo][listitem] = ammo;
					Trunk_Save(i);
					Trunk_WeaponStorage(playerid, carid);
				}
			}
			else
			{
				Trunk_OpenStorage(playerid, carid);
			}
		}
		return 1;
	}
	if(dialogid == TRUNK_MONEY)
	{
		if(response)
		{
			switch (listitem)
			{
				case 0:
				{
					new str[128];
					format(str, sizeof(str), "Please enter how much money you wish to withdraw from the safe:");
					ShowPlayerDialog(playerid, TRUNK_WITHDRAWMONEY, DIALOG_STYLE_INPUT, "Withdraw from safe", str, "Withdraw", "Back");
				}
				case 1:
				{
					new str[128];
					format(str, sizeof(str), "Please enter how much money you wish to deposit into the safe:");
					ShowPlayerDialog(playerid, TRUNK_DEPOSITMONEY, DIALOG_STYLE_INPUT, "Deposit into safe", str, "Deposit", "Back");
				}
			}
		}
		return 1;
	}
	if(dialogid == TRUNK_WITHDRAWMONEY)
	{
		if(response)
		{
			new x = GetNearestVehicleToPlayer(playerid, 3.5, false);

			if(x == INVALID_VEHICLE_ID)
				return Error(playerid, "You not in near any vehicles.");

		    foreach(new i: PVehicles)
			if(x == pvData[i][cVeh])
			{
				new carid = pvData[i][cVeh];
				new amount = strval(inputtext);

				if(isnull(inputtext))
				{
					new str[128];
					format(str, sizeof(str), "Please enter how much money you wish to withdraw from the safe:");
					ShowPlayerDialog(playerid, TRUNK_WITHDRAWMONEY, DIALOG_STYLE_INPUT, "Withdraw from safe", str, "Withdraw", "Back");
					return 1;
				}
				if(amount < 1 || amount > vsData[carid][tMoney])
				{
					new str[128];
					format(str, sizeof(str), "Error: Insufficient funds.\n\nSafe Balance: %s\n\nPlease enter how much money you wish to withdraw from the safe:", FormatMoney(vsData[carid][tMoney]));
					ShowPlayerDialog(playerid, TRUNK_WITHDRAWMONEY, DIALOG_STYLE_INPUT, "Withdraw from safe", str, "Withdraw", "Back");
					return 1;
				}
				vsData[carid][tMoney] -= amount;
				GivePlayerMoneyEx(playerid, amount);

				Trunk_Save(i);
				Trunk_OpenStorage(playerid, carid);

				SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s has withdrawn %s from their vehicle safe.", ReturnName(playerid), FormatMoney(amount));
			}
		}
		return 1;
	}
	if(dialogid == TRUNK_DEPOSITMONEY)
	{
		if(response)
		{
			new x = GetNearestVehicleToPlayer(playerid, 3.5, false);

			if(x == INVALID_VEHICLE_ID)
				return Error(playerid, "You not in near any vehicles.");

		    foreach(new i: PVehicles)
			if(x == pvData[i][cVeh])
			{
				new carid = pvData[i][cVeh];
				new amount = strval(inputtext);

				if(isnull(inputtext))
				{
					new str[128];
					format(str, sizeof(str), "Safe Balance: %s\n\nPlease enter how much money you wish to deposit into the safe:", FormatMoney(vsData[carid][tMoney]));
					ShowPlayerDialog(playerid, TRUNK_DEPOSITMONEY, DIALOG_STYLE_INPUT, "Deposit into safe", str, "Deposit", "Back");
					return 1;
				}
				if(amount < 1 || amount > GetPlayerMoney(playerid))
				{
					new str[128];
					format(str, sizeof(str), "Error: Insufficient funds.\n\nSafe Balance: %s\n\nPlease enter how much money you wish to deposit into the safe:", FormatMoney(vsData[carid][tMoney]));
					ShowPlayerDialog(playerid, TRUNK_DEPOSITMONEY, DIALOG_STYLE_INPUT, "Deposit into safe", str, "Deposit", "Back");
					return 1;
				}
				vsData[carid][tMoney] += amount;
				GivePlayerMoneyEx(playerid, -amount);

				Trunk_Save(i);
				Trunk_OpenStorage(playerid, carid);

				SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s has deposited %s into their vehicle safe.", ReturnName(playerid), FormatMoney(amount));
			}
		}
	}
	if(dialogid == TRUNK_COMP)
	{
		if(response)
		{
			switch (listitem)
			{
				case 0:
				{
					new str[128];
					format(str, sizeof(str), "Please enter how much component you wish to withdraw from the safe:");
					ShowPlayerDialog(playerid, TRUNK_WITHDRAWCOMP, DIALOG_STYLE_INPUT, "Withdraw from safe", str, "Withdraw", "Back");
				}
				case 1:
				{
					new str[128];
					format(str, sizeof(str), "Please enter how much component you wish to deposit into the safe:");
					ShowPlayerDialog(playerid, TRUNK_DEPOSITCOMP, DIALOG_STYLE_INPUT, "Deposit into safe", str, "Deposit", "Back");
				}
			}
		}
		return 1;
	}
	if(dialogid == TRUNK_WITHDRAWCOMP)
	{
		if(response)
		{
			new x = GetNearestVehicleToPlayer(playerid, 3.5, false);

			if(x == INVALID_VEHICLE_ID)
				return Error(playerid, "You not in near any vehicles.");

		    foreach(new i: PVehicles)
			if(x == pvData[i][cVeh])
			{
				new carid = pvData[i][cVeh];
				new amount = strval(inputtext);

				if(isnull(inputtext))
				{
					new str[128];
					format(str, sizeof(str), "Safe Balance: %d\n\nPlease enter how much component you wish to withdraw from the safe:", vsData[carid][tComp]);
					ShowPlayerDialog(playerid, TRUNK_WITHDRAWCOMP, DIALOG_STYLE_INPUT, "Withdraw from safe", str, "Withdraw", "Back");
					return 1;
				}
				if(amount < 1 || amount > vsData[carid][tComp])
				{
					new str[128];
					format(str, sizeof(str), "Error: Insufficient funds.\n\nSafe Balance: %d\n\nPlease enter how much component you wish to withdraw from the safe:", vsData[carid][tComp]);
					ShowPlayerDialog(playerid, TRUNK_WITHDRAWCOMP, DIALOG_STYLE_INPUT, "Withdraw from safe", str, "Withdraw", "Back");
					return 1;
				}
				vsData[carid][tComp] -= amount;
				pData[playerid][pComponent] += amount;

				Trunk_Save(i);
				Trunk_OpenStorage(playerid, carid);

				SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s has withdrawn %d from their vehicle storage safe.", ReturnName(playerid), amount);
			}
		}
	}
	if(dialogid == TRUNK_DEPOSITCOMP)
	{
		if(response)
		{
			new x = GetNearestVehicleToPlayer(playerid, 3.5, false);

			if(x == INVALID_VEHICLE_ID)
				return Error(playerid, "You not in near any vehicles.");

		    foreach(new i: PVehicles)
			if(x == pvData[i][cVeh])
			{
				new carid = pvData[i][cVeh];
				new amount = strval(inputtext);
				new total = vsData[carid][tComp] + amount;

				if(isnull(inputtext))
				{
					new str[128];
					format(str, sizeof(str), "Safe Balance: %d\n\nPlease enter how much component you wish to deposit into the safe:", vsData[carid][tComp]);
					ShowPlayerDialog(playerid, TRUNK_DEPOSITCOMP, DIALOG_STYLE_INPUT, "Deposit into safe", str, "Deposit", "Back");
					return 1;
				}
				if(amount < 1 || amount > pData[playerid][pComponent] || total > 150)
				{
					new str[128];
					format(str, sizeof(str), "Error: Insufficient funds.\n\nSafe Balance: %d\n\nPlease enter how much component you wish to deposit into the safe:", vsData[carid][tComp]);
					ShowPlayerDialog(playerid, TRUNK_DEPOSITCOMP, DIALOG_STYLE_INPUT, "Deposit into safe", str, "Deposit", "Back");
					return 1;
				}
				vsData[carid][tComp] += amount;
				pData[playerid][pComponent] -= amount;

				Trunk_Save(i);
				Trunk_OpenStorage(playerid, carid);

				SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s has deposited %d into their vehicle storage.", ReturnName(playerid), amount);
			}
		}
	}
	if(dialogid == TRUNK_MATS)
	{
		if(response)
		{
			switch (listitem)
			{
				case 0:
				{
					new str[128];
					format(str, sizeof(str), "Please enter how much material you wish to withdraw from the safe:");
					ShowPlayerDialog(playerid, TRUNK_WITHDRAWMATS, DIALOG_STYLE_INPUT, "Withdraw from safe", str, "Withdraw", "Back");
				}
				case 1:
				{
					new str[128];
					format(str, sizeof(str), "Please enter how much material you wish to deposit into the safe:");
					ShowPlayerDialog(playerid, TRUNK_DEPOSITMATS, DIALOG_STYLE_INPUT, "Deposit into safe", str, "Deposit", "Back");
				}
			}
		}
		return 1;
	}
	if(dialogid == TRUNK_WITHDRAWMATS)
	{
		if(response)
		{
			new x = GetNearestVehicleToPlayer(playerid, 3.5, false);

			if(x == INVALID_VEHICLE_ID)
				return Error(playerid, "You not in near any vehicles.");

		    foreach(new i: PVehicles)
			if(x == pvData[i][cVeh])
			{
				new carid = pvData[i][cVeh];
				new amount = strval(inputtext);

				if(isnull(inputtext))
				{
					new str[128];
					format(str, sizeof(str), "Safe Balance: %d\n\nPlease enter how much material you wish to withdraw from the safe:", vsData[carid][tMats]);
					ShowPlayerDialog(playerid, TRUNK_WITHDRAWMATS, DIALOG_STYLE_INPUT, "Withdraw from safe", str, "Withdraw", "Back");
					return 1;
				}
				if(amount < 1 || amount > vsData[carid][tMats])
				{
					new str[128];
					format(str, sizeof(str), "Error: Insufficient funds.\n\nSafe Balance: %d\n\nPlease enter how much material you wish to withdraw from the safe:", vsData[carid][tMats]);
					ShowPlayerDialog(playerid, TRUNK_WITHDRAWMATS, DIALOG_STYLE_INPUT, "Withdraw from safe", str, "Withdraw", "Back");
					return 1;
				}
				vsData[carid][tMats] -= amount;
				pData[playerid][pMaterial] += amount;

				Trunk_Save(i);
				Trunk_OpenStorage(playerid, carid);

				SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s has withdrawn %d from their vehicle storage safe.", ReturnName(playerid), amount);
			}
		}
		return 1;
	}
	if(dialogid == TRUNK_DEPOSITMATS)
	{
		if(response)
		{
			new x = GetNearestVehicleToPlayer(playerid, 3.5, false);

			if(x == INVALID_VEHICLE_ID)
				return Error(playerid, "You not in near any vehicles.");

		    foreach(new i: PVehicles)
			if(x == pvData[i][cVeh])
			{
				new carid = pvData[i][cVeh];
				new amount = strval(inputtext);
				new total = vsData[carid][tMats] + amount;
				if(isnull(inputtext))
				{
					new str[128];
					format(str, sizeof(str), "Safe Balance: %d\n\nPlease enter how much material you wish to deposit into the safe:", vsData[carid][tMats]);
					ShowPlayerDialog(playerid, TRUNK_DEPOSITMATS, DIALOG_STYLE_INPUT, "Deposit into safe", str, "Deposit", "Back");
					return 1;
				}
				if(amount < 1 || amount > pData[playerid][pMaterial] || total > 150)
				{
					new str[128];
					format(str, sizeof(str), "Error: Insufficient funds.\n\nSafe Balance: %d\n\nPlease enter how much material you wish to deposit into the safe:", vsData[carid][tMats]);
					ShowPlayerDialog(playerid, TRUNK_DEPOSITMATS, DIALOG_STYLE_INPUT, "Deposit into safe", str, "Deposit", "Back");
					return 1;
				}
				vsData[carid][tMats] += amount;
				pData[playerid][pMaterial] -= amount;

				Trunk_Save(i);
				Trunk_OpenStorage(playerid, carid);

				SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s has deposited %d into their vehicle storage.", ReturnName(playerid), amount);
			}
		}
	}
	//End of trunk
	if(dialogid == DIALOG_VC)
	{
 		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
					return callcmd::v(playerid, "en");
				}
				case 1:
				{
					return callcmd::v(playerid, "lock");
				}
				case 2:
				{
					return callcmd::v(playerid, "lights");
				}
			}
			//return 1;
		}
	}
	if(dialogid == DIALOG_WORK)
	{
 		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
					return callcmd::mechduty(playerid);
				}
				case 1:
				{
					return callcmd::taxiduty(playerid);
				}
			}
		}
	}
	if(dialogid == DIALOG_TRACK)
	{
 		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
					return callcmd::tr(playerid, "ph");
				}
				case 1:
				{
					return callcmd::tr(playerid, "bis");
				}
				case 2:
				{
					return callcmd::tr(playerid, "house");
				}
				case 3:
				{
					return callcmd::tr(playerid, "flat");
				}
				case 4:
				{
					return callcmd::tr(playerid, "hotel");
				}
			}
			return 1;
		}
	}
	//graf
	if(dialogid == DIALOG_SELECT)
    {
        if(response)
        {
            switch(listitem)
            {
                case 0: ShowPlayerDialog(playerid, DIALOG_INPUTGRAFF, DIALOG_STYLE_INPUT, "Graffiti", "Please Enter Graffiti text", "Continue", "Cancel");
            }
        }
        return 1;
    }
    if(dialogid == BUY_SPRAYCAN)
    {
        if(response)
        {
            switch(listitem)
            {
                case 0: GivePlayerMoneyEx(playerid, -70), GivePlayerWeaponEx(playerid, 41, 300);
                case 1: GivePlayerMoneyEx(playerid, -120), GivePlayerWeaponEx(playerid, 41, 500);
                case 2: GivePlayerMoneyEx(playerid, -200), GivePlayerWeaponEx(playerid, 41, 900);
            }
        }
        return 1;
    }
    if(dialogid == DIALOG_LIST)
    {
        if(response)
        {
            new id = listitem;
           	new string[128];
			format(string, sizeof(string),"/Graffitis/%d.ini",id);
			if(!IsPlayerAdmin(playerid)) return GameTextForPlayer( playerid, "~r~You are not authorized \nto delete Graffitis!]",10000,5);
			if(!fexist(string))
			{
				format(string,sizeof(string),"~y~]~r~Something went wrong, try again~y~]",id);
				GameTextForPlayer(playerid, string,7000,3);
				return 1;
			}
    		fremove(string);
    		format(string,sizeof(string),"~y~]~g~Graffiti ~r~%d ~g~Succefully removed!~y~]",id);
    		GameTextForPlayer(playerid, string,7000,3);
    		DestroyDynamicObject( gInfo[id][OBJECTID] );
        }
        else return ShowPlayerDialog(playerid, DIALOG_SELECT, DIALOG_STYLE_LIST, "Graffiti Menu", "Enter Graffiti Text\nGraffiti List", "Select", "Exit");
        return 1;
    }


    if(dialogid == DIALOG_COLOR)
    {
        if(response)
        {

            switch(listitem)
            {

                case 0: POBJECTC[playerid] = "000000";// BLACK

                case 1: POBJECTC[playerid] = "FFFFFF"; // WHITE

                case 2: POBJECTC[playerid] = "F81414"; // RED

                case 3: POBJECTC[playerid] = "00FF22"; // GREEN

                case 4: POBJECTC[playerid] = "00CED1"; // LIGHTBLUE

                case 5: POBJECTC[playerid] = "C3C3C3";  // GREY


            }
			new string[128];
   			new string2[96];
			format(string2, sizeof(string2),"{%s}%s", POBJECTC[playerid], POBJECTN[playerid]);
   			POBJECTN[playerid] = string2;
			format(string,sizeof(string), ""COL_WHITE"Are you happy with your Color?\n"COL_ORANGE"%s (Points to spray %d)1 point/second", string2, sprayammountch[playerid]);
 			ShowPlayerDialog(playerid, DIALOG_HAPPY, DIALOG_STYLE_MSGBOX, "Graffiti Menu", string, "Yes", "No");
        }
        else return ShowPlayerDialog(playerid, DIALOG_INPUTGRAFF, DIALOG_STYLE_INPUT, "Graffiti", "Please Enter Graffiti text", "Continue", "Cancel");
        return 1;
    }
    if(dialogid == DIALOG_GDOBJECT)
	{
	    if(response)
	    {
	        DestroyDynamicObject(POBJECT[playerid]);
    		InfoTD_MSG(playerid, 4000, "Text ~r~Removed");
	   	}
	}
   	if(dialogid == DIALOG_GOMENU)
	{
	    if(response)
	    {
	   		switch (listitem)
			{
			    case 0:
			    {

			    }
			    case 1:
			    {
			    	DestroyDynamicObject(POBJECT[playerid]);
    				InfoTD_MSG(playerid, 4000, "Text ~r~Removed");
			    }
			}
	   	}
	}
    if(dialogid == DIALOG_HAPPY)
    {
        if(response)
        {
            creategraff(playerid);
        }
        else
        {
			ShowPlayerDialog(playerid, DIALOG_INPUTGRAFF, DIALOG_STYLE_INPUT, "Graffiti", "Please Enter Graffiti text", "Continue", "Cancel");
        }
        return 1;
    }


	if(dialogid == DIALOG_INPUTGRAFF)
    {
        if(!response) return ShowPlayerDialog(playerid, DIALOG_SELECT, DIALOG_STYLE_LIST, "Graffiti Menu", "Enter Graffiti Text", "Select", "Exit");

       	if(isnull(inputtext)) return ShowPlayerDialog(playerid, DIALOG_INPUTGRAFF, DIALOG_STYLE_INPUT, ""COL_WHITE"Graffiti", ""COL_RED"ERROR: No text was written \nPlease try again!", "Continue", "Cancel");
       	else
       	{
       	    new string[96];
       	    format(string, sizeof(string),"%s",inputtext);
       	    POBJECTN[playerid] = string;
       	    sprayammountch[playerid] = strlen(string);
       	    ShowPlayerDialog(playerid, DIALOG_COLOR, DIALOG_STYLE_LIST, "Color Menu", "{000000}Black\n{FFFFFF}White\n{F81414}Red\n{00FF22}Green\n{00CED1}Lightblue\n{C3C3C3}Grey", "Select", "Exit");
		}
        return 1;
    }
    //end
 	if(dialogid == DIALOG_INFO_BIS)
	{
 		if(response)
		{
			new bid = floatround(strval(inputtext));
			SetPVarInt(playerid, "IDBisnis", bid);
            if(!Iter_Contains(Bisnis, bid)) return Error(playerid, "The Bisnis specified Number doesn't exist.");
		 	pData[playerid][pActivity] = SetTimerEx("CheckingBis", 1300, true, "i", playerid);

			PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Loading...");
			PlayerTextDrawShow(playerid, ActiveTD[playerid]);
			ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
		}
		return 1;
	}
	if(dialogid == DIALOG_INFO_HOUSE)
	{
 		if(response)
		{
			new hid = floatround(strval(inputtext));
			SetPVarInt(playerid, "IDHouse", hid);
            if(!Iter_Contains(Bisnis, hid)) return Error(playerid, "The House specified Number doesn't exist.");
		 	pData[playerid][pActivity] = SetTimerEx("CheckingHouse", 1300, true, "i", playerid);

			PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Loading...");
			PlayerTextDrawShow(playerid, ActiveTD[playerid]);
			ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
		}
		return 1;
	}
	if(dialogid == DIALOG_INFO_FLAT)
	{
 		if(response)
		{
			new hid = floatround(strval(inputtext));
			SetPVarInt(playerid, "IDFlat", hid);
            if(!Iter_Contains(Bisnis, hid)) return Error(playerid, "The Flat specified Number doesn't exist.");
		 	pData[playerid][pActivity] = SetTimerEx("CheckingFlat", 1300, true, "i", playerid);

			PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Loading...");
			PlayerTextDrawShow(playerid, ActiveTD[playerid]);
			ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
		}
		return 1;
	}
	if(dialogid == DIALOG_INFO_HOTEL)
	{
 		if(response)
		{
			new hid = floatround(strval(inputtext));
			SetPVarInt(playerid, "IDHotel", hid);
            if(!Iter_Contains(Bisnis, hid)) return Error(playerid, "The Hotel specified Number doesn't exist.");
		 	pData[playerid][pActivity] = SetTimerEx("CheckingHotel", 1300, true, "i", playerid);

			PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Loading...");
			PlayerTextDrawShow(playerid, ActiveTD[playerid]);
			ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
		}
		return 1;
	}
	if(dialogid == DIALOG_TRACK_PH)
    {
    	if(response)
		{
			new number = floatround(strval(inputtext));

			foreach(new ii : Player)
			{
				if(pData[ii][pPhone] == number)
				{
					if(pData[ii][IsLoggedIn] == false || !IsPlayerConnected(ii) || pData[ii][pPhoneOff] == 1) return Error(playerid, "This number is not actived!");
					Info(playerid, "Proses Track Ph Number %d, Please Wait", number);
					SetTimerEx("trackph", random(10000)+1, false, "iid", playerid, ii, number);
					return 1;
				}
			}
		}
	}
	if(dialogid == DIALOG_SETFREQ)
    {
    	if(response)
		{
			new number = strval(inputtext);

			new tstr[64];
			Info(playerid, "You have set your walkie talkie channel to "LIME_E"%d", number);
			pData[playerid][pWT] = number;
			format(tstr, sizeof(tstr), "%d", number);
			PlayerTextDrawSetString(playerid, WT2[playerid], tstr);
			//Info(playerid, "Silahkan menekan angka jika ingin memasukkan freq, jika ingin keluar dari sini ketikan /setfreq kembali.");
			return 1;
		}
	}
	if(dialogid == DIALOG_CHECK_NAME)
    {
    	if(response)
		{

			new name = strval(inputtext);

			if(pData[name][IsLoggedIn] == false || !IsPlayerConnected(name)) return Error(playerid, "This id not actived!");
			new fac[24];
			if(pData[name][pFaction] == 1)
			{
				fac = "SAPD";
			}
			else if(pData[name][pFaction] == 2)
			{
				fac = "SAGS";
			}
			else if(pData[name][pFaction] == 3)
			{
				fac = "SAMD";
			}
			else if(pData[name][pFaction] == 4)
			{
				fac = "SANA";
			}
			else if(pData[name][pFaction] == 5)
			{
				fac = "GOJEK";
			}
			else
			{
				fac = "None";
			}
			new strings[64], tstr[64], ssring[64], sssring[64];
			PlayerTextDrawSetPreviewModel(playerid, MDCTD7[playerid], GetPlayerSkin(name));
			PlayerTextDrawShow(playerid, MDCTD7[playerid]);
			format(strings, sizeof(strings), "%s", pData[name][pName]);
			PlayerTextDrawSetString(playerid, MDCTD8[playerid], strings);
			format(tstr, sizeof(tstr), "PH: %d", pData[name][pPhone]);
			PlayerTextDrawSetString(playerid, MDCTD9[playerid], tstr);
			format(ssring, sizeof(ssring), "%s", GetJobName(pData[name][pJob]));
			PlayerTextDrawSetString(playerid, MDCTD10[playerid], ssring);
			format(sssring, sizeof(ssring), "%s", fac);
			PlayerTextDrawSetString(playerid, MDCTD11[playerid], sssring);
			Info(playerid, "Succes Check Id %s", name);
			//SetTimerEx("checkname", random(10000)+1, false, "ii", playerid, ii);
			return 1;
		}
	}
	//cctv
	if(dialogid == d_Cam)
	{
	    if(!response) return editId[playerid] = -1;
	    else{
	        SCM(playerid,c_green,"* Interpolation updated.");
	        new camid = editId[playerid];
			if(listitem == 0)
			{
			    DeleteGizmos(camid);
	  			camInfo[camid][c_Interpolated] = 0;
	  			SaveCamera(camid,0);
	  			CreateGizmos(camid);
			}
			else if(listitem == 1)
			{
			    DeleteGizmos(camid);
   				camInfo[camid][c_Interpolated] = 1;
   				SaveCamera(camid,0);
	        	CreateGizmos(camid);
			}
			else if(listitem == 2)
			{
			    DeleteGizmos(camid);
				camInfo[camid][c_Interpolated] = 2;
				SaveCamera(camid,0);
    			CreateGizmos(camid);
			}
			else if(listitem == 3)
			{
			    DeleteGizmos(camid);
   				camInfo[camid][c_Interpolated] = 3;
   				SaveCamera(camid,0);
	        	CreateGizmos(camid);
			}
	    }
	}
	if(dialogid == d_Camhelp)
	{
	    if(response)
		{
	    	if(listitem == 0) SCM(playerid,c_yellow,"» /newcam - This command is used to create a new camera.");
	    	else if(listitem == 1) SCM(playerid,c_yellow,"» /camint - This will let you change the interpolation state of your camera.");
			else if(listitem == 2) SCM(playerid,c_yellow,"» /editcam - This will display the edit UI, wich you can use to change camera's position.");
			else if(listitem == 3) SCM(playerid,c_yellow,"» /editlook - This will display the edit UI, wich you can use to change the position where your camera is looking.");
			else if(listitem == 4) SCM(playerid,c_yellow,"» /ieditcam - This will display the edit UI, wich you can use to change interpolated camera's position.");
			else if(listitem == 5) SCM(playerid,c_yellow,"» /ieditlook - This will display the edit UI, wich you can use to change the interpolated position where your camera is gonna look.");
			else if(listitem == 6) SCM(playerid,c_yellow,"» /camtime - This edits the camera position interpolation time.");
			else if(listitem == 7) SCM(playerid,c_yellow,"» /looktime - This edits the camera look at interpolation time.");
			else if(listitem == 8) SCM(playerid,c_yellow,"» /playcam - This will play the camera animation.");
			else if(listitem == 9) SCM(playerid,c_yellow,"» /stopcam - This will get you out of camera mode.");
			else if(listitem == 10) SCM(playerid,c_yellow,"» /exportcam - This will export the code lines you need to implement a camera animation in your script.");
			else if(listitem == 11) SCM(playerid,c_yellow,"» /editstop - In case the camera edit is stuck on, this will help fix the problem.");
	    }
	}
	//Phone
	if(dialogid == DIALOG_ENTERNUM)
	{
		if (response)
		{
		    static
		        name[32],
		        str[128],
				string[128];

			strunpack(name, pData[playerid][pEditingItem]);
			format(str, sizeof(str), "Contact Name: %s\n\nPlease enter the phone number for this contact:", name);
		    if (isnull(inputtext) || !IsNumeric(inputtext))
		    	return ShowPlayerDialog(playerid, DIALOG_ENTERNUM, DIALOG_STYLE_INPUT, "Contact Number", str, "Submit", "Back");

			for (new i = 0; i != MAX_CONTACTS; i ++)
			{
				if (!ContactData[playerid][i][contactExists])
				{
	            	ContactData[playerid][i][contactExists] = true;
	            	ContactData[playerid][i][contactNumber] = strval(inputtext);

					format(ContactData[playerid][i][contactName], 32, name);

					mysql_format(g_SQL, string, sizeof(string), "INSERT INTO `contacts` (`ID`, `contactName`, `contactNumber`) VALUES('%d', '%s', '%d')", pData[playerid][pID], name, ContactData[playerid][i][contactNumber]);
					mysql_tquery(g_SQL, string, "OnContactAdd", "dd", playerid, i);
					Info(playerid, "You have added \"%s\" to your contacts.", name);
	                return 1;
				}
		    }
		    Error(playerid, "There is no room left for anymore contacts.");
		}
		else {
			ShowContacts(playerid);
		}
		return 1;
	}

	if(dialogid == NEW_CONTACT)
	{
		if (response)
		{
			new str[128];

		    if (isnull(inputtext))
				return ShowPlayerDialog(playerid, NEW_CONTACT, DIALOG_STYLE_INPUT, "New Contact", "Error: Please enter a contact name.\n\nPlease enter the name of the contact below:", "Submit", "Back");

		    if (strlen(inputtext) > 32)
		        return ShowPlayerDialog(playerid, NEW_CONTACT, DIALOG_STYLE_INPUT, "New Contact", "Error: The contact name can't exceed 32 characters.\n\nPlease enter the name of the contact below:", "Submit", "Back");

			strpack(pData[playerid][pEditingItem], inputtext, 32);
			format(str, sizeof(str), "Contact Name: %s\n\nPlease enter the phone number for this contact:", inputtext);
		    ShowPlayerDialog(playerid, DIALOG_ENTERNUM, DIALOG_STYLE_INPUT, "Contact Number", str, "Submit", "Back");
		}
		else {
			ShowContacts(playerid);
		}
		return 1;
	}

	if(dialogid == CONTACT_INFO)
	{
		if (response)
		{
		    new
				id = pData[playerid][pContact],
				string[72];

			switch (listitem)
			{
			    case 0:
			    {
			    	format(string, 16, "%d", ContactData[playerid][id][contactNumber]);
			    	callcmd::call(playerid, string);
			    }
			    case 1:
			    {
			        mysql_format(g_SQL, string, sizeof(string), "DELETE FROM `contacts` WHERE `ID` = '%d' AND `contactID` = '%d'", pData[playerid][pID], ContactData[playerid][id][contactID]);
			        mysql_tquery(g_SQL, string);

			        Info(playerid, "You have deleted \"%s\" from your contacts.", ContactData[playerid][id][contactName]);

			        ContactData[playerid][id][contactExists] = false;
			        ContactData[playerid][id][contactNumber] = 0;
			        ContactData[playerid][id][contactID] = 0;

			        ShowContacts(playerid);
			    }
			}
		}
		else {
		    ShowContacts(playerid);
		}
		return 1;
	}

	if(dialogid == CONTACT)
	{
		if (response)
		{
		    if (!listitem) {
		        ShowPlayerDialog(playerid, NEW_CONTACT, DIALOG_STYLE_INPUT, "New Contact", "Please enter the name of the contact below:", "Submit", "Back");
		    }
		    else {
		    	pData[playerid][pContact] = ListedContacts[playerid][listitem - 1];
		        ShowPlayerDialog(playerid, CONTACT_INFO, DIALOG_STYLE_LIST, "Contact Info", "Call Contact\nDelete Contact", "Select", "Back");
		    }
		}
		else {
			callcmd::phone(playerid);
		}
		for (new i = 0; i != MAX_CONTACTS; i ++) {
		    ListedContacts[playerid][i] = -1;
		}
		return 1;
	}

	//MY PHONE
	if(dialogid == DIAL_NUMBER)
	{
		if (response)
		{
		    new
		        string[16];

		    if (isnull(inputtext) || !IsNumeric(inputtext))
		        return ShowPlayerDialog(playerid, DIAL_NUMBER, DIALOG_STYLE_INPUT, "Dial Number", "Please enter the number that you wish to dial below:", "Dial", "Back");

	        format(string, 16, "%d", strval(inputtext));
			callcmd::call(playerid, string);
		}
		else {
			callcmd::phone(playerid);
		}
		return 1;
	}

	if(dialogid == TEXT_MESSAGE)
	{
		if (response)
		{
			if (isnull(inputtext))
				return ShowPlayerDialog(playerid, TEXT_MESSAGE, DIALOG_STYLE_INPUT, "Text Message", "Error: Please enter a message to send.", "Send", "Back");

			new targetid = pData[playerid][pContact];
			foreach(new ii : Player)
			{
				if(pData[ii][pPhone] == targetid)
				{
					SendClientMessageEx(playerid, COLOR_YELLOW, "[SMS to %d]"WHITE_E" %s", targetid, inputtext);
					SendClientMessageEx(ii, COLOR_YELLOW, "[SMS from %d]"WHITE_E" %s", pData[playerid][pPhone], inputtext);
					Info(ii, "Gunakan "LB_E"'@<text>' "WHITE_E"untuk membalas SMS!");
					PlayerPlaySound(ii, 6003, 0,0,0);
					pData[ii][pSMS] = pData[playerid][pPhone];

					pData[playerid][pPhoneCredit] -= 1;
				}
			}
		}
		else {
	        ShowPlayerDialog(playerid, SEND_TEXT, DIALOG_STYLE_INPUT, "Send Text Message", "Please enter the number that you wish to send a text message to:", "Submit", "Back");
		}
		return 1;
	}
	if(dialogid == SEND_TEXT)
	{
		if (response)
		{
		    new ph = strval(inputtext);

		    if (isnull(inputtext) || !IsNumeric(inputtext))
		        return ShowPlayerDialog(playerid, SEND_TEXT, DIALOG_STYLE_INPUT, "Send Text Message", "Please enter the number that you wish to send a text message to:", "Dial", "Back");

		    foreach(new ii : Player)
			{
				if(pData[ii][pPhone] == ph)
				{
		        	if(ii == INVALID_PLAYER_ID || !IsPlayerConnected(ii))
		            	return ShowPlayerDialog(playerid, SEND_TEXT, DIALOG_STYLE_INPUT, "Send Text Message", "Error: That number is not online right now.\n\nPlease enter the number that you wish to send a text message to:", "Dial", "Back");

		            ShowPlayerDialog(playerid, TEXT_MESSAGE, DIALOG_STYLE_INPUT, "Text Message", "Please enter the message to send", "Send", "Back");
		        	pData[playerid][pContact] = ph;
		        }
		    }
		}
		else {
			callcmd::phone(playerid);
		}
		return 1;
	}
	if(dialogid == MY_PHONE)
	{
		if (response)
		{
			switch (listitem)
			{
			    case 0:
			    {
			        if (pData[playerid][pPhoneOff])
			            return Error(playerid, "Your phone must be powered on.");

					ShowPlayerDialog(playerid, DIAL_NUMBER, DIALOG_STYLE_INPUT, "Dial Number", "Please enter the number that you wish to dial below:", "Dial", "Back");
				}
				case 1:
				{
				    if (pData[playerid][pPhoneOff])
			            return Error(playerid, "Your phone must be powered on.");

			        if(pData[playerid][pPhoneBook] == 0)
						return Error(playerid, "You dont have a phone book.");

				    ShowContacts(playerid);
				}
			    case 2:
			    {
			        if (pData[playerid][pPhoneOff])
			            return Error(playerid, "Your phone must be powered on.");

			        ShowPlayerDialog(playerid, SEND_TEXT, DIALOG_STYLE_INPUT, "Send Text Message", "Please enter the number that you wish to send a text message to:", "Dial", "Back");
				}
				case 3:
				{
					ShowPlayerDialog(playerid, SHARE_LOC, DIALOG_STYLE_INPUT, "Shareloc", "Please enter the phone number that you wish to share locations to:", "Send", "Back");

				}
				case 4:
				{
				    if (pData[playerid][pPhoneOff])
			            return Error(playerid, "Your phone must be powered on.");

			        ShowPlayerDialog(playerid, PHONE_APP, DIALOG_STYLE_LIST, "Application", "Tweeter\nNotification", "Dial", "Back");
				}
				case 5:
				{
				    if (!pData[playerid][pPhoneOff])
				    {
						pData[playerid][pPhoneOff] = 1;
				        SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s powered off their cellphone.", ReturnName(playerid));
					}
					else
					{
					    pData[playerid][pPhoneOff] = 0;
				        SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s powered on their cellphone.", ReturnName(playerid));
					}
				}
			}
		}
		return 1;
	}
	if(dialogid == SHARE_LOC)
    {
    	if(response)
        {
        	new string[16];
			format(string, 16, "%d", strval(inputtext));
			callcmd::shareloc(playerid, string);
		}
	}
	if(dialogid == PHONE_APP)
    {
    	if(response)
        {
			switch(listitem)
	  		{
	  			case 0:
	  			{
					ShowPlayerDialog(playerid, TWEET_APP, DIALOG_STYLE_LIST, "Tweeter", "My account\nCreate Account", "Dial", "Back");
				}
				case 1://tot
	  			{
	  				new str[128], twet[64];
	  				if(pData[playerid][pTogTweet] == 0)
					{
						twet = ""GREEN_E"Enable";
					}
					else
					{
						twet = ""RED_E"Disable";
					}
	  				format(str, sizeof(str), "Tweeter\t"GREY3_E"%s", twet);
					ShowPlayerDialog(playerid, PHONE_NOTIF, DIALOG_STYLE_LIST, "Settings", str, "Select", "Close");
				}
			}
		}
	}
	if(dialogid == PHONE_NOTIF)
    {
    	if(response)
        {
			switch(listitem)
	  		{
				case 0:
				{
					ShowPlayerDialog(playerid, DIALOG_TWEETMODE, DIALOG_STYLE_LIST, "Tweet Settings", ""GREEN_E"Enable\n"RED_E"Disable", "Set", "Close");
				}
			}
		}
	}
	if(dialogid == DIALOG_TWEETMODE)
	{
		if(response)
		{
			switch(listitem)
			{
				case 0:
				{
					pData[playerid][pTogTweet] = 0;
					Info(playerid, "Sucesfull enable tweet notification");
				}
				case 1:
				{
					pData[playerid][pTogTweet] = 1;
					Info(playerid, "Sucesfull disable tweet notification");
				}
			}
		}
	}
	if(dialogid == TWEET_APP)
    {
    	if(response)
        {
			switch(listitem)
	  		{
	  			case 0:
	  			{
	  				if(!pData[playerid][pTweet]) return Error(playerid, "Anda tidak mempunyai akun twitter");

	  				new strl[128];
	  				format(strl, sizeof(strl), "Username: %s\nChange Username", pData[playerid][pTname]);
	  				ShowPlayerDialog(playerid, TWEET_CHANGENAME, DIALOG_STYLE_LIST, "My Account", strl, "Dial", "Back");
	  			}
	  			case 1:
	  			{
	  				if(pData[playerid][pTweet]) return Error(playerid, "Anda Sudah mempunyai akun twitter");
	  				ShowPlayerDialog(playerid, TWEET_SIGNUP, DIALOG_STYLE_MSGBOX, "Sign Up", "Baca Peraturan Dibawah ini Sebelum Membuat akun\n\n[-] Tidak boleh mempromosikan barang atau apapun bentuknya\n[-] Gunakan nama yang valid\n[-] Gunakan format [Post], [Reply] dsb untuk mengirim pesan\n[-] Dilarang mengirim pesan yang bersifat rasis, sara, ataupun insult\n\nAkun anda akan di blokir jika melanggar peraturan di atas,\nJika anda sudah memahami silahkan klik 'Selanjutnya'", "Selanjutnya", "Kembali");
	  			}
	  		}
	  	}
  	}
  	if(dialogid == TWEET_CHANGENAME)
    {
    	if(response)
        {
        	switch(listitem)
  			{
	  			case 0:
	  			{

	  			}
        		case 1:
        		{
        			ShowPlayerDialog(playerid, TWEET_ACCEPT_CHANGENAME, DIALOG_STYLE_INPUT, "Change Username", "Input new username", "Confirm", "Back");
        		}
        	}
        }
    }
    if(dialogid == TWEET_ACCEPT_CHANGENAME)
    {
    	if(response)
        {
        	new query[128];
			mysql_format(g_SQL, query, sizeof(query), "SELECT tnames FROM players WHERE tnames='%s'", inputtext);
			mysql_tquery(g_SQL, query, "ChangeTwitUserName", "is", playerid, inputtext);
		}
	}
    if(dialogid == TWEET_SIGNUP)
    {
    	if(response)
        {
        	ShowPlayerDialog(playerid, TWEET_ACCEPT_CHANGENAME, DIALOG_STYLE_INPUT, "Sign Up", "Masukkan untuk username acoount anda:", "Konfirmasi", "Kembali");
        }
        else
        {
        	ShowPlayerDialog(playerid, TWEET_APP, DIALOG_STYLE_LIST, "Tweeter", "My account\nCreate Account", "Dial", "Back");
        }
    }
	if(dialogid == DIALOG_BOOMBOX)
    {
    	if(!response)
     	{
            SendClientMessage(playerid, COLOR_WHITE, " Kamu Membatalkan Music");
        	return 1;
        }
		switch(listitem)
  		{
			case 1:
			{
			    ShowPlayerDialog(playerid,DIALOG_BOOMBOX1,DIALOG_STYLE_INPUT, "Boombox Input URL", "Please put a Music URL to play the Music", "Play", "Cancel");
			}
			case 2:
			{
                if(GetPVarType(playerid, "BBArea"))
			    {
			        new string[128], pNames[MAX_PLAYER_NAME];
			        GetPlayerName(playerid, pNames, MAX_PLAYER_NAME);
					format(string, sizeof(string), "* %s Mematikan Boomboxnya", pNames);
					SendNearbyMessage(playerid, 15, COLOR_PURPLE, string);
			        foreach(new i : Player)
					{
			            if(IsPlayerInDynamicArea(i, GetPVarInt(playerid, "BBArea")))
			            {
			                StopStream(i);
						}
					}
			        DeletePVar(playerid, "BBStation");
				}
				SendClientMessage(playerid, COLOR_WHITE, "Kamu Telah Mematikan Boomboxnya");
			}
        }
		return 1;
	}
	if(dialogid == DIALOG_BOOMBOX1)//SET URL
	{
		if(response == 1)
		{
		    if(isnull(inputtext))
		    {
		        SendClientMessage(playerid, COLOR_WHITE, "Kamu Tidak Menulis Apapun" );
		        return 1;
		    }
		    if(strlen(inputtext))
		    {
		        if(GetPVarType(playerid, "PlacedBB"))
				{
				    foreach(new i : Player)
					{
						if(IsPlayerInDynamicArea(i, GetPVarInt(playerid, "BBArea")))
						{
							PlayStream(i, inputtext, GetPVarFloat(playerid, "BBX"), GetPVarFloat(playerid, "BBY"), GetPVarFloat(playerid, "BBZ"), 30.0, 1);
				  		}
				  	}
			  		SetPVarString(playerid, "BBStation", inputtext);
				}
			}
		}
		else
		{
		    return 1;
		}
	}
	if(dialogid == DIALOG_MYVEH)
	{
		if(!response) return 1;
		SetPVarInt(playerid, "ClickedVeh", ReturnPlayerVehID(playerid, (listitem + 1)));
		ShowPlayerDialog(playerid, DIALOG_MYVEH_INFO, DIALOG_STYLE_LIST, "Vehicle Info", "Information Vehicle\nTrack Vehicle\nUnstuck Vehicle", "Select", "Cancel");
		return 1;
	}
	if(dialogid == DIALOG_MYVEH_INFO)
	{
		if(!response) return 1;
		new vid = GetPVarInt(playerid, "ClickedVeh");
		switch(listitem)
		{
			case 0:
			{
				
				if(IsValidVehicle(pvData[vid][cVeh]))
				{
					new line9[900];
				
					format(line9, sizeof(line9), "{ffffff}[{7348EB}INFO VEHICLE{ffffff}]:\nVehicle ID: {ffff00}%d\n{ffffff}Model: {ffff00}%s\n{ffffff}Plate: {ffff00}%s{ffffff}\n\n{ffffff}[{7348EB}DATA VEHICLE{ffffff}]:\nInsurance: {ffff00}%d{ffffff}",
					pvData[vid][cVeh], GetVehicleModelName(pvData[vid][cModel]), pvData[vid][cPlate], pvData[vid][cInsu]);

					ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_MSGBOX, "Vehicle Info", line9, "Close","");
				}
				else
				{
					new line9[900];
				
					format(line9, sizeof(line9), "{ffffff}[{7348EB}INFO VEHICLE{ffffff}]:\nVehicle UID: {ffff00}%d\n{ffffff}Model: {ffff00}%s\n{ffffff}Plate: {ffff00}%s{ffffff}\n\n{ffffff}[{7348EB}DATA VEHICLE{ffffff}]:\nInsurance: {ffff00}%d{ffffff}",
					pvData[vid][cID], GetVehicleModelName(pvData[vid][cModel]), pvData[vid][cPlate], pvData[vid][cInsu]);

					ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_MSGBOX, "Vehicle Info", line9, "Close","");
				}
			}
			case 1:
			{
				if(IsValidVehicle(pvData[vid][cVeh]))
				{
					new palid = pvData[vid][cVeh];
					new
			        	Float:x,
			        	Float:y,
			        	Float:z;

					pData[playerid][pTrackCar] = 1;
					GetVehiclePos(palid, x, y, z);
					SetPlayerRaceCheckpoint(playerid, 1, x, y, z, 0.0, 0.0, 0.0, 3.5);
					Info(playerid, "Ikuti checkpoint untuk menemukan kendaraan anda!");
				}
				else if(pvData[vid][cPark] > 0)
				{
					SetPlayerRaceCheckpoint(playerid, 1, pvData[vid][cPosX], pvData[vid][cPosY], pvData[vid][cPosZ], 0.0, 0.0, 0.0, 3.5);
					Info(playerid, "Ikuti checkpoint untuk menemukan kendaraan yang ada di dalam garkot!");
				}
				else if(pvData[vid][cClaim] != 0)
				{
					Info(playerid, "Kendaraan kamu di kantor insuransi!");
				}
				else if(pvData[vid][cStolen] != 0)
				{
					Info(playerid, "Kendaraan kamu di rusak kamu bisa memperbaikinya di kantor insuransi!");
				}
				else
					return Error(playerid, "Kendaraanmu belum di spawn!");
			}
			
		}
		return 1;
	}
	if(dialogid == DIALOG_LOCKTIRE)
	{
	    if(response)
	    {
	        new count;
         	foreach(new i : PVehicles)
	        {
				if(pvData[i][cLockTire] == 1)
				{
	            	if(pvData[i][cOwner] == pData[playerid][pID] && count++ == listitem)
	            	{
	            	    if(pvData[i][cLockTire] == 0)
	            	        return Error(playerid, "Kendaraan ini tidak di kunci!");

						pvData[i][cLockTire] = 0;
						pvData[i][cTicket] = 0;
						Servers(playerid, "Kamu berhasil membayar {FFFF00}%s {FFFFFF}milikmu dari kunci ban!", GetVehicleModelName(pvData[i][cModel]));
					}
				}
			}
		}
	}
 	if(dialogid == DIALOG_ACANIM)//ACTOR SYSTEM
	{
	    if(!response) return -1;
        new actorid = GetPVarInt(playerid, "aPlayAnim");
	    if(response)
	    {
	        if(listitem == 0)
	        {
				ApplyActorAnimation(actorid,"ped","SEAT_down",4.0,0,0,0,1,0);
				ActorsInfo[actorid][aAnim] = 1;
				SaveActors();

				SendClientMessageEx(playerid, COLOR_RIKO, "ACTORS: "WHITE_E"You have changed animation");
				/*format(string, sizeof(string), "ACTORS: Admin {FF0000}%s {FFFFFF}has edited actorid {FFFF00}%d{FFFFFF}'s Animation.", GetPlayerNameEx(playerid), actorid);
				Log("logs/acedit.log", string);*/
			}
	        if(listitem == 1)
	        {
				ApplyActorAnimation(actorid,"ped","Idlestance_fat",4.0,0,0,0,1,0);
				ActorsInfo[actorid][aAnim] = 2;
				SaveActors();

				SendClientMessageEx(playerid, COLOR_RIKO, "ACTORS: "WHITE_E"You have changed animation");
				/*format(string, sizeof(string), "{B0C4DE}ACTORS: Admin {FF0000}%s {FFFFFF}has edited actorid {FFFF00}%d{FFFFFF}'s Animation.", GetPlayerNameEx(playerid), actorid);
				Log("logs/acedit.log", string);*/
			}
	        if(listitem == 2)
	        {
				ApplyActorAnimation(actorid,"ped","Idlestance_old",4.0,0,0,0,1,0);
				ActorsInfo[actorid][aAnim] = 3;
				SaveActors();

				SendClientMessageEx(playerid, COLOR_RIKO, "ACTORS: "WHITE_E"You have changed animation");
				/*format(string, sizeof(string), "{B0C4DE}ACTORS: Admin {FF0000}%s {FFFFFF}has edited actorid {FFFF00}%d{FFFFFF}'s Animation.", GetPlayerNameEx(playerid), actorid);
				Log("logs/acedit.log", string);*/
			}
	        if(listitem == 3)
	        {
				ApplyActorAnimation(actorid,"POOL","POOL_Idle_Stance",4.0,0,0,0,1,0);
				ActorsInfo[actorid][aAnim] = 4;
				SaveActors();

				SendClientMessageEx(playerid, COLOR_RIKO, "ACTORS: "WHITE_E"You have changed animation");
				/*format(string, sizeof(string), "{B0C4DE}ACTORS: Admin {FF0000}%s {FFFFFF}has edited actorid {FFFF00}%d{FFFFFF}'s Animation.", GetPlayerNameEx(playerid), actorid);
				Log("logs/acedit.log", string);*/
			}
	        if(listitem == 4)
	        {
				ApplyActorAnimation(actorid,"ped","woman_idlestance",4.0,0,0,0,1,0);
				ActorsInfo[actorid][aAnim] = 5;
				SaveActors();

				SendClientMessageEx(playerid, COLOR_RIKO, "ACTORS: "WHITE_E"You have changed animation");
				/*format(string, sizeof(string), "{B0C4DE}ACTORS: Admin {FF0000}%s {FFFFFF}has edited actorid {FFFF00}%d{FFFFFF}'s Animation.", GetPlayerNameEx(playerid), actorid);
				Log("logs/acedit.log", string);*/
			}
	        if(listitem == 5)
	        {
				ApplyActorAnimation(actorid,"ped","IDLE_stance",4.0,0,0,0,1,0);
				ActorsInfo[actorid][aAnim] = 6;
				SaveActors();

				SendClientMessageEx(playerid, COLOR_RIKO, "ACTORS: "WHITE_E"You have changed animation");
				/*format(string, sizeof(string), "{B0C4DE}ACTORS: Admin {FF0000}%s {FFFFFF}has edited actorid {FFFF00}%d{FFFFFF}'s Animation.", GetPlayerNameEx(playerid), actorid);
				Log("logs/acedit.log", string);*/
			}
	        if(listitem == 6)
	        {
				ApplyActorAnimation(actorid,"COP_AMBIENT","Copbrowse_in",4.0,0,0,0,1,0);
				ActorsInfo[actorid][aAnim] = 7;
				SaveActors();

				SendClientMessageEx(playerid, COLOR_RIKO, "ACTORS: "WHITE_E"You have changed animation");
				/*format(string, sizeof(string), "{B0C4DE}ACTORS: Admin {FF0000}%s {FFFFFF}has edited actorid {FFFF00}%d{FFFFFF}'s Animation.", GetPlayerNameEx(playerid), actorid);
				Log("logs/acedit.log", string);*/
			}
	        if(listitem == 7)
	        {
				ApplyActorAnimation(actorid,"COP_AMBIENT","Copbrowse_loop",4.0,0,0,0,1,0);
				ActorsInfo[actorid][aAnim] = 8;
				SaveActors();

				SendClientMessageEx(playerid, COLOR_RIKO, "ACTORS: "WHITE_E"You have changed animation");
				/*format(string, sizeof(string), "{B0C4DE}ACTORS: Admin {FF0000}%s {FFFFFF}has edited actorid {FFFF00}%d{FFFFFF}'s Animation.", GetPlayerNameEx(playerid), actorid);
				Log("logs/acedit.log", string);*/
			}
	        if(listitem == 8)
	        {
				ApplyActorAnimation(actorid,"COP_AMBIENT","Copbrowse_nod",4.0,0,0,0,1,0);
				ActorsInfo[actorid][aAnim] = 9;
				SaveActors();

				SendClientMessageEx(playerid, COLOR_RIKO, "ACTORS: "WHITE_E"You have changed animation");
				/*format(string, sizeof(string), "{B0C4DE}ACTORS: Admin {FF0000}%s {FFFFFF}has edited actorid {FFFF00}%d{FFFFFF}'s Animation.", GetPlayerNameEx(playerid), actorid);
				Log("logs/acedit.log", string);*/
			}
	        if(listitem == 9)
	        {
				ApplyActorAnimation(actorid,"COP_AMBIENT","Copbrowse_out",4.0,0,0,0,1,0);
				ActorsInfo[actorid][aAnim] = 10;
				SaveActors();

				SendClientMessageEx(playerid, COLOR_RIKO, "ACTORS: "WHITE_E"You have changed animation");
				/*format(string, sizeof(string), "{B0C4DE}ACTORS: Admin {FF0000}%s {FFFFFF}has edited actorid {FFFF00}%d{FFFFFF}'s Animation.", GetPlayerNameEx(playerid), actorid);
				Log("logs/acedit.log", string);*/
			}
	        if(listitem == 10)
	        {
				ApplyActorAnimation(actorid,"COP_AMBIENT","Copbrowse_shake",4.0,0,0,0,1,0);
				ActorsInfo[actorid][aAnim] = 11;
				SaveActors();

				SendClientMessageEx(playerid, COLOR_RIKO, "ACTORS: "WHITE_E"You have changed animation");
				/*format(string, sizeof(string), "{B0C4DE}ACTORS: Admin {FF0000}%s {FFFFFF}has edited actorid {FFFF00}%d{FFFFFF}'s Animation.", GetPlayerNameEx(playerid), actorid);
				Log("logs/acedit.log", string);*/
			}
	        if(listitem == 11)
	        {
				ApplyActorAnimation(actorid,"COP_AMBIENT","Coplook_in",4.0,0,0,0,1,0);
				ActorsInfo[actorid][aAnim] = 12;
				SaveActors();

				SendClientMessageEx(playerid, COLOR_RIKO, "ACTORS: "WHITE_E"You have changed animation");
				/*format(string, sizeof(string), "{B0C4DE}ACTORS: Admin {FF0000}%s {FFFFFF}has edited actorid {FFFF00}%d{FFFFFF}'s Animation.", GetPlayerNameEx(playerid), actorid);
				Log("logs/acedit.log", string);*/
			}
	        if(listitem == 12)
	        {
				ApplyActorAnimation(actorid,"COP_AMBIENT","Coplook_loop",4.0,0,0,0,1,0);
				ActorsInfo[actorid][aAnim] = 13;
				SaveActors();

				SendClientMessageEx(playerid, COLOR_RIKO, "ACTORS: "WHITE_E"You have changed animation");
				/*format(string, sizeof(string), "{B0C4DE}ACTORS: Admin {FF0000}%s {FFFFFF}has edited actorid {FFFF00}%d{FFFFFF}'s Animation.", GetPlayerNameEx(playerid), actorid);
				Log("logs/acedit.log", string);*/
			}
	        if(listitem == 13)
	        {
				ApplyActorAnimation(actorid,"COP_AMBIENT","Coplook_nod",4.0,0,0,0,1,0);
				ActorsInfo[actorid][aAnim] = 14;
				SaveActors();

				SendClientMessageEx(playerid, COLOR_RIKO, "ACTORS: "WHITE_E"You have changed animation");
				/*format(string, sizeof(string), "{B0C4DE}ACTORS: Admin {FF0000}%s {FFFFFF}has edited actorid {FFFF00}%d{FFFFFF}'s Animation.", GetPlayerNameEx(playerid), actorid);
				Log("logs/acedit.log", string);*/
			}
	        if(listitem == 14)
	        {
				ApplyActorAnimation(actorid,"COP_AMBIENT","Coplook_out",4.0,0,0,0,1,0);
				ActorsInfo[actorid][aAnim] = 15;
				SaveActors();

				SendClientMessageEx(playerid, COLOR_RIKO, "ACTORS: "WHITE_E"You have changed animation");
				/*format(string, sizeof(string), "{B0C4DE}ACTORS: Admin {FF0000}%s {FFFFFF}has edited actorid {FFFF00}%d{FFFFFF}'s Animation.", GetPlayerNameEx(playerid), actorid);
				Log("logs/acedit.log", string);*/
			}
	        if(listitem == 15)
	        {
				ApplyActorAnimation(actorid,"COP_AMBIENT","Coplook_shake",4.0,0,0,0,1,0);
				ActorsInfo[actorid][aAnim] = 16;
				SaveActors();

				SendClientMessageEx(playerid, COLOR_RIKO, "ACTORS: "WHITE_E"You have changed animation");
				/*format(string, sizeof(string), "{B0C4DE}ACTORS: Admin {FF0000}%s {FFFFFF}has edited actorid {FFFF00}%d{FFFFFF}'s Animation.", GetPlayerNameEx(playerid), actorid);
				Log("logs/acedit.log", string);*/
			}
	        if(listitem == 16)
	        {
				ApplyActorAnimation(actorid,"COP_AMBIENT","Coplook_think",4.0,0,0,0,1,0);
				ActorsInfo[actorid][aAnim] = 17;
				SaveActors();

				SendClientMessageEx(playerid, COLOR_RIKO, "ACTORS: "WHITE_E"You have changed animation");
				/*format(string, sizeof(string), "{B0C4DE}ACTORS: Admin {FF0000}%s {FFFFFF}has edited actorid {FFFF00}%d{FFFFFF}'s Animation.", GetPlayerNameEx(playerid), actorid);
				Log("logs/acedit.log", string);*/
			}
	        if(listitem == 17)
	        {
				ApplyActorAnimation(actorid,"COP_AMBIENT","Coplook_watch",4.0,0,0,0,1,0);
				ActorsInfo[actorid][aAnim] = 18;
				SaveActors();

				SendClientMessageEx(playerid, COLOR_RIKO, "ACTORS: "WHITE_E"You have changed animation");
				/*format(string, sizeof(string), "{B0C4DE}ACTORS: Admin {FF0000}%s {FFFFFF}has edited actorid {FFFF00}%d{FFFFFF}'s Animation.", GetPlayerNameEx(playerid), actorid);
				Log("logs/acedit.log", string);*/
			}
	        if(listitem == 18)
	        {
				ApplyActorAnimation(actorid,"GANGS","leanIDLE",4.0,0,0,0,1,0);
				ActorsInfo[actorid][aAnim] = 19;
				SaveActors();

				SendClientMessageEx(playerid, COLOR_RIKO, "ACTORS: "WHITE_E"You have changed animation");
				/*format(string, sizeof(string), "{B0C4DE}ACTORS: Admin {FF0000}%s {FFFFFF}has edited actorid {FFFF00}%d{FFFFFF}'s Animation.", GetPlayerNameEx(playerid), actorid);
				Log("logs/acedit.log", string);*/
			}
	        if(listitem == 19)
	        {
				ApplyActorAnimation(actorid,"MISC","Plyrlean_loop",4.0,0,0,0,1,0);
				ActorsInfo[actorid][aAnim] = 20;
				SaveActors();

				SendClientMessageEx(playerid, COLOR_RIKO, "ACTORS: "WHITE_E"You have changed animation");
				/*format(string, sizeof(string), "{B0C4DE}ACTORS: Admin {FF0000}%s {FFFFFF}has edited actorid {FFFF00}%d{FFFFFF}'s Animation.", GetPlayerNameEx(playerid), actorid);
				Log("logs/acedit.log", string);*/
			}
	        if(listitem == 20)
	        {
				ApplyActorAnimation(actorid,"KNIFE", "KILL_Knife_Ped_Die",4.0,0,0,0,1,0);
				ActorsInfo[actorid][aAnim] = 21;
				SaveActors();

				SendClientMessageEx(playerid, COLOR_RIKO, "ACTORS: "WHITE_E"You have changed animation");
				/*format(string, sizeof(string), "{B0C4DE}ACTORS: Admin {FF0000}%s {FFFFFF}has edited actorid {FFFF00}%d{FFFFFF}'s Animation.", GetPlayerNameEx(playerid), actorid);
				Log("logs/acedit.log", string);*/
			}
	        if(listitem == 21)
	        {
				ApplyActorAnimation(actorid,"PED", "KO_shot_face",4.0,0,0,0,1,0);
				ActorsInfo[actorid][aAnim] = 22;
				SaveActors();

				SendClientMessageEx(playerid, COLOR_RIKO, "ACTORS: "WHITE_E"You have changed animation");
				/*format(string, sizeof(string), "{B0C4DE}ACTORS: Admin {FF0000}%s {FFFFFF}has edited actorid {FFFF00}%d{FFFFFF}'s Animation.", GetPlayerNameEx(playerid), actorid);
				Log("logs/acedit.log", string);*/
			}
	        if(listitem == 22)
	        {
				ApplyActorAnimation(actorid,"PED", "KO_shot_stom",4.0,0,0,0,1,0);
				ActorsInfo[actorid][aAnim] = 23;
				SaveActors();

				SendClientMessageEx(playerid, COLOR_RIKO, "ACTORS: "WHITE_E"You have changed animation");
				/*format(string, sizeof(string), "{B0C4DE}ACTORS: Admin {FF0000}%s {FFFFFF}has edited actorid {FFFF00}%d{FFFFFF}'s Animation.", GetPlayerNameEx(playerid), actorid);
				Log("logs/acedit.log", string);*/
			}
	        if(listitem == 23)
	        {
				ApplyActorAnimation(actorid,"PED", "BIKE_fallR",4.0,0,0,0,1,0);
				ActorsInfo[actorid][aAnim] = 24;
				SaveActors();

				SendClientMessageEx(playerid, COLOR_RIKO, "ACTORS: "WHITE_E"You have changed animation");
				/*format(string, sizeof(string), "{B0C4DE}ACTORS: Admin {FF0000}%s {FFFFFF}has edited actorid {FFFF00}%d{FFFFFF}'s Animation.", GetPlayerNameEx(playerid), actorid);
				Log("logs/acedit.log", string);*/
			}
	        if(listitem == 24)
	        {
				ApplyActorAnimation(actorid,"PED", "BIKE_fall_off",4.0,0,0,0,1,0);
				ActorsInfo[actorid][aAnim] = 25;
				SaveActors();

				SendClientMessageEx(playerid, COLOR_RIKO, "ACTORS: "WHITE_E"You have changed animation");
				/*format(string, sizeof(string), "{B0C4DE}ACTORS: Admin {FF0000}%s {FFFFFF}has edited actorid {FFFF00}%d{FFFFFF}'s Animation.", GetPlayerNameEx(playerid), actorid);
				Log("logs/acedit.log", string);*/
			}
	        if(listitem == 25)
	        {
				ApplyActorAnimation(actorid,"SWAT","gnstwall_injurd",4.0,0,0,0,1,0);
				ActorsInfo[actorid][aAnim] = 26;
				SaveActors();

				SendClientMessageEx(playerid, COLOR_RIKO, "ACTORS: "WHITE_E"You have changed animation");
				/*format(string, sizeof(string), "{B0C4DE}ACTORS: Admin {FF0000}%s {FFFFFF}has edited actorid {FFFF00}%d{FFFFFF}'s Animation.", GetPlayerNameEx(playerid), actorid);
				Log("logs/acedit.log", string);*/
			}
	        if(listitem == 26)
	        {
				ApplyActorAnimation(actorid,"SWEET","Sweet_injuredloop",4.0,0,0,0,1,0);
				ActorsInfo[actorid][aAnim] = 27;
				SaveActors();

				SendClientMessageEx(playerid, COLOR_RIKO, "ACTORS: "WHITE_E"You have changed animation");
				/*format(string, sizeof(string), "{B0C4DE}ACTORS: Admin {FF0000}%s {FFFFFF}has edited actorid {FFFF00}%d{FFFFFF}'s Animation.", GetPlayerNameEx(playerid), actorid);
				Log("logs/acedit.log", string);*/
			}
		}
	}
    return 1;
}

