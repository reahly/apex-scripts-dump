resource/ui/menus/panels/challenges.res
{
    ToolTip
    {
        ControlName				RuiPanel
        InheritProperties       ToolTip
    }

    ScreenFrame
    {
        ControlName				ImagePanel
        xpos					0
        ypos					0
        wide					%100
        tall					%100
        visible					0
        enabled 				1
        drawColor				"0 0 0 0"
    }

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    CategoryLargeButton0
    {
        ControlName				RuiButton
        xpos                    c-700
        xpos_nx_handheld        c-910		[$NX]
        ypos                    24
		wide					374
        wide_nx_handheld		540			[$NX]
        tall					80
        tall_nx_handheld		140			[$NX]
        zpos					2 // Needed or clicking on the background can hide this
        visible					1
        enabled					1
        rui                     "ui/challenge_category_button_large.rpak"
        clipRui                 1
        labelText				""
        style					RuiButton
        clip 					0
        cursorVelocityModifier  0.7
        tabPosition             1
        rightClickEvents		1
        doubleClickEvents       1
        sound_focus             "UI_Menu_Focus_Small"
        sound_accept            "UI_Menu_BattlePass_LevelIncreaseTab"
        sound_deny              ""
        selectOnDpadNav         1

        navDown					CategoryLargeButton1
    }

    CategoryLargeButton1
    {
        ControlName				RuiButton
        xpos                    0
        ypos                    10
        ypos_nx_handheld        15		[$NX]
        wide					374
        wide_nx_handheld		540		[$NX]
        tall					80
        tall_nx_handheld		140		[$NX]
        zpos					2 // Needed or clicking on the background can hide this
        visible					1
        enabled					1
        rui                     "ui/challenge_category_button_large.rpak"
        clipRui                 1
        labelText				""
        style					RuiButton
        clip 					0
        cursorVelocityModifier  0.7
        rightClickEvents		1
        doubleClickEvents       1
        sound_focus             "UI_Menu_Focus_Small"
        sound_accept            "UI_Menu_BattlePass_LevelIncreaseTab"
        sound_deny              ""
        selectOnDpadNav         1

        navUp   				CategoryLargeButton0
        navDown					CategoryLargeButton2

        pin_to_sibling			CategoryLargeButton0
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	BOTTOM_LEFT
    }

    CategoryLargeButton2
    {
        ControlName				RuiButton
        xpos                    0
        ypos                    10
        ypos_nx_handheld        15		[$NX]
        wide					374
        wide_nx_handheld		540		[$NX]
        tall					80
        tall_nx_handheld		140		[$NX]
        zpos					2 // Needed or clicking on the background can hide this
        visible					1
        enabled					1
        rui                     "ui/challenge_category_button_large.rpak"
        clipRui                 1
        labelText				""
        style					RuiButton
        clip 					0
        cursorVelocityModifier  0.7
        rightClickEvents		1
        doubleClickEvents       1
        sound_focus             "UI_Menu_Focus_Small"
        sound_accept            "UI_Menu_BattlePass_LevelIncreaseTab"
        sound_deny              ""
        selectOnDpadNav         1

        navUp   				CategoryLargeButton1
        navDown					CategoryLargeButton3

        pin_to_sibling			CategoryLargeButton1
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	BOTTOM_LEFT
    }

    CategoryLargeButton3
    {
        ControlName				RuiButton
        xpos                    0
        ypos                    10
        ypos_nx_handheld        15		[$NX]
        wide					374
        wide_nx_handheld		540		[$NX]
        tall					80
        tall_nx_handheld		140		[$NX]
        zpos					2 // Needed or clicking on the background can hide this
        visible					1
        enabled					1
        rui                     "ui/challenge_category_button_large.rpak"
        clipRui                 1
        labelText				""
        style					RuiButton
        clip 					0
        cursorVelocityModifier  0.7
        rightClickEvents		1
        doubleClickEvents       1
        sound_focus             "UI_Menu_Focus_Small"
        sound_accept            "UI_Menu_BattlePass_LevelIncreaseTab"
        sound_deny              ""
        selectOnDpadNav         1

        navUp   				CategoryLargeButton2
        navDown					CategoryLargeButton4

        pin_to_sibling			CategoryLargeButton2
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	BOTTOM_LEFT
    }

	CategoryLargeButton4
	{
	    ControlName				RuiButton
	    xpos                    0
	    ypos                    10
	    ypos_nx_handheld        15		[$NX]
	    wide					374
	    wide_nx_handheld		540		[$NX]
	    tall					80
	    tall_nx_handheld		140		[$NX]
	    zpos					2 // Needed or clicking on the background can hide this
	    visible					1
	    enabled					1
	    rui                     "ui/challenge_category_button_large.rpak"
	    clipRui                 1
	    labelText				""
	    style					RuiButton
	    clip 					0
	    cursorVelocityModifier  0.7
	    rightClickEvents		1
	    doubleClickEvents       1
	    sound_focus             "UI_Menu_Focus_Small"
	    sound_accept            "UI_Menu_BattlePass_LevelIncreaseTab"
	    sound_deny              ""
	    selectOnDpadNav         1

	    navUp   				CategoryLargeButton3
	    navDown					GridButton0

	    pin_to_sibling			CategoryLargeButton3
	    pin_corner_to_sibling	TOP_LEFT
	    pin_to_sibling_corner	BOTTOM_LEFT
	}

    CategoryList
    {
        ControlName				GridButtonListPanel
        xpos                    0
        ypos                    10
        ypos_nx_handheld        15		[$NX]
        columns                 1
        rows                    1
        buttonSpacing           6
        scrollbarSpacing        6
        scrollbarOnLeft         0
        visible					1
        selectOnDpadNav         1

        pin_to_sibling			CategoryLargeButton3
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	BOTTOM_LEFT

        ButtonSettings
        {
            rui                     "ui/challenge_category_button.rpak"
            clipRui                 1
            wide					350
            wide_nx_handheld		525		[$NX]
            tall					50
            tall_nx_handheld		90		[$NX]
            cursorVelocityModifier  0.7
            rightClickEvents		1
            doubleClickEvents       1
            sound_focus             "UI_Menu_Focus_Small"
            sound_accept            "UI_Menu_BattlePass_LevelIncreaseTab"
            sound_deny              ""
        }
    }

    PinnedChallenge
    {
        ControlName				RuiButton
        xpos                    c-300
        xpos_nx_handheld        c-340		[$NX]
        ypos                    24
        wide					990
        wide_nx_handheld		1250	[$NX]
        tall					70
        tall_nx_handheld		95		[$NX]
        zpos					2 // Needed or clicking on the background can hide this
        visible					1
        enabled					1
        rui                     ui/challenge_row.rpak
        clipRui                 1
        labelText				""
        style					RuiButton
        clip 					1
        cursorVelocityModifier  0.7
        rightClickEvents		1
        doubleClickEvents       1
        sound_focus             ""
        sound_accept            ""
        sound_deny              ""
    }

    PinnedChallenge2
    {
        ControlName				RuiButton
        xpos					0
        ypos                    16
        wide					990
        wide_nx_handheld		1250	[$NX]
        tall					70
        tall_nx_handheld		95		[$NX]
        zpos					2 // Needed or clicking on the background can hide this
        visible					1
        enabled					1
        rui                     ui/challenge_row.rpak
        clipRui                 1
        labelText				""
        style					RuiButton
        clip 					1
        cursorVelocityModifier  0.7
        rightClickEvents		1
        doubleClickEvents       1
        sound_focus             ""
        sound_accept            ""
        sound_deny              ""

        pin_to_sibling			PinnedChallenge
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	BOTTOM_LEFT
    }


    DividerLine
    {
        ControlName				RuiPanel
        rui                     "ui/basic_image.rpak"
        xpos					0
        ypos                    16
        wide					990
        wide_nx_handheld		1250		[$NX]
        tall					3
        tall_nx_handheld		8			[$NX]
        visible					1
        ruiArgs
        {
            basicImageAlpha     0.5
        }

        pin_to_sibling			PinnedChallenge2
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	BOTTOM_LEFT
    }

    ChallengesList
    {
        ControlName				GridButtonListPanel
        xpos                    0
        ypos                    16
        columns                 1
        rows                    1
        buttonSpacing           6
        scrollbarSpacing        6
        scrollbarOnLeft         0
        visible					1
        selectOnDpadNav         1

        pin_to_sibling			DividerLine
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	BOTTOM_LEFT

        ButtonSettings
        {
            rui                     ui/challenge_row.rpak
            clipRui                 1
            wide					990
            wide_nx_handheld		1250		[$NX]
            tall					65
            tall_nx_handheld		95			[$NX]
            cursorVelocityModifier  0.7
            rightClickEvents		1
            doubleClickEvents       1
            sound_focus             ""
            sound_accept            ""
            sound_deny              ""
        }
    }

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
}
