"resource/ui/menus/panels/character_emotes.res"
{
    PanelFrame
    {
		ControlName				Label
		wide					%100
		tall					%100
		labelText				""
        bgcolor_override        "0 0 0 0"
		visible				    0
        paintbackground         1
    }

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    Header
    {
        ControlName             RuiPanel
        xpos                    163 //22
        ypos                    64
        zpos                    4
        wide                    550
        tall                    33
        rui                     "ui/character_items_header.rpak"
    }

	SectionButton0
	{
		ControlName			RuiButton
        xpos				123
        xpos_nx_handheld	0			[$NX]
        ypos				96
        ypos_nx_handheld	55			[$NX]
		zpos			    3
		wide			    296
		wide_nx_handheld    376			[$NX]
		tall			    56
		tall_nx_handheld    73			[$NX]
		visible			    0
		labelText           ""
        rui					"ui/character_section_button.rpak"
        cursorVelocityModifier  0.7
	}

	SectionButton1
	{
		ControlName			RuiButton
		xpos			    0
		ypos			    3
		zpos			    3
		wide			    296
		wide_nx_handheld    376			[$NX]
		tall			    56
		tall_nx_handheld    73			[$NX]
		visible			    0
		labelText           ""
        rui					"ui/character_section_button.rpak"
        cursorVelocityModifier  0.7

        pin_to_sibling			SectionButton0
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	BOTTOM_LEFT
	}

	SectionButton2
	{
		ControlName			RuiButton
		xpos			    0
		ypos			    3
		zpos			    3
		wide			    296
		wide_nx_handheld    376			[$NX]
		tall			    56
		tall_nx_handheld    73			[$NX]
		visible			    0
		labelText           ""
        rui					"ui/character_section_button.rpak"
        cursorVelocityModifier  0.7

        pin_to_sibling			SectionButton1
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	BOTTOM_LEFT
	}

	SectionButton3
	{
		ControlName			RuiButton
		xpos			    0
		ypos			    3
		zpos			    3
		wide			    296
		wide_nx_handheld    376			[$NX]
		tall			    56
		tall_nx_handheld    73			[$NX]
		visible			    0
		labelText           ""
        rui					"ui/character_section_button.rpak"
        cursorVelocityModifier  0.7

        pin_to_sibling			SectionButton2
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	BOTTOM_LEFT
	}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    LinePanel
    {
        ControlName				CNestedPanel
        xpos					491
        xpos_nx_handheld		36			[$NX]
        ypos					96
        ypos_nx_handheld		0			[$NX]
        wide					550
		wide_nx_handheld		800			[$NX]
        tall					840
        visible					0
        tabPosition             1
        controlSettingsFile		"resource/ui/menus/panels/quips.res"
		
        pin_to_sibling_nx_handheld			SectionButton0		[$NX]
        pin_corner_to_sibling_nx_handheld	TOP_LEFT			[$NX]
        pin_to_sibling_corner_nx_handheld	TOP_RIGHT			[$NX]
    }

    BoxesPanel
    {
        ControlName				CNestedPanel
        xpos					491
        xpos_nx_handheld		36			[$NX]
        ypos					96
        ypos_nx_handheld		0			[$NX]
        wide					550
		wide_nx_handheld		800			[$NX]
        tall					840
        visible					0
        tabPosition             1
        controlSettingsFile		"resource/ui/menus/panels/emotes.res"
		
        pin_to_sibling_nx_handheld			SectionButton0		[$NX]
        pin_corner_to_sibling_nx_handheld	TOP_LEFT			[$NX]
        pin_to_sibling_corner_nx_handheld	TOP_RIGHT			[$NX]
    }

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

	HintGamepad
	{
		ControlName			RuiPanel
        ypos				205
        ypos_nx_handheld	105			[$NX]
        xpos				0
		zpos			    3
		wide			    492
		tall			    196
		tall_nx_handheld    296			[$NX]
		visible			    1
		labelText           ""
        rui					"ui/character_section_button.rpak"
        activeInputExclusivePaint	gamepad

        ruiArgs
        {
            textBreakWidth 400.0
        }

        pin_to_sibling			SectionButton3
        pin_corner_to_sibling	TOP_RIGHT
        pin_to_sibling_corner	BOTTOM_RIGHT
	}


	HintMKB
	{
		ControlName			RuiPanel
        ypos				205
        ypos_nx_handheld	105			[$NX]
        xpos				0
		zpos			    3
		wide			    492
		tall			    196
		tall_nx_handheld    296			[$NX]
		visible			    1
		labelText           ""
        rui					"ui/character_section_button.rpak"
		activeInputExclusivePaint		keyboard

		ruiArgs
		{
		    textBreakWidth 400.0
        }

        pin_to_sibling			SectionButton3
        pin_corner_to_sibling	TOP_RIGHT
        pin_to_sibling_corner	BOTTOM_RIGHT
	}

}