
pow_ext_config = pow_ext_config or {}
pow_ext_config.thresholds = pow_ext_config.thresholds or {}
pow_ext_config.kill_lord_counters = pow_ext_config.kill_lord_counters or {}
pow_ext_config.route_prereqs = pow_ext_config.route_prereqs or {}
pow_ext_config.watch_incident = pow_ext_config.watch_incident or {}
pow_ext_config.count_vanilla_sv = pow_ext_config.count_vanilla_sv or {}
pow_ext_config.complete_n_missions = pow_ext_config.complete_n_missions or {}
pow_ext_config.count_faction_regions = pow_ext_config.count_faction_regions or {}
pow_ext_config.count_corruption_regions = pow_ext_config.count_corruption_regions or {}
pow_ext_config.route_on_complete = pow_ext_config.route_on_complete or {}
pow_ext_config.legendary_lord_subtype_set = pow_ext_config.legendary_lord_subtype_set or {}
pow_ext_config.kill_class_agent_actions = pow_ext_config.kill_class_agent_actions or {}

pow_ext_config.kill_lord_counters["wh2_dlc13_lzd_spirits_of_the_jungle"] = {
  classic = {
    {
      script_key = "pow_ext_framework_kill_wh2_dlc13_lzd_spirits_of_the_jungle_I_ll_kill",
      mission_key = "wh_main_short_victory",
      total = 5,
      text_prefix = "mission_text_text_pow_ext_nakai_ll_kill_counter_b2_0",
      complete_loc_key = "mission_text_text_pow_ext_nakai_ll_kill_counter_b2_0_complete",
      match = {
        legendary_lord = true,
        subculture = { "wh_main_sc_chs_chaos", "wh3_main_sc_kho_khorne", "wh3_main_sc_tze_tzeentch", "wh3_main_sc_nur_nurgle", "wh3_main_sc_sla_slaanesh", "wh3_main_sc_dae_daemons", "wh_dlc08_sc_nor_norsca", "wh_dlc03_sc_bst_beastmen", "wh3_dlc23_sc_chd_chaos_dwarfs", "wh2_main_sc_skv_skaven", "wh_main_sc_vmp_vampire_counts", "wh2_dlc11_sc_cst_vampire_coast", "wh_main_sc_grn_greenskins", "wh2_main_sc_def_dark_elves" },
      },
      kill_via = nil,
      on_complete = nil,
    },
  },
  main = {
    {
      script_key = "pow_ext_framework_kill_wh2_dlc13_lzd_spirits_of_the_jungle_I_ll_kill",
      mission_key = "wh_main_short_victory",
      total = 5,
      text_prefix = "mission_text_text_pow_ext_nakai_ll_kill_counter_b2_0",
      complete_loc_key = "mission_text_text_pow_ext_nakai_ll_kill_counter_b2_0_complete",
      match = {
        legendary_lord = true,
        subculture = { "wh_main_sc_chs_chaos", "wh3_main_sc_kho_khorne", "wh3_main_sc_tze_tzeentch", "wh3_main_sc_nur_nurgle", "wh3_main_sc_sla_slaanesh", "wh3_main_sc_dae_daemons", "wh_dlc08_sc_nor_norsca", "wh_dlc03_sc_bst_beastmen", "wh3_dlc23_sc_chd_chaos_dwarfs", "wh2_main_sc_skv_skaven", "wh_main_sc_vmp_vampire_counts", "wh2_dlc11_sc_cst_vampire_coast", "wh_main_sc_grn_greenskins", "wh2_main_sc_def_dark_elves" },
      },
      kill_via = nil,
      on_complete = nil,
    },
  },
}

pow_ext_config.kill_lord_counters["wh3_dlc24_cth_the_celestial_court"] = {
  classic = {
    {
      script_key = "pow_ext_framework_kill_wh3_dlc24_cth_the_celestial_court_II_executioner",
      mission_key = "wh_main_long_victory",
      total = 12,
      text_prefix = "mission_text_text_pow_ext_yuan_bo_r2_executioner_b2_0",
      complete_loc_key = "mission_text_text_pow_ext_yuan_bo_r2_executioner_b2_0_complete",
      match = {
        faction_leader = true,
        named = true,
      },
      kill_via = nil,
      on_complete = nil,
    },
  },
  main = {
    {
      script_key = "pow_ext_framework_kill_wh3_dlc24_cth_the_celestial_court_II_executioner",
      mission_key = "wh_main_long_victory",
      total = 12,
      text_prefix = "mission_text_text_pow_ext_yuan_bo_r2_executioner_b2_0",
      complete_loc_key = "mission_text_text_pow_ext_yuan_bo_r2_executioner_b2_0_complete",
      match = {
        faction_leader = true,
        named = true,
      },
      kill_via = nil,
      on_complete = nil,
    },
  },
}

pow_ext_config.kill_lord_counters["wh3_main_chs_shadow_legion"] = {
  classic = {
    {
      script_key = "pow_ext_framework_kill_wh3_main_chs_shadow_legion_II_executioner",
      mission_key = "wh_main_long_victory",
      total = 12,
      text_prefix = "mission_text_text_pow_ext_belakor_r2_executioner",
      complete_loc_key = "mission_text_text_pow_ext_belakor_r2_executioner_complete",
      match = {
        legendary_lord = true,
        dedup = true,
      },
      kill_via = nil,
      on_complete = nil,
    },
  },
  main = {
    {
      script_key = "pow_ext_framework_kill_wh3_main_chs_shadow_legion_II_executioner",
      mission_key = "wh_main_long_victory",
      total = 12,
      text_prefix = "mission_text_text_pow_ext_belakor_r2_executioner",
      complete_loc_key = "mission_text_text_pow_ext_belakor_r2_executioner_complete",
      match = {
        legendary_lord = true,
        dedup = true,
      },
      kill_via = nil,
      on_complete = nil,
    },
  },
}

pow_ext_config.kill_lord_counters["wh_dlc08_nor_norsca"] = {
  classic = {
    {
      script_key = "pow_ext_framework_kill_wh_dlc08_nor_norsca_III_ll_long",
      mission_key = "wh_main_domination_victory",
      total = 30,
      text_prefix = "mission_text_text_pow_ext_nor_wul_r3_ll_kill",
      complete_loc_key = "mission_text_text_pow_ext_nor_wul_r3_ll_kill_complete",
      match = {
        legendary_lord = true,
        allow_respawn = true,
      },
      kill_via = nil,
      on_complete = nil,
    },
  },
  main = {
    {
      script_key = "pow_ext_framework_kill_wh_dlc08_nor_norsca_III_ll_long",
      mission_key = "wh_main_domination_victory",
      total = 30,
      text_prefix = "mission_text_text_pow_ext_nor_wul_r3_ll_kill",
      complete_loc_key = "mission_text_text_pow_ext_nor_wul_r3_ll_kill_complete",
      match = {
        legendary_lord = true,
        allow_respawn = true,
      },
      kill_via = nil,
      on_complete = nil,
    },
  },
}

pow_ext_config.route_prereqs["wh2_dlc16_wef_drycha"] = {
  classic = {
    ["wh_main_long_victory"] = {
      later_mission_key = "wh_main_domination_victory",
      script_key = "pow_ext_framework_route_prereq_II_wh2_dlc16_wef_drycha",
    },
  },
  main = {
    ["wh_main_long_victory"] = {
      later_mission_key = "wh_main_domination_victory",
      script_key = "pow_ext_framework_route_prereq_II_wh2_dlc16_wef_drycha",
    },
  },
}

pow_ext_config.route_prereqs["wh3_dlc24_cth_the_celestial_court"] = {
  classic = {
    ["wh_main_long_victory"] = {
      later_mission_key = "wh_main_domination_victory",
      script_key = "pow_ext_framework_route_prereq_II_wh3_dlc24_cth_the_celestial_court",
    },
  },
  main = {
    ["wh_main_long_victory"] = {
      later_mission_key = "wh_main_domination_victory",
      script_key = "pow_ext_framework_route_prereq_II_wh3_dlc24_cth_the_celestial_court",
    },
  },
}

pow_ext_config.route_prereqs["wh3_main_chs_shadow_legion"] = {
  classic = {
    ["wh_main_long_victory"] = {
      later_mission_key = "wh_main_domination_victory",
      script_key = "pow_ext_framework_route_prereq_II_wh3_main_chs_shadow_legion",
    },
  },
  main = {
    ["wh_main_long_victory"] = {
      later_mission_key = "wh_main_domination_victory",
      script_key = "pow_ext_framework_route_prereq_II_wh3_main_chs_shadow_legion",
    },
  },
}

pow_ext_config.route_prereqs["wh3_main_dwf_the_ancestral_throng"] = {
  classic = {
    ["wh_main_long_victory"] = {
      later_mission_key = "wh_main_domination_victory",
      script_key = "pow_ext_framework_route_prereq_II_wh3_main_dwf_the_ancestral_throng",
    },
  },
  main = {
    ["wh_main_long_victory"] = {
      later_mission_key = "wh_main_domination_victory",
      script_key = "pow_ext_framework_route_prereq_II_wh3_main_dwf_the_ancestral_throng",
    },
  },
}

pow_ext_config.route_prereqs["wh3_main_ksl_the_ice_court"] = {
  classic = {
    ["wh_main_short_victory"] = {
      later_mission_key = "wh_main_domination_victory",
      script_key = "pow_ext_framework_route_prereq_I_wh3_main_ksl_the_ice_court",
    },
  },
  main = {
    ["wh_main_short_victory"] = {
      later_mission_key = "wh_main_domination_victory",
      script_key = "pow_ext_framework_route_prereq_I_wh3_main_ksl_the_ice_court",
    },
  },
}

pow_ext_config.route_prereqs["wh_dlc08_nor_norsca"] = {
  classic = {
    ["wh_main_short_victory"] = {
      later_mission_key = "wh_main_domination_victory",
      script_key = "pow_ext_framework_route_prereq_I_wh_dlc08_nor_norsca",
    },
  },
  main = {
    ["wh_main_short_victory"] = {
      later_mission_key = "wh_main_domination_victory",
      script_key = "pow_ext_framework_route_prereq_I_wh_dlc08_nor_norsca",
    },
  },
}

pow_ext_config.watch_incident["wh3_dlc24_cth_the_celestial_court"] = {
  classic = {
    {
      script_key = "pow_ext_framework_watchinc_wh3_dlc24_cth_the_celestial_court_III_compass_west",
      mission_key = "wh_main_domination_victory",
      incident_keys = { "wh3_dlc24_story_panel_yuan_bo_compass_west" },
      total = 1,
      text_prefix = "mission_text_text_pow_ext_yuan_bo_r3_compass_west_b2",
      complete_loc_key = nil,
      on_complete = {
        { type = "DILEMMA", key = "pow_ext_yuan_bo_celestial_winds_b2_0" },
      },
    },
    {
      script_key = "pow_ext_framework_watchinc_wh3_dlc24_cth_the_celestial_court_III_compass_north",
      mission_key = "wh_main_domination_victory",
      incident_keys = { "wh3_dlc24_story_panel_yuan_bo_compass_north" },
      total = 1,
      text_prefix = "mission_text_text_pow_ext_yuan_bo_r3_compass_north_b2",
      complete_loc_key = nil,
      on_complete = {
        { type = "DILEMMA", key = "pow_ext_yuan_bo_celestial_winds_b2_0" },
      },
    },
    {
      script_key = "pow_ext_framework_watchinc_wh3_dlc24_cth_the_celestial_court_III_compass_south",
      mission_key = "wh_main_domination_victory",
      incident_keys = { "wh3_dlc24_story_panel_yuan_bo_compass_south" },
      total = 1,
      text_prefix = "mission_text_text_pow_ext_yuan_bo_r3_compass_south_b2",
      complete_loc_key = nil,
      on_complete = {
        { type = "DILEMMA", key = "pow_ext_yuan_bo_celestial_winds_b2_0" },
      },
    },
    {
      script_key = "pow_ext_framework_watchinc_wh3_dlc24_cth_the_celestial_court_III_compass_east",
      mission_key = "wh_main_domination_victory",
      incident_keys = { "wh3_dlc24_story_panel_yuan_bo_compass_east" },
      total = 1,
      text_prefix = "mission_text_text_pow_ext_yuan_bo_r3_compass_east_b2",
      complete_loc_key = nil,
      on_complete = {
        { type = "DILEMMA", key = "pow_ext_yuan_bo_celestial_winds_b2_0" },
      },
    },
  },
  main = {
    {
      script_key = "pow_ext_framework_watchinc_wh3_dlc24_cth_the_celestial_court_III_compass_west",
      mission_key = "wh_main_domination_victory",
      incident_keys = { "wh3_dlc24_story_panel_yuan_bo_compass_west" },
      total = 1,
      text_prefix = "mission_text_text_pow_ext_yuan_bo_r3_compass_west_b2",
      complete_loc_key = nil,
      on_complete = {
        { type = "DILEMMA", key = "pow_ext_yuan_bo_celestial_winds_b2_0" },
      },
    },
    {
      script_key = "pow_ext_framework_watchinc_wh3_dlc24_cth_the_celestial_court_III_compass_north",
      mission_key = "wh_main_domination_victory",
      incident_keys = { "wh3_dlc24_story_panel_yuan_bo_compass_north" },
      total = 1,
      text_prefix = "mission_text_text_pow_ext_yuan_bo_r3_compass_north_b2",
      complete_loc_key = nil,
      on_complete = {
        { type = "DILEMMA", key = "pow_ext_yuan_bo_celestial_winds_b2_0" },
      },
    },
    {
      script_key = "pow_ext_framework_watchinc_wh3_dlc24_cth_the_celestial_court_III_compass_south",
      mission_key = "wh_main_domination_victory",
      incident_keys = { "wh3_dlc24_story_panel_yuan_bo_compass_south" },
      total = 1,
      text_prefix = "mission_text_text_pow_ext_yuan_bo_r3_compass_south_b2",
      complete_loc_key = nil,
      on_complete = {
        { type = "DILEMMA", key = "pow_ext_yuan_bo_celestial_winds_b2_0" },
      },
    },
    {
      script_key = "pow_ext_framework_watchinc_wh3_dlc24_cth_the_celestial_court_III_compass_east",
      mission_key = "wh_main_domination_victory",
      incident_keys = { "wh3_dlc24_story_panel_yuan_bo_compass_east" },
      total = 1,
      text_prefix = "mission_text_text_pow_ext_yuan_bo_r3_compass_east_b2",
      complete_loc_key = nil,
      on_complete = {
        { type = "DILEMMA", key = "pow_ext_yuan_bo_celestial_winds_b2_0" },
      },
    },
  },
}

pow_ext_config.watch_incident["wh3_main_dwf_the_ancestral_throng"] = {
  classic = {
    {
      script_key = "pow_ext_framework_watchinc_wh3_main_dwf_the_ancestral_throng_II_gnollengrom",
      mission_key = "wh_main_long_victory",
      incident_keys = { "wh3_dlc25_incident_grudge_cycle_5" },
      total = 1,
      text_prefix = "mission_text_text_pow_ext_grombrindal_gnollengrom_b2",
      complete_loc_key = nil,
      on_complete = nil,
    },
  },
  main = {
    {
      script_key = "pow_ext_framework_watchinc_wh3_main_dwf_the_ancestral_throng_II_gnollengrom",
      mission_key = "wh_main_long_victory",
      incident_keys = { "wh3_dlc25_incident_grudge_cycle_5" },
      total = 1,
      text_prefix = "mission_text_text_pow_ext_grombrindal_gnollengrom_b2",
      complete_loc_key = nil,
      on_complete = nil,
    },
  },
}

pow_ext_config.count_vanilla_sv["wh3_dlc24_cth_the_celestial_court"] = {
  classic = {
    {
      script_key = "pow_ext_framework_csv_wh3_dlc24_cth_the_celestial_court_II_caravans",
      mission_key = "wh_main_long_victory",
      saved_value_key = "caravans_completed_wh3_dlc24_cth_the_celestial_court",
      event_hint = "CaravanCompleted",
      total = 8,
      text_prefix = "mission_text_text_pow_ext_yuan_bo_r2_caravans_b2_0",
      complete_loc_key = "mission_text_text_pow_ext_yuan_bo_r2_caravans_b2_0_complete",
      on_complete = nil,
    },
  },
  main = {
    {
      script_key = "pow_ext_framework_csv_wh3_dlc24_cth_the_celestial_court_II_caravans",
      mission_key = "wh_main_long_victory",
      saved_value_key = "caravans_completed_wh3_dlc24_cth_the_celestial_court",
      event_hint = "CaravanCompleted",
      total = 8,
      text_prefix = "mission_text_text_pow_ext_yuan_bo_r2_caravans_b2_0",
      complete_loc_key = "mission_text_text_pow_ext_yuan_bo_r2_caravans_b2_0_complete",
      on_complete = nil,
    },
  },
}

pow_ext_config.complete_n_missions["wh3_dlc24_cth_the_celestial_court"] = {
  classic = {
    {
      script_key = "pow_ext_framework_completen_wh3_dlc24_cth_the_celestial_court_II_dragons_gaze",
      mission_key = "wh_main_long_victory",
      mission_keys = { "cr_oldworld_qb_cth_yuan_bo_armour_of_the_dragons_gaze" },
      total = 1,
      text_prefix = "mission_text_text_pow_ext_yuan_bo_r2_dragons_gaze",
      complete_loc_key = nil,
      on_complete = nil,
    },
    {
      script_key = "pow_ext_framework_completen_wh3_dlc24_cth_the_celestial_court_II_dragons_fang",
      mission_key = "wh_main_long_victory",
      mission_keys = { "cr_oldworld_qb_cth_yuan_bo_dragons_fang" },
      total = 1,
      text_prefix = "mission_text_text_pow_ext_yuan_bo_r2_dragons_fang",
      complete_loc_key = nil,
      on_complete = nil,
    },
    {
      script_key = "pow_ext_framework_completen_wh3_dlc24_cth_the_celestial_court_III_final_battle",
      mission_key = "wh_main_domination_victory",
      mission_keys = { "wh3_dlc24_ie_cth_yuan_bo_final_battle" },
      total = 1,
      text_prefix = "",
      complete_loc_key = nil,
      on_complete = nil,
    },
  },
  main = {
    {
      script_key = "pow_ext_framework_completen_wh3_dlc24_cth_the_celestial_court_II_dragons_gaze",
      mission_key = "wh_main_long_victory",
      mission_keys = { "cr_oldworld_qb_cth_yuan_bo_armour_of_the_dragons_gaze" },
      total = 1,
      text_prefix = "mission_text_text_pow_ext_yuan_bo_r2_dragons_gaze",
      complete_loc_key = nil,
      on_complete = nil,
    },
    {
      script_key = "pow_ext_framework_completen_wh3_dlc24_cth_the_celestial_court_II_dragons_fang",
      mission_key = "wh_main_long_victory",
      mission_keys = { "cr_oldworld_qb_cth_yuan_bo_dragons_fang" },
      total = 1,
      text_prefix = "mission_text_text_pow_ext_yuan_bo_r2_dragons_fang",
      complete_loc_key = nil,
      on_complete = nil,
    },
    {
      script_key = "pow_ext_framework_completen_wh3_dlc24_cth_the_celestial_court_III_final_battle",
      mission_key = "wh_main_domination_victory",
      mission_keys = { "wh3_dlc24_ie_cth_yuan_bo_final_battle" },
      total = 1,
      text_prefix = "",
      complete_loc_key = nil,
      on_complete = nil,
    },
  },
}

pow_ext_config.complete_n_missions["wh3_main_dwf_the_ancestral_throng"] = {
  classic = {
    {
      script_key = "pow_ext_framework_completen_wh3_main_dwf_the_ancestral_throng_II_armour",
      mission_key = "wh_main_long_victory",
      mission_keys = { "cr_oldworld_qb_dwf_grombrindal_armour_of_glimril" },
      total = 1,
      text_prefix = "",
      complete_loc_key = nil,
      on_complete = nil,
    },
    {
      script_key = "pow_ext_framework_completen_wh3_main_dwf_the_ancestral_throng_II_axe",
      mission_key = "wh_main_long_victory",
      mission_keys = { "cr_oldworld_qb_dwf_grombrindal_rune_axe_of_grombrindal" },
      total = 1,
      text_prefix = "",
      complete_loc_key = nil,
      on_complete = nil,
    },
    {
      script_key = "pow_ext_framework_completen_wh3_main_dwf_the_ancestral_throng_II_cloak",
      mission_key = "wh_main_long_victory",
      mission_keys = { "cr_oldworld_qb_dwf_grombrindal_rune_cloak_of_valaya" },
      total = 1,
      text_prefix = "",
      complete_loc_key = nil,
      on_complete = nil,
    },
    {
      script_key = "pow_ext_framework_completen_wh3_main_dwf_the_ancestral_throng_II_helm",
      mission_key = "wh_main_long_victory",
      mission_keys = { "cr_oldworld_qb_dwf_grombrindal_rune_helm_of_zhufbar" },
      total = 1,
      text_prefix = "",
      complete_loc_key = nil,
      on_complete = nil,
    },
    {
      script_key = "pow_ext_framework_completen_wh3_main_dwf_the_ancestral_throng_III_legendary_grudges",
      mission_key = "wh_main_domination_victory",
      mission_keys = { "wh3_dlc25_grudge_legendary_athel_loren", "wh3_dlc25_grudge_legendary_chaos_dwarfs", "wh3_dlc25_grudge_legendary_eight_peaks", "wh3_dlc25_grudge_legendary_high_elves", "wh3_dlc25_grudge_legendary_karak_zorn", "wh3_dlc25_grudge_legendary_karaz_ankor", "wh3_dlc25_grudge_legendary_karaz_ankor_2", "wh3_dlc25_grudge_legendary_karaz_ankor_3", "wh3_dlc25_grudge_legendary_malekith_and_friends", "wh3_dlc25_grudge_legendary_norse_dwarfs", "wh3_dlc25_grudge_legendary_settlement_karak_dum", "wh3_dlc25_grudge_legendary_silver_pinnacle", "wh3_dlc25_grudge_legendary_skaven_blight" },
      total = 4,
      text_prefix = "mission_text_text_pow_ext_grombrindal_legendary_grudges",
      complete_loc_key = "mission_text_text_pow_ext_grombrindal_legendary_grudges_complete",
      on_complete = nil,
    },
  },
  main = {
    {
      script_key = "pow_ext_framework_completen_wh3_main_dwf_the_ancestral_throng_II_armour",
      mission_key = "wh_main_long_victory",
      mission_keys = { "cr_oldworld_qb_dwf_grombrindal_armour_of_glimril" },
      total = 1,
      text_prefix = "",
      complete_loc_key = nil,
      on_complete = nil,
    },
    {
      script_key = "pow_ext_framework_completen_wh3_main_dwf_the_ancestral_throng_II_axe",
      mission_key = "wh_main_long_victory",
      mission_keys = { "cr_oldworld_qb_dwf_grombrindal_rune_axe_of_grombrindal" },
      total = 1,
      text_prefix = "",
      complete_loc_key = nil,
      on_complete = nil,
    },
    {
      script_key = "pow_ext_framework_completen_wh3_main_dwf_the_ancestral_throng_II_cloak",
      mission_key = "wh_main_long_victory",
      mission_keys = { "cr_oldworld_qb_dwf_grombrindal_rune_cloak_of_valaya" },
      total = 1,
      text_prefix = "",
      complete_loc_key = nil,
      on_complete = nil,
    },
    {
      script_key = "pow_ext_framework_completen_wh3_main_dwf_the_ancestral_throng_II_helm",
      mission_key = "wh_main_long_victory",
      mission_keys = { "cr_oldworld_qb_dwf_grombrindal_rune_helm_of_zhufbar" },
      total = 1,
      text_prefix = "",
      complete_loc_key = nil,
      on_complete = nil,
    },
    {
      script_key = "pow_ext_framework_completen_wh3_main_dwf_the_ancestral_throng_III_legendary_grudges",
      mission_key = "wh_main_domination_victory",
      mission_keys = { "wh3_dlc25_grudge_legendary_athel_loren", "wh3_dlc25_grudge_legendary_chaos_dwarfs", "wh3_dlc25_grudge_legendary_eight_peaks", "wh3_dlc25_grudge_legendary_high_elves", "wh3_dlc25_grudge_legendary_karak_zorn", "wh3_dlc25_grudge_legendary_karaz_ankor", "wh3_dlc25_grudge_legendary_karaz_ankor_2", "wh3_dlc25_grudge_legendary_karaz_ankor_3", "wh3_dlc25_grudge_legendary_malekith_and_friends", "wh3_dlc25_grudge_legendary_norse_dwarfs", "wh3_dlc25_grudge_legendary_settlement_karak_dum", "wh3_dlc25_grudge_legendary_silver_pinnacle", "wh3_dlc25_grudge_legendary_skaven_blight" },
      total = 4,
      text_prefix = "mission_text_text_pow_ext_grombrindal_legendary_grudges",
      complete_loc_key = "mission_text_text_pow_ext_grombrindal_legendary_grudges_complete",
      on_complete = nil,
    },
  },
}

pow_ext_config.complete_n_missions["wh_dlc08_nor_norsca"] = {
  classic = {
    {
      script_key = "pow_ext_framework_completen_wh_dlc08_nor_norsca_I_hunt",
      mission_key = "wh_main_short_victory",
      mission_keys = { "wh_dlc08_qb_nor_monster_hunt_00", "wh_dlc08_qb_nor_monster_hunt_01", "wh_dlc08_qb_nor_monster_hunt_02", "wh_dlc08_qb_nor_monster_hunt_03", "wh_dlc08_qb_nor_monster_hunt_04", "wh_dlc08_qb_nor_monster_hunt_05", "wh_dlc08_qb_nor_monster_hunt_06", "wh_dlc08_qb_nor_monster_hunt_07", "wh3_dlc27_qb_nor_monster_hunt_12", "wh3_dlc27_qb_nor_monster_hunt_14", "wh3_dlc27_qb_nor_monster_hunt_15", "wh3_dlc27_qb_nor_monster_hunt_16", "wh3_dlc27_qb_nor_monster_hunt_17", "wh3_dlc27_qb_nor_monster_hunt_18", "wh3_dlc27_qb_nor_monster_hunt_19", "wh3_dlc27_qb_nor_monster_hunt_20", "wh3_dlc27_qb_nor_monster_hunt_21", "wh3_dlc27_qb_nor_monster_hunt_22", "wh3_dlc27_qb_nor_monster_hunt_23", "wh3_dlc27_qb_nor_monster_hunt_24", "wh3_dlc27_qb_nor_monster_hunt_25" },
      total = 5,
      text_prefix = "mission_text_text_pow_ext_nor_wul_hunt",
      complete_loc_key = "mission_text_text_pow_ext_nor_wul_hunt_complete",
      on_complete = nil,
    },
  },
  main = {
    {
      script_key = "pow_ext_framework_completen_wh_dlc08_nor_norsca_I_hunt",
      mission_key = "wh_main_short_victory",
      mission_keys = { "wh_dlc08_qb_nor_monster_hunt_00", "wh_dlc08_qb_nor_monster_hunt_01", "wh_dlc08_qb_nor_monster_hunt_02", "wh_dlc08_qb_nor_monster_hunt_03", "wh_dlc08_qb_nor_monster_hunt_04", "wh_dlc08_qb_nor_monster_hunt_05", "wh_dlc08_qb_nor_monster_hunt_06", "wh_dlc08_qb_nor_monster_hunt_07", "wh3_dlc27_qb_nor_monster_hunt_12", "wh3_dlc27_qb_nor_monster_hunt_14", "wh3_dlc27_qb_nor_monster_hunt_15", "wh3_dlc27_qb_nor_monster_hunt_16", "wh3_dlc27_qb_nor_monster_hunt_17", "wh3_dlc27_qb_nor_monster_hunt_18", "wh3_dlc27_qb_nor_monster_hunt_19", "wh3_dlc27_qb_nor_monster_hunt_20", "wh3_dlc27_qb_nor_monster_hunt_21", "wh3_dlc27_qb_nor_monster_hunt_22", "wh3_dlc27_qb_nor_monster_hunt_23", "wh3_dlc27_qb_nor_monster_hunt_24", "wh3_dlc27_qb_nor_monster_hunt_25" },
      total = 5,
      text_prefix = "mission_text_text_pow_ext_nor_wul_hunt",
      complete_loc_key = "mission_text_text_pow_ext_nor_wul_hunt_complete",
      on_complete = nil,
    },
  },
}

pow_ext_config.complete_n_missions["wh_main_vmp_vampire_counts"] = {
  main = {
    {
      script_key = "pow_ext_framework_completen_wh_main_vmp_vampire_counts_II_nagash_books",
      mission_key = "wh_main_long_victory",
      mission_keys = { "wh2_dlc09_books_of_nagash_1", "wh2_dlc09_books_of_nagash_2", "wh2_dlc09_books_of_nagash_3", "wh2_dlc09_books_of_nagash_4", "wh2_dlc09_books_of_nagash_5", "wh2_dlc09_books_of_nagash_6", "wh2_dlc09_books_of_nagash_7", "wh2_dlc09_books_of_nagash_8" },
      total = 5,
      text_prefix = "mission_text_text_pow_ext_vmp_man_5_books_collected_b2_0",
      complete_loc_key = "mission_text_text_pow_ext_vmp_man_5_books_collected_b2_0_complete",
      on_complete = nil,
    },
  },
}

pow_ext_config.count_faction_regions["wh2_dlc13_lzd_spirits_of_the_jungle"] = {
  classic = {
    {
      script_key = "pow_ext_framework_factionregions_wh2_dlc13_lzd_spirits_of_the_jungle_I_great_plan",
      mission_key = "wh_main_short_victory",
      target_faction_keys = { "wh2_dlc13_lzd_defenders_of_the_great_plan" },
      total = 15,
      text_prefix = "mission_text_text_pow_ext_nakai_great_plan_counter_b2_0",
      complete_loc_key = "mission_text_text_pow_ext_nakai_great_plan_counter_b2_0_complete",
      on_complete = nil,
    },
  },
  main = {
    {
      script_key = "pow_ext_framework_factionregions_wh2_dlc13_lzd_spirits_of_the_jungle_I_great_plan",
      mission_key = "wh_main_short_victory",
      target_faction_keys = { "wh2_dlc13_lzd_defenders_of_the_great_plan" },
      total = 15,
      text_prefix = "mission_text_text_pow_ext_nakai_great_plan_counter_b2_0",
      complete_loc_key = "mission_text_text_pow_ext_nakai_great_plan_counter_b2_0_complete",
      on_complete = nil,
    },
  },
}

pow_ext_config.route_on_complete["wh2_dlc16_wef_drycha"] = {
  classic = {
    ["wh_main_domination_victory"] = {
      { type = "DILEMMA", key = "vco_wef_dry_dilemma_fate_elves" },
    },
    ["wh_main_long_victory"] = {
      { type = "DILEMMA", key = "pow_ext_wef_dry_dilemma_unlikely_alliance" },
    },
  },
  main = {
    ["wh_main_domination_victory"] = {
      { type = "DILEMMA", key = "vco_wef_dry_dilemma_fate_elves" },
    },
    ["wh_main_long_victory"] = {
      { type = "DILEMMA", key = "pow_ext_wef_dry_dilemma_unlikely_alliance" },
    },
  },
}

pow_ext_config.route_on_complete["wh2_main_def_har_ganeth"] = {
  classic = {
    ["wh_main_domination_victory"] = {
      { type = "DILEMMA", key = "pow_ext_dilemma_def_gan_lady_unmasked" },
    },
  },
  main = {
    ["wh_main_domination_victory"] = {
      { type = "DILEMMA", key = "pow_ext_dilemma_def_gan_lady_unmasked" },
    },
  },
}

pow_ext_config.route_on_complete["wh2_main_skv_clan_moulder"] = {
  classic = {
    ["wh_main_domination_victory"] = {
      { type = "DILEMMA", key = "vco_skv_mdr_dilemma_ultimate_harvest" },
      { type = "MISSION", key = "vco_wh2_dlc16_qb_skv_final_battle_throt" },
    },
    ["wh_main_short_victory"] = {
      { type = "MISSION", key = "vco_custom_quest_throt_ghoritch" },
    },
  },
  main = {
    ["wh_main_domination_victory"] = {
      { type = "DILEMMA", key = "vco_skv_mdr_dilemma_ultimate_harvest" },
      { type = "MISSION", key = "vco_wh2_dlc16_qb_skv_final_battle_throt" },
    },
    ["wh_main_short_victory"] = {
      { type = "MISSION", key = "vco_custom_quest_throt_ghoritch" },
    },
  },
}

pow_ext_config.route_on_complete["wh3_dlc24_cth_the_celestial_court"] = {
  classic = {
    ["wh_main_short_victory"] = {
      { type = "DILEMMA", key = "pow_ext_yuan_bo_r1_to_r2_guide" },
    },
  },
  main = {
    ["wh_main_short_victory"] = {
      { type = "DILEMMA", key = "pow_ext_yuan_bo_r1_to_r2_guide" },
    },
  },
}

pow_ext_config.route_on_complete["wh3_main_ksl_the_ice_court"] = {
  classic = {
    ["wh_main_long_victory"] = {
      { type = "DILEMMA", key = "vco_ksl_kat_dilemma_call_for_aid" },
    },
  },
  main = {
    ["wh_main_long_victory"] = {
      { type = "DILEMMA", key = "vco_ksl_kat_dilemma_call_for_aid" },
    },
  },
}

pow_ext_config.route_on_complete["wh_dlc05_bst_morghur_herd"] = {
  classic = {
    ["wh_main_domination_victory"] = {
      { type = "MISSION", key = "vco_custom_quest_morghur_athel_loren" },
    },
  },
  main = {
    ["wh_main_domination_victory"] = {
      { type = "MISSION", key = "vco_custom_quest_morghur_athel_loren" },
    },
  },
}

pow_ext_config.route_on_complete["wh_dlc08_nor_norsca"] = {
  classic = {
    ["wh_main_domination_victory"] = {
      { type = "DILEMMA", key = "vco_nor_wul_dilemma_everchosens_summons" },
    },
  },
  main = {
    ["wh_main_domination_victory"] = {
      { type = "DILEMMA", key = "vco_nor_wul_dilemma_everchosens_summons" },
    },
  },
}

pow_ext_config.route_on_complete["wh_main_vmp_schwartzhafen"] = {
  classic = {
    ["wh_main_long_victory"] = {
      { type = "DILEMMA", key = "vco_vmp_vla_dilemma_last_stand" },
    },
  },
  main = {
    ["wh_main_long_victory"] = {
      { type = "DILEMMA", key = "vco_vmp_vla_dilemma_last_stand" },
    },
  },
}

pow_ext_config.route_on_complete["wh_main_vmp_vampire_counts"] = {
  main = {
    ["wh_main_short_victory"] = {
      { type = "DILEMMA", key = "vco_vmp_man_dilemma_ossified_portal" },
    },
  },
}

pow_ext_config.legendary_lord_subtype_set = {
  ["wh2_dlc09_skv_tretch_craventail"] = true,
  ["wh2_dlc09_tmb_arkhan"] = true,
  ["wh2_dlc09_tmb_khalida"] = true,
  ["wh2_dlc09_tmb_khatep"] = true,
  ["wh2_dlc09_tmb_settra"] = true,
  ["wh2_dlc10_def_crone_hellebron"] = true,
  ["wh2_dlc10_hef_alarielle"] = true,
  ["wh2_dlc10_hef_alith_anar"] = true,
  ["wh2_dlc11_cst_aranessa"] = true,
  ["wh2_dlc11_cst_cylostra"] = true,
  ["wh2_dlc11_cst_harkon"] = true,
  ["wh2_dlc11_cst_noctilus"] = true,
  ["wh2_dlc11_def_lokhir"] = true,
  ["wh2_dlc12_lzd_tehenhauin"] = true,
  ["wh2_dlc12_lzd_tiktaqto"] = true,
  ["wh2_dlc12_skv_ikit_claw"] = true,
  ["wh2_dlc13_emp_cha_markus_wulfhart"] = true,
  ["wh2_dlc13_lzd_gor_rok"] = true,
  ["wh2_dlc13_lzd_nakai"] = true,
  ["wh2_dlc14_brt_repanse"] = true,
  ["wh2_dlc14_def_malus_darkblade"] = true,
  ["wh2_dlc14_skv_deathmaster_snikch"] = true,
  ["wh2_dlc15_grn_grom_the_paunch"] = true,
  ["wh2_dlc15_hef_eltharion"] = true,
  ["wh2_dlc15_hef_imrik"] = true,
  ["wh2_dlc16_skv_throt_the_unclean"] = true,
  ["wh2_dlc16_wef_drycha"] = true,
  ["wh2_dlc16_wef_sisters_of_twilight"] = true,
  ["wh2_dlc17_bst_taurox"] = true,
  ["wh2_dlc17_dwf_thorek"] = true,
  ["wh2_dlc17_lzd_oxyotl"] = true,
  ["wh2_main_def_malekith"] = true,
  ["wh2_main_def_morathi"] = true,
  ["wh2_main_hef_teclis"] = true,
  ["wh2_main_hef_tyrion"] = true,
  ["wh2_main_lzd_kroq_gar"] = true,
  ["wh2_main_lzd_lord_mazdamundi"] = true,
  ["wh2_main_skv_lord_skrolk"] = true,
  ["wh2_main_skv_queek_headtaker"] = true,
  ["wh2_twa03_def_rakarth"] = true,
  ["wh3_cp1_cth_bhashiva"] = true,
  ["wh3_dlc20_kho_valkia"] = true,
  ["wh3_dlc20_nur_festus"] = true,
  ["wh3_dlc20_sla_azazel"] = true,
  ["wh3_dlc20_tze_vilitch"] = true,
  ["wh3_dlc23_chd_astragoth"] = true,
  ["wh3_dlc23_chd_drazhoath"] = true,
  ["wh3_dlc23_chd_zhatan"] = true,
  ["wh3_dlc24_cth_yuan_bo"] = true,
  ["wh3_dlc24_ksl_mother_ostankya"] = true,
  ["wh3_dlc24_tze_the_changeling"] = true,
  ["wh3_dlc25_dwf_malakai_makaisson"] = true,
  ["wh3_dlc25_emp_elspeth_von_draken"] = true,
  ["wh3_dlc25_nur_epidemius"] = true,
  ["wh3_dlc25_nur_tamurkhan"] = true,
  ["wh3_dlc26_grn_gorbad_ironclaw"] = true,
  ["wh3_dlc26_kho_arbaal_the_undefeated"] = true,
  ["wh3_dlc26_kho_skulltaker"] = true,
  ["wh3_dlc26_ogr_golgfag_maneater"] = true,
  ["wh3_dlc27_hef_aislinn"] = true,
  ["wh3_dlc27_nor_sayl_the_faithless"] = true,
  ["wh3_dlc27_sla_dechala"] = true,
  ["wh3_dlc27_sla_masque_of_slaanesh"] = true,
  ["wh3_main_cth_miao_ying"] = true,
  ["wh3_main_cth_zhao_ming"] = true,
  ["wh3_main_dae_belakor"] = true,
  ["wh3_main_dae_daemon_prince"] = true,
  ["wh3_main_kho_skarbrand"] = true,
  ["wh3_main_ksl_boris"] = true,
  ["wh3_main_ksl_katarin"] = true,
  ["wh3_main_ksl_kostaltyn"] = true,
  ["wh3_main_nur_kugath"] = true,
  ["wh3_main_ogr_greasus_goldtooth"] = true,
  ["wh3_main_ogr_skrag_the_slaughterer"] = true,
  ["wh3_main_sla_nkari"] = true,
  ["wh3_main_tze_kairos"] = true,
  ["wh3_prologue_general_test"] = true,
  ["wh_dlc01_chs_kholek_suneater"] = true,
  ["wh_dlc01_chs_prince_sigvald"] = true,
  ["wh_dlc03_bst_khazrak"] = true,
  ["wh_dlc03_bst_malagor"] = true,
  ["wh_dlc04_emp_volkmar"] = true,
  ["wh_dlc04_vmp_helman_ghorst"] = true,
  ["wh_dlc04_vmp_vlad_con_carstein"] = true,
  ["wh_dlc05_bst_morghur"] = true,
  ["wh_dlc05_wef_durthu"] = true,
  ["wh_dlc05_wef_orion"] = true,
  ["wh_dlc06_dwf_belegar"] = true,
  ["wh_dlc06_grn_skarsnik"] = true,
  ["wh_dlc06_grn_wurrzag_da_great_prophet"] = true,
  ["wh_dlc07_brt_alberic"] = true,
  ["wh_dlc07_brt_fay_enchantress"] = true,
  ["wh_dlc08_nor_throgg"] = true,
  ["wh_dlc08_nor_wulfrik"] = true,
  ["wh_main_brt_louen_leoncouer"] = true,
  ["wh_main_chs_archaon"] = true,
  ["wh_main_dwf_thorgrim_grudgebearer"] = true,
  ["wh_main_dwf_ungrim_ironfist"] = true,
  ["wh_main_emp_balthasar_gelt"] = true,
  ["wh_main_emp_karl_franz"] = true,
  ["wh_main_grn_azhag_the_slaughterer"] = true,
  ["wh_main_grn_grimgor_ironhide"] = true,
  ["wh_main_vmp_heinrich_kemmler"] = true,
  ["wh_main_vmp_mannfred_von_carstein"] = true,
  ["wh_pro01_dwf_grombrindal"] = true,
  ["wh_pro02_vmp_isabella_von_carstein"] = true,
}

pow_ext_config.kill_class_agent_actions = {
  ["wh2_main_agent_action_champion_hinder_agent_assassinate"] = true,
  ["wh2_main_agent_action_champion_hinder_agent_wound"] = true,
  ["wh2_main_agent_action_dignitary_hinder_agent_wound"] = true,
  ["wh2_main_agent_action_engineer_hinder_agent_assassinate"] = true,
  ["wh2_main_agent_action_engineer_hinder_agent_wound"] = true,
  ["wh2_main_agent_action_runesmith_hinder_agent_wound"] = true,
  ["wh2_main_agent_action_runesmith_hinder_character_assassinate"] = true,
  ["wh2_main_agent_action_spy_hinder_agent_assassinate"] = true,
  ["wh2_main_agent_action_spy_hinder_agent_wound"] = true,
  ["wh2_main_agent_action_spy_hinder_character_assassinate"] = true,
  ["wh2_main_agent_action_wizard_hinder_agent_assassinate"] = true,
  ["wh2_main_agent_action_wizard_hinder_agent_wound"] = true,
  ["wh3_main_agent_action_dignitary_hinder_agent_assassinate"] = true,
}

pow_ext_config.dilemmas    = pow_ext_config.dilemmas or {}
pow_ext_config.bundles     = pow_ext_config.bundles or {}
pow_ext_config.ancillaries = pow_ext_config.ancillaries or {}
pow_ext_config.dilemmas["wh2_dlc16_wef_drycha"] = {
    ["pow_ext_wef_dry_dilemma_unlikely_alliance"] = "pow_ext_wef_dry_dilemma_unlikely_alliance",
}
pow_ext_config.dilemmas["wh2_main_def_har_ganeth"] = {
    ["pow_ext_dilemma_def_gan_lady_unmasked"] = "pow_ext_dilemma_def_gan_lady_unmasked",
}
pow_ext_config.dilemmas["wh3_dlc24_cth_the_celestial_court"] = {
    ["pow_ext_yuan_bo_celestial_winds"] = "pow_ext_yuan_bo_celestial_winds_b2_0",
    ["pow_ext_yuan_bo_r1_to_r2_guide"] = "pow_ext_yuan_bo_r1_to_r2_guide",
}
pow_ext_config.bundles["wh2_dlc13_lzd_spirits_of_the_jungle"] = {
    ["pow_ext_victory_payload_lzd_nak_1_wanderer"] = "pow_ext_victory_payload_lzd_nak_1_wanderer_b2_0",
    ["pow_ext_victory_payload_lzd_nak_2_coils"] = "pow_ext_victory_payload_lzd_nak_2_coils",
    ["pow_ext_victory_payload_lzd_nak_3_protector"] = "pow_ext_victory_payload_lzd_nak_3_protector_b2_0",
}
pow_ext_config.bundles["wh2_dlc16_wef_drycha"] = {
    ["pow_ext_victory_payload_wef_dry_2_foreshadow"] = "pow_ext_victory_payload_wef_dry_2_foreshadow",
    ["pow_ext_victory_payload_wef_dry_2_liberation"] = "pow_ext_victory_payload_wef_dry_2_liberation",
    ["pow_ext_wef_dry_pact_dark_elves"] = "pow_ext_wef_dry_pact_dark_elves",
    ["pow_ext_wef_dry_pact_dwarfs"] = "pow_ext_wef_dry_pact_dwarfs",
    ["pow_ext_wef_dry_pact_independence"] = "pow_ext_wef_dry_pact_independence",
    ["pow_ext_wef_dry_pact_ogres"] = "pow_ext_wef_dry_pact_ogres",
    ["pow_ext_wef_dry_pact_slaanesh"] = "pow_ext_wef_dry_pact_slaanesh",
    ["pow_ext_wef_dry_pact_vampires"] = "pow_ext_wef_dry_pact_vampires",
}
pow_ext_config.bundles["wh2_dlc16_wef_sisters_of_twilight"] = {
    ["pow_ext_victory_payload_wef_twi_1_dreaming_wood"] = "pow_ext_victory_payload_wef_twi_1_dreaming_wood",
    ["pow_ext_victory_payload_wef_twi_3_worldroots"] = "pow_ext_victory_payload_wef_twi_3_worldroots",
    ["pow_ext_victory_payload_wef_twi_sherweald_herd"] = "pow_ext_victory_payload_wef_twi_sherweald_herd",
}
pow_ext_config.bundles["wh2_main_def_har_ganeth"] = {
    ["pow_ext_def_gan_lady_unmasked_feast"] = "pow_ext_def_gan_lady_unmasked_feast",
    ["pow_ext_def_gan_lady_unmasked_warding"] = "pow_ext_def_gan_lady_unmasked_warding",
    ["pow_ext_victory_payload_def_gan_1_witch_queen_walks_albion"] = "pow_ext_victory_payload_def_gan_1_witch_queen_walks_albion",
    ["pow_ext_victory_payload_def_gan_2_cauldron_fills"] = "pow_ext_victory_payload_def_gan_2_cauldron_fills",
    ["pow_ext_victory_payload_def_gan_3_lady_unmasked_foreshadow"] = "pow_ext_victory_payload_def_gan_3_lady_unmasked_foreshadow",
}
pow_ext_config.bundles["wh3_dlc24_cth_the_celestial_court"] = {
    ["pow_ext_victory_payload_cth_yua_throne_of_albion"] = "pow_ext_victory_payload_cth_yua_throne_of_albion",
}
pow_ext_config.bundles["wh3_main_chs_shadow_legion"] = {
    ["pow_ext_belakor_r1_harbinger_legions"] = "pow_ext_belakor_r1_harbinger_legions",
    ["pow_ext_belakor_r2_harbinger_aspect"] = "pow_ext_belakor_r2_harbinger_aspect",
}
pow_ext_config.bundles["wh3_main_dwf_the_ancestral_throng"] = {
    ["pow_ext_victory_payload_dwf_gro_1_anti_chaos"] = "pow_ext_victory_payload_dwf_gro_1_anti_chaos_b2_0",
    ["pow_ext_victory_payload_dwf_gro_2_accoutrements"] = "pow_ext_victory_payload_dwf_gro_2_accoutrements_b2_0",
    ["pow_ext_victory_payload_dwf_gro_3_old_grudge"] = "pow_ext_victory_payload_dwf_gro_3_old_grudge_b2_0",
}
pow_ext_config.bundles["wh3_main_kho_exiles_of_khorne"] = {
    ["pow_ext_victory_payload_kho_ska_3_crowns_of_blood"] = "pow_ext_victory_payload_kho_ska_3_crowns_of_blood",
}
pow_ext_config.bundles["wh_dlc05_bst_morghur_herd"] = {
    ["pow_ext_victory_payload_bst_mor_2_drakwald_defiled"] = "pow_ext_victory_payload_bst_mor_2_drakwald_defiled",
}
pow_ext_config.ancillaries["wh_dlc05_bst_morghur_herd"] = {
    ["pow_ext_anc_enchanted_item_morgaines_mirror"] = "pow_ext_anc_enchanted_item_morgaines_mirror",
    ["pow_ext_anc_talisman_broken_defiled_crown"] = "pow_ext_anc_talisman_broken_defiled_crown",
}
