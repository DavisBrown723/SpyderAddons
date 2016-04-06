/* ----------------------------------------------------------------------------
Function: SpyderAddons_fnc_callToPrayerInit

Description:
Initializes call to prayer

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

params ["_logic"];

_enable = call compile (_logic getVariable ["Enable",false]);
if !(_enable) exitWith {["[SpyderAddons - Call to Prayer] Module has been disabled, exiting"] call SpyderAddons_fnc_log};

// Confirm init function available
if (isNil "SpyderAddons_fnc_callToPrayer") exitWith {["[SpyderAddons - Call to Prayer] Main function missing"] call SpyderAddons_fnc_log};

["[SpyderAddons - Call to Prayer] Initialization starting"] call SpyderAddons_fnc_log;

[_logic,"init"] call SpyderAddons_fnc_callToPrayer;

["[SpyderAddons - Call to Prayer] Initialization complete"] call SpyderAddons_fnc_log;

true