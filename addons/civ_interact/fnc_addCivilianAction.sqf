params ["_unit"];

if (!isNil "SpyderAddons_civilianInteraction") then {
	_unit addAction ["Interact", {[SpyderAddons_civilianInteraction,"openMenu", _this select 0] call SpyderAddons_fnc_civilianInteraction}, "", 50, true, false, "", "alive _target"];
};