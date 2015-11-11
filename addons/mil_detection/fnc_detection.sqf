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
		_requiredDetectionInfantry = call compile (_logic getVariable "RequiredDetectionInfantry");		//-- Scalar
		_requiredDetectionVehicle = call compile (_logic getVariable "RequiredDetectionVehicle");		//-- Scalar
		_incognitoDetection = call compile (_logic getVariable "IncognitoDetection");				//-- Scalar

		SpyderAddons_milDetection_logic = [] call ALIVE_fnc_hashCreate;
		[SpyderAddons_milDetection_logic,"Debug",_debug] call ALiVE_fnc_hashSet;
		[SpyderAddons_milDetection_logic,"HostileSides",_hostileSides] call ALiVE_fnc_hashSet;
		[SpyderAddons_milDetection_logic,"InfantryDetection",_requiredDetectionInfantry] call ALiVE_fnc_hashSet;
		[SpyderAddons_milDetection_logic,"VehicleDetection",_requiredDetectionVehicle] call ALiVE_fnc_hashSet;
		[SpyderAddons_milDetection_logic,"Cooldown",_cooldown] call ALiVE_fnc_hashSet;
		[SpyderAddons_milDetection_logic,"RestrictedAreas",_restrictedAreas] call ALiVE_fnc_hashSet;
		[SpyderAddons_milDetection_logic,"DriveOffroad",_canDriveOffroad] call ALiVE_fnc_hashSet;
		[SpyderAddons_milDetection_logic,"IncognitoVehicles",_incognitoVehicles] call ALiVE_fnc_hashSet;
		[SpyderAddons_milDetection_logic,"IncognitoDetection",_incognitoDetection] call ALiVE_fnc_hashSet;
		[SpyderAddons_milDetection_logic,"RestrictFactionVehicles",_restrictFactionVehicles] call ALiVE_fnc_hashSet;
		[SpyderAddons_milDetection_logic,"FactionVehicles",_factionVehicles] call ALiVE_fnc_hashSet;
		[SpyderAddons_milDetection_logic,"SpeedLimit",_speedLimit] call ALiVE_fnc_hashSet;

		//-- Make restricted area markers invisible
		{_x setMarkerAlpha 0} forEach _restrictedAreas;

		//-- Start detection
		["beginTracking"] spawn SpyderAddons_fnc_detection;
		player addEventHandler ["respawn", {["beginTracking"] spawn SpyderAddons_fnc_detection}]
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

			//-- Check if player is armed
			if (["hasWeapon"] call SpyderAddons_fnc_detection) exitWith {
				_result = true;
			};
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

		//-- Needed to fix bug where this returns true if player has no handgun
		if ((primaryWeapon player == "") and (secondaryWeapon player == "") and (handgunWeapon player == "")) exitWith {};

		if ((primaryWeapon player != "") or (secondaryWeapon player != "") or (currentWeapon player == handgunWeapon player)) then {
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