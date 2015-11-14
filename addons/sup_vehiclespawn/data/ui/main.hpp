//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////				Recruitment Menu							/////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

#include "common.hpp"

class SpyderAddons_VehicleSpawner
{
	idd = 570;
	movingEnable = 1;
	onLoad = "";
	onUnload = "SpyderAddons_VehicleSpawner_Logic = nil";
	class controls 
	{

		class VehicleSpawner_Background: VehicleSpawner_RscText
		{
			idc = 571;

			x = 7 * GUI_GRID_W + GUI_GRID_X;
			y = 4 * GUI_GRID_H + GUI_GRID_Y;
			w = 24.5 * GUI_GRID_W;
			h = 20 * GUI_GRID_H;
			colorBackground[] = {0,0,0,0.55};
			colorActive[] = {0,0,0,0.55};
		};
		class VehicleSpawner_Header: VehicleSpawner_RscText
		{
			idc = 572;

			text = "Vehicle Spawner";
			x = 7 * GUI_GRID_W + GUI_GRID_X;
			y = 3 * GUI_GRID_H + GUI_GRID_Y;
			w = 24.5 * GUI_GRID_W;
			h = 1 * GUI_GRID_H;
			colorBackground[] = {0.788,0.443,0.157,0.65};
			colorActive[] = {0.788,0.443,0.157,0.65};
			sizeEx = .8 * GUI_GRID_H;
		};
		class VehicleSpawner_AvailableVehiclesTitle: VehicleSpawner_RscText
		{
			idc = 573;

			text = "Available Vehicles";
			x = 9 * GUI_GRID_W + GUI_GRID_X;
			y = 5 * GUI_GRID_H + GUI_GRID_Y;
			w = 8 * GUI_GRID_W;
			h = 1.5 * GUI_GRID_H;
			colorActive[] = {0,0,0,0};
		};
		class VehicleSpawner_VehicleList: VehicleSpawner_ListNBox
		{
			idc = 574;

			x = 7.5 * GUI_GRID_W + GUI_GRID_X;
			y = 7 * GUI_GRID_H + GUI_GRID_Y;
			w = 11 * GUI_GRID_W;
			h = 16 * GUI_GRID_H;
			colorBackground[] = {0.722,0.694,0.62,0.2};
			colorActive[] = {0.722,0.694,0.62,0.2};
			sizeEx = .6 * GUI_GRID_H;
		};
		class VehicleSpawner_VehicleInfoTitle: VehicleSpawner_RscText
		{
			idc = 575;

			text = "Vehicle Info";
			x = 21.8 * GUI_GRID_W + GUI_GRID_X;
			y = 5 * GUI_GRID_H + GUI_GRID_Y;
			w = 5.5 * GUI_GRID_W;
			h = 1.5 * GUI_GRID_H;
			colorActive[] = {0,0,0,0};
		};
		class VehicleSpawner_VehicleInfoList: VehicleSpawner_RscListBox
		{
			idc = 576;

			x = 18.8 * GUI_GRID_W + GUI_GRID_X;
			y = 7 * GUI_GRID_H + GUI_GRID_Y;
			w = 12.5 * GUI_GRID_W;
			h = 16 * GUI_GRID_H;
			colorBackground[] = {0,0,0,0};
			sizeEx = .7 * GUI_GRID_H;
		};
		class VehicleSpawner_Close: VehicleSpawner_RscButton
		{
			idc = 577;
			action = "closeDialog 0";

			text = "Close";
			x = 7 * GUI_GRID_W + GUI_GRID_X;
			y = 24.2 * GUI_GRID_H + GUI_GRID_Y;
			w = 4 * GUI_GRID_W;
			h = 1 * GUI_GRID_H;
			colorBackground[] = {0,0,0,0.55};
			colorActive[] = {0,0,0,0.55};
		};
		class VehicleSpawner_Spawn: VehicleSpawner_RscButton
		{
			idc = 578;
			action = "['spawnVehicle'] call SpyderAddons_fnc_vehicleSpawner";

			text = "Spawn";
			x = 11.3 * GUI_GRID_W + GUI_GRID_X;
			y = 24.2 * GUI_GRID_H + GUI_GRID_Y;
			w = 4 * GUI_GRID_W;
			h = 1 * GUI_GRID_H;
			colorBackground[] = {0,0,0,0.55};
		};

	};
};