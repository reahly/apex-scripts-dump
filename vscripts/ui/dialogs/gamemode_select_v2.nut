global function InitGamemodeSelectV2Dialog
global function GamemodeSelectV2_IsEnabled
global function GamemodeSelectV2_UpdateSelectButton
global function GamemodeSelectV2_PlayVideo
global function GamemodeSelectV2_PlaylistIsDefaultSlot
global function UpdateOpenModeSelectV2Dialog

//
global function Ranked_OnUserInfoUpdatedInGameModeSelect
global function VideoStopThread
                          
global function OnTournamentConnectButton_Activate
      


struct {
	var menu
	var closeButton
	var selectionPanel
                          
	var tournamentConnectButton
      

	int   videoChannel = -1
	asset currentVideoAsset = $""

	array<var>         modeSelectButtonList
	table<var, string> selectButtonPlaylistNameMap
	var rankedRUIToUpdate = null
} file


global const int MAX_DISPLAYED_MODES = 7

//
//
//
//
//
//
//
//
//
//


bool function GamemodeSelectV2_IsEnabled()
{
	return GetCurrentPlaylistVarBool( "gamemode_select_v2_enable", false ) //
}


//
const int DRAW_NONE = 0
const int DRAW_IMAGE = 1
const int DRAW_RANK = 2

void function GamemodeSelectV2_UpdateSelectButton( var button, string playlistName )
{
	var rui = Hud_GetRui( button )

	bool doDebug = (InputIsButtonDown( KEY_LSHIFT ) && InputIsButtonDown( KEY_LCONTROL ))  || (InputIsButtonDown( BUTTON_TRIGGER_LEFT_FULL ) && InputIsButtonDown( BUTTON_SHOULDER_LEFT ))
	RuiSetString( rui, "modeNameText", GetPlaylistVarString( playlistName, "name", "#PLAYLIST_UNAVAILABLE" ) )
	RuiSetString( rui, "playlistName", playlistName )
	RuiSetBool( rui, "doDebug", doDebug )

	string descText = GetPlaylistVarString( playlistName, "description", "#HUD_UNKNOWN" )
	RuiSetString( rui, "modeDescText", descText )

	RuiSetString( rui, "modeLockedReason", "" )

	RuiSetBool( rui, "alwaysShowDesc", false )

	RuiSetBool( rui, "isPartyLeader", false )
	RuiSetBool( rui, "showLockedIcon", true )

	RuiSetBool( rui, "isLimitedTime", GetPlaylistVarBool( playlistName, "is_limited_time", false ) )

	string imageKey  = GetPlaylistVarString( playlistName, "image", "" )
	asset imageAsset = GetImageFromImageMap( imageKey )
	RuiSetImage( Hud_GetRui( button ), "modeImage", imageAsset )


	bool isPlaylistAvailable = Lobby_IsPlaylistAvailable( playlistName )
	Hud_SetLocked( button, !isPlaylistAvailable )
	RuiSetString( rui, "modeLockedReason", Lobby_GetPlaylistStateString( Lobby_GetPlaylistState( playlistName ) ) )

	int emblemMode = DRAW_NONE
	if ( IsRankedPlaylist( playlistName ) )
	{
		emblemMode = DRAW_RANK
		int rankScore = GetPlayerRankScore( GetUIPlayer() )
		int ladderPosition = Ranked_GetLadderPosition( GetUIPlayer() )

		if ( Ranked_ShouldUpdateWithComnunityUserInfo( rankScore, ladderPosition )  ) //
			file.rankedRUIToUpdate = rui


		PopulateRuiWithRankedBadgeDetails( rui, rankScore, ladderPosition )
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

	file.selectButtonPlaylistNameMap[button] <- playlistName
}


void function GamemodeSelectV2_PlayVideo( var button, string playlistName )
{
	string videoKey         = GetPlaylistVarString( playlistName, "video", "" )
	asset desiredVideoAsset = GetBinkFromBinkMap( videoKey )

	if ( desiredVideoAsset != $"" )
		file.currentVideoAsset = $"" //
	Signal( uiGlobal.signalDummy, "GamemodeSelectV2_EndVideoStopThread" )
	Assert( file.currentVideoAsset == $"" )

	if ( desiredVideoAsset != $"" )
	{
		if ( file.videoChannel == -1 )
			file.videoChannel = ReserveVideoChannel()

		StartVideoOnChannel( file.videoChannel, desiredVideoAsset, true, 0.0 )
		file.currentVideoAsset = desiredVideoAsset
	}

	var rui = Hud_GetRui( button )
	RuiSetBool( rui, "hasVideo", videoKey != "" )
	RuiSetInt( rui, "channel", file.videoChannel )
	if ( file.currentVideoAsset != $"" )
		thread VideoStopThread( button )
}


void function VideoStopThread( var button )
{
	EndSignal( uiGlobal.signalDummy, "GamemodeSelectV2_EndVideoStopThread" )

	OnThreadEnd( function() : ( button ) {
		if ( IsValid( button ) )
		{
			var rui = Hud_GetRui( button )
			RuiSetInt( rui, "channel", -1 )
		}
		if ( file.currentVideoAsset != $"" )
		{
			StopVideoOnChannel( file.videoChannel )
			file.currentVideoAsset = $""
		}
	} )

	while ( GetFocus() == button )
		WaitFrame()

	wait 0.3
}


void function InitGamemodeSelectV2Dialog( var newMenuArg ) //
{
	var menu = GetMenu( "GamemodeSelectV2Dialog" )
	file.menu = menu

	file.selectionPanel = Hud_GetChild( menu, "GamemodeSelectPanel" )

                           
		file.tournamentConnectButton = Hud_GetChild( menu, "TournamentConnectButton" )
		HudElem_SetRuiArg( file.tournamentConnectButton, "icon", $"rui/menu/lobby/tournament_icon" )
		Hud_AddEventHandler( file.tournamentConnectButton, UIE_CLICK, OnTournamentConnectButton_Activate )
       

	SetDialog( menu, true )
	SetClearBlur( menu, false )

	AddMenuEventHandler( menu, eUIEvent.MENU_OPEN, OnOpenModeSelectDialog )
	AddMenuEventHandler( menu, eUIEvent.MENU_CLOSE, OnCloseModeSelectDialog )

	file.closeButton = Hud_GetChild( menu, "CloseButton" )
	Hud_AddEventHandler( file.closeButton, UIE_CLICK, OnCloseButton_Activate )

	for ( int buttonIdx = 0; buttonIdx < MAX_DISPLAYED_MODES; buttonIdx++ )
	{
		var button = Hud_GetChild( file.menu, format( "GamemodeButton%d", buttonIdx ) )
		Hud_AddEventHandler( button, UIE_CLICK, GamemodeButton_Activate )
		Hud_AddEventHandler( button, UIE_GET_FOCUS, GamemodeButton_OnGetFocus )
		Hud_AddEventHandler( button, UIE_LOSE_FOCUS, GamemodeButton_OnLoseFocus )
		file.modeSelectButtonList.append( button )
	}

	RegisterSignal( "GamemodeSelectV2_EndVideoStopThread" )

	AddMenuFooterOption( menu, LEFT, BUTTON_B, true, "#B_BUTTON_CLOSE", "#CLOSE" )
	AddMenuFooterOption( menu, LEFT, BUTTON_A, true, "#A_BUTTON_SELECT" )
}

const string DEFAULT_PLAYLIST_UI_SLOT_NAME = "regular_1"
bool function GamemodeSelectV2_PlaylistIsDefaultSlot( string playlist )
{
	string uiSlot = GetPlaylistVarString( playlist, "ui_slot", "" )
	return (uiSlot == DEFAULT_PLAYLIST_UI_SLOT_NAME)
}

void function OnOpenModeSelectDialog()
{
	uiGlobal.modeSelectMenuOpen = true
	UpdateOpenModeSelectV2Dialog()
	AddCallbackAndCallNow_UserInfoUpdated( Ranked_OnUserInfoUpdatedInGameModeSelect )
}

void function UpdateOpenModeSelectV2Dialog()
{
	Hud_SetAboveBlur( GetMenu( "LobbyMenu" ), false )

	bool showButton = false
                           
		#if(PC_PROG)
			bool arePrivateMatchesVisible = GetPlaylistVarBool( "private_match", "visible", true )
			showButton = arePrivateMatchesVisible && !IsPrivateMatchLobby()

			Hud_SetVisible( file.tournamentConnectButton, showButton )
		#endif
       
	file.selectButtonPlaylistNameMap.clear()

	table<string, string> slotToPlaylistNameMap = {
		training = "",
		firing_range = "",
		regular_1 = "",
		regular_2 = "",
		regular_3 = "",
		ranked = "",
		ltm = "",
	}

	array<string> playlistNames = GetVisiblePlaylistNames( IsPrivateMatchLobby() )
	foreach ( string plName in playlistNames )
	{
		string uiSlot = GetPlaylistVarString( plName, "ui_slot", "" )
		if ( uiSlot == "" )
			continue

		if ( !(uiSlot in slotToPlaylistNameMap) )
		{
			Assert( false, format( "Playlist '%s' has invalid value '%s' for 'ui_slot' setting.", plName, uiSlot ) )
			continue
		}

		if ( slotToPlaylistNameMap[uiSlot] != "" )
		{
			//
			//
			continue
		}

		slotToPlaylistNameMap[uiSlot] = plName
	}

	table<string, var > slotToButtonMap = {
		training =		Hud_GetChild( file.menu, "GamemodeButton0" ),
		firing_range =	Hud_GetChild( file.menu, "GamemodeButton1" ),
		regular_1 =		Hud_GetChild( file.menu, "GamemodeButton2" ),
		regular_2 =		Hud_GetChild( file.menu, "GamemodeButton3" ),
		regular_3 =		Hud_GetChild( file.menu, "GamemodeButton4" ),
		ranked =		Hud_GetChild( file.menu, "GamemodeButton5" ),
		ltm =			Hud_GetChild( file.menu, "GamemodeButton6" ),
	}

	int drawWidth = 0
	foreach ( string slot, var button in slotToButtonMap )
	{
		string playlistName = slotToPlaylistNameMap[slot]
		if ( playlistName == "" )
		{
			Hud_Hide( button )
			Hud_SetWidth( button, 0 )
			Hud_SetX( button, 0 )
			continue
		}

		Hud_SetX( button, REPLACEHud_GetBasePos( button ).x )
		Hud_SetWidth( button, Hud_GetBaseWidth( button ) )
		Hud_Show( button )
		drawWidth += (REPLACEHud_GetPos( button ).x + Hud_GetWidth( button ))

		GamemodeSelectV2_UpdateSelectButton( button, playlistName )
	}

	//
	float scale = float( GetScreenSize().width ) / 1920.0
	drawWidth += int( 48 * scale )

	var rui = Hud_GetRui( file.selectionPanel )
	RuiSetFloat( rui, "drawWidth", (drawWidth / scale) )
	Hud_SetWidth( file.selectionPanel, drawWidth )

	string ltmPlaylist = slotToPlaylistNameMap["ltm"]
	Assert( ltmPlaylist == Playlist_GetLTMSlotPlaylist( IsPrivateMatchLobby() ) )
	bool hasLimitedMode = (ltmPlaylist != "")
	RuiSetBool( rui, "hasLimitedMode", hasLimitedMode )
	RuiSetGameTime( rui, "ltmExpireTime", RUI_BADGAMETIME )
	if ( hasLimitedMode )
	{
		PlaylistScheduleData scheduleData = Playlist_GetScheduleData( ltmPlaylist )
		if ( scheduleData.currentBlock != null )
		{
			TimestampRange currentBlock = expect TimestampRange(scheduleData.currentBlock)
			int remainingDuration       = currentBlock.endUnixTime - GetUnixTimestamp()
			RuiSetGameTime( rui, "ltmExpireTime", Time() + remainingDuration )
		}
	}
}

void function OnCloseModeSelectDialog()
{
	Hud_SetAboveBlur( GetMenu( "LobbyMenu" ), true )

	var modeSelectButton = GetModeSelectButton()
	Hud_SetSelected( modeSelectButton, false )
	Hud_SetFocused( modeSelectButton )

	printt( "Clearing rui to update in game mode select"  )
	file.rankedRUIToUpdate = null
	RemoveCallback_UserInfoUpdated( Ranked_OnUserInfoUpdatedInGameModeSelect )
	uiGlobal.modeSelectMenuOpen = false

	Lobby_OnGamemodeSelectV2Close()
}


void function GamemodeButton_Activate( var button )
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
{
	//

	string playlistName = file.selectButtonPlaylistNameMap[button]
	GamemodeSelectV2_PlayVideo( button, playlistName )
}


void function GamemodeButton_OnLoseFocus( var button )
{
	//
}


void function OnCloseButton_Activate( var button )
{
	CloseAllDialogs()
}


                          
void function OnTournamentConnectButton_Activate( var button )
{
	CloseAllDialogs()
	AdvanceMenu( GetMenu( "TournamentConnectMenu" ) )
}
      


void function Ranked_OnUserInfoUpdatedInGameModeSelect( string hardware, string id )
{
	PrintFunc()
	if ( !IsConnected() )
		return

	if ( !IsLobby() )
		return

	if ( hardware == "" && id == "" )
		return

	CommunityUserInfo ornull cui = GetUserInfo( hardware, id )

	if ( cui == null )
		return

	expect CommunityUserInfo( cui )

	if ( cui.hardware == GetUnspoofedPlayerHardware() && cui.uid == GetPlayerUID() ) //
	{
		if ( file.rankedRUIToUpdate != null  ) //
		{
			printt( "We are updating in Ranked_OnUserInfoUpdatedInGameModeSelect"  )
			PopulateRuiWithRankedBadgeDetails( file.rankedRUIToUpdate, cui.rankScore, cui.rankedLadderPos )
		}

	}
}