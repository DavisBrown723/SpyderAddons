/* ----------------------------------------------------------------------------
Function: SpyderAddons_fnc_getOpcomsBySide

Description:
Returns an array of opcoms controling factions of the passed side

Parameters:
String/Object - Side

Returns:
Array - Opcom hash

Examples:
(begin example)
_westOpcoms = "WEST" call SpyderAddons_fnc_getOpcomsBySide
_westOpcoms = WEST call SpyderAddons_fnc_getOpcomsBySide
(end)

See Also:
- nil

Author: SpyderBlack723
---------------------------------------------------------------------------- */

private _side = _this;
private _result = [];

if (typename _side == "OBJECT") then {_side = str _side};

if !(isnil "OPCOM_instances") then {
	{
		private _opcomSide = [_x,"side",""] call ALiVE_fnc_hashGet;

		if (_opcomSide == _side) then {_result pushback _x};
	} foreach OPCOM_instances;
};