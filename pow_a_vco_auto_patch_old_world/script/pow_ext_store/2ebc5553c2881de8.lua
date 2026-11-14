-- pow_ext_listeners_dwf_grombrindal.lua
-- Grombrindal, the White Dwarf (wh3_main_dwf_the_ancestral_throng) v1.5 redesign listener.
-- Owns R2 (The Mountainstrider — 4 vanilla rank-up QBs + Gnollengrom)
-- and R3 (The Old Grudge — R2-complete forwarder + legendary grudge counter).
--
-- R2 sub-objective trackers:
--   - 4 rank-up QB completions: Armour of Glimril Scales, Rune Axe of Grombrindal,
--     Cloak of Valaya, Rune Helm of Zhufbar. MissionSucceeded on cr_oldworld_qb_dwf_grombrindal_*
--     (OW Main's duplicated keys; vanilla IE keys silently no-fire under cr_oldworld).
--   - Gnollengrom: IncidentOccuredEvent on wh3_dlc25_incident_grudge_cycle_5
--     ("Age of Reckoning Complete: Gnollengrom"). Single one-shot fire.
--
-- R3 sub-objective trackers:
--   - R2-complete forwarder: MissionSucceeded on wh_main_long_victory — marks R3's
--     compound prereq SCRIPTED as done.
--   - Legendary grudges counter: MissionSucceeded prefix-match on
--     wh3_dlc25_grudge_legendary_*. Catches all 12 OW grudges (10 vanilla + 2 OW-added
--     karaz_ankor_2 / _3). mission_record_key dedup. Threshold 4.

local FACTION_GRO_KEY = "wh3_main_dwf_the_ancestral_throng"

-- ============================================================
-- R2 thresholds and keys
-- ============================================================
local R2_MISSION_KEY = "wh_main_long_victory"

local R2_ARMOUR_SCRIPT_KEY = "pow_ext_grombrindal_armour_of_glimril"
local R2_ARMOUR_QB_MISSION = "cr_oldworld_qb_dwf_grombrindal_armour_of_glimril"
local R2_AXE_SCRIPT_KEY    = "pow_ext_grombrindal_rune_axe"
local R2_AXE_QB_MISSION    = "cr_oldworld_qb_dwf_grombrindal_rune_axe_of_grombrindal"
local R2_CLOAK_SCRIPT_KEY  = "pow_ext_grombrindal_cloak_of_valaya"
local R2_CLOAK_QB_MISSION  = "cr_oldworld_qb_dwf_grombrindal_rune_cloak_of_valaya"
local R2_HELM_SCRIPT_KEY   = "pow_ext_grombrindal_rune_helm"
local R2_HELM_QB_MISSION   = "cr_oldworld_qb_dwf_grombrindal_rune_helm_of_zhufbar"

local R2_GNOLLENGROM_SCRIPT_KEY = "pow_ext_grombrindal_gnollengrom"
local GNOLLENGROM_INCIDENT_KEY  = "wh3_dlc25_incident_grudge_cycle_5"

-- ============================================================
-- R3 thresholds and keys
-- ============================================================
local R3_MISSION_KEY = "wh_main_domination_victory"

local R3_GRUDGE_SCRIPT_KEY  = "pow_ext_grombrindal_legendary_grudges"
local R3_GRUDGE_THRESHOLD   = 4
local R3_GRUDGE_TEXT_PREFIX = "mission_text_text_pow_ext_grombrindal_legendary_grudges_"
local GRUDGE_KEY_PREFIX     = "wh3_dlc25_grudge_legendary_"

local R3_R2_COMPLETE_SCRIPT_KEY = "pow_ext_grombrindal_r2_complete"

-- ============================================================
-- Save-value keys
-- ============================================================
local SV_LISTENER_VERSION    = "pow_ext_grombrindal_listener_version_at_start"
local SV_R2_ARMOUR_DONE      = "pow_ext_grombrindal_r2_armour_done"
local SV_R2_AXE_DONE         = "pow_ext_grombrindal_r2_axe_done"
local SV_R2_CLOAK_DONE       = "pow_ext_grombrindal_r2_cloak_done"
local SV_R2_HELM_DONE        = "pow_ext_grombrindal_r2_helm_done"
local SV_R2_GNOLLENGROM_DONE = "pow_ext_grombrindal_r2_gnollengrom_done"
local SV_R3_R2_COMPLETE_DONE = "pow_ext_grombrindal_r3_r2_complete_done"
local SV_R3_GRUDGE_COUNT     = "pow_ext_grombrindal_r3_grudge_count"
local SV_R3_GRUDGE_DONE      = "pow_ext_grombrindal_r3_grudge_complete"
local SV_R3_GRUDGE_SEEN      = "pow_ext_grombrindal_r3_grudge_seen_keys"

local LISTENER_VERSION = "1.5.0"

-- ============================================================
-- Helpers
-- ============================================================
local function log_grom(msg)
    if ModLog then ModLog("[GRO] " .. tostring(msg)) end
end

local function gro_human()
    local f = cm:get_faction(FACTION_GRO_KEY)
    return f and not f:is_null_interface() and f:is_human()
end

local function mark_qb_done(script_key, sv_key)
    if cm:get_saved_value(sv_key) then return end
    cm:set_saved_value(sv_key, true)
    log_grom("R2 QB completed: " .. script_key)
    cm:complete_scripted_mission_objective(
        FACTION_GRO_KEY, R2_MISSION_KEY, script_key, true
    )
end

local function refresh_grudge_text()
    local count = cm:get_saved_value(SV_R3_GRUDGE_COUNT) or 0
    if count > R3_GRUDGE_THRESHOLD then count = R3_GRUDGE_THRESHOLD end
    local key
    if count >= R3_GRUDGE_THRESHOLD then
        key = R3_GRUDGE_TEXT_PREFIX .. "complete"
    else
        key = R3_GRUDGE_TEXT_PREFIX .. tostring(count)
    end
    cm:set_scripted_mission_text(R3_MISSION_KEY, R3_GRUDGE_SCRIPT_KEY, key)
end

-- ============================================================
-- Main: wire all listeners after first tick
-- ============================================================
local function pow_ext_dwf_grombrindal_main()
    cm:add_first_tick_callback(function()
        cm:set_saved_value(SV_LISTENER_VERSION, LISTENER_VERSION)

        if not gro_human() then return end

        refresh_grudge_text()

        -- ----- R2 rank-up QB forwarders (4 of them) -----
        core:add_listener(
            "pow_ext_grombrindal_r2_armour_qb",
            "MissionSucceeded",
            function(context)
                if cm:get_saved_value(SV_R2_ARMOUR_DONE) then return false end
                if context:faction():name() ~= FACTION_GRO_KEY then return false end
                return context:mission():mission_record_key() == R2_ARMOUR_QB_MISSION
            end,
            function() mark_qb_done(R2_ARMOUR_SCRIPT_KEY, SV_R2_ARMOUR_DONE) end,
            true
        )

        core:add_listener(
            "pow_ext_grombrindal_r2_axe_qb",
            "MissionSucceeded",
            function(context)
                if cm:get_saved_value(SV_R2_AXE_DONE) then return false end
                if context:faction():name() ~= FACTION_GRO_KEY then return false end
                return context:mission():mission_record_key() == R2_AXE_QB_MISSION
            end,
            function() mark_qb_done(R2_AXE_SCRIPT_KEY, SV_R2_AXE_DONE) end,
            true
        )

        core:add_listener(
            "pow_ext_grombrindal_r2_cloak_qb",
            "MissionSucceeded",
            function(context)
                if cm:get_saved_value(SV_R2_CLOAK_DONE) then return false end
                if context:faction():name() ~= FACTION_GRO_KEY then return false end
                return context:mission():mission_record_key() == R2_CLOAK_QB_MISSION
            end,
            function() mark_qb_done(R2_CLOAK_SCRIPT_KEY, SV_R2_CLOAK_DONE) end,
            true
        )

        core:add_listener(
            "pow_ext_grombrindal_r2_helm_qb",
            "MissionSucceeded",
            function(context)
                if cm:get_saved_value(SV_R2_HELM_DONE) then return false end
                if context:faction():name() ~= FACTION_GRO_KEY then return false end
                return context:mission():mission_record_key() == R2_HELM_QB_MISSION
            end,
            function() mark_qb_done(R2_HELM_SCRIPT_KEY, SV_R2_HELM_DONE) end,
            true
        )

        -- ----- R2 Gnollengrom forwarder (one-shot) -----
        core:add_listener(
            "pow_ext_grombrindal_r2_gnollengrom",
            "IncidentOccuredEvent",
            function(context)
                if cm:get_saved_value(SV_R2_GNOLLENGROM_DONE) then return false end
                if context:faction():name() ~= FACTION_GRO_KEY then return false end
                return context:dilemma() == GNOLLENGROM_INCIDENT_KEY
            end,
            function()
                cm:set_saved_value(SV_R2_GNOLLENGROM_DONE, true)
                log_grom("Gnollengrom achieved (Age of Reckoning at 100%)")
                cm:complete_scripted_mission_objective(
                    FACTION_GRO_KEY, R2_MISSION_KEY, R2_GNOLLENGROM_SCRIPT_KEY, true
                )
            end,
            true
        )

        -- ----- R3 R2-complete forwarder -----
        -- When R2 (wh_main_long_victory) completes, mark R3's compound
        -- prereq SCRIPTED as done. Brittleness tradeoff accepted by user:
        -- if R2's mission-success listener fires miss, R3 cannot complete.
        -- The R2 SCRIPTED gates (4 QBs + LL hunt + Gnollengrom) all forward
        -- to wh_main_long_victory's completion via the engine's standard
        -- victory mission flow, so this is the same MissionSucceeded
        -- signal vanilla emits when R2 completes.
        core:add_listener(
            "pow_ext_grombrindal_r3_r2_complete",
            "MissionSucceeded",
            function(context)
                if cm:get_saved_value(SV_R3_R2_COMPLETE_DONE) then return false end
                if context:faction():name() ~= FACTION_GRO_KEY then return false end
                return context:mission():mission_record_key() == R2_MISSION_KEY
            end,
            function()
                cm:set_saved_value(SV_R3_R2_COMPLETE_DONE, true)
                log_grom("R2 complete (Accoutrements of Ages) — forwarding to R3 prereq")
                cm:complete_scripted_mission_objective(
                    FACTION_GRO_KEY, R3_MISSION_KEY, R3_R2_COMPLETE_SCRIPT_KEY, true
                )
            end,
            true
        )


        -- ----- R3 legendary grudges counter -----
        log_grom("registering legendary grudges MissionSucceeded listener (threshold=" ..
            tostring(R3_GRUDGE_THRESHOLD) .. ")")
        core:add_listener(
            "pow_ext_grombrindal_r3_legendary_grudges",
            "MissionSucceeded",
            function(context)
                if cm:get_saved_value(SV_R3_GRUDGE_DONE) then return false end
                if context:faction():name() ~= FACTION_GRO_KEY then return false end
                local mk = context:mission():mission_record_key()
                if string.sub(mk, 1, string.len(GRUDGE_KEY_PREFIX)) ~= GRUDGE_KEY_PREFIX then
                    return false
                end
                local seen = cm:get_saved_value(SV_R3_GRUDGE_SEEN) or {}
                if seen[mk] == true then return false end
                return true
            end,
            function(context)
                local mk = context:mission():mission_record_key()
                local seen = cm:get_saved_value(SV_R3_GRUDGE_SEEN) or {}
                seen[mk] = true
                cm:set_saved_value(SV_R3_GRUDGE_SEEN, seen)

                local count = (cm:get_saved_value(SV_R3_GRUDGE_COUNT) or 0) + 1
                if count > R3_GRUDGE_THRESHOLD then count = R3_GRUDGE_THRESHOLD end
                cm:set_saved_value(SV_R3_GRUDGE_COUNT, count)
                log_grom("Legendary grudge settled: " .. mk ..
                    " (" .. tostring(count) .. " / " ..
                    tostring(R3_GRUDGE_THRESHOLD) .. ")")
                refresh_grudge_text()
                if count >= R3_GRUDGE_THRESHOLD then
                    cm:set_saved_value(SV_R3_GRUDGE_DONE, true)
                    log_grom("Legendary grudges threshold reached")
                    cm:complete_scripted_mission_objective(
                        FACTION_GRO_KEY, R3_MISSION_KEY, R3_GRUDGE_SCRIPT_KEY, true
                    )
                end
            end,
            true
        )
    end)
end

pow_ext_dwf_grombrindal_main();
