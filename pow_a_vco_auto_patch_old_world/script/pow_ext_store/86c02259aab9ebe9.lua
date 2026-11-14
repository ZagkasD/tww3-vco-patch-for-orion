do
local _pow_ext_orig_aftc = cm.add_first_tick_callback
cm.add_first_tick_callback = function(_self, _fn) _fn() end

local FACTION_MDR_KEY = "wh2_main_skv_clan_moulder"

local R1_SCRIPT_KEY = "vco_skv_mld_augments"
local R1_OW_MISSION_KEY = "wh_main_short_victory"
local REQUIRED_TAILS = { "inf_aug_13", "inf_aug_14", "mon_aug_13", "mon_aug_14" }
local AUGMENTS_THRESHOLD = 4
local AUGMENTS_DEBUG_WILDCARD = false

local function effect_tail_for(effect_key)
    for _, tail in ipairs(REQUIRED_TAILS) do
        if effect_key == "wh2_dlc16_throt_flesh_lab_" .. tail then
            return tail
        end
    end
    if AUGMENTS_DEBUG_WILDCARD
        and effect_key:sub(1, 26) == "wh2_dlc16_throt_flesh_lab_"
    then
        return REQUIRED_TAILS[1]
    end
    return nil
end

local function count_unlocked_augments()
    local n = 0
    for _, tail in ipairs(REQUIRED_TAILS) do
        if cm:get_saved_value("vco_skv_mdr_" .. tail .. "_unlocked") then
            n = n + 1
        end
    end
    return n
end

local function pow_ext_skv_mdr_main()
    cm:add_first_tick_callback(function()
        if pow_ext and pow_ext.get_threshold then
            local cfg = pow_ext.get_threshold(FACTION_MDR_KEY, "augments_count", nil)
            if cfg then
                if cfg.threshold then AUGMENTS_THRESHOLD = cfg.threshold end
                if cfg.debug_wildcard ~= nil then AUGMENTS_DEBUG_WILDCARD = cfg.debug_wildcard end
            end
        end
        core:add_listener(
            "pow_ext_skv_mdr_augments",
            "UnitEffectPurchased",
            function(context)
                if cm:get_saved_value("pow_ext_skv_mdr_augments_complete") then
                    return false
                end
                local faction = context:unit():faction()
                if not faction:is_human() or faction:name() ~= FACTION_MDR_KEY then
                    return false
                end
                return effect_tail_for(context:effect():record_key()) ~= nil
            end,
            function(context)
                local tail = effect_tail_for(context:effect():record_key())
                if tail then
                    cm:set_saved_value("vco_skv_mdr_" .. tail .. "_unlocked", true)
                end
                if count_unlocked_augments() >= AUGMENTS_THRESHOLD then
                    cm:complete_scripted_mission_objective(
                        FACTION_MDR_KEY, R1_OW_MISSION_KEY, R1_SCRIPT_KEY, true
                    )
                    cm:set_saved_value("pow_ext_skv_mdr_augments_complete", true)
                end
            end,
            true
        )
    end)
end

pow_ext_skv_mdr_main()

cm.add_first_tick_callback = _pow_ext_orig_aftc
end
