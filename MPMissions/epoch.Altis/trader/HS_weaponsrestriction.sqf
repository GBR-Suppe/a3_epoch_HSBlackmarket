/*
	a3 epoch trader
	HS_weaponsrestriction.sqf
	by Halv & Suppe
	
	Copyright (C) 2015  Halvhjearne & Suppe > README.md
*/
#include "settings.sqf";

_vehicle = _this;

//_vehicle setVehicleAmmo _setVehicleAmmo;
_turrets = (allturrets [_vehicle,true])+[[-1]];

{
	_restriction = _x;
	if(_vehicle isKindOf (_restriction select 0))exitWith{
		{
			_turret = _x;
			{
				_veh removeWeaponTurret [_x,_turret];
			}forEach (_restriction select 1);
		}forEach _turrets;
	};
}forEach _restrictedvehicles;

if(_clearammo)then{
	{
		_path = _x;
		{
			if !(_x in _dontremove)then{
				_vehicle removeMagazinesTurret [_x,_path];
			};
		}forEach (_vehicle magazinesTurret _path);
	}forEach _turrets;
};
