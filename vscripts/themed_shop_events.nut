//

#if CLIENT || UI 
global function ThemedShopEvents_Init
#endif


#if CLIENT || UI 
global function GetActiveThemedShopEvent
global function ThemedShopEvent_GetChallenges
global function ThemedShopEvent_GetHeaderIcon
#endif

#if(UI)
global function ThemedShopEvent_GetTabText
global function ThemedShopEvent_GetGRXOfferLocation
global function ThemedShopEvent_GetTabBGDefaultCol
global function ThemedShopEvent_GetTabBarDefaultCol
global function ThemedShopEvent_GetTabBGFocusedCol
global function ThemedShopEvent_GetTabBarFocusedCol
global function ThemedShopEvent_GetTabBGSelectedCol
global function ThemedShopEvent_GetTabBarSelectedCol
global function ThemedShopEvent_GetItemButtonBGImage
global function ThemedShopEvent_GetItemGroupHeaderImage
global function ThemedShopEvent_GetItemGroupHeaderText
global function ThemedShopEvent_GetItemGroupHeaderTextColor
global function ThemedShopEvent_GetItemGroupBackgroundImage
global function ThemedShopEvent_GetHeaderTextColor
global function ThemedShopEvent_GetLobbyButtonImage
global function ThemedShopEvent_GetTitleTextColor
global function ThemedShopEvent_HasLobbyTheme
#endif


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

#if CLIENT || UI 
struct FileStruct_LifetimeLevel
{
	table<ItemFlavor, array<ItemFlavor> > eventChallengesMap
}
#endif
#if(CLIENT)
FileStruct_LifetimeLevel fileLevel //
#elseif(UI)
FileStruct_LifetimeLevel& fileLevel //

struct {
	//
} fileVM //
#endif




//
//
//
//
//

#if CLIENT || UI 
void function ThemedShopEvents_Init()
{
	#if(UI)
		FileStruct_LifetimeLevel newFileLevel
		fileLevel = newFileLevel
	#endif

	AddCallback_OnItemFlavorRegistered( eItemType.calevent_themedshop, void function( ItemFlavor ev ) {
		fileLevel.eventChallengesMap[ev] <- RegisterReferencedItemFlavorsFromArray( ev, "challenges", "flavor" )
		foreach ( int challengeSortOrdinal, ItemFlavor challengeFlav in fileLevel.eventChallengesMap[ev] )
			RegisterChallengeSource( challengeFlav, ev, challengeSortOrdinal )
	} )
}
#endif



//
//
//
//
//

#if CLIENT || UI 
ItemFlavor ornull function GetActiveThemedShopEvent( int t )
{
	Assert( IsItemFlavorRegistrationFinished() )
	ItemFlavor ornull event = null
	foreach ( ItemFlavor ev in GetAllItemFlavorsOfType( eItemType.calevent_themedshop ) )
	{
		if ( !CalEvent_IsActive( ev, t ) )
			continue

		Assert( event == null, format( "Multiple themedshop events are active!! (%s, %s)", ItemFlavor_GetHumanReadableRef( expect ItemFlavor(event) ), ItemFlavor_GetHumanReadableRef( ev ) ) )
		event = ev
	}
	return event
}
#endif


#if CLIENT || UI 
array<ItemFlavor> function ThemedShopEvent_GetChallenges( ItemFlavor event )
{
	Assert( ItemFlavor_GetType( event ) == eItemType.calevent_themedshop )

	return fileLevel.eventChallengesMap[event]
}
#endif


#if(UI)
string function ThemedShopEvent_GetTabText( ItemFlavor event )
{
	Assert( ItemFlavor_GetType( event ) == eItemType.calevent_themedshop )
	return GetGlobalSettingsString( ItemFlavor_GetAsset( event ), "tabText" )
}
#endif


#if(UI)
string function ThemedShopEvent_GetGRXOfferLocation( ItemFlavor event )
{
	Assert( ItemFlavor_GetType( event ) == eItemType.calevent_themedshop )
	return GetGlobalSettingsString( ItemFlavor_GetAsset( event ), "grxOfferLocation" )
}
#endif


#if(UI)
vector function ThemedShopEvent_GetTabBGDefaultCol( ItemFlavor event )
{
	Assert( ItemFlavor_GetType( event ) == eItemType.calevent_themedshop )
	return GetGlobalSettingsVector( ItemFlavor_GetAsset( event ), "tabBGDefaultCol" )
}
#endif


#if(UI)
vector function ThemedShopEvent_GetTabBarDefaultCol( ItemFlavor event )
{
	Assert( ItemFlavor_GetType( event ) == eItemType.calevent_themedshop )
	return GetGlobalSettingsVector( ItemFlavor_GetAsset( event ), "tabBarDefaultCol" )
}
#endif


#if(UI)
vector function ThemedShopEvent_GetTabBGFocusedCol( ItemFlavor event )
{
	Assert( ItemFlavor_GetType( event ) == eItemType.calevent_themedshop )
	return GetGlobalSettingsVector( ItemFlavor_GetAsset( event ), "tabBGFocusedCol" )
}
#endif


#if(UI)
vector function ThemedShopEvent_GetTabBarFocusedCol( ItemFlavor event )
{
	Assert( ItemFlavor_GetType( event ) == eItemType.calevent_themedshop )
	return GetGlobalSettingsVector( ItemFlavor_GetAsset( event ), "tabBarFocusedCol" )
}
#endif


#if(UI)
vector function ThemedShopEvent_GetTabBGSelectedCol( ItemFlavor event )
{
	Assert( ItemFlavor_GetType( event ) == eItemType.calevent_themedshop )
	return GetGlobalSettingsVector( ItemFlavor_GetAsset( event ), "tabBGSelectedCol" )
}
#endif


#if(UI)
vector function ThemedShopEvent_GetTabBarSelectedCol( ItemFlavor event )
{
	Assert( ItemFlavor_GetType( event ) == eItemType.calevent_themedshop )
	return GetGlobalSettingsVector( ItemFlavor_GetAsset( event ), "tabBarSelectedCol" )
}
#endif


#if(UI)
asset function ThemedShopEvent_GetItemButtonBGImage( ItemFlavor event, bool isHighlighted )
{
	Assert( ItemFlavor_GetType( event ) == eItemType.calevent_themedshop )
	return GetGlobalSettingsAsset( ItemFlavor_GetAsset( event ), isHighlighted ? "itemBtnHighlightedBGImage" : "itemBtnRegularBGImage" )
}
#endif


#if(UI)
asset function ThemedShopEvent_GetItemGroupHeaderImage( ItemFlavor event, int group )
{
	Assert( ItemFlavor_GetType( event ) == eItemType.calevent_themedshop )
	return GetGlobalSettingsAsset( ItemFlavor_GetAsset( event ), "itemGroup" + string( group ) + "HeaderImage" )
}
#endif


#if(UI)
string function ThemedShopEvent_GetItemGroupHeaderText( ItemFlavor event, int group )
{
	Assert( ItemFlavor_GetType( event ) == eItemType.calevent_themedshop )
	return GetGlobalSettingsString( ItemFlavor_GetAsset( event ), "itemGroup" + string( group ) + "HeaderText" )
}
#endif


#if(UI)
vector function ThemedShopEvent_GetItemGroupHeaderTextColor( ItemFlavor event, int group )
{
	Assert( ItemFlavor_GetType( event ) == eItemType.calevent_themedshop )
	return GetGlobalSettingsVector( ItemFlavor_GetAsset( event ), "itemGroup" + string( group ) + "HeaderTextColor" )
}
#endif


#if(UI)
asset function ThemedShopEvent_GetItemGroupBackgroundImage( ItemFlavor event, int group )
{
	Assert( ItemFlavor_GetType( event ) == eItemType.calevent_themedshop )
	return GetGlobalSettingsAsset( ItemFlavor_GetAsset( event ), "itemGroup" + string( group ) + "BGImage" )
}
#endif


#if(UI)
bool function ThemedShopEvent_HasLobbyTheme( ItemFlavor event )
{
	Assert( ItemFlavor_GetType( event ) == eItemType.calevent_themedshop )
	return GetGlobalSettingsBool( ItemFlavor_GetAsset( event ), "themeLobby" )
}
#endif


#if(UI)
asset function ThemedShopEvent_GetLobbyButtonImage( ItemFlavor event )
{
	Assert( ItemFlavor_GetType( event ) == eItemType.calevent_themedshop )
	return GetGlobalSettingsAsset( ItemFlavor_GetAsset( event ), "lobbyButtonImage" )
}
#endif


#if(UI)
vector function ThemedShopEvent_GetTitleTextColor( ItemFlavor event )
{
	Assert( ItemFlavor_GetType( event ) == eItemType.calevent_themedshop )
	return GetGlobalSettingsVector( ItemFlavor_GetAsset( event ), "seasonTitleColor" )
}
#endif


#if(UI)
vector function ThemedShopEvent_GetHeaderTextColor( ItemFlavor event )
{
	Assert( ItemFlavor_GetType( event ) == eItemType.calevent_themedshop )
	return GetGlobalSettingsVector( ItemFlavor_GetAsset( event ), "seasonHeaderColor" )
}
#endif

#if CLIENT || UI 
asset function ThemedShopEvent_GetHeaderIcon( ItemFlavor event )
{
	Assert( ItemFlavor_GetType( event ) == eItemType.calevent_themedshop )
	return GetGlobalSettingsAsset( ItemFlavor_GetAsset( event ), "headerIcon" )
}
#endif


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


