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

-- Tag overlap counts 2 each; a name-keyword hit counts 1.
local function Score(name, theme)
    local score = 0
    if theme.tags then
        local tags = ns.TagsFor(name)
        for _, t in ipairs(theme.tags) do
            if tags[t] then score = score + 2 end
        end
    end
    if theme.keywords then
        local lname = name:lower()
        for _, kw in ipairs(theme.keywords) do
            if lname:find(kw:lower(), 1, true) then score = score + 1 break end
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
            local s = theme and Score(name, theme) or 0
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
local function TagString(mountName)
    local list = {}
    for tag in pairs(ns.TagsFor(mountName)) do list[#list + 1] = tag end
    table.sort(list)
    return table.concat(list, ", ")
end

local function DecorateRow(frame, data)
    local mountID = data and (data.mountID or (data.index and C_MountJournal.GetDisplayedMountID(data.index))) or frame.mountID
    if not mountID then return end
    local mountName = C_MountJournal.GetMountInfoByID(mountID)
    if not mountName then return end
    frame.zmTagText = TagString(mountName)

    if not frame.zmFS then
        frame.zmFS = frame:CreateFontString(nil, "OVERLAY", "GameFontDisableSmall")
        frame.zmFS:SetPoint("BOTTOMLEFT", frame, "BOTTOMLEFT", 44, 4)
        frame.zmFS:SetJustifyH("LEFT")
    end
    local twoLines = frame.name and frame.name.GetNumLines and frame.name:GetNumLines() > 1
    frame.zmFS:SetText(frame.zmTagText)
    frame.zmFS:SetShown(not twoLines and frame.zmTagText ~= "")

    if not frame.zmHooked then
        frame.zmHooked = true
        frame:HookScript("OnEnter", function(self)
            if self.zmTagText and self.zmTagText ~= "" and GameTooltip:IsShown() then
                GameTooltip:AddLine("Tags: " .. self.zmTagText, 0.4, 0.8, 1, true)
                GameTooltip:Show()
            end
        end)
    end
end

local function HookJournal()
    if ns.journalHooked or not MountJournal or not MountJournal.ScrollBox then return end
    ns.journalHooked = true
    ScrollUtil.AddInitializedFrameCallback(MountJournal.ScrollBox, DecorateRow, ns, true)
end

local ev = CreateFrame("Frame")
ev:RegisterEvent("ADDON_LOADED")
ev:SetScript("OnEvent", function(_, _, name)
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
