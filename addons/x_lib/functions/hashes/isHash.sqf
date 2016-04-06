/* ----------------------------------------------------------------------------
Function: SpyderAddons_fnc_isHash

Description:
Determines whether or not the passed variable is a hash

Parameters:
Any

Returns:
Bool - true if passed variable is an object to store settings

Examples:
(begin example)
_hash = [] call SpyderAddons_fnc_hashCreate;
_hash call SpyderAddons_fnc_isHash; // returns true

[1,2,3] call SpyderAddons_fnc_isHash;    // returns false
(end)

Author:
SpyderBlack723

peer reviewed:
-nil
---------------------------------------------------------------------------- */

if (typename _this == "ARRAY" && {count _this == 3 || count _this == 4} && {(_this select 0) in ["#SA_HASH#","#CBA_HASH#"]}) then {true} else {false};