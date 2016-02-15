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
_civData = [_logic,"CivData"] call ALiVE_fnc_hashGet;
_civInfo = [_civData,"CivInfo"] call ALiVE_fnc_hashGet;
_personality = [_civInfo,"Personality"] call ALiVE_fnc_hashGet;

switch (_question) do {

	case "HowAreYou": {
		if (random 100 > [_personality,"Hostility"] call ALiVE_fnc_hashGet) then {
			//-- Positive
			_responses = ["I am well","I am well, how are you?","Everything is going well here","Life has been kind to me","No problems plague me",
			"Thanks to your forces, everything is well","There are no problems here","I have no complaints"];

			_result = [_responses call BIS_fnc_selectRandom,[]];
		} else {
			//-- Negative
			if (random 100 > [_personality,"Aggressiveness"] call ALiVE_fnc_hashGet) then {
				//-- Aggressive
				_responses = ["Get out of here!","Leave me alone you demon!","Leave now!","It will be fine once you leave.","I hate you.",
				"Every day I have to see you patrol is a day in hell.","Go to hell!","I have no time for you!"];

				_result = [_responses call BIS_fnc_selectRandom,[]];
			} else {
				//-- Non Aggressive
				_responses = ["Leave now.","I have no time for you.","Awful, thanks to you.","Your forces have ruined life around here.","Leave me alone.",
				"You need to leave.","Go to hell.","I hope you die in a hole."];

				_result = [_responses call BIS_fnc_selectRandom,[]];
			};
		};
	};

};

//-- Return result if any exists
if (!isNil "_result") then {_result} else {nil};