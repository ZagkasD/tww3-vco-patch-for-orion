-- Auto-generated extended-coverage loader for pow-tzeentch-extended.
--
-- Replaces the role of vco:trigger_custom_missions for our generated content,
-- with a runtime deference guard against any other mod that supplies victory
-- missions for the same faction.
--
-- Detection is via __pow_ext_runtime.lua, which wraps
-- cm:trigger_custom_mission_from_string to record every faction another mod
-- triggers a custom mission for. Our actual trigger is registered via
-- cm:add_post_first_tick_callback from INSIDE cm:add_first_tick_callback —
-- this guarantees our callback is appended to the post-first-tick queue
-- AFTER everyone else's source-time registrations (including POW's), so it
-- fires last in the batch. By then every other mod's trigger calls are
-- recorded and we can stand aside on covered factions and trigger ours on
-- the rest.

local pow = core:get_static_object("pow");

local function pow_tze_extended_trigger()
    if pow_ext and pow_ext.log then pow_ext.log("pow-tzeentch-extended trigger fired; is_new_game=" .. tostring(cm:is_new_game())) end
    if not cm:is_new_game() then return end
    local campaign = cm:get_campaign_name();
    for _, faction in ipairs(cm:get_human_factions()) do
        if pow_ext and pow_ext.log then pow_ext.log("pow-tzeentch-extended considering faction " .. tostring(faction)) end
        if not pow_ext.has_external_coverage(faction) then
            local our_path = "script/pow-tzeentch-extended/" .. campaign .. "/" .. faction .. "/missions";
            local ok, missions = pcall(require, our_path);
            if pow_ext and pow_ext.log then pow_ext.log("pow-tzeentch-extended require " .. our_path .. " -> ok=" .. tostring(ok) .. " type=" .. type(missions)) end
            if ok and type(missions) == "table" then
                pow_ext.trigger_our_missions(faction, missions);
                -- Notify the player that this faction is running our
                -- auto-generated extended coverage. Delayed past the
                -- intro cinematic to avoid the "blink" the engine
                -- otherwise re-renders post-video.
                if not pow_ext.notified[faction] then
                    pow_ext.notified[faction] = true;
                    local notify_faction = faction;
                    cm:callback(function()
                        cm:show_message_event(
                            notify_faction,
                            "event_feed_strings_text_pow_extended_dialog_title",
                            "event_feed_strings_text_pow_extended_dialog_primary",
                            "event_feed_strings_text_pow_extended_dialog_secondary",
                            true,
                            1
                        );
                    end, 20.0);
                end
            end
        end
    end
end

local function pow_tze_extended_main()
    if pow_ext and pow_ext.log then pow_ext.log("pow_tze_extended_main entry; pow=" .. tostring(pow)) end
    if not pow then return end
    if pow_ext and pow_ext.log then pow_ext.log("pow_tze_extended_main is_pow_campaign=" .. tostring(pow:is_pow_campaign())) end
    if not pow:is_pow_campaign() then return end

    -- Defer our post-first-tick registration to first-tick time. The engine
    -- iterates first_tick_callbacks then post_first_tick_callbacks; #-len is
    -- snapshotted at each call_each call, so appending to
    -- post_first_tick_callbacks during first-tick processing makes our entry
    -- visible (and last) when post-first-tick processing then iterates.
    cm:add_first_tick_callback(function()
        if pow_ext and pow_ext.log then pow_ext.log("pow_tze_extended_main first-tick callback firing; registering post-first-tick") end
        cm:add_post_first_tick_callback(pow_tze_extended_trigger);
    end);
end

pow_tze_extended_main();
