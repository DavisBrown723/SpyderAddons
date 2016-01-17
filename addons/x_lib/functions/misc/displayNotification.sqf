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

params [
	["_text", ""];
	["_placement", "upperleft"],
	["_speed", 1],
	["_deletionDelay", 4]
];

_ctrl = findDisplay 46 ctrlCreate ["RscStructuredText", -1];
_ctrl ctrlSetBackgroundColor [0.392,0.412,0.42,1];
_ctrl ctrlSetText _text;

switch (toLower _placement) do {
	case "upperleft": {
		_ctrl ctrlSetPosition [-.215, -.4,.3, ((ceil (count _text / 26)) * 0.06)];
	};
};

_ctrl ctrlCommit 0;

_ctrl ctrlSetPosition [-.215, -.255];
_ctrl ctrlCommit _speed;

sleep _deletionDelay;
ctrlDelete _ctrl;