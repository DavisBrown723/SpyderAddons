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

private ["_result"];
params [
	["_logic", objNull],
	["_operation", ""],
	["_arguments", []]
];

//-- Define Class
#define MAINCLASS SpyderAddons_fnc_loadoutManager

//-- Define control ID's
#define LOADOUTMANAGER_DISPLAY (findDisplay 721)

#define LOADOUTMANAGER_LEFTTITLE (LOADOUTMANAGER_DISPLAY displayCtrl 7210)
#define LOADOUTMANAGER_LEFTINSTRUCTIONS (LOADOUTMANAGER_DISPLAY displayCtrl 7212)
#define LOADOUTMANAGER_LEFTLIST (LOADOUTMANAGER_DISPLAY displayCtrl 7214)

#define LOADOUTMANAGER_RIGHTTITLE (LOADOUTMANAGER_DISPLAY displayCtrl 7211)
#define LOADOUTMANAGER_RIGHTINSTRUCTIONS (LOADOUTMANAGER_DISPLAY displayCtrl 7213)
#define LOADOUTMANAGER_RIGHTLIST (LOADOUTMANAGER_DISPLAY displayCtrl 7222)

#define LOADOUTMANAGER_INPUTBOX (LOADOUTMANAGER_DISPLAY displayCtrl 7223)

#define LOADOUTMANAGER_OPENFOLDER (LOADOUTMANAGER_DISPLAY displayCtrl 7227)
#define LOADOUTMANAGER_CLOSEFOLDER (LOADOUTMANAGER_DISPLAY displayCtrl 7228)

#define LOADOUTMANAGER_MOVE (LOADOUTMANAGER_DISPLAY displayCtrl 7229)
#define LOADOUTMANAGER_TRANSFER (LOADOUTMANAGER_DISPLAY displayCtrl 7219)
#define LOADOUTMANAGER_RENAME (LOADOUTMANAGER_DISPLAY displayCtrl 7218)
#define LOADOUTMANAGER_DELETE (LOADOUTMANAGER_DISPLAY displayCtrl 7221)

#define LOADOUTMANAGER_LOADCLASS (LOADOUTMANAGER_DISPLAY displayCtrl 7216)
#define LOADOUTMANAGER_SAVECLASS (LOADOUTMANAGER_DISPLAY displayCtrl 7217)
#define LOADOUTMANAGER_LOADONRESPAWN (LOADOUTMANAGER_DISPLAY displayCtrl 7220)

#define LOADOUTMANAGER_BLANKBUTTON (LOADOUTMANAGER_DISPLAY displayCtrl 7224)
#define LOADOUTMANAGER_ARSENAL (LOADOUTMANAGER_DISPLAY displayCtrl 7226)

switch (_operation) do {

	case "init": {
		_syncedUnits = _arguments;

		if (isNil QMOD(loadoutManager)) then {
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

		//-- Check if arsenal and transfer is enabled
		LOADOUTMANAGER_ARSENAL ctrlEnable _arsenal;
		LOADOUTMANAGER_TRANSFER ctrlEnable _transfer;

		//-- Disable unneeded buttons
		LOADOUTMANAGER_BLANKBUTTON ctrlShow false;
		LOADOUTMANAGER_CLOSEFOLDER ctrlEnable false;

		//-- Create main folder if it doesn't exist
		_loadoutDirectory = profileNamespace getVariable "SpyderAddons_Loadouts";
		if (isNil "_loadoutDirectory") then {
			profileNamespace setVariable ["SpyderAddons_Loadouts", ([] call CBA_fnc_hashCreate)];
			[_logic,"createFolder", "Transferred_Loadouts"] call MAINCLASS;
		};

		//-- Load and reformat old classes
		[_logic,"loadOldFormatClasses"] call MAINCLASS;

		//-- Display main folder
		[_logic,"displayFolder", _loadoutDirectory] call SpyderAddons_fnc_loadoutManager;

		LOADOUTMANAGER_LEFTLIST ctrlAddEventHandler ["LBSelChanged","[SpyderAddons_loadoutManager,'onLeftListSwitch'] call SpyderAddons_fnc_loadoutManager"];

		if (lbSize LOADOUTMANAGER_LEFTLIST > 0) then {
			LOADOUTMANAGER_LEFTLIST lbSetCurSel 0;
		};
	};

	case "onUnload": {
		[_logic,"TransferData", nil] call CBA_fnc_hashSet;
		[_logic,"MoveData", nil] call CBA_fnc_hashSet;
		[_logic,"AllFolders", nil] call CBA_fnc_hashSet;
		[_logic,"CurrentFolder", nil] call CBA_fnc_hashSet;

		saveProfileNamespace;	//-- 99% sure this isn't necessary, but w/e
	};

	case "onLeftListSwitch": {
		_currentFolder = [_logic,"CurrentFolder"] call CBA_fnc_hashGet;

		lbClear LOADOUTMANAGER_RIGHTLIST;
		LOADOUTMANAGER_RIGHTLIST ctrlRemoveAllEventHandlers "LBSelChanged";

		_index = lbCurSel LOADOUTMANAGER_LEFTLIST;
		_slotName = LOADOUTMANAGER_LEFTLIST lbText _index;
		_slotData = [_currentFolder,_slotName] call CBA_fnc_hashGet;

		LOADOUTMANAGER_INPUTBOX ctrlSetText _slotName;
		LOADOUTMANAGER_LEFTINSTRUCTIONS ctrlSetText "";
		LOADOUTMANAGER_RIGHTINSTRUCTIONS ctrlSetText "";
		LOADOUTMANAGER_BLANKBUTTON ctrlShow false;

		//-- Nullify data
		[_logic,"TransferData", nil] call CBA_fnc_hashSet;
		[_logic,"MoveData", nil] call CBA_fnc_hashSet;
		[_logic,"AllFolders", nil] call CBA_fnc_hashSet;

		if ([_slotData] call CBA_fnc_isHash) then {
			//-- Selected folder
			[nil,"displayFolderContents", _slotData] call SpyderAddons_fnc_loadoutManager;

			LOADOUTMANAGER_RIGHTTITLE ctrlSetText "Folder Contents";

			//-- Disable loadout controls
			LOADOUTMANAGER_LOADCLASS ctrlEnable false;
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
		_oldClasses = [];

		//-- Get old classes
		for "_i" from 0 to 15 step 1 do {
			_loadout = profileNamespace getVariable format ["LoadoutManagerLoadout_%1", _i];

			if (!isNil {_loadout select 0}) then {

				//-- Get old format info
				_loadout params [
					"_name",
					"_uniform",
					"_vest",
					"_backpack",
					"_backpackItems",
					"_headgear",
					"_goggles",
					"_uniformItems",
					"_vestItems",
					"_weapons",
					"_primaryWeaponItems",
					"_secondaryWeaponItems",
					"_assignedItems",
					"_primaryWeaponMagazines"
				];

				//-- Reformat info to new standard
				_loadout = [
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
					[""],
					["","",""],
					[""],
					_secondaryWeaponItems,
					[""],
					_assignedItems
				];

				[_logic,"saveClass", _name] call MAINCLASS;

				//-- Delete old format class
				profileNamespace setVariable [(format ["LoadoutManagerLoadout_%1", _i]), nil];
			};
		};
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
			LOADOUTMANAGER_LEFTINSTRUCTIONS ctrlSetText "A slot with that name already exists in the current folder";
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

		LOADOUTMANAGER_RIGHTTITLE ctrlSetText "";
		LOADOUTMANAGER_RIGHTINSTRUCTIONS ctrlSetText "";

		[_logic,"displayFolder", _currentFolder] call MAINCLASS;
	};

	case "displayFolder": {
		_folder = _arguments;
		[_logic,"CurrentFolder", _folder] call CBA_fnc_hashSet;

		_mainDirectory = profileNamespace getVariable "SpyderAddons_Loadouts";
		if (_folder isEqualTo _mainDirectory) then {
			LOADOUTMANAGER_CLOSEFOLDER ctrlEnable false;
		} else {
			LOADOUTMANAGER_CLOSEFOLDER ctrlEnable true;
		};

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
				LOADOUTMANAGER_LEFTLIST lbSetPicture [_forEachIndex, "x\spyderaddons\addons\sup_loadout\data\images\weapon.paa"];
			};
		} forEach (_folder select 1);

		if (lbSize LOADOUTMANAGER_LEFTLIST > 0) then {
			_selectedIndex = lbCurSel LOADOUTMANAGER_LEFTLIST;

			if (_selectedIndex != -1) then {
				LOADOUTMANAGER_LEFTLIST lbSetCurSel _selectedIndex;
			} else {
				LOADOUTMANAGER_LEFTLIST lbSetCurSel 0;
			};

			LOADOUTMANAGER_MOVE ctrlEnable true;

			//-- enable generic controls
			LOADOUTMANAGER_RENAME ctrlEnable true;
			LOADOUTMANAGER_DELETE ctrlEnable true;

			if (([_logic,"Settings"] call CBA_fnc_hashGet) select 1) then {
				LOADOUTMANAGER_TRANSFER ctrlEnable true;
			};
		} else {
			LOADOUTMANAGER_MOVE ctrlEnable false;
			LOADOUTMANAGER_TRANSFER ctrlEnable false;

			//-- disable folder controls
			LOADOUTMANAGER_OPENFOLDER ctrlEnable false;

			//-- disable generic controls
			LOADOUTMANAGER_RENAME ctrlEnable false;
			LOADOUTMANAGER_DELETE ctrlEnable false;

			//-- disable loadout controls
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
				LOADOUTMANAGER_RIGHTLIST lbSetPicture [_forEachIndex, "x\spyderaddons\addons\sup_loadout\data\images\weapon.paa"];
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
				LOADOUTMANAGER_LEFTINSTRUCTIONS ctrlSetText "Error: previous folder could not be found";
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

		[_logic,"displayFolder", _parentFolder] call MAINCLASS;
	};

	case "getAllFoldersInDirectory": {
		private ["_names","_folders"];
		_arguments params ["_directory",["_exclude",[]]];
		_keys = _directory select 1;

		_names = [];
		_folders = [];
			
		{
			if ([_x] call CBA_fnc_isHash) then {
				if !(_x isEqualTo _exclude) then {
					_names pushBack (_keys select _forEachIndex);
					_folders pushBack _x;

					_subData = [_logic,"getAllFoldersInDirectory", [_x,_exclude]] call MAINCLASS;
					_names append (_subData select 0);
					_folders append (_subData select 1);
				};
			};
		} forEach (_directory select 2);	

		_result = [_names,_folders];
	};

	case "moveSlot": {
		private ["_allFolders"];
		_mainDirectory = profileNamespace getVariable "SpyderAddons_Loadouts";
		_currentFolder = [_logic,"CurrentFolder"] call CBA_fnc_hashGet;

		_index = lbCurSel LOADOUTMANAGER_LEFTLIST;
		_slotName = LOADOUTMANAGER_LEFTLIST lbText _index;
		_slotData = [_currentFolder,_slotName] call CBA_fnc_hashGet;

		[_logic,"MoveData", [_slotName, _slotData]] call CBA_fnc_hashSet;

		if ([_slotData] call CBA_fnc_isHash) then {
			LOADOUTMANAGER_RIGHTTITLE ctrlSetText "Move Folder";
			LOADOUTMANAGER_RIGHTINSTRUCTIONS ctrlSetText "Select a folder to move the folder to";

			_allFolders = [nil,"getAllFoldersInDirectory", [_mainDirectory, _slotData]] call MAINCLASS;
		} else {
			LOADOUTMANAGER_RIGHTTITLE ctrlSetText "Move Loadout";
			LOADOUTMANAGER_RIGHTINSTRUCTIONS ctrlSetText "Select a folder to move the loadout to";

			_allFolders = [nil,"getAllFoldersInDirectory", [_mainDirectory]] call MAINCLASS;
		};

		//-- Display all folders in the right list
		lbClear LOADOUTMANAGER_RIGHTLIST;
		_allFolders params ["_names","_folders"];

		//-- Add main directory
		_folders = [_mainDirectory] + _folders;
		_index = LOADOUTMANAGER_RIGHTLIST lbAdd "Main Directory";
		LOADOUTMANAGER_RIGHTLIST lbSetPicture [_index, "x\spyderaddons\addons\sup_loadout\data\images\folder.paa"];

		{
			_index = LOADOUTMANAGER_RIGHTLIST lbAdd _x;
			LOADOUTMANAGER_RIGHTLIST lbSetPicture [_index, "x\spyderaddons\addons\sup_loadout\data\images\folder.paa"];
		} forEach _names;

		[_logic,"AllFolders", _folders] call CBA_fnc_hashSet;

		LOADOUTMANAGER_BLANKBUTTON ctrlShow true;
		LOADOUTMANAGER_BLANKBUTTON ctrlSetText "Confirm Move";
		LOADOUTMANAGER_BLANKBUTTON buttonSetAction "[SpyderAddons_loadoutManager,'confirmMove'] call SpyderAddons_fnc_loadoutManager";

		LOADOUTMANAGER_RIGHTLIST lbSetCurSel 0;
	};

	case "confirmMove": {
		_data = [_logic,"MoveData"] call CBA_fnc_hashGet;
		_data params ["_name","_data"];
		_index = lbCurSel LOADOUTMANAGER_RIGHTLIST;

		//-- Get selected folder
		_allFolders = [_logic,"AllFolders"] call CBA_fnc_hashGet;
		_selectedFolder = _allFolders select _index;

		if (_name in (_selectedFolder select 1)) then {
			LOADOUTMANAGER_RIGHTINSTRUCTIONS ctrlSetText "A slot of that name already exists in the selected folder";
		} else {
			//-- Delete original data
			_currentFolder = [_logic,"CurrentFolder"] call CBA_fnc_hashGet;
			[_currentFolder,_name, nil] call CBA_fnc_hashSet;

			//-- Create replicated data in selected folder
			[_selectedFolder,_name,_data] call CBA_fnc_hashSet;

			[_logic,"displayFolder", _currentFolder] call MAINCLASS;
		};

		LOADOUTMANAGER_RIGHTLIST ctrlAddEventHandler ["LbSelChanged", "
			LOADOOUTMANAGER_RIGHTINSTRUCTIONS ctrlSetText 'Select a folder to move the data to';
		"];
	};

	case "saveClass": {
		private ["_name"];

		_currentFolder = [_logic,"CurrentFolder"] call CBA_fnc_hashGet;

		if (typeName _arguments == "ARRAY") then {
			_name = ctrlText LOADOUTMANAGER_INPUTBOX;
		} else {
			_name = _arguments;
		};

		if (_name in (_currentFolder select 1) && {[([_currentFolder,_name] call CBA_fnc_hashGet)] call CBA_fnc_isHash}) then {
			LOADOUTMANAGER_LEFTINSTRUCTIONS ctrlSetText "A folder with that name already exists in the current folder";
		} else {
			_loadout = [nil,"getLoadout", player] call MAINCLASS;
			[_currentFolder,_name,_loadout] call CBA_fnc_hashSet;

			[_logic,"displayFolder", _currentFolder] call MAINCLASS;
		};
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
		_unit forceAddUniform _uniform;
		_unit addVest _vest;
		_unit addBackpack _backpack;
		_unit addHeadgear _headgear;
		_unit addGoggles _goggles;

		//-- Remove preset items from containers
		{_unit removeItem _x} forEach ((uniformItems _unit) + (vestItems _unit) + (backpackItems _unit));

		{_unit addItemToUniform _x} forEach _uniformitems;
		{_unit addItemToVest _x} forEach _vestitems;
		{_unit addItemToBackpack _x} forEach _backpackitems;

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
		_vestItems = vestItems _unit;
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

		//-- Weapons
		{
			_configPath = configfile >> "CfgWeapons" >> _x;
			if (isClass _configPath) then {
				_displayName = getText (_configPath >> "displayName");

				if (_displayName != "") then {
					_picture = getText (_configPath >> "picture");
					_tooltip = getText (_configPath >> "descriptionShort");
					_tooltip = [_tooltip, "<br />", ". "] call CBA_fnc_replace;
					_tooltip = [_tooltip, "<br/>", ". "] call CBA_fnc_replace;

					_index = LOADOUTMANAGER_RIGHTLIST lbAdd _displayName;
					LOADOUTMANAGER_RIGHTLIST lbSetPicture [_index, _picture];
					LOADOUTMANAGER_RIGHTLIST lbSetTooltip [_index,_tooltip];
				};
			};
		} forEach _weapons;

		//-- Weapon attachments
		_attachments = _primaryWeaponItems + _handgunItems + _secondaryWeaponItems;
		{
			_item = _x;
			_configPath = configfile >> "CfgWeapons" >> _item;
			if (isClass _configPath) then {
				_displayName = getText (_configPath >> "displayName");

				if (_displayName != "") then {
					_picture = getText (_configPath >> "picture");
					_tooltip = getText (_configPath >> "descriptionShort");
					_tooltip = [_tooltip, "<br />", ". "] call CBA_fnc_replace;
					_tooltip = [_tooltip, "<br/>", ". "] call CBA_fnc_replace;

					_index = LOADOUTMANAGER_RIGHTLIST lbAdd _displayName;
					LOADOUTMANAGER_RIGHTLIST lbSetPicture [_index, _picture];
					LOADOUTMANAGER_RIGHTLIST lbSetTooltip [_index,_tooltip];
				};
			};
		} forEach _attachments;

		//-- Uniform
		_uniformConfigPath = configfile >> "CfgWeapons" >> _uniform;
		if (isClass _uniformConfigPath) then {
			_displayName = getText (_uniformConfigPath >> "displayName");

			if (_displayName != "") then {
				_picture = getText (_uniformConfigPath >> "picture");
				_tooltip = getText (_uniformConfigPath >> "descriptionShort");
				_tooltip = [_tooltip, "<br />", ". "] call CBA_fnc_replace;
				_tooltip = [_tooltip, "<br/>", ". "] call CBA_fnc_replace;

				_index = LOADOUTMANAGER_RIGHTLIST lbAdd _displayName;
				LOADOUTMANAGER_RIGHTLIST lbSetPicture [_index, _picture];
				LOADOUTMANAGER_RIGHTLIST lbSetTooltip [_index,_tooltip];
			};
		};

		//-- Vest
		_vestConfigPath = configfile >> "CfgWeapons" >> _vest;
		if (isClass _vestConfigPath) then {
			_displayName = getText (_vestConfigPath >> "displayName");

			if (_displayName != "") then {
				_picture = getText (_vestConfigPath >> "picture");
				_tooltip = getText (_vestConfigPath >> "descriptionShort");
				_tooltip = [_tooltip, "<br />", ". "] call CBA_fnc_replace;
				_tooltip = [_tooltip, "<br/>", ". "] call CBA_fnc_replace;

				_index = LOADOUTMANAGER_RIGHTLIST lbAdd _displayName;
				LOADOUTMANAGER_RIGHTLIST lbSetPicture [_index, _picture];
				LOADOUTMANAGER_RIGHTLIST lbSetTooltip [_index,_tooltip];
			};
		};

		//-- Headgear
		_headgearConfigPath = configfile >> "CfgWeapons" >> _headgear;
		if (isClass _headgearConfigPath) then {
			_displayName = getText (_headgearConfigPath >> "displayName");

			if (_displayName != "") then {
				_picture = getText (_headgearConfigPath >> "picture");
				_tooltip = getText (_headgearConfigPath >> "descriptionShort");
				_tooltip = [_tooltip, "<br />", ". "] call CBA_fnc_replace;
				_tooltip = [_tooltip, "<br/>", ". "] call CBA_fnc_replace;

				_index = LOADOUTMANAGER_RIGHTLIST lbAdd _displayName;
				LOADOUTMANAGER_RIGHTLIST lbSetPicture [_index, _picture];
				LOADOUTMANAGER_RIGHTLIST lbSetTooltip [_index,_tooltip];
			};
		};

		//-- Goggles
		if (_goggles != "") then {
			_gogglesConfigPath = configfile >> "CfgGlasses" >> _goggles;
			if (isClass _gogglesConfigPath) then {
				_displayName = getText (_gogglesConfigPath >> "displayName");

				if (_displayName != "") then {
					_picture = getText (_gogglesConfigPath >> "picture");
					_tooltip = getText (_gogglesConfigPath >> "descriptionShort");
					_tooltip = [_tooltip, "<br />", ". "] call CBA_fnc_replace;
					_tooltip = [_tooltip, "<br/>", ". "] call CBA_fnc_replace;

					_index = LOADOUTMANAGER_RIGHTLIST lbAdd _displayName;
					LOADOUTMANAGER_RIGHTLIST lbSetPicture [_index, _picture];
					LOADOUTMANAGER_RIGHTLIST lbSetTooltip [_index,_tooltip];
				};
			};
		};

		//-- Backpack
		_backpackConfigPath = configfile >> "CfgVehicles" >> _backpack;
		if (isClass _backpackConfigPath) then {
			_displayName = getText (_backpackConfigPath >> "displayName");

			if (_displayName != "") then {
				_picture = getText (_backpackConfigPath >> "picture");
				_tooltip = getText (_backpackConfigPath >> "descriptionShort");
				_tooltip = [_tooltip, "<br />", ". "] call CBA_fnc_replace;
				_tooltip = [_tooltip, "<br/>", ". "] call CBA_fnc_replace;

				_index = LOADOUTMANAGER_RIGHTLIST lbAdd _displayName;
				LOADOUTMANAGER_RIGHTLIST lbSetPicture [_index, _picture];
				LOADOUTMANAGER_RIGHTLIST lbSetTooltip [_index,_tooltip];
			};
		};

		//-- Items
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

				if (_displayName != "") then {
					_picture = getText (_configPath >> "picture");
					_itemInfo = format ["%1: %2", _displayName, _count];
					_tooltip = getText (_configPath >> "descriptionShort");
					_tooltip = [_tooltip, "<br />", ". "] call CBA_fnc_replace;
					_tooltip = [_tooltip, "<br/>", ". "] call CBA_fnc_replace;

					_index = LOADOUTMANAGER_RIGHTLIST lbAdd _displayName;
					LOADOUTMANAGER_RIGHTLIST lbSetPicture [_index, _picture];
					LOADOUTMANAGER_RIGHTLIST lbSetTooltip [_index,_tooltip];
				};
			};
		} forEach _itemArray;
	};

	case "setLoadOnRespawn": {
		_currentFolder = [_logic,"CurrentFolder"] call CBA_fnc_hashGet;
		_index = lbCurSel LOADOUTMANAGER_LEFTLIST;
		_slotName = LOADOUTMANAGER_LEFTLIST lbText _index;

		_slotData = [_currentFolder,_slotName] call CBA_fnc_hashGet;

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

		LOADOUTMANAGER_LEFTINSTRUCTIONS ctrlSetText "Class will load on respawn";
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
				if (!(_x in _units) && {_x != player} && {alive _x}) then {
					_name = name _x;
					_role = getText (configfile >> "CfgVehicles" >> (typeOf _x) >> "displayName");

					_index = LOADOUTMANAGER_RIGHTLIST lbAdd (format ["%1 (%2)", _name, _role]);
					LOADOUTMANAGER_RIGHTLIST lbSetData [_index,_name];
				};
			};
		} forEach ((units group player) + allPlayers);

		//-- Enable confirm transfer button right list texts
		if ([_data] call CBA_fnc_isHash) then {
			LOADOUTMANAGER_RIGHTTITLE ctrlSetText "Transfer Folder";
			LOADOUTMANAGER_RIGHTINSTRUCTIONS ctrlSetText "Select a unit to transfer the folder to";
		} else {
			LOADOUTMANAGER_RIGHTTITLE ctrlSetText "Transfer Loadout";
			LOADOUTMANAGER_RIGHTINSTRUCTIONS ctrlSetText "Select a unit to transfer the loadout to";
		};

		LOADOUTMANAGER_BLANKBUTTON ctrlShow true;
		LOADOUTMANAGER_BLANKBUTTON ctrlSetText "Confirm Transfer";
		LOADOUTMANAGER_BLANKBUTTON buttonSetAction "[SpyderAddons_loadoutManager,'confirmTransfer'] call SpyderAddons_fnc_loadoutManager";

		if (lbSize LOADOUTMANAGER_RIGHTLIST > 0) then {
			LOADOUTMANAGER_RIGHTLIST lbSetCurSel 0;
		} else {
			LOADOUTMANAGER_RIGHTINSTRUCTIONS ctrlSetText "There are no units to transfer to";
		};
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
		_unit = LOADOUTMANAGER_RIGHTLIST lbData _index;
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
		private ["_loadoutDirectory","_storedData"];
		_arguments params ["_sender","_transferData"];
		_transferData params ["_slotName","_data"];

		//-- Notify player
		if ([_data] call CBA_fnc_isHash) then {
			[format ["%1 has sent you a folder titled %2", _sender, _slotName]] spawn SpyderAddons_fnc_displayNotification;
		} else {
			[format ["%1 has sent you a loadout titled %2", _sender, _slotName]] spawn SpyderAddons_fnc_displayNotification;
		};

		//-- Create Transferred_Data Folder if it doesn't exist
		_loadoutDirectory = profileNamespace getVariable "SpyderAddons_Loadouts";
		_storedData = [_loadoutDirectory,"Transferred_Data"] call CBA_fnc_hashGet;
		if (isNil "_storedData") then {
			[_loadoutDirectory,"Transferred_Data", ([] call CBA_fnc_hashCreate)] call CBA_fnc_hashSet;
			_loadoutDirectory = profileNamespace getVariable "SpyderAddons_Loadouts";
			_storedData = [_loadoutDirectory,"Transferred_Data"] call CBA_fnc_hashGet;
		};

		//-- Store data
		if (_slotName in (_storedData select 1)) then {
			[_storedData,(format ["%1 (%2)", _slotName, time]), _data] call CBA_fnc_hashSet;
		} else {
			[_storedData,_slotName, _data] call CBA_fnc_hashSet;
		};

		if ([MOD(loadoutManager),"CurrentFolder"] call CBA_fnc_hashGet isEqualTo _loadoutDirectory) then {
			[MOD(loadoutManager),"displayFolder", _loadoutDirectory] call MAINCLASS;
		};
	};
};

//-- Return result if any exists
if (!isNil "_result") then {_result} else {nil};