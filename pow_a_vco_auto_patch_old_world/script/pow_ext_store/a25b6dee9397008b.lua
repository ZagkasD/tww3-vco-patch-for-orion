
local function log_fr(msg)
    if ModLog then ModLog("[POW_EXT_FACTION_REGIONS] " .. tostring(msg)) end
end

local function active_campaign()
    if pow_ext and pow_ext.is_classic_campaign and pow_ext.is_classic_campaign() then
        return "classic"
    end
    return "main"
end

local function sv_count_key(sk) return "pow_ext_framework_factionregions_count_" .. sk end
local function sv_done_key(sk)  return "pow_ext_framework_factionregions_done_" .. sk end

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

local function sum_region_count(target_faction_keys)
    local total = 0
    for _, fk in ipairs(target_faction_keys) do
        local ok, fac = pcall(function() return cm:get_faction(fk) end)
        if ok and fac then
            local ok_n, isnull = pcall(function() return fac:is_null_interface() end)
            if ok_n and not isnull then
                local ok_r, region_list = pcall(function() return fac:region_list() end)
                if ok_r and region_list then
                    local ok_c, n = pcall(function() return region_list:num_items() end)
                    if ok_c and n then total = total + n end
                end
            end
        end
    end
    return total
end

local function key_in_list(needle, list)
    if not needle or not list then return false end
    for _, v in ipairs(list) do
        if v == needle then return true end
    end
    return false
end

local function complete_entry(faction_key, entry)
    cm:set_saved_value(sv_done_key(entry.script_key), true)
    cm:complete_scripted_mission_objective(
        faction_key, entry.mission_key, entry.script_key, true
    )
    if pow_ext_fire_on_complete then
        pow_ext_fire_on_complete(faction_key, entry.script_key, entry.on_complete)
    end
end

local function pow_ext_count_faction_regions_main()
        if not (pow_ext_config and pow_ext_config.count_faction_regions) then
            log_fr("no pow_ext_config.count_faction_regions table; skipping")
            return
        end
        local campaign = active_campaign()

        local active_by_faction = {}
        local entry_count, faction_count = 0, 0
        local skipped_ai, skipped_covered = 0, 0
        for faction, by_campaign in pairs(pow_ext_config.count_faction_regions) do
            local entries = by_campaign[campaign]
            if entries then
                if pow_ext.active_factions[faction] then
                    active_by_faction[faction] = entries
                    faction_count = faction_count + 1
                    for _, entry in ipairs(entries) do
                        entry_count = entry_count + 1
                        local current = sum_region_count(entry.target_faction_keys)
                        cm:set_saved_value(sv_count_key(entry.script_key), current)
                        refresh_text(entry, current)
                        if not cm:get_saved_value(sv_done_key(entry.script_key))
                            and current >= entry.total then
                            complete_entry(faction, entry)
                        end
                    end
                end
            end
        end

        if next(active_by_faction) == nil then
            log_fr("no active COUNT_FACTION_REGIONS entries for " .. campaign
                .. " (skipped " .. tostring(skipped_ai) .. " AI, "
                .. tostring(skipped_covered) .. " covered faction(s))")
            return
        end

        log_fr(string.format(
            "registered %d region counter(s) across %d faction(s) for %s (skipped %d AI, %d covered faction(s))",
            entry_count, faction_count, campaign, skipped_ai, skipped_covered
        ))

        core:add_listener(
            "pow_ext_framework_count_faction_regions",
            "RegionFactionChangeEvent",
            function(context)
                return true
            end,
            function(context)
                local ok_r, region = pcall(function() return context:region() end)
                if not ok_r or not region then return end
                local ok_n, isnull = pcall(function() return region:is_null_interface() end)
                if not ok_n or isnull then return end
                local new_owner_key, prev_owner_key
                local ok_o, owner = pcall(function() return region:owning_faction() end)
                if ok_o and owner and not owner:is_null_interface() then
                    new_owner_key = owner:name()
                end
                local ok_p, prev = pcall(function() return context:previous_faction() end)
                if ok_p and prev and not prev:is_null_interface() then
                    prev_owner_key = prev:name()
                end

                for faction_key, entries in pairs(active_by_faction) do
                    for _, entry in ipairs(entries) do
                        if not cm:get_saved_value(sv_done_key(entry.script_key)) then
                            local is_relevant = key_in_list(new_owner_key, entry.target_faction_keys)
                                or key_in_list(prev_owner_key, entry.target_faction_keys)
                            if is_relevant then
                                local current = sum_region_count(entry.target_faction_keys)
                                local prev_count = cm:get_saved_value(sv_count_key(entry.script_key)) or 0
                                if current ~= prev_count then
                                    cm:set_saved_value(sv_count_key(entry.script_key), current)
                                    log_fr(string.format(
                                        "COUNTED faction=%s sk=%s -> %d / %d",
                                        faction_key, entry.script_key, current, entry.total
                                    ))
                                    refresh_text(entry, current)
                                    if current >= entry.total then
                                        log_fr(string.format(
                                            "threshold reached %s/%s on %s",
                                            faction_key, entry.script_key, entry.mission_key
                                        ))
                                        complete_entry(faction_key, entry)
                                    end
                                end
                            end
                        end
                    end
                end
            end,
            true
        )
end

log_fr("listener loaded")
pow_ext_count_faction_regions_main();
