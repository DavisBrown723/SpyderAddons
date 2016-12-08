#include <\x\spyderaddons\addons\sup_loadout\script_component.hpp>
SCRIPT(loadoutListEntry);

/* ----------------------------------------------------------------------------
Function: SpyderAddons_fnc_loadoutListEntry

Description:
Base class for loadout list entries

Parameters:
Array - Logic
String - Operation
Any - Arguments

Returns:
Any - Result of the operation

Examples:
(begin example)
(end)

Author: SpyderBlack723
---------------------------------------------------------------------------- */

#define SUPERCLASS  FUNC(baseClassHash)
#define MAINCLASS   FUNC(loadoutListEntry)

init_OOP();

params [
    ["_logic", objNull, [objNull,[]]],
    ["_operation", "", [""]],
    ["_args", objNull]
];

switch (_operation) do {

    method( "create" ) {

        _result = _this call SUPERCLASS;

        [_result,"init"] call MAINCLASS;

    };

    method( "init" ) {

        [_logic,"superclass", QUOTE(SUPERCLASS)] call FUNC(hashSet);
        [_logic,"mainclass", QUOTE(MAINCLASS)] call FUNC(hashSet);

        [_logic,"id", ""] call FUNC(hashSet);
        [_logic,"parent", ""] call FUNC(hashSet);
        [_logic,"dataType", "base"] call FUNC(hashSet);
        [_logic,"name", ""] call FUNC(hashSet);

    };

    method( "id" ) {

        if (typename _args == "STRING") then {
            [_logic,_operation,_args] call FUNC(hashSet);
            _result = _args;
        } else {
            _result = [_logic,_operation] call FUNC(hashGet);
        };

    };

    method( "parent" ) {

        if (typename _args == "STRING") then {
            [_logic,_operation,_args] call FUNC(hashSet);
            _result = _args;
        } else {
            _result = [_logic,_operation] call FUNC(hashGet);
        };

    };

    method( "dataType" ) {

        if (typename _args == "STRING") then {
            [_logic,_operation,_args] call FUNC(hashSet);
            _result = _args;
        } else {
            _result = [_logic,_operation] call FUNC(hashGet);
        };

    };

    method( "name" ) {

        if (typename _args == "STRING") then {
            [_logic,_operation,_args] call FUNC(hashSet);
            _result = _args;
        } else {
            _result = [_logic,_operation] call FUNC(hashGet);
        };

    };

    defaultMethod();

};

if (!isnil "_result") then {_result} else {nil};