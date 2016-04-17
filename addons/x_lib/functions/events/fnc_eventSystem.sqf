#include <\x\spyderaddons\addons\x_lib\script_component.hpp>
SCRIPT(eventSystem);

/* ----------------------------------------------------------------------------
Function: SpyderAddons_fnc_eventSystem

Description:
Main handler for listeners and events

Parameters:
Object - Logic
String - Operation
Any - Arguments

Returns:
Any - Result fo the operation

Examples:

Author:
SpyderBlack723
---------------------------------------------------------------------------- */

#define MAINCLASS SpyderAddons_fnc_eventSystem

private ["_logic"];

params [
    ["_logic", objNull, [objNull,[]]],
    ["_operation", "", [""]],
    ["_args", objNull]
];

switch (_operation) do {

    case "create": {

        _result = [] call ALiVE_fnc_hashCreate;

    };

    case "init": {

        [_logic,"listenerCount", 0] call MAINCLASS;

        [_logic,"listeners", [] call ALiVE_fnc_hashCreate] call MAINCLASS;

        [_logic,"listenersByFilter", [] call ALiVE_fnc_hashCreate] call MAINCLASS;

    };

    case "listenerCount": {

        if (typename _args == "SCALAR") then {
            [_logic,_operation,_args] call ALiVE_fnc_hashSet;
            _result = _args;
        } else {
            _result = [_logic,_operation]  call ALiVE_fnc_hashGet;
        };

    };

    case "getNextListenerID": {

        _listenerCount = [_logic,"listenerCount"] call MAINCLASS;
        _newCount = _listenerCount + 1;

        [_logic,"listenerCount", _newCount] call ALiVE_fnc_hashSet;

        _result = _newCount;

    };

    case "listeners": {

        if (typename _args == "ARRAY") then {
            [_logic,_operation,_args] call ALiVE_fnc_hashSet;
            _result = _args;
        } else {
            _result = [_logic,_operation] call ALiVE_fnc_hashGet;
        };

    };

    case "listenersByFilter": {

        if (typename _args == "ARRAY" && {_args call SpyderAddons_fnc_isHash}) then {
            [_logic,_operation,_args] call ALiVE_fnc_hashSet;
            _result = _args;
        } else {
            _result = [_logic,_operation] call ALiVE_fnc_hashSet;
        };

    };

    case "addListener": {

        if (typename _args == "ARRAY") then {

            _args params [
                ["_listener", objNull, [objNull,[]]],
                ["_filters", [], [[]]]
            ];

            if (_filters isEqualTo []) exitWith {
                ["[%1]: %2 - Listener wasn't assigned any filters, exiting. Called from %3", QUOTE(ADDON), _operation, _fnc_scriptNameParent] call SpyderAddons_fnc_log;
            };

            _listeners = [_logic,"listeners"] call MAINCLASS;
            _listenersByFilter = [_logic,"listenersByFilter"] call MAINCLASS;

            _listenerID = [_logic,"getNextListenerID"] call MAINCLASS;

            [_listeners,_listenerID,_args] call ALiVE_fnc_hashCreate;

            _keys = _listenersByFilter select 1;
            {
                if (_x in _filters) then {
                    _listenersForFilter = [_listenersByFilter,_x] call ALiVE_fnc_hashCreate;
                    [_listenersForFilter,_listenerID,_listener] call ALiVE_fnc_hashSet;
                } else {
                    _listenersForFilter = [] call ALiVE_fnc_hashSet;
                    [_listenersForFilter,_listenerID,_listener] call ALiVE_fnc_hashSet;
                    [_listenersByFilter,_x, _listenersForFilter] call ALiVE_fnc_hashSet;
                };
            } foreach _filters;
        };

    };

    case "registerEvent": {

        _event = _args;
        _event params [
            ["_type", "", [""]],
            ["_data", []],
            ["_from", "", [""]],
            ["_message", "", [""]]
        ];

        if (_type == "") exitWith {
            ["[%1] - Event has no type, exiting. Sender: %2", QUOTE(ADDON), _from] call SpyderAddons_fnc_log;
        };

        _listeners = [_logic,"listeners"] call MAINCLASS;

        {
            if (_type in (_x select 1)) then {
                _listener = _x select 0;

                [_listener,_data] spawn {
                    params ["_listener","_data"];
                    _class = _listener getVariable ["class",{}];

                    [_listener,"handleEvent", _data] call _class;
                };
            };
        } foreach (_listeners select 2);

    };

    case "removeListenerByID": {

        _id = _args;

        if (typename _id == "SCALAR") then {

            // remove from listeners hash

            _listeners = [_logic,"listeners"] call MAINCLASS;

            if ([_listener,_id] call ALiVE_fnc_hashHasKey) then {

                _filters = ([_listeners,_id] call ALiVE_fnc_hashGet) select 1;
                [_listeners,_id] call ALiVE_fnc_hashRem;

                // remove from listenersByFilter hash

                _listenersByFilter = [_logic,"listenersByFilter"] call MAINCLASS;

                {
                    _listenersForFilter = [_listenersByFilter,_x] call ALiVE_fnc_hashGet;
                    [_listenersForFilter,_id] call ALiVE_fnc_hashRem;
                } foreach _filters;

            };

        };

    };

    case "removeListenersByFilter": {

        _filter = _args;

        _listenersByFilter = [_logic,"listenersByFilter"] call MAINCLASS;

        _listenersForFilter = [_listenersByFilter,_filter] call ALiVE_fnc_hashGet;
        _listenerIDs = _listenersForFilter select 1;

        // remove from listenersByFilter hash

        [_listenersByFilter,_filter] call ALiVE_fnc_hashRem;

        // remove from listeners hash

        _listeners = [_logic,"listeners"] call MAINCLASS;

        {
            [_listeners,_x] call ALiVE_fnc_hashRem;
        } foreach _listenerIDs;

    };

    case "getListenerByID": {

        _id = _args;

        _listeners = [_logic,"listeners"] call MAINCLASS;
        _result = [_listeners,_id] call ALiVE_fnc_hashGet;

    };

    case "getListenersByFilter": {

        _filter = _args;

        _listenersByFilter = [_logic,"listenersByFilter"] call MAINCLASS;
        _result = [_listenersByFilter,_filter, [] call ALiVE_fnc_hashCreate] call ALiVE_fnc_hashSet;

    };

    case "clearListeners": {

        [_logic,"listeners", [] call ALiVE_fnc_hashCreate] call MAINCLASS;

        [_logic,"listenersByFilter", [] call ALiVE_fnc_hashCreate] call MAINCLASS;

    };

    case "removeFiltersFromListenerByID": {

        _args params [
            ["_id", -1, [0]],
            ["_filtersToRemove", [], [[]]]
        ];

        if (_id == -1) exitWith {
            ["[%1]: %2 - No listener ID given or listener ID is not a number, exiting. Called from %3", QUOTE(ADDON), _operation, _fnc_scriptNameParent] call SpyderAddons_fnc_log;
        };

        _listener = [_logic,"getListenerByID"] call MAINCLASS;
        _filters = _listener select 1;

        // get array of all filters that exist for the listener

        _presentFilters = [];

        {
            _filterToRemove = _x;
            _foundIndex = _filters find _filterToRemove;

            if (_foundIndex != -1) then {
                _filters deleteAt _foundIndex;

                _presentFilters pushback _filterToRemove;
            };
        } foreach _filtersToRemove;

    };

};

// return result if any exists
if !(isnil "_result") then {_result} else {nil};