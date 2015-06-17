/*
        Arma3 Epoch
        remove vehicle ammo/weapons
        by Halv
	
	Copyright (C) 2015  Halvhjearne & Suppe
	This program is free software: you can redistribute it and/or modify
	it under the terms of the GNU General Public License as published by
	the Free Software Foundation, either version 3 of the License, or
	(at your option) any later version.
	This program is distributed in the hope that it will be useful,
	but WITHOUT ANY WARRANTY; without even the implied warranty of
	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
	GNU General Public License for more details.
	You should have received a copy of the GNU General Public License
	along with this program.  If not, see <http://www.gnu.org/licenses/>.
	Contact : halvhjearne@gmail.com
*/
 
_restrictedvehicles = [
        //Vehicleclass                          //Weapons to remove                    
        ["B_Heli_Light_01_armed_F",["missiles_DAR"]]
];
 
//vehicle ammo %, note that this might add ammo to a vehicles with ammo below this amount, 1 = no change
_vehicleammo = 1;
 
if(hasInterface)exitWith{};
waitUntil{!isNil "EPOCH_allowedVehiclesList"};
waitUntil{isNil "EPOCH_allowedVehiclesList"};
 
{
        _veh = _x;
        {
                _res = _x;
                if(_veh isKindOf (_res select 0))then{
                        {_veh removeWeapon _x;}forEach (_res select 1);
                        if(_vehicleammo < 1)then{
                                _veh setVehicleAmmo _vehicleammo;
                        };
                };
        }forEach _restrictedvehicles;
}forEach vehicles;