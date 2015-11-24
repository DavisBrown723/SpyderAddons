params ["_unit"];

if (!isServer) exitWith {_this remoteExecCall ["SpyderAddons_fnc_addCivilianAction",2]};
if ((side _unit != civilian) or (isNil "SpyderAddons_civInteract_Logic")) exitWith {};

[[[_unit],{
	if (hasInterface) then {
		params ["_unit"];
		_unit addAction ["Interact", "['openMenu', [_this select 0]] call SpyderAddons_fnc_civInteract", "", 50, true, false, "", "alive _target"];
	};
}],"BIS_fnc_spawn",true] call BIS_fnc_MP;

/* --------
[
	[[_unit],
	{
		if (hasInterface) then {
			params ["_unit"];
			_unit addAction ["Interact", "['openMenu', [_this select 0]] call SpyderAddons_fnc_civInteract", "", 50, true, false, "", "alive _target"];
		};
	}]
] remoteExecCall ["BIS_fnc_spawn",0];
-------- */