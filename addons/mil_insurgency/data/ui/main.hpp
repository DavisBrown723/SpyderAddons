//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////				Recruitment Menu							/////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

#include "common.hpp"

class Command_Board
{
	idd = 9200;
	movingEnable = 1;
	onLoad = "";
	onUnload = "[nil,'unLoad'] call SpyderAddons_fnc_commandBoard";
	class controls 
	{
		
		//////////-- Grey borders --//////////
		class CommandBoard_GreyBorderLeft: Insurgency_RscText
		{
			idc = -1;

			x = -9 * GUI_GRID_W + GUI_GRID_X;
			y = -6.5 * GUI_GRID_H + GUI_GRID_Y;
			w = 2.5 * GUI_GRID_W;
			h = 39 * GUI_GRID_H;
			colorBackground[] = {0.541,0.553,0.557,1};
		};
		class CommandBoard_GreyBorderRight: Insurgency_RscText
		{
			idc = -1;

			x = 47 * GUI_GRID_W + GUI_GRID_X;
			y = -6.5 * GUI_GRID_H + GUI_GRID_Y;
			w = 2 * GUI_GRID_W;
			h = 38 * GUI_GRID_H;
			colorBackground[] = {0.541,0.553,0.557,1};
		};
		class CommandBoard_GreyBorderBottom: Insurgency_RscText
		{
			idc = -1;

			x = -8.5 * GUI_GRID_W + GUI_GRID_X;
			y = 30.5 * GUI_GRID_H + GUI_GRID_Y;
			w = 55.5 * GUI_GRID_W;
			h = 1 * GUI_GRID_H;
			colorBackground[] = {0.541,0.553,0.557,1};
		};
		class CommandBoard_GreyBorderTop: Insurgency_RscText
		{
			idc = -1;

			x = -7.5 * GUI_GRID_W + GUI_GRID_X;
			y = -6.5 * GUI_GRID_H + GUI_GRID_Y;
			w = 54.5 * GUI_GRID_W;
			h = 1 * GUI_GRID_H;
			colorBackground[] = {0.541,0.553,0.557,1};
		};
		
		//////////-- Main --//////////
		class CommandBoard_Background: Insurgency_RscText
		{
			idc = 9200;

			x = -7 * GUI_GRID_W + GUI_GRID_X;
			y = -5.5 * GUI_GRID_H + GUI_GRID_Y;
			w = 54 * GUI_GRID_W;
			h = 36 * GUI_GRID_H;
			colorBackground[] = {1,1,1,1};
		};
		class CommandBoard_Map: Insurgency_RscMapControl
		{
			idc = 9201;

			x = -6.5 * GUI_GRID_W + GUI_GRID_X;
			y = -5 * GUI_GRID_H + GUI_GRID_Y;
			w = 53 * GUI_GRID_W;
			h = 21 * GUI_GRID_H;
			colorBackground[] = {0,0,0,1};
		};
		
		class CommandBoard_MainMenu: Insurgency_RscListBox
		{
			idc = 9202;

			x = -6.5 * GUI_GRID_W + GUI_GRID_X;
			y = 16.3 * GUI_GRID_H + GUI_GRID_Y;
			w = 26 * GUI_GRID_W;
			h = 11 * GUI_GRID_H;
		};
		class CommandBoard_SecondaryMenu: Insurgency_RscListBox
		{
			idc = 9206;

			x = 20 * GUI_GRID_W + GUI_GRID_X;
			y = 16.3 * GUI_GRID_H + GUI_GRID_Y;
			w = 19 * GUI_GRID_W;
			h = 11 * GUI_GRID_H;
		};

		class CommandBoard_FactionLogo: Insurgency_RscPicture
		{
			idc = 9203;
			text = "\x\spyderaddons\addons\main\logo.paa";
			x = 43.95 * GUI_GRID_W + GUI_GRID_X;
			y = 28.6 * GUI_GRID_H + GUI_GRID_Y;
			w = 3.5 * GUI_GRID_W;
			h = 1.68 * GUI_GRID_H;
		};
		class CommandBoard_BackMain: Insurgency_RscButton
		{
			idc = 9204;
			text = "Back";
			x = -6.5 * GUI_GRID_W + GUI_GRID_X;
			y = 27.5 * GUI_GRID_H + GUI_GRID_Y;
			w = 26 * GUI_GRID_W;
			h = 1 * GUI_GRID_H;
		};
		class CommandBoard_Close: Insurgency_RscButton
		{
			idc = 9205;
			action = "closeDialog 0";
			text = "Close";
			x = -6.35 * GUI_GRID_W + GUI_GRID_X;
			y = 28.9 * GUI_GRID_H + GUI_GRID_Y;
			w = 6 * GUI_GRID_W;
			h = 1.4 * GUI_GRID_H;
		};
		class CommandBoard_BackSeconadary: Insurgency_RscButton
		{
			idc = 9207;
			action = "";

			text = "Back";
			x = 39.5 * GUI_GRID_W + GUI_GRID_X;
			y = 26.3 * GUI_GRID_H + GUI_GRID_Y;
			w = 7 * GUI_GRID_W;
			h = 1 * GUI_GRID_H;
		};
		
		//////////-- Black borders --//////////
		class CommandBoard_BlackBorderLeft: Insurgency_RscText
		{
			idc = -1;

			x = -7 * GUI_GRID_W + GUI_GRID_X;
			y = -5.5 * GUI_GRID_H + GUI_GRID_Y;
			w = 0.2 * GUI_GRID_W;
			h = 36 * GUI_GRID_H;
			colorBackground[] = {0,0,0,1};
		};
		class CommandBoard_BlackBorderRight: Insurgency_RscText
		{
			idc = -1;

			x = 47 * GUI_GRID_W + GUI_GRID_X;
			y = -5.5 * GUI_GRID_H + GUI_GRID_Y;
			w = 0.2 * GUI_GRID_W;
			h = 36.2 * GUI_GRID_H;
			colorBackground[] = {0,0,0,1};
		};
		class CommandBoard_BlackBorderTop: Insurgency_RscText
		{
			idc = -1;

			x = -7 * GUI_GRID_W + GUI_GRID_X;
			y = -5.5 * GUI_GRID_H + GUI_GRID_Y;
			w = 54 * GUI_GRID_W;
			h = 0.2 * GUI_GRID_H;
			colorBackground[] = {0,0,0,1};
		};
		class CommandBoard_BlackBorderBottom: Insurgency_RscText
		{
			idc = -1;

			x = -7.01 * GUI_GRID_W + GUI_GRID_X;
			y = 30.5 * GUI_GRID_H + GUI_GRID_Y;
			w = 54.12 * GUI_GRID_W;
			h = 0.2 * GUI_GRID_H;
			colorBackground[] = {0,0,0,1};
		};

	};
};