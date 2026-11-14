local missions = {
[[
 		mission
		{
			victory_type vco_victory_type_pow_ext_sla_the_tormentors_1;
			key wh_main_short_victory;
			issuer CLAN_ELDERS;
			primary_objectives_and_payload
			{
				objective
				{
					override_text mission_text_text_pow_ext_sla_dec_1;
					type SCRIPTED;
					script_key vco_dummy;
				}

				objective
				{
				    type DESTROY_FACTION;
				    faction wh3_main_cth_the_western_provinces;
				    confederation_valid;
				}

				objective
				{
				type CAPTURE_X_BATTLE_CAPTIVES;
				total 10000;
				}

				objective
				{
				type CONTROL_N_REGIONS_INCLUDING;
				total 1;
				region cr_oldworld_region_kharakorsi;
				}

				objective
				{
				type CONTROL_N_PROVINCES_INCLUDING;
				total 6;
				province cr_oldworld_province_shardback_foothills;
				province cr_oldworld_province_eastern_steppes;
				province cr_oldworld_province_road_to_damnation;
				province cr_oldworld_province_grave_of_scythia;
				province cr_oldworld_province_crossroads_of_the_world;
				province cr_oldworld_province_blizzard_vale;
				}

				payload
				{
					effect_bundle
					{
						bundle_key vco_victory_payload_sla_dec_1;
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
			victory_type vco_victory_type_pow_ext_sla_the_tormentors_2;
			key wh_main_long_victory;
			issuer CLAN_ELDERS;
			primary_objectives_and_payload
			{
				objective
				{
					override_text mission_text_text_pow_ext_dechala_elixir_of_excess;
					type SCRIPTED;
					script_key vco_dummy;
				}

				objective
				{
				    type DESTROY_FACTION;
				    faction wh3_dlc20_chs_festus;
				    confederation_valid;
				}

				objective
				{
				type CONTROL_N_REGIONS_FROM;
				total 1;
				region cr_oldworld_region_the_oak_of_ages;
				region cr_oldworld_region_waterfall_palace;
				region cr_oldworld_region_gryphon_wood;
				region cr_oldworld_region_forest_of_sighs;
				region cr_oldworld_region_forest_of_gloom;
				}

				payload
				{
					effect_bundle
					{
						bundle_key vco_victory_payload_sla_dec_2;
						turns 0;
					}

					add_ancillary_to_faction_pool
					{
						ancillary_key vco_anc_enchanted_item_dechala_elixir_of_excess;
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
			victory_type vco_victory_type_pow_ext_sla_the_tormentors_3;
			key wh_main_domination_victory;
			issuer KING_KAZADOR;
			primary_objectives_and_payload
			{
				objective
				{
					override_text mission_text_text_pow_ext_sla_dec_3;
					type SCRIPTED;
					script_key vco_dummy;
				}

				objective
				{
				type CONTROL_N_REGIONS_INCLUDING;
				total 3;
				region cr_oldworld_region_brass_citadel;
				region cr_oldworld_region_brass_keep;
				region cr_oldworld_region_drifting_castle;
				region cr_oldworld_region_hell_pit;
				}

				payload
				{
					effect_bundle
					{
						bundle_key vco_victory_payload_sla_dec_3;
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
