#include <\x\spyderaddons\addons\sup_loadout\script_component.hpp>
SCRIPT(loadoutManager);

/* ----------------------------------------------------------------------------
Function: SpyderAddons_fnc_loadoutManager

Description:
Main handler for the loadout manager

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
#define MAINCLASS   FUNC(loadoutManager)

//-- Define control IDs
#define LOADOUT_MANAGER_DISPLAY             7200

#define LOADOUT_MANAGER_HEADER_LEFT         7203
#define LOADOUT_MANAGER_HEADER_RIGHT        7204
#define LOADOUT_MANAGER_INSTRUCTIONS_LEFT   7225
#define LOADOUT_MANAGER_INSTRUCTIONS_RIGHT  7205
#define LOADOUT_MANAGER_COMBO_LEFT          7208
#define LOADOUT_MANAGER_LIST_LEFT           7209
#define LOADOUT_MANAGER_LIST_RIGHT          7210
#define LOADOUT_MANAGER_BUTTON_1            7211
#define LOADOUT_MANAGER_BUTTON_2            7212
#define LOADOUT_MANAGER_BUTTON_3            7213
#define LOADOUT_MANAGER_BUTTON_4            7214
#define LOADOUT_MANAGER_BUTTON_5            7215
#define LOADOUT_MANAGER_BUTTON_6            7216
#define LOADOUT_MANAGER_BUTTON_7            7217
#define LOADOUT_MANAGER_BUTTON_8            7218
#define LOADOUT_MANAGER_BUTTON_BIG_1        7219
#define LOADOUT_MANAGER_BUTTON_BIG_2        7220
#define LOADOUT_MANAGER_BUTTON_BIG_3        7221
#define LOADOUT_MANAGER_INPUT_RENAME        7222
#define LOADOUT_MANAGER_BUTTON_RENAME       7223
#define LOADOUT_MANAGER_BUTTON_CLOSE        7224

disableSerialization;

init_OOP();

params [
    ["_logic", objNull],
    ["_operation", ""],
    ["_args", objNull]
];

switch (_operation) do {

    method( "init" ) {

        private _syncedObjects = _args;

        // Get module parameters

        _transfer = call compile (_logic getVariable "Transfer");
        _arsenal = call compile (_logic getVariable "Arsenal");

        // add actions to objects

        {
            if (typeName _x == "OBJECT") then {
                _x setVariable ["SpyderAddons_LoadoutManager_Settings", [_arsenal,_transfer]];
                _x addAction ["Access Loadout Manager", format ["[nil,'open', _this] call %1", QFUNC(loadoutManager)]];
            };
        } forEach _syncedObjects;

        // init loadout manager

        if (isnil QMOD(loadoutManager)) then {
            MOD(loadoutManager) = [] call FUNC(hashCreate);
            [MOD(loadoutManager),"currentFolder", ""] call FUNC(hashSet);
            [MOD(loadoutManager),"moveTarget", ""] call FUNC(hashSet);
            [MOD(loadoutManager),"moveDestination", ""] call FUNC(hashSet);
            [MOD(loadoutManager),"transferTarget", []] call FUNC(hashSet);
            [MOD(loadoutManager),"transferDestination", objNull] call FUNC(hashSet);
            [MOD(loadoutManager),"LoadOnRespawn_EHIndex", -1] call FUNC(hashSet);
            [MOD(loadoutManager),"LoadOnRespawn_DataID", -1] call FUNC(hashSet);
            [MOD(loadoutManager),"currentDataLocality", "local"] call FUNC(hashSet);

            private _tempDataDirectory = [] call FUNC(hashCreate);
            [MOD(loadoutManager),"tempDataDirectory", _tempDataDirectory] call FUNC(hashSet);
        };

        [nil,"onLoadoutManagerInit"] remoteExecCall [QFUNC(loadoutSystem),2];

    };

    method( "open" ) {

        private ["_settings"];

        _args params [
            ["_object", nil]
        ];

        createDialog "SpyderAddons_LoadoutManager";
        [MOD(loadoutManager),"onLoad", _object] call MAINCLASS;

    };

    method( "onLoad" ) {

        private ["_object","_settings","_arsenal","_transfer","_dataDirectory","_mainFolder"];

        // load module settings

        if (!isnull _args) then {
            _object = _args;
            _settings = _object getVariable "SpyderAddons_LoadoutManager_Settings";
            _arsenal = _settings select 0;
            _transfer = _settings select 1;

            [_logic,"settings", [_arsenal,_transfer]] call FUNC(hashSet);
        } else {
            _settings = [_logic,"settings"] call FUNC(hashGet);
            _arsenal = _settings select 0;
            _transfer = _settings select 1;
        };

        // Create data directory and main folder if they don't exist

        _dataDirectory = [_logic,"dataDirectory"] call MAINCLASS;

        if (isnil "_dataDirectory") then {
            _dataDirectory = [] call FUNC(hashCreate);
            [_logic,"dataDirectory", _dataDirectory] call MAINCLASS;
        };

        _mainFolder = [_logic,"mainFolder"] call MAINCLASS;

        if (isnil "_mainFolder") then {
            _mainFolder = [nil,"create"] call FUNC(loadoutFolder);
            [_logic,"mainFolder", _mainFolder] call MAINCLASS;

            [_logic,"addData", _mainFolder] call MAINCLASS;
        };

        private _mainFolderID = [_mainFolder,"id"] call FUNC(hashGet);
        [_logic,"currentFolder", _mainFolderID] call FUNC(hashSet);

        // init loadout locality options

        private _comboLeft = getControl(LOADOUT_MANAGER_DISPLAY,LOADOUT_MANAGER_COMBO_LEFT);

        private _index = _comboLeft lbAdd "My Loadouts";
        _comboLeft lbSetData [_index,"local"];

        _index = _comboLeft lbAdd "Server Loadouts";
        _comboLeft lbSetData [_index,"server"];

        _comboLeft ctrlSetEventHandler ["LBSelChanged","['onDataLocalityChanged', _this] call SpyderAddons_fnc_loadoutManagerOnAction"];
        _comboLeft lbSetCurSel 0;

        // init buttons

        private _listLeft = getControl(LOADOUT_MANAGER_DISPLAY,LOADOUT_MANAGER_LIST_LEFT);
        _listLeft ctrlSetEventHandler ["LBSelChanged","['onLeftListClick', _this] call SpyderAddons_fnc_loadoutManagerOnAction"];
        _listLeft ctrlSetEventHandler ["LBDblClick","['onLeftListDoubleClicked', _this] call SpyderAddons_fnc_loadoutManagerOnAction"];

        private _button1 = getControl(LOADOUT_MANAGER_DISPLAY,LOADOUT_MANAGER_BUTTON_1);
        private _button2 = getControl(LOADOUT_MANAGER_DISPLAY,LOADOUT_MANAGER_BUTTON_2);
        private _button3 = getControl(LOADOUT_MANAGER_DISPLAY,LOADOUT_MANAGER_BUTTON_3);
        private _button4 = getControl(LOADOUT_MANAGER_DISPLAY,LOADOUT_MANAGER_BUTTON_4);
        private _button5 = getControl(LOADOUT_MANAGER_DISPLAY,LOADOUT_MANAGER_BUTTON_5);
        private _button6 = getControl(LOADOUT_MANAGER_DISPLAY,LOADOUT_MANAGER_BUTTON_6);
        private _button7 = getControl(LOADOUT_MANAGER_DISPLAY,LOADOUT_MANAGER_BUTTON_7);
        private _button8 = getControl(LOADOUT_MANAGER_DISPLAY,LOADOUT_MANAGER_BUTTON_8);

        _button1 ctrlShow false;
        _button2 ctrlShow false;

        _button3 ctrlSetText "Save Loadout";
        _button3 ctrlSetEventHandler ["MouseButtonDown","['onSaveLoadoutClicked', _this] call SpyderAddons_fnc_loadoutManagerOnAction"];

        _button4 ctrlSetText "Create Folder";
        _button4 ctrlSetEventHandler ["MouseButtonDown","['onCreateFolderClicked', _this] call SpyderAddons_fnc_loadoutManagerOnAction"];

        _button5 ctrlSetText "Move";
        _button5 ctrlSetEventHandler ["MouseButtonDown","['onMoveClicked', _this] call SpyderAddons_fnc_loadoutManagerOnAction"];

        if (_transfer) then {
            _button6 ctrlSetText "Transfer";
            _button6 ctrlSetEventHandler ["MouseButtonDown","['onTransferClicked', _this] call SpyderAddons_fnc_loadoutManagerOnAction"];

            _button7 ctrlSetText "Delete";
            _button7 ctrlSetEventHandler ["MouseButtonDown","['onDeleteClicked', _this] call SpyderAddons_fnc_loadoutManagerOnAction"];

            _button8 ctrlSetText "Export";
            _button8 ctrlSetEventHandler ["MouseButtonDown","['onExportClicked', _this] call SpyderAddons_fnc_loadoutManagerOnAction"];
            _button8 ctrlSetTooltip "Export currently selected data to clipboard";
        } else {
            _button6 ctrlSetText "Delete";
            _button6 ctrlSetEventHandler ["MouseButtonDown","['onDeleteClicked', _this] call SpyderAddons_fnc_loadoutManagerOnAction"];

            _button6 ctrlSetText "Export";
            _button6 ctrlSetEventHandler ["MouseButtonDown","['onExportClicked', _this] call SpyderAddons_fnc_loadoutManagerOnAction"];
            _button6 ctrlSetTooltip "Export currently selected data to clipboard";

            _button8 ctrlShow false;
        };

        private _buttonBig1 = getControl(LOADOUT_MANAGER_DISPLAY,LOADOUT_MANAGER_BUTTON_BIG_1);
        private _buttonBig2 = getControl(LOADOUT_MANAGER_DISPLAY,LOADOUT_MANAGER_BUTTON_BIG_2);
        private _buttonBig3 = getControl(LOADOUT_MANAGER_DISPLAY,LOADOUT_MANAGER_BUTTON_BIG_3);

        _buttonBig1 ctrlShow false;

        if (_arsenal) then {
            _buttonBig2 ctrlSetText "Arsenal";
            _buttonBig2 ctrlSetEventHandler ["MouseButtonDown","['onArsenalClicked', _this] call SpyderAddons_fnc_loadoutManagerOnAction"];
            _buttonBig2 ctrlSetTooltip "Open BIS Arsenal";
        };

        _buttonBig3 ctrlSetText "Reset All Data";
        _buttonBig3 ctrlSetEventHandler ["MouseButtonDown","['resetData', _this] call SpyderAddons_fnc_loadoutManagerOnAction"];
        _buttonBig3 ctrlSetTooltip "Warning: Will erase all folders and loadouts";

        private _buttonRename = getControl(LOADOUT_MANAGER_DISPLAY,LOADOUT_MANAGER_BUTTON_RENAME);
        _buttonRename ctrlSetEventHandler ["MouseButtonDown","['onRenameClicked', _this] call SpyderAddons_fnc_loadoutManagerOnAction"];

        // convert old format data if any exists

        if (!isnil {profileNamespace getVariable "SpyderAddons_Loadouts"}) then {
            [_logic,"convertLegacyFormatLoadouts"] call MAINCLASS;

            private _instructionsLeft = getControl(LOADOUT_MANAGER_DISPLAY,LOADOUT_MANAGER_INSTRUCTIONS_LEFT);
            _instructionsLeft ctrlSetText "Legacy loadouts automatically converted";

            profileNamespace setVariable ["SpyderAddons_Loadouts", nil];
        };

        // init folder browser

        [_logic,"updateLists"] call MAINCLASS;

    };

    method( "onUnload" ) {

        saveProfileNamespace;

        private _tempDataDirectory = [] call FUNC(hashCreate);
        [MOD(loadoutManager),"tempDataDirectory", _tempDataDirectory] call FUNC(hashSet);

    };

    method( "resetData" ) {

        private _currentLocality = [_logic,"currentDataLocality"] call FUNC(hashGet);

        if (_currentLocality == "local") then {

            profileNamespace setVariable [LOADOUT_MANAGER_DATA_NAMESPACE_PATH, nil];
            profileNamespace setVariable [LOADOUT_MANAGER_LOADOUTS_NAMESPACE_PATH, nil];

            private _dialogOpen = !(isnil {findDisplay 7200});

            if (_dialogOpen) then {

                // re init data

                private _dataDirectory = [] call FUNC(hashCreate);
                [_logic,"dataDirectory", _dataDirectory] call MAINCLASS;

                private _mainFolder = [nil,"create"] call FUNC(loadoutFolder);
                [_logic,"mainFolder", _mainFolder] call MAINCLASS;

                [_logic,"addData", _mainFolder] call MAINCLASS;

                private _mainFolderID = [_mainFolder,"id"] call FUNC(hashGet);
                [_logic,"currentFolder", _mainFolderID] call FUNC(hashSet);

                [_logic,"updateLists"] call MAINCLASS;
            };

        };

    };

    method( "dataDirectory" ) {

        if (typename _args == "ARRAY") then {
            profileNamespace setVariable [LOADOUT_MANAGER_DATA_NAMESPACE_PATH, _args];
            _result = _args;
        } else {
            _result = profileNamespace getVariable LOADOUT_MANAGER_DATA_NAMESPACE_PATH;
        };

    };

    method( "mainFolder" ) {

        if (typename _args == "ARRAY") then {
            profileNamespace setVariable [LOADOUT_MANAGER_LOADOUTS_NAMESPACE_PATH, _args];
            [_args,"name", "main"] call FUNC(hashSet);
            [_args,"id", "main"] call FUNC(hashSet);
            _result = _args;
        } else {
            _result = profileNamespace getVariable LOADOUT_MANAGER_LOADOUTS_NAMESPACE_PATH;
        };

    };

    method( "getNextDataID" ) {

        _result = format ["%1_%2", diag_tickTime, random 1000];

    };

    method( "addData" ) {

        private _data = _args;

        private _dataDirectory = [_logic,"dataDirectory"] call MAINCLASS;

        private _dataID = [_logic,"getNextDataID"] call MAINCLASS;
        [_dataDirectory,_dataID, _data] call FUNC(hashSet);

        [_data,"id", _dataID] call FUNC(hashSet);

        _result = _dataID;

    };

    method( "addDataTemp" ) {

        _args params [
            "_data",
            ["_dataID","",[""]]
        ];

        private _tempDataDirectory = [_logic,"tempDataDirectory"] call FUNC(hashGet);

        if (_dataID == "") then {
            _dataID = [_logic,"getNextDataID"] call MAINCLASS;
        };

        [_tempDataDirectory,_dataID, _data] call FUNC(hashSet);

        [_data,"id", _dataID] call FUNC(hashSet);

        _result = _dataID;

    };

    method( "getData" ) {

        private _id = _args;

        if (typename _id == "STRING") then {
            private _dataDirectory = [_logic,"dataDirectory"] call MAINCLASS;
            _result = [_dataDirectory,_id] call FUNC(hashGet);

            if (isnil "_result") then {
                private _tempDataDirectory = [_logic,"tempDataDirectory"] call FUNC(hashGet);
                _result = [_tempDataDirectory,_id] call FUNC(hashGet);
            };
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

    method( "onAction" ) {

        _args params ["_action","_actionArgs"];

        [_logic,_action, _actionArgs] call MAINCLASS;

    };

    method( "onLeftListClick" ) {

        _args params ["_list","_index"];

        private _selectedDataID = _list lbData _index;
        private _selectedDataText = _list lbText _index;

        private _inputRename = getControl(LOADOUT_MANAGER_DISPLAY,LOADOUT_MANAGER_INPUT_RENAME);
        if (_selectedDataText != ". . \") then {
            _inputRename ctrlSetText _selectedDataText;
        };

        // display contents of selected data in right list

        private _headerRight = getControl(LOADOUT_MANAGER_DISPLAY,LOADOUT_MANAGER_HEADER_RIGHT);
        _headerRight ctrlSetText "";

        private _instructionsLeft = getControl(LOADOUT_MANAGER_DISPLAY,LOADOUT_MANAGER_INSTRUCTIONS_LEFT);
        _instructionsLeft ctrlSetText "";

        private _instructionsRight = getControl(LOADOUT_MANAGER_DISPLAY,LOADOUT_MANAGER_INSTRUCTIONS_RIGHT);
        _instructionsRight ctrlSetText "";

        private _listRight = getControl(LOADOUT_MANAGER_DISPLAY,LOADOUT_MANAGER_LIST_RIGHT);
        _listRight ctrlRemoveAllEventHandlers "LBSelChanged";
        _listRight ctrlRemoveAllEventHandlers "LBDblClick";
        lbClear _listRight;

        private _selectedData = [_logic,"getData", _selectedDataID] call MAINCLASS;
        [_logic,"displayContents", [_listRight,_selectedData]] call MAINCLASS;

        // enable/disable buttons

        private _selectedDataType = [_selectedData,"dataType"] call FUNC(hashGet);

        private _button1 = getControl(LOADOUT_MANAGER_DISPLAY,LOADOUT_MANAGER_BUTTON_1);
        private _button2 = getControl(LOADOUT_MANAGER_DISPLAY,LOADOUT_MANAGER_BUTTON_2);

        if (_selectedDataType == "loadout") then {
            _button1 ctrlShow true;
            _button1 ctrlSetText "Load Loadout";
            _button1 ctrlSetEventHandler ["MouseButtonDown","['onLoadLoadoutClicked', _this] call SpyderAddons_fnc_loadoutManagerOnAction"];

            _button2 ctrlShow true;
            _button2 ctrlSetText "Load on Respawn";
            _button2 ctrlSetEventHandler ["MouseButtonDown","['onLoadOnRespawnClicked', _this] call SpyderAddons_fnc_loadoutManagerOnAction"];
        } else {
            _button1 ctrlShow true;
            _button1 ctrlSetText "Open Folder";
            _button1 ctrlSetEventHandler ["MouseButtonDown","['onOpenFolderClicked', _this] call SpyderAddons_fnc_loadoutManagerOnAction"];

            _button2 ctrlShow false;
        };

    };

    method( "onLeftListDoubleClicked" ) {

        _args params ["_list","_index"];

        private _selectedDataID = _list lbData _index;
        private _selectedData = [_logic,"getData", _selectedDataID] call MAINCLASS;

        private _selectedDataType = [_selectedData,"dataType"] call FUNC(hashGet);

        if (_selectedDataType == "loadout") then {
            [_logic,"setUnitLoadout", [player,_selectedData]] call MAINCLASS;
        } else {
            [_logic,"openFolder", _selectedData] call MAINCLASS;
        };

    };

    method( "onDataLocalityChanged" ) {

        _args params ["_combo","_index"];

        private _selectedLocality = _combo lbData _index;
        private _currentLocality = [_logic,"currentDataLocality"] call FUNC(hashGet);

        if (_currentLocality != _selectedLocality) then {
            switch (_selectedLocality) do {
                case "local": {
                    [_logic,"currentDataLocality", "local"] call FUNC(hashSet);

                    private _mainFolder = [_logic,"mainFolder"] call MAINCLASS;
                    [_logic,"openFolder", _mainFolder] call MAINCLASS;

                    private _tempDataDirectory = [] call FUNC(hashCreate);
                    [MOD(loadoutManager),"tempDataDirectory", _tempDataDirectory] call FUNC(hashSet);
                };
                case "server": {
                    [_logic,"currentDataLocality", "server"] call FUNC(hashSet);

                    private _tempDataDirectory = [] call FUNC(hashCreate);
                    [MOD(loadoutManager),"tempDataDirectory", _tempDataDirectory] call FUNC(hashSet);

                    [nil,"onDataRequest", player] remoteExecCall [QFUNC(loadoutSystem),2];
                };
            };
        };

    };

    method( "onServerDataReceived" ) {

        private ["_iterKey","_iterData"];
        _args params ["_mainFolderID","_keys","_data"];

        for "_i" from 0 to (count _keys - 1) do {
            _iterKey = _keys select _i;
            _iterData = _data select _i;

            [_logic,"addDataTemp", [_iterData,_iterKey]] call MAINCLASS;
        };

        [_logic,"openFolder", _mainFolderID] call MAINCLASS;

    };

    method( "openFolder" ) {

        private "_folderID";
        private _folder = _args;

        if (typename _folder == "STRING") then {
            _folderID = _folder;
            _folder = [_logic,"getData", _folder] call MAINCLASS;
        } else {
            _folderID = [_folder,"id"] call FUNC(hashGet);
        };

        private _listLeft = getControl(LOADOUT_MANAGER_DISPLAY,LOADOUT_MANAGER_LIST_LEFT);
        lbClear _listLeft;
        _listLeft lbSetCurSel -1;

        [_logic,"currentFolder", _folderID] call FUNC(hashSet);
        [_logic,"displayContents", [_listLeft,_folder]] call MAINCLASS;

    };

    method( "updateLists" ) {

        private _listLeft = getControl(LOADOUT_MANAGER_DISPLAY,LOADOUT_MANAGER_LIST_LEFT);

        private _initialListSize = lbSize _listLeft;
        private _selectedIndex = lbCurSel _listLeft;

        _currentFolder = [_logic,"currentFolder"] call FUNC(hashGet);
        [_logic,"openFolder", _currentFolder] call MAINCLASS;

        // reset dynamic buttons

        private _button1 = getControl(LOADOUT_MANAGER_DISPLAY,LOADOUT_MANAGER_BUTTON_1);
        private _button2 = getControl(LOADOUT_MANAGER_DISPLAY,LOADOUT_MANAGER_BUTTON_2);

        _button1 ctrlShow false;
        _button2 ctrlShow false;

        private _newListSize = lbSize _listLeft;

        if (_newListSize > 0) then {
            private _newSelectedIndex = _selectedIndex;

            if (_initialListSize != _newListSize) then {
                if (_initialListSize - _newListSize > 0) then {
                    _newSelectedIndex = _selectedIndex - 1;

                    if (_newSelectedIndex == -1) then {
                        _newSelectedIndex = _selectedIndex;
                    };
                } else {
                    _newSelectedIndex = _newListSize - 1;
                };
            };

            _listLeft lbSetCurSel _newSelectedIndex;
        };

        private _inputRename = getControl(LOADOUT_MANAGER_DISPLAY,LOADOUT_MANAGER_INPUT_RENAME);
        _inputRename ctrlSetText (_listLeft lbText (lbCurSel _listLeft));

    };

    method( "displayContents" ) {

        private "_index";
        _args params ["_list","_data"];

        if (typename _data == "STRING") then {
            _data = [_logic,"getData", _data] call MAINCLASS;
        };

        private _listLeft = getControl(LOADOUT_MANAGER_DISPLAY,LOADOUT_MANAGER_LIST_LEFT);
        private _parentFolder = [_data,"parent"] call FUNC(hashGet);

        lbClear _list;

        private _currentFolder = [_logic,"currentFolder"] call FUNC(hashGet);
        _currentFolder = [_logic,"getData", _currentFolder] call MAINCLASS;
        private _currentFolderParentID = [_currentFolder,"parent"] call FUNC(hashGet);

        if (_listLeft == _list && {_currentFolderParentID != ""}) then {
            _index = _list lbAdd ". . \";
            _list lbSetTooltip [_index,"Previous Folder"];
            _list lbSetData [_index,_parentFolder];
        };

        private _dataClass = CLASS(_data);
        private _dataSource = [_data,"getDetailDataSource"] call _dataClass;

        {
            _x params ["_name","_image","_tooltip","_id"];

            _index = _list lbAdd _name;
            _list lbSetPicture [_index,_image];
            _list lbSetTooltip [_index,_tooltip];
            _list lbSetData [_index,_id];
        } foreach _dataSource;

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

    method( "folderGetContainedKeys" ) {

        private ["_dataID","_data","_dataType","_containedKeys"];
        private _folder = _args;

        if (typename _folder == "STRING") then {
            _folder = [_logic,"getData", _folder] call MAINCLASS;
        };

        _result = [];
        private _folderContents = [_folder,"contents"] call FUNC(hashGet);

        {
            _dataID = _x;
            _data = [_logic,"getData", _dataID] call MAINCLASS;
            _dataType = [_data,"dataType"] call FUNC(hashGet);

            _result pushback _dataID;

            if (_dataType == "folder") then {
                _containedKeys = [_logic,"folderGetContainedKeys", _data] call MAINCLASS;
                _result append _containedKeys;
            };
        } foreach _folderContents;

    };

    method( "onCreateFolderClicked" ) {

        private _currentLocality = [_logic,"currentDataLocality"] call FUNC(hashGet);

        if (_currentLocality == "local") then {

            private _inputRename = getControl(LOADOUT_MANAGER_DISPLAY,LOADOUT_MANAGER_INPUT_RENAME);
            private _name = ctrlText _inputRename;

            if (_name != "") then {
                private _currentFolder = [_logic,"currentFolder"] call FUNC(hashGet);
                [_logic,"createFolder", [_currentFolder,_name]] call MAINCLASS;
            } else {
                private _instructionsLeft = getControl(LOADOUT_MANAGER_DISPLAY,LOADOUT_MANAGER_INSTRUCTIONS_LEFT);
                _instructionsLeft ctrlSetText "You must name the folder first";
            };

        };

    };

    method( "createFolder" ) {

        _args params ["_parentFolder","_name"];

        private _folder = [nil,"create"] call FUNC(loadoutFolder);
        [_folder,"name", _name] call FUNC(loadoutFolder);

        [_logic,"addData", _folder] call MAINCLASS;
        [_logic,"folderAddData", [_parentFolder,_folder]] call MAINCLASS;

        [_logic,"updateLists"] call MAINCLASS;

    };

    method( "onSaveLoadoutClicked" ) {

        private _currentLocality = [_logic,"currentDataLocality"] call FUNC(hashGet);

        if (_currentLocality == "local") then {

            private _listLeft = getControl(LOADOUT_MANAGER_DISPLAY,LOADOUT_MANAGER_LIST_LEFT);
            private _selectedIndex = lbCurSel _listLeft;

            private _inputRename = getControl(LOADOUT_MANAGER_DISPLAY,LOADOUT_MANAGER_INPUT_RENAME);
            private _inputName = ctrlText _inputRename;

            private _currentFolder = [_logic,"currentFolder"] call FUNC(hashGet);

            if (_selectedIndex > -1) then {
                _name = _listLeft lbText _selectedIndex;

                if (_inputName == _name) then {
                    private _selectedDataID = ctrlGetSelData(_listLeft);
                    private _selectedData = [_logic,"getData", _selectedDataID] call MAINCLASS;
                    private _selectedDataType = [_selectedData,"dataType"] call FUNC(hashGet);

                    if (_selectedDataType == "loadout") then {
                        [_logic,"saveLoadout", [_selectedDataID,_name]] call MAINCLASS;
                    };
                } else {
                    [_logic,"createLoadout", [_currentFolder,_inputName]] call MAINCLASS;
                };
            } else {
                if (_inputName != "") then {
                    [_logic,"createLoadout", [_currentFolder,_inputName]] call MAINCLASS;
                } else {
                    private _instructionsLeft = getControl(LOADOUT_MANAGER_DISPLAY,LOADOUT_MANAGER_INSTRUCTIONS_LEFT);
                    _instructionsLeft ctrlSetText "You must name the loadout first";
                };
            };

        };

    };

    method( "createLoadout" ) {

        _args params ["_parentFolder","_name"];

        private _unitLoadout = [_logic,"getUnitLoadout", player] call MAINCLASS;

        private _loadout = [nil,"create"] call FUNC(loadout);
        [_loadout,"name", _name] call FUNC(loadout);
        [_loadout,"loadout", _unitLoadout] call FUNC(loadout);

        [_logic,"addData", _loadout] call MAINCLASS;
        [_logic,"folderAddData", [_parentFolder,_loadout]] call MAINCLASS;

        [_logic,"updateLists"] call MAINCLASS;

    };

    method( "saveLoadout" ) {

        _args params ["_loadoutID","_name"];

        private _loadout = [_logic,"getData", _loadoutID] call MAINCLASS;
        private _unitLoadout = [_logic,"getUnitLoadout", player] call MAINCLASS;

        [_loadout,"name", _name] call FUNC(loadout);
        [_loadout,"loadout", _unitLoadout] call FUNC(loadout);

        [_logic,"updateLists"] call MAINCLASS;

    };

    method( "onLoadLoadoutClicked" ) {

        private _selectedDataID = getSelData(LOADOUT_MANAGER_LIST_LEFT);

        [_logic,"setUnitLoadout", [player,_selectedDataID]] call MAINCLASS;

    };

    method( "setUnitLoadout" ) {

        _args params ["_unit","_loadout"];

        if (typename _loadout == "STRING") then {
            _loadout = [_logic,"getData", _loadout] call MAINCLASS;
        };

        if (_loadout call FUNC(isHash)) then {
            _loadout = [_loadout,"loadout"] call FUNC(hashGet);
        };

        _unit setUnitLoadout _loadout;

    };

    method( "getUnitLoadout" ) {

        private _unit = _args;

        _result = getUnitLoadout _unit;

    };

    method( "onOpenFolderClicked" ) {

        private _selectedDataID = getSelData(LOADOUT_MANAGER_LIST_LEFT);

        [_logic,"openFolder", _selectedDataID] call MAINCLASS;

    };

    method( "onDeleteClicked" ) {

        private _currentLocality = [_logic,"currentDataLocality"] call FUNC(hashGet);

        if (_currentLocality == "local") then {

            private _selectedDataID = getSelData(LOADOUT_MANAGER_LIST_LEFT);

            private _selectedData = [_logic,"getData", _selectedDataID] call MAINCLASS;
            private _selectedDataType = [_selectedData,"dataType"] call FUNC(hashGet);
            private _selectedDataParent = [_selectedData,"parent"] call FUNC(hashGet);

            [_logic,"folderRemoveData", [_selectedDataParent,_selectedData]] call MAINCLASS;

            if (_selectedDataType == "folder") then {
                private _allDataInFolder = [_logic,"getAllDataInFolder", _selectedData] call MAINCLASS;

                {
                    [_logic,"deleteData", _x] call MAINCLASS;
                } foreach _allDataInFolder;

            };

            [_logic,"deleteData", _selectedData] call MAINCLASS;

            [_logic,"updateLists"] call MAINCLASS;

        };

    };

    method( "folderExpandContents" ) {

        private _folder = _args;

        if (typename _folder == "STRING") then {
            _folder = [_logic,"getData", _folder] call MAINCLASS;
        };

        private _folderContents = [_folder,"contents"] call FUNC(hashGet);

        {
            _dataID = _x;
            _data = [_logic,"getData", _dataID] call MAINCLASS;
            _dataType = [_data,"dataType"] call FUNC(hashGet);

            _folderContents set [_forEachIndex,_data];

            if (_dataType == "folder") then {
                [_logic,"expandFolderToData", _data] call MAINCLASS;
            };
        } foreach _folderContents;

        _result = _folder;

    };

    method( "onExportClicked" ) {

        private ["_retrievedData"];
        private _selectedDataID = getSelData(LOADOUT_MANAGER_LIST_LEFT);

        if (_selectedDataID != "") then {
            private _selectedData = + ([_logic,"getData", _selectedDataID] call MAINCLASS);
            private _selectedDataType = [_selectedData,"dataType"] call FUNC(hashGet);
            private _selectedDataName = [_selectedData,"name"] call FUNC(hashGet);

            // prep for export

            [_selectedData,"parent", ""] call FUNC(hashSet);

            // generate export array

            private _keys = [];
            private _data = [];

            _keys pushback _selectedDataID;
            _data pushback _selectedData;

            if (_selectedDataType == "folder") then {
                private _contents = [_selectedData,"contents"] call FUNC(hashGet);
                private _containedKeys = [_logic,"folderGetContainedKeys", _selectedData] call MAINCLASS;
                private _containedData = [];

                {
                    _retrievedData = [_logic,"getData", _x] call MAINCLASS;
                    _containedData pushback _retrievedData;
                } foreach _containedKeys;

                _keys append _containedKeys;
                _data append _containedData;
            };

            private _exportData = [_keys,_data];

            // export

            private _output = format ["%1 spawn %2;", str _exportData, QFUNC(loadoutAddServerData)];
            copyToClipboard _output;

            private _instructionsLeft = getControl(LOADOUT_MANAGER_DISPLAY,LOADOUT_MANAGER_INSTRUCTIONS_LEFT);
            _instructionsLeft ctrlSetText "Data copied to clipboard";
        };

    };

    method( "getAllDataInFolder" ) {

        private ["_dataID","_data","_dataType","_dataInFolder"];
        private _folder = _args;

        if (typename _folder == "STRING") then {
            _folder = [_logic,"getData", _folder] call MAINCLASS;
        };

        private _folderContents = [_folder,"contents"] call FUNC(hashGet);
        _result = [];

        {
            _dataID = _x;
            _data = [_logic,"getData", _dataID] call MAINCLASS;
            _dataType = [_data,"dataType"] call FUNC(hashGet);

            if (_dataType == "folder") then {
                _dataInFolder = [_logic,"getAllDataInFolder", _data] call MAINCLASS;
                _result append _dataInFolder;
            };

            _result pushback _dataID;
        } foreach _folderContents;

    };

    method( "getAllFoldersInFolder" ) {

        private ["_dataID","_data","_dataType","_foldersInFolder"];
        private _folder = _args;

        if (typename _folder == "STRING") then {
            _folder = [_logic,"getData", _folder] call MAINCLASS;
        };

        private _folderContents = [_folder,"contents"] call FUNC(hashGet);
        _result = [];

        {
            _dataID = _x;
            _data = [_logic,"getData", _dataID] call MAINCLASS;
            _dataType = [_data,"dataType"] call FUNC(hashGet);

            if (_dataType == "folder") then {
                _foldersInFolder = [_logic,"getAllFoldersInFolder", _data] call MAINCLASS;
                _result append _foldersInFolder;
                _result pushback _dataID;
            };
        } foreach _folderContents;

    };

    method( "getAllLoadoutsInFolder" ) {

        private _folder = _args;

        if (typename _folder == "STRING") then {
            _folder = [_logic,"getData", _folder] call MAINCLASS;
        };

        private _folderContents = [_folder,"contents"] call FUNC(hashGet);
        _result = [];

        {
            _dataID = _x;
            _data = [_logic,"getData", _dataID] call MAINCLASS;
            _dataType = [_data,"dataType"] call FUNC(hashGet);

            if (_dataType == "folder") then {
                _loadoutsInFolder = [_logic,"getAllLoadoutsInFolder", _data] call MAINCLASS;
                _result append _loadoutsInFolder;
            } else {
                _result pushback _dataID;
            };
        } foreach _folderContents;

    };

    method( "onMoveClicked" ) {

        private _currentLocality = [_logic,"currentDataLocality"] call FUNC(hashGet);

        if (_currentLocality == "local") then {

            private ["_data","_dataID","_dataType","_name","_index"];

            private _selectedDataID = getSelData(LOADOUT_MANAGER_LIST_LEFT);

            if (_selectedDataID != "") then {

                private _selectedData = [_logic,"getData", _selectedDataID] call MAINCLASS;
                private _selectedDataType = [_selectedData,"dataType"] call FUNC(hashGet);

                private _parentFolderID = [_selectedData,"parent"] call FUNC(hashGet);

                private _blacklist = [_selectedDataID,_parentFolderID];

                if (_selectedDataType == "folder") then {
                    private _foldersInFolder = [_logic,"getAllFoldersInFolder", _selectedData] call MAINCLASS;
                    _blacklist append _foldersInFolder;
                };

                private _dataDirectory = [_logic,"dataDirectory"] call MAINCLASS;

                private _listRight = getControl(LOADOUT_MANAGER_DISPLAY,LOADOUT_MANAGER_LIST_RIGHT);
                lbClear _listRight;

                {
                    _dataID = _x;

                    if !(_dataID in _blacklist) then {
                        _data = [_logic,"getData", _dataID] call MAINCLASS;
                        _dataType = [_data,"dataType"] call FUNC(hashGet);

                        if (_dataType == "folder") then {

                            _name = [_data,"name"] call FUNC(hashGet);

                            _index = _listRight lbAdd _name;
                            _listRight lbSetPicture [_index,QUOTE(CIMAGES(COMPONENT)\folder.paa)];
                            _listRight lbSetData [_index,_dataID];

                        };
                    };
                } foreach (_dataDirectory select 1);

                [_logic,"moveTarget", _selectedDataID] call FUNC(hashSet);
                _listRight ctrlAddEventHandler ["LBSelChanged","['onMoveOptionClicked', _this] call SpyderAddons_fnc_loadoutManagerOnAction"];
                _listRight ctrlAddEventHandler ["LBDblClick","_this pushback true;['onMoveOptionClicked', _this] call SpyderAddons_fnc_loadoutManagerOnAction"];

            };

        };

    };

    method( "onMoveOptionClicked" ) {

        _args params ["_list","_index",["_doubleClicked", false]];

        private _selectedData = ctrlGetSelData(_list);
        [_logic,"moveDestination", _selectedData] call FUNC(hashSet);

        if (!_doubleClicked) then {
            private _buttonBig1 = getControl(LOADOUT_MANAGER_DISPLAY,LOADOUT_MANAGER_BUTTON_BIG_1);
            _buttonBig1 ctrlShow true;
            _buttonBig1 ctrlSetText "Confirm Move";

            _buttonBig1 ctrlSetEventHandler ["MouseButtonDown","['onMoveConfirmClicked', _this] call SpyderAddons_fnc_loadoutManagerOnAction"];
        } else {
            [_logic,"onMoveConfirmClicked"] call MAINCLASS;
        };

    };

    method( "onMoveConfirmClicked" ) {

        private _moveData = [_logic,"moveTarget"] call FUNC(hashGet);
        _moveData = [_logic,"getData", _moveData] call MAINCLASS;

        // remove data from parent folder

        private _moveDataParent = [_moveData,"parent"] call FUNC(hashGet);
        [_logic,"folderRemoveData", [_moveDataParent,_moveData]] call MAINCLASS;

        // add data to new destination folder

        private _moveDestination = [_logic,"moveDestination"] call FUNC(hashGet);

        [_logic,"folderAddData", [_moveDestination,_moveData]] call MAINCLASS;

        [_logic,"updateLists"] call MAINCLASS;

    };

    method( "onLoadOnRespawnClicked" ) {

        private _listLeft = getControl(LOADOUT_MANAGER_DISPLAY,LOADOUT_MANAGER_LIST_LEFT);
        private _selectedDataID = ctrlGetSelData(_listLeft);

        private _loadOnRespawnEHIndex = [_logic,"LoadOnRespawn_EHIndex"] call FUNC(hashGet);

        if (_loadOnRespawnEHIndex != -1) then {
            player removeEventHandler ["MPRespawn", _loadOnRespawnEHIndex];
        };

        _loadOnRespawnEHIndex = player addMPEventHandler ["MPRespawn", "['onUnitSpawned', _this] call SpyderAddons_fnc_loadoutManagerOnAction"];

        [_logic,"LoadOnRespawn_EHIndex", _loadOnRespawnEHIndex] call FUNC(hashSet);
        [_logic,"LoadOnRespawn_DataID", _selectedDataID] call FUNC(hashSet);

        private _instructionsLeft = getControl(LOADOUT_MANAGER_DISPLAY,LOADOUT_MANAGER_INSTRUCTIONS_LEFT);
        _instructionsLeft ctrlSetText "Loadout will load on respawn";

    };

    method( "onUnitSpawned" ) {

        _args params ["_unit"];

        _loadoutIndex = [_logic,"LoadOnRespawn_DataID"] call FUNC(hashGet);
        _loadout = [_logic,"getData", _loadoutIndex] call MAINCLASS;

        if (!isnil "_loadout") then {
            [_logic,"setUnitLoadout", [_unit,_loadout]] call MAINCLASS;
        };

    };

    method( "onTransferClicked" ) {

        private _currentLocality = [_logic,"currentDataLocality"] call FUNC(hashGet);

        if (_currentLocality == "local") then {

            private ["_name","_role","_index"];

            private _selectedDataID = getSelData(LOADOUT_MANAGER_LIST_LEFT);

            if (_selectedDataID != "") then {

                private _selectedData = [_logic,"getData", _selectedDataID] call MAINCLASS;
                private _selectedDataName = [_selectedData,"name"] call FUNC(hashGet);
                private _selectedDataType = [_selectedData,"dataType"] call FUNC(hashGet);

                [_logic,"transferTarget", [name player,_selectedDataID]] call FUNC(hashSet);

                // Set instructions

                private _headerRight = getControl(LOADOUT_MANAGER_DISPLAY,LOADOUT_MANAGER_HEADER_RIGHT);
                private _instructionsRight = getControl(LOADOUT_MANAGER_DISPLAY,LOADOUT_MANAGER_INSTRUCTIONS_RIGHT);

                if (_selectedDataType == "loadout") then {
                    _headerRight ctrlSetText "Transfer Loadout";
                    _instructionsRight ctrlSetText "Select a unit to transfer the loadout to";
                } else {
                    _headerRight ctrlSetText "Transfer Folder";
                    _instructionsRight ctrlSetText "Select a unit to transfer the folder to";
                };

                private _listRight = getControl(LOADOUT_MANAGER_DISPLAY,LOADOUT_MANAGER_LIST_RIGHT);
                lbClear _listRight;

                // Get all units of player's side

                private _playerSide = playerSide;
                private _units = [];

                {
                    if (side _x == _playerSide && {alive _x}) then {
                        if (isPlayer _x) then {
                            if (_x != player) then {
                                _units pushbackunique _x;
                            };
                        } else {
                            if (_x distance player < 150) then {
                                _units pushbackunique _x;
                            };
                        };
                    };
                } forEach ((units group player) + allPlayers);

                // display gathered units in right list

                {
                    _name = name _x;
                    _role = getText (configfile >> "CfgVehicles" >> (typeOf _x) >> "displayName");

                    _index = _listRight lbAdd (format ["%1 (%2)", _name, _role]);
                    _listRight lbSetData [_index,str _x];
                } foreach _units;

                private _headerRight = getControl(LOADOUT_MANAGER_DISPLAY,LOADOUT_MANAGER_HEADER_RIGHT);
                _headerRight ctrlSetText "Transfer Loadout";

                if (count _units > 0) then {
                    _listRight ctrlAddEventHandler ["LBSelChanged","['onTransferOptionClicked', _this] call SpyderAddons_fnc_loadoutManagerOnAction"];
                    _listRight ctrlAddEventHandler ["LBDblClick","_this pushback true;['onTransferOptionClicked', _this] call SpyderAddons_fnc_loadoutManagerOnAction"];
                } else {
                    _instructionsRight ctrlSetText "There are no units to transfer to";
                };

            };

        };

    };

    method( "onTransferOptionClicked" ) {

        _args params ["_list","_index",["_doubleClicked", false]];

        private _selectedData = ctrlGetSelData(_list);
        [_logic,"transferDestination", _selectedData] call FUNC(hashSet);

        if (!_doubleClicked) then {
            private _buttonBig1 = getControl(LOADOUT_MANAGER_DISPLAY,LOADOUT_MANAGER_BUTTON_BIG_1);
            _buttonBig1 ctrlShow true;
            _buttonBig1 ctrlSetText "Confirm Transfer";

            _buttonBig1 ctrlSetEventHandler ["MouseButtonDown","['onTransferConfirmClicked', _this] call SpyderAddons_fnc_loadoutManagerOnAction"];
        } else {
            [_logic,"onTransferConfirmClicked"] call MAINCLASS;
        };

    };

    method( "onTransferConfirmClicked" ) {

        private _transferDestination = [_logic,"transferDestination"] call FUNC(hashGet);

        private "_unit";
        {
            if (str _x == _transferDestination) exitWith {
                _unit = _x;
            };
        } foreach allunits;

        if (!isnil "_unit") then {

            private _transferData = [_logic,"transferTarget"] call FUNC(hashGet);
            _transferData params ["_sender","_transferDataID"];
            _transferData = [_logic,"getData", _transferDataID] call MAINCLASS;

            private _instructionsRight = getControl(LOADOUT_MANAGER_DISPLAY,LOADOUT_MANAGER_INSTRUCTIONS_RIGHT);

            if (isPlayer _unit) then {
                [nil,"storeTransferredData", [_sender,_transferData]] remoteExecCall [QUOTE(MAINCLASS),_unit];

                _instructionsRight ctrlshow true;
                _instructionsRight ctrlsettext (format ["Loadout sent to %1", name _unit]);
            } else {
                if (alive _unit) then {
                        private _transferDataType = [_transferData,"dataType"] call FUNC(hashGet);

                    if (_transferDataType == "loadout") then {
                        [_logic,"setUnitLoadout", [_unit,_transferData]] call MAINCLASS;

                        _instructionsRight ctrlshow true;
                        _instructionsRight ctrlsettext (format ["Loadout applied to %1", name _unit]);
                    } else {
                        // get random loadout from folder
                        // set random loadout to unit

                        private _allLoadoutsInFolder = [_logic,"getAllLoadoutsInFolder", _transferData] call MAINCLASS;

                        if (count _allLoadoutsInFolder > 0) then {
                            private _randomLoadout = selectRandom _allLoadoutsInFolder;

                            [_logic,"setUnitLoadout", [_unit,_randomLoadout]] call MAINCLASS;

                            _instructionsRight ctrlshow true;
                            _instructionsRight ctrlsettext (format ["Random loadout applied to %1", name _unit]);
                        } else {
                            _instructionsRight ctrlshow true;
                            _instructionsRight ctrlsettext (format ["There are no loadouts within folder %1", [_transferData,"name"] call FUNC(hashGet)]);
                        };
                    };
                };
            };
        };

    };

    method( "storeTransferredData" ) {

        private ["_dataID","_data","_name","_transferFolder"];
        _logic = MOD(loadoutManager);
        _args params ["_transferSender","_transferData"];

        _transferData = +_transferData;
        private _transferDataType = [_transferData,"dataType"] call FUNC(hashGet);
        private _transferDataName = [_transferData,"name"] call FUNC(hashGet);

        // notify player

        if (_transferDataType == "loadout") then {
            [format ["%1 has sent you a loadout named %2", _transferSender, _transferDataName]] spawn SpyderAddons_fnc_displayNotification;
        } else {
            [format ["%1 has sent you a folder named %2", _transferSender, _transferDataName]] spawn SpyderAddons_fnc_displayNotification;
        };

        // create Transferred Data folder if it doesn't exist

        private _mainFolder = [_logic,"mainFolder"] call MAINCLASS;
        private _mainFolderContents = [_mainFolder,"contents"] call FUNC(hashGet);

        // check if main folder exists

        {
            _dataID = _x;
            _data = [_logic,"getData", _dataID] call MAINCLASS;
            _name = [_data,"name"] call FUNC(hashGet);

            if (_name == "Transferred Loadouts") exitWith {
                _transferFolder = _x;
            };
        } foreach _mainFolderContents;

        // init main folder if it doesn't exist

        if (isnil "_transferFolder") then {
            _transferFolder = [nil,"create"] call FUNC(loadoutFolder);
            [_transferFolder,"name", "Transferred Loadouts"] call FUNC(loadoutFolder);

            [_logic,"addData", _transferFolder] call MAINCLASS;
            [_logic,"folderAddData", [_mainFolder,_transferFolder]] call MAINCLASS;
        };

        // store data

        [_logic,"addData", _transferData] call MAINCLASS;
        [_logic,"folderAddData", [_transferFolder,_transferData]] call MAINCLASS;

        [_logic,"updateLists"] call MAINCLASS;

    };

    method( "onArsenalClicked" ) {

        // Close Loadout Organizer

        closeDialog 0;

        ["Open",true] spawn BIS_fnc_arsenal;

        [] spawn {
            disableSerialization;

            waitUntil {!isNull findDisplay -1};

            // Set close button action to open the loadout manager

            private _closeButton = findDisplay -1 displayCtrl 44448;
            (ctrlParent _closeButton) displayAddEventHandler ["Unload", format ["[nil,'open'] call %1", QUOTE(MAINCLASS)]];
        };

    };

    method( "onRenameClicked" ) {

        private _currentLocality = [_logic,"currentDataLocality"] call FUNC(hashGet);

        if (_currentLocality == "local") then {

            private _inputRename = getControl(LOADOUT_MANAGER_DISPLAY,LOADOUT_MANAGER_INPUT_RENAME);
            private _name = ctrlText _inputRename;

            private _selectedDataID = getSelData(LOADOUT_MANAGER_LIST_LEFT);
            private _selectedData = [_logic,"getData", _selectedDataID] call MAINCLASS;

            [_selectedData,"name", _name] call FUNC(hashSet);

            [_logic,"updateLists"] call MAINCLASS;

        };

    };

    method( "convertFolder" ) {

        private ["_dataName","_data","_newFolder","_convertedLoadout","_newLoadout"];
        _args params ["_parentFolder","_folder"];

        private _folderKeys = _folder select 1;
        private _folderData = _folder select 2;

        for "_i" from 0 to (count _folderKeys - 1) do {

            _dataName = _folderKeys select _i;
            _data = _folderData select _i;

            if (_data call FUNC(isHash)) then {
                _newFolder = [nil,"create"] call FUNC(loadoutFolder);
                [_newFolder,"name", _dataName] call FUNC(loadoutFolder);

                [_logic,"addData", _newFolder] call MAINCLASS;
                [_logic,"folderAddData", [_parentFolder,_newFolder]] call MAINCLASS;

                [_logic,"convertFolder", [_newFolder,_data]] call MAINCLASS;
            } else {
                _convertedLoadout = [_logic,"convertLoadout", _data] call MAINCLASS;

                _newLoadout = [nil,"create"] call FUNC(loadout);
                [_newLoadout,"name", _dataName] call FUNC(loadout);
                [_newLoadout,"loadout", _convertedLoadout] call FUNC(loadout);

                [_logic,"addData", _newLoadout] call MAINCLASS;
                [_logic,"folderAddData", [_parentFolder,_newLoadout]] call MAINCLASS;
            };

        };

    };

    method( "convertLoadout" ) {

        private _loadout = _args;

        _loadout params [
                "_uniform",
                "_vest",
                "_backpack",
                "_headgear",
                "_goggles",
                "_uniformItems",
                "_vestItems",
                "_backpackItems",
                "_weapons",
                "_primaryWeaponItems",
                "_primaryWeaponMagazine",
                "_handgunItems",
                "_handgunMagazine",
                "_secondaryWeaponItems",
                "_secondaryWeaponMagazine",
                "_assignedItems"
        ];

        // strip unit

        removeAllWeapons player;
        {player removeMagazine _x} foreach (magazines player);
        removeUniform player;
        removeVest player;
        removeBackpack player;
        removeGoggles player;
        removeHeadGear player;
        removeAllAssignedItems player;

        // add gear

        player forceAddUniform _uniform;
        player addVest _vest;
        player addBackpack _backpack;
        player addHeadgear _headgear;
        player addGoggles _goggles;

        // remove preset items from containers

        {player removeItem _x} forEach ((uniformItems player) + (vestItems player) + (backpackItems player));
        {player addItemToUniform _x} forEach _uniformitems;
        {player addItemToVest _x} forEach _vestitems;
        {player addItemToBackpack _x} forEach _backpackitems;
        {player addMagazine _x} forEach _primaryWeaponMagazine;
        {player addMagazine _x} forEach _handgunMagazine;
        {player addMagazine _x} forEach _secondaryWeaponMagazine;
        {player addWeapon _x} forEach _weapons;
        {player addPrimaryWeaponItem _x} forEach _primaryWeaponItems;
        {player addHandgunItem _x} forEach _handgunItems;
        {player addSecondaryWeaponItem _x} forEach _secondaryWeaponItems;
        {player linkItem _x} forEach _assigneditems;

        _result = [_logic,"getUnitLoadout", player] call MAINCLASS;

    };

    method( "convertLegacyFormatLoadouts" ) {

        private _originalUnitLoadout = [_logic,"getUnitLoadout", player] call MAINCLASS;

        private _mainFolder = [_logic,"mainFolder"] call MAINCLASS;

        private _oldData = [];
        private _dataDirectory = profileNamespace getVariable "SpyderAddons_Loadouts";

        [_logic,"convertFolder", [_mainFolder,_dataDirectory]] call MAINCLASS;

        [_logic,"updateLists"] call MAINCLASS;
        [_logic,"setUnitLoadout", [player,_originalUnitLoadout]] call MAINCLASS;

    };

    defaultMethod();

};

// return result if any exists
if (!isnil "_result") then {_result} else {nil};