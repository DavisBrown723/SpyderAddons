#include <\x\spyderaddons\addons\x_lib\script_component.hpp>

/* ----------------------------------------------------------------------------
Function: SpyderAddons_fnc_dumpModuleInit

Description:
Dumps module initialization information to the rpt

Parameters:
Array - Module to be inspected

Returns:
none

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

params [
    ["_module", objNull, [objNull]],
    ["_start", false, [false]]
];

if (isnil QMOD(modulesToInit)) then {
    ["---------------------------------------------------"] call SpyderAddons_fnc_log;
    ["SpyderAddons - Beginning Initialization"] call SpyderAddons_fnc_log;
    ["---------------------------------------------------"] call SpyderAddons_fnc_log;

    MOD(modulesToInit) = [] call SC_fnc_hashCreate;
    MOD(moduleCount) = 1;
};

if (_start) then {
    // start module init

    [MOD(modulesToInit), _module, diag_ticktime] call SpyderAddons_fnc_hashSet;
} else {
    // finish module init

    private _startTime = [SC_modulesToInit, _module] call SpyderAddons_fnc_hashGet;
    private _functionPriority = getNumber (configfile >> "CfgVehicles" >>  (typeOf _module) >> "functionPriority");

    ["Module Initializing -- Module Type: %1 | Function Priority: %2 | Module to init: %3 | Time to init: %4", typeOf _module, _functionPriority, SC_moduleCount, diag_ticktime - _startTime] call SpyderAddons_fnc_log;

    [MOD(modulesToInit), _module] call SpyderAddons_fnc_hashRem;
    MOD(moduleCount) = MOD(moduleCount) + 1;
};