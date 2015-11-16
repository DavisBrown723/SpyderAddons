params ["_object"];

if (typeOf _object == "Land_MapBoard_F") then {
	_object addAction ["View Map", {hint "Yes, this does work"}];
};