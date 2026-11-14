
local pow = core:get_static_object("pow")

if pow and pow:is_pow_campaign() and cm:is_new_game() then
    local campaign = cm:get_campaign_name()
    for faction in pairs(pow_ext.active_factions or {}) do
        local our_path = "script/pow_ext_routes/" .. campaign .. "/" .. faction .. "/missions"
        local ok, missions = pcall(require, our_path)
        if ok and type(missions) == "table" then
            pow_ext.trigger_our_missions(faction, missions)
            if not pow_ext.notified[faction] then
                pow_ext.notified[faction] = true
                local notify_faction = faction
                cm:callback(function()
                    cm:show_message_event(
                        notify_faction,
                        "event_feed_strings_text_pow_extended_dialog_title",
                        "event_feed_strings_text_pow_extended_dialog_primary",
                        "event_feed_strings_text_pow_extended_dialog_secondary",
                        true,
                        1
                    )
                end, 20.0)
            end
        end
    end
end
