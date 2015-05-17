/*
	HALV_takegive_crypto.sqf
	by Halv
*/

_player = _this select 0;
_nr = _this select 1;
_cIndex=EPOCH_customVars find 'Crypto';
_vars = _player getVariable['VARS',[]+EPOCH_defaultVars_SEPXVar];
_curcrypt = _vars select _cIndex;
_newcrypt = _curcrypt+_nr;
[['effectCrypto',_newcrypt],(owner _player)]call EPOCH_sendPublicVariableClient;
_vars set[_cIndex,_newcrypt];
_player setVariable["VARS",_vars];
