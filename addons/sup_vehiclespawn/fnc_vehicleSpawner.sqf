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

#define VEHICLESPAWNER_VEHICLELISTCONTROL   (findDisplay 570 displayCtrl 574)
#define VEHICLESPAWNER_VEHICLELIST          574
#define VEHICLESPAWNER_INFOLIST             576

switch (_operation) do {

	method("init") {
		_args params ["_logic","_syncedUnits"];

		private _spawnMarkers = [_logic getVariable "SpawnPosition"] call FUNC(getModuleArray);
		private _spawnHeight = call compile (_logic getVariable "SpawnHeight");
		private _factions = [_logic getVariable "VehicleFactions"] call FUNC(getModuleArray);
		private _whitelist = [_logic getVariable "VehiclesWhitelist"] call FUNC(getModuleArray);
		private _blacklist = [_logic getVariable "VehiclesBlacklist"] call FUNC(getModuleArray);
		private _typeBlacklist = [_logic getVariable "VehiclesTypeBlacklist"] call FUNC(getModuleArray);
		private _typeWhitelist = [_logic getVariable "VehiclesTypeWhitelist"] call FUNC(getModuleArray);
		private _code = _logic getVariable "SpawnCode";
        private _condition = _logic getVariable "SpawnCondition";

		_code = compile ([_code,"this","_this"] call CBA_fnc_replace);

		{
			if !(_x getVariable ["VehicleSpawner_Settings", false]) then {
				if (typeName _x == "OBJECT") then {
					_x setVariable ["VehicleSpawner_Settings", [[_spawnMarkers,_spawnHeight], _spawnDir, _factions, _whitelist, _blacklist, _typeBlacklist, _typeWhitelist, _code, _condition]];
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
		_args params ["_object","_caller"];

		private _settings = _object getVariable "VehicleSpawner_Settings";
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

        private _vehicles = [];

        private _cfgVehicles = configFile >> "CfgVehicles";
        for "_i" from 0 to (count _cfgVehicles - 1) do {
            private _entry = _cfgVehicles select _i;

            if (isClass _entry) then {

                if (getnumber (_entry >> "scope") >= 2) then {

                    if (gettext (_entry >> "faction") in _Factions) then {

                        private _configName = configname _entry;

                        if (_configName isKindOf "LandVehicle" || {_configName isKindOf "Air"} || {_configName isKindOf "Ship"}) then {
                            if (!(_configName isKindOf "Static") && {!(_configName isKindOf "StaticWeapon")} && {!(_configName isKindOf "ParachuteBase")} && {!(_configName in _blacklist)}) then {
                                _vehicles pushback _entry;
                            };
                        };

                    };

                };

            };
        };

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
		private _validVehicles = [];
		{
			private _valid = true;
			private _vehicle = _x;
            private _configName = configName _vehicle;

			// if type whitelist exists, use those vehicle types. Otherwise, exclude type blacklists

			if !(_typeWhitelist isEqualTo []) then {
				// validate with whitelist
				{
					if (_configName isKindOf _x) then {
						_validVehicles pushBack _vehicle;
					};
				} forEach _typeWhitelist;
			} else {
				// validate with blacklist
				if !(_typeBlacklist isEqualTo []) then {
					{
						if (!(_configName isKindOf _x) and {_valid}) then {_valid = true} else {_valid = false};
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
			private _name = getText (_x >> "displayName");
			private _icon = getText (_x >> "icon");

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

		private _index = lbCurSel VEHICLESPAWNER_VEHICLELIST;
		private _classname = lbData [VEHICLESPAWNER_VEHICLELIST, _index];
		private _configPath = configFile >> "CfgVehicles" >> _classname;

		private _vehSpeed = getNumber (_configPath >> "maxSpeed");
		private _vehSpeedStr = format ["Top Speed: %1", _vehSpeed];
		lbAdd [VEHICLESPAWNER_INFOLIST, _vehSpeedStr];

		private _vehArmor = getNumber (_configPath >> "armor");
		private _vehArmorStr = format ["Armor: %1", _vehArmor];
		lbAdd [VEHICLESPAWNER_INFOLIST, _vehArmorStr];

		private _vehFuel = getNumber (_configPath >> "fuelCapacity");
		private _vehFuelStr = format ["Fuel Capacity: %1", _vehFuel];
		lbAdd [VEHICLESPAWNER_INFOLIST, _vehFuelStr];

		private _vehCargo = ([_classname, true] call BIS_fnc_crewCount) - ([_classname, false] call BIS_fnc_crewCount);
		private _vehCargoStr = format ["Passenger Seats: %1", _vehCargo];
		lbAdd [VEHICLESPAWNER_INFOLIST, _vehCargoStr];
	};

	method("getSelectedVehicle") {
		private _index = lbCurSel VEHICLESPAWNER_VEHICLELIST;

		if (_index == -1) exitWith {};

		private _classname = lbData [VEHICLESPAWNER_VEHICLELIST, _index];
		private _object = ([MOD(VehicleSpawner), "CurrentInfo"] call CBA_fnc_hashGet) select 0;

        private _settings = _object getVariable "VehicleSpawner_Settings";
        private _condition = _settings select 8;

        if (_condition == "" || {[player,_classname, _object] call (compile _condition)}) then {
            ["onVehicleRequest", [_classname, _object]] remoteExec [QUOTE(MAINCLASS), 2];
        };
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

        private _vehicle = createVehicle [_class, _pos, [], 0, "CAN_COLLIDE"];
		_vehicle setPos _pos;
        _vehicle setDir _dir;
		_vehicle setVectorUp (surfaceNormal _pos);

		_vehicle spawn _code;

    };

};

//-- Return result if any exists
if (!isNil "_result") then {_result} else {nil};