#include "common.hpp"

//-- GUI editor: configfile >> "Civ_Interact"

class Civ_Interact
{
	idd = 923;
	movingEnable = 1;
	onUnload = "['closeMenu'] call SpyderAddons_fnc_civInteract";
	class controls 
	{

		class CivInteract_Background: CivInteract_RscText
		{
			idc = 9231;

			x = 2 * GUI_GRID_W + GUI_GRID_X;
			y = 3 * GUI_GRID_H + GUI_GRID_Y;
			w = 30.5 * GUI_GRID_W;
			h = 21 * GUI_GRID_H;
			colorBackground[] = {0,0,0,0.65};
			colorActive[] = {0,0,0,0.65};
		};
		class CivInteract_Header: CivInteract_RscText
		{
			idc = 9232;

			text = "Civilian interaction";
			x = 2 * GUI_GRID_W + GUI_GRID_X;
			y = 2 * GUI_GRID_H + GUI_GRID_Y;
			w = 30.5 * GUI_GRID_W;
			h = 1 * GUI_GRID_H;
			colorBackground[] = {0.788,0.443,0.157,0.65};
			colorActive[] = {0.788,0.443,0.157,0.65};
			sizeEx = .85 * GUI_GRID_H;
		};
		class CivInteract_QuestionsTitle: CivInteract_RscText
		{
			idc = 9233;

			text = "Questions";
			x = 15.5 * GUI_GRID_W + GUI_GRID_X;
			y = 6 * GUI_GRID_H + GUI_GRID_Y;
			w = 4.5 * GUI_GRID_W;
			h = 1.5 * GUI_GRID_H;
			colorActive[] = {0,0,0,0};
		};
		class CivInteract_QuestionList: CivInteract_RscListBox
		{
			idc = 9234;

			x = 2.5 * GUI_GRID_W + GUI_GRID_X;
			y = 7.5 * GUI_GRID_H + GUI_GRID_Y;
			w = 29 * GUI_GRID_W;
			h = 7 * GUI_GRID_H;
			colorBackground[] = {0,0,0,0};
			colorActive[] = {0,0,0,0};
			sizeEx = .67 * GUI_GRID_H;
		};
		class CivInteract_CivName: CivInteract_RscText
		{
			idc = 9236;

			x = 14.2 * GUI_GRID_W + GUI_GRID_X;
			y = 3.5 * GUI_GRID_H + GUI_GRID_Y;
			w = 8.5 * GUI_GRID_W;
			h = 2 * GUI_GRID_H;
			sizeEx = 1 * GUI_GRID_H;
		};
		class CivInteract_ResponseTitle: CivInteract_RscText
		{
			idc = 9238;

			text = "Response";
			x = 15.5 * GUI_GRID_W + GUI_GRID_X;
			y = 14.4 * GUI_GRID_H + GUI_GRID_Y;
			w = 4.5 * GUI_GRID_W;
			h = 1.5 * GUI_GRID_H;
			colorActive[] = {0,0,0,0};
		};
		class CivInteract_ResponseList: CivInteract_RscStructuredText
		{
			idc = 9239;

			x = 3 * GUI_GRID_W + GUI_GRID_X;
			y = 16 * GUI_GRID_H + GUI_GRID_Y;
			w = 29 * GUI_GRID_W;
			h = 7.5 * GUI_GRID_H;
			colorBackground[] = {0,0,0,0};
			colorActive[] = {0,0,0,0};
			sizeEx = .7 * GUI_GRID_H;
		};
		class CivInteract_Detain: CivInteract_RscButton
		{
			idc = 92311;
			action = "['Detain'] call SpyderAddons_fnc_commandHandler";

			text = "Detain";
			x = 13.75 * GUI_GRID_W + GUI_GRID_X;
			y = 24.2 * GUI_GRID_H + GUI_GRID_Y;
			w = 4.5 * GUI_GRID_W;
			h = 1 * GUI_GRID_H;
			colorActive[] = {0,0,0,0.5};
			sizeEx = .8 * GUI_GRID_H;
		};
		class CivInteract_GetDown: CivInteract_RscButton
		{
			idc = 92312;
			action = "['getDown'] call SpyderAddons_fnc_commandHandler";

			text = "Get Down";
			x = 18.5 * GUI_GRID_W + GUI_GRID_X;
			y = 24.2 * GUI_GRID_H + GUI_GRID_Y;
			w = 4.5 * GUI_GRID_W;
			h = 1 * GUI_GRID_H;
			colorBackground[] = {0,0,0,0.5};
			colorActive[] = {0,0,0,0.5};
			sizeEx = .8 * GUI_GRID_H;
		};
		class CivInteract_GoAway: CivInteract_RscButton
		{
			idc = 92313;
			action = "['goAway'] call SpyderAddons_fnc_commandHandler";

			text = "Go Away";
			x = 23.25 * GUI_GRID_W + GUI_GRID_X;
			y = 24.2 * GUI_GRID_H + GUI_GRID_Y;
			w = 4.5 * GUI_GRID_W;
			h = 1 * GUI_GRID_H;
			colorBackground[] = {0,0,0,0.5};
			colorActive[] = {0,0,0,0.5};
			sizeEx = .8 * GUI_GRID_H;
		};
		class CivInteract_Close: CivInteract_RscButton
		{
			idc = 9237;
			action = "closeDialog 0";

			text = "Close";
			x = 2 * GUI_GRID_W + GUI_GRID_X;
			y = 24.2 * GUI_GRID_H + GUI_GRID_Y;
			w = 4.5 * GUI_GRID_W;
			h = 1 * GUI_GRID_H;
			colorBackground[] = {0,0,0,0.5};
			colorActive[] = {0,0,0,0.5};
			sizeEx = .8 * GUI_GRID_H;
		};
		class CivInteract_inventory_Background: CivInteract_RscText
		{
			idc = 9240;

			x = 33 * GUI_GRID_W + GUI_GRID_X;
			y = 3 * GUI_GRID_H + GUI_GRID_Y;
			w = 12.5 * GUI_GRID_W;
			h = 21 * GUI_GRID_H;
			colorBackground[] = {0,0,0,0.65};
			colorActive[] = {0,0,0,0.65};
		};
		class CivInteract_inventory_Header: CivInteract_RscText
		{
			idc = 9241;

			text = "Inventory";
			x = 33 * GUI_GRID_W + GUI_GRID_X;
			y = 2 * GUI_GRID_H + GUI_GRID_Y;
			w = 12.5 * GUI_GRID_W;
			h = 1 * GUI_GRID_H;
			colorBackground[] = {0.788,0.443,0.157,0.65};
			colorActive[] = {0.788,0.443,0.157,0.65};
			sizeEx = .85 * GUI_GRID_H;
		};
		class CivInteract_Search: CivInteract_RscButton
		{
			idc = 9242;
			action = "['toggleSearchMenu'] call SpyderAddons_fnc_civInteract";

			text = "Search";
			x = 28 * GUI_GRID_W + GUI_GRID_X;
			y = 24.2 * GUI_GRID_H + GUI_GRID_Y;
			w = 4.55 * GUI_GRID_W;
			h = 1 * GUI_GRID_H;
			colorBackground[] = {0,0,0,0.5};
			colorActive[] = {0,0,0,0.5};
			sizeEx = .8 * GUI_GRID_H;
		};
		class CivInteract_inventory_Close: CivInteract_RscButton
		{
			idc = 9243;
			action = "['toggleSearchMenu'] call SpyderAddons_fnc_civInteract";

			text = "Close";
			x = 33 * GUI_GRID_W + GUI_GRID_X;
			y = 24.2 * GUI_GRID_H + GUI_GRID_Y;
			w = 12.5 * GUI_GRID_W;
			h = 1 * GUI_GRID_H;
			colorBackground[] = {0,0,0,0.5};
			colorActive[] = {0,0,0,0.5};
			sizeEx = .8 * GUI_GRID_H;
			class Attributes { 
				font = "PuristaMedium"; 
				color = "#C0C0C0"; 
				align = "center"; 
				valign = "middle"; 
				shadow = true; 
				shadowColor = "#000000";
			};
		};
		class CivInteract_inventory_GearList: CivInteract_RscListNBox
		{
			idc = 9244;
			x = 33.5 * GUI_GRID_W + GUI_GRID_X;
			y = 3.5 * GUI_GRID_H + GUI_GRID_Y;
			w = 11.5 * GUI_GRID_W;
			h = 20 * GUI_GRID_H;
			colorBackground[] = {0.173,0.173,0.173,0.8};
			colorActive[] = {0.173,0.173,0.173,0.8};
		};
		class CivInteract_inventory_Confiscate: CivInteract_RscButton
		{
			idc = 9245;
			action = "['confiscate'] call SpyderAddons_fnc_civInteract";

			text = "Confiscate";
			x = 33 * GUI_GRID_W + GUI_GRID_X;
			y = 25.5 * GUI_GRID_H + GUI_GRID_Y;
			w = 12.5 * GUI_GRID_W;
			h = 1 * GUI_GRID_H;
			colorBackground[] = {0,0,0,0.5};
			colorActive[] = {0,0,0,0.5};
			sizeEx = .8 * GUI_GRID_H;
		};

	};
};