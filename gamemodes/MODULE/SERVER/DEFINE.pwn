// Server Define
#define TEXT_GAMEMODE	"Capitaliz 1.0.4a "
#define SHOT_SERVER_NAME	"Capitaliz rp"
#define TEXT_WEBURL		"-"
#define TEXT_LANGUAGE	"Indonesia/English"
#define SERVER_BOT      "AdesBot"
#define IP_SERVER   "66.42.53.68:7777"

// MySQL configuration
/*#define		MYSQL_HOST 			"127.0.0.1"
#define		MYSQL_USER 			"server_9753"
#define		MYSQL_PASSWORD 		"jalil"
#define		MYSQL_DATABASE 		"server_9753_moga"*/

#define		MYSQL_HOST 			"127.0.0.1"
#define		MYSQL_USER 			"root"
#define		MYSQL_PASSWORD 		""
#define		MYSQL_DATABASE 		"capitaliz"
// how many seconds until it kicks the player for taking too long to login
#define		SECONDS_TO_LOGIN 	200

// default spawn point: Las Venturas (The High Roller)
#define 	DEFAULT_POS_X 		71.3030
#define 	DEFAULT_POS_Y 		-1851.7705
#define 	DEFAULT_POS_Z 		5.1220
#define 	DEFAULT_POS_A 		298.4754

//Android Client Check
//#define IsPlayerAndroid(%0)                 GetPVarInt(%0, "NotAndroid") == 0
//Movement Header
GetXYLeftOfPoint(Float:x,Float:y,&Float:x2,&Float:y2,Float:A,Float:distance)
{
	x2 = x - (distance * floatsin(-A-90.0,degrees));
	y2 = y - (distance * floatcos(-A-90.0,degrees));
}
GetXYRightOfPoint(Float:x,Float:y,&Float:x2,&Float:y2,Float:A,Float:distance)
{
	x2 = x - (distance * floatsin(-A+90.0,degrees));
	y2 = y - (distance * floatcos(-A+90.0,degrees));
}
GetXYInFrontOfPoint11(Float:x,Float:y,&Float:x2,&Float:y2,Float:A,Float:distance)
{
	x2 = x + (distance * floatsin(-A,degrees));
	y2 = y + (distance * floatcos(-A,degrees));
}
GetXYBehindPoint11(Float:x,Float:y,&Float:x2,&Float:y2,Float:A,Float:distance)
{
	x2 = x - (distance * floatsin(-A,degrees));
	y2 = y - (distance * floatcos(-A,degrees));
}

//Header tianmetal & Y_Less
#define SEM(%0,%1) SendClientMessage(%0,0xBFC0C200,%1) 					// SEM = Send Error Message by 	Myself
#define IsNull(%1) ((!(%1[0])) || (((%1[0]) == '\1') && (!(%1[1]))))    // IsNull macro 			by 	Y_Less
//_________________________[ Variabel Define ]___________________________//
#define Loop(%0,%1,%2) for(new %0 = %2; %0 < %1; %0++)
#define GetPlayerCash(%0) GetPVarInt(%0, "Cash")

// Message
#define SCM SendClientMessage
#define SendCustomMessage(%0,%1,%2)     SendClientMessageEx(%0, COLOR_ARWIN, %1": "WHITE_E""%2)
#define function%0(%1) forward %0(%1); public %0(%1)
#define Servers(%1,%2) SendClientMessageEx(%1, -1, ""GREY_JG"SERVER: "WHITE_E""%2)
#define Names(%1,%2) SendClientMessage(%1, COLOR_GREY, "<Names>: "WHITE_E""%2)
#define Info(%1,%2) SendClientMessageEx(%1, -1, ""RIKO"INFO: "WHITE_E""%2)
#define Usage(%1,%2) SendClientMessage(%1, -1, ""GREY_JG"USAGE: "WHITE_E""%2)
#define Error(%1,%2) SendClientMessageEx(%1, -1, ""GREY_JG"ERROR: "WHITE_E""%2)
#define PermissionError(%0) SendClientMessage(%0, COLOR_WHITE, ""GREY_JG"ERROR: "WHITE_E"You don't have the privilege to use this command!")

#define SendMessage(%0,%1) \
	SendClientMessageEx(%0, COLOR_YELLOW, "»{FFFFFF} "%1)
#define SendMe(%0,%1) \
	SendClientMessageEx(%0, COLOR_YELLOW, "Â»{FFFFFF} "%1)
#define SM SendMessage
#define PRESSED(%0) \
    (((newkeys & (%0)) == (%0)) && ((oldkeys & (%0)) != (%0)))

#define SCMF(%0,%1,%2,%3)           					format(format_string, 144, %2,%3) && SendClientMessage(%0, %1, format_string)

#define IsPlayerAndroid(%0)                 GetPVarInt(%0, "NotAndroid") == 0

//Converter
#define minplus(%1) \
        (((%1) < 0) ? (-(%1)) : ((%1)))

// AntiCaps
#define UpperToLower(%1) for( new ToLowerChar; ToLowerChar < strlen( %1 ); ToLowerChar ++ ) if ( %1[ ToLowerChar ]> 64 && %1[ ToLowerChar ] < 91 ) %1[ ToLowerChar ] += 32

// Banneds
const BAN_MASK = (-1 << (32 - (/*this is the CIDR ip detection range [def: 26]*/26)));

//---------[ Define Faction ]-----
#define SAPD	1		//locker 1573.26, -1652.93, -40.59
#define	SAGS	2		// 1464.10, -1790.31, 2349.68
#define SAMD	3		// -1100.25, 1980.02, -58.91
#define SANEW	4		// 256.14, 1776.99, 701.08
//---------[ Define Job ]-----------
#define BOX_INDEX            9 // Index Box Barang
//mber
#define PRESSED(%0) (((newkeys & (%0)) == (%0)) && ((oldkeys & (%0)) != (%0)))
#define RELEASED(%0) (((newkeys & (%0)) != (%0)) && ((oldkeys & (%0)) == (%0)))

enum OffsetTypes {
	VEHICLE_OFFSET_BOOT,
	VEHICLE_OFFSET_HOOD,
	VEHICLE_OFFSET_ROOF
};

#define GetVehicleBoot(%0,%1,%2,%3)				GetVehicleOffset((%0),VEHICLE_OFFSET_BOOT,(%1),(%2),(%3))

//Private Vehicle Player System Define
#define MAX_PRIVATE_VEHICLE 5000
#define MAX_PLAYER_VEHICLE 3
#define MAX_VEHICLE_OBJECT 10
#define MAX_COLOR_OBJECT 5

#define OBJECT_TYPE_TEXT 1
