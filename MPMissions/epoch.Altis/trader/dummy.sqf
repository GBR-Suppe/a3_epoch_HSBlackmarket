/*
	a3 epoch trader
	dummy.sqf
	by Halv & Suppe
*/

systemChat "WARNING:";
systemChat "This trader is NOT finished yet ...";
systemChat "... you might loose items and / or crypto trading here!";

HS_SWITCH = false;
createDialog "HS_trader_dialog";
call HS_trader_menu;
