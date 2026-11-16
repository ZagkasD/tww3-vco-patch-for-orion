-- TODO: add the two other mission routes (route 2 in progress)
-- TODO: fix mission 1 destroy factions. They are too far away (expect wh2_dlc15_grn_broken_axe)
-- TODO: check vco for wh2_main_special_salzenmund_laurelorn_wef_1 (that building only has lvl 3, vco might be broken)
-- TODO: update description of wh_dlc05_qb_wef_grand_defense_of_the_oak

local missions = {
[[
 		mission
	{
		victory_type vco_victory_type_pow_ext_wef_orion_1;
		key wh_main_short_victory;
		issuer VCO_ISSUER_IME_1;
		primary_objectives_and_payload
		{
			objective
			{
				override_text mission_text_text_pow_ext_wef_orion_1_oak_of_ages;
				type SCRIPTED;
				script_key vco_dummy;
			}

			objective
			{
				type OWN_N_REGIONS_INCLUDING;
				total 1;
				region cr_oldworld_region_the_oak_of_ages;
			}

			objective
			{
				override_text mission_text_text_pow_ext_wef_orion_1_defend_oak;
				type FIGHT_SET_PIECE_BATTLE;
				set_piece_battle wh_dlc05_qb_wef_grand_defense_of_the_oak;
			}

			objective
			{
				type DESTROY_FACTION;
				faction wh2_dlc11_vmp_the_barrow_legion;
				faction wh2_dlc15_grn_broken_axe;
				faction wh2_main_skv_clan_skryre;
				faction wh_dlc05_bst_morghur_herd;
				confederation_valid;
			}

			payload
			{
				effect_bundle
				{
					bundle_key vco_victory_payload_wef_ori_1_oak_of_ages;
					turns 1;
				}

				text_display vco_text_display_orion_unique_glade_lord;

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
		victory_type vco_victory_type_pow_ext_wef_orion_2;
		key vco_route_victory;
		issuer VCO_ISSUER_IME_2;
		primary_objectives_and_payload
		{
			objective
			{
				override_text mission_text_text_vco_wef_ori_2_laurelorn_forest;
				type SCRIPTED;
				script_key vco_dummy;
			}

			objective
			{
				type CONSTRUCT_BUILDING_IN_PROVINCES;
				faction wh_dlc05_wef_wood_elves;
				province cr_oldworld_province_laurelorn_forest;
				building_level wh2_main_special_salzenmund_laurelorn_wef_3;
			}

			objective
			{
				override_text mission_text_text_vco_wef_ori_2_laurelorn_forest_1;
				type CONTROL_N_REGIONS_FROM;
				total 5;
				region cr_oldworld_region_oldenlitz;
				region cr_oldworld_region_vorbegwerk;
				region cr_oldworld_region_aarnau;
				region cr_oldworld_region_drachenhohle;
				region cr_oldworld_region_dietershafen;
			}

			payload
			{
				effect_bundle
				{
					bundle_key vco_victory_payload_wef_ori_2_laurelorn_forest;
					turns 1;
				}

				effect_bundle
				{
					bundle_key vco_victory_payload_all_campaign_victory_dummy;
					turns 0;
				}

				game_victory;
			}
		}
	}
]]
};

return missions;
