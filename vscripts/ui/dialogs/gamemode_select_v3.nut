global function InitGamemodeSelectV3Dialog
global function GamemodeSelectV3_IsEnabled
global function GamemodeSelectV3_UpdateSelectButton
global function GamemodeSelectV3_PlaylistIsDefaultSlot
global function GamemodeSelectV3_SetFeaturedSlot
global function UpdateOpenModeSelectV3Dialog

struct {
	var menu
	var closeButton
	var selectionPanel
	var gameModeButtonBackground
                           
		var tournamentConnectButton
       

	int   videoChannel = -1
	asset currentVideoAsset = $""

	string featuredSlot = ""
	string featuredSlotString = "#HEADER_NEW_MODE"

	array<var>         modeSelectButtonList
	table<var, string> selectButtonPlaylistNameMap
	var                rankedRUIToUpdate = null

                        
                                            
       

	bool showVideo
} file


bool function GamemodeSelectV3_IsEnabled()
{
	if ( GamemodeSelectV2_IsEnabled() )
		return false

	return GetCurrentPlaylistVarBool( "gamemode_select_v3_enable", true )
}

//
const int DRAW_NONE = 0
const int DRAW_IMAGE = 1
const int DRAW_RANK = 2

const int FEATURED_NONE = 0
const int FEATURED_ACTIVE = 1
const int FEATURED_INACTIVE = 2

const int MAX_DISPLAYED_MODES_V3 = 8

void function GamemodeSelectV3_UpdateSelectButton( var button, string playlistName, string slot = "" )
{
	var rui = Hud_GetRui( button )

	bool doDebug = (InputIsButtonDown( KEY_LSHIFT ) && InputIsButtonDown( KEY_LCONTROL )) || (InputIsButtonDown( BUTTON_TRIGGER_LEFT_FULL ) && InputIsButtonDown( BUTTON_B ))
	RuiSetString( rui, "modeNameText", GetPlaylistVarString( playlistName, "name", "#PLAYLIST_UNAVAILABLE" ) )
	RuiSetString( rui, "playlistName", playlistName )

	RuiSetBool( rui, "doDebug", doDebug )

	string descText = GetPlaylistVarString( playlistName, "description", "#HUD_UNKNOWN" )
	RuiSetString( rui, "modeDescText", descText )

	RuiSetString( rui, "modeLockedReason", "" )

	RuiSetBool( rui, "alwaysShowDesc", false )

	RuiSetBool( rui, "isPartyLeader", false )
	RuiSetBool( rui, "showLockedIcon", true )

	string uiSlot = GetPlaylistVarString( playlistName, "ui_slot", "" )
	bool isLTM    = uiSlot == "ltm" //
	RuiSetBool( rui, "isLimitedTime", isLTM )

	string imageKey  = GetPlaylistVarString( playlistName, "image", "" )
	asset imageAsset = GetImageFromImageMap( imageKey )
	string iconKey = GetPlaylistVarString( playlistName, "lobby_mini_icon", "" )
	asset iconAsset = GetImageFromMiniIconMap( iconKey )
	RuiSetImage( Hud_GetRui( button ), "modeImage", imageAsset )
	RuiSetImage( Hud_GetRui( button ), "expandArrowImage", iconAsset )


	bool isPlaylistAvailable = Lobby_IsPlaylistAvailable( playlistName )
	Hud_SetLocked( button, !isPlaylistAvailable )
	int playlistState          = Lobby_GetPlaylistState( playlistName )
	string playlistStateString = Lobby_GetPlaylistStateString( Lobby_GetPlaylistState( playlistName ) )
	if ( playlistState == ePlaylistState.ACCOUNT_LEVEL_REQUIRED )
	{
		int level = GetPlaylistVarInt( playlistName, "account_level_required", 0 )
		playlistStateString = Localize( playlistStateString, level )
	}

	RuiSetString( rui, "modeLockedReason", playlistStateString )

	int emblemMode = DRAW_NONE
	if ( IsRankedPlaylist( playlistName ) )
	{
		emblemMode = DRAW_RANK
		int rankScore      = GetPlayerRankScore( GetUIPlayer() )
		int ladderPosition = Ranked_GetLadderPosition( GetUIPlayer() )

		if ( Ranked_ShouldUpdateWithComnunityUserInfo( rankScore, ladderPosition ) ) //
			file.rankedRUIToUpdate = rui


		PopulateRuiWithRankedBadgeDetails( rui, rankScore, ladderPosition )
	}
                        
                                                   
  
    
  
       
                     
	else if (GetPlaylistVarBool( playlistName, "preview_locked", false ))
	{
		RuiSetString( rui, "modeLockedReason", Localize( "#S08E04_PLAY_LOBBY_UNLOCK" ) )
	}
       
	else
	{
		asset emblemImage = GetModeEmblemImage( playlistName )
		if ( emblemImage != $"" )
		{
			emblemMode = DRAW_IMAGE
			RuiSetImage( rui, "emblemImage", emblemImage )
		}
	}
	RuiSetInt( rui, "emblemMode", emblemMode )

	//
	RuiSetGameTime( rui, "expireTime", RUI_BADGAMETIME )

	PlaylistScheduleData scheduleData = Playlist_GetScheduleData( playlistName )
	if ( scheduleData.currentBlock != null )
	{
		TimestampRange currentBlock = expect TimestampRange(scheduleData.currentBlock)
		int remainingDuration       = currentBlock.endUnixTime - GetUnixTimestamp()
		RuiSetGameTime( rui, "expireTime", Time() + remainingDuration )
	}

	file.selectButtonPlaylistNameMap[button] <- playlistName

	if ( file.featuredSlot == "" || slot == "" )
	{
		RuiSetInt( rui, "featuredState", FEATURED_NONE )
	}
	else
	{
		if ( slot == file.featuredSlot )
		{
			RuiSetInt( rui, "featuredState", FEATURED_ACTIVE )
			RuiSetString( rui, "featuredString", file.featuredSlotString )
		}
		else
			RuiSetInt( rui, "featuredState", FEATURED_INACTIVE )
	}
}


void function InitGamemodeSelectV3Dialog( var newMenuArg )
//
{
	var menu = GetMenu( "GamemodeSelectV3Dialog" )
	file.menu = menu

	file.selectionPanel = Hud_GetChild( menu, "GamemodeSelectPanel" )
	file.gameModeButtonBackground = Hud_GetChild( menu, "GameModeButtonBg" )

                           
		file.tournamentConnectButton = Hud_GetChild( menu, "TournamentConnectButton" )
		HudElem_SetRuiArg( file.tournamentConnectButton, "icon", $"rui/menu/lobby/tournament_icon" )
		Hud_AddEventHandler( file.tournamentConnectButton, UIE_CLICK, OnTournamentConnectButton_Activate )
       

	SetDialog( menu, true )
	SetClearBlur( menu, false )

	AddMenuEventHandler( menu, eUIEvent.MENU_OPEN, OnOpenModeSelectDialog )
	AddMenuEventHandler( menu, eUIEvent.MENU_CLOSE, OnCloseModeSelectDialog )

	file.closeButton = Hud_GetChild( menu, "CloseButton" )
	Hud_AddEventHandler( file.closeButton, UIE_CLICK, OnCloseButton_Activate )

	for ( int buttonIdx = 0; buttonIdx < MAX_DISPLAYED_MODES_V3; buttonIdx++ )
	{
		var button = Hud_GetChild( file.menu, format( "GamemodeButton%d", buttonIdx ) )
		Hud_AddEventHandler( button, UIE_CLICK, GamemodeButton_Activate )
		Hud_AddEventHandler( button, UIE_GET_FOCUS, GamemodeButton_OnGetFocus )
		Hud_AddEventHandler( button, UIE_LOSE_FOCUS, GamemodeButton_OnLoseFocus )
		file.modeSelectButtonList.append( button )
	}

	RegisterSignal( "GamemodeSelectV3_EndVideoStopThread" )

	AddMenuFooterOption( menu, LEFT, BUTTON_B, true, "#B_BUTTON_CLOSE", "#CLOSE" )
	AddMenuFooterOption( menu, LEFT, BUTTON_A, true, "#A_BUTTON_SELECT" )
}

const string DEFAULT_PLAYLIST_UI_SLOT_NAME = "regular_1"
bool function GamemodeSelectV3_PlaylistIsDefaultSlot( string playlist )
{
	string uiSlot = GetPlaylistVarString( playlist, "ui_slot", "" )
	return (uiSlot == DEFAULT_PLAYLIST_UI_SLOT_NAME)
}


void function OnOpenModeSelectDialog()
{
	uiGlobal.modeSelectMenuOpen = true

	UpdateOpenModeSelectV3Dialog()
	AddCallbackAndCallNow_UserInfoUpdated( Ranked_OnUserInfoUpdatedInGameModeSelect )
}


void function GamemodeSelectV3_SetFeaturedSlot( string slot, string modeString = "#HEADER_NEW_MODE" )
{
	file.featuredSlot = slot
	file.featuredSlotString = modeString
}


void function ClearFeaturedSlotAfterDelay()
{
	float startTime = Time()
	while ( Time() - startTime < 3.0 && GetActiveMenu() == file.menu )
	{
		WaitFrame()
	}

	GamemodeSelectV3_SetFeaturedSlot( "" )
	if ( GetActiveMenu() == file.menu )
		UpdateOpenModeSelectV3Dialog()
}


void function UpdateOpenModeSelectV3Dialog()
{
	file.showVideo = GetCurrentPlaylistVarBool( "lobby_gamemode_video", false )

	Hud_SetAboveBlur( GetMenu( "LobbyMenu" ), false )

	if ( file.featuredSlot != "" )
		thread ClearFeaturedSlotAfterDelay()

	bool showButton = false
                           
		#if(PC_PROG)
			bool arePrivateMatchesVisible = GetPlaylistVarBool( "private_match", "visible", true )
			showButton = arePrivateMatchesVisible && !IsPrivateMatchLobby()

			Hud_SetVisible( file.tournamentConnectButton, showButton )
		#endif
       
	file.selectButtonPlaylistNameMap.clear()

	array<string> slots =
	[
		"training",
		"firing_range",
		"regular_1",
		"regular_2",
		"regular_3",
		"ranked",
                      
			"arenas",
        
                         
                   
        
		"ltm",
	]

	table<string, string> slotToPlaylistNameMap

	foreach ( key in slots )
		slotToPlaylistNameMap[ key ] <- ""

	array<string> playlistNames = GetVisiblePlaylistNames( IsPrivateMatchLobby() )
	foreach ( string plName in playlistNames )
	{
		string uiSlot = GetPlaylistVarString( plName, "ui_slot", "" )
		if ( uiSlot == "" )
			continue

		if ( !slots.contains(uiSlot) )
			continue

		if ( !(uiSlot in slotToPlaylistNameMap) )
		{
			Assert( false, format( "Playlist '%s' has invalid value '%s' for 'ui_slot' setting.", plName, uiSlot ) )
			continue
		}

		if ( slotToPlaylistNameMap[uiSlot] != "" )
		{
			Assert( false, format( "Playlist '%s' and '%s' specify the same 'ui_slot': %s", plName, slotToPlaylistNameMap[uiSlot], uiSlot ) )
			continue
		}

		slotToPlaylistNameMap[uiSlot] = plName
	}

	table<string, var > slotToButtonMap = {
		training = Hud_GetChild( file.menu, "GamemodeButton0" ),
		firing_range = Hud_GetChild( file.menu, "GamemodeButton1" ),
		regular_1 = Hud_GetChild( file.menu, "GamemodeButton2" ),
		regular_2 = Hud_GetChild( file.menu, "GamemodeButton3" ),
		regular_3 = Hud_GetChild( file.menu, "GamemodeButton4" ),
	}

	int gamemodeButtonIdx = 5

	array<string> slotsToSkip =
	[
		"firing_range",
		"regular_1",
		"regular_2",
		"regular_3",
	]

	for ( int i=0; i<MAX_DISPLAYED_MODES_V3; i++ )
	{
		var button = Hud_GetChild( file.menu, "GamemodeButton" + i )
		Hud_Hide( button )
		Hud_SetEnabled( button, false )
	}

	string mainPlaylist = "defaults"

	int drawWidth = 0
	foreach ( string slot in slots )
	{
		string playlistName = slotToPlaylistNameMap[slot]

		if ( playlistName == "" )
			continue

		if (!( slot in slotToButtonMap ))
		{
			slotToButtonMap[ slot ] <- Hud_GetChild( file.menu, "GamemodeButton" + gamemodeButtonIdx )
			gamemodeButtonIdx++
		}

		var button = slotToButtonMap[ slot ]
		var rui = Hud_GetRui( button )

		Hud_Show( button )
		Hud_SetEnabled( button, true )

		if ( !slotsToSkip.contains( slot ) )
		{
			drawWidth += (REPLACEHud_GetPos( button ).x + Hud_GetWidth( button ))
		}

		if ( slot == "regular_1" )
			mainPlaylist = playlistName

		GamemodeSelectV3_UpdateSelectButton( button, playlistName, slot )
	}

	//
	int regularPlaylistCount = GetPlaylistsInRegularSlots().len()
	foreach ( slotKey, button in slotToButtonMap )
	{
		if ( slotKey.find( "regular" ) == 0 )
		{
			if ( slotToPlaylistNameMap[ slotKey ] != "" )
				Hud_SetHeight( button, Hud_GetBaseHeight( button ) )
			else
				Hud_SetHeight( button, 0 )
		}
	}

	//
	var backgroundRui = Hud_GetRui( file.gameModeButtonBackground )

	string panelImageKey   = GetPanelImageKeyForCurrentRotationGroup()
	string rotationMapName = GetMapDisplayNameForCurrentRotationGroup()

	asset panelImageAsset = GetImageFromImageMap( panelImageKey )

	int remainingTimeSeconds = GetPlaylistRotationNextTime() - GetUnixTimestamp()

	RuiSetImage( backgroundRui, "modeImage", panelImageAsset )
	RuiSetString( backgroundRui, "mapDisplayName", rotationMapName )
	RuiSetString( backgroundRui, "modeDisplayName", GetPlaylistVarString( mainPlaylist, "survival_takeover_name", "#PL_PLAY_APEX" ) )
	RuiSetGameTime( backgroundRui, "rotationGroupNextTime", Time() + remainingTimeSeconds )
	if ( file.featuredSlot == "" )
		RuiSetInt( backgroundRui, "featuredState", FEATURED_NONE )
	else
		RuiSetInt( backgroundRui, "featuredState", FEATURED_INACTIVE )

	const float PANEL_BASE_WIDTH = 48 + 160 + 48 + 340 + 48 + 340 + 48 //

	//
	//
	float panelScale = Hud_GetBaseWidth( file.selectionPanel ) / PANEL_BASE_WIDTH

	var rui = Hud_GetRui( file.selectionPanel )
	RuiSetFloat( rui, "drawWidth", PANEL_BASE_WIDTH ) //
	RuiSetFloat( rui, "panelScale", panelScale )

	if ( file.featuredSlot == "" )
		RuiSetInt( rui, "featuredState", FEATURED_NONE )
	else
		RuiSetInt( rui, "featuredState", FEATURED_INACTIVE )

	//
	float scale = float( GetScreenSize().width ) / 1920.0

	var bgButton = file.gameModeButtonBackground
	drawWidth += (REPLACEHud_GetPos( bgButton ).x + Hud_GetWidth( bgButton ))
	drawWidth += int( 48 * scale )

	rui = Hud_GetRui( file.selectionPanel )
	RuiSetFloat( rui, "drawWidth", (drawWidth / scale) )
	
	#if(NX_PROG)
	if ( IsNxHandheldMode() )
		{
			Hud_SetWidth( file.selectionPanel, 1161 * scale )
		}
		else
		{
			Hud_SetWidth( file.selectionPanel, drawWidth )
		}
	#else
		Hud_SetWidth( file.selectionPanel, drawWidth )
	#endif

	string ltmPlaylist = slotToPlaylistNameMap["ltm"]
	Assert( ltmPlaylist == Playlist_GetLTMSlotPlaylist( IsPrivateMatchLobby() ) )
	bool hasLimitedMode = (ltmPlaylist != "")
	//
	//

	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//
	//

                 
	//
	if ( GetCurrentPlaylistVarBool( "crafting_enabled", true ) )
	{
		Hud_SetVisible( Hud_GetChild( file.menu, "CraftingDataPanel" ), true )
		RunClientScript( "UICallback_PopulateCraftingPanel", Hud_GetChild( file.menu, "CraftingDataPanel" ) )

                            
			Hud_SetPinSibling( Hud_GetChild( file.menu, "TournamentConnectButton" ), "CraftingDataPanel" )
        
	}
       
}


array<string> function GetPlaylistsInRegularSlots()
{
	array<string> playlistNames = GetVisiblePlaylistNames( IsPrivateMatchLobby() )
	array<string> regularList
	foreach ( string plName in playlistNames )
	{
		string uiSlot = GetPlaylistVarString( plName, "ui_slot", "" )

		if ( uiSlot.find( "regular" ) == 0 )
			regularList.append( plName )
	}

	return regularList
}


void function OnCloseModeSelectDialog()
//
{
	Hud_SetAboveBlur( GetMenu( "LobbyMenu" ), true )

	var modeSelectButton = GetModeSelectButton()
	Hud_SetSelected( modeSelectButton, false )
	Hud_SetFocused( modeSelectButton )

	printt( "Clearing rui to update in game mode select" )
	file.rankedRUIToUpdate = null
	RemoveCallback_UserInfoUpdated( Ranked_OnUserInfoUpdatedInGameModeSelect )
	uiGlobal.modeSelectMenuOpen = false

	Lobby_OnGamemodeSelectV3Close()
}


void function GamemodeButton_Activate( var button )
//
{
	if ( Hud_IsLocked( button ) )
	{
		EmitUISound( "menu_deny" )
		return
	}

	string playlistName = file.selectButtonPlaylistNameMap[button]
	if ( IsPrivateMatchLobby() )
		PrivateMatch_SetSelectedPlaylist( playlistName )
	else
		Lobby_SetSelectedPlaylist( playlistName )

	CloseAllDialogs()
}


void function GamemodeButton_OnGetFocus( var button )
//
{
	//

	string playlistName = file.selectButtonPlaylistNameMap[button]

	if ( file.showVideo )
		GamemodeSelectV2_PlayVideo( button, playlistName )
}


void function GamemodeButton_OnLoseFocus( var button )
//
{
	//
}


void function OnCloseButton_Activate( var button )
//
{
	CloseAllDialogs()
}
