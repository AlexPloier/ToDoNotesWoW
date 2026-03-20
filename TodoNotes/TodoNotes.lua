TodoNotesDB = TodoNotesDB or {}

-- SET LOCAL VARS
local backgrounds = {
    "Interface/AddOns/TodoNotes/Logos/AddonBackground1",
    "Interface/AddOns/TodoNotes/Logos/Banane",
    "Interface/AddOns/TodoNotes/Logos/Cat",
    "Interface/AddOns/TodoNotes/Logos/Friendlyframes",
    "Interface/AddOns/TodoNotes/Logos/Germknedl",
    "Interface/AddOns/TodoNotes/Logos/Kipferl",
    "Interface/AddOns/TodoNotes/Logos/Leberkas",
    "Interface/AddOns/TodoNotes/Logos/Tomate"
}
local fontSize = 14
local lineSpacing = 0
local lineHeight = fontSize + lineSpacing

-- CREATE FRAME
local frame = CreateFrame("Frame", "TodoNotesFrame", UIParent, "BackdropTemplate")
frame:SetSize(420, 840)
frame:SetPoint("CENTER")


local bg1 = frame:CreateTexture(nil, "BACKGROUND")
bg1:SetAllPoints()
bg1:SetTexture("Interface/DialogFrame/UI-DialogBox-Background")


local bg2 = frame:CreateTexture(nil, "BORDER")
bg2:SetSize(256, 256)
bg2:SetPoint("CENTER")



frame:SetMovable(true)
frame:EnableMouse(true)
frame:RegisterForDrag("LeftButton")
frame:SetScript("OnDragStart", frame.StartMoving)
frame:SetScript("OnDragStop", frame.StopMovingOrSizing)

-- TITEL BAR
local titleBar = CreateFrame("Frame", nil, frame, "BackdropTemplate")
titleBar:SetHeight(28)
titleBar:SetPoint("TOPLEFT", 4, -4)
titleBar:SetPoint("TOPRIGHT", -4, -4)

titleBar:SetBackdrop({
    bgFile = "Interface/Buttons/WHITE8x8"
})
titleBar:SetBackdropColor(0.1, 0.1, 0.1, 1)

titleBar:EnableMouse(true)
titleBar:RegisterForDrag("LeftButton")

titleBar:SetScript("OnDragStart", function()
    frame:StartMoving()
end)

titleBar:SetScript("OnDragStop", function()
    frame:StopMovingOrSizing()
end)

local title = titleBar:CreateFontString(nil, "OVERLAY", "GameFontNormal")
title:SetPoint("CENTER")
title:SetText("Todo Notes")

local close = CreateFrame("Button", nil, frame, "UIPanelCloseButton")
close:SetPoint("TOPRIGHT", -4, -4)

-- SCROLLFRAME
local scroll = CreateFrame("ScrollFrame", nil, frame, "UIPanelScrollFrameTemplate")
scroll:SetPoint("TOPLEFT", 15, -45)
scroll:SetPoint("BOTTOMRIGHT", -35, 15)
scroll:SetScript("OnMouseWheel", function(self, delta)

    local current = self:GetVerticalScroll()
    local step = lineHeight

    if delta > 0 then
        current = current - step
    else
        current = current + step
    end

    local maxScroll = self:GetVerticalScrollRange()

    if current < 0 then
        current = 0
    elseif current > maxScroll then
        current = maxScroll
    end

    self:SetVerticalScroll(current)

end)

scroll:EnableMouseWheel(true)
local editBox = CreateFrame("EditBox", nil, scroll)

editBox:SetMultiLine(true)
editBox:SetFontObject(ChatFontNormal)
editBox:SetWidth(350)
editBox:SetHeight(1200)
editBox:SetAutoFocus(false)
editBox:SetJustifyV("TOP")

editBox:SetTextInsets(2, 2, 2, 2)


editBox:SetFont("Fonts\\FRIZQT__.TTF", fontSize, "")
editBox:SetSpacing(lineSpacing)

scroll:SetScrollChild(editBox)

editBox:SetScript("OnEscapePressed", editBox.ClearFocus)

editBox:SetScript("OnTextChanged", function(self)
    TodoNotesDB.text = self:GetText()
end)

-- EVENT HANDLING
frame:RegisterEvent("PLAYER_LOGIN")
frame:SetScript("OnEvent", function()
    bg2:SetTexture(backgrounds[1])
    bg2:SetAlpha(0.1)
    if TodoNotesDB.text then
        editBox:SetText(TodoNotesDB.text)
    end
end)

-- SLASH CALL
SLASH_TODONOTES1 = "/todo"
SlashCmdList["TODONOTES"] = function()
    if not frame:IsShown() then
        local index = random(#backgrounds)
        bg2:SetTexture(backgrounds[index])
        bg2:SetAlpha(0.6)
    end

    frame:SetShown(not frame:IsShown())
end