-- pow_ext_listeners_lzd_nakai.lua
-- Nakai Wanderer route counters. Both gates live on
-- wh_main_short_victory; they're SCRIPTED objectives whose script_keys
-- match the listener names below.
--
-- LL kill counter: mirror of Wulfrik R2 (CharacterCompletedBattle +
-- is_unique() filter), with an additional subculture filter — only
-- LLs from corruption-producing subcultures count, matching the
-- anti-corruption theme of R2 (Purification of the Wandering Lands).
-- Increments saved value, updates per-N text, completes at threshold
-- and tears down.
--
-- Defenders-of-the-Great-Plan vassal counter: listens to
-- RegionFactionChangeEvent and recomputes the vassal's current
-- region_list():num_items() each tick. Bidirectional — a vassal
-- region loss decrements the displayed count. Once the count >= the
-- threshold, completes the objective and tears down (a later loss
-- does not undo the win).

local FACTION_NAK_KEY = "wh2_dlc13_lzd_spirits_of_the_jungle"
local VASSAL_KEY = "wh2_dlc13_lzd_defenders_of_the_great_plan"
local OW_MISSION_KEY = "wh_main_short_victory"

-- Subcultures whose Legendary Lord kills count toward the Wanderer
-- route's "enemies of the Old Ones" gate. Originally just corruption-
-- producing factions; expanded to also include Greenskins and Dark
-- Elves — both broadly defy the Great Plan in lore (the savage WAAAGH!
-- and Khainite slaughter respectively), and including them widens the
-- pool of valid kill targets across the OW map.
local CORRUPTION_SUBCULTURES = {
    ["wh_main_sc_chs_chaos"] = true,
    ["wh3_main_sc_kho_khorne"] = true,
    ["wh3_main_sc_tze_tzeentch"] = true,
    ["wh3_main_sc_nur_nurgle"] = true,
    ["wh3_main_sc_sla_slaanesh"] = true,
    ["wh3_main_sc_dae_daemons"] = true,
    ["wh_dlc08_sc_nor_norsca"] = true,
    ["wh_dlc03_sc_bst_beastmen"] = true,
    ["wh3_dlc23_sc_chd_chaos_dwarfs"] = true,
    ["wh2_main_sc_skv_skaven"] = true,
    ["wh_main_sc_vmp_vampire_counts"] = true,
    ["wh2_dlc11_sc_cst_vampire_coast"] = true,
    ["wh_main_sc_grn_greenskins"] = true,
    ["wh2_main_sc_def_dark_elves"] = true,
}

-- LL kill counter
local LL_SCRIPT_KEY = "pow_ext_nakai_ll_kill_counter"
local LL_TEXT_PREFIX = "mission_text_text_pow_ext_nakai_ll_kill_counter_"
local LL_THRESHOLD = 5

-- Defenders-of-the-Great-Plan vassal settlement counter
local GP_SCRIPT_KEY = "pow_ext_nakai_great_plan_counter"
local GP_TEXT_PREFIX = "mission_text_text_pow_ext_nakai_great_plan_counter_"
local GP_THRESHOLD = 15

local function pow_ext_nakai_main()
    cm:add_first_tick_callback(function()
        -- LL kill counter
        core:add_listener(
            "pow_ext_nakai_ll_counter",
            "CharacterCompletedBattle",
            function(context)
                if cm:get_saved_value("pow_ext_nakai_ll_complete") then
                    return false
                end
                local pb = context:pending_battle()
                local atk_faction = pb:attacker():faction()
                local def_faction = pb:defender():faction()
                local nak_atk = atk_faction:name() == FACTION_NAK_KEY
                local nak_def = def_faction:name() == FACTION_NAK_KEY
                if not (nak_atk or nak_def) then return false end
                local nak_faction = nak_atk and atk_faction or def_faction
                if not nak_faction:is_human() then return false end
                local won = nak_atk and pb:attacker_won() or pb:defender_won()
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

                -- Only count when the LOSER was a unique LL.
                local loser_is_ll
                local loser_faction
                if nak_atk then
                    loser_is_ll = is_ll(def_fm)
                    loser_faction = def_faction
                else
                    loser_is_ll = is_ll(atk_fm)
                    loser_faction = atk_faction
                end
                if not loser_is_ll then return false end
                -- Subculture filter: only LLs from corruption-producing
                -- factions count. Keeps the Wanderer route thematically
                -- aligned with the Purification route on long_victory.
                local sub = loser_faction:subculture()
                if not CORRUPTION_SUBCULTURES[sub] then return false end
                return true
            end,
            function()
                local count = cm:get_saved_value("pow_ext_nakai_ll_count") or 0
                count = count + 1
                if count > LL_THRESHOLD then count = LL_THRESHOLD end
                cm:set_saved_value("pow_ext_nakai_ll_count", count)
                cm:set_scripted_mission_text(
                    OW_MISSION_KEY, LL_SCRIPT_KEY,
                    LL_TEXT_PREFIX .. count
                )
                if count >= LL_THRESHOLD then
                    cm:complete_scripted_mission_objective(
                        FACTION_NAK_KEY, OW_MISSION_KEY, LL_SCRIPT_KEY, true
                    )
                    cm:set_saved_value("pow_ext_nakai_ll_complete", true)
                end
            end,
            true
        )

        -- Vassal settlement counter — recompute on every region transfer.
        local function update_gp_counter()
            if cm:get_saved_value("pow_ext_nakai_gp_complete") then
                return
            end
            -- Defensive: only run if the local human is Nakai.
            local nak = cm:get_faction(FACTION_NAK_KEY)
            if not nak or nak:is_null_interface() then return end
            if not nak:is_human() then return end
            local vassal = cm:get_faction(VASSAL_KEY)
            if not vassal or vassal:is_null_interface() then
                -- Vassal not in game (e.g. wiped). Display 0.
                cm:set_scripted_mission_text(
                    OW_MISSION_KEY, GP_SCRIPT_KEY, GP_TEXT_PREFIX .. "0"
                )
                return
            end
            local count = vassal:region_list():num_items()
            local display = count
            if display > GP_THRESHOLD then display = GP_THRESHOLD end
            cm:set_scripted_mission_text(
                OW_MISSION_KEY, GP_SCRIPT_KEY, GP_TEXT_PREFIX .. display
            )
            if count >= GP_THRESHOLD then
                cm:complete_scripted_mission_objective(
                    FACTION_NAK_KEY, OW_MISSION_KEY, GP_SCRIPT_KEY, true
                )
                cm:set_saved_value("pow_ext_nakai_gp_complete", true)
            end
        end

        -- Initial sync (turn 1 — vassal may have a starting region).
        update_gp_counter()

        core:add_listener(
            "pow_ext_nakai_gp_counter",
            "RegionFactionChangeEvent",
            function() return true end,
            function() update_gp_counter() end,
            true
        )
    end)
end

pow_ext_nakai_main();
