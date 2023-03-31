#define MAX_WORKSHOP            50

enum E_WORKSHOP_DATA
{
    W_OWNER[MAX_PLAYER_NAME],
	W_NAME[128],
	W_ID,
	W_PRICE,
	W_LOCK,
	W_OBJ,
	W_OBJECT,
	Float: W_X_POS,
	Float: W_Y_POS,
	Float: W_Z_POS,
	Float: WsRepX,
	Float: WsRepY,
	Float: WsRepZ,
	W_MONEY_BANK,
	W_COMPONENT_STOCK,
	W_SEGEL,
	Text3D: W_LABEL,
	Text3D: W_S_LABEL
};
new wsData[MAX_WORKSHOP][E_WORKSHOP_DATA];
new Iterator: Workshop<MAX_WORKSHOP>;

Workshop_Save(id)
{
	new cQuery[2248];
	format(cQuery, sizeof(cQuery), "UPDATE workshop SET owner='%s', name='%s', price='%d', locked='%d', xpos='%f', ypos='%f', zpos='%f', repx='%f', repy='%f', repz='%f', money='%d', component='%d', segel='%d' WHERE ID='%d'",
	wsData[id][W_OWNER],
    wsData[id][W_NAME],
    wsData[id][W_PRICE],
    wsData[id][W_LOCK],
    wsData[id][W_X_POS],
    wsData[id][W_Y_POS],
    wsData[id][W_Z_POS],
    wsData[id][WsRepX],
    wsData[id][WsRepY],
    wsData[id][WsRepZ],
    wsData[id][W_MONEY_BANK],
    wsData[id][W_COMPONENT_STOCK],
    wsData[id][W_SEGEL],   
	id);
	return mysql_tquery(g_SQL, cQuery);
}

Player_OwnsWorkshop(playerid, id)
{
	if(!IsPlayerConnected(playerid)) return 0;
	if(id == -1) return 0;
	if(!strcmp(wsData[id][W_OWNER], pData[playerid][pName], true)) return 1;
	return 0;
}

Player_WorkshopCount(playerid)
{
	#if LIMIT_PER_PLAYER != 0
    new count;
	foreach(new i : Workshop)
	{
		if(Player_OwnsWorkshop(playerid, i)) count++;
	}

	return count;
	#else
	return 0;
	#endif
}

Workshop_Refresh(id)
{
    if(id != -1)
    {
        static
        string[255];
        
        if(IsValidDynamic3DTextLabel(wsData[id][W_LABEL]))
            DestroyDynamic3DTextLabel(wsData[id][W_LABEL]);
            
        if(IsValidDynamic3DTextLabel(wsData[id][W_S_LABEL]))
            DestroyDynamic3DTextLabel(wsData[id][W_S_LABEL]);

        if(strcmp(wsData[id][W_OWNER], "-"))
		{
		    if(wsData[id][W_LOCK] == 0)
        	{
				format
				(
					string, sizeof(string),
					"[ID: %d]\n"WHITE_E"Name: {FFFF00}%s\n"WHITE_E"Owned by %s\n[{8CCB5E}OPEN{ffffff}]",
					id,
					wsData[id][W_NAME],
					wsData[id][W_OWNER]
				);
			}
   			else if(wsData[id][W_LOCK] == 1)
      		{
                format
				(
					string, sizeof(string),
					"[ID: %d]\n"WHITE_E"Name: {FFFF00}%s\n"WHITE_E"Owned by %s\n[{FF4040}CLOSE{ffffff}]",
					id,
					wsData[id][W_NAME],
					wsData[id][W_OWNER]
				);
      		}
        }
        else
        {
            format
			(
				string, sizeof(string),
				"[ID: %d]\n{00FF00}This workshop for sell\n{FFFFFF}Location: {FFFF00}%s\n{FFFFFF}Price: {FFFF00}%s\n"WHITE_E"Type /buy to purchase",
				id,
				GetLocation(wsData[id][W_X_POS], wsData[id][W_Y_POS], wsData[id][W_Z_POS]),
				FormatMoney(wsData[id][W_PRICE])
			);
        }
        
		wsData[id][W_LABEL] = CreateDynamic3DTextLabel(string, COLOR_GREEN, wsData[id][W_X_POS], wsData[id][W_Y_POS], wsData[id][W_Z_POS], 10, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1, 0, 0);
    }
    return 1;
}

function LoadWorkshop()
{
    static wid;

	new rows = cache_num_rows(), owner[128], name[128];
 	if(rows)
  	{
		for(new i; i < rows; i++)
		{
			cache_get_value_name_int(i, "ID", wid);
			
			cache_get_value_name(i, "owner", owner);
			format(wsData[wid][W_OWNER], 128, owner);
			
			cache_get_value_name(i, "name", name);
			format(wsData[wid][W_NAME], 128, name);
			
			cache_get_value_name_int(i, "price", wsData[wid][W_PRICE]);

			cache_get_value_name_int(i, "locked", wsData[wid][W_LOCK]);
			
			cache_get_value_name_float(i, "xpos", wsData[wid][W_X_POS]);
			cache_get_value_name_float(i, "ypos", wsData[wid][W_Y_POS]);
			cache_get_value_name_float(i, "zpos", wsData[wid][W_Z_POS]);

			cache_get_value_name_float(i, "repx", wsData[wid][WsRepX]);
			cache_get_value_name_float(i, "repy", wsData[wid][WsRepY]);
			cache_get_value_name_float(i, "repz", wsData[wid][WsRepZ]);
			
			cache_get_value_name_int(i, "money", wsData[wid][W_MONEY_BANK]);
			cache_get_value_name_int(i, "component", wsData[wid][W_COMPONENT_STOCK]);
			cache_get_value_name_int(i, "segel", wsData[wid][W_SEGEL]);
			
			Workshop_Refresh(wid);
			Iter_Add(Workshop, wid);
		}
		printf("[Workshop] Number of Loaded: %d.", rows);
	}
}

CMD:gotows(playerid, params[])
{
	new id;
	
	if(pData[playerid][pAdmin] < 2)
        return PermissionError(playerid);

	if(sscanf(params, "d", id))
		return Usage(playerid, "/gotows [id]");
		
	if(!Iter_Contains(Workshop, id)) return Error(playerid, "The Workshop you specified ID of doesn't exist.");
	
	SetPlayerPosition(playerid, wsData[id][W_X_POS], wsData[id][W_Y_POS], wsData[id][W_Z_POS], 0);
	
    SetPlayerInterior(playerid, 0);
    SetPlayerVirtualWorld(playerid, 0);
	SendClientMessageEx(playerid, COLOR_WHITE, "You has teleport to workshop id %d", id);
	
	pData[playerid][pInDoor] = -1;
	pData[playerid][pInHouse] = -1;
	pData[playerid][pInBiz] = -1;
	return 1;
}

CMD:createws(playerid, params[])
{
	if(pData[playerid][pAdmin] < 6)
		return PermissionError(playerid);

	new query[512];
	new id = Iter_Free(Workshop);
	
	if(id == -1) return Error(playerid, "You cant create more ws!");
	
	new price, name[50];
	
	if(sscanf(params, "s[50]d", name, price)) return Usage(playerid, "/createworkshop [name] [price]");
	
	format(wsData[id][W_OWNER], 128, "-");
	
	GetPlayerPos(playerid, wsData[id][W_X_POS], wsData[id][W_Y_POS], wsData[id][W_Z_POS]);
	
	wsData[id][W_PRICE] = price;

	format(wsData[id][W_NAME], 50, name);
	
	wsData[id][W_LOCK] = 0;
	wsData[id][W_MONEY_BANK] = 0;
	wsData[id][W_COMPONENT_STOCK] = 0;
    
    wsData[id][W_SEGEL] = 0;

    Workshop_Refresh(id);
	Iter_Add(Workshop, id);
	
	mysql_format(g_SQL, query, sizeof(query), "INSERT INTO workshop SET ID='%d', owner='%s', price='%d', name='%s'", id, wsData[id][W_OWNER], wsData[id][W_PRICE], wsData[id][W_NAME]);
	mysql_tquery(g_SQL, query, "OnWorkshopCreated", "i", id);
	
	return 1;
}

function OnWorkshopCreated(bid)
{
	Workshop_Save(bid);
	return 1;
}

CMD:editws(playerid, params[])
{
    if(pData[playerid][pAdmin] < 6)
		return PermissionError(playerid);

    static
    id, type[24], string[24];

    if(sscanf(params, "ds[24]S()[128]", id, type, string))
    {
        Usage(playerid, "/editworkshop [id] [pos, point, owner, name, price, bank]");
        return 1;
    }
    if(!strcmp(type, "bank", true))
    {
        static amount, types[24];

		if(sscanf(string, "s[24]d", types, amount))
		{
			Usage(playerid, "/workshop [bank] [money/component] [amount]");
			return 1;
	    }
	    if(!strcmp(types, "money", true))
    	{
    	    wsData[id][W_MONEY_BANK] = amount;
    	    SendClientMessageEx(playerid, 0xFFFFFFFF, "Anda Mengubah Uang Workshop Id %d Menjadi %d", id, amount);
    	}
    	if(!strcmp(types, "component", true))
    	{
            wsData[id][W_COMPONENT_STOCK] = amount;
            SendClientMessageEx(playerid, 0xFFFFFFFF, "Anda Mengubah Componnet Workshop Id %d Menjadi %d", id, amount);
    	}
    }
    if(!strcmp(type, "price", true))
    {
        static
      		harga;

		if(sscanf(string, "d", harga))
		{
			Usage(playerid, "/workshop [price] [harga]");
			return 1;
	    }
	    
	    wsData[id][W_PRICE] = harga;
	    Workshop_Refresh(id);
	    Workshop_Save(id);
    }
    if(!strcmp(type, "name", true))
    {
	    new name[50];

	    if(sscanf(string, "s[50]", name))
  			return Usage(playerid, "/workshop [name] [new name]");

	    format(wsData[id][W_NAME], 128, name);
	    Workshop_Refresh(id);
	    Workshop_Save(id);
    }
    if(!strcmp(type, "pos", true))
    {
        GetPlayerPos(playerid, wsData[id][W_X_POS], wsData[id][W_Y_POS], wsData[id][W_Z_POS]);
        
        Workshop_Save(id);
		Workshop_Refresh(id);
    }
    if(!strcmp(type, "point", true))
    {
        GetPlayerPos(playerid, wsData[id][WsRepX], wsData[id][WsRepY], wsData[id][WsRepZ]);
        
        Workshop_Save(id);
		Workshop_Refresh(id);
    }
    if(!strcmp(type, "removed", true))
    {
		DestroyDynamic3DTextLabel(wsData[id][W_LABEL]);
        
	    wsData[id][W_LOCK] = 1;
	    wsData[id][W_OBJ] = 0;
	    wsData[id][W_X_POS] = 0;
	    wsData[id][W_Y_POS] = 0;
	    wsData[id][W_Z_POS] = 0;
	    wsData[id][W_MONEY_BANK] = 0;
	    wsData[id][W_COMPONENT_STOCK] = 0;
	    wsData[id][W_SEGEL] = 0;

		Iter_Remove(Workshop, id);
		new query[128];
		mysql_format(g_SQL, query, sizeof(query), "DELETE FROM workshop WHERE ID=%d", id);
		mysql_tquery(g_SQL, query);
        SendAdminMessage(COLOR_RED, "%s has delete Workshop ID: %d.", pData[playerid][pAdminname], id);
    }
    if(!strcmp(type, "owner", true))
    {
        new name[MAX_PLAYER_NAME];

        if(sscanf(string, "s[24]", name))
            return Usage(playerid, "/editworkshop [id] [owner] [new owner name]");

       	format(wsData[id][W_OWNER], 128, name);
       	Workshop_Save(id);
       	Workshop_Refresh(id);
    }
	return 1;
}


CMD:wsinfo(playerid, params[])
{
    if(pData[playerid][pAdmin] < 6)
		return PermissionError(playerid);
		
	if(!strlen(params)) return Usage(playerid, "/wsinfo [Workshop Id]");
	extract params -> new id;
	
	new kontol[1000];
	format
	(
		kontol, sizeof kontol,
		"[ID %d]\n"\
		"Name :\t%s\n"\
		"Owner :\t%s\n"\
		"Harga :\t$%d\n"\
		"\n"\
		"Pos : X:%f, Y:%f, Z:%f\n"\
		"\n"\
		"Uang :\t$%d\n"\
		"Component :\t%d\n"\
		"Status :\t%s\n"\
		"{ffffffff}Status Segel :\t%s\n",
		id,
		wsData[id][W_NAME],
        wsData[id][W_OWNER],
        wsData[id][W_PRICE],
        //--
        wsData[id][W_X_POS],
        wsData[id][W_Y_POS],
        wsData[id][W_Z_POS],
        //--
        wsData[id][W_MONEY_BANK],
        wsData[id][W_COMPONENT_STOCK],
        wsData[id][W_LOCK] ? ("{F81414}Close") : ("{6EF83C}Open"),
        wsData[id][W_SEGEL] ? ("{F81414}Tersegel") : ("{6EF83C}Terbuka")
	);
	ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_MSGBOX, "Workshop info", kontol, "Oke", "");
	return 1;
}

new Tawaran[MAX_PLAYERS] = -1;
new Penawar[MAX_PLAYERS];

alias:workshop("ws")
CMD:workshop(playerid, params[])
{
    new id = GetNearestWorkshop(playerid, 10);

	static
 	type[24], string[24];

	if(sscanf(params, "s[24]S()[128]", type, string))
 	{
  		Usage(playerid, "/workshop [invite, uninvite, accept, info, lock]");
  		return 1;
    }
    if(!strcmp(type, "name", true))
    {
        if(Player_OwnsWorkshop(playerid, id))
		{
		    static
      		name[24];
      		
		    if(sscanf(string, "s[24]", name))
		    {
      			Usage(playerid, "/workshop [name] [new name]");
       			return 1;
		    }
		    format(wsData[id][W_NAME], 128, name);
		    Workshop_Refresh(id);
		}
    }
    if(!strcmp(type, "invite", true))
    {
        if(Player_OwnsWorkshop(playerid, id))
		{
	    	new ids;

			if(sscanf(string, "d", ids))
			    return Usage(playerid, "/workshop invite [player id]");

            if(IsPlayerInRangeOfPlayer(playerid, ids, 10.0))
			{
				SendClientMessage(ids, 0xFFFFFFFF, "Anda Diberikan Penawaran Untuk Bekerja DiWorkshop, Gunakan /workshop accept Untuk Menerima");
				SendClientMessage(playerid, 0xFFFFFFFF, "Anda Berhasil Menawarkan Pekerjaan");

				Tawaran[ids] = id;
				Penawar[ids] = playerid;
			}
			else SendClientMessage(playerid, 0xCECECEFF, "Anda Harus Dekat Dengan Orang Yang Dimaksud");
		}
		else SendClientMessageEx(playerid, 0xFFFFFFFF, "Anda Tidak Memiliki Workshop Atau Jauh Dengan Workshop Anda");
	}
	if(!strcmp(type, "uninvite", true))
    {
    	if(Player_OwnsWorkshop(playerid, id))
		{
	    	new ids;

			if(sscanf(string, "d", ids))
			    return Usage(playerid, "/workshop uninvite [player id]");

			if(pData[ids][pWsEmplooye] == id)
			{
			    pData[ids][pWsEmplooye] = -1;
			    SendClientMessageEx(ids, 0xFFFFFFFF, "Anda Dipecat Dari Workshop Tempat Anda Bekerja");
			    SendClientMessageEx(playerid, 0xFFFFFFFF, "Anda Memecat %s[%d]", pData[ids][pName], ids);
			}
		}
		else SendClientMessageEx(playerid, 0xFFFFFFFF, "Anda Tidak Memiliki Workshop Atau Jauh Dengan Workshop Anda");
	}
	if(!strcmp(type, "accept", true))
    {
        if(Tawaran[playerid] != -1)
        {
	        SendClientMessageEx(playerid, 0xFFFFFFFF, "Anda Menerima Tawaran Pekerjaan Workshop");
	        SendClientMessageEx(Penawar[playerid], 0xFFFFFFFF, "%s[%d] Menerima Tawaran Bekerja Di Workshop Ini", pData[playerid][pName], playerid);

	        pData[playerid][pWsEmplooye] = Tawaran[playerid];
		}
		else SendClientMessageEx(playerid, 0xFFFFFFFF, "Anda Tidak Memiliki Penawaran");
    }
    if(!strcmp(type, "lock", true))
    {
    	if(Player_OwnsWorkshop(playerid, id))
		{
      		if(wsData[id][W_LOCK] == 0)
        	{
        		wsData[id][W_LOCK] = 1;
			}
   			else if(wsData[id][W_LOCK] == 1)
      		{
				wsData[id][W_LOCK] = 0;
      		}
		    Workshop_Refresh(id);
		}
    }
	if(!strcmp(type, "info", true))
    {
	    if(Player_OwnsWorkshop(playerid, id))
		{
			new kontol[1000];
			format
			(
				kontol, sizeof kontol,
				"[ID %d]\n"\
				"Name :\t%s\n"\
				"Owner :\t%s\n"\
				"Harga :\t$%d\n"\
				"\n"\
				"Uang :\t$%d\n"\
				"Component :\t%d\n"\
				"Status :\t%s\n"\
				"{ffffff}Status Segel :\t%s\n",
				id,
				wsData[id][W_NAME],
		        wsData[id][W_OWNER],
		        wsData[id][W_PRICE],
		        wsData[id][W_MONEY_BANK],
		        wsData[id][W_COMPONENT_STOCK],
		        wsData[id][W_LOCK] ? ("{F81414}Close") : ("{6EF83C}Open"),
		        wsData[id][W_SEGEL] ? ("{6EF83C}Terbuka") : ("{F81414}Tersegel")
			);
			ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_MSGBOX, "Workshop info", kontol, "Oke", "");
		}
		else if(pData[playerid][pWsEmplooye] == id)
		{
		    new kontol[1000];
			format
			(
				kontol, sizeof kontol,
				"[ID %d]\n"\
				"Name :\t%s\n"\
				"Owner :\t%s\n"\
				"Harga :\t$%d\n"\
				"Uang :\t$%d\n"\
				"Component :\t%d\n"\
				"Status :\t%s\n"\
				"Status Segel :\t%s\n",
				id,
				wsData[id][W_NAME],
		        wsData[id][W_OWNER],
		        wsData[id][W_PRICE],
		        wsData[id][W_MONEY_BANK],
		        wsData[id][W_COMPONENT_STOCK],
		        wsData[id][W_LOCK] ? ("{F81414}Close") : ("{6EF83C}Open"),
		        wsData[id][W_SEGEL] ? ("{6EF83C}Terbuka") : ("{F81414}Tersegel")
			);
			ShowPlayerDialog(playerid, DIALOG_UNUSED, DIALOG_STYLE_MSGBOX, "Workshop info", kontol, "Oke", "");
		}
    }
    return 1;
}

CMD:wstorage(playerid, params[])
{
    new workshopid = GetNearestWorkshop(playerid, 10);
    
	static
 	type[24], types[24], amount;

	if(sscanf(params, "s[24]s[24]d", type, types, amount))
 	{
  		Usage(playerid, "/workshop [component/money] [take/deposit] [amount]");
    	return 1;
    }
    if(Player_OwnsWorkshop(playerid, workshopid))
	{
	    if(!strcmp(type, "component", true))
	    {
	    	SendClientMessageEx(playerid, COLOR_YELLOW, "%d Workshop Component", wsData[workshopid][W_COMPONENT_STOCK]);
			if(!strcmp(types, "take", true))
		    {
		        if(!(1 <= amount <= 1000))
		            return Error(playerid, "1-1000");

				if(amount > wsData[workshopid][W_COMPONENT_STOCK])
				    return Error(playerid, "Tidak Cukup Component");

				wsData[workshopid][W_COMPONENT_STOCK] -= amount;
				pData[playerid][pComponent] += amount;
				Workshop_Save(workshopid);
				Info(playerid, "Anda Mengambil %d Component (%d Workshop Component)", amount, wsData[workshopid][W_COMPONENT_STOCK]);
		    }
		    if(!strcmp(types, "deposit", true))
		    {
		        if(!(1 <= amount <= 1000))
		            return Error(playerid, "1-1000");

	            if(amount > pData[playerid][pComponent])
				    return Error(playerid, "Tidak Cukup Component");

	            wsData[workshopid][W_COMPONENT_STOCK] += amount;
	            pData[playerid][pComponent] -= amount;
				Workshop_Save(workshopid);
				Info(playerid, "Anda Menambahkan %d Component (%d Workshop Component)", amount, wsData[workshopid][W_COMPONENT_STOCK]);
		    }
		    if(IsValidDynamic3DTextLabel(wsData[workshopid][W_S_LABEL]))
	    		DestroyDynamic3DTextLabel(wsData[workshopid][W_S_LABEL]);
	    }
	    if(!strcmp(type, "money", true))
	    {
	    	SendClientMessageEx(playerid, COLOR_YELLOW, "%d Workshop Money", wsData[workshopid][W_MONEY_BANK]);
	        if(!strcmp(types, "take", true))
		    {
		        if(!(1 <= amount <= 10000))
		            return Error(playerid, "1-100000");

	            if(amount > wsData[workshopid][W_MONEY_BANK])
				    return Error(playerid, "Tidak Cukup Uang");

	            wsData[workshopid][W_MONEY_BANK] -= amount;
	            GivePlayerMoneyEx(playerid, amount);
				Workshop_Save(workshopid);
				Info(playerid, "Anda Mengambil $%d (%d Workshop Money)", amount, wsData[workshopid][W_MONEY_BANK]);
		    }
		    if(!strcmp(types, "deposit", true))
		    {
		        if(!(1 <= amount <= 1000))
		            return Error(playerid, "1-1000");

	            if(amount > pData[playerid][pMoney])
				    return Error(playerid, "Tidak Cukup Uang");

	            wsData[workshopid][W_MONEY_BANK] += amount;
	            GivePlayerMoneyEx(playerid, -amount);
				Workshop_Save(workshopid);
				Info(playerid, "Anda Menambahkan $%d (%d Workshop Money)", amount, wsData[workshopid][W_MONEY_BANK]);
		    }
		    if(IsValidDynamic3DTextLabel(wsData[workshopid][W_S_LABEL]))
	    		DestroyDynamic3DTextLabel(wsData[workshopid][W_S_LABEL]);
 	    }
	}
	else if(pData[playerid][pWsEmplooye] == workshopid)
	{
	    if(!strcmp(type, "component", true))
	    {
	    	SendClientMessageEx(playerid, COLOR_YELLOW, "%d Workshop Component", wsData[workshopid][W_COMPONENT_STOCK]);
	        if(!strcmp(types, "take", true))
		    {
		        if(!(1 <= amount <= 1000))
		            return Error(playerid, "1-1000");

				if(amount > wsData[workshopid][W_COMPONENT_STOCK])
				    return Error(playerid, "Tidak Cukup Component");

				wsData[workshopid][W_COMPONENT_STOCK] -= amount;
				pData[playerid][pComponent] += amount;
				Workshop_Save(workshopid);
				Info(playerid, "Anda Mengambil %d Component (%d Workshop Component)", amount, wsData[workshopid][W_COMPONENT_STOCK]);
		    }
		    if(!strcmp(types, "deposit", true))
		    {
		        if(!(1 <= amount <= 1000))
		            return Error(playerid, "1-1000");

	            if(amount > pData[playerid][pComponent])
				    return Error(playerid, "Tidak Cukup Component");

	            wsData[workshopid][W_COMPONENT_STOCK] += amount;
	            pData[playerid][pComponent] -= amount;
				Workshop_Save(workshopid);
				Info(playerid, "Anda Menambahkan %d Component (%d Workshop Component)", amount, wsData[workshopid][W_COMPONENT_STOCK]);
		    }
		    if(IsValidDynamic3DTextLabel(wsData[workshopid][W_S_LABEL]))
	    		DestroyDynamic3DTextLabel(wsData[workshopid][W_S_LABEL]);
	    }
	    if(!strcmp(type, "money", true))
	    {
	    	SendClientMessageEx(playerid, COLOR_YELLOW, "%d Workshop Money", wsData[workshopid][W_MONEY_BANK]);
	        if(!strcmp(types, "take", true))
		    {
		        if(!(1 <= amount <= 1000))
		            return Error(playerid, "1-1000");

	            if(amount > wsData[workshopid][W_MONEY_BANK])
				    return Error(playerid, "Tidak Cukup Uang");

	            wsData[workshopid][W_MONEY_BANK] -= amount;
	            GivePlayerMoneyEx(playerid, amount);
				Workshop_Save(workshopid);
				Info(playerid, "Anda Mengambil $%d (%d Workshop Money)", amount, wsData[workshopid][W_MONEY_BANK]);
		    }
		    if(!strcmp(types, "deposit", true))
		    {
		        if(!(1 <= amount <= 1000))
		            return Error(playerid, "1-1000");

	            if(amount > pData[playerid][pMoney])
				    return Error(playerid, "Tidak Cukup Uang");

	            wsData[workshopid][W_MONEY_BANK] += amount;
	            GivePlayerMoneyEx(playerid, -amount);
				Workshop_Save(workshopid);
				Info(playerid, "Anda Menambahkan $%d (%d Workshop Money)", amount, wsData[workshopid][W_MONEY_BANK]);
		    }
		    if(IsValidDynamic3DTextLabel(wsData[workshopid][W_S_LABEL]))
	    		DestroyDynamic3DTextLabel(wsData[workshopid][W_S_LABEL]);
	    }
	}
    return 1;
}

GetNearestWorkshop(playerid, Float: dist = 0.0)
{
	if(dist == 0.0)
		dist = FLOAT_INFINITY;

	new workshopid;
	new Float: my_dist;

	for(new idx; idx < MAX_WORKSHOP; idx ++)
	{
		my_dist = GetPlayerDistanceFromPoint(playerid, wsData[idx][W_X_POS], wsData[idx][W_Y_POS], wsData[idx][W_Z_POS]);
		if(my_dist < dist)
		{
			dist = my_dist,
			workshopid = idx;
		}
	}
	return workshopid;
}
GetOwnedWorkshop(playerid)
{
	new tmpcount;
	foreach(new wid : Workshop)
	{
	    if(!strcmp(wsData[wid][W_OWNER], pData[playerid][pName], true))
	    {
     		tmpcount++;
		}
	}
	return tmpcount;
}

ReturnPlayerWorkshopID(playerid, hslot)
{
	new tmpcount;
	if(hslot < 1 && hslot > LIMIT_PER_PLAYER) return -1;
	foreach(new wid : Workshop)
	{
	    if(!strcmp(pData[playerid][pName], wsData[wid][W_OWNER], true))
	    {
     		tmpcount++;
       		if(tmpcount == hslot)
       		{
        		return wid;
  			}
	    }
	}
	return -1;
}

CMD:myws(playerid)
{
	if(GetOwnedWorkshop(playerid) == -1) return Error(playerid, "You don't have a workshop.");
	new wid, _tmpstring[128], count = GetOwnedWorkshop(playerid), CMDSString[512];
	CMDSString = "";
	new lock[128];
	Loop(itt, (count + 1), 1)
	{
	    wid = ReturnPlayerBisnisID(playerid, itt);
		if(wsData[wid][W_LOCK])
		{
			lock = "{FF0000}Open";
		}
		else
		{
			lock = "{00FF00}Closed";
		}
		if(itt == count)
		{
		    format(_tmpstring, sizeof(_tmpstring), ""LB_E"%d.\t{FFFF2A}%s   (%s)\n", itt, wsData[wid][W_NAME], lock);
		}
		else format(_tmpstring, sizeof(_tmpstring), ""LB_E"%d.\t{FFFF2A}%s  (%s)\n", itt, wsData[wid][W_NAME], lock);
		strcat(CMDSString, _tmpstring);
	}
	ShowPlayerDialog(playerid, DIALOG_MY_WORKSHOP, DIALOG_STYLE_LIST, "{FF0000}HB:PR {0000FF}Workshop", CMDSString, "Select", "Cancel");
	return 1;
}

stock IsPlayerInRangeOfPlayer(playerid, to_player, Float: distance)
{
	new Float: x, Float: y, Float: z;
	GetPlayerPos(to_player, x, y, z);

	return IsPlayerInRangeOfPoint(playerid, distance, x, y, z);
}

function CheckCars(playerid, vehicleid)
{
	if(!IsPlayerConnected(playerid)) return 0;
	//if(!IsValidVehicle(vehicleid)) return 0;
	if(!IsValidTimer(pData[playerid][pMechanic])) return 0;

	if(GetNearestVehicleToPlayer(playerid, 3.8, false) == vehicleid)
	{
		if(pData[playerid][pActivityTime] >= 100 && IsValidVehicle(vehicleid))
		{
			pData[playerid][pMechVeh] = vehicleid;
			InfoTD_MSG(playerid, 8000, "Checking done!");
			//SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s has successfully refulling the vehicle.", ReturnName(playerid));
			KillTimer(pData[playerid][pMechanic]);
			pData[playerid][pActivityTime] = 0;
			HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
			PlayerTextDrawHide(playerid, ActiveTD[playerid]);
			ClearAnimations(playerid);
			return 1;
		}
		else if(pData[playerid][pActivityTime] < 100 && IsValidVehicle(vehicleid))
		{
			pData[playerid][pActivityTime] += 5;
			SetPlayerProgressBarValue(playerid, pData[playerid][activitybar], pData[playerid][pActivityTime]);
		}
		else
		{
			Error(playerid, "Checking fail! Anda tidak berada didekat kendaraan tersebut!");
			KillTimer(pData[playerid][pMechanic]);
			HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
			PlayerTextDrawHide(playerid, ActiveTD[playerid]);
			pData[playerid][pActivityTime] = 0;
			pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
		}
	}
	else
	{
		Error(playerid, "Checking fail! Anda tidak berada didekat kendaraan tersebut!");
		KillTimer(pData[playerid][pMechanic]);
		HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
		PlayerTextDrawHide(playerid, ActiveTD[playerid]);
		pData[playerid][pActivityTime] = 0;
		pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
		return 1;
	}
	return 1;
}

function BodyFixs(playerid, vehicleid)
{
	if(!IsPlayerConnected(playerid)) return 0;
	//if(!IsValidVehicle(vehicleid)) return 0;
	if(!IsValidTimer(pData[playerid][pMechanic])) return 0;

	if(GetNearestVehicleToPlayer(playerid, 3.8, false) == vehicleid)
	{
		if(pData[playerid][pActivityTime] >= 100 && IsValidVehicle(vehicleid))
		{
			new panels, doors, light, tires;
			GetVehicleDamageStatus(vehicleid, panels, doors, light, tires);
			UpdateVehicleDamageStatus(vehicleid, 0, 0, 0, tires);

			InfoTD_MSG(playerid, 8000, "Fix body done!");
			pData[playerid][pMechVeh] = vehicleid;
			KillTimer(pData[playerid][pMechanic]);
			pData[playerid][pActivityTime] = 0;
			HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
			PlayerTextDrawHide(playerid, ActiveTD[playerid]);
			ClearAnimations(playerid);
			return 1;
		}
		else if(pData[playerid][pActivityTime] < 100 && IsValidVehicle(vehicleid))
		{
			pData[playerid][pActivityTime] += 5;
			SetPlayerProgressBarValue(playerid, pData[playerid][activitybar], pData[playerid][pActivityTime]);
		}
		else
		{
			Error(playerid, "Body fix fail! Anda tidak berada didekat kendaraan tersebut!");
			KillTimer(pData[playerid][pMechanic]);
			HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
			PlayerTextDrawHide(playerid, ActiveTD[playerid]);
			pData[playerid][pActivityTime] = 0;
			pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
		}
	}
	else
	{
		Error(playerid, "Body fix fail! Anda tidak berada didekat kendaraan tersebut!");
		KillTimer(pData[playerid][pMechanic]);
		HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
		PlayerTextDrawHide(playerid, ActiveTD[playerid]);
		pData[playerid][pActivityTime] = 0;
		pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
		return 1;
	}
	return 1;
}

function EngineFixs(playerid, vehicleid)
{
	if(!IsPlayerConnected(playerid)) return 0;
	//if(!IsValidVehicle(vehicleid)) return 0;
	if(!IsValidTimer(pData[playerid][pMechanic])) return 0;

	if(GetNearestVehicleToPlayer(playerid, 3.8, false) == vehicleid)
	{
		if(pData[playerid][pActivityTime] >= 100 && IsValidVehicle(vehicleid))
		{
			SetValidVehicleHealth(vehicleid, 1000);
			//new panels, doors, light, tires;
			//GetVehicleDamageStatus(vehicleid, panels, doors, light, tires);
			//UpdateVehicleDamageStatus(vehicleid, 0, 0, 0, tires);

			InfoTD_MSG(playerid, 8000, "Fix engine done!");
			pData[playerid][pMechVeh] = vehicleid;
			KillTimer(pData[playerid][pMechanic]);
			pData[playerid][pActivityTime] = 0;
			HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
			PlayerTextDrawHide(playerid, ActiveTD[playerid]);
			ClearAnimations(playerid);
			return 1;
		}
		else if(pData[playerid][pActivityTime] < 100 && IsValidVehicle(vehicleid))
		{
			pData[playerid][pActivityTime] += 5;
			SetPlayerProgressBarValue(playerid, pData[playerid][activitybar], pData[playerid][pActivityTime]);
		}
		else
		{
			Error(playerid, "Engine fix fail! Anda tidak berada didekat kendaraan tersebut!");
			KillTimer(pData[playerid][pMechanic]);
			HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
			PlayerTextDrawHide(playerid, ActiveTD[playerid]);
			pData[playerid][pActivityTime] = 0;
			pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
		}
	}
	else
	{
		Error(playerid, "Engine fix fail! Anda tidak berada didekat kendaraan tersebut!");
		KillTimer(pData[playerid][pMechanic]);
		HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
		PlayerTextDrawHide(playerid, ActiveTD[playerid]);
		pData[playerid][pActivityTime] = 0;
		pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
		return 1;
	}
	return 1;
}

function SprayCars(playerid, vehicleid)
{
	if(!IsPlayerConnected(playerid)) return 0;
	
	if(!IsValidTimer(pData[playerid][pMechanic])) return 0;
	if(GetNearestVehicleToPlayer(playerid, 3.8, false) == vehicleid)
	{
		if(pData[playerid][pActivityTime] >= 100 && IsValidVehicle(vehicleid))
		{

			ChangeVehicleColor(vehicleid, pData[playerid][pMechColor1], pData[playerid][pMechColor2]);
			foreach(new ii : PVehicles)
			{
				if(vehicleid == pvData[ii][cVeh])
				{
					pvData[ii][cColor1] = pData[playerid][pMechColor1];
					pvData[ii][cColor2] = pData[playerid][pMechColor2];
				}
			}
			InfoTD_MSG(playerid, 8000, "Spraying done!");
			pData[playerid][pMechVeh] = vehicleid;
			KillTimer(pData[playerid][pMechanic]);
			pData[playerid][pActivityTime] = 0;
			HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
			PlayerTextDrawHide(playerid, ActiveTD[playerid]);
			ClearAnimations(playerid);
			return 1;
		}
		else if(pData[playerid][pActivityTime] < 100 && IsValidVehicle(vehicleid))
		{
			pData[playerid][pActivityTime] += 5;
			SetPlayerProgressBarValue(playerid, pData[playerid][activitybar], pData[playerid][pActivityTime]);
		}
		else
		{
			Error(playerid, "Spraying car fail! Anda tidak berada didekat kendaraan tersebut!");
			KillTimer(pData[playerid][pMechanic]);
			HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
			PlayerTextDrawHide(playerid, ActiveTD[playerid]);
			pData[playerid][pActivityTime] = 0;
			pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
		}
	}
	else
	{
		Error(playerid, "Engine fix fail! Anda tidak berada didekat kendaraan tersebut!");
		KillTimer(pData[playerid][pMechanic]);
		HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
		PlayerTextDrawHide(playerid, ActiveTD[playerid]);
		pData[playerid][pActivityTime] = 0;
		pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
		return 1;
	}
	return 1;
}

function PaintjobCars(playerid, vehicleid)
{
	if(!IsPlayerConnected(playerid)) return 0;
	if(!IsValidTimer(pData[playerid][pMechanic])) return 0;

	if(GetNearestVehicleToPlayer(playerid, 3.8, false) == vehicleid)
	{
		if(pData[playerid][pActivityTime] >= 100 && IsValidVehicle(vehicleid))
		{

			ChangeVehiclePaintjob(vehicleid, pData[playerid][pMechColor1]);
			foreach(new ii : PVehicles)
			{
				if(vehicleid == pvData[ii][cVeh])
				{
					pvData[ii][cPaintJob] = pData[playerid][pMechColor1];
				}
			}

			InfoTD_MSG(playerid, 8000, "Painting done!");
			pData[playerid][pMechVeh] = vehicleid;
			KillTimer(pData[playerid][pMechanic]);
			pData[playerid][pActivityTime] = 0;
			HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
			PlayerTextDrawHide(playerid, ActiveTD[playerid]);
			ClearAnimations(playerid);
			return 1;
		}
		else if(pData[playerid][pActivityTime] < 100 && IsValidVehicle(vehicleid))
		{
			pData[playerid][pActivityTime] += 5;
			SetPlayerProgressBarValue(playerid, pData[playerid][activitybar], pData[playerid][pActivityTime]);
		}
		else
		{
			Error(playerid, "Spraying car fail! Anda tidak berada didekat kendaraan tersebut!");
			KillTimer(pData[playerid][pMechanic]);
			HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
			PlayerTextDrawHide(playerid, ActiveTD[playerid]);
			pData[playerid][pActivityTime] = 0;
			pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
		}
	}
	else
	{
		Error(playerid, "Engine fix fail! Anda tidak berada didekat kendaraan tersebut!");
		KillTimer(pData[playerid][pMechanic]);
		HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
		PlayerTextDrawHide(playerid, ActiveTD[playerid]);
		pData[playerid][pActivityTime] = 0;
		pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
		return 1;
	}
	return 1;
}

function ModifCars(playerid, vehicleid)
{
	if(!IsPlayerConnected(playerid)) return 0;
	if(!IsValidTimer(pData[playerid][pMechanic])) return 0;

	if(GetNearestVehicleToPlayer(playerid, 3.8, false) == vehicleid)
	{
		if(pData[playerid][pActivityTime] >= 100 && IsValidVehicle(vehicleid))
		{

			AddVehicleComponent(vehicleid, pData[playerid][pMechColor1]);
			SavePVComponents(vehicleid, pData[playerid][pMechColor1]);
			if(pData[playerid][pMechColor2] != 0)
			{
				AddVehicleComponent(vehicleid, pData[playerid][pMechColor2]);
				SavePVComponents(vehicleid, pData[playerid][pMechColor2]);
			}

			InfoTD_MSG(playerid, 8000, "Modif done!");
			pData[playerid][pMechVeh] = vehicleid;
			KillTimer(pData[playerid][pMechanic]);
			pData[playerid][pActivityTime] = 0;
			HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
			PlayerTextDrawHide(playerid, ActiveTD[playerid]);
			ClearAnimations(playerid);
			PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
			return 1;
		}
		else if(pData[playerid][pActivityTime] < 100 && IsValidVehicle(vehicleid))
		{
			pData[playerid][pActivityTime] += 5;
			SetPlayerProgressBarValue(playerid, pData[playerid][activitybar], pData[playerid][pActivityTime]);
		}
		else
		{
			Error(playerid, "Spraying car fail! Anda tidak berada didekat kendaraan tersebut!");
			KillTimer(pData[playerid][pMechanic]);
			HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
			PlayerTextDrawHide(playerid, ActiveTD[playerid]);
			pData[playerid][pActivityTime] = 0;
			pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
		}
	}
	else
	{
		Error(playerid, "Mofid fix fail! Anda tidak berada didekat kendaraan tersebut!");
		KillTimer(pData[playerid][pMechanic]);
		HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
		PlayerTextDrawHide(playerid, ActiveTD[playerid]);
		pData[playerid][pActivityTime] = 0;
		pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
		return 1;
	}
	return 1;
}


function NeonCars(playerid, vehicleid)
{
	if(!IsPlayerConnected(playerid)) return 0;
	if(!IsValidTimer(pData[playerid][pMechanic])) return 0;
	if(GetNearestVehicleToPlayer(playerid, 3.8, false) == vehicleid)
	{
		if(pData[playerid][pActivityTime] >= 100 && IsValidVehicle(vehicleid))
		{
			if(pData[playerid][pMechColor1] == 0)
			{
				SetVehicleNeonLights(vehicleid, false, pData[playerid][pMechColor1], 0);
			}
			else
			{
				SetVehicleNeonLights(vehicleid, true, pData[playerid][pMechColor1], 0);
			}
			foreach(new ii : PVehicles)
			{
				if(vehicleid == pvData[ii][cVeh])
				{
					pvData[ii][cNeon] = pData[playerid][pMechColor1];

					if(pvData[ii][cNeon] == 0)
					{
						pvData[ii][cTogNeon] = 0;
					}
					else
					{
						pvData[ii][cTogNeon] = 1;
					}
				}
			}

			InfoTD_MSG(playerid, 8000, "Neon done!");
			pData[playerid][pMechVeh] = vehicleid;
			KillTimer(pData[playerid][pMechanic]);
			pData[playerid][pActivityTime] = 0;
			HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
			PlayerTextDrawHide(playerid, ActiveTD[playerid]);
			ClearAnimations(playerid);
			return 1;
		}
		else if(pData[playerid][pActivityTime] < 100 && IsValidVehicle(vehicleid))
		{
			pData[playerid][pActivityTime] += 5;
			SetPlayerProgressBarValue(playerid, pData[playerid][activitybar], pData[playerid][pActivityTime]);
		}
		else
		{
			Error(playerid, "Spraying car fail! Anda tidak berada didekat kendaraan tersebut!");
			KillTimer(pData[playerid][pMechanic]);
			HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
			PlayerTextDrawHide(playerid, ActiveTD[playerid]);
			pData[playerid][pActivityTime] = 0;
			pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
		}
	}
	else
	{
		Error(playerid, "Engine fix fail! Anda tidak berada didekat kendaraan tersebut!");
		KillTimer(pData[playerid][pMechanic]);
		HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
		PlayerTextDrawHide(playerid, ActiveTD[playerid]);
		pData[playerid][pActivityTime] = 0;
		pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
		return 1;
	}
	return 1;
}
