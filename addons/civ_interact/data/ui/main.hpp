#include "common.hpp"

//-- GUI editor: configfile >> "Civ_Interact"

class Civ_Interact
{
	idd = 923;
	movingEnable = 1;
	//onLoad = "[SpyderAddons_civilianInteraction,'onLoad'] call SpyderAddons_fnc_civilianInteraction"; //-- Get's executed before the menu is opened.. wtf
	onUnload = "[SpyderAddons_civilianInteraction,'unLoad'] call SpyderAddons_fnc_civilianInteraction";

	class controlsBackground {
		class CivInteract_inventory_Background: CivInteract_RscText
		{
			idc = 9240;

			x = 34.5 * GUI_GRID_W + GUI_GRID_X;
			y = -2 * GUI_GRID_H + GUI_GRID_Y;
			w = 14.5 * GUI_GRID_W;
			h = 25 * GUI_GRID_H;
			colorBackground[] = {0,0,0,1};
			colorActive[] = {-1,-1,-1,-1};
		};
		class CivInteract_inventory_Header: CivInteract_RscText
		{
			idc = 9241;

			moving = 1;
			text = " Inventory";
			x = 34 * GUI_GRID_W + GUI_GRID_X;
			y = -3 * GUI_GRID_H + GUI_GRID_Y;
			w = 15 * GUI_GRID_W;
			h = 1 * GUI_GRID_H;
			colorBackground[] = {0.788,0.443,0.157,1};
			colorActive[] = {-1,-1,-1,-1};
			sizeEx = .9 * GUI_GRID_H;
		};

		class CivInteract_Background: CivInteract_RscText
		{
			idc = 9231;

			x = -2 * GUI_GRID_W + GUI_GRID_X;
			y = -2 * GUI_GRID_H + GUI_GRID_Y;
			w = 36 * GUI_GRID_W;
			h = 25 * GUI_GRID_H;
			colorBackground[] = {0,0,0,1}; //colorBackground[] = {0,0,0,0.7};
			colorActive[] = {-1,-1,-1,-1};
		};
		class CivInteract_Header: CivInteract_RscText
		{
			idc = 9232;

			moving = 1;
			text = "Civilian Interaction";
			x = -2 * GUI_GRID_W + GUI_GRID_X;
			y = -3 * GUI_GRID_H + GUI_GRID_Y;
			w = 36 * GUI_GRID_W;
			h = 1 * GUI_GRID_H;
			colorBackground[] = {0.788,0.443,0.157,1};
			colorActive[] = {-1,-1,-1,-1};
			sizeEx = .9 * GUI_GRID_H;
		};
		class CivInteract_QuestionsTitle: CivInteract_RscText
		{
			idc = 9233;

			text = "Questions";
			x = 0.5 * GUI_GRID_W + GUI_GRID_X;
			y = 0 * GUI_GRID_H + GUI_GRID_Y;
			w = 5 * GUI_GRID_W;
			h = 1 * GUI_GRID_H;
			colorActive[] = {-1,-1,-1,-1};
			sizeEx = 1 * GUI_GRID_H;
		};
		class CivInteract_ResponseTitle: CivInteract_RscText
		{
			idc = 9238;

			text = "Response";
			x = 0.5 * GUI_GRID_W + GUI_GRID_X;
			y = 12.5 * GUI_GRID_H + GUI_GRID_Y;
			w = 4.5 * GUI_GRID_W;
			h = 1.5 * GUI_GRID_H;
			colorActive[] = {0,0,0,0};
			sizeEx = 1 * GUI_GRID_H;
		};
	};

	class controls 
	{

		class CivInteract_CivName: CivInteract_RscText
		{
			idc = 9236;

			text = "Name";
			x = 12.5 * GUI_GRID_W + GUI_GRID_X;
			y = -1.7 * GUI_GRID_H + GUI_GRID_Y;
			w = 16 * GUI_GRID_W;
			h = 2 * GUI_GRID_H;
			sizeEx = 1 * GUI_GRID_H;
		};
		class CivInteract_QuestionListOne: CivInteract_RscListBox
		{
			idc = 9234;

			text = "";
			x = -1 * GUI_GRID_W + GUI_GRID_X;
			y = 1.5 * GUI_GRID_H + GUI_GRID_Y;
			w = 17 * GUI_GRID_W;
			h = 9.3 * GUI_GRID_H;
			colorBackground[] = {0.173,0.173,0.173,0.8};
			sizeEx = .67 * GUI_GRID_H;
		};
		class CivInteract_QuestionListTwo: CivInteract_RscListBox
		{
			idc = 9235;

			text = "";
			x = 16.5 * GUI_GRID_W + GUI_GRID_X;
			y = 1.5 * GUI_GRID_H + GUI_GRID_Y;
			w = 16.5 * GUI_GRID_W;
			h = 9.3 * GUI_GRID_H;
			colorBackground[] = {0.173,0.173,0.173,0.8};
			sizeEx = .67 * GUI_GRID_H;
		};
		class CivInteract_AskQuestion: CivInteract_RscButton
		{
			idc = 9247;
			action = "[SpyderAddons_civilianInteraction,'prepQuestion'] call SpyderAddons_fnc_civilianInteraction";

			text = "Ask Question";
			x = -1 * GUI_GRID_W + GUI_GRID_X;
			y = 11.2 * GUI_GRID_H + GUI_GRID_Y;
			w = 34 * GUI_GRID_W;
			h = 1.2 * GUI_GRID_H;
			colorBackground[] = {0.788,0.443,0.157,0.8};
			colorSelect[] = {0.788,0.443,0.157,0.8};
			colorSelect2[] = {0.788,0.443,0.157,0.8};
			colorBackgroundDisabled[] = {0.788,0.443,0.157,0.5};
			sizeEx = .85 * GUI_GRID_H;
		};
		class CivInteract_ResponseBox: CivInteract_RscStructuredText
		{
			idc = 9239;

			x = -1.1 * GUI_GRID_W + GUI_GRID_X;
			y = 14 * GUI_GRID_H + GUI_GRID_Y;
			w = 33.5 * GUI_GRID_W;
			h = 8 * GUI_GRID_H;
			colorBackground[] = {0,0,0,0};
			colorActive[] = {0,0,0,0};
			sizeEx = .6 * GUI_GRID_H;
		};
		class CivInteract_ProgressBarTitle: CivInteract_RscText
		{
			idc = 9248;

			text = "";
			x = 13.5 * GUI_GRID_W + GUI_GRID_X;
			y = 20 * GUI_GRID_H + GUI_GRID_Y;
			w = 15 * GUI_GRID_W;
			h = 1 * GUI_GRID_H;
			sizeEx = 1 * GUI_GRID_H;
		};
		//class CivInteract_AskingProgressBar: CivInteract_RscProgress
		//{
		//	idc = 9249;
		//	x = -1.1 * GUI_GRID_W + GUI_GRID_X;
		//	y = 21.5 * GUI_GRID_H + GUI_GRID_Y;
		//	w = 34 * GUI_GRID_W;
		//	h = 1 * GUI_GRID_H;
		//	colorBackground[] = {0.788,0.443,0.157,1};
		//	colorText[] = {0.788,0.443,0.157,1};
		//};
		class CivInteract_Detain: CivInteract_RscButton
		{
			idc = 92311;
			action = "[SpyderAddons_civilianInteraction,'Detain'] call SpyderAddons_fnc_civilianInteraction";

			text = "Detain";
			x = 7.5 * GUI_GRID_W + GUI_GRID_X;
			y = 23.25 * GUI_GRID_H + GUI_GRID_Y;
			w = 5.5 * GUI_GRID_W;
			h = 1.2 * GUI_GRID_H;
			colorBackground[] = {0,0,0,0.5};
			sizeEx = .85 * GUI_GRID_H;
		};
		class CivInteract_GetDown: CivInteract_RscButton
		{
			idc = 92312;
			action = "[SpyderAddons_civilianInteraction,'getDown'] call SpyderAddons_fnc_civilianInteraction";

			text = "Get Down";
			x = 13.5 * GUI_GRID_W + GUI_GRID_X;
			y = 23.25 * GUI_GRID_H + GUI_GRID_Y;
			w = 5.5 * GUI_GRID_W;
			h = 1.2 * GUI_GRID_H;
			colorBackground[] = {0,0,0,0.5};
			sizeEx = .85 * GUI_GRID_H;
		};
		class CivInteract_GoAway: CivInteract_RscButton
		{
			idc = 92313;
			action = "[SpyderAddons_civilianInteraction,'goAway'] call SpyderAddons_fnc_civilianInteraction";

			text = "Go Away";
			x = 19.5 * GUI_GRID_W + GUI_GRID_X;
			y = 23.25 * GUI_GRID_H + GUI_GRID_Y;
			w = 5.5 * GUI_GRID_W;
			h = 1.2 * GUI_GRID_H;
			colorBackground[] = {0,0,0,0.5};
			sizeEx = .85 * GUI_GRID_H;
		};
		class CivInteract_Close: CivInteract_RscButton
		{
			idc = 9237;
			action = "closeDialog 0";

			text = "Close";
			x = -2 * GUI_GRID_W + GUI_GRID_X;
			y = 23.25 * GUI_GRID_H + GUI_GRID_Y;
			w = 5.5 * GUI_GRID_W;
			h = 1.2 * GUI_GRID_H;
			colorBackground[] = {0,0,0,0.5};
			sizeEx = .85 * GUI_GRID_H;
		};
		class CivInteract_Search: CivInteract_RscButton
		{
			idc = 9242;
			action = "[SpyderAddons_civilianInteraction,'toggleSearchMenu'] call SpyderAddons_fnc_inventoryHandler";

			text = "Search";
			tooltip = "Search the civilian's inventory";
			x = 28.5 * GUI_GRID_W + GUI_GRID_X;
			y = 23.25 * GUI_GRID_H + GUI_GRID_Y;
			w = 5.5 * GUI_GRID_W;
			h = 1.2 * GUI_GRID_H;
			colorBackground[] = {0,0,0,0.5};
			sizeEx = .85 * GUI_GRID_H;
		};

		class CivInteract_inventory_GearList: CivInteract_RscListNBox
		{
			idc = 9244;

			x = 34.95 * GUI_GRID_W + GUI_GRID_X;
			y = -1.5 * GUI_GRID_H + GUI_GRID_Y;
			w = 13.5 * GUI_GRID_W;
			h = 24 * GUI_GRID_H;
			colorBackground[] = {0,0,0,0};
			rowHeight = 0.08;
			sizeEx = 0.6 * GUI_GRID_H;
		};
		class CivInteract_inventory_ButtonTwo: CivInteract_RscButton
		{
			idc = 9245;
			action = "";

			text = "";
			x = 34.5 * GUI_GRID_W + GUI_GRID_X;
			y = 24.8 * GUI_GRID_H + GUI_GRID_Y;
			w = 14.5 * GUI_GRID_W;
			h = 1.2 * GUI_GRID_H;
			colorBackground[] = {0,0,0,0.5};
			sizeEx = .85 * GUI_GRID_H;
		};
		class CivInteract_inventory_ButtonThree: CivInteract_RscButton
		{
			idc = 9246;
			action = "";

			text = "";
			x = 34.5 * GUI_GRID_W + GUI_GRID_X;
			y = 26.35 * GUI_GRID_H + GUI_GRID_Y;
			w = 14.5 * GUI_GRID_W;
			h = 1.2 * GUI_GRID_H;
			colorBackground[] = {0,0,0,0.5};
			sizeEx = .85 * GUI_GRID_H;
		};

	};
};