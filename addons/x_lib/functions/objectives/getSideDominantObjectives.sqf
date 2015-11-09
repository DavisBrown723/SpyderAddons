/* ----------------------------------------------------------------------------
Function: SpyderAddons_fnc_getSideDominantObjectives

Description:
Returns objectives that are controlled by the given side

Parameters:
String or Object- Side

Returns:
Array - Objectives

Examples:
(begin example)
["WEST"] call SpyderAddons_fnc_getSideDominantObjectives; //-- Returns objectives controlled by side WEST
[WEST] call SpyderAddons_fnc_getSideDominantObjectives; //-- Returns objectives controlled by side WEST
(end)

See Also:
- nil

Author: SpyderBlack723
---------------------------------------------------------------------------- */

params ["_objectives","_side"];
private ["_dominantSide"];
_returnList = [];

//-- Convert side to a string if it's not already
if !(typeName _side == "STRING") then {_side = str _side};

//-- Get objectives with dominant faction same as passed side
{
	_position = [_x,"center"] call CBA_fnc_HashGet;
	_size = [_x,"size"] call CBA_fnc_HashGet;
	_dominantFaction = [_position, _size + 100] call ALiVE_fnc_getDominantFaction;
	if (!isNil "_dominantFaction") then {
		_dominantSide = [getNumber (configfile >> "CfgFactionClasses" >> _dominantFaction >> "side")] call ALIVE_fnc_sideNumberToText;
		if (_dominantSide == _side) then {
			_returnList pushBack _x;
		};
	};
	sleep .1;
} forEach _objectives;

_returnList;