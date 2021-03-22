"resource/ui/menus/panels/panel_club_lobby_requests.res"
{
    Anchor
    {
        ControlName				Label
        xpos                    -2
        ypos					0
        wide					%100
        tall					%100
        labelText				""
        visible				    1
        bgcolor_override        "0 0 0 64"
        paintbackground         1
        proportionalToParent    1
    }

	JoinRequestsButton
    {
        ControlName				RuiButton
        classname               "MenuButton"
        wide					192
        tall					48
        xpos                    -320
        ypos                    -8
        rui                     "ui/generic_button.rpak"
        labelText               ""
        visible					1
        cursorVelocityModifier  0.7

        //navDown                   ModeButton

        proportionalToParent    1

        pin_to_sibling			Anchor
        pin_corner_to_sibling	BOTTOM_LEFT
        pin_to_sibling_corner	BOTTOM_LEFT

        sound_focus             "UI_Menu_Focus_Large"
    }

    JoinRequestsLabel
    {
        ControlName				Label
        wide					%50
        tall					48
        xpos                    16
        ypos                    4
        zpos                    0
        labelText               ""
        textAlignment           "west"
        wrap                    1
        visible					1
        bgcolor_override        "0 0 0 128"
        paintbackground         0

        pin_to_sibling          JoinRequestsButton
        pin_corner_to_sibling   LEFT
        pin_to_sibling_corner   RIGHT
    }
}