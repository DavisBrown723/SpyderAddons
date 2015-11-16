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
if !(_enable) exitWith {["[SpyderAddons - Civ Interact] Module has been disabled, exiting"] call ALIVE_fnc_dump};

// Confirm init function available
if (isNil "SpyderAddons_fnc_civInteract") exitWith {["[SpyderAddons - Civ Interact] Main function missing"] call ALIVE_fnc_dump};

["[SpyderAddons - Civ Interact] Initialization starting"] call ALIVE_fnc_dump;

["init",_logic] call SpyderAddons_fnc_civInteract;

["[SpyderAddons - Civ Interact] Initialization complete"] call ALIVE_fnc_dump;

true