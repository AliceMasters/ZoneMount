local _, ns = ...

-- Word -> look tags. A mount gets every tag whose words appear in its name (worth 2)
-- or in its journal description (worth 1). Add words here to teach the addon.
ns.tagRules = {
    -- looks / themes
    green   = { "Green", "Emerald", "Verdant", "Jade", "Moss", "Leaf", "Wildseed", "Forest", "Swamp", "Sprout", "Lush" },
    nature  = { "Wild", "Verdant", "Emerald", "Dream", "Leaf", "Bloom", "Blossom", "Moss", "Forest", "Tree", "Ancient", "Grove", "Treant", "Sprout", "Flower", "Druid", "Cenarion", "Elderhorn", "Lush", "Amirdrassil", "Nature", "Vine", "Thorn", "Mushroom", "Fungal" },
    fire    = { "Fire", "Flame", "Ember", "Molten", "Cinder", "Phoenix", "Infernal", "Magma", "Inferno", "Smolder", "Blazing", "Burning", "Lava", "Flaming" },
    fel     = { "Fel", "Felblood", "Felsaber", "Demon", "Hellfire", "Infernal", "Eredar", "Legion", "Demonic" },
    ice     = { "Frost", "Ice", "Icy", "Snow", "Winter", "Glacial", "Arctic", "Frozen", "Icewing", "Frostbrood" },
    undead  = { "Bone", "Skeletal", "Deathcharger", "Spectral", "Ghost", "Undead", "Plague", "Rotting", "Fleshbeast", "Wraith", "Warstitched", "Gloomcharger", "Necrotic", "Scourge", "Lich", "Death" },
    sea     = { "Sea", "Seahorse", "Abyssal", "Manta", "Kelp", "Tidal", "Azshari", "Pearl", "Nazjatar", "Ocean", "Naga", "Murloc", "Coral" },
    desert  = { "Sand", "Dune", "Desert", "Qiraji", "Mirage", "Sun", "Sandstone", "Dust" },
    mech    = { "Mecha", "Mechanostrider", "Trike", "Chopper", "Rocket", "Steam", "Clockwork", "Goblin", "Gnomish", "Jalopy", "Bruiser", "Rustbolt", "Mechanical", "Robot", "Engineer", "Gear", "Cogwheel" },
    arcane  = { "Arcane", "Mana", "Ley", "Nightborne", "Astral", "Cosmic", "Star", "Magic", "Magical", "Enchanted", "Crystal" },
    holy    = { "Light", "Lightforged", "Holy", "Argent", "Golden", "Phalynx", "Larion", "Aspirant", "Celestial", "Naaru", "Divine", "Sacred" },
    void    = { "Void", "Shadow", "Twilight", "Nether", "Maw", "Mawsworn", "Dark", "Darkness" },
    storm   = { "Storm", "Thunder", "Lightning", "Tempest", "Stormwind", "Cloud", "Wind" },
    stone   = { "Stone", "Rock", "Obsidian", "Earthen", "Granite", "Boulder", "Earth" },
    royal   = { "Royal", "Regal", "Imperial", "Royal", "King", "Queen", "Noble", "Admiralty", "Crowned" },
    -- colors
    blue    = { "Blue", "Azure", "Sapphire", "Cobalt", "Cyan" },
    red     = { "Red", "Crimson", "Scarlet", "Ruby", "Blood", "Bloodthirsty" },
    black   = { "Black", "Onyx", "Obsidian", "Midnight", "Ebon", "Raven" },
    white   = { "White", "Albino", "Ivory", "Pale", "Snowy", "Silver" },
    purple  = { "Purple", "Violet", "Amethyst", "Lavender" },
    gold    = { "Gold", "Golden", "Amber", "Brass" },
    -- creatures
    drake   = { "Drake", "Proto-Drake", "Velocidrake", "Wylderdrake", "Dragon", "Wyrm", "Windborne", "Dragonhawk" },
    bear    = { "Bear", "Ursine", "Ursoc" },
    gryphon = { "Gryphon", "Griffin" },
    cat     = { "Saber", "Sabre", "Sabertooth", "Tiger", "Panther", "Lion", "Cat", "Cheetah", "Lynx", "Nightsaber", "Manasaber", "Feline", "Cougar" },
    bird    = { "Hawk", "Owl", "Raven", "Crow", "Eagle", "Parrot", "Hawkstrider", "Roc", "Windrider", "Bird", "Peacock", "Phoenix", "Swan", "Crane" },
    bat     = { "Bat", "Bloodwing", "Batwing" },
    boar    = { "Boar", "Warboar", "Hog", "Pig" },
    ram     = { "Ram", "Goat", "Yak", "Sheep" },
    kodo    = { "Kodo" },
    elekk   = { "Elekk" },
    rhino   = { "Rhino", "Clefthoof", "Thunderhoof" },
    horse   = { "Horse", "Stallion", "Steed", "Mare", "Charger", "Palomino", "Warhorse", "Pony", "Destrier" },
    stag    = { "Stag", "Deer", "Elk", "Moose", "Antler", "Antlered", "Hippogryph" },
    wolf    = { "Wolf", "Warg", "Hound", "Frostwolf", "Gloomhound", "Dog" },
    raptor  = { "Raptor", "Devilsaur", "Pterrordax", "Dinosaur", "Direhorn" },
    turtle  = { "Turtle", "Tortoise" },
    serpent = { "Serpent", "Snake", "Cobra", "Hydra", "Worm", "Wyvern", "Basilisk" },
    spider  = { "Spider", "Nerubian", "Weaver", "Web", "Arachnid", "Scorpion" },
    insect  = { "Bee", "Wasp", "Beetle", "Moth", "Butterfly", "Mantis", "Scarab", "Dragonfly", "Silithid", "Weevil", "Locust", "Insect", "Ant" },
    crab    = { "Crab", "Lobster" },
    flying  = { "Flying", "Wings", "Soar", "Skyward" },
}

-- mountTypeID -> tag (from C_MountJournal.GetMountInfoExtraByID)
ns.typeTags = {
    [231] = "sea", [232] = "sea", [254] = "sea",
}

-- Exact-name fixes where the name misleads.
-- ns.tagOverrides["Mount Name"] = { "tag", ... }  (replaces everything derived)
ns.tagOverrides = {}

local function Normalize(s)
    return " " .. (s:lower():gsub("[^%w']", " ")) .. " "
end

-- Word-start match; words shorter than 4 letters (red, sea, ice, ram...) must be a whole word.
-- So "red" does not match "Armored" and "sea" does not match "Seabraid".
local function Has(normalized, word)
    local w = word:lower():gsub("[^%w']", " ")
    if #w < 4 then return normalized:find(" " .. w .. " ", 1, true) ~= nil end
    return normalized:find(" " .. w, 1, true) ~= nil
end

function ns.NameHas(name, word)
    return Has(Normalize(name), word)
end

local cache = {}

-- Returns { tag = weight } (name hit = 2, description / type hit = 1).
function ns.TagsFor(name, mountID)
    local key = mountID or name
    if cache[key] then return cache[key] end
    local tags = {}
    if ns.tagOverrides[name] then
        for _, t in ipairs(ns.tagOverrides[name]) do tags[t] = 2 end
    else
        local nname = Normalize(name)
        local ndesc, mtype = "", nil
        if mountID then
            local _, desc, _, _, typeID = C_MountJournal.GetMountInfoExtraByID(mountID)
            ndesc, mtype = Normalize(desc or ""), typeID
        end
        for tag, words in pairs(ns.tagRules) do
            for _, w in ipairs(words) do
                if Has(nname, w) then tags[tag] = 2 break end
            end
            if not tags[tag] then
                for _, w in ipairs(words) do
                    if Has(ndesc, w) then tags[tag] = 1 break end
                end
            end
        end
        local tt = mtype and ns.typeTags[mtype]
        if tt and not tags[tt] then tags[tt] = 1 end
    end
    cache[key] = tags
    return tags
end
