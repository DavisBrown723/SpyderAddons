/* ----------------------------------------------------------------------------
Function: SpyderAddons_fnc_inspectArray

Description:
Inspects an array to the rpt

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

params ["_array"];

if !(typeName _array == "ARRAY") exitWith {
	[" ------------------ SpyderAddons: Inspecting Array -------------------- "] call SpyderAddons_fnc_log;
	["      Passed value is not an array, exiting"] call SpyderAddons_fnc_log;
	[" ------------------ SpyderAddons: Inspection Complete -------------------- "] call SpyderAddons_fnc_log;
};

_indentOne = "      ";
_indentTwo = "              ";

[" ------------------ SpyderAddons: Inspecting Array -------------------- "] call SpyderAddons_fnc_log;

for "_x" from 0 to (count _array - 1) do {
	_value = _array select _x;

	_data = _array select _x;
	["%1[%2]: %3", _indentOne,_x,_data] call SpyderAddons_fnc_log;

	if (typeName _data == "ARRAY") then {
		{
			["%1[%2]: %3", _indentTwo,_forEachIndex,_x] call SpyderAddons_fnc_log;
		} forEach _data;
	};
};

[" ------------------ SpyderAddons: Inspection Complete -------------------- "] call SpyderAddons_fnc_log;