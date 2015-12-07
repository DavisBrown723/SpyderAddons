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

//-- Define control ID's
#define MAINCLASS SpyderAddons_fnc_vehicleSpawner
#define VEHICLESPAWNER_DIALOG "SpyderAddons_VehicleSpawner"
#define VEHICLESPAWNER_VEHICLELISTCONTROL (findDisplay 570 displayCtrl 574)
#define VEHICLESPAWNER_VEHICLELIST 574
#define VEHICLESPAWNER_INFOLIST 576

switch (_operation) do {

	case "init": {
		_arguments params ["_logic","_syncedUnits"];

		_spawnMarker = _logic getVariable "SpawnPosition";
		_factions = [_logic getVariable "VehicleFactions"] call SpyderAddons_fnc_getModuleArray;
		_whitelist = [_logic getVariable "VehiclesWhitelist"] call SpyderAddons_fnc_getModuleArray;
		_blacklist = [_logic getVariable "VehiclesBlacklist"] call SpyderAddons_fnc_getModuleArray;
		_typeBlacklist = [_logic getVariable "VehiclesTypeBlacklist"] call SpyderAddons_fnc_getModuleArray;
		_typeWhitelist = [_logic getVariable "VehiclesTypeWhitelist"] call SpyderAddons_fnc_getModuleArray;

		_spawnPosition = getMarkerPos _spawnMarker;
		_spawnDir = markerDir _spawnMarker;

		{
			if (typeName _x == "OBJECT") then {
				_x setVariable ["VehicleSpawner_SpawnPos", _spawnPosition];
				_x setVariable ["VehicleSpawner_SpawnDir", _spawnDir];
				_x setVariable ["VehicleSpawner_Factions", _factions];
				_x setVariable ["VehicleSpawner_Whitelist", _whitelist];
				_x setVariable ["VehicleSpawner_Blacklist", _blacklist];
				_x setVariable ["VehicleSpawner_TypeBlacklist", _typeBlacklist];
				_x setVariable ["VehicleSpawner_TypeWhitelist", _typeWhitelist];
				_x addAction ["Vehicle Spawner", {["open",_this] call SpyderAddons_fnc_vehicleSpawner}];
			};
		} forEach _syncedUnits;
	};
	
	case "open": {
		CreateDialog VEHICLESPAWNER_DIALOG;
		["onLoad", _arguments] call MAINCLASS;
		SpyderAddons_VehicleSpawner_Logic = [] call ALiVE_fnc_hashCreate;
		[SpyderAddons_VehicleSpawner_Logic, "CurrentInfo", _arguments] call ALiVE_fnc_hashSet;
	};

	case "onLoad": {
		private ["_vehicles"];
		_arguments params ["_object","_caller"];

		_factions = _object getVariable ["VehicleSpawner_Factions", []];
		_whitelist = _object getVariable ["VehicleSpawner_Whitelist", []];
		_blacklist = _object getVariable ["VehicleSpawner_Blacklist", []];
		_typeBlacklist = _object getVariable ["VehicleSpawner_TypeBlacklist", []];
		_typeWhitelist = _object getVariable ["VehicleSpawner_TypeWhitelist", []];

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
				{
					if !(configName _vehicle isKindOf _x) then {
						_validVehicles pushBack _vehicle;
					};
				} forEach _typeBlacklist;
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

	case "spawnVehicle": {
		_index = lbCurSel VEHICLESPAWNER_VEHICLELIST;
		if (_index == -1) exitWith {};
		_classname = lbData [VEHICLESPAWNER_VEHICLELIST, _index];
		_object = ([SpyderAddons_VehicleSpawner_Logic, "CurrentInfo"] call ALiVE_fnc_hashGet) select 0;
		_spawnPos = _object getVariable "VehicleSpawner_SpawnPos";
		_spawnDir = _object getVariable "VehicleSpawner_SpawnDir";

		_vehicle = _classname createVehicle _spawnPos;
		_vehicle = _vehicle setDir _spawnDir;
	};
};

//-- Return result if any exists
if (!isNil "_result") then {_result} else {nil};