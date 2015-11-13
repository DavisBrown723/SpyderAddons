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

params [
	["_operation", ""],
	["_arguments", []]
];
private ["_debug","_result"];

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
		
		//-- Detection Values
		_requiredDetectionInfantry = call compile (_logic getVariable "RequiredDetectionInfantry");		//-- Scalar
		_requiredDetectionVehicle = call compile (_logic getVariable "RequiredDetectionVehicle");		//-- Scalar
		_incognitoDetection = call compile (_logic getVariable "IncognitoDetection");				//-- Scalar

		
		//-- Create client-side object to save settings
		SpyderAddons_milDetection_logic = [] call ALIVE_fnc_hashCreate;
		[SpyderAddons_milDetection_logic,"Debug",_debug] call ALiVE_fnc_hashSet;
		[SpyderAddons_milDetection_logic,"HostileSides",_hostileSides] call ALiVE_fnc_hashSet;
		[SpyderAddons_milDetection_logic,"Cooldown",_cooldown] call ALiVE_fnc_hashSet;
		[SpyderAddons_milDetection_logic,"RestrictedAreas",_restrictedAreas] call ALiVE_fnc_hashSet;
		[SpyderAddons_milDetection_logic,"DriveOffroad",_canDriveOffroad] call ALiVE_fnc_hashSet;
		[SpyderAddons_milDetection_logic,"IncognitoVehicles",_incognitoVehicles] call ALiVE_fnc_hashSet;
		[SpyderAddons_milDetection_logic,"RestrictFactionVehicles",_restrictFactionVehicles] call ALiVE_fnc_hashSet;
		[SpyderAddons_milDetection_logic,"FactionVehicles",_factionVehicles] call ALiVE_fnc_hashSet;
		[SpyderAddons_milDetection_logic,"SpeedLimit",_speedLimit] call ALiVE_fnc_hashSet;
		
		//-- Restricted Clothing
		[SpyderAddons_milDetection_logic,"RestrictedHeadgear", _restrictedHeadgear] call ALiVE_fnc_hashSet;
		[SpyderAddons_milDetection_logic,"RestrictedVests", _restrictedVests] call ALiVE_fnc_hashSet;
		[SpyderAddons_milDetection_logic,"RestrictedUniforms", _restrictedUniforms] call ALiVE_fnc_hashSet;
		
		//-- Detection Values
		[SpyderAddons_milDetection_logic,"InfantryDetection",_requiredDetectionInfantry] call ALiVE_fnc_hashSet;
		[SpyderAddons_milDetection_logic,"VehicleDetection",_requiredDetectionVehicle] call ALiVE_fnc_hashSet;
		[SpyderAddons_milDetection_logic,"IncognitoDetection",_incognitoDetection] call ALiVE_fnc_hashSet;

		//-- Make restricted area markers invisible
		{_x setMarkerAlpha 0} forEach _restrictedAreas;

		//-- Get faction gear
		_headgearFactions = "(configName _x) in _restrictedHeadgear" configClasses (configFile >> "CfgFactionClasses");
		_vestFactions = "(configName _x) in _restrictedVests" configClasses (configFile >> "CfgFactionClasses");
		_uniformFactions = "(configName _x) in _restrictedUniforms" configClasses (configFile >> "CfgFactionClasses");

		//-- Get faction headgear
		if !(count _headgearFactions == 0) then {
			_factionNames = [];
			{_factionNames pushBack (configName _x)} forEach _headgearFactions;
			_gear = ["getFactionGear", ["headgear", _factionNames]] call SpyderAddons_fnc_detection;
			_headgear = ([SpyderAddons_milDetection_logic,"RestrictedHeadgear"] call ALiVE_fnc_hashGet) + _gear;
			[SpyderAddons_milDetection_logic,"RestrictedHeadgear", _headgear] call ALiVE_fnc_hashSet;
		};

		//-- Get faction vests
		if !(count _vestFactions == 0) then {
			_factionNames = [];
			{_factionNames pushBack (configName _x)} forEach _vestFactions;
			_gear = ["getFactionGear", ["vests", _factionNames]] call SpyderAddons_fnc_detection;
			_vests = ([SpyderAddons_milDetection_logic,"RestrictedVests"] call ALiVE_fnc_hashGet) + _gear;
			[SpyderAddons_milDetection_logic,"RestrictedVests", _vests] call ALiVE_fnc_hashSet;
		};

		//-- Get faction uniforms
		if !(count _uniformFactions == 0) then {
			_factionNames = [];
			{_factionNames pushBack (configName _x)} forEach _uniformFactions;
			_gear = ["getFactionGear", ["uniforms", _factionNames]] call SpyderAddons_fnc_detection;
			_uniforms = ([SpyderAddons_milDetection_logic,"RestrictedUniforms"] call ALiVE_fnc_hashGet) + _gear;
			[SpyderAddons_milDetection_logic,"RestrictedUniforms", _uniforms] call ALiVE_fnc_hashSet;
		};

		//-- Start detection
		["beginTracking"] spawn SpyderAddons_fnc_detection;
		player addEventHandler ["respawn", {["beginTracking"] spawn SpyderAddons_fnc_detection}]
	};

	case "getFactionGear": {
		_data = _arguments;
		_data params ["_subOperation","_factions"];

		_restrictedHeadgear = [SpyderAddons_milDetection_logic,"RestrictedHeadgear"] call ALiVE_fnc_hashGet;
		_restrictedVests = [SpyderAddons_milDetection_logic,"RestrictedVests"] call ALiVE_fnc_hashGet;
		_restrictedUniforms = [SpyderAddons_milDetection_logic,"RestrictedUniforms"] call ALiVE_fnc_hashGet;

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
		if ([SpyderAddons_milDetection_logic,"Debug"] call ALiVE_fnc_hashGet) then {player sideChat "[SpyderAddons - Detection] Tracking Started"};

		waitUntil {player == player};

		player setCaptive true;

		[{
			params ["_data"];
			_data params ["_debug"];

			if (captive player) then {
				if (["isHostile"] call SpyderAddons_fnc_detection) then {
					if (_debug) then {player sideChat "[SpyderAddons - Detection] Player is hostile"};
					["setHostile"] call SpyderAddons_fnc_detection;
				};
			};
		}, 3, [_debug]] call CBA_fnc_addPerFrameHandler;
	};

	case "isHostile": {
		_result = false;
		_playerPos = getPosATL vehicle player;
		
		//-- Check if player is armed
		if (["hasWeapon"] call SpyderAddons_fnc_detection) exitWith {
			_result = true;
		};
		
		//-- Check restricted Clothing
		if (["hasRestrictedClothing"] call SpyderAddons_fnc_detection) exitWith {
			_result = true;
		};

		if (vehicle player == player) then {
			//-- On foot

			//-- Check if player has been spotted
			{
				_side = _x;
				_side = [_side] call ALIVE_fnc_sideTextToObject;

				if (_side knowsAbout player >= ([SpyderAddons_milDetection_logic,"InfantryDetection"] call ALiVE_fnc_hashGet)) exitWith {
					_result = true;
				};
			} forEach ([SpyderAddons_milDetection_logic,"HostileSides"] call ALiVE_fnc_hashGet);
		} else {
			//-- In Vehicle

			//-- Check if player is offroad -- Don't use isOnRoad --> unreliable
			if !([SpyderAddons_milDetection_logic,"DriveOffroad"] call ALiVE_fnc_hashGet) then {
				if ((count (_playerPos nearRoads 22)) == 0) then {
					_result = true;
				};
			};

			//-- Check if player has been spotted
			if !(vehicle player in ([SpyderAddons_milDetection_logic,"IncognitoVehicles"] call ALiVE_fnc_hashGet)) then {
				{
					_side = _x;
					_side = [_side] call ALIVE_fnc_sideTextToObject;
					if (_side knowsAbout vehicle player >= ([SpyderAddons_milDetection_logic,"VehicleDetection"] call ALiVE_fnc_hashGet)) then {
						_result = true;
					};
				} forEach ([SpyderAddons_milDetection_logic,"HostileSides"] call ALiVE_fnc_hashGet);
			} else {
				{
					_side = _x;
					_side = [_side] call ALIVE_fnc_sideTextToObject;
					if (_side knowsAbout vehicle player >= ([SpyderAddons_milDetection_logic,"IncognitoDetection"] call ALiVE_fnc_hashGet)) then {
						_result = true;
					};
				} forEach ([SpyderAddons_milDetection_logic,"HostileSides"] call ALiVE_fnc_hashGet);
			};

			//-- Check speed limit
			if (speed vehicle player > ([SpyderAddons_milDetection_logic,"SpeedLimit"] call ALiVE_fnc_hashGet)) then {
				_result = true;
			};

			//-- Check restricted vehicle
			if (["inRestrictedVehicle"] call SpyderAddons_fnc_detection) then {
				_result = true;
			};
		};

		//-- Check if player is in restricted area
		{
			_marker = _x;

			if ([_marker, _playerPos] call BIS_fnc_inTrigger) exitWith {
				_result = true;
			};
		} forEach ([SpyderAddons_milDetection_logic,"RestrictedAreas"] call ALiVE_fnc_hashGet);
	};

		case "setHostile": {
		//-- Possible reveal player to ensure they are engaged properly. Cycle through nearby enemy units and if their knows about value is high enough, reveal player to them

		//-- Ensure we don't have multiple loops
		if !(captive player) exitWith {};

		//-- Make player hostile
		player setCaptive false;

		[] spawn {
			_cooldown = [SpyderAddons_milDetection_logic,"Cooldown"] call ALiVE_fnc_hashGet;
			sleep _cooldown;

			while {["isHostile"] call SpyderAddons_fnc_detection} do {
				sleep _cooldown;
			};

			//-- Make player friendly
			player setCaptive true;

			if ([SpyderAddons_milDetection_logic,"Debug"] call ALiVE_fnc_hashGet) then {player sideChat "[SpyderAddons - Detection] Player is friendly"};
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
		if (headgear player in ([SpyderAddons_milDetection_logic,"RestrictedHeadgear"] call ALiVE_fnc_hashGet)) exitWith {
			_result = true;
		};
		
		//-- Check vest
		if (vest player in ([SpyderAddons_milDetection_logic,"RestrictedVests"] call ALiVE_fnc_hashGet)) exitWith {
			_result = true;
		};
		
		//-- Check uniform
		if (uniform player in ([SpyderAddons_milDetection_logic,"RestrictedUniforms"] call ALiVE_fnc_hashGet)) exitWith {
			_result = true;
		};
	};

	case "inRestrictedVehicle": {
		_result = false;

		if !([SpyderAddons_milDetection_logic,"RestrictFactionVehicles"] call ALiVE_fnc_hashGet) exitWith {};

		_vehicle = typeOf vehicle player;
		_factionVehicleArray = [SpyderAddons_milDetection_logic,"FactionVehicles"] call ALiVE_fnc_hashGet;

		if (((getText (configFile >> "CfgVehicles" >> _vehicle >> "faction")) in _factionVehicleArray) or (_vehicle in _factionVehicleArray)) then {
			_result = true;
		};
	};
};

//-- Return result if any exists
if (!isNil "_result") then {_result} else {nil};