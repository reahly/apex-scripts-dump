global function IsShieldRegenGameMode

global function ShGameMode_ShieldRegen_Init
global function ShGameMode_ShieldRegen_RegisterNetworking

#if(false)

#endif

#if(CLIENT)
global function ShGameMode_ShieldRegen_ServerCallback_AnnouncementSplash
global function ShGameMode_ShieldRegen_ServerCallback_RegenTriggerEvent
global function ShGameMode_ShieldRegen_ServerCallback_RegenCancelEvent
#endif

#if(DEV)
const bool POWER_WEAPONS_MODE_DEBUG = false
#endif //

const float SHIELD_REGEN_DELAY_TIME = 8.0 //
const float SHIELD_REGEN_BREAK_DELAY_TIME = 16.0 //
const float SHIELD_REGEN_PREEMPTIVE_TIME = 0.25

#if(false)
//
#endif

//
#if(false)
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
#endif
//

//
#if(false)
//
//
//
//
#endif
//

#if(CLIENT)//
const asset ASSET_ANNOUNCEMENT_ICON = $"rui/gamemodes/salvo_war_games/war_games_icon"
#endif

struct
{
	var modeRui
} file

void function ShGameMode_ShieldRegen_Init()
{
	#if(DEV)
		if ( POWER_WEAPONS_MODE_DEBUG )
		{
			printf("ShGameMode_ShieldRegen_Init()")
		}
	#endif

	if ( !IsShieldRegenGameMode() )
	{
		#if(DEV)
			if ( POWER_WEAPONS_MODE_DEBUG )
			{
				printf("ShGameMode_ShieldRegen_Init: Game mode disabled. See playlist vars!")
			}
		#endif
		return
	}

	#if(false)







#endif

	RegisterSignal( "ShieldRegen_OnDamaged" )
	RegisterSignal( "ShieldRegen_OnDisconnect" )

	#if(CLIENT)
		AddCallback_OnPlayerDisconnected( ShieldRegen_OnPlayerDisconnected )
		AddCreateCallback( "player", ShieldRegen_OnPlayerSpawned )
		AddCallback_GameStateEnter( eGameState.Postmatch, ShieldRegen_OnGameState_Ending )
	#endif

	AddCallback_EntitiesDidLoad( ShieldRegen_EntitiesDidLoad )
}

void function ShieldRegen_EntitiesDidLoad()
{
	thread __EntitiesDidLoad()
}

void function __EntitiesDidLoad()
{
	SurvivalCommentary_SetHost( eSurvivalHostType.MAGGIE )
}

void function ShGameMode_ShieldRegen_RegisterNetworking()
{
	if ( !IsShieldRegenGameMode() )
	{
		return
	}

	Remote_RegisterClientFunction( "ShGameMode_ShieldRegen_ServerCallback_RegenTriggerEvent", "bool" )
	Remote_RegisterClientFunction( "ShGameMode_ShieldRegen_ServerCallback_RegenCancelEvent" )
	Remote_RegisterClientFunction( "ShGameMode_ShieldRegen_ServerCallback_AnnouncementSplash" )
}

#if(false)














































//















































































//














































































































































//













#endif

#if(CLIENT)
void function ShieldRegen_OnPlayerSpawned( entity player )
{
	#if(DEV)
		if ( POWER_WEAPONS_MODE_DEBUG )
		{
			printf( "ShieldRegen_OnPlayerSpawned()" )
		}
	#endif

	if ( player == GetLocalClientPlayer() )
	{
		ShieldRegen_CreateShieldRegenUI()
	}
}

void function ShieldRegen_OnPlayerDisconnected( entity player )
{
	#if(DEV)
		if ( POWER_WEAPONS_MODE_DEBUG )
		{
			printf("ShieldRegen_OnPlayerDisconnected()")
		}
	#endif

	if ( !IsValid( player ) )
	{
		return
	}
	
	player.Signal( "ShieldRegen_OnDisconnect" )
}

void function ShieldRegen_CreateShieldRegenUI()
{
	#if(DEV)
		if ( POWER_WEAPONS_MODE_DEBUG )
		{
			printf("ShieldRegen_CreateShieldRegenUI()")
		}
	#endif

	if ( IsValid( file.modeRui ) )
	{
		return
	}

	file.modeRui = CreateCockpitRui( $"ui/gamemode_shieldregen.rpak" )
	RuiSetFloat( file.modeRui, "maxRegenDelay", SHIELD_REGEN_BREAK_DELAY_TIME )
}

void function ShieldRegen_OnGameState_Ending()
{
	#if(DEV)
		if ( POWER_WEAPONS_MODE_DEBUG )
		{
			printf("ShieldRegen_OnGameState_Ending()")
		}
	#endif

	if ( !IsValid( file.modeRui ) )
	{
		return
	}
	RuiDestroyIfAlive( file.modeRui )
}

void function ShGameMode_ShieldRegen_ServerCallback_RegenTriggerEvent( bool skipDelay )
{
	#if(DEV)
		if ( POWER_WEAPONS_MODE_DEBUG )
		{
			printf("ShGameMode_ShieldRegen_ServerCallback_RegenTriggerEvent()")
		}
	#endif

	thread ShieldRegen_RegenTriggerNotice_Thread( skipDelay )
}

void function ShGameMode_ShieldRegen_ServerCallback_RegenCancelEvent()
{
	#if(DEV)
		if ( POWER_WEAPONS_MODE_DEBUG )
		{
			printf("ShGameMode_ShieldRegen_ServerCallback_RegenCancelEvent()")
		}
	#endif

	entity player = GetLocalClientPlayer()
	if ( !IsValid( player ) )
	{
		return
	}

	player.Signal( "ShieldRegen_OnDamaged" )
}


void function ShieldRegen_RegenTriggerNotice_Thread( bool skipDelay )
{
	#if(DEV)
		if ( POWER_WEAPONS_MODE_DEBUG )
		{
			printf("ShieldRegen_RegenTriggerNotice_Thread()")
		}
	#endif

	entity player = GetLocalClientPlayer()
	if ( !IsValid( player ) )
	{
		return
	}

	player.EndSignal( "OnDestroy" )
	player.EndSignal( "ShieldRegen_OnDamaged" )
	player.EndSignal( "ShieldRegen_OnDisconnect" )

	OnThreadEnd( function() : ( ) {
		#if(DEV)
			if ( POWER_WEAPONS_MODE_DEBUG )
			{
				printf("ShieldRegen_RegenTriggerNotice: Thread End")
			}
		#endif

		RuiSetBool( file.modeRui, "isDamaged", false )
		RuiSetFloat( file.modeRui, "regenDelay", 0.0 )
	} )

	float regenDelay = 0.0
	if ( !skipDelay )
	{
		regenDelay = SHIELD_REGEN_DELAY_TIME
		if ( player.GetShieldHealth() == 0 )
		{
			regenDelay = SHIELD_REGEN_BREAK_DELAY_TIME
		}
	}

	//
	int armorTier = EquipmentSlot_GetEquipmentTier( player, "armor" )
	vector color = GetFXRarityColorForTier( armorTier )

	RuiSetBool( file.modeRui, "isDamaged", true )
	RuiSetGameTime( file.modeRui, "lastDamageTime", Time() )
	RuiSetFloat( file.modeRui, "regenDelay", regenDelay )

	RuiSetFloat3( file.modeRui, "armorColor", <color.x/255.0, color.y/255.0, color.z/255.0> )

	if ( !skipDelay )
	{
		wait( regenDelay - SHIELD_REGEN_PREEMPTIVE_TIME ) //
	}

	while ( player.GetShieldHealth() != player.GetShieldHealthMax() )
	{
		WaitFrame()
	}

	RuiSetBool( file.modeRui, "isDamaged", false )
}

void function ShGameMode_ShieldRegen_ServerCallback_AnnouncementSplash()
{
	entity player = GetLocalClientPlayer()
	if ( !IsValid( player ) )
	{
		return
	}

	int style = ANNOUNCEMENT_STYLE_SWEEP
	float duration = 16.0
	string messageText = "#WAR_GAMESMODE_SHIELD_REGEN"
	string subText = "#WAR_GAMESMODE_SHIELD_REGEN_ABOUT"
	vector titleColor = <0, 0, 0>
	asset icon = $""
	asset leftIcon = ASSET_ANNOUNCEMENT_ICON
	asset rightIcon = ASSET_ANNOUNCEMENT_ICON
	string soundAlias = SFX_HUD_ANNOUNCE_QUICK

	AnnouncementData announcement = Announcement_Create( messageText )
	announcement.drawOverScreenFade = true
	Announcement_SetSubText( announcement, subText )
	Announcement_SetHideOnDeath( announcement, true )
	Announcement_SetDuration( announcement, duration )
	Announcement_SetPurge( announcement, true )
	Announcement_SetStyle( announcement, style )
	Announcement_SetSoundAlias( announcement, soundAlias )
	Announcement_SetTitleColor( announcement, titleColor )
	Announcement_SetIcon( announcement, icon )
	Announcement_SetLeftIcon( announcement, leftIcon )
	Announcement_SetRightIcon( announcement, rightIcon )
	AnnouncementFromClass( player, announcement )
}
#endif

bool function IsShieldRegenGameMode()
{
	return GetCurrentPlaylistVarBool( "is_shield_regen_mode", false )
}
