global function Sh_Loot_Vault_Panel_Init

global function SetVaultPanelMinimapObj
global function GetVaultPanelMinimapObj
global function SetVaultPanelOpenMinimapObj
global function GetVaultPanelOpenMinimapObj
global function VaultPanel_GetBestMinimapObjs
global function VaultPanel_GetAllMinimapObjs

global function IsVaultDoor
global function IsValidLootVaultDoorEnt
global function IsVaultPanel
global function GetVaultPanelFromDoor
global function GetVaultPanelForLoot
global function IsVaultPanelLocked

global function VaultPanel_GetTeammateWithKey

global function ForceVaultOpen

#if(false)

#endif

#if(false)

#endif

global const string LOOT_VAULT_PANEL_SCRIPTNAME = "LootVaultPanel"
global const string LOOT_VAULT_DOOR_SCRIPTNAME = "LootVaultDoor"
global const string LOOT_VAULT_DOOR_SCRIPTNAME_RIGHT = "LootVaultDoorRight"

global const string LOOT_VAULT_AUDIO_OPEN = "LootVault_Open"
global const string LOOT_VAULT_AUDIO_ACCESS = "lootVault_Access"
global const string LOOT_VAULT_AUDIO_STATUSBAR = "LootVault_StatusBar"

const asset VAULT_ALARM_FX = $"P_vault_door_alarm"
const string VAULT_ALARM_SOUND = "Loba_Ultimate_Staff_VaultAlarm"

enum ePanelState
{
	LOCKED,
	UNLOCKING,
	UNLOCKED
}

struct LootVaultPanelData
{
	entity panel
	int    panelState = ePanelState.LOCKED

	array<entity> vaultDoors
	#if(false)

#endif //

	entity minimapObj
	entity openMinimapObj
}

struct
{
	array< void functionref( LootVaultPanelData, int ) > vaultPanelUnlockingStateCallbacks
	array< void functionref( LootVaultPanelData, int ) > vaultPanelUnlockedStateCallbacks

	array<LootVaultPanelData> vaultControlPanels
	EntitySet                 vaultDoorSet
	entity                    textPanel
} file

void function Sh_Loot_Vault_Panel_Init()
{
	PrecacheParticleSystem( VAULT_ALARM_FX )

	#if(false)




#endif //

	#if(CLIENT)
		AddCreateCallback( "prop_dynamic", VaultPanelSpawned )
		AddCreateCallback( "prop_door", VaultDoorSpawned )
	#endif //

	LootVaultPanels_AddCallback_OnVaultPanelStateChangedToUnlocking( VaultPanelUnlocking )
	LootVaultPanels_AddCallback_OnVaultPanelStateChangedToUnlocked( VaultPanelUnlocked )
}


void function VaultPanelSpawned( entity panel )
{
	if ( !IsValidLootVaultPanelEnt( panel ) )
		return

	LootVaultPanelData newPanel
	newPanel.panel = panel

	#if(false)



#endif //

	file.vaultControlPanels.append( newPanel )

	SetVaultPanelUsable( panel )
}


void function VaultDoorSpawned( entity door )
{
	if ( !IsValidLootVaultDoorEnt( door ) )
		return

	#if(false)








#endif //

	door.kv.IsVaultDoor = true

	file.vaultDoorSet[door] <- IN_SET
}

const float PANEL_TO_DOOR_RADIUS = 150.0
void function EntitiesDidLoad()
{
	foreach ( panelData in file.vaultControlPanels )
	{
		vector panelPos = panelData.panel.GetOrigin()

		foreach ( entity door, void _ in file.vaultDoorSet )
		{
			vector doorPos = door.GetOrigin()

			if ( Distance( panelPos, doorPos ) <= PANEL_TO_DOOR_RADIUS )
			{
				if ( !panelData.vaultDoors.contains( door ) )
					panelData.vaultDoors.append( door )
			}
		}
	}
}


void function SetVaultPanelState( entity panel, int panelState )
{
	LootVaultPanelData panelData = GetVaultPanelDataFromEntity( panel )

	if ( panelState == panelData.panelState )
		return

	printf( "LootVaultPanelDebug: Changing panel state from %i to %i.", panelData.panelState, panelState )

	panelData.panelState = panelState

	switch ( panelState )
	{
		case ePanelState.LOCKED:
			return

		case ePanelState.UNLOCKING:
		{
			printf( "LootVaultPanelDebug: Changing panel state to UNLOCKING" )
			LootVaultPanelState_Unlocking( panelData, panelState )
		}

		case ePanelState.UNLOCKED:
		{
			printf( "LootVaultPanelDebug: Changing panel state to UNLOCKED" )
			LootVaultPanelState_Unlocked( panelData, panelState )
		}

		default:
			return
	}
}


void function LootVaultPanels_AddCallback_OnVaultPanelStateChangedToUnlocking( void functionref( LootVaultPanelData, int ) callbackFunc )
{
	Assert( !file.vaultPanelUnlockingStateCallbacks.contains( callbackFunc ), "Already added " + string( callbackFunc ) + " with LootVaultPanels_AddCallback_OnVaultPanelStateChanged" )
	file.vaultPanelUnlockingStateCallbacks.append( callbackFunc )
}


void function LootVaultPanelState_Unlocking( LootVaultPanelData panelData, int panelState )
{
	foreach ( func in file.vaultPanelUnlockingStateCallbacks )
		func( panelData, panelData.panelState )
}


void function LootVaultPanels_AddCallback_OnVaultPanelStateChangedToUnlocked( void functionref( LootVaultPanelData, int ) callbackFunc )
{
	Assert( !file.vaultPanelUnlockedStateCallbacks.contains( callbackFunc ), "Already added " + string( callbackFunc ) + " with LootVaultPanels_AddCallback_OnVaultPanelStateChanged" )
	file.vaultPanelUnlockedStateCallbacks.append( callbackFunc )
}


void function LootVaultPanelState_Unlocked( LootVaultPanelData panelData, int panelState )
{
	foreach ( func in file.vaultPanelUnlockedStateCallbacks )
		func( panelData, panelData.panelState )
}

const int VAULTPANEL_MAX_VIEW_ANGLE_TO_AXIS = 60
bool function LootVaultPanel_CanUseFunction( entity playerUser, entity panel )
{
	if ( Bleedout_IsBleedingOut( playerUser ) )
		return false

	if ( playerUser.ContextAction_IsActive() )
		return false

	entity activeWeapon = playerUser.GetActiveWeapon( eActiveInventorySlot.mainHand )
	if ( IsValid( activeWeapon ) && activeWeapon.IsWeaponOffhand() )
		return false

	if ( panel.e.isBusy )
		return false

	if ( GetVaultPanelDataFromEntity( panel ).panelState != ePanelState.LOCKED )
		return false

	return true
}

const float VAULT_PANEL_USE_TIME = 3.0
void function OnVaultPanelUse( entity panel, entity playerUser, int useInputFlags )
{
	if ( !(useInputFlags & USE_INPUT_LONG) )
		return

	if ( !playerUser.GetPlayerNetBool( "hasDataKnife" ) )
		return

	ExtendedUseSettings settings

	settings.duration = VAULT_PANEL_USE_TIME
	settings.useInputFlag = IN_USE_LONG
	settings.successSound = LOOT_VAULT_AUDIO_ACCESS
	settings.successFunc = VaultPanelUseSuccess

	#if(CLIENT)
		settings.loopSound = LOOT_VAULT_AUDIO_STATUSBAR
		settings.displayRuiFunc = DisplayRuiForLootVaultPanel
		settings.displayRui = $"ui/health_use_progress.rpak"
		settings.icon = $"rui/hud/gametype_icons/survival/data_knife"
		settings.hint = "#HINT_VAULT_UNLOCKING"

		//
	#endif //

	#if(false)



#endif //

	thread ExtendedUse( panel, playerUser, settings )
}


void function ForceVaultOpen( entity panel )
{
	LootVaultPanelData panelData = GetVaultPanelDataFromEntity( panel )

	if ( panelData.panelState != ePanelState.UNLOCKING )
		SetVaultPanelState( panel, ePanelState.UNLOCKING )
}


void function VaultPanelUseSuccess( entity panel, entity player, ExtendedUseSettings settings )
{
	LootVaultPanelData panelData = GetVaultPanelDataFromEntity( panel )

	printf( "LootVaultPanelDebug: Panel Use Success" )

	#if(false)






//


#endif

	if ( panelData.panelState != ePanelState.UNLOCKING )
		SetVaultPanelState( panel, ePanelState.UNLOCKING )
}


void function VaultPanelUnlocking( LootVaultPanelData panelData, int panelState )
{
	if ( panelState != ePanelState.UNLOCKING )
		return

	printf( "LootVaultPanelDebug: Panel State: Unlocking" )

	SetVaultPanelUnusable( panelData.panel )

	#if(false)

#endif //

	thread HideVaultPanel( panelData )
}


void function VaultPanelUnlocked( LootVaultPanelData panelData, int panelState )
{
	if ( panelState != ePanelState.UNLOCKED )
	{
		return
	}

	printf( "LootVaultPanelDebug: Panel State: Unlocked" )

	#if(false)
















#endif //
}

#if(false)





































#endif //

void function HideVaultPanel( LootVaultPanelData panelData )
{
	entity panel = panelData.panel

	#if(false)


#endif //

	wait 2.0

	SetVaultPanelState( panelData.panel, ePanelState.UNLOCKED )
}

#if(CLIENT)
string function VaultPanel_TextOverride( entity panel )
{
	entity player = GetLocalViewPlayer()

	int currentUnixTime           = GetUnixTimestamp()
	int ornull keyAccessTimeStamp = GetCurrentPlaylistVarTimestamp( "loot_vault_key_availability_unixtime", 1566864000 )
	if ( keyAccessTimeStamp != null )
	{
		if ( currentUnixTime < expect int( keyAccessTimeStamp ) )
		{
			int timeDelta        = expect int(keyAccessTimeStamp) - currentUnixTime
			TimeParts timeParts  = GetUnixTimeParts( timeDelta )
			string timeString    = GetDaysHoursMinutesSecondsString( timeDelta )
			string displayString = Localize( "#HINT_VAULT_NEED_TIMESTAMP", timeString )
			return displayString
		}
	}

	if ( !player.GetPlayerNetBool( "hasDataKnife" ) )
	{
		return "#HINT_VAULT_NEED"
	}

	return "#HINT_VAULT_USE"
}

void function DisplayRuiForLootVaultPanel( entity ent, entity player, var rui, ExtendedUseSettings settings )
{
	DisplayRuiForLootVaultPanel_Internal( rui, settings.icon, Time(), Time() + settings.duration, settings.hint )
}

void function DisplayRuiForLootVaultPanel_Internal( var rui, asset icon, float startTime, float endTime, string hint )
{
	RuiSetBool( rui, "isVisible", true )
	RuiSetImage( rui, "icon", icon )
	RuiSetGameTime( rui, "startTime", startTime )
	RuiSetGameTime( rui, "endTime", endTime )
	RuiSetString( rui, "hintKeyboardMouse", hint )
	RuiSetString( rui, "hintController", hint )
}
#endif //

LootVaultPanelData function GetVaultPanelDataFromEntity( entity panel )
{
	foreach ( panelData in file.vaultControlPanels )
	{
		if ( panelData.panel == panel )
			return panelData
	}

	Assert( false, "Invalid Loot Vault Panel ( " + string( panel ) + " )." )

	unreachable
}


bool function IsValidLootVaultPanelEnt( entity ent )
{
	if ( ent.GetScriptName() == LOOT_VAULT_PANEL_SCRIPTNAME )
		return true

	return false
}


bool function IsValidLootVaultDoorEnt( entity ent )
{
	if ( !IsDoor( ent ) )
		return false

	string scriptName = ent.GetScriptName()
	if ( scriptName != LOOT_VAULT_DOOR_SCRIPTNAME && scriptName != LOOT_VAULT_DOOR_SCRIPTNAME_RIGHT )
		return false

	return true
}


void function SetVaultPanelUsable( entity panel )
{
	#if(false)


//


#endif //

	SetCallback_CanUseEntityCallback( panel, LootVaultPanel_CanUseFunction )

	#if(CLIENT)
		AddEntityCallback_GetUseEntOverrideText( panel, VaultPanel_TextOverride )
		AddCallback_OnUseEntity_ClientServer( panel, OnVaultPanelUse )
	#endif //
}


void function SetVaultPanelUnusable( entity panel )
{
	#if(false)

#endif //
}


void function SetVaultPanelMinimapObj( entity panel, entity minimapObj )
{
	LootVaultPanelData panelData = GetVaultPanelDataFromEntity( panel )

	panelData.minimapObj = minimapObj
}


void function SetVaultPanelOpenMinimapObj( entity panel, entity minimapObj )
{
	LootVaultPanelData panelData = GetVaultPanelDataFromEntity( panel )

	panelData.openMinimapObj = minimapObj
}


entity function GetVaultPanelMinimapObj( entity panel )
{
	LootVaultPanelData panelData = GetVaultPanelDataFromEntity( panel )

	return panelData.minimapObj
}


entity function GetVaultPanelOpenMinimapObj( entity panel )
{
	LootVaultPanelData panelData = GetVaultPanelDataFromEntity( panel )

	return panelData.openMinimapObj
}


entity function GetBestVaultPanelMinimapObj( entity panel )
{
	LootVaultPanelData panelData = GetVaultPanelDataFromEntity( panel )

	if ( panelData.panelState == ePanelState.UNLOCKED )
		return panelData.openMinimapObj

	return panelData.minimapObj
}

#if(false)







#endif

bool function IsVaultDoor( entity ent )
{
	if ( !IsValid( ent ) )
		return false

	return (ent in file.vaultDoorSet)
}


bool function IsVaultPanel( entity ent )
{
	foreach ( panelData in file.vaultControlPanels )
	{
		if ( panelData.panel == ent )
			return true
	}

	return false
}


entity function GetVaultPanelFromDoor( entity door )
{
	foreach ( panelData in file.vaultControlPanels )
	{
		if ( !IsValid( panelData.panel ) )
			return null

		#if(false)





#endif

		#if(CLIENT)
			vector panelPos = panelData.panel.GetOrigin()
			vector doorPos  = door.GetOrigin()

			if ( Distance( panelPos, doorPos ) <= PANEL_TO_DOOR_RADIUS )
				return panelData.panel
		#endif
	}

	return null
}


//
//
const vector VAULT_ROOM_MINS = <-350.210938, 9.0, -124.107796>
const vector VAULT_ROOM_MAXS = <350.210938, 390.891083 + 317.891083, 124.107796>
entity function GetVaultPanelForLoot( entity lootEnt )
{
	foreach ( panelData in file.vaultControlPanels )
	{
		if ( !IsValid( panelData.panel ) )
			continue

		vector localPos = WorldPosToLocalPos( lootEnt.GetOrigin(), panelData.panel )
		if ( localPos.x > VAULT_ROOM_MINS.x && localPos.x < VAULT_ROOM_MAXS.x
		&& localPos.y > VAULT_ROOM_MINS.y && localPos.y < VAULT_ROOM_MAXS.y
		&& localPos.z > VAULT_ROOM_MINS.z && localPos.z < VAULT_ROOM_MAXS.z )
			return panelData.panel
	}

	return null
}


bool function IsVaultPanelLocked( entity vaultPanel )
{
	return GradeFlagsHas( vaultPanel, eGradeFlags.IS_LOCKED )
}


entity function VaultPanel_GetTeammateWithKey( int teamIdx )
{
	array< entity > squad = GetPlayerArrayOfTeam( teamIdx )

	foreach ( player in squad )
	{
		if ( player.GetPlayerNetBool( "hasDataKnife" ) )
			return player
	}

	return null
}


array< entity > function VaultPanel_GetBestMinimapObjs()
{
	array<entity> mapObjs
	foreach ( data in file.vaultControlPanels )
	{
		entity minimapObj
		if ( data.panelState == ePanelState.LOCKED )
			minimapObj = data.minimapObj
		else
			minimapObj = data.openMinimapObj

		if ( IsValid( minimapObj ) )
			mapObjs.append( minimapObj )
	}

	return mapObjs
}


array< entity > function VaultPanel_GetAllMinimapObjs()
{
	array<entity> mapObjs
	foreach ( data in file.vaultControlPanels )
	{
		mapObjs.append( data.minimapObj )
		mapObjs.append( data.openMinimapObj )
	}

	return mapObjs
}

#if(false)


//


























//































#endif //


#if(false)
















#endif


