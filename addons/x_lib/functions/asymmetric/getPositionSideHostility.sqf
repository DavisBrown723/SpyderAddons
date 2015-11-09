/* ----------------------------------------------------------------------------
Function: SpyderAddons_fnc_getPositionSideHostility

Description:
Returns the hostility towards a side at a given location

Parameters:
Array - Position
String - Side

Returns:
Scalar - Hostility value if it exists, otherwise nil

Examples:
(begin example)
[getPos player, "WEST"] call SpyderAddons_fnc_getPositionSideHostility; //-- Returns hostility towards side west at player location
[getPos player, str side player] call SpyderAddons_fnc_getPositionSideHostility; //-- Returns hostility towards player side at player location
[getMarkerPos "Town1", "GUER"] call SpyderAddons_fnc_getPositionSideHostility; //-- Returns hostility towards the independent side at marker "Town1"
(end)

See Also:
- nil

Author: SpyderBlack723
---------------------------------------------------------------------------- */

_arguments params ["_pos","_side"];
private ["_hostility"];

//-- Get current sector hostility
_sector = [ALIVE_sectorGrid, "positionToSector", _pos] call ALIVE_fnc_sectorGrid;
_sectorData = [_sector,"data",["",[],[],nil]] call ALIVE_fnc_hashGet;

//-- Get closest civilian cluster
if ("clustersCiv" in (_sectorData select 1)) then {
	_civClusters = [_sectorData,"clustersCiv"] call ALIVE_fnc_hashGet;
	_settlementClusters = [_civClusters,"settlement"] call ALIVE_fnc_hashGet;
	_settlementClusters = [_settlementClusters,[_pos],{_Input0 distance2D (_x select 0)},"ASCEND"] call BIS_fnc_sortBy;
	_settlementCluster = _settlementClusters select 0;

	//-- Get cluster
	_clusterID = _settlementCluster select 1;
	_cluster = [ALIVE_clusterHandler, "getCluster", _clusterID] call ALIVE_fnc_clusterHandler;

	//-- Get hostility
	if (!isNil "_cluster") then {
		_clusterHostility = [_cluster, "hostility"] call ALIVE_fnc_hashGet;
		_hostility = [_clusterHostility,_side,0] call ALIVE_fnc_hashGet;
	};
};

if (!isNil "_hostility") then {_hostility} else {nil};