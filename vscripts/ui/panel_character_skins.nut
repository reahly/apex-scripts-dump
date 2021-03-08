global function InitCharacterSkinsPanel

//

struct
{
	var               panel
	var               headerRui
	var               listPanel
	array<ItemFlavor> characterSkinList
	var heirloomButton
	var blurbPanel
} file

void function InitCharacterSkinsPanel( var panel )
{
	file.panel = panel
	file.listPanel = Hud_GetChild( panel, "CharacterSkinList" )
	file.headerRui = Hud_GetRui( Hud_GetChild( panel, "Header" ) )

	SetPanelTabTitle( panel, "#SKINS" )
	RuiSetString( file.headerRui, "title", Localize( "#OWNED" ).toupper() )

	AddPanelEventHandler( panel, eUIEvent.PANEL_SHOW, CharacterSkinsPanel_OnShow )
	AddPanelEventHandler( panel, eUIEvent.PANEL_HIDE, CharacterSkinsPanel_OnHide )
	AddPanelEventHandler_FocusChanged( panel, CharacterSkinsPanel_OnFocusChanged )

	AddPanelFooterOption( panel, LEFT, BUTTON_B, true, "#B_BUTTON_BACK", "#B_BUTTON_BACK" )
	AddPanelFooterOption( panel, LEFT, BUTTON_A, false, "#A_BUTTON_SELECT", "", null, CustomizeMenus_IsFocusedItem )
	AddPanelFooterOption( panel, LEFT, BUTTON_X, false, "#X_BUTTON_UNLOCK_LEGEND", "#X_BUTTON_UNLOCK_LEGEND", null, CustomizeMenus_IsFocusedItemParentItemLocked )
	AddPanelFooterOption( panel, LEFT, BUTTON_X, false, "#X_BUTTON_EQUIP", "#X_BUTTON_EQUIP", null, CustomizeMenus_IsFocusedItemEquippable )
	AddPanelFooterOption( panel, LEFT, BUTTON_X, false, "#X_BUTTON_UNLOCK", "#X_BUTTON_UNLOCK", null, CustomizeMenus_IsFocusedItemLocked )
	AddPanelFooterOption( panel, LEFT, BUTTON_STICK_LEFT, false, "#MENU_ZOOM_CONTROLS_GAMEPAD", "#MENU_ZOOM_CONTROLS" )

	var listPanel = file.listPanel
	void functionref( var ) func = (
		void function( var button ) : ( listPanel )
		{
			SetOrClearFavoriteFromFocus( listPanel )
		}
	)

	AddPanelFooterOption( panel, LEFT, BUTTON_Y, false, "#Y_BUTTON_SET_FAVORITE", "#Y_BUTTON_SET_FAVORITE", func, CustomizeMenus_IsFocusedItemFavoriteable )
	AddPanelFooterOption( panel, LEFT, BUTTON_Y, false, "#Y_BUTTON_CLEAR_FAVORITE", "#Y_BUTTON_CLEAR_FAVORITE", func, CustomizeMenus_IsFocusedItemFavorite )

	//
	//
	//
	//

	file.heirloomButton = Hud_GetChild( panel, "EquipHeirloomButton" )
	HudElem_SetRuiArg( file.heirloomButton, "bigText", "" )
	HudElem_SetRuiArg( file.heirloomButton, "buttonText", "" )
	HudElem_SetRuiArg( file.heirloomButton, "descText", "" )
	Hud_AddEventHandler( file.heirloomButton, UIE_CLICK, CustomizeCharacterMenu_HeirloomButton_OnActivate )
	//

	file.blurbPanel = Hud_GetChild( panel, "SkinBlurb" )
	Hud_SetVisible( file.blurbPanel, false )
}


void function CharacterSkinsPanel_OnShow( var panel )
{
	UI_SetPresentationType( ePresentationType.CHARACTER_SKIN )

	AddCallback_OnTopLevelCustomizeContextChanged( panel, CharacterSkinsPanel_Update )
	RunClientScript( "EnableModelTurn" )
	thread TrackIsOverScrollBar( file.listPanel )
	CharacterSkinsPanel_Update( panel )

	//
	AddCallback_ItemFlavorLoadoutSlotDidChange_SpecificPlayer( LocalClientEHI(), Loadout_MeleeSkin( GetTopLevelCustomizeContext() ), OnMeleeSkinChanged )
	CustomizeCharacterMenu_UpdateHeirloomButton()
}


void function CharacterSkinsPanel_OnHide( var panel )
{
	RemoveCallback_OnTopLevelCustomizeContextChanged( panel, CharacterSkinsPanel_Update )
	Signal( uiGlobal.signalDummy, "TrackIsOverScrollBar" )
	RunClientScript( "EnableModelTurn" )
	CharacterSkinsPanel_Update( panel )

	//
	RemoveCallback_ItemFlavorLoadoutSlotDidChange_SpecificPlayer( LocalClientEHI(), Loadout_MeleeSkin( GetTopLevelCustomizeContext() ), OnMeleeSkinChanged )
}


void function CharacterSkinsPanel_Update( var panel )
{
	var scrollPanel = Hud_GetChild( file.listPanel, "ScrollPanel" )

	//
	foreach ( int flavIdx, ItemFlavor unused in file.characterSkinList )
	{
		var button = Hud_GetChild( scrollPanel, "GridButton" + flavIdx )
		CustomizeButton_UnmarkForUpdating( button )
	}
	file.characterSkinList.clear()

	CustomizeMenus_SetActionButton( null )

	RunMenuClientFunction( "ClearAllCharacterPreview" )

	Hud_SetVisible( file.blurbPanel, false )

	//
	if ( IsPanelActive( file.panel ) && IsTopLevelCustomizeContextValid() )
	{
		LoadoutEntry entry = Loadout_CharacterSkin( GetTopLevelCustomizeContext() )
		file.characterSkinList = GetLoadoutItemsSortedForMenu( entry, CharacterSkin_GetSortOrdinal )
		FilterCharacterSkinList( file.characterSkinList )

		Hud_InitGridButtons( file.listPanel, file.characterSkinList.len() )
		foreach ( int flavIdx, ItemFlavor flav in file.characterSkinList )
		{
			var button = Hud_GetChild( scrollPanel, "GridButton" + flavIdx )
			CustomizeButton_UpdateAndMarkForUpdating( button, [entry], flav, PreviewCharacterSkin, CanEquipCanBuyCharacterItemCheck )
		}

		CustomizeMenus_SetActionButton( Hud_GetChild( panel, "ActionButton" ) )

		RuiSetString( file.headerRui, "collected", CustomizeMenus_GetCollectedString( entry, file.characterSkinList , false, false ) )
	}
}


void function CharacterSkinsPanel_OnFocusChanged( var panel, var oldFocus, var newFocus )
{
	if ( !IsValid( panel ) ) //
		return
	if ( GetParentMenu( panel ) != GetActiveMenu() )
		return

	UpdateFooterOptions()

	if ( IsControllerModeActive() )
		CustomizeMenus_UpdateActionContext( newFocus )
}


void function PreviewCharacterSkin( ItemFlavor flav )
{
	#if(DEV)
		if ( InputIsButtonDown( KEY_LSHIFT ) )
			printt( GetGlobalSettingsString( flav._____INTERNAL_settingsAsset, "grxRef" ) )
	#endif //

	//
	if ( CharacterSkin_HasStoryBlurb( flav ) )
	{
		Hud_SetVisible( file.blurbPanel, true )
		ItemFlavor characterFlav = CharacterSkin_GetCharacterFlavor( flav )

		asset portraitImage = ItemFlavor_GetIcon( characterFlav )
		CharacterHudUltimateColorData colorData = CharacterClass_GetHudUltimateColorData( characterFlav )

		var rui = Hud_GetRui( file.blurbPanel )
		RuiSetString( rui, "characterName", ItemFlavor_GetShortName( characterFlav ) )
		RuiSetString( rui, "skinNameText", ItemFlavor_GetLongName( flav ) )
		RuiSetString( rui, "bodyText", CharacterSkin_GetStoryBlurbBodyText( flav ) )
		RuiSetImage( rui, "portraitIcon", portraitImage )
		RuiSetFloat3( rui, "characterColor", SrgbToLinear( colorData.ultimateColor ) )
		RuiSetGameTime( rui, "startTime", Time() )
	}
	else
	{
		Hud_SetVisible( file.blurbPanel, false )
	}

	RunClientScript( "UIToClient_PreviewCharacterSkinFromCharacterSkinPanel", ItemFlavor_GetNetworkIndex_DEPRECATED( flav ), ItemFlavor_GetNetworkIndex_DEPRECATED( GetTopLevelCustomizeContext() ) )
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

void function OnMeleeSkinChanged( EHI playerEHI, ItemFlavor flavor )
{
	CustomizeCharacterMenu_UpdateHeirloomButton()
}

ItemFlavor ornull function GetMeleeHeirloom( ItemFlavor character )
{
	LoadoutEntry entry = Loadout_MeleeSkin( GetTopLevelCustomizeContext() )
	array<ItemFlavor> melees = GetValidItemFlavorsForLoadoutSlot( LocalClientEHI(), entry )

	foreach ( meleeFlav in melees )
	{
		if ( ItemFlavor_GetQuality( meleeFlav ) == eRarityTier.HEIRLOOM )
		{
			return meleeFlav
		}
	}

	return null
}

void function CustomizeCharacterMenu_UpdateHeirloomButton()
{
	LoadoutEntry entry = Loadout_MeleeSkin( GetTopLevelCustomizeContext() )
	ItemFlavor ornull meleeHeirloom = GetMeleeHeirloom( GetTopLevelCustomizeContext() )
	if ( meleeHeirloom != null )
	{
		expect ItemFlavor( meleeHeirloom )

		Hud_Show( file.heirloomButton )

		bool isEquipped = (LoadoutSlot_GetItemFlavor( LocalClientEHI(), entry ) == meleeHeirloom)
		bool isEquippable = IsItemFlavorUnlockedForLoadoutSlot( LocalClientEHI(), entry, meleeHeirloom )
		string meleeName = ItemFlavor_GetLongName( meleeHeirloom )

		Hud_SetLocked( file.heirloomButton, !isEquippable )
		Hud_ClearToolTipData( file.heirloomButton )

		HudElem_SetRuiArg( file.heirloomButton, "buttonText", Localize( meleeName ) )
		if ( !isEquippable )
		{
			HudElem_SetRuiArg( file.heirloomButton, "descText", Localize( "#MENU_ITEM_LOCKED" ) )
			HudElem_SetRuiArg( file.heirloomButton, "bigText", "`1%$rui/menu/store/reqs_locked%" )
			Hud_Hide( file.heirloomButton )
		}
		else if ( isEquipped )
		{
			HudElem_SetRuiArg( file.heirloomButton, "descText", Localize( "#EQUIPPED_LOOT_REWARD" ) )
			HudElem_SetRuiArg( file.heirloomButton, "bigText", "`1%$rui/hud/check_selected%" )
		}
		else
		{
			HudElem_SetRuiArg( file.heirloomButton, "descText", Localize( "#EQUIP_LOOT_REWARD" ) )
			HudElem_SetRuiArg( file.heirloomButton, "bigText", "`1%$rui/borders/key_border%" )
		}
	}
	else
	{
		Hud_Hide( file.heirloomButton )
	}
}

void function CustomizeCharacterMenu_HeirloomButton_OnActivate( var button )
{
	if ( Hud_IsLocked( button ) )
		return

	LoadoutEntry entry = Loadout_MeleeSkin( GetTopLevelCustomizeContext() )
	ItemFlavor ornull meleeHeirloom = GetMeleeHeirloom( GetTopLevelCustomizeContext() )

	if ( meleeHeirloom == null )
		return

	array<ItemFlavor> meleeSkinList = RegisterReferencedItemFlavorsFromArray( GetTopLevelCustomizeContext(), "meleeSkins", "flavor" )
	Assert( meleeSkinList.len() == 2 )

	ItemFlavor context = GetTopLevelCustomizeContext()
	ItemFlavor meleeToEquip

	foreach ( meleeFlav in meleeSkinList )
	{
		bool isEquipped = (LoadoutSlot_GetItemFlavor( LocalClientEHI(), entry ) == meleeFlav )
		if ( !isEquipped )
		{
			meleeToEquip = meleeFlav
			break
		}
	}

	PIN_Customization( context, meleeToEquip, "equip" )
	RequestSetItemFlavorLoadoutSlot( LocalClientEHI(), entry, meleeToEquip )
}

void function FilterCharacterSkinList( array<ItemFlavor> characterSkinList )
{
	for ( int i = characterSkinList.len() - 1; i >= 0; i-- )
	{
		if ( !ShouldDisplayCharacterSkin( characterSkinList[i] ) )
			characterSkinList.remove( i )
	}
}

bool function ShouldDisplayCharacterSkin( ItemFlavor characterSkin )
{
	if ( GladiatorCardCharacterSkin_ShouldHideIfLocked( characterSkin ) )
	{
		if ( !IsItemFlavorUnlockedForLoadoutSlot( LocalClientEHI(), Loadout_Character(), characterSkin ) )
			return false
	}

	return true
}