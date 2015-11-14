//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////				 Loadout Manager							/////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

#include "common.hpp"

//-- GUI editor: configfile >> "Loadout_Manager"

class Loadout_Manager
{
	idd = 721;
	movingEnable = 1;
	onLoad = "";
	onUnload = "SpyderAddons_LoadoutManager_Logic = nil";
	class controls 
	{

		class LoadoutManager_Background: LoadoutManager_RscText
		{
			idc = 7211;

			x = 0 * GUI_GRID_W + GUI_GRID_X;
			y = 5.5 * GUI_GRID_H + GUI_GRID_Y;
			w = 25 * GUI_GRID_W;
			h = 15.5 * GUI_GRID_H;
			colorBackground[] = {0,0,0,0.55};
			colorActive[] = {0,0,0,0.55};
		};
		class LoadoutManager_Header: LoadoutManager_RscText
		{
			idc = 7212;

			text = "Loadout Organizer";
			x = 0 * GUI_GRID_W + GUI_GRID_X;
			y = 4.5 * GUI_GRID_H + GUI_GRID_Y;
			w = 25 * GUI_GRID_W;
			h = 1 * GUI_GRID_H;
			colorBackground[] = {0.788,0.443,0.157,0.65};
			colorActive[] = {0.788,0.443,0.157,0.65};
			sizeEx = .8 * GUI_GRID_H;
		};
		class LoadoutManager_LoadoutHeader: LoadoutManager_RscText
		{
			idc = 7214;

			text = "Loadouts";
			x = 3.5 * GUI_GRID_W + GUI_GRID_X;
			y = 6 * GUI_GRID_H + GUI_GRID_Y;
			w = 4.5 * GUI_GRID_W;
			h = 1 * GUI_GRID_H;
			colorActive[] = {0,0,0,0};
			sizeEx = .9 * GUI_GRID_H;
		};
		class LoadoutManager_ClassLister: LoadoutManager_RscListBox
		{
			idc = 7217;

			x = 0.65 * GUI_GRID_W + GUI_GRID_X;
			y = 7.5 * GUI_GRID_H + GUI_GRID_Y;
			w = 11.95 * GUI_GRID_W;
			h = 11.5 * GUI_GRID_H;
			colorBackground[] = {0,0,0,0};
			colorActive[] = {0,0,0,0};
			sizeEx = .75 * GUI_GRID_H;
		};
		class LoadoutManager_GearList: LoadoutManager_ListNBox
		{
			idc = 72124;
			x = 12.7 * GUI_GRID_W + GUI_GRID_X;
			y = 7.5 * GUI_GRID_H + GUI_GRID_Y;
			w = 12.2 * GUI_GRID_W;
			h = 11.5 * GUI_GRID_H;
			sizeEx = .55 * GUI_GRID_H;
			colorBackground[] = {0,0,0,0};
			colorActive[] = {0,0,0,0};
		};
		class LoadoutManager_TypeBox: LoadoutManager_RscEdit
		{
			idc = 7215;

			x = 0.54 * GUI_GRID_W + GUI_GRID_X;
			y = 19.5 * GUI_GRID_H + GUI_GRID_Y;
			w = 11.5 * GUI_GRID_W;
			h = 1 * GUI_GRID_H;
			colorBackground[] = {0,0,0,0};
			colorActive[] = {0,0,0,0};
			sizeEx = .75 * GUI_GRID_H;
		};
		class LoadoutManager_Rename: LoadoutManager_RscButton
		{
			idc = 7219;
			action = "['renameClass'] call SpyderAddons_fnc_loadoutManager";

			text = "Rename";
			x = 13 * GUI_GRID_W + GUI_GRID_X;
			y = 19.5 * GUI_GRID_H + GUI_GRID_Y;
			w = 5 * GUI_GRID_W;
			h = 1.2 * GUI_GRID_H;
			colorBackground[] = {0,0,0,0.4};
			colorActive[] = {0,0,0,0.4};
			sizeEx = .8 * GUI_GRID_H;
		};
		class LoadoutManager_Arsenal: LoadoutManager_RscButton
		{
			idc = 72120;
			action = "['openArsenal'] spawn SpyderAddons_fnc_loadoutManager";

			text = "Arsenal";
			x = 18.5 * GUI_GRID_W + GUI_GRID_X;
			y = 19.5 * GUI_GRID_H + GUI_GRID_Y;
			w = 5.5 * GUI_GRID_W;
			h = 1.2 * GUI_GRID_H;
			colorBackground[] = {0,0,0,0.4};
			colorActive[] = {0,0,0,0.4};
			sizeEx = .8 * GUI_GRID_H;
		};
		class LoadoutManager_Delete: LoadoutManager_RscButton
		{
			idc = 72125;
			action = "['deleteClass'] call SpyderAddons_fnc_loadoutManager";

			text = "Delete";
			x = 0 * GUI_GRID_W + GUI_GRID_X;
			y = 21.2 * GUI_GRID_H + GUI_GRID_Y;
			w = 3 * GUI_GRID_W;
			h = 1.2 * GUI_GRID_H;
			colorBackground[] = {0,0,0,0.5};
			colorActive[] = {0,0,0,0.55};
			sizeEx = .8 * GUI_GRID_H;
		};
		class LoadoutManager_Save: LoadoutManager_RscButton
		{
			idc = 7216;
			action = "['saveClass'] call SpyderAddons_fnc_loadoutManager";

			text = "Save";
			x = 3.5 * GUI_GRID_W + GUI_GRID_X;
			y = 21.2 * GUI_GRID_H + GUI_GRID_Y;
			w = 3 * GUI_GRID_W;
			h = 1.2 * GUI_GRID_H;
			colorBackground[] = {0,0,0,0.5};
			colorActive[] = {0,0,0,0.5};
			sizeEx = .8 * GUI_GRID_H;
		};
		class LoadoutManager_Load: LoadoutManager_RscButton
		{
			idc = 7218;
			action = "['loadClass'] call SpyderAddons_fnc_loadoutManager";

			text = "Load";
			x = 7 * GUI_GRID_W + GUI_GRID_X;
			y = 21.2 * GUI_GRID_H + GUI_GRID_Y;
			w = 3 * GUI_GRID_W;
			h = 1.2 * GUI_GRID_H;
			colorBackground[] = {0,0,0,0.5};
			colorActive[] = {0,0,0,0.5};
			sizeEx = .8 * GUI_GRID_H;
		};
		class LoadoutManager_Transfer: LoadoutManager_RscButton
		{
			idc = 72122;
			action = "['openTransferMenu'] call SpyderAddons_fnc_loadoutManager";

			text = "Transfer";
			x = 10.5 * GUI_GRID_W + GUI_GRID_X;
			y = 21.2 * GUI_GRID_H + GUI_GRID_Y;
			w = 5.5 * GUI_GRID_W;
			h = 1.2 * GUI_GRID_H;
			colorBackground[] = {0,0,0,0.5};
			colorActive[] = {0,0,0,0.5};
			sizeEx = .8 * GUI_GRID_H;
		};
		class LoadoutManager_LoadOnRespawn: LoadoutManager_RscButton
		{
			idc = 72121;
			action = "['loadOnRespawn'] call SpyderAddons_fnc_loadoutManager";

			text = "Load on respawn";
			x = 16.5 * GUI_GRID_W + GUI_GRID_X;
			y = 21.2 * GUI_GRID_H + GUI_GRID_Y;
			w = 8.5 * GUI_GRID_W;
			h = 1.2 * GUI_GRID_H;
			colorBackground[] = {0,0,0,0.5};
			colorActive[] = {0,0,0,0.5};
			sizeEx = .8 * GUI_GRID_H;
		};
		class LoadoutManager_Close: LoadoutManager_RscButton
		{
			idc = 7213;
			action = "closeDialog 0";

			text = "Close";
			x = 0 * GUI_GRID_W + GUI_GRID_X;
			y = 22.6 * GUI_GRID_H + GUI_GRID_Y;
			w = 3 * GUI_GRID_W;
			h = 1.2 * GUI_GRID_H;
			colorBackground[] = {0,0,0,0.5};
			colorActive[] = {0,0,0,0.55};
			sizeEx = .8 * GUI_GRID_H;
		};
		class LoadoutManager_GearTitle: LoadoutManager_RscText
		{
			idc = 72123;
			text = "Gear";
			x = 17 * GUI_GRID_W + GUI_GRID_X;
			y = 6.2 * GUI_GRID_H + GUI_GRID_Y;
			w = 2 * GUI_GRID_W;
			h = 1 * GUI_GRID_H;
			sizeEx = .8 * GUI_GRID_H;
		};
		class LoadoutManager_Border1: LoadoutManager_RscText
		{
			idc = -1;

			x = 0.5 * GUI_GRID_W + GUI_GRID_X;
			y = 7.4 * GUI_GRID_H + GUI_GRID_Y;
			w = 0.15 * GUI_GRID_W;
			h = 11.66 * GUI_GRID_H;
			colorBackground[] = {0.722,0.694,0.62,0.4};
			colorActive[] = {0.722,0.694,0.62,0.4};
		};
		class LoadoutManager_Border2: LoadoutManager_RscText
		{
			idc = -1;

			x = 0.5 * GUI_GRID_W + GUI_GRID_X;
			y = 19 * GUI_GRID_H + GUI_GRID_Y;
			w = 12.15 * GUI_GRID_W;
			h = 0.15 * GUI_GRID_H;
			colorBackground[] = {0.722,0.694,0.62,0.4};
			colorActive[] = {0.722,0.694,0.62,0.4};
		};
		class LoadoutManager_Border3: LoadoutManager_RscText
		{
			idc = -1;

			x = 0.5 * GUI_GRID_W + GUI_GRID_X;
			y = 7.25 * GUI_GRID_H + GUI_GRID_Y;
			w = 12.15 * GUI_GRID_W;
			h = 0.15 * GUI_GRID_H;
			colorBackground[] = {0.722,0.694,0.62,0.4};
			colorActive[] = {0.722,0.694,0.62,0.4};
		};
		class LoadoutManager_Border4: LoadoutManager_RscText
		{
			idc = -1;

			x = 12.5 * GUI_GRID_W + GUI_GRID_X;
			y = 7.4 * GUI_GRID_H + GUI_GRID_Y;
			w = 0.15 * GUI_GRID_W;
			h = 11.66 * GUI_GRID_H;
			colorBackground[] = {0.722,0.694,0.62,0.4};
			colorActive[] = {0.722,0.694,0.62,0.4};
		};

};
};

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////				 Transfer Loadout							/////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//-- GUI editor: configfile >> "Transfer_Loadout"

class Transfer_Loadout
{
	idd = 719;
	movingEnable = 1;
   	onLoad = "";
	onUnload = "LoadoutManager_TransferLoadout = nil";
	class controls 
	{

		class TransferLoadout_Background: LoadoutManager_RscText
		{
			idc = 7191;
			x = 7.5 * GUI_GRID_W + GUI_GRID_X;
			y = 7.5 * GUI_GRID_H + GUI_GRID_Y;
			w = 11 * GUI_GRID_W;
			h = 13 * GUI_GRID_H;
			colorBackground[] = {0,0,0,0.55};
			colorActive[] = {0,0,0,0.55};
		};
		class TransferLoadout_Title: LoadoutManager_RscText
		{
			idc = 7192;

			text = "Transfer Loadout";
			x = 7.5 * GUI_GRID_W + GUI_GRID_X;
			y = 6.5 * GUI_GRID_H + GUI_GRID_Y;
			w = 11 * GUI_GRID_W;
			h = 1 * GUI_GRID_H;
			colorBackground[] = {0.788,0.443,0.157,0.65};
			colorActive[] = {0.788,0.443,0.157,0.65};
			sizeEx = .8 * GUI_GRID_H;
		};
		class TransferLoadout_CancelButton: LoadoutManager_RscButton
		{
			idc = 7193;
			action = "closeDialog 0";

			text = "Cancel";
			x = 7.5 * GUI_GRID_W + GUI_GRID_X;
			y = 20.7 * GUI_GRID_H + GUI_GRID_Y;
			w = 5 * GUI_GRID_W;
			h = 1.2 * GUI_GRID_H;
			colorBackground[] = {0,0,0,0.5};
			colorActive[] = {0,0,0,0.5};
			sizeEx = .8 * GUI_GRID_H;
		};
		class TransferLoadout_TransferButton: LoadoutManager_RscButton
		{
			idc = 7194;
			action = "['sendLoadout'] call SpyderAddons_fnc_loadoutManager";

			text = "Transfer";
			x = 13.5 * GUI_GRID_W + GUI_GRID_X;
			y = 20.7 * GUI_GRID_H + GUI_GRID_Y;
			w = 5 * GUI_GRID_W;
			h = 1.2 * GUI_GRID_H;
			colorBackground[] = {0,0,0,0.5};
			colorActive[] = {0,0,0,5};
			sizeEx = .8 * GUI_GRID_H;
		};
		class TransferLoadout_UnitsTitle: LoadoutManager_RscText
		{
			idc = 7195;
			text = "Units";
			x = 10.5 * GUI_GRID_W + GUI_GRID_X;
			y = 8 * GUI_GRID_H + GUI_GRID_Y;
			w = 2.5 * GUI_GRID_W;
			h = 1.5 * GUI_GRID_H;
			sizeEx = .9 * GUI_GRID_H;
		};
		class TransferLoadout_UnitLister: LoadoutManager_RscListbox
		{
			idc = 7199;
			x = 8.6 * GUI_GRID_W + GUI_GRID_X;
			y = 10 * GUI_GRID_H + GUI_GRID_Y;
			w = 8.2 * GUI_GRID_W;
			h = 9.5 * GUI_GRID_H;
			colorBackground[] = {0,0,0,0};
			colorActive[] = {0,0,0,0};
			sizeEx = .75 * GUI_GRID_H;
		};
		class TransferLoadout_BorderLeft: LoadoutManager_RscText
		{
			idc = 7196;
			x = 8.5 * GUI_GRID_W + GUI_GRID_X;
			y = 9.63 * GUI_GRID_H + GUI_GRID_Y;
			w = 0.15 * GUI_GRID_W;
			h = 9.86 * GUI_GRID_H;
			colorBackground[] = {0.722,0.694,0.62,0.4};
			colorActive[] = {0.722,0.694,0.62,0.4};
		};
		class TransferLoadout_BorderRight: LoadoutManager_RscText
		{
			idc = 7197;
			x = 17 * GUI_GRID_W + GUI_GRID_X;
			y = 9.63 * GUI_GRID_H + GUI_GRID_Y;
			w = 0.15 * GUI_GRID_W;
			h = 9.86 * GUI_GRID_H;
			colorBackground[] = {0.722,0.694,0.62,0.4};
			colorActive[] = {0.722,0.694,0.62,0.4};
		};
		class TransferLoadout_BorderBottom: LoadoutManager_RscText
		{
			idc = 7198;
			x = 8.5 * GUI_GRID_W + GUI_GRID_X;
			y = 19.5 * GUI_GRID_H + GUI_GRID_Y;
			w = 8.65 * GUI_GRID_W;
			h = 0.15 * GUI_GRID_H;
			colorBackground[] = {0.722,0.694,0.62,0.4};
			colorActive[] = {0.722,0.694,0.62,0.4};
		};
		class TransferLoadout_BorderTop: LoadoutManager_RscText
		{
			idc = 71910;
			x = 8.5 * GUI_GRID_W + GUI_GRID_X;
			y = 9.5 * GUI_GRID_H + GUI_GRID_Y;
			w = 8.65 * GUI_GRID_W;
			h = 0.15 * GUI_GRID_H;
			colorBackground[] = {0.722,0.694,0.62,0.4};
			colorActive[] = {0.722,0.694,0.62,0.4};
		};

	};
};

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////				 Receive Loadout							/////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//-- GUI editor: configfile >> "Receive_Loadout"

class Receive_Loadout
{
	idd = 718;
	movingEnable = 1;
   	onLoad = "";
	onUnload = "LoadoutManager_TransferLoadout = nil";
	class controls 
	{

		class ReceiveLoadout_Background: LoadoutManager_RscText
		{
			idc = 7181;
			x = 2 * GUI_GRID_W + GUI_GRID_X;
			y = 10.5 * GUI_GRID_H + GUI_GRID_Y;
			w = 15 * GUI_GRID_W;
			h = 4 * GUI_GRID_H;
			colorBackground[] = {0,0,0,0.5};
			colorActive[] = {0,0,0,0.5};
		};
		class ReceiveLoadout_Header: LoadoutManager_RscText
		{
			idc = 7182;

			text = "Receive Loadout";
			x = 2 * GUI_GRID_W + GUI_GRID_X;
			y = 9.5 * GUI_GRID_H + GUI_GRID_Y;
			w = 15 * GUI_GRID_W;
			h = 1 * GUI_GRID_H;
			colorBackground[] = {0.788,0.443,0.157,0.65};
			colorActive[] = {0.788,0.443,0.157,0.65};
			sizeEx = .8 * GUI_GRID_H;
		};
		class ReceiveLoadout_Decline: LoadoutManager_RscButton
		{
			idc = 7183;
			action = "closeDialog 0";

			text = "Decline";
			x = 2 * GUI_GRID_W + GUI_GRID_X;
			y = 14.7 * GUI_GRID_H + GUI_GRID_Y;
			w = 6.5 * GUI_GRID_W;
			h = 1.2 * GUI_GRID_H;
			colorBackground[] = {0,0,0,0.4};
			colorActive[] = {0,0,0,0.4};
			sizeEx = .8 * GUI_GRID_H;
		};
		class ReceiveLoadout_Accept: LoadoutManager_RscButton
		{
			idc = 7184;
			action = "['loadClass', [player, LoadoutManager_TransferLoadout]] call SpyderAddons_fnc_loadoutManager; closeDialog 0";

			text = "Accept";
			x = 10.5 * GUI_GRID_W + GUI_GRID_X;
			y = 14.7 * GUI_GRID_H + GUI_GRID_Y;
			w = 6.5 * GUI_GRID_W;
			h = 1.2 * GUI_GRID_H;
			colorBackground[] = {0,0,0,0.4};
			colorActive[] = {0,0,0,0.4};
			sizeEx = .8 * GUI_GRID_H;
		};
		class ReceiveLoadout_TextBox: LoadoutManager_RscStructuredText
		{
			idc = 7185;
			text = "";
			x = 2.5 * GUI_GRID_W + GUI_GRID_X;
			y = 11 * GUI_GRID_H + GUI_GRID_Y;
			w = 14 * GUI_GRID_W;
			h = 3 * GUI_GRID_H;
			colorBackground[] = {0,0,0,0};
			colorActive[] = {0,0,0,0};
			sizeEx = .35 * GUI_GRID_H;
		};

	};
};