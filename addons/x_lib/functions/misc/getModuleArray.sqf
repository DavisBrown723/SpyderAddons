params ["_variable"];

if (!(typeName _variable == "STRING") or (_variable isEqualTo "")) exitWith {[]};

//-- Remove spaces
_variable = [_variable, " ", ""] call CBA_fnc_replace;

//-- Remove brackets
_variable = [_variable, "[", ""] call CBA_fnc_replace;
_variable = [_variable, "]", ""] call CBA_fnc_replace;

//-- Remove quotations
_variable = [_variable, """", ""] call CBA_fnc_replace;
_variable = [_variable, "''", ""] call CBA_fnc_replace;

//-- Split array entries
_variable = [_variable, ","] call CBA_fnc_split;

if (count _variable == 0) then {_variable = []};

_variable