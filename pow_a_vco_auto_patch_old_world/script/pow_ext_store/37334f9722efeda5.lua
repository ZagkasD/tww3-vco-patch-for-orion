-- pow_ext_listeners_wef_twi.lua
-- Sisters of Twilight R2 Worldroots-rebirth counter. See doc comment
-- on write_wef_twi_listener_stub in pack.rs for details.

local FACTION_TWI_KEY = "wh2_dlc16_wef_sisters_of_twilight"

-- R2 (Worldroots rebirth counter) — campaign-aware. Main has 16
-- magical-forest options and asks for 8 rebirths; Classic has 10
-- and asks for 6. Threshold + progress-string prefix selected at
-- first_tick from cm:get_campaign_name().
local R2_OW_MISSION_KEY = "wh_main_long_victory"
local R2_SCRIPT_KEY = "pow_ext_wef_twi_worldroots_rebirth_counter"
local R2_TEXT_PREFIX_MAIN = "mission_text_text_pow_ext_sisters_worldroots_rebirth_main_"
local R2_TEXT_PREFIX_CLASSIC = "mission_text_text_pow_ext_sisters_worldroots_rebirth_classic_"
local REBIRTH_THRESHOLD_MAIN = 8
local REBIRTH_THRESHOLD_CLASSIC = 6
local RITE_PREFIX = "cr_ritual_rebirth_"

local function pow_ext_wef_twi_main()
    cm:add_first_tick_callback(function()
        local is_classic = (cm:get_campaign_name() == "cr_oldworldclassic")
        local R2_TEXT_PREFIX = is_classic and R2_TEXT_PREFIX_CLASSIC or R2_TEXT_PREFIX_MAIN
        local REBIRTH_THRESHOLD = is_classic and REBIRTH_THRESHOLD_CLASSIC or REBIRTH_THRESHOLD_MAIN

        -- R2 Worldroots-rebirth counter. RitualCompletedEvent fires
        -- when any rite finishes its multi-turn cast; we filter to
        -- the Sisters as performer + ritual_key matching the
        -- cr_ritual_rebirth_<forest> family.
        core:add_listener(
            "pow_ext_wef_twi_worldroots_rebirth",
            "RitualCompletedEvent",
            function(context)
                if cm:get_saved_value("pow_ext_wef_twi_worldroots_rebirth_complete") then
                    return false
                end
                local faction = context:performing_faction()
                if not faction:is_human() then return false end
                if faction:name() ~= FACTION_TWI_KEY then return false end
                local key = context:ritual():ritual_key()
                return key:sub(1, #RITE_PREFIX) == RITE_PREFIX
            end,
            function(context)
                local count = (cm:get_saved_value("pow_ext_wef_twi_worldroots_rebirth_count") or 0) + 1
                cm:set_saved_value("pow_ext_wef_twi_worldroots_rebirth_count", count)
                local display = math.min(count, REBIRTH_THRESHOLD)
                cm:set_scripted_mission_text(
                    FACTION_TWI_KEY, R2_OW_MISSION_KEY, R2_SCRIPT_KEY,
                    R2_TEXT_PREFIX .. tostring(display)
                )
                if count >= REBIRTH_THRESHOLD then
                    cm:complete_scripted_mission_objective(
                        FACTION_TWI_KEY, R2_OW_MISSION_KEY, R2_SCRIPT_KEY, true
                    )
                    cm:set_saved_value("pow_ext_wef_twi_worldroots_rebirth_complete", true)
                end
            end,
            true
        )
    end)
end

pow_ext_wef_twi_main()
