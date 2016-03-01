/* ----------------------------------------------------------------------------
Function: SpyderAddons_fnc_ctrlGetRelDistance

Description:
Finds the relative position of control 2, from the position of control 1

Parameters:
Control - Control 1
Control - Control 2

Returns:
Position array [x,y]

Examples:
(begin example)
_relDist = [_ctrl1,_ctrl2] call SpyderAddons_fnc_ctrlGetRelDistance; 	// Find relative difference in position from ctrl1 to ctrl2
[_ctrl1,_relDist] call SpyderAddons_fnc_ctrlRelMove; 		// Move ctrl1 to the position of ctrl2
(end)

See Also:
- nil

Author: SpyderBlack723
---------------------------------------------------------------------------- */

disableSerialization;
_this params [
	["_controlOne", ctrlNull],
	["_controlTwo", ctrlNull]
];

(ctrlPosition _controlOne) params [["_x1",0],["_y1",0]];
(ctrlPosition _controlTwo) params [["_x2",0],["_y2",0]];

[_x2 - _x1,_y2 - _y1]