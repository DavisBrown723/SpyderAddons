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
	["_operation", ""],
	["_arguments", []]
];
private ["_result"];

//-- Define control ID's
#define LOADOUTMANAGER_MAINDIALOG "Loadout_Manager"
#define LOADOUTMANAGER_TRANSFERLOADOUT "Transfer_Loadout"
#define LOADOUTMANAGER_RECEIVELOADOUT "Receive_Loadout"
#define LOADOUTMANAGER_CLASSLIST 7217
#define LOADOUTMANAGER_GEARTITLE 72123
#define LOADOUTMANAGER_EDIT 7215
#define LOADOUTMANAGER_GEARTITLE 72123
#define LOADOUTMANAGER_GEARLIST 72124
#define LOADOUTMANAGER_UNITLIST 7199
#define LOADOUTMANAGER_TEXTBOX 7185
#define LOADOUTMANAGER_MAINCONTROLS allControls findDisplay 721

switch (_operation) do {

	case "init": {
		_syncedUnits = _arguments;

		{
			if (typeName _x == "OBJECT") then {
				_x addAction ["Access Loadout Manager", {["open"] call SpyderAddons_fnc_loadoutManager}];
			};
		} forEach _syncedUnits;
	};
	
	case "open": {
		CreateDialog LOADOUTMANAGER_MAINDIALOG;
		["onLoad"] call SpyderAddons_fnc_loadoutManager;
	};

	case "onLoad": {
		ctrlShow [LOADOUTMANAGER_GEARTITLE, false];

		["buildClassList"] call SpyderAddons_fnc_loadoutManager;

		(findDisplay 721 displayCtrl LOADOUTMANAGER_CLASSLIST)  ctrlAddEventHandler ["LBSelChanged","
			_slotNum = format ['%1', [lbCurSel 7217] select 0];
			_loadout = profileNamespace getVariable format ['LoadoutManagerLoadout_%1',_slotNum];

			if (!isNil '_loadout') then {
				_slotName = _loadout select 0;
				ctrlSetText [7215, _slotName];
			} else {
				_slotNum = format ['Loadout %1', [lbCurSel 7217] select 0];
				ctrlSetText [7215, _slotNum];
			};

			if (!isNil '_loadout') then {
				['displayGear', [_loadout]] call SpyderAddons_fnc_loadoutManager;
				{ctrlEnable [_x, true]} forEach [7218, 7219, 72121, 72125, 72122];
			} else {
				['displayGear'] call SpyderAddons_fnc_loadoutManager;
				{ctrlEnable [_x, false]} forEach [7218, 7219, 72121, 72125, 72122];
			};
		"];


		lbSetCurSel [LOADOUTMANAGER_CLASSLIST,0];
	};

	case "buildClassList": {

		//-- Flush list
		lbClear LOADOUTMANAGER_CLASSLIST;

		//-- Build new list
		for "_i" from 0 to 15 do {
			_loadout = profileNamespace getVariable format ["LoadoutManagerLoadout_%1",_i];
			if(!isNil {_loadout select 0}) then {
				lbAdd [LOADOUTMANAGER_CLASSLIST, _loadout select 0];
			} else {
				_slotName = format ["Loadout %1", _i];
				lbAdd [LOADOUTMANAGER_CLASSLIST, _slotName];
			};
		};
	};
	
	case "loadClass": {
		private ["_unit","_loadout"];

		//-- Retrieve loadout if none was passed
		if (count _arguments == 0) then {
			_slot = lbCurSel LOADOUTMANAGER_CLASSLIST;
			_loadout = profileNameSpace getVariable format ["LoadoutManagerLoadout_%1",_slot];
		} else {
			_unit = _arguments select 0;
			_loadout = _arguments select 1;
		};

		if (isNil "_unit") then {_unit = player};

		//-- Strip the unit down
		RemoveAllWeapons _unit;
		{_unit removeMagazine _x} foreach (magazines _unit);
		removeUniform _unit;
		removeVest _unit;
		removeBackpack _unit;
		removeGoggles _unit;
		removeHeadGear _unit;
		removeAllAssignedItems _unit;

		//-- Define Gear
		_uniform = _loadout select 1;
		_vest = _loadout select 2;
		_backpack = _loadout select 3;
		_backpackitems = _loadout select 4;
		_headgear = _loadout select 5;
		_goggles = _loadout select 6;
		_uniformitems = _loadout select 7;
		_vestitems = _loadout select 8;
		_weapons = _loadout select 9;
		_primaryweaponitems = _loadout select 10;
		_secondaryweaponitems = _loadout select 11;
		_assigneditems = _loadout select 12;
		_primaryWeaponMagazines = _loadout select 13;

		//-- Add Gear
		_unit addUniform _uniform;
		_unit addVest _vest;
		_unit addBackpack _backpack;
		{_unit addItemToBackpack _x} forEach _backpackitems;
		_unit addHeadgear _headgear;
		_unit addGoggles _goggles;
		{_unit addItemToUniform _x} forEach _uniformitems;
		{_unit addItemToVest _x} forEach _vestitems;
		{_unit addWeapon _x} forEach _weapons;
		{_unit addPrimaryWeaponItem _x} forEach _primaryweaponitems;
		{_unit addSecondaryWeaponItem _x} forEach _secondaryweaponitems;
		{_unit linkItem _x} forEach _assigneditems; 
		{_unit addMagazine _x} forEach _primaryWeaponMagazines;
	};
	
	case "saveClass": {
		//-- Dialog data
		_slot = lbCurSel LOADOUTMANAGER_CLASSLIST;
		_name = ctrlText LOADOUTMANAGER_EDIT;

		//-- Save gear
		_uniform = uniform player;
		_vest = vest player;
		_backpack = backpack player;
		_backpackitems = backpackItems player;
		_headgear = headgear player;
		_goggles = goggles player;
		_uniformitems = uniformItems player;
		_vestitems = vestItems player;
		_weapons = weapons player;
		_primaryweaponitems = primaryWeaponItems player;
		_secondaryweaponitems = secondaryWeaponItems player;
		_assigneditems = assignedItems player;
		_primaryWeaponMagazines = primaryWeaponMagazine player;

		//-- Save loadout
		profileNameSpace setVariable [format ["LoadoutManagerLoadout_%1", _slot],[_name, _uniform,_vest, _backpack, _backpackitems, _headgear, _goggles,_uniformitems, _vestitems, _weapons, _primaryweaponitems, _secondaryweaponitems, _assigneditems, _primaryWeaponMagazines]];

		saveProfileNamespace;

		//-- Build new list
		["buildClassList"] call SpyderAddons_fnc_loadoutManager;

		lbSetCurSel [LOADOUTMANAGER_CLASSLIST, _slot];
	};

	case "deleteClass": {
		//-- Get class
		_slot = lbCurSel LOADOUTMANAGER_CLASSLIST;

		//-- Save loadout
		profileNameSpace setVariable [format ["LoadoutManagerLoadout_%1", _slot], nil];

		saveProfileNamespace;

		//-- Build new list
		["buildClassList"] call SpyderAddons_fnc_loadoutManager;

		lbSetCurSel [LOADOUTMANAGER_CLASSLIST, _slot];
	};
	
	case "renameClass": {
		//-- Dialogue data
		_slot = lbCurSel LOADOUTMANAGER_CLASSLIST;

		//-- Get loadout
		_loadout = profileNameSpace getVariable format ["LoadoutManagerLoadout_%1",_slot];	
		_loadout params ["_name","_uniform","_vest","_backpack","_backpackitems","_headgear","_goggles","_uniformitems","_vestitems","_weapons","_primaryweaponitems","_secondaryweaponitems","_assigneditems", "_primaryWeaponMagazines"];
		_name = ctrlText LOADOUTMANAGER_EDIT;

		//-- Save loadout with new name
		profileNameSpace setVariable[format["LoadoutManagerLoadout_%1", _slot],[_name, _uniform,_vest, _backpack, _backpackitems, _headgear, _goggles,_uniformitems, _vestitems, _weapons, _primaryweaponitems, _secondaryweaponitems, _assigneditems, _primaryWeaponMagazines]];

		saveProfileNamespace;

		//-- Build new list
		["buildClassList"] call SpyderAddons_fnc_loadoutManager;

		lbSetCurSel [LOADOUTMANAGER_CLASSLIST, _slot];
	};
	
	case "displayGear": {
		ctrlShow [LOADOUTMANAGER_GEARTITLE, true];
		lbClear LOADOUTMANAGER_GEARLIST;

		_arguments params [["_loadout", nil]];

		if (isNil "_loadout") exitWith {
			lbClear LOADOUTMANAGER_GEARLIST;
			ctrlShow [LOADOUTMANAGER_GEARTITLE, false];
		};

		//-- Define Gear
		_uniform = _loadout select 1;
		_vest = _loadout select 2;
		_backpack = _loadout select 3;
		_backpackitems = _loadout select 4;
		_headgear = _loadout select 5;
		_goggles = _loadout select 6;
		_uniformitems = _loadout select 7;
		_vestitems = _loadout select 8;
		_weapons = _loadout select 9;
		_primaryweaponitems = _loadout select 10;
		_secondaryweaponitems = _loadout select 11;
		_assigneditems = _loadout select 12;
		_primaryWeaponMagazines = _loadout select 13;

		private ["_index"];
		_index = 0;

		//-- Weapons
		{
			_configPath = configfile >> "CfgWeapons" >> _x;
			if (isClass _configPath) then {
				_displayName = getText (_configPath >> "displayName");
				_picture = getText (_configPath >> "picture");

				lbAdd [LOADOUTMANAGER_GEARLIST, _displayName];
				lbSetPicture [LOADOUTMANAGER_GEARLIST, _index, _picture];
				_index = _index + 1;
			};
		} forEach _weapons;

		//-- Weapon attachments
		_attachments = _primaryweaponitems + _secondaryweaponitems;
		{
			_item = _x;
			_configPath = configfile >> "CfgWeapons" >> _item;
			if (isClass _configPath) then {
				_displayName = getText (_configPath >> "displayName");
				_picture = getText (_configPath >> "picture");

				lbAdd [LOADOUTMANAGER_GEARLIST, _displayName];
				lbSetPicture [LOADOUTMANAGER_GEARLIST, _index, _picture];
				_index = _index + 1;
			};
		} forEach _attachments;

		//-- Uniform
		_uniformConfigPath = configfile >> "CfgWeapons" >> _uniform;
		if (isClass _uniformConfigPath) then {
			_displayName = getText (_uniformConfigPath >> "displayName");
			_picture = getText (_uniformConfigPath >> "picture");

			lbAdd [LOADOUTMANAGER_GEARLIST, _displayName];
			lbSetPicture [LOADOUTMANAGER_GEARLIST, _index, _picture];
			_index = _index + 1;
		};

		//-- Vest
		_vestConfigPath = configfile >> "CfgWeapons" >> _vest;
		if (isClass _vestConfigPath) then {
			_displayName = getText (_vestConfigPath >> "displayName");
			_picture = getText (_vestConfigPath >> "picture");

			lbAdd [LOADOUTMANAGER_GEARLIST, _displayName];
			lbSetPicture [LOADOUTMANAGER_GEARLIST, _index, _picture];
			_index = _index + 1;
		};

		//-- Headgear
		_headgearConfigPath = configfile >> "CfgWeapons" >> _headgear;
		if (isClass _headgearConfigPath) then {
			_displayName = getText (_headgearConfigPath >> "displayName");
			_picture = getText (_headgearConfigPath >> "picture");

			lbAdd [LOADOUTMANAGER_GEARLIST, _displayName];
			lbSetPicture [LOADOUTMANAGER_GEARLIST, _index, _picture];
			_index = _index + 1;
		};

		//-- Goggles
		if (_goggles != "") then {
			_gogglesConfigPath = configfile >> "CfgGlasses" >> _goggles;
			if (isClass _gogglesConfigPath) then {
				_displayName = getText (_gogglesConfigPath >> "displayName");
				_picture = getText (_gogglesConfigPath >> "picture");

				lbAdd [LOADOUTMANAGER_GEARLIST, _displayName];
				lbSetPicture [LOADOUTMANAGER_GEARLIST, _index, _picture];
				_index = _index + 1;
			};
		};

		//-- Backpack
		_backpackConfigPath = configfile >> "CfgVehicles" >> _backpack;
		if (isClass _backpackConfigPath) then {
			_displayName = getText (_backpackConfigPath >> "displayName");
			_picture = getText (_backpackConfigPath >> "picture");

			lbAdd [LOADOUTMANAGER_GEARLIST, _displayName];
			lbSetPicture [LOADOUTMANAGER_GEARLIST, _index, _picture];
			_index = _index + 1;
		};

		//-- Backpack items
		_itemArray = _uniformitems + _vestitems + _backpackitems + _primaryWeaponMagazines + _assigneditems;
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
				_picture = getText (_configPath >> "picture");
				_itemInfo = format ["%1: %2", _displayName, _count];

				lbAdd [LOADOUTMANAGER_GEARLIST, _itemInfo];
				lbSetPicture [LOADOUTMANAGER_GEARLIST, _index, _picture];
				_index = _index + 1;

			};
		} forEach _itemArray;
	};

	case "loadOnRespawn": {
		//-- Dialogue data
		_slot = lbCurSel LOADOUTMANAGER_CLASSLIST;

		//-- Get selected loadout
		_loadout = profileNameSpace getVariable format ["LoadoutManagerLoadout_%1",_slot];
		_loadout params ["_name","_uniform","_vest","_backpack","_backpackitems","_headgear","_goggles","_uniformitems","_vestitems","_weapons","_primaryweaponitems","_secondaryweaponitems","_assigneditems", "_primaryWeaponMagazines"];

		//-- Save loadout to onRespawn variable
		profileNameSpace setVariable ["LoadoutManager_onRespawn", [_name,_uniform,_vest,_backpack,_backpackitems,_headgear,_goggles,_uniformitems,_vestitems,_weapons,_primaryweaponitems,_secondaryweaponitems,_assigneditems,_primaryWeaponMagazines]];
		saveProfileNamespace;

		//-- Remove previous eventhandler if one exists
		if (!isNil {player getVariable "LoadoutManager_onSpawnLoadoutIndex"}) then {
			_index = player getVariable "LoadoutManager_onSpawnLoadoutIndex";
			player removeEventHandler ["MPRespawn", _index];
			player setVariable ["LoadoutManager_onSpawnLoadoutIndex", nil];
		};

		_index = player addMPEventHandler ["MPRespawn", {["onSpawn",_this] call SpyderAddons_fnc_loadoutManager}];
		player setVariable ["LoadoutManager_onSpawnLoadoutIndex", _index];
	};
	
	case "onSpawn": {
		_loadout = profileNameSpace getVariable "LoadoutManager_onRespawn";

		//-- Define Gear
		_uniform = _loadout select 1;
		_vest = _loadout select 2;
		_backpack = _loadout select 3;
		_backpackitems = _loadout select 4;
		_headgear = _loadout select 5;
		_goggles = _loadout select 6;
		_uniformitems = _loadout select 7;
		_vestitems = _loadout select 8;
		_weapons = _loadout select 9;
		_primaryweaponitems = _loadout select 10;
		_secondaryweaponitems = _loadout select 11;
		_assigneditems = _loadout select 12;
		_primaryWeaponMagazines = _loadout select 13;

		//-- Strip the unit down

		RemoveAllWeapons player;

		{_unit removeMagazine _x} foreach (magazines player);

		removeUniform player;

		removeVest player;

		removeBackpack player;

		removeGoggles player;

		removeHeadGear player;

		removeAllAssignedItems player;

		//-- Add Gear
		player addUniform _uniform;
		player addVest _vest;
		player addBackpack _backpack;
		{player addItemToBackpack _x} forEach _backpackitems;
		player addHeadgear _headgear;
		player addGoggles _goggles;
		{player addItemToUniform _x} forEach _uniformitems;
		{player addItemToVest _x} forEach _vestitems;
		{player addWeapon _x} forEach _weapons;
		{player addPrimaryWeaponItem _x} forEach _primaryweaponitems;
		{player addSecondaryWeaponItem _x} forEach _secondaryweaponitems;
		{player linkItem _x} forEach _assigneditems;
		{player addMagazine _x} forEach _primaryWeaponMagazines;
	};
	
	case "openArsenal": {
		private ["_closeButton"];
		disableSerialization;

		//-- Close Loadout Organizer
		closeDialog 0;

		//-- Open Arsenal
		["Open",true] spawn BIS_fnc_arsenal;
		waitUntil {!isNull findDisplay -1};
		_closeButton = (findDisplay -1) displayCtrl 44448;
		_closeButton buttonSetAction "['open'] call SpyderAddons_fnc_loadoutManager";
	};
	
	case "sendLoadout": {
		_loadout = LoadoutManager_TransferLoadout;

		_playerSlot = lbCurSel LOADOUTMANAGER_UNITLIST;
		_playerName = lbData [LOADOUTMANAGER_UNITLIST, _playerSlot];
		_squad = [];
		{
			if (!isPlayer _x) then {_squad pushBack _x};
		} forEach units group player;

		{
			_unit = _x;

			if (name _unit == _playerName) exitWith {
				if (isPlayer _unit) then {
					["receiveLoadout",[name player,_loadout], "SpyderAddons_fnc_loadoutManager", owner _unit] call BIS_fnc_MP;
				} else {
					["loadClass", [_unit,_loadout]] call SpyderAddons_fnc_loadoutManager;
				};
			};
		} forEach allPlayers + _squad;
	};
	
	case "receiveLoadout": {
		_arguments params ["_sender","_loadout"];

		//if !(isNull findDisplay 718) exitWith {}; //-- Possibly breaking function
		hint "You received a loadout, tell Spyder the god about this momentous achievement";

		//-- Exit if player is not in loadout organizer interface
		if (isNull findDisplay 721) exitWith {
			_message = format ["You have received a loadout from %1, you must have the Loadout Organizer open when receiving a loadout in order to save it", _sender];
			hint _message;
		};

		LoadoutManager_TransferLoadout = _loadout;

		//-- Create dialog
		CreateDialog LOADOUTMANAGER_RECEIVELOADOUT;
		_message = format ["You have received a loadout from %1, would you like to accept the transfer and load the class?", _sender];

		(findDisplay 718 displayCtrl 7185) ctrlSetText _message;
	};
	
	case "openTransferMenu": {
		disableSerialization;

		_slotNum = format ['%1', [lbCurSel 7217] select 0];
		_loadout = profileNamespace getVariable format ['LoadoutManagerLoadout_%1',_slotNum];
		LoadoutManager_TransferLoadout = _loadout;

		{
			ctrlShow [_x, false];
		} forEach LOADOUTMANAGER_MAINCONTROLS;

		CreateDialog LOADOUTMANAGER_TRANSFERLOADOUT;

		_localPlayerName = name player;
		_playerSide = playerSide;
		_squad = [];
		{
			if (!isPlayer _x) then {_squad pushBack _x};
		} forEach units group player;

		_index = 0;
		{
			_unit = _x;
			_name = name _unit;

			if (side _unit == _playerSide) then {
				if (_name != _localPlayerName) then {
					lbAdd [LOADOUTMANAGER_UNITLIST, _name];
					lbSetData [LOADOUTMANAGER_UNITLIST, _index, _name];
					_index = _index + 1;
				};
			};
		} forEach allPlayers + _squad;
	};
	

};

//-- Return result if any exists
if (!isNil "_result") then {_result} else {nil};