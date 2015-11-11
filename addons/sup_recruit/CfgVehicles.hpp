class CfgVehicles
{
	class ModuleSpyderAddonsBase;
	class SpyderAddons_sup_recruit: ModuleSpyderAddonsBase
	{
		scope = 2;
		author = "SpyderBlack723";
		displayName = "Recruitment";
		function = "SpyderAddons_fnc_recruitmentInit";
		icon = "x\spyderaddons\addons\sup_recruit\icon_sup_recruit.paa";
		picture = "x\spyderaddons\addons\sup_recruit\icon_sup_recruit.paa";
		functionPriority = 10;
		isGlobal = 2;
		isDisposable = 1;

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
			
			class Debug {
				displayName = "Debug";
				description = "Enable debug";
				class values {
					class Yes {
						name = "Yes";
						value = true;
					};

					class No {
						name = "No";
						value = false;
						default = 1;
					};
				};
			};
			
			class RecruitableFactions {
				displayName = "Recruitable Factions";
				description = "Units of listed factions will be recruitable. Separate factions with commas.";
				defaultValue = "";
			};
			
			class RecruitableUnits {
				displayName = "Whitelisted Units";
				description = "Class names of units that will be recruitable. Separate class names with commas.";
				defaultValue = "";
			};
			
			class BlacklistedUnits {
				displayName = "Blacklisted Units";
				description = "Units that will be excluded from the recruit list. Separate class names with commas.";
				defaultValue = "";
			};

			class MaximumUnits {
				displayName = "Maximum Squad Size";
				description = "The maximum amount of units a player may have in his squad before being unable to recruit.";
				defaultValue = "10";
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