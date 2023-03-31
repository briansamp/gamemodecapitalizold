//-------------[ Player Commands ]-------------//
CMD:help(playerid, params[])
{
	ShowPlayerDialog(playerid, DIALOG_HELP, DIALOG_STYLE_LIST, "Help List", "General Commands\n"GREY_E"Chat Commands"WHITE_E"\nVehicle Commands\n"GREY_E"Job Commands"WHITE_E"\nFaction Commands\n"GREY_E"Family Commands"WHITE_E"\nBisnis Commands\n"GREY_E"House Commands"WHITE_E"\nFlat Commands\n"GREY_E"Hotel Command"WHITE_E"\nWorkshop Commands\n"GREY_E"Dealership Commands"WHITE_E"\nDonate Menu\n"GREY_E"Server Credits"WHITE_E"\nServer Info", "Select", "Close");
	return 1;
}

CMD:jobhelp(playerid)
{
	ShowPlayerDialog(playerid, DIALOG_JOBHELP, DIALOG_STYLE_LIST, "Job Help", "Taxi Driver\nMechanic Service\nProduction\nLumberjack\nFarmers\nMiner\nTrucker\nSweeper\nBus Driver\nTrashmaster\nPizza Boy\n{FF0000}Drug Smuggler\nPemotong Ayam\n{FF0000}Borax", "Select", "Close");
	return 1;
}

CMD:findatm(playerid)
{
	new
	han2[MAX_ATM * 32];

	han2 = "ID\tLocation\n";

   	foreach(new bid : Trees)
	{
 	   format(han2, sizeof(han2), "%s%d\t"RED_E"%.1f m\n", han2,
 	   bid, GetPlayerDistanceFromPoint(playerid, AtmData[bid][atmX], AtmData[bid][atmY], AtmData[bid][atmZ]));
	}
	ShowPlayerDialog(playerid, DIALOG_FIND_ATM, DIALOG_STYLE_TABLIST_HEADERS, "Atm Location", han2, "Select", "Close");
	return 1;
}
CMD:hauling(playerid)
{
    new vehicleid = GetPlayerVehicleID(playerid);
	if(GetPlayerState(playerid) != PLAYER_STATE_DRIVER && !IsATruck(vehicleid)) return Error(playerid, "Anda harus mengendarai truck.");

    if(pData[playerid][pJob] == 4 || pData[playerid][pJob2] == 4 || pData[playerid][pTruckerLic] == 1)
	{
	ShowPlayerDialog(playerid, DIALOG_TAKEHAULING, DIALOG_STYLE_LIST, "Hauling Mission", "GasStation Mission\nDealer Mission\nContainer Delivery", "Select", "Close");
	}
	else return Error(playerid, "You are not trucker job.");
	return 1;
}

CMD:paytire(playerid, params[])
{
	if (!IsPlayerInRangeOfPoint(playerid, 3.0, 1558.7731, -1672.3914, 2113.0349))
	    return Error(playerid, "You must be at SAPD HQ to pay your tickets.");

	new bool:found = false, msg2[512];
	format(msg2, sizeof(msg2), "Model\tReason\tTicket\n");
	foreach(new i : PVehicles)
	{
		if(pvData[i][cLockTire] == 1 && pvData[i][cClaim] == 0)
		{
			if(pvData[i][cOwner] == pData[playerid][pID])
			{
				if(strcmp(pvData[i][cPlate], "NoHave"))
				{
					format(msg2, sizeof(msg2), "%s%s("GREEN_E"%s"WHITE_E")\t%s\t%s\n", msg2, GetVehicleModelName(pvData[i][cModel]), pvData[i][cPlate], pvData[i][cReason], FormatMoney(pvData[i][cTicket]));
					found = true;
				}
				else
				{
					format(msg2, sizeof(msg2), "%s%s("GREEN_E"NoHave"WHITE_E")\t%s\t%s\n", msg2, GetVehicleModelName(pvData[i][cModel]), pvData[i][cReason], FormatMoney(pvData[i][cTicket]));
					found = true;
				}
			}
		}
	}
	if(found)
		ShowPlayerDialog(playerid, DIALOG_LOCKTIRE, DIALOG_STYLE_TABLIST_HEADERS, "Ticket Vehicle", msg2, "Select", "Close");
	else
		ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_MSGBOX, "Vehicles", "There is no vehicle in the ticket.", "Close", "");
	return 1;
}

CMD:teriak(playerid, params[])
{
	if(pData[playerid][pInjured] != 1) return Error(playerid, "Anda Tidak Pingsan");
	{
		new Float:x, Float:y, Float:z;
		GetPlayerPos(playerid, x, y, z);
		Info(playerid, "Info: Sinyal kamu Sudah berasil di sampaikan Silakan Tunggu Ems Datang!");
		SendFactionMessage(3, COLOR_PINK2, "[EMERGENCY DOWN] "WHITE_E"%s [ID: %d] NOMER INI MENGIRIM SINYAL! Ph: ["GREEN_E"%d"WHITE_E"] | Location: %s", ReturnName(playerid), playerid, pData[playerid][pPhone], GetLocation(x, y, z));
	}
	return 1;
}

CMD:credits(playerid)
{
	if(pData[playerid][pFreeze] == 1)
	return Error(playerid, "Anda sedang di Freeze oleh staff, tidak dapat menggunakan ini");
	if(pData[playerid][pCuffed] == 1)
	return Error(playerid, "Anda sedang di borgol oleh kepolisian, tidak dapat menggunakan ini");
	new line1[1200], line2[300], line3[500];
	strcat(line3, "Chief Executive Officer: "YELLOW_E"=\n");
	strcat(line3, "Developer: "YELLOW_E"=ades & burton\n");
	strcat(line3, "Server Manager: "YELLOW_E"=\n");
	strcat(line3, "Support Mapper: "YELLOW_E"=\n");
	strcat(line3, "Gamemode Creator: "YELLOW_E"Dandy Prasetyo\n");
	format(line2, sizeof(line2), ""LB_E"Server Support: "YELLOW_E"%s & All SA-MP Team\n\n\
	"GREEN_E"Terima kasih telah bergabung dengan kami! Copyright © 2023.", pData[playerid][pName]);
	format(line1, sizeof(line1), "%s%s", line3, line2);
   	ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_MSGBOX, ""ORANGE_E"CPPR: "WHITE_E"Server Credits", line1, "OK", "");
	return 1;
}

CMD:email(playerid)
{
    if(pData[playerid][IsLoggedIn] == false)
		return Error(playerid, "You must be logged in to change your email address!");

	ShowPlayerDialog(playerid, DIALOG_EMAIL, DIALOG_STYLE_INPUT, ""WHITE_E"Set your email address", ""WHITE_E"Enter your email address below.\nThis will be used to reset your password incase you lose it.\n\n"RED_E"* "WHITE_E"Your e-mail is confidential and will not be displayed publicly\n"RED_E"* "WHITE_E"Emails will only be sent for a password reset or important news\n\
	"RED_E"* "WHITE_E"Be sure to double-check and enter a valid email address!", "Enter", "Exit");
	return 1;
}

CMD:changepass(playerid)
{
    if(pData[playerid][IsLoggedIn] == false)
		return Error(playerid, "You must be logged in to change your email address!");

	ShowPlayerDialog(playerid, DIALOG_PASSWORD, DIALOG_STYLE_INPUT, ""WHITE_E"Change your password", "Insert your new password to change!", "Change", "Exit");
	InfoTD_MSG(playerid, 3000, "~g~~h~Insert your current password!");
	return 1;
}

CMD:savestats(playerid, params[])
{
	if(pData[playerid][IsLoggedIn] == false)
		return Error(playerid, "You are not logged in!");

	UpdatePlayerData(playerid);
	Servers(playerid, "Your statistics has successfully saved in database!");
	return 1;
}

CMD:gshop(playerid, params[])
{
	new Dstring[512];
	format(Dstring, sizeof(Dstring), "Gold Shop\tPrice\n\
	Instant Change Name\t500 Gold\n");
	format(Dstring, sizeof(Dstring), "%sClear Warning\t1000 Gold\n", Dstring);
	format(Dstring, sizeof(Dstring), "%sCustom Vehicle Plate\t250 Gold\n", Dstring);
	format(Dstring, sizeof(Dstring), "%sVIP Level 1(7 Days)\t150 Gold\n", Dstring);
	format(Dstring, sizeof(Dstring), "%sVIP Level 2(7 Days)\t250 Gold\n", Dstring);
	format(Dstring, sizeof(Dstring), "%sVIP Level 3(7 Days)\t500 Gold\n", Dstring);
	ShowPlayerDialog(playerid, DIALOG_GOLDSHOP, DIALOG_STYLE_TABLIST_HEADERS, "Gold Shop", Dstring, "Buy", "Cancel");
	return 1;
}

CMD:mypos(playerid, params[])
{
	new int, Float:px,Float:py,Float:pz, Float:a;
	GetPlayerPos(playerid, px, py, pz);
	GetPlayerFacingAngle(playerid, a);
	int = GetPlayerInterior(playerid);
	new zone[MAX_ZONE_NAME];
	GetPlayer3DZone(playerid, zone, sizeof(zone));
	SendClientMessageEx(playerid, COLOR_PINK, "Lokasi Anda Saat Ini: %s (%0.2f, %0.2f, %0.2f, %0.2f) Int = %d", zone, px, py, pz, a, int);
	return 1;
}

CMD:gps(playerid, params[])
{
	if(pData[playerid][pGPS] < 1) return Error(playerid, "Anda tidak memiliki GPS.");
	if(pData[playerid][pJob] == 4 || pData[playerid][pJob2] == 4)
	{
		ShowPlayerDialog(playerid, DIALOG_GPS, DIALOG_STYLE_LIST, "GPS Menu", "Disable GPS\nFaction\nPublic GPS\nJobs\nMy property\nDMV Location\nOnly Trucker", "Select", "Close");
	}
	else 
	{
		ShowPlayerDialog(playerid, DIALOG_GPS, DIALOG_STYLE_LIST, "GPS Menu", "Disable GPS\nFaction\nPublic GPS\nJobs\nMy property\nDMV Location", "Select", "Close");
	}
	return 1;
}
CMD:gpsbis(playerid)
{
	new
 	han2[MAX_BISNIS * 32];

	han2 = "ID\tName\tType\tLocation\n";

    new type[128];
   	foreach(new bid : Bisnis)
	{
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

	    format(han2, sizeof(han2), "%s%d\t%s\t%s\t"RED_E"%.1f m\n", han2,
	    bid, bData[bid][bName], type, GetPlayerDistanceFromPoint(playerid, bData[bid][bExtposX], bData[bid][bExtposY], bData[bid][bExtposZ]));
	}
	ShowPlayerDialog(playerid, DIALOG_FIND_BISNIS, DIALOG_STYLE_TABLIST_HEADERS, "Business Location", han2, "Select", "Close");
	return 1;
}

CMD:death(playerid, params[])
{
    if(pData[playerid][pInjured] == 0)
        return Error(playerid, "You are not injured at the moment.");

	if(pData[playerid][pJail] > 0)
		return Error(playerid, "You can't do this when in jail!");

	if(pData[playerid][pArrest] > 0)
		return Error(playerid, "You can't do this when in arrest sapd!");

    if((gettime()-GetPVarInt(playerid, "GiveUptime")) < 100)
        return Error(playerid, "You must waiting 3 minutes for spawn to hospital");

	/*if(pMatiPukul[playerid] == 1)
	{
	    SetPlayerHealthEx(playerid, 50.0);
	    ClearAnimations(playerid);
	    pData[playerid][pInjured] = 0;
	    pMatiPukul[playerid] = 0;
    	Servers(playerid, "You have wake up and accepted death in your position.");
    	return 1;
	}*/
    Servers(playerid, "You have given up and accepted your death.");
	pData[playerid][pHospitalTime] = 0;
	pData[playerid][pHospital] = 1;
    return 1;
}

CMD:sleep(playerid, params[])
{
	if(pData[playerid][pInjured] == 1)
        return Error(playerid, "You can't use this command at the injured moment.");

	if(pData[playerid][pInHouse] == -1)
		return Error(playerid, "You must inside a house to sleep.");

	InfoTD_MSG(playerid, 10000, "Sleeping... Please wait!");
	TogglePlayerControllable(playerid, 0);
	new time = (100 - pData[playerid][pEnergy]) * (400);
    SetTimerEx("UnfreezeSleep", time, 0, "i", playerid);
	switch(random(6))
	{
		case 0: ApplyAnimation(playerid, "INT_HOUSE", "BED_In_L",4.1,0,0,0,1,1);
		case 1: ApplyAnimation(playerid, "INT_HOUSE", "BED_In_R",4.1,0,0,0,1,1);
		case 2: ApplyAnimation(playerid, "INT_HOUSE", "BED_Loop_L",4.1,1,0,0,1,1);
		case 3: ApplyAnimation(playerid, "INT_HOUSE", "BED_Loop_R",4.1,1,0,0,1,1);
		case 4: ApplyAnimation(playerid, "INT_HOUSE", "BED_Out_L",4.1,0,1,1,0,0);
		case 5: ApplyAnimation(playerid, "INT_HOUSE", "BED_Out_R",4.1,0,1,1,0,0);
	}
	return 1;
}

CMD:time(playerid)
{
	if(pData[playerid][IsLoggedIn] == false)
		return Error(playerid, "You must logged in!");

	new line2[1200];
	new paycheck = 3600 - pData[playerid][pPaycheck];
	if(paycheck < 1)
	{
		paycheck = 0;
	}

	format(line2, sizeof(line2), ""WHITE_E"Paycheck Time: "YELLOW_E"%d remaining\n"WHITE_E"Job Delay Time: "RED_E"%d second\n"WHITE_E"Side Job Delay Time: "RED_E"%d second\n"WHITE_E"Plant Time(Farmer): "RED_E"%d second\n"WHITE_E"Arrest Time: "RED_E"%d second\n"WHITE_E"Jail Time: "RED_E"%d second\n", paycheck, pData[playerid][pJobTime], pData[playerid][pSideJobTime], pData[playerid][pPlantTime], pData[playerid][pArrestTime], pData[playerid][pJailTime]);
   	ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_MSGBOX, ""ORANGE_E"HomeBaseRp: "WHITE_E"My Time", line2, "Okay", "");
	return 1;
}

CMD:delays(playerid)
{
	if(pData[playerid][IsLoggedIn] == false)
		return Error(playerid, "You must logged in!");

	new String[1200];

	format(String, sizeof(String), "Jobs\tTime\n\
	Sweeper\t"YELLOW_E"%d\n", pData[playerid][pSweeperTime]);
	format(String, sizeof(String), "%sBus Driver\t"YELLOW_E"%d\n", String, pData[playerid][pBusTime]);
	format(String, sizeof(String), "%sForklift\t"YELLOW_E"%d\n", String, pData[playerid][pForkliftTime]);
	format(String, sizeof(String), "%sPizza delivery\t"YELLOW_E"%d\n", String, pData[playerid][pPizzaTime]);

   	ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_TABLIST_HEADERS, "SideJob Time", String, "Okay", "");
	return 1;
}

CMD:drivelic(playerid, params[])
{
	if(pData[playerid][pDriveLic] == 0) return Error(playerid, "Anda tidak memiliki Driving License/SIM!");
	new sext[40];
	if(pData[playerid][pGender] == 1) { sext = "Male"; } else { sext = "Female"; }
	SendNearbyMessage(playerid, 20.0, COLOR_GREEN, "[Drive-Lic] "GREY3_E"Name: %s | Gender: %s | Brithday: %s | Expire: %s.", pData[playerid][pName], sext, pData[playerid][pAge], ReturnTimelapse(gettime(), pData[playerid][pDriveLicTime]));
	return 1;
}

CMD:licbiz(playerid, params[])
{
	if(pData[playerid][pDriveLic] == 0) return Error(playerid, "Anda tidak memiliki Business Lic!");
	new sext[40];
	if(pData[playerid][pGender] == 1) { sext = "Male"; } else { sext = "Female"; }
	SendNearbyMessage(playerid, 20.0, COLOR_GREEN, "[Business-Lic] "GREY3_E"Name: %s | Gender: %s | Brithday: %s | Expire: %s.", pData[playerid][pName], sext, pData[playerid][pAge], ReturnTimelapse(gettime(), pData[playerid][pLicBizTime]));
	return 1;
}

CMD:showskck(playerid, params[])
{
    if(!pData[playerid][pSkck])
	 	return Error(playerid, "Anda Tidak Memiliki SKCK");


	new to_player;
    if(sscanf(params, "u", to_player))
        return Usage(playerid, "/showskck [playerid/PartOfName]");
	if(!NearPlayer(playerid, to_player, 6.0))
		return SendClientMessage(playerid, 0xCECECEFF, "Pemainnya terlalu jauh");

	new sext[40], lstr[128], mstr[128];
	if(pData[to_player][pGender] == 1) { sext = "Laki-Laki"; } else { sext = "Perempuan"; }
	format(mstr, sizeof(mstr), "Surat SKCK %s", pData[playerid][pName]);
	format(mstr,sizeof(mstr), "{FFFFFF}Nama: %s\nNegara: San Andreas\nTgl Lahir: %s\nJenis Kelamin: %s\nSisa Waktu: %s", pData[playerid][pName], pData[playerid][pAge], sext,  ReturnTimelapse(gettime(), pData[playerid][pSkckTime]));
	ShowPlayerDialog(to_player, DIALOG_UNUSED, DIALOG_STYLE_MSGBOX, lstr, mstr, "Tutup", "");
	SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s Memperlihatkan Surat SKCK Kepada %s", ReturnName(playerid), ReturnName(to_player));
	return 1;
}
CMD:showtrucker(playerid, params[])
{
    if(!pData[playerid][pTruckerLic])
	 	return Error(playerid, "Anda Tidak Memiliki License Trucker");

	new to_player;
    if(sscanf(params, "u", to_player))
        return Usage(playerid, "/showtrucker [playerid/PartOfName]");

	if(!NearPlayer(playerid, to_player, 6.0))
		return SendClientMessage(playerid, 0xCECECEFF, "Pemainnya terlalu jauh");

	new sext[40], lstr[128], mstr[128];
	if(pData[to_player][pGender] == 1) { sext = "Laki-Laki"; } else { sext = "Perempuan"; }
	format(lstr, sizeof(lstr), "License Trucker Milik %s", pData[playerid][pName]);
	format(mstr,sizeof(mstr), "{FFFFFF}Nama: %s\nNegara: San Andreas\nTgl Lahir: %s\nJenis Kelamin: %s\nSisa Waktu: %s", pData[playerid][pName], pData[playerid][pAge], sext,  ReturnTimelapse(gettime(), pData[playerid][pPenebangsTime]));
	ShowPlayerDialog(to_player, DIALOG_UNUSED, DIALOG_STYLE_MSGBOX, lstr, mstr, "Tutup", "");
	SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s Memperlihatkan License Trucker Kepada %s", ReturnName(playerid), ReturnName(to_player));
	return 1;
}
CMD:showpenebang(playerid, params[])
{
    if(!pData[playerid][pPenebangs])
	 	return Error(playerid, "Anda Tidak Memiliki License Penebang");

	new to_player;
    if(sscanf(params, "u", to_player))
        return Usage(playerid, "/showpenebang [playerid/PartOfName]");

	if(!NearPlayer(playerid, to_player, 6.0))
		return SendClientMessage(playerid, 0xCECECEFF, "Pemainnya terlalu jauh");

	new sext[40], lstr[128], mstr[128];
	if(pData[to_player][pGender] == 1) { sext = "Laki-Laki"; } else { sext = "Perempuan"; }
	format(lstr, sizeof(lstr), "License Penebang Milik %s", pData[playerid][pName]);
	format(mstr,sizeof(mstr), "{FFFFFF}Nama: %s\nNegara: San Andreas\nTgl Lahir: %s\nJenis Kelamin: %s\nSisa Waktu: %s", pData[playerid][pName], pData[playerid][pAge], sext,  ReturnTimelapse(gettime(), pData[playerid][pPenebangsTime]));
	ShowPlayerDialog(to_player, DIALOG_UNUSED, DIALOG_STYLE_MSGBOX, lstr, mstr, "Tutup", "");
	SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s Memperlihatkan License Penebang Kepada %s", ReturnName(playerid), ReturnName(to_player));
	return 1;
}

CMD:showbpjs(playerid, params[])
{
    if(!pData[playerid][pBpjs])
	 	return Error(playerid, "Anda Tidak Memiliki Bpjs");

	new to_player;
    if(sscanf(params, "u", to_player))
        return Usage(playerid, "/showbpjs [playerid/PartOfName]");

	if(!NearPlayer(playerid, to_player, 6.0))
		return SendClientMessage(playerid, 0xCECECEFF, "Pemainnya terlalu jauh");

	new sext[40], lstr[128], mstr[128];
	if(pData[to_player][pGender] == 1) { sext = "Laki-Laki"; } else { sext = "Perempuan"; }
	format(lstr, sizeof(lstr), "Surat BPJS %s %s", pData[playerid][pName]);
	format(mstr,sizeof(mstr), "{FFFFFF}Nama: %s\nNegara: San Andreas\nTgl Lahir: %s\nJenis Kelamin: %s\nSisa Waktu: %s", pData[playerid][pName], pData[playerid][pAge], sext,  ReturnTimelapse(gettime(), pData[playerid][pBpjsTime]));
	ShowPlayerDialog(to_player, DIALOG_UNUSED, DIALOG_STYLE_MSGBOX, lstr, mstr, "Tutup", "");
	SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s Memperlihatkan BPJS Kepada %s", ReturnName(playerid), ReturnName(to_player));
	return 1;
}

CMD:newidcard(playerid, params[])
{
	if(!IsPlayerInRangeOfPoint(playerid, 3.0, 708.5005, 393.4143, 1023.5939)) return Error(playerid, "Anda harus berada di City Hall!");
	if(pData[playerid][pIDCard] != 0) return Error(playerid, "Anda sudah memiliki ID Card!");
	if(GetPlayerMoney(playerid) < 5000) return Error(playerid, "Anda butuh $50.00 untuk membuat ID Card");
	new sext[40], mstr[128];
	if(pData[playerid][pGender] == 1) { sext = "Laki-Laki"; } else { sext = "Perempuan"; }
	format(mstr, sizeof(mstr), "{FFFFFF}Nama: %s\nNegara: San Andreas\nTgl Lahir: %s\nJenis Kelamin: %s\nBerlaku hingga 14 hari!", pData[playerid][pName], pData[playerid][pAge], sext);
	ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_MSGBOX, "ID-Card", mstr, "Tutup", "");
	pData[playerid][pIDCard] = 1;
	pData[playerid][pIDCardTime] = gettime() + (15 * 86400);
	GivePlayerMoneyEx(playerid, -5000);
	Server_AddMoney(5000);
	return 1;
}

CMD:newbpjs(playerid, params[])
{
	if(!IsPlayerInRangeOfPoint(playerid, 3.0, 1370.6390,717.5485,-15.7573)) return Error(playerid, "Anda harus berada di Rumah Sakit!");
	if(pData[playerid][pBpjs] != 0) return Error(playerid, "Anda sudah memiliki BPJS!");
	if(GetPlayerMoney(playerid) < 5000) return Error(playerid, "Anda butuh $50.00 untuk membuat BPJS");
	if(GetPlayerMoney(playerid) > 100000) return Error(playerid, "BPJS Tidak untuk orang kaya");
	if(pData[playerid][pBankMoney] > 100000) return Error(playerid, "BPJS Tidak untuk orang kaya");
	new sext[40], mstr[128];
	if(pData[playerid][pGender] == 1) { sext = "Laki-Laki"; } else { sext = "Perempuan"; }
	format(mstr, sizeof(mstr), "{FFFFFF}Nama: %s\nNegara: San Andreas\nTgl Lahir: %s\nJenis Kelamin: %s\nBerlaku hingga 14 hari!", pData[playerid][pName], pData[playerid][pAge], sext);
	ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_MSGBOX, "BPJS", mstr, "Tutup", "");
	pData[playerid][pBpjs] = 1;
	pData[playerid][pBpjsTime] = gettime() + (15 * 86400);
	GivePlayerMoneyEx(playerid, -5000);
	Server_AddMoney(5000);
	return 1;
}

CMD:newage(playerid, params[])
{
	if(!IsPlayerInRangeOfPoint(playerid, 3.0, 708.5005, 393.4143, 1023.5939)) return Error(playerid, "Anda harus berada di City Hall!");
	//if(pData[playerid][pIDCard] != 0) return Error(playerid, "Anda sudah memiliki ID Card!");
	if(GetPlayerMoney(playerid) < 5000) return Error(playerid, "Anda butuh $50.00 untuk mengganti tgl lahir anda!");
	if(pData[playerid][IsLoggedIn] == false) return Error(playerid, "Anda harus login terlebih dahulu!");
	ShowPlayerDialog(playerid, DIALOG_CHANGEAGE, DIALOG_STYLE_INPUT, "Tanggal Lahir", "Masukan tanggal lahir (Tgl/Bulan/Tahun): 15/04/1998", "Change", "Cancel");
	return 1;
}

CMD:treatment(playerid, params[])
{
	if(!IsPlayerInRangeOfPoint(playerid, 3.0, 1168.4275,-1313.3032,2231.9749)) return Error(playerid, "Anda harus berada di Rumah Sakit!");
	if(GetPlayerMoney(playerid) < 30000) return Error(playerid, "Anda butuh $250.00 untuk membeli obat pereda sakit!");
	if(pData[playerid][IsLoggedIn] == false) return Error(playerid, "Anda harus login terlebih dahulu!");
	GivePlayerMoneyEx(playerid, -30000);
	pData[playerid][pSick] = 0;
	pData[playerid][pSickTime] = 0;
	SetPlayerDrunkLevel(playerid, 0);
	Info(playerid, "Kamu telah membeli obat pereda sakit, dan kamu sudah kembali sembuh");
	return 1;
}

CMD:newdrivelic(playerid, params[])
{
	if(!IsPlayerInRangeOfPoint(playerid, 3.0, -2038.9857, -125.9983, -50.9141)) return Error(playerid, "Anda harus berada di DMV!");
	if(pData[playerid][pDriveLic] == 1) return Error(playerid, "Anda Sudah Memiliki {FFFF00}Driving Licence");
	if(Global[SKM] == 1) return Error(playerid, "Masih Ada Proses Sekolah SIM Yang Berlangsung, Tunggu Sebentar");
	//PutPlayerInVehicle(playerid, DmvVeh[0], 0);
    //Global[SKM] = 1;
    //pData[playerid][pSekolahSim] = 1;
    //SetPlayerCheckpoint(playerid, dmvpoint1, 3.0);
    Info(playerid, "Anda sedang memulai {FFFF00}DMV {FFFFFF}Test");
    if(GetPlayerMoney(playerid) < 10000) return Error(playerid, "Anda butuh {00FF00}$50.00 {FFFFFF}untuk memulai {FFFF00}DMV {FFFFFF}Test");
    GivePlayerMoneyEx(playerid, -5000);
    ShowPlayerDialog(playerid,DIALOG_DMV1,DIALOG_STYLE_LIST,"Jika satu atau dua roda Anda keluar dari tepi jalan raya?","Perlambat dengan cepat dengan mengerem keras.\nPelan-pelan secara bertahap dan santai kembali ke jalan\nTingkatkan kecepatan Anda dan kembali ke jalan.","Oke","Cancel");
    return 1;
}

CMD:payticket(playerid, params[])
{
	if(!IsPlayerInRangeOfPoint(playerid, 3.0, 1560.4094, -1672.3917, 2113.0349)) return Error(playerid, "Anda harus berada di kantor SAPD!");

	new vehid;
	if(sscanf(params, "d", vehid))
		return Usage(playerid, "/payticket [vehid] | /v my(/mypv) - for find vehid");

	if(vehid == INVALID_VEHICLE_ID || !IsValidVehicle(vehid))
		return Error(playerid, "Invalid id");

	foreach(new i : PVehicles)
	{
		if(vehid == pvData[i][cVeh])
		{
			if(pvData[i][cOwner] == pData[playerid][pID])
			{
				new ticket = pvData[i][cTicket];

				if(ticket > GetPlayerMoney(playerid))
					return Error(playerid, "Not enough money! check your ticket in /v insu.");

				if(ticket > 0)
				{
					GivePlayerMoneyEx(playerid, -ticket);
					pvData[i][cTicket] = 0;
					Info(playerid, "Anda telah berhasil membayar ticket tilang kendaraan %s(id: %d) sebesar "RED_E"%s", GetVehicleName(vehid), vehid, FormatMoney(ticket));
					return 1;
				}
			}
			else return Error(playerid, "Kendaraan ini bukan milik anda! /v my(/mypv) - for find vehid");
		}
	}
	return 1;
}

CMD:buyplate(playerid, params[])
{
	if(!IsPlayerInRangeOfPoint(playerid, 3.0, 1560.4094, -1672.3917, 2113.0349)) return Error(playerid, "Anda harus berada di SAPD!");

	new vehid;
	if(sscanf(params, "d", vehid)) return Usage(playerid, "/buyplate [vehid] | /v my(/mypv) - for find vehid");

	if(vehid == INVALID_VEHICLE_ID || !IsValidVehicle(vehid))
		return Error(playerid, "Invalid id");

	foreach(new i : PVehicles)
	{
		if(vehid == pvData[i][cVeh])
		{
			if(pvData[i][cOwner] == pData[playerid][pID])
			{
				if(GetPlayerMoney(playerid) < 20000) return Error(playerid, "Anda butuh $200.00 untuk membeli Plate baru.");
				GivePlayerMoneyEx(playerid, -20000);
				new rand = RandomEx(1111, 9999);
				format(pvData[i][cPlate], 32, "A-%d", rand);
				SetVehicleNumberPlate(pvData[i][cVeh], pvData[i][cPlate]);
				pvData[i][cPlateTime] = gettime() + (15 * 86400);
				Info(playerid, "Model: %s || New plate: %s || Plate Time: %s || Plate Price: $100.00", GetVehicleModelName(pvData[i][cModel]), pvData[i][cPlate], ReturnTimelapse(gettime(), pvData[i][cPlateTime]));
			}
			else return Error(playerid, "ID kendaraan ini bukan punya mu! gunakan /v my(/mypv) untuk mencari ID.");
		}
	}
	return 1;
}

CMD:work(playerid)
{
	ShowPlayerDialog(playerid, DIALOG_WORK, DIALOG_STYLE_LIST, "Start Work", "MechDuty\nTaxiDuty", "Enter", "Back");
	return 1;
}

CMD:buyinsu(playerid, params[])
{
	if(!IsPlayerInRangeOfPoint(playerid, 3.0, -2045.3181, -131.1306, -50.9141)) return Error(playerid, "Anda harus berada di Insurance office(/gps)!");

	new vehid;
	if(sscanf(params, "d", vehid)) return Usage(playerid, "/buyinsu [vehid] | /v my(mypv) - for find vehid");
	if(vehid == INVALID_VEHICLE_ID) return Error(playerid, "Invalid id");

	foreach(new i : PVehicles)
	{
		if(vehid == pvData[i][cVeh])
		{
			if(pvData[i][cOwner] == pData[playerid][pID] && pvData[i][cClaim] == 0)
			{
				if(GetPlayerMoney(playerid) < 20000) return Error(playerid, "Anda butuh $200.00 untuk membeli Insurance.");
				GivePlayerMoneyEx(playerid, -20000);
				pvData[i][cInsu]++;
				Info(playerid, "Model: %s || Total Insurance: %d || Insurance Price: $200.00", GetVehicleModelName(pvData[i][cModel]), pvData[i][cInsu]);
			}
			else return Error(playerid, "ID kendaraan ini bukan punya mu! gunakan /v my(/mypv) untuk mencari ID.");
		}
	}
	return 1;
}

/*CMD:claimpv(playerid, params[])
{
	if(!IsPlayerInRangeOfPoint(playerid, 3.0, -2045.3196, -131.2115, -50.9141)) return Error(playerid, "Anda harus berada di Insurance office(/gps)!");
	new vstring[1024];
	for(new i; i < 6; i++)
	{
		if(pvData[i][cOwner] == pData[playerid][pID])
		{
			if(pvData[i][cClaim] == 1)
			{
				if(pvData[i][cClaimTime] != 0)
				{
					format(vstring, sizeof(vstring), "%s\n%d\t%s\t"YELLOW_E"%s"WHITE_E"\n", vstring, pvData[i][cID], GetVehicleModelName(pvData[i][cModel]), ReturnTimelapse(gettime(), pvData[i][cClaimTime]));
				}
				else
				{
					format(vstring, sizeof(vstring), "%s\n%d\t%s\t"GREEN_E"Ready"WHITE_E"\n", vstring, pvData[i][cID], GetVehicleModelName(pvData[i][cModel]));
				}
			}
			else format(vstring, sizeof(vstring), "%s\n%d\t%s\t"GREY_JG"(None)"WHITE_E"\n", vstring, pvData[i][cID], GetVehicleModelName(pvData[i][cModel]));
		}
	}
	ShowPlayerDialog(playerid, DIALOG_INSURANCE, DIALOG_STYLE_LIST, "Insurance", vstring, "Claim", "Close");
	return 1;
}
*/
/*CMD:claimpv(playerid, params[])
{
	if(!IsPlayerInRangeOfPoint(playerid, 3.0, -2045.3196, -131.2115, -50.9141))
		return Error(playerid, "Anda harus berada di Asuransi!");

	if(GetVehiclesInsurance(playerid) == 0)
		return Error(playerid, "Belum saat nya mengambil kendaraanmu (/v insu)");

	new vehid, _tmpstring[128], count = GetVehiclesInsurance(playerid), CMDSString[1024];
	CMDSString = "";
	
	Loop(itt, (count + 1), 1)
	{
	    vehid = ReturnPVehiclesInsuID(playerid, itt);
		if(itt == count)
		{
		    format(_tmpstring, sizeof(_tmpstring), "%d\t%s\tClaimed\n", itt, GetVehicleModelName(pvData[vehid][cModel]));
		}
		else format(_tmpstring, sizeof(_tmpstring), "%d\t%s\tClaimed\n", itt, GetVehicleModelName(pvData[vehid][cModel]));
		strcat(CMDSString, _tmpstring);
	}
	ShowPlayerDialog(playerid, VEHICLE_INSURANCE, DIALOG_STYLE_LIST, "Claim Vehicles Insurance", CMDSString, "Select", "Cancel");
	return 1;
}
*/
CMD:claimpv(playerid, params[])
{
	if(!IsPlayerInRangeOfPoint(playerid, 3.0, -2045.3196, -131.2115, -50.9141)) return Error(playerid, "Kamu harus berada di Kantor Insurance!");
	new found = 0;
	foreach(new i : PVehicles)
	{
		if(pvData[i][cClaim] == 1 && pvData[i][cClaimTime] == 0)
		{
			if(pvData[i][cOwner] == pData[playerid][pID])
			{
				pvData[i][cClaim] = 0;
				
				OnPlayerVehicleRespawn(i);
				//OnPlayerVehicleRespawn(listitem);
				pvData[i][cPosX] = 1082.3927;
				pvData[i][cPosY] = -1772.6974;
				pvData[i][cPosZ] = 13.3508;
				pvData[i][cPosA] = 90.0956;
				SetValidVehicleHealth(pvData[i][cVeh], 1500);
				SetVehiclePos(pvData[i][cVeh], 1082.3927, -1772.6974, 13.3508);
				SetVehicleZAngle(pvData[i][cVeh], 2.5077);
				SetVehicleFuel(pvData[i][cVeh], 1000);
				ValidRepairVehicle(pvData[i][cVeh]);
				found++;
				Info(playerid, "Anda telah mengclaim kendaraan %s anda.", GetVehicleModelName(pvData[i][cModel]));
			}
			//else return Error(playerid, "ID kendaraan ini bukan punya mu! gunakan /mypv untuk mencari ID.");
		}
	}
	if(found == 0)
	{
		Info(playerid, "Sekarang belum saatnya anda mengclaim kendaraan anda!");
	}
	else
	{
		Info(playerid, "Anda berhasil mengclaim %d kendaraan anda!", found);
	}
	return 1;
}
CMD:claimip(playerid, params[])
{
	if(!IsPlayerInRangeOfPoint(playerid, 3.0, 1560.4094, -1672.3917, 2113.0349)) return Error(playerid, "Anda harus berada di SAPD HQ(/gps)!");
	new found = 0;
	foreach(new i : PVehicles)
	{
		if(pvData[i][cImpound] == 1 && pvData[i][cImpoundTime] == 0)
		{
			if(pvData[i][cOwner] == pData[playerid][pID])
			{
				pvData[i][cImpound] = 0;

				OnPlayerVehicleRespawn(i);
				pvData[i][cPosX] = 1578.9211;
				pvData[i][cPosY] = -1608.3389;
				pvData[i][cPosZ] = 14.4479;
				pvData[i][cPosA] = 182.6852;
				SetValidVehicleHealth(pvData[i][cVeh], 1000);
				SetVehiclePos(pvData[i][cVeh], 1578.9211, -1608.3389, 14.4479);
				SetVehicleZAngle(pvData[i][cVeh], 268.6917);
				SetVehicleFuel(pvData[i][cVeh], 1000);
				found++;
				Info(playerid, "Anda telah mengclaim kendaraan %s anda.", GetVehicleModelName(pvData[i][cModel]));
			}
			//else return Error(playerid, "ID kendaraan ini bukan punya mu! gunakan /v my(/mypv) untuk mencari ID.");
		}
	}
	if(found == 0)
	{
		Info(playerid, "Sekarang belum saatnya anda mengclaim kendaraan anda!");
	}
	else
	{
		Info(playerid, "Anda berhasil mengclaim %d kendaraan anda, silahkan ambil di garasi SAPD HQ!", found);
	}
	return 1;
}
CMD:sellpv(playerid, params[])
{
	if(!IsPlayerInRangeOfPoint(playerid, 3.0, -2045.3181, -131.1306, -50.9141)) return Error(playerid, "Anda harus berada di Insurance office(/gps)!");

	new vehid;
	if(sscanf(params, "d", vehid)) return Usage(playerid, "/sellpv [vehid] | /v my(mypv) - for find vehid");
	if(vehid == INVALID_VEHICLE_ID) return Error(playerid, "Invalid id");

	foreach(new i : PVehicles)
	{
		if(vehid == pvData[i][cVeh])
		{
			if(pvData[i][cOwner] == pData[playerid][pID])
			{
				if(!IsValidVehicle(pvData[i][cVeh])) return Error(playerid, "Your vehicle is not spanwed!");
				if(pvData[i][cRent] != 0) return Error(playerid, "You can't sell rental vehicle!");
				new pay = pvData[i][cPrice] / 2;
				GivePlayerMoneyEx(playerid, pay);

				Info(playerid, "Anda menjual kendaraan model %s(%d) dengan seharga "LG_E"%s", GetVehicleName(vehid), GetVehicleModel(vehid), FormatMoney(pay));
				new query[128];
				mysql_format(g_SQL, query, sizeof(query), "DELETE FROM vehicle WHERE id = '%d'", pvData[i][cID]);
				mysql_tquery(g_SQL, query);
				if(IsValidVehicle(pvData[i][cVeh])) DestroyVehicle(pvData[i][cVeh]);
				Iter_SafeRemove(PVehicles, i, i);
			}
			else return Error(playerid, "ID kendaraan ini bukan punya anda! gunakan /v my(/mypv) untuk mencari ID.");
		}
	}
	return 1;
}

CMD:newrek(playerid, params[])
{
	if(!IsPlayerInRangeOfPoint(playerid, 3.0, -1340.1584, 2897.8811, 3014.2109)) return Error(playerid, "Anda harus berada di Bank!");
	if(GetPlayerMoney(playerid) < 5000) return Error(playerid, "Not enough money!");
	new query[128], rand = RandomEx(111111, 999999);
	new rek = rand+pData[playerid][pID];
	mysql_format(g_SQL, query, sizeof(query), "SELECT brek FROM players WHERE brek='%d'", rek);
	mysql_tquery(g_SQL, query, "BankRek", "id", playerid, rek);
	Info(playerid, "New rekening bank!");
	GivePlayerMoneyEx(playerid, -5000);
	Server_AddMoney(5000);
	return 1;
}

CMD:oldbank(playerid, params[])
{
	if(!IsPlayerInRangeOfPoint(playerid, 3.0, 2246.55, -1750.25, 1014.77)) return Error(playerid, "Anda harus berada di bank point!");
	new tstr[128];
	format(tstr, sizeof(tstr), ""ORANGE_E"No Rek: "LB_E"%d", pData[playerid][pBankRek]);
	ShowPlayerDialog(playerid, DIALOG_BANK, DIALOG_STYLE_LIST, tstr, "Deposit Money\nWithdraw Money\nCheck Balance\nTransfer Money\nSign Paycheck", "Select", "Cancel");
	return 1;
}
CMD:bank(playerid, params[])
{
    if(IsPlayerInRangeOfPoint(playerid, 3.0, -1340.1584, 2886.3032, 3014.2109))
    {
		if(pData[playerid][pToggleAtm] == 0)
		{
			pData[playerid][pToggleAtm] = 1;
			new name[32];
			format(name, sizeof(name), "%s", GetRPName(playerid));
			PlayerTextDrawSetString(playerid, BankTD18[playerid], name);
			new cash[3200];
			format(cash, sizeof(cash), "$%s",  FormatMoney(pData[playerid][pBankMoney]));
			PlayerTextDrawSetString(playerid,  BankTD14[playerid], cash);
			PlayerTextDrawShow(playerid, BankTD0[playerid]);
			PlayerTextDrawShow(playerid, BankTD1[playerid]);
			PlayerTextDrawShow(playerid, BankTD2[playerid]);
			PlayerTextDrawShow(playerid, BankTD3[playerid]);
			PlayerTextDrawShow(playerid, BankTD4[playerid]);
			PlayerTextDrawShow(playerid, BankTD5[playerid]);
			PlayerTextDrawShow(playerid, BankTD6[playerid]);
			PlayerTextDrawShow(playerid, BankTD7[playerid]);
			PlayerTextDrawShow(playerid, BankTD8[playerid]);
			PlayerTextDrawShow(playerid, BankTD9[playerid]);
			PlayerTextDrawShow(playerid, BankTD10[playerid]);
			PlayerTextDrawShow(playerid, BankTD11[playerid]);
	        PlayerTextDrawShow(playerid, BankTD12[playerid]);
	        PlayerTextDrawShow(playerid, BankTD13[playerid]);
	        PlayerTextDrawShow(playerid, BankTD14[playerid]);
	        PlayerTextDrawShow(playerid, BankTD15[playerid]);
	        PlayerTextDrawShow(playerid, BankTD16[playerid]);
	        PlayerTextDrawShow(playerid, BankTD17[playerid]);
	        PlayerTextDrawShow(playerid, BankTD18[playerid]);
	        PlayerTextDrawShow(playerid, BankTD19[playerid]);
	        PlayerTextDrawShow(playerid, BankTD20[playerid]);
	        PlayerTextDrawShow(playerid, BankTD21[playerid]);
	        PlayerTextDrawShow(playerid, BankTD22[playerid]);
	        PlayerTextDrawShow(playerid, BankTD23[playerid]);
			SelectTextDraw(playerid, 0xFFA500FF);
			return 1;
		}
		else
		{
			pData[playerid][pToggleAtm] = 0;
			PlayerTextDrawHide(playerid, BankTD0[playerid]);
			PlayerTextDrawHide(playerid, BankTD1[playerid]);
			PlayerTextDrawHide(playerid, BankTD2[playerid]);
			PlayerTextDrawHide(playerid, BankTD3[playerid]);
			PlayerTextDrawHide(playerid, BankTD4[playerid]);
			PlayerTextDrawHide(playerid, BankTD5[playerid]);
			PlayerTextDrawHide(playerid, BankTD6[playerid]);
			PlayerTextDrawHide(playerid, BankTD7[playerid]);
			PlayerTextDrawHide(playerid, BankTD8[playerid]);
			PlayerTextDrawHide(playerid, BankTD9[playerid]);
			PlayerTextDrawHide(playerid, BankTD10[playerid]);
			PlayerTextDrawHide(playerid, BankTD11[playerid]);
			PlayerTextDrawHide(playerid, BankTD12[playerid]);
			PlayerTextDrawHide(playerid, BankTD13[playerid]);
			PlayerTextDrawHide(playerid, BankTD14[playerid]);
			PlayerTextDrawHide(playerid, BankTD15[playerid]);
			PlayerTextDrawHide(playerid, BankTD16[playerid]);
			PlayerTextDrawHide(playerid, BankTD17[playerid]);
			PlayerTextDrawHide(playerid, BankTD18[playerid]);
			PlayerTextDrawHide(playerid, BankTD19[playerid]);
			PlayerTextDrawHide(playerid, BankTD20[playerid]);
			PlayerTextDrawHide(playerid, BankTD21[playerid]);
			PlayerTextDrawHide(playerid, BankTD22[playerid]);
			PlayerTextDrawHide(playerid, BankTD23[playerid]);
			CancelSelectTextDraw(playerid);
		}
	}
	return 1;
}
CMD:pay(playerid, params[])
{
    new id, cash[32], String[256];
    new dollars, cents, totalcash[25];
    if(sscanf(params, "us[32]", id, cash)) return SendClientMessage(playerid, COLOR_RIKO, "USAGE: /pay [playerid] [amount]");

	if(!IsPlayerConnected(id) || !NearPlayer(playerid, id, 4.0))
        return Error(playerid, "Player disconnect atau tidak berada didekat anda.");

    if(strfind(cash, ".", true) != -1)
    {
        sscanf(cash, "p<.>dd", dollars, cents);
        format(totalcash, sizeof(totalcash), "%d%02d", dollars, cents);
        if(GetPlayerMoney(playerid) >= strval(totalcash))
        {
		    if(strval(totalcash) < 0) return SendClientMessageEx(playerid, COLOR_PINK, "ERROR: {FFFFFF}Tidak bisa dibawah $0.00");
	            GivePlayerMoneyEx(playerid, -strval(totalcash));
			    GivePlayerMoneyEx(id, strval(totalcash));
  		    format(String, sizeof(String), "PAYINFO: {ffffff}You've given {ffff00}%s {00ff00}$%s", ReturnName(playerid), FormatMoney(strval(totalcash)));
          	SendClientMessage(playerid, COLOR_LOGS, String);
            format(String, sizeof(String), "PAYINFO: {ffffff}You've received {00ff00}$%s {ffffff}from {ffff00}%s ", FormatMoney(strval(totalcash)), ReturnName(playerid));
            SendClientMessage(id, COLOR_LOGS, String);
           	ApplyAnimation(playerid, "DEALER", "DEALER_DEAL", 4.0, 0, 0, 0, 0, 0);
			ApplyAnimation(id, "DEALER", "DEALER_DEAL", 4.0, 0, 0, 0, 0, 0);
		    new ip[32], ipex[32], str[300];
		    GetPlayerIp(playerid, ip, sizeof(ip));
		    GetPlayerIp(id, ipex, sizeof(ipex));
		    format(str, sizeof(str), "> __%s Memberikan %s sebesar:__ %s", pData[playerid][pName], pData[id][pName], FormatMoney(strval(totalcash)));
		    DCC_SendChannelMessage(g_discord_paylogs, str);
		    new query[512];
			mysql_format(g_SQL, query, sizeof(query), "INSERT INTO logpay (player,playerid,toplayer,toplayerid,ammount,time) VALUES('%s','%d','%s','%d','%d',UNIX_TIMESTAMP())", pData[playerid][pName], pData[playerid][pID], pData[id][pName], pData[id][pID], totalcash);
			mysql_tquery(g_SQL, query);
			//playerid
			PlayerTextDrawSetString(playerid, ITEMSNAME[playerid], "Money");
			PlayerTextDrawSetString(playerid, Received[playerid], "Gived");
			PlayerTextDrawSetPreviewModel(playerid, MODELITEM[playerid], 1212);
			PlayerTextDrawShow(playerid, ITEMSBOX[0][playerid]);
			PlayerTextDrawShow(playerid, ITEMSBOX[1][playerid]);
			PlayerTextDrawShow(playerid, Received[playerid]);
			PlayerTextDrawShow(playerid, ITEMSNAME[playerid]);
			PlayerTextDrawShow(playerid, MODELITEM[playerid]);
			SetTimerEx("ItemsBoxtimer", 5500, false, "i", playerid);
			//otherid
			PlayerTextDrawSetString(id, ITEMSNAME[id], "Money");
			PlayerTextDrawSetString(id, Received[id], "Received");
			PlayerTextDrawSetPreviewModel(id, MODELITEM[id], 1212);	
			PlayerTextDrawShow(id, ITEMSBOX[0][id]);
			PlayerTextDrawShow(id, ITEMSBOX[1][id]);
			PlayerTextDrawShow(id, Received[id]);
			PlayerTextDrawShow(id, ITEMSNAME[id]);
			PlayerTextDrawShow(id, MODELITEM[id]);
			SetTimerEx("ItemsBoxtimer", 5500, false, "i", id);			
        }
        else Error(playerid, "Anda tidak memiliki uang sebesar itu.");
    }
    else
    {
        sscanf(cash, "d", dollars);
        format(totalcash, sizeof(totalcash), "%d00", dollars);
        if(GetPlayerMoney(playerid) >= strval(totalcash))
        {
		    if(strval(totalcash) < 0) return SendClientMessageEx(playerid, COLOR_GREY, "Tidak bisa dibawah $0.00");
	            GivePlayerMoneyEx(playerid, -strval(totalcash));
			    GivePlayerMoneyEx(id, strval(totalcash));
  		    format(String, sizeof(String), "PAYINFO: {ffffff}You've given {ffff00}%s {00ff00}$%s", ReturnName(playerid), FormatMoney(strval(totalcash)));
          	SendClientMessage(playerid, COLOR_LOGS, String);
            format(String, sizeof(String), "PAYINFO: {ffffff}You've received {00ff00}$%s {ffffff}from {ffff00}%s ", FormatMoney(strval(totalcash)), ReturnName(playerid));
            SendClientMessage(id, COLOR_LOGS, String);
           	ApplyAnimation(playerid, "DEALER", "DEALER_DEAL", 4.0, 0, 0, 0, 0, 0);
			ApplyAnimation(id, "DEALER", "DEALER_DEAL", 4.0, 0, 0, 0, 0, 0);
		    new ip[32], ipex[32], str[300];
		    GetPlayerIp(playerid, ip, sizeof(ip));
		    GetPlayerIp(id, ipex, sizeof(ipex));
		    format(str, sizeof(str), "> __%s Memberikan %s sebesar:__ %s", pData[playerid][pName], pData[id][pName], FormatMoney(strval(totalcash)));
		    DCC_SendChannelMessage(g_discord_paylogs, str);
		    new query[512];
			mysql_format(g_SQL, query, sizeof(query), "INSERT INTO logpay (player,playerid,toplayer,toplayerid,ammount,time) VALUES('%s','%d','%s','%d','%d',UNIX_TIMESTAMP())", pData[playerid][pName], pData[playerid][pID], pData[id][pName], pData[id][pID], totalcash);
			mysql_tquery(g_SQL, query);
			//playerid
			PlayerTextDrawSetString(playerid, ITEMSNAME[playerid], "Money");
			PlayerTextDrawSetString(playerid, Received[playerid], "Gived");
			PlayerTextDrawSetPreviewModel(playerid, MODELITEM[playerid], 1212);
			PlayerTextDrawShow(playerid, ITEMSBOX[0][playerid]);
			PlayerTextDrawShow(playerid, ITEMSBOX[1][playerid]);
			PlayerTextDrawShow(playerid, Received[playerid]);
			PlayerTextDrawShow(playerid, ITEMSNAME[playerid]);
			PlayerTextDrawShow(playerid, MODELITEM[playerid]);
			SetTimerEx("ItemsBoxtimer", 5500, false, "i", playerid);
			//otherid
			PlayerTextDrawSetString(id, ITEMSNAME[id], "Money");
			PlayerTextDrawSetString(id, Received[id], "Received");
			PlayerTextDrawSetPreviewModel(id, MODELITEM[id], 1212);	
			PlayerTextDrawShow(id, ITEMSBOX[0][id]);
			PlayerTextDrawShow(id, ITEMSBOX[1][id]);
			PlayerTextDrawShow(id, Received[id]);
			PlayerTextDrawShow(id, ITEMSNAME[id]);
			PlayerTextDrawShow(id, MODELITEM[id]);
			SetTimerEx("ItemsBoxtimer", 5500, false, "i", id);
        }
        else Error(playerid, "Anda tidak memiliki uang sebesar itu.");
    }
    return 1;
}
/*
CMD:showlic(playerid, params[])
{
    static
        item[24],
		to_player;

	//new otherid, item, mstr[128];
	if(sscanf(params, "ud", to_player, item))
	{
	    Usage(playerid, "/showlic <ID/Name> <item>");
		Info(playerid, "[idcard], [penebang], [skck], [sim]");
	    return true;
	}

	if(!IsPlayerConnected(to_player) || !NearPlayer(playerid, to_player, 4.0))
        	return Error(playerid, "The specified player is disconnected or not near you.");

    if(!strcmp(item,"idcard"))
	{
        if(pData[playerid][pIDCard] == 0) return Error(playerid, "Anda tidak memiliki id card!");
		new sext[40];
		if(pData[playerid][pGender] == 1) { sext = "Male"; } else { sext = "Female"; }
		SendClientMessage(to_player, COLOR_GREEN, "[ID-Card] "GREY3_E"Name: %s | Gender: %s | Brithday: %s | Expire: %s.", pData[playerid][pName], sext, pData[playerid][pAge], ReturnTimelapse(gettime(), pData[playerid][pIDCardTime]));
    }
    else if(!strcmp(item,"penebang",true))
	{
        if(pData[playerid][pPenebangs] == 0) return Error(playerid, "Anda tidak memiliki lic penebang!");
		new fmt_text, sext[1000];
		if(pData[playerid][pGender] == 1) { sext = "Male"; } else { sext = "Female"; }
		SendClientMessage(to_player, COLOR_GREEN, "[LIC PENEBANG] "GREY3_E"Name: %s | Gender: %s | Brithday: %s | Expire: %s.", pData[playerid][pName], sext, pData[playerid][pAge], ReturnTimelapse(gettime(), pData[playerid][pPenebangsTime]));
    }
    else if(!strcmp(item,"skck"))
	{
        if(pData[playerid][pSkck] == 0) return Error(playerid, "Anda tidak memiliki SKCK!");
		new fmt_text, sext[1000];
		if(pData[playerid][pGender] == 1) { sext = "Male"; } else { sext = "Female"; }
		format(fmt_text, sizeof fmt_text, "[SKCK] "GREY3_E"Name: %s | Gender: %s | Brithday: %s | Expire: %s.", pData[playerid][pName], sext, pData[playerid][pAge], ReturnTimelapse(gettime(), pData[playerid][pSkckTime]));
		SendClientMessage(to_player, COLOR_GREEN, fmt_text);
		//SendClientMessage(to_player, COLOR_GREEN, "[SKCK] "GREY3_E"Name: %s | Gender: %s | Brithday: %s | Expire: %s.", pData[playerid][pName], sext, pData[playerid][pAge], ReturnTimelapse(gettime(), pData[playerid][pSkckTime]));
    }

    else if(!strcmp(item,"sim"))
	{
       	if(pData[playerid][pDriveLic] == 0) return Error(playerid, "Anda tidak memiliki SIM!");
		new sext[40];
		if(pData[playerid][pGender] == 1) { sext = "Male"; } else { sext = "Female"; }
		SendClientMessage(to_player, COLOR_GREEN, "[SIM] "GREY3_E"Name: %s | Gender: %s | Brithday: %s | Expire: %s.", pData[playerid][pName], sext, pData[playerid][pAge], ReturnTimelapse(gettime(), pData[playerid][pDriveLicTime]));
    }
	return 1;
}
*/

CMD:givebpjs(playerid, params[])
{

    if(pData[playerid][pFaction] != 3)
        return Error(playerid, "You must be part of a medical faction.");
	new to_player;
    if(sscanf(params, "u", to_player))
        return Usage(playerid, "/givebpjs [playerid/PartOfName]");

    if(!NearPlayer(playerid, to_player, 6.0))
		return SendClientMessage(playerid, 0xCECECEFF, "Pemainnya terlalu jauh");

	if(pData[to_player][pBpjs] != 0) return Error(playerid, "Orang ini sudah mempunyai BPJS");
	new sext[40], lstr[128], mstr[128];
	if(pData[to_player][pGender] == 1) { sext = "Laki-Laki"; } else { sext = "Perempuan"; }
	format(lstr, sizeof(lstr), "Surat BPJS %s", pData[to_player][pName]);
	format(mstr,sizeof(mstr), "{FFFFFF}Nama: %s\nNegara: San Andreas\nTgl Lahir: %s\nJenis Kelamin: %s\nBerlaku hingga 14 hari!", pData[to_player][pName], pData[to_player][pAge], sext);
	ShowPlayerDialog(to_player, DIALOG_UNUSED, DIALOG_STYLE_MSGBOX, lstr, mstr, "Tutup", "");
	Info(to_player, "Anda mendapatkan surat	BPJS dari departemen rumah sakit");
	SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s Memberikan Surat BPJS Kepada %s", ReturnName(playerid), ReturnName(to_player));
	pData[to_player][pBpjs] = 1;
	pData[to_player][pBpjsTime] = gettime() +  (15 * 86400);
	Info(playerid, "Anda Telah Memberikan Surat SKCK kepada %s", ReturnName(to_player));

    return 1;
}

CMD:giveskck(playerid, params[])
{
	if(pData[playerid][pFaction] != 1)
        return Error(playerid, "You not police officer.");
    if(pData[playerid][pFactionRank] < 3)
		return Error(playerid, "You must be 3 rank level!");

	new to_player;
    if(sscanf(params, "u", to_player))
        return Usage(playerid, "/giveskck [playerid/PartOfName]");
	if(!NearPlayer(playerid, to_player, 6.0))
		return SendClientMessage(playerid, 0xCECECEFF, "Pemainnya terlalu jauh");

	if(pData[to_player][pSkck] != 0) return Error(playerid, "Orang ini sudah mempunyai SKCK");
	new sext[40], lstr[128], mstr[128];
	if(pData[to_player][pGender] == 1) { sext = "Laki-Laki"; } else { sext = "Perempuan"; }
	format(lstr, sizeof(lstr), "Surat SKCK", pData[to_player][pName]);
	format(mstr,sizeof(mstr), "{FFFFFF}Nama: %s\nNegara: San Andreas\nTgl Lahir: %s\nJenis Kelamin: %s\nBerlaku hingga 14 hari!", pData[to_player][pName], pData[to_player][pAge], sext);
	ShowPlayerDialog(to_player, DIALOG_UNUSED, DIALOG_STYLE_MSGBOX, lstr, mstr, "Tutup", "");
	Info(to_player, "Anda mendapatkan surat SKCK dari departemen kepolisian");
	SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s Memberikan Surat SKCK Kepada %s", ReturnName(playerid), ReturnName(to_player));
	pData[to_player][pSkck] = 1;
	pData[to_player][pSkckTime] = gettime() +  (15 * 86400);
	Info(playerid, "Anda Telah Memberikan Surat SKCK kepada %s", ReturnName(to_player));
	//GivePlayerMoneyEx(playerid, -50);
	//Server_AddMoney(25);
	return 1;
}
CMD:givetrucker(playerid, params[])
{
	if(pData[playerid][pFaction] != 1)
        return Error(playerid, "You not police officer.");
    if(pData[playerid][pFactionRank] < 3)
		return Error(playerid, "You must be 3 rank level!");

	new to_player;
    if(sscanf(params, "u", to_player))
        return Usage(playerid, "/givetrucker [playerid/PartOfName]");

	if(!NearPlayer(playerid, to_player, 6.0))
		return SendClientMessage(playerid, 0xCECECEFF, "Pemainnya terlalu jauh");

	if(pData[to_player][pTruckerLic] != 0) return Error(playerid, "Orang ini sudah mempunyai Lic Trucker");
	new sext[40], lstr[128], mstr[128];
	if(pData[to_player][pGender] == 1) { sext = "Laki-Laki"; } else { sext = "Perempuan"; }
	format(lstr, sizeof(lstr), "Surat Trucker %s", pData[to_player][pName]);
	format(mstr,sizeof(mstr), "{FFFFFF}Nama: %s\nNegara: San Andreas\nTgl Lahir: %s\nJenis Kelamin: %s\nBerlaku hingga 14 hari!", pData[to_player][pName], pData[to_player][pAge], sext);
	ShowPlayerDialog(to_player, DIALOG_UNUSED, DIALOG_STYLE_MSGBOX, lstr, mstr, "Tutup", "");
	Info(to_player, "Anda Mendapatkan License Trucker dari Departemen kepolisian");
	pData[to_player][pTruckerLic] = 1;
	pData[to_player][pTruckerLicTime] = gettime() +  (15 * 86400);
	Info(playerid, "Anda Telah Memberikan License Trucker Kepada %s", ReturnName(to_player));
	SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s Memberikan License Trucker Kepada %s", ReturnName(playerid), ReturnName(to_player));
	//GivePlayerMoneyEx(playerid, -50);
	//Server_AddMoney(25);
	return 1;
}
CMD:givepenebang(playerid, params[])
{
	if(pData[playerid][pFaction] != 1)
        return Error(playerid, "You not police officer.");
    if(pData[playerid][pFactionRank] < 3)
		return Error(playerid, "You must be 3 rank level!");

	new to_player;
    if(sscanf(params, "u", to_player))
        return Usage(playerid, "/givepenebang [playerid/PartOfName]");

	if(!NearPlayer(playerid, to_player, 6.0))
		return SendClientMessage(playerid, 0xCECECEFF, "Pemainnya terlalu jauh");

	if(pData[to_player][pPenebangs] != 0) return Error(playerid, "Orang ini sudah mempunyai Lic Penebang");
	new sext[40], lstr[128], mstr[128];
	if(pData[to_player][pGender] == 1) { sext = "Laki-Laki"; } else { sext = "Perempuan"; }
	format(lstr, sizeof(lstr), "Surat Penebang %s", pData[to_player][pName]);
	format(mstr,sizeof(mstr), "{FFFFFF}Nama: %s\nNegara: San Andreas\nTgl Lahir: %s\nJenis Kelamin: %s\nBerlaku hingga 14 hari!", pData[to_player][pName], pData[to_player][pAge], sext);
	ShowPlayerDialog(to_player, DIALOG_UNUSED, DIALOG_STYLE_MSGBOX, lstr, mstr, "Tutup", "");
	Info(to_player, "Anda Mendapatkan License Penebang dari Departemen kepolisian");
	pData[to_player][pPenebangs] = 1;
	pData[to_player][pPenebangsTime] = gettime() +  (15 * 86400);
	Info(playerid, "Anda Telah Memberikan License Penebang Kepada %s", ReturnName(to_player));
	SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s Memberikan License Penebang Kepada %s", ReturnName(playerid), ReturnName(to_player));
	//GivePlayerMoneyEx(playerid, -50);
	//Server_AddMoney(25);
	return 1;
}
CMD:acs(playerid, params[])
{
	new queen[266];
	
	new otherid;
	if(sscanf(params, "u", otherid))
        return Usage(playerid, "/acs [playerid/PartOfName]");
        
	format(queen, sizeof(queen), "cs/%s.txt", pData[otherid][pName]);
	if(dini_Exists(queen))
	{
	    Info(playerid, "Character Story %s {00FF11}Active", pData[otherid][pName]);
	}
	else
	{
	    Info(playerid, "Character Story %s {FF0000}Not Active", pData[otherid][pName]);
	}
	return 1;
}
CMD:cs(playerid, params[])
{
	new queen[266];
	format(queen, sizeof(queen), "cs/%s.txt", pData[playerid][pName]);
	if(dini_Exists(queen))
	{
	    Info(playerid, "Your Character Story {00FF11}Active");
	}
	else
	{
	    Info(playerid, "Your Character Story {FF0000}Not Active");
	}
	return 1;
}
CMD:stats(playerid, params[])
{
	if(pData[playerid][IsLoggedIn] == false)
	{
	    Error(playerid, "You must be logged in to check statistics!");
	    return 1;
	}

	DisplayStats(playerid, playerid);
	return 1;
}

CMD:settings(playerid)
{
	if(pData[playerid][IsLoggedIn] == false)
	{
	    Error(playerid, "You must be logged in to check statistics!");
	    return 1;
	}

	new str[1024], hbemode[64], tdmode[64], togpm[64], toglog[64], togads[64], togwt[64], togdamage[64];
	if(pData[playerid][pHBEMode] == 1)
	{
		hbemode = ""LG_E"Simple";
	}
	else if(pData[playerid][pHBEMode] == 2)
	{
		hbemode = ""LG_E"Modern";
	}
	else if(pData[playerid][pHBEMode] == 3)
	{
		hbemode = ""LG_E"Modern 2";
	}
	else
	{
		hbemode = ""RED_E"Disable";
	}

	if(pData[playerid][pTDMode] == 1)
	{
		tdmode = ""LG_E"Simple";
	}
	else if(pData[playerid][pTDMode] == 2)
	{
		tdmode = ""LG_E"Modern";
	}
	else
	{
		tdmode = ""RED_E"Disable";
	}

	if(pData[playerid][pTogPM] == 0)
	{
		togpm = ""RED_E"Disable";
	}
	else
	{
		togpm = ""LG_E"Enable";
	}

	if(pData[playerid][pTogLog] == 0)
	{
		toglog = ""RED_E"Disable";
	}
	else
	{
		toglog = ""LG_E"Enable";
	}

	if(pData[playerid][pTogAds] == 0)
	{
		togads = ""LG_E"Enable";
	}
	else
	{
		togads = ""RED_E"Disable";
	}

	if(pData[playerid][pTogWT] == 0)
	{
		togwt = ""LG_E"Enable";
	}
	else
	{
		togwt = ""RED_E"Disable";
	}

	if(pData[playerid][pTogDamage] == 0)
	{
		togdamage = ""LG_E"Enable";
	}
	else
	{
		togdamage = ""RED_E"Disable";
	}

	format(str, sizeof(str), ""WHITEP_E"Email:\t"GREY3_E"%s\n"WHITEP_E"Change Password\n"WHITEP_E"HUD HBE Mode:\t%s\n"WHITEP_E"Textdraw Mode:\t%s\n"WHITEP_E"Toggle PM:\t%s\n"WHITEP_E"Toggle Log Server:\t%s\n"WHITEP_E"Toggle Ads:\t%s\n"WHITEP_E"Toggle WT:\t%s\n"WHITEP_E"Toggle Damage:\t%s",
	pData[playerid][pEmail],
	hbemode,
	tdmode,
	togpm,
	toglog,
	togads,
	togwt,
	togdamage
	);

	ShowPlayerDialog(playerid, DIALOG_SETTINGS, DIALOG_STYLE_LIST, "Settings", str, "Set", "Close");
	return 1;
}
CMD:shakehand(playerid, params[])
{
	new String[10000], giveplayerid, style;
	if(sscanf(params, "ud", giveplayerid, style)) return SendClientMessageEx(playerid, COLOR_PINK, "USE: /shakehand [playerid] [style (1-8)]");

	if(IsPlayerConnected(giveplayerid))
	{
		if(giveplayerid == playerid)
		{
			SendClientMessageEx(playerid, COLOR_GREY, "You can't shake your own hand.");
			return 1;
		}
		if(style >= 1 && style < 9)
		{
			new Float: ppFloats[3];

			GetPlayerPos(giveplayerid, ppFloats[0], ppFloats[1], ppFloats[2]);

			if(!IsPlayerInRangeOfPoint(playerid, 5, ppFloats[0], ppFloats[1], ppFloats[2]))
			{
				SendClientMessageEx(playerid, COLOR_GREY, "You're too far away. You can't shake hands right now.");
				return 1;
			}

			SetPVarInt(playerid, "shrequest", giveplayerid);
			SetPVarInt(playerid, "shstyle", style);

			format(String, sizeof(String), "You have requested to shake %s's hand, please wait for them to respond.", pData[giveplayerid][pName]);
			SendClientMessageEx(playerid, COLOR_PINK, String);

			format(String, sizeof(String), "%s has requested to shake your hand, please use {FFFF00}'/accept handshake'{FFFFFF} to approve the hand shake.", pData[playerid][pName]);
			SendClientMessageEx(giveplayerid, COLOR_PINK, String);
		}
		else
		{
			Usage(playerid,"/shakehand [1-9]");
		}
	}
	else
	{
		 Error(playerid, "Invalid player specified.");
	}
	return 1;
}
CMD:items(playerid, params[])
{
	if(pData[playerid][IsLoggedIn] == false)
	{
	    Error(playerid, "You must be logged in to check items!");
	    return true;
	}
	DisplayItems(playerid, playerid);
	return 1;
}
CMD:health(playerid, params[])
{
	if(IsAtEvent[playerid] == 1)
		return Error(playerid, "Anda sedang mengikuti event & tidak bisa melakukan ini");

	new body[80];
	if(pData[playerid][pSick] == 0)
    {
    	body = "Normal";
    }
    else if(pData[playerid][pSick] == 1)
   	{
   		body = "Maag";
   	}
   	else if(pData[playerid][pSick] == 2)
   	{
   		body = "Diare";
   	}
   	else if(pData[playerid][pSick] == 3)
   	{
   		body = "Dizzy";
   	}
	new coordsString[10000], S3MP4K[10000], idiot[1401];
    format(idiot, sizeof(idiot), "{00ffff}Character Health{FFFFFF}");
    //SendClientMessageEx(playerid,COLOR_PINK,coordsString);
    format(coordsString, sizeof(coordsString), "{FF00EA}Body Part Status\n");
    strcat(S3MP4K, coordsString);
    //SendClientMessageEx(playerid, 0xFFFF00FF,coordsString);
    format(coordsString, sizeof(coordsString), "{FFFFFF}Part: {00FFEE}Body\n");
    strcat(S3MP4K, coordsString);
    //SendClientMessageEx(playerid, 0xFFFFFFAA,coordsString);
    format(coordsString, sizeof(coordsString), "{FFFFFF}Condition: {6EF83C}%s\n", body);
    strcat(S3MP4K, coordsString);
    //SendClientMessageEx(playerid, 0xFFFFFFAA,coordsString);
    format(coordsString, sizeof(coordsString), "{FFFFFF}Part: {00FFEE}Groin\n");
    strcat(S3MP4K, coordsString);
    //SendClientMessageEx(playerid,COLOR_PINK,coordsString);
    format(coordsString, sizeof(coordsString), "{FFFFFF}Condition: %s\n", pStockBodyCondition0(playerid));
    strcat(S3MP4K, coordsString);
    //SendClientMessageEx(playerid, 0xFFFFFFAA,coordsString);
    format(coordsString, sizeof(coordsString), "{FFFFFF}Part: {00FFEE}Torso\n");
    strcat(S3MP4K, coordsString);
    //SendClientMessageEx(playerid, 0xFFFFFFAA,coordsString);
    format(coordsString, sizeof(coordsString), "{FFFFFF}Condition: %s\n", pStockBodyCondition1(playerid));
    strcat(S3MP4K, coordsString);
    format(coordsString, sizeof(coordsString), "{FFFFFF}Part: {00FFEE}Right Arm\n");
    strcat(S3MP4K, coordsString);
    format(coordsString, sizeof(coordsString), "{FFFFFF}Condition: %s\n", pStockBodyCondition2(playerid));
    strcat(S3MP4K, coordsString);
    format(coordsString, sizeof(coordsString), "{FFFFFF}Part: {00FFEE}Left Arm\n");
    strcat(S3MP4K, coordsString);
    format(coordsString, sizeof(coordsString), "{FFFFFF}Condition: %s\n", pStockBodyCondition3(playerid));
    strcat(S3MP4K, coordsString);
    format(coordsString, sizeof(coordsString), "{FFFFFF}Part: {00FFEE}Right Leg\n");
    strcat(S3MP4K, coordsString);
    format(coordsString, sizeof(coordsString), "{FFFFFF}Condition: %s\n", pStockBodyCondition4(playerid));
    strcat(S3MP4K, coordsString);
    format(coordsString, sizeof(coordsString), "{FFFFFF}Part: {00FFEE}Left Leg\n");
    strcat(S3MP4K, coordsString);
    format(coordsString, sizeof(coordsString), "{FFFFFF}Condition: %s\n", pStockBodyCondition5(playerid));
    strcat(S3MP4K, coordsString);
    //SendClientMessageEx(playerid, 0xFFFFFFAA,coordsString);
    ShowPlayerDialog(playerid, DIALOG_HEALTH, DIALOG_STYLE_MSGBOX, "Body Status",S3MP4K,"Close","");
    return 1;
}
CMD:getjob(playerid, params[])
{
	if(pData[playerid][pIDCard] <= 0)
		return Error(playerid, "Anda tidak memiliki ID-Card.");

	if(pData[playerid][pVip] > 0)
	{
		if(pData[playerid][pJob] == 0 || pData[playerid][pJob2] == 0)
		{
			if(pData[playerid][pJob] == 0)
			{
				if(pData[playerid][pJob] == 0 && GetPlayerState(playerid) == 1 && IsPlayerInRangeOfPoint(playerid, 3.0, -2159.04, 640.36, 1052.38))
				{
					pData[playerid][pGetJob] = 1;
					Info(playerid, "Anda telah berhasil mendaftarkan job Taxi. /accept job untuk konfirmasi.");
				}
				else if(pData[playerid][pJob] == 0 && GetPlayerState(playerid) == 1 && IsPlayerInRangeOfPoint(playerid, 3.0, 2171.0276,-2238.5984,13.3178))
				{
					pData[playerid][pGetJob] = 2;
					Info(playerid, "Anda telah berhasil mendaftarkan job mechanic. /accept job untuk konfirmasi.");
				}
				else if(pData[playerid][pJob] == 0 && GetPlayerState(playerid) == 1 && IsPlayerInRangeOfPoint(playerid, 3.0, -265.87, -2213.63, 29.04))
				{
					pData[playerid][pGetJob] = 3;
					Info(playerid, "Anda telah berhasil mendaftarkan job lumber jack. /accept job untuk konfirmasi.");
				}
				else if(pData[playerid][pJob] == 0 && GetPlayerState(playerid) == 1 && IsPlayerInRangeOfPoint(playerid, 3.0, -77.38, -1136.52, 1.07))
				{
					pData[playerid][pGetJob] = 4;
					Info(playerid, "Anda telah berhasil mendaftarkan job trucker. /accept job untuk konfirmasi.");
				}
				else if(pData[playerid][pJob] == 0 && GetPlayerState(playerid) == 1 && IsPlayerInRangeOfPoint(playerid, 3.0, 319.94, 874.77, 20.39))
				{
					pData[playerid][pGetJob] = 5;
					Info(playerid, "Anda telah berhasil mendaftarkan job miner. /accept job untuk konfirmasi.");
				}
				else if(pData[playerid][pJob] == 0 && GetPlayerState(playerid) == 1 && IsPlayerInRangeOfPoint(playerid, 3.0, -283.02, -2174.36, 28.66))
				{
					pData[playerid][pGetJob] = 6;
					Info(playerid, "Anda telah berhasil mendaftarkan job production. /accept job untuk konfirmasi.");
				}
				else if(pData[playerid][pJob] == 0 && GetPlayerState(playerid) == 1 && IsPlayerInRangeOfPoint(playerid, 3.0, -383.67, -1438.90, 26.32))
				{
					pData[playerid][pGetJob] = 7;
					Info(playerid, "Anda telah berhasil mendaftarkan job farmer. /accept job untuk konfirmasi.");
				}
				else if(pData[playerid][pJob] == 0 && GetPlayerState(playerid) == 1 && IsPlayerInRangeOfPoint(playerid, 3.0, -3805.5723,1307.4285,75.5859))
				{                                                                                                            
					pData[playerid][pGetJob] = 8;
					Info(playerid, "Anda telah berhasil mendaftarkan job smuggler. /accept job untuk konfirmasi.");
				}
				else if(pData[playerid][pJob] == 0 && GetPlayerState(playerid) == 1 && IsPlayerInRangeOfPoint(playerid, 3.0, 1613.6221,-1892.9106,13.5469))
				{
					pData[playerid][pGetJob] = 9;
					Info(playerid, "Anda telah berhasil mendaftarkan job courier. /accept job untuk konfirmasi.");
				}
				else if(pData[playerid][pJob] == 0 && GetPlayerState(playerid) == 1 && IsPlayerInRangeOfPoint(playerid, 3.0, -2110.5532, -2400.3428, 31.3713))
				{
					pData[playerid][pGetJob] = 10;
					Info(playerid, "Anda telah berhasil mendaftarkan job pemotong ayam. /accept job untuk konfirmasi.");
				}
				else if(pData[playerid][pJob] == 0 && GetPlayerState(playerid) == 1 && IsPlayerInRangeOfPoint(playerid, 3.0, 1432.51, -967.69, 37.40))
				{
					pData[playerid][pGetJob] = 11;
					Info(playerid, "Anda telah berhasil mendaftarkan job depositor. /accept job untuk konfirmasi.");
				}
				else if(pData[playerid][pJob] == 0 && GetPlayerState(playerid) == 1 && IsPlayerInRangeOfPoint(playerid, 3.0, 2070.6267,-1793.8580,13.5469))
				{
					pData[playerid][pGetJob] = 12;
					Info(playerid, "Anda telah berhasil mendaftarkan job Cleaner. /accept job untuk konfirmasi.");
				}
				else return Error(playerid, "Anda sudah memiliki job atau tidak berada di dekat pendaftaran job.");
			}
			else if(pData[playerid][pJob2] == 0)
			{
				if(pData[playerid][pJob2] == 0 && GetPlayerState(playerid) == 1 && IsPlayerInRangeOfPoint(playerid, 3.0, -2159.04, 640.36, 1052.38))
				{
					pData[playerid][pGetJob2] = 1;
					Info(playerid, "Anda telah berhasil mendaftarkan job Taxi. /accept job untuk konfirmasi.");
				}
				else if(pData[playerid][pJob2] == 0 && GetPlayerState(playerid) == 1 && IsPlayerInRangeOfPoint(playerid, 3.0, 2171.0276,-2238.5984,13.3178))
				{
					pData[playerid][pGetJob2] = 2;
					Info(playerid, "Anda telah berhasil mendaftarkan job mechanic. /accept job untuk konfirmasi.");
				}
				else if(pData[playerid][pJob2] == 0 && GetPlayerState(playerid) == 1 && IsPlayerInRangeOfPoint(playerid, 3.0, -265.87, -2213.63, 29.04))
				{
					pData[playerid][pGetJob2] = 3;
					Info(playerid, "Anda telah berhasil mendaftarkan job lumber jack. /accept job untuk konfirmasi.");
				}
				else if(pData[playerid][pJob2] == 0 && GetPlayerState(playerid) == 1 && IsPlayerInRangeOfPoint(playerid, 3.0, -77.38, -1136.52, 1.07))
				{
					pData[playerid][pGetJob2] = 4;
					Info(playerid, "Anda telah berhasil mendaftarkan job trucker. /accept job untuk konfirmasi.");
				}
				else if(pData[playerid][pJob2] == 0 && GetPlayerState(playerid) == 1 && IsPlayerInRangeOfPoint(playerid, 3.0, 319.94, 874.77, 20.39))
				{
					pData[playerid][pGetJob2] = 5;
					Info(playerid, "Anda telah berhasil mendaftarkan job miner. /accept job untuk konfirmasi.");
				}
				else if(pData[playerid][pJob2] == 0 && GetPlayerState(playerid) == 1 && IsPlayerInRangeOfPoint(playerid, 3.0, -283.02, -2174.36, 28.66))
				{
					pData[playerid][pGetJob2] = 6;
					Info(playerid, "Anda telah berhasil mendaftarkan job production. /accept job untuk konfirmasi.");
				}
				else if(pData[playerid][pJob2] == 0 && GetPlayerState(playerid) == 1 && IsPlayerInRangeOfPoint(playerid, 3.0, -383.67, -1438.90, 26.32))
				{
					pData[playerid][pGetJob2] = 7;
					Info(playerid, "Anda telah berhasil mendaftarkan job farmer. /accept job untuk konfirmasi.");
				}
				else if(pData[playerid][pJob2] == 0 && GetPlayerState(playerid) == 1 && IsPlayerInRangeOfPoint(playerid, 3.0, -3805.5723, 1307.4285, 75.5859))
				{
					pData[playerid][pGetJob2] = 8;
					Info(playerid, "Anda telah berhasil mendaftarkan job smuggler. /accept job untuk konfirmasi.");
				}
				else if(pData[playerid][pJob2] == 0 && GetPlayerState(playerid) == 1 && IsPlayerInRangeOfPoint(playerid, 3.0, 1613.6221, -1892.9106, 13.5469))
				{
					pData[playerid][pGetJob2] = 9;
					Info(playerid, "Anda telah berhasil mendaftarkan job courier. /accept job untuk konfirmasi.");
				}
				else if(pData[playerid][pJob] == 0 && GetPlayerState(playerid) == 1 && IsPlayerInRangeOfPoint(playerid, 3.0, -2110.68, -2400.37, 31.36))
				{
					pData[playerid][pGetJob] = 10;
					Info(playerid, "Anda telah berhasil mendaftarkan job pemotong ayam. /accept job untuk konfirmasi.");
				}
				else if(pData[playerid][pJob] == 0 && GetPlayerState(playerid) == 1 && IsPlayerInRangeOfPoint(playerid, 3.0, 1432.51, -967.69, 37.40))
				{
					pData[playerid][pGetJob] = 11;
					Info(playerid, "Anda telah berhasil mendaftarkan job depositor. /accept job untuk konfirmasi.");
				}
				else if(pData[playerid][pJob] == 0 && GetPlayerState(playerid) == 1 && IsPlayerInRangeOfPoint(playerid, 3.0, 2070.6267,-1793.8580,13.5469))
				{
				pData[playerid][pGetJob] = 12;
				Info(playerid, "Anda telah berhasil mendaftarkan job Cleaner. /accept job untuk konfirmasi.");
				}
				else return Error(playerid, "Anda sudah memiliki job atau tidak berada di dekat pendaftaran job.");
			}
			else return Error(playerid, "Anda sudah memiliki 2 pekerjaan!");
		}
		else return Error(playerid, "Anda sudah memiliki 2 pekerjaan!");
	}
	else
	{
		if(pData[playerid][pJob] > 0)
			return Error(playerid, "Anda hanya bisa memiliki 1 pekerjaan!");

		if(pData[playerid][pJob] == 0 && GetPlayerState(playerid) == 1 && IsPlayerInRangeOfPoint(playerid, 3.0, -2159.04, 640.36, 1052.38))
		{
			pData[playerid][pGetJob] = 1;
			Info(playerid, "Anda telah berhasil mendaftarkan job Taxi. /accept job untuk konfirmasi.");
		}
		else if(pData[playerid][pJob] == 0 && GetPlayerState(playerid) == 1 && IsPlayerInRangeOfPoint(playerid, 3.0, 2171.0276,-2238.5984,13.3178))
		{
			pData[playerid][pGetJob] = 2;
			Info(playerid, "Anda telah berhasil mendaftarkan job mechanic. /accept job untuk konfirmasi.");
		}
		else if(pData[playerid][pJob] == 0 && GetPlayerState(playerid) == 1 && IsPlayerInRangeOfPoint(playerid, 3.0, -265.87, -2213.63, 29.04))
		{
			pData[playerid][pGetJob] = 3;
			Info(playerid, "Anda telah berhasil mendaftarkan job lumber jack. /accept job untuk konfirmasi.");
		}
		else if(pData[playerid][pJob] == 0 && GetPlayerState(playerid) == 1 && IsPlayerInRangeOfPoint(playerid, 3.0, -77.38, -1136.52, 1.07))
		{
			pData[playerid][pGetJob] = 4;
			Info(playerid, "Anda telah berhasil mendaftarkan job trucker. /accept job untuk konfirmasi.");
		}
		else if(pData[playerid][pJob2] == 0 && GetPlayerState(playerid) == 1 && IsPlayerInRangeOfPoint(playerid, 3.0, 319.94, 874.77, 20.39))
		{
			pData[playerid][pGetJob] = 5;
			Info(playerid, "Anda telah berhasil mendaftarkan job miner. /accept job untuk konfirmasi.");
		}
		else if(pData[playerid][pJob] == 0 && GetPlayerState(playerid) == 1 && IsPlayerInRangeOfPoint(playerid, 3.0, -283.02, -2174.36, 28.66))
		{
			pData[playerid][pGetJob] = 6;
			Info(playerid, "Anda telah berhasil mendaftarkan job production. /accept job untuk konfirmasi.");
		}
		else if(pData[playerid][pJob] == 0 && GetPlayerState(playerid) == 1 && IsPlayerInRangeOfPoint(playerid, 3.0, -383.67, -1438.90, 26.32))
		{
			pData[playerid][pGetJob] = 7;
			Info(playerid, "Anda telah berhasil mendaftarkan job farmer. /accept job untuk konfirmasi.");
		}
		else if(pData[playerid][pJob] == 0 && GetPlayerState(playerid) == 1 && IsPlayerInRangeOfPoint(playerid, 3.0, -3805.5723, 1307.4285, 75.5859))
		{
			pData[playerid][pGetJob] = 8;
			Info(playerid, "Anda telah berhasil mendaftarkan job smuggler. /accept job untuk konfirmasi.");
		}
		else if(pData[playerid][pJob] == 0 && GetPlayerState(playerid) == 1 && IsPlayerInRangeOfPoint(playerid, 3.0, 1613.6221,-1892.9106,13.5469))
		{
			pData[playerid][pGetJob] = 9;
			Info(playerid, "Anda telah berhasil mendaftarkan job courier. /accept job untuk konfirmasi.");
		}
		else if(pData[playerid][pJob] == 0 && GetPlayerState(playerid) == 1 && IsPlayerInRangeOfPoint(playerid, 3.0, -2110.68, -2400.37, 31.36))
		{
			pData[playerid][pGetJob] = 10;
			Info(playerid, "Anda telah berhasil mendaftarkan job pemotong ayam. /accept job untuk konfirmasi.");
		}
		else return Error(playerid, "Anda sudah memiliki job atau tidak berada di dekat pendaftaran job.");
	}
	return 1;
}

CMD:inspect(playerid, params[])
{
	new otherid;
	if(sscanf(params, "u", otherid))
        return Usage(playerid, "/inspect [playerid/PartOfName]");

    if(otherid == INVALID_PLAYER_ID || !NearPlayer(playerid, otherid, 5.0))
        return Error(playerid, "The specified player is disconnected or not near you.");

    if(otherid == playerid)
        return Error(playerid, "You cannot inspect yourself.");

    pData[otherid][pInspectOffer] = playerid;

    Info(otherid, "%s has offered to inspect you (type \"/accept inspect or /deny inspect\").", ReturnName(playerid));
    Info(playerid, "You have offered to inspect %s.", ReturnName(otherid));
	return 1;
}

CMD:frisk(playerid, params[])
{
	new otherid;
	if(sscanf(params, "u", otherid))
        return Usage(playerid, "/frisk [playerid/PartOfName]");

    if(otherid == INVALID_PLAYER_ID || !NearPlayer(playerid, otherid, 5.0))
        return Error(playerid, "The specified player is disconnected or not near you.");

    if(otherid == playerid)
        return Error(playerid, "You cannot frisk yourself.");

    pData[otherid][pFriskOffer] = playerid;

    Info(otherid, "%s has offered to frisk you (type \"/accept frisk or /deny frisk\").", ReturnName(playerid));
    Info(playerid, "You have offered to frisk %s.", ReturnName(otherid));
	return 1;
}

CMD:accept(playerid, params[])
{
	if(IsPlayerConnected(playerid))
	{
        if(isnull(params))
		{
            Usage(playerid, "/accept [name]");
            Info(playerid, "Names: faction, family, drag, frisk, job, farm");
            return 1;
        }
		if(strcmp(params,"faction",true) == 0)
		{
            if(IsPlayerConnected(pData[playerid][pFacOffer]))
			{
                if(pData[playerid][pFacInvite] > 0)
				{
                    pData[playerid][pFaction] = pData[playerid][pFacInvite];
					pData[playerid][pFactionRank] = 1;
					Info(playerid, "Anda telah menerima invite faction dari %s", pData[pData[playerid][pFacOffer]][pName]);
					Info(pData[playerid][pFacOffer], "%s telah menerima invite faction yang anda tawari", pData[playerid][pName]);
					pData[playerid][pFacInvite] = 0;
					pData[playerid][pFacOffer] = -1;
				}
				else
				{
					Error(playerid, "Invalid faction id!");
					return 1;
				}
            }
            else
			{
                Error(playerid, "Tidak ada player yang menawari anda!");
                return 1;
            }
        }
		if(strcmp(params,"family",true) == 0)
		{
            if(IsPlayerConnected(pData[playerid][pFamOffer]))
			{
                if(pData[playerid][pFamInvite] > -1)
				{
                    pData[playerid][pFamily] = pData[playerid][pFamInvite];
					pData[playerid][pFamilyRank] = 1;
					Info(playerid, "Anda telah menerima invite family dari %s", pData[pData[playerid][pFamOffer]][pName]);
					Info(pData[playerid][pFamOffer], "%s telah menerima invite family yang anda tawari", pData[playerid][pName]);
					pData[playerid][pFamInvite] = 0;
					pData[playerid][pFamOffer] = -1;
				}
				else
				{
					Error(playerid, "Invalid family id!");
					return 1;
				}
            }
            else
			{
                Error(playerid, "Tidak ada player yang menawari anda!");
                return 1;
            }
        }
        if(strcmp(params,"farm",true) == 0)
		{
            if(IsPlayerConnected(pData[playerid][pFarmOffer]))
			{
                if(pData[playerid][pFarmInvite] > -1)
				{
                    pData[playerid][pFarm] = pData[playerid][pFarmInvite];
					pData[playerid][pFarmRank] = 1;
					Info(playerid, "Anda telah menerima invite farm dari %s", pData[pData[playerid][pFarmOffer]][pName]);
					Info(pData[playerid][pFarmOffer], "%s telah menerima invite farm yang anda tawari", pData[playerid][pName]);
					pData[playerid][pFarmInvite] = 0;
					pData[playerid][pFarmOffer] = -1;
				}
				else
				{
					Error(playerid, "Invalid farm id!");
					return 1;
				}
            }
            else
			{
                Error(playerid, "Tidak ada player yang menawari anda!");
                return 1;
            }
        }
		else if(strcmp(params,"drag",true) == 0)
		{
			new dragby = GetPVarInt(playerid, "DragBy");
			if(dragby == INVALID_PLAYER_ID || dragby == playerid)
				return Error(playerid, "That player is disconnected.");

			if(!NearPlayer(playerid, dragby, 5.0))
				return Error(playerid, "You must be near this player.");

			pData[playerid][pDragged] = 1;
			pData[playerid][pDraggedBy] = dragby;

			pData[playerid][pDragTimer] = SetTimerEx("DragUpdate", 1000, true, "ii", dragby, playerid);
			SendNearbyMessage(dragby, 30.0, COLOR_PURPLE, "* %s grabs %s and starts dragging them, (/undrag).", ReturnName(dragby), ReturnName(playerid));
			return true;
		}
		else if(strcmp(params,"frisk",true) == 0)
		{
			if(pData[playerid][pFriskOffer] == INVALID_PLAYER_ID || !IsPlayerConnected(pData[playerid][pFriskOffer]))
				return Error(playerid, "That player not connected!");

			if(!NearPlayer(playerid, pData[playerid][pFriskOffer], 5.0))
				return Error(playerid, "You must be near this player.");

			DisplayItems(pData[playerid][pFriskOffer], playerid);
			Servers(playerid, "Anda telah berhasil menaccept tawaran frisk kepada %s.", ReturnName(pData[playerid][pFriskOffer]));
			pData[playerid][pFriskOffer] = INVALID_PLAYER_ID;
		}
		else if(strcmp(params,"inspect",true) == 0)
		{
			if(pData[playerid][pInspectOffer] == INVALID_PLAYER_ID || !IsPlayerConnected(pData[playerid][pFriskOffer]))
				return Error(playerid, "That player not connected!");

			if(!NearPlayer(playerid, pData[playerid][pInspectOffer], 5.0))
				return Error(playerid, "You must be near this player.");

			new body[80];
            if(pData[playerid][pSick] == 0)
            {
                body = "Normal";
            }
            else
            {
                body = "Sick";
            }
            new coordsString[10000], S3MP4K[10000], idiot[1401];
            format(idiot, sizeof(idiot), "{00ffff}Character Health{FFFFFF}");
            //SendClientMessageEx(playerid,COLOR_PINK,coordsString);
            format(coordsString, sizeof(coordsString), "{FF00EA}Body Part Status\n");
            strcat(S3MP4K, coordsString);
            //SendClientMessageEx(playerid, 0xFFFF00FF,coordsString);
            format(coordsString, sizeof(coordsString), "{FFFFFF}Part: {00FFEE}Body\n");
            strcat(S3MP4K, coordsString);
            //SendClientMessageEx(playerid, 0xFFFFFFAA,coordsString);
            format(coordsString, sizeof(coordsString), "{FFFFFF}Condition: {6EF83C}%s\n", body);
            strcat(S3MP4K, coordsString);
            //SendClientMessageEx(playerid, 0xFFFFFFAA,coordsString);
            format(coordsString, sizeof(coordsString), "{FFFFFF}Part: {00FFEE}Groin\n");
            strcat(S3MP4K, coordsString);
            //SendClientMessageEx(playerid,COLOR_PINK,coordsString);
            format(coordsString, sizeof(coordsString), "{FFFFFF}Condition: %s\n", pStockBodyCondition0(playerid));
            strcat(S3MP4K, coordsString);
            //SendClientMessageEx(playerid, 0xFFFFFFAA,coordsString);
            format(coordsString, sizeof(coordsString), "{FFFFFF}Part: {00FFEE}Torso\n");
            strcat(S3MP4K, coordsString);
            //SendClientMessageEx(playerid, 0xFFFFFFAA,coordsString);
            format(coordsString, sizeof(coordsString), "{FFFFFF}Condition: %s\n", pStockBodyCondition1(playerid));
            strcat(S3MP4K, coordsString);
            format(coordsString, sizeof(coordsString), "{FFFFFF}Part: {00FFEE}Right Arm\n");
            strcat(S3MP4K, coordsString);
            format(coordsString, sizeof(coordsString), "{FFFFFF}Condition: %s\n", pStockBodyCondition2(playerid));
            strcat(S3MP4K, coordsString);
            format(coordsString, sizeof(coordsString), "{FFFFFF}Part: {00FFEE}Left Arm\n");
            strcat(S3MP4K, coordsString);
            format(coordsString, sizeof(coordsString), "{FFFFFF}Condition: %s\n", pStockBodyCondition3(playerid));
            strcat(S3MP4K, coordsString);
            format(coordsString, sizeof(coordsString), "{FFFFFF}Part: {00FFEE}Right Leg\n");
            strcat(S3MP4K, coordsString);
            format(coordsString, sizeof(coordsString), "{FFFFFF}Condition: %s\n", pStockBodyCondition4(playerid));
            strcat(S3MP4K, coordsString);
            format(coordsString, sizeof(coordsString), "{FFFFFF}Part: {00FFEE}Left Leg\n");
            strcat(S3MP4K, coordsString);
            format(coordsString, sizeof(coordsString), "{FFFFFF}Condition: %s\n", pStockBodyCondition5(playerid));
            strcat(S3MP4K, coordsString);
            //SendClientMessageEx(playerid, 0xFFFFFFAA,coordsString);
            ShowPlayerDialog(pData[playerid][pInspectOffer], DIALOG_HEALTH, DIALOG_STYLE_MSGBOX, "Body Status",S3MP4K,"Close","");
			Servers(playerid, "Anda telah berhasil menaccept tawaran inspect kepada %s.", ReturnName(pData[playerid][pFriskOffer]));
			pData[playerid][pInspectOffer] = INVALID_PLAYER_ID;
		}
		else if(strcmp(params, "handshake",true) == 0) {

            foreach(new i : Player)
	 			{
                if(GetPVarInt(i, "shrequest") == playerid) {
                    new
                        Float: ppFloats[3];

                    GetPlayerPos(i, ppFloats[0], ppFloats[1], ppFloats[2]);

                    if(!IsPlayerInRangeOfPoint(playerid, 5, ppFloats[0], ppFloats[1], ppFloats[2])) {
                        Count++;
                        SendClientMessageEx(playerid, COLOR_PINK, "You're too far away. You can't accept the handshake right now.");
                    }
                    else {
                        switch(GetPVarInt(i, "shstyle")) {
                            case 1:
                            {
                                Count++;
                                PlayerFacePlayer( playerid, i );
                                ApplyAnimation( playerid, "GANGS", "hndshkaa", 4.1, 0, 1, 1, 0, 0, 1);
                                ApplyAnimation( i, "GANGS", "hndshkaa", 4.1, 0, 1, 1, 0, 0, 1);
                                SetPVarInt(i, "shrequest", INVALID_PLAYER_ID);
                                DeletePVar(i, "shstyle");
                            }
                            case 2:
                            {
                                Count++;
                                PlayerFacePlayer( playerid, i );
                                ApplyAnimation( playerid, "GANGS", "hndshkba", 4.1, 0, 1, 1, 0, 0, 1);
                                ApplyAnimation( i, "GANGS", "hndshkba", 4.1, 0, 1, 1, 0, 0, 1);
                                SetPVarInt(i, "shrequest", INVALID_PLAYER_ID);
                                DeletePVar(i, "shstyle");
                            }
                            case 3:
                            {
                                Count++;
                                PlayerFacePlayer( playerid, i );
                                ApplyAnimation( playerid, "GANGS", "hndshkca", 4.1, 0, 1, 1, 0, 0, 1);
                                ApplyAnimation( i, "GANGS", "hndshkca", 4.1, 0, 1, 1, 0, 0, 1);
                                SetPVarInt(i, "shrequest", INVALID_PLAYER_ID);
                                DeletePVar(i, "shstyle");
                            }
                            case 4:
                            {
                                Count++;
                                PlayerFacePlayer( playerid, i );
                                ApplyAnimation( playerid, "GANGS", "hndshkcb", 4.1, 0, 1, 1, 0, 0, 1);
                                ApplyAnimation( i, "GANGS", "hndshkca", 4.1, 0, 1, 1, 0, 0, 1);
                                SetPVarInt(i, "shrequest", INVALID_PLAYER_ID);
                                DeletePVar(i, "shstyle");
                            }
                            case 5:
                            {
                                Count++;
                                PlayerFacePlayer( playerid, i );
                                ApplyAnimation( playerid, "GANGS", "hndshkda", 4.1, 0, 1, 1, 0, 0, 1);
                                ApplyAnimation( i, "GANGS", "hndshkca", 4.1, 0, 1, 1, 0, 0, 1);
                                SetPVarInt(i, "shrequest", INVALID_PLAYER_ID);
                                DeletePVar(i, "shstyle");
                            }
                            case 6:
                            {
                                Count++;
                                PlayerFacePlayer( playerid, i );
                                ApplyAnimation( playerid, "GANGS","hndshkfa_swt", 4.1, 0, 1, 1, 0, 0, 1);
                                ApplyAnimation( i, "GANGS","hndshkfa_swt", 4.1, 0, 1, 1, 0, 0, 1);
                                SetPVarInt(i, "shrequest", INVALID_PLAYER_ID);
                                DeletePVar(i, "shstyle");
                            }
                            case 7:
                            {
                                Count++;
                                PlayerFacePlayer( playerid, i );
                                ApplyAnimation( playerid, "GANGS", "prtial_hndshk_01", 4.1, 0, 1, 1, 0, 0, 1);
                                ApplyAnimation( i, "GANGS", "prtial_hndshk_01", 4.1, 0, 1, 1, 0, 0, 1);
                                SetPVarInt(i, "shrequest", INVALID_PLAYER_ID);
                                DeletePVar(i, "shstyle");
                            }
                            case 8:
                            {
                                Count++;
                                PlayerFacePlayer( playerid, i );
                                ApplyAnimation( playerid, "GANGS", "prtial_hndshk_biz_01", 4.1, 0, 1, 1, 0, 0, 1);
                                ApplyAnimation( i, "GANGS", "prtial_hndshk_biz_01", 4.1, 0, 1, 1, 0, 0, 1);
                                SetPVarInt(i, "shrequest", INVALID_PLAYER_ID);
                                DeletePVar(i, "shstyle");
                            }
                        }
                    }
                }
            }
            if(Count == 0) return SendClientMessageEx(playerid, COLOR_PINK, "You don't have any pending handshake requests.");
            return 1;
        }
		else if(strcmp(params,"job",true) == 0)
		{
			if(pData[playerid][pGetJob] > 0)
			{
				pData[playerid][pJob] = pData[playerid][pGetJob];
				Info(playerid, "Anda telah berhasil mendapatkan pekerjaan baru. gunakan /help untuk informasi.");
				pData[playerid][pGetJob] = 0;
				pData[playerid][pExitJob] = gettime() + (1 * 7200);
			}
			else if(pData[playerid][pGetJob2] > 0)
			{
				pData[playerid][pJob2] = pData[playerid][pGetJob2];
				Info(playerid, "Anda telah berhasil mendapatkan pekerjaan baru. gunakan /help untuk informasi.");
				pData[playerid][pGetJob2] = 0;
				pData[playerid][pExitJob] = gettime() + (1 * 7200);
			}
		}
	}
	return 1;
}

CMD:deny(playerid, params[])
{
	if(IsPlayerConnected(playerid))
	{
        if(isnull(params))
		{
            Usage(playerid, "/deny [name]");
            Info(playerid, "Names: faction, drag, frisk, job1, job2");
            return 1;
        }
		if(strcmp(params,"faction",true) == 0)
		{
            if(pData[playerid][pFacOffer] > -1)
			{
                if(pData[playerid][pFacInvite] > 0)
				{
					Info(playerid, "Anda telah menolak faction dari %s", ReturnName(pData[playerid][pFacOffer]));
					Info(pData[playerid][pFacOffer], "%s telah menolak invite faction yang anda tawari", ReturnName(playerid));
					pData[playerid][pFacInvite] = 0;
					pData[playerid][pFacOffer] = -1;
				}
				else
				{
					Error(playerid, "Invalid faction id!");
					return 1;
				}
            }
            else
			{
                Error(playerid, "Tidak ada player yang menawari anda!");
                return 1;
            }
        }
        if(strcmp(params,"family",true) == 0)
		{
            if(pData[playerid][pFamOffer] > -1)
			{
                if(pData[playerid][pFamInvite] > 0)
				{
					Info(playerid, "Anda telah menolak fam dari %s", ReturnName(pData[playerid][pFamOffer]));
					Info(pData[playerid][pFamOffer], "%s telah menolak invite fam yang anda tawari", ReturnName(playerid));
					pData[playerid][pFamInvite] = 0;
					pData[playerid][pFamOffer] = -1;
				}
				else
				{
					Error(playerid, "Invalid fam id!");
					return 1;
				}
            }
            else
			{
                Error(playerid, "Tidak ada player yang menawari anda!");
                return 1;
            }
        }
        if(strcmp(params,"farm",true) == 0)
		{
            if(pData[playerid][pFarmOffer] > -1)
			{
                if(pData[playerid][pFarmInvite] > 0)
				{
					Info(playerid, "Anda telah menolak farm dari %s", ReturnName(pData[playerid][pFarmOffer]));
					Info(pData[playerid][pFarmOffer], "%s telah menolak invite farm yang anda tawari", ReturnName(playerid));
					pData[playerid][pFarmInvite] = 0;
					pData[playerid][pFarmOffer] = -1;
				}
				else
				{
					Error(playerid, "Invalid farm id!");
					return 1;
				}
            }
            else
			{
                Error(playerid, "Tidak ada player yang menawari anda!");
                return 1;
            }
        }
		else if(strcmp(params,"drag",true) == 0)
		{
			new dragby = GetPVarInt(playerid, "DragBy");
			if(dragby == INVALID_PLAYER_ID || dragby == playerid)
				return Error(playerid, "That player is disconnected.");

			Info(playerid, "Anda telah menolak drag.");
			Info(dragby, "Player telah menolak drag yang anda tawari.");

			DeletePVar(playerid, "DragBy");
			pData[playerid][pDragged] = 0;
			pData[playerid][pDraggedBy] = INVALID_PLAYER_ID;
			return 1;
		}
		else if(strcmp(params,"frisk",true) == 0)
		{
			if(pData[playerid][pFriskOffer] == INVALID_PLAYER_ID || !IsPlayerConnected(pData[playerid][pFriskOffer]))
				return Error(playerid, "That player not connected!");

			Info(playerid, "Anda telah menolak tawaran frisk kepada %s.", ReturnName(pData[playerid][pFriskOffer]));
			pData[playerid][pFriskOffer] = INVALID_PLAYER_ID;
			return 1;
		}
		else if(strcmp(params,"job1",true) == 0)
		{
			if(pData[playerid][pJob] == 0) return Error(playerid, "Anda tidak memiliki job apapun.");
			if(pData[playerid][pExitJob] != 0) return Error(playerid, "You must wait 1 days for exit from your current job!");
			if(pData[playerid][pJob] != 0)
			{
				pData[playerid][pJob] = 0;
				Info(playerid, "Anda berhasil keluar dari pekerjaan anda.");
				return 1;
			}
		}
		else if(strcmp(params,"job2",true) == 0)
		{
			if(pData[playerid][pJob2] == 0) return Error(playerid, "Anda tidak memiliki job apapun.");
			if(pData[playerid][pJob2] != 0)
			{
				pData[playerid][pJob2] = 0;
				Info(playerid, "Anda berhasil keluar dari pekerjaan anda.");
				return 1;
			}
		}
	}
	return 1;
}

CMD:give(playerid, params[])
{
	if(IsPlayerConnected(playerid))
	{
		new name[24], ammount, otherid;
        if(sscanf(params, "us[24]d", otherid, name, ammount))
		{
			Usage(playerid, "/give [playerid] [name] [ammount]");
			Info(playerid, "Names: bandage, painkiller, medkit, paracetamol, amoxicilin, antasida, snack, sprunk, material, component, marijuana, berry, borax(paket borax)");
			return 1;
		}
		if(otherid == INVALID_PLAYER_ID || otherid == playerid || !NearPlayer(playerid, otherid, 3.0))
			return Error(playerid, "Invalid playerid!");

		if(!(1 <= ammount <= 500))
			return Error(playerid, "1-500");

		if(strcmp(name,"bandage",true) == 0)
		{
			if(pData[playerid][pBandage] < ammount)
				return Error(playerid, "Item anda tidak cukup.");

			pData[playerid][pBandage] -= ammount;
			pData[otherid][pBandage] += ammount;
			Info(playerid, "Anda telah berhasil memberikan perban kepada %s sejumlah %d.", ReturnName(otherid), ammount);
			Info(otherid, "%s telah berhasil memberikan perban kepada anda sejumlah %d.", ReturnName(playerid), ammount);
			ApplyAnimation(playerid, "DEALER", "shop_pay", 4.0, 0, 0, 0, 0, 0);
			ApplyAnimation(otherid, "DEALER", "shop_pay", 4.0, 0, 0, 0, 0, 0);
			//playerid
			PlayerTextDrawSetString(playerid, ITEMSNAME[playerid], "Bandage");
			PlayerTextDrawSetString(playerid, Received[playerid], "Gived");
			PlayerTextDrawSetPreviewModel(playerid, MODELITEM[playerid], 11747);
			PlayerTextDrawShow(playerid, ITEMSBOX[0][playerid]);
			PlayerTextDrawShow(playerid, ITEMSBOX[1][playerid]);
			PlayerTextDrawShow(playerid, Received[playerid]);
			PlayerTextDrawShow(playerid, ITEMSNAME[playerid]);
			PlayerTextDrawShow(playerid, MODELITEM[playerid]);
			SetTimerEx("ItemsBoxtimer", 5500, false, "i", playerid);
			//otherid
			PlayerTextDrawSetString(otherid, ITEMSNAME[otherid], "Bandage");
			PlayerTextDrawSetString(otherid, Received[otherid], "Received");
			PlayerTextDrawSetPreviewModel(otherid, MODELITEM[otherid], 11747);	
			PlayerTextDrawShow(otherid, ITEMSBOX[0][otherid]);
			PlayerTextDrawShow(otherid, ITEMSBOX[1][otherid]);
			PlayerTextDrawShow(otherid, Received[otherid]);
			PlayerTextDrawShow(otherid, ITEMSNAME[otherid]);
			PlayerTextDrawShow(otherid, MODELITEM[otherid]);
			SetTimerEx("ItemsBoxtimer", 5500, false, "i", otherid);
		}
		else if(strcmp(name,"painkiller",true) == 0)
		{
			if(pData[playerid][pMedicine] < ammount)
				return Error(playerid, "Item anda tidak cukup.");

			pData[playerid][pMedicine] -= ammount;
			pData[otherid][pMedicine] += ammount;
			Info(playerid, "Anda telah berhasil memberikan painkiller kepada %s sejumlah %d.", ReturnName(otherid), ammount);
			Info(otherid, "%s telah berhasil memberikan painkiller kepada anda sejumlah %d.", ReturnName(playerid), ammount);
			ApplyAnimation(playerid, "DEALER", "shop_pay", 4.0, 0, 0, 0, 0, 0);
			ApplyAnimation(otherid, "DEALER", "shop_pay", 4.0, 0, 0, 0, 0, 0);
			//playerid
			PlayerTextDrawSetString(playerid, ITEMSNAME[playerid], "Painkiller");
			PlayerTextDrawSetString(playerid, Received[playerid], "Gived");
			PlayerTextDrawSetPreviewModel(playerid, MODELITEM[playerid], 2709);
			PlayerTextDrawShow(playerid, ITEMSBOX[0][playerid]);
			PlayerTextDrawShow(playerid, ITEMSBOX[1][playerid]);
			PlayerTextDrawShow(playerid, Received[playerid]);
			PlayerTextDrawShow(playerid, ITEMSNAME[playerid]);
			PlayerTextDrawShow(playerid, MODELITEM[playerid]);
			SetTimerEx("ItemsBoxtimer", 5500, false, "i", playerid);
			//otherid
			PlayerTextDrawSetString(otherid, ITEMSNAME[otherid], "Painkiller");
			PlayerTextDrawSetString(otherid, Received[otherid], "Received");
			PlayerTextDrawSetPreviewModel(otherid, MODELITEM[otherid], 2709);	
			PlayerTextDrawShow(otherid, ITEMSBOX[0][otherid]);
			PlayerTextDrawShow(otherid, ITEMSBOX[1][otherid]);
			PlayerTextDrawShow(otherid, Received[otherid]);
			PlayerTextDrawShow(otherid, ITEMSNAME[otherid]);
			PlayerTextDrawShow(otherid, MODELITEM[otherid]);
			SetTimerEx("ItemsBoxtimer", 5500, false, "i", otherid);
		}
		else if(strcmp(name, "paracetamol",true) == 0)
		{
			if(pData[playerid][pParacetamol] < ammount)
				return Error(playerid, "Item anda tidak cukup.");

			pData[playerid][pParacetamol] -= ammount;
			pData[otherid][pParacetamol] += ammount;
			Info(playerid, "Anda telah berhasil memberikan paracetamol kepada %s sejumlah %d.", ReturnName(otherid), ammount);
			Info(otherid, "%s telah berhasil memberikan paracetamol kepada anda sejumlah %d.", ReturnName(playerid), ammount);
			ApplyAnimation(playerid, "DEALER", "shop_pay", 4.0, 0, 0, 0, 0, 0);
			ApplyAnimation(otherid, "DEALER", "shop_pay", 4.0, 0, 0, 0, 0, 0);

			//playerid
			PlayerTextDrawSetString(playerid, ITEMSNAME[playerid], "Paracetamol");
			PlayerTextDrawSetString(playerid, Received[playerid], "Gived");
			PlayerTextDrawSetPreviewModel(playerid, MODELITEM[playerid], 11736);
			PlayerTextDrawShow(playerid, ITEMSBOX[0][playerid]);
			PlayerTextDrawShow(playerid, ITEMSBOX[1][playerid]);
			PlayerTextDrawShow(playerid, Received[playerid]);
			PlayerTextDrawShow(playerid, ITEMSNAME[playerid]);
			PlayerTextDrawShow(playerid, MODELITEM[playerid]);
			SetTimerEx("ItemsBoxtimer", 5500, false, "i", playerid);
			//otherid
			PlayerTextDrawSetString(otherid, ITEMSNAME[otherid], "Paracetamol");
			PlayerTextDrawSetString(otherid, Received[otherid], "Received");
			PlayerTextDrawSetPreviewModel(otherid, MODELITEM[otherid], 11736);	
			PlayerTextDrawShow(otherid, ITEMSBOX[0][otherid]);
			PlayerTextDrawShow(otherid, ITEMSBOX[1][otherid]);
			PlayerTextDrawShow(otherid, Received[otherid]);
			PlayerTextDrawShow(otherid, ITEMSNAME[otherid]);
			PlayerTextDrawShow(otherid, MODELITEM[otherid]);
			SetTimerEx("ItemsBoxtimer", 5500, false, "i", otherid);
		}
		else if(strcmp(name, "amoxicilin",true) == 0)
		{
			if(pData[playerid][pAmoxicilin] < ammount)
				return Error(playerid, "Item anda tidak cukup.");

			pData[playerid][pAmoxicilin] -= ammount;
			pData[otherid][pAmoxicilin] += ammount;
			Info(playerid, "Anda telah berhasil memberikan Amoxicilin kepada %s sejumlah %d.", ReturnName(otherid), ammount);
			Info(otherid, "%s telah berhasil memberikan Amoxicilin kepada anda sejumlah %d.", ReturnName(playerid), ammount);
			ApplyAnimation(playerid, "DEALER", "shop_pay", 4.0, 0, 0, 0, 0, 0);
			ApplyAnimation(otherid, "DEALER", "shop_pay", 4.0, 0, 0, 0, 0, 0);

			//playerid
			PlayerTextDrawSetString(playerid, ITEMSNAME[playerid], "Amoxicilin");
			PlayerTextDrawSetString(playerid, Received[playerid], "Gived");
			PlayerTextDrawSetPreviewModel(playerid, MODELITEM[playerid], 11736);
			PlayerTextDrawShow(playerid, ITEMSBOX[0][playerid]);
			PlayerTextDrawShow(playerid, ITEMSBOX[1][playerid]);
			PlayerTextDrawShow(playerid, Received[playerid]);
			PlayerTextDrawShow(playerid, ITEMSNAME[playerid]);
			PlayerTextDrawShow(playerid, MODELITEM[playerid]);
			SetTimerEx("ItemsBoxtimer", 5500, false, "i", playerid);
			//otherid
			PlayerTextDrawSetString(otherid, ITEMSNAME[otherid], "Amoxicilin");
			PlayerTextDrawSetString(otherid, Received[otherid], "Received");
			PlayerTextDrawSetPreviewModel(otherid, MODELITEM[otherid], 11736);	
			PlayerTextDrawShow(otherid, ITEMSBOX[0][otherid]);
			PlayerTextDrawShow(otherid, ITEMSBOX[1][otherid]);
			PlayerTextDrawShow(otherid, Received[otherid]);
			PlayerTextDrawShow(otherid, ITEMSNAME[otherid]);
			PlayerTextDrawShow(otherid, MODELITEM[otherid]);
			SetTimerEx("ItemsBoxtimer", 5500, false, "i", otherid);
		}
		else if(strcmp(name, "antasida",true) == 0)
		{
			if(pData[playerid][pAntasida] < ammount)
				return Error(playerid, "Item anda tidak cukup.");

			pData[playerid][pAntasida] -= ammount;
			pData[otherid][pAntasida] += ammount;
			Info(playerid, "Anda telah berhasil memberikan antasida kepada %s sejumlah %d.", ReturnName(otherid), ammount);
			Info(otherid, "%s telah berhasil memberikan antasia kepada anda sejumlah %d.", ReturnName(playerid), ammount);
			ApplyAnimation(playerid, "DEALER", "shop_pay", 4.0, 0, 0, 0, 0, 0);
			ApplyAnimation(otherid, "DEALER", "shop_pay", 4.0, 0, 0, 0, 0, 0);

			//playerid
			PlayerTextDrawSetString(playerid, ITEMSNAME[playerid], "Antasida");
			PlayerTextDrawSetString(playerid, Received[playerid], "Gived");
			PlayerTextDrawSetPreviewModel(playerid, MODELITEM[playerid], 11736);
			PlayerTextDrawShow(playerid, ITEMSBOX[0][playerid]);
			PlayerTextDrawShow(playerid, ITEMSBOX[1][playerid]);
			PlayerTextDrawShow(playerid, Received[playerid]);
			PlayerTextDrawShow(playerid, ITEMSNAME[playerid]);
			PlayerTextDrawShow(playerid, MODELITEM[playerid]);
			SetTimerEx("ItemsBoxtimer", 5500, false, "i", playerid);
			//otherid
			PlayerTextDrawSetString(otherid, ITEMSNAME[otherid], "Antasida");
			PlayerTextDrawSetString(otherid, Received[otherid], "Received");
			PlayerTextDrawSetPreviewModel(otherid, MODELITEM[otherid], 11736);	
			PlayerTextDrawShow(otherid, ITEMSBOX[0][otherid]);
			PlayerTextDrawShow(otherid, ITEMSBOX[1][otherid]);
			PlayerTextDrawShow(otherid, Received[otherid]);
			PlayerTextDrawShow(otherid, ITEMSNAME[otherid]);
			PlayerTextDrawShow(otherid, MODELITEM[otherid]);
			SetTimerEx("ItemsBoxtimer", 5500, false, "i", otherid);
		}
		else if(strcmp(name,"medkit",true) == 0)
		{
			if(pData[playerid][pMedkit] < ammount)
				return Error(playerid, "Item anda tidak cukup.");

			pData[playerid][pMedkit] -= ammount;
			pData[otherid][pMedkit] += ammount;
			Info(playerid, "Anda telah berhasil memberikan medkit kepada %s sejumlah %d.", ReturnName(otherid), ammount);
			Info(otherid, "%s telah berhasil memberikan medkit kepada anda sejumlah %d.", ReturnName(playerid), ammount);
			ApplyAnimation(playerid, "DEALER", "shop_pay", 4.0, 0, 0, 0, 0, 0);
			ApplyAnimation(otherid, "DEALER", "shop_pay", 4.0, 0, 0, 0, 0, 0);
			//playerid
			PlayerTextDrawSetString(playerid, ITEMSNAME[playerid], "Medkit");
			PlayerTextDrawSetString(playerid, Received[playerid], "Gived");
			PlayerTextDrawSetPreviewModel(playerid, MODELITEM[playerid], 11736);
			PlayerTextDrawShow(playerid, ITEMSBOX[0][playerid]);
			PlayerTextDrawShow(playerid, ITEMSBOX[1][playerid]);
			PlayerTextDrawShow(playerid, Received[playerid]);
			PlayerTextDrawShow(playerid, ITEMSNAME[playerid]);
			PlayerTextDrawShow(playerid, MODELITEM[playerid]);
			SetTimerEx("ItemsBoxtimer", 5500, false, "i", playerid);
			//otherid
			PlayerTextDrawSetString(otherid, ITEMSNAME[otherid], "Medkit");
			PlayerTextDrawSetString(otherid, Received[otherid], "Received");
			PlayerTextDrawSetPreviewModel(otherid, MODELITEM[otherid], 11736);	
			PlayerTextDrawShow(otherid, ITEMSBOX[0][otherid]);
			PlayerTextDrawShow(otherid, ITEMSBOX[1][otherid]);
			PlayerTextDrawShow(otherid, Received[otherid]);
			PlayerTextDrawShow(otherid, ITEMSNAME[otherid]);
			PlayerTextDrawShow(otherid, MODELITEM[otherid]);
			SetTimerEx("ItemsBoxtimer", 5500, false, "i", otherid);
		}
		else if(strcmp(name,"snack",true) == 0)
		{
			if(pData[playerid][pSnack] < ammount)
				return Error(playerid, "Item anda tidak cukup.");

			pData[playerid][pSnack] -= ammount;
			pData[otherid][pSnack] += ammount;
			Info(playerid, "Anda telah berhasil memberikan snack kepada %s sejumlah %d.", ReturnName(otherid), ammount);
			Info(otherid, "%s telah berhasil memberikan snack kepada anda sejumlah %d.", ReturnName(playerid), ammount);
			ApplyAnimation(playerid, "DEALER", "shop_pay", 4.0, 0, 0, 0, 0, 0);
			ApplyAnimation(otherid, "DEALER", "shop_pay", 4.0, 0, 0, 0, 0, 0);
			//playerid
			PlayerTextDrawSetString(playerid, ITEMSNAME[playerid], "Snack");
			PlayerTextDrawSetString(playerid, Received[playerid], "Gived");
			PlayerTextDrawSetPreviewModel(playerid, MODELITEM[playerid], 19811);
			PlayerTextDrawShow(playerid, ITEMSBOX[0][playerid]);
			PlayerTextDrawShow(playerid, ITEMSBOX[1][playerid]);
			PlayerTextDrawShow(playerid, Received[playerid]);
			PlayerTextDrawShow(playerid, ITEMSNAME[playerid]);
			PlayerTextDrawShow(playerid, MODELITEM[playerid]);
			SetTimerEx("ItemsBoxtimer", 5500, false, "i", playerid);
			//otherid
			PlayerTextDrawSetString(otherid, ITEMSNAME[otherid], "Snack");
			PlayerTextDrawSetString(otherid, Received[otherid], "Received");
			PlayerTextDrawSetPreviewModel(otherid, MODELITEM[otherid], 19811);	
			PlayerTextDrawShow(otherid, ITEMSBOX[0][otherid]);
			PlayerTextDrawShow(otherid, ITEMSBOX[1][otherid]);
			PlayerTextDrawShow(otherid, Received[otherid]);
			PlayerTextDrawShow(otherid, ITEMSNAME[otherid]);
			PlayerTextDrawShow(otherid, MODELITEM[otherid]);
			SetTimerEx("ItemsBoxtimer", 5500, false, "i", otherid);
		}
		else if(strcmp(name,"sprunk",true) == 0)
		{
			if(pData[playerid][pSprunk] < ammount)
				return Error(playerid, "Item anda tidak cukup.");

			pData[playerid][pSprunk] -= ammount;
			pData[otherid][pSprunk] += ammount;
			Info(playerid, "Anda telah berhasil memberikan Sprunk kepada %s sejumlah %d.", ReturnName(otherid), ammount);
			Info(otherid, "%s telah berhasil memberikan Sprunk kepada anda sejumlah %d.", ReturnName(playerid), ammount);
			ApplyAnimation(playerid, "DEALER", "shop_pay", 4.0, 0, 0, 0, 0, 0);
			ApplyAnimation(otherid, "DEALER", "shop_pay", 4.0, 0, 0, 0, 0, 0);
			//playerid
			PlayerTextDrawSetString(playerid, ITEMSNAME[playerid], "Sprunk");
			PlayerTextDrawSetString(playerid, Received[playerid], "Gived");
			PlayerTextDrawSetPreviewModel(playerid, MODELITEM[playerid], 13562);
			PlayerTextDrawShow(playerid, ITEMSBOX[0][playerid]);
			PlayerTextDrawShow(playerid, ITEMSBOX[1][playerid]);
			PlayerTextDrawShow(playerid, Received[playerid]);
			PlayerTextDrawShow(playerid, ITEMSNAME[playerid]);
			PlayerTextDrawShow(playerid, MODELITEM[playerid]);
			SetTimerEx("ItemsBoxtimer", 5500, false, "i", playerid);
			//otherid
			PlayerTextDrawSetString(otherid, ITEMSNAME[otherid], "Sprunk");
			PlayerTextDrawSetString(otherid, Received[otherid], "Received");
			PlayerTextDrawSetPreviewModel(otherid, MODELITEM[otherid], 13562);	
			PlayerTextDrawShow(otherid, ITEMSBOX[0][otherid]);
			PlayerTextDrawShow(otherid, ITEMSBOX[1][otherid]);
			PlayerTextDrawShow(otherid, Received[otherid]);
			PlayerTextDrawShow(otherid, ITEMSNAME[otherid]);
			PlayerTextDrawShow(otherid, MODELITEM[otherid]);
			SetTimerEx("ItemsBoxtimer", 5500, false, "i", otherid);
		}
		else if(strcmp(name,"material",true) == 0)
		{
			if(pData[playerid][pMaterial] < ammount)
				return Error(playerid, "Item anda tidak cukup.");

			if(ammount > 500)
				return Error(playerid, "Invalid ammount 1 - 500");

			new maxmat = pData[otherid][pMaterial] + ammount;

			if(maxmat > 500)
				return Error(playerid, "That player already have maximum material!");

			pData[playerid][pMaterial] -= ammount;
			pData[otherid][pMaterial] += ammount;
			Info(playerid, "Anda telah berhasil memberikan Material kepada %s sejumlah %d.", ReturnName(otherid), ammount);
			Info(otherid, "%s telah berhasil memberikan Material kepada anda sejumlah %d.", ReturnName(playerid), ammount);
			ApplyAnimation(playerid, "DEALER", "shop_pay", 4.0, 0, 0, 0, 0, 0);
			ApplyAnimation(otherid, "DEALER", "shop_pay", 4.0, 0, 0, 0, 0, 0);
			//playerid
			PlayerTextDrawSetString(playerid, ITEMSNAME[playerid], "Material");
			PlayerTextDrawSetString(playerid, Received[playerid], "Gived");
			PlayerTextDrawSetPreviewModel(playerid, MODELITEM[playerid], 2042);
			PlayerTextDrawShow(playerid, ITEMSBOX[0][playerid]);
			PlayerTextDrawShow(playerid, ITEMSBOX[1][playerid]);
			PlayerTextDrawShow(playerid, Received[playerid]);
			PlayerTextDrawShow(playerid, ITEMSNAME[playerid]);
			PlayerTextDrawShow(playerid, MODELITEM[playerid]);
			SetTimerEx("ItemsBoxtimer", 5500, false, "i", playerid);
			//otherid
			PlayerTextDrawSetString(otherid, ITEMSNAME[otherid], "Material");
			PlayerTextDrawSetString(otherid, Received[otherid], "Received");
			PlayerTextDrawSetPreviewModel(otherid, MODELITEM[otherid], 2042);	
			PlayerTextDrawShow(otherid, ITEMSBOX[0][otherid]);
			PlayerTextDrawShow(otherid, ITEMSBOX[1][otherid]);
			PlayerTextDrawShow(otherid, Received[otherid]);
			PlayerTextDrawShow(otherid, ITEMSNAME[otherid]);
			PlayerTextDrawShow(otherid, MODELITEM[otherid]);
			SetTimerEx("ItemsBoxtimer", 5500, false, "i", otherid);
		}
		else if(strcmp(name,"component",true) == 0)
		{
			if(pData[playerid][pComponent] < ammount)
				return Error(playerid, "Item anda tidak cukup.");

			if(ammount > 500)
				return Error(playerid, "Invalid ammount 1 - 500");

			new maxcomp = pData[otherid][pComponent] + ammount;

			if(maxcomp > 500)
				return Error(playerid, "That player already have maximum component!");

			pData[playerid][pComponent] -= ammount;
			pData[otherid][pComponent] += ammount;
			Info(playerid, "Anda telah berhasil memberikan Component kepada %s sejumlah %d.", ReturnName(otherid), ammount);
			Info(otherid, "%s telah berhasil memberikan Component kepada anda sejumlah %d.", ReturnName(playerid), ammount);
			ApplyAnimation(playerid, "DEALER", "shop_pay", 4.0, 0, 0, 0, 0, 0);
			ApplyAnimation(otherid, "DEALER", "shop_pay", 4.0, 0, 0, 0, 0, 0);
			//playerid
			PlayerTextDrawSetString(playerid, ITEMSNAME[playerid], "Component");
			PlayerTextDrawSetString(playerid, Received[playerid], "Gived");
			PlayerTextDrawSetPreviewModel(playerid, MODELITEM[playerid], 1271);
			PlayerTextDrawShow(playerid, ITEMSBOX[0][playerid]);
			PlayerTextDrawShow(playerid, ITEMSBOX[1][playerid]);
			PlayerTextDrawShow(playerid, Received[playerid]);
			PlayerTextDrawShow(playerid, ITEMSNAME[playerid]);
			PlayerTextDrawShow(playerid, MODELITEM[playerid]);
			SetTimerEx("ItemsBoxtimer", 5500, false, "i", playerid);
			//otherid
			PlayerTextDrawSetString(otherid, ITEMSNAME[otherid], "Component");
			PlayerTextDrawSetString(otherid, Received[otherid], "Received");
			PlayerTextDrawSetPreviewModel(otherid, MODELITEM[otherid], 1271);	
			PlayerTextDrawShow(otherid, ITEMSBOX[0][otherid]);
			PlayerTextDrawShow(otherid, ITEMSBOX[1][otherid]);
			PlayerTextDrawShow(otherid, Received[otherid]);
			PlayerTextDrawShow(otherid, ITEMSNAME[otherid]);
			PlayerTextDrawShow(otherid, MODELITEM[otherid]);
			SetTimerEx("ItemsBoxtimer", 5500, false, "i", otherid);	
		}
		else if(strcmp(name,"marijuana",true) == 0)
		{
			if(pData[playerid][pMarijuana] < ammount)
				return Error(playerid, "Item anda tidak cukup.");

			pData[playerid][pMarijuana] -= ammount;
			pData[otherid][pMarijuana] += ammount;
			Info(playerid, "Anda telah berhasil memberikan Marijuana kepada %s sejumlah %d.", ReturnName(otherid), ammount);
			Info(otherid, "%s telah berhasil memberikan Marijuana kepada anda sejumlah %d.", ReturnName(playerid), ammount);
			ApplyAnimation(playerid, "DEALER", "shop_pay", 4.0, 0, 0, 0, 0, 0);
			ApplyAnimation(otherid, "DEALER", "shop_pay", 4.0, 0, 0, 0, 0, 0);
			//playerid
			PlayerTextDrawSetString(playerid, ITEMSNAME[playerid], "Marijuana");
			PlayerTextDrawSetString(playerid, Received[playerid], "Gived");
			PlayerTextDrawSetPreviewModel(playerid, MODELITEM[playerid], 2901);
			PlayerTextDrawShow(playerid, ITEMSBOX[0][playerid]);
			PlayerTextDrawShow(playerid, ITEMSBOX[1][playerid]);
			PlayerTextDrawShow(playerid, Received[playerid]);
			PlayerTextDrawShow(playerid, ITEMSNAME[playerid]);
			PlayerTextDrawShow(playerid, MODELITEM[playerid]);
			SetTimerEx("ItemsBoxtimer", 5500, false, "i", playerid);
			//otherid
			PlayerTextDrawSetString(otherid, ITEMSNAME[otherid], "Marijuana");
			PlayerTextDrawSetString(otherid, Received[otherid], "Received");
			PlayerTextDrawSetPreviewModel(otherid, MODELITEM[otherid], 2901);	
			PlayerTextDrawShow(otherid, ITEMSBOX[0][otherid]);
			PlayerTextDrawShow(otherid, ITEMSBOX[1][otherid]);
			PlayerTextDrawShow(otherid, Received[otherid]);
			PlayerTextDrawShow(otherid, ITEMSNAME[otherid]);
			PlayerTextDrawShow(otherid, MODELITEM[otherid]);
			SetTimerEx("ItemsBoxtimer", 5500, false, "i", otherid);		
		}
		else if(strcmp(name,"berry",true) == 0)
		{
			if(pData[playerid][pBerry] < ammount)
				return Error(playerid, "Item anda tidak cukup.");

			pData[playerid][pBerry] -= ammount;
			pData[otherid][pBerry] += ammount;
			Info(playerid, "Anda telah berhasil memberikan Berry kepada %s sejumlah %d.", ReturnName(otherid), ammount);
			Info(otherid, "%s telah berhasil memberikan Berry kepada anda sejumlah %d.", ReturnName(playerid), ammount);
			ApplyAnimation(playerid, "DEALER", "shop_pay", 4.0, 0, 0, 0, 0, 0);
			ApplyAnimation(otherid, "DEALER", "shop_pay", 4.0, 0, 0, 0, 0, 0);
			//playerid
			PlayerTextDrawSetString(playerid, ITEMSNAME[playerid], "Berry");
			PlayerTextDrawSetString(playerid, Received[playerid], "Gived");
			PlayerTextDrawSetPreviewModel(playerid, MODELITEM[playerid], 19575);
			PlayerTextDrawShow(playerid, ITEMSBOX[0][playerid]);
			PlayerTextDrawShow(playerid, ITEMSBOX[1][playerid]);
			PlayerTextDrawShow(playerid, Received[playerid]);
			PlayerTextDrawShow(playerid, ITEMSNAME[playerid]);
			PlayerTextDrawShow(playerid, MODELITEM[playerid]);
			SetTimerEx("ItemsBoxtimer", 5500, false, "i", playerid);
			//otherid
			PlayerTextDrawSetString(otherid, ITEMSNAME[otherid], "Berry");
			PlayerTextDrawSetString(otherid, Received[otherid], "Received");
			PlayerTextDrawSetPreviewModel(otherid, MODELITEM[otherid], 19575);	
			PlayerTextDrawShow(otherid, ITEMSBOX[0][otherid]);
			PlayerTextDrawShow(otherid, ITEMSBOX[1][otherid]);
			PlayerTextDrawShow(otherid, Received[otherid]);
			PlayerTextDrawShow(otherid, ITEMSNAME[otherid]);
			PlayerTextDrawShow(otherid, MODELITEM[otherid]);
			SetTimerEx("ItemsBoxtimer", 5500, false, "i", otherid);		

		}
		else if(strcmp(name,"borax",true) == 0)
		{
			if(pData[playerid][pPaketBorax] < ammount)
				return Error(playerid, "Item anda tidak cukup.");

			pData[playerid][pPaketBorax] -= ammount;
			pData[otherid][pPaketBorax] += ammount;
			Info(playerid, "Anda telah berhasil memberikan Paket Borax kepada %s sejumlah %d.", ReturnName(otherid), ammount);
			Info(otherid, "%s telah berhasil memberikan Paket Borax kepada anda sejumlah %d.", ReturnName(playerid), ammount);
			ApplyAnimation(playerid, "DEALER", "shop_pay", 4.0, 0, 0, 0, 0, 0);
			ApplyAnimation(otherid, "DEALER", "shop_pay", 4.0, 0, 0, 0, 0, 0);
			//playerid
			PlayerTextDrawSetString(playerid, ITEMSNAME[playerid], "Paket Borax");
			PlayerTextDrawSetString(playerid, Received[playerid], "Gived");
			PlayerTextDrawSetPreviewModel(playerid, MODELITEM[playerid], 2925);
			PlayerTextDrawShow(playerid, ITEMSBOX[0][playerid]);
			PlayerTextDrawShow(playerid, ITEMSBOX[1][playerid]);
			PlayerTextDrawShow(playerid, Received[playerid]);
			PlayerTextDrawShow(playerid, ITEMSNAME[playerid]);
			PlayerTextDrawShow(playerid, MODELITEM[playerid]);
			SetTimerEx("ItemsBoxtimer", 5500, false, "i", playerid);
			//otherid
			PlayerTextDrawSetString(otherid, ITEMSNAME[otherid], "Paket Borax");
			PlayerTextDrawSetString(otherid, Received[otherid], "Received");
			PlayerTextDrawSetPreviewModel(otherid, MODELITEM[otherid], 2925);	
			PlayerTextDrawShow(otherid, ITEMSBOX[0][otherid]);
			PlayerTextDrawShow(otherid, ITEMSBOX[1][otherid]);
			PlayerTextDrawShow(otherid, Received[otherid]);
			PlayerTextDrawShow(otherid, ITEMSNAME[otherid]);
			PlayerTextDrawShow(otherid, MODELITEM[otherid]);
			SetTimerEx("ItemsBoxtimer", 5500, false, "i", otherid);	
		}
	}
	return 1;
}

CMD:use(playerid, params[])
{
	if(IsPlayerConnected(playerid))
	{
        if(isnull(params))
		{
            Usage(playerid, "/use [name]");
            Info(playerid, "Names: bandage, snack, sprunk, gas, painkiller, marijuana, boombox, berry, boombox, nugget, burger, teh");
            return 1;
        }
		if(strcmp(params,"bandage",true) == 0)
		{
			if(pData[playerid][pBandage] < 1)
				return Error(playerid, "Anda tidak memiliki perban.");

			if(pData[playerid][pHealth] >= 100)
				return Error(playerid, "Anda sudah tidak sakit.");

			PlayerTextDrawSetString(playerid, ITEMSNAME[playerid], "Bandage");
			PlayerTextDrawSetString(playerid, Received[playerid], "Used");
			PlayerTextDrawSetPreviewModel(playerid, MODELITEM[playerid], 11747);
			PlayerTextDrawShow(playerid, ITEMSBOX[0][playerid]);
			PlayerTextDrawShow(playerid, ITEMSBOX[1][playerid]);
			PlayerTextDrawShow(playerid, Received[playerid]);
			PlayerTextDrawShow(playerid, ITEMSNAME[playerid]);
			PlayerTextDrawShow(playerid, MODELITEM[playerid]);
			PlayerTextDrawSetString(playerid, Loading[2][playerid], "UseBandage");
			for(new i =0 ; i < 3; i++)
			{
				PlayerTextDrawShow(playerid, Loading[i][playerid]);
			}
			SetTimerEx("ItemsBoxtimer", 5500, false, "i", playerid);
			pData[playerid][pActivity] = SetTimerEx("LoadingBandage", 1000, true, "i", playerid);
			ClearAnimations(playerid);
			ApplyAnimation(playerid, "BOMBER","BOM_Plant_Loop",4.0, 0, 0, 0, 0, 0, 1); // Place Bomb
		}
		else if(strcmp(params,"snack",true) == 0)
		{
			if(pData[playerid][pSnack] < 1)
				return Error(playerid, "Anda tidak memiliki snack.");

			PlayerTextDrawSetString(playerid, ITEMSNAME[playerid], "Snack");
			PlayerTextDrawSetString(playerid, Received[playerid], "Used");
			PlayerTextDrawSetPreviewModel(playerid, MODELITEM[playerid], 19811);
			PlayerTextDrawShow(playerid, ITEMSBOX[0][playerid]);
			PlayerTextDrawShow(playerid, ITEMSBOX[1][playerid]);
			PlayerTextDrawShow(playerid, Received[playerid]);
			PlayerTextDrawShow(playerid, ITEMSNAME[playerid]);
			PlayerTextDrawShow(playerid, MODELITEM[playerid]);
			PlayerTextDrawSetString(playerid, Loading[2][playerid], "UseSnack");
			for(new i =0 ; i < 3; i++)
			{
				PlayerTextDrawShow(playerid, Loading[i][playerid]);
			}
			SetTimerEx("ItemsBoxtimer", 5500, false, "i", playerid);
			pData[playerid][pActivity] = SetTimerEx("LoadingSnack", 500, true, "i", playerid);
			ApplyAnimation(playerid, "BAR", "dnk_stndM_loop", 4.1, 0, 0, 0, 0, 0, 0);
		}
		else if(strcmp(params,"sprunk",true) == 0)
		{
			if(pData[playerid][pSprunk] < 1)
				return Error(playerid, "Anda tidak memiliki sprunk.");

			if(pData[playerid][pActivityTime] != 0) 
				return Error(playerid, "Tunggu kamu masih melakukan sesuatu!");

			PlayerTextDrawSetString(playerid, ITEMSNAME[playerid], "Sprunk");
			PlayerTextDrawSetString(playerid, Received[playerid], "Used");
			PlayerTextDrawSetPreviewModel(playerid, MODELITEM[playerid], 13562);
			PlayerTextDrawShow(playerid, ITEMSBOX[0][playerid]);
			PlayerTextDrawShow(playerid, ITEMSBOX[1][playerid]);
			PlayerTextDrawShow(playerid, Received[playerid]);
			PlayerTextDrawShow(playerid, ITEMSNAME[playerid]);
			PlayerTextDrawShow(playerid, MODELITEM[playerid]);
			PlayerTextDrawSetString(playerid, Loading[2][playerid], "UseSprunk");
			for(new i =0 ; i < 3; i++)
			{
				PlayerTextDrawShow(playerid, Loading[i][playerid]);
			}
			SetTimerEx("ItemsBoxtimer", 5500, false, "i", playerid);
			pData[playerid][pActivity] = SetTimerEx("LoadingSprunk", 500, true, "i", playerid);
			ApplyAnimation(playerid, "BAR", "dnk_stndM_loop", 4.1, 0, 1, 1, 1, 1, 1);
		}
		else if(strcmp(params,"nugget",true) == 0)
		{
			if(pData[playerid][pNugget] < 1)
				return Error(playerid, "Anda tidak memiliki Nugget.");

			pData[playerid][pNugget]--;
			pData[playerid][pHunger] += 30;
			pData[playerid][pTrash] += 1;
			Info(playerid, "Anda telah berhasil memakan Nugget dan terdapat sampah pada inventory.");
			InfoTD_MSG(playerid, 3000, "Restore +30 Hunger");
			ApplyAnimation(playerid,"SMOKING","M_smkstnd_loop",2.1,0,0,0,0,0);
		}
		else if(strcmp(params,"burger",true) == 0)
		{
			if(pData[playerid][pBurger] < 1)
				return Error(playerid, "Anda tidak memiliki Burger.");

			pData[playerid][pBurger]--;
			pData[playerid][pHunger] += 32;
			pData[playerid][pTrash] += 1;
			Info(playerid, "Anda telah berhasil memakan Burger dan terdapat sampah pada inventory.");
			InfoTD_MSG(playerid, 3000, "Restore +32 Hunger");
			ApplyAnimation(playerid,"SMOKING","M_smkstnd_loop",2.1,0,0,0,0,0);
		}
		else if(strcmp(params,"teh",true) == 0)
		{
			if(pData[playerid][pTeh] < 1)
				return Error(playerid, "Anda tidak memiliki Teh.");

			pData[playerid][pTeh]--;
			pData[playerid][pEnergy] += 30;
			pData[playerid][pTrash] += 1;
			Info(playerid, "Anda telah berhasil meminum Teh dan terdapat sampah pada inventory.");
			InfoTD_MSG(playerid, 3000, "Restore +35 Energy");
			ApplyAnimation(playerid,"SMOKING","M_smkstnd_loop",2.1,0,0,0,0,0);
		}
		/*else if(strcmp(params,"sprunk",true) == 0)
		{
			if(pData[playerid][pSprunk] < 1)
				return Error(playerid, "Anda tidak memiliki snack.");

			SetPlayerSpecialAction(playerid,SPECIAL_ACTION_DRINK_SPRUNK);
			//SendNearbyMessage(playerid, 10.0, COLOR_PURPLE,"* %s opens a can of sprunk.", ReturnName(playerid));
			SetPVarInt(playerid, "UsingSprunk", 1);
			pData[playerid][pSprunk]--;
		}*/
		else if(strcmp(params,"gas",true) == 0)
		{
			if(pData[playerid][pGas] < 1)
				return Error(playerid, "Anda tidak memiliki gas.");

			if(IsPlayerInAnyVehicle(playerid))
				return Error(playerid, "Anda harus berada diluar kendaraan!");

			if(pData[playerid][pActivityTime] > 5) return Error(playerid, "Anda masih memiliki activity progress!");

			new vehicleid = GetNearestVehicleToPlayer(playerid, 3.5, false);
			if(IsValidVehicle(vehicleid))
			{
				new fuel = GetVehicleFuel(vehicleid);

				if(GetEngineStatus(vehicleid))
					return Error(playerid, "Turn off vehicle engine.");

				if(fuel >= 999.0)
					return Error(playerid, "This vehicle gas is full.");

				if(!IsEngineVehicle(vehicleid))
					return Error(playerid, "This vehicle can't be refull.");

				if(!GetHoodStatus(vehicleid))
					return Error(playerid, "The hood must be opened before refull the vehicle.");

				pData[playerid][pGas]--;
				Info(playerid, "Don't move from your position or you will failed to refulling this vehicle.");
				ApplyAnimation(playerid, "BD_FIRE", "wash_up", 4.1, 0, 0, 0, 0, 0, 1);
				pData[playerid][pActivity] = SetTimerEx("RefullCar", 1000, true, "id", playerid, vehicleid);
				PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Refulling...");
				PlayerTextDrawShow(playerid, ActiveTD[playerid]);
				ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
				/*InfoTD_MSG(playerid, 10000, "Refulling...");
				//SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s starts to refulling the vehicle.", ReturnName(playerid));*/
				return 1;
			}
		}
		else if(strcmp(params,"painkiller",true) == 0)
		{
			if(pData[playerid][pMedicine] < 1)
				return Error(playerid, "Anda tidak memiliki painkiller.");

			pData[playerid][pMedicine]--;
			pData[playerid][pSick] = 0;
			pData[playerid][pSickTime] = 0;
			SetPlayerDrunkLevel(playerid, 0);
			Info(playerid, "Anda menggunakan painkiller.");

			//InfoTD_MSG(playerid, 3000, "Restore +15 Hunger");
			ApplyAnimation(playerid,LIBRARY,ANIMATION,4.1,false,false,false,false,3000,false);
		}
		else if(strcmp(params,"marijuana",true) == 0)
		{
			if(pData[playerid][pMarijuana] < 1)
				return Error(playerid, "You dont have marijuana.");

			new Float:armor;
			GetPlayerArmour(playerid, armor);
			if(armor+10 > 90) return Error(playerid, "Over dosis!");

			pData[playerid][pMarijuana]--;
			SetPlayerArmourEx(playerid, armor+10);
			SetPlayerDrunkLevel(playerid, 4000);
			ApplyAnimation(playerid,"SMOKING","M_smkstnd_loop",2.1,0,0,0,0,0);
		}
		else if(strcmp(params,"boombox",true) == 0)
		{
			if(pData[playerid][pBoombox] < 1)
				return Error(playerid, "You dont have boombox");

			new string[128], Float:BBCoord[4], pNames[MAX_PLAYER_NAME];
		    GetPlayerPos(playerid, BBCoord[0], BBCoord[1], BBCoord[2]);
		    GetPlayerFacingAngle(playerid, BBCoord[3]);
		    SetPVarFloat(playerid, "BBX", BBCoord[0]);
		    SetPVarFloat(playerid, "BBY", BBCoord[1]);
		    SetPVarFloat(playerid, "BBZ", BBCoord[2]);
		    GetPlayerName(playerid, pNames, sizeof(pNames));
		    BBCoord[0] += (2 * floatsin(-BBCoord[3], degrees));
		   	BBCoord[1] += (2 * floatcos(-BBCoord[3], degrees));
		   	BBCoord[2] -= 1.0;
			if(GetPVarInt(playerid, "PlacedBB")) return SCM(playerid, -1, "Kamu Sudah Memasang Boombox");
			foreach(new i : Player)
			{
		 		if(GetPVarType(i, "PlacedBB"))
		   		{
		  			if(IsPlayerInRangeOfPoint(playerid, 30.0, GetPVarFloat(i, "BBX"), GetPVarFloat(i, "BBY"), GetPVarFloat(i, "BBZ")))
					{
		   				SendClientMessage(playerid, COLOR_PINK, "Kamu Tidak Dapat Memasang Boombox Disini, Karena Orang Sudah Lain Sudah Memasang Boombox Disini");
					    return 1;
					}
				}
			}
			new string2[128];
			format(string2, sizeof(string2), "%s Telah Memasang Boombox!", pNames);
			SendNearbyMessage(playerid, 15, COLOR_PURPLE, string2);
			SetPVarInt(playerid, "PlacedBB", CreateDynamicObject(2102, BBCoord[0], BBCoord[1], BBCoord[2], 0.0, 0.0, 0.0, .worldid = GetPlayerVirtualWorld(playerid), .interiorid = GetPlayerInterior(playerid)));
			format(string, sizeof(string), "Creator "WHITE_E"%s\n["LBLUE"/bbhelp for info"WHITE_E"]", pNames);
			SetPVarInt(playerid, "BBLabel", _:CreateDynamic3DTextLabel(string, COLOR_YELLOW, BBCoord[0], BBCoord[1], BBCoord[2]+0.6, 5, .worldid = GetPlayerVirtualWorld(playerid), .interiorid = GetPlayerInterior(playerid)));
			SetPVarInt(playerid, "BBArea", CreateDynamicSphere(BBCoord[0], BBCoord[1], BBCoord[2], 30.0, GetPlayerVirtualWorld(playerid), GetPlayerInterior(playerid)));
			SetPVarInt(playerid, "BBInt", GetPlayerInterior(playerid));
			SetPVarInt(playerid, "BBVW", GetPlayerVirtualWorld(playerid));
			ApplyAnimation(playerid,"BOMBER","BOM_Plant",4.0,0,0,0,0,0);
		    ApplyAnimation(playerid,"BOMBER","BOM_Plant",4.0,0,0,0,0,0);
		}
        else if(strcmp(params,"berry",true) == 0)
		{
			if(pData[playerid][pBerry] < 0)
				return Error(playerid, "You dont have berry.");

			pData[playerid][pHunger] += 8;
			pData[playerid][pBerry]--;
			ApplyAnimation(playerid,"SMOKING","M_smkstnd_loop",2.1,0,0,0,0,0);
		}
	}
	return 1;
}

CMD:usemedicine(playerid, params[])
{
  	ShowPlayerDialog(playerid, DIALOG_MEDICINE, DIALOG_STYLE_LIST, "Medicine","Paracetamol\nAmoxicillin\nAntasida","Use","Cancel");
  	return 1;
}

CMD:bbhelp(playerid, params[])
{
	Usage(playerid, "/use boombox /setbb /pickupbb");
	return 1;
}

CMD:setbb(playerid, params[])
{
    if(pData[playerid][pBoombox] == 0)
	    return SendClientMessage(playerid, 0xCECECEFF, "you dont have boombox");

	if(GetPVarType(playerid, "PlacedBB"))
	{
		if(IsPlayerInRangeOfPoint(playerid, 3.0, GetPVarFloat(playerid, "BBX"), GetPVarFloat(playerid, "BBY"), GetPVarFloat(playerid, "BBZ")))
		{
			ShowPlayerDialog(playerid,DIALOG_BOOMBOX,DIALOG_STYLE_LIST,"Boombox","Turn Off Boombox\nInput URL","Select", "Cancel");
		}
		else
		{
   			return SendClientMessage(playerid, -1, "You're not near from your boombox");
		}
    }
    else
    {
        SendClientMessage(playerid, -1, "you didnt place boombox before");
	}
	return 1;
}

CMD:pickupbb(playerid, params [])
{
    if(pData[playerid][pBoombox] == 0)
	    return SendClientMessage(playerid, 0xCECECEFF, "you dont have boombox");

	if(!GetPVarInt(playerid, "PlacedBB"))
    {
        SendClientMessage(playerid, -1, "you dont have placedboombox to take");
    }
	if(IsPlayerInRangeOfPoint(playerid, 3.0, GetPVarFloat(playerid, "BBX"), GetPVarFloat(playerid, "BBY"), GetPVarFloat(playerid, "BBZ")))
    {
        PickUpBoombox(playerid);
        SendClientMessage(playerid, -1, "boombox pickup");
    }
    return 1;
}
stock StopStream(playerid)
{
	DeletePVar(playerid, "pAudioStream");
    StopAudioStreamForPlayer(playerid);
}

stock PlayStream(playerid, url[], Float:posX = 0.0, Float:posY = 0.0, Float:posZ = 0.0, Float:distance = 50.0, usepos = 0)
{
	if(GetPVarType(playerid, "pAudioStream")) StopAudioStreamForPlayer(playerid);
	else SetPVarInt(playerid, "pAudioStream", 1);
    PlayAudioStreamForPlayer(playerid, url, posX, posY, posZ, distance, usepos);
}

stock PickUpBoombox(playerid)
{
    foreach(new i : Player)
	{
 		if(IsPlayerInDynamicArea(i, GetPVarInt(playerid, "BBArea")))
   		{
     		StopStream(i);
		}
	}
	DeletePVar(playerid, "BBArea");
	DestroyDynamicObject(GetPVarInt(playerid, "PlacedBB"));
	DestroyDynamic3DTextLabel(Text3D:GetPVarInt(playerid, "BBLabel"));
	DeletePVar(playerid, "PlacedBB"); DeletePVar(playerid, "BBLabel");
 	DeletePVar(playerid, "BBX"); DeletePVar(playerid, "BBY"); DeletePVar(playerid, "BBZ");
	DeletePVar(playerid, "BBInt");
	DeletePVar(playerid, "BBVW");
	DeletePVar(playerid, "BBStation");
	return 1;
}

CMD:drop(playerid, params[])
{
	if(IsPlayerConnected(playerid))
	{
        if(isnull(params))
		{
            Usage(playerid, "/drop [name]");
            Info(playerid, "Names: bandage, snack, sprunk, gas, painkiller, marijuana");
            return 1;
        }
		if(strcmp(params,"bandage",true) == 0)
		{
			if(pData[playerid][pBandage] < 1)
				return Error(playerid, "Anda tidak memiliki perban.");

			pData[playerid][pBandage] = 0;
			Info(playerid, "Anda telah berhasil membuang bandage");
		}
		else if(strcmp(params,"snack",true) == 0)
		{
			if(pData[playerid][pSnack] < 1)
				return Error(playerid, "Anda tidak memiliki snack.");

			pData[playerid][pSnack] = 0;
			Info(playerid, "Anda telah berhasil membuang Snack");
		}
		else if(strcmp(params,"sprunk",true) == 0)
		{
			if(pData[playerid][pSprunk] < 1)
				return Error(playerid, "Anda tidak memiliki sprunk.");

			pData[playerid][pSprunk] = 0;
			Info(playerid, "Anda telah berhasil membuang sprunk");
		}
		else if(strcmp(params,"sprunk",true) == 0)
		{
			if(pData[playerid][pSprunk] < 1)
				return Error(playerid, "Anda tidak memiliki snack.");

			pData[playerid][pSprunk] = 0;
			Info(playerid, "Anda telah berhasil membuang snack");
		}
		else if(strcmp(params,"gas",true) == 0)
		{
			if(pData[playerid][pGas] < 1)
				return Error(playerid, "Anda tidak memiliki gas.");

			pData[playerid][pGas] = 0;
			Info(playerid, "Anda telah berhasil membuang gas");
		}
		else if(strcmp(params,"painkiller",true) == 0)
		{
			if(pData[playerid][pMedicine] < 1)
				return Error(playerid, "Anda tidak memiliki painkiller.");

			pData[playerid][pMedicine] = 0;
			Info(playerid, "Anda telah berhasil membuang painkiller");
		}
		else if(strcmp(params,"marijuana",true) == 0)
		{
			if(pData[playerid][pMarijuana] < 1)
				return Error(playerid, "You dont have marijuana.");

			pData[playerid][pMarijuana] = 0;
			Info(playerid, "Anda telah berhasil membuang marijuana");
		}
	}
	return 1;
}

CMD:enter(playerid, params[])
{
	if(pData[playerid][pInjured] == 0)
    {
		foreach(new did : Doors)
		{
			if(IsPlayerInRangeOfPoint(playerid, 2.8, dData[did][dExtposX], dData[did][dExtposY], dData[did][dExtposZ]))
			{
				if(dData[did][dGarage] == 1 && GetPlayerState(playerid) == PLAYER_STATE_DRIVER && IsPlayerInAnyVehicle(playerid))
				{
					if(dData[did][dIntposX] == 0.0 && dData[did][dIntposY] == 0.0 && dData[did][dIntposZ] == 0.0)
						return Error(playerid, "Interior entrance masih kosong, atau tidak memiliki interior.");

					if(dData[did][dLocked])
						return Error(playerid, "This entrance is locked at the moment.");

					if(dData[did][dFaction] > 0)
					{
						if(dData[did][dFaction] != pData[playerid][pFaction])
							return Error(playerid, "This door only for faction.");
					}
					if(dData[did][dFamily] > 0)
					{
						if(dData[did][dFamily] != pData[playerid][pFamily])
							return Error(playerid, "This door only for family.");
					}

					if(dData[did][dVip] > pData[playerid][pVip])
						return Error(playerid, "Your VIP level not enough to enter this door.");

					if(dData[did][dAdmin] > pData[playerid][pAdmin])
						return Error(playerid, "Your admin level not enough to enter this door.");

					if(strlen(dData[did][dPass]))
					{
						if(sscanf(params, "s[256]", params)) return Usage(playerid, "/enter [password]");
						if(strcmp(params, dData[did][dPass])) return Error(playerid, "Invalid door password.");

						if(dData[did][dCustom])
						{
							SetVehiclePositionEx(playerid, GetPlayerVehicleID(playerid), dData[did][dIntposX], dData[did][dIntposY], dData[did][dIntposZ], dData[did][dIntposA]);
						}
						else
						{
							SetVehiclePosition(playerid, GetPlayerVehicleID(playerid), dData[did][dIntposX], dData[did][dIntposY], dData[did][dIntposZ], dData[did][dIntposA]);
						}
						pData[playerid][pInDoor] = did;
						SetPlayerInterior(playerid, dData[did][dIntint]);
						SetPlayerVirtualWorld(playerid, dData[did][dIntvw]);
						SetCameraBehindPlayer(playerid);
						SetPlayerWeather(playerid, 0);
					}
					else
					{
						if(dData[did][dCustom])
						{
							SetVehiclePositionEx(playerid, GetPlayerVehicleID(playerid), dData[did][dIntposX], dData[did][dIntposY], dData[did][dIntposZ], dData[did][dIntposA]);
						}
						else
						{
							SetVehiclePosition(playerid, GetPlayerVehicleID(playerid), dData[did][dIntposX], dData[did][dIntposY], dData[did][dIntposZ], dData[did][dIntposA]);
						}
						pData[playerid][pInDoor] = did;
						SetPlayerInterior(playerid, dData[did][dIntint]);
						SetPlayerVirtualWorld(playerid, dData[did][dIntvw]);
						SetCameraBehindPlayer(playerid);
						SetPlayerWeather(playerid, 0);
					}
				}
				else
				{
					if(dData[did][dIntposX] == 0.0 && dData[did][dIntposY] == 0.0 && dData[did][dIntposZ] == 0.0)
						return Error(playerid, "Interior entrance masih kosong, atau tidak memiliki interior.");

					if(dData[did][dLocked])
						return Error(playerid, "This entrance is locked at the moment.");

					if(dData[did][dFaction] > 0)
					{
						if(dData[did][dFaction] != pData[playerid][pFaction])
							return Error(playerid, "This door only for faction.");
					}
					if(dData[did][dFamily] > 0)
					{
						if(dData[did][dFamily] != pData[playerid][pFamily])
							return Error(playerid, "This door only for family.");
					}

					if(dData[did][dVip] > pData[playerid][pVip])
						return Error(playerid, "Your VIP level not enough to enter this door.");

					if(dData[did][dAdmin] > pData[playerid][pAdmin])
						return Error(playerid, "Your admin level not enough to enter this door.");

					if(strlen(dData[did][dPass]))
					{
						if(sscanf(params, "s[256]", params)) return Usage(playerid, "/enter [password]");
						if(strcmp(params, dData[did][dPass])) return Error(playerid, "Invalid door password.");

						if(dData[did][dCustom])
						{
							SetPlayerPositionEx(playerid, dData[did][dIntposX], dData[did][dIntposY], dData[did][dIntposZ], dData[did][dIntposA]);
						}
						else
						{
							SetPlayerPositionEx(playerid, dData[did][dIntposX], dData[did][dIntposY], dData[did][dIntposZ], dData[did][dIntposA]);
						}
						pData[playerid][pInDoor] = did;
						SetPlayerInterior(playerid, dData[did][dIntint]);
						SetPlayerVirtualWorld(playerid, dData[did][dIntvw]);
						SetCameraBehindPlayer(playerid);
						SetPlayerWeather(playerid, 0);
					}
					else
					{
						if(dData[did][dCustom])
						{
							SetPlayerPositionEx(playerid, dData[did][dIntposX], dData[did][dIntposY], dData[did][dIntposZ], dData[did][dIntposA]);
						}
						else
						{
							SetPlayerPositionEx(playerid, dData[did][dIntposX], dData[did][dIntposY], dData[did][dIntposZ], dData[did][dIntposA]);
						}
						pData[playerid][pInDoor] = did;
						SetPlayerInterior(playerid, dData[did][dIntint]);
						SetPlayerVirtualWorld(playerid, dData[did][dIntvw]);
						SetCameraBehindPlayer(playerid);
						SetPlayerWeather(playerid, 0);
					}
				}
			}
			if(IsPlayerInRangeOfPoint(playerid, 2.8, dData[did][dIntposX], dData[did][dIntposY], dData[did][dIntposZ]))
			{
				if(dData[did][dGarage] == 1 && GetPlayerState(playerid) == PLAYER_STATE_DRIVER && IsPlayerInAnyVehicle(playerid))
				{
					if(dData[did][dFaction] > 0)
					{
						if(dData[did][dFaction] != pData[playerid][pFaction])
							return Error(playerid, "This door only for faction.");
					}

					if(dData[did][dCustom])
					{
						SetVehiclePositionEx(playerid, GetPlayerVehicleID(playerid), dData[did][dExtposX], dData[did][dExtposY], dData[did][dExtposZ], dData[did][dExtposA]);
					}
					else
					{
						SetVehiclePosition(playerid, GetPlayerVehicleID(playerid), dData[did][dExtposX], dData[did][dExtposY], dData[did][dExtposZ], dData[did][dExtposA]);
					}
					pData[playerid][pInDoor] = -1;
					SetPlayerInterior(playerid, dData[did][dExtint]);
					SetPlayerVirtualWorld(playerid, dData[did][dExtvw]);
					SetCameraBehindPlayer(playerid);
					SetPlayerWeather(playerid, WorldWeather);
				}
				else
				{
					if(dData[did][dFaction] > 0)
					{
						if(dData[did][dFaction] != pData[playerid][pFaction])
							return Error(playerid, "This door only for faction.");
					}

					if(dData[did][dCustom])
						SetPlayerPositionEx(playerid, dData[did][dExtposX], dData[did][dExtposY], dData[did][dExtposZ], dData[did][dExtposA]);

					else
						SetPlayerPositionEx(playerid, dData[did][dExtposX], dData[did][dExtposY], dData[did][dExtposZ], dData[did][dExtposA]);

					pData[playerid][pInDoor] = -1;
					SetPlayerInterior(playerid, dData[did][dExtint]);
					SetPlayerVirtualWorld(playerid, dData[did][dExtvw]);
					SetCameraBehindPlayer(playerid);
					SetPlayerWeather(playerid, 0);
				}
			}
        }
		//Houses
		foreach(new hid : Houses)
		{
			if(IsPlayerInRangeOfPoint(playerid, 2.5, hData[hid][hExtposX], hData[hid][hExtposY], hData[hid][hExtposZ]))
			{
				if(hData[hid][hIntposX] == 0.0 && hData[hid][hIntposY] == 0.0 && hData[hid][hIntposZ] == 0.0)
					return Error(playerid, "Interior house masih kosong, atau tidak memiliki interior.");

				if(hData[hid][hLocked])
					return Error(playerid, "This house is locked!");

				pData[playerid][pInHouse] = hid;
				SetPlayerPositionEx(playerid, hData[hid][hIntposX], hData[hid][hIntposY], hData[hid][hIntposZ], hData[hid][hIntposA]);

				SetPlayerInterior(playerid, hData[hid][hInt]);
				SetPlayerVirtualWorld(playerid, hid);
				SetCameraBehindPlayer(playerid);
				SetPlayerWeather(playerid, 0);
			}
        }
		new inhouseid = pData[playerid][pInHouse];
		if(pData[playerid][pInHouse] != -1 && IsPlayerInRangeOfPoint(playerid, 2.8, hData[inhouseid][hIntposX], hData[inhouseid][hIntposY], hData[inhouseid][hIntposZ]))
		{
			SetPlayerPositionEx(playerid, hData[inhouseid][hExtposX], hData[inhouseid][hExtposY], hData[inhouseid][hExtposZ], hData[inhouseid][hExtposA]);

			pData[playerid][pInHouse] = -1;
			SetPlayerInterior(playerid, 0);
			SetPlayerVirtualWorld(playerid, 0);
			SetCameraBehindPlayer(playerid);
			SetPlayerWeather(playerid, WorldWeather);
		}
		//Flats
		foreach(new flid : Flats)
		{
			if(IsPlayerInRangeOfPoint(playerid, 2.5, flData[flid][flExtposX], flData[flid][flExtposY], flData[flid][flExtposZ]))
			{
				if(flData[flid][flExtposX] == 0.0 && flData[flid][flExtposY] == 0.0 && flData[flid][flExtposZ] == 0.0)
					return Error(playerid, "Interior flat masih kosong, atau tidak memiliki interior.");

				if(flData[flid][flLocked])
					return Error(playerid, "This flat is locked!");

				pData[playerid][pInFlat] = flid;
				SetPlayerPositionEx(playerid, flData[flid][flExtposX], flData[flid][flExtposY], flData[flid][flExtposZ], flData[flid][flExtposA]);

				SetPlayerInterior(playerid, flData[flid][flInt]);
				SetPlayerVirtualWorld(playerid, flid);
				SetCameraBehindPlayer(playerid);
				SetPlayerWeather(playerid, 0);
			}
        }
		new inflatid = pData[playerid][pInFlat];
		if(pData[playerid][pInFlat] != -1 && IsPlayerInRangeOfPoint(playerid, 2.8, flData[inflatid][flExtposX], flData[inflatid][flExtposY], flData[inflatid][flExtposZ]))
		{
			SetPlayerPositionEx(playerid, flData[inflatid][flExtposX], flData[inflatid][flExtposY], flData[inflatid][flExtposZ], flData[inflatid][flExtposA]);

			pData[playerid][pInFlat] = -1;
			SetPlayerInterior(playerid, 0);
			SetPlayerVirtualWorld(playerid, 0);
			SetCameraBehindPlayer(playerid);
			SetPlayerWeather(playerid, WorldWeather);
		}
		//Hotels
		foreach(new htid : Hotels)
		{
			if(IsPlayerInRangeOfPoint(playerid, 2.5, htData[htid][htExtposX], htData[htid][htExtposY], htData[htid][htExtposZ]))
			{
				if(htData[htid][htExtposX] == 0.0 && htData[htid][htExtposY] == 0.0 && htData[htid][htExtposZ] == 0.0)
					return Error(playerid, "Interior hotel masih kosong, atau tidak memiliki interior.");

				if(htData[htid][htLocked])
					return Error(playerid, "This hotel is locked!");

				pData[playerid][pInHotel] = htid;
				SetPlayerPositionEx(playerid, htData[htid][htExtposX], htData[htid][htExtposY], htData[htid][htExtposZ], htData[htid][htExtposA]);

				SetPlayerInterior(playerid, htData[htid][htInt]);
				SetPlayerVirtualWorld(playerid, htid);
				SetCameraBehindPlayer(playerid);
				SetPlayerWeather(playerid, 0);
			}
        }
		new inhotelid = pData[playerid][pInHotel];
		if(pData[playerid][pInHotel] != -1 && IsPlayerInRangeOfPoint(playerid, 2.8, htData[inhotelid][htExtposX], htData[inhotelid][htExtposY], htData[inhotelid][htExtposZ]))
		{
			SetPlayerPositionEx(playerid, htData[inhotelid][htExtposX], htData[inhotelid][htExtposY], htData[inhotelid][htExtposZ], htData[inhotelid][htExtposA]);

			pData[playerid][pInHotel] = -1;
			SetPlayerInterior(playerid, 0);
			SetPlayerVirtualWorld(playerid, 0);
			SetCameraBehindPlayer(playerid);
			SetPlayerWeather(playerid, WorldWeather);
		}
		//Bisnis
		foreach(new bid : Bisnis)
		{
			if(IsPlayerInRangeOfPoint(playerid, 2.8, bData[bid][bExtposX], bData[bid][bExtposY], bData[bid][bExtposZ]))
			{
				if(bData[bid][bIntposX] == 0.0 && bData[bid][bIntposY] == 0.0 && bData[bid][bIntposZ] == 0.0)
					return Error(playerid, "Interior bisnis masih kosong, atau tidak memiliki interior.");

				if(bData[bid][bLocked])
					return Error(playerid, "This bisnis is locked!");

				pData[playerid][pInBiz] = bid;
				SetPlayerPositionEx(playerid, bData[bid][bIntposX], bData[bid][bIntposY], bData[bid][bIntposZ], bData[bid][bIntposA]);

				PlayAudioStreamForPlayer(playerid, bData[bid][bSong], bData[bid][bIntposX], bData[bid][bIntposY], bData[bid][bIntposZ], 15.0, 1);
				SetPlayerInterior(playerid, bData[bid][bInt]);
				SetPlayerVirtualWorld(playerid, bid);
				SetCameraBehindPlayer(playerid);
				SetPlayerWeather(playerid, 0);
			}
        }
		new inbisnisid = pData[playerid][pInBiz];
		if(pData[playerid][pInBiz] != -1 && IsPlayerInRangeOfPoint(playerid, 2.8, bData[inbisnisid][bIntposX], bData[inbisnisid][bIntposY], bData[inbisnisid][bIntposZ]))
		{
			SetPlayerPositionEx(playerid, bData[inbisnisid][bExtposX], bData[inbisnisid][bExtposY], bData[inbisnisid][bExtposZ], bData[inbisnisid][bExtposA]);

			StopAudioStreamForPlayer(playerid);
			pData[playerid][pInBiz] = -1;
			SetPlayerInterior(playerid, 0);
			SetPlayerVirtualWorld(playerid, 0);
			SetCameraBehindPlayer(playerid);
			SetPlayerWeather(playerid, WorldWeather);
		}
		//Family
		foreach(new fid : FAMILYS)
		{
			if(IsPlayerInRangeOfPoint(playerid, 2.8, fData[fid][fExtposX], fData[fid][fExtposY], fData[fid][fExtposZ]))
			{
				if(fData[fid][fIntposX] == 0.0 && fData[fid][fIntposY] == 0.0 && fData[fid][fIntposZ] == 0.0)
					return Error(playerid, "Interior masih kosong, atau tidak memiliki interior.");

				if(pData[playerid][pFaction] == 0)
					if(pData[playerid][pFamily] == -1)
						return Error(playerid, "You dont have registered for this door!");

				SetPlayerPositionEx(playerid, fData[fid][fIntposX], fData[fid][fIntposY], fData[fid][fIntposZ], fData[fid][fIntposA]);

				SetPlayerInterior(playerid, fData[fid][fInt]);
				SetPlayerVirtualWorld(playerid, fid);
				SetCameraBehindPlayer(playerid);
				//pData[playerid][pInBiz] = fid;
				SetPlayerWeather(playerid, 0);
			}
			if(IsPlayerInRangeOfPoint(playerid, 2.8, fData[fid][fIntposX], fData[fid][fIntposY], fData[fid][fIntposZ]))
			{
				SetPlayerPositionEx(playerid, fData[fid][fExtposX], fData[fid][fExtposY], fData[fid][fExtposZ], fData[fid][fExtposA]);

				SetPlayerInterior(playerid, 0);
				SetPlayerVirtualWorld(playerid, 0);
				SetCameraBehindPlayer(playerid);
				SetPlayerWeather(playerid, WorldWeather);
				//pData[playerid][pInBiz] = -1;
			}
        }
	}
	return 1;
}
CMD:mytrain(playerid, params[])
{
  	new String[10000], S3MP4K[10000];
    if(pData[playerid][pFaction] != 0)
    {
		strcat(S3MP4K, "Name\tCurrent\tNext\n");
    	format(String, sizeof(String),"Silinced Pistol\tLevel %d\tLevel %d\nDesert Eagle\t$%s\tLevel %d\tLevel %d\n", pData[playerid][pSilincedSkill], pData[playerid][pSilincedSkill]+1, FormatMoney(pData[playerid][pDesertEagleSkill]+1*5000/2), pData[playerid][pDesertEagleSkill], pData[playerid][pDesertEagleSkill]+1);
     	strcat(S3MP4K, String);
      	format(String, sizeof(String),"Shotgun\tLevel %d\tLevel %d\nSpas-12\t$%s\tLevel %d\tLevel %d\n", pData[playerid][pShotgunSkill], pData[playerid][pShotgunSkill]+1, FormatMoney(pData[playerid][pSpassSkill]+1*7500/2), pData[playerid][pSpassSkill], pData[playerid][pSpassSkill]+1);
      	strcat(S3MP4K, String);
    	format(String, sizeof(String),"MP5\tLevel %d\tLevel %d\nAK47\t%s\tLevel %d\tLevel %d\n", pData[playerid][pMP5Skill], pData[playerid][pMP5Skill]+1, FormatMoney(pData[playerid][pAK47Skill]+1*12500/2), pData[playerid][pAK47Skill], pData[playerid][pAK47Skill]+1);
    	strcat(S3MP4K, String);
    	format(String, sizeof(String),"M4\tLevel %d\tLevel %d\nSniper Rifle\t%s\tLevel %d\tLevel %d", pData[playerid][pM4Skill], pData[playerid][pM4Skill]+1, FormatMoney(pData[playerid][pSniperSkill]+1*16500/2), pData[playerid][pSniperSkill], pData[playerid][pSniperSkill]+1);
        strcat(S3MP4K, String);
    }
    else
    {
        strcat(S3MP4K, "Name\tCurrent\tNext\n");
        format(String, sizeof(String),"Silinced Pistol\tLevel %d\tLevel %d\nDesert Eagle\t$%s\tLevel %d\tLevel %d\n", pData[playerid][pSilincedSkill], pData[playerid][pSilincedSkill]+1, FormatMoney(pData[playerid][pDesertEagleSkill]+1*5000), pData[playerid][pDesertEagleSkill], pData[playerid][pDesertEagleSkill]+1);
        strcat(S3MP4K, String);
        format(String, sizeof(String),"Shotgun\tLevel %d\tLevel %d\nSpas-12\t$%s\tLevel %d\tLevel %d\n", pData[playerid][pShotgunSkill], pData[playerid][pShotgunSkill]+1, FormatMoney(pData[playerid][pSpassSkill]+1*7500), pData[playerid][pSpassSkill], pData[playerid][pSpassSkill]+1);
        strcat(S3MP4K, String);
        format(String, sizeof(String),"MP5\tLevel %d\tLevel %d\nAK47\t%s\tLevel %d\tLevel %d\n", pData[playerid][pMP5Skill], pData[playerid][pMP5Skill]+1, FormatMoney(pData[playerid][pAK47Skill]+1*12500), pData[playerid][pAK47Skill], pData[playerid][pAK47Skill]+1);
        strcat(S3MP4K, String);
        format(String, sizeof(String),"M4\tLevel %d\tLevel %d\nSniper Rifle\t%s\tLevel %d\tLevel %d", pData[playerid][pM4Skill], pData[playerid][pM4Skill]+1, FormatMoney(pData[playerid][pSniperSkill]+1*16500), pData[playerid][pSniperSkill], pData[playerid][pSniperSkill]+1);
        strcat(S3MP4K, String);
    }		
    ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_TABLIST_HEADERS, "Weapon Training", S3MP4K, "Select", "Cancel");
  	return 1;
}
CMD:skills(playerid)
{
	SkillStatus(playerid);
	return 1;
}
CMD:putplayer(playerid, params[])
{
	new giveplayerid, seat;
	if(sscanf(params, "ud", giveplayerid, seat)) return Usage(playerid, "/putplayer [playerid] [seatid 1-3]");

	if(!IsPlayerInAnyVehicle(playerid))
		return Error(playerid, "You can't do this while you're in a vehicle.");

	if(seat < 1 || seat > 3)
		return Error(playerid, "The seat ID cannot be above 3 or below 1.");

	if(IsPlayerInAnyVehicle(giveplayerid))
		return Error(playerid, "That person is in a car - get them out first.");

	if(giveplayerid == INVALID_PLAYER_ID)
    	return Error(playerid, "That player is disconnected.");

    if(giveplayerid == playerid)
        return Error(playerid, "You cannot put yourself.");

    if(!NearPlayer(playerid, giveplayerid, 5.0))
        return Error(playerid, "You must be near this player.");

    if(!pData[giveplayerid][pInjured])
        return Error(playerid, "That person is not injured!.");

	new carid = GetPlayerVehicleID(playerid);
	new Float:pos[6];
	GetPlayerPos(playerid, pos[0], pos[1], pos[2]);
	GetPlayerPos(giveplayerid, pos[3], pos[4], pos[5]);
	GetVehiclePos( carid, pos[0], pos[1], pos[2]);
	if (floatcmp(floatabs(floatsub(pos[0], pos[3])), 10.0) != -1 &&
	floatcmp(floatabs(floatsub(pos[1], pos[4])), 10.0) != -1 &&
	floatcmp(floatabs(floatsub(pos[2], pos[5])), 10.0) != -1) return false;
	Info(giveplayerid, "You were put in vehicle by %s .", ReturnName(playerid));
	Info(playerid, "Put %s To Vehicle.", ReturnName(giveplayerid));

	ClearAnimations(giveplayerid);
	PutPlayerInVehicle(giveplayerid, carid, seat);

	return 1;
}
CMD:eject(playerid, params[])
{
	new giveplayerid;
	if(sscanf(params, "u", giveplayerid)) return Usage(playerid, "/eject [playerid]");

	new State;
	State = GetPlayerState(playerid);
	if(State != PLAYER_STATE_DRIVER)
		return Error(playerid, "You can only eject people as the driver!");

	if(giveplayerid == INVALID_PLAYER_ID)
    return Error(playerid, "That player is disconnected.");

    if(giveplayerid == playerid)
        return Error(playerid, "You cannot eject yourself.");

    if(!NearPlayer(playerid, giveplayerid, 5.0))
        return Error(playerid, "You must be near this player.");

	new vid;
	vid = GetPlayerVehicleID(playerid);

	if(IsPlayerInVehicle(giveplayerid, vid))
	{
		Servers(playerid, "You have thrown %s out of the car.", ReturnName(giveplayerid));
		Servers(giveplayerid, "You have been thrown out the car by %s.", ReturnName(playerid));

		RemovePlayerFromVehicle(giveplayerid);
		new Float:slx, Float:sly, Float:slz;
		GetPlayerPos(giveplayerid, slx, sly, slz);
		SetPlayerPos(giveplayerid, slx, sly, slz+1.2);
	}
	return 1;
}
CMD:drag(playerid, params[])
{
	new otherid;
    if(sscanf(params, "u", otherid))
        return Usage(playerid, "/drag [playerid/PartOfName] || /undrag [playerid]");

    if(otherid == INVALID_PLAYER_ID)
        return Error(playerid, "That player is disconnected.");

    if(otherid == playerid)
        return Error(playerid, "You cannot drag yourself.");

    if(!NearPlayer(playerid, otherid, 5.0))
        return Error(playerid, "You must be near this player.");

    if(!pData[otherid][pInjured])
        return Error(playerid, "kamu tidak bisa drag orang yang tidak mati.");

    SetPVarInt(otherid, "DragBy", playerid);
    Info(otherid, "%s Telah menawari drag kepada anda, /accept drag untuk menerimanya /deny drag untuk membatalkannya.", ReturnName(playerid));
	Info(playerid, "Anda berhasil menawari drag kepada player %s", ReturnName(otherid));
    return 1;
}

CMD:undrag(playerid, params[])
{
	new otherid;
    if(sscanf(params, "u", otherid)) return Usage(playerid, "/undrag [playerid]");
	if(pData[otherid][pDragged])
    {
        DeletePVar(playerid, "DragBy");
        DeletePVar(otherid, "DragBy");
        pData[otherid][pDragged] = 0;
        pData[otherid][pDraggedBy] = INVALID_PLAYER_ID;

        KillTimer(pData[otherid][pDragTimer]);
        SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s releases %s from their grip.", ReturnName(playerid), ReturnName(otherid));
    }
    return 1;
}

CMD:masked(playerid)
{
	if(IsPlayerConnected(playerid))
    {
        if(pData[playerid][pAdmin] < 1)
        {
            SendClientMessage(playerid, COLOR_GREY, "** You're no authorized to use that command . ");
            return 1;
        }
    }
    new String[10000];
    SendClientMessage(playerid, COLOR_YELLOW, "Masked Users online:");
    for(new i = 0; i < MAX_PLAYERS; i++)
    {
	    if(IsPlayerConnected(i))
        {
            if(pData[i][pMaskOn] == 1)
            {
                format(String, sizeof(String), "%s[%d] - Mask_%d", pData[i][pName], i, pData[i][pMaskID]);
            	SendClientMessageEx(playerid, COLOR_GREYJG, String);
            }
        }
    }
    return 1;
}

CMD:tweet(playerid, params[])
{
    if(GetPVarInt(playerid, "maketw") > gettime())
        return Error(playerid, "Mohon Tunggu 120 Detik Untuk Menggunakan kembali (Don't Spam).");


	if(!pData[playerid][pTweet]) return Error(playerid, "Anda tidak mempunyai akun twitter");
    if(!strcmp(pData[playerid][pTname], "None"))
		return Error(playerid, "Kamu Harus set nama untuk nama akun Twitter mu.");
    if(pData[playerid][pPhoneCredit] <= 0) return Error(playerid, "You dont have phone credits!");

	if(!strlen(params)) return Usage(playerid, "/tweet [teks]");

	new string[300];
	format(string, sizeof(string), "[TWITTER] @%s: %s ", pData[playerid][pTname], params);
	SendTweetMessage(0x00BFFFFF, string);
	format(string, sizeof string, "```\n[TWITTER] @%s: %s ```", pData[playerid][pTname], params);
	pData[playerid][pPhoneCredit] -= 1;
    DCC_SendChannelMessage(g_discord_twt, string);

	SetPVarInt(playerid, "maketw", gettime() + 60);
	return 1;
}
CMD:serverstats(playerid, params[])
{
  	new String[10000];
    format(String,sizeof(String),"Server Statistics - Version %s.",TEXT_GAMEMODE);
    SendClientMessageEx(playerid, COLOR_PINK, String);
    format(String, sizeof(String), "* Objects: %d | Pickups: %d | Map icons: %d | 3D text labels: %d | Loaded houses: %d",CountDynamicObjects(),CountDynamicPickups(),CountDynamicMapIcons(),CountDynamic3DTextLabels(),MAX_HOUSES);
    SendClientMessageEx(playerid, COLOR_GREYJG, String);
    format(String, sizeof(String), "* Logins: %d | Connections: %d | Registrations: %d | Hackers autobanned: %d | Uptime: %d hours",TotalLogin, TotalConnect, TotalRegister, TotalAutoBan, up_hours);
	SendClientMessageEx(playerid, COLOR_GREYJG, String);
	format(String, sizeof(String), "* Players connected: %d | Peak players recorded: 85",online);
	SendClientMessageEx(playerid, COLOR_GREYJG, String);
  	return 1;
}
CMD:twlist(playerid)
{
	new mstr[4000];
	mstr = "Player Name\tTweet Name\n";
	foreach (new i : Player)
	{
		if(pData[i][pTweet] == 1)
		{
			format(mstr, sizeof(mstr), "%s%s[%d]\t"YELLOW_E"%s\n", mstr, pData[i][pName], i, pData[i][pTname]);
			ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_TABLIST_HEADERS, "List Tweet Account", mstr, "Close","");
		}
	}
}/*
CMD:twban(playerid, params[])
{
	new otherid, tmp[120];
	if(pData[playerid][pAdmin] < 3)
		return PermissionError(playerid);

	if(sscanf(params, "us[120]", otherid, tmp))
    	return Usage(playerid, "/twban [playerid/PartOfName]");

    pData[otherid][pTBan] = 1;
    pData[otherid][pTBantime] = gettime() + (1 * 3600);
    Info(playerid, "Akun tweet kamu telah di ban, dengan alasan %s", tmp);
    return 1;
}*/

CMD:mask(playerid, params[])
{
	if(pData[playerid][pMask] <= 0)
		return Error(playerid, "You don't have a mask.");

	switch (pData[playerid][pMaskOn])
    {
        case 0:
        {
        	SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "* Mask_#%d takes out a mask and puts it on.", pData[playerid][pMaskID]);
		    pData[playerid][pMaskOn] = 1;
			new string[300], Float:healthh, Float:armourr;
			GetPlayerHealth(playerid, healthh), GetPlayerArmour(playerid, armourr);
			if(armourr == 0)
			{
				format(string, sizeof(string), "Mask_#%d\nH:["RED_E"%.1f"WHITE_E"]", pData[playerid][pMaskID], healthh);
				pData[playerid][pMaskLabel] = CreateDynamic3DTextLabel(string, -1, 0, 0, -10, 15.0, playerid);
				Streamer_SetFloatData(STREAMER_TYPE_3D_TEXT_LABEL, pData[playerid][pMaskLabel] , E_STREAMER_ATTACH_OFFSET_Z, 0.30);
				Attach3DTextLabelToPlayer(pData[playerid][pMaskLabel], playerid, 0, 0, 0.39);
					//ShowPlayerNameTagForPlayer(i, playerid, false);
				for(new ii = GetPlayerPoolSize(); ii != -1; --ii)
				{
					ShowPlayerNameTagForPlayer(ii, playerid, false);
				}
			}
			else if(armourr > 0)
			{
				format(string, sizeof(string), "Mask_#%d\nH:["RED_E"%.1f"WHITE_E"] A:["RED_E"%.1f"WHITE_E"]", pData[playerid][pMaskID], healthh, armourr);
				pData[playerid][pMaskLabel] = CreateDynamic3DTextLabel(string, -1, 0, 0, -10, 10.0, playerid);
				Streamer_SetFloatData(STREAMER_TYPE_3D_TEXT_LABEL, pData[playerid][pMaskLabel] , E_STREAMER_ATTACH_OFFSET_Z, 0.30);
				Attach3DTextLabelToPlayer(pData[playerid][pMaskLabel], playerid, 0, 0, 0.39);
					//ShowPlayerNameTagForPlayer(i, playerid, false);
				for(new ii = GetPlayerPoolSize(); ii != -1; --ii)
				{
					ShowPlayerNameTagForPlayer(ii, playerid, true);
				}
			}
			//SetPlayerAttachedObject(playerid, 9, 18911, 2,0.078534, 0.041857, -0.001727, 268.970458, 1.533374, 269.223754);
        }
        case 1:
        {
        	DestroyDynamic3DTextLabel(pData[playerid][pMaskLabel]);
            pData[playerid][pMaskOn] = 0;
            SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "* %s takes their mask off and puts it away.", ReturnName(playerid));
			for(new i = GetPlayerPoolSize(); i != -1; --i)
			{
				ShowPlayerNameTagForPlayer(i, playerid, 1);
			}
			//RemovePlayerAttachedObject(playerid, 9);
        }
    }
	return 1;
}

CMD:dice(playerid, params[])
{
	new Float:pPos[3];

	new dice = 1 + random(30);

	if(dice > 30 ) return dice = 30;

	GetPlayerPos(playerid, pPos[0], pPos[1], pPos[2]);

	foreach(new i : Player)
	{
	    if(IsPlayerInRangeOfPoint(i, 8.0, pPos[0], pPos[1], pPos[2]))
	    {
	        SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s rolls a dice which lands on the number %d.", ReturnName(playerid), dice);
	    }
	}

	return 1;
}

//Text and Chat Commands
CMD:try(playerid, params[])
{

    if(isnull(params))
        return Usage(playerid, "/try [action]");

	if(GetPVarType(playerid, "Caps")) UpperToLower(params);
    if(strlen(params) > 64)
	{
        SendNearbyMessage(playerid, 20.0, COLOR_PURPLE, "* %s %.64s ..", ReturnName(playerid), params);
        SendNearbyMessage(playerid, 20.0, COLOR_PURPLE, ".. %s, %s", params[64], (random(2) == 0) ? ("and success") : ("but fail"));
    }
    else {
        SendNearbyMessage(playerid, 20.0, COLOR_PURPLE, "* %s %s, %s", ReturnName(playerid), params, (random(2) == 0) ? ("and success") : ("but fail"));
    }
	printf("[TRY] %s(%d) : %s", pData[playerid][pName], playerid, params);
    return 1;
}

CMD:ado(playerid, params[])
{
    new flyingtext[164], Float:x, Float:y, Float:z;

    if(isnull(params))
	{
        Usage(playerid, "/ado [text]");
		Info(playerid, "Use /ado off to disable or delete the ado tag.");
		return 1;
	}
    if(strlen(params) > 128)
        return Error(playerid, "Max text can only maximmum 128 characters.");

    if (!strcmp(params, "off", true))
    {
        if (!pData[playerid][pAdoActive])
            return Error(playerid, "You're not actived your 'ado' text.");

        if (IsValidDynamic3DTextLabel(pData[playerid][pAdoTag]))
            DestroyDynamic3DTextLabel(pData[playerid][pAdoTag]);

        Servers(playerid, "You're removed your ado text.");
        pData[playerid][pAdoActive] = false;
        return 1;
    }

    FixText(params);
    format(flyingtext, sizeof(flyingtext), "* %s *\n(( %s ))", params, ReturnName(playerid));

	if(GetPVarType(playerid, "Caps")) UpperToLower(params);
    if(strlen(params) > 64)
	{
        SendNearbyMessage(playerid, 20.0, COLOR_PURPLE, "* [ADO]: %.64s ..", params);
        SendNearbyMessage(playerid, 20.0, COLOR_PURPLE, ".. %s", params[64]);
    }
    else
	{
        SendNearbyMessage(playerid, 20.0, COLOR_PURPLE, "* [ADO]: %s", params);
    }

    GetPlayerPos(playerid, x, y, z);
    if(pData[playerid][pAdoActive])
    {
    	if(IsPlayerInAnyVehicle(playerid))
  		{
      		if (IsValidDynamic3DTextLabel(pData[playerid][pAdoTag]))
            	DestroyDynamic3DTextLabel(pData[playerid][pAdoTag]);

    		new carid = GetPlayerVehicleID(playerid);
    		pData[playerid][pAdoTag] = CreateDynamic3DTextLabel(flyingtext, COLOR_PURPLE, x, y, 200, 20, INVALID_PLAYER_ID, carid);
  		}
  		else
  		{

        	if (IsValidDynamic3DTextLabel(pData[playerid][pAdoTag]))
            	UpdateDynamic3DTextLabelText(pData[playerid][pAdoTag], COLOR_PURPLE, flyingtext);
        	else
            	pData[playerid][pAdoTag] = CreateDynamic3DTextLabel(flyingtext, COLOR_PURPLE, x, y, z, 15, _, _, 1, GetPlayerVirtualWorld(playerid), GetPlayerInterior(playerid));
  		}
    }
    else
    {
    	if(IsPlayerInAnyVehicle(playerid))
  		{
      		if (IsValidDynamic3DTextLabel(pData[playerid][pAdoTag]))
            	DestroyDynamic3DTextLabel(pData[playerid][pAdoTag]);
        
    		new carid = GetPlayerVehicleID(playerid);
    		pData[playerid][pAdoActive] = true;
    		pData[playerid][pAdoTag] = CreateDynamic3DTextLabel(flyingtext, COLOR_PURPLE, x, y, 200, 20, INVALID_PLAYER_ID, carid);
  		}
  		else
    	{
	        pData[playerid][pAdoActive] = true;
	        pData[playerid][pAdoTag] = CreateDynamic3DTextLabel(flyingtext, COLOR_PURPLE, x, y, z, 15, _, _, 1, GetPlayerVirtualWorld(playerid), GetPlayerInterior(playerid));
		}
	}
	printf("[ADO] %s(%d) : %s", pData[playerid][pName], playerid, params);
    return 1;
}

CMD:ame(playerid, params[])
{
    new flyingtext[164];

    if(isnull(params))
        return Usage(playerid, "/ame [action]");

    if(strlen(params) > 128)
        return Error(playerid, "Max action can only maximmum 128 characters.");

	if(GetPVarType(playerid, "Caps")) UpperToLower(params);
    /*if(strlen(params) > 64)
	{
        SendNearbyMessage(playerid, 20.0, COLOR_PURPLE, "* [AME]: %.64s ..", params);
        SendNearbyMessage(playerid, 20.0, COLOR_PURPLE, ".. %s", params[64]);
    }
    else
	{
        SendNearbyMessage(playerid, 20.0, COLOR_PURPLE, "* [AME]: %s", params);
    }*/
    format(flyingtext, sizeof(flyingtext), "* %s %s*", ReturnName(playerid), params);
    SetPlayerChatBubble(playerid, flyingtext, COLOR_PURPLE, 10.0, 10000);
	printf("[AME] %s(%d) : %s", pData[playerid][pName], playerid, params);
    return 1;
}

CMD:me(playerid, params[])
{

    if(isnull(params))
        return Usage(playerid, "/me [action]");

	if(GetPVarType(playerid, "Caps")) UpperToLower(params);
    if(strlen(params) > 64)
	{
        SendNearbyMessage(playerid, 20.0, COLOR_PURPLEJG, "* %s %.64s ..", ReturnName(playerid), params);
        SendNearbyMessage(playerid, 20.0, COLOR_PURPLEJG, ".. %s", params[64]);
    }
    else
	{
        SendNearbyMessage(playerid, 20.0, COLOR_PURPLEJG, "* %s %s", ReturnName(playerid), params);
    }
	printf("[ME] %s(%d) : %s", pData[playerid][pName], playerid, params);
    return 1;
}

CMD:do(playerid, params[])
{
    if(isnull(params))
        return Usage(playerid, "/do [description]");

	if(GetPVarType(playerid, "Caps")) UpperToLower(params);
    if(strlen(params) > 64)
	{
        SendNearbyMessage(playerid, 20.0, COLOR_PURPLEJG, "* %.64s ..", params);
        SendNearbyMessage(playerid, 20.0, COLOR_PURPLEJG, ".. %s (( %s ))", params[64], ReturnName(playerid));
    }
    else
	{
        SendNearbyMessage(playerid, 20.0, COLOR_PURPLEJG, "* %s (( %s ))", params, ReturnName(playerid));
    }
	printf("[DO] %s(%d) : %s", pData[playerid][pName], playerid, params);
    return 1;
}

CMD:toglog(playerid)
{
	if(!pData[playerid][pTogLog])
	{
		pData[playerid][pTogLog] = 1;
		Info(playerid, "Anda telah menonaktifkan log server.");
	}
	else
	{
		pData[playerid][pTogLog] = 0;
		Info(playerid, "Anda telah mengaktifkan log server.");
	}
	return 1;
}

CMD:togdamage(playerid)
{
	if(!pData[playerid][pTogDamage])
	{
		pData[playerid][pTogDamage] = 1;
		Info(playerid, "Anda telah menonaktifkan log Damage.");
	}
	else
	{
		pData[playerid][pTogDamage] = 0;
		Info(playerid, "Anda telah mengaktifkan log Damage.");
	}
	return 1;
}
CMD:togpm(playerid)
{
	if(!pData[playerid][pTogPM])
	{
		pData[playerid][pTogPM] = 1;
		Info(playerid, "Anda telah menonaktifkan PM");
	}
	else
	{
		pData[playerid][pTogPM] = 0;
		Info(playerid, "Anda telah mengaktifkan PM");
	}
	return 1;
}

CMD:togads(playerid)
{
	if(!pData[playerid][pTogAds])
	{
		pData[playerid][pTogAds] = 1;
		Info(playerid, "Anda telah menonaktifkan Ads/Iklan.");
	}
	else
	{
		pData[playerid][pTogAds] = 0;
		Info(playerid, "Anda telah mengaktifkan Ads/Iklan.");
	}
	return 1;
}

CMD:togwt(playerid)
{
	if(!pData[playerid][pTogWT])
	{
		pData[playerid][pTogWT] = 1;
		Info(playerid, "Anda telah menonaktifkan Walkie Talkie.");
	}
	else
	{
		pData[playerid][pTogWT] = 0;
		Info(playerid, "Anda telah mengaktifkan Walkie Talkie.");
	}
	return 1;
}

CMD:pm(playerid, params[])
{
    static text[128], otherid;
    if(pData[playerid][pInjured] != 0)
		return Error(playerid, "You cant do that in this time.");

    if(sscanf(params, "us[128]", otherid, text))
        return Usage(playerid, "/pm [playerid/PartOfName] [message]");

    /*if(pData[playerid][pTogPM])
        return Error(playerid, "You must enable private messaging first.");*/

    /*if(pData[otherid][pAdminDuty])
        return Error(playerid, "You can't pm'ing admin duty now!");*/

	if(otherid == INVALID_PLAYER_ID)
        return Error(playerid, "You have specified an invalid player.");

    if(otherid == playerid)
        return Error(playerid, "You can't private message yourself.");

    if(pData[otherid][pTogPM] && pData[playerid][pAdmin] < 1)
        return Error(playerid, "That player has disabled private messaging.");

    GameTextForPlayer(otherid, "~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~y~New message!", 3000, 3);
    PlayerPlaySound(otherid, 1085, 0.0, 0.0, 0.0);

    SendClientMessageEx(otherid, COLOR_YELLOW, "(( PM from %s (%d): %s ))", pData[playerid][pName], playerid, text);
    SendClientMessageEx(playerid, COLOR_YELLOW, "(( PM to %s (%d): %s ))", pData[otherid][pName], otherid, text);
	Info(otherid, "/togpm for tog enable/disable PM");

    foreach(new i : Player) if((pData[i][pAdmin]) && pData[playerid][pSPY] > 0)
    {
        SendClientMessageEx(i, COLOR_LIGHTGREEN, "[SPY PM] %s (%d) to %s (%d): %s", pData[playerid][pName], playerid, pData[otherid][pName], otherid, text);
    }
    return 1;
}

CMD:whisper(playerid, params[])
{
	new text[128], otherid;
	
	if(pData[playerid][pInjured] != 0)
		return Error(playerid, "You cant do that in this time.");

    if(sscanf(params, "us[128]", otherid, text))
        return Usage(playerid, "/(w)hisper [playerid/PartOfName] [text]");

    if(otherid == INVALID_PLAYER_ID || !NearPlayer(playerid, otherid, 5.0))
        return Error(playerid, "That player is disconnected or not near you.");

    if(otherid == playerid)
        return Error(playerid, "You can't whisper yourself.");

	if(GetPVarType(playerid, "Caps")) UpperToLower(params);
    if(strlen(text) > 64)
	{
        SendClientMessageEx(otherid, COLOR_YELLOW, "** Whisper from %s (%d): %.64s", ReturnName(playerid), playerid, text);
        SendClientMessageEx(otherid, COLOR_YELLOW, "...%s **", text[64]);

        SendClientMessageEx(playerid, COLOR_YELLOW, "** Whisper to %s (%d): %.64s", ReturnName(otherid), otherid, text);
        SendClientMessageEx(playerid, COLOR_YELLOW, "...%s **", text[64]);
    }
    else
	{
        SendClientMessageEx(otherid, COLOR_YELLOW, "** Whisper from %s (%d): %s **", ReturnName(playerid), playerid, text);
        SendClientMessageEx(playerid, COLOR_YELLOW, "** Whisper to %s (%d): %s **", ReturnName(otherid), otherid, text);
    }
    SendNearbyMessage(playerid, 10.0, COLOR_PURPLE, "* %s mutters something in %s's ear.", ReturnName(playerid), ReturnName(otherid));

	foreach(new i : Player) if((pData[i][pAdmin]) && pData[i][pSPY] > 0)
    {
        SendClientMessageEx(i, COLOR_YELLOW2, "[SPY Whisper] %s (%d) to %s (%d): %s", pData[playerid][pName], playerid, pData[otherid][pName], otherid, text);
    }
    return 1;
}

CMD:l(playerid, params[])
{
    if(isnull(params))
        return Usage(playerid, "/(l)ow [low text]");

	if(GetPVarType(playerid, "Caps")) UpperToLower(params);
	if(IsPlayerInAnyVehicle(playerid))
	{
		foreach(new i : Player)
		{
			if(IsPlayerInAnyVehicle(i) && GetPlayerVehicleID(i) == GetPlayerVehicleID(playerid))
			{
				if(strlen(params) > 64)
				{
					SendClientMessageEx(i, COLOR_PINK, "[car] %s says: %.64s ..", ReturnName(playerid), params);
					SendClientMessageEx(i, COLOR_PINK, "...%s", params[64]);
				}
				else
				{
					SendClientMessageEx(i, COLOR_PINK, "[car] %s says: %s", ReturnName(playerid), params);
				}
				printf("[CAR] %s(%d) : %s", pData[playerid][pName], playerid, params);
			}
		}
	}
	else
	{
		if(strlen(params) > 64)
		{
			SendNearbyMessage(playerid, 5.0, COLOR_PINK, "[low] %s says: %.64s ..", ReturnName(playerid), params);
			SendNearbyMessage(playerid, 5.0, COLOR_PINK, "...%s", params[64]);
		}
		else
		{
			SendNearbyMessage(playerid, 5.0, COLOR_PINK, "[low] %s says: %s", ReturnName(playerid), params);
		}
		printf("[LOW] %s(%d) : %s", pData[playerid][pName], playerid, params);
	}
    return 1;
}

CMD:s(playerid, params[])
{

    if(isnull(params))
        return Usage(playerid, "/(s)hout [shout text] /ds for in the door");

	if(GetPVarType(playerid, "Caps")) UpperToLower(params);
    if(strlen(params) > 64)
	{
        SendNearbyMessage(playerid, 30.0, COLOR_PINK, "%s shouts: %.64s ..", ReturnName(playerid), params);
        SendNearbyMessage(playerid, 30.0, COLOR_PINK, "...%s!", params[64]);
    }
    else
	{
        SendNearbyMessage(playerid, 30.0, COLOR_PINK, "%s shouts: %s!", ReturnName(playerid), params);
    }
	new flyingtext[128];
	format(flyingtext, sizeof(flyingtext), "%s!", params);
    SetPlayerChatBubble(playerid, flyingtext, COLOR_PINK, 10.0, 10000);
	printf("[SHOUTS] %s(%d) : %s", pData[playerid][pName], playerid, params);
    return 1;
}

CMD:b(playerid, params[])
{
    if(isnull(params))
        return Usage(playerid, "/b [local OOC]");

	UpperToLower(params);
	if(pData[playerid][pAdminDuty] == 1)
    {
		if(strlen(params) > 64)
		{
			SendNearbyMessage(playerid, 20.0, COLOR_PINK, "%s:"WHITE_E" (( %.64s ..", ReturnName(playerid), params);
            SendNearbyMessage(playerid, 20.0, COLOR_PINK, ".. %s ))", params[64]);
		}
		else
        {
            SendNearbyMessage(playerid, 20.0, COLOR_PINK, "%s:"WHITE_E" (( %s ))", ReturnName(playerid), params);
            return 1;
        }
	}
	else
	{
		if(strlen(params) > 64)
		{
			SendNearbyMessage(playerid, 20.0, COLOR_PINK, "%s: (( %.64s ..", ReturnName(playerid), params);
            SendNearbyMessage(playerid, 20.0, COLOR_PINK, ".. %s ))", params[64]);
		}
		else
        {
            SendNearbyMessage(playerid, 20.0, COLOR_PINK, "%s: (( %s ))", ReturnName(playerid), params);
            return 1;
        }
	}
	//printf("[OOC] %s(%d) : %s", pData[playerid][pName], playerid, params);
    return 1;
}

CMD:call(playerid, params[])
{
	new ph;
	if(pData[playerid][pPhone] == 0) return Error(playerid, "You dont have phone!");
	if(pData[playerid][pPhoneCredit] <= 0) return Error(playerid, "You dont have phone credits!");

	if(sscanf(params, "d", ph))
	{
		Usage(playerid, "/call [phone number] 933 - Taxi Call | 511 - Gojek Call | 911 - SAPD Crime Call | 922 - SAMD Medic Call");
		foreach(new ii : Player)
		{
			if(pData[ii][pMechDuty] == 1)
			{
				SendClientMessageEx(playerid, COLOR_GREEN, "Mekanik Duty: %s | PH: [%d]", ReturnName(ii), pData[ii][pPhone]);
			}
		}
		return 1;
	}
	if(ph == 911)
	{
		if(pData[playerid][pCallTime] >= gettime())
			return Error(playerid, "You must wait %d seconds before sending another call.", pData[playerid][pCallTime] - gettime());

		SendNearbyMessage(playerid, 20.0, COLOR_PURPLE, "* %s takes out a cellphone and calling someone.", ReturnName(playerid));
        Info(playerid, "911: "WHITE_E"You have reached the emergency crime.");
		Info(playerid, "911: "WHITE_E"How can I help you?");
		SetPVarInt(playerid, "911", 1);

		pData[playerid][pCallTime] = gettime() + 60;
	}
	if(ph == 922)
	{
		if(pData[playerid][pCallTime] >= gettime())
			return Error(playerid, "You must wait %d seconds before sending another call.", pData[playerid][pCallTime] - gettime());

		SendNearbyMessage(playerid, 20.0, COLOR_PURPLE, "* %s takes out a cellphone and calling someone.", ReturnName(playerid));
		Info(playerid, "922: "WHITE_E"You have reached the emergency medical service.");
		Info(playerid, "922: "WHITE_E"How can I help you?");
		SetPVarInt(playerid, "922", 1);

		pData[playerid][pCallTime] = gettime() + 60;
	}
	if(ph == 933)
	{
		if(pData[playerid][pCallTime] >= gettime())
			return Error(playerid, "You must wait %d seconds before sending another call.", pData[playerid][pCallTime] - gettime());

		SendNearbyMessage(playerid, 20.0, COLOR_PURPLE, "* %s takes out a cellphone and calling someone.", ReturnName(playerid));
		Info(playerid, "933: "WHITE_E"You have reached the taxi driver.");
		Info(playerid, "933: "WHITE_E"Describe Your Positions!");
		SetPVarInt(playerid, "933", 1);
	}
	if(ph == 511)
	{
		if(pData[playerid][pCallTime] >= gettime())
			return Error(playerid, "You must wait %d seconds before sending another call.", pData[playerid][pCallTime] - gettime());

		SendNearbyMessage(playerid, 20.0, COLOR_PURPLE, "* %s takes out a cellphone and calling someone.", ReturnName(playerid));
		Info(playerid, "511: "WHITE_E"You have reached the gojek driver.");
		Info(playerid, "511: "WHITE_E"Describe Your Positions!");
		SetPVarInt(playerid, "511", 1);
	}
	if(ph == pData[playerid][pPhone]) return Error(playerid, "Nomor sedang sibuk!");
	foreach(new ii : Player)
	{
		if(pData[ii][pPhone] == ph)
		{
			if(pData[ii][IsLoggedIn] == false || !IsPlayerConnected(ii)) 
				return Error(playerid, "This number is not actived!");

			if(pData[ii][pCall] == INVALID_PLAYER_ID)
			{
				pData[playerid][pCall] = ii;

				new tstr[128], tstrs[128];
				format(tstr, sizeof(tstr), "%d", pData[ii][pPhone]);
				PlayerTextDrawSetString(playerid, PHANGKAT[14][playerid], tstr);
				format(tstrs, sizeof(tstr), "%d", pData[playerid][pPhone]);
				PlayerTextDrawSetString(ii, PHANGKAT[14][ii], tstr);
				ShowMemanggil(playerid);
				ShowPanggilanMasuk(ii);
				PlayerPlaySound(playerid, 3600, 0,0,0);
				PlayerPlaySound(ii, 6003, 0,0,0);
				Terhubung[playerid] = 0;
				Terhubung[playerid] = 0;
				SetPlayerSpecialAction(playerid, SPECIAL_ACTION_USECELLPHONE);
				SendNearbyMessage(playerid, 20.0, COLOR_PURPLE, "* %s takes out a cellphone and calling someone.", ReturnName(playerid));
				return 1;
			}
			else
			{
				Error(playerid, "Nomor ini sedang sibuk.");
				return 1;
			}
		}
	}
	return 1;
}

CMD:p(playerid)
{
	if(pData[playerid][pCall] != INVALID_PLAYER_ID)
		return Error(playerid, "Anda sudah sedang menelpon seseorang!");

	if(pData[playerid][pInjured] != 0)
		return Error(playerid, "You cant do that in this time.");

	foreach(new ii : Player)
	{
		if(playerid == pData[ii][pCall])
		{
			pData[ii][pPhoneCredit]--;

			pData[playerid][pCall] = ii;
			//
			PlayerTextDrawHide(playerid, PHANGKAT[10][playerid]);
			PlayerTextDrawHide(playerid, PHANGKAT[11][playerid]);
			PlayerTextDrawShow(playerid, REJECT[playerid]);
			PlayerTextDrawShow(playerid, BERDERING[playerid]);
			//
			new tstr[128], tstrs[128];
			format(tstr, sizeof(tstr), "Terhubung..");
			PlayerTextDrawSetString(playerid, BERDERING[playerid], tstr);
			format(tstr, sizeof(tstr), "Terhubung..");
			PlayerTextDrawSetString(ii, BERDERING[ii], tstrs);
			//
			PlayerTextDrawHide(ii, BERDERING[ii]);
			PlayerTextDrawHide(ii, REJECT[ii]);
			PlayerTextDrawShow(ii, BERDERING[ii]);
			PlayerTextDrawShow(ii, REJECT[ii]);
			//
			Terhubung[playerid] = 1;
			Terhubung[ii] = 1;
			CancelSelectTextDraw(playerid);
			SendClientMessageEx(ii, COLOR_YELLOW, "[CELLPHONE] "WHITE_E"phone is connected, type '/cursor' and press red button to stop!");
			SendClientMessageEx(playerid, COLOR_YELLOW, "[CELLPHONE] "WHITE_E"phone is connected, type '/cursor' and press red button to stop!");
			SetPlayerSpecialAction(playerid, SPECIAL_ACTION_USECELLPHONE);
			SendNearbyMessage(playerid, 20.0, COLOR_PURPLE, "* %s answers their cellphone.", ReturnName(playerid));
			return 1;
		}
	}
	return 1;
}

CMD:shareloc(playerid, params[])
{
    if(pData[playerid][pPhone] == 0) return Error(playerid, "You dont have phone!");

	new ph;
	if(sscanf(params, "d", ph))
	{
		Usage(playerid, "/shareloc [phone number]");
		return 1;
	}
	foreach(new ii : Player)
	{
		if(pData[ii][pPhone] == ph)
		{
			if(pData[ii][IsLoggedIn] == false || !IsPlayerConnected(ii) || pData[playerid][pPhoneOff] == 1) return Error(playerid, "This number is not actived!");

			Servers(playerid, "Send Your location to phone number  %d", ph);
			Info(ii, "Anda Dikirimi Lokasi Oleh Seseorang");

			SendNearbyMessage(playerid, 20.0, COLOR_PURPLE, "* %s mengirimkan lokasinya kepada seseorang", ReturnName(playerid));

			new
				Float: X,
				Float: Y,
				Float: Z;

			GetPlayerPos(playerid, X, Y, Z);
			SetPlayerCheckpoint(ii, X, Y, Z, 5.0);
			return 1;
		}
	}
	return 1;
}

stock hungup(playerid)
{
	new caller = pData[playerid][pCall];
	if(IsPlayerConnected(caller) && caller != INVALID_PLAYER_ID)
	{
		HidePhone1(caller);
		pData[caller][pCall] = INVALID_PLAYER_ID;
		SetPlayerSpecialAction(caller, SPECIAL_ACTION_STOPUSECELLPHONE);
		SendNearbyMessage(caller, 20.0, COLOR_PURPLE, "* %s puts away their cellphone.", ReturnName(caller));

		Terhubung[caller] = 0;
		Terhubung[playerid] = 0;

		HidePhone(playerid);
		SendNearbyMessage(playerid, 20.0, COLOR_PURPLE, "* %s puts away their cellphone.", ReturnName(playerid));
		pData[playerid][pCall] = INVALID_PLAYER_ID;
		SetPlayerSpecialAction(playerid, SPECIAL_ACTION_STOPUSECELLPHONE);
	}
	return 1;
}

CMD:sms(playerid, params[])
{
	new ph, text[50];
	if(pData[playerid][pPhone] == 0) return Error(playerid, "You dont have phone!");
	if(pData[playerid][pPhoneCredit] <= 0) return Error(playerid, "You dont have phone credits!");
	if(pData[playerid][pInjured] != 0) return Error(playerid, "You cant do at this time.");

	if(sscanf(params, "ds[50]", ph, text))
        return Usage(playerid, "/sms [phone number] [message max 50 text]");

	foreach(new ii : Player)
	{
		if(pData[ii][pPhone] == ph)
		{
			if(ii == INVALID_PLAYER_ID || !IsPlayerConnected(ii)) return Error(playerid, "This number is not actived!");
			SendClientMessageEx(playerid, COLOR_YELLOW, "[SMS to %d]"WHITE_E" %s", ph, text);
			SendClientMessageEx(ii, COLOR_YELLOW, "[SMS from %d]"WHITE_E" %s", pData[playerid][pPhone], text);
			Info(ii, "Gunakan "LB_E"'@<text>' "WHITE_E"untuk membalas SMS!");
			PlayerPlaySound(ii, 6003, 0,0,0);
			pData[ii][pSMS] = pData[playerid][pPhone];

			pData[playerid][pPhoneCredit] -= 1;
			return 1;
		}
	}
	return 1;
}
CMD:setfreq(playerid, params[])
{
	if(pData[playerid][pWT] == 0)
		return Error(playerid, "You dont have walkie talkie!");
	
	if(pData[playerid][pToggleWT] == 0)
	{
		new tstr[64];
		Info(playerid, "Silahkan menekan angka jika ingin memasukkan freq, jika ingin keluar dari sini ketikan /setfreq kembali.");
		PlayerTextDrawShow(playerid, WT1[playerid]);
		PlayerTextDrawShow(playerid, WT2[playerid]);
		format(tstr, sizeof(tstr), "%d", pData[playerid][pWT]);
		PlayerTextDrawSetString(playerid, WT2[playerid], tstr);
		SelectTextDraw(playerid, 0xFFA500FF);
		pData[playerid][pToggleWT] = 1;
	}
	else
	{
		PlayerTextDrawHide(playerid, WT1[playerid]);
		PlayerTextDrawHide(playerid, WT2[playerid]);
		CancelSelectTextDraw(playerid);
		pData[playerid][pToggleWT] = 0;
	}
	return 1;
}
CMD:setfreqold(playerid, params[])
{
	if(pData[playerid][pWT] == 0)
		return Error(playerid, "You dont have walkie talkie!");

	new channel;
	if(sscanf(params, "d", channel))
		return Usage(playerid, "/setfreq [channel 1 - 1000]");

	if(pData[playerid][pTogWT] == 1) return Error(playerid, "Your walkie talkie is turned off.");
	if(channel == pData[playerid][pWT]) return Error(playerid, "You are already in this channel.");

	if(channel > 0 && channel <= 1000)
	{
		foreach(new i : Player)
		{
		    if(pData[i][pWT] == channel)
		    {
				SendClientMessageEx(i, COLOR_LIME, "[WT] "WHITE_E"%s has joined in to this channel!", ReturnName(playerid));
		    }
		}
		Info(playerid, "You have set your walkie talkie channel to "LIME_E"%d", channel);
		pData[playerid][pWT] = channel;
	}
	else
	{
		Error(playerid, "Invalid channel id! 1 - 1000");
	}
	return 1;
}

CMD:wt(playerid, params[])
{
    new text[128], mstr[512];
    
	if(sscanf(params,"s[128]",text))
        return Usage(playerid, "/wt [text]");
        
	if(pData[playerid][pTogWT] == 1)return Info(playerid, "Your Wt is disable");
	
	for(new i = 0; i<MAX_PLAYERS; i++)
	{
     	if(pData[i][pWT] == pData[playerid][pWT])
		{
			if(pData[i][pTogWT] == 0)
			{
			    SendClientMessageEx(i, COLOR_LIME, "[WT] "YELLOW_E"%s: %s", ReturnName(playerid), text);
			    format(mstr, sizeof(mstr), "[<WT>]\n* %s *", text);
				SetPlayerChatBubble(playerid, mstr, COLOR_RADIO, 10.0, 3000);
			    //SendClientMessage(i, COLOREWT, stringa);
			}
		}
	}
	return 1;
}


/*CMD:savestats(playerid, params[])
{
	UpdateWeapons(playerid);
	UpdatePlayerData(playerid);
	Info(playerid, "Your data have been saved!");
	return 1;
}*/

/*CMD:ads(playerid, params[])
{
	if(!IsPlayerInRangeOfPoint(playerid, 3.0, 2461.21, 2270.42, 91.67)) return Error(playerid, "You must in SANA Station!");
	//if(pData[playerid][pPhone] == 0) return Error(playerid, "You dont have phone!");
	if(GetPVarInt(playerid, "makead") > gettime())
        return Error(playerid, "Anda Sudah Membuat iklan beberapa menit yang lalu(Tunggulah beberapa saat lagi).");

	if(isnull(params))
	{
		Usage(playerid, "/ads [text] | 1 character pay $2");
		return 1;
	}
	if(strlen(params) >= 100 ) return Error(playerid, "Maximum character is 100 text." );
	new payout = strlen(params) * 500;
	if(GetPlayerMoney(playerid) < payout) return Error(playerid, "Not enough money.");

	GivePlayerMoneyEx(playerid, -payout);
	Server_AddMoney(payout);
	SendClientMessage(playerid, COLOR_ARWIN, "ADVERTISEMENT: {FFFFFF}Your advertisement will be published shortly.");
	SetTimerEx("advertisement", 15000, 0, "i", playerid);
	format(advertise[playerid], 1024, "%s", params);
	SetPVarInt(playerid, "makead", gettime() + 300);
	return 1;
}
*/
forward advertisement(playerid);
public advertisement(playerid)
{
 	new String[255];
  	format(String, sizeof(String), "{FF0000}Iklan: {33AA33}%s",  advertise[playerid]);
 	OOCNews(TEAM_GROVE_COLOR,String);
	format(String, sizeof(String), "{FF0000}Contact Info: [{33AA33}%s{FF0000}] Phone Number: [{33AA33}%d{FF0000}]", pData[playerid][pName], pData[playerid][pPhone]);
	OOCNews(TEAM_GROVE_COLOR,String);
	return 1;
}
//------------------[ Bisnis and Buy Commands ]-------
CMD:buy(playerid, params[])
{
	//Kurir
	if(IsPlayerInRangeOfPoint(playerid, 3.5, 1654.9298,-1862.5781,13.5344))
	{
		if(pData[playerid][pJob] == 9 || pData[playerid][pJob2] == 9)
		{
			if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
			{
				SetPlayerCheckpoint(playerid, 2787.4229,-2417.5588,13.6338, 4.0);
				TogglePlayerControllable(playerid, 0);
				pData[playerid][pActivity] = SetTimerEx("KurirStart", 400, true, "i", playerid);
				PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Memuat Crate...");
				PlayerTextDrawShow(playerid, ActiveTD[playerid]);
				ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
				GivePlayerMoneyEx(playerid, 500);
				SendClientMessage(playerid, COLOR_RIKO, "COURIER: {FFFFFF}You buying crate packet "LG_E"$5.00.");
			}
			else return Error(playerid, "You are not in vehicle trucker.");
		}
		else return Error(playerid, "You are not trucker job.");
	}
	//trucker product
	if(IsPlayerInRangeOfPoint(playerid, 3.5, -279.67, -2148.42, 28.54))
	{
		if(pData[playerid][pJob] == 4 || pData[playerid][pJob2] == 4)
		{
			if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
			{
				new mstr[128];
				format(mstr, sizeof(mstr), ""WHITE_E"Masukan jumlah product:\nProduct Stock: "GREEN_E"%d\n"WHITE_E"Product Price"GREEN_E"%s / item", Product, FormatMoney(ProductPrice));
				ShowPlayerDialog(playerid, DIALOG_PRODUCT, DIALOG_STYLE_INPUT, "Buy Product", mstr, "Buy", "Cancel");
			}
			else return Error(playerid, "You are not in vehicle trucker.");
		}
		else return Error(playerid, "You are not trucker job.");
	}
	if(IsPlayerInRangeOfPoint(playerid, 3.5, 336.70, 895.54, 20.40))
	{
		if(pData[playerid][pJob] == 4 || pData[playerid][pJob2] == 4)
		{
			if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
			{
				new mstr[128];
				format(mstr, sizeof(mstr), ""WHITE_E"Masukan jumlah liter gasoil:\nGasOil Stock: "GREEN_E"%d\n"WHITE_E"GasOil Price"GREEN_E"%s / liters", GasOil, FormatMoney(GasOilPrice));
				ShowPlayerDialog(playerid, DIALOG_GASOIL, DIALOG_STYLE_INPUT, "Buy GasOil", mstr, "Buy", "Cancel");
			}
			else return Error(playerid, "You are not in vehicle trucker.");
		}
		else return Error(playerid, "You are not trucker job.");
	}
	//spray
	if(IsPlayerInRangeOfPoint(playerid, 2.5, 1345.3302,-1763.2202,13.5992))
	{
		if(pData[playerid][pLevel] < 5)
			return Error(playerid, "You must level 5 to use this!");

		new String[900];
		format(String, sizeof(String), "Size\tPrice\n\
		"ORANGE_E"Small\t$70\n");
		format(String, sizeof(String), "%s"GREEN_E"Normal\t$120\n", String);
		format(String, sizeof(String), "%s"RED_E"Big\t$200\n", String);
		SendNearbyMessage(playerid, 30.0, COLOR_PINK, "[BOT]Radeetz says: %s apakah kamu ingin membeli spraycan?Silahkan dipilih.", ReturnName(playerid));
		ShowPlayerDialog(playerid, BUY_SPRAYCAN, DIALOG_STYLE_TABLIST_HEADERS, "Buy spray can", String, "Buy", "Close");
	}
	//Material
	if(IsPlayerInRangeOfPoint(playerid, 2.5, -258.54, -2189.92, 28.97))
	{
		if(pData[playerid][pMaterial] >= 500) return Error(playerid, "Anda sudah membawa 500 Material!");
		new mstr[128];
		format(mstr, sizeof(mstr), ""WHITE_E"Masukan jumlah material:\nMaterial Stock: "GREEN_E"%d\n"WHITE_E"Material Price"GREEN_E"%s / item", Material, FormatMoney(MaterialPrice));
		ShowPlayerDialog(playerid, DIALOG_MATERIAL, DIALOG_STYLE_INPUT, "Buy Material", mstr, "Buy", "Cancel");
	}
	//Component
	if(IsPlayerInRangeOfPoint(playerid, 0.5, 315.07, 926.53, 20.46))
	{
	    {
			if(pData[playerid][pComponent] >= 500) return Error(playerid, "Anda sudah membawa 500 Component!");
			new mstr[128];
			format(mstr, sizeof(mstr), ""WHITE_E"Masukan jumlah component:\nComponent Stock: "GREEN_E"%d\n"WHITE_E"Component Price"GREEN_E"%s / item", Component, FormatMoney(ComponentPrice));
			ShowPlayerDialog(playerid, DIALOG_COMPONENT, DIALOG_STYLE_INPUT, "Buy Component", mstr, "Buy", "Cancel");
		}
	}
	//Apotek
	if(IsPlayerInRangeOfPoint(playerid, 2.5, 1265.6334, -1279.1998, 1061.1492))
	{
		if(pData[playerid][pFaction] != 3)
			return Error(playerid, "Medical only!");

		new mstr[250];
		format(mstr, sizeof(mstr), "Product\tPrice\n");
		format(mstr, sizeof(mstr), "%sPainkiller\t"GREEN_E"%s\n", mstr, FormatMoney(MedicinePrice));
		format(mstr, sizeof(mstr), "%sMedkit\t"GREEN_E"%s\n", mstr, FormatMoney(MedkitPrice));
		format(mstr, sizeof(mstr), "%sBandage\t"GREEN_E"$100\n", mstr);
		format(mstr, sizeof(mstr), "%sParacetamol\t"GREEN_E"$150\n", mstr);
		format(mstr, sizeof(mstr), "%sAmoxicilin\t"GREEN_E"$200\n", mstr);
		format(mstr, sizeof(mstr), "%sAntasida\t"GREEN_E"$120\n", mstr);
		ShowPlayerDialog(playerid, DIALOG_APOTEK, DIALOG_STYLE_TABLIST_HEADERS, "Apotek", mstr, "Buy", "Cancel");
	}
	if(IsPlayerInRangeOfPoint(playerid, 2.5, -2020.1874, -83.2404, 1060.9877))
	{
		if(pData[playerid][pFaction] != 3)
			return Error(playerid, "Medical only!");

		new mstr[250];
		format(mstr, sizeof(mstr), "Product\tPrice\n");
		format(mstr, sizeof(mstr), "%sPainkiller\t"GREEN_E"%s\n", mstr, FormatMoney(MedicinePrice));
		format(mstr, sizeof(mstr), "%sMedkit\t"GREEN_E"%s\n", mstr, FormatMoney(MedkitPrice));
		format(mstr, sizeof(mstr), "%sBandage\t"GREEN_E"$100\n", mstr);
		ShowPlayerDialog(playerid, DIALOG_APOTEK, DIALOG_STYLE_TABLIST_HEADERS, "Apotek", mstr, "Buy", "Cancel");
	}
	//Food and Seed
	if(IsPlayerInRangeOfPoint(playerid, 2.5, -381.44, -1426.13, 25.93))
	{
		new mstr[128];
		format(mstr, sizeof(mstr), "Product\tPrice\n\
		Food\t"GREEN_E"%s\n\
		Seed\t"GREEN_E"%s\n\
		", FormatMoney(FoodPrice), FormatMoney(SeedPrice));
		ShowPlayerDialog(playerid, DIALOG_FOOD, DIALOG_STYLE_TABLIST_HEADERS, "Food", mstr, "Buy", "Cancel");
	}
	//Drugs
	if(IsPlayerInRangeOfPoint(playerid, 2.5, -3811.65, 1313.72, 71.42))
	{
		if(pData[playerid][pMarijuana] >= 100) return Error(playerid, "Anda sudah membawa 100 kg Marijuana!");
		if(pData[playerid][pFamily] == -1) return Error(playerid, "Only for family member!");

		new mstr[128];
		format(mstr, sizeof(mstr), ""WHITE_E"Masukan jumlah marijuana:\nMarijuana Stock: "GREEN_E"%d\n"WHITE_E"Marijuana Price"GREEN_E"%s / item", Marijuana, FormatMoney(MarijuanaPrice));
		ShowPlayerDialog(playerid, DIALOG_DRUGS, DIALOG_STYLE_INPUT, "Buy Drugs", mstr, "Buy", "Cancel");
	}
	//Gym
	for(new a = 1; a < sizeof(GymPoint); a++)
	if(IsPlayerInRangeOfPoint(playerid, 5.0, GymPoint[a][bbPos][0], GymPoint[a][bbPos][1], GymPoint[a][bbPos][2]))
	{
		ShowPlayerDialog(playerid, DIALOG_GMENU, DIALOG_STYLE_LIST, "Gym Menu", "Gym Membership[16 Days]\nLearning Fight Style[$500,00]", "Select", "Back");
	}
	//Mods
	for(new aaa = 1; aaa < sizeof(ModsPoint); aaa++)
	if(IsPlayerInRangeOfPoint(playerid, 5.0, ModsPoint[aaa][ModsPos][0], ModsPoint[aaa][ModsPos][1], ModsPoint[aaa][ModsPos][2]))
	{
		ShowPlayerDialog(playerid, DIALOG_MMENU, DIALOG_STYLE_LIST, "Vehicle Modshop", "Purchase Vehicle Toys\nPurchase Vehicle Parachute\nPurchase Sticker", "Select", "Back");
	}
	//Buy House
	foreach(new hid : Houses)
	{
		if(IsPlayerInRangeOfPoint(playerid, 2.5, hData[hid][hExtposX], hData[hid][hExtposY], hData[hid][hExtposZ]))
		{
			if(pData[playerid][pMaskOn] == 1) return Error(playerid, "Anda memakai mask, anda harus melepaskannya terlebih dahulu!");
			if(hData[hid][hPrice] > GetPlayerMoney(playerid)) return Error(playerid, "Not enough money, you can't afford this houses.");
			if(strcmp(hData[hid][hOwner], "-")) return Error(playerid, "Someone already owns this house.");
			if(pData[playerid][pVip] == 1)
			{
			    #if LIMIT_PER_PLAYER > 0
				if(Player_HouseCount(playerid) + 1 > 2) return Error(playerid, "You can't buy any more houses.");
				#endif
			}
			else if(pData[playerid][pVip] == 2)
			{
			    #if LIMIT_PER_PLAYER > 0
				if(Player_HouseCount(playerid) + 1 > 3) return Error(playerid, "You can't buy any more houses.");
				#endif
			}
			else if(pData[playerid][pVip] == 3)
			{
			    #if LIMIT_PER_PLAYER > 0
				if(Player_HouseCount(playerid) + 1 > 4) return Error(playerid, "You can't buy any more houses.");
				#endif
			}
			else
			{
				#if LIMIT_PER_PLAYER > 0
				if(Player_HouseCount(playerid) + 1 > 1) return Error(playerid, "You can't buy any more houses.");
				#endif
			}
			GivePlayerMoneyEx(playerid, -hData[hid][hPrice]);
			Server_AddMoney(hData[hid][hPrice]);
			GetPlayerName(playerid, hData[hid][hOwner], MAX_PLAYER_NAME);
			hData[hid][hVisit] = gettime();

			House_Refresh(hid);
			House_Save(hid);
		}
	}
	//Buy Flat
	foreach(new flid : Flats)
	{
		if(IsPlayerInRangeOfPoint(playerid, 2.5, flData[flid][flExtposX], flData[flid][flExtposY], flData[flid][flExtposZ]))
		{
			if(pData[playerid][pMaskOn] == 1) return Error(playerid, "Anda memakai mask, anda harus melepaskannya terlebih dahulu!");
			if(flData[flid][flPrice] > GetPlayerMoney(playerid)) return Error(playerid, "Not enough money, you can't afford this flats.");
			if(strcmp(flData[flid][flOwner], "-")) return Error(playerid, "Someone already owns this flat.");
			if(pData[playerid][pVip] == 1)
			{
			    #if LIMIT_PER_PLAYER > 0
				if(Player_FlatCount(playerid) + 1 > 2) return Error(playerid, "You can't buy any more flats.");
				#endif
			}
			else if(pData[playerid][pVip] == 2)
			{
			    #if LIMIT_PER_PLAYER > 0
				if(Player_FlatCount(playerid) + 1 > 3) return Error(playerid, "You can't buy any more flats.");
				#endif
			}
			else if(pData[playerid][pVip] == 3)
			{
			    #if LIMIT_PER_PLAYER > 0
				if(Player_FlatCount(playerid) + 1 > 4) return Error(playerid, "You can't buy any more flats.");
				#endif
			}
			else
			{
				#if LIMIT_PER_PLAYER > 0
				if(Player_FlatCount(playerid) + 1 > 1) return Error(playerid, "You can't buy any more flats.");
				#endif
			}
			GivePlayerMoneyEx(playerid, -flData[flid][flPrice]);
			Server_AddMoney(flData[flid][flPrice]);
			GetPlayerName(playerid, flData[flid][flOwner], MAX_PLAYER_NAME);
			flData[flid][flVisit] = gettime();

			Flat_Refresh(flid);
			Flat_Save(flid);
		}
	}
	//Buy Hotel
	foreach(new htid : Hotels)
	{
		if(IsPlayerInRangeOfPoint(playerid, 2.5, htData[htid][htExtposX], htData[htid][htExtposY], htData[htid][htExtposZ]))
		{
			if(pData[playerid][pMaskOn] == 1) return Error(playerid, "Anda memakai mask, anda harus melepaskannya terlebih dahulu!");
			if(htData[htid][htPrice] > GetPlayerMoney(playerid)) return Error(playerid, "Not enough money, you can't afford this hotels.");
			if(strcmp(htData[htid][htOwner], "-")) return Error(playerid, "Someone already owns this hotel.");
			if(pData[playerid][pVip] == 1)
			{
			    #if LIMIT_PER_PLAYER > 0
				if(Player_HotelCount(playerid) + 1 > 2) return Error(playerid, "You can't buy any more hotels.");
				#endif
			}
			else if(pData[playerid][pVip] == 2)
			{
			    #if LIMIT_PER_PLAYER > 0
				if(Player_HotelCount(playerid) + 1 > 3) return Error(playerid, "You can't buy any more hotels.");
				#endif
			}
			else if(pData[playerid][pVip] == 3)
			{
			    #if LIMIT_PER_PLAYER > 0
				if(Player_HotelCount(playerid) + 1 > 4) return Error(playerid, "You can't buy any more hotels.");
				#endif
			}
			else
			{
				#if LIMIT_PER_PLAYER > 0
				if(Player_HotelCount(playerid) + 1 > 1) return Error(playerid, "You can't buy any more hotels.");
				#endif
			}
			GivePlayerMoneyEx(playerid, -htData[htid][htPrice]);
			Server_AddMoney(htData[htid][htPrice]);
			GetPlayerName(playerid, htData[htid][htOwner], MAX_PLAYER_NAME);
			htData[htid][htVisit] = gettime();

			Hotel_Refresh(htid);
			Hotel_Save(htid);
		}
	}
	//Buy Bisnis
	foreach(new bid : Bisnis)
	{
		if(IsPlayerInRangeOfPoint(playerid, 2.5, bData[bid][bExtposX], bData[bid][bExtposY], bData[bid][bExtposZ]))
		{
			if(pData[playerid][pLicBiz] <= 0)
				return Error(playerid, "Anda tidak memiliki License Business.");

			if(pData[playerid][pMaskOn] == 1) return Error(playerid, "Anda memakai mask, anda harus melepaskannya terlebih dahulu!");
			if(bData[bid][bPrice] > GetPlayerMoney(playerid)) return Error(playerid, "Not enough money, you can't afford this bisnis.");
			if(strcmp(bData[bid][bOwner], "-")) return Error(playerid, "Someone already owns this bisnis.");
			if(pData[playerid][pVip] == 1)
			{
			    #if LIMIT_PER_PLAYER > 0
				if(Player_BisnisCount(playerid) + 1 > 2) return Error(playerid, "You can't buy any more bisnis.");
				#endif
			}
			else if(pData[playerid][pVip] == 2)
			{
			    #if LIMIT_PER_PLAYER > 0
				if(Player_BisnisCount(playerid) + 1 > 3) return Error(playerid, "You can't buy any more bisnis.");
				#endif
			}
			else if(pData[playerid][pVip] == 3)
			{
			    #if LIMIT_PER_PLAYER > 0
				if(Player_BisnisCount(playerid) + 1 > 4) return Error(playerid, "You can't buy any more bisnis.");
				#endif
			}
			else
			{
				#if LIMIT_PER_PLAYER > 0
				if(Player_BisnisCount(playerid) + 1 > 1) return Error(playerid, "You can't buy any more bisnis.");
				#endif
			}
			GivePlayerMoneyEx(playerid, -bData[bid][bPrice]);
			Server_AddMoney(-bData[bid][bPrice]);
			GetPlayerName(playerid, bData[bid][bOwner], MAX_PLAYER_NAME);
			bData[bid][bVisit] = gettime();

			Bisnis_Refresh(bid);
			Bisnis_Save(bid);
		}
	}
	//Buy Vending menu
	foreach(new vid : Vending)
    {
        if(IsPlayerInRangeOfPoint(playerid, 2.8, VendingData[vid][VendingPosX], VendingData[vid][VendingPosY], VendingData[vid][VendingPosZ]) && strcmp(VendingData[vid][VendingOwner], "-"))
        {
            VendingBuyMenu(playerid, vid);
        }
    }
	//Buy Bisnis menu
	if(pData[playerid][pInBiz] >= 0 && IsPlayerInRangeOfPoint(playerid, 2.5, bData[pData[playerid][pInBiz]][bPointX], bData[pData[playerid][pInBiz]][bPointY], bData[pData[playerid][pInBiz]][bPointZ]))
	{
		Bisnis_BuyMenu(playerid, pData[playerid][pInBiz]);
	}
	return 1;
}


CMD:settwname(playerid, params[])
{
	if(pData[playerid][pAdmin] < 1)
		return PermissionError(playerid);

	new tname[128], otherid, query[128];
	if(sscanf(params, "us[128]", otherid, tname))
	{
	    Usage(playerid, "/settwname <ID/Name> <twit name>");
	    return true;
	}

	mysql_format(g_SQL, query, sizeof(query), "SELECT tnames FROM players WHERE tnames='%s'", tname);
	mysql_tquery(g_SQL, query, "ChangeTwitName", "iis", otherid, playerid, tname);
	return 1;
}

function ChangeTwitName(otherplayer, playerid, nname[])
{
	if(cache_num_rows() > 0)
	{
		// Name Exists
		Error(playerid, "The name "DARK_E"'%s' "GREY_E"already exists in the database, please use a different name!", nname);
	}
	else
	{
		new query[512];
	    format(query, sizeof(query), "UPDATE players SET tnames='%e' WHERE reg_id=%d", nname, pData[otherplayer][pID]);
		mysql_tquery(g_SQL, query);
		format(pData[otherplayer][pTname], MAX_PLAYER_NAME, "%s", nname);
		Servers(playerid, "You has set twitter name %s to %s", pData[otherplayer][pName], nname);
	}
    return true;
}
function ChangeTwitUserName(otherplayer, nname[])
{
	if(cache_num_rows() > 0)
	{
		// Name Exists
		Error(otherplayer, "This Username "DARK_E"'%s' "GREY_E"already exists, please use a different name!", nname);
	}
	else
	{
		new query[512];
	    format(query, sizeof(query), "UPDATE players SET tnames='%e' WHERE reg_id=%d", nname, pData[otherplayer][pID]);
		mysql_tquery(g_SQL, query);
		format(pData[otherplayer][pTname], MAX_PLAYER_NAME, "%s", nname);
		Servers(otherplayer, "Your username account has changed to %s", nname);
		pData[otherplayer][pTweet] = 1;
	}
    return true;
}

function OnVehStarterpack(playerid, pid, model, color1, color2, cost, Float:x, Float:y, Float:z, Float:a)
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
	pvData[i][cRent] = 0;
	for(new j = 0; j < 17; j++)
		pvData[i][cMod][j] = 0;
	Iter_Add(PVehicles, i);
	OnPlayerVehicleRespawn(i);
	Servers(playerid, "Anda telah menggclaim starterpack");
	//SetPlayerPosition(playerid, 1800.99, -1800.90, 13.54, 6.14, 0);
	pData[playerid][pBuyPvModel] = 0;
	SetPlayerPos(playerid, 121.9126, -1814.0848, 4.2059);
	pData[playerid][pSpack] = 1;
	return 1;
}


CMD:claimstarterpack(playerid, params[])
{
    DisablePlayerCheckpoint(playerid);
	if(pData[playerid][pSpack]) return Error(playerid, "Anda Sudah Mengclaim Starterpack");
	if(!IsPlayerInRangeOfPoint(playerid, 3.0, 98.8032,-1807.9840,4.3699)) return Error(playerid, "Anda Harus Ada Di Point Claim Starterpack!");
    new vehicleid, count = 0, limit = MAX_PLAYER_VEHICLE + pData[playerid][pVip];
	foreach(new ii : PVehicles)
	{
		if(pvData[ii][cOwner] == pData[playerid][pID])
		count++;
	}
	if(count >= limit)
	{
		Error(playerid, "Slot kendaraan anda sudah penuh!");
		RemovePlayerFromVehicle(playerid);
		SetTimerEx("RespawnPV", 3000, false, "d", vehicleid);
		return 1;
	}
	SendStaffMessage(COLOR_PINK, "* %s telah mengclaim starterpack.", pData[playerid][pName]);
	GivePlayerMoneyEx(playerid, 50000);
	new cQuery[1024];
	new Float:x,Float:y,Float:z, Float:a;
	new model, color1, color2;
	GetPlayerPos(playerid, x ,y , z);
	GetPlayerFacingAngle(playerid, a);
	new cost = 3000;
	color1 = 9;
	color2 = 9;
	model = 481;
	x = 121.8043;
	y = -1814.1162;
	z = 4.2059;
	a = 262.0055;
	mysql_format(g_SQL, cQuery, sizeof(cQuery), "INSERT INTO `vehicle` (`owner`, `model`, `color1`, `color2`, `price`, `x`, `y`, `z`, `a`) VALUES (%d, %d, %d, %d, %d, '%f', '%f', '%f', '%f')", pData[playerid][pID], model, color1, color2, cost, x, y, z, a);

	mysql_tquery(g_SQL, cQuery, "OnVehStarterpack", "ddddddffff", playerid, pData[playerid][pID], model, color1, color2, cost, x, y, z, a);

	return 1;
}

CMD:clearchat(playerid, params[])
{
	if(pData[playerid][pAdmin] < 1)
		if(pData[playerid][pHelper] < 2)
			return SCM(playerid, COLOR_YELLOW, "Use /cc");

	for(new i = 0; i < 20; i++)
	{
		SendClientMessageToAll(-1, "");
	}
	return 1;
}

CMD:cc(playerid, params[])
{
	for(new i = 0; i < 20; i++)
	{
		SendClientMessage(playerid, -1, "");
	}
	return 1;
}

CMD:saverp(playerid, params[])
{
	new saverp[70];
	if(sscanf(params, "s[70]", saverp))
		return Usage(playerid, "/saverp [action]");

	Info(playerid, "AutoRp Save : %s", saverp);

	//format(pData[playerid][pSavedRp], 70, saverp);
	pData[playerid][pSavedRp] = saverp;
	return 1;
}

CMD:rp(playerid)
{
	SendNearbyMessage(playerid, 20.0, COLOR_PURPLE, "* %s %s", ReturnName(playerid), pData[playerid][pSavedRp]);
    return 1;
}
CMD:changelogs(playerid, params[])
{
	new fmt_str[1208];
 	format(fmt_str, sizeof(fmt_str), "{42A2DD}Changelogs %s:\n\n", TEXT_GAMEMODE);
	format(fmt_str, sizeof(fmt_str), "%s{FFFFFF}1.[Improved] New Tetxdraw Simple\n", fmt_str);
	format(fmt_str, sizeof(fmt_str), "%s{FFFFFF}2.[Improved] New Speedometer Simple\n", fmt_str);
	format(fmt_str, sizeof(fmt_str), "%s{FFFFFF}3.[Improved] Fix Bug /settings\n", fmt_str);
	format(fmt_str, sizeof(fmt_str), "%s{FFFFFF}4.[Improved] Fix Bug pergantian textdraw \n", fmt_str);
	format(fmt_str, sizeof(fmt_str), "%s{FFFFFF}5.[Improved] Fix Any Bug\n", fmt_str);
	format(fmt_str, sizeof(fmt_str), "%s{FFFFFF}6.[Improved] Trash Menggunakan [ Y ]\n", fmt_str);
	format(fmt_str, sizeof(fmt_str), "%s"LB_E"\nMore Information HomeBase  "RED_E"https://discord.io/hbprp\n", fmt_str);
	ShowPlayerDialog(playerid,DIALOG_CHANGELOGS,DIALOG_STYLE_MSGBOX, "Changelogs", fmt_str,"F.A.Q", "Close");
	return 1;
}

CMD:astop(playerid, params[])
{
  	if(StopaniFloats[playerid][0] != 0)
  	{
      	SendClientMessageEx (playerid, COLOR_GREY, "You are already attempting to clear your animations!");
    	return 1;
  	}
  	if(pData[playerid][pInjured] != 0|| pData[playerid][pCuffed] != 0|| pData[playerid][pHospital] != 0)
  	{
      	Error(playerid, "You cannot do this at this time.");
  	}
  	else
  	{
      	GetPlayerPos(playerid, StopaniFloats[playerid][0], StopaniFloats[playerid][1], StopaniFloats[playerid][2]);
    	SetTimerEx("StopaniTimer", 3000, 0, "d", playerid);
    	SendClientMessageEx(playerid, COLOR_YELLOW, "Do not move for 3 seconds to have your animations cleared!");
  	}
  	return 1;
}

forward StopaniTimer(playerid);
public StopaniTimer(playerid)
{
  	new Float:posX, Float:posY, Float:posZ;
    GetPlayerPos(playerid, posX, posY, posZ);
    if(StopaniFloats[playerid][0] != posX || StopaniFloats[playerid][1] != posY || StopaniFloats[playerid][2] != posZ)
  	{
      	SendClientMessageEx (playerid, COLOR_YELLOW, "Failed to clear animations because you moved!");
      	for(new i = 0; i < 3; i++)
    	{
      		StopaniFloats[playerid][i] = 0;
    	}
      	return 1;
  	}
	SendClientMessageEx (playerid, COLOR_YELLOW, "Your animations were cleared!");
  	ClearAnimations(playerid);
  	SetPlayerSkin(playerid, GetPlayerSkin(playerid));
  	SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
  	TextDrawHideForPlayer(playerid, txtAnimHelper);
  	for(new i = 0; i < 3; i++)
  	{
    	StopaniFloats[playerid][i] = 0;
  	}
  	return 1;
}

CMD:stuck(playerid, params[])
{
  if(IsPlayerConnected(playerid))
  {
      ShowPlayerDialog(playerid, BUGGED, DIALOG_STYLE_LIST, "Available Bug", "Freeze Bug\nBug VirtualWorld\nBug Interior\nBlueberry BUG", "Pilih", "Tidak");
  }
  return 1;
}

stock ShowFAQChangelogs(playerid)
{
    new String[10280];
	format(String, sizeof String, "Q: Apa Saja Yang Kami Tambahkan(1)\nA: Dealership, Vending\nQ:Apakah Ada Bug?\nA:Kami Memastikan Bahwa Tidak ada bug\nQ: Apakah Fitur Ini Menarik\nA: Kami Jamin Menarik Untuk Anda\nQ: Apa Yang Di Ubah\nA: Textdraw Server\nQ: Mappingan Apa Saja Yang Di Tambahkan\nA: Bank,Asgh,DLL\n\n"LB_E"For more information: {FFF000}https://discord.gg/HomeBase");
	ShowPlayerDialog(playerid, INVALID_DIALOG_ID, DIALOG_STYLE_MSGBOX, "F.A.Q", String, "OK", "");
}
CMD:race(playerid, params[])
{
	new type[24], string[128], Float:pos[3];
	GetPlayerPos(playerid, pos[0], pos[1], pos[2]);
	if(sscanf(params, "s[24]S()[128]", type, string))
	{
	    return Usage(playerid, "/race [names]") ,SendClientMessageEx(playerid, COLOR_BLUE, "NAMES: {FFFFFF}savecp(1-5), finishcp, invite, start, kick");
	}
	if(!strcmp(type, "savecp1", true))
	{
	    RaceData[playerid][racePos1][0] = pos[0];
	    RaceData[playerid][racePos1][1] = pos[1];
	    RaceData[playerid][racePos1][2] = pos[2];

	    SendMessage(playerid, "Checkpoint recorded!");
	}
	else if(!strcmp(type, "savecp2", true))
	{
	    RaceData[playerid][racePos2][0] = pos[0];
	    RaceData[playerid][racePos2][1] = pos[1];
	    RaceData[playerid][racePos2][2] = pos[2];

	    SendMessage(playerid, "Checkpoint recorded!");
	}
	else if(!strcmp(type, "savecp3", true))
	{
	    RaceData[playerid][racePos3][0] = pos[0];
	    RaceData[playerid][racePos3][1] = pos[1];
	    RaceData[playerid][racePos3][2] = pos[2];

	    SendMessage(playerid, "Checkpoint recorded!");
	}
	else if(!strcmp(type, "savecp4", true))
	{
	    RaceData[playerid][racePos4][0] = pos[0];
	    RaceData[playerid][racePos4][1] = pos[1];
	    RaceData[playerid][racePos4][2] = pos[2];

	    SendMessage(playerid, "Checkpoint recorded!");
	}
	else if(!strcmp(type, "savecp5", true))
	{
	    RaceData[playerid][racePos5][0] = pos[0];
	    RaceData[playerid][racePos5][1] = pos[1];
	    RaceData[playerid][racePos5][2] = pos[2];

	    SendMessage(playerid, "Checkpoint recorded!");
	}
	else if(!strcmp(type, "finishcp", true))
	{
	    RaceData[playerid][raceFinish][0] = pos[0];
	    RaceData[playerid][raceFinish][1] = pos[1];
	    RaceData[playerid][raceFinish][2] = pos[2];

	    SendMessage(playerid, "Finish checkpoint recorded!");
	}
	else if(!strcmp(type, "kick", true))
	{
	    new targetid;
	    if(sscanf(params, "u", targetid))
			return Usage(playerid, "/race [kick] [playerid/name]");

		if(!IsPlayerConnected(targetid))
        return Error(playerid, "Player not connected!");

		if(pData[targetid][pRaceWith] != playerid)
		    return Error(playerid, "That player is not on your race!");


		pData[targetid][pRaceWith] = INVALID_PLAYER_ID;
		pData[targetid][pRaceIndex] = 0;
		DisablePlayerRaceCheckpoint(targetid);
		SendMessage(playerid, "You've kick %s from your race!", ReturnName(targetid));
		SendMessage(targetid, "You've been kicked by %s from their race!", ReturnName(playerid));
	}
	else if(!strcmp(type, "invite", true))
	{
	    new targetid;
	    if(sscanf(string, "u", targetid))
			return Usage(playerid, "/race [invite] [playerid/name]");

		if(!IsPlayerConnected(targetid))
        return Error(playerid, "Player not connected!");

		if(pData[targetid][pRaceWith] != INVALID_PLAYER_ID)
		    return Error(playerid, "That player is already in any Race's!");

		if(pData[targetid][pRaceWith] == playerid)
		    return Error(playerid, "That player is already in your race!");

		pData[targetid][pRaceWith] = playerid;
		SendMessage(playerid, "You've invite %s to join your race!", ReturnName(targetid));
		SendMessage(targetid, "You've been invited by %s to join their race!", ReturnName(playerid));
	}
	else if(!strcmp(type, "start", true))
	{
	    if(RaceData[playerid][racePos1][0] == 0.0)
	        return Error(playerid, "You must record your CP's first!");

	    if(RaceData[playerid][racePos2][0] == 0.0)
	        return Error(playerid, "You must record your CP's first!");

	    if(RaceData[playerid][racePos3][0] == 0.0)
	        return Error(playerid, "You must record your CP's first!");

	    if(RaceData[playerid][racePos4][0] == 0.0)
	        return Error(playerid, "You must record your CP's first!");

	    if(RaceData[playerid][racePos5][0] == 0.0)
	        return Error(playerid, "You must record your CP's first!");

	    if(RaceData[playerid][raceFinish][0] == 0.0)
	        return Error(playerid, "You must record your Finish CP's first!");

		foreach(new i : Player) if(pData[i][pRaceWith] == playerid)
		{
		    SetRaceCP(i, 2, RaceData[pData[i][pRaceWith]][racePos1][0], RaceData[pData[i][pRaceWith]][racePos1][1], RaceData[pData[i][pRaceWith]][racePos1][2], 5.0);
			pData[i][pRaceIndex] = 1;
			GameTextForPlayer(i, "Race Started!", 3000, 5);
		}
	}
	return 1;
}
CMD:togtd(playerid, params[])
{
	new fmt_str[128];

    if(togtextdraws[playerid] == 0)
    {
        format(fmt_str, sizeof fmt_str,"{F6FE00}SERVER: {FFFFFF}Succesfuly Hide Textdraw.");
        SendClientMessage(playerid, -1, fmt_str);
        togtextdraws[playerid] = 1;
        //TextDrawHideForPlayer(playerid, ServerName);
		PlayerTextDrawHide(playerid, PlayerTXD[playerid][0]);
		PlayerTextDrawHide(playerid, PlayerTXD[playerid][1]);
		PlayerTextDrawHide(playerid, PlayerTXD[playerid][2]);
		PlayerTextDrawHide(playerid, PlayerTXD[playerid][3]);
	 	TextDrawHideForPlayer(playerid, Cent[0]);
     	TextDrawHideForPlayer(playerid, Cent[1]);
 	 	TextDrawHideForPlayer(playerid, TDTime[0]);
	 	TextDrawHideForPlayer(playerid, TDTime[1]);
    }
    else if(togtextdraws[playerid] == 1)
    {
        format(fmt_str, sizeof fmt_str,"{F6FE00}SERVER: {FFFFFF}Succesfuly Show Textdraw.");
        SendClientMessage(playerid, -1, fmt_str);
        togtextdraws[playerid] = 0;
        //TextDrawShowForPlayer(playerid, ServerName);
		PlayerTextDrawShow(playerid, PlayerTXD[playerid][0]);
		PlayerTextDrawShow(playerid, PlayerTXD[playerid][1]);
		PlayerTextDrawShow(playerid, PlayerTXD[playerid][2]);
		PlayerTextDrawShow(playerid, PlayerTXD[playerid][3]);
	 	TextDrawShowForPlayer(playerid, Cent[0]);
     	TextDrawShowForPlayer(playerid, Cent[1]);
 	 	TextDrawShowForPlayer(playerid, TDTime[0]);
	 	TextDrawShowForPlayer(playerid, TDTime[1]);
    }
    return 1;
}
CMD:showpass(playerid, params[])
{
    if(pData[playerid][pIDCard] == 0) return Error(playerid, "Anda tidak memiliki id card!");
	new otherid;
	if(sscanf(params, "d", otherid)) return Usage(playerid, "/showpass <Playerid>");

    new waktu = pData[playerid][pIDCardTime];

    new pus[300];
    format(pus, sizeof pus, "%s", pData[playerid][pName]);
    PlayerTextDrawSetString(otherid, KTPTD[11][playerid], pus);

    new puss[300];
    format(pus, sizeof puss, "%s", pData[playerid][pName]);
    PlayerTextDrawSetString(otherid, KTPTD[4][playerid], puss);

    new date[300];
    format(date, sizeof date, "%s", pData[playerid][pAge]);
    PlayerTextDrawSetString(otherid, KTPTD[13][playerid], date);

    PlayerTextDrawSetPreviewModel(otherid, KTPTD[7][playerid], pData[playerid][pSkin]);

    new t[300];
    format(t, sizeof t, "%s", waktu);
    PlayerTextDrawSetString(otherid, KTPTD[14][playerid], t);

    new sext[40];
	if(pData[playerid][pGender] == 1) { sext = "Male"; } else { sext = "Female"; }
    new y[300];
    format(y, sizeof y, "%s", sext);
    PlayerTextDrawSetString(otherid, KTPTD[10][playerid], y);

	for(new i =0 ; i < 15; i++)
	{
		PlayerTextDrawShow(otherid, KTPTD[i][playerid]);
	}
	return 1;
}

CMD:unstuckme(playerid, params[])
{
    pData[playerid][pFreeze] = 0;
    TogglePlayerControllable(playerid, 1);
    Info(playerid, "Berhasil");
    return 1;
}

CMD:backpass(playerid, params[])
{
	for(new i =0 ; i < 15; i++)
	{
		PlayerTextDrawHide(playerid, KTPTD[i][playerid]);
	}
	SendNearbyMessage(playerid, 20.0, COLOR_PURPLE, "%s Mengembalikan ID Card Ke Orang Di Depan Dengan Kedua Tangan.", pData[playerid][pName]);
	return 1;
}
