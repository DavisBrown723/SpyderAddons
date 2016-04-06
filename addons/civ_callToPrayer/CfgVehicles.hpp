class CfgVehicles {
    class ModuleSpyderAddonsBase;

    class ADDON : ModuleSpyderAddonsBase {
        scope = 2;
        author = "SpyderBlack723";
        displayName = "Call to Prayer";
        function = "SpyderAddons_fnc_callToPrayerInit";
        icon = QUOTE(CPATH(COMPONENT)\icon_civ_callToPrayer.paa);
        picture = QUOTE(CPATH(COMPONENT)\icon_civ_callToPrayer.paa);
        functionPriority = 30;
        isGlobal = 2;

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
                description = "Enable Debug";
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

            class whitelist {
                displayName = "Whitelist Markers";
                description = "Markers where call to prayer will look for locations.";
                defaultValue = "";
            };

            class blacklist {
                displayName = "Blacklist Markers";
                description = "Markers where call to prayer will avoid looking for locations.";
                defaultValue = "";
            };

            class manual {
                displayName = "Manual Markers";
                description = "Markers that will generate a CTP speaker in a close-by location. Use this to generate CTP speakers in areas not recognized by whitelist markers.";
                defaultValue = "";
            };

            class buildings {
                displayName = "CTP Buildings";
                description = "Buildings that will be prioritized for CTP speaker placement.";
                defaultValue = "";
            };

            class autoPopulate {
                displayName = "Require Buildings";
                description = "If no, CTP will place speakers in random, nearby locations if no CTP buildings are found.";
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

            class moveCivs {
                displayName = "Move Civs";
                description = "Civilians will move to nearby CTP locations during times of prayer.";
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

            class timesOfPrayer {
                displayName = "Times of Prayer";
                description = "Call to prayer sounds will play at these times.";
                defaultValue = "[4.25,4.5],[5.25,5.75],[11.75,12],[15.25,15.5],[17.75,18.25],[19,19.25]";
            };

            class CTPSound {
                displayName = "CTP Sound";
                description = "Sound that will play during times of prayer.";
                class values {
                    class none {
                        name = "None";
                        value = "";
                    };

                    class churchbells {
                        name = "Church Bells";
                        value = "SpyderAddons_ChurchBells_1";
                    };

                    class islamicCTP {
                        name = "Islamic Call to Prayer";
                        value = "SpyderAddons_IslamicCTP_1";
                        default = 1;
                    };
                };
            };

            class CTPSoundsCustom {
                displayName = "Custom CTP Sounds";
                description = "Custom CTP sounds that will play during times of prayer. If multiple are listed, one will be selected at random to play.";
                defaultValue = "";
            };
        };

        class ModuleDescription {
			description[] = {
                "Plays call to prayer sounds at user specified locations during times of prayer."
            };
            optional = 0;
        };
    };
};