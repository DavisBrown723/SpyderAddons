/* ----------------------------------------------------------------------------
Function: SpyderAddons_fnc_getObjectiveInstallations

Description:
Returns an array of installations within the objective

Parameters:
Hash - Objective

Returns:
Array - 

Examples:
(begin example)
_installations = _objective call SpyderAddons_fnc_getObjectiveInstallations;
(end)

See Also:
- nil

Author: SpyderBlack723
---------------------------------------------------------------------------- */

_objective = _this;

_HQ = [nil,"convertObject", [_objective,"HQ"] call ALiVE_fnc_HashGet] call ALiVE_fnc_OPCOM;
_depot = [nil,"convertObject", [_objective,"depot"] call ALiVE_fnc_HashGet] call ALiVE_fnc_OPCOM;
_factory = [nil,"convertObject", [_objective,"factory"] call ALiVE_fnc_HashGet] call ALiVE_fnc_OPCOM;
_roadblocks = [nil,"convertObject", [_objective,"roadblocks"] call ALiVE_fnc_HashGet] call ALiVE_fnc_OPCOM;

_ambush = [nil,"convertObject", [_objective,"ambush"] call ALiVE_fnc_HashGet] call ALiVE_fnc_OPCOM;
_sabotage = [nil,"convertObject", [_objective,"sabotage"] call ALiVE_fnc_HashGet] call ALiVE_fnc_OPCOM;
_ied = [nil,"convertObject", [_objective,"ied"] call ALiVE_fnc_HashGet] call ALiVE_fnc_OPCOM;
_suicide = [nil,"convertObject", [_objective,"suicide"] call ALiVE_fnc_HashGet] call ALiVE_fnc_OPCOM;

[_HQ,_depot,_factory,_roadblocks,_ambush,_sabotage,_ied,_suicide];