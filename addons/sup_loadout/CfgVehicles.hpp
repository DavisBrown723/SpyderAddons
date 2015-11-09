class CfgVehicles
{
	class ModuleSpyderAddonsBase;
	class SpyderAddons_SupLoadoutModule: ModuleSpyderAddonsBase
	{
		scope = 2;
		author = "SpyderBlack723";
		displayName = "Loadout Manager";
		function = "SpyderAddons_fnc_loadoutManagerInit";
		icon = "x\spyderaddons\addons\sup_loadout\icon_sup_loadout.paa";
		picture = "x\spyderaddons\addons\sup_loadout\icon_sup_loadout.paa";
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