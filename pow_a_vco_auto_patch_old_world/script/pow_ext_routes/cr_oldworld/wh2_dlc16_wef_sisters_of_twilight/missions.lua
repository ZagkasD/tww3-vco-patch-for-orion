local missions = {
[[
 		mission
		{
			victory_type vco_victory_type_pow_ext_wef_sisters_of_twilight_1;
			key wh_main_short_victory;
			issuer CLAN_ELDERS;
			primary_objectives_and_payload
			{
				objective
				{
					override_text mission_text_text_pow_ext_sisters_dreaming_wood_b2_0;
					type SCRIPTED;
					script_key vco_dummy;
				}

				objective
				{
				type CONSTRUCT_BUILDING_IN_PROVINCES;
				faction wh2_dlc16_wef_sisters_of_twilight;
				province cr_oldworld_province_forest_of_sighs;
				building_level cr_wef_temple_lileath_1;
				}

				objective
				{
				    type DESTROY_FACTION;
				    faction cr_skv_clan_crooktail;
				    faction wh3_dlc20_chs_vilitch;
				    confederation_valid;
				}

				payload
				{
					effect_bundle
					{
						bundle_key pow_ext_victory_payload_wef_twi_1_dreaming_wood;
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
			victory_type vco_victory_type_pow_ext_wef_sisters_of_twilight_2;
			key wh_main_long_victory;
			issuer CLAN_ELDERS;
			primary_objectives_and_payload
			{
				objective
				{
					override_text mission_text_text_pow_ext_sisters_sherweald_b2_0;
					type SCRIPTED;
					script_key vco_dummy;
				}

				objective
				{
				type CONSTRUCT_BUILDING_IN_PROVINCES;
				faction wh2_dlc16_wef_sisters_of_twilight;
				province cr_oldworld_province_sherweald_forest;
				building_level cr_wef_temple_hoeth_1;
				}

				objective
				{
				    type DESTROY_FACTION;
				    faction wh2_main_def_har_ganeth;
				    faction wh3_main_chs_shadow_legion;
				    confederation_valid;
				}

				payload
				{
					effect_bundle
					{
						bundle_key pow_ext_victory_payload_wef_twi_sherweald_herd;
						turns 0;
					}

					add_ancillary_to_faction_pool
					{
						ancillary_key vco_anc_enchanted_item_lotus_bloom_draught;
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
			victory_type vco_victory_type_pow_ext_wef_sisters_of_twilight_3;
			key wh_main_domination_victory;
			issuer CLAN_ELDERS;
			primary_objectives_and_payload
			{
				objective
				{
					override_text mission_text_text_pow_ext_sisters_worldroots_rebirth_b2_0;
					type SCRIPTED;
					script_key vco_dummy;
				}

				objective
				{
				override_text mission_text_text_pow_ext_sisters_worldroots_rebirth_main;
				type PERFORM_RITUAL;
				ritual_category WORLDROOTS_HEALING;
				total 4;
				}

				objective
				{
				override_text mission_text_text_pow_ext_sisters_oak_ritual;
				type PERFORM_RITUAL;
				ritual cr_ritual_rebirth_the_oak_of_ages;
				}

				objective
				{
				type FIGHT_SET_PIECE_BATTLE;
				set_piece_battle wh_dlc05_qb_wef_grand_defense_of_the_oak;
				}

				payload
				{
					effect_bundle
					{
						bundle_key pow_ext_victory_payload_wef_twi_3_worldroots;
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
