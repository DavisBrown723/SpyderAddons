/* ----------------------------------------------------------------------------
Function: SpyderAddons_fnc_hashSet

Description:
Stores a value-data pair to an object

Parameters:
String - Key
Any - Value

Returns:
none

Examples:
(begin example)
_hash = [] call SpyderAddons_fnc_hashCreate;
[_hash,"key","data"] call SpyderAddons_fnc_hashSet;
(end)

Author:
SpyderBlack723

peer reviewed:
-nil
---------------------------------------------------------------------------- */

params ["_object","_key","_value"];

if (_object call SpyderAddons_fnc_isHash) then {
    private _keys = _object select 1;
    private _values = _object select 2;
    private _index = _keys find _key;

    if (isnil "_value") then {
        if (_index != -1) then {
            _keys deleteAt _index;
            (_object select 2) deleteAt _index;
        };
    } else {
        if (_index == -1) then {
            (_object select 1) pushback _key;
            (_object select 2) pushback _value;
        } else {
            _values set [_index,_value];
        };
    };
};