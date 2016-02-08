#include <\x\spyderaddons\addons\civ_interact\script_component.hpp>
SCRIPT(inventoryHandler);

/* ----------------------------------------------------------------------------
Function: SpyderAddons_fnc_inventoryHandler

Description:
Main handler for inventory management

Parameters:
String - Operation
Array - Arguments

Returns:
Any - Result of the operation

Examples:
(begin example)
(end)

See Also:
- nil

Author: SpyderBlack723

Peer Reviewed:
nil
---------------------------------------------------------------------------- */

disableSerialization;
private ["_result"];
params [
	["_logic", objNull],
	["_operation", ""],
	["_arguments", []]
];

//-- Define function shortcuts
#define MAINCLASS 			SpyderAddons_fnc_inventoryHandler

//-- Define control ID's
#define CIVINTERACT_DISPLAY		(findDisplay 923)

#define INVENTORY_BACKGROUND		(CIVINTERACT_DISPLAY displayCtrl 9240)
#define INVENTORY_HEADER			(CIVINTERACT_DISPLAY displayCtrl 9241)
#define INVENTORY_SEARCHBUTTON		(CIVINTERACT_DISPLAY displayCtrl 9242)
#define INVENTORY_GEARLIST		(CIVINTERACT_DISPLAY displayCtrl 9244)

#define INVENTORY_PROGRESSBARTITLE	(CIVINTERACT_DISPLAY displayCtrl 9248)
#define INVENTORY_PROGRESSBAR		(CIVINTERACT_DISPLAY displayCtrl 9249)
#define INVENTORY_PROGRESSBAR2		(CIVINTERACT_DISPLAY displayCtrl 8563)

#define INVENTORY_BUTTONONE		(CIVINTERACT_DISPLAY displayCtrl 9242)
#define INVENTORY_BUTTONTWO		(CIVINTERACT_DISPLAY displayCtrl 9245)
#define INVENTORY_BUTTONTHREE		(CIVINTERACT_DISPLAY displayCtrl 9246)

switch (_operation) do {

	case "create": {
		_result = [] call ALiVE_fnc_hashCreate;
	};

	//-- Create logic
	case "init": {
		if (isNil QMOD(inventoryHandler)) then {

		};
	};

	case "mainMenuOpened": {
		{_x ctrlShow false} forEach ([INVENTORY_BACKGROUND, INVENTORY_HEADER, INVENTORY_BUTTONTWO, INVENTORY_BUTTONTHREE]);
	};

	case "mainMenuClosed": {
		[_logic,"WeaponHolder", nil] call ALiVE_fnc_hashSet;
	};

	case "toggleSearchMenu": {
		private ["_enable"];
		if (ctrlVisible 9240) then {_enable = false} else {_enable = true};

		if (_enable) then {
			[_logic,"openMenu"] call MAINCLASS;
		} else {
			[_logic,"closeMenu"] call MAINCLASS;
		};
	};

	case "openMenu": {
		//-- Set progress bar info
		INVENTORY_PROGRESSBARTITLE ctrlSetText "Opening Inventory";
		_bar = [MOD(civInteractHandler),"ProgressBar"] call ALiVE_fnc_hashGet;
		[_bar,.55] spawn SpyderAddons_fnc_progressAnimateAndExecute;

		//-- Set inventory controls to starting position
		_controls = [INVENTORY_BACKGROUND,INVENTORY_HEADER];
		{
			[_x, [-.37]] call SpyderAddons_fnc_ctrlMoveRelative;
		} forEach _controls;

		//-- Show inventory controls
		{
			_x ctrlShow true;
			[_x, [.37],0.55] call SpyderAddons_fnc_ctrlMoveRelative;
		} forEach _controls;

		//-- Glide search button into position
		INVENTORY_SEARCHBUTTON ctrlSetText "Close";
		INVENTORY_SEARCHBUTTON ctrlEnable false;
		[INVENTORY_SEARCHBUTTON, [.15,0,0.225], 0.55] call SpyderAddons_fnc_ctrlMoveRelative;

		//-- Enable search button after animation complete
		[INVENTORY_SEARCHBUTTON,INVENTORY_PROGRESSBARTITLE] spawn {
			disableSerialization;
			sleep .55;
			(_this select 0) ctrlEnable true;
			(_this select 1) ctrlSetText "";

			[SpyderAddons_CivInteractHandler,"displayGearContainers"] call MAINCLASS;
		};
	};

	case "closeMenu": {
		//-- Clear list
		lbClear INVENTORY_GEARLIST;

		//-- Hide buttons
		INVENTORY_BUTTONTWO ctrlShow false;
		INVENTORY_BUTTONTHREE ctrlShow false;

		//-- Modify progress bar
		INVENTORY_PROGRESSBARTITLE ctrlSetText "Closing Inventory";
		_bar = [MOD(civInteractHandler),"ProgressBar"] call ALiVE_fnc_hashGet;
		[_bar,.55] spawn SpyderAddons_fnc_progressAnimateAndExecute;

		//-- Move inventory controls
		_controls = [INVENTORY_BACKGROUND,INVENTORY_HEADER];
		[_controls, [-.37], 0.55] call SpyderAddons_fnc_ctrlMoveRelative;
		

		//-- Hide controls once hidden behind main dialog
		_controls spawn {
			disableSerialization;
			sleep 0.56;
			{
				[_x, [.37]] call SpyderAddons_fnc_ctrlMoveRelative;
				_x ctrlShow false;
			} forEach _this;
		};

		//-- Glide search button into position
		INVENTORY_SEARCHBUTTON ctrlSetText "Search";
		INVENTORY_SEARCHBUTTON buttonSetAction "[SpyderAddons_civInteractHandler,'toggleSearchMenu'] call SpyderAddons_fnc_inventoryHandler";
		INVENTORY_SEARCHBUTTON ctrlEnable false;
		[INVENTORY_SEARCHBUTTON, [-.15,0,-0.225], 0.55] call SpyderAddons_fnc_ctrlMoveRelative;

		//-- Enable search button after animation complete
		[INVENTORY_SEARCHBUTTON,INVENTORY_PROGRESSBARTITLE] spawn {
			disableSerialization;
			sleep .55;
			(_this select 0) ctrlEnable true;
			(_this select 1) ctrlSetText "";
		};
	};

	case "onGearClick": {
		_arguments params ["_control","_index"];
		_civ = [_logic,"Civ"] call ALiVE_fnc_hashGet;
		_item = _control lbData _index;

		if (_item in [backpack _civ, vest _civ, uniform _civ]) then {
			INVENTORY_BUTTONONE ctrlShow true;
			INVENTORY_BUTTONONE ctrlSetText "Confiscate";
			INVENTORY_BUTTONONE buttonSetAction "[SpyderAddons_civInteractHandler,'confiscate'] call SpyderAddons_fnc_inventoryHandler";

			INVENTORY_BUTTONTWO ctrlShow true;
			INVENTORY_BUTTONTWO ctrlSetText "View Contents";
			INVENTORY_BUTTONTWO buttonSetAction "[SpyderAddons_civInteractHandler,'openGearContainer'] call SpyderAddons_fnc_inventoryHandler";

			INVENTORY_BUTTONTHREE ctrlShow true;
			INVENTORY_BUTTONTHREE ctrlSetText "Close";
			INVENTORY_BUTTONTHREE buttonSetAction "[SpyderAddons_civInteractHandler,'toggleSearchMenu'] call SpyderAddons_fnc_inventoryHandler";
		} else {
			INVENTORY_BUTTONONE ctrlShow true;
			INVENTORY_BUTTONONE ctrlSetText "Confiscate";
			INVENTORY_BUTTONONE buttonSetAction "[SpyderAddons_civInteractHandler,'confiscate'] call SpyderAddons_fnc_inventoryHandler";

			INVENTORY_BUTTONTWO ctrlShow true;
			INVENTORY_BUTTONTWO ctrlSetText "Close";
			INVENTORY_BUTTONTWO buttonSetAction "[SpyderAddons_civInteractHandler,'toggleSearchMenu'] call SpyderAddons_fnc_inventoryHandler";

			INVENTORY_BUTTONTHREE ctrlShow false;
		};
	};

	case "reorderButtons": {
		if (lbSize INVENTORY_GEARLIST > 0) then {
			_index = lbCurSel INVENTORY_GEARLIST;

			if (_index != -1) then {
				INVENTORY_GEARLIST lbSetCurSel _index;
			} else {
				INVENTORY_GEARLIST lbSetCurSel 0;
			};
		} else {
			_gearmode = [_logic,"GearMode"] call ALiVE_fnc_hashGet;

			if (_gearmode == "Containers") then {
				INVENTORY_BUTTONONE ctrlShow true;
				INVENTORY_BUTTONONE ctrlSetText "Close";
				INVENTORY_BUTTONONE buttonSetAction "[SpyderAddons_civInteractHandler,'toggleSearchMenu'] call SpyderAddons_fnc_inventoryHandler";

				INVENTORY_BUTTONTWO ctrlShow false;
				INVENTORY_BUTTONTHREE ctrlShow false;
			} else {
				INVENTORY_BUTTONONE ctrlShow true;
				INVENTORY_BUTTONONE ctrlSetText "Close Contents";
				INVENTORY_BUTTONONE buttonSetAction "[SpyderAddons_civInteractHandler,'displayGearContainers'] call SpyderAddons_fnc_inventoryHandler";

				INVENTORY_BUTTONTWO ctrlShow true;
				INVENTORY_BUTTONTWO ctrlSetText "Close";
				INVENTORY_BUTTONTWO buttonSetAction "[SpyderAddons_civInteractHandler,'toggleSearchMenu'] call SpyderAddons_fnc_inventoryHandler";

				INVENTORY_BUTTONTHREE ctrlShow false;
			};
		};
	};

	case "displayGearContainers": {
		private ["_configPath"];
		_civ = [_logic, "Civ"] call ALiVE_fnc_hashGet;

		lbClear INVENTORY_GEARLIST;

		//-- Add gear containers and assigned items to list
		{
			if (_x != "") then {
				//-- Get config path
				_configPath = nil;
				_configPath = configfile >> "CfgWeapons" >> _x;
				if !(isClass _configPath) then {_configPath = configfile >> "CfgMagazines" >> _x};
				if !(isClass _configPath) then {_configPath = configfile >> "CfgVehicles" >> _x};
				if !(isClass _configPath) then {_configPath = configfile >> "CfgGlasses" >> _x};

				//-- Get item info
				if (isClass _configPath) then {
					_itemName = getText (_configPath >> "displayName");
					_itemPic = getText (_configPath >> "picture");

					_index = INVENTORY_GEARLIST lbAdd _itemName;
					INVENTORY_GEARLIST lbSetPicture [_index, _itemPic];
					INVENTORY_GEARLIST lbSetData [_index, (configName _configPath)];
				};
			};
		} forEach ((assignedItems _civ) + [headgear _civ, goggles _civ, uniform _civ, vest _civ, backpack _civ]);

		//-- Set gear mode
		[_logic,"GearMode", "Containers"] call ALiVE_fnc_hashSet;

		//-- Add EH to list
		INVENTORY_GEARLIST ctrlAddEventHandler ["LBSelChanged",{[SpyderAddons_civInteractHandler,"onGearClick", _this] call SpyderAddons_fnc_inventoryHandler}];

		//-- Reorder buttons
		[_logic,"reorderButtons"] call MAINCLASS;
	};

	case "openGearContainer": {
		_civ = [_logic, "Civ"] call ALiVE_fnc_hashGet;
		_item = INVENTORY_GEARLIST lbData (lbCurSel INVENTORY_GEARLIST);

		if (_item == backpack _civ) exitWith {
			[_logic,"GearMode", "Backpack"] call ALiVE_fnc_hashSet;
			[_logic,"displayContainerItems", backpackItems _civ] call MAINCLASS;
		};

		if (_item == vest _civ) exitWith {
			[_logic,"GearMode", "Vest"] call ALiVE_fnc_hashSet;
			[_logic,"displayContainerItems", vestItems _civ] call MAINCLASS;
		};

		if (_item == uniform _civ) exitWith {
			[_logic,"GearMode", "Uniform"] call ALiVE_fnc_hashSet;
			[_logic,"displayContainerItems", uniformItems _civ] call MAINCLASS;
		};
	};

	case "displayContainerItems": {
		private ["_configPath"];
		_items = _arguments;

		lbClear INVENTORY_GEARLIST;

		//-- Display items in list
		{
			//-- Get config path
			_configPath = nil;
			_configPath = configfile >> "CfgWeapons" >> _x;
			if !(isClass _configPath) then {_configPath = configfile >> "CfgMagazines" >> _x};
			if !(isClass _configPath) then {_configPath = configfile >> "CfgVehicles" >> _x};
			if !(isClass _configPath) then {_configPath = configfile >> "CfgGlasses" >> _x};

			//-- Get item info
			if (isClass _configPath) then {
				_itemName = getText (_configPath >> "displayName");
				_itemPic = getText (_configPath >> "picture");

				if (_itemPic != "") then {
					_index = INVENTORY_GEARLIST lbAdd _itemName;
					INVENTORY_GEARLIST lbSetPicture [_index, _itemPic];
					INVENTORY_GEARLIST lbSetData [_index, (configName _configPath)];
				};
			};	
		} forEach _arguments;

		//-- Reorder buttons
		[_logic,"reorderButtons"] call MAINCLASS;
	};

	case "addToInventory": {
		_arguments params ["_receiver","_item"];
		_result = false;

		if (_receiver canAddItemToBackpack _item) then {
			player addItemToBackpack _item;
			_result = true;
		} else {
			if (_receiver canAddItemToVest _item) then {
				player addItemToVest _item;
				_result = true;
			} else {
				if (_receiver canAddItemToUniform _item) then {
					player addItemToUniform _item;
					_result = true;
				};
			};
		};
	};

	case "refreshCurrentContainer": {
		_gearMode = [_logic,"GearMode"] call ALiVE_fnc_hashGet;
		_civ = [_logic,"Civ"] call ALiVE_fnc_hashGet;

		switch (_gearMode) do {
			case "Backpack": {
				[_logic,"displayContainerItems", backpackItems _civ] call MAINCLASS;
			};
			case "Vest": {
				[_logic,"displayContainerItems", vestItems _civ] call MAINCLASS;
			};
			case "Uniform": {
				[_logic,"displayContainerItems", uniformItems _civ] call MAINCLASS;
			};
			Default {
				[_logic,"displayGearContainers"] call MAINCLASS;
			};
		};
	};

	case "confiscate": {
		_index = lbCurSel INVENTORY_GEARLIST;
		_item = INVENTORY_GEARLIST lbData _index;
		_civ = [_logic, "Civ"] call ALiVE_fnc_hashGet;

		switch true do {
			//-- Item is the civ's backpack
			case (_item == backpack _civ): {
				if !([nil,"addToInventory", [player,_item]] call MAINCLASS) then {
					[nil,"createItemOnGround", [backpack _civ, getPos _civ, backpackItems _civ]] call MAINCLASS;
				};

				removeBackpackGlobal _civ;
			};

			//-- Item is the civ's vest
			case (_item == vest _civ): {
				if !([nil,"addToInventory", [player,_item]] call MAINCLASS) then {
					[nil,"createItemOnGround", [vest _civ, getPos _civ, vestItems _civ]] call MAINCLASS;
				};

				removeVest _civ;
			};

			//-- Item is the civ's uniform
			case (_item == uniform _civ): {
				if !([nil,"addToInventory", [player,_item]] call MAINCLASS) then {
					[_logic,"createItemOnGround", [uniform _civ, getPosATL _civ, uniformItems _civ]] call MAINCLASS;
				};

				removeUniform _civ;
			};

			//-- Item is the civ's headgear
			case (_item == headgear _civ): {
				if !([nil,"addToInventory", [player,_item]] call MAINCLASS) then {
					[_logic,"createItemOnGround", [headgear _civ, getPosATL _civ]] call MAINCLASS;
				};

				removeHeadgear _civ;
			};

			//-- Item is the civ's gogles
			case (_item == goggles _civ): {
				if !([nil,"addToInventory", [player,_item]] call MAINCLASS) then {
					[_logic,"createItemOnGround", [goggles _civ, getPosATL _civ]] call MAINCLASS;
				};

				removeGoggles _civ;
			};

			//-- Item is not an asthetic
			default {
				//-- Add item to backpack
				if (player canAddItemToBackpack _item) exitWith {
					player addItemToBackpack _item;
					_civ removeWeaponGlobal _item;_civ removeMagazineGlobal _item;_civ removeItem _item;
				};

				//-- Add item to vest
				if (player canAddItemToVest _item) exitWith {
					player addItemToVest _item;
					_civ removeWeaponGlobal _item;_civ removeMagazineGlobal _item;_civ removeItem _item;
				};

				//-- Add item to uniform
				if (player canAddItemToUniform _item) exitWith {
					player addItemToUniform _item;
					_civ removeWeaponGlobal _item;_civ removeMagazineGlobal _item;_civ removeItem _item;
				};

				//-- Item could not fit in player's gear
				_civ removeWeaponGlobal _item;_civ removeMagazineGlobal _item;_civ removeItem _item;
			};
		};

		[_logic,"refreshCurrentContainer"] call MAINCLASS;
	};

	case "createItemOnGround": {
		private ["_weaponholder"];
		_arguments params ["_item","_pos",["_items",[]]];

		//-- Store item in a weaponholder
		if (isNil {[_logic,"WeaponHolder"] call ALiVE_fnc_hashGet}) then {
			_weaponholder = "GroundWeaponHolder" createVehicle _pos;
			_weaponholder setPosATL _pos;
			[_logic,"WeaponHolder", _weaponholder] call ALiVE_fnc_hashSet;
		} else {
			_weaponholder = [_logic,"WeaponHolder"] call ALiVE_fnc_hashGet;
		};

		//-- Manipulate container using maybe (find) and everyContainer commands
		_weaponholder addItemCargoGlobal [_item, 1];

		//-- Add items to container
		{
			if (_item == (_x select 0)) exitWith {
				_container = _x select 1;
				{_container removeItem _x} forEach (items _container);
				{_container addItemCargoGlobal [_x,1]} forEach _items;
			};
		} forEach (everyContainer _weaponholder);
	};

};

//-- Return result if any exists
if (!isNil "_result") then {_result} else {nil};