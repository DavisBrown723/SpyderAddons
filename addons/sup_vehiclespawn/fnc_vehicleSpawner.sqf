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

private ["_result"];
params [
	["_operation", ""],
	["_args", []]
];

// define function shortcuts

#define MAINCLASS FUNC(vehicleSpawner)

// define control ID's

#define VEHICLESPAWNER_VEHICLELISTCONTROL (findDisplay 570 displayCtrl 574)
#define VEHICLESPAWNER_VEHICLELIST 574
#define VEHICLESPAWNER_INFOLIST 576

switch (_operation) do {

	method("init") {
		_args params ["_logic","_syncedUnits"];

		_spawnMarkers = [_logic getVariable "SpawnPosition"] call FUNC(getModuleArray);
		_spawnHeight = call compile (_logic getVariable "SpawnHeight");
		_factions = [_logic getVariable "VehicleFactions"] call FUNC(getModuleArray);
		_whitelist = [_logic getVariable "VehiclesWhitelist"] call FUNC(getModuleArray);
		_blacklist = [_logic getVariable "VehiclesBlacklist"] call FUNC(getModuleArray);
		_typeBlacklist = [_logic getVariable "VehiclesTypeBlacklist"] call FUNC(getModuleArray);
		_typeWhitelist = [_logic getVariable "VehiclesTypeWhitelist"] call FUNC(getModuleArray);
		_code = _logic getVariable "SpawnCode";

		_code = compile ([_code,"this","_this"] call CBA_fnc_replace);

		{
			if !(_x getVariable ["VehicleSpawner_Settings", false]) then {
				if (typeName _x == "OBJECT") then {
					_x setVariable ["VehicleSpawner_Settings", [[_spawnMarkers,_spawnHeight], _spawnDir, _factions, _whitelist, _blacklist, _typeBlacklist, _typeWhitelist, _code]];
					_x addAction ["Vehicle Spawner", {["open",_this] call SpyderAddons_fnc_vehicleSpawner}];
				};
			};
		} forEach _syncedUnits;
	};

	method("open") {
		CreateDialog "SpyderAddons_VehicleSpawner";
		["onLoad", _args] call MAINCLASS;

		MOD(VehicleSpawner) = [] call CBA_fnc_hashCreate;
		[MOD(VehicleSpawner), "CurrentInfo", _args] call CBA_fnc_hashSet;
	};

	method("onLoad") {
		private ["_vehicles"];
		_args params ["_object","_caller"];

		_settings = _object getVariable "VehicleSpawner_Settings";
		_settings params [
			"_spawnPositions",
			"_spawnDir",
			"_factions",
			"_whitelist",
			"_blacklist",
			"_typeBlacklist",
			"_typeWhitelist",
			"_spawnCode"
		];

		// get faction vehicles

		_vehicles = "(
			(getNumber (_x >> 'scope') >= 2) &&
			{(getText (_x >> 'faction')) in _factions} &&
			{(((configName _x) isKindOf 'LandVehicle') || ((configName _x) isKindOf 'Air') || ((configName _x) isKindOf 'Ship'))} &&
			{!((configName _x) isKindOf 'Static')} &&
			{!((configName _x) isKindOf 'StaticWeapon')} &&
			{!((configName _x) isKindOf 'ParachuteBase')} &&
			{!((configName _x) in _blacklist)}
		)" configClasses (configFile >> "CfgVehicles");

		// get whitelisted vehicles

		{
			if !(_x in _vehicles) then {
				_configPath = configFile >> "CfgVehicles" >>_x;

				if (isClass _configPath) then {
					_vehicles pushBack _configPath;
				};
			};
		} forEach _whitelist;

		// validate vehicles
		_validVehicles = [];
		{
			private ["_valid"];
			_valid = true;
			_vehicle = _x;

			// if type whitelist exists, use those vehicle types. Otherwise, exclude type blacklists

			if !(_typeWhitelist isEqualTo []) then {
				// validate with whitelist
				{
					if (configName _vehicle isKindOf _x) then {
						_validVehicles pushBack _vehicle;
					};
				} forEach _typeWhitelist;
			} else {
				// validate with blacklist
				if !(_typeBlacklist isEqualTo []) then {
					{
						if (!(configName _vehicle isKindOf _x) and {_valid}) then {_valid = true} else {_valid = false};
					} forEach _typeBlacklist;

					// make sure the vehicle isn't validated by not being in another blacklist
					if (_valid) then {_validVehicles pushBack _vehicle};
				} else {
					// no blacklist or whitelist, just add the vehicle
					_validVehicles pushBack _vehicle;
				};
			};
		} forEach _vehicles;

		{
			_name = getText (_x >> "displayName");
			_icon = getText (_x >> "icon");

				lbAdd [VEHICLESPAWNER_VEHICLELIST, _name];
				lbSetData [VEHICLESPAWNER_VEHICLELIST, _forEachIndex, configName _x];
				if (_icon != "iconcar") then {
					lbSetPicture [VEHICLESPAWNER_VEHICLELIST, _forEachIndex, _icon];
				};
		} forEach _validVehicles;

		// track vehicle list selection

		VEHICLESPAWNER_VEHICLELISTCONTROL  ctrlAddEventHandler ["LBSelChanged","
			['updateInfo'] call SpyderAddons_fnc_vehicleSpawner;
		"];
	};

	method("onUnload") {
		MOD(VehicleSpawner) = nil;
	};

	method("updateInfo") {
		lbClear VEHICLESPAWNER_INFOLIST;

		_index = lbCurSel VEHICLESPAWNER_VEHICLELIST;
		_classname = lbData [VEHICLESPAWNER_VEHICLELIST, _index];
		_configPath = configFile >> "CfgVehicles" >> _classname;

		_vehSpeed = getNumber (_configPath >> "maxSpeed");
		_vehSpeed = format ["Top Speed: %1", _vehSpeed];
		lbAdd [VEHICLESPAWNER_INFOLIST, _vehSpeed];

		_vehArmor = getNumber (_configPath >> "armor");
		_vehArmor = format ["Armor: %1", _vehArmor];
		lbAdd [VEHICLESPAWNER_INFOLIST, _vehArmor];

		_vehFuel = getNumber (_configPath >> "fuelCapacity");
		_vehFuel = format ["Fuel Capacity: %1", _vehFuel];
		lbAdd [VEHICLESPAWNER_INFOLIST, _vehFuel];

		_vehCargo = ([_classname, true] call BIS_fnc_crewCount) - ([_classname, false] call BIS_fnc_crewCount);
		_vehCargo = format ["Passenger Seats: %1", _vehCargo];
		lbAdd [VEHICLESPAWNER_INFOLIST, _vehCargo];
	};

	method("getSelectedVehicle") {
		_index = lbCurSel VEHICLESPAWNER_VEHICLELIST;
		if (_index == -1) exitWith {};

		_classname = lbData [VEHICLESPAWNER_VEHICLELIST, _index];
		_object = ([MOD(VehicleSpawner), "CurrentInfo"] call CBA_fnc_hashGet) select 0;

		["onVehicleRequest", [_classname, _object]] remoteExec [QUOTE(MAINCLASS), 2];
	};

    method("getVehiclesInRadius") {

        _args params ["_pos","_radius"];

        _result = nearestObjects [_pos, ["AllVehicles"], _radius];

    };

    method("clearVehiclesInRadius") {

        _args params ["_pos","_radius"];

        private _nearVehicles = ["getVehiclesInRadius", [_pos,_radius]] call MAINCLASS;

         private _allPlayers = allPlayers;
        {
            if (({_x in _allPlayers} count (crew _x)) == 0) then {
                deleteVehicle _x;
            };
        } foreach _nearVehicles;

    };

    method("getOpenMarkers") {

        private ["_marker","_markerPos"];

        _args params ["_markers","_radius"];

        _result = [];

        {
            _marker = _x;
            _markerPos = markerPos _marker;

            _vehicleNearMarker = ["getVehiclesInRadius", [_markerPos,_radius]] call MAINCLASS;

            if (count _vehicleNearMarker == 0) then {
                _result pushback _marker;
            };
        } foreach _markers;

    };

	method("onVehicleRequest") {

        private ["_markerToSpawn"];

		_args params ["_class","_object"];

		private _settings = _object getVariable "VehicleSpawner_Settings";

		private _spawnSettings = _settings select 0;
		_spawnSettings params ["_spawnMarkers","_spawnHeight"];

        private _radius = ((sizeof _class) / 2) max 5;
		private _openMarkers = ["getOpenMarkers", [_spawnMarkers,_radius]] call MAINCLASS;

        if (count _openMarkers > 0) then {
            _markerToSpawn = _openMarkers select 0;
        } else {
            _markerToSpawn = _spawnMarkers select 0;
            ["clearVehiclesInRadius", [markerPos _markerToSpawn,_radius]] call MAINCLASS;
        };

        private _pos = markerPos _markerToSpawn;
        private _dir = markerDir _markerToSpawn;
		private _code = _settings select 7;

		_pos set [2,_spawnheight];

        sleep 0.1;

        ["createVehicle", [_class,_pos,_dir,_code]] call MAINCLASS;

	};

    method("createVehicle") {

        _args params ["_class","_pos","_dir","_code"];

        private _vehicle = _class createVehicle [0,0,0];
		_vehicle setPos _pos;
        _vehicle setDir _dir;
		_vehicle setVectorUp (surfaceNormal _pos);

		_vehicle spawn _code;

    };

};

//-- Return result if any exists
if (!isNil "_result") then {_result} else {nil};