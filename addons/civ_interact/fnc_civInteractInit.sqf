/* ----------------------------------------------------------------------------
Function: SpyderAddons_fnc_civInteractInit

Description:
Initializes civilian interaction

Parameters:
Object - Module Object
Array - Synchronized units

Returns:
nil

Author:
SpyderBlack723

Peer Reviewed:
nil
---------------------------------------------------------------------------- */

private ["_logic","_moduleID"];
params ["_logic"];

_enable = call compile (_logic getvariable ["Enable","false"]);
if !(_enable) exitWith {["[SpyderAddons - Civ Interact] Module has been disabled, exiting"] call SpyderAddons_fnc_log};

// Confirm init function available
if (isNil "SpyderAddons_fnc_civInteract") exitWith {["[SpyderAddons - Civ Interact] Main function missing"] call SpyderAddons_fnc_log};

["[SpyderAddons - Civ Interact] Initialization starting"] call SpyderAddons_fnc_log;

[_logic,"init"] call SpyderAddons_fnc_civInteract;

["[SpyderAddons - Civ Interact] Initialization complete"] call SpyderAddons_fnc_log;

true