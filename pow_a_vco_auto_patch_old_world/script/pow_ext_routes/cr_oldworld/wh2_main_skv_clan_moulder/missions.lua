local missions = {
[[
 		mission
		{
			victory_type vco_victory_type_pow_ext_skv_clan_moulder_1;
			key wh_main_short_victory;
			issuer CLAN_ELDERS;
			primary_objectives_and_payload
			{
				objective
				{
					override_text mission_text_text_pow_ext_throt_r1_nine_circles_lab;
					type SCRIPTED;
					script_key vco_dummy;
				}

				objective
				{
					override_text mission_text_text_vco_skv_mdr_1_yes_yes_prepare_the_lab;
					type SCRIPTED;
					script_key vco_skv_mld_augments;
				}

				objective
				{
				    type DESTROY_FACTION;
				    faction cr_nur_putrid_musk;
				    faction cr_kho_insensate_rage;
				    faction cr_sla_coveted_passion;
				    faction wh3_main_tze_sarthoraels_watchers;
				    confederation_valid;
				}

				objective
				{
				type OWN_N_REGIONS_INCLUDING;
				total 9;
				region cr_oldworld_region_hell_pit;
				region cr_oldworld_region_hell_pit_second;
				region cr_oldworld_region_hell_pit_third;
				region cr_oldworld_region_hell_pit_fourth;
				region cr_oldworld_region_hell_pit_fifth;
				region cr_oldworld_region_hell_pit_sixth;
				region cr_oldworld_region_hell_pit_seventh;
				region cr_oldworld_region_hell_pit_eighth;
				region cr_oldworld_region_hell_pit_ninth;
				}

				payload
				{
					effect_bundle
					{
						bundle_key vco_victory_payload_skv_mdr_1_yes_yes_prepare_the_lab;
						turns 1;
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
			victory_type vco_victory_type_pow_ext_skv_clan_moulder_2;
			key wh_main_long_victory;
			issuer CLAN_ELDERS;
			primary_objectives_and_payload
			{
				objective
				{
					override_text mission_text_text_pow_ext_skv_mdr_2_the_vermintide_comes;
					type SCRIPTED;
					script_key vco_dummy;
				}

				objective
				{
				    type DESTROY_FACTION;
				    faction wh3_main_ksl_the_great_orthodoxy;
				    faction wh3_main_ksl_the_ice_court;
				    faction wh_main_emp_wissenland;
				    faction wh_main_emp_empire;
				    confederation_valid;
				}

				objective
				{
				type CAPTURE_X_BATTLE_CAPTIVES;
				total 20000;
				}

				objective
				{
				type CONTROL_N_REGIONS_INCLUDING;
				total 2;
				region cr_oldworld_region_kislev;
				region cr_oldworld_region_altdorf;
				}

				payload
				{
					effect_bundle
					{
						bundle_key vco_victory_payload_skv_mdr_2_the_vermintide_comes;
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
			victory_type vco_victory_type_pow_ext_skv_clan_moulder_3;
			key wh_main_domination_victory;
			issuer CLAN_ELDERS;
			primary_objectives_and_payload
			{
				objective
				{
					override_text mission_text_text_pow_ext_skv_mdr_3_ultimate_harvest;
					type SCRIPTED;
					script_key vco_dummy;
				}

				objective
				{
				    type DESTROY_FACTION;
				    faction wh2_dlc16_wef_drycha;
				    faction wh_dlc05_wef_wood_elves;
				    faction wh_dlc05_wef_argwylon;
				    confederation_valid;
				}

				objective
				{
				type RAZE_OR_OWN_SETTLEMENTS;
				region cr_oldworld_region_the_oak_of_ages;
				}


				payload
				{
					effect_bundle
					{
						bundle_key vco_victory_payload_skv_mdr_3_ultimate_harvest;
						turns 1;
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
