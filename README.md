# Zone Mount

One button. Mounts you on a mount that *looks* like it belongs in the zone you're standing in.

Green nature drake in Amirdrassil. Seahorse in Nazjatar. Cloud serpent in Pandaria. Trike in Undermine. Dragonhawk in Eversong.

## How it works

1. **Reads your zone.** It walks up your map chain (zone, then continent, and so on) and uses the most specific themed map it finds.
2. **Tags every mount.** Each mount in the game has look tags such as `green`, `nature`, `drake`, `fire`, `ice`, `undead`, `sea`, plus creature and color tags. The tags live in a shipped table (`Data.lua`, keyed by mount ID, so it works in any client language and for mounts you don't own).
3. **Scores them.** Each zone asks for tags. A tag that came from the mount's name is worth 2 points, one that came from its description is worth 1, and a name-keyword hit is worth 1.
4. **Picks one.** Only mounts you own and can use right now are considered. The pick is a weighted random, with weight equal to score squared: great matches show up most, but any match can appear.
5. **Falls back.** If a zone has no theme or nothing matches, it summons one of your favorite mounts, then any usable mount.

Press the button again while mounted to dismount.

## Install

1. Download or clone this repo.
2. Put the `ZoneMount` folder in `World of Warcraft\_retail_\Interface\AddOns\`. The folder needs to contain `ZoneMount.toc` directly.
3. Launch the game, or `/reload` if it's already running.

Retail only (Interface 120100).

## Usage

- **Button:** Click the floating icon. Shift-drag to move it. Hover to see the current zone's theme.
- **Keybind:** Esc > Options > Keybindings > AddOns > Zone Mount.
- **Slash commands** (`/zmount` or `/zonemount`):

| Command | What it does |
|---|---|
| `/zmount` | Summon a zone-themed mount (or dismount) |
| `/zmount where` | Print your map chain and which themes matched |
| `/zmount list` | List usable mounts that match this zone, best first, with scores |
| `/zmount hide` / `show` | Toggle the button |

The Collections > Mounts journal shows each mount's tags under its name (colored by type: red is red, fire is orange, void is purple, and so on) and in its tooltip.

## Zones covered

Themes are defined in `Themes.lua`:

- **Classic:** Elwynn/Stormwind, Durotar/Orgrimmar, Dun Morogh/Ironforge, Winterspring, Tanaris, Un'Goro, Silithus
- **Outland, Northrend, Cataclysm, Pandaria, Draenor, Broken Isles, Argus**
- **Battle for Azeroth:** Zandalar, Kul Tiras, Nazjatar, Mechagon
- **Shadowlands:** Bastion, Revendreth, Maldraxxus, Ardenweald, The Maw/Korthia, Zereth Mortis
- **Dragonflight:** Dragon Isles, Waking Shores, Ohn'ahran Plains, Azure Span, Thaldraszus, Forbidden Reach, Zaralek Cavern, Emerald Dream, Amirdrassil
- **The War Within:** Khaz Algar, Isle of Dorn, The Ringing Deeps, Hallowfall, Azj-Kahet, K'aresh, Undermine
- **Midnight:** Silvermoon City, Eversong Woods, Isle of Quel'Danas, Zul'Aman, Harandar, Voidstorm

A zone that isn't listed falls back to your favorite mounts.

## Customizing

- **Zones:** edit `Themes.lua`. Each theme has `maps` (uiMapIDs), optional `tags`, and optional name `keywords`. Run `/zmount where` in a zone to get its map ID.
- **Tag rules:** `Tags.lua` holds the word lists that decide which look a mount has. They are used for mounts missing from `Data.lua` and by the table generator.
- **Overrides in game:** when a mount's name misleads, set `ns.tagOverrides["Mount Name"] = { "tag", ... }` in `Tags.lua`.

### Regenerating the tag table

`Data.lua` is generated. On logout the addon dumps every journal mount to `WTF\Account\<id>\SavedVariables\ZoneMount.lua`. To rebuild:

```bash
python tools/gen_tags.py "<path to that file>" tools/curated.json
```

- `tools/gen_tags.py` derives tags from the rules in `Tags.lua` and writes `Data.lua`. Mounts it can't tag are listed in `tools/untagged.txt`.
- `tools/curated.json` holds hand-reviewed tags (mount ID or exact name to `"tag tag ~weak"`) that replace the derived ones. About 1,100 mounts are curated; the rest were reviewed and left as generated.
- `tools/apply.py` merges a JSON object of new curated entries from stdin into `curated.json`.

Pull requests with tag fixes are welcome.

## Known limits

- WoW doesn't expose mount colors or themes to addons, so tags come from names and descriptions and were then reviewed by hand. A few mounts are tagged wrong, and 7 are untagged because I couldn't tell what they look like (Craghorn Chasm-Leaper, Sarge's Tale, Pattie, Wick, Siesbarg, The Breaker's Song, Sthaarbs's Last Lunch).
- Mounts added after the table was generated use the English-only name rules until it is regenerated.
- Midnight map IDs were taken from guide-site coordinates, and some older IDs are from memory. If a zone doesn't theme, check `/zmount where` and fix the ID in `Themes.lua`.
- Sub-zones without their own theme inherit their parent's.

## Ideas

- Swimming mode (seahorses underwater)
- `/zmount tag <mount> <tags>` to fix tags in game
- Per-zone pinned mounts
- Tags in the journal's detail panel as well as the list
