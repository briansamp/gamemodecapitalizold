CreateJoinCleaningPoint()
{
	//JOBS
	new strings[128];
	CreateDynamicPickup(1239, 23, 2070.6267,-1793.8580,13.5469, -1);
	format(strings, sizeof(strings), "[CLEANER JOBS]\n{FFFFFF}/joinjob to join");
	CreateDynamic3DTextLabel(strings, COLOR_YELLOW, 2070.6267,-1793.8580,13.5469, 3.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1); // Taxi
}


CMD:clean(playerid, params[])
{
	new bid = pData[playerid][pInBiz];
	if(pData[playerid][pCleanTime] > 0) return Error(playerid, "You must be waiting "YELLOW_E"%d "GREY_E"second again to begin jobs.", pData[playerid][pCleanTime]);
	if(pData[playerid][pCleanTools] < 1) return Error(playerid, "You don't have ToolsCleaner, Visit 24/7 to purchased.");

	if(bData[bid][bClean] == 1) return Error(playerid, "Bisnis ini sudah bersih");
	if(pData[playerid][pJob] == 9 || pData[playerid][pJob2] == 9)
	if(pData[playerid][pInBiz] > -1)
	{
		pData[playerid][pActivity] = SetTimerEx("Clean", 1800, true, "i", playerid);

		PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Cleaning...");
		PlayerTextDrawShow(playerid, ActiveTD[playerid]);
		ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
		TogglePlayerControllable(playerid, 0);
		ApplyAnimation(playerid, "BOMBER","BOM_Plant_Loop",4.1, 1, 1, 1, 1, 1, 1);
	}	
	else 
	{
		Error(playerid, "Anda bukan pekerja sebagai Pemberih.");
	}	
	return 1;
}


function Clean(playerid)
{
    new bid = pData[playerid][pInBiz];
    if(!IsValidTimer(pData[playerid][pActivity])) return 0;
	{
	    if(pData[playerid][pActivityTime] >= 100)
	    {
		    {
		    	InfoTD_MSG(playerid, 8000, "Cleaning ~g~Succesfully!");
		    	TogglePlayerControllable(playerid, 1);
		    	HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
				PlayerTextDrawHide(playerid, ActiveTD[playerid]);
				KillTimer(pData[playerid][pActivity]);
				pData[playerid][pHunger] -= 5;
				pData[playerid][pEnergy] -= 8;
				pData[playerid][pActivityTime] = 0;
				bData[bid][bClean] = 1;
				pData[playerid][pCleanTime] += 500;
				bData[bid][bCleanTime] = gettime() + (1 * 16400);
		        Bisnis_Save(bid);
		        Bisnis_Refresh(bid);
		        pData[playerid][pCleanTools] -= 1;
				ClearAnimations(playerid);
				pData[playerid][pCleanSkill] += 1;
				
				new Cleaning = Random(40000, 60000);
				if(pData[playerid][pCleanSkill] == 5)
				{
		        GivePlayerMoneyEx(playerid, 20000);
		        Info(playerid, "Bonus Junior skill "GREEN_E"$200.00");

				}
				else if(pData[playerid][pCleanSkill] == 20)
				{
		        GivePlayerMoneyEx(playerid, 40000);
		        Info(playerid, "Bonus Senior skill "GREEN_E"$400.00");

				}
				else if(pData[playerid][pCleanSkill] >= 50)
				{
				new kontol = Random(50000, 75000);
		        GivePlayerMoneyEx(playerid, kontol);
		        Info(playerid, "Anda berhasil membersihkan , Anda diberi uang "GREEN_E"$%s", FormatMoney(kontol));
				return 0;
			    }
				else if(pData[playerid][pCleanSkill] == 70)
				{
		        pData[playerid][pCleanSkill] = 55;
			    }
				GivePlayerMoneyEx(playerid, Cleaning);
               	bData[bid][bMoney] -= Cleaning;
		    	Info(playerid, "Anda berhasil membersihkan , Anda diberi uang "GREEN_E"$%s", FormatMoney(Cleaning));
			}
		}
	 	else if(pData[playerid][pActivityTime] < 100)
		{
            ClearAnimations(playerid);
		   	pData[playerid][pActivityTime] += 5;
			SetPlayerProgressBarValue(playerid, pData[playerid][activitybar], pData[playerid][pActivityTime]);
		   	PlayerPlaySound(playerid, 1053, 0.0, 0.0, 0.0);
		}
	}
	return 1;
}

