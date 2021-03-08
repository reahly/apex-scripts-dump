global function InitStoreInspectMenu
global function StoreInspectMenu_SetStoreOfferData
global function StoreInspectMenu_SetSKUPurchaseInfo
global function StoreInspectMenu_IsItemPresentationSupported
global function StoreInspectMenu_AttemptOpenWithOffer
global function ViewEntitlementInStoreOverlay

#if(DEV)
global function DEV_PrintInspectedOffer
global function DEV_DisplayAllInspectElements
global function DEV_AddFakeItemToOffer
global function DEV_AddFakeItemsToOffer
#endif

struct SKUInfo
{
	string currentPrice
	string originalPrice
	int skuID = -1
}

struct
{
	var menu
	var inspectPanel
	var mouseCaptureElem

	var pageHeader
	var itemGrid
	var discountInfo
	var itemInfo
	var purchaseButton
	var purchaseLimit

} file

struct
{
	SKUInfo skuInfo
	string originalPriceStr
	string displayedPriceStr
	string purchaseText
	string purchaseDescText
	int discountPct
	int itemCount
	int originalPrice
	int displayedPrice
	int purchaseLimit
	bool isOwnedItemEquippable
	bool isPurchasable

	array<GRXScriptOffer> currentOffers
	array<ItemFlavor> itemFlavors
	array<string> exclusiveItems
} s_inspectOffers

const int ITEM_GRID_ROWS = 4
const int ITEM_GRID_COLUMNS = 6

void function InitStoreInspectMenu( var newMenuArg )
{
	var menu = GetMenu( "StoreInspectMenu" )
	file.menu = menu

	AddMenuEventHandler( menu, eUIEvent.MENU_OPEN, StoreInspectMenu_OnOpen )
	AddMenuEventHandler( menu, eUIEvent.MENU_SHOW, StoreInspectMenu_OnShow )
	AddMenuEventHandler( menu, eUIEvent.MENU_CLOSE, StoreInspectMenu_OnClose )

	file.inspectPanel = Hud_GetChild( menu, "InspectPanel" )
	file.mouseCaptureElem = Hud_GetChild( menu, "ModelRotateMouseCapture" )

	file.pageHeader = Hud_GetChild( file.inspectPanel, "InspectHeader" )
	file.itemGrid = Hud_GetChild( file.inspectPanel, "ItemGridPanel" )
	file.discountInfo = Hud_GetChild( file.inspectPanel, "DiscountInfo" )
	file.itemInfo = Hud_GetChild( file.inspectPanel, "IndividualItemInfo" )
	file.purchaseButton = Hud_GetChild( file.inspectPanel, "PurchaseOfferButton" )
	file.purchaseLimit = Hud_GetChild( file.inspectPanel, "PurchaseLimit" )

	AddButtonEventHandler( file.purchaseButton, UIE_CLICK, PurchaseOfferButton_OnClick )

	GridPanel_Init( file.itemGrid, ITEM_GRID_ROWS, ITEM_GRID_COLUMNS, OnBindItemGridButton, ItemGridButtonCountCallback, ItemGridButtonInitCallback )
	GridPanel_SetFillDirection( file.itemGrid, eGridPanelFillDirection.RIGHT )
	GridPanel_SetButtonHandler( file.itemGrid, UIE_CLICK, OnStoreGridItemClicked )
	GridPanel_SetButtonHandler( file.itemGrid, UIE_GET_FOCUS, OnStoreGridItemHover )

	AddMenuFooterOption( menu, LEFT, BUTTON_B, true, "#B_BUTTON_BACK", "#B_BUTTON_BACK" )
}

void function StoreInspectMenu_OnOpen()
{

}

void function StoreInspectMenu_OnShow()
{
	UI_SetPresentationType( ePresentationType.STORE_INSPECT )

	AddCallbackAndCallNow_OnGRXInventoryStateChanged( StoreInspectMenu_OnGRXUpdated )
	AddCallback_OnGRXOffersRefreshed( StoreInspectMenu_OnGRXUpdated )
	AddCallback_OnGRXBundlesRefreshed( StoreInspectMenu_OnGRXBundlesUpdated )

	StoreInspectMenu_OnUpdate()

	if ( IsPresentingSKUProduct() )
		OnOpenDLCStore()
}

void function StoreInspectMenu_OnClose()
{
	RemoveCallback_OnGRXInventoryStateChanged( StoreInspectMenu_OnGRXUpdated )
	RemoveCallback_OnGRXOffersRefreshed( StoreInspectMenu_OnGRXUpdated )
	RemoveCallback_OnGRXBundlesRefreshed( StoreInspectMenu_OnGRXBundlesUpdated )

	if ( IsPresentingSKUProduct() )
		OnCloseDLCStore()

	//
	s_inspectOffers.skuInfo.currentPrice = ""
	s_inspectOffers.skuInfo.originalPrice = ""
	s_inspectOffers.skuInfo.skuID = -1
}

void function StoreInspectMenu_OnUpdate()
{
	if ( !IsFullyConnected() )
		return

	GridPanel_Refresh( file.itemGrid )
}

void function UpdatePrices( GRXScriptOffer storeOffer, bool isBundlesRefresh )
{
	if( isBundlesRefresh && storeOffer.offerType != GRX_OFFERTYPE_BUNDLE )
		return

	bool isBundle = storeOffer.offerType == GRX_OFFERTYPE_BUNDLE
	bool isBundlePriceMissing = false
	string ineligibleReason = ""
	int purchaseCount = 0

	if ( isBundle )
	{
		if( !isBundlesRefresh && !GRX_HasUpToDateBundleOffers() )
		{
			printt( "StoreInspectMenu: Client never received bundle offers but we're trying to display a bundle." )
			isBundlePriceMissing = true
		}
		else
		{
			GRXBundleOffer bundle = GRX_GetUserBundleOffer( storeOffer.offerAlias )
			ineligibleReason = bundle.ineligibleReason
			purchaseCount = bundle.purchaseCount

			if ( ineligibleReason == "" )
			{
				storeOffer.prices.clear()

				ItemFlavorBag bundlePricesBag = GRX_MakeItemFlavorBagFromPriceArray( bundle.bundlePrices[0] )
				if ( bundlePricesBag.flavors.len() > 0 )
					storeOffer.prices.append( bundlePricesBag )

				ItemFlavorBag originalPriceBag = GRX_MakeItemFlavorBagFromPriceArray( bundle.bundlePrices[1] )
				if( originalPriceBag.flavors.len() > 0 )
					storeOffer.originalPrice = originalPriceBag
			}
		}
	}

	if( IsPresentingSKUProduct() )
	{
		s_inspectOffers.displayedPriceStr = s_inspectOffers.skuInfo.currentPrice
	}
	else
	{
		s_inspectOffers.displayedPrice = storeOffer.prices[0].quantities[0]
		s_inspectOffers.displayedPriceStr = GRX_GetFormattedPrice( storeOffer.prices[0], 1 )
	}

	s_inspectOffers.discountPct = 0

	ItemFlavorBag originalPriceFlavBag
	if ( storeOffer.originalPrice != null )
		originalPriceFlavBag = expect ItemFlavorBag( storeOffer.originalPrice )

	if( originalPriceFlavBag.quantities.len() > 0 )
	{
		s_inspectOffers.originalPrice = originalPriceFlavBag.quantities[0]
		s_inspectOffers.originalPriceStr = GRX_GetFormattedPrice( originalPriceFlavBag, 1 )
		float discount = 100 - ( s_inspectOffers.displayedPrice / (s_inspectOffers.originalPrice * 1.0) * 100 )
		s_inspectOffers.discountPct = int( floor( discount ) ) //
	}

	string bundleRestrictionsStr = isBundle ? GRXOffer_GetBundleOfferRestrictions( storeOffer ) : ""
	bool hasBundleRestrictions = bundleRestrictionsStr != ""

	bool isOfferFullyClaimed = GRXOffer_IsFullyClaimed( storeOffer )
	bool isPurchaseLimitReached = s_inspectOffers.purchaseLimit > 0 && purchaseCount >= s_inspectOffers.purchaseLimit

	int numOfferItemsOwned = GRXOffer_GetOwnedItemsCount( storeOffer )
	HudElem_SetRuiArg( file.discountInfo, "ownedItemsDesc", numOfferItemsOwned > 0 ? Localize( "#BUNDLE_OWNED_ITEMS_DESC", numOfferItemsOwned ) : "" )

	s_inspectOffers.isPurchasable = !isOfferFullyClaimed && !hasBundleRestrictions && !isPurchaseLimitReached && storeOffer.isAvailable
	s_inspectOffers.purchaseText = isBundle ? Localize( "#PURCHASE_BUNDLE" ) : Localize( "#PURCHASE" )
	s_inspectOffers.purchaseDescText = Localize( s_inspectOffers.displayedPriceStr )

	if ( !storeOffer.isAvailable )
	{
		//
		s_inspectOffers.purchaseText = Localize( "#UNAVAILABLE" )
		s_inspectOffers.purchaseDescText = ""
	}
	else if ( isBundle && isBundlePriceMissing )
	{
		s_inspectOffers.purchaseText = Localize( "#UNAVAILABLE" )
		s_inspectOffers.purchaseDescText = Localize( "#BUNDLE_UNABLE_TO_RETREIVE_DATA" )
	}
	else if ( isBundle && hasBundleRestrictions )
	{
		s_inspectOffers.purchaseText = Localize( "#LOCKED" )
		s_inspectOffers.purchaseDescText = Localize( bundleRestrictionsStr )
	}
	else if ( isBundle && isOfferFullyClaimed )
	{
		s_inspectOffers.purchaseText = Localize( "#UNAVAILABLE" )
		s_inspectOffers.purchaseDescText = Localize( "#BUNDLE_OWNED_DESC" )
	}
	else if ( isPurchaseLimitReached )
	{
		s_inspectOffers.purchaseText = Localize( "#UNAVAILABLE" )
		s_inspectOffers.purchaseDescText = Localize( "#PURCHASE_LIMIT_REACHED" )
	}
	else if ( isOfferFullyClaimed )
	{
		s_inspectOffers.purchaseText = Localize( "#OWNED" )
		s_inspectOffers.purchaseDescText = hasBundleRestrictions ? bundleRestrictionsStr : ""
	}
	//
	//

	StoreInspectMenu_UpdatePurchaseButton( storeOffer )
}

void function StoreInspectMenu_UpdatePurchaseButton( GRXScriptOffer storeOffer )
{
	bool isExtraInfoVisible = false
	bool isOfferFullyClaimed = GRXOffer_IsFullyClaimed( storeOffer )

	if ( storeOffer.prereq != null )
	{
		isExtraInfoVisible = false
		ItemFlavor prereqFlav = expect ItemFlavor( storeOffer.prereq )
		if ( !GRX_IsItemOwnedByPlayer( prereqFlav ) )
		{
			s_inspectOffers.isPurchasable = false
			s_inspectOffers.purchaseText = Localize( "#LOCKED" )
			s_inspectOffers.purchaseDescText = Localize( "#STORE_REQUIRES_LOCKED", Localize( ItemFlavor_GetLongName( prereqFlav ) ) )
		}
	}
	else
	{
		HudElem_SetRuiArg( file.discountInfo, "discountPct", Localize( "#N_PERCENT", s_inspectOffers.discountPct ) )
		HudElem_SetRuiArg( file.discountInfo, "originalPrice", Localize( s_inspectOffers.originalPriceStr ) )
		isExtraInfoVisible = s_inspectOffers.isPurchasable && s_inspectOffers.discountPct > 0.0
	}

	Hud_SetVisible( file.discountInfo, isExtraInfoVisible )

	HudElem_SetRuiArg( file.purchaseButton, "buttonText", s_inspectOffers.purchaseText )
	HudElem_SetRuiArg( file.purchaseButton, "buttonDescText", s_inspectOffers.purchaseDescText )

	if( s_inspectOffers.itemCount == 1 && isOfferFullyClaimed )
	{
		StoreInspectMenu_UpdateButtonForEquips()
		Hud_SetLocked( file.purchaseButton, !s_inspectOffers.isOwnedItemEquippable )
		HudElem_SetRuiArg( file.purchaseButton, "isDisabled", !s_inspectOffers.isOwnedItemEquippable )
	}
	else
	{
		s_inspectOffers.isOwnedItemEquippable = false
		Hud_SetLocked( file.purchaseButton, !s_inspectOffers.isPurchasable )
		HudElem_SetRuiArg( file.purchaseButton, "isDisabled", !s_inspectOffers.isPurchasable )
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
}

void function StoreInspectMenu_UpdateButtonForEquips()
{
	ItemFlavor itemFlav = s_inspectOffers.itemFlavors[0]
	int itemType = ItemFlavor_GetType( itemFlav )
	var rui = Hud_GetRui( file.purchaseButton )

	if ( itemType == eItemType.weapon_charm )
	{
		//
		s_inspectOffers.isOwnedItemEquippable = false
	}
	else if( IsItemEquipped( itemFlav ) )
	{
		int rarity = 0
		if ( ItemFlavor_HasQuality( itemFlav ) )
			rarity = ItemFlavor_GetQuality( itemFlav )

		RuiSetString( rui, "buttonText", "#EQUIPPED_LOOT_REWARD" )
		RuiSetString( rui, "buttonDescText", Localize( "#CURRENTLY_EQUIPPED_ITEM", Localize( ItemFlavor_GetLongName( itemFlav ) ) ) )
		RuiSetInt( rui, "buttonDescRarity", rarity )
		s_inspectOffers.isOwnedItemEquippable = false
	}
	else
	{
		RuiSetString( rui, "buttonText", "#EQUIP_LOOT_REWARD" )
		RuiSetString( rui, "buttonDescText", Localize( "#CURRENTLY_EQUIPPED_ITEM", Localize( GetCurrentlyEquippedItemNameForItemTypeSlot( itemFlav ) ) ) )
		RuiSetInt( rui, "buttonDescRarity", GetCurrentlyEquippedItemRarityForItemTypeSlot( itemFlav ) )
		s_inspectOffers.isOwnedItemEquippable = true
	}
}

void function StoreInspectMenu_OnGRXBundlesUpdated()
{
	if ( s_inspectOffers.currentOffers.len() == 0 )
		return

	if( !GRX_IsInventoryReady() )
		return

	UpdatePrices( s_inspectOffers.currentOffers[0], true )
}

void function StoreInspectMenu_OnGRXUpdated()
{
	if( !GRX_IsInventoryReady() || !GRX_AreOffersReady() )
		return

	GRXScriptOffer storeOffer = s_inspectOffers.currentOffers[0]
	s_inspectOffers.itemFlavors.clear()

	if( IsPresentingSKUProduct() )
		printt( "StoreInspectMenu_OnGRXUpdated offer is SKU Product:", SKUStore_EntitlementHumanReadableRefs[s_inspectOffers.skuInfo.skuID] )
	else
		printt( "StoreInspectMenu_OnGRXUpdated offer is from store:", storeOffer.offerAlias )

	foreach( ItemFlavor flav in storeOffer.output.flavors )
		s_inspectOffers.itemFlavors.append( flav )

	s_inspectOffers.purchaseLimit = ( "purchaselimit" in storeOffer.attributes ? storeOffer.attributes["purchaselimit"].tointeger() : -1 )

	s_inspectOffers.exclusiveItems.clear()
	string exclusiveItemsAttr = ( "offerexclusives" in storeOffer.attributes ? storeOffer.attributes["offerexclusives"] : "" )
	s_inspectOffers.exclusiveItems = split( exclusiveItemsAttr, "," )

	UpdatePrices( storeOffer, false )

	HudElem_SetRuiArg( file.pageHeader, "offerName", storeOffer.titleText )
	HudElem_SetRuiArg( file.pageHeader, "isSingleItem", s_inspectOffers.itemCount == 1 )

	if( s_inspectOffers.itemCount == 1 )
	{
		ItemFlavor itemFlav = s_inspectOffers.itemFlavors[0]

		HudElem_SetRuiArg( file.pageHeader, "singleItemRarity", ItemFlavor_GetQuality( itemFlav ) )
		HudElem_SetRuiArg( file.pageHeader, "singleItemRarityText", ItemFlavor_GetQualityName( itemFlav ) )
		HudElem_SetRuiArg( file.pageHeader, "singleItemTypeText", ItemFlavor_GetRewardShortDescription( itemFlav ) )
	}
	else
	{
		HudElem_SetRuiArg( file.pageHeader, "offerDesc", storeOffer.descText )
	}

	//
	OnStoreGridItemHover( null, null, 0 )
	GridPanel_Refresh( file.itemGrid )

	bool hasPurchaseLimit = s_inspectOffers.purchaseLimit > 0
	HudElem_SetRuiArg( file.purchaseLimit, "limitText", Localize( "#STORE_LIMIT_N", s_inspectOffers.purchaseLimit ) )
	Hud_SetVisible( file.purchaseLimit, hasPurchaseLimit )
}

GRXStoreOfferItem function GetItemFromGridIndex( int index )
{
	GRXScriptOffer storeOffer = s_inspectOffers.currentOffers[0]
	return storeOffer.items[index]
}

void function OnBindItemGridButton( var panel, var button, int index )
{
	GRXStoreOfferItem item = GetItemFromGridIndex( index )

	ItemFlavor itemFlav
	asset itemThumbnail = $""

	if( IsPresentingSKUProduct() && index == s_inspectOffers.itemCount-1 )
	{
		//
		itemFlav = s_inspectOffers.currentOffers[0].output.flavors[index]
		itemThumbnail = $"rui/menu/buttons/bundles/currency_coins"
	}
	else
	{
		itemFlav = GetItemFlavorByGRXIndex( item.itemIdx )
		itemThumbnail = CustomizeMenu_GetRewardButtonImage( itemFlav )
	}

	var rui = Hud_GetRui( button )
	if( ItemFlavor_GetGRXMode( itemFlav ) == eItemFlavorGRXMode.REGULAR )
		RuiSetBool( rui, "isOwned", GRX_IsItemOwnedByPlayer( itemFlav ) )
	else
		RuiSetBool( rui, "isOwned", false )

	RuiSetImage( rui, "itemThumbnail", itemThumbnail )
	RuiSetInt( rui, "rarity", ItemFlavor_GetQuality( itemFlav ) )
	RuiSetInt( rui, "itemQty", item.itemQuantity )

	string specialItemDesc = ""
	foreach( string itemName in s_inspectOffers.exclusiveItems )
		if( ItemFlavor_GetHumanReadableRef( itemFlav ) == itemName )
			specialItemDesc = "#BUNDLE_ITEM_DESC_EXCLUSIVE"

	if ( item.itemType == GRX_OFFERITEMTYPE_BONUS )
		specialItemDesc = "#BUNDLE_ITEM_DESC_BONUS"

	RuiSetString( rui, "specialItemDesc", Localize( specialItemDesc ) )
}

int function ItemGridButtonCountCallback( var panel )
{
	return s_inspectOffers.itemCount
}

void function ItemGridButtonInitCallback( var button )
{
}

void function OnStoreGridItemClicked( var panel, var button, int index )
{
}

void function OnStoreGridItemHover( var panel, var button, int index )
{
	GRXStoreOfferItem item = GetItemFromGridIndex( index )
	ItemFlavor itemFlav

	if( IsPresentingSKUProduct() && index == s_inspectOffers.itemCount-1 )
		itemFlav = s_inspectOffers.currentOffers[0].output.flavors[index]
	else
		itemFlav = GetItemFlavorByGRXIndex( item.itemIdx )

	bool isOwned = false
	if( ItemFlavor_GetGRXMode( itemFlav ) == GRX_ITEMFLAVORMODE_REGULAR )
		isOwned = GRX_IsItemOwnedByPlayer( itemFlav )

	int itemType = ItemFlavor_GetType( itemFlav )
	string rarityText = itemType == eItemType.character ? "" : ItemFlavor_GetQualityName( itemFlav )

	HudElem_SetRuiArg( file.itemInfo, "isOwned", isOwned )
	HudElem_SetRuiArg( file.itemInfo, "rarity", ItemFlavor_GetQuality( itemFlav ) )
	HudElem_SetRuiArg( file.itemInfo, "rarityText", rarityText )
	HudElem_SetRuiArg( file.itemInfo, "itemName", ItemFlavor_GetLongName( itemFlav ) )
	HudElem_SetRuiArg( file.itemInfo, "itemType", ItemFlavor_GetRewardShortDescription( itemFlav ) )

	bool shouldPlayAudioPreview = true
	bool showLow = false
	float scale = 1.0

	switch ( itemType )
	{
		case eItemType.weapon_charm:
			scale = 0.5
			break
		case eItemType.weapon_skin:
			scale = 2.1
			break
		case eItemType.gladiator_card_stance:
			scale = 0.8
			break
	}

	RunClientScript( "UIToClient_PreviewStoreItem", ItemFlavor_GetGUID( itemFlav ) )
}

void function ViewEntitlementInStoreOverlay( string storeLink )
{
	#if(PC_PROG)
		if ( !PCPlat_IsOverlayAvailable() )
		{
			string platname = PCPlat_IsOrigin() ? "ORIGIN" : "STEAM"
			ConfirmDialogData dialogData
			dialogData.headerText = ""
			dialogData.messageText = "#" + platname + "_INGAME_REQUIRED"
			dialogData.contextImage = $"ui/menu/common/dialog_notice"

			OpenOKDialogFromData( dialogData )
			return
		}
	#endif

	ViewEntitlementInStore( storeLink )
}

void function PurchaseOfferButton_OnClick( var button )
{
	if ( Hud_IsLocked( button ) )
	{
		EmitUISound( "menu_deny" )
		return
	}

	if ( IsPresentingSKUProduct() )
	{
		ItemFlavor entitlementFlav = GetItemFlavorByHumanReadableRef( SKUStore_EntitlementHumanReadableRefs[s_inspectOffers.skuInfo.skuID] )
		string storeLink = Entitlement_GetSKUStoreLink( entitlementFlav )
		if ( storeLink != "" )
			ViewEntitlementInStoreOverlay( storeLink )

		return
	}

	GRXScriptOffer offer = s_inspectOffers.currentOffers[0]

	if ( s_inspectOffers.isOwnedItemEquippable && offer.output.flavors.len() == 1 )
	{
		StoreInspectMenu_EquipOwnedItem( offer.output.flavors[0] )
		return
	}

	PurchaseDialogConfig pdc
	pdc.offer = offer
	pdc.quantity = 1
	PurchaseDialog( pdc )
}

void function StoreInspectMenu_EquipOwnedItem( ItemFlavor itemFlavToEquip )
{
	int itemType = ItemFlavor_GetType( itemFlavToEquip )
	array<LoadoutEntry> entry = EquipButton_GetItemLoadoutEntries( itemFlavToEquip, false )

	if ( entry.len() != 1 )
		return

	EmitUISound( "UI_Menu_Equip_Generic" )
	array<LoadoutEntry> entries = EquipButton_GetItemLoadoutEntries( itemFlavToEquip, false )
	RequestSetItemFlavorLoadoutSlot_WithDuplicatePrevention( LocalClientEHI(), entries, itemFlavToEquip, 0 )
	Newness_IfNecessaryMarkItemFlavorAsNoLongerNewAndInformServer( itemFlavToEquip )
	PIN_Customization( null, itemFlavToEquip, "equip", 0 )

	var rui = Hud_GetRui( file.purchaseButton )
	RuiSetString( rui, "buttonText", "#EQUIPPED_LOOT_REWARD" )
	RuiSetString( rui, "buttonDescText", Localize( "#CURRENTLY_EQUIPPED_ITEM", Localize( ItemFlavor_GetLongName( itemFlavToEquip ) ) ) )
	Hud_SetLocked( file.purchaseButton, true )
}

void function StoreInspectMenu_SetStoreOfferData( array<GRXScriptOffer> storeOffers )
{
	s_inspectOffers.currentOffers.clear()
	foreach( GRXScriptOffer offer in storeOffers )
		s_inspectOffers.currentOffers.append( offer )

	GRXScriptOffer storeOffer = s_inspectOffers.currentOffers[0]

	Assert( storeOffer.output.flavors.len() == storeOffer.output.quantities.len() )

	s_inspectOffers.itemCount = storeOffer.output.flavors.len()

	Assert( s_inspectOffers.itemCount > 0 )

	Hud_SetVisible( file.itemGrid, s_inspectOffers.itemCount > 1 )
	Hud_SetVisible( file.itemInfo, s_inspectOffers.itemCount > 1 )
}

void function StoreInspectMenu_SetSKUPurchaseInfo( string currentPrice, string originalPrice, int skuID )
{
	printf( "StoreInspectMenu_SetSKUPurchaseInfo currentPrice: %s, originalPrice: %s, skuID: %i", currentPrice, originalPrice, skuID )
	s_inspectOffers.skuInfo.currentPrice = currentPrice
	s_inspectOffers.skuInfo.originalPrice = originalPrice
	s_inspectOffers.skuInfo.skuID = skuID
}

bool function StoreInspectMenu_IsItemPresentationSupported( ItemFlavor itemFlav )
{
	//
	switch ( ItemFlavor_GetType( itemFlav ) )
	{
		case eItemType.account_pack:
		case eItemType.apex_coins:
		case eItemType.character:
		case eItemType.character_skin:
		case eItemType.weapon_skin:
		case eItemType.weapon_charm:
		case eItemType.gladiator_card_stance:
		case eItemType.gladiator_card_frame:
		case eItemType.gladiator_card_badge:
		case eItemType.gladiator_card_intro_quip:
		case eItemType.gladiator_card_kill_quip:
			return true
	}

	printf( "Offer has item '%s' [eItemType: %d] which is currently unsupported in bundle inspect view.",
		ItemFlavor_GetHumanReadableRef( itemFlav ), ItemFlavor_GetType( itemFlav ) )
	return false
}

void function StoreInspectMenu_AttemptOpenWithOffer( GRXScriptOffer offer )
{
	bool canAllItemsBePresented = true
	foreach( ItemFlavor flav in offer.output.flavors )
	{
		if( !StoreInspectMenu_IsItemPresentationSupported( flav ) )
		{
			canAllItemsBePresented = false
			break
		}
	}

	if ( canAllItemsBePresented )
	{
		StoreInspectMenu_SetStoreOfferData( [offer] )
		AdvanceMenu( GetMenu( "StoreInspectMenu" ) )
	}
	else
	{
		PurchaseDialogConfig pdc
		pdc.offer = offer
		pdc.quantity = 1
		PurchaseDialog( pdc )
	}
}

bool function IsPresentingSKUProduct()
{
	return s_inspectOffers.skuInfo.skuID >= 0
}

#if(DEV)
void function DEV_PrintInspectedOffer()
{
	if ( s_inspectOffers.currentOffers.len() == 0 )
	{
		printt( "Must be viewing the store inspect menu to see the inspected offer" )
		return
	}

	GRXScriptOffer offer = s_inspectOffers.currentOffers[0]

	printt( "DEV_PrintInspectedOffer" )
	printt( "------------------------------------" )
	printt( "Name:", Localize( offer.titleText ) )
	printt( "Desc:", Localize( offer.descText ) )
	printt( "Item Count:", s_inspectOffers.itemCount )
	printt( "Offer Type:", offer.offerType == GRX_OFFERTYPE_DEFAULT ? "Default" : "Bundle" )
	printt( "Displayed Price:", s_inspectOffers.displayedPrice )
	printt( "Original Price:", s_inspectOffers.originalPrice )
	printt( "Discount Pct:", s_inspectOffers.discountPct )
	printt( "Limit:", s_inspectOffers.purchaseLimit )
	printt( "IsAvailable:", offer.isAvailable )
	printt( "Unavailable Reason:", Localize( offer.unavailableReason ) )
	printt( "------------------------------------" )
	printt( "Item Flavors:" )
	foreach( ItemFlavor flav in s_inspectOffers.itemFlavors )
	{
		printt( ItemFlavor_GetHumanReadableRef( flav ), "[", ItemFlavor_GetGRXIndex( flav ), "]" )
	}
	printt( "------------------------------------" )

	//
	//
}

void function DEV_DisplayAllInspectElements( bool shouldShow )
{
	Hud_SetVisible( file.itemGrid, shouldShow )
	Hud_SetVisible( file.itemInfo, shouldShow )
	Hud_SetVisible( file.discountInfo, shouldShow )
}

void function DEV_AddFakeItemToOffer( string grxRef )
{
	ItemFlavor flav = GetItemFlavorByHumanReadableRef( grxRef )
	array<GRXScriptOffer> fakeOffers = clone s_inspectOffers.currentOffers
	fakeOffers[0].output.flavors.append( flav )
	fakeOffers[0].output.quantities.append( 1 )
	GRXStoreOfferItem item
	item.itemType = GRX_OFFERITEMTYPE_DEFAULT
	item.itemQuantity = 1
	item.itemIdx = ItemFlavor_GetGRXIndex( flav )
	fakeOffers[0].items.append( item )
	StoreInspectMenu_SetStoreOfferData( fakeOffers )
	StoreInspectMenu_OnGRXUpdated()
	//
	//
}


void function DEV_AddFakeItemsToOffer()
{
	const array<string> fakeGRXRefs =
	[
		"pack_cosmetic_rare",
		//
		//
		"pack_cosmetic_epic",
		"pack_cosmetic_epic",
		"pack_cosmetic_legendary",
		"gcard_frame_crypto_common_02",
		"gcard_frame_revenant_rare_02",
		"gcard_stance_octane_epic_02",
		"gcard_stance_octane_epic_02",
		"character_loba",
		"character_skin_wraith_common_12",
		"character_skin_gibraltar_rare_09",
		"character_skin_revenant_rare_03",
		"character_skin_mirage_rare_02",
		"character_skin_lifeline_epic_02",
		"character_skin_bloodhound_epic_01",
		//
		//
		"character_skin_crypto_legendary_01",
		//
		//
		//
		"weapon_charm_bloodhound_knife",
		//
		"gcard_stance_wraith_heirloom_01",
		"gcard_badge_pathfinder_sku04",
	]

	const int MAX_GRID_ITEMS = ITEM_GRID_ROWS * ITEM_GRID_COLUMNS
	array<GRXScriptOffer> fakeOffers = clone s_inspectOffers.currentOffers
	foreach( string grxRef in fakeGRXRefs )
	{
		if( fakeOffers[0].output.flavors.len() >= MAX_GRID_ITEMS )
			continue

		ItemFlavor flav = GetItemFlavorByHumanReadableRef( grxRef )
		fakeOffers[0].output.flavors.append( flav )
		fakeOffers[0].output.quantities.append( 1 )
		GRXStoreOfferItem item
		item.itemType = GRX_OFFERITEMTYPE_DEFAULT
		item.itemQuantity = 1
		item.itemIdx = ItemFlavor_GetGRXIndex( flav )
		fakeOffers[0].items.append( item )
	}

	StoreInspectMenu_SetStoreOfferData( fakeOffers )
	StoreInspectMenu_OnGRXUpdated()
}
#endif