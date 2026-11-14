local missions = {
[[
 		mission
		{
			victory_type vco_victory_type_pow_ext_wh_dlc05_bst_morghur_herd_1;
			key wh_main_short_victory;
			issuer CLAN_ELDERS;
			primary_objectives_and_payload
			{
				objective
				{
					override_text mission_text_text_pow_ext_morghur_forest_of_arden;
					type SCRIPTED;
					script_key vco_dummy;
				}

				objective
				{
				    type DESTROY_FACTION;
				    faction wh_main_brt_carcassonne;
				    faction wh_main_brt_bretonnia;
				    confederation_valid;
				}

				objective
				{
				type RAZE_OR_OWN_SETTLEMENTS;
				region cr_oldworld_region_castle_carcassonne;
				region cr_oldworld_region_castle_bastonne;
				region cr_oldworld_region_castle_artois;
				region cr_oldworld_region_couronne;
				}

				payload
				{
					effect_bundle
					{
						bundle_key vco_victory_payload_bst_mor_1_bretonnia;
						turns 0;
					}

					add_ancillary_to_faction_pool
					{
						ancillary_key pow_ext_anc_enchanted_item_morgaines_mirror;
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
			victory_type vco_victory_type_pow_ext_wh_dlc05_bst_morghur_herd_2;
			key wh_main_long_victory;
			issuer CLAN_ELDERS;
			primary_objectives_and_payload
			{
				objective
				{
					override_text mission_text_text_pow_ext_morghur_destroyer_of_men_b2_0;
					type SCRIPTED;
					script_key vco_dummy;
				}

				objective
				{
				    type DESTROY_FACTION;
				    faction wh_main_emp_empire;
				    faction wh_main_emp_wissenland;
				    faction wh_main_emp_marienburg;
				    confederation_valid;
				}

				objective
				{
				type RAZE_OR_OWN_SETTLEMENTS;
				region cr_oldworld_region_altdorf;
				region cr_oldworld_region_nuln;
				region cr_oldworld_region_marienburg;
				}

				payload
				{
					effect_bundle
					{
						bundle_key pow_ext_victory_payload_bst_mor_2_drakwald_defiled;
						turns 0;
					}

					add_ancillary_to_faction_pool
					{
						ancillary_key pow_ext_anc_talisman_broken_defiled_crown;
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
			victory_type vco_victory_type_pow_ext_wh_dlc05_bst_morghur_herd_3;
			key wh_main_domination_victory;
			issuer CLAN_ELDERS;
			primary_objectives_and_payload
			{
				objective
				{
					override_text mission_text_text_pow_ext_bst_mor_1_wood_elves;
					type SCRIPTED;
					script_key vco_dummy;
				}

				objective
				{
				    type DESTROY_FACTION;
				    faction wh_dlc05_wef_wood_elves;
				    faction wh_dlc05_wef_argwylon;
				    confederation_valid;
				}

				objective
				{
				type RAZE_OR_OWN_SETTLEMENTS;
				region cr_oldworld_region_the_oak_of_ages;
				region cr_oldworld_region_waterfall_palace;
				region cr_oldworld_region_crag_halls_of_findol;
				region cr_oldworld_region_kings_glade;
				}

				payload
				{
					effect_bundle
					{
						bundle_key vco_victory_payload_bst_mor_1_wood_elves;
						turns 1;
					}

					effect_bundle
					{
						bundle_key vco_victory_payload_bst_mor_3_high_elves;
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
