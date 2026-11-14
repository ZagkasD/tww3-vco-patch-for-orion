local missions = {
[[
 		mission
		{
			victory_type vco_victory_type_pow_ext_wh_main_vmp_vampire_counts_1;
			key wh_main_short_victory;
			issuer CLAN_ELDERS;
			primary_objectives_and_payload
			{
				objective
				{
					override_text mission_text_text_pow_ext_vmp_man_1_restless_dunes;
					type SCRIPTED;
					script_key vco_dummy;
				}

				objective
				{
				    type DESTROY_FACTION;
				    faction wh2_dlc09_tmb_khemri;
				    faction wh2_dlc09_tmb_the_sentinels;
				    faction wh2_dlc09_tmb_rakaph_dynasty;
				    confederation_valid;
				}

				objective
				{
				type CONTROL_N_PROVINCES_INCLUDING;
				total 7;
				province cr_oldworld_province_city_of_kings;
				province cr_oldworld_province_upper_ash_river;
				province cr_oldworld_province_lower_ash_river;
				province cr_oldworld_province_canal_of_abundance;
				province cr_oldworld_province_necropolis_of_khemri;
				province cr_oldworld_province_black_pyramid_of_nagash;
				province cr_oldworld_province_quatari_desert;
				}

				objective
				{
				type OWN_N_REGIONS_INCLUDING;
				total 1;
				region cr_oldworld_region_black_pyramid_of_nagash;
				}

				payload
				{
					effect_bundle
					{
						bundle_key vco_victory_payload_vmp_man_1_restless_dunes;
						turns 0;
					}

					effect_bundle
					{
						bundle_key vco_victory_payload_vmp_man_2_reclaim_throne;
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
			victory_type vco_victory_type_pow_ext_wh_main_vmp_vampire_counts_2;
			key wh_main_long_victory;
			issuer CLAN_ELDERS;
			primary_objectives_and_payload
			{
				objective
				{
					override_text mission_text_text_pow_ext_vmp_man_3_death_comes_for_all;
					type SCRIPTED;
					script_key vco_dummy;
				}

				objective
				{
				override_text mission_text_text_pow_ext_vmp_man_5_books_collected_b2_0_0;
				type SCRIPTED;
				script_key pow_ext_framework_completen_wh_main_vmp_vampire_counts_II_nagash_books;
				}

				objective
				{
				type OWN_N_REGIONS_INCLUDING;
				total 2;
				region cr_oldworld_region_black_pyramid_of_nagash;
				region cr_oldworld_region_nagashizzar;
				}

				payload
				{
					effect_bundle
					{
						bundle_key vco_victory_payload_vmp_man_3_death_comes_for_all_1;
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
			victory_type vco_victory_type_pow_ext_wh_main_vmp_vampire_counts_3;
			key wh_main_domination_victory;
			issuer CLAN_ELDERS;
			primary_objectives_and_payload
			{
				objective
				{
					override_text mission_text_text_pow_ext_vmp_man_2_reclaim_throne;
					type SCRIPTED;
					script_key vco_dummy;
				}

				objective
				{
					override_text mission_text_text_pow_ext_vmp_man_3_reclaim_throne_hint;
					type SCRIPTED;
					script_key vco_dummy;
				}

				objective
				{
				    type DESTROY_FACTION;
				    faction wh_main_emp_empire;
				    confederation_valid;
				}

				objective
				{
				type OWN_N_REGIONS_INCLUDING;
				total 1;
				region cr_oldworld_region_castle_drakenhof;
				}

				objective
				{
				type CONTROL_N_PROVINCES_INCLUDING;
				total 4;
				province cr_oldworld_province_haunted_hills;
				province cr_oldworld_province_marienburg;
				province cr_oldworld_province_altdorf;
				province cr_oldworld_province_nuln;
				}

				payload
				{
					effect_bundle
					{
						bundle_key vco_victory_payload_vmp_man_3_death_comes_for_all_2;
						turns 0;
					}

					add_ancillary_to_faction_pool
					{
						ancillary_key vco_anc_weapon_ghal_maraz;
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
