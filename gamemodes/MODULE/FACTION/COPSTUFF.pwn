// New stuff
new UpdateSeconds = 1;
new MaxObjects = 20;

forward UpdateSpeed(playerid);
enum SavePlayerPosEnum 
{
	Float:LastX,
	Float:LastY,
	Float:LastZ
}
#define SLOTS 200

new objectcreated;
new SavePlayerPos[SLOTS][SavePlayerPosEnum];
new distance1[MAX_PLAYERS];


public UpdateSpeed(playerid)
{
	new Float:x,Float:y,Float:z;
	new Float:distance,value;
	for(new i=0; i<SLOTS; i++)
	{
		if(IsPlayerConnected(i))
		{
			GetPlayerPos(i, x, y, z);
			distance = floatsqroot(floatpower(floatabs(floatsub(x,SavePlayerPos[i][LastX])),2)+floatpower(floatabs(floatsub(y,SavePlayerPos[i][LastY])),2)+floatpower(floatabs(floatsub(z,SavePlayerPos[i][LastZ])),2));
    		// Distance: meters in the last second
			value = floatround(distance * 3600);
			if(UpdateSeconds > 1)
			{
				value = floatround(value / UpdateSeconds);
			}
			distance1[i] = floatround(value/1600);

			SavePlayerPos[i][LastX] = x;
			SavePlayerPos[i][LastY] = y;
			SavePlayerPos[i][LastZ] = z;
			
			
			// Speeding controllers
			
			/*                CoordX    CoordY   CoorZ  Radius Speedlimit (MP/H)    */
			
        	AddSpeedingCam(i, 1350.9496, -1112.5031, 28.0000, 20, 60);
            AddSpeedingCam(i, 790.7557, -1776.3378, 21.0000, 20, 80);
            AddSpeedingCam(i, 681.2205, -1139.5607, 22.0000, 20, 70);
            AddSpeedingCam(i, 1797.2307, -2678.8931, 10.0000, 20, 90);
			AddSpeedingCam(i, 2879.8845, -1295.8997, 15.0000, 20, 60);
 			AddSpeedingCam(i, 2263.1226, -1741.4176, 22.0000, 20, 65);
 			AddSpeedingCam(i, 1073.4392, -1390.1713, 18.0000, 20, 75);
 			AddSpeedingCam(i, -128.4532, -1318.2719, 6.0000, 20, 65);
 			AddSpeedingCam(i, 1857.1750, -1477.2706, 17.0000, 20, 70);
		}
	} 
} 

stock AddSpeedingCam(playerid, Float:xx, Float:yy, Float:zz, radius, speed)
{
	//new fine[MAX_PLAYERS];
 	//new str[256];

 	if(objectcreated!=MaxObjects)
  	{
    	CreateObject(playerid, xx, yy, zz, 0.0, 0.0, 10);
     	objectcreated++;
  	}
  	if((distance1[playerid])>speed)
  	{
		if(IsPlayerInRangeOfPoint(playerid, radius, xx, yy, zz)  && GetPlayerState(playerid)== PLAYER_STATE_DRIVER)
		{
			if(IsPlayerInAnyVehicle(playerid))
			{	
				//new vehicleid = GetPlayerVehicleID(playerid);
				new vehid = GetPlayerVehicleID(playerid);
				foreach(new ii : PVehicles)
				{
					if(vehid == pvData[ii][cVeh])
					{
						//new vehicleid = GetPlayerVehicleID(playerid);
						new locationStrings[40], zoneStrings[MAX_ZONE_NAME];
					  	locationStrings[0] = zoneStrings[0] = EOS;
						GetPlayer2DZone(playerid, zoneStrings, MAX_ZONE_NAME);
						//new vehid = GetPlayerVehicleID(playerid);
						//fine[playerid]=((distance1[playerid]*17/10)-speed);
						//GivePlayerMoney(playerid, -fine[playerid]);
			            SendClientMessage(playerid, COLOR_PURPLE, "You bypassed the Police Automatic Speeding camera too fast and its light flashed for you.");
						Info(playerid, "[SPEED CAM] You were driving faster than %d MP/H (Your speed was %d MP/H)",speed, distance1[playerid]);
			            //GameTextForPlayer(playerid, "~r~AUTOMATIC SPEEDING CAMERA!", 5000, 3);
			            PlayerPlaySound(playerid, 1132, 0.0, 0.0, 0.0);
						SendFactionMessage(1, COLOR_RADIO, "[SPEED CAM] has seen a vehicle that exceeds the speed");
						SendFactionMessage(1, COLOR_RADIO, "Location : %s || Model : %s || Plate : %s || Vehicle Speed : %d MP/H", zoneStrings, GetVehicleName(pvData[ii][cVeh]), pvData[ii][cPlate], distance1[playerid]);
					}
				}
			}
		}
	}
}

