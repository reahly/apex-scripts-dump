"resource/ui/menus/panels/store_characters.res"
{
    PanelFrame
    {
		ControlName				Label
		xpos					0
		ypos					0
		wide					%100
		tall					%100
		labelText				""
		visible				    0
        bgcolor_override        "0 0 0 255"
        paintbackground         1

        proportionalToParent    1
    }

    CharacterSelectInfo
    {
        ControlName		        RuiPanel
        xpos                    -150
        ypos                    0
        wide                    740
        tall                    153
        visible			        1
        rui                     "ui/character_select_info.rpak"

        pin_to_sibling			PanelFrame
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	TOP_LEFT
    }

    Anchor
    {
        ControlName             Label

        labelText               ""
        xpos                    380
        xpos_nx_handheld        520		[$NX]
        ypos                    236
        wide					50
        tall                    50
        //bgcolor_override		"0 255 0 100"
        //paintbackground			1
    }

    CharacterButton0
    {
        ControlName				RuiButton
        InheritProperties		StoreCharacterButton
        tabPosition             1
    }
    CharacterButton1
    {
        ControlName				RuiButton
        InheritProperties		StoreCharacterButton
    }
    CharacterButton2
    {
        ControlName				RuiButton
        InheritProperties		StoreCharacterButton
    }
    CharacterButton3
    {
        ControlName				RuiButton
        InheritProperties		StoreCharacterButton
    }
    CharacterButton4
    {
        ControlName				RuiButton
        InheritProperties		StoreCharacterButton
    }
    CharacterButton5
    {
        ControlName				RuiButton
        InheritProperties		StoreCharacterButton
    }
    CharacterButton6
    {
        ControlName				RuiButton
        InheritProperties		StoreCharacterButton
    }
    CharacterButton7
    {
        ControlName				RuiButton
        InheritProperties		StoreCharacterButton
    }
    CharacterButton8
    {
        ControlName				RuiButton
        InheritProperties		StoreCharacterButton
    }
    CharacterButton9
    {
        ControlName				RuiButton
        InheritProperties		StoreCharacterButton
    }
    CharacterButton10
    {
        ControlName             RuiButton
        InheritProperties       StoreCharacterButton
    }
    CharacterButton11
    {
        ControlName             RuiButton
        InheritProperties       StoreCharacterButton
    }
    CharacterButton12
    {
        ControlName             RuiButton
        InheritProperties       StoreCharacterButton
    }
    CharacterButton13
    {
        ControlName             RuiButton
        InheritProperties       StoreCharacterButton
    }
    CharacterButton14
    {
        ControlName             RuiButton
        InheritProperties       StoreCharacterButton
    }
    CharacterButton15
    {
        ControlName             RuiButton
        InheritProperties       StoreCharacterButton
    }
    CharacterButton16
    {
        ControlName             RuiButton
        InheritProperties       StoreCharacterButton
    }
    CharacterButton17
    {
        ControlName             RuiButton
        InheritProperties       StoreCharacterButton
    }
    CharacterButton18
    {
        ControlName             RuiButton
        InheritProperties       StoreCharacterButton
    }
    CharacterButton19
    {
        ControlName             RuiButton
        InheritProperties       StoreCharacterButton
    }

    AllLegendsPanel
    {
        ControlName				RuiPanel
        rui                     "ui/all_legends.rpak"
        ypos					-64
        wide					%100
        tall					%100
        visible					0
        zpos                    10

        proportionalToParent    1

        pin_to_sibling			PanelFrame
        pin_corner_to_sibling	TOP
        pin_to_sibling_corner	TOP
    }
}