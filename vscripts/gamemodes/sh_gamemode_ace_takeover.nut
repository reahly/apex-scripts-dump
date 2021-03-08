global function SHGameMode_ACETakeOverMode_Init
global function SHGameMode_ACETakeOverMode_RegisterNetworking

#if(CLIENT)
global function ACETakeOverMode_ServerCallback_AnnouncementSplash

//
const asset ASSET_ANNOUNCEMENT_ICON = $"rui/menu/gamemode_emblem/ace_takeover"
#endif //

struct {
#if(DEV)
	bool debugDraw = false
#endif //
} file

//
//
//
//
//

void function SHGameMode_ACETakeOverMode_Init()
{
	if ( !IsACETakeOverGameMode() )
		return

	#if(false)

#endif //

	#if(DEV)
		file.debugDraw = bool( GetCurrentPlaylistVarInt( "ace_takeover_debug_draw", 0 ) )
	#endif //
}

void function SHGameMode_ACETakeOverMode_RegisterNetworking()
{
	if ( !IsACETakeOverGameMode() )
		return

	Remote_RegisterClientFunction( "ACETakeOverMode_ServerCallback_AnnouncementSplash" )
}

//
//
//
//
//

#if(false)

//




#endif //

#if(CLIENT)
//
void function ACETakeOverMode_ServerCallback_AnnouncementSplash()
{
	entity player = GetLocalClientPlayer()
	if ( !IsValid( player ) )
		return

	float duration = 16.0
	string messageText = "#ACETAKEOVER_LTM_NAME"
	string subText = "#ACETAKEOVER_LTM_BANNER"
	vector titleColor = <0, 0, 0>
	asset icon = $""
	asset leftIcon = ASSET_ANNOUNCEMENT_ICON
	asset rightIcon = ASSET_ANNOUNCEMENT_ICON
	string soundAlias = SFX_HUD_ANNOUNCE_QUICK
	int style = ANNOUNCEMENT_STYLE_SWEEP
	AnnouncementData announcement = Announcement_Create( messageText )
	announcement.drawOverScreenFade = true
	Announcement_SetSubText( announcement, subText )
	Announcement_SetHideOnDeath( announcement, true )
	Announcement_SetDuration( announcement, duration )
	Announcement_SetPurge( announcement, true )
	Announcement_SetStyle( announcement, style )
	Announcement_SetSoundAlias( announcement, soundAlias )
	Announcement_SetTitleColor( announcement, titleColor )
	Announcement_SetIcon( announcement, icon )
	Announcement_SetLeftIcon( announcement, leftIcon )
	Announcement_SetRightIcon( announcement, rightIcon )
	AnnouncementFromClass( player, announcement )
}
#endif //
