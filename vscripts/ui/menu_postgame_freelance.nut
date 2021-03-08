global function InitPostGameFreelanceMenu
global function OpenPostGameFreelanceMenu

const string POSTGAME_LINE_ITEM = "ui_menu_matchsummary_xpbreakdown"
const float PROGRESS_BAR_FILL_TIME = 5.0
const float PROGRESS_BAR_FILL_TIME_FAST = 2.0
const float LINE_DISPLAY_TIME = 0.75

struct
{
	var menu
	var continueButton
	var combinedCard
	var menuHeaderRui
	var rewardFrameRui

	bool skippableWaitSkipped = false
	bool disableNavigateBack = true
	bool isFirstTime = false
} file

void function InitPostGameFreelanceMenu( var menu )
{
	file.menu = menu

	file.combinedCard = Hud_GetChild( menu, "CombinedCard" )
	file.continueButton = Hud_GetChild( menu, "ContinueButton" )
	file.menuHeaderRui = Hud_GetRui( Hud_GetChild( menu, "MenuHeader" ) )
	file.rewardFrameRui = Hud_GetRui( Hud_GetChild( menu, "RewardFrame" ) )

	AddMenuEventHandler( menu, eUIEvent.MENU_OPEN, OnMenuOpen )
	AddMenuEventHandler( menu, eUIEvent.MENU_CLOSE, OnMenuClose )

	AddMenuEventHandler( menu, eUIEvent.MENU_SHOW, OnMenuShow )
	AddMenuEventHandler( menu, eUIEvent.MENU_HIDE, OnMenuHide )

	AddMenuEventHandler( menu, eUIEvent.MENU_NAVIGATE_BACK, OnNavigateBack )

	Hud_AddEventHandler( file.continueButton, UIE_CLICK, OnContinue_Activate )
	AddMenuFooterOption( menu, LEFT, BUTTON_B, true, "#B_BUTTON_CLOSE", "#B_BUTTON_CLOSE", null, CanNavigateBack )
	AddMenuFooterOption( menu, LEFT, BUTTON_BACK, true, "", "", CloseThisMenu, CanNavigateBack )

	InitMissionRewardButtons( menu, "RewardButtonFree" )
}


void function OnMenuOpen()
{
	s_onCloseShowQuest = null
	s_onCloseShowQuestLoreMissionIndex = -1
}


void function OnMenuShow()
{
	if ( !IsFullyConnected() )
		return

	entity player = GetUIPlayer()
	if ( !player )
		return

	//
	{
		Hud_Hide( file.continueButton )
		file.disableNavigateBack = false
		UpdateFooterOptions()
	}

	RegisterButtonPressedCallback( BUTTON_A, OnContinue_Activate )
	RegisterButtonPressedCallback( KEY_SPACE, OnContinue_Activate )

	UI_SetPresentationType( ePresentationType.WEAPON_CATEGORY )

	bool isFirstTime = (GetPersistentVarAsInt( "showGameSummary" ) != 0)

                        
		int questGUID = GetPersistentVarAsInt( "pve.postGame_questGUID" )
		if ( !IsValidItemFlavorGUID( questGUID ) )
			return
		ItemFlavor quest = GetItemFlavorByGUID( questGUID )
		if ( ItemFlavor_GetType( quest ) != eItemType.quest )
		{
			Assert( false, format( "Quest guid '%d' resolved to invalid non-quest: '%s'", questGUID, ItemFlavor_GetHumanReadableRef( quest ) ) )
			return
		}
		printf( "Using quest: '%s'", ItemFlavor_GetHumanReadableRef( quest ) )

		thread PopulateMissionSummary( quest, file.isFirstTime )

          

	UpdateMenuGladCard( player, file.combinedCard )

	Remote_ServerCallFunction( "ClientCallback_ViewedGameSummary" )
}


void function UpdateMenuGladCard( entity player, var hudElement )
{
	Hud_SetVisible( hudElement, true )

	//
	int characterPDefEnumIndex = player.GetPersistentVarAsInt( "characterForXP" ) //
	Assert( characterPDefEnumIndex >= 0 && characterPDefEnumIndex < PersistenceGetEnumCount( "eCharacterFlavor" ) )
	string characterGUIDString = PersistenceGetEnumItemNameForIndex( "eCharacterFlavor", characterPDefEnumIndex )

	int characterGUID = ConvertItemFlavorGUIDStringToGUID( characterGUIDString )
	ItemFlavor ornull character

	if ( !IsValidItemFlavorGUID( characterGUID ) )
	{
		Warning( "Cannot display post-game summary banner because character \"" + characterGUIDString + "\" is not registered right now." ) //
		character = null
	}
	else
	{
		character = GetItemFlavorByGUID( characterGUID )
		expect ItemFlavor( character )

		RunMenuClientFunction( "UpdateMenuCharacterModel", ItemFlavor_GetNetworkIndex_DEPRECATED( character ) )

		SetupMenuGladCard( file.combinedCard, "card", true )
		SendMenuGladCardPreviewCommand( eGladCardPreviewCommandType.CHARACTER, 0, character )

		Ranked_SetupMenuGladCardForUIPlayer()
	}
}


struct FreelanceLevelData
{
	//
	//
	asset icon
	int   scoreMin
	int   index
}

FreelanceLevelData function GetLevelDataForScore( int score )
{
	FreelanceLevelData res
	res.index = (score / 10000)
	res.scoreMin = (res.index * 10000)
	//
	res.icon = $"rui/gladiator_cards/badges/temp_freelance_level"

	return res
}


FreelanceLevelData ornull function GetNextLevelDataForScore( int score )
{
	FreelanceLevelData res
	res.index = ((score / 10000) + 1)
	res.scoreMin = (res.index * 10000)
	//
	res.icon = $"rui/gladiator_cards/badges/temp_freelance_level"

	return res
}

                       
ItemFlavor ornull s_onCloseShowQuest = null
int s_onCloseShowQuestLoreMissionIndex = -1
void function PopulateMissionSummary( ItemFlavor quest, bool isFirstTimeSeeingThisPostgame )
{
	entity player = GetUIPlayer()

	int missionsTotalMax = SeasonQuest_GetMissionsMaxCount( quest )
	int missionIndex     = GetPersistentVarAsInt( "pve.postGame_questMissionIndex" )
	if ( missionIndex < 0 )
	{
		Warning( "Recorded quest mission index is < 0, skipping summary (assuming dev mission)." )
		return
	}

	string playlistName = SeasonQuest_GetPlaylistForMissionIndex( quest, missionIndex )

	bool isFinalMission = (missionIndex == (missionsTotalMax - 1))
	bool isSuccess          = (GetPersistentVarAsInt( "pve.postGame_questIsSuccess" ) == 1)
	bool isFirstTimeVictory = (GetPersistentVarAsInt( "pve.postGame_questIsFirstTimeVictory" ) == 1)
	bool showRewards		= isSuccess && isFirstTimeVictory

	//
	int status 				= SeasonQuest_GetStatusForMissionIndex( player, quest, missionIndex )
	bool showNotice			= status < eQuestMissionStatus.LAUNCHABLE

	if ( isFirstTimeSeeingThisPostgame )
	{
		s_onCloseShowQuest = quest
		if ( isFirstTimeVictory )
			s_onCloseShowQuestLoreMissionIndex = missionIndex
	}

	string artifactName = SeasonQuest_GetQuestItemNameForMissionIndex( quest, missionIndex )

	//

	bool artifactRecovered = isSuccess
	RuiSetString( file.rewardFrameRui, "artifactName", artifactName )
	RuiSetBool( file.rewardFrameRui, "artifactRecovered", artifactRecovered )
	RuiSetBool( file.rewardFrameRui, "showRewards", showRewards )
	RuiSetBool( file.rewardFrameRui, "showNotice", showNotice )


	string missionName = GetPlaylistVarString( playlistName, "name", "XxXxX" )
	RuiSetString( file.menuHeaderRui, "menuName", missionName )
	RuiSetString( file.menuHeaderRui, "subString", Localize( "#EOG_QUEST_MATCH_SUMMARY", string( missionIndex + 1 ) ) )

	var breakdownRui = Hud_GetRui( Hud_GetChild( file.menu, "XPEarned1" ) )
	var statusRui    = Hud_GetRui( Hud_GetChild( file.menu, "XPEarned2" ) )

	RuiSetString( breakdownRui, "headerText", "#EOG_QUEST_BREAKDOWN" )

	string statusStr     = isSuccess ? Localize( "#EOG_QUEST_SUCCESS" ) : Localize( "#EOG_QUEST_FAILED" )
	string missionHeader = Localize( "#EOG_QUEST_MISSION", statusStr.toupper() )
	RuiSetString( statusRui, "headerText", missionHeader )

	const vector CREDITS_COLOR = (<244, 197, 66> / 255.0)
	const vector SUCCESS_COLOR = <1.0, 1.0, 1.0>
	const vector FAIL_COLOR = <0.4, 0.15, 0.15>

	int secondsPlayed = GetPersistentVarAsInt( "pve.postGame_secondsPlayed" )
	int kills         = GetPersistentVarAsInt( "pve.postGame_kills" )
	bool didExtract   = (GetPersistentVarAsInt( "pve.postGame_didExtract" ) != 0)

	int minutesPlayed    = (secondsPlayed / SECONDS_PER_MINUTE)
	int secondsRemainder = (secondsPlayed - (minutesPlayed * SECONDS_PER_MINUTE))
	RuiSetString( breakdownRui, "line1KeyString", Localize( "#MISSIONSUMMARY_LINE_TIMEPLAYED" ) )
	RuiSetString( breakdownRui, "line1ValueString", format( "%d:%02d", minutesPlayed, secondsRemainder ) )
	RuiSetColorAlpha( breakdownRui, "line1Color", SUCCESS_COLOR, 1 )

	RuiSetString( breakdownRui, "line2KeyString", Localize( "#MISSIONSUMMARY_LINE_KILLS" ) )
	RuiSetString( breakdownRui, "line2ValueString", format( "%d", kills ) )
	RuiSetColorAlpha( breakdownRui, "line2Color", SUCCESS_COLOR, 1 )

	//
	//
	//

	RuiSetFloat( breakdownRui, "lineDisplayTime", 0.00001 )
	RuiSetFloat( breakdownRui, "startDelay", 0.0 )
	RuiSetGameTime( breakdownRui, "startTime", Time() + 0.5 )
	RuiSetInt( breakdownRui, "numLines", 2 )

	//
	RuiSetString( statusRui, "line1KeyString", Localize( "#EOG_QUEST_SURVIVED" ) )
	RuiSetString( statusRui, "line1ValueString", didExtract ? Localize( "#EOG_QUEST_SUCCESS" ) : Localize( "#EOG_QUEST_FAILED" ) )
	RuiSetColorAlpha( statusRui, "line1Color", SUCCESS_COLOR, 1 )

	RuiSetString( statusRui, "line2KeyString", Localize( "#EOG_QUEST_RETRIEVED_ARTIFACT" ) )
	RuiSetString( statusRui, "line2ValueString", isSuccess ? Localize( "#EOG_QUEST_SUCCESS" ) : Localize( "#EOG_QUEST_FAILED" ) )
	RuiSetColorAlpha( statusRui, "line2Color", SUCCESS_COLOR, 1 )

	RuiSetString( statusRui, "line3KeyString", Localize( "#EOG_QUEST_EVAC_IN_TIME" ) )
	RuiSetString( statusRui, "line3ValueString", didExtract ? Localize( "#EOG_QUEST_SUCCESS" ) : Localize( "#EOG_QUEST_FAILED" ) )
	RuiSetColorAlpha( statusRui, "line3Color", SUCCESS_COLOR, 1 )

	RuiSetFloat( statusRui, "lineDisplayTime", 0.00001 )
	RuiSetFloat( statusRui, "startDelay", 0.0 )
	RuiSetGameTime( statusRui, "startTime", Time() + 0.5 )
	RuiSetInt( statusRui, "numLines", 3 )

	//
	bool ownRewards = isSuccess || missionIndex < SeasonQuest_GetMissionsCompletedForPlayer( player, quest )
	SetupMissionRewardButtons( file.menu, quest, missionIndex, "RewardButtonFree", ownRewards, isFinalMission )

	array<var> rewardButtonArray = GetPanelElementsByClassname( file.menu, "RewardButtonFree" )
	foreach( button in rewardButtonArray )
	{
		if ( showRewards )
			Hud_Show( button )
		else
			Hud_Hide( button )
	}

	if ( isFinalMission )
	{
		Hud_SetVisible( Hud_GetChild( file.menu, "XPEarned1" ), false )
		Hud_SetVisible( Hud_GetChild( file.menu, "XPEarned2" ), false )
		RuiSetString( file.menuHeaderRui, "subString", "" )
		RuiSetString( file.rewardFrameRui, "recoveredHeader", " " )
		RuiSetString( file.rewardFrameRui, "artifactName", "#EOG_QUEST_SUCCESS_FINAL" )
	}
	else
	{
		Hud_SetVisible( Hud_GetChild( file.menu, "XPEarned1" ), true )
		Hud_SetVisible( Hud_GetChild( file.menu, "XPEarned2" ), true )
		RuiSetString( file.rewardFrameRui, "recoveredHeader", "#EOG_QUEST_RECOVERED" )
	}

	//
	//
}
         

void function OnMenuClose()
{
	if ( !IsConnected() )
		return
	if ( !IsPersistenceAvailable() )
		return

	ItemFlavor ornull quest = s_onCloseShowQuest
	if ( quest == null )
		return
	expect ItemFlavor( quest )

	thread function() : (quest)
	{
		JumpToSeasonTab( "QuestPanel" )

		if ( s_onCloseShowQuestLoreMissionIndex >= 0 )
		{
			asset data = SeasonQuest_GetLoreSequenceStoryChapterDataForMissionIndex( quest, s_onCloseShowQuestLoreMissionIndex )
			if ( data != LoreReader_GetLastOpenedDataAsset() )
			{
				WaitFrame()
				if ( !IsConnected() )
					return
				LoreReaderMenu_OpenTo( data )

				//
				if ( GetCurrentPlaylistVarBool( "quest_show_mission_reward_ceremnony", true ) )
					DisplayQuestMissionRewards( quest, s_onCloseShowQuestLoreMissionIndex )
			}
		}
	}()
}


void function OnContinue_Activate( var button )
{
	file.skippableWaitSkipped = true
	if ( !file.disableNavigateBack )
		CloseActiveMenu()
}


void function OnMenuHide()
{
	DeregisterButtonPressedCallback( BUTTON_A, OnContinue_Activate )
	DeregisterButtonPressedCallback( KEY_SPACE, OnContinue_Activate )
}


void function ResetSkippableWait()
{
	file.skippableWaitSkipped = false
}


bool function IsSkippableWaitSkipped()
{
	return file.skippableWaitSkipped || !file.disableNavigateBack
}


bool function SkippableWait( float waitTime, string uiSound = "" )
{
	if ( IsSkippableWaitSkipped() )
		return false

	if ( uiSound != "" )
		EmitUISound( uiSound )

	float startTime = Time()
	while ( Time() - startTime < waitTime )
	{
		if ( IsSkippableWaitSkipped() )
			return false

		WaitFrame()
	}

	return true
}


bool function CanNavigateBack()
{
	return file.disableNavigateBack != true
}


void function OnNavigateBack()
{
	if ( !CanNavigateBack() )
		return
	CloseThisMenu( null )
}


void function CloseThisMenu( var button )
{
	if ( GetActiveMenu() == file.menu )
		thread CloseActiveMenu()
}


void function OpenPostGameFreelanceMenu( bool firstTime )
{
	file.isFirstTime = firstTime
	AdvanceMenu( file.menu )
}
