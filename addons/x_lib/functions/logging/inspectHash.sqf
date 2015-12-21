/* ----------------------------------------------------------------------------
Function: SpyderAddons_fnc_inspectHash

Description:
Inspects a hash to the rpt

Parameters:
Mixed

Returns:
none

Examples:
(begin example)
(end)

See Also:
-nil

Author:
SpyderBlack723

peer reviewed:
-nil
---------------------------------------------------------------------------- */

params ["_hash"];

if !([_hash] call CBA_fnc_isHash) exitWith {
	[" ------------------ SpyderAddons: Inspecting Hash -------------------- "] call SpyderAddons_fnc_log;
	["      Passed value is not a hash, exiting"] call SpyderAddons_fnc_log;
	[" ------------------ SpyderAddons: Inspection Complete -------------------- "] call SpyderAddons_fnc_log;
};

_keys = _hash select 1;
_values = _hash select 2;

_indentOne = "      ";
_indentTwo = "              ";

[" ------------------ SpyderAddons: Inspecting Hash -------------------- "] call SpyderAddons_fnc_log;

for "_x" from 0 to (count _keys - 1) do {
	_key = _keys select _x;

	_data = _values select _x;
	["%1[%2]: %3", _indentOne,_key,_data] call SpyderAddons_fnc_log;

	if (typeName _data == "ARRAY") then {
		{
			_value = _x;
			["%1[%2]%3:", _indentTwo,_forEachIndex,_x] call SpyderAddons_fnc_log;
		} forEach _data;
	};
};

[" ------------------ SpyderAddons: Inspection Complete -------------------- "] call SpyderAddons_fnc_log;