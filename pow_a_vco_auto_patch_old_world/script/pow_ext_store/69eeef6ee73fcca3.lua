
pow_ext = pow_ext or {}
pow_ext.our_triggered = pow_ext.our_triggered or {}
pow_ext.notified = pow_ext.notified or {}
pow_ext._calling_self = pow_ext._calling_self or false
pow_ext.active_factions = pow_ext.active_factions or {}
pow_ext.mod_version = "2.0.0"

local function pow_ext_log(msg)
    if ModLog then ModLog("[POW_EXT] " .. tostring(msg)) end
end
pow_ext.log = pow_ext_log

pow_ext_log("__pow_ext_runtime.lua sourcing")

function pow_ext.for_each_active(section, fn)
    if type(section) ~= "table" then return end
    local af = pow_ext.active_factions or {}
    for faction_key, value in pairs(section) do
        if af[faction_key] then
            fn(faction_key, value)
        end
    end
end

function pow_ext.trigger_our_missions(faction_key, missions)
    if pow_ext.our_triggered[faction_key] then return end
    pow_ext.our_triggered[faction_key] = true
    pow_ext._calling_self = true
    pow_ext_log("trigger_our_missions(" .. tostring(faction_key) ..
        "): firing " .. tostring(#missions) .. " missions")
    for _, mission in ipairs(missions) do
        if mission and mission ~= "" then
            cm:trigger_custom_mission_from_string(faction_key, mission)
        end
    end
    pow_ext._calling_self = false
end


function pow_ext.is_classic_campaign()
    if pow_ext._is_classic_cached ~= nil then
        return pow_ext._is_classic_cached
    end
    local result = false
    if cm and cm.model then
        local ok, campaign_name = pcall(function()
            return cm:model():world():campaign_name()
        end)
        if ok and type(campaign_name) == "string" then
            result = (campaign_name == "cr_oldworldclassic")
        end
    end
    pow_ext._is_classic_cached = result
    return result
end

function pow_ext.is_debug()
    return (pow_ext_config and pow_ext_config.debug) == true
end

function pow_ext.is_human_faction(faction_key)
    if not (cm and cm.get_faction) then return false end
    local ok, fac = pcall(function() return cm:get_faction(faction_key) end)
    if not ok or not fac then return false end
    local ok_n, isnull = pcall(function() return fac:is_null_interface() end)
    if not ok_n or isnull then return false end
    local ok_h, h = pcall(function() return fac:is_human() end)
    return ok_h and h == true
end

function pow_ext.get_threshold(faction_key, key, fallback)
    if not (pow_ext_config and pow_ext_config.thresholds) then
        return fallback
    end
    local by_campaign = pow_ext_config.thresholds[faction_key]
    if not by_campaign then return fallback end

    local is_classic = pow_ext.is_classic_campaign and pow_ext.is_classic_campaign()
    local active = is_classic and "classic" or "main"
    local alt = (active == "classic") and "main" or "classic"

    local function lookup(campaign_key)
        local params = by_campaign[campaign_key]
        if not params then return nil end
        local v = params[key]
        if v == nil then return nil end
        return v
    end

    local v = lookup(active)
    if v ~= nil then return v end
    v = lookup(alt)
    if v ~= nil then return v end
    return fallback
end
