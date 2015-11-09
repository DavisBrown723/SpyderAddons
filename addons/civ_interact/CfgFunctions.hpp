class CfgFunctions {
	class PREFIX {
		class COMPONENT {
			class addCivilianAction {
				description = "Adds interact option to civilians";
				file = "\x\spyderaddons\addons\civ_interact\fnc_addCivilianAction.sqf";
				recompile = RECOMPILE;
			};
			class civInteract {
				description = "Main handler for civilian interraction";
				file = "\x\spyderaddons\addons\civ_interact\fnc_civInteract.sqf";
				recompile = RECOMPILE;
			};
			class civInteractInit {
				description = "Initializes civilian interaction";
				file = "\x\spyderaddons\addons\civ_interact\fnc_civInteractInit.sqf";
				recompile = RECOMPILE;
			};
			class commandHandler {
				description = "Main handler for civilian commands";
				file = "\x\spyderaddons\addons\civ_interact\fnc_commandHandler.sqf";
				recompile = RECOMPILE;
			};
			class questionHandler {
				description = "Main handler for questions";
				file = "\x\spyderaddons\addons\civ_interact\fnc_questionHandler.sqf";
				recompile = RECOMPILE;
			};
		};
	};
};