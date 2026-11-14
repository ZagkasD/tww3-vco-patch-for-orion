
local function log_cr(msg)
    if ModLog then ModLog("[POW_EXT_CORRUPTION_REGIONS] " .. tostring(msg)) end
end

local function active_campaign()
    if pow_ext and pow_ext.is_classic_campaign and pow_ext.is_classic_campaign() then
        return "classic"
    end
    return "main"
end

local function sv_count_key(sk) return "pow_ext_framework_corruption_count_" .. sk end
local function sv_done_key(sk)  return "pow_ext_framework_corruption_done_" .. sk end

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

local function vco_corruption_helper()
    local vlc = core:get_static_object("vco-lib-commons")
    if vlc and vlc.corruption then return vlc.corruption end
    return nil
end

local function count_dominant_regions(entry)
    local helper = vco_corruption_helper()
    if not helper then return 0 end
    local n = 0
    if entry.regions and #entry.regions > 0 then
        for _, region_key in ipairs(entry.regions) do
            local ok_r, region = pcall(function() return cm:get_region(region_key) end)
            if ok_r and region then
                local ok_n, isnull = pcall(function() return region:is_null_interface() end)
                if ok_n and not isnull then
                    local ok_c, is_highest = pcall(function()
                        return helper:is_corruption_highest_in_region(entry.corruption_key, region)
                    end)
                    if ok_c and is_highest then n = n + 1 end
                end
            end
        end
    else
        local ok_w, world = pcall(function() return cm:model():world() end)
        if not ok_w or not world then return 0 end
        local ok_m, region_manager = pcall(function() return world:region_manager() end)
        if not ok_m or not region_manager then return 0 end
        local ok_l, region_list = pcall(function() return region_manager:region_list() end)
        if not ok_l or not region_list then return 0 end
        local ok_count, total = pcall(function() return region_list:num_items() end)
        if not ok_count or not total then return 0 end
        for i = 0, total - 1 do
            local ok_i, region = pcall(function() return region_list:item_at(i) end)
            if ok_i and region then
                local ok_n, isnull = pcall(function() return region:is_null_interface() end)
                if ok_n and not isnull then
                    local ok_c, is_highest = pcall(function()
                        return helper:is_corruption_highest_in_region(entry.corruption_key, region)
                    end)
                    if ok_c and is_highest then n = n + 1 end
                end
            end
        end
    end
    return n
end

local function check_entry(faction_key, entry)
    if cm:get_saved_value(sv_done_key(entry.script_key)) then return end
    local count = count_dominant_regions(entry)
    local prev = cm:get_saved_value(sv_count_key(entry.script_key)) or 0
    if count ~= prev then
        cm:set_saved_value(sv_count_key(entry.script_key), count)
        log_cr(string.format(
            "COUNTED faction=%s sk=%s -> %d / %d",
            faction_key, entry.script_key, count, entry.total
        ))
        refresh_text(entry, count)
    end
    if count >= entry.total and not cm:get_saved_value(sv_done_key(entry.script_key)) then
        log_cr(string.format(
            "threshold reached %s/%s on %s",
            faction_key, entry.script_key, entry.mission_key
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

local function pow_ext_count_corruption_regions_main()
        if not (pow_ext_config and pow_ext_config.count_corruption_regions) then
            log_cr("no pow_ext_config.count_corruption_regions table; skipping")
            return
        end
        local campaign = active_campaign()

        local active_by_faction = {}
        local entry_count, faction_count = 0, 0
        local skipped_ai, skipped_covered = 0, 0
        for faction, by_campaign in pairs(pow_ext_config.count_corruption_regions) do
            local entries = by_campaign[campaign]
            if entries then
                if pow_ext.active_factions[faction] then
                    active_by_faction[faction] = entries
                    faction_count = faction_count + 1
                    for _, entry in ipairs(entries) do
                        entry_count = entry_count + 1
                        check_entry(faction, entry)
                    end
                end
            end
        end

        if next(active_by_faction) == nil then
            log_cr("no active COUNT_CORRUPTION_REGIONS entries for " .. campaign
                .. " (skipped " .. tostring(skipped_ai) .. " AI, "
                .. tostring(skipped_covered) .. " covered faction(s))")
            return
        end

        log_cr(string.format(
            "registered %d corruption counter(s) across %d faction(s) for %s (skipped %d AI, %d covered faction(s))",
            entry_count, faction_count, campaign, skipped_ai, skipped_covered
        ))

        core:add_listener(
            "pow_ext_framework_count_corruption_regions",
            "FactionTurnStart",
            function(context)
                local ok_f, fac = pcall(function() return context:faction() end)
                if not ok_f or not fac then return false end
                return active_by_faction[fac:name()] ~= nil
            end,
            function(context)
                local fac = context:faction()
                local faction_key = fac:name()
                local entries = active_by_faction[faction_key]
                if not entries then return end
                for _, entry in ipairs(entries) do
                    check_entry(faction_key, entry)
                end
            end,
            true
        )
end

log_cr("listener loaded")
pow_ext_count_corruption_regions_main();
