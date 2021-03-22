global function PrivateMatch_Init
global function IsPrivateMatchLobby
global function PrivateMatch_RegisterNetworking
global function PrivateMatch_GetSelectedPlaylistName

#if(CLIENT)
global function PrivateMatch_CanAssignPlayers
global function PrivateMatch_CanAssignSelf
global function PrivateMatch_CanRenameTeam

//
global function PrivateMatch_IsObserverHighlightEnabled
#endif

#if(false)




//
























#endif


#if(CLIENT)
global function PrivateMatch_ClientFrame
global function PrivateMatch_GetPlayerTeamStats

global function ServerCallback_EnableGameStatusMenu
global function ServerCallback_PrivateMatch_ManageHighlights
global function PrivateMatch_OpenGameStatusMenu
global function PrivateMatch_ToggleHighlights

//
global function ServerCallback_GameStatus_PlayerButton_Update
#endif


const string MAX_PLAYERS_PLAYLIST_VAR = "max_players"
const string MAX_TEAMS_PLAYLIST_VAR = "max_teams"

const string WAYPOINTTYPE_PLAYERTEAMSTATS = "team_stats"

const int WP_STRING_INDEX_PLAYERNAME = 0
const int WP_STRING_INDEX_TEAMNAME = 1

const int WP_INT_INDEX_PLAYERINDEX = 0
const int WP_INT_INDEX_PLACEMENT = 1
const int WP_INT_INDEX_TEAMINDEX = 2
const int WP_INT_INDEX_PLAYERKILLS = 3
const int WP_INT_INDEX_PLAYERDAMAGE = 4
const int WP_INT_INDEX_SURVIVALTIME = 5
const int WP_INT_INDEX_PLAYERASSISTS = 6

global const int TEAM_SPECTATOR_MAX_PLAYERS = 10

const asset PM_CHAMPION_SCREEN = $"ui/private_match_champion_screen.rpak"

//
const string NV_OBSERVER_EVENT_INDEX = "PrivateMatch_ObserverEvents"
const string NV_OBSERVER_HIGHLIGHT_ENABLED = "PrivateMatch_Observer_HighlightEnabled"
const float PM_OBSERVER_HIGHLIGHT_TOGGLE_DEBOUNCE = 0.5

global struct RosterStruct
{
	var           headerPanel
	var           listPanel
	int           teamIndex
	int           teamSize
	int           teamDisplayNumber
	array<entity> playerRoster

	array<var>      _listButtons

	array<PrivateMatchStatsStruct> playerPlacementData
}

struct
{
	string		selectedPlaylist = ""
	int			playlistMaxTeams
	int			playlistTeamSize
	int			lastObserverCommand = -1
	PrivateMatchChatConfigStruct chatConfig
	
	table< int, PrivateMatchStatsStruct > privateMatchStats

	array<int> teamFinalPlacementArray = []
	
	table signalDummy = {}
} file



void function PrivateMatch_Init()
{
	array<string> privateMatchPlaylists = GetVisiblePlaylistNames( true )

	#if(false)










//












//



#endif //

	#if(CLIENT)
		Waypoints_RegisterCustomType( WAYPOINTTYPE_PLAYERTEAMSTATS, InstancePlayerTeamStats )
		AddOnSpectatorTargetChangedCallback( OnSpectatorTargetChanged )
		RegisterConCommandTriggeredCallback( "toggle_observer_highlight", PrivateMatch_ToggleHighlights )
	#endif
		
	#if(CLIENT)
	
		//
		Remote_RegisterServerFunction( "ClientCallback_PrivateMatchKickPlayer", "entity" )
		Remote_RegisterServerFunction( "ClientCallback_PrivateMatchSetPlayerTeam", "entity", "int", TEAM_UNASSIGNED, TEAM_MULTITEAM_LAST )
		Remote_RegisterServerFunction( "ClientCallback_PrivateMatchStartMatch" )
		Remote_RegisterServerFunction( "ClientCallback_PrivateMatchToggleReady" )
		Remote_RegisterServerFunction( "ClientCallback_PrivateMatchToggleAssignSelf" )
		Remote_RegisterServerFunction( "ClientCallback_PrivateMatchToggleTeamRenaming" )
		Remote_RegisterServerFunction( "ClientCallback_PrivateMatchToggleAdminOnlyChat" )
		Remote_RegisterServerFunction( "ClientCallback_PrivateMatchSetTeamName", "int", 0, INT_MAX, "string" )
		Remote_RegisterServerFunction( "ClientCallback_PrivateMatchSetPlaylist", "string" )
		Remote_RegisterServerFunction( "ClientCallback_PrivateMatchCycleAdminChatMode" )
		Remote_RegisterServerFunction( "ClientCallback_PrivateMatchToggleSpectatorChat" )
		Remote_RegisterServerFunction( "ClientCallback_PrivateMatchEndMatchEarly" )
	
		//
		Remote_RegisterServerFunction( "ClientCallback_PrivateMatchChangeObserverTarget", "entity" )
		Remote_RegisterServerFunction( "ClientCallback_PrivateMatchToggleObserverHighlights" )
		Remote_RegisterServerFunction( "ClientCallback_PrivateMatchReportObserverTargetChanged" )
		Remote_RegisterServerFunction( "ClientCallback_RefreshObserverHighlights" )		
	#endif
	
}

void function PrivateMatch_RegisterNetworking()
{
	RegisterNetworkedVariable( "canAssignPlayers", SNDC_GLOBAL, SNVT_BOOL, false )
	RegisterNetworkedVariable( "canAssignSelf", SNDC_GLOBAL, SNVT_BOOL, true )
	RegisterNetworkedVariable( "adminOnlyChat", SNDC_GLOBAL, SNVT_BOOL, true )
	RegisterNetworkedVariable( "adminChatMode", SNDC_GLOBAL, SNVT_INT, 0 )
	RegisterNetworkedVariable( "adminSpectatorChat", SNDC_GLOBAL, SNVT_BOOL, true )
	RegisterNetworkedVariable( "canPlayersRenameTeams", SNDC_GLOBAL, SNVT_BOOL, false )
	RegisterNetworkedVariable( "isReady", SNDC_PLAYER_GLOBAL, SNVT_BOOL, false )
	RegisterNetworkedVariable( "selectedPlaylistIndex", SNDC_GLOBAL, SNVT_INT, -1 )
	RegisterNetworkedVariable( "startCountdown", SNDC_GLOBAL, SNVT_INT, -1 )

	Remote_RegisterClientFunction( "ServerCallback_EnableGameStatusMenu", "bool" )
	Remote_RegisterClientFunction( "ServerCallback_GameStatus_PlayerButton_Update", "entity" )
	Remote_RegisterClientFunction( "ServerCallback_PrivateMatch_ManageHighlights" )
	Remote_RegisterClientFunction( "ServerCallback_PrivateMatch_PopulateGameStatusMenu" )
	RegisterNetworkedVariable( NV_OBSERVER_EVENT_INDEX, SNDC_GLOBAL, SNVT_UNSIGNED_INT, 0 )
	RegisterNetworkedVariable( NV_OBSERVER_HIGHLIGHT_ENABLED, SNDC_PLAYER_GLOBAL, SNVT_BOOL, false )

	#if(CLIENT)
		RegisterNetworkedVariableChangeCallback_int( "selectedPlaylistIndex", OnSelectedPlaylistIndexChanged )
		RegisterNetworkedVariableChangeCallback_int( "startCountdown", OnStartCountdownChanged )

		RegisterNetworkedVariableChangeCallback_int( NV_OBSERVER_EVENT_INDEX, PrivateMatch_Observer_EventIndexChanged )
		RegisterNetworkedVariableChangeCallback_bool( NV_OBSERVER_HIGHLIGHT_ENABLED, ObserverHighlightEnableChanged )

		RegisterNetVarIntChangeCallback( "gameState", PrivateMatch_OnGameStateChanged )
	#endif
}


#if(CLIENT)
void function PrivateMatch_ClientFrame()
{
	PerfStart( PerfIndexClient.PrivateLobbyThread )
	array<entity> players = GetPlayerArrayIncludingSpectators()

	table< int, array< entity > > teamPlayersMap
	foreach ( player in players )
	{
		if ( !(player.GetTeam() in teamPlayersMap) )
			teamPlayersMap[player.GetTeam()] <- []

		teamPlayersMap[player.GetTeam()].append( player )
	}

	PrivateMatch_TeamRosters_Update( teamPlayersMap )

	PerfEnd( PerfIndexClient.PrivateLobbyThread )
}


void function InstancePlayerTeamStats( entity wp )
{
	PrivateMatchStatsStruct privateMatchStats
	privateMatchStats.platformUid = wp.GetWaypointGroupName()
	privateMatchStats.playerName = wp.GetWaypointString( WP_STRING_INDEX_PLAYERNAME )
	privateMatchStats.teamName = wp.GetWaypointString( WP_STRING_INDEX_TEAMNAME )
	privateMatchStats.teamPlacement = wp.GetWaypointInt( WP_INT_INDEX_PLACEMENT )
	privateMatchStats.teamNum = wp.GetWaypointInt( WP_INT_INDEX_TEAMINDEX )
	privateMatchStats.kills = wp.GetWaypointInt( WP_INT_INDEX_PLAYERKILLS )
	privateMatchStats.damageDealt = wp.GetWaypointInt( WP_INT_INDEX_PLAYERDAMAGE )
	privateMatchStats.survivalTime = wp.GetWaypointInt( WP_INT_INDEX_SURVIVALTIME )
	privateMatchStats.assists = wp.GetWaypointInt( WP_INT_INDEX_PLAYERASSISTS )

	int playerIndex = wp.GetWaypointInt( WP_INT_INDEX_PLAYERINDEX )
	file.privateMatchStats[playerIndex] <- privateMatchStats
}


PrivateMatchStatsStruct ornull function PrivateMatch_GetPlayerTeamStats( int playerIndex )
{
	if ( !(playerIndex in file.privateMatchStats) )
		return null

	return file.privateMatchStats[playerIndex]
}

void function ServerCallback_EnableGameStatusMenu( bool doEnable )
{
	RunUIScript( "EnablePrivateMatchGameStatusMenu", doEnable )

	if ( doEnable == false )
		RunUIScript( "ClosePrivateMatchGameStatusMenu", null )
}

void function PrivateMatch_OpenGameStatusMenu()
{
	if ( GetLocalClientPlayer().GetTeam() == TEAM_SPECTATOR )
		RunUIScript( "OpenPrivateMatchGameStatusMenu", null )
}

void function PrivateMatch_ToggleHighlights( entity player )
{
	if ( player.GetTeam() == TEAM_SPECTATOR )
	{
		Remote_ServerCallFunction( "ClientCallback_PrivateMatchToggleObserverHighlights" )
	}
}

#endif //


void function PrivateMatch_SetUpTeamRosters( string playlistName )
{
	file.selectedPlaylist = playlistName
	#if(false)

#endif

	int maxPlayers = GetPlaylistVarInt( file.selectedPlaylist, MAX_PLAYERS_PLAYLIST_VAR, 60 )
	file.playlistMaxTeams = GetPlaylistVarInt( file.selectedPlaylist, MAX_TEAMS_PLAYLIST_VAR, 20 )
	file.playlistTeamSize = maxPlayers / file.playlistMaxTeams

	#if(false)










#endif

	//
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


































































































/*




*/





































#endif //


string function PrivateMatch_GetSelectedPlaylistName()
{
	int playlistIndex = GetGlobalNetInt( "selectedPlaylistIndex" )
	if ( playlistIndex > 0 )
	{
		string ornull playlistName = GetPlaylistName( playlistIndex )
		return playlistName != null ? expect string( playlistName ) : ""
	}

	return ""
}


bool function IsPrivateMatchLobby()
{
	#if(UI)
		//
		if ( !IsConnected() )
			return false
	#endif

	if ( !IsPrivateMatch() )
	{
		if ( GetCurrentPlaylistName() != "private_match" ) //
			return false
	}

	string mapName

	#if(UI)
		mapName = GetActiveLevel()
	#else
		mapName = GetMapName()
	#endif

	return IsLobbyMapName( mapName )
}

#if(CLIENT)
bool function PrivateMatch_CanAssignPlayers( entity player )
{
	if ( player.HasMatchAdminRole() )
		return true

	return GetGlobalNetBool( "canAssignPlayers" )
}

bool function PrivateMatch_CanAssignSelf( entity player )
{
	if ( player.HasMatchAdminRole() )
		return true

	return GetGlobalNetBool( "canAssignSelf" )
}

bool function PrivateMatch_CanRenameTeam( entity player, int teamIndex )
{
	if ( player.HasMatchAdminRole() )
		return true

	if ( player.GetTeam() != teamIndex )
		return false

	return GetGlobalNetBool( "canPlayersRenameTeams" )
}
#endif

#if(CLIENT)
void function OnSelectedPlaylistIndexChanged( entity player, int oldIndex, int newIndex, bool actuallyChanged )
{
	if ( !IsPrivateMatchLobby() )
		return

	printf( "PrivateMatchPlaylistDebug: Selected playlist changed. old: %i, new: %i", oldIndex, newIndex )
	RunUIScript( "PrivateMatch_RefreshPlaylistButtonName" )
}

void function OnStartCountdownChanged( entity player, int oldVal, int newVal, bool actuallyChanged )
{
	if ( !IsPrivateMatchLobby() )
		return
		
	RunUIScript( "PrivateMatch_RefreshStartCountdown", newVal )
}
#endif //

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






















































































#endif //

#if(CLIENT)
void function PrivateMatch_Observer_EventIndexChanged( entity player, int oldIndex, int newIndex, bool actuallyChanged )
{
	printf( "PMGameStatusDebug: Observer Event Occurred. Refreshing Observer Match Status Menus. (was: %i, is: %i)", oldIndex, newIndex )
	#if(CLIENT)
		if ( actuallyChanged )
		{
			array<entity> observers = GetPlayerArrayOfTeam( TEAM_SPECTATOR )

			if ( observers.len() > 0 )
				ServerCallback_PrivateMatch_PopulateGameStatusMenu()
		}
	#endif
}

bool function PrivateMatch_IsObserverHighlightEnabled( entity observer )
{
	if ( !IsValid( observer ) )
		return false

	if ( !observer.IsPlayer() )
		return false

	if ( observer.GetTeam() != TEAM_SPECTATOR )
		return false

	return observer.GetPlayerNetBool( NV_OBSERVER_HIGHLIGHT_ENABLED )
}
#endif

#if(CLIENT)
void function ServerCallback_GameStatus_PlayerButton_Update( entity player )
{
	if ( !IsValid( player ) )
		return

	var playerButton = PrivateMatch_GameStatus_GetPlayerButton( player )

	if ( playerButton == null )
		return

	thread PrivateMatch_GameStatus_ConfigurePlayerButton( playerButton, player )
}

void function ObserverHighlightEnableChanged( entity observer, bool oldValue, bool newValue, bool actuallyChanged )
{
	if ( observer.GetTeam() != TEAM_SPECTATOR )
		return

	if ( observer == GetLocalClientPlayer() )
	{
		if ( newValue == true && oldValue == false )
			Obituary_Print_Localized( Localize( "#TOURNAMENT_OBSERVER_HIGHLIGHT_ENABLED" ) )
		if ( newValue == false && oldValue == true )
			Obituary_Print_Localized( Localize( "#TOURNAMENT_OBSERVER_HIGHLIGHT_DISABLED" ) )
	}

	array<entity> players = GetPlayerArray_Alive()
	foreach ( player in players )
	{
		ManageHighlightEntity( player )
	}
}

//
//
//
//
//
//
//
//
//

void function ServerCallback_PrivateMatch_ManageHighlights()
{
	printf( "ObserverHighlightDebug: Managing observer highlights for observer %s", GetLocalClientPlayer().GetPlayerName() )

	array<entity> players = GetPlayerArray_Alive()
	foreach ( player in players )
	{
		ManageHighlightEntity( player )
	}
}

void function OnSpectatorTargetChanged( entity observer, entity prevTarget, entity newTarget )
{
	if ( observer.GetTeam() != TEAM_SPECTATOR )
		return

	if ( IsValid( newTarget ) && ( newTarget.IsPlayer() || newTarget.IsBot() ) && (newTarget != prevTarget) )
	{
		printf( "PrivateMatchObserver: Observer %s changed target to %s", observer.GetPINNucleusPid(), newTarget.GetPINNucleusPid() )
		Remote_ServerCallFunction( "ClientCallback_PrivateMatchReportObserverTargetChanged" ) 
		ShowTeamNameInHud()
	}
	else
	{
		HideTeamNameInHud()
	}

	Remote_ServerCallFunction( "ClientCallback_RefreshObserverHighlights" )
	PrivateMatch_UpdateChatTarget()

	//
}

void function PrivateMatch_OnGameStateChanged( entity player, int oldVal, int newVal, bool actuallyChanged )
{
	if ( !IsPrivateMatch() )
		return

	if ( GetGameState() == eGameState.WinnerDetermined )
	{
		SetChampionScreenRuiAsset( PM_CHAMPION_SCREEN )
		SetChampionScreenRuiAssetExtraFunc( ChampionScreenSetWinningTeamName )
	}
	else if ( GetGameState() == eGameState.Epilogue )
	{
		string winningTeam =  GameRules_GetTeamName( GetWinningTeam() ) 
		if ( winningTeam == "Unassigned" )
		{
			var messagePanel = CreateFullscreenRui( $"ui/private_match_end_early_text.rpak", RUI_SORT_SCREENFADE + 100 )
			RuiSetResolutionToScreenSize( messagePanel )
			RuiSetString( messagePanel, "message", Localize( "#TOURNAMENT_END_MATCH_EARLY" ) )
		}
	}
}

void function ChampionScreenSetWinningTeamName( var rui )
{
	if ( !IsPrivateMatch() )
		return

	RuiSetString( rui, "winningTeamName", GameRules_GetTeamName( GetWinningTeam() ).toupper() )
}
#endif //
