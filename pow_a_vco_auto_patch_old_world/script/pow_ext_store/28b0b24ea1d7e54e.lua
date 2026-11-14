do
local _pow_ext_orig_aftc = cm.add_first_tick_callback
cm.add_first_tick_callback = function(_self, _fn) _fn() end

local FACTION_KEY = "wh_dlc08_nor_norsca"

local SV_TIER_3_DONE = "pow_ext_nor_wul_tier_3_done"
local SV_TIER_4_DONE = "pow_ext_nor_wul_tier_4_done"

local R2_MISSION_KEY = "wh_main_long_victory"
local R2_SCRIPT_KEY  = "attain_chaos_god_favour_lvl_3"
local R3_MISSION_KEY = "wh_main_domination_victory"
local R3_SCRIPT_KEY  = "attain_chaos_god_favour_lvl_4"

local COMPLETION_DELAY_SEC = 0.5

local function fire_completion(mission_key, script_key, done_sv_key)
    if cm:get_saved_value(done_sv_key) then return end
    pcall(function()
        cm:complete_scripted_mission_objective(FACTION_KEY, mission_key, script_key, true)
    end)
    cm:set_saved_value(done_sv_key, true)
end

local function schedule_tier_3()
    if cm:get_saved_value(SV_TIER_3_DONE) then return end
    cm:callback(function()
        fire_completion(R2_MISSION_KEY, R2_SCRIPT_KEY, SV_TIER_3_DONE)
    end, COMPLETION_DELAY_SEC)
end

local function schedule_tier_4()
    if cm:get_saved_value(SV_TIER_4_DONE) then return end
    cm:callback(function()
        fire_completion(R3_MISSION_KEY, R3_SCRIPT_KEY, SV_TIER_4_DONE)
    end, COMPLETION_DELAY_SEC)
end

core:add_listener(
    "pow_ext_nor_wul_chaos_favour_tier",
    "PooledResourceEffectChangedEvent",
    function(context)
        if not context:faction():is_human() then return false end
        if context:faction():name() ~= FACTION_KEY then return false end
        return string.find(tostring(context:resource():key()), "nor_progress_") ~= nil
    end,
    function(context)
        local effect = tostring(context:new_effect())
        if string.find(effect, "_3") then
            schedule_tier_3()
        elseif string.find(effect, "_4") then
            schedule_tier_4()
        end
    end,
    true
)

cm.add_first_tick_callback = _pow_ext_orig_aftc
end
