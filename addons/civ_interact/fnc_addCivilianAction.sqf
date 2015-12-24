params ["_unit"];

["Interact", {[SpyderAddons_civInteractHandler,"openMenu", _this select 0] call SpyderAddons_fnc_civInteract}, "", 50, true, false, "", "alive _target"];