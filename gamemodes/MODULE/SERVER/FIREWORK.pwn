#define MAX_FIREWORK 100 //You can change it...
#define NON -1

enum EnumFirework
{
	FW_Owner,
	Float:FW_Pos[4],
	Float:FW_Height,
	Float:FW_Radius,
	FW_Amount,
	FW_RocketsReleased,
	FW_Timer,
	FW_Box
};
new FireworkInfo[MAX_FIREWORK][EnumFirework];

function EmptyFireworkSlot()
{
	for(new i=1; i < MAX_FIREWORK; i++)if(FireworkInfo[i][FW_Owner]==NON) return i;
	return 0;
}

CMD:placefirework(playerid,params[])
{
	new Float:height,Float:radius,amount;
	if(sscanf(params,"ffd",height,radius,amount))return Usage(playerid, "/placefirework [Height] [Radius] [Amount]");
	new eid=EmptyFireworkSlot();
	if(!eid)return Error(playerid, "There are no more free firework slots!");
	GetPlayerPos(playerid,FireworkInfo[eid][FW_Pos][0],FireworkInfo[eid][FW_Pos][1],FireworkInfo[eid][FW_Pos][2]);
	GetPlayerFacingAngle(playerid,FireworkInfo[eid][FW_Pos][3]);
	//Enum info settimine
	FireworkInfo[eid][FW_RocketsReleased]=-2;
	FireworkInfo[eid][FW_Radius]=radius;
	FireworkInfo[eid][FW_Height]=height;
	FireworkInfo[eid][FW_Owner]=playerid;
	FireworkInfo[eid][FW_Amount]=amount;
	FireworkInfo[eid][FW_Pos][0]+= (2.0 * floatsin(-FireworkInfo[eid][FW_Pos][3],degrees));
	FireworkInfo[eid][FW_Pos][1]+= (2.0 * floatcos(-FireworkInfo[eid][FW_Pos][3],degrees));
	FireworkInfo[eid][FW_Pos][2]-=0.9;
	FireworkInfo[eid][FW_Box]=CreateObject(3016,FireworkInfo[eid][FW_Pos][0],FireworkInfo[eid][FW_Pos][1],FireworkInfo[eid][FW_Pos][2], 0,0,0);
	Info(playerid, "Firework box ID: %d",eid);
	return 1;
}
CMD:startfirework(playerid,params[])
{
	new eid;
	if(sscanf(params,"d",eid))return SCM(playerid,-1,"USAGE: /startfirwork [ID]");
	if(FireworkInfo[eid][FW_Owner]!=playerid)return Error(playerid, "You can't light up this firework!");
	FireworkInfo[eid][FW_Timer]=SetTimerEx("StartFirework",600,true,"d",eid);
	return 1;
}

function StartFirework(eid)
{
    FireworkInfo[eid][FW_Amount]--;
	new Float:distance,Float:Ax,Float:Ay,Float:Az,time,object;

    if(!FireworkInfo[eid][FW_Amount])
    {
		if(IsPlayerConnected(FireworkInfo[eid][FW_Owner])) Info(FireworkInfo[eid][FW_Owner], "Firework stopped has stopped!");
        FireworkInfo[eid][FW_Owner]=NON;
		DestroyObject(FireworkInfo[eid][FW_Box]);
		KillTimer(FireworkInfo[eid][FW_Timer]);
		return 1;
	}
	if(++FireworkInfo[eid][FW_RocketsReleased]==3)FireworkInfo[eid][FW_RocketsReleased]=-2;
	//Counting
	Ax=FireworkInfo[eid][FW_Pos][0]+(distance * floatsin(-FireworkInfo[eid][FW_Pos][3],degrees));
	Ay=FireworkInfo[eid][FW_Pos][1]+(distance * floatsin(-FireworkInfo[eid][FW_Pos][3],degrees));
	Az=FireworkInfo[eid][FW_Pos][2]+FireworkInfo[eid][FW_Height];
	//Rocket body moving
	object=CreateObject(3000,FireworkInfo[eid][FW_Pos][0],FireworkInfo[eid][FW_Pos][1],FireworkInfo[eid][FW_Pos][2],0,0,0);
	time=MoveObject(object, Ax,Ay,Az, 20.0);
    SetTimerEx("MakeSphere",time,false,"dffff",object,Ax,Ay,Az,FireworkInfo[eid][FW_Radius]);
	return 1;
}
function MakeSphere(nobject,Float:x,Float:y,Float:z,Float:radius)
{
    DestroyObject(nobject);
	new object,type[3]={19282,19283,19284};
	new Float:phi=0.0,Float:theta=0.0,time;
	new Float:Ax=0.0,Float:Ay=0.0,Float:Az=0.0;
    CreateExplosion(x,y,z, 12,10.0);
	for(new i; i < 26; i++)
	{ // 1 8 8 8 1
		Ax=x+(radius*floatsin(-phi,degrees)*floatcos(-theta,degrees));
		Ay=y+(radius*floatsin(-phi,degrees)*floatsin(-theta,degrees));
		Az=z+(radius*floatcos(-phi,degrees));
		//Object moveing
		object=CreateObject(type[random(3)],x,y,z,0.0,0.0,theta+45);//Start
		time=MoveObject(object, Ax,Ay,Az, 5.0);
        SetTimerEx("FireworkRocketEnd",time,false,"d",object);//End
		//Reset
		theta+=45.0; if(theta==360.0){ Ax=0.0; Ax=0.0; Ay=0.0;}
        if((1+i)%8==1)phi+=45;
    }
	return 1;
}
function FireworkRocketEnd(object)return DestroyObject(object);