/* ----------------------------------------------------------------------------
Function: SpyderAddons_fnc_recruitment

Description:
Main handler for recruitment

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

params [
	["_operation", ""],
	["_arguments", []]
];
private ["_result"];

//-- Define control ID's
#define RECRUITMENT_DIALOG "Recruitment_Menu"
#define RECRUITMENT_UNITLIST 574
#define RECRUITMENT_GEARLIST 576

switch (_operation) do {

	case "init": {
		_arguments params ["_logic","_syncedUnits"];

		_factions = [_logic getVariable "RecruitableFactions"] call SpyderAddons_fnc_getModuleArray;
		_whitelist = [_logic getVariable "RecruitableUnits"] call SpyderAddons_fnc_getModuleArray;
		_blacklist = [_logic getVariable "BlacklistedUnits"] call SpyderAddons_fnc_getModuleArray;

		{
			if (typeName _x == "OBJECT") then {
				_x setVariable ["Recruitment_Factions", _factions];
				_x setVariable ["Recruitment_Whitelist", _whitelist];
				_x setVariable ["Recruitment_Blacklist", _blacklist];
				_x addAction ["Recruit", {["open",_this] call SpyderAddons_fnc_recruitment}];
			};
		} forEach _syncedUnits;
	};
	
	case "open": {
		CreateDialog RECRUITMENT_DIALOG;
		["onLoad", _arguments] call SpyderAddons_fnc_recruitment;
	};

	case "onLoad": {
		private ["_factions"];
		_arguments params ["_object","_caller"];

		//-- Get settings
		_factions = _object getVariable ["Recruitment_Factions",[]];
		_whitelist = _object getVariable ["Recruitment_Whitelist",[]];
		_blacklist = _object getVariable ["Recruitment_Blacklist",[]];

		//-- Get faction units
		_units = "(
			((getText (_x >> 'faction')) in _factions) and
			{(configName _x) isKindOf 'Man' and
			{!((getText (_x >> '_generalMacro') == 'B_Soldier_base_F')) and
			{!((configName _x) in _blacklist)
		}}})" configClasses (configFile >> "CfgVehicles");

		//-- Add whitelisted units
		{
			if ((typeName _x == "STRING") and !(_x in _units)) then {
				_units pushBack (configFile >> "CfgVehicles" >> _x);
			};
		} forEach _whitelist;

		//-- Build list with retrieved units
		{
			lbAdd [RECRUITMENT_UNITLIST, (getText (_x >> "displayName"))];
			lbSetData [RECRUITMENT_UNITLIST, _forEachIndex, configName _x];
		} forEach _units;

		//-- Track group list selection
		(findDisplay 570 displayCtrl RECRUITMENT_UNITLIST)  ctrlAddEventHandler ["LBSelChanged","
			['updateGear'] call SpyderAddons_fnc_recruitment;
		"];
	};

	case "updateGear": {
		private ["_index"];
		_index = 0;

		//-- Clear any existing data
		lbClear RECRUITMENT_GEARLIST;

		//-- Get currently selected unit
		_index = lbCurSel RECRUITMENT_UNITLIST;
		_class = lbData [RECRUITMENT_UNITLIST, _index];

		//-- Get config entry
		_configClass = configfile >> "CfgVehicles" >> _class;
		_weapons = getArray (_configClass >> "weapons");
		_magazines = getArray (_configClass >> "magazines");
		_items = getArray (_configClass >> "Items");

		//-- Populate weapons and items
		{
			if !((_x == "Throw") or (_x == "Put")) then {
				_configPath = configfile >> "CfgWeapons" >> _x;
				if (isClass _configPath) then {
					_text = getText (_configPath >> "displayName");
					_picture = getText (_configPath >> "picture");
					lbAdd [RECRUITMENT_GEARLIST, _text];
					lbSetPicture [RECRUITMENT_GEARLIST, _index, _picture];
					_index = _index + 1;
				};
			};
		} forEach _weapons;

		//-- Populate magazines
		{
			private ["_configPath"];
			_item = _x;
			_count = {_x == _item} count _magazines;
			if !(_count == 0) then {
				for "_i" from 0 to _count step 1 do {_magazines = _magazines - [_item]};

				_configPath = configfile >> "CfgWeapons" >> _item;
				if !(isClass _configPath) then {_configPath = configfile >> "CfgMagazines" >> _item};
				if !(isClass _configPath) then {_configPath = configfile >> "CfgVehicles" >> _item};

				if (isClass _configPath) then {
					_displayName = getText (_configPath >> "displayName");
					_magazineInfo = format ["%1: %2", _displayName,_count];
					_picture = getText (_configPath >> "picture");
					lbAdd [RECRUITMENT_GEARLIST,_magazineInfo];
					lbSetPicture [RECRUITMENT_GEARLIST, _index, _picture];
					_index = _index + 1;
				};
			};
		} forEach _magazines + _items;
	};

	case "recruitUnit": {
		private ["_locality"];
		_locality = _arguments select 0;

		switch (_locality) do {
			//-- Get data from client and execute file on server
			case "client": {
				//-- Get selected unit
				_index = lbCurSel RECRUITMENT_UNITLIST;
				_classname = lbData [RECRUITMENT_UNITLIST, _index];
				["recruitUnit", ["server", [_classname, player]]] remoteExecCall ["SpyderAddons_fnc_recruitment",2];
			};

			//-- Recieve client-sent data and create unit on server
			case "server": {
				_data = _arguments select 1;
				_data params ["_classname","_player"];
				_unit = (group _player) createUnit [_classname, position _player, [], 15, "FORM"];
			};
		};
	};

};

//-- Return result if any exists
if (!isNil "_result") then {_result} else {nil};