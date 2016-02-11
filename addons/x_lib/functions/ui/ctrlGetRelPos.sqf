/* ----------------------------------------------------------------------------
Function: SpyderAddons_fnc_ctrlGetRelPos

Description:
Finds the positions relative to the passed control's position

Parameters:
Control - Control
Array - Position array
	Scalar - X offset
	Scalar - Y offset

Returns:
Position array [x,y]

Examples:
(begin example)
(end)

See Also:
- nil

Author: SpyderBlack723
---------------------------------------------------------------------------- */

disableSerialization;
_this params [
	["_control",[]],
	["_positionArray", [0,0]]
];

_positionArray params [
	["_offsetX",0],
	["_offsetY",0]
];

(ctrlPosition _control) params ["_x","_y"];

[_x + _offsetX, _y + _offsetY]