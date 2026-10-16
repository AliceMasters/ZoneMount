local _, ns = ...

-- Word -> look tags. A mount gets every tag whose words appear in its name (worth 2)
-- or in its journal description (worth 1). Add words here to teach the addon.
ns.tagRules = {
    -- looks / themes
    green   = { "Green", "Emerald", "Verdant", "Jade", "Moss", "Leaf", "Wildseed", "Forest", "Swamp", "Sprout", "Lush" },
    nature  = { "Wild", "Verdant", "Emerald", "Dream", "Leaf", "Bloom", "Blossom", "Moss", "Forest", "Tree", "Ancient", "Grove", "Treant", "Sprout", "Flower", "Druid", "Cenarion", "Elderhorn", "Lush", "Amirdrassil", "Nature", "Vine", "Thorn", "Mushroom", "Fungal", "Snapvine", "Sporeglider", "Gladechewer", "Arboreal", "Bramblewing", "Heartsbane", "Pseudoshell", "Rufflefur", "Petalwing", "Mushan", "Quilen", "Pango", "Panda", "Spring", "Autumn", "Harvest", "Grove", "Rootstalker", "Wild" },
    fire    = { "Fire", "Flame", "Ember", "Molten", "Cinder", "Phoenix", "Infernal", "Magma", "Inferno", "Smolder", "Blazing", "Burning", "Lava", "Flaming" },
    fel     = { "Fel", "Felsteed", "Dreadsteed", "Felblood", "Felsaber", "Demon", "Hellfire", "Infernal", "Eredar", "Legion", "Demonic", "Doomhawk", "Felbroken", "Fel-Scarred", "Hexflame", "Warstrider", "Gronnling" },
    ice     = { "Frost", "Ice", "Icy", "Snow", "Winter", "Glacial", "Arctic", "Frozen", "Icewing", "Frostbrood", "Tundra", "Mammoth", "Icehoof", "Coldsnout", "Yeti", "Wintry" },
    undead  = { "Bone", "Skeletal", "Deathcharger", "Spectral", "Ghost", "Undead", "Plague", "Rotting", "Fleshbeast", "Wraith", "Warstitched", "Gloomcharger", "Necrotic", "Scourge", "Lich", "Death", "Soul Eater", "Reaver", "Necroray", "Gravestone", "Dreadwing", "Dreadwake", "Witchwick", "Scythemaw", "Eve's Ghastly" },
    sea     = { "Sea", "Seahorse", "Abyssal", "Manta", "Kelp", "Tidal", "Azshari", "Pearl", "Nazjatar", "Ocean", "Naga", "Murloc", "Coral", "Aurelid", "Gulper", "Riverbeast", "Riverwallow", "Trawling", "Sharkbait", "Bilgewater", "Kah" },
    desert  = { "Sand", "Dune", "Desert", "Qiraji", "Mirage", "Sun", "Sandstone", "Dust", "Camel", "Marsh Hopper" },
    mech    = { "Mecha", "Mechanostrider", "Trike", "Chopper", "Rocket", "Steam", "Clockwork", "Goblin", "Gnomish", "Jalopy", "Bruiser", "Rustbolt", "Mechanical", "Robot", "Engineer", "Gear", "Cogwheel", "Heartbreaker", "Jumpjets", "Magnetomech", "Shreddertank", "Treadblade", "Bunmover", "Motocross", "Dirigible", "Fleetpod", "Launcher", "Compass Rose", "Defense Unit", "Bombardier", "Chariot", "Prototype", "Juggernaut", "Magnet", "X-45" },
    arcane  = { "Arcane", "Mana", "Ley", "Nightborne", "Astral", "Cosmic", "Star", "Magic", "Magical", "Enchanted", "Crystal", "Aquilon", "Quilen", "Shimmering", "Shimmermist", "Luminous", "Prismatic", "Imagiwing", "Salatrancer", "Ineffable", "Cryptic", "Protostag", "Elysian", "Pureheart", "Radiant", "Resplendent", "Anointed" },
    holy    = { "Light", "Lightforged", "Holy", "Argent", "Golden", "Phalynx", "Larion", "Aspirant", "Celestial", "Naaru", "Divine", "Sacred", "Elysian", "Heartlight", "Aquilon", "Pureheart", "Anointed", "Radiant", "Resplendent", "Ascended", "Heartbond" },
    void    = { "Void", "Shadow", "Twilight", "Nether", "Maw", "Mawsworn", "Dark", "Darkness" },
    storm   = { "Storm", "Thunder", "Lightning", "Tempest", "Stormwind", "Cloud", "Wind", "Skyreaver", "Thunder" },
    stone   = { "Stone", "Rock", "Obsidian", "Earthen", "Granite", "Boulder", "Earth" },
    royal   = { "Royal", "Regal", "Imperial", "Royal", "King", "Queen", "Noble", "Admiralty", "Crowned" },
    -- colors
    blue    = { "Blue", "Azure", "Sapphire", "Cobalt", "Cyan", "Cerulean", "Beryl", "Aquamarine", "Indigo" },
    red     = { "Red", "Crimson", "Scarlet", "Ruby", "Blood", "Bloodthirsty" },
    black   = { "Black", "Onyx", "Obsidian", "Midnight", "Ebon", "Raven" },
    white   = { "White", "Albino", "Ivory", "Pale", "Snowy", "Silver" },
    purple  = { "Purple", "Violet", "Amethyst", "Lavender" },
    gold    = { "Gold", "Golden", "Amber", "Brass" },
    -- creatures
    drake   = { "Drake", "Proto-Drake", "Velocidrake", "Wylderdrake", "Dragon", "Wyrm", "Windborne", "Dragonhawk" },
    bear    = { "Bear", "Ursine", "Ursoc" },
    gryphon = { "Gryphon", "Griffin" },
    cat     = { "Saber", "Sabre", "Sabertooth", "Tiger", "Panther", "Lion", "Cat", "Cheetah", "Lynx", "Nightsaber", "Manasaber", "Feline", "Cougar", "Moonsaber", "Warsaber", "Frostsaber", "Grimlynx", "Prowler", "Shredclaw", "Prideclaw", "Skyclaw", "Panthara", "Lynx", "Furline", "Vombata" },
    bird    = { "Hawk", "Owl", "Raven", "Crow", "Eagle", "Parrot", "Hawkstrider", "Roc", "Windrider", "Bird", "Peacock", "Phoenix", "Swan", "Crane", "Skyscreamer", "Direbeak", "Shrieker", "Screecher", "Kite", "Petalwing", "Peafowl", "Turkey", "Warturkey", "Sporeglider", "Skyfriend", "Chimaera" },
    bat     = { "Bat", "Bloodwing", "Batwing" },
    boar    = { "Boar", "Warboar", "Hog", "Pig", "Hogrus", "Harvesthog", "Coldsnout", "Greytusk", "Irontusk", "Hellboar", "Swine" },
    ram     = { "Ram", "Goat", "Yak", "Sheep" },
    kodo    = { "Kodo" },
    elekk   = { "Elekk" },
    rhino   = { "Rhino", "Clefthoof", "Thunderhoof", "Razorback", "Mauler", "Cragstepper", "Crest-Horn", "Longhorn", "Scythehorn", "Tauralus", "Bakar", "Triceratops", "Tuskaar", "Ottuk", "Chloroceros", "Bull", "Courser" },
    horse   = { "Horse", "Stallion", "Steed", "Mare", "Charger", "Palomino", "Warhorse", "Pony", "Destrier", "Strider", "Courser", "Skymane", "Runner", "Free Runner", "Zhevra", "Donkey", "Mule", "Bronco", "Duskrunner", "Ruinstrider", "Shorestrider", "Breezestrider", "Moonbeast", "Phase-Hunter" },
    stag    = { "Stag", "Deer", "Elk", "Moose", "Antler", "Antlered", "Hippogryph" },
    wolf    = { "Wolf", "Warg", "Hound", "Frostwolf", "Gloomhound", "Dog", "Warwolf", "Direwolf", "Lupine", "Warhound", "Snarler", "Nighthowl", "Fox" },
    raptor  = { "Raptor", "Devilsaur", "Pterrordax", "Dinosaur", "Direhorn", "Brutosaur", "Ravasaur", "Pterrorwing", "Stegosaur", "Dinosaur" },
    turtle  = { "Turtle", "Tortoise" },
    serpent = { "Serpent", "Snake", "Cobra", "Hydra", "Worm", "Wyvern", "Basilisk", "Warserpent", "Coiler", "Horror", "Venomfang", "Snapdragon", "Crocolisk", "Eel", "Shark", "Jawcrawler", "Slyvern", "Leystrider" },
    spider  = { "Spider", "Nerubian", "Weaver", "Web", "Arachnid", "Scorpion" },
    insect  = { "Bee", "Wasp", "Beetle", "Moth", "Butterfly", "Mantis", "Scarab", "Dragonfly", "Silithid", "Weevil", "Locust", "Insect", "Ant", "Corpsefly", "Drone", "Swarmer", "Swarmite", "Animite", "Glowmite", "Gladechewer", "Skyflayer", "Skyterror", "Hivemind", "Helicid", "Worldsnail", "Pseudoshell", "Skitterer", "Parasite", "Devourer", "Mimic", "Leafmimic" },
    crab    = { "Crab", "Lobster" },
    mammoth = { "Mammoth", "Tuskarr", "Ottuk", "Brontosaur", "Woolly", "Wooly" },
    camel   = { "Camel", "Talbuk", "Mushan", "Yak", "Quilen", "Riverbeast", "Pango", "Pangolin" },
    frog    = { "Frog", "Croaker", "Toad", "Bufonid", "Hopper" },
    lizard  = { "Lizard", "Snaplizard", "Gecko", "Gorger", "Coiler", "Crocolisk" },
    snail   = { "Snail", "Slug", "Helicid", "Worldsnail", "Pseudoshell", "Ghastropod" },
    ray     = { "Ray", "Stormray", "Mana Ray", "Nether Ray", "Aurelid", "Necroray", "Skyray" },
    rabbit  = { "Rabbit", "Bunny", "Rabbit'ath", "Bunmover" },
    venom   = { "Venom", "Venomous", "Venomfang", "Venomhide", "Poison", "Acid", "Biletooth", "Caustic", "Blight", "Parasite" },
    demonic = { "Gargon", "Gorm", "Dreadwing", "Felbroken", "Infernal", "Doomhawk", "Hexflame", "Fleshripper" },
    flying  = { "Flying", "Wings", "Soar", "Skyward" },
}

-- mountTypeID -> tag (from C_MountJournal.GetMountInfoExtraByID)
ns.typeTags = {
    [231] = "sea", [232] = "sea", [254] = "sea",
}

-- Descriptions are lore and noisy, so only these tags may come from a description.
ns.descSafe = {}
for t in ("bear gryphon bird bat boar ram kodo elekk rhino horse stag wolf raptor turtle serpent spider insect "
        .. "crab mammoth camel frog lizard snail ray rabbit fire ice undead sea desert mech fel"):gmatch("%S+") do
    ns.descSafe[t] = true
end

-- Shipped per-mountID tags (Data.lua): "strong strong ~weak". Language-independent.
ns.mountTags = ns.mountTags or {}

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
    elseif mountID and ns.mountTags[mountID] then
        for tok in ns.mountTags[mountID]:gmatch("%S+") do
            if tok:sub(1, 1) == "~" then tags[tok:sub(2)] = 1 else tags[tok] = 2 end
        end
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
            if not tags[tag] and ns.descSafe[tag] then
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
