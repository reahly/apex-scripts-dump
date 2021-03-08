global function InitPlayPanel
global function PlayPanel_LevelInit

global function IsPlayPanelCurrentlyTopLevel
global function PlayPanelUpdate
global function ClientToUI_PartyMemberJoinedOrLeft
global function GetModeSelectButton
global function GetLobbyChatBox

global function Lobby_GetPlaylists
global function Lobby_GetPlaylistMods
global function Lobby_GetSelectedPlaylist
global function Lobby_GetLastSelectedPlaylist
global function Lobby_IsPlaylistAvailable
global function Lobby_SetSelectedPlaylist
global function Lobby_ClearSelectedPlaylist
global function Lobby_SetSelectedPlaylistMods
global function Lobby_GetSelectedPlaylistExpectedSquadSize
global function Lobby_OnGamemodeSelectV2Close
global function Lobby_OnGamemodeSelectV3Close
global function Lobby_UpdateLoadscreenFromPlaylist

                       
                                   
      

global function Lobby_GetPlaylistState
global function Lobby_GetPlaylistStateString

global function Lobby_UpdatePlayPanelPlaylists

global function CanInvite

global function UpdateMiniPromoPinning
global function UpdateLootBoxButton

global function ShouldShowMatchmakingDelayDialog
global function ShowMatchmakingDelayDialog
global function ShouldShowLastGameRankedAbandonForgivenessDialog
global function ShowLastGameRankedAbandonForgivenessDialog
global function PulseModeButton

global function ReadyShortcut_OnActivate

global function IsTrainingCompleted
global function IsExemptFromTraining

global function UpdateSeasonTab

global function DialogFlow_DidCausePotentiallyInterruptingPopup

#if(DEV)
global function DEV_PrintPartyInfo
global function DEV_PrintUserInfo
global function Lobby_MovePopupMessage
global function Lobby_ShowCallToActionPopup
global function Lobby_ShowBattlePassPopup
global function Lobby_ShowHeirloomShopPopup
global function Lobby_ShowQuestPopup
global function Lobby_ShowStoryEventChallengesPopup
global function Lobby_ShowStoryEventDialoguePopup
#endif

const string SOUND_BP_POPUP = "UI_Menu_BattlePass_PopUp"

const string SOUND_START_MATCHMAKING_1P = "UI_Menu_ReadyUp_1P"
const string SOUND_STOP_MATCHMAKING_1P = "UI_Menu_ReadyUp_Cancel_1P"
const string SOUND_START_MATCHMAKING_3P = "UI_Menu_ReadyUp_3P"
const string SOUND_STOP_MATCHMAKING_3P = "UI_Menu_ReadyUp_Cancel_3P"

const float INVITE_LAST_TIMEOUT = 15.0
const float INVITE_LAST_PANEL_EXPIRATION = 1 * MINUTES_PER_HOUR * SECONDS_PER_MINUTE
global enum ePlaylistState
{
	AVAILABLE,
	NO_PLAYLIST,
	TRAINING_REQUIRED,
	COMPLETED_TRAINING_REQUIRED,
	PARTY_SIZE_OVER,
	LOCKED,
	RANKED_LEVEL_REQUIRED,
	RANKED_LARGE_RANK_DIFFERENCE,
	RANKED_NOT_INITIALIZED,
	RANKED_MATCH_ABANDON_DELAY,
	ACCOUNT_LEVEL_REQUIRED,
	ROTATION_GROUP_MISMATCH,
	_COUNT
}


const table< int, string > playlistStateMap = {
	[ ePlaylistState.NO_PLAYLIST ] = "#PLAYLIST_STATE_NO_PLAYLIST",
	[ ePlaylistState.TRAINING_REQUIRED ] = "#PLAYLIST_STATE_TRAINING_REQUIRED",
	[ ePlaylistState.COMPLETED_TRAINING_REQUIRED ] = "#PLAYLIST_STATE_COMLETED_TRAINING_REQUIRED",
	[ ePlaylistState.AVAILABLE ] = "#PLAYLIST_STATE_AVAILABLE",
	[ ePlaylistState.PARTY_SIZE_OVER ] = "#PLAYLIST_STATE_PARTY_SIZE_OVER",
	[ ePlaylistState.LOCKED ] = "#PLAYLIST_STATE_LOCKED",
	[ ePlaylistState.RANKED_LEVEL_REQUIRED ] = "#PLAYLIST_STATE_RANKED_LEVEL_REQUIRED",
	[ ePlaylistState.RANKED_LARGE_RANK_DIFFERENCE ] = "#PLAYLIST_STATE_RANKED_LARGE_RANK_DIFFERENCE",
	[ ePlaylistState.RANKED_NOT_INITIALIZED ] = "#PLAYLIST_STATE_RANKED_NOT_INITIALIZED",
	[ ePlaylistState.RANKED_MATCH_ABANDON_DELAY ] = "#RANKED_ABANDON_PENALTY_PLAYLIST_STATE",
	[ ePlaylistState.ROTATION_GROUP_MISMATCH ] = "#PLAYLIST_UNAVAILABLE",
	[ ePlaylistState.ACCOUNT_LEVEL_REQUIRED ] = "#PLAYLIST_STATE_ACCOUNT_LEVEL_REQUIRED",
}

global const string PLAYLIST_TRAINING = "survival_training"

struct
{
	var panel
	var chatBox
	var chatroomMenu
	var chatroomMenu_chatroomWidget

	var fillButton
	var modeButton
	var gamemodeSelectV2Button
	var gamemodeSelectV3Button
	var readyButton
	var trainingButton
	var inviteFriendsButton0
	var inviteFriendsButton1
	var inviteLastPlayedHeader
	var inviteLastPlayedUnitFrame0
	var inviteLastPlayedUnitFrame1
	var friendButton0
	var friendButton1
	var selfButton
	var allChallengesButton
	var eventPrizeTrackButton

	bool newModesAcknowledged = false

	var hdTextureProgress

	int lastExpireTime

	string lastVisiblePlaylistValue

	array<string> playlists
	array<string> playlistMods
	string        selectedPlaylist
	string        selectedPlaylistMods

	bool personInLeftSpot = false
	bool personInRightSlot = false

	Friend& friendInLeftSpot
	Friend& friendInRightSpot

	string lastPlayedPlayerPlatformUid0 = ""
	string lastPlayedPlayerNucleusID0 = ""
	int    lastPlayedPlayerHardwareID0 = -1
	string lastPlayedPlayerPlatformUid1 = ""
	string lastPlayedPlayerNucleusID1 = ""
	int    lastPlayedPlayerHardwareID1 = -1
	int    lastPlayedPlayerPersistenceIndex0 = -1
	int    lastPlayedPlayerPersistenceIndex1 = -1
	float  lastPlayedPlayerInviteSentTimestamp0 = -1
	float  lastPlayedPlayerInviteSentTimestamp1 = -1


	bool leftWasReady = false
	bool rightWasReady = false

	bool fullInstallNotification = false

	bool wasReady = false

	bool  haveShownSelfMatchmakingDelay = false
	bool  haveShownPartyMemberMatchmakingDelay = false
	bool  haveShownLastGameRankedAbandonForgivenessDialog = false
	int   lobbyRankTier = -1
	bool  rankedInitialized = false
	float currentMaxMatchmakingDelayEndTime = -1
	var   rankedRUIToUpdate = null

	void functionref() onCallToActionFunc

	string lastPlaylistDisplayed

                        
                        
                     
       

	table<string, float> s_cachedAccountXPFrac

	bool dialogFlowDidCausePotentiallyInterruptingPopup = false

	var  challengeCategorySelection
	bool challengeInputCallbacksRegistered = false
	int  challengeLastStickState = eStickState.NEUTRAL

	float nextAllowFriendsUpdateTime

	bool noFillButtonWasFullSquad = false
	bool noFillButtonWasPartyLeader = false
} file

void function InitPlayPanel( var panel )
{
	file.panel = panel
	SetPanelTabTitle( panel, "#PLAY" )
	AddPanelEventHandler( panel, eUIEvent.PANEL_SHOW, PlayPanel_OnShow )
	AddPanelEventHandler( panel, eUIEvent.PANEL_HIDE, PlayPanel_OnHide )
	AddPanelEventHandler( panel, eUIEvent.PANEL_NAVBACK, PlayPanel_OnNavBack )

	SetPanelInputHandler( panel, BUTTON_Y, ReadyShortcut_OnActivate )
	SetPanelInputHandler( panel, BUTTON_X, SeasonShortcut_OnActivate )

	file.fillButton = Hud_GetChild( panel, "FillButton" )
	Hud_AddEventHandler( file.fillButton, UIE_CLICK, FillButton_OnActivate )

	file.modeButton = Hud_GetChild( panel, "ModeButton" )
	Hud_AddEventHandler( file.modeButton, UIE_CLICK, ModeButton_OnActivate )

	file.gamemodeSelectV2Button = Hud_GetChild( panel, "GamemodeSelectV2Button" )
	Hud_AddEventHandler( file.gamemodeSelectV2Button, UIE_CLICK, GameModeSelectV2Button_OnActivate )
	Hud_AddEventHandler( file.gamemodeSelectV2Button, UIE_GET_FOCUS, GameModeSelectV2Button_OnGetFocus )
	Hud_AddEventHandler( file.gamemodeSelectV2Button, UIE_LOSE_FOCUS, GameModeSelectV2Button_OnLoseFocus )
	Hud_SetVisible( file.gamemodeSelectV2Button, false )

	file.gamemodeSelectV3Button = Hud_GetChild( panel, "GamemodeSelectV3Button" )
	Hud_AddEventHandler( file.gamemodeSelectV3Button, UIE_CLICK, GameModeSelectV3Button_OnActivate )
	Hud_AddEventHandler( file.gamemodeSelectV3Button, UIE_GET_FOCUS, GameModeSelectV3Button_OnGetFocus )
	Hud_AddEventHandler( file.gamemodeSelectV3Button, UIE_LOSE_FOCUS, GameModeSelectV3Button_OnLoseFocus )
	Hud_SetVisible( file.gamemodeSelectV3Button, false )

	file.readyButton = Hud_GetChild( panel, "ReadyButton" )
	Hud_AddEventHandler( file.readyButton, UIE_CLICK, ReadyButton_OnActivate )

	file.inviteFriendsButton0 = Hud_GetChild( panel, "InviteFriendsButton0" )
	Hud_AddEventHandler( file.inviteFriendsButton0, UIE_CLICK, InviteFriendsButton_OnActivate )

	file.inviteFriendsButton1 = Hud_GetChild( panel, "InviteFriendsButton1" )
	Hud_AddEventHandler( file.inviteFriendsButton1, UIE_CLICK, InviteFriendsButton_OnActivate )

	file.inviteLastPlayedHeader = Hud_GetChild( panel, "InviteLastSquadHeader" )
	Hud_Hide( file.inviteLastPlayedHeader )

	file.inviteLastPlayedUnitFrame0 = Hud_GetChild( panel, "InviteLastPlayedUnitframe0" )
	Hud_AddEventHandler( file.inviteLastPlayedUnitFrame0, UIE_CLICK, InviteLastPlayedButton_OnActivate )
	//
	Hud_AddKeyPressHandler( file.inviteLastPlayedUnitFrame0, InviteLastPlayedButton_OnKeyPress )
	Hud_AddEventHandler( file.inviteLastPlayedUnitFrame0, UIE_CLICKRIGHT, InviteLastPlayedButton_OnRightClick )
	Hud_Hide( file.inviteLastPlayedUnitFrame0 )

	file.inviteLastPlayedUnitFrame1 = Hud_GetChild( panel, "InviteLastPlayedUnitframe1" )
	Hud_AddEventHandler( file.inviteLastPlayedUnitFrame1, UIE_CLICK, InviteLastPlayedButton_OnActivate )
	//
	Hud_AddKeyPressHandler( file.inviteLastPlayedUnitFrame1, InviteLastPlayedButton_OnKeyPress )
	Hud_AddEventHandler( file.inviteLastPlayedUnitFrame1, UIE_CLICKRIGHT, InviteLastPlayedButton_OnRightClick )
	Hud_Hide( file.inviteLastPlayedUnitFrame1 )

	file.selfButton = Hud_GetChild( panel, "SelfButton" )
	Hud_AddEventHandler( file.selfButton, UIE_CLICK, FriendButton_OnActivate )

	file.friendButton0 = Hud_GetChild( panel, "FriendButton0" )
	Hud_AddEventHandler( file.friendButton0, UIE_CLICK, FriendButton_OnActivate )
	Hud_AddEventHandler( file.friendButton0, UIE_CLICKRIGHT, FriendButton_OnRightClick )

	file.friendButton1 = Hud_GetChild( panel, "FriendButton1" )
	Hud_AddEventHandler( file.friendButton1, UIE_CLICK, FriendButton_OnActivate )
	Hud_AddEventHandler( file.friendButton1, UIE_CLICKRIGHT, FriendButton_OnRightClick )

	file.allChallengesButton = Hud_GetChild( panel, "AllChallengesButton" )
	Hud_SetVisible( file.allChallengesButton, true )
	Hud_SetEnabled( file.allChallengesButton, true )

	var nextBPRewardButton = Hud_GetChild( panel, "ChallengesNextBPReward" )
	Hud_AddEventHandler( nextBPRewardButton, UIE_CLICK, ChallengeInspectNextReward )

	HudElem_SetRuiArg( file.allChallengesButton, "buttonText", Localize( "#CHALLENGES_LOBBY_BUTTON_SHORT" ) )
	Hud_AddEventHandler( file.allChallengesButton, UIE_CLICK, AllChallengesButton_OnActivate )

	file.eventPrizeTrackButton = Hud_GetChild( panel, "EventPrizeTrackButton" )
	Hud_SetVisible( file.eventPrizeTrackButton, true )
	Hud_SetEnabled( file.eventPrizeTrackButton, true )

	Hud_AddEventHandler( Hud_GetChild( file.panel, "PopupMessage" ), UIE_CLICK, OnClickCallToActionPopup )

	file.challengeCategorySelection = Hud_GetChild( file.panel, "ChallengeCatergorySelection" )
	Hud_AddEventHandler( Hud_GetChild( file.panel, "ChallengeCatergoryLeftButton" ), UIE_CLICK, ChallengeSwitchLeft_OnClick )
	Hud_AddEventHandler( Hud_GetChild( file.panel, "ChallengeCatergoryRightButton" ), UIE_CLICK, ChallengeSwitchRight_OnClick )

	Hud_AddEventHandler( Hud_GetChild( file.panel, "ChallengeCatergoryLeftButton" ), UIE_GET_FOCUS, ChallengeSwitch_GetFocus )
	Hud_AddEventHandler( Hud_GetChild( file.panel, "ChallengeCatergoryRightButton" ), UIE_GET_FOCUS, ChallengeSwitch_GetFocus )
	Hud_AddEventHandler( Hud_GetChild( file.panel, "ChallengeCatergorySelection" ), UIE_GET_FOCUS, ChallengeSwitch_GetFocus )

	Hud_AddEventHandler( Hud_GetChild( file.panel, "ChallengeCatergoryLeftButton" ), UIE_LOSE_FOCUS, ChallengeSwitch_LoseFocus )
	Hud_AddEventHandler( Hud_GetChild( file.panel, "ChallengeCatergoryRightButton" ), UIE_LOSE_FOCUS, ChallengeSwitch_LoseFocus )
	Hud_AddEventHandler( Hud_GetChild( file.panel, "ChallengeCatergorySelection" ), UIE_LOSE_FOCUS, ChallengeSwitch_LoseFocus )

	AddMenuVarChangeHandler( "isMatchmaking", UpdateLobbyButtons )

	file.chatBox = Hud_GetChild( panel, "ChatRoomTextChat" )
	file.hdTextureProgress = Hud_GetChild( panel, "HDTextureProgress" )

	//
	//
	var chatTextEntry = Hud_GetChild( Hud_GetChild( file.chatBox, "ChatInputLine" ), "ChatInputTextEntry" )
	Hud_SetNavUp( chatTextEntry, chatTextEntry )

	InitMiniPromo( Hud_GetChild( panel, "MiniPromo" ) )

	RegisterSignal( "UpdateFriendButtons" )
	RegisterSignal( "CallToActionPopupThink" )
	RegisterSignal( "Lobby_ShowCallToActionPopup" )

	RegisterSignal( "CallToActionPopupAudioThink" )
	RegisterSignal( "CallToActionPopupAudioCancel" )

	var aboutButton = Hud_GetChild( file.panel, "AboutButton" )
	Hud_AddEventHandler( aboutButton, UIE_CLICK, OpenAboutGameModePage )

	var rankedBadge = Hud_GetChild( file.panel, "RankedBadge" )
	Hud_AddEventHandler( rankedBadge, UIE_CLICK, OpenRankedInfoPage )
	AddUICallback_OnLevelInit( Ranked_OnLevelInit )
	AddCallback_OnPartyMemberAdded( TryShowMatchmakingDelayDialog )
	AddCallback_OnPartyMemberRemoved( UpdateCurrentMaxMatchmakingDelayEndTime )

                        
                                                                  
                                                
       
}


void function PlayPanel_LevelInit()
{
	ResetFillButton()
}


bool function IsPlayPanelCurrentlyTopLevel()
{
	return GetActiveMenu() == GetMenu( "LobbyMenu" ) && IsPanelActive( file.panel )
}


void function UpdateLastPlayedPlayerInfo()
{
	string oldUid0 = file.lastPlayedPlayerPlatformUid0
	string oldUid1 = file.lastPlayedPlayerPlatformUid1

	array<string> curPartyMemberUids
	file.lastPlayedPlayerPlatformUid0 = ""
	file.lastPlayedPlayerNucleusID0 = ""
	file.lastPlayedPlayerHardwareID0 = -1
	file.lastPlayedPlayerPersistenceIndex0 = -1

	file.lastPlayedPlayerPlatformUid1 = ""
	file.lastPlayedPlayerNucleusID1 = ""
	file.lastPlayedPlayerHardwareID1 = -1
	file.lastPlayedPlayerPersistenceIndex1 = -1

	if ( !IsPersistenceAvailable() || !InviteLastPlayedPanelShouldBeVisible() )
	{
		return
	}

	int maxTrackedSquadMembers = PersistenceGetArrayCount( "lastGameSquadStats" )
	foreach ( index, member in GetParty().members )
	{
		curPartyMemberUids.append( member.uid )
	}

	for ( int i = 0; i < maxTrackedSquadMembers; i++ )
	{
		string lastPlayedPlayerUid     = expect string( GetPersistentVar( "lastGameSquadStats[" + i + "].platformUid" ) )
		string lastPlayedNucleusID     = expect string( GetPersistentVar( "lastGameSquadStats[" + i + "].nucleusId" ) )
		int lastPlayedPlayerHardwareID = expect int( GetPersistentVar( "lastGameSquadStats[" + i + "].hardwareID" ) )

		if ( lastPlayedPlayerUid == "" || lastPlayedPlayerHardwareID < 0 ) //
		{
			continue
		}

		if ( !curPartyMemberUids.contains( lastPlayedPlayerUid ) )
		{
			if ( file.lastPlayedPlayerPlatformUid0 == "" )
			{
				file.lastPlayedPlayerPlatformUid0 = lastPlayedPlayerUid
				file.lastPlayedPlayerNucleusID0 = lastPlayedNucleusID
				file.lastPlayedPlayerHardwareID0 = lastPlayedPlayerHardwareID
				file.lastPlayedPlayerPersistenceIndex0 = i
			}
			else if ( file.lastPlayedPlayerPlatformUid1 == "" && lastPlayedPlayerUid != file.lastPlayedPlayerPlatformUid0 )
			{
				file.lastPlayedPlayerPlatformUid1 = lastPlayedPlayerUid
				file.lastPlayedPlayerNucleusID1 = lastPlayedNucleusID
				file.lastPlayedPlayerHardwareID1 = lastPlayedPlayerHardwareID
				file.lastPlayedPlayerPersistenceIndex1 = i
			}
		}
	}

	if ( file.lastPlayedPlayerPlatformUid0 == oldUid1 )
	{
		file.lastPlayedPlayerInviteSentTimestamp0 = file.lastPlayedPlayerInviteSentTimestamp1
	}

	if ( file.lastPlayedPlayerPlatformUid1 == oldUid0 )
	{
		file.lastPlayedPlayerInviteSentTimestamp1 = file.lastPlayedPlayerInviteSentTimestamp0
	}
}


bool function InviteLastPlayedPanelShouldBeVisible()
{
	if ( GetUnixTimestamp() - GetPersistentVarAsInt( "lastGameTime" ) > INVITE_LAST_PANEL_EXPIRATION )
		return false

	if ( GetPersistentVarAsInt( "lastGamePlayers" ) == 0 && GetPersistentVarAsInt( "lastGameSquads" ) == 0 )
		return false

	return true
}


bool function LastPlayedPlayerIsInMatch( string playerPlatformUid, int playerHardwareID )
{
	string hardware                         = GetNameFromeHardware( playerHardwareID )
	CommunityUserInfo ornull userInfoOrNull = GetUserInfo( hardware, playerPlatformUid )
	if ( userInfoOrNull != null )
	{
		CommunityUserInfo userInfo = expect CommunityUserInfo(userInfoOrNull)
		return userInfo.charData[ePlayerStryderCharDataArraySlots.PLAYER_IN_MATCH] == 1
	}
	return false
}


void function WatchForLTMModeExpiring( string plName )
{
	RegisterSignal( "WatchForLTMModeExpiring" )

	thread function() : (plName)
	{
		Signal( uiGlobal.signalDummy, "WatchForLTMModeExpiring" )
		EndSignal( uiGlobal.signalDummy, "WatchForLTMModeExpiring" )
		EndSignal( uiGlobal.signalDummy, "LevelShutdown" )
		EndSignal( uiGlobal.signalDummy, "CleanupInGameMenus" )

		PlaylistScheduleData scheduleData = Playlist_GetScheduleData( plName )
		if ( scheduleData.currentBlock == null )
			return //

		WaitForUnixTime( (expect TimestampRange(scheduleData.currentBlock)).endUnixTime )

		printf( "%s() - Playlist '%s' has expired, so refreshing all.", FUNC_NAME(), plName )
		if ( AreWeMatchmaking() )
		{
			CancelMatchmaking()
			Remote_ServerCallFunction( "ClientCallback_CancelMatchSearch" )
			EmitUISound( SOUND_STOP_MATCHMAKING_1P )
			while( AreWeMatchmaking() )
				WaitFrame()
		}
		Lobby_UpdatePlayPanelPlaylists()
		UpdateLobbyButtons()
	}()
}


var function GetModeSelectButton()
{
	return file.modeButton
}


var function GetLobbyChatBox()
{
	return file.chatBox
}


void function PlayPanel_OnShow( var panel )
{
	//

	if ( IsFullyConnected() )
	{
		AccessibilityHint( eAccessibilityHint.LOBBY_CHAT )
		Lobby_UpdatePlayPanelPlaylists()
	}

	UpdateLobbyButtons()

	if ( file.chatroomMenu )
	{
		Hud_Hide( file.chatroomMenu )
		Hud_Hide( file.chatroomMenu_chatroomWidget )
	}
	AddCallbackAndCallNow_OnGRXInventoryStateChanged( UpdatePlayPanelGRXDependantElements )
	AddCallbackAndCallNow_OnGRXInventoryStateChanged( UpdateFriendButtons )
	AddCallbackAndCallNow_OnGRXInventoryStateChanged( UpdateSeasonTab )
	AddCallbackAndCallNow_OnGRXOffersRefreshed( UpdateSeasonTab )
	AddCallbackAndCallNow_RemoteMatchInfoUpdated( OnRemoteMatchInfoUpdated )

	Remote_ServerCallFunction( "ClientCallback_ViewingMainLobbyPage" )

	MiniPromo_Start()

                        
                              
                                                           
      
                                                   
      
		UI_SetPresentationType( ePresentationType.PLAY )
       

	bool v2PlaylistSelect = GamemodeSelectV2_IsEnabled()
	bool v3PlaylistSelect = GamemodeSelectV3_IsEnabled()

	if ( v3PlaylistSelect )
	{
		Hud_SetNavUp( file.readyButton, file.gamemodeSelectV3Button )
	}
	else if ( v2PlaylistSelect )
	{
		Hud_SetNavUp( file.readyButton, file.gamemodeSelectV2Button )
	}
	else
	{
		Hud_SetNavUp( file.readyButton, file.modeButton )
	}

	KeepUnixTimeDebugDisplayUpdated()

	thread TryRunDialogFlowThread()
	thread Lobby_ShowCallToActionPopup()

	AddCallbackAndCallNow_UserInfoUpdated( Ranked_OnUserInfoUpdatedInPanelPlay )

	Lobby_SetTempSeasonExtensionButtonVisible( true )

	file.nextAllowFriendsUpdateTime = Time()

	bool LTMisTakeover = GetPlaylistVarBool( Lobby_GetSelectedPlaylist(), "show_ltm_about_button_is_takeover", false )
	var aboutButton         = Hud_GetChild( file.panel, "AboutButton" )
	Hud_ClearToolTipData( aboutButton )
	if ( LTMisTakeover )
	{
		string takeoverAbout = GetPlaylistVarString( Lobby_GetSelectedPlaylist(), "survival_takeover_about", "" )
		if ( takeoverAbout != "" )
		{
			ToolTipData td
			td.titleText = GetPlaylistVarString( Lobby_GetSelectedPlaylist(), "survival_takeover_title", "#PL_PLAY_APEX" )
			td.descText = takeoverAbout
			Hud_SetToolTipData( aboutButton, td )
		}
	}
}


void function UpdateLobbyButtons()
{
	if ( !IsConnected() )
		return

                        
                    
       

	UpdateFillButton()
	UpdateReadyButton()
	UpdateModeButton()
	UpdateFriendButtons()
	UpdateLastPlayedButtons()
	UpdateLowerLeftButtonPositions()
	UpdateFooterOptions()

	#if(NX_PROG)
		bool NewAoCAvailable = GetConVarBool( "NewAoCDownloadComplete" )
		if ( NewAoCAvailable )
		{
			OpenDownloadAoCNoticeDialog( false )
		}
	#endif
}

                       
                                
 
                      
        

                         

                                                                                                                                                                   

                                          
  
                                                                 
                    
   
                                                                  
                                                                                                
                                                                 
   
      
   
                                                
                                                         
   

                                   
                            

              
                             
                            
       
                           
        
  
 
      

string function GetDebugTimeString()
{
	int utTime        = GetUnixTimePDT()
	string timeString = GetDateTimeString( utTime, 0 )
	string dayName    = GetDayOfWeekName( GetDayOfWeek( utTime ) )
	return format( "%s, %s PDT", Localize( dayName ), timeString )
}


void function KeepUnixTimeDebugDisplayUpdated()
{
	RegisterSignal( "KeepFakeDaysDebugDisplayUpdated" )

	thread function() : ()
	{
		Signal( uiGlobal.signalDummy, "KeepFakeDaysDebugDisplayUpdated" )
		EndSignal( uiGlobal.signalDummy, "KeepFakeDaysDebugDisplayUpdated" )
		EndSignal( uiGlobal.signalDummy, "LevelShutdown" )
		EndSignal( uiGlobal.signalDummy, "CleanupInGameMenus" )

		var textLabel = Hud_GetChild( file.panel, "LobbyDebugText" )

		int devLevelPrev = -99
		for ( ; ; )
		{
			WaitFrame()
			int devLevel = GetDeveloperLevel()
			if ( (devLevel == 0) && (devLevel == devLevelPrev) )
				continue

			string str = ((devLevel == 0) ? "" : GetDebugTimeString())
			Hud_SetText( textLabel, str )
			devLevelPrev = devLevel
		}
	}()
}


void function UpdateHDTextureProgress()
{
	//
	HudElem_SetRuiArg( file.hdTextureProgress, "hdTextureProgress", GetGameFullyInstalledProgress() )
	HudElem_SetRuiArg( file.hdTextureProgress, "hdTextureNeedsReboot", HasNonFullyInstalledAssetsLoaded() )

	if ( ShowDownloadCompleteDialog() )
	{
		ConfirmDialogData data
		data.headerText = "#TEXTURE_STREAM_REBOOT_HEADER"
		data.messageText = "#TEXTURE_STREAM_REBOOT_MESSAGE"
		data.yesText = ["#TEXTURE_STREAM_REBOOT", "#TEXTURE_STREAM_REBOOT_PC"]
		data.noText = ["#B_BUTTON_CANCEL", "#CANCEL"]

		data.resultCallback = void function ( int result ) : ()
		{
			if ( result == eDialogResult.YES )
			{
				//
				ClientCommand( "disconnect" )
			}

			return
		}

		OpenConfirmDialogFromData( data )
		file.fullInstallNotification = true
	}
}


void function UpdateLastSquadDpadNav()
{
	var buttonBeneathLastSquadPanel = file.modeButton

	if ( Hud_IsVisible( file.gamemodeSelectV3Button ) )
	{
		buttonBeneathLastSquadPanel = file.gamemodeSelectV3Button
	}

	if ( Hud_IsVisible( file.gamemodeSelectV2Button ) )
	{
		buttonBeneathLastSquadPanel = file.gamemodeSelectV2Button
	}

	if ( Hud_IsVisible( file.fillButton ) )
	{
		buttonBeneathLastSquadPanel = file.fillButton
	}

	bool isVisibleButton0 = Hud_IsVisible( file.inviteLastPlayedUnitFrame0 )
	bool isVisibleButton1 = Hud_IsVisible( file.inviteLastPlayedUnitFrame1 )

	if ( isVisibleButton0 )
	{
		Hud_SetNavDown( file.inviteLastPlayedUnitFrame0, buttonBeneathLastSquadPanel )
		Hud_SetNavUp( buttonBeneathLastSquadPanel, file.inviteLastPlayedUnitFrame0 )
		Hud_SetNavLeft( file.inviteFriendsButton0, file.inviteLastPlayedUnitFrame0 )
		Hud_SetNavRight( file.inviteLastPlayedUnitFrame0, file.inviteFriendsButton0 )

		if ( isVisibleButton1 )
		{
			Hud_SetNavDown( file.inviteLastPlayedUnitFrame1, buttonBeneathLastSquadPanel )
			Hud_SetNavUp( buttonBeneathLastSquadPanel, file.inviteLastPlayedUnitFrame1 )

			Hud_SetNavDown( file.inviteLastPlayedUnitFrame0, file.inviteLastPlayedUnitFrame1 )
		}
	}
	else
	{
		Hud_SetNavUp( buttonBeneathLastSquadPanel, file.inviteFriendsButton0 )
		Hud_SetNavDown( file.inviteFriendsButton0, buttonBeneathLastSquadPanel )
		Hud_SetNavLeft( file.inviteFriendsButton0, buttonBeneathLastSquadPanel )
		Hud_SetNavRight( buttonBeneathLastSquadPanel, file.inviteFriendsButton0 )
	}
}


bool function ShowDownloadCompleteDialog()
{
	if ( GetGameFullyInstalledProgress() != 1 )
		return false

	if ( !HasNonFullyInstalledAssetsLoaded() )
		return false

	if ( file.fullInstallNotification )
		return false

	if ( GetActiveMenu() != GetMenu( "LobbyMenu" ) )
		return false

	if ( GetPersistentVar( "showGameSummary" ) && IsPostGameMenuValid( true ) )
		return false

	return true
}


array<string> function Lobby_GetPlaylistMods()
{
	return file.playlistMods
}


array<string> function Lobby_GetPlaylists()
{
	return file.playlists
}


string function Lobby_GetSelectedPlaylist()
{
	bool isLeader       = IsPartyLeader()
	string playlistName = isLeader ? file.selectedPlaylist : GetParty().playlistName
	return playlistName
}


string function Lobby_GetLastSelectedPlaylist()
{
	return file.lastPlaylistDisplayed
}


bool function Lobby_IsPlaylistAvailable( string playlistName )
{
	return Lobby_GetPlaylistState( playlistName ) == ePlaylistState.AVAILABLE
}


void function Lobby_SetSelectedPlaylistMods( string playlistModNames )
{
	printt( "Lobby_SetSelectedPlaylistMods " + playlistModNames )
	file.selectedPlaylistMods = playlistModNames
	UpdateLobbyButtons()
	Lobby_UpdateLoadscreenFromPlaylist()

	if ( file.selectedPlaylist.len() > 0 )
		SetMatchmakingPlaylist( file.selectedPlaylist + playlistModNames )
}


int function Lobby_GetSelectedPlaylistExpectedSquadSize()
{
	string selectedPlaylist = Lobby_GetSelectedPlaylist()
	return int ( GetPlaylistVarFloat( selectedPlaylist, "max_players", 60 ) / GetPlaylistVarFloat( selectedPlaylist, "max_teams", 20 ) )
}


void function Lobby_SetSelectedPlaylist( string playlistName )
{
	printt( "Lobby_SetSelectedPlaylist " + playlistName )
	file.selectedPlaylist = playlistName
	UpdateLobbyButtons()
	Lobby_UpdateLoadscreenFromPlaylist()

	if ( playlistName.len() > 0 )
		SetMatchmakingPlaylist( playlistName + file.selectedPlaylistMods )

	WatchForLTMModeExpiring( playlistName )
}


void function Lobby_ClearSelectedPlaylist()
{
	file.selectedPlaylist = ""
}


void function Lobby_UpdateLoadscreenFromPlaylist()
{
	if ( GetPlaylistVarBool( Lobby_GetSelectedPlaylist(), "force_level_loadscreen", false ) )
	{
		SetCustomLoadScreen( $"" )
	}
	else
	{
		thread Loadscreen_SetEquppedLoadscreenAsActive()
	}
}


void function PlayPanel_OnHide( var panel )
{
	Signal( uiGlobal.signalDummy, "UpdateFriendButtons" )
	Hud_ClearToolTipData( file.modeButton )

	RemoveCallback_OnGRXInventoryStateChanged( UpdatePlayPanelGRXDependantElements )
	RemoveCallback_OnGRXInventoryStateChanged( UpdateFriendButtons )
	RemoveCallback_OnGRXInventoryStateChanged( UpdateSeasonTab )
	RemoveCallback_OnGRXOffersRefreshed( UpdateSeasonTab )
	RemoveCallback_RemoteMatchInfoUpdated( OnRemoteMatchInfoUpdated )

	//

	MiniPromo_Stop()
	file.rankedRUIToUpdate = null
	RemoveCallback_UserInfoUpdated( Ranked_OnUserInfoUpdatedInPanelPlay )

	UpdateSeasonTab()

	Lobby_SetTempSeasonExtensionButtonVisible( false )
}


void function UpdateFriendButton( var rui, PartyMember info, bool inMatch )
{
	Party party = GetParty()

	string playerName = ""
	if ( info.clubTag != "" )
	{
		playerName = "[" + info.clubTag + "]" + info.name
	}
	else
	{
		playerName = info.name
	}
	//

	RuiSetString( rui, "playerName", playerName )
	RuiSetBool( rui, "isLeader", party.originatorUID == info.uid && GetPartySize() > 1 )
	RuiSetBool( rui, "isReady", info.ready )
	RuiSetBool( rui, "inMatch", inMatch )
	if ( inMatch )
	{
		RuiSetString( rui, "footerText", "#PROMPT_IN_MATCH" )
	}
	else
	{
		RuiSetString( rui, "footerText", "" )
	}

	thread KeepMicIconUpdated( info, rui )

	int rankScore      = 0 //
	int ladderPosition = RANKED_INVALID_LADDER_POSITION

	CommunityUserInfo ornull userInfo = GetUserInfo( info.hardware, info.uid )
	if ( userInfo == null )
	{
		if ( info.uid in file.s_cachedAccountXPFrac )
			RuiSetFloat( rui, "accountXPFrac", file.s_cachedAccountXPFrac[info.uid] )
		else
			RuiSetFloat( rui, "accountXPFrac", 0 )
		//

		int accountLevel = 0
		if ( info.uid == GetPlayerUID() && IsPersistenceAvailable() )
			accountLevel = GetAccountLevelForXP( GetPersistentVarAsInt( "xp" ) )

		//
		//
		var nestedAccountBadge = CreateNestedAccountDisplayBadge( rui, "accountBadgeHandle", accountLevel )

		if ( info.uid == GetPlayerUID() && IsPersistenceAvailable() )
			rankScore = GetPlayerRankScore( GetUIPlayer() )
	}
	else
	{
		expect CommunityUserInfo( userInfo )

		float accountXPFrac = userInfo.charData[ePlayerStryderCharDataArraySlots.ACCOUNT_PROGRESS_INT] / 100.0

		file.s_cachedAccountXPFrac[info.uid] <- accountXPFrac
		RuiSetFloat( rui, "accountXPFrac", accountXPFrac )

		//
		//
		var accountBadge = CreateNestedAccountDisplayBadge( rui, "accountBadgeHandle", userInfo.charData[ePlayerStryderCharDataArraySlots.ACCOUNT_LEVEL] )

		rankScore = userInfo.rankScore
		ladderPosition = userInfo.rankedLadderPos

		string platformString = CrossplayUserOptIn() ? PlatformIDToIconString( GetHardwareFromName( info.hardware ) ) : ""
		RuiSetString( rui, "platformString", platformString )
	}


	bool isRanked = IsRankedPlaylist( Lobby_GetSelectedPlaylist() )
	RuiSetBool( rui, "showRanked", isRanked )
	PopulateRuiWithRankedBadgeDetails( rui, rankScore, ladderPosition )
	if ( isRanked )
	{
		float frac = 0.0

		RankedDivisionData currentRank     = GetCurrentRankedDivisionFromScoreAndLadderPosition( rankScore, ladderPosition )
		RankedDivisionData ornull nextRank = GetNextRankedDivisionFromScore( rankScore )

		if ( nextRank == null )
		{
			frac = 1.0
		}
		else
		{
			expect RankedDivisionData( nextRank )
			if ( nextRank != currentRank )
			{
				frac = GraphCapped( float( rankScore ), currentRank.scoreMin, nextRank.scoreMin, 0.0, 1.0 )
			}
		}

		RuiSetFloat( rui, "accountXPFrac", frac )
	}
}


void function KeepMicIconUpdated( PartyMember info, var rui )
{
	EndSignal( uiGlobal.signalDummy, "UpdateFriendButtons" )

	while ( 1 )
	{
		RuiSetInt( rui, "micStatus", GetChatroomMicStatus( info.uid, info.hardware ) )
		WaitFrame()
	}
}


void function UpdateSeasonTab()
{
	bool ready = GRX_IsInventoryReady() && GRX_AreOffersReady()

	TabData lobbyTabData = GetTabDataForPanel( GetMenu( "LobbyMenu" ) )
	TabDef seasonTabDef  = Tab_GetTabDefByBodyName( lobbyTabData, "SeasonPanel" )

	if ( ready && IsTabPanelActive( GetPanel( "PlayPanel" ) ) && IsFullyConnected() )
	{
		HudElem_SetRuiArg( seasonTabDef.button, "callToActionText", "#SEASON_TAB_HINT" )
	}
	else
	{
		HudElem_SetRuiArg( seasonTabDef.button, "callToActionText", "" )
	}
}


void function UpdateFriendButtons()
{
	Signal( uiGlobal.signalDummy, "UpdateFriendButtons" )

	Hud_SetVisible( file.inviteFriendsButton0, !file.personInLeftSpot )
	Hud_SetVisible( file.inviteFriendsButton1, !file.personInRightSlot )

	Hud_SetVisible( file.friendButton0, false )
	Hud_SetVisible( file.friendButton1, false )

	if ( file.nextAllowFriendsUpdateTime < Time() )
	{
		int count = GetInGameFriendCount( true )
		RuiSetInt( Hud_GetRui( file.inviteFriendsButton0 ), "onlineFriendCount", count )
		RuiSetInt( Hud_GetRui( file.inviteFriendsButton1 ), "onlineFriendCount", count )
		file.nextAllowFriendsUpdateTime = Time() + 5.0
	}

	Party party = GetParty()
	foreach ( PartyMember partyMember in party.members )
	{
		if ( partyMember.uid == GetPlayerUID() )
		{
			ToolTipData toolTipData
			toolTipData.tooltipStyle = eTooltipStyle.BUTTON_PROMPT
			toolTipData.actionHint1 = "#A_BUTTON_INSPECT"
			Hud_SetToolTipData( file.selfButton, toolTipData )

			var friendRui = Hud_GetRui( file.selfButton )

			RuiSetBool( friendRui, "canViewStats", true )

			UpdateFriendButton( friendRui, partyMember, false )
		}
		else if ( partyMember.uid == file.friendInLeftSpot.id )
		{
			ToolTipData toolTipData
			toolTipData.tooltipStyle = eTooltipStyle.BUTTON_PROMPT
			toolTipData.actionHint1 = "#A_BUTTON_INSPECT"
			toolTipData.actionHint2 = IsPlayerVoiceMutedForUID( partyMember.uid, partyMember.hardware ) ? "#X_BUTTON_UNMUTE" : "#X_BUTTON_MUTE"
			Hud_SetToolTipData( file.friendButton0, toolTipData )

			var friendRui = Hud_GetRui( file.friendButton0 )
			UpdateFriendButton( friendRui, partyMember, file.friendInLeftSpot.ingame )
			Hud_SetVisible( file.friendButton0, true )
			if ( file.leftWasReady != partyMember.ready )
				EmitUISound( partyMember.ready ? SOUND_START_MATCHMAKING_3P : SOUND_STOP_MATCHMAKING_3P )

			file.leftWasReady = partyMember.ready
		}
		else if ( partyMember.uid == file.friendInRightSpot.id )
		{
			ToolTipData toolTipData
			toolTipData.tooltipStyle = eTooltipStyle.BUTTON_PROMPT
			toolTipData.actionHint1 = "#A_BUTTON_INSPECT"
			toolTipData.actionHint2 = IsPlayerVoiceMutedForUID( partyMember.uid, partyMember.hardware ) ? "#X_BUTTON_UNMUTE" : "#X_BUTTON_MUTE"
			Hud_SetToolTipData( file.friendButton1, toolTipData )

			var friendRui = Hud_GetRui( file.friendButton1 )
			UpdateFriendButton( friendRui, partyMember, file.friendInRightSpot.ingame )
			Hud_SetVisible( file.friendButton1, true )

			if ( file.rightWasReady != partyMember.ready )
				EmitUISound( partyMember.ready ? SOUND_START_MATCHMAKING_3P : SOUND_STOP_MATCHMAKING_3P )

			file.rightWasReady = partyMember.ready
		}
	}

	ToolTipData toolTipData
	toolTipData.titleText = "#INVITE"
	toolTipData.descText = "#INVITE_HINT"

	entity player = GetUIPlayer()
	if ( IsLocalClientEHIValid() && IsValid( player ) )
	{
		bool hasPremiumPass                = false
		ItemFlavor ornull activeBattlePass = GetPlayerActiveBattlePass( ToEHI( player ) )
		bool hasActiveBattlePass           = activeBattlePass != null
		if ( hasActiveBattlePass && GRX_IsInventoryReady() )
		{
			expect ItemFlavor( activeBattlePass )
			hasPremiumPass = DoesPlayerOwnBattlePass( player, activeBattlePass )
			if ( hasPremiumPass )
				toolTipData.descText = Localize( "#INVITE_HINT_BP" )
		}
	}

	#if(PC_PROG)
		if ( !PCPlat_IsOverlayAvailable() && !GetCurrentPlaylistVarBool( "social_menu_enabled", true ) )
		{
			string platname = PCPlat_IsOrigin() ? "ORIGIN" : "STEAM"
			toolTipData.descText = "#" + platname + "_INGAME_REQUIRED"
			Hud_SetLocked( file.inviteFriendsButton0, true )
			Hud_SetLocked( file.inviteFriendsButton1, true )
		}
	#endif //

	Hud_SetToolTipData( file.inviteFriendsButton0, toolTipData )
	Hud_SetToolTipData( file.inviteFriendsButton1, toolTipData )
}


void function UpdateLowerLeftButtonPositions()
{
	bool v3PlaylistSelect = GamemodeSelectV3_IsEnabled()
	bool v2PlaylistSelect = GamemodeSelectV2_IsEnabled()

	bool showLTMAboutButton = GetPlaylistVarBool( Lobby_GetSelectedPlaylist(), "show_ltm_about_button", false )
	var aboutButton         = Hud_GetChild( file.panel, "AboutButton" )
	Hud_SetVisible( aboutButton, false )

	bool shouldShowRankedBadge = IsRankedPlaylist( Lobby_GetSelectedPlaylist() )

	var rankedBadge = Hud_GetChild( file.panel, "RankedBadge" )
	Hud_SetVisible( rankedBadge, false )

	Hud_SetY( file.fillButton, 16 )

                        
                           
                                                   
                                                 
       

	if ( v3PlaylistSelect )
	{
		Hud_SetPinSibling( rankedBadge, Hud_GetHudName( file.gamemodeSelectV3Button ) )
		Hud_SetPinSibling( aboutButton, Hud_GetHudName( file.gamemodeSelectV3Button ) )
		Hud_SetPinSibling( file.fillButton, Hud_GetHudName( file.gamemodeSelectV3Button ) )

		Hud_SetNavUp( file.gamemodeSelectV3Button, file.inviteFriendsButton0 )

		Hud_SetNavDown( rankedBadge, file.gamemodeSelectV3Button )
		Hud_SetNavDown( aboutButton, file.gamemodeSelectV3Button )
		Hud_SetNavDown( file.fillButton, file.gamemodeSelectV3Button )
	}
	else if ( v2PlaylistSelect )
	{
		Hud_SetPinSibling( rankedBadge, Hud_GetHudName( file.gamemodeSelectV2Button ) )
		Hud_SetPinSibling( aboutButton, Hud_GetHudName( file.gamemodeSelectV2Button ) )
		Hud_SetPinSibling( file.fillButton, Hud_GetHudName( file.gamemodeSelectV2Button ) )

		Hud_SetNavUp( file.gamemodeSelectV2Button, file.inviteFriendsButton0 )

		Hud_SetNavDown( rankedBadge, file.gamemodeSelectV2Button )
		Hud_SetNavDown( aboutButton, file.gamemodeSelectV2Button )
		Hud_SetNavDown( file.fillButton, file.gamemodeSelectV2Button )
	}
	else
	{
		Hud_SetPinSibling( rankedBadge, Hud_GetHudName( file.modeButton ) )
		Hud_SetPinSibling( aboutButton, Hud_GetHudName( file.modeButton ) )
		Hud_SetPinSibling( file.fillButton, Hud_GetHudName( file.modeButton ) )

		Hud_SetNavDown( rankedBadge, file.modeButton )
		Hud_SetNavDown( aboutButton, file.modeButton )
		Hud_SetNavDown( file.fillButton, file.modeButton )
	}

	var msgLabel = Hud_GetChild( file.panel, "PlaylistNotificationMessage" )
	Hud_SetVisible( msgLabel, false )

	if ( v3PlaylistSelect )
	{
		Hud_SetPinSibling( msgLabel, Hud_GetHudName( file.gamemodeSelectV3Button ) )
	}
	else if ( v2PlaylistSelect )
	{
		Hud_SetPinSibling( msgLabel, Hud_GetHudName( file.gamemodeSelectV2Button ) )
	}
	else
	{
		Hud_SetPinSibling( msgLabel, Hud_GetHudName( file.modeButton ) )
	}

	if ( shouldShowRankedBadge )
	{
		Hud_SetVisible( rankedBadge, shouldShowRankedBadge )

		if ( v3PlaylistSelect )
		{
			Hud_SetNavUp( file.gamemodeSelectV3Button, rankedBadge )
		}
		else if ( v2PlaylistSelect )
		{
			Hud_SetNavUp( file.gamemodeSelectV2Button, rankedBadge )
		}

		var rui = Hud_GetRui( rankedBadge )

		int score = GetPlayerRankScore( GetUIPlayer() )

		if ( score == RANKED_INVALID_RANK_SCORE ) //
			score = 0

		int ladderPosition = Ranked_GetLadderPosition( GetUIPlayer() )
		if ( Ranked_ShouldUpdateWithComnunityUserInfo( score, ladderPosition ) )
			file.rankedRUIToUpdate = rui

		RankedDivisionData data = GetCurrentRankedDivisionFromScoreAndLadderPosition( score, ladderPosition )
		RuiSetInt( rui, "score", score )
		RuiSetInt( rui, "scoreMax", 0 )
		RuiSetFloat( rui, "scoreFrac", 1.0 )
		RuiSetString( rui, "rankName", data.divisionName )
		PopulateRuiWithRankedBadgeDetails( rui, score, ladderPosition )
		RuiSetBool( rui, "inSeason", IsRankedInSeason() )

		if ( data.tier.index != file.lobbyRankTier )
		{
			RuiDestroyNestedIfAlive( rui, "rankedBadgeHandle" )
			CreateNestedRankedRui( rui, data.tier, "rankedBadgeHandle", score, ladderPosition )
			file.lobbyRankTier = data.tier.index
		}

		ToolTipData tooltip
		tooltip.titleText = data.divisionName

		RankedDivisionData ornull nextData = GetNextRankedDivisionFromScore( score )

		if ( nextData != null )
		{
			expect RankedDivisionData( nextData )
			tooltip.descText = Localize( "#RANKED_TOOLTIP_NEXT", Localize( nextData.divisionName ).toupper(), (nextData.scoreMin - score) )

			RuiSetInt( rui, "scoreMax", nextData.scoreMin )
			RuiSetFloat( rui, "scoreFrac", float( score - data.scoreMin ) / float( nextData.scoreMin - data.scoreMin ) )
		}

		Hud_SetToolTipData( rankedBadge, tooltip )
		return
	}

	if ( showLTMAboutButton )
	{
		Hud_SetVisible( aboutButton, showLTMAboutButton )

		if ( v3PlaylistSelect )
		{
			Hud_SetNavUp( file.gamemodeSelectV3Button, aboutButton )
		}
		else if ( v2PlaylistSelect )
		{
			Hud_SetNavUp( file.gamemodeSelectV2Button, aboutButton )
		}

		if ( DoesPlaylistSupportNoFill( Lobby_GetSelectedPlaylist() ) )
			Hud_SetNavUp( aboutButton, file.fillButton )

		Hud_SetPinSibling( file.fillButton, Hud_GetHudName( aboutButton ) )
		Hud_SetY( file.fillButton, 10 )
		Hud_SetNavDown( file.fillButton, aboutButton )

		array<int> emblemColor = GetEmblemColor( GetSelectedPlaylist() )

		var rui = Hud_GetRui( aboutButton )

		bool LTMisTakeover = GetPlaylistVarBool( Lobby_GetSelectedPlaylist(), "show_ltm_about_button_is_takeover", false )
		var aboutButtonRui         = Hud_GetRui( Hud_GetChild( file.panel, "AboutButton" ) )
		if ( LTMisTakeover )
		{
			RuiSetBool( aboutButtonRui, "extendBorder", true )
			RuiSetString( aboutButtonRui, "buttonText", "#ABOUT_TAKEOVER" )
		}
		else
		{
			RuiSetBool( aboutButtonRui, "extendBorder", false )
			RuiSetString( aboutButtonRui, "buttonText", "#ABOUT_GAMEMODE" )
		}

		asset emblemImage = GetModeEmblemImage( GetSelectedPlaylist() )
		RuiSetImage( rui, "emblemImage", emblemImage )
		RuiSetColorAlpha( rui, "emblemColor", SrgbToLinear( <emblemColor[0], emblemColor[1], emblemColor[2]> / 255.0 ), emblemColor[3] / 255.0 )

		//
		//
		//
		//
		//
		//
		//

		return
	}


                        
                                                                                                                                                                                  
                 
   
                            
    
                                                  
                                                      
    
   
       
}


void function UpdateLastPlayedButtons()
{
	UpdateLastPlayedPlayerInfo()

	bool isVisibleButton0 = file.lastPlayedPlayerPlatformUid0 != "" &&
		!LastPlayedPlayerIsInMatch( file.lastPlayedPlayerPlatformUid0, file.lastPlayedPlayerHardwareID0 ) &&
		EADP_IsBlockedByEAID( file.lastPlayedPlayerNucleusID0 ) <= 0

	bool isVisibleButton1 = file.lastPlayedPlayerPlatformUid1 != "" &&
		!LastPlayedPlayerIsInMatch( file.lastPlayedPlayerPlatformUid1, file.lastPlayedPlayerHardwareID1 ) &&
		EADP_IsBlockedByEAID( file.lastPlayedPlayerNucleusID1 ) <= 0

	bool shouldUpdateDpadNav = false

	if ( isVisibleButton0 != Hud_IsVisible( file.inviteLastPlayedUnitFrame0 ) || isVisibleButton1 != Hud_IsVisible( file.inviteLastPlayedUnitFrame1 ) )
	{
		shouldUpdateDpadNav = true
	}

	isVisibleButton0 = isVisibleButton0 && CanInvite()
	isVisibleButton1 = isVisibleButton1 && CanInvite()

	if ( isVisibleButton0 )
	{
		if ( file.lastPlayedPlayerPersistenceIndex0 == -1 )
			return

		string namePlayer0 = expect string( GetPersistentVar( "lastGameSquadStats[" + file.lastPlayedPlayerPersistenceIndex0 + "].playerName" ) )
		HudElem_SetRuiArg( file.inviteLastPlayedUnitFrame0, "name", namePlayer0 )

		string characterGUIDString = string( GetPersistentVar( "lastGameSquadStats[" + file.lastPlayedPlayerPersistenceIndex0 + "].character" ) )
		int characterGUID          = ConvertItemFlavorGUIDStringToGUID( characterGUIDString )
		if ( IsValidItemFlavorGUID( characterGUID ) )
		{
			ItemFlavor squadCharacterClass = GetItemFlavorByGUID( characterGUID )
			HudElem_SetRuiArg( file.inviteLastPlayedUnitFrame0, "icon", CharacterClass_GetGalleryPortrait( squadCharacterClass ), eRuiArgType.IMAGE )
		}

		if ( Time() - file.lastPlayedPlayerInviteSentTimestamp0 > INVITE_LAST_TIMEOUT )
		{
			HudElem_SetRuiArg( file.inviteLastPlayedUnitFrame0, "unitframeFooterText", "#INVITE_PLAYER_UNITFRAME" )
			Hud_SetLocked( file.inviteLastPlayedUnitFrame0, false )
		}

		int hardwareID        = expect int( GetPersistentVar( "lastGameSquadStats[" + file.lastPlayedPlayerPersistenceIndex0 + "].hardwareID" ) )
		string platformString = CrossplayUserOptIn() ? PlatformIDToIconString( hardwareID ) : ""
		HudElem_SetRuiArg( file.inviteLastPlayedUnitFrame0, "platformString", platformString )
	}

	Hud_SetVisible( file.inviteLastPlayedUnitFrame0, isVisibleButton0 )


	if ( isVisibleButton1 )
	{
		if ( file.lastPlayedPlayerPersistenceIndex1 == -1 )
			return

		string namePlayer1 = expect string( GetPersistentVar( "lastGameSquadStats[" + file.lastPlayedPlayerPersistenceIndex1 + "].playerName" ) )
		HudElem_SetRuiArg( file.inviteLastPlayedUnitFrame1, "name", namePlayer1 )

		string characterGUIDString = string( GetPersistentVar( "lastGameSquadStats[" + file.lastPlayedPlayerPersistenceIndex1 + "].character" ) )
		int characterGUID          = ConvertItemFlavorGUIDStringToGUID( characterGUIDString )
		if ( IsValidItemFlavorGUID( characterGUID ) )
		{
			ItemFlavor squadCharacterClass = GetItemFlavorByGUID( characterGUID )
			HudElem_SetRuiArg( file.inviteLastPlayedUnitFrame1, "icon", CharacterClass_GetGalleryPortrait( squadCharacterClass ), eRuiArgType.IMAGE )
		}

		if ( Time() - file.lastPlayedPlayerInviteSentTimestamp1 > INVITE_LAST_TIMEOUT )
		{
			HudElem_SetRuiArg( file.inviteLastPlayedUnitFrame1, "unitframeFooterText", "#INVITE_PLAYER_UNITFRAME" )
			Hud_SetLocked( file.inviteLastPlayedUnitFrame1, false )
		}

		int hardwareID        = expect int( GetPersistentVar( "lastGameSquadStats[" + file.lastPlayedPlayerPersistenceIndex1 + "].hardwareID" ) )
		string platformString = CrossplayUserOptIn() ? PlatformIDToIconString( hardwareID ) : ""
		HudElem_SetRuiArg( file.inviteLastPlayedUnitFrame1, "platformString", platformString )
	}

	Hud_SetVisible( file.inviteLastPlayedUnitFrame1, isVisibleButton1 )
	Hud_SetVisible( file.inviteLastPlayedHeader, isVisibleButton0 || isVisibleButton1 )

	if ( shouldUpdateDpadNav )
	{
		UpdateLastSquadDpadNav()
	}

	//

	ToolTipData toolTipData0
	toolTipData0.tooltipStyle = eTooltipStyle.BUTTON_PROMPT

	ToolTipData toolTipData1
	toolTipData1.tooltipStyle = eTooltipStyle.BUTTON_PROMPT

	if ( !IsSocialPopupActive() )
	{
		if ( Time() - file.lastPlayedPlayerInviteSentTimestamp0 > INVITE_LAST_TIMEOUT )
		{
			toolTipData0.actionHint1 = "#A_BUTTON_INVITE"
			toolTipData0.actionHint2 = "#X_BUTTON_INSPECT"
			if ( ClubIsValid() && ClubGetMyMemberRank() >= CLUB_RANK_CAPTAIN )
				toolTipData0.actionHint3 = "#LAST_SQUAD_BUTTON_CLUB_INVITE"
			Hud_SetToolTipData( file.inviteLastPlayedUnitFrame0, toolTipData0 )
		}
		else if ( Time() - file.lastPlayedPlayerInviteSentTimestamp0 <= INVITE_LAST_TIMEOUT )
		{
			toolTipData0.actionHint1 = "#X_BUTTON_INSPECT"
			Hud_SetToolTipData( file.inviteLastPlayedUnitFrame0, toolTipData0 )
		}

		if ( Time() - file.lastPlayedPlayerInviteSentTimestamp1 > INVITE_LAST_TIMEOUT )
		{
			toolTipData1.actionHint1 = "#A_BUTTON_INVITE"
			toolTipData1.actionHint2 = "#X_BUTTON_INSPECT"
			if ( ClubIsValid() && ClubGetMyMemberRank() >= CLUB_RANK_CAPTAIN )
				toolTipData0.actionHint3 = "#LAST_SQUAD_BUTTON_CLUB_INVITE"
			Hud_SetToolTipData( file.inviteLastPlayedUnitFrame1, toolTipData1 )
		}
		else if ( Time() - file.lastPlayedPlayerInviteSentTimestamp1 <= INVITE_LAST_TIMEOUT )
		{
			toolTipData1.actionHint1 = "#X_BUTTON_INSPECT"
			Hud_SetToolTipData( file.inviteLastPlayedUnitFrame1, toolTipData1 )
		}
	}
	else
	{
		Hud_ClearToolTipData( file.inviteLastPlayedUnitFrame1 )
		Hud_ClearToolTipData( file.inviteLastPlayedUnitFrame0 )
	}
}


void function ClientToUI_PartyMemberJoinedOrLeft( string leftSpotUID, string leftSpotEAID, string leftSpotHardware, string leftSpotName, bool leftSpotInMatch, string rightSpotUID, string rightSpotEAID, string rightSpotHardware, string rightSpotName, bool rightSpotInMatch )
{
	bool personInLeftSpot  = leftSpotUID.len() > 0
	bool persinInRightSpot = rightSpotUID.len() > 0

	file.friendInLeftSpot.id = leftSpotUID
	file.friendInLeftSpot.hardware = leftSpotHardware
	file.friendInLeftSpot.name = leftSpotName
	file.friendInLeftSpot.ingame = leftSpotInMatch
	file.friendInLeftSpot.eadpData = CreateEADPDataFromEAID( leftSpotEAID )

	file.friendInRightSpot.id = rightSpotUID
	file.friendInRightSpot.hardware = rightSpotHardware
	file.friendInRightSpot.name = rightSpotName
	file.friendInRightSpot.ingame = rightSpotInMatch
	file.friendInRightSpot.eadpData = CreateEADPDataFromEAID( rightSpotEAID )

	file.personInLeftSpot = personInLeftSpot
	file.personInRightSlot = persinInRightSpot

	file.leftWasReady = file.leftWasReady && personInLeftSpot
	file.rightWasReady = file.rightWasReady && persinInRightSpot

	UpdateLobbyButtons()
}


bool function CanActivateReadyButton()
{
	if ( IsConnectingToMatch() )
		return false

	//
	//
	if ( GetActiveMenu() == GetMenu( "ModeSelectDialog" ) )
		return false

	bool isReady = GetConVarBool( "party_readyToSearch" )

	//
	if ( isReady )
		return true

	if ( !Lobby_IsPlaylistAvailable( GetSelectedPlaylist() ) )
		return false


                                     
                                                                 
               
       

	return true
}


string function GetSelectedPlaylist()
{
	return IsPartyLeader() ? file.selectedPlaylist : GetParty().playlistName
}


int function Lobby_GetPlaylistState( string playlistName )
{
	if ( playlistName == "" )
		return ePlaylistState.NO_PLAYLIST

	if ( IsPrivateMatchLobby() )
	{
		if ( GetPlaylistVarBool( playlistName, "private_match", false ) )
			return ePlaylistState.AVAILABLE
		else
			return ePlaylistState.LOCKED
	}
	if ( playlistName != PLAYLIST_TRAINING && GetPartySize() == 1 && !IsExemptFromTraining() && !IsTrainingCompleted() )
	{
		if ( GetCurrentPlaylistVarBool( "full_training_required", true ) )
			return ePlaylistState.COMPLETED_TRAINING_REQUIRED
		else
			return ePlaylistState.TRAINING_REQUIRED
	}

	if ( file.currentMaxMatchmakingDelayEndTime > 0 )
		return ePlaylistState.RANKED_MATCH_ABANDON_DELAY

	if ( GetPartySize() > GetMaxTeamSizeForPlaylist( playlistName ) )
		return ePlaylistState.PARTY_SIZE_OVER

	if ( IsRankedPlaylist( playlistName ) )
	{
		if ( !Ranked_PartyHasRankedLevelAccess() )
			return ePlaylistState.RANKED_LEVEL_REQUIRED
		else if ( !Ranked_PartyMeetsRankedDifferenceRequirements() )
			return ePlaylistState.RANKED_LARGE_RANK_DIFFERENCE
		else if ( !Ranked_HasBeenInitialized() )
			return ePlaylistState.RANKED_NOT_INITIALIZED
	}

	if ( !PartyHasPlaylistAccountLevelRequired( playlistName ) )
		return ePlaylistState.ACCOUNT_LEVEL_REQUIRED

	string rotationGroup = GetPlaylistVarString( playlistName, "playlist_rotation_group", "" )
	if ( rotationGroup != "" && rotationGroup != GetPlaylistRotationGroup() )
		return ePlaylistState.ROTATION_GROUP_MISMATCH

                           
		if ( playlistName == "private_match" && !IsTournamentMatchmaking() )
			return ePlaylistState.LOCKED
       

	return ePlaylistState.AVAILABLE
}


string function Lobby_GetPlaylistStateString( int playlistState )
{
                                     
                                                                 
   
                                     
   
       

	return playlistStateMap[playlistState]
}


void function UpdateReadyButton()
{
	bool isLeader = IsPartyLeader()

	bool isReady               = GetConVarBool( "party_readyToSearch" )
	string buttonText
	string buttonDescText
	float buttonDescFontHeight = 0.0

                                      
		float timeRemaining = 0
		if ( file.currentMaxMatchmakingDelayEndTime > 0 )
			timeRemaining = file.currentMaxMatchmakingDelayEndTime - Time()

		if ( timeRemaining > 0 )
		{
			buttonText = "#RANKED_ABANDON_PENALTY_PLAY_BUTTON_LABEL"
			HudElem_SetRuiArg( file.readyButton, "expireTime", Time() + timeRemaining, eRuiArgType.GAMETIME )
		}
		else
		{
			file.currentMaxMatchmakingDelayEndTime = 0
			if ( isReady )
			{
				buttonText = IsControllerModeActive() ? "#B_BUTTON_CANCEL" : "#CANCEL"
			}
			else if ( ShouldForceShowModeSelection() )
			{
				buttonText = IsControllerModeActive() ? "#Y_BUTTON_SELECT" : "#SELECT"
			}
			else
			{
				buttonText = IsControllerModeActive() ? "#Y_BUTTON_READY" : "#READY"
			}

			if ( Dev_CommandLineHasParm( "-auto_ezlaunch" ) )
			{
				buttonDescText = "-auto_ezlaunch"
				buttonDescFontHeight = 24
			}

			HudElem_SetRuiArg( file.readyButton, "expireTime", RUI_BADGAMETIME, eRuiArgType.GAMETIME )
		}
      
                                                                          
                                       
                   
   
                                      
                                                                               
    
                                                                                                                     
                                                                        
    
   
      
   
                 
                                                                          
       
                                                                        

                                                                                             
   
          


	HudElem_SetRuiArg( file.readyButton, "isLeader", isLeader ) //
	HudElem_SetRuiArg( file.readyButton, "isReady", isReady )
	HudElem_SetRuiArg( file.readyButton, "buttonText", Localize( buttonText ) )
	HudElem_SetRuiArg( file.readyButton, "buttonDescText", buttonDescText )
	HudElem_SetRuiArg( file.readyButton, "buttonDescFontHeight", buttonDescFontHeight )

	Hud_SetLocked( file.readyButton, !CanActivateReadyButton() )

	if ( !CanActivateReadyButton() )
	{
		ToolTipData toolTipData
		toolTipData.titleText = IsConnectingToMatch() ? "#UNAVAILABLE" : "#READY_UNAVAILABLE"
		toolTipData.descText = IsConnectingToMatch() ? "#LOADINGPROGRESS_CONNECTING" : Lobby_GetPlaylistStateString( Lobby_GetPlaylistState( GetSelectedPlaylist() ) )

		Hud_SetToolTipData( file.readyButton, toolTipData )
	}
	else
	{
		Hud_ClearToolTipData( file.readyButton )
	}
}


bool function CanActivateModeButton()
{
	bool isReady  = GetConVarBool( "party_readyToSearch" )
	bool isLeader = IsPartyLeader()

	return !isReady && isLeader
}


bool function HasNewModes()
{
	bool hasNewModes = false
	if ( !IsFullyConnected() )
		return false

	if ( Playlist_GetNewModeVersion() > GetPersistentVarAsInt( "newModeVersion" ) )
		return true

	string currentLTM = Playlist_GetLTMSlotPlaylist()
	if ( (currentLTM != "") && (currentLTM != GetPersistentVar( "lastSeenLobbyLTM" )) )
		return true

	return false
}


string function GetCrossplayStatus()
{
	/*



*/

	//
	if ( GetPlayerHardware() == "" )
	{
		return ""
	}

	if ( !CrossplayEnabled() )
	{
		return ""
	}

	if ( !CrossplayUserOptIn() || !IsPartyAllowedCrossplay() )
	{
		//
		//
		return Localize( "#CROSSPLAY_N_ONLY", Localize( PlatformIDToIconString( GetHardwareFromName( GetPlayerHardware() ) ) ) )
	}

	foreach ( index, member in GetParty().members )
	{
		if ( GetHardwareFromName( member.hardware ) == HARDWARE_PC )
			return Localize( "#CROSSPLAY_N", Localize( PlatformIDToIconString( HARDWARE_PC ) ) )
	}

	#if(PC_PROG)
		return Localize( "#CROSSPLAY_N", Localize( "#CROSSPLAY_ICON_PC" ) )
	#else
		return Localize( "#CROSSPLAY_N", Localize( "#CROSSPLAY_ICON_CONTROLLER" ) )
	#endif
}


void function UpdateModeButton()
{
	if ( !IsConnected() )
		return

	string visiblePlaylistValue = GetConVarString( "match_visiblePlaylists" )
	if ( visiblePlaylistValue != file.lastVisiblePlaylistValue )
	{
		Lobby_UpdatePlayPanelPlaylists()
		file.lastVisiblePlaylistValue = visiblePlaylistValue
	}

	Hud_SetLocked( file.modeButton, !CanActivateModeButton() )

	bool isReady = GetConVarBool( "party_readyToSearch" )
	Hud_SetEnabled( file.modeButton, !isReady && CanActivateModeButton() )
	HudElem_SetRuiArg( file.modeButton, "isReady", isReady )
	HudElem_SetRuiArg( file.gamemodeSelectV2Button, "isReady", isReady )
	HudElem_SetRuiArg( file.gamemodeSelectV3Button, "isReady", isReady )
	HudElem_SetRuiArg( file.gamemodeSelectV3Button, "crossplayStatus", GetCrossplayStatus() )

	bool hasNewModes = HasNewModes()
	Hud_SetNew( file.gamemodeSelectV2Button, hasNewModes && (IsTrainingCompleted() || IsExemptFromTraining()) )
	Hud_SetNew( file.gamemodeSelectV3Button, hasNewModes && (IsTrainingCompleted() || IsExemptFromTraining()) )

	if ( file.wasReady != isReady )
	{
		UISize screenSize = GetScreenSize()

		float scale   = float( GetScreenSize().width ) / 1920.0
		int maxDist   = int( screenSize.height * 0.08 )
		int maxDistNX = int( screenSize.height * 0.1 )

		int x   = Hud_GetX( file.modeButton )
		int y   = isReady ? Hud_GetBaseY( file.modeButton ) + maxDist : Hud_GetBaseY( file.modeButton )
		int yNX = isReady ? Hud_GetBaseY( file.modeButton ) + maxDistNX : Hud_GetBaseY( file.modeButton )

		int currentY = Hud_GetY( file.modeButton )
		int diff     = abs( currentY - y )

		#if(NX_PROG)
			if ( IsNxHandheldMode() )
			{
				float duration = 0.15 * (float( diff ) / (float( maxDistNX ) * scale))
				Hud_MoveOverTime( file.modeButton, x, yNX, 0.15 )
			}
			else
			{
				float duration = 0.15 * (float( diff ) / float( maxDist ))
				Hud_MoveOverTime( file.modeButton, x, y, 0.15 )
			}
		#else
			float duration = 0.15 * (float( diff ) / float( maxDist ))
			Hud_MoveOverTime( file.modeButton, x, y, 0.15 )
		#endif

		file.wasReady = isReady
	}

	bool isLeader = IsPartyLeader()

	string playlistName        = isLeader ? (isReady ? GetConVarString( "match_playlist" ) : file.selectedPlaylist) : GetParty().playlistName
	string invalidPlaylistText = isLeader ? "#SELECT_PLAYLIST" : "#PARTY_LEADER_CHOICE"

	string name = GetPlaylistVarString( playlistName, "name", invalidPlaylistText )
	HudElem_SetRuiArg( file.modeButton, "buttonText", Localize( name ) + file.selectedPlaylistMods )

	bool useGamemodeSelectV2 = GamemodeSelectV2_IsEnabled() && !(ShouldDisplayOptInOptions() && uiGlobal.isOptInEnabled)
	bool useGamemodeSelectV3 = GamemodeSelectV3_IsEnabled() && !(ShouldDisplayOptInOptions() && uiGlobal.isOptInEnabled)

	Hud_SetVisible( file.modeButton, !(useGamemodeSelectV2 || useGamemodeSelectV3) )
	Hud_SetVisible( file.gamemodeSelectV2Button, useGamemodeSelectV2 && !useGamemodeSelectV3 )
	Hud_SetVisible( file.gamemodeSelectV3Button, useGamemodeSelectV3 )

	RuiSetBool( Hud_GetRui( file.readyButton ), "showReadyFrame", !useGamemodeSelectV2 && !useGamemodeSelectV3 )

	if ( useGamemodeSelectV3 )
	{
		GamemodeSelectV3_UpdateSelectButton( file.gamemodeSelectV3Button, playlistName )
		HudElem_SetRuiArg( file.gamemodeSelectV3Button, "alwaysShowDesc", true )
		HudElem_SetRuiArg( file.gamemodeSelectV3Button, "isPartyLeader", isLeader )

		HudElem_SetRuiArg( file.gamemodeSelectV3Button, "modeLockedReason", "" )
		Hud_SetLocked( file.gamemodeSelectV3Button, !CanActivateModeButton() )

		if ( PlaylistHasRotationGroup( Lobby_GetSelectedPlaylist() ) )
		{
			string rotationMapName  = GetMapDisplayNameForCurrentRotationGroup()
			string nextRotationTime = GetPlaylistRotationNextTimeFormatedString()
			string descText         = Localize( "#VAR_DASH_VAR", Localize( rotationMapName ).toupper(), nextRotationTime )
			HudElem_SetRuiArg( file.gamemodeSelectV3Button, "modeDescText", descText )
		}
	}
	else if ( useGamemodeSelectV2 )
	{
		GamemodeSelectV2_UpdateSelectButton( file.gamemodeSelectV2Button, playlistName )
		HudElem_SetRuiArg( file.gamemodeSelectV2Button, "alwaysShowDesc", true )
		HudElem_SetRuiArg( file.gamemodeSelectV2Button, "isPartyLeader", isLeader )

		HudElem_SetRuiArg( file.gamemodeSelectV2Button, "modeLockedReason", "" )
		Hud_SetLocked( file.gamemodeSelectV2Button, !CanActivateModeButton() )
	}

	if ( file.lastPlaylistDisplayed != playlistName )
	{
		Lobby_UpdateLoadscreenFromPlaylist()
	}

	file.lastPlaylistDisplayed = playlistName
}


void function ResetFillButton()
{
	Hud_SetSelected( file.fillButton, true )
	SetConVarBool( "party_nofill_selected", true )
	file.noFillButtonWasFullSquad = false
	file.noFillButtonWasPartyLeader = false
}


void function UpdateFillButton()
{
	Hud_ClearToolTipData( file.fillButton )

	//
	bool shouldShowFillButton = DoesPlaylistSupportNoFill( Lobby_GetSelectedPlaylist() )
	bool shouldLockFillButton = false

	if ( shouldShowFillButton )
	{
		string fillButtonToolTipText = "#MATCH_TEAM_FILL_DESC"

		if ( IsPartyLeader() )
		{
			if ( !file.noFillButtonWasPartyLeader )
				ResetFillButton()

			file.noFillButtonWasPartyLeader = true
		}
		else
		{
			shouldLockFillButton = true
			fillButtonToolTipText = "#MATCH_TEAM_FILL_NOT_LEADER"
			Hud_SetSelected( file.fillButton, IsNoFillSelected() ) //
			file.noFillButtonWasPartyLeader = false
		}


		if ( AreWeMatchmaking() ) //
		{
			fillButtonToolTipText = "#MATCH_TEAM_FILL_MATCHMAKING"
			shouldLockFillButton = true
		}
		else if ( GetPartySize() >= Lobby_GetSelectedPlaylistExpectedSquadSize() )
		{
			fillButtonToolTipText = "#MATCH_TEAM_FILL_ALREADY_FULL"
			shouldLockFillButton = true
			Hud_SetSelected( file.fillButton, false )
			SetConVarBool( "party_nofill_selected", false ) //
			file.noFillButtonWasFullSquad = true
		}
		else if ( GetPartySize() < Lobby_GetSelectedPlaylistExpectedSquadSize() && file.noFillButtonWasFullSquad )
		{
			ResetFillButton()
		}

		ToolTipData td
		td.descText = fillButtonToolTipText
		Hud_SetToolTipData( file.fillButton, td )

	}
	else
	{
		shouldLockFillButton = true
		Hud_SetSelected( file.fillButton, false )
		SetConVarBool( "party_nofill_selected", false )
	}

	Hud_SetVisible( file.fillButton, shouldShowFillButton )
	Hud_SetEnabled( file.fillButton, !shouldLockFillButton )
	Hud_SetLocked( file.fillButton, shouldLockFillButton )
}


void function FillButton_OnActivate( var button )
{
	//
	//
	bool isFillSquadActive = GetPartySize() > 1 ? IsNoFillSelected() : GetConVarBool( "party_nofill_selected" )

	Hud_SetSelected( button, !isFillSquadActive )
	SetConVarBool( "party_nofill_selected", !isFillSquadActive )
	printt( "SHOULD WE FILL THE SQUAD? " + !isFillSquadActive )
}


void function ModeButton_OnActivate( var button )
{
	if ( Hud_IsLocked( button ) || !CanActivateModeButton() )
		return

	Remote_ServerCallFunction( "ClientCallback_ViewedModes" )
	file.newModesAcknowledged = true

	AdvanceMenu( GetMenu( "ModeSelectDialog" ) )
}


void function GameModeSelectV2Button_OnActivate( var button )
{
	if ( Hud_IsLocked( button ) || !CanActivateModeButton() )
		return

	Hud_SetVisible( file.gamemodeSelectV2Button, false )
	Hud_SetVisible( file.readyButton, false )

	Remote_ServerCallFunction( "ClientCallback_ViewedModes" )

	AdvanceMenu( GetMenu( "GamemodeSelectV2Dialog" ) )
}


void function GameModeSelectV2Button_OnGetFocus( var button )
{
	GamemodeSelectV2_PlayVideo( button, file.selectedPlaylist )
}


void function GameModeSelectV2Button_OnLoseFocus( var button )
{
	//
}


void function Lobby_OnGamemodeSelectV2Close()
{
	Hud_SetVisible( file.gamemodeSelectV2Button, true )
	Hud_SetVisible( file.readyButton, true )
}


void function GameModeSelectV3Button_OnActivate( var button )
{
	if ( Hud_IsLocked( button ) || !CanActivateModeButton() )
		return

	Hud_SetVisible( file.gamemodeSelectV3Button, false )
	Hud_SetVisible( file.readyButton, false )

	string currentLTM = Playlist_GetLTMSlotPlaylist()
	if ( (currentLTM != "") && (currentLTM != GetPersistentVar( "lastSeenLobbyLTM" )) && Lobby_IsPlaylistAvailable( currentLTM ) )
		GamemodeSelectV3_SetFeaturedSlot( "ltm" )

	if ( Lobby_IsPlaylistAvailable( currentLTM ) )
		Remote_ServerCallFunction( "ClientCallback_ViewedModes" )

	AdvanceMenu( GetMenu( "GamemodeSelectV3Dialog" ) )
}


void function GameModeSelectV3Button_OnGetFocus( var button )
{
	//
	GamemodeSelectV2_PlayVideo( button, file.selectedPlaylist )
}


void function GameModeSelectV3Button_OnLoseFocus( var button )
{
	//
}


void function Lobby_OnGamemodeSelectV3Close()
{
	Hud_SetVisible( file.gamemodeSelectV3Button, true )
	Hud_SetVisible( file.readyButton, true )
}


void function PlayPanel_OnNavBack( var panel )
{
	if ( !IsControllerModeActive() )
		return

	bool isReady = GetConVarBool( "party_readyToSearch" )
	if ( !AreWeMatchmaking() && !isReady )
		return

	CancelMatchmaking()
	Remote_ServerCallFunction( "ClientCallback_CancelMatchSearch" )
}


bool function ReadyShortcut_OnActivate( var panel )
{
	if ( AreWeMatchmaking() )
		return false

	ReadyButton_OnActivate( file.readyButton )
	return true
}


bool function SeasonShortcut_OnActivate( var panel )
{
	TabData lobbyTabData = GetTabDataForPanel( GetMenu( "LobbyMenu" ) )

	if ( Hud_IsFocused( file.friendButton0 ) || Hud_IsFocused( file.friendButton1 ) )
		return false //

	ActivateTab( lobbyTabData, Tab_GetTabIndexByBodyName( lobbyTabData, "SeasonPanel" ) )
	EmitUISound( "UI_Menu_ApexTab_Select" )
	return true
}


bool function ShouldForceShowModeSelection()
{
	if ( !GetCurrentPlaylistVarBool( "force_show_mode_selection", true ) )
		return false

	if ( Hud_IsLocked( file.modeButton ) )
		return false

	if ( !CanActivateModeButton() )
		return false

	if ( !HasNewModes() )
		return false

	if ( file.newModesAcknowledged )
		return false

	if ( !IsTrainingCompleted() && !IsExemptFromTraining() )
		return false

	if ( IsSelectedPlaylistQuestMission() )
		return false

	return true
}


void function ReadyButton_OnActivate( var button )
{
	if ( ShouldForceShowModeSelection() )
	{
		if ( GamemodeSelectV3_IsEnabled() )
			GameModeSelectV3Button_OnActivate( file.gamemodeSelectV3Button )
		else if ( GamemodeSelectV2_IsEnabled() )
			GameModeSelectV2Button_OnActivate( file.gamemodeSelectV2Button )
		else
			ModeButton_OnActivate( file.modeButton )
		return
	}

	if ( Hud_IsLocked( file.readyButton ) || !CanActivateReadyButton() )
		return

	bool isReady                   = GetConVarBool( "party_readyToSearch" )
	bool requireConsensusForSearch = GetConVarBool( "party_requireConsensusForSearch" )

	if ( AreWeMatchmaking() || isReady )
	{
		CancelMatchmaking()
		Remote_ServerCallFunction( "ClientCallback_CancelMatchSearch" )
		EmitUISound( SOUND_STOP_MATCHMAKING_1P )
	}
	else
	{
		if ( !IsGameFullyInstalled() || HasNonFullyInstalledAssetsLoaded() )
		{
			ConfirmDialogData data
			data.headerText = "#TEXTURE_STREAM_HEADER"
			data.messageText = Localize( "#TEXTURE_STREAM_MESSAGE", floor( GetGameFullyInstalledProgress() * 100 ) )
			data.yesText = ["#TEXTURE_STREAM_PLAY", "#TEXTURE_STREAM_PLAY_PC"]
			data.noText = ["#TEXTURE_STREAM_WAIT", "#TEXTURE_STREAM_WAIT_PC"]
			if ( GetGameFullyInstalledProgress() >= 1 && HasNonFullyInstalledAssetsLoaded() )
			{
				//
				data.headerText = "#TEXTURE_STREAM_REBOOT_HEADER"
				data.messageText = "#TEXTURE_STREAM_REBOOT_MESSAGE"
				data.yesText = ["#TEXTURE_STREAM_REBOOT", "#TEXTURE_STREAM_REBOOT_PC"]
				data.noText = ["#TEXTURE_STREAM_PLAY_ON_NO", "#TEXTURE_STREAM_PLAY_PC"]
			}

			data.resultCallback = void function ( int result ) : ()
			{
				if ( GetGameFullyInstalledProgress() >= 1 && HasNonFullyInstalledAssetsLoaded() )
				{
					//
					if ( result == eDialogResult.YES )
					{
						//
						ClientCommand( "disconnect" )
						return
					}
				}
				else if ( result != eDialogResult.YES )
				{
					//
					return

				}

				//
				ReadyButtonActivate()
			}

			if ( !IsDialog( GetActiveMenu() ) )
				OpenConfirmDialogFromData( data )
			return
		}

		bool isLeader = IsPartyLeader()

		if ( isLeader && ShouldShowLowPopDialog( file.selectedPlaylist ) )
		{
			OpenLowPopDialog( ReadyButtonActivateForDataCenter )
		}
		else
		{
			ReadyButtonActivate()
		}
	}
}


void function ReadyButtonActivateForDataCenter( int datacenterIndex )
{
	LowPop_SetRankedDatacenter( datacenterIndex )
	ReadyButtonActivate()
}


void function ReadyButtonActivate()
{
	if ( Hud_IsLocked( file.readyButton ) || !CanActivateReadyButton() )
	{
		return
	}
	else
	{
		EmitUISound( SOUND_START_MATCHMAKING_1P )

		var jsonTable = {
			map = GetConVarString( "playlist_rotationGroup" )
			next_map_time = GetConVarInt( "playlist_rotationNextTime" )
		}
		PIN_UIInteraction_Select( GetActiveMenuName(), "readybutton", jsonTable );

		if ( GetConVarBool( "match_teamNoFill" ) && DoesPlaylistSupportNoFillTeams( file.selectedPlaylist ) )
			StartMatchmakingWithNoFillTeams( file.selectedPlaylist )
		else
			StartMatchmakingStandard( file.selectedPlaylist )
	}
}


void function InviteFriendsButton_OnActivate( var button )
{
	if ( Hud_IsLocked( button ) )
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

	thread CreatePartyAndInviteFriends()
}


void function InviteLastPlayedButton_OnActivate( var button )
{
	if ( Hud_IsLocked( button ) )
		return

	int scriptID = int( Hud_GetScriptID( button ) )

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

	InviteLastPlayedToParty( scriptID )
	if ( button == file.inviteLastPlayedUnitFrame0 )
		file.lastPlayedPlayerInviteSentTimestamp0 = Time()
	if ( button == file.inviteLastPlayedUnitFrame1 )
		file.lastPlayedPlayerInviteSentTimestamp1 = Time()

	HudElem_SetRuiArg( button, "unitframeFooterText", "#INVITE_PLAYER_INVITED" )
	Hud_SetLocked( button, true )
}


void function InviteLastPlayedToParty( int scriptID )
{
	Assert( scriptID == 0 || scriptID == 1 )

	string nucleusID
	string platformUID
	int hardwardID

	switch( scriptID )
	{
		case 0:
			nucleusID = file.lastPlayedPlayerNucleusID0
			platformUID = file.lastPlayedPlayerPlatformUid0
			hardwardID = file.lastPlayedPlayerHardwareID0
			break

		case 1:
			nucleusID = file.lastPlayedPlayerNucleusID1
			platformUID = file.lastPlayedPlayerPlatformUid1
			hardwardID = file.lastPlayedPlayerHardwareID1
			break
	}

	int localHardwareID = GetHardwareFromName( GetPlayerHardware() )
	bool isEADPFriend   = localHardwareID != hardwardID //

	#if(PC_PROG)
		if ( PCPlat_IsSteam() )
			isEADPFriend = true
	#endif

	#if(NX_PROG)
		//
		if( DoInviteToParty( [platformUID] ) == false )
		{
			isEADPFriend = true
		}
		else
		{
			return
		}
	#endif
	
	if ( isEADPFriend )
	{
		printt( " InviteEADPFriend id:", nucleusID )
		EADP_InviteToPlayByEAID( nucleusID )
	}
	else
	{
		printt( " InviteFriend id:", platformUID )
		DoInviteToParty( [platformUID] )
	}
}


void function InviteLastPlayedButton_OnMiddleClick( var button )
{
	if ( Hud_IsLocked( button ) )
		return

	if ( !Clubs_IsEnabled() )
		return

	if ( !ClubIsValid() )
		return

	if ( IsSocialPopupActive() )
		return

	int scriptID = int( Hud_GetScriptID( button ) )

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

	Assert( scriptID == 0 || scriptID == 1 )

	string nucleusID
	string platformUID
	int hardwardID

	switch( scriptID )
	{
		case 0:
			nucleusID = file.lastPlayedPlayerNucleusID0
			platformUID = file.lastPlayedPlayerPlatformUid0
			hardwardID = file.lastPlayedPlayerHardwareID0
			break

		case 1:
			nucleusID = file.lastPlayedPlayerNucleusID1
			platformUID = file.lastPlayedPlayerPlatformUid1
			hardwardID = file.lastPlayedPlayerHardwareID1
			break
	}

	if ( nucleusID != "" )
		return

	if ( Clubs_IsUserAClubmate( nucleusID ) )
		return

	ClubInviteUser( nucleusID )
	HudElem_SetRuiArg( button, "unitframeFooterText", "#CLUB_INVITE_INVITED" )
}


bool function InviteLastPlayedButton_OnKeyPress( var button, int keyId, bool isDown )
{
	printf( "LastSquadInputDebug: OnKeyPress" )
	if ( Hud_IsLocked( button ) )
		return false

	if ( !Clubs_IsEnabled() )
		return false

	if ( !ClubIsValid() )
		return false

	if ( !isDown )
		return false

	switch ( keyId )
	{
		case MOUSE_MIDDLE:
		case BUTTON_STICK_LEFT:
			break

		default:
			return false
	}

	int scriptID = int( Hud_GetScriptID( button ) )

	#if(PC_PROG)
		if ( !MeetsAgeRequirements() )
		{
			ConfirmDialogData dialogData
			dialogData.headerText = "#UNAVAILABLE"
			dialogData.messageText = "#ORIGIN_UNDERAGE_ONLINE"
			dialogData.contextImage = $"ui/menu/common/dialog_notice"

			OpenOKDialogFromData( dialogData )
			return false
		}
	#endif

	Assert( scriptID == 0 || scriptID == 1 )
	printf( "LastSquadInputDebug: OnKeyPress: Club Invite Input Detected" )

	string nucleusID
	string platformUID
	int hardwardID

	switch( scriptID )
	{
		case 0:
			nucleusID = file.lastPlayedPlayerNucleusID0
			platformUID = file.lastPlayedPlayerPlatformUid0
			hardwardID = file.lastPlayedPlayerHardwareID0
			break

		case 1:
			nucleusID = file.lastPlayedPlayerNucleusID1
			platformUID = file.lastPlayedPlayerPlatformUid1
			hardwardID = file.lastPlayedPlayerHardwareID1
			break
	}

	if ( nucleusID == "" )
		return false

	if ( Clubs_IsUserAClubmate( nucleusID ) )
		return false

	printf( "LastSquadInputDebug: OnKeyPress: Sending Invite" )

	ClubInviteUser( nucleusID )
	HudElem_SetRuiArg( button, "unitframeFooterText", "#CLUB_INVITE_INVITED" )

	return true
}


void function InviteLastPlayedButton_OnRightClick( var button )
{
	if ( IsSocialPopupActive() )
		return

	int scriptID   = int( Hud_GetScriptID( button ) )
	int hardwareID = GetHardwareFromName( GetUnspoofedPlayerHardware() )

	Friend friend

	if ( scriptID == 0 )
	{
		friend.name = expect string( GetPersistentVar( "lastGameSquadStats[" + file.lastPlayedPlayerPersistenceIndex0 + "].playerName" ) )
		friend.hardware = GetNameFromeHardware( file.lastPlayedPlayerHardwareID0 )
		friend.id = file.lastPlayedPlayerPlatformUid0
		friend.eadpData = CreateEADPDataFromEAID( file.lastPlayedPlayerNucleusID0 )
	}

	if ( scriptID == 1 )
	{
		friend.name = expect string( GetPersistentVar( "lastGameSquadStats[" + file.lastPlayedPlayerPersistenceIndex1 + "].playerName" ) )
		friend.hardware = GetNameFromeHardware( file.lastPlayedPlayerHardwareID1 )
		friend.id = file.lastPlayedPlayerPlatformUid1
		friend.eadpData = CreateEADPDataFromEAID( file.lastPlayedPlayerNucleusID1 )
	}

	if ( friend.id == "" )
		return

	InspectFriendForceEADP( friend, PCPlat_IsSteam() )
}


void function FriendButton_OnActivate( var button )
{
	int scriptID = int( Hud_GetScriptID( button ) )
	if ( scriptID == -1 )
	{
		Friend friend
		friend.status = eFriendStatus.ONLINE_INGAME
		friend.name = GetPlayerName()
		friend.hardware = GetUnspoofedPlayerHardware()
		friend.ingame = true
		friend.id = GetPlayerUID()

		Party party = GetParty()
		friend.presence = Localize( "#PARTY_N_N", party.numClaimedSlots, party.numSlots )
		friend.inparty = party.numClaimedSlots > 0

		InspectFriend( friend )
	}
	else
	{
		InspectFriend( scriptID == 0 ? file.friendInLeftSpot : file.friendInRightSpot )
	}
}


void function FriendButton_OnRightClick( var button )
{
	int scriptID = int( Hud_GetScriptID( button ) )

	if ( scriptID == 0 )
		TogglePlayerVoiceMutedForUID( file.friendInLeftSpot.id, file.friendInLeftSpot.hardware )
	else
		TogglePlayerVoiceMutedForUID( file.friendInRightSpot.id, file.friendInRightSpot.hardware )
}


void function CreatePartyAndInviteFriends()
{
	if ( CanInvite() )
	{
		while ( !PartyHasMembers() && !AmIPartyLeader() )
		{
			printt( "creating a party in CreatePartyAndInviteFriends" )
			ClientCommand( "createparty" )
			WaitFrameOrUntilLevelLoaded()
		}

		InviteFriends()
	}
	else
	{
		printt( "Not inviting friends - CanInvite() returned false" )
	}
}


void function InviteRoomButton_OnActivate( var button )
{
	if ( Hud_IsLocked( button ) )
		return

	entity player = GetUIPlayer()

	if ( !DoesCurrentCommunitySupportInvites() )
	{
		//
		return
	}

	SendOpenInvite( true )
}


void function OpenLootBoxButton_OnActivate( var button )
{
	if ( Hud_IsLocked( button ) )
		return

	OnLobbyOpenLootBoxMenu_ButtonPress()
}


void function UpdatePlayPanelGRXDependantElements()
{
	if ( GRX_IsInventoryReady() )
		UpdateLobbyChallengeMenu()

	#if(NX_PROG)
		if ( !IsNxHandheldMode() )
			UpdateMiniPromoPinning()
	#else
		UpdateMiniPromoPinning()
	#endif
}


void function UpdateMiniPromoPinning()
{
	//
	//
	//
	//
	//
	//

	var miniPromoButton = Hud_GetChild( file.panel, "MiniPromo" )
                        
                              
   
                                                                            
                       
                                                                       
                                       
         
   
       
	array<var> pinCandidates
	//
	pinCandidates.append( Hud_GetChild( file.panel, "EventPrizeTrackButton" ) )
	pinCandidates.append( Hud_GetChild( file.panel, "ChallengeCatergoryLeftButton" ) )

	array<var> challengeButtons = GetLobbyChallengeButtons()
	challengeButtons.reverse()
	pinCandidates.extend( challengeButtons ) //
	pinCandidates.append( Hud_GetChild( file.panel, "TopRightContentAnchor" ) )

	var anchor = Hud_GetChild( file.panel, "TopRightContentAnchor" )

	foreach ( pinCandidate in pinCandidates )
	{
		if ( !Hud_IsVisible( pinCandidate ) )
			continue

		printt( "Pinning to:", Hud_GetHudName( pinCandidate ) )
		Hud_SetPinSibling( miniPromoButton, Hud_GetHudName( pinCandidate ) )

		int vOffset = pinCandidate == anchor ? 0 : ContentScaledYAsInt( 24 )
		Hud_SetY( miniPromoButton, vOffset )
		break
	}
}


void function UpdateLootBoxButton( var button, array<ItemFlavor> specificPackFlavs = [] )
{
	ItemFlavor ornull packFlav
	int lootBoxCount    = 0
	string buttonText   = "#APEX_PACKS"
	string descText     = "#UNAVAILABLE"
	int nextRarity      = -1
	asset rarityIcon    = $""
	vector themeCol     = <1, 1, 1>
	vector countTextCol = SrgbToLinear( <255, 78, 29> * 1.0 / 255.0 )

	if ( GRX_IsInventoryReady() )
	{
		descText = "#REMAINING"

		if ( specificPackFlavs.len() > 0 )
		{
			foreach ( ItemFlavor specificPackFlav in specificPackFlavs )
			{
				int count = GRX_GetPackCount( ItemFlavor_GetGRXIndex( specificPackFlav ) )

				if ( packFlav == null || (lootBoxCount == 0 && count > 0) )
					packFlav = specificPackFlav

				lootBoxCount += count
			}
		}
		else
		{
			lootBoxCount = GRX_GetTotalPackCount()
			if ( lootBoxCount > 0 )
				packFlav = GetNextLootBox()
		}
	}

	if ( packFlav != null )
	{
		expect ItemFlavor( packFlav )

		if ( ItemFlavor_GetTags( packFlav ).len() == 0 )
		{
			buttonText = (lootBoxCount == 1 ? "#APEX_PACK" : "#APEX_PACKS")
		}
		else
		{
			buttonText = ItemFlavor_GetShortName( packFlav )
			descText = (lootBoxCount == 1 ? "#EVENT_PACK" : "#EVENT_PACKS")
		}

		nextRarity = ItemFlavor_GetQuality( packFlav )
		rarityIcon = GRXPack_GetOpenButtonIcon( packFlav )

		vector ornull customCol0 = GRXPack_GetCustomColor( packFlav, 0 )
		if ( customCol0 != null )
			themeCol = SrgbToLinear( expect vector(customCol0) )
		else if ( nextRarity >= 2 )
			themeCol = SrgbToLinear( GetKeyColor( COLORID_TEXT_LOOT_TIER0, nextRarity + 1 ) / 255.0 )

		vector ornull customCountTextCol = GRXPack_GetCustomCountTextCol( packFlav )
		if ( customCountTextCol != null )
			countTextCol = SrgbToLinear( expect vector(customCountTextCol) )
	}

	HudElem_SetRuiArg( button, "bigText", string( lootBoxCount ) )
	HudElem_SetRuiArg( button, "buttonText", buttonText )
	HudElem_SetRuiArg( button, "descText", descText )
	HudElem_SetRuiArg( button, "descTextRarity", nextRarity )
	HudElem_SetRuiArg( button, "rarityIcon", rarityIcon, eRuiArgType.ASSET )
	RuiSetColorAlpha( Hud_GetRui( button ), "themeCol", themeCol, 1.0 )
	RuiSetColorAlpha( Hud_GetRui( button ), "countTextCol", countTextCol, 1.0 )

	Hud_SetLocked( button, lootBoxCount == 0 )

	//
	Hud_SetEnabled( button, lootBoxCount > 0 )
}


void function PlayPanelUpdate()
{
	UpdateLobbyButtons()
	UpdateHDTextureProgress()
}


bool function ChatroomIsVisibleAndNotFocused()
{
	if ( !file.chatroomMenu )
		return false

	return Hud_IsVisible( file.chatroomMenu ) && !Hud_IsFocused( file.chatroomMenu_chatroomWidget )
}


bool function CanInvite()
{
                                     
                                                                 
               
       

	if ( GetParty().amIInThis == false )
		return false

	if ( GetParty().numFreeSlots == 0 )
		return false

	#if(DURANGO_PROG)
		return (GetMenuVarBool( "isFullyConnected" ) && GetMenuVarBool( "DURANGO_canInviteFriends" ) && GetMenuVarBool( "DURANGO_isJoinable" ))
	#elseif(PLAYSTATION_PROG)
		return GetMenuVarBool( "PS4_canInviteFriends" )
	#elseif(PC_PROG)
		return (GetMenuVarBool( "isFullyConnected" ) && GetMenuVarBool( "ORIGIN_isEnabled" ) && GetMenuVarBool( "ORIGIN_isJoinable" ))
	#elseif(NX_PROG)
		return GetMenuVarBool( "NX_canInviteFriends" )
	#endif
}


bool function IsExemptFromTraining()
{
	if ( !IsFullyConnected() || !IsPersistenceAvailable() )
		return false

                           
		if ( IsTournamentMatchmaking() )
			return true
       

	return GetAccountLevelForXP( GetPersistentVarAsInt( "xp" ) ) >= 14 //
}


bool function IsTrainingCompleted()
{
	if ( !IsFullyConnected() || !IsPersistenceAvailable() )
		return false

	if ( !GetVisiblePlaylistNames().contains( PLAYLIST_TRAINING ) )
		return true

	if ( GetBugReproNum() == 5000005 )
		return true

	if ( GetCurrentPlaylistVarBool( "require_training", true ) )
		return GetPersistentVarAsInt( "trainingCompleted" ) > 0

	return true
}


void function OnRemoteMatchInfoUpdated()
{
	RemoteMatchInfo matchInfo = GetRemoteMatchInfo()
	if ( matchInfo.playlist == "" )
		return

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
}


var function GetPartyMemberButton( string uid )
{
	if ( uid == GetPlayerUID() )
		return file.selfButton
	else if ( uid == file.friendInLeftSpot.id )
		return file.friendButton0
	else if ( uid == file.friendInRightSpot.id )
		return file.friendButton1

	return null
}

#if(DEV)
void function DEV_PrintPartyInfo()
{
	Party party = GetParty()
	printt( "party.partyType", party.partyType )
	printt( "party.playlistName", party.playlistName )
	printt( "party.originatorName", party.originatorName )
	printt( "party.originatorUID", party.originatorUID )
	printt( "party.numSlots", party.numSlots )
	printt( "party.numClaimedSlots", party.numClaimedSlots )
	printt( "party.numFreeSlots", party.numFreeSlots )
	printt( "party.timeLeft", party.timeLeft )
	printt( "party.amIInThis", party.amIInThis )
	printt( "party.amILeader", party.amILeader )
	printt( "party.searching", party.searching )

	foreach ( member in party.members )
	{
		printt( "\tmember.name", member.name )
		printt( "\tmember.uid", member.uid )
		printt( "\tmember.hardware", member.hardware )
		printt( "\tmember.ready", member.ready )

		CommunityUserInfo ornull userInfo = GetUserInfo( member.hardware, member.uid )
		if ( userInfo == null )
			continue

		expect CommunityUserInfo( userInfo )

		DEV_PrintUserInfo( userInfo, "\t\t" )
	}
}

void function DEV_PrintUserInfo( CommunityUserInfo userInfo, string prefix = "" )
{
	printt( prefix + "userInfo.hardware", userInfo.hardware )
	printt( prefix + "userInfo.uid", userInfo.uid )
	printt( prefix + "userInfo.name", userInfo.name )
	printt( prefix + "userInfo.kills", userInfo.kills )
	printt( prefix + "userInfo.wins", userInfo.wins )
	printt( prefix + "userInfo.matches", userInfo.matches )
	printt( prefix + "userInfo.banReason", userInfo.banReason, "(see MATCHBANREASON_)" )
	printt( prefix + "userInfo.banSeconds", userInfo.banSeconds )
	printt( prefix + "userInfo.eliteStreak", userInfo.eliteStreak )
	printt( prefix + "userInfo.rankScore", userInfo.rankScore )
	printt( prefix + "userInfo.lastCharIdx", userInfo.lastCharIdx )
	printt( prefix + "userInfo.isLivestreaming", userInfo.isLivestreaming )
	printt( prefix + "userInfo.isOnline", userInfo.isOnline )
	printt( prefix + "userInfo.isJoinable", userInfo.isJoinable )
	printt( prefix + "userInfo.privacySetting", userInfo.privacySetting )
	printt( prefix + "userInfo.partyFull", userInfo.partyFull )
	printt( prefix + "userInfo.partyInMatch", userInfo.partyInMatch )
	printt( prefix + "userInfo.lastServerChangeTime", userInfo.lastServerChangeTime )

	foreach ( int index, data in userInfo.charData )
	{
		printt( prefix + "\tuserInfo.charData[" + index + "]", data, "\t" + DEV_GetEnumStringSafe( "ePlayerStryderCharDataArraySlots", index ) )
	}
}
#endif


void function AllChallengesButton_OnActivate( var button )
{
	if ( !GRX_IsInventoryReady() || !GRX_AreOffersReady() )
		return

	if ( IsDialog( GetActiveMenu() ) )
		return

	JumpToChallenges()
}


void function ChallengeSwitchLeft_OnClick( var button )
{
	if ( !IsConnected() )
		return

	Assert( file.challengeCategorySelection != null )
	var rui = Hud_GetRui( file.challengeCategorySelection )
	DecrementCatergorySelection()
	UpdateChallengeCatergorySelection( rui )
	UpdateLobbyChallengeMenu()
}


void function ChallengeSwitchRight_OnClick( var button )
{
	if ( !IsConnected() )
		return

	Assert( file.challengeCategorySelection != null )
	var rui = Hud_GetRui( file.challengeCategorySelection )
	IncrementCatergorySelection()
	UpdateChallengeCatergorySelection( rui )
	UpdateLobbyChallengeMenu()
}


void function ChallengeSwitch_GetFocus( var button )
{
	if ( file.challengeInputCallbacksRegistered )
		return
	file.challengeInputCallbacksRegistered = true

	file.challengeLastStickState = eStickState.NEUTRAL
	RegisterStickMovedCallback( ANALOG_RIGHT_X, ChallengeSwitchOnStickMoved )
	AddCallback_OnMouseWheelUp( ChallengeMouseUp )
	AddCallback_OnMouseWheelDown( ChallengeMouseDown )
}


void function ChallengeSwitch_LoseFocus( var button )
{
	if ( !file.challengeInputCallbacksRegistered )
		return
	file.challengeInputCallbacksRegistered = false

	DeregisterStickMovedCallback( ANALOG_RIGHT_X, ChallengeSwitchOnStickMoved )
	RemoveCallback_OnMouseWheelUp( ChallengeMouseUp )
	RemoveCallback_OnMouseWheelDown( ChallengeMouseDown )
}

void function ChallengeMouseUp()
{
	ChallengeSwitchLeft_OnClick( null )
}

void function ChallengeMouseDown()
{
	ChallengeSwitchRight_OnClick( null )
}

void function ChallengeSwitchOnStickMoved( ... )
{
	float stickDeflection = expect float( vargv[1] )
	printt( "stick deflection:", stickDeflection )

	int stickState = eStickState.NEUTRAL
	if ( stickDeflection > 0.25 )
		stickState = eStickState.RIGHT
	else if ( stickDeflection < -0.25 )
		stickState = eStickState.LEFT

	if ( stickState != file.challengeLastStickState )
	{
		if ( stickState == eStickState.RIGHT )
			ChallengeSwitchRight_OnClick( null )
		else if ( stickState == eStickState.LEFT )
			ChallengeSwitchLeft_OnClick( null )
	}

	file.challengeLastStickState = stickState
}

                          
bool function IsTournamentMatchmaking()
{
	if ( file.selectedPlaylist != "private_match" )
		return false

	return GetConVarString( "match_roleToken" ) != ""
}
      

void function Lobby_UpdatePlayPanelPlaylists()
{
	file.playlistMods = GetPlaylistModNames()
	file.playlists = GetVisiblePlaylistNames()
	Assert( file.playlists.len() > 0 )

	if ( !IsFullyConnected() )
		return
	if ( AreWeMatchmaking() )
		return

	//
	string compareSting = "#MATCHMAKING_LOADING"
	string mmStatus     = GetMyMatchmakingStatus()
	if ( mmStatus.len() >= compareSting.len() && mmStatus.slice( 0, compareSting.len() ) == compareSting )
		return

	if ( IsPartyLeader() && GetPartySize() == 1 && !IsExemptFromTraining() && !IsTrainingCompleted() )
	{
		Lobby_SetSelectedPlaylist( PLAYLIST_TRAINING )
	}
	else if ( !file.playlists.contains( file.selectedPlaylist ) )
	{
                            
			if ( IsTournamentMatchmaking() )
				return
        

		string newPlaylist = GetDefaultPlaylist()
		if ( file.selectedPlaylist != "" )
		{
			string uiSlot         = GetPlaylistVarString( file.selectedPlaylist, "ui_slot", "" )
			string playlistInSlot = GetCurrentPlaylistInUiSlot( uiSlot )
			if ( playlistInSlot != "" )
				newPlaylist = playlistInSlot
		}

		if ( IsPartyLeader() )
		{
			Lobby_SetSelectedPlaylist( newPlaylist )
		}
	}
}


void function PulseModeButton()
{
	var rui = Hud_GetRui( file.modeButton )
	RuiSetGameTime( rui, "startPulseTime", Time() )
}


void function Ranked_OnPartyMemberAdded()
{
	file.haveShownPartyMemberMatchmakingDelay = false
	TryShowMatchmakingDelayDialog()
}


void function UpdateCurrentMaxMatchmakingDelayEndTime()
{
	file.currentMaxMatchmakingDelayEndTime = Ranked_GetMaxPartyMatchmakingDelay() + Time()
}


void function TryShowMatchmakingDelayDialog()
{
	if ( !ShouldShowMatchmakingDelayDialog() )
		return

	DialogFlow()
}


bool function ShouldShowMatchmakingDelayDialog()
{
	if ( !IsLobby() )
		return false

	if ( !IsFullyConnected() )
		return false

	if ( GetActiveMenu() != GetMenu( "LobbyMenu" ) )
		return false

	if ( !IsTabPanelActive( GetPanel( "PlayPanel" ) ) )
		return false

	bool amIbanned = false

	array< PartyMember > bannedPartyMembers
	foreach ( index, member in GetParty().members )
	{
		CommunityUserInfo ornull userInfoOrNull = GetUserInfo( member.hardware, member.uid )
		if ( userInfoOrNull != null )
		{
			CommunityUserInfo userInfo = expect CommunityUserInfo( userInfoOrNull )
			int matchMakingDelay       = Ranked_GetMatchmakingDelayFromCommunityUserInfo( userInfo )
			if ( matchMakingDelay > 0 )
			{
				bannedPartyMembers.append( member )

				if ( GetPlayerUID() == userInfo.uid )//
				{
					amIbanned = true
				}
			}
		}
	}

	if ( bannedPartyMembers.len() == 0 )
		return false

	if ( amIbanned && bannedPartyMembers.len() == 1 && file.haveShownSelfMatchmakingDelay )
		return false

	return !(file.haveShownPartyMemberMatchmakingDelay)
}


void function ShowMatchmakingDelayDialog()
{
	bool amIbanned = false

	array< PartyMember > bannedPartyMembers
	int maxDelayTime = -1
	foreach ( index, member in GetParty().members )
	{
		CommunityUserInfo ornull userInfoOrNull = GetUserInfo( member.hardware, member.uid )
		if ( userInfoOrNull != null )
		{
			CommunityUserInfo userInfo = expect CommunityUserInfo( userInfoOrNull )
			int matchMakingDelay       = Ranked_GetMatchmakingDelayFromCommunityUserInfo( userInfo )
			if ( matchMakingDelay > 0 )
			{
				bannedPartyMembers.append( member )

				if ( GetPlayerUID() == userInfo.uid ) //
				{
					amIbanned = true
				}

				if ( matchMakingDelay > maxDelayTime )
					maxDelayTime = matchMakingDelay
			}
		}
	}

	Assert( bannedPartyMembers.len() > 0 )
	ConfirmDialogData dialogData
	dialogData.resultCallback = void function ( int result )
	{
		DialogFlow()
	}

	if ( amIbanned && bannedPartyMembers.len() == 1 )
	{
		if ( !file.haveShownSelfMatchmakingDelay )
		{
			dialogData.headerText = "#RANKED_ABANDON_PENALTY_HEADER"
			dialogData.messageText = "#RANKED_ABANDON_PENALTY_MESSAGE"
			file.haveShownSelfMatchmakingDelay = true
		}
	}
	else
	{
		file.haveShownPartyMemberMatchmakingDelay = true
		switch( bannedPartyMembers.len() ) //
		{
			case 1:
				dialogData.headerText = "#RANKED_ONE_PARTY_MEMBER_ABANDON_PENALTY_HEADER"
				dialogData.messageText = Localize( "#RANKED_ONE_PARTY_MEMBER_ABANDON_PENALTY_MESSAGE", bannedPartyMembers[ 0 ].name )
				break

			case 2:
				dialogData.headerText = "#RANKED_TWO_PARTY_MEMBER_ABANDON_PENALTY_HEADER"
				dialogData.messageText = Localize( "#RANKED_TWO_PARTY_MEMBER_ABANDON_PENALTY_MESSAGE", bannedPartyMembers[ 0 ].name, bannedPartyMembers[ 1 ].name )
				break

			case 3:
				dialogData.headerText = "#RANKED_ALL_PARTY_MEMBERS_ABANDON_PENALTY_HEADER"
				dialogData.messageText = Localize( "#RANKED_ALL_PARTY_MEMBERS_ABANDON_PENALTY_MESSAGE", bannedPartyMembers[ 0 ].name, bannedPartyMembers[ 1 ].name, bannedPartyMembers[ 2 ].name )
				break

			default:
				unreachable
		}
	}

	dialogData.contextImage = $"ui/menu/common/dialog_notice"
	dialogData.timerEndTime = Time() + maxDelayTime

	OpenOKDialogFromData( dialogData )
}


bool function ShouldShowLastGameRankedAbandonForgivenessDialog()
{
	if ( !IsLobby() )
		return false

	if ( !IsFullyConnected() )
		return false

	if ( GetActiveMenu() != GetMenu( "LobbyMenu" ) )
		return false

	if ( !IsTabPanelActive( GetPanel( "PlayPanel" ) ) )
		return false

	if ( file.haveShownLastGameRankedAbandonForgivenessDialog )
		return false

	var lastGameAbandonForgiveness = GetRankedPersistenceData( GetUIPlayer(), "lastGameAbandonForgiveness" )

	if ( lastGameAbandonForgiveness == null )
		return false

	return expect bool ( lastGameAbandonForgiveness  )
}


void function ShowLastGameRankedAbandonForgivenessDialog()
{
	ConfirmDialogData dialogData
	dialogData.resultCallback = void function ( int result )
	{
		DialogFlow()
	}

	int numUsedForgivenessAbandons = expect int ( GetRankedPersistenceData( GetUIPlayer(), "numUsedForgivenessAbandons" ) )

	if ( numUsedForgivenessAbandons == GetCurrentPlaylistVarInt( "ranked_num_abandon_forgiveness_games", RANKED_NUM_ABANDON_FORGIVENESS_GAMES ) )
	{
		dialogData.headerText = "#RANKED_ABANDON_FORGIVENESS_LAST_CHANCE_HEADER"
		dialogData.messageText = "#RANKED_ABANDON_FORGIVENESS_LAST_CHANCE_MESSAGE"
	}
	else
	{
		dialogData.headerText = "#RANKED_ABANDON_FORGIVENESS_HEADER"
		dialogData.messageText = "#RANKED_ABANDON_FORGIVENESS_MESSAGE"
	}

	dialogData.contextImage = $"ui/menu/common/dialog_notice"

	file.haveShownLastGameRankedAbandonForgivenessDialog = true

	OpenOKDialogFromData( dialogData )
}


void function Ranked_OnLevelInit()
{
	if ( !IsLobby() )
		return

	file.haveShownSelfMatchmakingDelay = false
	file.haveShownLastGameRankedAbandonForgivenessDialog = false
	file.haveShownPartyMemberMatchmakingDelay = false
	file.currentMaxMatchmakingDelayEndTime = -1

	if ( !file.rankedInitialized ) //
	{
		AddCallbackAndCallNow_UserInfoUpdated( Ranked_OnUserInfoUpdatedForMatchmakingDelay )
		file.rankedInitialized = true
	}

	TryShowMatchmakingDelayDialog()
}


void function Ranked_OnUserInfoUpdatedForMatchmakingDelay( string hardware, string id )
{
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

	bool foundPartyMember = false

	foreach ( index, member in GetParty().members )
	{
		if ( cui.hardware != member.hardware && cui.uid != member.uid )
			continue

		foundPartyMember = true
		break
	}

	if ( !foundPartyMember )
		return

	int matchMakingDelay = Ranked_GetMaxPartyMatchmakingDelay()

	if ( matchMakingDelay > 0 )
	{
		file.currentMaxMatchmakingDelayEndTime = matchMakingDelay + Time()
		TryShowMatchmakingDelayDialog()
	}
}


void function Ranked_OnUserInfoUpdatedInPanelPlay( string hardware, string id )
{
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
		if ( file.rankedRUIToUpdate != null ) //
		{
			PopulateRuiWithRankedBadgeDetails( file.rankedRUIToUpdate, cui.rankScore, cui.rankedLadderPos )
		}
	}
}


array<int> POPUP_LEVEL_MARKERS = [ 25, 53, 77, 100 ]

void function Lobby_ShowCallToActionPopup()
{
	Signal( uiGlobal.signalDummy, "Lobby_ShowCallToActionPopup" )
	EndSignal( uiGlobal.signalDummy, "Lobby_ShowCallToActionPopup" )

	file.dialogFlowDidCausePotentiallyInterruptingPopup = false

	while( !EventChallengesDidRefreshOnUI() )
		WaitFrame()

	while ( !GRX_IsInventoryReady() )
		WaitFrame()

	if ( Lobby_ShowBattlePassPopup() )
		return

	if ( Lobby_ShowHeirloomShopPopup() )
		return

	if ( Lobby_ShowQuestPopup() )
		return

	if ( Lobby_ShowStoryEventDialoguePopup() )
		return

	if ( Lobby_ShowStoryEventChallengesPopup() )
		return
}


void function Lobby_HideCallToActionPopup()
{
	var popup = Hud_GetChild( file.panel, "PopupMessage" )
	Hud_Hide( popup )
}


bool function Lobby_ShowBattlePassPopup( bool forceShow = false )
{
	ItemFlavor ornull activeBattlePass = GetActiveBattlePass()

	if ( activeBattlePass == null )
		return false

	expect ItemFlavor( activeBattlePass )

	entity player = GetUIPlayer()

	if ( DoesPlayerOwnBattlePass( player, activeBattlePass ) && !forceShow )
		return false

	int currentXPProgress = GetPlayerBattlePassXPProgress( ToEHI( player ), activeBattlePass, false )
	int bpLevel           = GetBattlePassLevelForXP( activeBattlePass, currentXPProgress )

	BattlePassReward ornull rewardToShow = null

	int markerLevel = 0

	foreach ( level in POPUP_LEVEL_MARKERS )
	{
		if ( level - 1 <= bpLevel )
			markerLevel = level - 1
	}

	if ( markerLevel <= 0 && !forceShow )
		return false

	string bpString = ItemFlavor_GetGUIDString( activeBattlePass )

	if ( markerLevel <= player.GetPersistentVar( format( "battlePasses[%s].lastPopupLevel", bpString ) ) && !forceShow )
		return false

	array<BattlePassReward> rewards = GetBattlePassLevelRewards( activeBattlePass, markerLevel )

	foreach ( reward in rewards )
	{
		if ( !reward.isPremium )
			continue

		rewardToShow = reward
		break
	}

	if ( rewardToShow == null )
		return false

	expect BattlePassReward( rewardToShow )

	file.onCallToActionFunc = void function() : ()
	{
		JumpToSeasonTab( "PassPanel" )
		TabData tabData = GetTabDataForPanel( Hud_GetParent( file.panel ) )
		AdvanceMenu( GetMenu( "PassPurchaseMenu" ) )
		Lobby_HideCallToActionPopup()
	}

	thread function() : ( rewardToShow, bpLevel, bpString, markerLevel )
	{
		EndSignal( uiGlobal.signalDummy, "Lobby_ShowCallToActionPopup" )

		var popup = Hud_GetChild( file.panel, "PopupMessage" )
		Lobby_MovePopupMessage( 1 )
		RuiSetImage( Hud_GetRui( popup ), "buttonImage", CustomizeMenu_GetRewardButtonImage( rewardToShow.flav ) )
		int rarity = ItemFlavor_HasQuality( rewardToShow.flav ) ? ItemFlavor_GetQuality( rewardToShow.flav ) : 0
		RuiSetInt( Hud_GetRui( popup ), "rarity", rarity )
		RuiSetInt( Hud_GetRui( popup ), "level", bpLevel + 1 )
		BattlePass_SetTallButtonSettings( rewardToShow.flav, Hud_GetRui( popup ), null, false )
		BattlePass_SetUnlockedString( popup, bpLevel + 1 )

		HudElem_SetRuiArg( popup, "titleText", Localize( "#BATTLEPASS_POPUP_TITLE" ) )
		HudElem_SetRuiArg( popup, "subText", Localize( "#BATTLEPASS_POPUP_BODY", bpLevel + 1 ) )
		HudElem_SetRuiArg( popup, "detailText", Localize( "#BATTLEPASS_POPUP_UNLOCK" ) )

		wait 0.2

		while ( GetActiveMenu() != GetMenu( "LobbyMenu" ) || !IsPanelActive( file.panel ) )
			WaitFrame()

		RuiSetGameTime( Hud_GetRui( popup ), "animStartTime", Time() )
		Remote_ServerCallFunction( "ClientCallback_MarkBattlePassPopupAsSeen", bpString, markerLevel )
		EmitUISound( SOUND_BP_POPUP )
		thread CallToActionPopupThink( popup, 10.0 )
	}()

	return true
}


bool function Lobby_ShowHeirloomShopPopup( bool forceShow = false )
{
	if ( !GRX_IsInventoryReady() && !forceShow )
		return false

	int heirloomShardBalance = GRXCurrency_GetPlayerBalance( GetUIPlayer(), GRX_CURRENCIES[GRX_CURRENCY_HEIRLOOM] )
	int priceOfHeirloom      = GetCurrentPlaylistVarInt( "grx_currency_bundle_heirloom_count", 50 ) * 3
	if ( heirloomShardBalance < priceOfHeirloom && !forceShow )
		return false

	if ( GetUnixTimestamp() - expect int( GetPersistentVar( "heirloomShopLastSeen" ) ) < SECONDS_PER_DAY * 2 && !forceShow )
		return false

	file.onCallToActionFunc = void function() : ()
	{
		JumpToHeirloomShop()
		Lobby_HideCallToActionPopup()
	}

	thread function() : ()
	{
		EndSignal( uiGlobal.signalDummy, "Lobby_ShowCallToActionPopup" )

		TabData lobbyTabData = GetTabDataForPanel( GetMenu( "LobbyMenu" ) )
		int idx              = Tab_GetTabIndexByBodyName( lobbyTabData, "PassPanelV2" )
		var popup            = Hud_GetChild( file.panel, "PopupMessage" )

		HudElem_SetRuiArg( popup, "titleText", "#CTA_HEIRLOOM_SHOP_TITLE" )
		HudElem_SetRuiArg( popup, "subText", "#CTA_HEIRLOOM_SHOP_SUBTEXT" )
		HudElem_SetRuiArg( popup, "detailText", "#CTA_HEIRLOOM_SHOP_DETAIL" )
		HudElem_SetRuiArg( popup, "unlockedString", "" )
		HudElem_SetRuiArg( popup, "buttonImage", ItemFlavor_GetIcon( GRX_CURRENCIES[GRX_CURRENCY_HEIRLOOM] ), eRuiArgType.IMAGE )
		HudElem_SetRuiArg( popup, "forceFullIcon", false )
		HudElem_SetRuiArg( popup, "rarity", eRarityTier.HEIRLOOM )

		HudElem_SetRuiArg( popup, "altStyle1Color", <0.55, 0.55, 0.55> )
		HudElem_SetRuiArg( popup, "altStyle2Color", <1.0, 1.0, 1.0> )
		HudElem_SetRuiArg( popup, "altStyle3Color", SrgbToLinear( GetKeyColor( COLORID_MENU_TEXT_LOOT_TIER0, eRarityTier.HEIRLOOM ) / 255.0 ) )

		Lobby_MovePopupMessage( 2 )
		//
		//
		//
		//
		//
		//
		//

		wait 0.2

		while ( GetActiveMenu() != GetMenu( "LobbyMenu" ) || !IsPanelActive( file.panel ) )
			WaitFrame()

		RuiSetGameTime( Hud_GetRui( popup ), "animStartTime", Time() )
		Remote_ServerCallFunction( "ClientCallback_MarkHeirloomShopPopupAsSeen" )
		EmitUISound( SOUND_BP_POPUP )
		thread CallToActionPopupThink( popup, 10.0 )
	}()

	return true
}


bool function Lobby_ShowQuestPopup( bool forceShow = false )
{
	if ( GetUnixTimestamp() - expect int( GetPersistentVar( "questPopupLastSeen" ) ) < SECONDS_PER_DAY * 2 && !forceShow )
		return false

	ItemFlavor ornull quest = SeasonQuest_GetActiveSeasonQuest( GetUnixTimestamp() )
	if ( quest == null )
		return false

	expect ItemFlavor( quest )

	entity player = GetUIPlayer()

	bool isComic     = false
	int missionCount = SeasonQuest_GetMissionsMaxCount( quest )

	if ( missionCount == 0 )
	{
		missionCount = SeasonQuest_GetComicPagesMaxCount( quest )
		isComic = true
	}

	int missionIndex = -1
	for ( int index = 0; index < missionCount; index++ )
	{
		bool launchable = isComic ? SeasonQuest_GetStatusForComicPageIndex( player, quest, index ) == eQuestMissionStatus.LAUNCHABLE : SeasonQuest_GetStatusForMissionIndex( player, quest, index ) == eQuestMissionStatus.LAUNCHABLE

		if ( launchable )
		{
			missionIndex = index
			break
		}
	}

	//
	if ( missionIndex < 0 )
		return false

	file.onCallToActionFunc = void function() : ()
	{
		JumpToSeasonTab( "QuestPanel" )
		Lobby_HideCallToActionPopup()
	}

	thread function() : ( quest, missionIndex, isComic )
	{
		EndSignal( uiGlobal.signalDummy, "Lobby_ShowCallToActionPopup" )

		TabData lobbyTabData = GetTabDataForPanel( GetMenu( "LobbyMenu" ) )
		var popup            = Hud_GetChild( file.panel, "PopupMessage" )

		ItemFlavor mission = isComic ? SeasonQuest_GetComicPageForIndex( quest, missionIndex ) : SeasonQuest_GetMissionForIndex( quest, missionIndex )

		HudElem_SetRuiArg( popup, "titleText", isComic ? "#CTA_QUEST_COMIC_TITLE" : "#CTA_QUEST_TITLE" )
		HudElem_SetRuiArg( popup, "subText", Localize( (isComic ? "#CTA_QUEST_COMIC_SUBTEXT" : "#CTA_QUEST_SUBTEXT"), string( missionIndex + 1 ), Localize( ItemFlavor_GetLongName( mission ) ) ) )
		HudElem_SetRuiArg( popup, "detailText", "#CTA_QUEST_DETAIL" )
		HudElem_SetRuiArg( popup, "unlockedString", "" )
		HudElem_SetRuiArg( popup, "buttonImage", isComic ? SeasonQuest_GetComicPagesIconForIndex( quest, missionIndex ) : SeasonQuest_GetMissionIconForMissionIndex( quest, missionIndex ), eRuiArgType.IMAGE )
		HudElem_SetRuiArg( popup, "forceFullIcon", false )
		HudElem_SetRuiArg( popup, "rarity", eRarityTier.LEGENDARY )

		HudElem_SetRuiArg( popup, "altStyle1Color", <0.55, 0.55, 0.55> )
		HudElem_SetRuiArg( popup, "altStyle2Color", <1.0, 1.0, 1.0> )
		HudElem_SetRuiArg( popup, "altStyle3Color", SrgbToLinear( GetKeyColor( COLORID_MENU_TEXT_LOOT_TIER0, eRarityTier.HEIRLOOM ) / 255.0 ) )

		Lobby_MovePopupMessage( 0, 0.288 )

		wait 0.2

		while ( GetActiveMenu() != GetMenu( "LobbyMenu" ) || !IsPanelActive( file.panel ) )
			WaitFrame()

		RuiSetGameTime( Hud_GetRui( popup ), "animStartTime", Time() )
		Remote_ServerCallFunction( "ClientCallback_MarkQuestPopupAsSeen" )
		EmitUISound( SOUND_BP_POPUP )
		thread CallToActionPopupThink( popup, 10.0 )
	}()

	return true
}


bool function Lobby_ShowStoryEventDialoguePopup( bool forceShow = false )
{
	ItemFlavor ornull storyChallengeEventOrNull = GetActiveStoryChallengeEvent( GetUnixTimestamp() )
	if ( storyChallengeEventOrNull == null )
		return false
	ItemFlavor storyChallengeEvent = expect ItemFlavor( storyChallengeEventOrNull )

	entity player = GetUIPlayer()

	//
	array<StoryEventDialogueData> dialogueDatas = StoryChallengeEvent_GetAppropriateDialogueDatasForPlayer( storyChallengeEvent, player )

	if ( dialogueDatas.len() < 1 )
		return false

	//
	bool hasSeenSomeDialogue = false
	foreach ( StoryEventDialogueData data in dialogueDatas )
	{
		if ( data.persistenceVarNameHasSeenOrNull != null && GetPersistentVarAsInt( expect string( data.persistenceVarNameHasSeenOrNull ) ) > 0 )
		{
			hasSeenSomeDialogue = true
			break
		}
	}

	if ( hasSeenSomeDialogue )
	{
		if ( GetUnixTimestamp() - expect int( GetPersistentVar( "storyEventDialoguePopupLastSeen" ) ) < SECONDS_PER_DAY * 2 && !forceShow )
			return false
	}

	//
	thread function() : ( dialogueDatas )
	{
		EndSignal( uiGlobal.signalDummy, "Lobby_ShowCallToActionPopup" )

		var popup = Hud_GetChild( file.panel, "StoryEventsMessage" )
		var rui   = Hud_GetRui( popup )

		foreach ( StoryEventDialogueData data in dialogueDatas )
		{
			RuiSetBool( rui, "shouldHideInMenu", false )
			RuiSetString( rui, "displayText", data.bodyText )
			RuiSetString( rui, "speakerName", data.speakerName )
			RuiSetImage( rui, "portraitImage", data.speakerIcon )

			wait 0.5

			while ( GetActiveMenu() != GetMenu( "LobbyMenu" ) || !IsPanelActive( file.panel ) )
				WaitFrame()

			RuiSetFloat( rui, "soundDuration", data.duration )
			RuiSetGameTime( rui, "startTimeOverride", Time() )

			thread CallToActionDialoguePopupAudioThink( popup, data )
			waitthread CallToActionDialoguePopupThink( popup, data )
		}
	}()

	return true
}


bool function Lobby_ShowStoryEventChallengesPopup( bool forceShow = false )
{
	ItemFlavor ornull storyChallengeEventOrNull = GetActiveStoryChallengeEvent( GetUnixTimestamp() )
	if ( storyChallengeEventOrNull == null )
		return false
	ItemFlavor storyChallengeEvent = expect ItemFlavor( storyChallengeEventOrNull )

	entity player = GetUIPlayer()

	array<ItemFlavor> appropriateSpecialEventChallenges = StoryChallengeEvent_GetAppropriateChallengesForPlayer( storyChallengeEvent, player )
	bool hasSeenPopupForSomeChallenges                  = false
	array<ItemFlavor> activeChallenges
	array<string> hasSeenPersistenceVarNames

	foreach ( ItemFlavor challenge in appropriateSpecialEventChallenges )
	{
		//
		if ( Challenge_IsAssigned( player, challenge ) && !Challenge_IsComplete( player, challenge ) )
		{
			activeChallenges.append( challenge )

			string ornull hasSeenPersistenceVarNameOrNull = StoryChallengeEvent_GetHasChallengesPopupBeenSeenVarNameOrNull( challenge, player )
			if ( hasSeenPersistenceVarNameOrNull != null && !hasSeenPersistenceVarNames.contains( expect string ( hasSeenPersistenceVarNameOrNull ) ) )
				hasSeenPersistenceVarNames.append( expect string ( hasSeenPersistenceVarNameOrNull ) )

			if ( StoryChallengeEvent_HasChallengesPopupBeenSeen( challenge, player ) )
				hasSeenPopupForSomeChallenges = true
		}
	}

	if ( activeChallenges.len() == 0 )
		return false

	if ( hasSeenPersistenceVarNames.len() == 0 )
		return false

	//
	if ( hasSeenPopupForSomeChallenges )
	{
		if ( GetUnixTimestamp() - expect int( GetPersistentVar( "storyEventChallengesPopupLastSeen" ) ) < SECONDS_PER_DAY * 2 && !forceShow )
			return false
	}

	file.onCallToActionFunc = void function() : ()
	{
		JumpToSeasonTab( "ChallengesPanel" )
		AllChallengesMenu_ForceClickSpecialEventButton()
		Lobby_HideCallToActionPopup()
	}

	thread function() : ( hasSeenPersistenceVarNames )
	{
		EndSignal( uiGlobal.signalDummy, "Lobby_ShowCallToActionPopup" )

		TabData lobbyTabData = GetTabDataForPanel( GetMenu( "LobbyMenu" ) )
		var popup            = Hud_GetChild( file.panel, "PopupMessage" )

		//
		//
		HudElem_SetRuiArg( popup, "detailText", "" )
		HudElem_SetRuiArg( popup, "unlockedString", "" )
		//
		HudElem_SetRuiArg( popup, "forceFullIcon", false )
		//

		HudElem_SetRuiArg( popup, "altStyle1Color", <0.55, 0.55, 0.55> )
		HudElem_SetRuiArg( popup, "altStyle2Color", <1.0, 1.0, 1.0> )
		HudElem_SetRuiArg( popup, "altStyle3Color", SrgbToLinear( GetKeyColor( COLORID_MENU_TEXT_LOOT_TIER0, eRarityTier.HEIRLOOM ) / 255.0 ) )

		Lobby_MovePopupMessage( 0, 0.288 )

		wait 0.2

		while ( GetActiveMenu() != GetMenu( "LobbyMenu" ) || !IsPanelActive( file.panel ) )
			WaitFrame()

		RuiSetGameTime( Hud_GetRui( popup ), "animStartTime", Time() )
		EmitUISound( SOUND_BP_POPUP )

		foreach ( string varName in hasSeenPersistenceVarNames )
			Remote_ServerCallFunction( "ClientCallback_MarkStoryEventChallengesPopupAsSeen", true, varName )

		thread CallToActionPopupThink( popup, 10.0 )
	}()

	return true
}


void function CallToActionPopupThink( var popup, float timeout )
{
	Signal( uiGlobal.signalDummy, "CallToActionPopupThink" )
	EndSignal( uiGlobal.signalDummy, "CallToActionPopupThink" )

	OnThreadEnd(
		function() : ( popup )
		{
			Hud_Hide( popup )
		}
	)

	Hud_Show( popup )

	wait timeout

	while ( GetFocus() == popup )
		wait 0.25
}


void function CallToActionDialoguePopupAudioThink( var popup, StoryEventDialogueData data )
{
	Signal( uiGlobal.signalDummy, "CallToActionPopupAudioThink" )
	EndSignal( uiGlobal.signalDummy, "CallToActionPopupAudioThink" )
	EndSignal( uiGlobal.signalDummy, "CallToActionPopupAudioCancel" )

	OnThreadEnd(
		function() : ( data )
		{
			foreach ( string alias in data.audioAliases )
				StopUISoundByName( alias )
		}
	)

	EmitUISound( "SQ_UI_InGame_CommChime" )

	foreach ( string alias in data.audioAliases )
	{
		var handle = EmitUISound( alias )

		WaitSignal( handle, "OnSoundFinished" )
	}
}


void function CallToActionDialoguePopupThink( var popup, StoryEventDialogueData data )
{
	const float DIALOGUE_FADE_OUT_TIME = 1.0

	Signal( uiGlobal.signalDummy, "CallToActionPopupThink" )
	EndSignal( uiGlobal.signalDummy, "CallToActionPopupThink" )

	table<string, bool> results = { hasSeen = false }

	OnThreadEnd(
		function() : ( popup, data, results )
		{
			if ( results.hasSeen && !file.dialogFlowDidCausePotentiallyInterruptingPopup )
			{
				string str      = data.persistenceVarNameHasSeenOrNull != null ? expect string( data.persistenceVarNameHasSeenOrNull ) : ""
				bool extraParam = data.persistenceVarNameHasSeenOrNull != null
				Remote_ServerCallFunction( "ClientCallback_MarkStoryEventDialoguePopupAsSeen", extraParam, str )
			}

			Hud_Hide( popup )
			Signal( uiGlobal.signalDummy, "CallToActionPopupAudioCancel" )
		}
	)

	Hud_Show( popup )

	float totalDuration = data.duration + DIALOGUE_FADE_OUT_TIME
	float startTime     = Time()

	float timeToWaitForMarkedAsSeen = data.duration

	//
	while ( true )
	{
		if ( GetActiveMenu() != GetMenu( "LobbyMenu" ) || !IsPanelActive( file.panel ) )
			break

		WaitFrame()

		float elapsedTime = Time() - startTime

		if ( !results.hasSeen && elapsedTime >= timeToWaitForMarkedAsSeen )
			results.hasSeen = true

		if ( elapsedTime >= totalDuration )
			break
	}
}


void function DialogFlow_DidCausePotentiallyInterruptingPopup()
{
	file.dialogFlowDidCausePotentiallyInterruptingPopup = true
}


void function OnClickCallToActionPopup( var button )
{
	file.onCallToActionFunc()
}


void function Lobby_MovePopupMessage( int tabIndex, float additionalOffsetFrac = 0.0 )
{
	var button = Hud_GetChild( file.panel, "PopupMessage" )

	var lobbyTabs = Hud_GetChild( GetMenu( "LobbyMenu" ), "TabsCommon" )

	var tabButton = Hud_GetChild( lobbyTabs, "Tab0" )

	int offset = 0
	if ( tabIndex==0 )
	{
		offset += Hud_GetX( tabButton )
		offset += int( Hud_GetWidth( tabButton ) * additionalOffsetFrac )
	}
	else
	{
		for ( int i = 0; i < tabIndex; i++ )
		{
			var bt = Hud_GetChild( lobbyTabs, "Tab" + i )
			offset += Hud_GetWidth( bt )
			offset += Hud_GetX( bt )
			offset += int( Hud_GetWidth( tabButton ) * additionalOffsetFrac )
		}
	}

	Hud_SetX( button, offset )
}

                       
                                   
 
                           
 
      