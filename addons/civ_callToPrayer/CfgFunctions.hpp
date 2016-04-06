class CfgFunctions {
    class PREFIX {
        class COMPONENT {

            class callToPrayer {
                description = "Main handler for call to prayer";
                file = QUOTE(CPATH(COMPONENT)\fnc_callToPrayer.sqf);
                recompile = RECOMPILE;
            };

            class callToPrayerInit {
                description = "Initializes call to prayer";
                file = QUOTE(CPATH(COMPONENT)\fnc_callToPrayerInit.sqf);
                recompile = RECOMPILE;
            };

        };
    };
};