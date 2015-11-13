class CfgVehicles
{
	class ModuleSpyderAddonsBase;
	class SpyderAddons_mil_detection: ModuleSpyderAddonsBase
	{
		scope = 2;
		author = "SpyderBlack723";
		displayName = "Detection";
		function = "SpyderAddons_fnc_detectionInit";
		icon = "x\spyderaddons\addons\mil_detection\icon_mil_detection.paa";
		picture = "x\spyderaddons\addons\mil_detection\icon_mil_detection.paa";
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
			
			class HostileSides {
				displayName = "Hostile Sides";
				description = "Sides that will monitor player activity. Separate sides with commas.";
				defaultValue = "EAST";
			};

			class RestrictedAreas {
				displayName = "Restricted Areas";
				description = "Marker areas that the player will be automatically determined as an enemy if inside. Separate marker names with commas";
				defaultValue = "";
			};

			class Cooldown {
				displayName = "Cooldown Time";
				description = "Amount of time that must pass before the player is considered friendly after being 'spotted'.";
				defaultValue = 60;
			};

			class SpeedLimit {
				displayName = "Speed Limit";
				description = "The limit that, if exceeded, will cause the player to be made hostile.";
				defaultValue = 60;
			};

			class DrivableOffroad {
				displayName = "Can Drive Offroad?";
				description = "If yes, the player can drive offroad without being 'spotted'";
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

			class RestrictFactionVehicles {
				displayName = "Restrict Faction Vehicles?";
				description = "If yes, the player will be made hostile when they enter a certain faction's vehicles";
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

			class FactionVehicles {
				displayName = "Faction Vehicles";
				description = "Factions of vehicles, or vehicle classnames, that will cause the player to be hostile if entered.";
				defaultValue = "";
			};

			class IncognitoVehicles {
				displayName = "Incognito Vehicles";
				description = "Factions of vehicles that cause the player to benefit from an increased incognito rating (ex. enemy vehicles).";
				defaultValue = "";
			};
			
			class RestrictedClothing {
				displayName = "";
				description = "";
				class Values {
					class Divider {
						name = "----- Restricted Clothing --------------------------------------------------------";
						value = "";
					};
				};
			};
			
			class RestrictedHeadgear {
				displayName = "Restricted Headgear";
				description = "Headgear that will cause the player to be made instantly hostile if worn. Separate classnames with commas.";
				defaultValue = "";
			};
			
			class RestrictedVests {
				displayName = "Restricted Vests";
				description = "Vests that will cause the player to be made instantly hostile if worn. Separate classnames with commas.";
				defaultValue = "";
			};
			
			class RestrictedUniforms {
				displayName = "Restricted Uniforms";
				description = "Uniforms that will cause the player to be made instantly hostile if worn. Separate classnames with commas.";
				defaultValue = "";
			};

			class DetectionValues {
				displayName = "";
				description = "";
				class Values {
					class Divider {
						name = "----- Detection Values --------------------------------------------------------";
						value = "";
					};
				};
			};

			class RequiredDetectionInfantry {
				displayName = "Infantry: Required Detection Value";
				description = "How aware enemies must be of players on foot before considering them hostile.";
				defaultValue = 3;
			};

			class RequiredDetectionVehicle {
				displayName = "Vehicle: Required Detection Value";
				description = "How aware enemies must be of players inside vehicles before considering them hostile.";
				defaultValue = 3.5;
			};

			class IncognitoDetection {
				displayName = "Incognito Detection";
				description = "How aware enemies must be of players inside incognito vehicles to consider them hostile.";
				defaultValue = 4;
			};

		};

		class ModuleDescription
		{
			description[] = {
				"Enables an in-depth detection system best suited to guerilla and insurgent scenarios.",
				"",
				"Usage: Sync objects to this module to have them be tracked by the detection system."
			};
			optional = 1; // Synced entity is optional
		};
	};
};