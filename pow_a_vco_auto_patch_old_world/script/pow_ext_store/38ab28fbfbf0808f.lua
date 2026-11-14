-- pow_ext_listeners_nur_epi.lua
-- Epidemius Route 1 'Land of Plagues' — restricted-region Nurgle
-- corruption counter. Mirrors vco-listeners-doc.lua's monogod
-- great_game check but iterates a 17-region whitelist instead of
-- counting globally. Threshold 14/17 to complete the route.
-- Epidemius is disabled in classic so this only matters in OW main.
--
-- Note: VCO's vco:set_mission_text and vco:complete_mission helpers
-- hardcode mission key "vco_route_victory", but OW campaigns rename
-- routes to wh_main_short/long/domination_victory. Calls below use
-- the underlying CA API directly with the correct OW mission key.

local vlc = core:get_static_object("vco-lib-commons");

local FACTION_EPI_KEY = "wh3_dlc25_nur_epidemius";
local NURGLE_CORRUPTION = "wh3_main_corruption_nurgle";
local THRESHOLD = 14;
local SCRIPT_KEY = "pow_ext_epidemius_land_of_plagues";
local OW_MISSION_KEY = "wh_main_short_victory";
local TEXT_PREFIX = "mission_text_text_pow_ext_epidemius_land_of_plagues_progress_";

local LAND_OF_PLAGUES_REGIONS = {
    "cr_oldworld_region_wyrmid_reaches",
    "cr_oldworld_region_lair_of_the_thirteenth_lord",
    "cr_oldworld_region_great_tree",
    "cr_oldworld_region_eternal_swamps",
    "cr_oldworld_region_arnzipals_island",
    "cr_oldworld_region_titan_graveyards",
    "cr_oldworld_region_ossified_halls",
    "cr_oldworld_region_fields_of_tooth_and_bone",
    "cr_oldworld_region_lair_of_the_maggot_lord",
    "cr_oldworld_region_arghus_the_plague_moon",
    "cr_oldworld_region_septic_isle",
    "cr_oldworld_region_abyssal_sump",
    "cr_oldworld_region_bridge_of_fools",
    "cr_oldworld_region_island_of_lepers",
    "cr_oldworld_region_rotten_reaches",
    "cr_oldworld_region_fungus_lands",
    "cr_oldworld_region_garden_of_blight",
};

local function count_corrupted_in_set()
    local n = 0
    for _, region_key in ipairs(LAND_OF_PLAGUES_REGIONS) do
        local region = cm:get_region(region_key)
        if region and not region:is_null_interface() then
            if vlc.corruption:is_corruption_highest_in_region(NURGLE_CORRUPTION, region) then
                n = n + 1
            end
        end
    end
    return n
end

local function check_land_of_plagues()
    local corrupted = count_corrupted_in_set()
    if cm:get_saved_value("pow_ext_epidemius_lop_completed") then
        return
    end
    if corrupted < THRESHOLD then
        cm:set_scripted_mission_text(OW_MISSION_KEY, SCRIPT_KEY, TEXT_PREFIX .. corrupted)
    else
        cm:set_scripted_mission_text(OW_MISSION_KEY, SCRIPT_KEY, TEXT_PREFIX .. "complete")
        cm:complete_scripted_mission_objective(FACTION_EPI_KEY, OW_MISSION_KEY, SCRIPT_KEY, true)
        cm:set_saved_value("pow_ext_epidemius_lop_completed", true)
    end
end

local function pow_ext_nur_epi_main()
    cm:add_first_tick_callback(function()
        core:add_listener(
            "pow_ext_nur_epi_land_of_plagues_check",
            "FactionTurnStart",
            function(context)
                return context:faction():name() == FACTION_EPI_KEY
                    and context:faction():is_human()
            end,
            check_land_of_plagues,
            true
        )
    end)
end

pow_ext_nur_epi_main();
