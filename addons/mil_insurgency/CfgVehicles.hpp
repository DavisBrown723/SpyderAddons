class CfgVehicles
{
	class ModuleSpyderAddonsBase;
	class ADDON : ModuleSpyderAddonsBase
	{
		scope = 1;
		author = "SpyderBlack723";
		displayName = "Insurgency";
		function = "SpyderAddons_fnc_insurgencyInit";
		icon = "x\spyderaddons\addons\mil_insurgency\icon_mil_insurgency.paa";
		picture = "x\spyderaddons\addons\mil_insurgency\icon_mil_insurgency.paa";
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

			class Debug {
				displayName = "Debug";
				description = "Enable Debug";
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

			class InsurgentFactions {
				displayName = "Insurgent Factions";
				description = "Factions that insurgents belong to.";
				defaultValue = "";
			};
			
		};

		class ModuleDescription
		{
			description[] = {
				"Enables players to play as ALiVE insurgents. Players will be given the ability to establish installations, recruit civilians, and plan coordinated attacks on security forces.",
				"",
				"Usage: Sync players to this module to add the insurgent actions to them."
			};
			optional = 1; // Synced entity is optional
		};
	};
};