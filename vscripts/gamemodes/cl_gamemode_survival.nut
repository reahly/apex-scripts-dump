global function ClGamemodeSurvival_Init
global function CLSurvival_RegisterNetworkFunctions

global function AddCallback_PlayerPressedInventory

global function ServerCallback_AnnounceCircleClosing
global function ServerCallback_SUR_PingMinimap
global function ServerCallback_SurvivalHint
global function ServerCallback_PlayerBootsOnGround
global function ServerCallback_ClearHints
global function ServerCallback_MatchEndAnnouncement
global function ServerCallback_AddWinningSquadData
global function ServerCallback_PromptSayThanks
global function ServerCallback_PromptSayThanksRevive
global function ServerCallback_PromptTaunt
global function ServerCallback_PromptSayGetOnTheDropship
                            
global function ServerCallback_PromptMarkMyLastDeathbox
      
global function ServerCallback_RefreshInventoryAndWeaponInfo
global function ServerCallback_RefreshDeathBoxHighlight

global function ServerCallback_AnnounceDevRespawn

                     
global function ServerCallback_AutoReloadComplete //
      

global function CreateQuickchatFunction

global function AddCallback_OnUpdateShowButtonHints
global function AddCallback_OnVictoryCharacterModelSpawned

global function OnHealthPickupTypeChanged

global function UpdateFallbackMatchmaking
global function UpdateInventoryCounter

global function OverrideHUDHealthFractions
global function AddMinimapLabel

global function OpenSurvivalMenu

global function SURVIVAL_AddMinimapLevelLabel
global function SURVIVAL_PopulatePlayerInfoRui
global function SURVIVAL_SetGameStateAssetOverrideCallback

global function MarkDpadAsBlocked

global function ScorebarInitTracking
global function FullMap_CommonAdd
global function FullMap_CommonTrackEntOrigin
global function FullMap_PingLocation
global function FullMap_PingEntity
global function FullMap_SetDeathFieldRadius
global function FullMap_UpdateTopologies
global function FullMap_UpdateAimPos
global function FullMap_AddEnemyLocation
global function FullMap_PlayCryptoPulseSequence

global function PlayerHudSetWeaponInspect
global function UpdateDpadHud

global function PROTO_ServerCallback_Sur_HoldForUltimate

global function PROTO_OpenInventoryOrSpecifiedMenu

global function UICallback_UpdateCharacterDetailsPanel
global function UICallback_OpenCharacterSelectNewMenu
global function UICallback_QueryPlayerCanBeRespawned
global function UICallback_DieAndChangeCharacters

global function HealthkitWheelToggleEnabled
global function HealthkitWheelUseOnRelease
global function HealthkitUseOnHold

global function OrdnanceWheelToggleEnabled
global function OrdnanceWheelUseOnRelease
global function OrdnanceUseOnHold

global function GetSquadSummaryData
global function GetWinnerSquadSummaryData
global function SetSquadDataToLocalTeam
global function SetVictorySequenceEffectPackage
global function SetVictorySequenceLocation
global function SetVictorySequenceSunSkyIntensity
global function IsShowingVictorySequence
global function GetVictoryScreenCharacterModelForEHI
global function ServerCallback_NessyMessage
global function ShowChampionVictoryScreen

global function CanReportPlayer

global function UIToClient_ToggleMute
global function SetSquadMuteState
global function ToggleSquadMute
global function IsSquadMuted
global function AddCallback_OnSquadMuteChanged
global function AddCallback_ShouldRunCharacterSelection

global function OverwriteWithCustomPlayerInfoTreatment
global function SetCustomPlayerInfoCharacterIcon
global function SetCustomPlayerInfoTreatment
global function SetCustomPlayerInfoColor
global function SetCustomPlayerInfoShadowFormState
global function GetPlayerInfoColor
global function ClearCustomPlayerInfoColor

global function SetNextCircleDisplayCustomStarting
global function SetNextCircleDisplayCustomClosing
global function SetNextCircleDisplayCustomClear
global function SetGamestateCountdown
global function SetGamestateCountdownClear

global function SetPreVictoryScreenCallback
global function SetChampionScreenRuiAsset
global function SetChampionScreenSound
global function SetChampionScreenRuiAssetExtraFunc

global function InitSurvivalHealthBar

global function GetCompassRui

                      
global function EvolvingArmor_SetEvolutionRuiAnimTime
      

                          
global function ShowTeamNameInHud
global function HideTeamNameInHud
      

#if(DEV)
global function Dev_ShowVictorySequence
global function Dev_AdjustVictorySequence
global function Dev_SpoofMatchData
#endif

global function CircleAnnouncementsEnable
global function CircleBannerAnnouncementsEnable
global function Survival_SetVictorySoundPackageFunction

global function ClientCodeCallback_OnTryCycleOrdnance

global struct NextCircleDisplayCustomData
{
	float  circleStartTime
	float  circleCloseTime
	float  countdownGoalTime
	int    roundNumber
	string roundString

	vector deathFieldOrigin
	vector safeZoneOrigin

	float deathfieldDistance
	float deathfieldStartRadius
	float deathfieldEndRadius

	asset  altIcon = $""
	string altIconText
	vector altColor = <1, 1, 1>
}

global struct VictorySoundPackage
{
	string youAreChampPlural
	string youAreChampSingular
	string theyAreChampPlural
	string theyAreChampSingular
}

struct VictoryCameraPackage
{
	vector camera_offset_start
	vector camera_offset_end
	vector camera_focus_offset
	float  camera_fov
}

global struct VictoryEffectPackage
{
	vector position
	vector angles
	asset effect = $""
}

global const FULLMAP_OBJECT_RUI = $"ui/in_world_minimap_object.rpak"
const FULLMAP_ZOOM_SPEED_MOUSE = 0.5
const FULLMAP_ZOOM_SPEED_CONTROLLER = 0.1

const FULLMAP_SELECT_RANGE = 750

const float CROUCH_SPAM_DETECT_TIMEOUT = 1.25

const string SOUND_UI_TEAMMATE_KILLED = "UI_DeathAlert_Friendly"

const string CIRCLE_CLOSING_IN_SOUND = "UI_InGame_RingMoveWarning" //

const float TITAN_DESYNC_TIME = 1.0
const float OVERVIEW_MAP_SIZE = 4096 //

//
const int HEALTH_STATE_DEFAULT = 0
const int HEALTH_STATE_BLEED = 1
const int HEALTH_STATE_REVIVE = 2

const string SFX_DROPSELECTION_ME = "UI_Survival_DropSelection_Player"
const string SFX_DROPSELECTION_TEAM = "UI_Survival_DropSelection_TeamMember"

global const vector SAFE_ZONE_COLOR = <1, 1, 1>
global const float SAFE_ZONE_ALPHA = 0.05

global const string HEALTHKIT_BIND_COMMAND = "+scriptCommand2"
global const string ORDNANCEMENU_BIND_COMMAND = "+strafe"
                   
global const string GADGETSLOT_BIND_COMMAND = "+scriptCommand6"
      

struct MinimapLabelStruct
{
	string name
	vector pos
	float  width = 200
	float  scale = 1.0
}

global struct SquadSummaryPlayerData
{
	int eHandle
	int kills
	int assists
	int knockdowns
	int damageDealt
	int survivalTime
	int revivesGiven
	int respawnsGiven
	entity victoryScreenCharacterModel
}

global struct SquadSummaryData
{
	array<SquadSummaryPlayerData> playerData
	int                           squadPlacement = -1
}

struct
{
	var titanLinkProgressRui
	var dpadMenuRui
	var pilotRui

	var fallbackMMRui

	var compassRui

	array<var>         minimapTopos
	table<entity, var> minimapTopoClientEnt

	//
	var   mapAimRui
	var   mapTopo
	var   mapTopoBG
	float mapCornerX
	float mapCornerY
	float mapScale
	float threatMaxDist

	bool cameFromWaitingForPlayersState = false
	bool knowsHowToUseAmmo = false
	bool superHintAllowed = true
	bool needsMapHint = true

	bool                        toggleMuteKeysEnabled = false
	bool                        isSquadMuted = false
	array< void functionref() > squadMuteChangeCallbacks

	entity lastPrimaryWeapon

	bool toposInitialized = false

	entity planeStart
	entity planeEnd

	bool mapContextPushed = false

	bool autoLoadoutDone = false

	bool haveEverSetOwnDropPoint = false

	string playerState

	array<MinimapLabelStruct> 	minimapLabels
	table<EHI, var> 			fullmapPlayerItems
	int							playerTagMode = OBS_PLAYERTAG_MODE_ALL
	bool						updatePlayerTags = true
	entity 						highlightedPlayer

	string                  rodeoOfferingHintShown = ""
	ConsumableInventoryItem rodeoOfferedItem

	bool  wantsGroundItemUpdate = false
	float nextGroundItemUpdate = 0

	bool requestReviveButtonRegistered = false

	table<entity, entity> playerWaypointData

	var inWorldMinimapDeathFieldRui

	vector fullmapAimPos = <0.5, 0.5, 0>
	vector fullmapZoomPos = <0.5, 0.5, 0>
	float  fullmapZoomFactor = 1.0
	float  moveInputPrevTime = 0.0

	table<string, string> toggleAttachments

	vector victorySequencePosition = < 0, 0, 10000 >
	vector victorySequenceAngles = < 0, 0, 0 >
	float  victorySunIntensity = 1.0
	float  victorySkyIntensity = 1.0
	var    victoryRui = null
	bool   IsShowingVictorySequence = false
	VictoryEffectPackage victoryEffectData

	SquadSummaryData squadSummaryData
	SquadSummaryData winnerSquadSummaryData

	var inventoryCountRui

	bool shouldShowButtonHintsLocal

	float nextAllowToggleFireRateTime = 0.0

	bool circleAnnouncementsEnabled = true

	bool circleBannerAnnouncementsEnabled = true

	bool functionref() shouldRunCharacterSelectionCallback
	void functionref() gameStateOverrideCallback
	VictorySoundPackage functionref() victorySoundPackageCallback

	table<entity, asset>  customPlayerInfoTreatment
	table<entity, vector> customCharacterColor
	table<entity, asset>  customCharacterIcon

	asset customChampionScreenRuiAsset
	string customChampionScreenSound
	void functionref( bool) onPreVictoryScreenCallback

	int   crouchSpamCount
	float lastPressedCrouchTime

	array<bool functionref(entity) > tryAccessInventoryCallbacks

	string clubName = ""
} file

void function ClGamemodeSurvival_Init()
{
	Sh_ArenaDeathField_Init()
	ClSurvivalCommentary_Init()
	ObjectiveResourceSystem_Init()
	BleedoutClient_Init()
	ClSurvivalShip_Init()
	SurvivalFreefall_Init()
	ClUnitFrames_Init()
	Cl_Survival_InventoryInit()
	Cl_Survival_LootInit()
	Cl_SquadDisplay_Init()

	Bleedout_SetFirstAidStrings( "#SURVIVAL_APPLYING_FIRST_AID", "#SURVIVAL_RECIEVING_FIRST_AID" )

	RegisterSignal( "Sur_EndTrackOffhandWeaponSlot0" )
	RegisterSignal( "Sur_EndTrackAmmo" )
	RegisterSignal( "Sur_EndTrackPrimary" )
	RegisterSignal( "StopShowingRodeoOfferingPrompt" )
	RegisterSignal( "ReloadPressed" )
	RegisterSignal( "ClearSwapOnUseThread" )
	RegisterSignal( "DroppodLanded" )
	RegisterSignal( "SquadEliminated" )

	FlagInit( "SquadEliminated" )

	ClGameState_RegisterGameStateAsset( $"ui/gamestate_info_survival.rpak" )
	if ( file.gameStateOverrideCallback != null )
	{
		file.gameStateOverrideCallback()
	}

	AddCallback_OnClientScriptInit( OverrideMinimapPackages )

	SetGameModeScoreBarUpdateRulesWithFlags( GameModeScoreBarRules, sbflag.SKIP_STANDARD_UPDATE )
	AddCallback_OnPlayerMatchStateChanged( OnPlayerMatchStateChanged )

	AddCallback_OnClientScriptInit( Cl_Survival_AddClient )

	AddCreateCallback( "npc_titan", OnTrackTitanTeam )
	AddCreateCallback( "prop_survival", OnPropCreated )
	AddCreateCallback( "prop_dynamic", OnPropDynamicCreated )

	AddCreateCallback( "player", OnPlayerCreated )
	AddDestroyCallback( "player", OnPlayerDestroyed )
	AddOnDeathCallback( "player", OnPlayerKilled )

	AddCreatePilotCockpitCallback( OnPilotCockpitCreated )
	AddCallback_PlayerClassChanged( Survival_OnPlayerClassChanged )

	RegisterConCommandTriggeredCallback( "-offhand4", AllowSuperHint )
	RegisterConCommandTriggeredCallback( "+scriptCommand3", ToggleFireSelect )

	RegisterConCommandTriggeredCallback( "+reload", ReloadPressed )
	RegisterConCommandTriggeredCallback( "+use", UsePressed )
	RegisterConCommandTriggeredCallback( "+useAndReload", ReloadPressed )

	RegisterConCommandTriggeredCallback( "+duck", CrouchPressed )
	RegisterConCommandTriggeredCallback( "+toggle_duck", CrouchPressed )

	RegisterConCommandTriggeredCallback( HEALTHKIT_BIND_COMMAND, HealthkitButton_Down )
	RegisterConCommandTriggeredCallback( "-" + HEALTHKIT_BIND_COMMAND.slice( 1 ), HealthkitButton_Up )

	RegisterConCommandTriggeredCallback( ORDNANCEMENU_BIND_COMMAND, OrdnanceMenu_Down )
	RegisterConCommandTriggeredCallback( "-" + ORDNANCEMENU_BIND_COMMAND.slice( 1 ), OrdnanceMenu_Up )

                    
	RegisterConCommandTriggeredCallback( GADGETSLOT_BIND_COMMAND, GadgetSlot_Down )
       
	asset mapImage = Minimap_GetAssetForKey( "minimap" )
	file.mapCornerX = Minimap_GetFloatForKey( "pos_x" )
	file.mapCornerY = Minimap_GetFloatForKey( "pos_y" )
	file.mapScale = max( Minimap_GetFloatForKey( "scale" ), 1.0 )
	float displayDist    = Minimap_GetFloatForKey( "displayDist" )
	float threatDistNear = Minimap_GetFloatForKey( "threatNearDist" )
	float threatDistFar  = Minimap_GetFloatForKey( "threatFarDist" )
	file.threatMaxDist = Minimap_GetFloatForKey( "threatMaxDist" )

	file.inventoryCountRui = CreateFullscreenRui( $"ui/inventory_count_meter.rpak", 0 )

	AddScoreboardShowCallback( Sur_OnScoreboardShow )
	AddScoreboardHideCallback( Sur_OnScoreboardHide )

	AddCallback_MinimapEntShouldCreateCheck( DontCreateRuisForEnemies )
	AddCallback_MinimapEntSpawned( AddInWorldMinimapObject )

	AddCallback_LocalClientPlayerSpawned( OnLocalPlayerSpawned )

	AddCallback_EntitiesDidLoad( Survival_EntitiesDidLoad )

	AddCallback_OnBleedoutStarted( Sur_OnBleedoutStarted )
	AddCallback_OnBleedoutEnded( Sur_OnBleedoutEnded )

	AddFirstPersonSpectateStartedCallback( OnFirstPersonSpectateStarted )
	AddOnSpectatorTargetChangedCallback( OnSpectatorTargetChanged )
	AddOnSpectatorTagModeChangedCallback( OnSpectatorTagModeChanged )

	AddCallback_OnViewPlayerChanged( OnViewPlayerChanged )
	AddCallback_OnPlayerConsumableInventoryChanged( UpdateDpadHud )

	AddCallback_GameStateEnter( eGameState.WaitingForPlayers, Survival_WaitForPlayers )
	AddCallback_GameStateEnter( eGameState.WaitingForPlayers, EnableToggleMuteKeys )
	AddCallback_GameStateEnter( eGameState.PickLoadout, Survival_RunCharacterSelection )
	AddCallback_GameStateEnter( eGameState.PickLoadout, DisableToggleMuteKeys )
	AddCallback_GameStateEnter( eGameState.Prematch, OnGamestatePrematch )
	AddCallback_GameStateEnter( eGameState.Playing, DisableToggleMuteKeys )
	AddCallback_GameStateEnter( eGameState.Playing, StreamHintPlayers )
	AddCallback_GameStateEnter( eGameState.WaitingForCustomStart, SetDpadMenuVisible )
	AddCallback_GameStateEnter( eGameState.Playing, SetDpadMenuVisible )
	AddCallback_GameStateEnter( eGameState.Playing, OnGamestatePlaying )
	AddCallback_GameStateEnter( eGameState.WinnerDetermined, Survival_ClearHints )
	AddCallback_GameStateEnter( eGameState.Epilogue, OnGamestateEpilogue )

	if ( SquadMuteIntroEnabled() )
		AddCallback_OnSquadMuteChanged( OnSquadMuteChanged )

	RegisterNetVarIntChangeCallback( "gameState", OnGameStateChanged )

	if ( GetCurrentPlaylistVarBool( "inventory_counter_enabled", true ) )
		AddCallback_LocalPlayerPickedUpLoot( TryUpdateInventoryCounter )

	Obituary_SetEnabled( GetCurrentPlaylistVarBool( "enable_obituary", true ) )

	foreach ( equipSlot, data in EquipmentSlot_GetAllEquipmentSlots() )
	{
		if ( data.trackingNetInt != "" )
		{
			AddCallback_OnEquipSlotTrackingIntChanged( equipSlot, EquipmentChanged )
		}
	}

	AddCallback_OnEquipSlotTrackingIntChanged( "backpack", BackpackChanged )

	if ( IsSoloMode() )
		SetCommsDialogueEnabled( false ) //

	AddCallback_OnSettingsUpdated( OnSettingsUpdated )
}


void function SURVIVAL_SetGameStateAssetOverrideCallback( void functionref() func )
{
	file.gameStateOverrideCallback = func
}


void function Survival_EntitiesDidLoad()
{
	InitInWorldScreens()

	foreach ( data in file.minimapLabels )
	{
		AddMinimapLabel( data.name, data.pos.x, data.pos.y, data.width, data.scale )
	}

	file.toposInitialized = true
}


void function InitInWorldScreens()
{
	array<entity> screens = GetEntArrayByScriptName( "inworld_minimap" )
	array<var> topos

	float size = 800 * 2

	foreach ( screen in screens )
	{
		topos.append( AddInWorldMinimapTopo( screen, size, size ) )
	}

	asset mapImage = Minimap_GetAssetForKey( "minimap" )

	file.mapCornerX = Minimap_GetFloatForKey( "pos_x" )
	file.mapCornerY = Minimap_GetFloatForKey( "pos_y" )
	float displayDist    = Minimap_GetFloatForKey( "displayDist" )
	float threatDistNear = Minimap_GetFloatForKey( "threatNearDist" )
	float threatDistFar  = Minimap_GetFloatForKey( "threatFarDist" )
	file.mapScale = max( Minimap_GetFloatForKey( "scale" ), 1.0 )

	file.threatMaxDist = Minimap_GetFloatForKey( "threatMaxDist" )

	foreach ( screen in topos )
	{
		var rui2 = RuiCreate( $"ui/basic_image.rpak", screen, RUI_DRAW_WORLD, FULLMAP_Z_BASE )
		RuiSetFloat3( rui2, "basicImageColor", <0, 0, 0> )

		var rui = RuiCreate( $"ui/in_world_minimap_base.rpak", screen, RUI_DRAW_WORLD, FULLMAP_Z_BASE )
		RuiSetFloat3( rui, "mapCorner", <file.mapCornerX, file.mapCornerY, 0> )
		RuiSetFloat( rui, "mapScale", file.mapScale )
		RuiSetImage( rui, "mapImage", mapImage )
		RuiSetImage( rui, "mapBgTileImage", GetMinimapBackgroundTileImage() )
		entity ent = CreateClientSidePropDynamic( <0, 0, 0>, <0, 0, 0>, $"mdl/dev/empty_model.rmdl" )
		file.minimapTopoClientEnt[ ent ] <- screen
		thread CleanupRuiOnTopoDestroy( rui, screen )
		thread CleanupRuiOnTopoDestroy( rui2, screen )
	}

	file.minimapTopos.extend( topos )

	if ( file.minimapTopos.len() > 1 )
		file.needsMapHint = false
}


bool function SprintFXAreEnabled()
{
	if ( Freelance_IsHubLevel() )
		return false

	bool enabled = GetCurrentPlaylistVarBool( "fp_sprint_fx", false )
	return enabled
}


void function OnPlayerCreated( entity player )
{
	if ( SprintFXAreEnabled() )
	{
		if ( player == GetLocalViewPlayer() )
			thread TrackSprint( player )
	}

	if ( (player.GetTeam() == GetLocalClientPlayer().GetTeam()) && (SquadMuteIntroEnabled() || SquadMuteLegendSelectEnabled()) )
	{
		//
		if ( IsSquadMuted() )
			SetSquadMuteState( IsSquadMuted() )
	}
}


void function OnPlayerDestroyed( entity player )
{

}


void function TrackSprint( entity player )
{
	player.EndSignal( "OnDestroy" )

	table<string, bool> e
	e[ "sprintingVisuals" ] <- false
	int fxHandle

	while ( 1 )
	{
		bool isSprint     = e[ "sprintingVisuals" ]
		bool shouldSprint = ShouldShowSprintVisuals( player )

		if ( isSprint && !shouldSprint )
		{
			e[ "sprintingVisuals" ] = false
			player.SetFOVScale( 1, 2 )
			EffectStop( fxHandle, false, true )
			fxHandle = -1
		}
		else if ( !isSprint && shouldSprint )
		{
			e[ "sprintingVisuals" ] = true
			//
			if ( IsValid( player.GetCockpit() ) )
				fxHandle = StartParticleEffectOnEntity( player.GetCockpit(), GetParticleSystemIndex( SPRINT_FP ), FX_PATTACH_ABSORIGIN_FOLLOW, -1 )
		}

		//
		if ( shouldSprint )
			player.SetFOVScale( 1.15, 2 )

		WaitFrame()
	}
}


bool function ShouldShowSprintVisuals( entity player )
{
	if ( player.GetParent() != null )
		return false

	if ( player.GetPhysics() == MOVETYPE_NOCLIP )
		return false

	entity activeWeapon = player.GetActiveWeapon( eActiveInventorySlot.mainHand )
	if ( IsValid( activeWeapon ) && activeWeapon.GetWeaponSettingFloat( eWeaponVar.move_speed_modifier ) > 1 && player.IsSprinting() )
		return true

	float max = PLAYER_STANDING_SPRINT_SPEED //

	vector fwd = player.GetViewVector()
	float dot  = DotProduct( fwd, player.GetVelocity() )
	float dot2 = DotProduct( fwd, Normalize( player.GetVelocity() ) )

	return (dot > max * 1.01) && (dot2 > 0.85)
}


var function AddInWorldMinimapTopo( entity ent, float width, float height )
{
	vector ang   = ent.GetAngles()
	vector right = ((AnglesToRight( ang ) * -1) * width * 0.5)
	vector down  = ((AnglesToUp( ang ) * -1) * height * 0.5)

	vector org = ent.GetOrigin()

	org = ent.GetOrigin() - right * 0.5 - down * 0.5

	var topo = RuiTopology_CreatePlane( org, right, down, true )
	return topo
}


void function Cl_Survival_AddClient( entity player )
{
	SetBigMapZoomScale( 1.0 )
	CreateFullmap()
	HideMapRui()

	asset mapImage       = Minimap_GetAssetForKey( "minimap" )
	float displayDist    = Minimap_GetFloatForKey( "displayDist" )
	float threatDistNear = Minimap_GetFloatForKey( "threatNearDist" )
	float threatDistFar  = Minimap_GetFloatForKey( "threatFarDist" )

	file.mapCornerX = Minimap_GetFloatForKey( "pos_x" )
	file.mapCornerY = Minimap_GetFloatForKey( "pos_y" )
	file.mapScale = max( Minimap_GetFloatForKey( "scale" ), 1.0 )

	var rui = RuiCreate( $"ui/in_world_minimap_base.rpak", file.mapTopo, FULLMAP_RUI_DRAW_LAYER, FULLMAP_Z_BASE )
	RuiSetFloat3( rui, "mapCorner", <file.mapCornerX, file.mapCornerY, 0> )
	RuiSetFloat( rui, "mapScale", file.mapScale )
	RuiTrackFloat2( rui, "zoomPos", null, RUI_TRACK_BIG_MAP_ZOOM_ANCHOR )
	RuiTrackFloat( rui, "zoomFactor", null, RUI_TRACK_BIG_MAP_ZOOM_SCALE )
	RuiSetImage( rui, "mapImage", mapImage )
	RuiSetImage( rui, "mapBgTileImage", GetMinimapBackgroundTileImage() )
	RuiSetBool( rui, "hudVersion", true )

	Fullmap_AddRui( rui )
	Fullmap_AddTintableRui( rui )

	file.dpadMenuRui = CreateCockpitPostFXRui( SURVIVAL_HUD_DPAD_RUI, HUD_Z_BASE )
	RuiTrackFloat( file.dpadMenuRui, "reviveEndTime", player, RUI_TRACK_SCRIPT_NETWORK_VAR, GetNetworkedVariableIndex( "reviveEndTime" ) )

                               
                               
   
                                                                                                                                     
                                                                                        
   
       

	getroottable().testRui <- file.dpadMenuRui
	SetDpadMenuVisible()

	#if(DEV)
		if ( GetBugReproNum() == 1972 )
			file.pilotRui = CreatePermanentCockpitPostFXRui( $"ui/survival_player_hud_editor_version.rpak", HUD_Z_BASE )
		else
			file.pilotRui = CreatePermanentCockpitPostFXRui( SURVIVAL_HUD_PLAYER, HUD_Z_BASE )
	#else
		file.pilotRui = CreatePermanentCockpitPostFXRui( SURVIVAL_HUD_PLAYER, HUD_Z_BASE )
	#endif

	RuiSetBool( file.pilotRui, "isVisible", GetHudDefaultVisibility() )
	RuiSetBool( file.pilotRui, "useShields", true )

                     
                                                                      
   
                                                       
                                                                                                                                                 
   
       

	if ( GetCurrentPlaylistVarBool( "compass_flat_enabled", true ) )
	{
		file.compassRui = CreatePermanentCockpitRui( $"ui/compass_flat.rpak", HUD_Z_BASE )
		RuiTrackFloat3( file.compassRui, "playerAngles", player, RUI_TRACK_CAMANGLES_FOLLOW )
		RuiTrackInt( file.compassRui, "gameState", null, RUI_TRACK_SCRIPT_NETWORK_VAR_GLOBAL_INT, GetNetworkedVariableIndex( "gameState" ) )
	}

	#if(PC_PROG)
		if ( GetCurrentPlaylistVarBool( "pc_force_pushtotalk", false ) )
			player.ClientCommand( "+pushtotalk" )
	#endif //

	SetConVarFloat( "dof_variable_blur", 0.0 )

	RuiTrackInt( file.pilotRui, "squadID", player, RUI_TRACK_SQUADID )

	WaitingForPlayersOverlay_Setup( player )
}


void function InitSurvivalHealthBar()
{
	Assert( IsNewThread(), "Must be threaded off" )

	entity player = GetLocalViewPlayer()
	SURVIVAL_PopulatePlayerInfoRui( player, file.pilotRui )
}


void function SURVIVAL_PopulatePlayerInfoRui( entity player, var rui )
{
	Assert( IsValid( player ) )
	EndSignal( player, "OnDestroy" )

	#if(true)
		RuiTrackInt( rui, "teamMemberIndex", player, RUI_TRACK_PLAYER_TEAM_MEMBER_INDEX )
	#endif
	RuiTrackString( rui, "name", player, RUI_TRACK_PLAYER_NAME_STRING )
	RuiTrackInt( rui, "micStatus", player, RUI_TRACK_MIC_STATUS )

	ItemFlavor character = LoadoutSlot_WaitForItemFlavor( ToEHI( player ), Loadout_Character() )
	asset classIcon      = CharacterClass_GetGalleryPortrait( character )

	RuiSetImage( rui, "playerIcon", classIcon )
	RuiSetInt( rui, "playerBaseHealth", GetPlayerSettingBaseHealth( player ) )
	RuiSetInt( rui, "playerBaseShield", GetPlayerSettingBaseShield( player ) )

	RuiSetGameTime( rui, "trackedPlayerChangeTime", Time() )
	RuiTrackFloat( rui, "playerHealthFrac", player, RUI_TRACK_HEALTH )
	RuiTrackFloat( rui, "playerTargetHealthFrac", player, RUI_TRACK_HEAL_TARGET )
	RuiTrackFloat( rui, "playerShieldFrac", player, RUI_TRACK_SHIELD_FRACTION )
                
                                                                                                                             
       
	RuiTrackFloat( rui, "cameraViewFrac", player, RUI_TRACK_STATUS_EFFECT_SEVERITY, eStatusEffect.camera_view ) //
	vector shieldFrac = < SURVIVAL_GetArmorShieldCapacity( 0 ) / 100.0,
	SURVIVAL_GetArmorShieldCapacity( 1 ) / 100.0,
	SURVIVAL_GetArmorShieldCapacity( 2 ) / 100.0 >

	RuiSetColorAlpha( rui, "shieldFrac", shieldFrac, float( SURVIVAL_GetArmorShieldCapacity( 3 ) ) )
	RuiTrackFloat( rui, "playerTargetShieldFrac", player, RUI_TRACK_STATUS_EFFECT_SEVERITY, eStatusEffect.target_shields )
	RuiTrackFloat( rui, "playerTargetHealthFrac", player, RUI_TRACK_STATUS_EFFECT_SEVERITY, eStatusEffect.target_health )
	RuiTrackFloat( rui, "playerTargetHealthFracTemp", player, RUI_TRACK_HEAL_TARGET )

		string platformString = ""
		if ( GetLocalClientPlayer() != GetLocalViewPlayer() && CrossplayUserOptIn() )
			platformString = PlatformIDToIconString( GetHardwareFromName( GetLocalViewPlayer().GetHardware() ) )
		RuiSetString( rui, "platformString", platformString )

	bool isSwitchHardware = player.GetHardware() == "HARDWARE_SWITCH"
	if ( isSwitchHardware )
		RuiSetFloat( rui, "nxPlatformTextOffsetX", -1.5 )

	OverwriteWithCustomPlayerInfoTreatment( player, rui )
}


void function OverwriteWithCustomPlayerInfoTreatment( entity player, var rui )
{
	if ( player in file.customCharacterIcon )
		RuiSetImage( rui, "playerIcon", file.customCharacterIcon[player] )

	if ( player in file.customPlayerInfoTreatment )
	{
		RuiSetImage( rui, "customTreatment", file.customPlayerInfoTreatment[player] )
	}
	else
	{
		RuiSetImage( rui, "customTreatment", $"" )
	}

	if ( player in file.customCharacterColor )
	{
		RuiSetColorAlpha( rui, "customCharacterColor", SrgbToLinear( GetPlayerInfoColor( player ) / 255.0 ), 1.0 )
		RuiSetBool( rui, "useCustomCharacterColor", true )
	}
	else
	{
		RuiSetBool( rui, "useCustomCharacterColor", false )
	}
}


void function SetCustomPlayerInfoCharacterIcon( entity player, asset customIcon )
{
	if ( !(player in file.customCharacterIcon) )
		file.customCharacterIcon[player] <- customIcon
	file.customCharacterIcon[player] = customIcon
	if ( file.pilotRui != null )
		RuiSetImage( file.pilotRui, "playerIcon", file.customCharacterIcon[player] )
}


void function SetCustomPlayerInfoTreatment( entity player, asset treatmentImage )
{
	if ( !(player in file.customPlayerInfoTreatment) )
		file.customPlayerInfoTreatment[player] <- treatmentImage
	file.customPlayerInfoTreatment[player] = treatmentImage
	if ( file.pilotRui != null )
		RuiSetImage( file.pilotRui, "customTreatment", file.customPlayerInfoTreatment[player] )
}


void function SetCustomPlayerInfoShadowFormState( entity player, bool state )
{
	if ( file.pilotRui != null )
		RuiSetBool( file.pilotRui, "useShadowFormFrame", state )
}


void function SetCustomPlayerInfoColor( entity player, vector characterColor )
{
	if ( !(player in file.customCharacterColor) )
		file.customCharacterColor[player] <- characterColor
	file.customCharacterColor[player] = characterColor
	if ( file.pilotRui != null )
	{
		RuiSetColorAlpha( file.pilotRui, "customCharacterColor", SrgbToLinear( file.customCharacterColor[player] / 255.0 ), 1.0 )
		RuiSetBool( file.pilotRui, "useCustomCharacterColor", true )
	}
}


vector function GetPlayerInfoColor( entity player )
{
	if ( player in file.customCharacterColor )
		return file.customCharacterColor[player]

	return GetKeyColor( COLORID_MEMBER_COLOR0, player.GetTeamMemberIndex() )
}


void function ClearCustomPlayerInfoColor( entity player )
{
	if ( player in file.customCharacterColor )
	{
		delete file.customCharacterColor[player]
		RuiSetBool( file.pilotRui, "useCustomCharacterColor", false )
	}
}


void function OverrideHUDHealthFractions( entity player, float targetHealthFrac = -1, float targetShieldFrac = -1 )
{
	if ( targetHealthFrac < 0 )
		RuiTrackFloat( file.pilotRui, "playerTargetHealthFrac", player, RUI_TRACK_STATUS_EFFECT_SEVERITY, eStatusEffect.target_health )
	else
		RuiSetFloat( file.pilotRui, "playerTargetHealthFrac", targetHealthFrac )

	if ( targetShieldFrac < 0 )
		RuiTrackFloat( file.pilotRui, "playerTargetShieldFrac", player, RUI_TRACK_STATUS_EFFECT_SEVERITY, eStatusEffect.target_shields )
	else
		RuiSetFloat( file.pilotRui, "playerTargetShieldFrac", targetShieldFrac )
}


void function OverrideMinimapPackages( entity player )
{
	RegisterMinimapPackage( "prop_script", eMinimapObject_prop_script.OBJECTIVE_AREA, MINIMAP_OBJECTIVE_AREA_RUI, MinimapPackage_ObjectiveAreaInit )
	RegisterMinimapPackage( "prop_script", eMinimapObject_prop_script.FD_HARVESTER, MINIMAP_OBJECT_RUI, MinimapPackage_PlaneInit )
	//
               
                        
			RegisterMinimapPackage( "prop_script", eMinimapObject_prop_script.VAULT_KEY, MINIMAP_OBJECT_RUI, MinimapPackage_VaultKey )
        
		RegisterMinimapPackage( "prop_script", eMinimapObject_prop_script.VAULT_PANEL, MINIMAP_OBJECT_RUI, MinimapPackage_VaultPanel, FULLMAP_OBJECT_RUI, MinimapPackage_VaultPanel )
		RegisterMinimapPackage( "prop_script", eMinimapObject_prop_script.VAULT_PANEL_OPEN, MINIMAP_OBJECT_RUI, MinimapPackage_VaultPanelOpen, FULLMAP_OBJECT_RUI, MinimapPackage_VaultPanelOpen )
       

	RegisterMinimapPackage( "prop_script", eMinimapObject_prop_script.HOVERTANK, MINIMAP_OBJECT_RUI, MinimapPackage_HoverTank )
	RegisterMinimapPackage( "prop_script", eMinimapObject_prop_script.HOVERTANK_DESTINATION, MINIMAP_OBJECT_RUI, MinimapPackage_HoverTankDestination )

                         
                                                                                                                     
       
                          
		RegisterMinimapPackage( "prop_script", eMinimapObject_prop_script.TRAIN, MINIMAP_OBJECT_RUI, MinimapPackage_Train )
		//
		//
       
                       
                                                                                                                                                                                         
       

	RegisterMinimapPackage( "prop_script", eMinimapObject_prop_script.RISING_WALL_DOWN, MINIMAP_OBJECT_RUI, MinimapPackage_RisingWall_Down )
	RegisterMinimapPackage( "prop_script", eMinimapObject_prop_script.RISING_WALL_MOVING, MINIMAP_OBJECT_RUI, MinimapPackage_RisingWall_Moving )
	RegisterMinimapPackage( "prop_script", eMinimapObject_prop_script.RISING_WALL_UP, MINIMAP_OBJECT_RUI, MinimapPackage_RisingWall_Up )
}


void function FD_NPCTitanInit( entity ent, var rui )
{
	#if(DEV)
		printt( "Adding '' (NPCTitanInit) icon to minimap" )
	#endif
	RuiSetImage( rui, "defaultIcon", $"" )
	RuiSetImage( rui, "clampedDefaultIcon", $"" )
}


              
void function MinimapPackage_VaultPanel( entity ent, var rui )
{
	#if(DEV)
		printt( "Adding 'rui/hud/gametype_icons/survival/data_knife_vault' icon to minimap" )
	#endif
	RuiSetImage( rui, "defaultIcon", $"rui/hud/gametype_icons/survival/data_knife_vault" )
	//
	//
	RuiSetFloat3( rui, "iconColor", (GetKeyColor( COLORID_LOOT_TIER5 ) / 255.0) )
	RuiSetImage( rui, "clampedDefaultIcon", $"" )
	RuiSetBool( rui, "useTeamColor", false )
}

void function MinimapPackage_VaultPanelOpen( entity ent, var rui )
{
	#if(DEV)
		printt( "Adding 'rui/hud/gametype_icons/survival/data_knife_vault_open' icon to minimap" )
	#endif
	RuiSetImage( rui, "defaultIcon", $"rui/hud/gametype_icons/survival/data_knife_vault_open" )
	RuiSetImage( rui, "smallIcon", $"rui/hud/gametype_icons/survival/data_knife_vault_small" )
	RuiSetBool( rui, "hasSmallIcon", true )
	RuiSetFloat3( rui, "iconColor", (GetKeyColor( COLORID_LOOT_TIER5 ) / 255.0) )
	RuiSetImage( rui, "clampedDefaultIcon", $"" )
	RuiSetBool( rui, "useTeamColor", false )
}
         


              
void function MinimapPackage_VaultKey( entity ent, var rui )
{
	#if(DEV)
		printt( "Adding VaultKey icon to minimap" )
	#endif
	//
	//
	//
}
         


void function MinimapPackage_HoverTank( entity ent, var rui )
{
	#if(DEV)
		printt( "Adding 'rui/hud/gametype_icons/survival/sur_hovertank_minimap' icon to minimap" )
	#endif
	RuiSetImage( rui, "defaultIcon", $"rui/hud/gametype_icons/survival/sur_hovertank_minimap" )
	RuiSetImage( rui, "clampedDefaultIcon", $"" )
	RuiSetBool( rui, "useTeamColor", false )
}


void function MinimapPackage_HoverTankDestination( entity ent, var rui )
{
	#if(DEV)
		printt( "Adding 'rui/hud/gametype_icons/survival/sur_hovertank_minimap_destination' icon to minimap" )
	#endif
	RuiSetImage( rui, "defaultIcon", $"rui/hud/gametype_icons/survival/sur_hovertank_minimap_destination" )
	RuiSetImage( rui, "clampedDefaultIcon", $"" )
	RuiSetBool( rui, "useTeamColor", false )
}

                        
                                                         
 
         
                                                                                     
       
                                                                                     
                                              
                                         
 
      

                         
void function MinimapPackage_Train( entity ent, var rui )
{
	#if(DEV)
		printt( "Adding 'rui/hud/gametype_icons/sur_train_minimap' icon to minimap" )
	#endif
	RuiSetImage( rui, "defaultIcon", $"rui/hud/gametype_icons/sur_train_minimap" )
	RuiSetImage( rui, "clampedDefaultIcon", $"" )
	RuiSetBool( rui, "useTeamColor", false )
}


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
      

                      
                                                                       
 
         
                                                                         
       
                                                                         
                                              
                                         
   
 
      


void function MinimapPackage_RisingWall_Down( entity ent, var rui )
{
	#if(DEV)
		printt( "Adding 'rui/hud/minimap/icon_map_wall_open' icon to minimap" )
	#endif
	RuiSetImage( rui, "defaultIcon", $"rui/hud/minimap/icon_map_wall_open" )
	RuiSetImage( rui, "clampedDefaultIcon", $"" )
	RuiSetBool( rui, "useTeamColor", false )
}


void function MinimapPackage_RisingWall_Moving( entity ent, var rui )
{
	#if(DEV)
		printt( "Adding 'rui/hud/minimap/icon_map_wall_moving' icon to minimap" )
	#endif
	RuiSetImage( rui, "defaultIcon", $"rui/hud/minimap/icon_map_wall_moving" )
	RuiSetImage( rui, "clampedDefaultIcon", $"" )
	RuiSetBool( rui, "useTeamColor", false )
}


void function MinimapPackage_RisingWall_Up( entity ent, var rui )
{
	#if(DEV)
		printt( "Adding 'rui/hud/minimap/icon_map_wall_blocking' icon to minimap" )
	#endif
	RuiSetImage( rui, "defaultIcon", $"rui/hud/minimap/icon_map_wall_blocking" )
	RuiSetImage( rui, "clampedDefaultIcon", $"" )
	RuiSetBool( rui, "useTeamColor", false )
}


void function MinimapPackage_PlaneInit( entity ent, var rui )
{
	#if(DEV)
		printt( "Adding 'rui/survival_ship' icon to minimap" )
	#endif
	if ( ent.GetTargetName() != "planeMapEnt" )
		return

	RuiSetImage( rui, "defaultIcon", $"rui/survival_ship" )
	RuiSetImage( rui, "clampedDefaultIcon", $"rui/survival_ship" )
	RuiSetBool( rui, "useTeamColor", false )
}


void function MinimapPackage_ObjectiveAreaInit( entity ent, var rui )
{
	RuiSetFloat( rui, "radiusScale", SURVIVAL_MINIMAP_RING_SCALE )
	if ( ent.IsClientOnly() )
		RuiSetFloat( rui, "objectRadius", ent.e.clientEntMinimapScale )
	else
		RuiTrackFloat( rui, "objectRadius", ent, RUI_TRACK_MINIMAP_SCALE )
	RuiSetImage( rui, "clampedImage", $"" )
	RuiSetImage( rui, "centerImage", $"" )
	RuiSetBool( rui, "blink", true )

	switch ( ent.GetTargetName() )
	{
		case "safeZone":
			RuiTrackFloat3( rui, "playerPos", GetLocalViewPlayer(), RUI_TRACK_ABSORIGIN_FOLLOW )
			RuiSetColorAlpha( rui, "objColor", SrgbToLinear( SAFE_ZONE_COLOR ), SAFE_ZONE_ALPHA )  //
			RuiSetBool( rui, "drawLine", true )
			break

		case "safeZone_noline":
			//
			RuiSetColorAlpha( rui, "objColor", SrgbToLinear( SAFE_ZONE_COLOR ), SAFE_ZONE_ALPHA )  //
			//
			break

		case "surveyZone":
			RuiSetBool( rui, "blink", false )
			RuiSetColorAlpha( rui, "objColor", SrgbToLinear( TEAM_COLOR_PARTY / 255.0 ), 0.05 )  //
			break

                         

		case "trainIcon":
			//
			//
			RuiSetBool( rui, "blink", false )
			RuiSetColorAlpha( rui, "objColor", SrgbToLinear( TEAM_COLOR_PARTY / 255.0 ), 1.0 )  //
			break
      

		case "risingWallIconDown":
		case "risingWallIconMoving":
		case "risingWallIconUp":
			RuiSetBool( rui, "blink", false )
			RuiSetColorAlpha( rui, "objColor", SrgbToLinear( TEAM_COLOR_PARTY / 255.0 ), 1.0 )  //
			break

                      

                             
                                                                                     
                                                                                          
                                   
                                          
     
        

                      
                                                                                 
                                                                                          
                                    
                                          
     
        
      

		case "hotZone":
			RuiSetColorAlpha( rui, "objColor", SrgbToLinear( <128, 188, 255> / 255.0 ), 0.25 )
			RuiSetColorAlpha( rui, "objBorderColor", SrgbToLinear( <128, 188, 255> / 255.0 ), 0.5 )
			RuiSetBool( rui, "blink", true )
			RuiSetBool( rui, "borderBlink", true )
			break

                                
		case "airdropClusterWhite":
			RuiSetColorAlpha( rui, "objColor", SrgbToLinear( GetKeyColor( COLORID_HUD_LOOT_TIER1 ) / 255.0 ), 0.25 )
			RuiSetColorAlpha( rui, "objBorderColor", SrgbToLinear( GetKeyColor( COLORID_HUD_LOOT_TIER1 ) / 255.0 ), 0.5 )
			RuiSetBool( rui, "blink", true )
			RuiSetBool( rui, "borderBlink", true )
			break
		case "airdropClusterBlue":
			RuiSetColorAlpha( rui, "objColor", SrgbToLinear( GetKeyColor( COLORID_HUD_LOOT_TIER2 ) / 255.0 ), 0.25 )
			RuiSetColorAlpha( rui, "objBorderColor", SrgbToLinear( GetKeyColor( COLORID_HUD_LOOT_TIER2 ) / 255.0 ), 0.5 )
			RuiSetBool( rui, "blink", true )
			RuiSetBool( rui, "borderBlink", true )
			break
		case "airdropClusterPurple":
			RuiSetColorAlpha( rui, "objColor", SrgbToLinear( GetKeyColor( COLORID_HUD_LOOT_TIER3 ) / 255.0 ), 0.25 )
			RuiSetColorAlpha( rui, "objBorderColor", SrgbToLinear( GetKeyColor( COLORID_HUD_LOOT_TIER3 ) / 255.0 ), 0.5 )
			RuiSetBool( rui, "blink", true )
			RuiSetBool( rui, "borderBlink", true )
			break
		case "airdropClusterGold":
			RuiSetColorAlpha( rui, "objColor", SrgbToLinear( GetKeyColor( COLORID_HUD_LOOT_TIER4 ) / 255.0 ), 0.25 )
			RuiSetColorAlpha( rui, "objBorderColor", SrgbToLinear( GetKeyColor( COLORID_HUD_LOOT_TIER4 ) / 255.0 ), 0.5 )
			RuiSetBool( rui, "blink", true )
			RuiSetBool( rui, "borderBlink", true )
			break
		case "airdropClusterRed":
			RuiSetColorAlpha( rui, "objColor", SrgbToLinear( GetKeyColor( COLORID_HUD_LOOT_TIER5 ) / 255.0 ), 0.25 )
			RuiSetColorAlpha( rui, "objBorderColor", SrgbToLinear( GetKeyColor( COLORID_HUD_LOOT_TIER5 ) / 255.0 ), 0.5 )
			RuiSetBool( rui, "blink", true )
			RuiSetBool( rui, "borderBlink", true )
			break
      

                         
		case "campfireZone":
			RuiSetColorAlpha( rui, "objColor", SrgbToLinear( <173, 216, 255> / 255.0 ), 0.25 )
			RuiSetColorAlpha( rui, "objBorderColor", SrgbToLinear( <173, 216, 230> / 255.0 ), 0.0 )
			RuiSetBool( rui, "blink", false )
			RuiSetBool( rui, "borderBlink", false )
			break
      

                
		case "craftingZone":
			RuiSetColorAlpha( rui, "objColor", SrgbToLinear( <255, 255, 255> / 255.0 ), 1 )
			RuiSetColorAlpha( rui, "objBorderColor", SrgbToLinear( <235, 207, 52> / 255.0 ), 0 )
			RuiSetAsset( rui, "areaImage", CRAFTING_ZONE_ASSET )
			RuiSetBool( rui, "blink", false )
			break
      

                              
		case FISSURE_MINIMAP_WARNING:
			RuiSetColorAlpha( rui, "objColor", SrgbToLinear( RING_COLLAPSEMODE_WARN_COLOR / 255.0 ), 0.04 )
			RuiSetColorAlpha( rui, "objBorderColor", SrgbToLinear( RING_COLLAPSEMODE_WARN_COLOR / 255.0 ), 0.5 )
			RuiSetBool( rui, "blink", true )
			RuiSetBool( rui, "borderBlink", true )
			break

		case RING_FISSURE:
			RuiSetColorAlpha( rui, "objColor", SrgbToLinear( RING_COLLAPSEMODE_DANGER_COLOR / 255.0 ), 1.0 )
			RuiSetColorAlpha( rui, "objBorderColor", SrgbToLinear( RING_COLLAPSEMODE_DANGER_COLOR_BORDER / 255.0 ), 1.0 )
			RuiSetBool( rui, "blink", false )
			RuiSetBool( rui, "borderBlink", false )
			break
      
              
                                     
                                                                                               
                                                                                                     
                                    
                                          
        
                                  
                                                                                    
                                                                                         
                                    
                                          
        
         
	}
}


void function CLSurvival_RegisterNetworkFunctions()
{
	if ( IsLobby() )
		return

	RegisterNetworkedVariableChangeCallback_time( "nextCircleStartTime", NextCircleStartTimeChanged )
	RegisterNetworkedVariableChangeCallback_time( "circleCloseTime", CircleCloseTimeChanged )
	RegisterNetworkedVariableChangeCallback_bool( "isHealing", OnIsHealingChanged )
	RegisterNetworkedVariableChangeCallback_ent( "killLeader", KillLeaderChangeCallback )
}


void function ScorebarInitTracking( entity player, var statusRui )
{
	RuiTrackInt( statusRui, "connectedPlayerCount", null, RUI_TRACK_SCRIPT_NETWORK_VAR_GLOBAL_INT, GetNetworkedVariableIndex( "connectedPlayerCount" ) )
	RuiTrackInt( statusRui, "livingPlayerCount", null, RUI_TRACK_SCRIPT_NETWORK_VAR_GLOBAL_INT, GetNetworkedVariableIndex( "livingPlayerCount" ) )
	RuiTrackInt( statusRui, "squadsRemainingCount", null, RUI_TRACK_SCRIPT_NETWORK_VAR_GLOBAL_INT, GetNetworkedVariableIndex( "squadsRemainingCount" ) )
	RuiTrackFloat( statusRui, "deathfieldDistance", player, RUI_TRACK_DEATHFIELD_DISTANCE )
	RuiTrackInt( statusRui, "teamMemberIndex", player, RUI_TRACK_PLAYER_TEAM_MEMBER_INDEX )

	UpdateKillLeaderOnGameStateRui( statusRui )

	MatchCandy_RUITrackForPlayer( statusRui, "coinCount", player )

/*







*/
}


void function OnHealthPickupTypeChanged( entity player, int oldKitType, int kitType, bool actuallyChanged )
{
	if ( WeaponDrivenConsumablesEnabled() )
	{
		Consumable_OnSelectedConsumableTypeNetIntChanged( player, oldKitType, kitType, actuallyChanged )
	}

	if ( !IsLocalViewPlayer( player ) )
		return

	UpdateDpadHud( player )
}


void function UpdateDpadHud( entity player )
{
	if ( !IsValid( player ) || file.pilotRui == null || file.dpadMenuRui == null )
		return

	if ( !IsLocalViewPlayer( player ) )
		return

	PerfStart( PerfIndexClient.SUR_HudRefresh )

	PerfStart( PerfIndexClient.SUR_HudRefresh_1 )
	int healthItems = SURVIVAL_Loot_GetTotalHealthItems( player, eHealthPickupCategory.HEALTH )
	PerfEnd( PerfIndexClient.SUR_HudRefresh_1 )
	RuiSetInt( file.dpadMenuRui, "totalHealthPackCount", healthItems )
	PerfStart( PerfIndexClient.SUR_HudRefresh_2 )
	int shieldItems = SURVIVAL_Loot_GetTotalHealthItems( player, eHealthPickupCategory.SHIELD )
	PerfEnd( PerfIndexClient.SUR_HudRefresh_2 )
	RuiSetInt( file.dpadMenuRui, "totalShieldPackCount", shieldItems )

	int kitType = Survival_Health_GetSelectedHealthPickupType()
	if ( kitType != -1 )
	{
		PerfStart( PerfIndexClient.SUR_HudRefresh_3 )
		string kitRef    = SURVIVAL_Loot_GetHealthPickupRefFromType( kitType )
		LootData kitData = SURVIVAL_Loot_GetLootDataByRef( kitRef )
		PerfEnd( PerfIndexClient.SUR_HudRefresh_3 )
		RuiSetInt( file.dpadMenuRui, "selectedHealthPickupCount", SURVIVAL_CountItemsInInventory( player, kitRef ) )
		RuiSetImage( file.dpadMenuRui, "selectedHealthPickupIcon", kitData.hudIcon )
		if ( PlayerHasPassive( player, ePassives.PAS_INFINITE_HEAL ) )
			RuiSetBool( file.dpadMenuRui, "isInfinite", true )
		else
			RuiSetBool( file.dpadMenuRui, "isInfinite", false )
	}
	else
	{
		RuiSetInt( file.dpadMenuRui, "selectedHealthPickupCount", -1 )
		RuiSetImage( file.dpadMenuRui, "selectedHealthPickupIcon", $"rui/hud/gametype_icons/survival/health_pack_auto" )
	}
	PerfEnd( PerfIndexClient.SUR_HudRefresh )

                   
                   
                                                             
       

	RuiSetInt( file.dpadMenuRui, "healthTypeCount", GetCountForLootType( eLootType.HEALTH ) )

	entity ordnanceWeapon = player.GetNormalWeapon( WEAPON_INVENTORY_SLOT_ANTI_TITAN )
	int ammo              = 0
	asset ordnanceIcon    = $""

	if ( IsValid( ordnanceWeapon ) )
	{
		ammo = SURVIVAL_CountItemsInInventory( player, ordnanceWeapon.GetWeaponClassName() )
		ordnanceIcon = ordnanceWeapon.GetWeaponSettingAsset( eWeaponVar.hud_icon )
	}

	RuiSetImage( file.dpadMenuRui, "ordnanceIcon", ordnanceIcon )
	RuiSetInt( file.dpadMenuRui, "ordnanceCount", ammo )
	RuiSetInt( file.dpadMenuRui, "ordnanceTypeCount", GetCountForLootType( eLootType.ORDNANCE ) )

                    
	RuiSetBool( file.dpadMenuRui, "gadgetUIEnabled", true )
	asset gadgetIcon = $"rui/hud/dpad/empty_slot" //
	LootData lootData = EquipmentSlot_GetEquippedLootDataForSlot( player, "gadgetslot" )
	string equipRef = EquipmentSlot_GetLootRefForSlot( player, "gadgetslot" )
	int maxAmmoCount = 0
	if ( IsLootTypeValid( lootData.lootType ) )
	{
		gadgetIcon = lootData.hudIcon
		maxAmmoCount = lootData.inventorySlotCount

		entity gadgetWeapon = player.GetNormalWeapon( WEAPON_INVENTORY_SLOT_GADGET )
		if( IsValid( gadgetWeapon ) )
			ammo = gadgetWeapon.GetWeaponPrimaryClipCount()
	}
	else
	{
		ammo = 0
	}
	RuiSetImage( file.dpadMenuRui, "gadgetIcon", gadgetIcon )
	RuiSetInt( file.dpadMenuRui, "gadgetCount", ammo )
	RuiSetInt( file.dpadMenuRui, "maxGadgetCount", maxAmmoCount )
       

                
		if ( StatusEffect_GetSeverity( player, eStatusEffect.is_boxing ) )
		{
			RuiSetBool( file.dpadMenuRui, "isBoxing", true )
		}
		else
		{
			RuiSetBool( file.dpadMenuRui, "isBoxing", false )
		}
       
}

array<void functionref( bool )> s_callbacks_OnUpdateShowButtonHints
void function AddCallback_OnUpdateShowButtonHints( void functionref( bool ) func )
{
	Assert( !s_callbacks_OnUpdateShowButtonHints.contains( func ) )
	s_callbacks_OnUpdateShowButtonHints.append( func )
}

array<void functionref( entity, ItemFlavor, int )> s_callbacks_OnVictoryCharacterModelSpawned
void function AddCallback_OnVictoryCharacterModelSpawned( void functionref( entity, ItemFlavor, int ) func )
{
	Assert( !s_callbacks_OnVictoryCharacterModelSpawned.contains( func ) )
	s_callbacks_OnVictoryCharacterModelSpawned.append( func )
}

bool s_didScorebarSetup = false
void function GameModeScoreBarRules( var gamestateRui )
{
	if ( !s_didScorebarSetup )
	{
		entity player = GetLocalViewPlayer()
		if ( !IsValid( player ) )
			return

		ScorebarInitTracking( player, gamestateRui )
		RuiSetBool( gamestateRui, "hideSquadsRemaining", GetCurrentPlaylistVarBool( "scorebar_hide_squads_remaining", false ) )
		RuiSetBool( gamestateRui, "hideWaitingForPlayers", GetCurrentPlaylistVarBool( "scorebar_hide_waiting_for_players", false ) )

		s_didScorebarSetup = true

		UpdateGamestateRuiTracking( player )

		//
		file.shouldShowButtonHintsLocal = !ShouldShowButtonHints()
	}

	PerfStart( PerfIndexClient.SUR_ScoreBoardRules_1 )
	PerfStart( PerfIndexClient.SUR_ScoreBoardRules_2 )

	if ( file.shouldShowButtonHintsLocal != ShouldShowButtonHints() )
	{
		entity player = GetLocalViewPlayer()
		if ( !IsValid( player ) )
			return

		bool showButtonHints = ShouldShowButtonHints()

		Minimap_UpdateShowButtonHint()
		ClWeaponStatus_UpdateShowButtonHint()
		if ( file.dpadMenuRui != null )
			RuiSetBool( file.dpadMenuRui, "showButtonHints", showButtonHints )

		//
		foreach ( func in s_callbacks_OnUpdateShowButtonHints )
			func( showButtonHints )

		file.shouldShowButtonHintsLocal = showButtonHints
	}

	PerfEnd( PerfIndexClient.SUR_ScoreBoardRules_2 )

	PerfStart( PerfIndexClient.SUR_ScoreBoardRules_3 )

	float endTime = GetNV_PreGameStartTime()
	if ( endTime > 0.0 )
		RuiSetGameTime( gamestateRui, "endTime", endTime )

	PerfEnd( PerfIndexClient.SUR_ScoreBoardRules_3 )
	PerfEnd( PerfIndexClient.SUR_ScoreBoardRules_1 )
}


void function OnIsHealingChanged( entity player, bool old, bool new, bool actuallyChanged )
{
	if ( player != GetLocalClientPlayer() )
		return

	UpdateHealHint( player )
}

void function SetNextCircleDisplayCustom_( NextCircleDisplayCustomData data )
{
	entity localViewPlayer = GetLocalViewPlayer()
	if ( !IsValid( localViewPlayer ) )
		return

	var gamestateRui = ClGameState_GetRui()
	array<var> ruis  = [gamestateRui]
	var cameraRui    = GetCameraCircleStatusRui()
	if ( IsValid( cameraRui ) )
		ruis.append( cameraRui )

	foreach ( rui in ruis )
	{
		RuiTrackFloat3( rui, "playerOrigin", localViewPlayer, RUI_TRACK_ABSORIGIN_FOLLOW )

		RuiSetGameTime( rui, "circleStartTime", data.circleStartTime )
		RuiSetGameTime( rui, "circleCloseTime", data.circleCloseTime )
		RuiSetGameTime( rui, "countdownGoalTime", data.countdownGoalTime )
		RuiSetInt( rui, "roundNumber", data.roundNumber )
		RuiSetString( rui, "roundClosingString", data.roundString )

		RuiSetFloat3( rui, "deathFieldOrigin", data.deathFieldOrigin )
		RuiSetFloat3( rui, "safeZoneOrigin", data.safeZoneOrigin )

		RuiSetFloat( rui, "deathfieldDistance", data.deathfieldDistance )
		RuiSetFloat( rui, "deathfieldStartRadius", data.deathfieldStartRadius )
		RuiSetFloat( rui, "deathfieldEndRadius", data.deathfieldEndRadius )

		RuiSetBool( rui, "hasAltIcon", (data.altIcon != $"") )
		RuiSetImage( rui, "altIcon", data.altIcon )
		RuiSetString( rui, "altIconText", data.altIconText )
		RuiSetColorAlpha( rui, "altColor", data.altColor, 1.0 )
	}
}


void function SetGamestateCountdown( float goalTime, asset altIcon, string altIconText, vector altColor = <1, 1, 1> )
{
	NextCircleDisplayCustomData data
	data.countdownGoalTime = goalTime
	data.altIcon = altIcon
	data.altIconText = altIconText
	data.altColor = altColor
	SetNextCircleDisplayCustom_( data )
}


void function SetGamestateCountdownClear()
{
	NextCircleDisplayCustomData data
	SetNextCircleDisplayCustom_( data )
}


void function SetNextCircleDisplayCustomStarting( float circleStartTime, asset altIcon, string altIconText, vector altColor = <1, 1, 1> )
{
	NextCircleDisplayCustomData data
	data.circleStartTime = circleStartTime
	data.roundNumber = -1
	data.altIcon = altIcon
	data.altIconText = altIconText
	data.altColor = altColor
	SetNextCircleDisplayCustom_( data )
}


void function SetNextCircleDisplayCustomClosing( float circleCloseTime, string prompt, vector altColor = <1, 1, 1> )
{
	NextCircleDisplayCustomData data
	data.circleStartTime = Time() - 4.0
	data.circleCloseTime = circleCloseTime
	data.roundString = prompt
	data.roundNumber = -1
	data.altColor = altColor
	SetNextCircleDisplayCustom_( data )
}


void function SetNextCircleDisplayCustomClear()
{
	NextCircleDisplayCustomData data
	SetNextCircleDisplayCustom_( data )
}


void function NextCircleStartTimeChanged( entity player, float old, float new, bool actuallyChanged )
{
	if ( !actuallyChanged || ! CircleAnnouncementsEnabled() )
		return

	UpdateFullmapRuiTracks()

	var gamestateRui = ClGameState_GetRui()
	array<var> ruis  = [gamestateRui]
	var cameraRui    = GetCameraCircleStatusRui()
	if ( IsValid( cameraRui ) )
		ruis.append( cameraRui )


	int roundNumber    = (SURVIVAL_GetCurrentDeathFieldStage() + 1)
	string roundString = Localize( "#SURVIVAL_CIRCLE_STATUS_ROUND_CLOSING", roundNumber )
	if ( SURVIVAL_IsFinalDeathFieldStage() )
		roundString = Localize( "#SURVIVAL_CIRCLE_STATUS_ROUND_CLOSING_FINAL" )
	DeathFieldStageData data = Cl_GetDeathFieldStage( SURVIVAL_GetCurrentDeathFieldStage() )
	float currentRadius      = Cl_SURVIVAL_GetDeathFieldCurrentRadius()
	float endRadius          = data.endRadius

	foreach ( rui in ruis )
	{
		RuiSetGameTime( rui, "circleStartTime", new )
		RuiSetInt( rui, "roundNumber", roundNumber )
		RuiSetString( rui, "roundClosingString", roundString )

		entity localViewPlayer = GetLocalViewPlayer()
		if ( IsValid( localViewPlayer ) )
		{
			RuiSetFloat( rui, "deathfieldStartRadius", currentRadius )
			RuiSetFloat( rui, "deathfieldEndRadius", endRadius )
			RuiTrackFloat3( rui, "playerOrigin", localViewPlayer, RUI_TRACK_ABSORIGIN_FOLLOW )

			#if(true)
				RuiTrackInt( rui, "teamMemberIndex", localViewPlayer, RUI_TRACK_PLAYER_TEAM_MEMBER_INDEX )
			#endif
		}
	}

	if ( new < Time() )
		return

	if ( actuallyChanged && GamePlaying() && CircleBannerAnnouncementsEnabled() )
	{
		if ( !GetCurrentPlaylistVarBool( "deathfield_starts_after_ship_flyout", true ) && SURVIVAL_GetCurrentDeathFieldStage() == 0 )
			return //

		if ( SURVIVAL_IsFinalDeathFieldStage() )
			roundString = "#SURVIVAL_CIRCLE_ROUND_FINAL"
		else
			roundString = Localize( "#SURVIVAL_CIRCLE_ROUND", SURVIVAL_GetCurrentRoundString() )

		float duration = 7.0

		AnnouncementData announcement
		announcement = Announcement_Create( "" )
		Announcement_SetSubText( announcement, roundString )
		Announcement_SetHeaderText( announcement, "#SURVIVAL_CIRCLE_WARNING" )
		Announcement_SetDisplayEndTime( announcement, new )
		Announcement_SetStyle( announcement, ANNOUNCEMENT_STYLE_CIRCLE_WARNING )
		Announcement_SetSoundAlias( announcement, CIRCLE_CLOSING_IN_SOUND )
		Announcement_SetPurge( announcement, true )
		Announcement_SetPriority( announcement, 200 ) //
		Announcement_SetDuration( announcement, duration )

		AnnouncementFromClass( GetLocalViewPlayer(), announcement )
	}
}


void function CircleCloseTimeChanged( entity player, float old, float new, bool actuallyChanged )
{
	var gamestateRui = ClGameState_GetRui()
	array<var> ruis  = [gamestateRui]
	var cameraRui    = GetCameraCircleStatusRui()
	if ( IsValid( cameraRui ) )
		ruis.append( cameraRui )
	foreach ( rui in ruis )
	{
		RuiSetGameTime( rui, "circleCloseTime", new )
	}

	UpdateFullmapRuiTracks()
}


void function InventoryCountChanged( entity player, int old, int new, bool actuallyChanged )
{
	ResetInventoryMenu( player )
}


asset function GetArmorIconForTypeIndex( int typeIndex )
{
	switch ( typeIndex )
	{
		case 1:
			return $"rui/hud/gametype_icons/survival/sur_armor_icon_l1"

		case 2:
			return $"rui/hud/gametype_icons/survival/sur_armor_icon_l2"

		case 3:
			return $"rui/hud/gametype_icons/survival/sur_armor_icon_l3"

		default:
			return $""
	}

	unreachable
}


void function EquipmentChanged( entity player, string equipSlot, int new )
{
	int tier          = 0
	EquipmentSlot es  = Survival_GetEquipmentSlotDataByRef( equipSlot )
	asset hudIcon     = es.emptyImage
	int armorCapacity = -1

	bool isEvo   = false
	int evoCount = 0

	if ( new > -1 )
	{
		LootData data = SURVIVAL_Loot_GetLootDataByIndex( new )
		tier = data.tier
		hudIcon = data.hudIcon

		if ( data.lootType == eLootType.ARMOR )
		{
			armorCapacity = SURVIVAL_GetCharacterShieldHealthMaxForArmor( player, data )
		}

		if ( es.attachmentPoint != "" )
		{
			string attachmentStyle = GetAttachmentPointStyle( es.attachmentPoint, data.ref )
			hudIcon = emptyAttachmentSlotImages[attachmentStyle]
		}
	}

                       
		LootData data = EquipmentSlot_GetEquippedLootDataForSlot( player, "armor" )
		if ( data.lootType == eLootType.ARMOR && EvolvingArmor_IsEquipmentEvolvingArmor( data.ref ) )
		{
			isEvo = true
			evoCount = EvolvingArmor_GetRequirementForEvolution( data.tier )
		}
       

	if ( player == GetLocalViewPlayer() )
	{
		if ( es.unitFrameTierVar != "" )
		RuiSetInt( file.pilotRui, es.unitFrameTierVar, tier )
		if ( es.unitFrameImageVar != "" )
		RuiSetImage( file.pilotRui, es.unitFrameImageVar, hudIcon )

		if ( armorCapacity >= 0 )
		{
			RuiSetInt( file.pilotRui, "armorShieldCapacity", armorCapacity )
		}
                        
			if ( data.lootType == eLootType.ARMOR )
			{
				if ( EvolvingArmor_IsEquipmentEvolvingArmor( data.ref ) )
				{
					RuiSetBool( file.pilotRui, "evoShieldDoubleDisplayAmount", EvolvingArmor_ExceedsMaxIntLimit( data ) )
					RuiSetBool( file.pilotRui, "isEvolvingShield", isEvo )
					RuiTrackInt( file.pilotRui, "evolvingShieldKillCounter", player, RUI_TRACK_SCRIPT_NETWORK_VAR_INT, GetNetworkedVariableIndex( NV_EVOLVING_ARMOR_KILL_COUNT ) )
				}
				else
				{
					RuiSetBool( file.pilotRui, "isEvolvingShield", false )
				}
			}
			else if ( data.ref == "" )
			{
				RuiSetBool( file.pilotRui, "isEvolvingShield", false )
			}
        

                               
                                                              
       
			RuiSetBool( file.pilotRui, "hasReducedShieldValues", false )
        

		UpdateActiveLootPings()
	}
	else
	{
		if ( PlayerHasUnitFrame( player ) )
		{
			var rui = GetUnitFrame( player ).rui

			RuiSetInt( rui, "armorShieldCapacity", armorCapacity )
		}
	}

	if ( player == GetLocalClientPlayer() )
	{
		ResetInventoryMenu( player )
	}
}


void function BackpackChanged( entity player, string equipSlot, int new )
{
	int tier         = 0
	EquipmentSlot es = Survival_GetEquipmentSlotDataByRef( equipSlot )
	asset hudIcon    = es.emptyImage

	if ( new > -1 )
	{
		LootData data = SURVIVAL_Loot_GetLootDataByIndex( new )
		tier = data.tier
		hudIcon = data.hudIcon
	}

	if ( player == GetLocalViewPlayer() )
	{
		RuiSetImage( file.dpadMenuRui, "backpackIcon", hudIcon )
		RuiSetInt( file.dpadMenuRui, "backpackTier", tier )
	}
}


void function UpdateActiveLootPings()
{
	entity player           = GetLocalViewPlayer()
	array<entity> waypoints = Waypoints_GetActiveLootPings()
	foreach ( wp in waypoints )
	{
		entity owner = wp.GetOwner()
		if ( owner != player )
		{
			entity lootItem = Waypoint_GetItemEntForLootWaypoint( wp )
			if ( !IsValid( lootItem ) )
				continue

			LootData lootData = SURVIVAL_Loot_GetLootDataByIndex( lootItem.GetSurvivalInt() )
			RuiSetBool( wp.wp.ruiHud, "isImportant", SURVIVAL_IsLootAnUpgrade( player, lootItem, lootData, eLootContext.GROUND ) )
		}
	}
}


void function LinkContestedChanged( entity player, bool old, bool new, bool actuallyChanged )
{
	if ( player != GetLocalClientPlayer() )
		return

	if ( player != GetLocalViewPlayer() )
		return

	RuiSetBool( file.titanLinkProgressRui, "isContested", new )
}


void function LinkInUseChanged( entity player, bool old, bool new, bool actuallyChanged )
{
	if ( player != GetLocalClientPlayer() )
		return

	if ( player != GetLocalViewPlayer() )
		return

	RuiSetBool( file.titanLinkProgressRui, "isInUse", new )
}


void function OnPilotCockpitCreated( entity cockpit, entity player )
{
	if ( file.pilotRui != null )
		RuiSetBool( file.pilotRui, "isVisible", GetHudDefaultVisibility() )

	if ( player == GetLocalViewPlayer() )
	{
		RuiTrackBool( file.dpadMenuRui, "inventoryEnabled", GetLocalViewPlayer(), RUI_TRACK_SCRIPT_NETWORK_VAR_BOOL, GetNetworkedVariableIndex( "inventoryEnabled" ) )
		RuiTrackInt( file.dpadMenuRui, "selectedHealthPickup", GetLocalViewPlayer(), RUI_TRACK_SCRIPT_NETWORK_VAR_INT, GetNetworkedVariableIndex( "selectedHealthPickupType" ) )
		RuiTrackFloat( file.dpadMenuRui, "bleedoutEndTime", GetLocalViewPlayer(), RUI_TRACK_SCRIPT_NETWORK_VAR, GetNetworkedVariableIndex( "bleedoutEndTime" ) )

		EquipmentSlot es = Survival_GetEquipmentSlotDataByRef( "backpack" )
		RuiSetImage( file.dpadMenuRui, "backpackIcon", es.emptyImage )
		RuiSetInt( file.dpadMenuRui, "backpackTier", 0 )

		foreach ( equipSlot, data in EquipmentSlot_GetAllEquipmentSlots() )
		{
			if ( data.trackingNetInt != "" )
			{
				EquipmentChanged( GetLocalViewPlayer(), equipSlot, EquipmentSlot_GetEquippedLootDataForSlot( player, equipSlot ).index )
			}
		}
	}
}


void function ToggleFireSelect( entity player )
{
	if ( file.nextAllowToggleFireRateTime > Time() )
		return

	file.nextAllowToggleFireRateTime = Time() + 0.05

	entity weapon = player.GetActiveWeapon( eActiveInventorySlot.mainHand )

	if ( !IsValid( weapon ) )
		return

	if ( weapon.IsDiscarding() )
		return

	if ( player.GetWeaponDisableFlags() == WEAPON_DISABLE_FLAGS_ALL )
		return

	foreach ( mod, toggleMod in GetAttachmentsWithToggleModsList() )
	{
		if ( IsModActive( weapon, mod ) )
		{
			WeaponModCommand_Toggle( toggleMod )
			return
		}
	}

	bool canToggleAltfire = DoesModExist( weapon, "altfire" ) && !DoesModExist( weapon, "hopup_selectfire" )
                       
		if ( canToggleAltfire && IsModActive( weapon, "hopup_highcal_rounds" ) )	//
			canToggleAltfire = false
       
	if ( canToggleAltfire )
	{
		WeaponModCommand_Toggle( "altfire" )
		return
	}

                           
   
   
                                              
  
                                                                                                         
                                           
        
  
      


                          
    
                                         
   
                                      
         
   
       

	if ( DoesModExist( weapon, "energized" ) && GetCurrentPlaylistVarBool( SENTINEL_USE_ENERGIZE_PLAYLIST_VAR, true ) )
		WeaponSentinel_TryApplyEnergized( player, weapon )


                         
                                                                                                                  
                                                       
      

                  
                                                      
                                             
      

                  
		if ( DoesModExist( weapon, "hopup_paintball" ) && IsModActive( weapon, "hopup_paintball" ) )
		{
			if ( IsModActive( weapon, "paintball_color01" ) )
			{
				WeaponModCommand_Toggle( "paintball_color01" )
				WeaponLmg_TryNextPaintballMod( player, weapon, 0 )
				return
			}
			else if ( IsModActive( weapon, "paintball_color02" ) )
			{
				WeaponModCommand_Toggle( "paintball_color02" )
				WeaponLmg_TryNextPaintballMod( player, weapon, 1 )
				return
			}
			else if ( IsModActive( weapon, "paintball_color03" ) )
			{
				WeaponModCommand_Toggle( "paintball_color03" )
				WeaponLmg_TryNextPaintballMod( player, weapon, 2 )
				return
			}
			else if ( IsModActive( weapon, "paintball_color_random" ) )
			{
				WeaponModCommand_Toggle( "paintball_color_random" )
				WeaponLmg_TryNextPaintballMod( player, weapon, 3 )
				return
			}
		}
       

	//
	if ( DoesModExist( weapon, "vertical_firestar" ) )
	{
		WeaponModCommand_Toggle( "vertical_firestar" )
		return
	}

	//
	if ( DoesModExist( weapon, "double_link_mod" ) )
	{
		WeaponModCommand_Toggle( "double_link_mod" )
		return
	}
}


void function ServerCallback_SUR_PingMinimap( vector origin, float duration, float spreadRadius, float ringRadius, int colorID, float frequency, float frequencyVariation, int airdropType )
{
	asset altIcon = $""
                
	if ( airdropType == eAirdropType.CRAFTING_REPLICATOR )
		altIcon = $"rui/hud/ping/hex_pulse"
      

	vector color = ColorPalette_GetColorFromID(colorID)
	thread ServerCallback_SUR_PingMinimap_Internal( origin, duration, spreadRadius, ringRadius, color, frequency, frequencyVariation, altIcon )
}

void function ServerCallback_SUR_PingMinimap_Internal( vector origin, float duration, float spreadRadius, float ringRadius, vector color, float frequency, float frequencyVariation, asset altIcon = $"" )
{
	entity player = GetLocalViewPlayer()
	player.EndSignal( "OnDestroy" )

	float endTime = Time() + duration

	float randMin = -1 * spreadRadius
	float randMax = spreadRadius

	float pulseDuration = 1.5
	float lifeTime      = 1.5

	float minWait = ( frequency - frequencyVariation )
	float maxWait = min( frequency + frequencyVariation, lifeTime )

	while ( Time() < endTime )
	{
		vector newOrigin = origin + < RandomIntRange( randMin, randMax ), RandomIntRange( randMin, randMax ), 0 >  //

		Minimap_RingPulseAtLocation( newOrigin, ringRadius, color / 255.0, pulseDuration, lifeTime, false, altIcon )
		FullMap_PingLocation( newOrigin, ringRadius, color / 255.0, pulseDuration, lifeTime, false, altIcon )

		wait RandomFloatRange( minWait, maxWait )
	}
}

struct FullmapDrawParams
{
	vector org
	vector right
	vector down
}

FullmapDrawParams function GetFullmapDrawParams()
{
	UISize screenSize = GetScreenSize()

	float mapSizeScale = GetCurrentPlaylistVarFloat( "fullmap_size_scale", 0.94 )
	float posScaleX    = GetCurrentPlaylistVarFloat( "fullmap_pos_x", -0.5 )
	float posScaleY    = GetCurrentPlaylistVarFloat( "fullmap_pos_y", -0.5/**/ )

	float size  = (screenSize.height * mapSizeScale)
	float baseX = (screenSize.width * 0.5)
	float baseY = (screenSize.height * 0.5)

	float posX = baseX + (screenSize.height * posScaleX)
	float posY = baseY + (screenSize.height * posScaleY)

	FullmapDrawParams fp
	fp.org = <posX, posY, 0.0>
	fp.right = <size, 0, 0>
	fp.down = <0, size, 0>
	return fp
}


void function CreateFullmap()
{
	FullmapDrawParams fp = GetFullmapDrawParams()
	file.mapTopoBG = RuiTopology_CreatePlane( fp.org, fp.right, fp.down, false )
	file.mapTopo = RuiTopology_CreatePlane( fp.org, fp.right, fp.down, true )
	file.minimapTopos.append( file.mapTopo )

	file.mapAimRui = RuiCreate( $"ui/survival_map_selector.rpak", file.mapTopoBG, FULLMAP_RUI_DRAW_LAYER, RUI_SORT_SCREENFADE - 2 )
	Fullmap_AddRui( file.mapAimRui )
}


void function FullMap_UpdateAimPos()
{
	RuiSetGameTime( file.mapAimRui, "updateTime", Time() )
}


void function FullMap_UpdateTopologies()
{
	FullmapDrawParams fp = GetFullmapDrawParams()

	RuiTopology_UpdatePos( file.mapTopoBG, fp.org, fp.right, fp.down )
	RuiTopology_UpdatePos( file.mapTopo, fp.org, fp.right, fp.down )
}


void function HideMapRui()
{
	//
	//
	//
	//
	//

	Fullmap_SetVisible( false )
	UpdateMainHudVisibility( GetLocalViewPlayer() )
}


void function ShowMapRui()
{
	HidePlayerHint( "#SURVIVAL_MAP_HINT" )
	file.needsMapHint = false

	//
	//
	//

	Fullmap_SetVisible( true )
	UpdateMainHudVisibility( GetLocalViewPlayer() )
}


bool function MapDevCheatsAreActive()
{
	#if(DEV)
		if ( !GetConVarBool( "sv_cheats" ) )
			return false
		if ( InputIsButtonDown( KEY_LSHIFT ) || InputIsButtonDown( BUTTON_STICK_LEFT ) )
			return true
	#endif

	return false
}


void function UpdateMap_THREAD()
{
	EndSignal( clGlobal.signalDummy, "OnHideScoreboard" )

	Fullmap_SetVisible( true )
	UpdateMainHudVisibility( GetLocalViewPlayer() )

	OnThreadEnd(
		function() : ()
		{
			Fullmap_SetVisible( false )
			UpdateMainHudVisibility( GetLocalViewPlayer() )
		}
	)

	//
	if ( GetCurrentPlaylistVarFloat( "fullmapCustomZoomFactor", 0 ) > 0 )
	{
		float fullmapCustomZoomFactor = GetCurrentPlaylistVarFloat( "fullmapCustomZoomFactor", 0 )
		file.fullmapZoomFactor = fullmapCustomZoomFactor
		SetBigMapZoomScale( file.fullmapZoomFactor )
	}

	for ( ; ; )
	{
		if ( IsValid( file.mapAimRui ) )
		{
			RuiSetBool( file.mapAimRui, "devCheatsAreActive", MapDevCheatsAreActive() )
			RuiSetBool( file.mapAimRui, "tpPromptIsActive", TPPromptIsActive() )
		}

		if ( InputIsButtonDown( BUTTON_TRIGGER_RIGHT ) )
			ChangeFullMapZoomFactor( FULLMAP_ZOOM_SPEED_CONTROLLER )

		if ( InputIsButtonDown( BUTTON_TRIGGER_LEFT ) )
			ChangeFullMapZoomFactor( -FULLMAP_ZOOM_SPEED_CONTROLLER )

		if ( IsSpectator( GetLocalClientPlayer() ) && file.updatePlayerTags == true)
		{
			array< entity > sortedPlayers = GetPlayerArray()
			sortedPlayers.sort( int function(entity playerA, entity playerB){
				entity player = GetLocalViewPlayer()
				if ( playerA.GetTeam() == playerB.GetTeam() && playerA.GetTeam() == player.GetTeam() )
				{
					return -1
				}

				vector playerOrigin = player.GetOrigin()
				vector distToPlayerA = playerA.GetOrigin() - playerOrigin
				vector distToPlayerB = playerB.GetOrigin() - playerOrigin
				if(distToPlayerA > distToPlayerB)
				{
					return 1
				}
				else if ( distToPlayerA < distToPlayerB )
				{
					return -1
				}

				return 0
			});

			int playersShownCount = 0
			foreach ( ent in sortedPlayers )
			{
				if ( !IsValid( ent ) || !ent.IsPlayer() )
					continue

				EHI ehi = ToEHI( ent )
				var rui = file.fullmapPlayerItems[ehi]

				if ( !IsValid( rui ) )
					continue

				entity player = GetLocalViewPlayer()

				bool showNameTag = false
				switch( file.playerTagMode )
				{
					case OBS_PLAYERTAG_MODE_NONE:
						printt("PlayerTagMode_None")
						showNameTag = false
						break;

					case OBS_PLAYERTAG_MODE_5_TEAMS:
						showNameTag = playersShownCount < 15
						playersShownCount++;
						break;
					case OBS_PLAYERTAG_MODE_7_TEAMS:
						showNameTag = playersShownCount < 21
						playersShownCount++;
						break;
					case OBS_PLAYERTAG_MODE_11_TEAMS:
						showNameTag = playersShownCount < 33
						playersShownCount++;
						break;
					case OBS_PLAYERTAG_MODE_ALL:
						showNameTag = true
						break;

					case OBS_PLAYERTAG_MODE_TEAM:
						showNameTag = (ent.GetTeam() == player.GetTeam())
						break;
				}

				if ( showNameTag )
					RuiSetString( rui, "playerName", ent.GetPlayerNameWithClanTag() )
				else
					RuiSetString( rui, "playerName", "" )

				if ( ent == player )
					RuiSetFloat2( rui, "highlightScaleTarget", < 1.5, 1.5, 0.0 > )
				else if ( ent == file.highlightedPlayer )
					RuiSetFloat2( rui, "highlightScaleTarget", < 2.0, 2.0, 0.0 > )
				else
					RuiSetFloat2( rui, "highlightScaleTarget", < 1.0, 1.0, 0.0 > )

				RuiSetBool( rui, "viewerIsSpectator", true )
			}

			file.updatePlayerTags = false
		}

		WaitFrame()
	}
}


void function ChangeFullMapZoomFactor( float delta )
{
	if ( IsViewingDeathScreen() )
	{
		//
		file.fullmapZoomFactor = 1.0
		SetBigMapZoomScale( 1.0 )
		return
	}

	vector oldAimPos = GetMapNormalizedAimCoordinate()

	file.fullmapZoomFactor *= pow( 1.5, delta )

	if ( file.fullmapZoomFactor > 6.0 )
		file.fullmapZoomFactor = 6.0

	if ( file.fullmapZoomFactor < 1 )
		file.fullmapZoomFactor = 1

	SetBigMapZoomScale( file.fullmapZoomFactor )

	vector newAimPos = GetMapNormalizedAimCoordinate()

	vector zoomDelta = oldAimPos - newAimPos

	float zoomScreenWidth       = 1.0 / GetBigMapZoomScale()
	float zoomAreaUpperLeftFrac = 1.0 - zoomScreenWidth

	if ( zoomAreaUpperLeftFrac > 0 )
	{
		file.fullmapZoomPos += zoomDelta / zoomAreaUpperLeftFrac
		file.fullmapZoomPos = <clamp( file.fullmapZoomPos.x, 0, 0.99999 ), clamp( file.fullmapZoomPos.y, 0, 0.99999 ), 0>
		SetBigMapZoomAnchor( file.fullmapZoomPos.x, file.fullmapZoomPos.y )
	}
}


void function Sur_OnScoreboardShow()
{
	if ( !GetCurrentPlaylistVarBool( "fullmap_enabled", true ) )
		return

	if ( Freelance_IsHubLevel() )
		return

	if ( RadialMenu_IsShowing() )
		RadialMenu_Destroy()

	ShowMapRui()
	UpdateFullmapRuiTracks()

	thread UpdateMap_THREAD()

	if ( !IsSpectating() && !IsPlayerInPlane( GetLocalViewPlayer() ) )
	{
		if ( GetCurrentPlaylistVarFloat( "fullmapCustomZoomAnchorX", 100 ) < 100 && GetCurrentPlaylistVarFloat( "fullmapCustomZoomAnchorY", 100 ) < 100 )
		{
			//
			float customX = GetCurrentPlaylistVarFloat( "fullmapCustomZoomAnchorX", 0.5 )
			float customY = GetCurrentPlaylistVarFloat( "fullmapCustomZoomAnchorY", 0.5 )
			file.fullmapZoomPos = < customX, customY, 0 >
			file.fullmapAimPos = file.fullmapZoomPos
		}
		else
		{
			//
			vector normalized = NormalizeWorldPos( GetLocalViewPlayer().GetOrigin() )
			file.fullmapAimPos = normalized
			file.fullmapZoomPos = normalized
		}
	}

	if ( IsValid( file.mapAimRui ) )
		RuiSetFloat2( file.mapAimRui, "pos", file.fullmapAimPos )

	s_inputDebounceIsActive = true
	HudInputContext inputContext
	inputContext.keyInputCallback = Survival_HandleKeyInput
	inputContext.moveInputCallback = Survival_HandleMoveInput
	inputContext.viewInputCallback = Survival_HandleViewInput
	inputContext.hudInputFlags = (HIF_ALLOW_AUTOSPRINT_FORWARD)
	HudInput_PushContext( inputContext )
	file.mapContextPushed = true
}


void function Sur_OnScoreboardHide()
{
	Signal( clGlobal.signalDummy, "OnHideScoreboard" )

	if ( !GetCurrentPlaylistVarBool( "fullmap_enabled", true ) )
		return

	if ( Freelance_IsHubLevel() )
		return

	HideMapRui()

	if ( file.mapContextPushed )
	{
		HudInput_PopContext()
		file.mapContextPushed = false
	}
}


void function AddInWorldMinimapObject( entity ent )
//
{
	Assert( IsValid( ent ) )
	thread AddInWorldMinimapObject_WhenValid( ent )
}


void function AddInWorldMinimapObject_WhenValid( entity ent )
{
	ent.EndSignal( "OnDestroy" )

	while ( !file.toposInitialized )
		WaitFrame()

	switch ( ent.GetTargetName() )
	{
		case CRYPTO_DRONE_TARGETNAME:
		case "no_minimap_object":
			return

		case "deathField":
			thread AddInWorldMinimapDeathFieldInternal( ent, file.mapTopo )
			return

                                
		case "airdropClusterWhite":
		case "airdropClusterBlue":
		case "airdropClusterPurple":
		case "airdropClusterGold":
		case "airdropClusterRed":
      

		case "hotZone":
			SetMapFeatureItem( 300, "#HOT_ZONE", "#HOT_ZONE_DESC", $"rui/hud/gametype_icons/survival/hot_zone" )
			//
                             

                        
                                                                  
                                                                                                                        
      

                      

                             
                      
      

                              

		case FISSURE_MINIMAP_WARNING:
		case RING_FISSURE:
      

		case "safeZone":
		case "safeZone_noline":
		case "surveyZone":
			thread AddInWorldMinimapObjectiveInternal( ent, file.mapTopo )
			return

                         

		case "trainIcon":
			foreach ( screen in file.minimapTopos )
				thread AddInWorldMinimapObjectInternal( ent, screen, $"rui/hud/gametype_icons/sur_train_minimap", $"rui/hud/gametype_icons/sur_train_minimap", <1.5, 1.5, 0.0>, <0.5, 0.5, 0.5> )
			return

			//
			//
			//
			//
			//
			//
			//
			//
			//
      

		case "risingWallIconDown":
			foreach ( screen in file.minimapTopos )
				thread AddInWorldMinimapObjectInternal( ent, screen, $"rui/hud/minimap/icon_map_wall_open", $"rui/hud/minimap/icon_map_wall_open", <1.0, 1.0, 1.0>, <1.0, 1.0, 1.0> )
			return

		case "risingWallIconMoving":
			foreach ( screen in file.minimapTopos )
				thread AddInWorldMinimapObjectInternal( ent, screen, $"rui/hud/minimap/icon_map_wall_moving", $"rui/hud/minimap/icon_map_wall_moving", <1.0, 1.0, 1.0>, <1.0, 1.0, 1.0> )
			return

		case "risingWallIconUp":
			foreach ( screen in file.minimapTopos )
				thread AddInWorldMinimapObjectInternal( ent, screen, $"rui/hud/minimap/icon_map_wall_blocking", $"rui/hud/minimap/icon_map_wall_blocking", <1.0, 1.0, 1.0>, <1.0, 1.0, 1.0> )
			return

                
		case "craftingZone":
			foreach ( screen in file.minimapTopos )
				thread AddInWorldMinimapObjectiveInternal( ent, screen )
			return
      

                     
		case "hover_vehicle":
			SetMapFeatureItem( 1000, "#HOVER_VEHICLE", "#HOVER_VEHICLE_DESC", HOVER_VEHICLE_SPAWNPOINT_ICON )
			return
      

                         
		case "campfireZone":
			//
			foreach ( screen in file.minimapTopos )
				thread AddInWorldMinimapObjectiveInternal( ent, screen )
			return
      

		case "hovertank":
			foreach ( screen in file.minimapTopos )
				thread AddInWorldMinimapObjectInternal( ent, screen, $"rui/hud/gametype_icons/survival/sur_hovertank_minimap", $"rui/hud/gametype_icons/survival/sur_hovertank_minimap", <1.5, 1.5, 0.0>, <0.5, 0.5, 0.5> )
			return

		case "hovertankDestination":
			foreach ( screen in file.minimapTopos )
				thread AddInWorldMinimapObjectInternal( ent, screen, $"rui/hud/gametype_icons/survival/sur_hovertank_minimap_destination", $"rui/hud/gametype_icons/survival/sur_hovertank_minimap_destination", <1.5, 1.5, 0.0>, <0.5, 0.5, 0.5> )
			return

                        

                       
                                          
                                                                                                                                                                                                 
         
      

		case "SurveyBeacon":
			foreach ( screen in file.minimapTopos )
				thread AddInWorldMinimapObjectInternal( ent, screen, $"rui/hud/gametype_icons/survival/survey_beacon_only_pathfinder", $"rui/hud/gametype_icons/survival/survey_beacon_only_pathfinder", <1.5, 1.5, 0.0>, <0.5, 0.5, 0.5> )
			return

              

			//
			//
			//
			//
			//
			//
			//
			//
			//
      

		case "pathCenterEnt":
			ent.SetDoDestroyCallback( true )
			Sur_SetPlaneCenterEnt( ent )
			foreach ( screen in file.minimapTopos )
				thread ShowPlaneTube( ent, screen )
			return

		case "planeEnt":
			foreach ( screen in file.minimapTopos )
				thread AddInWorldMinimapObjectInternal( ent, screen, $"rui/survival_ship", $"", <1.5, 1.5, 0.0>, <0.5, 0.5, 0.5> )
			return

		case "worldMarker":
			if ( IsFriendlyTeam( ent.GetTeam(), GetLocalViewPlayer().GetTeam() ) )
				thread AddInWorldMinimapObjectInternal( ent, file.mapTopo, $"rui/hud/gametype_icons/ctf/ctf_flag_neutral", $"rui/hud/gametype_icons/ctf/ctf_flag_neutral" )
			return

		case "trophy_system":
			if ( IsFriendlyTeam( ent.GetTeam(), GetLocalViewPlayer().GetTeam() ) )
				thread AddInWorldMinimapObjectInternal( ent, file.mapTopo, $"rui/hud/gametype_icons/survival/wattson_ult_map_icon", $"" )
			return

		case "tesla_trap":
			if ( IsFriendlyTeam( ent.GetTeam(), GetLocalViewPlayer().GetTeam() ) )
				thread AddInWorldMinimapTeslaTrap( ent, file.mapTopo )
			return
	}

	if ( !ent.IsPlayer() && !ent.IsTitan() )
		return

	while ( IsValid( ent ) )
	{
		if ( IsPVEMode() && ent.IsPlayer() && IsMultiTeamMission() )
			break

		if ( DoesModeDisplayIconsForAllTeams( GameRules_GetGameMode() ) )
			break
		if ( DoesModeDisplayIconsForAllFriendlyTeams( GameRules_GetGameMode() ) )
		{
			if ( ent.IsPlayer() && IsFriendlyTeam( ent.GetTeam(), GetLocalViewPlayer().GetTeam() ) )
			{
				break
			}
		}

		//
		if ( !IsSpectator( GetLocalClientPlayer() ) )
		{
			if ( ent.IsPlayer() && ent.GetTeam() != GetLocalViewPlayer().GetTeam() )
			{
				waitthread WaitForEntUpdate( ent, GetLocalViewPlayer() )
				continue
			}
			else if ( ent.IsTitan() && ent.GetTeam() != GetLocalViewPlayer().GetTeam() )
			{
				wait 0.5
				continue
			}
		}

		if ( IsValid( GetLocalViewPlayer() ) )
		{
			break
		}
		WaitFrame()
	}

	ent.SetDoDestroyCallback( true )

	thread AddInWorldMinimapObjectInternal( ent, file.mapTopo )
}


void function WaitForEntUpdate( entity ent, entity viewPlayer )
{
	EndSignal( ent, "SettingsChanged", "OnDeath", "TeamChanged" )

	EndSignal( viewPlayer, "SettingsChanged", "OnDeath", "TeamChanged" )

	WaitForever()
}


bool function DoesModeDisplayIconsForAllTeams( string mode )
{
	return false
}


bool function DoesModeDisplayIconsForAllFriendlyTeams( string mode )
{
                         
                                 
              
       
	return false
}


void function AddInWorldMinimapPlaneLine( var screen )
{
	if ( !IsValid( file.planeStart ) )
		return
	if ( !IsValid( file.planeEnd ) )
		return

	file.planeStart.EndSignal( "OnDestroy" )
	file.planeEnd.EndSignal( "OnDestroy" )

	int drawType = RUI_DRAW_WORLD
	if ( screen == file.mapTopo )
		drawType = RUI_DRAW_HUD

	int zOrder = file.planeEnd.Minimap_GetZOrder()

	printt( "======================= added line ========================" )

	var rui = RuiCreate( $"ui/in_world_minimap_line.rpak", screen, drawType, FULLMAP_Z_BASE + 10 )
	RuiSetFloat3( rui, "mapCorner", <file.mapCornerX, file.mapCornerY, 0.0> )
	RuiSetFloat( rui, "mapScale", file.mapScale )
	RuiTrackFloat3( rui, "startPos", file.planeStart, RUI_TRACK_ABSORIGIN_FOLLOW )
	RuiTrackFloat3( rui, "endPos", file.planeEnd, RUI_TRACK_ABSORIGIN_FOLLOW )
	RuiSetBool( rui, "hudVersion", screen == file.mapTopo )
	RuiSetBool( rui, "clipLine", false )

	OnThreadEnd(
		function() : ( rui )
		{
			printt( "Line Destroy " + rui )
			RuiDestroy( rui )
		}
	)

	entity clientEnt = GetClientEntFromTopo( screen )
	if ( clientEnt != null )
		clientEnt.EndSignal( "OnDestroy" )

	WaitForever()
}


void function AddInWorldMinimapObjectiveInternal( entity ent, var screen )
{
	if ( !IsValid( ent ) )
		return

	int customState    = ent.Minimap_GetCustomState()
	asset minimapAsset = $"ui/in_world_minimap_objective_area.rpak"
	int zOrder         = ent.Minimap_GetZOrder()
	entity viewPlayer  = GetLocalViewPlayer()

	int drawType = RUI_DRAW_WORLD
	if ( screen == file.mapTopo )
		drawType = FULLMAP_RUI_DRAW_LAYER

	var rui = RuiCreate( minimapAsset, screen, drawType, FULLMAP_Z_BASE + zOrder )

	RuiSetFloat3( rui, "mapCorner", <file.mapCornerX, file.mapCornerY, 0.0> )
	RuiSetFloat( rui, "mapScale", file.mapScale )
	RuiTrackFloat2( rui, "zoomPos", null, RUI_TRACK_BIG_MAP_ZOOM_ANCHOR )
	RuiTrackFloat( rui, "zoomFactor", null, RUI_TRACK_BIG_MAP_ZOOM_SCALE )
	RuiTrackFloat3( rui, "objectPos", ent, RUI_TRACK_ABSORIGIN_FOLLOW )
	RuiTrackFloat3( rui, "objectAngles", ent, RUI_TRACK_EYEANGLES_FOLLOW )
	if ( ent.IsClientOnly() )
	{
		RuiSetInt( rui, "objectFlags", ent.e.clientEntMinimapFlags )
		RuiSetInt( rui, "customState", ent.e.clientEntMinimapCustomState )
	}
	else
	{
		RuiTrackInt( rui, "objectFlags", ent, RUI_TRACK_MINIMAP_FLAGS )
		RuiTrackInt( rui, "customState", ent, RUI_TRACK_MINIMAP_CUSTOM_STATE )
	}
	RuiSetFloat( rui, "displayDist", max( file.threatMaxDist, 2200 ) )
	RuiSetBool( rui, "hudVersion", screen == file.mapTopo )

	MinimapPackage_ObjectiveAreaInit( ent, rui )

	Fullmap_AddRui( rui )

	OnThreadEnd(
		function() : ( rui )
		{
			Fullmap_RemoveRui( rui )
			RuiDestroy( rui )
		}
	)

	ent.EndSignal( "OnDestroy" )
	entity clientEnt = GetClientEntFromTopo( screen )
	if ( clientEnt != null )
		clientEnt.EndSignal( "OnDestroy" )

	if ( ent.IsPlayer() )
	{
		while ( IsValid( ent ) )
		{
			WaitSignal( ent, "SettingsChanged", "OnDeath" )
			RuiSetFloat2( rui, "iconScale", ent.IsTitan() ? <1.0, 1.0, 0.0> : <2.0, 2.0, 0.0> )
		}
	}
	else
	{
		ent.WaitSignal( "OnDestroy" )
	}
}


void function AddInWorldMinimapDeathFieldInternal( entity ent, var screen )
{
	if ( !IsValid( ent ) )
		return

	int customState    = ent.Minimap_GetCustomState()
	asset minimapAsset = $"ui/in_world_minimap_death_field.rpak"
	int zOrder         = ent.Minimap_GetZOrder()
	entity viewPlayer  = GetLocalViewPlayer()

	int drawType = RUI_DRAW_WORLD
	if ( screen == file.mapTopo )
		drawType = FULLMAP_RUI_DRAW_LAYER

	var rui = RuiCreate( minimapAsset, screen, drawType, FULLMAP_Z_BASE + zOrder )
	file.inWorldMinimapDeathFieldRui = rui
	asset mapImage = Minimap_GetAssetForKey( "minimap" )

	RuiSetImage( rui, "mapImage", mapImage )
	RuiSetImage( rui, "mapBgTileImage", GetMinimapBackgroundTileImage() )

	RuiSetFloat3( rui, "mapCorner", <file.mapCornerX, file.mapCornerY, 0.0> )
	RuiSetFloat( rui, "mapScale", file.mapScale )
	RuiTrackFloat2( rui, "zoomPos", null, RUI_TRACK_BIG_MAP_ZOOM_ANCHOR )
	RuiTrackFloat( rui, "zoomFactor", null, RUI_TRACK_BIG_MAP_ZOOM_SCALE )
	RuiTrackFloat3( rui, "objectPos", ent, RUI_TRACK_ABSORIGIN_FOLLOW )
	if ( ent.IsClientOnly() )
		RuiSetInt( rui, "objectFlags", ent.e.clientEntMinimapFlags )
	else
		RuiTrackInt( rui, "objectFlags", ent, RUI_TRACK_MINIMAP_FLAGS )
	RuiSetFloat( rui, "displayDist", max( file.threatMaxDist, 2200 ) )
	RuiSetBool( rui, "hudVersion", screen == file.mapTopo )

	RuiSetFloat( rui, "radiusScale", SURVIVAL_MINIMAP_RING_SCALE )
	FullMap_SetDeathFieldRadius( Cl_SURVIVAL_GetDeathFieldCurrentRadius() )

	Fullmap_AddRui( rui )
	Fullmap_AddTintableRui( rui )

	OnThreadEnd(
		function() : ( rui )
		{
			Fullmap_RemoveRui( rui )
			RuiDestroy( rui )
			file.inWorldMinimapDeathFieldRui = null
		}
	)

	ent.EndSignal( "OnDestroy" )
	entity clientEnt = GetClientEntFromTopo( screen )
	if ( clientEnt != null )
		clientEnt.EndSignal( "OnDestroy" )

	ent.WaitSignal( "OnDestroy" )
}


void function FullMap_SetDeathFieldRadius( float radius )
{
	if ( file.inWorldMinimapDeathFieldRui == null )
		return

	RuiSetFloat( file.inWorldMinimapDeathFieldRui, "objectRadius", radius / SURVIVAL_MINIMAP_RING_SCALE )
}


void function AddInWorldMinimapObjectInternal( entity ent, var screen, asset defaultIcon = $"", asset clampedDefaultIcon = $"", vector iconScale = <1.0, 1.0, 0.0>, vector iconColor = <1, 1, 1> )
{
	entity viewPlayer  = GetLocalViewPlayer()
	bool isNPCTitan    = ent.IsNPC() && ent.IsTitan()
	bool isPetTitan    = ent == viewPlayer.GetPetTitan()
	bool isLocalPlayer = ent == viewPlayer
	int customState    = ent.Minimap_GetCustomState()
	bool isFriendlyAlly = ent.GetTeam() != viewPlayer.GetTeam() && IsFriendlyTeam( ent.GetTeam(), viewPlayer.GetTeam() )
	asset minimapAsset = FULLMAP_OBJECT_RUI
	if ( ent.IsPlayer() )
	{
		minimapAsset = $"ui/in_world_minimap_player.rpak"
	}

	int zOrder       = ent.Minimap_GetZOrder()
	int zOrderOffset = 2 //

	int drawType = RUI_DRAW_WORLD
	if ( screen == file.mapTopo )
		drawType = FULLMAP_RUI_DRAW_LAYER

	var rui = RuiCreate( minimapAsset, screen, drawType, FULLMAP_Z_BASE + zOrder + zOrderOffset )

	//

	RuiSetFloat3( rui, "mapCorner", <file.mapCornerX, file.mapCornerY, 0.0> )
	RuiSetFloat( rui, "mapScale", file.mapScale )
	RuiTrackFloat2( rui, "zoomPos", null, RUI_TRACK_BIG_MAP_ZOOM_ANCHOR )
	RuiTrackFloat( rui, "zoomFactor", null, RUI_TRACK_BIG_MAP_ZOOM_SCALE )

	RuiTrackFloat3( rui, "objectPos", ent, RUI_TRACK_ABSORIGIN_FOLLOW )
	RuiTrackFloat3( rui, "objectAngles", ent, RUI_TRACK_EYEANGLES_FOLLOW )
	if ( ent.IsClientOnly() )
	{
		RuiSetInt( rui, "objectFlags", ent.e.clientEntMinimapFlags )
		RuiSetInt( rui, "customState", ent.e.clientEntMinimapCustomState )
	}
	else
	{
		RuiTrackInt( rui, "objectFlags", ent, RUI_TRACK_MINIMAP_FLAGS )
		RuiTrackInt( rui, "customState", ent, RUI_TRACK_MINIMAP_CUSTOM_STATE )
	}
	RuiSetFloat( rui, "displayDist", max( file.threatMaxDist, 2200 ) )
	RuiSetFloat( rui, "iconBlend", 1.0 )
	RuiSetFloat( rui, "iconPremul", 0.0 )
	RuiSetFloat2( rui, "iconScale", ent.IsTitan() ? <1.5, 1.5, 0.0> : <2.0, 2.0, 0.0> )
	RuiSetBool( rui, "hudVersion", screen == file.mapTopo )

	#if(true)
		if ( ent.IsPlayer() )
			RuiTrackInt( rui, "teamMemberIndex", ent, RUI_TRACK_PLAYER_TEAM_MEMBER_INDEX )
	#endif

	if ( ent.IsPlayer() )
		RuiTrackInt( rui, "squadID", ent, RUI_TRACK_SQUADID )

	if ( isLocalPlayer )
	{
		RuiSetBool( rui, "isLocalPlayer", isLocalPlayer )
	}

	if ( !ent.IsPlayer() )
	{
		if ( isNPCTitan )
		{
			//
			//
		}
		else
		{
			RuiSetImage( rui, "defaultIcon", defaultIcon )
			RuiSetImage( rui, "clampedDefaultIcon", clampedDefaultIcon )
			RuiSetFloat2( rui, "iconScale", iconScale )
			RuiSetFloat3( rui, "iconColor", iconColor )
		}
	}

	if ( ent.IsPlayer() )
	{
		bool viewerIsSpectator = IsSpectator( GetLocalClientPlayer() )
		RuiSetBool( rui, "viewerIsSpectator", viewerIsSpectator )

		vector smokeColor = SrgbToLinear(GetSkydiveSmokeColorForTeam( ent.GetTeam() ) / 255.0)
		RuiSetFloat3( rui, "smokeColor", smokeColor )


		RuiSetString( rui, "playerName", viewerIsSpectator ? ent.GetPlayerNameWithClanTag() : "" )
		if ( isFriendlyAlly )
			RuiSetFloat3( rui, "iconColorOverride", (GetKeyColor( COLORID_FRIENDLY ) / 255.0)  )

		if( viewerIsSpectator )
		{
			RuiTrackGameTime( rui, "lastFireTime", ent, RUI_TRACK_LAST_FIRED_TIME )
		}

		EHI ehi = ToEHI( ent )
		if( ehi in file.fullmapPlayerItems )
		{
			Fullmap_RemoveRui( file.fullmapPlayerItems[ehi] )	//
			file.fullmapPlayerItems[ehi] = null
		}

		file.fullmapPlayerItems[ehi] <- rui
	}

	Fullmap_AddRui( rui )

	OnThreadEnd(
		function() : ( rui, ent )
		{
			Fullmap_RemoveRui( rui )
			RuiDestroy( rui )
		}
	)

	ent.EndSignal( "OnDestroy" )
	entity clientEnt = GetClientEntFromTopo( screen )
	if ( clientEnt != null )
		clientEnt.EndSignal( "OnDestroy" )

	if ( ent.IsPlayer() )
	{
		while ( IsValid( ent ) )
		{
			WaitSignal( ent, "SettingsChanged", "OnDeath" )
			RuiSetFloat2( rui, "iconScale", ent.IsTitan() ? <1.0, 1.0, 0.0> : <2.0, 2.0, 0.0> )
			if ( isFriendlyAlly && !ent.IsTitan() )
				RuiSetFloat2( rui, "iconScale", <1.0, 1.0, 0.0> )
		}
	}
	else
	{
		ent.WaitSignal( "OnDestroy" )
	}
}


void function MinimapPackage_PlayerInit( entity ent, var rui )
{
	RuiTrackGameTime( rui, "lastFireTime", ent, RUI_TRACK_LAST_FIRED_TIME )
	if ( Is2TeamPvPGame() )
		//
	{
		RuiTrackFloat( rui, "sonarDetectedFrac", ent, RUI_TRACK_STATUS_EFFECT_SEVERITY, eStatusEffect.sonar_detected )
		RuiTrackFloat( rui, "maphackDetectedFrac", ent, RUI_TRACK_STATUS_EFFECT_SEVERITY, eStatusEffect.maphack_detected )
	}
}


void function AddMinimapLabel( string title, float xPos, float yPos, float width = 200, float scale = 1.0 )
{
	foreach ( topo in file.minimapTopos )
	{
		int drawType = RUI_DRAW_WORLD
		int sort     = FULLMAP_Z_BASE
		if ( topo == file.mapTopo )
		{
			drawType = FULLMAP_RUI_DRAW_LAYER
			sort = FULLMAP_Z_BASE + 20
		}

		var rui = RuiCreate( $"ui/in_world_minimap_label.rpak", topo, drawType, sort )
		RuiSetString( rui, "title", title )
		RuiSetFloat2( rui, "pos", <xPos, yPos, 0> )
		RuiTrackFloat2( rui, "zoomPos", null, RUI_TRACK_BIG_MAP_ZOOM_ANCHOR )
		RuiTrackFloat( rui, "zoomFactor", null, RUI_TRACK_BIG_MAP_ZOOM_SCALE )
		RuiSetFloat( rui, "width", width )
		RuiSetFloat( rui, "scale", scale )
		RuiSetBool( rui, "hudVersion", topo == file.mapTopo )

		if ( topo != file.mapTopo )
		{
			thread CleanupRuiOnTopoDestroy( rui, topo )
		}

		if ( topo == file.mapTopo )
			Fullmap_AddRui( rui )
	}
}


void function AddInWorldMinimapTeslaTrap( entity trapEnt, var screen )
{
	vector iconScale = <1.0, 1.0, 0.0>
	vector iconColor = <1, 1, 1>

	entity viewPlayer  = GetLocalViewPlayer()
	bool isLocalPlayer = trapEnt == viewPlayer
	int customState    = trapEnt.Minimap_GetCustomState()
	asset minimapAsset = FULLMAP_OBJECT_RUI
	int zOrder         = trapEnt.Minimap_GetZOrder()

	int drawType = RUI_DRAW_WORLD
	if ( screen == file.mapTopo )
		drawType = FULLMAP_RUI_DRAW_LAYER

	var rui = RuiCreate( $"ui/in_world_minimap_tesla_trap.rpak", screen, drawType, FULLMAP_Z_BASE + zOrder )
	RegisterTeslaTrapMinimapRui( trapEnt, rui )

	RuiSetFloat3( rui, "mapCorner", <file.mapCornerX, file.mapCornerY, 0.0> )
	RuiSetFloat( rui, "mapScale", file.mapScale )
	RuiTrackFloat2( rui, "zoomPos", null, RUI_TRACK_BIG_MAP_ZOOM_ANCHOR )
	RuiTrackFloat( rui, "zoomFactor", null, RUI_TRACK_BIG_MAP_ZOOM_SCALE )

	RuiTrackFloat3( rui, "objectPos", trapEnt, RUI_TRACK_ABSORIGIN_FOLLOW )
	RuiTrackFloat3( rui, "objectAngles", trapEnt, RUI_TRACK_EYEANGLES_FOLLOW )
	if ( trapEnt.IsClientOnly() )
		RuiSetInt( rui, "objectFlags", trapEnt.e.clientEntMinimapFlags )
	else
		RuiTrackInt( rui, "objectFlags", trapEnt, RUI_TRACK_MINIMAP_FLAGS )
	RuiSetBool( rui, "hudVersion", screen == file.mapTopo )

	Fullmap_AddRui( rui )

	OnThreadEnd(
		function() : ( rui )
		{
			Fullmap_RemoveRui( rui )
			RuiDestroy( rui )
		}
	)

	trapEnt.EndSignal( "OnDestroy" )
	entity clientEnt = GetClientEntFromTopo( screen )
	if ( clientEnt != null )
		clientEnt.EndSignal( "OnDestroy" )


	trapEnt.WaitSignal( "OnDestroy" )
}


void function CleanupRuiOnTopoDestroy( var rui, var topo )
{
	entity clientEnt = GetClientEntFromTopo( topo )
	if ( clientEnt != null )
		clientEnt.EndSignal( "OnDestroy" )

	OnThreadEnd(
		function () : ( rui )
		{
			Fullmap_RemoveRui( rui )
		}
	)

	WaitForever()
}


void function AllowSuperHint( entity player )
{
	file.superHintAllowed = true
}


void function Survival_OnPlayerClassChanged( entity player )
{
	if ( file.pilotRui == null )
		return

	if ( player != GetLocalViewPlayer() )
		return

	UpdateDpadHud( player )

	if ( player.IsTitan() )
	{
		if ( file.playerState != "titan" )
		{
			ResetInventoryMenu( player )
			file.playerState = "titan"
		}
	}
	else
	{
		bool resetInventory = false

		if ( file.playerState != "pilot" )
		{
			resetInventory = true
			file.playerState = "pilot"
		}

		if ( resetInventory )
		{
			ResetInventoryMenu( player )
		}

		bool isReady = LoadoutSlot_IsReady( ToEHI( player ), Loadout_Character() )
		if ( isReady )
		{
			thread InitSurvivalHealthBar()
		}
	}

	if ( player == GetLocalClientPlayer() )
	{
		thread PeriodicHealHint()
		thread TrackAmmoPool( player )
		thread TrackPrimaryWeapon( player )
		if ( file.pilotRui != null )
			thread TrackPrimaryWeaponEnabled( player, file.pilotRui, "Sur_EndTrackPrimary" )
	}

	ServerCallback_ClearHints()
}


void function OnPropDynamicCreated( entity prop )
{
	if ( prop.GetTargetName() == "fakeButton" )
		AddEntityCallback_GetUseEntOverrideText( prop, DroppodButtonUseTextOverride )
}


void function OnPropCreated( entity prop )
{
	if ( prop.GetSurvivalInt() < 0 )
	{
		PROTO_OnContainerCreated( prop )
		return
	}
}


string function DroppodButtonUseTextOverride( entity prop )
{
	if ( GetLocalViewPlayer().GetParent() != null )
		return " "
	return ""
}


void function OpenSurvivalMenu()
{
	entity player = GetLocalClientPlayer()

	if ( !IsAlive( player ) )
		RunUIScript( "ServerCallback_OpenSurvivalExitMenu", false )
	else
		PROTO_OpenInventoryOrSpecifiedMenu( player )
}


void function AddCallback_PlayerPressedInventory( bool functionref(entity) func )
{
	file.tryAccessInventoryCallbacks.append( func )
}


void function PROTO_OpenInventoryOrSpecifiedMenu( entity player )
{
	HideScoreboard()

	foreach ( func in file.tryAccessInventoryCallbacks )
	{
		if ( !func( player ) )
			return
	}

	if ( player.GetTeam() == TEAM_SPECTATOR && IsPrivateMatch() )
		PrivateMatch_OpenGameStatusMenu()
	else
		OpenSurvivalInventory( player )
}


void function OpenQuickSwap( entity player )
{
	thread TryOpenQuickSwap()
}


void function PeriodicHealHint()
{
	while ( IsAlive( GetLocalClientPlayer() ) )
	{
		wait 30.0
		UpdateHealHint( GetLocalClientPlayer() )
	}
}


void function TrackAmmoPool( entity player )
{
	if ( player != GetLocalViewPlayer() )
		return
	if ( player != GetLocalClientPlayer() )
		return

	player.Signal( "Sur_EndTrackAmmo" )
	player.EndSignal( "Sur_EndTrackAmmo" )
	player.EndSignal( "OnDeath" )

	table<string, int> oldAmmo
	foreach ( ammoRef, value in eAmmoPoolType )
	{
		oldAmmo[ ammoRef ] <- 0
	}

	while ( IsAlive( player ) )
	{
		bool resetAmmo = false
		foreach ( ammoRef, value in eAmmoPoolType )
		{
			int ammo = player.AmmoPool_GetCount( value )

			if ( ammo != oldAmmo[ ammoRef ] )
			{
				resetAmmo = true
				oldAmmo[ ammoRef ] = ammo
			}
		}

		if ( resetAmmo )
			ResetInventoryMenu( player )
		WaitFrame()
	}
}


void function TrackPrimaryWeapon( entity player )
{
	if ( player != GetLocalViewPlayer() )
		return

	if ( player != GetLocalClientPlayer() )
		return

	player.Signal( "Sur_EndTrackPrimary" )
	player.EndSignal( "Sur_EndTrackPrimary" )
	player.EndSignal( "OnDeath" )

	entity oldWeapon = player.GetActiveWeapon( eActiveInventorySlot.mainHand )
	int oldBitField  = 0

	if ( oldWeapon != null && oldWeapon.IsWeaponOffhand() )
		oldWeapon = null

	bool firstRun = true

	while ( IsAlive( player ) )
	{
		entity weapon = player.GetActiveWeapon( eActiveInventorySlot.mainHand )
		if ( IsValid( weapon ) && weapon.IsWeaponMelee() )
		{
			WaitFrame()
			continue
		}

		int bitField = 0

		if ( !player.IsTitan() )
		{
			if ( player.GetWeaponDisableFlags() != WEAPON_DISABLE_FLAGS_ALL )
			{
				if ( weapon != null && weapon.IsWeaponOffhand() )
					weapon = IsValid( oldWeapon ) ? oldWeapon : null
			}
			if ( weapon )
				bitField = weapon.GetModBitField()
		}

		if ( (weapon != oldWeapon || bitField != oldBitField || firstRun) )
		{
			firstRun = false

			if ( IsValid( weapon ) && weapon.GetWeaponType() != WT_ANTITITAN )
				file.lastPrimaryWeapon = weapon
			else
				file.lastPrimaryWeapon = null

			ServerCallback_ClearHints()

			if ( IsValid( weapon ) )
			{
				if ( weapon.GetWeaponType() == WT_ANTITITAN && SURVIVAL_GetAllPlayerOrdnance( player ).len() > 1 )
					ServerCallback_SurvivalHint( eSurvivalHints.ORDNANCE )
			}

			UpdateActiveLootPings()
			ResetInventoryMenu( player )
			oldWeapon = weapon
			oldBitField = bitField
		}
		WaitFrame()
	}
}


void function ServerCallback_SurvivalHint( int hintType )
{
	string hintString
	float duration = 8.0

	switch ( hintType )
	{
		case eSurvivalHints.EQUIP:
			hintString = "#SURVIVAL_ATTACH_HINT"
			break

		case eSurvivalHints.ORDNANCE:
			duration = 2.0
			hintString = "#SURVIVAL_ORDNANCE_HINT"
			break

		default:
			return
	}
	AddPlayerHint( duration, 0.5, $"", hintString )
}


void function ServerCallback_ClearHints()
{
	HidePlayerHint( "#SURVIVAL_MAP_HINT" )
	HidePlayerHint( "#SURVIVAL_ATTACH_HINT" )
	HidePlayerHint( "#SURVIVAL_DROPPOD_LAUNCH_HINT" )
	HidePlayerHint( "#SURVIVAL_DROPPOD_STEER_HINT" )
	HidePlayerHint( "#SURVIVAL_DROPPOD_ACTIVATE_HINT" )
	HidePlayerHint( "#SURVIVAL_TITAN_HOVER_HINT" )
}


void function SurvivalTitanHoverHint()
{
	ServerCallback_ClearHints()
	wait 4
	AddPlayerHint( 6.0, 0.5, $"", "#SURVIVAL_TITAN_HOVER_HINT" )
}


vector function NormalizeWorldPos( vector pos, float zoomFactor = 1.0 )
{
	float mapScaleTweak  = max( file.mapScale * OVERVIEW_MAP_SIZE, 1 )
	vector normalizedPos = (pos - <file.mapCornerX, file.mapCornerY, 0>) / mapScaleTweak
	normalizedPos = <normalizedPos.x, -1 * normalizedPos.y, 0> * zoomFactor
	return normalizedPos
}


vector function ConvertNormalizedPosToWorldPos( vector normalizedPos, float zoomFactor = 1.0 )
{
	vector fixedPos     = <normalizedPos.x, -1 * normalizedPos.y, 0> / zoomFactor
	float mapScaleTweak = max( file.mapScale * OVERVIEW_MAP_SIZE, 1 )
	vector pos          = (fixedPos * mapScaleTweak) + <file.mapCornerX, file.mapCornerY, 0>
	return pos
}


//
bool function Survival_HandleKeyInput( int key )
{
#if(DEV)
	if ( MapDevCheatsAreActive() )
	{
		switch ( key )
		{
			case BUTTON_A:
			case MOUSE_LEFT:
				vector worldPos = ConvertNormalizedPosToWorldPos( GetMapNormalizedAimCoordinate() )
				GetLocalClientPlayer().ClientCommand( format( "GoToMapPoint %.3f %.3f %.3f", worldPos.x, worldPos.y, worldPos.z ) )
				ScreenFlash( 0.0, 0.0, 0.0, 0.1, 0.5 )
				EmitSoundOnEntity( GetLocalViewPlayer(), "dropship_mp_epilogue_warpout" )
				delaythread( 0.25 ) HideScoreboard()
				return true

			case BUTTON_B:
			case MOUSE_RIGHT:
				vector worldPos = ConvertNormalizedPosToWorldPos( GetMapNormalizedAimCoordinate() )
				GetLocalClientPlayer().ClientCommand( format( "UpdateCirclePos %.3f %.3f %.3f", worldPos.x, worldPos.y, worldPos.z ) )
				delaythread( 0.25 ) HideScoreboard()
				return true
		}

		return false
	}
	else
#endif //
	{
		if ( TPPromptIsActive() )
		{
			switch ( key )
			{
				case BUTTON_A:
				case MOUSE_LEFT:
					vector worldPos = ConvertNormalizedPosToWorldPos( GetMapNormalizedAimCoordinate() )
					Remote_ServerCallFunction( "ClientCallback_TPPromptGoToMapPoint", worldPos.x, worldPos.y )
					ScreenFlash( 0.0, 0.0, 0.0, 0.1, 0.5 )
					EmitSoundOnEntity( GetLocalViewPlayer(), "dropship_mp_epilogue_warpout" )
					delaythread( 0.25 ) HideScoreboard()
					return true
			}
		}
	}

	bool pressedPing  = false
	bool swallowInput = false
	switch ( key )
	{
		case MOUSE_WHEEL_UP:
			ChangeFullMapZoomFactor( FULLMAP_ZOOM_SPEED_MOUSE )
			swallowInput = true
			break

		case MOUSE_WHEEL_DOWN:
			ChangeFullMapZoomFactor( -FULLMAP_ZOOM_SPEED_MOUSE )
			swallowInput = true
			break

		case BUTTON_TRIGGER_RIGHT:
		case BUTTON_TRIGGER_RIGHT_FULL:
			ChangeFullMapZoomFactor( FULLMAP_ZOOM_SPEED_CONTROLLER )
			swallowInput = true
			break

		case BUTTON_TRIGGER_LEFT:
		case BUTTON_TRIGGER_LEFT_FULL:
			ChangeFullMapZoomFactor( -FULLMAP_ZOOM_SPEED_CONTROLLER )
			swallowInput = true
			break

		case BUTTON_SHOULDER_RIGHT:
		case MOUSE_LEFT:
			if( GetLocalClientPlayer().GetTeam() == TEAM_SPECTATOR )
			{
				Spectator_ViewPlayer( GetLocalClientPlayer() )
				swallowInput = true
			}
			else
			{
				pressedPing = true
			}
			break

		case MOUSE_RIGHT:
		case BUTTON_X:
			Ping_ClearMapWaypoint( GetLocalClientPlayer() )
			swallowInput = true
			break

		case BUTTON_B:
			HideScoreboard()
			swallowInput = true
			break

		case MOUSE_MIDDLE:
		case BUTTON_STICK_RIGHT:
		case BUTTON_Y:
		case BUTTON_DPAD_RIGHT:
		case BUTTON_DPAD_LEFT:
			swallowInput = true
			break
	}

	if ( pressedPing )
		printt( "pressedPing", key )

	if ( ButtonIsBoundToAction( key, "use" ) )
		return true

	if ( ButtonIsBoundToAction( key, "+jump" ) )
		return true

	if ( ButtonIsBoundToAction( key, "offhand1" ) )
		return true

	if ( ButtonIsBoundToAction( key, "offhand4" ) )
		return true

	if ( (!IsControllerModeActive() && ButtonIsBoundToPing( key )) || pressedPing )
	{
		vector worldPos = ConvertNormalizedPosToWorldPos( GetMapNormalizedAimCoordinate() )
		Ping_SetMapWaypoint( GetLocalClientPlayer(), worldPos )
		swallowInput = true
	}

	return swallowInput
}


vector function SmoothInput( vector vecIn )
{
	const float DEADZONE = 0.05

	float len = min( Length2D( vecIn ), 1.0 )
	if ( len < DEADZONE )
		return <0, 0, 0>

	float factor = (len * len)
	return (vecIn * factor)
}


vector function GetMapNormalizedAimCoordinate()
{
	float zoomScreenWidth = 1.0 / file.fullmapZoomFactor

	float zoomAreaUpperLeftFrac = 1.0 - zoomScreenWidth
	vector zoomAreaUpperLeft    = file.fullmapZoomPos * zoomAreaUpperLeftFrac
	return zoomAreaUpperLeft + file.fullmapAimPos * zoomScreenWidth
}


entity function GetPlayerUnderAim()
{
	vector worldPos = ConvertNormalizedPosToWorldPos( GetMapNormalizedAimCoordinate() )
	//

	array<entity> playerArray = GetPlayerArray_Alive()
	foreach ( player in playerArray )
	{
		if( !IsValid( player ) )
			continue

		vector playerOrigin = player.GetOrigin()
		if( fabs( playerOrigin.x - worldPos.x ) <= FULLMAP_SELECT_RANGE &&
			fabs( playerOrigin.y - worldPos.y ) <= FULLMAP_SELECT_RANGE )
		{
			return player
		}
	}

	return null
}

void function Spectator_ViewPlayer( entity spectatorPlayer )
{
	entity player = GetPlayerUnderAim()
	if( IsValid(player) )
	{
		Remote_ServerCallFunction( "ClientCallback_PrivateMatchChangeObserverTarget", player )
	}
}

bool function Survival_HandleViewInput( float x, float y )
{
	if ( IsControllerModeActive() )
		return false

	//

	vector oldAimPos = GetMapNormalizedAimCoordinate()

	file.fullmapAimPos += <x, -y, 0> * 0.001
	vector desiredFullMapPos = file.fullmapAimPos

	if ( InputIsButtonDown( MOUSE_RIGHT ) )//
	{
		vector newAimPos = GetMapNormalizedAimCoordinate()

		vector delta = oldAimPos - newAimPos

		float zoomScreenWidth       = 1.0 / file.fullmapZoomFactor
		float zoomAreaUpperLeftFrac = 1.0 - zoomScreenWidth

		if ( zoomAreaUpperLeftFrac > 0 )
			file.fullmapZoomPos += delta / zoomAreaUpperLeftFrac
	}

	file.fullmapAimPos = <clamp( file.fullmapAimPos.x, 0, 0.99999 ), clamp( file.fullmapAimPos.y, 0, 0.99999 ), 0>
	vector clampDiff = desiredFullMapPos - file.fullmapAimPos
	if ( file.fullmapZoomFactor > 0 )
		file.fullmapZoomPos += clampDiff / file.fullmapZoomFactor

	file.fullmapZoomPos = <clamp( file.fullmapZoomPos.x, 0, 0.99999 ), clamp( file.fullmapZoomPos.y, 0, 0.99999 ), 0>
	SetBigMapZoomAnchor( file.fullmapZoomPos.x, file.fullmapZoomPos.y )

	if ( IsValid( file.mapAimRui ) )
		RuiSetFloat2( file.mapAimRui, "pos", file.fullmapAimPos )

	entity playerUnderAim = GetPlayerUnderAim()
	if ( playerUnderAim != file.highlightedPlayer )
	{
		file.highlightedPlayer = playerUnderAim
		file.updatePlayerTags = true
	}

	return true
}


bool s_inputDebounceIsActive = false
bool function Survival_HandleMoveInput( float x, float y )
{
	if ( !IsValid( file.mapAimRui ) )
		return false
	if ( !IsControllerModeActive() )
		return false

	if ( s_inputDebounceIsActive )
	{
		const float DEBOUNCE_THRESHOLD = 0.4
		float len = min( Length2D( <x, y, 0> ), 1.0 )
		if ( len > DEBOUNCE_THRESHOLD )
			return true
		s_inputDebounceIsActive = false
	}

	float deltaTime = Time() - file.moveInputPrevTime
	file.moveInputPrevTime = Time()

	if ( deltaTime > 1.0 )
		deltaTime = 0.01

	vector smoothed = SmoothInput( <x, y, 0> )
	file.fullmapAimPos += <smoothed.x, (-1.0 * smoothed.y), 0> * deltaTime / file.fullmapZoomFactor
	file.fullmapAimPos = <clamp( file.fullmapAimPos.x, 0, 0.99999 ), clamp( file.fullmapAimPos.y, 0, 0.99999 ), 0>
	file.fullmapZoomPos = file.fullmapAimPos
	RuiSetFloat2( file.mapAimRui, "pos", file.fullmapAimPos )
	SetBigMapZoomAnchor( file.fullmapZoomPos.x, file.fullmapZoomPos.y )
	return true
}


void function Sur_Cl_PickLoadout( entity player )
{

}


void function Survival_WaitForPlayers()
{
	file.cameFromWaitingForPlayersState = true
	SetDpadMenuVisible()
	SetMapSetting_FogEnabled( true )
	Minimap_UpdateMinimapVisibility( GetLocalClientPlayer() )
}


void function EnableToggleMuteKeys()
{
	if ( !SquadMuteIntroEnabled() )
		return

	if ( file.toggleMuteKeysEnabled )
		return

	RegisterButtonPressedCallback( BUTTON_Y, OnToggleMute )
	RegisterButtonPressedCallback( KEY_F, OnToggleMute )

	file.toggleMuteKeysEnabled = true
}


void function DisableToggleMuteKeys()
{
	if ( !SquadMuteIntroEnabled() )
		return

	if ( !file.toggleMuteKeysEnabled )
		return

	DeregisterButtonPressedCallback( BUTTON_Y, OnToggleMute )
	DeregisterButtonPressedCallback( KEY_F, OnToggleMute )

	file.toggleMuteKeysEnabled = false
}


void function OnToggleMute( var button )
{
	ToggleSquadMute()
}


void function StreamHintPlayers()
{
	thread (void function() : () {
		array<entity> players = GetPlayerArray_Alive()
		foreach ( player in players )
		{
			if ( !IsValid( player ) )
				continue

			StreamModelHint( player.GetModelName() )
			wait 0.1
		}
	})()
}


bool function GetWaitingForPlayersOverlayEnabled( entity player )
{
	if ( IsTestMap() )
		return false
	if ( player.GetTeam() == TEAM_SPECTATOR )
		return false
	if ( GetCurrentPlaylistVarBool( "survival_staging_area_enabled", false ) )
		return false

	return true
}

var s_overlayRui = null
void function WaitingForPlayersOverlay_Setup( entity player )
{
	if ( !GetWaitingForPlayersOverlayEnabled( player ) )
		return

	s_overlayRui = CreatePermanentCockpitRui( $"ui/waiting_for_players_blackscreen.rpak", -1 )
	RuiSetResolutionToScreenSize( s_overlayRui )
	RuiSetBool( s_overlayRui, "isOpaque", PreGame_GetWaitingForPlayersHasBlackScreen() )

	UpdateWaitingForPlayersMuteHint()
}


void function WaitingForPlayersOverlay_Destroy()
{
	if ( s_overlayRui == null )
		return

	RuiDestroyIfAlive( s_overlayRui )
	s_overlayRui = null
}


void function UpdateWaitingForPlayersMuteHint()
{
	if ( !s_overlayRui )
		return

	string muteString = ""
	if ( SquadMuteIntroEnabled() && !IsSoloMode() )
		muteString = Localize( IsSquadMuted() ? "#CHAR_SEL_BUTTON_UNMUTE" : "#CHAR_SEL_BUTTON_MUTE" )
	RuiSetString( s_overlayRui, "squadMuteHint", muteString )
}


void function OnGamestatePlaying()
{
	WaitingForPlayersOverlay_Destroy()
}


void function Survival_RunCharacterSelection()
{
	if ( file.shouldRunCharacterSelectionCallback != null )
	{
		if ( !file.shouldRunCharacterSelectionCallback() )
			return
	}

	SetDpadMenuHidden()
	WaitingForPlayersOverlay_Destroy()
	thread Survival_RunCharacterSelection_Thread()
}


void function Survival_RunCharacterSelection_Thread()
{
	FlagWait( "ClientInitComplete" )

	if ( !Survival_CharacterSelectEnabled() )
		return

	while( GetGlobalNetBool( "characterSelectionReady" ) == false )
		WaitFrame()
	for ( ; ; )
	{
		entity player = GetLocalClientPlayer()
		if ( IsValid( player ) && (player.GetPlayerNetInt( "characterSelectLockstepPlayerIndex" ) >= 0) )
			break
		WaitFrame()
	}

	HideMapRui()

	//
	CloseCharacterSelectNewMenu()
	WaitFrame()
	OpenCharacterSelectNewMenu()

	while( Time() < GetGlobalNetTime( "squadPresentationStartTime" ) )
		WaitFrame()

	if ( GetCurrentPlaylistVarInt( "survival_enable_squad_intro", 1 ) == 1 )
		thread DoSquadCardsPresentation()
	else
		CloseCharacterSelectNewMenu()

	while( Time() < GetGlobalNetTime( "championSquadPresentationStartTime" ) )
		WaitFrame()

	if ( GetCurrentPlaylistVarInt( "survival_enable_gladiator_intros", 1 ) == 1 )
		thread DoChampionSquadCardsPresentation()
}


void function OnGameStateChanged(entity player, int oldVal, int newVal, bool actuallyChanged)
{
	int gamestate = newVal

	if ( gamestate == eGameState.Playing && actuallyChanged )
	{
		array<entity> players = GetPlayerArray()
		//
		int myTeam = GetLocalClientPlayer().GetTeam()
		foreach ( enemyPlayer in players )
		{
			if ( enemyPlayer.GetTeam() != myTeam )
				enemyPlayer.RequestClubData()
		}
	}

	var gamestateRui = ClGameState_GetRui()
	if ( gamestateRui == null )
		return

	bool gamestateIsPlaying         = GamePlaying()
	bool gamestateWaitingForPlayers = gamestate == eGameState.WaitingForPlayers
	RuiSetBool( gamestateRui, "gamestateIsPlaying", gamestateIsPlaying )
	RuiSetBool( gamestateRui, "gamestateWaitingForPlayers", gamestateWaitingForPlayers )
	RuiSetInt( gamestateRui, "gamestate", gamestate )

	if ( file.pilotRui != null )
	{
		RuiSetBool( file.pilotRui, "gamestateIsPlaying", gamestateIsPlaying )
		RuiSetBool( file.dpadMenuRui, "gamestateIsPlaying", gamestateIsPlaying )

		RuiSetBool( file.pilotRui, "gamestateWaitingForPlayers", gamestateWaitingForPlayers )
		RuiSetBool( file.dpadMenuRui, "gamestateWaitingForPlayers", gamestateWaitingForPlayers )
	}

	var netGraphRui = CLGameState_GetNetGraphRui()
	if ( netGraphRui != null )
	{
		float graphAlpha = 1.0
		if ( gamestateWaitingForPlayers )
			graphAlpha = 0.0

		if ( gamestate > eGameState.Playing )
			graphAlpha = 0.0

		string currentPlaylist = GetCurrentPlaylistName()
		if ( currentPlaylist == "survival_training" || currentPlaylist == "survival_firingrange" )
			graphAlpha = 1.0

		RuiSetFloat( netGraphRui, "graphAlpha", graphAlpha )
	}
}


void function OnGamestatePrematch()
{
	SetDpadMenuHidden()
	WaitingForPlayersOverlay_Destroy()
	Minimap_UpdateMinimapVisibility( GetLocalClientPlayer() )
}


void function SetDpadMenuVisible()
{
	Assert( IsValid(file.dpadMenuRui) )
	RuiSetBool( file.dpadMenuRui, "isVisible", GetHudDefaultVisibility() )
}


void function SetDpadMenuHidden()
{
	Assert( IsValid(file.dpadMenuRui) )
	RuiSetBool( file.dpadMenuRui, "isVisible", false )
}


void function Survival_ClearHints()
{
	UpdateHealHint( GetLocalViewPlayer() )
}


void function ServerCallback_PlayerBootsOnGround()
{
	NotifyDropSequence( false )

	Signal( GetLocalClientPlayer(), "DroppodLanded" )

	array<entity> keysToClear
	foreach ( topo in file.minimapTopos )
	{
		if ( topo != file.mapTopo )
		{
			entity ent = GetClientEntFromTopo( topo )
			ent.Signal( "OnDestroy" )
			RuiTopology_Destroy( topo )
			keysToClear.append( ent )
		}
	}
	foreach ( ent in keysToClear )
	{
		delete file.minimapTopoClientEnt[ ent ]
		ent.Destroy()
	}
	file.minimapTopos.clear()
	file.minimapTopos.append( file.mapTopo )

	DoF_LerpFarDepthToDefault( 0.5 )
	DoF_LerpNearDepthToDefault( 0.5 )
	SetConVarFloat( "dof_variable_blur", 0.0 )
}


void function ServerCallback_AnnounceCircleClosing()
{
	if ( !CircleAnnouncementsEnabled() )
		return

	float duration            = 4.0
	string circleClosingSound = "survival_circle_close_alarm_02"
                                                
		if ( IsFallLTM() || IsShadowRoyaleMode() )
			circleClosingSound = "survival_circle_close_alarm_02_ss"
       

	AnnouncementData announcement = Announcement_Create( Localize( "#SURVIVAL_CIRCLE_STARTING" ) )
	Announcement_SetSoundAlias( announcement, circleClosingSound )
	Announcement_SetStyle( announcement, ANNOUNCEMENT_STYLE_CIRCLE_WARNING )
	Announcement_SetPurge( announcement, true )
	Announcement_SetOptionalTextArgsArray( announcement, [ "true" ] )
	Announcement_SetPriority( announcement, 200 ) //
	announcement.duration = duration
	AnnouncementFromClass( GetLocalViewPlayer(), announcement )
}


void function Sur_OnBleedoutStarted( entity victim, float endTime )
{
	if ( victim != GetLocalViewPlayer() )
		return

	RuiSetGameTime( file.pilotRui, "bleedoutEndTime", endTime )
	RuiSetBool( file.pilotRui, "isDowned", true )

	if ( victim == GetLocalClientPlayer() )
		RunUIScript( "TryCloseSurvivalInventory", null )
}


void function Sur_OnBleedoutEnded( entity victim )
{
	if ( victim != GetLocalViewPlayer() )
		return

	RuiSetGameTime( file.pilotRui, "bleedoutEndTime", 0.0 )
	RuiSetBool( file.pilotRui, "isDowned", false )
}


void function SURVIVAL_AddMinimapLevelLabel( string name, float x, float y, float scale = 1.0, float width = 200, bool overrideLabelDisable = false )
{
	if ( GetCurrentPlaylistVarBool( "disable_minimap_labels", false ) && !overrideLabelDisable )
		return

	MinimapLabelStruct s
	s.name = name
	s.pos = <x, y, 0>
	s.scale = scale
	s.width = width
	file.minimapLabels.append( s )
}


bool function DontCreateRuisForEnemies( entity ent )
{
	if ( ent.IsPlayer() || ent.IsNPC() )
	{
		if ( IsPVEMode() && !IsSingleTeamMode() )
		{
			if ( ent.IsPlayer() && IsFriendlyTeam( ent.GetTeam(), GetLocalViewPlayer().GetTeam() ) )
			{
				return true
			}
			else
			{
				return false
			}
		}

		if ( DoesModeDisplayIconsForAllFriendlyTeams( GameRules_GetGameMode() ) )
		{
			if ( IsFriendlyTeam( ent.GetTeam(), GetLocalViewPlayer().GetTeam() ) )
				return true
		}

		if ( ent.GetTeam() != GetLocalViewPlayer().GetTeam() && GetLocalViewPlayer().GetTeam() != TEAM_SPECTATOR ) //
		{
			return false
		}
	}

	return true
}


void function MarkDpadAsBlocked( bool isBlocked )
{
	if ( file.dpadMenuRui != null )
		RuiSetBool( file.dpadMenuRui, "dpadNotAvailable", isBlocked )
}


void function OnTrackTitanTeam( entity titan )
{
	thread OnTrackTitanTeamInternal( titan )
}


void function OnTrackTitanTeamInternal( entity titan )
{
	titan.SetDoDestroyCallback( true )

	EndSignal( titan, "OnDestroy" )

	int team = titan.GetTeam()

	while ( IsValid( titan ) )
	{
		if ( team != titan.GetTeam() )
		{
			team = titan.GetTeam()
			Signal( titan, "SettingsChanged" )
		}
		wait 0.5
	}
}


entity function GetClientEntFromTopo( var screen )
{
	entity entToReturn
	foreach ( ent, topo in file.minimapTopoClientEnt )
	{
		if ( topo == screen )
		{
			entToReturn = ent
		}
	}

	return entToReturn
}


var function FullMap_CommonAdd( asset ruiAsset, int zOrder = 50 )
{
	if ( !file.mapTopo )
		return null
	var rui = RuiCreate( ruiAsset, file.mapTopo, FULLMAP_RUI_DRAW_LAYER, FULLMAP_Z_BASE + zOrder )

	RuiSetFloat3( rui, "mapCorner", <file.mapCornerX, file.mapCornerY, 0> )
	RuiSetFloat( rui, "mapScale", file.mapScale )
	RuiTrackFloat2( rui, "zoomPos", null, RUI_TRACK_BIG_MAP_ZOOM_ANCHOR )
	RuiTrackFloat( rui, "zoomFactor", null, RUI_TRACK_BIG_MAP_ZOOM_SCALE )

	if ( ruiAsset == FULLMAP_OBJECT_RUI )
	{
		RuiSetBool( rui, "hudVersion", true )
	}

	return rui
}


void function FullMap_CommonTrackEntOrigin( var rui, entity ent, bool doTrackAngles )
{
	RuiTrackFloat3( rui, "objectPos", ent, RUI_TRACK_ABSORIGIN_FOLLOW )
	if ( doTrackAngles )
		RuiTrackFloat3( rui, "objectAngles", ent, RUI_TRACK_EYEANGLES_FOLLOW )
}


var function FullMap_Ping_( float radius, vector color, float pulseDuration, float lifeTime, bool reverse, asset customRing = $"" )
{
	var rui = FullMap_CommonAdd( $"ui/in_world_minimap_ping.rpak" )

	RuiSetFloat3( rui, "objColor", SrgbToLinear( color ) )
	RuiSetFloat( rui, "objectRadius", max( radius, 1000 ) )
	RuiSetGameTime( rui, "startTime", Time() )
	RuiSetFloat( rui, "pulseDuration", pulseDuration )
	RuiSetBool( rui, "reverse", reverse )
	RuiSetImage( rui, "marker", $"" )

	if ( customRing != "" )
		RuiSetImage( rui, "pulse", customRing )

	Fullmap_AddRui( rui )

	if ( lifeTime > 0 )
	{
		RuiSetFloat( rui, "lifeTime", lifeTime )
		delaythread( lifeTime - (1 / 60.0) ) Fullmap_RemoveRui( rui )
	}

	return rui
}


var function FullMap_AddEnemyLocation( entity enemy )
{
	var rui = FullMap_CommonAdd( $"ui/in_world_minimap_square_simple.rpak" )

	RuiSetFloat3( rui, "objectPos", enemy.GetOrigin() )
	RuiSetFloat3( rui, "objectAngles", ( enemy.GetAngles() + <0, -90, 0> ) )
	RuiSetFloat3( rui, "objColor", GetKeyColor( COLORID_MINIMAP_ENEMY_REF ) * ( 1.0 / 255.0 ) )
	RuiSetFloat( rui, "objectSize", 5.0 )
	RuiSetBool( rui, "doAnnounceEffect", true )
	RuiSetImage( rui, "iconImage", $"rui/hud/minimap/compass_icon_player" )

	Fullmap_AddRui( rui )
	return rui
}

var function FullMap_AddCryptoRingPulse( vector pulseOrg )
{
	var rui = FullMap_CommonAdd( $"ui/in_world_crypto_tt_map_pulse.rpak" )

	RuiSetFloat3( rui, "objectPos", pulseOrg )
	RuiSetFloat3( rui, "ellipseColor", < 131.0/255.0, 216.0/255.0, 255.0/255.0 > )
	RuiSetFloat( rui, "objectSize", 20.0 )
	RuiSetBool( rui, "scaleWithZoom", true )
	RuiSetImage( rui, "iconImage", $"rui/events/s05_CryptoTT/crypto_tt_map_ring_main" )

	Fullmap_AddRui( rui )

	return rui
}

void function FullMap_PlayCryptoPulseSequence( vector pulseOrigin, bool tintMap, float tintDuration )
{
	thread Fullmap_PlayCryptoPulseSequence_Thread( pulseOrigin, tintMap, tintDuration )
}

void function Fullmap_PlayCryptoPulseSequence_Thread( vector pulseOrigin, bool tintMap, float tintDuration )
{
	if ( tintMap )
	{
		Fullmap_SetTintParams( Time(), tintDuration, GetKeyColor( COLORID_MINMAP_CRYPTO_PULSE_TINT ) )
		Minimap_SetTintParams( Time(), tintDuration, GetKeyColor( COLORID_MINMAP_CRYPTO_PULSE_TINT ) )
	}

	wait 0.5
	var pulseRui = FullMap_AddCryptoRingPulse( pulseOrigin )
	var minimapPulseRui = Minimap_AddCryptoPulseToMinimap( pulseOrigin )
	RuiSetGameTime( pulseRui, "pulseSequenceEndTime", Time() + ( tintDuration - 1 ) )
	RuiSetGameTime( minimapPulseRui, "pulseSequenceEndTime", Time() + ( tintDuration - 1 ) )

	wait tintDuration
	Fullmap_RemoveRui( pulseRui )
	RuiDestroy( pulseRui )
	Minimap_CommonCleanup( minimapPulseRui )
}

var function FullMap_PingLocation( vector origin, float radius, vector color, float pulseDuration, float lifeTime = -1, bool reverse = false, asset altIcon = $"" )
{
	if ( !file.mapTopo )
		return null

	var rui
	if ( altIcon != $"" )
		rui = FullMap_Ping_( radius, color, pulseDuration, lifeTime, reverse, altIcon )
	else
		rui = FullMap_Ping_( radius, color, pulseDuration, lifeTime, reverse )

	RuiSetFloat3( rui, "objectPos", origin )
	RuiSetFloat3( rui, "objectAngles", <0, 0, 0> )
	return rui
}


var function FullMap_PingEntity( entity ent, float radius, vector color, float pulseDuration, float lifeTime = -1, bool reverse = false )
{
	if ( !file.mapTopo )
		return null

	var rui = FullMap_Ping_( radius, color, pulseDuration, lifeTime, reverse )
	FullMap_CommonTrackEntOrigin( rui, ent, false )
	return rui
}


//
//
//
//
//
struct PROTO_LootContainerState
{
	entity container
	bool   isLit = false
	entity light = null
}

bool proto_isContainerThinkRunning = false
array<PROTO_LootContainerState> proto_lootContainerStateList = []
void function PROTO_OnContainerCreated( entity container )
{
	PROTO_LootContainerState state
	state.container = container
	proto_lootContainerStateList.append( state )

	if ( !proto_isContainerThinkRunning )
	{
		thread PROTO_ContainersThink()
	}

	//
}


void function PROTO_ContainersThink()
{
	proto_isContainerThinkRunning = true
	while( true )
	{
		if ( proto_lootContainerStateList.len() == 0 )
		{
			proto_isContainerThinkRunning = false
			return
		}

		entity player = GetLocalViewPlayer()

		array<int> stateIndexesToRemove = []
		foreach ( int stateIndex, PROTO_LootContainerState state in proto_lootContainerStateList )
		{
			if ( !IsValid( state.container ) )
			{
				stateIndexesToRemove.append( stateIndex )
				continue
			}

			float dist           = Distance2D( state.container.GetWorldSpaceCenter(), player.GetWorldSpaceCenter() )
			float fullOnPoint    = 100.0
			float offPoint       = 120.0
			bool shouldBecomeLit = (dist < offPoint)
			//

			if ( shouldBecomeLit )
			{
				if ( !state.isLit )
				{
					state.light = CreateClientSideDynamicLight( state.container.GetWorldSpaceCenter(), <0, 0, 0>, <0, 0, 0>, 0.0 )
					//
					state.isLit = true
				}
			}
			else//
			{
				if ( state.isLit )
				{
					state.light.Destroy()
					state.light = null
					state.isLit = false
				}
			}

			if ( state.isLit )
			{
				vector lightCol  = <0, 1, 1>
				float brightness = GraphCapped( dist, fullOnPoint, offPoint, 1.0, 0.0 )
				state.light.SetLightColor( lightCol * brightness )
				state.light.SetLightRadius( 220.0 )
			}
		}

		for ( int i = stateIndexesToRemove.len() - 1; i >= 0; i-- )
		{
			PROTO_LootContainerState state = proto_lootContainerStateList[ stateIndexesToRemove[i] ]
			if ( state.light != null )
			{
				state.light.Destroy()
			}
			proto_lootContainerStateList.fastremove( stateIndexesToRemove[i] )
		}

		wait 0.1
	}
}


void function ClientCodeCallback_OnTryCycleOrdnance( entity player )
{
	if ( player == GetLocalClientPlayer() && player == GetLocalViewPlayer() && !Fullmap_IsVisible() )
	{
		entity weapon = player.GetActiveWeapon( eActiveInventorySlot.mainHand )

		if ( IsValid( weapon ) && player.GetWeaponDisableFlags() != WEAPON_DISABLE_FLAGS_ALL )
		{
			if ( weapon.GetWeaponType() == WT_ANTITITAN )
			{
				array<string> allOrdnance = SURVIVAL_GetAllPlayerOrdnance( player )

				if ( allOrdnance.len() > 1 || !allOrdnance.contains( weapon.GetWeaponClassName() ) )
				{
					Remote_ServerCallFunction( "ClientCallback_Sur_SwapToNextOrdnance" )
				}
			}
		}
	}
}


void function CrouchPressed( entity player )
{
	if ( !GetCurrentPlaylistVarBool( "survival_autoprompt_taunt_on_crouch_spam", true ) )
		return

	if ( player != GetLocalClientPlayer() || player != GetLocalViewPlayer() )
		return

	if ( IsPlayerInCryptoDroneCameraView( player ) )
		return
                     
	if ( HoverVehicle_IsPlayerInAnyVehicle( player ) )
		return
      
	if ( Time() - file.lastPressedCrouchTime > CROUCH_SPAM_DETECT_TIMEOUT )
		file.crouchSpamCount = 0
	else
		file.crouchSpamCount += 1

	file.lastPressedCrouchTime = Time()

	if ( file.crouchSpamCount == 4 )
	{
		ServerCallback_PromptTaunt()
	}
}


void function ReloadPressed( entity player )
{
	player.Signal( "ReloadPressed" )

	if ( player != GetLocalClientPlayer() || player != GetLocalViewPlayer() )
		return

	int weaponDisableFlags = player.GetWeaponDisableFlags()
	if ( weaponDisableFlags == WEAPON_DISABLE_FLAGS_ALL )
		return

	entity weapon = player.GetActiveWeapon( eActiveInventorySlot.mainHand )

	if ( !IsValid( weapon ) )
		return

	if ( weapon.GetWeaponType() == WT_ANTITITAN )
		return

	if ( weapon.GetWeaponPrimaryClipCountMax() <= 0 || !weapon.GetWeaponSettingBool( eWeaponVar.uses_ammo_pool ) || player.AmmoPool_GetCount( weapon.GetWeaponAmmoPoolType() ) > 0 )
		return

	bool isUsePressed   = player.IsInputCommandPressed( IN_USE )
	entity playerUseEnt = player.GetUseEntity()
	if ( isUsePressed && playerUseEnt != null )
		return

	NotifyReloadAttemptButNoReserveAmmo()
}


void function UsePressed( entity player )
{
	int gamepadUseType = GetConVarInt( "gamepad_use_type" )
	if ( gamepadUseType == eGamepadUseSchemeType.TAP_TO_USE_HOLD_TO_RELOAD && player == GetLocalClientPlayer() && player == GetLocalViewPlayer() )
	{
		if ( !player.HasUsePrompt() )
		{
			entity weapon = player.GetActiveWeapon( eActiveInventorySlot.mainHand )
			if ( IsValid( weapon ) && player.GetWeaponDisableFlags() != WEAPON_DISABLE_FLAGS_ALL )
			{
				if ( !weapon.GetWeaponSettingBool( eWeaponVar.reload_enabled ) )
					return

				if ( weapon.GetWeaponType() == WT_ANTITITAN )
				{
					array<string> allOrdnance = SURVIVAL_GetAllPlayerOrdnance( player )

					if ( allOrdnance.len() > 1 )
					{
						ServerCallback_SurvivalHint( eSurvivalHints.ORDNANCE )
					}
				}
				else if ( IsControllerModeActive() && player.AmmoPool_GetCount( weapon.GetWeaponAmmoPoolType() ) > 0 )
				{
					float lowAmmoFrac = weapon.GetWeaponSettingFloat( eWeaponVar.low_ammo_fraction )

					float weaponClipMax = float( weapon.GetWeaponPrimaryClipCountMax() )
					float currClipCount = float( weapon.GetWeaponPrimaryClipCount() )
					float ammoFrac      = currClipCount / weaponClipMax

					if ( weaponClipMax > currClipCount && ammoFrac > lowAmmoFrac )
						AddPlayerHint( 2.0, 0.5, $"", "#HINT_RELOAD_TAP_TO_USE" )
				}
			}
		}
	}
}


void function ShowPlaneTube( entity ent, var topo )
{
	int drawMode = RUI_DRAW_WORLD
	if ( topo == file.mapTopo )
		drawMode = FULLMAP_RUI_DRAW_LAYER

	var rui = RuiCreate( $"ui/in_world_minimap_plane_path.rpak", topo, drawMode, FULLMAP_Z_BASE )
	RuiSetFloat3( rui, "mapCorner", <file.mapCornerX, file.mapCornerY, 0> )
	RuiSetFloat( rui, "mapScale", file.mapScale )
	RuiTrackFloat2( rui, "zoomPos", null, RUI_TRACK_BIG_MAP_ZOOM_ANCHOR )
	RuiTrackFloat( rui, "zoomFactor", null, RUI_TRACK_BIG_MAP_ZOOM_SCALE )
	RuiTrackFloat3( rui, "objectPos", ent, RUI_TRACK_ABSORIGIN_FOLLOW )
	RuiTrackFloat3( rui, "objectAngles", ent, RUI_TRACK_EYEANGLES_FOLLOW )
	RuiSetFloat( rui, "displayDist", max( file.threatMaxDist, 2200 ) )
	RuiSetBool( rui, "hudVersion", topo == file.mapTopo )

	//

	if ( topo == file.mapTopo )
		Fullmap_AddRui( rui )

	OnThreadEnd(
		function () : ( rui, topo )
		{
			if ( topo == file.mapTopo )
				Fullmap_RemoveRui( rui )

			RuiDestroy( rui )
		}
	)

	ent.WaitSignal( "OnDestroy" )
}


void function UpdateFallbackMatchmaking( string fallbackPlaylistName, string fallbackStatusText )
{
	if ( fallbackPlaylistName == "" )
	{
		if ( file.fallbackMMRui != null )
			RuiDestroy( file.fallbackMMRui )

		file.fallbackMMRui = null
		return
	}

	if ( file.fallbackMMRui == null )
	{
		file.fallbackMMRui = RuiCreate( $"ui/fallback_status_text.rpak", clGlobal.topoFullScreen, RUI_DRAW_HUD, 100 )
		RuiSetGameTime( file.fallbackMMRui, "queueStartTime", Time() )
	}

	string playlistName = Localize( GetPlaylistVarString( fallbackPlaylistName, "name", "Undefined: " + fallbackPlaylistName ) )

	RuiSetString( file.fallbackMMRui, "fallbackPlaylistText", playlistName )
	RuiSetString( file.fallbackMMRui, "fallbackStatusText", fallbackStatusText )
}


void function PROTO_ServerCallback_Sur_HoldForUltimate()
{
	AddPlayerHint( 4.0, 0.25, $"", "Hold %offhand4%" )
}

void function SetVictorySequenceEffectPackage( vector position, vector angles, asset effect )
{
	file.victoryEffectData.position = position
	file.victoryEffectData.angles = angles
	file.victoryEffectData.effect = effect

	PrecacheParticleSystem( effect )
}

void function SetVictorySequenceLocation( vector position, vector angles )
{
	file.victorySequencePosition = position
	file.victorySequenceAngles = angles
}


void function SetVictorySequenceSunSkyIntensity( float sunIntensity, float skyIntensity )
{
	file.victorySunIntensity = sunIntensity
	file.victorySkyIntensity = skyIntensity
}


void function ServerCallback_MatchEndAnnouncement( bool victory, int winningTeam )
{
	clGlobal.levelEnt.Signal( "SquadEliminated" )

	DeathScreenCreateNonMenuBlackBars()
	DeathScreenUpdate()
	entity clientPlayer = GetLocalClientPlayer()
	Assert( IsValid( clientPlayer ) )

	bool isPureSpectator = IsSpectating() && clientPlayer.GetTeam() == TEAM_SPECTATOR

	//
	if ( clientPlayer.GetTeam() == winningTeam || IsAlive( clientPlayer ) || isPureSpectator )
		ShowChampionVictoryScreen( winningTeam )
}


void function ShowChampionVictoryScreen( int winningTeam )
{
	if ( file.victoryRui != null )
		return

	//
	HideGladiatorCardSidePane( true )
	UpdateRespawnStatus( eRespawnStatus.NONE )

	bool onWinningTeam
	if ( IsPrivateMatch() )
		onWinningTeam = GetLocalClientPlayer().GetTeam() == winningTeam
	else
		onWinningTeam = GetLocalViewPlayer().GetTeam() == winningTeam

	if ( file.onPreVictoryScreenCallback != null )
	{
		file.onPreVictoryScreenCallback( onWinningTeam )
	}

	asset ruiAsset = GetChampionScreenRuiAsset()
	file.victoryRui = CreateFullscreenRui( ruiAsset )

	RuiSetBool( file.victoryRui, "onWinningTeam", onWinningTeam )
	if ( onWinningTeam )
	{
		if ( GetBugReproNum() == 8675309 )
			RuiSetString( file.victoryRui, "winningClubName", "WWWWWWWWWWWWWWWW" )
		else if ( GetClubPartyBool() == true )
			RuiSetString( file.victoryRui, "winningClubName", Clubs_GetMyStoredClubName() )
	}

	if ( s_championScreenExtraFunc != null )
		s_championScreenExtraFunc( file.victoryRui )

	EmitSoundOnEntity( GetLocalClientPlayer(), GetChampionScreenSound() )

	Chroma_VictoryScreen()
}

string function GetChampionScreenSound()
{
	if ( file.customChampionScreenSound != "" )
		return file.customChampionScreenSound

	return "UI_InGame_ChampionVictory"
}

asset function GetChampionScreenRuiAsset()
{
	if ( file.customChampionScreenRuiAsset != $"" )
		return file.customChampionScreenRuiAsset

	return $"ui/champion_screen.rpak"
}

void functionref( var ) s_championScreenExtraFunc = null
void function SetChampionScreenRuiAssetExtraFunc( void functionref( var ) func )
{
	s_championScreenExtraFunc = func
}


void function SetChampionScreenRuiAsset( asset ruiAsset )
{
	file.customChampionScreenRuiAsset = ruiAsset
}

void function SetChampionScreenSound( string alias )
{
	file.customChampionScreenSound = alias
}

void function SetPreVictoryScreenCallback( void functionref(bool) func )
{
	file.onPreVictoryScreenCallback = func
}

void function ShowSquadSummary()
{
	entity player = GetLocalClientPlayer()
	EndSignal( player, "OnDestroy" )
}


void function ServerCallback_AddWinningSquadData( int index, int eHandle, int kills, int assists, int knockdowns, int damageDealt, int survivalTime, int revivesGiven, int respawnsGiven )
{
	if ( index == -1 )
	{
		file.winnerSquadSummaryData.playerData.clear()
		file.winnerSquadSummaryData.squadPlacement = -1
		return
	}

	SquadSummaryPlayerData data
	data.eHandle = eHandle
	data.kills = kills
	data.assists = assists
	data.knockdowns = knockdowns
	data.damageDealt = damageDealt
	data.survivalTime = survivalTime
	data.revivesGiven = revivesGiven
	data.respawnsGiven = respawnsGiven
	file.winnerSquadSummaryData.playerData.append( data )
	file.winnerSquadSummaryData.squadPlacement = 1
}


SquadSummaryData function GetSquadSummaryData()
{
	return file.squadSummaryData
}


SquadSummaryData function GetWinnerSquadSummaryData()
{
	return file.winnerSquadSummaryData
}

#if(DEV)
void function Dev_ShowVictorySequence()
{
	ServerCallback_AddWinningSquadData( -1, -1, 0, 0, 0, 0, 0, 0, 0 )
	foreach ( int i, entity player in GetPlayerArrayOfTeam( GetLocalClientPlayer().GetTeam() ) )
		ServerCallback_AddWinningSquadData( i, player.GetEncodedEHandle(), 2, 3, 4, 1234, 600, 3, 1 )
	thread ShowVictorySequence( false, true )
}

void function Dev_AdjustVictorySequence()
{
	ServerCallback_AddWinningSquadData( -1, -1, 0, 0, 0, 0, 0, 0, 0 )
	foreach ( int i, entity player in GetPlayerArrayOfTeam( GetLocalClientPlayer().GetTeam() ) )
		ServerCallback_AddWinningSquadData( i, player.GetEncodedEHandle(), 2, 3, 4, 1234, 600, 3, 1 )
	GetLocalClientPlayer().FreezeControlsOnClient()
	thread ShowVictorySequence( true, true )
}

void function Dev_SpoofMatchData()
{
	int i = 0
    entity player = GetLocalClientPlayer()
	ServerCallback_AddWinningSquadData( i, player.GetEncodedEHandle(), 2, 3, 4, 1234, 600, 3, 1 )
}
#endif

void function OnGamestateEpilogue()
{
	if ( IsPVEMode() )
		return

                         
	if ( ShGameModeExplore_IsActive() )
		return
       

	if ( IsShowingVictorySequence() )
		return

	thread ShowVictorySequence()
}

void function SetSquadDataToLocalTeam()
{
	entity player = GetLocalClientPlayer()

	int maxTrackedSquadMembers = PersistenceGetArrayCount( "lastGameSquadStats" )

	#if(DEV)
		printt( "PD: Reading Match Summary Persistet Vars for", player, "and", maxTrackedSquadMembers, "maxTrackedSquadMembers" )
	#endif

	file.squadSummaryData.playerData.clear()
	for ( int i = 0 ; i < maxTrackedSquadMembers ; i++ )
	{
		int eHandle = player.GetPersistentVarAsInt( "lastGameSquadStats[" + i + "].eHandle" )

		#if(DEV)
			printt( "PD: ", i, "eHandle", player.GetPersistentVarAsInt( "lastGameSquadStats[" + i + "].eHandle" ) )
		#endif

		if ( eHandle <= 0 )
			continue

		SquadSummaryPlayerData data

		data.eHandle = eHandle
		data.kills = player.GetPersistentVarAsInt( "lastGameSquadStats[" + i + "].kills" )
		data.assists = player.GetPersistentVarAsInt( "lastGameSquadStats[" + i + "].assists" )
		data.knockdowns = player.GetPersistentVarAsInt( "lastGameSquadStats[" + i + "].knockdowns" )
		data.damageDealt = player.GetPersistentVarAsInt( "lastGameSquadStats[" + i + "].damageDealt" )
		data.survivalTime = player.GetPersistentVarAsInt( "lastGameSquadStats[" + i + "].survivalTime" )
		data.revivesGiven = player.GetPersistentVarAsInt( "lastGameSquadStats[" + i + "].revivesGiven" )
		data.respawnsGiven = player.GetPersistentVarAsInt( "lastGameSquadStats[" + i + "].respawnsGiven" )

		#if(DEV)
			printt( "PD: ", i, "kills", player.GetPersistentVarAsInt( "lastGameSquadStats[" + i + "].kills" ) )
			printt( "PD: ", i, "assists", player.GetPersistentVarAsInt( "lastGameSquadStats[" + i + "].assists" ) )
			printt( "PD: ", i, "knockdowns", player.GetPersistentVarAsInt( "lastGameSquadStats[" + i + "].knockdowns" ) )
			printt( "PD: ", i, "damageDealt", player.GetPersistentVarAsInt( "lastGameSquadStats[" + i + "].damageDealt" ) )
			printt( "PD: ", i, "survivalTime", player.GetPersistentVarAsInt( "lastGameSquadStats[" + i + "].survivalTime" ) )
			printt( "PD: ", i, "revivesGiven", player.GetPersistentVarAsInt( "lastGameSquadStats[" + i + "].revivesGiven" ) )
			printt( "PD: ", i, "respawnsGiven", player.GetPersistentVarAsInt( "lastGameSquadStats[" + i + "].respawnsGiven" ) )
		#endif

		file.squadSummaryData.playerData.append( data )
	}

	file.squadSummaryData.squadPlacement = player.GetPersistentVarAsInt( "lastGameRank" )

	#if(DEV)
		printt( "PD: squadPlacement", player.GetPersistentVarAsInt( "lastGameRank" ) )
	#endif

}


void function VictorySequenceOrderLocalPlayerFirst( entity player )
{
	int playerEHandle   = player.GetEncodedEHandle()
	bool hadLocalPlayer = false
	array<SquadSummaryPlayerData> playerDataArray
	SquadSummaryPlayerData localPlayerData

	foreach ( SquadSummaryPlayerData data in file.winnerSquadSummaryData.playerData )
	{
		if ( data.eHandle == playerEHandle )
		{
			localPlayerData = data
			hadLocalPlayer = true
			continue
		}

		playerDataArray.append( data )
	}

	file.winnerSquadSummaryData.playerData = playerDataArray
	if ( hadLocalPlayer )
		file.winnerSquadSummaryData.playerData.insert( 0, localPlayerData )
}


void function ShowVictorySequence( bool placementMode = false, bool isDevTest = false )
{
	#if(!DEV)
		placementMode = false
	#endif

	entity player 				= GetLocalClientPlayer()
	int playerTeam 				= player.GetTeam()
	int playerEncodedEHandle 	= player.GetEncodedEHandle()

	//

                  
		array<int> offsetArray = [90, 78, 78, 90, 90, 78, 78, 90, 90, 78]
       

	//
	ScreenFade( player, 255, 255, 255, 255, 0.4, 2.0, FFADE_OUT | FFADE_PURGE )

	EmitSoundOnEntity( player, "UI_InGame_ChampionMountain_Whoosh" )

	file.IsShowingVictorySequence = true

	if ( IsSquadDataPersistenceEmpty( player ) && !isDevTest )
		Remote_ServerCallFunction( "ClientCallback_Sur_RequestSquadDataPersistence" )
	wait 0.4

	DeathScreenUpdate()

	if ( IsSpectating() )    //
	{
		//
		SwitchDeathScreenTab( eDeathScreenPanel.SPECTATE )
		EnableDeathScreenTab( eDeathScreenPanel.SQUAD_SUMMARY, false )
		EnableDeathScreenTab( eDeathScreenPanel.DEATH_RECAP, false )
	}

	if ( file.victoryRui != null )
		RuiDestroyIfAlive( file.victoryRui )

	UpdateRespawnStatus( eRespawnStatus.NONE )
	HideGladiatorCardSidePane( true )

	if ( IsValid ( player ) )
	{
		Signal( player, "Bleedout_StopBleedoutEffects" )
		ScreenFade( player, 255, 255, 255, 255, 0.4, 0.0, FFADE_IN | FFADE_PURGE )
	}

	//
	asset defaultModel                = GetGlobalSettingsAsset( DEFAULT_PILOT_SETTINGS, "bodyModel" )
	LoadoutEntry loadoutSlotCharacter = Loadout_Character()
	vector characterAngles            = < file.victorySequenceAngles.x / 2.0, file.victorySequenceAngles.y, file.victorySequenceAngles.z >

	array<entity> cleanupEnts
	array<var> overHeadRuis

	//
	VictoryPlatformModelData victoryPlatformModelData = GetVictorySequencePlatformModel()
	entity platformModel
	int maxPlayersToShow                              = -1
	if ( victoryPlatformModelData.isSet && IsValid ( player ) )
	{
		printf( "VICTORY: Getting platform model" )
		platformModel = CreateClientSidePropDynamic( file.victorySequencePosition + victoryPlatformModelData.originOffset, victoryPlatformModelData.modelAngles, victoryPlatformModelData.modelAsset )
                   
			//
			if ( IsFallLTM() )
			{
				entity platformModel2 = CreateClientSidePropDynamic( PositionOffsetFromEnt( platformModel, -284, 1000, 0 ), victoryPlatformModelData.modelAngles, victoryPlatformModelData.modelAsset )
				entity platformModel3 = CreateClientSidePropDynamic( PositionOffsetFromEnt( platformModel, -284, 0, 0 ), victoryPlatformModelData.modelAngles, victoryPlatformModelData.modelAsset )                    //
				entity platformModel4 = CreateClientSidePropDynamic( PositionOffsetFromEnt( platformModel, -500, 200, 0 ), victoryPlatformModelData.modelAngles, victoryPlatformModelData.modelAsset )
				entity platformModel5 = CreateClientSidePropDynamic( PositionOffsetFromEnt( platformModel, -284, 500, 0 ), victoryPlatformModelData.modelAngles, victoryPlatformModelData.modelAsset )
				entity platformModel6 = CreateClientSidePropDynamic( PositionOffsetFromEnt( platformModel, 0, 500, 0 ), victoryPlatformModelData.modelAngles, victoryPlatformModelData.modelAsset )                    //
				entity platformModel7 = CreateClientSidePropDynamic( PositionOffsetFromEnt( platformModel, 300, 300, 0 ), victoryPlatformModelData.modelAngles, victoryPlatformModelData.modelAsset )
				entity platformModel8 = CreateClientSidePropDynamic( PositionOffsetFromEnt( platformModel, 0, 1000, 0 ), victoryPlatformModelData.modelAngles, victoryPlatformModelData.modelAsset )
				cleanupEnts.append( platformModel2 )
				cleanupEnts.append( platformModel3 )
				cleanupEnts.append( platformModel4 )
				cleanupEnts.append( platformModel5 )
				cleanupEnts.append( platformModel6 )
				cleanupEnts.append( platformModel7 )
				cleanupEnts.append( platformModel8 )
				if ( IsShadowVictory() )
					maxPlayersToShow = 16
			}
           

		cleanupEnts.append( platformModel )
		int playersOnPodium = 0

		//
		if ( file.victoryEffectData.effect != $"" )
		{
			StartParticleEffectInWorld( GetParticleSystemIndex( file.victoryEffectData.effect ), file.victoryEffectData.position, file.victoryEffectData.angles )
		}

		//
		VictorySequenceOrderLocalPlayerFirst( player )

		foreach ( int i, SquadSummaryPlayerData data in file.winnerSquadSummaryData.playerData )
		{
			if ( maxPlayersToShow > 0 && i > maxPlayersToShow )
				break

			string playerName = ""
			if ( EHIHasValidScriptStruct( data.eHandle ) )
				playerName = EHI_GetName( data.eHandle )

			if ( !LoadoutSlot_IsReady( data.eHandle, loadoutSlotCharacter ) )
				continue

			ItemFlavor character = LoadoutSlot_GetItemFlavor( data.eHandle, loadoutSlotCharacter )

			if ( !LoadoutSlot_IsReady( data.eHandle, Loadout_CharacterSkin( character ) ) )
				continue

			ItemFlavor characterSkin = LoadoutSlot_GetItemFlavor( data.eHandle, Loadout_CharacterSkin( character ) )

			vector pos = GetVictorySquadFormationPosition( file.victorySequencePosition, file.victorySequenceAngles, i )

			//
			entity characterNode = CreateScriptRef( pos, characterAngles )
			characterNode.SetParent( platformModel, "", true )
			entity characterModel = CreateClientSidePropDynamic( pos, characterAngles, defaultModel )
			SetForceDrawWhileParented( characterModel, true )
			characterModel.MakeSafeForUIScriptHack()
			CharacterSkin_Apply( characterModel, characterSkin )
			cleanupEnts.append( characterModel )

			data.victoryScreenCharacterModel = characterModel

			#if(DEV)
				if ( GetBugReproNum() == 1111 )
				{
					var topo = CreateRUITopology_Worldspace( OffsetPointRelativeToVector( pos, < 0, -50, 0 >, characterModel.GetForwardVector() ), characterAngles + <0, 180, 0>, 1000, 500 )
					var rui  = RuiCreate( $"ui/dev_blue_screen.rpak", topo, RUI_DRAW_WORLD, 1000 )
					characterModel.Hide()
				}
				else if ( GetBugReproNum() == 2222 )
				{
					if ( i == 0 )
						characterModel.Hide()
				}
			#endif

			//
			foreach ( func in s_callbacks_OnVictoryCharacterModelSpawned )
				func( characterModel, character, data.eHandle )

			//
			characterModel.SetParent( characterNode, "", false )
			string victoryAnim = GetVictorySquadFormationActivity( i, characterModel, data.eHandle )
			characterModel.Anim_Play( victoryAnim )
			characterModel.Anim_EnableUseAnimatedRefAttachmentInsteadOfRootMotion()
                                               
			if ( IsFallLTM() || IsShadowRoyaleMode() )
			{
				//
				float duration    = characterModel.GetSequenceDuration( victoryAnim )
				float initialTime = RandomFloatRange( 0, duration )
				characterModel.Anim_SetInitialTime( initialTime )
			}
         


			#if(DEV)
				if ( GetBugReproNum() == 1111 || GetBugReproNum() == 2222 )
				{
					playersOnPodium++
					continue
				}
			#endif

			//
			bool createOverheadRui = true
                    
				if ( ( IsFallLTM() && IsShadowVictory() ) && ( playerEncodedEHandle != data.eHandle ) )
				{
					createOverheadRui = false
				}
            
			if ( createOverheadRui )
			{
				int offset = 78
                     
					if ( IsFallLTM() )
						offset = offsetArray[i]
          

				entity overheadEnt = CreateClientSidePropDynamic( pos + (AnglesToUp( file.victorySequenceAngles ) * offset), <0, 0, 0>, $"mdl/dev/empty_model.rmdl" )
				overheadEnt.Hide()
				var overheadRui = RuiCreate( $"ui/winning_squad_member_overhead_name.rpak", clGlobal.topoFullScreen, RUI_DRAW_HUD, 0 )
				RuiSetString( overheadRui, "playerName", playerName )
				RuiTrackFloat3( overheadRui, "position", overheadEnt, RUI_TRACK_ABSORIGIN_FOLLOW )
				overHeadRuis.append( overheadRui )
			}

			playersOnPodium++
		}

		//
		VictorySoundPackage victorySoundPackage = GetVictorySoundPackage()
		string dialogueApexChampion
		if ( playerTeam == GetWinningTeam() )
		{
			//
			if ( playersOnPodium > 1 )
				dialogueApexChampion = victorySoundPackage.youAreChampPlural
			else
				dialogueApexChampion = victorySoundPackage.youAreChampSingular
		}
		else
		{
			if ( playersOnPodium > 1 )
				dialogueApexChampion = victorySoundPackage.theyAreChampPlural
			else
				dialogueApexChampion = victorySoundPackage.theyAreChampSingular
		}

                    
		//
		if ( IsMadMaggieHost() )
		{
			bool isFuseInChampSquad = false

			foreach ( int i, SquadSummaryPlayerData data in file.winnerSquadSummaryData.playerData )
			{
				if ( !LoadoutSlot_IsReady( data.eHandle, loadoutSlotCharacter ) )
					continue

				ItemFlavor character = LoadoutSlot_GetItemFlavor( data.eHandle, loadoutSlotCharacter )
				string characterName = ItemFlavor_GetLongName( character )
				if ( characterName == "#character_fuse_NAME" )
				{
					isFuseInChampSquad = true
					break
				}
			}

			if ( playersOnPodium > 1 && isFuseInChampSquad )
			{
				dialogueApexChampion = GetAnyDialogueAliasFromName( PickCommentaryLineFromBucket( eSurvivalCommentaryBucket.VICTORY_APEX_CHAMP_HAS_FUSE ) )
			}
			else if ( player.GetTeam() == GetWinningTeam() )
			{
				//
				if ( playersOnPodium > 1 )
				{
					dialogueApexChampion = GetAnyDialogueAliasFromName( PickCommentaryLineFromBucket( eSurvivalCommentaryBucket.VICTORY_APEX_CHAMP_SQUAD_YOU ) )
				}
				else
				{
					dialogueApexChampion = GetAnyDialogueAliasFromName( PickCommentaryLineFromBucket( eSurvivalCommentaryBucket.VICTORY_APEX_CHAMP_SOLO_YOU ) )
				}
			}
			else
			{
				if ( playersOnPodium > 1 )
				{
					dialogueApexChampion = GetAnyDialogueAliasFromName( PickCommentaryLineFromBucket( eSurvivalCommentaryBucket.VICTORY_APEX_CHAMP_SQUAD ) )
				}
				else
				{
					dialogueApexChampion = GetAnyDialogueAliasFromName( PickCommentaryLineFromBucket( eSurvivalCommentaryBucket.VICTORY_APEX_CHAMP_SOLO ) )
				}
			}
		}
          

		EmitSoundOnEntityAfterDelay( platformModel, dialogueApexChampion, 0.5 )

		//
		VictoryCameraPackage victoryCameraPackage = GetVictoryCameraPackage()

		vector camera_offset_start = victoryCameraPackage.camera_offset_start
		vector camera_offset_end   = victoryCameraPackage.camera_offset_end
		vector camera_focus_offset = victoryCameraPackage.camera_focus_offset
		float camera_fov           = victoryCameraPackage.camera_fov

		vector camera_start_pos = OffsetPointRelativeToVector( file.victorySequencePosition, camera_offset_start, AnglesToForward( file.victorySequenceAngles ) )
		vector camera_end_pos   = OffsetPointRelativeToVector( file.victorySequencePosition, camera_offset_end, AnglesToForward( file.victorySequenceAngles ) )
		vector camera_focus_pos = OffsetPointRelativeToVector( file.victorySequencePosition, camera_focus_offset, AnglesToForward( file.victorySequenceAngles ) )

		vector camera_start_angles = VectorToAngles( camera_focus_pos - camera_start_pos )
		vector camera_end_angles   = VectorToAngles( camera_focus_pos - camera_end_pos )

		entity cameraMover = CreateClientsideScriptMover( $"mdl/dev/empty_model.rmdl", camera_start_pos, camera_start_angles )
		entity camera      = CreateClientSidePointCamera( camera_start_pos, camera_start_angles, camera_fov )
		player.SetMenuCameraEntity( camera )
		camera.SetTargetFOV( camera_fov, true, EASING_CUBIC_INOUT, 0.0 )
		camera.SetParent( cameraMover, "", false )
		cleanupEnts.append( camera )

		//
		GetLightEnvironmentEntity().ScaleSunSkyIntensity( file.victorySunIntensity, file.victorySkyIntensity )

		//
		float camera_move_duration = 6.5
		cameraMover.NonPhysicsMoveTo( camera_end_pos, camera_move_duration, 0.0, camera_move_duration / 2.0 )
		cameraMover.NonPhysicsRotateTo( camera_end_angles, camera_move_duration, 0.0, camera_move_duration / 2.0 )
		cleanupEnts.append( cameraMover )

		wait camera_move_duration - 0.5

		#if(DEV)
			if ( placementMode )
			{
				if ( IsValid( platformModel ) )
					platformModel.SetParent( cameraMover, "", true )

				while( true )
				{
					vector pos        = cameraMover.GetOrigin()
					vector ang        = cameraMover.GetAngles()
					vector flatAngles = FlattenAngles( ang )

					vector forward = AnglesToForward( flatAngles )
					vector right   = AnglesToRight( flatAngles )
					vector up      = <0, 0, 1>

					float moveSpeed = 800.0 + (InputGetAxis( ANALOG_L_TRIGGER ) * 5000.0)
					moveSpeed *= max( 1.0 - InputGetAxis( ANALOG_R_TRIGGER ), 0.05 )

					float rotateSpeed = 2.0 + (InputGetAxis( ANALOG_L_TRIGGER ) * 10.0)
					rotateSpeed *= max( 1.0 - InputGetAxis( ANALOG_R_TRIGGER ), 0.05 )

					if ( InputGetAxis( ANALOG_LEFT_Y ) > 0.15 || InputGetAxis( ANALOG_LEFT_Y ) < -0.15 )
						pos += forward * InputGetAxis( ANALOG_LEFT_Y ) * -moveSpeed
					if ( InputGetAxis( ANALOG_LEFT_X ) > 0.15 || InputGetAxis( ANALOG_LEFT_X ) < -0.15 )
						pos += right * InputGetAxis( ANALOG_LEFT_X ) * moveSpeed
					if ( InputIsButtonDown( BUTTON_STICK_LEFT ) )
						pos += up * moveSpeed * 0.1
					if ( InputIsButtonDown( BUTTON_STICK_RIGHT ) )
						pos -= up * moveSpeed * 0.1

					if ( InputGetAxis( ANALOG_RIGHT_X ) > 0.15 || InputGetAxis( ANALOG_RIGHT_X ) < -0.15 )
					{
						float yaw = ang.y + (InputGetAxis( ANALOG_RIGHT_X ) * -rotateSpeed)
						ang = ClampAngles( < ang.x, yaw, ang.z > )
					}

					cameraMover.NonPhysicsMoveTo( pos, 0.1, 0.0, 0.0 )
					cameraMover.NonPhysicsRotateTo( ang, 0.1, 0.0, 0.0 )

					printt( "SetVictorySequenceLocation(" + (platformModel.GetOrigin() - victoryPlatformModelData.originOffset) + ", " + ClampAngles( < 0, camera.GetAngles().y + 180, 0 > ) + " )" )

					WaitFrame()
				}
			}
		#endif
	}

	if ( IsPrivateMatch() )
	{
		wait 60.0 //
	}

                       
	else if ( WinterExpress_IsModeEnabled() )
	{
		wait 5.0 //
	}
       

	file.IsShowingVictorySequence = false

	#if(DEV)
		if ( IsValid( player ) )
			printt( "PD: IsSquadDataPersistenceEmpty", IsSquadDataPersistenceEmpty( player ) )
	#endif

	if ( playerTeam != TEAM_SPECTATOR )
	{
		if ( IsValid( player ) )
		{
			while ( IsSquadDataPersistenceEmpty( player ) && !isDevTest )
			{
				Remote_ServerCallFunction( "ClientCallback_Sur_RequestSquadDataPersistence" )
				wait 1.0
			}

			SetSquadDataToLocalTeam()
			ShowDeathScreen( eDeathScreenPanel.SQUAD_SUMMARY )
			EnableDeathScreenTab( eDeathScreenPanel.SPECTATE, false )
			EnableDeathScreenTab( eDeathScreenPanel.DEATH_RECAP, !IsAlive( player ) )
			SwitchDeathScreenTab( eDeathScreenPanel.SQUAD_SUMMARY )
		}
		else
		{
			SetSquadDataToLocalTeam()
			ShowDeathScreen( eDeathScreenPanel.SQUAD_SUMMARY )
			EnableDeathScreenTab( eDeathScreenPanel.SPECTATE, false )
			EnableDeathScreenTab( eDeathScreenPanel.DEATH_RECAP, true )
			SwitchDeathScreenTab( eDeathScreenPanel.SQUAD_SUMMARY )
		}

		//
		wait 1.0
	}

	foreach ( rui in overHeadRuis )
		RuiDestroyIfAlive( rui )

	foreach ( entity ent in cleanupEnts )
		ent.Destroy()
}

entity function GetVictoryScreenCharacterModelForEHI( int playerEHI )
{
	if ( !IsShowingVictorySequence() )
		return null

	foreach ( int i, SquadSummaryPlayerData data in file.winnerSquadSummaryData.playerData )
	{
		if ( data.eHandle == playerEHI )
			return data.victoryScreenCharacterModel
	}

	return null
}

bool function IsShowingVictorySequence()
{
	return file.IsShowingVictorySequence
}

void function Survival_SetVictorySoundPackageFunction( VictorySoundPackage functionref() func )
{
	file.victorySoundPackageCallback = func
}

VictorySoundPackage function GetVictorySoundPackage()
{
	VictorySoundPackage victorySoundPackage

	if ( file.victorySoundPackageCallback != null )
		return file.victorySoundPackageCallback()

	victorySoundPackage.youAreChampPlural = "diag_ap_aiNotify_winnerFound_07" //
	victorySoundPackage.youAreChampSingular = "diag_ap_aiNotify_winnerFound_10" //
	victorySoundPackage.theyAreChampPlural = "diag_ap_aiNotify_winnerFound_08" //
	victorySoundPackage.theyAreChampSingular = "diag_ap_ainotify_introchampion_01_02" //

	return victorySoundPackage
}


VictoryCameraPackage function GetVictoryCameraPackage()
{
	VictoryCameraPackage victoryCameraPackage

                  
		if ( IsFallLTM() )
		{
			if ( IsShadowVictory() )
			{
				victoryCameraPackage.camera_offset_start = <0, 725, 100>
				victoryCameraPackage.camera_offset_end = <0, 400, 48>
			}
			else
			{
				victoryCameraPackage.camera_offset_start = <0, 735, 68>
				victoryCameraPackage.camera_offset_end = <0, 625, 48>
			}

			victoryCameraPackage.camera_focus_offset = <0, 0, 36>
			victoryCameraPackage.camera_fov = 35.5

			return victoryCameraPackage
		}
          

	victoryCameraPackage.camera_offset_start = <0, 320, 68>
	victoryCameraPackage.camera_offset_end = <0, 200, 48>
	victoryCameraPackage.camera_focus_offset = <0, 0, 36>
	victoryCameraPackage.camera_fov = 35.5

	return victoryCameraPackage
}


vector function GetVictorySquadFormationPosition( vector mainPosition, vector angles, int index )
{
	if ( index == 0 )
		return mainPosition - <0, 0, 8>

	float offset_side = 48.0
	float offset_back = -28.0

                  
		if ( IsFallLTM() )
		{
			if ( IsShadowVictory() )
			{
				if ( index < 7 )
				{
					offset_side = 48.0
					offset_back = -48.0
				}
				else if ( index == 7 )
					return OffsetPointRelativeToVector( mainPosition, <24, 16, -8>, AnglesToForward( angles ) )
				else if ( index == 8 )
					return OffsetPointRelativeToVector( mainPosition, <48, 16, -8>, AnglesToForward( angles ) )
				else if ( index == 9 )
					return OffsetPointRelativeToVector( mainPosition, <72, 16, -8>, AnglesToForward( angles ) )
				else if ( index == 10 )
					return OffsetPointRelativeToVector( mainPosition, <96, 16, -8>, AnglesToForward( angles ) )
				else if ( index == 11 )
					return OffsetPointRelativeToVector( mainPosition, <120, 16, -8>, AnglesToForward( angles ) )
				else if ( index == 12 )
					return OffsetPointRelativeToVector( mainPosition, <-24, 16, -8>, AnglesToForward( angles ) )
				else if ( index == 13 )
					return OffsetPointRelativeToVector( mainPosition, <-48, 16, -8>, AnglesToForward( angles ) )
				else if ( index == 14 )
					return OffsetPointRelativeToVector( mainPosition, <-96, 16, -8>, AnglesToForward( angles ) )
				else if ( index == 15 )
					return OffsetPointRelativeToVector( mainPosition, <-120, 16, -8>, AnglesToForward( angles ) )
				else if ( index == 16 )
					return OffsetPointRelativeToVector( mainPosition, <12, 32, -8>, AnglesToForward( angles ) )
			}
			else
			{
				if ( index > 2 )
				{
					//
					offset_side = 56.0
					offset_back = -28.0
				}
			}
		}

          

	int countBack = (index + 1) / 2
	vector offset = < offset_side, offset_back, 0 > * countBack

	if ( index % 2 == 0 )
		offset.x *= -1

	vector point = OffsetPointRelativeToVector( mainPosition, offset, AnglesToForward( angles ) )
	return point - <0, 0, 8>
}


string function GetVictorySquadFormationActivity( int index, entity characterModel, int eHandle )
{
                                                
		entity playerEnt = GetEntityFromEncodedEHandle( eHandle )
		if ( ( IsFallLTM() && IsShadowVictory() ) || ( IsShadowRoyaleMode() && IsPlayerShadowZombie( playerEnt ) ) )
		{
			bool animExists = characterModel.LookupSequence( "ACT_VICTORY_DANCE" ) != -1
			if ( animExists )
				return "ACT_VICTORY_DANCE"
			else
			{
				Assert( characterModel.LookupSequence( "ACT_MP_MENU_LOBBY_SELECT_IDLE" ) != -1, "Unable to find victory idle for " + characterModel )
				return "ACT_MP_MENU_LOBBY_SELECT_IDLE"
			}
		}

          

	return "ACT_MP_MENU_LOBBY_SELECT_IDLE"
	/*







*/
}


bool function HealthkitWheelToggleEnabled()
{
	return false
}


bool function HealthkitWheelUseOnRelease()
{
	return false && !HealthkitUseOnHold()
}


bool function HealthkitUseOnHold()
{
	return false && !HealthkitWheelToggleEnabled()
}


void function HealthkitButton_Down( entity player )
{
	if ( !CommsMenu_CanUseMenu( player ) )
		return

                   
                         
         
          

	if ( !IsFiringRangeGameMode() )
	{
		int ms = PlayerMatchState_GetFor( player )
		if ( ms < ePlayerMatchState.NORMAL )
			return
	}

	if ( player.ContextAction_IsInVehicle() )
	{
                                        
                                                                                   
   
     
   
      
      
		{
			return
		}
	}

	CommsMenu_OpenMenuTo( player, eChatPage.INVENTORY_HEALTH, eCommsMenuStyle.INVENTORY_HEALTH_MENU, false )
}


void function HealthkitButton_Up( entity player )
{
	if ( !IsCommsMenuActive() )
		return

	if ( CommsMenu_GetCurrentCommsMenu() != eCommsMenuStyle.INVENTORY_HEALTH_MENU )
		return

	if ( HealthkitWheelToggleEnabled() )
		return

	if ( CommsMenu_HasValidSelection() )
		CommsMenu_ExecuteSelection( eWheelInputType.NONE )

	CommsMenu_Shutdown( true )
}


bool function OrdnanceWheelToggleEnabled()
{
	return false
}


bool function OrdnanceWheelUseOnRelease()
{
	return true && !OrdnanceUseOnHold()
}


bool function OrdnanceUseOnHold()
{
	return false && !OrdnanceWheelToggleEnabled()
}


void function OrdnanceMenu_Down( entity player )
{
	if ( !SURVIVAL_PlayerCanSwitchOrdnance( player ) )
		return

                   
                         
         
          

	if ( !CommsMenu_CanUseMenu( player ) )
		return

	if ( Bleedout_IsBleedingOut( player ) )
		return

	CommsMenu_OpenMenuTo( player, eChatPage.ORDNANCE_LIST, eCommsMenuStyle.ORDNANCE_MENU, false )
}


void function OrdnanceMenu_Up( entity player )
{
	if ( !IsCommsMenuActive() )
		return
	if ( CommsMenu_GetCurrentCommsMenu() != eCommsMenuStyle.ORDNANCE_MENU )
		return

	if ( CommsMenu_HasValidSelection() )
		CommsMenu_ExecuteSelection( eWheelInputType.NONE )

	CommsMenu_Shutdown( true )
}


                   
void function GadgetSlot_Down( entity player )
{
	if ( !SURVIVAL_PlayerCanSwitchOrdnance( player ) )
		return

                   
                         
         
          

	if ( Bleedout_IsBleedingOut( player ) )
		return

	string equipRef = EquipmentSlot_GetLootRefForSlot( player, "gadgetslot" )
	if ( equipRef == "" )
		return
	else
	{
		if( SURVIVAL_Loot_GetLootDataByRef( equipRef ).lootType == eLootType.GADGET )
		{
			Remote_ServerCallFunction( "ClientCallback_Sur_EquipGadget", equipRef )
		}
	}
}
      

const float MINIMAP_SCALE_SPECTATE = 1.0
void function OnFirstPersonSpectateStarted( entity player, entity currentTarget )
{
	if ( !Flag( "SquadEliminated" ) )
		StopLocal1PDeathSound()

	if ( IsValid( currentTarget ) && currentTarget.IsPlayer() )
		thread InitSurvivalHealthBar()

	Minimap_SetSizeScale( MINIMAP_SCALE_SPECTATE )
}


void function OnSpectatorTargetChanged( entity player, entity previousTarget, entity currentTarget )
{
	if ( IsValid( currentTarget ) && currentTarget.IsPlayer() )
	{
		thread InitSurvivalHealthBar()
		ScorebarInitTracking( currentTarget, ClGameState_GetRui() )
	}

	file.updatePlayerTags = true
}

void function OnSpectatorTagModeChanged( entity player, int newMode )
{
	file.playerTagMode = newMode
	file.updatePlayerTags = true
}

void function OnViewPlayerChanged( entity newViewPlayer )
{
	if ( IsValid( newViewPlayer ) && newViewPlayer.IsPlayer() )
	{
		bool isReady = ToEHI( newViewPlayer ) != EHI_null && IsLocalClientEHIValid();
		if ( isReady )
		{
			thread InitSurvivalHealthBar()
			ScorebarInitTracking( newViewPlayer, ClGameState_GetRui() )
		}
	}
}


void function OnLocalPlayerSpawned( entity localPlayer )
{
	thread InitSurvivalHealthBar()
	ScorebarInitTracking( localPlayer, ClGameState_GetRui() )

	Minimap_SetSizeScale( 1.0 )
}


void function OnPlayerMatchStateChanged( entity player, int oldState, int newState )
{
	switch ( newState )
	{
		case ePlayerMatchState.SKYDIVE_PRELAUNCH:
		case ePlayerMatchState.SKYDIVE_FALLING:
			Minimap_SetSizeScale( MINIMAP_SCALE_SPECTATE )
			break

		case ePlayerMatchState.NORMAL:
		case ePlayerMatchState.STAGING_AREA:
			Minimap_SetSizeScale( 1.0 )
			break
	}

	UpdateIsSonyMP()
	Chroma_UpdateBackground()
}


void function UICallback_UpdateCharacterDetailsPanel( var ruiPanel )
{
	var rui              = Hud_GetRui( ruiPanel )
	ItemFlavor character = LoadoutSlot_GetItemFlavor( ToEHI( GetLocalClientPlayer() ), Loadout_Character() )
	UpdateCharacterDetailsMenu( rui, character, true )
}


void function UICallback_OpenCharacterSelectNewMenu()
{
	entity player = GetLocalClientPlayer()
	if ( IsAlive( player ) && player.ContextAction_IsMeleeExecution() )
		return

	if ( (GetGameState() < eGameState.PickLoadout && !IsSurvivalTraining()) || GetCurrentPlaylistVarBool( "character_reselect_enabled", false ) )
	{
		OpenCharacterSelectNewMenu( true )
	}
}


void function UICallback_QueryPlayerCanBeRespawned()
{
	entity player             = GetLocalClientPlayer()
	bool playerCanBeRespawned = (PlayerIsMarkedAsCanBeRespawned( player ) && (GetGameState() == eGameState.Playing))

	bool penaltyMayBeActive
	if ( IsRankedGame() )
	{
		penaltyMayBeActive = Ranked_IsPlayerAbandoning( player ) //
	}
                        
                                  
   
                                                                 
   
       
	else
	{
		if ( !GetCurrentPlaylistVarBool( "survival_abandonment_enable", true ) ) //
		{
			penaltyMayBeActive = false
		}
		else
		{
			penaltyMayBeActive = PlayerMatchState_GetFor( GetLocalClientPlayer() ) < ePlayerMatchState.NORMAL
			penaltyMayBeActive = penaltyMayBeActive && GetPlayerArrayOfTeam( player.GetTeam() ).len() == 3
		}
	}

	RunUIScript( "ConfirmLeaveMatchDialog_SetPlayerCanBeRespawned", playerCanBeRespawned, penaltyMayBeActive )
}


void function UICallback_DieAndChangeCharacters()
{
	entity player = GetLocalClientPlayer()

                         
                                
   
     
                                                                 
    
                                 
          
    

     
                                                                         
   
       
}


void function ServerCallback_PromptTaunt()
{
	int selectedIndex = -1

	EHI playerEHI        = LocalClientEHI()
	ItemFlavor character = LoadoutSlot_GetItemFlavor( playerEHI, Loadout_Character() )
	array<ItemFlavor> options
	table<ItemFlavor, int> optionToIndex

	entity localPlayer = FromEHI( playerEHI )
	if ( IsValid( localPlayer ) && !CanPlayerSpeak( localPlayer ) )
		return

	for ( int i = 0; i < MAX_QUIPS_EQUIPPED; i++ )
	{
		LoadoutEntry entry = Loadout_CharacterQuip( character, i )
		ItemFlavor quip    = LoadoutSlot_GetItemFlavor( playerEHI, entry )
		if ( !CharacterQuip_IsTheEmpty( quip ) )
		{
			options.append( quip )
			optionToIndex[ quip ] <- i
		}
	}

	string promptString = "#PING_SAY_CELEBRATE"

	if ( options.len() > 0 )
	{
		ItemFlavor flav = options.getrandom()

              
                                                                
   
                                            

                                                                        
          

                                             
   
      

		if ( ItemFlavor_GetType( flav ) == eItemType.emote_icon )
		{
			promptString = "#PING_SAY_CELEBRATE_HOLO"
		}

		selectedIndex = optionToIndex[ flav ]
	}

	AddOnscreenPromptFunction( "quickchat",
		void function( entity player ) : ( selectedIndex, promptString )
		{
			if ( selectedIndex == -1 )
				Quickchat( player, eCommsAction.QUICKCHAT_CELEBRATE, null )
			else
				PerformQuipAtSlot( selectedIndex )
		},
		6.0, Localize( promptString ) )
}


void function ServerCallback_PromptSayThanks( entity playerBeingAddressed )
{
	if ( ShouldMuteCommsActionForCooldown( GetLocalViewPlayer(), eCommsAction.REPLY_THANKS, null ) )
		return

	AddOnscreenPromptFunction( "quickchat", CreateQuickchatFunction( eCommsAction.REPLY_THANKS, playerBeingAddressed ), 6.0, Localize( "#PING_SAY_THANKS", playerBeingAddressed.GetPlayerName() ) )
}

void function ServerCallback_PromptSayThanksRevive( entity playerBeingAddressed )
{
	if ( ShouldMuteCommsActionForCooldown( GetLocalViewPlayer(), eCommsAction.REPLY_THANKS, null ) )
		return

	AddOnscreenPromptFunction( "quickchat", CreateQuickchatFunction( eCommsAction.REPLY_REVIVE_THANKS, playerBeingAddressed ), 6.0, Localize( "#PING_SAY_THANKS", playerBeingAddressed.GetPlayerName() ) )
}


void function ServerCallback_PromptSayGetOnTheDropship()
{
	AddOnscreenPromptFunction( "quickchat", CreateQuickchatFunction( eCommsAction.QUICKCHAT_GET_ON_THE_DROPSHIP, null ), 6.0, Localize( "#PING_SAY_GETONDROPSHIP" ) )
}

                            
void function ServerCallback_PromptMarkMyLastDeathbox()
{
	AddOnscreenPromptFunction( "quickchat",  CreateQuickchatFunction ( eCommsAction.MARK_MY_LAST_DEATHBOX, null ), 6.0, Localize( "#PROMPT_MARK_MY_LAST_DEATHBOX" ) )
}
      

void functionref(entity) function CreateQuickchatFunction( int commsAction, entity playerBeingAddressed )
{
	return void function( entity player ) : ( playerBeingAddressed, commsAction )
	{
		Quickchat( player, commsAction, playerBeingAddressed )
	}
}


bool function CanReportPlayer( entity target )
{
	int reportStyle = GetReportStyle()

	if ( !IsValid( target ) )
		return false

	if ( !target.IsPlayer() )
		return false

	#if(CONSOLE_PROG)
		reportStyle = minint( reportStyle, 1 )
	#endif

	switch ( reportStyle )
	{
		case 0: //
			return false

		case 1: //
			//
			return CrossplayUserOptIn() ? true : target.GetUnspoofedHardware() == GetLocalClientPlayer().GetUnspoofedHardware()
		case 2: //
			break

		default:
			return false
	}

	return true
}


void function OnPlayerKilled( entity player )
{
	entity viewPlayer = GetLocalViewPlayer()
	if ( player.GetTeam() == viewPlayer.GetTeam() && player != viewPlayer )
	{
		EmitSoundOnEntity( viewPlayer, SOUND_UI_TEAMMATE_KILLED )
	}
}


void function UpdateInventoryCounter( entity player, string ref, bool isFull = false )
{
	var rui = file.inventoryCountRui

	RuiSetGameTime( rui, "startTime", Time() )
	RuiSetFloat2( rui, "offset", <0.0, 0.18, 0.0> )
	RuiSetInt( rui, "maxCount", SURVIVAL_GetInventoryLimit( player ) )
	RuiSetInt( rui, "currentCount", SURVIVAL_GetInventoryCount( player ) )
	RuiSetInt( rui, "highlightCount", 0 ) //
	RuiSetBool( rui, "isFull", isFull )
}


void function TryUpdateInventoryCounter( entity player, LootData data, int lootAction )
{
	if ( data.inventorySlotCount <= 0 )
		return

	if ( lootAction == eLootAction.PICKUP || lootAction == eLootAction.PICKUP_ALL || data.lootType == eLootType.BACKPACK )
		UpdateInventoryCounter( player, data.ref )
}


void function PlayerHudSetWeaponInspect( bool inspect )
{
	RuiSetBool( file.pilotRui, "weaponInspect", inspect )
	RuiSetBool( file.dpadMenuRui, "weaponInspect", inspect )
}


void function ServerCallback_NessyMessage( int state )
{
	if ( state == 0 )
		Obituary_Print_Localized( Localize( "#NESSY_APPEARS" ) )
	if ( state == 1 )
		Obituary_Print_Localized( Localize( "#NESSY_SURFACES" ) )
}


void function ServerCallback_RefreshInventoryAndWeaponInfo()
{
	ServerCallback_RefreshInventory()
	ClWeaponStatus_RefreshWeaponInfo()
	UpdateDpadHud( GetLocalViewPlayer() )
}


void function UIToClient_ToggleMute()
{
	ToggleSquadMute()
}


void function ToggleSquadMute()
{
	SetSquadMuteState( !file.isSquadMuted )
}


void function SetSquadMuteState( bool isSquadMuted )
{
	file.isSquadMuted = isSquadMuted
	foreach ( player in GetPlayerArrayOfTeam( GetLocalClientPlayer().GetTeam() ) )
	{
		if ( player == GetLocalClientPlayer() )
			continue

		if ( player.IsTextMuted() != isSquadMuted )
		{
			TogglePlayerTextMute( player )
		}

		if ( player.IsVoiceMuted() != isSquadMuted )
		{
			TogglePlayerVoiceMute( player )
		}
	}

	foreach ( cb in file.squadMuteChangeCallbacks )
		cb()
}


bool function IsSquadMuted()
{
	return file.isSquadMuted
}


bool function SquadMuteIntroEnabled()
{
	return GetCurrentPlaylistVarBool( "squad_mute_intro_enable", true )
}


void function AddCallback_OnSquadMuteChanged( void functionref() cb )
{
	file.squadMuteChangeCallbacks.append( cb )
}


void function OnSquadMuteChanged()
{
	UpdateWaitingForPlayersMuteHint()
}


void function ServerCallback_RefreshDeathBoxHighlight()
{
	array<entity> boxes = GetAllDeathBoxes()
	ArrayRemoveInvalid( boxes )
	foreach ( box in boxes )
	{
		ManageHighlightEntity( box )
	}
}

//
                     
const string magAttachmentName = "mag"
void function ServerCallback_AutoReloadComplete( entity weapon )
{
	if ( !IsValid( weapon ) )
		return

	if ( file.pilotRui == null )
		return

	//
	string mod = GetInstalledWeaponAttachmentForPoint( weapon, magAttachmentName )
	LootData magData = SURVIVAL_Loot_GetLootDataByRef( mod )

	//
	LootData weaponData = SURVIVAL_GetLootDataFromWeapon( weapon )
	asset ammoIcon = SURVIVAL_Loot_IsRefValid( weaponData.ammoType ) ?
		SURVIVAL_Loot_GetLootDataByRef( weaponData.ammoType ).hudIcon :
		weaponData.fakeAmmoIcon

	var rui = ClWeaponStatus_GetWeaponHudRui( GetLocalViewPlayer() )
	if(rui != null)
	{
		RuiSetString( rui, "passiveDesc", Localize( "#RELOADED" ).toupper() )
		RuiSetImage( rui, "passiveMagIcon", magData.hudIcon )
		RuiSetImage( rui, "passiveIcon", weapon.GetWeaponSettingAsset( eWeaponVar.hud_icon ) )
		RuiSetImage( rui, "passiveAmmoIcon", ammoIcon )
		RuiSetInt( rui, "passiveTier", magData.tier )
		RuiSetInt( rui, "passiveAltTier", weaponData.tier )
		RuiSetBool( rui, "displayPassiveBonusPopup", true )
		RuiSetGameTime( rui, "passiveActivationTime", Time() )
	}

}
      
//

bool function CircleAnnouncementsEnabled()
{
	return file.circleAnnouncementsEnabled
}


void function CircleAnnouncementsEnable( bool state )
{
	file.circleAnnouncementsEnabled = state
}

bool function CircleBannerAnnouncementsEnabled()
{
	return file.circleBannerAnnouncementsEnabled
}

void function CircleBannerAnnouncementsEnable( bool state )
{
	file.circleBannerAnnouncementsEnabled = state
}

void function AddCallback_ShouldRunCharacterSelection( bool functionref() func )
{
	file.shouldRunCharacterSelectionCallback = func
}

                      
void function EvolvingArmor_SetEvolutionRuiAnimTime()
{
	if ( file.pilotRui == null )
		return

	RuiSetGameTime( file.pilotRui, "evolvingArmorUpgradeStartTime", Time() )
}
         

void function OnSettingsUpdated()
{

}
                          
void function ShowTeamNameInHud()
{
	if ( GetLocalClientPlayer().GetTeam() != TEAM_SPECTATOR )
		return

	RuiSetString( file.pilotRui, "teamNameString", GameRules_GetTeamName( GetLocalViewPlayer().GetTeam() ) )
	RuiSetBool( file.pilotRui, "shouldShowTeamName", true )
}

void function HideTeamNameInHud()
{
	RuiSetBool( file.pilotRui, "shouldShowTeamName", false )
}
         

var function GetCompassRui()
{
	return file.compassRui
}

void function ServerCallback_AnnounceDevRespawn()
{
#if(DEV)
	AnnouncementMessageSweep( GetLocalViewPlayer(), "Dev Respawn" )
#endif
}
