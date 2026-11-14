
local function log_csv(msg)
    if ModLog then ModLog("[POW_EXT_COUNT_SV] " .. tostring(msg)) end
end

local function active_campaign()
    if pow_ext and pow_ext.is_classic_campaign and pow_ext.is_classic_campaign() then
        return "classic"
    end
    return "main"
end

local function sv_done_key(sk) return "pow_ext_framework_csv_done_" .. sk end

local function refresh_text(entry, count)
    if count > entry.total then count = entry.total end
    local key
    if count >= entry.total then
        if not entry.complete_loc_key then return end
        key = entry.complete_loc_key
    else
        key = entry.text_prefix .. "_" .. tostring(count)
    end
    pcall(function()
        cm:set_scripted_mission_text(entry.mission_key, entry.script_key, key)
    end)
end

local function check_entry(faction_key, entry)
    if cm:get_saved_value(sv_done_key(entry.script_key)) then return end
    local count = cm:get_saved_value(entry.saved_value_key) or 0
    refresh_text(entry, count)
    if count >= entry.total then
        log_csv(string.format(
            "threshold reached faction=%s sk=%s sv=%s count=%d/%d",
            faction_key, entry.script_key, entry.saved_value_key, count, entry.total
        ))
        cm:set_saved_value(sv_done_key(entry.script_key), true)
        cm:complete_scripted_mission_objective(
            faction_key, entry.mission_key, entry.script_key, true
        )
        if pow_ext_fire_on_complete then
            pow_ext_fire_on_complete(faction_key, entry.script_key, entry.on_complete)
        end
    end
end

local function pow_ext_count_vanilla_sv_main()
        if not (pow_ext_config and pow_ext_config.count_vanilla_sv) then
            log_csv("no pow_ext_config.count_vanilla_sv table; skipping")
            return
        end
        local campaign = active_campaign()

        local active_by_faction = {}
        local entry_count, faction_count, skipped_ai, skipped_covered = 0, 0, 0, 0
        local hint_listeners = {}

        for faction, by_campaign in pairs(pow_ext_config.count_vanilla_sv) do
            local entries = by_campaign[campaign]
            if entries then
                if pow_ext.active_factions[faction] then
                    active_by_faction[faction] = entries
                    faction_count = faction_count + 1
                    for _, entry in ipairs(entries) do
                        entry_count = entry_count + 1
                        check_entry(faction, entry)
                        if entry.event_hint and entry.event_hint ~= "" then
                            hint_listeners[entry.event_hint] = true
                        end
                    end
                end
            end
        end

        if next(active_by_faction) == nil then
            log_csv("no active COUNT_VANILLA_SAVED_VALUE entries for " .. campaign
                .. " (skipped " .. tostring(skipped_ai) .. " AI, "
                .. tostring(skipped_covered) .. " covered faction(s))")
            return
        end

        log_csv(string.format(
            "registered %d counter(s) across %d faction(s) for %s (skipped %d AI, %d covered faction(s))",
            entry_count, faction_count, campaign, skipped_ai, skipped_covered
        ))

        core:add_listener(
            "pow_ext_framework_count_vanilla_sv_turn",
            "FactionTurnStart",
            function(context)
                local fk = context:faction():name()
                return active_by_faction[fk] ~= nil
            end,
            function(context)
                local fk = context:faction():name()
                local entries = active_by_faction[fk]
                for _, entry in ipairs(entries) do
                    check_entry(fk, entry)
                end
            end,
            true
        )

        for event_name, _ in pairs(hint_listeners) do
            core:add_listener(
                "pow_ext_framework_count_vanilla_sv_evt_" .. event_name,
                event_name,
                function(context)
                    local ok, fac = pcall(function() return context:faction() end)
                    if not ok or not fac then return false end
                    return active_by_faction[fac:name()] ~= nil
                end,
                function(context)
                    local ok, fac = pcall(function() return context:faction() end)
                    if not ok or not fac then return end
                    local fk = fac:name()
                    local entries = active_by_faction[fk]
                    for _, entry in ipairs(entries) do
                        if entry.event_hint == event_name then
                            check_entry(fk, entry)
                        end
                    end
                end,
                true
            )
        end
end

log_csv("listener loaded")
pow_ext_count_vanilla_sv_main();
