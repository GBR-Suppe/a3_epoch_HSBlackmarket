/*
	a3 epoch trader
	tradermenu.sqf
	by Halv & Suppe
	
	Copyright (C) 2015  Halvhjearne & Suppe > README.md
*/

#include "settings.sqf";

HS_fnc_returnnameandpic = {
	_item = _this;
	_pic = "";
	_txt = "";
	_libtxt = "";
	_type = "";
	_BIStype = [];
	{
		if(isClass(configFile >> _x >> _item))exitWith{
			_type = _x;
			_pic = (gettext (configFile >> _type >> _item >> "picture"));
			_txt = (gettext (configFile >> _type >> _item >> "displayName"));
			_libtxt = (gettext (configFile >> _type >> _item >> "Library" >> "libTextDesc"));
			_BIStype = _item call BIS_fnc_itemType;
		};
	}forEach ["cfgweapons","cfgmagazines","cfgvehicles","cfgglasses"];
	_return = [_type,_txt,_libtxt,_pic,_BIStype select 0,_BIStype select 1];
	_return
};

_config = "HSPricing" call EPOCH_returnConfig;
HS_trader_itemlist = [];
for "_i" from 0 to (count _config)-1 do {
	_type = _config select _i;
	if (isClass _type) then {
		_item = configName(_type);
//		diag_log str["DEBUG:",_item];
		if !(_item in _blacklist)then{
			_price = getNumber(_config >> _item >> "price");
			_tax = getNumber(_config >> _item >> "tax");
			_info = _item call HS_fnc_returnnameandpic;
			HS_trader_itemlist pushBack [_item,_price,_tax,_info select 0,_info select 1,_info select 2,_info select 3,_info select 4,_info select 5];
		};
	};
};

//[item,price,tax,cfg,name,libtxt,pic]

HS_trader_menu = {
	disableSerialization;
	HS_BUYSELLARRAY = [];
	_currentarray = HS_trader_itemlist;
	if(HS_SWITCH)then{
		_HS_nearvehiclestypes = [];
		_HS_nearvehicles = [];
		{
			if((owner _x) isEqualTo (owner player))then{
				_HS_nearvehiclestypes pushBack (typeOf _x);
				_HS_nearvehicles pushBack _x;
			};
		}forEach (nearestObjects [player,["Air","Landvehicle","Ship"],60]);
		HS_PLAYER_itemlist = [];
		_config = "HSPricing" call EPOCH_returnConfig;
		_list = [];
		{
			if (_x != "")then{
				_list pushBack _x;
			};
		}forEach (assignedItems player)+(primaryWeaponItems player)+(handgunItems player)+(secondaryWeaponItems player)+(uniformItems player)+(vestItems player)+(backpackItems player)+[primaryWeapon player,handgunWeapon player,secondaryWeapon player,uniform player,vest player,backpack player,headgear player,goggles player];
		{
			_price = getNumber(_config >> _x >> "price");
			if(_price > 0)then{
				_info = _x call HS_fnc_returnnameandpic;
				HS_PLAYER_itemlist pushBack [_x,_price,getNumber(_config >> _x >> "tax"),_info select 0,_info select 1,_info select 2,_info select 3,_info select 4,_info select 5]
			};
		}forEach _list;
		{
			_price = getNumber(_config >> _x >> "price");
			if(_price > 0)then{
				_info = _x call HS_fnc_returnnameandpic;
		//damage price reductions, the price is divded by this number
				_obj = _HS_nearvehicles select _forEachIndex;
				if((_obj getVariable ["HSHALFPRICE",0]) isEqualTo 1)then{_price = _price/2;};
				_damagepricereduction = switch(true)do{
							//damaged over 90%
					case ((damage _obj) > 0.9):{10};
							//damaged over 75%
					case ((damage _obj) > 0.75):{5};
							//damaged over 50%
					case ((damage _obj) > 0.5):{3};
							//damaged over 25%
					case ((damage _obj) > 0.25):{1.5};
					default {1};
				};
				_price = round(_price/_damagepricereduction);
				HS_PLAYER_itemlist pushBack [_x,_price,getNumber(_config >> _x >> "tax"),_info select 0,_info select 1,_info select 2,_info select 3,_info select 4,_info select 5,_obj]
			};
		}forEach _HS_nearvehiclestypes;
		_currentarray = HS_PLAYER_itemlist;
	};
	_ctrl = (findDisplay 9999) displayCtrl 9997;
	tvClear _ctrl;
	_sp = [];
	{
		_mainindex = _ctrl tvAdd [[],_x select 0];
		_ctrl tvSetPicture [[_mainindex],_x select 1];
		_ctrl tvsetValue [[_mainindex],-1];
		switch(_mainindex)do{
			case 0:{
				{
					_index = _ctrl tvAdd [[_mainindex],_x select 0];
					_ctrl tvSetPicture [[_mainindex,_index],_x select 1];
					_ctrl tvsetValue [[_mainindex,_index],-1];
					_sp pushBack [_mainindex,_index];
				}forEach [
				[localize "STR_HS_ASSAULTRIFLES","\a3\Ui_f\data\gui\cfg\Hints\rifle_ca.paa"],
				[localize "STR_HS_HANDGUNS","\a3\Ui_f\data\gui\cfg\Hints\handgun_ca.paa"],
				[localize "STR_HS_MACHINEGUNS","\a3\Ui_f\data\gui\cfg\Hints\ranged_ca.paa"],
				[localize "STR_HS_SNIPERRIFLES","\a3\Ui_f\data\gui\cfg\Hints\sniper_ca.paa"],
				[localize "STR_HS_SUBMACHINEGUNS","\a3\Ui_f\data\gui\cfg\Hints\rifles_ca.paa"],
				[localize "STR_HS_LAUNCHERS","\a3\Ui_f\data\gui\cfg\Hints\launcher_ca.paa"],
				[localize "STR_HS_OTHER","\a3\Ui_f\data\gui\cfg\Hints\slots_ca.paa"]
				];
			};
			case 1:{
				{
					_index = _ctrl tvAdd [[_mainindex],_x select 0];
					_ctrl tvSetPicture [[_mainindex,_index],_x select 1];
					_ctrl tvsetValue [[_mainindex,_index],-1];
					_sp pushBack [_mainindex,_index];
				}forEach [
				[localize "STR_HS_AMMOBULLETS","\a3\Ui_f\data\gui\cfg\Hints\firemode_ca.paa"],
				[localize "STR_HS_AMMOROCKETS","\a3\Ui_f\data\gui\cfg\Hints\ammotype_ca.paa"],
				[localize "STR_HS_BUILDINGSUPP","\a3\Ui_f\data\gui\Rsc\RscDisplayGarage\animationsources_ca.paa"],
				[localize "STR_HS_FOOD","\a3\Ui_f\data\gui\Rsc\RscDisplayArcadeMap\section_mission_ca.paa"],
				[localize "STR_HS_OTHER","\a3\Ui_f\data\gui\cfg\Hints\slots_ca.paa"]
				];
			};
			case 2:{
				_index = _ctrl tvAdd [[_mainindex],"Attachments"];
				_ctrl tvSetPicture [[_mainindex,_index],"\a3\Ui_f\data\gui\Rsc\RscDisplayArsenal\itemoptic_ca.paa"];
				_ctrl tvsetValue [[_mainindex,_index],-1];
				{
					_index2 = _ctrl tvAdd [[_mainindex,_index],_x select 0];
					_ctrl tvSetPicture [[_mainindex,_index,_index2],_x select 1];
					_ctrl tvsetValue [[_mainindex,_index,_index2],-1];
					_sp pushBack [_mainindex,_index,_index2];
				}forEach [
				[localize "STR_HS_BIPODS","\a3\Ui_f\data\gui\Rsc\RscDisplayArsenal\itembipod_ca.paa"],
				[localize "STR_HS_MUZZLES","\a3\Ui_f\data\gui\Rsc\RscDisplayArsenal\itemmuzzle_ca.paa"],
				[localize "STR_HS_OPTICS","\a3\Ui_f\data\gui\Rsc\RscDisplayArsenal\itemoptic_ca.paa"],
				[localize "STR_HS_POINTERS","\a3\Ui_f\data\gui\Rsc\RscDisplayArsenal\itemacc_ca.paa"]
				];
				_index = _ctrl tvAdd [[_mainindex],"Tool Items & Other"];
				_ctrl tvSetPicture [[_mainindex,_index],_x select 1];
				_ctrl tvsetValue [[_mainindex,_index],-1];
				_sp pushBack [_mainindex,_index];
			};
			case 3:{
				{
					_index = _ctrl tvAdd [[_mainindex],_x select 0];
					_ctrl tvSetPicture [[_mainindex,_index],_x select 1];
					_ctrl tvsetValue [[_mainindex,_index],-1];
					_sp pushBack [_mainindex,_index];
				}forEach [
				[localize "STR_HALV_BACKPACKS","\a3\Ui_f\data\gui\Rsc\RscDisplayArsenal\backpack_ca.paa"],
				[localize "STR_HALV_GOGGLES","\a3\Ui_f\data\gui\Rsc\RscDisplayArsenal\goggles_ca.paa"],
				[localize "STR_HALV_HEADGEAR","\a3\Ui_f\data\gui\Rsc\RscDisplayArsenal\headgear_ca.paa"],
				[localize "STR_HALV_UNIFORMS","\a3\Ui_f\data\gui\Rsc\RscDisplayArsenal\uniform_ca.paa"],
				[localize "STR_HALV_VESTS","\a3\Ui_f\data\gui\Rsc\RscDisplayArsenal\vest_ca.paa"]
				];
			};
			case 4:{
				{
					_id = _x;
					_index = _ctrl tvAdd [[_mainindex],_id select 0];
					_ctrl tvSetPicture [[_mainindex,_index],_id select 1];
					_ctrl tvsetValue [[_mainindex,_index],-1];
					_sp pushBack [_mainindex,_index];
				}forEach [
				[localize "STR_HS_SMOKES","\a3\Ui_f\data\gui\cfg\Hints\smoke_granade_ca.paa"],
				[localize "STR_HS_FLARES","\a3\Ui_f\data\gui\cfg\Hints\flares_ca.paa"],
				[localize "STR_HS_GRENADES","\a3\Ui_f\data\gui\Rsc\RscDisplayArsenal\cargothrow_ca.paa"],
				[localize "STR_HS_MINES","\a3\Ui_f\data\gui\cfg\Hints\mines_ca.paa"],
				[localize "STR_HS_OTHER","\a3\Ui_f\data\gui\cfg\Hints\mines_ca.paa"]
				];
			};
			case 5:{
				{
					_id = _x;
					_index1 = _ctrl tvAdd [[_mainindex],_id select 0];
					_ctrl tvSetPicture [[_mainindex,_index1],_id select 1];
					_ctrl tvsetValue [[_mainindex,_index1],-1];
					switch(_index1)do{
						case 0:{
							{
								_index2 = _ctrl tvAdd [[_mainindex,_index1],_x select 0];
								_ctrl tvSetPicture [[_mainindex,_index1,_index2],_x select 1];
								_ctrl tvsetValue [[_mainindex,_index1,_index2],-1];
								_sp pushBack [_mainindex,_index1,_index2];
							}forEach [
							[localize "STR_HS_PLANES","\a3\Ui_f\data\gui\Rsc\RscDisplayGarage\plane_ca.paa"],
							[localize "STR_HS_HELICOPTERS","\a3\Ui_f\data\gui\Rsc\RscDisplayGarage\helicopter_ca.paa"],
							[localize "STR_HS_OTHER","\a3\Ui_f\data\gui\Rsc\RscDisplayGarage\texturesources_ca.paa"]
							];
						};
						case 1:{
							{
								_index2 = _ctrl tvAdd [[_mainindex,_index1],_x select 0];
								_ctrl tvSetPicture [[_mainindex,_index1,_index2],_x select 1];
								_ctrl tvsetValue [[_mainindex,_index1,_index2],-1];
								_sp pushBack [_mainindex,_index1,_index2];
							}forEach [
							[localize "STR_HS_CARS","\a3\Ui_f\data\IGUI\Cfg\MPTable\soft_ca.paa"],
							[localize "STR_HS_GOKARTS","A3\Soft_F_Kart\Kart_01\data\UI\Kart_01_base_CA.paa"],
							[localize "STR_HS_TRUCKS","\a3\Ui_f\data\map\VehicleIcons\picturepapercar_ca.paa"],
							[localize "STR_HS_APCS","\a3\Ui_f\data\map\VehicleIcons\iconapc_ca.paa"],
							[localize "STR_HS_TANKS","\a3\Ui_f\data\map\VehicleIcons\icontank_ca.paa"],
							[localize "STR_HS_OTHER","\a3\Ui_f\data\gui\Rsc\RscDisplayGarage\texturesources_ca.paa"]
							];
						};
					};

				}forEach [
				[localize "STR_HS_AIR","\a3\Ui_f\data\map\VehicleIcons\iconhelicopter_ca.paa"],
				[localize "STR_HS_LAND","\a3\Ui_f\data\map\VehicleIcons\iconcar_ca.paa"],
				[localize "STR_HS_SEA","\a3\Ui_f\data\map\VehicleIcons\iconship_ca.paa"],
				[localize "STR_HS_OTHER","\a3\Ui_f\data\gui\Rsc\RscDisplayArsenal\spacegarage_ca.paa"]
				];
			};
		};
	}forEach [
	[localize "STR_HS_WEAPONS","\a3\Ui_f\data\gui\Rsc\RscDisplayArsenal\primaryweapon_ca.paa"],
	[localize "STR_HS_MAGAZINEITEMS","\a3\Ui_f\data\gui\Rsc\RscDisplayArsenal\cargomag_ca.paa"],
	[localize "STR_HS_ATTACHMENTSTOOLS","\a3\Ui_f\data\gui\Rsc\RscDisplayArcadeMap\icon_debug_ca.paa"],
	[localize "STR_HS_EQUIPCLOTHING","\a3\Ui_f\data\gui\cfg\Hints\gear_ca.paa"],
	[localize "STR_HS_EXPLOSMOKEFLARE","\a3\Ui_f\data\map\VehicleIcons\iconcrategrenades_ca.paa"],
	[localize "STR_HS_VEHICLES","\a3\Ui_f\data\gui\Rsc\RscDisplayArsenal\spacegarage_ca.paa"]
	];
	_path = [];
	{
		switch (_x select 7) do{
			case "Weapon":{
//				diag_log format["%1",_x];
				switch(_x select 8)do{
					case "AssaultRifle":{
						if((_x select 0) in ["m249_EPOCH","m249Tan_EPOCH","MMG_02_camo_F","MMG_02_black_F","MMG_02_sand_F","MMG_01_tan_F","CUP_arifle_RPK74","CUP_arifle_MG36","CUP_arifle_MG36_camo","CUP_arifle_L86A2","CUP_glaunch_Mk13","CUP_glaunch_M79","CUP_glaunch_M32","CUP_sgun_M1014","CUP_sgun_Saiga12K","CUP_sgun_AA12","CUP_smg_MP5SD6","CUP_smg_MP5A5","CUP_smg_EVO","CUP_smg_bizon","m107_EPOCH","m107Tan_EPOCH","CUP_srifle_CZ550","CUP_srifle_CZ750","CUP_srifle_SVD_wdl_ghillie","CUP_srifle_SVD_des_ghillie_pso","CUP_srifle_ksvk","CUP_srifle_SVD","CUP_srifle_SVD_des","CUP_srifle_AWM_des","CUP_srifle_AWM_wdl","CUP_srifle_M110","CUP_srifle_DMR","CUP_srifle_M24_des","CUP_srifle_M24_wdl","CUP_srifle_M24_ghillie","CUP_srifle_M40A3","CUP_arifle_Mk20","CUP_srifle_VSSVintorez","hgun_PDW2000_F","ChainSaw","speargun_epoch","MMG_01_hex_F"])then{
							switch (true)do{
								case ((_x select 0) == "hgun_PDW2000_F"):{
									_index = _ctrl tvAdd [[0,1],_x select 4];
									_path = [0,1,_index];
								};
								case ((_x select 0) in ["m249_EPOCH","m249Tan_EPOCH","MMG_02_camo_F","MMG_02_black_F","MMG_02_sand_F","MMG_01_tan_F","MMG_01_hex_F","CUP_arifle_RPK74","CUP_arifle_MG36","CUP_arifle_MG36_camo","CUP_arifle_L86A2"]):{
									_index = _ctrl tvAdd [[0,2],_x select 4];
									_path = [0,2,_index];
								};
								case ((_x select 0) in ["m107_EPOCH","m107Tan_EPOCH","CUP_srifle_CZ550","CUP_srifle_CZ750","CUP_srifle_SVD_wdl_ghillie","CUP_srifle_SVD_des_ghillie_pso","CUP_srifle_ksvk","CUP_srifle_SVD","CUP_srifle_SVD_des","CUP_srifle_AWM_des","CUP_srifle_AWM_wdl","CUP_srifle_M110","CUP_srifle_DMR","CUP_srifle_M24_des","CUP_srifle_M24_wdl","CUP_srifle_M24_ghillie","CUP_srifle_M40A3","CUP_arifle_Mk20","CUP_srifle_VSSVintorez"]):{
									_index = _ctrl tvAdd [[0,3],_x select 4];
									_path = [0,3,_index];
								};
								case ((_x select 0) in ["CUP_smg_MP5SD6","CUP_smg_MP5A5","CUP_smg_EVO","CUP_smg_bizon"]):{
									_index = _ctrl tvAdd [[0,4],_x select 4];
									_path = [0,4,_index];
								};
								case ((_x select 0) in ["CUP_glaunch_Mk13","CUP_glaunch_M79","CUP_glaunch_M32"]):{
									_index = _ctrl tvAdd [[0,5],_x select 4];
									_path = [0,5,_index];
								};
								case ((_x select 0) in ["CUP_sgun_M1014","CUP_sgun_Saiga12K","CUP_sgun_AA12","speargun_epoch","ChainSaw"]):{
									_index = _ctrl tvAdd [[0,6],_x select 4];
									_path = [0,6,_index];
								};
							};
						}else{
							_index = _ctrl tvAdd [[0,0],_x select 4];
							_path = [0,0,_index];
						};
					};
					case "Handgun":{
						if((_x select 0) in ["Hatchet","CrudeHatchet"])then{
							_index = _ctrl tvAdd [[0,6],_x select 4];
							_path = [0,6,_index];
						}else{
							_index = _ctrl tvAdd [[0,1],_x select 4];
							_path = [0,1,_index];
						};
					};
					case "MachineGun":{
						if((_x select 0) in ["Hatchet","CrudeHatchet"])then{
							_index = _ctrl tvAdd [[0,6],_x select 4];
							_path = [0,6,_index];
						}else{
							_index = _ctrl tvAdd [[0,2],_x select 4];
							_path = [0,2,_index];
						};
					};
					case "SniperRifle":{
						_index = _ctrl tvAdd [[0,3],_x select 4];
						_path = [0,3,_index];
					};
					case "SubmachineGun":{
						_index = _ctrl tvAdd [[0,4],_x select 4];
						_path = [0,4,_index];
					};
					case "BombLauncher":{
						_index = _ctrl tvAdd [[0,5],_x select 4];
						_path = [0,5,_index];
					};
					case "Cannon":{
						_index = _ctrl tvAdd [[0,5],_x select 4];
						_path = [0,5,_index];
					};
					case "Mortar":{
						_index = _ctrl tvAdd [[0,5],_x select 4];
						_path = [0,5,_index];
					};
					case "RocketLauncher":{
						_index = _ctrl tvAdd [[0,5],_x select 4];
						_path = [0,5,_index];
					};
					case "MissileLauncher":{
						_index = _ctrl tvAdd [[0,5],_x select 4];
						_path = [0,5,_index];
					};
					case "Launcher":{
						_index = _ctrl tvAdd [[0,5],_x select 4];
						_path = [0,5,_index];
					};
					default{
						_index = _ctrl tvAdd [[0,6],_x select 4];
						_path = [0,6,_index];
					};
				};
			};
			case "Magazine":{
				if((_x select 0)in ["ItemLockbox","PaintCanClear","PaintCanBlk","PaintCanBlu","PaintCanBrn","PaintCanGrn","PaintCanOra","PaintCanPur","PaintCanRed",
				"PaintCanTeal","PaintCanYel","PartPlankPack","CinderBlocks","MortarBucket","ItemScraps","ItemCorrugated","ItemCorrugatedLg","KitStudWall","KitWoodFloor",
				"KitWoodStairs","KitWoodRamp","KitFirePlace","KitTiPi","KitShelf","KitWoodFoundation","KitFoundation","KitPlotPole","KitCinderWall","WoodLog_EPOCH"])then{
					_index = _ctrl tvAdd [[1,2],_x select 4];
					_path = [1,2,_index];
				}else{
					switch(_x select 8)do{
						case "Bullet":{
							_index = _ctrl tvAdd [[1,0],_x select 4];
							_path = [1,0,_index];
						};
						case "Missile":{
							_index = _ctrl tvAdd [[1,1],_x select 4];
							_path = [1,1,_index];
						};
						case "Rocket":{
							_index = _ctrl tvAdd [[1,1],_x select 4];
							_path = [1,1,_index];
						};
						case "ShotgunShell":{
							_index = _ctrl tvAdd [[1,0],_x select 4];
							_path = [1,0,_index];
						};
						case "Grenade":{
							_index = _ctrl tvAdd [[4,2],_x select 4];
							_path = [4,2,_index];
						};
						case "SmokeShell":{
							_index = _ctrl tvAdd [[4,0],_x select 4];
							_path = [4,0,_index];
						};
						case "Shell":{
							_index = _ctrl tvAdd [[4,2],_x select 4];
							_path = [4,2,_index];
						};
						case "Flare":{
							_index = _ctrl tvAdd [[4,1],_x select 4];
							_path = [4,1,_index];
						};
						case "Artillery":{
							_index = _ctrl tvAdd [[4,4],_x select 4];
							_path = [4,4,_index];
						};
						default{
							if((_x select 0) in [
							"FoodBioMeat","ItemTuna","ItemSodaBurst","CookedChicken_EPOCH","CookedGoat_EPOCH","CookedRabbit_EPOCH","CookedSheep_EPOCH",
							"SnakeMeat_EPOCH","honey_epoch","meatballs_epoch","ItemSodaMocha","ItemSodaOrangeSherbet","ItemSodaPurple","ItemTrout",
							"ItemSodaRbull","sardines_epoch","scam_epoch","ItemSeaBass","FoodSnooter","sweetcorn_epoch","FoodWalkNSons","WhiskeyNoodle",
							"FoodMeeps"
							])then{
								_index = _ctrl tvAdd [[1,3],_x select 4];
								_path = [1,3,_index];
							}else{
								_index = _ctrl tvAdd [[1,4],_x select 4];
								_path = [1,4,_index];
							};
						};
					};
				};
			};
			case "Item":{
				switch(_x select 8)do{
					case "AccessoryBipod":{
						_index = _ctrl tvAdd [[2,0,0],_x select 4];
						_path = [2,0,0,_index];
					};
					case "AccessoryMuzzle":{
						if((_x select 0) in ["Heal_EPOCH","Defib_EPOCH","Repair_EPOCH"])then{
							_index = _ctrl tvAdd [[2,1],_x select 4];
							_path = [2,1,_index];
						}else{
							_index = _ctrl tvAdd [[2,0,1],_x select 4];
							_path = [2,0,1,_index];
						};
					};
					case "AccessorySights":{
						_index = _ctrl tvAdd [[2,0,2],_x select 4];
						_path = [2,0,2,_index];
					};
					case "AccessoryPointer":{
						_index = _ctrl tvAdd [[2,0,3],_x select 4];
						_path = [2,0,3,_index];
					};
					default{
						_index = _ctrl tvAdd [[2,1],_x select 4];
						_path = [2,1,_index];
					};
				};
			};
			case "Equipment":{
				switch(_x select 8)do{
					case "Backpack":{
						_index = _ctrl tvAdd [[3,0],_x select 4];
						_path = [3,0,_index];
					};
					case "Glasses":{
						_index = _ctrl tvAdd [[3,1],_x select 4];
						_path = [3,1,_index];
					};
					case "Headgear":{
						_index = _ctrl tvAdd [[3,2],_x select 4];
						_path = [3,2,_index];
					};
					case "Uniform":{
						_index = _ctrl tvAdd [[3,3],_x select 4];
						_path = [3,3,_index];
					};
					case "Vest":{
						_index = _ctrl tvAdd [[3,4],_x select 4];
						_path = [3,4,_index];
					};
				};
			};
			case "Mine":{
				_index = _ctrl tvAdd [[4,3],_x select 4];
				_path = [4,3,_index];
			};
			case "":{
				switch(true)do{
					case ((_x select 0) isKindOf "air"):{
						switch(true)do{
							case ((_x select 0) isKindOf "plane"):{
								_index = _ctrl tvAdd [[5,0,0],_x select 4];
								_path = [5,0,0,_index];
							};
							case ((_x select 0) isKindOf "Helicopter_Base_F"):{
								_index = _ctrl tvAdd [[5,0,1],_x select 4];
								_path = [5,0,1,_index];
							};
							default{
								_index = _ctrl tvAdd [[5,0,2],_x select 4];
								_path = [5,0,2,_index];
							};
						};
					};
					case ((_x select 0) isKindOf "landvehicle"):{
						switch(true)do{
							case (((_x select 0) isKindOf "Car_F") && !((_x select 0) isKindOf "Truck_F")  && !((_x select 0) isKindOf "Wheeled_APC_F") && !((_x select 0) isKindOf "Tank_F") && !((_x select 0) isKindOf "Kart_01_Base_F")):{
								_index = _ctrl tvAdd [[5,1,0],_x select 4];
								_path = [5,1,0,_index];
							};
							case ((_x select 0) isKindOf "Kart_01_Base_F"):{
								_index = _ctrl tvAdd [[5,1,1],_x select 4];
								_path = [5,1,1,_index];
							};
							case ((_x select 0) isKindOf "Truck_F"):{
								_index = _ctrl tvAdd [[5,1,2],_x select 4];
								_path = [5,1,2,_index];
							};
							case ((_x select 0) isKindOf "Wheeled_APC_F"):{
								_index = _ctrl tvAdd [[5,1,3],_x select 4];
								_path = [5,1,3,_index];
							};
							case ((_x select 0) isKindOf "Tank_F"):{
								_index = _ctrl tvAdd [[5,1,4],_x select 4];
								_path = [5,1,4,_index];
							};
							case ((_x select 0) isKindOf "Pod_Heli_Transport_04_base_F"):{
								_index = _ctrl tvAdd [[5,0,2],_x select 4];
								_path = [5,0,2,_index];
							};
							default{
								_index = _ctrl tvAdd [[5,1,5],_x select 4];
								_path = [5,1,5,_index];
							};
						};

					};
					case ((_x select 0) isKindOf "ship"):{
						_index = _ctrl tvAdd [[5,2],_x select 4];
						_path = [5,2,_index];
					};
					default {
						_index = _ctrl tvAdd [[5,3],_x select 4];
						_path = [5,3,_index];
					};
				};
			};
			default{diag_log str(_x);};
		};
		_ctrl tvSetPicture [_path,_x select 6];
		_price = if(HS_SWITCH)then{format[localize "STR_HS_PRICE",_x select 1]}else{format[localize "STR_HS_PRICETAX",_x select 1,(_x select 2)*100,"%",EPOCH_taxRate*100]};
		_ctrl tvSetToolTip [_path,_price];
		_ctrl tvSetValue [_path,_forEachIndex];
	}forEach _currentarray;
	{_ctrl tvSort [_x,false];}forEach _sp;
	_ctrl tvSetCurSel [0];
	systemChat localize "STR_HS_DOUBLECLICKTOADD";
};

HS_additemtolb = {
	disableSerialization;
	_ctrl = _this select 0;
	_tree = _this select 1;
	_value = _ctrl tvValue _tree;
	if(_value < 0)exitWith{};
	if(HS_SWITCH)then{_ctrl tvDelete _tree;};
	if((_tree select 0) isEqualTo 5 && !HS_SWITCH)then{_ctrl tvDelete [5];};
	_ctrl = (findDisplay 9999) displayCtrl 9998;
	_currentarray = if(HS_SWITCH)then{HS_PLAYER_itemlist}else{HS_trader_itemlist};
	_arr = _currentarray select _value;
	_lb = _ctrl lbAdd (_arr select 4);
	_ctrl lbSetPicture [_lb,_arr select 6];
	_ctrl lbSetPictureColor [_lb,[1, 1, 1, 1]];
	_ctrl lbSetPictureColorSelected [_lb,[1, 1, 1, 1]];
	_price = if(HS_SWITCH)then{format[localize "STR_HS_PRICE",_arr select 1]}else{format[localize "STR_HS_PRICETAX",_arr select 1,(_arr select 2)*100,"%",EPOCH_taxRate*100]};
	_ctrl lbSetToolTip [_lb,_price];
	_ctrl lbSetValue [_lb,_value];
	lbSort _ctrl;
	HS_BUYSELLARRAY pushBack _value;
	_price = 0;
	{
		_cost = ((_currentarray select _x) select 1);
		_calced = _cost;
		if(!HS_SWITCH)then{
			_itemWorth = ((_currentarray select _x) select 1);
			_itemTax = ((_currentarray select _x) select 2);
			_tax = _itemWorth * (EPOCH_taxRate + _itemTax);
			_calced = ceil(_itemWorth + _tax);
		};
		_price = _price + _calced;
	}forEach HS_BUYSELLARRAY;
	_ctrl = (findDisplay 9999) displayCtrl 9996;
	_ctrl ctrlSetText ""+(str _price)+" Crypto";
//	systemChat str(HS_BUYSELLARRAY);
};

HS_deleteitemfromlb = {
	disableSerialization;
	_ctrl = _this select 0;
	_lb = _this select 1;
	_value = _ctrl lbValue _lb;
	_ctrl lbDelete _lb;
	_selected = HS_BUYSELLARRAY find _value;
	_deleted = HS_BUYSELLARRAY deleteAt _selected;
	_currentarray = if(HS_SWITCH)then{HS_PLAYER_itemlist}else{HS_trader_itemlist};
	_price = 0;
	{
		_cost = ((_currentarray select _x) select 1);
		_calced = _cost;
		if(!HS_SWITCH)then{
			_itemWorth = ((_currentarray select _x) select 1);
			_itemTax = ((_currentarray select _x) select 2);
			_tax = _itemWorth * (EPOCH_taxRate + _itemTax);
			_calced = ceil(_itemWorth + _tax);
		};
		_price = _price + _calced;
	}forEach HS_BUYSELLARRAY;
	_ctrl = (findDisplay 9999) displayCtrl 9996;
	_ctrl ctrlSetText ""+(str _price)+" Crypto";
	if(!HS_SWITCH && ((HS_trader_itemlist select _deleted)select 3 == "cfgvehicles" && (HS_trader_itemlist select _deleted)select 8 != "Backpack"))then{call HS_trader_menu;};
//	systemChat str(HS_BUYSELLARRAY);
};

//[classname,price,tax,config,txt,libtxt,pic,bis1,bis2(,vehicle)]
Halv_onlbtreeselected = {
	private "_value";
	_ctrl = _this select 0;
	_current = _this select 1;
	_value = if((typeName _current) == "ARRAY")then{_ctrl tvValue _current}else{_ctrl lbValue _current};
	_exit = if((typeName _current) == "ARRAY")then{if(count _current < 2)then{true}else{false};}else{false};
	if(_exit)exitWith{};
	if(_value < 0)exitWith{};
	_currentarray = if(HS_SWITCH)then{HS_PLAYER_itemlist}else{HS_trader_itemlist};
	_arr = _currentarray select _value;
	_pic = _arr select 6;
	_ammotxt = "";
	if((_arr select 3) == "cfgweapons")then{
		_ammo = [] + getArray (configFile >> "cfgWeapons" >> (_arr select 0) >> "magazines");
		if(count _ammo > 0)then{
			{
				_txt = (gettext (configFile >> "cfgmagazines" >> _x >> "displayName"));
				_ammotxt = _ammotxt + format["<br/><t size='0.7'>%1</t>",_txt];
			}forEach _ammo;
		};
	};
	_send = if((toLower _pic) in ["","pictureheal","picturepapercar","picturething","picturestaticobject"]) then {
		format["<t align='center'size='0.5'>%1</t><br/><t align='center'size='0.4'>%2</t>",_arr select 4,_arr select 5]; 
	}else{
		format["<img size='2.4' image='%1'/><br/><t align='center'size='0.5'>%2</t><br/><t align='center'size='0.4'>%3</t>",_pic,_arr select 4,_arr select 5]; 
	};
	if (_ammotxt != "")then{
		_send = _send + _ammotxt;
	};
	[parseText _send,0,0 * safezoneH + safezoneY,15,0,0,8407] spawn bis_fnc_dynamicText;
};

HS_buyorsell = {
	disableSerialization;
	if((_this select 2) isEqualTo 0)then{HS_SWITCH = false;}else{HS_SWITCH = true;};
	_ctrl = (findDisplay 9999) displayCtrl 9996;
	_ctrl ctrlSetText "0 Crypto";
	_lb = (findDisplay 9999) displayCtrl 9998;
	lbClear _lb;
};

HS_confirmtrade = {
	#include "settings.sqf";
	if !(isNil "HS_istrading")exitWith{
		titleText ["Already trading ...","PLAIN DOWN"];
	};
	HS_istrading = true;
	closeDialog 0;
	_spawnveh = -1;
	if (HS_SWITCH)then{
		_list = [];
		{_list pushBack (HS_PLAYER_itemlist select _x);}forEach HS_BUYSELLARRAY;
		_vehicles = [];
		_return = 0;
		_removeafter = [];
		{
			_isOK = false;
			diag_log format["CHECK: %1",_x];
			if((_x select 3) == "cfgvehicles" && ((_x select 8) != "Backpack"))then{
				_vehicles pushBack _x;
			}else{
				switch(true)do{
					case ((_x select 0) in backpackItems player):{
						player removeItemFromBackpack (_x select 0);
						_isOK = true;
					};
					case ((_x select 0) in vestItems player):{
						player removeItemFromVest (_x select 0);
						_isOK = true;
					};
					case ((_x select 0) in uniformItems player):{
						player removeItemFromUniform (_x select 0);
						_isOK = true;
					};
					case ((_x select 0) in assignedItems player):{
						if((_x select 0) in ["Binocular","Rangefinder","Laserdesignator","Laserdesignator_02","Laserdesignator_03"])then{
							player removeWeapon (_x select 0);
							_isOK = true;
						}else{
							player unlinkItem (_x select 0);
							_isOK = true;
						};
					};
					case ((_x select 0) in handgunItems player):{
						player removehandgunItem (_x select 0);
						_isOK = true;
					};
					case ((_x select 0) in secondaryWeaponItems player):{
						player removeSecondaryWeaponItem (_x select 0);
						_isOK = true;
					};
					case ((_x select 0) in primaryWeaponItems player):{
						player removePrimaryWeaponItem (_x select 0);
						_isOK = true;
					};
					case ((_x select 0) == primaryWeapon player || (_x select 0) == handgunWeapon player || (_x select 0) == secondaryWeapon player):{
						player removeWeapon (_x select 0);
						_isOK = true;
					};
					case ((_x select 0) == uniform player):{
						if(count (uniformItems player) > 0)then{
							systemChat localize "STR_HS_UNIFORMNOTSOLD";
							_removeafter pushBack [0,_forEachIndex];
						}else{
							removeuniform player;
							_isOK = true;
						};
					};
					case ((_x select 0) == vest player):{
						if(count (vestItems player) > 0)then{
							systemChat localize "STR_HS_VESTNOTSOLD";
							_removeafter pushBack [1,_forEachIndex];
						}else{
							removevest player;
							_isOK = true;
						};
					};
					case ((_x select 0) == backpack player):{
						if(count (backpackItems player) > 0)then{
							systemChat localize "STR_HS_BACKPACKNOTSOLD";
							_removeafter pushBack [2,_forEachIndex];
						}else{
							removeBackpack player;
							_isOK = true;
						};
					};
					case ((_x select 0) == headgear player):{
						removeheadgear player;
						_isOK = true;
					};
					case ((_x select 0) == goggles player):{
						removeGoggles player;
						_isOK = true;
					};
					default{diag_log str["HSBlackmarket","WTF happend?",_isOK,_return,_vehicles,_list];};
				};
			};
			if(_isOK)then{
				_return = _return + (_x select 1);
				diag_log format["SOLD: (%2) %1",_x,(_x select 1)];
			};
		}forEach _list;
		if(count _removeafter > 0)then{
			{
				_type = _x select 1;
				_itemcount = switch(_type)do{
					case 0:{count (uniformItems player);};
					case 1:{count (vestItems player);};
					case 2:{count (backpackItems player);};
				};
				if(_itemcount > 0)then{
					systemChat format[localize"STR_HS_FAILEDTOSELL",_x select 8];
				}else{
					_index = _x select 0;
					switch(_type)do{
						case 0:{removeuniform player;};
						case 1:{removevest player;};
						case 2:{removeBackpack player;};
					};
					_return = _return + (_x select 1);
					diag_log format["SOLD: (%2) %1",(_list select _index),(_x select 1)];
				};
			}forEach _removeafter;
		};
		if(count _vehicles > 0)then{
							//[items,player,isselling]
			HSPV_traderrequest = [_vehicles,player,1];
			publicVariableServer "HSPV_traderrequest";
		};
		HALV_takegive = [player,_return];
		publicVariableServer "HALV_takegive";
	}else{
		_price = 0;
		
		{
			_itemWorth = ((HS_trader_itemlist select _x) select 1);
			_itemTax = ((HS_trader_itemlist select _x) select 2);
			_tax = _itemWorth * (EPOCH_taxRate + _itemTax);
			_calced = ceil(_itemWorth + _tax);
			_price = _price + _calced;
			diag_log format["%1",_x];
		}forEach HS_BUYSELLARRAY;
		if(EPOCH_playerCrypto >= _price && !(_price isEqualTo 0))then{
			_pay = 0;
			_isNOTOK = [];
			{
//				diag_log format["CHECK: %1",(HS_trader_itemlist select _x)];
				_isOK = false;
				if((HS_trader_itemlist select _x) select 3 == "cfgvehicles" && (HS_trader_itemlist select _x) select 8 != "Backpack")then{
					diag_log format["%1",(HS_trader_itemlist select _x) select 4];
					_spawnveh = 1;
				}else{
					switch((HS_trader_itemlist select _x) select 7)do{
						case "Weapon":{
//							diag_log format["Weapon: %1",(HS_trader_itemlist select _x) select 4];
							switch((HS_trader_itemlist select _x) select 8)do{
								case "AssaultRifle":{
									if(primaryWeapon player != "")then{
										systemChat localize "STR_HS_ALREADYHAVEWEAPON";
										if (player canAdd ((HS_trader_itemlist select _x)select 0)) then {
											player addItem ((HS_trader_itemlist select _x)select 0);
											_isOK = true;
										}else{
											_isNOTOK pushBack (HS_trader_itemlist select _x);
										};
									}else{
										player addWeapon ((HS_trader_itemlist select _x)select 0);
										_isOK = true;
									};
								};
								case "Handgun":{
									if(handgunWeapon player != "")then{
										systemChat localize "STR_HS_ALREADYHAVEWEAPON";
										if (player canAdd ((HS_trader_itemlist select _x)select 0)) then {
											player addItem ((HS_trader_itemlist select _x)select 0);
											_isOK = true;
										}else{
											_isNOTOK pushBack (HS_trader_itemlist select _x);
										};
									}else{
										player addWeapon ((HS_trader_itemlist select _x)select 0);
										_isOK = true;
									};
								};
								case "MachineGun":{
									if(primaryWeapon player != "")then{
										systemChat localize "STR_HS_ALREADYHAVEWEAPON";
										if (player canAdd ((HS_trader_itemlist select _x)select 0)) then {
											player addItem ((HS_trader_itemlist select _x)select 0);
											_isOK = true;
										}else{
											_isNOTOK pushBack (HS_trader_itemlist select _x);
										};
									}else{
										player addWeapon ((HS_trader_itemlist select _x)select 0);
										_isOK = true;
									};
								};
								case "SniperRifle":{
									if (primaryWeapon player != "")then{
										systemChat localize "STR_HS_ALREADYHAVEWEAPON";
										if (player canAdd ((HS_trader_itemlist select _x)select 0)) then {
											player addItem ((HS_trader_itemlist select _x)select 0);
											_isOK = true;
										}else{
											_isNOTOK pushBack (HS_trader_itemlist select _x);
										};
									}else{
										player addWeapon ((HS_trader_itemlist select _x)select 0);
										_isOK = true;
									};
								};
								case "SubmachineGun":{
									if(primaryWeapon player != "")then{
										systemChat localize "STR_HS_ALREADYHAVEWEAPON";
										if (player canAdd ((HS_trader_itemlist select _x)select 0)) then {
											player addItem ((HS_trader_itemlist select _x)select 0);
											_isOK = true;
										}else{
											_isNOTOK pushBack (HS_trader_itemlist select _x);
										};
									}else{
										player addWeapon ((HS_trader_itemlist select _x)select 0);
										_isOK = true;
									};
								};
								default{
									if (player canAdd ((HS_trader_itemlist select _x)select 0)) then {
										player addItem ((HS_trader_itemlist select _x)select 0);
										_isOK = true;
									}else{
										_isNOTOK pushBack (HS_trader_itemlist select _x);
									};
								};
							};
						};
						case "Magazine":{
//							diag_log format["Magazine: %1",(HS_trader_itemlist select _x) select 4];
							if (player canAdd ((HS_trader_itemlist select _x)select 0)) then {
								player addMagazine ((HS_trader_itemlist select _x)select 0);
								_isOK = true;
							}else{
								_isNOTOK pushBack (HS_trader_itemlist select _x);
							};
						};
						case "Item":{
//							diag_log format["Item: %1",(HS_trader_itemlist select _x) select 4];
							switch ((HS_trader_itemlist select _x) select 8)do{
								case "Radio":{
									_radios = ["EpochRadio0","EpochRadio1","EpochRadio2","EpochRadio3","EpochRadio4","EpochRadio5","EpochRadio6","EpochRadio7","EpochRadio8","EpochRadio9"];
									if (!(((HS_trader_itemlist select _x) select 0) in (weapons player+items player+assignedItems player)) && {_x in _radios}count (weapons player+assignedItems player) < 1)then{
										player addWeapon ((HS_trader_itemlist select _x) select 0);
										_isOK = true;
									}else{
										if (player canAdd ((HS_trader_itemlist select _x)select 0)) then {
											player addItem ((HS_trader_itemlist select _x)select 0);
											_isOK = true;
										}else{
											_isNOTOK pushBack (HS_trader_itemlist select _x);
										};
									};
								};
								default{
									if (player canAdd ((HS_trader_itemlist select _x)select 0)) then {
										player addItem ((HS_trader_itemlist select _x)select 0);
										_isOK = true;
									}else{
										_isNOTOK pushBack (HS_trader_itemlist select _x);
									};
								};
							};
						};
						case "Equipment":{
//							diag_log format["Equipment: %1",(HS_trader_itemlist select _x) select 4];
							switch((HS_trader_itemlist select _x) select 8)do{
								case "Backpack":{
									if(backpack player != "")then{
										systemChat localize "STR_HS_ALREADYWEARINGBAG";
										if (player canAdd ((HS_trader_itemlist select _x)select 0)) then {
											player addItem ((HS_trader_itemlist select _x)select 0);
											_isOK = true;
										}else{
											_isNOTOK pushBack (HS_trader_itemlist select _x);
										};
									}else{
										player addBackpack ((HS_trader_itemlist select _x) select 0);
										_isOK = true;
									};
								};
								case "Glasses":{
									if(goggles player != "")then{
										systemChat localize "STR_HS_ALREADYWEARINGGLASSES";
										if (player canAdd ((HS_trader_itemlist select _x)select 0)) then {
											player addItem ((HS_trader_itemlist select _x)select 0);
											_isOK = true;
										}else{
											_isNOTOK pushBack (HS_trader_itemlist select _x);
										};
									}else{
										player addGoggles ((HS_trader_itemlist select _x) select 0);
										_isOK = true;
									};
								};
								case "Headgear":{
									if(headgear player != "")then{
										systemChat localize "STR_HS_ALREADYWEARINGHEADGEAR";
										if (player canAdd ((HS_trader_itemlist select _x)select 0)) then {
											player addItem ((HS_trader_itemlist select _x)select 0);
											_isOK = true;
										}else{
											_isNOTOK pushBack (HS_trader_itemlist select _x);
										};
									}else{
										player addHeadgear ((HS_trader_itemlist select _x) select 0);
										_isOK = true;
									};
								};
								case "Uniform":{
									if(uniform player != "")then{
										systemChat localize "STR_HS_ALREADYWEARINGUNIFORM";
//										diag_log str['Uniform',((HS_trader_itemlist select _x)select 0)];
										if (player canAdd ((HS_trader_itemlist select _x)select 0)) then {
											player addItem ((HS_trader_itemlist select _x)select 0);
											_isOK = true;
										}else{
											_isNOTOK pushBack (HS_trader_itemlist select _x);
										};
									}else{
										player forceadduniform ((HS_trader_itemlist select _x) select 0);
										_isOK = true;
									};
								};
								case "Vest":{
									if(vest player != "")then{
										systemChat localize "STR_HS_ALREADYWEARINGVEST";
//										diag_log format["%1",(HS_trader_itemlist select _x)select 0];
										if (player canAdd ((HS_trader_itemlist select _x)select 0)) then {
											player addItem ((HS_trader_itemlist select _x)select 0);
											_isOK = true;
										}else{
											_isNOTOK pushBack (HS_trader_itemlist select _x);
										};
									}else{
										player addvest ((HS_trader_itemlist select _x) select 0);
										_isOK = true;
									};
								};
							};
						};
						default{
//							diag_log format["Default: %1",(HS_trader_itemlist select _x) select 4];
							if (player canAdd ((HS_trader_itemlist select _x)select 0)) then {
								player addItem ((HS_trader_itemlist select _x)select 0);
								_isOK = true;
							}else{
								_isNOTOK pushBack (HS_trader_itemlist select _x);
							};
						};
					};
				};
				if(_isOK)then{
					_itemWorth = ((HS_trader_itemlist select _x) select 1);
					_itemTax = ((HS_trader_itemlist select _x) select 2);
					_tax = _itemWorth * (EPOCH_taxRate + _itemTax);
					_cost = ceil(_itemWorth + _tax);
					_pay = _pay + _cost;
					diag_log format["BOUGHT: (%2) %1",(HS_trader_itemlist select _x),_pay];
				};
			}forEach HS_BUYSELLARRAY;
			if(count _isNOTOK > 0)then{
				_pos = getPos player;
				_pos set [2,0];
				_WH = createVehicle["groundWeaponHolder",_pos,[],0,"CAN_COLLIDE"];
				_cluttercutter = createVehicle ["Land_ClutterCutter_medium_F", _pos, [], 0, "CAN_COLLIDE"];
				[_WH,_cluttercutter]spawn{
					_WH = _this select 0;
					_WH2 = _this select 1;
					waitUntil{sleep 1;(_WH distance player > 100 || isNull player || !alive player)};
					clearWeaponCargoGlobal _WH;
					clearMagazineCargoGlobal _WH;
					clearBackpackCargoGlobal  _WH;
					clearItemCargoGlobal _WH;
					deleteVehicle _WH;
					deleteVehicle _WH2;
				};
				_error = [];
				{
					_itemWorth = _x select 1;
					_itemTax = _x select 2;
					_tax = _itemWorth * (EPOCH_taxRate + _itemTax);
					_cost = ceil(_itemWorth + _tax);
					_pay = _pay + _cost;
					switch(_x select 3)do{
						case "cfgweapons":{
							_kindOf = [(configFile >> "CfgWeapons" >> (_x select 0)),true] call BIS_fnc_returnParents;
							if ("ItemCore" in _kindOf)then{
								_WH addItemCargo [_x select 0,1];
							}else{
								_WH addWeaponCargo [_x select 0,1];
							};
						};
						case "cfgmagazines":{
							_WH addMagazineCargo [_x select 0,1];
						};
						case "cfgvehicles":{
							_WH addBackpackCargo [_x select 0,1];
						};
						default {
							_error pushBack (_x select 0);
						};
					};
				}forEach _isNOTOK;
				titleText [localize "STR_HS_ONGROUNDNEARYOU","PLAIN DOWN"];
				if(count _error > 0)then{
					systemChat str['TraderError:',_error];
					diag_log str['TraderError:',_error];
				};
			};
			HALV_takegive = [player,(_pay*-1)];
			publicVariableServer "HALV_takegive";
		}else{
			if(_price isEqualTo 0)exitWith{};
			titleText [localize "STR_HS_NOTENOGHCRYPTO","PLAIN DOWN"];
		};
	};
	player playMove "AinvPknlMstpSlayWrflDnon_medic";
	[]spawn{
		sleep 6.2;
		player switchMove "";
	};
	if (_spawnveh > 0)then{
		switch (_vehiclespawnmode)do{
			case 0:{
				createDialog "HS_trader_dialog2";
			};
			case 1:{
				call HS_buyvehiclesaved;
			};
			case 2:{
				call HS_buyvehicletemp;
			};
		};
	};
	HS_istrading = nil;
};

HS_checkavailability = {
	if(EPOCH_VehicleSlotCount <= 0)exitWith{
		titleText ["Can't buy a saved vehicle, too many on the map!","PLAIN DOWN"];
	};
	titleText ["Vehicle slots available, you can buy one that saves!","PLAIN DOWN"];
};

HS_buyvehiclesaved = {
	closeDialog 0;
	{
		if((HS_trader_itemlist select _x) select 3 == "cfgvehicles" && (HS_trader_itemlist select _x) select 8 != "Backpack")exitWith{
			HSPV_traderrequest = [(HS_trader_itemlist select _x),player,2];
			publicVariableServer "HSPV_traderrequest";
			HS_BUYSELLARRAY = [];
		};
	}forEach HS_BUYSELLARRAY;
};

HS_buyvehicletemp = {
	closeDialog 0;
	{
		if((HS_trader_itemlist select _x) select 3 == "cfgvehicles" && (HS_trader_itemlist select _x) select 8 != "Backpack")exitWith{
			HSPV_traderrequest = [(HS_trader_itemlist select _x),player,3];
			publicVariableServer "HSPV_traderrequest";
			HS_BUYSELLARRAY = [];
		};
	}forEach HS_BUYSELLARRAY;
};