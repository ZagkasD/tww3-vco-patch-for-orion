local missions = {
[[
 		mission
		{
			victory_type vco_victory_type_pow_ext_tze_oracles_of_tzeentch_1;
			key wh_main_short_victory;
			issuer CLAN_ELDERS;
			primary_objectives_and_payload
			{
				objective
				{
					override_text mission_text_text_pow_ext_kairos_crystal_labyrinth;
					type SCRIPTED;
					script_key vco_dummy;
				}

				objective
				{
				    type DESTROY_FACTION;
				    faction wh3_main_nur_septic_claw;
				    confederation_valid;
				}

				objective
				{
				type CONTROL_N_REGIONS_INCLUDING;
				total 13;
				region cr_oldworld_region_frozen_moon;
				region cr_oldworld_region_eternity_stair;
				region cr_oldworld_region_true_liars_monolith;
				region cr_oldworld_region_ruins_of_the_dead_king;
				region cr_oldworld_region_impossible_fortress;
				region cr_oldworld_region_heavenward_halls;
				region cr_oldworld_region_eyrie_of_the_watcher;
				region cr_oldworld_region_citadel_of_the_iron_knight;
				region cr_oldworld_region_ninth_library;
				region cr_oldworld_region_obsidian_council;
				region cr_oldworld_region_mountains_of_questioning;
				region cr_oldworld_region_blasted_wastes;
				region cr_oldworld_region_crystal_labyrinth;
				}

				payload
				{
					effect_bundle
					{
						bundle_key vco_victory_payload_tze_kai_1_great_game;
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
			victory_type vco_victory_type_pow_ext_tze_oracles_of_tzeentch_2;
			key wh_main_long_victory;
			issuer MUFFIN_MAN;
			primary_objectives_and_payload
			{
				objective
				{
					override_text mission_text_text_pow_ext_kairos_visions_past;
					type SCRIPTED;
					script_key vco_dummy;
				}

				objective
				{
				    type DESTROY_FACTION;
				    faction wh2_dlc09_tmb_dune_kingdoms;
				    faction wh2_dlc09_tmb_followers_of_nagash;
				    faction wh2_dlc09_tmb_khemri;
				    confederation_valid;
				}

				objective
				{
				type CONTROL_N_REGIONS_INCLUDING;
				total 2;
				region cr_oldworld_region_khemri;
				region cr_oldworld_region_black_pyramid_of_nagash;
				}

				payload
				{
					effect_bundle
					{
						bundle_key vco_victory_payload_tze_kai_2_visions_past;
						turns 0;
					}

					add_ancillary_to_faction_pool
					{
						ancillary_key vco_anc_arcane_item_cube_of_darkness;
					}

					add_ancillary_to_faction_pool
					{
						ancillary_key vco_anc_weapon_the_blade_of_realities;
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
			victory_type vco_victory_type_pow_ext_tze_oracles_of_tzeentch_3;
			key wh_main_domination_victory;
			issuer CLAN_ELDERS;
			primary_objectives_and_payload
			{
				objective
				{
					override_text mission_text_text_pow_ext_kairos_visions_future;
					type SCRIPTED;
					script_key vco_dummy;
				}

				objective
				{
				    type DESTROY_FACTION;
				    faction wh3_main_emp_cult_of_sigmar;
				    faction wh_main_emp_wissenland;
				    confederation_valid;
				}

				objective
				{
				type CONTROL_N_REGIONS_INCLUDING;
				total 2;
				region cr_oldworld_region_nachtdorf;
				region cr_oldworld_region_nuln;
				}

				payload
				{
					effect_bundle
					{
						bundle_key vco_victory_payload_tze_kai_3_visions_future;
						turns 0;
					}

					add_ancillary_to_faction_pool
					{
						ancillary_key vco_anc_enchanted_item_hand_of_gods;
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
