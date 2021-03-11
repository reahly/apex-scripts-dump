#if(false)

#endif

global function CanyonLandsCausticLore_PreMapInit

#if(CLIENT)
global function ClCanyonLandsCausticLore_Init
global function ServerToClient_PlayCausticLoreMessage
global function SCB_KCCausticLore_SetMessageIdxToCustomSpeakerIdx
#endif


const string PANEL_DENY_SFX = "Caustic_TT_Screen_Deny"
const string HACK_SUCCESS_SFX = "Caustic_TT_Screen_Hacked"
const string HACK_LOADING_SFX = "Caustic_TT_Screen_Loading"
const string HACK_AMBIENT_SFX = "Caustic_TT_Screen_Ambient"
const string HACK_FADE_OUT_SFX = "Caustic_TT_Screen_End"


const asset SCREEN_CSV_DIALOGUE = $"datatable/dialogue/canyonlands_caustic_lore_dialogue.rpak"
const string SCREEN_SCRIPTNAME = "caustic_lab_monitor"

const float SCREEN_LOADING_DURATION = 6.0
const float SCREEN_LOADING_FADE_OUT_DURATION = 1.0
const float SCREEN_LOADING_FADE_OUT_BUFFER = 0.5
const float SCREEN_MESSAGE_FADE_IN_DURATION = 1.5
const float SCREEN_MESSAGE_FADE_OUT_DURATION = 1.0
const float SCREEN_MESSAGE_DURATION = 32.0
const float SCREEN_VO_BUFFER_DURATION = 1.0

const int CAUSTIC_LOG_DIALOGUE_FLAGS =
		eDialogueFlags.USE_CUSTOM_QUEUE |
		eDialogueFlags.USE_CUSTOM_SPEAKERS |
		eDialogueFlags.BLOCK_LOWER_PRIORITY_QUEUE_ITEMS |
		eDialogueFlags.MUTE_PLAYER_PING_DIALOGUE_FOR_DURATION |
		eDialogueFlags.MUTE_PLAYER_PING_CHIMES_FOR_DURATION |
		eDialogueFlags.BLOCK_ANNOUNCER

#if(CLIENT)
struct LoreScreenData
{
	array<entity> screens
	float         messageDuration = 0.0

	#if(CLIENT)
		var topo
		var rui
		asset      image1 = $""
		asset      image2 = $""
		asset      image3 = $""
		asset      image4 = $""
		asset      image5 = $""
		asset      image6 = $""
		asset      image7 = $""
		asset      image8 = $""
		float      lightnessVal = -0.45
	#endif
}
#endif //


const string LAB_DOOR_SCRIPTNAME = "CausticLabDoor"
const string LAB_ACCESS_PANEL_SCRIPTNAME = "CausticLabAccess"

struct
{
	LoreScreenData screenData

	#if(false)

#endif

	#if(CLIENT)
		int messageIdxToCustomSpeaker = -1
	#endif

	array< entity > labDoors
	array< entity > labAccessPanels
} file


#if(false)







#endif


#if(CLIENT)
void function ClCanyonLandsCausticLore_Init()
{
	RegisterCSVDialogue( SCREEN_CSV_DIALOGUE )

	AddCallback_EntitiesDidLoad( EntitiesDidLoad )
	AddCallback_FullUpdate( AudioLogsOnFullUpdate )
	AddCreateCallback( "prop_dynamic", LabAccessPanelSpawned )
	AddCreateCallback( "prop_door", LabDoorSpawned )
}
#endif

#if(CLIENT)
void function EntitiesDidLoad()
{
	if ( !DoLoreScreensExist() )
		return

	#if(false)



#endif

	#if(CLIENT)
		AddCallback_OnYouRespawned ( AudioLogsOnFullUpdate )
	#endif

	SetupLoreScreens()
}
#endif //

void function CanyonLandsCausticLore_PreMapInit()
{
	AddCallback_OnNetworkRegistration( CanyonLandsCausticLore_OnNetworkRegistration )
}


void function CanyonLandsCausticLore_OnNetworkRegistration()
{
	Remote_RegisterClientFunction( "SCB_KCCausticLore_SetMessageIdxToCustomSpeakerIdx", "int", 0, NUM_TOTAL_DIALOGUE_QUEUES )
}

#if(CLIENT)
void function AudioLogsOnFullUpdate()
{
	file.screenData.screens =  GetEntArrayByScriptName( SCREEN_SCRIPTNAME )

	if ( file.messageIdxToCustomSpeaker != -1 )
		RegisterCustomDialogueQueueSpeakerEntities( file.messageIdxToCustomSpeaker, GetEntArrayByScriptName( SCREEN_SCRIPTNAME ) )
}
#endif

#if(false)




#endif


#if(CLIENT)
bool function DoLoreScreensExist()
{
	array<entity> screenArray = GetEntArrayByScriptName( SCREEN_SCRIPTNAME )
	if ( screenArray.len() < 1 )
		return false
	return true
}
#endif

#if(CLIENT)
void function SetupLoreScreens()
{


	file.screenData.screens = GetEntArrayByScriptName( SCREEN_SCRIPTNAME )
	file.screenData.messageDuration = SCREEN_MESSAGE_DURATION
	#if(CLIENT)
		file.screenData.image1 = $"rui/events/s08_story_events/stage5_plan_reveal_03"
		file.screenData.image2 = $"rui/events/s08_story_events/stage5_plan_reveal_01"
		file.screenData.image3 = $"rui/events/s08_story_events/stage5_plan_reveal_02"
		file.screenData.image4 = $"rui/events/s08_story_events/stage5_plan_reveal_00"
		file.screenData.image5 = $"rui/events/s08_story_events/stage5_plan_reveal_03"
		file.screenData.image6 = $"rui/events/s08_story_events/stage5_plan_reveal_04"
		file.screenData.image7 = $"rui/events/s08_story_events/stage5_plan_reveal_04"
	#endif

	foreach ( entity screen in file.screenData.screens )
	{
		#if(CLIENT)
			vector originOffset = screen.GetOrigin()
			file.screenData.topo = CreateRUITopology_Worldspace( originOffset,screen.GetAngles() + <0, -90, 0>, 81.815, 33.561 )
		#endif

		#if(false)






#endif
	}


	#if(CLIENT)
		CreateIdleRuiForLoreData( file.screenData )
	#endif
}
#endif //

#if(false)


















#endif

#if(CLIENT)
void function ServerToClient_PlayCausticLoreMessage()
{
	thread PlayCausitcLoreMessage()
}
#endif


#if(CLIENT)
void function PlayCausitcLoreMessage( )
{
	EndSignal( GetLocalClientPlayer(), "OnDeath" )

	LoreScreenData data = file.screenData

	OnThreadEnd(
		function() : ( data )
		{
			RuiDestroyIfAlive( data.rui )
			CreateIdleRuiForLoreData( data )
		}
	)

	foreach ( entity screen in data.screens )
	{
		if ( IsValid( screen ) )
			EmitSoundOnEntity( screen, HACK_SUCCESS_SFX )
	}

	//
	RuiSetGameTime( data.rui, "idleEndTime", Time() )
	RuiSetFloat( data.rui, "loadingFadeOutDuration", SCREEN_LOADING_FADE_OUT_DURATION )

	foreach ( entity screen in data.screens )
	{
		if ( IsValid( screen ) )
			EmitSoundOnEntity( screen, HACK_LOADING_SFX )
	}

	wait SCREEN_LOADING_DURATION

	RuiSetGameTime( data.rui, "fadeOutStartTime", Time() )

	wait SCREEN_LOADING_FADE_OUT_DURATION + SCREEN_LOADING_FADE_OUT_BUFFER

	//

	RuiDestroyIfAlive( data.rui )

	//
	data.rui = RuiCreate( $"ui/lore_screen_wide.rpak", data.topo, RUI_DRAW_WORLD, 0 )
	RuiSetFloat( data.rui , "messageFadeInTime", SCREEN_MESSAGE_FADE_IN_DURATION )
	RuiSetFloat( data.rui , "messageFadeOutTime", SCREEN_MESSAGE_FADE_OUT_DURATION )
	RuiSetFloat( data.rui , "messageDuration", data.messageDuration )
	RuiSetAsset( data.rui , "messageImage1", data.image1 )
	RuiSetAsset( data.rui , "messageImage2", data.image2 )
	RuiSetAsset( data.rui , "messageImage3", data.image3 )
	RuiSetAsset( data.rui , "messageImage4", data.image4 )
	RuiSetAsset( data.rui , "messageImage5", data.image5 )
	RuiSetAsset( data.rui , "messageImage6", data.image6 )
	RuiSetAsset( data.rui , "messageImage7", data.image7 )
	RuiSetAsset( data.rui , "messageImage8", data.image8 )
	RuiSetFloat( data.rui , "lightnessVal", data.lightnessVal )


	thread PlayScreenVO( data )

	foreach ( entity screen in data.screens )
	{
		if ( IsValid( screen ) )
			EmitSoundOnEntity( screen, HACK_AMBIENT_SFX )
	}

	wait SCREEN_MESSAGE_FADE_IN_DURATION

	wait data.messageDuration

	foreach ( entity screen in data.screens )
	{
		if ( !IsValid( screen ) )
			continue

		StopSoundOnEntity( screen, HACK_AMBIENT_SFX )
		EmitSoundOnEntity( screen, HACK_FADE_OUT_SFX )
	}

	wait SCREEN_MESSAGE_FADE_OUT_DURATION + 0.25
}
#endif


#if(CLIENT)
void function PlayScreenVO( LoreScreenData data )
{
	entity localPlayer = GetLocalClientPlayer()
	EndSignal( localPlayer, "OnDeath" )

	int dialogueFlags = CAUSTIC_LOG_DIALOGUE_FLAGS

	array<string> dialogueRefs
	dialogueRefs.append( "bc_CanyonlandsCausticLore_Part5_a" )
	dialogueRefs.append( "bc_CanyonlandsCausticLore_Part5_b" )
	dialogueRefs.append( "bc_CanyonlandsCausticLore_Part5_c" )
	dialogueRefs.append( "bc_CanyonlandsCausticLore_Part5_d" )

	foreach ( string dialogueRef in dialogueRefs )
	{
		float duration = GetSoundDuration( GetAnyDialogueAliasFromName( dialogueRef ) )

		int customSpeakerIdx = GetCustomSpeakerIdxFromMessageIdx()
		PlayDialogueOnCustomSpeakers( GetAnyAliasIdForName( dialogueRef ), dialogueFlags, customSpeakerIdx )

		wait duration

		if ( dialogueRefs.top() != dialogueRef )
			wait SCREEN_VO_BUFFER_DURATION
	}
}
#endif //

#if(CLIENT)
void function SCB_KCCausticLore_SetMessageIdxToCustomSpeakerIdx( int speakerIdx1 )
{
	file.messageIdxToCustomSpeaker = speakerIdx1
	RegisterCustomDialogueQueueSpeakerEntities( speakerIdx1, GetEntArrayByScriptName( SCREEN_SCRIPTNAME ) )
}
#endif

#if(CLIENT)
int function GetCustomSpeakerIdxFromMessageIdx()
{
	Assert( file.messageIdxToCustomSpeaker != -1, "Tried to get custom speaker index that wasn't set up!" )
	return file.messageIdxToCustomSpeaker
}
#endif

#if(CLIENT)
void function CreateIdleRuiForLoreData( LoreScreenData data )
{
	data.rui = RuiCreate( $"ui/lore_screen_idle_caustic.rpak", data.topo, RUI_DRAW_WORLD, 0 )
}
#endif

void function LabAccessPanelSpawned( entity panel )
{
	if ( !IsValidLabAccessPanelEnt( panel ) )
		return

	file.labAccessPanels.append( panel )

	#if(false)

#endif //

	SetLabAccessPanelUsable( panel )
}

void function SetLabAccessPanelUsable ( entity panel )
{
	#if(false)




#endif //

	#if(CLIENT)
		AddCallback_OnUseEntity_ClientServer( panel, OnLabAccessPanelUse )
		AddEntityCallback_GetUseEntOverrideText( panel, OnLabAccessTextOverride )
	#endif //
}

void function OnLabAccessPanelUse( entity panel, entity playerUser, int useInputFlags )
{
	ItemFlavor character = LoadoutSlot_GetItemFlavor( ToEHI( playerUser ), Loadout_Character() )
	string characterRef  = ItemFlavor_GetHumanReadableRef( character ).tolower()
	if ( characterRef != "character_caustic" && characterRef != "character_wattson" )
	{
		#if(CLIENT)
			EmitSoundOnEntity( panel, PANEL_DENY_SFX )
		#endif
		return
	}


	#if(CLIENT)
		EmitSoundOnEntity( panel, "lootVault_Access" )
	#endif

	#if(false)










#endif
}

#if(CLIENT)
string function OnLabAccessTextOverride( entity ent )
{
	entity player = GetLocalViewPlayer()
	if ( !IsValid (player) )
	{
		return ""
	}

	ItemFlavor character = LoadoutSlot_GetItemFlavor( ToEHI( player ), Loadout_Character() )
	string characterRef  = ItemFlavor_GetHumanReadableRef( character ).tolower()
	if ( characterRef != "character_caustic" && characterRef != "character_wattson" )
	{
		return "#CAUSTIC_LAB_ACCESS_REQUIREMENT"
	}

	return "#CAUSTIC_LAB_ACCESS_USE"
}
#endif

bool function IsValidLabAccessPanelEnt ( entity ent )
{
	if ( ent.GetScriptName() == LAB_ACCESS_PANEL_SCRIPTNAME )
		return true

	return false
}

void function LabDoorSpawned( entity door )
{
	if ( !IsValidLabDoorEnt( door ) )
		return

	#if(false)






#endif //

	file.labDoors.append( door )
}

bool function IsValidLabDoorEnt( entity ent )
{
	if ( !IsDoor( ent ) )
		return false

	string scriptName = ent.GetScriptName()
	if ( scriptName != LAB_DOOR_SCRIPTNAME )
		return false

	return true
}