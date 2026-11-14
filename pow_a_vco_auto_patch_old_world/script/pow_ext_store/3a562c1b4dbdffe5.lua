
local function log_kn(msg)
    if ModLog then ModLog("[POW_EXT_KILL_N] " .. tostring(msg)) end
end

local function emit_slot_check(data) pow_ext_diag.emit("kill_n", "slot_check", data) end
local function emit_agent_action_seen(data) pow_ext_diag.emit("kill_n", "agent_action_seen", data) end

local function find_faction_side(faction_key)
    local n_atk = cm:pending_battle_cache_num_attackers()
    for i = 1, n_atk do
        if cm:pending_battle_cache_get_attacker_faction_name(i) == faction_key then
            return "attacker"
        end
    end
    local n_def = cm:pending_battle_cache_num_defenders()
    for i = 1, n_def do
        if cm:pending_battle_cache_get_defender_faction_name(i) == faction_key then
            return "defender"
        end
    end
    return nil
end

local function read_fm_state(fm)
    local s = {
        present = fm ~= nil,
        subtype = nil, culture = nil, subculture = nil,
        is_unique = false, is_faction_leader = false, is_commanding_army = false,
    }
    if not s.present then return s end
    local ok, d = pcall(function() return fm:character_details() end)
    if ok and d then
        local oku, u = pcall(function() return d:is_unique() end)
        if oku then s.is_unique = u end
    end
    local okc, char = pcall(function() return fm:character() end)
    if okc and char then
        local okn, isnull = pcall(function() return char:is_null_interface() end)
        if okn and not isnull then
            local okfl, fl = pcall(function() return char:is_faction_leader() end)
            if okfl then s.is_faction_leader = fl end
            local okca, ca = pcall(function() return char:has_military_force() end)
            if okca then s.is_commanding_army = ca end
            local okst, st = pcall(function() return char:character_subtype_key() end)
            if okst then s.subtype = st end
            local okf, fac = pcall(function() return char:faction() end)
            if okf and fac then
                local okfn, fn = pcall(function() return fac:is_null_interface() end)
                if okfn and not fn then
                    local okcc, c = pcall(function() return fac:culture() end)
                    if okcc then s.culture = c end
                    local oksc, sc = pcall(function() return fac:subculture() end)
                    if oksc then s.subculture = sc end
                end
            end
        end
    end
    return s
end

local function list_contains(list, key)
    if not list then return false end
    for _, v in ipairs(list) do if v == key then return true end end
    return false
end

local function fm_passes_match(fm_state, match, ll_set)
    if not match then return true, nil end
    if match.agent_subtypes and not list_contains(match.agent_subtypes, fm_state.subtype) then
        return false, "agent_subtypes"
    end
    if match.legendary_lord then
        local in_set = fm_state.subtype and ll_set and ll_set[fm_state.subtype] == true
        if not in_set then return false, "legendary_lord" end
    end
    if match.named and not fm_state.is_unique then return false, "named" end
    if match.faction_leader and not fm_state.is_faction_leader then return false, "faction_leader" end
    if match.general and not fm_state.is_commanding_army then return false, "general" end
    if match.culture and not list_contains(match.culture, fm_state.culture) then
        return false, "culture"
    end
    if match.subculture and not list_contains(match.subculture, fm_state.subculture) then
        return false, "subculture"
    end
    return true, nil
end

local function entry_accepts_path(entry, path)
    if not entry.kill_via or #entry.kill_via == 0 then return true end
    return list_contains(entry.kill_via, path)
end

local function sv_count_key(sk)     return "pow_ext_framework_kill_count_" .. sk end
local function sv_done_key(sk)      return "pow_ext_framework_kill_done_" .. sk end
local function sv_seen_fms_key(sk)  return "pow_ext_framework_kill_seen_fms_" .. sk end
local function sv_seen_sub_key(sk)  return "pow_ext_framework_kill_seen_subtypes_" .. sk end

local function active_campaign()
    if pow_ext and pow_ext.is_classic_campaign and pow_ext.is_classic_campaign() then
        return "classic"
    end
    return "main"
end

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


local function classify_kill(entry, fm_state, kill_via_path, ll_set)
    if not entry_accepts_path(entry, kill_via_path) then
        return "SKIP_KILL_VIA", nil
    end
    if not fm_state.present then
        return "SKIP", nil
    end
    local pass, failed = fm_passes_match(fm_state, entry.match, ll_set)
    if not pass then
        return "FAIL", failed
    end
    return "PASS_PROVISIONAL", nil
end

local function check_dedup(entry, fm_cqi, fm_state)
    local allow_respawn = entry.match and entry.match.allow_respawn
    if not allow_respawn then
        local seen_fms = cm:get_saved_value(sv_seen_fms_key(entry.script_key)) or {}
        if seen_fms[tostring(fm_cqi)] then
            return "DEDUP_FM"
        end
    end
    local match_has_dedup = entry.match and entry.match.dedup
    if match_has_dedup and fm_state.subtype then
        local seen_subtypes = cm:get_saved_value(sv_seen_sub_key(entry.script_key)) or {}
        if seen_subtypes[fm_state.subtype] then
            return "DEDUP_SUBTYPE"
        end
    end
    return nil
end

local function apply_pass(faction_key, entry, slot_idx, fm_cqi, fm_state, kill_via_path)
    local allow_respawn = entry.match and entry.match.allow_respawn
    if not allow_respawn then
        local seen_fms = cm:get_saved_value(sv_seen_fms_key(entry.script_key)) or {}
        seen_fms[tostring(fm_cqi)] = true
        cm:set_saved_value(sv_seen_fms_key(entry.script_key), seen_fms)
    end
    local seen_subtypes = cm:get_saved_value(sv_seen_sub_key(entry.script_key)) or {}
    local match_has_dedup = entry.match and entry.match.dedup
    if match_has_dedup and fm_state.subtype then
        seen_subtypes[fm_state.subtype] = true
    end
    local count = cm:get_saved_value(sv_count_key(entry.script_key)) or 0
    count = count + 1
    if count > entry.total then count = entry.total end
    cm:set_saved_value(sv_seen_sub_key(entry.script_key), seen_subtypes)
    cm:set_saved_value(sv_count_key(entry.script_key), count)
    refresh_text(entry, count)
    log_kn(string.format(
        "COUNTED %s/%s slot %d via=%s -> %d / %d",
        faction_key, entry.script_key, slot_idx, kill_via_path,
        count, entry.total
    ))
    if count >= entry.total then
        log_kn(string.format(
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

local function attempt_count(faction_key, entry, slot_idx, fm_cqi, fm_state, kill_via_path, ll_set)
    local result, failed_filter = classify_kill(entry, fm_state, kill_via_path, ll_set)
    if result == "PASS_PROVISIONAL" then
        local dedup = check_dedup(entry, fm_cqi, fm_state)
        result = dedup or "PASS"
    end

    emit_slot_check({
        faction = faction_key,
        script_key = entry.script_key,
        slot = slot_idx,
        fm_cqi = fm_cqi,
        subtype = fm_state.subtype,
        culture = fm_state.culture,
        subculture = fm_state.subculture,
        is_unique = fm_state.is_unique,
        is_faction_leader = fm_state.is_faction_leader,
        is_commanding_army = fm_state.is_commanding_army,
        result = result,
        failed_filter = failed_filter,
        kill_via = kill_via_path,
    })

    if result == "PASS" then
        apply_pass(faction_key, entry, slot_idx, fm_cqi, fm_state, kill_via_path)
    end
end

local function process_battle_entry(faction_key, entry, side, ll_set)
    local loser_side = (side == "attacker") and "defender" or "attacker"
    local n_loser = (loser_side == "attacker")
        and cm:pending_battle_cache_num_attackers()
        or cm:pending_battle_cache_num_defenders()

    for i = 1, n_loser do
        local fm_cqi = (loser_side == "attacker")
            and cm:pending_battle_cache_get_attacker_fm_cqi(i)
            or cm:pending_battle_cache_get_defender_fm_cqi(i)
        local fm = cm:get_family_member_by_cqi(fm_cqi)
        local fm_state = read_fm_state(fm)
        attempt_count(faction_key, entry, i, fm_cqi, fm_state, "battle", ll_set)
    end
end

local function process_agent_entry(faction_key, entry, target_fm, target_fm_cqi, ll_set)
    local fm_state = read_fm_state(target_fm)
    attempt_count(faction_key, entry, 1, target_fm_cqi, fm_state, "agent_action", ll_set)
end

local function pow_ext_kill_lords_main()
        if not (pow_ext_config and pow_ext_config.kill_lord_counters) then
            log_kn("no pow_ext_config.kill_lord_counters table; skipping")
            return
        end
        local campaign = active_campaign()
        local ll_set = pow_ext_config.legendary_lord_subtype_set or {}
        local kill_class_set = pow_ext_config.kill_class_agent_actions or {}

        local active_by_faction = {}
        local entry_count, faction_count, skipped_ai, skipped_covered = 0, 0, 0, 0
        for faction, by_campaign in pairs(pow_ext_config.kill_lord_counters) do
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
                            if pow_ext_fire_on_complete then
                                pow_ext_fire_on_complete(faction, entry.script_key, entry.on_complete)
                            end
                        end
                    end
                end
            end
        end

        if next(active_by_faction) == nil then
            log_kn("no active counters for " .. campaign
                .. " (skipped " .. tostring(skipped_ai) .. " AI, "
                .. tostring(skipped_covered) .. " covered faction(s))")
            return
        end

        log_kn(string.format(
            "registered %d kill counter(s) across %d faction(s) for %s (skipped %d AI, %d covered faction(s))",
            entry_count, faction_count, campaign, skipped_ai, skipped_covered
        ))

        core:add_listener(
            "pow_ext_framework_kill_lords_battle",
            "CharacterCompletedBattle",
            function(context)
                local pb = context:pending_battle()
                for faction, entries in pairs(active_by_faction) do
                    for _, entry in ipairs(entries) do
                        if not cm:get_saved_value(sv_done_key(entry.script_key)) then
                            local side = find_faction_side(faction)
                            if side then
                                local won = (side == "attacker") and pb:attacker_won() or pb:defender_won()
                                if won then return true end
                            end
                        end
                    end
                end
                return false
            end,
            function(context)
                local pb = context:pending_battle()
                for faction, entries in pairs(active_by_faction) do
                    for _, entry in ipairs(entries) do
                        if not cm:get_saved_value(sv_done_key(entry.script_key)) then
                            local side = find_faction_side(faction)
                            if side then
                                local won = (side == "attacker") and pb:attacker_won() or pb:defender_won()
                                if won then
                                    process_battle_entry(faction, entry, side, ll_set)
                                end
                            end
                        end
                    end
                end
            end,
            true
        )

        core:add_listener(
            "pow_ext_framework_kill_lords_agent_action",
            "CharacterCharacterTargetAction",
            function(context)
                local ok_c, char = pcall(function() return context:character() end)
                if not ok_c or not char then return false end
                local ok_f, fac = pcall(function() return char:faction() end)
                if not ok_f or not fac then return false end
                local fk = fac:name()
                if not active_by_faction[fk] then return false end
                local ok_ok, ok_v = pcall(function()
                    return context:mission_result_success()
                        or context:mission_result_critial_success()
                end)
                return ok_ok and ok_v == true
            end,
            function(context)
                local ok_c, char = pcall(function() return context:character() end)
                local faction_key = "?"
                if ok_c and char then
                    local ok_f, fac = pcall(function() return char:faction() end)
                    if ok_f and fac then faction_key = fac:name() end
                end
                local ability_key = nil
                local ok_ab, ab = pcall(function() return context:agent_action_key() end)
                if ok_ab then ability_key = ab end
                local is_kill_class = ability_key ~= nil
                    and kill_class_set[ability_key] == true

                local target_fm = nil
                local target_fm_cqi = nil
                local target_subtype = nil
                local target_faction = nil
                local ok_t, tgt_char = pcall(function() return context:target_character() end)
                if ok_t and tgt_char then
                    local ok_n, isnull = pcall(function() return tgt_char:is_null_interface() end)
                    if ok_n and not isnull then
                        local ok_st, st = pcall(function() return tgt_char:character_subtype_key() end)
                        if ok_st then target_subtype = st end
                        local ok_tf, tfac = pcall(function() return tgt_char:faction() end)
                        if ok_tf and tfac then
                            local ok_tfn, tfn = pcall(function() return tfac:name() end)
                            if ok_tfn then target_faction = tfn end
                        end
                        local ok_fm, tfm = pcall(function() return tgt_char:family_member() end)
                        if ok_fm and tfm then
                            target_fm = tfm
                            local ok_cqi, cqi = pcall(function() return tfm:command_queue_index() end)
                            if ok_cqi then target_fm_cqi = cqi end
                        end
                    end
                end

                emit_agent_action_seen({
                    actor_faction = faction_key,
                    ability_key = ability_key,
                    target_subtype = target_subtype,
                    target_faction = target_faction,
                    is_kill_class = is_kill_class,
                })

                if not is_kill_class then return end
                if not target_fm or not target_fm_cqi then return end

                local entries = active_by_faction[faction_key]
                if not entries then return end
                for _, entry in ipairs(entries) do
                    if not cm:get_saved_value(sv_done_key(entry.script_key)) then
                        process_agent_entry(faction_key, entry, target_fm, target_fm_cqi, ll_set)
                    end
                end
            end,
            true
        )
end

log_kn("listener loaded")
pow_ext_kill_lords_main();
