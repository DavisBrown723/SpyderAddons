/* ----------------------------------------------------------------------------
Function: SpyderAddons_fnc_getAsymmOpcoms

Description:
Returns asymmetric opcom handlers

Parameters:
String - Side or faction of opcoms to return (Optional)

Returns:
Array - Array of asymmetric opcom handlers

Examples:
(begin example)
_opcoms = [] call SpyderAddons_fnc_getAsymmOpcoms;
_opcoms = ["EAST"] call SpyderAddons_fnc_getAsymmOpcoms;
_opcom = ["OPF_G_F"] call SpyderAddons_fnc_getAsymmOpcoms; //-- Can also be done by simply doing: ["OPF_G_F"] call SF_fnc_getOpcom;
(end)

See Also:
- nil

Author: SpyderBlack723
---------------------------------------------------------------------------- */

private ["_identifiers"];
if (count _this > 0) then {_identifiers = _this};

_asymmOpcoms = [];
{
	_moduleType = _x getVariable "moduleType";

	if (!isNil "_moduleType") then {
		if (_moduleType == "ALIVE_OPCOM") then {
			_controlType = _x getVariable "controltype";

			if (_controlType == "asymmetric") then {
				_opcom = _x getVariable "handler";
				_side = [_opcom, "side"] call ALiVE_fnc_hashGet;
				_factions = [_opcom, "factions"] call ALiVE_fnc_hashGet;

				if (!isNil "_identifiers") then {
					{
						_identifier = _x;

						if (_identifier in ([_side] + _factions)) then {
							_asymmOpcoms pushBack _opcom;
						};
					} forEach _identifiers;
				} else {
					_asymmOpcoms pushBack _opcom;
				};
			};
		};
	};
} forEach (entities "Module_F");

["SpyderAddons_fnc_getAsymmOpcoms: Returning %1 asymmetric opcoms", count _asymmOpcoms] call ALIVE_fnc_dump;

_asymmOpcoms