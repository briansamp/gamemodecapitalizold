#define MAX_RANDOM_MESSAGE 4
#define COLOR_LIGHTBLUE 0x33CCFFAA
forward PaintBallStarting(playerid);
forward PaintBallStart(playerid);
forward PaintBallEnd(playerid);

new DeagleVote;
new ShotgunVote;
new M4Vote;
new Mp5Vote;
new SnipeVote;
new PlayerPBKills[MAX_PLAYERS];
new bool:PlayerPBing[MAX_PLAYERS];
new PBLeaderid = 999;
new PBLeaderKills = 0;
new PBPlayers = 0;
new PBGunID;
new bool:PBStarted;

new PBSkins[] =
{
	137,
	181,
	212
};

new Float:PBSpawns[][] =
{
	{-348.1376,2222.3022,42.4912,0.5975}, // Spawn 1
	{-366.0266,2263.8604,42.5641,271.2900}, // Spawn 2
	{-431.7350,2240.2869,42.9834,178.7918}, // Spawn 3
	{-452.6353,2217.8867,42.4297,189.6790}, // spawn 4
	{-392.8849,2198.0518,42.4245,189.0656} // spawn
};

public PaintBallStarting(playerid)
{
		new string[128];
		format(string,sizeof(string),"A PaintBall Match Is Going To Start You Have 30 Second's To Join This Match (Current Player's : %d)",PBPlayers);
	    SendClientMessageToAll(COLOR_LIGHTBLUE,string);
	    SetTimer("PaintBallStart",30000,false);
}
public PaintBallStart(playerid)
{
	PBStarted = true;
    SendClientMessageToAll(COLOR_LIGHTBLUE,"PaintBall Match Has Been Started You Can Not Join Now");
    if(PlayerPBing[playerid] == true)
	{
		if(DeagleVote > ShotgunVote && DeagleVote > M4Vote && DeagleVote > Mp5Vote && DeagleVote > SnipeVote )
		{
		    ResetPlayerWeapons(playerid);
		    GivePlayerWeapon(playerid,24,99999);
		    SendClientMessage(playerid,COLOR_LIGHTRED,"PaintBall Match Has Been Started With Gun Deagle");
		    SendClientMessage(playerid,COLOR_LIGHTRED,"PaintBall Match Will Be End In 3 Min's");
		    TogglePlayerControllable(playerid,1);
		    PBGunID = 24;
		    SetTimer("PaintBallEnd",180000,false);
		}
		if(ShotgunVote > DeagleVote && ShotgunVote > M4Vote && ShotgunVote > Mp5Vote && ShotgunVote > SnipeVote )
		{
			ResetPlayerWeapons(playerid);
		    GivePlayerWeapon(playerid,25,99999);
		    SendClientMessage(playerid,COLOR_LIGHTRED,"PaintBall Match Has Been Started With Gun Shotgun");
		    SendClientMessage(playerid,COLOR_LIGHTRED,"PaintBall Match Will Be End In 3 Min's");
		    TogglePlayerControllable(playerid,1);
		    PBGunID = 25;
		    SetTimer("PaintBallEnd",180000,false);
		}
		if(M4Vote > DeagleVote && M4Vote > ShotgunVote && M4Vote > Mp5Vote && M4Vote > SnipeVote )
		{
			ResetPlayerWeapons(playerid);
		    GivePlayerWeapon(playerid,31,99999);
		    SendClientMessage(playerid,COLOR_LIGHTRED,"PaintBall Match Has Been Started With Gun M4");
		    SendClientMessage(playerid,COLOR_LIGHTRED,"PaintBall Match Will Be End In 3 Min's");
		    TogglePlayerControllable(playerid,1);
		    PBGunID = 31;
		    SetTimer("PaintBallEnd",180000,false);
		}
		if(Mp5Vote > DeagleVote && Mp5Vote > ShotgunVote && Mp5Vote > M4Vote && Mp5Vote > SnipeVote )
		{
			ResetPlayerWeapons(playerid);
		    GivePlayerWeapon(playerid,29,99999);
		    SendClientMessage(playerid,COLOR_LIGHTRED,"PaintBall Match Has Been Started With Gun Mp5");
		    SendClientMessage(playerid,COLOR_LIGHTRED,"PaintBall Match Will Be End In 3 Min's");
		    TogglePlayerControllable(playerid,1);
		    PBGunID = 29;
		    SetTimer("PaintBallEnd",180000,false);
		}
		if(SnipeVote > DeagleVote && SnipeVote > ShotgunVote && SnipeVote > M4Vote && SnipeVote > M4Vote )
		{
			ResetPlayerWeapons(playerid);
		    GivePlayerWeapon(playerid,34,99999);
		    SendClientMessage(playerid,COLOR_LIGHTRED,"PaintBall Match Has Been Started With Gun Sniper");
		    SendClientMessage(playerid,COLOR_LIGHTRED,"PaintBall Match Will Be End In 3 Min's");
		    TogglePlayerControllable(playerid,1);
		    PBGunID = 34;
		    SetTimer("PaintBallEnd",180000,false);
		}
	}
	return 1;
}
public PaintBallEnd(playerid)
{
	new string[128],string2[128],name[MAX_PLAYER_NAME];

	GetPlayerName(PBLeaderid,name,MAX_PLAYER_NAME);

	PBStarted = false;
	DeagleVote = 0;
	M4Vote = 0;
	Mp5Vote = 0;
	ShotgunVote = 0;
	SnipeVote = 0;

	for(new i = 0;i < MAX_PLAYERS; i++)
	{
		if(PlayerPBing[i] == true)
		{
			SetPlayerPos(i,1310.1099,-1367.9067,13.5421);
			ResetPlayerWeapons(i);
			SetPlayerHealth(i,100.0);
			SetPlayerArmour(i,0.0);
			SendClientMessage(i,COLOR_YELLOW,"The Paintball Ended");
			format(string,sizeof(string),""COL_WHITE"The Winner Of Paintball Is "COL_RED"%s(%d) "COL_WHITE"With Total of "COL_RED"%d "COL_WHITE"Kills",name,PBLeaderid,PBLeaderKills);
			format(string2,sizeof(string2),"Total Players Of This PaintBall Was %d",PBPlayers);
			SendClientMessage(i,COLOR_WHITE,string);
			SendClientMessage(i,COLOR_LIGHTBLUE,string2);
			PlayerPBKills[i] = 0;
			PlayerPBing[i] = false;
			PBPlayers = 0;
			PBLeaderid = 999;
			PBLeaderKills = 0;
			PBGunID = 0;
		}
	}
	return 1;
}
CMD:pbenter(playerid, params[])
{
	//if(IsPlayerInRangeOfPoint(playerid,3.0,1310.1099,-1367.9067,13.5421))
	{
	    if(PBStarted == false)
	    {
	    new RandomSpawn = random(sizeof(PBSpawns));
	    new RandomSkin = random(sizeof(PBSkins));
	    SetPlayerSkin(playerid,PBSkins[RandomSkin]);
		SetPlayerPos(playerid,PBSpawns[RandomSpawn][0],PBSpawns[RandomSpawn][1],PBSpawns[RandomSpawn][2]);
		SetPlayerFacingAngle(playerid,PBSpawns[RandomSpawn][3]);
		SetPlayerArmour(playerid,50.0);
		SetPlayerHealth(playerid,100.0);
		ShowPlayerDialog(playerid, DIALOG_PB,2,"Vote For PaintBall Weapon :","Deagel\nShotgun\nM4\nMp5\nSniper","Vote","Quit");
		TogglePlayerControllable(playerid,0);
		PlayerPBing[playerid] = true;
		PBPlayers++;
		}
		else
		{
			SendClientMessage(playerid,COLOR_LIGHTRED,"PaintBall Round Has Been Started You Need To Wait 3 Min's To Start New Round");
		}
	}
	return 1;
}
CMD:gotosmall(playerid,params[])
{
	SetPlayerInterior(playerid,1);
	SetPlayerPos(playerid,-1401.6968,107.1886,1032.2734);
	return 1;
}
CMD:gotonormal(playerid,params[])
{
	SetPlayerInterior(playerid,14);
	SetPlayerPos(playerid,-1486.5941,1567.7218,1052.5313);
	return 1;
}
CMD:gotohuge(playerid,params[])
{
	SetPlayerInterior(playerid,15);
	SetPlayerPos(playerid,-1365.6370,931.1339,1036.3071);
	return 1;
}
