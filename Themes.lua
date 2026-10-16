local _, ns = ...

-- Each theme: label, maps = uiMapIDs it covers (children inherit via parent walk),
-- keywords = case-insensitive plain substrings matched against mount names.
-- Use "/zmount where" in game to see the map chain you're standing in.
-- Some map IDs are best guesses; fix them if "/zmount where" disagrees.
ns.themes = {
    -- Classic
    { label = "Elwynn / Stormwind",     maps = { 37, 84 },     keywords = { "Horse", "Stallion", "Steed", "Mare", "Palomino", "Charger", "Stormwind" } },
    { label = "Durotar / Orgrimmar",    maps = { 1, 85 },      keywords = { "Raptor", "Wolf", "Kodo", "Orgrimmar", "Kor'kron", "Warsong" } },
    { label = "Dun Morogh / Ironforge", maps = { 27, 87 },     keywords = { "Ram", "Mechanostrider", "Ironforge" } },
    { label = "Winterspring",           maps = { 83 },         keywords = { "Frostsaber", "Saber", "Yeti", "Frostwolf" } },
    { label = "Tanaris",                maps = { 71 },         keywords = { "Sand", "Scarab", "Camel", "Dune", "Qiraji", "Mirage" } },
    { label = "Un'Goro Crater",         maps = { 78 },         keywords = { "Raptor", "Devilsaur", "Pterrordax", "Primal", "Direhorn" } },
    { label = "Silithus",               maps = { 81 },         keywords = { "Qiraji", "Silithid", "Scarab" } },

    -- Outland
    { label = "Outland",                maps = { 101 },        keywords = { "Netherwing", "Nether Drake", "Nether Ray", "Talbuk", "Warp Stalker", "Fel Iron", "Windrider" } },

    -- Northrend
    { label = "Northrend",              maps = { 113 },        keywords = { "Proto-Drake", "Frostbrood", "Mammoth", "Ice", "Frost", "Wooly", "Yeti", "Sled" } },

    -- Cataclysm
    { label = "Mount Hyjal",            maps = { 198 },        keywords = { "Flame", "Fire", "Ember", "Phoenix", "Molten", "Cinder", "Smolder" }, tags = { "fire" } },
    { label = "Vashj'ir",               maps = { 203 },        keywords = { "Seahorse", "Sea", "Abyssal", "Ray", "Turtle" } },
    { label = "Deepholm",               maps = { 207 },        keywords = { "Stone", "Rock", "Crystal", "Obsidian", "Earth", "Twilight" } },
    { label = "Twilight Highlands",     maps = { 241 },        keywords = { "Twilight", "Drake", "Corrupted", "Wyrm" } },
    { label = "Uldum",                  maps = { 249 },        keywords = { "Camel", "Sand", "Scarab", "Mirage", "Cobra", "Dune", "Sun" } },

    -- Pandaria
    { label = "Pandaria",               maps = { 424 },        keywords = { "Cloud Serpent", "Serpent", "Crane", "Turtle", "Yak", "Kite", "Jade", "Pandaren" } },

    -- Draenor
    { label = "Draenor",                maps = { 572, 534 },   keywords = { "Clefthoof", "Talbuk", "Garn", "Telaari", "Frostwolf", "Ironhoof" } },

    -- Legion
    { label = "Broken Isles",           maps = { 619 },        keywords = { "Felsaber", "Hippogryph", "Stag", "Skyhorn", "Thunderhoof", "Manasaber", "Leyfeather", "Nightborne" } },
    { label = "Argus",                  maps = { 905 },        keywords = { "Fel", "Felblood", "Eredar", "Argus", "Lightforged", "Krokul" } },

    -- Battle for Azeroth
    { label = "Zandalar",               maps = { 875 },        keywords = { "Raptor", "Direhorn", "Pterrordax", "Zandalari", "Devilsaur", "Saurid" } },
    { label = "Kul Tiras",              maps = { 876 },        keywords = { "Kul Tiran", "Seabraid", "Stallion", "Admiralty", "Tidestallion", "Snapper" } },
    { label = "Nazjatar",               maps = { 1355 },       keywords = { "Seahorse", "Nazjatar", "Azshari", "Sea Turtle", "Mollusk" } },
    { label = "Mechagon",               maps = { 1462 },       keywords = { "Mechagon", "Mecha", "Rustbolt", "Chopper", "Trike", "Gnomish", "Mechanostrider" } },

    -- Shadowlands
    { label = "Bastion",                maps = { 1533 },       keywords = { "Larion", "Phalynx", "Aspirant", "Pale" } },
    { label = "Revendreth",             maps = { 1525 },       keywords = { "Gloomcharger", "Depraved", "Inquisitor", "Gargon", "Sinrunner", "Dredwing", "Bat" } },
    { label = "Maldraxxus",             maps = { 1536 },       keywords = { "Fleshbeast", "Warstitched", "Corpsefly", "Bonehoof", "Slime", "Gorger" } },
    { label = "Ardenweald",             maps = { 1565 },       keywords = { "Wildseed", "Wildling", "Winterpelt", "Swarmite", "Gorm", "Stag", "Dreamlight" }, tags = { "nature" } },
    { label = "The Maw / Korthia",      maps = { 1543, 1961 }, keywords = { "Maw", "Mawsworn", "Korthian", "Shadehound", "Soulbound" } },
    { label = "Zereth Mortis",          maps = { 1970 },       keywords = { "Zereth", "Protoform", "Vespoid", "Silken", "Resonant", "Cypher" } },

    -- Midnight (map IDs from guide /way coordinates; confirm with /zmount where)
    { label = "Silvermoon City",        maps = { 2393 },       tags = { "bird", "gold", "red", "royal", "arcane" } },
    { label = "Eversong Woods",         maps = { 2395 },       tags = { "bird", "red", "gold", "arcane", "fire" } },
    { label = "Isle of Quel'Danas",     maps = { 122 },        tags = { "holy", "gold", "bird", "fire" } },
    { label = "Zul'Aman",               maps = { 2437 },       tags = { "bear", "bird", "raptor", "nature", "green" } },
    { label = "Harandar",               maps = { 2413 },       tags = { "nature", "green", "snail", "insect", "pink" } },
    { label = "Voidstorm",              maps = { 2405 },       tags = { "void", "arcane", "purple", "cat", "ray" } },

    -- Dragonflight
    { label = "Dragon Isles",           maps = { 1978 },       keywords = { "Drake", "Velocidrake", "Wylderdrake", "Highland", "Dracthyr", "Dragonrider" } },
    { label = "Waking Shores",          maps = { 2022 },       tags = { "fire", "drake", "red" } },
    { label = "Ohn'ahran Plains",       maps = { 2023 },       tags = { "nature", "bird", "stag", "green" } },
    { label = "Azure Span",             maps = { 2024 },       tags = { "blue", "otter", "ice", "rhino" } },
    { label = "Thaldraszus",            maps = { 2025 },       tags = { "bronze", "time", "drake", "gold" } },
    { label = "Forbidden Reach",        maps = { 2151 },       tags = { "stone", "drake", "ice", "raptor" } },
    { label = "Zaralek Cavern",         maps = { 2133 },       tags = { "stone", "fire", "drake", "insect" } },
    { label = "Emerald Dream",          maps = { 2200 },       keywords = { "Dream", "Emerald", "Wildseed", "Verdant" }, tags = { "nature", "green" } },
    { label = "Amirdrassil",            maps = { 2239 },       tags = { "nature", "green", "drake" } },

    -- The War Within
    { label = "Khaz Algar",             maps = { 2274 },       keywords = { "Earthen", "Skyskimmer", "Delver", "Stonevault", "Cavern", "Armadillo", "Dornogal" } },
    { label = "Isle of Dorn",           maps = { 2248 },       tags = { "stone", "rhino", "sea", "mech" } },
    { label = "The Ringing Deeps",      maps = { 2214 },       tags = { "stone", "insect", "mech", "fire" } },
    { label = "Hallowfall",             maps = { 2215 },       tags = { "holy", "arcane", "mech", "white" } },
    { label = "K'aresh",                maps = { 2371 },       tags = { "void", "arcane", "insect", "bird", "purple" } },
    { label = "Azj-Kahet",              maps = { 2255 },       keywords = { "Spider", "Nerubian", "Weaver", "Web", "Skitter", "Carapace", "Arachnid" } },
    { label = "Undermine",              maps = { 2346 },       keywords = { "Goblin", "Trike", "Bruiser", "Rocket", "Steamwheedle", "Bilgewater", "Venture", "Jalopy", "Chopper", "Mechacycle" } },
}
