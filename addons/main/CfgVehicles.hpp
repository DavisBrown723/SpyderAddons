class CfgFactionClasses {
	class SpyderAddons {
		displayName = "Spyder Addons";
		priority = 1;
		side = 7;
	};
};

class CfgVehicles {
	class Logic;
	class Module_F: Logic {
		class ArgumentsBaseUnits {
			class Units;
		};
		class ModuleDescription
		{
			class AnyBrain;
		};
	};

	class ModuleSpyderAddonsBase: Module_F {
		scope = 1;
		displayName = "SpyderAddonsModuleBase";
		category = "SpyderAddons";
	};
};