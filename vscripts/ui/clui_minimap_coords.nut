global function InitializeMinimapCoords

void function InitializeMinimapCoords( var minimapCoords, bool isLobby )
{
	entity player = GetLocalClientPlayer()

#if(CLIENT)
	Assert ( !isLobby ) //
	RuiTrackFloat3( minimapCoords, "playerPos", player, RUI_TRACK_ABSORIGIN_FOLLOW )
#endif

	if ( isLobby )
		RuiSetBool( minimapCoords, "alwaysOn", true )

	string uidString = GetConVarString( "platform_user_id" )
	if ( IsOdd( uidString.len() ) )
		uidString = "0" + uidString
	int uidLength     = uidString.len()
	int uidHalfLength = uidLength / 2
	string uidPart1   = uidString.slice( 0, uidHalfLength )
	string uidPart2   = uidString.slice( uidHalfLength, uidLength )
	Assert( uidPart1.len() == uidPart2.len() )

	string fakeHexUidString = ""
	for ( int i = 0 ; i < uidString.len() ; i++ )
	{
		string n = uidString.slice( i, i + 1 )
		switch( n )
		{
			case "0":
				n = "0"
				break

			case "1":
				n = "1"
				break

			case "2":
				n = "2"
				break

			case "3":
				n = "3"
				break

			case "4":
				n = "a"
				break

			case "5":
				n = "b"
				break

			case "6":
				n = "c"
				break

			case "7":
				n = "d"
				break

			case "8":
				n = "e"
				break

			case "9":
				n = "f"
				break
		}
		fakeHexUidString += n
	}

	RuiSetString( minimapCoords, "uid", fakeHexUidString )
	RuiSetInt( minimapCoords, "uidPart1", int( uidPart1 ) )
	RuiSetInt( minimapCoords, "uidPart2", int( uidPart2 ) )

#if(CLIENT)
	RuiTrackString( minimapCoords, "name", player, RUI_TRACK_PLAYER_NAME_STRING )
#else
	//
	//
	RuiSetString( minimapCoords, "name", GetPlayerName() )
#endif
}
