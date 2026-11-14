local missions = {
[[
 		mission
		{
			victory_type vco_victory_type_pow_ext_chs_shadow_legion_1;
			key wh_main_short_victory;
			issuer CLAN_ELDERS;
			primary_objectives_and_payload
			{
				objective
				{
					override_text mission_text_text_pow_ext_belakor_r1_shadows_over_albion;
					type SCRIPTED;
					script_key vco_dummy;
				}

				objective
				{
				    type DESTROY_FACTION;
				    faction wh2_dlc13_emp_the_huntmarshals_expedition;
				    faction wh3_dlc24_cth_the_celestial_court;
				    faction wh2_main_lzd_last_defenders;
				    confederation_valid;
				}

				payload
				{
					effect_bundle
					{
						bundle_key pow_ext_belakor_r1_harbinger_legions;
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
			victory_type vco_victory_type_pow_ext_chs_shadow_legion_2;
			key wh_main_long_victory;
			issuer CLAN_ELDERS;
			primary_objectives_and_payload
			{
				objective
				{
					override_text mission_text_text_pow_ext_belakor_r2_one_by_one;
					type SCRIPTED;
					script_key vco_dummy;
				}

				objective
				{
				override_text mission_text_text_pow_ext_belakor_r2_executioner_0;
				type SCRIPTED;
				script_key pow_ext_framework_kill_wh3_main_chs_shadow_legion_II_executioner;
				}

				payload
				{
					effect_bundle
					{
						bundle_key pow_ext_belakor_r2_harbinger_aspect;
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
			victory_type vco_victory_type_pow_ext_chs_shadow_legion_3;
			key wh_main_domination_victory;
			issuer KING_KAZADOR;
			primary_objectives_and_payload
			{
				objective
				{
					override_text mission_text_text_pow_ext_belakor_r3_the_crown_taken;
					type SCRIPTED;
					script_key vco_dummy;
				}

				objective
				{
				override_text mission_text_text_pow_ext_belakor_r3_r2_prereq;
				type SCRIPTED;
				script_key pow_ext_framework_route_prereq_II_wh3_main_chs_shadow_legion;
				}

				objective
				{
				    type DESTROY_FACTION;
				    faction wh3_dlc26_kho_skulltaker;
				    faction wh3_main_tze_oracles_of_tzeentch;
				    faction wh3_dlc25_nur_epidemius;
				    faction wh3_main_sla_seducers_of_slaanesh;
				    confederation_valid;
				}

				payload
				{
					effect_bundle
					{
						bundle_key vco_victory_payload_chs_bel_2_no_strings_on_me;
						turns 0;
					}

					add_ancillary_to_faction_pool
					{
						ancillary_key vco_anc_enchanted_item_the_crown_of_domination;
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
