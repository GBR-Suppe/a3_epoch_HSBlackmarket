/*
	a3 epoch trader
	dummy.sqf
	by Halv & Suppe
	
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

//systemChat "WARNING:";
//systemChat "This trader is NOT finished yet ...";
//systemChat "... you might loose items and / or crypto trading here!";

HS_SWITCH = false;
createDialog "HS_trader_dialog";
call HS_trader_menu;
