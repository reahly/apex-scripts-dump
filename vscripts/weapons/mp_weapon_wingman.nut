global function OnWeaponActivate_weapon_wingman
global function OnWeaponDeactivate_weapon_wingman


void function OnWeaponActivate_weapon_wingman( entity weapon )
{
	OnWeaponActivate_ReactiveKillEffects( weapon )
}

void function OnWeaponDeactivate_weapon_wingman( entity weapon )
{
	OnWeaponDeactivate_ReactiveKillEffects( weapon )
}