global function AprilFools_S8_Mode_Init
global function ShGameMode_AprilFools_S8_RegisterNetworking

#if(false)
//
#endif //

#if(CLIENT)
global function AprilFools_S8_Mode_ServerCallback_RollerAnnouncement

//
const string SOUND_ROLLERS_SPAWN = "UI_WarGames_AprilFools_AirHorn"
#endif //

const float ROLLER_GROUNDTRACE_VERTICAL_OFFSET = 30000 //
const float MIN_ROLLER_SPAWN_HEIGHT = 200.0 //
const float PLAYER_POS_ROLLER_SEARCH_RADIUS_MIN = 100.0 //
const float PLAYER_POS_ROLLER_SEARCH_RADIUS_MAX = 1000.0 //
const int MAX_ROLLERS = 160 //
const int ROLLER_RANDOM_POSITION_COUNT = 200 //
const vector INVALID_ROLLER_POS = < -1, -1, -1 >
const vector ROLLER_SPAWN_ANGLE = < 0, 0, 0 > //

struct RollerData
{
	vector position = INVALID_ROLLER_POS
	bool isValidRoller = false
}

enum eRollerLootTier
{
	INVALID,
	COMMON,
	RARE,
	EPIC,
	LEGENDARY,
}

struct {
	#if(DEV)
		bool debugDraw
	#endif //
		float rollerSpawnHeight
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
	#if(CLIENT)
		float rollerSFXHeightOffset
	#endif //
} file

//
//
//
//
//

void function AprilFools_S8_Mode_Init()
{
	if ( !IsAprilFools_S8_Mode() )
		return

	#if(DEV)
		file.debugDraw = GetCurrentPlaylistVarBool( "april_fools_s8_debug_draw", false )
	#endif //

		file.rollerSpawnHeight = GetCurrentPlaylistVarFloat( "aprilfoolss8_roller_spawn_height", 200.0 )
		Assert( file.rollerSpawnHeight >= MIN_ROLLER_SPAWN_HEIGHT, "AprilFools_S8_Mode: roller spawn height is set to a value lower than " + MIN_ROLLER_SPAWN_HEIGHT )
	#if(false)
























#endif //
	#if(CLIENT)
		file.rollerSFXHeightOffset = GetCurrentPlaylistVarFloat( "aprilfoolss8_roller_sfx_height_offset", 1500.0 )
	#endif //
}

void function ShGameMode_AprilFools_S8_RegisterNetworking()
{
	if ( !IsAprilFools_S8_Mode() )
		return

	Remote_RegisterClientFunction( "AprilFools_S8_Mode_ServerCallback_RollerAnnouncement" )
}

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











//


//
//









//












//











//





















#endif //

#if(CLIENT)
//
void function AprilFools_S8_Mode_ServerCallback_RollerAnnouncement()
{
	entity player = GetLocalViewPlayer()
	if ( !IsValid( player ) )
		return

	vector sfxPosition = player.GetOrigin() + < 0, 0 , file.rollerSFXHeightOffset >
	EmitSoundAtPosition( TEAM_UNASSIGNED, sfxPosition, SOUND_ROLLERS_SPAWN )
}
#endif //


