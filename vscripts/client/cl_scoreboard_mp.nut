untyped

global const SCOREBOARD_LOCAL_PLAYER_COLOR = <LOCAL_R / 255.0, LOCAL_G / 255.0, LOCAL_B / 255.0>
global const SCOREBOARD_PARTY_COLOR = <PARTY_R / 255.0, PARTY_G / 255.0, PARTY_B / 255.0>
const SCOREBOARD_FRIENDLY_COLOR = <FRIENDLY_R / 255.0, FRIENDLY_G / 255.0, FRIENDLY_B / 255.0>
const SCOREBOARD_FRIENDLY_SELECTED_COLOR = <0.6640625,0.7578125,0.85546875>
const SCOREBOARD_ENEMY_COLOR = <ENEMY_R / 255.0, ENEMY_G / 255.0, ENEMY_B / 255.0>
const SCOREBOARD_ENEMY_SELECTED_COLOR = <1.0,0.7019,0.592>
const SCOREBOARD_DEAD_FONT_COLOR = <0.7,0.7,0.7>
const SCOREBOARD_FFA_COLOR = <0.5,0.5,0.5>
const SCOREBOARD_BG_ALPHA = 0.35
const SCOREBOARD_EMPTY_COLOR = <0,0,0>
const SCOREBOARD_EMPTY_BG_ALPHA = 0.35

const SCOREBOARD_TITLE_HEIGHT = 50
const SCOREBOARD_SUBTITLE_HEIGHT = 35
const SCOREBOARD_FOOTER_HEIGHT = 35
const SCOREBOARD_TEAM_LOGO_OFFSET = 24
const SCOREBOARD_TEAM_LOGO_HEIGHT = 64
const SCOREBOARD_PLAYER_ROW_OFFSET = 12
const SCOREBOARD_PLAYER_ROW_HEIGHT = 35
const SCOREBOARD_PLAYER_ROW_SPACING = 2

const int MAX_TEAM_SLOTS = 16

const int MIC_STATE_NO_MIC = 0
const int MIC_STATE_HAS_MIC = 1
const int MIC_STATE_TALKING = 2
const int MIC_STATE_PARTY_HAS_MIC = 3
const int MIC_STATE_PARTY_TALKING = 4
const int MIC_STATE_MUTED = 5

global function ClScoreboardMp_Init
//
global function ScoreboardFocus
global function ScoreboardLoseFocus
global function ScoreboardSelectPrevPlayer
global function ScoreboardSelectNextPlayer
//
//
global function AddScoreboardCallback_OnShowing
global function AddScoreboardCallback_OnHiding

struct {
	bool hasFocus = false
	entity selectedPlayer
	entity prevPlayer
	entity nextPlayer

	var scoreboardBg
	var scoreboard
	var background

	array<var> scoreboardOverlays
	array<var> scoreboardElems

	table header = {
		background = null
		gametypeAndMap = null
		gametypeDesc = null
		scoreHeader = null
	}

	var footer
	var pingText

	table teamElems

	table highlightColumns

	var nameEndColumn

	table playerElems

	var scoreboardRUI

	void functionref(entity,var) scoreboardUpdateCallback
	array <void functionref()> scoreboardCallbacks_OnShowing
	array <void functionref()> scoreboardCallbacks_OnHiding
} file

void function ClScoreboardMp_Init()
{
	clGlobal.initScoreboardFunc = InitScoreboardMP
	clGlobal.showScoreboardFunc = ShowScoreboardMP
	clGlobal.hideScoreboardFunc = HideScoreboardMP
	clGlobal.scoreboardInputFunc = ScoreboardInputMP

	//
	//
}

void function ScoreboardFocus( entity player )
{
	if ( !clGlobal.isScoreboardShown || file.hasFocus )
	{
		return
	}

	if ( !ScoreboardEnabled() )
		return

	EmitSoundOnEntity( player, "menu_click" )
	file.hasFocus = true
	file.selectedPlayer = GetLocalClientPlayer()

	HudInputContext inputContext;
	inputContext.keyInputCallback = clGlobal.scoreboardInputFunc
	HudInput_PushContext( inputContext )

	RuiSetGameTime( Hud_GetRui( file.footer ), "startFadeTime", -1.0 )

	string text = Localize( "#LEFT_SCOREBOARD_EXIT" ) + "   " + Localize( "#X_BUTTON_MUTE" )
	#if(PC_PROG)
		if ( PCPlat_IsOverlayAvailable() )
			text = text + "   " + Localize( "#Y_BUTTON_VIEW_PROFILE" )
	#else
		text = text + "   " + Localize( "#Y_BUTTON_VIEW_PROFILE" )
	#endif

	RuiSetString( Hud_GetRui( file.footer ), "footerText", text )

	//
	//
	//
	//
}

void function ScoreboardLoseFocus( entity player )
{
	Assert( file.hasFocus )
	if ( !clGlobal.isScoreboardShown )
		return

	if ( !ScoreboardEnabled() )
		return

	//
	//
	//
	//

	EmitSoundOnEntity( player, "menu_click" )
	file.hasFocus = false
	file.selectedPlayer = null

	HudInput_PopContext()

	RuiSetString( Hud_GetRui( file.footer ), "footerText", "" )
	//
	//
}

void function ScoreboardToggleFocus( entity player )
{
	if ( file.hasFocus )
		ScoreboardLoseFocus( player )
	else
		ScoreboardFocus( player )
}

int function GetEnemyScoreboardTeam()
{
	return GetEnemyTeam( GetLocalClientPlayer().GetTeam() )
}

int function GetNumPlayersToDisplayAsATeam()
{
	if ( UseOnlyMyTeamScoreboard() )
		return GetMaxTeamPlayers()

	if ( UseSingleTeamScoreboard() )
		return GetCurrentPlaylistVarInt( "max_players", MAX_TEAMS )

	return GetCurrentPlaylistVarInt( "max_players", MAX_TEAM_SLOTS ) / GetCurrentPlaylistVarInt( "max_teams", MAX_TEAM_SLOTS )
}

bool function ScoreboardEnabled()
{
	return GetCurrentPlaylistVarInt( "scoreboard_enabled", 0 ) == 1
}

void function InitScoreboardMP()
{
	if ( !ScoreboardEnabled() )
		return

	entity localPlayer = GetLocalClientPlayer()
	int myTeam = localPlayer.GetTeam()
	if ( myTeam == TEAM_SPECTATOR ) //
	{
		myTeam = GetDefaultNonSpectatorTeam()
	}
	string mapName = GetMapDisplayName( GetMapName() )

	var scoreboard = HudElement( "Scoreboard" )
	file.scoreboard = scoreboard

	file.header.gametypeAndMap = HudElement( "ScoreboardGametypeAndMap", scoreboard )
	RuiSetString( Hud_GetRui( file.header.gametypeAndMap ), "gameType", GAMETYPE_TEXT[ GAMETYPE ] )
	RuiSetString( Hud_GetRui( file.header.gametypeAndMap ), "mapName", mapName )
	file.header.gametypeDesc = HudElement( "ScoreboardHeaderGametypeDesc", scoreboard )
	RuiSetString( Hud_GetRui( file.header.gametypeDesc ), "desc", GAMEDESC_CURRENT )
	file.header.scoreHeader = HudElement( "ScoreboardScoreHeader", scoreboard )

	file.footer = HudElement( "ScoreboardGamepadFooter", scoreboard )
	file.pingText = HudElement( "ScoreboardPingText", scoreboard )

	file.scoreboardElems.append( file.header.gametypeAndMap )
	file.scoreboardElems.append( file.header.gametypeDesc )
	file.scoreboardElems.append( file.header.scoreHeader )
	file.scoreboardElems.append( file.footer )
	file.scoreboardElems.append( file.pingText )

	int maxPlayerDisplaySlots = GetNumPlayersToDisplayAsATeam()
	//

	//
	file.playerElems[ myTeam ] <- []
	file.teamElems[ myTeam ] <- {
		logo = HudElement( "ScoreboardMyTeamLogo", scoreboard )
		score = HudElement( "ScoreboardMyTeamScore", scoreboard )
		//
	}

	file.scoreboardElems.append( file.teamElems[ myTeam ].logo )
	file.scoreboardElems.append( file.teamElems[ myTeam ].score )
	for ( int elem = 0; elem < maxPlayerDisplaySlots; elem++ )
	{
		string elemNum = string( elem )

		table rowElementTable
		rowElementTable.background <- HudElement( "ScoreboardTeammateBackground" + elemNum, scoreboard )
		rowElementTable.background.Show()

		file.scoreboardElems.append( rowElementTable.background )

		file.playerElems[ myTeam ].append( rowElementTable )
	}

	if ( !UseSingleTeamScoreboard() )
	{
		RuiSetImage( Hud_GetRui( file.teamElems[ myTeam ].logo ), "logo", $"" )
	}

	//

	array<int> enemyTeams
	if ( !UseOnlyMyTeamScoreboard() )
	{
		enemyTeams = GetAllEnemyTeams( myTeam )
		for ( int teamNum = 1; teamNum <= enemyTeams.len(); ++teamNum )
		{
			string teamNumberPrefix
			if ( UseSingleTeamScoreboard() )
			{
				teamNumberPrefix = "Team1"
			}
			else
			{
				teamNumberPrefix = "Team" + minint( teamNum, 4 )
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

			//

			int currentEnemyTeam = enemyTeams[teamNum - 1]
			file.teamElems[currentEnemyTeam] <-
			{
				logo = HudElement( "ScoreboardEnemy" + teamNumberPrefix + "Logo", scoreboard )
				score = HudElement( "ScoreboardEnemy" + teamNumberPrefix + "Score", scoreboard )
				//
			}

			file.scoreboardElems.append( file.teamElems[currentEnemyTeam].logo )
			file.scoreboardElems.append( file.teamElems[currentEnemyTeam].score )

			file.playerElems[currentEnemyTeam] <- []
			for ( int elem = 0; elem < maxPlayerDisplaySlots; elem++ )
			{
				table rowElementTable
				rowElementTable.background <- HudElement( "ScoreboardOpponent" + teamNumberPrefix + "Background" + string( elem ), scoreboard )
				rowElementTable.background.Show()

				file.scoreboardElems.append( rowElementTable.background )

				file.playerElems[currentEnemyTeam].append( rowElementTable )
			}
		}
	}

	if ( IsPVEMode() )
	{
		file.header.gametypeAndMap.Hide()
		file.header.gametypeDesc.Hide()
	}
	else
	{
		file.header.gametypeAndMap.Show()
		file.header.gametypeDesc.Show()
	}

	if ( UseOnlyMyTeamScoreboard() )
	{
		file.teamElems[myTeam].logo.Show()
		file.teamElems[myTeam].score.Show()
	}
	else if ( UseSingleTeamScoreboard() )
	{
		file.teamElems[ myTeam ].logo.Hide()
		file.teamElems[ myTeam ].score.Hide()

		foreach ( enemyTeam in enemyTeams )
		{
			file.teamElems[ enemyTeam ].logo.Hide()
			file.teamElems[ enemyTeam ].score.Hide()
		}
	}
	else
	{
		file.teamElems[myTeam].logo.Show()
		file.teamElems[myTeam].score.Show()

		foreach ( enemyTeam in enemyTeams )
		{
			file.teamElems[ enemyTeam ].logo.Show()
			file.teamElems[ enemyTeam ].score.Show()
		}
	}
}

array<var> function CreateScoreboardOverlays()
{
	array<var> overlays

	switch ( GAMETYPE )
	{
		default:
			break
	}

	return overlays
}

void function ScoreboardFadeIn()
{
	foreach ( elem in file.scoreboardElems )
	{
		RuiSetGameTime( Hud_GetRui( elem ), "fadeOutStartTime", RUI_BADGAMETIME )
		RuiSetGameTime( Hud_GetRui( elem ), "fadeInStartTime", Time() )
	}

	if ( file.scoreboardBg != null )
	{
		RuiSetGameTime( file.scoreboardBg, "fadeOutStartTime", RUI_BADGAMETIME )
		RuiSetGameTime( file.scoreboardBg, "fadeInStartTime", Time() )
	}
}

void function ScoreboardFadeOut()
{
	foreach ( elem in file.scoreboardElems )
	{
		RuiSetGameTime( Hud_GetRui( elem ), "fadeInStartTime", RUI_BADGAMETIME )
		RuiSetGameTime( Hud_GetRui( elem ), "fadeOutStartTime", Time() )
	}

	if ( file.scoreboardBg != null )
	{
		RuiSetGameTime( file.scoreboardBg, "fadeInStartTime", RUI_BADGAMETIME )
		RuiSetGameTime( file.scoreboardBg, "fadeOutStartTime", Time() )
	}
}

void function ShowScoreboardMP()
{
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

/*







*/

//

//
























//






































//


















//

































































#endif //
}

void function UpdateScoreboardForGamemode( entity player, var rowRui, var scoreHeaderRui )
{
#if(false)






//
























































#endif //
}

void function HideScoreboardMP()
{
	foreach( void functionref() callbackFunc in file.scoreboardCallbacks_OnHiding )
		callbackFunc()

	if ( !ScoreboardEnabled() )
		return

	if ( file.hasFocus )
		HudInput_PopContext()

	ScoreboardFadeOut()
	wait( 0.1 )
	file.hasFocus = false
	file.selectedPlayer = null

	file.scoreboard.Hide()
	if ( file.scoreboardBg != null )
	{
		RuiDestroy( file.scoreboardBg )
		file.scoreboardBg = null
	}
	foreach ( overlay in file.scoreboardOverlays )
	{
		RuiDestroy( overlay )
	}
	file.scoreboardOverlays = []

	entity localPlayer = GetLocalClientPlayer()
	int myTeam = localPlayer.GetTeam()
	int enemyTeam = GetEnemyScoreboardTeam()

	Signal( clGlobal.signalDummy, "OnHideScoreboard" )
}

bool function ScoreboardInputMP( int key )
{
	if ( !ScoreboardEnabled() )
		return true

	Assert( clGlobal.isScoreboardShown )

	entity player = GetLocalClientPlayer()

	switch ( key )
	{
		case BUTTON_DPAD_UP:
			ScoreboardSelectPrevPlayer( player )
			return true

		case BUTTON_DPAD_DOWN:
			ScoreboardSelectNextPlayer( player )
			return true

		case BUTTON_Y:
			ShowPlayerProfile( file.selectedPlayer )
			return true

		case BUTTON_X:
			TogglePlayerVoiceMute( file.selectedPlayer )
			return true

		case BUTTON_DPAD_LEFT:
			ScoreboardLoseFocus( player )
			return true

		case BUTTON_A:
		case BUTTON_B:
		case BUTTON_SHOULDER_LEFT:
		case BUTTON_SHOULDER_RIGHT:
		case BUTTON_STICK_LEFT:
		case BUTTON_STICK_RIGHT:
		case BUTTON_TRIGGER_LEFT_FULL:
		case BUTTON_TRIGGER_RIGHT_FULL:
			ScoreboardLoseFocus( player )
			return false

		default:
			return false
	}

	unreachable
}

//
//
//
//

bool function UseSingleTeamScoreboard()
{
	return (IsFFAGame() || IsSingleTeamMode() || IsPVEMode())
}

bool function UseOnlyMyTeamScoreboard()
{
	if ( IsPVEMode() )
		return true

	bool scoreboard_onlyMyTeam = bool( GetCurrentPlaylistVarInt( "scoreboard_onlyMyTeam", 1 ) )
	if ( scoreboard_onlyMyTeam )
		return true

	return false
}

void function ScoreboardSelectNextPlayer( entity player )
{
	if ( !file.hasFocus )
		return

	EmitSoundOnEntity( player, "menu_click" )
	file.selectedPlayer = file.nextPlayer
}

void function ScoreboardSelectPrevPlayer( entity player )
{
	if ( !file.hasFocus )
		return

	EmitSoundOnEntity( player, "menu_click" )
	file.selectedPlayer = file.prevPlayer
}

//
//
//
//

//
//
//
//

void function AddScoreboardCallback_OnShowing( void functionref() func )
{
	file.scoreboardCallbacks_OnShowing.append( func )
}

void function AddScoreboardCallback_OnHiding( void functionref() func )
{
	file.scoreboardCallbacks_OnHiding.append( func )
}


void function ScoreboardProfile( entity player )
{
	if ( !file.hasFocus )
		return

	ShowPlayerProfile( file.selectedPlayer )
}

void function ScoreboardMute( entity player )
{
	if ( !file.hasFocus )
		return

	TogglePlayerVoiceMute( file.selectedPlayer )
}
