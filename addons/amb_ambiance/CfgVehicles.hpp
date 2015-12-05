class CfgVehicles
{
	class ModuleSpyderAddonsBase;
	class SpyderAddons_amb_ambiance: ModuleSpyderAddonsBase
	{
		scope = 2;
		author = "SpyderBlack723";
		displayName = "Ambiance";
		function = "SpyderAddons_fnc_ambianceInit";
		icon = "x\spyderaddons\addons\amb_ambiance\icon_amb_ambiance.paa";
		picture = "x\spyderaddons\addons\amb_ambiance\icon_amb_ambiance.paa";
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

			class ActivationCheck {
				displayName = "Activation Check";
				description = "Time in between checks to see if player is within a zone's activation range.";
				defaultValue = "20";
			};

			class SpawnRange {
				displayName = "Spawn Range";
				description = "Players must be within this range to activate a zone";
				defaultValue = "1000";
			};

			class WhitelistMarkers {
				displayName = "Whitelist Markers";
				description = "Areas in which Ambiance will exist. Default: Everywhere";
				defaultValue = "";
			};

			class BlacklistMarkers {
				displayName = "Blacklist Markers";
				description = "Areas where ambiance will avoid";
				defaultValue = "";
			};

			class Locations {
				displayName = "Locations";
				description = "Locations that ambiance will spawn around";
				defaultValue = "NameVillage, NameCity, NameCityCapital, NameLocal";
			};

			class AnimalsDivider {
				displayName = "";
				description = "";
				class Values
				{
					class AnimalsDivider
					{
						name = "----- Animals ------------------------------------------------------";
						value = "";
					};
				};
			};

			class AmbientAnimals {
				displayName = "Ambient Animals";
				description = "Animals will be randomly spawned around the map";
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

			class AnimalChance {
				displayName = "Animal Chance";
				description = "Chance that animals will be spawned inside an activated zone";
				defaultValue = "40";
			};

			class AnimalClasses {
				displayName = "Animals";
				description = "Animals that will be spawned";
				defaultValue = "Goat_Random_F, Sheep_random_F";
			};


			class VehiclesDivider {
				displayName = "";
				description = "";
				class Values
				{
					class VehiclesDivider
					{
						name = "----- Vehicles -----------------------------------------------------";
						value = "";
					};
				};
			};

			class AmbientVehicles {
				displayName = "Ambient Vehicles";
				description = "Vehicles will be randomly spawned in towns when players come near. Vehicles will be driven.";
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

			class VehicleChance {
				displayName = "Vehicle Chance";
				description = "Chance that vehicles will be spawned inside an activated zone";
				defaultValue = "30";
			};

			class MaxVehiclesPerZone {
				displayName = "Max Vehicles Per Zone";
				description = "Maximum amount of vehicles that can be spawned per zone";
				defaultValue = "2";
			};

			class VehicleClasses {
				displayName = "Vehicles";
				description = "Vehicles that will be spawned";
				defaultValue = "C_Hatchback_01_F, C_Offroad_01_F, C_Van_01_transport_F, C_Van_01_box_F";
			};

			class CivilianClasses {
				displayName = "Civilians";
				description = "Civilians that will be spawned";
				defaultValue = "C_man_1, C_man_polo_1_F, C_man_polo_2_F, C_man_polo_6_F, C_man_shorts_1_F, C_man_w_worker_F";
			};

			class EnemiesInsideVehicles {
				displayName = "Enemies Inside Vehicles";
				description = "Vehicles will have a chance of spawning with enemies inside instead of civilians";
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

			class EnemyChance {
				displayName = "Enemy Chance";
				description = "Chance that enemies will be spawned inside a vehicle instead of civilians, max 100";
				defaultValue = "15";
			};	

			class EnemyClasses {
				displayName = "Enemy Classes";
				description = "Enemies that will be spawned";
				defaultValue = "O_Soldier_F, O_Soldier_GL_F, O_Soldier_AR_F, O_Soldier_lite_F, O_Sharpshooter_F";
			};

		};

		class ModuleDescription
		{
			description[] = {
				"Allows mission makers to add subtle ambiance to their mission using a variety of highly customizable parameters",
			};
		};
	};
};