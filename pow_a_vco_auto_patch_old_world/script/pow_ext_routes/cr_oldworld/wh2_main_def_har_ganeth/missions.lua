local missions = {
[[
 		mission
		{
			victory_type vco_victory_type_pow_ext_def_har_ganeth_1;
			key wh_main_short_victory;
			issuer CLAN_ELDERS;
			primary_objectives_and_payload
			{
				objective
				{
					override_text mission_text_text_pow_ext_hellebron_suffer_not_another_queen;
					type SCRIPTED;
					script_key vco_dummy;
				}

				objective
				{
				    type DESTROY_FACTION;
				    faction wh3_dlc24_cth_the_celestial_court;
				    faction wh2_main_hef_nagarythe;
				    faction wh2_dlc13_emp_the_huntmarshals_expedition;
				    faction wh2_main_lzd_last_defenders;
				    confederation_valid;
				}

				objective
				{
				type CONTROL_N_REGIONS_INCLUDING;
				total 5;
				region cr_oldworld_region_nagronath;
				region cr_oldworld_region_neuland;
				region cr_oldworld_region_konquata;
				region cr_oldworld_region_great_ogham;
				region cr_oldworld_region_tower_of_llenog;
				}

				payload
				{
					effect_bundle
					{
						bundle_key pow_ext_victory_payload_def_gan_1_witch_queen_walks_albion;
						turns 0;
					}

					add_ancillary_to_faction_pool
					{
						ancillary_key vco_anc_follower_dark_convent_defector;
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
			victory_type vco_victory_type_pow_ext_def_har_ganeth_2;
			key wh_main_long_victory;
			issuer CLAN_ELDERS;
			primary_objectives_and_payload
			{
				objective
				{
					override_text mission_text_text_pow_ext_hellebron_sack_of_elftown;
					type SCRIPTED;
					script_key vco_dummy;
				}

				objective
				{
				type OWN_N_REGIONS_INCLUDING;
				total 1;
				region cr_oldworld_region_elftown;
				}

				objective
				{
				    type DESTROY_FACTION;
				    faction wh_main_brt_bretonnia;
				    faction wh_main_emp_marienburg;
				    faction cr_hef_continental_exarchate;
				    confederation_valid;
				}


				payload
				{
					effect_bundle
					{
						bundle_key pow_ext_victory_payload_def_gan_2_cauldron_fills;
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
			victory_type vco_victory_type_pow_ext_def_har_ganeth_3;
			key wh_main_domination_victory;
			issuer CLAN_ELDERS;
			primary_objectives_and_payload
			{
				objective
				{
					override_text mission_text_text_pow_ext_hellebron_khaines_coronation;
					type SCRIPTED;
					script_key vco_dummy;
				}

				objective
				{
				type CAPTURE_X_BATTLE_CAPTIVES;
				total 15000;
				}

				objective
				{
				    type DESTROY_FACTION;
				    faction wh_main_brt_bordeleaux;
				    faction wh_main_brt_carcassonne;
				    confederation_valid;
				}

				objective
				{
				type CONTROL_N_REGIONS_INCLUDING;
				total 2;
				region cr_oldworld_region_castle_bordeleaux;
				region cr_oldworld_region_castle_carcassonne;
				}

				payload
				{
					effect_bundle
					{
						bundle_key pow_ext_victory_payload_def_gan_3_lady_unmasked_foreshadow;
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
