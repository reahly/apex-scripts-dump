global function InitCharacterEmotesPanel
global function CharacterEmotesPanel_SetHintSub

struct SectionDef
{
	var button
	var panel
	int index
}

struct
{
	var panel
	var headerRui

	array<SectionDef> sections
	int               activeSectionIndex = 0
	table<int, array<int> > sectionToFilters

	ItemFlavor ornull lastNewnessCharacter
} file

void function InitCharacterEmotesPanel( var panel )
{
	file.panel = panel
	file.headerRui = Hud_GetRui( Hud_GetChild( panel, "Header" ) )

	SetPanelTabTitle( panel, "#SOCIAL_WHEEL" )
	RuiSetString( file.headerRui, "title", "" )
	RuiSetString( file.headerRui, "collected", "" )

	AddPanelEventHandler( panel, eUIEvent.PANEL_SHOW, EmotesPanel_OnShow )
	AddPanelEventHandler( panel, eUIEvent.PANEL_HIDE, EmotesPanel_OnHide )

	AddCallback_OnTopLevelCustomizeContextChanged( panel, EmotesPanel_OnCustomizeContextChanged )

	int buttonNum = 0

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

               
  
                    
                                                                     
                                        
                                                                          
                                                     
                           
                                                                     
                                                                          
                                 
             
  
       

	{
		SectionDef section
		section.button = Hud_GetChild( panel, "SectionButton" + buttonNum )
		Hud_SetVisible( section.button, true )
		HudElem_SetRuiArg( section.button, "buttonText", Localize( "#HOLOS" ) )
		section.panel = Hud_GetChild( panel, "BoxesPanel" )
		section.index = buttonNum
		file.sectionToFilters[ buttonNum ] <- [ eItemType.emote_icon ]
		Hud_AddEventHandler( section.button, UIE_CLICK, SectionButton_Activate )
		file.sections.append( section )
		buttonNum++
	}

	{
		SectionDef section
		section.button = Hud_GetChild( panel, "SectionButton" + buttonNum )
		Hud_SetVisible( section.button, true )
		HudElem_SetRuiArg( section.button, "buttonText", Localize( "#QUIPS" ) )
		section.panel = Hud_GetChild( panel, "LinePanel" )
		section.index = buttonNum
		file.sectionToFilters[ buttonNum ] <- [ eItemType.gladiator_card_kill_quip, eItemType.gladiator_card_intro_quip ]
		Hud_AddEventHandler( section.button, UIE_CLICK, SectionButton_Activate )
		file.sections.append( section )
		buttonNum++
	}

	HudElem_SetRuiArg( Hud_GetChild( file.panel, "HintMKB" ), "textBreakWidth", 400.0 )
	HudElem_SetRuiArg( Hud_GetChild( file.panel, "HintGamepad" ), "textBreakWidth", 400.0 )
}

void function SectionButton_Activate( var button )
{
	Hud_SetSelected( button, true )

	var panel

	foreach ( sectionIndex, sectionDef in file.sections )
	{
		bool isActivated = sectionDef.button == button
		if ( isActivated )
		{
			panel = sectionDef.panel
			file.activeSectionIndex = sectionIndex
			QuipPanel_SetItemTypeFilter( file.sectionToFilters[ sectionIndex ] )
		}

		Hud_SetSelected( sectionDef.button, isActivated )
	}

	ActivatePanel( panel )
}


void function ActivatePanel( var panel )
{
	HideVisibleSectionPanels()

	if ( panel )
	{
		ShowPanel( panel )
	}
}


void function HideVisibleSectionPanels()
{
	array<var> panels
	foreach ( sectionDef in file.sections )
		panels.append( sectionDef.panel )

	foreach ( panel in panels )
	{
		if ( Hud_IsVisible( panel ) )
			HidePanel( panel )
	}
}


void function EmotesPanel_OnShow( var panel )
{
	UI_SetPresentationType( ePresentationType.QUIP_WHEEL )

	file.activeSectionIndex = 0

	CharacterEmotesPanel_Update()

	for ( int i=0; i<MAX_QUIPS_EQUIPPED; i++ )
		AddCallback_ItemFlavorLoadoutSlotDidChange_SpecificPlayer( LocalClientEHI(), Loadout_CharacterQuip( GetTopLevelCustomizeContext(), i ), OnEmoteChanged )

	string hintSub = ""
	CharacterEmotesPanel_SetHintSub( hintSub )
}

void function CharacterEmotesPanel_SetHintSub( string hintSub )
{
	if ( hintSub != "" )
		hintSub = "\n\n" + Localize( hintSub )

	RunClientScript( "SetHintTextOnHudElem", Hud_GetChild( file.panel, "HintMKB" ), "#HINT_SOCIAL_WHEEL_MKB", hintSub )
	RunClientScript( "SetHintTextOnHudElem", Hud_GetChild( file.panel, "HintGamepad" ), "#HINT_SOCIAL_WHEEL_GAMEPAD", hintSub )
}

void function OnEmoteChanged( EHI playerEHI, ItemFlavor flavor )
{

}

void function EmotesPanel_OnCustomizeContextChanged( var panel )
{
	if ( !IsPanelActive( file.panel ) )
		return

	CharacterEmotesPanel_Update()
}


void function CharacterEmotesPanel_Update()
{
	SectionButton_Activate( file.sections[file.activeSectionIndex].button )
	UpdateNewnessCallbacks()

	ItemFlavor character = GetTopLevelCustomizeContext()
	ItemFlavor characterSkin = LoadoutSlot_GetItemFlavor( LocalClientEHI(), Loadout_CharacterSkin( character ) )
	RunClientScript( "UIToClient_PreviewCharacterSkin", ItemFlavor_GetNetworkIndex_DEPRECATED( characterSkin ), ItemFlavor_GetNetworkIndex_DEPRECATED( character ) )
}


void function EmotesPanel_OnHide( var panel )
{
	ClearNewnessCallbacks()
	HideVisibleSectionPanels()

	RunClientScript( "ClearBattlePassItem" )

	for ( int i=0; i<MAX_QUIPS_EQUIPPED; i++ )
		RemoveCallback_ItemFlavorLoadoutSlotDidChange_SpecificPlayer( LocalClientEHI(), Loadout_CharacterQuip( GetTopLevelCustomizeContext(), i ), OnEmoteChanged )
}

void function UpdateNewnessCallbacks()
{
	if ( !IsTopLevelCustomizeContextValid() )
		return

	ClearNewnessCallbacks()

	ItemFlavor character = GetTopLevelCustomizeContext()
	foreach ( section in file.sections )
	{
		table<ItemFlavor, Newness_ReverseQuery> ornull q = GetNewnessQueryForSection( section )
		if ( q != null )
		{
			expect table<ItemFlavor, Newness_ReverseQuery>( q )
			Newness_AddCallbackAndCallNow_OnRerverseQueryUpdated( q[character], OnNewnessQueryChangedUpdateButton, section.button )
		}
	}
	file.lastNewnessCharacter = character
}


void function ClearNewnessCallbacks()
{
	if ( file.lastNewnessCharacter == null )
		return

	foreach ( section in file.sections )
	{
		table<ItemFlavor, Newness_ReverseQuery> ornull q = GetNewnessQueryForSection( section )
		if ( q != null )
		{
			expect table<ItemFlavor, Newness_ReverseQuery>( q )
			Newness_RemoveCallback_OnRerverseQueryUpdated( q[expect ItemFlavor( file.lastNewnessCharacter )], OnNewnessQueryChangedUpdateButton, section.button )
		}
	}
	file.lastNewnessCharacter = null
}

table<ItemFlavor, Newness_ReverseQuery> ornull function GetNewnessQueryForSection( SectionDef section )
{
	//
	if ( file.sectionToFilters[ section.index ].contains( eItemType.emote_icon ) )
		return NEWNESS_QUERIES.CharacterEmotesHolospraySectionButton

	return null
}