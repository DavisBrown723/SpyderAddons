#include <\x\spyderaddons\addons\sup_loadout\script_component.hpp>
SCRIPT(loadoutManager);

/* ----------------------------------------------------------------------------
Function: SpyderAddons_fnc_loadoutManager

Description:
Main handler for the loadout manager

Parameters:
String - Operation
Array - Arguments

Returns:
Any - Result of the operation

Examples:
(begin example)
//-- Open the loadout manager
["open"] call SpyderAddons_fnc_loadoutManager;
(end)

See Also:
- nil

Author: SpyderBlack723

Peer Reviewed:
nil
---------------------------------------------------------------------------- */

params [
	["_logic", objNull],
	["_operation", ""],
	["_arguments", []]
];
private ["_result"];

//-- Define Class
#define MAINCLASS SpyderAddons_fnc_loadoutManager

//-- Define control ID's
#define LOADOUTMANAGER_DISPLAY (findDisplay 721)

#define LOADOUTMANAGER_LEFTTITLE (LOADOUTMANAGER_DISPLAY displayCtrl 7210)
#define LOADOOUTMANAGER_LEFTINSTRUCTIONS (LOADOUTMANAGER_DISPLAY displayCtrl 7212)
#define LOADOUTMANAGER_LEFTLIST (LOADOUTMANAGER_DISPLAY displayCtrl 7214)

#define LOADOUTMANAGER_RIGHTTITLE (LOADOUTMANAGER_DISPLAY displayCtrl 7211)
#define LOADOUTMANAGER_RIGHTINSTRUCTIONS (LOADOUTMANAGER_DISPLAY displayCtrl 7213)
#define LOADOUTMANAGER_RIGHTLIST (LOADOUTMANAGER_DISPLAY displayCtrl 7222)

#define LOADOUTMANAGER_INPUTBOX (LOADOUTMANAGER_DISPLAY displayCtrl 7223)

#define LOADOUTMANAGER_OPENFOLDER (LOADOUTMANAGER_DISPLAY displayCtrl 7227)
#define LOADOUTMANAGER_CLOSEFOLDER (LOADOUTMANAGER_DISPLAY displayCtrl 7228)

#define LOADOUTMANAGER_TRANSFER (LOADOUTMANAGER_DISPLAY displayCtrl 7219)

#define LOADOUTMANAGER_LOADCLASS (LOADOUTMANAGER_DISPLAY displayCtrl 7216)
#define LOADOUTMANAGER_SAVECLASS (LOADOUTMANAGER_DISPLAY displayCtrl 7217)
#define LOADOUTMANAGER_LOADONRESPAWN (LOADOUTMANAGER_DISPLAY displayCtrl 7220)

#define LOADOUTMANAGER_BLANKBUTTON (LOADOUTMANAGER_DISPLAY displayCtrl 7224)
#define LOADOUTMANAGER_ARSENAL (LOADOUTMANAGER_DISPLAY displayCtrl 7226)

switch (_operation) do {

	case "init": {
		_syncedUnits = _arguments;

		//-- Get module parameters
		_transfer = call compile (_logic getVariable "Transfer");
		_arsenal = call compile (_logic getVariable "Arsenal");

		{
			if (typeName _x == "OBJECT") then {
				_x setVariable ["LoadoutManager_Settings", [_arsenal,_transfer]];
				_x addAction ["Access Loadout Manager", {[nil,"open", _this] call SpyderAddons_fnc_loadoutManager}];
			};
		} forEach _syncedUnits;

		MOD(loadoutManager) = [] call CBA_fnc_hashCreate;
	};
	
	case "open": {
		private ["_settings"];
		_arguments params [
			["_object", nil]
		];

		CreateDialog "Loadout_Manager";
		[MOD(loadoutManager),"onLoad", _object] call MAINCLASS;
	};

	case "onLoad": {
		private ["_arsenal","_transfer"];

		if (typeName _arguments == "OBJECT") then {
			_object = _arguments;
			_settings = _object getVariable "LoadoutManager_Settings";
			_arsenal = _settings select 0;
			_transfer = _settings select 1;

			[_logic,"Settings", [_arsenal,_transfer]] call CBA_fnc_hashSet;
		} else {
			_settings = [_logic,"Settings"] call CBA_fnc_hashGet;
			_arsenal = _settings select 0;
			_transfer = _settings select 1;
		};

		//-- Check if arsenal is enabled
		LOADOUTMANAGER_ARSENAL ctrlEnable _arsenal;
		LOADOUTMANAGER_TRANSFER ctrlEnable _transfer;
		LOADOUTMANAGER_BLANKBUTTON ctrlShow false;

		LOADOUTMANAGER_CLOSEFOLDER ctrlEnable false;

		//-- Display main folder
		_loadoutDirectory = profileNamespace getVariable "SpyderAddons_Loadouts";
		if (isNil "_loadoutDirectory") then {
			profileNamespace setVariable ["SpyderAddons_Loadouts", ([] call CBA_fnc_hashCreate)];
			[_logic,"createFolder", "Transferred_Loadouts"] call MAINCLASS;
		};

		[_logic,"displayFolder", _loadoutDirectory] call SpyderAddons_fnc_loadoutManager;

		LOADOUTMANAGER_LEFTLIST ctrlAddEventHandler ["LBSelChanged","[SpyderAddons_loadoutManager,'onLeftListSwitch'] call SpyderAddons_fnc_loadoutManager"];
	};

	case "onUnload": {
		[_logic,"TransferData", nil] call CBA_fnc_hashSet;
		[_logic,"CurrentFolder", nil] call CBA_fnc_hashSet;
		[_logic,"ParentFolder", nil] call CBA_fnc_hashSet;
	};

	case "onLeftListSwitch": {
		_mainDirectory = profileNamespace getVariable "SpyderAddons_Loadouts";
		_currentFolder = [_logic,"CurrentFolder"] call CBA_fnc_hashGet;

		if !(_currentFolder isEqualTo _mainDirectory) then {
			LOADOUTMANAGER_CLOSEFOLDER ctrlEnable true;
		} else {
			LOADOUTMANAGER_CLOSEFOLDER ctrlEnable false;
		};

		lbClear LOADOUTMANAGER_RIGHTLIST;
		LOADOUTMANAGER_RIGHTLIST ctrlRemoveAllEventHandlers "LBSelChanged";

		_index = lbCurSel LOADOUTMANAGER_LEFTLIST;
		_slotName = LOADOUTMANAGER_LEFTLIST lbText _index;
		_slotData = [_currentFolder,_slotName] call CBA_fnc_hashGet;

		LOADOUTMANAGER_INPUTBOX ctrlSetText _slotName;
		LOADOOUTMANAGER_LEFTINSTRUCTIONS ctrlSetText "";
		LOADOUTMANAGER_RIGHTINSTRUCTIONS ctrlSetText "";
		LOADOUTMANAGER_BLANKBUTTON ctrlShow false;

		//-- Nullify data
		[_logic,"TransferData", nil] call CBA_fnc_hashSet;

		if ([_slotData] call CBA_fnc_isHash) then {
			//-- Selected folder
			[nil,"displayFolderContents", _slotData] call SpyderAddons_fnc_loadoutManager;

			LOADOUTMANAGER_RIGHTTITLE ctrlSetText "Folder Contents";

			//-- Disable loadout controls
			LOADOUTMANAGER_LOADCLASS ctrlEnable false;
			LOADOUTMANAGER_SAVECLASS ctrlEnable false;
			LOADOUTMANAGER_LOADONRESPAWN ctrlEnable false;

			//-- enable folder controls
			LOADOUTMANAGER_OPENFOLDER ctrlEnable true;

			LOADOUTMANAGER_LOADONRESPAWN ctrlEnable false;
		} else {
			//-- Selected loadout
			[nil,"displayClassContents", _slotData] call SpyderAddons_fnc_loadoutManager;

			LOADOUTMANAGER_RIGHTTITLE ctrlSetText "Loadout Contents";

			//-- enable loadout controls
			LOADOUTMANAGER_LOADCLASS ctrlEnable true;
			LOADOUTMANAGER_SAVECLASS ctrlEnable true;
			LOADOUTMANAGER_LOADONRESPAWN ctrlEnable true;

			//-- disable folder controls
			LOADOUTMANAGER_OPENFOLDER ctrlEnable false;

			LOADOUTMANAGER_LOADONRESPAWN ctrlEnable true;
		};
	};

	case "openFolder": {
		_currentFolder = [_logic,"CurrentFolder"] call CBA_fnc_hashGet;

		_index = lbCurSel LOADOUTMANAGER_LEFTLIST;
		_slotName = LOADOUTMANAGER_LEFTLIST lbText _index;

		_newFolder = [_currentFolder,_slotName] call CBA_fnc_hashGet;
		[_logic,"displayFolder", _newFolder] call MAINCLASS;
	};

	case "loadOldFormatClasses": {

	};

	case "createFolder": {
		private ["_folderName"];

		if (typeName _arguments == "ARRAY") then {
			_folderName = ctrlText LOADOUTMANAGER_INPUTBOX;
		} else {
			_folderName = _arguments;
		};

		_currentFolder = [_logic,"CurrentFolder"] call CBA_fnc_hashGet;
		
		if (_folderName in (_currentFolder select 1)) then {
			LOADOOUTMANAGER_LEFTINSTRUCTIONS ctrlSetText "Folder already exists";
		} else {
			LOADOUTMANAGER_LEFTLIST lbAdd _folderName;
			[_currentFolder,_folderName, ([] call CBA_fnc_hashCreate)] call CBA_fnc_hashSet;
		};

		[_logic,"displayFolder", _currentFolder] call MAINCLASS;
	};

	case "deleteSlot": {
		_index = lbCurSel LOADOUTMANAGER_LEFTLIST;
		_currentFolder = [_logic,"CurrentFolder"] call CBA_fnc_hashGet;
		_slotName = LOADOUTMANAGER_LEFTLIST lbText _index;

		LOADOUTMANAGER_LEFTLIST lbDelete _index;
		[_currentFolder, _slotName] call CBA_fnc_hashRem;

		[_logic,"displayFolder", _currentFolder] call MAINCLASS;

		lbClear LOADOUTMANAGER_RIGHTLIST;
		LOADOUTMANAGER_RIGHTTITLE ctrlSetText "";
		LOADOUTMANAGER_RIGHTINSTRUCTIONS ctrlSetText "";
	};

	case "displayFolder": {
		_folder = _arguments;
		[_logic,"CurrentFolder", _folder] call CBA_fnc_hashSet;

		//-- Flush list
		lbClear LOADOUTMANAGER_LEFTLIST;
		lbClear LOADOUTMANAGER_RIGHTLIST;

		_data = _folder select 2;
		{
			_name = _x;
			_slotData = _data select _forEachIndex;

			if ([_slotData] call CBA_fnc_isHash) then {
				LOADOUTMANAGER_LEFTLIST lbAdd _name;
				LOADOUTMANAGER_LEFTLIST lbSetPicture [_forEachIndex, "x\spyderaddons\addons\sup_loadout\data\images\folder.paa"];
			} else {
				LOADOUTMANAGER_LEFTLIST lbAdd _name;
			};
		} forEach (_folder select 1);

		if (lbSize LOADOUTMANAGER_LEFTLIST > 0) then {
			LOADOUTMANAGER_LEFTLIST lbSetCurSel 0;
		} else {
			//-- enable loadout controls
			LOADOUTMANAGER_LOADCLASS ctrlEnable false;
			LOADOUTMANAGER_SAVECLASS ctrlEnable true;
			LOADOUTMANAGER_LOADONRESPAWN ctrlEnable false;
		};
	};

	case "displayFolderContents": {
		_folder = _arguments;

		_keys = _folder select 1;
		{
			_name = _keys select _forEachIndex;

			if ([_x] call CBA_fnc_isHash) then {
				LOADOUTMANAGER_RIGHTLIST lbAdd _name;
				LOADOUTMANAGER_RIGHTLIST lbSetPicture [_forEachIndex, "x\spyderaddons\addons\sup_loadout\data\images\folder.paa"];
			} else {
				LOADOUTMANAGER_RIGHTLIST lbAdd _name;
			};
		} forEach (_folder select 2);
	};

	case "getParentFolder": {
		_childFolder = _arguments;
		_loadoutDirectory = profileNamespace getVariable "SpyderAddons_Loadouts";

		//-- Special check for main directory
		if (_childFolder in (_loadoutDirectory select 2)) then {
			_result = _loadoutDirectory;
		} else {
			_result = [nil,"findFolderInDirectory", [_loadoutDirectory,_childFolder]] call MAINCLASS;

			if (_result isEqualTo false) then {
				LOADOOUTMANAGER_LEFTINSTRUCTIONS ctrlSetText "Error: previous folder could not be found";
			};
		};
	};

	case "findFolderInDirectory": {
		_arguments params ["_directory","_folder"];
		_result = false;

		_subFolders = [];
		{
			if ([_x] call CBA_fnc_isHash) then {
				_subFolders pushBack _x;
			};
		} forEach (_directory select 2);

		//_childFolders = (_x select 2) select {[_x] call CBA_fnc_isHash};

		{
			if (_folder isEqualTo _x) exitWith {
				_result = _directory;
			};

			_searchResult = [nil,"findFolderInDirectory", [_x,_folder]] call MAINCLASS;

			if !(_searchResult isEqualTo false) exitWith {
				_result = _searchResult;
			};
		} forEach _subFolders;
	};

	case "closeFolder": {
		_currentFolder = [_logic,"CurrentFolder"] call CBA_fnc_hashGet;
		_parentFolder = [nil,"getParentFolder", _currentFolder] call MAINCLASS;

		copyToClipboard str ([_currentFolder,"DIVIDE",_parentFolder]);

		[_logic,"displayFolder", _parentFolder] call MAINCLASS;
	};

	case "getAllFoldersInDirectory": {
		_directory = _arguments;

		_names = [];
		_folders = [];

		_keys = _directory select 1;
		{
			if ([_x] call CBA_fnc_isHash) then {
				_names pushBack (_keys select _forEachIndex);
				_folders pushBack _x;

				{
					if (_forEachIndex == 0) then {
						_names pushBack _x;
					} else {
						_folders pushBack _x;
					};
				} forEach ([_logic,"getAllFoldersInDirectory", _x] call MAINCLASS);
			};
		} forEach (_directory select 2);

		_result = [_names,_folders];
	};

	case "moveSlot": {
		_mainDirectory = profileNamespace getVariable "SpyderAddons_Loadouts";
		_currentFolder = [_logic,"CurrentFolder"] call CBA_fnc_hashGet;

		_index = lbCurSel LOADOUTMANAGER_LEFTLIST;
		_slotName = LOADOUTMANAGER_LEFTLIST lbText _index;
		_slotData = [_currentFolder,_slotName] call CBA_fnc_hashGet;

		[_logic,"MoveData", _slotData] call CBA_fnc_hashSet;

		if ([_slotData] call CBA_fnc_isHash) then {
			LOADOUTMANAGER_RIGHTTITLE ctrlSetText "Move Folder";
		} else {
			LOADOUTMANAGER_RIGHTTITLE ctrlSetText "Move Loadout";
		};

		LOADOUTMANAGER_RIGHTINSTRUCTIONS ctrlSetText "Select a folder to move the data to";

		_allFolders = [nil,"getAllFoldersInDirectory", _mainDirectory] call MAINCLASS;
		{
			LOADOUTMANAGER_RIGHTLIST lbAdd _x;
		} forEach (_allFolders select 0);
		[_logic,"AllFolders", (_allFolders select 1)] call CBA_fnc_hashSet;

		LOADOUTMANAGER_BLANKBUTTON ctrlShow true;
		LOADOUTMANAGER_BLANKBUTTON ctrlSetText "Confirm Move";
		LOADOUTMANAGER_BLANKBUTTON buttonSetAction "[SpyderAddons_loadoutManager,'confirmMove'] call SpyderAddons_fnc_loadoutManager";
	};

	case "saveClass": {
		_name = ctrlText LOADOUTMANAGER_INPUTBOX;
		_currentFolder = [_logic,"CurrentFolder"] call CBA_fnc_hashGet;

		_loadout = [nil,"getLoadout", player] call MAINCLASS;
		[_currentFolder,_name,_loadout] call CBA_fnc_hashSet;

		[_logic,"displayFolder", _currentFolder] call MAINCLASS;
	};

	case "loadClass": {
		_currentFolder = [_logic,"CurrentFolder"] call CBA_fnc_hashGet;

		_index = lbCurSel LOADOUTMANAGER_LEFTLIST;
		_slotName = LOADOUTMANAGER_LEFTLIST lbText _index;
		_loadout = [_currentFolder,_slotName] call CBA_fnc_hashGet;

		[_logic,"equipLoadout", [player,_loadout]] call MAINCLASS;
	};

	case "equipLoadout": {
		_arguments params ["_unit","_loadout"];

		//-- Strip the unit down
		[nil,"removeAllGear", _unit] call MAINCLASS;

		//-- Define Gear
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

		//-- Add Gear
		_unit addUniform _uniform;
		_unit addVest _vest;
		_unit addBackpack _backpack;
		_unit addHeadgear _headgear;
		_unit addGoggles _goggles;

		{_unit addItemToBackpack _x} forEach _backpackitems;
		{_unit addItemToUniform _x} forEach _uniformitems;
		{_unit addItemToVest _x} forEach _vestitems;

		{_unit addMagazine _x} forEach _primaryWeaponMagazine;
		{_unit addMagazine _x} forEach _handgunMagazine;
		{_unit addMagazine _x} forEach _secondaryWeaponMagazine;

		{_unit addWeapon _x} forEach _weapons;

		{_unit addPrimaryWeaponItem _x} forEach _primaryWeaponItems;
		{_unit addHandgunItem _x} forEach _handgunItems;
		{_unit addSecondaryWeaponItem _x} forEach _secondaryWeaponItems;

		{_unit linkItem _x} forEach _assigneditems; 
	};

	case "removeAllGear": {
		_unit = _arguments;

		RemoveAllWeapons _unit;
		{_unit removeMagazine _x} foreach (magazines _unit);
		removeUniform _unit;
		removeVest _unit;
		removeBackpack _unit;
		removeGoggles _unit;
		removeHeadGear _unit;
		removeAllAssignedItems _unit;
	};

	case "getLoadout": {
		_unit = _arguments;

		_uniform = uniform _unit;
		_vest = vest _unit;
		_backpack = backpack _unit;
		_headgear = headgear _unit;
		_goggles = goggles _unit;

		_uniformItems = uniformItems _unit;
		_vestItems = uniformItems _unit;
		_backpackItems = backpackItems _unit;

		_weapons = weapons _unit;

		_primaryweaponItems = primaryWeaponItems _unit;
		_primaryWeaponMagazine = primaryWeaponMagazine _unit;

		_handgunItems = handgunItems _unit;
		_handgunMagazine = handgunMagazine _unit;

		_secondaryWeaponItems = secondaryWeaponItems _unit;
		_secondaryWeaponMagazine = secondaryWeaponMagazine _unit;

		_assignedItems = assignedItems _unit;

		_result = [
				_uniform,
				_vest,
				_backpack,
				_headgear,
				_goggles,
				_uniformItems,
				_vestItems,
				_backpackItems,
				_weapons,
				_primaryWeaponItems,
				_primaryWeaponMagazine,
				_handgunItems,
				_handgunMagazine,
				_secondaryWeaponItems,
				_secondaryWeaponMagazine,
				_assignedItems
		];
	};
	
	case "renameSlot": {
		_currentFolder = [_logic,"CurrentFolder"] call CBA_fnc_hashGet;
		_index = lbCurSel LOADOUTMANAGER_LEFTLIST;
		_oldName = LOADOUTMANAGER_LEFTLIST lbText _index;
		_newName = ctrlText LOADOUTMANAGER_INPUTBOX;

		_data = [_currentFolder,_oldName] call CBA_fnc_hashGet;
		[_currentFolder,_oldName] call CBA_fnc_hashRem;
		[_currentFolder,_newName, _data] call CBA_fnc_hashSet;

		[_logic,"displayFolder", _currentFolder] call MAINCLASS;
		lbSetCurSel [LOADOUTMANAGER_LEFTLIST, _index];
	};
	
	case "displayClassContents": {
		_loadout = _arguments;

		lbClear LOADOUTMANAGER_RIGHTLIST;

		TITLERIGHT ctrlSetText "Class Gear";

		//-- Define Gear
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

		private ["_index"];
		_index = 0;

		//-- Weapons
		{
			_configPath = configfile >> "CfgWeapons" >> _x;
			if (isClass _configPath) then {
				_displayName = getText (_configPath >> "displayName");
				_tooltip = getText (_configPath >> "tooltip");
				_picture = getText (_configPath >> "picture");

				LOADOUTMANAGER_RIGHTLIST lbAdd _displayName;
				LOADOUTMANAGER_RIGHTLIST lbSetTooltip [_index,_tooltip];
				LOADOUTMANAGER_RIGHTLIST lbSetPicture [_index, _picture];
				_index = _index + 1;
			};
		} forEach _weapons;

		//-- Weapon attachments
		_attachments = _primaryWeaponItems + _handgunItems + _secondaryWeaponItems;
		{
			_item = _x;
			_configPath = configfile >> "CfgWeapons" >> _item;
			if (isClass _configPath) then {
				_displayName = getText (_configPath >> "displayName");
				_tooltip = getText (_configPath >> "tooltip");
				_picture = getText (_configPath >> "picture");

				LOADOUTMANAGER_RIGHTLIST lbAdd _displayName;
				LOADOUTMANAGER_RIGHTLIST lbSetTooltip [_index,_tooltip];
				LOADOUTMANAGER_RIGHTLIST lbSetPicture [_index, _picture];
				_index = _index + 1;
			};
		} forEach _attachments;

		//-- Uniform
		_uniformConfigPath = configfile >> "CfgWeapons" >> _uniform;
		if (isClass _uniformConfigPath) then {
			_displayName = getText (_uniformConfigPath >> "displayName");
			_tooltip = getText (_configPath >> "tooltip");
			_picture = getText (_uniformConfigPath >> "picture");

			LOADOUTMANAGER_RIGHTLIST lbAdd _displayName;
			LOADOUTMANAGER_RIGHTLIST lbSetTooltip [_index,_tooltip];
			LOADOUTMANAGER_RIGHTLIST lbSetPicture [_index, _picture];
			_index = _index + 1;
		};

		//-- Vest
		_vestConfigPath = configfile >> "CfgWeapons" >> _vest;
		if (isClass _vestConfigPath) then {
			_displayName = getText (_vestConfigPath >> "displayName");
			_tooltip = getText (_configPath >> "tooltip");
			_picture = getText (_vestConfigPath >> "picture");

			LOADOUTMANAGER_RIGHTLIST lbAdd _displayName;
			LOADOUTMANAGER_RIGHTLIST lbSetTooltip [_index,_tooltip];
			LOADOUTMANAGER_RIGHTLIST lbSetPicture [_index, _picture];
			_index = _index + 1;
		};

		//-- Headgear
		_headgearConfigPath = configfile >> "CfgWeapons" >> _headgear;
		if (isClass _headgearConfigPath) then {
			_displayName = getText (_headgearConfigPath >> "displayName");
			_tooltip = getText (_configPath >> "tooltip");
			_picture = getText (_headgearConfigPath >> "picture");

			LOADOUTMANAGER_RIGHTLIST lbAdd _displayName;
			LOADOUTMANAGER_RIGHTLIST lbSetTooltip [_index,_tooltip];
			LOADOUTMANAGER_RIGHTLIST lbSetPicture [_index, _picture];
			_index = _index + 1;
		};

		//-- Goggles
		if (_goggles != "") then {
			_gogglesConfigPath = configfile >> "CfgGlasses" >> _goggles;
			if (isClass _gogglesConfigPath) then {
				_displayName = getText (_gogglesConfigPath >> "displayName");
				_tooltip = getText (_configPath >> "tooltip");
				_picture = getText (_gogglesConfigPath >> "picture");

				LOADOUTMANAGER_RIGHTLIST lbAdd _displayName;
				LOADOUTMANAGER_RIGHTLIST lbSetTooltip [_index,_tooltip];
				LOADOUTMANAGER_RIGHTLIST lbSetPicture [_index, _picture];
				_index = _index + 1;
			};
		};

		//-- Backpack
		_backpackConfigPath = configfile >> "CfgVehicles" >> _backpack;
		if (isClass _backpackConfigPath) then {
			_displayName = getText (_backpackConfigPath >> "displayName");
			_tooltip = getText (_configPath >> "tooltip");
			_picture = getText (_backpackConfigPath >> "picture");

			LOADOUTMANAGER_RIGHTLIST lbAdd _displayName;
			LOADOUTMANAGER_RIGHTLIST lbSetTooltip [_index,_tooltip];
			LOADOUTMANAGER_RIGHTLIST lbSetPicture [_index, _picture];
			_index = _index + 1;
		};

		//-- Backpack items
		_itemArray = _uniformItems + _vestItems + _backpackItems + _primaryWeaponMagazine + _handgunMagazine + _secondaryWeaponMagazine + _primaryWeaponItems
		 	+ _handgunItems + _secondaryWeaponItems + _assigneditems;
		{
			private ["_item","_count","_configPath"];
			_item = _x;
			_count = {_x == _item} count _itemArray;

			if !(_count == 0) then {
				for "_i" from 0 to _count step 1 do {_itemArray = _itemArray - [_item]};

				_configPath = configfile >> "CfgWeapons" >> _item;
				if !(isClass _configPath) then {_configPath = configfile >> "CfgMagazines" >> _item};
				if !(isClass _configPath) then {_configPath = configfile >> "CfgVehicles" >> _item};

				_displayName = getText (_configPath >> "displayName");
				_tooltip = getText (_configPath >> "tooltip");
				_picture = getText (_configPath >> "picture");
				_itemInfo = format ["%1: %2", _displayName, _count];

				LOADOUTMANAGER_RIGHTLIST lbAdd _displayName;
				LOADOUTMANAGER_RIGHTLIST lbSetTooltip [_index,_tooltip];
				LOADOUTMANAGER_RIGHTLIST lbSetPicture [_index, _picture];
				_index = _index + 1;

			};
		} forEach _itemArray;
	};

	case "setLoadOnRespawn": {
		_currentFolder = [_logic,"CurrentFolder"] call CBA_fnc_hashGet;
		_index = lbCurSel LOADOUTMANAGER_LEFTLIST;
		_slotName = LOADOUTMANAGER_LEFTLIST lbText _index;

		_slotData = [_currentFolder,_slotName] call CBA_fnc_hashGet;

		if ([_slotData] call CBA_fnc_isHash) then {
			hint "You must select a class to load on respawn";
		};

		//-- Remove previous eventhandler if one exists
		if (!isNil {[MOD(loadoutManager),"LoadOnRespawn_EHIndex"] call CBA_fnc_hashGet}) then {
			_index = [MOD(loadoutManager),"LoadOnRespawn_EHIndex"] call CBA_fnc_hashGet;

			player removeEventHandler ["MPRespawn", _index];

			[MOD(loadoutManager),"LoadOnRespawn_EHIndex", nil] call CBA_fnc_hashSet;
			[MOD(loadoutManager),"LoadOnRespawn_Loadout", nil] call CBA_fnc_hashSet;
		};

		_index = player addMPEventHandler ["MPRespawn", {
			_loadout = [SpyderAddons_loadoutManager,"LoadOnRespawn_Loadout"] call CBA_fnc_hashGet;
			_unit = _this select 0;

			[nil,"equipLoadout", [_unit,_loadout]] call SpyderAddons_fnc_loadoutManager;
		}];

		[MOD(loadoutManager),"LoadOnRespawn_EHIndex", _index] call CBA_fnc_hashSet;
		[MOD(loadoutManager),"LoadOnRespawn_Loadout", _slotData] call CBA_fnc_hashSet;
	};
	
	case "openArsenal": {
		private ["_closeButton"];
		disableSerialization;

		//-- Close Loadout Organizer
		closeDialog 0;

		//-- Open Arsenal
		["Open",true] spawn BIS_fnc_arsenal;

		waitUntil {!isNull findDisplay -1};

		//-- Set close button action to open the loadout manager
		_closeButton = (findDisplay -1) displayCtrl 44448;
		_closeButton buttonSetAction "[nil,'open'] call SpyderAddons_fnc_loadoutManager";
	};

	case "transferSlot": {
		_currentFolder = [_logic,"CurrentFolder"] call CBA_fnc_hashGet;

		_index = lbCurSel LOADOUTMANAGER_LEFTLIST;
		_slotName = LOADOUTMANAGER_LEFTLIST lbText _index;
		_data = [_currentFolder,_slotName] call CBA_fnc_hashGet;

		[MOD(loadoutManager),"TransferData", [_slotName,_data]] call CBA_fnc_hashSet;

		//-- Set instructions
		if ([_data] call CBA_fnc_isHash) then {
			LOADOUTMANAGER_RIGHTINSTRUCTIONS ctrlSetText "Select a unit to transfer the folder to";
		} else {
			LOADOUTMANAGER_RIGHTINSTRUCTIONS ctrlSetText "Select a unit to transfer the loadout to";
		};

		lbClear LOADOUTMANAGER_RIGHTLIST;

		//-- Get all units of side player and AI group members
		_units = [];
		{
			if (_x in (units group player) || {{isPlayer _x} && {side _x == side player}}) then {
				if (!(_x in _units) && {_x != player}) then {
					_index = LOADOUTMANAGER_RIGHTLIST lbAdd (name _x);
				};
			};
		} forEach allUnits;

		//-- Enable confirm transfer button right list texts
		if ([_data] call CBA_fnc_isHash) then {
			LOADOUTMANAGER_RIGHTTITLE ctrlSetText "Transfer Folder";
			LOADOUTMANAGER_RIGHTINSTRUCTIONS ctrlSetText "Select a unit to transfer the folder to";
		} else {
			LOADOUTMANAGER_RIGHTTITLE ctrlSetText "Transfer Loadout";
			LOADOUTMANAGER_RIGHTINSTRUCTIONS ctrlSetText "Select a unit to transfer the loadout to";
		};

		LOADOUTMANAGER_BLANKBUTTON ctrlShow true;
		LOADOUTMANAGER_BLANKBUTTON ctrlEnable false;
		LOADOUTMANAGER_BLANKBUTTON ctrlSetText "Confirm Transfer";
		LOADOUTMANAGER_BLANKBUTTON buttonSetAction "[SpyderAddons_loadoutManager,'confirmTransfer'] call SpyderAddons_fnc_loadoutManager";

		LOADOUTMANAGER_RIGHTLIST ctrlAddEventHandler ["LBSelChanged","
			(findDisplay 721 displayCtrl 7224) ctrlEnable true;
			(findDisplay 721 displayCtrl 7213) ctrlSetText 'Select a unit to transfer the data to';
		"];
	};

	case "getUnitByName": {
		_name = _arguments;

		{
			if (name _x == _name) exitWith {
				_result = _x;
			};
		} count allUnits;
	};

	case "confirmTransfer": {
		_index = lbCurSel LOADOUTMANAGER_RIGHTLIST;
		_unit = LOADOUTMANAGER_RIGHTLIST lbText _index;
		_unit = [nil,"getUnitByName", _unit] call MAINCLASS;

		LOADOUTMANAGER_RIGHTLIST ctrlRemoveAllEventHandlers "LBSelChanged";

		_data = [MOD(loadoutManager),"TransferData"] call CBA_fnc_hashGet;

		if (isPlayer _unit) then {
			[nil,"storeTransferredData", [name player, _data]] remoteExecCall [QUOTE(MAINCLASS), _unit];
		} else {
			_loadout = _data select 1;

			if ([_loadout] call CBA_fnc_isHash) then {
				LOADOUTMANAGER_RIGHTINSTRUCTIONS ctrlSetText "You cannot transfer a folder to an AI unit";
			} else {
				[nil,"equipLoadout", [_unit,_loadout]] call MAINCLASS;
			};
		};
	};

	case "storeTransferredData": {
		_arguments params ["_sender","_data"];
		_data params ["_slotName","_data"];

		_loadoutDirectory = profileNamespace getVariable "SpyderAddons_Loadouts";
		_storedData = [_loadoutDirectory,"Transferred_Loadouts"] call CBA_fnc_hashGet;
		if (isNil "_storedData") then {[_loadoutDirectory,"Transferred_Loadouts", ([] call CBA_fnc_hashCreate)] call CBA_fnc_hashSet};

		if (_slotName in (_storedData select 1)) then {
			[_storedData,(format ["%1 (%2)", _slotName, time]), _data] call CBA_fnc_hashSet;
		} else {
			[_storedData,_slotName, _data] call CBA_fnc_hashSet;
		};

		if ([MOD(loadoutManager),"CurrentFolder"] call CBA_fnc_hashGet isEqualTo _loadoutDirectory) then {
			[MOD(loadoutManager),"displayFolder", _loadoutDirectory] call MAINCLASS;
		};

		if ([_data] call CBA_fnc_isHash) then {
			[format ["%1 has sent you a folder titled %2", _sender, _slotName]] call SpyderAddons_fnc_displayNotification;
		} else {
			[format ["%1 has sent you a loadout titled %2", _sender, _slotName]] call SpyderAddons_fnc_displayNotification;
		};
	};
};

//-- Return result if any exists
if (!isNil "_result") then {_result} else {nil};