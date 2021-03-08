global function InitPromoData
global function UpdatePromoData
global function IsPromoDataProtocolValid
global function GetPromoDataVersion
global function GetPromoDataLayout
global function GetPromoImage

global function GetPromoRpakName
global function GetMiniPromoRpakName
global function OpenPromoLink

global function UICodeCallback_MainMenuPromosUpdated

#if(DEV)
global function DEV_PrintPromoData
#endif //

//
//
const int PROMO_PROTOCOL = 2

struct
{
	MainMenuPromos&      promoData
	table<string, asset> imageMap
} file

string function GetPromoRpakName()
{
	return file.promoData.promoRpak
}

string function GetMiniPromoRpakName()
{
	return file.promoData.miniPromoRpak
}

void function InitPromoData()
{
	RequestMainMenuPromos() //

	var dataTable = GetDataTable( $"datatable/promo_images.rpak" )
	for ( int i = 0; i < GetDatatableRowCount( dataTable ); i++ )
	{
		string name = GetDataTableString( dataTable, i, GetDataTableColumnByName( dataTable, "name" ) ).tolower()
		asset image = GetDataTableAsset( dataTable, i, GetDataTableColumnByName( dataTable, "image" ) )
		if ( name != "" )
			file.imageMap[name] <- image
	}
}


void function UpdatePromoData()
{
	#if(DEV)
		if ( GetConVarBool( "mainMenuPromos_scriptUpdateDisabled" ) )
			return
	#endif //
	file.promoData = GetMainMenuPromos()
	PromoDialog_InitPages()
}


void function UICodeCallback_MainMenuPromosUpdated()
{
	printt( "UICodeCallback_MainMenuPromosUpdated" )

	UpdatePromoData()
}


bool function IsPromoDataProtocolValid()
{
	return file.promoData.prot == PROMO_PROTOCOL
}


int function GetPromoDataVersion()
{
	return file.promoData.version
}


string function GetPromoDataLayout()
{
	return file.promoData.layout
}


asset function GetPromoImage( string identifier )
{
	identifier = identifier.tolower()

	asset image
	if ( identifier in file.imageMap )
		image = file.imageMap[identifier]
	else
		image = $"rui/promo/apex_title_blue"

	return image
}

#if(DEV)
void function DEV_PrintPromoData()
{
	printt( "protocol:      ", file.promoData.prot )
	printt( "version:       ", file.promoData.version )
	printt( "promoRpak:     ", file.promoData.promoRpak )
	printt( "miniPromoRpak: ", file.promoData.miniPromoRpak )
	printt( "layout:        ", file.promoData.layout )
}
#endif //

void function OpenPromoLink( string linkType, string link )
{
	if ( linkType == "battlepass" )
	{
		EmitUISound( "UI_Menu_Accept" )
		JumpToSeasonTab( "PassPanel" )
	}
	else if ( linkType == "storecharacter" )
	{
		ItemFlavor character = GetItemFlavorByHumanReadableRef( link )
		if ( GRX_IsItemOwnedByPlayer( character ) )
			return

		EmitUISound( "UI_Menu_Accept" )
		JumpToStoreCharacter( character )
	}
	else if ( linkType == "storeskin" )
	{
		ItemFlavor skin = GetItemFlavorByHumanReadableRef( link )
		if ( GRX_IsItemOwnedByPlayer( skin ) )
			return

		EmitUISound( "UI_Menu_Accept" )
		JumpToStoreSkin( skin )
	}
	else if ( linkType == "themedstoreskin" )
	{
		ItemFlavor skin = GetItemFlavorByHumanReadableRef( link )
		if ( GRX_IsItemOwnedByPlayer( skin ) )
			return

		EmitUISound( "UI_Menu_Accept" )
		JumpToSeasonTab( "ThemedShopPanel" )
	}
	else if ( linkType == "collectionevent" )
	{
		ItemFlavor item = GetItemFlavorByHumanReadableRef( link )
		if ( GRX_IsItemOwnedByPlayer( item ) )
			return

		EmitUISound( "UI_Menu_Accept" )
		JumpToSeasonTab( "CollectionEventPanel" )
	}
	else if ( linkType == "url" )
	{
		EmitUISound( "UI_Menu_Accept" )
		LaunchExternalWebBrowser( link, WEBBROWSER_FLAG_NONE )
	}
	else if ( linkType == "product" )
	{
		EmitUISound( "UI_Menu_Accept" )
		ViewEntitlementInStoreOverlay( link )
	}
	else if ( linkType == "storeoffer" )
	{
		EmitUISound( "UI_Menu_Accept" )
		JumpToStoreOffer( link )
	}
}