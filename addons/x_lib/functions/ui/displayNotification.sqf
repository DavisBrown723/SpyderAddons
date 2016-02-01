/* ----------------------------------------------------------------------------
Function: SpyderAddons_fnc_displayNotification

Description:
Displays a notification that slides into view

Parameters:
String - Faction of forcepool to adjust

Returns:
None

Examples:
(begin example)
["Displayed Text", "left", 1, 5] call SpyderAddons_fnc_displayNotification
["Displayed Text"] call SpyderAddons_fnc_displayNotification
(end)

See Also:
- nil

Author: SpyderBlack723
---------------------------------------------------------------------------- */

private ["_startPoint"];
params [
	["_text", ""],
	["_placement", "upperleft"],
	["_speed", .7],
	["_onScreenTime", 4]
];
disableSerialization;

#define GUI_GRID_X	(0)
#define GUI_GRID_Y	(0)
#define GUI_GRID_W	(0.025)
#define GUI_GRID_H	(0.04)

_ctrl = findDisplay 46 ctrlCreate ["RscStructuredText", -1];
_ctrl ctrlSetBackgroundColor [0.392,0.412,0.42,1];
_ctrl ctrlSetText _text;

switch (toLower _placement) do {
	case "upperleft": {
		_startPoint = [(-14.27 * GUI_GRID_W + GUI_GRID_X), (-8.5 * GUI_GRID_H + GUI_GRID_Y)];
		_ctrl ctrlSetPosition [_startPoint select 0, _startPoint select 1, (11.5 * GUI_GRID_W),((ceil (count _text / 26)) * 0.06)];
	};
};

_ctrl ctrlCommit 0;

//-- Slide into view
_ctrl ctrlSetPosition [(-14.27 * GUI_GRID_W + GUI_GRID_X), (-5.36 * GUI_GRID_H + GUI_GRID_Y)];
_ctrl ctrlCommit _speed;

sleep _onScreenTime;

//-- Slide offscreen
_ctrl ctrlSetPosition _startPoint;
_ctrl ctrlCommit _speed;

sleep (_speed + 1);
ctrlDelete _ctrl;