//ACT BARU
stock UpdateLoading(playerid)
{
	new Float:value;
	value = pData[playerid][pActivityTime] * 88.5/100;
	PlayerTextDrawTextSize(playerid, Loading[1][playerid], value, 15.5);
	PlayerTextDrawShow(playerid, Loading[1][playerid]);
	return 1;
}

function ForkliftTake(playerid)
{
    if(!IsValidTimer(pData[playerid][pActivity])) return 0;
	{
		if(pData[playerid][pActivityTime] >= 100)
		{
			InfoTD_MSG(playerid, 8000, "Done!");
			KillTimer(pData[playerid][pActivity]);
			pData[playerid][pActivityTime] = 0;
			for(new i =0 ; i < 3; i++)
			{
				PlayerTextDrawHide(playerid, Loading[i][playerid]);
			}
			pData[playerid][pEnergy] -= 3;
			TogglePlayerControllable(playerid, 1);

			SetPVarInt(playerid, "box", CreateDynamicObject(2912,0,0,0,0,0,0));
			AttachDynamicObjectToVehicle(GetPVarInt(playerid, "box"), GetPlayerVehicleID(playerid), -0.10851, 0.62915, -0.013238, 0.0, 0.0, 0.0);
			return 1;
		}
		else if(pData[playerid][pActivityTime] < 100)
		{
			pData[playerid][pActivityTime] += 5;
			UpdateLoading(playerid);
		}
	}
	return 1;
}

function ForkliftDown(playerid)
{
    if(!IsValidTimer(pData[playerid][pActivity])) return 0;
	{
		if(pData[playerid][pActivityTime] >= 100)
		{
			InfoTD_MSG(playerid, 8000, "Done!");
			KillTimer(pData[playerid][pActivity]);
			pData[playerid][pActivityTime] = 0;
			for(new i =0 ; i < 3; i++)
			{
				PlayerTextDrawHide(playerid, Loading[i][playerid]);
			}
			pData[playerid][pEnergy] -= 3;
			TogglePlayerControllable(playerid, 1);
			DestroyDynamicObject(GetPVarInt(playerid, "box"));
			return 1;
		}
		else if(pData[playerid][pActivityTime] < 100)
		{
			pData[playerid][pActivityTime] += 5;
			UpdateLoading(playerid);
		}
	}
	return 1;
}

function FillElectric(playerid)
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
			pData[playerid][pEnergy] -= 3;
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

function ContainerTake(playerid)
{
    if(!IsValidTimer(pData[playerid][pActivity])) return 0;
	{
		if(pData[playerid][pActivityTime] >= 100)
		{
			InfoTD_MSG(playerid, 8000, "Done!");
			KillTimer(pData[playerid][pActivity]);
			pData[playerid][pActivityTime] = 0;
			for(new i =0 ; i < 3; i++)
			{
				PlayerTextDrawHide(playerid, Loading[i][playerid]);
			}
			pData[playerid][pEnergy] -= 5;
			TogglePlayerControllable(playerid, 1);

			SetPVarInt(playerid, "container", CreateDynamicObject(2935,0,0,0,0,0,0));
			AttachDynamicObjectToVehicle(GetPVarInt(playerid, "container"), GetPlayerVehicleID(playerid), 0.000, -1.009, 1.090, 0.000, 0.000, 0.000);
			return 1;
		}
		else if(pData[playerid][pActivityTime] < 100)
		{
			pData[playerid][pActivityTime] += 5;
			UpdateLoading(playerid);
		}
	}
	return 1;
}

function ContainerDown(playerid)
{
    if(!IsValidTimer(pData[playerid][pActivity])) return 0;
	{
		if(pData[playerid][pActivityTime] >= 100)
		{
			InfoTD_MSG(playerid, 8000, "Done!");
			KillTimer(pData[playerid][pActivity]);
			pData[playerid][pActivityTime] = 0;
			for(new i =0 ; i < 3; i++)
			{
				PlayerTextDrawHide(playerid, Loading[i][playerid]);
			}
			pData[playerid][pEnergy] -= 5;
			TogglePlayerControllable(playerid, 1);
			DestroyDynamicObject(GetPVarInt(playerid, "container"));
			return 1;
		}
		else if(pData[playerid][pActivityTime] < 100)
		{
			pData[playerid][pActivityTime] += 5;
			UpdateLoading(playerid);
		}
	}
	return 1;
}
function PotongRumput(playerid)
{
    if(!IsValidTimer(pData[playerid][pActivity])) return 0;
	{
		if(pData[playerid][pActivityTime] >= 100)
		{
			InfoTD_MSG(playerid, 8000, "Mowed Grass!");
			KillTimer(pData[playerid][pActivity]);
			pData[playerid][pActivityTime] = 0;
			HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
			PlayerTextDrawHide(playerid, ActiveTD[playerid]);
			pData[playerid][pEnergy] -= 3;
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

function LoadingSprunk(playerid)
{
	if(!IsValidTimer(pData[playerid][pActivity])) return 0;
	{
	 	if(pData[playerid][pActivityTime] >= 100)
		{
			KillTimer(pData[playerid][pActivity]);
			for(new i =0 ; i < 3; i++)
			{
				PlayerTextDrawHide(playerid, Loading[i][playerid]);
			}
			pData[playerid][pActivityTime] = 0;
			pData[playerid][pSprunk] -= 1;
			pData[playerid][pEnergy] += 30;
			pData[playerid][pTrash] += 1;
			InfoTD_MSG(playerid, 3000, "Restore +15 Energy");
			ClearAnimations(playerid);
			StopLoopingAnim(playerid);
			SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
			return 1;
		}
		else if(pData[playerid][pActivityTime] < 100)
		{	
			pData[playerid][pActivityTime] += 10;
			UpdateLoading(playerid);
			ApplyAnimation(playerid, "BAR", "dnk_stndM_loop", 4.1, 1, 0, 0, 0, 0, 0);
		}
	}
	return 1;
}

function LoadingSnack(playerid)
{
	if(!IsValidTimer(pData[playerid][pActivity])) return 0;
	{
	 	if(pData[playerid][pActivityTime] >= 100)
		{
			KillTimer(pData[playerid][pActivity]);
			for(new i =0 ; i < 3; i++)
			{
				PlayerTextDrawHide(playerid, Loading[i][playerid]);
			}
			pData[playerid][pActivityTime] = 0;
			pData[playerid][pSnack] -= 1;
			pData[playerid][pHunger] += 15;
			pData[playerid][pTrash] += 1;
			InfoTD_MSG(playerid, 3000, "Restore +15 Hunger");
			ClearAnimations(playerid);
			StopLoopingAnim(playerid);
			return 1;
		}
		else if(pData[playerid][pActivityTime] < 100)
		{	
			pData[playerid][pActivityTime] += 10;
			UpdateLoading(playerid);
			ApplyAnimation(playerid, "BAR", "dnk_stndM_loop", 4.1, 0, 0, 0, 0, 0, 0);
		}
	}
	return 1;
}
function LoadingBandage(playerid)
{
	if(!IsValidTimer(pData[playerid][pActivity])) return 0;
	{
	 	if(pData[playerid][pActivityTime] >= 100)
		{
			KillTimer(pData[playerid][pActivity]);
			pData[playerid][pActivityTime] = 0;
			for(new i =0 ; i < 3; i++)
			{
				PlayerTextDrawHide(playerid, Loading[i][playerid]);
			}
			new Float:darah;
			GetPlayerHealth(playerid, darah);
			pData[playerid][pBandage]--;
			SetPlayerHealthEx(playerid, darah+10);
			Info(playerid, "Anda telah berhasil menggunakan perban.");
			InfoTD_MSG(playerid, 3000, "Restore +15 Health");
			ClearAnimations(playerid);
			StopLoopingAnim(playerid);
			return 1;
		}
		else if(pData[playerid][pActivityTime] < 100)
		{	
			pData[playerid][pActivityTime] += 5;
			UpdateLoading(playerid);
			ApplyAnimation(playerid, "BOMBER","BOM_Plant_Loop",4.0, 0, 0, 0, 0, 0, 1); // Place Bomb
		}
	}
	return 1;
}
function LoadingLogin(playerid)
{
	if(!IsValidTimer(pData[playerid][pActivity])) return 0;
	{
	 	if(pData[playerid][pActivityTime] >= 100)
		{
			KillTimer(pData[playerid][pActivity]);
			pData[playerid][pActivityTime] = 0;
			for(new i =0 ; i < 3; i++)
			{
				PlayerTextDrawHide(playerid, Loading[i][playerid]);
			}
			return 1;
		}
		else if(pData[playerid][pActivityTime] < 100)
		{	
			pData[playerid][pActivityTime] += 1;
			UpdateLoading(playerid);
		}
	}
	return 1;
}

function LoadingTrash(playerid)
{
	if(!IsValidTimer(pData[playerid][pActivity])) return 0;
	{
	 	if(pData[playerid][pActivityTime] >= 100)
		{
			KillTimer(pData[playerid][pActivity]);
			pData[playerid][pActivityTime] = 0;
			for(new i =0 ; i < 3; i++)
			{
				PlayerTextDrawHide(playerid, Loading[i][playerid]);
			}
			pData[playerid][pTrash] -= 10;
			GivePlayerMoneyEx(playerid, 550);
			Servers(playerid, "Kamu Telah membuang sampah ke tempatnya dan mendapatkan uang {00FF00}$5.50!");
			ClearAnimations(playerid);
			StopLoopingAnim(playerid);
			return 1;
		}
		else if(pData[playerid][pActivityTime] < 100)
		{	
			pData[playerid][pActivityTime] += 5;
			UpdateLoading(playerid);
			ApplyAnimation(playerid,"BD_FIRE","wash_up",4.0, 1, 0, 0, 0, 0, 1);
		}
	}
	return 1;
}

function CreateGun(playerid, gunid, ammo)
{
	if(!IsPlayerConnected(playerid)) return 0;
	if(!IsValidTimer(pData[playerid][pArmsDealer])) return 0;
	if(gunid == 0 || ammo == 0) return 0;
	if(pData[playerid][pActivityTime] >= 100)
	{
		GivePlayerWeaponEx(playerid, gunid, ammo);
		
		Info(playerid, "Anda telah berhasil membuat senjata ilegal.");
		TogglePlayerControllable(playerid, 1);
		InfoTD_MSG(playerid, 8000, "Weapon Created!");
		KillTimer(pData[playerid][pArmsDealer]);
		pData[playerid][pActivityTime] = 0;
		for(new i =0 ; i < 3; i++)
		{
			PlayerTextDrawHide(playerid, Loading[i][playerid]);
		}
		pData[playerid][pEnergy] -= 3;
		//playerid
		PlayerTextDrawSetString(playerid, ITEMSNAME[playerid], "Waapon");
		PlayerTextDrawSetString(playerid, Received[playerid], "Received");
		PlayerTextDrawSetPreviewModel(playerid, MODELITEM[playerid], 3014);
		PlayerTextDrawShow(playerid, ITEMSBOX[0][playerid]);
		PlayerTextDrawShow(playerid, ITEMSBOX[1][playerid]);
		PlayerTextDrawShow(playerid, Received[playerid]);
		PlayerTextDrawShow(playerid, ITEMSNAME[playerid]);
		PlayerTextDrawShow(playerid, MODELITEM[playerid]);
		SetTimerEx("ItemsBoxtimer", 5500, false, "i", playerid);
		return 1;
	}
	else if(pData[playerid][pActivityTime] < 100)
	{
		pData[playerid][pActivityTime] += 5;
		UpdateLoading(playerid);
		ApplyAnimation(playerid, "BD_FIRE", "wash_up", 4.1, 0, 0, 0, 0, 0, 1);
	}
	return 1;
}
function CreateAmmo(playerid, gunid, ammo)
{
	if(!IsPlayerConnected(playerid)) return 0;
	if(!IsValidTimer(pData[playerid][pArmsDealer])) return 0;
	//if(gunid == 0 || ammo == 0) return 0;
	if(pData[playerid][pActivityTime] >= 100)
	{
		GivePlayerWeaponEx(playerid, gunid, ammo);
		
		Info(playerid, "Anda telah berhasil membuat Ammo.");
		TogglePlayerControllable(playerid, 1);
		InfoTD_MSG(playerid, 8000, "Ammo Created!");
		KillTimer(pData[playerid][pArmsDealer]);
		pData[playerid][pActivityTime] = 0;
		for(new i =0 ; i < 3; i++)
		{
			PlayerTextDrawHide(playerid, Loading[i][playerid]);
		}
		pData[playerid][pEnergy] -= 3;
		//playerid
		PlayerTextDrawSetString(playerid, ITEMSNAME[playerid], "Ammo");
		PlayerTextDrawSetString(playerid, Received[playerid], "Received");
		PlayerTextDrawSetPreviewModel(playerid, MODELITEM[playerid], 2358);
		PlayerTextDrawShow(playerid, ITEMSBOX[0][playerid]);
		PlayerTextDrawShow(playerid, ITEMSBOX[1][playerid]);
		PlayerTextDrawShow(playerid, Received[playerid]);
		PlayerTextDrawShow(playerid, ITEMSNAME[playerid]);
		PlayerTextDrawShow(playerid, MODELITEM[playerid]);
		SetTimerEx("ItemsBoxtimer", 5500, false, "i", playerid);
		return 1;
	}
	else if(pData[playerid][pActivityTime] < 100)
	{
		pData[playerid][pActivityTime] += 5;
		UpdateLoading(playerid);
		ApplyAnimation(playerid, "BD_FIRE", "wash_up", 4.1, 0, 0, 0, 0, 0, 1);
	}
	return 1;
}
function CreateMegazine(playerid)
{
	if(!IsPlayerConnected(playerid)) return 0;
	if(!IsValidTimer(pData[playerid][pArmsDealer])) return 0;
	if(pData[playerid][pActivityTime] >= 100)
	{
		new Kjs[256];
		format(Kjs, sizeof(Kjs), "Megazine/%s.txt", pData[playerid][pName]);
		if(!dini_Exists(Kjs))
  		{
  			new Kj[256];
		    format(Kj, sizeof(Kj), "Megazine/%s.txt", pData[playerid][pName]);
      		dini_Create(Kj);
    		Info(playerid, "Anda telah berhasil membuat Megazine.");
			TogglePlayerControllable(playerid, 1);
			InfoTD_MSG(playerid, 8000, "Ammo Megazine!");
			KillTimer(pData[playerid][pArmsDealer]);
			pData[playerid][pActivityTime] = 0;
			for(new i =0 ; i < 3; i++)
			{
				PlayerTextDrawHide(playerid, Loading[i][playerid]);
			}
			pData[playerid][pEnergy] -= 3;
  		}
  		else
  		{
  			Error(playerid, "Your Already Have 1 Magazine!");
  			Error(playerid, "Semua Component, Material, Money Di Kembalikan!");
  			TogglePlayerControllable(playerid, 1);
			InfoTD_MSG(playerid, 8000, "Ammo Megazine!");
			KillTimer(pData[playerid][pArmsDealer]);
			pData[playerid][pActivityTime] = 0;
			pData[playerid][pMaterial] += 20;
			pData[playerid][pComponent] += 20;
			GivePlayerMoneyEx(playerid, 10000);
			for(new i =0 ; i < 3; i++)
			{
				PlayerTextDrawHide(playerid, Loading[i][playerid]);
			}
		}
		return 1;
	}
	else if(pData[playerid][pActivityTime] < 100)
	{
		pData[playerid][pActivityTime] += 5;
		UpdateLoading(playerid);
		ApplyAnimation(playerid, "BD_FIRE", "wash_up", 4.1, 0, 0, 0, 0, 0, 1);
	}
	return 1;
}