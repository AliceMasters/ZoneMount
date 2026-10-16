local ADDON, ns = ...

local mapToTheme = {}
for _, theme in ipairs(ns.themes) do
    for _, mapID in ipairs(theme.maps) do mapToTheme[mapID] = theme end
end

BINDING_HEADER_ZONEMOUNT = "Zone Mount"
BINDING_NAME_ZONEMOUNT_SUMMON = "Summon zone-appropriate mount"

local function print_(msg) print("|cff66ccffZoneMount:|r " .. msg) end

-- Walk from the player's current map up through its parents.
local function MapChain()
    local chain = {}
    local mapID = C_Map.GetBestMapForUnit("player")
    while mapID and mapID > 0 do
        local info = C_Map.GetMapInfo(mapID)
        chain[#chain + 1] = { id = mapID, name = info and info.name or "?" }
        mapID = info and info.parentMapID
    end
    return chain
end

-- Themes along the chain, most specific first.
local function ThemesForLocation()
    local found = {}
    for _, m in ipairs(MapChain()) do
        if mapToTheme[m.id] then found[#found + 1] = mapToTheme[m.id] end
    end
    return found
end

-- A tag matched in the name counts 2, in the description 1; a name-keyword hit counts 1.
local function Score(name, mountID, theme)
    local score = 0
    if theme.tags then
        local tags = ns.TagsFor(name, mountID)
        for _, t in ipairs(theme.tags) do
            score = score + (tags[t] or 0)
        end
    end
    if theme.keywords then
        for _, kw in ipairs(theme.keywords) do
            if ns.NameHas(name, kw) then score = score + 1 break end
        end
    end
    return score
end

-- Usable, collected mounts. With a theme, returns every mount that scores > 0,
-- best match first.
local function UsableMounts(theme)
    local out = {}
    for _, mountID in ipairs(C_MountJournal.GetMountIDs()) do
        local name, _, icon, _, isUsable, _, isFavorite, _, _, hidden, isCollected =
            C_MountJournal.GetMountInfoByID(mountID)
        if isCollected and isUsable and not hidden then
            local s = theme and Score(name, mountID, theme) or 0
            if not theme or s > 0 then
                out[#out + 1] = { id = mountID, name = name, icon = icon, fav = isFavorite, score = s }
            end
        end
    end
    table.sort(out, function(a, b) return a.score > b.score end)
    return out
end

-- Weighted random: weight = score^2, so great matches win often but others still appear.
local function WeightedPick(pool)
    local total = 0
    for _, m in ipairs(pool) do total = total + m.score * m.score end
    local roll = math.random() * total
    for _, m in ipairs(pool) do
        roll = roll - m.score * m.score
        if roll <= 0 then return m end
    end
    return pool[#pool]
end

local function Pick()
    for _, theme in ipairs(ThemesForLocation()) do
        local pool = UsableMounts(theme)
        if #pool > 0 then return WeightedPick(pool), theme.label end
    end
    local pool = UsableMounts()
    local favs = {}
    for _, m in ipairs(pool) do if m.fav then favs[#favs + 1] = m end end
    if #favs > 0 then pool = favs end
    if #pool > 0 then return pool[math.random(#pool)], nil end
end

function ZoneMount_Summon()
    if IsMounted() then C_MountJournal.Dismiss() return end
    if InCombatLockdown() then print_("Can't mount in combat.") return end
    local mount, label = Pick()
    if not mount then print_("No usable mounts here.") return end
    C_MountJournal.SummonByID(mount.id)
    print_(mount.name .. (label and (" |cff999999(" .. label .. ")|r") or " |cff999999(no theme, favorite)|r"))
end

-- Floating button -----------------------------------------------------------
local btn = CreateFrame("Button", "ZoneMountButton", UIParent)
btn:SetSize(44, 44)
btn:SetPoint("CENTER", 0, -200)
btn:SetMovable(true)
btn:SetClampedToScreen(true)
btn:RegisterForDrag("LeftButton")
btn:RegisterForClicks("LeftButtonUp")
btn:SetScript("OnDragStart", function(self) if IsShiftKeyDown() then self:StartMoving() end end)
btn:SetScript("OnDragStop", function(self)
    self:StopMovingOrSizing()
    local p, _, rp, x, y = self:GetPoint()
    ZoneMountDB.pos = { p, rp, x, y }
end)
btn:SetScript("OnClick", ZoneMount_Summon)

btn.icon = btn:CreateTexture(nil, "ARTWORK")
btn.icon:SetAllPoints()
btn.icon:SetTexture(413588)
btn.icon:SetTexCoord(0.07, 0.93, 0.07, 0.93)
btn:SetHighlightTexture("Interface\\Buttons\\ButtonHilight-Square", "ADD")

btn:SetScript("OnEnter", function(self)
    GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
    GameTooltip:AddLine("Zone Mount")
    local themes = ThemesForLocation()
    GameTooltip:AddLine(themes[1] and ("Theme: " .. themes[1].label) or "No theme here; using favorites", 1, 1, 1)
    GameTooltip:AddLine("Shift-drag to move", 0.6, 0.6, 0.6)
    GameTooltip:Show()
end)
btn:SetScript("OnLeave", GameTooltip_Hide)

-- Tags in the mount journal ---------------------------------------------------
local function TagString(mountName, mountID)
    local list = {}
    for tag in pairs(ns.TagsFor(mountName, mountID)) do list[#list + 1] = tag end
    table.sort(list)
    return table.concat(list, ", ")
end

-- Display colors: colors are themselves, elements get their element's hue,
-- creatures fall back to a warm cream.
local TAG_COLORS = {
    red = "ff6b6b", blue = "6bb5ff", green = "7bdc6e", yellow = "ffe066", orange = "ffa94d",
    purple = "c792ea", pink = "ff9ecb", brown = "c49a6c", black = "b4b4c8", white = "f5f5f5",
    gray = "bcbcbc", gold = "ffd24a", bronze = "d9a05b", teal = "4fd1c5",
    fire = "ff7a3d", ice = "8fd8ff", nature = "8fdc7a", void = "a77bff", holy = "fff0a0",
    arcane = "c28bff", fel = "9bff3b", undead = "a9c98a", sea = "4fb3d9", storm = "9ac8ff",
    stone = "b3a58f", mech = "c0c8d0", time = "e0b36a", royal = "e6c35c", venom = "b6e03c",
    demonic = "ff5a5a", flying = "d0e4ff", desert = "e8c987",
}
local TAG_DEFAULT = "e6dcc3"

local function ColorTagString(mountName, mountID)
    local list = {}
    for tag in pairs(ns.TagsFor(mountName, mountID)) do list[#list + 1] = tag end
    table.sort(list)
    for i, tag in ipairs(list) do
        list[i] = ("|cff%s%s|r"):format(TAG_COLORS[tag] or TAG_DEFAULT, tag)
    end
    return table.concat(list, "|cff6a6a78  ·  |r")
end

local function DecorateRow(frame, data)
    local mountID = data and (data.mountID or (data.index and C_MountJournal.GetDisplayedMountID(data.index))) or frame.mountID
    if not mountID then return end
    local mountName = C_MountJournal.GetMountInfoByID(mountID)
    if not mountName then return end
    frame.zmTagText = ColorTagString(mountName, mountID)

    if not frame.zmFS then
        frame.zmFS = frame:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
        frame.zmFS:SetPoint("BOTTOMLEFT", frame, "BOTTOMLEFT", 44, 3)
        frame.zmFS:SetJustifyH("LEFT")
        frame.zmFS:SetWordWrap(false)
    end
    frame.zmFS:SetText(frame.zmTagText)
    frame.zmFS:SetShown(frame.zmTagText ~= "")

    if not frame.zmHooked then
        frame.zmHooked = true
        frame:HookScript("OnEnter", function(self)
            if self.zmTagText and self.zmTagText ~= "" and GameTooltip:IsShown() then
                GameTooltip:AddLine("|cff66ccffTags:|r " .. self.zmTagText, 1, 1, 1, true)
                GameTooltip:Show()
            end
        end)
    end
end

local function HookJournal()
    if ns.journalHooked or not MountJournal or not MountJournal.ScrollBox then return end
    ns.journalHooked = true
    local box = MountJournal.ScrollBox
    local function Refresh()
        box:ForEachFrame(function(frame)
            local data = frame.GetElementData and frame:GetElementData()
            DecorateRow(frame, data)
        end)
    end
    -- Frames are recycled on scroll/filter/search, so re-decorate on every change.
    box:RegisterCallback(ScrollBoxListMixin.Event.OnUpdate, Refresh, ns)
    box:RegisterCallback(ScrollBoxListMixin.Event.OnDataRangeChanged, Refresh, ns)
    MountJournal:HookScript("OnShow", Refresh)
    Refresh()
end

-- Dump every collected mount with its tags to SavedVariables so the tag rules can be
-- tuned against real data (read ZoneMount.lua in WTF\...\SavedVariables after logout).
local function ExportMounts()
    local out = {}
    for _, mountID in ipairs(C_MountJournal.GetMountIDs()) do
        local name, _, _, _, _, _, _, _, _, _, isCollected = C_MountJournal.GetMountInfoByID(mountID)
        if name then
            local _, desc, _, _, typeID = C_MountJournal.GetMountInfoExtraByID(mountID)
            out[#out + 1] = {
                id = mountID,
                owned = isCollected and true or false,
                name = name,
                tags = TagString(name, mountID),
                type = typeID,
                desc = desc and desc:sub(1, 200) or "",
            }
        end
    end
    ZoneMountDB.export = out
end

local ev = CreateFrame("Frame")
ev:RegisterEvent("ADDON_LOADED")
ev:RegisterEvent("PLAYER_LOGOUT")
ev:SetScript("OnEvent", function(_, event, name)
    if event == "PLAYER_LOGOUT" then
        if ZoneMountDB then pcall(ExportMounts) end
        return
    end
    if name == "Blizzard_Collections" then HookJournal() end
    if name ~= ADDON then return end
    if C_AddOns.IsAddOnLoaded("Blizzard_Collections") then HookJournal() end
    ZoneMountDB = ZoneMountDB or {}
    if ZoneMountDB.pos then
        btn:ClearAllPoints()
        btn:SetPoint(ZoneMountDB.pos[1], UIParent, ZoneMountDB.pos[2], ZoneMountDB.pos[3], ZoneMountDB.pos[4])
    end
    btn:SetShown(not ZoneMountDB.hidden)
end)

-- Slash commands ------------------------------------------------------------
SLASH_ZONEMOUNT1, SLASH_ZONEMOUNT2 = "/zmount", "/zonemount"
SlashCmdList.ZONEMOUNT = function(arg)
    arg = (arg or ""):lower()
    if arg == "where" then
        for _, m in ipairs(MapChain()) do
            print_(("%d  %s%s"):format(m.id, m.name, mapToTheme[m.id] and ("  -> " .. mapToTheme[m.id].label) or ""))
        end
    elseif arg == "list" then
        local themes = ThemesForLocation()
        if not themes[1] then print_("No theme for this location.") return end
        for _, m in ipairs(UsableMounts(themes[1])) do print_(("%s  (score %d)"):format(m.name, m.score)) end
    elseif arg == "hide" or arg == "show" then
        ZoneMountDB.hidden = (arg == "hide")
        btn:SetShown(not ZoneMountDB.hidden)
    else
        ZoneMount_Summon()
    end
end
