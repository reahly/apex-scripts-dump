global function InitMainMenu
global function LaunchMP
global function AttemptLaunch
global function GetUserSignInState
global function UpdateSignedInState

struct
{
	var menu
	var titleArt
	var subtitle
	var versionDisplay
	var signedInDisplay
	#if(PLAYSTATION_PROG)
		bool chatRestrictionNoticeJustHandled = false
	#endif //
	#if(NX_PROG)
		var LangAOCNeeded
	#endif
} file


void function InitMainMenu( var newMenuArg ) //
{
	var menu = GetMenu( "MainMenu" )
	file.menu = menu

	SetGamepadCursorEnabled( menu, false )

	AddMenuEventHandler( menu, eUIEvent.MENU_SHOW, OnMainMenu_Show )
	AddMenuEventHandler( menu, eUIEvent.MENU_CLOSE, OnMainMenu_Close )
	AddMenuEventHandler( menu, eUIEvent.MENU_NAVIGATE_BACK, OnMainMenu_NavigateBack )

	file.titleArt = Hud_GetChild( file.menu, "TitleArt" )
	var titleArtRui = Hud_GetRui( file.titleArt )
	RuiSetImage( titleArtRui, "basicImage", $"ui/menu/title_screen/title_art" )

	file.subtitle = Hud_GetChild( file.menu, "Subtitle" )
	var subtitleRui = Hud_GetRui( file.subtitle )
	RuiSetString( subtitleRui, "subtitleText", Localize( "#SEASON_N", 8 ).toupper() )

	file.versionDisplay = Hud_GetChild( menu, "VersionDisplay" )
	file.signedInDisplay = Hud_GetChild( menu, "SignInDisplay" )
	
	#if(NX_PROG)
		file.LangAOCNeeded = GetConVarInt( "AoCLanguageNeeded" )
	#endif
}


void function OnMainMenu_Show()
{
	//
	//
	float aspectRatio = 2.4 //
	int width = int( Hud_GetHeight( file.titleArt ) * aspectRatio )
	Hud_SetWidth( file.titleArt, width )
	Hud_SetWidth( file.subtitle, width )

	Hud_SetText( file.versionDisplay, GetPublicGameVersion() )
	Hud_Show( file.versionDisplay )

	ActivatePanel( GetPanel( "MainMenuPanel" ) )

	Chroma_MainMenu()
	
	#if(NX_PROG)
		if ( file.LangAOCNeeded > 0 )
		{
			if ( GetActiveMenu() == GetMenu( "EULADialog" ) )
				return
			
			OpenLangAoCDialog(false)
		}
	#endif

	SetMenuNavigationDisabled( true )
}


void function OnMainMenu_Close()
{
	HidePanel( GetPanel( "MainMenuPanel" ) )
	SetMenuNavigationDisabled( false )
}


void function ActivatePanel( var panel )
{
	Assert( panel != null )

	array<var> elems = GetElementsByClassname( file.menu, "MainMenuPanelClass" )
	foreach ( elem in elems )
	{
		if ( elem != panel && Hud_IsVisible( elem ) )
			HidePanel( elem )
	}

	ShowPanel( panel )
}


void function OnMainMenu_NavigateBack()
{
	if ( IsSearchingForPartyServer() )
	{
		StopSearchForPartyServer( "", Localize( "#MAINMENU_CONTINUE" ) )
		return
	}

	#if(PC_PROG)
		OpenConfirmExitToDesktopDialog()
	#endif //
}


int function GetUserSignInState()
{
	#if(DURANGO_PROG)
		if ( Durango_InErrorScreen() )
		{
			return userSignInState.ERROR
		}
		else if ( Durango_IsSigningIn() )
		{
			return userSignInState.SIGNING_IN
		}
		else if ( !Console_IsSignedIn() && !Console_SkippedSignIn() )
		{
			//
			return userSignInState.SIGNED_OUT
		}

		Assert( Console_IsSignedIn() || Console_SkippedSignIn() )
	#endif
	return userSignInState.SIGNED_IN
}


void function UpdateSignedInState()
{
	#if(DURANGO_PROG)
		if ( Console_IsSignedIn() )
		{
			Hud_SetText( file.signedInDisplay, Localize( "#SIGNED_IN_AS_N", Durango_GetGameDisplayName() ) )
			return
		}
	#endif
	Hud_SetText( file.signedInDisplay, "" )
}

void function LaunchMP()
{
	uiGlobal.launching = eLaunching.MULTIPLAYER
	AttemptLaunch()
}


void function AttemptLaunch()
{
	if ( uiGlobal.launching == eLaunching.FALSE )
		return
	Assert( uiGlobal.launching == eLaunching.MULTIPLAYER ||	uiGlobal.launching == eLaunching.MULTIPLAYER_INVITE )

	#if(CONSOLE_PROG)
		if ( !IsEULAAccepted() )
		{
			if ( GetActiveMenu() == GetMenu( "EULADialog" ) )
				return

			if ( IsDialog( GetActiveMenu() ) )
				CloseActiveMenu( true )

			if ( GetUserSignInState() != userSignInState.SIGNED_IN )
				return

			var mmp = GetPanel( "MainMenuPanel" )
            var launchButton = Hud_GetChild( mmp, "LaunchButton" )
			OpenEULADialog( false, null, launchButton )

			return
		}
	#endif //

	#if(PLAYSTATION_PROG)
		//
		//
		if ( !file.chatRestrictionNoticeJustHandled )
		{
			thread PS4_ChatRestrictionNotice()
			return
		}
	#endif //

	const int CURRENT_INTRO_VIDEO_VERSION = 8
	if ( (GetIntroViewedVersion() < CURRENT_INTRO_VIDEO_VERSION) || (InputIsButtonDown( KEY_LSHIFT ) && InputIsButtonDown( KEY_LCONTROL ))  || (InputIsButtonDown( BUTTON_TRIGGER_LEFT_FULL ) && InputIsButtonDown( BUTTON_TRIGGER_RIGHT_FULL )) )
	{
		if ( GetActiveMenu() == GetMenu( "PlayVideoMenu" ) )
			return

		if ( IsDialog( GetActiveMenu() ) )
			CloseActiveMenu( true )

		SetIntroViewedVersion( CURRENT_INTRO_VIDEO_VERSION )
		PlayVideoMenu( true, "intro", "Apex_Opening_Movie", eVideoSkipRule.HOLD, PrelaunchValidateAndLaunch )
		return
	}

	if( TryLoadReconnectFromLocalStorage() )
		thread DelayedReconnect()
	else
		StartSearchForPartyServer()

	uiGlobal.launching = eLaunching.FALSE
	#if(PLAYSTATION_PROG)
		file.chatRestrictionNoticeJustHandled = false
	#endif //
}

void function DelayedReconnect()
{
	float delay = GetReconnectDelay()
	printt("DelayedReconnect ", delay)

	Wait(delay )

	StartReconnectFromParameters()
}

#if(PLAYSTATION_PROG)
void function PS4_ChatRestrictionNotice()
{
	Plat_ShowChatRestrictionNotice()
	while ( Plat_IsSystemMessageDialogOpen() )
		WaitFrame()

	file.chatRestrictionNoticeJustHandled = true
	PrelaunchValidateAndLaunch()
}
#endif //
