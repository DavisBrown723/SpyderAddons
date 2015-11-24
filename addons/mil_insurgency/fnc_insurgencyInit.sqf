/* ----------------------------------------------------------------------------
Function: SpyderAddons_fnc_insurgencyInit

Description:
Initializes insurgency

Parameters:
Object - Module object
Array - Synchronized units

Returns:
nil

Author:
SpyderBlack723

Peer Reviewed:
nil
---------------------------------------------------------------------------- */

private ["_logic","_moduleID"];
params ["_logic","_syncedUnits"];

_enable = call compile (_logic getvariable ["Enable","false"]);
if !(_enable) exitWith {["[SpyderAddons - Mil Insurgency] Module has been disabled, exiting"] call SpyderAddons_fnc_log};

// Confirm init function available
if (isNil "SpyderAddons_fnc_insurgency") exitWith {["[SpyderAddons - Mil Insurgency] Main function missing"] call SpyderAddons_fnc_log};

["[SpyderAddons - Mil Insurgency] Initialization starting"] call SpyderAddons_fnc_log;

[_logic,"init",_syncedUnits] call SpyderAddons_fnc_insurgency;

["[SpyderAddons - Mil Insurgency] Initialization complete"] call SpyderAddons_fnc_log;

true