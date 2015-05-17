/*
	HALV_takegive_crypto_init.sqf
	by Halv
*/

if(isServer)then{
	diag_log "[HSBlackmarket] Server: loading 'HALV_takegive_crypto.sqf'";
	HALV_server_takegive_crypto = compileFinal preprocessFileLineNumbers "trader\HALV_takegive_crypto.sqf";
	diag_log "[HSBlackmarket] Server: loading 'HALV_takegive' PVEvent";
	"HALV_takegive" addPublicVariableEventHandler {(_this select 1) call HALV_server_takegive_crypto};
};

if(hasInterface)then{
	isHalvTradeEnabled = true;
};