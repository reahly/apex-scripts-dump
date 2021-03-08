global function ShSniperTowers_Init

const string SNIPER_TOWER_PANEL = "sniper_tower_panel"

#if(false)





//




#endif //

struct SniperTowerData
{
	entity panel

	#if(false)






#endif //
}

struct
{
	table< entity, SniperTowerData >		sniperTowerDataMap
} file

void function ShSniperTowers_Init()
{
#if(false)

#endif //

	AddCallback_EntitiesDidLoad( EntitiesDidLoad )
}

#if(false)




#endif //

void function EntitiesDidLoad()
{
	foreach ( entity panel in GetEntArrayByScriptName( SNIPER_TOWER_PANEL ) )
	{
		SniperTowerData data

		data.panel = panel

		#if(false)




#endif //

		AddCallback_OnUseEntity_ClientServer( data.panel, SniperTower_OnUse )
		SetCallback_CanUseEntityCallback( data.panel, SniperTower_CanUse )

		#if(CLIENT)
			AddEntityCallback_GetUseEntOverrideText( data.panel, SniperTowerUseTextOverride )
		#endif //

		#if(false)
































#endif //

		file.sniperTowerDataMap[data.panel] <- data
	}
}

bool function SniperTower_CanUse( entity player, entity panel )
{
	if ( Bleedout_IsBleedingOut( player ) )
		return false

	if ( player.ContextAction_IsActive() )
		return false

	return true
}

#if(CLIENT)
string function SniperTowerUseTextOverride( entity panel )
{
	return "#SNIPERTOWER_HINT"
}
#endif //

void function SniperTower_OnUse( entity panel, entity player, int useInputFlags )
{
	if ( useInputFlags & USE_INPUT_LONG )
		thread SniperTower_UseThink_Thread( panel, player )
}

void function SniperTower_UseThink_Thread( entity ent, entity playerUser )
{
	ExtendedUseSettings settings
	settings.loopSound = "survival_titan_linking_loop"
	settings.successSound = "ui_menu_store_purchase_success"
	settings.duration = 0.3
	settings.successFunc = SniperTower_ExtendedUseSuccess

	#if CLIENT || UI 
		settings.icon = $""
		settings.hint = Localize( "#SNIPERTOWER_ACTIVATE" )
		settings.displayRui = $"ui/extended_use_hint.rpak"
		settings.displayRuiFunc = SniperTower_DisplayRui
		clGlobal.levelEnt.EndSignal( "ClearSwapOnUseThread" )
	#endif //

	ent.EndSignal( "OnDestroy" )
	playerUser.EndSignal( "OnDeath" )

	waitthread ExtendedUse( ent, playerUser, settings )
}

void function SniperTower_DisplayRui( entity ent, entity player, var rui, ExtendedUseSettings settings )
{
	#if CLIENT || UI 
		RuiSetString( rui, "holdButtonHint", settings.holdHint )
		RuiSetString( rui, "hintText", settings.hint )
		RuiSetGameTime( rui, "startTime", Time() )
		RuiSetGameTime( rui, "endTime", Time() + settings.duration )
	#endif //
}

void function SniperTower_ExtendedUseSuccess( entity panel, entity player, ExtendedUseSettings settings )
{
	#if(false)




















#endif //
}