local missions = {
[[
 		mission
		{
			victory_type vco_victory_type_pow_ext_wef_drycha_1;
			key wh_main_short_victory;
			issuer MUFFIN_MAN;
			primary_objectives_and_payload
			{
				objective
				{
					override_text mission_text_text_pow_ext_wef_dry_1_gryphon_wood;
					type SCRIPTED;
					script_key vco_dummy;
				}

				objective
				{
				type CONSTRUCT_BUILDING_IN_PROVINCES;
				faction wh2_dlc16_wef_drycha;
				province cr_oldworld_province_gryphon_wood;
				building_level wh_dlc05_wef_temple_ereth_khial_1;
				}

				objective
				{
				type FIGHT_SET_PIECE_BATTLE;
				set_piece_battle wh2_dlc16_qb_wef_drycha_coeddil_unchained;
				}

				objective
				{
				type DEFEAT_N_ARMIES_OF_FACTION;
				total 20;
				}

				payload
				{
					effect_bundle
					{
						bundle_key vco_victory_payload_wef_dry_1_gryphon_wood;
						turns 0;
					}

					add_ancillary_to_faction_pool
					{
						ancillary_key vco_anc_follower_ska_kerillian;
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
			victory_type vco_victory_type_pow_ext_wef_drycha_2;
			key wh_main_long_victory;
			issuer CLAN_ELDERS;
			primary_objectives_and_payload
			{
				objective
				{
					override_text mission_text_text_pow_ext_wef_dry_2_where_the_asrai_fled;
					type SCRIPTED;
					script_key vco_dummy;
				}

				objective
				{
				type CONSTRUCT_N_BUILDINGS_FROM;
				faction wh2_dlc16_wef_drycha;
				total 4;
				building_level cr_wef_temple_lileath_1;
				building_level cr_wef_temple_drakira_1;
				building_level cr_wef_temple_hoeth_1;
				building_level cr_wef_temple_asuryan_1;
				building_level cr_wef_temple_eldrazor_1;
				building_level wh_dlc05_wef_temple_kurnous_1;
				building_level cr_wef_guerac_circle_1;
				building_level wh2_main_special_salzenmund_laurelorn_wef_1;
				}

				payload
				{
					effect_bundle
					{
						bundle_key pow_ext_victory_payload_wef_dry_2_foreshadow;
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
			victory_type vco_victory_type_pow_ext_wef_drycha_3;
			key wh_main_domination_victory;
			issuer CLAN_ELDERS;
			primary_objectives_and_payload
			{
				objective
				{
					override_text mission_text_text_pow_ext_wef_dry_3_reclaim_oak_ages;
					type SCRIPTED;
					script_key vco_dummy;
				}

				objective
				{
				override_text mission_text_text_pow_ext_framework_route_prereq_II_wh2_dlc16_wef_drycha;
				type SCRIPTED;
				script_key pow_ext_framework_route_prereq_II_wh2_dlc16_wef_drycha;
				}

				objective
				{
				type OWN_N_REGIONS_INCLUDING;
				total 1;
				region cr_oldworld_region_the_oak_of_ages;
				}

				objective
				{
				    type DESTROY_FACTION;
				    faction wh_dlc05_wef_wood_elves;
				    confederation_valid;
				}

				objective
				{
				type CONSTRUCT_N_BUILDINGS_FROM;
				faction wh2_dlc16_wef_drycha;
				total 4;
				building_level wh_dlc05_wef_tree_delliandra_1;
				building_level wh_dlc05_wef_tree_druthandor_1;
				building_level wh_dlc05_wef_tree_talrennic_1;
				building_level wh_dlc05_wef_tree_threllock_1;
				}

				payload
				{
					effect_bundle
					{
						bundle_key pow_ext_victory_payload_wef_dry_2_liberation;
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
