private ["_result"];
params [
	["_profileID", []]
];
_result = false;

if (_profileID isEqualTo []) exitWith {_result};


_profile = [ALIVE_profileHandler, "getProfile", _profileID] call ALIVE_fnc_profileHandler;
if !(isNil "_profile") then {_result = true};

_result