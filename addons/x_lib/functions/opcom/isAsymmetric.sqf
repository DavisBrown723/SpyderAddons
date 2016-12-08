/* ----------------------------------------------------------------------------
Function: SpyderAddons_fnc_isAsymmetric

Description:
Tests whether an opcom has a control type of asymmetric

Parameters:
Array - Opcom hash

Returns:
Bool - True if opcom is asymmetric

Examples:
(begin example)
_result = _opcom call SpyderAddons_fnc_isAsymmetric;
(end)

See Also:
- nil

Author: SpyderBlack723
---------------------------------------------------------------------------- */

private _opcom = _this;

private _controlType = [_opcom,"controltype","invasion"] call ALiVE_fnc_hashGet;

if (_controlType == "asymmetric") then {true} else {false};