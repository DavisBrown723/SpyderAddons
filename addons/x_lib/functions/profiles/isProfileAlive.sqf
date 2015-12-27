/* ----------------------------------------------------------------------------
Function: SpyderAddons_fnc_isProfileAlive

Description:
Checks whether a profile is still "alive"

Parameters:
String - Profile ID

Returns:
Bool - Result

Examples:
(begin example)
_result = [_id] SpyderAddons_fnc_isProfileAlive;
(end)

See Also:
- nil

Author: SpyderBlack723
---------------------------------------------------------------------------- */

params [
	["_profileID", []]
];

if (_profileID isEqualTo []) exitWith {false};

_profile = [ALIVE_profileHandler, "getProfile", _profileID] call ALIVE_fnc_profileHandler;

!(isNil "_profile")