params ["_unit"];

if ((side _unit != civilian) or (isNil "SpyderAddons_civInteract_Logic")) exitWith {};

[[[_unit],{
	if (hasInterface) then {
		params ["_unit"];
		_unit addAction ["Interact", "['openMenu', [_this select 0]] call SpyderAddons_fnc_civInteract", "", 50, true, false, "", "alive _target"];
	};
}],"BIS_fnc_spawn",true] call BIS_fnc_MP;