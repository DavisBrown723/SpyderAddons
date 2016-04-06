/* ----------------------------------------------------------------------------
Function: SpyderAddons_fnc_hashAppend

Description:
Appends one hash to the back of another

Parameters:
Array - Hash

Returns:
Array - Reference to supplemented hash

Examples:
(begin example)
[_hash1, _hash2] call SpyderAddons_fnc_hashAppend;
(end)

Author:
SpyderBlack723

peer reviewed:
-nil
---------------------------------------------------------------------------- */

params ["_hashOne","_hashTwo"];

if (_hashOne call SpyderAddons_fnc_isHash) then {
    (_hashOne select 1) append (_hashTwo select 1);
    (_hashOne select 2) append (_hashTwo select 2);
};

_hashOne