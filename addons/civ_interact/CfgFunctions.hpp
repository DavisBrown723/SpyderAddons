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
			class responseHandler {
				description = "Main handler for civilian responses";
				file = "\x\spyderaddons\addons\civ_interact\fnc_responseHandler.sqf";
				recompile = RECOMPILE;
			};
		};
	};
};