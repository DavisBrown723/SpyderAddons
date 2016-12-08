#include <\x\spyderaddons\addons\x_lib\script_component.hpp>

/* ----------------------------------------------------------------------------
Function: SpyderAddons_fnc_baseClass

Description:
A base class for objects to inherit from

Parameters:
Array - Hash object
String - Operation
Any - Arguments

Returns:
Result of operation

Examples:
(begin example)
(end)

See Also:
-nil

Author:
SpyderBlack723

peer reviewed:
-nil
---------------------------------------------------------------------------- */

#define SUPERCLASS  nil
#define MAINCLASS   FUNC(baseClass)

private ["_result"];
params [
    ["_logic", objNull, [objNull,[]]],
    ["_operation", "", [""]],
    ["_args", objNull]
];

switch (_operation) do {

    case "create": {
        _logic = createAgent ["LOGIC", [0,0], [], 0, "NONE"];
        _logic setVariable ["superclass", QUOTE(SUPERCLASS)];
        _logic setVariable ["mainclass", QUOTE(MAINCLASS)];
        _logic enableSimulation false;
        _result = _logic;
    };

    case "superclass": {
        if (typename _args == "STRING") then {
            _logic setVariable [_operation,_args];
            _result = _args;
        } else {
            _result = _logic getVariable _operation;
        };
    };

    case "mainclass": {
        if (typename _args == "STRING") then {
            _logic setVariable [_operation,_args];
            _result = _args;
        } else {
            _result = _logic getVariable _operation;
        };
    };

    case "destroy": {
        deleteVehicle _logic;
        _result = true;
    };

    default {
        ["[SpyderAddons]: Object %1 does not support operation ""%2""", _logic, _operation] call FUNC(log);
    };

};

// return result if any exists
if (!isnil "_result") then {_result} else {nil};