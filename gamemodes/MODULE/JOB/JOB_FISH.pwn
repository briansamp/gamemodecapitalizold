//Fishing System
IsPlayerInWater(playerid)
{
  new Float:x,Float:y,Float:pz;
  GetPlayerPos(playerid,x,y,pz);
  if (
  (IsPlayerInArea(playerid, 2032.1371, 1841.2656, 1703.1653, 1467.1099) && pz <= 9.0484) //lv piratenschiff
    || (IsPlayerInArea(playerid, 2109.0725, 2065.8232, 1962.5355, 10.8547) && pz <= 10.0792) //lv visage
    || (IsPlayerInArea(playerid, -492.5810, -1424.7122, 2836.8284, 2001.8235) && pz <= 41.06) //lv staucamm
    || (IsPlayerInArea(playerid, -2675.1492, -2762.1792, -413.3973, -514.3894) && pz <= 4.24) //sf südwesten kleiner teich
    || (IsPlayerInArea(playerid, -453.9256, -825.7167, -1869.9600, -2072.8215) && pz <= 5.72) //sf gammel teich
    || (IsPlayerInArea(playerid, 1281.0251, 1202.2368, -2346.7451, -2414.4492) && pz <= 9.3145) //ls neben dem airport
    || (IsPlayerInArea(playerid, 2012.6154, 1928.9028, -1178.6207, -1221.4043) && pz <= 18.45) //ls mitte teich
    || (IsPlayerInArea(playerid, 2326.4858, 2295.7471, -1400.2797, -1431.1266) && pz <= 22.615) //ls weiter südöstlich
    || (IsPlayerInArea(playerid, 2550.0454, 2513.7588, 1583.3751, 1553.0753) && pz <= 9.4171) //lv pool östlich
    || (IsPlayerInArea(playerid, 1102.3634, 1087.3705, -663.1653, -682.5446) && pz <= 112.45) //ls pool nordwestlich
    || (IsPlayerInArea(playerid, 1287.7906, 1270.4369, -801.3882, -810.0527) && pz <= 87.123) //pool bei maddog's haus oben
    || (pz < 1.5)
  )
  {
    return 1;
  }
  return 0;
}

IsPlayerInArea(playerid, Float:minx, Float:maxx, Float:miny, Float:maxy)
{
  new Float:x, Float:y, Float:z;
  GetPlayerPos(playerid, x, y, z);
  if (x > minx && x < maxx && y > miny && y < maxy) return 1;
  return 0;
}

IsAtFishPlace(playerid)
{
  if(IsPlayerConnected(playerid))
  {
      if(IsPlayerInRangeOfPoint(playerid,1.0,403.8266,-2088.7598,7.8359) || IsPlayerInRangeOfPoint(playerid,1.0,398.7553,-2088.7490,7.8359))
    {
        return 1;
    }
      else if(IsPlayerInRangeOfPoint(playerid,1.0,396.2197,-2088.6692,7.8359) || IsPlayerInRangeOfPoint(playerid,1.0,391.1094,-2088.7976,7.8359))
    {
        return 1;
    }
      else if(IsPlayerInRangeOfPoint(playerid,1.0,383.4157,-2088.7849,7.8359) || IsPlayerInRangeOfPoint(playerid,1.0,374.9598,-2088.7979,7.8359))
    {
        return 1;
    }
      else if(IsPlayerInRangeOfPoint(playerid,1.0,369.8107,-2088.7927,7.8359) || IsPlayerInRangeOfPoint(playerid,1.0,367.3637,-2088.7925,7.8359))
    {
        return 1;
    }
      else if(IsPlayerInRangeOfPoint(playerid,1.0,362.2244,-2088.7981,7.8359) || IsPlayerInRangeOfPoint(playerid,1.0,354.5382,-2088.7979,7.8359))
    {
        return 1;
    }
      else if(IsPlayerInRangeOfPoint(playerid,100.0, 532.8261,-2845.8967,0.1618))
    {
        return 1;
    }
      else if(IsPlayerInWater(playerid))
    {
      return 1;
    }
  }
  return 0;
}

forward TimeMancingRendah(playerid);
public TimeMancingRendah(playerid)
{
  	new rand = random(4);
  	new String[10000];
  	new randberat = random(25)+10;
  	SedangMancing[playerid] = 0;
  	pData[playerid][pPancingan] --;
  	if(rand == 0)
  	{
    	SendClientMessageEx(playerid, COLOR_WHITE,"FISH-INFO: Kail Anda terputus Karena Deras nya air laut.");
    	ClearAnimations(playerid);
    	RemovePlayerAttachedObject(playerid, 0);
    	ClearAnimations(playerid);
    	TogglePlayerControllable(playerid,1);
    	return 1;
  	}
  	else if(rand == 1)
  	{
    	format(String, sizeof(String), "* Kamu mendapatkan ikan seberat {FF0000} %d gram", randberat);
      	SendClientMessageEx(playerid, COLOR_YELLOW,String);
      	pData[playerid][pBeratIkan] += randberat;
      	pData[playerid][pFMax] += 1;
      	RemovePlayerAttachedObject(playerid, 0);
    	ClearAnimations(playerid);
    	TogglePlayerControllable(playerid,1);
      	return 1;
  	}
  	else if(rand == 2)
  	{
    	SendClientMessageEx(playerid, COLOR_WHITE,"FISH-INFO: Kail Anda terputus Karena kuatnya tarikan Ikan.");
    	RemovePlayerAttachedObject(playerid, 0);
    	ClearAnimations(playerid);
    	TogglePlayerControllable(playerid,1);
    	return 1;
  	}
  	else if(rand == 3)
  	{
    	format(String, sizeof(String), "* Kamu mendapatkan ikan seberat {FF0000} %d gram", randberat);
      	SendClientMessageEx(playerid, COLOR_YELLOW,String);
      	pData[playerid][pBeratIkan] += randberat;
      	pData[playerid][pFMax] += 1;
      	RemovePlayerAttachedObject(playerid, 0);
    	ClearAnimations(playerid);
    	TogglePlayerControllable(playerid,1);
      	return 1;
  	}
    return 1;
}

forward TimeMancingTinggi(playerid);
public TimeMancingTinggi(playerid)
{
  	new rand = random(4);
  	new String[10000];
	new randberat = random(100)+200;
  	SedangMancing[playerid] = 0;
  	pData[playerid][pPancingan] --;
  	if(rand == 0)
  	{
    	SendClientMessageEx(playerid, COLOR_WHITE,"FISH-INFO: Kail Anda terputus Karena Deras nya air laut.");
    	RemovePlayerAttachedObject(playerid, 0);
    	ClearAnimations(playerid);
    	TogglePlayerControllable(playerid,1);
    	return 1;
  	}
  	else if(rand == 1)
  	{
    	format(String, sizeof(String), "* Kamu mendapatkan ikan seberat {FF0000} %d gram", randberat);
      	SendClientMessageEx(playerid, COLOR_YELLOW,String);
      	pData[playerid][pBeratIkan] += randberat;
      	pData[playerid][pFMax] += 1;
      	RemovePlayerAttachedObject(playerid, 0);
    	ClearAnimations(playerid);
    	TogglePlayerControllable(playerid,1);
      	return 1;
  	}
  	else if(rand == 2)
  	{
	    SendClientMessageEx(playerid, COLOR_WHITE,"FISH-INFO: Anda mendapatkan Jaket Bekas Lalu membuang nya.");
	    RemovePlayerAttachedObject(playerid, 0);
	    ClearAnimations(playerid);
	    TogglePlayerControllable(playerid,1);
	    return 1;
  	}
  	else if(rand == 3)
  	{
    	format(String, sizeof(String), "* Kamu mendapatkan ikan seberat {FF0000} %d gram", randberat);
     	SendClientMessageEx(playerid, COLOR_YELLOW,String);
      	pData[playerid][pBeratIkan] += randberat;
      	pData[playerid][pFMax] += 1;
      	RemovePlayerAttachedObject(playerid, 0);
    	ClearAnimations(playerid);
    	TogglePlayerControllable(playerid,1);
      	return 1;
  	}
    return 1;
}

forward TimeMancingTengah(playerid);
public TimeMancingTengah(playerid)
{
  	new rand = random(4);
  	new String[10000];
  	new randberat = random(100)+100;
  	SedangMancing[playerid] = 0;
  	pData[playerid][pPancingan] --;
  	if(rand == 0)
  	{
	    SendClientMessageEx(playerid, COLOR_WHITE,"FISH-INFO: Kail Anda terputus Karena Deras nya air laut.");
	    RemovePlayerAttachedObject(playerid, 0);
	    ClearAnimations(playerid);
	    TogglePlayerControllable(playerid,1);
	    return 1;
  	}
  	else if(rand == 1)
  	{
    	format(String, sizeof(String), "* Kamu mendapatkan ikan seberat {FF0000} %d gram", randberat);
	    SendClientMessageEx(playerid, COLOR_YELLOW,String);
	    pData[playerid][pBeratIkan] += randberat;
	    pData[playerid][pFMax] += 1;
	    RemovePlayerAttachedObject(playerid, 0);
    	ClearAnimations(playerid);
    	TogglePlayerControllable(playerid,1);
      	return 1;
	}
	else if(rand == 2)
	{
	    SendClientMessageEx(playerid, COLOR_WHITE,"FISH-INFO: Anda mendapatkan Jaket Bekas Lalu membuang nya.");
	    RemovePlayerAttachedObject(playerid, 0);
	    ClearAnimations(playerid);
    	TogglePlayerControllable(playerid,1);
    	return 1;
  	}
  	else if(rand == 3)
  	{
    	format(String, sizeof(String), "* Kamu mendapatkan ikan seberat {FF0000} %d gram", randberat);
      	SendClientMessageEx(playerid, COLOR_YELLOW,String);
      	pData[playerid][pBeratIkan] += randberat;
      	pData[playerid][pFMax] += 1;
      	RemovePlayerAttachedObject(playerid, 0);
    	ClearAnimations(playerid);
    	TogglePlayerControllable(playerid,1);
      	return 1;
  	}
    return 1;
}

CMD:fish(playerid, params[])
{
	if(pData[playerid][pPancingan] <= 0) 
		return Error(playerid, "Kamu tidak memiliki pancingan untuk memancing");
  	if(pData[playerid][pCacing] <= 0) 
  		return Error(playerid, "Kamu tidak memiliki umpan");
  	if(pData[playerid][pFMax] >= 5)
  		return Error(playerid,"Kamu tidak dapat membawa ikan lagi");

  	if(pData[playerid][pFTime] > 0)
  	{
      	new String[10000];
      	format(String, sizeof(String), "FISH-INFO: Kamu bisa memancing setelah %d detik lagi",pData[playerid][pFTime]);
    	SendClientMessageEx(playerid, COLOR_YELLOW,String);
    	return 1;
  	}

  	if(SedangMancing[playerid] == 1) 
  		return Error(playerid, "Anda sedang memancing.");

  	if(!IsPlayerInAnyVehicle(playerid))
  	{
    	if(IsAtFishPlace(playerid))
    	{
        	new rand = random(10);
        	new ftimer = Random(10000, 30000);
        	if(rand == 0)
        	{
          		SetTimerEx("TimeMancingRendah", ftimer, false, "i", playerid);
      		}
      		if(rand == 1)
	        {
	          	SetTimerEx("TimeMancingRendah", ftimer, false, "i", playerid);
	      	}
      		if(rand == 2)
        	{
          		SetTimerEx("TimeMancingTinggi", ftimer, false, "i", playerid);
     		}
      		if(rand == 3)
        	{
          		SetTimerEx("TimeMancingTinggi", ftimer, false, "i", playerid);
      		}
      		if(rand == 4)
        	{
          		SetTimerEx("TimeMancingTinggi", ftimer, false, "i", playerid);
      		}
      		if(rand == 5)
        	{
          		SetTimerEx("TimeMancingTengah", ftimer, false, "i", playerid);
      		}
      		if(rand == 6)
        	{
          		SetTimerEx("TimeMancingTinggi", ftimer, false, "i", playerid);
      		}
      		if(rand == 7)
        	{
          		SetTimerEx("TimeMancingTinggi", ftimer, false, "i", playerid);
      		}
      		if(rand == 8)
        	{
          		SetTimerEx("TimeMancingTinggi", ftimer, false, "i", playerid);
      		}
      		if(rand == 9)
        	{
          		SetTimerEx("TimeMancingRendah", ftimer, false, "i", playerid);
      		}
        	SedangMancing[playerid] = 1;
        	pData[playerid][pCacing] -= 1;
            TogglePlayerControllable(playerid, 0);
	    	Info(playerid, "Memulai memancing tunggu beberapa saat . .");
	    	SetPlayerAttachedObject(playerid, 0, 18632, 6, 0.00000, 0.00000, 0.00000, 0.00000, 180.00000, 90.00000, 1, 1, 1);
	   		pData[playerid][pEnergy] -= 1;
	   		pData[playerid][pHunger] -= 1;
	   		ApplyAnimation(playerid,"SWORD","sword_block",4.0,0,1,1,1,1);
       		return 1;
        }
    	else
    	{
        	Error(playerid, "Kamu tidak menaiki kapal laut/Daerah nya.");
        	return 1;
    	}
  	}	
  	return 1;
}

CMD:sellallfish(playerid,params[])
{
  	new String[10000];
  	if(pData[playerid][pBeratIkan] == 0) 
  		return Error(playerid, "Kamu tidak memiliki ikan.");

  	if(pData[playerid][pFTime] > 0)
  		return Error(playerid, "Saat ini kamu tidak dapat menjual ikan");

  	if(IsPlayerInRangeOfPoint(playerid, 7.0, 2843.66, -1516.64, 11.30) || IsPlayerInRangeOfPoint(playerid, 7.0, 359.3322,-2031.8260,7.8359))
  	{
    	format(String, sizeof(String), "Apakah kamu akan menjual ikan kamu?\n Total Berat %d Kg dengan harga $%s", pData[playerid][pBeratIkan], FormatMoney(pData[playerid][pBeratIkan] * FishPrice/2));
    	ShowPlayerDialog(playerid, DIALOG_SELL_FISH, DIALOG_STYLE_MSGBOX, "Toko Ikan", String, "Sell", "Cancel");
    	return 1;
  	}
  	else return Error(playerid, "Kamu tidak berada di sellfish point.");
}