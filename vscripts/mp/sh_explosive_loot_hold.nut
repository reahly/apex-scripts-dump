                            
global function ShExplosiveHold_Init
global function ExplosiveHold_IsOpen
global function ExplosiveHold_PlayerHasGrenadeInInventory

#if(CLIENT)
global function ExplosiveHold_IsPlayerPlantingGrenade
#endif

global const asset EXPLOSIVE_HOLD_PROXY = $"mdl/props/explosivehold_container_01/explosivehold_container_01_proxy.rmdl"
global const string EXPLOSIVE_HOLD_PANEL_SCRIPTNAME = "explosive_hold_panel"

const string EXPLOSIVE_HOLD_SCRIPTNAME = "explosive_hold"
const string EXPLOSIVE_HOLD_GUN_RACK_SCRIPTNAME = "explosive_hold_gun_rack"
const string EXPLOSIVE_HOLD_PANEL_HOUSING = "explosive_hold_panel_housing"
const string EXPLOSIVE_HOLD_DOOR_RIGHT = "explosive_hold_door_right"
const string EXPLOSIVE_HOLD_DOOR_LEFT = "explosive_hold_door_left"
const string EXPLOSIVE_HOLD_VENT_SMOKE_SCRIPTNAME = "explosive_hold_vent_fx_helper"

const string EXPLOSIVE_HOLD_WEAPON_LOOT_GROUP = "Weapon_Medium"

const string DOOR_DENY_SOUND = "menu_deny"
const string GRENADE_DETONATE_SOUND = "Loot_ExplosiveHold_Explosion_3p"
const string ARC_PLACEMENT_SOUND = "weapon_arcstar_explosivewarningbeep"
const string PANEL_ALARM_SOUND = "Loot_ExplosiveHold_PanelAlarm_3p"
const string OPEN_DOOR_DAMAGED_SOUND = "Loot_ExplosiveHold_Door_Damaged_Open_3p"
const string OPEN_DOOR_SOUND = "Loot_ExplosiveHold_Door_Back_Open_3p"

const float GRENADE_FUSE = 2.0
const float PANEL_UPWARD_OFFSET = 69.0
const float PANEL_USABLE_DISTANCE_OVERRIDE = 20.0
const float PANEL_USABLE_HEIGHT = 80.0

const asset EXPLOSIVE_HOLD_PANEL_ANIM_IDLE = $"animseq/props/explosivehold_panel_animated/explosivehold_panel_idle.rseq"
const asset EXPLOSIVE_HOLD_EXPLOSION_FX = $"P_exp_hold_exp_emp_med"
const asset EXPLOSIVE_HOLD_VENT_SMOKE_FX = $"P_exp_hold_vent_smk_linger_sm"

const int EXPLOSIVE_HOLD_WEAPONS_NEEDED = 6 //
const int EXPLOSIVE_HOLD_CRATE_WEAPON_LOOT_TIER = 5

#if(false)




#endif

const asset EXPLOSIVE_HOLD_ARC_GRENADE_MODEL = $"mdl/weapons_r5/loot/w_loot_wep_iso_shuriken.rmdl"

struct ExplosiveHoldGrenadeData
{
	asset  panelOpenAnim
	string thirdPersonAnim
	string firstPersonAnim
	asset  modelName
	string weaponName
	string targetName

             
	asset panelOpenAnim_Fuse
	string firstPersonAnim_Fuse
       
}
const ExplosiveHoldGrenadeData fragGrenadeData = {
	panelOpenAnim = $"animseq/props/explosivehold_panel_animated/explosivehold_panel_open_frag.rseq",
	thirdPersonAnim = "pilot_explosive_hold_start_frag",
	firstPersonAnim = "ptpov_explosive_hold_start_frag",
	modelName = $"mdl/weapons/grenades/m20_f_grenade.rmdl",
	weaponName = "mp_weapon_frag_grenade",
	targetName = "explosive_hold_frag_grenade",

             
	panelOpenAnim_Fuse = $"animseq/props/explosivehold_panel_animated/explosivehold_panel_open_frag_fuse.rseq",
	firstPersonAnim_Fuse = "ptpov_explosive_hold_start_frag_fuse"
       
}

const ExplosiveHoldGrenadeData thermiteGrenadeData = {
	panelOpenAnim = $"animseq/props/explosivehold_panel_animated/explosivehold_panel_open_thermite.rseq",
	thirdPersonAnim = "pilot_explosive_hold_start_thermite",
	firstPersonAnim = "ptpov_explosive_hold_start_thermite",
	modelName = $"mdl/weapons/grenades/w_thermite_grenade.rmdl",
	weaponName = "mp_weapon_thermite_grenade",
	targetName = "explosive_hold_thermite_grenade",

             
	panelOpenAnim_Fuse = $"animseq/props/explosivehold_panel_animated/explosivehold_panel_open_thermite_fuse.rseq",
	firstPersonAnim_Fuse = "ptpov_explosive_hold_start_thermite_fuse"
       
}

const ExplosiveHoldGrenadeData arcGrenadeData = {
	panelOpenAnim = $"animseq/props/explosivehold_panel_animated/explosivehold_panel_open_shuriken.rseq",
	thirdPersonAnim = "pilot_explosive_hold_start_shuriken",
	firstPersonAnim = "ptpov_explosive_hold_start_shuriken",
	modelName = EXPLOSIVE_HOLD_ARC_GRENADE_MODEL,
	weaponName = "mp_weapon_grenade_emp",
	targetName = "explosive_hold_arc_grenade",

             
	panelOpenAnim_Fuse = $"animseq/props/explosivehold_panel_animated/explosivehold_panel_open_shuriken_fuse.rseq",
	firstPersonAnim_Fuse = "ptpov_explosive_hold_start_shuriken_fuse"
       
}

struct ExplosiveHoldData
{
	array<entity> panels
	array<entity> panelHousings
	entity rightDoor
	entity leftDoor
	array<entity> ventFXHelpers
	entity holdProxy
}

struct DoorInfo
{
	vector moveDir
	entity door
	entity mover
}

struct
{
	table< EHI, ExplosiveHoldData >	explosiveHoldDataGroups
	array < ExplosiveHoldGrenadeData > grenadeDatas = [ fragGrenadeData, thermiteGrenadeData, arcGrenadeData ]

	#if(false)



#endif //
} file

void function ShExplosiveHold_Init()
{
	AddCallback_EntitiesDidLoad( EntitiesDidLoad )

	PrecacheParticleSystem( EXPLOSIVE_HOLD_EXPLOSION_FX )
	PrecacheParticleSystem( EXPLOSIVE_HOLD_VENT_SMOKE_FX )

	#if(false)


//
#endif
}

void function EntitiesDidLoad()
{
	#if(false)

#endif //

	foreach ( entity explosiveHold in GetEntArrayByScriptName( EXPLOSIVE_HOLD_SCRIPTNAME ) )
	{
		ExplosiveHoldData  				data

		#if(false)
//

#endif //

		foreach ( entity linkEnt in explosiveHold.GetLinkEntArray() )
		{
			string scriptName = linkEnt.GetScriptName()

			if ( scriptName == EXPLOSIVE_HOLD_PANEL_SCRIPTNAME )
			{
				#if(false)






#endif //

				AddCallback_OnUseEntity_ClientServer( linkEnt, ExplosiveHoldDoor_OnUse )
				SetCallback_CanUseEntityCallback( linkEnt, ExplosiveHoldDoor_CanUse )

				#if(CLIENT)
					AddEntityCallback_GetUseEntOverrideText( linkEnt, GetExplosiveHoldUseTextOverride )
				#endif //

				foreach ( entity panelLinkEnt in linkEnt.GetLinkEntArray() )
				{
					if ( panelLinkEnt.GetScriptName() == EXPLOSIVE_HOLD_DOOR_RIGHT )
					{
						data.rightDoor = panelLinkEnt
						#if(false)

#endif
					}
					else if ( panelLinkEnt.GetScriptName() == EXPLOSIVE_HOLD_DOOR_LEFT )
					{
						data.leftDoor = panelLinkEnt
						#if(false)

#endif
					}
					else if ( panelLinkEnt.GetScriptName() == EXPLOSIVE_HOLD_PANEL_HOUSING )
					{
						entity panelHousing = panelLinkEnt
						#if(false)
//



#endif
					}
					else if ( panelLinkEnt.GetScriptName() == EXPLOSIVE_HOLD_VENT_SMOKE_SCRIPTNAME )
					{
						#if(false)



#endif
					}
				}

				data.panels.append( linkEnt )
			}
			#if(false)












//











#endif //
		}

		file.explosiveHoldDataGroups[ ToEHI( explosiveHold ) ] <- data
	}
}

#if(false)























#endif //

bool function ExplosiveHoldDoor_CanUse( entity player, entity panel )
{
	if ( !SURVIVAL_PlayerCanUse_AnimatedInteraction( player, panel ) )
		return false

	vector playerToPanel = panel.GetOrigin() - player.GetOrigin()
	if ( DotProduct( panel.GetUpVector(), playerToPanel ) < -PANEL_USABLE_HEIGHT )
		return false

	return true
}

#if(CLIENT)
string function GetExplosiveHoldUseTextOverride( entity panel )
{
	entity player = GetLocalClientPlayer()
	vector playerToPanel = panel.GetOrigin() - player.GetOrigin()

	if ( DotProduct( panel.GetForwardVector(), playerToPanel ) < 0 )
	{
		if ( !ExplosiveHold_IsOpen( panel ) )
		{
			if ( !ExplosiveHold_PlayerHasGrenadeInInventory( player ) )
				return "#EXPLOSIVEHOLD_HINT_MISSING_GRENADE"
			else
				return "#EXPLOSIVEHOLD_HINT"
		}
		else
			return ""
	}

	return "#EXPLOSIVEHOLD_HINT_INTERIOR"
}
#endif //

void function ExplosiveHoldDoor_OnUse( entity panel, entity player, int useInputFlags )
{
	vector playerToPanel = panel.GetOrigin() - player.GetOrigin()

	if ( DotProduct( panel.GetForwardVector(), playerToPanel ) < 0 )
	{
		if ( !ExplosiveHold_IsOpen( panel ) )
		{
			if ( useInputFlags & USE_INPUT_LONG )
			{
				if ( !ExplosiveHold_PlayerHasGrenadeInInventory( player ) )
				{
					#if(false)

#endif //
					return
				}

				thread ExplosiveHoldDoor_UseThink_Thread( panel, player )
			}
		}
		#if(false)


#endif //
	}
	#if(false)


#endif //
}

void function ExplosiveHoldDoor_UseThink_Thread( entity ent, entity playerUser )
{
	ExtendedUseSettings settings
	settings.loopSound = "survival_titan_linking_loop"
	settings.successSound = "ui_menu_store_purchase_success"
	settings.duration = 0.3

	#if(false)

#endif //

	#if CLIENT || UI 
		settings.icon = $""
		settings.hint = Localize( "#EXPLOSIVEHOLD_ACTIVATE" )
		settings.displayRui = $"ui/extended_use_hint.rpak"
		settings.displayRuiFunc = ExplosiveHoldDoor_DisplayRui
	#endif //

	waitthread ExtendedUse( ent, playerUser, settings )
}

void function ExplosiveHoldDoor_DisplayRui( entity ent, entity player, var rui, ExtendedUseSettings settings )
{
	#if CLIENT || UI 
		RuiSetString( rui, "holdButtonHint", settings.holdHint )
		RuiSetString( rui, "hintText", settings.hint )
		RuiSetGameTime( rui, "startTime", Time() )
		RuiSetGameTime( rui, "endTime", Time() + settings.duration )
	#endif //
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


















//

//



//







//


//




//














//
















































#endif //

bool function ExplosiveHold_PlayerHasGrenadeInInventory( entity player )
{
	foreach ( info in file.grenadeDatas )
	{
		int count = SURVIVAL_CountItemsInInventory( player, info.weaponName )
		if ( count > 0 )
			return true
	}

	return false
}

bool function ExplosiveHold_IsOpen( entity explosiveHoldEnt )
{
	entity explosiveHold = explosiveHoldEnt.GetParent()
	bool isOpen = false

	if ( IsValid( explosiveHold ) )
		isOpen = StatusEffect_GetSeverity( explosiveHold, eStatusEffect.hold_is_open ) > 0.0

	return isOpen
}

#if(CLIENT)
bool function ExplosiveHold_IsPlayerPlantingGrenade( entity player )
{
	entity possiblePanel = player.GetParent()
	if ( IsValid( possiblePanel ) && possiblePanel.HasKey( "script_name" ) && possiblePanel.GetScriptName() == EXPLOSIVE_HOLD_PANEL_SCRIPTNAME )
	{
		return true
	}

	return false
}
#endif

         

