/* ----------------------------------------------------------------------------
Function: SpyderAddons_fnc_vehicleSpawnerInit

Description:
Initializes the vehicle spawner

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
if !(_enable) exitWith {["[SpyderAddons - Sup Vehiclespawn] Module has been disabled, exiting"] call SpyderAddons_fnc_log};

// Confirm init function available
if (isNil "SpyderAddons_fnc_vehicleSpawner") exitWith {["[SpyderAddons - Sup Vehiclespawn] Main function missing"] call SpyderAddons_fnc_log};

["[SpyderAddons - Sup Vehiclespawn] Initialization starting"] call SpyderAddons_fnc_log;

["init",[_logic,_syncedUnits]] call SpyderAddons_fnc_vehicleSpawner;

["[SpyderAddons - Sup Vehiclespawn] Initialization complete"] call SpyderAddons_fnc_log;