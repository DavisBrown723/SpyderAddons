/* ----------------------------------------------------------------------------
Function: SpyderAddons_fnc_ctrlRelMove

Description:
Moves a control relative to it's current position

Parameters:
Control - Progress bar
Array - Position array
	Scalar - X value
	Scalar - Y value
	Scalar - W value
	Scalar - H value

Returns:
None

Examples:
(begin example)
(end)

See Also:
- nil

Author: SpyderBlack723
---------------------------------------------------------------------------- */

disableSerialization;
_this params [
	["_controls",[]],
	["_positionArray", [0,0,0,0]],
	["_commitTime", 0]
];

if (typename _controls != "ARRAY") then {_controls = [_controls]};

_positionArray params [
	["_offsetX",0],
	["_offsetY",0],
	["_offsetW",0],
	["_offsetH",0]
];

{
	_control = _x;
	(ctrlPosition _control) params ["_x","_y","_w","_h"];

	_control ctrlSetPosition [_x + _offsetX, _y + _offsetY, _w + _offsetW, _h + _offsetH];
	_control ctrlCommit _commitTime;
} forEach _controls;