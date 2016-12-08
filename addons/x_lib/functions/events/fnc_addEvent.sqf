#include "\x\spyderaddons\addons\x_lib\script_component.hpp"
SCRIPT(addEvent);

/* ----------------------------------------------------------------------------
Function: SpyderAddons_fnc_addEvent

Description:
Registers an event on the server

Parameters:
String - type
Any - data
String - from
String - message

Returns:
Any - Result of the operation

Examples:
(begin example)
_event call SpyderAddons_fnc_addEvent;
(end)

See Also:
- nil

Author: SpyderBlack723

Peer Reviewed:
nil
---------------------------------------------------------------------------- */

if (isServer) then {
    [MOD(eventSystem),"registerEvent", _this] call SpyderAddons_fnc_eventHandler;
} else {
    _this remoteExecCall ["SpyderAddons_fnc_addEvent", 2];
};