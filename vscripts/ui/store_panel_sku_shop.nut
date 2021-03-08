global function SKUShopPanel_Init
#if(DEV)
global function DEV_SKUShopPanel_PrintAll
#endif

global const array<string> SKUStore_EntitlementHumanReadableRefs =
[
	"entitlement_champion_sku_pack",
                   
                               
      
	"entitlement_gibraltar_sku_pack",
	"entitlement_pathfinder_sku_pack",
	"entitlement_octane_sku_pack",
	"entitlement_bloodhound_sku_pack",
	"entitlement_lifeline_sku_pack",
	"entitlement_bloodhound_lifeline_sku_pack",
]

enum SKU_ID
{
	CHAMPION,
                   
        
      
	GIBRALTAR,
	PATHFINDER,
	OCTANE,
	BLOODHOUND,
	LIFELINE,
	BLOODHOUND_LIFELINE,

	COUNT,
}

//
const array<int> SKUStore_EntitlementEnums =
[
	CHAMPION_SKU,
                   
            
      
	GIBRALTAR_SKU,
	PATHFINDER_SKU,
	OCTANE_SKU,
	BLOODHOUND_SKU,
	LIFELINE_SKU,
	BLOODHOUND_LIFELINE_PACK,
]

const int NUM_GRID_ROWS = 1
const int NUM_GRID_COLS = 4

struct SKUData
{
	asset image
	string name
	string desc
	string link
	string currentPrice
	string originalPrice
	int entitlementEnum
	bool isVisible
}

struct
{
	var				panel
	var				skuButtonList
	var				infoBox
	array<string>	currentPrices
	array<string>	originalPrices
	table<int, SKUData> enumToSKUData
	table<var, int> skuButtonToSKUID
	int				numVisibleSKUs
} file


void function SKUShopPanel_Init( var panel )
{
	file.panel = panel

	AddPanelEventHandler( panel, eUIEvent.PANEL_SHOW, SKUShopPanel_OnShow )
	AddPanelEventHandler( panel, eUIEvent.PANEL_HIDE, SKUShopPanel_OnHide )

	file.skuButtonList = Hud_GetChild( panel, "SKUButtonList" )
	file.infoBox = Hud_GetChild( panel, "InfoBox" )
	HudElem_SetRuiArg( file.infoBox, "headerText", "#SKU_STORE_HEADER_DESC" )

	AddPanelFooterOption( panel, LEFT, BUTTON_B, true, "#B_BUTTON_BACK", "#B_BUTTON_BACK" )
}


void function SKUShopPanel_OnShow( var panel )
{
	UI_SetPresentationType( ePresentationType.WEAPON_CATEGORY )
	file.numVisibleSKUs = 0

	for( int i = 0; i < SKU_ID.COUNT; i++ )
	{
		ItemFlavor entitlementFlav = GetItemFlavorByHumanReadableRef( SKUStore_EntitlementHumanReadableRefs[i] )

		SKUData data
		if ( SKUShopPanel_GetEntitlementVisibility( entitlementFlav ) )
		{
			data.name = Entitlement_GetSKUStoreTitle( entitlementFlav )
			data.desc = Entitlement_GetSKUStoreDesc( entitlementFlav )
			data.link = Entitlement_GetSKUStoreLink( entitlementFlav )
			data.entitlementEnum = Entitlement_GetEntitlementEnumVal( entitlementFlav )
			data.image = Entitlement_GetSKUStoreImage( entitlementFlav )
			data.isVisible = true
			file.numVisibleSKUs++
		}
		else
		{
			data.isVisible = false
		}
		file.enumToSKUData[i] <- data
	}

	SKUShopPanel_UpdateGRXDependentElements()
	OnOpenDLCStore()
}

void function SKUShopPanel_OnHide( var panel )
{
	RunClientScript( "UIToClient_StopBattlePassScene" )
	OnCloseDLCStore()
}

void function SKUShopPanel_UpdateGRXDependentElements()
{
	printt( "SKUShopPanel_UpdateGRXDependentElements" )
	Hud_InitGridButtonsDetailed( file.skuButtonList, file.numVisibleSKUs, NUM_GRID_ROWS, NUM_GRID_COLS )
	var scrollPanel = Hud_GetChild( file.skuButtonList, "ScrollPanel" )

	foreach ( skuButton, skuID in file.skuButtonToSKUID )
	{
		Hud_RemoveEventHandler( skuButton, UIE_CLICK, SKUShopPanel_GridButtonOnActivate )
	}
	file.skuButtonToSKUID.clear()

	array<string> currentPrices = GetEntitlementPricesAsStr( SKUStore_EntitlementEnums )
	array<string> originalPrices = GetEntitlementOriginalPricesAsStr( SKUStore_EntitlementEnums )

	//
	//
	//
	//

	Assert( currentPrices.len() == originalPrices.len() )

	for( int i = 0; i < currentPrices.len(); i++ )
	{
		if ( !file.enumToSKUData[i].isVisible )
			continue

		if ( currentPrices[i] != "" )
		{
			file.enumToSKUData[i].currentPrice = currentPrices[i]
			file.enumToSKUData[i].originalPrice = originalPrices[i]
		}
		else
		{
			file.enumToSKUData[i].currentPrice = "#SKU_STORE_PRICE_NOT_FOUND"
			file.enumToSKUData[i].originalPrice = ""
		}
	}

	int buttonIdx = 0
	for ( int skuID; skuID < SKU_ID.COUNT; skuID++ )
	{
		if ( !file.enumToSKUData[skuID].isVisible )
			continue

		var skuButton = Hud_GetChild( scrollPanel, "GridButton" + buttonIdx )

		SKUData sku = file.enumToSKUData[skuID]
		file.skuButtonToSKUID[skuButton] <- skuID
		buttonIdx++

		ItemFlavor entitlementFlav = GetItemFlavorByHumanReadableRef( SKUStore_EntitlementHumanReadableRefs[skuID] )
		bool isOwned = Entitlement_IsSKUBundleOwned( sku.entitlementEnum, entitlementFlav )
		Hud_SetLocked( skuButton, isOwned )

		HudElem_SetRuiArg( skuButton, "itemName", sku.name )
		HudElem_SetRuiArg( skuButton, "itemPrice", isOwned ? "#OWNED" : sku.currentPrice )
		HudElem_SetRuiArg( skuButton, "originalPrice", isOwned ? "" : sku.originalPrice )
		HudElem_SetRuiArg( skuButton, "isOwned", isOwned )
		RuiSetImage( Hud_GetRui( skuButton ), "itemImg", sku.image )

		Hud_AddEventHandler( skuButton, UIE_CLICK, SKUShopPanel_GridButtonOnActivate )
	}
}

void function AddItemFlavToSKUOffer( GRXScriptOffer offer, ItemFlavor itemFlav, bool isApexCoinsFlav )
{
	if( StoreInspectMenu_IsItemPresentationSupported( itemFlav ) )
	{
		printt( "adding grxRef:", ItemFlavor_GetHumanReadableRef( itemFlav ) )
		offer.output.flavors.append( itemFlav )
		offer.output.quantities.append( 1 )

		GRXStoreOfferItem item
		item.itemType = GRX_OFFERITEMTYPE_DEFAULT
		if ( isApexCoinsFlav )
		{
			item.itemQuantity = int( Entitlement_GetSKUStoreApexCoinAmount( itemFlav ) )
			item.itemIdx = -1
		}
		else
		{
			item.itemQuantity = 1
			item.itemIdx = ItemFlavor_GetGRXIndex( itemFlav )
		}
		offer.items.append( item )
	}
	else
	{
		printt( "item is unsupported right now, skipping for now, support will be added later. item:", ItemFlavor_GetHumanReadableRef( itemFlav ) )
	}
}

void function SKUShopPanel_GridButtonOnActivate( var button )
{
	if ( Hud_IsLocked( button ) )
	{
		EmitUISound( "menu_deny" )
		return
	}

	int skuID = file.skuButtonToSKUID[button]
	SKUData sku = file.enumToSKUData[skuID]
	printt( "SKUShopPanel_GridButtonOnActivate ", skuID )

	Assert( sku.isVisible, "Clicked on a SKU Product that wasn't visible." )

	//
	GRXScriptOffer offer
	offer.titleText = sku.name
	offer.descText = sku.desc

	ItemFlavor entitlementFlav = GetItemFlavorByHumanReadableRef( SKUStore_EntitlementHumanReadableRefs[skuID] )
	foreach ( var block in IterateSettingsAssetArray( ItemFlavor_GetAsset( entitlementFlav ), "list" ) )
	{
		ItemFlavor itemFlav = GetItemFlavorByAsset( GetSettingsBlockAsset( block, "flavor" ) )
		AddItemFlavToSKUOffer( offer, itemFlav, false )
	}

	if( offer.items.len() > 1 )
		offer.items.sort( SortStoreOfferItems )

	ItemFlavor ornull apexCoinsFlav = Entitlement_GetSKUStoreApexCoinFlav( entitlementFlav )
	if( apexCoinsFlav != null )
	{
		expect ItemFlavor( apexCoinsFlav )
		AddItemFlavToSKUOffer ( offer, apexCoinsFlav, true )
	}
	else
	{
		printt( "This SKU product does not contain any apex coins. Be sure to add coins to the entitlement bakery data." )
	}

	StoreInspectMenu_SetSKUPurchaseInfo( sku.currentPrice, sku.originalPrice, skuID )
	StoreInspectMenu_AttemptOpenWithOffer( offer )
}

bool function SKUShopPanel_GetEntitlementVisibility( ItemFlavor flav )
{
	ItemFlavor ornull calEvent = Entitlement_GetSKUStoreCalEvent( flav )
	if( calEvent == null )
		return true //

	if ( CalEvent_IsActive( expect ItemFlavor( calEvent ), GetUnixTimestamp() ) )
		return true

	return false
}

#if(DEV)
void function DEV_SKUShopPanel_PrintAll()
{
	if ( file.enumToSKUData.len() == 0 )
	{
		printt( "Must be in the Store > Editions tab to use these debug prints!" )
		return
	}

	for ( int skuID = 0; skuID < SKU_ID.COUNT; skuID++ )
	{
		SKUData sku = file.enumToSKUData[skuID]
		printt( "-----------------------------------------", skuID )
		printt( "Name: ", sku.name )
		printt( "Link: ", sku.link )
		printt( "Current Price: ", sku.currentPrice )
		printt( "Original Price: ", sku.originalPrice )
		printt( "Entitlement Enum: ", sku.entitlementEnum )
	}
	printt( "----------------------------------------- END" )
}
#endif