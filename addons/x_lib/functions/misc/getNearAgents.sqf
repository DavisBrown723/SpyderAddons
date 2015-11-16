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
} forEach allUnitsl

_agents