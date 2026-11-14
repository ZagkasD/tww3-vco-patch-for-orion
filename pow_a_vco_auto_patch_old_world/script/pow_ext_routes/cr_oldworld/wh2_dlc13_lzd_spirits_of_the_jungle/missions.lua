local missions = {
[[
 		mission
		{
			victory_type vco_victory_type_pow_ext_lzd_spirits_of_the_jungle_1;
			key wh_main_short_victory;
			issuer CLAN_ELDERS;
			primary_objectives_and_payload
			{
				objective
				{
					override_text mission_text_text_pow_ext_nakai_wanderer_intro_b2_0;
					type SCRIPTED;
					script_key vco_dummy;
				}

				objective
				{
				override_text mission_text_text_pow_ext_nakai_ll_kill_counter_b2_0_0;
				type SCRIPTED;
				script_key pow_ext_framework_kill_wh2_dlc13_lzd_spirits_of_the_jungle_I_ll_kill;
				}

				objective
				{
				override_text mission_text_text_pow_ext_nakai_great_plan_counter_b2_0_0;
				type SCRIPTED;
				script_key pow_ext_framework_factionregions_wh2_dlc13_lzd_spirits_of_the_jungle_I_great_plan;
				}

				objective
				{
				    type DESTROY_FACTION;
				    faction wh3_main_nur_poxmakers_of_nurgle;
				    faction wh_main_grn_orcs_of_the_bloody_hand;
				    confederation_valid;
				}

				payload
				{
					effect_bundle
					{
						bundle_key pow_ext_victory_payload_lzd_nak_1_wanderer_b2_0;
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
			victory_type vco_victory_type_pow_ext_lzd_spirits_of_the_jungle_2;
			key wh_main_long_victory;
			issuer CLAN_ELDERS;
			primary_objectives_and_payload
			{
				objective
				{
					override_text mission_text_text_pow_ext_nakai_purification_b2_0;
					type SCRIPTED;
					script_key vco_dummy;
				}

				objective
				{
				    type DESTROY_FACTION;
				    faction wh2_main_skv_clan_skryre;
				    faction wh2_dlc11_cst_pirates_of_sartosa;
				    faction wh2_dlc11_vmp_the_barrow_legion;
				    faction wh3_dlc27_sla_masque_of_slaanesh;
				    confederation_valid;
				}

				objective
				{
				type OCCUPY_LOOT_RAZE_OR_SACK_X_SETTLEMENTS;
				total 50;
				}

				payload
				{
					effect_bundle
					{
						bundle_key pow_ext_victory_payload_lzd_nak_2_coils;
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
			victory_type vco_victory_type_pow_ext_lzd_spirits_of_the_jungle_3;
			key wh_main_domination_victory;
			issuer CLAN_ELDERS;
			primary_objectives_and_payload
			{
				objective
				{
					override_text mission_text_text_pow_ext_nakai_protector_of_lizardkin_b2_0;
					type SCRIPTED;
					script_key vco_dummy;
				}

				objective
				{
				    type DESTROY_FACTION;
				    faction wh2_dlc13_emp_the_huntmarshals_expedition;
				    faction wh3_main_chs_shadow_legion;
				    faction wh2_main_def_har_ganeth;
				    confederation_valid;
				}

				objective
				{
				type CONTROL_N_PROVINCES_INCLUDING;
				total 8;
				province cr_oldworld_province_muddy_point;
				province cr_oldworld_province_the_lost_road;
				province cr_oldworld_province_whale_coast;
				province cr_oldworld_province_neuland;
				province cr_oldworld_province_sherweald_forest;
				province cr_oldworld_province_the_lost_valley;
				province cr_oldworld_province_lakeland;
				province cr_oldworld_province_plain_of_battles;
				}

				payload
				{
					effect_bundle
					{
						bundle_key pow_ext_victory_payload_lzd_nak_3_protector_b2_0;
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
