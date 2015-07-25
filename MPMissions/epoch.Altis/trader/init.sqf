/*
	a3 epoch trader
	init.sqf
	by Halv & Suppe
	
	Copyright (C) 2015  Halvhjearne & Suppe > README.md
*/
private ["_staticCoords","_blacklistedAreas","_spawnarea"];

_agent = "I_G_resistanceLeader_F";

_addsafezone = true;

_spawnnearroad = true;

_dist2roadMax = 350;

//amount of traders to build
_tradercount = round(random 4)+6;
//min distance from other traders in meters, dont go to higher than _spawnarea/(_tradercount+1) or script will just revert back to this amount to avoid problems 
_mindist = 4000;
//marker text for traders
_markertext = "HS Blackmarket";
//texture on the flag (has to be 200x200), "" to disable
_flagtexture = "trader\dkflagpole.jpg";
//texture on the sign, "" to disable
_sigtexture = "trader\trader.jpg";

//if _staticCoords are set here, there will be a trader at that exact position and direction,
//_blacklistedAreas is where random blackmarkets cannot spawn
switch(toLower worldName)do{
	case "altis":{
		_staticCoords = [
/*
			[traderposition,direction,createmarker,props[classname,position,direction]]
			//"full" array
			[[0,0,0],0,true,[["classname1",[1,1,1],1],["classname2",[2,2,2],2]]]
			//minimal array
			[[0,0,0],0]
*/
			[[18459.1,14259.2,0],340.199,false], //trader by mine
			[[13319,14523.9,0],143.067,false], //trader by stavros
			[[6193.02,16828.7,0],1.52142,false] //trader by kore
		];
		_blacklistedAreas = [
							/*[position,area]*/
			[[18451.9, 14278.1, 0],500],
			[[13326.5, 14515.2, 0],500],
			[[6192.46, 16834, 0],500]
		];
		//distance to search for trader positions
		_spawnarea = 12500;
	};
	case "stratis":{_staticCoords = [];_blacklistedAreas = [[[4089.82, 4597.71, 0],500]];_spawnarea = 6000;};
	case "bornholm":{
		_staticCoords = [];
		_blacklistedAreas = [
			[[14121.2,11331.5,0],500],
			[[1322.18,8733.92,0],500],
			[[15639.3,191.995,0],500]
		];
		_spawnarea = 12500;
	};
	case "chernarus":{
		_staticCoords = [
			[[4584.02,4521.47,0],180.729,false],//trader by Kozlovka
			[[12076.8,5112.95,0],281.836,false],//trader between Msta & Tulga
			[[10676.7,9437.48,0],120.482,false] //trader by Dubrovka
		];
		_blacklistedAreas = [
			[[4569.52, 4524.24, 0],500],
			[[12077.8, 5121.92, 0],500],
			[[10688.6, 9428.98, 0],500]
		];
		_spawnarea = 7000;
	};
	default{_staticCoords = [];_blacklistedAreas = [[[0,0,0],0]];_spawnarea = 7000;};
};

//============================== DONT TOUCH ANYTHING BELOW THIS POINT ==============================\\

// Server stuff...
if(isServer) then{
	diag_log "[HSBlackmarket] Server Loading functions";
	HS_playertraderequest = compileFinal preprocessFileLineNumbers "trader\HS_playertraderequest.sqf";
	HS_weaponsrestriction = compileFinal preprocessFileLineNumbers "trader\HS_weaponsrestriction.sqf";
	HALV_PurgeObject = compileFinal preprocessFileLineNumbers "trader\HALV_PurgeObject.sqf";
	diag_log "[HSBlackmarket] Server adding PVEvent";
	"HSPV_traderrequest" addPublicVariableEventHandler {(_this select 1) call HS_playertraderequest};
	private ["_coords","_roadlist","_firstroad","_statdir"];
/////////////////////////////////////////////////////////////
	/*
	this is taken from:
	objectMapper.sqf Author: Joris-Jan van 't Land
	Edited by HALV
	*/
	private ["_multiplyMatrixFunc"];
	_multiplyMatrixFunc =
	{
		private ["_array1", "_array2", "_result"];
		_array1 = _this select 0;
		_array2 = _this select 1;
		_result = [(((_array1 select 0) select 0) * (_array2 select 0)) + (((_array1 select 0) select 1) * (_array2 select 1)),(((_array1 select 1) select 0) * (_array2 select 0)) + (((_array1 select 1) select 1) * (_array2 select 1))];
		_result
	};
/////////////////////////////////////////////////////////////
	waitUntil {(!isNil "BIS_fnc_findSafePos")};
	waitUntil {(!isNil "BIS_fnc_selectRandom")};
	diag_log "[HSBlackmarket] Server Building traders ...";
	if(_blacklistedAreas isEqualTo [[[0,0,0],0]])then{
		diag_log format["[HSBlackmarket]: no blacklisted areas found for world: %1",worldName];
	}else{
		diag_log format["[HSBlackmarket]: Selected blacklisted areas for world: %1",worldName];
	};
	if(_mindist > _spawnarea/(_tradercount+1))then{
		_mindist = _spawnarea/(_tradercount+1);
		diag_log format["[HSBlackmarket]: Reverted _mindist '%1' to avoid problems",_mindist];
	};
	_units = [];
	_allcords = [];
	for "_i" from 1 to _tradercount do {
		while{true}do{
			scopeName "posiscope";
			_coords = [getMarkerPos "Center",0,_spawnarea,20,0,500,0] call BIS_fnc_findSafePos;
			_IsBlacklisted = false;
			{if(_coords distance (_x select 0) < (_x select 1))exitWith{_IsBlacklisted = true};}count _blacklistedAreas;
			{if(_coords distance _x < _mindist)exitWith{_IsBlacklisted = true};}count _allcords;
			_roadlist = _coords nearRoads _dist2roadMax;
			if(!_IsBlacklisted && !isOnRoad _coords && !surfaceIsWater _coords)then{
				_firstroad = [_roadlist,_coords] call BIS_fnc_nearestPosition;
				if(_spawnnearroad)then{
					if((count _roadlist > 0) && (_coords distance _firstroad > 50))then{breakOut "posiscope"};
				}else{
					if(count _roadlist > 0)then{
						if(_coords distance _firstroad > 50)then{breakOut "posiscope"};
					}else{breakOut "posiscope"};
				};
			};
		};
		_allcords pushBack _coords;
		diag_log format["[HSBlackmarket]: Found position for a HSBlackmarket ... (%1) %2",mapGridPosition _coords,_coords];
		_randir = (random 360);
	//	diag_log format["[HSBlackmarket]: _roadlist: %1 _roadlist: %2",_randir,_roadlist];
		if(count _roadlist > 0)then{
			_randir = [_coords,(position _firstroad)] call BIS_fnc_dirTo;
	//		diag_log format["[HSBlackmarket]: _randir: %1 _firstroad: %2",_randir,_firstroad];
		};
		//create trader and objects
		_objects = 
		[
			[180,180,
				["Land_Campfire_F",[-0.669922,-7.08984,0],0],
				["Land_CampingChair_V2_F",[0.0654297,0.904297,0],2],
				["Land_CampingTable_F",[-0.117188,-1.29102,0],3.62851],
				["Land_CampingTable_small_F",[-5.70996,6.62695,0],133.6414],
				["Land_CampingChair_V1_F",[-5.4375,6.27148,0],140.0554],
				["Land_Ground_sheet_blue_F",[-3.99902,9.41211,0],-128.113],
				["Land_Sleeping_bag_brown_folded_F",[-3.40625,9.90234,0],52.2286],
				["Land_TentDome_F",[-0.620117,8.94727,0],-89.0146],
				["Land_WoodenLog_F",[-2.37109,-6.21289,0],0],
				["Land_WoodenLog_F",[0.00488281,-5.4082,0],0],
				["Land_WoodenLog_F",[1.02344,-7.76953,0],0],
				["CargoNet_01_barrels_F",[-5.90723,2.83398,0],0],
				["CargoNet_01_box_F",[2.25586,7.05273,0],25.5532],
				["FlexibleTank_01_forest_F",[-5.65625,1.40625,0],0],
				["Land_PlasticCase_01_large_F",[4.05664,3.0957,0],291.761],
				["Flag_ARMEX_F",[-5.03809,-3.10938,0],180],
				["Land_PaperBox_open_full_F",[3.4707,5.66992,0],-66.7469],
				["Land_PaperBox_open_empty_F",[4.58105,4.24219,0],23.4405],
				["Land_ScrapHeap_1_F",[-1.34961,3.19141,0],-91.183],
				[(["Land_HelipadCivil_F","Land_HelipadCircle_F","Land_HelipadEmpty_F","Land_HelipadSquare_F","Land_JumpTarget_F"]call BIS_fnc_selectRandom),[-0.304688,-22.9434,0],0],
				["SignAd_Sponsor_F",[-7.05371,-3.66797,0],-31.456],
				["Land_Canteen_F",[-2.36914,9.56641,0],0],
				["Land_FireExtinguisher_F",[-5.31934,0.582031,0],0],
				["Land_Laptop_F",[-4.60547,8.95117,0],-129.859],
				[(["CamoNet_INDP_big_F","CamoNet_OPFOR_big_F","CamoNet_BLUFOR_big_F"]call BIS_fnc_selectRandom),[-0.75,4.9082,0],0]
			],
			[-90,90,
				["Flag_ARMEX_F",[9.69922,5,0],209.0909],
				["CamoNet_BLUFOR_open_Curator_F",[2.09961,1.09961,0],209.0909],
				["Land_Timbers_F",[1.69922,-4.2998,0],-122.6364],
				["Land_IronPipes_F",[-3,0.0996094,0],-75.454],
				["Land_FieldToilet_F",[-4.30078,-5.40039,0],28.273],
				["Land_GasTank_02_F",[2.09961,-2.7998,0],209.0909],
				["Land_WorkStand_F",[1.5,1.59961,0],176.0909],
				["Land_Pallet_F",[7.7998,4.7998,0],209.0909],
				["Land_Pallets_F",[-3.40039,4.09961,0],-59.545],
				["Land_Pallets_stack_F",[9.89941,0.399414,0],-146.364],
				["Land_Pipes_small_F",[-1.40039,4.89941,0],-90.454],
				["Land_WheelCart_F",[10.0996,3.2002,0],-208.182],
				["Land_Workbench_01_F",[-0.100586,178.60059,0],25],
				["Land_Bricks_V4_F",[7.39941,-1.7002,0],172.2727],
				["Land_CampingChair_V2_F",[5.09961,179.7002,0],-151.364],
				["Land_CampingTable_small_F",[4.89941,178.60059,0],-153.636],
				["Land_WoodenLog_F",[6,8.7998,0],209.0909],
				["Land_Campfire_F",[4.59961,8.39941,0],209.0909],
				["Land_WoodenLog_F",[4.7998,6.2002,0],209.0909],
				["Land_WoodenLog_F",[8.2998,4.89941,0],209.0909],
				["Land_WoodenLog_F",[7.39941,4.39941,0],209.0909],
				["Land_TentA_F",[0.799805,8.59961,0],-99.0911],
				[(["Land_HelipadCivil_F","Land_HelipadCircle_F","Land_HelipadEmpty_F","Land_HelipadSquare_F","Land_JumpTarget_F"]call BIS_fnc_selectRandom),[18.8994,-2.90039,0],209.0909],
				["SignAd_Sponsor_F",[0.199219,4.5,0],-75.4541]
			],
			[0,-19.430197,
				["Land_CampingTable_F",[-0.0771484,0.853516,0],160.272,1,0], 
				["Land_CampingChair_V2_F",[0.731445,-1.44629,1.90735e-005],160.679], 
				["CargoNet_01_box_F",[-1.42773,-1.71387,-3.8147e-006],2.04104], 
				["Land_CargoBox_V1_F",[-3.02148,0.523438,0.0305347],6.5862], 
				["Land_WoodenLog_F",[3.06445,0.310547,1.33514e-005],359.99], 
				["CargoNet_01_barrels_F",[-0.617188,-3.64746,0],359.999], 
				["Land_Bricks_V4_F",[3.28223,1.85352,0],77.4211], 
				["Land_Sleeping_bag_F",[3.62402,-2.26758,-5.72205e-005],166.708], 
				["Land_Pillow_camouflage_F",[3.5332,-2.44238,-0.0296116],0.0385798], 
				["Land_WoodPile_F",[3.03516,3.63184,-3.8147e-006],352.152], 
				["Land_Cargo40_blue_F",[-4.07617,-3.80273,0],245.36], 
				["Land_TentA_F",[4.08887,-4.2002,-1.90735e-006],164.006], 
				["O_CargoNet_01_ammo_F",[0.181641,-5.96875,0],72.5656], 
				["Land_Cargo40_brick_red_F",[6.0332,-0.418945,1.90735e-006],256.356], 
				["SignAd_Sponsor_F",[-6.72363,1.97559,-2.67029e-005],155.599], 
				["SignAd_Sponsor_F",[4.4834,5.66699,0.000146866],168.142], 
				["Land_Campfire_F",[-2.51953,6.96484,-9.53674e-006],0], 
				["Flag_ARMEX_F",[5.57227,-5.44141,-1.14441e-005],74.6117], 
				["Land_HBarrierTower_F",[3.19043,-8.56348,7.62939e-006],341.69], 
				["Land_HBarrier_5_F",[-11.4238,6.97852,0.00966454],81.4106], 
				["Land_HBarrier_5_F",[4.87793,12.3633,0.00466537],51.4648], 
				["Land_Cargo40_military_green_F",[-4.41699,12.2959,0.00237656],339.806], 
				[(["Land_HelipadCivil_F","Land_HelipadCircle_F","Land_HelipadEmpty_F","Land_HelipadSquare_F","Land_JumpTarget_F"]call BIS_fnc_selectRandom),[-10.749,30.5313,6.67572e-005],339.294]
			],
			[0,0,
				["Land_CncShelter_F",[-0.046875,0.580078,1.90735e-006],357.404], 
				["Land_CampingChair_V1_F",[0.0585938,-0.673828,-3.8147e-006],178.509], 
				["Land_Ammobox_rounds_F",[-0.632813,-0.664063,3.05176e-005],0], 
				["Land_CashDesk_F",[0.000976563,1.01563,-9.53674e-006],176.522], 
				["Land_HBarrierWall_corridor_F",[0.0253906,-1.33398,-3.8147e-006],268.766], 
				["Land_Money_F",[0.59082,-1.40234,1.90735e-006],0], 
				["Box_IND_WpsLaunch_F",[2.66504,-0.130859,0.000112534],263.01], 
				["Land_HBarrierBig_F",[0.0957031,-3.3418,-1.90735e-006],356.696], 
				["Land_PartyTent_01_F",[-1.54102,4.25195,-0.283783],356.027], 
				["Land_TentA_F",[-4.65137,1.9707,-1.14441e-005],175.654], 
				["Land_HBarrierWall_corner_F",[5.36816,-1.13672,5.53131e-005],88.9725], 
				["Land_ScrapHeap_1_F",[-2.25781,5.82422,0],336.275], 
				["Land_HBarrierWall_corner_F",[-5.72461,-2.73242,-4.19617e-005],175.661], 
				["Land_HBarrierWall6_F",[6.2002,5.00781,-3.8147e-006],88.8191], 
				["I_CargoNet_01_ammo_F",[3.29395,6.26758,-1.90735e-006],354.135], 
				["Land_HBarrierWall6_F",[-7.81152,2.37109,-5.14984e-005],268.762], 
				["I_supplyCrate_F",[-5.28125,5.77148,-1.52588e-005],86.827], 
				["Land_WoodenBox_F",[2.86914,9.89453,1.90735e-006],268.489], 
				["Flag_ARMEX_F",[3.62207,9.92188,-3.8147e-005],0], 
				["Land_GasTank_01_yellow_F",[-5.97559,9.41016,-1.33514e-005],0], 
				["Land_GasTank_01_yellow_F",[-6.07129,9.91406,-4.3869e-005],0], 
				["Land_HBarrierWall4_F",[-7.09766,9.25195,-4.57764e-005],267.767], 
				["Land_CargoBox_V1_F",[3.01172,12.1934,-5.72205e-006],0], 
				["Land_HBarrierWall6_F",[6.0332,12.0391,-8.2016e-005],92.5993], 
				["Land_Campfire_F",[-1.17676,12.8457,-3.8147e-006],0], 
				["Land_CncBarrier_stripes_F",[3.9502,18.3145,5.72205e-006],46.6013], 
				["SignAd_Sponsor_F",[1.74609,19.457,0],268.517], 
				["Land_HBarrierTower_F",[-2.02734,19.7676,1.90735e-006],177.085], 
				["SignAd_Sponsor_F",[-5.6748,19.0156,1.33514e-005],83.7269], 
				["Land_Crash_barrier_F",[-8.78418,21.2773,-1.90735e-006],292.427], 
				[(["Land_HelipadCivil_F","Land_HelipadCircle_F","Land_HelipadEmpty_F","Land_HelipadSquare_F","Land_JumpTarget_F"]call BIS_fnc_selectRandom),[-2.83496,39.7852,-0.000118256],359.41]
			],
			[0,0,
				["Flag_ARMEX_F",[-0.788086,-1.14063,0],0], 
				["Land_WoodenTable_large_F",[-0.917969,1.29883,-0.0575085],69.0909], 
				["Land_Ancient_Wall_8m_F",[2.67578,-0.420898,-0.630144],336.364], 
				["Land_Ancient_Wall_4m_F",[-2.31738,0.493164,-0.719454],251.818], 
				["Land_Bench_F",[2.27148,1.33203,-0.0392952],359.091], 
				["SignAd_Sponsor_F",[-2.91699,-0.139648,-0.789555],72.7272], 
				["Land_BarrelWater_F",[-2.84766,3.59277,-0.0297241],0], 
				["Land_GarbageContainer_open_F",[1.98145,4.67383,-0.0621395],268.182], 
				["Land_Tyres_F",[5.16504,1.0127,-0.0753136],318.182], 
				["Land_Ancient_Wall_8m_F",[3.37598,3.1377,-0.0258389],89.5454], 
				["Land_GarbageWashingMachine_F",[5.55273,5.00879,-0.0555096],0], 
				["Land_Bricks_V1_F",[1.03613,7.59863,-0.0867004],3.63635], 
				["Land_Ancient_Wall_4m_F",[-0.470703,8.37695,-0.531187],309.091], 
				["Land_Bench_F",[-2.08203,7.82129,-0.0440636],39.0909], 
				["Land_Ancient_Wall_4m_F",[2.88281,8.50098,-0.338644],8.18182], 
				[(["Land_HelipadCivil_F","Land_HelipadCircle_F","Land_HelipadEmpty_F","Land_HelipadSquare_F","Land_JumpTarget_F"]call BIS_fnc_selectRandom),[-10.7529,4.375,1.90735e-006],0]
			]
		]call BIS_fnc_selectRandom;
		_extra = _objects deleteAt 0;
		if(_addsafezone)then{_objects pushBack ["ProtectionZone_Invisible_F",[0,0,0],0];};
		_randir = _randir + _extra;
		//creating trader
		_pos0 = [(_coords select 0),(_coords select 1),0];
		_unit = createAgent [_agent, _pos0, [], 0, "CAN_COLLIDE"];
		_unitdir = _objects deleteAt 0;
		_unit setDir (_randir+_unitdir);
		_unit setUnitAbility 0.60000002;
		_unit allowDammage false; _unit disableAI "FSM"; _unit disableAI "MOVE"; _unit disableAI "AUTOTARGET"; _unit disableAI "TARGET"; _unit setBehaviour "CARELESS"; _unit forceSpeed 0;_unit enableSimulation false;
		_unit switchMove "AmovPercMstpSrasWrflDnon_AmovPercMstpSnonWnonDnon";
		_unit setCaptive true;
		_obj = createVehicle ["Land_ClutterCutter_large_F", _pos0, [], 0, "CAN_COLLIDE"];
		_obj setPos _pos0;
		{
			_Dir = (_randir + (_x select 2));
			_newRelPos = [[[cos _randir, sin _randir],[-(sin _randir), cos _randir]], (_x select 1)] call _multiplyMatrixFunc;
			_pos = [(_coords select 0) + (_newRelPos select 0), (_coords select 1) + (_newRelPos select 1), 0];
			_obj = createVehicle [(_x select 0), _pos, [], 0, "CAN_COLLIDE"];
			_obj setDir _Dir;
			_obj setPos _pos;
			_obj allowDammage false;
			_obj enableSimulation false;
			_obj setVariable ["R3F_LOG_disabled", true, true];
			switch (_x select 0) do {
				case "Land_Ammobox_rounds_F":{clearBackpackCargoGlobal _obj;clearItemCargoGlobal _obj;clearMagazineCargoGlobal _obj;clearWeaponCargoGlobal _obj;};
				case "Box_IND_WpsLaunch_F":{clearBackpackCargoGlobal _obj;clearItemCargoGlobal _obj;clearMagazineCargoGlobal _obj;clearWeaponCargoGlobal _obj;};
				case "I_CargoNet_01_ammo_F":{clearBackpackCargoGlobal _obj;clearItemCargoGlobal _obj;clearMagazineCargoGlobal _obj;clearWeaponCargoGlobal _obj;};
				case "I_supplyCrate_F":{clearBackpackCargoGlobal _obj;clearItemCargoGlobal _obj;clearMagazineCargoGlobal _obj;clearWeaponCargoGlobal _obj;};
				case "O_CargoNet_01_ammo_F":{clearBackpackCargoGlobal _obj;clearItemCargoGlobal _obj;clearMagazineCargoGlobal _obj;clearWeaponCargoGlobal _obj;};
				case "Land_Campfire_F":{_obj = createVehicle ["Land_ClutterCutter_medium_F", _pos, [], 0, "CAN_COLLIDE"];_obj setPos _pos;};
				case "Land_Ground_sheet_blue_F":{_obj = createVehicle ["Land_ClutterCutter_large_F", _pos, [], 0, "CAN_COLLIDE"];_obj setPos _pos;};
				case "Flag_ARMEX_F":{if(_flagtexture != "")then{_obj setFlagTexture _flagtexture;};};
				case "Land_HelipadEmpty_F":{_obj = createVehicle ["Land_ClutterCutter_large_F", _pos, [], 0, "CAN_COLLIDE"];_obj setPos _pos;};
				case "SignAd_Sponsor_F":{if(_sigtexture != "")then{_obj setObjectTextureGlobal [0,_sigtexture];};};
			};
		}forEach _objects;
		diag_log "[HSBlackmarket]: HSBlackmarket Creating a Marker";
		_marker = createMarker [format["HSBlackmarket_%1",_i], _coords];
		_marker setMarkerShape "ICON";
		_marker setMarkerType "hd_pickup";
		_marker setMarkerText _markertext;
		_marker setMarkerColor "ColorWEST";
		_units pushBack _unit;
	};
	{
		_pos = _x select 0;
		_dir = _x select 1;
		_createmarker = if(count _x > 2)then{_x select 2}else{true};
		diag_log format["[HSBlackmarket]: HSBlackmarket Creating a Static trader @ (%2) %1",_pos,mapGridPosition _pos];
		_unit = createAgent [_agent, _pos, [], 0, "CAN_COLLIDE"];
		_unit setDir _dir;
		if(surfaceIsWater _pos)then{
			_unit setPosASL _pos;
		}else{
			_unit setPosATL _pos;
		};
		_unit setUnitAbility 0.60000002;
		_unit allowDammage false; _unit disableAI "FSM"; _unit disableAI "MOVE"; _unit disableAI "AUTOTARGET"; _unit disableAI "TARGET"; _unit setBehaviour "CARELESS"; _unit forceSpeed 0;_unit enableSimulation false;
		_unit switchMove "AmovPercMstpSrasWrflDnon_AmovPercMstpSnonWnonDnon";
		_unit setCaptive true;
		_units pushBack _unit;
		if(_createmarker)then{
			diag_log "[HSBlackmarket]: HSBlackmarket Creating a Marker";
			_marker = createMarker [format["HSBlackmarket_%1",(count _units)], _pos];
			_marker setMarkerShape "ICON";
			_marker setMarkerType "hd_dot";
			_marker setMarkerText _markertext;
			_marker setMarkerColor "ColorWEST";
		};
		if(count _x > 3)then{
			_objs = _x select 3;
			{
				_objtype = _x select 0;
				_objpos = _x select 1;
				_objdir = _x select 2;
				_obj = createVehicle [_objtype, _objpos, [], 0, "CAN_COLLIDE"];
				_obj setDir _objdir;
				if(surfaceIsWater _objpos)then{
					_obj setPosASL _objpos;
				}else{
					_obj setPosATL _objpos;
				};
				_obj allowDammage false;
				_obj enableSimulation false;
				_obj setVariable ["R3F_LOG_disabled", true, true];
			}forEach _objs;
		};
	}forEach _staticCoords;
	HSPV_HSBlackmarket = _units;
	publicVariable "HSPV_HSBlackmarket";
	diag_log "[HSBlackmarket] Server Done ...";
};

// Client stuff...
if(hasInterface)then{
	diag_log "[HSBlackmarket]: Client waiting for Trader ...";
	waitUntil {sleep 1;(!isNil "HSPV_HSBlackmarket")};
	{
		_x addAction ["<img size='1.5'image='\a3\Ui_f\data\gui\Rsc\RscDisplayArcadeMap\icon_layout_ca.paa'/> <t color='#0096ff'>HS Trader Menu</t>",
		{
			/*
			systemChat "WARNING:";
			systemChat "This trader is NOT finished yet ...";
			systemChat "... you might loose items and / or crypto trading here!";
			*/
			HS_SWITCH = false;
			createDialog "HS_trader_dialog";
			call HS_trader_menu;
		},_x, -9, true, true, "", "player distance _target < 5"];
	}forEach HSPV_HSBlackmarket;
	HSPV_HSBlackmarket = nil;
	call compile preprocessFileLineNumbers "trader\tradermenu.sqf";
	diag_log "[HSBlackmarket]: Client Done ...";
};


