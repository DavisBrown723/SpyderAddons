//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////				Recruitment Menu							/////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

#include "common.hpp"

class Recruitment_Menu
{
	idd = 570;
	movingEnable = 1;
	onLoad = "";
	onUnload = "['onUnload'] call SpyderAddons_fnc_recruitment";
	class controls 
	{
		class Recruitment_Background: Recruitment_RscText
		{
			idc = 571;
			x = 7 * GUI_GRID_W + GUI_GRID_X;
			y = 4 * GUI_GRID_H + GUI_GRID_Y;
			w = 24.5 * GUI_GRID_W;
			h = 20 * GUI_GRID_H;
			colorBackground[] = {0,0,0,0.55};
			colorActive[] = {0,0,0,0.55};
		};
		class Recruitment_Header: Recruitment_RscText
		{
			moving = 1;
			idc = 572;
			text = "Recruitment";
			x = 7 * GUI_GRID_W + GUI_GRID_X;
			y = 3 * GUI_GRID_H + GUI_GRID_Y;
			w = 24.5 * GUI_GRID_W;
			h = 1 * GUI_GRID_H;
			colorBackground[] = {0.788,0.443,0.157,0.65};
			colorActive[] = {0.788,0.443,0.157,0.65};
			sizeEx = .8 * GUI_GRID_H;
		};
		class Recruitment_AvailableUnitsTitle: Recruitment_RscText
		{
			idc = 573;
			text = "Available Units";
			x = 9 * GUI_GRID_W + GUI_GRID_X;
			y = 5 * GUI_GRID_H + GUI_GRID_Y;
			w = 7 * GUI_GRID_W;
			h = 1.5 * GUI_GRID_H;
			colorBackground[] = {0,0,0,0};
			colorActive[] = {0,0,0,0};
		};
		class Recruitment_AvailableUnitsList: Recruitment_RscListBox
		{
			idc = 574;
			x = 7.5 * GUI_GRID_W + GUI_GRID_X;
			y = 7 * GUI_GRID_H + GUI_GRID_Y;
			w = 11 * GUI_GRID_W;
			h = 16 * GUI_GRID_H;
			sizeEx = .6 * GUI_GRID_H;
			colorBackground[] = {0.722,0.694,0.62,0.2};
			colorActive[] = {0.722,0.694,0.62,0.2};
		};
		class Recruitment_UnitGearTitle: Recruitment_RscText
		{
			idc = 575;
			text = "Unit Gear";
			x = 22.5 * GUI_GRID_W + GUI_GRID_X;
			y = 5 * GUI_GRID_H + GUI_GRID_Y;
			w = 4.5 * GUI_GRID_W;
			h = 1.5 * GUI_GRID_H;
			colorBackground[] = {0,0,0,0};
			colorActive[] = {0,0,0,0};
		};
		class Recruitment_UnitGearList: Recruitment_ListNBox
		{
			idc = 576;
			x = 18.8 * GUI_GRID_W + GUI_GRID_X;
			y = 7 * GUI_GRID_H + GUI_GRID_Y;
			w = 12.5 * GUI_GRID_W;
			h = 16 * GUI_GRID_H;
			colorBackground[] = {0,0,0,0};
			sizeEx = .6 * GUI_GRID_H;
		};
		class Recruitment_Close: Recruitment_RscButton
		{
			idc = 577;
			action = "closeDialog 0";
			text = "Close";
			x = 7 * GUI_GRID_W + GUI_GRID_X;
			y = 24.2 * GUI_GRID_H + GUI_GRID_Y;
			w = 4 * GUI_GRID_W;
			h = 1 * GUI_GRID_H;
		};
		class Recruitment_Recruit: Recruitment_RscButton
		{
			idc = 578;
			action = "['getSelectedUnit'] call SpyderAddons_fnc_recruitment";
			text = "Recruit";
			x = 11.3 * GUI_GRID_W + GUI_GRID_X;
			y = 24.2 * GUI_GRID_H + GUI_GRID_Y;
			w = 4 * GUI_GRID_W;
			h = 1 * GUI_GRID_H;
		};
};
};