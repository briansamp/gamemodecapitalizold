#define MAX_COBJECTS 1000

//Object
new oEdit[MAX_PLAYERS];
new oEditID[MAX_PLAYERS]; // Object's ID
new Float:oPos[MAX_PLAYERS][3];
new Float:oRot[MAX_PLAYERS][3];

enum objInfo
{
	oMT,
	objText[256],
	objCol1,
	objCol2,
	objMSize,
	objFSize,
	objBold,
	objAlig,
	obj,
	Text3D:oText,
	oModel,
	Float:oX,
	Float:oY,
	Float:oZ,
	Float:oRX,
	Float:oRY,
	Float:oRZ,
}
new ObjectInfo[MAX_COBJECTS][objInfo];
Float:GetDistance( Float: x1, Float: y1, Float: z1, Float: x2, Float: y2, Float: z2 )
{
	new Float:d;
	d += floatpower(x1-x2, 2.0 );
	d += floatpower(y1-y2, 2.0 );
	d += floatpower(z1-z2, 2.0 );
	d = floatsqroot(d);
	return d;
}
stock split(const strsrc[], strdest[][], delimiter)
{
    new i, li;
    new aNum;
    new len;
    while(i <= strlen(strsrc))
    {
        if(strsrc[i] == delimiter || i == strlen(strsrc))
        {
            len = strmid(strdest[aNum], strsrc, li, i, 128);
            strdest[aNum][len] = 0;
            li = i+1;
            aNum++;
        }
        i++;
    }
    return 1;
}
stock GetName(playerid)
{
	new name[MAX_PLAYER_NAME];
 	GetPlayerName(playerid,name,sizeof(name));
	return name;
}
FormatText(text[])
{
	new len = strlen(text);
	if(len > 1)
	{
		for(new i = 0; i < len; i++)
		{
			if(text[i] == 92)
			{
				// New line
			    if(text[i+1] == 'n')
			    {
					text[i] = '\n';
					for(new j = i+1; j < len; j++) text[j] = text[j+1], text[j+1] = 0;
					continue;
			    }

				// Tab
			    if(text[i+1] == 't')
			    {
					text[i] = '\t';
					for(new j = i+1; j < len-1; j++) text[j] = text[j+1], text[j+1] = 0;
					continue;
			    }

				// Literal
			    if(text[i+1] == 92)
			    {
					text[i] = 92;
					for(new j = i+1; j < len-1; j++) text[j] = text[j+1], text[j+1] = 0;
			    }
			}
		}
	}
	return 1;
}

stock LoadObjects()
{
	new dinfo[11][128];
	new String[256];
	new File:file = fopen("cobjects.cfg", io_read);
	if(file)
	{
	    new idx = 1;
		while(idx < MAX_COBJECTS)
		{
		    fread(file, String);
		    split(String, dinfo, '|');
			format(ObjectInfo[idx][objText], 256, "%s", dinfo[0]);
			ObjectInfo[idx][oModel] = strval(dinfo[1]);
			ObjectInfo[idx][oMT] = strval(dinfo[2]);
			ObjectInfo[idx][oX] = floatstr(dinfo[3]);
			ObjectInfo[idx][oY] = floatstr(dinfo[4]);
			ObjectInfo[idx][oZ] = floatstr(dinfo[5]);
			ObjectInfo[idx][oRX] = floatstr(dinfo[6]);
			ObjectInfo[idx][oRY] = floatstr(dinfo[7]);
			ObjectInfo[idx][oRZ] = floatstr(dinfo[8]);
			ObjectInfo[idx][objFSize] = strval(dinfo[9]);
			ObjectInfo[idx][objMSize] = strval(dinfo[10]);
			if(ObjectInfo[idx][oModel]) // If gate exists
			{
			    if(ObjectInfo[idx][oMT] == 0)
			    {
					ObjectInfo[idx][obj] = CreateDynamicObject(ObjectInfo[idx][oModel], ObjectInfo[idx][oX], ObjectInfo[idx][oY], ObjectInfo[idx][oZ], ObjectInfo[idx][oRX], ObjectInfo[idx][oRY], ObjectInfo[idx][oRZ]);
					//O-bjectInfo[idx][oText] = CreateDynamic3DTextLabel(String, COLOR_RED, ObjectInfo[idx][oX], ObjectInfo[idx][oY], ObjectInfo[idx][oZ], 10);
				}
				else if(ObjectInfo[idx][oMT] == 1)
				{
					ObjectInfo[idx][obj] = CreateDynamicObject(ObjectInfo[idx][oModel], ObjectInfo[idx][oX], ObjectInfo[idx][oY], ObjectInfo[idx][oZ], ObjectInfo[idx][oRX], ObjectInfo[idx][oRY], ObjectInfo[idx][oRZ]);
					format(String, 128, "%s", ObjectInfo[idx][objText]);
					SetDynamicObjectMaterialText(ObjectInfo[idx][obj], 0, ObjectInfo[idx][objText], ObjectInfo[idx][objMSize], "Arial", ObjectInfo[idx][objFSize], 1, 0xFFFFFFFF, -16777216, 1);
					//O-bjectInfo[idx][oText] = CreateDynamic3DTextLabel(String, COLOR_RED, ObjectInfo[idx][oX], ObjectInfo[idx][oY], ObjectInfo[idx][oZ], 10);
				}
			}
			idx++;
	    }
	}
	return 1;
}

stock SaveObj()
{
	new idx = 1, File:file;
	new String[256];
	while(idx < MAX_COBJECTS)
	{
	    format(String, sizeof(String), "%s|%d|%d|%f|%f|%f|%f|%f|%f|%i|%i\r\n",
        ObjectInfo[idx][objText],
        ObjectInfo[idx][oModel],
        ObjectInfo[idx][oMT],
        ObjectInfo[idx][oX],
        ObjectInfo[idx][oY],
        ObjectInfo[idx][oZ],
        ObjectInfo[idx][oRX],
        ObjectInfo[idx][oRY],
        ObjectInfo[idx][oRZ],
        ObjectInfo[idx][objFSize],
        ObjectInfo[idx][objMSize]);
        if(idx == 1)
	    {
	        file = fopen("cobjects.cfg", io_write);
	    }
	    else
	    {
	    	file = fopen("cobjects.cfg", io_append);
	    }
		fwrite(file, String);
		fclose(file);
		idx++;
	}
	return 1;
}

CMD:setalldmtobject(playerid, params[])
{
	if(pData[playerid][pAdmin] < 5)
	//if(pData[playerid][pHelper] == 1)
	return PermissionError(playerid);

	for(new idx;idx<MAX_COBJECTS;idx++)
	{
	    ObjectInfo[idx][oMT] = 0;
	    DestroyDynamicObject(ObjectInfo[idx][obj]);
		ObjectInfo[idx][obj] = CreateDynamicObject(ObjectInfo[idx][oModel], ObjectInfo[idx][oX], ObjectInfo[idx][oY], ObjectInfo[idx][oZ], ObjectInfo[idx][oRX], ObjectInfo[idx][oRY], ObjectInfo[idx][oRZ]);
	    SaveObj();
	    return 1;
	}
	SendClientMessage(playerid, COLOR_RED, "INFO: {FFFFFF}Anda telah mematikan efek Material Text Object");
	return 1;
}

CMD:createobject(playerid, params[])
{
	new String[10000], object;
 	if(pData[playerid][pAdmin] < 5)
	//if(pData[playerid][pHelper] == 1)
	return PermissionError(playerid);
	{
		if(sscanf(params, "i", object)) return Usage(playerid, "> /createobject [objectid]");
		for(new idx=1; idx<MAX_COBJECTS; idx++)
		{
		    if(!ObjectInfo[idx][oModel])
		    {
		        GetPlayerPos(playerid, ObjectInfo[idx][oX], ObjectInfo[idx][oY], ObjectInfo[idx][oZ]);
	  			ObjectInfo[idx][oModel] = object;
				ObjectInfo[idx][oX] = ObjectInfo[idx][oX] + 2;
				ObjectInfo[idx][oY] = ObjectInfo[idx][oY] + 2;
				ObjectInfo[idx][oRX] = 0;
				ObjectInfo[idx][oRY] = 0;
				ObjectInfo[idx][oRZ] = 0;
				ObjectInfo[idx][oMT] = 0;
				// Creating
				ObjectInfo[idx][obj] = CreateDynamicObject(ObjectInfo[idx][oModel], ObjectInfo[idx][oX], ObjectInfo[idx][oY], ObjectInfo[idx][oZ], ObjectInfo[idx][oRX], ObjectInfo[idx][oRY], ObjectInfo[idx][oRZ]);
				//O-bjectInfo[idx][oText] = CreateDynamic3DTextLabel(String, COLOR_RED, ObjectInfo[idx][oX], ObjectInfo[idx][oY], ObjectInfo[idx][oZ], 10);
				// Text
				format(String, sizeof(String), "AdmCmd: %s has created object ID %d. (Object: %d)", GetName(playerid), idx, object);
			    SendStaffMessage(COLOR_RED, String, 2);

				idx = MAX_COBJECTS;
				SaveObj();
			}
		}
	}
	return 1;
}
CMD:onear(playerid, params[])
{
    if(pData[playerid][pAdmin] < 5)
	//if(pData[playerid][pHelper] == 1)
	return PermissionError(playerid);
	{
		SendClientMessageEx(playerid, COLOR_LOGS, "SERVER: Waiting!");
		new Float:X, Float:Y, Float:Z;
		new Float:X2, Float:Y2, Float:Z2;
  		GetPlayerPos(playerid, X2, Y2, Z2);
		for(new i;i<MAX_COBJECTS;i++)
		{
			GetDynamicObjectPos(ObjectInfo[i][obj], X, Y, Z);
			if(IsPlayerInRangeOfPoint(playerid, 10, X, Y, Z))
			{
				if(ObjectInfo[i][oModel] != 0)
				{
				    new String[10000];
			    	format(String, sizeof(String), "INFO: {FFFFFF}Object ID %d | %f from you", i, GetDistance(X, Y, Z, X2, Y2, Z2));
			    	SendClientMessageEx(playerid, COLOR_RED, String);
				}
			}
		}
	}
	return 1;
}

CMD:editobject(playerid, params[])
{
	new String[10000], idx;
	if(pData[playerid][pAdmin] < 5)
	//if(pData[playerid][pHelper] == 1)
	return PermissionError(playerid);
	{
	 	if(sscanf(params, "s[128]", params))
		{
			Usage(playerid, "> /objedit [Names] [objectid]");
            Info(playerid, "Names: mt | objek | posisi | fsize | msize | text");
			return 1;
		}
		if(!strcmp(params, "mt", true, 2))
		{
		    new mt;
		    if(sscanf(params, "s[128]ii", params, idx, mt))
	 		{
		 		SendClientMessage(playerid, COLOR_RED, "KEGUNAAN: /editobject mt [objectid] [mt on/off]");
		 		SendClientMessage(playerid, COLOR_RED, "1 = On | 0 = Off");
		 		Usage(playerid, "> /editobject mt [objectid] [action]");
            	Info(playerid, "action: 1 = On | 0 = Off");
				return 1;
			}
	        if(!ObjectInfo[idx][oModel]) return Info(playerid, "Invalid object id.");
			ObjectInfo[idx][oMT] = mt;
			SaveObj();
			if(ObjectInfo[idx][oMT] == 0)
	  		{
				DestroyDynamicObject(ObjectInfo[idx][obj]);
				ObjectInfo[idx][obj] = CreateDynamicObject(ObjectInfo[idx][oModel], ObjectInfo[idx][oX], ObjectInfo[idx][oY], ObjectInfo[idx][oZ], ObjectInfo[idx][oRX], ObjectInfo[idx][oRY], ObjectInfo[idx][oRZ]);
				format(String, 128, "INFO: {FFFFFF}Anda telah menonaktifkan Material Text Object ID: %d", idx);
			    SendClientMessage(playerid, COLOR_RED, String);
			}
			else if(ObjectInfo[idx][oMT] == 1)
			{
				DestroyDynamicObject(ObjectInfo[idx][obj]);
				ObjectInfo[idx][obj] = CreateDynamicObject(ObjectInfo[idx][oModel], ObjectInfo[idx][oX], ObjectInfo[idx][oY], ObjectInfo[idx][oZ], ObjectInfo[idx][oRX], ObjectInfo[idx][oRY], ObjectInfo[idx][oRZ]);
				format(String, 128, "%s", ObjectInfo[idx][objText]);
				SetDynamicObjectMaterialText(ObjectInfo[idx][obj], 0, ObjectInfo[idx][objText], ObjectInfo[idx][objMSize], "Arial", ObjectInfo[idx][objFSize], 1, 0xFFF5F5F5, 0xFF000000, 1);
				format(String, 128, "INFO: {FFFFFF}Anda telah mengaktifkan Material Text Object ID: %d", idx);
			    SendClientMessage(playerid, COLOR_RED, String);
			}
		}
		if(!strcmp(params, "objek", true, 5))
		{
		    new object;
		    if(sscanf(params, "s[128]ii", params, idx, object)) return Usage(playerid, "> /objedit object [objectid] [new objectid]");
	        if(!ObjectInfo[idx][oModel]) return Info(playerid, "Invalid object id.");
	        /*if(object == 0)
			{
				//format(String, sizeof(String), "%d", object);
				//cmd_deleteobject(playerid, String);
				return 1;
			}*/
			ObjectInfo[idx][oModel] = object;
			DestroyDynamicObject(ObjectInfo[idx][obj]);
			ObjectInfo[idx][obj] = CreateDynamicObject(ObjectInfo[idx][oModel], ObjectInfo[idx][oX], ObjectInfo[idx][oY], ObjectInfo[idx][oZ], ObjectInfo[idx][oRX], ObjectInfo[idx][oRY], ObjectInfo[idx][oRZ]);
		    format(String, sizeof(String), "INFO: {FFFFFF}You have set object ID %d's object ID to %d.", idx, object);
		    SendClientMessage(playerid, COLOR_RED, String);
			SaveObj();
		}
		else if(!strcmp(params, "posisi", true, 5))
		{
		    if(sscanf(params, "s[128]i", params, idx)) return Usage(playerid, "> /objedit position [objectid]");
	        if(!ObjectInfo[idx][oModel]) return SendClientMessage(playerid, COLOR_GREY, "Invalid object id.");
			oEdit[playerid] = 1;
			oEditID[playerid] = idx;
			GetDynamicObjectPos(ObjectInfo[idx][obj], oPos[playerid][0], oPos[playerid][1], oPos[playerid][2]);
			GetDynamicObjectRot(ObjectInfo[idx][obj], oRot[playerid][0], oRot[playerid][1], oRot[playerid][2]);
			EditDynamicObject(playerid, ObjectInfo[idx][obj]);
		    format(String, sizeof(String), "INFO: {FFFFFF}You are now editing object ID %d's position.", idx);
		    SendClientMessage(playerid, COLOR_RED, String);
		}
		else if(!strcmp(params, "fsize", true, 5))
		{
		    new fsize;
		    if(sscanf(params, "s[128]ii", params, idx, fsize)) return Usage(playerid, "> /editobject fsize [ObjectID] [Font Size]");
	        if(!ObjectInfo[idx][oModel]) return SendClientMessage(playerid, COLOR_GREY, "Invalid object id.");
			ObjectInfo[idx][objFSize] = fsize;
			DestroyDynamicObject(ObjectInfo[idx][obj]);
			ObjectInfo[idx][obj] = CreateDynamicObject(ObjectInfo[idx][oModel], ObjectInfo[idx][oX], ObjectInfo[idx][oY], ObjectInfo[idx][oZ], ObjectInfo[idx][oRX], ObjectInfo[idx][oRY], ObjectInfo[idx][oRZ]);
			SetDynamicObjectMaterialText(ObjectInfo[idx][obj], 0, ObjectInfo[idx][objText], ObjectInfo[idx][objMSize], "Arial", ObjectInfo[idx][objFSize], 1, 0xFFF5F5F5, 0xFF000000, 1);
			SaveObj();
		}
		else if(!strcmp(params, "msize", true, 5))
		{
		    new msize;
		    if(sscanf(params, "s[128]ii", params, idx, msize)) return Usage(playerid, "> /editobject msize [ObjectID] [Material Size]");
	        if(!ObjectInfo[idx][oModel]) return SendClientMessage(playerid, COLOR_GREY, "Invalid object id.");
			ObjectInfo[idx][objMSize] = msize;
			DestroyDynamicObject(ObjectInfo[idx][obj]);
			ObjectInfo[idx][obj] = CreateDynamicObject(ObjectInfo[idx][oModel], ObjectInfo[idx][oX], ObjectInfo[idx][oY], ObjectInfo[idx][oZ], ObjectInfo[idx][oRX], ObjectInfo[idx][oRY], ObjectInfo[idx][oRZ]);
			SetDynamicObjectMaterialText(ObjectInfo[idx][obj], 0, ObjectInfo[idx][objText], ObjectInfo[idx][objMSize], "Arial", ObjectInfo[idx][objFSize], 1, 0xFFF5F5F5, 0xFF000000, 1);
			SaveObj();
		}
		else if(!strcmp(params, "text", true, 4))
		{
		    new password[256];
		    if(sscanf(params, "s[128]is[256]", params, idx, password)) return Usage(playerid, "> /editobject tulisan [ID Object] [Tulisan]");
	        if(!ObjectInfo[idx][oModel]) return SendClientMessage(playerid, COLOR_GREY, "ERROR: ID gate salah.");
			FormatText(password);
			format(ObjectInfo[idx][objText], 256, "%s", password);
			DestroyDynamicObject(ObjectInfo[idx][obj]);
			ObjectInfo[idx][obj] = CreateDynamicObject(ObjectInfo[idx][oModel], ObjectInfo[idx][oX], ObjectInfo[idx][oY], ObjectInfo[idx][oZ], ObjectInfo[idx][oRX], ObjectInfo[idx][oRY], ObjectInfo[idx][oRZ]);
			SetDynamicObjectMaterialText(ObjectInfo[idx][obj], 0, ObjectInfo[idx][objText], ObjectInfo[idx][objMSize], "Arial", ObjectInfo[idx][objFSize], 1, 0xFFF5F5F5, 0xFF000000, 1);
		    format(String, sizeof(String), "INFO:{FFFFFF} Anda telah menset Teks Objek ID %d menjadi {FF6347}%s", idx, password);
		    SendClientMessage(playerid, COLOR_RED, String);
			SaveObj();
		}
	}
	return 1;
}

CMD:cdeleteobject(playerid, params[])
{
	new idx, String[10000];
	if(pData[playerid][pAdmin] < 5)
	//if(pData[playerid][pHelper] == 1)
	return PermissionError(playerid);
	{
		if(sscanf(params, "i", idx)) return Usage(playerid, "> /deleteobject [objid]");
		if(!ObjectInfo[idx][oModel]) return Info(playerid, "Invalid object id.");
		ObjectInfo[idx][oModel] = 0;
		ObjectInfo[idx][oX] = 0;
		ObjectInfo[idx][oY] = 0;
		ObjectInfo[idx][oZ] = 0;
		ObjectInfo[idx][oRX] = 0;
		ObjectInfo[idx][oRY] = 0;
		ObjectInfo[idx][oRZ] = 0;
		format(ObjectInfo[idx][objText], 256, "None");
		ObjectInfo[idx][objFSize] = 0;
		ObjectInfo[idx][objMSize] = 0;
		DestroyDynamicObject(ObjectInfo[idx][obj]);
		DestroyDynamic3DTextLabel(ObjectInfo[idx][oText]);
		format(String, sizeof(String), "AdmCmd: %s has deleted object ID %d.", GetName(playerid), idx);
	    SendStaffMessage(COLOR_RED, String, 2);

		SaveObj();
	}
	return 1;
}

