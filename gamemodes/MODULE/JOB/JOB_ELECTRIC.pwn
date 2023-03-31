new tangga1, tangga2;
enum	e_Electricdata
{
	Float: ElectricX,
	Float: ElectricY,
	Float: ElectricZ,
	Text3D: ElectricLabel
}

new
	ElectricData[][e_Electricdata] = {
	{754.00000, 1884.63281, 4.85156},
	{719.39844, 1794.82813, 4.71875},
	{754.00000, 1884.63281, 4.85156},
	{-239.12160, 2757.57202, 61.38760}
};

new
	ElectricCP[MAX_PLAYERS] = {-1, ...};

Electric_Closest(playerid)
{
	new closest_id = -1, Float: dist = 3.0, Float: tempdist;
    for(new i; i < sizeof(ElectricData); i++)
	{
	    tempdist = GetPlayerDistanceFromPoint(playerid, ElectricData[i][ElectricX], ElectricData[i][ElectricY], ElectricData[i][ElectricZ]);
		if(tempdist > 3.0) continue;
		if(tempdist <= dist)
		{
		    dist = tempdist;
		    closest_id = i;
		}
	}
	return closest_id;
}

function MovedS1(playerid)
{
	MoveDynamicObject(tangga1, -770.86072, 2740.76587, 42.99480, 2.00);
}
function MovedS2()
{
	MoveObject(tangga2, -1462.87024, 2527.30664, 53.48190, 2.00);
}

/*
tangga1(playerid); {
	MoveObject(tangga1, -770.86072, 2740.87280, 46.07280, 2.00, 13.00000, 0.00000, 0.00000);
}
tangga2(playerid); {
	MoveObject(tangga2, -1462.54321, 2527.04883, 56.42190, 2.00, 7.00000, 0.00000, -130.00000);
}
*/

CMD:services(playerid, params[])
{
	if(IsPlayerInAnyVehicle(playerid)) return Error(playerid, "You can't use this command in a vehicle.");
	new vehicleid = GetPVarInt(playerid, "LastVehicleID");
	if(GetVehicleModel(vehicleid) != 552) return Error(playerid, "Your last vehicle has to be a Electric.");
    
	new id = Electric_Closest(playerid);
	if(id == -1) return Error(playerid, "Anda Tidak Berada Di dekat tiang listrik.");

	ApplyAnimation(playerid, "CARRY", "liftup105", 4.1, 0, 0, 0, 0, 0);

	//1
	if(IsPlayerInRangeOfPoint(playerid, 0.3, -770.89148, 2741.13550, 39.22420))
	{
		MoveDynamicObject(tangga1, -770.86072, 2740.87280, 46.07280, 2.00);
    	SetTimerEx("MovedS1", 5000, false, "i", playerid);
	}
	//2
	else if(IsPlayerInRangeOfPoint(playerid, 10.5, -1462.59180, 2527.11865, 49.64470))
	{
		pData[playerid][pActivity] = SetTimerEx("FillElectric", 1300, true, "i", playerid);
	    PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Memasang Tangga...");
		PlayerTextDrawShow(playerid, ActiveTD[playerid]);
		ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
		MoveObject(tangga2, -1462.54321, 2527.04883, 56.42190, 2.00);
    	SetTimer("MovedS2", 5000, false);
	}
	return 1;
}