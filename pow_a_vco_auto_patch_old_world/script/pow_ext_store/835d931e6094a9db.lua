do
local _pow_ext_orig_aftc = cm.add_first_tick_callback
cm.add_first_tick_callback = function(_self, _fn) _fn() end

local FACTION_YUA_KEY = "wh3_dlc24_cth_the_celestial_court"

local CELESTIAL_WINDS_DILEMMA_KEY =
    pow_ext_config.dilemmas[FACTION_YUA_KEY]["pow_ext_yuan_bo_celestial_winds"]
local R3_TELEPORT_COORDS_BY_DIR = {
    west  = {221, 1372},
    north = {770, 1683},
    south = {741, 929},
    east  = {1343, 1322},
}
local DILEMMA_CHOICE_BY_INDEX = {
    [0] = "west",
    [1] = "north",
    [2] = "south",
    [3] = "east",
}
local DILEMMA_DEFER_CHOICE   = 4
local DILEMMA_DISMISS_CHOICE = 5
local DILEMMA_DEFER_TURNS    = 5

local SV_DILEMMA_DEFER_TURN = "pow_ext_yuan_bo_dilemma_defer_target_turn"

local function log_yua(msg)
    if ModLog then ModLog("[YUA] " .. tostring(msg)) end
end

local function yua_human()
    local f = cm:get_faction(FACTION_YUA_KEY)
    return f and not f:is_null_interface() and f:is_human()
end

local function handle_celestial_winds_choice(choice)
    local faction = cm:get_faction(FACTION_YUA_KEY)
    if not faction or faction:is_null_interface() then return end
    local leader = faction:faction_leader()
    if not leader or leader:is_null_interface() then return end

    if choice == DILEMMA_DEFER_CHOICE then
        local target = cm:turn_number() + DILEMMA_DEFER_TURNS
        cm:set_saved_value(SV_DILEMMA_DEFER_TURN, target)
        return
    end
    if choice == DILEMMA_DISMISS_CHOICE then return end

    local direction = DILEMMA_CHOICE_BY_INDEX[choice]
    if not direction then return end
    local coords = R3_TELEPORT_COORDS_BY_DIR[direction]
    if not coords then return end

    cm:callback(function()
        cm:teleport_to(cm:char_lookup_str(leader), coords[1], coords[2])
    end, 0.1)
end

local function pow_ext_cth_yua_main()
    cm:add_first_tick_callback(function()
        if not yua_human() then return end

        core:add_listener(
            "pow_ext_yuan_bo_celestial_winds_choice",
            "DilemmaChoiceMadeEvent",
            function(context)
                return context:dilemma() == CELESTIAL_WINDS_DILEMMA_KEY
            end,
            function(context)
                local choice = context:choice()
                log_yua("celestial winds choice: " .. tostring(choice))
                handle_celestial_winds_choice(choice)
            end,
            true
        )

        core:add_listener(
            "pow_ext_yuan_bo_defer_check",
            "FactionTurnStart",
            function(context)
                if context:faction():name() ~= FACTION_YUA_KEY then return false end
                local target = cm:get_saved_value(SV_DILEMMA_DEFER_TURN)
                if not target or target == 0 then return false end
                return cm:turn_number() == target
            end,
            function()
                cm:set_saved_value(SV_DILEMMA_DEFER_TURN, 0)
                cm:trigger_dilemma(FACTION_YUA_KEY, CELESTIAL_WINDS_DILEMMA_KEY)
            end,
            true
        )

    end)
end

pow_ext_cth_yua_main();

cm.add_first_tick_callback = _pow_ext_orig_aftc
end
