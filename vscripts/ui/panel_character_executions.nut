global function InitCharacterExecutionsPanel

struct
{
	var                    panel
	var                    headerRui
	var                    listPanel
	array<ItemFlavor>      characterExecutionList

	var   videoRui
	int   videoChannel = -1
	asset currentVideo = $""
} file

void function InitCharacterExecutionsPanel( var panel )
{
	file.panel = panel
	file.listPanel = Hud_GetChild( panel, "CharacterExecutionList" )
	file.headerRui = Hud_GetRui( Hud_GetChild( panel, "Header" ) )
	file.videoRui = Hud_GetRui( Hud_GetChild( panel, "Video" ) )

	SetPanelTabTitle( panel, "#FINISHER" )
	RuiSetString( file.headerRui, "title", Localize( "#OWNED" ).toupper() )

	AddPanelEventHandler( panel, eUIEvent.PANEL_SHOW, CharacterExecutionsPanel_OnShow )
	AddPanelEventHandler( panel, eUIEvent.PANEL_HIDE, CharacterExecutionsPanel_OnHide )
	AddPanelEventHandler_FocusChanged( panel, CharacterExecutionsPanel_OnFocusChanged )

	AddPanelFooterOption( panel, LEFT, BUTTON_B, true, "#B_BUTTON_BACK", "#B_BUTTON_BACK" )
	AddPanelFooterOption( panel, LEFT, BUTTON_A, false, "#A_BUTTON_SELECT", "", null, CustomizeMenus_IsFocusedItem )
	AddPanelFooterOption( panel, LEFT, BUTTON_X, false, "#X_BUTTON_UNLOCK_LEGEND", "#X_BUTTON_UNLOCK_LEGEND", null, CustomizeMenus_IsFocusedItemParentItemLocked )
	AddPanelFooterOption( panel, LEFT, BUTTON_X, false, "#X_BUTTON_EQUIP", "#X_BUTTON_EQUIP", null, CustomizeMenus_IsFocusedItemEquippable )
	AddPanelFooterOption( panel, LEFT, BUTTON_X, false, "#X_BUTTON_UNLOCK", "#X_BUTTON_UNLOCK", null, CustomizeMenus_IsFocusedItemLocked )
	//
	//
	//
	//

	file.videoChannel = ReserveVideoChannel()
	RuiSetInt( file.videoRui, "channel", file.videoChannel )
}


void function CharacterExecutionsPanel_OnShow( var panel )
{
	AddCallback_OnTopLevelCustomizeContextChanged( panel, CharacterExecutionsPanel_Update )
	CharacterExecutionsPanel_Update( panel )

	UI_SetPresentationType( ePresentationType.CHARACTER_CARD )
}


void function CharacterExecutionsPanel_OnHide( var panel )
{
	RemoveCallback_OnTopLevelCustomizeContextChanged( panel, CharacterExecutionsPanel_Update )
	CharacterExecutionsPanel_Update( panel )
}


void function CharacterExecutionsPanel_Update( var panel )
{
	var scrollPanel = Hud_GetChild( file.listPanel, "ScrollPanel" )

	//
	foreach ( int flavIdx, ItemFlavor unused in file.characterExecutionList )
	{
		var button = Hud_GetChild( scrollPanel, "GridButton" + flavIdx )
		CustomizeButton_UnmarkForUpdating( button )
	}
	file.characterExecutionList.clear()

	StopVideoOnChannel( file.videoChannel )
	file.currentVideo = $""

	//
	if ( IsPanelActive( file.panel ) )
	{
		ItemFlavor character = GetTopLevelCustomizeContext()
		LoadoutEntry entry   = Loadout_CharacterExecution( character )
		file.characterExecutionList = GetLoadoutItemsSortedForMenu( entry, CharacterExecution_GetSortOrdinal )

		Hud_InitGridButtons( file.listPanel, file.characterExecutionList.len() )
		foreach ( int flavIdx, ItemFlavor flav in file.characterExecutionList )
		{
			var button = Hud_GetChild( scrollPanel, "GridButton" + flavIdx )
			CustomizeButton_UpdateAndMarkForUpdating( button, [entry], flav, PreviewCharacterExecution, CanEquipCanBuyCharacterItemCheck )
		}

		RuiSetString( file.headerRui, "collected", CustomizeMenus_GetCollectedString( entry, file.characterExecutionList, false, false ) )
	}
}


void function CharacterExecutionsPanel_OnFocusChanged( var panel, var oldFocus, var newFocus )
{
	if ( !IsValid( panel ) ) //
		return
	if ( GetParentMenu( panel ) != GetActiveMenu() )
		return

	UpdateFooterOptions()
}


void function PreviewCharacterExecution( ItemFlavor flav )
{
	asset desiredVideo = CharacterExecution_GetExecutionVideo( flav )

	if ( file.currentVideo != desiredVideo ) //
	{
		file.currentVideo = desiredVideo
		StartVideoOnChannel( file.videoChannel, desiredVideo, true, 0.0 )
	}
}


