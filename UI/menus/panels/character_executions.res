"resource/ui/menus/panels/character_executions.res"
{
	PanelFrame
	{
		ControlName				Label
		xpos					0
		ypos					0
		wide					%100
		tall					%100
		labelText				""
		bgcolor_override		"70 70 70 255"
		visible					0
		paintbackground			1
	}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    Header
    {
        ControlName             RuiPanel
        xpos                    194
        ypos                    50
        zpos                    4
        wide                    550
        tall                    33
        rui                     "ui/character_items_header.rpak"
    }

    CharacterExecutionList
    {
        ControlName				GridButtonListPanel
        xpos                    194
        xpos_nx_handheld        35   [$NX]
        ypos                    96
        columns                 1
        rows                    12
        buttonSpacing           6
        scrollbarSpacing        6
        scrollbarOnLeft         0
        visible					1
        tabPosition             1
        selectOnDpadNav         1

        ButtonSettings
        {
            rui                     "ui/generic_item_button.rpak"
            clipRui                 1
            wide					350
            wide_nx_handheld		550  [$NX]
            tall					50
            tall_nx_handheld		86   [$NX]
            cursorVelocityModifier  0.7
            rightClickEvents		1
			doubleClickEvents       1
            sound_focus             "UI_Menu_Focus_Small"
            sound_accept            ""
            sound_deny              ""
        }
    }

    Video
    {
        ControlName             RuiPanel
        xpos					576
        xpos_nx_handheld		595   [$NX]
        ypos					71
        ypos_nx_handheld		60    [$NX]
        wide                    1022
        wide_nx_handheld        1222  [$NX]
        tall                    575
        tall_nx_handheld        775   [$NX]
        visible                 1
        rui                     "ui/finisher_video.rpak"
    }
}