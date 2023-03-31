#define		SCM					SendClientMessage
new pCargo[MAX_PLAYERS];
new pPurchaseCargoMeat[MAX_PLAYERS];
new pPurchaseCargoSeed[MAX_PLAYERS];

new vCargoObj1[MAX_VEHICLES];
new vCargoObj2[MAX_VEHICLES];
new ObjetoC[MAX_PLAYERS];
new ObjetoC1[MAX_PLAYERS];

forward CargoMeat(playerid);
public CargoMeat(playerid)
{
    new name[24], string[200];
	TogglePlayerControllable(playerid,1);
	pCargo[playerid] = 1;
    ClearAnimations(playerid);
    ApplyAnimation(playerid, "CARRY", "crry_prtial", 4.1, 1, 1, 1, 1, 1, 1);
    SetPlayerAttachedObject(playerid, 0, 2912, 1, 0.436000, 0.519000, -0.342000, 0.000000, 0.000000, 0.000000, 1.000000,1.000000,1.000000);
	pPurchaseCargoMeat[playerid]++;
	SCM(playerid, COLOR_JOB, "TRUCKER:"WHITE_E"You Have purchase a Cargo of "YELLOW_E"Meat "WHITE_E"for "GREEN_E"$5");
    GetPlayerName(playerid, name, 24);
	format(string, 64, "* %s Gets Up a Cargo for both hands", name);
	SendRangedMessage(playerid, COLOR_PURPLE, string, 50);
	return 1;
}

forward CargoSeed(playerid);
public CargoSeed(playerid)
{
    new name[24], string[200];
	pCargo[playerid] = 1;
    ClearAnimations(playerid);
    ApplyAnimation(playerid, "CARRY", "crry_prtial", 4.1, 1, 1, 1, 1, 1, 1);
    SetPlayerAttachedObject(playerid, 0, 2912, 1, 0.436000, 0.519000, -0.342000, 0.000000, 0.000000, 0.000000, 1.000000,1.000000,1.000000);
	pPurchaseCargoSeed[playerid]++;
	SCM(playerid, COLOR_JOB, "TRUCKER:"WHITE_E"You Have purchase a Cargo of "YELLOW_E"Seed "WHITE_E"for "GREEN_E"$5");
    GetPlayerName(playerid, name, 24);
	format(string, 64, "* %s Gets Up a Cargo for both hands", name);
	SendRangedMessage(playerid, COLOR_PURPLE, string, 50);
	return 1;
}

GetHaulingCveh(carid)
{
	if(GetVehicleModel(carid) == 422 || GetVehicleModel(carid) == 499|| GetVehicleModel(carid) == 554)
	{
		return 1;
	}
	return 0;
}

vMbobcat(carid)
{
    if(GetVehicleModel(carid) == 422)
	{
		return 1;
	}
	return 0;
}

vMbenson(carid)
{
    if(GetVehicleModel(carid) == 499)
	{
		return 1;
	}
	return 0;
}

vMyosemite(carid)
{
    if(GetVehicleModel(carid) == 554)
	{
		return 1;
	}
	return 0;
}

forward csellmeat(playerid);
public csellmeat(playerid)
{
    new rand = random(5);
	switch(rand)
	{
	    case 0:
	    {
			AddPlayerSalary(playerid, "Job(Hauling Meat Cargo)", 5000);
			SCM(playerid, COLOR_JOB, "HAULING: {FFFFFF}$50.00 have been issued to your paycheck");
			ClearAnimations(playerid);
			pData[playerid][pSideJobTime] += 30*30;
			ApplyAnimation(playerid, "CARRY", "crry_prtial", 4.1, 1, 1, 1, 1, 1, 1);
			pCargo[playerid] = 0;
		}
		case 1:
		{
		    AddPlayerSalary(playerid, "Job(Hauling Meat Cargo)", 5000);
			SCM(playerid, COLOR_JOB, "HAULING: {FFFFFF}$50.00 have been issued to your paycheck");
			ClearAnimations(playerid);
			pData[playerid][pSideJobTime] += 30*30;
			ApplyAnimation(playerid, "CARRY", "crry_prtial", 4.1, 1, 1, 1, 1, 1, 1);
			pCargo[playerid] = 0;
		}
		case 2:
		{
		    AddPlayerSalary(playerid, "Job(Hauling Meat Cargo)", 5000);
			SCM(playerid, COLOR_JOB, "HAULING: {FFFFFF}$50.00 have been issued to your paycheck");
			ClearAnimations(playerid);
			pData[playerid][pSideJobTime] += 30*30;
			ApplyAnimation(playerid, "CARRY", "crry_prtial", 4.1, 1, 1, 1, 1, 1, 1);
			pCargo[playerid] = 0;
		}
	    case 3:
		{
  			AddPlayerSalary(playerid, "Job(Hauling Meat Cargo)", 5000);
			SCM(playerid, COLOR_JOB, "HAULING: {FFFFFF}$50.00 have been issued to your paycheck");
			ClearAnimations(playerid);
			pData[playerid][pSideJobTime] += 30*30;
			ApplyAnimation(playerid, "CARRY", "crry_prtial", 4.1, 1, 1, 1, 1, 1, 1);
			pCargo[playerid] = 0;
		}
		case 4:
		{
		    AddPlayerSalary(playerid, "Job(Hauling Meat Cargo)", 5000);
			SCM(playerid, COLOR_JOB, "HAULING: {FFFFFF}$50.00 have been issued to your paycheck");
			ClearAnimations(playerid);
			pData[playerid][pSideJobTime] += 30*30;
			ApplyAnimation(playerid, "CARRY", "crry_prtial", 4.1, 1, 1, 1, 1, 1, 1);
			pCargo[playerid] = 0;
		}
	}
	return 1;
}

forward csellmat(playerid);
public csellmat(playerid)
{
    new rand = random(5);
	switch(rand)
	{
	    case 0:
	    {
			AddPlayerSalary(playerid, "Job(Hauling Seed Cargo)", 35);
			SCM(playerid, COLOR_JOB, "HAULING: {FFFFFF}$35 have been issued to your paycheck");
			ClearAnimations(playerid);
			pData[playerid][pSideJobTime] += 30*30;
			ApplyAnimation(playerid, "CARRY", "crry_prtial", 4.1, 1, 1, 1, 1, 1, 1);
			pCargo[playerid] = 0;
		}
		case 1:
		{
		    AddPlayerSalary(playerid, "Job(Hauling Seed Cargo)", 35);
			SCM(playerid, COLOR_JOB, "HAULING: {FFFFFF}$35 have been issued to your paycheck");
			ClearAnimations(playerid);
			pData[playerid][pSideJobTime] += 30*30;
			ApplyAnimation(playerid, "CARRY", "crry_prtial", 4.1, 1, 1, 1, 1, 1, 1);
			pCargo[playerid] = 0;
		}
		case 2:
		{
		    AddPlayerSalary(playerid, "Job(Hauling Seed Cargo)", 35);
			SCM(playerid, COLOR_JOB, "HAULING: {FFFFFF}$35 have been issued to your paycheck");
			ClearAnimations(playerid);
			pData[playerid][pSideJobTime] += 30*30;
			ApplyAnimation(playerid, "CARRY", "crry_prtial", 4.1, 1, 1, 1, 1, 1, 1);
			pCargo[playerid] = 0;
		}
	    case 3:
		{
	        AddPlayerSalary(playerid, "Job(Hauling Seed Cargo)", 35);
			SCM(playerid, COLOR_JOB, "HAULING: {FFFFFF}$35 have been issued to your paycheck");
			ClearAnimations(playerid);
			pData[playerid][pSideJobTime] += 30*30;
			ApplyAnimation(playerid, "CARRY", "crry_prtial", 4.1, 1, 1, 1, 1, 1, 1);
			pCargo[playerid] = 0;
		}
		case 4:
		{
		    AddPlayerSalary(playerid, "Job(Hauling Seed Cargo)", 35);
			SCM(playerid, COLOR_JOB, "HAULING: {FFFFFF}$35 have been issued to your paycheck");
			ClearAnimations(playerid);
			pData[playerid][pSideJobTime] += 30*30;
			ApplyAnimation(playerid, "CARRY", "crry_prtial", 4.1, 1, 1, 1, 1, 1, 1);
			pCargo[playerid] = 0;
		}
	}
	return 1;
}


stock SendRangedMessage(sourceid, color, message[], Float:range) 
{
    new Float:x, Float:y, Float: z;
    GetPlayerPos(sourceid, x, y, z);
    for (new ii = 0; ii < MAX_PLAYERS; ii++) 
    {
        if(GetPlayerVirtualWorld(sourceid) == GetPlayerVirtualWorld(ii)) 
        {
       	    if(IsPlayerInRangeOfPoint(ii, range, x, y, z)) 
   		    {
                SendClientMessage(ii, color, message);
            }
        }
    }
}

CMD:tdc(playerid)
{
	ShowPlayerDialog(playerid, DIALOG_TDC, DIALOG_STYLE_LIST, "Trucker Data Computer","General Trucker Data\nMy Trucker Data\nIndustri Place", "Select", "Back");
	return 1;
}

CMD:cargob(playerid, params[])
{
	if(IsPlayerConnected(playerid))
	{
        if(isnull(params))
		{
            Usage(playerid, "USAGE: /cargo [name]");
            Info(playerid, "Names: purchase, load, take, sell, throw");
            return 1;
        }
		if(strcmp(params,"purchase",true) == 0)
		{
            if(IsPlayerInRangeOfPoint(playerid, 3.0, 163.5530,-54.8748,1.5781))//Type Meat
			{
		    	if(IsPlayerInAnyVehicle(playerid)) return Error(playerid, "Don't use this in vehicle");
				{
   					if(pData[playerid][pSideJobTime] > 0)
					{
	    				Error(playerid, "Anda harus menunggu "GREY2_E"%d "WHITE_E"detik lagi.", pData[playerid][pSideJobTime]);
	    				return 1;
					}
					if(ServerCargoMeat != 0)
					{
						if(pCargo[playerid] == 1) return SCM(playerid, COLOR_JOB, "HAULING:"WHITE_E"You has purchase a cargo");
						{
					    	if(pPurchaseCargoMeat[playerid] == 2) return Error(playerid, "You has purchased 2 Cargo of Meat!");
					    	{
			    	    		if(IsPlayerAttachedObjectSlotUsed(playerid,2)) RemovePlayerAttachedObject(playerid,2);
								TogglePlayerControllable(playerid,0);
								ApplyAnimation(playerid, "BOMBER", "BOM_Plant", 4.0, 1, 1, 1, 1, 11000);
						  		SetTimerEx("CargoMeat", 11000, false, "d", playerid);
								
								ServerCargoMeat -= 1;
								Server_Save();
							}
						}
					}
					else
					{
	 	  				Error(playerid, "There is nothing a cargo of meat!");
	 	  			}
				}
			}
			if(IsPlayerInRangeOfPoint(playerid, 3.0, -383.0497,-1438.9336,26.3277))//Type Seed
			{
			    if(IsPlayerInAnyVehicle(playerid)) return Error(playerid, "Don't use this in vehicle");
				{
					if(ServerCargoSeed != 0)
					{
						if(pCargo[playerid] == 1) return SCM(playerid, COLOR_JOB, "HAULING:"WHITE_E"You has purchase a cargo");
						{
						    if(pPurchaseCargoSeed[playerid] == 2) return Error(playerid, "You has purchased 2 Cargo of Seed!");
						    {
					    	    if(IsPlayerAttachedObjectSlotUsed(playerid,2)) RemovePlayerAttachedObject(playerid,2);
								TogglePlayerControllable(playerid,0);
								ApplyAnimation(playerid, "BOMBER", "BOM_Plant", 4.0, 1, 1, 1, 1, 11000);
								SetTimerEx("CargoSeed", 11000, false, "d", playerid);
								GivePlayerMoneyEx(playerid, -5);

								ServerCargoSeed -= 1;
								Server_Save();
							}
						}
					}
					else
					{
	 	  				Error(playerid, "There is nothing a cargo of seed!");
	 	  			}
				}
			}
        }
		else if(strcmp(params,"load",true) == 0)
		{
			if(pCargo[playerid] == 0) return Error(playerid, "You not purchase a cargo");
	    	{
		    	new Float:Cpos[3];
		    	new name[24], string[500];
		    	for(new i = 0;i<MAX_VEHICLES;i++)
				{
			    	if(GetHaulingCveh(i))
					{
						GetVehiclePos(i,Cpos[0],Cpos[1],Cpos[2]);
						if(IsPlayerInRangeOfPoint(playerid,3.0,Cpos[0],Cpos[1],Cpos[2]))
						{
					    	if(vCargoObj1[i] == 0)
					    	{
			    				ObjetoC[playerid] = CreateObject(2912,0,0,-1000,0,0,0,100);
				   				RemovePlayerAttachedObject(playerid,0);

				   				ClearAnimations(playerid);
								pCargo[playerid] = 0;
								GetPlayerName(playerid, name, 24);
								format(string, 64, "* %s Stored a cargo to vehicle with both hands", name, params);
								SendRangedMessage(playerid, COLOR_PURPLE, string, 50);

								if(vMbenson(i))
								{
									SCM(playerid, COLOR_JOB, "HAULING:"WHITE_E"You have stored a cargo into the Benson"YELLOW_E"(Storage: 1)");
									vCargoObj1[i] = 1;
								}
								else if(vMbobcat(i))
								{
				    				AttachObjectToVehicle(ObjetoC[playerid], i, 0.14590, -1.91780, 0.03320,   0.00000, 0.00000,0.00000);
				    				SCM(playerid, COLOR_JOB, "HAULING:"WHITE_E"You have stored a cargo into the Bobcat"YELLOW_E"(Storage: 1)");
		          					vCargoObj1[i] = 1;
								}
								else if(vMyosemite(i))
								{
				    				AttachObjectToVehicle(ObjetoC[playerid], i, -0.03366, -1.17622, 0.09120,   0.00000, 0.00000,0.00000);
				    				SCM(playerid, COLOR_JOB, "HAULING:"WHITE_E"You have stored a cargo into the Yosemite"YELLOW_E"(Storage: 1)");
		         					vCargoObj1[i] = 1;
								}
							}
						 	else if(vCargoObj1[i] == 1)
							{
			    				ObjetoC1[playerid] = CreateObject(2912,0,0,-1000,0,0,0,100);
				   				RemovePlayerAttachedObject(playerid,0);

				   				ClearAnimations(playerid);
								pCargo[playerid] = 0;
								GetPlayerName(playerid, name, 24);
								format(string, 64, "* %s Stored a cargo to vehicle with both hands", name, params);
								SendRangedMessage(playerid, COLOR_PURPLE, string, 50);

								if(vMbenson(i))
								{
									SCM(playerid, COLOR_JOB, "HAULING:"WHITE_E"You have stored a cargo into the Benson"YELLOW_E"(Storage: 2)");
									vCargoObj2[i] = 1;
								}
								else if(vMbobcat(i))
								{
	   								AttachObjectToVehicle(ObjetoC1[playerid], i, -0.03620, -0.95140, 0.11720,   0.00000, 0.00000,0.00000);
	   								SCM(playerid, COLOR_JOB, "HAULING:"WHITE_E"You have stored a cargo into the Bobcat"YELLOW_E"(Storage: 2)");
	      							vCargoObj2[i] = 1;
								}
								else if(vMyosemite(i))
								{
	   								AttachObjectToVehicle(ObjetoC1[playerid], i, -0.04046, -2.15479, 0.07253,   0.00000, 0.00000,0.00000);
	   								SCM(playerid, COLOR_JOB, "HAULING:"WHITE_E"You have stored a cargo into the Yosemite"YELLOW_E"(Storage: 2)");
	      							vCargoObj2[i] = 1;
								}
							}
							else if(vCargoObj2[i] == 1 && vCargoObj1[i] == 1)
							{
							    Error(playerid, "This vehicle storage is full(2 Cargo)");
							}
						}
     				}
        		}
			}
		}
		else if(strcmp(params,"take",true) == 0)
		{
        	new name[24],string[128];
   			new Float:Cpos[3];
   			for(new i = 0;i<MAX_VEHICLES;i++)
			{
				if(GetHaulingCveh(i))
				{
	   				GetVehiclePos(i,Cpos[0],Cpos[1],Cpos[2]);
					if(IsPlayerInRangeOfPoint(playerid,3.0,Cpos[0],Cpos[1],Cpos[2]))
					{
	    				if(IsPlayerInAnyVehicle(playerid)) return Error(playerid, "Don't use this in vehicle");
						{
							if(pPurchaseCargoMeat[playerid] == 1 || pPurchaseCargoMeat[playerid] == 2) return Error(playerid, "You not have a cargo");
					    	{
	                            if(vCargoObj1[i] == 1 && vCargoObj2[i] == 0)
								{
	                                SetPlayerAttachedObject(playerid, 0, 2912, 1, 0.436000, 0.519000, -0.342000, 0.000000, 0.000000, 0.000000, 1.000000,1.000000,1.000000);

									ApplyAnimation(playerid, "CARRY", "crry_prtial", 4.1, 1, 1, 1, 1, 1, 1);
									pCargo[playerid] = 1;
									vCargoObj1[i] = 0;
									DestroyObject(ObjetoC[playerid]);
									GetPlayerName(playerid, name, 24);
									format(string, 64, "* %s Takes a cargo from vehicle with both hands", name, params);
									SendRangedMessage(playerid, COLOR_PURPLE, string, 50);
								}
	                            else if(vCargoObj1[i] == 1 && vCargoObj2[i] == 1)
								{
									SetPlayerAttachedObject(playerid, 0, 2912, 1, 0.436000, 0.519000, -0.342000, 0.000000, 0.000000, 0.000000, 1.000000,1.000000,1.000000);

									ApplyAnimation(playerid, "CARRY", "crry_prtial", 4.1, 1, 1, 1, 1, 1, 1);
									pCargo[playerid] = 1;
									vCargoObj1[i] = 0;
									DestroyObject(ObjetoC[playerid]);
									GetPlayerName(playerid, name, 24);
									format(string, 64, "* %s Takes a cargo from vehicle with both hands", name, params);
									SendRangedMessage(playerid, COLOR_PURPLE, string, 50);
								}
							    else if(vCargoObj1[i] == 0 && vCargoObj2[i] == 1)
								{
				    				SetPlayerAttachedObject(playerid, 0, 2912, 1, 0.436000, 0.519000, -0.342000, 0.000000, 0.000000, 0.000000, 1.000000,1.000000,1.000000);

									ApplyAnimation(playerid, "CARRY", "crry_prtial", 4.1, 1, 1, 1, 1, 1, 1);
									pCargo[playerid] = 1;
									vCargoObj2[i] = 0;
									DestroyObject(ObjetoC1[playerid]);
									GetPlayerName(playerid, name, 24);
									format(string, 64, "* %s Takes a cargo from vehicle with both hands", name, params);
									SendRangedMessage(playerid, COLOR_PURPLE, string, 50);
								}
								else if(vCargoObj1[i] == 0 && vCargoObj2[i] == 0)
								{
								    Error(playerid, "This vehicle cargo is empty!");
								}
							}
						}
					}
				}
			}
		}
        else if(strcmp(params,"sell",true) == 0)
        {
   	    	new string [256];
 			if(IsPlayerInRangeOfPoint(playerid, 4.0, 1466.4801,1039.0343,10.0313))//Meat
 			{
				if(IsPlayerInAnyVehicle(playerid)) return Error(playerid, "Don't use this in vehicle");
				{
					if(pCargo[playerid] == 1)
	 				{
		    			if(pPurchaseCargoMeat[playerid] == 1 || pPurchaseCargoMeat[playerid] == 2)
	  			   		{
			    			new name[24];

							RemovePlayerAttachedObject(playerid,0);
	  	   					GetPlayerName(playerid, name, 24);
	      					pPurchaseCargoMeat[playerid]--;
							format(string, 64, "* %s Places down a cargo with both hands", name, params);
							SendRangedMessage(playerid, COLOR_PURPLE, string, 50);
							ApplyAnimation(playerid, "BOMBER", "BOM_Plant", 4.1, 0, 1, 1, 1, 900);
							SetTimerEx("csellmeat", 900, false, "d", playerid);
						}
					}
				}
			}
			if(IsPlayerInRangeOfPoint(playerid, 4.0, 2790.7275,-2417.8015,13.6329))//Seed
 			{
				if(IsPlayerInAnyVehicle(playerid)) return Error(playerid, "Don't use this in vehicle");
				{
					if(pCargo[playerid] == 1)
	 				{
		    			if(pPurchaseCargoSeed[playerid] == 1 || pPurchaseCargoSeed[playerid] == 2)
	  			   		{
			    			new name[24];

							RemovePlayerAttachedObject(playerid,0);
	  	   					GetPlayerName(playerid, name, 24);
	      					pPurchaseCargoSeed[playerid]--;
							format(string, 64, "* %s Places down a cargo with both hands", name, params);
							SendRangedMessage(playerid, COLOR_PURPLE, string, 50);
							ApplyAnimation(playerid, "BOMBER", "BOM_Plant", 4.1, 0, 1, 1, 1, 900);
							SetTimerEx("csellmat", 900, false, "d", playerid);
						}
					}
				}
			}
		}
		else if(strcmp(params,"throw",true) == 0)
        {
	        new name[24], string[64];
		    {
				if(pCargo[playerid] == 1)
				{
				    if(pPurchaseCargoMeat[playerid] == 0) return Error(playerid, "Anda Tidak Membawa Box");
				    {
						if(IsPlayerInAnyVehicle(playerid)) return Error(playerid, "Don't use this in vehicle");
						{

							RemovePlayerAttachedObject(playerid,0);
							pCargo[playerid] = 0;
							pPurchaseCargoMeat[playerid]--;
							GetPlayerName(playerid, name, 24);
							ClearAnimations(playerid);
							format(string, 64, "* %s Throw down a cargo with both hands", name, params);
							SendRangedMessage(playerid, COLOR_PURPLE, string, 50);
						}
					}
				}
			}
		}
	}
	return 1;
}
