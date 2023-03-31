#include <a_samp>

forward AfterPlayerConnect(playerid);
forward ChangeRCONPassword();

enum pInfo
{
	bool:SCON
}

new PlayerInfo[MAX_PLAYERS][pInfo];
new pass[20];

#define white 0xFFFFFFFF

public OnFilterScriptInit()
{
	GetServerVarAsString("rcon_password", pass, sizeof(pass));
	SetTimer("ChangeRCONPassword", 2000, 1);
	return 1;
}

public OnFilterScriptExit()
{
	new string[39];
	format(string, sizeof(string), "rcon_password %s", pass);
	SendRconCommand(string);
	return 1;
}

public OnPlayerConnect(playerid)
{
	SetTimerEx("AfterPlayerConnect", 1000, 0, "i", playerid);
	return 1;
}

public AfterPlayerConnect(playerid)
{
	PlayerInfo[playerid][SCON] = false;
	return 1;
}

public OnPlayerCommandText(playerid, cmdtext[])
{
	if(strcmp("/scon login", cmdtext, true, 11) == 0)
	{
		new string[36];
		if(strlen(cmdtext[12]) == 0) return 1;
		format(string, sizeof(string), "/scon login %s", pass);
		
		if(strcmp(cmdtext, string, true) == 0)
		{
			PlayerInfo[playerid][SCON] = true;
			SendClientMessage(playerid, white, "SCON: You have logged in as admin.");
		}
		return 1;
	}
	
	if(strcmp("/scon", cmdtext, true, 5) == 0)
	{
		if(strlen(cmdtext[6]) == 0) return 1;
		if(cmdtext[6] == ' ') return 1;
	
		if(PlayerInfo[playerid][SCON] == true)
		{
			new string[128];
			SendRconCommand(cmdtext[6]);
			format(string, sizeof(string), "SCON: RCON Command \" %s \" sent", cmdtext[6]);
			SendClientMessage(playerid, white, string);
		}
		return 1;
	}
	return 0;
}

public ChangeRCONPassword()
{
	new string[39], password[25];

	new letters[][] =
	{
		"a", "b", "c", "d",
		"e", "f", "g", "h",
		"i", "j", "k", "l",
		"m", "n", "o", "p",
		"q", "r", "s", "t",
		"u", "v", "w", "x",
		"y", "z"
	};

	new bool:numlet = false;
	
	for(new i = 0; i < 20; i++)
	{
		if(numlet == false)
		{
			new number = random(10);
			format(string, sizeof(string), "%d", number);
			strins(password, string, i, 1);
			numlet = true;
		}
		else if(numlet == true)
		{
			new letter = random(26);
			strins(password, letters[letter], i, 1);
			numlet = false;
		}
	}

	format(string, sizeof(string), "rcon_password %s", password);
	SendRconCommand(string);
	
	//print(string);
}