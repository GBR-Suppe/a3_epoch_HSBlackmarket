/*
	a3 epoch trader
	settings.sqf
	by Halv & Suppe
	
	Copyright (C) 2015  Halvhjearne & Suppe > README.md
*/
//this is to blacklist items you do not want in the blackmarket
_blacklist = [
"srifle_DMR_03_spotter_F","13Rnd_mas_9x19_Mag","25Rnd_mas_9x21_Mag","B_mas_HMMWV_SOV_M2","CUP_arifle_M16A4GL","CUP_arifle_ksvk_PSO3","CUP_srifle_M15_Aim",
"CUP_optic_AN_PVS_4","CUP_optic_AN_PVS_10","CUP_optic_CWS","CUP_optic_AN_PAS_13c1","CUP_optic_AN_PAS_13c2","CUP_optic_GOSHAWK","CUP_optic_NSPU","optic_Nightstalker",
"optic_NVS","CUP_SMAW_HEAA_M"
];

//this is how vehicles spawn, 0 = player gets menu to decide, 1 = only allow saved vehicles, 2 = only allow rentals
_vehiclespawnmode = 0;

//restrict vehicle weaponry here
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

//this is to remove all ammo on any vehicle purchase
_clearammo = true;

//this is ammo excluded from above removal
_dontremove =
[
	"Laserbatteries","SmokeLauncherMag_boat","SmokeLauncherMag","300Rnd_CMFlare_Chaff_Magazine","168Rnd_CMFlare_Chaff_Magazine","192Rnd_CMFlare_Chaff_Magazine",
	"240Rnd_CMFlare_Chaff_Magazine","120Rnd_CMFlare_Chaff_Magazine","60Rnd_CMFlare_Chaff_Magazine","240Rnd_CMFlareMagazine","120Rnd_CMFlareMagazine",
	"60Rnd_CMFlareMagazine"
];

