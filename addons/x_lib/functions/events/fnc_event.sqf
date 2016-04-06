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
	["_type", ""],
	["_data", []],
	["_from", ""],
	["_message",""]
];

["SA_HASH",["type","data","from","message"],[_type,_data,_from,_message]];