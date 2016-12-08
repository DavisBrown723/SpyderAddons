/* ----------------------------------------------------------------------------
Function: SpyderAddons_fnc_getOpcomByFaction

Description:
Returns an opcom that controls the passed faction, if any exist

Parameters:
String - Faction

Returns:
Array - Opcom hash

Examples:
(begin example)
_natoOpcom = "BLU_F" call SpyderAddons_fnc_getOpcomByFaction;
(end)

See Also:
- nil

Author: SpyderBlack723
---------------------------------------------------------------------------- */

private _faction = _this;

if !(isnil "OPCOM_instances") then {
	{
		private _opcomFactions = [_x,"factions",""] call ALiVE_fnc_hashGet;

		if (_faction in _opcomFactions) exitWith {_x};
	} foreach OPCOM_instances;
};