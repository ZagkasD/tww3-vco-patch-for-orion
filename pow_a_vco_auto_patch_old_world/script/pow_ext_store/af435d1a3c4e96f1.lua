do
local _pow_ext_orig_aftc = cm.add_first_tick_callback
cm.add_first_tick_callback = function(_self, _fn) _fn() end

local FACTION_MAN_KEY = "wh_main_vmp_vampire_counts"

local OSSIFIED_DILEMMA_KEY = "vco_vmp_man_dilemma_ossified_portal"
local OW_PORTAL_X = 1035
local OW_PORTAL_Y = 1075
local OW_PORTAL_DELAY_TURNS = 5
local VCO_DELAY_LISTENER_NAME = "vco_vmp_man_dilemma_trigger_delay"

local function pow_ext_vmp_man_main()
    cm:add_first_tick_callback(function()
        core:add_listener(
            "pow_ext_vmp_man_ossified_portal_override",
            "DilemmaChoiceMadeEvent",
            function(context)
                return context:dilemma() == OSSIFIED_DILEMMA_KEY
            end,
            function(context)
                local choice = context:choice()
                cm:callback(function()
                    local faction = cm:get_faction(FACTION_MAN_KEY)
                    if not faction or faction:is_null_interface() then return end
                    local leader = faction:faction_leader()
                    if not leader or leader:is_null_interface() then return end

                    if choice == 0 then
                        cm:teleport_to(
                            cm:char_lookup_str(leader),
                            OW_PORTAL_X, OW_PORTAL_Y
                        )
                    elseif choice == 1 then
                        core:remove_listener(VCO_DELAY_LISTENER_NAME)
                        local target_turn_number =
                            cm:turn_number() + OW_PORTAL_DELAY_TURNS
                        core:add_listener(
                            "pow_ext_vmp_man_portal_delay_t" .. cm:turn_number(),
                            "FactionTurnStart",
                            function(c)
                                return c:faction():is_human() and
                                    c:faction():name() == FACTION_MAN_KEY and
                                    cm:turn_number() == target_turn_number
                            end,
                            function()
                                cm:trigger_dilemma(
                                    FACTION_MAN_KEY, OSSIFIED_DILEMMA_KEY
                                )
                            end,
                            false
                        )
                    end
                end, 0.1)
            end,
            true
        )
    end)
end

pow_ext_vmp_man_main();

cm.add_first_tick_callback = _pow_ext_orig_aftc
end
