"resource/ui/menus/panels/club_landing.res"
{
    Screen
    {
        ControlName				Label
        wide			        %100
        tall			        %100
        labelText				""
        visible					0
    }

    PanelFrame
    {
		ControlName				Label
		xpos					0
		ypos					0
		wide					%100
		tall					%100
		labelText				""
		visible				    0
        bgcolor_override        "0 0 0 64"
        paintbackground         1

        proportionalToParent    1
    }

    ClubDiscoveryPanel
    {
        ControlName                 CNestedPanel
        controlSettingsFile         "resource/ui/menus/panels/panel_club_discovery.res"

        xpos                        0
        ypos                        0

        wide                        %100
        tall                        %100
        proportionalToParent        1

        pin_to_sibling              PanelFrame
        pin_corner_to_sibling       CENTER
        pin_to_sibling_corner       CENTER

        visible                     0
    }

    ClubLobbyPanel
    {
        ControlName                 CNestedPanel
        controlSettingsFile         "resource/ui/menus/panels/panel_club_lobby.res"

        xpos                        0
        ypos                        0

        wide                        %100
        tall                        %100
        proportionalToParent        1

        pin_to_sibling              PanelFrame
        pin_corner_to_sibling       CENTER
        pin_to_sibling_corner       CENTER

        visible                     1
    }

    ClubLobbySpinner
    {
        ControlName                 CNestedPanel
        controlSettingsFile         "resource/ui/menus/panels/panel_club_loading.res"

        xpos                        0
        ypos                        0

        wide                        %100
        tall                        %100
        proportionalToParent        1

        pin_to_sibling              PanelFrame
        pin_corner_to_sibling       CENTER
        pin_to_sibling_corner       CENTER

        visible                     1
    }

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    //ChatroomPanel
    //{
    //    ControlName				CNestedPanel
    //    ypos					0
    //    wide					%100
    //    tall					308
    //    visible					1
    //    controlSettingsFile		"resource/ui/menus/panels/chatroom.res"
    //    proportionalToParent    1
    //    pin_to_sibling          PanelFrame
    //    pin_corner_to_sibling	BOTTOM_RIGHT
    //    pin_to_sibling_corner	BOTTOM_RIGHT
    //}

    //OpenInvitePanel
    //{
    //    ControlName				CNestedPanel
    //    xpos					c-300
    //    ypos					r670
    //    zpos					10
    //    wide					552
    //    tall					440
    //    visible					0
    //    controlSettingsFile		"resource/ui/menus/panels/community_openinvites.res"
    //}

    //InviteNetworkButton
    //{
    //    ControlName				RuiButton
    //    wide					320
    //    tall					80
    //    ypos                    16
    //    zpos                    3
    //    rui                     "ui/prototype_generic_button.rpak"
    //    labelText               ""
    //    visible					1
	//
    //    proportionalToParent    1
	//
    //    pin_to_sibling			InviteFriendsButton0
    //    pin_corner_to_sibling	TOP
    //    pin_to_sibling_corner	BOTTOM
    //}

    UserInfo
    {
        ControlName				CNestedPanel

        xpos                    0
        ypos                    0
        tall					500

        zpos					5
        wide					%28
        visible					0
        controlSettingsFile		"resource/ui/menus/panels/user_info.res"
        pin_to_sibling          PanelFrame
        pin_corner_to_sibling	BOTTOM_RIGHT
        pin_to_sibling_corner	BOTTOM_RIGHT
    }

    MatchDetails
    {
        ControlName				CNestedPanel
        xpos					650
        ypos					180
        wide					780
        tall					470
        visible					0
        controlSettingsFile		"resource/ui/menus/panels/match_info.res"
    }

    PopupMessage
    {
        ControlName				RuiButton
        wide        650
        tall        170
        ypos        -38
        rui         "ui/bp_popup_widget.rpak"

        visible     0
        enabled     1
        zpos        100

        pin_to_sibling          PanelFrame
        pin_corner_to_sibling	TOP_LEFT
        pin_to_sibling_corner	TOP
    }
}