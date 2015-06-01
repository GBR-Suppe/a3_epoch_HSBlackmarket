/*
	a3 epoch trader
	settings.sqf
	by Halv & Suppe
*/

_blacklist = ["srifle_DMR_03_spotter_F","13Rnd_mas_9x19_Mag","25Rnd_mas_9x21_Mag","B_mas_HMMWV_SOV_M2"];

_restrictedvehicles = [
	/*
		["vehicleclassname",["weaponclassname1","weaponclassname2","weaponclassname3"]],
	*/
		["O_Heli_Attack_02_black_F",["missiles_SCALPEL"]],
		["O_Heli_Attack_02_F",["missiles_SCALPEL"]],
		["O_Heli_Light_02_F",["missiles_DAGR"]],
		["B_Heli_Attack_01_F",["missiles_DAGR"]],
		["O_Heli_Light_02_v2_F",["missiles_DAGR"]],
		["B_APC_Wheeled_01_cannon_F",["autocannon_40mm_CTWS"]],
		["O_APC_Tracked_02_cannon_F",["missiles_titan"]],
		["I_APC_Wheeled_03_cannon_F",["missiles_titan"]],
		["B_Plane_CAS_01_F",["Missile_AA_04_Plane_CAS_01_F","Missile_AGM_02_Plane_CAS_01_F","Bomb_04_Plane_CAS_01_F"]],
		["I_Plane_Fighter_03_AA_F",["missiles_Zephyr","missiles_ASRAAM"]],
		["I_Plane_Fighter_03_CAS_F",["missiles_SCALPEL","missiles_ASRAAM","GBU12BombLauncher"]],
		["O_Plane_CAS_02_F",["Missile_AA_03_Plane_CAS_02_F","Missile_AGM_01_Plane_CAS_02_F","Bomb_03_Plane_CAS_02_F"]],
		["B_Heli_Light_01_armed_F",["missiles_DAR"]]
];
//this is to set vehicle ammo amount, range from 0 to 1 - 0 is empty, 1 is full ammo
_setVehicleAmmo = 0;
//this is how vehicles spawn, 0 = player gets menu to decide, 1 = only allow saved vehicles, 2 = only allow rentals
_vehiclespawnmode = 0;
