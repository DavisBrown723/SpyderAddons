/* ----------------------------------------------------------------------------
Function: SpyderAddons_fnc_detectionInit

Description:
Initializes detection

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
if !(_enable) exitWith {["[SpyderAddons - Mil Detection] Module has been disabled, exiting"] call SpyderAddons_fnc_log};

// Confirm init function available
if (isNil "SpyderAddons_fnc_detection") exitWith {["[SpyderAddons - Mil Detection] Main function missing"] call SpyderAddons_fnc_log};

["[SpyderAddons - Mil Detection] Initialization starting"] call SpyderAddons_fnc_log;

["init",[_logic,_syncedUnits]] call SpyderAddons_fnc_detection;

["[SpyderAddons - Mil Detection] Initialization complete"] call SpyderAddons_fnc_log;

true