class CfgVehicles
{
	class ModuleSpyderAddonsBase;
	class ADDON : ModuleSpyderAddonsBase
	{
		scope = 2;
		author = "SpyderBlack723";
		displayName = "Vehicle Spawner";
		function = "SpyderAddons_fnc_vehicleSpawnerInit";
		icon = "x\spyderaddons\addons\sup_vehiclespawn\icon_sup_vehiclespawn.paa";
		picture = "x\spyderaddons\addons\sup_vehiclespawn\icon_sup_vehiclespawn.paa";
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

			class SpawnPosition {
				displayName = "Spawn Position";
				description = "Marker name of where vehicles will be spawned";
				defaultValue = "";
			};

			class SpawnHeight {
				displayName = "Spawn Height";
				description = "Height that vehicles will be spawned at";
				defaultValue = "0";
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

			class VehiclesTypeWhitelist {
				displayName = "Type Whitelist";
				description = "Only vehicles of types defined here will be included. Some types are [Car, Truck, Armored, Tank, Helicopter, Plane]";
				defaultValue = "";
			};

			class VehiclesTypeBlacklist {
				displayName = "Type Blacklist";
				description = "Vehicles of these types will be excluded. Some types are [Car, Truck, Armored, Tank, Helicopter, Plane]";
				defaultValue = "";
			};
			class SpawnCode {
				displayName = "Code";
				description = "Code ran when a vehicle is spawned. The vehicle can be referenced by the variable _this";
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