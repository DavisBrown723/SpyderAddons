/* ----------------------------------------------------------------------------
Function: SpyderAddons_fnc_addForcepool

Description:
Adjusts forcepool for the given faction

Parameters:
String - Faction of forcepool to adjust

Returns:
True - True if forcepool was added successfully

Examples:
(begin example)
["BLU_F", 20] call SpyderAddons_fnc_addForcepool; //-- Add 20 forcepool to NATO
["BLU_F", -20] call SpyderAddons_fnc_addForcepool; //-- Subtract 20 forcepool to NATO
[[] call SF_fnc_getFactionMostPlayers, 20] call SpyderAddons_fnc_addForcepool; //-- Add 20 forcepool to the faction with the most players
(end)

See Also:
- nil

Author: SpyderBlack723
---------------------------------------------------------------------------- */

params ["_input","_amount"];
private ["_faction"];

//-- Get faction
if (typeName _input == "OBJECT") then {
	_faction = faction _input;
} else {
	if (typeName _input == "STRING") then {
		_faction = _input;
	};
};

//-- Exit if no opcom exists for faction (Possibly add extra check to see if opcom exists to then check to see if a logistics module is synced)
if ((isNil {[ALIVE_globalForcePool, _faction] call ALIVE_fnc_hashGet}) or (isNil "_faction")) exitWith {
	["SpyderAddons_fnc_addForcepool: Faction %1 does not have an existing forcepool", _faction] call ALIVE_fnc_dump;
	false;
};

_forcePool = [ALIVE_globalForcePool, _faction] call ALIVE_fnc_hashGet;
[ALIVE_globalForcePool, _faction, (_forcePool + _amount)] call ALIVE_fnc_hashSet;
["SpyderAddons_fnc_addForcepool: %1 forcepool added to faction %2", _amount, _faction] call ALIVE_fnc_dump;