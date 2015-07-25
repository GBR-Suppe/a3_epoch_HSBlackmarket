/*
	HALV_PurgeObject.sqf by Halv

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

_this enableSimulation false;
{_this removeAllMPEventHandlers _x;}count ["mpkilled","mphit","mprespawn"];
{_this removeAllEventHandlers _x;}count ["FiredNear","HandleDamage","Killed","Fired","GetOut","GetIn","Local"];
removeFromRemainsCollector[_this];
deleteVehicle _this;
deleteGroup (group _this);
_this = nil;
