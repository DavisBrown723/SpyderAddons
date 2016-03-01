#include <\x\spyderaddons\addons\civ_interact\script_component.hpp>
SCRIPT(personalityHandler);

/* ----------------------------------------------------------------------------
Function: SpyderAddons_fnc_personalityHandler

Description:
Main handler for civilian personalities

Parameters:
String - Operation
Array - Arguments

Returns:
Any - Result of the operation

Examples:
(begin example)
[_logic,_operation, _arguments] call SpyderAddons_fnc_personalityHandler
(end)

See Also:
- nil

Author: SpyderBlack723

Peer Reviewed:
nil
---------------------------------------------------------------------------- */

private ["_result"];
params [
	["_logic", objNull],
	["_operation", ""],
	["_arguments", []]
];

//-- Define function shortcuts
#define MAINCLASS 		SpyderAddons_fnc_personalityHandler

switch (_operation) do {

	case "getPersonality": {
		_civ = _arguments;
		_civID = _civ getVariable ["agentID", ""];

		if (_civID == "") exitWith {};

		_civProfile = [ALIVE_agentHandler, "getAgent", _civID] call ALIVE_fnc_agentHandler;
		_result = [_civProfile,"Personality", ""] call ALiVE_fnc_hashGet;

		if (typename _result == "STRING") then {
			_result = [_logic,"create", _civ] call MAINCLASS;
			[_civProfile,"Personality", _result] call ALiVE_fnc_hashSet;
		};
	};

	case "create": {
		//_hostility = [nil,"generateHostilityValue"] call MAINCLASS;
		_bravery = [nil,"generateBraveryValue"] call MAINCLASS;
		_aggressiveness = [nil,"generateAggressivenessValue", [_bravery,_indecisiveness]] call MAINCLASS;
		_patience = [nil,"generatePatienceValue", _aggressiveness] call MAINCLASS;
		_indecisiveness = [nil,"generateIndecisivenessValue", _bravery] call MAINCLASS;

		_result = [] call ALiVE_fnc_hashCreate;
		[_result,"Bravery", _bravery] call ALiVE_fnc_hashSet;
		[_result,"Aggressiveness", _aggressiveness] call ALiVE_fnc_hashSet;
		[_result,"Patience", _patience] call ALiVE_fnc_hashSet;
		[_result,"Indecisiveness", _indecisiveness] call ALiVE_fnc_hashSet;

		_forces = [SpyderAddons_civilianInteraction,"forces"] call SpyderAddons_fnc_civilianInteraction;
		_forceAlignments = [] call ALiVE_fnc_hashCreate;
		{
			[_forceAlignments,(_x select 2) select 0, (_x select 2) select 2] call ALiVE_fnc_hashSet;
		} foreach _forces;

		[_result,"ForceAlignments", _forceAlignments] call ALiVE_fnc_hashSet;
	};

	case "generateBraveryValue": {
		//-- Average over 10,000 iterations: 24
		_result = (ceil random 100) - (floor random 70);
		if !([_result,[0,100]] call SpyderAddons_fnc_numberInBounds) then {
			_result = [_result,[0,100]] call SpyderAddons_fnc_getClosestNumber;
		};
	};

	case "generatePatienceValue": {
		__aggressiveness = _arguments;

		//-- Average over 10,000 iterations: 59
		_result = ((ceil random 100) + 30) - (ceil random 20 + (ceil random 20));
		if !([_result,[0,100]] call SpyderAddons_fnc_numberInBounds) then {
			_result = [_result,[0,100]] call SpyderAddons_fnc_getClosestNumber;
		};
	};

	case "generateAggressivenessValue": {
		_arguments params ["_bravery","_indecisiveness"];

		//-- Average over 10,000 iterations: 34
		_result = ((ceil random 100) + 15) - (ceil random 30 + (ceil random 30));
		if !([_result,[0,100]] call SpyderAddons_fnc_numberInBounds) then {
			_result = [_result,[0,100]] call SpyderAddons_fnc_getClosestNumber;
		};
	};

	case "generateIndecisivenessValue": {
		_bravery = _arguments;

		//-- Average over 10,000 iterations: 59
		_result = ((ceil random 100) + 30) - (ceil random 20 + (ceil random 20));
		if !([_result,[0,100]] call SpyderAddons_fnc_numberInBounds) then {
			_result = [_result,[0,100]] call SpyderAddons_fnc_getClosestNumber;
		};
	};

	case "positivity": {
		if (typename _arguments == "OBJECT") then {
			_civ = _arguments;
			_civPersonality = [_logic,"getPersonality"] call MAINCLASS;
			_return = [_logic,"Positivity"] call ALiVE_fnc_hashGet;
		} else {
			_arguments params ["_civ","_value"];
			[_logic,"Positivity", ([_logic,"Positivity"] call ALiVE_fnc_hashGet) + _value] call ALiVE_fnc_hashSet;
		};
	};

	case "negativity": {
		if (typename _arguments == "OBJECT") then {
			_civ = _arguments;
			_civPersonality = [_logic,"getPersonality"] call MAINCLASS;
			_return = [_logic,"Negativity"] call ALiVE_fnc_hashGet;
		} else {
			_arguments params ["_civ","_value"];
			[_logic,"Negativity", ([_logic,"Negativity"] call ALiVE_fnc_hashGet) + _value] call ALiVE_fnc_hashSet;
		};
	};

	case "bravery": {
		if (typename _arguments == "OBJECT") then {
			_civ = _arguments;
			_civPersonality = [_logic,"getPersonality"] call MAINCLASS;
			_return = [_logic,"Bravery"] call ALiVE_fnc_hashGet;
		} else {
			_arguments params ["_civ","_value"];
			[_logic,"Bravery", ([_logic,"Bravery"] call ALiVE_fnc_hashGet) + _value] call ALiVE_fnc_hashSet;
		};
	};

	case "indecisiveness": {
		if (typename _arguments == "OBJECT") then {
			_civ = _arguments;
			_civPersonality = [_logic,"getPersonality"] call MAINCLASS;
			_return = [_logic,"Indecisiveness"] call ALiVE_fnc_hashGet;
		} else {
			_arguments params ["_civ","_value"];
			[_logic,"Indecisiveness", ([_logic,"Indecisiveness"] call ALiVE_fnc_hashGet) + _value] call ALiVE_fnc_hashSet;
		};
	};

	case "aggressiveness": {
		if (typename _arguments == "OBJECT") then {
			_civ = _arguments;
			_civPersonality = [_logic,"getPersonality"] call MAINCLASS;
			_return = [_logic,"Aggressiveness"] call ALiVE_fnc_hashGet;
		} else {
			_arguments params ["_civ","_value"];
			[_logic,"Aggressiveness", ([_logic,"Aggressiveness"] call ALiVE_fnc_hashGet) + _value] call ALiVE_fnc_hashSet;
		};
	};

	case "getForceAlignment": {
		_arguments params ["_personality","_force"];
		_sideAlignments = [_personality,"SideAlignments"] call ALiVE_fnc_hashGet;
		_return = [_sideAlignments,_force] call ALiVE_fnc_hashGet;
	};

	case "savePersonality": {
		if !(isServer) exitWith {[_logic,_operation,_arguments] remoteExecCall [QUOTE(MAINCLASS),2]};
		_arguments params ["_civ","_personality"];

		_civID = _civ getVariable ["agentID", ""];
		if (_civID == "") exitWith {};

		_civProfile = [ALIVE_agentHandler, "getAgent", _civID] call ALIVE_fnc_agentHandler;
		[_civProfile,"Personality", _personality] call ALiVE_fnc_hashSet;
	};

};

//-- Return result if any exists
if (!isNil "_result") then {_result} else {nil};