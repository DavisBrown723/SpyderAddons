#include "common.hpp"

class SpyderAddons_LoadoutManager {
    idd = 7200;
    movingEnable = 1;
    onUnload = "['onUnload', _this] call SpyderAddons_fnc_loadoutManagerOnAction";

    class controlsBackground {

        class SpyderAddons_LoadoutManager_Background: LoadoutManager_RscText {
            idc = 7201;

            x = 0.2375 * safezoneW + safezoneX;
            y = 0.15 * safezoneH + safezoneY;
            w = 0.35 * safezoneW;
            h = 0.658 * safezoneH;
            colorBackground[] = {0,0,0,0.5};
        };

        class SpyderAddons_LoadoutManager_Title: LoadoutManager_RscText {
            idc = 7202;
            moving = 1;

            text = "Loadout Manager";
            x = 0.2375 * safezoneW + safezoneX;
            y = 0.122 * safezoneH + safezoneY;
            w = 0.35 * safezoneW;
            h = 0.028 * safezoneH;
            colorBackground[] = MOD_COLOR_MAIN;
            sizeEx = "(((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 0.7)";
        };

        class SpyderAddons_LoadoutManager_HeaderLeft: LoadoutManager_RscText {
            idc = 7203;

            style = 0x02;
            text = "Loadouts";
            x = 0.244792 * safezoneW + safezoneX;
            y = 0.164 * safezoneH + safezoneY;
            w = 0.167708 * safezoneW;
            h = 0.042 * safezoneH;
            sizeEx = "(((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 1.1)";
        };

        class SpyderAddons_LoadoutManager_HeaderRight: LoadoutManager_RscText {
            idc = 7204;

            style = 0x02;
            x = 0.4125 * safezoneW + safezoneX;
            y = 0.164 * safezoneH + safezoneY;
            w = 0.167708 * safezoneW;
            h = 0.042 * safezoneH;
            sizeEx = "(((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 1.1)";
        };

        class SpyderAddons_LoadoutManager_InstructionsLeft: LoadoutManager_RscText {
            idc = 7225;

            x = 0.241875 * safezoneW + safezoneX;
            y = 0.2564 * safezoneH + safezoneY;
            w = 0.167708 * safezoneW;
            h = 0.014 * safezoneH;
            sizeEx = "(((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 0.6)";
        };

        class SpyderAddons_LoadoutManager_InstructionsRight: LoadoutManager_RscText {
            idc = 7205;

            x = 0.409583 * safezoneW + safezoneX;
            y = 0.2564 * safezoneH + safezoneY;
            w = 0.167708 * safezoneW;
            h = 0.014 * safezoneH;
            sizeEx = "(((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 0.6)";
        };

        class SpyderAddons_LoadoutManager_FrameLeft: RscFrame {
            idc = 7206;

            x = 0.244792 * safezoneW + safezoneX;
            y = 0.276 * safezoneH + safezoneY;
            w = 0.153125 * safezoneW;
            h = 0.266 * safezoneH;
        };

        class SpyderAddons_LoadoutManager_FrameRight: RscFrame {
            idc = 7207;

            x = 0.4125 * safezoneW + safezoneX;
            y = 0.276 * safezoneH + safezoneY;
            w = 0.167708 * safezoneW;
            h = 0.266 * safezoneH;
        };

    };

    class controls {

        class SpyderAddons_LoadoutManager_ComboLeft: RscCombo {
            idc = 7208;

            x = 0.244792 * safezoneW + safezoneX;
            y = 0.206 * safezoneH + safezoneY;
            w = 0.153125 * safezoneW;
            h = 0.028 * safezoneH;
        };
        class SpyderAddons_LoadoutManager_ListLeft: LoadoutManager_RscListBox {
            idc = 7209;

            candrag = 1;
            x = 0.244792 * safezoneW + safezoneX;
            y = 0.276 * safezoneH + safezoneY;
            w = 0.153125 * safezoneW;
            h = 0.2632 * safezoneH;
        };
        class SpyderAddons_LoadoutManager_ListRight: LoadoutManager_RscListBox {
            idc = 7210;

            sizeEx = 0.0225;
            x = 0.4125 * safezoneW + safezoneX;
            y = 0.276 * safezoneH + safezoneY;
            w = 0.167708 * safezoneW;
            h = 0.2632 * safezoneH;
        };
        class SpyderAddons_LoadoutManager_Button1: LoadoutManager_RscButton {
            idc = 7211;

            text = "Button 1";
            x = 0.244792 * safezoneW + safezoneX;
            y = 0.57 * safezoneH + safezoneY;
            w = 0.0729167 * safezoneW;
            h = 0.028 * safezoneH;
            sizeEx = "(((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 0.8)";
        };
        class SpyderAddons_LoadoutManager_Button2: LoadoutManager_RscButton {
            idc = 7212;

            text = "Button 2";
            x = 0.325 * safezoneW + safezoneX;
            y = 0.57 * safezoneH + safezoneY;
            w = 0.0729167 * safezoneW;
            h = 0.028 * safezoneH;
            sizeEx = "(((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 0.8)";
        };
        class SpyderAddons_LoadoutManager_Button3: LoadoutManager_RscButton {
            idc = 7213;

            text = "Button 3";
            x = 0.244792 * safezoneW + safezoneX;
            y = 0.626 * safezoneH + safezoneY;
            w = 0.0729167 * safezoneW;
            h = 0.028 * safezoneH;
            sizeEx = "(((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 0.8)";
        };
        class SpyderAddons_LoadoutManager_Button4: LoadoutManager_RscButton {
            idc = 7214;

            text = "Button 4";
            x = 0.325 * safezoneW + safezoneX;
            y = 0.626 * safezoneH + safezoneY;
            w = 0.0729167 * safezoneW;
            h = 0.028 * safezoneH;
            sizeEx = "(((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 0.8)";
        };
        class SpyderAddons_LoadoutManager_Button5: LoadoutManager_RscButton {
            idc = 7215;

            text = "Button 5";
            x = 0.244792 * safezoneW + safezoneX;
            y = 0.668 * safezoneH + safezoneY;
            w = 0.0729167 * safezoneW;
            h = 0.028 * safezoneH;
            sizeEx = "(((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 0.8)";
        };
        class SpyderAddons_LoadoutManager_Button6: LoadoutManager_RscButton {
            idc = 7216;

            text = "Button 6";
            x = 0.325 * safezoneW + safezoneX;
            y = 0.668 * safezoneH + safezoneY;
            w = 0.0729167 * safezoneW;
            h = 0.028 * safezoneH;
            sizeEx = "(((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 0.8)";
        };
        class SpyderAddons_LoadoutManager_Button7: LoadoutManager_RscButton {
            idc = 7217;

            text = "Button 7";
            x = 0.244792 * safezoneW + safezoneX;
            y = 0.71 * safezoneH + safezoneY;
            w = 0.0729167 * safezoneW;
            h = 0.028 * safezoneH;
            sizeEx = "(((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 0.8)";
        };
        class SpyderAddons_LoadoutManager_Button8: LoadoutManager_RscButton {
            idc = 7218;

            text = "Button 8";
            x = 0.325 * safezoneW + safezoneX;
            y = 0.71 * safezoneH + safezoneY;
            w = 0.0729167 * safezoneW;
            h = 0.028 * safezoneH;
            sizeEx = "(((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 0.8)";
        };
        class SpyderAddons_LoadoutManager_ButtonBig1: LoadoutManager_RscButton {
            idc = 7219;

            text = "Button Big 1";
            x = 0.4125 * safezoneW + safezoneX;
            y = 0.57 * safezoneH + safezoneY;
            w = 0.167708 * safezoneW;
            h = 0.035 * safezoneH;
            colorBackground[] = {0,0,0,0.65};
            colorActive[] = {0,0,0,0.65};
            sizeEx = "(((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 0.9)";
        };
        class SpyderAddons_LoadoutManager_ButtonBig2: LoadoutManager_RscButton {
            idc = 7220;

            text = "Button Big 2";
            x = 0.4125 * safezoneW + safezoneX;
            y = 0.626 * safezoneH + safezoneY;
            w = 0.167708 * safezoneW;
            h = 0.035 * safezoneH;
            colorBackground[] = {0,0,0,0.65};
            colorActive[] = {0,0,0,0.65};
            sizeEx = "(((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 0.9)";
        };
        class SpyderAddons_LoadoutManager_ButtonBig3: LoadoutManager_RscButton {
            idc = 7221;

            text = "Button Big 3";
            x = 0.4125 * safezoneW + safezoneX;
            y = 0.703 * safezoneH + safezoneY;
            w = 0.167708 * safezoneW;
            h = 0.035 * safezoneH;
            colorBackground[] = {0,0,0,0.65};
            colorActive[] = {0,0,0,0.65};
            sizeEx = "(((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 0.9)";
        };
        class SpyderAddons_LoadoutManager_RenameInput: LoadoutManager_RscEdit {
            idc = 7222;

            x = 0.244792 * safezoneW + safezoneX;
            y = 0.766 * safezoneH + safezoneY;
            w = 0.153125 * safezoneW;
            h = 0.035 * safezoneH;
        };
        class SpyderAddons_LoadoutManager_Rename: LoadoutManager_RscButton {
            idc = 7223;

            text = "Rename";
            x = 0.4125 * safezoneW + safezoneX;
            y = 0.766 * safezoneH + safezoneY;
            w = 0.167708 * safezoneW;
            h = 0.035 * safezoneH;
            colorBackground[] = {0,0,0,0.65};
            colorActive[] = {0,0,0,0.65};
            sizeEx = "(((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 0.9)";
        };
        class SpyderAddons_LoadoutManager_Close: LoadoutManager_RscButton {
            idc = 7224;
            action = "closeDialog 0";

            text = "Close";
            x = 0.2375 * safezoneW + safezoneX;
            y = 0.8164 * safezoneH + safezoneY;
            w = 0.35 * safezoneW;
            h = 0.028 * safezoneH;
            colorBackground[] = {-1,-1,-1,0.65};
            sizeEx = "(((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 0.8)";
        };


    };
};