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
_personality = [_civInfo,"Personality"] call ALiVE_fnc_hashGet;	// ["Bravery","Aggressiveness","Indecisiveness","ForceAlignments (Hash)"]

_hostility = [_civInfo,"HostilityIndividual"] call ALiVE_fnc_hashGet;
_hostile = [_civInfo,"Hostile"] call ALiVE_fnc_hashGet;
_civName = [_civInfo,"Name"] call ALiVE_fnc_hashGet;

switch (_question) do {

	//-- How are you
	case "HowAreYou": {
		if (random 100 < _hostility) then {
			//-- Positive
			_responses = ["I am well","I am well, how are you?","Everything is going well here","Life has been kind to me","No problems plague me",
			"Thanks to your forces, everything is well","There are no problems here","I have no complaints"];

			_result = _responses call BIS_fnc_selectRandom;
			_result = [_result, [["That is good to hear","['GoodToHear',1,1]"]]];
		} else {
			//-- Negative
			if (random 100 > [_personality,"Aggressiveness"] call ALiVE_fnc_hashGet) then {
				//-- Aggressive
				_responses = ["Get out of here!","Leave me alone you demon!","Leave now!","It will be fine once you leave.","I hate you.",
				"Every day I have to see you patrol is a day in hell.","Go to hell!","I have no time for you!","I hope you die in a hole!"];

				_result = _responses call BIS_fnc_selectRandom;
				_result = [_result, [["You better calm down","['CalmDownThreat',1.3,2]"],["Sorry to bother you","['SorryForBother',1.3,1]"]]];
			} else {
				//-- Non Aggressive
				_responses = ["Leave now.","I have no time for you.","Awful, thanks to you.","Your forces have ruined life around here.","Leave me alone.",
				"You need to leave.","Go to hell.","Get our of here pig.","Make yourself useful and leave."];

				_result = _responses call BIS_fnc_selectRandom;
				_result = [_result, [["Calm down","['CalmDown',1,1]"],["Sorry to bother you","['SorryForBother',1,1]"]]];
			};
		};
	};

	case "GoodToHear": {
		//-- No response
		_result = ["", []];
	};

	case "CalmDown": {
		if (random 100 > [_personality,"Aggressiveness"] call ALiVE_fnc_hashGet) then {
			_responses = ["You're right.","I am sorry.","Forgive me.","I will calm down.","Sorry.",format ["%1 appears to ignore you", _civName]];
			_result = [_responses call BIS_fnc_selectRandom, []];
		} else {
			_responses = ["Screw you!","Do not even dare tell me what to do!","Do not tell me what to do.","I will not listen to you!","Sorry.",format ["%1 appears to ignore you", _civName]];
			_result = [_responses call BIS_fnc_selectRandom, [["You better watch your attitude","['WatchOutThreat',1.5,2]"],["Sorry to bother you","['SorryForBother',1,1]"]]];
		};
	};

	case "CalmDownThreat": {
		if (random 100 > [_personality,"Bravery"] call ALiVE_fnc_hashGet) then {
			//-- Succumbs to threat
			_responses = ["I am sorry.","I'm sorry, I shouldn't have said that.","Please forgive me, I do not want to cause trouble.","Oh, please forgive me.","You have my apologies."];
			_result = [_responses call BIS_fnc_selectRandom, []];
		} else {
			//-- Defiant to threat
			if (random 100 > [_personality,"Aggressiveness"] call ALiVE_fnc_hashGet) then {
				//-- Non-Aggressive
				_responses = ["Do not talk to me like that.","I will not be bullied by you.","I will not surrender to you.","I refuse to be spoken to like that.","Your threats do not scare me."];
				_result = [_responses call BIS_fnc_selectRandom, []];
			} else {
				//-- Aggressive
				_responses = ["You will not order me around!","I will not be bullied by you!","You must leave now! You are not welcome!","You better watch out.","Your threats do not scare me!"];
				_result = [_responses call BIS_fnc_selectRandom, []];
			};
		};
	};

	case "SorryForBother": {
		if (_hostile) then {
			if (75 > (([_personality,"Aggressiveness"] call ALiVE_fnc_hashGet) + ([_personality,"Patience"] call ALiVE_fnc_hashGet)) * .65) then {
				//-- Non-Aggressive
				_responses = ["It will take more than that for me to forgive you","Thank you.","Don't worry about it.","It is ok.","You just remember that for next time we meet.","We can all be bothersome at times."];
				_result = [_responses call BIS_fnc_selectRandom, []];
			} else {
				//-- Aggressive
				_responses = ["Your apologies mean nothing!","Don't waste your time apologizing.","Do you really expect that to fix the situation?","Your apologies insult me!","I will not forgive you so easily."];
				_result = [_responses call BIS_fnc_selectRandom, []];
			};
		} else {
			if (random 100 > [_personality,"Patience"] call ALiVE_fnc_hashGet) then {
				//-- Doesn't like being bothered
				_responses = ["Think next time.","Learn to stop talking.","You need to learn manners.","You will not be favored here with that arrogant attitude.","You just remember that for next time we meet."];
				_result = [_responses call BIS_fnc_selectRandom, []];
			} else {
				//-- Doesn't mind
				_responses = ["Thank you","It is quite alright.","No worries brother.","You have not bothered me.","You are always welcome here.","Do not worry about it."];
				_result = [_responses call BIS_fnc_selectRandom, []];
			};
		};
	};

	case "WatchOutThreat": {
		if (random 100 > [_personality,"Bravery"] call ALiVE_fnc_hashGet) then {
			//-- Succumbs to threat
			_responses = ["My apologies.","I am sorry.","I'm sorry, I shouldn't have said that.","Please forgive me, I do not want to cause trouble.","Oh, please forgive me.","You have my apologies."];
			_result = [_responses call BIS_fnc_selectRandom, []];
		} else {
			//-- Defiant to threat
			if (random 100 > [_personality,"Aggressiveness"] call ALiVE_fnc_hashGet) then {
				//-- Non-Aggressive
				_responses = ["Your words bring hosility.","Go bully someone else.","I will not surrender to you.","I refuse to be spoken to like that.","Your threats do not scare me."];
				_result = [_responses call BIS_fnc_selectRandom, []];
			} else {
				//-- Aggressive
				_responses = ["Do not talk to me like that!","I will not be bullied by you!","You insult me? Leave now!","You better watch out.","Your threats do not scare me!"];
				_result = [_responses call BIS_fnc_selectRandom, []];
			};
		};
	};

	//-- Where do you live
	case "Home": {
		if (_hostile) then {
			if (random 100 > [_personality,"Aggressiveness"] call ALiVE_fnc_hashGet) then {
				//-- Aggressive
				_responses = [".","."];

				_result = _responses call BIS_fnc_selectRandom;
				_result = [_result, []];
			} else {
				//-- Non Aggressive
				_responses = [".","."];

				_result = _responses call BIS_fnc_selectRandom;
				_result = [_result, []];
			};
		} else {
			if (random 100 > [_personality,"Indecisiveness"] call ALiVE_fnc_hashGet) then {
				//-- Gives answer
				_responses = ["I will show you!","Allow me to show you.","I will give you it's location.","It is not too far from here.","It is over there."];

				_result = format ["%1 (%2's home has been marked on the map).",_responses call BIS_fnc_selectRandom,_civName];
				_result = [_result, []];

				//-- Create marker on home
				_pos = [_civInfo,"HomePosition"] call ALiVE_fnc_hashGet;
				_marker = createMarkerLocal [str _pos,_pos];
				_marker setMarkerShapeLocal "ICON";
				_marker setMarkerTypeLocal "marker";
				_marker setMarkerColorLocal "ColorCivilian";
			} else {
				//-- Hesitant
				_responses = ["I don't know if I can tell you that..","That is very personal information.","I do not wish to give that type of information out.","I am sorry but I cannot tell you that.","Please, no personal questions."];

				_result = _responses call BIS_fnc_selectRandom;
				_result = [_result, [["Would you reconsider?","['PleaseReconsider',1.5]"]]];

				[_logic,"ReconsiderQuestion",[_operation,_arguments]] call ALiVE_fnc_hashSet;
			};
		};
	};

	case "PleaseReconsider": {
		if (random 100 > ([_personality,"Indecisiveness"] call ALiVE_fnc_hashGet + 20)) then {
			//-- Reconsider question
			_questionData = [_logic,"ReconsiderQuestion"] call ALiVE_fnc_hashGet;
			[_logic,(_questionData select 0),(_questionData select 1)] call SpyderAddons_fnc_getResponse;
		} else {
			if (random 100 > [_personality,"Aggressiveness"] call ALiVE_fnc_hashGet) then {
				//-- Non aggressive
				_responses = ["Please, do not pressure me.","I do not enjoy being pressured.","No, sorry.","I will not reconsider that question.","I have given you your answer already."];

				_result = _responses call BIS_fnc_selectRandom;
				_result = [_result, []];
			} else {
				//-- Aggressive
				_responses = ["I do not think so.","Do not push it.","I have given you your answer already.","No, means no.","What does it take to get rid of you?","If I wanted to tell you, I would have told you"];

				_result = _responses call BIS_fnc_selectRandom;
				_result = [_result, []];
			};
		};
	};

};

//-- Return result if any exists
if (!isNil "_result") then {_result} else {nil};