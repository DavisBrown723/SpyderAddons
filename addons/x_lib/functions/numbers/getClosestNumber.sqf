/* ----------------------------------------------------------------------------
Function: SpyderAddons_fnc_getClosestNumber

Description:
Returns the closest number number in an array to the passed number

Parameters:
Scalar - Number
Array - Bounds

Returns:
Scalar - Closest number

Examples:
(begin example)
_result = [5,[0,4,10]] call SpyderAddons_fnc_closestNumberInArray;		//-- Returns: 4
_result = [0,[-1,2]] call SpyderAddons_fnc_closestNumberInArray;		//-- Returns: -1
(end)

Notes:
- If there are multiple numbers with the same distance from the number being checked, the first will be selected
ex. [5,[4,6]] Will return 4
- If the array is empty, nil will be returned

Author: SpyderBlack723
---------------------------------------------------------------------------- */

private ["_result","_closest"];
params ["_number","_array"];

if (count _array > 0) then {
	_closest = abs (_number - (_array select 0)) + 1;

	{
		_diff = abs (_number - _x);
		if (_diff < _closest) then {
			_closest = _diff;
			_result = _x;
		};
	} forEach _array;
};

_result