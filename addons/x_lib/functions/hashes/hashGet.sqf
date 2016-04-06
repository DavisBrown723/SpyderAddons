/* ----------------------------------------------------------------------------
Function: SpyderAddons_fnc_hashGet

Description:
Retrieves the value tied to the passed key from a hash

Parameters:
String - Key

Returns:
Any - If it exists, stored variable, else defaultValue

Examples:
(begin example)
_hash = [] call SpyderAddons_fnc_hashCreate;
[_hash,"key","value"] call SpyderAddons_fnc_hashSet;
_value = [_hash,"key"] call SpyderAddons_fnc_hashGet; // returns: "value"
(end)

Author:
SpyderBlack723

peer reviewed:
-nil
---------------------------------------------------------------------------- */

private ["_result"];
params ["_object","_key","_defaultValue"];

if (_object call SpyderAddons_fnc_isHash) then {
    _index = (_object select 1) find _key;
    if (_index != -1) then {
        _result = (_object select 2) select _index;
    };
};

if (isnil "_result") then {
    if (!isnil "_defaultValue") then {
        if (typename _defaultValue == "ARRAY") then {+_defaultValue} else {_defaultValue};
    };
} else {_result};