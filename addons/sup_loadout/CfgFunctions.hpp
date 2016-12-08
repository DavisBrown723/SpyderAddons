class CfgFunctions {
    class PREFIX {
        class COMPONENT {

            class loadoutAddServerData {
                description = "Adds data to the server-side store";
                file = "\x\spyderaddons\addons\sup_loadout\fnc_loadoutAddServerData.sqf";
                recompile = RECOMPILE;
            };

            class loadout {
                description = "Main handler for loadout list entries";
                file = "\x\spyderaddons\addons\sup_loadout\fnc_loadout.sqf";
                recompile = RECOMPILE;
            };

            class loadoutFolder {
                description = "Main handler for folder list entries";
                file = "\x\spyderaddons\addons\sup_loadout\fnc_loadoutFolder.sqf";
                recompile = RECOMPILE;
            };

            class loadoutListEntry {
                description = "Base class for loadout list entries";
                file = "\x\spyderaddons\addons\sup_loadout\fnc_loadoutListEntry.sqf";
                recompile = RECOMPILE;
            };

            class loadoutManager {
                description = "Main handler for the loadout manager";
                file = "\x\spyderaddons\addons\sup_loadout\fnc_loadoutManager.sqf";
                recompile = RECOMPILE;
            };

            class loadoutManagerInit {
                description = "Initializes the loadout manager";
                file = "\x\spyderaddons\addons\sup_loadout\fnc_loadoutManagerInit.sqf";
                recompile = RECOMPILE;
            };

            class loadoutManagerOnAction {
                description = "Sets current loadout manager action";
                file = "\x\spyderaddons\addons\sup_loadout\fnc_loadoutManagerOnAction.sqf";
                recompile = RECOMPILE;
            };

            class loadoutSystem {
                description = "Handles server side loadout manager data";
                file = "\x\spyderaddons\addons\sup_loadout\fnc_loadoutSystem.sqf";
                recompile = RECOMPILE;
            };

        };
    };
};