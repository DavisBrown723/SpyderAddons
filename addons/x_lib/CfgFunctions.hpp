class CfgFunctions {
	class PREFIX {
		class COMPONENT {
			
			//////-- Asymmetric --//////
			class getCivilianRole {
				description = "Returns a civilians ALiVE role (priest, townelder, etc)";
				file = "\x\spyderaddons\addons\x_lib\functions\asymmetric\getCivilianRole.sqf";
				recompile = RECOMPILE;
			};
			class getPositionSideHostility {
				description = "Returns the hostility towards a side at a given location";
                			file = "\x\spyderaddons\addons\x_lib\functions\asymmetric\getPositionSideHostility.sqf";
				recompile = RECOMPILE;
			};

			//////-- Events --//////
			class addEvent {
				description = "Registers an event on the server";
				file = "\x\spyderaddons\addons\x_lib\functions\events\fnc_addEvent.sqf";
				recompile = RECOMPILE;
			};
			class event {
				description = "Creates an event";
				file = "\x\spyderaddons\addons\x_lib\functions\events\fnc_event.sqf";
				recompile = RECOMPILE;
			};
			class eventSystem {
				description = "Main handler for listeners and events";
				file = "\x\spyderaddons\addons\x_lib\functions\events\fnc_eventSystem.sqf";
				recompile = RECOMPILE;
			};

			//////-- Hashes --//////
			class hashAppend {
				description = "Appends one hash to the back of another";
				file = "\x\spyderaddons\addons\x_lib\functions\hashes\hashAppend.sqf";
				recompile = RECOMPILE;
			};
			class hashCreate {
				description = "Creates an object to store settings";
				file = "\x\spyderaddons\addons\x_lib\functions\hashes\hashCreate.sqf";
				recompile = RECOMPILE;
			};
			class hashGet {
				description = "Retrieves the value tied to the passed key from a hash";
				file = "\x\spyderaddons\addons\x_lib\functions\hashes\hashGet.sqf";
				recompile = RECOMPILE;
			};
			class hashRem {
				description = "Removes a value-data pair from an object";
				file = "\x\spyderaddons\addons\x_lib\functions\hashes\hashRem.sqf";
				recompile = RECOMPILE;
			};
			class hashSet {
				description = "Stores a value-data pair to an object";
				file = "\x\spyderaddons\addons\x_lib\functions\hashes\hashSet.sqf";
				recompile = RECOMPILE;
			};
			class isHash {
				description = "Determines whether or not the passed variable is a hash";
				file = "\x\spyderaddons\addons\x_lib\functions\hashes\isHash.sqf";
				recompile = RECOMPILE;
			};

			//////-- Logging --//////
			class dumpModuleInit {
				description = "Dumps module initialization information to the rpt";
				file = "\x\spyderaddons\addons\x_lib\functions\logging\dumpModuleInit.sqf";
				recompile = RECOMPILE;
			};
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

			//////-- Numbers --//////
			class getClosestNumber {
				description = "Returns the closest number number in an array to the passed number";
				file = "\x\spyderaddons\addons\x_lib\functions\numbers\getClosestNumber.sqf";
				recompile = RECOMPILE;
			};
			class numberInBounds {
				description = "Returns whether a number is between the given bounds";
				file = "\x\spyderaddons\addons\x_lib\functions\numbers\numberInBounds.sqf";
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
			class getObjectiveInstallations {
				description = "Returns an array of installations within the objective";
				file = "\x\spyderaddons\addons\x_lib\functions\objectives\getObjectiveInstallations.sqf";
				recompile = RECOMPILE;
			};
			class getSideDominantObjectives {
				description = "Returns objectives controlled by the given sides";
				file = "\x\spyderaddons\addons\x_lib\functions\objectives\getSideDominantObjectives.sqf";
				recompile = RECOMPILE;
			};

			//////-- OOP --//////
			class baseClass {
				description = "A base class for objects to inherit from";
				file = "\x\spyderaddons\addons\x_lib\functions\oop\baseClass.sqf";
				recompile = RECOMPILE;
			};
			class baseClassHash {
				description = "A base class for hash objects to inherit from";
				file = "\x\spyderaddons\addons\x_lib\functions\oop\baseClassHash.sqf";
				recompile = RECOMPILE;
			};
			
			//////-- OPCOM --//////
			class getOpcomByFaction {
				description = "Returns an opcom that controls the passed faction, if any exist";
				file = "\x\spyderaddons\addons\x_lib\functions\opcom\getOpcomByFaction.sqf";
				recompile = RECOMPILE;
			};
			class getOpcoms {
				description = "Returns opcom handlers of given parameters";
				file = "\x\spyderaddons\addons\x_lib\functions\opcom\getOpcoms.sqf";
				recompile = RECOMPILE;
			};
			class getOpcomsBySide {
				description = "Returns an array of opcoms controling factions of the passed side";
				file = "\x\spyderaddons\addons\x_lib\functions\opcom\getOpcomsBySide.sqf";
				recompile = RECOMPILE;
			};
			class isAsymmetric {
				description = "Tests whether an opcom has a control type of asymmetric";
				file = "\x\spyderaddons\addons\x_lib\functions\opcom\isAsymmetric.sqf";
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
			class ctrlGetRelDistance {
				description = "Finds the relative position of control 2, from the position of control 1";
				file = "\x\spyderaddons\addons\x_lib\functions\ui\ctrlGetRelDistance.sqf";
				recompile = RECOMPILE;
			};
			class ctrlGetRelPos {
				description = "Finds the positions relative to the passed control's position";
				file = "\x\spyderaddons\addons\x_lib\functions\ui\ctrlGetRelPos.sqf";
				recompile = RECOMPILE;
			};
			class ctrlRelMove {
				description = "Moves a control relative to it's current position";
				file = "\x\spyderaddons\addons\x_lib\functions\ui\ctrlRelMove.sqf";
				recompile = RECOMPILE;
			};
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
			class progressAnimate {
				description = "Fills or drains a progress bar over the specified period of time";
				file = "\x\spyderaddons\addons\x_lib\functions\ui\progressAnimate.sqf";
				recompile = RECOMPILE;
			};
		};
	};
};