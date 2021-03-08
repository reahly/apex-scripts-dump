global function MpAbilitySilence_Init
global function OnProjectileCollision_ability_silence
global function OnWeaponReadyToFire_ability_silence
global function OnWeaponTossReleaseAnimEvent_ability_silence
global function OnWeaponDeactivate_ability_silence

global function Silence_GetEffectDuration

#if(false)

#endif

                              
                                    
      

//
const float SILENCE_AREA_DURATION = 10.0
const float SILENCE_AREA_RADIUS = 175.0 //

//
const asset FX_SILENCE_READY_1P = $"P_wpn_bSilence_glow_FP"
const asset FX_SILENCE_READY_3P = $"P_wpn_bSilence_glow_3P"

const asset FX_SILENCE_VICTIM_1P = $"P_bSilent_screen_CP"
const asset FX_SILENCE_VICTIM_3P = $"P_bSilent_body"
const asset FX_SILENCE_SMOKE_CENTER = $"P_bSilent_orb"
const asset FX_SILENCE_SMOKE = $"P_bSilent_fill"
//
const vector FX_SILENCE_SMOKE_OFFSET = <0,0,-20>

//

global const string SILENCE_MOVER_SCRIPTNAME = "silence_mover"
global const string SILENCE_TRACE_SCRIPTNAME = "silence_trace_blocker"

const bool SILENCE_DEBUG = false
const bool SILENCE_DEBUG_STATUSEFFECT = false
const bool SILENCE_DEBUG_WEAPONEFFECT = false

struct
{
	int colorCorrection
	int ScreenFxId
	table<int,float> teamDebounceTimes

	float effectDuration

	#if(false)

#endif
} file

void function MpAbilitySilence_Init()
{
	PrecacheParticleSystem( FX_SILENCE_READY_1P )
	PrecacheParticleSystem( FX_SILENCE_READY_3P )
	PrecacheParticleSystem( FX_SILENCE_VICTIM_3P )
	PrecacheParticleSystem( FX_SILENCE_SMOKE )
	PrecacheParticleSystem( FX_SILENCE_SMOKE_CENTER )

	file.effectDuration = GetCurrentPlaylistVarFloat( "revenant_silence_effect_duration", 20.0 )

	#if(CLIENT)
	AddCallback_OnWeaponStatusUpdate( Silenced_WeaponStatusCheck )

	RegisterSignal( "AbilitySilence_StopColorCorrection" )
	file.ScreenFxId = PrecacheParticleSystem( FX_SILENCE_VICTIM_1P )
	file.colorCorrection = ColorCorrection_Register( "materials/correction/ability_silence.raw_hdr" )
	StatusEffect_RegisterEnabledCallback( eStatusEffect.silenced, AbilitySilence_StartVisualEffect )
	StatusEffect_RegisterDisabledCallback( eStatusEffect.silenced, AbilitySilence_StopVisualEffect )

	#else

	RegisterDynamicEntCleanupItem_Parented_Scriptname( SILENCE_MOVER_SCRIPTNAME )
	RegisterDynamicEntCleanupItem_Area_Scriptname( SILENCE_MOVER_SCRIPTNAME )
	AddDamageCallbackSourceID( eDamageSourceId.damagedef_ability_silence, ApplySilence )
	Bleedout_AddCallback_OnPlayerStartBleedout( OnPlayerStartBleedout_Silence )
	RegisterSignal( "StopSilence")

	file.abilitiesToCancel = [
		"mp_weapon_grenade_bangalore",
		"mp_ability_silence",
		"mp_ability_gibraltar_shield",
		"mp_ability_phase_walk",
		"mp_ability_phase_tunnel",
		"mp_weapon_zipline",
	]

                               
                              
  
                                                          
  
       
	#endif
}

void function OnWeaponReadyToFire_ability_silence( entity weapon )
{
	if ( SILENCE_DEBUG_WEAPONEFFECT )
		printt( "WEAPON: READY TO FIRE")

	weapon.PlayWeaponEffect( FX_SILENCE_READY_1P, FX_SILENCE_READY_3P, "muzzle_flash" )

	#if(CLIENT)
		thread PROTO_FadeModelIntensityOverTime( weapon, 1.0, 0, 255)
	#endif

}

void function OnWeaponDeactivate_ability_silence( entity weapon )
{
	if ( SILENCE_DEBUG_WEAPONEFFECT )
		printt( "WEAPON: DEACTIVATE")

	weapon.StopWeaponEffect( FX_SILENCE_READY_1P, FX_SILENCE_READY_3P )

	#if(CLIENT)
		thread PROTO_FadeModelIntensityOverTime( weapon, 0.25, 255, 0)
	#endif

	Grenade_OnWeaponDeactivate( weapon )
}

var function OnWeaponTossReleaseAnimEvent_ability_silence( entity weapon, WeaponPrimaryAttackParams attackParams )
{
	if ( SILENCE_DEBUG_WEAPONEFFECT )
		printt( "WEAPON: TOSS RELEASE")

	weapon.StopWeaponEffect( FX_SILENCE_READY_1P, FX_SILENCE_READY_3P )
	Grenade_OnWeaponTossReleaseAnimEvent( weapon, attackParams )
	return weapon.GetWeaponSettingInt( eWeaponVar.ammo_per_shot )
}

#if(false)








//



#endif //

void function OnProjectileCollision_ability_silence( entity projectile, vector pos, vector normal, entity hitEnt, int hitbox, bool isCritical, bool isPassthrough )
{
	#if(false)





















//







#endif
	projectile.GrenadeExplode( normal )
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












//




//





















//







//































//
































//






























#endif //


#if(CLIENT)
void function Silenced_WeaponStatusCheck( entity player, var rui, int slot )
{
	switch ( slot )
	{
		case OFFHAND_LEFT:
		case OFFHAND_INVENTORY:
			if ( StatusEffect_GetSeverity( player, eStatusEffect.silenced ) )
			{
				RuiSetString( rui, "hintText", Localize( "#SILENCED" ) )
				RuiSetBool( rui, "isSilenced", true )
			}
			else
			{
				RuiSetBool( rui, "isSilenced", false )
			}
			break
	}
}

void function AbilitySilence_StartVisualEffect( entity ent, int statusEffect, bool actuallyChanged )
{
	if ( !actuallyChanged && GetLocalViewPlayer() == GetLocalClientPlayer() )
		return

	if ( ent != GetLocalViewPlayer() )
		return

	entity viewPlayer = ent

	//

	thread AbilitySilence_UpdatePlayerScreenColorCorrection( viewPlayer )

	int fxHandle = StartParticleEffectOnEntityWithPos( viewPlayer, file.ScreenFxId, FX_PATTACH_ABSORIGIN_FOLLOW, -1, viewPlayer.EyePosition(), <0,0,0> )
	EffectSetIsWithCockpit( fxHandle, true )

	thread AbilitySilence_ScreenEffectThread( viewPlayer, fxHandle, statusEffect )

}


void function AbilitySilence_StopVisualEffect( entity ent, int statusEffect, bool actuallyChanged )
{
	if ( !actuallyChanged && GetLocalViewPlayer() == GetLocalClientPlayer() )
		return

	if ( ent != GetLocalViewPlayer() )
		return

	if ( IsAlive( ent ) )
	{
		EmitSoundOnEntity( ent, "Survival_UI_Ability_Ready_SilenceEnded" )
	}

	ent.Signal( "AbilitySilence_StopColorCorrection" )
}


void function AbilitySilence_UpdatePlayerScreenColorCorrection( entity player )
{
	Assert ( IsNewThread(), "Must be threaded off." )
	Assert ( player == GetLocalViewPlayer() )

	player.EndSignal( "OnDeath" )
	player.EndSignal( "OnDestroy" )
	player.EndSignal( "AbilitySilence_StopColorCorrection" )

	OnThreadEnd(
		function() : ( player )
		{
			ColorCorrection_SetWeight( file.colorCorrection, 0.0 )
			ColorCorrection_SetExclusive( file.colorCorrection, false )
		}
	)

	ColorCorrection_SetExclusive( file.colorCorrection, true )
	ColorCorrection_SetWeight( file.colorCorrection, 1.0 )

	const LERP_IN_TIME = 0.0125	//
	float startTime = Time()

	while ( true )
	{
		float timeRemaining = StatusEffect_GetTimeRemaining( player, eStatusEffect.silenced )
		float normalizedTime = timeRemaining / Silence_GetEffectDuration()

		ColorCorrection_SetWeight( file.colorCorrection, normalizedTime )

		if ( SILENCE_DEBUG_STATUSEFFECT )
			DebugScreenText( 0.427, 0.69, "ColorCorrection Weight: " + normalizedTime )

		WaitFrame()
	}
}


void function AbilitySilence_ScreenEffectThread( entity viewPlayer, int fxHandle, int statusEffect )
{
	EndSignal( viewPlayer, "OnDeath" )
	EndSignal( viewPlayer, "AbilitySilence_StopColorCorrection" )

	OnThreadEnd(
		function() : ( fxHandle, viewPlayer )
		{
			if ( !EffectDoesExist( fxHandle ) )
				return

			EffectStop( fxHandle, false, true )
			if ( IsValid( viewPlayer ) )
				StopSoundOnEntity( viewPlayer, "Silence_Victim_Loop_1p" )
		}
	)

	EmitSoundOnEntity( viewPlayer, "Silence_Victim_Loop_1p")
	bool stopSoundOnce = false
	while( true )
	{
		float timeRemaining = StatusEffect_GetTimeRemaining( viewPlayer, eStatusEffect.silenced )
		float CP1Value = timeRemaining / Silence_GetEffectDuration()

		if ( SILENCE_DEBUG_STATUSEFFECT )
			DebugScreenText( 0.47, 0.68, "CP1 Value: " + CP1Value )

		if ( !EffectDoesExist( fxHandle ) )
			break

		EffectSetControlPointVector( fxHandle, 1, <CP1Value,255,255> )
		if ( stopSoundOnce == false && timeRemaining < 3 )
		{
			stopSoundOnce = true
			StopSoundOnEntity( viewPlayer, "Silence_Victim_Loop_1p" )
		}
		WaitFrame()
	}
}

#endif //

#if(false)




#endif //

bool function SilenceDisablesHeals()
{
	return GetCurrentPlaylistVarBool( "revenant_silence_disables_heal", false )
}

float function Silence_GetEffectDuration()
{
	return file.effectDuration
}