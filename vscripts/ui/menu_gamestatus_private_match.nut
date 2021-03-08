global function InitPrivateMatchGameStatusMenu

#if(UI)
global function EnablePrivateMatchGameStatusMenu
global function IsPrivateMatchGameStatusMenuOpen
global function TogglePrivateMatchGameStatusMenu
global function OpenPrivateMatchGameStatusMenu
global function ClosePrivateMatchGameStatusMenu
global function SetChatModeButtonText
global function SetSpecatorChatModeState
global function SetChatTargetText
global function InitPrivateMatchRosterPanel
global function InitPrivateMatchOverviewPanel
global function InitPrivateMatchAdminPanel
#endif

#if(CLIENT)
global function ServerCallback_PrivateMatch_PopulateGameStatusMenu
global function PrivateMatch_PopulateGameStatusMenu
global function PrivateMatch_GameStatus_GetPlayerButton
global function PrivateMatch_GameStatus_ConfigurePlayerButton
global function PrivateMatch_UpdateChatTarget
#endif


const int TEAMS_PER_PANEL = 10

enum ePlayerHealthStatus
{
	PM_PLAYERSTATE_ALIVE,
	PM_PLAYERSTATE_BLEEDOUT,
	PM_PLAYERSTATE_DEAD,
	PM_PLAYERSTATE_REVIVING,
	PM_PLAYERSTATE_ELIMINATED,

	_count
}

struct TeamRosterStruct
{
	var           headerPanel
	var           listPanel
	int           teamIndex
	int			  teamPlacement
	int           teamSize
	int           teamDisplayNumber

	array<var>      _listButtons

	table< var, entity > buttonPlayerMap
}

struct TeamDeatailsData
{
	int teamIndex
	int teamValue
	int teamKills
	int playerAlive
	string teamName
}

struct
{
	var menu

	var decorationRui
	var menuHeaderRui

	var teamRosterPanel
	var overviewPanel
	var adminPanel

	var teamOverviewOne
	var teamOverviewTwo
	
	var endMatchButton
	var chatModeButton
	var chatSpectCheckBox
	var chatTargetText

	bool enableMenu = false
	bool disableNavigateBack = false

	table< int, TeamRosterStruct > teamRosters
	array< var > teamOverviewPanels

	bool isInitialized = false
	bool tabsInitialized = false

} file

void function InitPrivateMatchGameStatusMenu( var menu )
{
	file.menu = menu
	file.teamRosterPanel = Hud_GetChild( menu, "PrivateMatchRosterPanel" )
	file.overviewPanel = Hud_GetChild( menu, "PrivateMatchOverviewPanel" )
	file.adminPanel = Hud_GetChild( menu, "PrivateMatchAdminPanel" )

	#if(UI)
		file.menuHeaderRui = Hud_GetRui( Hud_GetChild( menu, "MenuHeader" ) )
		RuiSetString( file.menuHeaderRui, "menuName", "#TOURNAMENT_MATCH_STATUS" )

		AddMenuEventHandler( menu, eUIEvent.MENU_OPEN, OnOpenPrivateMatchGameStatusMenu )
		AddMenuEventHandler( menu, eUIEvent.MENU_SHOW, OnShowPrivateMatchGameStatusMenu )
		AddMenuEventHandler( menu, eUIEvent.MENU_HIDE, OnHidePrivateMatchGameStatusMenu )
		AddMenuEventHandler( menu, eUIEvent.MENU_CLOSE, OnClosePrivateMatchGameStatusMenu )
		AddMenuEventHandler( menu, eUIEvent.MENU_NAVIGATE_BACK, OnNavigateBack )

		AddMenuFooterOption( menu, LEFT, BUTTON_B, true, "#B_BUTTON_CLOSE", "#B_BUTTON_CLOSE", null, CanNavigateBack )
		AddMenuFooterOption( menu, LEFT, BUTTON_BACK, true, "", "", ClosePrivateMatchGameStatusMenu, CanNavigateBack )

		AddCommandForMenuToPassThrough( menu, "toggle_inventory" )
		
		AddUICallback_OnLevelInit( void function() : ( menu )
		{
			Assert( CanRunClientScript() )
			RunClientScript( "InitPrivateMatchGameStatusMenu", menu )
		} )
		
		HudElem_SetChildRuiArg( Hud_GetChild( menu, "TabsCommon" ), "Background", "bgColor", <0, 0, 1>, eRuiArgType.VECTOR )
		HudElem_SetChildRuiArg( Hud_GetChild( menu, "TabsCommon" ), "Background", "bgAlpha", 1.6, eRuiArgType.FLOAT )

		SetTabRightSound( menu, "UI_InGame_InventoryTab_Select" )
		SetTabLeftSound( menu, "UI_InGame_InventoryTab_Select" )
	
	#elseif(CLIENT)

		for ( int index; index < 20; index++ )
		{
			string team          = "Team"
			string indexName     = index < 10 ? "0" + string( index ) : string( index )
			string teamIndexName = team + indexName
			var teamPanel = Hud_GetChild( file.teamRosterPanel, teamIndexName )

			file.teamRosters[TEAM_MULTITEAM_FIRST + index] <- CreateTeamPlacement( TEAM_MULTITEAM_FIRST + index, 3, teamPanel )
		}

		if ( !file.isInitialized )
		{
			var teamOverview = Hud_GetChild( file.overviewPanel, "TeamOverview01" ) 
			Hud_InitGridButtons( teamOverview, TEAMS_PER_PANEL )
			var scrollPanel = Hud_GetChild( teamOverview, "ScrollPanel" )

			for ( int i = 0; i < TEAMS_PER_PANEL; i++ )
			{
				file.teamOverviewPanels.insert( file.teamOverviewPanels.len(), Hud_GetRui( Hud_GetChild( scrollPanel, ("GridButton" + i) ) ) )
			}

			teamOverview = Hud_GetChild( file.overviewPanel, "TeamOverview02" ) 
			Hud_InitGridButtons( teamOverview, TEAMS_PER_PANEL )
			scrollPanel = Hud_GetChild( teamOverview, "ScrollPanel" )

			for ( int i = 0; i < TEAMS_PER_PANEL; i++ )
			{
				file.teamOverviewPanels.insert( file.teamOverviewPanels.len(), Hud_GetRui( Hud_GetChild( scrollPanel, ("GridButton" + i) ) ) )
			}

			AddCallback_OnPlayerMatchStateChanged( OnPlayerMatchStateChanged )

			//
			AddCallback_GameStateEnter( eGameState.Playing, OnGameStateEnter_Playing )
			#if(PC_PROG)
			SwitchChatModeButtonText( GetGlobalNetInt( "adminChatMode" ) )
			#endif
		}
	#endif

	file.isInitialized = true
}

#if(UI)
void function InitPrivateMatchRosterPanel( var panel )
{

}

void function EndMatchButton_OnActivate( var button )
{
	if ( IsDialog( GetActiveMenu() ) )
		return

	ConfirmDialogData data
	data.headerText = "#TOURNAMENT_END_MATCH_DIALOG_HEADER"
	data.messageText = "#TOURNAMENT_END_MATCH_DIALOG_MSG" 
	data.resultCallback = void function( int dialogResult ) 
	{
		if( dialogResult == eDialogResult.YES )
		{
			ClosePrivateMatchGameStatusMenu( null )
			if ( HasMatchAdminRole() )
			{
				Remote_ServerCallFunction( "ClientCallback_PrivateMatchEndMatchEarly" )
			}
		}
	}

	OpenConfirmDialogFromData( data )
}

void function InitPrivateMatchOverviewPanel( var panel )
{
	var teamOneHeaderRui = Hud_GetRui( Hud_GetChild( panel, "TeamOverviewHeader01" ) )
	RuiSetString( teamOneHeaderRui, "kills", Localize( "#TOURNAMENT_SPECTATOR_TEAM_KILLS" ) )
	RuiSetString( teamOneHeaderRui, "teamName", Localize( "#TOURNAMENT_SPECTATOR_TEAM_NAME" ) )
	RuiSetString( teamOneHeaderRui, "playersAlive", Localize( "#TOURNAMENT_SPECTATOR_PLAYERS_ALIVE" ) )

	var teamTwoHeaderRui = Hud_GetRui( Hud_GetChild( panel, "TeamOverviewHeader02" ) )
	RuiSetString( teamTwoHeaderRui, "kills", Localize( "#TOURNAMENT_SPECTATOR_TEAM_KILLS" ) )
	RuiSetString( teamTwoHeaderRui, "teamName", Localize( "#TOURNAMENT_SPECTATOR_TEAM_NAME" ) )
	RuiSetString( teamTwoHeaderRui, "playersAlive", Localize( "#TOURNAMENT_SPECTATOR_PLAYERS_ALIVE" ) )

}

void function InitPrivateMatchAdminPanel( var panel )
{
	file.endMatchButton = Hud_GetChild( panel, "EndMatchButton" )
	HudElem_SetRuiArg( file.endMatchButton, "buttonText", Localize( "#TOURNAMENT_END_MATCH" ) )
	Hud_AddEventHandler( file.endMatchButton, UIE_CLICK, EndMatchButton_OnActivate )
	
#if(PC_PROG)
	file.chatModeButton = Hud_GetChild( panel, "AdminChatModeButton" )
	Hud_AddEventHandler( file.chatModeButton, UIE_CLICK, ChatModeButton_OnActivate )

	file.chatSpectCheckBox = Hud_GetChild( panel, "SpectatorChatCheckBox" )
	Hud_AddEventHandler( file.chatSpectCheckBox, UIE_CLICK, ChatSpectatorCheckBox_OnActivate )

	file.chatTargetText = Hud_GetChild( panel, "AdminChatTarget" )
#endif
}

void function SetChatModeButtonText( string newText )
{
#if(PC_PROG)
	ToolTipData adminChatModeTooltip
	adminChatModeTooltip.descText = newText
	HudElem_SetRuiArg( file.chatModeButton, "buttonText", newText )
#endif
}


void function SetSpecatorChatModeState( bool isActive, bool isSelected )
{
#if(PC_PROG)
	HudElem_SetRuiArg( file.chatSpectCheckBox, "isActive", isActive )

	HudElem_SetRuiArg( file.chatSpectCheckBox, "isSelected", isSelected )
#endif
}

void function SetChatTargetText( string target )
{
#if(PC_PROG)
	if ( target != "" )
	{
		HudElem_SetRuiArg( file.chatTargetText, "targetText", Localize("#TOURNAMENT_SPECTATOR_CHAT_TARGET" ) + target )
	}
	else
	{
		HudElem_SetRuiArg( file.chatTargetText, "targetText", "" )
	}
#endif
}

#endif

#if(CLIENT)

void function SwitchChatModeButtonText( int chatMode )
{
#if(PC_PROG)
	string chatModeText = ""
	switch ( chatMode )
	{
		case ACM_PLAYER:
		{
			chatModeText = Localize( "#TOURNAMENT_PLAYER_CHAT" ) 
		}
		break
		case ACM_TEAM:
		{
			chatModeText = Localize( "#TOURNAMENT_TEAM_CHAT" ) 
		}
		break
		case ACM_SPECTATORS:
		{
			chatModeText = Localize( "#TOURNAMENT_SPECTATOR_CHAT" ) 
		}
		break
		case ACM_ALL_PLAYERS:
		{
			chatModeText = Localize( "#TOURNAMENT_ALL_CHAT" ) 
		}
		break
	}

	RunUIScript( "SetChatModeButtonText", chatModeText )
#endif
}

TeamRosterStruct function CreateTeamPlacement( int teamIndex, int teamSize, var panel )
{
	TeamRosterStruct teamPlacement
	teamPlacement.teamIndex = teamIndex
	teamPlacement.teamDisplayNumber = teamIndex - 1
	teamPlacement.teamSize = teamSize

	teamPlacement.headerPanel = Hud_GetChild( panel, PRIVATE_MATCH_TEAM_HEADER_PANEL )
	teamPlacement.listPanel = Hud_GetChild( panel, PRIVATE_MATCH_TEAM_BUTTON_PANEL )

	return teamPlacement
}

void function ServerCallback_PrivateMatch_PopulateGameStatusMenu()
{
	PrivateMatch_PopulateGameStatusMenu( file.menu )
}

int function SortTeams( TeamDeatailsData a, TeamDeatailsData b )
{
	if ( a.teamValue < b.teamValue )
		return 1

	if ( a.teamValue > b.teamValue )
		return -1

	return 0
}

void function PrivateMatch_PopulateGameStatusMenu( var menu )
{
	if ( file.enableMenu == false )
		return

	array<entity> players = GetPlayerArray()
	if ( players.len() == 0 )
		return

	table< int, array<entity> > teamPlayersMap
	foreach( player in players )
	{
		int teamIndex = player.GetTeam()

		if ( !(teamIndex in teamPlayersMap) )
			teamPlayersMap[teamIndex] <- []

		teamPlayersMap[teamIndex].append( player )
	}

	PrivateMatch_GameStatus_TeamRoster_Update( teamPlayersMap )
#if(DEV)
	thread UpdateStatusMenuEachSecond()
#endif

	if ( GetLocalClientPlayer().HasMatchAdminRole() )
		thread OnPrivateMatchGameStatusThink()
}

void function PrivateMatch_GameStatus_TeamRoster_Configure( TeamRosterStruct teamRoster, string teamName )
{
	var buttonPanel = teamRoster.listPanel
	int teamSize    = teamRoster.teamSize

	HudElem_SetRuiArg( teamRoster.headerPanel, "teamName", teamName )
	HudElem_SetRuiArg( teamRoster.headerPanel, "teamNumber", teamRoster.teamDisplayNumber )

	foreach ( button in teamRoster._listButtons )
	{
		Hud_RemoveEventHandler( button, UIE_CLICK, OnRosterButton_Click )
	}

	Hud_InitGridButtons( buttonPanel, teamSize )
	var scrollPanel = Hud_GetChild( buttonPanel, "ScrollPanel" )
	for ( int i = 0; i < teamSize; i++ )
	{
		var button = Hud_GetChild( scrollPanel, ("GridButton" + i) )
		InitButtonRCP( button )
		HudElem_SetRuiArg( button, "buttonText", "" )
		Hud_AddEventHandler( button, UIE_CLICK, OnRosterButton_Click )

		if ( !teamRoster._listButtons.contains( button ) )
			teamRoster._listButtons.append( button )
	}
}

void function PrivateMatch_GameStatus_TeamDetails_Update( array< TeamDeatailsData > teamOrderArray )
{
	if ( file.enableMenu == false )
		return
	if ( teamOrderArray.len() == 0 )
		return
	if( file.teamOverviewPanels.len() == 0 )
		return
	
	for ( int orderedIndex = 0; orderedIndex < teamOrderArray.len(); orderedIndex++ )
	{
		int teamIndex = teamOrderArray[orderedIndex].teamIndex

		if ( orderedIndex > file.teamOverviewPanels.len() - 1 ) 
			continue
		
		var panel = file.teamOverviewPanels[orderedIndex]

		RuiSetString( panel, "teamName", teamOrderArray[orderedIndex].teamName )
		RuiSetString( panel, "teamPosition", string( orderedIndex + 1 ) )

		RuiSetString( panel, "playersAlive", string( teamOrderArray[orderedIndex].playerAlive ) )
		RuiSetString( panel, "kills", string( teamOrderArray[orderedIndex].teamKills ) )
	}
}

void function PrivateMatch_GameStatus_TeamOverview_Process( table< int, array<entity> > teamPlayersMap )
{
	if ( file.enableMenu == false )
		return

	array< TeamDeatailsData > teamOrderArray
	
	array<entity> players
	int kills

	foreach ( teamIndex, teamRoster in file.teamRosters )
	{
		TeamDeatailsData teamDetailsData

		teamDetailsData.playerAlive = 0

		if ( teamIndex in teamPlayersMap )
		{
			players = teamPlayersMap[teamIndex]
			kills = 0
			
			foreach( player in players )
			{
				kills += player.GetPlayerNetInt( "kills" )
				if ( IsAlive(player) )
				{
					teamDetailsData.playerAlive++
				}
			}
		}
		if ( players.len() > 0)
		{
			teamDetailsData.teamIndex = teamIndex
			teamDetailsData.teamValue = teamDetailsData.playerAlive * 1000
			teamDetailsData.teamKills = kills
			teamDetailsData.teamValue += kills
			teamDetailsData.teamName = GameRules_GetTeamName( teamIndex )
			teamOrderArray.insert( teamOrderArray.len(), teamDetailsData )
		}
        	
	}

	teamOrderArray.sort( SortTeams )
	PrivateMatch_GameStatus_TeamDetails_Update( teamOrderArray )
}

void function PrivateMatch_GameStatus_TeamRoster_Update( table< int, array<entity> > teamPlayersMap )
{
	if ( file.teamRosterPanel == null )
		return

	if ( file.teamRosters.len() == 0 )
		return

	if ( file.enableMenu == false )
		return

	foreach ( teamIndex, teamRoster in file.teamRosters )
	{
		array<entity> players
		if ( teamIndex in teamPlayersMap )
			players = teamPlayersMap[teamIndex]

		string teamName = GameRules_GetTeamName( teamRoster.teamIndex )

		PrivateMatch_GameStatus_TeamRoster_Configure( teamRoster, teamName )

		HudElem_SetRuiArg( teamRoster.headerPanel, "teamName", teamName )
		HudElem_SetRuiArg( teamRoster.headerPanel, "teamNumber", teamRoster.teamDisplayNumber )

		var scrollPanel = Hud_GetChild( teamRoster.listPanel, "ScrollPanel" )
		Assert( players.len() <= teamRoster.teamSize )
		for ( int playerIndex = 0; playerIndex < teamRoster.teamSize; playerIndex++ )
		{
			var button = Hud_GetChild( scrollPanel, ("GridButton" + playerIndex) )
			if ( playerIndex < players.len() )
			{
				teamRoster.buttonPlayerMap[ button ] <- players[playerIndex]
				thread PrivateMatch_GameStatus_ConfigurePlayerButton( button, players[playerIndex] )
			}
			else
			{
				HudElem_SetRuiArg( button, "buttonText", "" )
				HudElem_SetRuiArg( button, "rightText", "" )
				HudElem_SetRuiArg( button, "killCount", 0 )
			}
		}
	}
}


void function PrivateMatch_GameStatus_ConfigurePlayerButton( var button, entity player )
{
	if ( !IsValid( player ) )
		return

	string playerName       = ""
	int killCount           = 0
	asset characterPortrait = $"white"
	int playerHealthStatus  = 0
	bool isObserveTarget    = false
	if ( player != null )
	{
		playerName = player.GetPlayerNameWithClanTag()
		killCount = player.GetPlayerNetInt( "kills" )

		ItemFlavor character = LoadoutSlot_WaitForItemFlavor( ToEHI( player ), Loadout_Character() )
		characterPortrait = CharacterClass_GetGalleryPortrait( character )

		playerHealthStatus = GetPlayerHealthStatus( player )

		isObserveTarget = GetLocalClientPlayer().GetObserverTarget() == player
	}

	HudElem_SetRuiArg( button, "buttonText", playerName )
	HudElem_SetRuiArg( button, "killCount", killCount )
	var buttonRui = Hud_GetRui( button )
	RuiSetImage( buttonRui, "playerPortrait", characterPortrait )
	HudElem_SetRuiArg( button, "playerState", playerHealthStatus )
	HudElem_SetRuiArg( button, "isObserveTarget", isObserveTarget )
}

var function PrivateMatch_GameStatus_GetPlayerButton( entity player )
{
	var playerButton
	foreach( teamIndex, teamRoster in file.teamRosters )
	{
		foreach ( var button in teamRoster.buttonPlayerMap )
		{
			if ( !IsValid( teamRoster.buttonPlayerMap[ button ] ) )
				continue

			if ( teamRoster.buttonPlayerMap[ button ] == player )
			{
				playerButton = button
				break
			}
		}
	}

	return playerButton
}


void function OnRosterButton_Click( var button )
{
	entity observerTarget = null
	foreach ( teamIndex, teamRoster in file.teamRosters )
	{
		if ( button in teamRoster.buttonPlayerMap )
			observerTarget = teamRoster.buttonPlayerMap[ button ]
	}

	if ( !IsValid( observerTarget ) )
		return

	if ( !IsAlive( observerTarget ) )
		return

	if ( GetLocalClientPlayer().GetObserverTarget() == observerTarget )
		return

	Remote_ServerCallFunction( "ClientCallback_PrivateMatchChangeObserverTarget", observerTarget )
	RunUIScript( "ClosePrivateMatchGameStatusMenu", null )
}

int function GetPlayerHealthStatus( entity player )
{
	int healthStatus = ePlayerHealthStatus.PM_PLAYERSTATE_ALIVE

	if ( !IsAlive( player ) )
	{
		int respawnStatus = GetRespawnStatus( player )
		switch( respawnStatus )
		{
			case eRespawnStatus.PICKUP_DESTROYED:
			case eRespawnStatus.SQUAD_ELIMINATED:
				healthStatus = ePlayerHealthStatus.PM_PLAYERSTATE_ELIMINATED
				break

			case eRespawnStatus.WAITING_FOR_DELIVERY:
			case eRespawnStatus.WAITING_FOR_DROPPOD:
			case eRespawnStatus.WAITING_FOR_PICKUP:
			case eRespawnStatus.WAITING_FOR_RESPAWN:
				healthStatus = ePlayerHealthStatus.PM_PLAYERSTATE_DEAD
				break

			case eRespawnStatus.NONE:
			default:
				healthStatus = ePlayerHealthStatus.PM_PLAYERSTATE_ALIVE
				break
		}
	}

	if ( Bleedout_IsBleedingOut( player ) )
	{
		int bleedoutState = player.GetBleedoutState()

		switch( bleedoutState )
		{
			case BS_BLEEDING_OUT:
			case BS_ENTERING_BLEEDOUT:
				healthStatus = ePlayerHealthStatus.PM_PLAYERSTATE_BLEEDOUT
				break

			case BS_EXITING_BLEEDOUT:
				healthStatus = ePlayerHealthStatus.PM_PLAYERSTATE_REVIVING
				break
		}
	}

	return healthStatus
}

void function OnGameStateEnter_Playing()
{
	TryEnablePrivateMatchGameStatusMenu( GetLocalClientPlayer() )
}

void function OnPlayerMatchStateChanged( entity player, int oldState, int newState )
{
	if ( file.enableMenu == true )
		return

	if ( newState >= ePlayerMatchState.SKYDIVE_PRELAUNCH )
	{
		file.enableMenu = true
		RunUIScript( "EnablePrivateMatchGameStatusMenu", true )
	}
}

void function TryEnablePrivateMatchGameStatusMenu( entity player )
{
	if ( !IsPrivateMatch() )
		return

	if ( PlayerMatchState_GetFor( GetLocalClientPlayer() ) < ePlayerMatchState.SKYDIVE_PRELAUNCH )
		return

	if ( player.GetTeam() != TEAM_SPECTATOR )
		return

	if ( file.enableMenu == true )
		return

	RunUIScript( "EnablePrivateMatchGameStatusMenu", true )
	file.enableMenu = true
	PrivateMatch_PopulateGameStatusMenu( file.menu )

}

void function UpdateStatusMenuEachSecond()
{
	while ( true )
	{
		array<entity> players = GetPlayerArray()
		if ( players.len() == 0 )
			return

		table< int, array<entity> > teamPlayersMap
		foreach( player in players )
		{
			int teamIndex = player.GetTeam()

			if ( !(teamIndex in teamPlayersMap) )
				teamPlayersMap[teamIndex] <- []

			teamPlayersMap[teamIndex].append( player )
		}
		PrivateMatch_GameStatus_TeamOverview_Process( teamPlayersMap )
		wait 1
	}
}

void function PrivateMatch_UpdateChatTarget()
{
	int chatMode = GetGlobalNetInt( "adminChatMode" )

	if ( chatMode == ACM_PLAYER )
	{
		RunUIScript( "SetChatTargetText", GetLocalClientPlayer().GetObserverTarget().GetPlayerName() )
	}
	else if ( chatMode == ACM_TEAM )
	{
		RunUIScript( "SetChatTargetText", GameRules_GetTeamName( GetLocalClientPlayer().GetObserverTarget().GetTeam() ) )
	}
	else
	{
		RunUIScript( "SetChatTargetText", "" )
	}
}

void function OnPrivateMatchGameStatusThink()
{
	int lastAdminChatMode = 0
	bool lastAdminSpectatorChat = false

	#if(PC_PROG)
	while ( true )
	{
		if ( GetGlobalNetInt( "adminChatMode" ) != lastAdminChatMode )
		{
			if( lastAdminChatMode == ACM_ALL_PLAYERS )
			{
				RunUIScript( "SetSpecatorChatModeState", false, lastAdminSpectatorChat )
			}
			
			lastAdminChatMode = GetGlobalNetInt( "adminChatMode" );
			SwitchChatModeButtonText( lastAdminChatMode )
			PrivateMatch_UpdateChatTarget()

			if( lastAdminChatMode == ACM_ALL_PLAYERS )
			{
				RunUIScript( "SetSpecatorChatModeState", true, lastAdminSpectatorChat )	
			}
		}

		if ( GetGlobalNetBool( "adminSpectatorChat" ) != lastAdminSpectatorChat )
		{
			lastAdminSpectatorChat = !lastAdminSpectatorChat
			RunUIScript( "SetSpecatorChatModeState", lastAdminChatMode == ACM_ALL_PLAYERS, lastAdminSpectatorChat )
		}
		
		WaitFrame()
	}
	#endif
}

#endif //


#if(UI)
void function OnOpenPrivateMatchGameStatusMenu()
{
	if ( !IsFullyConnected() )
	{
		CloseActiveMenu()
		return
	}
	
	if ( !file.tabsInitialized )
	{
		TabData tabData = GetTabDataForPanel( file.menu )
		tabData.centerTabs = true
		AddTab( file.menu, Hud_GetChild( file.menu, "PrivateMatchRosterPanel" ), "#TOURNAMENT_TEAM_STATUS" )		//
#if(DEV)
		AddTab( file.menu, Hud_GetChild( file.menu, "PrivateMatchOverviewPanel" ), "#TOURNAMENT_MATCH_STATS" )		//
#endif
		if ( HasMatchAdminRole() )
			AddTab( file.menu, Hud_GetChild( file.menu, "PrivateMatchAdminPanel" ), "#TOURNAMENT_ADMIN_CONTROLS" )	//
		
		file.tabsInitialized = true
	}

	TabData tabData        = GetTabDataForPanel( file.menu )
	TabDef rosterTab       = Tab_GetTabDefByBodyName( tabData, "PrivateMatchRosterPanel" )
#if(DEV)
	TabDef overviewTab     = Tab_GetTabDefByBodyName( tabData, "PrivateMatchOverviewPanel" )
#endif
	
	UpdateMenuTabs()
	
	ActivateTab( tabData, 0 )
		
	SetTabNavigationEnabled( file.menu, true )

	RunClientScript( "PrivateMatch_PopulateGameStatusMenu", file.menu )
}


void function OnShowPrivateMatchGameStatusMenu()
{
	SetMenuReceivesCommands( file.menu, PROTO_Survival_DoInventoryMenusUseCommands() && !IsControllerModeActive() )
}

void function OnHidePrivateMatchGameStatusMenu()
{
	//
}


void function OnClosePrivateMatchGameStatusMenu()
{
	//
}


bool function CanNavigateBack()
{
	return file.disableNavigateBack != true
}


void function OnNavigateBack()
{
	ClosePrivateMatchGameStatusMenu( null )
}


void function EnablePrivateMatchGameStatusMenu( bool doEnable )
{
	file.enableMenu = doEnable
}


bool function IsPrivateMatchGameStatusMenuOpen()
{
	return GetActiveMenu() == file.menu
}

void function TogglePrivateMatchGameStatusMenu( var button )
{
	if ( !IsPrivateMatch() )
		return

	if ( GetActiveMenu() == file.menu )
		thread CloseActiveMenu()

	if ( file.enableMenu == true )
		AdvanceMenu( file.menu )
}


void function OpenPrivateMatchGameStatusMenu( var button )
{
	if ( !IsPrivateMatch() )
		return

	if ( file.enableMenu == false )
		return

	CloseAllMenus()
	AdvanceMenu( file.menu )
}

void function ChatModeButton_OnActivate( var button )
{
	if ( HasMatchAdminRole() )
	{
		Remote_ServerCallFunction( "ClientCallback_PrivateMatchCycleAdminChatMode" )
	}
}

void function ChatSpectatorCheckBox_OnActivate( var button )
{
	if ( HasMatchAdminRole() )
	{
		Remote_ServerCallFunction( "ClientCallback_PrivateMatchToggleSpectatorChat" )
	}
}

void function ClosePrivateMatchGameStatusMenu( var button )
{
	if ( GetActiveMenu() == file.menu )
		thread CloseActiveMenu()
}
#endif //

