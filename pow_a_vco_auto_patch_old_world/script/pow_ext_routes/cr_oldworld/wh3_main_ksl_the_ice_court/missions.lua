local missions = {
[[
 		mission
		{
			victory_type vco_victory_type_pow_ext_ksl_the_ice_court_1;
			key wh_main_short_victory;
			issuer CLAN_ELDERS;
			primary_objectives_and_payload
			{
				objective
				{
					override_text mission_text_text_pow_ext_ksl_kat_1_there_can_only_be_one;
					type SCRIPTED;
					script_key vco_dummy;
				}

				objective
				{
				type HAVE_AT_LEAST_X_OF_A_POOLED_RESOURCE;
				total 10;
				pooled_resource wh3_main_ksl_support_level_ice_court;
				}

				objective
				{
				type CONTROL_N_REGIONS_INCLUDING;
				total 3;
				region cr_oldworld_region_kislev;
				region cr_oldworld_region_erengrad;
				region cr_oldworld_region_praag;
				}

				payload
				{
					effect_bundle
					{
						bundle_key vco_victory_payload_ksl_kat_1_there_can_only_be_one_1;
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
			victory_type vco_victory_type_pow_ext_ksl_the_ice_court_2;
			key wh_main_long_victory;
			issuer CLAN_ELDERS;
			primary_objectives_and_payload
			{
				objective
				{
					override_text mission_text_text_pow_ext_katarin_kislev_with_love_b2_0;
					type SCRIPTED;
					script_key vco_dummy;
				}

				objective
				{
				    type DESTROY_FACTION;
				    faction wh2_main_skv_clan_moulder;
				    faction wh2_dlc15_grn_bonerattlaz;
				    confederation_valid;
				}

				objective
				{
				type CONTROL_N_PROVINCES_INCLUDING;
				total 3;
				province cr_oldworld_province_hell_pit_lower;
				province cr_oldworld_province_hell_pit_middle;
				province cr_oldworld_province_hell_pit_upper;
				}

				payload
				{
					effect_bundle
					{
						bundle_key vco_victory_payload_ksl_kat_3_defenders_world;
						turns 1;
					}

					effect_bundle
					{
						bundle_key vco_victory_payload_ksl_kat_1_there_can_only_be_one_2;
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
			victory_type vco_victory_type_pow_ext_ksl_the_ice_court_3;
			key wh_main_domination_victory;
			issuer CLAN_ELDERS;
			primary_objectives_and_payload
			{
				objective
				{
					override_text mission_text_text_pow_ext_katarin_bulwark_of_the_north_b2_0;
					type SCRIPTED;
					script_key vco_dummy;
				}

				objective
				{
				override_text mission_text_text_pow_ext_framework_route_prereq_I_wh3_main_ksl_the_ice_court;
				type SCRIPTED;
				script_key pow_ext_framework_route_prereq_I_wh3_main_ksl_the_ice_court;
				}

				objective
				{
				    type DESTROY_FACTION;
				    faction wh3_main_dae_daemon_prince;
				    faction wh3_main_kho_exiles_of_khorne;
				    faction wh3_dlc20_chs_azazel;
				    faction wh3_dlc20_chs_kholek;
				    confederation_valid;
				}

				payload
				{
					effect_bundle
					{
						bundle_key vco_victory_payload_ksl_kat_2_kislev_love;
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
