untyped

global const bool EDIT_LOADOUT_SELECTS = true
global const string PURCHASE_SUCCESS_SOUND = "UI_Menu_Store_Purchase_Success"
global const float LOADSCREEN_FINISHED_MAX_WAIT_TIME = 5.0

global function UICodeCallback_RemoteMatchInfoUpdated
global function UICodeCallback_InboxUpdated
global function UICodeCallback_CloseAllMenus
global function UICodeCallback_ActivateMenus
global function UICodeCallback_LevelInit
global function UICodeCallback_LevelLoadingStarted
global function UICodeCallback_LevelLoadingFinished
global function UICodeCallback_LevelShutdown
global function UICodeCallback_FullyConnected
global function UICodeCallback_OnConnected
global function UICodeCallback_OnFocusChanged
global function UICodeCallback_NavigateBack
global function UICodeCallback_ToggleInGameMenu
global function UICodeCallback_ToggleInventoryMenu
global function UICodeCallback_ToggleMap
global function UICodeCallback_TryCloseDialog
global function UICodeCallback_UpdateLoadingLevelName
global function UICodeCallback_ConsoleKeyboardClosed
global function UICodeCallback_ErrorDialog
global function UICodeCallback_AcceptInvite
global function UICodeCallback_OnDetenteDisplayed
global function UICodeCallback_OnSpLogDisplayed
global function UICodeCallback_KeyBindOverwritten
global function UICodeCallback_KeyBindSet
global function UICodeCallback_PartyUpdated
global function UICodeCallback_PartyMemberAdded
global function UICodeCallback_PartyMemberRemoved
global function AddCallback_OnPartyUpdated
global function RemoveCallback_OnPartyUpdated
global function AddCallback_OnPartyMemberAdded
global function RemoveCallback_OnPartyMemberAdded
global function AddCallback_OnPartyMemberRemoved
global function RemoveCallback_OnPartyMemberRemoved
global function AddCallback_OnTopLevelCustomizeContextChanged
global function RemoveCallback_OnTopLevelCustomizeContextChanged
global function AddUICallback_LevelLoadingFinished
global function AddUICallback_LevelShutdown
global function AddUICallback_OnResolutionChanged
global function UICodeCallback_UserInfoUpdated
global function UICodeCallback_UIScriptResetComplete
global function UICodeCallback_ReconnectFailed
global function UICodeCallback_LoadscreenFinished
global function UICodeCallback_MatchMakeExpired

global function UICodeCallback_ClubRequestFinished
global function UICodeCallback_ClubEventLogUpdate
global function UICodeCallback_ClubChatLogUpdate
global function UICodeCallback_ClubMembershipNotification
global function UICodeCallback_EadpSearchRequestFinished
global function UICodeCallback_EadpFriendsChanged
global function UICodeCallback_EadpClubMemberPresence
global function UICodeCallback_EadpInviteDataChanged

#if(NX_PROG)
global function UICodeCallback_LobbyAllowStaticScene
#endif

global function TryRunDialogFlowThread
global function ShouldShowPremiumCurrencyDialog
global function ShowPremiumCurrencyDialog

global function AdvanceMenu
global function CloseActiveMenu
global function CloseActiveMenuNoParms
global function CloseAllMenus
global function CloseAllDialogs
global function CloseAllToTargetMenu
global function PrintMenuStack
global function GetActiveMenu
global function IsMenuVisible
global function IsPanelActive
global function GetActiveMenuName
global function GetMenu
global function GetPanel
global function GetAllMenuPanels
global function GetMenuTabBodyPanels
global function InitGamepadConfigs
global function InitMenus
global function AdvanceMenuEventHandler
global function PCSwitchTeamsButton_Activate
global function PCToggleSpectateButton_Activate
global function AddMenuElementsByClassname
global function SetPanelDefaultFocus
global function PanelFocusDefault
global function AddMenuEventHandler
global function AddPanelEventHandler
global function AddPanelEventHandler_FocusChanged
global function SetPanelInputHandler
global function AddButtonEventHandler
global function AddEventHandlerToButton
global function AddEventHandlerToButtonClass
global function RemoveEventHandlerFromButtonClass
global function UIMusicUpdate
global function PlayCustomUIMusic
global function CancelCustomUIMusic
global function IsMenuInMenuStack
global function RemoveFromMenuStack
global function GetTopNonDialogMenu
global function SetDialog
global function SetPopup
global function SetAllowControllerFooterClick
global function SetClearBlur
global function SetPanelClearBlur
global function ClearMenuBlur
global function UpdateMenuBlur
global function IsDialog
global function IsDialogOnlyActiveMenu
global function AllowControllerFooterClick
global function AddMenuThinkFunc
global function IsTopLevelCustomizeContextValid
global function GetTopLevelCustomizeContext
global function SetTopLevelCustomizeContext
global function SetGamepadCursorEnabled
global function IsGamepadCursorEnabled
global function IsCommsMenuOpen
global function IsModeSelectMenuOpen

global function ButtonClass_AddMenu

global function PCBackButton_Activate

global function RegisterMenuVarInt
global function GetMenuVarInt
global function SetMenuVarInt
global function RegisterMenuVarBool
global function GetMenuVarBool
global function SetMenuVarBool
global function RegisterMenuVarVar
global function GetMenuVarVar
global function SetMenuVarVar
global function AddMenuVarChangeHandler
global function EnterLobbySurveyReset

global function ClientToUI_SetCommsMenuOpen

global function InviteFriends
global function OpenInGameMenu

global function HACK_DelayedSetFocus_BecauseWhy

global function InitButtonRCP

global function AddCallbackAndCallNow_UserInfoUpdated
global function RemoveCallback_UserInfoUpdated

global function AddCallbackAndCallNow_RemoteMatchInfoUpdated
global function RemoveCallback_RemoteMatchInfoUpdated

global function UpdateMatchPINData

global function _IsMenuThinkActive
global function UpdateActiveMenuThink

global function DialogFlow
global function SetDialogFlowPersistenceTables
global function GetDialogFlowTablesValueOrPersistence
global function IsLoadScreenFinished

global function AttemptReconnect

global function IncrementNumDialogFlowDialogsDisplayed

#if(DURANGO_PROG)
global function OpenXboxPartyApp
global function OpenXboxHelp
#endif //

#if(DEV)
global function OpenDevMenu
#endif //

const string SOUND_MATCHMAKING_CANCELED = "ui_networks_invitation_canceled" //

struct
{
	array<void functionref()>                   partyUpdatedCallbacks
	array<void functionref()>                   partymemberAddedCallbacks
	array<void functionref()>                   partymemberRemovedCallbacks
	table<var, array<void functionref( var )> > topLevelCustomizeContextChangedCallbacks
	array<void functionref()>                   levelLoadingFinishedCallbacks
	array<void functionref()>                   levelShutdownCallbacks

	array<void functionref( string, string )>   userInfoChangedCallbacks //
	array<void functionref()>                   remoteMatchInfoChangedCallbacks //

	int numDialogFlowDialogsDisplayed = 0

	bool menuThinkThreadActive = false

	bool TEMP_circularReferenceCleanupEnabled = true

	bool loadScreenFinished = false

	float reconnectStartTime

	table<string, var> dialogFlowPersistenceChecksValuesTable
	table<string, float> dialogFlowPersistenceChecksTimeTable


	int partyMemberCount
} file


void function UICodeCallback_InboxUpdated()
{
	//
}


void function UICodeCallback_CloseAllMenus()
{
	printt( "UICodeCallback_CloseAllMenus" )
	CloseAllMenus()
	//
}

//
void function UICodeCallback_ActivateMenus()
{
	if ( IsConnected() )
		return

	var mainMenu = GetMenu( "MainMenu" )

	printt( "UICodeCallback_ActivateMenus:", GetActiveMenu() && Hud_GetHudName( GetActiveMenu() ) != "" )
	if ( uiGlobal.menuStack.len() == 0 )
		AdvanceMenu( mainMenu )

	if ( GetActiveMenu() == mainMenu )
		Signal( uiGlobal.signalDummy, "OpenErrorDialog" )

	UIMusicUpdate()

	#if(DURANGO_PROG)
		Durango_LeaveParty()
	#endif //
}


void function UICodeCallback_ToggleInGameMenu()
{
	if ( !IsFullyConnected() )
		return

	var activeMenu = GetActiveMenu()
	bool isLobby   = IsLobby()

	if ( isLobby )
	{
		if ( activeMenu == null )
		{
			if ( IsPrivateMatch() )
			{
				printf( "PrivateMatchMenuDebug: Advancing Lobby Menu" )
				AdvanceMenu( GetMenu( "PrivateMatchLobbyMenu" ) )
			}
			else
			{
				AdvanceMenu( GetMenu( "LobbyMenu" ) )
			}
		}
		else if ( activeMenu == GetMenu( "SystemMenu" ) )
		{
			CloseActiveMenu()
		}
		return
	}

	var ingameMenu = GetMenu( "SystemMenu" )

	//
	if ( IsMenuInMenuStack( GetMenu( "CharacterSelectMenuNew" ) ) )
		return

	if ( IsDialog( activeMenu ) )
	{
		//
	}
	else if ( IsSurvivalMenuEnabled() )
	{
		if ( activeMenu == null || SURVIVAL_IsAnInventoryMenuOpened() )
		{
			thread ToggleInventoryOrOpenOptions()
		}
		else if ( InputIsButtonDown( KEY_ESCAPE ) && uiGlobal.menuData[ uiGlobal.activeMenu ].navBackFunc != null )
		{
			uiGlobal.menuData[ uiGlobal.activeMenu ].navBackFunc()
		}
		else if ( DeathScreenIsOpen() )    //
		{
			thread OpenOptionsOnHold()
		}
		else
		{
			CloseActiveMenu()
		}
	}
	else if ( !isLobby )
	{
		if ( activeMenu == null )
			AdvanceMenu( ingameMenu )
		else
			CloseAllMenus()
	}
}


void function ToggleInventoryOrOpenOptions()
{
	float startTime = Time()
	float duration  = 0.3
	float endTIme   = startTime + duration

	while ( InputIsButtonDown( BUTTON_START ) && Time() < endTIme )
	{
		WaitFrame()
	}

	if ( GetActiveMenu() != null )
	{
		if ( IsDialog( GetActiveMenu() ) )
			return
	}

	if ( InputIsButtonDown( KEY_ESCAPE ) && IsCommsMenuOpen() )
	{
		RunClientScript( "CommsMenu_HandleKeyInput", KEY_ESCAPE ) //
		return
	}

	if ( (Time() >= endTIme && InputIsButtonDown( BUTTON_START )) || (InputIsButtonDown( KEY_ESCAPE ) && !SURVIVAL_IsAnInventoryMenuOpened()) )
	{
		if ( IsShowingMap() && InputIsButtonDown( KEY_ESCAPE ) )
		{
			RunClientScript( "ClientToUI_HideScoreboard" )
			return
		}

		OpenSystemMenu()
	}
	else
	{
		if ( IsFullyConnected() )
		{
			if ( IsShowingMap() )
				RunClientScript( "ClientToUI_HideScoreboard" )

                             
				//
				if ( IsPrivateMatchGameStatusMenuOpen() )
					ClosePrivateMatchGameStatusMenu( null )

				if ( !IsPrivateMatchGameStatusMenuOpen() && IsPrivateMatch() )
				{
					RunClientScript( "PrivateMatch_OpenGameStatusMenu" )
					//
				}
         

			if ( SURVIVAL_IsAnInventoryMenuOpened() )
			{
				if ( uiGlobal.menuData[ uiGlobal.activeMenu ].navBackFunc != null )
				{
					uiGlobal.menuData[ uiGlobal.activeMenu ].navBackFunc()
				}
				else
				{
					CloseActiveMenu()
				}
			}
			else
			{
				RunClientScript( "OpenSurvivalMenu" )
			}
		}
	}
}


void function OpenOptionsOnHold()
{
	//

	float startTime = Time()
	float duration  = 0.3
	float endTIme   = startTime + duration

	while ( InputIsButtonDown( BUTTON_START ) && Time() < endTIme )
	{
		WaitFrame()
	}

	if ( GetActiveMenu() != null )
	{
		if ( IsDialog( GetActiveMenu() ) )
			return
	}

	//
	if ( InputIsButtonDown( KEY_ESCAPE ) && IsCommsMenuOpen() )
	{
		RunClientScript( "CommsMenu_HandleKeyInput", KEY_ESCAPE ) //
		return
	}

	if ( Time() >= endTIme && InputIsButtonDown( BUTTON_START ) ) //
	{
		if ( IsShowingMap() && InputIsButtonDown( KEY_ESCAPE ) )
		{
			RunClientScript( "ClientToUI_HideScoreboard" )
			return
		}

		OpenSystemMenu()
	}
}


void function UICodeCallback_ToggleInventoryMenu()
{
	if ( !IsFullyConnected() )
		return

	var activeMenu = GetActiveMenu()
	bool isLobby   = IsLobby()

	if ( isLobby || IsDialog( activeMenu ) )
		return

	if ( !activeMenu )
	{
		RunClientScript( "PROTO_OpenInventoryOrSpecifiedMenu", GetUIPlayer() )
	}
	else
	{
		CloseAllMenus()
	}
}


void function UICodeCallback_ToggleMap()
{
	if ( !IsFullyConnected() )
		return

	if ( IsLobby() )
		return

	RunClientScript( "ClientToUI_ToggleScoreboard" )
}


void function OpenInGameMenu( var button )
{
	var ingameMenu = GetMenu( "SystemMenu" )

	AdvanceMenu( ingameMenu )
}

//
//
bool function UICodeCallback_LevelLoadingStarted( string levelname )
{
	printt( "UICodeCallback_LevelLoadingStarted: " + levelname )

	CloseAllMenus()

	Signal( uiGlobal.signalDummy, "EndFooterUpdateFuncs" )
	Signal( uiGlobal.signalDummy, "EndSearchForPartyServerTimeout" )

	uiGlobal.loadingLevel = levelname

	if ( uiGlobal.playingVideo )
		Signal( uiGlobal.signalDummy, "PlayVideoEnded" )

	if ( uiGlobal.playingCredits )
		Signal( uiGlobal.signalDummy, "PlayingCreditsDone" )

	//
	Signal( uiGlobal.signalDummy, "PGDisplay" )

	#if(CONSOLE_PROG)
		if ( !Console_IsSignedIn() )
			return false
	#endif

	return true
}

//
bool function UICodeCallback_UpdateLoadingLevelName( string levelname )
{
	printt( "UICodeCallback_UpdateLoadingLevelName: " + levelname )

	#if(CONSOLE_PROG)
		if ( !Console_IsSignedIn() )
			return false
	#endif

	return true
}


void function UICodeCallback_LevelLoadingFinished( bool error )
{
	printt( "UICodeCallback_LevelLoadingFinished: " + uiGlobal.loadingLevel + " (" + error + ")" )

	UIMusicUpdate()

	if ( !IsLobby() )
		HudChat_ClearTextFromAllChatPanels()
	else
		uiGlobal.lobbyFromLoadingScreen = true

	uiGlobal.loadingLevel = ""
	Signal( uiGlobal.signalDummy, "LevelFinishedLoading" )

	foreach ( callback in file.levelLoadingFinishedCallbacks )
		callback()

	TEMP_CircularReferenceCleanup()
}


void function UICodeCallback_LevelInit( string levelname )
{
	printt( "UICodeCallback_LevelInit: " + levelname + ", IsConnected(): ", IsConnected() )
	file.loadScreenFinished = false //
}


void function UICodeCallback_FullyConnected( string levelname )
{
	Assert( IsConnected() )

	StopVideos( eVideoPanelContext.ALL )

	uiGlobal.loadedLevel = levelname

	printt( "UICodeCallback_FullyConnected: " + uiGlobal.loadedLevel + ", IsFullyConnected(): ", IsFullyConnected() )

	//
	//
	//
	//
	//
	//
	//
	//

	InitXPData() //

	#if(DEV)
		ShDevUtility_Init()
	#endif
	ShDevWeapons_Init()
	ShEHI_LevelInit_Begin()
	ShPakRequests_LevelInit()
	ShPersistentData_LevelInit_Begin()
	ShItems_LevelInit_Begin()
	ShGRX_LevelInit()
	Entitlements_LevelInit()
	CustomizeCommon_Init()
	ShLoadouts_LevelInit_Begin()
	ShCharacters_LevelInit()
	ShPassives_Init()
	ShCharacterAbilities_LevelInit()
	ShCharacterCosmetics_LevelInit()
	ShCalEvent_LevelInit()
	Vouchers_LevelInit()
	TimeGatedLoginRewards_Init()
	CollectionEvents_Init()
	ThemedShopEvents_Init()
	BuffetEvents_Init()
	StoryChallengeEvents_Init()
	ShSkydiveTrails_LevelInit()
	Sh_Ranked_ItemRegistrationInit()
	Sh_Ranked_Init()
                        
                                        
                        
       
	ShWeapons_LevelInit()
	ShWeaponCosmetics_LevelInit()
	ShGladiatorCards_LevelInit()
	ShQuips_Init()
	ShLoadscreen_LevelInit()
	ShMusic_LevelInit()
	ShBattlePass_LevelInit()
	Clubs_Init()
	PlayPanel_LevelInit()
                        
		TreasureBox_SharedInit()
		SeasonQuest_SharedInit()
          
	MenuCamera_Init()
	MenuScene_Init()
	MeleeShared_Init()
	MeleeSyncedShared_Init()
	ShPing_Init()
	ShQuickchat_Init()
	ShChallenges_LevelInit_PreStats()
	ShItems_LevelInit_Finish()
	ShItemPerPlayerState_LevelInit()
	UserInfoPanels_LevelInit()
	ShLoadouts_LevelInit_Finish()
	UiNewnessQueries_LevelInit()
	ShStatsInternals_LevelInit()
	ShStats_LevelInit()
	ShChallenges_LevelInit_PostStats()
	ShPlaylist_Init()
                
                
       

	ShPersistentData_LevelInit_Finish()
	ShPassPanel_LevelInit()
            
                            
       
	ShEHI_LevelInit_End()

	//

	SURVIVAL_Loot_All_InitShared()
	//
	//

	#if(DEV)
		UpdatePrecachedSPWeapons()
	#endif

                       
                      
       

                           
		PrivateMatch_Init()
       

                   
          
                            
        
       
	NewScriptInit_Level()

	if ( !uiGlobal.loadoutsInitialized )
	{
		string gameModeString = GetConVarString( "mp_gamemode" )
		if ( gameModeString != "solo" )
		{
			DeathHints_Init()
			//
			uiGlobal.loadoutsInitialized = true
		}
	}

	//
	//
	//

	if ( !uiGlobal.eventHandlersAdded )
	{
		uiGlobal.eventHandlersAdded = true
	}

	//

	bool isLobby = IsLobbyMapName( levelname )

	string gameModeString = GetConVarString( "mp_gamemode" )
	if ( gameModeString == "" )
		gameModeString = "<null>"

	Assert( gameModeString == GetConVarString( "mp_gamemode" ) )
	Assert( gameModeString != "" )

	int gameModeId        = GameMode_GetGameModeId( gameModeString )
	int mapId             = -1
	int difficultyLevelId = 0
	int roundId           = 0
	if ( isLobby )
	{
		file.dialogFlowPersistenceChecksValuesTable.clear()
		file.dialogFlowPersistenceChecksTimeTable.clear()
		Durango_OnLobbySessionStart( gameModeId, difficultyLevelId )
	}
	else
	{
		Durango_OnMultiplayerRoundStart( gameModeId, mapId, difficultyLevelId, roundId, 0 )
	}

	foreach ( callbackFunc in uiGlobal.onLevelInitCallbacks )
	{
		callbackFunc()
	}
	thread UpdateMenusOnConnectThread( levelname )

	uiGlobal.previousLevel = uiGlobal.loadedLevel
	uiGlobal.previousPlaylist = GetCurrentPlaylistName()
	uiGlobal.isShowingMap = false

	if ( !IsLobby() )
		uiGlobal.matchPinData = {}

	file.TEMP_circularReferenceCleanupEnabled = GetCurrentPlaylistVarBool( "circular_reference_cleanup_enabled", true )
}


void function UICodeCallback_LevelShutdown()
{
	ShutdownAllPanels()
	CloseAllMenus()

	ShGladiatorCards_LevelShutdown()
	ShLoadouts_LevelShutdown()
	VideoChannelManager_OnLevelShutdown()
	ImagePakLoad_OnLevelShutdown()
	ShGRX_LevelShutdown()

	Signal( uiGlobal.signalDummy, "LevelShutdown" )

	printt( "UICodeCallback_LevelShutdown: " + uiGlobal.loadedLevel )

	StopVideos( eVideoPanelContext.ALL )

	if ( uiGlobal.loadedLevel != "" )
		Signal( uiGlobal.signalDummy, "CleanupInGameMenus" )

	uiGlobal.loadedLevel = ""

	foreach ( callbackFunc in file.levelShutdownCallbacks )
	{
		callbackFunc()
	}

	UiNewnessQueries_LevelShutdown()

	TEMP_CircularReferenceCleanup()
}


void function UICodeCallback_NavigateBack()
{
	var activeMenu = GetActiveMenu()
	if ( activeMenu == null )
		return

	if ( IsDialog( activeMenu ) )
	{
		if ( uiGlobal.menuData[ activeMenu ].dialogData.noChoice ||
		uiGlobal.menuData[ activeMenu ].dialogData.forceChoice ||
		Time() < uiGlobal.dialogInputEnableTime )
			return
	}

	Assert( activeMenu in uiGlobal.menuData )
	if ( uiGlobal.menuData[ activeMenu ].navBackFunc != null )
	{
		if ( IsPanelTabbed( activeMenu ) )
			_OnTab_NavigateBack( null )

		uiGlobal.menuData[ activeMenu ].navBackFunc()
		return
	}

	CloseActiveMenu( true )
}

//
void function UICodeCallback_OnConnected()
{
	//
}


void function UICodeCallback_OnFocusChanged( var oldFocus, var newFocus )
{
	foreach ( panel in uiGlobal.activePanels )
	{
		foreach ( focusChangedFunc in uiGlobal.panelData[ panel ].focusChangedFuncs )
			focusChangedFunc( panel, oldFocus, newFocus )
	}
}

//
bool function UICodeCallback_TryCloseDialog()
{
	var activeMenu = GetActiveMenu()

	if ( !IsDialog( activeMenu ) )
		return true

	if ( uiGlobal.menuData[ activeMenu ].dialogData.forceChoice )
		return false

	CloseAllDialogs()
	Assert( !IsDialog( GetActiveMenu() ) )
	return true
}


void function UICodeCallback_ConsoleKeyboardClosed()
{
	switch ( GetActiveMenu() )
	{
		//
		//
		//
		//
		//
		//
		//
		//
		//
		//
		//
		//
		//
		//

		default:
			break
	}
}


void function UICodeCallback_OnDetenteDisplayed()
{
	//
	//
	//
	//
	//
	//
	//
	//
}


void function UICodeCallback_OnSpLogDisplayed()
{
}


void function UICodeCallback_ErrorDialog( string errorDetails )
{
	printt( "UICodeCallback_ErrorDialog: " + errorDetails )
	thread OpenErrorDialogThread( errorDetails )
}


void function UICodeCallback_AcceptInviteThread( string accesstoken, string from, string from_hardware )
{
	printt( "UICodeCallback_AcceptInviteThread '" + accesstoken + "' from '" + from + "' " + from_hardware )

	#if(PLAYSTATION_PROG)
		if ( !Ps4_PSN_Is_Loggedin() )
		{
			Ps4_LoginDialog_Schedule()
			while ( Ps4_LoginDialog_Running() )
				WaitFrame()

			if ( !Ps4_PSN_Is_Loggedin() )
				return
		}

		/*


























*/

	#endif //

	SubscribeToChatroomPartyChannel( accesstoken, from, from_hardware )
}


void function UICodeCallback_AcceptInvite( string accesstoken, string fromxid, string from_hardware )
{
	printt( "UICodeCallback_AcceptInvite '" + accesstoken + "' from '" + fromxid + "' " + from_hardware )
	thread    UICodeCallback_AcceptInviteThread( accesstoken, fromxid, from_hardware )
}

#if(NX_PROG)
bool function UICodeCallback_LobbyAllowStaticScene()
{
	return IsPlayPanelCurrentlyTopLevel() || IsClubLandingPanelCurrentlyTopLevel() || IsSeaonPanelCurrentlyTopLevel() || IsModeSelectMenuOpen()
}
#endif


void function AdvanceMenu( var newMenu )
{
	//
	//
	//
	//
	//

	var currentMenu = GetActiveMenu()

	if ( currentMenu )
	{
		//
		if ( currentMenu == newMenu )
			return

		//
		//
		Assert( !IsDialog( currentMenu ) || IsPopup( newMenu ), "Tried opening menu: " + Hud_GetHudName( newMenu ) + " when activeMenu was: " + Hud_GetHudName( currentMenu ) )
	}

	if ( currentMenu && !IsDialog( newMenu ) ) //
	{
		CloseMenu( currentMenu )
		ClearMenuBlur( currentMenu )

		if ( uiGlobal.menuData[ currentMenu ].loseTopLevelFunc != null )
			uiGlobal.menuData[ currentMenu ].loseTopLevelFunc()

		if ( uiGlobal.menuData[ currentMenu ].hideFunc != null )
			uiGlobal.menuData[ currentMenu ].hideFunc()

		foreach ( var panel in GetAllMenuPanels( currentMenu ) )
		{
			PanelDef panelData = uiGlobal.panelData[panel]
			if ( panelData.isActive )
			{
				Assert( panelData.isCurrentlyShown )
				HidePanelInternal( panel )
			}
		}
	}

	if ( IsDialog( newMenu ) && currentMenu )
	{
		SetFooterPanelVisibility( currentMenu, false )
		if ( ShouldClearBlur( newMenu ) )
			ClearMenuBlur( currentMenu )

		if ( uiGlobal.menuData[ currentMenu ].loseTopLevelFunc != null )
			uiGlobal.menuData[ currentMenu ].loseTopLevelFunc()
	}

	uiGlobal.menuStack.push( GetMenuDef( newMenu ) )
	uiGlobal.activeMenu = newMenu

	uiGlobal.lastMenuNavDirection = MENU_NAV_FORWARD

	if ( uiGlobal.activeMenu )
	{
		UpdateMenuBlur( uiGlobal.activeMenu )
		OpenMenuWrapper( uiGlobal.activeMenu, true )
	}

	Signal( uiGlobal.signalDummy, "ActiveMenuChanged" )
}


void function UpdateMenuBlur( var menu )
{
	if ( !Hud_HasChild( menu, "ScreenBlur" ) || menu != GetActiveMenu() )
	{
		Hud_SetAboveBlur( menu, false )
		return
	}

	bool enableBlur = IsConnected()

	if ( _HasActiveTabPanel( menu ) )
	{
		var panel = _GetActiveTabPanel( menu )
		if ( uiGlobal.panelData[ panel ].panelClearBlur )
			enableBlur = false
	}

	Hud_SetVisible( Hud_GetChild( menu, "ScreenBlur" ), enableBlur )
	Hud_SetAboveBlur( menu, enableBlur )
}


void function ClearMenuBlur( var menu )
{
	Hud_SetAboveBlur( menu, false )
}


bool function IsCharacterSelectMenu( var menu )
{
	if ( menu == GetMenu( "CharacterSelectMenuNew" ) )
		return true
	return false
}


void function SetFooterPanelVisibility( var menu, bool visible )
{
	if ( !Hud_HasChild( menu, "FooterButtons" ) )
		return

	var panel = Hud_GetChild( menu, "FooterButtons" )
	Hud_SetVisible( panel, visible )
}


void function CloseActiveMenuNoParms()
{
	CloseActiveMenu()
}


void function CloseActiveMenu( bool cancelled = false, bool openStackMenu = true )
{
	bool wasDialog = false

	var currentActiveMenu = uiGlobal.activeMenu
	var nextActiveMenu

	uiGlobal.menuStack.pop()
	if ( uiGlobal.menuStack.len() )
		nextActiveMenu = uiGlobal.menuStack.top().menu
	else
		nextActiveMenu = null

	uiGlobal.activeMenu = nextActiveMenu //

	if ( currentActiveMenu )
	{
		if ( IsDialog( currentActiveMenu ) )
		{
			wasDialog = true
			uiGlobal.dialogInputEnableTime = 0.0

			if ( uiGlobal.dialogCloseCallback )
			{
				uiGlobal.dialogCloseCallback( cancelled )
				uiGlobal.dialogCloseCallback = null
			}
		}

		CloseMenuWrapper( currentActiveMenu )
	}

	uiGlobal.lastMenuNavDirection = MENU_NAV_BACK

	if ( wasDialog )
	{
		if ( nextActiveMenu )
		{
			SetFooterPanelVisibility( nextActiveMenu, true )
			UpdateFooterOptions()
			UpdateMenuTabs()
		}

		if ( IsDialog( nextActiveMenu ) )
			openStackMenu = true
		else
			openStackMenu = false
	}

	if ( nextActiveMenu )
	{
		UpdateMenuBlur( nextActiveMenu )

		if ( openStackMenu )
		{
			OpenMenuWrapper( nextActiveMenu, false )
		}
		else
		{
			if ( uiGlobal.menuData[ nextActiveMenu ].getTopLevelFunc != null )
				uiGlobal.menuData[ nextActiveMenu ].getTopLevelFunc()
		}
	}

	Signal( uiGlobal.signalDummy, "ActiveMenuChanged" )
}


void function CloseAllMenus()
{
	while ( GetActiveMenu() )
		CloseActiveMenu( true, false )
}


void function CloseAllDialogs()
{
	while ( IsDialog( GetActiveMenu() ) || IsPopup( GetActiveMenu() ) )
		CloseActiveMenu( true )
}


void function CloseAllToTargetMenu( var targetMenu )
{
	while ( GetActiveMenu() != targetMenu )
		CloseActiveMenu( true, false )
}


void function PrintMenuStack()
{
	array<MenuDef> stack = clone uiGlobal.menuStack
	stack.reverse()

	printt( "MENU STACK:" )

	foreach ( menuDef in stack )
	{
		if ( menuDef.menu )
			printt( "   ", Hud_GetHudName( menuDef.menu ) )
		else
			printt( "    null" )
	}
}

//
void function UpdateMenusOnConnectThread( string levelname )
{
	EndSignal( uiGlobal.signalDummy, "LevelShutdown" ) //

	CloseAllMenus()
	Assert( GetActiveMenu() != null || uiGlobal.menuStack.len() == 0 )

	bool isLobby        = IsLobbyMapName( levelname )
	bool isPrivateMatch = IsPrivateMatch()

	//
	if ( Lobby_GetSelectedPlaylist() == PLAYLIST_TRAINING )
		Lobby_ClearSelectedPlaylist()

	if ( isLobby )
	{
		if ( isPrivateMatch )
		{
			printf( "PrivateMatchMenuDebug: Advancing Lobby Menu" )
			AdvanceMenu( GetMenu( "PrivateMatchLobbyMenu" ) )
		}
		else
		{
			AdvanceMenu( GetMenu( "LobbyMenu" ) )
		}
		UIMusicUpdate()

		if ( IsFullyConnected() )
		{
			if ( GetCurrentPlaylistVarBool( "force_level_loadscreen", false ) )
			{
				SetCustomLoadScreen( $"" )
			}
			else
			{
				thread Loadscreen_SetEquppedLoadscreenAsActive()
			}
		}

		//
		//

		//
		ShouldReconnect()
		ShowGameSummaryIfNeeded()
	}
}


bool function ShouldReconnect()
{
	string reconnectParams = expect string( GetPersistentVar( "reconnectParams" ) )

	if ( reconnectParams != "" && !GetCurrentPlaylistVarBool( "reconnect_disabled", false ) )
	{
		//
		printt( "ShouldReconnect ReconnectCheckStatus because " + reconnectParams )
		Remote_ServerCallFunction( "ClientCallback_ReconnectCheckStatus" ) //
		return false
	}

	printt( "ShouldReconnect NO because " + reconnectParams )
	return false
}


void function AttemptReconnect()
{
	string reconnectParams = expect string( GetPersistentVar( "reconnectParams" ) )
	ClientCommand( "reconnect " + reconnectParams )
}


void function ReconnectDialogYes()
{
	ConfirmDialogData dialogData
	dialogData.headerText = "#RECONNECT_TO_GAME"
	dialogData.messageText = ""
	dialogData.okText = ["", ""]
	OpenOKDialogFromData( dialogData )
}


void function UICodeCallback_ReconnectFailed( string reason )
{
	printt( "ReconnectFailed " + reason )
	Signal( uiGlobal.signalDummy, "ReconnectFailed" )

	if ( reason == "cancelled" )
		return //

	Remote_ServerCallFunction( "ClientCallback_ResetReconnectParams" )
	CloseAllDialogs()

	ShowGameSummaryIfNeeded()
}


void function UICodeCallback_LoadscreenFinished()
{
	printt( "UICodeCallback_LoadscreenFinished" )
	file.loadScreenFinished = true
}


void function TryReconnectFlow()
{
	if ( !IsLobby() )
		return

	if ( IsPrivateMatch() )
		return

	bool attemptingReconnect = false

	if ( !IsPrivateMatch() )
		attemptingReconnect = ShouldReconnect()

	if ( !attemptingReconnect )
		ShowGameSummaryIfNeeded()
	else
		AttemptReconnect()
}


void function UICodeCallback_MatchMakeExpired()
{
	printt( "UICodeCallback_MatchMakeExpired" )
	EmitUISound( SOUND_MATCHMAKING_CANCELED )
}


void function UICodeCallback_EadpSearchRequestFinished( int error, string reason, array<EadpInviteToPlayData> results )
{
	printt( "UICodeCallback_EadpSearchRequestFinished", error, reason, results.len() )
	for ( int i = 0; i < results.len(); i++ )
		printt( results[i].eaid, " ", results[i].name, " ", results[i].hardware, " ", GetNameFromeHardware( results[i].hardware ) )

	FindFriendDialog_OnSearchResult( error, reason, results )
	FindClubMemberDialog_OnSearchResult( error, reason, results )
}

void function UICodeCallback_EadpInviteDataChanged()
{
	printt( "UICodeCallback_EadpInviteDataChanged" )

	//
	SocialEventUpdate()
}

void function UICodeCallback_EadpFriendsChanged()
{
	printt( "UICodeCallback_EadpFriendsChanged" )
	ForceSocialMenuUpdate()
}

void function UICodeCallback_EadpClubMemberPresence( EadpPresenceData presence )
{
	//
	printt( "Club Member presence: " + presence.name + " online:" + presence.online + " ingame:" + presence.ingame )

	ClubLobby_TryUpdatingMemberListForPresence( presence )
}

void function UICodeCallback_ClubRequestFinished( int operation, int errorCode, string errorMsg )
{
	if ( errorCode != 0 )
	{
		Warning( format( "ClubsError: Operation %i returned error code %i", operation, errorCode ) )
		ClubSetLastQueryError( errorCode )
		Clubs_SetClubQueryState( operation, eClubQueryState.FAILED )

		if ( errorMsg == "ALREADY_A_MEMBER" )
		{
			if ( ClubIsValid() )
				return;

			Clubs_OpenErrorDialog( operation, errorCode, errorMsg, "#CLUB_OP_FAIL_MEMBERSHIP_LIMIT" )
			return;
		}

		printt( "ClubRequestFinished error for operation " + operation + " errorCode " + errorCode + " errorMsg " + errorMsg )
		string errorString = Club_GetErrorStringForCode( errorCode )
		Clubs_OpenErrorDialog( operation, errorCode, errorMsg, errorString )

		if ( errorCode == CLUB_ERROR_CODE_NO_SUCH_GROUP )
		{
			array<ItemFlavor> emptyArray
			Clubs_Search( "", "", CLUB_PRIVACY_SEARCH_ANY, 0, 0, emptyArray, 54, false )
		}
		else if ( errorCode == CLUB_ERROR_CODE_CROSSPLAY_INCOMPAT )
		{
			Club_SetKickedForCrossplayIncompat()
		}

		switch( operation )
		{
			case CLUB_OP_GET_CURRENT:
				Warning( "ClubsError: CLUB_OP_GET_CURRENT failed. Attempting requery." )
				thread Clubs_AttemptRequeryThread()
				break
		}
		return
	}
	else
	{
		ClubClearLastQueryError()
		Clubs_SetClubQueryState( operation, eClubQueryState.SUCCESSFUL )
	}

	switch( operation )
	{
		case CLUB_OP_GET_CURRENT:
			Clubs_SetClubQueryState( operation, eClubQueryState.SUCCESSFUL )
			Clubs_UpdateMyData()
			thread Clubs_MonitorCrossplayChangeThread()
			//
			//
			break;

		case CLUB_OP_CREATE:
			//
			Clubs_FinalizeNewClub()
			break;

		case CLUB_OP_JOIN:
			//
			Clubs_FinalizeJoinClub()
			//
			//
			break;

		case CLUB_OP_GET_PENDING_APPROVAL:
			//
			//
			break;

		case CLUB_OP_JOIN_REQUESTED:
			if ( ClubIsPendingApproval() )
			{
				SetDialogFlowPersistenceTables( "clubIsPendingApproval", true  )//
				Remote_ServerCallFunction( "ClientCallback_SetClubIsPendingApproval", true )
			}
			break;

		case CLUB_OP_LEAVE:
			thread Clubs_FinalizeLeaveClub()
			break;

		case CLUB_OP_KICKED:
			thread Clubs_FinalizeLeaveClub( true )
			break;

		case CLUB_OP_SET_MEMBERRANK:
			Clubs_UpdateMyData()
			UpdateClubLobbyDetails()
			//
			break;

		case CLUB_OP_SEARCH:
			//
			Clubs_CompletedSearch()
			break;

		case CLUB_OP_PETITION_LIST:
			UpdateJoinRequestsButton()
			ClubJoinRequests_RefreshJoinRequests()
			break;

		case CLUB_OP_PETITION_APPROVE:
		case CLUB_OP_PETITION_DENY:
			ClubJoinRequests_RefreshJoinRequests()
			break;

		case CLUB_OP_MEMBERS_UPDATED:
			ClubMemberManagement_RefreshMenu()
			Clubs_UpdateMyData()
			Clubs_SetClubTabUserCount()
			//
			break;

		case CLUB_OP_INVITED_CLUBS_LIST:
			Clubs_CompletedClubInviteQuery()
			break;

		case CLUB_OP_SET_PRIVACY_SETTING:
		case CLUB_OP_SET_JOIN_REQUIREMENTS:
			UpdateClubLobbyDetails()
			break;

		case CLUB_OP_INVITED_MEMBERS_LIST:
			break;

		case CLUB_OP_HISTORY:
			thread ClubLanding_InitHistory()
			break;

		case CLUB_OP_STICKY_NOTE:
			ClubLanding_UpdateViewAnnouncementButton()
			CloseClubAnnouncementDialog()
			if ( Clubs_ShouldShowClubAnnouncementDialog() )
			{
				OpenViewAnnouncementDialog()
			}
			break;
	}
}


void function UICodeCallback_ClubEventLogUpdate( int eventLogIndex )
{
	array<ClubEvent> eventLog = ClubGetEventLogAll()
	if ( eventLog.len() == 0 )
	{
		Warning( "UICodeCallback_ClubEventLogUpdate executed, but EventLog returned empty. This should not be possible." )
		return
	}

	ClubEvent event = eventLog[eventLogIndex]
	//

	Clubs_UpdateMyData()

	switch( event.eventType )
	{
		case CLUB_EVENT_RANK_CHANGE:
			//
			if ( event.eventText == GetLocalClientPlayer().GetPINNucleusId() )
				UpdateClubAdminButtons()
			//
			ClubMemberManagement_RefreshMenu()
			break

		case CLUB_EVENT_KICK:
			break

		case CLUB_EVENT_REPORT:
			if ( ClubGetMyMemberRank() >= CLUB_RANK_ADMIN )
				ClubMemberManagement_RefreshMenu()

			ClubMemberManagement_UpdateReportGrid()
			//
			break

		case CLUB_EVENT_JOIN:
			ClubLanding_ForceUpdateMemberList()
			break
	}
}

void function UICodeCallback_ClubChatLogUpdate( int chatLogIndex )
{
	//
	Clubs_UpdateMyData()
	UpdateClubChat()
}


void function UICodeCallback_ClubMembershipNotification( int notification, string clubID, string clubName, string userName )
{
	switch ( notification )
	{
		case CLUB_NOTIFY_RECEIVED_INVITE:
			//
			SocialEventUpdate() //
			printt( "ClubInvite received: " + clubID + " " + clubName + " from " + userName )
			ClubDiscovery_ProcessClubInvites()
			break

		case CLUB_NOTIFY_JOIN_REQUEST_RECEIVED:
			//
			//
			break

		case CLUB_NOTIFY_JOIN_REQUEST_ACCEPTED:
			//
			//
			break

		case CLUB_NOTIFY_JOIN_REQUEST_REJECTED:
			Clubs_OpenJoinRequestDeniedDialog()
			printt( "Club join request rejected: " + clubID + " " + clubName + " from " + userName )
			break
	}
}


void function ShowGameSummaryIfNeeded()
{
	if ( GetPersistentVar( "showGameSummary" ) && IsPostGameMenuValid( true ) && IsPlayPanelCurrentlyTopLevel() )
	{
		if ( GetPersistentVar( "pve.postGame_isValid" ) )
		{
			OpenPostGameFreelanceMenu( true )
		}
		else
		{
			OpenPostGameMenu( null )

			if ( GetActiveBattlePass() != null )
			{
				OpenPostGameBattlePassMenu( true )
			}

			if ( GetPersistentVar( "showRankedSummary" ) )
			{
				OpenRankedSummary( true )
			}

                          
                                                             
     
                                    
     
         
		}
	}
	else
	{
		DialogFlow()
	}
}


bool function IsLoadScreenFinished()
{
	return file.loadScreenFinished
}


//

bool function AreDialogFlowPersistenceValuesSet( string persistenceVar, var value = true, float timeBeforeNextCheckAllowed = 9999  )
{
	if ( !(persistenceVar in file.dialogFlowPersistenceChecksValuesTable ) )
		return false

	if ( file.dialogFlowPersistenceChecksValuesTable[ persistenceVar ] != value )
		return false

	Assert( persistenceVar in file.dialogFlowPersistenceChecksTimeTable )

	if ( file.dialogFlowPersistenceChecksTimeTable[ persistenceVar] + timeBeforeNextCheckAllowed < Time() )
		return false

	return true
}

var function GetDialogFlowTablesValueOrPersistence( string persistenceVar, float timeBeforeDialogFlowTableValuesAreOutdated = 5.0 ) //
{
	if ( (persistenceVar in file.dialogFlowPersistenceChecksValuesTable ) )
	{
		Assert( persistenceVar in file.dialogFlowPersistenceChecksTimeTable )

		if ( file.dialogFlowPersistenceChecksTimeTable[ persistenceVar] + timeBeforeDialogFlowTableValuesAreOutdated > Time() )
			return file.dialogFlowPersistenceChecksValuesTable[ persistenceVar ]
	}

	return GetPersistentVar( persistenceVar )
}

void function SetDialogFlowPersistenceTables( string persistenceVar, var value = true )
{
	file.dialogFlowPersistenceChecksValuesTable[ persistenceVar ] <- value
	file.dialogFlowPersistenceChecksTimeTable[ persistenceVar ] <- Time()
}


void function DialogFlow()
{
	if ( !IsPlayPanelCurrentlyTopLevel() )
		return

	bool persistenceAvailable = IsPersistenceAvailable()

	if ( DisplayQueuedRewardsGiven() )
	{
		//
		IncrementNumDialogFlowDialogsDisplayed()

		DialogFlow_DidCausePotentiallyInterruptingPopup()
	}
                       
	else if ( DisplayTreasureBoxRewards() )
	{
		IncrementNumDialogFlowDialogsDisplayed()

		DialogFlow_DidCausePotentiallyInterruptingPopup()
	}
         
                          
	else if ( DisplayQuestFinalRewards() )
	{
		IncrementNumDialogFlowDialogsDisplayed()

		DialogFlow_DidCausePotentiallyInterruptingPopup()
	}
      
	else if ( persistenceAvailable && TryEntitlementMenus() )
	{
	}
	else if ( PlayerHasStarterPack( null ) && persistenceAvailable && ( GetDialogFlowTablesValueOrPersistence ("starterAcknowledged", 9999 )  == false ) )
	{
		SetDialogFlowPersistenceTables( "starterAcknowledged", true )
		Remote_ServerCallFunction( "ClientCallback_MarkEntitlementMenuSeen", "starterAcknowledged" )
		Remote_ServerCallFunction( "ClientCallback_lastSeenPremiumCurrency" )
		PromoDialog_OpenHijacked( "<p|starter|" + Localize( "#ORIGIN_ACCESS_STARTER" ) + "|" + Localize( "#STARTER_ENTITLEMENT_OWNED" ) + ">" )
		IncrementNumDialogFlowDialogsDisplayed()

		DialogFlow_DidCausePotentiallyInterruptingPopup()
	}
	else if ( PlayerHasFoundersPack( null ) && persistenceAvailable && ( GetDialogFlowTablesValueOrPersistence( "founderAcknowledged", 9999 ) == false )  )
	{
		SetDialogFlowPersistenceTables( "founderAcknowledged", true )
		Remote_ServerCallFunction( "ClientCallback_MarkEntitlementMenuSeen", "founderAcknowledged" )
		Remote_ServerCallFunction( "ClientCallback_lastSeenPremiumCurrency" )
		PromoDialog_OpenHijacked( "<p|founder|" + Localize( "#ORIGIN_ACCESS_FOUNDER" ) + "|" + Localize( "#FOUNDER_ENTITLEMENT_OWNED" ) + ">" )
		IncrementNumDialogFlowDialogsDisplayed()

		DialogFlow_DidCausePotentiallyInterruptingPopup()
	}
	else if ( Ranked_ManageDialogFlow() )
	{
		//
	}
                       
                                            
  
    
  
      
	else if ( Clubs_ShouldShowClubJoinedDialog() )
	{
		Clubs_OpenClubJoinedDialog( ClubGetHeader().name )
		IncrementNumDialogFlowDialogsDisplayed()

		DialogFlow_DidCausePotentiallyInterruptingPopup()
	}
	else if ( Clubs_ShouldShowClubKickedDialog() )
	{
		Clubs_OpenClubKickedDialog()
		IncrementNumDialogFlowDialogsDisplayed()

		DialogFlow_DidCausePotentiallyInterruptingPopup()
	}
	else if ( Clubs_ShouldShowClubJoinRequestDeniedDialog() )
	{
		Clubs_OpenJoinRequestDeniedDialog()
		IncrementNumDialogFlowDialogsDisplayed()

		DialogFlow_DidCausePotentiallyInterruptingPopup()
	}
	else if ( Clubs_ShouldShowClubAnnouncementDialog() )
	{
		OpenViewAnnouncementDialog()
		IncrementNumDialogFlowDialogsDisplayed()

		DialogFlow_DidCausePotentiallyInterruptingPopup()
	}
	else if ( ShouldShowPremiumCurrencyDialog() )
	{
		ShowPremiumCurrencyDialog( true )
		IncrementNumDialogFlowDialogsDisplayed()

		DialogFlow_DidCausePotentiallyInterruptingPopup()
	}
	else if ( OpenPromoDialogIfNew() )
	{
		//
		IncrementNumDialogFlowDialogsDisplayed()

		DialogFlow_DidCausePotentiallyInterruptingPopup()
	}
	else if ( ShouldShowMatchmakingDelayDialog() )
	{
		ShowMatchmakingDelayDialog()
		IncrementNumDialogFlowDialogsDisplayed()

		DialogFlow_DidCausePotentiallyInterruptingPopup()
	}
	else if ( ShouldShowLastGameRankedAbandonForgivenessDialog() )
	{
		ShowLastGameRankedAbandonForgivenessDialog()
		IncrementNumDialogFlowDialogsDisplayed()

		DialogFlow_DidCausePotentiallyInterruptingPopup()
	}
	else if ( !OpenPromoDialogIfNew() && file.numDialogFlowDialogsDisplayed == 0 && TryOpenSurvey( eSurveyType.ENTER_LOBBY ) )
	{
		IncrementNumDialogFlowDialogsDisplayed()

		DialogFlow_DidCausePotentiallyInterruptingPopup()
	}
}


void function TryRunDialogFlowThread()
{
	WaitEndFrame()
	DialogFlow()
}


bool function ShouldShowPremiumCurrencyDialog()
{
	if ( !GRX_IsInventoryReady() )
		return false

	if ( IsDialog( GetActiveMenu() ) )
		return false

	if ( GetActiveMenu() == GetMenu( "LootBoxOpen" ) )
		return false

	int premiumBalance  = GRXCurrency_GetPlayerBalance( GetUIPlayer(), GRX_CURRENCIES[GRX_CURRENCY_PREMIUM] )
	int lastSeenBalance =  expect int( GetDialogFlowTablesValueOrPersistence( "lastSeenPremiumCurrency" ) )
	if ( premiumBalance == lastSeenBalance )
		return false

	return premiumBalance > lastSeenBalance
}


void function ShowPremiumCurrencyDialog( bool dialogFlow )
{
	int premiumBalance  = GRXCurrency_GetPlayerBalance( GetUIPlayer(), GRX_CURRENCIES[GRX_CURRENCY_PREMIUM] )
	int lastSeenBalance = expect int( GetDialogFlowTablesValueOrPersistence( "lastSeenPremiumCurrency" ) )
	//
	Assert( premiumBalance > lastSeenBalance )
	Assert( GRX_IsInventoryReady() )

	ItemFlavor currency = GRX_CURRENCIES[GRX_CURRENCY_PREMIUM]
	ConfirmDialogData dialogData
	dialogData.headerText = "#RECEIVED_PREMIUM_CURRENCY"
	dialogData.messageText = Localize( "#RECEIVED_PREMIUM_CURRENCY_DESC", ShortenNumber( string( premiumBalance - lastSeenBalance ) ), "%$" + ItemFlavor_GetIcon( currency ) + "%" )
	if ( dialogFlow )
	{
		dialogData.resultCallback = void function ( int result )
		{
			DialogFlow()
		}
	}

	SetDialogFlowPersistenceTables( "lastSeenPremiumCurrency", premiumBalance )

	Remote_ServerCallFunction( "ClientCallback_lastSeenPremiumCurrency" )
	OpenOKDialogFromData( dialogData )
	EmitUISound( "UI_Menu_Purchase_Coins" )
}


bool function IsMenuInMenuStack( var searchMenu )
{
	foreach ( menuDef in uiGlobal.menuStack )
	{
		//
		if ( !menuDef.menu )
			continue

		if ( menuDef.menu == searchMenu )
			return true
	}

	return false
}


void function RemoveFromMenuStack( var searchMenu )
{
	for ( int i = uiGlobal.menuStack.len() - 1; i >= 0; i-- )
	{
		if ( searchMenu == uiGlobal.menuStack[i].menu )
			uiGlobal.menuStack.remove( i )
	}
}


var function GetTopNonDialogMenu()
{
	array<MenuDef> menuArray = clone uiGlobal.menuStack
	menuArray.reverse()

	foreach ( menuDef in menuArray )
	{
		if ( menuDef.menu == null || IsDialog( menuDef.menu ) )
			continue

		return menuDef.menu
	}

	return null
}


var function GetActiveMenu()
{
	return uiGlobal.activeMenu
}


bool function IsMenuVisible( var menu )
{
	return Hud_IsVisible( menu )
}


//
//
//
//
//
//
//


bool function IsPanelActive( var panel )
{
	return uiGlobal.activePanels.contains( panel )
}


string function GetActiveMenuName()
{
	return expect string( GetActiveMenu()._name )
}


var function GetMenu( string menuName )
{
	return uiGlobal.menus[ menuName ]
}


var function GetPanel( string panelName )
{
	return uiGlobal.panels[ panelName ]
}


array<var> function GetAllMenuPanels( var menu )
{
	array<var> menuPanels

	foreach ( panel in uiGlobal.allPanels )
	{
		if ( Hud_GetParent( panel ) == menu )
			menuPanels.append( panel )
	}

	return menuPanels
}


array<var> function GetMenuTabBodyPanels( var menu )
{
	array<var> panels

	foreach ( panel in uiGlobal.allPanels )
	{
		if ( Hud_GetParent( panel ) == menu )
			panels.append( panel )
	}

	return panels
}


void function InitGamepadConfigs()
{
	uiGlobal.buttonConfigs = [ { orthodox = "gamepad_button_layout_custom.cfg", southpaw = "gamepad_button_layout_custom.cfg" } ]

	uiGlobal.stickConfigs = []
	uiGlobal.stickConfigs.append( "gamepad_stick_layout_default.cfg" )
	uiGlobal.stickConfigs.append( "gamepad_stick_layout_southpaw.cfg" )
	uiGlobal.stickConfigs.append( "gamepad_stick_layout_legacy.cfg" )
	uiGlobal.stickConfigs.append( "gamepad_stick_layout_legacy_southpaw.cfg" )

	foreach ( key, val in uiGlobal.buttonConfigs )
	{
		VPKNotifyFile( "cfg/" + val.orthodox )
		VPKNotifyFile( "cfg/" + val.southpaw )
	}

	foreach ( key, val in uiGlobal.stickConfigs )
		VPKNotifyFile( "cfg/" + val )

	ExecCurrentGamepadButtonConfig()
	ExecCurrentGamepadStickConfig()

	SetStandardAbilityBindingsForPilot( GetLocalClientPlayer() )
}


void function InitMenus()
{
	InitGlobalMenuVars()
	//

                     
    
       
                         
                                             
       

	var mainMenu = AddMenu( "MainMenu", $"resource/ui/menus/main.menu", InitMainMenu, "#MAIN" )
	AddPanel( mainMenu, "EstablishUserPanel", InitEstablishUserPanel )
	AddPanel( mainMenu, "MainMenuPanel", InitMainMenuPanel )

	AddMenu( "PlayVideoMenu", $"resource/ui/menus/play_video.menu", InitPlayVideoMenu )

	var lobbyMenu   = AddMenu( "LobbyMenu", $"resource/ui/menus/lobby.menu", InitLobbyMenu )
	var seasonPanel = AddPanel( lobbyMenu, "SeasonPanel", InitSeasonPanel )
	AddPanel( seasonPanel, "ChallengesPanel", void function( var panel ) : () {
		InitAllChallengesPanel( panel, false )
	} )
                        
		AddPanel( seasonPanel, "QuestPanel", InitQuestPanel )
       
	AddPanel( seasonPanel, "PassPanel", InitPassPanel )
            
              
                                                            
        
       
	AddPanel( seasonPanel, "ThemedShopPanel", ThemedShopPanel_Init )
	AddPanel( seasonPanel, "CollectionEventPanel", CollectionEventPanel_Init )

	AddMenu( "SeasonWelcomeMenu", $"resource/ui/menus/season_welcome.menu", InitSeasonWelcomeMenu )

	AddPanel( lobbyMenu, "PlayPanel", InitPlayPanel )
	var clubLandingPanel = AddPanel( lobbyMenu, "ClubLandingPanel", InitClubLandingPanel )
	var clubLandingLobby = AddPanel( clubLandingPanel, "ClubLobbyPanel" )
	AddPanel( clubLandingLobby, "ClubEventTimelinePanel" )
	AddPanel( clubLandingLobby, "ClubChatPanel" )
	AddPanel( lobbyMenu, "CharactersPanel", InitCharactersPanel )
	AddPanel( lobbyMenu, "ArmoryPanel", InitArmoryPanel )

	var storePanel = AddPanel( lobbyMenu, "StorePanel", InitStorePanel )
	AddPanel( storePanel, "LootPanel", InitLootPanel )
	//
	//
	AddPanel( storePanel, "HeirloomShopPanel", HeirloomShopPanel_Init )
	AddPanel( storePanel, "SKUShopPanel", SKUShopPanel_Init )
	//
	AddPanel( storePanel, "ECPanel", InitOffersPanel )
	AddPanel( storePanel, "CharacterPanel", InitStoreCharactersPanel )
	AddPanel( storePanel, "VCPanel", InitStoreVCPanel )

	var storeInspectMenu = AddMenu( "StoreInspectMenu", $"resource/ui/menus/store_inspect.menu", InitStoreInspectMenu )

                           
		var privateMatchLobbyMenu         = AddMenu( "PrivateMatchLobbyMenu", $"resource/ui/menus/lobby_private_match.menu", InitPrivateMatchLobbyMenu )
		var privateMatchTeamRosters       = AddPanel( privateMatchLobbyMenu, "PrivateMatchRosterPanel", InitPrivateMatchTeamRostersPanel )
		var privateMatchSpectators        = AddPanel( privateMatchLobbyMenu, "PrivateMatchSpectatorPanel", InitPrivateMatchSpectatorsPanel )
		var privateMatchUnassignedPlayers = AddPanel( privateMatchLobbyMenu, "PrivateMatchUnassignedPlayersPanel", InitPrivateMatchUnassignedPlayersPanel )
		//
		//

		AddMenu( "TournamentConnectMenu", $"resource/ui/menus/tournament_connect.menu", InitTournamentConnectMenu )
		AddMenu( "PrivateMatchPostGameMenu", $"resource/ui/menus/postgame_private_match.menu", InitPrivateMatchPostGameMenu )
		AddMenu( "SetTeamNameDialog", $"resource/ui/menus/dialogs/setteamname_dialog.menu", InitSetTeamNameDialogMenu )
		AddMenu( "PrivateMatchSpectCharSelectMenu", $"resource/ui/menus/private_match_spec_char_select.menu", InitPrivateMatchSpectCharSelectMenu )
		var privateGameStatusMenu = AddMenu( "PrivateMatchGameStatusMenu", $"resource/ui/menus/private_match_game_status.menu", InitPrivateMatchGameStatusMenu )
		AddPanel( privateGameStatusMenu, "PrivateMatchRosterPanel", InitPrivateMatchRosterPanel )
		AddPanel( privateGameStatusMenu, "PrivateMatchOverviewPanel", InitPrivateMatchOverviewPanel )
		AddPanel( privateGameStatusMenu, "PrivateMatchAdminPanel", InitPrivateMatchAdminPanel )
		

       

	var clubsCreationMenu = AddMenu( "ClubsCreationMenu", $"resource/ui/menus/clubs_creation.menu", InitClubsCreationMenu )
	var clubsSearchMenu   = AddMenu( "ClubsSearchMenu", $"resource/ui/menus/clubs_search.menu", InitClubsSearchMenu )

	var clubSearchTagSelectionDialog = AddMenu( "ClubSearchTagDialog", $"resource/ui/menus/dialog_clubs_search_tag_selection.menu", InitSearchTagSelectionDialog )
	var clubJoinDialog               = AddMenu( "ClubJoinDialog", $"resource/ui/menus/dialog_clubs_participation.menu", InitClubJoinDialog )
	var clubJoinRequestDialog        = AddMenu( "ClubJoinRequestDialog", $"resource/ui/menus/dialog_clubs_join_requests.menu", InitJoinRequestsMenu )
	var clubCreateDialog             = AddMenu( "ClubCreateDialog", $"resource/ui/menus/dialog_clubs_participation.menu", InitClubCreateDialog )
	var clubEditDialog               = AddMenu( "ClubEditDialog", $"resource/ui/menus/dialogs/confirm_dialog.menu", InitConfirmEditClubDialog )
	var clubMemberRankDialog		 = AddMenu( "ClubMemberRankDialog", $"resource/ui/menus/dialogs/confirm_dialog.menu", InitConfirmClubMemberRankDialog )
	var clubAnnouncementDialog       = AddMenu( "ClubAnnouncementDialog", $"resource/ui/menus/dialogs/dialog_clubs_announcement.menu", InitClubAnnouncementDialog )

	var clubManageUsersMenu  = AddMenu( "ClubManageUsersMenu", $"resource/ui/menus/clubs_manage_users.menu", InitUserManagementMenu )
	//
	var reportClubMemberDialog = AddMenu( "ReportClubmateDialog", $"resource/ui/menus/dialog_report_player.menu", InitReportClubmateDialog )
	var reportClubMemberReasonPopup = AddMenu( "ReportClubmateReasonPopup", $"resource/ui/menus/dialog_report_player_reason.menu", InitReportClubmateReasonPopup )

	var clubInviteMemberDialog = AddMenu( "FindClubMemberDialog", $"resource/ui/menus/dialog_find_friend.menu", InitFindClubMemberDialog )
	var clubLeaveDialog        = AddMenu( "ClubLeaveDialog", $"resource/ui/menus/dialogs/confirm_dialog.menu", InitConfirmLeaveClubDialog )
	var clubKickDialog         = AddMenu( "ClubKickDialog", $"resource/ui/menus/dialogs/confirm_dialog.menu", InitConfirmKickUserDialog )

	var clubsLogoEditorMenu        = AddMenu( "ClubsLogoEditorMenu", $"resource/ui/menus/clubs_logo_editor.menu", InitClubsLogoEditorMenu )
	var clubsLogoEditorCanvasPanel = AddPanel( clubsLogoEditorMenu, "ClubLogoCanvasPanel", InitClubsLogoEditorCanvasPanel )

	var clubsLogoElementSelectionMenu = AddMenu( "ClubsLogoElementSelectionMenu", $"resource/ui/menus/clubs_logo_editor_element_selection.menu", InitClubsLogoElementSelectionMenu )
	var clubsLogoColorSelectionMenu   = AddMenu( "ClubsLogoColorSelectionMenu", $"resource/ui/menus/clubs_logo_editor_color_selection.menu", InitClubsLogoColorSelectionMenu )

	var systemMenu = AddMenu( "SystemMenu", $"resource/ui/menus/system.menu", InitSystemMenu )
	AddPanel( systemMenu, "SystemPanel", InitSystemPanelMain )

	var miscMenu      = AddMenu( "MiscMenu", $"resource/ui/menus/misc.menu", InitMiscMenu )
	var settingsPanel = AddPanel( miscMenu, "SettingsPanel", InitSettingsPanel )

	#if(PC_PROG)
		var controlsPCContainer = AddPanel( settingsPanel, "ControlsPCPanelContainer", InitControlsPCPanel )
		InitControlsPCPanelForCode( controlsPCContainer )
	#endif
	AddPanel( settingsPanel, "ControlsGamepadPanel", InitControlsGamepadPanel )

	var videoPanelContainer = AddPanel( settingsPanel, "VideoPanelContainer", InitVideoPanel )
	InitVideoPanelForCode( videoPanelContainer )
	AddPanel( settingsPanel, "SoundPanel", InitSoundPanel )
	AddPanel( settingsPanel, "HudOptionsPanel", InitHudOptionsPanel )

	var customizeCharacterMenu = AddMenu( "CustomizeCharacterMenu", $"resource/ui/menus/customize_character.menu", InitCustomizeCharacterMenu )
	AddPanel( customizeCharacterMenu, "CharacterSkinsPanel", InitCharacterSkinsPanel )
	var cardPanel = AddPanel( customizeCharacterMenu, "CharacterCardsPanelV2", InitCharacterCardsPanel )
	AddPanel( cardPanel, "CardFramesPanel", InitCardFramesPanel )
	AddPanel( cardPanel, "CardPosesPanel", InitCardPosesPanel )
	AddPanel( cardPanel, "CardBadgesPanel", InitCardBadgesPanel )
	AddPanel( cardPanel, "CardTrackersPanel", InitCardTrackersPanel )
	AddPanel( cardPanel, "IntroQuipsPanel", InitIntroQuipsPanel )
	AddPanel( cardPanel, "KillQuipsPanel", InitKillQuipsPanel )
                      
		var quipsPanel = AddPanel( customizeCharacterMenu, "CharacterEmotesPanelV2", InitCharacterEmotesPanel )
		AddPanel( quipsPanel, "LinePanel", InitQuipsPanel )
		AddPanel( quipsPanel, "BoxesPanel", InitEmotesPanel )
      
                                                                                                       
                                                      
       
	AddPanel( customizeCharacterMenu, "CharacterExecutionsPanel", InitCharacterExecutionsPanel )

	var customizeWeaponMenu = AddMenu( "CustomizeWeaponMenu", $"resource/ui/menus/customize_weapon.menu", InitCustomizeWeaponMenu )
	AddPanel( customizeWeaponMenu, "WeaponSkinsPanel0", InitWeaponSkinsPanel )
	AddPanel( customizeWeaponMenu, "WeaponSkinsPanel1", InitWeaponSkinsPanel )
	AddPanel( customizeWeaponMenu, "WeaponSkinsPanel2", InitWeaponSkinsPanel )
	AddPanel( customizeWeaponMenu, "WeaponSkinsPanel3", InitWeaponSkinsPanel )
	AddPanel( customizeWeaponMenu, "WeaponSkinsPanel4", InitWeaponSkinsPanel )
	AddPanel( customizeWeaponMenu, "WeaponSkinsPanel5", InitWeaponSkinsPanel )

	var miscCustomizeMenu = AddMenu( "MiscCustomizeMenu", $"resource/ui/menus/misc_customize.menu", InitMiscCustomizeMenu )
	AddPanel( miscCustomizeMenu, "LoadscreenPanel", InitLoadscreenPanel )
	AddPanel( miscCustomizeMenu, "MusicPackPanel", InitMusicPackPanel )
	AddPanel( miscCustomizeMenu, "SkydiveTrailPanel", InitSkydiveTrailPanel )

	AddMenu( "PassPurchasePremiumMenu", $"resource/ui/menus/passpurchasepremium.menu", InitDummyMenu )
	AddMenu( "PassPurchaseLevelMenu", $"resource/ui/menus/passpurchaselevel.menu", InitDummyMenu )

	AddMenu( "CharacterSelectMenuNew", $"resource/ui/menus/character_select_new.menu", UI_InitCharacterSelectNewMenu )

	var deathScreenMenu = AddMenu( "DeathScreenMenu", $"resource/ui/menus/death_screen.menu", InitDeathScreenMenu )
	AddPanel( deathScreenMenu, "DeathScreenRecap", InitDeathScreenRecapPanel )
	AddPanel( deathScreenMenu, "DeathScreenSpectate", InitDeathScreenSpectatePanel )
	AddPanel( deathScreenMenu, "DeathScreenSquadSummary", InitDeathScreenSquadSummaryPanel )

	AddMenu( "PostGameRankedMenu", $"resource/ui/menus/post_game_ranked.menu", InitPostGameRankedMenu )
	AddMenu( "RankedInfoMenu", $"resource/ui/menus/ranked_info.menu", InitRankedInfoMenu )
	AddMenu( "RankedInfoMoreMenu", $"resource/ui/menus/ranked_info_more.menu", InitRankedInfoMoreMenu )
	AddMenu( "AboutGameModeMenu", $"resource/ui/menus/about_game_mode.menu", InitAboutGameModeMenu )

                        
                                                                                                                        
                                                                                                           
       

	var inventoryMenu = AddMenu( "SurvivalInventoryMenu", $"resource/ui/menus/survival_inventory.menu", InitSurvivalInventoryMenu )
	AddPanel( inventoryMenu, "SurvivalQuickInventoryPanel", InitSurvivalQuickInventoryPanel )
	//
	AddPanel( inventoryMenu, "SquadPanel", InitSquadPanelInventory )
	AddPanel( inventoryMenu, "CharacterDetailsPanel", InitLegendPanelInventory )

                           
		AddMenu( "NEW_SurvivalGroundListMenu", $"resource/ui/menus/new_survival_ground_list.menu", NEW_InitSurvivalGroundList )
       
	AddMenu( "SurvivalGroundListMenu", $"resource/ui/menus/survival_ground_list.menu", InitGroundListMenu )
	AddMenu( "SurvivalQuickSwapMenu", $"resource/ui/menus/survival_quick_swap.menu", InitQuickSwapMenu )

                         
                                                                                                                                               
                                                                                         
       

	AddMenu( "GammaMenu", $"resource/ui/menus/gamma.menu", InitGammaMenu, "#BRIGHTNESS" )

	AddMenu( "Notifications", $"resource/ui/menus/notifications.menu", InitNotificationsMenu )

	AddMenu( "InGameMPMenu", $"resource/ui/menus/ingame_mp.menu", InitInGameMPMenu )

	AddMenu( "PostGameFreelanceMenu", $"resource/ui/menus/postgame_freelance.menu", InitPostGameFreelanceMenu )

	AddMenu( "PostGameMenu", $"resource/ui/menus/postgame.menu", InitPostGameMenu )

	AddMenu( "Dialog", $"resource/ui/menus/dialog.menu", InitDialogMenu )
	AddMenu( "PromoDialog", $"resource/ui/menus/dialogs/promo.menu", InitPromoDialog )
	AddMenu( "BuffetEventAboutDialog", $"resource/ui/menus/dialogs/buffet_event_about.menu", InitBuffetEventAboutDialog )
	AddMenu( "LowPopDialog", $"resource/ui/menus/dialogs/low_pop.menu", InitLowPopDialog )

	var selectSlot = AddMenu( "SlotSelectDialog", $"resource/ui/menus/dialogs/select_slot.menu", InitSelectSlotDialog )
	AddPanel( selectSlot, "SelectSlotDefault", InitSelectSlotDefaultPanel )
	AddPanel( selectSlot, "SelectSlotQuips", InitSelectSlotQuipsPanel )

	AddMenu( "CharacterSkillsDialog", $"resource/ui/menus/dialogs/character_skills.menu", InitCharacterSkillsDialog )
	AddMenu( "LaunchMissionDialog", $"resource/ui/menus/dialogs/launch_mission_dialog.menu", InitLaunchMissionDialog )
	AddMenu( "ConfirmDialog", $"resource/ui/menus/dialogs/confirm_dialog.menu", InitConfirmDialog )

                        
                                                                                             
       

	AddMenu( "OKDialog", $"resource/ui/menus/dialogs/ok_dialog.menu", InitOKDialog )
	AddMenu( "ConfirmExitToDesktopDialog", $"resource/ui/menus/dialogs/confirm_dialog.menu", InitConfirmExitToDesktopDialog )
	AddMenu( "ConfirmLeaveMatchDialog", $"resource/ui/menus/dialogs/confirm_dialog.menu", InitConfirmLeaveMatchDialog )
	AddMenu( "ConfirmKeepVideoChangesDialog", $"resource/ui/menus/dialogs/confirm_dialog.menu", InitConfirmKeepVideoChangesDialog )
	AddMenu( "ConfirmPurchaseDialog", $"resource/ui/menus/dialogs/confirm_purchase.menu", InitConfirmPurchaseDialog )
	AddMenu( "ConfirmPackBundlePurchaseDialog", $"resource/ui/menus/dialogs/confirm_pack_bundle_purchase.menu", InitConfirmPackBundlePurchaseDialog )
	AddMenu( "ConnectingDialog", $"resource/ui/menus/dialog_connecting.menu", InitConnectingDialog )
	AddMenu( "DataCenterDialog", $"resource/ui/menus/dialog_datacenter.menu", InitDataCenterDialogMenu )
	AddMenu( "EULADialog", $"resource/ui/menus/dialog_eula.menu", InitEULADialog )
#if(NX_PROG)
	AddMenu( "LangAoCWarn", $"resource/ui/menus/lang_aoc_warn.menu", InitLangAoCDialog )
	AddMenu( "DownloadAoCNotice", $"resource/ui/menus/download_aoc_notice.menu", InitDownloadAoCNoticeDialog )
#endif
	AddMenu( "ModeSelectDialog", $"resource/ui/menus/dialog_mode_select.menu", InitModeSelectDialog )
	AddMenu( "GamemodeSelectV2Dialog", $"resource/ui/menus/dialog_gamemode_select_v2.menu", InitGamemodeSelectV2Dialog )
	AddMenu( "GamemodeSelectV3Dialog", $"resource/ui/menus/dialog_gamemode_select_v3.menu", InitGamemodeSelectV3Dialog )
	AddMenu( "ErrorDialog", $"resource/ui/menus/dialogs/ok_dialog.menu", InitErrorDialog )
	AddMenu( "AccessibilityDialog", $"resource/ui/menus/dialogs/accessibility_dialog.menu", InitAccessibilityDialog )
	AddMenu( "ReportPlayerDialog", $"resource/ui/menus/dialog_report_player.menu", InitReportPlayerDialog )
	AddMenu( "ReportPlayerReasonPopup", $"resource/ui/menus/dialog_report_player_reason.menu", InitReportReasonPopup )
	AddMenu( "ProcessingDialog", $"resource/ui/menus/dialog_processing.menu", InitProcessingDialog )

                        
                                                                                                               
       

	AddMenu( "RewardPurchaseDialog", $"resource/ui/menus/dialogs/pass_dialog.menu", InitRewardPurchaseDialog )
	AddMenu( "PassPurchaseMenu", $"resource/ui/menus/pass_purchase.menu", InitPassPurchaseMenu )
	AddMenu( "RewardCeremonyMenu", $"resource/ui/menus/reward_ceremony.menu", InitRewardCeremonyMenu )
	AddMenu( "LoadscreenPreviewMenu", $"resource/ui/menus/loadscreen_preview.menu", InitLoadscreenPreviewMenu )

	AddMenu( "PostGameBattlePassMenu", $"resource/ui/menus/post_game_battlepass.menu", InitPostGameBattlePassMenu )
	AddMenu( "BattlePassAboutPage1", $"resource/ui/menus/dialogs/battle_pass_about_1.menu", InitAboutBattlePass1Dialog )
	AddMenu( "CollectionEventAboutPage", $"resource/ui/menus/dialogs/collection_event_about.menu", CollectionEventAboutPage_Init )

	var controlsAdvancedLookMenu = AddMenu( "ControlsAdvancedLookMenu", $"resource/ui/menus/controls_advanced_look.menu", InitControlsAdvancedLookMenu, "#CONTROLS_ADVANCED_LOOK" )
	AddPanel( controlsAdvancedLookMenu, "AdvancedLookControlsPanel", InitAdvancedLookControlsPanel )
	AddMenu( "GamepadLayoutMenu", $"resource/ui/menus/gamepadlayout.menu", InitGamepadLayoutMenu )

                        
		AddMenu( "LoreReaderMenu", $"resource/ui/menus/lore_reader.menu", InitLoreReaderMenu )
          

                        
		AddMenu( "ComicReaderMenu", $"resource/ui/menus/comic_reader.menu", InitComicReaderMenu )
          

                        
                                                                                                        
                                                                                                                    
                                                                                                                      
       

	#if(PC_PROG)
		var controlsADSPC = AddMenu( "ControlsAdvancedLookMenuPC", $"resource/ui/menus/controls_ads_pc.menu", InitADSControlsMenuPC, "#CONTROLS_ADVANCED_LOOK" )
		AddPanel( controlsADSPC, "ADSControlsPanel", InitADSControlsPanelPC )
	#endif

	var controlsADSConsole = AddMenu( "ControlsAdvancedLookMenuConsole", $"resource/ui/menus/controls_ads_console.menu", InitADSControlsMenuConsole, "#CONTROLS_ADVANCED_LOOK" )
	AddPanel( controlsADSConsole, "ADSControlsPanel", InitADSControlsPanelConsole )

	var controlsADSAdvancedConsole = AddMenu( "ControlsAdsAdvancedLookMenuConsole", $"resource/ui/menus/controls_ads_advanced_console.menu", InitADSAdvancedControlsMenuConsole, "#CONTROLS_ADVANCED_LOOK" )
	AddPanel( controlsADSAdvancedConsole, "ADSAdvancedControlsPanel", InitADSAdvancedControlsPanelConsole )

	#if(NX_PROG)
		//
		var motionADSConsole = AddMenu( "MotionADSMenuConsole", $"resource/ui/menus/controls_ads_console_motion.menu", InitADSMotionControlsMenuConsole, "#CONTROLS_ADVANCED_LOOK" )
		AddPanel( motionADSConsole, "ADSMotionControlsPanel", InitADSMotionControlsPanelConsole )
	#endif
	//

	AddMenu( "LootBoxOpen", $"resource/ui/menus/loot_box.menu", InitLootBoxMenu )
	AddMenu( "InviteFriendsMenu", $"resource/ui/menus/invite_friends.menu", InitInviteFriendsMenu )
	var socialMenu = AddMenu( "SocialMenu", $"resource/ui/menus/social.menu", InitSocialMenu )
	AddPanel( socialMenu, "FriendsPanel", InitFriendsPanel )
	AddPanel( socialMenu, "FriendsOtherPanel", InitFriendsOtherPanel )
	AddPanel( socialMenu, "FriendRequestsPanel", InitFriendRequestsPanel )

	AddMenu( "FindFriendDialog", $"resource/ui/menus/dialog_find_friend.menu", InitFindFriendDialog )
	//
	//
	//
	//

	var inspectMenu = AddMenu( "InspectMenu", $"resource/ui/menus/inspect.menu", InitInspectMenu )

	AddPanel( inspectMenu, "StatsSummaryPanel", InitStatsSummaryPanel )
	//

	AddMenu( "StatsSeasonSelectPopUp", $"resource/ui/menus/dialog_player_stats_season_select.menu", InitSeasonSelectPopUp )

	AddMenu( "DevMenu", $"resource/ui/menus/dev.menu", InitDevMenu, "Dev" )

	InitTabs()
	InitSurveys()
	ShMenuModels_UIInit()

	foreach ( var menu in uiGlobal.allMenus )
	{
		if ( uiGlobal.menuData[ menu ].initFunc != null )
			uiGlobal.menuData[ menu ].initFunc( menu )

		array<var> elems = GetElementsByClassname( menu, "TabsCommonClass" )
		if ( elems.len() )
			uiGlobal.menuData[ menu ].hasTabs = true

		elems = GetElementsByClassname( menu, "EnableKeyBindingIcons" )
		foreach ( elem in elems )
			Hud_EnableKeyBindingIcons( elem )
	}

	foreach ( panel in uiGlobal.allPanels )
	{
		if ( uiGlobal.panelData[ panel ].initFunc != null )
			uiGlobal.panelData[ panel ].initFunc( panel )

		array<var> elems = GetPanelElementsByClassname( panel, "TabsPanelClass" )
		if ( elems.len() )
			uiGlobal.panelData[ panel ].hasTabs = true
	}

	//
	foreach ( menu in uiGlobal.allMenus )
	{
		array<var> buttons = GetElementsByClassname( menu, "DefaultFocus" )
		foreach ( button in buttons )
		{
			var panel = Hud_GetParent( button )

			//
			Assert( panel != null, "no parent panel found for button " + Hud_GetHudName( button ) )
			Assert( panel in uiGlobal.panelData, "panel " + Hud_GetHudName( panel ) + " isn't in uiGlobal.panelData, but button " + Hud_GetHudName( button ) + " has defaultFocus set!" )
			uiGlobal.panelData[ panel ].defaultFocus = button
			//
		}
	}

	InitFooterOptions()
	InitMatchmakingOverlay()
	InitPromoData()

	RegisterTabNavigationInput()
	thread UpdateGamepadCursorEnabledThread()
}


void function InitDummyMenu( var newMenuArg )
//
{

}


void functionref( var ) function AdvanceMenuEventHandler( var menu )
{
	return void function( var item ) : ( menu )
	{
		if ( Hud_IsLocked( item ) )
			return

		AdvanceMenu( menu )
	}
}


void function PCBackButton_Activate( var button )
{
	UICodeCallback_NavigateBack()
}


void function PCSwitchTeamsButton_Activate( var button )
{
	ClientCommand( "PrivateMatchSwitchTeams" )
}


void function PCToggleSpectateButton_Activate( var button )
{
	ClientCommand( "PrivateMatchToggleSpectate" )
}


void function AddMenuElementsByClassname( var menu, string classname )
{
	array<var> elements = GetElementsByClassname( menu, classname )

	if ( !(classname in menu.classElements) )
		menu.classElements[classname] <- []

	menu.classElements[classname].extend( elements )
}


void function SetPanelDefaultFocus( var panel, var button )
{
	uiGlobal.panelData[ panel ].defaultFocus = button
}


void function PanelFocusDefault( var panel )
{
	//
	if ( uiGlobal.panelData[ panel ].defaultFocus )
	{
		Hud_SetFocused( uiGlobal.panelData[ panel ].defaultFocus )
		//
	}
}


void function AddMenuThinkFunc( var menu, void functionref( var ) func )
{
	uiGlobal.menuData[ menu ].thinkFuncs.append( func )
}


void function AddMenuEventHandler( var menu, int event, void functionref() func )
{
	if ( event == eUIEvent.MENU_OPEN )
	{
		Assert( uiGlobal.menuData[ menu ].openFunc == null )
		uiGlobal.menuData[ menu ].openFunc = func
	}
	else if ( event == eUIEvent.MENU_CLOSE )
	{
		Assert( uiGlobal.menuData[ menu ].closeFunc == null )
		uiGlobal.menuData[ menu ].closeFunc = func
	}
	else if ( event == eUIEvent.MENU_SHOW )
	{
		Assert( uiGlobal.menuData[ menu ].showFunc == null )
		uiGlobal.menuData[ menu ].showFunc = func
	}
	else if ( event == eUIEvent.MENU_HIDE )
	{
		Assert( uiGlobal.menuData[ menu ].hideFunc == null )
		uiGlobal.menuData[ menu ].hideFunc = func
	}
	else if ( event == eUIEvent.MENU_GET_TOP_LEVEL )
	{
		Assert( uiGlobal.menuData[ menu ].getTopLevelFunc == null )
		uiGlobal.menuData[ menu ].getTopLevelFunc = func
	}
	else if ( event == eUIEvent.MENU_LOSE_TOP_LEVEL )
	{
		Assert( uiGlobal.menuData[ menu ].loseTopLevelFunc == null )
		uiGlobal.menuData[ menu ].loseTopLevelFunc = func
	}
	else if ( event == eUIEvent.MENU_NAVIGATE_BACK )
	{
		Assert( uiGlobal.menuData[ menu ].navBackFunc == null )
		uiGlobal.menuData[ menu ].navBackFunc = func
	}
	//
	//
	//
	//
	//
	else if ( event == eUIEvent.MENU_INPUT_MODE_CHANGED )
	{
		Assert( uiGlobal.menuData[ menu ].inputModeChangedFunc == null )
		uiGlobal.menuData[ menu ].inputModeChangedFunc = func
	}
}


void function AddPanelEventHandler( var panel, int event, void functionref( var panel ) func )
{
	if ( event == eUIEvent.PANEL_SHOW )
		uiGlobal.panelData[ panel ].showFuncs.append( func )
	else if ( event == eUIEvent.PANEL_HIDE )
		uiGlobal.panelData[ panel ].hideFuncs.append( func )
	else if ( event == eUIEvent.PANEL_NAVUP )
		uiGlobal.panelData[ panel ].navUpFunc = func
	else if ( event == eUIEvent.PANEL_NAVDOWN )
		uiGlobal.panelData[ panel ].navDownFunc = func
	else if ( event == eUIEvent.PANEL_NAVBACK )
		uiGlobal.panelData[ panel ].navBackFunc = func
}


void function AddPanelEventHandler_FocusChanged( var panel, void functionref( var panel, var oldFocus, var newFocus ) func )
{
	uiGlobal.panelData[ panel ].focusChangedFuncs.append( func )
}


void function SetPanelInputHandler( var panel, int inputID, bool functionref( var panel ) func )
{
	Assert( !(inputID in uiGlobal.panelData[ panel ].panelInputs), "Panels may only register a single handler for button input" )
	uiGlobal.panelData[ panel ].panelInputs[ inputID ] <- func
}


//
void function OpenMenuWrapper( var menu, bool isFirstOpen )
{
	OpenMenu( menu )
	printt( Hud_GetHudName( menu ), "menu opened" )

	Assert( menu in uiGlobal.menuData )

	if ( isFirstOpen )
	{
		if ( uiGlobal.menuData[ menu ].openFunc != null )
		{
			uiGlobal.menuData[ menu ].openFunc()
			//
		}
		FocusDefaultMenuItem( menu )
	}

	if ( uiGlobal.menuData[ menu ].showFunc != null )
		uiGlobal.menuData[ menu ].showFunc()

	if ( uiGlobal.menuData[ menu ].getTopLevelFunc != null )
		uiGlobal.menuData[ menu ].getTopLevelFunc()

	uiGlobal.menuData[ menu ].enterTime = Time()

	foreach ( var panel in GetAllMenuPanels( menu ) )
	{
		PanelDef panelData = uiGlobal.panelData[panel]
		if ( panelData.isActive && !panelData.isCurrentlyShown )
			ShowPanelInternal( panel )
	}

	#if(true)
		ToolTips_MenuOpened( menu )
	#endif

	UpdateFooterOptions()
	UpdateMenuTabs()
}


void function CloseMenuWrapper( var menu )
{
	bool wasVisible = Hud_IsVisible( menu )
	CloseMenu( menu )
	ClearMenuBlur( menu )
	printt( Hud_GetHudName( menu ), "menu closed" )

	#if(true)
		ToolTips_MenuClosed( menu )
	#endif

	if ( wasVisible )
	{
		if ( uiGlobal.menuData[ menu ].hideFunc != null )
			uiGlobal.menuData[ menu ].hideFunc()

		PIN_PageView( Hud_GetHudName( menu ), Time() - uiGlobal.menuData[ menu ].enterTime, uiGlobal.pin_lastMenuId, IsDialog( menu ) )
		uiGlobal.pin_lastMenuId = Hud_GetHudName( menu )

		foreach ( var panel in GetAllMenuPanels( menu ) )
		{
			PanelDef panelData = uiGlobal.panelData[panel]
			if ( panelData.isActive )
			{
				Assert( panelData.isCurrentlyShown )
				HidePanelInternal( panel )
			}
		}
	}

	Assert( menu in uiGlobal.menuData )
	if ( uiGlobal.menuData[ menu ].closeFunc != null )
	{
		uiGlobal.menuData[ menu ].closeFunc()
		//
	}
}


void function AddButtonEventHandler( var button, int event, void functionref( var ) func )
{
	Hud_AddEventHandler( button, event, func )
}


void function AddEventHandlerToButton( var menu, string buttonName, int event, void functionref( var ) func )
{
	var button = Hud_GetChild( menu, buttonName )
	Hud_AddEventHandler( button, event, func )
}


void function AddEventHandlerToButtonClass( var menu, string classname, int event, void functionref( var ) func )
{
	array<var> buttons = GetElementsByClassname( menu, classname )

	foreach ( button in buttons )
	{
		//
		Hud_AddEventHandler( button, event, func )
	}
}


void function RemoveEventHandlerFromButtonClass( var menu, string classname, int event, void functionref( var ) func )
{
	array<var> buttons = GetElementsByClassname( menu, classname )

	foreach ( button in buttons )
	{
		//
		Hud_RemoveEventHandler( button, event, func )
	}
}


//
const array<string> WORKAROUND_UI_MUSIC_SOUND_LIST = [
	"Music_FrontEnd",
	"mainmenu_music_Bangalore", "Music_Lobby_Bangalore",
	"mainmenu_music_Bloodhound", "Music_Lobby_Bloodhound",
	"mainmenu_music_Caustic", "Music_Lobby_Caustic",
	"mainmenu_music", "Music_Lobby",
	"mainmenu_music_Gibraltar", "Music_Lobby_Gibraltar",
	"mainmenu_music_Lifeline", "Music_Lobby_Lifeline",
	"mainmenu_music_Mirage", "Music_Lobby_Mirage",
	"mainmenu_music_Octane", "Music_Lobby_Octane",
	"mainmenu_music_Pathfinder", "Music_Lobby_Pathfinder",
	"mainmenu_music_Event1", "Music_Lobby_Event1",
	"mainmenu_music_Event2", "Music_Lobby_Event2",
	"mainmenu_music_Wattson", "Music_Lobby_Wattson",
	"mainmenu_music_Wraith", "Music_Lobby_Wraith",
	"mainmenu_music_Event3", "Music_Lobby_Event3",
	"mainmenu_music_Event4", "Music_Lobby_Event4",
	"mainmenu_music_Crypto", "Music_Lobby_Crypto",
	"mainmenu_music_Season4", "Music_Lobby_Season4",
	"mainmenu_music_Revenant", "Music_Lobby_Revenant",
	"mainmenu_music_Season4_1", "Music_Lobby_Season4_1",
	"mainmenu_music_Season4_2", "Music_Lobby_Season4_2",
	"mainmenu_music_Season5", "Music_Lobby_Season5",
	"mainmenu_music_Loba", "Music_Lobby_Loba",
	"mainmenu_music_Season5_1", "Music_Lobby_Season5_1",
	"mainmenu_music_Season6", "Music_Lobby_Season6",
	"mainmenu_music_Rampart", "Music_Lobby_Rampart",
	"mainmenu_music_Season6_1", "Music_Lobby_Season6_1",
	"mainmenu_music_Halloween20", "Music_Lobby_Halloween20",
	"mainmenu_music_Season7", "Music_Lobby_Season7",
	"mainmenu_music_Horizon", "Music_Lobby_Horizon",
	"mainmenu_music_Season8", "Music_Lobby_Season8",
	"mainmenu_music_Fuse", "Music_Lobby_Fuse",
	"mainmenu_music_Season8_1", "Music_Lobby_Season8_1",
	//
	"SQ_Music_Lobby_Silence", "SQ_S5_Music_9_44p", "SQ_S5_Music_EP", "SQ_S6_Page_1_01", "SQ_S6_Page_1_02", "SQ_S6_Page_2_01", "SQ_S6_Page_2_02", "SQ_S6_Page_2_03", "SQ_S6_Page_3_01", "SQ_S6_Page_3_02"
	"SQ_S6_Page_4_01", "SQ_S6_Page_4_02", "SQ_S6_Page_4_03", "SQ_S6_Page_5_01", "SQ_S6_Page_5_02", "SQ_S6_Page_5_03", "SQ_S6_Page_6_01", "SQ_S6_Page_6_02", "SQ_S6_Page_7_01", "SQ_S6_Page_7_02", "SQ_S6_Page_7_03"
	"SQ_S6_Page_6_03", "SQ_S7_Page_1_01", "SQ_S7_Page_1_02", "SQ_S7_Page_1_03", "SQ_S7_Page_2_01", "SQ_S7_Page_2_02", "SQ_S7_Page_2_03", "SQ_S7_Page_3_01"
	"SQ_S7_Page_3_02", "SQ_S7_Page_3_03", "SQ_S7_Page_4_01", "SQ_S7_Page_4_02", "SQ_S7_Page_4_03", "SQ_S7_Page_5_01", "SQ_S7_Page_5_02", "SQ_S7_Page_5_03", "SQ_S6_Page_7_01", "SQ_S7_Page_6_02", "SQ_S7_Page_6_03"
	"SQ_S7_Page_7_01", "SQ_S7_Page_7_02", "SQ_S7_Page_7_03", "SQ_S8_Page_2_09", "SQ_S8_Page_2_13", "SQ_S8_Page_2_16", "SQ_S8_Page_2_17", "SQ_S8_Page_3_19", "SQ_S8_Page_3_28", "SQ_S8_Page_3_27", "SQ_S8_Page_1_1"
	"SQ_S8_Page_4_29", "SQ_S8_Page_5_38", "SQ_S8_Page_5_43", "SQ_S8_Page_6_45", "SQ_S8_Page_6_53", "SQ_S8_Page_7_54", "SQ_S8_Page_7_59", 
	LOOT_CEREMONY_MUSIC_P1,
	LOOT_CEREMONY_MUSIC_P2
]

void function UIMusicUpdate( bool wasManualMusicPackChange = false )
{
	int currentMusicContext  = uiGlobal.activeMusicContext
	string currentMusicTrack = uiGlobal.activeMusicTrack
	int desiredMusicContext  = eMenuMusicContext.NONE
	string desiredMusicTrack = "" //

	if ( uiGlobal.playingVideo )
	{
		desiredMusicContext = eMenuMusicContext.NONE
		desiredMusicTrack = ""
	}
	else if ( !IsConnected() )
	{
		//
		desiredMusicContext = eMenuMusicContext.MAIN_MENU
		desiredMusicTrack = "Music_FrontEnd"
	}
	else if ( IsLobby() )
	{
		if ( uiGlobal.desiredCustomMusicOrNull != null )
		{
			desiredMusicContext = eMenuMusicContext.CUSTOM
			desiredMusicTrack = expect string(uiGlobal.desiredCustomMusicOrNull)
		}
		else
		{
			if ( IsLocalClientEHIValid() && LoadoutSlot_IsReady( LocalClientEHI(), Loadout_MusicPack() ) )
			{
				ItemFlavor musicPack = GetMusicPackForPlayer( GetUIPlayer() )
				uiGlobal.WORKAROUND_activeMusicPack = musicPack

				desiredMusicContext = eMenuMusicContext.LOBBY
				if ( currentMusicContext == eMenuMusicContext.MAIN_MENU || wasManualMusicPackChange )
					desiredMusicTrack = MusicPack_GetMainMenuToLobbyMusic( musicPack )
				else
					desiredMusicTrack = MusicPack_GetLobbyMusic( musicPack )
			}
			else
			{
				//
				desiredMusicContext = currentMusicContext
				desiredMusicTrack = currentMusicTrack

				thread UpdateUIMusicOnMusicPackLoadoutSlotReadyThread()
			}
		}
	}
	else
	{
		desiredMusicContext = eMenuMusicContext.NONE
		desiredMusicTrack = ""
	}

	bool changeIfDesiredMusicTrackIsDifferentEvenIfContextIsUnchanged = false
	if ( wasManualMusicPackChange )
		changeIfDesiredMusicTrackIsDifferentEvenIfContextIsUnchanged = true
	if ( desiredMusicContext == eMenuMusicContext.CUSTOM ) //
		changeIfDesiredMusicTrackIsDifferentEvenIfContextIsUnchanged = true

	bool shouldChangeMusic = false //
	if ( desiredMusicContext != currentMusicContext ) //
		shouldChangeMusic = true
	else if ( currentMusicTrack == "" && desiredMusicTrack != "" ) //
		shouldChangeMusic = true
	else if ( currentMusicTrack != "" && desiredMusicTrack == "" ) //
		shouldChangeMusic = true
	else if ( desiredMusicTrack != currentMusicTrack && changeIfDesiredMusicTrackIsDifferentEvenIfContextIsUnchanged ) //
		shouldChangeMusic = true

	if ( shouldChangeMusic )
	{
		if ( desiredMusicContext != eMenuMusicContext.LOBBY )
			uiGlobal.WORKAROUND_activeMusicPack = null

		uiGlobal.activeMusicContext = desiredMusicContext

		printf( "Menu music update: %s (%s) -> %s (%s) (%s)", currentMusicTrack, DEV_GetEnumStringSafe( "eMenuMusicContext", currentMusicContext ), desiredMusicTrack, DEV_GetEnumStringSafe( "eMenuMusicContext", desiredMusicContext ), changeIfDesiredMusicTrackIsDifferentEvenIfContextIsUnchanged ? "T" : "F" )

		if ( desiredMusicTrack != currentMusicTrack )
		{
			foreach ( string soundName in WORKAROUND_UI_MUSIC_SOUND_LIST )
				StopUISoundByName( soundName )

			if ( desiredMusicTrack != "" )
			{
				Assert( WORKAROUND_UI_MUSIC_SOUND_LIST.contains( desiredMusicTrack ), format( "Tried to play '%s' for UI music but its not in WORKAROUND_UI_MUSIC_SOUND_LIST", desiredMusicTrack ) )
				EmitUISound( desiredMusicTrack )
			}

			uiGlobal.activeMusicTrack = desiredMusicTrack
		}
	}
}


void function UpdateUIMusicOnMusicPackLoadoutSlotReadyThread()
{
	Signal( uiGlobal.signalDummy, "UpdateUIMusicOnMusicPackLoadoutSlotReadyThread" )
	EndSignal( uiGlobal.signalDummy, "UpdateUIMusicOnMusicPackLoadoutSlotReadyThread" )

	WaitForLocalClientEHI()
	LoadoutSlot_WaitForItemFlavor( LocalClientEHI(), Loadout_MusicPack() )

	UIMusicUpdate()
}


void function PlayCustomUIMusic( string music )
{
	Assert( IsConnected() && IsLobby() )

	uiGlobal.desiredCustomMusicOrNull = music
	UIMusicUpdate()
}


void function CancelCustomUIMusic()
{
	uiGlobal.desiredCustomMusicOrNull = null
	UIMusicUpdate()
}


void function RegisterMenuVarInt( string varName, int value )
{
	table<string, int> intVars = uiGlobal.intVars

	Assert( !(varName in intVars) )

	intVars[varName] <- value
}


void function RegisterMenuVarBool( string varName, bool value )
{
	table<string, bool> boolVars = uiGlobal.boolVars

	Assert( !(varName in boolVars) )

	boolVars[varName] <- value
}


void function RegisterMenuVarVar( string varName, var value )
{
	table<string, var> varVars = uiGlobal.varVars

	Assert( !(varName in varVars) )

	varVars[varName] <- value
}


int function GetMenuVarInt( string varName )
{
	table<string, int> intVars = uiGlobal.intVars

	Assert( varName in intVars )

	return intVars[varName]
}


bool function GetMenuVarBool( string varName )
{
	table<string, bool> boolVars = uiGlobal.boolVars

	Assert( varName in boolVars )

	return boolVars[varName]
}


var function GetMenuVarVar( string varName )
{
	table<string, var> varVars = uiGlobal.varVars

	Assert( varName in varVars )

	return varVars[varName]
}


void function SetMenuVarInt( string varName, int value )
{
	table<string, int> intVars = uiGlobal.intVars

	Assert( varName in intVars )

	if ( intVars[varName] == value )
		return

	intVars[varName] = value

	table<string, array<void functionref()> > varChangeFuncs = uiGlobal.varChangeFuncs

	if ( varName in varChangeFuncs )
	{
		foreach ( func in varChangeFuncs[varName] )
		{
			//
			func()
		}
	}
}


void function SetMenuVarBool( string varName, bool value )
{
	table<string, bool> boolVars = uiGlobal.boolVars

	Assert( varName in boolVars )

	if ( boolVars[varName] == value )
		return

	boolVars[varName] = value

	table<string, array<void functionref()> > varChangeFuncs = uiGlobal.varChangeFuncs

	if ( varName in varChangeFuncs )
	{
		foreach ( func in varChangeFuncs[varName] )
		{
			//
			func()
		}
	}
}


void function SetMenuVarVar( string varName, var value )
{
	table<string, var> varVars = uiGlobal.varVars

	Assert( varName in varVars )

	if ( varVars[varName] == value )
		return

	varVars[varName] = value

	table<string, array<void functionref()> > varChangeFuncs = uiGlobal.varChangeFuncs

	if ( varName in varChangeFuncs )
	{
		foreach ( func in varChangeFuncs[varName] )
		{
			//
			func()
		}
	}
}


void function AddMenuVarChangeHandler( string varName, void functionref() func )
{
	table<string, array<void functionref()> > varChangeFuncs = uiGlobal.varChangeFuncs

	if ( !(varName in varChangeFuncs) )
		varChangeFuncs[varName] <- []

	//
	varChangeFuncs[varName].append( func )
}

//
//
void function InitGlobalMenuVars()
{
	RegisterMenuVarBool( "isFullyConnected", false )
	RegisterMenuVarBool( "isPartyLeader", false )
	RegisterMenuVarBool( "isGamepadActive", IsControllerModeActive() )
	RegisterMenuVarBool( "isMatchmaking", false )

	#if(CONSOLE_PROG)
		RegisterMenuVarBool( "CONSOLE_isSignedIn", false )
	#endif //

	#if(DURANGO_PROG)
		RegisterMenuVarBool( "DURANGO_canInviteFriends", false )
		RegisterMenuVarBool( "DURANGO_isJoinable", false )
	#elseif(PLAYSTATION_PROG)
		RegisterMenuVarBool( "PS4_canInviteFriends", false )
	#elseif(PC_PROG)
		RegisterMenuVarBool( "ORIGIN_isEnabled", false )
		RegisterMenuVarBool( "ORIGIN_isJoinable", false )
	#elseif(NX_PROG)
		RegisterMenuVarBool( "NX_canInviteFriends", false )
	#endif

	thread UpdateIsFullyConnected()
	thread UpdateAmIPartyLeader()
	thread UpdateActiveMenuThink()
	thread UpdateIsMatchmaking()

	#if(CONSOLE_PROG)
		thread UpdateConsole_IsSignedIn()
	#endif //

	#if(DURANGO_PROG)
		thread UpdateDurango_CanInviteFriends()
		thread UpdateDurango_IsJoinable()
	#elseif(PLAYSTATION_PROG)
		thread UpdatePS4_CanInviteFriends()
	#elseif(PC_PROG)
		thread UpdatePCPlat_IsEnabled()
		thread UpdatePCPlat_IsJoinable()
		thread UpdateIsGamepadActive()
	#elseif(NX_PROG)
		thread UpdateNX_CanInviteFriends()
	#endif
}


bool function _IsMenuThinkActive()
{
	return file.menuThinkThreadActive
}


void function UpdateActiveMenuThink()
{
	OnThreadEnd(
		function() : ()
		{
			Assert( false, "This thread should not have ended" )
			file.menuThinkThreadActive = false
		}
	)

	file.menuThinkThreadActive = true
	while ( true )
	{
		var menu = GetActiveMenu()
		if ( menu )
		{
			Assert( menu in uiGlobal.menuData )
			foreach ( func in uiGlobal.menuData[ menu ].thinkFuncs )
				func( menu )
		}

		WaitFrame()
	}
}


void function UpdateIsFullyConnected()
{
	while ( true )
	{
		SetMenuVarBool( "isFullyConnected", IsFullyConnected() )
		WaitFrame()
	}
}


void function UpdateAmIPartyLeader()
{
	while ( true )
	{
		SetMenuVarBool( "isPartyLeader", AmIPartyLeader() )
		WaitFrame()
	}
}


void function UpdateIsMatchmaking()
{
	while ( true )
	{
		SetMenuVarBool( "isMatchmaking", (IsConnected() && AreWeMatchmaking()) )
		WaitFrame()
	}
}

#if(CONSOLE_PROG)
void function UpdateConsole_IsSignedIn()
{
	while ( true )
	{
		SetMenuVarBool( "CONSOLE_isSignedIn", Console_IsSignedIn() )
		WaitFrame()
	}
}
#endif //


#if(PLAYSTATION_PROG)
void function UpdatePS4_CanInviteFriends()
{
	while ( true )
	{
		SetMenuVarBool( "PS4_canInviteFriends", PS4_canInviteFriends() )
		WaitFrame()
	}
}
#endif //

#if(NX_PROG)
void function UpdateNX_CanInviteFriends()
{
	while ( true )
	{
		SetMenuVarBool( "NX_canInviteFriends", NX_canInviteFriends() )
		WaitFrame()
	}
}
#endif //

#if(DURANGO_PROG)
void function UpdateDurango_CanInviteFriends()
{
	while ( true )
	{
		SetMenuVarBool( "DURANGO_canInviteFriends", Durango_CanInviteFriends() )
		WaitFrame()
	}
}

void function UpdateDurango_IsJoinable()
{
	while ( true )
	{
		SetMenuVarBool( "DURANGO_isJoinable", Durango_IsJoinable() )
		WaitFrame()
	}
}
#endif //

#if(PC_PROG)
void function UpdatePCPlat_IsEnabled()
{
	while ( true )
	{
		SetMenuVarBool( "ORIGIN_isEnabled", PCPlat_IsEnabled() )
		WaitFrame()
	}
}

void function UpdatePCPlat_IsJoinable()
{
	while ( true )
	{
		SetMenuVarBool( "ORIGIN_isJoinable", PCPlat_IsJoinable() )
		WaitFrame()
	}
}

void function UpdateIsGamepadActive()
{
	while ( true )
	{
		SetMenuVarBool( "isGamepadActive", IsControllerModeActive() )
		WaitFrame()
	}
}
#endif //

void function InviteFriends()
{
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

#if(DURANGO_PROG)
void function OpenXboxPartyApp( var button )
{
	Durango_OpenPartyApp()
}

void function OpenXboxHelp( var button )
{
	Durango_ShowHelpWindow()
}
#endif //

#if(DEV)
void function OpenDevMenu( var button )
{
	AdvanceMenu( GetMenu( "DevMenu" ) )
}
#endif //

void function SetDialog( var menu, bool val )
{
	uiGlobal.menuData[ menu ].isDialog = val
}


void function SetPopup( var menu, bool val )
{
	uiGlobal.menuData[ menu ].isDialog = val
	uiGlobal.menuData[ menu ].isPopup = val
	uiGlobal.menuData[ menu ].clearBlur = false
}


void function SetAllowControllerFooterClick( var menu, bool val )
{
	uiGlobal.menuData[ menu ].allowControllerFooterClick = val
}


void function SetClearBlur( var menu, bool val )
{
	uiGlobal.menuData[ menu ].clearBlur = val
}


void function SetPanelClearBlur( var panel, bool val )
{
	uiGlobal.panelData[ panel ].panelClearBlur = val
}


bool function IsDialog( var menu )
{
	if ( menu == null )
		return false

	return uiGlobal.menuData[ menu ].isDialog
}


bool function IsPopup( var menu )
{
	if ( menu == null )
		return false

	return uiGlobal.menuData[ menu ].isPopup
}


bool function AllowControllerFooterClick( var menu )
{
	if ( menu == null )
		return false

	return uiGlobal.menuData[ menu ].allowControllerFooterClick
}


bool function ShouldClearBlur( var menu )
{
	if ( menu == null )
		return true

	return uiGlobal.menuData[ menu ].clearBlur
}


void function SetGamepadCursorEnabled( var menu, bool val )
{
	uiGlobal.menuData[ menu ].gamepadCursorEnabled = val
}


bool function IsGamepadCursorEnabled( var menu )
{
	if ( menu == null )
		return false

	return uiGlobal.menuData[ menu ].gamepadCursorEnabled
}


void function UpdateGamepadCursorEnabledThread()
{
	for ( ; ; )
	{
		WaitSignal( uiGlobal.signalDummy, "ActiveMenuChanged" )

		if ( IsGamepadCursorEnabled( GetActiveMenu() ) )
			ShowGameCursor()
		else
			HideGameCursor()
	}
}


bool function IsDialogOnlyActiveMenu()
{
	if ( !IsDialog( GetActiveMenu() ) )
		return false

	int stackLen = uiGlobal.menuStack.len()
	if ( stackLen < 1 )
		return false

	if ( uiGlobal.menuStack[stackLen - 1].menu != GetActiveMenu() )
		return false

	if ( stackLen == 1 )
		return true

	if ( uiGlobal.menuStack[stackLen - 2].menu == null )
		return true

	return false
}


void function AddCallback_OnPartyUpdated( void functionref() callbackFunc )
{
	Assert( !file.partyUpdatedCallbacks.contains( callbackFunc ), "Already added " + string( callbackFunc ) + " with AddCallback_OnPartyUpdated" )
	file.partyUpdatedCallbacks.append( callbackFunc )
}


void function RemoveCallback_OnPartyUpdated( void functionref() callbackFunc )
{
	Assert( file.partyUpdatedCallbacks.contains( callbackFunc ), "Callback " + string( callbackFunc ) + " doesn't exist" )
	file.partyUpdatedCallbacks.fastremovebyvalue( callbackFunc )
}


void function UICodeCallback_PartyUpdated()
{
	foreach ( callbackFunc in file.partyUpdatedCallbacks )
		callbackFunc()

	ShowNotification()

	if ( AmIPartyLeader() )
	{
		string activeSearchingPlaylist = GetActiveSearchingPlaylist()
		if ( activeSearchingPlaylist != "" && !CanPlaylistFitPartySize( activeSearchingPlaylist, GetPartySize(), IsSendOpenInviteTrue() ) )
			CancelMatchSearch()
	}

	if ( IsFullyConnected() )
	{
		//
		Party myParty = GetParty()

		int partyMemberCount = myParty.members.len()
		if ( AreWeMatchmaking() && partyMemberCount < file.partyMemberCount )
		{
			CancelMatchSearch()
			EmitUISound( "UI_Menu_ReadyUp_Cancel_1P" )
		}

		file.partyMemberCount = partyMemberCount
	}
}


void function AddCallback_OnPartyMemberRemoved( void functionref() callbackFunc )
{
	Assert( !file.partymemberRemovedCallbacks.contains( callbackFunc ), "Already added " + string( callbackFunc ) + " with AddCallback_OnPartyMemberRemoved" )
	file.partymemberRemovedCallbacks.append( callbackFunc )
}


void function RemoveCallback_OnPartyMemberRemoved( void functionref() callbackFunc )
{
	Assert( file.partymemberRemovedCallbacks.contains( callbackFunc ), "Callback " + string( callbackFunc ) + " doesn't exist" )
	file.partymemberRemovedCallbacks.fastremovebyvalue( callbackFunc )
}


void function AddCallback_OnPartyMemberAdded( void functionref() callbackFunc )
{
	Assert( !file.partymemberAddedCallbacks.contains( callbackFunc ), "Already added " + string( callbackFunc ) + " with AddCallback_OnPartyMemberAdded" )
	file.partymemberAddedCallbacks.append( callbackFunc )
}


void function RemoveCallback_OnPartyMemberAdded( void functionref() callbackFunc )
{
	Assert( file.partymemberAddedCallbacks.contains( callbackFunc ), "Callback " + string( callbackFunc ) + " doesn't exist" )
	file.partymemberAddedCallbacks.fastremovebyvalue( callbackFunc )
}


void function UICodeCallback_PartyMemberAdded()
{
	//
	foreach ( callbackFunc in file.partymemberAddedCallbacks )
		callbackFunc()
}


void function UICodeCallback_PartyMemberRemoved()
{
	//
	foreach ( callbackFunc in file.partymemberRemovedCallbacks )
		callbackFunc()
}


void function UICodeCallback_UserInfoUpdated( string hardware, string uid )
{
	//
	foreach ( callbackFunc in file.userInfoChangedCallbacks )
	{
		callbackFunc( hardware, uid )
	}
}


void function UICodeCallback_UIScriptResetComplete()
{
	printf( "UICodeCallback_UIScriptResetComplete()" )
	ShGRX_UIScriptResetComplete()
	RefreshChallenges()
	ImagePakLoad_UIScriptResetComplete()
}


void function AddCallbackAndCallNow_UserInfoUpdated( void functionref( string, string ) callbackFunc )
{
	Assert( !file.userInfoChangedCallbacks.contains( callbackFunc ) )
	file.userInfoChangedCallbacks.append( callbackFunc )

	callbackFunc( "", "" )
}


void function RemoveCallback_UserInfoUpdated( void functionref( string, string ) callbackFunc )
{
	Assert( file.userInfoChangedCallbacks.contains( callbackFunc ) )
	file.userInfoChangedCallbacks.fastremovebyvalue( callbackFunc )
}


//
void function HACK_DelayedSetFocus_BecauseWhy( var item )
{
	wait 0.1
	if ( IsValid( item ) )
		Hud_SetFocused( item )
}


void function UICodeCallback_KeyBindOverwritten( string key, string oldBinding, string newBinding )
{
	AddKeyBindEvent( key, newBinding, oldBinding )
	//
}


void function UICodeCallback_KeyBindSet( string key, string newBinding )
{
	foreach ( callbackFunc in uiGlobal.keyBindSetCallbacks )
	{
		callbackFunc( key, newBinding )
	}

	AddKeyBindEvent( key, newBinding )
}


void function AddUICallback_OnResolutionChanged( void functionref() callbackFunc )
{
	Assert( !uiGlobal.resolutionChangedCallbacks.contains( callbackFunc ) )
	uiGlobal.resolutionChangedCallbacks.append( callbackFunc )
}


void function AddCallback_OnTopLevelCustomizeContextChanged( var panel, void functionref( var ) callbackFunc )
{
	if ( !(panel in file.topLevelCustomizeContextChangedCallbacks) )
	{
		file.topLevelCustomizeContextChangedCallbacks[ panel ] <- [ callbackFunc ]
		return
	}
	else
	{
		Assert( !file.topLevelCustomizeContextChangedCallbacks[ panel ].contains( callbackFunc ), "Already added " + string( callbackFunc ) + " with AddCallback_OnCustomizeContextChanged for panel " + Hud_GetHudName( panel ) )
		file.topLevelCustomizeContextChangedCallbacks[ panel ].append( callbackFunc )
	}
}


void function RemoveCallback_OnTopLevelCustomizeContextChanged( var panel, void functionref( var ) callbackFunc )
{
	Assert( panel in file.topLevelCustomizeContextChangedCallbacks )
	Assert( file.topLevelCustomizeContextChangedCallbacks[ panel ].contains( callbackFunc ), "Callback " + string( callbackFunc ) + " for panel " + Hud_GetHudName( panel ) + " doesn't exist" )
	file.topLevelCustomizeContextChangedCallbacks[ panel ].fastremovebyvalue( callbackFunc )
}


bool function IsTopLevelCustomizeContextValid()
{
	return (uiGlobal.topLevelCustomizeContext != null)
}


ItemFlavor function GetTopLevelCustomizeContext()
{
	Assert( uiGlobal.topLevelCustomizeContext != null, "Tried using GetCustomizeContext() when it wasn't set to a valid value." )

	return expect ItemFlavor( uiGlobal.topLevelCustomizeContext )
}


void function SetTopLevelCustomizeContext( ItemFlavor ornull item )
{
	uiGlobal.topLevelCustomizeContext = item

	array<var> panels = []
	var activeMenu    = GetActiveMenu()
	if ( activeMenu != null )
		panels.append( activeMenu )
	panels.extend( uiGlobal.activePanels )

	foreach ( panel in panels )
	{
		if ( !(panel in file.topLevelCustomizeContextChangedCallbacks) )
			continue

		foreach ( callbackFunc in file.topLevelCustomizeContextChangedCallbacks[ panel ] )
			callbackFunc( panel )
	}
}


void function AddUICallback_LevelLoadingFinished( void functionref() callback )
{
	file.levelLoadingFinishedCallbacks.append( callback )
}


void function AddUICallback_LevelShutdown( void functionref() callback )
{
	file.levelShutdownCallbacks.append( callback )
}


void function ButtonClass_AddMenu( var menu )
{
	array<var> buttons = GetElementsByClassname( menu, "MenuButton" )
	foreach ( button in buttons )
	{
		InitButtonRCP( button )
	}
}


void function InitButtonRCP( var button )
{
	UIScaleFactor scaleFactor = GetContentScaleFactor( GetMenu( "MainMenu" ) )
	int width                 = int( float( Hud_GetWidth( button ) ) / scaleFactor.x )
	int height                = int( float( Hud_GetHeight( button ) ) / scaleFactor.y )
	RuiSetFloat2( Hud_GetRui( button ), "actualRes", <width, height, 0> )
}


void function ClientToUI_SetCommsMenuOpen( bool state )
{
	uiGlobal.commsMenuOpen = state
}


bool function IsCommsMenuOpen()
{
	return uiGlobal.commsMenuOpen
}


bool function IsModeSelectMenuOpen()
{
	return uiGlobal.modeSelectMenuOpen
}


void function AddCallbackAndCallNow_RemoteMatchInfoUpdated( void functionref() callbackFunc )
{
	Assert( !file.remoteMatchInfoChangedCallbacks.contains( callbackFunc ) )
	file.remoteMatchInfoChangedCallbacks.append( callbackFunc )

	callbackFunc()
}


void function RemoveCallback_RemoteMatchInfoUpdated( void functionref() callbackFunc )
{
	Assert( file.remoteMatchInfoChangedCallbacks.contains( callbackFunc ) )
	file.remoteMatchInfoChangedCallbacks.fastremovebyvalue( callbackFunc )
}


void function UICodeCallback_RemoteMatchInfoUpdated()
{
	foreach ( callbackFunc in file.remoteMatchInfoChangedCallbacks )
	{
		callbackFunc()
	}
}


void function UpdateMatchPINData( string pinKey, string pinValue )
{
	uiGlobal.matchPinData[pinKey] <- pinValue
}


void function IncrementNumDialogFlowDialogsDisplayed()
{
	file.numDialogFlowDialogsDisplayed++
}


void function EnterLobbySurveyReset()
{
	file.numDialogFlowDialogsDisplayed = 0
}

//
void function TEMP_CircularReferenceCleanup()
{
	if ( !file.TEMP_circularReferenceCleanupEnabled )
		return

	collectgarbage()
}
