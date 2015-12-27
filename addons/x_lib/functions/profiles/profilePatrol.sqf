/* ----------------------------------------------------------------------------
Function: SpyderAddons_fnc_profilePatrol

Description:
Sets a profile's orders to ambient movement with the given parameters

Parameters:
Hash - Profile
Scalar - Radius
String - Behavior
Array - Default position

Returns:
None

Examples:
(begin example)
[_profile,300,"SAFE"] SpyderAddons_fnc_SpyderAddons_fnc_profilePatrol;	//-- Orders a profile to patrol randomly within 300m of it's position with safe behavior
(end)

See Also:
- nil

Author: SpyderBlack723
---------------------------------------------------------------------------- */

params [
	["_profile"],
	["_radius", 300],
	["_behavior", "SAFE"],
	["_defaultPos",[0,0,0]]
];

_command = ["ALIVE_fnc_ambientMovement",[_radius,_behavior,_defaultPos]];
[_profile, "setActiveCommand",_command] call ALIVE_fnc_profileEntity;