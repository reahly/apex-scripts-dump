#if(false)



#endif

#if(false)




#endif

#if(CLIENT)
global function ClBloodhound_TT_Init
global function SCB_BloodTT_SetCustomSpeakerIdx
#endif


#if(CLIENT)
global function Bloodhound_TT_RegisterNetworking
global function IsBloodhountTTEnabled
global function GetBloodTTRewardPanelForLoot
global function IsBloodTTRewardPanelLocked
#endif


#if(false)









































//


#endif


#if(CLIENT)
const asset BLOOD_TT_CSV_DIALOGUE = $"datatable/dialogue/blood_tt_dialogue.rpak"
const asset BLOOD_TT_ANNOUNCER_CSV_DIALOGUE = $"datatable/dialogue/blood_tt_announcer_dialogue.rpak"
const array<string> PROWLER_PANEL_SCRIPTNAMES = ["prowler_console_tier0", "prowler_console_tier1", "prowler_console_tier2"]

const string STORY_PROP_HUNT_SCRIPTNAME = "blood_tt_story_hunt"
const string STORY_PROP_TECH_SCRIPTNAME = "blood_tt_story_tech"
const string STORY_PROP_TECH_TARGET_SCRIPTNAME = "blood_tt_story_tech_target"
const string STORY_PROP_SPIRITUAL_SCRIPTNAME = "blood_tt_story_spiritual"

const string SIGNAL_STORY_PROP_DIALOGUE_ABORTED = "BloodTTStoryPropDialogueAborted"

const array<string> DIALOGUE_LINES_STORY_PROP_HUNT =
[
	"bc_bloodhound_storyOfTheHunt_01",
	"bc_bloodhound_storyOfTheHunt_02",
	"bc_bloodhound_storyOfTheHunt_03",
]

const array<string> DIALOGUE_LINES_STORY_PROP_TECH =
[
	"bc_bloodhound_storyOfTheWeapon_01",
	"bc_bloodhound_storyOfTheWeapon_02",
	"bc_bloodhound_storyOfTheWeapon_03",
]

const array<string> DIALOGUE_LINES_STORY_PROP_SPIRITUAL =
[
	"bc_bloodhound_storyOfTheGuide_01",
	"bc_bloodhound_storyOfTheGuide_02",
	"bc_bloodhound_storyOfTheGuide_03",
	"bc_bloodhound_storyOfTheGuide_04",
	"bc_bloodhound_storyOfTheGuide_05",
	"bc_bloodhound_storyOfTheGuide_06",
]

const string LOUDSPEAKER_SCRIPTNAME = "bloodhound_tt_loudspeaker_target"
#endif //


struct RewardPanelData
{
	entity panel
	Point& doorStartPoint
	int    challengeIdx
}


#if(false)























#endif //


#if(CLIENT)
struct StoryPropUsabilityData
{
	bool propsUsable = true
}
#endif //

struct
{
	#if(CLIENT)
		array<entity>          allStoryProps
		array<RewardPanelData> panelDatas

		#if(false)


























#elseif(CLIENT)
			StoryPropUsabilityData& clientStoryPropData
		#endif
	#endif //
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


#if(CLIENT)
void function ClBloodhound_TT_Init()
{
	StoryPropUsabilityData data
	file.clientStoryPropData = data

	RegisterSignal( SIGNAL_STORY_PROP_DIALOGUE_ABORTED )

	RegisterCSVDialogue( BLOOD_TT_CSV_DIALOGUE )
	RegisterCSVDialogue( BLOOD_TT_ANNOUNCER_CSV_DIALOGUE )

	AddCallback_OnAbortDialogue( OnAbortDialogue )
	AddCallback_EntitiesDidLoad( EntitiesDidLoad )
}
#endif

void function Bloodhound_TT_RegisterNetworking()
{
	Remote_RegisterClientFunction( "SCB_BloodTT_SetCustomSpeakerIdx", "int", 0, NUM_TOTAL_DIALOGUE_QUEUES )
}

#if(false)































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




















#endif //


#if(false)




















//

#endif


#if(false)





//



#endif


#if(false)





#endif


#if(CLIENT)
void function EntitiesDidLoad()
{
	if ( !IsBloodhountTTEnabled() )
		return

	//
	InitStoryProps()

	#if(false)

#endif

	#if(false)
//


//




#endif

	//
	for ( int idx = 0; idx < PROWLER_PANEL_SCRIPTNAMES.len(); idx++ )
	{
		RewardPanelData panelData
		panelData.panel = GetEntByScriptName( PROWLER_PANEL_SCRIPTNAMES[ idx ] )
		panelData.challengeIdx = idx

		#if(false)




























#endif //


		//
		entity mover = panelData.panel.GetLinkEnt()

		//
		Point startPoint
		startPoint.origin = mover.GetOrigin()
		startPoint.angles = mover.GetAngles()
		panelData.doorStartPoint = startPoint
		file.panelDatas.append( panelData )

		#if(false)



















#endif //
	}

	#if(false)
//














#endif //

	printf( "BLOODHOUND TT INITIALIZED" )
}
#endif //

#if(CLIENT)
void function SCB_BloodTT_SetCustomSpeakerIdx( int speakerIdx )
{
	//
	RegisterCustomDialogueQueueSpeakerEntities( speakerIdx, GetEntArrayByScriptName( LOUDSPEAKER_SCRIPTNAME ) )
}
#endif

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








//


























//








//








//








//














//






#endif


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











































#endif //


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







//




//




//










































//



//












//































//



//



































#endif


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


#if(CLIENT)
void function InitStoryProps()
{
	#if(false)

#endif

	entity huntProp      = GetEntByScriptName( STORY_PROP_HUNT_SCRIPTNAME )
	entity techProp      = GetEntByScriptName( STORY_PROP_TECH_SCRIPTNAME )
	entity spiritualProp = GetEntByScriptName( STORY_PROP_SPIRITUAL_SCRIPTNAME )

	file.allStoryProps = [huntProp, techProp, spiritualProp]

	foreach ( entity prop in file.allStoryProps )
	{
		#if(false)



#endif

		AddCallback_OnUseEntity_ClientServer( prop, StoryPropOnActivate )
		SetCallback_CanUseEntityCallback( prop, StoryProp_CanUse )
	}

	#if(CLIENT)
		AddEntityCallback_GetUseEntOverrideText( huntProp, GetStoryPropHintText )
		AddEntityCallback_GetUseEntOverrideText( techProp, GetStoryPropHintText )
		AddEntityCallback_GetUseEntOverrideText( spiritualProp, GetStoryPropHintText )
	#endif
}
#endif //


#if(false)








#endif


#if(CLIENT)
string function GetStoryPropHintText( entity prop )
{
	if ( IsPlayerBloodhound( GetLocalClientPlayer() ) )
	{
		if ( IsChallengeActive() )
			return "#BLOOD_TT_STORY_PROP_UNUSABLE_TRIAL"

		switch ( prop.GetScriptName() )
		{
			case STORY_PROP_HUNT_SCRIPTNAME:
				return "#BLOOD_TT_STORY_PROP_HUNT"
				break

			case STORY_PROP_TECH_SCRIPTNAME:
				return "#BLOOD_TT_STORY_PROP_TECH"
				break

			case STORY_PROP_SPIRITUAL_SCRIPTNAME:
				return "#BLOOD_TT_STORY_PROP_SPIRIT"
				break
		}
	}

	return "#BLOOD_TT_STORY_PROP_UNUSABLE"
}
#endif //


#if(CLIENT)
bool function StoryProp_CanUse( entity playerUser, entity storyProp )
{
	if ( Bleedout_IsBleedingOut( playerUser ) )
		return false

	if ( !IsPlayerBloodhound( playerUser ) )
		return true

	//
	StoryPropUsabilityData data
	#if(false)



#elseif(CLIENT)
		data = file.clientStoryPropData
	#endif

	if ( !data.propsUsable )
		return false

	return true
}
#endif //


#if(CLIENT)
bool function IsPlayerBloodhound( entity player )
{
	ItemFlavor character = LoadoutSlot_GetItemFlavor( ToEHI( player ), Loadout_Character() )
	string characterRef  = ItemFlavor_GetHumanReadableRef( character ).tolower()

	if ( characterRef != "character_bloodhound" )
		return false

	return true
}
#endif


#if(CLIENT)
void function StoryPropOnActivate( entity prop, entity player, int useInputFlags )
{
	if ( !IsPlayerBloodhound( player ) )
		return

	if ( IsChallengeActive() )
		return

	StoryPropUsabilityData data
	array<string> dialogueLines

	#if(false)



#elseif(CLIENT)
		data = file.clientStoryPropData
	#endif

	string scriptName = prop.GetScriptName()

	if ( scriptName == STORY_PROP_HUNT_SCRIPTNAME )
	{
		dialogueLines = DIALOGUE_LINES_STORY_PROP_HUNT
	}
	else if ( scriptName == STORY_PROP_TECH_SCRIPTNAME )
	{
		dialogueLines = DIALOGUE_LINES_STORY_PROP_TECH
	}
	else if ( scriptName == STORY_PROP_SPIRITUAL_SCRIPTNAME )
	{
		dialogueLines = DIALOGUE_LINES_STORY_PROP_SPIRITUAL
	}

	thread MakeStoryPropUnusableWaitAndReset( data, scriptName, player )

	#if(false)


#endif
}


void function MakeStoryPropUnusableWaitAndReset( StoryPropUsabilityData data, string scriptName, entity player )
{
	EndSignal( player, SIGNAL_STORY_PROP_DIALOGUE_ABORTED )

	data.propsUsable = false
	float duration

	if ( scriptName == STORY_PROP_HUNT_SCRIPTNAME )
	{
		duration = 12.5
	}
	else if ( scriptName == STORY_PROP_TECH_SCRIPTNAME )
	{
		duration = 12.5
	}
	else if ( scriptName == STORY_PROP_SPIRITUAL_SCRIPTNAME )
	{
		duration = 19.0
	}

	OnThreadEnd(
		function() : ( data )
		{
			data.propsUsable = true
		}
	)

	wait duration
}


bool function IsChallengeActive()
{
	#if(false)

#else
		//
		if ( file.allStoryProps[0].GetLinkEntArray().len() > 0 )
			return true

		return false
	#endif
}
#endif //


#if(CLIENT)
void function OnAbortDialogue( string dialogueRefName )
{
	entity player = GetLocalClientPlayer()

	array<string> storyPropRefNames = clone(DIALOGUE_LINES_STORY_PROP_HUNT)
	storyPropRefNames.extend( DIALOGUE_LINES_STORY_PROP_TECH )
	storyPropRefNames.extend( DIALOGUE_LINES_STORY_PROP_SPIRITUAL )

	if ( storyPropRefNames.contains( dialogueRefName ) )
	{
		Signal( player, SIGNAL_STORY_PROP_DIALOGUE_ABORTED )
		Remote_ServerCallFunction( "ClientCallback_BloodTT_StoryPropDialogueAborted" )
	}
}
#endif


#if(false)




#endif


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


const vector BLOOD_TT_CHAMBER_MINS = <-108, -48, -16>
const vector BLOOD_TT_CHAMBER_MAXS = <0, 48, 88>

#if(CLIENT)
entity function GetBloodTTRewardPanelForLoot( entity lootEnt )
{
	foreach ( RewardPanelData data in file.panelDatas )
	{
		vector localPos = WorldPosToLocalPos_NoEnt( lootEnt.GetOrigin(), data.doorStartPoint.origin, data.doorStartPoint.angles )
		if ( localPos.x > BLOOD_TT_CHAMBER_MINS.x && localPos.x < BLOOD_TT_CHAMBER_MAXS.x
		&& localPos.y > BLOOD_TT_CHAMBER_MINS.y && localPos.y < BLOOD_TT_CHAMBER_MAXS.y
		&& localPos.z > BLOOD_TT_CHAMBER_MINS.z && localPos.z < BLOOD_TT_CHAMBER_MAXS.z )
			return data.panel
	}

	return null
}
#endif //


#if(CLIENT)
bool function IsBloodTTRewardPanelLocked( entity panel )
{
	return GradeFlagsHas( panel, eGradeFlags.IS_LOCKED )
}
#endif //

const vector RAVEN_EYE_LOCAL_OFFSET = <18.0, 15.0, 173.0>
const int RAVEN_EYE_COUNT = 2
const float ALARM_LENGTH = 14.0

#if(false)


//

























//












#endif //


#if(false)




















































#endif


#if(false)




















#endif


#if(false)




#endif
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


#if(CLIENT)
bool function IsBloodhountTTEnabled()
{
	if ( GetCurrentPlaylistVarBool( "bloodhound_tt_enabled", true ) )
	{
		array<string> entScriptnamesToCheck
		entScriptnamesToCheck.extend( PROWLER_PANEL_SCRIPTNAMES )
		entScriptnamesToCheck.append( STORY_PROP_HUNT_SCRIPTNAME )
		entScriptnamesToCheck.append( LOUDSPEAKER_SCRIPTNAME )

		bool allEntsPresent = true
		foreach ( string scriptName in entScriptnamesToCheck )
		{
			array<entity> entsToCheck = GetEntArrayByScriptName( scriptName )

			if ( entsToCheck.len() == 0 )
			{
				allEntsPresent = false
				break
			}
		}

		if ( allEntsPresent )
			return true

		return false
	}

	return false
}
#endif //


#if(false)
















































#endif //