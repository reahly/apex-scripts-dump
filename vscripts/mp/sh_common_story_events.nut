#if(false)

#endif

#if(CLIENT)
global function ClCommonStoryEvents_Init
#endif


                    

global function IsArenasTeaseLive
global function GetArenasTeaseLiveUnixTimestamp

#if(false)


#endif

#if(CLIENT)
global function ChallengeCompletionPercentage
#endif

#if(false)


#endif //

const array<vector> arenasTeaseOlympusCoordinates =
		[
			< -33124.644531, 14786.517578, -5127.968750 >,
			< -24939.072266, 21825.820313, -5994.746582 >,
			< -7501.260254, 31503.203125, -6051.907715 >,
			< 9851.766602, 26710.087891, -4673.809082 >,
			< -10283.401367, 9780.599609, -5631.644043 >,
			< -23193.404297, 643.732239, -5115.552246 >,
			< -5068.557617, -2134.176514, -5775.793945 >,
			< 317.559448, 7318.659180, -5228.123047 >,
			< 27933.208984, 5102.718262, -3309.284424 >,
			< -37811.226563, -2433.504883, -4380.738770 >,
			< -31697.916016, -16822.837891, -3935.968750 >,
			< -7709.215332, -25391.384766, -2354.832275 >,
			< 4881.700195, -21876.332031, -5375.943359 >,
			< 17045.427734, -3987.214355, -4521.968750 >,
			< 25215.775391, -17953.714844, -5247.968750 >
		]


const array<vector> arenasTeaseCanyonLandsCoordinates =
		[
			<36600.359375, 24534.921875, 3456.031250>,
			<38094.375000, 844.973938, 3066.129639>,
			<27719.533203, 1015.092590, 3872.664063>,
			<21784.146484, -7278.567871, 5413.561035>,
			<8405.953125, 20247.111328, 5473.21436>,
			<15844.699219, -1765.577881, 5852.031250>,
			<14807.288086, -22955.003906, 1836.190186>,
			<7238.140625, 25887.121094, 5852.060059>,
			<-4948.960938, 18666.833984, 2546.098633>,
			<-7094.754395, 5465.933594, 2662.958252>,
			<8556.442383, -30707.587891, 3763.075195>,
			<-28240.095703, 22508.328125, 1344.661865>,
			<-15937.164063, 16391.279297, 3714.660645>,
			<-24677.384766, 13465.040039, 2956.031250>,
			<-29307.839844, 467.718842, 2543.062744>,
			<-5428.272949, -15166.818359, 3219.642334>,
			<-7230.831055, 37886.640625, 6498.112305>
		]

const string TEASE_EVENT_REF = "calevent_s08e04_story_challenges"
const string KEYCARD_LOOT_REF = "s08_story_challenges_keycard"
const string KEYCARD_DROP_SOUND = "lootbin_treasurepack_shimmer_launch"
const string DROPPOD_KEYCARD_SPAWN_ANIM_EVENT = "Droppod_Spawn_Keycard"
const string DROPPOD_KEYCARD_PICK_SOUND_EVENT = "ArenaTease_KeyCard_Corrupted"
const string DROPPOD_KEYCARD_USE_SOUND_EVENT = "ArenaTease_KeyCard_Scanner"
const string KEYCARD_USAGE_1P_ANIM = "ptpov_burn_card_activate_seq_s07_tease"
const asset HOLOGRAM_FX = $"P_holospray_arenas_logo"
const asset HOLOGRAM_BASE = $"mdl/props/holo_spray/holo_spray_base.rmdl"

const string HOLOSPRAY_CHALLENGE_KC_REF = "challenge_s08e04_group1challenge0"
const string HOLOSPRAY_CHALLENGE_OLY_REF = "challenge_s08e04_group1challenge1"


global enum eArenasTeaseMapIndex
{
	NONE,
	KINGS_CANYON,
	OLYMPUS
}

      

struct
{
                     
		int mapIndex
       
} file


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


#if(false)
















#endif


#if(CLIENT)
                    
void function ClCommonStoryEvents_Init( int mapIndex = eArenasTeaseMapIndex.NONE )
     
                                        
      
{
	AddCallback_EntitiesDidLoad( EntitiesDidLoad )
                     
	if ( IsArenasTeaseLive() )
	{
		file.mapIndex = mapIndex
		AddCreateCallback( "prop_dynamic", ArenasTeaseHolosprayCreated )
	}
       
}
#endif

#if(CLIENT)
void function EntitiesDidLoad()
{
                     
	if ( IsArenasTeaseLive() )
	{
		RegisterCustomItemPickupAction( KEYCARD_LOOT_REF, KeyCard_OnPickup )
		RegisterCustomItemGroundAction( KEYCARD_LOOT_REF, KeyCard_GroundAction )
		#if(false)

#endif
	}
       
}
#endif //

                    
bool function IsArenasTeaseLive()
{
	ItemFlavor ornull storyChallengeEventOrNull = GetStoryChallengeEventIfActive( GetUnixTimestamp(), TEASE_EVENT_REF )
	return storyChallengeEventOrNull != null
}

int function GetArenasTeaseLiveUnixTimestamp()
{
	ItemFlavor itemFlav = GetItemFlavorByHumanReadableRef( TEASE_EVENT_REF )
	if ( IsValid (itemFlav) )
		return CalEvent_GetStartUnixTime ( itemFlav )

	return UNIX_TIME_FALLBACK_2038
}


#if(CLIENT)
bool function KeyCard_OnPickup( entity pickup, entity player, int pickupFlags, entity deathBox, int ornull desiredCount, LootData data )
{
	if ( !IsValid( pickup ) )
		return false

	#if(CLIENT)
		EmitSoundOnEntity( player, DROPPOD_KEYCARD_PICK_SOUND_EVENT )
	#endif

	#if(false)




#endif

	return true
}

LootActionStruct function KeyCard_GroundAction( entity player, LootRef lootRef )
{
	LootData lootData = lootRef.lootData
	LootActionStruct as

	if ( !player.GetPersistentVar( "s08StoryEvent.hasStep1Completed" ) )
	{
		as.action = eLootAction.PICKUP
	}
	else
	{
		as.action = eLootAction.NONE
		as.displayString = "#S08E04_KEYCARD_ALREADY_PICKEDUP"
	}

	return as
}

#endif

#if(false)



























#endif

#if(false)


















#endif

bool function ArenasHoloSpray_CanUse ( entity player, entity holospray )
{
	if ( Bleedout_IsBleedingOut( player ) )
		return false

	return true
}


void function ArenasHoloSpray_OnUse( entity holospray, entity player, int useInputFlags )
{
	if ( !player.GetPersistentVar( "s08StoryEvent.hasStep2Completed" ) || player.GetPersistentVarAsInt( "s08StoryEvent.step3ChallengesCompletedCount" ) >= 2 )
		return

	if ( ArenasHoloSpray_ChallengesCompleteCheck( player ) )
		return

	if ( ArenasHoloSpray_CheckIfScanned( player,  holospray.e.arenasTeaseHolosprayID  ) )
	{
		return
	}

	#if(CLIENT)
		EmitSoundOnEntity( player, DROPPOD_KEYCARD_USE_SOUND_EVENT )
	#endif

	#if(false)






















#endif
}

#if(false)

































#endif //

#if(CLIENT)
void function ArenasTeaseHolosprayCreated ( entity holospray )
{
	if ( holospray.GetScriptName() != "ArenasTeaseHoloSpray" )
		return

	if ( file.mapIndex == eArenasTeaseMapIndex.OLYMPUS )
	{
		for ( int i = 0; i < arenasTeaseOlympusCoordinates.len(); ++i )
		{
			if ( DistanceSqr(arenasTeaseOlympusCoordinates[i], holospray.GetOrigin()) <= 0.1 )
			{
				holospray.e.arenasTeaseHolosprayID = i
				break
			}
		}
	}
	else if ( file.mapIndex == eArenasTeaseMapIndex.KINGS_CANYON )
	{
		for ( int i = 0; i < arenasTeaseCanyonLandsCoordinates.len(); ++i )
		{
			if ( DistanceSqr(arenasTeaseCanyonLandsCoordinates[i], holospray.GetOrigin()) <= 0.1 )
			{
				holospray.e.arenasTeaseHolosprayID = i
				break
			}
		}
	}
	else
	{
		return
	}

	if ( holospray.e.arenasTeaseHolosprayID == -1 )
		return

	AddCallback_OnUseEntity_ClientServer( holospray, ArenasHoloSpray_OnUse )
	SetCallback_CanUseEntityCallback( holospray, ArenasHoloSpray_CanUse )
	AddEntityCallback_GetUseEntOverrideText( holospray, ArenasHoloSpray_OverrideText )
}


string function ArenasHoloSpray_OverrideText ( entity holospray )
{
	entity player = GetLocalViewPlayer()
	if ( !player.GetPersistentVar( "s08StoryEvent.hasStep1Completed" ) )
		return "#S08E04_CHALLENGE_EARLY"

	if ( !player.GetPersistentVar( "s08StoryEvent.hasStep2Completed" ) )
		return "#S08E04_CHALLENGE_NOT_ACCEPTED"

	if ( player.GetPersistentVar( "s08StoryEvent.hasStep3Completed" ) )
		return ""

	if ( ArenasHoloSpray_ChallengesCompleteCheck( player ) )
		return ""

	if ( ArenasHoloSpray_CheckIfScanned( player, holospray.e.arenasTeaseHolosprayID ) )
	{
		return "#S08E04_CHALLENGE_PROMPT_DONE"
	}

	return "#S08E04_CHALLENGE_PROMPT"
}
#endif

bool function ArenasHoloSpray_CheckIfScanned( entity player, int bitIndex )
{
	int holosprayActivatedBitfield = 0
	if ( file.mapIndex == eArenasTeaseMapIndex.KINGS_CANYON )
	{
		holosprayActivatedBitfield = player.GetPersistentVarAsInt( "s08StoryEvent.kcHolosprayScanned" )
	}
	else if ( file.mapIndex == eArenasTeaseMapIndex.OLYMPUS )
	{
		holosprayActivatedBitfield = player.GetPersistentVarAsInt( "s08StoryEvent.olyHolosprayScanned" )
	}
	else
	{
		Assert(false, "ArenasHoloSpray_CheckIfScanned called on a nonsupport map.")
		return false
	}

	if ( holosprayActivatedBitfield & (1 << bitIndex) )
	{
		return true
	}

	return false
}

#if(false)





































































#endif //

bool function ArenasHoloSpray_ChallengesCompleteCheck( entity player )
{
	if ( !IsValid( player ) )
		return false

	int challengesCompleted = player.GetPersistentVarAsInt( "s08StoryEvent.step3ChallengesCompletedCount" )
	if ( challengesCompleted == 0 )
	{
		return false
	}
	else if ( challengesCompleted == 2 )
	{
		return true
	}

	ItemFlavor challengeFlav
	if ( file.mapIndex == eArenasTeaseMapIndex.KINGS_CANYON )
	{
		challengeFlav = GetItemFlavorByHumanReadableRef(HOLOSPRAY_CHALLENGE_KC_REF)
	}
	else if ( file.mapIndex == eArenasTeaseMapIndex.OLYMPUS )
	{
		challengeFlav = GetItemFlavorByHumanReadableRef(HOLOSPRAY_CHALLENGE_OLY_REF)
	}
	else
	{
		 Assert(0, "Invalid map index for ArenasHoloSpray_ChallengesCompleteCheck.")
	}


	if ( !DoesPlayerHaveChallenge( player, challengeFlav ) )
	{
		Warning( "player do not have the challenge." )
		return false
	}

	int progress = Challenge_GetProgressValue( player, challengeFlav, 0 )
	if ( progress == 3 )
	{
		return true
	}

	return false
}

#if(CLIENT)
int function ChallengeCompletionPercentage ( entity player )
{
	ItemFlavor challengeFlav = GetItemFlavorByHumanReadableRef(HOLOSPRAY_CHALLENGE_KC_REF)
	int progress0 = 0
	if ( !IsValid(challengeFlav) || !DoesPlayerHaveChallenge( player, challengeFlav ) )
	{
		Warning( "player do not have the challenge." )
		progress0 = 0
	}
	else
	{
		progress0 = Challenge_GetProgressValue( player, challengeFlav, 0 )
	}


	challengeFlav = GetItemFlavorByHumanReadableRef(HOLOSPRAY_CHALLENGE_OLY_REF)
	int progress1 = 0
	if ( !IsValid(challengeFlav) || !DoesPlayerHaveChallenge( player, challengeFlav ) )
	{
		Warning( "player do not have the challenge." )
		progress1 = 0
	}
	else
	{
		progress1 = Challenge_GetProgressValue( player, challengeFlav, 0 )
	}

	int totalProgress = progress0 + progress1

	return int( (float( totalProgress ) / 6.0) * 100.00 )
}
#endif

      