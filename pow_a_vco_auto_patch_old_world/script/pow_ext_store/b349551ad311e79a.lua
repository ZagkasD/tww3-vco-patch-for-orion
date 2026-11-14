-- pow_ext_listeners_cth_yua.lua
-- Yuan Bo (wh3_dlc24_cth_the_celestial_court) v1.5 redesign listener.
-- Owns both R2 (Mandate of Heaven character progression) and R3 (Wu Xing
-- Compass empowerment + final battle + cinematic) logic.
--
-- R2 sub-objective trackers:
--   - Forge the Dragon's Regalia: MissionSucceeded on Yuan Bo's two
--     vanilla Cathay QBs (Armour of the Dragon's Gaze at rank 10 +
--     The Dragon's Fang at rank 15). Completes when both done.
--   - The Emperor's Executioner: CharacterCompletedBattle counter
--     walking enemy armies' character lists for wounded/dead.
--   - Imperial Trade: FactionTurnStart polling of vanilla saved value
--     'caravans_completed_<faction>'. Threshold 10.
--
-- R3 logic:
--   - IncidentOccuredEvent for compass empowerment: vanilla's
--     wh3_dlc24_story_panel_yuan_bo_compass_<dir> incident is fired
--     by matters_of_state:incursion_complete; we mirror that signal
--     to forward our R3 SCRIPTED key + fire celestial winds dilemma.
--   - MissionSucceeded for final compass QB: forwards final_battle
--     SCRIPTED key to R3. (Vanilla matters_of_state plays the
--     yuan_bo_win cinematic itself; we do not.)
--   - DilemmaChoiceMadeEvent for pow_ext_yuan_bo_celestial_winds:
--     branches on choice 0-4 (4 teleport destinations + defer-5).
--   - FactionTurnStart for defer-5 re-trigger.

local FACTION_YUA_KEY = "wh3_dlc24_cth_the_celestial_court"

-- ============================================================
-- R2 thresholds and keys
-- ============================================================
local R2_MISSION_KEY = "wh_main_long_victory"

-- Celestial Adornments — two independent QB completions.
-- Dragon's Gaze (armour) auto-triggers at rank 10; Dragon's Fang
-- (weapon) auto-triggers at rank 15. OW Main duplicates the vanilla
-- IE missions with cr_oldworld_qb_-prefixed keys (see
-- extracted/ow_full/_filelist.txt: cr_oldworld_ancillary_quests__*
-- tables) — those are the actual mission_record_keys in the OW
-- campaign. The IE keys (wh3_dlc24_anc_*) point at IE-only rows the
-- engine never spawns under cr_oldworld.
local R2_DRAGONS_GAZE_SCRIPT_KEY = "pow_ext_yuan_bo_r2_dragons_gaze"
local R2_DRAGONS_GAZE_QB_MISSION = "cr_oldworld_qb_cth_yuan_bo_armour_of_the_dragons_gaze"
local R2_DRAGONS_FANG_SCRIPT_KEY = "pow_ext_yuan_bo_r2_dragons_fang"
local R2_DRAGONS_FANG_QB_MISSION = "cr_oldworld_qb_cth_yuan_bo_dragons_fang"

-- Executioner — Nakai-style LL kill counter (CharacterCompletedBattle
-- + is_unique() loser filter). No subculture filter; any LL counts.
-- Bucket-per-loc display via cm:set_scripted_mission_text.
local R2_EXECUTIONER_SCRIPT_KEY = "pow_ext_yuan_bo_r2_executioner"
local R2_EXECUTIONER_THRESHOLD = 15
local R2_EXECUTIONER_TEXT_PREFIX = "mission_text_text_pow_ext_yuan_bo_r2_executioner_"

-- Caravans (10 caravan missions completed)
local R2_CARAVANS_SCRIPT_KEY = "pow_ext_yuan_bo_r2_caravans"
local R2_CARAVANS_THRESHOLD  = 10
local R2_CARAVANS_TEXT_PREFIX = "mission_text_text_pow_ext_yuan_bo_r2_caravans_"
-- Vanilla saved-value key written by the base WH3 caravan completion logic.
-- Confirmed by user playtest: increments for Celestial Court faction.
local CARAVANS_VANILLA_SV_KEY = "caravans_completed_" .. FACTION_YUA_KEY

-- ============================================================
-- R3 thresholds and keys
-- ============================================================
local R3_MISSION_KEY = "wh_main_domination_victory"

local R3_COMPASS_SCRIPT_KEYS_BY_DIR = {
    west  = "pow_ext_yuan_bo_r3_compass_west",
    north = "pow_ext_yuan_bo_r3_compass_north",
    south = "pow_ext_yuan_bo_r3_compass_south",
    east  = "pow_ext_yuan_bo_r3_compass_east",
}
local R3_FINAL_BATTLE_SCRIPT_KEY = "pow_ext_yuan_bo_r3_final_battle"

-- Vanilla matters_of_state compass QB mission record key (target of
-- MissionSucceeded filter for cinematic + final-battle forwarding).
local COMPASS_QB_MISSION_KEY_PREFIX = "wh3_dlc24_ie_cth_yuan_bo_final_battle"

-- Compass anchor regions per direction (CONTROL/build location per OW
-- Main's matters_of_state.lua override).
local R3_ANCHOR_REGIONS_BY_DIR = {
    west  = "cr_oldworld_region_konquata",
    north = "cr_oldworld_region_dragonbone",
    south = "cr_oldworld_region_tyr_vanna",
    east  = "cr_oldworld_region_kurak_peak",
}

-- Teleport coordinates per direction (logical coords for cm:teleport_to).
-- Defaults from matters_of_state incursion_coordinates; user to refine
-- in-game via Freiya_Get_Map_Coordinates mod during playtest.
local R3_TELEPORT_COORDS_BY_DIR = {
    west  = {221, 1372},
    north = {770, 1683},
    south = {741, 929},
    east  = {1343, 1322},
}

-- The celestial winds dilemma offers 4 directional teleport choices,
-- a defer-5 choice, and a permanent-dismiss choice. No engine-side
-- grey-out: clicking an already-empowered direction is a no-cost fast
-- travel (designed feature, not a no-op). Listener owns the teleport
-- logic in Lua.
local CELESTIAL_WINDS_DILEMMA_KEY = "pow_ext_yuan_bo_celestial_winds"
local DILEMMA_CHOICE_BY_INDEX = {
    [0] = "west",
    [1] = "north",
    [2] = "south",
    [3] = "east",
    -- choice 4 = defer-5; choice 5 = dismiss; both handled separately
}
local DILEMMA_DEFER_CHOICE   = 4
local DILEMMA_DISMISS_CHOICE = 5
local DILEMMA_DEFER_TURNS    = 5

-- Save-value keys
local SV_LISTENER_VERSION   = "pow_ext_yuan_bo_listener_version_at_start"
local SV_R2_DRAGONS_GAZE_DONE = "pow_ext_yuan_bo_r2_qb_dragons_gaze_done"
local SV_R2_DRAGONS_FANG_DONE = "pow_ext_yuan_bo_r2_qb_dragons_fang_done"
local SV_R2_EXEC_COUNT = "pow_ext_yuan_bo_r2_executioner_count"
local SV_R2_EXEC_DONE  = "pow_ext_yuan_bo_r2_executioner_complete"
-- Set of family-member CQIs already counted (string keys for save/restore
-- safety). Same lord can be killed multiple times via wound/respawn
-- cycles; dedup prevents farming.
local SV_R2_EXEC_SEEN  = "pow_ext_yuan_bo_r2_executioner_seen_fms"
local SV_R2_CARAVANS_DONE   = "pow_ext_yuan_bo_r2_caravans_complete"
local SV_R3_COMPASS_PREFIX  = "pow_ext_yuan_bo_r3_compass_"  -- + dir
local SV_R3_FINAL_BATTLE    = "pow_ext_yuan_bo_r3_final_battle_done"
local SV_DILEMMA_DEFER_TURN = "pow_ext_yuan_bo_dilemma_defer_target_turn"

local LISTENER_VERSION = "1.5.0"

-- ============================================================
-- Helpers
-- ============================================================
local function yua_human()
    local f = cm:get_faction(FACTION_YUA_KEY)
    return f and not f:is_null_interface() and f:is_human()
end

local function bucket_text(prefix, value, threshold, bucket_size)
    -- Returns the loc key for the bucketed progress state.
    -- e.g. for threshold=50 + bucket_size=10, returns _0, _10, ..., _50.
    if value >= threshold then return prefix .. "complete" end
    local bucket = math.floor(value / bucket_size) * bucket_size
    return prefix .. tostring(bucket)
end

local function direction_from_compass_incident(incident_key)
    -- Vanilla matters_of_state:incursion_complete fires
    -- cm:trigger_incident(faction, "wh3_dlc24_story_panel_yuan_bo_compass_<dir>", ...).
    -- That's our empowerment-completed signal. Compass empowerment is
    -- NOT a ritual in WH3 (despite the in-game "ritual"-flavored UI):
    -- it's BuildingCompleted (relay) -> 6-turn incursion countdown ->
    -- the story panel incident. RitualCompletedEvent never fires.
    if not incident_key then return nil end
    local prefix = "wh3_dlc24_story_panel_yuan_bo_compass_"
    if string.sub(incident_key, 1, string.len(prefix)) ~= prefix then
        return nil
    end
    local tail = string.sub(incident_key, string.len(prefix) + 1)
    for _, dir in ipairs({"west", "north", "south", "east"}) do
        if tail == dir then return dir end
    end
    return nil
end

local function all_compass_empowered()
    for _, dir in ipairs({"west", "north", "south", "east"}) do
        if not cm:get_saved_value(SV_R3_COMPASS_PREFIX .. dir) then
            return false
        end
    end
    return true
end

-- ============================================================
-- R2 Celestial Adornments: independent completion per QB
-- ============================================================
local function mark_dragons_gaze_done()
    if cm:get_saved_value(SV_R2_DRAGONS_GAZE_DONE) then return end
    cm:set_saved_value(SV_R2_DRAGONS_GAZE_DONE, true)
    cm:complete_scripted_mission_objective(
        FACTION_YUA_KEY, R2_MISSION_KEY, R2_DRAGONS_GAZE_SCRIPT_KEY, true
    )
end

local function mark_dragons_fang_done()
    if cm:get_saved_value(SV_R2_DRAGONS_FANG_DONE) then return end
    cm:set_saved_value(SV_R2_DRAGONS_FANG_DONE, true)
    cm:complete_scripted_mission_objective(
        FACTION_YUA_KEY, R2_MISSION_KEY, R2_DRAGONS_FANG_SCRIPT_KEY, true
    )
end

local function log_yua(msg)
    if ModLog then ModLog("[YUA] " .. tostring(msg)) end
end

-- ============================================================
-- R2 Executioner: Nakai-style LL kill counter (bucket-per-loc).
-- ============================================================
local function refresh_executioner_text()
    local count = cm:get_saved_value(SV_R2_EXEC_COUNT) or 0
    if count > R2_EXECUTIONER_THRESHOLD then count = R2_EXECUTIONER_THRESHOLD end
    local key
    if count >= R2_EXECUTIONER_THRESHOLD then
        key = R2_EXECUTIONER_TEXT_PREFIX .. "complete"
    else
        key = R2_EXECUTIONER_TEXT_PREFIX .. tostring(count)
    end
    cm:set_scripted_mission_text(R2_MISSION_KEY, R2_EXECUTIONER_SCRIPT_KEY, key)
end

-- ============================================================
-- R2 Caravans: poll vanilla saved value on FactionTurnStart
-- ============================================================
local function refresh_caravans_text()
    local count = cm:get_saved_value(CARAVANS_VANILLA_SV_KEY) or 0
    local last_logged = cm:get_saved_value("pow_ext_yuan_bo_r2_caravans_last_logged") or -1
    if count ~= last_logged then
        log_yua("Caravan poll: turn=" .. tostring(cm:turn_number()) ..
            " saved_value=" .. tostring(count) ..
            " (was=" .. tostring(last_logged) .. ")")
        cm:set_saved_value("pow_ext_yuan_bo_r2_caravans_last_logged", count)
    end
    if count > R2_CARAVANS_THRESHOLD then count = R2_CARAVANS_THRESHOLD end
    cm:set_scripted_mission_text(
        R2_MISSION_KEY, R2_CARAVANS_SCRIPT_KEY,
        bucket_text(R2_CARAVANS_TEXT_PREFIX, count, R2_CARAVANS_THRESHOLD, 1)
    )
    if count >= R2_CARAVANS_THRESHOLD and not cm:get_saved_value(SV_R2_CARAVANS_DONE) then
        cm:set_saved_value(SV_R2_CARAVANS_DONE, true)
        log_yua("Caravan threshold reached at turn " .. tostring(cm:turn_number()))
        cm:complete_scripted_mission_objective(
            FACTION_YUA_KEY, R2_MISSION_KEY, R2_CARAVANS_SCRIPT_KEY, true
        )
    end
end

-- ============================================================
-- R3 Compass: empowerment forwarding + resource decrement + dilemma
-- ============================================================
local function fire_celestial_winds_dilemma()
    if all_compass_empowered() then
        return
    end
    log_yua("firing celestial winds dilemma (turn=" ..
        tostring(cm:turn_number()) .. ")")
    cm:trigger_dilemma(FACTION_YUA_KEY, CELESTIAL_WINDS_DILEMMA_KEY)
end

local function handle_compass_empowered(direction)
    if not direction then return end
    local sv = SV_R3_COMPASS_PREFIX .. direction
    if cm:get_saved_value(sv) then return end  -- already handled
    cm:set_saved_value(sv, true)

    -- Forward R3 SCRIPTED completion
    cm:complete_scripted_mission_objective(
        FACTION_YUA_KEY, R3_MISSION_KEY,
        R3_COMPASS_SCRIPT_KEYS_BY_DIR[direction], true
    )

    -- Fire celestial winds dilemma (after a small delay so the
    -- empowerment UI feedback resolves first). The dilemma offers
    -- the 4 directions + defer; player picking an already-completed
    -- direction is a no-cost fast travel, not a misclick penalty.
    cm:callback(fire_celestial_winds_dilemma, 1.0)
end

-- ============================================================
-- R3 Final battle + cinematic
-- ============================================================
local function handle_final_battle_won()
    if cm:get_saved_value(SV_R3_FINAL_BATTLE) then return end
    cm:set_saved_value(SV_R3_FINAL_BATTLE, true)

    -- Forward R3 SCRIPTED completion
    cm:complete_scripted_mission_objective(
        FACTION_YUA_KEY, R3_MISSION_KEY,
        R3_FINAL_BATTLE_SCRIPT_KEY, true
    )

    -- Cinematic is fired by vanilla yuan_bo_final_battle_victory
    -- listener (wh3_dlc24_matters_of_state.lua:370) on the same
    -- MissionSucceeded event. Do NOT register the movie ourselves
    -- or it plays twice.
end

-- ============================================================
-- Dilemma choice handler
-- ============================================================
local function handle_celestial_winds_choice(choice)
    local faction = cm:get_faction(FACTION_YUA_KEY)
    if not faction or faction:is_null_interface() then return end
    local leader = faction:faction_leader()
    if not leader or leader:is_null_interface() then return end

    if choice == DILEMMA_DEFER_CHOICE then
        -- Defer-5: re-trigger dilemma in N turns
        local target = cm:turn_number() + DILEMMA_DEFER_TURNS
        cm:set_saved_value(SV_DILEMMA_DEFER_TURN, target)
        return
    end

    if choice == DILEMMA_DISMISS_CHOICE then
        -- Permanent dismiss: close without re-trigger. Next compass
        -- empowerment naturally re-fires the dilemma.
        return
    end

    local direction = DILEMMA_CHOICE_BY_INDEX[choice]
    if not direction then return end
    local coords = R3_TELEPORT_COORDS_BY_DIR[direction]
    if not coords then return end

    -- Defer the teleport one tick to let dilemma-close UI settle
    cm:callback(function()
        cm:teleport_to(
            cm:char_lookup_str(leader),
            coords[1], coords[2]
        )
    end, 0.1)
end

-- ============================================================
-- Main: wire all listeners after first tick
-- ============================================================
local function pow_ext_cth_yua_main()
    cm:add_first_tick_callback(function()
        cm:set_saved_value(SV_LISTENER_VERSION, LISTENER_VERSION)

        if not yua_human() then return end

        -- Sync displayed text on every (re)load so save-loads show
        -- current progress immediately rather than baked stale text.
        -- Adornments are binary per-QB; no progress text to refresh.
        refresh_executioner_text()
        refresh_caravans_text()


        -- ----- R2 Celestial Adornments: Dragon's Gaze (rank 10) -----
        core:add_listener(
            "pow_ext_yuan_bo_r2_dragons_gaze_qb",
            "MissionSucceeded",
            function(context)
                if cm:get_saved_value(SV_R2_DRAGONS_GAZE_DONE) then return false end
                if context:faction():name() ~= FACTION_YUA_KEY then return false end
                return context:mission():mission_record_key() == R2_DRAGONS_GAZE_QB_MISSION
            end,
            function() mark_dragons_gaze_done() end,
            true
        )

        -- ----- R2 Celestial Adornments: Dragon's Fang (rank 15) -----
        core:add_listener(
            "pow_ext_yuan_bo_r2_dragons_fang_qb",
            "MissionSucceeded",
            function(context)
                if cm:get_saved_value(SV_R2_DRAGONS_FANG_DONE) then return false end
                if context:faction():name() ~= FACTION_YUA_KEY then return false end
                return context:mission():mission_record_key() == R2_DRAGONS_FANG_QB_MISSION
            end,
            function() mark_dragons_fang_done() end,
            true
        )

        -- ----- R2 Executioner: named-lord kill counter (Nakai pattern + dedup) -----
        log_yua("registering executioner CharacterCompletedBattle listener (threshold=" ..
            tostring(R2_EXECUTIONER_THRESHOLD) .. ")")
        core:add_listener(
            "pow_ext_yuan_bo_r2_executioner",
            "CharacterCompletedBattle",
            function(context)
                if cm:get_saved_value(SV_R2_EXEC_DONE) then return false end
                local pb = context:pending_battle()
                local atk_faction = pb:attacker():faction()
                local def_faction = pb:defender():faction()
                local yua_atk = atk_faction:name() == FACTION_YUA_KEY
                local yua_def = def_faction:name() == FACTION_YUA_KEY
                if not (yua_atk or yua_def) then return false end
                local yua_faction = yua_atk and atk_faction or def_faction
                if not yua_faction:is_human() then return false end
                local won = yua_atk and pb:attacker_won() or pb:defender_won()

                local atk_fm_cqi = cm:pending_battle_cache_get_attacker_fm_cqi(1)
                local atk_fm = cm:get_family_member_by_cqi(atk_fm_cqi)
                local def_fm_cqi = cm:pending_battle_cache_get_defender_fm_cqi(1)
                local def_fm = cm:get_family_member_by_cqi(def_fm_cqi)

                local function is_named_faction_leader(fm)
                    if not fm then return false end
                    local d = fm:character_details()
                    if not d or not d:is_unique() then return false end
                    local char = fm:character()
                    if not char or char:is_null_interface() then return false end
                    return char:is_faction_leader()
                end

                -- Pick the loser's FM explicitly. Don't use the Lua
                -- `cond and a or b` ternary on is_named_faction_leader:
                -- when the leader check returns FALSE the OR falls
                -- through to the attacker FM, which is Yuan Bo himself
                -- (always a faction leader) -> every battle counts.
                local loser_fm_cqi, loser_fm, loser_faction
                if yua_atk then
                    loser_fm_cqi = def_fm_cqi
                    loser_fm = def_fm
                    loser_faction = def_faction:name()
                else
                    loser_fm_cqi = atk_fm_cqi
                    loser_fm = atk_fm
                    loser_faction = atk_faction:name()
                end
                local loser_is_leader = is_named_faction_leader(loser_fm)

                -- Dedup: same FM CQI only counts once across the campaign.
                local seen = cm:get_saved_value(SV_R2_EXEC_SEEN) or {}
                local cqi_key = tostring(loser_fm_cqi)
                local already_counted = seen[cqi_key] == true

                log_yua("Executioner filter: yua_atk=" .. tostring(yua_atk) ..
                    " won=" .. tostring(won) ..
                    " loser_faction=" .. tostring(loser_faction) ..
                    " loser_is_leader=" .. tostring(loser_is_leader) ..
                    " loser_fm_cqi=" .. cqi_key ..
                    " already_counted=" .. tostring(already_counted))
                return won and loser_is_leader and not already_counted
            end,
            function(context)
                -- Re-derive loser FM CQI from the same context the filter saw.
                local pb = context:pending_battle()
                local was_yua_atk = pb:attacker():faction():name() == FACTION_YUA_KEY
                local loser_fm_cqi = was_yua_atk
                    and cm:pending_battle_cache_get_defender_fm_cqi(1)
                    or cm:pending_battle_cache_get_attacker_fm_cqi(1)

                -- Mark this FM as seen.
                local seen = cm:get_saved_value(SV_R2_EXEC_SEEN) or {}
                seen[tostring(loser_fm_cqi)] = true
                cm:set_saved_value(SV_R2_EXEC_SEEN, seen)

                local count = (cm:get_saved_value(SV_R2_EXEC_COUNT) or 0) + 1
                if count > R2_EXECUTIONER_THRESHOLD then
                    count = R2_EXECUTIONER_THRESHOLD
                end
                cm:set_saved_value(SV_R2_EXEC_COUNT, count)
                log_yua("Executioner handler: counted FM " .. tostring(loser_fm_cqi) ..
                    " -> " .. tostring(count) .. " / " .. tostring(R2_EXECUTIONER_THRESHOLD))
                refresh_executioner_text()
                if count >= R2_EXECUTIONER_THRESHOLD then
                    log_yua("Executioner handler: threshold reached, completing objective")
                    cm:complete_scripted_mission_objective(
                        FACTION_YUA_KEY, R2_MISSION_KEY,
                        R2_EXECUTIONER_SCRIPT_KEY, true
                    )
                    cm:set_saved_value(SV_R2_EXEC_DONE, true)
                end
            end,
            true
        )


        -- ----- R2 Caravan: refresh on the vanilla CaravanCompleted event -----
        -- Vanilla wh3_campaign_caravans_core.lua handler writes
        -- caravans_completed_<faction> on this event (line 638) then
        -- triggers ScriptEventCaravanCompleted (line 639). Listening
        -- here gives us the same-tick refresh; the prior FactionTurnStart
        -- poll introduced a 1-2 turn delay (AI phase eats the gap
        -- between caravan arrival mid-turn and next Yuan Bo turn start).
        core:add_listener(
            "pow_ext_yuan_bo_r2_caravans_event",
            "CaravanCompleted",
            function(context)
                if cm:get_saved_value(SV_R2_CARAVANS_DONE) then return false end
                return context:faction():name() == FACTION_YUA_KEY
            end,
            refresh_caravans_text,
            true
        )
        -- Backup: FactionTurnStart poll as resilience layer. Catches
        -- the saved value if the CaravanCompleted listener misses
        -- (load order races, save-load mid-caravan, etc.).
        core:add_listener(
            "pow_ext_yuan_bo_r2_caravans_poll",
            "FactionTurnStart",
            function(context)
                if cm:get_saved_value(SV_R2_CARAVANS_DONE) then return false end
                return context:faction():name() == FACTION_YUA_KEY
            end,
            refresh_caravans_text,
            true
        )

        -- ----- R3 Compass empowerment via IncidentOccuredEvent (primary) -----
        -- Vanilla matters_of_state:incursion_complete fires
        -- cm:trigger_incident(faction, "wh3_dlc24_story_panel_yuan_bo_compass_<dir>", ...)
        -- when the 6-turn incursion countdown expires. Compass empowerment
        -- is NOT a ritual in WH3 — earlier RitualCompletedEvent listener
        -- never fired. IncidentOccuredEvent's `:dilemma()` accessor returns
        -- the incident key (CA reused the method name despite the type).
        --
        -- Defer our handler via cm:callback(0.5s) so vanilla's
        -- incursion_complete finishes its remaining work (sets
        -- yuan_tower_<dir>, increments yuan_bo_victory_count, fires
        -- empower_compass_<dir> on wh_main_long_victory, potentially
        -- triggers the final battle mission) before we run.
        core:add_listener(
            "pow_ext_yuan_bo_r3_compass_incident",
            "IncidentOccuredEvent",
            function(context)
                if context:faction():name() ~= FACTION_YUA_KEY then return false end
                return direction_from_compass_incident(context:dilemma()) ~= nil
            end,
            function(context)
                local direction = direction_from_compass_incident(context:dilemma())
                log_yua("R3 compass incident detected: dir=" .. tostring(direction))
                cm:callback(function()
                    handle_compass_empowered(direction)
                end, 0.5)
            end,
            true
        )

        -- ----- R3 Compass empowerment backup poll (FactionTurnStart) -----
        -- If IncidentOccuredEvent doesn't fire for whatever reason
        -- (cm:trigger_incident's trailing `true, true` flags suppressing
        -- the player-popup event, save/load mid-incursion, etc.), this
        -- polls vanilla's deterministic saved value `yuan_tower_<dir>`
        -- that incursion_complete sets at matters_of_state.lua:680.
        -- handle_compass_empowered is idempotent (guarded by
        -- SV_R3_COMPASS_PREFIX .. dir saved value), so it's safe even
        -- when the incident path also fires.
        core:add_listener(
            "pow_ext_yuan_bo_r3_compass_poll",
            "FactionTurnStart",
            function(context)
                if context:faction():name() ~= FACTION_YUA_KEY then return false end
                for _, dir in ipairs({"west", "north", "south", "east"}) do
                    if cm:get_saved_value("yuan_tower_" .. dir) and
                       not cm:get_saved_value(SV_R3_COMPASS_PREFIX .. dir) then
                        return true
                    end
                end
                return false
            end,
            function()
                for _, dir in ipairs({"west", "north", "south", "east"}) do
                    if cm:get_saved_value("yuan_tower_" .. dir) and
                       not cm:get_saved_value(SV_R3_COMPASS_PREFIX .. dir) then
                        log_yua("R3 compass poll caught empowerment: dir=" ..
                            tostring(dir) .. " (incident path missed it)")
                        handle_compass_empowered(dir)
                    end
                end
            end,
            true
        )

        -- ----- R3 Final battle via MissionSucceeded -----
        core:add_listener(
            "pow_ext_yuan_bo_r3_final_battle",
            "MissionSucceeded",
            function(context)
                if cm:get_saved_value(SV_R3_FINAL_BATTLE) then return false end
                if context:faction():name() ~= FACTION_YUA_KEY then return false end
                local mk = context:mission():mission_record_key()
                return string.sub(mk, 1, string.len(COMPASS_QB_MISSION_KEY_PREFIX))
                    == COMPASS_QB_MISSION_KEY_PREFIX
            end,
            function() handle_final_battle_won() end,
            true
        )

        -- ----- Celestial winds dilemma handler -----
        core:add_listener(
            "pow_ext_yuan_bo_celestial_winds_choice",
            "DilemmaChoiceMadeEvent",
            function(context)
                return context:dilemma() == CELESTIAL_WINDS_DILEMMA_KEY
            end,
            function(context)
                local choice = context:choice()
                log_yua("celestial winds choice made: " .. tostring(choice))
                handle_celestial_winds_choice(choice)
            end,
            true
        )

        -- ----- Defer-5 re-trigger checker -----
        -- Uses exact-match (==) rather than >=: a `>=` check combined
        -- with a `nil`-clear that doesn't reliably persist made the
        -- dilemma re-fire every turn forever after the target turn.
        -- Sentinel 0 = "cleared"; cm:set_saved_value(key, nil) is
        -- unreliable for clearing, so we write 0 explicitly.
        core:add_listener(
            "pow_ext_yuan_bo_defer_check",
            "FactionTurnStart",
            function(context)
                if context:faction():name() ~= FACTION_YUA_KEY then return false end
                local target = cm:get_saved_value(SV_DILEMMA_DEFER_TURN)
                if not target or target == 0 then return false end
                return cm:turn_number() == target
            end,
            function()
                cm:set_saved_value(SV_DILEMMA_DEFER_TURN, 0)
                fire_celestial_winds_dilemma()
            end,
            true
        )
    end)
end

pow_ext_cth_yua_main();
