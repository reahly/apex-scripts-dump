
global function InitSocialEventPopup
global function SocialEventUpdate
global function IsSocialPopUpAClubInvite
global function IsSocialPopupActive

#if(DEV)
global function SocialEvent_AddDevEvent
global function DevDumpFakeLists
global function DevRemoveFakeData
#endif


const BAR_COLOR_FRIEND = <29, 162, 255>
const BAR_COLOR_PARTY = <255, 78, 29>
const BAR_COLOR_CLUB = <94, 6, 203>


enum eSocialEventType
{
	PARTY,
	FRIEND,
	CLUB
}


struct SocialEvent
{
	string name
	string eventID
	int    entryIndex
	int    hardwareID = -1 //
	int    eventType
	bool   completed
	bool   active
	float  timeStamp
}


struct
{
	var eventPanel
	var contentPanel
	array<var> buttonArray

	LobbyPopup         socialEventPopup
	array<SocialEvent> socialEventCache
	SocialEvent&       activeSocialEvent

	bool socialPopupActive
	bool activeEventInvalid
	bool blockInput

} file


void function InitSocialEventPopup( var panel )
{
	file.eventPanel = panel
	file.contentPanel = Hud_GetChild( panel, "Content" )

	file.buttonArray.append( Hud_GetChild( panel, "AcceptButton" ) )
	file.buttonArray.append( Hud_GetChild( panel, "RejectButton" ) )
	file.buttonArray.append( Hud_GetChild( panel, "BlockButton" ) )

	//
	Hud_AddEventHandler( file.buttonArray[0], UIE_CLICK, void function( var btn ) { EventFriendRequest_HandleInput( KEY_Y ) } ) //
	Hud_AddEventHandler( file.buttonArray[1], UIE_CLICK, void function( var btn ) { EventFriendRequest_HandleInput( KEY_N ) } ) //
	Hud_AddEventHandler( file.buttonArray[2], UIE_CLICK, void function( var btn ) { EventFriendRequest_HandleInput( KEY_B ) } ) //

	file.socialEventPopup.onClose = SocialEventPopup_OnClose
	file.socialEventPopup.checkBlocksInput = EventFriendRequest_CheckBlocksInput
	file.socialEventPopup.handleInput = EventFriendRequest_HandleInput

	AddCallback_OnPartyUpdated( SocialEventUpdate )

	RegisterSignal( "SocialEventPopupClosed" )
}


void function SocialEventUpdate()
{
	if ( IsDialog( GetActiveMenu() ) || !IsLobby() )
		return

	file.activeEventInvalid = false

	UpdateFriendRequestCache()
	UpdatePartyInviteCache()
	UpdateClubInviteCache()

	SocialEvent_TryPurgeCrossplayFriendRequests()
	SocialEvent_TryPurgeCrossplayPartyInvites()

	SortSocialEventCache()

	if ( HasActiveLobbyPopup() )
	{
		if ( file.activeEventInvalid || GetPendingSocialEvent() != file.activeSocialEvent )
			TryShowNextSocialEvent()

		return
	}

	SocialEvent ornull event = GetPendingSocialEvent()
	if ( event == null )
		return
	expect SocialEvent( event )

	SetActiveSocialEvent( event )
	UpdateSocialEventRui( event )
	ShowSocialEventPopup( event )
	SetActiveLobbyPopup( file.socialEventPopup )

	thread BlockInputForDuration( 1.2 )
}


void function SocialEvent_TryPurgeCrossplayFriendRequests()
{
	if ( IsMatchPreferenceFlagActive( eMatchPreferenceFlags.CROSSPLAY_INVITE_AUTO_DENY ) )
	{
		array<SocialEvent> events = clone file.socialEventCache
		foreach ( SocialEvent event in events )
		{
			if ( event.eventType == eSocialEventType.FRIEND )
			{
				EADP_RejectFriendRequestByEAID( event.eventID )
				int pos = file.socialEventCache.find( event )
				file.socialEventCache.remove( pos )
			}
		}
	}
}


void function SocialEvent_TryPurgeCrossplayPartyInvites()
{
	//
	array<SocialEvent> events = clone file.socialEventCache
	foreach ( SocialEvent event in events )
	{
		if(  event.hardwareID  > 0 )
		{
			string hardware = GetNameFromeHardware( event.hardwareID )

			//
			if ( event.hardwareID == HARDWARE_PC_STEAM )
				hardware = GetNameFromeHardware( HARDWARE_PC ) //

			if ( event.eventType == eSocialEventType.PARTY && IsInPartyWithHardware( event.eventID, hardware ) )
			{
				EADP_RejectInviteToPlay( event.eventID )
				int pos = file.socialEventCache.find( event )
				file.socialEventCache.remove( pos )
			}
		}
	}
}


bool function IsInPartyWithHardware( string id, string hardware )
{
	Party party = GetParty()
	foreach (partyMember in party.members)
	{
		if ( partyMember.eaid == id && partyMember.hardware == hardware )
			return true
	}

	return false
}


void function SortSocialEventCache()
{
	file.socialEventCache.sort( int function( SocialEvent a, SocialEvent b ) {
		if ( a.eventType < b.eventType )
			return -1
		if ( b.eventType < a.eventType )
			return 1

		if ( a.timeStamp < b.timeStamp )
			return -1
		if ( b.timeStamp < a.timeStamp )
			return 1

		if ( a.entryIndex < b.entryIndex )
			return -1
		if ( b.entryIndex < a.entryIndex )
			return 1

		return 0
	} )
}


SocialEvent ornull function GetPendingSocialEvent()
{
	foreach ( SocialEvent event in file.socialEventCache )
	{
		//
		if ( IsValidSocialEvent( event ) )
			return event
	}
	return null
}


void function SetActiveSocialEvent( SocialEvent event )
{
	file.activeSocialEvent = event
}


SocialEvent function GetActiveSocialEvent()
{
	return file.activeSocialEvent
}


void function UpdateSocialEventRui( SocialEvent event )
{
	HudElem_SetRuiArg( file.contentPanel, "actionTaken", -1 )

	HudElem_SetRuiArg( file.contentPanel, "eventSubText", event.name )
	HudElem_SetRuiArg( file.contentPanel, "eventActionHint1", "#POPUP_BUTTON_ACCEPT" )
	HudElem_SetRuiArg( file.contentPanel, "eventActionHint2", "#POPUP_BUTTON_REJECT" )
	HudElem_SetRuiArg( file.contentPanel, "hardwareIconStr", PlatformIDToIconString( event.hardwareID ) )
	RuiDestroyNestedIfAlive( Hud_GetRui( file.contentPanel ), "clubLogo" )

	switch ( event.eventType )
	{
		case eSocialEventType.FRIEND:
			HudElem_SetRuiArg( file.contentPanel, "eventHeader", "#FRIEND_REQUEST" )
			HudElem_SetRuiArg( file.contentPanel, "eventActionHint3", "#POPUP_BUTTON_BLOCK" )
			RuiSetArgByType( Hud_GetRui( file.contentPanel ), "lineColor", BAR_COLOR_FRIEND / 255.0, eRuiArgType.COLOR )
			break

		case eSocialEventType.PARTY:
			string eventHeader = "#PARTY_INVITE"
			if ( Clubs_IsUserAClubmate( event.eventID ) )
				eventHeader = "#CLUB_POPUP_PARTY_INVITE"

			HudElem_SetRuiArg( file.contentPanel, "eventHeader", eventHeader )
			HudElem_SetRuiArg( file.contentPanel, "eventActionHint3", "#POPUP_BUTTON_BLOCK" )
			RuiSetArgByType( Hud_GetRui( file.contentPanel ), "lineColor", BAR_COLOR_PARTY / 255.0, eRuiArgType.COLOR )

#if(DEV)
			if ( GetBugReproNum() == 1970 )
				ClubLogoUI_CreateNestedClubLogo( Hud_GetRui( file.contentPanel ), "clubLogo", GenerateRandomClubLogo() )
#endif
			if ( Clubs_IsUserAClubmate( event.eventID ) )
			{
				//
				ClubLogo logo = ClubLogo_ConvertLogoStringToLogo( ClubGetHeader().logoString )
				ClubLogoUI_CreateNestedClubLogo( Hud_GetRui( file.contentPanel ), "clubLogo", logo )
			}
			break

		case eSocialEventType.CLUB:
			HudElem_SetRuiArg( file.contentPanel, "eventHeader", "#CLUB_POPUP_INVITE" )
			HudElem_SetRuiArg( file.contentPanel, "eventActionHint3", "" )
			RuiSetArgByType( Hud_GetRui( file.contentPanel ), "lineColor", BAR_COLOR_CLUB / 255.0, eRuiArgType.COLOR )
			//
			break
	}

	UpdateButtons()
}


void function ShowSocialEventPopup( SocialEvent event )
{
	file.socialPopupActive = true
	Hud_Show( file.eventPanel )

	HudElem_SetRuiArg( file.contentPanel, "shouldShow", true )
}


bool function IsValidSocialEvent( SocialEvent event )
{
	if ( event.completed )
		return false

	if ( event.eventType == eSocialEventType.CLUB )
	{
		if ( ClubIsValid() ) //
			return false

		//
		string matchmakingStatus = GetMyMatchmakingStatus()
		if ( matchmakingStatus != "" )
			return false
	}

	if ( event.eventType == eSocialEventType.PARTY )
	{
		//
		if ( Clubs_IsUserAClubmate( event.eventID ) && GetPartySize() > 1 )
			return false
	}

	return true
}


void function UpdateFriendRequestCache()
{
	EadpPeopleList requestData = EADP_GetFriendRequestList()
	if ( !requestData.isValid )
		return

	#if(DEV)
		if ( GetBugReproNum() == 1970 )
		{
			requestData.people.extend( DevGetFakeFriendList() )
		}
	#endif

	for ( int cacheIndex = 0; cacheIndex < file.socialEventCache.len(); cacheIndex++ )
	{
		SocialEvent event = file.socialEventCache[ cacheIndex ]

		if ( event.completed || event.eventType != eSocialEventType.FRIEND )
			continue    //

		bool eventValid = false
		foreach ( int index, EadpPeopleData request in requestData.people )
		{
			if ( event.eventID == request.eaid )
			{
				requestData.people.remove( index )
				eventValid = true
				break //
			}
		}

		if ( !eventValid )
		{
			//
			file.socialEventCache.remove( cacheIndex )
			cacheIndex-- //

			SocialEvent activeEvent = GetActiveSocialEvent()
			if ( activeEvent == event )
				file.activeEventInvalid = true
			continue
		}
	}

	foreach ( EadpPeopleData request in requestData.people )
	{
		if ( IsInEventCashe( request.eaid, eSocialEventType.FRIEND ) )
			continue

		SocialEvent newEvent
		newEvent.eventType = eSocialEventType.FRIEND
		newEvent.name = request.platformName
		newEvent.eventID = request.eaid
		newEvent.hardwareID = GetHardwareFromName( request.platformHardware )
		newEvent.timeStamp = Time()
		newEvent.entryIndex = file.socialEventCache.len()

		file.socialEventCache.append( newEvent )
	}
}


void function UpdatePartyInviteCache()
{
	EadpInviteToPlayList inviteToPlayList = EADP_GetInviteToPlayList()
	if ( !inviteToPlayList.isValid )
		return

	if ( !IsLobby() )
		return

	#if(DEV)
		if ( GetBugReproNum() == 1970 )
		{
			inviteToPlayList.invitations.extend( DevGetFakePartyList() )
		}
	#endif

	for ( int cacheIndex = 0; cacheIndex < file.socialEventCache.len(); cacheIndex++ )
	{
		SocialEvent event = file.socialEventCache[ cacheIndex ]

		if ( event.completed || event.eventType != eSocialEventType.PARTY )
			continue    //

		bool eventValid = false
		foreach ( int index, EadpInviteToPlayData invite in inviteToPlayList.invitations )
		{
			if ( event.eventID == invite.eaid )
			{
				inviteToPlayList.invitations.remove( index )
				eventValid = true
				break //
			}
		}

		if ( !eventValid )
		{
			//
			file.socialEventCache.remove( cacheIndex )
			cacheIndex--    //

			SocialEvent activeEvent = GetActiveSocialEvent()
			if ( activeEvent == event )
				file.activeEventInvalid = true
			continue
		}
	}

	foreach ( EadpInviteToPlayData invite in inviteToPlayList.invitations )
	{
		if ( IsInEventCashe( invite.eaid, eSocialEventType.PARTY ) )
			continue

		string eaid = GetUIPlayer().GetPINNucleusId()
		int hardwareId = GetHardwareFromName( GetUnspoofedPlayerHardware() )

		if ( invite.eaid == eaid && invite.hardware == hardwareId )
			continue //

		SocialEvent newEvent
		newEvent.eventType = eSocialEventType.PARTY
		newEvent.name = invite.name
		newEvent.eventID = invite.eaid
		newEvent.hardwareID = invite.hardware
		newEvent.timeStamp = Time()
		newEvent.entryIndex = file.socialEventCache.len()

		file.socialEventCache.append( newEvent )
	}
}


void function UpdateClubInviteCache()
{
	if ( !IsPersistenceAvailable() )
	{
		return
	}

	array<ClubInvite> clubInviteList = ClubGetInvitedClubsList()
	if ( !Clubs_DoIMeetMinimumLevelRequirement() )
	{
		printf( "ClubInviteDebug: Not displaying Club Invites because I'm not at least level %i", CLUB_JOIN_MIN_ACCOUNT_LEVEL + 1 )
		return
	}

	if ( !AreClubInvitesEnabled() )
	{
		printf( "ClubInviteDebug: Not displaying Club Invites because I've disabled them." )
		return
	}

	#if(DEV)
		if ( GetBugReproNum() == 1970 )
		{
			clubInviteList.extend( DevGetFakeClubList() )
		}
	#endif

	for ( int cacheIndex = 0; cacheIndex < file.socialEventCache.len(); cacheIndex++ )
	{
		SocialEvent event = file.socialEventCache[ cacheIndex ]

		if ( event.completed || event.eventType != eSocialEventType.CLUB )
			continue    //

		bool eventValid = false
		foreach ( int index, ClubInvite invite in clubInviteList )
		{
			if ( event.eventID == invite.clubID )
			{
				clubInviteList.remove( index )
				eventValid = true
				break //
			}
		}

		if ( !eventValid )
		{
			//
			file.socialEventCache.remove( cacheIndex )
			cacheIndex--    //

			SocialEvent activeEvent = GetActiveSocialEvent()
			if ( activeEvent == event )
				file.activeEventInvalid = true
			continue
		}
	}

	foreach ( ClubInvite invite in clubInviteList )
	{
		if ( IsInEventCashe( invite.clubID, eSocialEventType.CLUB ) )
			continue

		SocialEvent newEvent
		newEvent.eventType = eSocialEventType.CLUB
		newEvent.name = invite.name
		newEvent.eventID = invite.clubID
		newEvent.hardwareID = -1
		newEvent.timeStamp = Time()
		newEvent.entryIndex = file.socialEventCache.len()

		file.socialEventCache.append( newEvent )
	}
}


bool function IsInEventCashe( string eventID, int eventType )
{
	foreach ( SocialEvent event in file.socialEventCache )
	{
		if ( event.eventID == eventID && event.eventType == eventType )
			return true
	}
	return false
}


void function BlockInputForDuration( float duration )
{
	Assert( IsNewThread(), "Must be threaded off." )
	EndSignal( uiGlobal.signalDummy, "SocialEventPopupClosed" )

	OnThreadEnd( function() {
		file.blockInput = false
		UpdateButtons()
	} )

	file.blockInput = true
	UpdateButtons()

	wait duration
}


void function UpdateButtons()
{
	foreach ( button in file.buttonArray )
	{
		if ( file.blockInput )
			Hud_Hide( button )
		else
			Hud_Show( button )
	}

	if ( file.activeEventInvalid || file.activeSocialEvent.eventType == eSocialEventType.CLUB )
		Hud_Hide( file.buttonArray[2] ) //
}


void function SocialEventPopup_OnClose()
{
	//
	Signal( uiGlobal.signalDummy, "SocialEventPopupClosed" )

	HudElem_SetRuiArg( file.contentPanel, "shouldShow", false )

	file.blockInput = false
	file.socialEventCache.clear()
	file.socialPopupActive = false
	Hud_Hide( file.eventPanel )
}


bool function EventFriendRequest_CheckBlocksInput( int inputID )
{
	if ( inputID == BUTTON_X || inputID == KEY_N || inputID == KEY_Y || inputID == BUTTON_Y || inputID == BUTTON_STICK_LEFT || inputID == KEY_B )
		return true

	if ( inputID == KEY_ESCAPE || inputID == BUTTON_B )
		return true

	return false
}


bool function EventFriendRequest_HandleInput( int inputID )
{
	if ( file.blockInput )
		return false    //

	SocialEvent event = GetActiveSocialEvent()

	if ( inputID == BUTTON_X || inputID == KEY_Y )
	{
		switch( event.eventType )
		{
			case eSocialEventType.FRIEND:
				EADP_AcceptFriendRequestByEAID( event.eventID )
				break

			case eSocialEventType.PARTY:
				EADP_AcceptInvitToPlay( event.eventID )
				break

			case eSocialEventType.CLUB:
				Clubs_JoinClub( event.eventID )
				//
				break
		}

		#if(DEV)
			DevRemoveFakeData( event.eventID, event.eventType )
		#endif
		SocialEventMarkCompleted( event, 0 )
		TryShowNextSocialEvent()
		return true
	}
	else if ( inputID == BUTTON_Y || inputID == KEY_N )
	{
		switch( event.eventType )
		{
			case eSocialEventType.FRIEND:
				EADP_RejectFriendRequestByEAID( event.eventID )
				break

			case eSocialEventType.PARTY:
				EADP_RejectInviteToPlay( event.eventID )
				break

			case eSocialEventType.CLUB:
				SendClubInviteRejectionToPIN( event )
				ClubInviteDecline( event.eventID )
				thread ClubDiscovery_ProcessInvitesAndRefreshDisplay()
				break
		}

		#if(DEV)
			DevRemoveFakeData( event.eventID, event.eventType )
		#endif
		SocialEventMarkCompleted( event, 1 )
		TryShowNextSocialEvent()

		return true
	}
	else if ( inputID == BUTTON_STICK_RIGHT || inputID == KEY_B )
	{
		if ( event.eventType == eSocialEventType.FRIEND || event.eventType == eSocialEventType.PARTY )
			SocialEventBlockPlayerDialog( event )

		return true
	}

	return false
}


void function SocialEventMarkCompleted( SocialEvent event, int actionTaken )
{
	Assert( event.completed == false )
	event.completed = true

	HudElem_SetRuiArg( file.contentPanel, "actionTaken", actionTaken )
}


void function TryShowNextSocialEvent()
{
	SocialEvent ornull event = GetPendingSocialEvent()
	if ( event == null )
	{
		//
		thread function()
		{
			EndSignal( uiGlobal.signalDummy, "SocialEventPopupClosed" )
			OnThreadEnd( function() {
				SocialEventUpdate()
			} )

			HudElem_SetRuiArg( file.contentPanel, "shouldShow", false )
			thread BlockInputForDuration( 1.2 )

			wait(1.2) //
			thread ClearActiveLobbyPopup() //
		}()
	}
	else
	{
		//
		expect SocialEvent( event )

		thread function() : (event )
		{
			EndSignal( uiGlobal.signalDummy, "SocialEventPopupClosed" )
			OnThreadEnd( function() {
				SocialEventUpdate()
			} )

			//
			RuiSetArgByType( Hud_GetRui( file.contentPanel ), "transitionStartTime", Time(), eRuiArgType.GAMETIME )
			thread BlockInputForDuration( 1.0 )

			SetActiveSocialEvent( event ) //
			wait(0.4) //

			UpdateSocialEventRui( event )
		}()
	}
}


void function SocialEventBlockPlayerDialog( SocialEvent event )
{
	ShowBlockPlayerDialog( event.name, event.eventID, void function( int dialogResult, string eaid ) : ( event ) {
		if ( dialogResult == eDialogResult.YES )
		{
			if ( event.eventType == eSocialEventType.FRIEND )
				EADP_RejectFriendRequestByEAID( eaid )
			else if ( event.eventType == eSocialEventType.PARTY )
				EADP_RejectInviteToPlay( eaid )

			#if(DEV)
				DevRemoveFakeData( event.eventID, event.eventType )
			#endif

			EADP_BlockByEAID( eaid )

			SocialEventMarkCompleted( event, 2 )
			TryShowNextSocialEvent()
		}
		else
		{
			//
		}
	} )
}


void function SendClubInviteRejectionToPIN( SocialEvent event )
{
	ClubHeader clubHeader
	clubHeader.clubID = event.eventID
	clubHeader.name = event.name
	PIN_Club_DeclineInvite( clubHeader )
}

bool function IsSocialPopUpAClubInvite()
{
	if ( file.activeEventInvalid == true )
		return false

	return file.activeSocialEvent.eventType == eSocialEventType.CLUB
}


bool function IsSocialPopupActive()
{
	return file.socialPopupActive
}













#if(DEV)
array< EadpPeopleData > devFriendList
array< EadpInviteToPlayData > devPartyList
array< ClubInvite > devClubList
int friendIndex

array< EadpPeopleData > function DevGetFakeFriendList()
{
	return devFriendList
}


array< EadpInviteToPlayData > function DevGetFakePartyList()
{
	return devPartyList
}


array<ClubInvite> function DevGetFakeClubList()
{
	return devClubList
}


void function DevRemoveFakeData( string eventID, int eventType )
{
	if ( GetBugReproNum() != 1970 )
		return

	switch( eventType )
	{
		case eSocialEventType.FRIEND:
			foreach ( index, data in devFriendList )
			{
				if ( data.eaid == eventID )
					devFriendList.remove( index )
			}
			break

		case eSocialEventType.PARTY:
			foreach ( index, data in devPartyList )
			{
				if ( data.eaid == eventID )
					devPartyList.remove( index )
			}            break

		case eSocialEventType.CLUB:
			foreach ( index, data in devClubList )
			{
				if ( data.clubID == eventID )
					devClubList.remove( index )
			}
			break
	}

	//
	delaythread( 0.2 ) SocialEventUpdate()
}


void function DevDumpFakeLists()
{
	printt( "## devPartyList type:", eSocialEventType.PARTY, "count", devPartyList.len() )
	foreach ( data in devPartyList )
		printt( data.name, " - ", data.eaid )

	printt( "----" )
	printt( "## devFriendList type:", eSocialEventType.FRIEND, "count", devFriendList.len() )
	foreach ( data in devFriendList )
		printt( data.platformName, " - ", data.eaid )

	printt( "----" )
	printt( "## devClubList type:", eSocialEventType.CLUB, "count", devClubList.len() )
	foreach ( data in devClubList )
		printt( data.name, " - ", data.clubID )

	printt( "----" )
	printt( "## Event Cashe, count", file.socialEventCache.len() )
	foreach ( data in file.socialEventCache )
		printt( data.name, " - ", data.eventID, " - ", data.eventType )
}


void function SocialEvent_AddDevEvent( int eventType = eSocialEventType.FRIEND )
{
	//

	switch( eventType )
	{
		case eSocialEventType.FRIEND:
			EadpPeopleData person
			person.eaid = "10000" + string( RandomIntRange( 10000000, 30000000 ) )
			person.name = "Friend Name #" + (devFriendList.len() + 1) //
			person.platformName = "Friend Plfm Name #" + (++friendIndex)
			person.platformHardware = ["PC", "X1", "PS4"].getrandom()

			devFriendList.append( person )
			break

		case eSocialEventType.PARTY:
			EadpInviteToPlayData invite
			invite.name = "Party Friend Name #" + (++friendIndex)
			invite.eaid = "10000" + string( RandomIntRange( 10000000, 30000000 ) ) //
			invite.hardware = [HARDWARE_PC, HARDWARE_PS4, HARDWARE_XBOXONE].getrandom() //

			devPartyList.append( invite )
			break

		case eSocialEventType.CLUB:
			ClubInvite invite
			invite.name = "CoolClubName #" + (++friendIndex)
			invite.clubID = "10000" + string( RandomIntRange( 10000000, 30000000 ) ) //

			devClubList.append( invite )
			break
	}

	//
	delaythread( 0.2 ) SocialEventUpdate()
}
#endif //
