/* ----------------------------------------------------------------------------
Function: SpyderAddons_fnc_createObjective

Description:
Creates an ALiVE objective and registers it to opcoms of the given sides and factions

Parameters:
Array - Objective parameters
	String - ID
	Array - position
	String - Type
	Scalar - Size
	Scalar - Priority
	String - Opcom state (unassigned, idle, reserve, defend, attack)
Array - Sides or factions of opcoms to register the objective for

Returns:
none

Examples:
(begin example)
[["Outpost_Restrepo", getPos player, "MIL"], ["WEST"]] call SpyderAddons_fnc_createObjective;
[["Bosovo", getMarkerPos "Town15"], ["WEST"]] call SpyderAddons_fnc_createObjective;
[["DefendTown_3", _defendPos, "CIV", 250, 35, "defend"], ["BLU_F"]] call SpyderAddons_fnc_createObjective;
[["AssaultPos_4", _assaultPos, "MIL", 300, 50, "attack"], ["BLU_F"]] call SpyderAddons_fnc_createObjective;
(end)

See Also:
- nil

Author: SpyderBlack723
---------------------------------------------------------------------------- */

private ["_identifier"];
params [
	["_objectiveParams", []],
	["_identifiers", []]
];

_objectiveParams params [
	["_id", format ["objective_%1",floor random 500]],
	["_pos", [0,0,0]],
	["_type", "CIV"],
	["_size", 150],
	["_priority", 20],
	["_opcomState", "unassigned"]
];
_objectiveParams = [_id, _pos, _size, _type, _priority];

{
	_opcom = _x;

	{
		_identifier = _x;
		_side = [_opcom,"side"] call ALiVE_fnc_HashGet;
		_factions = [_opcom,"factions"] call ALiVE_fnc_HashGet;

		if (_identifier in ([_side] + _factions)) then {
			[_opcom, "addObjective", _objectiveParams] call ALiVE_fnc_OPCOM;
		};
	} forEach _identifiers;
} forEach OPCOM_INSTANCES;