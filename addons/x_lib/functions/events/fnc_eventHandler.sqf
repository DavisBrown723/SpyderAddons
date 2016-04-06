#include "\x\spyderaddons\addons\x_lib\script_component.hpp"
SCRIPT(eventHandler);

/* ----------------------------------------------------------------------------
Function: SpyderAddons_fnc_eventHandler

Description:
Main handler for events

Parameters:
Object - Logic
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

#define MAINCLASS SpyderAddons_fnc_eventHandler

private ["_result"];
params [
	["_logic", objNull],
	["_operation", ""],
	["_arguments", []]
];

switch (_operation) do {

	case "create": {
        _result = [] call ALiVE_fnc_hashCreate;
	};

	case "init": {
		[_logic,"nextListenerID", 0] call ALiVE_fnc_hashSet;
		[_logic,"listeners", ([] call ALiVE_fnc_hashCreate)] call ALiVE_fnc_hashSet;
	};

	case "addListener": {
		_arguments params ["_listener","_filters"];
		_listenerHash = [_logic,"listeners"] call ALiVE_fnc_hashGet;
		_listenerID = [_logic,"nextListenerID"] call ALiVE_fnc_hashGet;
		[_logic,"nextListenerID", (_listenerID + 1)] call ALiVE_fnc_hashSet;

		{
			_listeners = [_listenerHash,_x, ([] call ALiVE_fnc_hashCreate)] call ALiVE_fnc_hashGet;
			[_listeners,_listenerID, _listener] call ALiVE_fnc_hashSet;
			[_listenerHash,_x, _listeners] call ALiVE_fnc_hashSet;
		} forEach _filters;
	};

	case "addEvent": {
		_event = _arguments;
		_type = (_event select 2) select 1;
		_listenerHash = [_logic,"listeners"] call ALiVE_fnc_hashGet;

		{
			_listener = _x;

			switch (typeName _listener) do {

				case "OBJECT": {_event call (_listener getVariable ["mainclass",{}])};
				case "STRING": {
					_script = compile _listener;
					_event call _script;
				};
				case "CODE": {_event call _listener};
                default {
                    if (_listener call SpyderAddons_fnc_isHash) then {
                        [_listener,"eventReceived",_event] call ([_listener,"mainclass",{}] call SpyderAddons_fnc_hashGet);
                    };
                };

			};
		} forEach (([_listenerHash,_type, ([] call ALiVE_fnc_hashCreate)] call ALiVE_fnc_hashGet) select 2);
	};

	case "removeListener": {
		_id = _arguments;
		_listenerHash = [_logic,"listeners"] call ALiVE_fnc_hashGet;
		_keys = _listenerHash select 1;

		{
			_key = _x;
			_filterHash = [_listenerHash,_key] call ALiVE_fnc_hashGet;

			if (_id in (_filterHash select 1)) then {
				[_filterHash,_id] call ALiVE_fnc_hashRem;
			};
		} forEach _keys;
	};

};

//-- Return result if any exists
if (!isNil "_result") then {_result} else {nil};