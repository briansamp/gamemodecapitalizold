//=========[ Anticheat ]
new AntiCheatKontol = 1;
#define MAX_ANTICHEAT_WARNINGS   	3

/*public OnPlayerTeleport(playerid, Float:distance)
{
	if((AntiCheatKontol) && pData[playerid][pAdmin] < 2)
	{
	    if(!IsPlayerInRangeOfPoint(playerid, 3.0, pData[playerid][pPosX], pData[playerid][pPosY], pData[playerid][pPosZ]))
	    {
		    pData[playerid][pACWarns]++;

		    if(pData[playerid][pACWarns] < MAX_ANTICHEAT_WARNINGS)
		    {
	    	    SendAnticheat(COLOR_YELLOW, ""RED_E"%s"WHITE_E"[%i] is possibly teleport hacking (distance: %.1f).", ReturnName(playerid), playerid, distance);
			}
			else
			{
		    	SendClientMessageToAllEx(COLOR_RED, "[ANTICHEAT]: %s"WHITE_E" telah dikick otomatis oleh %s, Alasan: Teleport hacks", ReturnName(playerid), SERVER_BOT);
		    	KickEx(playerid);
			}
		}
	}

	return 1;
}
*/

#include <YSI_Coding\y_hooks.inc>
#include <YSI\y_iterate>

new SilentAimCount[MAX_PLAYERS],ProAimCount[MAX_PLAYERS],TintaApasata[MAX_PLAYERS];

hook OnPlayerWeaponShot(playerid, weaponid, hittype, hitid, Float:fX, Float:fY, Float:fZ)
{
	if(weaponid != 38 && weaponid > 18 && weaponid < 34 && hittype == 1)
	{
		new Float:cood[6],Float:DistanceAim;
		GetPlayerPos(hitid, cood[0], cood[1], cood[2]); 
		DistanceAim = GetPlayerDistanceFromPoint(playerid, cood[0], cood[1], cood[2]);
		
		if(GetPlayerTargetPlayer(playerid) == INVALID_PLAYER_ID && DistanceAim > 1 && DistanceAim < 31 && TintaApasata[playerid] == 1)
		{
			SilentAimCount[playerid]++;
			if(SilentAimCount[playerid] == 5)
			{
				SendAdminMessage(COLOR_RED, "%s(%d) possible use Silent Aim cheat with %s (Distance: %i meters)", ReturnName(playerid), playerid, ReturnWeaponName(weaponid), floatround(DistanceAim));
			}
			if(SilentAimCount[playerid] >= 10)
			{
				SilentAimCount[playerid] = 0;
				SendClientMessageToAllEx(COLOR_RED, "BotCmd: %s have been auto kicked for Silent Aim hacks!", pData[playerid][pName]);
			}
			return 1;
		}
		GetPlayerLastShotVectors(playerid, cood[0], cood[1], cood[2], cood[3], cood[4], cood[5]);
		if(!IsPlayerInRangeOfPoint(hitid, 3.0, cood[3], cood[4], cood[5])) 
		{
			ProAimCount[playerid]++;
			if(ProAimCount[playerid] == 3)
			{
				SendAdminMessage(COLOR_RED, "%s(%d) possible use ProAim cheat with: %s (Distance: %i meters)", ReturnName(playerid), playerid, ReturnWeaponName(weaponid), floatround(DistanceAim));
			}
			if(ProAimCount[playerid] >= 5)
			{
				ProAimCount[playerid] = 0;
				SendClientMessageToAllEx(COLOR_RED, "BotCmd: %s have been auto kicked for Pro Aim hacks!", pData[playerid][pName]);
			}
		}
	}
	return 1;
}

public OnPlayerAirbreak(playerid)
{
	if((AntiCheatKontol) && pData[playerid][pAdmin] < 2)
	{
	    pData[playerid][pACWarns]++;

	    if(pData[playerid][pACWarns] < MAX_ANTICHEAT_WARNINGS)
	    {
	        SendAnticheat(COLOR_YELLOW, ""RED_E"%s"WHITE_E"[%i] is possibly using airbreak hacks.", ReturnName(playerid), playerid);
		}
		else
		{
			new PlayerIP[16], giveplayer[24];
	
			GetPlayerName(playerid, giveplayer, sizeof(giveplayer));
			GetPlayerIp(playerid, PlayerIP, sizeof(PlayerIP));

		    SendClientMessageToAllEx(COLOR_RED, ""RED_E"[ANTICHEAT]: %s"WHITE_E" telah dibanned otomatis oleh %s, Alasan: Airbreak", ReturnName(playerid), SERVER_BOT);

			new query[248];
			mysql_format(g_SQL, query, sizeof(query), "INSERT INTO banneds(name, ip, admin, reason, ban_date, ban_expire) VALUES ('%s', '%s', '%s', '%s', %i, %d)", giveplayer, PlayerIP, SERVER_BOT, "Airbreak", gettime(), 0);
			mysql_tquery(g_SQL, query);
			KickEx(playerid);
		}
	}
	return 1;
}

stock NgecekCiter(playerid)
{
	if(gettime() > pData[playerid][pACTime])
	{
	    // Speedhacking
		if((AntiCheatKontol) && GetPlayerState(playerid) == PLAYER_STATE_DRIVER && GetVehicleSpeed(GetPlayerVehicleID(playerid)) > 350 && pData[playerid][pAdmin] < 2)
		{
		    pData[playerid][pACWarns]++;

		    if(pData[playerid][pACWarns] < MAX_ANTICHEAT_WARNINGS)
		    {
                SendAnticheat(COLOR_YELLOW, ""RED_E"%s"WHITE_E"[%i] is possibly speedhacking, speed: %.1f km/h.", ReturnName(playerid), playerid, GetVehicleSpeed(GetPlayerVehicleID(playerid)));
			}
			else
			{
                SendClientMessageToAllEx(COLOR_RED, "[ANTICHEAT]: %s"WHITE_E" telah dikick otomatis oleh %s, Alasan: Speed hacks", ReturnName(playerid), SERVER_BOT);
		    	KickEx(playerid);
			}
		}

		// Jetpack
		if(GetPlayerSpecialAction(playerid) == SPECIAL_ACTION_USEJETPACK && pData[playerid][pAdmin] < 2 && !pData[playerid][pJetpack])
		{
            SendClientMessageToAllEx(COLOR_RED, "[ANTICHEAT]: %s"WHITE_E" telah dikick otomatis oleh %s, Alasan: Jetpack hacks", ReturnName(playerid), SERVER_BOT);
		    KickEx(playerid);
		}

		// Flying hacks
		if((AntiCheatKontol) && GetPlayerState(playerid) == PLAYER_STATE_ONFOOT)
		{
			switch(GetPlayerAnimationIndex(playerid))
			{
			    case 958, 1538, 1539, 1543:
			    {
			        new
			            Float:z,
			            Float:vx,
			            Float:vy,
			            Float:vz;

					GetPlayerPos(playerid, z, z, z);
                    GetPlayerVelocity(playerid, vx, vy, vz);

                    if((z > 20.0) && (0.9 <= floatsqroot((vx * vx) + (vy * vy) + (vz * vz)) <= 1.9) && pData[playerid][pAdmin] < 2)
                    {
                        SendClientMessageToAllEx(COLOR_RED, "[ANTICHEAT]: %s"WHITE_E" telah dikick otomatis oleh %s, Alasan: Flying hacks", ReturnName(playerid), SERVER_BOT);
                        KickEx(playerid);
					}
				}
			}
		}

			// Armor hacks
		if(!IsAtEvent[playerid])
		{
		    new
   				Float:armor;

			GetPlayerArmour(playerid, armor);

  			if(!(gettime() - pData[playerid][pLastUpdate] > 5))
  			{
				if(floatround(armor) > floatround(pData[playerid][pArmour]) && gettime() > pData[playerid][pACTime] && gettime() > pData[playerid][pArmorTime] && pData[playerid][pAdmin] < 2)
				{
		            pData[playerid][pACWarns]++;
	    	        pData[playerid][pArmorTime] = gettime() + 10;

				    if(pData[playerid][pACWarns] < MAX_ANTICHEAT_WARNINGS)
				    {
                        SendAnticheat(COLOR_YELLOW, ""RED_E"%s"WHITE_E"[%i] is possibly Armor hacks, (old: %.2f, new: %.2f)", ReturnName(playerid), playerid, pData[playerid][pArmour], armor);
					}
					else
					{
                        SendClientMessageToAllEx(COLOR_RED, "[ANTICHEAT]: %s"WHITE_E" telah dikick otomatis oleh %s, Alasan: Armor hacks", ReturnName(playerid), SERVER_BOT);
                        KickEx(playerid);
					}
				}
			}

			pData[playerid][pArmour] = armor;
		}
	}

	// Ammo hacks
	if(!IsAtEvent[playerid])
	{
	    new
			weapon,
			ammo;

		GetPlayerWeaponData(playerid, 8, weapon, ammo);

		if((16 <= weapon <= 18) && ammo <= 0)
		{
			RemovePlayerWeapon(playerid, weapon);
		}
	}

	// Warping into vehicles while locked
	/*if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER && GetVehicleParams(GetPlayerVehicleID(playerid), VEHICLE_DOORS) && (!IsVehicleOwner(playerid, GetPlayerVehicleID(playerid)) && pData[playerid][pVehicleKeys] != GetPlayerVehicleID(playerid)))
    {
        new
            Float:x,
            Float:y,
            Float:z;
        GetPlayerPos(playerid, x, y, z);
        SetPlayerPos(playerid, x, y, z + 1.0);
        GameTextForPlayer(playerid, "~r~This vehicle is locked!", 3000, 3);
    }*/
}

stock RemovePlayerWeapon(playerid, weaponid)
{
	// Reset the player's weapons.
	ResetPlayerWeapons(playerid);
	// Set the armed slot to zero.
	SetPlayerArmedWeapon(playerid, 0);
	// Set the weapon in the slot to zero.
	pData[playerid][pACTime] = gettime() + 2;
	pData[playerid][pGuns][g_aWeaponSlots[weaponid]] = 0;
	// Set the player's weapons.
	SetWeapons(playerid);
}

CMD:anticheat(playerid, params[])
{
	new status;

	if(pData[playerid][pAdmin] < 5)
	{
	    return Error(playerid, "Kamu tidak diizinkan untuk menggunakan command ini.");
	}
	if(sscanf(params, "i", status) || !(0 <= status <= 1))
	{
	    return Usage(playerid, "/anticheat [0/1]");
	}

	if(status) {
		SendAdminMessage(COLOR_RED, "[ANTICHEAT]:"WHITE_E" %s telah mengaktifkan anticheat server .", pData[playerid][pAdminname]);
	} else {
		SendAdminMessage(COLOR_RED, "[ANTICHEAT]:"WHITE_E" %s telah menonaktifkan anticheat server .", pData[playerid][pAdminname]);
	}

	AntiCheatKontol = status;
	return 1;
}