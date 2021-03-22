"resource/ui/menus/panels/private_match_game_team_overview.res"
{
	PanelFrame
	{
		ControlName				Label
		xpos					0
		ypos					0
		wide					%100
		tall					%100
		labelText				""
		bgcolor_override		"255 16 255 32"
		visible					0
		paintbackground			0
		proportionalToParent    1
	}

	ToolTip
    {
        ControlName				RuiPanel
        InheritProperties       ToolTip
        zpos                    999
    }

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    ///////////////////////////////
    // Row 1 (team 0 - team 9)
    ///////////////////////////////

	TeamOverviewHeader01
    {

		ControlName					RuiPanel
		
		rui							"ui/private_match_team_overview_header.rpak"

		ruiArgs
		{
			teamPosition			"#"
		}

	    pin_to_sibling              TeamOverviewTitle
        pin_corner_to_sibling       BOTTOM_LEFT
        pin_to_sibling_corner       BOTTOM_LEFT

		wide					850
		tall 					48	
	}


	TeamOverview01
    {
        ControlName             GridButtonListPanel

        xpos                    0
        ypos                    10

        pin_to_sibling          TeamOverviewHeader01
        pin_corner_to_sibling   TOP_LEFT
        pin_to_sibling_corner   BOTTOM_LEFT

        columns                 1
        rows                    10
        buttonSpacing           5
        scrollbarSpacing        0
        scrollbarOnLeft         0
        //tabPosition             1
        selectOnDpadNav         1

        ButtonSettings
        {
            rui                     "ui/private_match_team_overview.rpak"
            clipRui                 1
            wide                    850
            tall                    48
            cursorVelocityModifier  0.7
            //rightClickEvents        1
            //doubleClickEvents       1
            //middleClickEvents       1
            sound_focus             "UI_Menu_Focus_Small"
            sound_accept            ""
            sound_deny              ""
        }
    }

	///////////////////////////////
    // Row 1 (team 10 - team 19)
    ///////////////////////////////

	TeamOverviewHeader02
    {

		ControlName					RuiPanel
		
		rui							"ui/private_match_team_overview_header.rpak"

		ruiArgs
		{
			teamPosition			"#"
		}

	    pin_to_sibling              TeamOverviewTitle
        pin_corner_to_sibling       BOTTOM_LEFT
        pin_to_sibling_corner       BOTTOM_LEFT

		xpos					900

		wide					850
		tall 					48	
	}


	TeamOverview02
    {
        ControlName             GridButtonListPanel

        xpos                    0
        ypos                    10

        pin_to_sibling          TeamOverviewHeader02
        pin_corner_to_sibling   TOP_LEFT
        pin_to_sibling_corner   BOTTOM_LEFT

        columns                 1
        rows                    10
        buttonSpacing           5
        scrollbarSpacing        0
        scrollbarOnLeft         0
        //tabPosition             1
        selectOnDpadNav         1

        ButtonSettings
        {
            rui                     "ui/private_match_team_overview.rpak"
            clipRui                 1
            wide                    850
            tall                    48
            cursorVelocityModifier  0.7
            //rightClickEvents        1
            //doubleClickEvents       1
            //middleClickEvents       1
            sound_focus             "UI_Menu_Focus_Small"
            sound_accept            ""
            sound_deny              ""
        }
    }
}