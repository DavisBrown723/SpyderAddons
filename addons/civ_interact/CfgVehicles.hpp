class CfgVehicles
{
	class ModuleSpyderAddonsBase;
	class ADDON : ModuleSpyderAddonsBase
	{
		scope = 2;
		author = "SpyderBlack723";
		displayName = "Civilian Interaction";
		function = "SpyderAddons_fnc_civilianInteractionInit";
		icon = "x\spyderaddons\addons\civ_interact\icon_civ_interact.paa";
		picture = "x\spyderaddons\addons\civ_interact\icon_civ_interact.paa";
		functionPriority = 10;
		isGlobal = 2;

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

			class EnemyForces {
				displayName = "Enemy Forces";
				description = "Enemy forces should be structured in this format [Faction_Classname,Faction_DisplayName, AttitudeTowardsFaction (1 being good, -1 being bad)";
				defaultValue = "[OPF_G_F,Guerilla, -.3]";
			};

			class FriendlyForces {
				displayName = "Friendly Forces";
				description = "Friendly forces should be structured in this format [Faction_Classname,Faction_DisplayName, AttitudeTowardsFaction (1 being good, -1 being bad)]";
				defaultValue = "[BLU_F,NATO, .3]";
			};

			class IEDClasses {
				displayName = "IED Classes";
				description = "IED Classes that civilians will identify and report to players. These classes are in addition to vanilla and ALiVE IED classes.";
				defaultValue = "";
			};
			
		};

		class ModuleDescription
		{
			description = "Enables players to interact with ALiVE ambient civilians";
		};
	};
};