global function ShQuips_Init
global function RegisterEquippableQuipsForCharacter

global function CharacterQuip_IsTheEmpty

              
                                       
                                           
                                                   
      

global function CharacterQuip_UseHoloProjector
global function CharacterQuip_GetModelAsset
global function CharacterQuip_GetUseEffectColor2
global function CharacterQuip_GetEffectColor1
global function CharacterQuip_GetEffectColor2

#if(CLIENT)
global function PerformQuip
global function CharacterQuip_ShortenTextForCommsMenu
#endif

#if(false)


#endif

#if CLIENT || UI 
global function CreateNestedRuiForQuip
global function EmoteIcon_PopulateNestedRui
#endif

global function CharacterQuip_GetCharacterFlavor
global function CharacterQuip_GetAliasSubName
global function Loadout_CharacterQuip
global function ItemFlavor_CanEquipToWheel

#if(false)

#endif

global const int MAX_QUIPS_EQUIPPED = 8

#if CLIENT || UI 
struct FileStruct_LifetimeLevel
{
	table<ItemFlavor, array<LoadoutEntry> >     loadoutCharacterQuipsSlotListMap

	array<ItemFlavor> universalQuips
	table<ItemFlavor, ItemFlavor> quipCharacterMap
}
FileStruct_LifetimeLevel& fileLevel
#endif

void function ShQuips_Init()
{
	FileStruct_LifetimeLevel newFileLevel
	fileLevel = newFileLevel
}

void function RegisterEquippableQuipsForCharacter( ItemFlavor characterClass, array<ItemFlavor> quipList )
{
	foreach( int index, ItemFlavor quip in quipList )
	{
		if ( quip in fileLevel.quipCharacterMap )
		{
			fileLevel.universalQuips.append( quip )
		}
		else
		{
			fileLevel.quipCharacterMap[quip] <- characterClass
		}

		#if(CLIENT)
		if ( CharacterQuip_UseHoloProjector( quip ) )
		{
			PrecacheModel( CharacterQuip_GetModelAsset( quip ) )
		}
		#endif
	}

	fileLevel.loadoutCharacterQuipsSlotListMap[characterClass] <- []

	for ( int quipIndex = 0; quipIndex < MAX_QUIPS_EQUIPPED; quipIndex++ )
	{
		LoadoutEntry entry = RegisterLoadoutSlot( eLoadoutEntryType.ITEM_FLAVOR, "quips_" + quipIndex + "_for_" + ItemFlavor_GetGUIDString( characterClass ) )
		entry.pdefSectionKey = "character " + ItemFlavor_GetGUIDString( characterClass )
		entry.DEV_category = "character_quips"
		entry.DEV_name = ItemFlavor_GetHumanReadableRef( characterClass ) + " Quip " + quipIndex
		entry.validItemFlavorList = quipList
		entry.defaultItemFlavor = entry.validItemFlavorList[0]
		entry.isSlotLocked = bool function( EHI playerEHI ) {
			return !IsLobby()
		}

		#if(false)




//




































#endif

		entry.isActiveConditions = { [Loadout_Character()] = { [characterClass] = true, }, }
		entry.networkTo = eLoadoutNetworking.PLAYER_EXCLUSIVE
		//
		fileLevel.loadoutCharacterQuipsSlotListMap[characterClass].append( entry )
	}
}


#if(CLIENT)
void function PerformQuip( entity player, int index )
{
	if ( !IsAlive( player ) )
		return

	ItemFlavor quip      = GetItemFlavorByGUID( index )

	CommsAction act
	act.index = eCommsAction.QUIP
	act.aliasSubname = CharacterQuip_GetAliasSubName( quip )
	act.hasCalm = false
	act.hasCalmFar = false
	act.hasUrgent = false
	act.hasUrgentFar = false

	CommsOptions opt
	opt.isFirstPerson = (player == GetLocalViewPlayer())
	opt.isFar = false
	opt.isUrgent = false
	opt.pauseQueue = player.GetTeam() == GetLocalViewPlayer().GetTeam()

	PlaySoundForCommsAction( player, null, act, opt )
}
#endif



#if CLIENT || UI 
LoadoutEntry function Loadout_CharacterQuip( ItemFlavor characterClass, int badgeIndex )
{
	return fileLevel.loadoutCharacterQuipsSlotListMap[characterClass][badgeIndex]
}

string function CharacterQuip_GetAliasSubName( ItemFlavor flavor )
{
	AssertEmoteIsValid( flavor )

	return GetGlobalSettingsString( ItemFlavor_GetAsset( flavor ), "quickchatAliasSubName" )
}

bool function CharacterQuip_IsTheEmpty( ItemFlavor flavor )
{
	AssertEmoteIsValid( flavor )

	return ( GetGlobalSettingsBool( ItemFlavor_GetAsset( flavor ), "isTheEmpty" ) )
}

              
                                                            
 
                             

                                                                          
 

                                                                
 
                                                                    

                                                                              
 

                                                                       
 
                                                                     

                                                                                    
 
         

bool function CharacterQuip_UseHoloProjector( ItemFlavor flavor )
{
	AssertEmoteIsValid( flavor )

	return ( GetGlobalSettingsBool( ItemFlavor_GetAsset( flavor ), "useHoloProjector" ) )
}

void function AssertEmoteIsValid( ItemFlavor flavor )
{
	array<int> allowedList = [
		eItemType.gladiator_card_kill_quip,
		eItemType.gladiator_card_intro_quip,
		eItemType.emote_icon,
               
                            
       
	]

	Assert( allowedList.contains( ItemFlavor_GetType( flavor ) ) )
}
#endif //


#if(false)



























































#endif

bool function ItemFlavor_CanEquipToWheel( ItemFlavor item )
{
	switch ( ItemFlavor_GetType( item ) )
	{
		case eItemType.gladiator_card_kill_quip:
		case eItemType.gladiator_card_intro_quip:
		case eItemType.emote_icon:
			return true
	}

	return false
}

#if CLIENT || UI 
string function CharacterQuip_ShortenTextForCommsMenu( ItemFlavor flav )
{
	string txt = ""

	int itemType = ItemFlavor_GetType( flav )
	if ( itemType == eItemType.gladiator_card_kill_quip || itemType == eItemType.gladiator_card_intro_quip )
	{
		txt = Localize( ItemFlavor_GetLongName( flav ) )

		int WORD_MAX_LEN = 11
		int TEXT_MAX_LEN = 26
		int TEXT_MAX_LEN_W_DOTS = TEXT_MAX_LEN - 2
#if(CLIENT)
		txt = CondenseText( txt, WORD_MAX_LEN, TEXT_MAX_LEN )
#endif
	}
	return txt
}

var function CreateNestedRuiForQuip( var baseRui, string argName, EHI ehi, ItemFlavor quip, ItemFlavor ornull character )
{
	asset ruiAsset = $"ui/comms_menu_icon_default.rpak"

	int type = ItemFlavor_GetType( quip )
	switch ( type )
	{
		case eItemType.emote_icon:
			ruiAsset = $"ui/comms_menu_icon_projector.rpak"
			var rui = RuiCreateNested( baseRui, argName, ruiAsset )
			EmoteIcon_PopulateNestedRui( rui, quip, null )
			return rui
	}

	var nestedRui = RuiCreateNested( baseRui, argName, ruiAsset )
	asset icon       = ItemFlavor_GetIcon( quip )
	RuiSetImage( nestedRui, "icon", icon )

	RuiSetBool( nestedRui, "centerTextUseTierColor", type == eItemType.gladiator_card_intro_quip || type == eItemType.gladiator_card_kill_quip )

	RuiSetInt( nestedRui, "tier", ItemFlavor_GetQuality( quip, 0 ) + 1 )

	string txt = CharacterQuip_ShortenTextForCommsMenu( quip )
	RuiSetString( nestedRui, "centerText", txt )

	return nestedRui
}


void function EmoteIcon_PopulateNestedRui( var rui, ItemFlavor item, int ornull overrideDataInt )
{
	asset ruiAsset = $"ui/basic_image.rpak"
	var nested = RuiCreateNested( rui, "ruiHandle", ruiAsset )
	asset icon = ItemFlavor_GetIcon( item )

	RuiSetInt( rui, "tier", ItemFlavor_GetQuality( item, 0 ) + 1 )
	RuiSetImage( nested, "basicImage", icon )
}
#endif //


asset function CharacterQuip_GetModelAsset( ItemFlavor item )
{
	Assert( ItemFlavor_GetType( item ) == eItemType.emote_icon )
	return GetGlobalSettingsAsset( ItemFlavor_GetAsset( item ), "holoProjectorSprayModel" )
}

bool function CharacterQuip_GetUseEffectColor2( ItemFlavor item )
{
	Assert( ItemFlavor_GetType( item ) == eItemType.emote_icon )
	return GetGlobalSettingsBool( ItemFlavor_GetAsset( item ), "holoProjectorUseEffectColor2" )
}

vector function CharacterQuip_GetEffectColor1( ItemFlavor item )
{
	Assert( ItemFlavor_GetType( item ) == eItemType.emote_icon )
	return GetGlobalSettingsVector( ItemFlavor_GetAsset( item ), "holoProjectorEffectColor1" )
}

vector function CharacterQuip_GetEffectColor2( ItemFlavor item )
{
	Assert( ItemFlavor_GetType( item ) == eItemType.emote_icon )
	return GetGlobalSettingsVector( ItemFlavor_GetAsset( item ), "holoProjectorEffectColor2" )
}


ItemFlavor ornull function CharacterQuip_GetCharacterFlavor( ItemFlavor item )
{
	if ( fileLevel.universalQuips.contains( item ) )
		return null

	return fileLevel.quipCharacterMap[ item ]
}