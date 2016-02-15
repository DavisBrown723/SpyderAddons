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
#define CIVINTERACT_LISTONE 		(CIVINTERACT_DISPLAY displayCtrl 9234)
#define CIVINTERACT_LISTTWO 		(CIVINTERACT_DISPLAY displayCtrl 9235)
#define CIVINTERACT_ASKQUESTION		(CIVINTERACT_DISPLAY displayCtrl 9247)
#define CIVINTERACT_RESPONSEBOX 		(CIVINTERACT_DISPLAY displayCtrl 9239)

#define CIVINTERACT_CIVNAME 		(CIVINTERACT_DISPLAY displayCtrl 9236)
#define CIVINTERACT_DETAIN 		(CIVINTERACT_DISPLAY displayCtrl 92311)

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
			_hostilityChance = call compile (_logic getVariable "HostilityChance");
			_irritatedChance = call compile (_logic getVariable "IrritatedChance");
			_answerChance = call compile (_logic getVariable "AnswerChance");

			_friendlyForces = _logic getVariable "FriendlyForces";
			_enemyForces = _logic getVariable "EnemyForces";

			//-- Let's get hacky! (Seriously, turn back now)
			_friendlyForces = [_friendlyForces, "[", "'["] call CBA_fnc_replace;
			_friendlyForces = [_friendlyForces, "]", "]'"] call CBA_fnc_replace;
			_friendlyForces = "[" + _friendlyForces + "]";
			_friendlyForces = call compile _friendlyForces;

			_enemyForces = [_enemyForces, "[", "'["] call CBA_fnc_replace;
			_enemyForces = [_enemyForces, "]", "]'"] call CBA_fnc_replace;
			_enemyForces = "[" + _enemyForces + "]";
			_enemyForces = call compile _enemyForces;

			_ff = [];
			{
				_f = _x;
				_f = [_f, "[", "['"] call CBA_fnc_replace;
				_f = [_f, "]", "']"] call CBA_fnc_replace;
				_f = [_f, ",", "','"] call CBA_fnc_replace;
				_f = call compile _f;

				private _hostility = call compile (_f select 2);
				if (_hostility > 1) then {
					_hostility = 1;
				} else {
					if (_hostility < -1) then {
						_hostility = -1;
					};
				};

				//-- Create forcehash
				_force = [] call ALiVE_fnc_hashCreate;
				[_force,"Faction", _f select 0] call ALiVE_fnc_hashSet;
				[_force,"DisplayName", _f select 1] call ALiVE_fnc_hashSet;
				[_force,"Hostility", _f select 2] call ALiVE_fnc_hashSet;
				[_force,"Asymmetric", false] call ALiVE_fnc_hashSet;

				_ff pushBack _force;
			} forEach _friendlyForces;

			_ef = [];
			{
				//-- Convert string
				_f = _x;
				_f = [_f, "[", "['"] call CBA_fnc_replace;
				_f = [_f, "]", "']"] call CBA_fnc_replace;
				_f = [_f, ",", "','"] call CBA_fnc_replace;
				_f = call compile _f;

				//-- Ensure hostility is between -1 and 1
				private _hostility = call compile (_f select 2);
				if (_hostility > 1) then {
					_hostility = 1;
				} else {
					if (_hostility < -1) then {
						_hostility = -1;
					};
				};

				//-- Create forcehash
				_force = [] call ALiVE_fnc_hashCreate;
				[_force,"Faction", _f select 0] call ALiVE_fnc_hashSet;
				[_force,"DisplayName", _f select 1] call ALiVE_fnc_hashSet;
				[_force,"Hostility", _f select 2] call ALiVE_fnc_hashSet;
				if (isnil {_f select 3}) then {
					[_force,"Asymmetric", false] call ALiVE_fnc_hashSet;
				} else {
					[_force,"Asymmetric", _x select 3] call ALiVE_fnc_hashSet;
				};

				_ef pushBack _force;
			} forEach _enemyForces;

			//-- Create interact handler object
			MOD(civInteract) = [nil,"create"] call MAINCLASS;
			[MOD(civInteract),"Hostilitychance", _hostilityChance] call ALiVE_fnc_hashSet;
			[MOD(civInteract),"IrritatedChance", _irritatedChance] call ALiVE_fnc_hashSet;
			[MOD(civInteract),"AnswerChance", _answerChance] call ALiVE_fnc_hashSet;
			[MOD(civInteract),"FriendlyForces", _ff] call ALiVE_fnc_hashSet;
			[MOD(civInteract),"EnemyForces", _ef] call ALiVE_fnc_hashSet;
		};
	};

	case "forces": {
		if (typeName _arguments == "STRING") then {
			_result = [_logic,_arguments] call ALiVE_fnc_hashGet;
		} else {
			_result = (([_logic,"FriendlyForces"] call ALiVE_fnc_hashGet) + ([_logic,"EnemyForces"] call ALiVE_fnc_hashGet));
		};
	};

	case "getForceByDisplayName": {
		_displayName = _arguments;

		//-- More questions reference enemy forces, check first
		_enemyForces = [_logic,"EnemyForces"] call ALiVE_fnc_hashGet;
		{
			if (_displayName == (_x select 1)) then {
				_result = _x;
			};
		} forEach _enemyForces;
	};

	case "openMenu": {
		_civ = _arguments;

		//-- Civ attacks if armed
		if (count (weapons _civ) > 0) exitWith {[nil,"attackUnit", [_civ,player]] call MAINCLASS};

		//-- Stop civilian
		[[[_civ],{(_this select 0) disableAI "MOVE"}],"BIS_fnc_spawn",_civ,false,true] call BIS_fnc_MP;

		[_logic, "Civ", _civ] call ALiVE_fnc_hashSet;

		CreateDialog "Civ_Interact";

		[_logic,"onLoad"] call MAINCLASS;
	};

	case "onLoad": {
		_civ = [_logic,"Civ"] call ALiVE_fnc_hashGet;

		//-- onLoad call for inventory handler
		[_logic,"mainMenuOpened"] call INVENTORYHANDLER;

		//-- Hide controls
		CIVINTERACT_LISTTWO ctrlShow false;
		CIVINTERACT_ASKQUESTION ctrlShow false;

		//-- Display loading
		CIVINTERACT_LISTONE lbAdd "Loading . . .";

		//-- Retrieve data
		[nil,"getData", [player,_civ]] remoteExecCall [QUOTE(MAINCLASS),2];

		if (_civ getVariable "detained") then {
			CIVINTERACT_DETAIN ctrlSetText "Release";
		};

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

	case "getData": {
		private ["_opcom","_nearestObjective","_civInfo","_clusterID","_agentProfile","_hostileCivInfo","_name","_installations"];
		_arguments params ["_player","_civ"];

		_civPos = getPos _civ;

		//-- Get insurgent factions
		_enemyForces = [MOD(civInteract), "EnemyForces"] call ALiVE_fnc_hashGet;
		_insurgentFactions = [];
		{
			_specifier = _x select 3;
			if !(isnil "_specifier") then {
				if (_specifier) then {
					_insurgentFactions pushback (_x select 0);
				};
			};
		} forEach _enemyForces;

		//-- Get nearest objective properties
		_objectives = [];
		{
			private _exit = false; //-- Don't grab the same objective from an opcom twice
			_opcom = _x;

			{
				if (!(_exit) && {_x in ([_opcom, "factions"] call ALiVE_fnc_hashGet)}) exitWith {
					_objectives = ([_opcom, "objectives"] call ALiVE_fnc_hashGet);
					_objectives = [_objectives,[_civPos],{_Input0 distance2D ([_x, "center"] call CBA_fnc_HashGet)},"ASCEND"] call BIS_fnc_sortBy;
					_objectives pushback (_objectives select 0);
					_exit = true;
				};
			} foreach _insurgentFactions;
		} count OPCOM_instances;

		_installations = [[],[],[],[],[],[],[],[]];
		{
			_objective = _x;
			_inst = _objective call SpyderAddons_fnc_getObjectiveInstallations; //-- [_HQ,_depot,_factory,_roadblocks,_ambush,_sabotage,_ied,_suicide]

			for "_i" from 0 to 8 do {
				(_installations select _i) append (_inst select _i);
			};
		} foreach _objectives;

		//-- Get civilian info
		_civID = _civ getVariable ["agentID", ""];
		if (_civID != "") then {
			//-- Get civ cluster
			_civProfile = [ALIVE_agentHandler, "getAgent", _civID] call ALIVE_fnc_agentHandler;
			_clusterID = (_civProfile select 2) select 9;
			_cluster = [ALIVE_clusterHandler, "getCluster", _clusterID] call ALIVE_fnc_clusterHandler;

			//-- Get info
			_homePos = (_civProfile select 2) select 10;
			_hostilityIndividual = (_civProfile select 2) select 12;
			_hostilityTown = [_cluster, "posture"] call ALIVE_fnc_hashGet;	//_townHostility = (_cluster select 2) select 9; (Different)

			//-- Get persistent civ name, set if it doesn't exist
			if (!isnil {[_civProfile,"SpyderAddons_PersistentName"] call ALiVE_fnc_hashGet}) then {
				_name = [_civProfile,"SpyderAddons_PersistentName"] call ALiVE_fnc_hashGet;
			} else {
				[_civProfile,"SpyderAddons_PersistentName", name _civ] call ALiVE_fnc_hashSet;
				_name = name _civ;
			};

			_personality = [nil,"getPersonality", _civ] call SpyderAddons_fnc_personalityHandler;

			//-- Create hash
			_civInfo = [] call ALiVE_fnc_hashCreate;
			[_civInfo,"Name", _name] call ALiVE_fnc_hashSet;
			[_civInfo,"Personality", _personality] call ALiVE_fnc_hashSet;
			[_civInfo,"HomePosition", _homePos] call ALiVE_fnc_hashSet;
			[_civInfo,"HostilityIndividual", _hostilityIndividual] call ALiVE_fnc_hashSet;
			[_civInfo,"HostilityTown", _hostilityTown] call ALiVE_fnc_hashSet;
		};

		//-- Get nearby hostile civilian
		_hostileCivInfo = [];
		_insurgentCommands = ["alive_fnc_cc_suicide","alive_fnc_cc_suicidetarget","alive_fnc_cc_rogue","alive_fnc_cc_roguetarget","alive_fnc_cc_sabotage","alive_fnc_cc_getweapons"];
		_agentsByCluster = [ALIVE_agentHandler, "agentsByCluster"] call ALIVE_fnc_hashGet;
		_nearCivs = [_agentsByCluster, _clusterID] call ALIVE_fnc_hashGet;

		{
			_agentID = _x;
			_agentProfile = [_nearCivs, _agentID] call ALiVE_fnc_hashGet;

			//-- Only check active, human agent profiles
			if ([_agentProfile,"active"] call ALIVE_fnc_hashGet) then {
				if ([_agentProfile, "type"] call ALiVE_fnc_hashGet == "agent") then {
					_activeCommands = [_agentProfile,"activeCommands",[]] call ALIVE_fnc_hashGet;

					//-- Check if any of the agent's current commands are insurgent commands
					if ({(tolower (_x select 0)) in _insurgentCommands} count _activeCommands > 0) then {
						_unit = [_agentProfile,"unit"] call ALIVE_fnc_hashGet;

						//-- Don't rat yourself out!
						if (name _civ != name _unit) then {
							_homePos = (_agentProfile select 2) select 10;

							_hostileCivInfo = [] call ALiVE_fnc_hashCreate; //-- [_unit,_homePos,_activeCommands]
							[_hostileCivInfo,"Unit", _unit] call ALiVE_fnc_hashSet;
							[_hostileCivInfo,"HomePosition", _homePos] call ALiVE_fnc_hashSet;
							[_hostileCivInfo,"ActiveCommands", _activeCommands] call ALiVE_fnc_hashSet;
						};
					};
				};
			};
		} foreach (_nearCivs select 1);

		//-- If multiple hostile civilians nearby, pick one at random
		if (count _hostileCivInfo > 0) then {_hostileCivInfo = _hostileCivInfo call BIS_fnc_selectRandom};	//-- Ensure random hostile civ is picked if there are multiple

		//-- Send data to client
		[nil,"dataReceived", [_installations, _civInfo,_hostileCivInfo]] remoteExecCall [QUOTE(MAINCLASS),_player];
	};

	//-- Data received from server
	case "dataReceived": {
		//-- Exit if the menu has been closed
		if (isNull (findDisplay 923)) exitWith {
			[MOD(civInteract),"Civ", nil] call ALiVE_fnc_hashSet;
			[MOD(civInteract),"ProgressBar", nil] call ALiVE_fnc_hashSet;
		};
		
		_arguments params ["_installations","_civInfo","_hostileCivInfo"];

		_civ = [MOD(civInteract),"Civ"] call ALiVE_fnc_hashGet;
		_answersGiven = _civ getVariable ["AnswersGiven", []];

		//-- Create hash
		_civData = [] call ALIVE_fnc_hashCreate;
		[_civData, "Installations", _installations] call ALiVE_fnc_hashSet;			//-- [_HQ,_depot,_factory,_roadblocks,_ambush,_sabotage,_ied,_suicide]
		[_civData, "CivInfo", _civInfo] call ALiVE_fnc_hashSet;				//-- ["HomePosition","HostilityIndividual","HostilityTown"] - Hash
		[_civData, "HostileCivInfo", _hostileCivInfo] call ALiVE_fnc_hashSet;			//-- ["Unit","HomePosition","ActiveCommands"] - Hash
		[_civData, "AnswersGiven", _answersGiven] call ALiVE_fnc_hashSet;			//-- Default []
		[_civData, "Asked", 0] call ALiVE_fnc_hashSet;					//-- Default - 0
		[MOD(civInteract), "CivData", _civData] call ALiVE_fnc_hashSet;

		//-- Display persistent civ name
		_name = [_civInfo,"Name"] call ALiVE_fnc_hashGet;
		_role = _civ call SpyderAddons_fnc_getCivilianRole;

		if !(isNil "_role") then {
			CIVINTERACT_CIVNAME ctrlSetText (format ["%1 (%2)", _name, _role]);
		} else {
			CIVINTERACT_CIVNAME ctrlSetText _name;
		};

		//-- Populate question list
		[MOD(civInteract),"loadQuestions"] call MAINCLASS;
	};

	case "loadQuestions": {
		//-- Clear list
		lbClear CIVINTERACT_LISTONE;

		//-- Build question list
		_index = CIVINTERACT_LISTONE lbAdd "How are you?";
		CIVINTERACT_LISTONE lbSetData [_index, "['HowAreYou', 1.5]"];

		_index = CIVINTERACT_LISTONE lbAdd "Where do you live?";
		CIVINTERACT_LISTONE lbSetData [_index, "['Home', 1.6]"];

		_index = CIVINTERACT_LISTONE lbAdd "Have you seen any IED's lately?";
		CIVINTERACT_LISTONE lbSetData [_index, "['IEDs', 2]"];

		_index = CIVINTERACT_LISTONE lbAdd "Have you seen any ... forces activity lately?";
		CIVINTERACT_LISTONE lbSetData [_index, "['Insurgents', -1, 'enemy']"];

		_index = CIVINTERACT_LISTONE lbAdd "Do you know the location of any insurgent hideouts?";
		CIVINTERACT_LISTONE lbSetData [_index, "['Hideouts', 2.5]"];

		_index = CIVINTERACT_LISTONE lbAdd "Have you seen any strange behavior lately?";
		CIVINTERACT_LISTONE lbSetData [_index, "['StrangeBehavior', 2.5]"];

		_index = CIVINTERACT_LISTONE lbAdd "What is your opinion of .. forces?";
		CIVINTERACT_LISTONE lbSetData [_index, "['ForcesOpinion', -1, 'all']"];

		_index = CIVINTERACT_LISTONE lbAdd "What is the opinion of ... forces in this area?";
		CIVINTERACT_LISTONE lbSetData [_index, "['TownOpinion', -1, 'all']"];

		//-- Add onSel EH to question list
		CIVINTERACT_LISTONE ctrlAddEventHandler ["LBSelChanged",{[SpyderAddons_civInteract,"mainListLBSelChanged", _this] call SpyderAddons_fnc_civInteract}];
	};

	case "mainListLBSelChanged": {
		_arguments params ["_control","_index"];
		_data = call compile (_control lbData _index);
		_data params ["_question","_askTime"];

		lbClear CIVINTERACT_LISTTWO;
		CIVINTERACT_LISTTWO lbSetCurSel -1;

		//-- Question requires force definition
		if (_askTime == -1) then {
			private ["_forces"];

			CIVINTERACT_LISTTWO ctrlShow true;
			CIVINTERACT_ASKQUESTION ctrlShow false;

			_forces = _data select 2;

			switch (_forces) do {
				case "friendly": {
					_forces = [_logic,"FriendlyForces",[]] call ALiVE_fnc_hashGet;
				};

				case "enemy": {
					_forces = [_logic,"EnemyForces",[]] call ALiVE_fnc_hashGet;
				};

				case "all": {
					_forces1 = [_logic,"FriendlyForces",[]] call ALiVE_fnc_hashGet;
					_forces2 = [_logic,"EnemyForces",[]] call ALiVE_fnc_hashGet;
					_forces = _forces1 + _forces2;
				};
			};

			//-- Populate list 2 with forces
			{
				_index = CIVINTERACT_LISTTWO lbAdd ((_x select 2) select 1);
				CIVINTERACT_LISTTWO lbSetData [_index, _question];
			} forEach _forces;

			//-- Add onSel EH to question list
			CIVINTERACT_LISTTWO ctrlAddEventHandler ["LBSelChanged",{[SpyderAddons_civInteract,"secondaryListLBSelChanged", _this] call SpyderAddons_fnc_civInteract}];
		} else {
			CIVINTERACT_LISTTWO ctrlShow false;
			CIVINTERACT_ASKQUESTION ctrlShow true;
		};
	};

	//-- Cleanup function, too complex
	case "secondaryListLBSelChanged": {
		CIVINTERACT_ASKQUESTION ctrlShow true;
	};

	case "prepQuestion": {
		_data = CIVINTERACT_LISTONE lbData (lbCurSel CIVINTERACT_LISTONE);
		_data = call compile _data;
		_data params ["_question","_askTime"];

		//-- disable ask control
		CIVINTERACT_ASKQUESTION ctrlEnable false;

		//-- animate progress bar
		_bar = [_logic,"ProgressBar"] call ALiVE_fnc_hashGet;
		[_bar,_askTime] spawn SpyderAddons_fnc_progressAnimate;

		//-- Ask question after delay if menu is still open
		[_logic,"askQuestion", [_question,_askTime]] spawn MAINCLASS;
	};

	case "askQuestion": {
		_arguments params ["_question","_askTime"];

		//-- Wait until progress bar is filled
		sleep _askTime;

		//-- Enable ask control
		CIVINTERACT_ASKQUESTION ctrlEnable true;

		//-- Exit if menu has closed
		if (isnull (findDisplay 923)) exitWith {};

		if (ctrlShown CIVINTERACT_LISTTWO) then {
			//-- Ask question from list one, with force from list two

			//-- Delete selected option
			CIVINTERACT_LISTTWO lbDelete (lbCurSel CIVINTERACT_LISTTWO);

			//-- If no more options in list two, delete question from list two
			if (lbSize CIVINTERACT_LISTTWO == 0) then {
				CIVINTERACT_LISTTWO ctrlShow false;
				CIVINTERACT_LISTONE lbDelete (lbCurSel CIVINTERACT_LISTONE);
			};
		} else {
			CIVINTERACT_LISTONE lbDelete (lbCurSel CIVINTERACT_LISTONE);
		};

		//-- Get responses to the question
		_responses = [SpyderAddons_civInteract,_question] call SpyderAddons_fnc_getResponses; //-- ["Response Text", [["FollowupResponse1","Data1"],["FollowupResponse2","Data2"]]]

		if (count (_responses select 1) > 0) then {
			//-- Followup questions
			CIVINTERACT_LISTTWO ctrlShow true;

			CIVINTERACT_RESPONSEBOX ctrlSetText (_responses select 0);

			//-- Populate list two with followup questions
			{
				_index = CIVINTERACT_LISTTWO lbAdd (_x select 0);
				CIVINTERACT_LISTTWO lbSetData [_index, (_x select 1)];
			} forEach (_responses select 1);
		} else {
			//-- No followup questions
			CIVINTERACT_RESPONSEBOX ctrlSetText (_responses select 0);
			CIVINTERACT_LISTTWO ctrlShow false;
		};

		if (lbCurSel CIVINTERACT_LISTONE != -1) then {CIVINTERACT_LISTONE lbSetCurSel (lbCurSel CIVINTERACT_LISTONE)};
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