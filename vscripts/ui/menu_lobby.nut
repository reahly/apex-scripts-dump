global function InitLobbyMenu
global function Lobby_SetTempSeasonExtensionButtonVisible

global function Lobby_IsInputBlocked
global function SetActiveLobbyPopup
global function ClearActiveLobbyPopup
global function HasActiveLobbyPopup

global struct LobbyPopup
{
	bool functionref( int inputID ) checkBlocksInput
	bool functionref( int inputID ) handleInput
	void functionref()              onClose
}

struct
{
	var  menu
	bool updatingLobbyUI = false
	bool inputsRegistered = false
	bool tabsInitialized = false
	bool newnessInitialized = false

	var postGameButton
	var newsButton
	var socialButton
	var gameMenuButton
	var datacenterButton
	var tempSeasonExtensionButton
	var socialEventPopup

	string previousRotationGroup

	bool firstSessionEntry = true

	LobbyPopup ornull  activeLobbyPopup = null
	table< int, bool > isInputBlocked
} file

void function InitLobbyMenu( var newMenuArg )
//
{
	var menu = GetMenu( "LobbyMenu" )
	file.menu = menu

	RegisterSignal( "LobbyMenuUpdate" )

	AddMenuEventHandler( menu, eUIEvent.MENU_OPEN, OnLobbyMenu_Open )
	AddMenuEventHandler( menu, eUIEvent.MENU_CLOSE, OnLobbyMenu_Close )

	AddMenuEventHandler( menu, eUIEvent.MENU_SHOW, OnLobbyMenu_Show )
	AddMenuEventHandler( menu, eUIEvent.MENU_HIDE, OnLobbyMenu_Hide )

	AddMenuEventHandler( menu, eUIEvent.MENU_GET_TOP_LEVEL, OnLobbyMenu_GetTopLevel )
	//

	AddMenuEventHandler( menu, eUIEvent.MENU_NAVIGATE_BACK, OnLobbyMenu_NavigateBack )

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
	#elseif(NX_PROG)
		AddMenuVarChangeHandler( "NX_canInviteFriends", UpdateFooterOptions )
	#endif

	var postGameButton = Hud_GetChild( menu, "PostGameButton" )
	file.postGameButton = postGameButton
	ToolTipData postGameToolTip
	postGameToolTip.descText = "#MATCH_SUMMARY"
	Hud_SetToolTipData( postGameButton, postGameToolTip )
	HudElem_SetRuiArg( postGameButton, "icon", $"rui/menu/lobby/postgame_icon" )
	HudElem_SetRuiArg( postGameButton, "shortcutText", "%[BACK|TAB]%" )
	Hud_AddEventHandler( postGameButton, UIE_CLICK, PostGameButton_OnActivate )

	var newsButton = Hud_GetChild( menu, "NewsButton" )
	file.newsButton = newsButton
	ToolTipData newsToolTip
	newsToolTip.descText = "#NEWS"
	Hud_SetToolTipData( newsButton, newsToolTip )
	HudElem_SetRuiArg( newsButton, "icon", $"rui/menu/lobby/news_icon" )
	HudElem_SetRuiArg( newsButton, "shortcutText", "%[R_TRIGGER|ESCAPE]%" )
	Hud_AddEventHandler( newsButton, UIE_CLICK, NewsButton_OnActivate )

	var socialButton = Hud_GetChild( menu, "SocialButton" )
	file.socialButton = socialButton
	ToolTipData socialToolTip
	socialToolTip.descText = "#MENU_TITLE_FRIENDS"
	Hud_SetToolTipData( socialButton, socialToolTip )
	HudElem_SetRuiArg( socialButton, "icon", $"rui/menu/lobby/friends_icon" )
	HudElem_SetRuiArg( socialButton, "shortcutText", "%[STICK2|]%" )
	Hud_AddEventHandler( socialButton, UIE_CLICK, SocialButton_OnActivate )

	var gameMenuButton = Hud_GetChild( menu, "GameMenuButton" )
	file.gameMenuButton = gameMenuButton
	ToolTipData gameMenuToolTip
	gameMenuToolTip.descText = "#GAME_MENU"
	Hud_SetToolTipData( gameMenuButton, gameMenuToolTip )
	HudElem_SetRuiArg( gameMenuButton, "icon", $"rui/menu/lobby/settings_icon" )
	HudElem_SetRuiArg( gameMenuButton, "shortcutText", "%[START|ESCAPE]%" )
	Hud_AddEventHandler( gameMenuButton, UIE_CLICK, GameMenuButton_OnActivate )

	var datacenterButton = Hud_GetChild( menu, "DatacenterButton" )
	file.datacenterButton = datacenterButton
	ToolTipData datacenterTooltip
	datacenterTooltip.descText = "#LOWPOP_DATACENTER_BUTTON"
	Hud_SetToolTipData( datacenterButton, datacenterTooltip )
	HudElem_SetRuiArg( datacenterButton, "icon", $"rui/hud/gamestate/net_latency" )
	Hud_AddEventHandler( datacenterButton, UIE_CLICK, OpenLowPopDialogFromButton )

	var tempSeasonExtensionButton = Hud_GetChild( menu, "TEMPTab0ButtonExtender" )
	file.tempSeasonExtensionButton = tempSeasonExtensionButton
	Hud_AddEventHandler( tempSeasonExtensionButton, UIE_CLICK, SeasonTab_OnActivate )

	var socialEventPopup = Hud_GetChild( menu, "SocialPopupPanel" )
	file.socialEventPopup = socialEventPopup

	InitSocialEventPopup( socialEventPopup )

	PerfInitLabel( 1, "1" )
	PerfInitLabel( 2, "2" )
	PerfInitLabel( 3, "3" )
	PerfInitLabel( 4, "4" )
	PerfInitLabel( 5, "5" )
	PerfInitLabel( 6, "6" )
}


void function OnLobbyMenu_Open()
{
	if ( !file.tabsInitialized )
	{
		array<var> panels = GetAllMenuPanels( file.menu )
		foreach ( panel in panels )
		{
			AddTab( file.menu, panel, GetPanelTabTitle( panel ) )
		}

		TabData tabData = GetTabDataForPanel( file.menu )

		tabData.customFirstTabButton = true
		tabData.groupNavHints = true
		tabData.activeTabIdx = GetLobbyDefaultTabIndex()

		file.tabsInitialized = true
	}

	if ( uiGlobal.lastMenuNavDirection == MENU_NAV_FORWARD )
	{
		TabData tabData = GetTabDataForPanel( file.menu )
		ActivateTab( tabData, GetLobbyDefaultTabIndex() )
	}
	else
	{
		TabData tabData = GetTabDataForPanel( file.menu )
		ActivateTab( tabData, tabData.activeTabIdx )
	}

	UpdateNewnessCallbacks()

	thread UpdateLobbyUI()

	Lobby_UpdatePlayPanelPlaylists()

                
    
                                                               
                                
       

	AddCallbackAndCallNow_OnGRXOffersRefreshed( OnGRXStateChanged )
	AddCallbackAndCallNow_OnGRXInventoryStateChanged( OnGRXStateChanged )
}


void function Lobby_SetTempSeasonExtensionButtonVisible( bool state )
{
	Hud_SetVisible( file.tempSeasonExtensionButton, state )
}


void function OnLobbyMenu_Show()
{
	thread LobbyMenuUpdate()
	SocialEventUpdate()
	RegisterInputs()

	Chroma_Lobby()
}


void function OnLobbyMenu_GetTopLevel()
{
	thread TryRunDialogFlowThread()
}


void function OnLobbyMenu_Hide()
{
	Signal( uiGlobal.signalDummy, "LobbyMenuUpdate" )
	ClearActiveLobbyPopup()
	DeregisterInputs()
}


void function OnLobbyMenu_Close()
{
	ClearActiveLobbyPopup()
	ClearNewnessCallbacks()
	DeregisterInputs()

	RemoveCallback_OnGRXOffersRefreshed( OnGRXStateChanged )
	RemoveCallback_OnGRXInventoryStateChanged( OnGRXStateChanged )
}


void function OnGRXStateChanged()
{
	bool ready = GRX_IsInventoryReady() && GRX_AreOffersReady()

	array<var> panels = [
		GetPanel( "SeasonPanel" ),
		GetPanel( "CharactersPanel" ),
		GetPanel( "ArmoryPanel" ),
		GetPanel( "StorePanel" ),
	]

	foreach ( var panel in panels )
	{
		SetPanelTabEnabled( panel, ready )
	}

	TabData tabData     = GetTabDataForPanel( file.menu )
	TabDef seasonTabDef = Tab_GetTabDefByBodyName( tabData, "SeasonPanel" )

	ItemFlavor season = GetLatestSeason( GetUnixTimestamp() )
	HudElem_SetRuiArg( seasonTabDef.button, "seasonHeader", Season_GetShortName( season ) )
	HudElem_SetRuiArg( seasonTabDef.button, "seasonTitle", Season_GetSeasonText( season ) )
	HudElem_SetRuiArg( seasonTabDef.button, "seasonDate", Season_GetTimeRemainingText( season ) )
	HudElem_SetRuiArg( seasonTabDef.button, "smallLogo", Season_GetSmallLogo( season ), eRuiArgType.IMAGE )
	HudElem_SetRuiArg( seasonTabDef.button, "bannerImage", Season_GetLobbyButtonImage( season ), eRuiArgType.IMAGE )

	HudElem_SetRuiArg( seasonTabDef.button, "titleTextColor", Season_GetTitleTextColor( season ), eRuiArgType.COLOR )
	HudElem_SetRuiArg( seasonTabDef.button, "headerTextColor", Season_GetHeaderTextColor( season ), eRuiArgType.COLOR )
	HudElem_SetRuiArg( seasonTabDef.button, "timeRemainingTextColor", Season_GetTimeRemainingTextColor( season ), eRuiArgType.COLOR )

	seasonTabDef.useCustomColors = true
	seasonTabDef.customDefaultBGCol = Season_GetTabBGDefaultCol( season )
	seasonTabDef.customDefaultBarCol = Season_GetTabBarDefaultCol( season )
	seasonTabDef.customFocusedBGCol = Season_GetTabBGFocusedCol( season )
	seasonTabDef.customFocusedBarCol = Season_GetTabBarFocusedCol( season )
	seasonTabDef.customSelectedBGCol = Season_GetTabBGSelectedCol( season )
	seasonTabDef.customSelectedBarCol = Season_GetTabBarSelectedCol( season )

	if ( ready )
	{
		if ( ShouldShowPremiumCurrencyDialog() )
			ShowPremiumCurrencyDialog( false )

		ItemFlavor ornull activeCollectionEvent = GetActiveCollectionEvent( GetUnixTimestamp() )
		bool haveActiveCollectionEvent          = (activeCollectionEvent != null)
		ItemFlavor ornull activeThemedShopEvent = GetActiveThemedShopEvent( GetUnixTimestamp() )
		bool haveActiveThemedShopEvent          = (activeThemedShopEvent != null)

		if ( haveActiveCollectionEvent )
		{
			expect ItemFlavor( activeCollectionEvent )
			if ( CollectionEvent_HasLobbyTheme( activeCollectionEvent ) )
			{
				HudElem_SetRuiArg( seasonTabDef.button, "seasonHeader", "#COLLECTION_EVENT" )
				HudElem_SetRuiArg( seasonTabDef.button, "seasonTitle", CollectionEvent_GetFrontTabText( activeCollectionEvent ) )
				HudElem_SetRuiArg( seasonTabDef.button, "seasonDate", CalEvent_GetTimeRemainingText( activeCollectionEvent ) )
				//
				//

				//
				//
			}
		}
		else if ( haveActiveThemedShopEvent )
		{
			expect ItemFlavor( activeThemedShopEvent )
			if ( ThemedShopEvent_HasLobbyTheme( activeThemedShopEvent ) )
			{
				HudElem_SetRuiArg( seasonTabDef.button, "seasonHeader", "#CURRENT_EVENT" )
				HudElem_SetRuiArg( seasonTabDef.button, "seasonTitle", ThemedShopEvent_GetTabText( activeThemedShopEvent ) )
				HudElem_SetRuiArg( seasonTabDef.button, "seasonDate", CalEvent_GetTimeRemainingText( activeThemedShopEvent ) )
				//
			}
		}
	}
}


void function UpdateNewnessCallbacks()
{
	ClearNewnessCallbacks()

	Newness_AddCallbackAndCallNow_OnRerverseQueryUpdated( NEWNESS_QUERIES.SeasonTab, OnNewnessQueryChangedUpdatePanelTab, GetPanel( "SeasonPanel" ) )
	Newness_AddCallbackAndCallNow_OnRerverseQueryUpdated( NEWNESS_QUERIES.GladiatorTab, OnNewnessQueryChangedUpdatePanelTab, GetPanel( "CharactersPanel" ) )
	Newness_AddCallbackAndCallNow_OnRerverseQueryUpdated( NEWNESS_QUERIES.ArmoryTab, OnNewnessQueryChangedUpdatePanelTab, GetPanel( "ArmoryPanel" ) )
	Newness_AddCallbackAndCallNow_OnRerverseQueryUpdated( NEWNESS_QUERIES.StoreTab, OnNewnessQueryChangedUpdatePanelTab, GetPanel( "StorePanel" ) )
	file.newnessInitialized = true
}


void function ClearNewnessCallbacks()
{
	if ( !file.newnessInitialized )
		return

	Newness_RemoveCallback_OnRerverseQueryUpdated( NEWNESS_QUERIES.SeasonTab, OnNewnessQueryChangedUpdatePanelTab, GetPanel( "SeasonPanel" ) )
	Newness_RemoveCallback_OnRerverseQueryUpdated( NEWNESS_QUERIES.GladiatorTab, OnNewnessQueryChangedUpdatePanelTab, GetPanel( "CharactersPanel" ) )
	Newness_RemoveCallback_OnRerverseQueryUpdated( NEWNESS_QUERIES.ArmoryTab, OnNewnessQueryChangedUpdatePanelTab, GetPanel( "ArmoryPanel" ) )
	Newness_RemoveCallback_OnRerverseQueryUpdated( NEWNESS_QUERIES.StoreTab, OnNewnessQueryChangedUpdatePanelTab, GetPanel( "StorePanel" ) )
	file.newnessInitialized = false
}


void function UpdateLobbyUI()
{
	if ( file.updatingLobbyUI )
		return

	file.updatingLobbyUI = true

	thread UpdateMatchmakingStatus()

	WaitSignal( uiGlobal.signalDummy, "CleanupInGameMenus" )
	file.updatingLobbyUI = false
}


void function LobbyMenuUpdate()
{
	Signal( uiGlobal.signalDummy, "LobbyMenuUpdate" )
	EndSignal( uiGlobal.signalDummy, "LobbyMenuUpdate" )
	EndSignal( uiGlobal.signalDummy, "CleanupInGameMenus" )

	while ( true )
	{
		PlayPanelUpdate()
		UpdateCornerButtons()
		UpdateTabs()
		TrackPlaylistRotation()
		HandleCrossplayPartyInvalid()
		WaitFrame()
	}
}


void function HandleCrossplayPartyInvalid()
{
	//
	if ( GetPersistentVar( "showGameSummary" ) && IsPostGameMenuValid( true ) )
		return

	if ( CrossplayUserOptIn() || GetPartySize() == 1 )
		return

	if( IsDialog( GetActiveMenu() ) )
		return

	//
	string hardware   = GetUnspoofedPlayerHardware()
	Party myParty     = GetParty()
	foreach ( p in myParty.members )
	{
		if ( hardware != p.hardware )
		{
			LeaveParty()

			ConfirmDialogData data
			data.headerText = "#CROSSPLAY_DIALOG_INVALID_PARTY_HEADER"
			data.messageText = Localize( "#CROSSPLAY_DIALOG_INVALID_PARTY_MSG" )

			OpenOKDialogFromData( data )
			break
		}
	}
}


void function TrackPlaylistRotation()
{
	if ( file.previousRotationGroup == "" )
		file.previousRotationGroup = GetPlaylistRotationGroup()

	if ( file.previousRotationGroup != GetPlaylistRotationGroup() )
	{
		file.previousRotationGroup = GetPlaylistRotationGroup()

		if ( IsModeSelectMenuOpen() )
		{
			//
			if ( GamemodeSelectV2_IsEnabled() )
				UpdateOpenModeSelectV2Dialog()
			else if ( GamemodeSelectV3_IsEnabled() )
				UpdateOpenModeSelectV3Dialog()
		}
	}

	string selectedPlaylist = Lobby_GetSelectedPlaylist()
	string rotationGroup    = GetPlaylistVarString( selectedPlaylist, "playlist_rotation_group", "" )
	if ( !Lobby_IsPlaylistAvailable( selectedPlaylist ) && !AreWeMatchmaking() && rotationGroup != "" )
	{
		//
		//
		string uiSlot      = GetPlaylistVarString( selectedPlaylist, "ui_slot", "" )
		string newPlaylist = GetCurrentPlaylistInUiSlot( uiSlot )
		if ( newPlaylist == "" || !Lobby_IsPlaylistAvailable( newPlaylist ) )
			newPlaylist = GetDefaultPlaylist()

		printt( "#PLAYLIST SWTICH", selectedPlaylist, uiSlot, newPlaylist )
		string mapChangeAlias = GetPlaylistVarString( newPlaylist, "map_change_VO_alias", "" )
		//
		if (mapChangeAlias != "")
			PlayLobbyCharacterDialogue( mapChangeAlias )

		Lobby_SetSelectedPlaylist( newPlaylist )
	}
}


void function UpdateCornerButtons()
{
	var playPanel           = GetPanel( "PlayPanel" )
	bool isPlayPanelActive  = IsTabPanelActive( playPanel )
	var postGameButton      = Hud_GetChild( file.menu, "PostGameButton" )
	bool showPostGameButton = isPlayPanelActive && IsPostGameMenuValid()
	Hud_SetVisible( postGameButton, showPostGameButton )
	if ( showPostGameButton )
		Hud_SetX( postGameButton, Hud_GetBaseX( postGameButton ) )
	else
		Hud_SetX( postGameButton, Hud_GetBaseX( postGameButton ) - Hud_GetWidth( postGameButton ) - Hud_GetBaseX( postGameButton ) )

	Hud_SetVisible( file.newsButton, isPlayPanelActive && PromoDialog_HasPages() )
	Hud_SetVisible( file.socialButton, isPlayPanelActive )
	Hud_SetVisible( file.gameMenuButton, isPlayPanelActive )

	var accessibilityHint = Hud_GetChild( playPanel, "AccessibilityHint" )
	Hud_SetVisible( accessibilityHint, isPlayPanelActive && IsAccessibilityChatHintEnabled() && !VoiceIsRestricted() )

	Hud_SetEnabled( file.gameMenuButton, !IsDialog( GetActiveMenu() ) )

	int count = GetOnlineFriendCount( false )
	if ( count > 0 )
	{
		HudElem_SetRuiArg( file.socialButton, "buttonText", "" + count )
		Hud_SetWidth( file.socialButton, Hud_GetBaseWidth( file.socialButton ) * 2 )
		InitButtonRCP( file.socialButton )
	}
	else
	{
		HudElem_SetRuiArg( file.socialButton, "buttonText", "" )
		Hud_ReturnToBaseSize( file.socialButton )
		InitButtonRCP( file.socialButton )
	}

	{
		bool datacenterButtonVisible = false
		if ( Lobby_GetSelectedPlaylist() != "" && IsFullyConnected() )
		{
			bool lowPop = IsLowPopPlaylist( Lobby_GetSelectedPlaylist() )
			bool sameDC = GetCurrentMatchmakingDatacenterETA( Lobby_GetSelectedPlaylist() ).datacenterIdx == GetCurrentRankedMatchmakingDatacenterETA( Lobby_GetSelectedPlaylist() ).datacenterIdx
			datacenterButtonVisible = isPlayPanelActive && lowPop && !sameDC && !AreWeMatchmaking()
		}

		Hud_SetVisible( file.datacenterButton, datacenterButtonVisible )
	}
}


void function UpdateTabs()
{
	if ( IsFullyConnected() )
	{
		//
	} //
}


void function RegisterInputs()
{
	if ( file.inputsRegistered )
		return

	RegisterButtonPressedCallback( BUTTON_START, GameMenuButton_OnActivate )
	RegisterButtonPressedCallback( BUTTON_BACK, PostGameButton_OnActivate )
	RegisterButtonPressedCallback( BUTTON_X, ButtonX_OnActivate )
	RegisterButtonPressedCallback( BUTTON_Y, ButtonY_OnActivate )
	RegisterButtonPressedCallback( BUTTON_STICK_LEFT, ButtonStickL_OnActivate )
	RegisterButtonPressedCallback( KEY_Y, KeyY_OnActivate )
	RegisterButtonPressedCallback( KEY_N, KeyN_OnActivate )
	RegisterButtonPressedCallback( KEY_B, KeyB_OnActivate )

	RegisterButtonPressedCallback( KEY_TAB, SeasonTab_OnActivate )
	RegisterButtonPressedCallback( KEY_ENTER, OnLobbyMenu_FocusChat )
	RegisterButtonPressedCallback( BUTTON_TRIGGER_RIGHT, NewsButton_OnActivate )
	RegisterButtonPressedCallback( BUTTON_STICK_RIGHT, SocialButton_OnActivate )
	file.inputsRegistered = true
}


void function DeregisterInputs()
{
	if ( !file.inputsRegistered )
		return

	DeregisterButtonPressedCallback( BUTTON_START, GameMenuButton_OnActivate )
	DeregisterButtonPressedCallback( BUTTON_BACK, PostGameButton_OnActivate )
	DeregisterButtonPressedCallback( BUTTON_X, ButtonX_OnActivate )
	DeregisterButtonPressedCallback( BUTTON_Y, ButtonY_OnActivate )
	DeregisterButtonPressedCallback( BUTTON_STICK_LEFT, ButtonStickL_OnActivate )
	DeregisterButtonPressedCallback( KEY_Y, KeyY_OnActivate )
	DeregisterButtonPressedCallback( KEY_N, KeyN_OnActivate )
	DeregisterButtonPressedCallback( KEY_B, KeyB_OnActivate )

	DeregisterButtonPressedCallback( KEY_TAB, SeasonTab_OnActivate )
	DeregisterButtonPressedCallback( KEY_ENTER, OnLobbyMenu_FocusChat )
	DeregisterButtonPressedCallback( BUTTON_TRIGGER_RIGHT, NewsButton_OnActivate )
	DeregisterButtonPressedCallback( BUTTON_STICK_RIGHT, SocialButton_OnActivate )
	file.inputsRegistered = false
}


void function SeasonTab_OnActivate( var button )
{
	TabData tabData = GetTabDataForPanel( file.menu )

	if ( !IsTabIndexEnabled( tabData, Tab_GetTabIndexByBodyName( tabData, "SeasonPanel" ) ) )
		return

	if ( IsDialog( GetActiveMenu() ) )
		return

	if ( !IsTabPanelActive( GetPanel( "PlayPanel" ) ) )
		return

	JumpToSeasonTab()
}


void function NewsButton_OnActivate( var button )
{
	if ( !PromoDialog_CanShow() )
		return

	AdvanceMenu( GetMenu( "PromoDialog" ) )
}


void function SocialButton_OnActivate( var button )
{
	if ( IsDialog( GetActiveMenu() ) )
		return

	if ( !IsTabPanelActive( GetPanel( "PlayPanel" ) ) )
		return

	#if(PC_PROG)
		if ( !MeetsAgeRequirements() )
		{
			ConfirmDialogData dialogData
			dialogData.headerText = "#UNAVAILABLE"
			dialogData.messageText = "#ORIGIN_UNDERAGE_ONLINE"
			dialogData.contextImage = $"ui/menu/common/dialog_notice"

			OpenOKDialogFromData( dialogData )
			return
		}
	#endif

	AdvanceMenu( GetMenu( "SocialMenu" ) )
}


void function GameMenuButton_OnActivate( var button )
{
	if ( InputIsButtonDown( BUTTON_STICK_LEFT ) ) //
		return

	if ( IsDialog( GetActiveMenu() ) )
		return

	AdvanceMenu( GetMenu( "SystemMenu" ) )
}


void function PostGameButton_OnActivate( var button )
{
	if ( IsDialog( GetActiveMenu() ) )
		return

	if ( !IsTabPanelActive( GetPanel( "PlayPanel" ) ) )
		return

	thread OnLobbyMenu_PostGameOrChat( button )
}


void function OnLobbyMenu_NavigateBack()
{
	//
	//
	//
	//
	//
	//

	if ( GetMenuActiveTabIndex( file.menu ) == 1 )
	{
		if ( !IsControllerModeActive() )
			AdvanceMenu( GetMenu( "SystemMenu" ) )
	}
	else
	{
		TabData tabData = GetTabDataForPanel( file.menu )
		ActivateTab( tabData, GetLobbyDefaultTabIndex() )
		UpdateMenuTabs()
	}
}


int function GetLobbyDefaultTabIndex()
{
	TabData lobbyTabData = GetTabDataForPanel( GetMenu( "LobbyMenu" ) )
	return Tab_GetTabIndexByBodyName( lobbyTabData, "PlayPanel" )
}


void function OnLobbyMenu_PostGameOrChat( var button )
{
	var savedMenu = GetActiveMenu()

	#if(CONSOLE_PROG)
		const float HOLD_FOR_CHAT_DELAY = 1.0
		float startTime = Time()
		while ( !VoiceIsRestricted() && (InputIsButtonDown( BUTTON_BACK ) || InputIsButtonDown( KEY_TAB ) && GetConVarInt( "hud_setting_accessibleChat" ) != 0) )
		{
			if ( Time() - startTime > HOLD_FOR_CHAT_DELAY )
			{
				if ( GetPartySize() > 1 )
				{
					printt( "starting message mode", Hud_IsEnabled( GetLobbyChatBox() ) )
					Hud_StartMessageMode( GetLobbyChatBox() )
				}
				else
				{
					ConfirmDialogData dialogData
					dialogData.headerText = "#ACCESSIBILITY_NO_CHAT_HEADER"
					dialogData.messageText = "#ACCESSIBILITY_NO_CHAT_MESSAGE"
					dialogData.contextImage = $"ui/menu/common/dialog_notice"

					OpenOKDialogFromData( dialogData )
				}
				return
			}

			WaitFrame()
		}
	#endif

	if ( IsPostGameMenuValid() && savedMenu == GetActiveMenu() )
	{
		if ( GetPersistentVar( "pve.postGame_isValid" ) )
		{
			OpenPostGameFreelanceMenu( GetPersistentVar( "showGameSummary" ) == true )
		}
		else
		{
			thread PostGameFlow()
		}
	}
}


void function PostGameFlow()
{
                        
                                                                                           
       
	bool showRankedSummary = GetPersistentVarAsInt( "showRankedSummary" ) != 0
	bool isFirstTime       = GetPersistentVarAsInt( "showGameSummary" ) != 0

	OpenPostGameMenu( null )

	if ( GetActiveBattlePass() != null )
	{
		OpenPostGameBattlePassMenu( isFirstTime )
	}

	if ( showRankedSummary )
	{
		OpenRankedSummary( isFirstTime )
	}

                        
                          
   
                                   
   
       
}


void function OnLobbyMenu_FocusChat( var panel )
{
	#if(PC_PROG)
		if ( IsDialog( GetActiveMenu() ) )
			return

		if ( !IsTabPanelActive( GetPanel( "PlayPanel" ) ) )
			return

		if ( GetPartySize() > 1 )
		{
			var playPanel = Hud_GetChild( file.menu, "PlayPanel" )
			var textChat  = Hud_GetChild( playPanel, "ChatRoomTextChat" )
			Hud_SetFocused( Hud_GetChild( textChat, "ChatInputLine" ) )
		}
	#endif
}


bool function Lobby_IsInputBlocked( int inputID )
{
	if ( file.activeLobbyPopup == null )
		return false

	LobbyPopup ornull lobbyPopup = file.activeLobbyPopup
	expect LobbyPopup( lobbyPopup )
	return lobbyPopup.checkBlocksInput( inputID )
}


void function ButtonB_OnActivate( var button )
{
	DispatchLobbyPopupInput( BUTTON_B )
}


void function KeyEscape_OnActivate( var button )
{
	DispatchLobbyPopupInput( KEY_ESCAPE )
}


void function ButtonX_OnActivate( var button )
{
	DispatchLobbyPopupInput( BUTTON_X )
}


void function ButtonY_OnActivate( var button )
{
	DispatchLobbyPopupInput( BUTTON_Y )
}


void function ButtonStickL_OnActivate( var button )
{
	DispatchLobbyPopupInput( BUTTON_STICK_RIGHT )
}


void function KeyY_OnActivate( var button )
{
	DispatchLobbyPopupInput( KEY_Y )
}


void function KeyN_OnActivate( var button )
{
	DispatchLobbyPopupInput( KEY_N )
}


void function KeyB_OnActivate( var button )
{
	DispatchLobbyPopupInput( KEY_B )
}


void function DispatchLobbyPopupInput( int inputID )
{
	if ( file.activeLobbyPopup == null )
		return

	if ( IsDialog( GetActiveMenu() ) )
		return

	LobbyPopup ornull lobbyPopup = file.activeLobbyPopup
	expect LobbyPopup( lobbyPopup )
	lobbyPopup.handleInput( inputID )
}


void function SetActiveLobbyPopup( LobbyPopup popup )
{
	Assert( file.activeLobbyPopup == null )

	file.activeLobbyPopup = popup
}


bool function HasActiveLobbyPopup()
{
	return file.activeLobbyPopup != null
}


void function ClearActiveLobbyPopup()
{
	if ( file.activeLobbyPopup != null )
	{
		LobbyPopup ornull lobbyPopup = file.activeLobbyPopup
		expect LobbyPopup( lobbyPopup )

		file.activeLobbyPopup = null

		lobbyPopup.onClose()
	}
}
