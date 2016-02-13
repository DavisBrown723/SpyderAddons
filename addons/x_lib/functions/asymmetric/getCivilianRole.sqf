/* ----------------------------------------------------------------------------
Function: SpyderAddons_fnc_getCivilianRole

Description:
Returns a civilians ALiVE role (priest, townelder, etc)

Parameters:
Object - Civilian

Returns:
Role if it exists, else nil

Examples:
(begin example)
(end)

See Also:
- nil

Author: SpyderBlack723
---------------------------------------------------------------------------- */

private ["_role"];
_civ = _this;

{if (_civ getvariable [_x,false]) exitwith {_role = _x}} foreach ["townelder","major","priest","muezzin","politician"];

if !(isNil "_role") then {([_role] call CBA_fnc_capitalize)} else {nil};