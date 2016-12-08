#include "common.hpp"

class SpyderAddons_VehicleSpawner {
    idd = 570;
    movingEnable = 1;
    onLoad = "";
    onUnload = "['onUnload'] call SpyderAddons_fnc_vehicleSpawner";

    class controls  {

        class VehicleSpawner_Background: VehicleSpawner_RscText {
            idc = 571;

            x = 0.310417 * safezoneW + safezoneX;
            y = 0.262 * safezoneH + safezoneY;
            w = 0.371875 * safezoneW;
            h = 0.56 * safezoneH;
            colorBackground[] = {0,0,0,0.7};
        };

        class VehicleSpawner_Header: VehicleSpawner_RscText {
            idc = 572;

            moving = 1;
            text = "Vehicle Spawner";
            x = 0.310417 * safezoneW + safezoneX;
            y = 0.2354 * safezoneH + safezoneY;
            w = 0.371875 * safezoneW;
            h = 0.028 * safezoneH;
            colorBackground[] = MOD_COLOR_MAIN;
            sizeEx = "(((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 0.9)";
        };

        class VehicleSpawner_AvailableVehiclesTitle: VehicleSpawner_RscText {
            idc = 573;

            text = "Available Vehicles";
            x = 0.339583 * safezoneW + safezoneX;
            y = 0.29 * safezoneH + safezoneY;
            w = 0.116667 * safezoneW;
            h = 0.042 * safezoneH;
            colorActive[] = {0,0,0,0};
        };

        class VehicleSpawner_VehicleList: VehicleSpawner_RscListBox {
            idc = 574;

            x = 0.317708 * safezoneW + safezoneX;
            y = 0.346 * safezoneH + safezoneY;
            w = 0.175 * safezoneW;
            h = 0.448 * safezoneH;
            colorBackground[] = {0.722,0.694,0.62,0.2};
            colorActive[] = {0.722,0.694,0.62,0.2};
            sizeEx = "(((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 0.7)";
        };

        class VehicleSpawner_VehicleInfoTitle: VehicleSpawner_RscText {
            idc = 575;

            text = "Vehicle Info";
            x = 0.540833 * safezoneW + safezoneX;
            y = 0.29 * safezoneH + safezoneY;
            w = 0.0802083 * safezoneW;
            h = 0.042 * safezoneH;
            colorActive[] = {0,0,0,0};
        };

        class VehicleSpawner_VehicleInfoList: VehicleSpawner_RscListBox {
            idc = 576;

            x = 0.5 * safezoneW + safezoneX;
            y = 0.346 * safezoneH + safezoneY;
            w = 0.172083 * safezoneW;
            h = 0.448 * safezoneH;
            colorBackground[] = {0,0,0,0};
            sizeEx = "(((((safezoneW / safezoneH) min 1.2) / 1.2) / 25) * 0.8)";
        };

        class VehicleSpawner_Close: VehicleSpawner_RscButton {
            idc = 577;
            action = "closeDialog 0";

            text = "Close";
            x = 0.310417 * safezoneW + safezoneX;
            y = 0.829 * safezoneH + safezoneY;
            w = 0.182292 * safezoneW;
            h = 0.028 * safezoneH;
            colorBackground[] = {0,0,0,0.8};
        };

        class VehicleSpawner_Spawn: VehicleSpawner_RscButton {
            idc = 578;
            action = "['getSelectedVehicle'] call SpyderAddons_fnc_vehicleSpawner";

            text = "Spawn";
            x = 0.5 * safezoneW + safezoneX;
            y = 0.829 * safezoneH + safezoneY;
            w = 0.182292 * safezoneW;
            h = 0.028 * safezoneH;
            colorBackground[] = {0,0,0,0.8};
        };

    };

};