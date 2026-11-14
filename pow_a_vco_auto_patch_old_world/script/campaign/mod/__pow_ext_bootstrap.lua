
local MOD_VERSION = "2.0.0";           -- substituted at pack time
local STAMP_KEY = "pow_ext_mod_version_at_start";
local STORE_DIR = "script/pow_ext_store/";
local MANIFEST_PATH = STORE_DIR .. "__pow_ext_manifest";
local NEW_STYLE_MIN_MAJOR = 2;   -- buckets with major >= this load at post-first-tick (kernel deference); older at autoload

local DEV = true;

pow_ext = pow_ext or {};
pow_ext.dispatch_info = pow_ext.dispatch_info or {};
pow_ext.mod_version = MOD_VERSION;
pow_ext.external_triggers = pow_ext.external_triggers or {};
pow_ext.active_factions = pow_ext.active_factions or {};
pow_ext._calling_self = pow_ext._calling_self or false;

local function bootlog(msg)
    if ModLog then ModLog("[POW_EXT_BOOT] " .. tostring(msg)) end
end
local function devlog(msg)
    if DEV and ModLog then ModLog("[POW_EXT_BOOT] " .. tostring(msg)) end
end

local KERNEL_ENV = getfenv(1);

function pow_ext.has_external_coverage(faction_key)
    return (pow_ext.external_triggers[faction_key] or 0) > 0;
end

local function install_wrap()
    if pow_ext.wrap_installed or not (cm and cm.trigger_custom_mission_from_string) then return; end
    pow_ext.wrap_installed = true;
    devlog("deference wrap installed (first-tick)");
    local _orig = cm.trigger_custom_mission_from_string;
    cm.trigger_custom_mission_from_string = function(self, faction_key, ...)
        if not pow_ext._calling_self then
            pow_ext.external_triggers[faction_key] = (pow_ext.external_triggers[faction_key] or 0) + 1;
        end
        return _orig(self, faction_key, ...);
    end
end

local function compute_active_factions()
    pow_ext.active_factions = {};
    local n = 0;
    if not (cm and cm.get_human_factions) then return n; end
    local ok, humans = pcall(function() return cm:get_human_factions() end);
    if not ok or type(humans) ~= "table" then return n; end
    for _, fk in ipairs(humans) do
        if not pow_ext.has_external_coverage(fk) then
            pow_ext.active_factions[fk] = true;
            n = n + 1;
        end
    end
    return n;
end

local function parse_ver(s)
    local maj, min, pat = 0, 0, 0;
    if type(s) == "string" then
        local a, b, c = string.match(s, "^(%d+)%.(%d+)%.(%d+)");
        if a then maj, min, pat = tonumber(a), tonumber(b), tonumber(c); end
    end
    return maj, min, pat;
end
local function ver_le(a1, a2, a3, b1, b2, b3)
    if a1 ~= b1 then return a1 < b1; end
    if a2 ~= b2 then return a2 < b2; end
    return a3 <= b3;
end

local function resolve_bucket(manifest, save_v)
    local smaj, smin, spat = parse_ver(save_v);
    local best, best_le, oldest_maj, oldest;
    for _, e in ipairs(manifest) do
        local emaj, emin, epat = parse_ver(e.version);
        if emaj == smaj and emin == smin then
            if not best or epat > best[4] then best = { e, emaj, emin, epat }; end
        end
        if emaj == smaj and ver_le(emaj, emin, epat, smaj, smin, spat) then
            if not best_le or not ver_le(emaj, emin, epat, best_le[2], best_le[3], best_le[4]) then
                best_le = { e, emaj, emin, epat };
            end
        end
        if emaj == smaj then
            if not oldest_maj or (ver_le(emaj, emin, epat, oldest_maj[2], oldest_maj[3], oldest_maj[4])
                and not (emaj==oldest_maj[2] and emin==oldest_maj[3] and epat==oldest_maj[4])) then
                oldest_maj = { e, emaj, emin, epat };
            end
        end
        if not oldest or (ver_le(emaj, emin, epat, oldest[2], oldest[3], oldest[4])
            and not (emaj==oldest[2] and emin==oldest[3] and epat==oldest[4])) then
            oldest = { e, emaj, emin, epat };
        end
    end
    local c = best or best_le or oldest_maj or oldest;
    return c and c[1] or nil;
end

local function run_store_file(path)
    local f = loadfile(path .. ".lua") or loadfile(path);
    if not f then return false, "loadfile returned nil for " .. tostring(path); end
    setfenv(f, KERNEL_ENV);
    return pcall(f);
end

local function entry_parts(e)
    if type(e) == "table" then
        return e.hash, e.faction;
    end
    return e, nil;
end

local function load_bucket(entry)
    local loaded, failed, skipped = 0, 0, 0;
    for _, e in ipairs(entry.files) do
        local hash, faction = entry_parts(e);
        if faction and not pow_ext.active_factions[faction] then
            skipped = skipped + 1;
            if DEV then
                pow_ext.dispatch_info.skipped = pow_ext.dispatch_info.skipped or {};
                table.insert(pow_ext.dispatch_info.skipped, hash);
            end
        else
            local ok, err = run_store_file(STORE_DIR .. hash);
            if ok then loaded = loaded + 1; else failed = failed + 1; bootlog("load FAILED " .. tostring(hash) .. ": " .. tostring(err)); end
        end
    end
    return loaded, failed, skipped;
end

local function load_bucket_oldstyle(entry)
    if not cm then return load_bucket(entry); end
    local saved = {};
    local names = { "add_first_tick_callback", "add_pre_first_tick_callback", "add_post_first_tick_callback" };
    for _, n in ipairs(names) do
        if cm[n] then
            saved[n] = cm[n];
            cm[n] = function(_self, fn) if fn then fn() end end;
        end
    end
    local ok, loaded, failed, skipped = pcall(load_bucket, entry);
    for n, fn in pairs(saved) do cm[n] = fn; end   -- restore even on error
    if not ok then
        bootlog("old-style bucket load error: " .. tostring(loaded));
        return 0, 0, 0;
    end
    return loaded, failed, skipped;
end

local function record_dispatch(save_v, entry, loaded, failed, deferred)
    pow_ext.dispatch_info.save_version = save_v;
    pow_ext.dispatch_info.bucket = entry and entry.version or nil;
    pow_ext.dispatch_info.mod_build = MOD_VERSION;
    pow_ext.dispatch_info.loaded = loaded;
    pow_ext.dispatch_info.failed = failed;
    pow_ext.dispatch_info.deferred = deferred and true or false;
end

local function resolve_and_load()
    local ok_m, manifest = run_store_file(MANIFEST_PATH);
    if not ok_m or type(manifest) ~= "table" then
        bootlog("FATAL: manifest missing/invalid at " .. MANIFEST_PATH .. " (" .. tostring(manifest) .. ")");
        return;
    end
    local save_v = MOD_VERSION;
    if cm and cm.get_saved_value then
        local ok_s, s = pcall(function() return cm:get_saved_value(STAMP_KEY) end);
        if ok_s and s then save_v = s; end
    end
    local entry = resolve_bucket(manifest, save_v);
    if not entry then bootlog("FATAL: no bucket for save_version=" .. tostring(save_v)); return; end

    local emaj = parse_ver(entry.version);
    if emaj < NEW_STYLE_MIN_MAJOR then
        local loaded, failed = load_bucket_oldstyle(entry);
        record_dispatch(save_v, entry, loaded, failed, false);
        devlog("dispatch[old-style/post-first-tick run-now]: save=" .. tostring(save_v) .. " -> bucket=" .. tostring(entry.version)
            .. "; loaded " .. loaded .. (failed > 0 and (", " .. failed .. " FAILED") or ""));
        return;
    end

    local active = compute_active_factions();
    if active == 0 then
        record_dispatch(save_v, entry, 0, 0, true);
        devlog("dispatch[new-style]: save=" .. tostring(save_v) .. " -> bucket=" .. tostring(entry.version)
            .. "; all human faction(s) externally covered -> bucket NOT loaded (deferred, zero footprint)");
        return;
    end
    pow_ext.dispatch_info.save_version = save_v;
    pow_ext.dispatch_info.bucket = entry.version;
    pow_ext.dispatch_info.mod_build = MOD_VERSION;
    pow_ext.dispatch_info.deferred = false;
    local loaded, failed, skipped = load_bucket(entry);
    pow_ext.dispatch_info.loaded = loaded;
    pow_ext.dispatch_info.failed = failed;
    devlog("dispatch[new-style/post-first-tick]: save=" .. tostring(save_v) .. " -> bucket=" .. tostring(entry.version)
        .. "; " .. active .. " active faction(s); loaded " .. loaded
        .. (skipped > 0 and (", " .. skipped .. " faction-skipped") or "")
        .. (failed > 0 and (", " .. failed .. " FAILED") or ""));
end

local function dispatch()
    if not (cm and cm.add_first_tick_callback) then return; end
    cm:add_first_tick_callback(function()
        install_wrap();
        cm:add_post_first_tick_callback(resolve_and_load);
    end);
end

if cm and cm.add_first_tick_callback then
    cm:add_first_tick_callback(function()
        if cm:is_new_game() and not cm:get_saved_value(STAMP_KEY) then
            cm:set_saved_value(STAMP_KEY, MOD_VERSION);
            devlog("stamped " .. STAMP_KEY .. " = " .. MOD_VERSION);
        end
    end);
end

devlog("kernel autoload (mod build=" .. MOD_VERSION .. ")");
dispatch();
