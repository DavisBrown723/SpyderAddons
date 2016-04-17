#include "\x\spyderaddons\addons\x_lib\script_component.hpp"
SCRIPT(event);

/* ----------------------------------------------------------------------------
Function: SpyderAddons_fnc_createEvent

Description:
Creates an event

Parameters:
String - type
Any - data
String - from
String - message

Returns:
Any - Result of the operation

Examples:
(begin example)
_event = ["Name",["Data"],"Sender","Message"] call SpyderAddons_fnc_event;
(end)

See Also:
- nil

Author: SpyderBlack723

Peer Reviewed:
nil
---------------------------------------------------------------------------- */

params [
	["_type", "", [""]],
	["_data", []],
	["_from", "", [""]],
	["_message","", [""]]
];

_event = [] call SpyderAddons_fnc_hashCreate;
[_event,"type", _type] call SpyderAddons_fnc_hashSet;
[_event,"data", _data] call SpyderAddons_fnc_hashSet;
[_event,"from", _from] call SpyderAddons_fnc_hashSet;
[_event,"message", _message] call SpyderAddons_fnc_hashSet;

_event