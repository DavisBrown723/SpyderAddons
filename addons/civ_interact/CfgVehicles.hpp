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

			class HostilityChance {
				displayName = "Hostility Chance";
				description = "Chance that a civilian will be immediately hostile towards security forces";
				class values
				{
					class HC30 {
						name = "30";
						value = "30";
					};
					class HC25 {
						name = "25";
						value = "25";
					};
					class HC20 {
						name = "20";
						value = "20";
					};

					class HC15 {
						name = "15";
						value = "15";
					};
					class HC10 {
						name = "10";
						value = "10";
						default = 1;
					};
					class HC5 {
						name = "5";
						value = "5";
					};
				};
			};

			class IrritatedChance {
				displayName = "Irritation Chance";
				description = "Chance that a civilian will grow hostile after being asked a question (chance increases with more questions asked)";
				class values
				{
					class 30 {
						name = "30";
						value = "30";
					};
					class 25 {
						name = "25";
						value = "25";
					};
					class 20 {
						name = "20";
						value = "20";
					};

					class 15 {
						name = "15";
						value = "15";
						default = 1;
					};
					class 10 {
						name = "10";
						value = "10";
					};
					class 5 {
						name = "5";
						value = "5";
					};
				};
			};

			class AnswerChance {
				displayName = "Answer Chance";
				description = "Chance that a civilian will give security forces answers";
				class values
				{
					class 75 {
						name = "75";
						value = "75";
					};
					class 60 {
						name = "60";
						value = "60";
					};

					class 45 {
						name = "45";
						value = "45";
					};
					class 30 {
						name = "30";
						value = "30";
						default = 1;
					};
					class 15 {
						name = "15";
						value = "15";
					};
				};
			};
			
		};

		class ModuleDescription
		{
			description = "Enables players to interact with ALiVE ambient civilians";
		};
	};
};