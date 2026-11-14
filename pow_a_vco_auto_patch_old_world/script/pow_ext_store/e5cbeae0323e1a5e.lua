do
local _pow_ext_orig_aftc = cm.add_first_tick_callback
cm.add_first_tick_callback = function(_self, _fn) _fn() end

local FACTION_DRY_KEY = "wh2_dlc16_wef_drycha"
local UNLIKELY_ALLIANCE_DILEMMA =
    pow_ext_config.dilemmas[FACTION_DRY_KEY]["pow_ext_wef_dry_dilemma_unlikely_alliance"]

local ASRAI_FACTIONS = {
    "wh_dlc05_wef_wood_elves",
    "wh_dlc05_wef_argwylon",
}

local ATHEL_LOREN_REGIONS = {
    "cr_oldworld_region_kings_glade",
    "cr_oldworld_region_waterfall_palace",
}

local CHOICE_HANDLERS = {
    [0] = { subculture = "wh_main_sc_dwf_dwarfs" },
    [1] = { subculture = "wh_main_sc_vmp_vampire_counts" },
    [2] = { subculture = "wh3_main_sc_ogr_ogre_kingdoms" },
    [3] = { subculture = "wh3_main_sc_sla_slaanesh" },
    [4] = { subculture = "wh2_main_sc_def_dark_elves" },
    [5] = { subculture = nil },
}

local function log_dry(msg)
    if ModLog then ModLog("[DRY] " .. tostring(msg)) end
end

local function dry_human()
    local f = cm:get_faction(FACTION_DRY_KEY)
    return f and not f:is_null_interface() and f:is_human()
end

local function collect_subculture_factions(subculture)
    local out = {}
    local faction_list = cm:model():world():faction_list()
    if not faction_list then
        log_dry("collect: no faction_list interface")
        return out
    end
    for i = 0, faction_list:num_items() - 1 do
        local f = faction_list:item_at(i)
        if f and not f:is_null_interface() and not f:is_dead() then
            local sc_ok, sc_val = pcall(function() return f:subculture() end)
            if sc_ok and sc_val == subculture then
                local key = f:name()
                if key ~= FACTION_DRY_KEY then
                    table.insert(out, key)
                end
            end
        end
    end
    return out
end

local function collect_war_pairs(partners)
    local pairs_needed = {}
    for _, partner_key in ipairs(partners) do
        local pf = cm:get_faction(partner_key)
        if pf and not pf:is_null_interface() and not pf:is_dead() then
            for _, asrai_key in ipairs(ASRAI_FACTIONS) do
                local af = cm:get_faction(asrai_key)
                if af and not af:is_null_interface() and not af:is_dead() then
                    local at_war = false
                    local ok = pcall(function() at_war = pf:at_war_with(af) end)
                    if ok and not at_war then
                        table.insert(pairs_needed, { partner = partner_key, asrai = asrai_key })
                    end
                end
            end
        end
    end
    return pairs_needed
end

local function collect_drycha_war_pairs()
    local out = {}
    local drycha = cm:get_faction(FACTION_DRY_KEY)
    if not drycha or drycha:is_null_interface() then return out end
    for _, asrai_key in ipairs(ASRAI_FACTIONS) do
        local af = cm:get_faction(asrai_key)
        if af and not af:is_null_interface() and not af:is_dead() then
            local at_war = false
            local ok = pcall(function() at_war = drycha:at_war_with(af) end)
            if ok and not at_war then
                table.insert(out, { partner = FACTION_DRY_KEY, asrai = asrai_key })
            end
        end
    end
    return out
end

local function collect_drycha_peace_pairs(partners)
    local out = {}
    local drycha = cm:get_faction(FACTION_DRY_KEY)
    if not drycha or drycha:is_null_interface() then return out end
    for _, partner_key in ipairs(partners) do
        local pf = cm:get_faction(partner_key)
        if pf and not pf:is_null_interface() and not pf:is_dead() then
            local at_war = false
            local ok = pcall(function() at_war = drycha:at_war_with(pf) end)
            if ok and at_war then
                table.insert(out, partner_key)
            end
        end
    end
    return out
end

local function schedule_wars(war_pairs, idx, subculture)
    if idx > #war_pairs then
        log_dry("force_war_all complete: subculture=" .. subculture .. " declared=" .. #war_pairs)
        return
    end
    local pair = war_pairs[idx]
    cm:callback(function()
        local ok, err = pcall(function()
            cm:force_declare_war(pair.partner, pair.asrai, false, false)
        end)
        if ok then
            log_dry("  forced war: " .. pair.partner .. " -> " .. pair.asrai)
        else
            log_dry("  force_declare_war error " .. pair.partner .. " vs " .. pair.asrai .. ": " .. tostring(err))
        end
        schedule_wars(war_pairs, idx + 1, subculture)
    end, 0.2 * idx)
end

local function schedule_peace(peace_partners, idx, war_pairs, subculture)
    if idx > #peace_partners then
        log_dry("force_peace_all complete: subculture=" .. subculture .. " pacified=" .. #peace_partners)
        schedule_wars(war_pairs, 1, subculture)
        return
    end
    local partner_key = peace_partners[idx]
    cm:callback(function()
        local ok, err = pcall(function()
            cm:force_make_peace(FACTION_DRY_KEY, partner_key)
        end)
        if ok then
            log_dry("  forced peace: Drycha <-> " .. partner_key)
        else
            log_dry("  force_make_peace error vs " .. partner_key .. ": " .. tostring(err))
        end
        schedule_peace(peace_partners, idx + 1, war_pairs, subculture)
    end, 0.2 * idx)
end

local function grant_athel_loren_visibility()
    for _, region_key in ipairs(ATHEL_LOREN_REGIONS) do
        local ok, err = pcall(function()
            cm:make_region_seen_in_shroud(FACTION_DRY_KEY, region_key)
        end)
        if ok then
            log_dry("  shroud cleared: " .. region_key)
        else
            log_dry("  make_region_seen_in_shroud error on " .. region_key .. ": " .. tostring(err))
        end
    end
    for _, asrai_key in ipairs(ASRAI_FACTIONS) do
        local ok, err = pcall(function()
            cm:make_diplomacy_available(FACTION_DRY_KEY, asrai_key)
        end)
        if ok then
            log_dry("  diplomacy available: Drycha <-> " .. asrai_key)
        else
            log_dry("  make_diplomacy_available error vs " .. asrai_key .. ": " .. tostring(err))
        end
    end
end

local function handle_unlikely_alliance_choice(choice)
    local h = CHOICE_HANDLERS[choice]
    if not h then
        log_dry("unknown choice index: " .. tostring(choice))
        return
    end

    cm:callback(function()
        if h.subculture then
            local partners = collect_subculture_factions(h.subculture)
            local peace_partners = collect_drycha_peace_pairs(partners)
            local partner_war_pairs = collect_war_pairs(partners)
            local drycha_war_pairs = collect_drycha_war_pairs()
            log_dry("dilemma_apply: subculture=" .. h.subculture
                .. " partners=" .. #partners
                .. " drycha_peace_pending=" .. #peace_partners
                .. " partner_war_pairs=" .. #partner_war_pairs
                .. " drycha_war_pairs=" .. #drycha_war_pairs)
            grant_athel_loren_visibility()
            for _, p in ipairs(drycha_war_pairs) do
                local af = cm:get_faction(p.asrai)
                local pre = false
                pcall(function() pre = cm:get_faction(FACTION_DRY_KEY):at_war_with(af) end)
                local ok, err = pcall(function()
                    cm:force_declare_war(p.partner, p.asrai, false, false)
                end)
                local post = false
                pcall(function() post = cm:get_faction(FACTION_DRY_KEY):at_war_with(af) end)
                if ok then
                    log_dry("  drycha-side war: Drycha -> " .. p.asrai
                        .. " (pre=" .. tostring(pre) .. " post=" .. tostring(post) .. ")")
                else
                    log_dry("  drycha-side war error vs " .. p.asrai .. ": " .. tostring(err))
                end
            end
            if #peace_partners > 0 then
                schedule_peace(peace_partners, 1, partner_war_pairs, h.subculture)
            else
                schedule_wars(partner_war_pairs, 1, h.subculture)
            end
        end
    end, 0.1)
end

local function suppress_shanlin_mission()
    local ok, err = pcall(function()
        cm:set_saved_value("vco_wef_drycha_shanlin_mission_already_happened", true)
    end)
    if ok then
        log_dry("blocked VCO Shanlin confederation mission (saved-value seeded)")
    else
        log_dry("Shanlin block error: " .. tostring(err))
    end
end

local function pow_ext_wef_dry_main()
    cm:add_first_tick_callback(function()
        if not dry_human() then return end

        suppress_shanlin_mission()

        core:add_listener(
            "pow_ext_wef_dry_unlikely_alliance_choice",
            "DilemmaChoiceMadeEvent",
            function(context)
                return context:dilemma() == UNLIKELY_ALLIANCE_DILEMMA
            end,
            function(context)
                local choice = context:choice()
                log_dry("unlikely alliance choice: " .. tostring(choice))
                handle_unlikely_alliance_choice(choice)
            end,
            true
        )
    end)
end

pow_ext_wef_dry_main()

cm.add_first_tick_callback = _pow_ext_orig_aftc
end
