#include <\x\spyderaddons\addons\mil_insurgency\script_component.hpp>

/* ----------------------------------------------------------------------------
Function: SpyderAddons_fnc_insurgencyBoard

Description:
Main handler for the insurgency command board

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
disableSerialization;

//-- Define Functions
#define MAINCLASS SpyderAddons_fnc_commandBoard
#define INSURGENCY SpyderAddons_fnc_insurgency

//-- Define control ID's
#define COMMANDBOARD_DIALOG "Command_Board"
#define COMMANDBOARD_DISPLAY (findDisplay 9200)
#define COMMANDBOARD_FACTIONLOGO 9203
#define COMMANDBOARD_MAINMENU 9202
#define COMMANDBOARD_SECONDARYMENU 9206
#define COMMANDBOARD_MAP 9201
#define COMMANDBOARD_BACKBUTTON 9204
#define COMMANDBOARD_BACKSECONDARY 9207
#define COMMANDBOARD_MAINMENUCONTROL (findDisplay 9200 displayCtrl 9202)
#define COMMANDBOARD_SECONDARYMENUCONTROL (findDisplay 9200 displayCtrl 9206)


switch (_operation) do {

	case "create": {
		_result = [] call ALiVE_fnc_hashCreate;
	};

	case "init": {
		if (isServer) then {
			[_logic,"class", MAINCLASS] call ALiVE_fnc_hashSet;
			[_logic,"debug",false] call ALIVE_fnc_hashSet;
			[_logic,"recentevents",[]] call ALiVE_fnc_hashSet;

			//--start listening for events
			[_logic,"listen"] spawn MAINCLASS;

			//-- Initialize event cleaner
			[_logic,"eventCleaner", [300,30]] call MAINCLASS;
		};
	};

	case "debug": {
		if (typeName _arguments != "BOOL") then {
			_arguments = [_logic,"debug"] call ALIVE_fnc_hashGet;
		} else {
			[_logic,"debug",_arguments] call ALIVE_fnc_hashSet;
		};

		_result = _arguments;
	};

	case "sides": {
		if (typeName _arguments == "ARRAY") then {
			if (count _arguments > 0) then {
				[_logic,"sides",_arguments] call ALIVE_fnc_hashSet;
			} else {
				_arguments = [_logic,"sides"] call ALIVE_fnc_hashGet;
			};
		};

		_result = _arguments;
	};

	case "listen": {
		waituntil {!isNil "ALIVE_profileSystemInit"};
		_listenerID = [ALIVE_eventLog, "addListener",[_logic, [
			"OPCOM_RESERVE",
			"OPCOM_CAPTURE",
			"OPCOM_TERRORIZE",
			"OPCOM_RECON",
			"OPCOM_DEFEND",
			"SA_Insurgency"
		]]] call ALIVE_fnc_eventLog;
		[_logic,"listenerID", _listenerID] call ALiVE_fnc_hashSet;
	};

	case "eventCleaner": {
		_arguments params ["_deleteTime","_delay"];

		[{
			private ["_events"];
			params ["_arguments"];
			_arguments params ["_deleteTime"];

			_events = [SpyderAddons_CommandBoard_Handler, "recentevents",[]] call ALiVE_fnc_hashGet;
			{
				_retrievedTime = _x select 1;
				if ((time - _retrievedTime) >= _deleteTime) then {
					_events = _events - [_x];
				};
			} forEach _events;

			_recentEvents = [SpyderAddons_CommandBoard_Handler, "recentevents",_events] call ALiVE_fnc_hashSet;
		}, _delay, [_deleteTime]] call CBA_fnc_addPerFrameHandler;
	};

	case "open": {
		CreateDialog COMMANDBOARD_DIALOG;

		[nil,"onLoad"] call MAINCLASS;
	};

	case "onLoad": {

		///////-- showGPS false;

		lbAdd [COMMANDBOARD_MAINMENU, "Recent Events"];
		lbAdd [COMMANDBOARD_MAINMENU, "Installations"];
		lbAdd [COMMANDBOARD_MAINMENU, "Insurgent Groups"];

		_factionIcon = getText (configFile >> "CfgFactionClasses" >> (faction player) >> "icon");
		ctrlSetText [COMMANDBOARD_FACTIONLOGO, _factionIcon];

		SpyderAddons_CommandBoard_Temp = [] call ALiVE_fnc_hashCreate;

		[nil,"enableMainMenu"] call MAINCLASS;
	};

	case "unLoad": {
		[nil,"clearMarkers"] call MAINCLASS;
		[nil,"clearObjectiveMarkers"] call MAINCLASS;
		SpyderAddons_CommandBoard_Temp = nil;
	};
	
	case "enableLoading": {
		(COMMANDBOARD_DISPLAY displayCtrl COMMANDBOARD_MAINMENU) ctrlRemoveAllEventHandlers "LBSelChanged";
		lbClear COMMANDBOARD_MAINMENU;
		lbAdd [COMMANDBOARD_MAINMENU, "Loading . . ."];
	};

	case "clearMarkers": {
		{deleteMarker _x} forEach ([SpyderAddons_CommandBoard_Temp,"markers"] call ALiVE_fnc_hashGet);
	};

	case "clearObjectiveMarkers": {
		{deleteMarker _x} forEach ([SpyderAddons_CommandBoard_Temp,"ObjectiveMarkers"] call ALiVE_fnc_hashGet);
	};
	
	case "enableBackButton": {
		_state = _arguments;
		ctrlShow [COMMANDBOARD_BACKBUTTON, _state];
	};

	case "enableMainMenu": {
		(COMMANDBOARD_DISPLAY displayCtrl COMMANDBOARD_MAINMENU) ctrlRemoveAllEventHandlers "LBSelChanged";
		[nil,"enableBackButton", false] call MAINCLASS;
		ctrlShow [COMMANDBOARD_BACKSECONDARY, false];

		lbClear COMMANDBOARD_MAINMENU;
		lbAdd [COMMANDBOARD_MAINMENU, "Operations Overview"];
		lbAdd [COMMANDBOARD_MAINMENU, "Installations"];
		lbAdd [COMMANDBOARD_MAINMENU, "Insurgent Groups"];

		lbClear COMMANDBOARD_SECONDARYMENU;
		COMMANDBOARD_SECONDARYMENUCONTROL ctrlRemoveAllEventHandlers "LBSelChanged";
		ctrlShow [COMMANDBOARD_BACKSECONDARY, false];
		buttonSetAction [COMMANDBOARD_BACKSECONDARY, ""];

		(COMMANDBOARD_DISPLAY displayCtrl COMMANDBOARD_MAINMENU)  ctrlAddEventHandler ["LBSelChanged",{

			params ["_control","_index"];
			switch (str (_index)) do {
				case "0": {
					[nil,"enableLoading"] call SpyderAddons_fnc_commandBoard;
					[nil,"getEvents", player] remoteExecCall ["SpyderAddons_fnc_commandBoard",2]
				};
				case "1": {
					[nil,"enableLoading"] call SpyderAddons_fnc_commandBoard;
					[nil,"getInstallations", player] remoteExecCall ["SpyderAddons_fnc_commandBoard",2];
				};
				case "2": {
					[nil,"enableLoading"] call SpyderAddons_fnc_commandBoard;
					[nil,"getGroups", player] remoteExecCall ["SpyderAddons_fnc_commandBoard",2];
				};
			};
		}];
	};

	case "getEvents": {
		_player = _arguments;
		_events = [SpyderAddons_CommandBoard_Handler, "recentevents",[]] call ALiVE_fnc_hashGet;
		[nil,"enableRecentEvents",_events] remoteExecCall [QUOTE(MAINCLASS),_player];
	};

	case "enableRecentEvents": {
		private ["_message","_pos"];
		_events = _arguments;

		lbClear COMMANDBOARD_MAINMENU;
		{
			_event = _x;
			_type = _event select 0;
			_data = _event select 2;
			_pos = _data select 0;
			
			switch (_type) do {
				case "OPCOM_RESERVE": {
					_message = "Insurgents capturing area";
				};
				case "OPCOM_CAPTURE": {
					_message1 = "Insurgents assaulting area";
				};
				case "OPCOM_TERRORIZE": {
					_message = "Insurgents terrorizing objective";
				};
				case "OPCOM_RECON": {
					_message1 = "Insurgents planning ambush";
					_message2 = "Ambush underway";
					_message3 = "Insurgents setting up ambush point";
					_message = [_message1,_message2,_message3] call BIS_fnc_selectRandom;

					_ambush = [[],"convertObject",[_objective,"ambush",[]] call ALiVE_fnc_HashGet] call ALiVE_fnc_OPCOM;
					_pos = getPosATL _ambush;
				};
				case "OPCOM_DEFEND": {
					_message1 = "Retreat issued for units in this sector";
					_message2 = "Insurgents retreating";
					_message = [_message1,_message2] call BIS_fnc_selectRandom;
				};
				case "INSTALLATION_CREATED": {
					_installation = _data select 1;
					_objective = _data select 2;
					_message = format ["%1 Created", _installation];
				};
				case "HQ_RECRUIT": {
					_pos = getPosATL (_data select 1);
					_message1 = "Group recruited from recruitment HQ";
					_message2 = "Insurgent group recruited";
					_message3 = "Recruitment HQ recruited group";
					_message = [_message1,_message2,_message3] call BIS_fnc_selectRandom;
				};
			};

			lbAdd [COMMANDBOARD_MAINMENU, _message];
			lbSetData [COMMANDBOARD_MAINMENU, _forEachIndex, str _pos];
		} forEach _events;
		
		[nil,"enableBackButton",true] call MAINCLASS;
		buttonSetAction [COMMANDBOARD_BACKBUTTON, "[nil,'enableMainMenu'] call SpyderAddons_fnc_commandBoard"];

		(COMMANDBOARD_DISPLAY displayCtrl COMMANDBOARD_MAINMENU)  ctrlAddEventHandler ["LBSelChanged",{
			disableSerialization;
			params ["_control","_index"];
			_data = lbData [COMMANDBOARD_MAINMENU,_index];
			_pos = call compile _data;
			_map = (COMMANDBOARD_DISPLAY displayCtrl COMMANDBOARD_MAP);

			ctrlMapAnimClear _map;
			_map ctrlMapAnimAdd [.3, ctrlMapScale _map, _pos];
			ctrlMapAnimCommit _map;
		}];
	};

	case "getInstallations": {
		_player = _arguments;
		_opcom = ([faction _player] call SpyderAddons_fnc_getOpcoms) select 0;
		_objectives = [_opcom,"objectives",[]] call ALiVE_fnc_hashGet;

		_HQArray = [];
		_depotArray = [];
		_factoryArray = [];
		_ambushArray = [];
		_sabotageArray = [];
		_iedArray = [];
		_suicideArray = [];
		_roadblockArray = [];

		{
			_objective = _x;
			_size = [_objective,"size"] call ALiVE_fnc_HashGet;

			_HQ = [_OPCOM_HANDLER,"convertObject",[_objective,"HQ",[]] call ALiVE_fnc_HashGet] call ALiVE_fnc_OPCOM;
			_depot = [_OPCOM_HANDLER,"convertObject",[_objective,"depot",[]] call ALiVE_fnc_HashGet] call ALiVE_fnc_OPCOM;
			_factory = [_OPCOM_HANDLER,"convertObject",[_objective,"factory",[]] call ALiVE_fnc_HashGet] call ALiVE_fnc_OPCOM;
			_sabotage = [_OPCOM_HANDLER,"convertObject",[_objective,"sabotage",[]] call ALiVE_fnc_HashGet] call ALiVE_fnc_OPCOM;
			_ied = [_OPCOM_HANDLER,"convertObject",[_objective,"ied",[]] call ALiVE_fnc_HashGet] call ALiVE_fnc_OPCOM;
			_suicide = [_OPCOM_HANDLER,"convertObject",[_objective,"suicide",[]] call ALiVE_fnc_HashGet] call ALiVE_fnc_OPCOM;
			_ambush = [_OPCOM_HANDLER,"convertObject",[_objective,"ambush",[]] call ALiVE_fnc_HashGet] call ALiVE_fnc_OPCOM;
			_roadblock = [_OPCOM_HANDLER,"convertObject",[_objective,"roadblocks",[]] call ALiVE_fnc_HashGet] call ALiVE_fnc_OPCOM;

			if (alive _HQ) then {_HQArray pushBack (getPosATL _HQ)};
			if (alive _depot) then {_depotArray pushBack (getPosATL _depot)};
			if (alive _factory) then {_factoryArray pushBack (getPosATL _factory)};
			if (alive _ambush) then {_ambushArray pushBack(getPosATL _ambush)};
			if (alive _sabotage) then {_sabotageArray pushBack (getPosATL _sabotage)};
			if (alive _ied) then {_iedArray pushBack [getPosATL _ied,_size]};
			if (alive _suicide) then {_suicideArray pushBack [getPosATL _suicide,_size]};
			if (alive _roadblock) then {_roadblockArray pushBack [getPosATL _roadblock,_size]};
		} forEach _objectives;

		_installations = [_HQArray,_depotArray,_factoryArray,_ambushArray,_sabotageArray,_iedArray,_suicideArray,_roadblockArray];
		[nil,"enableInstallations",_installations] remoteExecCall [QUOTE(MAINCLASS),_player]
	};
	
	case "enableInstallations": {
		private ["_index"];
		_installations = _arguments;
		_installations params ["_HQ","_depot","_factory","_ambush","_sabotage","_IED","_suicide","_roadblocks"];
		_markers = [];
		_index = 0;

		lbClear COMMANDBOARD_MAINMENU;
		{
			_pos = _x;
			lbAdd [COMMANDBOARD_MAINMENU, "Recruitment HQ"];
			lbSetData [COMMANDBOARD_MAINMENU, _index, str _pos];
			_index = _index + 1;

			_marker = [str _pos,_pos,"ICON", [0.5,0.5],"ColorRed","Recruitment HQ", "n_installation", "FDiagonal",0,0.5] call ALIVE_fnc_createMarker;
			_markers pushBack _marker;
		} forEach _HQ;

		{
			_pos = _x;
			lbAdd [COMMANDBOARD_MAINMENU, "Munitions Depot"];
			lbSetData [COMMANDBOARD_MAINMENU, _index, str _pos];
			_index = _index + 1;

			_marker = [str _pos,_pos,"ICON", [0.5,0.5],"ColorRed","Munitions Depot", "n_installation", "FDiagonal",0,0.5] call ALIVE_fnc_createMarker;
			_markers pushBack _marker;
		} forEach _depot;

		{
			_pos = _x;
			lbAdd [COMMANDBOARD_MAINMENU, "IED Factory"];
			lbSetData [COMMANDBOARD_MAINMENU, _index, str _pos];
			_index = _index + 1;

			_marker = [str _pos,_pos,"ICON", [0.5,0.5],"ColorRed","IED Factory", "n_installation", "FDiagonal",0,0.5] call ALIVE_fnc_createMarker;
			_markers pushBack _marker;
		} forEach _factory;

		{
			_pos = _x;
			lbAdd [COMMANDBOARD_MAINMENU, "Ambush"];
			lbSetData [COMMANDBOARD_MAINMENU, _index, str _pos];
			_index = _index + 1;

			_marker = [str _pos,_pos,"ICON", [0.5,0.5],"ColorRed","Ambush", "n_installation", "FDiagonal",0,0.5] call ALIVE_fnc_createMarker;
			_markers pushBack _marker;
		} forEach _ambush;

		{
			_pos = _x;
			lbAdd [COMMANDBOARD_MAINMENU, "Sabotage"];
			lbSetData [COMMANDBOARD_MAINMENU, _index, str _pos];
			_index = _index + 1;

			_marker = [str _pos,_pos,"ICON", [0.5,0.5],"ColorRed","Sabotage", "n_installation", "FDiagonal",0,0.5] call ALIVE_fnc_createMarker;
			_markers pushBack _marker;
		} forEach _sabotage;

		{
			_x params ["_pos","_size"];
			lbAdd [COMMANDBOARD_MAINMENU, "IED's"];
			lbSetData [COMMANDBOARD_MAINMENU, _index, str _pos];
			_index = _index + 1;

			_marker1 = [str _pos,_pos,"ELLIPSE", [_size,_size],"ColorRed","IED's", "n_installation", "FDiagonal",0,0.5] call ALIVE_fnc_createMarker;
			_marker2 = [str (str _pos),"ICON", [0.1,0.1],"ColorRed","IED's", "mil_dot", "FDiagonal",0,0.5 ] call ALIVE_fnc_createMarker;
			_markers pushBack _marker1;
			_markers pushBack _marker2;
		} forEach _IED;

		{
			_x params ["_pos","_size"];
			lbAdd [COMMANDBOARD_MAINMENU, "Suicide Bombers"];
			lbSetData [COMMANDBOARD_MAINMENU, _index, str _pos];
			_index = _index + 1;

			_marker1 = [str _pos,_pos,"ELLIPSE", [_size,_size],"ColorRed","Suicide Bombers", "n_installation", "FDiagonal",0,0.5] call ALIVE_fnc_createMarker;
			_marker2 = [str (str _pos),"ICON", [0.1,0.1],"ColorRed","Suicide Bombers", "mil_dot", "FDiagonal",0,0.5 ] call ALIVE_fnc_createMarker;
			_markers pushBack _marker1;
			_markers pushBack _marker2;
		} forEach _suicide;

		{
			_x params ["_pos","_size"];
			lbAdd [COMMANDBOARD_MAINMENU, "Roadblocks"];
			lbSetData [COMMANDBOARD_MAINMENU, _index, str _pos];
			_index = _index + 1;

			_marker1 = [str _pos,_pos,"ELLIPSE", [400,400],"ColorRed","Roadblocks", "n_installation", "FDiagonal",0,0.5] call ALIVE_fnc_createMarker;
			_marker2 = [str (str _pos),_pos,"ICON", [0.1,0.1],"ColorRed","Roadblocks", "mil_dot", "FDiagonal",0,0.5 ] call ALIVE_fnc_createMarker;
			_markers pushBack _marker1;
			_markers pushBack _marker2;
		} forEach _roadblocks;

		[SpyderAddons_CommandBoard_Temp,"markers",_markers] call ALiVE_fnc_hashSet;

		[nil,"enableBackButton",true] call MAINCLASS;
		buttonSetAction [COMMANDBOARD_BACKBUTTON, "
			[nil,'clearMarkers'] call SpyderAddons_fnc_commandBoard;
			[nil,'enableMainMenu'] call SpyderAddons_fnc_commandBoard;
		"];

		(COMMANDBOARD_DISPLAY displayCtrl COMMANDBOARD_MAINMENU)  ctrlAddEventHandler ["LBSelChanged",{
			disableSerialization;
			params ["_control","_index"];
			_data = lbData [COMMANDBOARD_MAINMENU,_index];
			_pos = call compile _data;
			_map = (COMMANDBOARD_DISPLAY displayCtrl COMMANDBOARD_MAP);

			ctrlMapAnimClear _map;
			_map ctrlMapAnimAdd [.3, ctrlMapScale _map, _pos];
			ctrlMapAnimCommit _map;
		}];
	};

	case "getGroups": {
		_player  = _arguments;
		_profileIDs = [ALIVE_profileHandler, "getProfilesByFaction", faction _player] call ALIVE_fnc_profileHandler;
		_profiles = [ALIVE_profileHandler, "profiles"] call ALIVE_fnc_hashGet;
		_profileData = [];

		{
			_profileID = _x;
			_profile = [_profiles, _profileID] call ALIVE_fnc_hashGet;
			_isPlayer = [_profile,"isPlayer"] call ALiVE_fnc_hashGet;

			if !(_isPlayer) then {
				_pos =  [_profile,"position"] call ALIVE_fnc_hashGet;
				_count = [_profile,"unitCount"] call ALIVE_fnc_hashGet;
				_busy = [_profile,"busy"] call ALiVE_fnc_hashGet;

				_profileData pushBack [_profileID,_pos,_count,_busy];
			};
		} forEach _profileIDs;

		[nil,"enableGroups",_profileData] remoteExecCall [QUOTE(MAINCLASS),_player];
	};
	
	case "enableGroups": {
		private ["_color","_prefix"];
		_profileData = _arguments;
		_markers = [];

		switch (playerSide) do {
			case west: {
				_color = "ColorWEST";
				_prefix = "b";
			};
			case east: {
				_color = "ColorEAST";
				_prefix = "o";
			};
			case guer: {
				_color = "ColorGUER";
				_prefix = "n";
			};
			case civilian: {
				_color = "ColorYellow";
				_prefix = "n";
			};
			default {
				_color = "ColorYellow";
				_prefix = "n";
			};
		};

		lbClear COMMANDBOARD_MAINMENU;
		{
			_x params ["_profileID","_pos","_count","_busy"];

			_entityNumber = [_profileID, "_"] call CBA_fnc_split;
			_entityNumber = _entityNumber select ((count _entityNumber) - 1);
			_name = format ["Insurgent Group %1", _entityNumber];

			_markerName = format ["%1", _entityNumber];
			_markerText = format ["e%1", _entityNumber];
			_markerType = format ["%1_inf", _prefix];
			_marker = [_markerName, _pos, ICON, [0.7,0.7], _color, _markerText,_markerType, "Solid", 0, .7] call ALiVE_fnc_createMarker;
			_markers pushBack _marker;

			lbAdd [COMMANDBOARD_MAINMENU, _name];
			_data = str [_profileID,_pos,_count,_busy];
			lbSetData [COMMANDBOARD_MAINMENU, _forEachIndex, _data];
		} forEach _profileData;

		[SpyderAddons_CommandBoard_Temp,"markers",_markers] call ALiVE_fnc_hashSet;

		[nil,"enableBackButton",true] call MAINCLASS;
		buttonSetAction [COMMANDBOARD_BACKBUTTON, "
			[nil,'clearMarkers'] call SpyderAddons_fnc_commandBoard;
			[nil,'enableMainMenu'] call SpyderAddons_fnc_commandBoard;
		"];

		(COMMANDBOARD_DISPLAY displayCtrl COMMANDBOARD_MAINMENU)  ctrlAddEventHandler ["LBSelChanged",{
			disableSerialization;
			params ["_control","_index"];
			_data = lbData [COMMANDBOARD_MAINMENU,_index];
			_data = call compile _data;
			_data params ["_profileID","_pos","_count","_busy"];
			_map = (COMMANDBOARD_DISPLAY displayCtrl COMMANDBOARD_MAP);

			[nil,"groupSelected"] call SpyderAddons_fnc_commandBoard;

			ctrlMapAnimClear _map;
			_map ctrlMapAnimAdd [.3, ctrlMapScale _map, _pos];
			ctrlMapAnimCommit _map;
		}];
	};

	case "groupSelected": {
		lbClear COMMANDBOARD_SECONDARYMENU;
		lbAdd [COMMANDBOARD_SECONDARYMENU, "View Group Details"];
		lbAdd [COMMANDBOARD_SECONDARYMENU, "Command Group"];

		ctrlShow [COMMANDBOARD_BACKSECONDARY, false];
		buttonSetAction [COMMANDBOARD_BACKSECONDARY, ""];

		(COMMANDBOARD_DISPLAY displayCtrl COMMANDBOARD_SECONDARYMENU)  ctrlAddEventHandler ["LBSelChanged",{
			params ["_control","_index"];

			switch (str _index) do {
				case "0": {[nil, "showGroupDetails"] call SpyderAddons_fnc_commandBoard};
				case "1": {[nil, "enableCommandGroup"] call SpyderAddons_fnc_commandBoard};
			};
		}];
	};

	case "showGroupDetails": {
		_index = lbCurSel COMMANDBOARD_MAINMENU;
		_data = lbData [COMMANDBOARD_MAINMENU,_index];
		_data = call compile _data;
		_data params ["_profileID","_pos","_count","_busy"];

		lbClear COMMANDBOARD_SECONDARYMENU;
		COMMANDBOARD_SECONDARYMENUCONTROL ctrlRemoveAllEventHandlers "LBSelChanged";

		_count = format ["Units in Group: %1", _count];
		lbAdd [COMMANDBOARD_SECONDARYMENU, _count];

		_busy = format ["Currently Tasked: %1", _busy];
		lbAdd [COMMANDBOARD_SECONDARYMENU, _busy];

		ctrlShow [COMMANDBOARD_BACKSECONDARY, true];
		buttonSetAction [COMMANDBOARD_BACKSECONDARY, "[nil,'groupSelected'] call SpyderAddons_fnc_commandBoard"];
	};

	case "enableCommandGroup": {
		_index = lbCurSel COMMANDBOARD_MAINMENU;
		_data = lbData [COMMANDBOARD_MAINMENU,_index];
		_data = call compile _data;
		_data params ["_profileID","_pos","_count","_busy"];

		lbClear COMMANDBOARD_SECONDARYMENU;
		COMMANDBOARD_SECONDARYMENUCONTROL ctrlRemoveAllEventHandlers "LBSelChanged";

		lbAdd [COMMANDBOARD_SECONDARYMENU, "Assault Objective"];
		lbAdd [COMMANDBOARD_SECONDARYMENU, "Setup Ambush"];
		lbAdd [COMMANDBOARD_SECONDARYMENU, "Plant IED's"];
		lbAdd [COMMANDBOARD_SECONDARYMENU, "Recruit Suicide Bombers"];

		lbSetData [COMMANDBOARD_SECONDARYMENU, 1, "Assault"];
		lbSetData [COMMANDBOARD_SECONDARYMENU, 2, "Ambush"];
		lbSetData [COMMANDBOARD_SECONDARYMENU, 3, "IED"];
		lbSetData [COMMANDBOARD_SECONDARYMENU, 4, "Suicide"];

		COMMANDBOARD_SECONDARYMENUCONTROL  ctrlAddEventHandler ["LBSelChanged",{
			params ["_control","_index"];
			_data = lbData [COMMANDBOARD_SECONDARYMENU,_index];
			[SpyderAddons_CommandBoard_Temp, "currentOrder", _data] call ALiVE_fnc_hashSet;
			[nil,"markObjectives", player] remoteExecCall ["SpyderAddons_fnc_commandBoard",2]
		}];

		ctrlShow [COMMANDBOARD_BACKSECONDARY, true];
		buttonSetAction [COMMANDBOARD_BACKSECONDARY, "[nil,'groupSelected'] call SpyderAddons_fnc_commandBoard"];
	};

	case "markObjectives": {
		_player = _arguments;
		_opcom = ([faction _player] call SpyderAddons_fnc_getOpcoms) select 0;
		_objectives = [_opcom,"objectives"] call ALiVE_fnc_hashGet;
		_data = [];

		{
			_pos = [_x,"center"] call ALiVE_fnc_hashGet;
			_size = [_x,"size"] call ALiVE_fnc_hashGet;
			_data pushBack [_pos,_size];
		} forEach _objectives;

		[nil,"enableObjectiveDisplay", _data] remoteExecCall [QUOTE(MAINCLASS),2];
	};

	case "enableObjectiveDisplay": {
		private ["_color"];
		_objectives = _arguments;
		_markers = [];

		switch (playerSide) do {
			case west: {_color = "ColorWEST"};
			case east: {_color = "ColorEAST"};
			case guer: {_color = "ColorGUER"};
			case civilian: {_color = "ColorYellow"};
			default {_color = "ColorYellow"};
		};

		{
			_x params ["_pos","_size"];
			_marker = createMarkerLocal [str _pos, _pos];
			_marker setMarkerShapeLocal "ELLIPSE";
			_marker setMarkerSizeLocal [_size, _size];
			_marker setMarkerColorLocal _color;
			_marker setMarkerTypeLocal "Empty";
			_marker setMarkerBrushLocal "FDiagonal";

			_markers pushBack _marker;
		} forEach _objectives;

		[SpyderAddons_CommandBoard_Temp,"ObjectiveMarkers",_markers] call ALiVE_fnc_hashSet;

		buttonSetAction [COMMANDBOARD_BACKSECONDARY, "
			[nil,'clearObjectiveMarkers'] call SpyderAddons_fnc_commandBoard;
			[nil,'enableCommandGroup'] call SpyderAddons_fnc_commandBoard;
		"];
	};

	case "handleEvent": {
		private["_event","_type","_eventData"];

		if (typeName _arguments == "ARRAY") then {
			_event = _arguments;
			_type = [_event, "type"] call ALIVE_fnc_hashGet;
			_eventData = [_event, "data"] call ALIVE_fnc_hashGet;

			[_logic, _type, _eventData] call MAINCLASS;
		};
	};

	case "OPCOM_RESERVE": {
		_eventData = _arguments;
		_eventData params ["_side","_objective"];
		_debug = [_logic,"debug"] call ALiVE_fnc_hashGet;

		if (_side in ([SpyderAddons_CommandBoard_Handler, "sides"] call ALiVE_fnc_hashGet)) then {

			_position = [_objective, "center"] call ALiVE_fnc_hashGet;
			_data = [_operation, time,[_position,_objective]];
			_recentEvents = [_logic,"recentevents",[]] call ALiVE_fnc_hashGet;
			_recentEvents pushBack _data;
			[_logic,"recentevents",_recentEvents] call ALiVE_fnc_hashSet;

			//-- Makeshift EH since XEH doesn't work with mapboard
			_size = [_objective,"size"] call ALiVE_fnc_hashGet;
			_boards = _position nearObjects ["Land_MapBoard_F", _size];
			{
				if !(_x getVariable ["SA_ActionAdded",false]) then {
					_x addAction ["View Command Board",{[nil,"open"] call SpyderAddons_fnc_commandBoard}];
					_x setVariable ["SA_ActionAdded", true];
				};
			} forEach _boards;

			if (_debug) then {
				["[SpyderAddons - Command Board]: %1 Event Received", _operation] call SpyderAddons_fnc_log;
				_eventData call ALiVE_fnc_inspectArray;
			};
		};
	};

	case "OPCOM_CAPTURE": {
		_eventData = _arguments;
		_eventData params ["_side","_objective"];
		_debug = [_logic,"debug"] call ALiVE_fnc_hashGet;

		if (_side in ([SpyderAddons_CommandBoard_Handler, "sides"] call ALiVE_fnc_hashGet)) then {

			_position = [_objective, "center"] call ALiVE_fnc_hashGet;
			_data = [_operation, time,[_position,_objective]];
			_recentEvents = [_logic,"recentevents",[]] call ALiVE_fnc_hashGet;
			_recentEvents pushBack _data;
			[_logic,"recentevents",_recentEvents] call ALiVE_fnc_hashSet;

			if (_debug) then {
				["[SpyderAddons - Command Board]: %1 Event Received", _operation] call SpyderAddons_fnc_log;
				_eventData call ALiVE_fnc_inspectArray;
			};
		};
	};

	case "OPCOM_TERRORIZE": {
		_eventData = _arguments;
		_eventData params ["_side","_objective"];
		_debug = [_logic,"debug"] call ALiVE_fnc_hashGet;

		if (_side in ([SpyderAddons_CommandBoard_Handler, "sides"] call ALiVE_fnc_hashGet)) then {

			_position = [_objective, "center"] call ALiVE_fnc_hashGet;
			_data = [_operation, time,[_position,_objective]];
			_recentEvents = [_logic,"recentevents",[]] call ALiVE_fnc_hashGet;
			_recentEvents pushBack _data;
			[_logic,"recentevents",_recentEvents] call ALiVE_fnc_hashSet;

			if (_debug) then {
				["[SpyderAddons - Command Board]: %1 Event Received", _operation] call SpyderAddons_fnc_log;
				_eventData call ALiVE_fnc_inspectArray;
			};
		};
	};

	case "OPCOM_RECON": {
		_eventData = _arguments;
		_eventData params ["_side","_objective"];
		_debug = [_logic,"debug"] call ALiVE_fnc_hashGet;

		if (_side in ([SpyderAddons_CommandBoard_Handler, "sides"] call ALiVE_fnc_hashGet)) then {

			_position = [_objective, "center"] call ALiVE_fnc_hashGet;
			_data = [_operation, time,[_position,_objective]];
			_recentEvents = [_logic,"recentevents",[]] call ALiVE_fnc_hashGet;
			_recentEvents pushBack _data;
			[_logic,"recentevents",_recentEvents] call ALiVE_fnc_hashSet;

			if (_debug) then {
				["[SpyderAddons - Command Board]: %1 Event Received", _operation] call SpyderAddons_fnc_log;
				_eventData call ALiVE_fnc_inspectArray;
			};
		};
	};

	case "OPCOM_DEFEND": {
		_eventData = _arguments;
		_eventData params ["_side","_objective"];
		_debug = [_logic,"debug"] call ALiVE_fnc_hashGet;

		if (_side in ([SpyderAddons_CommandBoard_Handler, "sides"] call ALiVE_fnc_hashGet)) then {

			_position = [_objective, "center"] call ALiVE_fnc_hashGet;
			_data = [_operation, time,[_position,_objective]];
			_recentEvents = [_logic,"recentevents",[]] call ALiVE_fnc_hashGet;
			_recentEvents pushBack _data;
			[_logic,"recentevents",_recentEvents] call ALiVE_fnc_hashSet;

			if (_debug) then {
				["[SpyderAddons - Command Board]: %1 Event Received", _operation] call SpyderAddons_fnc_log;
				_eventData call ALiVE_fnc_inspectArray;
			};
		};
	};
	
	case "SA_Insurgency": {
		_eventData = _arguments;
		_message = [_event,"message"] call ALiVE_fnc_hashGet;
		_debug = [_logic,"debug"] call ALiVE_fnc_hashGet;
		
		switch (_message) do {
		
			case "INSTALLATION_CREATED": {
				_eventData params ["_installation","_position","_objective"];
				
				_data = [_message, time,[_position,_installation,_objective]];
				_recentEvents = [_logic,"recentevents",[]] call ALiVE_fnc_hashGet;
				_recentEvents pushBack _data;
				[_logic,"recentevents",_recentEvents] call ALiVE_fnc_hashSet;

				if (_debug) then {
					["[SpyderAddons - Command Board]: %1 Event Received", _message] call SpyderAddons_fnc_log;
					_eventData call ALiVE_fnc_inspectArray;
				};
			};
			
			case "HQ_RECRUIT": {
				_eventData params ["_group","_position","_HQ"];

				_data = [_message,time,[_position,_HQ]];
				_recentEvents = [_logic,"recentevents",[]] call ALiVE_fnc_hashGet;
				_recentEvents pushBack _data;
				[_logic,"recentevents",_recentEvents] call ALiVE_fnc_hashSet;

				if (_debug) then {
					["[SpyderAddons - Command Board]: %1 Event Received", _message] call SpyderAddons_fnc_log;
					_eventData call ALiVE_fnc_inspectArray;
				};
			};
			
		};
	};

};

//-- Return result if any exists
if (!isNil "_result") then {_result} else {nil};