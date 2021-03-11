#if(CLIENT)
global function ShFiringRangeStoryEvents_Init
#endif

                    

#if(false)


#endif


//
const asset ARENAS_TEASE_PANEL_MDL = $"mdl/props/global_access_panel_button/global_access_panel_button_console_w_stand.rmdl"

//
const asset ARENAS_TEASE_ELEVATOR_PLATFORM_MDL = $"mdl/boomtown/btown_whouse_elevator_01.rmdl"
const string ARENAS_TEASE_ELEVATOR_PLATFORM_SCRIPTNAME = "arenas_tease_elevator"
const asset ARENAS_TEASE_ELEVATOR_RAILING_MDL = $"mdl/playback/playback_railing_01_064.rmdl"
const string ARENAS_TEASE_ELEVATOR_RAILING_SCRIPTNAME = "arenas_tease_elevator_railing"
const string ARENAS_TEASE_ELEVATOR_END_LOC_SCRIPTNAME = "arenas_tease_elevator_end"
const string ARENAS_TEASE_ELEVATOR_PANEL_SCRIPTNAME = "arenas_tease_elevator_panel"
const asset ARENAS_TEASE_ELEVATOR_CLIP_HACK_MDL = $"mdl/beacon/beacon_crane_wall_panel_512x512_01.rmdl"
const string ARENAS_TEASE_ELEVATOR_CLIP_FRONT_SCRIPTNAME = "arenas_playerclip_front"
const string ARENAS_TEASE_ELEVATOR_CLIP_BEHIND_SCRIPTNAME = "arenas_playerclip_behind"

//
const string ARENAS_TEASE_SHIP_PANEL_SCRIPTNAME = "arenas_tease_dropship_button"
const string ARENAS_TEASE_SHIP_BUTTON_SOUND_EVENT = "ArenaTease_DropshipButton_Activate"
const string ARENAS_TEASE_SHIP_BUTTON_DENY_SOUND_EVENT = "Olympus_Horizon_Screen_Deny"
const vector ARENAS_TEASE_SHIP_ORIGIN = < 33530, -4975, -28647>
const vector ARENAS_TEASE_SHIP_ANGLES = <0, -90, 0>
const float ARENAS_TEASE_SHIP_PICK_UP_RADIUS = 256
const float ARENAS_TEASE_SHIP_TIME_TO_ARRIVE = 6
const float ARENAS_TEASE_SHIP_TIME_TO_DEPART = 30
const string ARENAS_TEASE_SHIP_ATTACHMENT_PT =  "ATTACH_PLAYER_3"
const float ARENAS_TEASE_SHIP_Z_OFFSET = 128

//
const string ARENAS_TEASE_BANNERS_03_SCRIPTNAME = "arenas_tease_banner_03"
const string ARENAS_TEASE_BANNERS_04_SCRIPTNAME = "arenas_tease_banner_04"
const string ARENAS_TEASE_BANNERS_05_SCRIPTNAME = "arenas_tease_banner_05"
const asset ARENAS_TEASE_BANNERS_03_ON_MDL = $"mdl/thunderdome/thunderdome_blisk_flex_screen_03.rmdl"
const asset ARENAS_TEASE_BANNERS_03_OFF_MDL = $"mdl/thunderdome/thunderdome_blisk_flex_screen_03_off.rmdl"
const asset ARENAS_TEASE_BANNERS_04_ON_MDL = $"mdl/thunderdome/thunderdome_blisk_flex_screen_04.rmdl"
const asset ARENAS_TEASE_BANNERS_04_OFF_MDL = $"mdl/thunderdome/thunderdome_blisk_flex_screen_04_off.rmdl"
const asset ARENAS_TEASE_BANNERS_05_ON_MDL = $"mdl/thunderdome/thunderdome_blisk_flex_screen_05.rmdl"
const asset ARENAS_TEASE_BANNERS_05_OFF_MDL = $"mdl/thunderdome/thunderdome_blisk_flex_screen_05_off.rmdl"

//
const string ARENAS_TEASE_HOLO_SCRIPTNAME = "arenas_tease_hologram"
const asset ARENAS_TEASE_HOLO_FX_LOGO = $"P_holo_arenas_tease"
const asset ARENAS_TEASE_HOLO_FX_ASH = $"P_holo_ash_tease"
const asset ARENAS_TEASE_HOLO_FX_BG = $"P_holo_vapor_BG"


//
const string ARENAS_TEASE_TELEPORT_TARGET_INFO = "arenas_tease_teleport_location"

//
const vector ARENAS_TEASE_AMB_END_HALLWAY_ORIGIN = <-20895, 1055, -30934.6>
const vector ARENAS_TEASE_AMB_END_HALLWAY_ANG = <26.5, -90, 0>
const string ARENAS_TEASE_AMB_END_HALLWAY_EVENT = "ArenaTease_Emit_HallwayBattle"
const string ARENAS_TEASE_AMB_END_HALLWAY_SUB_EVENT = "diag_mp_fightVox_subtitles_hallway"
const float ARENAS_TEASE_AMB_END_HALLWAY_SUB_EVENT_DELAY = 8.5

const vector ARENAS_TEASE_AMB_END_ELEVATOR_ORIGIN = <-20910, 4000, -27182.16>
const vector ARENAS_TEASE_AMB_END_ELEVATOR_ANG = <42.9, -90, 0>
const string ARENAS_TEASE_AMB_END_ELEVATOR_EVENT = "ArenaTease_Emit_ElevatorBattle"

const string ARENAS_TEASE_AMB_ELEVATOR_SUB_EVENT = "diag_mp_fightVox_subtitles_elevator"
const string ARENAS_TEASE_AMB_ELEVATOR_DIAG_EVENT ="ArenaTease_Emit_ElevatorDiag"
const vector ARENAS_TEASE_AMB_ELEVATOR_DIAG_OFFSET = <5, 0, 0>

//
const array < vector > teaseDeathboxOrigins =
[
	<-20360, 4481, -27108>,
	<-21120, 4800, -27086>,
	<-20286, 5175, -26852>,
	<-21203, 4970, -26867>,
	<-20771, 5684, -26803>
]

const array < vector > teaseDeathboxAngles =
[
	<0, 218.39, 0>,
	<0, 310.13, 0>,
	<0, 61.97, 0>,
	<0, 199.14, 0>,
	<0, 313.53, 0>
]

const vector teaseAirdropOrigin = <-20276, 6172, -26597>
const vector teaseAirdropAngle = <0, 267.51, 0>
      

struct RealmStoryData
{
                     
		entity arenaShipPanel
		entity elevatorScriptMover
		entity elevatorPanel
		array < entity > bannersOff
		array < entity > bannersOn

		entity arenaShip
		bool arenaShipArrived
		bool arenaShipPlayerBoarded

		entity ambientGenericEndHallway
		entity finalChallengeWayPoint

		array < entity > dynamicElevatorFrontClip
		array < entity > dynamicElevatorBackClip
       
}

struct
{
                    

	//
	vector dropShipPanelOrigin
	vector dropShipPanelAngles

	array < vector > elevatorRailingOrigin
	array < vector > elevatorRailingAngles

	vector elevatorPlatformOrigin
	vector elevatorPlatformAngles
	vector elevatorPanelOrigin
	vector elevatorPanelAngles

	vector playerClipHackOrigin
	vector playerClipHackAngles

	vector elevatorEndPosition

	array < vector > banner03Origin
	array < vector > banner03Angles

	array < vector > banner04Origin
	array < vector > banner04Angles

	array < vector > banner05Origin
	array < vector > banner05Angles

	array < vector > frontClipOrigin
	array < vector > frontClipAngles
	array < vector > backClipOrigin
	array < vector > backClipAngles

	vector hologramLocation

	vector teleportLocation
	vector teleportAngle

	int activationTime
      

	table< int,  RealmStoryData > realmStoryDataByRealmTable
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


#if(CLIENT)
void function ShFiringRangeStoryEvents_Init()
{
	if ( GetMapName() != "mp_rr_canyonlands_staging" ) //
		return

	if ( !IsFiringRangeGameMode() )
		return

                     
		PrecacheModel( ARENAS_TEASE_BANNERS_03_OFF_MDL )
		PrecacheModel( ARENAS_TEASE_BANNERS_04_OFF_MDL )
		PrecacheModel( ARENAS_TEASE_BANNERS_05_OFF_MDL )
	#if(CLIENT)
		AddCreateCallback( "prop_dynamic", ArenasTeaseDynamicPropCreated )
	#endif
       

	AddCallback_EntitiesDidLoad( EntitiesDidLoad )
}
#endif

#if(CLIENT)
void function EntitiesDidLoad()
{
                     
	if ( !IsArenasTeaseEnabledInFiringRange() )
		return

	ArenasTeaseInit()
       
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

                    
bool function IsArenasTeaseEnabledInFiringRange()
{
	array<string> entScriptNamesToCheck
	entScriptNamesToCheck.append( ARENAS_TEASE_SHIP_PANEL_SCRIPTNAME )
	//

	bool allEntsPresent = true
	foreach ( string scriptName in entScriptNamesToCheck )
	{
		array<entity> entsToCheck = GetEntArrayByScriptName( scriptName )

		if ( entsToCheck.len() == 0 )
		{
			allEntsPresent = false
			break
		}
	}

	if ( allEntsPresent )
		return true

	return false
}

//
//
//

void function ArenasTeaseInit()
{

	file.activationTime =   expect int( GetCurrentPlaylistVarTimestamp( "s08e04_finale_activation", UNIX_TIME_FALLBACK_2038 ) )
	#if(false)



//


































































//










//


















#endif //
}

#if(CLIENT)
void function ArenasTeaseDynamicPropCreated( entity prop )
{
	if ( prop.GetScriptName() ==  ARENAS_TEASE_SHIP_PANEL_SCRIPTNAME)
	{
		SetCallback_CanUseEntityCallback( prop, ArenasTeaseDropshipPanel_CanUse )
		AddCallback_OnUseEntity_ClientServer( prop, ArenasTeaseDropshipPanel_OnUse )
		AddEntityCallback_GetUseEntOverrideText( prop, ArenasTeaseDropshipPanel_OverrideText )
	}

}
#endif

#if(false)
























//







//



//











































#endif


#if(false)
//












#endif

//
//
//

#if(false)














































#endif


#if(CLIENT)
string function ArenasTeaseDropshipPanel_OverrideText ( entity dropShipPanel )
{
	entity player = GetLocalViewPlayer()
	if ( !IsValid( player ) )
		return ""

	if ( !IsArenasTeaseLive() )
	{
		return ""
	}

#if(DEV)
	if ( !DEV_PlaylistOverride_DebugEnable() && player.GetPersistentVar( "s08StoryEvent.hasStep4Completed" ) )
#else
	if ( player.GetPersistentVar( "s08StoryEvent.hasStep4Completed" ) )
#endif
	{
		return ""
	}

	if ( GetPlayerArrayOfTeam( player.GetTeam() ).len() > 1 )
		return "#S08E04_DROPSHIP_SOLO_PROMPT"

#if(DEV)
	if ( !DEV_PlaylistOverride_DebugEnable() && player.GetPersistentVarAsInt( "s08StoryEvent.step3ChallengesCompletedCount" ) < 2)
#else
	if ( player.GetPersistentVarAsInt( "s08StoryEvent.step3ChallengesCompletedCount" ) < 2)
#endif
	{
		return "#S08E04_DROPSHIP_EARLY_PROMPT"
	}

	int time = GetUnixTimestamp()
	if ( time < file.activationTime )
	{
		int timeDelta        = file.activationTime - time
		string timeString    = GetDaysHoursMinutesSecondsString( timeDelta )
		return Localize( "#S08E04_DROPSHIP_COUNTDOWN_PROMPT", timeString )
	}

	return "S08E04_DROPSHIP_PROMPT"
}
#endif

bool function ArenasTeaseDropshipPanel_CanUse ( entity player, entity dropShipPanel )
{
	if ( !IsValid( player ) )
		return false

	if ( Bleedout_IsBleedingOut( player ) )
		return false

	return true
}

void function ArenasTeaseDropshipPanel_OnUse( entity dropShipPanel, entity player, int useInputFlags )
{
	if ( !IsArenasTeaseLive() || GetUnixTimestamp() < file.activationTime)
		return

#if(DEV)
	if ( !DEV_PlaylistOverride_DebugEnable() && player.GetPersistentVar( "s08StoryEvent.hasStep4Completed" ) )
#else
	if ( player.GetPersistentVar( "s08StoryEvent.hasStep4Completed" ) )
#endif
	{
		return
	}

	if ( GetPlayerArrayOfTeam( player.GetTeam() ).len() > 1 )
		return

#if(DEV)
	if ( !DEV_PlaylistOverride_DebugEnable() && player.GetPersistentVarAsInt( "s08StoryEvent.step3ChallengesCompletedCount" ) < 2)
#else
	if ( player.GetPersistentVarAsInt( "s08StoryEvent.step3ChallengesCompletedCount" ) < 2)
#endif
	{
		#if(false)

#endif
		return
	}

	#if(false)










#endif
}



#if(false)
































#endif

//
//
//

#if(false)


































































































































#endif

#if(false)












#endif

#if(false)


























































//
//
//









































































































//








//









































































































































//
//
//





































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









//
//
//





//
//
//



































































#endif

bool function IsPlayerHorizon( entity player )
{
	if ( !IsValid (player) )
		return false

	ItemFlavor character = LoadoutSlot_GetItemFlavor( ToEHI( player ), Loadout_Character() )
	string characterRef  = ItemFlavor_GetHumanReadableRef( character ).tolower()
	if ( characterRef == "character_horizon" )
	{
		return true
	}

	return false
}


#if(DEV)
bool function DEV_PlaylistOverride_DebugEnable()
{
	return GetCurrentPlaylistVarBool( "s08_tease_final_dev_debug", false )
}
#endif

      

