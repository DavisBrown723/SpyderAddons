class CfgFunctions {
	class PREFIX {
		class COMPONENT {
			
			//////-- Asymmetric --//////
			class getPositionSideHostility {
				description = "Returns the hostility towards a side at a given location";
				file = "\x\spyderaddons\addons\x_lib\functions\asymmetric\getPositionSideHostility.sqf";
				recompile = RECOMPILE;
			};

			//////-- Logging --//////
			class log {
				description = "Logs a value to the rpt";
				file = "\x\spyderaddons\addons\x_lib\functions\logging\log.sqf";
				recompile = RECOMPILE;
			};
			class inspectArray {
				description = "Inspects an array to the rpt";
				file = "\x\spyderaddons\addons\x_lib\functions\logging\inspectArray.sqf";
				recompile = RECOMPILE;
			};
			class inspectHash {
				description = "Inspects a hash to the rpt";
				file = "\x\spyderaddons\addons\x_lib\functions\logging\inspectHash.sqf";
				recompile = RECOMPILE;
			};

			//////-- Logistics --//////
			class addForcepool {
				description = "Adjusts forcepool for the given faction";
				file = "\x\spyderaddons\addons\x_lib\functions\logistics\addForcepool.sqf";
				recompile = RECOMPILE;
			};
			
			//////-- Misc --//////
			class getFactionMostPlayers {
				description = "Returns the faction that contains the most players";
				file = "\x\spyderaddons\addons\x_lib\functions\misc\getFactionMostPlayers.sqf";
				recompile = RECOMPILE;
			};
			class getModuleArray {
				description = "Converts a module parameter field entry into an array";
				file = "\x\spyderaddons\addons\x_lib\functions\misc\getModuleArray.sqf";
				recompile = RECOMPILE;
			};
			class getNearAgents {
				description = "Returns civilian agents from the closest settlement";
				file = "\x\spyderaddons\addons\x_lib\functions\misc\getNearAgents.sqf";
				recompile = RECOMPILE;
			};
			class isFaction {
				description = "Tests whether a string is a valid faction";
				file = "\x\spyderaddons\addons\x_lib\functions\misc\isFaction.sqf";
				recompile = RECOMPILE;
			};
			
			//////-- Objectives --//////
			class createObjective {
				description = "Creates an ALiVE objective and registers it to opcoms of the given sides and factions";
				file = "\x\spyderaddons\addons\x_lib\functions\objectives\createObjective.sqf";
				recompile = RECOMPILE;
			};
			class getSideDominantObjectives {
				description = "Returns objectives controlled by the given sides";
				file = "\x\spyderaddons\addons\x_lib\functions\objectives\getSideDominantObjectives.sqf";
				recompile = RECOMPILE;
			};
			
			//////-- OPCOM --//////
			class getOpcoms {
				description = "Returns opcom handlers of given parameters";
				file = "\x\spyderaddons\addons\x_lib\functions\opcom\getOpcoms.sqf";
				recompile = RECOMPILE;
			};
			class getAsymmOpcoms {
				description = "Returns asymmetric opcom handlers";
				file = "\x\spyderaddons\addons\x_lib\functions\opcom\getAsymmOpcoms.sqf";
				recompile = RECOMPILE;
			};
			
			//////-- Profiles --//////
			class profilePatrol {
				description = "Returns asymmetric opcom handlers";
				file = "\x\spyderaddons\addons\x_lib\functions\profiles\profilePatrol.sqf";
				recompile = RECOMPILE;
			};
			class isProfileAlive {
				description = "Returns whether or not the profile is still alive";
				file = "\x\spyderaddons\addons\x_lib\functions\profiles\isProfileAlive.sqf";
				recompile = RECOMPILE;
			};

			//////-- UI --//////
			class displayNotification {
				description = "Displays a notification that slides into view";
				file = "\x\spyderaddons\addons\x_lib\functions\ui\displayNotification.sqf";
				recompile = RECOMPILE;
			};
			class openRequiresAlive {
				description = "Opens the menu notifying the user that a module being used requires ALiVE to run";
				file = "\x\spyderaddons\addons\x_lib\functions\ui\openRequiresAlive.sqf";
				recompile = RECOMPILE;
			};
		};
	};
};