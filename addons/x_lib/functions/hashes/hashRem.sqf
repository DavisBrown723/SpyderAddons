/* ----------------------------------------------------------------------------
Function: SpyderAddons_fnc_hashRem

Description:
Removes a value-data pair from an object

Parameters:
String - Key

Returns:
none

Examples:
(begin example)
_hash = [] call SpyderAddons_fnc_hashCreate;
[_hash,"key","value"] call SpyderAddons_fnc_hashSet;
[_hash,"key"] call SpyderAddons_fnc_hashRem;
(end)

Author:
SpyderBlack723

peer reviewed:
-nil
---------------------------------------------------------------------------- */

params ["_object","_key"];

if (_object call SpyderAddons_fnc_isHash) then {
    [_object,_key,nil] call SpyderAddons_fnc_hashSet;
};