
local function log_rp(msg)
    if ModLog then ModLog("[POW_EXT_ROUTE_PREREQ] " .. tostring(msg)) end
end

local function active_campaign()
    if pow_ext and pow_ext.is_classic_campaign and pow_ext.is_classic_campaign() then
        return "classic"
    end
    return "main"
end

local function sv_forwarded_key(faction, prereq_mission_key)
    return "pow_ext_framework_route_prereq_done_" .. faction .. "_" .. prereq_mission_key
end

local function route_oc_script_key(faction_key, mission_key)
    return "pow_ext_framework_route_oc_" .. faction_key .. "_" .. mission_key
end

local function pow_ext_route_prereq_main()
        local has_prereqs = pow_ext_config and pow_ext_config.route_prereqs
        local has_route_oc = pow_ext_config and pow_ext_config.route_on_complete
        if not (has_prereqs or has_route_oc) then
            log_rp("no pow_ext_config.route_prereqs or route_on_complete table; skipping")
            return
        end
        local campaign = active_campaign()

        local function classify(faction_key)
            if pow_ext.active_factions[faction_key] then return true, nil end
            return false, "covered"
        end

        local active_factions = {}
        local prereq_entries, prereq_factions = 0, 0
        local skipped_prereq_ai, skipped_prereq_covered = 0, 0
        if has_prereqs then
            for faction, by_campaign in pairs(pow_ext_config.route_prereqs) do
                local by_prereq = by_campaign[campaign]
                if by_prereq then
                    local active, reason = classify(faction)
                    if active then
                        active_factions[faction] = by_prereq
                        prereq_factions = prereq_factions + 1
                        for _ in pairs(by_prereq) do prereq_entries = prereq_entries + 1 end
                    elseif reason == "ai" then
                        skipped_prereq_ai = skipped_prereq_ai + 1
                    elseif reason == "covered" then
                        skipped_prereq_covered = skipped_prereq_covered + 1
                    end
                end
            end
        end

        local route_oc_by_faction = {}
        local oc_entries, oc_factions = 0, 0
        local skipped_oc_ai, skipped_oc_covered = 0, 0
        if has_route_oc then
            for faction, by_campaign in pairs(pow_ext_config.route_on_complete) do
                local by_mission = by_campaign[campaign]
                if by_mission then
                    local active, reason = classify(faction)
                    if active then
                        route_oc_by_faction[faction] = by_mission
                        oc_factions = oc_factions + 1
                        for _ in pairs(by_mission) do oc_entries = oc_entries + 1 end
                    elseif reason == "ai" then
                        skipped_oc_ai = skipped_oc_ai + 1
                    elseif reason == "covered" then
                        skipped_oc_covered = skipped_oc_covered + 1
                    end
                end
            end
        end

        local total_skipped_ai = skipped_prereq_ai + skipped_oc_ai
        local total_skipped_covered = skipped_prereq_covered + skipped_oc_covered

        if next(active_factions) == nil and next(route_oc_by_faction) == nil then
            log_rp("no active forwarders or route hooks for " .. campaign
                .. " (skipped " .. tostring(total_skipped_ai) .. " AI, "
                .. tostring(total_skipped_covered) .. " covered faction-entries)")
            return
        end

        log_rp(string.format(
            "registered %d prereq forwarder(s) across %d faction(s) + %d route on_complete hook(s) across %d faction(s) for %s (skipped %d AI, %d covered faction-entries)",
            prereq_entries, prereq_factions, oc_entries, oc_factions, campaign,
            total_skipped_ai, total_skipped_covered
        ))

        core:add_listener(
            "pow_ext_framework_route_prereq_succeeded",
            "MissionSucceeded",
            function(context)
                local faction_key = context:faction():name()
                local mk = context:mission():mission_record_key()
                local oc_by_mission = route_oc_by_faction[faction_key]
                if oc_by_mission and oc_by_mission[mk] then
                    return true
                end
                local by_prereq = active_factions[faction_key]
                if by_prereq and by_prereq[mk]
                    and not cm:get_saved_value(sv_forwarded_key(faction_key, mk)) then
                    return true
                end
                return false
            end,
            function(context)
                local faction_key = context:faction():name()
                local mk = context:mission():mission_record_key()
                local oc_by_mission = route_oc_by_faction[faction_key]
                local oc_entry = oc_by_mission and oc_by_mission[mk]
                if oc_entry and pow_ext_fire_on_complete then
                    pow_ext_fire_on_complete(
                        faction_key,
                        route_oc_script_key(faction_key, mk),
                        oc_entry
                    )
                end
                local by_prereq = active_factions[faction_key]
                local entry = by_prereq and by_prereq[mk]
                if entry and not cm:get_saved_value(sv_forwarded_key(faction_key, mk)) then
                    log_rp(string.format(
                        "forwarded faction=%s prereq=%s -> completing %s on %s",
                        faction_key, mk, entry.script_key, entry.later_mission_key
                    ))
                    cm:set_saved_value(sv_forwarded_key(faction_key, mk), true)
                    cm:complete_scripted_mission_objective(
                        faction_key, entry.later_mission_key, entry.script_key, true
                    )
                end
            end,
            true
        )
end

log_rp("listener loaded")
pow_ext_route_prereq_main();
