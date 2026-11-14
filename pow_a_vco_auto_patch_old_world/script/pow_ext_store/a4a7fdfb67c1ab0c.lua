-- pow_ext_listeners_vmp_man.lua
-- Mannfred listener overrides. Currently fixes two issues:
--
-- (1) Route 2 'Death Comes For All' — Books of Nagash counter bypass.
--     (After the R2/R3 swap this is the long_victory slot.)
--     VCO's vlc.nagash_books:check_all_books_collected helper uses
--     vco:set_mission_text / vco:complete_mission which hardcode the
--     mission key vco_route_victory — broken under our OW long_victory
--     key. Listen to the same MissionSucceeded event but call the
--     direct CA APIs with the correct OW mission key, and complete
--     after 5 of 8 books (not all 8 — softens the route's grind).
--
-- (2) Route 1 'Restless Dunes' — Ossified Portal teleport override.
--     VCO's vco_vmp_man_dilemma_choice_made handler teleports
--     Mannfred to IE coords (666, 580) on Choice 0 of the Ossified
--     Portal dilemma — wrong on the OW map. Choice 1 schedules the
--     dilemma to re-fire after 10 turns, which makes the player wait
--     long stretches between portal prompts.
--
--     This stub registers a second DilemmaChoiceMadeEvent listener
--     that fires AFTER VCO's (our pack loads after theirs), and:
--       - Overrides Choice 0 with a fresh cm:teleport_to to OW coords
--         in the Sylvania region.
--       - Overrides Choice 1 by removing VCO's stale 10-turn
--         FactionTurnStart listener (named `vco_vmp_man_dilemma_-
--         trigger_delay`) and registering our own with a shorter
--         delay.

local FACTION_MAN_KEY = "wh_main_vmp_vampire_counts"

-- Route 3 Books of Nagash bypass --
local SCRIPT_KEY = "vco_wh_main_vmp_vampire_counts_nagash_books"
-- Books objective lives in long_victory slot for v1.2.0+ campaigns
-- (after the R2/R3 swap — Books became R2, Sylvania the R3 capstone).
-- For v1.1.1 saves carried over to v1.2.0, the objective is baked
-- into the domination_victory slot in the save. We fire both keys
-- so cm:complete_scripted_mission_objective hits whichever slot has
-- the objective; the other is a no-op. Same applies to
-- set_scripted_mission_text.
local OW_MISSION_KEY_NEW = "wh_main_long_victory"
local OW_MISSION_KEY_OLD = "wh_main_domination_victory"
-- Custom loc prefix for our 5-of-8 threshold. VCO's
-- vco_common_nagash_books_collected_X strings say "Collect ALL the
-- Books" which is wrong for our shortened threshold; the generator
-- rewrites the SCRIPTED objective override_text to point at this
-- prefix instead and our loc shim ships matching count text.
local TEXT_PREFIX = "mission_text_text_pow_ext_vmp_man_5_books_collected_"
local THRESHOLD = 5
local MAX_BOOKS = 8

-- Route 1 Ossified Portal override --
local OSSIFIED_DILEMMA_KEY = "vco_vmp_man_dilemma_ossified_portal"
local OW_PORTAL_X = 1035
local OW_PORTAL_Y = 1075
-- 5 turns. VCO source uses 10. Compromise: long enough that the choice
-- "decline now, ask again later" feels meaningful, short enough that
-- the player doesn't sit through two full turn cycles wondering when
-- the portal re-prompts.
local OW_PORTAL_DELAY_TURNS = 5
local VCO_DELAY_LISTENER_NAME = "vco_vmp_man_dilemma_trigger_delay"

-- Count books via VCO's saved-value naming (vco_<faction>_book_<N>_-
-- collected). VCO's own vco-listeners-vmp.lua already increments these
-- on each book mission via vlc.nagash_books:add — by reading the same
-- keys we automatically inherit prior progress in v1.1.1 saves
-- continued under v1.2.0+, and stay in sync with VCO going forward.
local function count_collected_books()
    local n = 0
    for i = 1, MAX_BOOKS do
        if cm:get_saved_value("vco_" .. FACTION_MAN_KEY .. "_book_" .. i .. "_collected") then
            n = n + 1
        end
    end
    return n
end

-- Apply the text/completion to whichever slot the SCRIPTED objective
-- actually lives in. New campaigns: objective is in long_victory.
-- v1.1.1 carry-over saves: objective is in domination_victory. Each
-- call is a no-op when the slot doesn't contain the objective, so
-- firing both is safe.
local function refresh_books_text(count_key)
    cm:set_scripted_mission_text(OW_MISSION_KEY_NEW, SCRIPT_KEY, TEXT_PREFIX .. count_key)
    cm:set_scripted_mission_text(OW_MISSION_KEY_OLD, SCRIPT_KEY, TEXT_PREFIX .. count_key)
end

local function complete_books_objective()
    cm:complete_scripted_mission_objective(FACTION_MAN_KEY, OW_MISSION_KEY_NEW, SCRIPT_KEY, true)
    cm:complete_scripted_mission_objective(FACTION_MAN_KEY, OW_MISSION_KEY_OLD, SCRIPT_KEY, true)
end

local function pow_ext_vmp_man_main()
    cm:add_first_tick_callback(function()
        ------------------------------------------------------------
        -- Books of Nagash counter
        ------------------------------------------------------------
        -- Proactive text refresh on every first-tick (new game AND
        -- save load). For v1.1.1 saves the baked override_text is
        -- VCO's "Collect ALL the Books" — without this, the player
        -- would see that stale text until they next complete a book
        -- mission. Refreshing here updates the display to our
        -- "Collect 5 Books. (X/5)" immediately, using the count VCO
        -- already tracked.
        local local_faction = cm:get_local_faction_name(true)
        if local_faction == FACTION_MAN_KEY
            and not cm:get_saved_value("pow_ext_vmp_man_nagash_books_complete")
        then
            local count = count_collected_books()
            if count < THRESHOLD then
                refresh_books_text(tostring(count))
            else
                refresh_books_text("complete")
                complete_books_objective()
                cm:set_saved_value("pow_ext_vmp_man_nagash_books_complete", true)
            end
        end

        core:add_listener(
            "pow_ext_vmp_man_nagash_books",
            "MissionSucceeded",
            function(context)
                if cm:get_saved_value("pow_ext_vmp_man_nagash_books_complete") then
                    return false
                end
                if not context:faction():is_human() then return false end
                if context:faction():name() ~= FACTION_MAN_KEY then return false end
                local mk = context:mission():mission_record_key()
                return mk:sub(1, 26) == "wh2_dlc09_books_of_nagash_"
            end,
            function(context)
                -- Idempotent write to VCO's saved-value key. VCO's
                -- listener also writes this (via vlc.nagash_books:add),
                -- but listener fire order isn't guaranteed; writing
                -- here ensures count_collected_books() sees this book
                -- regardless of which listener ran first.
                local mk = context:mission():mission_record_key()
                local book_number = tonumber(mk:sub(-1))
                if book_number then
                    cm:set_saved_value(
                        "vco_" .. FACTION_MAN_KEY .. "_book_" .. book_number .. "_collected",
                        true
                    )
                end
                local count = count_collected_books()
                if count < THRESHOLD then
                    refresh_books_text(tostring(count))
                else
                    refresh_books_text("complete")
                    complete_books_objective()
                    cm:set_saved_value("pow_ext_vmp_man_nagash_books_complete", true)
                end
            end,
            true
        )

        ------------------------------------------------------------
        -- Ossified Portal override (Route 1)
        ------------------------------------------------------------
        -- IMPORTANT load-order note: our pack loads BEFORE VCO's
        -- alphabetically (pow_a_... < victory_conditions_overhaul),
        -- so our first_tick_callback runs first, our listener
        -- registers first, and we fire FIRST on
        -- DilemmaChoiceMadeEvent. VCO's handler then runs after ours
        -- and overwrites whatever we did (teleports to IE coords,
        -- registers the 10-turn delay listener).
        --
        -- Workaround: wrap our override in cm:callback with a small
        -- real-time delay so our work happens AFTER the synchronous
        -- event handlers complete. Then our teleport / listener-
        -- removal lands last.
        core:add_listener(
            "pow_ext_vmp_man_ossified_portal_override",
            "DilemmaChoiceMadeEvent",
            function(context)
                return context:dilemma() == OSSIFIED_DILEMMA_KEY
            end,
            function(context)
                local choice = context:choice()
                cm:callback(function()
                    local faction = cm:get_faction(FACTION_MAN_KEY)
                    if not faction or faction:is_null_interface() then return end
                    local leader = faction:faction_leader()
                    if not leader or leader:is_null_interface() then return end

                    if choice == 0 then
                        -- Override VCO's IE-coord teleport with the OW
                        -- spot in the Sylvania area. By now VCO has
                        -- already teleported to (666, 580); we re-
                        -- teleport to the correct spot.
                        cm:teleport_to(
                            cm:char_lookup_str(leader),
                            OW_PORTAL_X, OW_PORTAL_Y
                        )
                    elseif choice == 1 then
                        -- VCO just registered a one-shot
                        -- FactionTurnStart listener with a 10-turn
                        -- delay. Remove it and register ours with a
                        -- shorter delay so the player doesn't wait
                        -- two-thirds of a turn cycle for the next
                        -- portal prompt.
                        core:remove_listener(VCO_DELAY_LISTENER_NAME)
                        local target_turn_number =
                            cm:turn_number() + OW_PORTAL_DELAY_TURNS
                        core:add_listener(
                            "pow_ext_vmp_man_portal_delay_t" .. cm:turn_number(),
                            "FactionTurnStart",
                            function(c)
                                return c:faction():is_human() and
                                    c:faction():name() == FACTION_MAN_KEY and
                                    cm:turn_number() == target_turn_number
                            end,
                            function()
                                cm:trigger_dilemma(
                                    FACTION_MAN_KEY, OSSIFIED_DILEMMA_KEY
                                )
                            end,
                            false
                        )
                    end
                    -- choice 2 = decline forever: no override (matches
                    -- VCO's silent no-op).
                end, 0.1)
            end,
            true
        )
    end)
end

pow_ext_vmp_man_main();
