global function RingCollapseMode_Init
global function RingCollapseMode_RegisterNetworking
global function RingCollapseMode_IsPositionWithinRadius

#if(false)




#endif

#if(CLIENT)
global function RingCollapseMode_ServerCallback_FissureWarnMsg
global function RingCollapseMode_ServerCallback_DestroyFissure
global function RingCollapseMode_ServerCallback_AnnouncementSplash
global function RingCollapseMode_ServerCallback_FissureWarnMinimapPing
global function RingCollapseMode_ServerCallback_ChangeFissureSize
global function CL_RingCollapseMode_IsPositionInRingFissure

//
//
const float FISSURE_FX_RADIUS_SCALE = 1000.0
const asset FISSURE_FX_SMALL_PRECISE = $"P_ringfury_radius_CP_1k_x_1k"
const asset FISSURE_FX_MEDIUM_PRECISE = $"P_ringfury_radius_CP_1k_x_5k"
const asset FISSURE_FX_LARGE_PRECISE = $"P_ringfury_radius_CP_1k_x_100k"
//
const asset FISSURE_BEAM_START_FX = $"P_ringfury_beam_start"
//
const asset FISSURE_BEAM_FX = $"P_ringfury_beam_constant"
//
const asset FISSURE_BEAM_END_FX = $"P_ringfury_beam_end"
const float FISSURE_BEAMFX_END_DELAY = 0.2 //
const float FISSURE_BEAMEND_FX_START_DELAY = 0.15 //
const float FISSURE_FX_SMALL_RADIUS = 3000.0  //
const float FISSURE_FX_MEDIUM_RADIUS = 17000.0

//
const float FISSURE_WARN_TIMER_DRAW_DIST = 4000.0 //
const float FISSURE_WARN_TIMER_ISFAR_DIST = 1000.0 //
const int STATUS_TEXT_SCALE_PER_CHAR = 14 //
const int STATUS_TEXT_SCALE_BUFFER_SPACE = 20 //
const asset ASSET_ANNOUNCEMENT_ICON = $"rui/gamemodes/ring_collapse/ring_collapse_icon"
const asset ASSET_TIMER_EMBLEM = $"rui/menu/gamemode_emblem/ring_collapse"
                          
const asset ASSET_ANNOUNCEMENT_ICON_WAR_GAMES = $"rui/gamemodes/salvo_war_games/war_games_icon"
const asset ASSET_TIMER_EMBLEM_WAR_GAMES = $"rui/menu/gamemode_emblem/emblem_war_games_flare_up"
      

//
//
const string SOUND_FISSURE_BEAM_START = "Survival_RingFury_Beam_Appear"
//
const string SOUND_FISSURE_BEAM = "Survival_RingFury_Beam_Idle"
//
const string SOUND_FISSURE_BEAM_END = "Survival_RingFury_Beam_Disappear"
//
const float FISSURE_BEAM_IDLE_SFX_CULLING_DIST = 5000.0
//
const float FISSURE_BEAM_SFX_CULLING_DIST = 13000.0
#endif //

global const string FISSURE_MINIMAP_WARNING = "ringFissureWarning"
global const string RING_FISSURE = "ringFissure"
global const vector RING_COLLAPSEMODE_WARN_COLOR = < 187, 35, 5 >
global const vector RING_COLLAPSEMODE_MINIMAP_WARN_COLOR = < 187, 35, 5 >
global const vector RING_COLLAPSEMODE_DANGER_COLOR = < 230, 13, 13 >
global const vector RING_COLLAPSEMODE_DANGER_COLOR_BORDER = < 141, 38, 0 >
global const float FISSURE_START_RADIUS = 95.0
global const float FISSURE_DAMAGE_RADIUS_OFFSET = 1000.0 //
const string CIRCLE_CLOSING_IN_SOUND = "survival_circle_close_alarm_01"
const string WAYPOINT_RING_FISSURE = "waypoint_ring_fissure"
const string WAYPOINT_FISSURE_TIMER = "waypoint_fissure_timer"
const float FISSURE_PINGABLE_RADIUS = 95.0
const float ANNOUNCEMENT_DURATION_LONG = 6.0
const float ANNOUNCEMENT_DURATION_SHORT = 3.0
const float MAX_FISSURE_SIZE = 29001.0 //
const float INVALID_FISSURE_RADIUS = -1.0
const float FISSURE_PING_SIZE_PERCENT_OFFSET = 0.88
const float PING_TRACEBLOCKER_HEIGHT = 18000
const float NEAR_FISSURE_MESSAGING_RADIUS_OFFSET = 2000.0
const float FAR_FISSURE_MESSAGING_RADIUS_OFFSET = 4000.0
const float FISSURE_DIALOGUE_COOLDOWN = 240.0
const float FISSURE_DIALOGUE_COOLDOWN_LONG = 300.0
const float DEATHFIELD_SIZE_PERCENT_OFFSET = 0.6
const float MINIMAP_PINGRADIUS_PERCENT_OFFSET = 0.025 //
const float MAP_PINGRADIUS_PERCENT_OFFSET = 0.38 //
const float MAP_MAX_PINGRADIUS = 2000.0
const float MINIMAP_MAX_PINGRADIUS = 65.0
const float MINIMAP_ACCURATE_PING_PULSE_DURATION = 4.0
const float MINIMAP_RANDOM_PING_PULSE_DURATION = 1.5
const float FISSURE_BEAM_GROW_TIME = 5.0
const float FISSURE_ENTITY_DESTROY_DELAY = 10.0 //
const float FISSURE_GROUNDTRACE_HEIGHT = 15000.0
const float FISSURE_GROUNDPOSITION_VERTICAL_OFFSET = 9000.0
const float FISSURE_TIMER_VERTICAL_OFFSET = 200.0 //
const int ANNOUNCEMENT_PRIORITY = 200
const int FISSURE_RANDOM_POSITION_COUNT = 200 //
const int WAYPOINT_FLOAT_IDX_STARTRADIUS = 0
const int WAYPOINT_FLOAT_IDX_ENDRADIUS = 1
const int WAYPOINT_FLOAT_IDX_WARNGROW_START_TIME = 2
const int WAYPOINT_FLOAT_IDX_GROW_START_TIME = 3
const int WAYPOINT_FLOAT_IDX_GROW_END_TIME = 4
const int WAYPOINT_FLOAT_IDX_SHRINK_TIME = 5
const int WAYPOINT_INT_IDX_STATE = 6
const int WAYPOINT_INT_IDX_SHOWLIFETIME = 7
const int WAYPOINT_ENT_IDX_ZONE_ENTITY = 0
const vector WHITE = < 1, 1, 1 >
const vector INVALID_FISSURE_POS = < -1, -1, -1 >

enum eFissureSize
{
	TINY,
	SMALL,
	MEDIUM,
	LARGE,
}

global enum eFissureState
{
	STARTING,
	IDLE,
	GROWING,
	SHRINKING,
	ENDING,
}

enum eFissureSoundState
{
	EXPANDING,
	IDLE,
	SHRINKING,
}

global struct FissureData
{
	vector position = INVALID_FISSURE_POS
	float currentRadius
	float endRadius = INVALID_FISSURE_RADIUS
#if(false)















#endif //
}

#if(false)








#endif //

struct {
	float fissureWarningTime
	float fissureLifetime
#if(DEV)
	bool debugDraw = false
	FissureData debugFissurePosSearchArea
#endif //

#if(false)











































#endif //

#if(CLIENT)
	int colorCorrection
	table<entity, FissureData> fissureDataByFissureWPEnts
	array<entity> fissureWPEnts

	table <float, string> expandSoundByFissureRadius =
	{
		[ 5000.0 ] = "Survival_RingFury_Flare_Expand_Large",
		[ 2500.0 ] = "Survival_RingFury_Flare_Expand_Medium",
		[ 0.0 ] = "Survival_RingFury_Flare_Expand_Small",
	}

	table <float, string> idleSoundByFissureRadius =
	{
		[ 5000.0 ] = "Survival_RingFury_Flare_Idle_Large",
		[ 2500.0 ] = "Survival_RingFury_Flare_Idle_Medium",
		[ 0.0 ] = "Survival_RingFury_Flare_Idle_Small",
	}

	table <float, string> shrinkSoundByFissureRadius =
	{
		[ 5000.0 ] = "Survival_RingFury_Flare_Shrink_Large",
		[ 2500.0 ] = "Survival_RingFury_Flare_Shrink_Medium",
		[ 0.0 ] = "Survival_RingFury_Flare_Shrink_Small",
	}

	table <float, float> sfxCullingDistByRadius =
	{
		[ 5000.0 ] = 10000.0,
		[ 2500.0] = 6000.0,
		[ 0.0 ] = 5000.0,
	}
#endif //
} file

//
//
//
//
//

void function RingCollapseMode_Init()
{
	if ( !IsRingCollapseGameMode() )
		return

	RegisterSignal( "FissureStarted" )
	RegisterSignal( "DestroyFissure" )
	RegisterSignal( "ChangeFissureSize" )

	file.fissureWarningTime = GetCurrentPlaylistVarFloat( "ring_fissure_warning_time", 5.0 )
	file.fissureLifetime = GetCurrentPlaylistVarFloat( "ring_fissure_lifetime", 30.0 )

	#if(DEV)
		file.debugDraw = GetCurrentPlaylistVarBool( "ring_collapse_debug_draw", false )
	#endif //

	Assert( FISSURE_START_RADIUS >= 1.0, format( "RingCollapseMode: fissureStartRadius is %f units, needs to be 1.0 or greater", FISSURE_START_RADIUS ) )
	float minWarnTime = FISSURE_BEAM_GROW_TIME + ( MINIMAP_ACCURATE_PING_PULSE_DURATION - MINIMAP_RANDOM_PING_PULSE_DURATION )
	Assert( file.fissureWarningTime >= minWarnTime, format( "RingCollapseMode: fissureWarningTime is too short, it should be at least %f seconds", minWarnTime ) )
	Assert( file.fissureLifetime >= 0, "RingCollapseMode: fissureLifetime is set to a negative number, it should be 0 or higher" )
	
	AddCallback_EntitiesDidLoad( EntitiesDidLoad_RingCollapse )
#if(false)


//















#endif //

#if(CLIENT)
	PrecacheParticleSystem( FISSURE_FX_SMALL_PRECISE )
	PrecacheParticleSystem( FISSURE_FX_MEDIUM_PRECISE )
	PrecacheParticleSystem( FISSURE_FX_LARGE_PRECISE )
	PrecacheParticleSystem( FISSURE_BEAM_START_FX )
	PrecacheParticleSystem( FISSURE_BEAM_FX )
	PrecacheParticleSystem( FISSURE_BEAM_END_FX )
	Waypoints_RegisterCustomType( WAYPOINT_RING_FISSURE, OnFissureWpInstanced )
	Waypoints_RegisterCustomType( WAYPOINT_FISSURE_TIMER, OnFissureWpInstanced )
#endif //
}

void function RingCollapseMode_RegisterNetworking()
{
	if ( !IsRingCollapseGameMode() )
		return

	Remote_RegisterClientFunction( "RingCollapseMode_ServerCallback_FissureWarnMsg", "bool" )
	Remote_RegisterClientFunction( "RingCollapseMode_ServerCallback_DestroyFissure", "entity", "entity" )
	Remote_RegisterClientFunction( "RingCollapseMode_ServerCallback_AnnouncementSplash" )
	Remote_RegisterClientFunction( "RingCollapseMode_ServerCallback_FissureWarnMinimapPing", "vector", -1.0, 1.0, 32, "float", 1.0, MAX_FISSURE_SIZE, 32, "bool" )
	Remote_RegisterClientFunction( "RingCollapseMode_ServerCallback_ChangeFissureSize", "entity", "entity", "float", 1.0, MAX_FISSURE_SIZE, 32, "float", 1.0, MAX_FISSURE_SIZE, 32, "float", 1.0, MAX_FISSURE_SIZE, 32, "float", 1.0, 999999.0, 32, "bool" )
}

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







//






//

//






#endif //

//
//
//
//
//

void function EntitiesDidLoad_RingCollapse()
{
	thread __EntitiesDidLoad()
}

void function __EntitiesDidLoad()
{
	SurvivalCommentary_SetHost( eSurvivalHostType.MAGGIE )
#if(false)



















//



//


//

#endif //
}

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
/*

















*/





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







#endif //

#if(CLIENT)
//
void function RingCollapseMode_ServerCallback_ChangeFissureSize( entity fissureWPZone, entity fissureTimer, float radius, float endRadius, float startTime, float endTime, bool isTimer )
{
	entity player = GetLocalViewPlayer()

	if ( IsValid( player ) && isTimer && IsValid( fissureTimer ) )
	{
		Signal( fissureTimer, "ChangeFissureSize", { oldRadius = radius, newEndRadius = endRadius, newEndTime = endTime } )
	}
	else if ( IsValid( player ) && IsValid( fissureWPZone ) )
	{
		Signal( fissureWPZone, "ChangeFissureSize", { oldRadius = radius, newEndRadius = endRadius, newEndTime = endTime } )
	}
}
#endif //

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



//

















//




























//


























//












//



































//













#endif //

//
bool function RingCollapseMode_IsPositionWithinRadius( float radius, float modifier, vector position1, vector position2 )
{
	float radiusToTest
	if ( modifier != 0 )
	{
		radiusToTest = radius + ( radius/ modifier )
	}
	else
	{
		radiusToTest = radius
	}
	float radiusToTestSqr = pow( radiusToTest, 2 )
	float positionDistSqr = Distance2DSqr( position1, position2 )

	if ( positionDistSqr < radiusToTestSqr )
	{
		return true
	}

	return false
}

//
//
//
//
//

#if(false)
//





#endif //

#if(CLIENT)
//
void function RingCollapseMode_ServerCallback_AnnouncementSplash()
{
	entity player = GetLocalClientPlayer()
	if ( !IsValid( player ) )
		return

	float duration = 16.0
	string messageText = GetCurrentPlaylistVarString( "ring_collapse_drop_banner_title", "#RING_COLLAPSEMODE" )
	string subText = GetCurrentPlaylistVarString( "ring_collapse_drop_banner_Text", "#RING_COLLAPSEMODE_BANNER_LVL_01" )
	vector titleColor = <0, 0, 0>
	asset icon = $""

	asset iconAsset = ASSET_ANNOUNCEMENT_ICON
	printl( "WarGames playlist name result = " +  GetCurrentPlaylistName().find( "flareup" ) )
                           
		if ( GetCurrentPlaylistName().find( "flareup" ) != -1 )
			iconAsset = ASSET_ANNOUNCEMENT_ICON_WAR_GAMES
       

	asset leftIcon = iconAsset
	asset rightIcon = iconAsset
	string soundAlias = SFX_HUD_ANNOUNCE_QUICK
	int style = ANNOUNCEMENT_STYLE_SWEEP
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
#endif //

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

















#endif //

#if(CLIENT)
//
void function RingCollapseMode_ServerCallback_FissureWarnMsg( bool isPlayerInsideFissure )
{
	entity player = GetLocalClientPlayer()
	if ( !IsValid( player ) )
		return

	//
	if ( isPlayerInsideFissure )
	{
		AnnouncementData announcement = Announcement_Create( Localize( "#RING_COLLAPSEMODE_ANNOUNCE_INSIDE_FISSURE" ) )
		announcement.drawOverScreenFade = true
		Announcement_SetSubText( announcement, "" )
		Announcement_SetHideOnDeath( announcement, true )
		Announcement_SetDuration( announcement, ANNOUNCEMENT_DURATION_LONG )
		Announcement_SetPurge( announcement, true )
		Announcement_SetStyle( announcement, ANNOUNCEMENT_STYLE_CIRCLE_WARNING )
		Announcement_SetSoundAlias( announcement, CIRCLE_CLOSING_IN_SOUND )
		Announcement_SetTitleColor( announcement, WHITE )
		Announcement_SetUseColorOnAnnouncementText( announcement, true )
		Announcement_SetIcon( announcement, $"" )
		Announcement_SetPriority( announcement, ANNOUNCEMENT_PRIORITY )
		AnnouncementFromClass( player, announcement )
	}
	else
	{
		AnnouncementData announcement = Announcement_Create( Localize( "#RING_COLLAPSEMODE_ANNOUNCE_FISSURE" ) )
		announcement.drawOverScreenFade = true
		Announcement_SetSubText( announcement, "" )
		Announcement_SetHideOnDeath( announcement, true )
		Announcement_SetDuration( announcement, ANNOUNCEMENT_DURATION_SHORT )
		Announcement_SetPurge( announcement, true )
		Announcement_SetStyle( announcement, ANNOUNCEMENT_STYLE_SWEEP )
		Announcement_SetSoundAlias( announcement, SFX_HUD_ANNOUNCE_QUICK )
		Announcement_SetTitleColor( announcement, WHITE )
		Announcement_SetUseColorOnAnnouncementText( announcement, true )
		Announcement_SetIcon( announcement, $"" )
		Announcement_SetPriority( announcement, ANNOUNCEMENT_PRIORITY )
		AnnouncementFromClass( player, announcement )
	}
}

//
void function RingCollapseMode_ServerCallback_FissureWarnMinimapPing( vector origin, float spreadRadius, bool isNewFissure )
{
	thread FissureWarnMinimapPing_Thread( origin, spreadRadius, isNewFissure )
}

//
void function FissureWarnMinimapPing_Thread( vector origin, float spreadRadius, bool isNewFissure )
{
	float minimap_PingRadius = min( ( spreadRadius * MINIMAP_PINGRADIUS_PERCENT_OFFSET ), MINIMAP_MAX_PINGRADIUS )
	float map_PingRadius = min( ( spreadRadius * MAP_PINGRADIUS_PERCENT_OFFSET ), MAP_MAX_PINGRADIUS )

	entity player = GetLocalViewPlayer()
	player.EndSignal( "OnDestroy" )
	asset altIcon = $""

	float endTime = Time() + ( FISSURE_BEAM_GROW_TIME - MINIMAP_RANDOM_PING_PULSE_DURATION ) //
	float randMin = -1 * ( spreadRadius * 0.5 )
	float randMax = spreadRadius * 0.5

	float minWait = 0.6
	float maxWait = 1.0

	while ( Time() < endTime )
	{
		vector newOrigin
		newOrigin = origin + < RandomIntRange( randMin, randMax ), RandomIntRange( randMin, randMax ), 0 >

		var minimapRui = Minimap_RingPulseAtLocation( newOrigin, minimap_PingRadius, RING_COLLAPSEMODE_MINIMAP_WARN_COLOR / 255.0, MINIMAP_RANDOM_PING_PULSE_DURATION, MINIMAP_RANDOM_PING_PULSE_DURATION, false, altIcon )
		RuiSetBool( minimapRui, "shouldClamp", false )
		FullMap_PingLocation( newOrigin, map_PingRadius, RING_COLLAPSEMODE_WARN_COLOR / 255.0, MINIMAP_RANDOM_PING_PULSE_DURATION, MINIMAP_RANDOM_PING_PULSE_DURATION, false, altIcon )

		wait RandomFloatRange( minWait, maxWait )
	}
}

//
//
//
//
//

//
void function OnFissureWpInstanced( entity wp )
{
	int fissureState = wp.GetWaypointInt( WAYPOINT_INT_IDX_STATE )
	float startRadius = wp.GetWaypointFloat( WAYPOINT_FLOAT_IDX_STARTRADIUS )
	float endRadius = wp.GetWaypointFloat( WAYPOINT_FLOAT_IDX_ENDRADIUS )
	float closeTime = wp.GetWaypointFloat( WAYPOINT_FLOAT_IDX_SHRINK_TIME )
	float startTime = wp.GetWaypointFloat( WAYPOINT_FLOAT_IDX_GROW_START_TIME )
	float endTime = wp.GetWaypointFloat( WAYPOINT_FLOAT_IDX_GROW_END_TIME )

	if ( wp.GetWaypointCustomType() == WAYPOINT_RING_FISSURE )
	{
		float warnGrowStartTime = wp.GetWaypointFloat( WAYPOINT_FLOAT_IDX_WARNGROW_START_TIME )
		float warnGrowEndTime = warnGrowStartTime + FISSURE_BEAM_GROW_TIME

		entity zoneEnt = wp.GetWaypointEntity( WAYPOINT_ENT_IDX_ZONE_ENTITY )
		thread FissureStart_Thread( zoneEnt, startRadius, endRadius, warnGrowStartTime, warnGrowEndTime, startTime, closeTime, endTime, fissureState, wp )
	}
	else if ( wp.GetWaypointCustomType() == WAYPOINT_FISSURE_TIMER )
	{
		bool showLifeTimeTimer = bool( wp.GetWaypointInt( WAYPOINT_INT_IDX_SHOWLIFETIME ) )
		thread FissureTimerStart_Thread( wp, startRadius, endRadius, startTime, closeTime, endTime, fissureState, showLifeTimeTimer )
	}
}

//
//
void function FissureStart_Thread( entity zoneEnt, float startRadius, float endRadius, float warnGrowStartTime, float warnGrowEndTime, float startTime, float closeTime, float endTime, int state, entity extraEnt = null )
{
	FlagWait( "EntitiesDidLoad" )
	entity player = GetLocalViewPlayer()
	if ( !IsValid( player ) || !IsValid( zoneEnt ) )
		return

	if ( IsValid( extraEnt ) )
	{
		Signal( extraEnt, "FissureStarted" )
		extraEnt.EndSignal( "OnDestroy" )
		extraEnt.EndSignal( "DestroyFissure" )
	}

	Signal( zoneEnt, "FissureStarted" )
	player.EndSignal( "OnDestroy" )
	zoneEnt.EndSignal( "OnDestroy" )
	zoneEnt.EndSignal( "DestroyFissure" )

	int fissureBeamStartFXID = GetParticleSystemIndex( FISSURE_BEAM_START_FX )
	int fissureBeamStartFX = -1
	int fissureBeamFXID = GetParticleSystemIndex( FISSURE_BEAM_FX )
	int fissureBeamFX = -1
	int fissureFXID = GetFissureFXIDForRadius( startRadius )
	int fissureFX   = -1

	table<string, int> e
	e["fx"] <- fissureFX
	e["fbsfx"] <- fissureBeamStartFX
	e["fbfx"] <- fissureBeamFX

	FissureData  fissureData
	fissureData.position = zoneEnt.GetOrigin()
	fissureData.currentRadius = 1
	fissureData.endRadius = endRadius
	file.fissureDataByFissureWPEnts[zoneEnt] <- fissureData
	file.fissureWPEnts.append( zoneEnt )

	vector fissurePos = zoneEnt.GetOrigin()
	vector fissureBeamPos = fissurePos + < 0, 0, FISSURE_GROUNDPOSITION_VERTICAL_OFFSET >
	vector fissureBeamIntroSFXPos = fissureBeamPos
	entity fissureSoundEnt = CreateClientSideAmbientGeneric( fissurePos, GetFissureSoundForSize( startRadius, eFissureSoundState.EXPANDING ), GetFissureSFXCullingDist( startRadius ) )
	fissureSoundEnt.SetEnabled( false )
	entity beamSoundEnt = CreateClientSideAmbientGeneric( fissureBeamPos, SOUND_FISSURE_BEAM, FISSURE_BEAM_IDLE_SFX_CULLING_DIST )
	beamSoundEnt.SetEnabled( false )
	string currentBeamSoundPlaying = ""

	//
	if ( state == eFissureState.ENDING )
		return

	OnThreadEnd(
		function() : ( e, zoneEnt, fissureSoundEnt, beamSoundEnt, closeTime, fissureData, extraEnt )
		{
			if ( IsValid( fissureSoundEnt ) )
			{
				fissureSoundEnt.SetEnabled( false )
				fissureSoundEnt.Destroy()
			}

			if ( IsValid( beamSoundEnt ) )
			{
				beamSoundEnt.SetEnabled( false )
				beamSoundEnt.Destroy()
			}

			foreach( effect in e )
			{
				if ( effect != -1 )
					EffectStop( effect, true, true )
			}

			thread FissureEnd_Thread( zoneEnt, closeTime, fissureData, extraEnt )
		}
	)
	string currentSoundPlaying = ""
	float radius = 1
	vector fwdToPlayer
	vector circleEdgePos


	//
	if ( state == eFissureState.STARTING )
	{
		//
		fissureBeamStartFX = StartParticleEffectOnEntity( zoneEnt, fissureBeamStartFXID, FX_PATTACH_ABSORIGIN_FOLLOW, -1 )
		e["fbsfx"] = fissureBeamStartFX
		EffectSetControlPointVector( e["fbsfx"], 2, fissureBeamPos )

		fissureBeamIntroSFXPos.z = player.EyePosition().z
		//
		currentBeamSoundPlaying = ManageFissureBeamSound( fissureBeamIntroSFXPos, player.GetOrigin(), beamSoundEnt, currentBeamSoundPlaying, true, false )

		//
		fissureBeamFX = StartParticleEffectOnEntity( zoneEnt, fissureBeamFXID, FX_PATTACH_ABSORIGIN_FOLLOW, -1 )
		e["fbfx"] = fissureBeamFX
		EffectSetControlPointVector( e["fbfx"], 2, fissureBeamPos )

		//
		fissureFX   = StartParticleEffectOnEntity( zoneEnt, fissureFXID, FX_PATTACH_ABSORIGIN_FOLLOW, -1 )
		e["fx"] = fissureFX
		EffectSetControlPointVector( e["fx"], 1, < FissureFX_GetScaledRadius( 1 ), 0, 0 > )

		while ( Time() < startTime )
		{
			if ( !IsValid( player ) || !IsValid( zoneEnt ) )
				break

			radius = GraphCapped( Time(), warnGrowStartTime, warnGrowEndTime, 1, startRadius )
			fissureData.currentRadius = radius
			EffectSetControlPointVector( e["fx"], 1, < FissureFX_GetScaledRadius( radius ), 0, 0 > )

			fissureBeamIntroSFXPos.z = player.EyePosition().z
			//
			currentBeamSoundPlaying = ManageFissureBeamSound( fissureBeamIntroSFXPos, player.GetOrigin(), beamSoundEnt, currentBeamSoundPlaying, false, false )

			WaitFrame()
		}

		//
		if ( e["fbsfx"] != -1 )
			EffectStop( e["fbsfx"], true, true )

		//
		currentBeamSoundPlaying = ManageFissureBeamSound( fissureBeamPos, player.GetOrigin(), beamSoundEnt, currentBeamSoundPlaying, false, false )

		//
		while ( Time() < endTime )
		{
			if ( !IsValid( player ) || !IsValid( zoneEnt ) )
				break

			radius = GraphCapped( Time(), startTime, endTime, startRadius, endRadius )
			fissureData.currentRadius = radius
			int idealFx = GetFissureFXIDForRadius( radius ) //
			if ( idealFx != fissureFXID )
			{
				fissureFXID = idealFx
				EffectStop( e["fx"], true, true )
				fissureFX = StartParticleEffectOnEntity( zoneEnt, fissureFXID, FX_PATTACH_ABSORIGIN_FOLLOW, -1 )
				e["fx"] = fissureFX
			}

			fwdToPlayer = Normalize( < player.GetOrigin().x, player.GetOrigin().y, 0 > - < fissurePos.x, fissurePos.y, 0 > )
			circleEdgePos = fissurePos + ( fwdToPlayer * radius )
			circleEdgePos.z = player.EyePosition().z

			currentSoundPlaying = ManageFissureSound( circleEdgePos, fissureSoundEnt, endRadius, currentSoundPlaying, eFissureSoundState.EXPANDING, false )
			EffectSetControlPointVector( e["fx"], 1, < FissureFX_GetScaledRadius( radius ), 0, 0 > )
			WaitFrame()
		}
	}
	//
	fissureData.currentRadius = endRadius
	//
	if ( e["fbfx"] == -1 )
	{
		fissureBeamFX = StartParticleEffectOnEntity( zoneEnt, fissureBeamFXID, FX_PATTACH_ABSORIGIN_FOLLOW, -1 )
		e["fbfx"] = fissureBeamFX
		EffectSetControlPointVector( e["fbfx"], 2, fissureBeamPos )
	}

	//
	if ( e["fx"] == -1 )
	{
		fissureFXID = GetFissureFXIDForRadius( endRadius )
		fissureFX = StartParticleEffectOnEntity( zoneEnt, fissureFXID, FX_PATTACH_ABSORIGIN_FOLLOW, -1 )
		e["fx"] = fissureFX
		EffectSetControlPointVector( e["fx"], 1, < FissureFX_GetScaledRadius( endRadius ), 0, 0 > )
	}

	//
	if ( state == eFissureState.GROWING || state == eFissureState.SHRINKING )
	{
		thread FissureChangeSize_Thread( zoneEnt, fissureData.currentRadius, endRadius, endTime, fissureData, extraEnt )
	}
	else //
	{
		thread FissureIdle_Thread( zoneEnt, fissureData, extraEnt )
	}
	//
	WaitFrame()
	if ( IsValid( fissureSoundEnt ) )
	{
		fissureSoundEnt.SetEnabled( false )
		fissureSoundEnt.Destroy()
	}

	if ( e["fx"] != -1 )
		EffectStop( e["fx"], true, true )

	//
	for ( ;; )
	{
		if ( !IsValid( player ) || !IsValid( zoneEnt ) )
			break

		table updatedFissureData = zoneEnt.WaitSignal( "ChangeFissureSize" )
		float oldRadius = expect float( updatedFissureData.oldRadius )
		float newEndRadius = expect float( updatedFissureData.newEndRadius )
		float newEndTime = expect float( updatedFissureData.newEndTime )
		waitthread FissureChangeSize_Thread( zoneEnt, oldRadius, newEndRadius, newEndTime, fissureData, extraEnt )
	}
}

//
void function FissureIdle_Thread( entity zoneEnt, FissureData fissureData, entity extraEnt = null )
{
	FlagWait( "EntitiesDidLoad" )
	entity player = GetLocalViewPlayer()
	if ( !IsValid( player ) || !IsValid( zoneEnt ) )
		return

	float radius = fissureData.endRadius
	int fissureFXID = GetFissureFXIDForRadius( radius )
	int fissureFX   = StartParticleEffectOnEntity( zoneEnt, fissureFXID, FX_PATTACH_ABSORIGIN_FOLLOW, -1 )
	vector fissurePos = zoneEnt.GetOrigin()
	entity fissureSoundEnt = CreateClientSideAmbientGeneric( fissurePos, GetFissureSoundForSize( radius, eFissureSoundState.IDLE ), GetFissureSFXCullingDist( radius ) )
	fissureSoundEnt.SetEnabled( false )

	table<string, int> e
	e["fx"] <- fissureFX

	EffectSetControlPointVector( e["fx"], 1, < FissureFX_GetScaledRadius( radius ), 0, 0 > )

	if ( IsValid( extraEnt ) )
	{
		extraEnt.EndSignal( "OnDestroy" )
		extraEnt.EndSignal( "DestroyFissure" )
		extraEnt.EndSignal( "ChangeFissureSize" )
	}

	player.EndSignal( "OnDestroy" )
	zoneEnt.EndSignal( "OnDestroy" )
	zoneEnt.EndSignal( "DestroyFissure" )
	zoneEnt.EndSignal( "ChangeFissureSize" )

	string currentSoundPlaying = ""
	vector fwdToPlayer
	vector circleEdgePos

	OnThreadEnd(
		function() : ( e, fissureSoundEnt )
		{
			if ( IsValid( fissureSoundEnt ) )
			{
				fissureSoundEnt.SetEnabled( false )
				fissureSoundEnt.Destroy()
			}

			foreach( effect in e )
			{
				if ( effect != -1 )
					EffectStop( effect, true, true )
			}
		}
	)

	//
	for ( ;; )
	{
		if ( !IsValid( player ) || !IsValid( zoneEnt ) )
			break

		int idealFx = GetFissureFXIDForRadius( radius )
		if ( idealFx != fissureFXID )
		{
			fissureFXID = idealFx
			EffectStop( e["fx"], true, true )
			fissureFX = StartParticleEffectOnEntity( zoneEnt, fissureFXID, FX_PATTACH_ABSORIGIN_FOLLOW, -1 )
			e["fx"] = fissureFX
		}

		fwdToPlayer = Normalize( < player.GetOrigin().x, player.GetOrigin().y, 0 > - < fissurePos.x, fissurePos.y, 0 > )
		circleEdgePos = fissurePos + ( fwdToPlayer * radius )
		circleEdgePos.z = player.EyePosition().z

		currentSoundPlaying = ManageFissureSound( circleEdgePos, fissureSoundEnt, radius, currentSoundPlaying, eFissureSoundState.IDLE, false )

		EffectSetControlPointVector( e["fx"], 1, < FissureFX_GetScaledRadius( radius ), 0, 0 > )
		WaitFrame()
	}
}

//
void function FissureChangeSize_Thread( entity zoneEnt, float oldRadius, float endRadius, float endTime, FissureData fissureData, entity extraEnt = null )
{
	FlagWait( "EntitiesDidLoad" )
	entity player = GetLocalViewPlayer()
	if ( !IsValid( player ) || !IsValid( zoneEnt ) )
		return

	if ( IsValid( extraEnt ) )
	{
		extraEnt.EndSignal( "OnDestroy" )
		extraEnt.EndSignal( "DestroyFissure" )
	}

	player.EndSignal( "OnDestroy" )
	zoneEnt.EndSignal( "OnDestroy" )
	zoneEnt.EndSignal( "DestroyFissure" )

	float radius = oldRadius
	float startRadius = oldRadius
	int fissureFXID = GetFissureFXIDForRadius( startRadius )
	int fissureFX   = StartParticleEffectOnEntity( zoneEnt, fissureFXID, FX_PATTACH_ABSORIGIN_FOLLOW, -1 )

	table<string, int> e
	e["fx"] <- fissureFX

	vector fissurePos = zoneEnt.GetOrigin()
	entity fissureSoundEnt = CreateClientSideAmbientGeneric( fissurePos, GetFissureSoundForSize( startRadius, eFissureSoundState.EXPANDING ), GetFissureSFXCullingDist( startRadius ) )
	fissureSoundEnt.SetEnabled( false )

	OnThreadEnd(
		function() : ( e, fissureSoundEnt )
		{
			if ( IsValid( fissureSoundEnt ) )
			{
				fissureSoundEnt.SetEnabled( false )
				fissureSoundEnt.Destroy()
			}

			foreach( effect in e )
			{
				if ( effect != -1 )
					EffectStop( effect, true, true )
			}
		}
	)
	string currentSoundPlaying = ""
	vector fwdToPlayer
	vector circleEdgePos
	float startTime = Time()
	int soundState

	if ( endRadius > oldRadius )
	{
		soundState = eFissureSoundState.EXPANDING
	}
	else
	{
		soundState = eFissureSoundState.SHRINKING
	}

	//
	while ( Time() < endTime )
	{
		if ( !IsValid( player ) || !IsValid( zoneEnt ) )
			break

		radius = GraphCapped( Time(), startTime, endTime, startRadius, endRadius )
		fissureData.currentRadius = radius
		int idealFx = GetFissureFXIDForRadius( radius )
		if ( idealFx != fissureFXID )
		{
			fissureFXID = idealFx
			EffectStop( e["fx"], true, true )
			fissureFX = StartParticleEffectOnEntity( zoneEnt, fissureFXID, FX_PATTACH_ABSORIGIN_FOLLOW, -1 )
			e["fx"] = fissureFX
		}

		fwdToPlayer = Normalize( < player.GetOrigin().x, player.GetOrigin().y, 0 > - < fissurePos.x, fissurePos.y, 0 > )
		circleEdgePos = fissurePos + ( fwdToPlayer * radius )
		circleEdgePos.z = player.EyePosition().z

		if ( Time() > startTime && Time() < endTime )
		{
			//
			currentSoundPlaying = ManageFissureSound( circleEdgePos, fissureSoundEnt, endRadius, currentSoundPlaying, soundState, false )
		}
		else
		{
			//
			currentSoundPlaying = ManageFissureSound( circleEdgePos, fissureSoundEnt, endRadius, currentSoundPlaying, eFissureSoundState.IDLE, false )
		}

		EffectSetControlPointVector( e["fx"], 1, < FissureFX_GetScaledRadius( radius ), 0, 0 > )
		WaitFrame()
	}
	//
	fissureData.endRadius = endRadius
	thread FissureIdle_Thread( zoneEnt, fissureData, extraEnt )
}

//
void function FissureEnd_Thread( entity zoneEnt, float closeTime, FissureData  fissureData, entity extraEnt = null )
{
	entity player = GetLocalViewPlayer()
	if ( !IsValid( player ) || !IsValid( zoneEnt ) )
		return

	if ( IsValid( extraEnt ) )
	{
		extraEnt.EndSignal( "OnDestroy" )
	}
	player.EndSignal( "OnDestroy" )
	zoneEnt.EndSignal( "OnDestroy" )

	float shrinkStartTime = Time()
	float shrinkEndTime = Time() + closeTime

	float FXDelay = max( FISSURE_BEAMFX_END_DELAY, FISSURE_BEAMEND_FX_START_DELAY )
	Assert( FXDelay <= FISSURE_ENTITY_DESTROY_DELAY, format( "RingCollapseMode: FISSURE_BEAMFX_END_DELAY or FISSURE_BEAMEND_FX_START_DELAY is too long, be  %f seconds or less", FISSURE_ENTITY_DESTROY_DELAY ) )

	float startRadius = fissureData.currentRadius
	vector fissurePos = zoneEnt.GetOrigin()
	vector fissureBeamPos = fissurePos + < 0, 0, FISSURE_GROUNDPOSITION_VERTICAL_OFFSET >

	int fissureFXID = GetFissureFXIDForRadius( startRadius )
	int fissureFX   = StartParticleEffectOnEntity( zoneEnt, fissureFXID, FX_PATTACH_ABSORIGIN_FOLLOW, -1 )
	int fissureBeamFXID = GetParticleSystemIndex( FISSURE_BEAM_FX )
	int fissureBeamFX = StartParticleEffectOnEntity( zoneEnt, fissureBeamFXID, FX_PATTACH_ABSORIGIN_FOLLOW, -1 )
	int fissureBeamEndFXID = GetParticleSystemIndex( FISSURE_BEAM_END_FX )
	int fissureBeamEndFX = -1

	table<string, int> e
	e["fx"] <- fissureFX
	e["fbfx"] <- fissureBeamFX
	e["fbefx"] <- fissureBeamEndFX

	EffectSetControlPointVector( e["fbfx"], 2, fissureBeamPos )
	entity fissureSoundEnt = CreateClientSideAmbientGeneric( fissurePos, GetFissureSoundForSize( startRadius, eFissureSoundState.IDLE ), GetFissureSFXCullingDist( startRadius ) )
	fissureSoundEnt.SetEnabled( false )
	entity beamSoundEnt = CreateClientSideAmbientGeneric( fissureBeamPos, SOUND_FISSURE_BEAM, FISSURE_BEAM_IDLE_SFX_CULLING_DIST )
	beamSoundEnt.SetEnabled( false )

	OnThreadEnd(
		function() : ( e, zoneEnt, fissureSoundEnt, beamSoundEnt )
		{
			if ( IsValid( fissureSoundEnt ) )
			{
				fissureSoundEnt.SetEnabled( false )
				fissureSoundEnt.Destroy()
			}

			if ( IsValid( beamSoundEnt ) )
			{
				beamSoundEnt.SetEnabled( false )
				beamSoundEnt.Destroy()
			}

			foreach( effect in e )
			{
				if ( effect != -1 )
					EffectStop( effect, true, true )
			}

			if ( zoneEnt in file.fissureDataByFissureWPEnts )
			{
				delete file.fissureDataByFissureWPEnts[zoneEnt]
				file.fissureWPEnts.fastremovebyvalue( zoneEnt )
			}
		}
	)
	string currentBeamSoundPlaying = ""
	string currentSoundPlaying = ""
	float radius = startRadius
	vector fwdToPlayer
	vector circleEdgePos
	bool haveEndFXDelaysTriggered = false
	bool haveBeamEndFXTriggered = false
	bool haveBeamConstFXBeenKilled = false
	bool isFissureClosing = true
	float beamEndFXStartTime = -1
	float beamFXEndTime = -1

	//
	while ( isFissureClosing )
	{
		if ( !IsValid( player ) || !IsValid( zoneEnt ) )
			break

		if ( Time() >= shrinkEndTime && haveBeamEndFXTriggered && haveBeamConstFXBeenKilled )
			isFissureClosing = false

		radius = GraphCapped( Time(), shrinkStartTime, shrinkEndTime, startRadius, 1 )
		fissureData.currentRadius = radius
		int idealFx = GetFissureFXIDForRadius( radius )
		if ( idealFx != fissureFXID )
		{
			fissureFXID = idealFx
			EffectStop( e["fx"], true, true )
			fissureFX = StartParticleEffectOnEntity( zoneEnt, fissureFXID, FX_PATTACH_ABSORIGIN_FOLLOW, -1 )
			e["fx"] = fissureFX
		}

		//
		if ( radius <= FISSURE_START_RADIUS && !haveEndFXDelaysTriggered )
		{
			beamEndFXStartTime = Time() + FISSURE_BEAMEND_FX_START_DELAY
			beamFXEndTime = Time() + FISSURE_BEAMFX_END_DELAY
			haveEndFXDelaysTriggered = true
		}

		//
		if ( !haveBeamEndFXTriggered && beamEndFXStartTime != -1 && Time() >= beamEndFXStartTime )
		{
			fissureBeamEndFX = StartParticleEffectOnEntity( zoneEnt, fissureBeamEndFXID, FX_PATTACH_ABSORIGIN_FOLLOW, -1 )
			e["fbefx"] = fissureBeamEndFX
			EffectSetControlPointVector( e["fbefx"], 2, fissureBeamPos )

			if ( IsValid( beamSoundEnt ) )
				currentBeamSoundPlaying = ManageFissureBeamSound( fissureBeamPos, player.GetOrigin(), beamSoundEnt, currentBeamSoundPlaying, false, true )

			if ( IsValid( fissureSoundEnt ) )
				currentSoundPlaying = ManageFissureSound( circleEdgePos, fissureSoundEnt, radius, currentSoundPlaying, eFissureSoundState.SHRINKING, true )

			haveBeamEndFXTriggered = true
		}

		//
		if ( !haveBeamConstFXBeenKilled && beamFXEndTime != -1 && Time() >= beamFXEndTime )
		{
			if ( e["fbfx"] != -1 )
				EffectStop( e["fbfx"], true, true )
			haveBeamConstFXBeenKilled = true
		}

		fwdToPlayer = Normalize( < player.GetOrigin().x, player.GetOrigin().y, 0 > - < fissurePos.x, fissurePos.y, 0 > )
		circleEdgePos = fissurePos + ( fwdToPlayer * radius )
		circleEdgePos.z = player.EyePosition().z

		if ( !haveBeamEndFXTriggered )
		{
			currentSoundPlaying = ManageFissureSound( circleEdgePos, fissureSoundEnt, radius, currentSoundPlaying, eFissureSoundState.SHRINKING, false )
			currentBeamSoundPlaying = ManageFissureBeamSound( fissureBeamPos, player.GetOrigin(), beamSoundEnt, currentBeamSoundPlaying, false, false )
		}
		EffectSetControlPointVector( e["fx"], 1, < FissureFX_GetScaledRadius( radius ), 0, 0 > )
		WaitFrame()
	}

	//
	if ( currentSoundPlaying != "" )
		fissureSoundEnt.SetEnabled( false )

	if ( currentBeamSoundPlaying != "" )
		beamSoundEnt.SetEnabled( false )

	if ( IsValid( fissureSoundEnt ) )
		fissureSoundEnt.Destroy()

	//
	if ( e["fx"] != -1 )
		EffectStop( e["fx"], true, true )

	//
	wait FISSURE_ENTITY_DESTROY_DELAY
}

//
//
string function ManageFissureSound( vector circleEdgePos, entity fissureSoundEnt, float fissureRadius, string currentSoundPlaying, int state, bool shouldKillSFX )
{
	//
	if ( PositionIsInMapBounds( circleEdgePos ) && !shouldKillSFX )
	{
		fissureSoundEnt.SetOrigin( circleEdgePos )
		string soundToPlay = GetFissureSoundForSize( fissureRadius, state )

		if ( currentSoundPlaying != soundToPlay )
		{
			if ( currentSoundPlaying != "" )
				fissureSoundEnt.SetEnabled( false )

			if ( soundToPlay != "" )
				fissureSoundEnt.SetSoundName( soundToPlay )

			fissureSoundEnt.SetEnabled( true )
			currentSoundPlaying = soundToPlay
		}
	}
	else
	{
		if ( currentSoundPlaying != "" ) //
			fissureSoundEnt.SetEnabled( false )

		currentSoundPlaying = ""
	}

	return currentSoundPlaying
}

//
string function ManageFissureBeamSound( vector beamPos, vector playerPos, entity beamSoundEnt, string currentSoundPlaying, bool shouldPlayStartSFX, bool shouldPlayEndSFX )
{
	if ( !PositionIsInMapBounds( beamPos ) )
	{
		if ( currentSoundPlaying != "" )
			beamSoundEnt.SetEnabled( false )

		currentSoundPlaying = ""
	}
	else
	{
		//
		if ( shouldPlayStartSFX && RingCollapseMode_IsPositionWithinRadius( FISSURE_BEAM_SFX_CULLING_DIST, 0, beamPos, playerPos ) )
		{
			EmitSoundAtPosition( TEAM_UNASSIGNED, beamPos, SOUND_FISSURE_BEAM_START )
		}
		else if ( shouldPlayEndSFX && RingCollapseMode_IsPositionWithinRadius( FISSURE_BEAM_SFX_CULLING_DIST, 0, beamPos, playerPos ) )
		{
			EmitSoundAtPosition( TEAM_UNASSIGNED, beamPos, SOUND_FISSURE_BEAM_END )
		}

		//
		beamSoundEnt.SetOrigin( beamPos )

		if ( currentSoundPlaying != SOUND_FISSURE_BEAM )
		{
			if ( currentSoundPlaying != "" )
				beamSoundEnt.SetEnabled( false )

			beamSoundEnt.SetSoundName( SOUND_FISSURE_BEAM )
			beamSoundEnt.SetEnabled( true )
			currentSoundPlaying = SOUND_FISSURE_BEAM
		}
	}

	return currentSoundPlaying
}

//
float function GetFissureSFXCullingDist( float fissureRadius )
{
	foreach ( radius, cullingDist in file.sfxCullingDistByRadius )
	{
		if ( radius < fissureRadius )
			return cullingDist
	}

	Assert( 0, format( "fissureRadius %d, is not a valid value for determining sfxCullingDistByRadius", fissureRadius ) )

	return 0
}

//
bool function CL_RingCollapseMode_IsPositionInRingFissure( vector position )
{
	foreach ( zoneEnt in file.fissureWPEnts )
	{
		if( IsValid( zoneEnt ) && zoneEnt in file.fissureDataByFissureWPEnts )
		{
			FissureData fissureData = file.fissureDataByFissureWPEnts[zoneEnt]
			if ( RingCollapseMode_IsPositionWithinRadius( fissureData.currentRadius, 0, position, fissureData.position ) )
				return true
		}
	}
	return false
}

//
int function GetFissureFXIDForRadius( float radius )
{
	array<int> fxIdx     = [ GetParticleSystemIndex( FISSURE_FX_SMALL_PRECISE ), GetParticleSystemIndex( FISSURE_FX_MEDIUM_PRECISE ), GetParticleSystemIndex( FISSURE_FX_LARGE_PRECISE ) ]

	int idealIdx
	if ( radius <= FISSURE_FX_SMALL_RADIUS )
	{
		idealIdx = 2
	}
	else if ( radius <= FISSURE_FX_MEDIUM_RADIUS )
	{
		idealIdx = 1
	}
	else
	{
		idealIdx = 0
	}

	return fxIdx[ idealIdx ]
}

//
float function FissureFX_GetScaledRadius( float radius )
{
	Assert( FISSURE_FX_RADIUS_SCALE > 0, "RingCollapseMode: FISSURE_FX_RADIUS_SCALE is 0 or lower, it needs to be higher than 0" )
	return	radius / FISSURE_FX_RADIUS_SCALE
}

//
string function GetFissureSoundForSize( float radius, int state )
{
	table <float, string> soundTable = file.idleSoundByFissureRadius

	switch ( state )
	{
		case eFissureSoundState.EXPANDING:
			soundTable = file.expandSoundByFissureRadius
			break
		case eFissureSoundState.SHRINKING:
			soundTable = file.shrinkSoundByFissureRadius
			break
		default:
			break
	}

	foreach ( distance, sound in soundTable )
	{
		if ( distance < radius )
			return sound
	}
	return ""
}

//
void function RingCollapseMode_ServerCallback_DestroyFissure( entity fissureWPZoneEntToDestroy, entity fissureTimerToDestroy )
{
	entity player = GetLocalViewPlayer()
	if ( !IsValid( player ) || !IsValid( fissureWPZoneEntToDestroy ) )
		return

	Signal( fissureWPZoneEntToDestroy, "DestroyFissure" )
	if ( IsValid( fissureTimerToDestroy ) )
		Signal( fissureTimerToDestroy, "DestroyFissure" )
}

//
//
//
//
//

//
//
void function FissureTimerStart_Thread( entity wp, float startRadius, float endRadius, float warningEndTime, float closeTime, float growEndTime, int state, bool showLifeTimeTimer )
{
	entity player = GetLocalViewPlayer()
	if ( !IsValid( player ) || !IsValid( wp ) )
		return

	wp.SetDoDestroyCallback( true )
	wp.EndSignal( "DestroyFissure" )
	wp.EndSignal( "OnDestroy" )
	player.EndSignal( "OnDestroy" )

	float width  = 220
	float height = 220
	vector right = <0, 1, 0> * height * 0.5
	vector fwd   = <1, 0, 0> * width * 0.5 * -1.0
	vector org   = <0, 0, 0>
	vector wpPos = wp.GetOrigin()

	var topo = RuiTopology_CreatePlane( wpPos - right * 0.5 - fwd * 0.5, fwd, right, true )
	RuiTopology_SetParent( topo, wp )

	float startTime = Time()
	var ownedRui = CreateCockpitRui( $"ui/gamemode_ringcollapse_fissure_timer_world.rpak", 1 )
	asset gameModeEmblem = ASSET_TIMER_EMBLEM
                           
		if ( GetCurrentPlaylistName().find( "flareup" ) != -1 )
			gameModeEmblem = ASSET_TIMER_EMBLEM_WAR_GAMES
       
	RuiSetAsset( ownedRui, "emblem", gameModeEmblem  )
	RuiTrackFloat3( ownedRui, "worldPos", wp, RUI_TRACK_ABSORIGIN_FOLLOW )
	RuiSetGameTime( ownedRui, "warnEndTime", warningEndTime )
	RuiSetGameTime( ownedRui, "warnStartTime", startTime )
	RuiSetBool( ownedRui, "isTimerVisible", true )
	string statusText = Localize( "#FISSURE_TIMER_STATUS_INCOMING" )
	RuiSetString( ownedRui, "statusText", statusText )
	RuiSetFloat(ownedRui, "statusTextScale", GetFissureTimerStatusTextScale( statusText.len() ) )
	//
	RuiSetInt( ownedRui, "state", eFissureState.STARTING )

	//
	if ( state == eFissureState.ENDING )
		return

	//
	OnThreadEnd(
		function() : ( wp, ownedRui, topo, closeTime, wpPos, endRadius )
		{
			thread FissureTimerEnd_Thread( wp, ownedRui, topo, closeTime, wpPos, endRadius )
		}
	)

	//
	if ( state == eFissureState.STARTING )
	{
		//
		if ( Time() < warningEndTime )
		{
			//
			while ( Time() < warningEndTime )
			{
				if ( !IsValid( player ) || !IsValid( wp ) )
					return
				SetFissureTimerVisibility( player, ownedRui, wpPos, endRadius ) //
				WaitFrame()
			}
		}

		//
		RuiSetBool( ownedRui, "isTimerVisible", false )
		statusText = Localize( "#FISSURE_TIMER_STATUS_OPENING" )
		RuiSetString( ownedRui, "statusText", statusText )
		RuiSetFloat(ownedRui, "statusTextScale", GetFissureTimerStatusTextScale( statusText.len() ) )
		RuiSetInt( ownedRui, "state", eFissureState.IDLE )
	//

		while ( Time() < growEndTime )
		{
			if ( !IsValid( player ) || !IsValid( wp ) )
				return
			SetFissureTimerVisibility( player, ownedRui, wpPos, endRadius ) //
			WaitFrame()
		}
	}
	//
	if ( state == eFissureState.GROWING || state == eFissureState.SHRINKING )
	{
		thread FissureTimerChangeSize_Thread( wp, ownedRui, topo, wpPos, endRadius, growEndTime, showLifeTimeTimer, state )
	}
	else //
	{
		thread FissureTimerIdle_Thread( wp, ownedRui, topo, wpPos, endRadius, showLifeTimeTimer )
	}

	//
	for ( ;; )
	{
		if ( !IsValid( player ) || !IsValid( wp ) )
			break

		table updatedTimerData = wp.WaitSignal( "ChangeFissureSize" )
		float oldRadius = expect float( updatedTimerData.oldRadius )
		float newEndRadius = expect float( updatedTimerData.newEndRadius )
		float newEndTime = expect float( updatedTimerData.newEndTime )
		waitthread FissureTimerChangeSize_Thread( wp, ownedRui, topo, wpPos, newEndRadius, newEndTime, showLifeTimeTimer, state )
	}
}

//
void function FissureTimerIdle_Thread( entity wp, var ownedRui, var topo, vector wpPos, float endRadius, bool showLifeTimeTimer )
{
	entity player = GetLocalViewPlayer()
	if ( !IsValid( player ) || !IsValid( wp ) )
		return

	wp.SetDoDestroyCallback( true )
	wp.EndSignal( "DestroyFissure" )
	wp.EndSignal( "OnDestroy" )
	wp.EndSignal( "ChangeFissureSize" )
	player.EndSignal( "OnDestroy" )

	//
	if ( showLifeTimeTimer )
	{
		float startTime = Time()
		float endTime = Time() + file.fissureLifetime

		RuiSetGameTime( ownedRui, "warnEndTime", endTime )
		RuiSetGameTime( ownedRui, "warnStartTime", startTime )
	}
	RuiSetBool( ownedRui, "isTimerVisible", showLifeTimeTimer )
	string statusText = Localize( "#FISSURE_TIMER_STATUS_ACTIVE" )
	RuiSetString( ownedRui, "statusText", statusText )
	RuiSetFloat(ownedRui, "statusTextScale", GetFissureTimerStatusTextScale( statusText.len() ) )
	RuiSetInt( ownedRui, "state", eFissureState.IDLE )
//

	for ( ;; )
	{
		if ( !IsValid( player ) || !IsValid( wp ) )
			return

		SetFissureTimerVisibility( player, ownedRui, wpPos, endRadius ) //
		WaitFrame()
	}
}

//
void function FissureTimerChangeSize_Thread( entity wp, var ownedRui, var topo, vector wpPos, float endRadius, float endTime, bool showLifeTimeTimer, int state )
{
	entity player = GetLocalViewPlayer()
	if ( !IsValid( player ) || !IsValid( wp ) )
		return

	wp.SetDoDestroyCallback( true )
	wp.EndSignal( "DestroyFissure" )
	wp.EndSignal( "OnDestroy" )
	player.EndSignal( "OnDestroy" )

	float startTime = Time()
	float warnEndTime = startTime + file.fissureWarningTime

	RuiSetGameTime( ownedRui, "warnEndTime", warnEndTime )
	RuiSetGameTime( ownedRui, "warnStartTime", startTime )
	string statusText
	if ( state == eFissureState.GROWING )
	{
		statusText = Localize( "#FISSURE_TIMER_STATUS_EXPANDING" )
		RuiSetInt( ownedRui, "state", eFissureState.GROWING )
	}
	else
	{
		statusText = Localize( "#FISSURE_TIMER_STATUS_SHRINKING" )
		RuiSetInt( ownedRui, "state", eFissureState.SHRINKING )
	}
	RuiSetString( ownedRui, "statusText", statusText )
	RuiSetFloat(ownedRui, "statusTextScale", GetFissureTimerStatusTextScale( statusText.len() ) )
//
	RuiSetBool( ownedRui, "isTimerVisible", true )

	//
	while ( Time() < warnEndTime )
	{
		if ( !IsValid( player ) || !IsValid( wp ) )
			return
		SetFissureTimerVisibility( player, ownedRui, wpPos, endRadius ) //
		WaitFrame()
	}

	//
	RuiSetBool( ownedRui, "isTimerVisible", false )
	statusText = Localize( "#FISSURE_TIMER_STATUS_ACTIVE" )
	RuiSetString( ownedRui, "statusText", statusText )
	RuiSetFloat(ownedRui, "statusTextScale", GetFissureTimerStatusTextScale( statusText.len() ) )
	RuiSetInt( ownedRui, "state", eFissureState.IDLE )
//
	//
	while ( Time() < endTime )
	{
		if ( !IsValid( player ) || !IsValid( wp ) )
			return

		SetFissureTimerVisibility( player, ownedRui, wpPos, endRadius ) //
		WaitFrame()
	}
	RuiSetBool( ownedRui, "isVisible", false )
	thread FissureTimerIdle_Thread( wp, ownedRui, topo, wpPos, endRadius, showLifeTimeTimer )
}

//
void function FissureTimerEnd_Thread( entity wp, var ownedRui, var topo, float closeTime, vector wpPos, float endRadius )
{
	entity player = GetLocalViewPlayer()

	OnThreadEnd(
		function() : ( topo, ownedRui )
		{
			RuiDestroy( ownedRui )
			RuiTopology_Destroy( topo )
		}
	)
	if ( !IsValid( wp ) )
		return

	wp.SetDoDestroyCallback( true )
	wp.EndSignal( "OnDestroy" )

	RuiSetBool( ownedRui, "isTimerVisible", false )
	string statusText = Localize( "#FISSURE_TIMER_STATUS_CLOSING" )
	RuiSetString( ownedRui, "statusText", statusText )
	RuiSetFloat(ownedRui, "statusTextScale", GetFissureTimerStatusTextScale( statusText.len() ) )
	RuiSetInt( ownedRui, "state", eFissureState.ENDING )
//
	float startTime = Time()
	float endTime = startTime + closeTime
	RuiSetGameTime( ownedRui, "warnEndTime", endTime )
	RuiSetGameTime( ownedRui, "warnStartTime", startTime )

	while ( Time() < endTime )
	{
		if ( !IsValid( player ) || !IsValid( wp ) )
			break

		SetFissureTimerVisibility( player, ownedRui, wpPos, endRadius ) //
		WaitFrame()
	}
}

//
void function SetFissureTimerVisibility( entity player, var ownedRui, vector wpPos, float endRadius )
{
	vector playerPos = < player.GetOrigin().x, player.GetOrigin().y, 0 >
	bool isInRange = RingCollapseMode_IsPositionWithinRadius( ( FISSURE_WARN_TIMER_DRAW_DIST + endRadius ), 0, playerPos, wpPos )
	bool isFar = !RingCollapseMode_IsPositionWithinRadius( ( FISSURE_WARN_TIMER_ISFAR_DIST + endRadius ), 0, playerPos, wpPos )
	bool canTrace = false

	//
	if ( isInRange )
	{
		TraceResults results = TraceLine( player.EyePosition(), wpPos, [player], TRACE_MASK_VISIBLE, TRACE_COLLISION_GROUP_NONE )
		canTrace = results.fraction > 0.9
		if ( !canTrace )
		{
			wpPos = < wpPos.x, wpPos.y, player.EyePosition().z >
			results = TraceLine( player.EyePosition(), wpPos, [player], TRACE_MASK_VISIBLE, TRACE_COLLISION_GROUP_NONE )
			canTrace = results.fraction > 0.9
		}
	}
	//
	RuiSetBool( ownedRui, "isVisible", ( canTrace && isInRange ) )
	RuiSetBool( ownedRui, "isFar", isFar )
}

//
float function GetFissureTimerStatusTextScale( int textLength )
{
	return float( ( textLength * STATUS_TEXT_SCALE_PER_CHAR ) + STATUS_TEXT_SCALE_BUFFER_SPACE )
}
#endif //

