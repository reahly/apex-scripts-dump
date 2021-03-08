global function InitPrivateMatchLobbyMenu
global function PrivateMatch_SetSelectedPlaylist
global function PrivateMatch_RefreshPlaylistButtonName
global function PrivateMatch_RefreshStartCountdown

const string SIGNAL_LOBBY_UPDATE = "PrivateMatchLobbyMenuUpdate"

struct
{
	#if(UI)
		int  activePresentationType = ePresentationType.INACTIVE
	#endif //

	var    menu
	var    menuHeaderRui

	bool updatingLobbyUI = false
	bool inputsRegistered = false

	var teamRosterPanel
	var spectatorRosterPanel
	var unassignedRosterPanel
	var userControlsPanel
	var postGamePanel

	var readyLaunchButton
	var modeButton
	var gameMenuButton
	var postGameButton
	var teamSwapButton
	var teamRenameButton
	var adminOnlyButton

	var textChat
	var chatInputLine

	var mouseDragIcon
} file

void function InitPrivateMatchLobbyMenu( var newMenuArg )
{
	printf( "PrivateMatchLobbyDebug: Init Private Match Lobby" )
	var menu = GetMenu( "PrivateMatchLobbyMenu" )
	file.menu = menu
	file.mouseDragIcon = Hud_GetChild( menu, "MouseDragIcon" )

	file.menuHeaderRui = Hud_GetRui( Hud_GetChild( menu, "MenuHeader" ) )
	RuiSetString( file.menuHeaderRui, "menuName", "#TOURNAMENT_LOBBY_HEADER" )

	RegisterSignal( SIGNAL_LOBBY_UPDATE )

	AddMenuEventHandler( menu, eUIEvent.MENU_GET_TOP_LEVEL, OnGetTopLevel )

	AddMenuEventHandler( menu, eUIEvent.MENU_OPEN, OnPrivateMatchLobbyMenu_Open )
	AddMenuEventHandler( menu, eUIEvent.MENU_CLOSE, OnPrivateMatchLobbyMenu_Close )

	AddMenuEventHandler( menu, eUIEvent.MENU_SHOW, OnPrivateMatchLobbyMenu_Show )
	AddMenuEventHandler( menu, eUIEvent.MENU_HIDE, OnPrivateMatchLobbyMenu_Hide )

	AddMenuEventHandler( menu, eUIEvent.MENU_NAVIGATE_BACK, OnPrivateMatchLobbyMenu_NavigateBack )

	AddMenuVarChangeHandler( "isFullyConnected", UpdateFooterOptions )
	AddMenuVarChangeHandler( "isPartyLeader", UpdateFooterOptions )

	var teamRosterPanel = Hud_GetChild( menu, "PrivateMatchRosterPanel" )
	file.teamRosterPanel = teamRosterPanel
	Hud_Show( file.teamRosterPanel )

	var spectatorRosterPanel = Hud_GetChild( menu, "PrivateMatchSpectatorPanel" )
	file.spectatorRosterPanel = spectatorRosterPanel
	Hud_Show( file.spectatorRosterPanel )
	
#if(PC_PROG)
	file.textChat = Hud_GetChild( menu, "LobbyChatBox" )
	file.chatInputLine = Hud_GetChild( file.textChat, "ChatInputLine" )
	Hud_Show( file.textChat )
#endif

	var unassignedRosterPanel = Hud_GetChild( menu, "PrivateMatchUnassignedPlayersPanel" )
	file.unassignedRosterPanel = unassignedRosterPanel
	Hud_Show( file.unassignedRosterPanel )

	var userControlsPanel = Hud_GetChild( menu, "PrivateMatchUserControls" )
	file.userControlsPanel = userControlsPanel
	Hud_Show( file.userControlsPanel )

	var postGameButton = Hud_GetChild( userControlsPanel, "PrivateMatchPostGameButton" )
	file.postGameButton = postGameButton
	ToolTipData postGameToolTip
	postGameToolTip.descText = "#MATCH_SUMMARY"
	Hud_SetToolTipData( postGameButton, postGameToolTip )
	HudElem_SetRuiArg( postGameButton, "icon", $"rui/menu/lobby/postgame_icon" )
	HudElem_SetRuiArg( postGameButton, "shortcutText", "%[BACK|TAB]%" )
	Hud_AddEventHandler( postGameButton, UIE_CLICK, PrivateMatchPostGameButton_OnActivate )

	var readyLaunchButton = Hud_GetChild( userControlsPanel, "ReadyButton" )
	file.readyLaunchButton = readyLaunchButton
	Hud_AddEventHandler( file.readyLaunchButton, UIE_CLICK, ReadyLaunchButton_OnActivate )
	HudElem_SetRuiArg( file.readyLaunchButton, "buttonText", Localize( "#TOURNAMENT_START_MATCH" ) )

	file.modeButton = Hud_GetChild( userControlsPanel, "ModeButton" )
	Hud_AddEventHandler( file.modeButton, UIE_CLICK, ModeSelectButton_OnActivate )

	file.teamSwapButton = Hud_GetChild( userControlsPanel, "PrivateMatchTeamSwapToggleButton" )
	ToolTipData teamSwapToolTip
	teamSwapToolTip.descText = "#TOURNAMENT_TEAM_SWAP_OFF"
	Hud_SetToolTipData( file.teamSwapButton, teamSwapToolTip )
	Hud_AddEventHandler( file.teamSwapButton, UIE_CLICK, TeamSwapButton_OnActivate )

	file.teamRenameButton = Hud_GetChild( userControlsPanel, "PrivateMatchTeamRenameToggleButton" )
	ToolTipData teamRenameToolTip
	teamRenameToolTip.descText = "#TOURNAMENT_TEAM_RENAME_OFF"
	Hud_SetToolTipData( file.teamRenameButton, teamRenameToolTip )
	Hud_AddEventHandler( file.teamRenameButton, UIE_CLICK, TeamRenameButton_OnActivate )

	file.adminOnlyButton = Hud_GetChild( userControlsPanel, "PrivateMatchAdminOnlyChatToggleButton" )
	ToolTipData adminOnlyToolTip
	adminOnlyToolTip.descText = "#ADMIN_ONLY_CHAT_OFF"
	Hud_SetToolTipData( file.adminOnlyButton, adminOnlyToolTip )
	Hud_AddEventHandler( file.adminOnlyButton, UIE_CLICK, AdminOnlyButton_OnActivate )

	AddMenuVarChangeHandler( "isFullyConnected", UpdateFooterOptions )
	AddMenuVarChangeHandler( "isPartyLeader", UpdateFooterOptions )
	#if(DURANGO_PROG)
		AddMenuVarChangeHandler( "DURANGO_canInviteFriends", UpdateFooterOptions )
		AddMenuVarChangeHandler( "DURANGO_isJoinable", UpdateFooterOptions )
	#elseif(PLAYSTATION_PROG)
		AddMenuVarChangeHandler( "PS4_canInviteFriends", UpdateFooterOptions )
	#elseif(PC_PROG)
		AddMenuVarChangeHandler( "ORIGIN_isEnabled", UpdateFooterOptions )
		AddMenuVarChangeHandler( "ORIGIN_isJoinable", UpdateFooterOptions )
	#endif

	RegisterSignal( "TEMP_UpdateCursorPosition" )
}


void function OnGetTopLevel()
{
	UI_SetPresentationType( ePresentationType.WEAPON_CATEGORY )
}


void function OnPrivateMatchLobbyMenu_Open()
{

}


void function OnPrivateMatchLobbyMenu_Show()
{
	RegisterInputs()

	Chroma_Lobby()

	if ( HasMatchAdminRole() )
	{
		HudElem_SetRuiArg( file.readyLaunchButton, "buttonText", Localize( "#TOURNAMENT_START_MATCH" ) )
	}
	else
	{
		HudElem_SetRuiArg( file.readyLaunchButton, "buttonText", Localize( "#READY" ) )
	}

	Hud_SetEnabled( file.modeButton, HasMatchAdminRole() )
	Hud_SetEnabled( file.teamSwapButton, HasMatchAdminRole() )

	//

	thread OnPrivateMatchLobbyThink()
}


void function OnPrivateMatchLobbyThink()
{
	Signal( uiGlobal.signalDummy, "TEMP_UpdateCursorPosition" )
	EndSignal( uiGlobal.signalDummy, "TEMP_UpdateCursorPosition" )

	bool lastTeamSwapState = false
	bool lastTeamRenameState = false
	bool lastAdminOnlyChatState = false

	while ( true )
	{
		if ( CanRunClientScript() )
		{
			RunClientScript( "PrivateMatch_ClientFrame" )

			PrivateMatch_RefreshPlaylistButtonName()

			if ( GetGlobalNetBool( "canAssignSelf" ) != lastTeamSwapState )
			{
				ToolTipData teamSwapToolTip
				teamSwapToolTip.descText = GetGlobalNetBool( "canAssignSelf" ) ? "#TOURNAMENT_TEAM_SWAP_ON" : "#TOURNAMENT_TEAM_SWAP_OFF"
				Hud_SetToolTipData( file.teamSwapButton, teamSwapToolTip )
				lastTeamSwapState = GetGlobalNetBool( "canAssignSelf" )
			}

			if ( GetGlobalNetBool( "canPlayersRenameTeams" ) != lastTeamRenameState )
			{
				ToolTipData teamRenameToolTip
				teamRenameToolTip.descText = GetGlobalNetBool( "canPlayersRenameTeams" ) ? "#TOURNAMENT_TEAM_RENAME_ON" : "#TOURNAMENT_TEAM_RENAME_OFF"
				Hud_SetToolTipData( file.teamRenameButton, teamRenameToolTip )
				lastTeamRenameState = GetGlobalNetBool( "canPlayersRenameTeams" )
			}

			if ( GetGlobalNetBool( "adminOnlyChat" ) != lastAdminOnlyChatState )
			{
				bool isAdminOnly = GetGlobalNetBool( "adminOnlyChat" )
				ToolTipData adminOnlyChatToolTip
				adminOnlyChatToolTip.descText = isAdminOnly ? "#TOURNAMENT_ADMIN_ONLY_CHAT_ON" : "#TOURNAMENT_ADMIN_ONLY_CHAT_OFF"
				Hud_SetToolTipData( file.adminOnlyButton, adminOnlyChatToolTip )
				lastAdminOnlyChatState = isAdminOnly
				
#if(PC_PROG)
				if ( !HasMatchAdminRole() )
					SetChatTextBoxVisible( !isAdminOnly )
#endif
			}
		}

		WaitFrame()
	}
}


void function OnPrivateMatchLobbyMenu_Hide()
{
	DeregisterInputs()
	Signal( uiGlobal.signalDummy, "TEMP_UpdateCursorPosition" )
}


void function OnPrivateMatchLobbyMenu_Close()
{
	DeregisterInputs()
	Signal( uiGlobal.signalDummy, "TEMP_UpdateCursorPosition" )
}


void function PrivateMatch_SetSelectedPlaylist( string playlistName )
{
	Remote_ServerCallFunction( "ClientCallback_PrivateMatchSetPlaylist", playlistName )
}

void function PrivateMatch_RefreshPlaylistButtonName()
{
	string displayName = "#SELECT_PLAYLIST"
	string playlistName = PrivateMatch_GetSelectedPlaylistName()
	displayName = playlistName != "" ? GetPlaylistVarString( playlistName, "name", "#SELECT_PLAYLIST" ) : "#SELECT_PLAYLIST"
	//

	HudElem_SetRuiArg( file.modeButton, "buttonText", Localize( displayName ) )
}

void function PrivateMatch_RefreshStartCountdown( int newVal )
{
	if( newVal > 0 )
	{
		string countdownString = format( "%s %d",Localize( "#TOURNAMENT_STARTING_IN" ), newVal ) 	
		HudElem_SetRuiArg( file.readyLaunchButton, "buttonText", countdownString )
	}
	else if( newVal == 0 )
	{
		HudElem_SetRuiArg( file.readyLaunchButton, "buttonText", Localize( "#TOURNAMENT_STARTING_NOW" ) )	
	}
	else if( newVal == -1 )
	{
		if ( HasMatchAdminRole() )
		{
			HudElem_SetRuiArg( file.readyLaunchButton, "buttonText", Localize( "#TOURNAMENT_START_MATCH" ) )
		}
		else
		{
			HudElem_SetRuiArg( file.readyLaunchButton, "buttonText", Localize( "#READY" ) )
		}
	}
}

void function PrivateMatchLobbyMenuUpdate()
{
	Signal( uiGlobal.signalDummy, SIGNAL_LOBBY_UPDATE )
	EndSignal( uiGlobal.signalDummy, SIGNAL_LOBBY_UPDATE )
	EndSignal( uiGlobal.signalDummy, "CleanupInGameMenus" )

	//
	//
	//
	//
	//
	//
	//
}


void function RegisterInputs()
{
	if ( file.inputsRegistered )
		return

	//
	//
	//
	//
	//
	//
	file.inputsRegistered = true
}


void function DeregisterInputs()
{
	if ( !file.inputsRegistered )
		return

	//
	//
	//
	//
	//
	//
	file.inputsRegistered = false
}


void function ReadyLaunchButton_OnActivate( var button )
{
	if ( HasMatchAdminRole() )
	{
		Remote_ServerCallFunction( "ClientCallback_PrivateMatchStartMatch" )
	}
	else
	{
		Remote_ServerCallFunction( "ClientCallback_PrivateMatchToggleReady" )
	}
}


void function ModeSelectButton_OnActivate( var button )
{
	if ( !HasMatchAdminRole() )
		return

	AdvanceMenu( GetMenu( "GamemodeSelectV2Dialog" ) )
}



void function TeamSwapButton_OnActivate( var button )
{
	if ( !HasMatchAdminRole() )
		return

	Remote_ServerCallFunction( "ClientCallback_PrivateMatchToggleAssignSelf" )
}


void function TeamRenameButton_OnActivate( var button )
{
	if ( !HasMatchAdminRole() )
		return

	Remote_ServerCallFunction( "ClientCallback_PrivateMatchToggleTeamRenaming" )
}

void function AdminOnlyButton_OnActivate( var button )
{
	if ( !HasMatchAdminRole() )
		return
	
	Remote_ServerCallFunction( "ClientCallback_PrivateMatchToggleAdminOnlyChat" )
}

void function SetChatTextBoxVisible( bool visible )
{
	Hud_SetVisible( Hud_GetChild( file.chatInputLine, "ChatInputPrompt" ), visible )
	Hud_SetVisible( Hud_GetChild( file.chatInputLine, "ChatInputTextEntry" ), visible )

	var chatHistory = Hud_GetChild( file.textChat, "HudChatHistory" )
	if ( visible )
	{
		Hud_SetHeight( chatHistory, 45 )
	}
	else
	{
		Hud_SetHeight( chatHistory, 65 )
	}
}


void function PrivateMatchPostGameButton_OnActivate( var button )
{
	if ( IsDialog( GetActiveMenu() ) )
		return

	//
	//
	//
	//

	thread PrivateMatchPostGameFlow()
}


void function OnPrivateMatchLobbyMenu_NavigateBack()
{
	if ( !IsControllerModeActive() )
		AdvanceMenu( GetMenu( "SystemMenu" ) )
}


void function PrivateMatchPostGameFlow()
{
	OpenPrivateMatchPostGameMenu( null )
}

#if(CLIENT)
void function ServerCallback_UpdateModeButton( string modeName )
{
	string mode = modeName != "" ? modeName : "#PL_TOURNAMENT"
	HudElem_SetRuiArg( file.modeButton, "name", mode )
}
#endif