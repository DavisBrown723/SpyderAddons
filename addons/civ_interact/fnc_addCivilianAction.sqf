params ["_unit"];

if (!isNil "SpyderAddons_civInteractHandler" && {side _unit == CIVILIAN}) then {
	_unit addAction ["Interact", {[SpyderAddons_civInteractHandler,"openMenu", _this select 0] call SpyderAddons_fnc_civInteract}, "", 50, true, false, "", "alive _target"];
};