#include "script_component.hpp"

/* ----------------------------------------------------------------------------
Function: callToPrayer

Description:
Main handler for call to prayer

Parameters:
Logic - Object
String - Operation
Any - Arguments

Returns:
Result of operation

Examples:
[_logic,_operation,_args] call SM_fnc_callToPrayer;

Author:
SpyderBlack712

Peer Reviewed:
nil
---------------------------------------------------------------------------- */

#define MAINCLASS   SpyderAddons_fnc_callToPrayer

#define CTP_TIMES   [[4.25,4.5],[5.25,5.75],[11.75,12],[15.25,15.5],[17.75,18.25],[19,19.25]]

private ["_result"];
params [
    ["_logic", objNull, [objNull,[]]],
    ["_operation", "", [""]],
    ["_args", [], [objNull,[],"",0,true,false]]
];


switch (_operation) do {

    case "init": {
        _debug = call compile (_logic getVariable ["Debug", false]);
        _autoPopulate = call compile (_logic getVariable ["autoPopulate",true]);
        _moveCivs = call compile (_logic getVariable ["moveCivs",true]);

        _whitelist = [_logic getVariable ["whitelist", []]] call SpyderAddons_fnc_getModuleArray;
        _blacklist = [_logic getVariable ["blacklist", []]] call SpyderAddons_fnc_getModuleArray;
        _manual = [_logic getVariable ["manual", []]] call SpyderAddons_fnc_getModuleArray;
        _buildings = [_logic getVariable ["buildings", []]] call SpyderAddons_fnc_getModuleArray;

        _timesOfPrayer = call compile ("[" + (_logic getVariable "timesOfPrayer") + "]");
        _CTPSound = _logic getVariable "CTPSound";
        _CTPSoundsCustom = [_logic getVariable ["CTPSoundsCustom", []]] call SpyderAddons_fnc_getModuleArray;

        _sounds = [];
        if (_CTPSound != "") then {_sounds pushback _CTPSound};
        _sounds append _CTPSoundsCustom;

        MOD(callToPrayer) = [] call SpyderAddons_fnc_hashCreate;
        [MOD(callToPrayer),"debug", _debug] call SpyderAddons_fnc_hashSet;
        [MOD(callToPrayer),"moveCivs", _moveCivs] call SpyderAddons_fnc_hashSet;
        [MOD(callToPrayer),"civs", []] call SpyderAddons_fnc_hashSet;
        [MOD(callToPrayer),"sounds",_sounds] call SpyderAddons_fnc_hashSet;
        [MOD(callToPrayer),"timesOfPrayer", _timesOfPrayer] call SpyderAddons_fnc_hashSet;
        [MOD(callToPrayer),"prayerActive", false] call SpyderAddons_fnc_hashSet;

        [MOD(callToPrayer),"start", [_buildings,_whitelist,_blacklist,_manual,_autoPopulate]] call MAINCLASS;
    };

    case "start": {
        _args params ["_buildings","_whitelist","_blacklist","_manual","_autoPopulate"];

        _locs = [];

        _cityTypes = ["NameVillage","NameCity","NameCityCapital"];
        _locations = configfile >> "CfgWorlds" >> worldName >> "Names";

        for "_i" from 0 to (count _locations - 1) do {
            _loc = _locations select _i;
            _locType = getText(_loc >> "type");

            if (_locType in _cityTypes) then {
                _locPos = getArray(_loc >> "position");
                private _valid = true;

                {
                    if !(markerPos _x isEqualTo [0,0,0]) then {
                        if ([_x,_locPos] call BIS_fnc_inTrigger) exitwith {
                            _valid = false;
                        };
                    };
                } forEach _blacklist;

                if (_valid && {count _whitelist > 0}) then {
                    _valid = false;
                    {
                        if !(markerColor _x isEqualTo [0,0,0]) then {
                            if ([_x,_locPos] call BIS_fnc_inTrigger) exitwith {
                                _valid = true;
                            };
                        };
                    } foreach _whitelist;
                };

                if (_valid) then {
                    _locs pushback _locPos;
                };
            };
        };

        {
            _locs pushback (markerPos _x);
        } foreach _manual;

        // create loudspeakers

        _loudspeakers = [];
        {
            _pos = _x;

            if (count _buildings > 0) then {
                _nearobjects = nearestobjects [_x, _buildings, 500];

                if (count _nearobjects > 0) then {
                    {
                        _pos = getPosATL _x;
                        _pos = [_pos, 1, 15, 1, 0, 0, 0] call BIS_fnc_findSafePos;
                        _pole = "Land_Loudspeakers_F" createVehicle _pos;
                        _loudspeakers pushback _pole;
                    } foreach _nearobjects;
                } else {
                    if (_autoPopulate) then {
                        _pos = [_pos, 1, 50, 1, 0, 0, 0] call BIS_fnc_findSafePos;
                        _pole = "Land_Loudspeakers_F" createVehicle _pos;
                        _loudspeakers pushback _pole;
                    };
                };
            } else {
                _pos = [_pos, 1, 50, 1, 0, 0, 0] call BIS_fnc_findSafePos;
                _pole = "Land_Loudspeakers_F" createVehicle _pos;
                _loudspeakers pushback _pole;
            };
        } foreach _locs;

        {
            _x setmarkeralpha 0;
        } foreach (_whitelist + _blacklist + _manual);

        if (_debug) then {
            {
                _pos = getPosATL _x;
                _marker = createMarker [str _pos, _pos];
                _marker setMarkerShape "ICON";
                _marker setMarkerType "mil_dot";
                _marker setMarkerColor "ColorGreen";
                _marker setMarkerText "CTP Speaker";
            } foreach _loudspeakers;
        };

        [_logic,"loudspeakers", _loudspeakers] call SpyderAddons_fnc_hashSet;

        // start cycle
        [] spawn {
            waitUntil {
                [SpyderAddons_callToPrayer,"cycle"] call SpyderAddons_fnc_callToPrayer;
                sleep 120;

                false
            };
        };
    };

    case "cycle": {
        private _debug = [_logic,"debug", false] call SpyderAddons_fnc_hashGet;
        private _timesOfPrayer = [_logic,"timesOfPrayer", []] call SpyderAddons_fnc_hashGet;
        private _moveCivs = [_logic,"moveCivs", false] call SpyderAddons_fnc_hashGet;
        private _prayerActive = [_logic,"prayerActive", false] call SpyderAddons_fnc_hashGet;
        private _loudspeakers = [_logic,"loudspeakers"] call SpyderAddons_fnc_hashGet;

        private _inTime = false;
        private _currTime = daytime;

        {
            _x params ["_startTime","_endTime"];
            if (_currTime >= _startTime && {_currTime < _endTime}) exitwith {
                _inTime = true;

                if !(_prayerActive) then {
                    [_logic,"prayerActive", true] call ALiVE_fnc_hashSet;
                    _prayerActive = true;

                    _sounds = [_logic,"sounds", []] call SpyderAddons_fnc_hashGet;

                    {
                        if (alive _x) then {
                            [_x, [selectRandom _sounds,650]] remoteExecCall ["say3D"];

                            if (_moveCivs) then {
                                [_logic,"moveCivs", _x] call MAINCLASS;
                            };
                        };
                    } foreach _loudspeakers;

                    if (_debug) then {
                        ["[SpyderAddons] Call to Prayer: Playing prayer - %3 <= %4 <= %5", _startTime, _currTime, _endTime] call SpyderAddons_fnc_log;
                    };
                };
            };
        } foreach _timesOfPrayer;

        if (_prayerActive && {!_inTime}) then {
            [_logic,"prayerActive", false] call SpyderAddons_fnc_hashSet;
            _prayerActive = false;

            if (_moveCivs) then {
                [_logic,"resetCivs"] call MAINCLASS;
            };
        };
    };

    case "moveCivs": {
        _speaker = _args;
        _pos = getPos _speaker;
        _civs = [_logic,"civs", []] call SpyderAddons_fnc_hashGet;

        {
            if (side _x == civilian) then {
                _wp = (group _x) addWaypoint [[(_pos select 0) + random 7,(_pos select 1) + random 7], 0];
                _wp setWaypointStatements ["true", "{_x action ['SITDOWN',_x]} foreach thisList"];
                _x forceWalk true;
                _x setVariable ["SM_CTP_prevPos", getPos _x];
                _civs pushbackUnique _x;
            };
        } foreach (_pos nearEntities 300);
    };

    case "resetCivs": {
        {
            _retPos = _x getVariable ["SM_CTP_prevPos", getPos _x];
            _wp = (group _x) addWaypoint [_retPos, 15];
            _wp setWaypointStatements ["true", "{_x forceWalk false} foreach thisList"];
            _x setVariable ["SM_CTP_prevPos", nil];
        } foreach ([_logic,"civs", []] call SpyderAddons_fnc_hashGet);

        [_logic,"civs", []] call SpyderAddons_fnc_hashSet;
    };

    default {
        _result = [] call SpyderAddons_fnc_hashCreate;
    };

};

if (!isnil "_result") then {_result} else {nil};