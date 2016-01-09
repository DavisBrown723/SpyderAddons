#include <\x\spyderaddons\addons\amb_ambiance\script_component.hpp>

/* ----------------------------------------------------------------------------
Function: SpyderAddons_fnc_ambianceInit

Description:
Initializes ambiance

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

params ["_logic","_syncedUnits"];

_enable = call compile (_logic getvariable ["Enable","false"]);
if !(_enable) exitWith {["[%1 - %2] Module has been disabled, exiting", QUOTE(PREFIX),QUOTE(COMPONENT)] call SpyderAddons_fnc_log};

// Confirm init function available
if (isNil "SpyderAddons_fnc_insurgency") exitWith {["[%1 - %2] Main function missing", QUOTE(PREFIX),QUOTE(COMPONENT)] call SpyderAddons_fnc_log};

["[%1 - %2] Initialization starting", QUOTE(PREFIX),QUOTE(COMPONENT)] call SpyderAddons_fnc_log;

[_logic,"init", _syncedUnits] call SpyderAddons_fnc_ambiance;

["[%1 - %2] Initialization complete", QUOTE(PREFIX),QUOTE(COMPONENT)] call SpyderAddons_fnc_log;

true