params ["_unit"];

if (!isNil "SpyderAddons_civInteract") then {
	_unit addAction ["Interact", {[SpyderAddons_civInteract,"openMenu", _this select 0] call SpyderAddons_fnc_civInteract}, "", 50, true, false, "", "alive _target"];
};