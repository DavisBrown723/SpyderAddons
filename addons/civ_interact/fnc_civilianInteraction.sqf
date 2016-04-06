#include <\x\spyderaddons\addons\civ_interact\script_component.hpp>
SCRIPT(civilianInteraction);

/* ----------------------------------------------------------------------------
Function: SpyderAddons_fnc_civilianInteraction

Description:
Main handler for civilian interraction

Parameters:
String - Operation
Array - Arguments

Returns:
Any - Result of the operation

Examples:
(begin example)
[_logic,_operation, _args] call SpyderAddons_fnc_civilianInteraction;
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
	["_logic", objNull, [objNull,[]]],
	["_operation", "", [""]],
	["_args", objNull]
];

//-- Define function shortcuts
#define MAINCLASS 			SpyderAddons_fnc_civilianInteraction
#define INVENTORYHANDLER 		SpyderAddons_fnc_inventoryHandler

//-- Define control ID's
#define CIVINTERACT_DISPLAY 		(findDisplay 923)
#define CIVINTERACT_LISTONE 		(CIVINTERACT_DISPLAY displayCtrl 9234)
#define CIVINTERACT_LISTTWO 		(CIVINTERACT_DISPLAY displayCtrl 9235)
#define CIVINTERACT_ASKQUESTION		(CIVINTERACT_DISPLAY displayCtrl 9247)
#define CIVINTERACT_RESPONSEBOX 		(CIVINTERACT_DISPLAY displayCtrl 9239)

#define INVENTORY_PROGRESSBARTITLE	(CIVINTERACT_DISPLAY displayCtrl 9248)

#define CIVINTERACT_CIVNAME 		(CIVINTERACT_DISPLAY displayCtrl 9236)
#define CIVINTERACT_DETAIN 		(CIVINTERACT_DISPLAY displayCtrl 92311)

switch (_operation) do {

	case "create": {
		_result = [] call SpyderAddons_fnc_hashCreate;
	};

	//-- Create logic on all localities
	case "init": {
		//-- Make sure ALiVE is running
		if ((hasInterface) and {!(isClass (configfile >> "CfgVehicles" >> "ALiVE_require"))}) exitWith {
			waitUntil {sleep 1; time > 5};
			["Civilian Interaction"] call SpyderAddons_fnc_openRequiresAlive;
		};

		if (isNil QMOD(civilianInteraction)) then {
			//-- Get settings
			_debug = _logic getVariable "Debug";
			_IEDclasses = [_logic getVariable "IEDClasses"] call SpyderAddons_fnc_getModuleArray;

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

			_ff = [] call SpyderAddons_fnc_hashCreate;
			{
				_f = _x; // "[faction,displayname,hostility,asymm]"
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
				_force = [] call SpyderAddons_fnc_hashCreate;
				[_force,"displayName", _f select 1] call SpyderAddons_fnc_hashSet;
				[_force,"hostility", call compile (_f select 2)] call SpyderAddons_fnc_hashSet;
				[_force,"asymmetric", false] call SpyderAddons_fnc_hashSet;

				[_ff,(_f select 0),_force] call SpyderAddons_fnc_hashSet;
			} forEach _friendlyForces;

			_ef = [] call SpyderAddons_fnc_hashCreate;
			{
				//-- Convert string
				_f = _x; // "[faction,displayname,hostility,asymm]"
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
				_force = [] call SpyderAddons_fnc_hashCreate;
				[_force,"displayName", _f select 1] call SpyderAddons_fnc_hashSet;
				[_force,"hostility", call compile (_f select 2)] call SpyderAddons_fnc_hashSet;
				if (isnil {_f select 3}) then {
					[_force,"asymmetric", false] call SpyderAddons_fnc_hashSet;
				} else {
					[_force,"asymmetric", call compile (_x select 3)] call SpyderAddons_fnc_hashSet;
				};

				[_ef,(_f select 0),_force] call SpyderAddons_fnc_hashSet;
			} forEach _enemyForces;

			_allForces = [] call SpyderAddons_fnc_hashCreate;
			[_allForces,"friendly",_ff] call SpyderAddons_fnc_hashSet;
			[_allForces,"enemy",_ef] call SpyderAddons_fnc_hashSet;

			//-- Create interact handler object
			MOD(civilianInteraction) = [nil,"create"] call MAINCLASS;
			[MOD(civilianInteraction),"debug", call compile _debug] call SpyderAddons_fnc_hashSet;
			[MOD(civilianInteraction),"forces", _allForces] call SpyderAddons_fnc_hashSet;
			[MOD(civilianInteraction),"IEDClasses", _IEDclasses] call SpyderAddons_fnc_hashSet;
			[MOD(civilianInteraction),"topics", []] call SpyderAddons_fnc_hashSet
		};
	};

	case "debug": {
		if (typename _args == "BOOL") then {
			[_logic,"debug", _args] call SpyderAddons_fnc_hashSet;
			_result = true;
		} else {
			_result = [_logic,"debug"] call SpyderAddons_fnc_hashGet;
		};
	};

	case "forces": {
		if (typename _args == "ARRAY") then {
			[_logic,"forces",_args] call SpyderAddons_fnc_hashSet;
			_result = true;
		} else {
			_result = [_logic,"forces"] call SpyderAddons_fnc_hashGet;
		};
	};

	case "topics": {
		if (typename _args == "ARRAY") then {
			[_logic,"topics",_args] call SpyderAddons_fnc_hashSet;
			_result = true;
		} else {
			_result = [_logic,"topics"] call SpyderAddons_fnc_hashGet;
		};
	};

	case "getForceByFaction": {
		_faction = _args;
		_forces = [_logic,"forces"] call SpyderAddons_fnc_hashGet;
		_friendlyForces = [_forces,"friendly"] call SpyderAddons_fnc_hashGet;
		_result = [_friendlyForces,_faction] call SpyderAddons_fnc_hashGet;

		if (isnil "_result") then {
			_enemyforces = [_forces,"enemy"] call SpyderAddons_fnc_hashGet;
			_result = [_enemyForces,_faction] call SpyderAddons_fnc_hashGet;
		};
	};

	case "openMenu": {
		_civ = _args;

		//-- Civ attacks if armed
		if (count (weapons _civ) > 0) exitWith {[nil,"attackUnit", [_civ,player]] call MAINCLASS};

		//-- Stop civilian
		[_civ,{_this disableAI "MOVE"}] remoteExecCall ["BIS_fnc_spawn",_civ];

		[_logic, "Civ", _civ] call SpyderAddons_fnc_hashSet;

		CreateDialog "Civ_Interact";

		[_logic,"onLoad"] call MAINCLASS;
	};

	case "onLoad": {
		_civ = [_logic,"Civ"] call SpyderAddons_fnc_hashGet;

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

		//-- Create progress bar --> doesn't like working when created via main.hpp
		_bar = CIVINTERACT_DISPLAY ctrlCreate ["RscProgress", -1];
		_bar ctrlSetPosition [-0.0275, 0.86, 0.85, 0.04]; 
		_bar ctrlSetTextColor [0.788,0.443,0.157,1];
		_bar progressSetPosition 0;
		_bar ctrlCommit 0;
		[_logic,"ProgressBar", _bar] call SpyderAddons_fnc_hashSet;
	};

	case "unLoad": {
		//-- Un-stop civilian
		_civ = [_logic, "Civ"] call SpyderAddons_fnc_hashGet;
		[_civ,{_this enableAI "MOVE"}] remoteExecCall ["BIS_fnc_spawn",_civ];

		//-- unLoad call for inventory handler
		[_logic,"mainMenuClosed"] call INVENTORYHANDLER;

		//-- Remove data from handler
		[_logic, "CivData", nil] call SpyderAddons_fnc_hashSet;
		[_logic, "Civ", nil] call SpyderAddons_fnc_hashSet;

		_debug = [_logic,"Debug"] call SpyderAddons_fnc_hashGet;
		if (_debug) then {
			hint "";
		};

		//-- Delete progress bar
		ctrlDelete ([MOD(civilianInteraction),"ProgressBar"] call SpyderAddons_fnc_hashGet);
		[MOD(civilianInteraction),"ProgressBar", nil] call SpyderAddons_fnc_hashSet;
	};

	case "getData": {
		private ["_opcom","_nearestObjective","_civInfo","_clusterID","_agentProfile","_hostileCivInfo","_name","_installations"];
		_args params ["_player","_civ"];

		_civPos = getPos _civ;

		//-- Get insurgent factions
		_enemyForces = [MOD(civilianInteraction), "EnemyForces"] call SpyderAddons_fnc_hashGet;
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
				if (!(_exit) && {_x in ([_opcom, "factions"] call SpyderAddons_fnc_hashGet)}) exitWith {
					_objectives = ([_opcom, "objectives"] call SpyderAddons_fnc_hashGet);
					_objectives = [_objectives,[_civPos],{_Input0 distance2D ([_x, "center"] call CBA_fnc_HashGet)},"ASCEND"] call BIS_fnc_sortBy;
					_objectives pushback (_objectives select 0);
					_exit = true;
				};
			} foreach _insurgentFactions;
		} count OPCOM_instances;

		_installations = [[],[],[],[]];
		_actions = [[],[],[],[]];
		{
			_objective = _x;
			_inst = _objective call SpyderAddons_fnc_getObjectiveInstallations; //-- [_HQ,_depot,_factory,_roadblocks,_ambush,_sabotage,_ied,_suicide]

			for "_i" from 0 to 3 do {
				_instEntry = _inst select _i;
				if (typename _instEntry == "OBJECT") then {
					(_installations select _i) pushback _instEntry;
				};
			};

			for "_i" from 4 to 7 do {
				_instEntry = _inst select _i;
				if (typename _instEntry == "OBJECT") then {
					(_actions select _i) pushback _instEntry;
				};
			};
		} foreach _objectives;

		_installations = [_installations,_actions];

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
			_hostilityTown = [_cluster, "posture"] call SpyderAddons_fnc_hashGet;	//_townHostility = (_cluster select 2) select 9; (Different)

			//-- Get persistent civ name, set if it doesn't exist
			if (!isnil {[_civProfile,"SpyderAddons_PersistentName"] call SpyderAddons_fnc_hashGet}) then {
				_name = [_civProfile,"SpyderAddons_PersistentName"] call SpyderAddons_fnc_hashGet;
			} else {
				[_civProfile,"SpyderAddons_PersistentName", name _civ] call SpyderAddons_fnc_hashSet;
				_name = name _civ;
			};

			_personality = [nil,"getPersonality", _civ] call SpyderAddons_fnc_personality;

			_civInfo = [_name,_personality,_homePos,_hostilityIndividual,_hostilityTown];
		};

		//-- Get nearby hostile civilian
		_hostileCivInfo = [];
		_insurgentCommands = ["alive_fnc_cc_suicide","alive_fnc_cc_suicidetarget","alive_fnc_cc_rogue","alive_fnc_cc_roguetarget","alive_fnc_cc_sabotage","alive_fnc_cc_getweapons"];
		_agentsByCluster = [ALIVE_agentHandler, "agentsByCluster"] call SpyderAddons_fnc_hashGet;
		_nearCivs = [_agentsByCluster, _clusterID] call SpyderAddons_fnc_hashGet;

		{
			_agentID = _x;
			_agentProfile = [_nearCivs, _agentID] call SpyderAddons_fnc_hashGet;

			//-- Only check active, human agent profiles
			if ([_agentProfile,"active"] call SpyderAddons_fnc_hashGet) then {
				if ([_agentProfile, "type"] call SpyderAddons_fnc_hashGet == "agent") then {
					_activeCommands = [_agentProfile,"activeCommands",[]] call SpyderAddons_fnc_hashGet;

					//-- Check if any of the agent's current commands are insurgent commands
					if ({(tolower (_x select 0)) in _insurgentCommands} count _activeCommands > 0) then {
						_unit = [_agentProfile,"unit"] call SpyderAddons_fnc_hashGet;

						//-- Don't rat yourself out!
						if (name _civ != name _unit) then {
							_homePos = (_agentProfile select 2) select 10;

							_hostileCivInfo = [_unit,_homePos,_activeCommands]; //-- [_unit,_homePos,_activeCommands]
						};
					};
				};
			};
		} foreach (_nearCivs select 1);

		//-- If multiple hostile civilians nearby, pick one at random
		if (count _hostileCivInfo > 0) then {_hostileCivInfo = selectRandom _hostileCivInfo};	//-- Ensure random hostile civ is picked if there are multiple

		//-- Send data to client
		[nil,"dataReceived", [_installations, _civInfo,_hostileCivInfo]] remoteExecCall [QUOTE(MAINCLASS),_player];
	};

	//-- Data received from server
	case "dataReceived": {
		private ["_hostile"];

		//-- Exit if the menu has been closed
		if (isNull (findDisplay 923)) exitWith {
			[MOD(civilianInteraction),"Civ", nil] call SpyderAddons_fnc_hashSet;
			[MOD(civilianInteraction),"ProgressBar", nil] call SpyderAddons_fnc_hashSet;
		};

		_civ = [MOD(civilianInteraction),"Civ"] call SpyderAddons_fnc_hashGet;
		_args params ["_installations","_civInfo","_hostileCivInfo"];

		//-- Get previously given answers -- Use getVariable/setVariable for temp storage
		_questionsAsked = _civ getVariable ["QuestionsAsked", []]; //-- [_questionsAsked,_questionsAnswerd]

		//-- Create civ info hash
		_civInfo params ["_name","_personality","_homePos","_hostilityIndividual","_hostilityTown"];
		if (random 100 > _hostilityIndividual) then {_hostile = false} else {_hostile = true};
		_civInfo = [] call SpyderAddons_fnc_hashCreate;
		[_civInfo,"Name", _name] call SpyderAddons_fnc_hashSet;
		[_civInfo,"Personality", _personality] call SpyderAddons_fnc_hashSet;
		[_civInfo,"HomePosition", _homePos] call SpyderAddons_fnc_hashSet;
		[_civInfo,"Hostile", _hostile] call SpyderAddons_fnc_hashSet;
		[_civInfo,"HostilityIndividual", _hostilityIndividual] call SpyderAddons_fnc_hashSet;
		[_civInfo,"HostilityTown", _hostilityTown] call SpyderAddons_fnc_hashSet;

		//-- Create hostile civ info hash
		_hostileCivInfo params ["_unit","_homePos","_activeCommands"];
		_hostileCivInfo = [] call SpyderAddons_fnc_hashCreate;
		[_hostileCivInfo,"Unit", _unit] call SpyderAddons_fnc_hashSet;
		[_hostileCivInfo,"HomePosition", _homePos] call SpyderAddons_fnc_hashSet;
		[_hostileCivInfo,"ActiveCommands", _activeCommands] call SpyderAddons_fnc_hashSet;

		//-- Create civ data hash
		_civData = [] call SpyderAddons_fnc_hashCreate;
		[_civData, "Installations", _installations select 0] call SpyderAddons_fnc_hashSet;	//-- [_HQ,_depot,_factory,_roadblocks]
		[_civData,"InsurgentActions", _installations select 1] call SpyderAddons_fnc_hashSet;	//-- [_ambush,_sabotage,_ied,_suicide]
		[_civData, "CivInfo", _civInfo] call SpyderAddons_fnc_hashSet;				//-- ["Name","Personality","HomePosition","HostilityIndividual","HostilityTown"] - Hash
		[_civData, "HostileCivInfo", _hostileCivInfo] call SpyderAddons_fnc_hashSet;		//-- ["Unit","HomePosition","ActiveCommands"] - Hash
		[_civData, "AnswersGiven", _answersGiven] call SpyderAddons_fnc_hashSet;		//-- Default []
		[_civData, "Asked", 0] call SpyderAddons_fnc_hashSet;					//-- Default - 0
		[MOD(civilianInteraction), "CivData", _civData] call SpyderAddons_fnc_hashSet;

		//-- Display persistent civ name
		_name = [_civInfo,"Name"] call SpyderAddons_fnc_hashGet;
		_role = _civ call SpyderAddons_fnc_getCivilianRole;

		if !(isNil "_role") then {
			CIVINTERACT_CIVNAME ctrlSetText (format ["%1 (%2)", _name, _role]);
		} else {
			CIVINTERACT_CIVNAME ctrlSetText _name;
		};

		//-- Populate question list
		[MOD(civilianInteraction),"enableMain"] call MAINCLASS;

		_debug = [MOD(civilianInteraction),"Debug"] call SpyderAddons_fnc_hashGet;
		if (_debug) then {
			[MOD(civilianInteraction),"debugCurrentCiv"] call MAINCLASS;
		};
	};

	case "saveData": {
		//-- Send modified data back to the server and store it in the civ's profile hash
	};

	case "debugCurrentCiv": {
		_civ = [_logic,"Civ"] call SpyderAddons_fnc_hashGet;
		_civData = [_logic,"CivData"] call SpyderAddons_fnc_hashGet;
		_civInfo = [_civData,"CivInfo"] call SpyderAddons_fnc_hashGet;
		_personality = [_civInfo,"Personality"] call SpyderAddons_fnc_hashGet;

		_civInfoTitle =  parseText "<t size='1.8' >Civilian Info</t>";
		_name = format ["<t align='left'>Name: %1</t>", [_civInfo,"Name"] call SpyderAddons_fnc_hashGet];
		_individualHostility = format ["<t align='left'>Individual Hostility: %1</t>", [_civInfo,"HostilityIndividual"] call SpyderAddons_fnc_hashGet];
		_townHostility = format ["<t align='left'>Town Hositility: %1</t>", [_civInfo,"HostilityTown"] call SpyderAddons_fnc_hashGet];

		_personalityTitle =  parseText "<t size='1.8'>Personality</t>";
		_bravery = format ["<t align='left'>Bravery: %1</t>", [_personality,"Bravery"] call SpyderAddons_fnc_hashGet]; 
		_aggressiveness = format ["<t align='left'>Aggressiveness: %1</t>", [_personality,"Aggressiveness"] call SpyderAddons_fnc_hashGet];
		_patience = format ["<t align='left'>Patience: %1</t>", [_personality,"Patience"] call SpyderAddons_fnc_hashGet];
		_indecisiveness = format ["<t align='left'>Indecisiveness: %1</t>", [_personality,"Indecisiveness"] call SpyderAddons_fnc_hashGet];

		_text = composeText [_civInfoTitle,
			lineBreak, 
			linebreak,
			parseText _name,
			linebreak,
			parseText _individualHostility,
			linebreak,
			parseText _townHostility,
			linebreak,
			linebreak,
			_personalityTitle,
			linebreak,
			parseText _bravery,
			linebreak,
			parseText _aggressiveness,
			linebreak,
			parseText _patience,
			linebreak,
			parseText _indecisiveness
		];

		hint _text;
	};

	case "addTopic": {
		([_logic,"Topics"] call SpyderAddons_fnc_hashGet) pushback _args; // [_position,_questionText,_questionData]
	};

	case "enableMain": {
		//-- Reset list two
		_listtwo = CIVINTERACT_LISTTWO;
		lbclear _listtwo;
		_listtwo ctrlshow false;

		//-- Clear list
		_listone = CIVINTERACT_LISTONE;
		lbClear _listone;

		//-- Build question list
		_index = _listone lbAdd "How are you?";
		_listone lbSetData [_index, "['HowAreYou', 1.5]"];

		_index = _listone lbAdd "Where do you live?";
		_listone lbSetData [_index, "['Home', 1.6]"];

		_index = _listone lbAdd "Have you seen any IED's in this area?";
		_listone lbSetData [_index, "['SeenAnyIEDs', 2]"];

		_index = _listone lbAdd "Have you seen any ... forces activity nearby?";
		_listone lbSetData [_index, "['SeenForces', 2, 'question','enemy']"];

		_index = _listone lbAdd "Do you know the location of any insurgent bases?";
		_listone lbSetData [_index, "['SeenBases', 2.5]"];

		_index = _listone lbAdd "Have you seen any strange behavior lately?";
		_listone lbSetData [_index, "['StrangeBehavior', 2.5]"];

		_index = _listone lbAdd "What is your opinion of .. forces?";
		_listone lbSetData [_index, "['ForcesOpinion', 2, 'question','all']"];

		_index = _listone lbAdd "What is the opinion of ... forces in this area?";
		_listone lbSetData [_index, "['TownOpinion', 2, 'question','all']"];

		_topics = [];
		{
			if ((_x select 0) distance (getPos player) < 300) then {
				_index = _listone lbAdd (_x select 1);
				_listone lbSetData [_index, (_x select 2)];
				_topics pushBack _x;
			};
		} forEach ([_logic,"Topics",[]] call SpyderAddons_fnc_hashGet); // [_position,_questionText,_questionData]

		[_logic,"Topics", _topics] call SpyderAddons_fnc_hashSet;

		//-- Add onSel EH to question list
		_listone ctrlRemoveAllEventHandlers "LBSelChanged";
		_listone ctrlAddEventHandler ["LBSelChanged",{[SpyderAddons_civilianInteraction,"mainListLBSelChanged", _this] call SpyderAddons_fnc_civilianInteraction}];
	};

	case "enableSubResponses": {
		_responses = _args;

		//-- Reset list two
		_listtwo = CIVINTERACT_LISTTWO;
		lbclear _listtwo;
		_listtwo ctrlshow false;

		//-- Clear list
		_listone = CIVINTERACT_LISTONE;
		lbClear _listone;

		//-- Add response selections
		{
			_index = _listone lbAdd (_x select 0);
			_listone lbsetData [_index,(_x select 1)];
		} foreach _responses;

		//-- Add back selection which enables the main question list
		_index = _listone lbAdd "Back";

		//-- Add onSel EH to question list
		_listone ctrlRemoveAllEventHandlers "LBSelChanged";
		_listone ctrlAddEventHandler ["LBSelChanged",{[SpyderAddons_civilianInteraction,"subResponsesLBSelChanged", _this] call SpyderAddons_fnc_civilianInteraction}];

		_listone lbSetCurSel 0;
	};

	case "mainListLBSelChanged": {
		private ["_forces"];
		_args params ["_control","_index"];
		_data = call compile (_control lbData _index);
		_data params ["_question","_askTime",["_dialogType","question"],["_forceOptions","none"]];

		_listtwo = CIVINTERACT_LISTTWO;
		_askQuestionCtrl = CIVINTERACT_ASKQUESTION;

		lbClear _listtwo;
		_listtwo lbSetCurSel -1;

		//-- Question requires force definition
		if (!isnil "_forceOptions" && _forceOptions != "none") then {
			private _forceHash = [_logic,"forces"] call SpyderAddons_fnc_hashGet;

			_listtwo ctrlShow true;
			_askQuestionCtrl ctrlShow false;

			switch (_forceOptions) do {
				case "friendly": {
					_forces = [_forceHash,"friendly"] call SpyderAddons_fnc_hashGet;
				};

				case "enemy": {
					_forces = [_forceHash,"enemy"] call SpyderAddons_fnc_hashGet;
				};

				case "all": {
					_forces = [+([_forceHash,"friendly"] call SpyderAddons_fnc_hashGet), [_forceHash,"enemy"] call SpyderAddons_fnc_hashGet] call SpyderAddons_fnc_hashAppend;
				};
			};

			//-- Populate list 2 with force options
			_keys = _forces select 1;
			{
				_index = _listtwo lbAdd (_x select 2 select 0);
				_listtwo lbSetData [_index, _keys select _forEachIndex];
			} forEach (_forces select 2);

			//-- Add onSel EH to question list
			_listtwo ctrlAddEventHandler ["LBSelChanged",{[SpyderAddons_civilianInteraction,"secondaryListLBSelChanged", _this] call SpyderAddons_fnc_civilianInteraction}];
		} else {
			_listtwo ctrlShow false;
			_askQuestionCtrl ctrlShow true;
		};

		//-- Switch ask question control text to fit the type of selected dialog
		switch (_dialogType) do {
			case "question": {
				//-- Question
				CIVINTERACT_ASKQUESTION ctrlSetText "Ask Question";
			};

			case "comment": {
				//-- Comment
				CIVINTERACT_ASKQUESTION ctrlSetText "Speak";
			};

			case "threat": {
				//-- Threat
				CIVINTERACT_ASKQUESTION ctrlSetText "Threaten Civilian";
			};
		};
	};

	//-- Cleanup function, too complex
	case "secondaryListLBSelChanged": {
		CIVINTERACT_ASKQUESTION ctrlShow true;
	};

	case "subResponsesLBSelChanged": {
		_args params ["_control","_index"];

		if (_control lbText _index == "Back") exitWith {
			//-- Back selected
			[_logic,"enableMain"] call MAINCLASS;
		};

		//-- Ask question
		_data = call compile (_control lbData _index);
		_data params ["_question","_askTime",["_dialogType","question"],"_forces"];

		_listtwo = CIVINTERACT_LISTTWO;
		lbClear _listtwo;
		_listtwo lbSetCurSel -1;

		//-- Question requires force definition
		if (!isnil "_forces" && _forces != "none") then {

			_listtwo ctrlShow true;
			CIVINTERACT_ASKQUESTION ctrlShow false;

			switch (_forces) do {
				case "friendly": {
					_forces = [_logic,"FriendlyForces",[]] call SpyderAddons_fnc_hashGet;
				};

				case "enemy": {
					_forces = [_logic,"EnemyForces",[]] call SpyderAddons_fnc_hashGet;
				};

				case "all": {
					_forces1 = [_logic,"FriendlyForces",[]] call SpyderAddons_fnc_hashGet;
					_forces2 = [_logic,"EnemyForces",[]] call SpyderAddons_fnc_hashGet;
					_forces = _forces1 + _forces2;
				};
			};

			//-- Populate list 2 with forces
			{
				_index = _listtwo lbAdd ((_x select 2) select 1);
				_listtwo lbSetData [_index,(_x select 2) select 0];
			} forEach _forces;

			//-- Add onSel EH to question list
			_listtwo ctrlAddEventHandler ["LBSelChanged",{[SpyderAddons_civilianInteraction,"secondaryListLBSelChanged", _this] call SpyderAddons_fnc_civilianInteraction}];
		} else {
			_listtwo ctrlShow false;
			CIVINTERACT_ASKQUESTION ctrlShow true;
		};

		//-- Switch ask question control text to fit the type of selected dialog
		switch (_dialogType) do {
			case "question": {
				//-- Question
				CIVINTERACT_ASKQUESTION ctrlSetText "Ask Question";
			};

			case "comment": {
				//-- Comment
				CIVINTERACT_ASKQUESTION ctrlSetText "Speak";
			};

			case "threat": {
				//-- Threat
				CIVINTERACT_ASKQUESTION ctrlSetText "Threaten Civilian";
			};
		};
	};

	case "prepQuestion": {
		_data = CIVINTERACT_LISTONE lbData (lbCurSel CIVINTERACT_LISTONE);
		_data = call compile _data;
		_data params ["_question","_askTime"];

		//-- disable ask control
		CIVINTERACT_ASKQUESTION ctrlEnable false;

		//-- animate progress bar
		INVENTORY_PROGRESSBARTITLE ctrlSetText "Speaking . . .";
		_bar = [_logic,"ProgressBar"] call SpyderAddons_fnc_hashGet;
		[_bar,_askTime] spawn SpyderAddons_fnc_progressAnimate;

		//-- Ask question after delay if menu is still open
		[_logic,"askQuestion", [_question,_askTime]] spawn MAINCLASS;
	};

	case "askQuestion": {
		private ["_responses"];
		_args params ["_question","_askTime"];

		//-- Wait until progress bar is filled
		sleep _askTime;

		_listone = CIVINTERACT_LISTONE;
		_listtwo = CIVINTERACT_LISTTWO;

		//-- Reset progress title
		INVENTORY_PROGRESSBARTITLE ctrlSetText "";

		//-- Enable ask control
		CIVINTERACT_ASKQUESTION ctrlEnable true;

		//-- Exit if menu has closed
		if (isnull (findDisplay 923)) exitWith {};

		if (ctrlShown _listtwo) then {
			//-- Ask question from list one, with force from list two
			_index = lbCurSel _listtwo;
			_force = _listtwo lbData _index;

			//-- Delete selected option
			_listtwo lbDelete _index;

			//-- If no more options in list two, delete question from list one
			if (lbSize _listtwo == 0) then {
				_listtwo ctrlShow false;
				_listone lbDelete (lbCurSel _listone);
			};

			_responses = [_logic,_question,_force] call SpyderAddons_fnc_getResponses;
		} else {
			_listone lbDelete (lbCurSel _listone);

			_responses = [_logic,_question] call SpyderAddons_fnc_getResponses;
		};

		_responses params ["_response","_additionalQuestions","_civInfoAdjustments"];

		//-- Display response
		CIVINTERACT_RESPONSEBOX ctrlSetText _response;

		//-- Check for followup questions
		if (count _additionalQuestions != 0) then {
			//-- Display additional questions/conversation topics
			[_logic,"enableSubResponses", _additionalQuestions] call MAINCLASS;
		};

		//-- Refresh list onLBSel EH
		if (lbCurSel _listone != -1) then {
			_listone lbSetCurSel (lbCurSel _listone);
		} else {
			if (lbSize _listone > 0) then {
				_listone lbSetCurSel 0;
			};
		};
	};



	case "isIrritated": {
		_args params ["_hostile","_asked","_civ"];

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
					_response = selectRandom [_response1, _response2, _response3, _response4, _response5];
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
					_response = selectRandom [_response1, _response2, _response3,_response4, _response5];
					CIVINTERACT_RESPONSELIST ctrlSetText ((ctrlText CIVINTERACT_RESPONSELIST) + _response);
				};
			};
		};
	};

	case "UpdateHostility": {
		//-- Change local civilian hostility
		private ["_townHostilityValue"];
		_args params ["_civ","_value"];
		if (count _args > 2) then {_townHostilityValue = _args select 2};

		if (isNil "_townHostilityValue") then {
			if (isNil {[SpyderAddons_civilianInteraction_Logic, "CurrentCivData"] call SpyderAddons_fnc_hashGet}) exitWith {};

			_civData = [SpyderAddons_civilianInteraction_Logic, "CurrentCivData"] call SpyderAddons_fnc_hashGet;
			_civInfo = ([_civData, "CivInfo", _civInfo] call SpyderAddons_fnc_hashGet) select 0;
			_civInfo params ["_homePos","_individualHostility","_townHostility"];

			_individualHostility = _individualHostility + _value;
			_townHostilityValue = floor random 4;
			_townHostility = _townHostility + _townHostilityValue;
			[_civData, "CivInfo", [[_homePos, _individualHostility, _townHostility]]] call SpyderAddons_fnc_hashSet;
			[SpyderAddons_civilianInteraction_Logic, "CurrentCivData", _civData] call SpyderAddons_fnc_hashSet;
		};

		//-- Change civilian posture globally
		if (isNil "_townHostilityValue") exitWith {["UpdateHostility", [_civ,_value,_townHostilityValue]] remoteExecCall ["SpyderAddons_fnc_civilianInteraction",2]};

		_civID = _civ getVariable ["agentID", ""];
		if (_civID != "") then {
			_civProfile = [ALIVE_agentHandler, "getAgent", _civID] call ALIVE_fnc_agentHandler;
			_clusterID = _civProfile select 2 select 9;

			//-- Set town hostility
			_cluster = [ALIVE_clusterHandler, "getCluster", _clusterID] call ALIVE_fnc_clusterHandler;
			_clusterHostility = [_cluster, "posture"] call SpyderAddons_fnc_hashGet;
			[_cluster, "posture", (_clusterHostility + _townHostilityValue)] call SpyderAddons_fnc_hashSet;

			//-- Set individual hostility
			_hostility = (_civProfile select 2) select 12;
			_hostility = _hostility + _value;
			[_civProfile, "posture", _hostility] call SpyderAddons_fnc_hashSet;
		};
	};

	case "getActivePlan": {
		_activeCommand = _args;

		switch (toLower _activeCommand) do {
			case "alive_fnc_cc_suicide": {
				_activePlan1 = "carrying out a suicide bombing";
				_activePlan2 = "strapping himself with explosives";
				_activePlan3 = "planning a bombing";
				_activePlan4 = "getting ready to bomb your forces";
				_activePlan5 = "about to bomb your forces";
				_result = selectRandom [_activePlan1,_activePlan2,_activePlan3,_activePlan4,_activePlan5];
			};
			case "alive_fnc_cc_suicidetarget": {
				_activePlan1 = "planning on carrying out a suicide bombing";
				_activePlan2 = "strapping himself with explosives";
				_activePlan3 = "planning a bombing";
				_activePlan4 = "getting ready to bomb your forces";
				_activePlan5 = "about to bomb your forces";
				_result = selectRandom [_activePlan1,_activePlan2,_activePlan3,_activePlan4,_activePlan5];
			};
			case "alive_fnc_cc_rogue": {
				_activePlan1 = "storing a weapon in his house";
				_activePlan2 = "stockpiling weapons";
				_activePlan3 = "planning on shooting a patrol";
				_activePlan4 = "looking for patrols to shoot at";
				_activePlan5 = "paid to shoot at your forces";
				_result = selectRandom [_activePlan1,_activePlan2,_activePlan3,_activePlan4,_activePlan5];
			};
			case "alive_fnc_cc_roguetarget": {
				_activePlan1 = "storing a weapon in his house";
				_activePlan2 = "stockpiling weapons";
				_activePlan3 = "planning on shooting a patrol";
				_activePlan4 = "looking for somebody to shoot at";
				_activePlan5 = "paid to shoot at your forces";
				_result = selectRandom [_activePlan1,_activePlan2,_activePlan3,_activePlan4,_activePlan5];
			};
			case "alive_fnc_cc_sabotage": {
				_activePlan1 = "planning on sabotaging a building";
				_activePlan2 = "blowing up a building";
				_activePlan3 = "planting explosives nearby";
				_activePlan4 = "getting ready to plant explosives";
				_activePlan5 = "paid to shoot at your forces";
				_result = selectRandom [_activePlan1,_activePlan2,_activePlan3,_activePlan4,_activePlan5];
			};
			case "alive_fnc_cc_getweapons": {
				_activePlan1 = "retrieving weapons from a nearby weapons depot";
				_activePlan2 = "planning on joining the insurgents";
				_activePlan3 = "getting ready to go to a nearby insurgent recruitment center";
				_activePlan4 = "getting ready to retrieve weapons from a cache";
				_activePlan5 = "paid to attack your forces";
				_activePlan6 = "forced to join the insurgents";
				_activePlan7 = "preparing to attack your forces";
				_result = selectRandom [_activePlan1,_activePlan2,_activePlan3,_activePlan4,_activePlan5];
			};
		};
	};

	case "Detain": {
		//-- Function is exactly the same as ALiVE arrest/release --> Author: Highhead
		_civ = [_logic, "Civ"] call SpyderAddons_fnc_hashGet;

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
		_civ = [_logic, "Civ"] call SpyderAddons_fnc_hashGet;

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
		_civ = [_logic, "Civ"] call SpyderAddons_fnc_hashGet;

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

	case "markIEDLocation": {
		_args params [
			["_pos", [0,0,0]],
			["_radius", 0],
			["_exact", false],
			["_size", 1.2]
		];

		//-- Get marker properties
		_pos = [_pos, _radius] call CBA_fnc_randPos;

		//-- Create marker
		if (_exact) then {
			_text = [str _pos,_pos,"ICON", [_size,_size],"ColorRed","Possible IED Location", "n_installation", "Solid",0,0.5] call ALIVE_fnc_createMarkerGlobal;
			_text spawn {sleep 60; deletemarker _this};
		} else {
			_marker = [str _pos, _pos, "ELLIPSE", [_size, _size], "ColorEAST", "", "n_installation", "FDiagonal", 0, 0.5] call ALIVE_fnc_createMarkerGlobal;
			_marker setMarkerAlpha .7;
			_text = [str (str _pos),_pos,"ICON", [0.1,0.1],"ColorRed","Possible IED Location", "mil_dot", "FDiagonal",0,0.5] call ALIVE_fnc_createMarkerGlobal;
			[_marker,_text] spawn {sleep 60; {deletemarker _x} foreach _this};
		};
	};

	case "markForceLocation": {
		_args params [
			["_faction",""],
			["_pos", [0,0,0]],
			["_size", 120]
		];

		//-- Exit if faction is undefined
		if (_faction == "") exitWith {["[Civilian Interaction]: markForceLocation - Force undefined"] call SpyderAddons_fnc_log};

		//-- Get faction display name
		_force = [_logic,"getForceByFaction", _faction] call MAINCLASS;
		_displayname = [_force,"displayName"] call SpyderAddons_fnc_hashGet;

		//-- Get marker properties
		_pos = [_pos, _size - 15] call CBA_fnc_randPos;
		_markertext = format ["Possible %1 troops", _displayname];

		//-- Create marker
		_marker = [str _pos, _pos, "ELLIPSE", [_size, _size], "ColorEAST", "", "n_installation", "FDiagonal", 0, 0.5] call ALIVE_fnc_createMarkerGlobal;
		_marker setMarkerAlpha .7;
		_text = [str (str _pos),_pos,"ICON", [0.1,0.1],"ColorRed",_markertext, "mil_dot", "FDiagonal",0,0.5] call ALIVE_fnc_createMarkerGlobal;
		[_marker,_text] spawn {sleep 60; {deletemarker _x} foreach _this};
	};

	case "markInstallationLocation": {
		_args params [
			["_text", "Possible insurgent base"],
			["_pos", [0,0,0]],
			["_exact", false],
			["_radius", 0],
			["_size", 1.2]
		];

		//-- Get marker properties
		_pos = [_pos, _radius] call CBA_fnc_randPos;

		//-- Create marker
		if (_exact) then {
			_text = [str _pos,_pos,"ICON", [_size,_size],"ColorRed","Possible IED Location", "n_installation", "Solid",0,0.5] call ALIVE_fnc_createMarkerGlobal;
			_text spawn {sleep 60; deletemarker _this};
		} else {
			_marker = [str _pos, _pos, "ELLIPSE", [_size, _size], "ColorEAST", "", "n_installation", "FDiagonal", 0, 0.5] call ALIVE_fnc_createMarkerGlobal;
			_marker setMarkerAlpha .7;
			_text = [str (str _pos),_pos,"ICON", [0.1,0.1],"ColorRed","Possible IED Location", "mil_dot", "FDiagonal",0,0.5] call ALIVE_fnc_createMarkerGlobal;
			[_marker,_text] spawn {sleep 60; {deletemarker _x} foreach _this};
		};
	};

};

//-- Return result if any exists
if (!isNil "_result") then {_result} else {nil};