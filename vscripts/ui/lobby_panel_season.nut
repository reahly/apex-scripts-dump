global function InitSeasonPanel
global function InitSeasonWelcomeMenu
global function JumpToSeasonTab

global function SeasonPanel_GetLastMenuNavDirectionTopLevel

struct
{
	var panel

	bool tabsInitialized = false
	bool callbacksAdded = false

	bool wasCollectionEventActive = false
	bool wasThemedShopEventActive = false

	bool isFirstSessionOpen = true

	bool lastMenuNavDirectionTopLevel = MENU_NAV_FORWARD

} file


void function InitSeasonPanel( var panel )
{
	file.panel = panel
	SetPanelTabTitle( panel, "#PLAY" )
	AddPanelEventHandler( panel, eUIEvent.PANEL_SHOW, SeasonPanel_OnShow )
	AddPanelEventHandler( panel, eUIEvent.PANEL_HIDE, SeasonPanel_OnHide )
}


void function SeasonPanel_OnShow( var panel )
{
	TabData tabData = GetTabDataForPanel( panel )
	if ( !file.tabsInitialized )
	{
		SetTabNavigationEndCallback( tabData, eTabDirection.NEXT, void function () : () {
			TabData lobbyTabData = GetTabDataForPanel( GetMenu( "LobbyMenu" ) )
			ActivateTab( lobbyTabData, 1 )
		} )
		file.tabsInitialized = true
		tabData.groupNavHints = true
	}
	UI_SetPresentationType( ePresentationType.WEAPON_CATEGORY )

	if ( !file.callbacksAdded )
	{
		AddCallbackAndCallNow_OnGRXInventoryStateChanged( OnGRXSeasonUpdate )
		AddCallbackAndCallNow_OnGRXOffersRefreshed( OnGRXSeasonUpdate )
		Newness_AddCallbackAndCallNow_OnRerverseQueryUpdated( NEWNESS_QUERIES.QuestTab, OnNewnessQueryChangedUpdatePanelTab, GetPanel( "QuestPanel" ) )
		file.callbacksAdded = true
	}


	thread AnimateTabBar( tabData )
}


void function SeasonPanel_OnHide( var panel )
{
	TabData tabData = GetTabDataForPanel( panel )
	DeactivateTab( tabData )

	if ( file.callbacksAdded )
	{
		RemoveCallback_OnGRXInventoryStateChanged( OnGRXSeasonUpdate )
		RemoveCallback_OnGRXOffersRefreshed( OnGRXSeasonUpdate )

		Newness_RemoveCallback_OnRerverseQueryUpdated( NEWNESS_QUERIES.QuestTab, OnNewnessQueryChangedUpdatePanelTab, GetPanel( "QuestPanel" ) )
		file.callbacksAdded = false
	}
}


array<var> function GetAllMenuPanelsSorted( var menu )
{
	array<var> allPanels = GetAllMenuPanels( menu )
	foreach ( panel in allPanels )
		printt( Hud_GetHudName( panel ) )
	allPanels.sort( SortMenuPanelsByPlaylist )

	return allPanels
}


int function SortMenuPanelsByPlaylist( var a, var b )
{
	//
	string playlistVal = GetCurrentPlaylistVarString( "season_panel_order", "CollectionEventPanel|ThemedShopPanel|PassPanel|QuestPanel|ChallengesPanel" )
	if ( playlistVal == "" )
		return 0

	array<string> tokens = split( playlistVal, "|" )
	if ( tokens.find( Hud_GetHudName( a ) ) > tokens.find( Hud_GetHudName( b ) ) )
		return 1
	else if ( tokens.find( Hud_GetHudName( b ) ) > tokens.find( Hud_GetHudName( a ) ) )
		return -1

	return 0
}


void function OnGRXSeasonUpdate()
{
	TabData tabData = GetTabDataForPanel( file.panel )
	UpdateSeasonTab()

	if ( !GRX_IsInventoryReady() || !GRX_AreOffersReady() )
	{
		DeactivateTab( tabData )
		SetTabNavigationEnabled( file.panel, false )

		foreach ( tabDef in GetPanelTabs( file.panel ) )
		{
			SetTabDefEnabled( tabDef, false )
		}
	}
	else
	{
		ItemFlavor ornull activeCollectionEvent = GetActiveCollectionEvent( GetUnixTimestamp() )
		bool haveActiveCollectionEvent          = (activeCollectionEvent != null)
		ItemFlavor ornull activeThemedShopEvent = GetActiveThemedShopEvent( GetUnixTimestamp() )
		bool haveActiveThemedShopEvent          = (activeThemedShopEvent != null)

		if ( haveActiveCollectionEvent != file.wasCollectionEventActive || haveActiveThemedShopEvent != file.wasThemedShopEventActive || GetMenuNumTabs( file.panel ) == 0 )
		{
			ClearTabs( file.panel )
			array<var> nestedPanels = GetAllMenuPanelsSorted( file.panel )
			foreach ( nestedPanel in nestedPanels )
			{
				bool wantDividerAfter               = false
				float tabBarLeftOffsetFracIfVisible = 0.0

				if ( Hud_GetHudName( nestedPanel ) == "CollectionEventPanel" && !haveActiveCollectionEvent )
					continue

				if ( Hud_GetHudName( nestedPanel ) == "ThemedShopPanel" && !haveActiveThemedShopEvent )
					continue

				switch ( Hud_GetHudName( nestedPanel ) )
				{
					case "ThemedShopPanel":
					case "CollectionEventPanel":
						//
						//
						break
				}

				AddTab( file.panel, nestedPanel, GetPanelTabTitle( nestedPanel ), wantDividerAfter, tabBarLeftOffsetFracIfVisible )
			}

			file.wasCollectionEventActive = haveActiveCollectionEvent
			file.wasThemedShopEventActive = haveActiveThemedShopEvent
		}
		SetTabNavigationEnabled( file.panel, true )
		ItemFlavor season = GetLatestSeason( GetUnixTimestamp() )

		int numTabs = tabData.tabDefs.len()
		foreach ( TabDef tabDef in GetPanelTabs( file.panel ) )
		{
			bool showTab   = true
			bool enableTab = true

			tabDef.title = GetPanelTabTitle( tabDef.panel )

			if ( Hud_GetHudName( tabDef.panel ) == "CollectionEventPanel" )
			{
				showTab = haveActiveCollectionEvent
				enableTab = true
				if ( haveActiveCollectionEvent )
				{
					expect ItemFlavor(activeCollectionEvent)

					tabDef.title = "#MENU_STORE_PANEL_COLLECTION" //

					tabDef.useCustomColors = true
					tabDef.customDefaultBGCol = CollectionEvent_GetTabBGDefaultCol( activeCollectionEvent )
					tabDef.customDefaultBarCol = CollectionEvent_GetTabBarDefaultCol( activeCollectionEvent )
					tabDef.customFocusedBGCol = CollectionEvent_GetTabBGFocusedCol( activeCollectionEvent )
					tabDef.customFocusedBarCol = CollectionEvent_GetTabBarFocusedCol( activeCollectionEvent )
					tabDef.customSelectedBGCol = CollectionEvent_GetTabBGSelectedCol( activeCollectionEvent )
					tabDef.customSelectedBarCol = CollectionEvent_GetTabBarSelectedCol( activeCollectionEvent )
				}
			}
			else if ( Hud_GetHudName( tabDef.panel ) == "ThemedShopPanel" )
			{
				showTab = haveActiveThemedShopEvent
				if ( haveActiveThemedShopEvent )
				{
					expect ItemFlavor(activeThemedShopEvent)

					tabDef.title = ThemedShopEvent_GetTabText( activeThemedShopEvent )

					tabDef.useCustomColors = true
					tabDef.customDefaultBGCol = ThemedShopEvent_GetTabBGDefaultCol( activeThemedShopEvent )
					tabDef.customDefaultBarCol = ThemedShopEvent_GetTabBarDefaultCol( activeThemedShopEvent )
					tabDef.customFocusedBGCol = ThemedShopEvent_GetTabBGFocusedCol( activeThemedShopEvent )
					tabDef.customFocusedBarCol = ThemedShopEvent_GetTabBarFocusedCol( activeThemedShopEvent )
					tabDef.customSelectedBGCol = ThemedShopEvent_GetTabBGSelectedCol( activeThemedShopEvent )
					tabDef.customSelectedBarCol = ThemedShopEvent_GetTabBarSelectedCol( activeThemedShopEvent )
				}
			}
			else
			{
				tabDef.useCustomColors = true
				tabDef.customDefaultBGCol = Season_GetTabBGDefaultCol( season )
				tabDef.customDefaultBarCol = Season_GetTabBarDefaultCol( season )
				tabDef.customFocusedBGCol = Season_GetTabBGFocusedCol( season )
				tabDef.customFocusedBarCol = Season_GetTabBarFocusedCol( season )
				tabDef.customSelectedBGCol = Season_GetTabBGSelectedCol( season )
				tabDef.customSelectedBarCol = Season_GetTabBarSelectedCol( season )
			}

			SetTabDefVisible( tabDef, showTab )
			SetTabDefEnabled( tabDef, enableTab )
		}

		int activeIndex = tabData.activeTabIdx

		file.lastMenuNavDirectionTopLevel = uiGlobal.lastMenuNavDirection

		if ( GetCurrentPlaylistVarBool( "season_panel_reverse_nav", true ) || (file.isFirstSessionOpen && GetCurrentPlaylistVarBool( "season_panel_first_open_behavior", true )) )
		{
			if ( uiGlobal.lastMenuNavDirection == MENU_NAV_FORWARD )
				activeIndex = 0

			while( (!IsTabIndexEnabled( tabData, activeIndex ) || !IsTabIndexVisible( tabData, activeIndex ) || activeIndex == INVALID_TAB_INDEX) && activeIndex > numTabs )
				activeIndex++
		}
		else
		{
			if ( uiGlobal.lastMenuNavDirection == MENU_NAV_FORWARD )
				activeIndex = numTabs - 1

			while( (!IsTabIndexEnabled( tabData, activeIndex ) || !IsTabIndexVisible( tabData, activeIndex ) || activeIndex == INVALID_TAB_INDEX) && activeIndex < numTabs )
				activeIndex--
		}
		file.isFirstSessionOpen = false

		bool wasPanelActive = IsTabActive( tabData )
		if ( !wasPanelActive )
			ActivateTab( tabData, activeIndex )
	}
}


bool function SeasonPanel_GetLastMenuNavDirectionTopLevel()
{
	return file.lastMenuNavDirectionTopLevel
}


void function AnimateTabBar( TabData tabData )
{
	Hud_SetY( tabData.tabPanel, Hud_GetHeight( tabData.tabPanel ) )
	Hud_ReturnToBasePosOverTime( tabData.tabPanel, 0.25, INTERPOLATOR_DEACCEL )
}


void function JumpToSeasonTab( string activateSubPanel = "" )
{
	while ( GetActiveMenu() != GetMenu( "LobbyMenu" ) )
		CloseActiveMenu( true, true )

	TabData lobbyTabData = GetTabDataForPanel( GetMenu( "LobbyMenu" ) )
	ActivateTab( lobbyTabData, Tab_GetTabIndexByBodyName( lobbyTabData, "SeasonPanel" ) )

	if ( activateSubPanel == "" )
		return

	TabData tabData = GetTabDataForPanel( file.panel )
	int tabIndex = Tab_GetTabIndexByBodyName( tabData, activateSubPanel )
	if ( tabIndex == -1 )
	{
		Warning( "JumpToSeasonTab() is ignoring unknown subpanel \"" + activateSubPanel + "\"" )
		return
	}

	ActivateTab( tabData, tabIndex )
}

struct
{
	var menu

	var welcomeHeader

} s_welcomeMenu

void function InitSeasonWelcomeMenu( var menu )
{
	s_welcomeMenu.menu = menu
	s_welcomeMenu.welcomeHeader = Hud_GetChild( menu, "Header" )

	AddMenuEventHandler( menu, eUIEvent.MENU_OPEN, SeasonWelcome_OnOpen )
	AddMenuEventHandler( menu, eUIEvent.MENU_CLOSE, SeasonWelcome_OnClose )

	//
	//

	AddMenuFooterOption( menu, LEFT, BUTTON_B, true, "#B_BUTTON_BACK", "#B_BUTTON_BACK" )
}


void function SeasonWelcome_OnOpen()
{
	ItemFlavor season = GetLatestSeason( GetUnixTimestamp() )
	//
	//
	//
	//
	//
	//
	//
	//
	//

	HudElem_SetRuiArg( s_welcomeMenu.welcomeHeader, "logo", Season_GetSmallLogo( season ), eRuiArgType.IMAGE )
}


void function SeasonWelcome_OnClose()
{

}

