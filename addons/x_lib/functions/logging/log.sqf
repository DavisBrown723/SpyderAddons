/* ----------------------------------------------------------------------------
Function: SpyderAddons_fnc_log

Description:
Logs variables to the RPT
For use with modules that don't require ALiVE (ALiVE_fnc_dump used otherwise)

Parameters:
Mixed

Returns:
none

Examples:
(begin example)
//-- Simple
[getPos player] call SpyderAddons_fnc_log;

//-- Formatted
["Module Init Finished: %1", "civ_interact"] call SpyderAddons_fnc_log;
(end)

See Also:
-nil

Author:
SpyderBlack723

peer reviewed:
-nil
---------------------------------------------------------------------------- */

private ["_result"];
params ["_variable"];

if (isNil "_variable") exitWith {diag_log "[SpyderAddons - log: Incorrect parameters passed]"};

//-- Format double variables
if (count _this > 1) then {
	_variable = format _this;
};

//-- Convert to string
if (typeName _variable == "STRING") then {
	_result = _variable;
} else {
	_result = str _variable;
};

diag_log text _result;