/*
	a3 epoch trader
	HS_weaponsrestriction.sqf
	by Halv & Suppe
*/
#include "settings.sqf";

_this setVehicleAmmo _setVehicleAmmo;

{
	if(_this isKindOf (_x select 0))exitWith{
		{_this removeWeapon _x;}forEach (_x select 1);
	};
}forEach _restrictedvehicles;
