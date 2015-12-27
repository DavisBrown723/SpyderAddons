/* ----------------------------------------------------------------------------
Function: SpyderAddons_fnc_openRequiresAlive

Description:
Opens a menu notifying the player that the passed module name 
requires ALiVE to be running in order to function

Parameters:
String - Module name

Returns:
None

Examples:
(begin example)
["Civilian Interaction"] call SpyderAddons_fnc_openRequiresAlive;
(end)

See Also:
- nil

Author: SpyderBlack723
---------------------------------------------------------------------------- */

params ["_module"];

//-- Open the menu
CreateDialog "SpyderAddons_RequiresALiVE";

//-- Set warning text
(findDisplay 10090 displayCtrl 10093) ctrlSetText (format ["%1 requires ALiVE to be running in order to function. Please download ALiVE if you wish to use this module. https://alivemod.com/#Download", _module]);