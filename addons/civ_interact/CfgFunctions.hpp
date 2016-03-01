class CfgFunctions {
	class PREFIX {
		class COMPONENT {
			class addCivilianAction {
				description = "Adds interact option to civilians";
				file = "\x\spyderaddons\addons\civ_interact\fnc_addCivilianAction.sqf";
				recompile = RECOMPILE;
			};
			class civilianInteraction {
				description = "Main handler for civilian interraction";
				file = "\x\spyderaddons\addons\civ_interact\fnc_civilianInteraction.sqf";
				recompile = RECOMPILE;
			};
			class civilianInteractionInit {
				description = "Initializes civilian interaction";
				file = "\x\spyderaddons\addons\civ_interact\fnc_civilianInteractionInit.sqf";
				recompile = RECOMPILE;
			};
			class getResponses {
				description = "Returns any responses for a question";
				file = "\x\spyderaddons\addons\civ_interact\fnc_getResponses.sqf";
				recompile = RECOMPILE;
			};
			class inventoryHandler {
				description = "Main handler for questions";
				file = "\x\spyderaddons\addons\civ_interact\fnc_inventoryHandler.sqf";
				recompile = RECOMPILE;
			};
			class personalityHandler {
				description = "Main handler for civilian personalities";
				file = "\x\spyderaddons\addons\civ_interact\fnc_personalityHandler.sqf";
				recompile = RECOMPILE;
			};
		};
	};
};