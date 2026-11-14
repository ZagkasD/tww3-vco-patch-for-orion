local missions = {
[[
 		mission
		{
			victory_type vco_victory_type_pow_ext_wh_dlc08_nor_norsca_1;
			key wh_main_short_victory;
			issuer CLAN_ELDERS;
			primary_objectives_and_payload
			{
				objective
				{
					override_text mission_text_text_pow_ext_nor_wul_1_lustria;
					type SCRIPTED;
					script_key vco_dummy;
				}

				objective
				{
				override_text mission_text_text_pow_ext_nor_wul_hunt_0;
				type SCRIPTED;
				script_key pow_ext_framework_completen_wh_dlc08_nor_norsca_I_hunt;
				}

				objective
				{
				type OCCUPY_LOOT_RAZE_OR_SACK_X_SETTLEMENTS;
				total 30;
				}

				payload
				{
					effect_bundle
					{
						bundle_key vco_victory_payload_nor_wul_1_lustria;
						turns 0;
					}

					effect_bundle
					{
						bundle_key vco_victory_payload_nor_wul_1_monster_hunter;
						turns 0;
					}

					add_ancillary_to_faction_pool
					{
						ancillary_key vco_anc_follower_adella;
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
			victory_type vco_victory_type_pow_ext_wh_dlc08_nor_norsca_2;
			key wh_main_long_victory;
			issuer CLAN_ELDERS;
			primary_objectives_and_payload
			{
				objective
				{
					override_text mission_text_text_pow_ext_wulfrik_alberic_grudge;
					type SCRIPTED;
					script_key vco_dummy;
				}

				objective
				{
					override_text mission_text_text_pow_ext_nor_wul_r2_favour;
					type SCRIPTED;
					script_key attain_chaos_god_favour_lvl_3;
				}

				objective
				{
				    type DESTROY_FACTION;
				    faction wh_main_brt_bordeleaux;
				    confederation_valid;
				}

				objective
				{
				type CONTROL_N_REGIONS_INCLUDING;
				total 1;
				region cr_oldworld_region_castle_bordeleaux;
				}

				payload
				{
					effect_bundle
					{
						bundle_key vco_victory_payload_nor_wul_3_sea_fang;
						turns 0;
					}

					add_ancillary_to_faction_pool
					{
						ancillary_key vco_anc_weapon_trident_manann;
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
			victory_type vco_victory_type_pow_ext_wh_dlc08_nor_norsca_3;
			key wh_main_domination_victory;
			issuer CLAN_ELDERS;
			primary_objectives_and_payload
			{
				objective
				{
					override_text mission_text_text_pow_ext_nor_wul_2_eternal_challenger;
					type SCRIPTED;
					script_key vco_dummy;
				}

				objective
				{
				override_text mission_text_text_pow_ext_framework_route_prereq_I_wh_dlc08_nor_norsca;
				type SCRIPTED;
				script_key pow_ext_framework_route_prereq_I_wh_dlc08_nor_norsca;
				}

				objective
				{
					override_text mission_text_text_pow_ext_nor_wul_r3_favour;
					type SCRIPTED;
					script_key attain_chaos_god_favour_lvl_4;
				}

				objective
				{
				override_text mission_text_text_pow_ext_nor_wul_r3_ll_kill_0;
				type SCRIPTED;
				script_key pow_ext_framework_kill_wh_dlc08_nor_norsca_III_ll_long;
				}

				payload
				{
					effect_bundle
					{
						bundle_key vco_victory_payload_nor_wul_2_eternal_challenger;
						turns 0;
					}

					effect_bundle
					{
						bundle_key vco_victory_payload_nor_wul_2_apocalypse_now;
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
