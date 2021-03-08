global function HeirloomShopPanel_Init

global function HeirloomShop_GetTabText
global function HeirloomShop_GetGRXOfferLocation
global function HeirloomShop_GetTabBGDefaultCol
global function HeirloomShop_GetTabBarDefaultCol
global function HeirloomShop_GetTabBGFocusedCol
global function HeirloomShop_GetTabBarFocusedCol
global function HeirloomShop_GetTabBGSelectedCol
global function HeirloomShop_GetTabBarSelectedCol
global function HeirloomShop_GetItemButtonBGImage
global function HeirloomShop_GetItemButtonFrameImage
global function HeirloomShop_GetItemButtonLowerBGDecoImage
global function HeirloomShop_GetItemButtonBorderCol
global function HeirloomShop_GetItemButtonSpecialIcon
global function HeirloomShop_GetItemGroupHeaderImage
global function HeirloomShop_GetItemGroupHeaderText
global function HeirloomShop_GetItemGroupHeaderTextColor
global function HeirloomShop_GetItemGroupBackgroundImage

global function HeirloomShop_IsVisibleWithoutCurrency

global struct ShopThemeStruct
{
	//
	string tabText
	string grxOfferLocation
	vector tabBGDefaultCol
	vector tabBarDefaultCol
	vector tabBGFocusedCol
	vector tabBarFocusedCol
	vector tabBGSelectedCol
	vector tabBarSelectedCol

	//
	vector shopInfoBoxBGTintCol
	vector shopCurrencyCountTextCol
	vector shopCurrencyCountDecoCol
	vector specialAboutTextCol
	asset  bgPatternImage

	//
	asset  itemBtnHighlightedBGImage
	asset  itemBtnRegularBGImage
	asset  itemBtnHighlightedFrameImage
	asset  itemBtnRegularFrameImage
	asset  itemBtnHighlightedLowerBGDecoImage
	asset  itemBtnRegularLowerBGDecoImage
	vector itemBtnHighlightedBorderCol
	vector itemBtnRegularBorderCol
	asset  itemBtnHighlightedSpecialIcon
	asset  itemBtnRegularSpecialIcon
}

struct {
	var        panel
	var        infoBox
	var		   heirloomList
	array<var> offerButtons

	var		   infoButton

	table<var, GRXScriptOffer> offerButtonToOfferMap
	var                        WORKAROUND_currentlyFocusedOfferButtonForFooters

	ShopThemeStruct themeStruct
} file

const int NUM_OFFER_BUTTONS = 5

void function HeirloomShopPanel_Init( var panel )
{
	file.panel = panel

	AddPanelEventHandler( panel, eUIEvent.PANEL_SHOW, HeirloomShopPanel_OnShow )
	AddPanelEventHandler( panel, eUIEvent.PANEL_HIDE, HeirloomShopPanel_OnHide )

	file.infoBox = Hud_GetChild( panel, "InfoBox" )
	file.infoButton = Hud_GetChild( panel, "MoreInfoButton" )

	file.heirloomList = Hud_GetChild( panel, "HeirloomList" )

	Hud_AddEventHandler( file.infoButton, UIE_CLICK, void function( var button ) : () {
		ConfirmDialogData dialogData
		dialogData.headerText = "#CURRENCY_HEIRLOOM_NAME_SHORT"
		dialogData.messageText = Localize( "#CURRENCY_HEIRLOOM_DESC_LONG" )
		OpenOKDialogFromData( dialogData )
	} )

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

	file.themeStruct.tabText = "#MENU_STORE_PANEL_HEIRLOOM_SHOP"
	file.themeStruct.grxOfferLocation = "heirloom_shop"
	file.themeStruct.tabBGDefaultCol = <116.0 / 255.0, 40.0 / 255.0, 29.0 / 255.0>
	file.themeStruct.tabBarDefaultCol = <188.0 / 255.0, 94.0 / 255.0, 57.0 / 255.0>
	file.themeStruct.tabBGFocusedCol = <139.0 / 255.0, 55.0 / 255.0, 25.0 / 255.0>
	file.themeStruct.tabBarFocusedCol = <219.0 / 255.0, 103.0 / 255.0, 55.0 / 255.0>
	file.themeStruct.tabBGSelectedCol = <159.0 / 255.0, 33.0 / 255.0, 5.0 / 255.0>
	file.themeStruct.tabBarSelectedCol = <255.0 / 255.0, 88.0 / 255.0, 23.0 / 255.0>

	file.themeStruct.shopInfoBoxBGTintCol = <0.2, 0.02, 0.02>
	file.themeStruct.shopCurrencyCountTextCol = <1.0, 1.0, 1.0>
	file.themeStruct.shopCurrencyCountDecoCol = <.85, 0.035, 0.013>
	file.themeStruct.specialAboutTextCol = <.6, .6, .6>
	file.themeStruct.bgPatternImage = $"white"

	file.themeStruct.itemBtnHighlightedBGImage = $"white"
	file.themeStruct.itemBtnRegularBGImage = $"white"
	file.themeStruct.itemBtnHighlightedFrameImage = $"white"
	file.themeStruct.itemBtnRegularFrameImage = $"white"
	file.themeStruct.itemBtnHighlightedLowerBGDecoImage = $"white"
	file.themeStruct.itemBtnRegularLowerBGDecoImage = $"white"
	file.themeStruct.itemBtnHighlightedBorderCol = <0, 0, 0>
	file.themeStruct.itemBtnRegularBorderCol = <0, 0, 0>
	file.themeStruct.itemBtnHighlightedSpecialIcon = $"white"
	file.themeStruct.itemBtnRegularSpecialIcon = $"white"

	AddPanelFooterOption( panel, LEFT, BUTTON_B, true, "#B_BUTTON_BACK", "#B_BUTTON_BACK" )
	AddPanelFooterOption( panel, LEFT, BUTTON_A, false, "#A_BUTTON_INSPECT", "#A_BUTTON_INSPECT", null, IsFocusedItemInspectable )
	AddPanelFooterOption( panel, LEFT, BUTTON_X, false, "#X_BUTTON_EQUIP", "#X_BUTTON_EQUIP", null, IsFocusedItemEquippable )
}


void function HeirloomShopPanel_OnShow( var panel )
{
	UI_SetPresentationType( ePresentationType.WEAPON_CATEGORY )

	AddCallbackAndCallNow_OnGRXInventoryStateChanged( HeirloomShopPanel_UpdateGRXDependantElements )
	AddCallbackAndCallNow_OnGRXOffersRefreshed( HeirloomShopPanel_UpdateGRXDependantElements )

	thread HeirloomShopPanel_Think( panel )
}


void function HeirloomShopPanel_OnHide( var panel )
{
	RunClientScript( "UIToClient_StopBattlePassScene" )

	RemoveCallback_OnGRXInventoryStateChanged( HeirloomShopPanel_UpdateGRXDependantElements )
	RemoveCallback_OnGRXOffersRefreshed( HeirloomShopPanel_UpdateGRXDependantElements )
}


GRXScriptOffer function DEV_FakeHeirloomOffer( asset packAsset )
{
	GRXScriptOffer fakeOffer
	ItemFlavorBag priceBag
	priceBag.flavors.append( GRX_CURRENCIES[GRX_CURRENCY_HEIRLOOM] )
	priceBag.quantities.append( 100 )
	fakeOffer.prices.append( priceBag )

	ItemFlavorBag outputBag
	outputBag.flavors.append( GetItemFlavorByAsset( packAsset ) )
	outputBag.quantities.append( 1 )
	fakeOffer.output = outputBag

	return fakeOffer
}


void function HeirloomShopPanel_UpdateGRXDependantElements()
{
	bool isInventoryReady    = GRX_IsInventoryReady()
	bool hasHeirloomCurrency = true
	bool menuIsUsable        = isInventoryReady && hasHeirloomCurrency

	foreach ( offerButton, offer in file.offerButtonToOfferMap )
	{
		Hud_RemoveEventHandler( offerButton, UIE_GET_FOCUS, OfferButton_OnGetFocus )
		Hud_RemoveEventHandler( offerButton, UIE_LOSE_FOCUS, OfferButton_OnLoseFocus )
		Hud_RemoveEventHandler( offerButton, UIE_CLICK, OfferButton_OnActivate )
		Hud_RemoveEventHandler( offerButton, UIE_CLICKRIGHT, OfferButton_OnAltActivate )
	}
	file.offerButtonToOfferMap.clear()

	ShopThemeStruct themeStruct = file.themeStruct

	if ( menuIsUsable )
	{
		ItemFlavor currencyFlav = GRX_CURRENCIES[GRX_CURRENCY_HEIRLOOM]

		HudElem_SetRuiArg( file.infoBox, "title", "#HEIRLOOM_SHOP" )
		HudElem_SetRuiArg( file.infoBox, "descriptionText", ItemFlavor_GetLongDescription( currencyFlav ) )
		HudElem_SetRuiArg( file.infoBox, "currencyName", ItemFlavor_GetShortName( currencyFlav ) )

		HudElem_SetRuiArg( file.infoBox, "shopInfoBoxBGTintCol", themeStruct.shopInfoBoxBGTintCol )
		HudElem_SetRuiArg( file.infoBox, "shopCurrencyCountTextCol", themeStruct.shopCurrencyCountTextCol )
		HudElem_SetRuiArg( file.infoBox, "shopCurrencyCountDecoCol", themeStruct.shopCurrencyCountDecoCol )
		HudElem_SetRuiArg( file.infoBox, "specialAboutTextCol", themeStruct.specialAboutTextCol )
		HudElem_SetRuiArg( file.infoBox, "bgPatternImage", themeStruct.bgPatternImage )

		HudElem_SetRuiArg( file.infoBox, "currencyIcon", ItemFlavor_GetIcon( currencyFlav ) )

		HudElem_SetRuiArg( file.infoBox, "isCurrencyAmountLoading", !isInventoryReady )
		if ( isInventoryReady )
			HudElem_SetRuiArg( file.infoBox, "currencyAmount", GRXCurrency_GetPlayerBalance( GetUIPlayer(), currencyFlav ) )
		else
			HudElem_SetRuiArg( file.infoBox, "currencyAmount", 0 )

		int heirloomCost = GetCurrentPlaylistVarInt( "grx_currency_bundle_heirloom_count", 50 ) * 3
		HudElem_SetRuiArg( file.infoBox, "heirloomCost", heirloomCost )

		string offerGRXLocation      = "heirloom_shop"
		array<GRXScriptOffer> offers = GRX_GetLocationOffers( offerGRXLocation )

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
		int numTiles = offers.len()
		Hud_InitGridButtonsDetailed( file.heirloomList, numTiles, 1, 5 )
		var scrollPanel = Hud_GetChild( file.heirloomList, "ScrollPanel" )
		foreach ( offerIndex, offer in offers )
		{
			var offerButton = Hud_GetChild( scrollPanel, "GridButton" + offerIndex )

			file.offerButtonToOfferMap[offerButton] <- offer

			ItemFlavor singleOutputFlav = ItemFlavorBag_GetSingleOutputItemFlavor_Assert( offer.output )
			array<ItemFlavor> packContents = GRXPack_GetPackContents( singleOutputFlav )
			Assert( packContents.len() == 1, "" + packContents.len() )

			singleOutputFlav = packContents[0]
			ItemFlavor character = MeleeSkin_GetCharacterFlavor( singleOutputFlav )

			bool isOwned = GRX_IsItemOwnedByPlayer_AllowOutOfDateData( singleOutputFlav )

			HudElem_SetRuiArg( offerButton, "itemName", ItemFlavor_GetLongName( character ) )
			HudElem_SetRuiArg( offerButton, "itemDesc", isOwned ? "#COLLECTED" : ItemFlavor_GetLongName( singleOutputFlav ) )
			HudElem_SetRuiArg( offerButton, "itemRarity", ItemFlavor_GetQuality( singleOutputFlav ) )
			HudElem_SetRuiArg( offerButton, "itemImg", GRXPack_GetOpenButtonIcon( ItemFlavorBag_GetSingleOutputItemFlavor_Assert( offer.output ) ), eRuiArgType.IMAGE )
			HudElem_SetRuiArg( offerButton, "charImg", ItemFlavor_GetIcon( character ), eRuiArgType.IMAGE )
			Assert( offer.prices.len() == 1 )
			HudElem_SetRuiArg( offerButton, "isOwned", isOwned )

			Hud_AddEventHandler( offerButton, UIE_GET_FOCUS, OfferButton_OnGetFocus )
			Hud_AddEventHandler( offerButton, UIE_LOSE_FOCUS, OfferButton_OnLoseFocus )
			Hud_AddEventHandler( offerButton, UIE_CLICK, OfferButton_OnActivate )
			Hud_AddEventHandler( offerButton, UIE_CLICKRIGHT, OfferButton_OnAltActivate )
		}
		/*


























*/
	}
	else
	{
		Hud_InitGridButtonsDetailed( file.heirloomList, 0, 1, 6 )

		//
		//
	}

	var focus = GetFocus()
	if ( !(focus in file.offerButtonToOfferMap) )
		focus = null
	UpdateFocusStuff( focus )
}


void function HeirloomShopPanel_Think( var panel )
{
	var focusedOfferButton = null
	float offerLostFocusTime = 0
	bool offerFocusNeedsUpdate = true

	var menu = GetParentMenu( panel )
	while ( uiGlobal.activeMenu == menu && uiGlobal.activePanels.contains( panel ) )
	{
		var focus = GetFocus()

		if ( focus in file.offerButtonToOfferMap )
		{
			if ( focus != focusedOfferButton )
			{
				offerFocusNeedsUpdate = false
				focusedOfferButton = focus
				printt( "new offer focus" )
				foreach ( offerButton, offer in file.offerButtonToOfferMap )
				{
					if ( offerButton != focusedOfferButton )
						HudElem_SetRuiArg( offerButton, "isOtherFocused", true )
					else
						HudElem_SetRuiArg( offerButton, "isOtherFocused", false )
				}
			}
		}
		else if ( focusedOfferButton != null )
		{
			focusedOfferButton = null
			offerLostFocusTime = Time()
			offerFocusNeedsUpdate = true
			printt( "lost offer focus" )
		}
		else if ( Time() > offerLostFocusTime + 0.25 && offerFocusNeedsUpdate )
		{
			offerFocusNeedsUpdate = false
			printt( "it's been long enough" )
			foreach ( offerButton, offer in file.offerButtonToOfferMap )
			{
				HudElem_SetRuiArg( offerButton, "isOtherFocused", false )
			}
		}

		WaitFrame()
	}
}


void function OfferButton_OnGetFocus( var btn )
{
	UpdateFocusStuff( btn )
	//
	//
	//
	//
}


void function OfferButton_OnLoseFocus( var btn )
{
	var focus = GetFocus()
	//
	//
	//
	//
	//

	UpdateFocusStuff( null )
}


void function OfferButton_OnActivate( var btn )
{
	if ( !Hud_IsEnabled( btn ) )
		return

	GRXScriptOffer offer = file.offerButtonToOfferMap[btn]
	ItemFlavor offerFlav = ItemFlavorBag_GetSingleOutputItemFlavor_Assert( offer.output )
	if ( !IsItemFlavorInspectable( offerFlav ) || ItemFlavor_GetType( offerFlav ) != eItemType.account_pack )
		return

	array<ItemFlavor> packContents = GRXPack_GetPackContents( offerFlav )
	Assert( packContents.len() == 1 )

	SetHeirloomShopItemPresentationModeActive( offer )
}


void function OfferButton_OnAltActivate( var btn )
{
	if ( !Hud_IsEnabled( btn ) )
		return

	GRXScriptOffer offer = file.offerButtonToOfferMap[btn]
	ItemFlavor offerFlav = ItemFlavorBag_GetSingleOutputItemFlavor_Assert( offer.output )
	if ( !IsItemFlavorEquippable( offerFlav ) )
		return

	EmitUISound( "UI_Menu_Equip_Generic" )
	EquipItemFlavorInAppropriateLoadoutSlot( offerFlav )
}


bool function IsFocusedItemInspectable()
{
	var focus = file.WORKAROUND_currentlyFocusedOfferButtonForFooters //
	if ( focus in file.offerButtonToOfferMap )
	{
		GRXScriptOffer offer = file.offerButtonToOfferMap[focus]
		ItemFlavor offerFlav = ItemFlavorBag_GetSingleOutputItemFlavor_Assert( offer.output )
		return IsItemFlavorInspectable( offerFlav )
	}

	return false
}


bool function IsFocusedItemEquippable()
{
	var focus = file.WORKAROUND_currentlyFocusedOfferButtonForFooters //
	if ( focus in file.offerButtonToOfferMap )
	{
		GRXScriptOffer offer = file.offerButtonToOfferMap[focus]
		ItemFlavor offerFlav = ItemFlavorBag_GetSingleOutputItemFlavor_Assert( offer.output )
		return IsItemFlavorEquippable( offerFlav )
	}

	return false
}


void function UpdateFocusStuff( var focusedOfferButtonOrNull )
{
	file.WORKAROUND_currentlyFocusedOfferButtonForFooters = focusedOfferButtonOrNull

	UpdateFooterOptions() //
}


string function HeirloomShop_GetTabText()
{
	return file.themeStruct.tabText
}


string function HeirloomShop_GetGRXOfferLocation()
{
	return file.themeStruct.grxOfferLocation
}


vector function HeirloomShop_GetTabBGDefaultCol()
{
	return file.themeStruct.tabBGDefaultCol
}


vector function HeirloomShop_GetTabBarDefaultCol()
{
	return file.themeStruct.tabBarDefaultCol
}


vector function HeirloomShop_GetTabBGFocusedCol()
{
	return file.themeStruct.tabBGFocusedCol
}


vector function HeirloomShop_GetTabBarFocusedCol()
{
	return file.themeStruct.tabBarFocusedCol
}


vector function HeirloomShop_GetTabBGSelectedCol()
{
	return file.themeStruct.tabBGSelectedCol
}


vector function HeirloomShop_GetTabBarSelectedCol()
{
	return file.themeStruct.tabBarSelectedCol
}


asset function HeirloomShop_GetItemButtonBGImage( bool isHighlighted )
{
	return isHighlighted ? file.themeStruct.itemBtnHighlightedBGImage : file.themeStruct.itemBtnRegularBGImage
}


asset function HeirloomShop_GetItemButtonFrameImage( bool isHighlighted )
{
	return isHighlighted ? file.themeStruct.itemBtnHighlightedFrameImage : file.themeStruct.itemBtnRegularFrameImage
}


asset function HeirloomShop_GetItemButtonLowerBGDecoImage( bool isHighlighted )
{
	return isHighlighted ? file.themeStruct.itemBtnHighlightedLowerBGDecoImage : file.themeStruct.itemBtnRegularLowerBGDecoImage
}


vector function HeirloomShop_GetItemButtonBorderCol( bool isHighlighted )
{
	return isHighlighted ? file.themeStruct.itemBtnHighlightedBorderCol : file.themeStruct.itemBtnRegularBorderCol
}


asset function HeirloomShop_GetItemButtonSpecialIcon( bool isHighlighted )
{
	return isHighlighted ? file.themeStruct.itemBtnHighlightedSpecialIcon : file.themeStruct.itemBtnRegularSpecialIcon
}


asset function HeirloomShop_GetItemGroupHeaderImage( int group )
{
	return $""//
}


string function HeirloomShop_GetItemGroupHeaderText( int group )
{
	return ""//
}


vector function HeirloomShop_GetItemGroupHeaderTextColor( int group )
{
	return <1, 1, 1>//
}


asset function HeirloomShop_GetItemGroupBackgroundImage( int group )
{
	return $""//
}


asset function HeirloomShop_GetHeaderIcon()
{
	return $""//
}


bool function HeirloomShop_IsVisibleWithoutCurrency()
{
	return GetCurrentPlaylistVarBool( "heirloom_shop_visible_without_currency", true )
}