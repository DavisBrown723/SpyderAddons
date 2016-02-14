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

See Also:
- nil

Author: SpyderBlack723
---------------------------------------------------------------------------- */

params ["_number","_array"];
private _closest = 0;

{if (abs (_number - _x) < _closest) then {_closest = _x}} forEach _array;

if (_closest == 0) then {_number} else {_closest};