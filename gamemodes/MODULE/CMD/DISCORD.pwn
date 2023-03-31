new DCC_Channel:g_Admin_Command;

function DJailPlayer(NameToJail[], jailTime, jailReason[])
{
	if(cache_num_rows() < 1)
	{
		SendErrorEmbedMessage(inchanel, "This Account Does Not Exist!");
	}
	else
	{
	    new RegID, JailMinutes = jailTime * 60;
		cache_get_value_index_int(0, 0, RegID);

		SendClientMessageToAllEx(COLOR_RED, "BotCmd: menjail(offline) player %s selama %d menit. [Reason: %s]", NameToJail, jailTime, jailReason);
		DCC_SendChannelMessage(inchanel, "Succesfull Jail This Player!");
		new query[512];
		mysql_format(g_SQL, query, sizeof(query), "UPDATE players SET jail=%d WHERE reg_id=%d", JailMinutes, RegID);
		mysql_tquery(g_SQL, query);
	}
	return 1;
}
function DcOnUnbanQueryData(BannedName[])
{
	if(cache_num_rows() > 0)
	{
		new banIP[16], query[128];
		cache_get_value_name(0, "ip", banIP);
		mysql_format(g_SQL, query, sizeof(query), "DELETE FROM banneds WHERE ip = '%s'", banIP);
		mysql_tquery(g_SQL, query);
	}
	else
	{
		DCC_SendChannelMessage(inchanel, "This Account Does Not found on ban list!");
	}
	return 1;
}

forward OnPostPlayerStat(playerid);

new 
	DCC_Message:StatMessage = DCC_Message:0,
    StatTarget;

DeleteSavedStatMessage()
{
    DCC_DeleteInternalMessage(StatMessage);
    StatMessage = DCC_Message:0;
}

public DCC_OnMessageReaction(DCC_Message:message, DCC_User:reaction_user, DCC_Emoji:emoji, DCC_MessageReactionType:reaction_type)
{
    new DCC_Channel:channel, bool:bot;
    DCC_GetMessageChannel(message, channel);

    if(reaction_type == REACTION_ADD)
    {
        if(!DCC_IsUserBot(reaction_user, bot))
            return 1;
        if(bot)
            return 1;

        if(StatMessage == message && _:StatMessage != 0)
        {
            new emoji_name[DCC_EMOJI_NAME_SIZE];
            DCC_GetEmojiName(emoji, emoji_name);
            new name[MAX_PLAYER_NAME];
            GetPlayerName(StatTarget, name, MAX_PLAYER_NAME);

            new DCC_Embed:embed = DCC_CreateEmbed();
            if(!strcmp("👢", emoji_name))
            {
                KickEx(StatTarget);
                DCC_SetEmbedTitle(embed, "KICKED! 👢");
                DCC_SetEmbedColor(embed, 0xFF0000);
                new str[144];
                format(str, sizeof str, "Player %s (%d) has been kicked from the server!", name, StatTarget);
                DCC_SetEmbedDescription(embed, str);
                DCC_EditMessage(message, "", embed);
                DCC_DeleteMessageReaction(message);
                DeleteSavedStatMessage();
            }
            else if(!strcmp("🔨", emoji_name))
            {
                Ban(StatTarget);
                DCC_SetEmbedTitle(embed, "BANNED! 🔨");
                DCC_SetEmbedColor(embed, 0xFF0000);
                new str[144];
                format(str, sizeof str, "Player %s (%d) has been kicked from the server!", name, StatTarget);
                DCC_SetEmbedDescription(embed, str);
                DCC_EditMessage(message, "", embed);
                DCC_DeleteMessageReaction(message);
                DeleteSavedStatMessage();
            }
            else
            {
                DCC_DeleteEmbed(embed);
            }
        }
    }
    printf("Reaction Type %d", _:reaction_type);
    return 1;
}
SendErrorEmbedMessage(DCC_Channel:channel, const error_message[])
{
	new DCC_Embed:embed = DCC_CreateEmbed("ERROR!");
    DCC_SetEmbedColor(embed, 0xFF0000);
    DCC_SetEmbedDescription(embed, error_message);
    DCC_SendChannelEmbedMessage(channel, embed);
	return 1;
}
SendReceiveEmbedMessage(DCC_Channel:channel, const receive_message[])
{
	new DCC_Embed:embed = DCC_CreateEmbed("Received!");
	DCC_SetEmbedColor(embed, 0xDB881AFF);
	DCC_SetEmbedThumbnail(embed, "https://media.discordapp.net/attachments/1002992064914522152/1003852376635101345/HBRP_CR_byKazoo.gif?width=533&height=400 SERVER KALIAN");
	DCC_AddEmbedField(embed, "", receive_message, true);
    DCC_SendChannelEmbedMessage(channel, embed);
	return 1;
}
DCMD:takerole(user, channel, params[])
{
	if(channel == register)
	{
        SendReceiveEmbedMessage(register, "```\nrole berhasil di dapatkan```");
		extract params -> new string:ucp_name[30]; else return SendErrorEmbedMessage(register, "```\n!takerole namaic```");

	    SendReceiveEmbedMessage(register, "```\nrole berhasil di dapatkan```");
	    //DCC_SetBotActivity("Registering People...");
        DCC_SetBotPresenceStatus(DO_NOT_DISTURB);
        SetTimer("Sendingdata", 3000, false);

		

	 	new DCC_Role: ucprole, DCC_Role:ucpremove, strl[520];
		ucprole = DCC_FindRoleById("1084763662465646661");
		ucpremove = DCC_FindRoleById("1002992031490113656");
		format(strl, sizeof(strl), "[Verifed] %s", ucp_name);
        DCC_SetGuildMemberNickname(serverguild, user, strl);
        DCC_AddGuildMemberRole(serverguild, user, ucprole);
        DCC_RemoveGuildMemberRole(serverguild, user, ucpremove);
	}
	else
	{
		return SendErrorEmbedMessage(channel, "You are not at the registration site");
	}
	return 1;
}
new const randomreceive[5][144] = {
	"=",
    "=",
    "=",
    "=",
    "="
};
forward Sendingdata();
public Sendingdata()
{
	new rand = random(5), lmn[144];
	format(lmn, sizeof lmn, "Sending Data %s", randomreceive[rand]);
	DCC_ClearBotActivity();
	DCC_SetBotActivity(lmn);
	SetTimer("ClearActivity", random(2500)+1, false);
	return 1;
}
forward ClearActivity();
public ClearActivity()
{
	DCC_ClearBotActivity();
	DCC_SetBotActivity("Java Roleplay | "TEXT_GAMEMODE"");
	DCC_SetBotPresenceStatus(IDLE);
	return 1;
}
DCMD:dstats(user, channel, params[])
{
	if(channel == g_Admin_Command)
	{
		new target;
	    if(sscanf(params, "u", target))
	    {
			SendErrorEmbedMessage(channel, "Command argument error!\n**!dstats [playerid/name]**");
			return 1;
	    }
	    else if(target == INVALID_PLAYER_ID)
	    {
	        SendErrorEmbedMessage(channel, "Player is not connected!");
			return 1;
	    }
	    DCC_SetBotActivity("Checking People...");
        DCC_SetBotPresenceStatus(DO_NOT_DISTURB);
        SetTimer("Sendingdata", random(3000)+1, false);

	    new name[MAX_PLAYER_NAME], skin_image[500], Float:health, Float:armour, weapon_name[30], str[50];
	    new cash[32], dollars, cents;
	    GetPlayerName(target, name, MAX_PLAYER_NAME);
	    GetPlayerHealth(target, health);
	    GetPlayerArmour(target, armour);
	   	GetWeaponName(GetPlayerWeapon(target), weapon_name, 30);
	   	format(cash,  sizeof cash, "%d", GetPlayerMoney(target));
	   	sscanf(cash, "p<.>dd", dollars, cents);

	    if(!strlen(weapon_name))
	    {
			format(weapon_name, sizeof weapon_name, "Fists");
	    }
	        
	    new DCC_Embed:embed = DCC_CreateEmbed();
	    format(str, sizeof str, "%s's Stats.", name);
	    DCC_SetEmbedTitle(embed, str);

	    format(skin_image, sizeof skin_image, "https://weedarr.wdfiles.com/local--files/skinlistc/%d.png", pData[target][pSkin]);
	    DCC_SetEmbedThumbnail(embed, skin_image);

	    format(str, sizeof str, "%d%02d", dollars, cents);
	    DCC_AddEmbedField(embed, "Money", FormatMoney(strval(str)), true);

	    format(str, sizeof str, "%d/20", pData[target][pWarn]);
	    DCC_AddEmbedField(embed, "Warning", str, true);

	    format(str, sizeof str, "%d", pData[target][pLevel]);
	    DCC_AddEmbedField(embed, "Level", str, true);
	        
	    format(str, sizeof str, "%0.1f", health);
	    DCC_AddEmbedField(embed, "Health", str, true);
	        
	    format(str, sizeof str, "%0.1f", armour);
	    DCC_AddEmbedField(embed, "Armour", str, true);

	    DCC_AddEmbedField(embed, "Weapon", weapon_name, true);

	    DCC_SendChannelEmbedMessage(channel, embed, "", "OnPostPlayerStat", "i", target);
	}
	return 1;
}
public OnPostPlayerStat(playerid)
{
	new DCC_Message:message = DCC_GetCreatedMessage();
    if(StatMessage != DCC_Message:0 )
    {
        DCC_DeleteInternalMessage(StatMessage);
    }
	StatMessage = message;
    StatTarget = playerid;
    DCC_CreateReaction(message, DCC_CreateEmoji("👢"));
    DCC_CreateReaction(message, DCC_CreateEmoji("🔨"));   
	DCC_SetMessagePersistent(message, true);
}
DCMD:ojail(user, channel, params[])
{
 	new player[24], datez, tmp[50], PlayerName[MAX_PLAYER_NAME];
 	inchanel = channel;
 	if(sscanf(params, "s[24]ds[50]", player, datez, tmp))

    if(channel == g_Admin_Command)
	{
		foreach(new ii : Player)
		{
			GetPlayerName(ii, PlayerName, MAX_PLAYER_NAME);

		    if(strfind(PlayerName, player, true) != -1)
			{
				SendErrorEmbedMessage(channel, "This Player is Online!");
		  	}
		}
		new query[512];
		mysql_format(g_SQL, query, sizeof(query), "SELECT reg_id FROM players WHERE username='%e'", player);
		mysql_tquery(g_SQL, query, "DJailPlayer", "sis", player, datez, tmp);
	}
}
DCMD:unban(user, channel, params[])
{
	new tmp[24];
	if(sscanf(params, "s[24]", tmp))

	if(channel == g_Admin_Command)
	{
		new query[128];
		mysql_format(g_SQL, query, sizeof(query), "SELECT name,ip FROM banneds WHERE name = '%e'", tmp);
		mysql_tquery(g_SQL, query, "DcOnUnbanQueryData", "s", tmp);
	}

	return 1;
}
DCMD:gmx(user, channel, params[])
{
    new String[256];
	if(channel == g_Admin_Command)
	{
 		if(CurGMX == 0)
  		{
  			format(String, sizeof(String), "GMX:"RED_E" BOT CMD "WHITE_E"has initiated a server restart, it will occur in the next "YELLOW_E"30 seconds.");
			SendClientMessageToAll(COLOR_RIKO, String);
			//
			DCC_SendChannelMessage(channel, "Server Restarted.");
			DCC_SetBotActivity("GMX PROGRESS...");
			SetTimer("Sendingdata", 25000, false);
			//
        	DCC_SetBotPresenceStatus(DO_NOT_DISTURB);
			SetTimer("DoGMX", 30000, false);
			CurGMX = 1;
  		}
   		else
   		{
	        SendErrorEmbedMessage(channel, "There already is a current GMX in execution.");
    	}
    }
	return 1;
}
DCMD:agmx(user, channel, params[])
{
    new String[256];
	if(channel == g_Admin_Command)
	{
 		if(CurGMX == 0)
  		{
  			format(String, sizeof(String), "GMX:"RED_E" BOT CMD "WHITE_E"has initiated a server restart, it will occur in the next "YELLOW_E"30 seconds.");
			SendClientMessageToAll(COLOR_RIKO, String);
			DCC_SendChannelMessage(channel, "Server Restarted.");
			SetTimer("DoGMX", 1000, false);
			CurGMX = 1;
  		}
   		else
   		{
	        SendErrorEmbedMessage(channel, "There already is a current GMX in execution.");
    	}
    }
	return 1;
}
DCMD:ooc(user, channel, params[])
{
	if(isnull(params))
        return SendErrorEmbedMessage(channel, "/ooc [global OOC]");

	if(channel == g_Admin_Command)
	{
		DCC_SetBotActivity("Send Global OOC...");
		SetTimer("Sendingdata", 1500, false);
		SendClientMessageToAllEx(COLOR_WHITE, "(( {FF0000}[STAFF] BOT DISCORD{FFFFFF}: %s {FFFFFF}))", ColouredText(params));
	}
	return 1;
}
DCMD:countobject(user, channel, params[])
{
    new object_count, fmt_strs[128], fmt_str[128];
    for (new i; i < MAX_OBJECTS; i++)
    {
        if (IsValidObject(i))
        {
            object_count++;
        }
    }
    format(fmt_str, sizeof fmt_strs, "[DEBUG] Amount of objects: ***%i***", object_count);
    DCC_SendChannelMessage(channel, fmt_strs);
    format(fmt_str, sizeof fmt_str, "[DEBUG] Amount of cdynamic objects: ***%i***", Streamer_CountItems(STREAMER_TYPE_OBJECT));
    DCC_SendChannelMessage(channel, fmt_str);
    return 1;
}
DCMD:pjail(user, channel, params[])
{
 	new player[24], datez, tmp[50], PlayerName[MAX_PLAYER_NAME];
	if(sscanf(params, "s[24]ds[50]", player, datez, tmp))

	if(channel == g_Admin_Command)
	{
		foreach(new ii : Player)
		{
			GetPlayerName(ii, PlayerName, MAX_PLAYER_NAME);

		    if(strfind(PlayerName, player, true) != -1)
			{
				SendErrorEmbedMessage(channel, "Player is online, you can use /jail on him.");
		  		return 1;
		  	}
		}
		new query[512];
		mysql_format(g_SQL, query, sizeof(query), "SELECT reg_id FROM players WHERE username='%e'", player);
		mysql_tquery(g_SQL, query, "OJailPlayer", "ssi", player, tmp, datez);
	}
	return 1;
}
DCMD:aplayers(user, channel, params[])
{
	if(channel == g_Admin_Command)
	{
	    new count = 0;
		new name[24];
		new fmt_strs[128];
		DCC_SendChannelMessage(channel, "**__Online Players__**");
		for(new i=0; i < MAX_PLAYERS; i++) {
		if(!IsPlayerConnected(i)) continue;
		GetPlayerName(i, name, MAX_PLAYER_NAME);
		{
		   format(fmt_strs, sizeof fmt_strs, "```%s(%d)```", name, i);
		   DCC_SendChannelMessage(channel, fmt_strs);
		   count++; }
		}
		if (count == 0) return SendErrorEmbedMessage(channel, "There are no players online.");
	}
	return 1;
}
DCMD:akick(user, channel, params[])
{
	if(channel == g_Admin_Command)
	{
		if(isnull(params))
	        return SendErrorEmbedMessage(channel, "/akick [playerid]");

		static
	        reason[128];
			
		new otherid;
	    if(sscanf(params, "us[128]", otherid, reason))

	    SendClientMessageToAllEx(COLOR_BAN, "BotCmd: %s Has Been Kicked By MasDicky.", pData[otherid][pName]);
	    SendClientMessageToAllEx(COLOR_BAN, "Reason: %s ", reason);
	    KickEx(otherid);
	}
    return 1;
}
