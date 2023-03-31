
#define MAX_ADVERTISEMENTS							(500)
enum adsQueue {
    adsExists,
    adsContact,
    adsType,
    adsContent[128],
    adsUsed
};

new AdsQueue[MAX_ADVERTISEMENTS][adsQueue];
new ListedAds[MAX_PLAYERS][10];


CMD:ads(playerid, params[])
{
	ShowAdvertisements(playerid);
	return 1;
}

CMD:ad(playerid, params[])
{
	if(isnull(params))
	{
		Usage(playerid, "(/ad)vertise [advert text]");
		return 1;
	}
	if(pData[playerid][pVip] > 1)
	{
		if(pData[playerid][pPhone] < 0) return Error(playerid, "You dont have phone!");
		if(pData[playerid][pAdsTime] > 0)
			return Error(playerid, "Tunggu %d menit untuk membuat iklan.", pData[playerid][pAdsTime] / 60);

		if(isnull(params))
		{
			Usage(playerid, "(/ad)vertise [advert text]");
			return 1;
		}
		if (strlen(params) > 128)
        	return Error(playerid, "Max characters length is 128 chars");
		new payout = strlen(params) * 2;
		if(GetPlayerMoney(playerid) < payout) return Error(playerid, "Not enough money.");

		GivePlayerMoneyEx(playerid, -payout);
		Server_AddMoney(payout);
		strpack(pData[playerid][pAdvertise], params, 128 char);
		
		Dialog_Show(playerid, AdsType, DIALOG_STYLE_LIST, "Advertisement Type", "Automotive\nProperty\nEvent\nService\nJob Search", "Input", "Close");

		// SendClientMessageEx(playerid, COLOR_ARWIN, "ADS: {ffffff}Your Advertisement has been issued to the queue, use '{ffff00}/ads{ffffff}' to see your Advertisement");
	}
	else
	{
		if(!IsPlayerInRangeOfPoint(playerid, 3.0, 2461.21, 2270.42, 91.67)) return Error(playerid, "You must in SANA Station!");
		if(pData[playerid][pPhone] < 0) return Error(playerid, "You dont have phone!");

		if(pData[playerid][pAdsTime] > 0)
			return Error(playerid, "Tunggu %d menit untuk membuat iklan.", pData[playerid][pAdsTime] / 60);

		if(isnull(params))
		{
			Usage(playerid, "(/ad)vertise [advert text]");
			return 1;
		}
		if (strlen(params) > 128)
            return Error(playerid, "Max characters length is 128 chars");
		new payout = strlen(params) * 2;
		if(GetPlayerMoney(playerid) < payout) return Error(playerid, "Not enough money.");

		GivePlayerMoneyEx(playerid, -payout);
		Server_AddMoney(payout);
		strpack(pData[playerid][pAdvertise], params, 128 char);
		
		Dialog_Show(playerid, AdsType, DIALOG_STYLE_LIST, "Advertisement Type", "Automotive\nProperty\nEvent\nService\nJob Search", "Input", "Close");

	}
    return 1;
}

Dialog:AdsType(playerid, response, listitem, inputtext[]) {
    if (response) 
	{
       switch(listitem)
	   {
			case 0:
			{
				Advertisement_Create(playerid, pData[playerid][pPhone], 1, pData[playerid][pAdvertise]);
			}
			case 1:
			{
				Advertisement_Create(playerid, pData[playerid][pPhone], 2, pData[playerid][pAdvertise]);
			}
			case 2:
			{
				Advertisement_Create(playerid, pData[playerid][pPhone], 3, pData[playerid][pAdvertise]);
			}
			case 3:
			{
				Advertisement_Create(playerid, pData[playerid][pPhone], 4, pData[playerid][pAdvertise]);
			}
			case 4:
			{
				Advertisement_Create(playerid, pData[playerid][pPhone], 5, pData[playerid][pAdvertise]);
			}
	   }
    }
    return 1;
}

Advertisement_Create(playerid, number, type, content[]) {
    new index = Advertisement_GetFreeID();

    if (index == -1)
        return Error(playerid, "Advertisement is full!");

    AdsQueue[index][adsExists] = true;
    AdsQueue[index][adsContact] = number;
    AdsQueue[index][adsType] = type;
    strunpack(AdsQueue[index][adsContent], content);
    AdsQueue[index][adsUsed] = 0;

    pData[playerid][pAdsTime] = 600;

    SendClientMessage(playerid, COLOR_ARWIN, "ADVERTISEMENT:"WHITE_E" Your advertisement will be published shortly.");
    return 1;
}

Advertisement_GetFreeID() {
    for (new i = 0; i < MAX_ADVERTISEMENTS; i ++) if (!AdsQueue[i][adsExists]) {
        return i;
    }
    return -1;
}

Dialog:Dialog_Advertisements(playerid, response, listitem, inputtext[]) {
    if (response) {
        new ads[150 * 10], count = 0;
        strcat(ads, "Contact Person\tContact Number\tAdvertisement\n");
        for (new i = 0; i < MAX_ADVERTISEMENTS; i ++) if (AdsQueue[i][adsExists] && AdsQueue[i][adsType] == (listitem + 1)) {
            if (strlen(AdsQueue[i][adsContent]) > 64) {
                strcat(ads, sprintf("%s\t%d\t%.64s...\n", AdsQueue[i][adsContent], AdsQueue[i][adsContact], AdsQueue[i][adsContent]));
            } else strcat(ads, sprintf("%s\t%d\t%s\n", AdsQueue[i][adsContent], AdsQueue[i][adsContact], AdsQueue[i][adsContent]));
            ListedAds[playerid][count++] = i;
        }
        if (!count) Dialog_Show(playerid, ShowOnly, DIALOG_STYLE_LIST, inputtext, "There are no advertisement on this type", "Contact", "Back");
        else Dialog_Show(playerid, SelectAds, DIALOG_STYLE_TABLIST_HEADERS, inputtext, ads, "Contact", "Back");
    }
    return 1;
}

Dialog:SelectAds(playerid, response, listitem, inputtext[]) {
    if (!response) ShowAdvertisements(playerid);
    else {
        new index = ListedAds[playerid][listitem],
            targetid = GetNumberOwner(AdsQueue[index][adsContact]);

        if (targetid == INVALID_PLAYER_ID)
            return Error(playerid, "The specified phone number is not in service.");

        if(targetid == playerid)
            return Error(playerid, "You can't text yourself!");

        if(pData[targetid][pPhoneOff])
            return Error(playerid, "The recipient has their cellphone powered off.");

        SetPVarInt(playerid, "replyTextTo", targetid);
        Dialog_Show(playerid, ReplyMessage, DIALOG_STYLE_INPUT, "Send Message", ""YELLOW_E"Ad: {00AA00}%s\n"YELLOW_E"Contact Number: [ {00AA00}%d "YELLOW_E"] Type: [ {00AA00}%s "YELLOW_E"]", "Send", "Cancel", AdsQueue[index][adsContent], AdsQueue[index][adsContact], GetAdvertiseType(AdsQueue[index][adsType]));
    }
    return 1;
}

Dialog:ReplyMessage(playerid, response, listitem, inputtext[]) {
    if (response) {
        if (GetPVarInt(playerid, "replyTextTo") != INVALID_PLAYER_ID) {
            new targetid = GetPVarInt(playerid, "replyTextTo"), msg[64];

            if (sscanf(inputtext, "s[64]", msg))
                return Dialog_Show(playerid, ReplyMessage, DIALOG_STYLE_INPUT, "Reply Message", "Replying message to: %d", "Send", "Cancel", pData[targetid][pPhone]);

            if (strlen(msg) > 64)
                return Dialog_Show(playerid, ReplyMessage, DIALOG_STYLE_INPUT, "Reply Message", "Replying message to: %d", "Send", "Cancel", pData[targetid][pPhone]);

            new ph = pData[targetid][pPhone];
			new String[512];
			foreach(new ii : Player)
			{
				if(pData[ii][pPhone] == ph)
				{
					if(ii == INVALID_PLAYER_ID || !IsPlayerConnected(ii)) return Error(playerid, "This number is not actived!");
					if(pData[ii][pPhoneOff] == 1) return Error(playerid, "The specified phone number went offline");

					format(String, sizeof(String), "SMS: {ffffff}You have received one new message from '{ffff00}%d{ffffff}'", pData[playerid][pPhone]);
					SendClientMessageEx(ii, COLOR_RED, String);	
					format(String, sizeof(String), "Message: {ffff00}%s", inputtext);
					SendClientMessageEx(ii, COLOR_RED, String);
					Info(ii, "Gunakan "LB_E"'@<text>' "WHITE_E"untuk membalas SMS!");
					SendClientMessageEx(playerid, COLOR_ARWIN, "SMS: {FFFF00}Message sent");
					SendClientMessageEx(playerid, COLOR_WHITE, "AME: {C2A2DA}types something to his cellphone");
					format(String, sizeof(String), "types something to his cellphone");
					SetPlayerChatBubble(playerid, String, COLOR_PURPLE, 5.0, 5000);
					PlayerPlaySound(ii, 6003, 0,0,0);
					pData[ii][pSMS] = pData[playerid][pPhone];
					
					pData[playerid][pPhoneCredit] -= 1;
					return 1;
				}
			}
        }
    } else DeletePVar(playerid, "replyTextTo");
    return 1;
}

ShowAdvertisements(playerid) {
    Dialog_Show(playerid, Dialog_Advertisements, DIALOG_STYLE_LIST, "Advertisements", "Automotive\nProperty\nEvent\nServices\nJob Search", "Select", "Cancel");
    return 1;
}

Advertisement_Remove(playerid) {
    for (new i = 0; i < MAX_ADVERTISEMENTS; i ++) if (AdsQueue[i][adsExists] && AdsQueue[i][adsUsed] == 1 && AdsQueue[i][adsContact] == pData[playerid][pPhone]) {
        AdsQueue[i][adsExists] = false;
        AdsQueue[i][adsContact] = 0;
        AdsQueue[i][adsContent] = EOS;
        AdsQueue[i][adsType] = 0;
        AdsQueue[i][adsUsed] = 0;
    }
    return 1;
}

task Advertise[60000]() {
    for (new i = 0; i < MAX_ADVERTISEMENTS; i ++) if (AdsQueue[i][adsExists] && !AdsQueue[i][adsUsed]) {
        foreach (new player : Player) 
		{
            if(pData[player][pTogAds] == 0)
			{
                SendClientMessageEx(player, COLOR_ORANGE2, "Ad: "GREEN_E"%s", AdsQueue[i][adsContent]);
                SendClientMessageEx(player, COLOR_ORANGE2, "Contact Info: ["GREEN_E"%s"ORANGE_E2"] Phone: ["GREEN_E"%d"ORANGE_E2"]"YELLOW_E"]", AdsQueue[i][adsContent], AdsQueue[i][adsContact]);
            }
            if (pData[player][pPhone] == AdsQueue[i][adsContact]) {
                pData[player][pAdvertise] = '\0';
            }
        }
        AdsQueue[i][adsUsed] = 1;
        break;
    }
    return 1;
}

GetAdvertiseType(types) {
    new type[24];

    switch (types) {
        case 1: format(type,sizeof(type),"Automotive");
        case 2: format(type,sizeof(type),"Property");
        case 3: format(type,sizeof(type),"Event");
        case 4: format(type,sizeof(type),"Service");
        case 5: format(type,sizeof(type),"Job Search");
        default: format(type,sizeof(type),"Unknown Type");
    }

    return type;
}
