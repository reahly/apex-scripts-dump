global function CharacterLoadouts_Init
global function CharacterLoadouts_GetWeaponLoadoutArray
global function CharacterLoadouts_GetConsumableLoadoutArray
global function CharacterLoadouts_GetEquipmentLoadoutArray
global function CharacterLoadouts_SetIdenticalLoadoutIndex


#if(false)

#endif

struct {
	table< string, array<string> >                 characterFlavorToWeaponLoadout
	table< string, table<string, array<string> > > characterWeaponToAttachmentArray
	table< string, array<string> >                 characterFlavorToConsumableLoadout
	table< string, array<string> >                 characterFlavorToEquipmentLoadout

	array<string>								   weaponLoadoutDefault
	array<string>								   consumableLoadoutDefault
	array<string>								   equipmentLoadoutDefault
	array<string>								   loadoutDisplayIgnoreItemsDefault

	table< string, array<string> >				   characterFlavorToDisplayedWeaponLoadout
	table< string, array<string> >                 characterFlavorToDisplayedConsumableLoadout
	table< string, array<string> >                 characterFlavorToDisplayedEquipmentLoadout

	int identicalLoadoutIndex = -1

	#if(CLIENT)
		var           loadoutInfoRui = null
		array<var>    loadoutRuiElements

		bool		  isDetailsPanelShowing = false
		bool          is16x10 = false
	#endif
} file




void function CharacterLoadouts_Init()
{
	if ( !IsCharacterLoadoutsEnabled() )
		return

	if ( GetCurrentPlaylistVarBool( "character_loadouts_identical", false ) )
		CharacterLoadouts_SetIdenticalLoadoutIndex( 0 ) //

	SetDefaultLoadouts()

	PopulateCharacterLoadouts()

	#if(false)


#endif

	#if(CLIENT)
		file.loadoutInfoRui = RuiCreate( $"ui/loadout_selection_info.rpak", clGlobal.topoFullScreen, RUI_DRAW_HUD, 1 )

		AddCallback_OnCharacterSelectMenuOpened( Callback_OnCharacterSelectOpened )
		AddCallback_OnCharacterSelectMenuClosed( Callback_OnCharacterSelectClosed )
		AddCallback_CharacterSelectMenu_OnCharacterFocused( Callback_OnCharacterFocusChanged )
		AddCallback_CharacterSelectMenu_OnCharacterLocked( Callback_OnCharacterLocked )
		AddCallback_OnCharacterSelectDetailsToggled( Callback_OnCharacterDetailsToggled )
	#endif
}

void function SetDefaultLoadouts()
{
	file.weaponLoadoutDefault 					= []
	file.consumableLoadoutDefault 				= []
	file.equipmentLoadoutDefault				= []
	file.loadoutDisplayIgnoreItemsDefault 		= []
}


bool function IsCharacterLoadoutsEnabled()
{
	if ( !GetCurrentPlaylistVarBool( "character_loadouts_enabled", true ) )
		return false

	int startTime = expect int( GetCurrentPlaylistVarTimestamp( "character_loadouts_enabled_unixTimeStart", UNIX_TIME_FALLBACK_2038 ) )
	int endTime   = expect int( GetCurrentPlaylistVarTimestamp( "character_loadouts_enabled_unixTimeEnd", UNIX_TIME_FALLBACK_2038 ) )

	if ( startTime != UNIX_TIME_FALLBACK_2038 )
	{
		int unixTimeNow = GetUnixTimestamp()
		if ( (unixTimeNow >= startTime) && (unixTimeNow < endTime) )
		{
			return true
		}
		else
		{
			return false
		}
	}

	return true
}


void function CharacterLoadouts_SetIdenticalLoadoutIndex( int index )
{
	//
	//
	//
	//
	//

	Assert( index > -1 )
	file.identicalLoadoutIndex = index
}

string function GetCharacterLoadoutRef( string characterRef )
{
	array<ItemFlavor> characterList = clone GetAllCharacters()
	characterList.sort( SortByMenuButtonIndex )

	//
	//
	//
	table<string, int> characterDefaultLoadoutList
	for( int i = 0; i<characterList.len(); i++ )
	{
		characterDefaultLoadoutList[ ItemFlavor_GetHumanReadableRef( characterList[i] ).tolower() ] <- i
	}

	int characterLoadoutRefInt = 0 //
	if ( GetCurrentPlaylistVarBool( "character_loadouts_identical", false ) )
	{
		Assert( file.identicalLoadoutIndex != -1, "Need to call CharacterLoadouts_SetIdenticalLoadoutIndex() to define character loadout for match" )
		characterLoadoutRefInt = file.identicalLoadoutIndex
		return characterLoadoutRefInt.tostring()
	}
	else if ( characterRef in characterDefaultLoadoutList )
	{
		characterLoadoutRefInt = characterDefaultLoadoutList[ characterRef ]
	}

	//
	//
	//
	string unixTimeEventStartString = GetCurrentPlaylistVarString( "character_loadouts_daily_cycle_start_date", "" )
	if ( unixTimeEventStartString != "" )
	{
		int unixTimeNow = GetUnixTimestamp()
		int ornull unixTimeEventStart = DateTimeStringToUnixTimestamp( unixTimeEventStartString )
		if ( unixTimeEventStart == null )
		{
			Assert( 0, format( "Bad format in playlist for setting 'character_loadouts_daily_cycle_start_date': '%s'", unixTimeEventStartString ) )
			return characterLoadoutRefInt.tostring()
		}

		int maxCharacterLoadouts
		for( int i = 0; i<100; i++ )
		{
			string testVal = GetCurrentPlaylistVarString( "character_loadout_weapons_" + i, "NULL" )
			if ( testVal == "NULL" )
			{
				maxCharacterLoadouts = i
				break
			}
		}

		expect int( unixTimeEventStart )
		if ( unixTimeNow > unixTimeEventStart ) //
		{
			int unixTimeSinceEventStarted = ( unixTimeNow - unixTimeEventStart )
			int daysSinceEventStarted =  int( floor( unixTimeSinceEventStarted / SECONDS_PER_DAY ) )
			//
			characterLoadoutRefInt = ( ( characterLoadoutRefInt + daysSinceEventStarted ) % maxCharacterLoadouts )
		}
	}

	return characterLoadoutRefInt.tostring()
}


void function PopulateCharacterLoadouts()
{
	array<ItemFlavor> characterList = GetAllCharacters()
	foreach( character in characterList )
	{
		string characterRef = ItemFlavor_GetHumanReadableRef( character ).tolower()
		string characterLoadoutRef = GetCharacterLoadoutRef( characterRef )
		printf( "CHARACTER LOADOUT: Populating info for characterRef " + characterRef + " with matching loadout ref " + characterLoadoutRef )
		string weaponLoadoutsPlaylist    = GetCurrentPlaylistVarString( "character_loadout_weapons_" + characterLoadoutRef, "" )
		string consumableLoadoutPlaylist = GetCurrentPlaylistVarString( "character_loadout_consumables_" + characterLoadoutRef, "" )
		string equipmentLoadoutPlaylist  = GetCurrentPlaylistVarString ( "character_loadout_equipment_" + characterLoadoutRef, "" )
		bool useDefaultLoadout = GetCurrentPlaylistVarBool( "character_loadout_use_default", true )

		string displayIgnoreItemsRaw = GetCurrentPlaylistVarString ( "character_loadout_display_ignore_items", "" )
		array<string> displayIgnoredItems
		if ( displayIgnoreItemsRaw != "" )
			displayIgnoredItems = GetTrimmedSplitString( displayIgnoreItemsRaw, " " )
		else if ( !GetCurrentPlaylistVarBool( "character_loadout_ignore_default", false ) )
			displayIgnoredItems = file.loadoutDisplayIgnoreItemsDefault

		//
		array<string> equipmentToAdd = []
		if ( equipmentLoadoutPlaylist != "" )
			equipmentToAdd = GetTrimmedSplitString( equipmentLoadoutPlaylist, " " )
		else if ( useDefaultLoadout )
			equipmentToAdd = file.equipmentLoadoutDefault
                      
		if ( GetCurrentPlaylistVarBool( "should_give_lvl0_evo_armor", true ) )
		{
			bool give0Armor = true
			foreach ( string equipmentRef in equipmentToAdd )
			{
				if ( SURVIVAL_Loot_GetLootDataByRef( equipmentRef ).lootType == eLootType.ARMOR )
				{
					give0Armor = false
					break
				}
			}
			if ( give0Armor )
			{
				equipmentToAdd.append( "armor_pickup_lv0_evolving" )
				displayIgnoredItems.append( "armor_pickup_lv0_evolving" )
			}
		}
      
		file.characterFlavorToEquipmentLoadout[characterRef] <- equipmentToAdd
		array<string> equipmentToDisplay = []
		foreach ( string equipment in equipmentToAdd )
		{
			if ( !displayIgnoredItems.contains( equipment ) )
				equipmentToDisplay.append( equipment )
		}
		file.characterFlavorToDisplayedEquipmentLoadout[characterRef] <- equipmentToDisplay


		//
		array<string> weaponLoadout = []
		if ( weaponLoadoutsPlaylist != "" )
			weaponLoadout = GetTrimmedSplitString( weaponLoadoutsPlaylist, " " )
		else if ( useDefaultLoadout )
			weaponLoadout = file.weaponLoadoutDefault
		array<string> weaponsToAdd
		array<string> weaponsToDisplay
		table< string, array<string> > attachmentMatrixForWeapon
		foreach( weapon in weaponLoadout )
		{
			array<string> weaponTokens = GetTrimmedSplitString( weapon, ":" )
			string weaponRef           = weaponTokens[0]
			weaponsToAdd.append( weaponRef )
			if ( !displayIgnoredItems.contains( weaponRef ) )
				weaponsToDisplay.append( weaponRef )

			weaponTokens.remove( 0 )
			array<string> attachmentsToAdd = weaponTokens

			attachmentMatrixForWeapon[weaponRef] <- attachmentsToAdd
		}

		file.characterFlavorToWeaponLoadout[characterRef] <- weaponsToAdd
		file.characterWeaponToAttachmentArray[characterRef] <- attachmentMatrixForWeapon
		file.characterFlavorToDisplayedWeaponLoadout[characterRef] <- weaponsToDisplay


		//
		array<string> consumableTokens = []
		if ( consumableLoadoutPlaylist != "" )
			consumableTokens = GetTrimmedSplitString( consumableLoadoutPlaylist, " " )
		else if ( useDefaultLoadout )
			consumableTokens = file.consumableLoadoutDefault
		array<string> consumablesToAdd
		array<string> consumablesToDisplay
		foreach( itemType in consumableTokens )
		{
			array<string> tokens = GetTrimmedSplitString( itemType, ":" )
			string itemRef       = tokens[0]
			int numItems         = int( tokens[1] )

			for ( int i = 0; i < numItems; i++ )
			{
				consumablesToAdd.append( itemRef )
				if ( !displayIgnoredItems.contains( itemRef ) )
					consumablesToDisplay.append( itemRef )
			}
		}
		file.characterFlavorToConsumableLoadout[characterRef] <- consumablesToAdd
		file.characterFlavorToDisplayedConsumableLoadout[characterRef] <- consumablesToDisplay
	}

	printf( "CHARACTER LOADOUTS: Character Loadouts populated" )
}


#if(false)





































#endif


#if(false)
















































































//













//






















































//
//
















#endif


#if(CLIENT)
void function Callback_OnCharacterSelectOpened()
{
	file.is16x10 = GetNearestAspectRatio( GetScreenSize().width, GetScreenSize().height ) == 1.6

	RuiSetBool( file.loadoutInfoRui, "isVisible", true )
	RuiSetBool( file.loadoutInfoRui, "is16x10", file.is16x10 )

	ItemFlavor character = LoadoutSlot_GetItemFlavor( ToEHI( GetLocalClientPlayer() ), Loadout_Character() )
	DisplayLoadoutForCharacter( character )
}

void function Callback_OnCharacterSelectClosed()
{
	RuiSetBool( file.loadoutInfoRui, "isVisible", false )

	foreach( ruiAsset in file.loadoutRuiElements )
	{
		RuiDestroy( ruiAsset )
	}
	file.loadoutRuiElements.clear()

}

void function Callback_OnCharacterFocusChanged( ItemFlavor character )
{
	DisplayLoadoutForCharacter( character )
}

void function Callback_OnCharacterLocked( ItemFlavor character )
{
	DisplayLoadoutForCharacter( character )
}

void function Callback_OnCharacterDetailsToggled( bool isDetailsPanelVisible )
{
	if ( file.loadoutInfoRui == null )
		return

	file.isDetailsPanelShowing = !isDetailsPanelVisible

	RuiSetBool( file.loadoutInfoRui, "isDetailMode", !isDetailsPanelVisible )
	foreach( rui in file.loadoutRuiElements )
	{
		RuiSetBool( rui, "isDetailMode", !isDetailsPanelVisible )
	}
}

string function GetIdenticalLoadoutCharSelectPrefix()
{
	string playlistName = GetCurrentPlaylistName()
	if ( playlistName.find( "freelance" ) >= 0 )
		return ""

	return Localize( "#DEFAULT_CHAR_SELECT_LOADOUT_PREFIX" )
}

void function DisplayLoadoutForCharacter( ItemFlavor character )
{
	string characterRef = ItemFlavor_GetHumanReadableRef( character ).tolower()

	//
	foreach( ruiAsset in file.loadoutRuiElements )
	{
		RuiDestroy( ruiAsset )
	}
	file.loadoutRuiElements.clear()

	bool shouldShowLoadout = file.characterFlavorToDisplayedWeaponLoadout[characterRef].len() > 0 ||
	file.characterFlavorToDisplayedConsumableLoadout[characterRef].len() > 0 ||
	file.characterFlavorToDisplayedEquipmentLoadout[characterRef].len() > 0

	//
	if ( !shouldShowLoadout )
	{
		RuiSetBool( file.loadoutInfoRui, "isVisible", false )
		return
	}
	else
	{
		RuiSetBool( file.loadoutInfoRui, "isVisible", true )
	}

	if ( GetCurrentPlaylistVarBool( "character_loadouts_identical", false ) )
		RuiSetString( file.loadoutInfoRui, "characterLoadoutName", GetIdenticalLoadoutCharSelectPrefix() )
	else
		RuiSetString( file.loadoutInfoRui, "characterLoadoutName", Localize( "#" + characterRef + "_NAME" ) )

	//
	for ( int i = 0; i < file.characterFlavorToDisplayedWeaponLoadout[characterRef].len(); i++ )
	{
		string weaponRef    = file.characterFlavorToDisplayedWeaponLoadout[characterRef][i]
		LootData weaponData = SURVIVAL_Loot_GetLootDataByRef( weaponRef )
		var weaponRuiAsset  = RuiCreate( $"ui/loadout_selection_icon_weapon.rpak", clGlobal.topoFullScreen, RUI_DRAW_HUD, 1 )

		RuiSetBool( weaponRuiAsset, "isDetailMode", file.isDetailsPanelShowing )
		RuiSetAsset( weaponRuiAsset, "iconImage", weaponData.hudIcon )
		RuiSetInt( weaponRuiAsset, "weaponIndex", i )
		if ( ShouldShrinkWeaponIcon( weaponRef ) )
			RuiSetFloat2( weaponRuiAsset, "iconSize", <150, 75, 0.0> )

		string ammoRef = GetWeaponAmmoType( weaponRef )
		if ( ammoRef != "" )
		{
			//
			LootData ammoData = SURVIVAL_Loot_GetLootDataByRef( ammoRef )
			RuiSetAsset( weaponRuiAsset, "ammoImage", ammoData.hudIcon )
		}

		RuiSetString( weaponRuiAsset, "weaponName", Localize( "#WPN_" + weaponData.baseWeapon.slice(10) + "_SHORT" ) )

		file.loadoutRuiElements.append( weaponRuiAsset )

		//
		array<string> attachmentRefs
		if( !SURVIVAL_Weapon_IsAttachmentLocked ( weaponRef ) )
		{
			attachmentRefs = file.characterWeaponToAttachmentArray[characterRef][weaponRef]
		}
		else
		{
			attachmentRefs = SURVIVAL_Weapon_GetBaseMods( weaponRef )
		}
		int attachmentSlot = 0
		for ( int j = 0; j < attachmentRefs.len(); j++ )
		{
			if ( !SURVIVAL_Loot_IsRefValid( attachmentRefs[j] ) )
				continue
			LootData attachmentData = SURVIVAL_Loot_GetLootDataByRef( attachmentRefs[j] )
			var attachmentRuiAsset  = RuiCreate( $"ui/loadout_selection_icon_attachment.rpak", clGlobal.topoFullScreen, RUI_DRAW_HUD, 1 )

			RuiSetBool( attachmentRuiAsset, "isDetailMode", file.isDetailsPanelShowing )
			RuiSetAsset( attachmentRuiAsset, "iconImage", attachmentData.hudIcon )
			RuiSetInt( attachmentRuiAsset, "attachmentIndex", attachmentSlot )
			RuiSetInt( attachmentRuiAsset, "weaponIndex", i )
			RuiSetInt( attachmentRuiAsset, "lootTier", attachmentData.tier )

			attachmentSlot++

			file.loadoutRuiElements.append( attachmentRuiAsset )
		}
	}

	//
	for ( int i = 0; i < file.characterFlavorToDisplayedEquipmentLoadout[characterRef].len(); i++ )
	{
		string equipmentRef    = file.characterFlavorToDisplayedEquipmentLoadout[characterRef][i]
		LootData equipmentData = SURVIVAL_Loot_GetLootDataByRef( equipmentRef )
		var equipmentRuiAsset  = RuiCreate( $"ui/loadout_selection_icon_equipment.rpak", clGlobal.topoFullScreen, RUI_DRAW_HUD, 1 )

		RuiSetBool( equipmentRuiAsset, "isDetailMode", file.isDetailsPanelShowing )
		RuiSetAsset( equipmentRuiAsset, "iconImage", equipmentData.hudIcon )
		RuiSetInt( equipmentRuiAsset, "lootTier", equipmentData.tier )
		RuiSetInt( equipmentRuiAsset, "equipmentIndex", i )

		file.loadoutRuiElements.append( equipmentRuiAsset )
	}

	//
	table<string, int> trackedConsumableCount
	table<string, var> trackConsumableRuiAssets
	int consumableCounter = 0
	int equipmentIndex = -1
	for ( int i = 0; i < file.characterFlavorToDisplayedConsumableLoadout[characterRef].len(); i++ )
	{
		string consumableRef    = file.characterFlavorToDisplayedConsumableLoadout[characterRef][i]

		if ( consumableRef in trackedConsumableCount )
		{
			trackedConsumableCount[consumableRef]++
			RuiSetInt( trackConsumableRuiAssets[consumableRef], "itemCount", trackedConsumableCount[consumableRef] )
		}
		else
		{
			LootData consumableData = SURVIVAL_Loot_GetLootDataByRef( consumableRef )
			var consumableRuiAsset  = RuiCreate( $"ui/loadout_selection_icon_equipment.rpak", clGlobal.topoFullScreen, RUI_DRAW_HUD, 1 )
			if ( equipmentIndex == -1 )
				equipmentIndex = i
			else
				equipmentIndex++
			RuiSetBool( consumableRuiAsset, "isDetailMode", file.isDetailsPanelShowing )
			RuiSetAsset( consumableRuiAsset, "iconImage", consumableData.hudIcon )
			RuiSetInt( consumableRuiAsset, "lootTier", consumableData.tier )
			RuiSetInt( consumableRuiAsset, "equipmentIndex", equipmentIndex )
			RuiSetBool( consumableRuiAsset, "isConsumable", true )

			trackedConsumableCount[consumableRef] <- 1
			trackConsumableRuiAssets[consumableRef] <- consumableRuiAsset

			file.loadoutRuiElements.append( consumableRuiAsset )
			consumableCounter++
		}
	}

	foreach( ruiAsset in file.loadoutRuiElements )
		RuiSetBool( ruiAsset, "is16x10", file.is16x10 )

}

bool function ShouldShrinkWeaponIcon( string weaponRef )
{
	//
		//

	return false
}
#endif



array<string> function CharacterLoadouts_GetWeaponLoadoutArray( ItemFlavor character )
{
	return file.characterFlavorToWeaponLoadout[ItemFlavor_GetHumanReadableRef( character ).tolower()]
}

array<string> function CharacterLoadouts_GetConsumableLoadoutArray( ItemFlavor character )
{
	return file.characterFlavorToConsumableLoadout[ItemFlavor_GetHumanReadableRef( character ).tolower()]
}

array<string> function CharacterLoadouts_GetEquipmentLoadoutArray( ItemFlavor character )
{
	return file.characterFlavorToEquipmentLoadout[ItemFlavor_GetHumanReadableRef( character ).tolower()]
}
