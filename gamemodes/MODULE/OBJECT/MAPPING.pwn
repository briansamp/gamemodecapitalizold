//maping andro sistem
#define MAX_MAPPING         100

enum E_MAPING
{
	mObj,
	mObject,
	Float: mPosX,
	Float: mPosY,
	Float: mPosZ,
	Float: mRotX,
	Float: mRotY,
	Float: mRotZ,
	Text3D: mLabel
}
new
	mpData[MAX_MAPPING][E_MAPING],
	Iterator:Mapping<MAX_MAPPING>;

CMD:createmapping(playerid, params[])
{
	if(pData[playerid][pAdmin] < 1)
		return PermissionError(playerid);

	new id = Iter_Free(Mapping);

	if(id == -1) return Error(playerid, "You cant create more mapping");

	new object, Float:xpos, Float:ypos, Float:zpos, Float:xrot, Float:yrot, Float:zrot;

	if(sscanf(params, "dffffff", object, xpos, ypos, zpos, xrot, yrot, zrot)) return Usage(playerid, "/createmapping [object] [pos x] [pos y] [pos z] [rot x] [rot y] [rot z]");

	mpData[id][mObj] = CreateDynamicObject(object, xpos, ypos, zpos, xrot, yrot, zrot);
	
	mpData[id][mObject] = object;
	mpData[id][mPosX] = xpos;
	mpData[id][mPosY] = ypos;
	mpData[id][mPosZ] = zpos;
	mpData[id][mRotX] = xrot;
	mpData[id][mRotY] = yrot;
	mpData[id][mRotZ] = zrot;

	new string[200];
	format
	(
		string, sizeof string, "Object Id : %d\nPos X : %f\nPos Y : %f\nPos Z : %f\nRot X : %f\nRot Y : %f\nRot Z : %f",
	    mpData[id][mObject],
		mpData[id][mPosX],
		mpData[id][mPosY],
		mpData[id][mPosZ],
		mpData[id][mRotX],
		mpData[id][mRotY],
		mpData[id][mRotZ]
 	);
	mpData[id][mLabel] = CreateDynamic3DTextLabel(string, 0xFFFFFFFF, mpData[id][mPosX], mpData[id][mPosY], mpData[id][mPosZ], 20);

 	Iter_Add(Mapping, id);
 	return 1;
}

Mapping_Refresh(id)
{
    if(id != -1)
    {
	    if(IsValidDynamic3DTextLabel(mpData[id][mLabel]))
	    	DestroyDynamic3DTextLabel(mpData[id][mLabel]);

		if(IsValidDynamicObject(mpData[id][mObj]))
	 		DestroyDynamicObject(mpData[id][mObj]);

        new string[200];
		format
		(
			string, sizeof string, "Object Id : %d\nPos X : %f\nPos Y : %f\nPos Z : %f\nRot X : %f\nRot Y : %f\nRot Z : %f",
		    mpData[id][mObject],
			mpData[id][mPosX],
			mpData[id][mPosY],
			mpData[id][mPosZ],
			mpData[id][mRotX],
			mpData[id][mRotY],
			mpData[id][mRotZ]
	 	);
		mpData[id][mLabel] = CreateDynamic3DTextLabel(string, 0xFFFFFFFF, mpData[id][mPosX], mpData[id][mPosY], mpData[id][mPosZ], 20);

        mpData[id][mObj] = CreateDynamicObject(mpData[id][mObject], mpData[id][mPosX], mpData[id][mPosY], mpData[id][mPosZ], mpData[id][mRotX], mpData[id][mRotY], mpData[id][mRotZ]);
	}
}

CMD:editmp(playerid, params[])
{
		    if(pData[playerid][pAdmin] < 1)
				return PermissionError(playerid);

            static
	        id, type[24], string[24];

		    if(sscanf(params, "ds[24]S()[128]", id, type, string))
		    {
		        Usage(playerid, "/editmp [id] [pos/object]");
		        return 1;
		    }
			if(!strcmp(type, "pos", true))
		    {
		        new types[24], Float:amount;

		        if(sscanf(string, "s[24]f", types, amount))
		            return Usage(playerid, "/editmp [id] [pos] [posx-y-z] [amount]");

				if(!strcmp(types, "posx", true))
			    {
					mpData[id][mPosX] = amount;
					Mapping_Refresh(id);
			    }
			    if(!strcmp(types, "posy", true))
			    {
                    mpData[id][mPosY] = amount;
                    Mapping_Refresh(id);
			    }
			    if(!strcmp(types, "posz", true))
			    {
       				mpData[id][mPosZ] = amount;
       				Mapping_Refresh(id);
			    }
			    if(!strcmp(types, "rotx", true))
			    {
       				mpData[id][mRotX] = amount;
       				Mapping_Refresh(id);
			    }
			    if(!strcmp(types, "roty", true))
			    {
       				mpData[id][mRotY] = amount;
       				Mapping_Refresh(id);
			    }
			    if(!strcmp(types, "rotz", true))
			    {
       				mpData[id][mRotZ] = amount;
       				Mapping_Refresh(id);
			    }
		    }
		    if(!strcmp(type, "object", true))
		    {
		        new amount;

		        if(sscanf(string, "d", amount))
		            return Usage(playerid, "/editmp [id] [object] [new id object]");

		        mpData[id][mObject] = amount;
		        Mapping_Refresh(id);
		    }
		    if(!strcmp(type, "edit", true))
		    {
		        EditDynamicObject(playerid, mpData[id][mObj]);
		    }
		    if(!strcmp(type, "save", true))
		    {
		        GetDynamicObjectPos(mpData[id][mObj], mpData[id][mPosX], mpData[id][mPosY], mpData[id][mPosZ]);
  				Mapping_Refresh(id);
		    }
			return 1;
}

