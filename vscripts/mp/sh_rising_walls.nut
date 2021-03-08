#if(false)






#endif


#if(CLIENT)
global function ClRisingWalls_Init
global function ServerToClient_SetRisingWallAmbientGenericState
#endif


#if(CLIENT)
global const string RISABLE_WALL_BRUSH_SCRIPTNAME = "risable_wall_brush"

const string RISABLE_WALL_HELPER_SCRIPTNAME = "rising_wall_helper"
const string RISABLE_WALL_PANEL_SCRIPTNAME = "risable_wall_top_panel"
const string RISABLE_WALL_MOVER_TOP_SCRIPTNAME = "risable_wall_top_mover"
const string RISABLE_WALL_MOVER_BASE_SCRIPTNAME = "risable_wall_base_mover"
const string RISABLE_WALL_MOVER_FLAP_SCRIPTNAME = "risable_wall_flap_mover"
const string RISABLE_WALL_FLOOR_MODEL_SCRIPTNAME = "rising_wall_floor_model"
const string RISABLE_WALL_FX_TRANSITION = "FX_wall_transition"
const string RISABLE_WALL_FX_COMPLETE = "FX_wall_complete"

const float WALL_RAISE_SEQ_DURATION = 20.0
const float DISPERSE_STICKY_LOOT_DURATION = 14.0
#endif //


#if(false)





















#endif //


#if(CLIENT)
const string AMBIENT_GENERIC_SCRIPTNAME = "rising_wall_ambient_generic"
#endif


struct RisableWallData
{
	array<entity> panels
	entity        moverTop
	entity        moverFlap
	entity        moverBase
	entity        baseWallBrush
	entity        topWallBrush
	entity        flapWallBrush

	bool hasStartedRising = false

	#if(false)







#else
		array<entity> ambientGenerics
	#endif
}


struct
{
	table<EHI, RisableWallData> risableWallEHandleDataGroups

	#if(false)

#endif
} file


#if(false)








#endif


#if(CLIENT)
void function ClRisingWalls_Init()
{
	AddCallback_EntitiesDidLoad( EntitiesDidLoad )
}
#endif


void function EntitiesDidLoad()
{
	if ( !DoRisableWallEntsExist() )
		return

	#if(CLIENT)
		array<entity> allAmbientGenerics = GetEntArrayByScriptName( AMBIENT_GENERIC_SCRIPTNAME )
		foreach ( entity ambientGeneric in allAmbientGenerics )
			ambientGeneric.SetEnabled( false )
	#endif

	foreach ( entity helper in GetEntArrayByScriptName( RISABLE_WALL_HELPER_SCRIPTNAME ) )
	{
		RisableWallData data
		EHI helperEHI = ToEHI( helper )

		#if(false)

#endif

		foreach ( entity linkEnt in helper.GetLinkEntArray() )
		{
			string scriptName = linkEnt.GetScriptName()

			if ( scriptName == RISABLE_WALL_PANEL_SCRIPTNAME )
			{
				data.panels.append( linkEnt )
			}
			else if ( scriptName == RISABLE_WALL_MOVER_BASE_SCRIPTNAME )
			{
				data.moverBase = linkEnt
				#if(false)

#endif

				foreach ( entity childEnt in linkEnt.GetChildren() )
				{
					string className

					#if(false)

#else
						className = expect string( childEnt.GetNetworkedClassName() )
					#endif

					if ( className == "func_brush" )
					{
						data.baseWallBrush = childEnt
						data.baseWallBrush.SetScriptName( RISABLE_WALL_BRUSH_SCRIPTNAME )
					}
				}
			}
			else if ( scriptName == RISABLE_WALL_MOVER_TOP_SCRIPTNAME )
			{
				data.moverTop = linkEnt
				#if(false)

#endif

				foreach ( entity childEnt in linkEnt.GetChildren() )
				{
					string className

					#if(false)

#else
						className = expect string( childEnt.GetNetworkedClassName() )
					#endif

					if ( className == "func_brush" )
					{
						data.topWallBrush = childEnt
						data.topWallBrush.SetScriptName( RISABLE_WALL_BRUSH_SCRIPTNAME )
					}
				}
			}
			else if ( scriptName == RISABLE_WALL_MOVER_FLAP_SCRIPTNAME )
			{
				data.moverFlap = linkEnt
				#if(false)

#endif

				foreach ( entity childEnt in linkEnt.GetChildren() )
				{
					string className

					#if(false)

#else
						className = expect string( childEnt.GetNetworkedClassName() )
					#endif

					if ( className == "func_brush" )
					{
						data.flapWallBrush = childEnt
						data.flapWallBrush.SetScriptName( RISABLE_WALL_BRUSH_SCRIPTNAME )
					}
				}
			}
#if(false)




















#endif
		}

		#if(CLIENT)
			foreach ( entity ambientGeneric in allAmbientGenerics )
			{
				entity parentEnt = ambientGeneric.GetParent()
				if ( IsValid( parentEnt ) && IsValid( data.baseWallBrush ) && data.baseWallBrush == parentEnt )
					data.ambientGenerics.append( ambientGeneric )
			}
		#endif

		#if(false)
//





//











//

#endif

		string instanceName = data.panels[0].GetInstanceName()

		if ( instanceName == "" )
		{
			Warning( "Risable wall instance at pos: " + data.panels[0].GetOrigin() + " needs an instance name." )
		}
		else
		{
			data.panels.extend( GetEntArrayByScriptName( format( "%s_extra_panel", instanceName ) ) )
		}

		foreach ( entity wallPanel in data.panels )
		{
			#if(false)







#endif
			//

			AddCallback_OnUseEntity_ClientServer( wallPanel, CreateRisableWallPanelFunc( data, helper ) )
		}

		#if(false)

#endif

		file.risableWallEHandleDataGroups[helperEHI] <- data
	}
}


#if(false)





























#endif


#if(false)










#endif


#if(CLIENT)
bool function DoRisableWallEntsExist()
{
	array<string> entNamesToCheck

	#if(false)








#endif

	foreach ( string scriptName in entNamesToCheck )
	{
		array<entity> ents = GetEntArrayByScriptName( scriptName )
		if ( ents.len() < 1 )
			return false
	}

	return true
}
#endif //


#if(CLIENT)
void functionref( entity panel, entity player, int useInputFlags ) function CreateRisableWallPanelFunc( RisableWallData data, entity helper )
{
	return void function( entity panel, entity player, int useInputFlags ) : ( data, helper )
	{
		thread OnRisableWallPanelActivate( data, helper, panel, player )
	}
}
#endif //


#if(CLIENT)
void function OnRisableWallPanelActivate( RisableWallData data, entity helper, entity activePanel, entity playerUser )
{
	if ( data.hasStartedRising )
		return

	data.hasStartedRising = true

	#if(false)

























#endif //

	AddEntToInvalidEntsForPlacingPermanentsOnto( data.baseWallBrush )
	AddEntToInvalidEntsForPlacingPermanentsOnto( data.flapWallBrush )
	AddRefEntAreaToInvalidOriginsForPlacingPermanentsOnto( data.moverBase, <-94, -896, -32>, <122, 890, 24> )

	#if(false)

#endif

	#if(false)












#endif //

	OnThreadEnd(
		function() : ( data )
		{
			#if(false)

#endif //
		}
	)

	#if(false)














//





#endif //

	wait DISPERSE_STICKY_LOOT_DURATION

	#if(false)










#endif

	wait WALL_RAISE_SEQ_DURATION - DISPERSE_STICKY_LOOT_DURATION

	#if(false)











#endif //

	#if(CLIENT)
		AddToAllowedAirdropDynamicEntities( data.topWallBrush )
	#endif

	#if(false)


#endif //
}
#endif //


#if(CLIENT)
void function ServerToClient_SetRisingWallAmbientGenericState( entity helper, bool shouldEnable )
{
	if ( !IsValid( helper ) )
		return

	EHI helperEHI = ToEHI( helper )

	if ( !( helperEHI in file.risableWallEHandleDataGroups ) )
		return

	RisableWallData data = file.risableWallEHandleDataGroups[ helperEHI ]

	foreach ( entity ambientGeneric in data.ambientGenerics )
	{
		if ( IsValid( ambientGeneric ) )
		{
			if ( !shouldEnable )
			{
				ambientGeneric.Destroy()
			}
			else
			{
				ambientGeneric.SetEnabled( true )
			}
		}
	}
}
#endif


#if(false)




#endif //


#if(false)


















#endif //


#if(false)







#endif //

#if(false)





#endif //
