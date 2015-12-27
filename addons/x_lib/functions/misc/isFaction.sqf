/* ----------------------------------------------------------------------------
Function: SpyderAddons_fnc_isFaction

Description:
Tests whether a string is a valid faction

Parameters:
none

Returns:
Bool - Result

Examples:
(begin example)
_result = ["BLU_F"] call SpyderAddons_fnc_isFaction;	//-- True
(end)

See Also:
- nil

Author: SpyderBlack723
---------------------------------------------------------------------------- */

params ["_faction"];

_factionConfigs = "true" configClasses (configFile >> "CfgFactionClasses");
_factions = [];
{_factions pushBack (configName _x)} forEach _factionConfigs;

(_faction in _factions)