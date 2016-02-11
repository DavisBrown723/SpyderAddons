#include <\x\spyderaddons\addons\civ_interact\script_component.hpp>
SCRIPT(civInteract);

/* ----------------------------------------------------------------------------
Function: SpyderAddons_fnc_civInteract

Description:
Main handler for civilian interraction

Parameters:
String - Operation
Array - Arguments

Returns:
Any - Result of the operation

Examples:
(begin example)
[_logic,_operation, _arguments] call SpyderAddons_fnc_civInteract;
(end)

See Also:
- nil

Author: SpyderBlack723

Peer Reviewed:
nil
---------------------------------------------------------------------------- */

disableSerialization;
private ["_result"];
params [
	["_logic", objNull],
	["_operation", ""],
	["_arguments", []]
];

//-- Define function shortcuts
#define MAINCLASS 			SpyderAddons_fnc_civInteract
#define INVENTORYHANDLER 		SpyderAddons_fnc_inventoryHandler

//-- Define control ID's
#define CIVINTERACT_DISPLAY 		(findDisplay 923)
#define CIVINTERACT_CIVNAME 		(CIVINTERACT_DISPLAY displayCtrl 9236)
#define CIVINTERACT_DETAIN 		(CIVINTERACT_DISPLAY displayCtrl 92311)
#define CIVINTERACT_QUESTIONLIST 		(CIVINTERACT_DISPLAY displayCtrl 9234)
#define CIVINTERACT_RESPONSELIST 		(CIVINTERACT_DISPLAY displayCtrl 9239)

switch (_operation) do {

	case "create": {
		_result = [] call ALiVE_fnc_hashCreate;
	};

	//-- Create logic on all localities
	case "init": {
		//-- Make sure ALiVE is running
		if ((hasInterface) and {!(isClass (configfile >> "CfgVehicles" >> "ALiVE_require"))}) exitWith {
			waitUntil {sleep 1; time > 5};
			["Civilian Interaction"] call SpyderAddons_fnc_openRequiresAlive;
		};

		if (isNil QMOD(civInteract)) then {
			//-- Get settings
			_factionEnemy = _logic getVariable "enemyFaction";
			_hostilityChance = call compile (_logic getVariable "HostilityChance");
			_irritatedChance = call compile (_logic getVariable "IrritatedChance");
			_answerChance = call compile (_logic getVariable "AnswerChance");

			//-- Create interact handler object
			MOD(civInteract) = [nil,"create"] call MAINCLASS;
			[MOD(civInteract),"InsurgentFaction", _factionEnemy] call ALiVE_fnc_hashSet;
			[MOD(civInteract),"Hostilitychance", _hostilityChance] call ALiVE_fnc_hashSet;
			[MOD(civInteract),"IrritatedChance", _irritatedChance] call ALiVE_fnc_hashSet;
			[MOD(civInteract),"AnswerChance", _answerChance] call ALiVE_fnc_hashSet;
		};
	};

	case "openMenu": {
		_civ = _arguments;

		//-- Civ attacks if armed
		if (count (weapons _civ) > 0) exitWith {[nil,"attackUnit", [_civ,player]] call MAINCLASS};

		//-- Stop civilian
		[[[_civ],{(_this select 0) disableAI "MOVE"}],"BIS_fnc_spawn",_civ,false,true] call BIS_fnc_MP;

		[_logic, "Civ", _civ] call ALiVE_fnc_hashSet;

		CreateDialog "Civ_Interact";
	};

	case "onLoad": {
		_civ = [_logic,"Civ"] call ALiVE_fnc_hashGet;

		//-- onLoad call for inventory handler
		[_logic,"mainMenuOpened"] spawn INVENTORYHANDLER;

		//-- Display loading
		CIVINTERACT_QUESTIONLIST lbAdd "Loading . . .";

		//-- Retrieve data
		[nil,"getData", [player,_civ]] remoteExecCall [QUOTE(MAINCLASS),2];

		if (_civ getVariable "detained") then {
			CIVINTERACT_DETAIN ctrlSetText "Release";
		};

		//-- Build question list
		CIVINTERACT_QUESTIONLIST lbAdd "How are you?";
		CIVINTERACT_QUESTIONLIST lbSetData [0, "HowAreYou"];

		CIVINTERACT_QUESTIONLIST lbAdd "Where do you live?";
		CIVINTERACT_QUESTIONLIST lbSetData [0, "Home"];

		CIVINTERACT_QUESTIONLIST lbAdd "What town you do live in";
		CIVINTERACT_QUESTIONLIST lbSetData [1, "Town"];

		CIVINTERACT_QUESTIONLIST lbAdd "Have you seen any IED's lately?";
		CIVINTERACT_QUESTIONLIST lbSetData [2, "IEDs"];

		CIVINTERACT_QUESTIONLIST lbAdd "Have you seen any insurgent activity lately?";
		CIVINTERACT_QUESTIONLIST lbSetData [3, "Insurgents"];

		CIVINTERACT_QUESTIONLIST lbAdd "Do you know the location of any insurgent hideouts?";
		CIVINTERACT_QUESTIONLIST lbSetData [4, "Hideouts"];

		CIVINTERACT_QUESTIONLIST lbAdd "Have you seen any strange behavior lately?";
		CIVINTERACT_QUESTIONLIST lbSetData [5, "StrangeBehavior"];

		CIVINTERACT_QUESTIONLIST lbAdd "Do you support us?";
		CIVINTERACT_QUESTIONLIST lbSetData [6, "Opinion"];

		CIVINTERACT_QUESTIONLIST lbAdd "What is the opinion of our forces in this area?";
		CIVINTERACT_QUESTIONLIST lbSetData [7, "TownOpinion"];

		//-- Add onSel EH to question list
		CIVINTERACT_QUESTIONLIST ctrlAddEventHandler ["LBSelChanged","
			params ['_control','_index'];
			_question = _control lbData _index;
			[SpyderAddons_civInteract,_question] call SpyderAddons_fnc_questionHandler;
		"];

		//-- Create progress bar --> doesn't like working when created via main.hpp (fix) --> This needs to be created relative to progressTitle (ctrlGetRelPos)
		_bar = CIVINTERACT_DISPLAY ctrlCreate ["RscProgress", -1];
		_bar ctrlSetPosition [-0.0275, 0.86, 0.85, 0.04]; 
		_bar ctrlSetTextColor [0.788,0.443,0.157,1];
		_bar progressSetPosition 0;
		_bar ctrlCommit 0;
		[_logic,"ProgressBar", _bar] call ALiVE_fnc_hashSet;
	};

	case "unLoad": {
		//-- Un-stop civilian
		_civ = [_logic, "Civ"] call ALiVE_fnc_hashGet;
		[[[_civ],{(_this select 0) enableAI "MOVE"}],"BIS_fnc_spawn",_civ,false,true] call BIS_fnc_MP;

		//-- unLoad call for inventory handler
		[_logic,"mainMenuClosed"] call INVENTORYHANDLER;

		//-- Remove data from handler
		[_logic, "CivData", nil] call ALiVE_fnc_hashSet;
		[_logic, "Civ", nil] call ALiVE_fnc_hashSet;

		//-- Delete progress bar
		ctrlDelete ([MOD(civInteract),"ProgressBar"] call ALiVE_fnc_hashGet);
		[MOD(civInteract),"ProgressBar", nil] call ALiVE_fnc_hashSet;
	};

	//-- Load data
	case "dataReceived": {
		//-- Exit if the menu has been closed
		if (isNull findDisplay 923) exitWith {};

		_arguments params ["_objectiveInstallations","_objectiveActions","_civInfo","_hostileCivInfo"];

		_logic = MOD(civInteract);

		//-- Create hash
		_civData = [] call ALIVE_fnc_hashCreate;
		_civ = [_logic,"Civ"] call ALiVE_fnc_hashGet;
		_answersGiven = _civ getVariable ["AnswersGiven", []];

		//-- Hash data to logic
		[_civData, "Installations", _objectiveInstallations] call ALiVE_fnc_hashSet;		//-- [_factory,_HQ,_depot,_roadblocks]
		[_civData, "Actions", _objectiveActions] call ALiVE_fnc_hashSet;			//-- [_ambush,_sabotage,_ied,_suicide]
		[_civData, "CivInfo", _civInfo] call ALiVE_fnc_hashSet;				//-- [_homePos, _individualHostility, _townHostility]
		[_civData, "HostileCivInfo", _hostileCivInfo] call ALiVE_fnc_hashSet;			//-- [_civ,_homePos,_activeCommands]
		[_civData, "AnswersGiven", _answersGiven] call ALiVE_fnc_hashSet;			//-- Default []
		[_civData, "Asked", 0] call ALiVE_fnc_hashSet;					//-- Default - 0
		[_logic, "CivData", _civData] call ALiVE_fnc_hashSet;

		//-- Display persistent civ name
		_name = _civInfo select 3;
		_role = [nil,"getRole", _civ] call MAINCLASS;
		if (_role == "None") then {
			CIVINTERACT_CIVNAME ctrlSetText _name;
		} else {
			CIVINTERACT_CIVNAME ctrlSetText (format ["%1 (%2)", _name, _role]);
		};

		[_logic,"enableMain"] call MAINCLASS;
	};

	case "getData": {
		private ["_opcom","_nearestObjective","_civInfo","_clusterID","_agentProfile","_hostileCivInfo","_name","_objectiveInstallations","_objectiveActions"];
		_arguments params ["_player","_civ"];

		_civPos = getPos _civ;
		_insurgentFaction = [MOD(civInteract), "InsurgentFaction"] call ALiVE_fnc_hashGet;

		//-- Get nearest objective properties
		for "_i" from 0 to (count OPCOM_instances - 1) step 1 do {
			_opcom = OPCOM_instances select _i;

			if (_insurgentFaction in ([_opcom, "factions"] call ALiVE_fnc_hashGet)) exitWith {
				_objectives = ([_opcom, "objectives"] call ALiVE_fnc_hashGet);
				_objectives = [_objectives,[_civPos],{_Input0 distance2D ([_x, "center"] call CBA_fnc_HashGet)},"ASCEND"] call BIS_fnc_sortBy;
				_nearestObjective = _objectives select 0;
			};
		};

		if (!isNil "_opcom") then {
			_objectiveInstallations = ["getObjectiveInstallations", [_opcom,_nearestObjective]] call SpyderAddons_fnc_civInteract;
			_objectiveActions = ["getObjectiveActions", [_opcom,_nearestObjective]] call SpyderAddons_fnc_civInteract;
		} else {
			_objectiveInstallations = [[],[],[],[]];
			_objectiveActions = [[],[],[],[]];
		};

		//-- Get civilian info
		_civID = _civ getVariable ["agentID", ""];

		if (_civID != "") then {
			_civProfile = [ALIVE_agentHandler, "getAgent", _civID] call ALIVE_fnc_agentHandler;
			_clusterID = (_civProfile select 2) select 9;
			_cluster = [ALIVE_clusterHandler, "getCluster", _clusterID] call ALIVE_fnc_clusterHandler;
			_homePos = (_civProfile select 2) select 10;
			_individualHostility = (_civProfile select 2) select 12;
			_townHostility = [_cluster, "posture"] call ALIVE_fnc_hashGet;	//_townHostility = (_cluster select 2) select 9; (Different)

			if (!isNil {[_civProfile,"SpyderAddons_PersistentName"] call ALiVE_fnc_hashGet}) then {
				_name = [_civProfile,"SpyderAddons_PersistentName"] call ALiVE_fnc_hashGet;
			} else {
				[_civProfile,"SpyderAddons_PersistentName", name _civ] call ALiVE_fnc_hashSet;
				_name = name _civ;
			};

			_civInfo = [_homePos, _individualHostility, _townHostility,_name];
		};

		//-- Get nearby hostile civilian
		_hostileCivInfo = [];
		_insurgentCommands = ["alive_fnc_cc_suicide","alive_fnc_cc_suicidetarget","alive_fnc_cc_rogue","alive_fnc_cc_roguetarget","alive_fnc_cc_sabotage","alive_fnc_cc_getweapons"];
		_agentsByCluster = [ALIVE_agentHandler, "agentsByCluster"] call ALIVE_fnc_hashGet;
		_nearCivs = [_agentsByCluster, _clusterID] call ALIVE_fnc_hashGet;

		for "_i" from 0 to ((count (_nearCivs select 1)) - 1) do {
			_agentID = (_nearCivs select 1) select _i;
			_agentProfile = [_nearCivs, _agentID] call ALiVE_fnc_hashGet;

			if ([_agentProfile,"active"] call ALIVE_fnc_hashGet) then {
				if ([_agentProfile, "type"] call ALiVE_fnc_hashGet == "agent") then {
					_activeCommands = [_agentProfile,"activeCommands",[]] call ALIVE_fnc_hashGet;

					if ({toLower (_x select 0) in _insurgentCommands} count _activeCommands > 0) then {
						_unit = [_agentProfile,"unit"] call ALIVE_fnc_hashGet;

						if (name _civ != name _unit) then {
							_homePos = (_agentProfile select 2) select 10;
							_hostileCivInfo pushBack [_unit,_homePos,_activeCommands];
						};
					};
				};
			};
		};

		if (count _hostileCivInfo > 0) then {_hostileCivInfo = _hostileCivInfo call BIS_fnc_selectRandom};	//-- Ensure random hostile civ is picked if there are multiple

		_civData = [_objectiveInstallations, _objectiveActions, _civInfo,_hostileCivInfo];

		//-- Send data to client
		[nil,"dataReceived", _civData] remoteExecCall [QUOTE(MAINCLASS),_player];
	};

	case "getRole": {
		private ["_role"];
		_civ = _arguments;
		_role = "none";

		{if (_civ getvariable [_x,false]) exitwith {_role = _x}} foreach ["townelder","major","priest","muezzin","politician"];

		_result = ([_role] call CBA_fnc_capitalize);
	};

	case "isIrritated": {
		_arguments params ["_hostile","_asked","_civ"];

		//-- Raise hostility if civilian is irritated
		if !(_hostile) then {
			if (floor random 100 < (3 * _asked)) then {
				[_logic,"UpdateHostility", [_civ, 10]] call MAINCLASS;
				if (floor random 70 < (_asked * 5)) then {
					_response1 = format [" *%1 grows visibly annoyed*", name _civ];
					_response2 = format [" *%1 appears uninterested in the conversation*", name _civ];
					_response3 = " Please leave me alone now.";
					_response4 = " I do not want to talk to you anymore.";
					_response5 = " Can I go now?";
					_response = [_response1, _response2, _response3, _response4, _response5] call BIS_fnc_selectRandom;
					CIVINTERACT_RESPONSELIST ctrlSetText ((ctrlText CIVINTERACT_RESPONSELIST) + _response);
				};
			};
		} else {
			if (floor random 100 < (8 * _asked)) then {
				[_logic,"UpdateHostility", [_civ, 10]] call MAINCLASS;
				if (floor random 70 < (_asked * 5)) then {
					_response1 = format [" *%1 looks anxious*", name _civ];
					_response2 = format [" *%1 looks distracted*", name _civ];
					_response3 = " Are you done yet?";
					_response4 = " You ask too many questions.";
					_response5 = " You need to leave now.";
					_response = [_response1, _response2, _response3,_response4, _response5] call BIS_fnc_selectRandom;
					CIVINTERACT_RESPONSELIST ctrlSetText ((ctrlText CIVINTERACT_RESPONSELIST) + _response);
				};
			};
		};
	};

	case "UpdateHostility": {
		//-- Change local civilian hostility
		private ["_townHostilityValue"];
		_arguments params ["_civ","_value"];
		if (count _arguments > 2) then {_townHostilityValue = _arguments select 2};

		if (isNil "_townHostilityValue") then {
			if (isNil {[SpyderAddons_civInteract_Logic, "CurrentCivData"] call ALiVE_fnc_hashGet}) exitWith {};

			_civData = [SpyderAddons_civInteract_Logic, "CurrentCivData"] call ALiVE_fnc_hashGet;
			_civInfo = ([_civData, "CivInfo", _civInfo] call ALiVE_fnc_hashGet) select 0;
			_civInfo params ["_homePos","_individualHostility","_townHostility"];

			_individualHostility = _individualHostility + _value;
			_townHostilityValue = floor random 4;
			_townHostility = _townHostility + _townHostilityValue;
			[_civData, "CivInfo", [[_homePos, _individualHostility, _townHostility]]] call ALiVE_fnc_hashSet;
			[SpyderAddons_civInteract_Logic, "CurrentCivData", _civData] call ALiVE_fnc_hashSet;
		};

		//-- Change civilian posture globally
		if (isNil "_townHostilityValue") exitWith {["UpdateHostility", [_civ,_value,_townHostilityValue]] remoteExecCall ["SpyderAddons_fnc_civInteract",2]};

		_civID = _civ getVariable ["agentID", ""];
		if (_civID != "") then {
			_civProfile = [ALIVE_agentHandler, "getAgent", _civID] call ALIVE_fnc_agentHandler;
			_clusterID = _civProfile select 2 select 9;

			//-- Set town hostility
			_cluster = [ALIVE_clusterHandler, "getCluster", _clusterID] call ALIVE_fnc_clusterHandler;
			_clusterHostility = [_cluster, "posture"] call ALIVE_fnc_hashGet;
			[_cluster, "posture", (_clusterHostility + _townHostilityValue)] call ALIVE_fnc_hashSet;

			//-- Set individual hostility
			_hostility = (_civProfile select 2) select 12;
			_hostility = _hostility + _value;
			[_civProfile, "posture", _hostility] call ALiVE_fnc_hashSet;
		};
	};

	case "getActivePlan": {
		_activeCommand = _arguments;

		switch (toLower _activeCommand) do {
			case "alive_fnc_cc_suicide": {
				_activePlan1 = "carrying out a suicide bombing";
				_activePlan2 = "strapping himself with explosives";
				_activePlan3 = "planning a bombing";
				_activePlan4 = "getting ready to bomb your forces";
				_activePlan5 = "about to bomb your forces";
				_result = [_activePlan1,_activePlan2,_activePlan3,_activePlan4,_activePlan5] call BIS_fnc_selectRandom;
			};
			case "alive_fnc_cc_suicidetarget": {
				_activePlan1 = "planning on carrying out a suicide bombing";
				_activePlan2 = "strapping himself with explosives";
				_activePlan3 = "planning a bombing";
				_activePlan4 = "getting ready to bomb your forces";
				_activePlan5 = "about to bomb your forces";
				_result = [_activePlan1,_activePlan2,_activePlan3,_activePlan4,_activePlan5] call BIS_fnc_selectRandom;
			};
			case "alive_fnc_cc_rogue": {
				_activePlan1 = "storing a weapon in his house";
				_activePlan2 = "stockpiling weapons";
				_activePlan3 = "planning on shooting a patrol";
				_activePlan4 = "looking for patrols to shoot at";
				_activePlan5 = "paid to shoot at your forces";
				_result = [_activePlan1,_activePlan2,_activePlan3,_activePlan4,_activePlan5] call BIS_fnc_selectRandom;
			};
			case "alive_fnc_cc_roguetarget": {
				_activePlan1 = "storing a weapon in his house";
				_activePlan2 = "stockpiling weapons";
				_activePlan3 = "planning on shooting a patrol";
				_activePlan4 = "looking for somebody to shoot at";
				_activePlan5 = "paid to shoot at your forces";
				_result = [_activePlan1,_activePlan2,_activePlan3,_activePlan4,_activePlan5] call BIS_fnc_selectRandom;
			};
			case "alive_fnc_cc_sabotage": {
				_activePlan1 = "planning on sabotaging a building";
				_activePlan2 = "blowing up a building";
				_activePlan3 = "planting explosives nearby";
				_activePlan4 = "getting ready to plant explosives";
				_activePlan5 = "paid to shoot at your forces";
				_result = [_activePlan1,_activePlan2,_activePlan3,_activePlan4,_activePlan5] call BIS_fnc_selectRandom;
			};
			case "alive_fnc_cc_getweapons": {
				_activePlan1 = "retrieving weapons from a nearby weapons depot";
				_activePlan2 = "planning on joining the insurgents";
				_activePlan3 = "getting ready to go to a nearby insurgent recruitment center";
				_activePlan4 = "getting ready to retrieve weapons from a cache";
				_activePlan5 = "paid to attack your forces";
				_activePlan6 = "forced to join the insurgents";
				_activePlan7 = "preparing to attack your forces";
				_result = [_activePlan1,_activePlan2,_activePlan3,_activePlan4,_activePlan5] call BIS_fnc_selectRandom;
			};
		};
	};

	case "Detain": {
		//-- Function is exactly the same as ALiVE arrest/release --> Author: Highhead
		_civ = [_logic, "Civ"] call ALiVE_fnc_hashGet;

		closeDialog 0;

		if (!isNil "_civ") then {
			if !(_civ getVariable ["detained", false]) then {
				//-- Join caller group
				[_civ] joinSilent (group player);
				_civ setVariable ["detained", true, true];
			} else {
				//-- Join civilian group
				[_civ] joinSilent (createGroup civilian);
				_civ setVariable ["detained", false, true];
			};
		};
	};

	case "getDown": {
		_civ = [_logic, "Civ"] call ALiVE_fnc_hashGet;

		closeDialog 0;

		if (!isNil "_civ") then {
			[_civ] spawn {
				params ["_civ"];
				sleep 1;
				_civ disableAI "MOVE";
				_civ setUnitPos "DOWN";
				sleep (10 + (ceil random 20));
				_civ enableAI "MOVE";
				_civ setUnitPos "AUTO";
			};
		};
	};

	case "goAway": {
		_civ = [_logic, "Civ"] call ALiVE_fnc_hashGet;

		closeDialog 0;

		if (!isNil "_civ") then {
			[_civ] spawn {
				params ["_civ"];
				sleep 1;
				_civ setUnitPos "AUTO";
				_fleePos = [position _civ, 30, 50, 1, 0, 1, 0] call BIS_fnc_findSafePos;
				_civ doMove _fleePos;
			};
		};
	};

};

//-- Return result if any exists
if (!isNil "_result") then {_result} else {nil};