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

	case "create": {
		_positivity = ((ceil random 100) - (ceil random 100)) + 20;
		_negativity = ceil ();
		_bravery = ceil ();
		_indecisiveness = 
		_aggressiveness = 

		_result = [] call ALiVE_fnc_hashCreate;
		[_result,"Positivity", _positivity] call ALiVE_fnc_hashSet;
		[_result,"Negativity, _negativity] call ALiVE_fnc_hashSet;
		[_result,"Bravery", _bravery] call ALiVE_fnc_hashSet;
		[_result,"Indecisiveness", _indecisiveness] call ALiVE_fnc_hashSet;
		[_result,"Aggressiveness", _aggressiveness] call ALiVE_fnc_hashSet;

		_forces = [SpyderAddons_civInteract,"forces"] call SpyderAddons_fnc_civInteract;
		_forceAlignments = [] call ALiVE_fnc_hashCreate;
		{
			[_forceAlignments,(_x select 0), _x select 2]] call ALiVE_fnc_hashSet;
		} foreach _forces;

		[_result,"ForceAlignments", _forceAlignments] call ALiVE_fnc_hashSet;
	};

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
		_arguments params ["_civ","_force"];
		_personality = [_logic,"getPersonality", _civ] call MAINCLASS;
		_sideAlignments = [_personality,"SideAlignments"] call ALiVE_fnc_hashGet;
		_return = [_sideAlignments,_force] call ALiVE_fnc_hashGet;
	};

	

};

//-- Return result if any exists
if (!isNil "_result") then {_result} else {nil};