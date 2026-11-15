# VCO Patch for Orion — Old World Campaign

A minimal patch that adds a missing victory route for **Orion (Wood Elves)** on the **Old World** campaign map in *Total War: Warhammer III*, using the **POW (Patch for Old World)** auto-loading system.

**TODO:** Add the two other mission routes as well as the events/battles.

**TODO2:** Update the factions that need to be destroyed for route 1. Currently almost all are too far away in the old world.

## Why VCO breaks on the Old World map

VCO defines all its victory missions against the default campaign map (`main_warhammer`). Every objective references concrete database keys:

- **Region keys** — e.g. `wh3_main_combi_region_the_oak_of_ages`.
- **Faction keys** — e.g. `wh_dlc05_bst_morghur_herd`.
- **Set-piece battle keys** — e.g. `wh_dlc05_qb_wef_grand_defense_of_the_oak`.

The Old World mod is a remade campaign with different keys for everything. VCO's missions point to keys that don't exist on the Old World map, so they fail to trigger.

## How POW fixes it

**POW (Patch for Old World)** provides Old World–corrected mission definitions. Its dispatcher automatically discovers missions in `pow_ext_routes/cr_oldworld/<faction>/missions.lua` for all active factions, and loads them on new game starts.

No manifest entry is needed — the dispatcher handles everything.

## The Orion-specific fix

Orion (the Wood Elves DLC faction) had no Route I victory defined for the Old World map. This patch adds **Route I — "Oak of Ages"** by placing a mission file in the routes directory, where POW's dispatcher auto-discovers it.

## What Changed

Three files in `pow_a_vco_auto_patch_old_world`:

| File | Change |
|---|---|
| `script/pow_ext_routes/cr_oldworld/wh_dlc05_wef_wood_elves/missions.lua` | **New file** — Orion Route I mission, using Old World map keys for regions, factions, and set-piece battles. Auto-discovered by POW's dispatcher. |
| `db/victory_types_tables/__pow_ext.tsv` | Added one row: `vco_victory_type_pow_ext_wef_orion_1` (short route, short length). |
| `text/db/!!zzz_pow_extended_dialog.loc.tsv` | Added mission description text and display name ("Route I - Oak of Ages"). |


## Dependencies

- **Victory Conditions Overhaul (VCO)** — required.
- **POW — Patch for Old World** — required. This patch adds a mission file to POW's routes directory.