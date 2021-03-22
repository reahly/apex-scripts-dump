"resource/ui/menus/panels/store_vc.res"
{
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

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

	VCButton1
	{
		ControlName			RuiButton
		scriptId            0
		xpos			    "%-50"
		xpos_nx_handheld    4     		[$NX]
		ypos			    -60
		ypos_nx_handheld    -20     	[$NX]
		zpos			    4
		wide			    337
		wide_nx_handheld    358     	[$NX]
		tall			    646
		tall_nx_handheld    760     	[$NX]
		visible			    1
		enabled             0
        rui					"ui/store_button_vc.rpak"
        cursorVelocityModifier  0.7
		proportionalToParent	1

		tabPosition             1

		navRight                			VCButton2

        pin_to_sibling						PanelFrame
        pin_corner_to_sibling				TOP_LEFT
        pin_to_sibling_corner				TOP
        pin_to_sibling_corner_nx_handheld 	TOP_LEFT     [$NX]
	}

	VCButton2
	{
		ControlName			RuiButton
		scriptId            1
		xpos			    10
		xpos_nx_handheld    21    		[$NX]
		ypos			    0
		zpos			    4
		wide			    337
		wide_nx_handheld    358    		[$NX]
		tall			    646
		tall_nx_handheld    760    		[$NX]
		visible			    1
		enabled             0
        rui					"ui/store_button_vc.rpak"
        cursorVelocityModifier  0.7
		proportionalToParent	1

        navLeft                 VCButton1
		navRight                VCButton3

        pin_to_sibling          VCButton1
        pin_corner_to_sibling   TOP_LEFT
        pin_to_sibling_corner   TOP_RIGHT
	}

	VCButton3
	{
		ControlName			RuiButton
		scriptId            2
		xpos			    0
		xpos_nx_handheld    21     		[$NX]
		ypos			    -60
		ypos_nx_handheld    0      		[$NX]
		zpos			    4
		wide			    337
		wide_nx_handheld    358    		[$NX]
		tall			    646
		tall_nx_handheld    760    		[$NX]
		visible			    1
		enabled             0
        rui					"ui/store_button_vc.rpak"
        cursorVelocityModifier  0.7
		proportionalToParent	1

        navLeft                 VCButton2
		navRight                VCButton4

        pin_to_sibling          			PanelFrame
        pin_to_sibling_nx_handheld          VCButton2   [$NX]
        pin_corner_to_sibling   			TOP
        pin_corner_to_sibling_nx_handheld   TOP_LEFT    [$NX]
        pin_to_sibling_corner   			TOP
        pin_to_sibling_corner_nx_handheld   TOP_RIGHT   [$NX]
	}

	VCButton4
	{
		ControlName			RuiButton
		scriptId            3
		xpos			    10
		xpos_nx_handheld    21     		[$NX]
		ypos			    0
		zpos			    4
		wide			    337
		wide_nx_handheld    358    		[$NX]
		tall			    646
		tall_nx_handheld    760    		[$NX]
		visible			    1
		enabled             0
        rui					"ui/store_button_vc.rpak"
        cursorVelocityModifier  0.7
		proportionalToParent	1

        navLeft                 VCButton3
		navRight                VCButton5

        pin_to_sibling          			VCButton5
        pin_to_sibling_nx_handheld          VCButton3   [$NX]
        pin_corner_to_sibling   			TOP_RIGHT
		pin_corner_to_sibling_nx_handheld   TOP_LEFT    [$NX]
        pin_to_sibling_corner   			TOP_LEFT
		pin_to_sibling_corner_nx_handheld   TOP_RIGHT   [$NX]
	}

	VCButton5
	{
		ControlName			RuiButton
		scriptId            4
		xpos			    "%50"
		xpos_nx_handheld    4			[$NX]
		ypos			    -60
		ypos_nx_handheld    -20			[$NX]
		zpos			    4
		wide			    337
		wide_nx_handheld    358    		[$NX]
		tall			    646
		tall_nx_handheld    760    		[$NX]
		visible			    1
		enabled             0
        rui					"ui/store_button_vc.rpak"
        cursorVelocityModifier  0.7
		proportionalToParent	1

        navLeft                 VCButton4

        pin_to_sibling          			PanelFrame
        pin_corner_to_sibling   			TOP_RIGHT
        pin_to_sibling_corner   			TOP
		pin_to_sibling_corner_nx_handheld   TOP_RIGHT    [$NX]
	}

	DiscountPanel
	{
		ControlName				RuiPanel
		ypos                    5 [$PS4] // Avoid overlapping the PS Store banner
		ypos                    20 [!$PS4]
		wide					900
		tall					132
		visible					1
        rui                     "ui/store_discount_panel.rpak"

        proportionalToParent    1

        pin_to_sibling			VCButton3
        pin_corner_to_sibling	TOP
        pin_to_sibling_corner	BOTTOM
	}
	
	TaxNoticeMessage [$NX]
	{
		ControlName				Label
		labelText				""
		ypos					24
		wide					800
		tall					81
		visible					0
		fontHeight				42
		textAlignment			center

		pin_to_sibling			VCButton3
		pin_corner_to_sibling	TOP
		pin_to_sibling_corner	BOTTOM
	}
}
