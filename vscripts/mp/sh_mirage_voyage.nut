#if(CLIENT)
global function ClMirageVoyage_Init
#endif //

#if(false)

#endif //


#if(false)










#endif //


#if(CLIENT)
const string MIRAGE_VOYAGE_MUSIC_CONTROLLER_SCRIPT_NAME = "mirage_voyage_music_target"
#endif


#if(false)





























//
//








































#endif //


#if(CLIENT)
const string MIRAGE_VOYAGE_AMBIENT_GENERIC_SCRIPT_NAME = "mirage_tt_music_ambient_generic"
#endif



#if(false)













#endif //


#if(false)












#endif //


//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//


#if(CLIENT)
void function ClMirageVoyage_Init()
{
	AddCallback_EntitiesDidLoad( InitMirageVoyageMusicEnts )
}
#endif //


#if(CLIENT)
void function InitMirageVoyageMusicEnts()
{
	if ( !IsMirageVoyageEnabled() )
		return

	entity musicController = GetEntByScriptName( MIRAGE_VOYAGE_MUSIC_CONTROLLER_SCRIPT_NAME )
	entity ambientGeneric  = GetEntByScriptName( MIRAGE_VOYAGE_AMBIENT_GENERIC_SCRIPT_NAME )

	ambientGeneric.SetSoundCodeControllerEntity( musicController )
}
#endif //


#if(false)














#endif //


#if(false)





//








//



//









//

















//







//















//





//







//





//






//









//






//









//






//









//







//








//








//










//


//
























//



//




#endif //


#if(false)













#endif


#if(false)







#endif


bool function IsMirageVoyageEnabled()
{
	if ( GetCurrentPlaylistVarBool( "mirage_tt_enabled", true ) )
	{
		array<string> entScriptnamesToCheck
		#if(false)




#elseif(CLIENT)
			entScriptnamesToCheck.append( MIRAGE_VOYAGE_AMBIENT_GENERIC_SCRIPT_NAME )
		#endif

		bool allEntsPresent = true
		foreach ( string scriptName in entScriptnamesToCheck )
		{
			array<entity> entsToCheck = GetEntArrayByScriptName( scriptName )

			if ( entsToCheck.len() == 0 )
			{
				allEntsPresent = false
				break
			}
		}

		if ( allEntsPresent )
			return true

		return false

	}

	return false
}


//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//


#if(false)














#endif //


#if(false)







#endif //


#if(false)













#endif //


#if(false)




//





//



//


//


//







//






//























//








#endif //


#if(false)





















































//













//



#endif


#if(false)




//







//






//













//















#endif //


#if(false)














#endif //


//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//


#if(false)














//










//


//

















//

















//



//




//





















#endif //


#if(false)




















#endif //


#if(false)
















#endif //


#if(false)




#endif //


#if(false)















#endif //


#if(false)





















#endif //


#if(false)













































#endif //

#if(false)









#endif
