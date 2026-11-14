
local function log_wi(msg)
    if ModLog then ModLog("[POW_EXT_WATCH_INCIDENT] " .. tostring(msg)) end
end

local function log_hook(msg)
    if ModLog then ModLog("[POW_EXT_HOOK] " .. tostring(msg)) end
end

local function active_campaign()
    if pow_ext and pow_ext.is_classic_campaign and pow_ext.is_classic_campaign() then
        return "classic"
    end
    return "main"
end

local function sv_count_key(sk)  return "pow_ext_framework_watchinc_count_" .. sk end
local function sv_done_key(sk)   return "pow_ext_framework_watchinc_done_" .. sk end
local function sv_hook_fired(sk) return "pow_ext_framework_watchinc_hook_" .. sk end

local function dispatch_trigger(faction_key, trigger_type, key, delay_s)
    if trigger_type == "DILEMMA" then
        cm:callback(function()
            cm:trigger_dilemma(faction_key, key)
        end, delay_s)
    elseif trigger_type == "MISSION" then
        cm:callback(function()
            cm:trigger_mission(faction_key, key, true)
        end, delay_s)
    elseif trigger_type == "INCIDENT" then
        cm:callback(function()
            cm:trigger_incident(faction_key, key, true, true)
        end, delay_s)
    else
        log_hook(string.format(
            "WARN: unknown on_complete trigger type=%s key=%s (faction=%s) — skipped",
            tostring(trigger_type), tostring(key), faction_key
        ))
    end
end

function pow_ext_fire_on_complete(faction_key, script_key, triggers)
    if not triggers or #triggers == 0 then return end
    if cm:get_saved_value(sv_hook_fired(script_key)) then return end
    cm:set_saved_value(sv_hook_fired(script_key), true)
    for i, item in ipairs(triggers) do
        local delay_s = 0.1 * i
        log_hook(string.format(
            "fire: faction=%s sk=%s trigger[%d/%d]=%s key=%s (deferred %.1fs)",
            faction_key, script_key, i, #triggers,
            tostring(item.type), tostring(item.key), delay_s
        ))
        dispatch_trigger(faction_key, item.type, item.key, delay_s)
    end
end

local function refresh_text(entry, count)
    if count > entry.total then count = entry.total end
    if not entry.complete_loc_key then
        return
    end
    local key
    if count >= entry.total then
        key = entry.complete_loc_key
    else
        key = entry.text_prefix .. "_" .. tostring(count)
    end
    pcall(function()
        cm:set_scripted_mission_text(entry.mission_key, entry.script_key, key)
    end)
end

local function pow_ext_watch_incident_main()
        if not (pow_ext_config and pow_ext_config.watch_incident) then
            log_wi("no pow_ext_config.watch_incident table; skipping")
            return
        end
        local campaign = active_campaign()

        local active_by_faction = {}
        local entry_count, faction_count, skipped_ai, skipped_covered = 0, 0, 0, 0
        for faction, by_campaign in pairs(pow_ext_config.watch_incident) do
            local entries = by_campaign[campaign]
            if entries then
                if pow_ext.active_factions[faction] then
                    active_by_faction[faction] = entries
                    faction_count = faction_count + 1
                    for _, entry in ipairs(entries) do
                        entry_count = entry_count + 1
                        local existing = cm:get_saved_value(sv_count_key(entry.script_key)) or 0
                        refresh_text(entry, existing)
                        if not cm:get_saved_value(sv_done_key(entry.script_key))
                            and existing >= entry.total then
                            cm:set_saved_value(sv_done_key(entry.script_key), true)
                            cm:complete_scripted_mission_objective(
                                faction, entry.mission_key, entry.script_key, true
                            )
                            pow_ext_fire_on_complete(faction, entry.script_key, entry.on_complete)
                        end
                    end
                end
            end
        end

        if next(active_by_faction) == nil then
            log_wi("no active WATCH_INCIDENT entries for " .. campaign
                .. " (skipped " .. tostring(skipped_ai) .. " AI, "
                .. tostring(skipped_covered) .. " covered faction(s))")
            return
        end

        log_wi(string.format(
            "registered %d incident watcher(s) across %d faction(s) for %s (skipped %d AI, %d covered faction(s))",
            entry_count, faction_count, campaign, skipped_ai, skipped_covered
        ))

        core:add_listener(
            "pow_ext_framework_watch_incident",
            "IncidentOccuredEvent",
            function(context)
                local ok_f, fac = pcall(function() return context:faction() end)
                if not ok_f or not fac then return false end
                local faction_key = fac:name()
                local entries = active_by_faction[faction_key]
                if not entries then return false end
                local ok_k, inc_key = pcall(function() return context:dilemma() end)
                if not ok_k or not inc_key then return false end
                for _, entry in ipairs(entries) do
                    if not cm:get_saved_value(sv_done_key(entry.script_key)) then
                        for _, want in ipairs(entry.incident_keys) do
                            if want == inc_key then return true end
                        end
                    end
                end
                return false
            end,
            function(context)
                local fac = context:faction()
                local faction_key = fac:name()
                local inc_key = context:dilemma()
                local entries = active_by_faction[faction_key]
                if not entries then return end
                for _, entry in ipairs(entries) do
                    if not cm:get_saved_value(sv_done_key(entry.script_key)) then
                        local matched = false
                        for _, want in ipairs(entry.incident_keys) do
                            if want == inc_key then matched = true; break end
                        end
                        if matched then
                            local count = (cm:get_saved_value(sv_count_key(entry.script_key)) or 0) + 1
                            if count > entry.total then count = entry.total end
                            cm:set_saved_value(sv_count_key(entry.script_key), count)
                            log_wi(string.format(
                                "COUNTED faction=%s sk=%s inc=%s -> %d / %d",
                                faction_key, entry.script_key, inc_key, count, entry.total
                            ))
                            refresh_text(entry, count)
                            if count >= entry.total then
                                cm:set_saved_value(sv_done_key(entry.script_key), true)
                                cm:complete_scripted_mission_objective(
                                    faction_key, entry.mission_key, entry.script_key, true
                                )
                                pow_ext_fire_on_complete(faction_key, entry.script_key, entry.on_complete)
                            end
                        end
                    end
                end
            end,
            true
        )
end

log_wi("listener loaded")
pow_ext_watch_incident_main();
