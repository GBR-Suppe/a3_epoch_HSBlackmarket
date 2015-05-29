/*
        Arma3 Epoch
        remove vehicle ammo/weapons
        by Halv
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