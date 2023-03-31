CMD:prosesborax(playerid, params[])
{
    if(IsPlayerInRangeOfPoint(playerid, 3.0, -347.8703,-1045.7944,59.8125))
	{
		if(pData[playerid][pActivityTime] > 5) return Error(playerid, "Anda tidak dapat melakukannya sekarang");
		if(pData[playerid][pBorax] < 5) return Error(playerid, "Setidaknya Anda Harus Membawa 5kg Borax!.");
			
	    TogglePlayerControllable(playerid, 0);
		ApplyAnimation(playerid, "BD_FIRE", "wash_up", 4.1, 0, 0, 0, 0, 0, 1);
		pData[playerid][pProsesBorax] = SetTimerEx("Proses", 1000, true, "id", playerid, 3);
		PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Proses...");
		PlayerTextDrawShow(playerid, ActiveTD[playerid]);
		ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
	}
	else return Error(playerid, "Anda tidak ditempat proses Borax");
	return 1;
}

function Proses(playerid, type)
{
	if(!IsPlayerConnected(playerid)) return 0;
	if(!IsValidTimer(pData[playerid][pProsesBorax])) return 0;
	{
		if(pData[playerid][pActivityTime] >= 100)
		{
			if(IsPlayerInRangeOfPoint(playerid, 3.0, -347.8703,-1045.7944,59.8125))
			{
				if(pData[playerid][pActivityTime] >= 100)
				{
					Info(playerid, "Anda berhasil memproses Borax");
					pData[playerid][pBorax] -=5;
					pData[playerid][pPaketBorax] +=10;
					TogglePlayerControllable(playerid, 1);
					KillTimer(pData[playerid][pProsesBorax]);
					pData[playerid][pActivityTime] = 0;
					HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
					PlayerTextDrawHide(playerid, ActiveTD[playerid]);
					pData[playerid][pEnergy] -= 3;
					ClearAnimations(playerid);
				}
				else
				{
					KillTimer(pData[playerid][pProsesBorax]);
					pData[playerid][pActivityTime] = 0;
					HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
					PlayerTextDrawHide(playerid, ActiveTD[playerid]);
					return 1;
				}
			}
		}
		else if(pData[playerid][pActivityTime] < 100)
		{
            if(IsPlayerInRangeOfPoint(playerid, 3.0, -347.8703,-1045.7944,59.8125))
			{
				pData[playerid][pActivityTime] += 5;
				SetPlayerProgressBarValue(playerid, pData[playerid][activitybar], pData[playerid][pActivityTime]);
				ApplyAnimation(playerid, "BD_FIRE", "wash_up", 4.1, 0, 0, 0, 0, 0, 1);
			}
		}
	}
	return 1;
}

CMD:jualborax(playerid, params[])
{
	if(!IsPlayerInRangeOfPoint(playerid, 3.0, 1513.2206,21.2324,24.1406))
		return Error(playerid, "Anda harus di tempat penjualan Borax");
		
	if(pData[playerid][pPaketBorax] < 5)
		return Error(playerid, "Anda tidak dapat menjual paket Borax kurang dari 5pcs");
		
    //if(pData[playerid][pFamily] != -1)
 	    //return Error(playerid, "Hanya Family Yang Bisa Menjual Paket Borax");
    if(pData[playerid][pFamily] != -1)
	{
		pData[playerid][pRedMoney] += 25000;
		pData[playerid][pPaketBorax] -= 5;
		SendClientMessage(playerid, COLOR_LBLUE, "INFO: "WHITE_E"Anda telah menjual Borax dan mendapatkan "GREEN_E"$250.00 uang kotor");

	    ApplyAnimation(playerid, "DEALER", "shop_pay", 4.0, 0, 0, 0, 0, 0);
	}
	else
	{
		Error(playerid, "You don't have permission to sell the borax!");
	}
	/*pData[playerid][pRedMoney] += 100000;
	pData[playerid][pPaketBorax] -= 5;
	SendClientMessage(playerid, COLOR_LBLUE, "INFO: "WHITE_E"Anda telah menjual Borax dan mendapatkan "GREEN_E"$1.000.00");

    ApplyAnimation(playerid, "DEALER", "shop_pay", 4.0, 0, 0, 0, 0, 0);*/
	return 1;
}

CMD:cuciuang(playerid, params[])
{
	if(!IsPlayerInRangeOfPoint(playerid, 3.0, -2819.71,-1516.75,140.84))
		return Error(playerid, "Anda harus di tempat pencucian Uang !");

	if(pData[playerid][pRedMoney] < 100000)
		return Error(playerid, "Minimal membawa $1.000.00 uang merah");

	pData[playerid][pRedMoney] -= 100000;
	GivePlayerMoneyEx(playerid, 80000);

	SendClientMessage(playerid, COLOR_LBLUE, "INFO: "WHITE_E"Anda telah menukarkan "RED_E"$1.000.00 uang merah menjadi "GREEN_E"$800.00 uang bersih");

    ApplyAnimation(playerid, "DEALER", "shop_pay", 4.0, 0, 0, 0, 0, 0);
	return 1;
}

CMD:borax(playerid, params[])
{
	if(pData[playerid][pFamily] != -1)
	{
	    if(IsPlayerInRangeOfPoint(playerid, 106,-1079.7341,-973.8702,129.2188))
		{
	        if(pData[playerid][pActivityTime] > 5) return Error(playerid, "Anda tidak dapat melakukannya sekarang");
			if(pData[playerid][pBorax] > 19) return Error(playerid, "Anda tidak dapat membawa lebih dari 20 borax");
			
		    TogglePlayerControllable(playerid, 0);
			ApplyAnimation(playerid, "BD_FIRE", "wash_up", 4.1, 0, 0, 0, 0, 0, 1);
			pData[playerid][pGetBorax] = SetTimerEx("Borax", 1000, true, "id", playerid, 3);
			PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Mengambil...");
			PlayerTextDrawShow(playerid, ActiveTD[playerid]);
			ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
		}
		else return Error(playerid, "Anda tidak ditempat ladang borax");
	}
	else
	{
		Error(playerid, "You don't have permission to take the borax!");
	}
	return 1;
}

function Borax(playerid, type)
{
	if(!IsPlayerConnected(playerid)) return 0;
	if(!IsValidTimer(pData[playerid][pGetBorax])) return 0;
	{
		if(pData[playerid][pActivityTime] >= 100)
			{
				if(pData[playerid][pActivityTime] >= 100)
				{
					Info(playerid, "Anda berhasil mengambil borax");
					pData[playerid][pBorax] +=2;
					TogglePlayerControllable(playerid, 1);
					KillTimer(pData[playerid][pGetBorax]);
					pData[playerid][pActivityTime] = 0;
					HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
					PlayerTextDrawHide(playerid, ActiveTD[playerid]);
					pData[playerid][pEnergy] -= 3;
					ClearAnimations(playerid);
					PlayerTextDrawSetString(playerid, ITEMSNAME[playerid], "Borax");
					PlayerTextDrawSetString(playerid, Received[playerid], "Received");
					PlayerTextDrawSetPreviewModel(playerid, MODELITEM[playerid], 854);
					PlayerTextDrawShow(playerid, ITEMSBOX[0][playerid]);
					PlayerTextDrawShow(playerid, ITEMSBOX[1][playerid]);
					PlayerTextDrawShow(playerid, Received[playerid]);
					PlayerTextDrawShow(playerid, ITEMSNAME[playerid]);
					PlayerTextDrawShow(playerid, MODELITEM[playerid]);
					SetTimerEx("ItemsBoxtimer", 5500, false, "i", playerid);
				}
				else
				{
					KillTimer(pData[playerid][pGetBorax]);
					pData[playerid][pActivityTime] = 0;
					HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
					PlayerTextDrawHide(playerid, ActiveTD[playerid]);
					return 1;
				}
			}
		else if(pData[playerid][pActivityTime] < 100)
		{
            if(IsPlayerInRangeOfPoint(playerid, 106,-1079.7341,-973.8702,129.2188))
			{
				pData[playerid][pActivityTime] += 5;
				SetPlayerProgressBarValue(playerid, pData[playerid][activitybar], pData[playerid][pActivityTime]);
				ApplyAnimation(playerid, "BOMBER","BOM_Plant_Loop",4.0, 1, 0, 0, 0, 0, 1);
			}
		}
	}
	return 1;
}
