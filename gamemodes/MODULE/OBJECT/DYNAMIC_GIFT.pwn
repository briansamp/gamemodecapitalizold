#define MAX_GIFT 50

enum giftinfo
{
	Float:giftPosX,
	Float:giftPosY,
	Float:giftPosZ,
	Text3D:giftLabel,
	giftPickup
};



new giftData[MAX_GIFT][giftinfo],
	Iterator: Gift<MAX_GIFT>;
	

Gift_Refresh(giftid)
{
	if(giftid != -1)
    {
        if(IsValidDynamic3DTextLabel(giftData[giftid][giftLabel]))
            DestroyDynamic3DTextLabel(giftData[giftid][giftLabel]);

        if(IsValidDynamicPickup(giftData[giftid][giftPickup]))
            DestroyDynamicPickup(giftData[giftid][giftPickup]);

        static
        string[255];

		format(string, sizeof(string), "[GIFT ID: %d]\n"WHITE_E"Type '"RED_E"/getgift"WHITE_E"' to use", giftid);
		giftData[giftid][giftPickup] = CreateDynamicPickup(19056, 23, giftData[giftid][giftPosX], giftData[giftid][giftPosY], giftData[giftid][giftPosZ]+0.2, -1, -1, -1, 5.0);
		giftData[giftid][giftLabel] = CreateDynamic3DTextLabel(string, COLOR_GREEN, giftData[giftid][giftPosX], giftData[giftid][giftPosY], giftData[giftid][giftPosZ]+0.5, 4.5);
	}
    return 1;
}

CMD:creategift(playerid, params[])
{
	new giftid;
	if(pData[playerid][pAdmin] < 2)
		return PermissionError(playerid);

	GetPlayerPos(playerid, giftData[giftid][giftPosX], giftData[giftid][giftPosY], giftData[giftid][giftPosZ]);
    Gift_Refresh(giftid);
	Iter_Add(Gift, giftid);
	SendClientMessageToAllEx(COLOR_YELLOW, "MYSTERY BOX HAS BEN DROP IN LOCATION: "LG_E"%s", GetLocation(giftData[giftid][giftPosX], giftData[giftid][giftPosY], giftData[giftid][giftPosZ]));
	return 1;
}

CMD:getgift(playerid, params[])
{
         new gstr[1024], header[512];
         header = "";
         gstr = "";

         new giftid;
         if(!IsPlayerInRangeOfPoint(playerid, 2.8, giftData[giftid][giftPosX], giftData[giftid][giftPosY], giftData[giftid][giftPosZ]))
         return Error(playerid, "Anda harus berada di giftpoint");


		 new Randomgift = random(7);
         if(Randomgift == 1)
	{
	     pData[playerid][pComponent] += 50;
	     pData[playerid][pMaterial] += 50;
	     format(header,sizeof(header),"NORMAL BOX");
	     format(gstr,sizeof(gstr),"%s"WHITE_E"COMPONENT :"YELLOW_E"50\n", gstr);
	     format(gstr,sizeof(gstr),"%s"WHITE_E"MATERIAL :"YELLOW_E"50\n", gstr);
         ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_MSGBOX, header, gstr, "Tutup", "");
		 SendStaffMessage(COLOR_RED, "* %s "WHITE_E" Mendapatkan normal box", pData[playerid][pName]);
	}
	     else if(Randomgift == 2)
	{
	     pData[playerid][pMaterial] += 50;
	     GivePlayerMoneyEx(playerid, 20000);
	     format(header,sizeof(header),"NORMAL BOX");
	     format(gstr,sizeof(gstr),"%s"WHITE_E"MONEY :"YELLOW_E"200$\n", gstr);
	     format(gstr,sizeof(gstr),"%s"WHITE_E"MATERIAL :"YELLOW_E"50\n", gstr);
         ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_MSGBOX, header, gstr, "Tutup", "");
         SendStaffMessage(COLOR_RED, "* %s "WHITE_E" Mendapatkan normal box", pData[playerid][pName]);
	}
	     else if(Randomgift == 3)
	{
	     pData[playerid][pGold] += 20;
	     GivePlayerMoneyEx(playerid, 15000);
	     format(header,sizeof(header),""PURPLE_E"RARE"WHITE_E"BOX");
	     format(gstr,sizeof(gstr),"%s"WHITE_E"GOLD :"YELLOW_E"20\n", gstr);
	     format(gstr,sizeof(gstr),"%s"WHITE_E"MONEY :"YELLOW_E"150$\n", gstr);
         ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_MSGBOX, header, gstr, "Tutup", "");
         SendStaffMessage(COLOR_RED, "* %s "WHITE_E" Mendapatkan rare box", pData[playerid][pName]);
	}
	     else if(Randomgift == 4)
	{
	     GivePlayerMoneyEx(playerid, 100000);
	     pData[playerid][pComponent] += 200;
	     pData[playerid][pMaterial] += 200;
	     format(header,sizeof(header),""PURPLE_E"RARE" WHITE_E" BOX");
	     format(gstr,sizeof(gstr),"%s"WHITE_E"COMPONENT :"YELLOW_E"200\n", gstr);
	     format(gstr,sizeof(gstr),"%s"WHITE_E"MATERIAL :"YELLOW_E"200\n", gstr);
	     format(gstr,sizeof(gstr),"%s"WHITE_E"MONEY :"YELLOW_E"1000$$\n", gstr);
	     ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_MSGBOX, header, gstr, "Tutup", "");
         SendStaffMessage(COLOR_RED, "* %s "WHITE_E" Mendapatkan rare box ", pData[playerid][pName]);
	}
	     else if(Randomgift == 5)
	{
	     pData[playerid][pFood] += 200;
	     pData[playerid][pSeed] += 200;
	     pData[playerid][pComponent] += 200;
	     pData[playerid][pMaterial] += 200;
	     pData[playerid][pGold] += 30;
		 GivePlayerMoneyEx(playerid, 50000);
	     format(header,sizeof(header),""BLUE_E"LEGENDS" WHITE_E "BOX");
	     format(gstr,sizeof(gstr),"%s"WHITE_E"COMPONENT :"YELLOW_E"200\n", gstr);
	     format(gstr,sizeof(gstr),"%s"WHITE_E"MATERIAL :"YELLOW_E"200\n", gstr);
	     format(gstr,sizeof(gstr),"%s"WHITE_E"FOOD :"YELLOW_E"200\n", gstr);
 	     format(gstr,sizeof(gstr),"%s"WHITE_E"SEED :"YELLOW_E"200\n", gstr);
   	     format(gstr,sizeof(gstr),"%s"WHITE_E"GOLD :"YELLOW_E"30\n", gstr);
	     format(gstr,sizeof(gstr),"%s"WHITE_E"MONEY :"YELLOW_E"500$\n", gstr);
         ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_MSGBOX, header, gstr, "Tutup", "");
         SendStaffMessage(COLOR_RED, "* %s "WHITE_E" Mendapatkan legends box", pData[playerid][pName]);
	}

         else if(Randomgift == 6)
	{
	   	 pData[playerid][pGold] += 50;
	   	 GivePlayerMoneyEx(playerid, 100000);
	     pData[playerid][pFood] += 500;
	     pData[playerid][pSeed] += 500;
	     pData[playerid][pComponent] += 500;
	     pData[playerid][pMaterial] += 500;
         GivePlayerWeaponEx(playerid, 24, 20);
	     format(header,sizeof(header),""YELLOW_E"ULTIMATE" WHITE_E "BOX");
	     format(gstr,sizeof(gstr),"%s"WHITE_E"COMPONENT :"YELLOW_E"500\n", gstr);
	     format(gstr,sizeof(gstr),"%s"WHITE_E"MATERIAL :"YELLOW_E"500\n", gstr);
	     format(gstr,sizeof(gstr),"%s"WHITE_E"FOOD :"YELLOW_E"500\n", gstr);
 	     format(gstr,sizeof(gstr),"%s"WHITE_E"SEED :"YELLOW_E"500\n", gstr);
   	     format(gstr,sizeof(gstr),"%s"WHITE_E"GOLD :"YELLOW_E"50\n", gstr);
	     format(gstr,sizeof(gstr),"%s"WHITE_E"MONEY :"YELLOW_E"1000$\n", gstr);
         format(gstr,sizeof(gstr),"%s"WHITE_E"WEAPON :"RED_E"DESERT EAGLE\n", gstr);
         ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_MSGBOX, header, gstr, "Tutup", "");
		 SendStaffMessage(COLOR_RED, "* %s "WHITE_E" Mendapatkan ultimate box", pData[playerid][pName]);
	}
	     DestroyDynamic3DTextLabel(giftData[giftid][giftLabel]);
	     DestroyDynamicPickup(giftData[giftid][giftPickup]);
	     giftData[giftid][giftPosX] = 0;
	     giftData[giftid][giftPosY] = 0;
	     giftData[giftid][giftPosZ] = 0;
	     giftData[giftid][giftLabel] = Text3D: INVALID_3DTEXT_ID;
	     giftData[giftid][giftPickup] = -1;
	     Iter_Remove(Gift, giftid);

	
         return 1;
   }
