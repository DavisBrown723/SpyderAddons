/* ----------------------------------------------------------------------------
Function: SpyderAddons_fnc_numberInBounds

Description:
Returns whether a number is between the given bounds

Parameters:
Scalar - Number
Array - Bounds
	Scalar - Lower Bound
	Scalar - Higher Bound
Bool - True if number is between bounds

Returns:
Bool - Result

Examples:
(begin example)
_result = [5,[0,10]] call SpyderAddons_fnc_numberInBounds;	//-- Returns: true
_result = [5,[10,20]] call SpyderAddons_fnc_numberInBounds;	//-- Returns: false
(end)

See Also:
- nil

Author: SpyderBlack723
---------------------------------------------------------------------------- */

private ["_result"];
params [
	["_number", 0],
	["_bounds", [-1,0]]
];

_bounds params ["_botBound","_topBound"];

if (_number > _botBound) then {
	if (_number < _topBound) then {
		_result = true;
	} else {
		_result = false;
	};
} else {
	_result = false;
};

_result

