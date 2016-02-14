#include <\x\spyderaddons\addons\civ_interact\script_component.hpp>
SCRIPT(getResponses);

/* ----------------------------------------------------------------------------
Function: SpyderAddons_fnc_getResponses

Description:
Returns any responses for a question

Parameters:
Object - Logic
String - Question

Returns:
none

Examples:
(begin example)
(end)

See Also:
- nil

Author:
SpyderBlack723

Peer Reviewed:
nil
---------------------------------------------------------------------------- */

private ["_result"];
params [
	["_logic", objNull],
	["_question", ""]
];

//-- Get information
_civ = [_logic,"Civ"] call ALiVE_fnc_hashGet;
_personality = [nil,"getPersonality", _civ] call SpyderAddons_fnc_personalityHandler;

switch (_question) do {


};

//-- Return result if any exists
if (!isNil "_result") then {_result} else {nil};