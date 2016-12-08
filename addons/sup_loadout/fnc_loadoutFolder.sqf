#include <\x\spyderaddons\addons\sup_loadout\script_component.hpp>
SCRIPT(loadoutFolder);

/* ----------------------------------------------------------------------------
Function: SpyderAddons_fnc_loadoutFolder

Description:
Main handler for folder list entries

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

#define SUPERCLASS  FUNC(loadoutListEntry)
#define MAINCLASS   FUNC(loadoutFolder)

init_OOP();

params [
    ["_logic", objNull, [objNull,[]]],
    ["_operation", "", [""]],
    ["_args", objNull]
];

switch (_operation) do {

    method( "create" ) {

        _result = _this call SUPERCLASS;

        [_result,"init"] call MAINCLASS;

    };

    method( "init" ) {

        [_logic,"superclass", QUOTE(SUPERCLASS)] call FUNC(hashSet);
        [_logic,"mainclass", QUOTE(MAINCLASS)] call FUNC(hashSet);

        [_logic,"dataType", "folder"] call FUNC(hashSet);

        [_logic,"contents", []] call FUNC(hashSet);

    };

    method( "contents" ) {

        if (typename _args == "ARRAY") then {
            [_logic,_operation,_args] call FUNC(hashSet);
            return _args;
        } else {
            return [_logic,_operation] call FUNC(hashGet);
        };

    };

    method( "getDetailDataSource" ) {

        private ["_name","_dataType","_id","_image"];

        _result = [];
        private _contents = [_logic,"contents"] call FUNC(hashGet);

        {
            _dataID = _x;
            _data = [MOD(loadoutManager),"getData", _dataID] call FUNC(loadoutManager);

            _name = [_data,"name"] call FUNC(hashGet);
            _dataType = [_data,"dataType"] call FUNC(hashGet);
            _id = [_data,"id"] call FUNC(hashGet);

            if (_dataType == "loadout") then {
                _image = QUOTE(CIMAGES(COMPONENT)\loadout.paa);
            } else {
                _image = QUOTE(CIMAGES(COMPONENT)\folder.paa);
            };

            _result pushback [_name,_image,"",_id];
        } foreach _contents;

    };

    defaultMethod();

};

if (!isnil "_result") then {_result} else {nil};