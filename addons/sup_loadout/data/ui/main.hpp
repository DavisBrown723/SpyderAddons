//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////				 Loadout Manager							/////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

#include "common.hpp"

//-- GUI editor: configfile >> "Loadout_Manager"

class Loadout_Manager
{
	idd = 721;
	movingEnable = 1;
	onUnload = "[SpyderAddons_loadoutManager,'onUnload'] call SpyderAddons_fnc_loadoutManager";

	class controlsBackground {
		class LoadoutManager_Background: LoadoutManager_RscText
		{
			idc = -1;

			x = 0.5 * GUI_GRID_W + GUI_GRID_X;
			y = -3 * GUI_GRID_H + GUI_GRID_Y;
			w = 39 * GUI_GRID_W;
			h = 29.5 * GUI_GRID_H;
			colorBackground[] = {0,0,0,0.6};
		};
		class LoadoutManager_Title: LoadoutManager_RscText
		{
			idc = -1;

			text = "Loadout Manager";
			x = 0.5 * GUI_GRID_W + GUI_GRID_X;
			y = -4 * GUI_GRID_H + GUI_GRID_Y;
			w = 39 * GUI_GRID_W;
			h = 1 * GUI_GRID_H;
			colorBackground[] = {0.788,0.443,0.157,0.65};
		};

		class LoadoutManager_ListLeftTitle: LoadoutManager_RscText
		{
			idc = 7210;

			text = "Classes";
			style = 0x02;
			x = 1 * GUI_GRID_W + GUI_GRID_X;
			y = -2.5 * GUI_GRID_H + GUI_GRID_Y;
			w = 16 * GUI_GRID_W;
			h = 1 * GUI_GRID_H;
			sizeEx = 1 * GUI_GRID_H;
		};
		class LoadoutManager_ListRightTitle: LoadoutManager_RscText
		{
			idc = 7211;

			text = "";
			style = 0x02;
			x = 23 * GUI_GRID_W + GUI_GRID_X;
			y = -2.5 * GUI_GRID_H + GUI_GRID_Y;
			w = 15.5 * GUI_GRID_W;
			h = 1 * GUI_GRID_H;
			sizeEx = 1 * GUI_GRID_H;
		};

		class LoadoutManager_InstructionsLeftTop: LoadoutManager_RscText
		{
			idc = 7212;
			x = 1 * GUI_GRID_W + GUI_GRID_X;
			y = -1.15 * GUI_GRID_H + GUI_GRID_Y;
			w = 16 * GUI_GRID_W;
			h = 0.5 * GUI_GRID_H;
			sizeEx = .6 * GUI_GRID_H;
		};
		class LoadoutManager_InstructionsRightTop: LoadoutManager_RscText
		{
			idc = 7213;
			x = 23 * GUI_GRID_W + GUI_GRID_X;
			y = -1.15 * GUI_GRID_H + GUI_GRID_Y;
			w = 16 * GUI_GRID_W;
			h = 0.5 * GUI_GRID_H;
			sizeEx = .6 * GUI_GRID_H;
		};

		class LoadoutManager_ListLeftFrame: LoadoutManager_RscFrame
		{
			idc = -1;

			x = 1 * GUI_GRID_W + GUI_GRID_X;
			y = -0.5 * GUI_GRID_H + GUI_GRID_Y;
			w = 16 * GUI_GRID_W;
			h = 25 * GUI_GRID_H;
			colorBackground[] = {-1,-1,-1,0.5};
		};
		class LoadoutManager_ListRightFrame: LoadoutManager_RscFrame
		{
			idc = -1;

			x = 23 * GUI_GRID_W + GUI_GRID_X;
			y = -0.5 * GUI_GRID_H + GUI_GRID_Y;
			w = 16 * GUI_GRID_W;
			h = 25 * GUI_GRID_H;
			colorBackground[] = {-1,-1,-1,0.5};
		};

	};

	class controls {

		class LoadoutManager_ListLeft: LoadoutManager_RscListNBox
		{
			idc = 7214;

			x = 1 * GUI_GRID_W + GUI_GRID_X;
			y = -.5 * GUI_GRID_H + GUI_GRID_Y;
			w = 16 * GUI_GRID_W;
			h = 25 * GUI_GRID_H;
			colorBackground[] = {0.302,0.302,0.302,0.5};
		};

		class LoadoutManager_CreateFolder: LoadoutManager_RscButton
		{
			idc = 7215;
			action = "[SpyderAddons_loadoutManager,'createFolder'] call SpyderAddons_fnc_loadoutManager";

			text = "Create Folder";
			x = 17.5 * GUI_GRID_W + GUI_GRID_X;
			y = .5 * GUI_GRID_H + GUI_GRID_Y;
			w = 5 * GUI_GRID_W;
			h = 1.25 * GUI_GRID_H;
			colorBackground[] = {-1,-1,-1,.8};
			sizeEx = .75 * GUI_GRID_H;
		};
		class LoadoutManager_OpenFolder: LoadoutManager_RscButton
		{
			idc = 7227;
			action = "[SpyderAddons_loadoutManager,'openFolder'] call SpyderAddons_fnc_loadoutManager";

			text = "Open Folder";
			x = 17.5 * GUI_GRID_W + GUI_GRID_X;
			y = 2.5 * GUI_GRID_H + GUI_GRID_Y;
			w = 5 * GUI_GRID_W;
			h = 1.25 * GUI_GRID_H;
			colorBackground[] = {-1,-1,-1,0.8};
			sizeEx = .75 * GUI_GRID_H;
		};
		class LoadoutManager_CloseFolder: LoadoutManager_RscButton
		{
			idc = 7228;
			action = "[SpyderAddons_loadoutManager,'closeFolder'] call SpyderAddons_fnc_loadoutManager";

			text = "Close Folder";
			x = 17.5 * GUI_GRID_W + GUI_GRID_X;
			y = 4.5 * GUI_GRID_H + GUI_GRID_Y;
			w = 5 * GUI_GRID_W;
			h = 1.25 * GUI_GRID_H;
			colorBackground[] = {-1,-1,-1,0.8};
			sizeEx = .75 * GUI_GRID_H;
		};

		class LoadoutManager_Transfer: LoadoutManager_RscButton
		{
			idc = 7219;

			text = "Transfer";
			action = "[SpyderAddons_loadoutManager,'transferSlot'] call SpyderAddons_fnc_loadoutManager";
			x = 17.5 * GUI_GRID_W + GUI_GRID_X;
			y = 8 * GUI_GRID_H + GUI_GRID_Y;
			w = 5 * GUI_GRID_W;
			h = 1.25 * GUI_GRID_H;
			colorBackground[] = {-1,-1,-1,.8};
			sizeEx = .75 * GUI_GRID_H;
		};
		class LoadoutManager_Rename: LoadoutManager_RscButton
		{
			idc = 7218;
			action = "[SpyderAddons_loadoutManager,'renameSlot'] call SpyderAddons_fnc_loadoutManager";

			text = "Rename";
			x = 17.5 * GUI_GRID_W + GUI_GRID_X;
			y = 10 * GUI_GRID_H + GUI_GRID_Y;
			w = 5 * GUI_GRID_W;
			h = 1.25 * GUI_GRID_H;
			colorBackground[] = {-1,-1,-1,.8};
			sizeEx = .75 * GUI_GRID_H;
		};
		class LoadoutManager_Delete: LoadoutManager_RscButton
		{
			idc = 7221;
			action = "[SpyderAddons_loadoutManager,'deleteSlot'] call SpyderAddons_fnc_loadoutManager";

			text = "Delete";
			x = 17.5 * GUI_GRID_W + GUI_GRID_X;
			y = 12 * GUI_GRID_H + GUI_GRID_Y;
			w = 5 * GUI_GRID_W;
			h = 1.25 * GUI_GRID_H;
			colorBackground[] = {-1,-1,-1,.8};
			sizeEx = .75 * GUI_GRID_H;
		};
		class LoadoutManager_Move: LoadoutManager_RscButton
		{
			idc = 7229;
			action = "[SpyderAddons_loadoutManager,'moveSlot'] call SpyderAddons_fnc_loadoutManager";

			text = "Move";
			x = 17.5 * GUI_GRID_W + GUI_GRID_X;
			y = 14 * GUI_GRID_H + GUI_GRID_Y;
			w = 5 * GUI_GRID_W;
			h = 1.25 * GUI_GRID_H;
			colorBackground[] = {-1,-1,-1,0.8};
			sizeEx = .75 * GUI_GRID_H;
		};

		class LoadoutManager_Load: LoadoutManager_RscButton
		{
			idc = 7216;
			action = "[SpyderAddons_loadoutManager,'loadClass'] call SpyderAddons_fnc_loadoutManager";

			text = "Load Class";
			x = 17.5 * GUI_GRID_W + GUI_GRID_X;
			y = 18 * GUI_GRID_H + GUI_GRID_Y;
			w = 5 * GUI_GRID_W;
			h = 1.25 * GUI_GRID_H;
			colorBackground[] = {-1,-1,-1,.8};
			sizeEx = .75 * GUI_GRID_H;
		};
		class LoadoutManager_Save: LoadoutManager_RscButton
		{
			idc = 7217;
			action = "[SpyderAddons_loadoutManager,'saveClass'] call SpyderAddons_fnc_loadoutManager";

			text = "Save Class";
			x = 17.5 * GUI_GRID_W + GUI_GRID_X;
			y = 20 * GUI_GRID_H + GUI_GRID_Y;
			w = 5 * GUI_GRID_W;
			h = 1.25 * GUI_GRID_H;
			colorBackground[] = {-1,-1,-1,.8};
			sizeEx = .75 * GUI_GRID_H;
		};
		class LoadoutManager_LoadOnRespawn: LoadoutManager_RscButton
		{
			idc = 7220;
			action = "[SpyderAddons_loadoutManager,'setLoadOnRespawn'] call SpyderAddons_fnc_loadoutManager";

			text = "Load on Respawn";
			x = 17.5 * GUI_GRID_W + GUI_GRID_X;
			y = 22 * GUI_GRID_H + GUI_GRID_Y;
			w = 5 * GUI_GRID_W;
			h = 1.25 * GUI_GRID_H;
			colorBackground[] = {-1,-1,-1,.8};
			sizeEx = .6 * GUI_GRID_H;
		};

		class LoadoutManager_ListRight: LoadoutManager_RscListNBox
		{
			idc = 7222;
			rowHeight = 0.07;

			x = 23 * GUI_GRID_W + GUI_GRID_X;
			y = -.5 * GUI_GRID_H + GUI_GRID_Y;
			w = 16 * GUI_GRID_W;
			h = 25 * GUI_GRID_H;
			colorBackground[] = {0.302,0.302,0.302,0.5};
		};

		class LoadoutManager_InputBox: LoadoutManager_RscEdit
		{
			idc = 7223;

			text = "New Slot";
			x = 1 * GUI_GRID_W + GUI_GRID_X;
			y = 24.75 * GUI_GRID_H + GUI_GRID_Y;
			w = 16 * GUI_GRID_W;
			h = 1.5 * GUI_GRID_H;
			colorBackground[] = {-1,-1,-1,.8};
		};
		class LoadoutManager_ButtonRightBlank: LoadoutManager_RscButton
		{
			idc = 7224;

			x = 23 * GUI_GRID_W + GUI_GRID_X;
			y = 24.75 * GUI_GRID_H + GUI_GRID_Y;
			w = 16 * GUI_GRID_W;
			h = 1.5 * GUI_GRID_H;
			colorBackground[] = {-1,-1,-1,0.65};
		};

		class LoadoutManager_Close: LoadoutManager_RscButton
		{
			idc = 7225;
			action = "closeDialog 0";

			text = "Close";
			x = 0.5 * GUI_GRID_W + GUI_GRID_X;
			y = 26.75 * GUI_GRID_H + GUI_GRID_Y;
			w = 5 * GUI_GRID_W;
			h = 1.25 * GUI_GRID_H;
		};
		class LoadoutManager_Arsenal: LoadoutManager_RscButton
		{
			idc = 7226;
			action = "[SpyderAddons_loadoutManager,'openArsenal'] spawn SpyderAddons_fnc_loadoutManager";

			text = "Arsenal";
			x = 30 * GUI_GRID_W + GUI_GRID_X;
			y = 26.75 * GUI_GRID_H + GUI_GRID_Y;
			w = 9.5 * GUI_GRID_W;
			h = 1.25 * GUI_GRID_H;
			colorBackground[] = {-1,-1,-1,0.65};
		};
	};
};