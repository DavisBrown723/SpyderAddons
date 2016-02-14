/* ----------------------------------------------------------------------------
Function: SpyderAddons_fnc_numberInBounds

Description:
Checks if a number is between the given bounds, and either returns true/false or the closest bound if it isn't

Parameters:
Scalar - Number
Array - Bounds
	Scalar - Lower Bound
	Scalar - Higher Bound
Bool - If true, if number is out of bounds it is adjusted to the closest bound

Returns:
Bool - Result

Examples:
(begin example)
_result = [5,[0,10]] call SpyderAddons_fnc_numberInBounds;		//-- Returns: true
_adjustedValue = [5,[10,20]] call SpyderAddons_fnc_numberInBounds;	//-- Returns: 10
(end)

See Also:
- nil

Author: SpyderBlack723
---------------------------------------------------------------------------- */

private ["_result"];
params [
	["_number", 0],
	["_bounds", [-1,0]],
	["_adjust", true]
];

_bounds params ["_botBound","_topBound"];

if (_number < _botBound) then {
	if !(_adjust) then {
		_result = false;
	};
};

if (_number > _topBound) then {
	if !(_adjust) then {
		_result = false;
	};
} else {
	if !(_adjust) then {
		_result = true;
	};
};

if (isnil "_result") then {
	_result = [_number,_bounds] call SpyderAddons_fnc_closestNumberInArray;
};

