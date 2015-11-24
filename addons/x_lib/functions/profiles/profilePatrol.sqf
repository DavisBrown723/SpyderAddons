params [
	["_profile"],
	["_radius", 300],
	["_behavior", "SAFE"],
	["_defaultPos",[0,0,0]]
];

_command = ["ALIVE_fnc_ambientMovement",[_radius,_behavior,_defaultPos]];
[_profile, "setActiveCommand",_command] call ALIVE_fnc_profileEntity;