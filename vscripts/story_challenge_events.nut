#if CLIENT || UI 
global function StoryChallengeEvents_Init
global function GetActiveStoryChallengeEvent
global function StoryChallengeEvent_GetAppropriateChallengesForPlayer
global function StoryChallengeEvent_HasChallengesPopupBeenSeen
global function StoryChallengeEvent_GetHasChallengesPopupBeenSeenVarNameOrNull
global function StoryChallengeEvent_GetAppropriateDialogueDatasForPlayer
#endif


//
//
//
//
//


#if CLIENT || UI 
global struct StoryEventGroupChallengeData
{
	array<ItemFlavor> challengeFlavors
	string ornull     persistenceVarNameToUnlockOrNull
	string ornull     persistenceVarNameHasSeenOrNull
	int               requiredStartDateUnixTime = -1
}
#endif


#if CLIENT || UI 
global struct StoryEventDialogueData
{
	string        bodyText
	string        speakerName
	float         duration
	asset         speakerIcon
	string ornull persistenceVarNameToUnlockOrNull
	int           persistenceVarCountToUnlock
	string ornull persistenceVarNameHasSeenOrNull
	string ornull persistenceVarNameToHideOrNull
	array<string> audioAliases
}
#endif


#if CLIENT || UI 
struct FileStruct_LifetimeLevel
{
	table< ItemFlavor, array<StoryEventGroupChallengeData> > eventChallengesDataMap
	table< ItemFlavor, array<StoryEventDialogueData> >       eventDialogueDataMap
	table< ItemFlavor, StoryEventGroupChallengeData >        challengeToEventDataMap
}
#endif
#if(CLIENT)
FileStruct_LifetimeLevel fileLevel //
#elseif(UI)
FileStruct_LifetimeLevel& fileLevel //

struct {
	//
} fileVM //
#endif




//
//
//
//
//

#if CLIENT || UI 
void function StoryChallengeEvents_Init()
{
	#if(UI)
		FileStruct_LifetimeLevel newFileLevel
		fileLevel = newFileLevel
	#endif

	AddCallback_OnItemFlavorRegistered( eItemType.calevent_story_challenges, void function( ItemFlavor ev ) {
		//
		int challengeSortOrdinal = 1
		array<StoryEventGroupChallengeData> challengeGroupDatas

		foreach ( var challengeGroupBlock in IterateSettingsAssetArray( ItemFlavor_GetAsset( ev ), "challengeGroups" ) )
		{
			StoryEventGroupChallengeData data

			string persistenceVarNameToUnlock = GetSettingsBlockString( challengeGroupBlock, "requiredChallengesPersistentVarName" )
			string persistenceVarNameHasSeen  = GetSettingsBlockString( challengeGroupBlock, "hasSeenChallengesPersistentVarName" )
			string requiredStartDate          = GetSettingsBlockString( challengeGroupBlock, "requiredStartTime" )

			//
			if ( persistenceVarNameToUnlock != "" )
			{
				Assert( PersistenceGetVarHandle( persistenceVarNameToUnlock ) != null, "Invalid challenge required persistence variable name: " + persistenceVarNameToUnlock )
				data.persistenceVarNameToUnlockOrNull = persistenceVarNameToUnlock
			}
			else
			{
				data.persistenceVarNameToUnlockOrNull = null
			}

			//
			if ( persistenceVarNameHasSeen != "" )
			{
				Assert( PersistenceGetVarHandle( persistenceVarNameHasSeen ) != null, "Invalid challenge required persistence variable name: " + persistenceVarNameHasSeen )
				data.persistenceVarNameHasSeenOrNull = persistenceVarNameHasSeen
			}
			else
			{
				data.persistenceVarNameHasSeenOrNull = null
			}

			//
			if ( requiredStartDate != "" )
			{
				int ornull requiredStartDateUnixTimeOrNull = DateTimeStringToUnixTimestamp( requiredStartDate )
				if ( requiredStartDateUnixTimeOrNull != null )
				{
					data.requiredStartDateUnixTime = expect int( requiredStartDateUnixTimeOrNull )
				}
				else
				{
					Assert( requiredStartDateUnixTimeOrNull != null, "Invalid challenge group required start time: " + requiredStartDate )
				}
			}

			//
			foreach ( var challengeBlock in IterateSettingsArray( GetSettingsBlockArray( challengeGroupBlock, "challenges" ) ) )
			{
				ItemFlavor ornull challengeFlavOrNull = RegisterItemFlavorFromSettingsAsset( GetSettingsBlockAsset( challengeBlock, "challengeFlav" ) )
				if ( challengeFlavOrNull != null )
				{
					ItemFlavor challengeFlav = expect ItemFlavor( challengeFlavOrNull )

					RegisterChallengeSource( challengeFlav, ev, challengeSortOrdinal )
					challengeSortOrdinal++

					data.challengeFlavors.append( challengeFlav )
					fileLevel.challengeToEventDataMap[ challengeFlav ] <- data
				}
				else Warning( "StoryChallenge event '%s' refers to bad challenge asset: %s", ItemFlavor_GetHumanReadableRef( ev ), string( GetSettingsBlockAsset( challengeBlock, "flavor" ) ) )
			}

			if ( data.challengeFlavors.len() > 0 )
			{
				challengeGroupDatas.append( data )
			}
			else Warning( "StoryChallenge event '%s' has a group with no valid challenges", ItemFlavor_GetHumanReadableRef( ev ) )
		}

		fileLevel.eventChallengesDataMap[ev] <- challengeGroupDatas

		//
		array<StoryEventDialogueData> dialogueDatas

		foreach ( var dialogueBlock in IterateSettingsAssetArray( ItemFlavor_GetAsset( ev ), "dialogueMessages" ) )
		{
			StoryEventDialogueData data
			data.bodyText = GetSettingsBlockString( dialogueBlock, "dialogueBodyText" )
			data.speakerName = GetSettingsBlockString( dialogueBlock, "dialogueSpeakerName" )
			data.duration = GetSettingsBlockFloat( dialogueBlock, "dialogueDuration" )
			data.speakerIcon = GetSettingsBlockAsset( dialogueBlock, "dialogueSpeakerIcon" )

			string persistenceVarNameToUnlock = GetSettingsBlockString( dialogueBlock, "dialoguePersistentVarNameToUnlock" )
			data.persistenceVarCountToUnlock = GetSettingsBlockInt( dialogueBlock, "dialoguePersistentVarNameToUnlockCount" )
			string persistenceVarNameHasSeen = GetSettingsBlockString( dialogueBlock, "dialoguePersistentVarNameHasSeen" )
			string persistenceVarNameToHide  = GetSettingsBlockString( dialogueBlock, "dialoguePersistentVarNameToHide" )

			//
			if ( persistenceVarNameToUnlock != "" )
			{
				Assert( PersistenceGetVarHandle( persistenceVarNameToUnlock ) != null, "Invalid dialogue message persistence var name to unlock: " + persistenceVarNameToUnlock )
				data.persistenceVarNameToUnlockOrNull = persistenceVarNameToUnlock
			}
			else
			{
				data.persistenceVarNameToUnlockOrNull = null
			}

			//
			if ( persistenceVarNameHasSeen != "" )
			{
				Assert( PersistenceGetVarHandle( persistenceVarNameHasSeen ) != null, "Invalid dialogue message persistence var name to hide: " + persistenceVarNameHasSeen )
				data.persistenceVarNameHasSeenOrNull = persistenceVarNameHasSeen
			}
			else
			{
				data.persistenceVarNameHasSeenOrNull = null
			}

			//
			if ( persistenceVarNameToHide != "" )
			{
				Assert( PersistenceGetVarHandle( persistenceVarNameToHide ) != null, "Invalid dialogue message persistence var name to hide: " + persistenceVarNameToHide )
				data.persistenceVarNameToHideOrNull = persistenceVarNameToHide
			}
			else
			{
				data.persistenceVarNameToHideOrNull = null
			}

			float soundDuration = 0.0
			foreach ( var audioBlock in IterateSettingsArray( GetSettingsBlockArray( dialogueBlock, "dialogueAudioAliases" ) ) )
			{
				string dialogueAlias = GetSettingsBlockString( audioBlock, "dialogueAudioAlias" )

				#if CLIENT || UI 
					if ( dialogueAlias != "" )
					{
						soundDuration += GetSoundDuration( dialogueAlias )
						data.audioAliases.append( dialogueAlias )
					}
				#endif
			}

			#if CLIENT || UI 
				if ( soundDuration > 0.0 )
					data.duration = soundDuration
			#endif

			dialogueDatas.append( data )
		}

		fileLevel.eventDialogueDataMap[ev] <- dialogueDatas
	} )
}
#endif



//
//
//
//
//

#if CLIENT || UI 
ItemFlavor ornull function GetActiveStoryChallengeEvent( int t )
{
	Assert( IsItemFlavorRegistrationFinished() )
	ItemFlavor ornull event = null
	foreach ( ItemFlavor ev in GetAllItemFlavorsOfType( eItemType.calevent_story_challenges ) )
	{
		if ( !CalEvent_IsActive( ev, t ) )
			continue

		Assert( event == null, format( "Multiple story challenge events are active!! (%s, %s)", ItemFlavor_GetHumanReadableRef( expect ItemFlavor(event) ), ItemFlavor_GetHumanReadableRef( ev ) ) )
		event = ev
	}
	return event
}
#endif


#if CLIENT || UI 
array<ItemFlavor> function StoryChallengeEvent_GetAppropriateChallengesForPlayer( ItemFlavor event, entity player )
{
	Assert( ItemFlavor_GetType( event ) == eItemType.calevent_story_challenges )

	array<ItemFlavor> appropriateChallenges

	foreach ( StoryEventGroupChallengeData groupData in fileLevel.eventChallengesDataMap[ event ] )
	{
		bool challengesGroupIsUnlockedFromPersistence = groupData.persistenceVarNameToUnlockOrNull == null || player.GetPersistentVarAsInt( expect string( groupData.persistenceVarNameToUnlockOrNull ) ) > 0

		if ( !challengesGroupIsUnlockedFromPersistence )
			continue

		bool challengesGroupIsUnlockedFromDate = groupData.requiredStartDateUnixTime < UNIX_TIME_FALLBACK_1970 || GetUnixTimestamp() >= groupData.requiredStartDateUnixTime

		if ( !challengesGroupIsUnlockedFromDate )
			continue

		appropriateChallenges.extend( groupData.challengeFlavors )
	}

	return appropriateChallenges
}
#endif


#if CLIENT || UI 
bool function StoryChallengeEvent_HasChallengesPopupBeenSeen( ItemFlavor challenge, entity player )
{
	Assert( ItemFlavor_GetType( challenge ) == eItemType.challenge )

	StoryEventGroupChallengeData data = fileLevel.challengeToEventDataMap[ challenge ]

	if ( data.persistenceVarNameHasSeenOrNull != null && player.GetPersistentVarAsInt( expect string ( data.persistenceVarNameHasSeenOrNull ) ) > 0 )
		return true

	return false
}
#endif


#if CLIENT || UI 
string ornull function StoryChallengeEvent_GetHasChallengesPopupBeenSeenVarNameOrNull( ItemFlavor challenge, entity player )
{
	Assert( ItemFlavor_GetType( challenge ) == eItemType.challenge )

	StoryEventGroupChallengeData data = fileLevel.challengeToEventDataMap[ challenge ]

	return data.persistenceVarNameHasSeenOrNull
}
#endif


#if CLIENT || UI 
array<StoryEventDialogueData> function StoryChallengeEvent_GetAppropriateDialogueDatasForPlayer( ItemFlavor event, entity player )
{
	Assert( ItemFlavor_GetType( event ) == eItemType.calevent_story_challenges )

	array<StoryEventDialogueData> appropriateDialogueDatas

	foreach ( StoryEventDialogueData data in fileLevel.eventDialogueDataMap[ event ] )
	{
		bool isUnlocked = data.persistenceVarNameToUnlockOrNull == null || player.GetPersistentVarAsInt( expect string( data.persistenceVarNameToUnlockOrNull ) ) >= data.persistenceVarCountToUnlock

		bool shouldHide = data.persistenceVarNameToHideOrNull != null && player.GetPersistentVarAsInt( expect string( data.persistenceVarNameToHideOrNull ) ) > 0

		if ( !isUnlocked || shouldHide )
			continue

		appropriateDialogueDatas.append( data )
	}

	return appropriateDialogueDatas
}
#endif //
