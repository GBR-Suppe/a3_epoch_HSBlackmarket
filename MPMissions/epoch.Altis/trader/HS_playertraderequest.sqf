/*
	a3 epoch trader
	HS_playertraderequest.sqf
	by Halv & Suppe
	
	Copyright (C) 2015  Halvhjearne & Suppe > README.md
*/

_arr = _this select 0;
_player = _this select 1;
_type = _this select 2;


_message = "";

switch(_type)do{
	case 1:{
		//[classname,price,tax,config,txt,libtxt,pic,bis1,bis2(,vehicle)]
		_return = 0;
		{
			_obj = _x select 9;
			
			if((owner _obj) isEqualTo (owner _player))then{
		//damage price reductions, the price is divded by this number
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
				_vehSlot=_obj getVariable["VEHICLE_SLOT","ABORT"];
				_isrental = _obj getVariable ["HSHALFPRICE",0];
				if(!(_vehSlot isEqualTo "ABORT") && !(_isrental in [1,2]))then{
					_message = _message + format["%1 is OK to sell, dam: %2 pricemod: %3 || ",_x select 4,damage _obj,_damagepricereduction];
					removeFromRemainsCollector[_obj];
					deleteVehicle _obj;
					_vehHiveKey=format["%1:%2",(call EPOCH_fn_InstanceID),_vehSlot];
					_VAL=[];
					["Vehicle",_vehHiveKey,_VAL]call EPOCH_fnc_server_hiveSET;
					EPOCH_VehicleSlots pushBack _vehSlot;
					EPOCH_VehicleSlotCount=count EPOCH_VehicleSlots;
					publicVariable "EPOCH_VehicleSlotCount";
					_cost = ((_x select 1)/_damagepricereduction);
					_return = _return + _cost;
				}else{
					if(_isrental > 0)then{
						_message = _message + format[" || %1 'Rental' is OK to sell, dam: %2 pricemod: %3",_x select 4,damage _obj,_damagepricereduction];
						removeFromRemainsCollector[_obj];
						_obj setVariable["VEHICLE_SLOT","ABORT",true];
						_obj setVariable["HSHALFPRICE",0,true];
						_obj call HALV_PurgeObject;
						_cost = ((_x select 1)/_damagepricereduction);
						_return = _return + _cost;
					}else{
						_message = _message + format[" || - ERROR Attempt to sell %1 twice -",_x select 4,_player];
					};
				};
			}else{
				_message = _message + format[" || %1 Not yours (get in as driver to sell)",_x select 4];
			};
//			diag_log format["[HSBlackmarket] %1 | %2",_player,_x];
		}forEach _arr;
		if(_return > 0)then{
			[_player,round _return]call HALV_server_takegive_crypto;
		};
		_message = format["Return: %3 Crypto (%1) %2",_return,_message,_player];
		diag_log format["[HSBlackmarket] %1 selling %2",_player,_arr];
	};
	case 2:{
		if(EPOCH_VehicleSlotCount <= 0)exitWith{
			_message = format["Could not buy a %1, too many vehicles on the map!",_arr select 4];
		};
		_spot = nearestObjects [_player, ["Land_HelipadCivil_F","Land_HelipadCircle_F","Land_HelipadEmpty_F","Land_HelipadSquare_F","Land_JumpTarget_F"],100];
		_nospace = false;
		if(count _spot < 1)then{
			_canbewwater = if((_arr select 0) isKindOf "Ship")then{1}else{0};
			_spot = [getPos _player,5,125,0,_canbewwater,2000,0] call BIS_fnc_findSafePos;
			if(_spot distance _player > 125)exitWith{_nospace = true;};
		}else{
			_spot = getPosATL (_spot select 0);
		};
		if(_nospace)exitWith{_message = format["Could not buy a %1, not enough space nearby!",_arr select 4];};
		_slot=EPOCH_VehicleSlots select 0;
		EPOCH_VehicleSlots = EPOCH_VehicleSlots - [_slot];
		EPOCH_VehicleSlotCount = count EPOCH_VehicleSlots;
		publicVariable "EPOCH_VehicleSlotCount";
		_veh = createVehicle[(_arr select 0),_spot,[],0,"NONE"];
		_veh call EPOCH_server_setVToken;
		addToRemainsCollector[_veh];
		_veh disableTIEquipment true;
		clearWeaponCargoGlobal _veh;
		clearMagazineCargoGlobal _veh;
		clearBackpackCargoGlobal _veh;
		clearItemCargoGlobal _veh;
		_veh lock true;
		_lockOwner=getPlayerUID _player;
		_plyrGroup=_player getVariable["GROUP",""];
		if !(_plyrGroup isEqualTo "")then{
			_lockOwner=_plyrGroup;
		};
		_vehLockHiveKey=format["%1:%2",(call EPOCH_fn_InstanceID),_slot];
		["VehicleLock",_vehLockHiveKey,EPOCH_vehicleLockTime,[_lockOwner]]call EPOCH_fnc_server_hiveSETEX;
		_colorsConfig=configFile >> "CfgVehicles" >> (_arr select 0) >> "availableColors";
		if(isArray(_colorsConfig))then{
			_textureSelectionIndex=configFile >> "CfgVehicles" >> (_arr select 0) >> "textureSelectionIndex";
			_selections=if(isArray(_textureSelectionIndex))then{getArray(_textureSelectionIndex)}else{[0]};
			_colors=getArray(_colorsConfig);
			_textures=_colors select 0;
			_color=floor(random(count _textures));
			_count=(count _colors)-1;
			{
				if(_count >=_forEachIndex)then{
					_textures=_colors select _forEachIndex;
				};
				_veh setObjectTextureGlobal[_x,(_textures select _color)];
			}forEach _selections;
			_veh setVariable["VEHICLE_TEXTURE",_color];
		};
		_veh setVariable["VEHICLE_SLOT",_slot,true];
		_veh call EPOCH_server_save_vehicle;
		_veh call EPOCH_server_vehicleInit;
		_veh call HS_weaponsrestriction;

		_itemWorth = (_arr select 1);
		_itemTax = (_arr select 2);
		_tax = _itemWorth * (EPOCH_taxRate + _itemTax);
		_calced = ceil(_itemWorth + _tax);

		[_player,_calced*-1]call HALV_server_takegive_crypto;

		_message = format["You Bought a %1",_arr select 4];
		diag_log format["[HSBlackmarket] %1 | %2",_player,_arr];
	};
	case 3:{
		_spot = nearestObjects [_player, ["Land_HelipadCivil_F","Land_HelipadCircle_F","Land_HelipadEmpty_F","Land_HelipadSquare_F","Land_JumpTarget_F"],100];
		_nospace = false;
		if(count _spot < 1)then{
			_canbewwater = if((_arr select 0) isKindOf "Ship")then{1}else{0};
			_spot = [getPos _player,5,125,0,_canbewwater,2000,0] call BIS_fnc_findSafePos;
			if(_spot distance _player > 125)exitWith{_nospace = true;};
		}else{
			_spot = getPosATL (_spot select 0);
		};
		if(_nospace)exitWith{_message = format["Could not buy a %1, not enough space nearby!",_arr select 4];};
		_veh = createVehicle[(_arr select 0),_spot,[],0,"NONE"];
		_veh call EPOCH_server_setVToken;
		addToRemainsCollector[_veh];
		_veh disableTIEquipment true;
		clearWeaponCargoGlobal _veh;
		clearMagazineCargoGlobal _veh;
		clearBackpackCargoGlobal _veh;
		clearItemCargoGlobal _veh;
		_veh lock true;
		_colorsConfig=configFile >> "CfgVehicles" >> (_arr select 0) >> "availableColors";
		if(isArray(_colorsConfig))then{
			_textureSelectionIndex=configFile >> "CfgVehicles" >> (_arr select 0) >> "textureSelectionIndex";
			_selections=if(isArray(_textureSelectionIndex))then{getArray(_textureSelectionIndex)}else{[0]};
			_colors=getArray(_colorsConfig);
			_textures=_colors select 0;
			_color=floor(random(count _textures));
			_count=(count _colors)-1;
			{
				if(_count >=_forEachIndex)then{
					_textures=_colors select _forEachIndex;
				};
				_veh setObjectTextureGlobal[_x,(_textures select _color)];
			}forEach _selections;
			_veh setVariable["VEHICLE_TEXTURE",_color];
		};
		_veh call EPOCH_server_vehicleInit;
		_veh call HS_weaponsrestriction;
		_veh addEventHandler ["GetIn",{
			HalvPV_player_message = ["titleText", ["[Warning]:\nnThis vehicle is a rental and will disappear on server restart!", "PLAIN DOWN"]];
			owner(_this select 2) publicVariableClient "HalvPV_player_message";
		}];
		_veh setVariable["HSHALFPRICE",1,true];
		_itemWorth = ((_arr select 1)/2);
		_itemTax = (_arr select 2);
		_tax = _itemWorth * (EPOCH_taxRate + _itemTax);
		_calced = ceil(_itemWorth + _tax);
		[_player,_calced*-1]call HALV_server_takegive_crypto;
		_message = format["You Rented a Temporary %1 untill next restart\nIt is 'unlocked' so watch out for thieves!",_arr select 4];
		diag_log format["[HSBlackmarket] %1 | %2",_player,_arr];
	};
};

if !(_message isEqualTo "")then{
	HalvPV_player_message = ["titleText", [_message, "PLAIN DOWN"]];
	(owner _player) publicVariableClient "HalvPV_player_message";
}else{
	HalvPV_player_message = ["titleText", ["== HS Trader ERROR ==", "PLAIN DOWN"]];
	(owner _player) publicVariableClient "HalvPV_player_message";
};