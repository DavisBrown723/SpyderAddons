/* ----------------------------------------------------------------------------
Function: SpyderAddons_fnc_getModuleArray

Description:
Get's an array from a module field

Parameters:
String - Module field variable

Returns:
Array - Array

Examples:
(begin example)
_whitelistMarkers = [_logic getVariable "WhitelistMarkers"] call SpyderAddons_fnc_getModuleArray;
(end)

See Also:
- nil

Author: SpyderBlack723
---------------------------------------------------------------------------- */

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

//-- Split array entries into strings
_variable = [_variable, ","] call CBA_fnc_split;

if (count _variable == 0) then {_variable = []};

_variable