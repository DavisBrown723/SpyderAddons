/* ----------------------------------------------------------------------------
Function: SpyderAddons_fnc_hashCreate

Description:
Creates an object to store settings

Parameters:
Array

Returns:
Array - Object to store settings

Examples:
(begin example)
_hash = [] call SpyderAddons_fnc_hashCreate;
(end)

Author:
SpyderBlack723

peer reviewed:
-nil
---------------------------------------------------------------------------- */

private ["_result"];

if (typename _this == "ARRAY") then {
    if (count _this == 0) then {
        _result = ["#SA_HASH#",[],[]];
    } else {
        _result = ["#SA_HASH#",_this select 0,_this select 1];
    };
};

_result