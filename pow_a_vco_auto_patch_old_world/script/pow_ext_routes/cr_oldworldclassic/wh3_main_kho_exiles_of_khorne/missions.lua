local missions = {
[[
 		mission
		{
			victory_type vco_victory_type_pow_ext_kho_exiles_of_khorne_1;
			key wh_main_short_victory;
			issuer CLAN_ELDERS;
			primary_objectives_and_payload
			{
				objective
				{
					override_text mission_text_text_pow_ext_kho_ska_1_kislev_sweep_b2_0;
					type SCRIPTED;
					script_key vco_dummy;
				}

				objective
				{
				type RAZE_OR_OWN_SETTLEMENTS;
				region cr_oldworld_region_kislev;
				region cr_oldworld_region_praag;
				}

				objective
				{
				    type DESTROY_FACTION;
				    faction wh3_main_ksl_the_ice_court;
				    faction wh3_main_ksl_the_great_orthodoxy;
				    faction wh3_main_ksl_ursun_revivalists;
				    faction wh3_dlc24_ksl_daughters_of_the_forest;
				    confederation_valid;
				}

				payload
				{
					effect_bundle
					{
						bundle_key vco_victory_payload_kho_ska_1_great_game;
						turns 0;
					}

					add_ancillary_to_faction_pool
					{
						ancillary_key wh3_main_anc_weapon_chainsword;
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
			victory_type vco_victory_type_pow_ext_kho_exiles_of_khorne_2;
			key wh_main_long_victory;
			issuer CLAN_ELDERS;
			primary_objectives_and_payload
			{
				objective
				{
					override_text mission_text_text_pow_ext_kho_ska_2_crack_the_holds_b2_0;
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
				type RAZE_OR_OWN_SETTLEMENTS;
				region cr_oldworld_region_karaz_a_karak;
				region cr_oldworld_region_karak_kadrin;
				region cr_oldworld_region_zhufbar;
				}

				payload
				{
					effect_bundle
					{
						bundle_key vco_victory_payload_kho_ska_2_blood_god;
						turns 0;
					}

					add_ancillary_to_faction_pool
					{
						ancillary_key vco_anc_follower_bloodcursed;
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
			victory_type vco_victory_type_pow_ext_kho_exiles_of_khorne_3;
			key wh_main_domination_victory;
			issuer CLAN_ELDERS;
			primary_objectives_and_payload
			{
				objective
				{
					override_text mission_text_text_pow_ext_kho_ska_3_crowns_of_blood_b2_0;
					type SCRIPTED;
					script_key vco_dummy;
				}

				objective
				{
				    type DESTROY_FACTION;
				    faction wh_main_vmp_schwartzhafen;
				    faction wh_main_emp_empire;
				    confederation_valid;
				}

				objective
				{
				type RAZE_OR_OWN_SETTLEMENTS;
				region cr_oldworld_region_castle_drakenhof;
				region cr_oldworld_region_altdorf;
				}

				payload
				{
					effect_bundle
					{
						bundle_key pow_ext_victory_payload_kho_ska_3_crowns_of_blood;
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
