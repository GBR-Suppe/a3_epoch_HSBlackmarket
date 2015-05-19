/*
	a3 epoch trader
	HALV_PurgeObject.sqf
	by Halv
*/

_this enableSimulation false;
{_this removeAllMPEventHandlers _x;}count ["mpkilled","mphit","mprespawn"];
{_this removeAllEventHandlers _x;}count ["FiredNear","HandleDamage","Killed","Fired","GetOut","GetIn","Local"];
deleteVehicle _this;
deleteGroup (group _this);
_this = nil;
