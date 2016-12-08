#include <\x\spyderaddons\addons\sup_loadout\script_component.hpp>
SCRIPT(loadout);

/* ----------------------------------------------------------------------------
Function: SpyderAddons_fnc_loadout

Description:
Main handler for loadout list entries

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
#define MAINCLASS   FUNC(loadout)

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

        [_logic,"dataType", "loadout"] call FUNC(hashSet);

        [_logic,"loadout", []] call FUNC(hashSet);

    };

    method( "loadout" ) {

        if (typename _args == "ARRAY") then {
            [_logic,_operation,_args] call FUNC(hashSet);
            _result = _args;
        } else {
            _result = [_logic,_operation] call FUNC(hashGet);
        };

    };

    method( "getDetailDataSource" ) {

        private ["_itemClass","_itemCount","_item","_itemCount","_itemConfig","_itemDisplayName","_itemPicture","_tooltip"];

        _result = [];

        private _itemsToProcess = [];
        private _loadout = [_logic,"loadout"] call FUNC(hashGet);
        private _id = [_logic,"id"] call FUNC(hashGet);

        _loadout params [
            "_primaryWeaponArray","_secondaryWeaponArray","_handgunWeaponArray","_uniformArray",
            "_vestArray","_backpackArray","_helmet","_goggles","_binocularArray","_assignedItems"
        ];

        // primary

        if (count _primaryWeaponArray > 0) then {
            _primaryWeaponArray params ["_weaponClass","_muzzleAccessory","_pointerAccessory","_opticsAccessory","_primaryMagazineArray","_secondaryMagazineArray","_bipodAccessory"];
            _itemsToProcess append [_weaponClass,_muzzleAccessory,_pointerAccessory,_opticsAccessory,_bipodAccessory];

            {
                if (count _x > 0) then {
                    _itemsToProcess pushback (_x select 0);
                };
            } foreach [_primaryMagazineArray,_secondaryMagazineArray];
        };

        // secondary

        if (count _secondaryWeaponArray > 0) then {
            _secondaryWeaponArray params ["_weaponClass","_muzzleAccessory","_pointerAccessory","_opticsAccessory","_primaryMagazineArray","_secondaryMagazineArray","_bipodAccessory"];
            _itemsToProcess append [_weaponClass,_muzzleAccessory,_pointerAccessory,_opticsAccessory,_bipodAccessory];

            {
                if (count _x > 0) then {
                    _itemsToProcess pushback (_x select 0);
                };
            } foreach [_primaryMagazineArray,_secondaryMagazineArray];
        };

        // handgun

        if (count _handgunWeaponArray > 0) then {
            _handgunWeaponArray params ["_weaponClass","_muzzleAccessory","_pointerAccessory","_opticsAccessory","_primaryMagazineArray","_secondaryMagazineArray","_bipodAccessory"];
            _itemsToProcess append [_weaponClass,_muzzleAccessory,_pointerAccessory,_opticsAccessory,_bipodAccessory];

            {
                if (count _x > 0) then {
                    _itemsToProcess pushback (_x select 0);
                };
            } foreach [_primaryMagazineArray,_secondaryMagazineArray];
        };

        // uniform

        if (count _uniformArray > 0) then {
            _uniformArray params ["_uniformClass","_uniformItems"];
            _itemsToProcess pushback _uniformClass;

            {
                _itemClass = _x select 0;
                _itemCount = _x select 2;

                for "_i" from 0 to _itemCount do {
                    _itemsToProcess pushback _itemClass;
                };
            } foreach _uniformItems;
        };

        // vest

        if (count _vestArray > 0) then {
            _vestArray params ["_vestClass","_vestItems"];
            _itemsToProcess pushback _vestClass;

            {
                _itemClass = _x select 0;
                _itemCount = _x select 2;

                for "_i" from 0 to _itemCount do {
                    _itemsToProcess pushback _itemClass;
                };
            } foreach _vestItems;
        };

        // backpack

        if (count _backpackArray > 0) then {
            _backpackArray params ["_backpackClass","_backpackItems"];
            _itemsToProcess pushback _backpackClass;

            {
                _itemClass = _x select 0;
                _itemCount = _x select 2;

                for "_i" from 0 to _itemCount do {
                    _itemsToProcess pushback _itemClass;
                };
            } foreach _backpackItems;
        };

        _itemsToProcess pushback _helmet;
        _itemsToProcess pushback _goggles;

        // binocular

        if (count _binocularArray > 0) then {
            _binocularArray params ["_binocularClass","_muzzleAccessory","_pointerAccessory","_opticsAccessory","_primaryMagazineArray","_secondaryMagazineArray","_bipodAccessory"];
            _itemsToProcess append [_binocularClass,_muzzleAccessory,_pointerAccessory,_opticsAccessory,_bipodAccessory];

            {
                if (count _x > 0) then {
                    _itemsToProcess pushback (_x select 0);
                };
            } foreach [_primaryMagazineArray,_secondaryMagazineArray];
        };

        // assigned items

        {
            _itemsToProcess pushback _x;
        } foreach _assignedItems;

        // generate datasource

        private _itemsProcessed = [];

        {
            _item = _x;

            if (!(_item == "") && {!(_item in _itemsProcessed)}) then {
                _itemsProcessed pushback _item;
                _itemCount = {_x == _item} count _itemsToProcess;

                _itemConfig = configfile >> "CfgMagazines" >> _item;
                if !(isClass _itemConfig) then {_itemConfig = configfile >> "CfgVehicles" >> _item};
                if !(isClass _itemConfig) then {_itemConfig = configfile >> "CfgWeapons" >> _item};

                if (isClass _itemConfig) then {
                    _itemDisplayName = getText (_itemConfig >> "displayName");
                    if (_itemCount > 1) then {
                        _itemDisplayName = format ["%1: %2", _itemDisplayName, _itemCount];
                    };

                    _itemPicture = getText (_itemConfig >> "picture");

                    _tooltip = getText (_itemConfig >> "descriptionShort");
                    if !(_tooltip == "") then {
                        _tooltip = [_tooltip, "<br />", "\n"] call CBA_fnc_replace;
                        _tooltip = [_tooltip, "<br/>", "\n"] call CBA_fnc_replace;
                    };

                    _result pushback [_itemDisplayName,_itemPicture,_tooltip,""];
                };
            };
        } foreach _itemsToProcess;

    };

    method( "beautifyTooltip" ) {

        private _tooltip = _args;

        _tooltip = [_tooltip, "<br />", ". "] call CBA_fnc_replace;
        _tooltip = [_tooltip, "<br/>", ". "] call CBA_fnc_replace;

        _result = _tooltip;

    };

    defaultMethod();

};

if (!isnil "_result") then {_result} else {nil};