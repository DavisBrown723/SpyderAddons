/* ----------------------------------------------------------------------------
Function: SpyderAddons_fnc_getOpcoms

Description:
Returns opcom handlers of given parameters

Parameters:
String - Faction or side of opcoms to return (Optional)

Returns:
Array - Array of opcom handlers

Examples:
(begin example)
_opcom = [] call SpyderAddons_fnc_getOpcoms; //-- Returns all opcoms
_opcom = ["WEST"] call SpyderAddons_fnc_getOpcoms; //-- Returns opcoms controlling factions of side west
_opcom = ["BLU_F"] call SpyderAddons_fnc_getOpcoms; //-- Returns opcom controlling NATO faction
(end)

Noes:
Important to note that if you are retrieving a faction opcom, you will need to (_opcoms select 0) due to it still retrieving an array. Will change when not lazy.

See Also:
- nil

Author: SpyderBlack723
---------------------------------------------------------------------------- */

private ["_identifiers"];
if (count _this > 0) then {_identifiers = _this};

_opcoms = [];
{
	_opcom = _x;

	if (!isNil "_identifiers") then {
		_side = [_opcom, "side"] call ALiVE_fnc_hashGet;
		_factions = [_opcom, "factions"] call ALiVE_fnc_hashGet;

		{
			_identifier = _x;

			if (_identifier in ([_side] + _factions)) then {
				_opcoms pushBack _opcom;
			};
		} forEach _identifiers;
	} else {
		_opcoms pushBack _opcom;
	};
} forEach OPCOM_instances;

_opcoms