/* ----------------------------------------------------------------------------
Function: SpyderAddons_fnc_detection

Description:
Main handler for detection

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

private ["_debug","_result"];

params [
	["_operation", ""],
	["_arguments", []]
];

//-- Define functions
#define MAINCLASS SpyderAddons_fnc_detection
#define MAIN_LOGIC SpyderAddons_milDetection_logic

if (!isNil "SpyderAddons_milDetection_logic") then {
	_debug = [SpyderAddons_milDetection_logic,"Debug"] call ALiVE_fnc_hashGet;
} else {
	_debug = false;
};

switch (_operation) do {

	case "init": {
		private ["_restrictedHeadgear","_restrictedVests","_restrictedUniforms"];
		_arguments params ["_logic","_syncedUnits"];

		if !(hasInterface) exitWith {};
		if !(player in _syncedUnits) exitWith {};

		_debug = call compile (_logic getVariable "Debug");						//-- Bool
		_hostileSides = [_logic getVariable "HostileSides"] call SpyderAddons_fnc_getModuleArray;		//-- Array
		_cooldown = call compile (_logic getVariable "Cooldown");						//-- Scalar
		_restrictedAreas = [_logic getVariable "RestrictedAreas"] call SpyderAddons_fnc_getModuleArray;		//-- Array
		_canDriveOffroad = call compile (_logic getVariable "DrivableOffroad");				//-- Bool
		_incognitoVehicles = [_logic getVariable "IncognitoVehicles"] call SpyderAddons_fnc_getModuleArray;	//-- Array
		_restrictFactionVehicles = call compile (_logic getVariable "RestrictFactionVehicles");			//-- Bool
		_factionVehicles = [_logic getVariable "FactionVehicles"] call SpyderAddons_fnc_getModuleArray;		//-- Array
		_speedLimit = call compile (_logic getVariable "SpeedLimit");					//-- Scalar
		
		//-- Restricted Clothing
		_restrictedHeadgear = [_logic getVariable "RestrictedHeadgear"] call SpyderAddons_fnc_getModuleArray;	//-- Array
		_restrictedVests = [_logic getVariable "RestrictedVests"] call SpyderAddons_fnc_getModuleArray;		//-- Array
		_restrictedUniforms = [_logic getVariable "RestrictedUniforms"] call SpyderAddons_fnc_getModuleArray;	//-- Array

		//-- Incognito Clothing
		_incognitoHeadgear = [_logic getVariable "IncognitoHeadgear"] call SpyderAddons_fnc_getModuleArray;	//-- Array
		_incognitoVests = [_logic getVariable "IncognitoVests"] call SpyderAddons_fnc_getModuleArray;		//-- Array
		_incognitoUniforms = [_logic getVariable "IncognitoUniforms"] call SpyderAddons_fnc_getModuleArray;	//-- Array
		
		//-- Detection Values
		_requiredDetectionInfantry = call compile (_logic getVariable "RequiredDetectionInfantry");		//-- Scalar
		_requiredDetectionVehicle = call compile (_logic getVariable "RequiredDetectionVehicle");		//-- Scalar
		_incognitoDetectionInfantry = call compile (_logic getVariable "IncognitoDetectionInfantry");		//-- Scalar
		_incognitoDetectionVehicle = call compile (_logic getVariable "IncognitoDetectionVehicle");		//-- Scalar

		
		//-- Create client-side object to save settings
		MAIN_LOGIC = [] call ALIVE_fnc_hashCreate;
		[MAIN_LOGIC,"Debug",_debug] call ALiVE_fnc_hashSet;
		[MAIN_LOGIC,"HostileSides",_hostileSides] call ALiVE_fnc_hashSet;
		[MAIN_LOGIC,"Cooldown",_cooldown] call ALiVE_fnc_hashSet;
		[MAIN_LOGIC,"RestrictedAreas",_restrictedAreas] call ALiVE_fnc_hashSet;
		[MAIN_LOGIC,"DriveOffroad",_canDriveOffroad] call ALiVE_fnc_hashSet;
		[MAIN_LOGIC,"IncognitoVehicles",_incognitoVehicles] call ALiVE_fnc_hashSet;
		[MAIN_LOGIC,"RestrictFactionVehicles",_restrictFactionVehicles] call ALiVE_fnc_hashSet;
		[MAIN_LOGIC,"FactionVehicles",_factionVehicles] call ALiVE_fnc_hashSet;
		[MAIN_LOGIC,"SpeedLimit",_speedLimit] call ALiVE_fnc_hashSet;
		
		//-- Restricted Clothing
		[MAIN_LOGIC,"RestrictedHeadgear", _restrictedHeadgear] call ALiVE_fnc_hashSet;
		[MAIN_LOGIC,"RestrictedVests", _restrictedVests] call ALiVE_fnc_hashSet;
		[MAIN_LOGIC,"RestrictedUniforms", _restrictedUniforms] call ALiVE_fnc_hashSet;

		//-- Incognito Clothing
		[MAIN_LOGIC,"IncognitoHeadgear", _incognitoHeadgear] call ALiVE_fnc_hashSet;
		[MAIN_LOGIC,"IncognitoVests", _incognitoVests] call ALiVE_fnc_hashSet;
		[MAIN_LOGIC,"IncognitoUniforms", _incognitoUniforms] call ALiVE_fnc_hashSet;
		
		//-- Detection Values
		[MAIN_LOGIC,"InfantryDetection",_requiredDetectionInfantry] call ALiVE_fnc_hashSet;
		[MAIN_LOGIC,"VehicleDetection",_requiredDetectionVehicle] call ALiVE_fnc_hashSet;
		[MAIN_LOGIC,"IncognitoDetectionInfantry",_incognitoDetectionInfantry] call ALiVE_fnc_hashSet;
		[MAIN_LOGIC,"IncognitoDetectionVehicle",_incognitoDetectionVehicle] call ALiVE_fnc_hashSet;

		//-- Make restricted area markers invisible
		{_x setMarkerAlpha 0} forEach _restrictedAreas;

		/////////////////////////////-- Restricted Clothing --/////////////////////////////
		//-- Get faction gear
		_headgearFactionsRestricted = "(configName _x) in _restrictedHeadgear" configClasses (configFile >> "CfgFactionClasses");
		_vestFactionsRestricted = "(configName _x) in _restrictedVests" configClasses (configFile >> "CfgFactionClasses");
		_uniformFactionsRestricted = "(configName _x) in _restrictedUniforms" configClasses (configFile >> "CfgFactionClasses");

		//-- Get faction headgear
		if !(count _headgearFactionsRestricted == 0) then {
			_factionNames = [];
			{_factionNames pushBack (configName _x)} forEach _headgearFactionsRestricted;
			_gear = ["getFactionGear", ["headgear", _factionNames]] call MAINCLASS;
			_headgear = ([MAIN_LOGIC,"RestrictedHeadgear"] call ALiVE_fnc_hashGet) + _gear;
			[MAIN_LOGIC,"RestrictedHeadgear", _headgear] call ALiVE_fnc_hashSet;
		};

		//-- Get faction vests
		if !(count _vestFactionsRestricted == 0) then {
			_factionNames = [];
			{_factionNames pushBack (configName _x)} forEach _vestFactionsRestricted;
			_gear = ["getFactionGear", ["vests", _factionNames]] call MAINCLASS;
			_vests = ([MAIN_LOGIC,"RestrictedVests"] call ALiVE_fnc_hashGet) + _gear;
			[MAIN_LOGIC,"RestrictedVests", _vests] call ALiVE_fnc_hashSet;
		};

		//-- Get faction uniforms
		if !(count _uniformFactionsRestricted == 0) then {
			_factionNames = [];
			{_factionNames pushBack (configName _x)} forEach _uniformFactionsRestricted;
			_gear = ["getFactionGear", ["uniforms", _factionNames]] call MAINCLASS;
			_uniforms = ([MAIN_LOGIC,"RestrictedUniforms"] call ALiVE_fnc_hashGet) + _gear;
			[MAIN_LOGIC,"RestrictedUniforms", _uniforms] call ALiVE_fnc_hashSet;
		};

		/////////////////////////////-- Incognito Clothing --/////////////////////////////
		//-- Get faction gear
		_headgearFactionsIncognito = "(configName _x) in _incognitoHeadgear" configClasses (configFile >> "CfgFactionClasses");
		_vestFactionsIncognito = "(configName _x) in _incognitoVests" configClasses (configFile >> "CfgFactionClasses");
		_uniformFactionsIncognito = "(configName _x) in _incognitoUniforms" configClasses (configFile >> "CfgFactionClasses");

		//-- Get faction headgear
		if !(count _headgearFactionsIncognito == 0) then {
			_factionNames = [];
			{_factionNames pushBack (configName _x)} forEach _headgearFactionsIncognito;
			_gear = ["getFactionGear", ["headgear", _factionNames]] call MAINCLASS;
			_headgear = ([MAIN_LOGIC,"IncognitoHeadgear"] call ALiVE_fnc_hashGet) + _gear;
			[MAIN_LOGIC,"IncognitoHeadgear", _headgear] call ALiVE_fnc_hashSet;
		};

		//-- Get faction vests
		if !(count _vestFactionsIncognito == 0) then {
			_factionNames = [];
			{_factionNames pushBack (configName _x)} forEach _vestFactionsIncognito;
			_gear = ["getFactionGear", ["vests", _factionNames]] call MAINCLASS;
			_vests = ([MAIN_LOGIC,"IncognitoVests"] call ALiVE_fnc_hashGet) + _gear;
			[MAIN_LOGIC,"IncognitoVests", _vests] call ALiVE_fnc_hashSet;
		};

		//-- Get faction uniforms
		if !(count _uniformFactionsIncognito == 0) then {
			_factionNames = [];
			{_factionNames pushBack (configName _x)} forEach _uniformFactionsIncognito;
			_gear = ["getFactionGear", ["uniforms", _factionNames]] call MAINCLASS;
			_uniforms = ([MAIN_LOGIC,"IncognitoUniforms"] call ALiVE_fnc_hashGet) + _gear;
			[MAIN_LOGIC,"IncognitoUniforms", _uniforms] call ALiVE_fnc_hashSet;
		};

		//-- Init done

		//-- Start detection
		["beginTracking"] spawn MAINCLASS;
		player addEventHandler ["respawn", {["beginTracking"] spawn SpyderAddons_fnc_detection}]
	};

	case "getFactionGear": {
		_data = _arguments;
		_data params ["_subOperation","_factions"];

		_restrictedHeadgear = [MAIN_LOGIC,"RestrictedHeadgear"] call ALiVE_fnc_hashGet;
		_restrictedVests = [MAIN_LOGIC,"RestrictedVests"] call ALiVE_fnc_hashGet;
		_restrictedUniforms = [MAIN_LOGIC,"RestrictedUniforms"] call ALiVE_fnc_hashGet;

		_result = [];
		_headGear = [];
		_vests = [];
		_uniforms = [];

		//-- Get units
		_units = "(
			((getText (_x >> 'faction')) in _factions) and
			{(configName _x) isKindOf 'Man' and
			{!((getText (_x >> '_generalMacro') == 'B_Soldier_base_F')) and
			{count (getArray (_x >> 'weapons')) > 2
		}}})" configClasses (configFile >> "CfgVehicles");

		switch (_subOperation) do {
			case "headgear": {
				{
					_unit = _x;
					_linkedItems = getArray (_unit >> "linkedItems");
	
					{
						_item = _x;
						_configPath = configFile >> "CfgWeapons" >> _item;
							if (isClass _configPath) then {
								_itemInfo = getNumber (_configPath >> "ItemInfo" >> "Type");

								switch (str _itemInfo) do {
									case "605": {
										if (!(_item in _headGear) and !(_item in _restrictedHeadgear)) then {
											_headGear pushBack _item;
										};
									};
								};
							};
					} forEach _linkedItems;

					_headGear = _headGear - _factions;
					_result = _headGear;
				} forEach _units;
			};

			case "vests": {
				{
					_unit = _x;
					_linkedItems = getArray (_unit >> "linkedItems");
					{
						_item = _x;
						_configPath = configFile >> "CfgWeapons" >> _item;
							if (isClass _configPath) then {
								_itemInfo = getNumber (_configPath >> "ItemInfo" >> "Type");

								switch (str _itemInfo) do {
									case "701": {
										if (!(_item in _vests) and !(_item in _restrictedVests)) then {
											_vests pushBack _item;
										};
									};
								};
							};
					} forEach _linkedItems;
				} forEach _units;

				_vests = _vests - _factions;
				_result = _vests;
			};

			case "uniforms": {
				{
					_uniform = getText (_x >> "uniformClass");
					if !(_uniform in _restrictedUniforms) then {
						_uniforms pushBack _uniform;
					};
				} forEach _units;

				_uniforms = _uniforms - _factions;
				_result = _uniforms;
			};
			
		};
	};

	case "beginTracking": {
		if ([MAIN_LOGIC,"Debug"] call ALiVE_fnc_hashGet) then {player sideChat "[SpyderAddons - Detection] Tracking Started"};

		waitUntil {player == player};

		player setCaptive true;

		[{
			params ["_data"];
			_data params ["_debug"];

			if (captive player) then {
				if (["isHostile"] call MAINCLASS) then {
					if (_debug) then {player sideChat "[SpyderAddons - Detection] Player is hostile"};
					["setHostile"] call MAINCLASS;
				};
			};
		}, 3, [_debug]] call CBA_fnc_addPerFrameHandler;
	};

	case "isHostile": {
		private ["_incognito"];
		_result = false;
		_playerPos = getPosATL vehicle player;
		
		//-- Check if player is armed
		if (["hasWeapon"] call MAINCLASS) exitWith {
			_result = true;
		};
		
		//-- Check restricted Clothing
		if (["hasRestrictedClothing"] call MAINCLASS) exitWith {
			_result = true;
		};

		if (vehicle player == player) then {
			//-- On foot

			if (["inIncognitoClothing"] call MAINCLASS) then {
				_incognito = true;
			} else {
				_incognito = false;
			};

			//-- Check if player has been spotted
			{
				_side = _x;
				_side = [_side] call ALIVE_fnc_sideTextToObject;

				if !(_incognito) then {
					if (_side knowsAbout player >= ([MAIN_LOGIC,"InfantryDetection"] call ALiVE_fnc_hashGet)) exitWith {
						_result = true;
					};
				} else {
					if (_side knowsAbout player >= ([MAIN_LOGIC,"IncognitoDetectionInfantry"] call ALiVE_fnc_hashGet)) exitWith {
						_result = true;
					};
				};
			} forEach ([MAIN_LOGIC,"HostileSides"] call ALiVE_fnc_hashGet);
		} else {
			//-- In Vehicle

			//-- Check if player is offroad -- Don't use isOnRoad --> unreliable
			if !([MAIN_LOGIC,"DriveOffroad"] call ALiVE_fnc_hashGet) then {
				if ((count (_playerPos nearRoads 22)) == 0) then {
					_result = true;
				};
			};

			//-- Check if player has been spotted
			if !(vehicle player in ([MAIN_LOGIC,"IncognitoVehicles"] call ALiVE_fnc_hashGet)) then {
				{
					_side = _x;
					_side = [_side] call ALIVE_fnc_sideTextToObject;
					if (_side knowsAbout vehicle player >= ([MAIN_LOGIC,"VehicleDetection"] call ALiVE_fnc_hashGet)) then {
						_result = true;
					};
				} forEach ([MAIN_LOGIC,"HostileSides"] call ALiVE_fnc_hashGet);
			} else {
				{
					_side = _x;
					_side = [_side] call ALIVE_fnc_sideTextToObject;
					if (_side knowsAbout vehicle player >= ([MAIN_LOGIC,"IncognitoDetectionVehicle"] call ALiVE_fnc_hashGet)) then {
						_result = true;
					};
				} forEach ([MAIN_LOGIC,"HostileSides"] call ALiVE_fnc_hashGet);
			};

			//-- Check speed limit
			if (speed vehicle player > ([MAIN_LOGIC,"SpeedLimit"] call ALiVE_fnc_hashGet)) then {
				_result = true;
			};

			//-- Check restricted vehicle
			if (["inRestrictedVehicle"] call MAINCLASS) then {
				_result = true;
			};
		};

		//-- Check if player is in restricted area
		{
			_marker = _x;

			if ([_marker, _playerPos] call BIS_fnc_inTrigger) exitWith {
				_result = true;
			};
		} forEach ([MAIN_LOGIC,"RestrictedAreas"] call ALiVE_fnc_hashGet);
	};

		case "setHostile": {
		//-- Possible reveal player to ensure they are engaged properly. Cycle through nearby enemy units and if their knows about value is high enough, reveal player to them

		//-- Ensure we don't have multiple loops
		if !(captive player) exitWith {};

		//-- Make player hostile
		player setCaptive false;

		[] spawn {
			_cooldown = [MAIN_LOGIC,"Cooldown"] call ALiVE_fnc_hashGet;
			sleep _cooldown;

			while {["isHostile"] call MAINCLASS} do {
				sleep _cooldown;
			};

			//-- Make player friendly
			player setCaptive true;

			if ([MAIN_LOGIC,"Debug"] call ALiVE_fnc_hashGet) then {player sideChat "[SpyderAddons - Detection] Player is friendly"};
		};
	};

	case "hasWeapon": {
		_result = false;

		if ((primaryWeapon player == "") and (secondaryWeapon player == "") and (handgunWeapon player == "")) exitWith {};

		if ((primaryWeapon player != "") or (secondaryWeapon player != "")) then {
			//if ((currentWeapon player == handgunWeapon player) and ((handgunWeapon player != "") or (currentWeapon player != ""))) then {
				_result = true;
			//};
		};
	};
	
	case "hasRestrictedClothing": {
		_result = false;
		
		//-- Check headgear
		if (headgear player in ([MAIN_LOGIC,"RestrictedHeadgear"] call ALiVE_fnc_hashGet)) exitWith {
			_result = true;
		};
		
		//-- Check vest
		if (vest player in ([MAIN_LOGIC,"RestrictedVests"] call ALiVE_fnc_hashGet)) exitWith {
			_result = true;
		};
		
		//-- Check uniform
		if (uniform player in ([MAIN_LOGIC,"RestrictedUniforms"] call ALiVE_fnc_hashGet)) exitWith {
			_result = true;
		};
	};

	case "inIncognitoClothing": {
		_result = false;
		
		//-- Check headgear
		if (headgear player in ([MAIN_LOGIC,"IncognitoHeadgear"] call ALiVE_fnc_hashGet)) exitWith {
			_result = true;
		};
		
		//-- Check vest
		if (vest player in ([MAIN_LOGIC,"IncognitoVests"] call ALiVE_fnc_hashGet)) exitWith {
			_result = true;
		};
		
		//-- Check uniform
		if (uniform player in ([MAIN_LOGIC,"IncognitoUniforms"] call ALiVE_fnc_hashGet)) exitWith {
			_result = true;
		};
	};

	case "inRestrictedVehicle": {
		_result = false;

		if !([MAIN_LOGIC,"RestrictFactionVehicles"] call ALiVE_fnc_hashGet) exitWith {};

		_vehicle = typeOf vehicle player;
		_factionVehicleArray = [MAIN_LOGIC,"FactionVehicles"] call ALiVE_fnc_hashGet;

		if (((getText (configFile >> "CfgVehicles" >> _vehicle >> "faction")) in _factionVehicleArray) or (_vehicle in _factionVehicleArray)) then {
			_result = true;
		};
	};
};

//-- Return result if any exists
if (!isNil "_result") then {_result} else {nil};
