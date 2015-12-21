params ["_module"];

//-- Open the menu
CreateDialog "SpyderAddons_RequiresALiVE";

//-- Set warning text
(findDisplay 10090 displayCtrl 10093) ctrlSetText (format ["%1 requires ALiVE to be running in order to function. Please download ALiVE if you wish to use this module. https://alivemod.com/#Download", _module]);