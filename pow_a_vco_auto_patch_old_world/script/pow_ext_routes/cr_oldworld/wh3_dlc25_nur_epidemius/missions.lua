local missions = {
[[
 		mission
		{
			victory_type vco_victory_type_pow_ext_nur_epidemius_1;
			key wh_main_short_victory;
			issuer CLAN_ELDERS;
			primary_objectives_and_payload
			{
				objective
				{
					override_text mission_text_text_pow_ext_epidemius_land_of_plagues;
					type SCRIPTED;
					script_key vco_dummy;
				}

				objective
				{
				override_text mission_text_text_pow_ext_epidemius_land_of_plagues_progress_0;
				type SCRIPTED;
				script_key pow_ext_framework_corruption_wh3_dlc25_nur_epidemius_I_land_of_plagues;
				}

				payload
				{
					effect_bundle
					{
						bundle_key vco_victory_payload_nur_epi_1_chaos_wastes;
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
			victory_type vco_victory_type_pow_ext_nur_epidemius_2;
			key wh_main_long_victory;
			issuer MUFFIN_MAN;
			primary_objectives_and_payload
			{
				objective
				{
					override_text mission_text_text_pow_ext_epidemius_caledor_crusade;
					type SCRIPTED;
					script_key vco_dummy;
				}

				objective
				{
				    type DESTROY_FACTION;
				    faction wh2_dlc15_hef_imrik;
				    faction wh2_dlc09_tmb_lybaras;
				    confederation_valid;
				}

				objective
				{
				type CONTROL_N_REGIONS_INCLUDING;
				total 1;
				region cr_oldworld_region_dramalliels_landing;
				}

				payload
				{
					effect_bundle
					{
						bundle_key vco_victory_payload_nur_epi_2_norsca;
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
			victory_type vco_victory_type_pow_ext_nur_epidemius_3;
			key wh_main_domination_victory;
			issuer CLAN_ELDERS;
			primary_objectives_and_payload
			{
				objective
				{
					override_text mission_text_text_pow_ext_epidemius_carnival_of_chaos;
					type SCRIPTED;
					script_key vco_dummy;
				}

				objective
				{
				    type DESTROY_FACTION;
				    faction wh_dlc05_wef_wood_elves;
				    faction wh_dlc05_wef_wydrioth;
				    faction wh_dlc05_wef_torgovann;
				    faction wh_dlc05_wef_argwylon;
				    confederation_valid;
				}

				objective
				{
				type OWN_N_REGIONS_INCLUDING;
				total 1;
				region cr_oldworld_region_the_oak_of_ages;
				}

				payload
				{
					effect_bundle
					{
						bundle_key vco_victory_payload_nur_epi_3_elves;
						turns 0;
					}

					add_ancillary_to_faction_pool
					{
						ancillary_key vco_anc_follower_carnival_of_chaos;
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
