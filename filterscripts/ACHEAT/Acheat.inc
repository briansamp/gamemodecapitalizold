#include "ACHEAT\rAgc.inc"//Anti gun cheats -Rogue
#include "ACHEAT\FLaggers.inc"//Lag spike\desnyc detector- Rogue
#include "ACHEAT\Opba.inc"//Anti airbreak\teleport - Rogue
#include "ACHEAT\rAct.inc"//Anti car trolls - Rogue
#include "ACHEAT\AntiJC.inc"//Anti jetpack cheats- Rogue
#include "ACHEAT\rEac.inc"//Anti carswing\particlespam - Lorenc_
#include "ACHEAT\rAmc.inc"//Anti money cheats- Rogue
#include "ACHEAT\rAGM.inc"//Anti godmode -Rogue
#include "ACHEAT\rAntiBuggers.inc"//Depresses 5 abusing bugs triggered by cheats. -Rogue
#include "ACHEAT\AFkill.inc" //Anti fake kill -Rogue
#include "ACHEAT\AntiFC.inc"//Anti fake clients - Rogue
#include "ACHEAT\rAsc.inc"//Anti speed cheats- Rogue
#include "ACHEAT\rVM.inc"//Anti illegal car mods -Emmet_
#include "ACHEAT\rAcs.inc"//Anti car spam - Rogue
#include "ACHEAT\AntiSpam.inc"//Anti chat spam- Rogue
#include "ACHEAT\AntiSba.inc"//Anti slide bug abuse- Rogue

#if !defined FILTERSCRIPT 

#if defined RogueAC_OnGameModeInit
	forward RogueAC_OnGameModeInit();
#endif

public OnGameModeInit()
{
	print("	 [[--|| Rogue-AC V7.0 ||--]]	 ");
	print("	 [[--|| Rogue Anti cheat version 7.0 ||--]]	  ");
	print("	 [[--|| Successfully Loaded! ||--]]	  ");
	#if defined RogueAC_OnGameModeInit
		return RogueAC_OnGameModeInit();
	#else
		return 1;
	#endif
}

#if defined _ALS_OnGameModeInit
  #undef OnGameModeInit
#else
	#define _ALS_OnGameModeInit
#endif

#define OnGameModeInit RogueAC_OnGameModeInit

#endif
