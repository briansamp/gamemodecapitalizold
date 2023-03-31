#pragma warning disable 239, 214, 217, 219, 203
#pragma dynamic 5000000
#include <a_samp>
#include <sampvoice>
#undef MAX_PLAYERS
#define MAX_PLAYERS	500
#include <crashdetect.inc>
#include <gvar.inc>
#include <a_mysql.inc>
#include <a_actor.inc>
#include <a_zones.inc>
#include <CTime>
#include <discord-connector.inc>
#include <Dini>
#include <audio>
#include <progress2.inc>
#include <Pawn.CMD.inc>
#include <selection>
#include <mSelection.inc>
#include <TimestampToDate.inc>
#define ENABLE_3D_TRYG_YSI_SUPPORT
#include <streamer.inc>
#include <ColAndreas>
#include <3DTryg>
#include <VehPara>
#include <EVF2.inc>
#include <YSI\y_timers>
#include <YSI\y_iterate>
#include <sscanf2.inc>
#include <yom_buttons.inc>
#include <geoiplite.inc>
#include <garageblock.inc>
#include <timerfix.inc>
#include <discord-cmd>
#include <anti-cheat>
#include <wep-config>
#include <BustAim.inc>
#include <compat>
#include <player_geolocation.inc>
#include <NewCallbacks>
#include <map-zones>
#include <android-check>
#include <easyDialog>
#include <strlib>
#include <foreach.inc>
#include <PreviewModelDialog>

//-----[ Modular ]-----
#include "MODULE\SERVER\DEFINE.pwn"
#include "MODULE\SERVER\COLOR.pwn"
#include "MODULE\SERVER\TEXTDRAW.pwn"					
#define CONVERT_TIME_TO_SECONDS 	1
#define CONVERT_TIME_TO_MINUTES 	2
#define CONVERT_TIME_TO_HOURS 		3
#define CONVERT_TIME_TO_DAYS 		4
#define CONVERT_TIME_TO_MONTHS 		5
#define CONVERT_TIME_TO_YEARS 		6
//BUST AIM
#define BUSTAIM_MAX_PING 600
#define BUSTAIM_MAX_PL_PERCENT_ALLOWED 5
//baricade
#define MAX_BARRICADES  10
new Barricade[MAX_BARRICADES];
//
#define LIBRARY "BOMBER"
#define ANIMATION "BOM_Plant_Crouch_In"
#define AFKList 777
//taser gun
#define TASER_EFFECT_TIME 5000 // The time during which the hit player is under the effect of the taser.
#define TASER_GIVING_TIME 3000 // The time after which the taser will be given again.
#define TASER_WEAPON WEAPON_SILENCED // The weapon which will work as a taser.
#define TASER_WEAPON_SLOT 2 // The slot of the chosen weapon.
#define TASER_WEAPON_OBJECT 347 // The ID of the object of the chosen weapon.
//--- [ New Variable ] ----//
#define IPRP::%0(%1) forward %0(%1); public %0(%1)
new DmvVeh[1];
new format_string[244];
//anti spam veh
new VehicleLastEnterTime[MAX_PLAYERS],
    Warning[MAX_PLAYERS];
//taser gun
new bool:taser[MAX_PLAYERS];
new GiveTaserAgainTimer[MAX_PLAYERS];
new Float:StopaniFloats[MAX_PLAYERS][3];
new AFK[MAX_PLAYERS];
new CurGMX;
new TotalLogin, TotalConnect, TotalAutoBan, TotalRegister;
new p_tick[MAX_PLAYERS];
new p_afktime[MAX_PLAYERS];
new advertise[MAX_PLAYERS][128];
new Tax = 0;
new Terhubung[MAX_PLAYERS];
//new ConnectedToPC[MAX_PLAYERS];
//Enum GMX
forward DoGMX();
forward Zone_OnFilterScriptInit();
forward Zone_OnPlayerEnterDynamicArea(playerid, areaid);
forward Zone_OnPlayerLeaveDynamicArea(playerid, areaid);
new AimbotWarnings[MAX_PLAYERS];
//new SilentAimCount[MAX_PLAYERS],ProAimCount[MAX_PLAYERS],TintaApasata[MAX_PLAYERS];
new online;
//bank
forward BankTDHIDE(playerid);
public BankTDHIDE(playerid)
{
    HideReceipt(playerid);
	ShowBank(playerid);
    return 1;
}
new ship_enter_pickups[2];
new Text3D: ship_3d[2];

new ship_pickup;

new bool: player_ship_worked[MAX_PLAYERS];
new bool: player_ship_oil[MAX_PLAYERS];
new Float: ship_work_pos[][] =
{
	{2575.9648,-3870.1377,13.6421,88.9770}, // 1
	{2573.3079,-3870.1340,13.6421,271.6519}, // 2
	{2573.1243,-3861.8542,13.6421,268.8944}, // 3
	{2575.9102,-3861.7927,13.6421,89.0419}, // 4
	{2575.8850,-3855.5596,13.6421,89.7313}, // 5
	{2573.2952,-3855.7444,13.6421,273.0304}, // 6
	{2573.3242,-3849.3765,13.6421,270.9624}, // 7
	{2575.9053,-3849.4736,13.6421,80.7697}, // 8
	{2570.9011,-3845.3364,13.6421,8.3890}, // 9
	{2570.7744,-3842.8340,13.6421,188.0117}, // 10
	{2576.6416,-3842.7576,13.6421,180.4289}, // 11
	{2576.6160,-3845.2634,13.6421,3.1039}, // 12
	{2582.9436,-3845.3484,13.6421,0.3467}, // 13
	{2582.8818,-3842.7935,13.6421,194.4456}, // 14
	{2588.1187,-3842.6926,13.6421,184.5650}, // 15
	{2588.1221,-3845.1392,13.6421,28.5444}, // 16
	{2595.3381,-3845.2595,13.6421,355.9159}, // 17
	{2595.4141,-3842.6641,13.6421,187.3226}, // 18
	{2600.8149,-3842.8306,13.6421,220.1811}, // 18
	{2603.4011,-3845.0933,13.6421,56.8075} // 19
};

new Float: ship_oil_pos[][] =
{
    {2587.8545,-3845.6191,8.0929,355.0620}, // 20
	{2579.2722,-3845.4946,8.0929,2.4150}, // 21
	{2570.6086,-3845.3025,8.0929,1.2660} // 22
};

new ship_oil_pickups[sizeof ship_oil_pos];
new ship_work_pickups[sizeof ship_work_pos];
new ship_repair_cd[sizeof ship_work_pos];

new ship_mid_object;
new ship_pos_id = -1, ship_move_time = 0;

new Float: ship_positions[][] =
{
	//Tiba di pelabuhan
	{-2709.1870,-2709.6218,7.039000,0.0,0.0, 0.0},
	//�������� ? ����?
	{2639.0034,-2605.8933,7.039000,0.0,0.0, 90.0},

	//Posisi port
	{-2549.76758, -2663.64185, 7.039000, 0.0, 0.0, 180.0},

	{0.0, 0.0, 0.0, 0.0, 0.0, 0.0},

	//Tiba di platform
	{-2533.8271,-3658.9165,7.039000,0.0,0.0, 180.0},

	//Posisi platform
	{-2601.44775, -3798.35669, 7.039000, 0.0, 0.0, 270.00000},

	//Berhenti
	{0.0, 0.0, 0.0, 0.0, 0.0, 0.0},

	//Putar balik
	{-2784.3079,-3740.4880,7.039000,0.0,0.0, 0.0}
};

//race
enum e_race_data
{
	raceStart,
	Float:racePos1[3],
	Float:racePos2[3],
	Float:racePos3[3],
	Float:racePos4[3],
	Float:racePos5[3],
	Float:raceFinish[3],
};
new RaceData[MAX_PLAYERS][e_race_data];

//new tmpobjid;
new togtextdraws[MAX_PLAYERS];
new Text:txtAnimHelper;
enum e_TEMP_INFO
{
	pWorkSalary, //gaji
}


stock const ColorList[] = {
    0x000000FF, 0xF5F5F5FF, 0x2A77A1FF, 0x840410FF, 0x263739FF, 0x86446EFF, 0xD78E10FF, 0x4C75B7FF, 0xBDBEC6FF, 0x5E7072FF,
    0x46597AFF, 0x656A79FF, 0x5D7E8DFF, 0x58595AFF, 0xD6DAD6FF, 0x9CA1A3FF, 0x335F3FFF, 0x730E1AFF, 0x7B0A2AFF, 0x9F9D94FF,
    0x3B4E78FF, 0x732E3EFF, 0x691E3BFF, 0x96918CFF, 0x515459FF, 0x3F3E45FF, 0xA5A9A7FF, 0x635C5AFF, 0x3D4A68FF, 0x979592FF,
    0x421F21FF, 0x5F272BFF, 0x8494ABFF, 0x767B7CFF, 0x646464FF, 0x5A5752FF, 0x252527FF, 0x2D3A35FF, 0x93A396FF, 0x6D7A88FF,
    0x221918FF, 0x6F675FFF, 0x7C1C2AFF, 0x5F0A15FF, 0x193826FF, 0x5D1B20FF, 0x9D9872FF, 0x7A7560FF, 0x989586FF, 0xADB0B0FF,
    0x848988FF, 0x304F45FF, 0x4D6268FF, 0x162248FF, 0x272F4BFF, 0x7D6256FF, 0x9EA4ABFF, 0x9C8D71FF, 0x6D1822FF, 0x4E6881FF,
    0x9C9C98FF, 0x917347FF, 0x661C26FF, 0x949D9FFF, 0xA4A7A5FF, 0x8E8C46FF, 0x341A1EFF, 0x6A7A8CFF, 0xAAAD8EFF, 0xAB988FFF,
    0x851F2EFF, 0x6F8297FF, 0x585853FF, 0x9AA790FF, 0x601A23FF, 0x20202CFF, 0xA4A096FF, 0xAA9D84FF, 0x78222BFF, 0x0E316DFF,
    0x722A3FFF, 0x7B715EFF, 0x741D28FF, 0x1E2E32FF, 0x4D322FFF, 0x7C1B44FF, 0x2E5B20FF, 0x395A83FF, 0x6D2837FF, 0xA7A28FFF,
    0xAFB1B1FF, 0x364155FF, 0x6D6C6EFF, 0x0F6A89FF, 0x204B6BFF, 0x2B3E57FF, 0x9B9F9DFF, 0x6C8495FF, 0x4D8495FF, 0xAE9B7FFF,
    0x406C8FFF, 0x1F253BFF, 0xAB9276FF, 0x134573FF, 0x96816CFF, 0x64686AFF, 0x105082FF, 0xA19983FF, 0x385694FF, 0x525661FF,
    0x7F6956FF, 0x8C929AFF, 0x596E87FF, 0x473532FF, 0x44624FFF, 0x730A27FF, 0x223457FF, 0x640D1BFF, 0xA3ADC6FF, 0x695853FF,
    0x9B8B80FF, 0x620B1CFF, 0x5B5D5EFF, 0x624428FF, 0x731827FF, 0x1B376DFF, 0xEC6AAEFF, 0x000000FF, 0x177517FF, 0x210606FF,
    0x125478FF, 0x452A0DFF, 0x571E1EFF, 0x010701FF, 0x25225AFF, 0x2C89AAFF, 0x8A4DBDFF, 0x35963AFF, 0xB7B7B7FF, 0x464C8DFF,
    0x84888CFF, 0x817867FF, 0x817A26FF, 0x6A506FFF, 0x583E6FFF, 0x8CB972FF, 0x824F78FF, 0x6D276AFF, 0x1E1D13FF, 0x1E1306FF,
    0x1F2518FF, 0x2C4531FF, 0x1E4C99FF, 0x2E5F43FF, 0x1E9948FF, 0x1E9999FF, 0x999976FF, 0x7C8499FF, 0x992E1EFF, 0x2C1E08FF,
    0x142407FF, 0x993E4DFF, 0x1E4C99FF, 0x198181FF, 0x1A292AFF, 0x16616FFF, 0x1B6687FF, 0x6C3F99FF, 0x481A0EFF, 0x7A7399FF,
    0x746D99FF, 0x53387EFF, 0x222407FF, 0x3E190CFF, 0x46210EFF, 0x991E1EFF, 0x8D4C8DFF, 0x805B80FF, 0x7B3E7EFF, 0x3C1737FF,
    0x733517FF, 0x781818FF, 0x83341AFF, 0x8E2F1CFF, 0x7E3E53FF, 0x7C6D7CFF, 0x020C02FF, 0x072407FF, 0x163012FF, 0x16301BFF,
    0x642B4FFF, 0x368452FF, 0x999590FF, 0x818D96FF, 0x99991EFF, 0x7F994CFF, 0x839292FF, 0x788222FF, 0x2B3C99FF, 0x3A3A0BFF,
    0x8A794EFF, 0x0E1F49FF, 0x15371CFF, 0x15273AFF, 0x375775FF, 0x060820FF, 0x071326FF, 0x20394BFF, 0x2C5089FF, 0x15426CFF,
    0x103250FF, 0x241663FF, 0x692015FF, 0x8C8D94FF, 0x516013FF, 0x090F02FF, 0x8C573AFF, 0x52888EFF, 0x995C52FF, 0x99581EFF,
    0x993A63FF, 0x998F4EFF, 0x99311EFF, 0x0D1842FF, 0x521E1EFF, 0x42420DFF, 0x4C991EFF, 0x082A1DFF, 0x96821DFF, 0x197F19FF,
    0x3B141FFF, 0x745217FF, 0x893F8DFF, 0x7E1A6CFF, 0x0B370BFF, 0x27450DFF, 0x071F24FF, 0x784573FF, 0x8A653AFF, 0x732617FF,
    0x319490FF, 0x56941DFF, 0x59163DFF, 0x1B8A2FFF, 0x38160BFF, 0x041804FF, 0x355D8EFF, 0x2E3F5BFF, 0x561A28FF, 0x4E0E27FF,
    0x706C67FF, 0x3B3E42FF, 0x2E2D33FF, 0x7B7E7DFF, 0x4A4442FF, 0x28344EFF, 0x33FF0000
};

new color_string[3256], object_font[200];

enum E_OBJECT {
    Model,
    Name[37]
};


enum E_VEH_OBJECT {
    vehObjectID, // Untuk Menampung ID SQL Vehicle Acc
    vehObjectVehicleIndex, // Untuk mengampung ID SQL Vehicle
    vehObjectType, // Untuk menampung tipe object 
    vehObjectModel, // Untuk menampung model Object 
    vehObjectColor, // Untuk menampung warna object 

    vehObjectText[32], // Untuk menampung Text object
    vehObjectFont[24], // Untuk menampung font object
    vehObjectFontSize, // Untuk menampung size font dari si text 
    vehObjectFontColor, // Untuk menampung warna dari text 

    vehObject, // sebagai STREAMER ID object 
    
    bool:vehObjectExists, // Flagger untuk status object slot, true jika ada, false jika kosong

    Float:vehObjectPosX, // Coordinate dari object ketika attach ke kendaraan 
    Float:vehObjectPosY, // Coordinate dari object ketika attach ke kendaraan
    Float:vehObjectPosZ, // Coordinate dari object ketika attach ke kendaraan
    Float:vehObjectPosRX, // Coordinate dari object ketika attach ke kendaraan
    Float:vehObjectPosRY, // Coordinate dari object ketika attach ke kendaraan
    Float:vehObjectPosRZ // Coordinate dari object ketika attach ke kendaraan
};

new 
    VehicleObjects[MAX_PRIVATE_VEHICLE][MAX_VEHICLE_OBJECT][E_VEH_OBJECT], // Sebagai variable dari enumurator veh object
    ListedVehObject[MAX_PLAYERS][MAX_VEHICLE_OBJECT], // Untuk menyimpan index id array vehicle object ke playerid
    Player_EditingObject[MAX_PLAYERS], // Sebagai flagger untuk menandakan player sedang edit object atau tidak 
    Player_EditVehicleObject[MAX_PLAYERS], // Variable Holder
    Player_EditVehicleObjectSlot[MAX_PLAYERS] // Variable Holder
; 


new VehObject[][E_OBJECT] = 
{
    {19314,"BullHorns"},
    {1100,"Tengkorak"},
    {1013,"Lamp Round"},
    {1024,"Lamp Square"},
    {1028,"Exhaust Alien-1"},
    {1032,"Vent Alien-1"},
    {1033,"Vent X-Flow-1"},
    {1034,"Exhaust Alien-2"},
    {1035,"Vent Alien-2"},
    {1038,"Vent X-Flow-2"},
    {1099,"BullBars-1 Left"},
    {1042,"BullBars-1 Right"},
    {1046,"Exhaust Alien-2"},
    {1053,"Vent Alien-3"},
    {1054,"Vent X-Flow-3"},
    {1055,"Vent Alien-4"},
    {1061,"Vent X-Flow-4"},
    {1067,"Vent Alien-5"},
    {1068,"Vent X-Flow-5"},
    {1088,"Vent Alien-6"},
    {1091,"Vent X-Flow-6"},
    {1101,"BullBars Fire 1 Left"},
    {1106,"BullBars Stripes 1 Left"},
    {1109,"BullBars Lamp"},
    {1110,"BullBars Lamp Small"},
    {1111,"Accessories Metal 1"},
    {1112,"Accessories Metal 2"},
    {1121,"Accessories 3"},
    {1122,"BullBars Fire 2 Left"},
    {1123,"Accessories 4"},
    {1124,"BullBars Stripes 2 Left"},
    {1125,"BullBars Lamp 2"},
    {1128,"Hard Top"},
    {1130,"Medium Top"},
    {1131,"Soft Top"},
    {18659,"Vehicle Text"},
    {1025,"Wheels Offroad"},
    {1066,"Exhaust X-Flow"},
    {1065,"Exhaust Alien"},
    {1142,"Vets Left Oval"},
    {1143,"Vents Right Oval"},
    {1144,"Vents Left Square"},
    {1145,"Vents Right Square"},
    {1171,"Alien Front Bumper-1"},
    {1149,"Alien Rear Bumper-1"},
    {1023,"Spoiler Fury"},
    {1172,"X-Flow Front Bumper-1"},
    {1148,"X-Flow Rear Bumper-1"},
    {1000,"Pro Spoiler"},
    {1001,"Win Spoiler"},
    {1002,"Drag Spoiler"},
    {1003,"Alpha Spoiler"},
    {1004,"Champ Scoop Hood"},
    {1005,"Fury Scoop Hood"},
    {1006,"Roof Scoop"},
    {1007,"R-Sideskirt-TF"},
    {1011,"Race Scoop Hood"},
    {1012,"Worx Scoop Hood"},
    {1014,"Champ Spoiler"},
    {1015,"Race Spoiler"},
    {1016,"Worx Spoiler"},
    {1017,"L-Sideskirt-TF"},
    {1030,"L-Sideskirt-WAA-1"},
    {1031,"R-Sideskirt-WAA-1"},
    {1036,"R-Sideskirt-WAA-2"},
    {1039,"L-Sideskirt-WAA-3"},
    {1040,"L-Sideskirt-WAA-2"},
    {1041,"R-Sideskirt-WAA-3"},
    {1047,"R-Sideskirt-WAA-4"},
    {1048,"R-Sideskirt-WAA-5"},
    {1049,"Alien Spoiler-1"},
    {1050,"X-Flow Spoiler-1"},
    {1051,"L-Sideskirt-WAA-4"},
    {1052,"L-Sideskirt-WAA-5"},
    {1056,"R-Sideskirt-WAA-6"},
    {1057,"R-Sideskirt-WAA-7"},
    {1058,"Alien Spoiler-2"},
    {1060,"X-Flow Spoiler-2"},
    {1062,"L-Sideskirt-WAA-6"},
    {1063,"L-Sideskirt-WAA-7"},
    {1116,"F-Bullbars Slamin-1"},
    {1115,"F-Bullbars Chrome-1"},
    {1138,"Alien Spoiler-3"},
    {1139,"X-Flow Spoiler-3"},
    {1140,"X-Flow Rear Bumper-2"},
    {1141,"Alien Rear Bumper-2"},
    {1146,"X-Flow Spoiler-4"},
    {1147,"Alien Spoiler-4"},
    {1148,"X-Flow Rear Bumper-3"},
    {1149,"Alien Rear Bumper-3"},
    {1150,"Alien Rear Bumper-4"},
    {1151,"X-Flow Rear Bumper-4"},
    {1152,"X-Flow Front Bumper-4"},
    {1153,"Alien Front Bumper-4"},
    {1154,"Alien Rear Bumper-5"},
    {1155,"Alien Front Bumper-5"},
    {1156,"X-Flow Rear Bumper-5"},
    {1157,"X-Flow Front Bumper-5"},
    {1158,"X-Flow Spoiler-5"},
    {1159,"Alien Rear Bumper-6"},
    {1160,"Alien Front Bumper-6"},
    {1161,"X-Flow Rear Bumper-6"},
    {1162,"Alien Spoiler-5"},
    {1163,"X-Flow Spoiler-6"},
    {1164,"Alien Spoiler-6"},
    {1165,"X-Flow Front Bumper-7"},
    {1166,"Alien Front Bumper-7"},
    {1167,"X-Flow Rear Bumper-7"},
    {1168,"Alien Rear Bumper-7"},
    {1169,"Alien Front Bumper-2"},
    {1170,"X-Flow Front Bumper-2"},
    {1171,"Alien Front Bumper-3"},
    {1172,"X-Flow Front Bumper-3"},
    {1173,"X-Flow Front Bumper-6"},
    {1174,"Chrome Front Bumper-1"},
    {1175,"Slamin Front Bumper-1"},
    {1176,"Chrome Rear Bumper-1"},
    {1177,"Slamin Rear Bumper-1"},
    {1178,"Slamin Rear Bumper-2"},
    {1179,"Chrome Front Bumper-2"},
    {1185,"Slamin Front Bumper-3"},
    {1188,"Slamin Front Bumper-4"},
    {19308, "Taxi Sign"}
};

new const FontNames[][] = {
    "Arial",
    "Calibri",
    "Comic Sans MS",
    "Georgia",
    "Times New Roman",
    "Consolas",
    "Constantia",
    "Corbel",
    "Courier New",
    "Impact",
    "Lucida Console",
    "Palatino Linotype",
    "Tahoma",
    "Trebuchet MS",
    "Verdana",
    "Custom Font"
}; 

new bool:DialogHauling[7];
new bool:DialogSaya[MAX_PLAYERS][7];
new TrailerContainer[MAX_VEHICLES];

new pTemp[MAX_PLAYERS][e_TEMP_INFO];
// Player data
//pEnum
enum E_PLAYERS
{
	pID,
	pName[MAX_PLAYER_NAME],
	pAdminname[MAX_PLAYER_NAME],
	pIP[16],
	pPassword[65],

	pSalt[17],
	pEmail[40],
	pAdmin,
	pHelper,
	pLevel,
	pLevelUp,
	pVip,
	pVipTime,
	pGold,
	pRegDate[50],
	pLastLogin[50],
	pMoney,
	pBankMoney,
	pBankRek,
	pACWarns,
	EditingSIGNAL,
	pInGarageH,
	Float:pGarageExtX,
	Float:pGarageExtY,
	Float:pGarageExtZ,
	Float:pGarageExtA,
	PlayerBar:healtbar,
	//race
	pRaceWith,
	pRaceFinish,
	pRaceIndex,
	// WBR
	pHead,
 	pPerut,
 	pLHand,
 	pRHand,
 	pLFoot,
 	pRFoot,
	//phone
	pContact,
	pPhone,
	pPhoneOff,
	pPhoneCredit,
	pPhoneBook,
	pSMS,
	pCall,
	pCallTime,
	pEditingMode,
	pEditRoadblock,
	//--
    pAdsTime,
    pAdvertise,
	pWT,
	pHours,
	pMinutes,
	pSeconds,
	pPaycheck,
	pSkin,
	pFacSkin,
	pGender,
	pAge[50],
	pInDoor,
	pInHouse,
	pInFlat,
	pInHotel,
	pInBiz,
	pInVending,
	pInDealer,
	Float: pPosX,
	Float: pPosY,
	Float: pPosZ,
	Float: pPosA,
	pInt,
	pWorld,
	Float:pHealth,
    Float:pArmour,
	pHunger,
	pEnergy,
	pHungerTime,
	pEnergyTime,
	pSick,
	pSickTime,
	pHospital,
	pHospitalTime,
	pInjured,
	STREAMER_TAG_3D_TEXT_LABEL:pNameTag,
	STREAMER_TAG_3D_TEXT_LABEL:pInjuredLabel,
	STREAMER_TAG_3D_TEXT_LABEL:pAdoTag,
	STREAMER_TAG_3D_TEXT_LABEL:pBTag,
	Text3D:pMaskLabel,
    pSedangContainer,
    pServerModerator,
    pInFamily,
    pFillStatu,
    pFillStatus,
	//storage
	pEMoney,
	pInStorage,
	//
	//Storage1
	ST_MENU,
	ST_MONEY,
	ST_WITHDRAWMONEY,
	ST_DEPOSITMONEY,
	ST_COMPONENT,
	ST_COMPONENT2,
	ST_MATERIAL,
	ST_MATERIAL2,
	//
	pOnDuty,
	pOnDutyTime,
	pFaction,
	pFactionRank,
	pDivisi,
	pFactionLead,
	pTazer,
	pBroadcast,
	pNewsGuest,
	pFarm,
	pFarmRank,
	pFamily,
	pFamilyRank,
	pJail,
	pJailTime,
	pArrest,
	pArrestTime,
	pWarn,
	pJob,
	pJob2,
	pExitJob,
	pMedicine,
	pParacetamol,
	pAmoxicilin,
	pAntasida,
	pMedkit,
	pMask,
	pFightStyle,
	pGymVip,
	pFitnessTimer,
	pFitnessType,
	pBorax,
	pGetBorax,
	pPaketBorax,
	pProsesBorax,
	pRedMoney,
	pSeatBelt,
	pHelmet,
	pSnack,
	pSprunk,
	pTrash,
	pBerry,
	pGas,
	pBandage,
	pGPS,
	pMaterial,
	pComponent,
	pFood,
	pFrozenPizza,
	//pedagang
	pNugget,
	pBurger,
	pTeh,
	//garage
	pGarage,
	//========
	pSeed,
	pPotato,
	pWheat,
	pOrange,
	pPrice1,
	pPrice2,
	pPrice3,
	pPrice4,
	pMarijuana,
	pPlant,
	pPlantTime,
	//FISH
	pPancingan,
	pCacing,
	pFMax,
	pBeratIkan,
	pFTime,
	//
	pIDCard,
	pIDCardTime,
	pLicBiz,
	pLicBizTime,
	pSkck,
	pSkckTime,
	pPenebangs,
	pPenebangsTime,
	pBpjs,
	pBpjsTime,
	pSpack,
	pDriveLic,
	pDriveLicTime,
	//trucker
	pTruckerLic,
	pTruckerLicTime,
	//
	pSekolahSim,
	pBoatLic,
	pBoatLicTime,
	pFlyLic,
	pFlyLicTime,
	pGuns[13],
    pAmmo[13],
	pWeapon,
	pBoombox,
	//Not Save
	Cache:Cache_ID,
	bool: IsLoggedIn,
	LoginAttempts,
	LoginTimer,
	pSpawned,
	pAdminDuty,
	pFreezeTimer,
	pFreeze,
	pMaskID,
	pMaskOn,
	pSPY,
	pTname[MAX_PLAYER_NAME],
	pTweet,
	pTogTweet,
	pTogPM,
	pToggleAtm,
	pToggleWT,
	pTogLog,
	pTogAds,
	pTogWT,
	pTogReports,
	pTogDamage,
	pUsingWT,
	// Suspect
 	pSuspectTimer,
 	pSuspect,
	//Text3D:pAdoTag,
	bool:pAdoActive,
	pFlare,
	bool:pFlareActive,
	pTrackCar,
	pBuyPvModel,
	pTrackHouse,
	pTrackFlat,
	pTrackHotel,
	pTrackBisnis,
	pFacInvite,
	pFacOffer,
	pFamInvite,
	pFamOffer,
	pFarmInvite,
	pFarmOffer,
	pFindEms,
	pCuffed,
	toySelected,
	TEditStatus,
	bool:PurchasedToy,
	pEditingItem,
	pProductModify,
	pEditingVendingItem,
	pVendingProductModify,
	pCurrSeconds,
	pCurrMinutes,
	pCurrHours,
	pSpec,
	playerSpectated,
	pInspectOffer,
	Float:pBodyCondition[6],
	pStockBodyCondition[6],
	pFriskOffer,
	pDragged,
	pDraggedBy,
	pDragTimer,
	pHBEMode,
	pTDMode,
	pHelmetOn,
	pReportTime,
	pAskTime,
	//Player Progress Bar
	PlayerBar:fuelbar,
	PlayerBar:damagebar,
	PlayerBar:hungrybar,
	PlayerBar:energybar,
	PlayerBar:BarHp,
	PlayerBar:BarArmour,
	PlayerBar:activitybar,
	pProducting,
	pCooking,
	pArmsDealer,
	pReload,
	pMechanicStatus,
	pMechanic,
	pActivity,
	pActivityTime,
	//Delay sidejob
	pSweeperTime,
	pBusTime,
	pForkliftTime,
	pPizzaTime,
	//Jobs
	pSideJob,
	pSideJobTime,
	pJobTime,
	pGetJob,
	pGetJob2,
	pTaxiDuty,
	pTaxiTime,
	pFare,
	pFareTimer,
	pTotalFare,
	Float:pFareOldX,
	Float:pFareOldY,
	Float:pFareOldZ,
	Float:pFareNewX,
	Float:pFareNewY,
	Float:pFareNewZ,
	pMechDuty,
	pMechVeh,
	pMechColor1,
	pMechColor2,
	//ATM
	EditingATMID,
	//Graffity
	EditingGraffity,
	// Vending
	EditingVending,
	//Vehicle Toys
	EditingVtoys,
	//Limit Speed
	Float:pLimitSpeed,
	LimitSpeedTimer,
	pLsVehicle,
	//lumber job
	EditingTreeID,
	CuttingTreeID,
	bool:CarryingLumber,
	//Berry Farmers
	EditingBerryID,
	HarvestBerryID,
	
	pMenuType,
	pInWs,
	pTransferWS,
	//Miner job
	EditingOreID,
	MiningOreID,
	CarryingLog,
	LoadingPoint,
	//production
	CarryProduct,
	//trucker
	pMission,
	pDealerMission,
	pHauling,
	pRestock,
	//Farmer
	pHarvest,
	pHarvestID,
	pOffer,
	//Smuggler
	pSmugglerTimer,
	pPacket,
	//Bank
	pTransfer,
	pTransferRek,
	pTransferName[128],
	//pemotong ayam
	timerambilayamhidup,
    timerpotongayam,
    timerpackagingayam,
    timerjualayam,
    AyamHidup,
	AyamPotong,
	AyamFillet,
	sedangambilayam,
    sedangpotongayam,
    sedangfilletayam,
    sedangjualayam,
    //cleaning
    pCleanTime,
    pCleanSkill,
    pCleanTools,
	//Gas Station
	pFill,
	pFillTime,
	pFillPrice,
	//Gate
	gEditID,
	gEdit,
	// WBR
	//pHead,
 	//pPerut,
 	//pLHand,
 	//pRHand,
 	//pLFoot,
 	//pRFoot,
	// Garkot
	pPark,
	pLoc,
    pTrailer,
	//Workshop
	//pWsEmplooye,
	pWsVeh,
	pWorkshop,
    pWorkInvite,
    pWorkshopRank,
    pWorkOffer,
    pWsEmplooye,
	//auto rp
	pSavedRp[70],
	//Skill
	pTruckSkill,
	pMechSkill,
	pSmuggSkill,
	//train skill
	pSilincedSkill,
  	pDesertEagleSkill,
  	pRifleSkill,
  	pShotgunSkill,
  	pSpassSkill,
  	pMP5Skill,
  	pAK47Skill,
  	pM4Skill,
  	pSniperSkill,
  	pTrainingTime,
    pAsk,
    pAskQ,
	//Vehicle Toys
	EditStatus,
	VehicleID
	//
};
new pData[MAX_PLAYERS][E_PLAYERS];



//-----[ eSelection Define ]-----	
#define 	SPAWN_SKIN_MALE 		1
#define 	SPAWN_SKIN_FEMALE 		2
#define 	SHOP_SKIN_MALE 			3
#define 	SHOP_SKIN_FEMALE 		4
#define 	VIP_SKIN_MALE 			5
#define 	VIP_SKIN_FEMALE 		6
#define 	SAPD_SKIN_MALE 			7
#define 	SAPD_SKIN_FEMALE 		8
#define 	SAPD_SKIN_WAR 			9
#define 	SAGS_SKIN_MALE 			10
#define 	SAGS_SKIN_FEMALE 		11
#define 	SAMD_SKIN_MALE 			12
#define 	SAMD_SKIN_FEMALE 		13
#define 	SANA_SKIN_MALE 			14
#define 	SANA_SKIN_FEMALE 		15
#define 	TOYS_MODEL 				16
#define 	VIPTOYS_MODEL 			17

new SpawnSkinMale[] =
{
	1, 2, 3, 4, 5, 6, 7, 14, 100, 299
};

new SpawnSkinFemale[] =
{
	9, 10, 11, 12, 13, 31, 38, 39, 40, 41
};

new ShopSkinMale[] =
{
	1, 2, 3, 4, 5, 6, 7, 8, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 32, 33,
	34, 35, 36, 37, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 57, 58, 59, 60, 61, 62, 66, 68, 72, 73,
	78, 79, 80, 81, 82, 83, 84, 94, 95, 96, 97, 98, 99, 100, 101, 102, 103, 104, 105, 106, 107, 108, 109,
	110, 111, 112, 113, 114, 115, 116, 117, 118, 119, 120, 121, 122, 123, 124, 125, 126, 127, 128, 132, 133,
	134, 135, 136, 137, 142, 143, 144, 146, 153, 154, 156, 158, 159, 160, 161, 162, 167, 168, 170,
	171, 173, 174, 175, 176, 177, 179, 180, 181, 182, 183, 184, 185, 186, 188, 189, 190, 200, 202, 203,
	204, 206, 208, 209, 210, 212, 213, 217, 220, 221, 222, 223, 228, 229, 230, 234, 235, 236, 239, 240, 241,
	242, 247, 248, 249, 250, 253, 254, 255, 258, 259, 260, 261, 262, 268, 272, 273, 289, 290, 291, 292, 293,
	294, 296, 297, 299
};

new ShopSkinFemale[] =
{
	9, 10, 11, 12, 13, 31, 38, 39, 40, 41, 53, 54, 55, 56, 63, 64, 65, 69, 75, 76, 77, 85, 88, 89, 90, 91, 92,
	93, 129, 130, 131, 138, 140, 141, 145, 148, 150, 151, 152, 157, 169, 178, 190, 191, 192, 193, 194, 195, 196,
	197, 198, 199, 201, 205, 207, 211, 214, 215, 216, 219, 224, 225, 226, 231, 232, 233, 237, 238, 243, 244, 245,
	246, 251, 256, 257, 263, 298
};

new SAPDSkinWar[] =
{
	121, 285, 286, 287, 117, 118, 165, 166
};

new SAPDSkinMale[] =
{
	280, 281, 282, 283, 284, 288, 300, 301, 302, 303, 304, 305, 310, 311, 165, 166, 265, 266, 267
};

new SAPDSkinFemale[] =
{
	306, 307, 309, 148, 150
};

new SAGSSkinMale[] =
{
	171, 17, 71, 147, 187, 165, 166, 163, 164, 255, 295, 294, 303, 304, 305, 189, 253
};

new SAGSSkinFemale[] =
{
	9, 11, 76, 141, 150, 219, 169, 172, 194, 263
};

new SAMDSkinMale[] =
{
	70, 187, 303, 304, 305, 274, 275, 276, 277, 278, 279, 165, 71, 177
};

new SAMDSkinFemale[] =
{
	308, 76, 141, 148, 150, 169, 172, 194, 219
};

new SANASkinMale[] =
{
	171, 187, 189, 240, 303, 304, 305, 20, 59
};

new SANASkinFemale[] =
{
	172, 194, 211, 216, 219, 233, 11, 9
};

new ToysModel[] =
{
	19006, 19007, 19008, 19009, 19010, 19011, 19012, 19013, 19014, 19015, 19016, 19017, 19018, 19019, 19020, 19021, 19022,
	19023, 19024, 19025, 19026, 19027, 19028, 19029, 19030, 19031, 19032, 19033, 19034, 19035, 19801, 18891, 18892, 18893,
	18894, 18895, 18896, 18897, 18898, 18899, 18900, 18901, 18902, 18903, 18904, 18905, 18906, 18907, 18908, 18909, 18910,
	18911, 18912, 18913, 18914, 18915, 18916, 18917, 18918, 18919, 18920, 19036, 19037, 19038, 19557, 11704, 19472, 18974,
	19163, 19064, 19160, 19352, 19528, 19330, 19331, 18921, 18922, 18923, 18924, 18925, 18926, 18927, 18928, 18929, 18930,
	18931, 18932, 18933, 18934, 18935, 18939, 18940, 18941, 18942, 18943, 18944, 18945, 18946, 18947, 18948, 18949, 18950,
	18951, 18953, 18954, 18960, 18961, 19098, 19096, 18964, 18967, 18968, 18969, 19106, 19113, 19114, 19115, 18970, 18638,
	19553, 19558, 19554, 18971, 18972, 18973, 19101, 19116, 19117, 19118, 19119, 19120, 18952, 18645, 19039, 19040, 19041,
	19042, 19043, 19044, 19045, 19046, 19047, 19053, 19421, 19422, 19423, 19424, 19274, 19518, 19077, 19517, 19317, 19318,
	19319, 19520, 1550, 19592, 19621, 19622, 19623, 19624, 19625, 19626, 19555, 19556, 19469, 19085, 19559, 19904, 19942, 
	19944, 11745, 19773, 18639, 18640, 18641, 18635, 18633, 3028, 11745, 19142
};

new VipToysModel[] =
{
	19006, 19007, 19008, 19009, 19010, 19011, 19012, 19013, 19014, 19015, 19016, 19017, 19018, 19019, 19020, 19021, 19022,
	19023, 19024, 19025, 19026, 19027, 19028, 19029, 19030, 19031, 19032, 19033, 19034, 19035, 19801, 18891, 18892, 18893,
	18894, 18895, 18896, 18897, 18898, 18899, 18900, 18901, 18902, 18903, 18904, 18905, 18906, 18907, 18908, 18909, 18910,
	18911, 18912, 18913, 18914, 18915, 18916, 18917, 18918, 18919, 18920, 19036, 19037, 19038, 19557, 11704, 19472, 18974,
	19163, 19064, 19160, 19352, 19528, 19330, 19331, 18921, 18922, 18923, 18924, 18925, 18926, 18927, 18928, 18929, 18930,
	18931, 18932, 18933, 18934, 18935, 18939, 18940, 18941, 18942, 18943, 18944, 18945, 18946, 18947, 18948, 18949, 18950,
	18951, 18953, 18954, 18960, 18961, 19098, 19096, 18964, 18967, 18968, 18969, 19106, 19113, 19114, 19115, 18970, 18638,
	19553, 19558, 19554, 18971, 18972, 18973, 19101, 19116, 19117, 19118, 19119, 19120, 18952, 18645, 19039, 19040, 19041,
	19042, 19043, 19044, 19045, 19046, 19047, 19053, 19421, 19422, 19423, 19424, 19274, 19518, 19077, 19517, 19317, 19318,
	19319, 19520, 1550, 19592, 19621, 19622, 19623, 19624, 19625, 19626, 19555, 19556, 19469, 19085, 19559, 19904, 19942, 
	19944, 11745, 19773, 18639, 18640, 18641, 18635, 18633, 3028, 11745, 19142
};

new VipSkinMale[] =
{
	1, 2, 3, 4, 5, 6, 7, 8, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 32, 33,
	34, 35, 36, 37, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 57, 58, 59, 60, 61, 62, 66, 68, 72, 73,
	78, 79, 80, 81, 82, 83, 84, 94, 95, 96, 97, 98, 99, 100, 101, 102, 103, 104, 105, 106, 107, 108, 109,
	110, 111, 112, 113, 114, 115, 116, 117, 118, 119, 120, 121, 122, 123, 124, 125, 126, 127, 128, 132, 133,
	134, 135, 136, 137, 142, 143, 144, 146, 147, 153, 154, 155, 156, 158, 159, 160, 161, 162, 167, 168, 170,
	171, 173, 174, 175, 176, 177, 179, 180, 181, 182, 183, 184, 185, 186, 187, 188, 189, 190, 200, 202, 203,
	204, 206, 208, 209, 210, 212, 213, 217, 220, 221, 222, 223, 228, 229, 230, 234, 235, 236, 239, 240, 241,
	242, 247, 248, 249, 250, 253, 254, 255, 258, 259, 260, 261, 262, 268, 272, 273, 289, 290, 291, 292, 293,
	294, 295, 296, 297, 299
};

new VipSkinFemale[] =
{
	9, 10, 11, 12, 13, 31, 38, 39, 40, 41, 53, 54, 55, 56, 63, 64, 65, 69, 75, 76, 77, 85, 88, 89, 90, 91, 92,
	93, 129, 130, 131, 138, 140, 141, 145, 148, 150, 151, 152, 157, 169, 178, 190, 191, 192, 193, 194, 195, 196,
	197, 198, 199, 201, 205, 207, 211, 214, 215, 216, 219, 224, 225, 226, 231, 232, 233, 237, 238, 243, 244, 245,
	246, 251, 256, 257, 263, 298
};





// MySQL connection handle
new MySQL: g_SQL;
new g_MysqlRaceCheck[MAX_PLAYERS];

enum    AsuKoe
{
	SKM
};
new Global[AsuKoe];

//DIALOG
enum
{
    //DEALER
	DIALOG_BUYJOBCARSVEHICLE,
	DIALOG_BUYDEALERCARS_CONFIRM,
	DIALOG_BUYTRUCKVEHICLE,
	DIALOG_BUYMOTORCYCLEVEHICLE,
	DIALOG_BUYUCARSVEHICLE,
	DIALOG_BUYCARSVEHICLE,
	DIALOG_DEALER_MANAGE,
	DIALOG_DEALER_VAULT,
	DIALOG_DEALER_WITHDRAW,
	DIALOG_DEALER_DEPOSIT,
	DIALOG_DEALER_NAME,
	DIALOG_DEALER_RESTOCK,
    Dialog_Advertisements,
	//
	DIALOG_STORAGE_RM,
	S_RM_WT,
	S_RM_DP,
	S_WEAPONS,
	DIALOG_STORAGE_MENU,
	DIALOG_STORAGE_M,
	DIALOG_S_WITHDRAW,
	DIALOG_S_DEPOSIT,
	DIALOG_STORAGE_MRJ,
	S_MRJ_WT,
	S_MRJ_DP,
	DIALOG_STORAGE_CMP,
	S_CMP_WT,
	S_CMP_DP,
	DIALOG_STORAGE_MTR,
	S_MTR_WT,
	S_MTR_DP,
    //CONTAINER
    DIALOG_CONTAINER,
    DIALOG_MYVEH,
    DIALOG_MYVEH_INFO,
    //Vending
	DIALOG_VENDING_BUYPROD,
	DIALOG_VENDING_MANAGE,
	DIALOG_VENDING_NAME,
	DIALOG_VENDING_VAULT,
	DIALOG_VENDING_WITHDRAW,
	DIALOG_VENDING_DEPOSIT,
	DIALOG_VENDING_EDITPROD,
	DIALOG_VENDING_PRICESET,
	DIALOG_VENDING_RESTOCK,
    //REPORT
    DIALOG_REPORTS,
    DIALOG_TRACKDEALER,
	//
	DIALOG_MY_WS,
	DIALOG_TRACKWS,
	WS_MENU,
	WS_SETNAME,
	WS_SETOWNER,
	WS_SETEMPLOYE,
	WS_SETEMPLOYEE,
	WS_SETOWNERCONFIRM,
	WS_SETMEMBER,
	WS_SETMEMBERE,
	WS_MONEY,
	WS_WITHDRAWMONEY,
	WS_DEPOSITMONEY,
	WS_COMPONENT,
	WS_COMPONENT2,
	WS_MATERIAL,
	WS_MATERIAL2,
	//tes
	DIALOG_NGENTOD,
	DIALOG_CHANGELOGS,
	DIALOG_ADMIN_SIGNAL,
	//---[ DIALOG PUBLIC ]---
	DIALOG_UNUSED,
    DIALOG_LOGIN,
    DIALOG_REGISTER,
    DIALOG_AGE,
	DIALOG_GENDER,
	DIALOG_EMAIL,
	DIALOG_PASSWORD,
	DIALOG_STATS,
	DIALOG_SETTINGS,
	DIALOG_HBEMODE,
	DIALOG_TDMODE,
	DIALOG_CHANGEAGE,
	//-----------------------
	DIALOG_GOLDSHOP,
	DIALOG_GOLDNAME,
	//---[ DIALOG BISNIS ]---
	DIALOG_SELL_BISNISS,
	DIALOG_SELL_BISNIS,
	DIALOG_SEALED,
	DIALOG_UNSEALED,
	DIALOG_MY_BISNIS,
	BISNIS_MENU,
	BISNIS_INFO,
	BISNIS_NAME,
	BISNIS_VAULT,
	BISNIS_WITHDRAW,
	BISNIS_DEPOSIT,
	BISNIS_BUYPROD,
	BISNIS_EDITPROD,
	BISNIS_PRICESET,
	BISNIS_SONG,
	BISNIS_PH,
	//--[Dialog Graffity]--
	DIALOG_WELCOME,
	DIALOG_SELECT,
	DIALOG_INPUTGRAFF,
	DIALOG_COLOR,
	DIALOG_HAPPY,
	DIALOG_LIST,
	BUY_SPRAYCAN,
	DIALOG_GOMENU,
	DIALOG_GDOBJECT,
	//---[ DIALOG HOUSE ]---
	DIALOG_SELL_HOUSES,
	DIALOG_SELL_HOUSE,
	DIALOG_MY_HOUSES,
	HOUSE_INFO,
	HOUSE_STORAGE,
	HOUSE_WEAPONS,
	HOUSE_MONEY,
	HOUSE_WITHDRAWMONEY,
	HOUSE_DEPOSITMONEY,
	//---[ DIALOG FLAT ]---
	DIALOG_SELL_FLATS,
	DIALOG_SELL_FLAT,
	DIALOG_MY_FLATS,
	FLAT_INFO,
	FLAT_STORAGE,
	FLAT_WEAPONS,
	FLAT_MONEY,
	FLAT_WITHDRAWMONEY,
	FLAT_DEPOSITMONEY,

	//Dv2
    DIALOG_CDEDIT,
    DIALOG_CDNEWVEH,
    DIALOG_CDEDITCARS,
    DIALOG_CDUPGRADE,
    DIALOG_VEH_SPAWN,
    DIALOG_CDTILL,
	DIALOG_CDCHANGETYPE,
	DIALOG_CDEDITONE,
	DIALOG_CDEDITMODEL,
	DIALOG_CDEDITCOST,
	DIALOG_CDEDITPARK,
	DIALOG_CDDELVEH,
	DIALOG_CDRADIUS,
	DIALOG_CDNAME,
	DIALOG_CDPRICE,
	DIALOG_CDBUY,
	DIALOG_CDWITHDRAW,
	DIALOG_CDDEPOSIT,
	DIALOG_CDSELL,

	//---[ DIALOG HOTEL ]---
	DIALOG_SELL_HOTELS,
	DIALOG_SELL_HOTEL,
	DIALOG_MY_HOTELS,
	HOTEL_INFO,
	HOTEL_STORAGE,
	HOTEL_WEAPONS,
	HOTEL_MONEY,
	HOTEL_WITHDRAWMONEY,
	HOTEL_DEPOSITMONEY,
	//GARAGE
	DIALOG_GARAGE,
	DIALOG_GARAGEOWNER,
	//garage
	DIALOG_GARAGETAKE,
	DIALOG_GARAGENAME,
	DIALOG_GARAGEFEE,
	//DIALOG_GARAGEOWNER,
	//---[ DIALOG PRIVATE VEHICLE ]---
	DIALOG_FINDVEH,
	DIALOG_TRACKVEH,
	DIALOG_GOTOVEH,
	DIALOG_GETVEH,
	DIALOG_DELETEVEH,
	DIALOG_BUYPV,
	DIALOG_BUYVIPPV,
	DIALOG_BUYPLATE,
	DIALOG_BUYPVCP,
	DIALOG_BUYPVCP_BIKES,
	DIALOG_BUYPVCP_CARS,
	DIALOG_BUYPVCP_UCARS,
	DIALOG_BUYPVCP_JOBCARS,
	DIALOG_BUYPVCP_VIPCARS,
	DIALOG_BUYPVCP_CONFIRM,
	DIALOG_BUYPVS_CONFIRM,
	DIALOG_BUYBOAT_CONFIRM,
	DIALOG_BUYPVCP_VIPCONFIRM,
	DIALOG_RENT_JOBCARS,
	DIALOG_RENT_JOBCARSCONFIRM,
	DIALOG_RADIO_SONG,
	DIALOG_RADIO_SERVER,
	//garkot
	DIALOG_PICKUPVEH,
	//FACTION GARAGE
	DIALOG_FACTION,
	DIALOG_FACTION1,
	DIALOG_FACTION2,
	DIALOG_FACTION3,
	//job
	LIST_JOB,
	//---[ DIALOG TOYS ]---
	//Vehicle Toys
	DIALOG_VTOY,
	DIALOG_VTOYBUY,
	DIALOG_VTOYEDIT,
	DIALOG_VTOYPOSX,
	DIALOG_VTOYPOSY,
	DIALOG_VTOYPOSZ,
	DIALOG_VTOYPOSRX,
	DIALOG_VTOYPOSRY,
	DIALOG_VTOYPOSRZ,
	VSELECT_POS,
	VTOYSET_VALUE,
	VTOYSET_COLOUR,
	VTOY_ACCEPT,
	//Player Toys
	DIALOG_TOY,
	DIALOG_TOYEDIT,
	DIALOG_TOYPOSISI,
	DIALOG_TOYPOSISIBUY,
	DIALOG_TOYBUY,
	DIALOG_TOYVIP,
	DIALOG_TOYPOSX,
	DIALOG_TOYPOSY,
	DIALOG_TOYPOSZ,
	DIALOG_TOYPOSRX,
	DIALOG_TOYPOSRY,
	DIALOG_TOYPOSRZ,
 	DIALOG_SCALEX,
 	DIALOG_SCALEY,
  	DIALOG_SCALEZ,
  	TSELECT_POS,
  	TOYSET_VALUE,
  	//butcher
  	D_WORK,
    D_WORK_INFO,
    //cctv
    d_Cam,
    d_Camhelp,
    //UPDATE DIALOG
    DIALOG_UPDATED,
	DIALOG_UPDATE,
	DIALOG_UE,
	DIALOG_U,
	//---[ DIALOG PLAYER ]---
	DIALOG_HELP,
	DIALOG_JOBHELP,
	DIALOG_GPS,
	DIALOG_GPS_FACTION,
	DIALOG_GPS_PROPERTY,
	DIALOG_GPS_PUBLIC,
	DIALOG_GPS_DEALERSHIP,
	DIALOG_GPS_TRUCKER,
	DIALOG_FIND_DEALER,
	DIALOG_FIND_BISNIS,
	DIALOG_FIND_ATM,
	DIALOG_FIND_TREES,
	DIALOG_GPS_JOB,
	DIALOG_PAY,
	DIALOG_TAKEHAULING,
	DIALOG_DYNAMICLIST,
	//---[ DIALOG WEAPONS ]---
	DIALOG_EDITBONE,
	//---[ DIALOG FAMILY ]---
	FAMILY_SAFE,
	FAMILY_STORAGE,
	FAMILY_WEAPONS,
	FAMILY_MARIJUANA,
	FAMILY_WITHDRAWMARIJUANA,
	FAMILY_DEPOSITMARIJUANA,
	FAMILY_COMPONENT,
	FAMILY_WITHDRAWCOMPONENT,
	FAMILY_DEPOSITCOMPONENT,
	FAMILY_MATERIAL,
	FAMILY_WITHDRAWMATERIAL,
	FAMILY_DEPOSITMATERIAL,
	FAMILY_MONEY,
	FAMILY_WITHDRAWMONEY,
	FAMILY_DEPOSITMONEY,
	FAMILY_INFO,
	BUSINESS_SETCARGO,
	//---[ DIALOG OWN FARM ]---
	FARM_STORAGE,
	FARM_INFO,
	FARM_POTATO,
	FARM_WHEAT,
	FARM_ORANGE,
	FARM_MONEY,
	FARM_DEPOSITPOTATO,
	FARM_WITHDRAWPOTATO,
	FARM_DEPOSITWHEAT,
	FARM_WITHDRAWWHEAT,
	FARM_DEPOSITORANGE,
	FARM_WITHDRAWORANGE,
	FARM_DEPOSITMONEY,
	FARM_WITHDRAWMONEY,
	//---[ DIALOG FACTION ]---
	DIALOG_LOCKERSAPD,
	DIALOG_WEAPONSAPD,
	DIALOG_LOCKERSAGS,
	DIALOG_WEAPONSAGS,
	DIALOG_LOCKERSAMD,
	DIALOG_WEAPONSAMD,
	DIALOG_LOCKERSANEW,
	DIALOG_WEAPONSANEW,
	DIALOG_LOCKERGOJEK,
	DIALOG_LOCKERPEDAGANG,
    DIALOG_LOCKTIRE,

	DIALOG_LOCKERVIP,
	//---[ DIALOG JOB ]---
	DIALOG_MOWER,
	DIALOG_AYAM,
	//MECH
	DIALOG_SERVICE,
	DIALOG_UPGRADE,
	DIALOG_SERVICE_COLOR,
	DIALOG_SERVICE_COLOR2,
	DIALOG_SERVICE_PAINTJOB,
	DIALOG_SERVICE_WHEELS,
	DIALOG_SERVICE_SPOILER,
	DIALOG_SERVICE_HOODS,
	DIALOG_SERVICE_VENTS,
	DIALOG_SERVICE_LIGHTS,
	DIALOG_SERVICE_EXHAUSTS,
	DIALOG_SERVICE_FRONT_BUMPERS,
	DIALOG_SERVICE_REAR_BUMPERS,
	DIALOG_SERVICE_ROOFS,
	DIALOG_SERVICE_SIDE_SKIRTS,
	DIALOG_SERVICE_BULLBARS,
	DIALOG_SERVICE_NEON,
	//Trucker
	DIALOG_HAULING,
	DIALOG_RESTOCK,
	//DIALOG_CONTAINER,

	//ARMS Dealer
	DIALOG_ARMS_GUN,
	DIALOG_ARMS_AMMO,
	DIALOG_ARMS_MEGAZINE,

	//FISH DIALOG
	DIALOG_SELL_FISH,

	//Farmer job
	DIALOG_PLANT,
	DIALOG_EDIT_PRICE,
	DIALOG_EDIT_PRICE1,
	DIALOG_EDIT_PRICE2,
	DIALOG_EDIT_PRICE3,
	DIALOG_EDIT_PRICE4,
	DIALOG_OFFER,
	//----[ Items ]-----
	DIALOG_MATERIAL,
	DIALOG_COMPONENT,
	DIALOG_DRUGS,
	DIALOG_FOOD,
	DIALOG_FOOD_BUY,
	DIALOG_SEED_BUY,
	DIALOG_PRODUCT,
	DIALOG_GASOIL,
	DIALOG_APOTEK,
	//Bank
	DIALOG_ATM,
	DIALOG_ATMWITHDRAW,
	DIALOG_BANK,
	DIALOG_BANKDEPOSIT,
	DIALOG_BANKWITHDRAW,
	DIALOG_BANKREKENING,
	DIALOG_BANKTRANSFER,
	DIALOG_BANKCONFIRM,
	DIALOG_BANKSUKSES,
	//ask
	DIALOG_ASKS,

	//reports
	//DIALOG_REPORTS,
	DIALOG_SALARY,
	DIALOG_PAYCHECK,
	BUGGED,

	//Sidejob
	DIALOG_TRASH,
	DIALOG_PIZZA,
	DIALOG_SWEEPER,
	DIALOG_BUS,
	DIALOG_FORKLIFT,
	// WBR
	DIALOG_HEALTH,
	DIALOG_MEDICINE,
	//DMV
	DIALOG_DMV1,
	DIALOG_DMV2,
	DIALOG_DMV3,
	//hauling tr
	//DIALOG_CHAULINGTR,
	//DIALOG_BUYTRUCK_CONFIRM,
	//DIALOG_HAULINGTR,

	DIALOG_PB,

	//gym
	DIALOG_FSTYLE,
	DIALOG_GMENU,
	//mods
	DIALOG_MMENU,
	//box
	DIALOG_TDC,
	DIALOG_TDC_PLACE,

	//dialogdamage
	//DIALOG_UNUSED,

	//event
	DIALOG_TDM,
    //DIALOG_LOCKTIRE,

	//veh control
	DIALOG_VC,
	//startjob
	DIALOG_WORK,
	//Phone
	DIALOG_ENTERNUM,
	NEW_CONTACT,
	CONTACT_INFO,
	CONTACT,
	DIAL_NUMBER,
	TEXT_MESSAGE,
	SEND_TEXT,
	SHARE_LOC,
	MY_PHONE,
	TWEET_APP,
	WHATSAPP_APP,
	TWEET_SIGNUP,
	TWEET_CHANGENAME,
	TWEET_ACCEPT_CHANGENAME,
	DIALOG_TWEETMODE,
	PHONE_NOTIF,
	PHONE_APP,
	//trunk
	TRUNK_STORAGE,
	TRUNK_WEAPONS,
	TRUNK_MONEY,
	TRUNK_COMP,
	TRUNK_MATS,
	TRUNK_WITHDRAWMONEY,
	TRUNK_DEPOSITMONEY,
	TRUNK_WITHDRAWCOMP,
	TRUNK_DEPOSITCOMP,
	TRUNK_WITHDRAWMATS,
	TRUNK_DEPOSITMATS,
	//mech
	DIALOG_MECH_LEVEL,

	//MDC
	DIALOG_TRACK,
	DIALOG_TRACK_PH,
	DIALOG_CHECK_NAME,

	//setfreq
	DIALOG_SETFREQ,

	DIALOG_INFO_BIS,
	DIALOG_INFO_HOUSE,
	DIALOG_INFO_FLAT,
	DIALOG_INFO_HOTEL,

	//training
	TRAININGSKILL,
	DIALOG_BARRICADE,

	DIALOG_INSURANCE,
	DIALOG_MY_WORKSHOP,
    WORKSHOP_SAFE,
	WORKSHOP_INFO,
    DIALOG_WORKSHOPSELL,
	
	//bb
	DIALOG_BOOMBOX,
	DIALOG_BOOMBOX1,
}
//---[New]---
//DISCORD BOT
//new DCC_Channel:g_Discord_AndroVerifed;
//new DCC_Channel:g_Discord_adslogs;
new DCC_Guild: serverguild;
new DCC_Channel:g_Discord_PcVerived;
new DCC_Channel:g_Discord_Information;
new DCC_Channel:g_discord_paylogs;
new DCC_Channel:g_discord_twt;
new DCC_Channel:g_discord_logs;
new DCC_Channel:g_discord_admins;
new DCC_Channel:g_discord_ban;
new DCC_Channel:g_discord_kill;
new DCC_Channel:inchanel;
new DCC_Channel:ucp;
new DCC_Channel:acss;
new DCC_Channel:register;
//TDM
new EventCreated = 0, EventStarted = 0, EventPrize = 500;
new Float: RedX, Float: RedY, Float: RedZ, EventInt, EventWorld;
new Float: BlueX, Float: BlueY, Float: BlueZ;
new EventHP = 100, EventArmour = 0, EventLocked = 0;
new EventWeapon1, EventWeapon2, EventWeapon3, EventWeapon4, EventWeapon5;
new BlueTeam = 0, RedTeam = 0;
new MaxRedTeam = 5, MaxBlueTeam = 5;
new IsAtEvent[MAX_PLAYERS];
//Digital Healt - Armour
new Text:DigiHP[MAX_PLAYERS];
new Text:DigiAP[MAX_PLAYERS];

new Text:Cent[2];

//OTHER
new kick_gTimer[MAX_PLAYERS];

//editing
enum    _:E_EDITING_TYPE {
    NOTHING = 0,
    ROADBLOCK
}

//area index
enum
{
    INVALID_AREA_INDEX = 0,
    BARRICADE_AREA_INDEX,
    //FIRE_AREA_INDEX
};

//ROB
new InRob[MAX_PLAYERS];
//BUTCHER
new playerobject[MAX_PLAYERS][2];
new meatsp;
new StoreMeat[MAX_PLAYERS];

//FISH
new SedangMancing[MAX_PLAYERS];

//PILOT
new WorkBucks = 5000;
//new Penality = -650;

#define PH_D        4834
new TakingPs[MAX_PLAYERS] = 2;
///////////////CHECKPOINTS || LANDING OR TAKING////////////
new Float:RandomCPs[][3] =
{
	{1678.4602,-2625.2407,13.1195},   //LS
	{-1275.9586,10.1346,15.5220},   //SF
	{1347.2815,1281.2484,12.1943}, //LV
	{394.8399,2509.7869,17.8583}  //Desert
};
new rands;
new rands2;

new cp[MAX_PLAYERS];
new GaragePickup[8];

new Text3D:MaskLabel[MAX_PLAYERS];

/////////VEHICLES || PLANES ////////////

new pilotvehs[9] =
{ 460, 511, 512, 513, 519, 553, 577, 592, 593 };

////////////////////////////////////////

//HAULING TRAILER
//new bool:DialogHauling[10];
new TrailerHauling[MAX_PLAYERS];
new SedangHauling[MAX_PLAYERS];
//new bool:DialogSaya[MAX_PLAYERS][10];

//[------ BACK FIRE ------]
enum ENUM_FIRE_INFO
{
	bool:fire_VALID,
	bool:fire_MIRROR,
	Float:fire_OFFSET_X,
	Float:fire_OFFSET_Y,
	Float:fire_OFFSET_Z,
	Float:fire_ROT_X,
	Float:fire_ROT_Y,
	Float:fire_ROT_Z
};
new FIRE_INFO[][ENUM_FIRE_INFO] =
{
	{true, false, 0.356599, -2.323499, -2.282700, 0.000000, 0.000000, 180.000000}, //400
	{true, false, 0.438600, -2.509499, -2.088700, 0.000000, 0.000000, 180.000000}, //401
	{true, true, 0.502600, -2.623499, -2.136700, 0.000000, 0.000000, 180.000000}, //402
	{false, false, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000}, //403
	{true, false, 0.452600, -2.679299, -2.057499, 0.000000, 0.000000, 180.000000}, //404
	{true, false, 0.484899, -2.694099, -2.203500, 0.000000, 0.000000, 180.000000}, //405
	{false, false, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000}, //406
	{false, false, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000}, //407
	{false, false, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000}, //408
	{true, false, 0.613099, -3.776700, -2.107199, 0.000000, 0.000000, 180.000000}, //409
	{true, false, 0.393799, -2.313999, -2.057199, 0.000000, 0.000000, 180.000000}, //410
	{true, true, 0.307799, -2.537999, -2.083199, 0.000000, 0.000000, 180.000000}, //411
	{true, false, 0.427300, -3.339999, -2.165199, 0.000000, 0.000000, 180.000000}, //412
	{false, false, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000}, //413
	{true, false, 0.516099, -3.160899, -2.317199, 0.000000, 0.000000, 180.000000}, //414
	{true, true, 0.378100, -2.368799, -2.103199, 0.000000, 0.000000, 180.000000}, //415
	{true, false, 0.504199, -3.720499, -2.407199, 0.000000, 0.000000, 180.000000}, //416
	{false, false, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000}, //417
	{true, false, 0.574599, -2.647899, -2.439199, 0.000000, 0.000000, 180.000000}, //418
	{true, false, 0.558099, -2.929099, -2.161200, 0.000000, 0.000000, 180.000000}, //419
	{true, false, 0.574100, -2.639099, -2.137199, 0.000000, 0.000000, 180.000000}, //420
	{true, false, 0.450100, -2.983999, -2.191200, 0.000000, 0.000000, 180.000000}, //421
	{true, false, 0.411700, -2.547899, -2.334000, 0.000000, 0.000000, 180.000000}, //422
	{true, false, -0.369800, -2.315999, -2.404000, 0.000000, 0.000000, 180.000000}, //423
	{true, true, 0.512099, -1.669300, -1.856099, 0.000000, 0.000000, 180.000000}, //424
	{false, false, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000}, //425
	{true, false, 0.578000, -2.621899, -2.136100, 0.000000, 0.000000, 180.000000}, //426
	{true, false, 0.601499, -3.878599, -2.324200, 0.000000, 0.000000, 180.000000}, //427
	{true, false, 0.588999, -2.971599, -2.462199, 0.000000, 0.000000, 180.000000}, //428
	{true, true, 0.503000, -2.523599, -1.965199, 0.000000, 0.000000, 180.000000}, //429
	{false, false, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000}, //430
	{false, false, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000}, //431
	{false, false, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000}, //432
	{false, false, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000}, //433
	{false, false, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000}, //434
	{false, false, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000}, //435
	{true, false, 0.486999, -2.497599, -2.099299, 0.000000, 0.000000, 180.000000}, //436
	{false, false, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000}, //437
	{true, false, 0.490399, -2.705899, -2.371700, 0.000000, 0.000000, 180.000000}, //438
	{true, true, 0.352400, -2.581899, -2.064399, 0.000000, 0.000000, 180.000000}, //439
	{true, false, 0.420700, -2.677599, -2.570899, 0.000000, 0.000000, 180.000000}, //440
	{false, false, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000}, //441
	{true, false, 0.593100, -2.798699, -2.205100, 0.000000, 0.000000, 180.000000}, //442
	{false, false, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000}, //443
	{false, false, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000}, //444
	{true, false, 0.480199, -2.714699, -2.147099, 0.000000, 0.000000, 180.000000}, //445
	{false, false, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000}, //446
	{false, false, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000}, //447
	{false, false, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000}, //448
	{false, false, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000}, //449
	{false, false, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000}, //450
	{true, false, 0.005400, -2.552699, -1.987100, 0.000000, 0.000000, 180.000000}, //451
	{false, false, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000}, //452
	{false, false, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000}, //453
	{false, false, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000}, //454
	{false, false, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000}, //455
	{false, false, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000}, //456
	{false, false, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000}, //457
	{true, false, 0.519200, -2.790499, -2.229899, 0.000000, 0.000000, 180.000000}, //458
	{false, false, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000}, //459
	{false, false, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000}, //460
	{false, false, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000}, //461
	{false, false, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000}, //462
	{false, false, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000}, //463
	{false, false, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000}, //464
	{false, false, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000}, //465
	{true, false, 0.435200, -2.877399, -2.125900, 0.000000, 0.000000, 180.000000}, //466
	{true, false, 0.481200, -2.917399, -2.097899, 0.000000, 0.000000, 180.000000}, //467
	{false, false, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000}, //468
	{false, false, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000}, //469
	{true, false, -1.250200, -2.029500, -0.472800, 0.000000, 0.000000, 180.000000}, //470
	{false, false, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000}, //471
	{false, false, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000}, //472
	{false, false, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000}, //473
	{true, true, 0.584999, -2.822599, -2.209800, 0.000000, 0.000000, 180.000000}, //474
	{true, false, 0.481000, -2.595699, -2.113800, 0.000000, 0.000000, 180.000000}, //475
	{false, false, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000}, //476
	{true, false, 0.587000, -2.805699, -2.071799, 0.000000, 0.000000, 180.000000}, //477
	{true, false, 0.416700, -2.568699, -2.196799, 0.000000, 0.000000, 180.000000}, //478
	{true, false, 0.460799, -2.865999, -2.082799, 0.000000, 0.000000, 180.000000}, //479
	{true, false, 0.483300, -2.409999, -2.163700, 0.000000, 0.000000, 180.000000}, //480
	{false, false, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000}, //481
	{true, false, 0.445899, -2.641699, -2.439800, 0.000000, 0.000000, 180.000000}, //482
	{true, false, -0.340600, -2.846899, -2.512400, 0.000000, 0.000000, 180.000000}, //483
	{false, false, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000}, //484
	{false, false, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000}, //485
	{false, false, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000}, //486
	{false, false, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000}, //487
	{false, false, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000}, //488
	{true, false, 0.446500, -2.771499, -2.240900, 0.000000, 0.000000, 180.000000}, //489
	{true, false, 0.439999, -3.227299, -2.240900, 0.000000, 0.000000, 180.000000}, //490
	{true, false, 0.572200, -2.925899, -2.166899, 0.000000, 0.000000, 180.000000}, //491
	{true, false, 0.579599, -2.606400, -2.116899, 0.000000, 0.000000, 180.000000}, //492
	{false, false, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000}, //493
	{false, false, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000}, //494
	{true, false, 0.596599, -2.335199, -2.332799, 0.000000, 0.000000, 180.000000}, //495
	{true, false, 0.545400, -2.173599, -2.111700, 0.000000, 0.000000, 180.000000}, //496
	{false, false, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000}, //497
	{true, false, -0.473800, -3.108199, -2.361400, 0.000000, 0.000000, 180.000000}, //498
	{true, false, 0.516200, -3.340600, -2.287400, 0.000000, 0.000000, 180.000000}, //499
	{true, false, 0.446900, -1.940299, -2.245399, 0.000000, 0.000000, 180.000000}, //500
	{false, false, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000}, //501
	{false, false, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000}, //502
	{false, false, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000}, //503
	{true, false, 0.430299, -2.876699, -2.117300, 0.000000, 0.000000, 180.000000}, //504
	{true, false, 0.446299, -2.772699, -2.236900, 0.000000, 0.000000, 180.000000}, //505
	{true, true, 0.560599, -2.476300, -2.120100, 0.000000, 0.000000, 180.000000}, //506
	{true, false, 0.485199, -2.971699, -2.262000, 0.000000, 0.000000, 180.000000}, //507
	{true, false, 0.467400, -3.586999, -2.686900, 0.000000, 0.000000, 180.000000}, //508
	{false, false, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000}, //509
	{false, false, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000}, //510
	{false, false, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000}, //511
	{false, false, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000}, //512
	{false, false, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000}, //513
	{false, false, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000}, //514
	{false, false, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000}, //515
	{true, false, 0.447800, -2.946699, -2.141499, 0.000000, 0.000000, 180.000000}, //516
	{true, false, 0.501800, -2.858699, -2.119499, 0.000000, 0.000000, 180.000000}, //517
	{true, false, -0.423400, -2.882499, -2.091500, 0.000000, 0.000000, 180.000000}, //518
	{false, false, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000}, //519
	{false, false, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000}, //520
	{false, false, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000}, //521
	{false, false, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000}, //522
	{false, false, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000}, //523
	{false, false, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000}, //524
	{false, false, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000}, //525
	{true, false, 0.481799, -2.314099, -2.129499, 0.000000, 0.000000, 180.000000}, //526
	{true, false, 0.471799, -2.298099, -1.999199, 0.000000, 0.000000, 180.000000}, //527
	{false, false, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000}, //528
	{true, false, -0.424699, -2.729899, -2.011199, 0.000000, 0.000000, 180.000000}, //529
	{false, false, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000}, //530
	{false, false, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000}, //531
	{false, false, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000}, //532
	{true, true, 0.515100, -2.452399, -2.037100, 0.000000, 0.000000, 180.000000}, //533
	{true, true, 0.483099, -2.958400, -2.167099, 0.000000, 0.000000, 180.000000}, //534
	{true, true, 0.350600, -2.693499, -2.189100, 0.000000, 0.000000, 180.000000}, //535
	{true, true, 0.500000, -2.971299, -2.161099, 0.000000, 0.000000, 180.000000}, //536
	{false, false, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000}, //537
	{false, false, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000}, //538
	{false, false, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000}, //539
	{true, false, -0.410600, -2.748699, -2.265599, 0.000000, 0.000000, 180.000000}, //540
	{true, true, 0.624000, -2.205999, -1.875100, 0.000000, 0.000000, 180.000000}, //541
	{true, false, 0.587400, -2.829499, -1.996899, 0.000000, 0.000000, 180.000000}, //542
	{true, false, -0.411000, -2.764599, -2.099200, 0.000000, 0.000000, 180.000000}, //543
	{false, false, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000}, //544
	{true, true, 0.314900, -2.263700, -2.260600, 0.000000, 0.000000, 180.000000}, //545
	{true, false, 0.581200, -2.833499, -2.020299, 0.000000, 0.000000, 180.000000}, //546
	{true, false, 0.629199, -2.589499, -2.074300, 0.000000, 0.000000, 180.000000}, //547
	{false, false, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000}, //548
	{true, false, 0.441300, -2.511600, -2.030299, 0.000000, 0.000000, 180.000000}, //549
	{true, false, -0.628300, -2.899799, -2.267199, 0.000000, 0.000000, 180.000000}, //550
	{true, false, 0.590799, -3.145499, -2.092799, 0.000000, 0.000000, 180.000000}, //551
	{true, false, 0.446900, -3.063399, -1.924800, 0.000000, 0.000000, 180.000000}, //552
	{false, false, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000}, //553
	{true, false, 0.559300, -2.751999, -2.208499, 0.000000, 0.000000, 180.000000}, //554
	{true, true, 0.136000, -2.282899, -2.003200, 0.000000, 0.000000, 180.000000}, //555
	{false, false, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000}, //556
	{false, false, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000}, //557
	{true, true, 0.465799, -2.558699, -1.977200, 0.000000, 0.000000, 180.000000}, //558
	{true, true, 0.633099, -2.394599, -1.977200, 0.000000, 0.000000, 180.000000}, //559
	{true, true, 0.479999, -2.474699, -1.991199, 0.000000, 0.000000, 180.000000}, //560
	{true, true, 0.446200, -2.739599, -2.166300, 0.000000, 0.000000, 180.000000}, //561
	{true, true, 0.483300, -2.380199, -2.037100, 0.000000, 0.000000, 180.000000}, //562
	{false, false, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000}, //563
	{false, false, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000}, //564
	{true, false, 0.479299, -2.134199, -1.999099, 0.000000, 0.000000, 180.000000}, //565
	{true, false, 0.564700, -2.946699, -2.063100, 0.000000, 0.000000, 180.000000}, //566
	{true, false, 0.628700, -2.776700, -2.252900, 0.000000, 0.000000, 180.000000}, //567
	{false, false, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000}, //568
	{false, false, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000}, //569
	{false, false, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000}, //570
	{false, false, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000}, //571
	{false, false, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000}, //572
	{false, false, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000}, //573
	{false, false, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000}, //574
	{true, false, 0.453399, -2.709800, -1.975300, 0.000000, 0.000000, 180.000000}, //575
	{true, false, 0.658100, -3.092499, -2.043299, 0.000000, 0.000000, 180.000000}, //576
	{false, false, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000}, //577
	{false, false, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000}, //578
	{true, false, -0.424600, -2.890699, -2.102699, 0.000000, 0.000000, 180.000000}, //579
	{true, false, -0.408600, -2.872699, -2.092700, 0.000000, 0.000000, 180.000000}, //580
	{false, false, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000}, //581
	{true, false, 0.444999, -3.395499, -2.334199, 0.000000, 0.000000, 180.000000}, //582
	{false, false, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000}, //583
	{false, false, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000}, //584
	{true, false, -0.428999, -3.143299, -1.889299, 0.000000, 0.000000, 180.000000}, //585
	{false, false, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000}, //586
	{true, true, 0.698000, -2.692600, -2.056400, 0.000000, 0.000000, 180.000000}, //587
	{false, false, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000}, //588
	{true, false, 0.583999, -2.358599, -1.965899, 0.000000, 0.000000, 180.000000}, //589
	{false, false, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000}, //590
	{false, false, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000}, //591
	{false, false, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000}, //592
	{false, false, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000}, //593
	{false, false, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000}, //594
	{false, false, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000}, //595
	{true, false, 0.577000, -2.622299, -2.138499, 0.000000, 0.000000, 180.000000}, //596
	{true, false, 0.577000, -2.622299, -2.138499, 0.000000, 0.000000, 180.000000}, //597
	{true, false, 0.595000, -2.678299, -2.002500, 0.000000, 0.000000, 180.000000}, //598
	{true, false, 0.440600, -2.773699, -2.239099, 0.000000, 0.000000, 180.000000}, //599
	{true, false, 0.442600, -2.763700, -2.054199, 0.000000, 0.000000, 180.000000}, //600
	{false, false, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000}, //601
	{true, true, 0.560999, -2.523999, -2.200700, 0.000000, 0.000000, 180.000000}, //602
	{true, true, 0.587000, -2.661999, -2.192699, 0.000000, 0.000000, 180.000000}, //603
	{true, false, 0.425700, -2.877099, -2.124700, 0.000000, 0.000000, 180.000000}, //604
	{true, false, -0.411900, -2.767699, -2.098700, 0.000000, 0.000000, 180.000000}, //605
	{false, false, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000}, //606
	{false, false, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000}, //607
	{false, false, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000}, //608
	{true, false, -0.477699, -3.106199, -2.359499, 0.000000, 0.000000, 180.000000}, //609
	{false, false, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000}, //610
	{false, false, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000} //611
};

new
	bool:Player_Fire_Enabled[MAX_PLAYERS],
	Player_Key_Sprint_Time[MAX_PLAYERS];
// Countdown
new Count = -1;
new countTimer;
new showCD[MAX_PLAYERS];
new CountText[5][5] =
{
	"~r~1",
	"~g~2",
	"~y~3",
	"~g~4",
	"~b~5"
};

// Server Uptime
new up_days,
	up_hours,
	up_minutes,
	up_seconds,
	WorldTime = 10,
	WorldWeather = 24;

//Model Selection
new SpawnMale = mS_INVALID_LISTID,
	SpawnFemale = mS_INVALID_LISTID,
	MaleSkins = mS_INVALID_LISTID,
	FemaleSkins = mS_INVALID_LISTID,
	VIPMaleSkins = mS_INVALID_LISTID,
	VIPFemaleSkins = mS_INVALID_LISTID,
	SAPDMale = mS_INVALID_LISTID,
	SAPDFemale = mS_INVALID_LISTID,
	SAPDWar = mS_INVALID_LISTID,
	SAGSMale = mS_INVALID_LISTID,
	SAGSFemale = mS_INVALID_LISTID,
	SAMDMale = mS_INVALID_LISTID,
	SAMDFemale = mS_INVALID_LISTID,
	SANEWMale = mS_INVALID_LISTID,
	SANEWFemale = mS_INVALID_LISTID,
	GOJEKMale = mS_INVALID_LISTID,
	GOJEKFemale = mS_INVALID_LISTID,
	PEDAGANGMale = mS_INVALID_LISTID,
	PEDAGANGFemale = mS_INVALID_LISTID,
	toyslist = mS_INVALID_LISTID,
	rentjoblist = mS_INVALID_LISTID,
	sportcar = mS_INVALID_LISTID,
	boatlist = mS_INVALID_LISTID,
	viptoyslist = mS_INVALID_LISTID,
	vtoylist = mS_INVALID_LISTID;


// Faction Vehicle
#define VEHICLE_RESPAWN 7200

new SAPDVehicles[30],
	SAGSVehicles[30],
	SAMDVehicles[30],
	SANAVehicles[30],
	GOJEKVehicles[30];

//flash for pd
#define flashtime 115
new Flash[MAX_VEHICLES];
new FlashTime[MAX_VEHICLES];

// Faction Vehicle
IsSAPDCar(carid)
{
	for(new v = 0; v < sizeof(SAPDVehicles); v++)
	{
	    if(carid == SAPDVehicles[v]) return 1;
	}
	return 0;
}

IsGovCar(carid)
{
	for(new v = 0; v < sizeof(SAGSVehicles); v++)
	{
	    if(carid == SAGSVehicles[v]) return 1;
	}
	return 0;
}

IsSAMDCar(carid)
{
	for(new v = 0; v < sizeof(SAMDVehicles); v++)
	{
	    if(carid == SAMDVehicles[v]) return 1;
	}
	return 0;
}

IsSANACar(carid)
{
	for(new v = 0; v < sizeof(SANAVehicles); v++)
	{
	    if(carid == SANAVehicles[v]) return 1;
	}
	return 0;
}
IsGOJEKCar(carid)
{
	for(new v = 0; v < sizeof(GOJEKVehicles); v++)
	{
	    if(carid == GOJEKVehicles[v]) return 1;
	}
	return 0;
}

//Showroom Checkpoint
new ShowRoomS,
	ShowRoomCPRent;

new BoatDealer;

// Yom Button
new SAGSLobbyBtn[2],
	SAGSLobbyDoor,
	SAPDLobbyBtn[4],
	SAPDLobbyDoor[4],
	LLFLobbyBtn[2],
	SAPDWeaponBtn,
	SAPDWeaponDoor,
	LLFLobbyDoor;

new TogOOC = 1;

//----------[ Lumber Object Vehicle Job ]------------
#define MAX_LUMBERS 50
#define LUMBER_LIFETIME 100
#define LUMBER_LIMIT 10

enum    E_LUMBER
{
	// temp
	lumberDroppedBy[MAX_PLAYER_NAME],
	lumberSeconds,
	lumberObjID,
	lumberTimer,
	Text3D: lumberLabel
}
new LumberData[MAX_LUMBERS][E_LUMBER],
	Iterator:Lumbers<MAX_LUMBERS>;

new
	LumberObjects[MAX_VEHICLES][LUMBER_LIMIT];

new
	Float: LumberAttachOffsets[LUMBER_LIMIT][4] = {
	    {-0.223, -1.089, -0.230, -90.399},
		{-0.056, -1.091, -0.230, 90.399},
		{0.116, -1.092, -0.230, -90.399},
		{0.293, -1.088, -0.230, 90.399},
		{-0.123, -1.089, -0.099, -90.399},
		{0.043, -1.090, -0.099, 90.399},
		{0.216, -1.092, -0.099, -90.399},
		{-0.033, -1.090, 0.029, -90.399},
		{0.153, -1.089, 0.029, 90.399},
		{0.066, -1.091, 0.150, -90.399}
	};
new hydr[6];
enum E_HYDR_DATA
{
	H_NAME[120],
	Float: H_BAWAH[6],
	Float: H_ATAS[6],
};
new h_hydr[6][E_HYDR_DATA] =
{
	{"Hydraulic 1\nType {34C924}/Hydraulic {ffffff}Or {34C924}/DHydraulic", {2193.24243, -2199.99780, 10.96290,   0.00000, 0.00000, 44.40000}, {2193.24243, -2199.99780, 11.52890,   0.33300, 0.00000, 44.40000}},
	{"Hydraulic 2\nType {34C924}/Hydraulic {ffffff}Or {34C924}/DHydraulic", {2199.55225, -2193.81885, 10.96290,   0.00000, 0.00000, 44.40000}, {2199.55225, -2193.81885, 11.52890,   0.00000, 0.00000, 44.40000}},
	{"Hydraulic 3\nType {34C924}/Hydraulic {ffffff}Or {34C924}/DHydraulic", {2186.67017, -2206.51807, 10.96290,   0.00000, 0.00000, 44.04000}, {2186.67017, -2206.51807, 11.52890,   0.00000, 0.00000, 44.04000}},
	{"Hydraulic 4\nType {34C924}/Hydraulic {ffffff}Or {34C924}/DHydraulic", {2201.54321, -2237.80566, 10.88290,   0.00000, 0.00000, -136.98000}, {2201.49927, -2237.76465, 11.46490,   0.00000, 0.00000, -136.98000}},
	{"Hydraulic 5\nType {34C924}/Hydraulic {ffffff}Or {34C924}/DHydraulic", {2208.19092, -2231.78809, 10.86690,   0.00000, 0.00000, -136.98000}, {2208.19092, -2231.78809, 11.43290,   0.00000, 0.00000, -136.98000}},
	{"Hydraulic 6\nType {34C924}/Hydraulic {ffffff}Or {34C924}/DHydraulic", {2214.58667, -2225.68530, 10.85890,   0.00000, 0.00000, -136.98000}, {2214.59106, -2225.65747, 11.42490,   0.00000, 0.00000, -136.98000}}
};

//---- [ Function ]----//

ShowDialogToPlayer(playerid, dialogid)
{
	    switch(dialogid)
	    {
	        case DIALOG_BANKWITHDRAW:
			{
                new mstr[512];
			    format(mstr, sizeof(mstr), "{F6F6F6}You have "LB_E"%s {F6F6F6}in your bank account.\n\nType in the amount you want to withdraw below:", FormatMoney(pData[playerid][pBankMoney]));
			    ShowPlayerDialog(playerid, DIALOG_BANKWITHDRAW, DIALOG_STYLE_INPUT, ""LB_E"Bank", mstr, "Withdraw", "Cancel");
			}
	        case DIALOG_BANKDEPOSIT:
			{
			    new mstr[512];
			    format(mstr, sizeof(mstr), "{F6F6F6}You have "LB_E"%s {F6F6F6}in bank account.\n\nType in the amount you want to deposit below:", FormatMoney(pData[playerid][pBankMoney]));
			    ShowPlayerDialog(playerid, DIALOG_BANKDEPOSIT, DIALOG_STYLE_INPUT, ""LB_E"Bank", mstr, "Deposit", "Cancel");
			}
			case DIALOG_BANKREKENING:
			{
				ShowPlayerDialog(playerid, DIALOG_BANKREKENING, DIALOG_STYLE_INPUT, ""LB_E"Bank", "Input Number Of The Money:", "Transfer", "Cancel");
			}
		}
	    return 1;
}

stock ShowBank(playerid)
{
    PlayerTextDrawShow(playerid, BankTD[playerid][0]);
    PlayerTextDrawShow(playerid, BankTD[playerid][1]);
    PlayerTextDrawShow(playerid, BankTD[playerid][2]);
    PlayerTextDrawShow(playerid, BankTD[playerid][3]);
	PlayerTextDrawShow(playerid, BankTD[playerid][4]);
    PlayerTextDrawShow(playerid, BankTD[playerid][5]);
    PlayerTextDrawShow(playerid, BankTD[playerid][6]);
    PlayerTextDrawShow(playerid, BankTD[playerid][7]);
    PlayerTextDrawShow(playerid, BankTD[playerid][8]);
    PlayerTextDrawShow(playerid, BankTD[playerid][9]);
    PlayerTextDrawShow(playerid, BankTD[playerid][10]);
    PlayerTextDrawShow(playerid, BankTD[playerid][11]);
    PlayerTextDrawShow(playerid, BankTD[playerid][12]);
    PlayerTextDrawShow(playerid, BankTD[playerid][13]);
    PlayerTextDrawShow(playerid, BankTD[playerid][14]);
    PlayerTextDrawShow(playerid, BankTD[playerid][15]);
    PlayerTextDrawShow(playerid, BankTD[playerid][16]);
    PlayerTextDrawShow(playerid, BankTD[playerid][17]);
    PlayerTextDrawShow(playerid, BankTD[playerid][18]);
    PlayerTextDrawShow(playerid, BankTD[playerid][19]);
    PlayerTextDrawShow(playerid, BankTD[playerid][20]);
    PlayerTextDrawShow(playerid, BankTD[playerid][21]);
    PlayerTextDrawShow(playerid, BankTD[playerid][22]);
    PlayerTextDrawShow(playerid, BankTD[playerid][23]);
    PlayerTextDrawShow(playerid, BankTD[playerid][24]);
    PlayerTextDrawShow(playerid, BankTD[playerid][25]);
    PlayerTextDrawShow(playerid, BankTD[playerid][26]);
    PlayerTextDrawShow(playerid, BankTD[playerid][27]);
    PlayerTextDrawShow(playerid, BankTD[playerid][28]);
    PlayerTextDrawShow(playerid, BankTD[playerid][29]);
    PlayerTextDrawShow(playerid, BankTD[playerid][30]);
    PlayerTextDrawShow(playerid, BankTD[playerid][31]);
    PlayerTextDrawShow(playerid, BankTD[playerid][32]);
    PlayerTextDrawShow(playerid, BankTD[playerid][33]);
    PlayerTextDrawShow(playerid, BankTD[playerid][34]);
    PlayerTextDrawShow(playerid, BankTD[playerid][35]);
    PlayerTextDrawShow(playerid, BankTD[playerid][36]);
    PlayerTextDrawShow(playerid, BankTD[playerid][37]);
    return 1;
}

stock HideBank(playerid)
{
    PlayerTextDrawHide(playerid, BankTD[playerid][0]);
    PlayerTextDrawHide(playerid, BankTD[playerid][1]);
    PlayerTextDrawHide(playerid, BankTD[playerid][2]);
    PlayerTextDrawHide(playerid, BankTD[playerid][3]);
	PlayerTextDrawHide(playerid, BankTD[playerid][4]);
    PlayerTextDrawHide(playerid, BankTD[playerid][5]);
    PlayerTextDrawHide(playerid, BankTD[playerid][6]);
    PlayerTextDrawHide(playerid, BankTD[playerid][7]);
    PlayerTextDrawHide(playerid, BankTD[playerid][8]);
    PlayerTextDrawHide(playerid, BankTD[playerid][9]);
    PlayerTextDrawHide(playerid, BankTD[playerid][10]);
    PlayerTextDrawHide(playerid, BankTD[playerid][11]);
    PlayerTextDrawHide(playerid, BankTD[playerid][12]);
    PlayerTextDrawHide(playerid, BankTD[playerid][13]);
    PlayerTextDrawHide(playerid, BankTD[playerid][14]);
    PlayerTextDrawHide(playerid, BankTD[playerid][15]);
    PlayerTextDrawHide(playerid, BankTD[playerid][16]);
    PlayerTextDrawHide(playerid, BankTD[playerid][17]);
    PlayerTextDrawHide(playerid, BankTD[playerid][18]);
    PlayerTextDrawHide(playerid, BankTD[playerid][19]);
    PlayerTextDrawHide(playerid, BankTD[playerid][20]);
    PlayerTextDrawHide(playerid, BankTD[playerid][21]);
    PlayerTextDrawHide(playerid, BankTD[playerid][22]);
    PlayerTextDrawHide(playerid, BankTD[playerid][23]);
    PlayerTextDrawHide(playerid, BankTD[playerid][24]);
    PlayerTextDrawHide(playerid, BankTD[playerid][25]);
    PlayerTextDrawHide(playerid, BankTD[playerid][26]);
    PlayerTextDrawHide(playerid, BankTD[playerid][27]);
    PlayerTextDrawHide(playerid, BankTD[playerid][28]);
    PlayerTextDrawHide(playerid, BankTD[playerid][29]);
    PlayerTextDrawHide(playerid, BankTD[playerid][30]);
    PlayerTextDrawHide(playerid, BankTD[playerid][31]);
    PlayerTextDrawHide(playerid, BankTD[playerid][32]);
    PlayerTextDrawHide(playerid, BankTD[playerid][33]);
    PlayerTextDrawHide(playerid, BankTD[playerid][34]);
    PlayerTextDrawHide(playerid, BankTD[playerid][35]);
    PlayerTextDrawHide(playerid, BankTD[playerid][36]);
    PlayerTextDrawHide(playerid, BankTD[playerid][37]);
    return 1;
}
stock ShowReceipt(playerid)
{
    PlayerTextDrawShow(playerid, BankReceiptTD[playerid][0]);
    PlayerTextDrawShow(playerid, BankReceiptTD[playerid][1]);
    PlayerTextDrawShow(playerid, BankReceiptTD[playerid][2]);
    PlayerTextDrawShow(playerid, BankReceiptTD[playerid][3]);
	PlayerTextDrawShow(playerid, BankReceiptTD[playerid][4]);
    PlayerTextDrawShow(playerid, BankReceiptTD[playerid][5]);
    PlayerTextDrawShow(playerid, BankReceiptTD[playerid][6]);
    PlayerTextDrawShow(playerid, BankReceiptTD[playerid][7]);
    return 1;
}

stock HideReceipt(playerid)
{
    PlayerTextDrawHide(playerid, BankReceiptTD[playerid][0]);
    PlayerTextDrawHide(playerid, BankReceiptTD[playerid][1]);
    PlayerTextDrawHide(playerid, BankReceiptTD[playerid][2]);
    PlayerTextDrawHide(playerid, BankReceiptTD[playerid][3]);
	PlayerTextDrawHide(playerid, BankReceiptTD[playerid][4]);
    PlayerTextDrawHide(playerid, BankReceiptTD[playerid][5]);
    PlayerTextDrawHide(playerid, BankReceiptTD[playerid][6]);
    PlayerTextDrawHide(playerid, BankReceiptTD[playerid][7]);
    return 1;
}
stock ShowBank1(playerid)
{
    PlayerTextDrawShow(playerid, BankT[playerid][0]);
    PlayerTextDrawShow(playerid, BankT[playerid][1]);
    PlayerTextDrawShow(playerid, BankT[playerid][2]);
    PlayerTextDrawShow(playerid, BankT[playerid][3]);
	PlayerTextDrawShow(playerid, BankT[playerid][4]);
    PlayerTextDrawShow(playerid, BankT[playerid][5]);
    PlayerTextDrawShow(playerid, BankT[playerid][6]);
    PlayerTextDrawShow(playerid, BankT[playerid][7]);
    return 1;
}

stock HideBank1(playerid)
{
    PlayerTextDrawHide(playerid, BankT[playerid][0]);
    PlayerTextDrawHide(playerid, BankT[playerid][1]);
    PlayerTextDrawHide(playerid, BankT[playerid][2]);
    PlayerTextDrawHide(playerid, BankT[playerid][3]);
	PlayerTextDrawHide(playerid, BankT[playerid][4]);
    PlayerTextDrawHide(playerid, BankT[playerid][5]);
    PlayerTextDrawHide(playerid, BankT[playerid][6]);
    PlayerTextDrawHide(playerid, BankT[playerid][7]);
    return 1;
}
forward ShowPanggilanMasuk(ii);
public ShowPanggilanMasuk(ii)
{
	for(new i =0 ; i < 18; i++)
	{
		PlayerTextDrawShow(ii, PHANGKAT[i][ii]);
	}
	SendClientMessageEx(ii, COLOR_PINK, "[CELLPHONE form %d] "WHITE_E"Your phonecell is ringing, type '/cursor' and press green button to answer it!", pData[ii][pPhone]);
	return 1;
}
forward ShowMemanggil(playerid);
public ShowMemanggil(playerid)
{
	for(new i =0 ; i < 18; i++)
	{
		PlayerTextDrawShow(playerid, PHANGKAT[i][playerid]);
	}
	new tstr[128];
	format(tstr, sizeof(tstr), "Berdering..");
	PlayerTextDrawSetString(playerid, BERDERING[playerid], tstr);
	PlayerTextDrawHide(playerid, PHANGKAT[10][playerid]);
	PlayerTextDrawHide(playerid, PHANGKAT[11][playerid]);
	PlayerTextDrawShow(playerid, REJECT[playerid]);
	PlayerTextDrawShow(playerid, BERDERING[playerid]);
	SendClientMessageEx(playerid, COLOR_PINK, "[CELLPHONE] "WHITE_E"phone begins to ring, please wait for answer, for reject use '/cursor' and press red button!");
	return 1;
}
forward HidePhone(playerid);
public HidePhone(playerid)
{
	CancelSelectTextDraw(playerid);
	for(new i =0 ; i < 18; i++)
	{
		PlayerTextDrawHide(playerid, PHANGKAT[i][playerid]);
	}
	PlayerTextDrawHide(playerid, REJECT[playerid]);
	PlayerTextDrawHide(playerid, BERDERING[playerid]);
	return 1;
}
forward HidePhone1(caller);
public HidePhone1(caller)
{
	for(new i =0 ; i < 18; i++)
	{
		PlayerTextDrawHide(caller, PHANGKAT[i][caller]);
	}
	PlayerTextDrawHide(caller, REJECT[caller]);
	PlayerTextDrawHide(caller, BERDERING[caller]);
	return 1;
}
stock FIXES_valstr(dest[], value, bool:pack = false)
{
    // format can't handle cellmin properly
    static const cellmin_value[] = !"-2147483648";

    if (value == cellmin)
        pack && strpack(dest, cellmin_value, 12) || strunpack(dest, cellmin_value, 12);
    else
        format(dest, 12, "%d", value) && pack && strpack(dest, dest, 12);
}
stock number_format(number)
{
	new i, string[15];
	FIXES_valstr(string, number);
	if(strfind(string, "-") != -1) i = strlen(string) - 4;
	else i = strlen(string) - 3;
	while (i >= 1)
 	{
		if(strfind(string, "-") != -1) strins(string, ",", i + 1);
		else strins(string, ",", i);
		i -= 3;
	}
	return string;
}
stock PlayerFacePlayer( playerid, targetplayerid )
{
	new Float: Angle;
	GetPlayerFacingAngle( playerid, Angle );
	SetPlayerFacingAngle( targetplayerid, Angle+180 );
	return true;
}

stock AutoBan(playernya)
{
   new ban_time = gettime() + (5 * 86400), query[512], PlayerIP[16], giveplayer[24];
   GetPlayerIp(playernya, PlayerIP, sizeof(PlayerIP));
   GetPlayerName(playernya, giveplayer, sizeof(giveplayer));

   SendClientMessageToAllEx(COLOR_BAN, "BotCmd: Player %s Has Been Banned Permanently For Mas Dicky", giveplayer);
   SendClientMessageToAllEx(COLOR_BAN, "Reason: Cheating ");
   TotalAutoBan++;

   mysql_format(g_SQL, query, sizeof(query), "INSERT INTO banneds(name, ip, admin, reason, ban_date, ban_expire) VALUES ('%s', '%s', 'Server Ban', 'Using Cheat!', %i, %d)", giveplayer, PlayerIP, gettime(), ban_time);
   mysql_tquery(g_SQL, query);
   KickEx(playernya);
}
stock SendMessageInChat(playerid, text[])
{
	/*new Float: x, Float: y, Float: z;
	new lstr[1024];

	GetPlayerPos(playerid, x, y, z);

	//UpperToLower(text);
	format(lstr, sizeof(lstr), "%s says: %s", ReturnName(playerid), text);
	ProxDetector(10, playerid, lstr, 0xE6E6E6E6, 0xC8C8C8C8, 0xAAAAAAAA, 0x8C8C8C8C, 0x6E6E6E6E);
	if(pData[playerid][pMaskOn] == 0)
	{
		SetPlayerChatBubble(playerid, text, COLOR_PINK, 10.0, 3000);
	}
	text[0] = toupper(text[0]);

	// if(!IsPlayerInAnyVehicle(playerid))
	// {
	// 	ApplyAnimation(playerid, "PED", "IDLE_chat", 4.100, 0, 1, 1, 1, 1, 1);
	// 	SetTimerEx("ClearPlayerAnim", strlen(text) * 400, false, "i", playerid);
	// }
	return 1;*/
}
//Butcher
stock GoObject(playerid)
{
    playerobject[playerid][0] = CreateDynamicObject(2806, 942.3492, 2131.815185, 1011.226501, 0.000000, 0.000000, 0.000000, playerid+1, -1, -1, 300.00, 300.00);
	if(random(2))
	{
	    SetPVarInt(playerid,"BadMeat",1);
		SetDynamicObjectMaterial(playerobject[playerid][0], 0, 5421, "laesmokecnthus", "greenwall4", 0x00000000);
	}
	else DeletePVar(playerid,"BadMeat");
	MoveDynamicObject(playerobject[playerid][0],942.3492, 2123.890380, 1011.226501,2);
	Streamer_SetIntData(STREAMER_TYPE_OBJECT,playerobject[playerid][0],E_STREAMER_EXTRA_ID,playerid);
	Streamer_Update(playerid);

	return 1;
}
GetRPName(playerid)
{
	new
		name[MAX_PLAYER_NAME];

	GetPlayerName(playerid, name, sizeof(name));

	for(new i = 0, l = strlen(name); i < l; i ++)
	{
	    if(name[i] == '_')
	    {
	        name[i] = ' ';
		}
	}

	return name;
}
stock RefreshHbec(playerid)
{
	PlayerTextDrawSetPreviewModel(playerid, HBEC[playerid], GetVehicleModel(GetPlayerVehicleID(playerid)));
	PlayerTextDrawShow(playerid, HBEC[playerid]);
    return 1;
}
stock FixedKick(playerid)
{
    KillTimer(kick_gTimer[playerid]);
    kick_gTimer[playerid] = SetTimerEx("DelayedKick", 1000, false, "i", playerid);
    return 1;
}
stock GiveMoneyRob(playerid, small, big)
{
	new money;
	new moneys[100];
	money = small+random(big);
	pData[playerid][pRedMoney] += money;
	format(moneys, sizeof moneys, "You have succesfull Robery, Getting : {00FF7F}$%s", FormatMoney(money));
	SendClientMessage(playerid, 0xFFFFFF00, moneys);
	return 1;
}
stock SendTweetMessage(color, String[])
{
	foreach(new i : Player)
	{
		if(pData[i][pTogTweet] == 0)
		{
			SendClientMessageEx(i, color, String);
		}
	}
	return 1;
}
function FitnessTime(playerid)
{
    if(!IsValidTimer(pData[playerid][pActivity])) return 0;
	{
		if(pData[playerid][pActivityTime] >= 100)
		{
			InfoTD_MSG(playerid, 8000, "Done!");
			KillTimer(pData[playerid][pActivity]);
			pData[playerid][pActivityTime] = 0;
			HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
			PlayerTextDrawHide(playerid, ActiveTD[playerid]);
			pData[playerid][pEnergy] -= 3;
			UpFitStats(playerid, playerid);
			ClearAnimations(playerid);
			return 1;
		}
		else if(pData[playerid][pActivityTime] < 100)
		{
			pData[playerid][pActivityTime] += 5;
			SetPlayerProgressBarValue(playerid, pData[playerid][activitybar], pData[playerid][pActivityTime]);
		}
	}
	return 1;
}
function SpawnTimer(playerid)
{
	ResetPlayerMoney(playerid);
	GivePlayerMoney(playerid, pData[playerid][pMoney]);
	SetPlayerScore(playerid, pData[playerid][pLevel]);
	SetPlayerHealth(playerid, pData[playerid][pHealth]);
	SetPlayerArmourEx(playerid, pData[playerid][pArmour]);
	pData[playerid][pSpawned] = 1;
	TogglePlayerControllable(playerid, 1);
	SetCameraBehindPlayer(playerid);
	AttachPlayerToys(playerid);
	SetWeapons(playerid);
	if(pData[playerid][pJail] > 0)
	{
		JailPlayer(playerid);
	}
	if(pData[playerid][pArrestTime] > 0)
	{
		SetPlayerArrest(playerid, pData[playerid][pArrest]);
	}
	return 1;
}
function SAGSLobbyDoorClose()
{
	MoveDynamicObject(SAGSLobbyDoor, 1389.375000, -25.387500, 999.978210, 3);
	return 1;
}

function SAPDLobbyDoorClose()
{
	MoveDynamicObject(SAPDLobbyDoor[0], 253.10965, 107.61060, 1002.21368, 3);
	MoveDynamicObject(SAPDLobbyDoor[1], 253.12556, 110.49657, 1002.21460, 3);
	MoveDynamicObject(SAPDLobbyDoor[2], 239.69435, 116.15908, 1002.21411, 3);
	MoveDynamicObject(SAPDLobbyDoor[3], 239.64050, 119.08750, 1002.21332, 3);
	return 1;
}

function SAPDWeaponDoorClose()
{
	MoveDynamicObject(SAPDWeaponDoor, 1556.010009, -1684.333007, 2113.355957, 3);
	return 1;
}

function LLFLobbyDoorClose()
{
	MoveDynamicObject(LLFLobbyDoor, -2119.21509, 657.54187, 1060.73560, 3);
	return 1;
}
ServerLabels()
{
	new strings[128];

	format(strings, sizeof(strings), "\n{6495ed}Selamat datang di Capitaliz roleplay dan selamat bermain");
	CreateDynamic3DTextLabel(strings, COLOR_GREEN, 92.7333,-1827.6486,4.3699, 3.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1); // spawn kendaraan

	CreateDynamicPickup(1239, 23, 1168.4275,-1313.3032,2231.9749, -1);
	format(strings, sizeof(strings), "[TREATMENT]\n{FFFFFF}/treatment\nMenghilangkan Sakit atau Penglihatan Merah\nPrice: $250.00");
	CreateDynamic3DTextLabel(strings, COLOR_LBLUE, 1168.4275,-1313.3032,2231.9749, 3.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1); //Treatement

	CreateDynamicPickup(1239, 23, 2108.7407,-1785.5049,13.3868, -1);
	format(strings, sizeof(strings), "[PIZZA JOB]\n{FFFFFF}/getpizza\nAmbil pizza lalu Antarkan Kesetiap Rumah\nGunakan Motor Pizza");
	CreateDynamic3DTextLabel(strings, COLOR_LBLUE, 2108.7407,-1785.5049,13.3868, 3.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1); //Pizza
	
	CreateDynamicPickup(1239, 23, 1082.3927,-1772.6974,13.3508, -1);
	format(strings, sizeof(strings), "[INSURANCE]\n{FFFFFF}VEHICLE INSURANCE SPAWN");
	CreateDynamic3DTextLabel(strings, COLOR_LBLUE, 1082.3927,-1772.6974,13.3508, 3.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1); //Pizza

	CreateDynamicPickup(1239, 23, 98.8032,-1807.9840,4.3699, -1);
	format(strings, sizeof(strings), "[STARTERPACK]\n{FFFFFF}/claimsp\n Get starterpack");
	CreateDynamic3DTextLabel(strings, COLOR_LBLUE, 98.8032,-1807.9840,4.3699, 3.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1); // ID Card

	CreateDynamicPickup(1239, 23, 121.8043,-1814.1162,4.2059, -1);
	format(strings, sizeof(strings), "[STARTERPACK]\n{FFFFFF}vehicle claimsp\n Respawn");
	CreateDynamic3DTextLabel(strings, COLOR_LBLUE, 121.8043,-1814.1162,4.2059, 3.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1); // spawn kendaraan

	//pemotong ayam
	format(strings, sizeof(strings), "[AYAM HIDUP]\n{FFFFFF}Gunakan /ambilayam Untuk Ambil Ayam Hidup");
    CreateDynamic3DTextLabel(strings, COLOR_PINK, -2107.4541,-2400.1042,31.4123, 3.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1); 
    CreateDynamicPickup(1239, 23, -2107.4541,-2400.1042,31.4123, -1, -1, -1, 5.0);

    format(strings, sizeof(strings), "[Pemotongan]\n{FFFFFF}Gunakan /potongayam Untuk Memotong Ayam Hidup");
    CreateDynamic3DTextLabel(strings, COLOR_PINK, -2110.5706,-2408.4841,31.3079, 3.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1); 
    CreateDynamicPickup(1239, 23, -2110.5706,-2408.4841,31.3079, -1, -1, -1, 5.0);

    format(strings, sizeof(strings), "[Packing Ayam]\n{FFFFFF}Gunakan /packingayam Untuk Membungkus Ayam Potong");
    CreateDynamic3DTextLabel(strings, COLOR_PINK, -2117.5095,-2414.5049,31.2266, 3.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1);
    CreateDynamicPickup(1239, 23, -2117.5095,-2414.5049,31.2266, -1, -1, -1, 5.0);

    format(strings, sizeof(strings), "[Gudang Ayam]\n{FFFFFF}Gunakan /jualayam Untuk Menjual Ayam Potong");
    CreateDynamic3DTextLabel(strings, COLOR_PINK, 921.7545,-1299.1313,14.0938, 3.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1);
    CreateDynamicPickup(1239, 23, 921.7545,-1299.1313,14.0938, -1, -1, -1, 5.0);

	//CreateDynamicPickup(1239, 23, 1370.6390,717.5485,-15.7573, -1);
	//format(strings, sizeof(strings), "[BPJS]\n{FFFFFF}/newbpjs\n mendapatkan BPJS");
	//CreateDynamic3DTextLabel(strings, COLOR_LBLUE, 1370.6390,717.5485,-15.7573, 3.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1); // bpjs

	CreateDynamicPickup(1239, 23, 1345.3302,-1763.2202,13.5992, -1);
	format(strings, sizeof(strings), "[Spray Tags]\n{FFFFFF}/buy");
	CreateDynamic3DTextLabel(strings, COLOR_LBLUE, 1345.3302,-1763.2202,13.5992, 3.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1); // tags

	CreateDynamicPickup(2912, 23, -383.0497,-1438.9336,26.3277, -1);
	format(strings, sizeof(strings), "[CARGO]\n{FFFFFF}/cargo sell\n sell cargo");
	CreateDynamic3DTextLabel(strings, COLOR_LBLUE, 2790.7275,-2417.8015,13.6329, 3.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1); // ID Card

	CreateDynamicPickup(1239, 23,708.5005, 393.4143, 1023.5939, -1);
	format(strings, sizeof(strings), "[City Hall]\n{FFFFFF}/newidcard - create new ID Card\n/newage - Change Birthday\n/sellhouse - sell your house\n/sellbisnis - sell your bisnis");
	CreateDynamic3DTextLabel(strings, COLOR_LBLUE, 708.5005, 393.4143, 1023.5939, 3.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1); // ID Card

	//CreateDynamicPickup(1239, 23, 1561.4852, -1694.3168, 5.8906, -1);
	format(strings, sizeof(strings), "{0900FF}[SAPD]\n{FFFFFF}Type {00FF11}/pickupsapd /pickupsapd1 {FFFFFF}- Pickup Vehicle\nType {FF0000}/storesapd {FFFFFF}- Store Vehicle");
	CreateDynamic3DTextLabel(strings, COLOR_PINK, 1561.4852, -1694.3168, 5.8906, 10.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1); // PICKUP SAPD

	format(strings, sizeof(strings), "{0900FF}[SAGS]\n{FFFFFF}Type {00FF11}/pickupsags {FFFFFF}- Pickup Vehicle\nType {FF0000}/storesags {FFFFFF}- Store Vehicle");
	CreateDynamic3DTextLabel(strings, COLOR_PINK, 1453.8130, -1749.3013, 13.5469, 10.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1); // PICKUP SAGS

	format(strings, sizeof(strings), "{0900FF}[SAMD]\n{FFFFFF}Type {00FF11}/pickupsafd {FFFFFF}- Pickup Vehicle\nType {FF0000}/storesafd {FFFFFF}- Store Vehicle");
	CreateDynamic3DTextLabel(strings, COLOR_PINK, 1176.6984, -1308.9498, 13.9363, 10.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1); // PICKUP SAFD

	CreateDynamicPickup(1239, 23, -2045.3181, -131.1306, -50.9141, -1);
	format(strings, sizeof(strings), "[Veh Insurance]\n{FFFFFF}/buyinsu - buy insurance\n/claimpv - claim insurance\n/sellpv - sell vehicle");
	CreateDynamic3DTextLabel(strings, COLOR_LBLUE, -2045.3181, -131.1306, -50.9141, 3.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1); // Veh insurance

	CreateDynamicPickup(1239, 23, -2038.9857,-125.9983,-50.9141, -1);
	format(strings, sizeof(strings), "[License]\n{FFFFFF}/newdrivelic - create new license driving");
	CreateDynamic3DTextLabel(strings, COLOR_BLUE, -2038.9857, -125.9983, -50.9141, 3.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1); // Driving Lic

	CreateDynamicPickup(1239, 23, 1560.4094, -1672.3917, 2113.0349, -1);
	format(strings, sizeof(strings), "[Payment]\n{FFFFFF}/payticket - to pay ticket\n/buyplate - create new plate\n/claimip - to claim impound");
	CreateDynamic3DTextLabel(strings, COLOR_BLUE, 1560.4094, -1672.3917, 2113.0349, 3.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1); // Ticket

	CreateDynamicPickup(1239, 23, 1583.8820, -1672.9263, 2982.2800, -1);
	format(strings, sizeof(strings), "[ARREST POINT]\n{FFFFFF}/arrest - arrest wanted player");
	CreateDynamic3DTextLabel(strings, COLOR_BLUE, 1583.8820, -1672.9263, 2982.2800, 3.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1); // arrest

	CreateDynamicPickup(1239, 23, 224.11, 118.50, 999.10, -1);
	format(strings, sizeof(strings), "[AMMO POINT]\n{FFFFFF}/createammo /createmegazine - create ammo gun & megazine");
	CreateDynamic3DTextLabel(strings, COLOR_BLUE, 1105.8766, -299.6543, 74.5391, 3.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1); //ammogun

	CreateDynamicPickup(1239, 23, 1142.38, -1330.74, 13.62, -1);
	format(strings, sizeof(strings), "[Hospital]\n{FFFFFF}/dropinjured");
	CreateDynamic3DTextLabel(strings, COLOR_PINK, 1142.38, -1330.74, 13.62, 3.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1); // hospital

	CreateDynamicPickup(1274, 23, -1340.1584, 2897.8811, 3014.2109, -1);
	format(strings, sizeof(strings), "[BANK]\n{FFFFFF}/newrek - create new rekening");
	CreateDynamic3DTextLabel(strings, COLOR_LOGS, -1340.1584, 2897.8811, 3014.2109, 3.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1); // bank

	CreateDynamicPickup(1274, 23, -1340.1584, 2886.3032, 3014.2109, -1);
	format(strings, sizeof(strings), "[BANK]\n{FFFFFF}/bank - access rekening");
	CreateDynamic3DTextLabel(strings, COLOR_LOGS, -1340.1584, 2886.3032, 3014.2109, 3.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1); // bank

	CreateDynamicPickup(1239, 23, 2461.21, 2270.42, 91.67, -1);
	format(strings, sizeof(strings), "[Ads]\n{FFFFFF}/ad - public ads");
	CreateDynamic3DTextLabel(strings, COLOR_LOGS, 2461.21, 2270.42, 91.67, 3.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1); // iklan

	CreateDynamicPickup(1239, 23, 1773.6583, -1015.3002, 23.9609, -1);
	format(strings, sizeof(strings), "[Payphone]\n{FFFFFF}/cu - $5");
	CreateDynamic3DTextLabel(strings, COLOR_LOGS, 1773.6583, -1015.3002, 23.9609 , 3.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1); // cu

	//meat
	CreateDynamicPickup(1239, 23, 942.3542, 2117.8999, 1011.0303, -1, -1, -1, 5.0);
	format(strings, sizeof(strings), "["YELLOW_E"Store Meat"WHITE_E"]\n"WHITE_E"You can store "LG_E"10"WHITE_E" meat\nand\nselect spoiled pieces\n\n"LB_E"/storemeat");
	CreateDynamic3DTextLabel(strings, COLOR_PINK, 942.3542, 2117.8999, 1011.0303, 5.0);

    CreateDynamicPickup(1239, 23, 1558.7731, -1672.3914, 2113.0349, -1, -1, -1, 50);
    format(strings, sizeof(strings), "[Tire Lock]\n{FFFFFF}/paytire");
    CreateDynamic3DTextLabel(strings, COLOR_ORANGE2, 1558.7731, -1672.3914, 2113.0349, 5.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1);

	//Dynamic CP
	BoatDealer = CreateDynamicCP(131.4477,-1804.2656, 4.3699, 1.0, -1, -1, -1, 5.0);
	CreateDynamic3DTextLabel("Buy Boat", COLOR_GREEN, 131.4477,-1804.2656, 4.3699, 5.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, -1);

	ShowRoomS = CreateDynamicCP(530.3839,-1292.3944,17.3201, 1.0, -1, -1, -1, 5.0);
	CreateDynamic3DTextLabel("Buy Vehicle", COLOR_GREEN, 530.3839,-1292.3944,17.3201, 5.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, -1);

	ShowRoomCPRent = CreateDynamicCP(1259.1423, -1262.9587, 13.5234, 1.0, -1, -1, -1, 5.0);
	CreateDynamic3DTextLabel("Rental Vehicle\n"YELLOW_E"/unrentpv", COLOR_LBLUE, 1259.1423, -1262.9587, 13.5234, 5.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, -1);
}

forward EnterDoor(playerid);
//
forward ClearPlayerAnim(playerid);
forward DCC_OnMessageCreate(DCC_Message:message);
forward DelayedKick(playerid);
forward FillTrash(id);
//forward UpdataBarMask(playerid);
//forward DeleteBarMask(playerid);

//
forward ParacetamolTime(playerid);
public ParacetamolTime(playerid)
{
	pData[playerid][pSick] = 0;
	return 1;
}


public ClearPlayerAnim(playerid)
{
	ApplyAnimation(playerid, "CARRY", "crry_prtial", 4.0, 0, 0, 0, 0, 0, 1);
}
public DCC_OnMessageCreate(DCC_Message:message)
{
	new realMsg[100], msg[128];
    DCC_GetMessageContent(message, realMsg, 100);
    new bool:IsBot;
    new DCC_Channel:channel;
 	DCC_GetMessageChannel(message, channel);
    new DCC_User:author;
	DCC_GetMessageAuthor(message, author);
    DCC_IsUserBot(author, IsBot);
    /*if(channel == g_Discord_AndroVerifed && !IsBot)
    {
    	new player[200];
    	format(player,sizeof(player),"Whitelist/%s.txt",realMsg);
    	{
			if(!dini_Exists(player))
  			{
      			dini_Create(player);
    			format(msg, sizeof(msg), "**Account: %s Akun telah diverifikasi ke database**",realMsg);
    			DCC_SendChannelMessage(g_Discord_AndroVerifed, msg);
			}
  			else
    		{
    			format(msg, sizeof(msg), "Akun ini Sudah **diverifikasi tadi!**");
    			DCC_SendChannelMessage(g_Discord_AndroVerifed, msg);
      		}
   		}
    }*/
    if(channel == g_Discord_PcVerived && !IsBot)
    {
    	new player[200];
    	format(player,sizeof(player),"pc/%s.txt",realMsg);
    	{
			if(!dini_Exists(player))
  			{
      			dini_Create(player);
    			format(msg, sizeof(msg), "Account: %s **Akun telah diverifikasi ke database**", realMsg);
    			DCC_SendChannelMessage(g_Discord_PcVerived, msg);
			}
  			else
    		{
    			format(msg, sizeof(msg), "**Akun ini Sudah diverifikasi tadi!**");
    			DCC_SendChannelMessage(g_Discord_PcVerived, msg);
      		}
   		}
	}
	if(channel == g_discord_paylogs && !IsBot) //!IsBot will block BOT's message in game
	{
        if(!strcmp(realMsg, "/players", true))
        {
        	format(msg, sizeof(msg), ":white_check_mark: **Jumlah Pemain Online Saat Ini: %d**", online);
	    	DCC_SendChannelMessage(g_discord_paylogs, msg);
	    }
	}
    return 1;
}

public DelayedKick(playerid)
{
    if (!IsPlayerConnected(playerid)) return 1;
    Kick(playerid);
    return 1;
}

//---------[ Ores miner Job Log ]-------
#define LOG_LIFETIME 100
#define LOG_LIMIT 10
#define MAX_LOG 100

enum    E_LOG
{
	// temp
	bool:logExist,
	logType,
	logDroppedBy[MAX_PLAYER_NAME],
	logSeconds,
	logObjID,
	logTimer,
	Text3D:logLabel
}
new LogData[MAX_LOG][E_LOG];

new
	LogStorage[MAX_VEHICLES][2];

//------[ Trucker ]--------

new VehProduct[MAX_VEHICLES];
new VehGasOil[MAX_VEHICLES];

//-----[ Include Modular ]-----
main()
{
	SetTimer("onlineTimer", 1000, true);
	SetTimer("TDUpdates", 10000, true);
	SetTimer_("OnMinuteTimer", 60000,0,-1);
	SetTimer_("OnSecondTimer", 1000, 0, -1);
	SetTimer("AutoGmx", 28800000, true);
	SetTimer("reloadpacket", 10000, true);
}
#include "MODULE\SERVER\DINI.pwn"
#include "MODULE\SERVER\DAMAGE.pwn"
#include "MODULE\OBJECT\BLUEZONE.pwn"
#include "MODULE\OBJECT\MODULAR.pwn"
#include "MODULE\OBJECT\MODULAR1.pwn"
#include "MODULE\OBJECT\REMOVE.pwn"
#include "MODULE\OBJECT\CCTV.pwn"
#include "MODULE\SERVER\SONG.pwn"
#include "MODULE\SERVER\ANIMS.pwn"
#include "MODULE\ADMIN\VOTE.pwn"
#include "MODULE\SERVER\BERRY.pwn"
#include "MODULE\OBJECT\ACTOR.pwn"
#include "MODULE\ADMIN\QUIZ.pwn"
#include "MODULE\COMERCE\GARKOT.pwn"
#include "MODULE\VEHICLE\PRIVATE_VEHICLE.pwn"
#include "MODULE\FACTION\SIREN.pwn"
#include "MODULE\FACTION\COPSTUFF.pwn"
#include "MODULE\VEHICLE\VEHICLE_TOYS.pwn"
#include "MODULE\VEHICLE\VEHICLE_STICKER.pwn"
#include "MODULE\BADSIDE\BORAX.pwn"
#include "MODULE\ADMIN\REPORT.pwn"
#include "MODULE\ADMIN\ASK.pwn"
#include "MODULE\SERVER\WEAPON_ATTH.pwn"
#include "MODULE\SERVER\TOYS.pwn"
#include "MODULE\SERVER\TOLL.pwn"
#include "MODULE\BADSIDE\GRAFITY.pwn"
#include "MODULE\ADMIN\PB.pwn"
#include "MODULE\SERVER\PHONE.pwn"
#include "MODULE\SERVER\HELMET.pwn"
#include "MODULE\SERVER\SERVER.pwn"
#include "MODULE\COMERCE\DOOR.pwn"
#include "MODULE\BADSIDE\FAMILY.pwn"
#include "MODULE\COMERCE\HOUSE.pwn"
#include "MODULE\COMERCE\FLAT.pwn"
#include "MODULE\COMERCE\HOTEL.pwn"
#include "MODULE\COMERCE\BISNIS.pwn"
#include "MODULE\COMERCE\AUCTION.pwn"
#include "MODULE\COMERCE\FARM.pwn"
#include "MODULE\COMERCE\WORKSHOP.pwn"
#include "MODULE\OBJECT\MAPPING.pwn"
#include "MODULE\OBJECT\COBJECT.pwn"
#include "MODULE\COMERCE\GAS_STATION.pwn"
#include "MODULE\SERVER\DYNAMIC_LOCKER.pwn"
#include "MODULE\SERVER\DYNAMIC_STORAGE.pwn"
//#include "MODULE\SERVER\GARAGE.pwn"
#include "MODULE\OBJECT\DYNAMIC_GIFT.pwn"
#include "MODULE\SERVER\DYNAMIC_MAPICON.pwn"
#include "MODULE\SERVER\CRATE.pwn"
//#include "MODULE\SERVER\DYNAMIC_MAPPING.pwn"
#include "MODULE\SERVER\NATIVE.pwn"
#include "MODULE\JOB\JOB_SWEEPER.pwn"
#include "MODULE\JOB\JOB_CLEANING.pwn"
#include "MODULE\JOB\JOB_CONTAINER.pwn"
#include "MODULE\JOB\JOB_BUS.pwn"
#include "MODULE\JOB\JOB_PIZZA.pwn"
#include "MODULE\COMERCE\GYM.pwn"
#include "MODULE\VEHICLE\MODSHOP.pwn"
#include "MODULE\JOB\JOB_FORKLIFT.pwn"
#include "MODULE\JOB\JOB_DEPOSITOR.pwn"
#include "MODULE\JOB\JOB_BOX.pwn"
#include "MODULE\JOB\JOB_COURIER.pwn"
#include "MODULE\JOB\JOB_TRASHMASTER.pwn"
#include "MODULE\JOB\JOB_MOWER.pwn"
#include "MODULE\JOB\JOB_PEMOTONGAYAM.pwn"
#include "MODULE\ADMIN\VOUCHER.pwn"
#include "MODULE\SERVER\SALARY.pwn"
#include "MODULE\COMERCE\ATM_MECHINE.pwn"
#include "MODULE\COMERCE\DMV.pwn"
#include "MODULE\COMERCE\VENDING.pwn"
#include "MODULE\COMERCE\DEALERSHIP.pwn"
#include "MODULE\BADSIDE\ARMS_DEALER.pwn"
#include "MODULE\COMERCE\GATE.pwn"
#include "MODULE\ADMIN\EVENT.pwn"
#include "MODULE\FACTION\MDC.pwn"
#include "MODULE\JOB\JOB_TAXI.pwn"
#include "MODULE\JOB\JOB_MECH.pwn"
#include "MODULE\JOB\JOB_LUMBER.pwn"
#include "MODULE\JOB\JOB_MINER.pwn"
#include "MODULE\JOB\JOB_PRODUCTION.pwn"
#include "MODULE\JOB\JOB_TRUCKER.pwn"
#include "MODULE\JOB\JOB_FISH.pwn"
#include "MODULE\JOB\JOB_FARMER.pwn"
#include "MODULE\JOB\JOB_ELECTRIC.pwn"
#include "MODULE\JOB\JOB_DRUG_SMUGGLER.pwn"
#include "MODULE\CMD\ADMIN.pwn"
#include "MODULE\CMD\FACTION.pwn"
#include "MODULE\CMD\PLAYER.pwn"
#include "MODULE\CMD\DISCORD.pwn"
#include "MODULE\FACTION\SAPD_TASER.pwn"
#include "MODULE\FACTION\SAPD_SPIKE.pwn"
#include "MODULE\SERVER\CONTACT.pwn"
#include "MODULE\VEHICLE\VSTORAGE.pwn"
#include "MODULE\SERVER\DIALOG.pwn"
#include "MODULE\CMD\ALIAS\ALIAS_ADMIN.pwn"
#include "MODULE\CMD\ALIAS\ALIAS_PLAYER.pwn"
#include "MODULE\CMD\ALIAS\ALIAS_BISNIS.pwn"
#include "MODULE\CMD\ALIAS\ALIAS_HOUSE.pwn"
#include "MODULE\CMD\ALIAS\ALIAS_PRIVATE_VEHICLE.pwn"
#include "MODULE\SERVER\FUNCTION.pwn"
#include "MODULE\SERVER\PROGRESS.pwn"
#include "MODULE\SERVER\AdsPlayer.pwn"
#include "MODULE\BADSIDE\ROBBERY.pwn"
#include "MODULE\CHEAT\ANTIAIMBOT.pwn"
#include "MODULE\CHEAT\ANTICHEAT.pwn"
#include "MODULE\CHEAT\SAPD_BARRICADE.pwn"
#include "MODULE\CHEAT\SIGNAL.pwn"
#include "MODULE\VEHICLE\SPEEDO.pwn"

function AutoGmx()
{
	SetTimer("GmxNya", 60000, true);
	SendClientMessageToAll(COLOR_PINK, "[Auto Gmx]"WHITE_E" - Server akan otomatis restar dalam "RED_E"60"WHITE_E" detik");
	DCC_SendChannelMessage(g_Discord_Information, "```Server akan otomatis __Restart__ Dalam 60 detik```.");
	return 1;
}
function GmxNya()
{
	SendRconCommand("gmx");
}
public EnterDoor(playerid)
{
	if(IsPlayerConnected(playerid))
	foreach(new did : Doors)
	{
		if(IsPlayerInRangeOfPoint(playerid, 2.8, dData[did][dExtposX], dData[did][dExtposY], dData[did][dExtposZ]))
		{
			return 1;
		}
		if(IsPlayerInRangeOfPoint(playerid, 2.8, dData[did][dIntposX], dData[did][dIntposY], dData[did][dIntposZ]))
		{
			return 1;
		}
	}
	return 0;
}
public OnGameModeInit()
{
	//mysql_log(ALL);

	new MySQLOpt: option_id = mysql_init_options();

	mysql_set_option(option_id, AUTO_RECONNECT, true);

	//afk
	for (new i; i<MAX_PLAYERS; i++)AFK[i]=0;

	g_SQL = mysql_connect(MYSQL_HOST, MYSQL_USER, MYSQL_PASSWORD, MYSQL_DATABASE, option_id);
	if (g_SQL == MYSQL_INVALID_HANDLE || mysql_errno(g_SQL) != 0)
	{
		print("MySQL connection failed. Server is shutting down.");
		SendRconCommand("");
		return 1;
	}
	print("MySQL connection is successful.");

	mysql_tquery(g_SQL, "SELECT * FROM `server`", "LoadServer");
	mysql_tquery(g_SQL, "SELECT * FROM `doors`", "LoadDoors");
	mysql_tquery(g_SQL, "SELECT * FROM `familys`", "LoadFamilys");
	mysql_tquery(g_SQL, "SELECT * FROM `farm`", "LoadFarm");
	mysql_tquery(g_SQL, "SELECT * FROM `houses`", "LoadHouses");
	mysql_tquery(g_SQL, "SELECT * FROM `flats`", "LoadFlats");
	mysql_tquery(g_SQL, "SELECT * FROM `hotels`", "LoadHotels");
	mysql_tquery(g_SQL, "SELECT * FROM `bisnis`", "LoadBisnis");
//	mysql_tquery(g_SQL, "SELECT * FROM `workshop`", "LoadWorkshop");
	mysql_tquery(g_SQL, "SELECT * FROM `workshop`", "LoadWorkshop");
	mysql_tquery(g_SQL, "SELECT * FROM `lockers`", "LoadLockers");
	mysql_tquery(g_SQL, "SELECT * FROM `gstations`", "LoadGStations");
	mysql_tquery(g_SQL, "SELECT * FROM `atms`", "LoadATM");
	mysql_tquery(g_SQL, "SELECT * FROM `gates`", "LoadGates");
	mysql_tquery(g_SQL, "SELECT * FROM `vouchers`", "LoadVouchers");
	mysql_tquery(g_SQL, "SELECT * FROM `trees`", "LoadTrees");
	mysql_tquery(g_SQL, "SELECT * FROM `ores`", "LoadOres");
	mysql_tquery(g_SQL, "SELECT * FROM `plants`", "LoadPlants");
	mysql_tquery(g_SQL, "SELECT * FROM `vending`", "LoadVending");
	mysql_tquery(g_SQL, "SELECT * FROM dealership", "LoadCarDealership");
	mysql_tquery(g_SQL, "SELECT * FROM `storage`", "LoadStorages");
	mysql_tquery(g_SQL, "SELECT * FROM `berry`", "LoadBerry");
	mysql_tquery(g_SQL, "SELECT * FROM `parks`", "LoadPark");
	mysql_tquery(g_SQL, "SELECT * FROM `garage`", "Garage_Load");
	mysql_tquery(g_SQL, "SELECT * FROM `cargo`", "Cargo_Load");
	mysql_tquery(g_SQL, "SELECT * FROM `sigenal`", "LoadSignal");
	//mysql_tquery(g_SQL, "SELECT * FROM `barikade`", "Loadbarikade");
	//--------
	new gm[32];
	format(gm, sizeof(gm), "%s", TEXT_GAMEMODE);
	SetGameModeText(gm);
	format(gm, sizeof(gm), "weburl %s", TEXT_WEBURL);
	SendRconCommand(gm);
	format(gm, sizeof(gm), "language %s", TEXT_LANGUAGE);
	SendRconCommand(gm);
	new statuz[100];
 	format(statuz,sizeof(statuz),"%d Players | %d MaxPlayers", online, GetMaxPlayers());
	DCC_SetBotActivity(statuz);
	//---- [ Function ]----
	ShowNameTags(false);
    EnableTirePopping(0);
	CreateTextDraw();
	CreateServerPoint();
	CreateJoinLumberPoint();
    CreateContainerPoint();
	CreateJoinTaxiPoint();
	CreateJoinMechPoint();
	CreateJoinMinerPoint();
	CreateJoinProductionPoint();
	CreateJoinTruckPoint();
	CreateArmsPoint();
	CreateJoinCleaningPoint();
	CreateJoinFarmerPoint();
	CreateJoinSmugglerPoint();
	CreateJoinKurirPoint();
	CreateJoinAyamPoint();
	CreateDepositorJobPoint();
	CreateLoadMoneyJobPoint();
	LoadTazerSAPD();
	//server
	ServerLabels();
	//ServerVehicle();
	LoadFarm();
	MoveShip();
	//cctv
	LoadCamDb();
	//Sidejob Vehicle
	AddSweeperVehicle();
	AddPizzaVehicle();
	AddBusVehicle();
	AddForVehicle();
	AddTrashVehicle();
	AddKurirVehicle();
	AddMowerVeh();
	//DMV Veh
	AddDmvVehicle();
	//map
	ObjectMapping();
	ObjectMapping1();
	LoadObjects();
	LoadGym();
	LoadGYMObject();
	LoadModsPoint();
	LoadActors();
	//BLUEZONE
	Zone_OnFilterScriptInit();
	//---
	SendRconCommand("mapname San Andreas");
	ManualVehicleEngineAndLights();
	EnableStuntBonusForAll(0);
	AllowInteriorWeapons(1);
	DisableInteriorEnterExits();
	LimitPlayerMarkerRadius(15.0);
	SetNameTagDrawDistance(20.0);

	ShowPlayerMarkers(PLAYER_MARKERS_MODE_OFF);
	SetWorldTime(WorldTime);
	SetWeather(WorldWeather);
	BlockGarages(.text=".");
	
	SendRconCommand("reloadfs ls_apartments1");
	SendRconCommand("reloadfs basket");
	//SendRconCommand("reloadfs rcon");
	//print("Android check has been successfully loaded.");

	//Timer
	SetTimer("settime",1000,true);
	SetTimer("UpdateSpeed", UpdateSeconds*1000, 1);
	SetTimer("UpdateStock", 7200000, true);
	//SetTimer("UpdatePrice", 7200000, true);
	//SetTimer("CheckPlayers",1000,true);
	//_____-txtAnimHelper___/
	txtAnimHelper = TextDrawCreate(630.0, 420.0,
	"~r~~k~~H~ ~w~to stop the animation");
	TextDrawUseBox(txtAnimHelper, 0);
	TextDrawFont(txtAnimHelper, 2);
	TextDrawSetShadow(txtAnimHelper,0);
    TextDrawSetOutline(txtAnimHelper,1);
    TextDrawBackgroundColor(txtAnimHelper,0x000000FF);
    TextDrawColor(txtAnimHelper,0xFFFFFFFF);
    TextDrawAlignment(txtAnimHelper,3);

	ship_3d[0] = CreateDynamic3DTextLabel("-", -1, 2537.3511,-2649.0061,3.2829, 15.0);
    ship_3d[1] = CreateDynamic3DTextLabel("-", -1, 2592.6445,-3810.7356,3.1971, 15.0);

	for(new i;i < sizeof(BarrierInfo);i ++)
	{
		new
		Float:X = BarrierInfo[i][brPos_X],
		Float:Y = BarrierInfo[i][brPos_Y];

		ShiftCords(0, X, Y, BarrierInfo[i][brPos_A]+90.0, 3.5);
		CreateDynamicObject(966,BarrierInfo[i][brPos_X],BarrierInfo[i][brPos_Y],BarrierInfo[i][brPos_Z],0.00000000,0.00000000,BarrierInfo[i][brPos_A]);
		if(!BarrierInfo[i][brOpen])
		{
			gBarrier[i] = CreateDynamicObject(968,BarrierInfo[i][brPos_X],BarrierInfo[i][brPos_Y],BarrierInfo[i][brPos_Z]+0.8,0.00000000,90.00000000,BarrierInfo[i][brPos_A]+180);
			MoveObject(gBarrier[i],BarrierInfo[i][brPos_X],BarrierInfo[i][brPos_Y],BarrierInfo[i][brPos_Z]+0.7,BARRIER_SPEED,0.0,0.0,BarrierInfo[i][brPos_A]+180);
			MoveObject(gBarrier[i],BarrierInfo[i][brPos_X],BarrierInfo[i][brPos_Y],BarrierInfo[i][brPos_Z]+0.75,BARRIER_SPEED,0.0,90.0,BarrierInfo[i][brPos_A]+180);
		}
		else gBarrier[i] = CreateDynamicObject(968,BarrierInfo[i][brPos_X],BarrierInfo[i][brPos_Y],BarrierInfo[i][brPos_Z]+0.8,0.00000000,20.00000000,BarrierInfo[i][brPos_A]+180);
	}
	//

    ship_pickup = CreateDynamicPickup(1239, 23, 2583.8079,-3830.8315,13.6421, 0);

	for(new i, z = sizeof ship_work_pos; i < z; i++) ship_work_pickups[i] = CreateDynamicPickup(19135, 23, ship_work_pos[i][0], ship_work_pos[i][1], ship_work_pos[i][2], 0);

	for(new i, z = sizeof ship_oil_pickups; i < z; i++) ship_oil_pickups[i] = CreateDynamicPickup(19135, 23, ship_oil_pos[i][0], ship_oil_pos[i][1], ship_oil_pos[i][2], 0);

    ship_mid_object = CreateObject(8493, 2560.034912, -2632.026367, 7.039000, 0.000000, 0.000000, 0.000000, 300.00);


    //trasher
	new label[128];
	for(new i; i < sizeof(TrashData); i++)
	{
	    format(label, sizeof(label), "%s{FFFFFF}\nTekan "GREEN_E"[Y]"WHITE_E" untuk membuang sampah!\nGunakan "YELLOW_E"'/pickup'"WHITE_E" Untuk memungut sampah!", (TrashData[i][TrashType] == TYPE_BIN) ? ("Trash Bin") : ("Dumpster"));
		TrashData[i][TrashLabel] = CreateDynamic3DTextLabel(label, 0x2ECC71FF, TrashData[i][TrashX], TrashData[i][TrashY], TrashData[i][TrashZ]+1.25, 15.0, .testlos = 1);
		TrashData[i][TrashLevel] = (TrashData[i][TrashType] == TYPE_BIN) ? 1 : 2;
	}
	for(new i; i < sizeof(FactoryData); i++)
	{
	    format(label, sizeof(label), "Recycling Factory - %s\n\n{FFFFFF}Current Trash Bags: {F39C12}0\n{FFFFFF}Bring trash here to earn money!", FactoryData[i][FactoryName]);
		FactoryData[i][FactoryLabel] = CreateDynamic3DTextLabel(label, 0x2ECC71FF, FactoryData[i][FactoryX], FactoryData[i][FactoryY], FactoryData[i][FactoryZ] + 0.5, 15.0, .testlos = 1);
		FactoryData[i][FactoryCP] = CreateDynamicCP(FactoryData[i][FactoryX], FactoryData[i][FactoryY], FactoryData[i][FactoryZ], 6.0);
	}

	for(new i, m = GetPlayerPoolSize(); i <= m; i++)
	{
	    if(!IsPlayerConnected(i)) continue;
		Trash_InitPlayer(i);
	}
	//electric
	for(new i; i < sizeof(ElectricData); i++)
	{
	    format(label, sizeof(label), "Electrican Point\n/services to service.");
		ElectricData[i][ElectricLabel] = CreateDynamic3DTextLabel(label, 0x2ECC71FF, ElectricData[i][ElectricX], ElectricData[i][ElectricY], ElectricData[i][ElectricZ]+1.25, 15.0, .testlos = 1);
	}
	tangga1 = CreateDynamicObject(1428, -770.86072, 2740.76587, 42.99480,   13.00000, 0.00000, 0.00000);
	tangga2 = CreateObject(1428, -1462.87024, 2527.30664, 53.48190,   7.00000, 0.00000, -130.00000);
	//Auction
	AuctionText = CreateDynamicObject(18244, 189.572525, -80.501548, 1032.988037, 89.999946, -0.499999, 0.699999, -1, -1, -1, 250.00, 250.00);
	SetDynamicObjectMaterialText(AuctionText, 0, "{FFFF00}Welcome\nTo Los Santos\n{FFFF00}Auction Office", 90, "Ariel", 20, 1, 0x00000000, 0x00000001, 1);
	HighBidText = CreateDynamicObject(3077, 195.396118, -81.974838, 1030.729858, 0.000000, 0.000000, -36.599998, -1, -1, -1, 300.00, 300.00);
	//hydr
	hydr[0] = CreateDynamicObject(19817, 2193.24243, -2199.99780, 10.96290,   0.00000, 0.00000, 44.40000);
	hydr[1] = CreateDynamicObject(19817, 2199.55225, -2193.81885, 10.96290,   0.00000, 0.00000, 44.40000);
	hydr[2] = CreateDynamicObject(19817, 2186.67017, -2206.51807, 10.96290,   0.00000, 0.00000, 44.04000);
	hydr[3] = CreateDynamicObject(19817, 2201.54321, -2237.80566, 10.88290,   0.00000, 0.00000, -136.98000);
	hydr[4] = CreateDynamicObject(19817, 2208.19092, -2231.78809, 10.86690,   0.00000, 0.00000, -136.98000);
	hydr[5] = CreateDynamicObject(19817, 2214.58667, -2225.68530, 10.85890,   0.00000, 0.00000, -136.98000);

	objectpacket = CreateDynamicObject(11745, -1304.212036, 2525.925537, 87.532722-1, 0.0, 0.0, 0.0, 0);
	//----------------------------------------------------------------------------------------------------
    CreateDynamicObject(19379, 1435.35657, -1227.07996, 151.31239,   360.00000, 90.00000, 0.00000);
	CreateDynamicObject(19379, 1424.86401, -1227.07996, 151.31239,   360.00000, 90.00000, 1080.00000);
	//g_Discord_AndroVerifed = DCC_FindChannelById("949772885122224170");
	g_discord_twt = DCC_FindChannelById("1084763664487297106");
	//g_Discord_adslogs = DCC_FindChannelById("953438202453196870");
	g_discord_ban = DCC_FindChannelById("1084763664487297106");
	g_discord_admins = DCC_FindChannelById("1084763664487297106");
	g_Discord_PcVerived = DCC_FindChannelById("1084763664487297106");
	g_Discord_Information = DCC_FindChannelById("1084763664487297106");
	g_discord_paylogs = DCC_FindChannelById("1084763664487297106");
	g_Admin_Command = DCC_FindChannelById("1084763664235642989");
	g_discord_logs = DCC_FindChannelById("1084763664487297106");
	g_discord_kill = DCC_FindChannelById("1084763664487297106");
	ucp = DCC_FindChannelById("1084768464666894437");
	acss = DCC_FindChannelById("1087860622403850270");
	serverguild = DCC_FindGuildById("1084763662448873493");
	register = DCC_FindChannelById("1087689535766413373");

	DCC_SetBotActivity("Capitaliz Roleplay | "TEXT_GAMEMODE"");
	DCC_SendChannelMessage(g_Discord_Information, "```\nServer Restarted.```");

	//Butcher
    new obuther = CreateDynamicObject(1439, 944.436828, 2127.660644, 1010.021179, 0.000000, 0.000000, -90.000000, -1, -1, -1, 300.00, 300.00);
	SetDynamicObjectMaterial(obuther, 0, 2803, "cj_meaty", "CJ_FLESH_2", 0x00000000);
	CreatePickup(1275, 23, 960.7062,2099.4375,1011.0248,0);
	meatsp = CreateDynamicSphere(960.7062,2099.4375,1011.0248, 2.0);

	CreateDynamic3DTextLabel("Start Work: {f7ae11}H",0xFFFFFFFF,940.1020,2127.6326,1011.0303,5.0,INVALID_PLAYER_ID,INVALID_VEHICLE_ID,0, 0);

	//-------------------------------------------------

	SpawnMale = LoadModelSelectionMenu("spawnmale.txt");
    SpawnFemale = LoadModelSelectionMenu("spawnfemale.txt");
    MaleSkins = LoadModelSelectionMenu("maleskin.txt");
    FemaleSkins = LoadModelSelectionMenu("femaleskin.txt");
    VIPMaleSkins = LoadModelSelectionMenu("maleskin.txt");
    VIPFemaleSkins = LoadModelSelectionMenu("femaleskin.txt");
    SAPDMale = LoadModelSelectionMenu("sapdmale.txt");
    SAPDFemale = LoadModelSelectionMenu("sapdfemale.txt");
    SAPDWar = LoadModelSelectionMenu("sapdwar.txt");
    SAGSMale = LoadModelSelectionMenu("sagsmale.txt");
    SAGSFemale = LoadModelSelectionMenu("sagsfemale.txt");
    SAMDMale = LoadModelSelectionMenu("samdmale.txt");
    SAMDFemale = LoadModelSelectionMenu("samdfemale.txt");
    SANEWMale = LoadModelSelectionMenu("sanewmale.txt");
    SANEWFemale = LoadModelSelectionMenu("sanewfemale.txt");
    toyslist = LoadModelSelectionMenu("toys.txt");
    viptoyslist = LoadModelSelectionMenu("viptoys.txt");
    vtoylist = LoadModelSelectionMenu("vtoylist.txt");

	SAGSLobbyBtn[0] = CreateButton(1388.987670, -25.291969, 1001.358520, 180.000000);
	SAGSLobbyBtn[1] = CreateButton(1391.275756, -25.481920, 1001.358520, 0.000000);
	SAGSLobbyDoor = CreateDynamicObject(1569, 1389.375000, -25.387500, 999.978210, 0.000000, 0.000000, 0.000000, -1, -1, -1, 300.00, 300.00);

	SAPDLobbyBtn[0] = CreateButton(252.95264, 107.67332, 1004.00909, 264.79898);
	SAPDLobbyBtn[1] = CreateButton(253.43437, 110.62970, 1003.92737, 91.00000);
	SAPDLobbyDoor[0] = CreateDynamicObject(1569, 253.10965, 107.61060, 1002.21368,   0.00000, 0.00000, 91.00000);
	SAPDLobbyDoor[1] = CreateDynamicObject(1569, 253.12556, 110.49657, 1002.21460,   0.00000, 0.00000, -91.00000);

	SAPDWeaponBtn = CreateButton(1556.1600, -1686.1654, 2113.77, 85.0783);
	SAPDWeaponDoor = CreateDynamicObject(3089, 1556.010009, -1684.333007, 2113.355957, 0.000000, 0.000000, 989.900024, -1, -1, -1, 300.00, 300.00);

	SAPDLobbyBtn[2] = CreateButton(239.82739, 116.12640, 1004.00238, 91.00000);
	SAPDLobbyBtn[3] = CreateButton(238.75888, 116.12949, 1003.94086, 185.00000);
	SAPDLobbyDoor[2] = CreateDynamicObject(1569, 239.69435, 116.15908, 1002.21411,   0.00000, 0.00000, 91.00000);
	SAPDLobbyDoor[3] = CreateDynamicObject(1569, 239.64050, 119.08750, 1002.21332,   0.00000, 0.00000, 270.00000);

	//Family Button
	LLFLobbyBtn[0] = CreateButton(-2119.90039, 655.96808, 1062.39954, 184.67528);
	LLFLobbyBtn[1] = CreateButton(-2119.18481, 657.88519, 1062.39954, 90.00000);
	LLFLobbyDoor = CreateDynamicObject(1569, -2119.21509, 657.54187, 1060.73560,   0.00000, 0.00000, -90.00000);

	printf("[Object] Number of Dynamic objects loaded: %d", CountDynamicObjects());
	//SetTimer("ServerOnlineTimer", 3000, false);
	return 1;
}

forward ServerOnlineTimer();
public ServerOnlineTimer()
{
	new fmt_str[128];
    format(fmt_str, sizeof fmt_str, "```\n[DEBUG] Amount of cdynamic objects: %i```", Streamer_CountItems(STREAMER_TYPE_OBJECT));
    DCC_SendChannelMessage(g_Discord_Information, fmt_str);
	DCC_SendChannelMessage(g_Discord_Information, "```\nServer Sudah Kembali Online.``` Gunakan Untuk Login <#1002992177170878464> @everyone");
	return 1;
}

public OnGameModeExit()
{
	print("-------------- [ Auto Gmx ] --------------");
	new count = 0, count1 = 0, user = 0;
	foreach(new gsid : GStation)
	{
		if(Iter_Contains(GStation, gsid))
		{
			count++;
			GStation_Save(gsid);
		}
	}
	printf("[Gas Station] Number of Saved: %d", count);

	foreach(new pid : Plants)
	{
		if(Iter_Contains(Plants, pid))
		{
			count1++;
			Plant_Save(pid);
		}
	}
	printf("[Farmer Plant] Number of Saved: %d", count1);
	for (new i = 0, j = GetPlayerPoolSize(); i <= j; i++)
	{
		if (IsPlayerConnected(i))
		{
			OnPlayerDisconnect(i, 1);
		}
	}
	//trasher
	for(new i, m = GetPlayerPoolSize(); i <= m; i++)
	{
	    if(!IsPlayerConnected(i)) continue;
	    Trash_ResetPlayer(i, 1);
	}
	foreach(new i : Player)
	{
		user++;
		UpdatePlayerData(i);
	}
	printf("[Database] User Saved: %d", user);
	print("-------------- [ Auto Gmx ] --------------");
	SendClientMessageToAll(COLOR_WHITE, "[!]"YELLOW_E" Sorry Server is Maintenance/Restart.{00FFFF} ~Capitaliz BOTS");
	new msg[100];
	format(msg, sizeof(msg), "```\nThe Server Is Now __Restarted__. [Database] User Saved: %d```", user);
	DCC_SendChannelMessage(g_Discord_Information, msg);

	for (new i; i<MAX_PLAYERS; i++)AFK[i]=0;
	UnloadTazerSAPD();
	SaveActors();
	//Audio_DestroyTCPServer();
	mysql_close(g_SQL);
	return 1;
}

/*
forward CheckPlayers(playerid);
public CheckPlayers(playerid)
{
	new str[20];

	format(str, sizeof(str), "Server ON %s Players In City", number_format(Iter_Count(Player)));
	DCC_SetEmbedDescription(Discord_Stats, str);
	return 1;
}*/

public OnPlayerPressButton(playerid, buttonid)
{
	if(buttonid == SAGSLobbyBtn[0] || buttonid == SAGSLobbyBtn[1])
	{
	    if(pData[playerid][pFaction] == 2)
	    {
	        MoveDynamicObject(SAGSLobbyDoor, 1387.9232, -25.3887, 999.9782, 3);
			SetTimer("SAGSLobbyDoorClose", 5000, 0);
	    }
		else
	    {
	        Error(playerid, "Access denied.");
			return 1;
		}
	}
	if(buttonid == SAPDWeaponBtn)
	{
	    if(pData[playerid][pFaction] == 1)
	    {
	        MoveDynamicObject(SAPDWeaponDoor, 1556.010009, -1684.333007, 2110.0349, 3);
			SetTimer("SAPDWeaponDoorClose", 5000, 0);
	    }
		else
	    {
	        Error(playerid, "Access denied.");
			return 1;
		}
	}
	if(buttonid == SAPDLobbyBtn[0] || buttonid == SAPDLobbyBtn[1])
	{
		if(pData[playerid][pFaction] == 1)
		{
			MoveDynamicObject(SAPDLobbyDoor[0], 253.14204, 106.60210, 1002.21368, 3);
			MoveDynamicObject(SAPDLobbyDoor[1], 253.24377, 111.94370, 1002.21460, 3);
			SetTimer("SAPDLobbyDoorClose", 5000, 0);
		}
		else
	    {
	        Error(playerid, "Access denied.");
			return 1;
		}
	}
	if(buttonid == SAPDLobbyBtn[2] || buttonid == SAPDLobbyBtn[3])
	{
		if(pData[playerid][pFaction] == 1)
		{
			MoveDynamicObject(SAPDLobbyDoor[2], 239.52385, 114.75534, 1002.21411, 3);
			MoveDynamicObject(SAPDLobbyDoor[3], 239.71977, 120.21591, 1002.21332, 3);
			SetTimer("SAPDLobbyDoorClose", 5000, 0);
		}
		else
	    {
	        Error(playerid, "Access denied.");
			return 1;
		}
	}
	if(buttonid == LLFLobbyBtn[0] || buttonid == LLFLobbyBtn[1])
	{
		if(pData[playerid][pFamily] == 0)
		{
			MoveDynamicObject(LLFLobbyDoor, -2119.27148, 656.04028, 1060.73560, 3);
			SetTimer("LLFLobbyDoorClose", 5000, 0);
		}
		else
		{
			Error(playerid, "Access denied.");
			return 1;
		}
	}
	return 1;
}

public OnPlayerEnterVehicle(playerid, vehicleid, ispassenger)
{
	
	if(IsBulletHitHead(playerid))
        SetPlayerHealth(playerid, 0);

	if(!ispassenger)
	{
		if(IsSAPDCar(vehicleid))
		{
		    if(pData[playerid][pFaction] != 1)
			{
			    RemovePlayerFromVehicle(playerid);
			    new Float:slx, Float:sly, Float:slz;
				GetPlayerPos(playerid, slx, sly, slz);
				SetPlayerPos(playerid, slx, sly, slz);
			    Error(playerid, "You are not SAPD!");
			}
		}
		if(IsGovCar(vehicleid))
		{
		    if(pData[playerid][pFaction] != 2)
			{
			    RemovePlayerFromVehicle(playerid);
			    new Float:slx, Float:sly, Float:slz;
				GetPlayerPos(playerid, slx, sly, slz);
				SetPlayerPos(playerid, slx, sly, slz);
			    Error(playerid, "You are not SAGS!");
			}
		}
		if(IsSAMDCar(vehicleid))
		{
		    if(pData[playerid][pFaction] != 3)
			{
			    RemovePlayerFromVehicle(playerid);
			    new Float:slx, Float:sly, Float:slz;
				GetPlayerPos(playerid, slx, sly, slz);
				SetPlayerPos(playerid, slx, sly, slz);
			    Error(playerid, "You are not SAMD!");
			}
		}
		if(IsSANACar(vehicleid))
		{
		    if(pData[playerid][pFaction] != 4)
			{
			    RemovePlayerFromVehicle(playerid);
			    new Float:slx, Float:sly, Float:slz;
				GetPlayerPos(playerid, slx, sly, slz);
				SetPlayerPos(playerid, slx, sly, slz);
			    Error(playerid, "You are not SANEW!");
			}
		}
		if(IsGOJEKCar(vehicleid))
		{
		    if(pData[playerid][pFaction] != 5)
			{
			    RemovePlayerFromVehicle(playerid);
			    new Float:slx, Float:sly, Float:slz;
				GetPlayerPos(playerid, slx, sly, slz);
				SetPlayerPos(playerid, slx, sly, slz);
			    Error(playerid, "You are not SANEW!");
			}
		}
		if(GetVehicleModel(vehicleid) == 548 || GetVehicleModel(vehicleid) == 417 || GetVehicleModel(vehicleid) == 487 || GetVehicleModel(vehicleid) == 488 ||
		GetVehicleModel(vehicleid) == 497 || GetVehicleModel(vehicleid) == 563 || GetVehicleModel(vehicleid) == 469)
		{
			if(pData[playerid][pLevel] < 5)
			{
				RemovePlayerFromVehicle(playerid);
			    new Float:slx, Float:sly, Float:slz;
				GetPlayerPos(playerid, slx, sly, slz);
				SetPlayerPos(playerid, slx, sly, slz);
				Error(playerid, "Anda tidak memiliki izin!");
			}
		}
	}
	return 1;
}
stock SetRaceCP(playerid, type, Float:x, Float:y, Float:z, Float:range)
{
	DisablePlayerRaceCheckpoint(playerid);
	SetPlayerRaceCheckpoint(playerid, type, x, y, z, 0, 0, 0, range);
}
public OnClientChecked(playerid, Client:type)
{
	if (type == CLIENT_TYPE_PC)
	{
		SetPVarInt(playerid, "NotAndroid", 1);
	}
	if (type == CLIENT_TYPE_ANDROID)
	{
		SetPVarInt(playerid, "NotAndroid", 0);
	}
	return 1;
}

public OnPlayerText(playerid, text[])
{
    new fmt_str[128];
    format(fmt_str, sizeof fmt_str, "```%s Says: %s```", pData[playerid][pName], text);
    DCC_SendChannelMessage(g_discord_logs, fmt_str);

	if(isnull(text)) return 0;
	printf("[CHAT] %s(%d) : %s", pData[playerid][pName], playerid, text);

	if(pData[playerid][pSpawned] == 0 && pData[playerid][IsLoggedIn] == false)
	{
	    Error(playerid, "You must be spawned or logged in to use chat.");
	    return 0;
	}
	text[0] = toupper(text[0]);
	if(!strcmp(text, "rpgun", true) || !strcmp(text, "gunrp", true))
	{
		SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s take the weapon off the belt and ready to shoot anytime.", ReturnName(playerid));
		return 0;
	}
	if(!strcmp(text, "savegun", true) || !strcmp(text, "savegunrp", true))
	{
		SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s safe a weapon in dueffel bag.", ReturnName(playerid));
		return 0;
	}
	if(!strcmp(text, "rpcrash", true) || !strcmp(text, "crashrp", true))
	{
		SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s shocked after crash.", ReturnName(playerid));
		return 0;
	}
	if(pData[playerid][pAdminDuty] == 1)
	{
		SendNearbyMessage(playerid, 20.0, COLOR_WHITE, "%s: "WHITE_E"(( %s ))", pData[playerid][pAdminname], text);
		SetPlayerChatBubble(playerid, text, COLOR_WHITE, 10.0, 3000);
		return 0;
	}
	if(text[0] == '@')
	{
		if(pData[playerid][pSMS] != 0)
		{
			if(pData[playerid][pPhoneCredit] < 1)
			{
				Error(playerid, "You dont have phone credits!");
				return 0;
			}
			if(pData[playerid][pInjured] != 0)
			{
				Error(playerid, "You cant do at this time.");
				return 0;
			}
			new tmp[512];
			if(text[0] == '!')
			{
				if(text[1] == ' ')
				{
			 		format(tmp, sizeof(tmp), "%s", text[2]);
				}
				else
				{
				    format(tmp, sizeof(tmp), "%s", text[1]);
				}
				if(pData[playerid][pPhone] == pData[playerid][pSMS])
				{
					if(playerid == INVALID_PLAYER_ID || !IsPlayerConnected(playerid))
					{
						Error(playerid, "This number is not actived!");
						return 0;
					}
					SendClientMessageEx(playerid, COLOR_PINK, "[SMS to %d]"WHITE_E" %s", pData[playerid][pSMS], tmp);
					SendClientMessageEx(playerid, COLOR_PINK, "[SMS from %d]"WHITE_E" %s", pData[playerid][pPhone], tmp);
					PlayerPlaySound(playerid, 6003, 0,0,0);
					pData[playerid][pSMS] = pData[playerid][pPhone];

					pData[playerid][pPhoneCredit] -= 1;
					return 0;
				}
			}
		}
	}
	if(GetPVarInt(playerid,"911"))
    {
		new Float:x, Float:y, Float:z, String[100];
		GetPlayerPos(playerid, x, y, z);
		Info(playerid, "Warning: This number for emergency crime only! please wait for SAPD respon!");
		SendFactionMessage(1, COLOR_BLUE, "[EMERGENCY CALL] "WHITE_E"%s calling the emergency crime! Ph: ["GREEN_E"%d"WHITE_E"] | Location: %s", ReturnName(playerid), pData[playerid][pPhone], GetLocation(x, y, z));
		format(String, sizeof(String), "[Description]: "WHITE_E"%s", text);
		SendFactionMessage(1, COLOR_BLUE, String);
		DeletePVar(playerid, "911");
		return 0;
	}
	if(GetPVarInt(playerid,"922"))
    {
		new Float:x, Float:y, Float:z, String[100];
		GetPlayerPos(playerid, x, y, z);
		Info(playerid, "Warning: This number for emergency medical only! please wait for SAMD respon!");
		SendFactionMessage(3, COLOR_PINK2, "[EMERGENCY CALL] "WHITE_E"%s calling the emergency medical! Ph: ["GREEN_E"%d"WHITE_E"] | Location: %s", ReturnName(playerid), pData[playerid][pPhone], GetLocation(x, y, z));
		format(String, sizeof(String), "[Description]: "WHITE_E"%s", text);
		SendFactionMessage(3, COLOR_PINK2, String);
		DeletePVar(playerid, "922");
		return 0;
	}
	if(GetPVarInt(playerid,"933"))
    {
		new Float:x, Float:y, Float:z, String[100];
		GetPlayerPos(playerid, x, y, z);
		Info(playerid, "Your calling has sent to the taxi driver. please wait for respon!");
		foreach(new tx : Player)
		{
			if(pData[tx][pJob] == 1 || pData[tx][pJob2] == 1)
			{
				SendClientMessageEx(tx, COLOR_PINK, "[TAXI CALL] "WHITE_E"%s calling the taxi for order! Ph: ["GREEN_E"%d"WHITE_E"] | Location: %s", ReturnName(playerid), pData[playerid][pPhone], GetLocation(x, y, z));
                format(String, sizeof(String), "[Description]: "WHITE_E"%s", text);
				SendFactionMessage(1, COLOR_PINK, String);
			}
		}
		DeletePVar(playerid, "933");
		return 0;
	}
	if(GetPVarInt(playerid,"511"))
    {
		new Float:x, Float:y, Float:z, String[100];
		GetPlayerPos(playerid, x, y, z);
		Info(playerid, "Your calling has sent to the GOJEK driver. please wait for respon!");
		foreach(new gj : Player)
		{
			if(pData[gj][pFaction] == 5)
			{
				SendClientMessageEx(gj, COLOR_PINK, "[GOJEK CALL] "WHITE_E"%s calling the gojek for order! Ph: ["GREEN_E"%d"WHITE_E"] | Location: %s", ReturnName(playerid), pData[playerid][pPhone], GetLocation(x, y, z));
                format(String, sizeof(String), "[Description]: "WHITE_E"%s", text);
				SendFactionMessage(5, COLOR_PINK, String);
			}
		}
		DeletePVar(playerid, "511");
		return 0;
	}
	/*new sgm[128];
	foreach(new i : Player)
	if(pData[playerid][pUsingWT] == 1)
   	{
        if(pData[i][pWT] == pData[playerid][pWT])
        {
			SendClientMessageEx(i, COLOR_LIME, "[WT:%d] "YELLOW_E"%s: %s", pData[playerid][pWT], ReturnName(playerid), text);
			format(sgm, sizeof(sgm), "[<WT>]\n* %s *", sgm);
			SetPlayerChatBubble(i, sgm, COLOR_LBLUE, 5.0, 5000);
        }
	}*/
	if(pData[playerid][pCall] != INVALID_PLAYER_ID)
	{
		if(Terhubung[playerid] == 1)
		{
			UpperToLower(text);
			new lstr[1024];
			format(lstr, sizeof(lstr), "(cellphone) %s says: %s", ReturnName(playerid), text);
			ProxDetector(10, playerid, lstr, 0xE6E6E6E6, 0xC8C8C8C8, 0xAAAAAAAA, 0x8C8C8C8C, 0x6E6E6E6E);
			if(pData[playerid][pMaskOn] == 0)
			{
				SetPlayerChatBubble(playerid, text, COLOR_PINK, 10.0, 3000);
			}
			
			SendClientMessageEx(pData[playerid][pCall], COLOR_PINK, "[CELLPHONE] "WHITE_E"%s.", text);
		}
		else SendMessageInChat(playerid, text);
		return 0;
	}
	else SendMessageInChat(playerid, text);
	return 0;
}

public OnPlayerCommandPerformed(playerid, cmd[], params[], result, flags)
{
    if (result == -1)
    {
        Error(playerid, "the command '/%s' not registered on the server see '(/help)'.", cmd);
        return 0;
    }
	printf("[CMD]: %s(%d) has used the command '%s' (%s)", pData[playerid][pName], playerid, cmd, params);
	//dc
    new name[MAX_PLAYER_NAME + 1];
    GetPlayerName(playerid, name, sizeof name);

    return 1;
}//
public OnPlayerClickPlayerTextDraw(playerid, PlayerText:playertextid)
{	
	if (playertextid == PHANGKAT[10][playerid])
	{
		callcmd::p(playerid);
		return 1;
	}
	if (playertextid == PHANGKAT[11][playerid])
	{
		hungup(playerid);
		return 1;
	}
	if (playertextid == REJECT[playerid])
	{
		hungup(playerid);
		return 1;
	}
	if (playertextid == LOGINTD[12][playerid])
	{
		new string[512];
		format(string, sizeof string, "{FFFF00}Selamat datang kembali di Capitaliz Roleplay\n{FFFFFF}Account kamu: {00FF00}%s\n{FFFFFF}Masukan Password:", pData[playerid][pName]);
		ShowPlayerDialog(playerid, DIALOG_LOGIN, DIALOG_STYLE_PASSWORD, "Login - Panel", string, "Login", "Abort");
		CancelSelectTextDraw(playerid);
		return 1;
	}
	if (playertextid == WT2[playerid])
	{
		new mstr[128];
		format(mstr, sizeof(mstr), "Input Freq Untuk Set Freq.");
		ShowPlayerDialog(playerid, DIALOG_SETFREQ, DIALOG_STYLE_INPUT, "Set Freq", mstr, "Input", "Cancel");
		return 1;
	}
	//MDCTD
	if (playertextid == CLICKPH[playerid])
    {
    	new mstr[128];
    	format(mstr, sizeof(mstr), "Input Phone Number to Track.");
		ShowPlayerDialog(playerid, DIALOG_TRACK_PH, DIALOG_STYLE_INPUT, "Track Phone", mstr, "Track", "Cancel");
		return 1;
	}
	if (playertextid == CLICKNAME[playerid])
	{
		new mstr[128];
		format(mstr, sizeof(mstr), "Input id player to check.");
		ShowPlayerDialog(playerid, DIALOG_CHECK_NAME, DIALOG_STYLE_INPUT, "Name Check", mstr, "Track", "Cancel");
		return 1;
	}
	if (playertextid == CLICKCLOSE[playerid])
    {
    	PlayerTextDrawHide(playerid, MDCTD0[playerid]);
		PlayerTextDrawHide(playerid, MDCTD1[playerid]);
		PlayerTextDrawHide(playerid, MDCTD2[playerid]);
		PlayerTextDrawHide(playerid, MDCTD3[playerid]);
		PlayerTextDrawHide(playerid, MDCTD4[playerid]);
		PlayerTextDrawHide(playerid, CLICKPH[playerid]);
		PlayerTextDrawHide(playerid, MDCTD6[playerid]);
		PlayerTextDrawHide(playerid, MDCTD7[playerid]);
		PlayerTextDrawHide(playerid, MDCTD8[playerid]);
		PlayerTextDrawHide(playerid, MDCTD9[playerid]);
		PlayerTextDrawHide(playerid, MDCTD10[playerid]);
		PlayerTextDrawHide(playerid, MDCTD11[playerid]);
		PlayerTextDrawHide(playerid, MDCTD12[playerid]);
		PlayerTextDrawHide(playerid, MDCTD13[playerid]);
		PlayerTextDrawHide(playerid, CLICKNAME[playerid]);
		PlayerTextDrawHide(playerid, MDCTD16[playerid]);
		PlayerTextDrawHide(playerid, CLICKCLOSE[playerid]);
		PlayerTextDrawHide(playerid, MDCTD20[playerid]);
		PlayerTextDrawHide(playerid, MDCTD21[playerid]);
		PlayerTextDrawHide(playerid, MDCTD22[playerid]);
		PlayerTextDrawHide(playerid, MDCTD23[playerid]);
		PlayerTextDrawHide(playerid, MDCTD24[playerid]);
		PlayerTextDrawHide(playerid, MDCTD25[playerid]);
		PlayerTextDrawHide(playerid, MDCTD26[playerid]);
		PlayerTextDrawHide(playerid, MDCTD27[playerid]);
		CancelSelectTextDraw(playerid);
    	return 1;
    }
    //GOINGTO 2NDPAGE
	if (playertextid == BankTD23[playerid])
    {

		PlayerTextDrawHide(playerid, BankTD5[playerid]);
		PlayerTextDrawHide(playerid, BankTD6[playerid]);
		PlayerTextDrawHide(playerid, BankTD7[playerid]);
		PlayerTextDrawHide(playerid, BankTD8[playerid]);
		PlayerTextDrawHide(playerid, BankTD9[playerid]);
		PlayerTextDrawHide(playerid, BankTD10[playerid]);
		PlayerTextDrawHide(playerid, BankTD11[playerid]);
		PlayerTextDrawShow(playerid, BankTD12[playerid]);
		PlayerTextDrawShow(playerid, BankTD13[playerid]);
		PlayerTextDrawShow(playerid, BankTD14[playerid]);
		PlayerTextDrawShow(playerid, BankTD15[playerid]);
		PlayerTextDrawShow(playerid, BankTD16[playerid]);
		PlayerTextDrawShow(playerid, BankTD17[playerid]);
		PlayerTextDrawShow(playerid, BankTD18[playerid]);
		PlayerTextDrawShow(playerid, BankTD19[playerid]);
        PlayerTextDrawShow(playerid, BankTD20[playerid]);
        PlayerTextDrawShow(playerid, BankTD21[playerid]);
        PlayerTextDrawShow(playerid, BankTD22[playerid]);
        PlayerTextDrawShow(playerid, BankTD23[playerid]);
		pData[playerid][pToggleAtm] = 0;
        return 1;
    }
    //DEPOSIT
	if (playertextid == BankTD15[playerid])
    {
		pData[playerid][pToggleAtm] = 0;
		PlayerTextDrawHide(playerid, BankTD0[playerid]);
		PlayerTextDrawHide(playerid, BankTD1[playerid]);
		PlayerTextDrawHide(playerid, BankTD2[playerid]);
		PlayerTextDrawHide(playerid, BankTD3[playerid]);
		PlayerTextDrawHide(playerid, BankTD4[playerid]);
		PlayerTextDrawHide(playerid, BankTD5[playerid]);
		PlayerTextDrawHide(playerid, BankTD6[playerid]);
		PlayerTextDrawHide(playerid, BankTD7[playerid]);
		PlayerTextDrawHide(playerid, BankTD8[playerid]);
		PlayerTextDrawHide(playerid, BankTD9[playerid]);
		PlayerTextDrawHide(playerid, BankTD10[playerid]);
		PlayerTextDrawHide(playerid, BankTD11[playerid]);
		PlayerTextDrawHide(playerid, BankTD12[playerid]);
		PlayerTextDrawHide(playerid, BankTD13[playerid]);
		PlayerTextDrawHide(playerid, BankTD14[playerid]);
		PlayerTextDrawHide(playerid, BankTD15[playerid]);
		PlayerTextDrawHide(playerid, BankTD16[playerid]);
		PlayerTextDrawHide(playerid, BankTD17[playerid]);
		PlayerTextDrawHide(playerid, BankTD18[playerid]);
		PlayerTextDrawHide(playerid, BankTD19[playerid]);
		PlayerTextDrawHide(playerid, BankTD20[playerid]);
		PlayerTextDrawHide(playerid, BankTD21[playerid]);
		PlayerTextDrawHide(playerid, BankTD22[playerid]);
		PlayerTextDrawHide(playerid, BankTD23[playerid]);

		ShowDialogToPlayer(playerid, DIALOG_BANKDEPOSIT);
		CancelSelectTextDraw(playerid);
        return 1;
    }
	//WITHDRAW
	if (playertextid == BankTD16[playerid])
    {
		pData[playerid][pToggleAtm] = 0;
		PlayerTextDrawHide(playerid, BankTD0[playerid]);
		PlayerTextDrawHide(playerid, BankTD1[playerid]);
		PlayerTextDrawHide(playerid, BankTD2[playerid]);
		PlayerTextDrawHide(playerid, BankTD3[playerid]);
		PlayerTextDrawHide(playerid, BankTD4[playerid]);
		PlayerTextDrawHide(playerid, BankTD5[playerid]);
		PlayerTextDrawHide(playerid, BankTD6[playerid]);
		PlayerTextDrawHide(playerid, BankTD7[playerid]);
		PlayerTextDrawHide(playerid, BankTD8[playerid]);
		PlayerTextDrawHide(playerid, BankTD9[playerid]);
		PlayerTextDrawHide(playerid, BankTD10[playerid]);
		PlayerTextDrawHide(playerid, BankTD11[playerid]);
		PlayerTextDrawHide(playerid, BankTD12[playerid]);
		PlayerTextDrawHide(playerid, BankTD13[playerid]);
		PlayerTextDrawHide(playerid, BankTD14[playerid]);
		PlayerTextDrawHide(playerid, BankTD15[playerid]);
		PlayerTextDrawHide(playerid, BankTD16[playerid]);
		PlayerTextDrawHide(playerid, BankTD17[playerid]);
		PlayerTextDrawHide(playerid, BankTD18[playerid]);
		PlayerTextDrawHide(playerid, BankTD19[playerid]);
		PlayerTextDrawHide(playerid, BankTD20[playerid]);
		PlayerTextDrawHide(playerid, BankTD21[playerid]);
		PlayerTextDrawHide(playerid, BankTD22[playerid]);
		PlayerTextDrawHide(playerid, BankTD23[playerid]);

		ShowDialogToPlayer(playerid, DIALOG_BANKWITHDRAW);
		CancelSelectTextDraw(playerid);
        return 1;
    }
	//TRANSFER
	if (playertextid == BankTD17[playerid])
    {
		pData[playerid][pToggleAtm] = 0;
		PlayerTextDrawHide(playerid, BankTD0[playerid]);
		PlayerTextDrawHide(playerid, BankTD1[playerid]);
		PlayerTextDrawHide(playerid, BankTD2[playerid]);
		PlayerTextDrawHide(playerid, BankTD3[playerid]);
		PlayerTextDrawHide(playerid, BankTD4[playerid]);
		PlayerTextDrawHide(playerid, BankTD5[playerid]);
		PlayerTextDrawHide(playerid, BankTD6[playerid]);
		PlayerTextDrawHide(playerid, BankTD7[playerid]);
		PlayerTextDrawHide(playerid, BankTD8[playerid]);
		PlayerTextDrawHide(playerid, BankTD9[playerid]);
		PlayerTextDrawHide(playerid, BankTD10[playerid]);
		PlayerTextDrawHide(playerid, BankTD11[playerid]);
		PlayerTextDrawHide(playerid, BankTD12[playerid]);
		PlayerTextDrawHide(playerid, BankTD13[playerid]);
		PlayerTextDrawHide(playerid, BankTD14[playerid]);
		PlayerTextDrawHide(playerid, BankTD15[playerid]);
		PlayerTextDrawHide(playerid, BankTD16[playerid]);
		PlayerTextDrawHide(playerid, BankTD17[playerid]);
		PlayerTextDrawHide(playerid, BankTD18[playerid]);
		PlayerTextDrawHide(playerid, BankTD19[playerid]);
		PlayerTextDrawHide(playerid, BankTD20[playerid]);
		PlayerTextDrawHide(playerid, BankTD21[playerid]);
		PlayerTextDrawHide(playerid, BankTD22[playerid]);
		PlayerTextDrawHide(playerid, BankTD23[playerid]);

		ShowDialogToPlayer(playerid, DIALOG_BANKREKENING);
		CancelSelectTextDraw(playerid);
        return 1;
    }
    //atm
    if(playertextid == BankT[playerid][2])
	{
		HideBank1(playerid);
		ShowBank(playerid);
		SCM(playerid, COLOR_GREEN, "Your Fingerprints has succesfully confirm. You Have now Access To Your Bank Account");
	}
	if(playertextid == BankTD[playerid][9])
	{
		if(pData[playerid][pBankMoney] < 10000) return Error(playerid, "Saldo Bank Anda Tidak Mencukupi");
        pData[playerid][pBankMoney] -= 10000;
        GivePlayerMoneyEx(playerid, 10000);
        Info(playerid, "You have withdrawn $100,00 from your account. Your new balance is $%i.", pData[playerid][pBankMoney]);
    }
    if(playertextid == BankTD[playerid][23])
	{
        DisplayPaycheck(playerid);
    }
    if(playertextid == BankTD[playerid][11])
	{
        if(pData[playerid][pBankMoney] < 50000) return Error(playerid, "Saldo Bank Anda Tidak Mencukupi");
        pData[playerid][pBankMoney] -= 50000;
        GivePlayerMoneyEx(playerid, 50000);
        Info(playerid, "You have withdrawn $500,00 from your account. Your new balance is $%i.", pData[playerid][pBankMoney]);
    }
	if(playertextid == BankTD[playerid][13])
	{
        if(pData[playerid][pBankMoney] < 100000) return Error(playerid, "Saldo Bank Anda Tidak Mencukupi");
        pData[playerid][pBankMoney] -= 100000;
        GivePlayerMoneyEx(playerid, 100000);
        Info(playerid, "You have withdrawn $1000,00 from your account. Your new balance is $%i.", pData[playerid][pBankMoney]);
    }
	if(playertextid == BankTD[playerid][19])
	{
        ShowDialogToPlayer(playerid, DIALOG_BANKDEPOSIT);
    }
	if(playertextid == BankTD[playerid][20])
	{
        ShowDialogToPlayer(playerid, DIALOG_BANKWITHDRAW);
    }
	if(playertextid == BankTD[playerid][21])
	{
        ShowDialogToPlayer(playerid, DIALOG_BANKREKENING);
    }
    if(playertextid == BankTD[playerid][25])
	{
		HideBank(playerid);
		CancelSelectTextDraw(playerid);
	}
	if(playertextid == phTextD[20][playerid])
    {
        PlayerPlaySound(playerid, 1058, 0, 0, 0);
		strcat(EnteredPhoneNumb[playerid], "1");
		PlayerTextDrawSetString(playerid, phTextD[5][playerid], EnteredPhoneNumb[playerid]);
    }

    if(playertextid == phTextD[21][playerid])
    {
        PlayerPlaySound(playerid, 1058, 0, 0, 0);
		strcat(EnteredPhoneNumb[playerid], "2");
		PlayerTextDrawSetString(playerid, phTextD[5][playerid], EnteredPhoneNumb[playerid]);
    }

    if(playertextid == phTextD[22][playerid])
    {
        PlayerPlaySound(playerid, 1058, 0, 0, 0);
		strcat(EnteredPhoneNumb[playerid], "3");
		PlayerTextDrawSetString(playerid, phTextD[5][playerid], EnteredPhoneNumb[playerid]);
    }

    if(playertextid == phTextD[23][playerid])
    {
        PlayerPlaySound(playerid, 1058, 0, 0, 0);
       	strcat(EnteredPhoneNumb[playerid], "4");
       	PlayerTextDrawSetString(playerid, phTextD[5][playerid], EnteredPhoneNumb[playerid]);
    }

    if(playertextid == phTextD[24][playerid])
    {
        PlayerPlaySound(playerid, 1058, 0, 0, 0);
       	strcat(EnteredPhoneNumb[playerid], "5");
       	PlayerTextDrawSetString(playerid, phTextD[5][playerid], EnteredPhoneNumb[playerid]);
    }

    if(playertextid == phTextD[25][playerid])
    {
        PlayerPlaySound(playerid, 1058, 0, 0, 0);
       	strcat(EnteredPhoneNumb[playerid], "6");
       	PlayerTextDrawSetString(playerid, phTextD[5][playerid], EnteredPhoneNumb[playerid]);
    }

    if(playertextid == phTextD[26][playerid])
    {
        PlayerPlaySound(playerid, 1058, 0, 0, 0);
       	strcat(EnteredPhoneNumb[playerid], "7");
       	PlayerTextDrawSetString(playerid, phTextD[5][playerid], EnteredPhoneNumb[playerid]);
    }

    if(playertextid == phTextD[27][playerid])
    {
        PlayerPlaySound(playerid, 1058, 0, 0, 0);
       	strcat(EnteredPhoneNumb[playerid], "8");
       	PlayerTextDrawSetString(playerid, phTextD[5][playerid], EnteredPhoneNumb[playerid]);
    }

    if(playertextid == phTextD[28][playerid])
    {
        PlayerPlaySound(playerid, 1058, 0, 0, 0);
       	strcat(EnteredPhoneNumb[playerid], "9");
    	PlayerTextDrawSetString(playerid, phTextD[5][playerid], EnteredPhoneNumb[playerid]);
    }

    if(playertextid == phTextD[29][playerid])
    {
        PlayerPlaySound(playerid, 1058, 0, 0, 0);
        strcat(EnteredPhoneNumb[playerid], "0");
    	PlayerTextDrawSetString(playerid, phTextD[5][playerid], EnteredPhoneNumb[playerid]);
    }

    if(playertextid == phTextD[30][playerid])
    {
		new numbs = strlen(EnteredPhoneNumb[playerid]);

        if(numbs == 1) strdel(EnteredPhoneNumb[playerid], 0, 1);
        if(numbs == 2) strdel(EnteredPhoneNumb[playerid], 1, 2);
        if(numbs == 3) strdel(EnteredPhoneNumb[playerid], 2, 3);
        if(numbs == 4) strdel(EnteredPhoneNumb[playerid], 3, 4);
        if(numbs == 5) strdel(EnteredPhoneNumb[playerid], 4, 5);
        if(numbs == 6) strdel(EnteredPhoneNumb[playerid], 5, 6);

        PlayerPlaySound(playerid, 1137, 0, 0, 0);
    	PlayerTextDrawSetString(playerid, phTextD[5][playerid], EnteredPhoneNumb[playerid]);
    }

    if(playertextid == phTextD[31][playerid])
    {
		if(!CallingNum[playerid])
		{
			PlayerPlaySound(playerid, 3600, 0, 0, 0);
			CallingNum[playerid] = true;

			PlayerTextDrawSetString(playerid, phTextD[5][playerid], "Dialing");
			PlayerTextDrawSetString(playerid, phTextD[31][playerid], "~r~h");
		}

		else if(CallingNum[playerid])
		{
        	PlayerPlaySound(playerid, 1058, 0, 0, 0);
			CallingNum[playerid] = false;

			PlayerTextDrawSetString(playerid, phTextD[5][playerid], EnteredPhoneNumb[playerid]);
			PlayerTextDrawSetString(playerid, phTextD[31][playerid], "~g~c");
		}

    }
    if(playertextid == EditVObjTD[playerid][4])
    {
    	if(IsPlayerInAnyVehicle(playerid))
    	{
    		HideEditVehicleTD(playerid);
    		new x = GetPlayerVehicleID(playerid);
    		foreach(new i: PVehicles)
			{
				if(x == pvData[i][cVeh])
				{
    				MySQL_SaveVehicleToys(i);
    			}
    		}
    	}
    }
    else if(playertextid == EditVObjTD[playerid][6])
    {
    	HideEditVehicleTD(playerid);
    	Info(playerid, "You has canceled edit vehicle toys position");
    }
    else if(playertextid == EditVObjTD[playerid][2])
    {
    	AddVObjPos(playerid);
    }
    else if(playertextid == EditVObjTD[playerid][3])
    {
    	SubVObjPos(playerid);
    }
    else if(playertextid == EditVObjTD[playerid][7])
    {
    	ShowPlayerDialog(playerid, VTOYSET_VALUE, DIALOG_STYLE_INPUT, "Vehicle Toy PosX", "Set current float value\nNormal Value = 0.05\n\nEnter Float NudgeValue in here:", "Edit", "Cancel");
    }
    else if(playertextid == ToysTDsave[playerid])
    {
    	HideEditToysTD(playerid);
    	SetPVarInt(playerid, "UpdatedToy", 1);
    	Info(playerid, "You has saved toys position");
    }
    else if(playertextid == ToysTDup[playerid])
    {
    	AddTObjPos(playerid);
    }
    else if(playertextid == ToysTDdown[playerid])
    {
    	SubTObjPos(playerid);
    }
    else if(playertextid == ToysTDedit[playerid])
    {
    	ShowPlayerDialog(playerid, TOYSET_VALUE, DIALOG_STYLE_INPUT, "Vehicle Toy PosX", "Set current float value\nNormal Value = 0.05\n\nEnter Float NudgeValue in here:", "Edit", "Cancel");
    }
    return 1;
}

public OnPlayerClickMap(playerid, Float:fX, Float:fY, Float:fZ)
{
	if(pData[playerid][pAdminDuty])
	{
        new vehicleid = GetPlayerVehicleID(playerid);
        if(vehicleid > 0 && GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
        {
            SetVehiclePos(vehicleid, fX, fY, fZ+10);
        }
        else
        {
           	SetPlayerPosFindZ(playerid, fX, fY, 999.0);
            SetPlayerVirtualWorld(playerid, 0);
            SetPlayerInterior(playerid, 0);
        }
        Info(playerid, "Teleport to : %f, %f, %f", fX, fY, fZ);
	}
    return 1;
}

public OnPlayerCommandReceived(playerid, cmd[], params[], flags)
{
	return 1;
}
public OnPlayerCommandText(playerid, cmdtext[])
{
	if (!strcmp(cmdtext, "/pcmds"))
	{
		SendClientMessage(playerid, 0x12FF12AA, "/pwork for work, /pwstop for stopping work, /phelp for some help.");
		return 1;
	}
	if (!strcmp(cmdtext, "/pwork"))
	{
		if(IsPlayerInAnyVehicle(playerid))
		{
			new strin[45];
 			format(strin, sizeof(strin), "%i, %i, %i", pilotvehs[0], pilotvehs[1], pilotvehs[2]);
 			SendClientMessage(playerid, -1, strin);
 			new bool:IsPassing[MAX_PLAYERS] = false;
 			for (new o; o < 9; o++)
			{
    			if(GetVehicleModel(GetPlayerVehicleID(playerid)) == pilotvehs[o])
				{
					// 476 Rustler
					rands = random(sizeof(RandomCPs));
    				SendClientMessage(playerid, 0x34AA33AA, "As you were in your plane. An airport officer noticed you then he approached you.");
	 				cp[playerid] = SetPlayerCheckpoint(playerid, RandomCPs[rands][0],RandomCPs[rands][1],RandomCPs[rands][2], 5.0);

	 				TakingPs[playerid] = 1;
	 				IsPassing[playerid] = true;
	 				return 1;
				}
			}
   			if(IsPassing[playerid] == false) {
			    SendClientMessage(playerid, 0xFF6347AA, "Please use planes. Hydra and Rustler not included in planes category.");
			}
		}
		else
		{
			SendClientMessage(playerid, 0xFF6347AA, "Please get in a plane and then start your work.");
		}
		return 1;
	}


	if(!strcmp(cmdtext, "/phelp"))
	{
	    new phstr[256];
	    format(phstr, sizeof(phstr),  "If you want to became a pilot then worry not we have\n some thing for you, just get in a plane and use /pwork.\n While you are doing your work you will also be \ngiven your payment it is %i per trip. So, have fun and fly just\n one.In last, use /pwstop to stop.", WorkBucks);
	    ShowPlayerDialog(playerid, PH_D, DIALOG_STYLE_MSGBOX, "Pilots Work Help", phstr, "OK", "Cancel");
	    return 1;
	}

	if(!strcmp(cmdtext, "/pwstop"))
	{
		SendClientMessage(playerid, 0xFFFF00AA, "He said: OK! you are out of duty. Have fun in your life.");
	    DestroyDynamicCP(cp[playerid]);
	    TakingPs[playerid] = 2;
	    return 1;
	}
	return 0;
}
public OnPlayerConnect(playerid)
{
	new hour, minute;
	gettime(hour, minute);
	online++;
	TotalConnect++;
	togtextdraws[playerid] = 0;
	PlayAudioStreamForPlayer(playerid, "http://a.top4top.io/m_2645f71320.mp3");
	new PlayerIP[16]; // country[MAX_COUNTRY_LENGTH], city[MAX_CITY_LENGTH];
	g_MysqlRaceCheck[playerid]++;

	ResetVariables(playerid);
	CreatePlayerTextDraws(playerid);

	GetPlayerName(playerid, pData[playerid][pName], MAX_PLAYER_NAME);
	GetPlayerIp(playerid, PlayerIP, sizeof(PlayerIP));
	pData[playerid][pIP] = PlayerIP;

	//GetPlayerCountry(playerid, country, MAX_COUNTRY_LENGTH);
	//GetPlayerCity(playerid, city, MAX_CITY_LENGTH);

	SetTimerEx("SafeLogin", 5000, 0, "i", playerid);

	new query[103];
	mysql_format(g_SQL, query, sizeof query, "SELECT * FROM `players` WHERE `username` = '%e' LIMIT 1", pData[playerid][pName]);
	mysql_pquery(g_SQL, query, "OnPlayerDataLoaded", "dd", playerid, g_MysqlRaceCheck[playerid]);
	SetPlayerColor(playerid, COLOR_WHITE);

	//---[ Function ]---
	SedangHauling[playerid] = 0;
	DeletePVar(playerid,"MeatCheck");
	pPurchaseCargoSeed[playerid] = 0;
	pPurchaseCargoMeat[playerid] = 0;
	SedangAnterPizza[playerid] = 0;
	AFK[playerid] = 0;
	//ConnectedToPC[playerid] = 0;
	pCargo[playerid] = 0;
	IsAtEvent[playerid] = 0;
	PlayerPBing[playerid] = false;
	player_ship_worked[playerid] = false;
    PlayerPBKills[playerid] = 0;
    pData[playerid][pToggleAtm] = 0;
    pData[playerid][pToggleWT] = 0;
    format(advertise[playerid], 128, "None");
  	pData[playerid][pStockBodyCondition][0] = 1;
    pData[playerid][pStockBodyCondition][1] = 1;
    pData[playerid][pStockBodyCondition][2] = 1;
    pData[playerid][pStockBodyCondition][3] = 1;
    pData[playerid][pStockBodyCondition][4] = 1;
    pData[playerid][pStockBodyCondition][5] = 1;
    //cctv
    editMode[playerid] = 0;
	editId[playerid] = -1;
    //taser gun
    taser[playerid] = false;
    GiveTaserAgainTimer[playerid] = 0;
    //stop ani
    for(new i = 0; i < 3; i++)
  	{
    	StopaniFloats[playerid][i] = 0;
  	}
    //train
  	SetPlayerSkillLevel(playerid, WEAPON_COLT45, 1);
	SetPlayerSkillLevel(playerid, WEAPON_SILENCED, 1);
	SetPlayerSkillLevel(playerid, WEAPON_DEAGLE, 1);
	SetPlayerSkillLevel(playerid, WEAPON_SHOTGUN, 1);
	SetPlayerSkillLevel(playerid, WEAPON_SAWEDOFF, 1);
	SetPlayerSkillLevel(playerid, WEAPON_SHOTGSPA, 1);
	SetPlayerSkillLevel(playerid, WEAPON_UZI, 1);
	SetPlayerSkillLevel(playerid, WEAPON_MP5, 1);
	SetPlayerSkillLevel(playerid, WEAPON_AK47, 1);
	SetPlayerSkillLevel(playerid, WEAPON_M4, 1);
	SetPlayerSkillLevel(playerid, WEAPON_TEC9, 1);
	SetPlayerSkillLevel(playerid, WEAPON_RIFLE, 1);
	SetPlayerSkillLevel(playerid, WEAPON_SNIPER, 1);
	//---------
	Trash_InitPlayer(playerid);
	//--------------------
 	new fmt_join[128];
	foreach(new ii : Player)
	{
		if(pData[ii][pTogLog] == 0)
		{
			SendClientMessageEx(ii, COLOR_PINK, " JOIN: {FFFFFF}%s (%d) {FFFFFF}Telah Masuk Kedalam Kota Capitaliz Roleplay. ", pData[playerid][pName], playerid);
		}
	}
 	format(fmt_join, sizeof fmt_join, "```[JOIN] %s (%d) Telah Masuk Kedalam Kota Capitaliz Roleplay```",  pData[playerid][pName], playerid);
    DCC_SendChannelMessage(g_discord_logs, fmt_join);
	pData[playerid][activitybar] = CreatePlayerProgressBar(playerid, 281.000000, 136.000000, 88.000000, 10.500000, -1061109611, 100, 0);
 	//HBE textdraw Modern
	pData[playerid][damagebar] = CreatePlayerProgressBar(playerid, 386.000000, 441.000000, 7.000000, 78.000000, -16776961, 1000.0, 2);
	pData[playerid][fuelbar] = CreatePlayerProgressBar(playerid, 405.000000, 440.000000, 7.000000, 78.000000, -16776961, 1000.0, 2);

	pData[playerid][hungrybar] = CreatePlayerProgressBar(playerid, 632.000000, 377.000000, 62.000000, 4.000000, 16711935, 100.0, 1);
	pData[playerid][energybar] = CreatePlayerProgressBar(playerid, 632.000000, 398.000000, 62.000000, 4.000000, 16711935, 100.0, 1);
	//pData[playerid][bladdybar] = CreatePlayerProgressBar(playerid, 632.000000, 417.000000, 62.000000, 4.000000, 16711935, 100.0, 1);

	//Textdraw Mode
	pData[playerid][BarHp] = CreatePlayerProgressBar(playerid, 523.000000, 150.000000, 85.500000, 6.500000, -16776961, 100.0, 0);
	pData[playerid][BarArmour] = CreatePlayerProgressBar(playerid, 523.000000, 167.000000, 85.500000, 6.500000, -1, 100.0, 0);

	if(pData[playerid][pHead] < 0) return pData[playerid][pHead] = 20;

    if(pData[playerid][pPerut] < 0) return pData[playerid][pPerut] = 20;

    if(pData[playerid][pRFoot] < 0) return pData[playerid][pRFoot] = 20;

    if(pData[playerid][pLFoot] < 0) return pData[playerid][pLFoot] = 20;

    if(pData[playerid][pLHand] < 0) return pData[playerid][pLHand] = 20;
   
    if(pData[playerid][pRHand] < 0) return pData[playerid][pRHand] = 20;

	//cent money
	//Server Cent
    Cent[0] = TextDrawCreate(580.000000, 54.000000, ".");
	TextDrawFont(Cent[0], 2);
	TextDrawLetterSize(Cent[0], 0.924999, 5.700003);
	TextDrawTextSize(Cent[0], 400.000000, 17.000000);
	TextDrawSetOutline(Cent[0], 1);
	TextDrawSetShadow(Cent[0], 0);
	TextDrawAlignment(Cent[0], 1);
	TextDrawColor(Cent[0], 6553855);
	TextDrawBackgroundColor(Cent[0], 255);
	TextDrawBoxColor(Cent[0], 50);
	TextDrawUseBox(Cent[0], 0);
	TextDrawSetProportional(Cent[0], 1);
	TextDrawSetSelectable(Cent[0], 0);

	Cent[1] = TextDrawCreate(542.000000, 75.000000, ",");
	TextDrawFont(Cent[1], 2);
	TextDrawLetterSize(Cent[1], 0.745832, 2.849998);
	TextDrawTextSize(Cent[1], 400.000000, 17.000000);
	TextDrawSetOutline(Cent[1], 1);
	TextDrawSetShadow(Cent[1], 0);
	TextDrawAlignment(Cent[1], 1);
	TextDrawColor(Cent[1], 6553855);
	TextDrawBackgroundColor(Cent[1], 255);
	TextDrawBoxColor(Cent[1], 50);
	TextDrawUseBox(Cent[1], 0);
	TextDrawSetProportional(Cent[1], 1);
	TextDrawSetSelectable(Cent[1], 0);

	TextDrawShowForPlayer(playerid, Cent[0]);
	TextDrawShowForPlayer(playerid, Cent[1]);

	DigiHP[playerid] = TextDrawCreate(614.000000, 177.000000, "100");
	TextDrawFont(DigiHP[playerid], 2);
	TextDrawLetterSize(DigiHP[playerid], 0.241666, 0.899999);
	TextDrawTextSize(DigiHP[playerid], 400.000000, 17.000000);
	TextDrawSetOutline(DigiHP[playerid], 1);
	TextDrawSetShadow(DigiHP[playerid], 0);
	TextDrawAlignment(DigiHP[playerid], 2);
	TextDrawColor(DigiHP[playerid], -1);
	TextDrawBackgroundColor(DigiHP[playerid], 255);
	TextDrawBoxColor(DigiHP[playerid], 50);
	TextDrawUseBox(DigiHP[playerid], 0);
	TextDrawSetProportional(DigiHP[playerid], 1);
	TextDrawSetSelectable(DigiHP[playerid], 0);

	DigiAP[playerid] = TextDrawCreate(614.000000, 194.000000, "100");
	TextDrawFont(DigiAP[playerid], 2);
	TextDrawLetterSize(DigiAP[playerid], 0.241666, 0.899999);
	TextDrawTextSize(DigiAP[playerid], 400.000000, 17.000000);
	TextDrawSetOutline(DigiAP[playerid], 1);
	TextDrawSetShadow(DigiAP[playerid], 0);
	TextDrawAlignment(DigiAP[playerid], 2);
	TextDrawColor(DigiAP[playerid], -1);
	TextDrawBackgroundColor(DigiAP[playerid], 255);
	TextDrawBoxColor(DigiAP[playerid], 50);
	TextDrawUseBox(DigiAP[playerid], 0);
	TextDrawSetProportional(DigiAP[playerid], 1);
	TextDrawSetSelectable(DigiAP[playerid], 0);

	//PlayAudioStreamForPlayer(playerid, "");
	RemoveVendingMachines(playerid);
	ObjectDelete(playerid);
    //------------------------------------------------------------------------------------------
    Warning[playerid] = 0;
    VehicleLastEnterTime[playerid] = 0;

    pData[playerid][pInjuredLabel] = CreateDynamic3DTextLabel("", COLOR_LIGHTGREEN, 0.0, 0.0, -0.3, 10, .attachedplayer = playerid, .testlos = 1);

    if(pData[playerid][pHead] < 0) return pData[playerid][pHead] = 20;

    if(pData[playerid][pPerut] < 0) return pData[playerid][pPerut] = 20;

    if(pData[playerid][pRFoot] < 0) return pData[playerid][pRFoot] = 20;

    if(pData[playerid][pLFoot] < 0) return pData[playerid][pLFoot] = 20;

    if(pData[playerid][pLHand] < 0) return pData[playerid][pLHand] = 20;
   
    if(pData[playerid][pRHand] < 0) return pData[playerid][pRHand] = 20;
	return 1;
}

public OnPlayerDisconnect(playerid, reason)
{
    online--;
    //pb
	if(PlayerPBing[playerid] == true)
	{
		PBPlayers--;
	}
	//end
    new name[MAX_PLAYER_NAME + 1];
    GetPlayerName(playerid, name, sizeof name);

    if(pData[playerid][pPacket] == 1)
    {
        taked = 0;
        pData[playerid][pPacket]--;
        pCPPacket = INVALID_PLAYER_ID;
        new Float:X, Float:Y, Float:Z;
        GetPlayerPos(playerid, X, Y, Z);
        objectpacket = CreateDynamicObject(11745, X, Y, Z-1, 80.0, 0.0, 0.0, 0);
        taked = 0;
    }

    //injured
    DestroyDynamic3DTextLabel(pData[playerid][pInjuredLabel]);
    //Player_ResetDamageLog(playerid);

	//pilot
	if(TakingPs[playerid] == 1 || TakingPs[playerid] == 0) {
		DestroyDynamicCP(cp[playerid]);
		TakingPs[playerid] = 2;
	}
	//butcher
    if(GetPVarInt(playerid,"InWork"))
	{
	    if(IsValidDynamicObject(playerobject[playerid][0])) DestroyDynamicObject(playerobject[playerid][0]);
	    else if(IsValidDynamicObject(playerobject[playerid][1])) DestroyDynamicObject(playerobject[playerid][1]);
	}
	if(GetPVarType(playerid, "PlacedBB"))
    {
        DestroyDynamicObject(GetPVarInt(playerid, "PlacedBB"));
        DestroyDynamic3DTextLabel(Text3D:GetPVarInt(playerid, "BBLabel"));
        if(GetPVarType(playerid, "BBArea"))
        {
            foreach(new i : Player)
            {
                if(IsPlayerInDynamicArea(i, GetPVarInt(playerid, "BBArea")))
                {
                    StopAudioStreamForPlayer(i);
                    SendClientMessage(i, COLOR_PURPLE, " The boombox creator has disconnected from the server.");
                }
            }
        }
    }
	DestroyObject(ObjetoC[playerid]);
	DestroyObject(ObjetoC1[playerid]);
	DeletePVar(playerid,"InWork");
	DeletePVar(playerid,"MeatCheck");
	DeletePVar(playerid,"BadMeatDel");
	DeletePVar(playerid,"BadMeat");
	DeletePVar(playerid,"OldSkin");
	DeletePVar(playerid,"OnWork");
	TextDrawDestroy(DigiHP[playerid]);
	TextDrawDestroy(DigiAP[playerid]);

	killgr(playerid);
	//trasher
	if(HasTrash[playerid]) Trash_ResetPlayer(playerid);
	//end trasher
	SetPlayerName(playerid, pData[playerid][pName]);

	if(pData[playerid][pSekolahSim] == 1)
	{
		pData[playerid][pSekolahSim] = 0;
		Global[SKM] = 0;
	}
 	if(pData[playerid][pMaskOn] == 1)
 	{
  		DestroyDynamic3DTextLabel(pData[playerid][pMaskLabel]);
	}
	if(IsPlayerInAnyVehicle(playerid))
	{
        RemovePlayerFromVehicle(playerid);
    }
	//UpdateWeapons(playerid);
	g_MysqlRaceCheck[playerid]++;

	if(pData[playerid][IsLoggedIn] == true)
	{
		UpdatePlayerData(playerid);
		RemovePlayerVehicle(playerid);
		for(new v; v < MAX_PLAYER_VEHICLE; ++v)
		{
		    for(new vt = 0; vt < 4; vt++)
		 	{
		 	 	DestroyObject(vtData[v][vt][vtoy_model]);
			}
		}
		//Report_Clear(playerid);
		Ask_Clear(playerid);
		Player_ResetMining(playerid);
		Player_ResetCutting(playerid);
		Player_RemoveLumber(playerid);
		Player_ResetHarvest(playerid);
		KillTazerTimer(playerid);
		if(IsAtEvent[playerid] == 1)
		{
			if(GetPlayerTeam(playerid) == 1)
			{
				if(EventStarted == 1)
				{
					RedTeam -= 1;
					foreach(new ii : Player)
					{
						if(GetPlayerTeam(ii) == 2)
						{
							GivePlayerMoneyEx(ii, EventPrize);
							Servers(ii, "Selamat, Tim Anda berhasil memenangkan Event dan Mendapatkan Hadiah $%d00 per orang", EventPrize);
							SetPlayerPos(ii, pData[playerid][pPosX], pData[playerid][pPosY], pData[playerid][pPosZ]);
							pData[playerid][pHospital] = 0;
							ResetPlayerWeapons(ii);
							SetPlayerColor(ii, COLOR_WHITE);
							ClearAnimations(ii);
							BlueTeam = 0;
						}
						else if(GetPlayerTeam(ii) == 1)
						{
							Servers(ii, "Maaf, Tim anda sudah terkalahkan, Harap Coba Lagi lain waktu");
							SetPlayerPos(ii, pData[playerid][pPosX], pData[playerid][pPosY], pData[playerid][pPosZ]);
							pData[playerid][pHospital] = 0;
							ResetPlayerWeapons(ii);
							SetPlayerColor(ii, COLOR_WHITE);
							ClearAnimations(ii);
							RedTeam = 0;
						}
					}
				}
			}
			if(GetPlayerTeam(playerid) == 2)
			{
				if(EventStarted == 1)
				{
					BlueTeam -= 1;
					foreach(new ii : Player)
					{
						if(GetPlayerTeam(ii) == 1)
						{
							GivePlayerMoneyEx(ii, EventPrize);
							Servers(ii, "Selamat, Tim Anda berhasil memenangkan Event dan Mendapatkan Hadiah $%d00 per orang", EventPrize);
							SetPlayerPos(ii, pData[playerid][pPosX], pData[playerid][pPosY], pData[playerid][pPosZ]);
							pData[playerid][pHospital] = 0;
							ResetPlayerWeapons(ii);
							SetPlayerColor(ii, COLOR_WHITE);
							ClearAnimations(ii);
							BlueTeam = 0;
						}
						else if(GetPlayerTeam(ii) == 2)
						{
							Servers(ii, "Maaf, Tim anda sudah terkalahkan, Harap Coba Lagi lain waktu");
							SetPlayerPos(ii, pData[playerid][pPosX], pData[playerid][pPosY], pData[playerid][pPosZ]);
							pData[playerid][pHospital] = 0;
							ResetPlayerWeapons(ii);
							SetPlayerColor(ii, COLOR_WHITE);
							ClearAnimations(ii);
							BlueTeam = 0;
						}
					}
				}
			}
			SetPlayerTeam(playerid, 0);
			IsAtEvent[playerid] = 0;
			pData[playerid][pInjured] = 0;
			pData[playerid][pSpawned] = 1;
		}
	}
	if(IsValidDynamic3DTextLabel(pData[playerid][pAdoTag]))
            DestroyDynamic3DTextLabel(pData[playerid][pAdoTag]);

	if(IsValidDynamicObject(pData[playerid][pFlare]))
            DestroyDynamicObject(pData[playerid][pFlare]);

    pData[playerid][pAdoActive] = false;

	if(cache_is_valid(pData[playerid][Cache_ID]))
	{
		cache_delete(pData[playerid][Cache_ID]);
		pData[playerid][Cache_ID] = MYSQL_INVALID_CACHE;
	}

	if (pData[playerid][LoginTimer])
	{
		KillTimer(pData[playerid][LoginTimer]);
		pData[playerid][LoginTimer] = 0;
	}

	pData[playerid][IsLoggedIn] = false;

	new Float:x, Float:y, Float:z;
	GetPlayerPos(playerid, x, y, z);

	//hauling tr
	for(new i; i <= 9; i++) // 9 = Total Dialog , Jadi kita mau tau kalau Player Ini Apakah Ambil Dialog dari 3 tersebut apa ga !
	{
		if(DialogSaya[playerid][i] == true) // Cari apakah dia punya salah satu diantara 10 dialog tersebut
		{
		    DialogSaya[playerid][i] = false; // Ubah Jadi Dia ga punya dialog lagi Kalau Udah Disconnect (Bukan dia lagi pemilik)
		    DialogHauling[i] = false; // Jadi ga ada yang punya nih dialog
		    DestroyVehicle(TrailerHauling[playerid]);
		}
	}
	foreach(new ii : Player)
	{
		if(IsPlayerInRangeOfPoint(ii, 40.0, x, y, z))
		{
			switch(reason)
			{
				case 0:
				{
					SendClientMessageEx(ii, COLOR_PINK, "[LEAVE]"WHITE_E" %s(%d) has leave from the server.{FFFF00}(timeout/crash)", pData[playerid][pName], playerid);
				}
				case 1:
				{
					SendClientMessageEx(ii, COLOR_PINK, "[LEAVE]"WHITE_E" %s(%d) has leave from the server.{FFFF00}(leaving)", pData[playerid][pName], playerid);
				}
				case 2:
				{
					SendClientMessageEx(ii, COLOR_RIKO, "[LEAVE]"WHITE_E" %s(%d) has leave from the server.{FFFF00}(kicked/banned)", pData[playerid][pName], playerid);
				}
			}
		}
	}
	Player_Fire_Enabled[playerid] = false;
	Player_Key_Sprint_Time[playerid] = 0;

	return 1;
}

public OnPlayerSpawn(playerid)
{
	if(PlayerPBing[playerid] == true)
	{
	    new RandomSpawn = random(sizeof(PBSpawns));
	    new RandomSkins = random(sizeof(PBSkins));
	    SetPlayerSkin(playerid,PBSkins[RandomSkins]);
		SetPlayerPos(playerid,PBSpawns[RandomSpawn][0],PBSpawns[RandomSpawn][1],PBSpawns[RandomSpawn][2]);
		SetPlayerFacingAngle(playerid,PBSpawns[RandomSpawn][3]);
		SetPlayerHealth(playerid,100.0);
		SetPlayerArmour(playerid,50.0);
		ResetPlayerWeapons(playerid);
		GivePlayerWeapon(playerid,PBGunID,99999);
	}
	SetPlayerFightingStyle(playerid, pData[playerid][pFightStyle]);
	StopAudioStreamForPlayer(playerid);
	SetPlayerInterior(playerid, pData[playerid][pInt]);
	SetPlayerVirtualWorld(playerid, pData[playerid][pWorld]);
	SetPlayerPos(playerid, pData[playerid][pPosX], pData[playerid][pPosY], pData[playerid][pPosZ]);
	SetPlayerFacingAngle(playerid, pData[playerid][pPosA]);
	SetCameraBehindPlayer(playerid);
	TogglePlayerControllable(playerid, 0);
	SetPlayerSpawn(playerid);
	LoadAnims(playerid);
	PreloadAnims(playerid);

	//butcher
	if(GetPVarInt(playerid,"InWork"))
	{
	    if(IsValidDynamicObject(playerobject[playerid][0])) DestroyDynamicObject(playerobject[playerid][0]);
	    else if(IsValidDynamicObject(playerobject[playerid][1])) DestroyDynamicObject(playerobject[playerid][1]);
	    DeletePVar(playerid,"InWork");
	}
	return 1;
}

SetPlayerSpawn(playerid)
{
	if(IsPlayerConnected(playerid))
	{
		if(pData[playerid][pGender] == 0)
		{
			TogglePlayerControllable(playerid,0);
			SetPlayerHealth(playerid, 100.0);
			SetPlayerArmour(playerid, 0.0);
			SetPlayerPos(playerid, 71.3030, -1851.7705, 5.1220);
			SetPlayerJoinCamera(playerid);
			SetPlayerVirtualWorld(playerid, 0);
			ShowPlayerDialog(playerid, DIALOG_AGE, DIALOG_STYLE_INPUT, "Tanggal Lahir", "Masukan tanggal lahir (Tgl/Bulan/Tahun): 15/04/1998", "Enter", "Batal");
		}
		else
		{
			SetPlayerColor(playerid, COLOR_WHITE);
			if(pData[playerid][pHBEMode] == 1) //simple
			{
				ShowSimplePlayerTetxdraw(playerid);
			}
			if(pData[playerid][pHBEMode] == 2) //modern
			{
				ShowPlayerProgressBar(playerid, pData[playerid][hungrybar]);
				ShowPlayerProgressBar(playerid, pData[playerid][energybar]);
				TextDrawShowForPlayer(playerid, CharBox);
				PlayerTextDrawSetPreviewModel(playerid, HBEO[playerid], GetPlayerSkin(playerid));
				PlayerTextDrawShow(playerid, HBEO[playerid]);
				for(new txd; txd < 4; txd++)
				{
					TextDrawShowForPlayer(playerid, HudChar[txd]);
				}
			}
			if(pData[playerid][pHBEMode] == 3)
			{				
				ShowHUD(playerid);
			}
			if(pData[playerid][pTDMode] == 1) //simple
			{
				TextDrawShowForPlayer(playerid, TextDate);
				TextDrawShowForPlayer(playerid, TextTime);
				PlayerTextDrawShow(playerid, LogoB[playerid][0]);
				PlayerTextDrawShow(playerid, LogoB[playerid][1]);
				PlayerTextDrawShow(playerid, LogoB[playerid][2]);
				PlayerTextDrawShow(playerid, LogoB[playerid][3]);
				PlayerTextDrawShow(playerid, LogoB[playerid][4]);
			}
			if(pData[playerid][pTDMode] == 2) //bar
			{
				TextDrawShowForPlayer(playerid, TextDate);
				TextDrawShowForPlayer(playerid, TextTime);
				PlayerTextDrawShow(playerid, LogoB[playerid][0]);
				PlayerTextDrawShow(playerid, LogoB[playerid][1]);
				PlayerTextDrawShow(playerid, LogoB[playerid][2]);
				PlayerTextDrawShow(playerid, LogoB[playerid][3]);
				PlayerTextDrawShow(playerid, LogoB[playerid][4]);
			}
			SetPlayerSkin(playerid, pData[playerid][pSkin]);
			PlayerTextDrawSetString(playerid, Loading[2][playerid], "Loading...");
			for(new i =0 ; i < 3; i++)
			{
				PlayerTextDrawShow(playerid, Loading[i][playerid]);
			}
			pData[playerid][pActivity] = SetTimerEx("LoadingLogin", 100, true, "i", playerid);
			if(pData[playerid][pOnDuty] >= 1)
			{
				SetPlayerSkin(playerid, pData[playerid][pFacSkin]);
				SetFactionColor(playerid);
			}
			if(pData[playerid][pAdminDuty] > 0)
			{
				SetPlayerColor(playerid, COLOR_WHITE);
			}
			SetTimerEx("SpawnTimer", 6000, false, "i", playerid);
		}
	}
}

public OnPlayerModelSelection(playerid, response, listid, modelid)
{
	if(listid == SpawnMale)
    {
		if(response)
		{
			pData[playerid][pSkin] = modelid;
			SetSpawnInfo(playerid, 0, pData[playerid][pSkin], 1642.8126, -2333.4019, 13.5469, 359.7415, 0, 0, 0, 0, 0, 0);
			SpawnPlayer(playerid);
		}
    }
	if(listid == SpawnFemale)
    {
		if(response)
		{
			pData[playerid][pSkin] = modelid;
			SetSpawnInfo(playerid, 0, pData[playerid][pSkin], 1642.8126, -2333.4019, 13.5469, 359.7415, 0, 0, 0, 0, 0, 0);
			SpawnPlayer(playerid);
		}
    }
	//Locker Faction Skin
	if(listid == SAPDMale)
    {
		if(response)
		{
			pData[playerid][pFacSkin] = modelid;
			SetPlayerSkin(playerid, modelid);
			Servers(playerid, "Anda telah mengganti faction skin menjadi ID %d", modelid);
		}
    }
	if(listid == SAPDFemale)
    {
		if(response)
		{
			pData[playerid][pFacSkin] = modelid;
			SetPlayerSkin(playerid, modelid);
			Servers(playerid, "Anda telah mengganti faction skin menjadi ID %d", modelid);
		}
    }
	if(listid == SAPDWar)
    {
		if(response)
		{
			pData[playerid][pFacSkin] = modelid;
			SetPlayerSkin(playerid, modelid);
			Servers(playerid, "Anda telah mengganti faction skin menjadi ID %d", modelid);
		}
    }
	if(listid == SAGSMale)
    {
		if(response)
		{
			pData[playerid][pFacSkin] = modelid;
			SetPlayerSkin(playerid, modelid);
			Servers(playerid, "Anda telah mengganti faction skin menjadi ID %d", modelid);
		}
    }
	if(listid == SAGSFemale)
    {
		if(response)
		{
			pData[playerid][pFacSkin] = modelid;
			SetPlayerSkin(playerid, modelid);
			Servers(playerid, "Anda telah mengganti faction skin menjadi ID %d", modelid);
		}
    }
	if(listid == SAMDMale)
    {
		if(response)
		{
			pData[playerid][pFacSkin] = modelid;
			SetPlayerSkin(playerid, modelid);
			Servers(playerid, "Anda telah mengganti faction skin menjadi ID %d", modelid);
		}
    }
	if(listid == SAMDFemale)
    {
		if(response)
		{
			pData[playerid][pFacSkin] = modelid;
			SetPlayerSkin(playerid, modelid);
			Servers(playerid, "Anda telah mengganti faction skin menjadi ID %d", modelid);
		}
    }
	if(listid == SANEWMale)
    {
		if(response)
		{
			pData[playerid][pFacSkin] = modelid;
			SetPlayerSkin(playerid, modelid);
			Servers(playerid, "Anda telah mengganti faction skin menjadi ID %d", modelid);
		}
    }
	if(listid == SANEWFemale)
    {
		if(response)
		{
			pData[playerid][pFacSkin] = modelid;
			SetPlayerSkin(playerid, modelid);
			Servers(playerid, "Anda telah mengganti faction skin menjadi ID %d", modelid);
		}
    }
	if(listid == GOJEKMale)
    {
		if(response)
		{
			pData[playerid][pFacSkin] = modelid;
			SetPlayerSkin(playerid, modelid);
			Servers(playerid, "Anda telah mengganti faction skin menjadi ID %d", modelid);
		}
    }
	if(listid == GOJEKFemale)
    {
		if(response)
		{
			pData[playerid][pFacSkin] = modelid;
			SetPlayerSkin(playerid, modelid);
			Servers(playerid, "Anda telah mengganti faction skin menjadi ID %d", modelid);
		}
    }
    if(listid == PEDAGANGMale)
    {
		if(response)
		{
			pData[playerid][pFacSkin] = modelid;
			SetPlayerSkin(playerid, modelid);
			Servers(playerid, "Anda telah mengganti faction skin menjadi ID %d", modelid);
		}
    }
	if(listid == PEDAGANGFemale)
    {
		if(response)
		{
			pData[playerid][pFacSkin] = modelid;
			SetPlayerSkin(playerid, modelid);
			Servers(playerid, "Anda telah mengganti faction skin menjadi ID %d", modelid);
		}
    }

	///Bisnis buy skin clothes
	if(listid == MaleSkins)
    {
		if(response)
		{
			new bizid = pData[playerid][pInBiz], price;
			price = bData[bizid][bP][0];
			pData[playerid][pSkin] = modelid;
			SetPlayerSkin(playerid, modelid);
			GivePlayerMoneyEx(playerid, -price);
            SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s telah membeli skin ID %d seharga %s.", ReturnName(playerid), modelid, FormatMoney(price));
            bData[bizid][bProd]--;
            bData[bizid][bMoney] += Server_Percent(price);
			Server_AddPercent(price);
            Bisnis_Save(bizid);
			Info(playerid, "Anda telah mengganti skin menjadi ID %d", modelid);
		}
		else return Servers(playerid, "Canceled buy skin");
    }
	if(listid == FemaleSkins)
    {
		if(response)
		{
			new bizid = pData[playerid][pInBiz], price;
			price = bData[bizid][bP][0];
			pData[playerid][pSkin] = modelid;
			SetPlayerSkin(playerid, modelid);
			GivePlayerMoneyEx(playerid, -price);
            SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s telah membeli skin ID %d seharga %s.", ReturnName(playerid), modelid, FormatMoney(price));
            bData[bizid][bProd]--;
            bData[bizid][bMoney] += Server_Percent(price);
			Server_AddPercent(price);
            Bisnis_Save(bizid);
			Info(playerid, "Anda telah mengganti skin menjadi ID %d", modelid);
		}
		else return Servers(playerid, "Canceled buy skin");
    }
	if(listid == VIPMaleSkins)
    {
		if(response)
		{
			pData[playerid][pSkin] = modelid;
			SetPlayerSkin(playerid, modelid);
            SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s telah mengganti skin ID %d.", ReturnName(playerid), modelid);
			Info(playerid, "Anda telah mengganti skin menjadi ID %d", modelid);
		}
		else return Servers(playerid, "Canceled buy skin");
    }
	if(listid == VIPFemaleSkins)
    {
		if(response)
		{
			pData[playerid][pSkin] = modelid;
			SetPlayerSkin(playerid, modelid);
            SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s telah membeli skin ID %d.", ReturnName(playerid), modelid);
			Info(playerid, "Anda telah mengganti skin menjadi ID %d", modelid);
		}
		else return Servers(playerid, "Canceled buy skin");
    }
    if(listid == vtoylist)
	{
		if(response)
		{
			new x = GetPlayerVehicleID(playerid);
			foreach(new i: PVehicles)
			if(x == pvData[i][cVeh])
			{
				new vehid = pvData[i][cVeh];
				vtData[vehid][pvData[vehid][vtoySelected]][vtoy_modelid] = modelid;
				if(pvData[vehid][PurchasedvToy] == false)
				{
					MySQL_CreateVehicleToy(i);
				}
				vtData[vehid][pvData[vehid][vtoySelected]][vtoy_model] = CreateDynamicObject(vtData[vehid][pvData[vehid][vtoySelected]][vtoy_modelid], 0.0, 0.0, -14.0, 0.0, 0.0, 0.0);
				AttachDynamicObjectToVehicle(vtData[vehid][pvData[vehid][vtoySelected]][vtoy_model], vehid, vtData[vehid][pvData[vehid][vtoySelected]][vtoy_x], vtData[vehid][pvData[vehid][vtoySelected]][vtoy_y], vtData[vehid][pvData[vehid][vtoySelected]][vtoy_z], vtData[vehid][pvData[vehid][vtoySelected]][vtoy_rx], vtData[vehid][pvData[vehid][vtoySelected]][vtoy_ry], vtData[vehid][pvData[vehid][vtoySelected]][vtoy_rz]);
				SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s memasang toys untuk vehicleid(%d) object ID %d", ReturnName(playerid), vehid, modelid);
				ShowPlayerDialog(playerid, VTOY_ACCEPT, DIALOG_STYLE_MSGBOX, "Vehicle Toys", "Do You Want To Save it?", "Yes", "Cancel");
			}
		}
		else return Servers(playerid, "Canceled buy toys");
	}
	if(listid == toyslist)
	{
		if(response)
		{
			new bizid = pData[playerid][pInBiz], price;
			price = bData[bizid][bP][1];

			GivePlayerMoneyEx(playerid, -price);
			if(pData[playerid][PurchasedToy] == false) MySQL_CreatePlayerToy(playerid);
			pToys[playerid][pData[playerid][toySelected]][toy_model] = modelid;
			new finstring[750];
			strcat(finstring, ""dot"Spine\n"dot"Head\n"dot"Left upper arm\n"dot"Right upper arm\n"dot"Left hand\n"dot"Right hand\n"dot"Left thigh\n"dot"Right tigh\n"dot"Left foot\n"dot"Right foot");
			strcat(finstring, "\n"dot"Right calf\n"dot"Left calf\n"dot"Left forearm\n"dot"Right forearm\n"dot"Left clavicle\n"dot"Right clavicle\n"dot"Neck\n"dot"Jaw");
			ShowPlayerDialog(playerid, DIALOG_TOYPOSISIBUY, DIALOG_STYLE_LIST, ""WHITE_E"Select Bone", finstring, "Select", "Cancel");

            SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s telah membeli object ID %d seharga %s.", ReturnName(playerid), modelid, FormatMoney(price));
            bData[bizid][bProd]--;
            bData[bizid][bMoney] += Server_Percent(price);
			Server_AddPercent(price);
            Bisnis_Save(bizid);
		}
		else return Servers(playerid, "Canceled buy toys");
	}
	if(listid == viptoyslist)
	{
		if(response)
		{
			if(pData[playerid][PurchasedToy] == false) MySQL_CreatePlayerToy(playerid);
			pToys[playerid][pData[playerid][toySelected]][toy_model] = modelid;
			new finstring[750];
			strcat(finstring, ""dot"Spine\n"dot"Head\n"dot"Left upper arm\n"dot"Right upper arm\n"dot"Left hand\n"dot"Right hand\n"dot"Left thigh\n"dot"Right tigh\n"dot"Left foot\n"dot"Right foot");
			strcat(finstring, "\n"dot"Right calf\n"dot"Left calf\n"dot"Left forearm\n"dot"Right forearm\n"dot"Left clavicle\n"dot"Right clavicle\n"dot"Neck\n"dot"Jaw");
			ShowPlayerDialog(playerid, DIALOG_TOYPOSISIBUY, DIALOG_STYLE_LIST, ""WHITE_E"Select Bone", finstring, "Select", "Cancel");

            SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s telah mengambil object ID %d dilocker.", ReturnName(playerid), modelid);
		}
		else return Servers(playerid, "Canceled toys");
	}
	if(listid == rentjoblist)
	{
		if(response)
		{
			if(modelid == 414)
			{
				//new modelid = 414;
				new tstr[128];
				pData[playerid][pBuyPvModel] = modelid;
				format(tstr, sizeof(tstr), ""WHITE_E"Anda akan menyewa kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"$500 / one days", GetVehicleModelName(modelid));
				ShowPlayerDialog(playerid, DIALOG_RENT_JOBCARSCONFIRM, DIALOG_STYLE_MSGBOX, "Rental Vehicles", tstr, "Rental", "Batal");
			}
			if(modelid == 455)
			{
				//new modelid = 455;
				new tstr[128];
				pData[playerid][pBuyPvModel] = modelid;
				format(tstr, sizeof(tstr), ""WHITE_E"Anda akan menyewa kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"$500 / one days", GetVehicleModelName(modelid));
				ShowPlayerDialog(playerid, DIALOG_RENT_JOBCARSCONFIRM, DIALOG_STYLE_MSGBOX, "Rental Vehicles", tstr, "Rental", "Batal");
			}
			if(modelid == 456)
			{
			//new modelid = 456;
				new tstr[128];
				pData[playerid][pBuyPvModel] = modelid;
				format(tstr, sizeof(tstr), ""WHITE_E"Anda akan menyewa kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"$500 / one days", GetVehicleModelName(modelid));
				ShowPlayerDialog(playerid, DIALOG_RENT_JOBCARSCONFIRM, DIALOG_STYLE_MSGBOX, "Rental Vehicles", tstr, "Rental", "Batal");
			}
			if(modelid == 498)
			{
				//new modelid = 498;
				new tstr[128];
				pData[playerid][pBuyPvModel] = modelid;
				format(tstr, sizeof(tstr), ""WHITE_E"Anda akan menyewa kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"$500 / one days", GetVehicleModelName(modelid));
				ShowPlayerDialog(playerid, DIALOG_RENT_JOBCARSCONFIRM, DIALOG_STYLE_MSGBOX, "Rental Vehicles", tstr, "Rental", "Batal");
			}
			if(modelid == 499)
			{
				//new modelid = 499;
				new tstr[128];
				pData[playerid][pBuyPvModel] = modelid;
				format(tstr, sizeof(tstr), ""WHITE_E"Anda akan menyewa kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"$500 / one days", GetVehicleModelName(modelid));
				ShowPlayerDialog(playerid, DIALOG_RENT_JOBCARSCONFIRM, DIALOG_STYLE_MSGBOX, "Rental Vehicles", tstr, "Rental", "Batal");
			}
			if(modelid == 609)
			{
				//new modelid = 609;
				new tstr[128];
				pData[playerid][pBuyPvModel] = modelid;
				format(tstr, sizeof(tstr), ""WHITE_E"Anda akan menyewa kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"$500 / one days", GetVehicleModelName(modelid));
				ShowPlayerDialog(playerid, DIALOG_RENT_JOBCARSCONFIRM, DIALOG_STYLE_MSGBOX, "Rental Vehicles", tstr, "Rental", "Batal");
			}
			if(modelid == 478)
			{
				//new modelid = 478;
				new tstr[128];
				pData[playerid][pBuyPvModel] = modelid;
				format(tstr, sizeof(tstr), ""WHITE_E"Anda akan menyewa kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"$500 / one days", GetVehicleModelName(modelid));
				ShowPlayerDialog(playerid, DIALOG_RENT_JOBCARSCONFIRM, DIALOG_STYLE_MSGBOX, "Rental Vehicles", tstr, "Rental", "Batal");
			}
			if(modelid == 422)
			{
				//new modelid = 422;
				new tstr[128];
				pData[playerid][pBuyPvModel] = modelid;
				format(tstr, sizeof(tstr), ""WHITE_E"Anda akan menyewa kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"$500 / one days", GetVehicleModelName(modelid));
				ShowPlayerDialog(playerid, DIALOG_RENT_JOBCARSCONFIRM, DIALOG_STYLE_MSGBOX, "Rental Vehicles", tstr, "Rental", "Batal");
			}
			if(modelid == 543)
			{
				//new modelid = 543;
				new tstr[128];
				pData[playerid][pBuyPvModel] = modelid;
				format(tstr, sizeof(tstr), ""WHITE_E"Anda akan menyewa kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"$500 / one days", GetVehicleModelName(modelid));
				ShowPlayerDialog(playerid, DIALOG_RENT_JOBCARSCONFIRM, DIALOG_STYLE_MSGBOX, "Rental Vehicles", tstr, "Rental", "Batal");
			}
			if(modelid == 554)
			{
				//new modelid = 554;
				new tstr[128];
				pData[playerid][pBuyPvModel] = modelid;
				format(tstr, sizeof(tstr), ""WHITE_E"Anda akan menyewa kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"$500 / one days", GetVehicleModelName(modelid));
				ShowPlayerDialog(playerid, DIALOG_RENT_JOBCARSCONFIRM, DIALOG_STYLE_MSGBOX, "Rental Vehicles", tstr, "Rental", "Batal");
			}
			if(modelid == 525)
			{
				//new modelid = 525;
				new tstr[128];
				pData[playerid][pBuyPvModel] = modelid;
				format(tstr, sizeof(tstr), ""WHITE_E"Anda akan menyewa kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"$500 / one days", GetVehicleModelName(modelid));
				ShowPlayerDialog(playerid, DIALOG_RENT_JOBCARSCONFIRM, DIALOG_STYLE_MSGBOX, "Rental Vehicles", tstr, "Rental", "Batal");
			}
			if(modelid == 438)
			{
				//new modelid = 438;
				new tstr[128];
				pData[playerid][pBuyPvModel] = modelid;
				format(tstr, sizeof(tstr), ""WHITE_E"Anda akan menyewa kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"$500 / one days", GetVehicleModelName(modelid));
				ShowPlayerDialog(playerid, DIALOG_RENT_JOBCARSCONFIRM, DIALOG_STYLE_MSGBOX, "Rental Vehicles", tstr, "Rental", "Batal");
			}
			if(modelid == 420)
			{
				//new modelid = 420;
				new tstr[128];
				pData[playerid][pBuyPvModel] = modelid;
				format(tstr, sizeof(tstr), ""WHITE_E"Anda akan menyewa kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"$500 / one days", GetVehicleModelName(modelid));
				ShowPlayerDialog(playerid, DIALOG_RENT_JOBCARSCONFIRM, DIALOG_STYLE_MSGBOX, "Rental Vehicles", tstr, "Rental", "Batal");
			}
		}
		else return Servers(playerid, "Canceled buy vehicle");
	}
	if(listid == sportcar)
	{
		if(response)
		{
			if(modelid == 400)
			{
				//new modelid = 414;
				new tstr[128], price = GetVipVehicleCost(modelid);
				pData[playerid][pBuyPvModel] = modelid;
				format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "YELLOW_E"%d gold", GetVehicleModelName(modelid), price);
				ShowPlayerDialog(playerid, DIALOG_BUYPVCP_VIPCONFIRM, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
			}
			if(modelid == 402)
			{
				//new modelid = 455;
				new tstr[128], price = GetVipVehicleCost(modelid);
				pData[playerid][pBuyPvModel] = modelid;
				format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "YELLOW_E"%d gold", GetVehicleModelName(modelid), price);
				ShowPlayerDialog(playerid, DIALOG_BUYPVCP_VIPCONFIRM, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
			}
			if(modelid == 415)
			{
				//new modelid = 498;
				new tstr[128], price = GetVipVehicleCost(modelid);
				pData[playerid][pBuyPvModel] = modelid;
				format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "YELLOW_E"%d gold", GetVehicleModelName(modelid), price);
				ShowPlayerDialog(playerid, DIALOG_BUYPVCP_VIPCONFIRM, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
			}
			if(modelid == 421)
			{
				//new modelid = 499;
				new tstr[128], price = GetVipVehicleCost(modelid);
				pData[playerid][pBuyPvModel] = modelid;
				format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "YELLOW_E"%d gold", GetVehicleModelName(modelid), price);
				ShowPlayerDialog(playerid, DIALOG_BUYPVCP_VIPCONFIRM, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
			}
			if(modelid == 429)
			{
				//new modelid = 609;
				new tstr[128], price = GetVipVehicleCost(modelid);
				pData[playerid][pBuyPvModel] = modelid;
				format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "YELLOW_E"%d gold", GetVehicleModelName(modelid), price);
				ShowPlayerDialog(playerid, DIALOG_BUYPVCP_VIPCONFIRM, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
			}
			if(modelid == 436)
			{
				//new modelid = 478;
				new tstr[128], price = GetVipVehicleCost(modelid);
				pData[playerid][pBuyPvModel] = modelid;
				format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "YELLOW_E"%d gold", GetVehicleModelName(modelid), price);
				ShowPlayerDialog(playerid, DIALOG_BUYPVCP_VIPCONFIRM, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
			}
			if(modelid == 466)
			{
				//new modelid = 543;
				new tstr[128], price = GetVipVehicleCost(modelid);
				pData[playerid][pBuyPvModel] = modelid;
				format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "YELLOW_E"%d gold", GetVehicleModelName(modelid), price);
				ShowPlayerDialog(playerid, DIALOG_BUYPVCP_VIPCONFIRM, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
			}
			if(modelid == 533)
			{
				//new modelid = 414;
				new tstr[128], price = GetVipVehicleCost(modelid);
				pData[playerid][pBuyPvModel] = modelid;
				format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "YELLOW_E"%d gold", GetVehicleModelName(modelid), price);
				ShowPlayerDialog(playerid, DIALOG_BUYPVCP_VIPCONFIRM, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
			}
			if(modelid == 541)
			{
				//new modelid = 455;
				new tstr[128], price = GetVipVehicleCost(modelid);
				pData[playerid][pBuyPvModel] = modelid;
				format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "YELLOW_E"%d gold", GetVehicleModelName(modelid), price);
				ShowPlayerDialog(playerid, DIALOG_BUYPVCP_VIPCONFIRM, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
			}
			if(modelid == 543)
			{
			//new modelid = 456;
				new tstr[128], price = GetVipVehicleCost(modelid);
				pData[playerid][pBuyPvModel] = modelid;
				format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "YELLOW_E"%d gold", GetVehicleModelName(modelid), price);
				ShowPlayerDialog(playerid, DIALOG_BUYPVCP_VIPCONFIRM, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
			}
			if(modelid == 579)
			{
				//new modelid = 498;
				new tstr[128], price = GetVipVehicleCost(modelid);
				pData[playerid][pBuyPvModel] = modelid;
				format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "YELLOW_E"%d gold", GetVehicleModelName(modelid), price);
				ShowPlayerDialog(playerid, DIALOG_BUYPVCP_VIPCONFIRM, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
			}
			if(modelid == 602)
			{
				//new modelid = 499;
				new tstr[128], price = GetVipVehicleCost(modelid);
				pData[playerid][pBuyPvModel] = modelid;
				format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "YELLOW_E"%d gold", GetVehicleModelName(modelid), price);
				ShowPlayerDialog(playerid, DIALOG_BUYPVCP_VIPCONFIRM, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
			}
			if(modelid == 405)
			{
				//new modelid = 609;
				new tstr[128], price = GetVipVehicleCost(modelid);
				pData[playerid][pBuyPvModel] = modelid;
				format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "YELLOW_E"%d gold", GetVehicleModelName(modelid), price);
				ShowPlayerDialog(playerid, DIALOG_BUYPVCP_VIPCONFIRM, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
			}
			if(modelid == 603)
			{
				//new modelid = 478;
				new tstr[128], price = GetVipVehicleCost(modelid);
				pData[playerid][pBuyPvModel] = modelid;
				format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "YELLOW_E"%d gold", GetVehicleModelName(modelid), price);
				ShowPlayerDialog(playerid, DIALOG_BUYPVCP_VIPCONFIRM, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
			}
			if(modelid == 589)
			{
				//new modelid = 422;
				new tstr[128], price = GetVipVehicleCost(modelid);
				pData[playerid][pBuyPvModel] = modelid;
				format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "YELLOW_E"%d gold", GetVehicleModelName(modelid), price);
				ShowPlayerDialog(playerid, DIALOG_BUYPVCP_VIPCONFIRM, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
			}
			if(modelid == 587)
			{
				//new modelid = 543;
				new tstr[128], price = GetVipVehicleCost(modelid);
				pData[playerid][pBuyPvModel] = modelid;
				format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "YELLOW_E"%d gold", GetVehicleModelName(modelid), price);
				ShowPlayerDialog(playerid, DIALOG_BUYPVCP_VIPCONFIRM, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
			}
			if(modelid == 566)
			{
				//new modelid = 554;
				new tstr[128], price = GetVipVehicleCost(modelid);
				pData[playerid][pBuyPvModel] = modelid;
				format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "YELLOW_E"%d gold", GetVehicleModelName(modelid), price);
				ShowPlayerDialog(playerid, DIALOG_BUYPVCP_VIPCONFIRM, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
			}
			if(modelid == 562)
			{
				//new modelid = 525;
				new tstr[128], price = GetVipVehicleCost(modelid);
				pData[playerid][pBuyPvModel] = modelid;
				format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "YELLOW_E"%d gold", GetVehicleModelName(modelid), price);
				ShowPlayerDialog(playerid, DIALOG_BUYPVCP_VIPCONFIRM, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
			}
			if(modelid == 560)
			{
				//new modelid = 438;
				new tstr[128], price = GetVipVehicleCost(modelid);
				pData[playerid][pBuyPvModel] = modelid;
				format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "YELLOW_E"%d gold", GetVehicleModelName(modelid), price);
				ShowPlayerDialog(playerid, DIALOG_BUYPVCP_VIPCONFIRM, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
			}
			if(modelid == 559)
			{
				//new modelid = 420;
				new tstr[128], price = GetVipVehicleCost(modelid);
				pData[playerid][pBuyPvModel] = modelid;
				format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "YELLOW_E"%d gold", GetVehicleModelName(modelid), price);
				ShowPlayerDialog(playerid, DIALOG_BUYPVCP_VIPCONFIRM, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
			}
			if(modelid == 558)
			{
				//new modelid = 609;
				new tstr[128], price = GetVipVehicleCost(modelid);
				pData[playerid][pBuyPvModel] = modelid;
				format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "YELLOW_E"%d gold", GetVehicleModelName(modelid), price);
				ShowPlayerDialog(playerid, DIALOG_BUYPVCP_VIPCONFIRM, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
			}
			if(modelid == 551)
			{
				//new modelid = 478;
				new tstr[128], price = GetVipVehicleCost(modelid);
				pData[playerid][pBuyPvModel] = modelid;
				format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "YELLOW_E"%d gold", GetVehicleModelName(modelid), price);
				ShowPlayerDialog(playerid, DIALOG_BUYPVCP_VIPCONFIRM, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
			}
			if(modelid == 540)
			{
				//new modelid = 422;
				new tstr[128], price = GetVipVehicleCost(modelid);
				pData[playerid][pBuyPvModel] = modelid;
				format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "YELLOW_E"%d gold", GetVehicleModelName(modelid), price);
				ShowPlayerDialog(playerid, DIALOG_BUYPVCP_VIPCONFIRM, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
			}
			if(modelid == 534)
			{
				//new modelid = 543;
				new tstr[128], price = GetVipVehicleCost(modelid);
				pData[playerid][pBuyPvModel] = modelid;
				format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "YELLOW_E"%d gold", GetVehicleModelName(modelid), price);
				ShowPlayerDialog(playerid, DIALOG_BUYPVCP_VIPCONFIRM, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
			}
			if(modelid == 527)
			{
				//new modelid = 554;
				new tstr[128], price = GetVipVehicleCost(modelid);
				pData[playerid][pBuyPvModel] = modelid;
				format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "YELLOW_E"%d gold", GetVehicleModelName(modelid), price);
				ShowPlayerDialog(playerid, DIALOG_BUYPVCP_VIPCONFIRM, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
			}
			if(modelid == 507)
			{
				//new modelid = 525;
				new tstr[128], price = GetVipVehicleCost(modelid);
				pData[playerid][pBuyPvModel] = modelid;
				format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "YELLOW_E"%d gold", GetVehicleModelName(modelid), price);
				ShowPlayerDialog(playerid, DIALOG_BUYPVCP_VIPCONFIRM, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
			}
			if(modelid == 411)
			{
				//new modelid = 420;
				new tstr[128], price = GetVipVehicleCost(modelid);
				pData[playerid][pBuyPvModel] = modelid;
				format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "YELLOW_E"%d gold", GetVehicleModelName(modelid), price);
				ShowPlayerDialog(playerid, DIALOG_BUYPVCP_VIPCONFIRM, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
			}
			if(modelid == 477)
			{
				//new modelid = 477;
				new tstr[128], price = GetVipVehicleCost(modelid);
				pData[playerid][pBuyPvModel] = modelid;
				format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "YELLOW_E"%d gold", GetVehicleModelName(modelid), price);
				ShowPlayerDialog(playerid, DIALOG_BUYPVCP_VIPCONFIRM, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
			}
   			if(modelid == 522)
			{
				//new modelid = 477;
				new tstr[128], price = GetVipVehicleCost(modelid);
				pData[playerid][pBuyPvModel] = modelid;
				format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "YELLOW_E"%d gold", GetVehicleModelName(modelid), price);
				ShowPlayerDialog(playerid, DIALOG_BUYPVCP_VIPCONFIRM, DIALOG_STYLE_MSGBOX, "Private Vehicles", tstr, "Buy", "Batal");
			}
		}
		else return Servers(playerid, "Canceled Buy Vehicle");
	}
	if(listid == boatlist)
	{
		if(response)
		{
			if(modelid == 446)
			{
				new tstr[128], price = GetVehicleCost(modelid);
				pData[playerid][pBuyPvModel] = modelid;
				format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"%s", GetVehicleModelName(modelid), FormatMoney(price));
				ShowPlayerDialog(playerid, DIALOG_BUYBOAT_CONFIRM, DIALOG_STYLE_MSGBOX, "Boat", tstr, "Buy", "Cancel");
			}
			if(modelid == 453)
			{
				new tstr[128], price = GetVehicleCost(modelid);
				pData[playerid][pBuyPvModel] = modelid;
				format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"%s", GetVehicleModelName(modelid), FormatMoney(price));
				ShowPlayerDialog(playerid, DIALOG_BUYBOAT_CONFIRM, DIALOG_STYLE_MSGBOX, "Boat", tstr, "Buy", "Cancel");
			}
			if(modelid == 472)
			{
				new tstr[128], price = GetVehicleCost(modelid);
				pData[playerid][pBuyPvModel] = modelid;
				format(tstr, sizeof(tstr), ""WHITE_E"Anda akan membeli kendaraan "PINK_E"%s "WHITE_E"dengan harga "LG_E"%s", GetVehicleModelName(modelid), FormatMoney(price));
				ShowPlayerDialog(playerid, DIALOG_BUYBOAT_CONFIRM, DIALOG_STYLE_MSGBOX, "Boat", tstr, "Buy", "Cancel");
			}
		}
		else return Servers(playerid, "Canceled Buy Boat");
	}
	return 1;
}

public OnPlayerRequestClass(playerid, classid)
{
	SetPlayerJoinCamera(playerid);
	SetSpawnInfo(playerid, 0, pData[playerid][pSkin], pData[playerid][pPosX], pData[playerid][pPosY], pData[playerid][pPosZ], pData[playerid][pPosA], 0, 0, 0, 0, 0, 0);
	//TogglePlayerSpectating(playerid, true); 
	return 1;
}

public OnPlayerRequestSpawn(playerid)
{
 	new mstr[128];
 	format(mstr, sizeof(mstr), "Masukkan password anda jika ingin bermain!");
	ShowPlayerDialog(playerid, DIALOG_NGENTOD, DIALOG_STYLE_MSGBOX, "Eror", mstr, "Close", "");
	KickEx(playerid);
	return 1;
}
//end
public OnPlayerDeath(playerid, killerid, reason)
{
	//pb
	/*if(PlayerPBing[killerid] == true)
	{
		new string[128],name[MAX_PLAYER_NAME];
		GetPlayerName(killerid,name,sizeof(name));
		PlayerPBKills[killerid]++;
		if(PlayerPBKills[killerid] > PBLeaderKills)
		{
			PBLeaderKills = PlayerPBKills[killerid];
			PBLeaderid = killerid;
			format(string,sizeof(string),"The Player "COL_RED"%s(%d) "COL_WHITE"Is In Lead With "COL_RED"%d "COL_WHITE"Kills",name,killerid,PlayerPBKills[killerid]);
			for(new i = 0; i < MAX_PLAYERS; i++)
			{
				if(PlayerPBing[i] == true)
				{
					SendClientMessage(i,COLOR_PINK,string);
				}
			}
		}
	}

	//end*/
	new h, m, s;
	new day, month, year;
	gettime(h, m, s);
	getdate(year,month,day);
    //new DCC_Channel:g_Discord_Chat;
	new name[MAX_PLAYER_NAME + 1];
    GetPlayerName(playerid, name, sizeof name);
    new names[MAX_PLAYER_NAME];
	GetPlayerName(killerid,names,sizeof(names));

	new String[512], Strings[512];

	new weaponid = GetPlayerWeaponEx(killerid);
	format(String, sizeof(String), "```\n%s killed %s [ID: %d] (%s)```", names, name, playerid, ReturnWeaponName(weaponid));
	DCC_SendChannelMessage(g_discord_kill, String);
    format(Strings, sizeof(Strings), "```\n%d.%d.%d - %d:%d:%d```", day, month, year, h, m, s);
    DCC_SendChannelMessage(g_discord_kill, Strings);

	DeletePVar(playerid, "UsingSprunk");
	SetPVarInt(playerid, "GiveUptime", -1);
	pData[playerid][pSpawned] = 0;
	Player_ResetCutting(playerid);
	Player_RemoveLumber(playerid);
	Player_ResetMining(playerid);
	Player_ResetHarvest(playerid);

	pData[playerid][CarryProduct] = 0;

	KillTimer(pData[playerid][pActivity]);
	KillTimer(pData[playerid][pMechanic]);
	KillTimer(pData[playerid][pProducting]);
	KillTimer(pData[playerid][pCooking]);
	HidePlayerProgressBar(playerid, pData[playerid][activitybar]);
	PlayerTextDrawHide(playerid, ActiveTD[playerid]);
	pData[playerid][pMechVeh] = INVALID_VEHICLE_ID;
	pData[playerid][pActivityTime] = 0;

	pData[playerid][pMechDuty] = 0;
	pData[playerid][pTaxiDuty] = 0;
	pData[playerid][pMission] = -1;
	pData[playerid][pDealerMission] = -1;
	SedangHauling[playerid] = 0;
	//RecogioChatarra[playerid] = 0;
	//taser gun
	taser[playerid] = false;
    GiveTaserAgainTimer[playerid] = 0;

	pData[playerid][pSideJob] = 0;
	pData[playerid][pJobTime] = 0;
	DisablePlayerCheckpoint(playerid);
	DisablePlayerRaceCheckpoint(playerid);
	SetPlayerColor(playerid, COLOR_WHITE);
	RemovePlayerAttachedObject(playerid, 9);
	GetPlayerPos(playerid, pData[playerid][pPosX], pData[playerid][pPosY], pData[playerid][pPosZ]);
	foreach(new ii : Player)
    {
        if(pData[ii][pAdmin] > 0)
        {
            SendDeathMessageToPlayer(ii, killerid, playerid, reason);
        }
    }
    if(TakingPs[playerid] == 1 || TakingPs[playerid] == 0) {
		DestroyDynamicCP(cp[playerid]);
		TakingPs[playerid] = 2;
	}
	if(IsAtEvent[playerid] == 0)
    {
    	new asakit = RandomEx(0, 5);
    	new bsakit = RandomEx(0, 9);
    	new csakit = RandomEx(0, 7);
    	new dsakit = RandomEx(0, 6);
    	pData[playerid][pLFoot] -= dsakit;
    	pData[playerid][pLHand] -= bsakit;
    	pData[playerid][pRFoot] -= csakit;
    	pData[playerid][pRHand] -= dsakit;
    	pData[playerid][pHead] -= asakit;
    }	   
	return 1;
}

public OnPlayerEditAttachedObject(playerid, response, index, modelid, boneid, Float:fOffsetX, Float:fOffsetY, Float:fOffsetZ, Float:fRotX, Float:fRotY, Float:fRotZ,Float:fScaleX, Float:fScaleY, Float:fScaleZ)
{
	new weaponid = EditingWeapon[playerid];
    if(weaponid)
    {
        if(response == 1)
        {
            new enum_index = weaponid - 22, weaponname[18], string[340];

            GetWeaponName(weaponid, weaponname, sizeof(weaponname));

            WeaponSettings[playerid][enum_index][Position][0] = fOffsetX;
            WeaponSettings[playerid][enum_index][Position][1] = fOffsetY;
            WeaponSettings[playerid][enum_index][Position][2] = fOffsetZ;
            WeaponSettings[playerid][enum_index][Position][3] = fRotX;
            WeaponSettings[playerid][enum_index][Position][4] = fRotY;
            WeaponSettings[playerid][enum_index][Position][5] = fRotZ;

            RemovePlayerAttachedObject(playerid, GetWeaponObjectSlot(weaponid));
            SetPlayerAttachedObject(playerid, GetWeaponObjectSlot(weaponid), GetWeaponModel(weaponid), WeaponSettings[playerid][enum_index][Bone], fOffsetX, fOffsetY, fOffsetZ, fRotX, fRotY, fRotZ, 1.0, 1.0, 1.0);

            Servers(playerid, "You have successfully adjusted the position of your %s.", weaponname);

            mysql_format(g_SQL, string, sizeof(string), "INSERT INTO weaponsettings (Owner, WeaponID, PosX, PosY, PosZ, RotX, RotY, RotZ) VALUES ('%d', %d, %.3f, %.3f, %.3f, %.3f, %.3f, %.3f) ON DUPLICATE KEY UPDATE PosX = VALUES(PosX), PosY = VALUES(PosY), PosZ = VALUES(PosZ), RotX = VALUES(RotX), RotY = VALUES(RotY), RotZ = VALUES(RotZ)", pData[playerid][pID], weaponid, fOffsetX, fOffsetY, fOffsetZ, fRotX, fRotY, fRotZ);
            mysql_tquery(g_SQL, string);
        }
		else if(response == 0)
		{
			new enum_index = weaponid - 22;
			SetPlayerAttachedObject(playerid, GetWeaponObjectSlot(weaponid), GetWeaponModel(weaponid), WeaponSettings[playerid][enum_index][Bone], fOffsetX, fOffsetY, fOffsetZ, fRotX, fRotY, fRotZ, 1.0, 1.0, 1.0);
		}
        EditingWeapon[playerid] = 0;
		return 1;
    }
	else
	{
		if(response == 1)
		{
			GameTextForPlayer(playerid, "~g~~h~Toy Position Updated~y~!", 4000, 5);

			pToys[playerid][index][toy_x] = fOffsetX;
			pToys[playerid][index][toy_y] = fOffsetY;
			pToys[playerid][index][toy_z] = fOffsetZ;
			pToys[playerid][index][toy_rx] = fRotX;
			pToys[playerid][index][toy_ry] = fRotY;
			pToys[playerid][index][toy_rz] = fRotZ;
			pToys[playerid][index][toy_sx] = fScaleX;
			pToys[playerid][index][toy_sy] = fScaleY;
			pToys[playerid][index][toy_sz] = fScaleZ;

			MySQL_SavePlayerToys(playerid);
		}
	}
	return 1;
}

public OnPlayerEditDynamicObject(playerid, STREAMER_TAG_OBJECT:objectid, response, Float:x, Float:y, Float:z, Float:rx, Float:ry, Float:rz)
{
	//cctv
	if(editMode[playerid] != 0)
	{
		new Float:oldPos[3]; GetDynamicObjectPos(objectid,oldPos[0],oldPos[1],oldPos[2]);
	    if(response == 0) { SetDynamicObjectPos(objectid,oldPos[0],oldPos[1],oldPos[2]); UpdateGizmo(0,editId[playerid]); UpdateGizmo(1,editId[playerid]); editMode[playerid] = 0; editId[playerid] = -1; SCM(playerid,c_green,"* Edit mode canceld."); }
	    if(response == 1)
	    {
	        if(editMode[playerid] == 1)
	        {
	            new camid = editId[playerid];
	            SetDynamicObjectPos(objectid,x,y,z);
	            camInfo[camid][c_Posx] = x; camInfo[camid][c_Posy] = y; camInfo[camid][c_Posz] = z;
	            SCM(playerid,c_green,"* Camera position updated.");
	            UpdateGizmo(0,camid);
	            SaveCamera(camid,1);
	            editMode[playerid] = 0; editId[playerid] = -1;
	        }
	        else if(editMode[playerid] == 2)
	        {
	            new camid = editId[playerid];
	            SetDynamicObjectPos(objectid,x,y,z);
	            camInfo[camid][c_Lookx] = x; camInfo[camid][c_Looky] = y; camInfo[camid][c_Lookz] = z;
	            SCM(playerid,c_green,"* Camera look at updated.");
	            UpdateGizmo(0,camid);
	            SaveCamera(camid,2);
	            editMode[playerid] = 0; editId[playerid] = -1;
	        }
	        else if(editMode[playerid] == 3)
	        {
	            new camid = editId[playerid];
	            SetDynamicObjectPos(objectid,x,y,z);
	            camInfo[camid][c_Intposx] = x; camInfo[camid][c_Intposy] = y; camInfo[camid][c_Intposz] = z;
	            SCM(playerid,c_green,"* Interpolated camera position updated.");
	            UpdateGizmo(1,camid);
	            SaveCamera(camid,1);
	            editMode[playerid] = 0; editId[playerid] = -1;
	        }
	        else if(editMode[playerid] == 4)
	        {
	            new camid = editId[playerid];
	            SetDynamicObjectPos(objectid,x,y,z);
	            camInfo[camid][c_Intlookx] = x; camInfo[camid][c_Intlooky] = y; camInfo[camid][c_Intlookz] = z;
	            SCM(playerid,c_green,"* Camera interpolated look at updated.");
	            UpdateGizmo(1,camid);
	            SaveCamera(camid,2);
	            editMode[playerid] = 0; editId[playerid] = -1;
	        }
	    }
	}
	if(pData[playerid][EditingSIGNAL] != -1 && Iter_Contains(Signal, pData[playerid][EditingSIGNAL]))
	{
		if(response == EDIT_RESPONSE_FINAL)
	    {
	        new sgid = pData[playerid][EditingSIGNAL];
	        sgData[sgid][sgX] = x;
	        sgData[sgid][sgY] = y;
	        sgData[sgid][sgZ] = z;
	        sgData[sgid][sgRX] = rx;
	        sgData[sgid][sgRY] = ry;
	        sgData[sgid][sgRZ] = rz;

	        SetDynamicObjectPos(objectid, sgData[sgid][sgX], sgData[sgid][sgY], sgData[sgid][sgZ]);
	        SetDynamicObjectRot(objectid, sgData[sgid][sgRX], sgData[sgid][sgRY], sgData[sgid][sgRZ]);

			Streamer_SetFloatData(STREAMER_TYPE_3D_TEXT_LABEL, sgData[sgid][sgLabel], E_STREAMER_X, sgData[sgid][sgX]);
			Streamer_SetFloatData(STREAMER_TYPE_3D_TEXT_LABEL, sgData[sgid][sgLabel], E_STREAMER_Y, sgData[sgid][sgY]);
			Streamer_SetFloatData(STREAMER_TYPE_3D_TEXT_LABEL, sgData[sgid][sgLabel], E_STREAMER_Z, sgData[sgid][sgZ] + 3.5);

		    Signal_Save(sgid);
	        pData[playerid][EditingSIGNAL] = -1;
	    }

	    else if(response == EDIT_RESPONSE_CANCEL)
	    {
	        new sgid = pData[playerid][EditingSIGNAL];
	        SetDynamicObjectPos(objectid, sgData[sgid][sgX], sgData[sgid][sgY], sgData[sgid][sgZ]);
	        SetDynamicObjectRot(objectid, sgData[sgid][sgRX], sgData[sgid][sgRY], sgData[sgid][sgRZ]);
	        pData[playerid][EditingSIGNAL] = -1;
	    }
	}
    if(pData[playerid][EditingVending] != -1 && Iter_Contains(Vending, pData[playerid][EditingVending]))
	{
		if(response == EDIT_RESPONSE_FINAL)
	    {
	        new venid = pData[playerid][EditingVending];
	        VendingData[venid][VendingPosX] = x;
	        VendingData[venid][VendingPosY] = y;
	        VendingData[venid][VendingPosZ] = z;
	        VendingData[venid][VendingPosRX] = rx;
	        VendingData[venid][VendingPosRY] = ry;
	        VendingData[venid][VendingPosRZ] = rz;

	        SetDynamicObjectPos(objectid, VendingData[venid][VendingPosX], VendingData[venid][VendingPosY], VendingData[venid][VendingPosZ]);
	        SetDynamicObjectRot(objectid, VendingData[venid][VendingPosRX], VendingData[venid][VendingPosRY], VendingData[venid][VendingPosRZ]);

			Streamer_SetFloatData(STREAMER_TYPE_3D_TEXT_LABEL, VendingData[venid][VendingLabel], E_STREAMER_X, VendingData[venid][VendingPosX]);
			Streamer_SetFloatData(STREAMER_TYPE_3D_TEXT_LABEL, VendingData[venid][VendingLabel], E_STREAMER_Y, VendingData[venid][VendingPosY]);
			Streamer_SetFloatData(STREAMER_TYPE_3D_TEXT_LABEL, VendingData[venid][VendingLabel], E_STREAMER_Z, VendingData[venid][VendingPosZ] + 0.3);

		    VendingSave(venid);
	        pData[playerid][EditingVending] = -1;
	    }

	    if(response == EDIT_RESPONSE_CANCEL)
	    {
	        new venid = pData[playerid][EditingVending];
	        SetDynamicObjectPos(objectid, VendingData[venid][VendingPosX], VendingData[venid][VendingPosY], VendingData[venid][VendingPosZ]);
	        SetDynamicObjectRot(objectid, VendingData[venid][VendingPosRX], VendingData[venid][VendingPosRY], VendingData[venid][VendingPosRZ]);
	    	pData[playerid][EditingVending] = -1;
	    }
	}
	if(pData[playerid][EditingVtoys] != -1)
	{
		if(response == EDIT_RESPONSE_FINAL)
	    {
	    	new vehicleid = GetNearestVehicleToPlayer(playerid, 5.0, false);
	        new vehid = pvData[vehicleid][cVeh];
	        new idxs = pvData[vehid][vtoySelected];
	        vtData[vehid][idxs][vtoy_x] = x;
	        vtData[vehid][idxs][vtoy_y] = y;
	        vtData[vehid][idxs][vtoy_z] = z;
	        vtData[vehid][idxs][vtoy_rx] = rx;
	        vtData[vehid][idxs][vtoy_ry] = ry;
	        vtData[vehid][idxs][vtoy_rz] = rz;

	        SetDynamicObjectPos(objectid, vtData[vehid][idxs][vtoy_x], vtData[vehid][idxs][vtoy_y], vtData[vehid][idxs][vtoy_z]);
	        SetDynamicObjectRot(objectid, vtData[vehid][idxs][vtoy_rx], vtData[vehid][idxs][vtoy_ry], vtData[vehid][idxs][vtoy_rz]);

		    MySQL_SaveVehicleToys(vehicleid);
	        pData[playerid][EditingVtoys] = -1;
	    }

	    if(response == EDIT_RESPONSE_CANCEL)
	    {
	        new vehid = pData[playerid][EditingVtoys];
	        new idxs = pvData[vehid][vtoySelected];
	        SetDynamicObjectPos(objectid, vtData[vehid][idxs][vtoy_x], vtData[vehid][idxs][vtoy_y], vtData[vehid][idxs][vtoy_z]);
	        SetDynamicObjectRot(objectid, vtData[vehid][idxs][vtoy_rx], vtData[vehid][idxs][vtoy_ry], vtData[vehid][idxs][vtoy_rz]);
	    	pData[playerid][EditingVtoys] = -1;
	    }
	}
	//graf
	if(response == EDIT_RESPONSE_FINAL )
	{
		if(GetPVarInt(playerid, "GraffitiCreating") == 1 )
		{
			new id = nGraffiti();
	        gInfo[id][Xpos] = x;
	        gInfo[id][Ypos] = y;
	        gInfo[id][Zpos] = z;
	        gInfo[id][XYpos] = rx;
	        gInfo[id][YYpos] = ry;
	        gInfo[id][ZYpos] = rz;

	        SetDynamicObjectPos(objectid, gInfo[id][Xpos], gInfo[id][Ypos], gInfo[id][Zpos]);
	        SetDynamicObjectRot(objectid, gInfo[id][XYpos], gInfo[id][YYpos], gInfo[id][ZYpos]);
		}
	}
	if( response == EDIT_RESPONSE_CANCEL )
	{
		if(GetPVarInt(playerid, "GraffitiCreating") == 1 )
		{
			DestroyDynamicObject( POBJECT[playerid] );
			SendClientMessage( playerid,0xFF6800FF,"Creation of Graffiti Canceled" ); // <---
			DeletePVar( playerid,"GraffitiCreating" );
		}
	}
    new String[10000];
    new idx = gymEditID[playerid];
	if(response == EDIT_RESPONSE_UPDATE)
	{
	    SetDynamicObjectPos(objectid, x, y, z);
		SetDynamicObjectRot(objectid, rx, ry, rz);
	}
	else if(response == EDIT_RESPONSE_CANCEL)
	{
	    if(gymEditID[playerid] != 0)
	    {
		    SetDynamicObjectPos(objectid, gymObjectPos[playerid][0], gymObjectPos[playerid][1], gymObjectPos[playerid][2]);
			SetDynamicObjectRot(objectid, gymObjectRot[playerid][0], gymObjectRot[playerid][1], gymObjectRot[playerid][2]);
			gymObjectPos[playerid][0] = 0; gymObjectPos[playerid][1] = 0; gymObjectPos[playerid][2] = 0;
			gymObjectRot[playerid][0] = 0; gymObjectRot[playerid][1] = 0; gymObjectRot[playerid][2] = 0;
			gymEdit[playerid] = 0;
			gymEditID[playerid] = 0;
		}
	}
	else if(response == EDIT_RESPONSE_FINAL)
	{
		SetDynamicObjectPos(objectid, x, y, z);
		SetDynamicObjectRot(objectid, rx, ry, rz);
		if(gymEdit[playerid] == 1)
		{
		    GYMInfo[idx][GYMOBJPos][0] = x;
	        GYMInfo[idx][GYMOBJPos][1] = y;
	        GYMInfo[idx][GYMOBJPos][2] = z;
	        GYMInfo[idx][GYMOBJPos][3] = rx;
	        GYMInfo[idx][GYMOBJPos][4] = ry;
	        GYMInfo[idx][GYMOBJPos][5] = rz;
	        GYMInfo[idx][GYMvw] = GetPlayerVirtualWorld(playerid);
        	GYMInfo[idx][GYMint] = GetPlayerInterior(playerid);
	        DestroyDynamic3DTextLabel(GYMInfo[idx][GYMOBJText]);
   			format(String, 128, "[ID:%d]\n{00FF00}Available\n%d/1000", idx, GYMInfo[idx][GYMOBJCondition]);
			GYMInfo[idx][GYMOBJText] = CreateDynamic3DTextLabel(String, COLOR_PINK, GYMInfo[idx][GYMOBJPos][0], GYMInfo[idx][GYMOBJPos][1], GYMInfo[idx][GYMOBJPos][2], 10.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, GYMInfo[idx][GYMvw], GYMInfo[idx][GYMint], -1, 10.0);
			SaveGYMObject();
		    gymEdit[playerid] = 0;
		    gymEditID[playerid] = 0;
		}
	}
    idx = oEditID[playerid];
	if(response == EDIT_RESPONSE_UPDATE)
	{
	    SetDynamicObjectPos(objectid, x, y, z);
		SetDynamicObjectRot(objectid, rx, ry, rz);
	}
	else if(response == EDIT_RESPONSE_CANCEL)
	{
	    if(oEditID[playerid] != 0)
	    {
		    SetDynamicObjectPos(objectid, oPos[playerid][0], oPos[playerid][1], oPos[playerid][2]);
			SetDynamicObjectRot(objectid, oRot[playerid][0], oRot[playerid][1], oRot[playerid][2]);
			oPos[playerid][0] = 0; oPos[playerid][1] = 0; oPos[playerid][2] = 0;
			oRot[playerid][0] = 0; oRot[playerid][1] = 0; oRot[playerid][2] = 0;
			format(String, sizeof(String), " Anda membatalkan Edit Object ID %d.", idx);
			SendClientMessage(playerid, COLOR_PINK, String);
			oEdit[playerid] = 0;
			oEditID[playerid] = 0;
		}
	}
	else if(response == EDIT_RESPONSE_FINAL)
	{
		SetDynamicObjectPos(objectid, x, y, z);
		SetDynamicObjectRot(objectid, rx, ry, rz);
		if(oEdit[playerid] == 1)
		{
		    ObjectInfo[idx][oX] = x;
			ObjectInfo[idx][oY] = y;
			ObjectInfo[idx][oZ] = z;
			ObjectInfo[idx][oRX] = rx;
			ObjectInfo[idx][oRY] = ry;
			ObjectInfo[idx][oRZ] = rz;
			//ObjectInfo[idx][oText] = CreateDynamic3DTextLabel(String, COLOR_PINK, ObjectInfo[idx][oX], ObjectInfo[idx][oY], ObjectInfo[idx][oZ], 10);
		    oEdit[playerid] = 0;
		    oEditID[playerid] = 0;
		    format(String, sizeof(String), " Anda telah menyelesaikan Edit Posisi Object ID %d.", idx);
		    SendClientMessage(playerid, COLOR_PINK, String);
			SaveObj();
		}
	}
	//--
	if(pData[playerid][EditingTreeID] != -1 && Iter_Contains(Trees, pData[playerid][EditingTreeID]))
	{
	    if(response == EDIT_RESPONSE_FINAL)
	    {
	        new etid = pData[playerid][EditingTreeID];
	        TreeData[etid][treeX] = x;
	        TreeData[etid][treeY] = y;
	        TreeData[etid][treeZ] = z;
	        TreeData[etid][treeRX] = rx;
	        TreeData[etid][treeRY] = ry;
	        TreeData[etid][treeRZ] = rz;

	        SetDynamicObjectPos(objectid, TreeData[etid][treeX], TreeData[etid][treeY], TreeData[etid][treeZ]);
	        SetDynamicObjectRot(objectid, TreeData[etid][treeRX], TreeData[etid][treeRY], TreeData[etid][treeRZ]);
			Streamer_SetFloatData(STREAMER_TYPE_3D_TEXT_LABEL, TreeData[etid][treeLabel], E_STREAMER_X, TreeData[etid][treeX]);
			Streamer_SetFloatData(STREAMER_TYPE_3D_TEXT_LABEL, TreeData[etid][treeLabel], E_STREAMER_Y, TreeData[etid][treeY]);
			Streamer_SetFloatData(STREAMER_TYPE_3D_TEXT_LABEL, TreeData[etid][treeLabel], E_STREAMER_Z, TreeData[etid][treeZ] + 1.5);

		    Tree_Save(etid);
	        pData[playerid][EditingTreeID] = -1;
	    }

	    if(response == EDIT_RESPONSE_CANCEL)
	    {
	        new etid = pData[playerid][EditingTreeID];
	        SetDynamicObjectPos(objectid, TreeData[etid][treeX], TreeData[etid][treeY], TreeData[etid][treeZ]);
	        SetDynamicObjectRot(objectid, TreeData[etid][treeRX], TreeData[etid][treeRY], TreeData[etid][treeRZ]);
	        pData[playerid][EditingTreeID] = -1;
	    }
	}
    if(pData[playerid][EditingBerryID] != -1 && Iter_Contains(Berrys, pData[playerid][EditingBerryID]))
	{
	    if(response == EDIT_RESPONSE_FINAL)
	    {
	        new etid = pData[playerid][EditingBerryID];
	        BerryData[etid][berryX] = x;
	        BerryData[etid][berryY] = y;
	        BerryData[etid][berryZ] = z;
	        BerryData[etid][berryRX] = rx;
	        BerryData[etid][berryRY] = ry;
	        BerryData[etid][berryRZ] = rz;

	        SetDynamicObjectPos(objectid, BerryData[etid][berryX], BerryData[etid][berryY], BerryData[etid][berryZ]);
	        SetDynamicObjectRot(objectid, BerryData[etid][berryRX], BerryData[etid][berryRY], BerryData[etid][berryRZ]);
			Streamer_SetFloatData(STREAMER_TYPE_3D_TEXT_LABEL, BerryData[etid][berryLabel], E_STREAMER_X, BerryData[etid][berryX]);
			Streamer_SetFloatData(STREAMER_TYPE_3D_TEXT_LABEL, BerryData[etid][berryLabel], E_STREAMER_Y, BerryData[etid][berryY]);
			Streamer_SetFloatData(STREAMER_TYPE_3D_TEXT_LABEL, BerryData[etid][berryLabel], E_STREAMER_Z, BerryData[etid][berryZ] + 1.5);

		    Berry_Save(etid);
	        pData[playerid][EditingBerryID] = -1;
	    }

	    if(response == EDIT_RESPONSE_CANCEL)
	    {
	        new etid = pData[playerid][EditingBerryID];
	        SetDynamicObjectPos(objectid, BerryData[etid][berryX], BerryData[etid][berryY], BerryData[etid][berryZ]);
	        SetDynamicObjectRot(objectid, BerryData[etid][berryRX], BerryData[etid][berryRY], BerryData[etid][berryRZ]);
	        pData[playerid][EditingBerryID] = -1;
	    }
	}
	if(pData[playerid][EditingOreID] != -1 && Iter_Contains(Ores, pData[playerid][EditingOreID]))
	{
	    if(response == EDIT_RESPONSE_FINAL)
	    {
	        new etid = pData[playerid][EditingOreID];
	        OreData[etid][oreX] = x;
	        OreData[etid][oreY] = y;
	        OreData[etid][oreZ] = z;
	        OreData[etid][oreRX] = rx;
	        OreData[etid][oreRY] = ry;
	        OreData[etid][oreRZ] = rz;

	        SetDynamicObjectPos(objectid, OreData[etid][oreX], OreData[etid][oreY], OreData[etid][oreZ]);
	        SetDynamicObjectRot(objectid, OreData[etid][oreRX], OreData[etid][oreRY], OreData[etid][oreRZ]);

			Streamer_SetFloatData(STREAMER_TYPE_3D_TEXT_LABEL, OreData[etid][oreLabel], E_STREAMER_X, OreData[etid][oreX]);
			Streamer_SetFloatData(STREAMER_TYPE_3D_TEXT_LABEL, OreData[etid][oreLabel], E_STREAMER_Y, OreData[etid][oreY]);
			Streamer_SetFloatData(STREAMER_TYPE_3D_TEXT_LABEL, OreData[etid][oreLabel], E_STREAMER_Z, OreData[etid][oreZ] + 1.5);

		    Ore_Save(etid);
	        pData[playerid][EditingOreID] = -1;
	    }

	    if(response == EDIT_RESPONSE_CANCEL)
	    {
	        new etid = pData[playerid][EditingOreID];
	        SetDynamicObjectPos(objectid, OreData[etid][oreX], OreData[etid][oreY], OreData[etid][oreZ]);
	        SetDynamicObjectRot(objectid, OreData[etid][oreRX], OreData[etid][oreRY], OreData[etid][oreRZ]);
	        pData[playerid][EditingOreID] = -1;
	    }
	}
	if(pData[playerid][EditingATMID] != -1 && Iter_Contains(ATMS, pData[playerid][EditingATMID]))
	{
		if(response == EDIT_RESPONSE_FINAL)
	    {
	        new etid = pData[playerid][EditingATMID];
	        AtmData[etid][atmX] = x;
	        AtmData[etid][atmY] = y;
	        AtmData[etid][atmZ] = z;
	        AtmData[etid][atmRX] = rx;
	        AtmData[etid][atmRY] = ry;
	        AtmData[etid][atmRZ] = rz;

	        SetDynamicObjectPos(objectid, AtmData[etid][atmX], AtmData[etid][atmY], AtmData[etid][atmZ]);
	        SetDynamicObjectRot(objectid, AtmData[etid][atmRX], AtmData[etid][atmRY], AtmData[etid][atmRZ]);

			Streamer_SetFloatData(STREAMER_TYPE_3D_TEXT_LABEL, AtmData[etid][atmLabel], E_STREAMER_X, AtmData[etid][atmX]);
			Streamer_SetFloatData(STREAMER_TYPE_3D_TEXT_LABEL, AtmData[etid][atmLabel], E_STREAMER_Y, AtmData[etid][atmY]);
			Streamer_SetFloatData(STREAMER_TYPE_3D_TEXT_LABEL, AtmData[etid][atmLabel], E_STREAMER_Z, AtmData[etid][atmZ] + 0.3);

		    Atm_Save(etid);
	        pData[playerid][EditingATMID] = -1;
	    }

	    if(response == EDIT_RESPONSE_CANCEL)
	    {
	        new etid = pData[playerid][EditingATMID];
	        SetDynamicObjectPos(objectid, AtmData[etid][atmX], AtmData[etid][atmY], AtmData[etid][atmZ]);
	        SetDynamicObjectRot(objectid, AtmData[etid][atmRX], AtmData[etid][atmRY], AtmData[etid][atmRZ]);
	        pData[playerid][EditingATMID] = -1;
	    }
	}
	if(pData[playerid][gEditID] != -1 && Iter_Contains(Gates, pData[playerid][gEditID]))
	{
		new id = pData[playerid][gEditID];
		if(response == EDIT_RESPONSE_UPDATE)
		{
			SetDynamicObjectPos(objectid, x, y, z);
			SetDynamicObjectRot(objectid, rx, ry, rz);
		}
		else if(response == EDIT_RESPONSE_CANCEL)
		{
			SetDynamicObjectPos(objectid, gPosX[playerid], gPosY[playerid], gPosZ[playerid]);
			SetDynamicObjectRot(objectid, gRotX[playerid], gRotY[playerid], gRotZ[playerid]);
			gPosX[playerid] = 0; gPosY[playerid] = 0; gPosZ[playerid] = 0;
			gRotX[playerid] = 0; gRotY[playerid] = 0; gRotZ[playerid] = 0;
			Servers(playerid, " You have canceled editing gate ID %d.", id);
			Gate_Save(id);
		}
		else if(response == EDIT_RESPONSE_FINAL)
		{
			SetDynamicObjectPos(objectid, x, y, z);
			SetDynamicObjectRot(objectid, rx, ry, rz);
			if(pData[playerid][gEdit] == 1)
			{
				gData[id][gCX] = x;
				gData[id][gCY] = y;
				gData[id][gCZ] = z;
				gData[id][gCRX] = rx;
				gData[id][gCRY] = ry;
				gData[id][gCRZ] = rz;
				if(IsValidDynamic3DTextLabel(gData[id][gText])) DestroyDynamic3DTextLabel(gData[id][gText]);
				new str[64];
				format(str, sizeof(str), "Gate ID: %d", id);
				gData[id][gText] = CreateDynamic3DTextLabel(str, COLOR_PINK, gData[id][gCX], gData[id][gCY], gData[id][gCZ], 10.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, -1, -1, -1, 10.0);

				pData[playerid][gEditID] = -1;
				pData[playerid][gEdit] = 0;
				Servers(playerid, " You have finished editing gate ID %d's closing position.", id);
				gData[id][gStatus] = 0;
				Gate_Save(id);
			}
			else if(pData[playerid][gEdit] == 2)
			{
				gData[id][gOX] = x;
				gData[id][gOY] = y;
				gData[id][gOZ] = z;
				gData[id][gORX] = rx;
				gData[id][gORY] = ry;
				gData[id][gORZ] = rz;

				pData[playerid][gEditID] = -1;
				pData[playerid][gEdit] = 0;
				Servers(playerid, " You have finished editing gate ID %d's opening position.", id);

				gData[id][gStatus] = 1;
				Gate_Save(id);
			}
		}
	}
	if(Player_EditingObject[playerid])
	{
		if(response == EDIT_RESPONSE_CANCEL)
		{
			ResetEditing(playerid);
		}
		else if(response == EDIT_RESPONSE_FINAL)
		{
			new
				vehicleid = Player_EditVehicleObject[playerid],
				vehid = GetPlayerVehicleID(playerid),
				slot = Player_EditVehicleObjectSlot[playerid],
				Float:vx,
				Float:vy,
				Float:vz,
				Float:va,
				Float:real_x,
				Float:real_y,
				Float:real_z,
				Float:real_a
			;

			GetVehiclePos(vehid, vx, vy, vz);
			GetVehicleZAngle(vehid, va); // Coba lagi

			real_x = x - vx;
			real_y = y - vy;
			real_z = z - vz;
			real_a = rz - va;

			new Float:v_size[3];
			GetVehicleModelInfo(pvData[vehicleid][cModel], VEHICLE_MODEL_INFO_SIZE, v_size[0], v_size[1], v_size[2]);
			if(	(real_x >= v_size[0] || -v_size[0] >= real_x) ||
				(real_y >= v_size[1] || -v_size[1] >= real_y) ||
				(real_z >= v_size[2] || -v_size[2] >= real_z))
			{
				SendClientMessageEx(playerid, COLOR_ARWIN,"MODSHOP: "WHITE_E"Posisi object terlal jauh dari body kendaraan.");
				ResetEditing(playerid);
				return 1;
			}

			VehicleObjects[vehicleid][slot][vehObjectPosX] = real_x;
			VehicleObjects[vehicleid][slot][vehObjectPosY] = real_y;
			VehicleObjects[vehicleid][slot][vehObjectPosZ] = real_z;
			VehicleObjects[vehicleid][slot][vehObjectPosRX] = rx;
			VehicleObjects[vehicleid][slot][vehObjectPosRY] = ry;
			VehicleObjects[vehicleid][slot][vehObjectPosRZ] = real_a;
		
			Streamer_UpdateEx(playerid, VehicleObjects[vehicleid][slot][vehObjectPosX], VehicleObjects[vehicleid][slot][vehObjectPosY], VehicleObjects[vehicleid][slot][vehObjectPosZ]);
			if(VehicleObjects[vehicleid][slot][vehObjectType] == OBJECT_TYPE_TEXT)
			{
				SetDynamicObjectMaterialText(VehicleObjects[vehicleid][slot][vehObject], 0, VehicleObjects[vehicleid][slot][vehObjectText], 130, VehicleObjects[vehicleid][slot][vehObjectFont], VehicleObjects[vehicleid][slot][vehObjectFontSize], 1, RGBAToARGB(ColorList[VehicleObjects[vehicleid][slot][vehObjectFontColor]]), 0, OBJECT_MATERIAL_TEXT_ALIGN_CENTER);
			}
			AttachDynamicObjectToVehicle(VehicleObjects[vehicleid][slot][vehObject], pvData[vehicleid][cVeh], real_x, real_y, real_z, rx, ry, real_a);
			Vehicle_ObjectUpdate(vehicleid, slot);
			//Vehicle_AttachObject(vehicleid, slot);
			Vehicle_ObjectSave(vehicleid, slot);
			
			if(VehicleObjects[vehicleid][slot][vehObjectType] == OBJECT_TYPE_TEXT)
			{
				Dialog_Show(playerid, VACCSE1, DIALOG_STYLE_LIST, "Edit Component", "Position\nPosition (Manual)\nText Name\nText Size\nText Font\nText Color\nRemove Modification\nSave", "Select", "Back");
			}
			return 1;
		}
	}
	return 1;
}

public OnPlayerEnterDynamicCP(playerid, checkpointid)
{
	//pilot
	if(IsPlayerInDynamicCP(playerid, cp[playerid]))
	{
	    if(TakingPs[playerid] == 1)
	    {
     		rands2 = random(sizeof(RandomCPs));
	        while (rands2 == rands)
	        {
	            rands2 = random(sizeof(RandomCPs));
			}
	    	SendClientMessage(playerid, 0x00FF24AA, "You took passengers and now are looking to leave, when ready.");
	    	DestroyDynamicCP(cp[playerid]);
 			rands = random(sizeof(RandomCPs));
 			TakingPs[playerid] = 0;
	 		cp[playerid] = CreateDynamicCP(RandomCPs[rands2][0],RandomCPs[rands2][1],RandomCPs[rands2][2], 20, -1, playerid, -1, 6000);
	 		return 1;
		}
		if(TakingPs[playerid] == 0)
		{
		    new wst[180];
			new pilotN[MAX_PLAYER_NAME];
		    GetPlayerName(playerid, pilotN, sizeof(pilotN));
		    format(wst, sizeof(wst), "Officer looking at you said: Well work MR.%s you have done your job honestly then he fetches something from his pocket and handes to you.", pilotN);
		    SendClientMessage(playerid, 0x26CF12AA, "You completed your passengers' trip (Which you must have to do), then a staff officer approached you...");
		    SendClientMessage(playerid, 0x26CF12AA, wst);
		    SendClientMessage(playerid, 0x26CF12AA, "You then hurried and opened you hand, it was filled with bucks i.e cash. You were payed. If you again need the work type /pwork");
			GivePlayerMoney(playerid, WorkBucks);
			DestroyDynamicCP(cp[playerid]);
			TakingPs[playerid] = 2;
			return 1;
		}
	}
	//trash
	else if(checkpointid == TrashCP[playerid])
	{
	    if(!HasTrash[playerid]) return SendClientMessage(playerid, 0xE74C3CFF, "ERROR: {FFFFFF}You're not carrying a trash bag.");
	    new vehicleid = GetPVarInt(playerid, "LastVehicleID");
	    if(LoadedTrash[vehicleid] >= TRASH_LIMIT) return SendClientMessage(playerid, 0xE74C3CFF, "ERROR: {FFFFFF}This vehicle is full, you can't load any more trash.");
	    LoadedTrash[vehicleid]++;
		ApplyAnimation(playerid, "GRENADE", "WEAPON_throwu", 4.1, 0, 0, 0, 0, 0);
		SendClientMessage(playerid, COLOR_JOB, "TRASHMASTER: {FFFFFF}You've collected a trash bag.");

		if(TRASH_LIMIT - LoadedTrash[vehicleid] > 0)
		{
			new string[96];
			format(string, sizeof(string), "TRASHMASTER: {FFFFFF}You can load {F39C12}%d {FFFFFF}more trash bags to this vehicle.", TRASH_LIMIT - LoadedTrash[vehicleid]);
			SendClientMessage(playerid, COLOR_JOB, string);
		}

		new driver = GetVehicleDriver(vehicleid);
		if(IsPlayerConnected(driver)) Trash_ShowCapacity(driver);
		Trash_ResetPlayer(playerid);
		return 1;
	}

    if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
	{
		for(new i; i < sizeof(FactoryData); i++)
		{
		    if(checkpointid == FactoryData[i][FactoryCP])
		    {
		        new string[128], vehicleid = GetPlayerVehicleID(playerid), cash = LoadedTrash[vehicleid] * TRASH_BAG_VALUE;
		        format(string, sizeof(string), "TRASHMASTER: {FFFFFF}Sold {F39C12}%d {FFFFFF}bags of trash and earned {2ECC71}$%d.", LoadedTrash[vehicleid], cash);
		        SendClientMessage(playerid, COLOR_JOB, string);
		        GivePlayerMoneyEx(playerid, cash);
		        FactoryData[i][FactoryCurrent] += LoadedTrash[vehicleid];
		        LoadedTrash[vehicleid] = 0;
                Trash_ShowCapacity(playerid);
                format(string, sizeof(string), "Recycling Factory - %s\n\n{FFFFFF}Current Trash Bags: {F39C12}%d\n{FFFFFF}Bring trash here to earn money!", FactoryData[i][FactoryName], FactoryData[i][FactoryCurrent]);
                UpdateDynamic3DTextLabelText(FactoryData[i][FactoryLabel], 0x2ECC71FF, string);

		        for(new x; x < sizeof(FactoryData); x++)
				{
				    if(IsValidDynamicMapIcon(FactoryIcons[playerid][x]))
				    {
				        DestroyDynamicMapIcon(FactoryIcons[playerid][x]);
				        FactoryIcons[playerid][x] = -1;
				    }
					TogglePlayerDynamicCP(playerid, FactoryData[x][FactoryCP], 0);
				}

		        break;
		    }
		}
	}
	//electrican
	if(checkpointid == ElectricCP[playerid])
	{
	    GetPVarInt(playerid, "LastVehicleID");

		ApplyAnimation(playerid, "CARRY", "liftup105", 4.1, 0, 0, 0, 0, 0);
		SetPlayerAttachedObject(playerid, 9, 1264, 6, 0.222, 0.024, 0.128, 1.90, -90.0, 0.0, 0.5,0.5, 0.5);
		SCM(playerid, COLOR_JOB, "ELECTRICAN: {FFFFFF}Anda Mengambil Tangga.");
		DestroyDynamicCP(TrashCP[playerid]);
		return 1;
	}
	else if(checkpointid == StoremeatCP[playerid])
	{
	    if(!GetMeatBag[playerid]) return SendClientMessage(playerid, 0xE74C3CFF, "ERROR: {FFFFFF}You're not carrying a meat bag.");

	    if(StoreMeat[playerid] == 10) return Error(playerid, "You has store 10 meat!");

	    StoreMeat[playerid] += 2;
	    GetMeatBag[playerid] = false;
	    ApplyAnimation(playerid, "GRENADE", "WEAPON_throwu", 4.1, 0, 0, 0, 0, 0);
	    RemovePlayerAttachedObject(playerid, ATTACHMENT_INDEX);
		SendClientMessage(playerid, COLOR_JOB, "BUTCHER: {FFFFFF}You've stored a meat bag.");

		Info(playerid, "You Has Stored "RED_E"%d "WHITE_E"Meat", StoreMeat[playerid]);
		return 1;
	}
	else if(checkpointid == pData[playerid][LoadingPoint])
	{
	    if(GetPVarInt(playerid, "LoadingCooldown") > gettime()) return 1;
		new vehicleid = GetPVarInt(playerid, "LastVehicleID"), type[64], carid = -1;
		if(pData[playerid][CarryingLog] == 0)
		{
			type = "Metal";
		}
		else if(pData[playerid][CarryingLog] == 1)
		{
			type = "Coal";
		}
		else
		{
			type = "Unknown";
		}
		if(Vehicle_LogCount(vehicleid) >= LOG_LIMIT) return Error(playerid, "You can't load any more ores to this vehicle.");
		if((carid = Vehicle_Nearest2(playerid)) != -1)
		{
			if(pData[playerid][CarryingLog] == 0)
			{
				pvData[carid][cMetal] += 1;
			}
			else if(pData[playerid][CarryingLog] == 1)
			{
				pvData[carid][cCoal] += 1;
			}
		}
		LogStorage[vehicleid][ pData[playerid][CarryingLog] ]++;
		Info(playerid, "MINING: Loaded %s.", type);
		ApplyAnimation(playerid, "CARRY", "putdwn05", 4.1, 0, 1, 1, 0, 0, 1);
		Player_RemoveLog(playerid);
		return 1;
	}
	else if(checkpointid == ShowRoomS)
	{
		ShowModelSelectionMenu(playerid, sportcar, "Sport Cars", 0x4A5A6BBB, 0x282828FF, 0x4A5A6BBB);
	}
	else if(checkpointid == ShowRoomCPRent)
	{
		ShowModelSelectionMenu(playerid, rentjoblist, "Rent JobsCar", 0x4A5A6BBB, 0x282828FF, 0x4A5A6BBB);
	}
	else if(checkpointid == BoatDealer)
	{
		ShowModelSelectionMenu(playerid, boatlist, "Buy Boat", 0x4A5A6BBB, 0x282828FF, 0x4A5A6BBB);
	}
	return 1;
}

public OnPlayerEnterRaceCheckpoint(playerid)
{
    if(pData[playerid][pSedangContainer] > 0)
    {
        if(pData[playerid][pSedangContainer] == 1)
        {
            new vehicleid = GetNearestVehicleToPlayer(playerid, 3.5, false);
            DisablePlayerRaceCheckpoint(playerid);
            SendClientMessage(playerid, COLOR_ARWIN, "CONTAINER: {FFFFFF}Bring the container to the destination.");
            PlayerPlaySound(playerid, 6003, 0,0,0);
            TrailerContainer[vehicleid] = CreateDynamicObject(2935, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0);
            AttachDynamicObjectToVehicle(TrailerContainer[vehicleid], vehicleid, 0.000, -1.330, 1.190, 0.000, 0.000, 180.0);
            pData[playerid][pSedangContainer] = 2;
            SetPlayerRaceCheckpoint(playerid, 1, 2791.4016, -2494.5452, 14.2522, 2791.4016, -2494.5452, 14.2522, 10.0);
            return 1;
        }
        else if(pData[playerid][pSedangContainer] == 2)
        {
            new vehicleid = GetNearestVehicleToPlayer(playerid, 3.5, false);
            DisablePlayerRaceCheckpoint(playerid);
            pData[playerid][pSedangContainer] = 0;
            DialogHauling[0] = false; // Dialog 0 telah di pilih
            DialogSaya[playerid][0] = false;
            DestroyDynamicObject(TrailerContainer[vehicleid]);
            AddPlayerSalary(playerid, "Job(Trucker)", 30000);
            pData[playerid][pJobTime] = 360;
            Info(playerid, "Job(Truck) telah masuk ke pending salary anda!");
            return 1;
        }
        else if(pData[playerid][pSedangContainer] == 3)
        {
            new vehicleid = GetNearestVehicleToPlayer(playerid, 3.5, false);
            DisablePlayerRaceCheckpoint(playerid);
            SendClientMessage(playerid, COLOR_ARWIN, "CONTAINER: {FFFFFF}Bring the container to the destination.");
            PlayerPlaySound(playerid, 6003, 0,0,0);
            TrailerContainer[vehicleid] = CreateDynamicObject(2935, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0);
            AttachDynamicObjectToVehicle(TrailerContainer[vehicleid], vehicleid, 0.000, -1.330, 1.190, 0.000, 0.000, 180.0);
            pData[playerid][pSedangContainer] = 4;
            SetPlayerRaceCheckpoint(playerid, 1, -1963.0142, -2436.3079, 31.2311, -1963.0142, -2436.3079, 31.2311, 10.0);
            return 1;
        }
        else if(pData[playerid][pSedangContainer] == 4)
        {
            new vehicleid = GetNearestVehicleToPlayer(playerid, 3.5, false);
            DisablePlayerRaceCheckpoint(playerid);
            pData[playerid][pSedangContainer] = 0;
            DialogHauling[1] = false; // Dialog 0 telah di pilih
            DialogSaya[playerid][1] = false;
            DestroyDynamicObject(TrailerContainer[vehicleid]);
            AddPlayerSalary(playerid, "Job(Trucker)", 30000);
            pData[playerid][pJobTime] = 360;
            Info(playerid, "Job(Truck) telah masuk ke pending salary anda!");
            return 1;
        }
        else if(pData[playerid][pSedangContainer] == 5)
        {
            new vehicleid = GetNearestVehicleToPlayer(playerid, 3.5, false);
            DisablePlayerRaceCheckpoint(playerid);
            SendClientMessage(playerid, COLOR_ARWIN, "CONTAINER: {FFFFFF}Bring the container to the destination.");
            PlayerPlaySound(playerid, 6003, 0,0,0);
            TrailerContainer[vehicleid] = CreateDynamicObject(2935, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0);
            AttachDynamicObjectToVehicle(TrailerContainer[vehicleid], vehicleid, 0.000, -1.330, 1.190, 0.000, 0.000, 180.0);
            pData[playerid][pSedangContainer] = 6;
            SetPlayerRaceCheckpoint(playerid, 1, -1863.1541, -1720.5603, 22.3558, -1863.1541, -1720.5603, 22.3558, 10.0);
            return 1;
        }
        else if(pData[playerid][pSedangContainer] == 6)
        {
            new vehicleid = GetNearestVehicleToPlayer(playerid, 3.5, false);
            DisablePlayerRaceCheckpoint(playerid);
            pData[playerid][pSedangContainer] = 0;
            DialogHauling[2] = false; // Dialog 0 telah di pilih
            DialogSaya[playerid][2] = false;
            DestroyDynamicObject(TrailerContainer[vehicleid]);
            AddPlayerSalary(playerid, "Job(Trucker)", 30000);
            pData[playerid][pJobTime] = 360;
            Info(playerid, "Job(Truck) telah masuk ke pending salary anda!");
            return 1;
        }
        else if(pData[playerid][pSedangContainer] == 7)
        {
            new vehicleid = GetNearestVehicleToPlayer(playerid, 3.5, false);
            DisablePlayerRaceCheckpoint(playerid);
            SendClientMessage(playerid, COLOR_ARWIN, "CONTAINER: {FFFFFF}Bring the container to the destination.");
            PlayerPlaySound(playerid, 6003, 0,0,0);
            TrailerContainer[vehicleid] = CreateDynamicObject(2935, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0);
            AttachDynamicObjectToVehicle(TrailerContainer[vehicleid], vehicleid, 0.000, -1.330, 1.190, 0.000, 0.000, 180.0);
            pData[playerid][pSedangContainer] = 8;
            pData[playerid][pJobTime] = 360;
            SetPlayerRaceCheckpoint(playerid, 1, -1053.6145, -658.6473, 32.6319, -1053.6145, -658.6473, 32.6319, 10.0);
            return 1;
        }
        else if(pData[playerid][pSedangContainer] == 8)
        {
            new vehicleid = GetNearestVehicleToPlayer(playerid, 3.5, false);
            DisablePlayerRaceCheckpoint(playerid);
            pData[playerid][pSedangContainer] = 0;
            DialogHauling[3] = false; // Dialog 0 telah di pilih
            DialogSaya[playerid][3] = false;
            DestroyDynamicObject(TrailerContainer[vehicleid]);
            AddPlayerSalary(playerid, "Job(Trucker)", 30000);
            pData[playerid][pJobTime] = 360;
            Info(playerid, "Job(Truck) telah masuk ke pending salary anda!");
            return 1;
        }
        else if(pData[playerid][pSedangContainer] == 9)
        {
            new vehicleid = GetNearestVehicleToPlayer(playerid, 3.5, false);
            DisablePlayerRaceCheckpoint(playerid);
            SendClientMessage(playerid, COLOR_ARWIN, "CONTAINER: {FFFFFF}Bring the container to the destination.");
            PlayerPlaySound(playerid, 6003, 0,0,0);
            TrailerContainer[vehicleid] = CreateDynamicObject(2935, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0);
            AttachDynamicObjectToVehicle(TrailerContainer[vehicleid], vehicleid, 0.000, -1.330, 1.190, 0.000, 0.000, 180.0);
            pData[playerid][pSedangContainer] = 10;
            SetPlayerRaceCheckpoint(playerid, 1, -459.3511, -48.3457, 60.5507, -459.3511, -48.3457, 60.5507, 10.0);
            return 1;
        }
        else if(pData[playerid][pSedangContainer] == 10)
        {
            new vehicleid = GetNearestVehicleToPlayer(playerid, 3.5, false);
            DisablePlayerRaceCheckpoint(playerid);
            pData[playerid][pSedangContainer] = 0;
            DialogHauling[4] = false; // Dialog 0 telah di pilih
            DialogSaya[playerid][4] = false;
            DestroyDynamicObject(TrailerContainer[vehicleid]);
            AddPlayerSalary(playerid, "Job(Trucker)", 30000);
            pData[playerid][pJobTime] = 360;
            Info(playerid, "Job(Truck) telah masuk ke pending salary anda!");
            return 1;
        }
        else if(pData[playerid][pSedangContainer] == 11)
        {
            new vehicleid = GetNearestVehicleToPlayer(playerid, 3.5, false);
            DisablePlayerRaceCheckpoint(playerid);
            SendClientMessage(playerid, COLOR_ARWIN, "CONTAINER: {FFFFFF}Bring the container to the destination.");
            PlayerPlaySound(playerid, 6003, 0,0,0);
            TrailerContainer[vehicleid] = CreateDynamicObject(2935, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0);
            AttachDynamicObjectToVehicle(TrailerContainer[vehicleid], vehicleid, 0.000, -1.330, 1.190, 0.000, 0.000, 180.0);
            pData[playerid][pSedangContainer] = 12;
            SetPlayerRaceCheckpoint(playerid, 1, 847.0450, 921.0422, 13.9579, 847.0450, 921.0422, 13.9579, 10.0);
            return 1;
        }
        else if(pData[playerid][pSedangContainer] == 12)
        {
            new vehicleid = GetNearestVehicleToPlayer(playerid, 3.5, false);
            DisablePlayerRaceCheckpoint(playerid);
            pData[playerid][pSedangContainer] = 0;
            DialogHauling[5] = false; // Dialog 0 telah di pilih
            DialogSaya[playerid][5] = false;
            DestroyDynamicObject(TrailerContainer[vehicleid]);
            AddPlayerSalary(playerid, "Job(Trucker)", 30000);
            pData[playerid][pJobTime] = 360;
            Info(playerid, "Job(Truck) telah masuk ke pending salary anda!");
            return 1;
        }
        else if(pData[playerid][pSedangContainer] == 13)
        {
            new vehicleid = GetNearestVehicleToPlayer(playerid, 3.5, false);
            DisablePlayerRaceCheckpoint(playerid);
            SendClientMessage(playerid, COLOR_ARWIN, "CONTAINER: {FFFFFF}Bring the container to the destination.");
            PlayerPlaySound(playerid, 6003, 0,0,0);
            TrailerContainer[vehicleid] = CreateDynamicObject(2935, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0);
            AttachDynamicObjectToVehicle(TrailerContainer[vehicleid], vehicleid, 0.000, -1.330, 1.190, 0.000, 0.000, 180.0);
            pData[playerid][pSedangContainer] = 14;
            SetPlayerRaceCheckpoint(playerid, 1, 249.6713, 1395.7150, 11.1923, 249.6713, 1395.7150, 11.1923, 10.0);
            return 1;
        }
        else if(pData[playerid][pSedangContainer] == 14)
        {
            new vehicleid = GetNearestVehicleToPlayer(playerid, 3.5, false);
            DisablePlayerRaceCheckpoint(playerid);
            pData[playerid][pSedangContainer] = 0;
            DialogHauling[6] = false; // Dialog 0 telah di pilih
            DialogSaya[playerid][6] = false;
            DestroyDynamicObject(TrailerContainer[vehicleid]);
            AddPlayerSalary(playerid, "Job(Trucker)", 30000);
            pData[playerid][pJobTime] = 360;
            Info(playerid, "Job(Truck) telah masuk ke pending salary anda!");
            return 1;
        }
    }
    if(CheckpointLast[playerid] == 1)
	{
	    if(pData[playerid][pPacket] == 1)
	    {
		    DisablePlayerRaceCheckpoint(playerid);
		    pData[playerid][pPacket] = 0;
		    pCPPacket = INVALID_PLAYER_ID;
		    CheckpointLast[playerid] = 0;
		    taked = 0;
		    packet = 0;
		    new packet_price = Random(90000, 100000);

		    GivePlayerMoneyEx(playerid, packet_price);
		    new String[1280];
		    format(String, sizeof String, "SMUGGLER: {FFFFFF}You get $%s from delivering packet", FormatMoney(packet_price));
		 	SendClientMessage(playerid, COLOR_LOGS, String);
		 	return 1;
		}
	}

    /*if(SedangHauling[playerid] > 0)
	{
 		if(SedangHauling[playerid] == 1)
	    {
     		DisablePlayerRaceCheckpoint(playerid);
     		SendClientMessage(playerid, COLOR_JOB,"TRUCKING: {FFFFFF}Attach the trailer to your vehicle to order");
  			SedangHauling[playerid] = 2;
     		SetPlayerRaceCheckpoint(playerid, 1, -2471.2942, 783.0248, 35.1719, -2471.2942, 783.0248, 35.1719, 10.0);
       		return 1;
		}
		else if(SedangHauling[playerid] == 2)
		{
   		if(IsTrailerAttachedToVehicle(GetPlayerVehicleID(playerid)))
			{
			    DisablePlayerRaceCheckpoint(playerid);
                SedangHauling[playerid] = 0;
                AddPlayerSalary(playerid, "Sidejob(Hauling)", 500);
                pData[playerid][pTruckerTime] += 30*60;
                DialogHauling[0] = false;
                DialogSaya[playerid][0] = false;
                DestroyVehicle(GetVehicleTrailer(GetPlayerVehicleID(playerid)));
                SendClientMessage(playerid, COLOR_JOB, "TRUCKING: {FFFFFF}$500 have been issued to your paycheck");
                return 1;
			}
		}
		else if(SedangHauling[playerid] == 3)
	    {
     		DisablePlayerRaceCheckpoint(playerid);
     		SendClientMessage(playerid, COLOR_JOB,"TRUCKING: {FFFFFF}Attach the trailer to your vehicle to order");
  			SedangHauling[playerid] = 4;
     		SetPlayerRaceCheckpoint(playerid, 1, -576.2687, 2569.0842, 53.5156, 576.2687, 2569.0842, 53.5156, 10.0);
       		return 1;
		}
		else if(SedangHauling[playerid] == 4)
		{
			if(IsTrailerAttachedToVehicle(GetPlayerVehicleID(playerid)))
			{
			    DisablePlayerRaceCheckpoint(playerid);
                SedangHauling[playerid] = 0;
                AddPlayerSalary(playerid, "Sidejob(Hauling)", 500);
                pData[playerid][pTruckerTime] += 30*60;
                DialogHauling[0] = false;
                DialogSaya[playerid][0] = false;
                DestroyVehicle(GetVehicleTrailer(GetPlayerVehicleID(playerid)));
                SendClientMessage(playerid, COLOR_JOB, "TRUCKING: {FFFFFF}$500 have been issued to your paycheck");
                return 1;
			}
		}
		else if(SedangHauling[playerid] == 5)
	    {
     		DisablePlayerRaceCheckpoint(playerid);
     		SendClientMessage(playerid, COLOR_JOB,"TRUCKING: {FFFFFF}Attach the trailer to your vehicle to order");
  			SedangHauling[playerid] = 6;
     		SetPlayerRaceCheckpoint(playerid, 1, 1424.8624, 2333.4939, 10.8203, 1424.8624, 2333.4939, 10.8203, 10.0);
       		return 1;
		}
		else if(SedangHauling[playerid] == 6)
		{
			if(IsTrailerAttachedToVehicle(GetPlayerVehicleID(playerid)))
			{
			    DisablePlayerRaceCheckpoint(playerid);
                SedangHauling[playerid] = 0;
                AddPlayerSalary(playerid, "Sidejob(Hauling)", 500);
                pData[playerid][pTruckerTime] += 30*60;
                DialogHauling[0] = false;
                DialogSaya[playerid][0] = false;
                DestroyVehicle(GetVehicleTrailer(GetPlayerVehicleID(playerid)));
                SendClientMessage(playerid, COLOR_JOB, "TRUCKING: {FFFFFF}$500 have been issued to your paycheck");
                return 1;
			}
		}
		if(SedangHauling[playerid] == 7)
	    {
     		DisablePlayerRaceCheckpoint(playerid);
     		SendClientMessage(playerid, COLOR_JOB,"TRUCKING: {FFFFFF}Attach the trailer to your vehicle to order");
  			SedangHauling[playerid] = 8;
     		SetPlayerRaceCheckpoint(playerid, 1, 1198.7153, 165.4331, 20.5056, 1198.7153, 165.4331, 20.5056, 10.0);
       		return 1;
		}
		else if(SedangHauling[playerid] == 8)
		{
			if(IsTrailerAttachedToVehicle(GetPlayerVehicleID(playerid)))
			{
			    DisablePlayerRaceCheckpoint(playerid);
                SedangHauling[playerid] = 0;
                AddPlayerSalary(playerid, "Sidejob(Hauling)", 500);
                pData[playerid][pTruckerTime] += 30*60;
                DialogHauling[0] = false;
                DialogSaya[playerid][0] = false;
                DestroyVehicle(GetVehicleTrailer(GetPlayerVehicleID(playerid)));
                SendClientMessage(playerid, COLOR_JOB, "TRUCKING: {FFFFFF}$500 have been issued to your paycheck");
                return 1;
			}
		}
		else if(SedangHauling[playerid] == 9)
	    {
     		DisablePlayerRaceCheckpoint(playerid);
     		SendClientMessage(playerid, COLOR_JOB,"TRUCKING: {FFFFFF}Attach the trailer to your vehicle to order");
  			SedangHauling[playerid] = 10;
     		SetPlayerRaceCheckpoint(playerid, 1, 1201.5385, 171.6184, 20.5035, 1201.5385, 171.6184, 20.5035, 10.0);
       		return 1;
		}
		else if(SedangHauling[playerid] == 10)
		{
			if(IsTrailerAttachedToVehicle(GetPlayerVehicleID(playerid)))
			{
			    DisablePlayerRaceCheckpoint(playerid);
                SedangHauling[playerid] = 0;
                AddPlayerSalary(playerid, "Sidejob(Hauling)", 500);
                pData[playerid][pTruckerTime] += 30*60;
                DialogHauling[0] = false;
                DialogSaya[playerid][0] = false;
                DestroyVehicle(GetVehicleTrailer(GetPlayerVehicleID(playerid)));
                SendClientMessage(playerid, COLOR_JOB, "TRUCKING: {FFFFFF}$500 have been issued to your paycheck");
                return 1;
			}
		}
		else if(SedangHauling[playerid] == 11)
	    {
     		DisablePlayerRaceCheckpoint(playerid);
     		SendClientMessage(playerid, COLOR_JOB,"TRUCKING: {FFFFFF}Attach the trailer to your vehicle to order");
  			SedangHauling[playerid] = 12;
     		SetPlayerRaceCheckpoint(playerid, 1, 2786.8313, -2417.9558, 13.6339, 2786.8313, -2417.9558, 13.6339, 10.0);
       		return 1;
		}
		else if(SedangHauling[playerid] == 12)
		{
			if(IsTrailerAttachedToVehicle(GetPlayerVehicleID(playerid)))
			{
			    DisablePlayerRaceCheckpoint(playerid);
                SedangHauling[playerid] = 0;
                AddPlayerSalary(playerid, "Sidejob(Hauling)", 500);
                pData[playerid][pTruckerTime] += 30*60;
                DialogHauling[0] = false;
                DialogSaya[playerid][0] = false;
                DestroyVehicle(GetVehicleTrailer(GetPlayerVehicleID(playerid)));
                SendClientMessage(playerid, COLOR_JOB, "TRUCKING: {FFFFFF}$500 have been issued to your paycheck");
                return 1;
			}
		}
		else if(SedangHauling[playerid] == 13)
	    {
     		DisablePlayerRaceCheckpoint(playerid);
     		SendClientMessage(playerid, COLOR_JOB,"TRUCKING: {FFFFFF}Attach the trailer to your vehicle to order");
  			SedangHauling[playerid] = 14;
     		SetPlayerRaceCheckpoint(playerid, 1, 1613.7815, 2236.2046, 10.3787, 1613.7815, 2236.2046, 10.3787, 10.0);
       		return 1;
		}
		else if(SedangHauling[playerid] == 14)
		{
			if(IsTrailerAttachedToVehicle(GetPlayerVehicleID(playerid)))
			{
			    DisablePlayerRaceCheckpoint(playerid);
                SedangHauling[playerid] = 0;
                AddPlayerSalary(playerid, "Sidejob(Hauling)", 500);
                pData[playerid][pTruckerTime] += 30*60;
                DialogHauling[0] = false;
                DialogSaya[playerid][0] = false;
                DestroyVehicle(GetVehicleTrailer(GetPlayerVehicleID(playerid)));
                SendClientMessage(playerid, COLOR_JOB, "TRUCKING: {FFFFFF}$500 have been issued to your paycheck");
                return 1;
			}
		}
		else if(SedangHauling[playerid] == 15)
	    {
     		DisablePlayerRaceCheckpoint(playerid);
     		SendClientMessage(playerid, COLOR_JOB,"TRUCKING: {FFFFFF}Attach the trailer to your vehicle to order");
  			SedangHauling[playerid] = 16;
     		SetPlayerRaceCheckpoint(playerid, 1, 2415.7803, -2470.1309, 13.6300, 2415.7803, -2470.1309, 13.6300, 10.0);
       		return 1;
		}
		else if(SedangHauling[playerid] == 16)
		{
			if(IsTrailerAttachedToVehicle(GetPlayerVehicleID(playerid)))
			{
			    DisablePlayerRaceCheckpoint(playerid);
                SedangHauling[playerid] = 0;
                AddPlayerSalary(playerid, "Sidejob(Hauling)", 500);
                pData[playerid][pTruckerTime] += 30*60;
                DialogHauling[0] = false;
                DialogSaya[playerid][0] = false;
                DestroyVehicle(GetVehicleTrailer(GetPlayerVehicleID(playerid)));
                SendClientMessage(playerid, COLOR_JOB, "TRUCKING: {FFFFFF}$500 have been issued to your paycheck");
                return 1;
			}
		}
		else if(SedangHauling[playerid] == 17)
	    {
     		DisablePlayerRaceCheckpoint(playerid);
     		SendClientMessage(playerid, COLOR_JOB,"TRUCKING: {FFFFFF}Attach the trailer to your vehicle to order");
  			SedangHauling[playerid] = 18;
     		SetPlayerRaceCheckpoint(playerid, 1, -980.1684, -713.3505, 32.0078, -980.1684, -713.3505, 32.0078, 10.0);
       		return 1;
		}
		else if(SedangHauling[playerid] == 18)
		{
			if(IsTrailerAttachedToVehicle(GetPlayerVehicleID(playerid)))
			{
			    DisablePlayerRaceCheckpoint(playerid);
                SedangHauling[playerid] = 0;
                AddPlayerSalary(playerid, "Sidejob(Hauling)", 500);
                pData[playerid][pTruckerTime] += 30*60;
                DialogHauling[0] = false;
                DialogSaya[playerid][0] = false;
                DestroyVehicle(GetVehicleTrailer(GetPlayerVehicleID(playerid)));
                SendClientMessage(playerid, COLOR_JOB, "TRUCKING: {FFFFFF}$500 have been issued to your paycheck");
                return 1;
			}
		}
		else if(SedangHauling[playerid] == 19)
		{
			DisablePlayerRaceCheckpoint(playerid);
			SendClientMessage(playerid, COLOR_JOB,"TRUCKING: {FFFFFF}Attach the trailer to your vehicle to order");
			SedangHauling[playerid] = 20;
			SetPlayerRaceCheckpoint(playerid, 1, -2226.1292, -2315.1055, 30.6045, -2226.1292, -2315.1055, 30.6045, 10.0);
			return 1;
		}
		else if(SedangHauling[playerid] == 20)
		{
			if(IsTrailerAttachedToVehicle(GetPlayerVehicleID(playerid)))
			{
			    DisablePlayerRaceCheckpoint(playerid);
                SedangHauling[playerid] = 0;
                AddPlayerSalary(playerid, "Sidejob(Hauling)", 500);
                pData[playerid][pTruckerTime] += 30*60;
                DialogHauling[0] = false;
                DialogSaya[playerid][0] = false;
                DestroyVehicle(GetVehicleTrailer(GetPlayerVehicleID(playerid)));
                SendClientMessage(playerid, COLOR_JOB, "TRUCKING: {FFFFFF}$500 have been issued to your paycheck");
                return 1;
			}
		}
	}*/
	if(pData[playerid][pTrackCar] == 1)
	{
		Info(playerid, "Anda telah berhasil menemukan kendaraan anda!");
		pData[playerid][pTrackCar] = 0;
		DisablePlayerRaceCheckpoint(playerid);
	}
	if(pData[playerid][pTrackHouse] == 1)
	{
		Info(playerid, "Anda telah berhasil menemukan rumah anda!");
		pData[playerid][pTrackHouse] = 0;
		DisablePlayerRaceCheckpoint(playerid);
	}
	if(pData[playerid][pTrackFlat] == 1)
	{
		Info(playerid, "Anda telah berhasil menemukan flat anda!");
		pData[playerid][pTrackFlat] = 0;
		DisablePlayerRaceCheckpoint(playerid);
	}
	if(pData[playerid][pTrackHotel] == 1)
	{
		Info(playerid, "Anda telah berhasil menemukan hotel anda!");
		pData[playerid][pTrackHotel] = 0;
		DisablePlayerRaceCheckpoint(playerid);
	}
	if(pData[playerid][pTrackBisnis] == 1)
	{
		Info(playerid, "Anda telah berhasil menemukan bisnis anda!");
		pData[playerid][pTrackBisnis] = 0;
		DisablePlayerRaceCheckpoint(playerid);
	}
	if(pData[playerid][pMission] > -1)
	{
		DisablePlayerRaceCheckpoint(playerid);
		//Info(playerid, "/buy , /gps(My Mission) , /storeproduct.");
	}
	if(pData[playerid][pHauling] > -1)
	{
		DisablePlayerRaceCheckpoint(playerid);
		//Info(playerid, "/buy , /gps(My Hauling) , /storegas.");
	}
	if(pData[playerid][pRestock] > -1)
	{
		DisablePlayerRaceCheckpoint(playerid);
		//Info(playerid, "/buy, /gps(My Restock Vending), /storestock.");
	}
    if(pData[playerid][pDealerMission] > -1)
	{
		DisablePlayerRaceCheckpoint(playerid);
		//Info(playerid, "/gps(My Dealer Mission) , /storeveh.");
	}
	if(CheckpointPacket[playerid] == 1)
	{
		CheckpointPacket[playerid] = 0;
		DisablePlayerRaceCheckpoint(playerid);
	}
	DisablePlayerRaceCheckpoint(playerid);
	return 1;
}
public OnPlayerHackTeleport(playerid, Float:distance)
{
	new Float:x, Float:y, Float:z;
	GetPlayerPos(playerid, x,y,z);
	if(!IsPlayerInRangeOfPoint(playerid, 3.0, x, y, z))
	{
		new string[50];
		format(string, sizeof(string), "%s have detected hack teleport.", pData[playerid][pName]);
		SendClientMessageToAll(-1, string);
		Kick(playerid);
	}
	return 1;
}
CMD:openpara(playerid)
{
	if(IsPlayerInAnyVehicle(playerid) && GetPlayerVehicleSeat(playerid) == 0)
	{
		new vid = GetPlayerVehicleID(playerid);
		if(IsToggleVehicleParachute(vid))
		{
			if(IsPlayerUsingVehPara(playerid))
			{
				StopVehicleParachuteAction(playerid);
				CallLocalFunction("OnVehicleParachuteThrown","dd",playerid,vid);
			}
			else
			{
				if(IsCollisionFlag(Item::GetCollisionFlags(vid,item_vehicle),POSITION_FLAG_AIR) && GetVehicleSpeed(vid) > 0.0)
				{
					StartVehicleParachuteAction(playerid);
					CallLocalFunction("OnVehicleParachuteOpened","dd",playerid,vid);
				}
				else
				{
					CallLocalFunction("OnVehicleParachuteOpenFail","dd",playerid,vid);
				}
			}
		}
	}
}
public OnVehicleParachuteThrown(playerid,vehicleid)
{
	InfoTD_MSG(playerid, 4000, "Vehicle Parachute ~r~thrown");
	return 1;
}

public OnVehicleParachuteOpened(playerid,vehicleid)
{
	InfoTD_MSG(playerid, 4000, "Vehicle Parachute ~g~opened");
	return 1;
}

public OnVehicleParachuteOpenFail(playerid,vehicleid)
{
	InfoTD_MSG(playerid, 4000, "Cannot use ~r~Parachute");
	return 1;
}
/*public OnPlayerAirbreak(playerid)
{
	SendClientMessage(playerid, -1, "You have detected airbreak teleport.");
	//Kick(playerid);
	return 1;
}
*/
public OnPlayerEnterCheckpoint(playerid)
{
	//race
    if(pData[playerid][pRaceIndex] != 0 && pData[playerid][pRaceWith] != INVALID_PLAYER_ID && !pData[playerid][pRaceFinish])
	{
		switch(pData[playerid][pRaceIndex])
		{
		    case 1:
		    {
			    SetRaceCP(playerid, 2, RaceData[pData[playerid][pRaceWith]][racePos2][0], RaceData[pData[playerid][pRaceWith]][racePos2][1], RaceData[pData[playerid][pRaceWith]][racePos2][2], 5.0);
				pData[playerid][pRaceIndex] = 2;
			}
			case 2:
			{
			    SetRaceCP(playerid, 2, RaceData[pData[playerid][pRaceWith]][racePos3][0], RaceData[pData[playerid][pRaceWith]][racePos3][1], RaceData[pData[playerid][pRaceWith]][racePos3][2], 5.0);
				pData[playerid][pRaceIndex] = 3;
			}
			case 3:
			{
			    SetRaceCP(playerid, 2, RaceData[pData[playerid][pRaceWith]][racePos4][0], RaceData[pData[playerid][pRaceWith]][racePos4][1], RaceData[pData[playerid][pRaceWith]][racePos4][2], 5.0);
				pData[playerid][pRaceIndex] = 4;
			}
			case 4:
			{
			    SetRaceCP(playerid, 2, RaceData[pData[playerid][pRaceWith]][racePos5][0], RaceData[pData[playerid][pRaceWith]][racePos5][1], RaceData[pData[playerid][pRaceWith]][racePos5][2], 5.0);
				pData[playerid][pRaceIndex] = 5;
			}
			case 5:
			{
			    SetRaceCP(playerid, 2, RaceData[pData[playerid][pRaceWith]][raceFinish][0], RaceData[pData[playerid][pRaceWith]][raceFinish][1], RaceData[pData[playerid][pRaceWith]][raceFinish][2], 5.0);
				pData[playerid][pRaceFinish] = 1;
			}
		}
	}
	if(pData[playerid][pSekolahSim] == 1)
	{
		new vehicleid = GetPlayerVehicleID(playerid);
		if(GetVehicleModel(vehicleid) == 426)
		{
			if (IsPlayerInRangeOfPoint(playerid,  3.0, dmvpoint1))
			{
				SetPlayerCheckpoint(playerid, dmvpoint2, 3.0);
			}
			if (IsPlayerInRangeOfPoint(playerid, 3.0, dmvpoint2))
			{
				TogglePlayerControllable(playerid, 0);
				showCD[playerid] = 1;
				Count = 6;
				countTimer = SetTimerEx("ppCountDown", 1000, 1, "i", playerid);
				SetPlayerCheckpoint(playerid, dmvpoint3, 3.0);
			}
			if (IsPlayerInRangeOfPoint(playerid, 3.0, dmvpoint3))
			{
				SetPlayerCheckpoint(playerid, dmvpoint4, 3.0);
			}
			if (IsPlayerInRangeOfPoint(playerid, 3.0, dmvpoint4))
			{
				SetPlayerCheckpoint(playerid, dmvpoint5, 3.0);
			}
			if (IsPlayerInRangeOfPoint(playerid, 3.0, dmvpoint5))
			{
				SetPlayerCheckpoint(playerid, dmvpoint6, 3.0);
			}
			if (IsPlayerInRangeOfPoint(playerid, 3.0, dmvpoint6))
			{
				SetPlayerCheckpoint(playerid, dmvpoint7, 3.0);
			}
			if (IsPlayerInRangeOfPoint(playerid, 3.0, dmvpoint7))
			{
				SetPlayerCheckpoint(playerid, dmvpoint8, 3.0);
			}
			if (IsPlayerInRangeOfPoint(playerid, 3.0, dmvpoint8))
			{
				SetPlayerCheckpoint(playerid, dmvpoint9, 3.0);
			}
			if (IsPlayerInRangeOfPoint(playerid, 3.0, dmvpoint9))
			{
				SetPlayerCheckpoint(playerid, dmvpoint10, 3.0);
			}
			if (IsPlayerInRangeOfPoint(playerid, 3.0, dmvpoint10))
			{
				SetPlayerCheckpoint(playerid, dmvpoint11, 3.0);
			}
			if (IsPlayerInRangeOfPoint(playerid, 3.0, dmvpoint11))
			{
				SetPlayerCheckpoint(playerid, dmvpoint12, 3.0);
			}
			if (IsPlayerInRangeOfPoint(playerid, 3.0, dmvpoint12))
			{
				pData[playerid][pDriveLic] = 1;
				pData[playerid][pSekolahSim] = 0;
				Global[SKM] = 0;
				DisablePlayerCheckpoint(playerid);
				pData[playerid][pDriveLicTime] = gettime() +  (15 * 86400);
				Info(playerid, "Anda telah berhasil membuat SIM");
				RemovePlayerFromVehicle(playerid);
				SetTimerEx("RespawnPV", 3000, false, "d", vehicleid);
			}
		}
	}
	if (IsPlayerInRangeOfPoint(playerid, 2.0, 1642.3374, -2326.3716, 13.5469))
	{
		DisablePlayerCheckpoint(playerid);
	}
	//butcher
	if(GetPVarInt(playerid,"OnWork"))
	{
		DisablePlayerCheckpoint(playerid);
	}

	if(IsPlayerInRangeOfPoint(playerid, 2.0, 2846.0537,955.7325,10.7500)) //lv
	{
 		DisablePlayerCheckpoint(playerid);
 		return 1;
	}
	if(IsPlayerInRangeOfPoint(playerid, 2.0, -1873.7448,1417.5586,7.1763)) //sf
	{
 		DisablePlayerCheckpoint(playerid);
 		return 1;
	}
	if(IsPlayerInRangeOfPoint(playerid, 2.0, 163.5530,-54.8748,1.5781)) //ls
	{
 		DisablePlayerCheckpoint(playerid);
 		return 1;
	}
	if(IsPlayerInRangeOfPoint(playerid, 2.0, 1466.4801,1039.0343,10.0313)) //pusat
	{
 		DisablePlayerCheckpoint(playerid);
 		return 1;
	}

	if(pData[playerid][CarryingLog] != -1)
	{
		if(GetPVarInt(playerid, "LoadingCooldown") > gettime()) return 1;
		new vehicleid = GetPVarInt(playerid, "LastVehicleID"), type[64], carid = -1;
		if(pData[playerid][CarryingLog] == 0)
		{
			type = "Metal";
		}
		else if(pData[playerid][CarryingLog] == 1)
		{
			type = "Coal";
		}
		else
		{
			type = "Unknown";
		}
		if(Vehicle_LogCount(vehicleid) >= LOG_LIMIT) return Error(playerid, "You can't load any more ores to this vehicle.");
		if((carid = Vehicle_Nearest2(playerid)) != -1)
		{
			if(pData[playerid][CarryingLog] == 0)
			{
				pvData[carid][cMetal] += 1;
			}
			else if(pData[playerid][CarryingLog] == 1)
			{
				pvData[carid][cCoal] += 1;
			}
		}
		LogStorage[vehicleid][ pData[playerid][CarryingLog] ]++;
		Info(playerid, "MINING: Loaded %s.", type);
		ApplyAnimation(playerid, "CARRY", "putdwn05", 4.1, 0, 1, 1, 0, 0, 1);
		Player_RemoveLog(playerid);
		DisablePlayerCheckpoint(playerid);
		return 1;
	}
	if(pData[playerid][pFindEms] != INVALID_PLAYER_ID)
	{
		pData[playerid][pFindEms] = INVALID_PLAYER_ID;
		DisablePlayerCheckpoint(playerid);
	}
	if(pData[playerid][pSideJob] == 1)
	{
		new vehicleid = GetPlayerVehicleID(playerid);
		if(GetVehicleModel(vehicleid) == 574)
		{
			if (IsPlayerInRangeOfPoint(playerid, 7.0,sweperpoint1))
			{
				SetPlayerCheckpoint(playerid, sweperpoint2, 7.0);
				GameTextForPlayer(playerid, "~g~Clean!", 1000, 3);
			}
			if (IsPlayerInRangeOfPoint(playerid, 7.0,sweperpoint2))
			{
				SetPlayerCheckpoint(playerid, sweperpoint3, 7.0);
				GameTextForPlayer(playerid, "~g~Clean!", 1000, 3);
			}
			if (IsPlayerInRangeOfPoint(playerid, 7.0,sweperpoint3))
			{
				SetPlayerCheckpoint(playerid, sweperpoint4, 7.0);
				GameTextForPlayer(playerid, "~g~Clean!", 1000, 3);
			}
			if (IsPlayerInRangeOfPoint(playerid, 7.0,sweperpoint4))
			{
				SetPlayerCheckpoint(playerid, sweperpoint5, 7.0);
			    GameTextForPlayer(playerid, "~g~Clean!", 1000, 3);
			}
			if (IsPlayerInRangeOfPoint(playerid, 7.0,sweperpoint5))
			{
				SetPlayerCheckpoint(playerid, sweperpoint6, 7.0);
				GameTextForPlayer(playerid, "~g~Clean!", 1000, 3);
			}
			if (IsPlayerInRangeOfPoint(playerid, 7.0,sweperpoint6))
			{
				SetPlayerCheckpoint(playerid, sweperpoint7, 7.0);
				GameTextForPlayer(playerid, "~g~Clean!", 1000, 3);
			}
			if (IsPlayerInRangeOfPoint(playerid, 7.0,sweperpoint7))
			{
				SetPlayerCheckpoint(playerid, sweperpoint8, 7.0);
				GameTextForPlayer(playerid, "~g~Clean!", 1000, 3);
			}
			if (IsPlayerInRangeOfPoint(playerid, 7.0,sweperpoint8))
			{
				SetPlayerCheckpoint(playerid, sweperpoint9, 7.0);
				GameTextForPlayer(playerid, "~g~Clean!", 1000, 3);
			}
			if (IsPlayerInRangeOfPoint(playerid, 7.0,sweperpoint9))
			{
				SetPlayerCheckpoint(playerid, sweperpoint10, 7.0);
				GameTextForPlayer(playerid, "~g~Clean!", 1000, 3);
			}
			if (IsPlayerInRangeOfPoint(playerid, 7.0,sweperpoint10))
			{
				SetPlayerCheckpoint(playerid, sweperpoint11, 7.0);
				GameTextForPlayer(playerid, "~g~Clean!", 1000, 3);
			}
			if (IsPlayerInRangeOfPoint(playerid, 7.0,sweperpoint11))
			{
				SetPlayerCheckpoint(playerid, sweperpoint12, 7.0);
				GameTextForPlayer(playerid, "~g~Clean!", 1000, 3);
			}
			if(IsPlayerInRangeOfPoint(playerid, 7.0,sweperpoint12))
			{
				pData[playerid][pSideJob] = 0;
				pData[playerid][pSweeperTime] = 900;
				DisablePlayerCheckpoint(playerid);
				AddPlayerSalary(playerid, "Sidejob(Sweeper)", 10000);
				Info(playerid, "Sidejob(Bus) telah masuk ke pending salary anda!");
				RemovePlayerFromVehicle(playerid);
				SetTimerEx("RespawnPV", 3000, false, "d", vehicleid);
			}
		}
	}
	if(pData[playerid][pSideJob] == 2)
	{
		new vehicleid = GetPlayerVehicleID(playerid);
		if(GetVehicleModel(vehicleid) == 431)
		{
			if (IsPlayerInRangeOfPoint(playerid, 7.0,buspoint1))
			{
				SetPlayerCheckpoint(playerid, buspoint2, 7.0);
			}
			if (IsPlayerInRangeOfPoint(playerid, 7.0,buspoint2))
			{
				SetPlayerCheckpoint(playerid, buspoint3, 7.0);
			}
			if (IsPlayerInRangeOfPoint(playerid, 7.0,buspoint3))
			{
				SetPlayerCheckpoint(playerid, buspoint4, 7.0);
			}
			if (IsPlayerInRangeOfPoint(playerid, 7.0,buspoint4))
			{
				SetPlayerCheckpoint(playerid, buspoint5, 7.0);
			}
			if (IsPlayerInRangeOfPoint(playerid, 7.0,buspoint5))
			{
				SetPlayerCheckpoint(playerid, buspoint6, 7.0);
			}
			if (IsPlayerInRangeOfPoint(playerid, 7.0,buspoint6))
			{
				SetPlayerCheckpoint(playerid, buspoint7, 7.0);
			}
			if (IsPlayerInRangeOfPoint(playerid, 7.0,buspoint7))
			{
				SetPlayerCheckpoint(playerid, buspoint8, 7.0);
			}
			if (IsPlayerInRangeOfPoint(playerid, 7.0,buspoint8))
			{
				SetPlayerCheckpoint(playerid, buspoint9, 7.0);
			}
			if (IsPlayerInRangeOfPoint(playerid, 7.0,buspoint9))
			{
				SetPlayerCheckpoint(playerid, buspoint10, 7.0);
			}
			if (IsPlayerInRangeOfPoint(playerid, 7.0,buspoint10))
			{
				SetPlayerCheckpoint(playerid, buspoint11, 7.0);
			}
			if (IsPlayerInRangeOfPoint(playerid, 7.0,buspoint11))
			{
				SetPlayerCheckpoint(playerid, buspoint12, 7.0);
			}
			if (IsPlayerInRangeOfPoint(playerid, 7.0,buspoint12))
			{
				SetPlayerCheckpoint(playerid, buspoint13, 7.0);
			}
			if (IsPlayerInRangeOfPoint(playerid, 7.0,buspoint13))
			{
				SetPlayerCheckpoint(playerid, buspoint14, 7.0);
			}
			if (IsPlayerInRangeOfPoint(playerid, 7.0,buspoint14))
			{
				SetPlayerCheckpoint(playerid, buspoint15, 7.0);
			}
			if (IsPlayerInRangeOfPoint(playerid, 7.0,buspoint15))
			{
				SetPlayerCheckpoint(playerid, buspoint16, 7.0);
			}
			if (IsPlayerInRangeOfPoint(playerid, 7.0,buspoint16))
			{
				SetPlayerCheckpoint(playerid, buspoint17, 7.0);
			}
			if (IsPlayerInRangeOfPoint(playerid, 7.0,buspoint17))
			{
				SetPlayerCheckpoint(playerid, buspoint18, 7.0);
			}
			if (IsPlayerInRangeOfPoint(playerid, 7.0,buspoint18))
			{
				SetPlayerCheckpoint(playerid, buspoint19, 7.0);
			}
			if (IsPlayerInRangeOfPoint(playerid, 7.0,buspoint19))
			{
				SetPlayerCheckpoint(playerid, buspoint20, 7.0);
			}
			if (IsPlayerInRangeOfPoint(playerid, 7.0,buspoint20))
			{
				SetPlayerCheckpoint(playerid, buspoint21, 7.0);
			}
			if (IsPlayerInRangeOfPoint(playerid, 7.0,buspoint21))
			{
				SetPlayerCheckpoint(playerid, buspoint22, 7.0);
			}
			if (IsPlayerInRangeOfPoint(playerid, 7.0,buspoint22))
			{
				SetPlayerCheckpoint(playerid, buspoint23, 7.0);
			}
			if (IsPlayerInRangeOfPoint(playerid, 7.0,buspoint23))
			{
				SetPlayerCheckpoint(playerid, buspoint24, 7.0);
			}
			if (IsPlayerInRangeOfPoint(playerid, 7.0,buspoint24))
			{
				SetPlayerCheckpoint(playerid, buspoint25, 7.0);
			}
			if (IsPlayerInRangeOfPoint(playerid, 7.0,buspoint25))
			{
				SetPlayerCheckpoint(playerid, buspoint26, 7.0);
			}
			if (IsPlayerInRangeOfPoint(playerid, 7.0,buspoint26))
			{
				SetPlayerCheckpoint(playerid, buspoint27, 7.0);
			}
			if(IsPlayerInRangeOfPoint(playerid, 7.0,buspoint27))
			{
				pData[playerid][pSideJob] = 0;
				pData[playerid][pBusTime] = 1200;
				DisablePlayerCheckpoint(playerid);
				AddPlayerSalary(playerid, "Sidejob(Bus Route B)", 12500);
				Info(playerid, "Sidejob(Bus) telah masuk ke pending salary anda!");
				RemovePlayerFromVehicle(playerid);
				SetTimerEx("RespawnPV", 3000, false, "d", vehicleid);
			}
		}
	}
	if(pData[playerid][pSideJob] == 2)
	{
		new vehicleid = GetPlayerVehicleID(playerid);
		if(GetVehicleModel(vehicleid) == 431)
		{
		    if (IsPlayerInRangeOfPoint(playerid, 7.0,cpbus1))
			{
			    SetPlayerCheckpoint(playerid,cpbus2, 7.0);
			}
			if (IsPlayerInRangeOfPoint(playerid, 7.0,cpbus2))
			{
			    SetPlayerCheckpoint(playerid,cpbus3, 7.0);
			}
			if (IsPlayerInRangeOfPoint(playerid, 7.0,cpbus3))
			{
			    SetPlayerCheckpoint(playerid,cpbus4, 7.0);
			}
			if (IsPlayerInRangeOfPoint(playerid, 7.0,cpbus4))
			{
			    SetPlayerCheckpoint(playerid,cpbus5, 7.0);
			}
			if (IsPlayerInRangeOfPoint(playerid, 7.0,cpbus5))
			{
			    SetPlayerCheckpoint(playerid,cpbus6, 7.0);
			}
			if (IsPlayerInRangeOfPoint(playerid, 7.0,cpbus6))
			{
			    SetPlayerCheckpoint(playerid,cpbus7, 7.0);
			}
			if (IsPlayerInRangeOfPoint(playerid, 7.0,cpbus7))
			{
			    SetPlayerCheckpoint(playerid,cpbus8, 7.0);
			}
			if (IsPlayerInRangeOfPoint(playerid, 7.0,cpbus8))
			{
			    SetPlayerCheckpoint(playerid,cpbus9, 7.0);
			}
			if (IsPlayerInRangeOfPoint(playerid, 7.0,cpbus9))
			{
			    SetPlayerCheckpoint(playerid,cpbus10, 7.0);
			}
			if (IsPlayerInRangeOfPoint(playerid, 7.0,cpbus10))
			{
			    SetPlayerCheckpoint(playerid,cpbus11, 7.0);
			}
			if (IsPlayerInRangeOfPoint(playerid, 7.0,cpbus11))
			{
			    SetPlayerCheckpoint(playerid,cpbus12, 7.0);
			}
			if (IsPlayerInRangeOfPoint(playerid, 7.0,cpbus12))
			{
			    SetPlayerCheckpoint(playerid,cpbus13, 7.0);
			}
			if (IsPlayerInRangeOfPoint(playerid, 7.0,cpbus13))
			{
			    SetPlayerCheckpoint(playerid,cpbus14, 7.0);
			}
			if (IsPlayerInRangeOfPoint(playerid, 7.0,cpbus14))
			{
			    SetPlayerCheckpoint(playerid,cpbus15, 7.0);
			}
			if (IsPlayerInRangeOfPoint(playerid, 7.0,cpbus15))
			{
			    SetPlayerCheckpoint(playerid,cpbus16, 7.0);
			}
			if (IsPlayerInRangeOfPoint(playerid, 7.0,cpbus16))
			{
			    SetPlayerCheckpoint(playerid,cpbus17, 7.0);
			}
			if (IsPlayerInRangeOfPoint(playerid, 7.0,cpbus17))
			{
			    SetPlayerCheckpoint(playerid,cpbus18, 7.0);
			}
			if (IsPlayerInRangeOfPoint(playerid, 7.0,cpbus18))
			{
			    SetPlayerCheckpoint(playerid,cpbus19, 7.0);
			}
			if (IsPlayerInRangeOfPoint(playerid, 7.0,cpbus19))
			{
			    SetPlayerCheckpoint(playerid,cpbus20, 7.0);
			}
			if (IsPlayerInRangeOfPoint(playerid, 7.0,cpbus20))
			{
			    SetPlayerCheckpoint(playerid,cpbus21, 7.0);
			}
			if (IsPlayerInRangeOfPoint(playerid, 7.0,cpbus21))
			{
			    SetPlayerCheckpoint(playerid,cpbus22, 7.0);
			}
			if (IsPlayerInRangeOfPoint(playerid, 7.0,cpbus22))
			{
			    SetPlayerCheckpoint(playerid,cpbus23, 7.0);
			}
			if(IsPlayerInRangeOfPoint(playerid, 7.0,cpbus23))
			{
				SetPlayerCheckpoint(playerid,cpbus24, 7.0);
			}
			if(IsPlayerInRangeOfPoint(playerid, 7.0,cpbus24))
			{
			    pData[playerid][pSideJob] = 0;
				pData[playerid][pBusTime] = 1200;
				DisablePlayerCheckpoint(playerid);
				AddPlayerSalary(playerid, "Sidejob(Bus Route B)", 15500);
				Info(playerid, "Sidejob(Bus) telah masuk ke pending salary anda!");
				RemovePlayerFromVehicle(playerid);
				SetTimerEx("RespawnPV", 3000, false, "d", vehicleid);
			}
		}
	}
	if(pData[playerid][pSideJob] == 2)
	{
		new vehicleid = GetPlayerVehicleID(playerid);
		if(GetVehicleModel(vehicleid) == 431)
		{
		    if (IsPlayerInRangeOfPoint(playerid, 7.0,buscp1))
			{
			    SetPlayerCheckpoint(playerid,buscp2, 7.0);
			}
			if (IsPlayerInRangeOfPoint(playerid, 7.0,buscp2))
			{
			    SetPlayerCheckpoint(playerid,buscp3, 7.0);
			}
			if (IsPlayerInRangeOfPoint(playerid, 7.0,buscp3))
			{
			    SetPlayerCheckpoint(playerid,buscp4, 7.0);
			}
			if (IsPlayerInRangeOfPoint(playerid, 7.0,buscp4))
			{
			    SetPlayerCheckpoint(playerid,buscp5, 7.0);
			}
			if (IsPlayerInRangeOfPoint(playerid, 7.0,buscp5))
			{
			    SetPlayerCheckpoint(playerid,buscp6, 7.0);
			}
			if (IsPlayerInRangeOfPoint(playerid, 7.0,buscp6))
			{
			    SetPlayerCheckpoint(playerid,buscp7, 7.0);
			}
			if (IsPlayerInRangeOfPoint(playerid, 7.0,buscp7))
			{
			    SetPlayerCheckpoint(playerid,buscp8, 7.0);
			}
			if (IsPlayerInRangeOfPoint(playerid, 7.0,buscp8))
			{
			    SetPlayerCheckpoint(playerid,buscp9, 7.0);
			}
			if (IsPlayerInRangeOfPoint(playerid, 7.0,buscp9))
			{
			    SetPlayerCheckpoint(playerid,buscp10, 7.0);
			}
			if (IsPlayerInRangeOfPoint(playerid, 7.0,buscp10))
			{
			    SetPlayerCheckpoint(playerid,buscp11, 7.0);
			}
			if (IsPlayerInRangeOfPoint(playerid, 7.0,buscp11))
			{
			    SetPlayerCheckpoint(playerid,buscp12, 7.0);
			}
			if (IsPlayerInRangeOfPoint(playerid, 7.0,buscp12))
			{
			    SetPlayerCheckpoint(playerid,buscp13, 7.0);
			}
			if (IsPlayerInRangeOfPoint(playerid, 7.0,buscp13))
			{
			    SetPlayerCheckpoint(playerid,buscp14, 7.0);
			}
			if (IsPlayerInRangeOfPoint(playerid, 7.0,buscp14))
			{
			    SetPlayerCheckpoint(playerid,buscp15, 7.0);
			}
			if (IsPlayerInRangeOfPoint(playerid, 7.0,buscp15))
			{
			    SetPlayerCheckpoint(playerid,buscp16, 7.0);
			}
			if (IsPlayerInRangeOfPoint(playerid, 7.0,buscp16))
			{
			    SetPlayerCheckpoint(playerid,buscp17, 7.0);
			}
			if (IsPlayerInRangeOfPoint(playerid, 7.0,buscp17))
			{
			    SetPlayerCheckpoint(playerid,buscp18, 7.0);
			}
			if (IsPlayerInRangeOfPoint(playerid, 7.0,buscp18))
			{
			    SetPlayerCheckpoint(playerid,buscp19, 7.0);
			}
			if (IsPlayerInRangeOfPoint(playerid, 7.0,buscp19))
			{
			    SetPlayerCheckpoint(playerid,buscp20, 7.0);
			}
			if (IsPlayerInRangeOfPoint(playerid, 7.0,buscp20))
			{
			    SetPlayerCheckpoint(playerid,buscp21, 7.0);
			}
			if (IsPlayerInRangeOfPoint(playerid, 7.0,buscp21))
			{
			    pData[playerid][pSideJob] = 0;
				pData[playerid][pBusTime] = 1200;
				DisablePlayerCheckpoint(playerid);
				AddPlayerSalary(playerid, "Sidejob(Bus Route C)", 20000);
				Info(playerid, "Sidejob(Bus) telah masuk ke pending salary anda!");
				RemovePlayerFromVehicle(playerid);
				SetTimerEx("RespawnPV", 3000, false, "d", vehicleid);
			}
		}
	}
	if(pData[playerid][pSideJob] == 3)
	{
		new vehicleid = GetPlayerVehicleID(playerid);
		if(IsAForVeh(vehicleid))
		{
			if (IsPlayerInRangeOfPoint(playerid, 4.0, forpoint1))
			{
				SetPlayerCheckpoint(playerid, forpoint2, 4.0);
				TogglePlayerControllable(playerid, 0);
				AddPlayerSalary(playerid, "Sidejob(Forklift)", 20000);
				for(new i =0 ; i < 3; i++)
				{
					PlayerTextDrawShow(playerid, Loading[i][playerid]);
				}
				PlayerTextDrawSetString(playerid, Loading[2][playerid], "Mengangkat");
				pData[playerid][pActivity] = SetTimerEx("ForkliftTake", 400, true, "i", playerid);
				return 1;
			}
			if (IsPlayerInRangeOfPoint(playerid, 4.0, forpoint2))
			{
				SetPlayerCheckpoint(playerid, forpoint3, 4.0);
				TogglePlayerControllable(playerid, 0);
				AddPlayerSalary(playerid, "Sidejob(Forklift)", 20000);
				for(new i =0 ; i < 3; i++)
				{
					PlayerTextDrawShow(playerid, Loading[i][playerid]);
				}
				PlayerTextDrawSetString(playerid, Loading[2][playerid], "Meletakkan");
				pData[playerid][pActivity] = SetTimerEx("ForkliftDown", 400, true, "i", playerid);
				return 1;
			}
			if (IsPlayerInRangeOfPoint(playerid, 4.0, forpoint3))
			{
				SetPlayerCheckpoint(playerid, forpoint4, 4.0);
				TogglePlayerControllable(playerid, 0);
				AddPlayerSalary(playerid, "Sidejob(Forklift)", 20000);
				for(new i =0 ; i < 3; i++)
				{
					PlayerTextDrawShow(playerid, Loading[i][playerid]);
				}
				PlayerTextDrawSetString(playerid, Loading[2][playerid], "Mengangkat");
				pData[playerid][pActivity] = SetTimerEx("ForkliftTake", 400, true, "i", playerid);
				return 1;
			}
			if (IsPlayerInRangeOfPoint(playerid, 4.0, forpoint4))
			{
				SetPlayerCheckpoint(playerid, forpoint5, 4.0);
				TogglePlayerControllable(playerid, 0);
				AddPlayerSalary(playerid, "Sidejob(Forklift)", 20000);
				for(new i =0 ; i < 3; i++)
				{
					PlayerTextDrawShow(playerid, Loading[i][playerid]);
				}
				PlayerTextDrawSetString(playerid, Loading[2][playerid], "Meletakkan");
				pData[playerid][pActivity] = SetTimerEx("ForkliftDown", 400, true, "i", playerid);
				return 1;
			}
			if (IsPlayerInRangeOfPoint(playerid, 4.0, forpoint5))
			{
				SetPlayerCheckpoint(playerid, forpoint6, 4.0);
				TogglePlayerControllable(playerid, 0);
				AddPlayerSalary(playerid, "Sidejob(Forklift)", 20000);
				for(new i =0 ; i < 3; i++)
				{
					PlayerTextDrawShow(playerid, Loading[i][playerid]);
				}
				PlayerTextDrawSetString(playerid, Loading[2][playerid], "Mengangkat");
				pData[playerid][pActivity] = SetTimerEx("ForkliftTake", 400, true, "i", playerid);
				return 1;
			}
			if (IsPlayerInRangeOfPoint(playerid, 4.0, forpoint6))
			{
				SetPlayerCheckpoint(playerid, forpoint7, 4.0);
				TogglePlayerControllable(playerid, 0);
				AddPlayerSalary(playerid, "Sidejob(Forklift)", 20000);
				for(new i =0 ; i < 3; i++)
				{
					PlayerTextDrawShow(playerid, Loading[i][playerid]);
				}
				PlayerTextDrawSetString(playerid, Loading[2][playerid], "Meletakkan");
				pData[playerid][pActivity] = SetTimerEx("ForkliftDown", 400, true, "i", playerid);
				return 1;
			}
			if (IsPlayerInRangeOfPoint(playerid, 4.0, forpoint7))
			{
				SetPlayerCheckpoint(playerid, forpoint8, 4.0);
				TogglePlayerControllable(playerid, 0);
				AddPlayerSalary(playerid, "Sidejob(Forklift)", 20000);
				for(new i =0 ; i < 3; i++)
				{
					PlayerTextDrawShow(playerid, Loading[i][playerid]);
				}
				PlayerTextDrawSetString(playerid, Loading[2][playerid], "Mengangkat");
				pData[playerid][pActivity] = SetTimerEx("ForkliftTake", 400, true, "i", playerid);
				return 1;
			}
			if (IsPlayerInRangeOfPoint(playerid, 4.0, forpoint8))
			{
				SetPlayerCheckpoint(playerid, forpoint9, 4.0);
				TogglePlayerControllable(playerid, 0);
				AddPlayerSalary(playerid, "Sidejob(Forklift)", 20000);
				for(new i =0 ; i < 3; i++)
				{
					PlayerTextDrawShow(playerid, Loading[i][playerid]);
				}
				PlayerTextDrawSetString(playerid, Loading[2][playerid], "Meletakkan");
				pData[playerid][pActivity] = SetTimerEx("ForkliftDown", 400, true, "i", playerid);
				return 1;
			}
			if (IsPlayerInRangeOfPoint(playerid, 4.0, forpoint9))
			{
				SetPlayerCheckpoint(playerid, forpoint10, 4.0);
				TogglePlayerControllable(playerid, 0);
				AddPlayerSalary(playerid, "Sidejob(Forklift)", 20000);
				for(new i =0 ; i < 3; i++)
				{
					PlayerTextDrawShow(playerid, Loading[i][playerid]);
				}
				PlayerTextDrawSetString(playerid, Loading[2][playerid], "Mengangkat");
				pData[playerid][pActivity] = SetTimerEx("ForkliftTake", 400, true, "i", playerid);
				return 1;
			}
			if (IsPlayerInRangeOfPoint(playerid, 4.0, forpoint10))
			{
				pData[playerid][pSideJob] = 0;
				pData[playerid][pForkliftTime] = 900;
				DisablePlayerCheckpoint(playerid);
				AddPlayerSalary(playerid, "Sidejob(Forklift)", 20000);
				Info(playerid, "Sidejob(Forklift) telah masuk ke pending salary anda!");
				RemovePlayerFromVehicle(playerid);
				DestroyDynamicObject(GetPVarInt(playerid, "box"));
				SetTimerEx("RespawnPV", 3000, false, "d", vehicleid);
				return 1;
			}
		}
	}
	if(pData[playerid][pSideJob] == 4)
	{
		new vehicleid = GetPlayerVehicleID(playerid);
		if(IsAMowerVeh(vehicleid))
		{
			if(IsPlayerInRangeOfPoint(playerid, 3.0, mowpoint1))
			{
				SetPlayerCheckpoint(playerid, mowpoint2, 3.0);
			}
			if(IsPlayerInRangeOfPoint(playerid, 3.0, mowpoint2))
			{
				SetPlayerCheckpoint(playerid, mowpoint3, 3.0);
			}
			if(IsPlayerInRangeOfPoint(playerid, 3.0, mowpoint3))
			{
				SetPlayerCheckpoint(playerid, mowpoint4, 3.0);
				TogglePlayerControllable(playerid, 0);
                pData[playerid][pActivity] = SetTimerEx("PotongRumput", 1300, true, "i", playerid);
                PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Cutting Grass...");
                PlayerTextDrawShow(playerid, ActiveTD[playerid]);
                ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
                return 1;
			}
			if(IsPlayerInRangeOfPoint(playerid, 3.0, mowpoint4))
			{
				SetPlayerCheckpoint(playerid, mowpoint5, 3.0);
				TogglePlayerControllable(playerid, 0);
                pData[playerid][pActivity] = SetTimerEx("PotongRumput", 1300, true, "i", playerid);
                PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Cutting Grass...");
                PlayerTextDrawShow(playerid, ActiveTD[playerid]);
                ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
                return 1;
			}
			if(IsPlayerInRangeOfPoint(playerid, 3.0, mowpoint5))
			{
				SetPlayerCheckpoint(playerid, mowpoint6, 3.0);
			}
			if(IsPlayerInRangeOfPoint(playerid, 3.0, mowpoint6))
			{
				SetPlayerCheckpoint(playerid, mowpoint7, 3.0);
			}
			if(IsPlayerInRangeOfPoint(playerid, 3.0, mowpoint7))
			{
				SetPlayerCheckpoint(playerid, mowpoint8, 3.0);
				TogglePlayerControllable(playerid, 0);
                pData[playerid][pActivity] = SetTimerEx("PotongRumput", 1300, true, "i", playerid);
                PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Cutting Grass...");
                PlayerTextDrawShow(playerid, ActiveTD[playerid]);
                ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
                return 1;
			}
			if(IsPlayerInRangeOfPoint(playerid, 3.0, mowpoint8))
			{
				SetPlayerCheckpoint(playerid, mowpoint9, 3.0);
			}
			if(IsPlayerInRangeOfPoint(playerid, 3.0, mowpoint9))
			{
				SetPlayerCheckpoint(playerid, mowpoint10, 3.0);
				TogglePlayerControllable(playerid, 0);
                pData[playerid][pActivity] = SetTimerEx("PotongRumput", 1300, true, "i", playerid);
                PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Cutting Grass...");
                PlayerTextDrawShow(playerid, ActiveTD[playerid]);
                ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
                return 1;
			}
			if(IsPlayerInRangeOfPoint(playerid, 3.0, mowpoint10))
			{
				SetPlayerCheckpoint(playerid, mowpoint11, 3.0);
				TogglePlayerControllable(playerid, 0);
                pData[playerid][pActivity] = SetTimerEx("PotongRumput", 1300, true, "i", playerid);
                PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Cutting Grass...");
                PlayerTextDrawShow(playerid, ActiveTD[playerid]);
                ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
                return 1;
			}
			if(IsPlayerInRangeOfPoint(playerid, 3.0, mowpoint11))
			{
				SetPlayerCheckpoint(playerid, mowpoint12, 3.0);
			}
			if(IsPlayerInRangeOfPoint(playerid, 3.0, mowpoint12))
			{
				SetPlayerCheckpoint(playerid, mowpoint13, 3.0);
			}
			if(IsPlayerInRangeOfPoint(playerid, 3.0, mowpoint13))
			{
				SetPlayerCheckpoint(playerid, mowpoint14, 3.0);
			}
			if(IsPlayerInRangeOfPoint(playerid, 3.0, mowpoint14))
			{
				SetPlayerCheckpoint(playerid, mowpoint15, 3.0);
			}
			if(IsPlayerInRangeOfPoint(playerid, 3.0, mowpoint15))
			{
				SetPlayerCheckpoint(playerid, mowpoint16, 3.0);
			}
			if(IsPlayerInRangeOfPoint(playerid, 3.0, mowpoint16))
			{
				SetPlayerCheckpoint(playerid, mowpoint17, 3.0);
			}
			if(IsPlayerInRangeOfPoint(playerid, 3.0, mowpoint17))
			{
				DisablePlayerCheckpoint(playerid);
				pData[playerid][pSideJob] = 0;
				pData[playerid][pSideJobTime] = 720;
				AddPlayerSalary(playerid, "Sidejob(Mower)", 10000);
				Info(playerid, "Sidejob(Mower) telah masuk ke pending salary anda!");
				RespawnPV(vehicleid);
			}
		}
    }
    if(SedangAnterPizza[playerid] == 1) // pizza
	{
        SedangAnterPizza[playerid] = 0;
	    pData[playerid][pPizzaTime] = 600;
    	AddPlayerSalary(playerid, "Sidejob(Pizza)", 50000);
    	new fmt_str[1280];
    	RemovePlayerAttachedObject(playerid,1);
    	format(fmt_str, sizeof fmt_str, "PIZZA JOB: {ffffff}Kamu mendapatkan $50.00 dari hasil mengirim pizza dan dimasukkan ke salary.");
    	SendClientMessage(playerid,COLOR_RIKO, "PIZZA JOB: {ffffff}Kamu berhasil mengirimkan pizza dan mendapat delay 10 menit.");
        SendClientMessage(playerid,COLOR_RIKO, fmt_str);
        DisablePlayerCheckpoint(playerid);
	}
    if(pData[playerid][pJob] == 4 || pData[playerid][pJob2] == 4)
	{
		new vehicleid = GetPlayerVehicleID(playerid);
		if(GetVehicleModel(vehicleid) == 578)
		{
			if (IsPlayerInRangeOfPoint(playerid, 4.0,containerpoint1))
			{
				SetPlayerCheckpoint(playerid, 2869.1934,917.6111,10.7500, 4.0);
				TogglePlayerControllable(playerid, 0);
				PlayerTextDrawSetString(playerid, Loading[2][playerid], "Memuat Container..");
				for(new i =0 ; i < 3; i++)
				{
					PlayerTextDrawShow(playerid, Loading[i][playerid]);
				}
				pData[playerid][pActivity] = SetTimerEx("ContainerTake", 400, true, "i", playerid);
				return 1;
			}
			if (IsPlayerInRangeOfPoint(playerid, 4.0,containerpoint2))
			{
				TogglePlayerControllable(playerid, 0);
				PlayerTextDrawSetString(playerid, Loading[2][playerid], "Meletakkan Container..");
				for(new i =0 ; i < 3; i++)
				{
					PlayerTextDrawShow(playerid, Loading[i][playerid]);
				}
				pData[playerid][pActivity] = SetTimerEx("ContainerDown", 400, true, "i", playerid);
				DisablePlayerCheckpoint(playerid);
				AddPlayerSalary(playerid, "Trucker(Container)", 35000);
				Info(playerid, "Trucker(Container) telah masuk ke pending salary anda!");
				return 1;
			}
		}
	}
	if(pData[playerid][pJob] == 9 || pData[playerid][pJob2] == 9)
	{
		new vehicleid = GetPlayerVehicleID(playerid);
		if(GetVehicleModel(vehicleid) == 482)
		{
			if (IsPlayerInRangeOfPoint(playerid, 4.0, 2787.4229,-2417.5588,13.6338))
			{
				SetPlayerCheckpoint(playerid, 2785.6194,-2455.9802,13.6342, 4.0);
				TogglePlayerControllable(playerid, 0);
				pData[playerid][pActivity] = SetTimerEx("KurirDone", 400, true, "i", playerid);
				PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Meletakkan Crate...");
				PlayerTextDrawShow(playerid, ActiveTD[playerid]);
				ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
				return 1;
			}
			if (IsPlayerInRangeOfPoint(playerid, 4.0, 2785.6194,-2455.9802,13.6342))
			{
				SetPlayerCheckpoint(playerid, 2787.2864,-2494.1882,13.6509, 4.0);
				TogglePlayerControllable(playerid, 0);
				pData[playerid][pActivity] = SetTimerEx("KurirDone", 400, true, "i", playerid);
				PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Memuat Crate...");
				PlayerTextDrawShow(playerid, ActiveTD[playerid]);
				ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
				return 1;
			}
			if (IsPlayerInRangeOfPoint(playerid, 4.0,2787.2864,-2494.1882,13.6509))
			{
				TogglePlayerControllable(playerid, 0);
				pData[playerid][pActivity] = SetTimerEx("KurirDone", 400, true, "i", playerid);
				PlayerTextDrawSetString(playerid, ActiveTD[playerid], "Memuat Crate...");
				PlayerTextDrawShow(playerid, ActiveTD[playerid]);
				ShowPlayerProgressBar(playerid, pData[playerid][activitybar]);
				pData[playerid][pSideJob] = 0;
				pData[playerid][pJobTime] = 800;
				DisablePlayerCheckpoint(playerid);
				AddPlayerSalary(playerid, "Couriers(Jobs)", 6500);
				Info(playerid, "Couriers(Jobs) telah masuk ke pending salary anda!");
				return 1;
			}
		}
	}
	//DisablePlayerCheckpoint(playerid);
	return 1;
}

public OnPlayerExitVehicle(playerid, vehicleid)
{
	KillTimer(pData[playerid][LimitSpeedTimer]);
	if(pData[playerid][pSekolahSim] == 1)
	{
		//new vehicleid = GetPlayerVehicleID(playerid);
		if(GetVehicleModel(vehicleid) == 426)
		{
		    DisablePlayerCheckpoint(playerid);
		    Info(playerid, "Anda gagal test mengemudi karena telah keluar dari kendaraan!");
		    RemovePlayerFromVehicle(playerid);
		    Global[SKM] = 0;
		    pData[playerid][pSekolahSim] = 0;
		    SetTimerEx("RespawnPV", 3000, false, "d", vehicleid);
		}
	}
    if (GetVehicleModel(vehicleid) == 574)
	{
	    {
	        SendClientMessageEx(playerid,COLOR_RIKO,"SIDEJOB:{FFFFFF}Kamu telah berhenti bekerja, kamu dapat bekerja Street Sweeper 10 menit lagi.");
			pData[playerid][pSideJob] = 0;
			RemovePlayerFromVehicle(playerid);
			SetTimerEx("RespawnPV", 3000, false, "d", vehicleid);
			pData[playerid][pSweeperTime] = 600;
			DisablePlayerCheckpoint(playerid);
	    }
	}
	else if (GetVehicleModel(vehicleid) == 431)
	{
	    {
	        SendClientMessageEx(playerid,COLOR_RIKO,"SIDEJOB:{FFFFFF}Kamu telah berhenti bekerja, kamu dapat bekerja sebagai Bus Driver 10 menit lagi.");
			pData[playerid][pSideJob] = 0;
			RemovePlayerFromVehicle(playerid);
			SetTimerEx("RespawnPV", 3000, false, "d", vehicleid);
			pData[playerid][pBusTime] = 600;
			DisablePlayerCheckpoint(playerid);
	    }
	}
	else if (GetVehicleModel(vehicleid) == 530)
	{
	    {
	        SendClientMessageEx(playerid,COLOR_RIKO,"SIDEJOB:{FFFFFF}Kamu telah berhenti bekerja, kamu dapat bekerja Forklift 10 menit lagi.");
			pData[playerid][pSideJob] = 0;
			RemovePlayerFromVehicle(playerid);
			DestroyDynamicObject(GetPVarInt(playerid, "box"));	
			SetTimerEx("RespawnPV", 3000, false, "d", vehicleid);
			pData[playerid][pForkliftTime] = 600;
			DisablePlayerCheckpoint(playerid);
	    }
	}
	else if (IsAMowerVeh(vehicleid))
	{
	    {
	        SendClientMessageEx(playerid,COLOR_JOB,"MOWER: "WHITE_E"Anda telah berhenti bekerja, tunggu beberapa menit lagi untuk bekerja kembali.");
			pData[playerid][pSideJob] = 0;
			RemovePlayerFromVehicle(playerid);
			SetTimerEx("RespawnPV", 3000, false, "d", vehicleid);
			pData[playerid][pSideJobTime] = 60;
			DisablePlayerCheckpoint(playerid);
	    }
	}
	return 1;
}

public OnDynamicObjectMoved(objectid)
{
    new playerid = Streamer_GetIntData(STREAMER_TYPE_OBJECT,objectid,E_STREAMER_EXTRA_ID);
    if(playerid != INVALID_PLAYER_ID)
    {
		new Float:x,Float:y,Float:z;
		GetDynamicObjectPos(objectid,x,y,z);
        if(GetPVarInt(playerid,"MeatCheck"))
        {
			if(x == 944.204345)
			{
				DestroyDynamicObject(objectid);
			    GoObject(playerid);
				DeletePVar(playerid,"MeatCheck");
				GameTextForPlayer(playerid,"~g~GOOD JOB",500,5);
				SetPVarInt(playerid,"BadMeatDel", GetPVarInt(playerid,"BadMeatDel") +1);
				StoreMeat[playerid]--;
				Info(playerid, "Remaining "RED_E"%d "WHITE_E"Meat (threw out "RED_E"%d "WHITE_E"spoiled pieces)", StoreMeat[playerid],GetPVarInt(playerid,"BadMeatDel"));
			}
        }
        else
        {
            if(y == 2123.890380)
            {
			    if(StoreMeat[playerid] == -1)
				{
			    	Info(playerid, "Finish.");
			    	if(IsValidDynamicObject(playerobject[playerid][0])) DestroyDynamicObject(playerobject[playerid][0]);
					else if(IsValidDynamicObject(playerobject[playerid][1])) DestroyDynamicObject(playerobject[playerid][1]);
					SetPlayerVirtualWorld(playerid,0);
				    TogglePlayerControllable(playerid, 1);
				    SetCameraBehindPlayer(playerid);
				    DeletePVar(playerid,"MeatCheck");
					DeletePVar(playerid,"InWork");
					DeletePVar(playerid,"MeatCheck");
					DeletePVar(playerid,"BadMeatDel");
					DeletePVar(playerid,"BadMeat");
					DeletePVar(playerid,"OldSkin");
					DeletePVar(playerid,"OnWork");
			    }
			    if(GetPVarInt(playerid,"BadMeat")) GameTextForPlayer(playerid,"~r~BAD JOB",500,5);
                else GameTextForPlayer(playerid,"~g~GOOD JOB",500,5);
                DestroyDynamicObject(objectid);
			    GoObject(playerid);
			    StoreMeat[playerid]--;
			    Info(playerid, "Remaining "RED_E"%d "WHITE_E"Meat (threw out "RED_E"%d "WHITE_E"spoiled pieces)",StoreMeat[playerid] ,GetPVarInt(playerid,"BadMeatDel"));
            }
        }
    }
	return 1;
}

public OnPlayerPickUpDynamicPickup(playerid, pickupid)
{
	if(EnterDoor(playerid))
	{
		InfoTD_MSG(playerid, 4000, "~w~ Type ~r~'/en' ~w~Or Press~r~ F");
		return 1;
	}

	if(pickupid == ship_enter_pickups[0] && ship_pos_id == 3) SetPlayerPos(playerid, 2550.4058,-2652.4631,5.7499);
	if(pickupid == ship_enter_pickups[1] && ship_pos_id == 6) SetPlayerPos(playerid, 2589.5679,-3797.1455,5.7499);
	
	new String[10000], issuer[24];
    GetPlayerName(playerid, issuer, 24);
	if(ship_work_pickups[0] <= pickupid <= ship_work_pickups[sizeof ship_work_pickups - 1])
	{
	    if(!player_ship_worked[playerid]) return SCM(playerid, COLOR_GREY, "Anda tidak bekerja di platform.");

	    if(player_ship_oil[playerid] == false) return SCM(playerid, COLOR_GREY, "Anda tidak memiliki minyak, pergi ke tingkat yang lebih rendah dan kumpulkan.");

	    new index = _:(pickupid - ship_work_pickups[0]);

        if(gettime() < ship_repair_cd[index]) return SCM(playerid, COLOR_GREY, "Perbaikan tidak diperlukan di sini.");

	    ship_repair_cd[index] = gettime() + 60;

	    TogglePlayerControllable(playerid, false);

	    ApplyAnimation(playerid,"INT_HOUSE","wash_up",4.0, 1, 0, 0, 0, 0,1);

        player_ship_oil[playerid] = false;

	    SetTimerEx("PlayerEndRepairShip", 10000, false, "i", playerid);
	}

	if(ship_oil_pickups[0] <= pickupid <= ship_oil_pickups[sizeof ship_oil_pickups - 1])
	{
	    if(!player_ship_worked[playerid]) return SCM(playerid, COLOR_GREY, "Anda tidak bekerja di platform.");

	    if(player_ship_oil[playerid]) return SCM(playerid, COLOR_GREY, "Anda sudah memiliki minyak, pergi gemukkan gigi.");

	    ApplyAnimation(playerid,"MISC","GRAB_R",4.0, 0, 0, 0, 0, 0,1);

        player_ship_oil[playerid] = true;

        SCM(playerid, COLOR_GREEN, "Anda mengambil minyak, pergi meminyak ke persneling.");

        format(String, sizeof String, "%s Mengambil minyak dengan bantuan kedua tangan", issuer);
  		ProxDetector(20.0, playerid, String, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
		SetPlayerChatBubble(playerid, "Mengambi minyak",COLOR_PURPLE,20.0,10000);
	}

	if(pickupid == ship_pickup)
	{
	    //if(IsPlayerGovermentWork(playerid)) return SendClientMessage(playerid, COLOR_GREY,"Anda adalah sebuah organisasi");
	    //if(rent_vehicle_id[playerid] != INVALID_VEHICLE_ID) return SCM(playerid, COLOR_GREY, "Untuk memulai, batalkan mobil sewaan: /rcancel");

	    if(!player_ship_worked[playerid])
	    {
	        SCM(playerid, COLOR_GREEN, "Anda memulai hari kerja.");

	        SetPVarInt(playerid, "old_skin", GetPlayerSkin(playerid));
		    SetPlayerSkin(playerid, 50);

		    //player_ship_oil[playerid] = true;

		    pTemp[playerid][pWorkSalary] = 0;

		    format(String, sizeof String, "%s Memasukan minyak kedalam persneling dengan bantuan kedua tangan",issuer);
  			ProxDetector(20.0, playerid, String, COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE,COLOR_PURPLE);
			SetPlayerChatBubble(playerid, "Memasukan minyak kedalam persneling",COLOR_PURPLE,20.0,10000);

			SetPlayerAttachedObject(playerid, 2, 19621, 6, 0.0829, 0.1529, 0.0479, 0.0000, 0.0000, 0.0000, 1.0000, 1.0000, 1.0000);
	    }
	    else
	    {
	        new salary = pTemp[playerid][pWorkSalary];
	        if(salary != 0)
	        {
	            SCMF(playerid, COLOR_GREEN, "Anda menghasilkan: $%i", salary);
      			//GivePlayerMoneyEx(playerid, salary, "gaji platform"); //TEST
	        }

	        SetPlayerSkin(playerid, GetPVarInt(playerid, "old_skin"));

	        SCM(playerid, COLOR_GREY, "Anda menyelesaikan hari kerja.");

	        RemovePlayerAttachedObject(playerid, 2);
	    }

	    player_ship_worked[playerid] = !player_ship_worked[playerid];
	}
	return 1;
}
function StopCameraEffect(playerid)
{
	SetPlayerDrunkLevel(playerid, 0);
	SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
	return 1;
}
public OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
	//-----[ Toll System ]-----
	if(newkeys & KEY_CROUCH)
	{
		if(GetPlayerState(playerid) != PLAYER_STATE_SPECTATING)
		{
			new forcount = MuchNumber(sizeof(BarrierInfo));
			for(new i;i < forcount;i ++)
			{
				if(i < sizeof(BarrierInfo))
				{
					if(IsPlayerInRangeOfPoint(playerid,8,BarrierInfo[i][brPos_X],BarrierInfo[i][brPos_Y],BarrierInfo[i][brPos_Z]))
					{
						if(BarrierInfo[i][brOrg] == TEAM_NONEE)
						{
							if(!BarrierInfo[i][brOpen])
							{
								if(pData[playerid][pMoney] < 150)
								{
									Info(playerid, "Uangmu tidak cukup untuk membayar toll");
								}
								else
								{
									MoveDynamicObject(gBarrier[i],BarrierInfo[i][brPos_X],BarrierInfo[i][brPos_Y],BarrierInfo[i][brPos_Z]+0.7,BARRIER_SPEED,0.0,0.0,BarrierInfo[i][brPos_A]+180);
									SetTimerEx("BarrierClose",15000,0,"i",i);
									BarrierInfo[i][brOpen] = true;
									Toll(playerid, "Anda berhasil membuka toll dan membayar {00ff00}$5");
									GivePlayerMoneyEx(playerid, -150);
									if(BarrierInfo[i][brForBarrierID] != -1)
									{
										new barrierid = BarrierInfo[i][brForBarrierID];
										MoveDynamicObject(gBarrier[barrierid],BarrierInfo[barrierid][brPos_X],BarrierInfo[barrierid][brPos_Y],BarrierInfo[barrierid][brPos_Z]+0.7,BARRIER_SPEED,0.0,0.0,BarrierInfo[barrierid][brPos_A]+180);
										BarrierInfo[barrierid][brOpen] = true;

									}
								}
							}
						}
						else Info(playerid, "Kamu tidak bisa membuka pintu Toll ini!");
						break;
					}
				}
			}
		}
		return true;
	}
	//Wine & Beer
	if(newkeys & KEY_FIRE && GetPlayerSpecialAction(playerid) == SPECIAL_ACTION_DRINK_BEER)
  	{
        SetPlayerDrunkLevel(playerid, 50000);
      	SetTimerEx("StopCameraEffect", 60000, 0, "i", playerid);
  	}
  	if(newkeys & KEY_FIRE && GetPlayerSpecialAction(playerid) == SPECIAL_ACTION_DRINK_WINE)
  	{
        SetPlayerDrunkLevel(playerid, 50000);
      	SetTimerEx("StopCameraEffect", 60000, 0, "i", playerid);
  	}		
    //Vote System
	if(VoteOn && VoteVoted[playerid] == 0)
	{
	    if(newkeys == KEY_YES)
	    {
	        VoteY++;
	        VoteVoted[playerid] = 1;
	        SendClientMessage(playerid, COLOR_RIKO, "[VOTE]{FFFFFF} Anda memilih {33AA33}IYA{FFFFFF}.");
		}
	    if(newkeys == KEY_NO)
	    {
		    VoteN++;
		    VoteVoted[playerid] = 1;
		    SendClientMessage(playerid, COLOR_RIKO, "[VOTE]{FFFFFF} Anda memilih {FF0000}TIDAK{FFFFFF}.");
	    }
	}
	if(PRESSED(KEY_FIRE) && GetPVarInt(playerid, "GraffitiCreating") == 0  && GetPlayerWeapon(playerid) == 41 )
	{
		if(!IsValidDynamicObject(POBJECT[playerid]))
    	{
		    spraytimerch[playerid] = SetTimerEx( "sprayingch", 1000, true, "i", playerid );
		    SetPVarInt(playerid, "GraffitiMenu", 1);
	    	return 1;
	    }
	    return ShowPlayerDialog(playerid, DIALOG_GDOBJECT, DIALOG_STYLE_MSGBOX, "Graffiti", "Anda sudah membuat graffiti\n\nJika anda ingin melanjutkan, text sebelumnya akan terhapus.", "Oke", "Cancel");
	}
	if(RELEASED( KEY_FIRE ) && GetPVarInt(playerid, "GraffitiMenu") == 1 && GetPlayerWeapon(playerid) == 41)
	{
	    KillTimer( spraytimerch[playerid] );
	    graffmenup[playerid] = 0;
	    DeletePVar(playerid, "GraffitiMenu");
	    return 1;
	}
	if( RELEASED( KEY_FIRE ) && GetPVarInt(playerid, "GraffitiCreating") == 1 )
	{
		if(GetPlayerWeapon(playerid) == 41 )
		{
		    KillTimer( spraytimer[playerid] );
	    	sprayammount[playerid] --;
    	 	spraytimerx[playerid] = SetTimerEx( "killgr", 90000, true, "i", playerid );
		}
	}
	/*
	if(newkeys == KEY_CROUCH)
   	{
      	if(IsPlayerInAnyVehicle(playerid))
      	{
      		callcmd::parkveh(playerid);
      		//callcmd::paytoll(playerid);
        	return 1;
      	}
   	}
   	*/
   	/*if(newkeys == KEY_LOOK_BEHIND)
   	{
      	{
        	ShowPlayerDialog(playerid, DIALOG_VC, DIALOG_STYLE_LIST, "Vehicle Control", "Engine\nLock\nLights", "Select", "Cancel");
      	}
   	}*/
	//butcher
	if(newkeys & KEY_CTRL_BACK && !GetPVarInt(playerid,"InWork") && GetPVarInt(playerid,"OnWork"))
	{
	    if(IsPlayerInRangeOfPoint(playerid,2.0,940.1020,2127.6326,1011.0303))
	    {
	        ShowPlayerDialog(playerid,D_WORK_INFO,DIALOG_STYLE_MSGBOX,"Information","Butcher - Sidejob\n\n"WHITE_E"You have to stored 10 meat and select the meat.\n\n"GREEN_E"Green "WHITE_E"meat is spoiled.\nAs it will be a "RED_E"red "WHITE_E"square press the {f7ae11}Y{ffffff}\nTo "YELLOW_E"end the operation, press {f7ae11}N","Ok","");
	    }
	}
	if(newkeys & KEY_NO && !GetPVarInt(playerid,"MeatCheck"))
	{
		if(IsValidDynamicObject(playerobject[playerid][0])) DestroyDynamicObject(playerobject[playerid][0]);
		else if(IsValidDynamicObject(playerobject[playerid][1])) DestroyDynamicObject(playerobject[playerid][1]);
		SetPlayerVirtualWorld(playerid,0);
	    TogglePlayerControllable(playerid, 1);
	    SetCameraBehindPlayer(playerid);
	    DeletePVar(playerid,"InWork");
	}
	if(newkeys & KEY_YES && !GetPVarInt(playerid,"MeatCheck") && GetPVarInt(playerid,"InWork") && GetPVarInt(playerid,"OnWork"))
	{
		if(StoreMeat[playerid] == 0)
		{
		    if(GetPVarInt(playerid,"BadMeat"))
		    {
				new Float:x,Float:y,Float:z;
				GetDynamicObjectPos(playerobject[playerid][0],x,y,z);
				if(floatround(y) == 2127)
				{
				    StopDynamicObject(playerobject[playerid][0]);
				    MoveDynamicObject(playerobject[playerid][0],944.204345, y, z,2);
				    SetPVarInt(playerid,"MeatCheck",1);
				    StoreMeat[playerid] -= 1;
				}
				else
				{
					DestroyDynamicObject(playerobject[playerid][0]);
				    GoObject(playerid);
					GameTextForPlayer(playerid,"~r~BAD JOB",500,5);
				}
			}
			else GameTextForPlayer(playerid,"~r~BAD JOB",500,5);
		}
		Info(playerid, "Finish.");
		if(IsValidDynamicObject(playerobject[playerid][0])) DestroyDynamicObject(playerobject[playerid][0]);
		else if(IsValidDynamicObject(playerobject[playerid][1])) DestroyDynamicObject(playerobject[playerid][1]);
		SetPlayerVirtualWorld(playerid,0);
	    TogglePlayerControllable(playerid, 1);
	    SetCameraBehindPlayer(playerid);
	    DeletePVar(playerid,"InWork");
	}
    if((newkeys & KEY_NO) && HasTrash[playerid])
	{
		Trash_ResetPlayer(playerid);
		SendClientMessage(playerid, COLOR_JOB, "TRASHMASTER: {FFFFFF}Trash bag removed.");
	}
    if(Player_Fire_Enabled[playerid])
	{
		if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
		{
			new vehicleid = GetPlayerVehicleID(playerid);
			if(vehicleid)
			{
				new vehicle_modelid = GetVehicleModel(vehicleid);
				if(FIRE_INFO[vehicle_modelid - 400][fire_VALID])
				{
					if(PRESSED(KEY_SPRINT))
					{
						Player_Key_Sprint_Time[playerid] = gettime();
					}
					else if(RELEASED(KEY_SPRINT))
					{
						if(gettime() - Player_Key_Sprint_Time[playerid] > 1)
						{
							PlayerPlaySound(playerid, 1131, 0.0, 0.0, 0.0);

							new effect_object = CreateObject(18695, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0), effect_object2 = -1;
							AttachDynamicObjectToVehicle
							(
								effect_object, vehicleid,
								FIRE_INFO[vehicle_modelid - 400][fire_OFFSET_X], FIRE_INFO[vehicle_modelid - 400][fire_OFFSET_Y], FIRE_INFO[vehicle_modelid - 400][fire_OFFSET_Z],
								FIRE_INFO[vehicle_modelid - 400][fire_ROT_X], FIRE_INFO[vehicle_modelid - 400][fire_ROT_Y], FIRE_INFO[vehicle_modelid - 400][fire_ROT_Z]
							);

							if(FIRE_INFO[vehicle_modelid - 400][fire_MIRROR])
							{
								effect_object2 = CreateObject(18695, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0);
								AttachDynamicObjectToVehicle
								(
									effect_object2, vehicleid,
									-FIRE_INFO[vehicle_modelid - 400][fire_OFFSET_X], FIRE_INFO[vehicle_modelid - 400][fire_OFFSET_Y], FIRE_INFO[vehicle_modelid - 400][fire_OFFSET_Z],
									FIRE_INFO[vehicle_modelid - 400][fire_ROT_X], -FIRE_INFO[vehicle_modelid - 400][fire_ROT_Y], -FIRE_INFO[vehicle_modelid - 400][fire_ROT_Z]
								);
							}

							SetTimerEx("DestroyEffectObject", 100, false, "ii", effect_object, effect_object2);
						}
					}
				}
			}
		}
	}
	if(GetPlayerState(playerid) == PLAYER_STATE_ONFOOT && (newkeys & KEY_NO))
	{
	    if(pData[playerid][CarryingLumber])
		{
			Player_DropLumber(playerid);
		}
		else if(pData[playerid][CarryingLog] == 0)
		{
			Player_DropLog(playerid, pData[playerid][CarryingLog]);
			Info(playerid, "You dropping metal ore.");
			DisablePlayerCheckpoint(playerid);
		}
		else if(pData[playerid][CarryingLog] == 1)
		{
			Player_DropLog(playerid, pData[playerid][CarryingLog]);
			Info(playerid, "You dropping coal ore.");
			DisablePlayerCheckpoint(playerid);
		}
	}
	if((newkeys & KEY_SECONDARY_ATTACK))
    {
		foreach(new did : Doors)
		{
			if(IsPlayerInRangeOfPoint(playerid, 2.8, dData[did][dExtposX], dData[did][dExtposY], dData[did][dExtposZ]))
			{
				if(dData[did][dIntposX] == 0.0 && dData[did][dIntposY] == 0.0 && dData[did][dIntposZ] == 0.0)
					return Error(playerid, "Interior entrance masih kosong, atau tidak memiliki interior.");

				if(dData[did][dLocked])
					return Error(playerid, "This entrance is locked at the moment.");

				if(dData[did][dFaction] > 0)
				{
					if(dData[did][dFaction] != pData[playerid][pFaction])
						return Error(playerid, "This door only for faction.");
				}
				if(dData[did][dFamily] > 0)
				{
					if(dData[did][dFamily] != pData[playerid][pFamily])
						return Error(playerid, "This door only for family.");
				}

				if(dData[did][dVip] > pData[playerid][pVip])
					return Error(playerid, "Your VIP level not enough to enter this door.");

				if(dData[did][dAdmin] > pData[playerid][pAdmin])
					return Error(playerid, "Your admin level not enough to enter this door.");

				if(strlen(dData[did][dPass]))
				{
					new params[256];
					if(sscanf(params, "s[256]", params)) return Usage(playerid, "/enter [password]");
					if(strcmp(params, dData[did][dPass])) return Error(playerid, "Invalid door password.");

					if(dData[did][dCustom])
					{
						SetPlayerPositionEx(playerid, dData[did][dIntposX], dData[did][dIntposY], dData[did][dIntposZ], dData[did][dIntposA]);
					}
					else
					{
						SetPlayerPositionEx(playerid, dData[did][dIntposX], dData[did][dIntposY], dData[did][dIntposZ], dData[did][dIntposA]);
					}
					pData[playerid][pInDoor] = did;
					SetPlayerInterior(playerid, dData[did][dIntint]);
					SetPlayerVirtualWorld(playerid, dData[did][dIntvw]);
					SetCameraBehindPlayer(playerid);
					SetPlayerWeather(playerid, 0);
				}
				else
				{
					if(dData[did][dCustom])
					{
						SetPlayerPositionEx(playerid, dData[did][dIntposX], dData[did][dIntposY], dData[did][dIntposZ], dData[did][dIntposA]);
					}
					else
					{
						SetPlayerPositionEx(playerid, dData[did][dIntposX], dData[did][dIntposY], dData[did][dIntposZ], dData[did][dIntposA]);
					}
					pData[playerid][pInDoor] = did;
					SetPlayerInterior(playerid, dData[did][dIntint]);
					SetPlayerVirtualWorld(playerid, dData[did][dIntvw]);
					SetCameraBehindPlayer(playerid);
					SetPlayerWeather(playerid, 0);
				}
			}
			if(IsPlayerInRangeOfPoint(playerid, 2.8, dData[did][dIntposX], dData[did][dIntposY], dData[did][dIntposZ]))
			{
				if(dData[did][dFaction] > 0)
				{
					if(dData[did][dFaction] != pData[playerid][pFaction])
						return Error(playerid, "This door only for faction.");
				}

				if(dData[did][dCustom])
				{
					SetPlayerPositionEx(playerid, dData[did][dExtposX], dData[did][dExtposY], dData[did][dExtposZ], dData[did][dExtposA]);
				}
				else
				{
					SetPlayerPositionEx(playerid, dData[did][dExtposX], dData[did][dExtposY], dData[did][dExtposZ], dData[did][dExtposA]);
				}
				pData[playerid][pInDoor] = -1;
				SetPlayerInterior(playerid, dData[did][dExtint]);
				SetPlayerVirtualWorld(playerid, dData[did][dExtvw]);
				SetCameraBehindPlayer(playerid);
				SetPlayerWeather(playerid, WorldWeather);
			}
        }
		//Bisnis
		foreach(new bid : Bisnis)
		{
			if(IsPlayerInRangeOfPoint(playerid, 2.8, bData[bid][bExtposX], bData[bid][bExtposY], bData[bid][bExtposZ]))
			{
				if(bData[bid][bIntposX] == 0.0 && bData[bid][bIntposY] == 0.0 && bData[bid][bIntposZ] == 0.0)
					return Error(playerid, "Interior bisnis masih kosong, atau tidak memiliki interior.");

				if(bData[bid][bLocked])
					return Error(playerid, "This bisnis is locked!");

				pData[playerid][pInBiz] = bid;
				SetPlayerPositionEx(playerid, bData[bid][bIntposX], bData[bid][bIntposY], bData[bid][bIntposZ], bData[bid][bIntposA]);

				PlayAudioStreamForPlayer(playerid, bData[bid][bSong], bData[bid][bIntposX], bData[bid][bIntposY], bData[bid][bIntposZ], 15.0, 1);
				SetPlayerInterior(playerid, bData[bid][bInt]);
				SetPlayerVirtualWorld(playerid, bid);
				SetCameraBehindPlayer(playerid);
				SetPlayerWeather(playerid, 0);
			}
        }
		new inbisnisid = pData[playerid][pInBiz];
		if(pData[playerid][pInBiz] != -1 && IsPlayerInRangeOfPoint(playerid, 2.8, bData[inbisnisid][bIntposX], bData[inbisnisid][bIntposY], bData[inbisnisid][bIntposZ]))
		{
			pData[playerid][pInBiz] = -1;
			SetPlayerPositionEx(playerid, bData[inbisnisid][bExtposX], bData[inbisnisid][bExtposY], bData[inbisnisid][bExtposZ], bData[inbisnisid][bExtposA]);

			StopAudioStreamForPlayer(playerid);
			SetPlayerInterior(playerid, 0);
			SetPlayerVirtualWorld(playerid, 0);
			SetCameraBehindPlayer(playerid);
			SetPlayerWeather(playerid, WorldWeather);
		}
		//Houses
		foreach(new hid : Houses)
		{
			if(IsPlayerInRangeOfPoint(playerid, 2.5, hData[hid][hExtposX], hData[hid][hExtposY], hData[hid][hExtposZ]))
			{
				if(hData[hid][hIntposX] == 0.0 && hData[hid][hIntposY] == 0.0 && hData[hid][hIntposZ] == 0.0)
					return Error(playerid, "Interior house masih kosong, atau tidak memiliki interior.");

				if(hData[hid][hLocked])
					return Error(playerid, "This house is locked!");

				pData[playerid][pInHouse] = hid;
				SetPlayerPositionEx(playerid, hData[hid][hIntposX], hData[hid][hIntposY], hData[hid][hIntposZ], hData[hid][hIntposA]);

				SetPlayerInterior(playerid, hData[hid][hInt]);
				SetPlayerVirtualWorld(playerid, hid);
				SetCameraBehindPlayer(playerid);
				SetPlayerWeather(playerid, 0);
			}
        }
		new inhouseid = pData[playerid][pInHouse];
		if(pData[playerid][pInHouse] != -1 && IsPlayerInRangeOfPoint(playerid, 2.8, hData[inhouseid][hIntposX], hData[inhouseid][hIntposY], hData[inhouseid][hIntposZ]))
		{
			pData[playerid][pInHouse] = -1;
			SetPlayerPositionEx(playerid, hData[inhouseid][hExtposX], hData[inhouseid][hExtposY], hData[inhouseid][hExtposZ], hData[inhouseid][hExtposA]);

			SetPlayerInterior(playerid, 0);
			SetPlayerVirtualWorld(playerid, 0);
			SetCameraBehindPlayer(playerid);
			SetPlayerWeather(playerid, WorldWeather);
		}
		//Flats
		foreach(new flid : Flats)
		{
			if(IsPlayerInRangeOfPoint(playerid, 2.5, flData[flid][flExtposX], flData[flid][flExtposY], flData[flid][flExtposZ]))
			{
				if(flData[flid][flIntposX] == 0.0 && flData[flid][flIntposY] == 0.0 && flData[flid][flIntposZ] == 0.0)
					return Error(playerid, "Interior flat masih kosong, atau tidak memiliki interior.");

				if(flData[flid][flLocked])
					return Error(playerid, "This flat is locked!");

				pData[playerid][pInFlat] = flid;
				SetPlayerPositionEx(playerid, flData[flid][flIntposX], flData[flid][flIntposY], flData[flid][flIntposZ], flData[flid][flIntposA]);

				SetPlayerInterior(playerid, flData[flid][flInt]);
				SetPlayerVirtualWorld(playerid, flid);
				SetCameraBehindPlayer(playerid);
				SetPlayerWeather(playerid, 0);
			}
        }
		new inflatid = pData[playerid][pInFlat];
		if(pData[playerid][pInFlat] != -1 && IsPlayerInRangeOfPoint(playerid, 2.8, flData[inflatid][flIntposX], flData[inflatid][flIntposY], flData[inflatid][flIntposZ]))
		{
			pData[playerid][pInFlat] = -1;
			SetPlayerPositionEx(playerid, flData[inflatid][flExtposX], flData[inflatid][flExtposY], flData[inflatid][flExtposZ], flData[inflatid][flExtposA]);

			SetPlayerInterior(playerid, 0);
			SetPlayerVirtualWorld(playerid, 0);
			SetCameraBehindPlayer(playerid);
			SetPlayerWeather(playerid, WorldWeather);
		}
		//Hotels
		foreach(new htid : Hotels)
		{
			if(IsPlayerInRangeOfPoint(playerid, 2.5, htData[htid][htExtposX], htData[htid][htExtposY], htData[htid][htExtposZ]))
			{
				if(htData[htid][htIntposX] == 0.0 && htData[htid][htIntposY] == 0.0 && htData[htid][htIntposZ] == 0.0)
					return Error(playerid, "Interior hotel masih kosong, atau tidak memiliki interior.");

				if(htData[htid][htLocked])
					return Error(playerid, "This hotel is locked!");

				pData[playerid][pInHotel] = htid;
				SetPlayerPositionEx(playerid, htData[htid][htIntposX], htData[htid][htIntposY], htData[htid][htIntposZ], htData[htid][htIntposA]);

				SetPlayerInterior(playerid, htData[htid][htInt]);
				SetPlayerVirtualWorld(playerid, htid);
				SetCameraBehindPlayer(playerid);
				SetPlayerWeather(playerid, 0);
			}
        }
		new inhotelid = pData[playerid][pInHotel];
		if(pData[playerid][pInHotel] != -1 && IsPlayerInRangeOfPoint(playerid, 2.8, htData[inhotelid][htIntposX], htData[inhotelid][htIntposY], htData[inhotelid][htIntposZ]))
		{
			pData[playerid][pInHotel] = -1;
			SetPlayerPositionEx(playerid, htData[inhotelid][htExtposX], htData[inhotelid][htExtposY], htData[inhotelid][htExtposZ], htData[inhotelid][htExtposA]);

			SetPlayerInterior(playerid, 0);
			SetPlayerVirtualWorld(playerid, 0);
			SetCameraBehindPlayer(playerid);
			SetPlayerWeather(playerid, WorldWeather);
		}
		//Family
		foreach(new fid : FAMILYS)
		{
			if(IsPlayerInRangeOfPoint(playerid, 2.8, fData[fid][fExtposX], fData[fid][fExtposY], fData[fid][fExtposZ]))
			{
				if(fData[fid][fIntposX] == 0.0 && fData[fid][fIntposY] == 0.0 && fData[fid][fIntposZ] == 0.0)
					return Error(playerid, "Interior masih kosong, atau tidak memiliki interior.");

				if(pData[playerid][pFaction] == 0)
					if(pData[playerid][pFamily] == -1)
						return Error(playerid, "You dont have registered for this door!");

				SetPlayerPositionEx(playerid, fData[fid][fIntposX], fData[fid][fIntposY], fData[fid][fIntposZ], fData[fid][fIntposA]);

				SetPlayerInterior(playerid, fData[fid][fInt]);
				SetPlayerVirtualWorld(playerid, fid);
				SetCameraBehindPlayer(playerid);
				//pData[playerid][pInBiz] = fid;
				SetPlayerWeather(playerid, 0);
			}
			if(IsPlayerInRangeOfPoint(playerid, 2.8, fData[fid][fIntposX], fData[fid][fIntposY], fData[fid][fIntposZ]))
			{
				SetPlayerPositionEx(playerid, fData[fid][fExtposX], fData[fid][fExtposY], fData[fid][fExtposZ], fData[fid][fExtposA]);

				SetPlayerInterior(playerid, 0);
				SetPlayerVirtualWorld(playerid, 0);
				SetCameraBehindPlayer(playerid);
				SetPlayerWeather(playerid, WorldWeather);
				//pData[playerid][pInBiz] = -1;
			}
        }
	}
	//SAPD Taser/Tazer
	if(newkeys & KEY_FIRE && TaserData[playerid][TaserEnabled] && GetPlayerWeapon(playerid) == 0 && !IsPlayerInAnyVehicle(playerid) && TaserData[playerid][TaserCharged])
	{
  		TaserData[playerid][TaserCharged] = false;

	    new Float: x, Float: y, Float: z, Float: health;
     	GetPlayerPos(playerid, x, y, z);
	    PlayerPlaySound(playerid, 6003, 0.0, 0.0, 0.0);
	    ApplyAnimation(playerid, "KNIFE", "KNIFE_3", 4.1, 0, 1, 1, 0, 0, 1);
		pData[playerid][pActivityTime] = 0;
	    TaserData[playerid][ChargeTimer] = SetTimerEx("ChargeUp", 1000, true, "i", playerid);
	    PlayerTextDrawSetString(playerid, Loading[2][playerid], "Recharge...");
		for(new i =0 ; i < 3; i++)
		{
			PlayerTextDrawShow(playerid, Loading[i][playerid]);
		}

	    for(new i, maxp = GetPlayerPoolSize(); i <= maxp; ++i)
		{
	        if(!IsPlayerConnected(i)) continue;
          	if(playerid == i) continue;
          	if(TaserData[i][TaserCountdown] != 0) continue;
          	if(IsPlayerInAnyVehicle(i)) continue;
			if(GetPlayerDistanceFromPoint(i, x, y, z) > 2.0) continue;
			ClearAnimations(i, 1);
			TogglePlayerControllable(i, false);
   			ApplyAnimation(i, "CRACK", "crckdeth2", 4.1, 0, 0, 0, 1, 0, 1);
			PlayerPlaySound(i, 6003, 0.0, 0.0, 0.0);

			GetPlayerHealth(i, health);
			TaserData[i][TaserCountdown] = TASER_BASETIME + floatround((100 - health) / 12);
   			Info(i, "You got tased for %d secounds!", TaserData[i][TaserCountdown]);
			TaserData[i][GetupTimer] = SetTimerEx("TaserGetUp", 1000, true, "i", i);
			break;
	    }
	}
	if((newkeys & KEY_CTRL_BACK ))
	{
		if(IsPlayerInAnyVehicle(playerid) && GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
		{
			return callcmd::berry(playerid, "pickup");
		}
	}
	//Vehicle
	if((newkeys & KEY_YES ))
	{
		if(IsPlayerInAnyVehicle(playerid) && GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
		{
			return callcmd::v(playerid, "engine");
		}
		if(GetPlayerState(playerid) == PLAYER_STATE_ONFOOT && pData[playerid][pCuffed] == 0 && pData[playerid][pFitnessType] == 0)
		{
			new id = Trash_Closest(playerid);
			if(id == -1) return 0;

			return callcmd::trash(playerid);
		}
	}
	if((newkeys & KEY_NO ))
	{
		if(IsPlayerInAnyVehicle(playerid) && GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
		{
			return callcmd::v(playerid, "lights");
		}
	}
	if(GetPVarInt(playerid, "UsingSprunk"))
	{
		if(pData[playerid][pEnergy] >= 100 )
		{
  			Info(playerid, " Kamu terlalu banyak minum.");
	   	}
	   	else
	   	{
		    pData[playerid][pEnergy] += 5;
		}
	}
	if(PRESSED( KEY_FIRE ))
	{
		if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER && IsPlayerInAnyVehicle(playerid))
		{
			foreach(new did : Doors)
			{
				if(IsPlayerInRangeOfPoint(playerid, 2.8, dData[did][dExtposX], dData[did][dExtposY], dData[did][dExtposZ]))
				{
					if(dData[did][dGarage] == 1)
					{
						if(dData[did][dIntposX] == 0.0 && dData[did][dIntposY] == 0.0 && dData[did][dIntposZ] == 0.0)
							return Error(playerid, "Interior entrance masih kosong, atau tidak memiliki interior.");

						if(dData[did][dLocked])
							return Error(playerid, "This entrance is locked at the moment.");

						if(dData[did][dFaction] > 0)
						{
							if(dData[did][dFaction] != pData[playerid][pFaction])
								return Error(playerid, "This door only for faction.");
						}
						if(dData[did][dFamily] > 0)
						{
							if(dData[did][dFamily] != pData[playerid][pFamily])
								return Error(playerid, "This door only for family.");
						}

						if(dData[did][dVip] > pData[playerid][pVip])
							return Error(playerid, "Your VIP level not enough to enter this door.");

						if(dData[did][dAdmin] > pData[playerid][pAdmin])
							return Error(playerid, "Your admin level not enough to enter this door.");

						if(strlen(dData[did][dPass]))
						{
							new params[256];
							if(sscanf(params, "s[256]", params)) return Usage(playerid, "/enter [password]");
							if(strcmp(params, dData[did][dPass])) return Error(playerid, "Invalid door password.");

							if(dData[did][dCustom])
							{
								SetVehiclePositionEx(playerid, GetPlayerVehicleID(playerid), dData[did][dIntposX], dData[did][dIntposY], dData[did][dIntposZ], dData[did][dIntposA]);
							}
							else
							{
								SetVehiclePosition(playerid, GetPlayerVehicleID(playerid), dData[did][dIntposX], dData[did][dIntposY], dData[did][dIntposZ], dData[did][dIntposA]);
							}
							pData[playerid][pInDoor] = did;
							SetPlayerInterior(playerid, dData[did][dIntint]);
							SetPlayerVirtualWorld(playerid, dData[did][dIntvw]);
							SetCameraBehindPlayer(playerid);
							SetPlayerWeather(playerid, 0);
						}
						else
						{
							if(dData[did][dCustom])
							{
								SetVehiclePositionEx(playerid, GetPlayerVehicleID(playerid), dData[did][dIntposX], dData[did][dIntposY], dData[did][dIntposZ], dData[did][dIntposA]);
							}
							else
							{
								SetVehiclePosition(playerid, GetPlayerVehicleID(playerid), dData[did][dIntposX], dData[did][dIntposY], dData[did][dIntposZ], dData[did][dIntposA]);
							}
							pData[playerid][pInDoor] = did;
							SetPlayerInterior(playerid, dData[did][dIntint]);
							SetPlayerVirtualWorld(playerid, dData[did][dIntvw]);
							SetCameraBehindPlayer(playerid);
							SetPlayerWeather(playerid, 0);
						}
					}
				}
				new xid = pData[playerid][pInDoor];
				if(IsPlayerInRangeOfPoint(playerid, 2.8, dData[xid][dIntposX], dData[xid][dIntposY], dData[xid][dIntposZ]))
				{
					if(dData[xid][dGarage] == 1)
					{
						if(dData[xid][dFaction] > 0)
						{
							if(dData[xid][dFaction] != pData[playerid][pFaction])
								return Error(playerid, "This door only for faction.");
						}

						if(dData[xid][dCustom])
						{
							SetVehiclePositionEx(playerid, GetPlayerVehicleID(playerid), dData[xid][dExtposX], dData[xid][dExtposY], dData[xid][dExtposZ], dData[xid][dExtposA]);
						}
						else
						{
							SetVehiclePosition(playerid, GetPlayerVehicleID(playerid), dData[xid][dExtposX], dData[xid][dExtposY], dData[xid][dExtposZ], dData[xid][dExtposA]);
						}
						pData[playerid][pInDoor] = -1;
						SetPlayerInterior(playerid, dData[xid][dExtint]);
						SetPlayerVirtualWorld(playerid, dData[xid][dExtvw]);
						SetCameraBehindPlayer(playerid);
						SetPlayerWeather(playerid, WorldWeather);
					}
				}
			}
		}
	}
	//if(IsKeyJustDown(KEY_CTRL_BACK,newkeys,oldkeys))
	/*if(PRESSED( KEY_CTRL_BACK ))
	{
		if(GetPlayerState(playerid) == PLAYER_STATE_ONFOOT && pData[playerid][pCuffed] == 0 && pData[playerid][pFitnessType] == 0)
		{
			ClearAnimations(playerid);
			StopLoopingAnim(playerid);
			SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
			TextDrawHideForPlayer(playerid, txtAnimHelper);
		}
    }*/
    // STREAMER MASK SYSTEM
	if(PRESSED( KEY_WALK ))
	{
		if(pData[playerid][pMaskOn] == 1)
		{
			for(new ii = GetPlayerPoolSize(); ii != -1; --ii)
			{
				ShowPlayerNameTagForPlayer(ii, playerid, false);
			}
		}
		else if(pData[playerid][pMaskOn] == 0)
		{
			for(new ii = GetPlayerPoolSize(); ii != -1; --ii)
			{
				ShowPlayerNameTagForPlayer(ii, playerid, true);
			}
		}
		if(IsPlayerInAnyVehicle(playerid))
		{
			new vehicleid = GetPlayerVehicleID(playerid);
			if(GetEngineStatus(vehicleid))
			{
				if(GetVehicleSpeed(vehicleid) <= 40)
				{
					new playerState = GetPlayerState(playerid);
					if(playerState == PLAYER_STATE_DRIVER)
					{
						SendClientMessageToAllEx(COLOR_PINK, "Anti-Bug User: "GREY2_E"%s have been auto kicked for vehicle engine hack!", pData[playerid][pName]);
						KickEx(playerid);
					}
				}
			}
		}
	}
	if(IsKeyJustDown(KEY_SECONDARY_ATTACK, newkeys, oldkeys))
	{
		if(GetPVarInt(playerid, "UsingSprunk"))
		{
			DeletePVar(playerid, "UsingSprunk");
			SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
		}
	}
	return 1;
}

public OnPlayerStateChange(playerid, newstate, oldstate)
{
	//trasher
	if(newstate == PLAYER_STATE_DRIVER)
	{
	    new vehicleid = GetPlayerVehicleID(playerid);
	    if(GetVehicleModel(vehicleid) == 408)
	    {
		    if(LoadedTrash[vehicleid] > 0)
		    {
		        new string[128];
		        format(string, sizeof(string), "TRASHMASTER: {FFFFFF}This vehicle has {F39C12}%d {FFFFFF}trash bags which is worth {2ECC71}$%d.", LoadedTrash[vehicleid], LoadedTrash[vehicleid] * TRASH_BAG_VALUE);
				SendClientMessage(playerid, COLOR_JOB, string);
				SendClientMessage(playerid, COLOR_JOB, "TRASHMASTER: {FFFFFF}You can sell your trash bags to recycling factories marked by a truck icon.");

				for(new i; i < sizeof(FactoryData); i++)
				{
				    FactoryIcons[playerid][i] = CreateDynamicMapIcon(FactoryData[i][FactoryX], FactoryData[i][FactoryY], FactoryData[i][FactoryZ], 51, 0, _, _, playerid, 8000.0, MAPICON_GLOBAL);
					TogglePlayerDynamicCP(playerid, FactoryData[i][FactoryCP], 1);
				}
		    }
		    else
		    {
		        SendClientMessage(playerid, COLOR_JOB, "TRASHMASTER: {FFFFFF}You can collect trash and sell them at recycling factories.");
		        SendClientMessage(playerid, COLOR_JOB, "TRASHMASTER: {FFFFFF}Find trash cans or dumpsters and use '/pickup'.");
		    }

			Trash_ShowCapacity(playerid);
		}
		SetPVarInt(playerid, "LastVehicleID", vehicleid);
	}

	if(oldstate == PLAYER_STATE_DRIVER)
	{
		for(new i; i < sizeof(FactoryData); i++)
		{
		    if(IsValidDynamicMapIcon(FactoryIcons[playerid][i]))
		    {
		        DestroyDynamicMapIcon(FactoryIcons[playerid][i]);
		        FactoryIcons[playerid][i] = -1;
		    }

			TogglePlayerDynamicCP(playerid, FactoryData[i][FactoryCP], 0);
		}

		PlayerTextDrawHide(playerid, CapacityText[playerid]);
		HidePlayerProgressBar(playerid, CapacityBar[playerid]);
	}
	Trash_ResetPlayer(playerid);
	//electrican
	if(newstate == PLAYER_STATE_DRIVER)
	{
	    new vehicleid = GetPlayerVehicleID(playerid);
	    if(GetVehicleModel(vehicleid) == 552)
	    {
		   	SendClientMessage(playerid, 0x2ECC71FF, "ELECTRICAN: {FFFFFF}.");
		}
		SetPVarInt(playerid, "LastVehicleID", vehicleid);
	}
	if(newstate == PLAYER_STATE_WASTED && pData[playerid][pJail] < 1)
    {
		if(pData[playerid][pInjured] == 0)
        {
            pData[playerid][pInjured] = 1;
            SetPlayerHealthEx(playerid, 99999);

            pData[playerid][pInt] = GetPlayerInterior(playerid);
            pData[playerid][pWorld] = GetPlayerVirtualWorld(playerid);

            GetPlayerPos(playerid, pData[playerid][pPosX], pData[playerid][pPosY], pData[playerid][pPosZ]);
            GetPlayerFacingAngle(playerid, pData[playerid][pPosA]);
        }
        else
        {
            pData[playerid][pHospital] = 1;
        }
	}
	//Spec Player
	new vehicleid = GetPlayerVehicleID(playerid);
	if(newstate == PLAYER_STATE_ONFOOT)
	{
		if(pData[playerid][playerSpectated] != 0)
		{
			foreach(new ii : Player)
			{
				if(pData[ii][pSpec] == playerid)
				{
					PlayerSpectatePlayer(ii, playerid);
					Servers(ii, ,"%s(%i) is now on foot.", pData[playerid][pName], playerid);
				}
			}
		}
	}
	if(newstate == PLAYER_STATE_DRIVER)
	{
		if(!GetEngineStatus(vehicleid))
	    {
	    	SendClientMessage(playerid, COLOR_GREYJG, "ENGINEINFO: Mesin masih mati. tekan tombol "RED_E"Y"GREY_JG" untuk menghidupkannya.");
	    }
	}
	if(newstate == PLAYER_STATE_DRIVER || newstate == PLAYER_STATE_PASSENGER)
    {
		if(pData[playerid][pInjured] == 1)
        {
            //RemoveFromVehicle(playerid);
			RemovePlayerFromVehicle(playerid);
            SetPlayerHealthEx(playerid, 99999);
        }
		foreach (new ii : Player) if(pData[ii][pSpec] == playerid)
		{
            PlayerSpectateVehicle(ii, GetPlayerVehicleID(playerid));
        }
        if(pvData[vehicleid][cRadio] == 0)
	    {
			if(IsPlayerInAnyVehicle(playerid) && GetPlayerVehicleID(playerid) == GetPlayerVehicleID(playerid))
			{
				StopAudioStreamForPlayer(playerid);
			}
	    }
        if(pvData[vehicleid][cRadio] == 1)
	    {
			if(IsPlayerInAnyVehicle(playerid) && GetPlayerVehicleID(playerid) == GetPlayerVehicleID(playerid))
			{
				PlayAudioStreamForPlayer(playerid, "https://s7.alhastream.com/radio/8350/radio?16018459773", pvData[vehicleid][cPosX], pvData[vehicleid][cPosY], pvData[vehicleid][cPosZ], 5.0, false);
			}
	    }
	    if(pvData[vehicleid][cRadio] == 2)
	    {
			if(IsPlayerInAnyVehicle(playerid) && GetPlayerVehicleID(playerid) == GetPlayerVehicleID(playerid))
			{
				PlayAudioStreamForPlayer(playerid, pvData[vehicleid][cSong], pvData[vehicleid][cPosX], pvData[vehicleid][cPosY], pvData[vehicleid][cPosZ], 5.0, false);
			}
	    }
	    if(pvData[vehicleid][cRadio] == 3)
	    {
			if(IsPlayerInAnyVehicle(playerid) && GetPlayerVehicleID(playerid) == GetPlayerVehicleID(playerid))
			{
				PlayAudioStreamForPlayer(playerid, "https://powerhitz.com/1power.pls", pvData[vehicleid][cPosX], pvData[vehicleid][cPosY], pvData[vehicleid][cPosZ], 5.0, false);
			}	
	    }
	}
	if(oldstate == PLAYER_STATE_PASSENGER)
	{
		StopAudioStreamForPlayer(playerid);
		TextDrawHideForPlayer(playerid, TextFare);
		TextDrawHideForPlayer(playerid, DPvehfare[playerid]);
	}
	if(oldstate == PLAYER_STATE_DRIVER)
    {
		if(GetPlayerSpecialAction(playerid) == SPECIAL_ACTION_CARRY || GetPlayerSpecialAction(playerid) == SPECIAL_ACTION_CUFFED)
            return RemovePlayerFromVehicle(playerid);/*RemoveFromVehicle(playerid);*/
		
		for(new i; i < 10; i++)
		{
			TextDrawHideForPlayer(playerid, SPEEDOTDMODERN[i]);
		}
		TextDrawHideForPlayer(playerid, HEALTHBARMODERN);
		TextDrawHideForPlayer(playerid, SPEEDTDMODERN);
		TextDrawHideForPlayer(playerid, VEHNAMETDMODERN);
		TextDrawHideForPlayer(playerid, FUELBARMODERN);

		HidePlayerVehicleModern(playerid);
		//HBE textdraw Simple
        HidePlayerVelocimetro(playerid);

		if(pData[playerid][pTaxiDuty] == 1)
		{
			pData[playerid][pTaxiDuty] = 0;
			SetPlayerColor(playerid, COLOR_WHITE);
			Servers(playerid, "You are no longer on taxi duty!");
		}
		if(pData[playerid][pFare] == 1)
		{
			KillTimer(pData[playerid][pFareTimer]);
			Info(playerid, "Anda telah menonaktifkan taxi fare pada total: {00FF00}%s", FormatMoney(pData[playerid][pTotalFare]));
			pData[playerid][pFare] = 0;
			pData[playerid][pTotalFare] = 0;
		}

        HidePlayerProgressBar(playerid, pData[playerid][fuelbar]);
        HidePlayerProgressBar(playerid, pData[playerid][damagebar]);

        StopAudioStreamForPlayer(playerid);
	}
	else if(newstate == PLAYER_STATE_DRIVER)
    {
    	if(GetCarDealershipVehicleId(vehicleid) != -1)
        {
            new String[1280];
            format(String, sizeof(String),"Do you want to buy a vehicle{ffff00} %s?\nWith price {00ff00}%s.", GetVehicleName(vehicleid), FormatMoney(CarDealershipInfo[GetCarDealershipId(vehicleid)][cdVehicleCost][GetCarDealershipVehicleId(vehicleid)]));
            ShowPlayerDialog(playerid, DIALOG_CDBUY, DIALOG_STYLE_MSGBOX,"Vehicles Buy",String,"Buy","Cancel");
            TogglePlayerControllable(playerid, false);
            SetPVarInt(playerid, "buycar_dialog", 1);
            return 1;
        }
		foreach(new pv : PVehicles)
		{
			if(vehicleid == pvData[pv][cVeh])
			{
				if(IsABike(vehicleid) || GetVehicleModel(vehicleid) == 424)
				{
					if(pvData[pv][cLocked] == 1)
					{
						RemovePlayerFromVehicle(playerid);
						//new Float:slx, Float:sly, Float:slz;
						//GetPlayerPos(playerid, slx, sly, slz);
						//SetPlayerPos(playerid, slx, sly, slz);
						Error(playerid, "This bike is locked by owner.");
						return 1;
					}
				}
			}
		}
        foreach(new pv : PVehicles)
        {
            if(vehicleid == pvData[pv][cVeh])
            {
                if(pvData[pv][cLockTire] == 1)
                {
                    RemovePlayerFromVehicle(playerid);
                    Error(playerid, "The tire of this vehicle is locked by SAPD. Call SAPD for unlocked it.");
                    return 1;
                }
            }
        }
		if(newstate == PLAYER_STATE_DRIVER)
	    {
	        if(VehicleLastEnterTime[playerid] > gettime())
	        {
	            Warning[playerid]++;
	            if(Warning[playerid] >= 3)
	                AutoBan(playerid);
	        }
	        VehicleLastEnterTime[playerid] = gettime() + 2;
	    }/*radio
	    if(newstate == PLAYER_STATE_DRIVER)
	    {
	    	if(pvData[vehicleid][cRadio] == 1)
	    	{
	    		foreach(new i : Player)
				{
			    	if(IsPlayerInAnyVehicle(i) && GetPlayerVehicleID(i) == GetPlayerVehicleID(playerid))
					{
						//pvData[vehicleid][cRadio] = 1;
						PlayAudioStreamForPlayer(i, ServerSong, pvData[vehicleid][cPosX], pvData[vehicleid][cPosY], pvData[vehicleid][cPosZ], 5.0, false);
					}
				}
	    	}
	    }*/
	    if(IsADmvVeh(vehicleid))
        {
            if(pData[playerid][pSekolahSim] == 0)
            {
                RemovePlayerFromVehicle(playerid);
                Error(playerid, "Anda Tidak Memulai {FFFF00}DMV {FFFFFF}Test");
			}
		}
		if(IsATrashVeh(vehicleid))
		{
			ShowPlayerDialog(playerid, DIALOG_TRASH, DIALOG_STYLE_MSGBOX, "Side Job - Trashmaster", "Anda akan bekerja sebagai pengangkut sampah?", "Start Job", "Close");
		}
		if(IsAForVeh(vehicleid))
		{
			ShowPlayerDialog(playerid, DIALOG_FORKLIFT, DIALOG_STYLE_MSGBOX, "Side Job - Forklift", "Anda akan bekerja sebagai pemuat barang dengan Forklift?", "Start Job", "Close");
		}
		if(IsASweeperVeh(vehicleid))
		{
			ShowPlayerDialog(playerid, DIALOG_SWEEPER, DIALOG_STYLE_MSGBOX, "Side Job - Sweeper", "Anda akan bekerja sebagai pembersih jalan?", "Start Job", "Close");
		}
		if(IsAPizzaVeh(vehicleid))
		{
			ShowPlayerDialog(playerid, DIALOG_PIZZA, DIALOG_STYLE_MSGBOX, "Side Job - Pizza", "Anda akan bekerja sebagai pengantar Pizza?", "Start Job", "Close");
		}
		if(IsAMowerVeh(vehicleid))
        {
        	ShowPlayerDialog(playerid, DIALOG_MOWER, DIALOG_STYLE_MSGBOX, "Side Job - Mowerjack", "Anda akan bekerja sebagai pemotong rumput?", "Start Job", "Close");
		}
		if(IsABusVeh(vehicleid))
		{
			ShowPlayerDialog(playerid, DIALOG_BUS, DIALOG_STYLE_LIST, "Side Job - Bus", "1.Route A\tLos Santos Bank\n2.Route B\tOcean Docks\n3.Route C\tEast Side\n", "Start Job", "Close");
		}
		if(!IsEngineVehicle(vehicleid))
        {
            SwitchVehicleEngine(vehicleid, true);
        }
		if(IsEngineVehicle(vehicleid) && pData[playerid][pDriveLic] <= 0)
        {
            SendClientMessage(playerid, COLOR_PINK, "WARNING: "WHITE_E"Anda tidak memiliki Driving Licenses, berhati-hatilah.");
        }
		if(pData[playerid][pHBEMode] == 1)
		{
			ShowPlayerVelocimetro(playerid);
		}
		else if(pData[playerid][pHBEMode] == 2)
		{
			RefreshHbec(playerid);
			for(new txd; txd < 6; txd++)
			{
				TextDrawShowForPlayer(playerid, HudVeh[txd]);
			}
			TextDrawShowForPlayer(playerid, VehBox);
			PlayerTextDrawShow(playerid, DPvehname[playerid]);
			PlayerTextDrawShow(playerid, DPvehengine[playerid]);
			PlayerTextDrawShow(playerid, DPvehspeed[playerid]);
			ShowPlayerProgressBar(playerid, pData[playerid][fuelbar]);
			ShowPlayerProgressBar(playerid, pData[playerid][damagebar]);
		}
		else if(pData[playerid][pHBEMode] == 3)
		{				
			ShowHUD(playerid);
		}
		else
		{

		}
		new Float:health;
        GetVehicleHealth(GetPlayerVehicleID(playerid), health);
        VehicleHealthSecurityData[GetPlayerVehicleID(playerid)] = health;
        VehicleHealthSecurity[GetPlayerVehicleID(playerid)] = true;

		if(pData[playerid][playerSpectated] != 0)
  		{
			foreach(new ii : Player)
			{
    			if(pData[ii][pSpec] == playerid)
			    {
        			PlayerSpectateVehicle(ii, vehicleid);
				    Servers(ii, "%s(%i) is now driving a %s(%d).", pData[playerid][pName], playerid, GetVehicleModelName(GetVehicleModel(vehicleid)), vehicleid);
				}
			}
		}
		SetPVarInt(playerid, "LastVehicleID", vehicleid);
	}
	return 1;
}
public OnPlayerShootHead(playerid, targetid, Float:amount, weaponid)
{

    // - notification 
    new name[MAX_PLAYER_NAME+1];
    GetPlayerName(targetid, name, sizeof(name));
    Info(targetid, "Someone just shoot your head!");
    Info(playerid, "You shoot %s's head", name);

    // - ini untuk set target yang terkena headshot instanly death 
    if(pData[targetid][pArmour] <= 0)
    {
    	SetPlayerHealthEx(targetid, -30);
    }
    return 1;
}
static ids[MAX_PLAYERS];//BUST AIM
////////////////////////////////////////////////////////////////////////////////
public OnPlayerSuspectedForAimbot(playerid,hitid,weaponid,warnings)
{
	new str[144],nme[MAX_PLAYER_NAME],wname[32],Float:Wstats[BUSTAIM_WSTATS_SHOTS];
	
	ids[playerid]++;
	GetPlayerName(playerid,nme,sizeof(nme));
	GetWeaponName(weaponid,wname,sizeof(wname));
	if(warnings & WARNING_OUT_OF_RANGE_SHOT)
	{
	    format(str,256,"[%d]%s(%d) fired shots from a distance greater than the %s's fire range(Normal Range:%d)",ids[playerid],nme,playerid,wname,BustAim::GetNormalWeaponRange(weaponid));
		foreach (new f : Player)
        {
            if(pData[f][pAdmin] >= 1) 
            {
				SendClientMessageEx(f, COLOR_GREYJG, "[AdminWarn] "WHITE_E"%s", str);
            }
        }
		BustAim::GetRangeStats(playerid,Wstats);
		format(str,256,"Shooter to Victim Distance(SA Units): 1)%f 2)%f 3)%f",Wstats[0],Wstats[1],Wstats[2]);
		foreach (new z : Player)
        {
            if(pData[z][pAdmin] >= 1) 
            {
				SendClientMessageEx(z, COLOR_GREYJG, "[AdminWarn] "WHITE_E"%s", str);
            }
        }
		SendClientMessageToAllEx(COLOR_BAN, "BotCmd: %s Has Been Kicked By MasAdes.", pData[playerid][pName]);
		SendClientMessageToAllEx(COLOR_BAN, "Reason: Shooter to Victim Distance(SA Units): 1)%f 2)%f 3)%f",Wstats[0],Wstats[1],Wstats[2]);
		KickEx(playerid);
	}
	if(warnings & WARNING_PROAIM_TELEPORT)
	{
	    format(str,256,"[%d]%s(%d) is using proaim (Teleport Detected)",ids[playerid],nme,playerid);
		foreach (new x : Player)
        {
            if(pData[x][pAdmin] >= 1) 
            {
				SendClientMessageEx(x, COLOR_GREYJG, "[AdminWarn] "WHITE_E"%s", str);
            }
        }
		BustAim::GetTeleportStats(playerid,Wstats);
		format(str,256,"Bullet to Victim Distance(SA Units): 1)%f 2)%f 3)%f",Wstats[0],Wstats[1],Wstats[2]);
		foreach (new v : Player)
        {
            if(pData[v][pAdmin] >= 1) 
            {
				SendClientMessageEx(v, COLOR_GREYJG, "[AdminWarn] "WHITE_E"%s", str);
            }
        }
		SendClientMessageToAllEx(COLOR_BAN, "BotCmd: %s Has Been Kicked By MasAdes.", pData[playerid][pName]);
		SendClientMessageToAllEx(COLOR_BAN, "Reason: using proaim (Teleport Detected)");
		KickEx(playerid);
	}
	if(warnings & WARNING_RANDOM_AIM)
	{
	    format(str,256,"[%d]%s(%d) is suspected to be using aimbot(Hit with Random Aim with %s)",ids[playerid],nme,playerid,wname);
		foreach (new a : Player)
        {
            if(pData[a][pAdmin] >= 1) 
            {
				SendClientMessageEx(a, COLOR_GREYJG, "[AdminWarn] "WHITE_E"%s", str);
            }
        }
		BustAim::GetRandomAimStats(playerid,Wstats);
		format(str,256,"Random Aim Offsets: 1)%f 2)%f 3)%f",Wstats[0],Wstats[1],Wstats[2]);
		foreach (new y : Player)
        {
            if(pData[y][pAdmin] >= 1) 
            {
				SendClientMessageEx(y, COLOR_GREYJG, "[AdminWarn] "WHITE_E"%s", str);
            }
        }
		SendClientMessageToAllEx(COLOR_BAN, "BotCmd: %s Has Been Kicked By MasAdes.", pData[playerid][pName]);
		SendClientMessageToAllEx(COLOR_BAN, "Reason: suspected to be using aimbot(Hit with Random Aim with %s)",wname);
		SendClientMessageToAllEx(COLOR_BAN, "Random Aim Offsets: 1)%f 2)%f 3)%f",Wstats[0],Wstats[1],Wstats[2]);
		KickEx(playerid);
	}
	if(warnings & WARNING_CONTINOUS_SHOTS)
	{
	    format(str,256,"[%d]%s(%d) has fired 10 shots continously with %s(%d)",ids[playerid],nme,playerid,wname,weaponid);
		SendClientMessageToAllEx(-1, str);
	}
	return 0;
}
forward EndTaserEffect(playerid);
public EndTaserEffect(playerid)
{
	new skin = GetPlayerSkin(playerid);
	SetPlayerSkin(playerid, skin);
	ClearAnimations(playerid, 1);
	SetPlayerDrunkLevel(playerid, 0);
	return 1;
}
forward GiveTaserAgain(playerid);
public GiveTaserAgain(playerid)
{
	RemovePlayerAttachedObject(playerid, 0);
	GivePlayerWeaponEx(playerid, TASER_WEAPON, 1);

	new skin = GetPlayerSkin(playerid);
	SetPlayerSkin(playerid, skin);
	ClearAnimations(playerid, 1);
	return 1;
}
forward Shotsfiredtimer(playerid);
public Shotsfiredtimer(playerid)
{
	HideShotsFired(playerid);
    return 1;
}

forward ShowSimplePlayerTetxdraw(playerid);
public ShowSimplePlayerTetxdraw(playerid)
{
	for(new txd; txd < 6; txd++)
	{
		PlayerTextDrawShow(playerid, DGhudchar[txd][playerid]);
	}
	return 1;
}
forward HideSimplePlayerTetxdraw(playerid);
public HideSimplePlayerTetxdraw(playerid)
{
	for(new txd; txd < 6; txd++)
	{
		PlayerTextDrawHide(playerid, DGhudchar[txd][playerid]);
	}
	return 1;
}
stock HideShotsFired(playerid)
{	
	PlayerTextDrawHide(playerid, ShotsTD[0][playerid]);
	PlayerTextDrawHide(playerid, ShotsTD[1][playerid]);
	PlayerTextDrawHide(playerid, ShotsTD[2][playerid]);
	PlayerTextDrawHide(playerid, ShotsTD[3][playerid]);
	PlayerTextDrawHide(playerid, ShotsTD[4][playerid]);
	PlayerTextDrawHide(playerid, ShotsTD[5][playerid]);
    return 1;
}
forward ItemsBoxtimer(playerid);
public ItemsBoxtimer(playerid)
{
	HideItemsBox(playerid);
	return 1;
}
stock HideItemsBox(playerid)
{
	PlayerTextDrawHide(playerid, ITEMSBOX[0][playerid]);
	PlayerTextDrawHide(playerid, ITEMSBOX[1][playerid]);
	PlayerTextDrawHide(playerid, Received[playerid]);
	PlayerTextDrawHide(playerid, ITEMSNAME[playerid]);
	PlayerTextDrawHide(playerid, MODELITEM[playerid]);
	return 1;
}
public OnPlayerWeaponShot(playerid, weaponid, hittype, hitid, Float:fX, Float:fY, Float:fZ)
{
	if(weaponid != 38 && weaponid > 18 && weaponid < 34 && hittype == 1)
	{
		new Float:cood[6],Float:DistantaAim,armaaim[128];
		GetPlayerPos(hitid,cood[0],cood[1],cood[2]); 
		DistantaAim = GetPlayerDistanceFromPoint(playerid,cood[0],cood[1],cood[2]);
		GetWeaponName(weaponid,armaaim,sizeof(armaaim));
 
		if(GetPlayerTargetPlayer(playerid) == INVALID_PLAYER_ID && DistantaAim > 1 && DistantaAim < 31 && TintaApasata[playerid] == 1)
		{
			SilentAimCount[playerid]++;
			if(SilentAimCount[playerid] >= 10)
			{
				SilentAimCount[playerid] = 0;
        		SendClientMessageToAllEx(COLOR_BAN, "BotCmd: %s Has Been Kicked By MasAdes.", pData[playerid][pName]);
				SendClientMessageToAllEx(COLOR_BAN, "Reason: Possible use Silent Aim cheat with %s (Distance: %i meters)", armaaim, floatround(DistantaAim));
				KickEx(playerid);
			}
			return 1;
		}
		GetPlayerLastShotVectors(playerid, cood[0],cood[1],cood[2], cood[3],cood[4],cood[5]);
		if(!IsPlayerInRangeOfPoint(hitid, 3.0, cood[3],cood[4],cood[5])) 
		{
			ProAimCount[playerid]++;
			if(ProAimCount[playerid] >= 5)
			{
				ProAimCount[playerid] = 0;
        		SendClientMessageToAllEx(COLOR_BAN, "BotCmd: %s Has Been Kicked By MasAdes.", pData[playerid][pName]);
				SendClientMessageToAllEx(COLOR_BAN, "Reason: Possible use ProAim cheat with: %s (Distance: %i meters)", armaaim, floatround(DistantaAim));
				KickEx(playerid);
			}
		}
	}

	if(IsBulletHitTorso(playerid))
	{
        ApplyAnimation(playerid, "PED", "ko_skid_back", 4.1, 0, 0, 0, 1, 0, 1);
        SetTimerEx("ClearAnim", 2000, false, "i", playerid);
	}

    foreach(new i : Player)
	{
		if(pData[i][pFaction] == 1)
		{	
			new string[32];
			new locationStrings[40], zoneStrings[MAX_ZONE_NAME];
		  	locationStrings[0] = zoneStrings[0] = EOS;
			GetPlayer2DZone(playerid, zoneStrings, MAX_ZONE_NAME), format(locationStrings, 40, "Loc: %s", zoneStrings);	        
			PlayerTextDrawSetString(i, ShotsTD[4][playerid], locationStrings);
			format(string, sizeof(string), "Weapon: %s", ReturnWeaponName(weaponid));
			PlayerTextDrawSetString(i, ShotsTD[5][playerid], string);
		   	PlayerTextDrawShow(i, ShotsTD[0][playerid]);
			PlayerTextDrawShow(i, ShotsTD[1][playerid]);
			PlayerTextDrawShow(i, ShotsTD[2][playerid]);
			PlayerTextDrawShow(i, ShotsTD[3][playerid]);
			PlayerTextDrawShow(i, ShotsTD[4][playerid]);
			PlayerTextDrawShow(i, ShotsTD[5][playerid]);
	        SetTimerEx("Shotsfiredtimer", 5000, false, "i", playerid);
		}
	}

    if(weaponid == TASER_WEAPON) //taser gun
    {
        if(taser[playerid])
        {
            GiveTaserAgainTimer[playerid] = SetTimerEx("GiveTaserAgain", TASER_GIVING_TIME, 0, "i", playerid);
            ApplyAnimation(playerid, "SWORD", "sword_block", 50.0, 0, 1, 0, 1, 1, 1);
            SetPlayerAttachedObject(playerid, 0, TASER_WEAPON_OBJECT, 6);
            SetPlayerArmedWeapon(playerid, 0);
 
            if(hittype == BULLET_HIT_TYPE_PLAYER) 
            {
                new Float:x, Float:y, Float:z;
                GetPlayerPos(hitid, x, y, z);
                foreach(new i : Player) 
                {
                	if(IsPlayerInRangeOfPoint(i, 30.0, x, y, z)) 
                	{
                		PlayAudioStreamForPlayer(i, "https://a.clyp.it/b0w3dcsr.mp3", x, y, z, 30.0, 1);
                	}
                }
                ApplyAnimation(hitid, "CRACK", "crckdeth2", 4.1, 0, 1, 1, 1, TASER_EFFECT_TIME, 1);
                SetPlayerDrunkLevel(hitid, 5000);
                SetTimerEx("EndTaserEffect", TASER_EFFECT_TIME, 0, "i", hitid);
            }
        }
    }
	switch(weaponid){ case 0..18, 39..54: return 1;} //invalid weapons
	if(1 <= weaponid <= 46 && pData[playerid][pGuns][g_aWeaponSlots[weaponid]] == weaponid)
	{
		pData[playerid][pAmmo][g_aWeaponSlots[weaponid]]--;
		if(pData[playerid][pGuns][g_aWeaponSlots[weaponid]] != 0 && !pData[playerid][pAmmo][g_aWeaponSlots[weaponid]])
		{
			pData[playerid][pGuns][g_aWeaponSlots[weaponid]] = 0;
		}
	}
	if(hittype == BULLET_HIT_TYPE_PLAYER && IsPlayerConnected(hitid) && !IsPlayerNPC(hitid))
    {
        new Float:Shot[3], Float:Hit[3];
        GetPlayerLastShotVectors(playerid, Shot[0], Shot[1], Shot[2], Hit[0], Hit[1], Hit[2]);

        new playersurf = GetPlayerSurfingVehicleID(playerid);
        new hitsurf = GetPlayerSurfingVehicleID(hitid);
        new Float:targetpackets = NetStats_PacketLossPercent(hitid);
        new Float:playerpackets = NetStats_PacketLossPercent(playerid);
        
        if(~(playersurf) && ~(hitsurf) && !IsPlayerInAnyVehicle(playerid) && !IsPlayerInAnyVehicle(hitid))
        {
            if(!IsPlayerAimingAtPlayer(playerid, hitid) && !IsPlayerInRangeOfPoint(hitid, 5.0, Hit[0], Hit[1], Hit[2]))
            {
                new String[10000], issuer[24];
                GetPlayerName(playerid, issuer, 24);
                AimbotWarnings[playerid] ++;

                format(String, sizeof(String), "{FFFFFF}Player %s warning of aimbot or lag [Target PL: %f | Shooter PL:%f]!", issuer, targetpackets, playerpackets);

                for(new p; p < MAX_PLAYERS;p++)
                    if(IsPlayerConnected(p) && IsPlayerAdmin(p))
                         SendClientMessage(p, -1, String);

                if(AimbotWarnings[playerid] > 10)
                {
                    if(targetpackets < 1.2 && playerpackets < 1.2) return Kick(playerid);
                    else
                    {
                        format(String, sizeof(String), "{FFFFFF}Player %s is probably using aimbot [Target PL: %f | Shooter PL:%f]!", issuer, targetpackets, playerpackets);
                        for(new p; p < MAX_PLAYERS;p++) if(IsPlayerConnected(p) && IsPlayerAdmin(p)) SendClientMessage(p, -1, String);
                    }
                }
                return 0;
            }
            else return 1;
        }
        else return 1;
    }
	return 1;
}
stock ClearAnim(playerid)
{
	ClearAnimations(playerid);
	StopLoopingAnim(playerid);
	return 1;
}
forward OnAimbotDetect(issuerid, playerid);
public OnAimbotDetect(issuerid, playerid)
{
    new str[48];
    format(str, sizeof(str), "( ! ) Player ID '%d' is possibly using aimbot!", issuerid);
    SendClientMessageToAll(-1, str);
    return 1;
}
stock GivePlayerHealth(playerid,Float:Health)
{
	new Float:health; GetPlayerHealth(playerid,health);
	SetPlayerHealth(playerid,health+Health);
}

public OnVehicleDamageStatusUpdate(vehicleid, playerid)
{
	//new
        //Float: vehicleHealth,
        //playerVehicleId = GetPlayerVehicleID(playerid);

    //new Float:health = GetPlayerHealth(playerid, health);
    //GetVehicleHealth(playerVehicleId, vehicleHealth);
    //new panels, doors, lights, tires;
    //GetVehicleDamageStatus(vehicleid, panels, doors, lights, tires);
    //UpdateVehicleDamageStatus(vehicleid, panels, doors, lights, tires);
    //UPGRADE
    new panel, doors, lights, tires, Float: HP, playerVehicleId = GetPlayerVehicleID(playerid);
	if(pvData[vehicleid][cBodyUpgrade] == 1)
	{
	    GetVehicleHealth(playerVehicleId, HP);
        GetVehicleDamageStatus(vehicleid, panel, doors, lights, tires);
        if(HP >= 1500) UpdateVehicleDamageStatus(vehicleid, 0, 0, 0, 0);
    }
   	else
   	{
    	GetVehicleHealth(playerVehicleId, HP);
        GetVehicleDamageStatus(vehicleid, panel, doors, lights, tires);
        if(HP < 1500)
        UpdateVehicleDamageStatus(vehicleid, panel, doors, lights, tires);
        pvData[playerVehicleId][cDamage0] = panel;
        pvData[playerVehicleId][cDamage1] = doors;
        pvData[playerVehicleId][cDamage2] = lights;
        pvData[playerVehicleId][cDamage3] = tires;
        pvData[playerVehicleId][cHealth] = HP;
   	}
    return 1;
}
public OnPlayerFall(playerid, Float:damage)
{
	if(IsAtEvent[playerid] == 0)
	{
		pData[playerid][pBodyCondition][4] -= damage;
		pData[playerid][pBodyCondition][5] -= damage;
	}
	return 1;
}
public OnPlayerTakeDamage(playerid, issuerid, Float: amount, weaponid, bodypart)
{
	//SetTimerEx("DeleteBarMask", 1000, false, "i", playerid);
	new Float:Armor, Float:Health;
	GetPlayerArmour(playerid, Armor);
	GetPlayerHealth(playerid, Health);
	//CreateDamageLog(playerid, Float:amount, weaponid, bodypart);
	new Float:sakit = RandomEx(20,22);
	if(IsAtEvent[playerid] == 0)
	{
		if(issuerid != INVALID_PLAYER_ID && GetPlayerWeapon(issuerid))
		{
			if(pData[issuerid][pTogDamage] == 0)
			{
				Info(issuerid, "Kamu menembak seseorang dengan {C6E2FF}%s{FFFFFF} dan memberikan damage sebesar {FF0000}%.1f", ReturnWeaponName(weaponid), amount);
			}
		}
		if(issuerid != INVALID_PLAYER_ID && GetPlayerWeapon(issuerid) && bodypart == 3)
		{
			if(pData[playerid][pBodyCondition][1] > 0)
			{
				pData[playerid][pBodyCondition][1] -= sakit;
			}
		}
		if(issuerid != INVALID_PLAYER_ID && GetPlayerWeapon(issuerid) && bodypart == 6)
		{
			if(pData[playerid][pBodyCondition][2] > 0)
			{
				pData[playerid][pBodyCondition][2] -= sakit;
			}
		}
		if(issuerid != INVALID_PLAYER_ID && GetPlayerWeapon(issuerid) && bodypart == 5)
		{
			if(pData[playerid][pBodyCondition][3] > 0)
			{
				pData[playerid][pBodyCondition][3] -= sakit;
			}
		}
		if(issuerid != INVALID_PLAYER_ID && GetPlayerWeapon(issuerid) && bodypart == 8)
		{
			if(pData[playerid][pBodyCondition][4] > 0)
			{
				pData[playerid][pBodyCondition][4] -= sakit;
			}
		}
		if(issuerid != INVALID_PLAYER_ID && GetPlayerWeapon(issuerid) && bodypart == 7)
		{
			if(pData[playerid][pBodyCondition][5] > 0)
			{
				pData[playerid][pBodyCondition][5] -= sakit;
			}
		}
	}
	if (weaponid == TASER_WEAPON) 
    {
        if (taser[issuerid])
        {
            new Float:health;
            GetPlayerHealth(playerid, health);
            SetPlayerHealthEx(playerid, health+amount);
        }
    }
	return 1;
}

public OnPlayerUpdate(playerid)
{
	if(pData[playerid][pMaskOn] == 1)
	{
		for(new i = GetPlayerPoolSize(); i != -1; --i)
		{
			ShowPlayerNameTagForPlayer(i, playerid, true);
		}
	}
	if(pData[playerid][pMaskOn] == 0)
    {
      	for(new i = GetPlayerPoolSize(); i != -1; --i)
		{
			ShowPlayerNameTagForPlayer(i, playerid, 1);
		}
    }
    //Mask System
	if(pData[playerid][pMaskOn] == 1)
	{
		new Float: health, Float: armour;
		GetPlayerHealth(playerid, health), GetPlayerArmour(playerid, armour);
		if(armour == 0)
		{
			new str[300];
			format(str, sizeof(str), "Mask_#%d\nH:["RED_E"%.1f"WHITE_E"]", pData[playerid][pMaskID], health);
			UpdateDynamic3DTextLabelText(pData[playerid][pMaskLabel], -1, str);
			Attach3DTextLabelToPlayer(pData[playerid][pMaskLabel], playerid, 0, 0, 0.39);
		}
		else if(armour > 0)
		{
			new strr[300];
			format(strr, sizeof(strr), "Mask_#%d\nH:["RED_E"%.1f"WHITE_E"] A:["RED_E"%.1f"WHITE_E"]", pData[playerid][pMaskID], health, armour);
			UpdateDynamic3DTextLabelText(pData[playerid][pMaskLabel], -1, strr);
			Attach3DTextLabelToPlayer(pData[playerid][pMaskLabel], playerid, 0, 0, 0.39);
		}
	}
	UpdateTazer(playerid);
	PlayerUpDateNeedBar(playerid);
	p_tick[playerid]++;
	CheckPlayerInSpike(playerid);
	//health
  	if(pData[playerid][pBodyCondition][0] >= 80.0 && pData[playerid][pBodyCondition][0] <= 100.0)//Groin
  	{
  	  	pData[playerid][pStockBodyCondition][0] = 1;
  	}
  	if(pData[playerid][pBodyCondition][0] >= 50.0 && pData[playerid][pBodyCondition][0] <= 79.0)//Groin
  	{
    	pData[playerid][pStockBodyCondition][0] = 2;
  	}
  	if(pData[playerid][pBodyCondition][0] >= 10.0 && pData[playerid][pBodyCondition][0] <= 49.0)//Groin
  	{
    	pData[playerid][pStockBodyCondition][0] = 3;
 	}
  	if(pData[playerid][pBodyCondition][0] >= 0 && pData[playerid][pBodyCondition][0] <= 9.0)//Groin
  	{
    	pData[playerid][pStockBodyCondition][0] = 4;
  	}
  	//Condition Character 1
  	if(pData[playerid][pBodyCondition][1] >= 80.0 && pData[playerid][pBodyCondition][1] <= 100.0)//Torso
  	{
    	pData[playerid][pStockBodyCondition][1] = 1;
  	}
  	if(pData[playerid][pBodyCondition][1] >= 50.0 && pData[playerid][pBodyCondition][1] <= 79.0)//Torso
  	{
    	pData[playerid][pStockBodyCondition][1] = 2;
  	}
  	if(pData[playerid][pBodyCondition][1] >= 10.0 && pData[playerid][pBodyCondition][1] <= 49.0)//Torso
  	{
    	pData[playerid][pStockBodyCondition][0] = 3;
  	}
  	if(pData[playerid][pBodyCondition][1] >= 0 && pData[playerid][pBodyCondition][1] <= 9.0)//Torso
  	{
    	pData[playerid][pStockBodyCondition][1] = 4;
  	}
  	//Condition Character 2
  	if(pData[playerid][pBodyCondition][2] >= 80.0 && pData[playerid][pBodyCondition][2] <= 100.0)//Right Arm
  	{
    	pData[playerid][pStockBodyCondition][2] = 1;
  	}
  	if(pData[playerid][pBodyCondition][2] >= 50.0 && pData[playerid][pBodyCondition][2] <= 79.0)//Right Arm
  	{
    	pData[playerid][pStockBodyCondition][2] = 2;
  	}
  	if(pData[playerid][pBodyCondition][2] >= 10.0 && pData[playerid][pBodyCondition][2] <= 49.0)//Right Arm
  	{
    	pData[playerid][pStockBodyCondition][2] = 3;
  	}
  	if(pData[playerid][pBodyCondition][2] >= 0 && pData[playerid][pBodyCondition][2] <= 9.0)//Right Arm
  	{
    	pData[playerid][pStockBodyCondition][2] = 4;
  	}
  	//Condition Character 3
  	if(pData[playerid][pBodyCondition][3] >= 80.0 && pData[playerid][pBodyCondition][3] <= 100.0)//Left Arm
  	{
    	pData[playerid][pStockBodyCondition][3] = 1;
  	}
  	if(pData[playerid][pBodyCondition][3] >= 50.0 && pData[playerid][pBodyCondition][3] <= 79.0)//Left Arm
  	{
    	pData[playerid][pStockBodyCondition][3] = 2;
  	}
  	if(pData[playerid][pBodyCondition][3] >= 10.0 && pData[playerid][pBodyCondition][3] <= 49.0)//Left Arm
  	{
    	pData[playerid][pStockBodyCondition][3] = 3;
  	}
  	if(pData[playerid][pBodyCondition][3] >= 0 && pData[playerid][pBodyCondition][3] <= 9.0)//Left Arm
  	{
    	pData[playerid][pStockBodyCondition][3] = 4;
  	}
  	//Condition Character 4
  	if(pData[playerid][pBodyCondition][4] >= 80.0 && pData[playerid][pBodyCondition][4] <= 100.0)//Right Leg
  	{
    	pData[playerid][pStockBodyCondition][4] = 1;
  	}
  	if(pData[playerid][pBodyCondition][4] >= 50.0 && pData[playerid][pBodyCondition][4] <= 79.0)//Right Leg
  	{
    	pData[playerid][pStockBodyCondition][4] = 2;
  	}
  	if(pData[playerid][pBodyCondition][4] >= 10.0 && pData[playerid][pBodyCondition][4] <= 49.0)//Right Leg
  	{
    	pData[playerid][pStockBodyCondition][4] = 3;
  	}
  	if(pData[playerid][pBodyCondition][4] >= 0 && pData[playerid][pBodyCondition][4] <= 9.0)//Right Leg
  	{
    	pData[playerid][pStockBodyCondition][4] = 4;
  	}
  	//Condition Character 5
  	if(pData[playerid][pBodyCondition][5] >= 80.0 && pData[playerid][pBodyCondition][5] <= 100.0)//Left Leg
  	{
    	pData[playerid][pStockBodyCondition][5] = 1;
  	}
  	if(pData[playerid][pBodyCondition][5] >= 50.0 && pData[playerid][pBodyCondition][5] <= 79.0)//Left Leg
  	{
    	pData[playerid][pStockBodyCondition][5] = 2;
  	}
  	if(pData[playerid][pBodyCondition][5] >= 10.0 && pData[playerid][pBodyCondition][5] <= 49.0)//Left Leg
  	{
    	pData[playerid][pStockBodyCondition][5] = 3;
  	}
  	if(pData[playerid][pBodyCondition][5] >= 0 && pData[playerid][pBodyCondition][5] <= 9.0)//Left Leg
  	{
    	pData[playerid][pStockBodyCondition][5] = 4;
  	}
	//fix health
	if(pData[playerid][pInjured] == 0)
	{
		if(pData[playerid][pHealth] > 100)
		{
			SetPlayerHealthEx(playerid, 100);
		}
		//return 0;
	}
	return 1;
}

public OnPlayerPause(playerid)
{
	AFK[playerid] = 1;
	return 1;
}

public OnPlayerResume(playerid, time)
{
	AFK[playerid] = 0;
	return 1;
}

task VehicleUpdate[40000]()
{
	for (new i = 1; i != MAX_VEHICLES; i ++) if(IsEngineVehicle(i) && GetEngineStatus(i))
    {
        if(GetVehicleFuel(i) > 0)
        {
			new fuel = GetVehicleFuel(i);
            SetVehicleFuel(i, fuel - 15);

            if(GetVehicleFuel(i) >= 1 && GetVehicleFuel(i) <= 200)
            {
               Info(GetVehicleDriver(i), "This vehicle is low on fuel. You must visit a fuel station!");
            }
        }
        if(GetVehicleFuel(i) <= 0)
        {
            SetVehicleFuel(i, 0);
            SwitchVehicleEngine(i, false);
        }
    }
	foreach(new ii : PVehicles)
	{
		if(IsValidVehicle(pvData[ii][cVeh]))
		{
			if(pvData[ii][cPlateTime] != 0 && pvData[ii][cPlateTime] <= gettime())
			{
				format(pvData[ii][cPlate], 32, "Capitaliz");
				SetVehicleNumberPlate(pvData[ii][cVeh], pvData[ii][cPlate]);
				pvData[ii][cPlateTime] = 0;
			}
			if(pvData[ii][cRent] != 0 && pvData[ii][cRent] <= gettime())
			{
				pvData[ii][cRent] = 0;
				new query[128];
				mysql_format(g_SQL, query, sizeof(query), "DELETE FROM vehicle WHERE id = '%d'", pvData[ii][cID]);
				mysql_tquery(g_SQL, query);
				if(IsValidVehicle(pvData[ii][cVeh])) DestroyVehicle(pvData[ii][cVeh]);
				Iter_SafeRemove(PVehicles, ii, ii);
			}
		}
		if(pvData[ii][cClaimTime] != 0 && pvData[ii][cClaimTime] <= gettime())
		{
			pvData[ii][cClaimTime] = 0;
		}
		if(pvData[ii][cImpoundTime] != 0 && pvData[ii][cImpoundTime] <= gettime())
		{
			pvData[ii][cImpoundTime] = 0;
		}
	}
}
public OnVehicleDeath(vehicleid, killerid)
{
	foreach(new i : PVehicles)
	{
		if(pvData[i][cVeh] == vehicleid)
		{
			pvData[i][cDeath] = gettime() + 15;
			pvData[i][cRadio] = 0;
		}
	}
	return 1;
}

public OnVehicleSpawn(vehicleid)
{
	//trasher
    LoadedTrash[vehicleid] = 0;
    //end

	foreach(new ii : PVehicles)
	{
		if(vehicleid == pvData[ii][cVeh] && pvData[ii][cRent] == 0 && pvData[ii][cDeath] > gettime())
		{
			if(pvData[ii][cInsu] > 0)
    		{
    			pvData[ii][cDeath] = 0;
    			//pvData[ii][cRadio] =  0;
				pvData[ii][cInsu]--;
				pvData[ii][cClaim] = 1;
				pvData[ii][cClaimTime] = gettime() + (1 * 3600);
				foreach(new pid : Player) if (pvData[ii][cOwner] == pData[pid][pID])
        		{
            		Info(pid, "Kendaraan anda hancur dan anda masih memiliki {FFFF00}insuransi{FFFFFF}, silahkan ambil di kantor sags setelah 1 jam.");
				}
				if(IsValidVehicle(pvData[ii][cVeh]))
					DestroyVehicle(pvData[ii][cVeh]);
				
				pvData[ii][cVeh] = 0;
			}
			else
			{
				foreach(new pid : Player) if (pvData[ii][cOwner] == pData[pid][pID])
        		{
					new query[128];
					mysql_format(g_SQL, query, sizeof(query), "DELETE FROM vehicle WHERE id = '%d'", pvData[pid][cID]);
					mysql_tquery(g_SQL, query);
					for(new z = 0; z < 4; z++)
					{
						vtData[pvData[ii][cVeh]][z][vtoy_modelid] = 0;
						vtData[pvData[ii][cVeh]][z][vtoy_x] = 0.0;
						vtData[pvData[ii][cVeh]][z][vtoy_y] = 0.0;
						vtData[pvData[ii][cVeh]][z][vtoy_z] = 0.0;
						vtData[pvData[ii][cVeh]][z][vtoy_rx] = 0.0;
						vtData[pvData[ii][cVeh]][z][vtoy_ry] = 0.0;
						vtData[pvData[ii][cVeh]][z][vtoy_rz] = 0.0;
						DestroyObject(vtData[pvData[ii][cVeh]][z][vtoy_model]);
					}
					mysql_format(g_SQL, query, sizeof(query), "DELETE FROM vtoys WHERE Owner = '%d'", pvData[pid][cID]);
					mysql_tquery(g_SQL, query);
					pvData[pvData[ii][cVeh]][PurchasedvToy] = false;

					mysql_format(g_SQL, query, sizeof(query), "DELETE FROM trunk WHERE Owner = '%d'", pvData[pid][cID]);
					mysql_tquery(g_SQL, query);
					pvData[pvData[ii][cVeh]][LoadedStorage] = false;
					if(IsValidVehicle(pvData[ii][cVeh]))
						DestroyVehicle(pvData[ii][cVeh]);
            		Info(pid, "Kendaraan anda hancur dan tidak memiliki {FFFF00}insuransi.");
					Iter_SafeRemove(PVehicles, ii, ii);
				}
				pvData[ii][cDeath] = 0;
			}
			return 1;
		}
	}
	return 1;
}

ptask PlayerVehicleUpdate[200](playerid)
{
	new vehicleid = GetPlayerVehicleID(playerid);
	if(IsValidVehicle(vehicleid))
	{
		if(!GetEngineStatus(vehicleid) && IsEngineVehicle(vehicleid))
		{
			SwitchVehicleEngine(vehicleid, false);
		}
		if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
		{
			new Float:fHealth;
			GetVehicleHealth(vehicleid, fHealth);
			if(IsValidVehicle(vehicleid) && fHealth <= 350.0)
			{
				SetValidVehicleHealth(vehicleid, 300.0);
				SwitchVehicleEngine(vehicleid, false);
				GameTextForPlayer(playerid, "~r~Totalled!", 2500, 3);
			}
		}
		if(IsPlayerInAnyVehicle(playerid) && GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
		{
			if(pData[playerid][pHBEMode] == 1)
			{
			    new Float:fDamage, fFuel, color1, color2;
				new tstr[64], nstr[50];

				GetVehicleColor(vehicleid, color1, color2);

				GetVehicleHealth(vehicleid, fDamage);

				//fDamage = floatdiv(1000 - fDamage, 10) * 1.42999;

				if(fDamage <= 350.0) fDamage = 0.0;
				else if(fDamage > 1000.0) fDamage = 1000.0;

				fFuel = GetVehicleFuel(vehicleid);

				if(fFuel < 0) fFuel = 0;
				else if(fFuel > 1000) fFuel = 1000;


				format(tstr, sizeof(tstr), "%s", GetVehicleName(vehicleid));
				PlayerTextDrawSetString(playerid, TDE_VELO[playerid][9], tstr);
				new string_velo[50]; static Float:valor;
				valor = GetVehicleSpeed(vehicleid);
				if(valor < 100.0) 
				{
					PlayerTextDrawBoxColor(playerid,TDE_VELO[playerid][7], -65440);
					PlayerTextDrawTextSize(playerid, TDE_VELO[playerid][7],(315.0 + ((46.0 * ++valor) / 100)), 0.0);
				}
				else
				{
					valor = 0.0;
					PlayerTextDrawBoxColor(playerid,TDE_VELO[playerid][7], 0xFF0000AA);
				}
				PlayerTextDrawShow(playerid, TDE_VELO[playerid][7]);

				if(!GetEngineStatus(vehicleid))
				{
					PlayerTextDrawSetString(playerid, TDE_VELO[playerid][4], "Off");
				}
				else
				{
					format(string_velo, sizeof (string_velo), "%.0f", GetVehicleSpeed(vehicleid));
			    	PlayerTextDrawSetString(playerid, TDE_VELO[playerid][4], string_velo);
				}
			    
			    format(nstr, sizeof (nstr), "  %dL", fFuel);
			    PlayerTextDrawSetString(playerid, TDE_VELO[playerid][13], nstr);

				new Float:VidaV; GetVehicleHealth(vehicleid, VidaV);
				new Float:V1 = floatmul(VidaV, 100.0);
				new Float:V2 = floatdiv(V1, 1000.0);
				if(VidaV < 1001)
				{
					new string2[100];
					format(string2, sizeof(string2), "%0.0f%s", V2, "%");
					PlayerTextDrawSetString(playerid, TDE_VELO[playerid][11], string2);
				}
			}
			else if(pData[playerid][pHBEMode] == 2)
			{
				new Float:fDamage, fFuel, color1, color2;
				new tstr[64];

				GetVehicleColor(vehicleid, color1, color2);

				GetVehicleHealth(vehicleid, fDamage);

				//fDamage = floatdiv(1000 - fDamage, 10) * 1.42999;

				if(fDamage <= 350.0) fDamage = 0.0;
				else if(fDamage > 1000.0) fDamage = 1000.0;

				fFuel = GetVehicleFuel(vehicleid);

				if(fFuel < 0) fFuel = 0;
				else if(fFuel > 1000) fFuel = 1000;

				if(!GetEngineStatus(vehicleid))
				{
					PlayerTextDrawSetString(playerid, DPvehengine[playerid], "~r~OFF");
				}
				else
				{
					PlayerTextDrawSetString(playerid, DPvehengine[playerid], "~g~ON");
				}

				SetPlayerProgressBarValue(playerid, pData[playerid][fuelbar], fFuel);
				SetPlayerProgressBarValue(playerid, pData[playerid][damagebar], fDamage);

				format(tstr, sizeof(tstr), "%s", GetVehicleName(vehicleid));
				PlayerTextDrawSetString(playerid, DPvehname[playerid], tstr);

				format(tstr, sizeof(tstr), "%.0f Mph", GetVehicleSpeed(vehicleid));
				PlayerTextDrawSetString(playerid, DPvehspeed[playerid], tstr);
			}
			else if(pData[playerid][pHBEMode] == 3)
			{
				new Float:fDamage, fFuel, tstr[64];			
				
				GetVehicleHealth(vehicleid, fDamage);		
				fFuel = GetVehicleFuel(vehicleid);		

				if(fDamage <= 350.0) fDamage = 0.0;
				else if(fDamage > 1000.0) fDamage = 1000.0;
				
				if(fFuel < 0) fFuel = 0;
				else if(fFuel > 1000) fFuel = 1000;

				new Float:fuel = fFuel * 51.0/1000.0;
				TextDrawTextSize(FUELBARMODERN, fuel, 10.0);
				TextDrawShowForPlayer(playerid, FUELBARMODERN);

				new Float:v_hp = fDamage * 51.0/1000.0;
				TextDrawTextSize(HEALTHBARMODERN, v_hp, 10.0);
				TextDrawShowForPlayer(playerid, HEALTHBARMODERN);

				format(tstr, sizeof(tstr), "%s", GetVehicleName(vehicleid));
				TextDrawSetString(VEHNAMETDMODERN, tstr);

				format(tstr, sizeof(tstr), "%.0f", GetVehicleSpeed(vehicleid));
				TextDrawSetString(SPEEDTDMODERN, tstr);
			}
			else
			{

			}
		}
	}
}

PlayerUpDateNeedBar(playerid)
{
	if(pData[playerid][pHBEMode] == 1)
	{
		new Float:value;
		value = pData[playerid][pHunger] * 82.5/100;
		PlayerTextDrawTextSize(playerid, DGhudchar[3][playerid], value, 15.5);
		PlayerTextDrawShow(playerid, DGhudchar[3][playerid]);

		new Float:values;
		values = pData[playerid][pEnergy] * 82.5/100;
		PlayerTextDrawTextSize(playerid, DGhudchar[1][playerid], values, 15.5);
		PlayerTextDrawShow(playerid, DGhudchar[1][playerid]);
	}
	return true;
}

ptask PlayerUpdate[999](playerid)
{
	//fish
	if(pData[playerid][pFTime] > 0)
    {
        if(pData[playerid][pFTime] == 1)
        {
            SendClientMessageEx(playerid, COLOR_PINK, "Fish : Sekarang kamu dapat memancing lagi.");
            pData[playerid][pFTime] --;
   		}
    }
    else
    {
        pData[playerid][pFTime] --;
    }
    if(pData[playerid][pTrainingTime] > 0)
    {
        if(pData[playerid][pTrainingTime] == 1)
        {
            SendClientMessageEx(playerid, COLOR_GREYJG, "SKILL: Sekarang kamu bisa melakukan latihan kembali.");
            pData[playerid][pTrainingTime] --;
    	}
    	else
    	{
            pData[playerid][pTrainingTime] --;
        }
    }
	if(pData[playerid][pMaskOn] == 1)
	{
		if(pData[playerid][pArmour] <= 0)
		{
			new string[128], Float:Health;
			GetPlayerHealth(playerid, Health);
		    //GetPlayerArmour(playerid, Armour);
			format(string, sizeof(string), "Mask_%d\n["RED_E"%.1f"WHITE_E"]", pData[playerid][pMaskID], Health);
			UpdateDynamic3DTextLabelText(MaskLabel[playerid], -1, string);
		}
		else
		{
			new string[128], Float:Health, Float:Armour;
			GetPlayerHealth(playerid, Health);
		    GetPlayerArmour(playerid, Armour);
			format(string, sizeof(string), "Mask_%d\n["RED_E"%.1f"WHITE_E"] [%.1f]", pData[playerid][pMaskID], Health, Armour);
			UpdateDynamic3DTextLabelText(MaskLabel[playerid], -1, string);
		}
	}
	//Anti-Money Hack
	if(GetPlayerMoney(playerid) > pData[playerid][pMoney])
	{
		ResetPlayerMoney(playerid);
		GivePlayerMoney(playerid, pData[playerid][pMoney]);
		//SendAdminMessage(COLOR_PINK, "Possible money hacks detected on %s(%i). Check on this player. "LG_E"($%d).", pData[playerid][pName], playerid, GetPlayerMoney(playerid) - pData[playerid][pMoney]);
	}
	// if(GetPlayerPing(playerid) > 800) // Ping Player
    // {
    //     FixedKick(playerid);
    // }
	//Anti Armour Hacks
	new Float:A;
	GetPlayerArmour(playerid, A);
	if(A > 98)
	{
		new fmt_msg[128];
		SetPlayerArmourEx(playerid, 0);
		SendClientMessageToAllEx(COLOR_BAN, "BotCmd: %s(%i) has been kicked by Mas Dicky.", pData[playerid][pName], playerid);
		format(fmt_msg, sizeof fmt_msg, "Reason: Armour Hacks");
        SendClientMessageToAll(COLOR_BAN, fmt_msg);
		FixedKick(playerid);
		//AutoBan(playerid);
	}
	//Weapon AC
	if(pData[playerid][pSpawned] == 1)
    {
        if(GetPlayerWeapon(playerid) != pData[playerid][pWeapon])
        {
            pData[playerid][pWeapon] = GetPlayerWeapon(playerid);

            if(pData[playerid][pWeapon] >= 1 && pData[playerid][pWeapon] <= 45 && pData[playerid][pWeapon] != 42 && pData[playerid][pWeapon] != 2 && pData[playerid][pGuns][g_aWeaponSlots[pData[playerid][pWeapon]]] != GetPlayerWeapon(playerid))
            {
                SendAdminWarn(COLOR_PINK, "%s (%d) has possibly used weapon hacks (%s), Please to check /spec this player first!", pData[playerid][pName], playerid, ReturnWeaponName(pData[playerid][pWeapon]));
                SetWeapons(playerid); //Reload old weapons
                //AutoBan(playerid);
            }
        }
    }
	//Weapon Atth
	if(NetStats_GetConnectedTime(playerid) - WeaponTick[playerid] >= 250)
	{
		static weaponid, ammo, objectslot, count, index;

		for (new i = 2; i <= 7; i++) //Loop only through the slots that may contain the wearable weapons
		{
			GetPlayerWeaponData(playerid, i, weaponid, ammo);
			index = weaponid - 22;

			if (weaponid && ammo && !WeaponSettings[playerid][index][Hidden] && IsWeaponWearable(weaponid) && EditingWeapon[playerid] != weaponid)
			{
				objectslot = GetWeaponObjectSlot(weaponid);

				if (GetPlayerWeapon(playerid) != weaponid)
					SetPlayerAttachedObject(playerid, objectslot, GetWeaponModel(weaponid), WeaponSettings[playerid][index][Bone], WeaponSettings[playerid][index][Position][0], WeaponSettings[playerid][index][Position][1], WeaponSettings[playerid][index][Position][2], WeaponSettings[playerid][index][Position][3], WeaponSettings[playerid][index][Position][4], WeaponSettings[playerid][index][Position][5], 1.0, 1.0, 1.0);

				else if (IsPlayerAttachedObjectSlotUsed(playerid, objectslot)) RemovePlayerAttachedObject(playerid, objectslot);
			}
		}
		for (new i = 4; i <= 8; i++) if (IsPlayerAttachedObjectSlotUsed(playerid, i))
		{
			count = 0;

			for (new j = 22; j <= 38; j++) if (PlayerHasWeapon(playerid, j) && GetWeaponObjectSlot(j) == i)
				count++;

			if(!count) RemovePlayerAttachedObject(playerid, i);
		}
		WeaponTick[playerid] = NetStats_GetConnectedTime(playerid);
	}
	if(pData[playerid][pJail] <= 0)
	{
		if(pData[playerid][pHunger] > 100)
		{
			pData[playerid][pHunger] = 100;
		}
		if(pData[playerid][pHunger] < 0)
		{
			pData[playerid][pHunger] = 0;
		}
		if(pData[playerid][pEnergy] > 100)
		{
			pData[playerid][pEnergy] = 100;
		}
		if(pData[playerid][pEnergy] < 0)
		{
			pData[playerid][pEnergy] = 0;
		}
	}
	if(pData[playerid][pHBEMode] == 2 && pData[playerid][IsLoggedIn] == true)
	{
		SetPlayerProgressBarValue(playerid, pData[playerid][hungrybar], pData[playerid][pHunger]);
		SetPlayerProgressBarColour(playerid, pData[playerid][hungrybar], ConvertHBEColor(pData[playerid][pHunger]));
		SetPlayerProgressBarValue(playerid, pData[playerid][energybar], pData[playerid][pEnergy]);
		SetPlayerProgressBarColour(playerid, pData[playerid][energybar], ConvertHBEColor(pData[playerid][pEnergy]));
		new strings[64], tstr[64];
		format(strings, sizeof(strings), "%s", pData[playerid][pName]);
		PlayerTextDrawSetString(playerid, DPname[playerid], strings);
		PlayerTextDrawShow(playerid, DPname[playerid]);
		format(tstr, sizeof(tstr), "Gold: %d", pData[playerid][pGold]);
		PlayerTextDrawSetString(playerid, DPcoin[playerid], tstr);
		PlayerTextDrawShow(playerid, DPcoin[playerid]);
		PlayerTextDrawSetString(playerid, DPmoney[playerid], FormatMoney(GetPlayerMoney(playerid)));
  		PlayerTextDrawShow(playerid, DPmoney[playerid]);

	}
	else if(pData[playerid][pTDMode] == 2 && pData[playerid][IsLoggedIn] == true)
	{
		SetPlayerProgressBarValue(playerid, pData[playerid][BarHp], pData[playerid][pHealth]);
		SetPlayerProgressBarValue(playerid, pData[playerid][BarArmour], pData[playerid][pArmour]);
	}
	if(pData[playerid][pHospital] == 1)
    {
		if(pData[playerid][pInjured] == 1)
		{
			SetPlayerPosition(playerid, 1187.2991, -1332.2943, 13.5611, 257.4692, 1);

			SetPlayerInterior(playerid, 1);
			SetPlayerVirtualWorld(playerid, playerid + 100);

			SetPlayerCameraPos(playerid, 1187.9255, -1338.8413, 13.5703);
			SetPlayerCameraLookAt(playerid, -2028.32, -92.87, 1067.43);
			ResetPlayerWeaponsEx(playerid);
			TogglePlayerControllable(playerid, 0);
			pData[playerid][pInjured] = 0;
			UpdateDynamic3DTextLabelText(pData[playerid][pInjuredLabel], COLOR_GREEN, "");
			
		}
		pData[playerid][pHospitalTime]++;
		new mstr[64];
		format(mstr, sizeof(mstr), "~n~~n~~n~~w~Recovering... %d", 15 - pData[playerid][pHospitalTime]);
		InfoTD_MSG(playerid, 1000, mstr);

		ApplyAnimation(playerid, "CRACK", "crckdeth2", 4.0, 1, 0, 0, 0, 0);
		ApplyAnimation(playerid, "CRACK", "crckdeth2", 4.0, 1, 0, 0, 0, 0);
        if(pData[playerid][pHospitalTime] >= 15)
        {
            pData[playerid][pHospitalTime] = 0;
            pData[playerid][pHospital] = 0;
			pData[playerid][pHunger] = 50;
			pData[playerid][pEnergy] = 50;
			SetPlayerHealthEx(playerid, 50);
			pData[playerid][pSick] = 0;
			GivePlayerMoneyEx(playerid, -20000);
			SetPlayerHealthEx(playerid, 50);

            for (new i; i < 20; i++)
            {
                SendClientMessage(playerid, -1, "");
            }

			SendClientMessage(playerid, COLOR_GREY, "--------------------------------------------------------------------------------------------------------");
            SendClientMessage(playerid, COLOR_PINK, "Kamu telah keluar dari rumah sakit, kamu membayar {00FF00}$200.00 {FFFFFF}kerumah sakit.");
            SendClientMessage(playerid, COLOR_GREY, "--------------------------------------------------------------------------------------------------------");

			SetPlayerPosition(playerid, 1182.8778, -1324.2023, 13.5784, 269.8747);

            TogglePlayerControllable(playerid, 1);
            SetCameraBehindPlayer(playerid);

            SetPlayerVirtualWorld(playerid, 0);
            SetPlayerInterior(playerid, 0);
			ClearAnimations(playerid);
			pData[playerid][pSpawned] = 1;
			SetPVarInt(playerid, "GiveUptime", -1);
		}
    }
	if(pData[playerid][pInjured] == 1 && pData[playerid][pHospital] != 1)
    {
		new mstr[64]; new strings[150];
        format(mstr, sizeof(mstr), "/death for spawn to hospital /teriak for signal emergency");
		InfoTD_MSG(playerid, 1000, mstr);
		//format(strings, sizeof(strings), "(( Injured PLAYER ))");
		UpdateDynamic3DTextLabelText(pData[playerid][pInjuredLabel], COLOR_GREEN, strings);
		
		if(GetPVarInt(playerid, "GiveUptime") == -1)
		{
			SetPVarInt(playerid, "GiveUptime", gettime());
		}
		
		if(GetPVarInt(playerid,"GiveUptime"))
        {
            if((gettime()-GetPVarInt(playerid, "GiveUptime")) > 600)
            {
                Info(playerid, "Now you can spawn, type '/death' for spawn to hospital.");
                SetPVarInt(playerid, "GiveUptime", 0);
            }
        }
		
        ApplyAnimation(playerid, "CRACK", "crckidle1", 4.0, 0, 0, 0, 1, 0, 1);
        ApplyAnimation(playerid, "CRACK", "crckidle1", 4.0, 0, 0, 0, 1, 0, 1);
        SetPlayerHealthEx(playerid, 99999);
    }
	if(pData[playerid][pInjured] == 0 && pData[playerid][pGender] != 0) //Pengurangan Data
	{
		if(++ pData[playerid][pHungerTime] >= 150)
        {
            if(pData[playerid][pHunger] > 0)
            {
                pData[playerid][pHunger]--;
            }
            else if(pData[playerid][pHunger] <= 0)
            {
                //SetPlayerHealth(playerid, health - 10);
          		//SetPlayerDrunkLevel(playerid, 8000);
          		pData[playerid][pSick] = 1;
            }
            pData[playerid][pHungerTime] = 0;
        }
        if(++ pData[playerid][pEnergyTime] >= 120)
        {
            if(pData[playerid][pEnergy] > 0)
            {
                pData[playerid][pEnergy]--;
            }
            else if(pData[playerid][pEnergy] <= 0)
            {
                //SetPlayerHealth(playerid, health - 10);
          		//SetPlayerDrunkLevel(playerid, 8000);
          		pData[playerid][pSick] = 1;
            }
            pData[playerid][pEnergyTime] = 0;
        }
		if(pData[playerid][pSick] == 1)
		{
			if(++ pData[playerid][pSickTime] >= 200)
			{
				if(pData[playerid][pSick] >= 1)
				{
					new Float:hp;
					GetPlayerHealth(playerid, hp);
					SetPlayerDrunkLevel(playerid, 8000);
					ApplyAnimation(playerid,"CRACK","crckdeth2",4.1,0,1,1,1,1,1);
					Info(playerid, "Sepertinya anda sakit, segeralah pergi ke dokter.");
					SetPlayerHealth(playerid, hp - 3);
					pData[playerid][pSickTime] = 0;
				}
			}
		}
	}
	//Jail Player
	if(pData[playerid][pJail] > 0)
	{
		if(pData[playerid][pJailTime] > 0)
		{
			pData[playerid][pJailTime]--;
			new mstr[128];
			format(mstr, sizeof(mstr), "~b~~h~You will be unjail in ~w~%d ~b~~h~seconds.", pData[playerid][pJailTime]);
			InfoTD_MSG(playerid, 1000, mstr);
		}
		else
		{
			pData[playerid][pJail] = 0;
			pData[playerid][pJailTime] = 0;
			//SpawnPlayer(playerid);
			SetPlayerPositionEx(playerid, 1482.0356,-1724.5726,13.5469,750, 2000);
			SetPlayerInterior(playerid, 0);
			SetPlayerVirtualWorld(playerid, 0);
			SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
			SendClientMessageToAllEx(COLOR_PINK, "Server: "GREY2_E" %s(%d) have been un-jailed by the server. (times up)", pData[playerid][pName], playerid);
		}
	}
	//Arreset Player
	if(pData[playerid][pArrest] > 0)
	{
		if(pData[playerid][pArrestTime] > 0)
		{
			pData[playerid][pArrestTime]--;
			new mstr[128];
			format(mstr, sizeof(mstr), "~b~~h~You will be released in ~w~%d ~b~~h~seconds.", pData[playerid][pArrestTime]);
			InfoTD_MSG(playerid, 1000, mstr);
		}
		else
		{
			pData[playerid][pArrest] = 0;
			pData[playerid][pArrestTime] = 0;
			//SpawnPlayer(playerid);
			SetPlayerPositionEx(playerid, 1555.3, -1675.69, 16.1953, 87.1144, 2000);
			SetPlayerInterior(playerid, 0);
			SetPlayerVirtualWorld(playerid, 0);
			SetPlayerSpecialAction(playerid, SPECIAL_ACTION_NONE);
			Info(playerid, "You have been auto release. (times up)");
		}
	}
}

CMD:pos(playerid, params[])
{
	if(pData[playerid][pAdmin] < 1)
		if(pData[playerid][pHelper] == 0)
			return PermissionError(playerid);

	new Float: x, Float: y, Float: z, interior, virtual_world;

	if(sscanf(params, "P<,>fff", x, y, z))
		return SendClientMessage(playerid, 0xCECECEFF, "Gunakan: /pos [x y z]");

	sscanf(params, "P<,>{fff}dd", interior, virtual_world);

	SetPlayerPosition(playerid, x, y, z, interior, virtual_world);
	return 1;
}
DCMD:setcs(user, channel, params[])
{
	if(channel == acss)
	{
		if(sscanf(params, "s[64]", params[0])) return DCC_SendChannelMessage(channel, "**GUNAKAN: !accs [Names]**");
		new queen[266];
		format(queen, sizeof(queen), "cs/%s.txt", params[0]);
		if(dini_Exists(queen))
		{
		    DCC_SendChannelMessage(channel, "__***The name is already at the database***__");
		}
		else
		{
			new Kj[256];
		    format(Kj, sizeof(Kj), "cs/%s.txt", params[0]);
		    dini_Create(Kj);
			new query[256];
			format(query, sizeof(query), "**```%s succesfully registered in the Character Story database, Happy Roleplay```**", params[0]);
			DCC_SendChannelMessage(channel, query);
			/*new DCC_Guild:guild, DCC_Role:verified, DCC_Role:warga;
			verified = DCC_FindRoleById("947143914199068729");
			warga = DCC_FindRoleById("947143914199068731");
			DCC_GetChannelGuild(channel, guild);
			DCC_SetGuildMemberNickname(guild, user, params);
			DCC_AddGuildMemberRole(guild, user, verified);
			DCC_AddGuildMemberRole(guild, user, warga);*/
		}
	}
	else
	{
		return DCC_SendChannelMessage(channel, "***__You are not on the register channel Character Story__***");
	}
	return 1;
}
DCMD:register(user, channel, params[])
{
	if(channel == ucp)
	{
		if(sscanf(params, "s[64]", params[0])) return DCC_SendChannelMessage(channel, "**GUNAKAN: !register [Whitelist Names]**");
		new queen[266];
		format(queen, sizeof(queen), "whitelist/%s.txt", params[0]);
		if(dini_Exists(queen))
		{
		    DCC_SendChannelMessage(channel, "__***The name is already at the database***__");
		}
		else
		{
			new Kj[256];
		    format(Kj, sizeof(Kj), "Whitelist/%s.txt", params[0]);
		    dini_Create(Kj);
			new query[256];
			format(query, sizeof(query), "**```\n%s Kamu berhasil mendaftar anjay```**", params[0]);
			DCC_SendChannelMessage(channel, query);
			//DCC_SetBotActivity("Registering People...");
        	DCC_SetBotPresenceStatus(DO_NOT_DISTURB);
			/*new DCC_Guild:guild, DCC_Role:verified, DCC_Role:warga;
			verified = DCC_FindRoleById("947143914199068729");
			warga = DCC_FindRoleById("947143914199068731");
			DCC_GetChannelGuild(channel, guild);
			DCC_SetGuildMemberNickname(guild, user, params);
			DCC_AddGuildMemberRole(guild, user, verified);
			DCC_AddGuildMemberRole(guild, user, warga);*/
		}
	}
	else
	{
		return DCC_SendChannelMessage(channel, "***__You are not on the register channel Whitelist <#1002992180199170078>__***");
	}
	return 1;
}

//trasher
public FillTrash(id)
{
	TrashData[id][TrashLevel]++;
	if(TrashData[id][TrashType] == TYPE_BIN && TrashData[id][TrashLevel] > 1) TrashData[id][TrashLevel] = 1;

	if(TrashData[id][TrashType] == TYPE_DUMPSTER) {
		if(TrashData[id][TrashLevel] == 1) TrashData[id][TrashTimer] = SetTimerEx("FillTrash", REFILL_TIME * 1000, false, "i", id);
		if(TrashData[id][TrashLevel] >= 2)
		{
			TrashData[id][TrashLevel] = 2;
			KillTimer(TrashData[id][TrashTimer]);
			TrashData[id][TrashTimer] = -1;
		}

		Streamer_SetIntData(STREAMER_TYPE_3D_TEXT_LABEL, TrashData[id][TrashLabel], E_STREAMER_COLOR, (TrashData[id][TrashLevel] == 1) ? 0xF39C12FF : 0x2ECC71FF);
		return 1;
	}

	Streamer_SetIntData(STREAMER_TYPE_3D_TEXT_LABEL, TrashData[id][TrashLabel], E_STREAMER_COLOR, 0x2ECC71FF);
	return 1;
}
CMD:pickup(playerid, params[])
{
	if(IsPlayerInAnyVehicle(playerid)) return Error(playerid, "You can't do at this moment.");
	new vehicleid = GetPVarInt(playerid, "LastVehicleID");
	if(GetVehicleModel(vehicleid) != 408) return Error(playerid, "Your last vehicle has to be a Trashmaster.");
    if(HasTrash[playerid]) return Error(playerid, "You're already carrying a trash bag.");
	new id = Trash_Closest(playerid);
	if(id == -1) return Error(playerid, "You're not near any trash.");
	if(TrashData[id][TrashLevel] < 1) return Error(playerid, "There's nothing here.");
    new Float: x, Float: y, Float: z;
    GetVehicleBoot(vehicleid, x, y, z);
    if(GetPlayerDistanceFromPoint(playerid, x, y, z) >= 30.0) return Error(playerid, "You're not near your Trashmaster.");
	TrashData[id][TrashLevel]--;
	KillTimer(TrashData[id][TrashTimer]);
    TrashData[id][TrashTimer] = SetTimerEx("FillTrash", REFILL_TIME * 1000, false, "i", id);
	TrashCP[playerid] = CreateDynamicCP(x, y, z, 3.0, .playerid = playerid);
	HasTrash[playerid] = true;
	ApplyAnimation(playerid, "CARRY", "liftup105", 4.1, 0, 0, 0, 0, 0);
	SetPlayerAttachedObject(playerid, ATTACHMENT_INDEX, 1264, 6, 0.222, 0.024, 0.128, 1.90, -90.0, 0.0, 0.5,0.5, 0.5);

	Streamer_SetIntData(STREAMER_TYPE_3D_TEXT_LABEL, TrashData[id][TrashLabel], E_STREAMER_COLOR, (TrashData[id][TrashLevel] == 0) ? 0xE74C3CFF : 0xF39C12FF);
	SendClientMessage(playerid, COLOR_JOB, "TRASHMASTER: {FFFFFF}You can press {FFFF00}N {FFFFFF}to remove the trash bag.");
	return 1;
}
CMD:trash(playerid)
{
	new id = Trash_Closest(playerid);
	if(id == -1) return Error(playerid, "You're not near any trash.");
	if(TrashData[id][TrashLevel] < 1) return Error(playerid, "There's nothing here.");
    if(pData[playerid][pTrash] < 10)
		return Error(playerid, "Kamu tidak mempunyai 10 sampah di inventory mu!");

	PlayerTextDrawSetString(playerid, ITEMSNAME[playerid], "Trash");
	PlayerTextDrawSetString(playerid, Received[playerid], "Drop");
	PlayerTextDrawSetPreviewModel(playerid, MODELITEM[playerid], 2840);
	PlayerTextDrawShow(playerid, ITEMSBOX[0][playerid]);
	PlayerTextDrawShow(playerid, ITEMSBOX[1][playerid]);
	PlayerTextDrawShow(playerid, Received[playerid]);
	PlayerTextDrawShow(playerid, ITEMSNAME[playerid]);
	PlayerTextDrawShow(playerid, MODELITEM[playerid]);
	PlayerTextDrawSetString(playerid, Loading[2][playerid], "Membuang");
	for(new i =0 ; i < 3; i++)
	{
		PlayerTextDrawShow(playerid, Loading[i][playerid]);
	}
	SetTimerEx("ItemsBoxtimer", 5500, false, "i", playerid);
	pData[playerid][pActivity] = SetTimerEx("LoadingTrash", 500, true, "i", playerid);
	ApplyAnimation(playerid,"BD_FIRE","wash_up",4.0, 1, 0, 0, 0, 0, 1);
	return 1;
}
CMD:getmeat(playerid, params[])
{
	if(IsPlayerInAnyVehicle(playerid)) return Error(playerid, "You can't do at this moment.");

    if(GetMeatBag[playerid]) return Error(playerid, "You're already put a meat bag.");

	StoremeatCP[playerid] = CreateDynamicCP(942.3542, 2117.8999, 1011.0303, 3.0, .playerid = playerid);
	GetMeatBag[playerid] = true;
	ApplyAnimation(playerid, "CARRY", "liftup105", 4.1, 0, 0, 0, 0, 0);
	SetPlayerAttachedObject(playerid, ATTACHMENT_INDEX, 2805, 6, 0.222, 0.024, 0.128, 1.90, -90.0, 0.0, 0.5,0.5, 0.5);
	Meat--;
	Server_Save();
	return 1;
}
CMD:cu(playerid, params[])
{
    //for(new idx = 0; idx < MAX_TELEPON; idx ++)
	{
	    if(IsPlayerInRangeOfPoint(playerid,5.0,1773.6583, -1015.3002, 23.9609) || IsPlayerInRangeOfPoint(playerid,5.0,1254.7303, -2059.5728, 59.5827))
		{
		    GivePlayerMoneyEx(playerid, -5);
			new ph;

			if(sscanf(params, "d", ph))
			{
				Usage(playerid, "/cu [phone number] 933 - Taxi Call | 911 - SAPD Crime Call | 922 - SAMD Medic Call");
				foreach(new ii : Player)
				{
					if(pData[ii][pMechDuty] == 1)
					{
						SendClientMessageEx(playerid, COLOR_GREEN, "Mekanik Duty: %s | PH: [%d]", ReturnName(ii), pData[ii][pPhone]);
					}
				}
				return 1;
			}
			if(ph == 911)
			{
				if(pData[playerid][pCallTime] >= gettime())
					return Error(playerid, "You must wait %d seconds before sending another call.", pData[playerid][pCallTime] - gettime());

				new Float:x, Float:y, Float:z;
				GetPlayerPos(playerid, x, y, z);
				Info(playerid, "Warning: This number for emergency crime only! please wait for SAPD respon!");
				SendFactionMessage(1, COLOR_BLUE, "[EMERGENCY CALL] "WHITE_E"%s calling the emergency crime! Ph: ["GREEN_E"Telp Umum"WHITE_E"] | Location: %s", ReturnName(playerid), pData[playerid][pPhone], GetLocation(x, y, z));

				pData[playerid][pCallTime] = gettime() + 60;
			}
			if(ph == 922)
			{
				if(pData[playerid][pCallTime] >= gettime())
					return Error(playerid, "You must wait %d seconds before sending another call.", pData[playerid][pCallTime] - gettime());

				new Float:x, Float:y, Float:z;
				GetPlayerPos(playerid, x, y, z);
				Info(playerid, "Warning: This number for emergency medical only! please wait for SAMD respon!");
				SendFactionMessage(3, COLOR_PINK2, "[EMERGENCY CALL] "WHITE_E"%s calling the emergency medical! Ph: ["GREEN_E"Telp Umum"WHITE_E"] | Location: %s", ReturnName(playerid), pData[playerid][pPhone], GetLocation(x, y, z));

				pData[playerid][pCallTime] = gettime() + 60;
			}
			if(ph == 933)
			{
				if(pData[playerid][pCallTime] >= gettime())
					return Error(playerid, "You must wait %d seconds before sending another call.", pData[playerid][pCallTime] - gettime());

				new Float:x, Float:y, Float:z;
				GetPlayerPos(playerid, x, y, z);
				Info(playerid, "Your calling has sent to the taxi driver. please wait for respon!");
				pData[playerid][pCallTime] = gettime() + 60;
				foreach(new tx : Player)
				{
					if(pData[tx][pJob] == 1 || pData[tx][pJob2] == 1)
					{
						SendClientMessageEx(tx, COLOR_PINK, "[TAXI CALL] "WHITE_E"%s calling the taxi for order! Ph: ["GREEN_E"Telp Umum"WHITE_E"] | Location: %s", ReturnName(playerid), pData[playerid][pPhone], GetLocation(x, y, z));
					}
				}
			}
			if(ph == 511)
			{
				if(pData[playerid][pCallTime] >= gettime())
					return Error(playerid, "You must wait %d seconds before sending another call.", pData[playerid][pCallTime] - gettime());

				new Float:x, Float:y, Float:z;
				GetPlayerPos(playerid, x, y, z);
				Info(playerid, "Your calling has sent to the gojek driver. please wait for respon!");
				pData[playerid][pCallTime] = gettime() + 60;
				foreach(new tx : Player)
				{
					if(pData[tx][pFaction] == 5)
					{
						SendClientMessageEx(tx, COLOR_PINK, "[GOJEK CALL] "WHITE_E"%s calling the gojek for order! Ph: ["GREEN_E"Telp Umum"WHITE_E"] | Location: %s", ReturnName(playerid), pData[playerid][pPhone], GetLocation(x, y, z));
					}
				}
			}
			if(ph == pData[playerid][pPhone]) return Error(playerid, "Nomor sedang sibuk!");
			foreach(new ii : Player)
			{
				if(pData[ii][pPhone] == ph)
				{
					if(pData[ii][IsLoggedIn] == false || !IsPlayerConnected(ii)) return Error(playerid, "This number is not actived!");

					if(pData[ii][pCall] == INVALID_PLAYER_ID)
					{
						pData[playerid][pCall] = ii;

						SendClientMessageEx(playerid, COLOR_PINK, "[CELLPHONE to %d] "WHITE_E"phone begins to ring, please wait for answer!", ph);
						SendClientMessageEx(ii, COLOR_PINK, "[CELLPHONE form %d] "WHITE_E"Your phonecell is ringing, type '/p' to answer it!", pData[playerid][pPhone]);
						PlayerPlaySound(playerid, 3600, 0,0,0);
						PlayerPlaySound(ii, 6003, 0,0,0);
						SetPlayerSpecialAction(playerid, SPECIAL_ACTION_USECELLPHONE);
						SendNearbyMessage(playerid, 20.0, COLOR_PURPLE, "* %s takes out a cellphone and calling someone.", ReturnName(playerid));
						return 1;
					}
					else
					{
						Error(playerid, "Nomor ini sedang sibuk.");
						return 1;
					}
				}
			}
		}
	}

	return 1;
}

public OnVehicleSirenStateChange(playerid, vehicleid, newstate)
{
        if(newstate)
        {
            FlashTime[vehicleid] = SetTimerEx("OnLightFlash", flashtime, true, "d", vehicleid);
        }
        if(!newstate)
        {
        	new panels, doors, lights, tires;

			KillTimer(FlashTime[vehicleid]);

			GetVehicleDamageStatus(vehicleid, panels, doors, lights, tires);
            UpdateVehicleDamageStatus(vehicleid, panels, doors, 0, tires);
        }
        return 1;
}

public DoGMX()
{
	SendRconCommand("gmx");
	return 1;
}

public OnPlayerEnterDynamicArea(playerid, areaid)
{
	//BLUEZONE
	Zone_OnPlayerEnterDynamicArea(playerid, areaid);
	//butcher
    if(areaid == meatsp)
	{
	    if(!GetPVarInt(playerid,"OnWork"))
	    {
	    	ShowPlayerDialog(playerid,D_WORK,DIALOG_STYLE_MSGBOX,"Butcher Job","Do you want to start working on the Assembly line?","Yes","");
	    }
	    else ShowPlayerDialog(playerid,D_WORK,DIALOG_STYLE_MSGBOX,"Butcher Job","Do you want to finish working on the Assembly line?","Yes","");
	}
    foreach(new i : Player)
	{
	    if(GetPVarType(i, "BBArea"))
	    {
	        if(areaid == GetPVarInt(i, "BBArea"))
	        {
	            new station[256];
	            GetPVarString(i, "BBStation", station, sizeof(station));
	            if(!isnull(station))
				{
					PlayStream(playerid, station, GetPVarFloat(i, "BBX"), GetPVarFloat(i, "BBY"), GetPVarFloat(i, "BBZ"), 30.0, 1);
				 	Servers(playerid, "You Enter The Boombox Area");
	            }
				return 1;
	        }
	    }
	}
	return 1;
}
forward OnSecondTimer();
public OnSecondTimer()
{
	new minute;
	gettime(_, minute);

	foreach(new playerid : Player)
	{
		CallLocalFunction("OnPlayerTimer", "i", playerid);
	}
}

forward OnPlayerTimer(playerid);
public OnPlayerTimer(playerid)
{
	if(pData[playerid][IsLoggedIn] == true)
	{	
		if(pData[playerid][pJob] == 8 || pData[playerid][pJob2] == 8)
		{
			if(packet == 1)
			{
				pData[playerid][pSmugglerTimer]++;

				if(pData[playerid][pSmugglerTimer] == 25)
					SendClientMessage(playerid, COLOR_LOGS, "JOB: {FFFFFF}Smuggling job is currently active!, use "YELLOW_E"'/findpacket'"WHITE_E" to trace the package"),
					pData[playerid][pSmugglerTimer] = 0;
			}
		}
		if(pData[playerid][pJob] == 8 || pData[playerid][pJob2] == 8)
		{
			if(packet == 2)
			{
				pData[playerid][pSmugglerTimer]++;

				if(pData[playerid][pSmugglerTimer] == 25)
					SendClientMessage(playerid, COLOR_LOGS, "JOB: {FFFFFF}Smuggling job is currently active!, use "YELLOW_E"'/findpacket'"WHITE_E" to trace the package"),
					pData[playerid][pSmugglerTimer] = 0;
			}
		}
	}
    return 1;
}

forward OnMinuteTimer();
public OnMinuteTimer()
{
	new hour, minute, second;
	gettime(hour, minute, second);

//	UpdateBet();

	switch(minute)
	{
		case 0:
		{
			if(hour == 0 && taked == 0)
		    {
		        DestroyDynamicObject(objectpacket);
		        packet = 2;
		        objectpacket = CreateDynamicObject(11745, -127.492500, 2258.050048, 28.337009-1, 0.0, 0.0, 0.0, 0);
		        taked = 0;
		    }
			
			if(hour == 1 && taked == 0)
		    {
		        DestroyDynamicObject(objectpacket);
		        packet = 1;
		        objectpacket = CreateDynamicObject(11745, -1304.212036, 2525.925537, 87.532722-1, 0.0, 0.0, 0.0, 0);
		        taked = 0;
		    }
		    
		    if(hour == 2 && taked == 0)
		    {
		        DestroyDynamicObject(objectpacket);
		        packet = 1;
		        objectpacket = CreateDynamicObject(11745, -1304.212036, 2525.925537, 87.532722-1, 0.0, 0.0, 0.0, 0);
		        taked = 0;
		    }
		    
		    if(hour == 7 && taked == 0)
		    {
		        DestroyDynamicObject(objectpacket);
		        packet = 2;
		        objectpacket = CreateDynamicObject(11745, -127.492500, 2258.050048, 28.337009-1, 0.0, 0.0, 0.0, 0);
		        taked = 0;
		    }
		    
		    if(hour == 8 && taked == 0)
		    {
		        DestroyDynamicObject(objectpacket);
		        packet = 1;
		        objectpacket = CreateDynamicObject(11745, -1304.212036, 2525.925537, 87.532722-1, 0.0, 0.0, 0.0, 0);
		        taked = 0;
		    }
		    
		    if(hour == 10 && taked == 0)
		    {
		        DestroyDynamicObject(objectpacket);
		        packet = 1;
		        objectpacket = CreateDynamicObject(11745, -1304.212036, 2525.925537, 87.532722-1, 0.0, 0.0, 0.0, 0);
		        taked = 0;
		    }

            if(hour == 11 && taked == 0)
		    {
		        DestroyDynamicObject(objectpacket);
		        packet = 2;
		        objectpacket = CreateDynamicObject(11745, -127.492500, 2258.050048, 28.337009-1, 0.0, 0.0, 0.0, 0);
		        taked = 0;
		    }
		    
		    if(hour == 13 && taked == 0)
		    {
		        DestroyDynamicObject(objectpacket);
		        packet = 2;
		        objectpacket = CreateDynamicObject(11745, -127.492500, 2258.050048, 28.337009-1, 0.0, 0.0, 0.0, 0);
		        taked = 0;
		    }
		    
		    if(hour == 15 && taked == 0)
		    {
		        DestroyDynamicObject(objectpacket);
		        packet = 2;
		        objectpacket = CreateDynamicObject(11745, -127.492500, 2258.050048, 28.337009-1, 0.0, 0.0, 0.0, 0);
		        taked = 0;
		    }
		    
		    if(hour == 17 && taked == 0)
		    {
		        DestroyDynamicObject(objectpacket);
		        packet = 1;
		        objectpacket = CreateDynamicObject(11745, -1304.212036, 2525.925537, 87.532722-1, 0.0, 0.0, 0.0, 0);
		        taked = 0;
		    }
		    
		    if(hour == 20 && taked == 0)
		    {
		        DestroyDynamicObject(objectpacket);
		        packet = 1;
		        objectpacket = CreateDynamicObject(11745, -1304.212036, 2525.925537, 87.532722-1, 0.0, 0.0, 0.0, 0);
		        taked = 0;
		    }
		}
	 	case 30:
		{
		    if(hour == 4 && taked == 0)
		    {
				DestroyDynamicObject(objectpacket);
		        packet = 1;
		        objectpacket = CreateDynamicObject(11745, -1304.212036, 2525.925537, 87.532722-1, 0.0, 0.0, 0.0, 0);
		        taked = 0;
		    }
		}
		case 20:
		{
		    if(hour == 12 && taked == 0)
		    {
		        DestroyDynamicObject(objectpacket);
		        packet = 2;
		        objectpacket = CreateDynamicObject(11745, -127.492500, 2258.050048, 28.337009-1, 0.0, 0.0, 0.0, 0);
		        taked = 0;
		    }
		}
		case 22:
		{
      		if(hour == 21 && taked == 0)
		    {
		        DestroyDynamicObject(objectpacket);
		        packet = 1;
		        objectpacket = CreateDynamicObject(11745, -1304.212036, 2525.925537, 87.532722-1, 0.0, 0.0, 0.0, 0);
		        taked = 0;
		    }
		}
		case 40:
		{
		    if(hour == 4)
		    {
		        new msg[500];
		        format(msg, sizeof(msg), "**BOT Pengingat Sholat\nAssalamualaikum Semuanya Warga Capitaliz Roleplay\nBagi Yang Ber Agama Islam Jangan Lupa Sholat Subuh Yaa!\nSekarang Sudah Jam %d:%02d WIB\n@everyone**", hour, minute);
	    		DCC_SendChannelMessage(g_discord_logs, msg);
		    }
		}
		case 9:
		{
		    if(hour == 12)
		    {
		        new msg[500];
		        format(msg, sizeof(msg), "**BOT Pengingat Sholat\nAssalamualaikum Semuanya Warga Capitaliz Roleplay\nBagi Yang Ber Agama Islam Jangan Lupa Sholat Dzuhur Yaa!\nSekarang Sudah Jam %d:%02d WIB\n@everyone**", hour, minute);
	    		DCC_SendChannelMessage(g_discord_logs, msg);
		    }
		}
		case 25:
		{
		    if(hour == 15)
		    {
		        new msg[500];
		        format(msg, sizeof(msg), "**BOT Pengingat Sholat\nAssalamualaikum Semuanya Warga Capitaliz Roleplay\nBagi Yang Ber Agama Islam Jangan Lupa Sholat Ashar Yaa!\nSekarang Sudah Jam %d:%02d WIB\n@everyone**", hour, minute);
	    		DCC_SendChannelMessage(g_discord_logs, msg);
		    }
		    else if(hour == 19)
		    {
		        new msg[500];
		        format(msg, sizeof(msg), "**BOT Pengingat Sholat\nAssalamualaikum Semuanya Warga Capitaliz Roleplay\nBagi Yang Ber Agama Islam Jangan Lupa Sholat Isya Yaa!\nSekarang Sudah Jam %d:%02d WIB\n@everyone**", hour, minute);
	    		DCC_SendChannelMessage(g_discord_logs, msg);
		    }
		}
		case 15:
		{
		    if(hour == 18)
		    {
		        new msg[500];
		        format(msg, sizeof(msg), "**BOT Pengingat Sholat\nAssalamualaikum Semuanya Warga Capitaliz Roleplay\nBagi Yang Ber Agama Islam Jangan Lupa Sholat Maghrib Yaa!\nSekarang Sudah Jam %d:%02d WIB\n@everyone**", hour, minute);
	    		DCC_SendChannelMessage(g_discord_logs, msg);
		    }
		}
	}

	SetWorldTime(WorldTime);
	OnPlayersWorldTimeInit(hour, minute);

	return 1;
}

forward OnPlayersWorldTimeInit(hour, minute);
public OnPlayersWorldTimeInit(hour, minute)
{
	foreach(new playerid : Player)
	{
		SetPlayerTime(playerid, hour, minute);
	}
}

forward Packet(packetid);
public Packet(packetid)
{
	switch(packetid)
	{
		case 1:
		{
		    DestroyDynamicObject(objectpacket);
		    packet = 1;
		    objectpacket = CreateDynamicObject(11745, -1304.212036, 2525.925537, 87.532722-1, 0.0, 0.0, 0.0, 0);
		    taked = 0;
		}
		case 2:
		{
		    DestroyDynamicObject(objectpacket);
	        packet = 2;
	        objectpacket = CreateDynamicObject(11745, -127.492500, 2258.050048, 28.337009-1, 0.0, 0.0, 0.0, 0);
	        taked = 0;
		}
	}
}

public OnPlayerLeaveDynamicArea(playerid, areaid)
{
	//BLUEZONE
	Zone_OnPlayerLeaveDynamicArea(playerid, areaid);
	//
    foreach(new i : Player)
	{
	    if(GetPVarType(i, "BBArea"))
	    {
	        if(areaid == GetPVarInt(i, "BBArea"))
	        {
	            StopStream(playerid);
	            Servers(playerid, "You Has Been Leave Boombox Area");
				return 1;
	        }
	    }
	}
	return 1;
}

forward splits(const strsrc[], strdest[][], delimiter);
public splits(const strsrc[], strdest[][], delimiter)
{
	new i, li;
	new aNum;
	new len;
	while(i <= strlen(strsrc)){
		if(strsrc[i]==delimiter || i==strlen(strsrc)){
			len = strmid(strdest[aNum], strsrc, li, i, 128);
			strdest[aNum][len] = 0;
			li = i+1;
			aNum++;
		}
		i++;
	}
	return 1;
}

CMD:setskill(playerid, params[])
{
	new choice[128], String[50], giveplayerid, amount;
	if(sscanf(params, "s[128]dd", choice, giveplayerid, amount))
	{
		SendClientMessageEx(playerid, COLOR_PINK, "USE: /setskill [trucker, mechanic, smuggler] [playerid] [amount]");
		return 1;
	}
	if(strcmp(choice, "mechanic", true) == 0)
	{
		pData[giveplayerid][pMechSkill] = amount;
		format(String, sizeof(String), "SKILLINFO: You've set %s mechanic Skill to Level %d", pData[giveplayerid][pName], amount);

		SendClientMessage(playerid, COLOR_PINK, String);
	}
	else if(strcmp(choice, "trucker", true) == 0)
	{
		pData[giveplayerid][pTruckSkill] = amount;
		format(String, sizeof(String), "SKILLINFO: You've set %s trucker Skill to Level %d", pData[giveplayerid][pName], amount);

		SendClientMessage(playerid, COLOR_PINK, String);
	}
	else if(strcmp(choice, "smuggler", true) == 0)
	{
		pData[giveplayerid][pSmuggSkill] = amount;
		format(String, sizeof(String), "SKILLINFO: You've set %s smuggler Skill to Level %d", pData[giveplayerid][pName], amount);

		SendClientMessage(playerid, COLOR_PINK, String);
	}
	return 1;
}
ptask AfkCheck[1000](playerid)  
{
	new str[300];
    if(p_tick[playerid] > 0) 
    {
        p_tick[playerid] = 0, p_afktime[playerid] = 0;
        return 1;
    }
    if(p_tick[playerid] == 0) 
    {
        p_afktime[playerid]++;
    }
    new afk_minutes = ConvertUnixTime(p_afktime[playerid], CONVERT_TIME_TO_MINUTES);
	new afk_seconds = ConvertUnixTime(p_afktime[playerid]);

	if(afk_minutes > 0)
	{
		format(str, sizeof str, "[ATIP] %d:%02d Minute(s).", afk_minutes, afk_seconds);
	}
	else format(str, sizeof str, "[ATIP] %d Seconds(s).", afk_seconds);
	if(pData[playerid][pMaskOn] == 0)
	{
		SetPlayerChatBubble(playerid, str, COLOR_SYSTEM, 10.0, 1000);		
	}
    return 1;
}
stock ConvertUnixTime(unix_time, type = CONVERT_TIME_TO_SECONDS)
{
	switch(type)
	{
		case CONVERT_TIME_TO_SECONDS:
		{
			unix_time %= 60;
		}
		case CONVERT_TIME_TO_MINUTES:
		{
			unix_time = (unix_time / 60) % 60;
		}
		case CONVERT_TIME_TO_HOURS:
		{
			unix_time = (unix_time / 3600) % 24;
		}
		case CONVERT_TIME_TO_DAYS:
		{
			unix_time = (unix_time / 86400) % 30;
		}
		case CONVERT_TIME_TO_MONTHS:
		{
			unix_time = (unix_time / 2629743) % 12;
		}
		case CONVERT_TIME_TO_YEARS:
		{
			unix_time = (unix_time / 31556926) + 1970;
		}
		default:
			unix_time %= 60;
	}
	return unix_time;
}

function MoveShip()
{
	ship_pos_id++;

	if(ship_pos_id == sizeof ship_positions) ship_pos_id = 0;

	switch(ship_pos_id)
	{
	    case 0: UpdateShip3DText("Kapal:\nMendekati tepi pelabuhan LS");
	    case 3: UpdateShip3DText("Kapal:\nMenunggu pengiriman ke pelabuhan pekerja industri minyak");
	    case 4: UpdateShip3DText("Kapal:\nBerlayar ke pelabuhan pekerja industri minyak");
	    case 5: UpdateShip3DText("Kapal:\nMendekati pantai pelabuhan pekerja industri minyak");
	    case 6: UpdateShip3DText("Kapal:\nMenunggu dikirim ke pelabuhan LS");
	    case 7: UpdateShip3DText("Kapal:\nBerlayar ke pelabuhan LS");
	}

	if(ship_positions[ship_pos_id][0] != 0.0)
	{
		ship_move_time = MoveObject(ship_mid_object,
			ship_positions[ship_pos_id][0], ship_positions[ship_pos_id][1], ship_positions[ship_pos_id][2] + 10.0, //- 0.004,
			12.0,
			ship_positions[ship_pos_id][3], ship_positions[ship_pos_id][4], ship_positions[ship_pos_id][5]);
	}
	else ship_move_time = 30 * 100;

	return SetTimer("MoveShip", ship_move_time, false);
}

stock UpdateShip3DText(text[])
{
	for(new i; i < 2; i++) UpdateDynamic3DTextLabelText(ship_3d[i], -1, text);
}

stock CreateShip()
{
    new objectsship[11];

	new Float: ship_start_pos[][] =
	{
	    {2560.034912, -2632.026367, 7.039000, 0.000000, 0.000007, 0.000000},
	    {2555.903076, -2632.779296, 7.899000, 0.000007, 0.000000, 89.999977},
		{2555.582031, -2631.939941, 7.038000, 0.000000, 0.000007, 0.000000},
		{2563.015380, -2666.564453, 10.213899, 0.000000, 0.000007, 0.000000},
		{2550.206787, -2661.585937, 10.213899, -0.000007, -0.000000, -89.999977},
		{2561.179931, -2606.847900, 9.928000, 0.000000, -0.000007, 179.999954},
		{2561.179931, -2625.447021, 9.928000, 0.000000, -0.000007, 179.994461},
		{2561.179931, -2644.101074, 9.928000, 0.000000, -0.000007, 179.994461},
		{2553.453857, -2609.960937, 9.928000, -0.000000, 0.000007, -0.005493},
		{2553.453857, -2628.729003, 9.928000, -0.000000, 0.000007, -0.010986},
		{2553.453857, -2647.277099, 9.928000, -0.000000, 0.000007, -0.010986}
	};

    objectsship[0] = CreateObject(19545, 2560.034912, -2632.026367, 7.039000, 0.000000, 0.000000, 0.000000, 300.00); // kk

    objectsship[1] = CreateObject(10230, 2555.903076, -2632.779296, 7.899000, 0.000007, 0.000000, 89.999977, 300.00); // kk

	objectsship[2] = CreateObject(19545, 2555.582031, -2631.939941, 7.038000, 0.000000, 0.000007, 0.000000, 300.00); // kk
	objectsship[3] = CreateObject(13025, 2563.015380, -2666.564453, 10.213899, 0.000000, 0.000007, 0.000000, 300.00); // kk
	objectsship[4] = CreateObject(13025, 2550.206787, -2661.585937, 10.213899, -0.000007, -0.000000, -89.999977, 300.00); // kk
	objectsship[5] = CreateObject(3637, 2561.179931, -2606.847900, 9.928000, 0.000000, -0.000007, 179.999954, 300.00); // kk
	objectsship[6] = CreateObject(3637, 2561.179931, -2625.447021, 9.928000, 0.000000, -0.000007, 179.994461, 300.00); // kk
	objectsship[7] = CreateObject(3637, 2561.179931, -2644.101074, 9.928000, 0.000000, -0.000007, 179.994461, 300.00); // kk
	objectsship[8] = CreateObject(3637, 2553.453857, -2609.960937, 9.928000, -0.000000, 0.000007, -0.005493, 300.00); // kk
	objectsship[9] = CreateObject(3637, 2553.453857, -2628.729003, 9.928000, -0.000000, 0.000007, -0.010986, 300.00); // kk
	objectsship[10] = CreateObject(3637, 2553.453857, -2647.277099, 9.928000, -0.000000, 0.000007, -0.010986, 300.00); // kk

    for(new i; i < 11; i++)
    {
        if(i > 0)
		{
		    printf("[%i] %f, %f, %f, %f, %f, %f",
				i,
				ship_start_pos[i][0] - ship_start_pos[0][0],
				ship_start_pos[i][1] - ship_start_pos[0][1],
				ship_start_pos[i][2] - ship_start_pos[0][2],
				0.0,
				0.0,
				ship_start_pos[i][5]);

			AttachObjectToObject(objectsship[i], objectsship[0],
				ship_start_pos[i][0] - ship_start_pos[0][0],
				ship_start_pos[i][1] - ship_start_pos[0][1],
				ship_start_pos[i][2] - ship_start_pos[0][2],
				0.0,
				0.0,
				ship_start_pos[i][5],
				1);
		}
    }

    return objectsship[0];
}

function PlayerEndRepairShip(playerid)
{
	SCM(playerid, COLOR_GREEN, "Ditambahkan ke gaji: $65.00");
	SCM(playerid, -1, "Pergi dan dapatkan minyak.");

    //pTemp[playerid][pWorkSalary] += 2305;
    //GivePlayerMoneyEx(playerid, 2305, "menara minyak"); //TEST

	AddPlayerSalary(playerid, "Oil(Jobs)", 2500);
	Info(playerid, "Oil(Jobs) telah masuk ke pending salary anda!");

	ClearAnimations(playerid);

	TogglePlayerControllable(playerid, true);

	return 1;
}


stock RefreshVModel(playerid)
{
	PlayerTextDrawSetPreviewModel(playerid, VModelTD[playerid], GetVehicleModel(GetPlayerVehicleID(playerid)));
	PlayerTextDrawShow(playerid, VModelTD[playerid]);
    return 1;
}

stock RefreshPSkin(playerid)
{
	PlayerTextDrawSetPreviewModel(playerid, PSkinStats[playerid], GetPlayerSkin(playerid));
	PlayerTextDrawShow(playerid, PSkinStats[playerid]);
    return 1;
}




public OnPlayerSelectionMenuResponse(playerid, extraid, response, listitem, modelid)
{
	switch(extraid)
	{
		case SPAWN_SKIN_MALE:
		{
			if(response)
			{
				pData[playerid][pSkin] = modelid;
				SetSpawnInfo(playerid, 0, pData[playerid][pSkin], 1744.3411, -1862.8655, 13.3983, 270.0000, 0, 0, 0, 0, 0, 0);
				SpawnPlayer(playerid);
				UpdatePlayerData(playerid);
				RefreshPSkin(playerid);
			}
		}
		case SPAWN_SKIN_FEMALE:
		{
			if(response)
			{
				pData[playerid][pSkin] = modelid;
				SetSpawnInfo(playerid, 0, pData[playerid][pSkin], 1744.3411, -1862.8655, 13.3983, 270.0000, 0, 0, 0, 0, 0, 0);
				SpawnPlayer(playerid);
				UpdatePlayerData(playerid);
				RefreshPSkin(playerid);
			}
		}
		case SHOP_SKIN_MALE:
	    {
	        if(response)
	        {
				new bizid = pData[playerid][pInBiz], price;
				price = bData[bizid][bP][0];
				pData[playerid][pSkin] = modelid;
				SetPlayerSkin(playerid, modelid);
				GivePlayerMoneyEx(playerid, -price);
				SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s telah membeli skin ID %d seharga %s.", ReturnName(playerid), modelid, FormatMoney(price));
				bData[bizid][bProd]--;
				bData[bizid][bMoney] += Server_Percent(price);
				Server_AddPercent(price);
				
				new query[128];
				mysql_format(g_SQL, query, sizeof(query), "UPDATE bisnis SET prod='%d', money='%d' WHERE ID='%d'", bData[bizid][bProd], bData[bizid][bMoney], bizid);
				mysql_tquery(g_SQL, query);

				Info(playerid, "Anda telah mengganti skin menjadi ID %d", modelid);
				RefreshPSkin(playerid);
			}
			else 
				return Servers(playerid, "Canceled buy skin");	
		}	
		case SHOP_SKIN_FEMALE:
	    {
			if(response)
			{
				new bizid = pData[playerid][pInBiz], price;
				price = bData[bizid][bP][0];
				pData[playerid][pSkin] = modelid;
				SetPlayerSkin(playerid, modelid);
				GivePlayerMoneyEx(playerid, -price);
				SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s telah membeli skin ID %d seharga %s.", ReturnName(playerid), modelid, FormatMoney(price));
				bData[bizid][bProd]--;
				bData[bizid][bMoney] += Server_Percent(price);
				Server_AddPercent(price);
				
				new query[128];
				mysql_format(g_SQL, query, sizeof(query), "UPDATE bisnis SET prod='%d', money='%d' WHERE ID='%d'", bData[bizid][bProd], bData[bizid][bMoney], bizid);
				mysql_tquery(g_SQL, query);

				Info(playerid, "Anda telah mengganti skin menjadi ID %d", modelid);
				RefreshPSkin(playerid);
			}
			else 
				return Servers(playerid, "Canceled buy skin");	
		}
		case VIP_SKIN_MALE:
		{
			if(response)
			{
				pData[playerid][pSkin] = modelid;
				SetPlayerSkin(playerid, modelid);
				SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s telah mengganti skin ID %d.", ReturnName(playerid), modelid);
				Info(playerid, "Anda telah mengganti skin menjadi ID %d", modelid);
				RefreshPSkin(playerid);
			}
			else 
				return Servers(playerid, "Canceled buy skin");
		}
		case VIP_SKIN_FEMALE:
		{
			if(response)
			{
				pData[playerid][pSkin] = modelid;
				SetPlayerSkin(playerid, modelid);
				SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s telah mengganti skin ID %d.", ReturnName(playerid), modelid);
				Info(playerid, "Anda telah mengganti skin menjadi ID %d", modelid);
				RefreshPSkin(playerid);
			}
			else 
				return Servers(playerid, "Canceled buy skin");
		}
		case SAPD_SKIN_MALE:
		{
			if(response)
			{
				pData[playerid][pFacSkin] = modelid;
				SetPlayerSkin(playerid, modelid);
				Servers(playerid, "Anda telah mengganti faction skin menjadi ID %d", modelid);
				RefreshPSkin(playerid);
			}	
		}
		case SAPD_SKIN_FEMALE:
		{
			if(response)
			{
				pData[playerid][pFacSkin] = modelid;
				SetPlayerSkin(playerid, modelid);
				Servers(playerid, "Anda telah mengganti faction skin menjadi ID %d", modelid);
				RefreshPSkin(playerid);
			}	
		}
		case SAPD_SKIN_WAR:
		{
			if(response)
			{
				pData[playerid][pFacSkin] = modelid;
				SetPlayerSkin(playerid, modelid);
				Servers(playerid, "Anda telah mengganti faction skin menjadi ID %d", modelid);
				RefreshPSkin(playerid);
			}	
		}
		case SAGS_SKIN_MALE:
		{
			if(response)
			{
				pData[playerid][pFacSkin] = modelid;
				SetPlayerSkin(playerid, modelid);
				Servers(playerid, "Anda telah mengganti faction skin menjadi ID %d", modelid);
				RefreshPSkin(playerid);
			}	
		}
		case SAGS_SKIN_FEMALE:
		{
			if(response)
			{
				pData[playerid][pFacSkin] = modelid;
				SetPlayerSkin(playerid, modelid);
				Servers(playerid, "Anda telah mengganti faction skin menjadi ID %d", modelid);
				RefreshPSkin(playerid);
			}	
		}
		case SAMD_SKIN_MALE:
		{
			if(response)
			{
				pData[playerid][pFacSkin] = modelid;
				SetPlayerSkin(playerid, modelid);
				Servers(playerid, "Anda telah mengganti faction skin menjadi ID %d", modelid);
				RefreshPSkin(playerid);
			}	
		}
		case SAMD_SKIN_FEMALE:
		{
			if(response)
			{
				pData[playerid][pFacSkin] = modelid;
				SetPlayerSkin(playerid, modelid);
				Servers(playerid, "Anda telah mengganti faction skin menjadi ID %d", modelid);
				RefreshPSkin(playerid);
			}	
		}
		case SANA_SKIN_MALE:
		{
			if(response)
			{
				pData[playerid][pFacSkin] = modelid;
				SetPlayerSkin(playerid, modelid);
				Servers(playerid, "Anda telah mengganti faction skin menjadi ID %d", modelid);
				RefreshPSkin(playerid);
			}	
		}
		case SANA_SKIN_FEMALE:
		{
			if(response)
			{
				pData[playerid][pFacSkin] = modelid;
				SetPlayerSkin(playerid, modelid);
				Servers(playerid, "Anda telah mengganti faction skin menjadi ID %d", modelid);
				RefreshPSkin(playerid);
			}	
		}
		case TOYS_MODEL:
		{
			if(response)
			{
				new bizid = pData[playerid][pInBiz], price;
				price = bData[bizid][bP][1];
				
				GivePlayerMoneyEx(playerid, -price);
				if(pData[playerid][PurchasedToy] == false) MySQL_CreatePlayerToy(playerid);
				pToys[playerid][pData[playerid][toySelected]][toy_model] = modelid;
				//pToys[playerid][pData[playerid][toySelected]][toy_status] = 1;
				new finstring[750];
				strcat(finstring, ""dot"Spine\n"dot"Head\n"dot"Left upper arm\n"dot"Right upper arm\n"dot"Left hand\n"dot"Right hand\n"dot"Left thigh\n"dot"Right tigh\n"dot"Left foot\n"dot"Right foot");
				strcat(finstring, "\n"dot"Right calf\n"dot"Left calf\n"dot"Left forearm\n"dot"Right forearm\n"dot"Left clavicle\n"dot"Right clavicle\n"dot"Neck\n"dot"Jaw");
				ShowPlayerDialog(playerid, DIALOG_TOYPOSISIBUY, DIALOG_STYLE_LIST, ""WHITE_E"Select Bone", finstring, "Select", "Cancel");
				
				SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s telah membeli object ID %d seharga %s.", ReturnName(playerid), modelid, FormatMoney(price));
				bData[bizid][bProd]--;
				bData[bizid][bMoney] += Server_Percent(price);
				Server_AddPercent(price);

				new query[128];
				mysql_format(g_SQL, query, sizeof(query), "UPDATE bisnis SET prod='%d', money='%d' WHERE ID='%d'", bData[bizid][bProd], bData[bizid][bMoney], bizid);
				mysql_tquery(g_SQL, query);
			}
			else 
				return Servers(playerid, "Canceled buy toys");
		}
		case VIPTOYS_MODEL:
		{
			if(response)
			{
				if(pData[playerid][PurchasedToy] == false) MySQL_CreatePlayerToy(playerid);
				pToys[playerid][pData[playerid][toySelected]][toy_model] = modelid;
				//pToys[playerid][pData[playerid][toySelected]][toy_status] = 1;
				new finstring[750];
				strcat(finstring, ""dot"Spine\n"dot"Head\n"dot"Left upper arm\n"dot"Right upper arm\n"dot"Left hand\n"dot"Right hand\n"dot"Left thigh\n"dot"Right tigh\n"dot"Left foot\n"dot"Right foot");
				strcat(finstring, "\n"dot"Right calf\n"dot"Left calf\n"dot"Left forearm\n"dot"Right forearm\n"dot"Left clavicle\n"dot"Right clavicle\n"dot"Neck\n"dot"Jaw");
				ShowPlayerDialog(playerid, DIALOG_TOYPOSISIBUY, DIALOG_STYLE_LIST, ""WHITE_E"Select Bone", finstring, "Select", "Cancel");
				
				SendNearbyMessage(playerid, 30.0, COLOR_PURPLE, "** %s telah mengambil object ID %d dilocker.", ReturnName(playerid), modelid);
			}
			else
				return Servers(playerid, "Canceled toys");
		}
	}
	return 1;
}	


CMD:burton10(playerid, params[])
{
    pData[playerid][pJobTime] = 1;
    return 1;
}