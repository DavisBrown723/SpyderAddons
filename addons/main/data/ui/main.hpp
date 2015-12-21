#include "common.hpp"

//-- GUI editor: configfile >> "SpyderAddons_RequiresALiVE"

class SpyderAddons_RequiresALiVE
{
	idd = 10090;
	movingEnable = 1;
	onLoad = "";
	onUnload = "";
	class controls 
	{

		class RequiresAlive_Background: SpyderAddons_RscText
		{
			idc = 10091;
			x = 4 * GUI_GRID_W + GUI_GRID_X;
			y = 9 * GUI_GRID_H + GUI_GRID_Y;
			w = 32 * GUI_GRID_W;
			h = 7 * GUI_GRID_H;
			colorBackground[] = {0,0,0,0.7};
		};
		class RequiresAlive_Title: SpyderAddons_RscText
		{
			idc = 10092;
			text = "Spyder Addons";
			x = 4 * GUI_GRID_W + GUI_GRID_X;
			y = 8 * GUI_GRID_H + GUI_GRID_Y;
			w = 32 * GUI_GRID_W;
			h = 1 * GUI_GRID_H;
			colorBackground[] = {0.788,0.443,0.157,0.65};
			sizeEx = .8 * GUI_GRID_H;
		};
		class RequiresAlive_Warning: SpyderAddons_RscStructuredText
		{
			idc = 10093;
			text = "This module requires ALiVE to be running in order to function. Please download ALiVE if you wish to use this module. https://alivemod.com/#Download";
			x = 4.5 * GUI_GRID_W + GUI_GRID_X;
			y = 9.8 * GUI_GRID_H + GUI_GRID_Y;
			w = 31 * GUI_GRID_W;
			h = 5.5 * GUI_GRID_H;
			colorBackground[] = {0,0,0,0};
		};
		class RequiresAlive_Close: SpyderAddons_RscButton
		{
			idc = 10095;
			action = "closeDialog 0";
			text = "Close";
			x = 4 * GUI_GRID_W + GUI_GRID_X;
			y = 16.2 * GUI_GRID_H + GUI_GRID_Y;
			w = 7 * GUI_GRID_W;
			h = 1.2 * GUI_GRID_H;
			sizeEx = .8 * GUI_GRID_H;
		};

	};
};