/*
	HS Blackmarket
	by Halv & Suppe
*/

Copyright (C) 2015 Halvhjearne & Suppe

This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with this program. If not, see http://www.gnu.org/licenses/.

Contact : halvhjearne@gmail.com



The HS Blackmarket is a 'new' Trader-system for A3 Epoch, it was created in collaboration with Halv, he wrote 90% of the scripts, Halv is the true genius.

Features:
- Trader with Custom Dialog (Menu)
- Trader with unlimited supply
- Trader will spawn random over the Map
- Trader will spawn in 5 different "Camps"
- Easily edit/add Prices,Items,Vehicles,Weapons
- Easily Blacklist Items,Vehicles,Weapons
- Easily control about Vehicleammo
- Vehicleammo count over restart (10 bullets left for the restart = 10 bullets left after restart)
- Static and Random Traders
- Work with stock Epoch AH and infistar
- Work without emod !
- Work on every Map

Install:
- Copy the "trader" Folder and the Stringtable.xml in your epoch.Mission

- Add to your init:
  [] execVM "trader\init.sqf";
  [] execVM "trader\HALV_takegive_crypto_init.sqf";
  [] execVM "trader\resetvehicleammo.sqf";
  
- Add to your description.ext ( On the very top. And if you use Halv's spawn script as well, you need only 1x the Halv_defines.hpp )
  #include "trader\Halv_defines.hpp"
  #include "trader\tradedialog.hpp"
  #include "trader\HSPricing.hpp"


- (optional) Open epoch.Mission/trader/init.sqf to configurate the HS Blackmarket

- (optional) Open epoch.Mission/trader/HSPricing.hpp to configurate prices, or to add Items,Vehicles,Weapons and so on

- (optional) Open epoch.Mission/trader/settings.sqf and resetvehicleammo.sqf to configurate the Vehicleammo

- (optional) Remove 1 Epoch Trader for every Blackmarket Trader you added (remove Epoch Trader: \Arma 3\@epochhive\epochconfig.hpp  ,search for NPCSlotsLimit)

- (optional) to get all messages of the traders (like the vehicleworldlimit check) you need: http://epochmod.com/forum/index.php?/topic/34570-easy-kill-feedmessages-wstudy-bury-body-function-beta/
  
- Edit your BE Filter:
createvehicle.txt   Line 1   add:
!="M_AT" !="SmokeLauncherAmmo" !="B_AssaultPack_cbr" !="B_AssaultPack_dgtl" !="B_AssaultPack_khk" !="B_AssaultPack_mcamo" !="B_AssaultPack_ocamo" !="B_AssaultPack_rgr" !="B_AssaultPack_sgg" !="B_Carryall_cbr" !="B_Carryall_khk" !="B_Carryall_mcamo" !="B_Carryall_ocamo" !="B_Carryall_oli" !="B_Carryall_oucamo" !="B_FieldPack_blk" !="B_FieldPack_cbr" !="B_FieldPack_khk" !="B_FieldPack_ocamo" !="B_FieldPack_oli" !="B_FieldPack_oucamo" !="B_Kitbag_cbr" !="B_Kitbag_mcamo" !="B_Kitbag_rgr" !="B_Kitbag_sgg" !="B_Parachute" !="B_TacticalPack_blk" !="B_TacticalPack_mcamo" !="B_TacticalPack_ocamo" !="B_TacticalPack_oli" !="B_TacticalPack_rgr"
createvehicle.txt   Line 2   add:
!="smallbackpack_red_epoch" !="smallbackpack_green_epoch" !="smallbackpack_teal_epoch" !="smallbackpack_pink_epoch"

publicvariable.txt    Line 1   add:
!="BIS_fnc_objectVar_obj2_1288" !="HALV_takegive" !="HSPV_traderrequest"

setvariable.txt   Line 1   add:
!="bis_fnc_objectvar_var" !="BIS_fnc_objectVar_obj2_1280"

scripts.txt      7 createDialog    add:
!="createDialog "HS_trader_dialog";"
scripts.txt      7 addMagazine    add:
!="if !(player canAdd (_x select 0)) exitWith {};\nplayer addMagazine[_x select 0, _x select 1];"
scripts.txt      7 setVelocity    add:
!="_smokeg setVelocity _Gvel;"
scripts.txt      7 addItem    add:
!="_this call HS_additemtolb;false"
scripts.txt      7 exec    add:
!="trader\init.sqf";"

- For infistar Server:
add these: 9999,9980 to the allowedDialogs.
like this: _allowedDialogs = [-1,602,7777,7778,9999,9980];
and
/*  Remove Actions Plr and /*  Remove Actions Objs
^ must both be false.