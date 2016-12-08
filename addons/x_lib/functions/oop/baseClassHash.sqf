#include <\x\spyderaddons\addons\x_lib\script_component.hpp>

/* ----------------------------------------------------------------------------
Function: SpyderAddons_fnc_baseClassHash

Description:
A base class for hash objects to inherit from

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
#define MAINCLASS   FUNC(baseClassHash)

private ["_result"];
params [
    ["_logic", objNull, [objNull,[]]],
    ["_operation", "", [""]],
    ["_args", objNull]
];

switch (_operation) do {

    case "create": {
        _result = [] call FUNC(hashCreate);
        [_result,"superclass", QUOTE(SUPERCLASS)] call FUNC(hashSet);
        [_result,"mainclass", QUOTE(MAINCLASS)] call FUNC(hashSet);
    };

    case "superclass": {
        if (typename _args == "STRING") then {
            [_logic,_operation,_args] call FUNC(hashSet);
            _result = _args;
        } else {
            _result = [_logic,_operation] call FUNC(hashGet);
        };
    };

    case "mainclass": {
        if (typename _args == "STRING") then {
            [_logic,_operation,_args] call FUNC(hashSet);
            _result = _args;
        } else {
            _result = [_logic,_operation] call FUNC(hashGet);
        };
    };

    case "destroy": {
        _logic = nil;
        _result = true;
    };

    default {
        ["[SpyderAddons]: Hash %1 does not support operation ""%2""", _logic, _operation] call FUNC(log);
    };

};

// return result if any exists
if (!isnil "_result") then {_result} else {nil};