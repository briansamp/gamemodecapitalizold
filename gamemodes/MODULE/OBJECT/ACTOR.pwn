//------[ ACTOR SYSTEM RADEETZ ]------
#define MAX_ACTOR 	  500
#define DIALOG_ACANIM 6884

enum Actor
{
	aId,
	Text3D: aTId,
	aSkin,
	aAnim,
	Float:aPosX,
	Float:aPosY,
	Float:aPosZ,
	Float:aPosR,
	aName[80],
	aVW,
	aInt
}

new ActorsInfo[MAX_ACTOR][Actor];

CreateActors(actorid)
{
	new string[256];
	format(string, sizeof(string), "{ADD8E6}[Actors:%d]\n{FFFFFF}%s",actorid, ActorsInfo[actorid][aName]);

	ActorsInfo[actorid][aId] = CreateActor(ActorsInfo[actorid][aSkin], ActorsInfo[actorid][aPosX], ActorsInfo[actorid][aPosY], ActorsInfo[actorid][aPosZ], ActorsInfo[actorid][aPosR]);
	ActorsInfo[actorid][aTId] = CreateDynamic3DTextLabel(string, COLOR_WHITE, ActorsInfo[actorid][aPosX], ActorsInfo[actorid][aPosY], ActorsInfo[actorid][aPosZ]+1,10.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1, ActorsInfo[actorid][aVW], ActorsInfo[actorid][aInt], -1);
	switch(ActorsInfo[actorid][aAnim])
	{
		case 1: {ApplyActorAnimation(actorid,"ped","SEAT_down",4.0,0,0,0,1,0);}
		case 2: {ApplyActorAnimation(actorid,"ped","Idlestance_fat",4.0,0,0,0,1,0);}
		case 3: {ApplyActorAnimation(actorid,"ped","Idlestance_old",4.0,0,0,0,1,0);}
		case 4: {ApplyActorAnimation(actorid,"POOL","POOL_Idle_Stance",4.0,0,0,0,1,0);}
		case 5: {ApplyActorAnimation(actorid,"ped","woman_idlestance",4.0,0,0,0,1,0);}
		case 6: {ApplyActorAnimation(actorid,"ped","IDLE_stance",4.0,0,0,0,1,0);}
		case 7: {ApplyActorAnimation(actorid,"COP_AMBIENT","Copbrowse_in",4.0,0,0,0,1,0);}
		case 8: {ApplyActorAnimation(actorid,"COP_AMBIENT","Copbrowse_loop",4.0,0,0,0,1,0);}
		case 9: {ApplyActorAnimation(actorid,"COP_AMBIENT","Copbrowse_nod",4.0,0,0,0,1,0);}
		case 10: {ApplyActorAnimation(actorid,"COP_AMBIENT","Copbrowse_out",4.0,0,0,0,1,0);}
		case 11: {ApplyActorAnimation(actorid,"COP_AMBIENT","Copbrowse_shake",4.0,0,0,0,1,0);}
		case 12: {ApplyActorAnimation(actorid,"COP_AMBIENT","Coplook_in",4.0,0,0,0,1,0);}
		case 13: {ApplyActorAnimation(actorid,"COP_AMBIENT","Coplook_loop",4.0,0,0,0,1,0);}
		case 14: {ApplyActorAnimation(actorid,"COP_AMBIENT","Coplook_nod",4.0,0,0,0,1,0);}
		case 15: {ApplyActorAnimation(actorid,"COP_AMBIENT","Coplook_out",4.0,0,0,0,1,0);}
		case 16: {ApplyActorAnimation(actorid,"COP_AMBIENT","Coplook_shake",4.0,0,0,0,1,0);}
		case 17: {ApplyActorAnimation(actorid,"COP_AMBIENT","Coplook_think",4.0,0,0,0,1,0);}
		case 18: {ApplyActorAnimation(actorid,"COP_AMBIENT","Coplook_watch",4.0,0,0,0,1,0);}
		case 19: {ApplyActorAnimation(actorid,"GANGS","leanIDLE",4.1,0,0,0,1,0);}
		case 20: {ApplyActorAnimation(actorid,"MISC","Plyrlean_loop",4.1,0,0,0,1,0);}
		case 21: {ApplyActorAnimation(actorid,"KNIFE", "KILL_Knife_Ped_Die",4.1,0,0,0,1,0);}
		case 22: {ApplyActorAnimation(actorid,"PED", "KO_shot_face",4.0,0,0,0,1,0);}
		case 23: {ApplyActorAnimation(actorid,"PED", "KO_shot_stom",4.0,0,0,0,1,0);}
		case 24: {ApplyActorAnimation(actorid,"PED", "BIKE_fallR",4.0,0,0,0,1,0);}
		case 25: {ApplyActorAnimation(actorid,"PED", "BIKE_fall_off",4.0,0,0,0,1,0);}
		case 26: {ApplyActorAnimation(actorid,"SWAT","gnstwall_injurd",4.0,0,0,0,1,0);}
		case 27: {ApplyActorAnimation(actorid,"SWEET","Sweet_injuredloop",4.0,0,0,0,1,0);}
	}
}

LoadActors()
{
	new arrCoords[25][64];
	new strFromFile2[256];
	new File: file = fopen("actors.cfg", io_read);
	if (file)
	{
		new idx;
		while (idx < sizeof(ActorsInfo))
		{
			fread(file, strFromFile2);
			splits(strFromFile2, arrCoords, '|');
	  		ActorsInfo[idx][aId] = strval(arrCoords[0]);
	  		ActorsInfo[idx][aSkin] = strval(arrCoords[1]);
	  		ActorsInfo[idx][aAnim] = strval(arrCoords[2]);
	  		ActorsInfo[idx][aPosX] = floatstr(arrCoords[3]);
	  		ActorsInfo[idx][aPosY] = floatstr(arrCoords[4]);
	  		ActorsInfo[idx][aPosZ] = floatstr(arrCoords[5]);
	  		ActorsInfo[idx][aPosR] = floatstr(arrCoords[6]);
	  		strmid(ActorsInfo[idx][aName], arrCoords[7], 0, strlen(arrCoords[7]), 80);
	  		ActorsInfo[idx][aVW] = strval(arrCoords[8]);
	  		ActorsInfo[idx][aInt] = strval(arrCoords[9]);

	  		if(ActorsInfo[idx][aPosX])
	  		{
		  		if(!IsNull(ActorsInfo[idx][aName]))
		  		{
		  		    CreateActors(idx);
				}
			}

			idx++;
		}
		fclose(file);
	}
	print("[RT:RP Database] Actors Loaded Successfully");
	return 1;
}

SaveActors()
{
	new
		szFileStr[512],
		File: fHandle = fopen("actors.cfg", io_write);

	for(new iIndex; iIndex < MAX_ACTOR; iIndex++) {
		format(szFileStr, sizeof(szFileStr), "%d|%d|%d|%f|%f|%f|%f|%s|%d|%d\r\n",
			ActorsInfo[iIndex][aId],
			ActorsInfo[iIndex][aSkin],
			ActorsInfo[iIndex][aAnim],
			ActorsInfo[iIndex][aPosX],
			ActorsInfo[iIndex][aPosY],
			ActorsInfo[iIndex][aPosZ],
			ActorsInfo[iIndex][aPosR],
			ActorsInfo[iIndex][aName],
			ActorsInfo[iIndex][aVW],
			ActorsInfo[iIndex][aInt]
		);
		fwrite(fHandle, szFileStr);
	}
	print("[RT:RP Database] Actors saved successfully");
	return fclose(fHandle);
}

//--------[ COMMAND ACTOR ]--------
CMD:createactor(playerid, params[])
{
	new skin, name[80];
	if(pData[playerid][pAdmin] < 4) return SEM(playerid, "ERROR: You don't have the privilege to use this command!");
	if(sscanf(params, "is[80]", skin, name)) return Usage(playerid, "/createactor [skinid] [name]");
	new Float:X,Float:Y,Float:Z;
	for(new idx=0; idx<MAX_ACTOR; idx++)
	{
	    if(!ActorsInfo[idx][aSkin])
	    {
	        GetPlayerPos(playerid, ActorsInfo[idx][aPosX], ActorsInfo[idx][aPosY], ActorsInfo[idx][aPosZ]);
			GetPlayerFacingAngle(playerid, ActorsInfo[idx][aPosR]);
			GetPlayerPos(playerid, X,Y,Z);
			SetPlayerPos(playerid, X+5,Y,Z);
  			ActorsInfo[idx][aSkin] = skin;
			format(ActorsInfo[idx][aName], 80, "%s", name);
			CreateActors(idx);
			// Text
			/*format(string, sizeof(string), "[AdmCmd]{FFFFFF} %s telah membuat Actors ID %d. (Skin: %d ; Name: %s)", GetPlayerNameEx(playerid), idx, skin, name);
			SendAdminMessage(COLOR_YELLOW, string);
			Log("logs/actors.log", string);*/
			idx = MAX_ACTOR;
			SaveActors();
		}
	}
	return 1;
}

CMD:usedactor(playerid, params[])
{
	new string[128];
	if(pData[playerid][pAdmin] < 4) return SEM(playerid, "ERROR: You don't have the privilege to use this command!");
	SendClientMessage(playerid, COLOR_LBLUE, "[Used Actors]:");
	for(new idx=0; idx<MAX_ACTOR; idx++)
	{
	    if(ActorsInfo[idx][aId])
	    {
			format(string, sizeof(string), "ID: %d | Skin: %d | VW: %d | Int: %d", idx, ActorsInfo[idx][aSkin], ActorsInfo[idx][aVW], ActorsInfo[idx][aInt]);
			SendClientMessage(playerid, COLOR_LBLUE, string);
	    }
	}
	return 1;
}

CMD:gotoactor(playerid, params[])
{
    new idx, string[128];
	if(pData[playerid][pAdmin] < 4) return SEM(playerid, "ERROR: You don't have the privilege to use this command!");
	if(sscanf(params, "i", idx)) return Usage(playerid, "/gotoactor [actorid]");
	if(!ActorsInfo[idx][aId]) return SEM(playerid, "ERROR: Invalid actors id.");
	SetPlayerPos(playerid, ActorsInfo[idx][aPosX], ActorsInfo[idx][aPosY], ActorsInfo[idx][aPosZ]);
	format(string, sizeof(string), "TELEPORT: "WHITE_E"You have teleported to actors ID %d", idx);
	SendClientMessage(playerid, COLOR_RIKO, string);
	return 1;
}

CMD:actorname(playerid, params[])
{
	if(pData[playerid][pAdmin] < 4)
	{
		SEM(playerid, "ERROR: You don't have the privilege to use this command!");
		return 1;
	}

	new actorid, actorname[128];

	if(sscanf(params, "ds[128]", actorid, actorname)) return Usage(playerid, "/actorname [actorid] [name]");

	format(ActorsInfo[actorid][aName], 80, "%s", actorname);
	SendClientMessageEx(playerid, COLOR_LBLUE, "ACTORS: "WHITE_E"You have changed the name of the actors!");
	if(IsValidActor(ActorsInfo[actorid][aId])) DestroyActor(ActorsInfo[actorid][aId]);
	if(IsValidDynamic3DTextLabel(ActorsInfo[actorid][aTId])) DestroyDynamic3DTextLabel(ActorsInfo[actorid][aTId]);
	CreateActors(actorid);
	SaveActors();

	/*format(string, sizeof(string), "ACTORS: %s has edited actors [ID:%d]'s Name to %s.", GetPlayerNameEx(playerid), actorid, actorname);
	Log("logs/aedit.log", string);*/
	return 1;
}

CMD:actoranim(playerid, params[])
{
	if(pData[playerid][pAdmin] < 4)
	{
		SEM(playerid, "ERROR: You don't have the privilege to use this command!");
		return 1;
	}

	new actorid;
	if(sscanf(params, "d", actorid))
	{
		Usage(playerid, "/actoranim [actorid]");
		return 1;
	}

	SetPVarInt(playerid, "aPlayAnim", actorid);
	if(actorid >= MAX_ACTOR)
	{
  		SEM(playerid, "ERROR: Invalid Actors ID!");
		return 1;
	}

	ShowPlayerDialog(playerid, DIALOG_ACANIM, DIALOG_STYLE_LIST, "Actor Anim",
 	"Seat down\nIdlestance Fat\nIdlestance Old\nPool Idle Stance\nWoman Idlestance\nIdle Stance\nCopbrowse In\nCopbrowse Loop\nCopbrowse Nod\nCopbrowse Out\nCopbrowse shake\nCoplook In\nCoplook Loop\nCoplook Nod\nCoplook Out\nCoplook Shake\nCoplook Think\nCoplook Watch\nLean Idle\nPlyrlean Loop\nKILL Knife Ped Die\nKO Shot Face\nKO Shot Stom\nBike FallR\nBike Fall Off\nGnstwall Injurd\nSweet Injuredloop"
	, "Pilih", "Close");
	return 1;
}

CMD:actoredit(playerid, params[])
{
    if(pData[playerid][pAdmin] < 4)
	{
		SEM(playerid, "ERROR: You don't have the privilege to use this command!");
		return 1;
	}

	new string[128], choice[32], actorid, amount;
	if(sscanf(params, "s[32]dD", choice, actorid, amount))
	{
		Usage(playerid, "/actoredit [name] [actorid] [amount]");
		SendClientMessageEx(playerid, COLOR_RIKO, "Available name: "WHITE_E"Exterior, Skin, Delete, Refresh, Clearanim");
		return 1;
	}

	if(actorid >= MAX_ACTOR)
	{
		SEM(playerid, "ERROR: Invalid Actors ID!");
		return 1;
	}

	if(strcmp(choice, "exterior", true) == 0)
	{
  		if(ActorsInfo[actorid][aPosX])
  		{
	  		if(!IsNull(ActorsInfo[actorid][aName]))
	  		{
				GetPlayerPos(playerid, ActorsInfo[actorid][aPosX], ActorsInfo[actorid][aPosY], ActorsInfo[actorid][aPosZ]);
				GetPlayerFacingAngle(playerid, ActorsInfo[actorid][aPosR]);
				ActorsInfo[actorid][aVW] = GetPlayerVirtualWorld(playerid);
				ActorsInfo[actorid][aInt] = GetPlayerInterior(playerid);
				SendClientMessageEx(playerid, COLOR_LBLUE, "ACTORS: "WHITE_E"You have changed the exterior!");
				if(IsValidActor(ActorsInfo[actorid][aId])) DestroyActor(ActorsInfo[actorid][aId]);
				if(IsValidDynamic3DTextLabel(ActorsInfo[actorid][aTId])) DestroyDynamic3DTextLabel(ActorsInfo[actorid][aTId]);
				CreateActors(actorid);
				SaveActors();
				/*format(string, sizeof(string), "[ActorS] Admin %s has edited actorid %d's Exterior.", GetPlayerNameEx(playerid), actorid);
				Log("logs/aedit.log", string);*/
			}
			else
			{
				SEM(playerid, "ERROR: The Actors not created.");
			}
		}
	}
	else if(strcmp(choice, "skin", true) == 0)
	{
		ActorsInfo[actorid][aSkin] = amount;

		format(string, sizeof(string), "ACTORS: "WHITE_E"You have changed skin "YELLOW_E"%d", amount);
		SendClientMessageEx(playerid, COLOR_RIKO, string);

		if(IsValidActor(ActorsInfo[actorid][aId])) DestroyActor(ActorsInfo[actorid][aId]);
		if(IsValidDynamic3DTextLabel(ActorsInfo[actorid][aTId])) DestroyDynamic3DTextLabel(ActorsInfo[actorid][aTId]);
		CreateActors(actorid);

		SaveActors();
		/*format(string, sizeof(string), "ACTORS: Admin %s has edited actorid %d's Skin.", GetPlayerNameEx(playerid), actorid);
		Log("logs/aedit.log", string);*/
		return 1;
	}
	else if(strcmp(choice, "clearanim", true) == 0)
	{
		ActorsInfo[actorid][aAnim] = 0;
		ClearActorAnimations(actorid);

		format(string, sizeof(string), "ACTORS: "WHITE_E"You have clear animation actorid "YELLOW_E"}%d", actorid);
		SendClientMessageEx(playerid, COLOR_RIKO, string);

		SaveActors();
		/*format(string, sizeof(string), "ACTORS: Admin %s has clear animation actorid %d.", GetPlayerNameEx(playerid), actorid);
		Log("logs/aedit.log", string);*/
		return 1;
	}
	else if(strcmp(choice, "refresh", true) == 0)
	{
		format(string, sizeof(string), "ACTORS: "WHITE_E"You have refresh actor id "YELLOW_E"%d", actorid);
		SendClientMessageEx(playerid, COLOR_RIKO, string);

		if(IsValidActor(ActorsInfo[actorid][aId])) DestroyActor(ActorsInfo[actorid][aId]);
		if(IsValidDynamic3DTextLabel(ActorsInfo[actorid][aTId])) DestroyDynamic3DTextLabel(ActorsInfo[actorid][aTId]);
		CreateActors(actorid);

		SaveActors();
		/*format(string, sizeof(string), "ACTORS: Admin %s has refresh actorid %d.", GetPlayerNameEx(playerid), actorid);
		Log("logs/aedit.log", string);*/
		return 1;
	}
	else if(strcmp(choice, "delete", true) == 0)
	{
    	if(IsValidActor(ActorsInfo[actorid][aId])) DestroyActor(ActorsInfo[actorid][aId]);
	    DestroyDynamic3DTextLabel(ActorsInfo[actorid][aTId]);
		ActorsInfo[actorid][aName] = 0;
		ActorsInfo[actorid][aVW] = 0;
		ActorsInfo[actorid][aInt] = 0;
		ActorsInfo[actorid][aPosX] = 0;
		ActorsInfo[actorid][aPosY] = 0;
		ActorsInfo[actorid][aPosZ] = 0;
		ActorsInfo[actorid][aPosR] = 0;
		ActorsInfo[actorid][aSkin] = 0;
		SaveActors();
		/*format(string, sizeof(string), "ACTORS: {FFFFFF}You have delete actor id {FFFF00}%d.", actorid);*/
		//SendClientMessageEx(playerid, COLOR_RIKO, string);
		/*format(string, sizeof(string), "ACTORS: Admin %s has delete actors id %d", GetPlayerNameEx(playerid), actorid);
		Log("logs/aedit.log", string);*/
		return 1;
	}
	return 1;
}
