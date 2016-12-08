class CfgVehicles
{
    class ModuleSpyderAddonsBase;
    class ADDON : ModuleSpyderAddonsBase
    {
        scope = 2;
        author = "SpyderBlack723";
        displayName = "Recruitment";
        function = "SpyderAddons_fnc_recruitmentInit";
        icon = "x\spyderaddons\addons\sup_recruit\icon_sup_recruit.paa";
        picture = "x\spyderaddons\addons\sup_recruit\icon_sup_recruit.paa";
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
            
            class RecruitableFactions {
                displayName = "Recruitable Factions";
                description = "Factions of units that will be recruitable.";
                defaultValue = "";
            };
            
            class RecruitableUnits {
                displayName = "Whitelisted Units";
                description = "Units that will be recruitable.";
                defaultValue = "";
            };
            
            class BlacklistedUnits {
                displayName = "Blacklisted Units";
                description = "Units that will be excluded from the recruitment list.";
                defaultValue = "";
            };

            class MaximumUnits {
                displayName = "Maximum Squad Size";
                description = "The maximum amount of units a player may have in his squad before being unable to recruit.";
                defaultValue = "10";
            };
            class SpawnCode {
                displayName = "Code";
                description = "Code ran a unit is recruited. The unit can be referenced by the variable _this";
                defaultValue = "";
            };
            
        };

        class ModuleDescription
        {
            description[] = {
                "Enables players to recruit units into their squad.",
                "",
                "Usage: Sync objects to this module to add the recruit action to them."
            };
            optional = 1; // Synced entity is optional
        };
    };
};