global function MpWeaponIncapShield_Init

global function OnWeaponChargeBegin_weapon_incap_shield
global function OnWeaponChargeEnd_weapon_incap_shield
global function OnWeaponOwnerChanged_weapon_incap_shield
global function OnWeaponPrimaryAttack_incap_shield
global function OnWeaponPrimaryAttackAnimEvent_incap_shield
global function OnWeaponActivate_incap_shield
global function OnWeaponDeactivate_incap_shield

#if(CLIENT)
global function OnCreateChargeEffect_incap_shield
#endif //

global function IncapShield_GetMaxShieldHealthFromTier

//
const bool INCAP_SHIELD_PERSIST_LOGIC = true
const bool INCAP_SHIELD_DEBUG = false

const INCAP_SHIELD_FX_WALL_FP = $"P_down_shield_CP" //
const INCAP_SHIELD_FX_WALL = $"P_down_shield_CP" //
const INCAP_SHIELD_FX_COL = $"mdl/fx/down_shield_01.rmdl" //
const INCAP_SHIELD_FX_BREAK = $"P_down_shield_break_CP"

const string SOUND_PILOT_INCAP_SHIELD_3P = "BleedOut_Shield_Sustain_3p"
const string SOUND_PILOT_INCAP_SHIELD_1P = "BleedOut_Shield_Sustain_1p"

const string SOUND_PILOT_INCAP_SHIELD_END_3P = "BleedOut_Shield_Break_3P"
const string SOUND_PILOT_INCAP_SHIELD_END_1P = "BleedOut_Shield_Break_1P"

const vector COLOR_SHIELD_TIER4_HIGH = <220, 185, 39>
const vector COLOR_SHIELD_TIER4_MED = <219, 200, 121>
const vector COLOR_SHIELD_TIER4_LOW = <219, 211, 175>

const vector COLOR_SHIELD_TIER3_HIGH = <158, 73, 188>
const vector COLOR_SHIELD_TIER3_MED = <171, 123, 188>
const vector COLOR_SHIELD_TIER3_LOW = <184, 170, 188>

const vector COLOR_SHIELD_TIER2_HIGH = <58, 133, 176>
const vector COLOR_SHIELD_TIER2_MED = <114, 153, 176>
const vector COLOR_SHIELD_TIER2_LOW = <158, 169, 176>

const vector COLOR_SHIELD_TIER1_HIGH = <255, 255, 255>
const vector COLOR_SHIELD_TIER1_MED = <191, 191, 191>
const vector COLOR_SHIELD_TIER1_LOW = <191, 191, 191>

struct
{
	int shieldhealthTier1
	int shieldhealthTier2
	int shieldhealthTier3
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

void function MpWeaponIncapShield_Init()
{
	PrecacheModel( INCAP_SHIELD_FX_COL )

	PrecacheParticleSystem( INCAP_SHIELD_FX_WALL_FP )
	PrecacheParticleSystem( INCAP_SHIELD_FX_WALL )
	PrecacheParticleSystem( INCAP_SHIELD_FX_BREAK )

	RegisterSignal( "IncapShieldBeginCharge" )

	file.shieldhealthTier1 = GetCurrentPlaylistVarInt( "survival_bleedout_shield_health_tier1", 200 )
	file.shieldhealthTier2 = GetCurrentPlaylistVarInt( "survival_bleedout_shield_health_tier2", 450 )
	file.shieldhealthTier3 = GetCurrentPlaylistVarInt( "survival_bleedout_shield_health_tier3", 750 )
}

vector function GetIncapShieldTriLerpColor( float frac, int tier )
{
	vector color1
	vector color2
	vector color3

	switch( tier )
	{
		case 4:
			color1 = COLOR_SHIELD_TIER4_LOW
			color2 = COLOR_SHIELD_TIER4_MED
			color3 = COLOR_SHIELD_TIER4_HIGH
			break
		case 3:
			color1 = COLOR_SHIELD_TIER3_LOW
			color2 = COLOR_SHIELD_TIER3_MED
			color3 = COLOR_SHIELD_TIER3_HIGH
			break
		case 2:
			color1 = COLOR_SHIELD_TIER2_LOW
			color2 = COLOR_SHIELD_TIER2_MED
			color3 = COLOR_SHIELD_TIER2_HIGH
			break
		default:
			color1 = COLOR_SHIELD_TIER1_LOW
			color2 = COLOR_SHIELD_TIER1_MED
			color3 = COLOR_SHIELD_TIER1_HIGH
	}

	return GetTriLerpColor( frac, color1, color2, color3, 0.55, 0.10 )
}

int function IncapShield_GetShieldTier( entity player )
{
	return EquipmentSlot_GetEquipmentTier( player, "incapshield" )
}

int function IncapShield_GetMaxShieldHealthFromTier( int tier )
{
	switch( tier )
	{
		case 2:
			return file.shieldhealthTier2
		case 3:
		case 4:
			return file.shieldhealthTier3
		default:
			return file.shieldhealthTier1
	}

	unreachable
}

int function IncapShield_GetShieldImpactColorID( entity player )
{
	int shieldTier = IncapShield_GetShieldTier( player )
	return COLORID_FX_LOOT_TIER0 + shieldTier
}

#if(false)





































#endif //

#if(CLIENT)
void function OnCreateChargeEffect_incap_shield( entity weapon, int fxHandle )
{
	int shieldEnergy = weapon.GetScriptInt0()
	if ( shieldEnergy <= 0 )
	{
		weapon.StopWeaponEffect( $"P_down_shield_CP", $"P_down_shield_CP" )
		return
	}

	thread UpdateFirstPersonIncapShieldColor_Thread( weapon, fxHandle )
}

void function UpdateFirstPersonIncapShieldColor_Thread( entity weapon, int fxHandle )
{
	weapon.EndSignal( "OnDestroy" )
	weapon.EndSignal( "OnChargeEnd" )

	entity weaponOwner = weapon.GetOwner()
	weaponOwner.EndSignal( "OnDeath" )
	weaponOwner.EndSignal( "OnDestroy" )

	while ( EffectDoesExist( fxHandle ) )
	{
		float currentHealth = IsValid( weapon ) ? float( weapon.GetScriptInt0() ) : 0.0
		float maxHealth = float( IncapShield_GetMaxShieldHealthFromTier( IncapShield_GetShieldTier( weapon.GetOwner() ) )  )
		float healthFrac = currentHealth / maxHealth
		vector colorVec = GetIncapShieldTriLerpColor( healthFrac, IncapShield_GetShieldTier( GetLocalViewPlayer() ) )

		EffectSetControlPointVector( fxHandle, 2, colorVec )

		if ( currentHealth <= 0 )
		{
			weapon.StopWeaponEffect( $"P_down_shield_CP", $"P_down_shield_CP" )
		}

		WaitFrame()
	}
}
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

#if(true)

var function OnWeaponPrimaryAttack_incap_shield( entity weapon, WeaponPrimaryAttackParams attackParams )
{
	return 0
}

var function OnWeaponPrimaryAttackAnimEvent_incap_shield( entity weapon, WeaponPrimaryAttackParams attackParams )
{
	return 0
}

void function OnWeaponOwnerChanged_weapon_incap_shield( entity weapon, WeaponOwnerChangedParams changeParams )
{
#if(false)





#endif //
}

void function OnWeaponActivate_incap_shield( entity weapon )
{
#if(false)



//









































#endif //
}

void function OnWeaponDeactivate_incap_shield( entity weapon )
{
#if(false)






#endif //
}

bool function OnWeaponChargeBegin_weapon_incap_shield( entity weapon )
{
#if(false)





#endif //

	return true
}

void function OnWeaponChargeEnd_weapon_incap_shield( entity weapon )
{
	weapon.Signal( "OnChargeEnd" )
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











































#endif //

#endif //