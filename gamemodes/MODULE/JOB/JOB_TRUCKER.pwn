CreateJoinTruckPoint()
{
	//JOBS
	new strings[128];
	CreateDynamicPickup(1239, 23, -77.38, -1136.52, 1.07, -1);
	format(strings, sizeof(strings), "[TRUCKER JOBS]\n{ffffff}Jadilah Pekerja Trucker disini\n{7fffd4}/getjob /accept job");
	CreateDynamic3DTextLabel(strings, COLOR_YELLOW, -77.38, -1136.52, 1.07, 3.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1); // truck

	CreateDynamicPickup(1239, 23, 331.1737,920.4896,20.4063, -1);
	format(strings, sizeof(strings), "[Raw Component Cargo]\n{ffffff}Stock: {00ff00}Unlimited\n{ffffff}Type {ffff00}'/cargo get' {ffffff}to pickup cargo.");
	CreateDynamic3DTextLabel(strings, COLOR_ARWIN, 331.1737,920.4896,20.4063, 3.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1);
	
	CreateDynamicPickup(1239, 23, -23.3818, -270.3624, 5.4297, -1);
	format(strings, sizeof(strings), "[Raw Material Cargo]\n{ffffff}Stock: {00ff00}Unlimited\n{ffffff}Type {ffff00}'/cargo get' {ffffff}to pickup cargo.");
	CreateDynamic3DTextLabel(strings, COLOR_ARWIN, -23.3818, -270.3624, 5.4297, 3.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1);

	CreateDynamicPickup(1239, 23, 1352.4987, 356.0309, 19.8482, -1);
	format(strings, sizeof(strings), "[Raw Fish Cargo]\n{ffffff}Stock: {00ff00}Unlimited\n{ffffff}Type {ffff00}'/cargo get' {ffffff}to pickup cargo.");
	CreateDynamic3DTextLabel(strings, COLOR_ARWIN, 1352.4987, 356.0309, 19.8482, 3.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1);
	
	CreateDynamicPickup(1239, 23, 797.8308,-617.3008,16.0409, -1);
	format(strings, sizeof(strings), "[Warehouse Component]\n{ffffff}Type {ffff00}'/storecargo' {ffffff}to sell.");
	CreateDynamic3DTextLabel(strings, COLOR_ARWIN, 797.8308,-617.3008,16.0409, 3.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1);
	
	CreateDynamicPickup(1239, 23, 2281.7327,64.0160,26.4844, -1);
	format(strings, sizeof(strings), "[Warehouse Material]\n{ffffff}Type {ffff00}'/storecargo' {ffffff}to sell.");
	CreateDynamic3DTextLabel(strings, COLOR_ARWIN, 2281.7327,64.0160,26.4844, 3.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1);
	
	CreateDynamicPickup(1239, 23, -535.4600,-502.9689,25.2238, -1);
	format(strings, sizeof(strings), "[Warehouse Fish]\n{ffffff}Type {ffff00}'/storecargo' {ffffff}to sell.");
	CreateDynamic3DTextLabel(strings, COLOR_ARWIN, -535.4600,-502.9689,25.2238, 3.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1);
}

//Container CheckPoint
#define containerpoint1 -1733.8103,187.5354,3.5547
#define containerpoint2 2869.1934,917.6111,10.7500

//Vending
/*GetRestockVending()
{
	new tmpcount;
	foreach(new vid : Vending)
	{
	    if(VendingData[vid][VendingRestock] == 1)
	    {
     		tmpcount++;
		}
	}
	return tmpcount;
}*/

ReturnRestockVendingID(slot)
{
	new tmpcount;
	if(slot < 1 && slot > MAX_VENDING) return -1;
	foreach(new id : Vending)
	{
		if(VendingData[id][VendingRestock] == 1)
		{
			tmpcount++;
			if(tmpcount == slot)
			{
				return id;
			}
		}
	}
	return -1;
}

//Mission
GetRestockBisnis()
{
	new tmpcount;
	foreach(new id : Bisnis)
	{
	    if(bData[id][bRestock] == 1)
	    {
     		tmpcount++;
		}
	}
	return tmpcount;
}

ReturnRestockBisnisID(slot)
{
	new tmpcount;
	if(slot < 1 && slot > MAX_BISNIS) return -1;
	foreach(new id : Bisnis)
	{
	    if(bData[id][bRestock] == 1)
	    {
     		tmpcount++;
       		if(tmpcount == slot)
       		{
        		return id;
  			}
	    }
	}
	return -1;
}

//Dealership Hauling

//Hauling
GetRestockGStation()
{
	new tmpcount;
	foreach(new id : GStation)
	{
	    if(gsData[id][gsStock] < 7000)
	    {
     		tmpcount++;
		}
	}
	return tmpcount;
}

ReturnRestockGStationID(slot)
{
	new tmpcount;
	if(slot < 1 && slot > MAX_GSTATION) return -1;
	foreach(new id : GStation)
	{
	    if(gsData[id][gsStock] < 7000)
	    {
     		tmpcount++;
       		if(tmpcount == slot)
       		{
        		return id;
  			}
	    }
	}
	return -1;
}

//Mission Commands
CMD:mission(playerid, params[])
{
	if(pData[playerid][pJob] == 4 || pData[playerid][pJob2] == 4 || pData[playerid][pTruckerLic] == 1)
	{
		if(GetRestockBisnis() <= 0) return Error(playerid, "Mission sedang kosong.");
		new id, count = GetRestockBisnis(), mission[128], type[32], lstr[512];
		
		strcat(mission,"No\tBusinesID\tBusinesType\tBusinesName\n",sizeof(mission));
		Loop(itt, (count + 1), 1)
		{
			id = ReturnRestockBisnisID(itt);
			if(bData[id][bType] == 1)
			{
				type= "Fast Food";
			}
			else if(bData[id][bType] == 2)
			{
				type= "Market";
			}
			else if(bData[id][bType] == 3)
			{
				type= "Clothes";
			}
			else if(bData[id][bType] == 4)
			{
				type= "Ammunation";
			}
			else if(bData[id][bType] == 5)
			{
				type= "Bar";
			}
			else
			{
				type= "Unknow";
			}
			if(itt == count)
			{
				format(lstr,sizeof(lstr), "%d\t%d\t%s\t%s\n", itt, id, type, bData[id][bName]);	
			}
			else format(lstr,sizeof(lstr), "%d\t%d\t%s\t%s\n", itt, id, type, bData[id][bName]);
			strcat(mission,lstr,sizeof(mission));
		}
		ShowPlayerDialog(playerid, DIALOG_RESTOCK, DIALOG_STYLE_TABLIST_HEADERS,"Mission",mission,"Start","Cancel");
	}
	else return Error(playerid, "You are not trucker job.");
	return 1;
}



CMD:storestock(playerid, params[])
{
	if(pData[playerid][pJob] == 4 || pData[playerid][pJob2] == 4)
	{
		new vid = pData[playerid][pRestock], vehicleid = GetPlayerVehicleID(playerid), carid = -1, total, Float:percent, pay, convert;
		if(vid == -1) return Error(playerid, "You dont have restock mission.");
		if(IsPlayerInRangeOfPoint(playerid, 5.0, VendingData[vid][VendingPosX], VendingData[vid][VendingPosY], VendingData[vid][VendingPosZ]))
		{
			if(GetPlayerState(playerid) != PLAYER_STATE_DRIVER && !IsATruck(vehicleid)) return Error(playerid, "Anda harus mengendarai truck.");
			if(VehProduct[vehicleid] < 1) return Error(playerid, "Product is empty in this vehicle.");
			total = VehProduct[vehicleid] * ProductPrice;
			percent = (total / 100) * 700;
			convert = floatround(percent, floatround_floor);
			pay = total + convert;
			VendingData[vid][VendingStock] += VehProduct[vehicleid];
			VendingData[vid][VendingMoney] -= pay;
			Info(playerid, "Anda menjual "RED_E"%d "WHITE_E"product dengan seharga "GREEN_E"%s", VehProduct[vehicleid], FormatMoney(pay));
			AddPlayerSalary(playerid, "Trucker(vending)", pay);
			if((carid = Vehicle_Nearest(playerid)) != -1)
			{
				pvData[carid][cProduct] = 0;
				Info(playerid, "Anda mendapatkan uang 70 percent dari hasil stock product anda.");
				VendingSave(vid);
				VendingRefresh(vid);
			}
			VehProduct[vehicleid] = 0;
			pData[playerid][pRestock] = -1;
		}
		else return Error(playerid, "Anda harus berada didekat dengan vending mission anda.");
	}
	else return Error(playerid, "You are not trucker job.");
	return 1;
}

CMD:storecargo(playerid, params[])
{
	static
	carid = -1;
	new crate = CARGO_NONE, count = 0, gajih;
	if(pData[playerid][pJob] == 4 || pData[playerid][pJob2] == 4)
	{
		if((carid = Vehicle_Nearest(playerid)) != -1)
		{
			if(GetPlayerState(playerid) != PLAYER_STATE_DRIVER) return Error(playerid, "Anda harus didalam truck.");
			if(IsPlayerInRangeOfPoint(playerid, 2.5, 797.8308,-617.3008,16.0409)) crate = 2;//component
			else if(IsPlayerInRangeOfPoint(playerid, 2.5, 2281.7327,64.0160,26.4844)) crate = 3;//material
			else if(IsPlayerInRangeOfPoint(playerid, 2.5, -535.4600,-502.9689,25.2238)) crate = 4;//fish
			else return Error(playerid, "You're not in any cargo factory.");

			// check apakah di dalam kendaraan ada cargo
            for(new i = 0; i != MAX_CARGO; i++) if (CargoData[i][cargoVehicle] == pvData[carid][cID]) {
				if(CargoData[i][cargoType] == crate)
				{
            		ListedCargo[playerid][count++] = i;
				}
            }
			if(!count) return Error(playerid, "This vehicle not loaded any cargo.");

			gajih = 40*count;
			Info(playerid, "Kamu berhasil menjual {00ff00}%s {ffffff}sebanyak {00ff00}%d {ffffff}dan mendapatkan {00ff00}$%s", Cargo_Name(crate), count, FormatMoney(gajih));
			GivePlayerMoneyEx(playerid, gajih);
			// menghapus cargo sesuai type cargonya
			for(new i = 0; i != MAX_CARGO; i++) if (CargoData[i][cargoVehicle] == pvData[carid][cID]) 
			{
				if(CargoData[i][cargoType] == crate)
				{
					Cargo_Destroy(i);
				}
			}
		}
	}
	return 1;
}

CMD:storeproduct(playerid, params[])
{
	if(pData[playerid][pJob] == 4 || pData[playerid][pJob2] == 4)
	{
		new bid = pData[playerid][pMission], vehicleid = GetPlayerVehicleID(playerid), carid = -1, total, Float:percent, pay, convert;
		if(bid == -1) return Error(playerid, "You dont have mission.");
		if(IsPlayerInRangeOfPoint(playerid, 4.8, bData[bid][bExtposX], bData[bid][bExtposY], bData[bid][bExtposZ]))
		{
			if(GetPlayerState(playerid) != PLAYER_STATE_DRIVER && !IsATruck(vehicleid)) return Error(playerid, "Anda harus mengendarai truck.");
			if(VehProduct[vehicleid] < 1) return Error(playerid, "Product is empty in this vehicle.");
			total = VehProduct[vehicleid] * ProductPrice;
			percent = (total / 100) * 700;
			convert = floatround(percent, floatround_floor);
			pay = total + convert;
			bData[bid][bProd] += VehProduct[vehicleid];
			bData[bid][bMoney] -= pay;
			Info(playerid, "Anda menjual "RED_E"%d "WHITE_E"product dengan seharga "GREEN_E"%s", VehProduct[vehicleid], FormatMoney(pay));
			AddPlayerSalary(playerid, "Trucker(Restock bisnis)", pay);
			if((carid = Vehicle_Nearest(playerid)) != -1)
			{
				pvData[carid][cProduct] = 0;
				Info(playerid, "Anda mendapatkan uang 70 percent dari hasil stock product anda.");
			}
			VehProduct[vehicleid] = 0;
			pData[playerid][pMission] = -1;
		}
		else return Error(playerid, "Anda harus berada didekat dengan bisnis mission anda.");
	}
	else return Error(playerid, "You are not trucker job.");
	return 1;
}


//Hauling Commands
CMD:haulingmission(playerid)
{
    if(pData[playerid][pLevel] < 3)
			return Error(playerid, "You must level 3 to use this!");
	 
	if(pData[playerid][pJob] == 4 || pData[playerid][pJob2] == 4 || pData[playerid][pTruckerLic] == 1)
	{
		if(pData[playerid][pJobTime] > 0)
		{
	    	Error(playerid, "Anda harus menunggu "GREY2_E"%d "WHITE_E"detik lagi.", pData[playerid][pJobTime]);
	    	return 1;
		}
		if(GetRestockGStation() <= 0) return Error(playerid, "Tidak ada gas station yang harus di restock.");
		new id, count = GetRestockGStation(), hauling[128], lstr[512];
		
		strcat(hauling,"No\tGas Station ID\tLocation\n",sizeof(hauling));
		Loop(itt, (count + 1), 1)
		{
			id = ReturnRestockGStationID(itt);
			if(itt == count)
			{
				format(lstr,sizeof(lstr), "%d\t%d\t%s\n", itt, id, GetLocation(gsData[id][gsPosX], gsData[id][gsPosY], gsData[id][gsPosZ]));	
			}
			else format(lstr,sizeof(lstr), "%d\t%d\t%s\n", itt, id, GetLocation(gsData[id][gsPosX], gsData[id][gsPosY], gsData[id][gsPosZ]));
			strcat(hauling,lstr,sizeof(hauling));
		}
		ShowPlayerDialog(playerid, DIALOG_HAULING, DIALOG_STYLE_TABLIST_HEADERS,"Hauling",hauling,"Start","Cancel");
	}
	else return Error(playerid, "You are not trucker job.");
	return 1;
}

CMD:storegas(playerid, params[])
{
	if(pData[playerid][pJob] == 4 || pData[playerid][pJob2] == 4)
	{
		new id = pData[playerid][pHauling], vehicleid = GetPlayerVehicleID(playerid), carid = -1, total, Float:percent, pay, convert;
		if(id == -1) return Error(playerid, "You dont have hauling.");
		if(IsPlayerInRangeOfPoint(playerid, 3.5, gsData[id][gsPosX], gsData[id][gsPosY], gsData[id][gsPosZ]))
		{
			if(GetPlayerState(playerid) != PLAYER_STATE_DRIVER && !IsATruck(vehicleid)) return Error(playerid, "Anda harus mengendarai truck.");
			if(VehGasOil[vehicleid] < 1) return Error(playerid, "GasOil is empty in this vehicle.");
			if(IsTrailerAttachedToVehicle(GetPlayerVehicleID(playerid)))
			total = VehGasOil[vehicleid] * GStationPrice;
			percent = (total / 100) * 800;
			convert = floatround(percent, floatround_ceil);
			pay = total + convert;
			gsData[id][gsStock] += VehGasOil[vehicleid];
			Server_MinMoney(pay);
			Info(playerid, "Anda menjual "RED_E"%d "WHITE_E"liters gas oil dengan seharga "GREEN_E"%s", VehGasOil[vehicleid], FormatMoney(pay));
			AddPlayerSalary(playerid, "Trucker(Restock GasStation)", pay);
			pData[playerid][pJobTime] += 360;
			if((carid = Vehicle_Nearest(playerid)) != -1)
			{
				pvData[carid][cGasOil] = 0;
				Info(playerid, "Anda mendapatkan uang 80 percent dari hasil stock liters gas oil anda.");
			}
			DestroyVehicle(GetVehicleTrailer(GetPlayerVehicleID(playerid)));
			VehGasOil[vehicleid] = 0;
			pData[playerid][pHauling] = -1;
			GStation_Refresh(id);
			GStation_Save(id);
		}
		else return Error(playerid, "Anda harus berada didekat dengan Gas Oil hauling anda.");
	}
	else return Error(playerid, "You are not trucker job.");
	return 1;
}
