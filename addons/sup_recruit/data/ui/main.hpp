#include "common.hpp"

class SpyderAddons_Recruitment {
    idd = 570;
    movingEnable = 1;
    onLoad = "";
    onUnload = "['onUnload'] call SpyderAddons_fnc_recruitment";

    class controls {

        class Recruitment_Background: Recruitment_RscText {
            idc = 571;
            x = 0.310417 * safezoneW + safezoneX;
            y = 0.262 * safezoneH + safezoneY;
            w = 0.357292 * safezoneW;
            h = 0.56 * safezoneH;
            colorBackground[] = {0,0,0,0.7};
        };

        class Recruitment_Header: Recruitment_RscText {
            moving = 1;
            idc = 572;
            text = "Recruitment";
            x = 0.310417 * safezoneW + safezoneX;
            y = 0.2354 * safezoneH + safezoneY;
            w = 0.357292 * safezoneW;
            h = 0.028 * safezoneH;
            colorBackground[] = MOD_COLOR_MAIN;
            sizeEx = "(((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 0.9)";
        };

        class Recruitment_AvailableUnitsTitle: Recruitment_RscText {
            idc = 573;
            text = "Available Units";
            x = 0.339583 * safezoneW + safezoneX;
            y = 0.29 * safezoneH + safezoneY;
            w = 0.102083 * safezoneW;
            h = 0.042 * safezoneH;
            colorBackground[] = {0,0,0,0};
            colorActive[] = {0,0,0,0};
        };

        class Recruitment_AvailableUnitsList: Recruitment_RscListBox {
            idc = 574;
            x = 0.317708 * safezoneW + safezoneX;
            y = 0.346 * safezoneH + safezoneY;
            w = 0.167708 * safezoneW;
            h = 0.448 * safezoneH;
            sizeEx = "(((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 0.85)";
            colorBackground[] = {0.722,0.694,0.62,0.2};
        };

        class Recruitment_UnitGearTitle: Recruitment_RscText {
            idc = 575;
            text = "Unit Gear";
            x = 0.536458 * safezoneW + safezoneX;
            y = 0.29 * safezoneH + safezoneY;
            w = 0.065625 * safezoneW;
            h = 0.042 * safezoneH;
            colorBackground[] = {0,0,0,0};
        };

        class Recruitment_UnitGearList: Recruitment_ListNBox {
            idc = 576;
            x = 0.492708 * safezoneW + safezoneX;
            y = 0.346 * safezoneH + safezoneY;
            w = 0.167708 * safezoneW;
            h = 0.448 * safezoneH;
            colorBackground[] = {0,0,0,0};
            sizeEx = "(((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 0.7)";
        };

        class Recruitment_Close: Recruitment_RscButton {
            idc = 577;
            action = "closeDialog 0";
            text = "Close";
            x = 0.310417 * safezoneW + safezoneX;
            y = 0.8276 * safezoneH + safezoneY;
            w = 0.175 * safezoneW;
            h = 0.028 * safezoneH;
            colorBackground[] = {0,0,0,0.8};
        };

        class Recruitment_Recruit: Recruitment_RscButton {
            idc = 578;
            action = "['getSelectedUnit'] call SpyderAddons_fnc_recruitment";
            text = "Recruit";
            x = 0.492708 * safezoneW + safezoneX;
            y = 0.8276 * safezoneH + safezoneY;
            w = 0.175 * safezoneW;
            h = 0.028 * safezoneH;
            colorBackground[] = {0,0,0,0.8};
        };

    };

};