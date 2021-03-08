//

global function ShDevWeapons_Init


//
#if CLIENT || UI 
void function ShDevWeapons_Init()
{
	#if(CLIENT)
		//

		PrecacheWeapon( "mp_weapon_sentinel" )

                    
                                    
        

		PrecacheWeapon( "melee_bloodhound_axe" )
		PrecacheWeapon( "mp_weapon_bloodhound_axe_primary" )

		PrecacheWeapon( "melee_lifeline_baton" )
		PrecacheWeapon( "mp_weapon_lifeline_baton_primary" )

                                                 
			PrecacheWeapon( "melee_shadowsquad_hands" )
			PrecacheWeapon( "melee_shadowroyale_hands" )
			PrecacheWeapon( "mp_weapon_shadow_squad_hands_primary" )
        

                 
			PrecacheWeapon( "mp_weapon_melee_boxing_ring" )
			PrecacheWeapon( "melee_boxing_ring" )
        

                          
                                                        
        

                
                                                    
        
	#endif
}
#endif


