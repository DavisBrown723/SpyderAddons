/* ----------------------------------------------------------------------------
Function: SpyderAddons_fnc_getFactionMostPlayers

Description:
Returns the faction that contains the most players

Parameters:
none

Returns:
String - Faction with most players

Examples:
(begin example)
_faction = [] call SpyderAddons_fnc_getFactionMostPlayers;
(end)

See Also:
- nil

Author: SpyderBlack723
---------------------------------------------------------------------------- */

//-- Gather player factions
_factions = [];
{
	if (hasInterface) then {
		_factions pushBack (faction _x);
	};
} forEach allPlayers;

_factionData = [];
_factionCounts = [];
for "_i" from 0 to (count _factions - 1) do {
	_faction = _factions select _i;
	_countFaction = {_x == _faction} count _factions;

	if !(_countFaction == 0) then {
		for "_x" from 0 to _countFaction step 1 do {_factions = _factions - [_faction]};
		_factionData pushBack [_faction, _countFaction];
		_factionCounts pushBack _countFaction;
	};
};

_sortedFactions = _factionCounts call BIS_fnc_sortNum;
_playerFaction = (_sortedFactions select (count _sortedFactions - 1));

for "_i" from 0 to (count _factionData) do {
	_testedFactionData = _factionData select _i;
	_testedFactionData params ["_faction","_factionCount"];

	if (_factionCount == _playerFaction) exitWith {
		["SpyderAddons_fnc_getFactionMostPlayers: Returning faction %1", _faction] call ALIVE_fnc_dump;
		_faction;
	};
};