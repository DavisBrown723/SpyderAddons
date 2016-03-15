#include <\x\spyderaddons\addons\mil_insurgency\script_component.hpp>
SCRIPT(insurgency);

/* ----------------------------------------------------------------------------
Function: SpyderAddons_fnc_insurgency

Description:
Main handler for insurgency

Parameters:
String - Operation
Array - Arguments

Returns:
Any - Result of the operation

Examples:
(begin example)
(end)

See Also:
- nil

Author: SpyderBlack723

Peer Reviewed:
nil
---------------------------------------------------------------------------- */

params [
	["_logic", objNull],
	["_operation", ""],
	["_arguments", []]
];
private ["_result"];

//-- Define control ID's
#define MAINCLASS SpyderAddons_fnc_insurgency
#define COMMANDBOARD SpyderAddons_fnc_commandBoard

/*
Event Tags
OPCOM_RESERVE = HQ,Depot,Roadblocks
OPCOM_CAPTURE = Assault
OPCOM_RECON = Ambush
OPCOM_DEFEND = Retreat
OPCOM_TERRORIZE = Factory,IED,Suicide,Sabotage
*/

switch (_operation) do {

	case "init": {
		_syncedUnits = _arguments;

		//-- Make sure ALiVE is running
		if ((hasInterface) and {!(isClass (configfile >> "CfgVehicles" >> "ALiVE_require"))}) exitWith {
			waitUntil {sleep 1; time > 5};
			["Insurgency"] call SpyderAddons_fnc_openRequiresAlive;
		};
		
		//Only one init per instance is allowed
		if !(isNil {_logic getVariable "initGlobal"}) exitwith {["[SpyderAddons -  Mil Insurgency]:Only one init process per instance allowed, Exiting..."] call SpyderAddons_fnc_log};

		//-- Start init
		_logic setVariable ["initGlobal", false];

		//-- Get module parameters
		_debug = call compile (_logic getVariable "Debug");
		_factions = [_logic getVariable "InsurgentFactions"] call SpyderAddons_fnc_getModuleArray;
		_sides = [];
		{
			_sides pushBack (_x call ALiVE_fnc_factionSide);
		} forEach _factions;

		if (isServer) then {
			if (isNil "SpyderAddons_CommandBoard_Handler") then {
				SpyderAddons_CommandBoard_Handler = [nil,"create"] call COMMANDBOARD;
				[SpyderAddons_CommandBoard_Handler, "init"] call COMMANDBOARD;
				[SpyderAddons_CommandBoard_Handler, "debug", _debug] call COMMANDBOARD;
				[SpyderAddons_CommandBoard_Handler, "sides", _sides] call COMMANDBOARD;
			};
		};
		if (hasInterface) then {
			_logic setVariable ["startupComplete", true];
		};
	};

	case "createHQ": {
		if (!isServer) exitWith {_this remoteExecCall [QUOTE(MAINCLASS), 2]};
		_player = _arguments;

		//-- Get nearest building
		_HQ = nearestBuilding _player;
		if (_HQ getVariable "alive_mil_opcom_furnitured") exitWith {hint "Building is already an installation"};
		if !(alive _HQ) exitWith {hint "building is dead"};

		_faction = faction _player;

		//-- Get nearest objective
		_opcom = ([_faction] call SpyderAddons_fnc_getOpcoms) select 0;
		_objectives = [_opcom,"objectives"] call ALiVE_fnc_hashGet;
		_objectives = [_objectives,[getPos _player],{_Input0 distance2D ([_x, "center"] call ALiVE_fnc_HashGet)},"ASCEND"] call BIS_fnc_sortBy;
		_objective = _objectives select 0;

		//-- Check if objective has an HQ or will shortly
		if !(([_objective, "HQ", []] call ALiVE_fnc_hashGet) isEqualTo []) exitWith {hint "This objective has a recruitment HQ"};
		if ("recruit" in ([_objective, "actionsFulfilled", []] call ALiVE_fnc_hashGet)) exitWith {hint "Insurgents are already moving to setup an HQ here"};

		_id = [_objective, "objectiveID"] call ALiVE_fnc_hashGet;
		_pos = [_objective,"center"] call ALiVE_fnc_hashGet;
		_size = [_objective,"size"] call ALiVE_fnc_hashGet;

		//-- Spawn HQ
		[_HQ,_id] call ALiVE_fnc_INS_spawnHQ;

		//-- Spawn CQB
		_CQB = ALiVE_CQB getvariable ["instances",[]];
		[getPosATL _HQ,_size,_CQB] spawn ALiVE_fnc_addCQBpositions;	//-- Nearby CQB
		{[_x,"addHouse",_HQ] call ALiVE_fnc_CQB} foreach _CQB;		//-- Virtual house guards

		//-- Set HQ to objective
		[_objective,"HQ",[[],"convertObject",_HQ] call ALiVE_fnc_OPCOM] call ALiVE_fnc_HashSet;
		_actionsCompleted = [_objective,"actionsFulfilled", []] call ALiVE_fnc_hashGet;
		_actionsCompleted pushBack ("recruit");
		_actions = [_objective,"actionsFulfilled", _actionsCompleted] call ALiVE_fnc_hashSet;

		//-- Add IED command on nearby civilians
		_movePos = getposATL _HQ;
		_housePositions = [_movePos,15] call ALIVE_fnc_findIndoorHousePositions;
		_movePos = if (count _housePositions > 0) then {selectRandom _housePositions} else {_movePos};
		_agents = [_objective, "agents",[]] call ALiVE_fnc_hashGet;
		{
			private ["_agent"];
			_agent = [ALiVE_AgentHandler,"getAgent",_x] call ALiVE_fnc_AgentHandler;

			if (!isNil "_agent" and {_forEachIndex < 3}) then {
				[_agent, "setActiveCommand", ["ALIVE_fnc_cc_getWeapons", "managed", [_movePos]]] call ALIVE_fnc_civilianAgent;
			};
		} forEach _agents;

		//-- Record events
		_side = _faction call ALiVE_fnc_factionSide;
		_event = ["OPCOM_RESERVE",[_side,_objective],"OPCOM"] call ALIVE_fnc_event;
		_eventID = [ALIVE_eventLog, "addEvent",_event] call ALIVE_fnc_eventLog;

		_pos = getPosATL _HQ;
		_event = ["SA_Insurgency",["HQ",_pos,_objective],(name _player),"INSTALLATION_CREATED"] call ALIVE_fnc_event;
		_eventID = [ALIVE_eventLog, "addEvent",_event] call ALIVE_fnc_eventLog;

		//-- Start Recruitment
		["recruitment", [_pos,_size,_faction,_agents,_HQ]] spawn MAINCLASS;
	};

	case "createDepot": {
		if (!isServer) exitWith {_this remoteExecCall [QUOTE(MAINCLASS), 2]};
		_player = _arguments;

		//-- Get nearest building
		_depot = nearestBuilding _player;
		if (_depot getVariable "alive_mil_opcom_furnitured") exitWith {hint "Building is already an installation"};
		if !(alive _depot) exitWith {hint "building is dead"};

		_faction = faction _player;

		//-- Get nearest objective
		_opcom = ([_faction] call SpyderAddons_fnc_getOpcoms) select 0;
		_objectives = [_opcom,"objectives"] call ALiVE_fnc_hashGet;
		_objectives = [_objectives,[getPos _player],{_Input0 distance2D ([_x, "center"] call ALiVE_fnc_HashGet)},"ASCEND"] call BIS_fnc_sortBy;
		_objective = _objectives select 0;

		//-- Check if objective has an HQ or will shortly
		if !(([_objective, "depot", []] call ALiVE_fnc_hashGet) isEqualTo []) exitWith {hint "This objective already has a weapons depot"};
		if ("depot" in ([_objective, "actionsFulfilled", []] call ALiVE_fnc_hashGet)) exitWith {hint "Insurgents are already moving to setup a weapons depot"};

		_id = [_objective, "objectiveID"] call ALiVE_fnc_hashGet;
		_pos = [_objective,"center"] call ALiVE_fnc_hashGet;
		_size = [_objective,"size"] call ALiVE_fnc_hashGet;

		[_depot,_id] call ALiVE_fnc_INS_spawnDepot;

		//-- Spawn CQB
		_CQB = ALiVE_CQB getvariable ["instances",[]];
		[getPosATL _depot,_size,_CQB] spawn ALiVE_fnc_addCQBpositions;		//-- Nearby CQB
		{[_x,"addHouse",_depot] call ALiVE_fnc_CQB} foreach _CQB;		//-- Virtual house guards

		//-- Set HQ to objective
		[_objective,"depot",[[],"convertObject",_depot] call ALiVE_fnc_OPCOM] call ALiVE_fnc_HashSet;
		_actionsCompleted = [_objective,"actionsFulfilled", []] call ALiVE_fnc_hashGet;
		_actionsCompleted pushBack ("depot");
		_actions = [_objective,"actionsFulfilled", _actionsCompleted] call ALiVE_fnc_hashSet;

		//-- Add get weapons command on nearby civilians
		_movePos = getposATL _depot;
		_housePositions = [_movePos,15] call ALIVE_fnc_findIndoorHousePositions;
		_movePos = if (count _housePositions > 0) then {selectRandom _housePositions} else {_movePos};
		_agents = [_objective, "agents",[]] call ALiVE_fnc_hashGet;
		{
			private ["_agent"];
			_agent = [ALiVE_AgentHandler,"getAgent",_x] call ALiVE_fnc_AgentHandler;

			if (!isNil "_agent" and {_forEachIndex < 3}) then {
				[_agent, "setActiveCommand", ["ALIVE_fnc_cc_getWeapons", "managed", [_movePos]]] call ALIVE_fnc_civilianAgent;
			};
		} forEach _agents;

		//-- Record events
		_side = _faction call ALiVE_fnc_factionSide;
		_event = ["OPCOM_RESERVE",[_side,_objective],"OPCOM"] call ALIVE_fnc_event;
		_eventID = [ALIVE_eventLog, "addEvent",_event] call ALIVE_fnc_eventLog;

		_pos = getPosATL _depot;
		_event = ["SA_Insurgency",["Depot",_pos,_objective],(name _player),"INSTALLATION_CREATED"] call ALIVE_fnc_event;
		_eventID = [ALIVE_eventLog, "addEvent",_event] call ALIVE_fnc_eventLog;

		//-- Update hostility
		_sidesEnemy = [_opcom, "sidesenemy"] call ALiVE_fnc_hashGet;
		_sidesFriendly = [_opcom, "sidesfriendly"] call ALiVE_fnc_hashGet;
		[_pos,_sidesEnemy, 20] call ALiVE_fnc_updateSectorHostility;
		[_pos,_sidesFriendly, -20] call ALiVE_fnc_updateSectorHostility;
	};

	case "createFactory": {
		if (!isServer) exitWith {_this remoteExecCall [QUOTE(MAINCLASS), 2]};
		_player = _arguments;

		//-- Get nearest building
		_factory = nearestBuilding _player;
		if (_factory getVariable "alive_mil_opcom_furnitured") exitWith {hint "Building is already an installation"};
		if !(alive _factory) exitWith {hint "building is dead"};

		_faction = faction _player;

		//-- Get nearest objective
		_opcom = ([_faction] call SpyderAddons_fnc_getOpcoms) select 0;
		_objectives = [_opcom,"objectives"] call ALiVE_fnc_hashGet;
		_objectives = [_objectives,[getPos _player],{_Input0 distance2D ([_x, "center"] call ALiVE_fnc_HashGet)},"ASCEND"] call BIS_fnc_sortBy;
		_objective = _objectives select 0;

		//-- Check if objective has an HQ or will shortly
		if !(([_objective, "factory", []] call ALiVE_fnc_hashGet) isEqualTo []) exitWith {hint "This objective already has an IED factory"};
		if ("factory" in ([_objective, "actionsFulfilled", []] call ALiVE_fnc_hashGet)) exitWith {hint "Insurgents are already moving to setup an IED factory"};

		_id = [_objective, "objectiveID"] call ALiVE_fnc_hashGet;
		_pos = [_objective,"center"] call ALiVE_fnc_hashGet;
		_size = [_objective,"size"] call ALiVE_fnc_hashGet;

		[_factory,_id] call ALiVE_fnc_INS_spawnIEDfactory;

		//-- Spawn CQB
		_CQB = ALiVE_CQB getvariable ["instances",[]];
		[getPosATL _factory,_size,_CQB] spawn ALiVE_fnc_addCQBpositions;	//-- Nearby CQB
		{[_x,"addHouse",_factory] call ALiVE_fnc_CQB} foreach _CQB;		//-- Virtual house guards

		//-- Set HQ to objective
		[_objective,"factory",[[],"convertObject",_factory] call ALiVE_fnc_OPCOM] call ALiVE_fnc_HashSet;
		_actionsCompleted = [_objective,"actionsFulfilled", []] call ALiVE_fnc_hashGet;
		_actionsCompleted pushBack ("factory");
		_actions = [_objective,"actionsFulfilled", _actionsCompleted] call ALiVE_fnc_hashSet;

		//-- Add IED command on nearby civilians
		_movePos = getposATL _factory;
		_housePositions = [_movePos,15] call ALIVE_fnc_findIndoorHousePositions;
		_movePos = if (count _housePositions > 0) then {selectRandom _housePositions} else {_movePos};
		_agents = [_objective, "agents",[]] call ALiVE_fnc_hashGet;
		{
			private ["_agent"];
			_agent = [ALiVE_AgentHandler,"getAgent",_x] call ALiVE_fnc_AgentHandler;

			if (!isnil "_agent" and {([_agent,"type",""] call ALiVE_fnc_HashGet) == "agent"}) exitwith {
				[_agent, "setActiveCommand", ["ALIVE_fnc_cc_getWeapons", "managed", [_movePos]]] call ALIVE_fnc_civilianAgent;
			};
		} forEach _agents;

		//-- Record events
		_side = _faction call ALiVE_fnc_factionSide;
		_event = ["OPCOM_TERRORIZE",[_side,_objective],"OPCOM"] call ALIVE_fnc_event;
		_eventID = [ALIVE_eventLog, "addEvent",_event] call ALIVE_fnc_eventLog;

		_pos = getPosATL _factory;
		_event = ["SA_Insurgency",["Factory",_pos,_objective],(name _player),"INSTALLATION_CREATED"] call ALIVE_fnc_event;
		_eventID = [ALIVE_eventLog, "addEvent",_event] call ALIVE_fnc_eventLog;

		//-- Update hostility
		_sidesEnemy = [_opcom, "sidesenemy"] call ALiVE_fnc_hashGet;
		_sidesFriendly = [_opcom, "sidesfriendly"] call ALiVE_fnc_hashGet;
		[_pos,_sidesEnemy, 20] call ALiVE_fnc_updateSectorHostility;
		[_pos,_sidesFriendly, -20] call ALiVE_fnc_updateSectorHostility;
	};
/*
This should be changed to "orderRoadblocks". There can only be one roadblock command per objective so players creating roadblocks one by one would hinder the insurgents overall effort by reducing total roadblock count.
	case "createRoadblocks": {
		if (!isServer) exitWith {_this remoteExecCall [QUOTE(MAINCLASS), 2]};
		_player = _arguments;
		_faction = faction _player;

		//-- Get nearest objective
		_opcom = ([_faction] call SpyderAddons_fnc_getOpcoms) select 0;
		_objectives = [_opcom,"objectives"] call ALiVE_fnc_hashGet;
		_objectives = [_objectives,[getPos _player],{_Input0 distance2D ([_x, "center"] call ALiVE_fnc_HashGet)},"ASCEND"] call BIS_fnc_sortBy;
		_objective = _objectives select 0;

		_id = [_objective, "objectiveID"] call ALiVE_fnc_hashGet;
		_center = [_objective,"center"] call ALiVE_fnc_hashGet;
		_size = [_objective,"size"] call ALiVE_fnc_hashGet;

		_sideEnemy = selectRandom ([_opcom, "sidesenemy"] call ALiVE_fnc_hashGet);
		_agents = [_objective, "agents",[]] call ALiVE_fnc_hashGet;
		{
			private ["_agent"];
			_agent = [ALiVE_AgentHandler,"getAgent",_x] call ALiVE_fnc_AgentHandler;

			if (!isnil "_agent" && {([_agent,"type",""] call ALiVE_fnc_HashGet) == "agent"}) exitwith {
				[_agent, "setActiveCommand", ["ALIVE_fnc_cc_rogueTarget", "managed", [_sideEnemy]]] call ALIVE_fnc_civilianAgent;
			};
		} forEach _agents;

		//-- Spawn CQB
		_CQB = ALiVE_CQB getvariable ["instances",[]];
		[_center,_size,_CQB] spawn ALiVE_fnc_addCQBpositions;		//-- Nearby CQB

		// Spawn roadblock
		 [_pos, _size, ceil(_size/200), false] call ALiVE_fnc_createRoadblock;
		[_objective,"roadblocks",[[],"convertObject",_pos nearestObject ""] call ALiVE_fnc_OPCOM] call ALiVE_fnc_HashSet;

		//-- Record event
		_event = ["OPCOM_RESERVE",[_side,_objective],"OPCOM"] call ALIVE_fnc_event;
		_eventID = [ALIVE_eventLog, "addEvent",_event] call ALIVE_fnc_eventLog;

		//-- Update hostility
		_sidesFriendly = [_opcom, "sidesfriendly"] call ALiVE_fnc_hashGet;
		[_pos,_sidesEnemy, 20] call ALiVE_fnc_updateSectorHostility;
		[_pos,_sidesFriendly, -20] call ALiVE_fnc_updateSectorHostility;
	};
*/
	case "recruitment": {
		private ["_recruitCount","_recruits"];
		_arguments params ["_pos","_size","_faction","_agents","_HQ"];

		_opcom = ([_faction] call SpyderAddons_fnc_getOpcoms) select 0;
		_sidesEnemy = [_opcom, "sidesenemy"] call ALiVE_fnc_hashGet;
		_sidesFriendly = [_opcom, "sidesfriendly"] call ALiVE_fnc_hashGet;
		_recruited = 0;

		//-- Get maximum recruit count
		_recruitCount = count _agents;
		if (_recruitCount > 5) then {_recruitCount = 5};

		//-- Start recruiting loop
		for "_i" from 1 to _recruitCount do {

			//-- Exit if HQ is destroyed
			if !(alive _HQ) exitwith {};

			//-- Recruit group
			_group = ["Infantry",_faction] call ALIVE_fnc_configGetRandomGroup;
			_recruits = [_group, ([_pos,_size] call CBA_fnc_RandPos), (random 360), true, _faction] call ALIVE_fnc_createProfilesFromGroupConfig;
			{
				[_x, "setActiveCommand", ["ALIVE_fnc_ambientMovement","spawn",[_size + 350,"SAFE",[0,0,0]]]] call ALIVE_fnc_profileEntity;
			} foreach _recruits;

			//-- Update hostility
			[_pos,_sidesEnemy, 10] call ALiVE_fnc_updateSectorHostility;
			[_pos,_sidesFriendly, -10] call ALiVE_fnc_updateSectorHostility;

			//-- Update recruit count
			_recruited = _recruited + 1;

			//-- Record event
			_event = ["SA_Insurgency",[_group,_pos,_HQ],(name _player),"HQ_RECRUIT"] call ALIVE_fnc_event;
			_eventID = [ALIVE_eventLog, "addEvent",_event] call ALIVE_fnc_eventLog;

			//-- Recruitment delay
			sleep (1200 + random 600);
		};
	};

};

//-- Return result if any exists
if (!isNil "_result") then {_result} else {nil};