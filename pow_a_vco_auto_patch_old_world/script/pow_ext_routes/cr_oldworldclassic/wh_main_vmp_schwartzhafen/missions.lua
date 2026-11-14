local missions = {
[[
 		mission
		{
			victory_type vco_victory_type_pow_ext_wh_main_vmp_schwartzhafen_1;
			key wh_main_short_victory;
			issuer CLAN_ELDERS;
			primary_objectives_and_payload
			{
				objective
				{
					override_text mission_text_text_pow_ext_vmp_vla_1_fourth_vampire_war;
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
				type CONTROL_N_PROVINCES_INCLUDING;
				total 3;
				province cr_oldworld_province_altdorf;
				province cr_oldworld_province_marienburg;
				province cr_oldworld_province_nuln;
				}

				objective
				{
				type OWN_N_REGIONS_INCLUDING;
				total 1;
				region cr_oldworld_region_castle_drakenhof;
				}

				payload
				{
					effect_bundle
					{
						bundle_key vco_victory_payload_vmp_vla_1_fourth_vampire_war;
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
]],
[[
 		mission
		{
			victory_type vco_victory_type_pow_ext_wh_main_vmp_schwartzhafen_2;
			key wh_main_long_victory;
			issuer CLAN_ELDERS;
			primary_objectives_and_payload
			{
				objective
				{
					override_text mission_text_text_pow_ext_vmp_vla_2_slaughter_slopes;
					type SCRIPTED;
					script_key vco_dummy;
				}

				objective
				{
				    type DESTROY_FACTION;
				    faction wh_main_dwf_dwarfs;
				    faction wh_main_dwf_karak_kadrin;
				    faction wh_main_dwf_zhufbar;
				    confederation_valid;
				}

				objective
				{
				type CONTROL_N_PROVINCES_INCLUDING;
				total 2;
				province cr_oldworld_province_peak_pass;
				province cr_oldworld_province_north_black_water;
				}

				payload
				{
					effect_bundle
					{
						bundle_key vco_victory_payload_vmp_vla_2_slaughter_slopes;
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
			victory_type vco_victory_type_pow_ext_wh_main_vmp_schwartzhafen_3;
			key wh_main_domination_victory;
			issuer CLAN_ELDERS;
			primary_objectives_and_payload
			{
				objective
				{
					override_text mission_text_text_pow_ext_vmp_vla_3_hearts_of_ice;
					type SCRIPTED;
					script_key vco_dummy;
				}

				objective
				{
				    type DESTROY_FACTION;
				    faction wh3_main_ksl_the_ice_court;
				    faction wh3_main_ksl_the_great_orthodoxy;
				    confederation_valid;
				}

				objective
				{
				type CONTROL_N_PROVINCES_INCLUDING;
				total 3;
				province cr_oldworld_province_urskoy_river;
				province cr_oldworld_province_river_lynsk;
				province cr_oldworld_province_eastern_oblast;
				}

				payload
				{
					effect_bundle
					{
						bundle_key vco_victory_payload_vmp_vla_3_hearts_of_ice;
						turns 0;
					}

					add_ancillary_to_faction_pool
					{
						ancillary_key vco_anc_follower_ice_vampire;
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
