-- pow_ext_listeners_skv_mdr.lua
-- Throt R1 augments bypass + R3 Ariel-QB trigger. See doc comment
-- on write_skv_mdr_augments_listener_stub in pack.rs for details.

local FACTION_MDR_KEY = "wh2_main_skv_clan_moulder"

-- R1 (augments) --
local R1_SCRIPT_KEY = "vco_skv_mld_augments"
local R1_OW_MISSION_KEY = "wh_main_short_victory"
local REQUIRED_TAILS = { "inf_aug_13", "inf_aug_14", "mon_aug_13", "mon_aug_14" }
local AUGMENTS_THRESHOLD = 4
-- In debug, any Flesh Lab augment purchase triggers (tier-13/14
-- requires late-game tech research — impractical for quick
-- iteration). Wildcard-matches the wh2_dlc16_throt_flesh_lab_ prefix.
local AUGMENTS_DEBUG_WILDCARD = false

-- R3 (Ariel QB) --
local R3_QB_KEY = "vco_wh2_dlc16_qb_skv_final_battle_throt"
local R3_OW_MISSION_KEY = "wh_main_domination_victory"

local function effect_tail_for(effect_key)
    for _, tail in ipairs(REQUIRED_TAILS) do
        if effect_key == "wh2_dlc16_throt_flesh_lab_" .. tail then
            return tail
        end
    end
    -- Debug-only fallback: any Flesh Lab augment effect counts as
    -- one of the required tails (folded into the first tail's slot)
    -- so a tier-1 augment purchase fires the listener.
    if AUGMENTS_DEBUG_WILDCARD
        and effect_key:sub(1, 26) == "wh2_dlc16_throt_flesh_lab_"
    then
        return REQUIRED_TAILS[1]
    end
    return nil
end

local function count_unlocked_augments()
    local n = 0
    for _, tail in ipairs(REQUIRED_TAILS) do
        if cm:get_saved_value("vco_skv_mdr_" .. tail .. "_unlocked") then
            n = n + 1
        end
    end
    return n
end

local function pow_ext_skv_mdr_main()
    cm:add_first_tick_callback(function()
        -- R1 augments listener
        core:add_listener(
            "pow_ext_skv_mdr_augments",
            "UnitEffectPurchased",
            function(context)
                if cm:get_saved_value("pow_ext_skv_mdr_augments_complete") then
                    return false
                end
                local faction = context:unit():faction()
                if not faction:is_human() or faction:name() ~= FACTION_MDR_KEY then
                    return false
                end
                return effect_tail_for(context:effect():record_key()) ~= nil
            end,
            function(context)
                local tail = effect_tail_for(context:effect():record_key())
                if tail then
                    cm:set_saved_value("vco_skv_mdr_" .. tail .. "_unlocked", true)
                end
                if count_unlocked_augments() >= AUGMENTS_THRESHOLD then
                    cm:complete_scripted_mission_objective(
                        FACTION_MDR_KEY, R1_OW_MISSION_KEY, R1_SCRIPT_KEY, true
                    )
                    cm:set_saved_value("pow_ext_skv_mdr_augments_complete", true)
                end
            end,
            true
        )

        -- R3 Ariel-QB trigger on R3 MissionSucceeded. Mirrors VCO's
        -- R1 Ghoritch pattern (vco_skv_mdr_ghoritch_3_completed
        -- fires the QB on MUFFIN_MAN-issuer MissionSucceeded). For
        -- R3 the issuer is KING_KAZADOR which fires VCO's separate
        -- harvest dilemma — we add our own listener filtering by
        -- mission_record_key + faction so we don't depend on the
        -- issuer chain. Fires the Ariel QB as a post-completion
        -- reward simultaneously with R3's game_victory payload.
        core:add_listener(
            "pow_ext_skv_mdr_ariel_qb_trigger",
            "MissionSucceeded",
            function(context)
                if cm:get_saved_value("pow_ext_skv_mdr_ariel_qb_triggered") then
                    return false
                end
                if not context:faction():is_human() then return false end
                if context:faction():name() ~= FACTION_MDR_KEY then return false end
                return context:mission():mission_record_key() == R3_OW_MISSION_KEY
            end,
            function(context)
                cm:trigger_mission(FACTION_MDR_KEY, R3_QB_KEY, true)
                cm:set_saved_value("pow_ext_skv_mdr_ariel_qb_triggered", true)
            end,
            false
        )
    end)
end

pow_ext_skv_mdr_main()
