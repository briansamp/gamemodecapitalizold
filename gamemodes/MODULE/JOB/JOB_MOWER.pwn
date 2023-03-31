//---------------- [ Mowerjack By Patrick ] ------------------//
#define mowpoint1 2051.8115,-1233.8628,23.5856
#define mowpoint2 2052.5850,-1209.4774,23.6258
#define mowpoint3 2048.9238,-1163.3545,23.3121
#define mowpoint4 2022.9722,-1170.7074,21.9110
#define mowpoint5 2007.9442,-1159.1406,21.2262
#define mowpoint6 1954.6255,-1157.4760,20.9727
#define mowpoint7 1944.0886,-1168.1492,20.7069
#define mowpoint8 1907.4731,-1148.3826,24.1436
#define mowpoint9 1912.9974,-1197.8744,20.5503
#define mowpoint10 1874.1877,-1229.7418,16.1745
#define mowpoint11 1893.4293,-1234.2031,15.2168
#define mowpoint12 1925.0219,-1221.2054,19.5785
#define mowpoint13 1947.3702,-1228.7236,19.7686
#define mowpoint14 1978.0836,-1234.4777,20.0133
#define mowpoint15 2010.3376,-1215.6193,20.3400
#define mowpoint16 2027.7722,-1230.3829,22.1260
#define mowpoint17 2030.5848,-1246.6855,23.4572

new MowerVeh[4];

AddMowerVeh()
{
	MowerVeh[0] = AddStaticVehicle(572,2052.7400,-1248.8200,23.7500,1.2000,3,3); // MowerVeh1
	MowerVeh[1] = AddStaticVehicle(572,2048.7400,-1248.8200,23.7500,1.2000,3,3); // MowerVeh2
	MowerVeh[2] = AddStaticVehicle(572,2044.7400,-1248.8200,23.7500,1.2000,3,3); // MowerVeh3
	MowerVeh[3] = AddStaticVehicle(572,2040.7400,-1248.8200,23.7500,1.2000,3,3); // MowerVeh4
}

IsAMowerVeh(carid)
{
	for(new v = 0; v < 4; v++)
	{
		if(carid == MowerVeh[v]) return 1;
	}
	return 0;
}