# Zone Mount

One button. Mounts you on a mount that *looks* like it belongs in the zone you're standing in.

Green nature drake in Amirdrassil. Seahorse in Nazjatar. Cloud serpent in Pandaria. Trike in Undermine.

## How it works

1. **Reads your zone.** It walks up your map chain (zone, then continent, and so on) and uses the most specific themed map it finds.
2. **Tags your mounts.** Every mount gets look tags like `green`, `nature`, `drake`, `fire`, `ice`, `undead` or `sea`, derived from its name by the rules in `Tags.lua`.
3. **Scores them.** Each zone asks for tags, and each matching tag is worth 2 points. A name-keyword hit is worth 1.
4. **Picks one.** Only mounts you own and can use right now are considered. The pick is a weighted random, with weight equal to score squared. Great matches show up most, but any match can appear.
5. **Falls back.** If a zone has no theme or nothing matches, it summons one of your favorite mounts, then any usable mount.

Press the button again while mounted to dismount.

## Install

1. Download or clone this repo.
2. Put the `ZoneMount` folder in `World of Warcraft\_retail_\Interface\AddOns\`.
3. Launch the game, or `/reload` if it's already running.

Retail only (Interface 120100).

## Usage

- **Button:** Click the floating icon. Shift-drag to move it.
- **Keybind:** Esc > Options > Keybindings > AddOns > Zone Mount.
- **Slash commands** (`/zmount` or `/zonemount`):

| Command | What it does |
|---|---|
| `/zmount` | Summon a zone-themed mount (or dismount) |
| `/zmount where` | Print your map chain and which themes matched |
| `/zmount list` | List usable mounts that match this zone, best first, with scores |
| `/zmount hide` / `show` | Toggle the button |

The Collections > Mounts journal also shows each mount's tags under its name and in its tooltip.

## Customizing

- **Zones:** edit `Themes.lua`. Each theme has `maps` (uiMapIDs), optional `tags`, and optional name `keywords`. Run `/zmount where` in a zone to get its map ID.
- **Tag rules:** edit `Tags.lua` to teach the addon which words in a mount's name imply which look.
- **Overrides:** when a mount's name misleads, set `ns.tagOverrides["Mount Name"] = { "tag", ... }` in `Tags.lua`.

## Known limits

- Tags come from **English mount names**. On other client languages, themes won't match and it falls back to favorites.
- WoW doesn't expose mount colors or themes to addons, so tagging is name-based and will miss some mounts. Overrides are the fix.
- Some map IDs in `Themes.lua` are best guesses. If a zone doesn't theme, check `/zmount where`.
- Only the zones in `Themes.lua` are themed so far.

## Ideas

- Swimming mode (seahorses underwater)
- `/zmount tag <mount> <tags>` to fix tags in game
- Per-zone pinned mounts
