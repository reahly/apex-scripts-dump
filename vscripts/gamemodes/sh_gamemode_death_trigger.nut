global function IsDeathTriggerGameMode
global function ShGameMode_DeathTrigger_Init

global function ShGameMode_DeathTrigger_DeathFieldCircleWaitThread
global function ShGameMode_DeathTrigger_RegisterNetworking

#if(CLIENT)
global function ShGameMode_DeathTrigger_ServerCallback_AnnouncementSplash
global function ShGameMode_DeathTrigger_ServerCallback_DeathEvent
global function ShGameMode_DeathTrigger_ServerCallback_UpdateRui
#endif

#if(CLIENT)
const asset ASSET_ANNOUNCEMENT_ICON = $"rui/gamemodes/salvo_war_games/war_games_icon"
#endif

const float WARNING_SFX_COOLDOWN = 0.3
const EFFECT_CONTROLPOINT_COLOR = <255, 0, 0>

const float ROUND_GRACE_PERIOD = 3.0

//
const float RUI_HIDE_BUFFER = 10.0

const string NETWORKVAR_DEATHTRIGGER_MATCHSTARTTIME = "DeathTrigger_MatchStartTime"

#if(false)




#endif

//
const string HUD_MATCH_DEATH_PING_1P = "UI_WarGames_DeathTrigger_NumberFlash"
const string HUD_MATCH_TIME_REDUCE_WARNING_1P = "UI_WarGames_DeathTrigger_BarShrink"
const string HUD_BODYCOUNT_CLIMBS_WARNING_1P = "ui_ingame_markedfordeath_playerunmarked"
const string CIRCLE_CLOSING_IN_SOUND = "UI_InGame_RingMoveWarning"
//

#if(DEV)
const bool DEATH_TRIGGER_MODE_DEBUG = false
#endif //

struct
{
	#if(false)








#endif


	#if(CLIENT)
		float lastWarningTime = 0.0
	#endif
} file

void function ShGameMode_DeathTrigger_Init()
{
	if ( !IsDeathTriggerGameMode() )
	{
		return
	}

	#if(false)




//





#endif

	RegisterSignal( "DeathTrigger_OnNewDeath" )

	AddCallback_GameStateEnter( eGameState.Playing, DeathTrigger_OnGameState_Playing )

	#if(CLIENT)
		CircleBannerAnnouncementsEnable( false )
		SURVIVAL_SetGameStateAssetOverrideCallback( DeathTrigger_OverrideGameStateRUI )
	#endif

	AddCallback_EntitiesDidLoad( DeathTrigger_EntitiesDidLoad )
}

void function DeathTrigger_EntitiesDidLoad()
{
	thread __EntitiesDidLoad()
}

void function __EntitiesDidLoad()
{
	SurvivalCommentary_SetHost( eSurvivalHostType.MAGGIE )
}

void function ShGameMode_DeathTrigger_RegisterNetworking()
{
	if ( !IsDeathTriggerGameMode() )
		return

	Remote_RegisterClientFunction( "ShGameMode_DeathTrigger_ServerCallback_UpdateRui", "bool" )
	Remote_RegisterClientFunction( "ShGameMode_DeathTrigger_ServerCallback_DeathEvent", "int", 0, 60, "bool", "bool" )
	Remote_RegisterClientFunction( "ShGameMode_DeathTrigger_ServerCallback_AnnouncementSplash" )

	RegisterNetworkedVariable( NETWORKVAR_DEATHTRIGGER_MATCHSTARTTIME, SNDC_GLOBAL, SNVT_TIME, -1 )
}

void function DeathTrigger_OnGameState_Playing()
{
	#if(DEV)
		if ( DEATH_TRIGGER_MODE_DEBUG )
		{
			printf("DeathTrigger_OnGameState_Playing()")
		}
	#endif

	#if(false)

#endif
}

#if(false)















//














































//





//
























































//



//

















//




































































































#endif //

#if(CLIENT)
void function DeathTrigger_OverrideGameStateRUI()
{
	#if(DEV)
		if ( DEATH_TRIGGER_MODE_DEBUG )
		{
			printf("[CLIENT] DeathTrigger_OverrideGameStateRUI()")
		}
	#endif

	ClGameState_RegisterGameStateAsset( $"ui/gamestate_info_death_trigger.rpak" )
	ClGameState_RegisterGameStateFullmapAsset( $"ui/gamestate_info_fullmap_death_trigger.rpak" )
}

void function ShGameMode_DeathTrigger_ServerCallback_DeathEvent( int deaths, bool isKiller, bool bShowWarning )
{
	#if(DEV)
		if ( DEATH_TRIGGER_MODE_DEBUG )
		{
			printf("[CLIENT] ShGameMode_DeathTrigger_ServerCallback_DeathEvent()")
		}
	#endif

	float now = Time()

	if ( bShowWarning )
	{
		DeathTrigger_WarningSplash()
	}

	//
	if ( now - file.lastWarningTime > WARNING_SFX_COOLDOWN && !isKiller && !bShowWarning )
	{
		EmitSoundOnEntity( GetLocalClientPlayer(), HUD_MATCH_DEATH_PING_1P )
		file.lastWarningTime = now
	}

	RuiSetInt( ClGameState_GetRui(), "newDeathsTotal", deaths )
	RuiSetGameTime( ClGameState_GetRui(), "lastDeathTime", Time() )
	if ( IsValid( GetCameraCircleStatusRui() ) )
	{
		RuiSetInt( GetCameraCircleStatusRui(), "newDeathsTotal", deaths )
		RuiSetGameTime( GetCameraCircleStatusRui(), "lastDeathTime", Time() )
	}
	RuiSetInt( GetFullmapGamestateRui(), "newDeathsTotal", deaths )
	RuiSetGameTime( GetFullmapGamestateRui(), "lastDeathTime", Time() )
}

void function ShGameMode_DeathTrigger_ServerCallback_UpdateRui( bool isEnabled )
{
	#if(DEV)
		if ( DEATH_TRIGGER_MODE_DEBUG )
		{
			printf("[CLIENT] ShGameMode_DeathTrigger_ServerCallback_UpdateRui() isEnabled = " + isEnabled)
		}
	#endif

	if ( isEnabled == true )
	{
		int currentDeathFieldStage = SURVIVAL_GetCurrentDeathFieldStage()

		float nextCircleStartTime = GetGlobalNetTime( "nextCircleStartTime" )

		#if(DEV)
			if ( DEATH_TRIGGER_MODE_DEBUG )
			{
				printf("[CLIENT] ShGameMode_DeathTrigger_ServerCallback_UpdateRui() NextCircleStartTime = " + nextCircleStartTime)
			}
		#endif

		RuiSetFloat( ClGameState_GetRui(), "secondsPerDeath", GetCurrentPlaylistVarFloat( "deathfield_onDeathTimeReduction_" + currentDeathFieldStage,  10.0 ) )
		RuiSetGameTime( ClGameState_GetRui(), "circleStartTimeCache", nextCircleStartTime )
		if ( IsValid( GetCameraCircleStatusRui() ) )
		{
			RuiSetFloat( GetCameraCircleStatusRui(), "secondsPerDeath", GetCurrentPlaylistVarFloat( "deathfield_onDeathTimeReduction_" + currentDeathFieldStage, 10.0 ) )
			RuiSetGameTime( GetCameraCircleStatusRui(), "circleStartTimeCache", nextCircleStartTime )
		}
		RuiSetFloat( GetFullmapGamestateRui(), "secondsPerDeath", GetCurrentPlaylistVarFloat( "deathfield_onDeathTimeReduction_" + currentDeathFieldStage,  10.0 ) )
		RuiSetGameTime( GetFullmapGamestateRui(), "circleStartTimeCache", nextCircleStartTime )
	}

	if ( isEnabled == true )
	{
		DeathTrigger_DisplayRoundTimerUI( true )
	} else {
		thread DeathTrigger_HideRoundTimerAfterDelay_Thread()
	}
}

void function DeathTrigger_HideRoundTimerAfterDelay_Thread()
{
	wait 1.0
	DeathTrigger_DisplayRoundTimerUI( false )
}

void function DeathTrigger_DisplayRoundTimerUI( bool isVisible ) //
{
	RuiSetBool( ClGameState_GetRui(), "shouldShowDeathTriggerRoundTimer", isVisible )
	if ( IsValid( GetCameraCircleStatusRui() ) )
	{
		RuiSetBool( GetCameraCircleStatusRui(), "shouldShowDeathTriggerRoundTimer", isVisible )
	}
	RuiSetBool( GetFullmapGamestateRui(), "shouldShowDeathTriggerRoundTimer", isVisible )
}

void function DeathTrigger_WarningSplash()
{
	entity player = GetLocalClientPlayer()
	if ( !IsValid( player ) )
		return

	AnnouncementData announcement = Announcement_Create( "#WAR_GAMESMODE_DEATH_TRIGGER_WARNING" )
	announcement.drawOverScreenFade = true
	Announcement_SetHideOnDeath( announcement, true )
	Announcement_SetDuration( announcement, 4.0 )
	Announcement_SetPurge( announcement, true )
	Announcement_SetStyle( announcement, ANNOUNCEMENT_STYLE_SWEEP ) //
	Announcement_SetSoundAlias( announcement, HUD_BODYCOUNT_CLIMBS_WARNING_1P )
	Announcement_SetTitleColor( announcement, <1, 0, 0> )
	AnnouncementFromClass( player, announcement )
}


void function ShGameMode_DeathTrigger_ServerCallback_AnnouncementSplash()
{
	entity player = GetLocalClientPlayer()
	if ( !IsValid( player ) )
		return

	AnnouncementData announcement = Announcement_Create( "#WAR_GAMESMODE_DEATH_TRIGGER" )
	announcement.drawOverScreenFade = true
	Announcement_SetSubText( announcement, "#WAR_GAMESMODE_DEATH_TRIGGER_ABOUT" )
	Announcement_SetHideOnDeath( announcement, true )
	Announcement_SetDuration( announcement, 16.0 )
	Announcement_SetPurge( announcement, true )
	Announcement_SetStyle( announcement, ANNOUNCEMENT_STYLE_SWEEP )
	Announcement_SetSoundAlias( announcement, SFX_HUD_ANNOUNCE_QUICK )
	Announcement_SetTitleColor( announcement, <0, 0, 0> )
	Announcement_SetLeftIcon( announcement, ASSET_ANNOUNCEMENT_ICON )
	Announcement_SetRightIcon( announcement, ASSET_ANNOUNCEMENT_ICON )
	AnnouncementFromClass( player, announcement )
}
#endif

void function ShGameMode_DeathTrigger_DeathFieldCircleWaitThread( float waitTime )
{
	//
	while ( Time() <  GetGlobalNetTime( "nextCircleStartTime" ) )
	{
		WaitFrame()
	}
}

bool function IsDeathTriggerGameMode()
{
	return GetCurrentPlaylistVarBool( "is_death_trigger_mode", false )
}