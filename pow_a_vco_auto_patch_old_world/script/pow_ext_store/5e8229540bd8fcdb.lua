-- __pow_ext_runtime.lua
-- Shared runtime support for pow-<race>-extended loader stubs.
--
-- Wraps cm:trigger_custom_mission_from_string so that any other mod's
-- victory-mission triggers are recorded per-faction. Loader stubs query
-- pow_ext.has_external_coverage(faction) to decide whether another mod
-- has already supplied victory content (in which case we silently stand
-- aside) or whether the faction is ours to cover.
--
-- This replaces the previous file-existence-based deference check, which
-- gave false positives for races whose POW loader entry-point is
-- commented out (e.g. pow_skv_main(), pow_dwf_main(), pow_lzd_main()) —
-- their per-LL missions.lua files exist in the POW pack but are never
-- actually loaded at runtime, so deferring to them suppressed our
-- content for factions POW doesn't really cover.
--
-- Also stamps the mod version on every new-game save via the
-- pow_ext_mod_version_at_start saved-value. Listener code can read
-- this later to branch on save-shape when a release introduces
-- listener-affecting content changes that aren't resolvable via the
-- "fire on both old/new shapes" resilience pattern alone.

pow_ext = pow_ext or {}
pow_ext.external_triggers = pow_ext.external_triggers or {}
pow_ext.our_triggered = pow_ext.our_triggered or {}
pow_ext.notified = pow_ext.notified or {}
pow_ext._calling_self = pow_ext._calling_self or false
pow_ext.mod_version = "1.2.0"

local function pow_ext_log(msg)
    if ModLog then ModLog("[POW_EXT] " .. tostring(msg)) end
end
pow_ext.log = pow_ext_log

pow_ext_log("__pow_ext_runtime.lua sourcing")

-- Install the wrap via cm:add_first_tick_callback (shared queue, step 4 of
-- process_first_tick_callbacks). This is AFTER step 2 (sp_new/mp_new), where
-- OW's vanilla wincons fire via victory_objectives.lua line 5142
-- (cm:add_first_tick_callback_new). So by installing in step 4, our wrap
-- never sees vanilla CA wincon triggers — only POW's post_first_tick
-- triggers in step 5 (and anyone else who triggers after).
--
-- Installing here (not at module-source time) means we don't need a content
-- filter to distinguish mod-driven from vanilla triggers. The signal is
-- naturally clean: anything our wrap records is post-vanilla-init.

if cm and cm.add_first_tick_callback then
    cm:add_first_tick_callback(function()
        -- Install the wrap (idempotent — see the wrap install
        -- discussion at the top of this file).
        if not pow_ext.wrap_installed
            and cm and cm.trigger_custom_mission_from_string
        then
            pow_ext.wrap_installed = true
            pow_ext_log("wrap installed (first-tick)")
            local _orig = cm.trigger_custom_mission_from_string
            cm.trigger_custom_mission_from_string = function(self, faction_key, ...)
                if not pow_ext._calling_self then
                    pow_ext.external_triggers[faction_key] =
                        (pow_ext.external_triggers[faction_key] or 0) + 1
                end
                return _orig(self, faction_key, ...)
            end
        end

        -- Stamp the mod version on every NEW campaign save.
        -- cm:is_new_game() returns false on save-load, so existing
        -- v1.1.1 (pre-stamp) saves never set this; listener code
        -- treating "missing stamp" as "pre-1.2.0" is the convention.
        if cm:is_new_game()
            and not cm:get_saved_value("pow_ext_mod_version_at_start")
        then
            cm:set_saved_value("pow_ext_mod_version_at_start", pow_ext.mod_version)
            pow_ext_log("stamped pow_ext_mod_version_at_start = " .. pow_ext.mod_version)
        end
    end)
end

function pow_ext.has_external_coverage(faction_key)
    return (pow_ext.external_triggers[faction_key] or 0) > 0
end

function pow_ext.trigger_our_missions(faction_key, missions)
    if pow_ext.our_triggered[faction_key] then return end
    pow_ext.our_triggered[faction_key] = true
    pow_ext._calling_self = true
    pow_ext_log("trigger_our_missions(" .. tostring(faction_key) ..
        "): firing " .. tostring(#missions) .. " missions")
    for _, mission in ipairs(missions) do
        if mission and mission ~= "" then
            cm:trigger_custom_mission_from_string(faction_key, mission)
        end
    end
    pow_ext._calling_self = false
end
