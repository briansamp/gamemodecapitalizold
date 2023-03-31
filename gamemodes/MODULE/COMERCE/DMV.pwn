//======== DMV ===========
#define dmvpoint1 1113.0308,-1742.9071,13.1032 //6
#define dmvpoint2 1172.6083,-1756.3083,13.1033 //2
#define dmvpoint3 1172.4963,-1828.6533,13.1026 //3
#define dmvpoint4 1315.5011,-1842.7815,13.0875 //4
#define dmvpoint5 1314.7780,-1572.8468,13.0875 //5
#define dmvpoint6 1358.8923,-1419.1207,13.0896 //6
#define dmvpoint7 1262.0618,-1388.0289,12.8597 //6
#define dmvpoint8 1195.1228,-1288.4309,13.0884 //6
#define dmvpoint9 1194.0211,-1559.2946,13.0888
#define dmvpoint10 1034.9552,-1586.8615,13.0875
#define dmvpoint11 1049.2568,-1715.0460,13.0876
#define dmvpoint12 1110.3112,-1738.5746,13.1945

/*new DmvVeh;*/

AddDmvVehicle()
{
	DmvVeh[0] = AddStaticVehicleEx(426,1099.4312, -1775.6335, 13.0493, 89.3263, 1, 3, VEHICLE_RESPAWN);
	tmpobjid = CreateDynamicObject(19482,0.0,0.0,-1000.0,0.0,0.0,0.0,-1,-1,-1,300.0,300.0);
    SetDynamicObjectMaterialText(tmpobjid, 0, "{FF0000}DMV", 120, "Ariel", 50, 1, 0, 0, 1);
    AttachDynamicObjectToVehicle(tmpobjid, DmvVeh[0], 0.002, -1.732, 0.553, 0.000, -59.499, -88.300);
}
/*AddDmvVehicle()
{
	DmvVeh[0] = AddStaticVehicleEx(547, 1237.7479,-1835.3470,12.9585, 0.0000, 1, 1, VEHICLE_RESPAWN);
	DmvVeh[1] = AddStaticVehicleEx(547, 1242.8639,-1835.7610,12.9602, 0.0000, 1, 1, VEHICLE_RESPAWN);
	DmvVeh[2] = AddStaticVehicleEx(547, 1246.7274,-1835.7286,12.9598, 0.0000, 1, 1, VEHICLE_RESPAWN);
	DmvVeh[3] = AddStaticVehicleEx(574, 2029.251, -1824.943, 13.273, 0.0000, 1, 1, VEHICLE_RESPAWN);

}*/

IsADmvVeh(carid)
{
	for(new v = 0; v < sizeof(DmvVeh); v++) {
	    if(carid == DmvVeh[v]) return 1;
	}
	return 0;
}
