local missions = {
[[
 		mission
		{
			victory_type vco_victory_type_pow_ext_cth_the_celestial_court_1;
			key wh_main_short_victory;
			issuer CLAN_ELDERS;
			primary_objectives_and_payload
			{
				objective
				{
					override_text mission_text_text_pow_ext_yuan_bo_r1_throne_of_albion_b2_0;
					type SCRIPTED;
					script_key vco_dummy;
				}

				objective
				{
				type CONSTRUCT_BUILDING_IN_PROVINCES;
				faction wh3_dlc24_cth_the_celestial_court;
				province cr_oldworld_province_the_lost_valley;
				building_level wh3_dlc24_cth_special_jade_dragon_astromantic_relay;
				}

				objective
				{
				    type DESTROY_FACTION;
				    faction wh2_main_def_har_ganeth;
				    faction wh2_main_lzd_last_defenders;
				    faction wh3_main_chs_shadow_legion;
				    confederation_valid;
				}

				payload
				{
					effect_bundle
					{
						bundle_key pow_ext_victory_payload_cth_yua_throne_of_albion;
						turns 0;
					}

					effect_bundle
					{
						bundle_key vco_victory_payload_all_campaign_victory_dummy;
						turns 0;
					}

				}
			}
		}
]],
[[
 		mission
		{
			victory_type vco_victory_type_pow_ext_cth_the_celestial_court_2;
			key wh_main_long_victory;
			issuer CLAN_ELDERS;
			primary_objectives_and_payload
			{
				objective
				{
					override_text mission_text_text_pow_ext_yuan_bo_r2_mandate_of_heaven_b2_0;
					type SCRIPTED;
					script_key vco_dummy;
				}

				objective
				{
				override_text mission_text_text_pow_ext_yuan_bo_r2_dragons_gaze_0;
				type SCRIPTED;
				script_key pow_ext_framework_completen_wh3_dlc24_cth_the_celestial_court_II_dragons_gaze;
				}

				objective
				{
				override_text mission_text_text_pow_ext_yuan_bo_r2_dragons_fang_0;
				type SCRIPTED;
				script_key pow_ext_framework_completen_wh3_dlc24_cth_the_celestial_court_II_dragons_fang;
				}

				objective
				{
				override_text mission_text_text_pow_ext_yuan_bo_r2_executioner_b2_0_0;
				type SCRIPTED;
				script_key pow_ext_framework_kill_wh3_dlc24_cth_the_celestial_court_II_executioner;
				}

				objective
				{
				override_text mission_text_text_pow_ext_yuan_bo_r2_caravans_b2_0_0;
				type SCRIPTED;
				script_key pow_ext_framework_csv_wh3_dlc24_cth_the_celestial_court_II_caravans;
				}

				payload
				{
					effect_bundle
					{
						bundle_key vco_victory_payload_cth_yua_3_the_spymaster;
						turns 0;
					}

					effect_bundle
					{
						bundle_key vco_victory_payload_all_campaign_victory_dummy;
						turns 0;
					}

				}
			}
		}
]],
[[
 		mission
		{
			victory_type vco_victory_type_pow_ext_cth_the_celestial_court_3;
			key wh_main_domination_victory;
			issuer CLAN_ELDERS;
			primary_objectives_and_payload
			{
				objective
				{
					override_text mission_text_text_pow_ext_yuan_bo_r3_wu_xing_compass_b2_0;
					type SCRIPTED;
					script_key vco_dummy;
				}

				objective
				{
				override_text mission_text_text_pow_ext_yuan_bo_r3_r2_prereq;
				type SCRIPTED;
				script_key pow_ext_framework_route_prereq_II_wh3_dlc24_cth_the_celestial_court;
				}

				objective
				{
				override_text mission_text_text_pow_ext_yuan_bo_r3_compass_west_b2_0;
				type SCRIPTED;
				script_key pow_ext_framework_watchinc_wh3_dlc24_cth_the_celestial_court_III_compass_west;
				}

				objective
				{
				override_text mission_text_text_pow_ext_yuan_bo_r3_compass_north_b2_0;
				type SCRIPTED;
				script_key pow_ext_framework_watchinc_wh3_dlc24_cth_the_celestial_court_III_compass_north;
				}

				objective
				{
				override_text mission_text_text_pow_ext_yuan_bo_r3_compass_south_b2_0;
				type SCRIPTED;
				script_key pow_ext_framework_watchinc_wh3_dlc24_cth_the_celestial_court_III_compass_south;
				}

				objective
				{
				override_text mission_text_text_pow_ext_yuan_bo_r3_compass_east_b2_0;
				type SCRIPTED;
				script_key pow_ext_framework_watchinc_wh3_dlc24_cth_the_celestial_court_III_compass_east;
				}

				objective
				{
				override_text mission_text_text_pow_ext_yuan_bo_r3_final_battle;
				type SCRIPTED;
				script_key pow_ext_framework_completen_wh3_dlc24_cth_the_celestial_court_III_final_battle;
				}

				payload
				{
					effect_bundle
					{
						bundle_key vco_victory_payload_cth_yua_1_the_jade_compass;
						turns 0;
					}

					effect_bundle
					{
						bundle_key vco_victory_payload_all_campaign_victory_dummy;
						turns 0;
					}

				}
			}
		}
]]
};

return missions;
