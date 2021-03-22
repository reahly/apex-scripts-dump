"resource/ui/menus/panels/character_skins.res"
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
		proportionalToParent    1
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

    SkinBlurb
    {
        ControlName             RuiPanel
        xpos                    0
        ypos                    -50
        zpos                    0
        wide                    308
        wide_nx_handheld        380		[$NX]
        tall                    308
        tall_nx_handheld        380		[$NX]
        rui                     "ui/character_skin_blurb.rpak"
        visible                 0

        pin_to_sibling			PanelFrame
        pin_corner_to_sibling	TOP_RIGHT
        pin_to_sibling_corner	TOP_RIGHT
    }

    CharacterSkinList
    {
        ControlName				GridButtonListPanel
        xpos                    194
        xpos_nx_handheld        35  [$NX]
        ypos                    96
        columns                 1
        rows                    12
        rows_nx_handheld        7   [$NX]
        buttonSpacing           6
        buttonSpacing_nx_handheld   10  [$NX]
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
            wide_nx_handheld		630  [$NX]
            tall					50
            tall_nx_handheld		85   [$NX]
            cursorVelocityModifier  0.7
            rightClickEvents		1
			doubleClickEvents       1
			middleClickEvents       1
            sound_focus             "UI_Menu_Focus_Small"
            sound_accept            ""
            sound_deny              ""
        }
    }

    ModelRotateMouseCapture
    {
        ControlName				CMouseMovementCapturePanel
        xpos                    700
        ypos                    0
        wide                    1340
        tall                    %100
    }

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    ActionButton
    {
        ControlName				RuiButton
        classname               "MenuButton"
        wide					280
        wide_nx_handheld        420			[$NX]
        tall					110
        tall_nx_handheld		150			[$NX]
        xpos                    -28
        xpos_nx_handheld        38			[$NX]
        ypos                    -25
        ypos_nx_handheld        25			[$NX]
        rui                     "ui/generic_loot_button.rpak"
        labelText               ""
        visible					1
        cursorVelocityModifier  0.7

        pin_to_sibling			PanelFrame
        pin_corner_to_sibling	BOTTOM_RIGHT
        pin_to_sibling_corner	BOTTOM_RIGHT
    }

    EquipHeirloomButton
    {
        ControlName             RuiButton
        classname               "MenuButton"
        wide                    280
        wide_nx_handheld        420			[$NX]
        tall                    110
        tall_nx_handheld		150			[$NX]
        ypos                    6
        rui                     "ui/generic_loot_button.rpak"
        labelText               ""
        visible                 1
        cursorVelocityModifier  0.7

        pin_to_sibling			ActionButton
        pin_corner_to_sibling	BOTTOM_RIGHT
        pin_to_sibling_corner	TOP_RIGHT
    }
}