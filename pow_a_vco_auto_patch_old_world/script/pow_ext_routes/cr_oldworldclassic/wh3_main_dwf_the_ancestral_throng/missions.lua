local missions = {
[[
 		mission
		{
			victory_type vco_victory_type_pow_ext_dwf_the_ancestral_throng_1;
			key wh_main_short_victory;
			issuer CLAN_ELDERS;
			primary_objectives_and_payload
			{
				objective
				{
					override_text mission_text_text_pow_ext_grombrindal_secure_home_b2_0;
					type SCRIPTED;
					script_key vco_dummy;
				}

				objective
				{
				    type DESTROY_FACTION;
				    faction wh3_main_dae_daemon_prince;
				    faction wh3_main_kho_exiles_of_khorne;
				    faction wh3_dlc20_chs_azazel;
				    confederation_valid;
				}

				objective
				{
				type CONTROL_N_PROVINCES_INCLUDING;
				total 3;
				province cr_oldworld_province_eagles_peak;
				province cr_oldworld_province_mountains_of_hel;
				province cr_oldworld_province_trollheim_mountains_east;
				}

				payload
				{
					effect_bundle
					{
						bundle_key pow_ext_victory_payload_dwf_gro_1_anti_chaos_b2_0;
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
			victory_type vco_victory_type_pow_ext_dwf_the_ancestral_throng_2;
			key wh_main_long_victory;
			issuer CLAN_ELDERS;
			primary_objectives_and_payload
			{
				objective
				{
					override_text mission_text_text_pow_ext_grombrindal_accoutrements_b2_0;
					type SCRIPTED;
					script_key vco_dummy;
				}

				objective
				{
				override_text mission_text_text_pow_ext_grombrindal_armour_of_glimril;
				type SCRIPTED;
				script_key pow_ext_framework_completen_wh3_main_dwf_the_ancestral_throng_II_armour;
				}

				objective
				{
				override_text mission_text_text_pow_ext_grombrindal_rune_axe;
				type SCRIPTED;
				script_key pow_ext_framework_completen_wh3_main_dwf_the_ancestral_throng_II_axe;
				}

				objective
				{
				override_text mission_text_text_pow_ext_grombrindal_cloak_of_valaya;
				type SCRIPTED;
				script_key pow_ext_framework_completen_wh3_main_dwf_the_ancestral_throng_II_cloak;
				}

				objective
				{
				override_text mission_text_text_pow_ext_grombrindal_rune_helm;
				type SCRIPTED;
				script_key pow_ext_framework_completen_wh3_main_dwf_the_ancestral_throng_II_helm;
				}

				objective
				{
				override_text mission_text_text_pow_ext_grombrindal_gnollengrom_b2_0;
				type SCRIPTED;
				script_key pow_ext_framework_watchinc_wh3_main_dwf_the_ancestral_throng_II_gnollengrom;
				}

				payload
				{
					effect_bundle
					{
						bundle_key pow_ext_victory_payload_dwf_gro_2_accoutrements_b2_0;
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
			victory_type vco_victory_type_pow_ext_dwf_the_ancestral_throng_3;
			key wh_main_domination_victory;
			issuer CLAN_ELDERS;
			primary_objectives_and_payload
			{
				objective
				{
					override_text mission_text_text_pow_ext_grombrindal_old_grudge_b2_0;
					type SCRIPTED;
					script_key vco_dummy;
				}

				objective
				{
				override_text mission_text_text_pow_ext_grombrindal_r2_complete;
				type SCRIPTED;
				script_key pow_ext_framework_route_prereq_II_wh3_main_dwf_the_ancestral_throng;
				}

				objective
				{
				override_text mission_text_text_pow_ext_grombrindal_legendary_grudges_0;
				type SCRIPTED;
				script_key pow_ext_framework_completen_wh3_main_dwf_the_ancestral_throng_III_legendary_grudges;
				}

				payload
				{
					effect_bundle
					{
						bundle_key pow_ext_victory_payload_dwf_gro_3_old_grudge_b2_0;
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
