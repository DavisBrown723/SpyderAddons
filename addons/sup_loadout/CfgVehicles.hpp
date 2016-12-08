class CfgVehicles
{
    class ModuleSpyderAddonsBase;
    class ADDON : ModuleSpyderAddonsBase
    {
        scope = 2;
        author = "SpyderBlack723";
        displayName = "Loadout Manager";
        function = "SpyderAddons_fnc_loadoutManagerInit";
        icon = "x\spyderaddons\addons\sup_loadout\icon_sup_loadout.paa";
        picture = "x\spyderaddons\addons\sup_loadout\icon_sup_loadout.paa";
        functionPriority = 10;
        isGlobal = 2;
        //isDisposable = 1;

        class Arguments {
            
            class Enable {
                displayName = "Enable";
                description = "Enable module";
                class values {
                    class Yes {
                        name = "Yes";
                        value = true;
                        default = 1;
                    };

                    class No {
                        name = "No";
                        value = false;
                    };
                };
            };

            class Transfer {
                displayName = "Transfer";
                description = "Allow players to transfer loadouts and folders to AI and other players.";
                class values {
                    class Yes {
                        name = "Yes";
                        value = true;
                        default = 1;
                    };

                    class No {
                        name = "No";
                        value = false;
                    };
                };
            };

            class Arsenal {
                displayName = "Arsenal";
                description = "Allow players to access the BIS arsenal from within the loadout manager.";
                class values {
                    class Yes {
                        name = "Yes";
                        value = true;
                        default = 1;
                    };

                    class No {
                        name = "No";
                        value = false;
                    };
                };
            };
            
        };

        class ModuleDescription
        {
            description[] = {
                "Enables players to access the loadout manager.",
                "",
                "Usage: Sync objects to this module to add the loadout manager action to them."
            };
            optional = 1; //-- Synced entity is optional
        };
    };
};