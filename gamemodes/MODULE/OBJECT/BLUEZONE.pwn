#define MAX_ZONES 4

new zones[MAX_ZONES];
new Bluezone;
new Float:zones_points_0[] = {
    1071.0, -1409.0, 1336.0, -1269.0 
};
new Float:zones_points_1[] = {
    1421.0, -1720.0, 1585.0, -1580.0 
};
new Float:zones_points_2[] = {
    1322.0, -1873.0, 1576.0, -1724.0 
};
new Float:zones_points_3[] = {
    1080.0, -2091.0, 1450.0, -1980.0 
};
/*new zones_text[MAX_ZONES][64] = {
    "BLUEZONE ASGH",
    "BLUEZONE SAPD",
    "BLUEZONE SAGS",
    "BLUEZONE BALAIKOTA"
};*/


public Zone_OnFilterScriptInit()
{
    print("--------------------------------------");
    print("BLUE ZONE LOADED");
    print("--------------------------------------");

    zones[0] = CreateDynamicRectangle(zones_points_0[0], zones_points_0[1], zones_points_0[2], zones_points_0[3]);
    zones[1] = CreateDynamicRectangle(zones_points_1[0], zones_points_1[1], zones_points_1[2], zones_points_1[3]);
    zones[2] = CreateDynamicRectangle(zones_points_2[0], zones_points_2[1], zones_points_2[2], zones_points_2[3]);
    zones[3] = CreateDynamicRectangle(zones_points_3[0], zones_points_3[1], zones_points_3[2], zones_points_3[3]);

    Bluezone = GangZoneCreate(-2994.0, -3001.0, 3006.0, 2999.0);
    return 1;
}

public Zone_OnPlayerEnterDynamicArea(playerid, areaid)
{
    
    for(new zone=0; zone<MAX_ZONES; zone++) 
    {
        if(areaid==zones[zone]) 
        {
            GangZoneShowForPlayer(playerid, Bluezone, 0x6666ffAA);
        }
    }
    return 1;
}

public Zone_OnPlayerLeaveDynamicArea(playerid, areaid)
{
    for(new zone=0; zone<MAX_ZONES; zone++) 
    {
        if (areaid==zones[zone])
        {
            GangZoneHideForPlayer(playerid, Bluezone);
        }
    }
}
