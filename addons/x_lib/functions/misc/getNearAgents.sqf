/* ----------------------------------------------------------------------------
Function: SpyderAddons_fnc_getNearAgents

Description:
Get's nearby ALiVE civilians

Parameters:
Array - Position
Scalar - Range

Returns:
Array - Array of agents

Examples:
(begin example)
_nearAgents = [getPos player, 400] call SpyderAddons_fnc_getNearAgents;
(end)

See Also:
- nil

Author: SpyderBlack723
---------------------------------------------------------------------------- */

params [
	["_pos", [0,0,0]],
	["_maxRange", 800]
];

_agents = [];
{
	if (side _x == civilian) then {
		if (!isNil {_x getVariable "agentID"}) then {
			if (_x distance2D _pos < _maxRange) then {
				_agents pushBack _x;
			};
		};
	};
} forEach allUnits;

_agents