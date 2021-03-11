global function Caustic_TT_Init
global function Caustic_TT_RegisterNetworking
global function IsCausticTTEnabled
global function GetCausticTTCanisterFrameForLoot
global function AreCausticTTCanistersClosed

#if(false)

#endif //

#if(CLIENT)
global function Caustic_TT_ServerCallback_SetCanistersOpen
global function Caustic_TT_ServerCallback_SetCanistersClosed
global function Caustic_TT_ServerCallback_ToxicWaterEmitterOn
global function Caustic_TT_ServerCallback_ToxicWaterEmitterOff

const string CAUSTIC_TT_TOXIC_WATER_AUDIO_EMIT = "caustic_tt_floor_ambient_generic"
#endif //

const string CAUSTIC_TT_SWITCH_SCRIPTNAME = "caustic_tt_switch"
const string CAUSTIC_TT_CANISTER_FRAME_SCRIPTNAME = "caustic_tt_canister_frame"

const float CANISTER_TIMER_START = 15.0
const float CANISTER_TIMER_END = 10.0

const int CANISTER_DISTANCE_FRAME_TO_LOOT_SQR = 4900

#if(false)







































#endif //

#if(false)



















#endif //

struct
{
	bool 				canistersClosed
	array < entity >	canisterFrames
	array < entity >	canisterSwitches
	array < entity >	windowHighlights
	array < string >	canisterLootRefs

	#if(CLIENT)
		array < entity >	toxicWaterEmitters
	#endif

	#if(false)








#endif //
}file

void function Caustic_TT_Init()
{
	AddCallback_EntitiesDidLoad( EntitiesDidLoad )

	#if(false)



#endif //
}

void function Caustic_TT_RegisterNetworking()
{
	Remote_RegisterClientFunction( "Caustic_TT_ServerCallback_SetCanistersOpen" )
	Remote_RegisterClientFunction( "Caustic_TT_ServerCallback_SetCanistersClosed" )
	Remote_RegisterClientFunction( "Caustic_TT_ServerCallback_ToxicWaterEmitterOn" )
	Remote_RegisterClientFunction( "Caustic_TT_ServerCallback_ToxicWaterEmitterOff" )
}

void function EntitiesDidLoad()
{
	if ( !IsCausticTTEnabled() )
		return

	#if(false)









//

#endif //

	#if(CLIENT)
		//
		foreach ( entity emitter in GetEntArrayByScriptName( CAUSTIC_TT_TOXIC_WATER_AUDIO_EMIT ) )
			file.toxicWaterEmitters.append( emitter )
	#endif //

	file.canistersClosed = true

	foreach ( entity canisterSwitch in GetEntArrayByScriptName( CAUSTIC_TT_SWITCH_SCRIPTNAME ) )
	{
		#if(false)






#endif //

		SetCallback_CanUseEntityCallback( canisterSwitch, CanisterSwitch_CanUse )
		AddCallback_OnUseEntity_ClientServer( canisterSwitch, CanisterSwitch_OnUse )

		#if(CLIENT)
			AddEntityCallback_GetUseEntOverrideText( canisterSwitch, GetCanisterSwitchUseTextOverride )
		#endif //

		file.canisterSwitches.append( canisterSwitch )
	}

	//
	foreach ( entity canisterFrame in GetEntArrayByScriptName( CAUSTIC_TT_CANISTER_FRAME_SCRIPTNAME ) )
		file.canisterFrames.append( canisterFrame )

	#if(false)


















































































































#endif //
}

bool function CanisterSwitch_CanUse ( entity player, entity canisterSwitch )
{
	if ( !SURVIVAL_PlayerCanUse_AnimatedInteraction( player, canisterSwitch ) )
		return false

	return true
}

#if(CLIENT)
string function GetCanisterSwitchUseTextOverride( entity canisterSwitch )
{
	if ( file.canistersClosed )
	{
		return "#CAUSTIC_TT_SWITCH_ON"
	}

	return ""
}
#endif //

void function CanisterSwitch_OnUse( entity canisterSwitch, entity player, int useInputFlags )
{
	if ( file.canistersClosed )
	{
		if ( useInputFlags & USE_INPUT_LONG )
			thread CanisterSwitch_UseThink_Thread( canisterSwitch, player )
	}
	else
	{
		#if(false)

#endif //
	}
}

void function CanisterSwitch_UseThink_Thread( entity ent, entity playerUser )
{
	ent.EndSignal( "OnDestroy" )

	ExtendedUseSettings settings
	settings.loopSound = "survival_titan_linking_loop"
	settings.successSound = "ui_menu_store_purchase_success"
	settings.duration = 1.0
	settings.successFunc = CanisterSwitch_ExtendedUseSuccess

	#if CLIENT || UI 
		settings.icon = $""
		settings.hint = Localize ( "#CAUSTIC_TT_ACTIVATE" )
		settings.displayRui = $"ui/extended_use_hint.rpak"
		settings.displayRuiFunc = CanisterSwitch_DisplayRui
	#endif //

	waitthread ExtendedUse( ent, playerUser, settings )
}

void function CanisterSwitch_DisplayRui( entity ent, entity player, var rui, ExtendedUseSettings settings )
{
	#if CLIENT || UI 
		RuiSetString( rui, "holdButtonHint", settings.holdHint )
		RuiSetString( rui, "hintText", settings.hint )
		RuiSetGameTime( rui, "startTime", Time() )
		RuiSetGameTime( rui, "endTime", Time() + settings.duration )
	#endif //
}

void function CanisterSwitch_ExtendedUseSuccess( entity canisterSwitch, entity player, ExtendedUseSettings settings )
{
		if ( !IsValid( player ) )
			return

		if ( !IsValid( canisterSwitch ) )
			return

	thread CanisterSwitch_TrapActivate_Thread( player )
}

void function CanisterSwitch_TrapActivate_Thread( entity player )
{
	CanisterSwitches_Disabled()

	#if(false)

//

























#endif //

	wait 2.0

	#if(false)




#endif //

	wait 7.5

	#if(false)


#endif //

	wait 7.5 //

	#if(false)

#endif //

	wait CANISTER_TIMER_END

	thread CanisterSwitch_TrapExpired_Thread()
}

void function CanisterSwitch_TrapExpired_Thread()
{
	#if(false)
//



































#endif //

	wait 2.0

	#if(false)

#endif //

	wait 5.0

	#if(false)


#endif //

	wait 3.0

	CanisterSwitches_Enabled()
}

void function CanisterSwitches_Disabled()
{
	#if(false)








#endif //

	file.canistersClosed = false
}

void function CanisterSwitches_Enabled()
{
	#if(false)
//







//









//








#endif //

	file.canistersClosed = true
}

#if(false)






















//





































//



































































//
//



























//










































#endif //

#if(CLIENT)
void function Caustic_TT_ServerCallback_SetCanistersOpen()
{
	file.canistersClosed = false
}

void function Caustic_TT_ServerCallback_SetCanistersClosed()
{
	file.canistersClosed = true
}

void function Caustic_TT_ServerCallback_ToxicWaterEmitterOff()
{
	foreach ( entity emitter in file.toxicWaterEmitters )
	{
		emitter.SetEnabled( false )
	}
}

void function Caustic_TT_ServerCallback_ToxicWaterEmitterOn()
{
	foreach ( entity emitter in file.toxicWaterEmitters )
	{
		emitter.SetEnabled( true )
	}
}
#endif

entity function GetCausticTTCanisterFrameForLoot( entity lootEnt )
{
	foreach ( canisterFrame in file.canisterFrames )
	{
		if ( IsValid( canisterFrame ) ) //
			if ( DistanceSqr( canisterFrame.GetOrigin(), lootEnt.GetOrigin() ) < CANISTER_DISTANCE_FRAME_TO_LOOT_SQR )
				return canisterFrame
	}

	return null
}

bool function AreCausticTTCanistersClosed()
{
	return file.canistersClosed
}

bool function IsPlayerCaustic( entity player )
{
	ItemFlavor character = LoadoutSlot_GetItemFlavor( ToEHI( player ), Loadout_Character() )
	string characterRef  = ItemFlavor_GetHumanReadableRef( character ).tolower()

	if ( characterRef != "character_caustic" )
		return false

	return true
}

bool function IsCausticTTEnabled()
{
	bool causticTTSwitchExists = true
	array<entity> causticTTSwitches = GetEntArrayByScriptName( CAUSTIC_TT_SWITCH_SCRIPTNAME )
	if ( causticTTSwitches.len() == 0 )
		causticTTSwitchExists = false

	return causticTTSwitchExists
}