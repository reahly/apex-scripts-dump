global function InitRankedInfoMoreMenu
global function OpenRankedInfoMorePage

struct
{
	var menu
} file

void function InitRankedInfoMoreMenu( var newMenuArg ) //
{
	var menu = GetMenu( "RankedInfoMoreMenu" )
	file.menu = menu

	AddMenuEventHandler( menu, eUIEvent.MENU_OPEN, OnRankedInfoMoreMenu_Open )
	AddMenuEventHandler( menu, eUIEvent.MENU_CLOSE, OnRankedInfoMoreMenu_Close )

	AddMenuEventHandler( menu, eUIEvent.MENU_SHOW, OnRankedInfoMoreMenu_Show )
	AddMenuEventHandler( menu, eUIEvent.MENU_HIDE, OnRankedInfoMoreMenu_Hide )

	AddMenuFooterOption( menu, LEFT, BUTTON_B, true, "#B_BUTTON_BACK", "#B_BUTTON_BACK" )
}

void function OpenRankedInfoMorePage( var button )
{
	AdvanceMenu( file.menu )
}

void function OnRankedInfoMoreMenu_Open()
{
	UI_SetPresentationType( ePresentationType.WEAPON_CATEGORY )
	
	int currentScore               = GetPlayerRankScore( GetUIPlayer() )
	array<RankedTierData> tiers    = Ranked_GetTiers()
	int ladderPosition             = Ranked_GetLadderPosition( GetUIPlayer() )
	RankedDivisionData currentRank = GetCurrentRankedDivisionFromScoreAndLadderPosition( currentScore, ladderPosition )
	RankedTierData currentTier     = currentRank.tier
	
	var mainRui = Hud_GetRui( Hud_GetChild( file.menu, "InfoMain" ) )
	
	for ( int i=0; i<tiers.len(); i++ )
	{
		int idx              = i+1
		RankedTierData d     = tiers[i]
		string scoringString = d.entryCost == 0 ? Localize( "#RANKED_FREE" ) : Localize( "#RANKED_COST", d.entryCost )	
		RuiSetInt( mainRui, "entryFee" + i, d.entryCost )
	}
	
	var rankedScoringTableRui = Hud_GetRui( Hud_GetChild( file.menu, "RankedScoringTable" ) )
	RuiSetInt( rankedScoringTableRui, "fourteenthPlaceRP", Ranked_GetPointsForPlacement( 14 ) )
	RuiSetInt( rankedScoringTableRui, "eleventhPlaceRP", Ranked_GetPointsForPlacement( 11 ) )
	RuiSetInt( rankedScoringTableRui, "tenthPlaceRP", Ranked_GetPointsForPlacement( 10 ) )
	RuiSetInt( rankedScoringTableRui, "eighthPlaceRP", Ranked_GetPointsForPlacement( 8 ) )
	RuiSetInt( rankedScoringTableRui, "sixthPlaceRP", Ranked_GetPointsForPlacement( 6 ) )
	RuiSetInt( rankedScoringTableRui, "fourthPlaceRP", Ranked_GetPointsForPlacement( 4 ) )
	RuiSetInt( rankedScoringTableRui, "secondPlaceRP", Ranked_GetPointsForPlacement( 2 ) )
	RuiSetInt( rankedScoringTableRui, "firstPlaceRP", Ranked_GetPointsForPlacement( 1 ) )
	
	RuiSetInt( rankedScoringTableRui, "eleventhPlaceKillAssistMultiplier", Ranked_GetPointsPerKillForPlacement( 11 ) )
	RuiSetInt( rankedScoringTableRui, "tenthPlaceKillAssistMultiplier", Ranked_GetPointsPerKillForPlacement( 10 ) )
	RuiSetInt( rankedScoringTableRui, "fifthPlaceKillAssistMultiplier", Ranked_GetPointsPerKillForPlacement( 5 ) )
	RuiSetInt( rankedScoringTableRui, "thirdPlaceKillAssistMultiplier", Ranked_GetPointsPerKillForPlacement( 3 ) )
	RuiSetInt( rankedScoringTableRui, "firstPlaceKillAssistMultiplier", Ranked_GetPointsPerKillForPlacement( 1 ) )
	
	int maxKills = Ranked_GetKillsAndAssistsPointCap( 1 ) / Ranked_GetPointsPerKillForPlacement( 1 )
	
	RuiSetInt( rankedScoringTableRui, "killAndAssistsCap", maxKills )
	
	var rankedIconRui = Hud_GetRui( Hud_GetChild( file.menu, "PanelArt" ) )
	RuiSetInt( rankedIconRui, "tier", currentTier.index )
	RuiSetImage( rankedIconRui, "tierBadgeIcon", currentTier.icon )
	RuiSetString( rankedIconRui, "emblemText" , currentRank.emblemText )
}

void function OnRankedInfoMoreMenu_Close()
{

}

void function OnRankedInfoMoreMenu_Show()
{

}

void function OnRankedInfoMoreMenu_Hide()
{

}