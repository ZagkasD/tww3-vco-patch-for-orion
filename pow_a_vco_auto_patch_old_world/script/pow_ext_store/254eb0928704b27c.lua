-- pow_ext_listeners_nor_wul.lua
-- Wulfrik counter bypasses. VCO's source listeners call
-- vco:set_mission_text / vco:complete_mission which hardcode the
-- mission key "vco_route_victory" — broken under our OW route
-- keys. Mirror the filters and use direct CA APIs instead.

local FACTION_WUL_KEY = "wh_dlc08_nor_norsca"

-- Route 1 hunt counter (target 5)
local HUNT_SCRIPT_KEY = "vco_wulfrik_hunt_counter"
local HUNT_OW_MISSION_KEY = "wh_main_short_victory"
local HUNT_TEXT_PREFIX = "mission_text_text_vco_nor_wulfrik_hunt_counter_"
local HUNT_THRESHOLD = 5

local HUNT_KEYS = {
    ["wh_dlc08_qb_nor_monster_hunt_00"] = true,
    ["wh_dlc08_qb_nor_monster_hunt_01"] = true,
    ["wh_dlc08_qb_nor_monster_hunt_02"] = true,
    ["wh_dlc08_qb_nor_monster_hunt_03"] = true,
    ["wh_dlc08_qb_nor_monster_hunt_04"] = true,
    ["wh_dlc08_qb_nor_monster_hunt_05"] = true,
    ["wh_dlc08_qb_nor_monster_hunt_06"] = true,
    ["wh_dlc08_qb_nor_monster_hunt_07"] = true,
    ["wh3_dlc27_qb_nor_monster_hunt_12"] = true,
    ["wh3_dlc27_qb_nor_monster_hunt_14"] = true,
    ["wh3_dlc27_qb_nor_monster_hunt_15"] = true,
    ["wh3_dlc27_qb_nor_monster_hunt_16"] = true,
    ["wh3_dlc27_qb_nor_monster_hunt_17"] = true,
    ["wh3_dlc27_qb_nor_monster_hunt_18"] = true,
    ["wh3_dlc27_qb_nor_monster_hunt_19"] = true,
    ["wh3_dlc27_qb_nor_monster_hunt_20"] = true,
    ["wh3_dlc27_qb_nor_monster_hunt_21"] = true,
    ["wh3_dlc27_qb_nor_monster_hunt_22"] = true,
    ["wh3_dlc27_qb_nor_monster_hunt_23"] = true,
    ["wh3_dlc27_qb_nor_monster_hunt_24"] = true,
    ["wh3_dlc27_qb_nor_monster_hunt_25"] = true,
}

-- Route 2 legendary lord kill counter (target 15)
local LL_SCRIPT_KEY = "vco_script_nor_wulfrik_legendary_lord_counter"
local LL_OW_MISSION_KEY = "wh_main_long_victory"
local LL_TEXT_PREFIX = "mission_text_text_vco_nor_wulfrik_legendary_lord_counter_"
local LL_THRESHOLD = 15

local function pow_ext_nor_wul_main()
    cm:add_first_tick_callback(function()
        -- Route 1 hunt counter: increment on hunt mission complete
        core:add_listener(
            "pow_ext_nor_wul_hunt_counter",
            "MissionSucceeded",
            function(context)
                if cm:get_saved_value("pow_ext_nor_wul_hunt_complete") then
                    return false
                end
                if context:faction():name() ~= FACTION_WUL_KEY then return false end
                if not context:faction():is_human() then return false end
                local mission_key = context:mission():mission_record_key()
                return HUNT_KEYS[mission_key] == true
            end,
            function()
                local count = cm:get_saved_value("pow_ext_nor_wul_hunt_count") or 0
                count = count + 1
                if count > HUNT_THRESHOLD then count = HUNT_THRESHOLD end
                cm:set_saved_value("pow_ext_nor_wul_hunt_count", count)
                cm:set_scripted_mission_text(
                    HUNT_OW_MISSION_KEY, HUNT_SCRIPT_KEY,
                    HUNT_TEXT_PREFIX .. count
                )
                if count >= HUNT_THRESHOLD then
                    cm:complete_scripted_mission_objective(
                        FACTION_WUL_KEY, HUNT_OW_MISSION_KEY, HUNT_SCRIPT_KEY, true
                    )
                    cm:set_saved_value("pow_ext_nor_wul_hunt_complete", true)
                end
            end,
            true
        )

        -- Route 2 LL counter: increment on legendary lord defeated in battle
        core:add_listener(
            "pow_ext_nor_wul_ll_counter",
            "CharacterCompletedBattle",
            function(context)
                if cm:get_saved_value("pow_ext_nor_wul_ll_complete") then
                    return false
                end
                local pb = context:pending_battle()
                local atk_faction = pb:attacker():faction()
                local def_faction = pb:defender():faction()
                local wul_atk = atk_faction:name() == FACTION_WUL_KEY
                local wul_def = def_faction:name() == FACTION_WUL_KEY
                if not (wul_atk or wul_def) then return false end
                local wul_faction = wul_atk and atk_faction or def_faction
                if not wul_faction:is_human() then return false end
                local won = wul_atk and pb:attacker_won() or pb:defender_won()
                if not won then return false end

                local atk_fm_cqi = cm:pending_battle_cache_get_attacker_fm_cqi(1)
                local atk_fm = cm:get_family_member_by_cqi(atk_fm_cqi)
                local def_fm_cqi = cm:pending_battle_cache_get_defender_fm_cqi(1)
                local def_fm = cm:get_family_member_by_cqi(def_fm_cqi)

                local function is_ll(fm)
                    if not fm then return false end
                    local d = fm:character_details()
                    if not d then return false end
                    return d:is_unique()
                end

                if not (is_ll(atk_fm) or is_ll(def_fm)) then return false end

                local victory_table = cm:get_cached_value(
                    "pow_ext_nor_wul_victory_table",
                    function() return {} end
                )
                if victory_table[tostring(def_fm_cqi)] then return false end
                if victory_table[tostring(atk_fm_cqi)] then return false end

                return true
            end,
            function(context)
                local pb = context:pending_battle()
                local atk_faction = pb:attacker():faction()
                local wul_atk = atk_faction:name() == FACTION_WUL_KEY
                local atk_fm_cqi = cm:pending_battle_cache_get_attacker_fm_cqi(1)
                local def_fm_cqi = cm:pending_battle_cache_get_defender_fm_cqi(1)
                local defeated_cqi = wul_atk and def_fm_cqi or atk_fm_cqi
                if not defeated_cqi then return end

                local count = cm:get_saved_value("pow_ext_nor_wul_ll_count") or 0
                count = count + 1
                if count > LL_THRESHOLD then count = LL_THRESHOLD end
                cm:set_saved_value("pow_ext_nor_wul_ll_count", count)

                local victory_table = cm:get_cached_value(
                    "pow_ext_nor_wul_victory_table",
                    function() return {} end
                )
                victory_table[tostring(defeated_cqi)] = true
                cm:set_saved_value("pow_ext_nor_wul_victory_table", victory_table)

                cm:set_scripted_mission_text(
                    LL_OW_MISSION_KEY, LL_SCRIPT_KEY,
                    LL_TEXT_PREFIX .. count
                )
                if count >= LL_THRESHOLD then
                    cm:complete_scripted_mission_objective(
                        FACTION_WUL_KEY, LL_OW_MISSION_KEY, LL_SCRIPT_KEY, true
                    )
                    cm:set_saved_value("pow_ext_nor_wul_ll_complete", true)
                end
            end,
            true
        )
    end)
end

pow_ext_nor_wul_main();
