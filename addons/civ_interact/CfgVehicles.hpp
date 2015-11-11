class CfgVehicles
{
	class ModuleSpyderAddonsBase;
	class SpyderAddons_civ_interact: ModuleSpyderAddonsBase
	{
		scope = 2;
		author = "SpyderBlack723";
		displayName = "Civilian Interaction";
		function = "SpyderAddons_fnc_civInteractInit";
		icon = "x\spyderaddons\addons\civ_interact\icon_civ_interact.paa";
		picture = "x\spyderaddons\addons\civ_interact\icon_civ_interact.paa";
		functionPriority = 10;
		isGlobal = 2;
		isDisposable = 1;

		class Arguments
		{
			class Enable
  			{
				displayName = "Enable";
				description = "Enable module";
				class values
				{
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
			class Debug
  			{
				displayName = "Debug";
				description = "Enable debug";
				class values
				{
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

			class EnemyFaction {
				displayName = "Insurgent Faction";
				description = "Faction used for enemy insurgents";
				defaultValue = "";
			};
			
		};

		class ModuleDescription
		{
			description = "Enables players to interact with ALiVE ambient civilians";
		};
	};
};