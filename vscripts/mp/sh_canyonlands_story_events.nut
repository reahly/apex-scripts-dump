#if(false)

#endif

#if(CLIENT)
global function ClCanyonlandsStoryEvents_Init
#endif

#if(CLIENT)
global function GetS08TownTakeoverTeasePhase
#endif

const asset CAUSTIC_MODEL = $"mdl/Humans/class/heavy/pilot_heavy_caustic.rmdl"
const asset CAUSTIC_WALK_ANIM_SEQ = $"animseq/humans/class/heavy/pilot_heavy_caustic/caustic_desertlands_intro_walking_in.rseq"
const asset CAUSTIC_IDLE_ANIM_SEQ = $"animseq/humans/class/heavy/pilot_heavy_caustic/caustic_desertlands_intro_typing_loop.rseq"
const float CAUSTIC_MAX_ANIMATION_BUDGET = 8.0

global enum eS08TownTakeoverTeasePhase
{
	DISABLED,
	PHASE_1,
	PHASE_2,
	PHASE_3,
	PHASE_4
}

#if(DEV)
bool debugEnableS08TownTakeoverTease = false
#endif

struct
{
	table< entity, array<string> > audioLogTable
	#if(CLIENT)
		entity causticModel
	#endif
} file


//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//


#if(false)




#endif


#if(CLIENT)
void function ClCanyonlandsStoryEvents_Init()
{
	AddCallback_EntitiesDidLoad( EntitiesDidLoad )
	AddCallback_GameStateEnter( eGameState.WaitingForPlayers, OnWaitingForPlayers_Client )
}
#endif


#if(CLIENT)
void function EntitiesDidLoad()
{
	#if(false)

#endif
}
#endif //

//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//


#if(CLIENT)
int function GetS08TownTakeoverTeasePhase()
{
	int fakePhase = GetCurrentPlaylistVarInt( "s08_tt_tease_fake_phase", -1 )
	if (fakePhase != -1)
		return fakePhase

	int unixTimeNow = GetUnixTimestamp()
	if ( unixTimeNow >=  expect int( GetCurrentPlaylistVarTimestamp( "s08_tt_tease_phase4", UNIX_TIME_FALLBACK_2038 ) ) )
	{
		return eS08TownTakeoverTeasePhase.PHASE_4
	}
	else if ( unixTimeNow >=  expect int( GetCurrentPlaylistVarTimestamp( "s08_tt_tease_phase3", UNIX_TIME_FALLBACK_2038 ) ) )
	{
		return eS08TownTakeoverTeasePhase.PHASE_3
	}
	else if ( unixTimeNow >=  expect int( GetCurrentPlaylistVarTimestamp( "s08_tt_tease_phase2", UNIX_TIME_FALLBACK_2038 ) ) )
	{
		return eS08TownTakeoverTeasePhase.PHASE_2
	}
	else if ( unixTimeNow >=  expect int( GetCurrentPlaylistVarTimestamp( "s08_tt_tease_phase1", UNIX_TIME_FALLBACK_2038 ) ) )
	{
		return eS08TownTakeoverTeasePhase.PHASE_1
	}

	return eS08TownTakeoverTeasePhase.DISABLED
}
#endif


#if(false)





















































































































#endif

#if(false)







#endif

#if(false)
















#endif

#if(CLIENT)
void function OnWaitingForPlayers_Client()
{
	int teasePhase = GetS08TownTakeoverTeasePhase()
	if ( teasePhase == eS08TownTakeoverTeasePhase.PHASE_1 )
	{
		RegisterSignal( "S08TeaseRemoveCaustic" )
		AddCallback_GameStateEnter( eGameState.PickLoadout, OnPickLoadout_Client )
		thread PlayCausticIntroAnim_ClientThread()
	}
}

void function PlayCausticIntroAnim_ClientThread()
{
	float endTime = GetNV_PreGameStartTime()
	if ( endTime > 0.0 )
	{
		float remainingTime = endTime - Time()
		if ( remainingTime > CAUSTIC_MAX_ANIMATION_BUDGET )
			wait (remainingTime - CAUSTIC_MAX_ANIMATION_BUDGET)
	}

	vector origin = <2640, 36380, 5216.031250>
	vector angles = <0, -190.0, 0.0>

	file.causticModel = CreatePropDynamic( CAUSTIC_MODEL, origin, angles )

	OnThreadEnd(
		function() : ()
		{
			if ( IsValid( file.causticModel ) )
			{
				file.causticModel.Anim_Stop()
				file.causticModel.Destroy()
			}
		}
	)

	PlayAnimOnly( file.causticModel, CAUSTIC_WALK_ANIM_SEQ)
	thread PlayAnimOnly( file.causticModel, CAUSTIC_IDLE_ANIM_SEQ)

	WaitSignal( file.causticModel, "S08TeaseRemoveCaustic" )
}

void function OnPickLoadout_Client()
{
	if ( IsValid(file.causticModel) )
		Signal( file.causticModel, "S08TeaseRemoveCaustic" )
}
#endif