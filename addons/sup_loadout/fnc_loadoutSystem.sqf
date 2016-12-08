#include <\x\spyderaddons\addons\sup_loadout\script_component.hpp>
SCRIPT(loadoutSystem);

/* ----------------------------------------------------------------------------
Function: SpyderAddons_fnc_loadoutSystem

Description:
Handles server side loadout manager data

Parameters:
Array - Logic
String - Operation
Any - Arguments

Returns:
Any - Result of the operation

Examples:
(begin example)
(end)

Author: SpyderBlack723
---------------------------------------------------------------------------- */

#define SUPERCLASS  FUNC(baseClassHash)
#define MAINCLASS   FUNC(loadoutSystem)

init_OOP();

params [
	["_logic", objNull],
	["_operation", ""],
	["_args", objNull]
];

switch (_operation) do {

    method( "create" ) {

        _result = _this call SUPERCLASS;

        [_result,"init"] call MAINCLASS;

    };

    method( "init" ) {

        private _dataDirectory = [] call FUNC(hashCreate);
        [_logic,"dataDirectory", _dataDirectory] call FUNC(hashSet);

        private _mainFolder = [nil,"create"] call FUNC(loadoutFolder);
        [_mainFolder,"name", "main"] call FUNC(loadoutFolder);

        [_logic,"mainFolder", _mainFolder] call FUNC(hashSet);
        [_logic,"addData", [_mainFolder,"main_server"]] call MAINCLASS;

    };

    method( "onLoadoutManagerInit" ) {

        if (isnil QMOD(loadoutSystem)) then {
            MOD(loadoutSystem) = [nil,"create"] call MAINCLASS;
        };

    };

    method( "dataDirectory" ) {

        if (typename _args == "ARRAY") then {
            [_logic,_operation,_args] call FUNC(hashSet);
            _result = _args;
        } else {
            _result = [_logic,_operation] call FUNC(hashGet);
        };

    };

    method( "mainFolder" ) {

        if (typename _args == "ARRAY") then {
            [_logic,_operation,_args] call FUNC(hashSet);
            _result = _args;
        } else {
            _result = [_logic,_operation] call FUNC(hashGet);
        };

    };

    method( "getNextDataID" ) {

        _result = format ["%1_%2", diag_tickTime, random 1000];

    };

    method( "addData" ) {

        _args params [
            "_data",
            ["_dataID","",[""]]
        ];

        private _dataDirectory = [_logic,"dataDirectory"] call MAINCLASS;

        if (_dataID == "") then {
            _dataID = [_logic,"getNextDataID"] call MAINCLASS;
        };

        [_dataDirectory,_dataID, _data] call FUNC(hashSet);

        [_data,"id", _dataID] call FUNC(hashSet);

        _result = _dataID;

    };

    method( "getData" ) {

        private _id = _args;

        if (typename _id == "STRING") then {
            private _dataDirectory = [_logic,"dataDirectory"] call MAINCLASS;
            _result = [_dataDirectory,_id] call FUNC(hashGet);
        } else {
            _result = _args;
        };

    };

    method( "deleteData" ) {

        private _dataID = _args;

        if (typename _dataID == "ARRAY") then {
            _dataID = [_dataID,"id"] call FUNC(hashGet);
        };

        private _dataDirectory = [_logic,"dataDirectory"] call MAINCLASS;
        [_dataDirectory,_dataID] call FUNC(hashRem);

    };

    method( "resetData" ) {

        [_logic,"destroy"] call MAINCLASS;

        MOD(loadoutSystem) = [nil,"create"] call MAINCLASS;

        _result = MOD(loadoutSystem);

    };

    method( "folderAddData" ) {

        _args params ["_folder","_data"];

        if (typename _folder == "STRING") then {
            _folder = [_logic,"getData", _folder] call MAINCLASS;
        };

        if (typename _data == "STRING") then {
            _data = [_logic,"getData", _data] call MAINCLASS;
        };

        private _folderID = [_folder,"id"] call FUNC(hashGet);
        private _dataID = [_data,"id"] call FUNC(hashGet);

        private _folderContents = [_folder,"contents"] call FUNC(hashGet);
        _folderContents pushback _dataID;

        [_data,"parent", _folderID] call FUNC(hashSet);

    };

    method( "folderRemoveData" ) {

        private "_dataID";
        _args params ["_folder","_data"];

        if (typename _folder == "STRING") then {
            _folder = [_logic,"getData", _folder] call MAINCLASS;
        };

        if (typename _data == "STRING") then {
            _dataID = _data;
            _data = [_logic,"getData", _dataID] call MAINCLASS;
        } else {
            _dataID = [_data,"id"] call FUNC(hashGet);
        };

        private _folderContents = [_folder,"contents"] call FUNC(hashGet);
        _folderContents deleteAt (_folderContents find _dataID);

        [_data,"parent", ""] call FUNC(hashSet);

    };

    method( "convertIDsToServerIDs" ) {

        private "_contentID";
        _args params ["_data","_dataArray"];

        // generate new server-unique id

        private _dataID = [_data,"id"] call FUNC(hashGet);
        private _newDataID = format ["%1_server_%2", _dataID, random 1000];
        [_data,"id", _newDataID] call FUNC(hashSet);

        // change parent folder's contents array

        {
            _contents = [_x,"contents",[]] call FUNC(hashGet);
            _foundIndex = _contents find _dataID;

            if (_foundIndex != -1) then {
                _contents set [_contents find _dataID, _newDataID];
            };
        } foreach _dataArray;

        // change parent value of each content item

        private _dataContents = [_data,"contents",[]] call FUNC(hashGet);

        {
            _contentID = _x;

            {
                if ([_x,"id"] call FUNC(hashGet) == _contentID) then {
                    [_x,"parent", _newDataID] call FUNC(hashSet);
                };
            } foreach _dataArray;
        } foreach _dataContents;

        _result = _newDataID;

    };

    method( "onDataRequest" ) {

        private _requester = _args;

        private _dataDirectory = [MOD(loadoutSystem),"dataDirectory"] call MAINCLASS;

        private _keys = _dataDirectory select 1;
        private _data = _dataDirectory select 2;

        private _mainFolder = [MOD(loadoutSystem),"mainFolder"] call MAINCLASS;
        private _mainFolderID = [_mainFolder,"id"] call FUNC(hashGet);

        ["onServerDataReceived", [_mainFolderID,_keys,_data]] remoteExecCall [QFUNC(loadoutManagerOnAction),_requester];

    };

    defaultMethod();

};

// return result if any exists
if (!isnil "_result") then {_result} else {nil};