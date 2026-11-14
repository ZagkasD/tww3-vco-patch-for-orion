
local function log_cm(msg)
    if ModLog then ModLog("[POW_EXT_COMPLETE_N] " .. tostring(msg)) end
end

local function active_campaign()
    if pow_ext and pow_ext.is_classic_campaign and pow_ext.is_classic_campaign() then
        return "classic"
    end
    return "main"
end

local function sv_count_key(sk) return "pow_ext_framework_completen_count_" .. sk end
local function sv_done_key(sk)  return "pow_ext_framework_completen_done_" .. sk end

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

local function pow_ext_complete_n_missions_main()
        if not (pow_ext_config and pow_ext_config.complete_n_missions) then
            log_cm("no pow_ext_config.complete_n_missions table; skipping")
            return
        end
        local campaign = active_campaign()

        local active_by_faction = {}
        local entry_count, faction_count = 0, 0
        local skipped_ai, skipped_covered = 0, 0
        for faction, by_campaign in pairs(pow_ext_config.complete_n_missions) do
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
            log_cm("no active COMPLETE_N_MISSIONS entries for " .. campaign
                .. " (skipped " .. tostring(skipped_ai) .. " AI, "
                .. tostring(skipped_covered) .. " covered faction(s))")
            return
        end

        log_cm(string.format(
            "registered %d mission counter(s) across %d faction(s) for %s (skipped %d AI, %d covered faction(s))",
            entry_count, faction_count, campaign, skipped_ai, skipped_covered
        ))

        core:add_listener(
            "pow_ext_framework_complete_n_missions",
            "MissionSucceeded",
            function(context)
                local ok_f, fac = pcall(function() return context:faction() end)
                if not ok_f or not fac then return false end
                local faction_key = fac:name()
                local entries = active_by_faction[faction_key]
                if not entries then return false end
                local ok_m, mission = pcall(function() return context:mission() end)
                if not ok_m or not mission then return false end
                local ok_mk, mk = pcall(function() return mission:mission_record_key() end)
                if not ok_mk or not mk then return false end
                for _, entry in ipairs(entries) do
                    if not cm:get_saved_value(sv_done_key(entry.script_key)) then
                        for _, want in ipairs(entry.mission_keys) do
                            if want == mk then return true end
                        end
                    end
                end
                return false
            end,
            function(context)
                local fac = context:faction()
                local faction_key = fac:name()
                local mk = context:mission():mission_record_key()
                local entries = active_by_faction[faction_key]
                if not entries then return end
                for _, entry in ipairs(entries) do
                    if not cm:get_saved_value(sv_done_key(entry.script_key)) then
                        local matched = false
                        for _, want in ipairs(entry.mission_keys) do
                            if want == mk then matched = true; break end
                        end
                        if matched then
                            local count = (cm:get_saved_value(sv_count_key(entry.script_key)) or 0) + 1
                            if count > entry.total then count = entry.total end
                            cm:set_saved_value(sv_count_key(entry.script_key), count)
                            log_cm(string.format(
                                "COUNTED faction=%s sk=%s mission=%s -> %d / %d",
                                faction_key, entry.script_key, mk, count, entry.total
                            ))
                            refresh_text(entry, count)
                            if count >= entry.total then
                                log_cm(string.format(
                                    "threshold reached %s/%s on %s",
                                    faction_key, entry.script_key, entry.mission_key
                                ))
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

log_cm("listener loaded")
pow_ext_complete_n_missions_main();
