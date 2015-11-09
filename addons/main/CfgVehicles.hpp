class CfgFactionClasses {
	class NO_CATEGORY;
	class PREFIX {
		displayName = "Spyder Addons";
		priority = 0;
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
		displayName = "EditorSpyderAddonsBase";
		category = "SpyderAddons";
	};
};