#include <\x\spyderaddons\addons\sup_loadout\script_component.hpp>
SCRIPT(loadoutAddServerData);

/* ----------------------------------------------------------------------------
Function: SpyderAddons_fnc_addServerData

Description:
Adds data to the server-side store

Parameters:
Array - Data

Returns:
None

Examples:
(begin example)
(end)

Author: SpyderBlack723
---------------------------------------------------------------------------- */

//if (!isServer) exitWith {_this remoteExecCall [QFUNC(addServerData),2]};
if (!isServer) exitWith {};

private _data = _this;
_data params ["_keys","_data"];

waitUntil {!isnil QMOD(loadoutSystem)};

private _mainFolder = [MOD(loadoutSystem),"mainFolder"] call FUNC(loadoutSystem);

private ["_iterKey","_iterData","_iterDataType","_iterDataID","_newID"];
for "_i" from 0 to (count _keys - 1) do {
    _iterKey = _keys select _i;
    _iterData = _data select _i;

    _newID = [MOD(loadoutSystem),"convertIDsToServerIDs", [_iterData,_data]] call FUNC(loadoutSystem);

    [MOD(loadoutSystem),"addData", [_iterData,_newID]] call FUNC(loadoutSystem);

    if (_i == 0) then {
        [MOD(loadoutSystem),"folderAddData", [_mainFolder,_iterData]] call FUNC(loadoutSystem);
    };
};