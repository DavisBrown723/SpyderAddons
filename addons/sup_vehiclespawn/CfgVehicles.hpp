class CfgVehicles
{
	class ModuleSpyderAddonsBase;
	class SpyderAddons_sup_vehiclespawn: ModuleSpyderAddonsBase
	{
		scope = 2;
		author = "SpyderBlack723";
		displayName = "Vehicle Spawner";
		function = "SpyderAddons_fnc_vehicleSpawnerInit";
		icon = "x\spyderaddons\addons\sup_vehiclespawn\icon_sup_vehiclespawn.paa";
		picture = "x\spyderaddons\addons\sup_vehiclespawn\icon_sup_vehiclespawn.paa";
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

			class SpawnPosition {
				displayName = "Spawn Position";
				description = "Marker name of where vehicles will be spawned";
				defaultValue = "";
			};

			class VehicleFactions {
				displayName = "Vehicle Factions";
				description = "Factions of vehicles that will be able to be spawned";
				defaultValue = "";
			};

			class VehiclesWhitelist {
				displayName = "Whitelist";
				description = "Vehicles that will be able to be spawned";
				defaultValue = "";
			};
			
			class VehiclesBlacklist {
				displayName = "Blacklist";
				description = "Vehicles that will be excluded";
				defaultValue = "";
			};

			class VehiclesTypeBlacklist {
				displayName = "Type Blacklist";
				description = "Vehicles of these types will be excluded. Types are [Car, Truck, Armored, Tank, Helicopter, Plane]";
				defaultValue = "";
			};

			class VehiclesTypeWhitelist {
				displayName = "Type Whitelist";
				description = "Only vehicles of types defined here will be included. Types are [Car, Truck, Armored, Tank, Helicopter, Plane]";
				defaultValue = "";
			};
		};

		class ModuleDescription
		{
			description[] = {
				"Enables players to spawn vehicles at a predefined location.",
				"",
				"Usage: Sync objects to this module to add the vehicle spawner action to them."
			};
			optional = 1; // Synced entity is optional
		};
	};
};