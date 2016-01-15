#include <\x\spyderaddons\addons\sup_vehiclespawn\script_component.hpp>
SCRIPT(vehicleSpawner);

/* ----------------------------------------------------------------------------
Function: SpyderAddons_fnc_vehicleSpawner

Description:
Main handler for the vehicle spawner

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
private ["_result"];

//-- Define function shortcuts
#define MAINCLASS SpyderAddons_fnc_vehicleSpawner

//-- Define control ID's
#define VEHICLESPAWNER_DIALOG "SpyderAddons_VehicleSpawner"
#define VEHICLESPAWNER_VEHICLELISTCONTROL (findDisplay 570 displayCtrl 574)
#define VEHICLESPAWNER_VEHICLELIST 574
#define VEHICLESPAWNER_INFOLIST 576

switch (_operation) do {

	case "init": {
		private ["_spawnPosition"];
		_arguments params ["_logic","_syncedUnits"];

		_spawnMarker = _logic getVariable "SpawnPosition";
		_spawnHeight = _logic getVariable "SpawnHeight";
		_factions = [_logic getVariable "VehicleFactions"] call SpyderAddons_fnc_getModuleArray;
		_whitelist = [_logic getVariable "VehiclesWhitelist"] call SpyderAddons_fnc_getModuleArray;
		_blacklist = [_logic getVariable "VehiclesBlacklist"] call SpyderAddons_fnc_getModuleArray;
		_typeBlacklist = [_logic getVariable "VehiclesTypeBlacklist"] call SpyderAddons_fnc_getModuleArray;
		_typeWhitelist = [_logic getVariable "VehiclesTypeWhitelist"] call SpyderAddons_fnc_getModuleArray;
		_spawnCode = compile (_logic getVariable "SpawnCode");

		_spawnPosition = getMarkerPos _spawnMarker;
		_spawnDir = markerDir _spawnMarker;

		if (_spawnHeight != "") then {_spawnPosition = [_spawnPosition select 0, _spawnPosition select 1, call (compile _spawnHeight)]};

		{
			if (typeName _x == "OBJECT") then {
				_x setVariable ["VehicleSpawner_Settings", [_spawnPosition, _spawnDir, _factions, _whitelist, _blacklist, _typeBlacklist, _typeWhitelist, _spawnCode]];
				_x addAction ["Vehicle Spawner", {["open",_this] call SpyderAddons_fnc_vehicleSpawner}];
			};
		} forEach _syncedUnits;
	};
	
	case "open": {
		CreateDialog VEHICLESPAWNER_DIALOG;
		["onLoad", _arguments] call MAINCLASS;

		MOD(VehicleSpawnerHandler) = [] call CBA_fnc_hashCreate;
		[MOD(VehicleSpawnerHandler), "CurrentInfo", _arguments] call CBA_fnc_hashSet;
	};

	case "onLoad": {
		private ["_vehicles"];
		_arguments params ["_object","_caller"];

		_settings = _object getVariable "VehicleSpawner_Settings";
		_settings params [
			"_spawnPosition",
			"_spawnDir",
			"_factions",
			"_whitelist",
			"_blacklist",
			"_typeBlacklist",
			"_typeWhitelist",
			"_spawnCode"
		];

		//-- Get faction vehicles
		_vehicles = "(
			((getText (_x >> 'faction')) in _factions) and
			{(((configName _x) isKindOf 'LandVehicle') or ((configName _x) isKindOf 'Air') or ((configName _x) isKindOf 'Ship')) and
			{!((configName _x) isKindOf 'Static') and
			{!((configName _x) isKindOf 'StaticWeapon') and
			{!((configName _x) isKindOf 'ParachuteBase') and
			{!((configName _x) in _blacklist)
		}}}}})" configClasses (configFile >> "CfgVehicles");

		//-- Get whitelisted vehicles
		{
			if !(_x in _vehicles) then {
				_configPath = configFile >> "CfgVehicles" >>_x;

				if (isClass _configPath) then {
					_vehicles pushBack _configPath;
				};
			};
		} forEach _whitelist;

		//-- Validate vehicles
		_validVehicles = [];
		{
			private ["_valid"];
			_valid = true;
			_vehicle = _x;

			//-- If type whitelist exists, use those vehicle types. Otherwise, exclude type blacklists
			if !(_typeWhitelist isEqualTo []) then {
				//-- Validate with whitelist
				{
					if (configName _vehicle isKindOf _x) then {
						_validVehicles pushBack _vehicle;
					};
				} forEach _typeWhitelist;
			} else {
				//-- Validate with blacklist
				if !(_typeBlacklist isEqualTo []) then {
					{
						if (!(configName _vehicle isKindOf _x) and {_valid}) then {_valid = true} else {_valid = false};
					} forEach _typeBlacklist;

					//-- Make sure the vehicle isn't validated by not being in another blacklist
					if (_valid) then {_validVehicles pushBack _vehicle};
				} else {
					//-- No blacklist or whitelist, just add the vehicle
					_validVehicles pushBack _vehicle;
				};
			};
		} forEach _vehicles;

		//-- Add to list
		{
			_name = getText (_x >> "displayName");
			_icon = getText (_x >> "icon");

				lbAdd [VEHICLESPAWNER_VEHICLELIST, _name];
				lbSetData [VEHICLESPAWNER_VEHICLELIST, _forEachIndex, configName _x];
				lbSetPicture [VEHICLESPAWNER_VEHICLELIST, _forEachIndex, _icon];
		} forEach _validVehicles;

		//-- Track vehicle list selection
		VEHICLESPAWNER_VEHICLELISTCONTROL  ctrlAddEventHandler ["LBSelChanged","
			['updateInfo'] call SpyderAddons_fnc_vehicleSpawner;
		"];
	};

	case "onUnload": {
		MOD(VehicleSpawnerHandler) = nil;
	};

	case "updateInfo": {
		//-- Clear list
		lbClear VEHICLESPAWNER_INFOLIST;

		_index = lbCurSel VEHICLESPAWNER_VEHICLELIST;
		_classname = lbData [VEHICLESPAWNER_VEHICLELIST, _index];
		_configPath = configFile >> "CfgVehicles" >> _classname;

		//-- Get speed
		_vehSpeed = getNumber (_configPath >> "maxSpeed");
		_vehSpeed = format ["Top Speed: %1", _vehSpeed];
		lbAdd [VEHICLESPAWNER_INFOLIST, _vehSpeed];

		//-- Get armor
		_vehArmor = getNumber (_configPath >> "armor");
		_vehArmor = format ["Armor: %1", _vehArmor];
		lbAdd [VEHICLESPAWNER_INFOLIST, _vehArmor];

		//-- Get fuel
		_vehFuel = getNumber (_configPath >> "fuelCapacity");
		_vehFuel = format ["Fuel Capacity: %1", _vehFuel];
		lbAdd [VEHICLESPAWNER_INFOLIST, _vehFuel];

		//-- Get passenger seats
		_vehCargo = getNumber (_configPath >> "transportSoldier");
		_vehCargo = format ["Passenger Seats: %1", _vehCargo];
		lbAdd [VEHICLESPAWNER_INFOLIST, _vehCargo];
	};

	case "getSelectedVehicle": {
		_index = lbCurSel VEHICLESPAWNER_VEHICLELIST;
		if (_index == -1) exitWith {};

		_classname = lbData [VEHICLESPAWNER_VEHICLELIST, _index];
		_object = ([MOD(VehicleSpawnerHandler), "CurrentInfo"] call CBA_fnc_hashGet) select 0;

		["spawnVehicle", [_classname, _object]] remoteExecCall [QUOTE(MAINCLASS), 2];
	};

	case "spawnVehicle": {
		_arguments params ["_vehicle","_object"];

		_settings = _object getVariable "VehicleSpawner_Settings";
		_spawnPosition = _settings select 0;
		_spawnDir = _settings select 1;
		_spawnCode = _settings select 7;

		_vehicle = _classname createVehicle _spawnPosition;

		_vehicle setPos _spawnPos;	//-- createVehicle doesn't utilize spawnheight
		_vehicle setDir _spawnDir;

		_vehicle call _spawnCode;
	};
};

//-- Return result if any exists
if (!isNil "_result") then {_result} else {nil};