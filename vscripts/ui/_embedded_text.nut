global function EmbeddedText_Init

struct
{
} file

void function EmbeddedText_Init()
{
	AddUICallback_InputModeChanged( OnInputModeChanged )
	AddUICallback_KeyBindSet( OnKeyBindSet )

	InitEmbeddedKeyRui( $"ui/key_square_pc.rpak", "KEY_0", "0" )
	InitEmbeddedKeyRui( $"ui/key_square_pc.rpak", "KEY_1", "1" )
	InitEmbeddedKeyRui( $"ui/key_square_pc.rpak", "KEY_2", "2" )
	InitEmbeddedKeyRui( $"ui/key_square_pc.rpak", "KEY_3", "3" )
	InitEmbeddedKeyRui( $"ui/key_square_pc.rpak", "KEY_4", "4" )
	InitEmbeddedKeyRui( $"ui/key_square_pc.rpak", "KEY_5", "5" )
	InitEmbeddedKeyRui( $"ui/key_square_pc.rpak", "KEY_6", "6" )
	InitEmbeddedKeyRui( $"ui/key_square_pc.rpak", "KEY_7", "7" )
	InitEmbeddedKeyRui( $"ui/key_square_pc.rpak", "KEY_8", "8" )
	InitEmbeddedKeyRui( $"ui/key_square_pc.rpak", "KEY_9", "9" )
	InitEmbeddedKeyRui( $"ui/key_square_pc.rpak", "KEY_A", "A" )
	InitEmbeddedKeyRui( $"ui/key_square_pc.rpak", "KEY_B", "B" )
	InitEmbeddedKeyRui( $"ui/key_square_pc.rpak", "KEY_C", "C" )
	InitEmbeddedKeyRui( $"ui/key_square_pc.rpak", "KEY_D", "D" )
	InitEmbeddedKeyRui( $"ui/key_square_pc.rpak", "KEY_E", "E" )
	InitEmbeddedKeyRui( $"ui/key_square_pc.rpak", "KEY_F", "F" )
	InitEmbeddedKeyRui( $"ui/key_square_pc.rpak", "KEY_G", "G" )
	InitEmbeddedKeyRui( $"ui/key_square_pc.rpak", "KEY_H", "H" )
	InitEmbeddedKeyRui( $"ui/key_square_pc.rpak", "KEY_I", "I" )
	InitEmbeddedKeyRui( $"ui/key_square_pc.rpak", "KEY_J", "J" )
	InitEmbeddedKeyRui( $"ui/key_square_pc.rpak", "KEY_K", "K" )
	InitEmbeddedKeyRui( $"ui/key_square_pc.rpak", "KEY_L", "L" )
	InitEmbeddedKeyRui( $"ui/key_square_pc.rpak", "KEY_M", "M" )
	InitEmbeddedKeyRui( $"ui/key_square_pc.rpak", "KEY_N", "N" )
	InitEmbeddedKeyRui( $"ui/key_square_pc.rpak", "KEY_O", "O" )
	InitEmbeddedKeyRui( $"ui/key_square_pc.rpak", "KEY_P", "P" )
	InitEmbeddedKeyRui( $"ui/key_square_pc.rpak", "KEY_Q", "Q" )
	InitEmbeddedKeyRui( $"ui/key_square_pc.rpak", "KEY_R", "R" )
	InitEmbeddedKeyRui( $"ui/key_square_pc.rpak", "KEY_S", "S" )
	InitEmbeddedKeyRui( $"ui/key_square_pc.rpak", "KEY_T", "T" )
	InitEmbeddedKeyRui( $"ui/key_square_pc.rpak", "KEY_U", "U" )
	InitEmbeddedKeyRui( $"ui/key_square_pc.rpak", "KEY_V", "V" )
	InitEmbeddedKeyRui( $"ui/key_square_pc.rpak", "KEY_W", "W" )
	InitEmbeddedKeyRui( $"ui/key_square_pc.rpak", "KEY_X", "X" )
	InitEmbeddedKeyRui( $"ui/key_square_pc.rpak", "KEY_Y", "Y" )
	InitEmbeddedKeyRui( $"ui/key_square_pc.rpak", "KEY_Z", "Z" )
	InitEmbeddedKeyRui( $"ui/key_wide_pc.rpak", "KEY_PAD_0", "NUMPAD0" )
	InitEmbeddedKeyRui( $"ui/key_wide_pc.rpak", "KEY_PAD_1", "NUMPAD1" )
	InitEmbeddedKeyRui( $"ui/key_wide_pc.rpak", "KEY_PAD_2", "NUMPAD2" )
	InitEmbeddedKeyRui( $"ui/key_wide_pc.rpak", "KEY_PAD_3", "NUMPAD3" )
	InitEmbeddedKeyRui( $"ui/key_wide_pc.rpak", "KEY_PAD_4", "NUMPAD4" )
	InitEmbeddedKeyRui( $"ui/key_wide_pc.rpak", "KEY_PAD_5", "NUMPAD5" )
	InitEmbeddedKeyRui( $"ui/key_wide_pc.rpak", "KEY_PAD_6", "NUMPAD6" )
	InitEmbeddedKeyRui( $"ui/key_wide_pc.rpak", "KEY_PAD_7", "NUMPAD7" )
	InitEmbeddedKeyRui( $"ui/key_wide_pc.rpak", "KEY_PAD_8", "NUMPAD8" )
	InitEmbeddedKeyRui( $"ui/key_wide_pc.rpak", "KEY_PAD_9", "NUMPAD9" )
	InitEmbeddedKeyRui( $"ui/key_wide_pc.rpak", "KEY_PAD_DIVIDE", "NUMPAD/" )
	InitEmbeddedKeyRui( $"ui/key_wide_pc.rpak", "KEY_PAD_MULTIPLY", "NUMPAD*" )
	InitEmbeddedKeyRui( $"ui/key_wide_pc.rpak", "KEY_PAD_MINUS", "NUMPAD-" )
	InitEmbeddedKeyRui( $"ui/key_wide_pc.rpak", "KEY_PAD_PLUS", "NUMPAD+" )
	InitEmbeddedKeyRui( $"ui/key_wide_pc.rpak", "KEY_PAD_ENTER", "NUMPADENTER" )
	InitEmbeddedKeyRui( $"ui/key_wide_pc.rpak", "KEY_PAD_DECIMAL", "NUMPAD." )
	InitEmbeddedKeyRui( $"ui/key_square_pc.rpak", "KEY_LBRACKET", "[" )
	InitEmbeddedKeyRui( $"ui/key_square_pc.rpak", "KEY_RBRACKET", "]" )
	InitEmbeddedKeyRui( $"ui/key_square_pc.rpak", "KEY_SEMICOLON", ";" )
	InitEmbeddedKeyRui( $"ui/key_square_pc.rpak", "KEY_APOSTROPHE", "'" )
	InitEmbeddedKeyRui( $"ui/key_square_pc.rpak", "KEY_BACKQUOTE", "~" )
	InitEmbeddedKeyRui( $"ui/key_square_pc.rpak", "KEY_COMMA", "," )
	InitEmbeddedKeyRui( $"ui/key_square_pc.rpak", "KEY_PERIOD", "." )
	InitEmbeddedKeyRui( $"ui/key_square_pc.rpak", "KEY_SLASH", "/" )
	InitEmbeddedKeyRui( $"ui/key_square_pc.rpak", "KEY_BACKSLASH", "\\" )
	InitEmbeddedKeyRui( $"ui/key_square_pc.rpak", "KEY_MINUS", "-" )
	InitEmbeddedKeyRui( $"ui/key_square_pc.rpak", "KEY_EQUAL", "=" )
	InitEmbeddedKeyRui( $"ui/key_wide_pc.rpak", "KEY_ENTER", "ENTER" )
	InitEmbeddedKeyRui( $"ui/key_wide_pc.rpak", "KEY_SPACE", "SPACE" )
	InitEmbeddedKeyRui( $"ui/key_wide_pc.rpak", "KEY_BACKSPACE", "BKSPACE" )
	InitEmbeddedKeyRui( $"ui/key_rect_pc.rpak", "KEY_TAB", "TAB" )
	InitEmbeddedKeyRui( $"ui/key_rect_pc.rpak", "KEY_CAPSLOCK", "CAPS" )
	InitEmbeddedKeyRui( $"ui/key_wide_pc.rpak", "KEY_NUMLOCK", "NUMLOCK" )
	InitEmbeddedKeyRui( $"ui/key_rect_pc.rpak", "KEY_ESCAPE", "ESC" )
	InitEmbeddedKeyRui( $"ui/key_wide_pc.rpak", "KEY_SCROLLLOCK", "SCROLL" )
	InitEmbeddedKeyRui( $"ui/key_rect_pc.rpak", "KEY_INSERT", "INS" )
	InitEmbeddedKeyRui( $"ui/key_rect_pc.rpak", "KEY_DELETE", "DEL" )
	InitEmbeddedKeyRui( $"ui/key_rect_pc.rpak", "KEY_HOME", "HOME" )
	InitEmbeddedKeyRui( $"ui/key_rect_pc.rpak", "KEY_END", "END" )
	InitEmbeddedKeyRui( $"ui/key_rect_pc.rpak", "KEY_PAGEUP", "PGUP" )
	InitEmbeddedKeyRui( $"ui/key_rect_pc.rpak", "KEY_PAGEDOWN", "PGDN" )
	InitEmbeddedKeyRui( $"ui/key_rect_pc.rpak", "KEY_BREAK", "BREAK" )
	InitEmbeddedKeyRui( $"ui/key_wide_pc.rpak", "KEY_LSHIFT", "LSHIFT" )
	InitEmbeddedKeyRui( $"ui/key_wide_pc.rpak", "KEY_RSHIFT", "RSHIFT" )
	InitEmbeddedKeyRui( $"ui/key_rect_pc.rpak", "KEY_LALT", "LALT" )
	InitEmbeddedKeyRui( $"ui/key_rect_pc.rpak", "KEY_RALT", "RALT" )
	InitEmbeddedKeyRui( $"ui/key_wide_pc.rpak", "KEY_LCONTROL", "LCTRL" )
	InitEmbeddedKeyRui( $"ui/key_wide_pc.rpak", "KEY_RCONTROL", "RCTRL" )
	InitEmbeddedKeyRui( $"ui/key_rect_pc.rpak", "KEY_LWIN", "LWIN" )
	InitEmbeddedKeyRui( $"ui/key_rect_pc.rpak", "KEY_RWIN", "RWIN" )
	InitEmbeddedKeyRui( $"ui/key_rect_pc.rpak", "KEY_APP", "APP" )
	//
	//
	//
	//
	InitEmbeddedKeyRui( $"ui/key_rect_pc.rpak", "KEY_UP", "UP" )
	InitEmbeddedKeyRui( $"ui/key_rect_pc.rpak", "KEY_LEFT", "LEFT" )
	InitEmbeddedKeyRui( $"ui/key_rect_pc.rpak", "KEY_DOWN", "DOWN" )
	InitEmbeddedKeyRui( $"ui/key_rect_pc.rpak", "KEY_RIGHT", "RIGHT" )
	InitEmbeddedKeyRui( $"ui/key_square_pc.rpak", "KEY_F1", "F1" )
	InitEmbeddedKeyRui( $"ui/key_square_pc.rpak", "KEY_F2", "F2" )
	InitEmbeddedKeyRui( $"ui/key_square_pc.rpak", "KEY_F3", "F3" )
	InitEmbeddedKeyRui( $"ui/key_square_pc.rpak", "KEY_F4", "F4" )
	InitEmbeddedKeyRui( $"ui/key_square_pc.rpak", "KEY_F5", "F5" )
	InitEmbeddedKeyRui( $"ui/key_square_pc.rpak", "KEY_F6", "F6" )
	InitEmbeddedKeyRui( $"ui/key_square_pc.rpak", "KEY_F7", "F7" )
	InitEmbeddedKeyRui( $"ui/key_square_pc.rpak", "KEY_F8", "F8" )
	InitEmbeddedKeyRui( $"ui/key_square_pc.rpak", "KEY_F9", "F9" )
	InitEmbeddedKeyRui( $"ui/key_square_pc.rpak", "KEY_F10", "F10" )
	InitEmbeddedKeyRui( $"ui/key_square_pc.rpak", "KEY_F11", "F11" )
	InitEmbeddedKeyRui( $"ui/key_square_pc.rpak", "KEY_F12", "F12" )
	InitEmbeddedKeyRui( $"ui/key_rect_pc.rpak", "KEY_CAPSLOCKTOGGLE", "CAPS" )
	InitEmbeddedKeyRui( $"ui/key_wide_pc.rpak", "KEY_NUMLOCKTOGGLE", "NUMLOCK" )
	InitEmbeddedKeyRui( $"ui/key_wide_pc.rpak", "KEY_SCROLLLOCKTOGGLE	", "SCROLL" )
	InitEmbeddedKeyRui( $"ui/key_square_icon_pc.rpak", "ICON_UNBOUND", "%$vgui/fonts/buttons/icon_unbound%" )

	RuiCreateEmbedded( $"ui/embedded_bullet_point.rpak", "embedded_bullet_point" )
}

void function InitEmbeddedKeyRui( asset ruiAsset, string stringReplace, string displayText )
{
	var keyRui = RuiCreateEmbedded( ruiAsset, stringReplace )
	RuiSetEmbeddedRuiString( keyRui, "displayText", displayText )
}

void function OnKeyBindSet( string key, string newBinding )
{
}

void function OnInputModeChanged( bool controllerModeActive )
{
}