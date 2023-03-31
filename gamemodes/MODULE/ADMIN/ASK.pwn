#define MAX_ASK                         (50)
enum askData {
    askExists,
    askPlayer,
    askQuestion[128 char]
};
new AskData[MAX_ASK][askData];


Ask_GetCount(playerid) {
    new count = 0;

    for (new i = 0; i < MAX_ASK; i++) if (AskData[i][askExists] && AskData[i][askPlayer] == playerid) {
        count++;
    }
    return count;
}

Ask_Count() {
    new count = 0;

    for (new i = 0; i != MAX_ASK; i ++) if(AskData[i][askExists]) {
        count++;
    }
    return count;
}

Ask_Clear(playerid) {
    for (new i = 0; i < MAX_ASK; i++) if (AskData[i][askExists] && AskData[i][askPlayer] == playerid) {
        Ask_Remove(i);
    }
    return 1;
}

Ask_Add(playerid, const text[])
{
    for (new i = 0; i != MAX_ASK; i ++)
    {
        if(!AskData[i][askExists])
        {
            AskData[i][askExists] = true;
            AskData[i][askPlayer] = playerid;

            strpack(AskData[i][askQuestion], text, 128 char);
            return i;
        }
    }
    return -1;
}

Ask_Remove(askid)
{
    if(askid != -1 && AskData[askid][askExists])
    {
        AskData[askid][askExists] = false;
        AskData[askid][askPlayer] = INVALID_PLAYER_ID;
    }
    return 1;
}

CMD:asks(playerid, params[]) {
    if (pData[playerid][pAdmin] < 1)
        return PermissionError(playerid);

    if(!Ask_Count()) return Error(playerid, "There are no one ask active.");

    new
        dialog[900],
        text[128];

    format(dialog, sizeof(dialog),"ID\tIssuer\tQuestion\n");
    for (new i = 0; i != MAX_ASK; i ++) if(AskData[i][askExists]) {
        strunpack(text, AskData[i][askQuestion]);

        if(strlen(text) > 32)
            format(dialog, sizeof(dialog), "%s%d\t%s (%d)\t%.32s ...\n", dialog, i, ReturnName(AskData[i][askPlayer]), AskData[i][askPlayer], text);
        else
            format(dialog, sizeof(dialog), "%s%d\t%s (%d)\t%s\n", dialog, i, ReturnName(AskData[i][askPlayer]), AskData[i][askPlayer], text);
    }
    Dialog_Show(playerid, DialogAsks, DIALOG_STYLE_TABLIST_HEADERS,"Asks", dialog,"Next","Cancel");
    return 1;
}

CMD:clearallasks(playerid) {
    if (pData[playerid][pAdmin] < 5)
        return PermissionError(playerid);
        
    new
        count;

    for (new i = 0; i != MAX_ASK; i ++)
    {
        if(AskData[i][askExists]) {
            Ask_Remove(i);
            count++;
        }
    }
    if(!count)
        return Error(playerid, "There are no active asks to display.");
            
    SendAdminMessage(TOMATO, "CLEAR: "WHITE_E"%s has removed all asks on the server.",ReturnName(playerid));
    return 1;
}

CMD:ask(playerid, params[])
{
    if(isnull(params))
        return Usage(playerid, "/ask [questions]");

    if(pData[playerid][pAsk] || Ask_GetCount(playerid) > 0)
        return Error(playerid, "Waiting answered from admin to repeat your questions again..");

    new askid = -1;
    if((askid = Ask_Add(playerid, params)) != -1)
    {
        SendQuestionMessage(COLOR_BLUE, "[ASK:#%d] "YELLOW_E"%s (%d): "WHITE_E"%s", askid, ReturnName(playerid), playerid, params);
        pData[playerid][pAsk] = true;
        format(pData[playerid][pAskQ], 128, params);

        pData[playerid][pAskTime] = 120000;

        Servers(playerid, "You have sent a questions to helper/admin online.");
    }
    else Error(playerid, "The ask list is full. Please wait for a while.");
    return 1;
}

CMD:ans(playerid, params[])
{
    static
        userid,
        text[128];

    if (pData[playerid][pAdmin] < 1 && !pData[playerid][pHelper])
        return PermissionError(playerid);

    if(sscanf(params, "us[128]", userid, text)) return Usage(playerid, "/ans [playerid/PartOfName] [message]");
    if(userid == INVALID_PLAYER_ID) return Error(playerid, "You have specified an invalid player.");
    if(!pData[userid][pAsk]) return Error(playerid, "This player don't ask anything");

    SendClientMessageEx(userid, COLOR_BLUE, "QUESTIONS: "YELLOW_E"%s", pData[playerid][pAskQ]);
    SendClientMessageEx(userid, COLOR_BLUE, "ANSWER: "YELLOW_E"%s", text);
    SendAdminMessage(TOMATO, "AdmCmd: %s answered %s questions: %s", pData[playerid][pAdminname], ReturnName(userid), text);

    pData[userid][pAsk] = false;
    pData[userid][pAskQ] = EOS;
    pData[userid][pAskTime] = 0;
    Ask_Clear(userid);
    return 1;
}

CMD:cancel(playerid, params[]) {
    new option[24];
    if (sscanf(params, "s[24]", option))
        return Usage(playerid, "/cancel [ask]");

    if (!strcmp(option, "ask", true)) {
        if (!pData[playerid][pAsk] || !Ask_GetCount(playerid))
            return Error(playerid, "You don't have any active ask.");

        pData[playerid][pAsk] = false;
        pData[playerid][pAskQ] = EOS;
        pData[playerid][pAskTime] = 0;
        Ask_Clear(playerid);
        SendCustomMessage(playerid, "CANCEL", "You've been canceled your ask.");
    } else Usage(playerid, "/cancel [report/ask/taxi/mechanic]");
    return 1;
}

ptask Canusingask[1000](playerid)
{
    pData[playerid][pAskTime]--;
    if(pData[playerid][pAskTime] == 0)
    {
        if(pData[playerid][pAsk])
        {
            pData[playerid][pAsk] = false;
            pData[playerid][pAskQ] = EOS;
            Servers(playerid, "No one answer your questions, now you can use /ask again.");
        }
    }
    return 1;
}

stock SendQuestionMessage(color, const str[], {Float,_}:...)
{
    static
        args,
        start,
        end,
        string[144]
    ;
    #emit LOAD.S.pri 8
    #emit STOR.pri args

    if(args > 8)
    {
        #emit ADDR.pri str
        #emit STOR.pri start

        for (end = start + (args - 8); end > start; end -= 4)
        {
            #emit LREF.pri end
            #emit PUSH.pri
        }
        #emit PUSH.S str
        #emit PUSH.C 144
        #emit PUSH.C string

        #emit LOAD.S.pri 8
        #emit ADD.C 4
        #emit PUSH.pri

        #emit SYSREQ.C format
        #emit LCTRL 5
        #emit SCTRL 4

        foreach (new i : Player)
        {
            if(pData[i][pAdmin] >= 1) {
                SendClientMessage(i, color, string);
            }
        }
        return 1;
    }
    foreach (new i : Player)
    {
        if(pData[i][pAdmin] >= 1) {
            SendClientMessage(i, color, str);
        }
    }
    return 1;
}

Dialog:DialogAsks(playerid, response, listitem, inputtext[]) {
    if (response) {
        new string[225],
            i = strval(inputtext),
            text[128],
            header[25];
        
        strunpack(text, AskData[i][askQuestion]);
        format(header, sizeof(header), ""RED_E"Ask Id: #%d", i);
        format(string,sizeof(string),""WHITE_E"Issuer: "YELLOW_E"%s\n"WHITE_E"Question: "YELLOW_E"%s.", ReturnName(AskData[i][askPlayer]), text);
        SetPVarInt(playerid, "holdingAskPlayer", AskData[i][askPlayer]);
        Dialog_Show(playerid, DialogAns, DIALOG_STYLE_INPUT,header,string,"Answer","Back");
    }
    return 1;
}

Dialog:DialogAns(playerid, response, listitem, inputtext[]) {
    if (response) {
        new issuerid = GetPVarInt(playerid, "holdingAskPlayer");

        if (!isnull(inputtext)) {
            new params[128];
            format(params, sizeof(params), "%d %s", issuerid, inputtext);
            callcmd::ans(playerid, params);
        }
    } else callcmd::ans(playerid, "\0"), DeletePVar(playerid, "holdingAskPlayer");
    return 1;
}
