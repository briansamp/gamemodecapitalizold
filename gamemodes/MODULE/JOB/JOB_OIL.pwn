CreateJoinOilPoint()
{
	//JOBS
	new strings[128];
	CreateDynamicPickup(1239, 23, -265.87, -2213.63, 29.04, -1, -1, -1, 5.0);
	format(strings, sizeof(strings), "[JOB OIL]\n{ffffff}Jadilah Pekerja Oil disini\n{7fffd4}/getjob /accept job");
	CreateDynamic3DTextLabel(strings, COLOR_YELLOW, -265.87, -2213.63, 29.04, 3.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1); // lumber
}

#define MAX_OIL 15
#define OIL_RESPAWN 1800

enum    E_OIL
{
	// loaded from db
	Float: oilX,
	Float: oilY,
	Float: oilZ,
	Float: oilRX,
	Float: oilRY,
	Float: oilRZ,
	// temp
	oilCarrier,
	oilSeconds,
	bool: oilGettingCarrier,
	oilObjId,
	Text3D: oilLabel,
	oilTimer
}

new OilData[MAX_OIL][E_OIL],
	Iterator:Oils<MAX_OIL>;
	

GetClosestOil(playerid, Float: range = 3.0)
{
	new id = -1, Float: dist = range, Float: tempdist;
	foreach(new i : Oils)
	{
	    tempdist = GetPlayerDistanceFromPoint(playerid, OilData[i][oilX], OilData[i][oilY], OilData[i][oilZ]);

	    if(tempdist > range) continue;
		if(tempdist <= dist)
		{
			dist = tempdist;
			id = i;
		}
	}
	return id;
}

Player_ResetTaking(playerid)
{
	if(!IsPlayerConnected(playerid) || pData[playerid][TakingOilID] == -1) return 0;
	new id = pData[playerid][TakingOilID];
	OilData[id][oilGettingCarrier] = false;
	if(OilData[id][oilSeconds] < 1) Streamer_SetIntData(STREAMER_TYPE_3D_TEXT_LABEL, OilData[id][oilLabel], E_STREAMER_COLOR, 0x2ECC71FF);
	
	ClearAnimations(playerid);
    TogglePlayerControllable(playerid, 1);
    pData[playerid][TakingOilID] = -1;
    
    if(pData[playerid][pActivity] != -1)
	{
	    KillTimer(pData[playerid][pActivity]);
		pData[playerid][pActivity] = -1;
		pData[playerid][pActivityTime] = 0;
	}
	PlayerTextDrawHide(playerid, ActiveTD[playerid]);
	HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
	return 1;
}

Player_DropOil(playerid, death_drop = 0)
{
    if(!IsPlayerConnected(playerid) || !pData[playerid][CarryingOil]) return 0;
    new id = Iter_Free(Oils);
    if(id != -1)
    {
        new Float: x, Float: y, Float: z, Float: a, label[128];
        GetPlayerPos(playerid, x, y, z);
        GetPlayerFacingAngle(playerid, a);
        GetPlayerName(playerid, CarrierData[id][oilDroppedBy], MAX_PLAYER_NAME);

		if(!death_drop)
		{
		    x += (1.0 * floatsin(-a, degrees));
			y += (1.0 * floatcos(-a, degrees));
			
			ApplyAnimation(playerid, "CARRY", "putdwn05", 4.1, 0, 1, 1, 0, 0, 1);
		}

		CarrierData[id][lumberSeconds] = LUMBER_LIFETIME;
		CarrierData[id][carrierObjId] = CreateDynamicObject(3632, x, y, z - 0.9, 0.0, 0.0, a);
		
		format(label, sizeof(label), "OilCarrier (%d)\n"WHITE_E"Dropped By "GREEN_E"%s\n"WHITE_E"%s\nUse /oil pickup.", id, CarrierData[id][lumberDroppedBy], ConvertToMinutes(LUMBER_LIFETIME));
		CarrierData[id][carrierLabel] = CreateDynamic3DTextLabel(label, COLOR_GREEN, x, y, z - 0.7, 5.0, .testlos = 1);
		
		CarrierData[id][carrierTimer] = SetTimerEx("RemoveLumber", 1000, true, "i", id);
		Iter_Add(Lumbers, id);
    }
    
    Player_RemoveLumber(playerid);
	return 1;
}

Player_RemoveCarrier(playerid)
{
	if(!IsPlayerConnected(playerid) || !pData[playerid][CarryingLumber]) return 0;
	RemovePlayerAttachedObject(playerid, 9);
	SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
	pData[playerid][CarryingLumber] = false;
	return 1;
}

function RespawnOil(id)
{
	new label[96];
	if(OilData[id][oilSeconds] > 1)
	{
	    OilData[id][oilSeconds]--;
	    
	    format(label, sizeof(label), "Oil (%d)\n{FFFFFF}%s", id, ConvertToMinutes(OilData[id][oilSeconds]));
		UpdateDynamic3DTextLabelText(OilData[id][oilLabel], COLOR_GREEN, label);
	}
	else if(OilData[id][oilSeconds] == 1)
	{
	    KillTimer(OilData[id][oilTimer]);

	    OilData[id][oilCarrier] = 0;
	    OilData[id][oilSeconds] = 0;
	    OilData[id][oilTimer] = -1;
	    
	    SetDynamicObjectPos(OilData[id][oilObjId], OilData[id][oilX], OilData[id][oilY], OilData[id][oilZ]);
     	SetDynamicObjectRot(OilData[id][oilObjId], OilData[id][oilRX], OilData[id][oilRY], OilData[id][oilRZ]);
     	
     	format(label, sizeof(label), "Oil (%d)\n", id);
     	UpdateDynamic3DTextLabelText(OilData[id][oilLabel], COLOR_GREEN, label);
	}
	return 1;
}
	
function LoadTrees()
{
    new tid;
	
	new rows = cache_num_rows();
 	if(rows)
  	{
		for(new i; i < rows; i++)
		{
			cache_get_value_name_int(i, "id", tid);
			cache_get_value_name_float(i, "posx", OilData[tid][oilX]);
			cache_get_value_name_float(i, "posy", OilData[tid][oilY]);
			cache_get_value_name_float(i, "posz", OilData[tid][oilZ]);
			cache_get_value_name_float(i, "posrx", OilData[tid][oilRX]);
			cache_get_value_name_float(i, "posry", OilData[tid][oilRY]);
			cache_get_value_name_float(i, "posrz", OilData[tid][oilRZ]);
			
			new label[64];
			format(label, sizeof(label), "Tree (%d)\n", tid);
			OilData[tid][oilLabel] = CreateDynamic3DTextLabel(label, COLOR_GREEN, OilData[tid][oilX], OilData[tid][oilY], OilData[tid][oilZ] + 1.5, 5.0);
			OilData[tid][oilObjId] = CreateDynamicObject(657, OilData[tid][oilX], OilData[tid][oilY], OilData[tid][oilZ], OilData[tid][oilRX], OilData[tid][oilRY], OilData[tid][oilRZ]);
			Iter_Add(Trees, tid);
			
			OilData[tid][oilGettingCarrier] = false;
			OilData[tid][oilSeconds] = 0;
		}
		printf("[Dynamic Tree] Number of Loaded: %d.", rows);
	}
}

Tree_Save(tid)
{
	new cQuery[512];
	format(cQuery, sizeof(cQuery), "UPDATE trees SET posx='%f', posy='%f', posz='%f', posrx='%f', posry='%f', posrz='%f' WHERE id='%d'",
	OilData[tid][oilX],
	OilData[tid][oilY],
	OilData[tid][oilZ],
	OilData[tid][oilRX],
	OilData[tid][oilRY],
	OilData[tid][oilRZ],
	tid
	);
	return mysql_tquery(g_SQL, cQuery);
}

Tree_Refresh(tid)
{
    if(!Iter_Contains(Trees, tid)) return 0;
    new label[96];
    
    if(OilData[tid][oilCarrier] > 0) {
	    format(label, sizeof(label), "Tree (%d)\n"WHITE_E"Lumber: "GREEN_E"%d\n"WHITE_E"Use /lumber take.", tid, OilData[tid][oilCarrier]);
		UpdateDynamic3DTextLabelText(OilData[tid][oilLabel], COLOR_GREEN, label);
	}else{
	    OilData[tid][oilTimer] = SetTimerEx("RespawnTree", 1000, true, "i", tid);
	    
	    format(label, sizeof(label), "Tree (%d)\n"WHITE_E"%s", tid, ConvertToMinutes(OilData[tid][oilSeconds]));
		UpdateDynamic3DTextLabelText(OilData[tid][oilLabel], COLOR_GREEN, label);
	}
	
	return 1;
}

Tree_BeingEdited(tid)
{
	if(!Iter_Contains(Trees, tid)) return 0;
	foreach(new i : Player) if(pData[i][EditingTreeID] == tid) return 1;
	return 0;
}

ConvertToMinutes(time)
{
    // http://forum.sa-mp.com/showpost.php?p=3223897&postcount=11
    new string[15];//-2000000000:00 could happen, so make the string 15 chars to avoid any errors
    format(string, sizeof(string), "%02d:%02d", time / 60, time % 60);
    return string;
}

//-------[ commands ]----------

CMD:createtree(playerid, params[])
{
	if(pData[playerid][pAdmin] < 4)
		return PermissionError(playerid);
	new tid = Iter_Free(Trees), query[512];
	if(tid == -1) return Error(playerid, "Can't add any more trees.");
 	new Float: x, Float: y, Float: z, Float: a;
 	GetPlayerPos(playerid, x, y, z);
 	GetPlayerFacingAngle(playerid, a);
 	x += (3.0 * floatsin(-a, degrees));
	y += (3.0 * floatcos(-a, degrees));
	z -= 1.0;
	
	OilData[tid][oilX] = x;
	OilData[tid][oilY] = y;
	OilData[tid][oilZ] = z;
	OilData[tid][oilRX] = OilData[tid][oilRY] = OilData[tid][oilRZ] = 0.0;
	
	new label[96];
	format(label, sizeof(label), "Tree (%d)\n", tid);
	OilData[tid][oilLabel] = CreateDynamic3DTextLabel(label, COLOR_GREEN, OilData[tid][oilX], OilData[tid][oilY], OilData[tid][oilZ] + 1.5, 5.0);
	OilData[tid][oilObjId] = CreateDynamicObject(657, OilData[tid][oilX], OilData[tid][oilY], OilData[tid][oilZ], OilData[tid][oilRX], OilData[tid][oilRY], OilData[tid][oilRZ]);
	Iter_Add(Trees, tid);
	
	mysql_format(g_SQL, query, sizeof(query), "INSERT INTO trees SET id='%d', posx='%f', posy='%f', posz='%f', posrx='%f', posry='%f', posrz='%f'", tid, OilData[tid][oilX], OilData[tid][oilY], OilData[tid][oilZ], OilData[tid][oilRX], OilData[tid][oilRY], OilData[tid][oilRZ]);
	mysql_tquery(g_SQL, query, "OnTreeCreated", "di", playerid, tid);
	return 1;
}

function OnTreeCreated(playerid, tid)
{
	Tree_Save(tid);
	
	pData[playerid][EditingTreeID] = tid;
	EditDynamicObject(playerid, OilData[tid][oilObjId]);
	Servers(playerid, "Tree created.");
	Servers(playerid, "You can edit it right now, or cancel editing and edit it some other time.");
	return 1;
}

CMD:edittree(playerid, params[])
{
    if(pData[playerid][pAdmin] < 4)
		return PermissionError(playerid);
    if(pData[playerid][EditingTreeID] != -1) return Error(playerid, "You're already editing a tree.");
	new tid;
	if(sscanf(params, "i", tid)) return Usage(playerid, "/edittree [tree id]");
	if(!Iter_Contains(Trees, tid)) return Error(playerid, "Invalid ID.");
	if(OilData[tid][oilGettingCarrier]) return Error(playerid, "Can't edit specified tree because its getting cut down.");
	if(!IsPlayerInRangeOfPoint(playerid, 30.0, OilData[tid][oilX], OilData[tid][oilY], OilData[tid][oilZ])) return SendClientMessage(playerid, 0xE74C3CFF, "ERROR: {FFFFFF}You're not near the tree you want to edit.");
	pData[playerid][EditingTreeID] = tid;
	EditDynamicObject(playerid, OilData[tid][oilObjId]);
	return 1;
}

CMD:removetree(playerid, params[])
{
    if(pData[playerid][pAdmin] < 4)
		return PermissionError(playerid);
		
	new tid, query[512];
	if(sscanf(params, "i", tid)) return Usage(playerid, "/removetree [tree id]");
	if(!Iter_Contains(Trees, tid)) return Error(playerid, "Invalid ID.");
	if(OilData[tid][oilGettingCarrier]) return Error(playerid, "Can't remove specified tree because its getting cut down.");
	if(Tree_BeingEdited(tid)) return Error(playerid, "Can't remove specified tree because its being edited.");
	DestroyDynamicObject(OilData[tid][oilObjId]);
	DestroyDynamic3DTextLabel(OilData[tid][oilLabel]);
	if(OilData[tid][oilTimer] != -1) KillTimer(OilData[tid][oilTimer]);
	
	OilData[tid][oilCarrier] = OilData[tid][oilSeconds] = 0;
	OilData[tid][oilObjId] = OilData[tid][oilTimer] = -1;
	OilData[tid][oilLabel] = Text3D: -1;
	Iter_Remove(Oils, tid);
	
	mysql_format(g_SQL, query, sizeof(query), "DELETE FROM trees WHERE id=%d", tid);
	mysql_tquery(g_SQL, query);
	Servers(playerid, "Tree removed.");
	return 1;
}

CMD:gototree(playerid, params[])
{
	new tid;
	if(pData[playerid][pAdmin] < 4)
        return PermissionError(playerid);
		
	if(sscanf(params, "d", tid))
		return Usage(playerid, "/gototree [id]");
	if(!Iter_Contains(Trees, tid)) return Error(playerid, "The tree you specified ID of doesn't exist.");
	SetPlayerPosition(playerid, OilData[tid][oilX], OilData[tid][oilY], OilData[tid][oilZ], 2.0);
	pData[playerid][pInBiz] = -1;
	pData[playerid][pInHouse] = -1;
	pData[playerid][pInDoor] = -1;
    SetPlayerInterior(playerid, 0);
    SetPlayerVirtualWorld(playerid, 0);
	Servers(playerid, "You has teleport to house id %d", tid);
	return 1;
}

CMD:lumber(playerid, params[])
{
	if(pData[playerid][pJob] == 3 || pData[playerid][pJob2] == 3)
	{
		if(IsPlayerInAnyVehicle(playerid)) return Error(playerid, "Anda harus keluar dari kendaraan.");
		if(isnull(params)) return Usage(playerid, "/lum [cut/take/load/unload/pickup/sell]");
		
		if(!strcmp(params, "cut", true))
		{
			if(pData[playerid][CarryingLumber]) return Player_DropLumber(playerid);
				
			if(GetPlayerWeapon(playerid) == WEAPON_CHAINSAW && pData[playerid][CuttingTreeID] == -1 && !pData[playerid][CarryingLumber])
			{
				if(pData[playerid][pJobTime] > 0) return Error(playerid, "Anda harus menunggu "GREY2_E"%d "WHITE_E"detik untuk bisa bekerja kembali.", pData[playerid][pJobTime]);
				
				new tid = GetClosestTree(playerid);

				if(tid != -1)
				{
					if(!Tree_BeingEdited(tid) && !OilData[tid][oilGettingCarrier] && OilData[tid][oilSeconds] < 1)
					{
						SetPlayerLookAt(playerid, OilData[tid][oilX], OilData[tid][oilY]);

						Streamer_SetIntData(STREAMER_TYPE_3D_TEXT_LABEL, OilData[tid][oilLabel], E_STREAMER_COLOR, 0xE74C3CFF);
						pData[playerid][pActivity] = SetTimerEx("CutTree", 1000, true, "i", playerid);
						pData[playerid][CuttingTreeID] = tid;
						PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Cutting...");
						PlayerTextDrawShow(playerid, ActiveTD[playerid]);
						ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
						TogglePlayerControllable(playerid, 0);
						SetPlayerArmedWeapon(playerid, WEAPON_CHAINSAW);
						ApplyAnimation(playerid, "CHAINSAW", "WEAPON_csaw", 4.1, 1, 0, 0, 1, 0, 1);

						OilData[tid][oilGettingCarrier] = true;
	
					}
					else return Error(playerid, "This tree is not ready.");
				}
				else return Error(playerid, "Invalid tree id");
			}
			else return Error(playerid, "You need to pickup the chainsaw.");
		}
		else if(!strcmp(params, "take", true))
		{
			// taking from a cut tree
			if(pData[playerid][CarryingLumber]) return Error(playerid, "You're already carrying a log.");
			new tid = GetClosestTree(playerid);
			if(tid == -1) return Error(playerid, "You're not near a tree.");
			if(OilData[tid][oilSeconds] < 1) return Error(playerid, "This tree isn't cut.");
			if(OilData[tid][oilCarrier] < 1) return Error(playerid, "This tree doesn't have any logs.");
			OilData[tid][oilCarrier]--;
			Tree_Refresh(tid);
			
			Player_GiveLumber(playerid);
			Info(playerid, "You've taken a log from the cut tree.");
		}
		else if(!strcmp(params, "load", true))
		{
			// loading to a bobcat
			new carid = -1;
			if(!pData[playerid][CarryingLumber]) return Error(playerid, "You're not carrying a log.");
			new vehicleid = GetNearestVehicleToPlayer(playerid, 3.5, false);
			if(vehicleid == INVALID_VEHICLE_ID) return Error(playerid, "You not in near any vehicles.");
			if(!IsAPickup(vehicleid)) return Error(playerid, "You're not near a pickup car.");

			if(Vehicle_LumberCount(vehicleid) >= LUMBER_LIMIT) return Error(playerid, "You can't load any more logs to this vehicle.");
			if((carid = Vehicle_Nearest(playerid)) != -1)
			{
				if(IsValidVehicle(pvData[carid][cVeh]))
				{
					pvData[carid][cLumber] += 1;
				}
			}
			if(IsValidVehicle(vehicleid))
			{
				for(new i; i < LUMBER_LIMIT; i++)
				{
					if(!IsValidDynamicObject(LumberObjects[vehicleid][i]))
					{
						LumberObjects[vehicleid][i] = CreateDynamicObject(19793, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0);
						AttachDynamicObjectToVehicle(LumberObjects[vehicleid][i], vehicleid, LumberAttachOffsets[i][0], LumberAttachOffsets[i][1], LumberAttachOffsets[i][2], 0.0, 0.0, LumberAttachOffsets[i][3]);
						break;
					}
				}
			}
			Streamer_Update(playerid);
			Player_RemoveLumber(playerid);
			Info(playerid, "Loaded a log.");
		}
		else if(!strcmp(params, "unload")) 
		{
			// taking from a bobcat
			new carid = -1;
			if(pData[playerid][CarryingLumber]) return Error(playerid, "You're already carrying a log.");
			new vehicleid = GetNearestVehicleToPlayer(playerid, 3.5, false);
			if(vehicleid == INVALID_VEHICLE_ID) return Error(playerid, "You not in near any vehicles.");
			if(!IsAPickup(vehicleid)) return Error(playerid, "You're not near a pickupcar.");

			if(Vehicle_LumberCount(vehicleid) < 1) return Error(playerid, "This vehicle doesn't have any logs.");
			if((carid = Vehicle_Nearest(playerid)) != -1)
			{
				if(IsValidVehicle(pvData[carid][cVeh]))
				{
					pvData[carid][cLumber] -= 1;
				}
			}
			if(IsValidVehicle(vehicleid))
			{
				for(new i = (LUMBER_LIMIT - 1); i >= 0; i--)
				{
					if(IsValidDynamicObject(LumberObjects[vehicleid][i]))
					{
						DestroyDynamicObject(LumberObjects[vehicleid][i]);
						LumberObjects[vehicleid][i] = -1;
						break;
					}
				}
			}
			Streamer_Update(playerid);
			Player_GiveLumber(playerid);
			Info(playerid, "You've taken a log from the Bobcat.");
			// done
		}
		else if(!strcmp(params, "pickup")) 
		{
			// taking from ground
			if(pData[playerid][CarryingLumber]) return Error(playerid, "You're already carrying a log.");
			new tid = GetClosestLumber(playerid);
			if(tid == -1) return Error(playerid, "You're not near a log.");
			CarrierData[tid][lumberSeconds] = 1;
			RemoveLumber(tid);
			
			Player_GiveLumber(playerid);
			Info(playerid, "You've taken a log from ground.");
			// done
		}
		else if(!strcmp(params, "sell")) 
		{
			// selling a log
			if(!pData[playerid][CarryingLumber]) return Error(playerid, "You're not carrying a log.");
			if(!IsPlayerInRangeOfPoint(playerid, 3.0, -258.54, -2189.92, 28.97)) return Error(playerid, "You're not near a lumber warehouse.");
			Player_RemoveLumber(playerid);
			AddPlayerSalary(playerid, "Lumberjack(Jobs)", LumberPrice);
			Server_MinMoney(LumberPrice);
			Material += 10;
			pData[playerid][pJobTime] += 90;
			Info(playerid, "Sold a lumber for "GREEN_E"%s.", FormatMoney(LumberPrice));
			// done
		}
	}
	else return Error(playerid, "anda bukan pekerja lumber!");
	return 1;
}

CMD:lum(playerid, params[]) return callcmd::lumber(playerid, params);

Vehicle_LumberCount(vehicleid)
{
	if(GetVehicleModel(vehicleid) == 0) return 0;
	new count;
	for(new i; i < LUMBER_LIMIT; i++) if(IsValidDynamicObject(LumberObjects[vehicleid][i])) count++;
	return count;
}

GetClosestLumber(playerid, Float: range = 2.0)
{
	new tid = -1, Float: dist = range, Float: tempdist, Float: pos[3];
	foreach(new i : Lumbers)
	{
		GetDynamicObjectPos(CarrierData[i][carrierObjId], pos[0], pos[1], pos[2]);
	    tempdist = GetPlayerDistanceFromPoint(playerid, pos[0], pos[1], pos[2]);

	    if(tempdist > range) continue;
		if(tempdist <= dist)
		{
			dist = tempdist;
			tid = i;
		}
	}
	return tid;
}

Player_GiveLumber(playerid)
{
    if(!IsPlayerConnected(playerid)) return 0;
	pData[playerid][CarryingLumber] = true;
	SetPlayerSpecialAction(playerid, SPECIAL_ACTION_CARRY);
	SetPlayerAttachedObject(playerid, 9, 19793, 6, 0.077999, 0.043999, -0.170999, -13.799953, 79.70, 0.0);
	
	Info(playerid, "You can press "GREEN_E"'N' "WHITE_E"to drop your log.");
	return 1;
}

function CutTree(playerid)
{
    if(pData[playerid][CuttingTreeID] != -1)
	{
		new tid = pData[playerid][CuttingTreeID];
		
		if(pData[playerid][pActivityTime] >= 100)
		{
			OilData[tid][oilCarrier] = 5;
			OilData[tid][oilSeconds] = TREE_RESPAWN;
			Player_ResetCutting(playerid);
			Tree_Refresh(tid);
			
			InfoTD_MSG(playerid, 8000, "Cutting tree done!");
			KillTimer(pData[playerid][pActivity]);
			pData[playerid][pActivityTime] = 0;
			HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
			PlayerTextDrawHide(playerid, ActiveTD[playerid]);
			pData[playerid][pEnergy] -= 3;
			ClearAnimations(playerid);
			StopLoopingAnim(playerid);
			SetPlayerSpecialAction(playerid, 0);
			//TogglePlayerControllable(playerid, 1);
			MoveDynamicObject(OilData[tid][oilObjId], OilData[tid][oilX], OilData[tid][oilY], OilData[tid][oilZ] + 0.03, 0.025, OilData[tid][oilRX], OilData[tid][oilRY] - 80.0, OilData[tid][oilRZ]);
			Streamer_Update(playerid);
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

function RemoveLumber(tid)
{
	if(!Iter_Count(Lumbers, tid)) return 1;
	
	if(CarrierData[tid][lumberSeconds] > 1)
	{
	    CarrierData[tid][lumberSeconds]--;

        new label[128];
	    format(label, sizeof(label), "Lumber (%d)\n"WHITE_E"Dropped By "GREEN_E"%s\n"WHITE_E"%s\nUse /lumber pickup.", tid, CarrierData[tid][lumberDroppedBy], ConvertToMinutes(CarrierData[tid][lumberSeconds]));
		UpdateDynamic3DTextLabelText(CarrierData[tid][carrierLabel], COLOR_GREEN, label);
	}
	else if(CarrierData[tid][lumberSeconds] == 1)
	{
	    KillTimer(CarrierData[tid][carrierTimer]);
	    DestroyDynamicObject(CarrierData[tid][carrierObjId]);
		DestroyDynamic3DTextLabel(CarrierData[tid][carrierLabel]);
		
	    CarrierData[tid][carrierTimer] = -1;
        CarrierData[tid][carrierObjId] = -1;
        CarrierData[tid][carrierLabel] = Text3D: -1;

		Iter_Remove(Lumbers, tid);
	}
	
	return 1;
}
