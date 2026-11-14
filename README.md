# VCO Patch for Orion — Old World Campaign

A minimal patch that fixes **Victory Conditions Overhaul (VCO)** so it works on the **Old World** campaign map, specifically adding the missing victory route for **Orion (Wood Elves)**.

## Why VCO breaks on the Old World map

VCO defines all its victory missions against a specific campaign map. Every objective in a VCO mission references concrete database keys:

- **Region keys** — e.g. `cr_oldworld_region_the_oak_of_ages` (the Old World map's version of the Oak of Ages).
- **Faction keys** — e.g. `wh_dlc05_bst_morghur_herd` (Morghur's faction on the Old World map).
- **Set-piece battle keys** — e.g. `wh_dlc05_qb_wef_grand_defense_of_the_oak`.

The Old World mod is a separate, remade version of the campaign. It renumbers settlements, reassigns starting positions, and uses its own set of faction and region keys. VCO was built against the default map layout, so when you switch to the Old World map, VCO's mission definitions point to keys that either don't exist or refer to completely different locations and factions.

The result is that VCO's missions either fail to trigger, reference the wrong targets, or — in the case of newer DLC factions like Orion — don't load at all.

## Why the POW patch exists

**POW (Patch for Old World)** bridges this gap. It provides a separate set of mission definitions that use the Old World map's keys, so VCO-style victory routes work correctly on the remade campaign. The POW bootstrap script detects which factions are active, checks whether VCO or another mod already covers them, and loads only the Old World–corrected missions for the remaining factions.

## The Orion-specific fix

Even with POW in place, Orion (the Wood Elves DLC faction) had no victory route defined for the Old World map. Playing Orion with VCO + POW enabled still left the faction with no way to win.

This patch adds **Route I — "Oak of Ages"** for Orion to the POW manifest, so the bootstrap system loads it automatically when Orion is active.

## What Changed

Four files in `pow_a_vco_auto_patch_old_world`:

| File | Change |
|---|---|
| `script/pow_ext_store/orion_route1.lua` | **New file** — Orion Route I mission, using Old World map keys for regions, factions, and set-piece battles. |
| `db/victory_types_tables/__pow_ext.tsv` | Added one row: `vco_victory_type_pow_ext_wef_orion_1` (short route, short length). |
| `text/db/!!zzz_pow_extended_dialog.loc.tsv` | Added mission description text and display name ("Route I - Oak of Ages"). |
| `script/pow_ext_store/__pow_ext_manifest.lua` | Registered `orion_route1` under faction `wh_dlc05_wef_wood_elves` in the VCO 2.0.0 manifest. |



## Dependencies

- **Victory Conditions Overhaul (VCO)** — required.
- **POW — Patch for Old World** — required. This patch is a single entry added to the POW manifest.
