local _, ns = ...

-- Name-substring -> look tags. A mount gets every tag whose keywords appear in its name.
-- Add words here to teach the addon what mounts look like.
ns.tagRules = {
    green   = { "Green", "Emerald", "Verdant", "Jade", "Moss", "Leaf", "Wildseed", "Forest", "Swamp", "Sprout", "Lush" },
    nature  = { "Wild", "Verdant", "Emerald", "Dream", "Leaf", "Bloom", "Blossom", "Moss", "Forest", "Tree", "Ancient", "Grove", "Treant", "Sprout", "Flower", "Stag", "Antler", "Hippogryph", "Druid", "Cenarion", "Elderhorn", "Winterpelt", "Lush", "Amirdrassil" },
    drake   = { "Drake", "Proto-Drake", "Velocidrake", "Wylderdrake", "Dragon", "Wyrm", "Windborne" },
    fire    = { "Fire", "Flame", "Ember", "Molten", "Cinder", "Phoenix", "Infernal", "Magma", "Inferno", "Smolder", "Blazing" },
    fel     = { "Fel", "Felblood", "Demon", "Hellfire", "Infernal", "Eredar" },
    ice     = { "Frost", "Ice", "Icy", "Snow", "Winter", "Glacial", "Arctic", "Frozen", "Yeti", "Mammoth" },
    undead  = { "Bone", "Skeletal", "Deathcharger", "Spectral", "Ghost", "Undead", "Plague", "Rotting", "Fleshbeast", "Wraith", "Warstitched", "Gloomcharger" },
    sea     = { "Sea", "Seahorse", "Turtle", "Abyssal", "Manta", "Kelp", "Tidal", "Azshari", "Pearl", "Nazjatar" },
    desert  = { "Sand", "Dune", "Scarab", "Camel", "Desert", "Qiraji", "Mirage", "Sun" },
    mech    = { "Mecha", "Mechanostrider", "Trike", "Chopper", "Rocket", "Steam", "Clockwork", "Goblin", "Gnomish", "Jalopy", "Bruiser", "Rustbolt" },
    arcane  = { "Arcane", "Mana", "Ley", "Nightborne", "Astral", "Cosmic", "Star" },
    holy    = { "Light", "Lightforged", "Holy", "Argent", "Golden", "Phalynx", "Larion", "Aspirant", "Celestial" },
    void    = { "Void", "Shadow", "Twilight", "Nether", "Maw", "Mawsworn" },
    spider  = { "Spider", "Nerubian", "Weaver", "Web", "Arachnid" },
    raptor  = { "Raptor", "Devilsaur", "Pterrordax" },
    horse   = { "Horse", "Stallion", "Steed", "Mare", "Charger", "Palomino" },
    wolf    = { "Wolf", "Warg", "Hound", "Frostwolf" },
    blue    = { "Blue", "Azure", "Sapphire", "Cobalt" },
    red     = { "Red", "Crimson", "Scarlet", "Ruby" },
    black   = { "Black", "Onyx", "Obsidian", "Midnight" },
    white   = { "White", "Albino", "Ivory", "Pale" },
    purple  = { "Purple", "Violet", "Amethyst" },
    gold    = { "Gold", "Golden", "Amber" },
}

-- Exact-name fixes where the name misleads (e.g. "Highland Drake" is green/nature-ish).
-- ns.tagOverrides["Mount Name"] = { "tag", ... }  (replaces rule-derived tags)
ns.tagOverrides = {}

local function Normalize(s)
    return " " .. (s:lower():gsub("[^%w']", " ")) .. " "
end

-- Word-start match; words shorter than 4 letters (red, sea, ice, ram...) must be a whole word.
-- So "red" does not match "Armored" and "sea" does not match "Seabraid".
function ns.NameHas(name, word)
    local n, w = Normalize(name), word:lower():gsub("[^%w']", " ")
    if #w < 4 then return n:find(" " .. w .. " ", 1, true) ~= nil end
    return n:find(" " .. w, 1, true) ~= nil
end

local cache = {}
function ns.TagsFor(name)
    if cache[name] then return cache[name] end
    local tags
    if ns.tagOverrides[name] then
        tags = {}
        for _, t in ipairs(ns.tagOverrides[name]) do tags[t] = true end
    else
        tags = {}
        for tag, words in pairs(ns.tagRules) do
            for _, w in ipairs(words) do
                if ns.NameHas(name, w) then tags[tag] = true break end
            end
        end
    end
    cache[name] = tags
    return tags
end
