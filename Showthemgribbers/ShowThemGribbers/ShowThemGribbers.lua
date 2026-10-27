-- Settings: match these to your sprite sheet
local FRAME_COUNT = 60
local COLUMNS     = 8
local ROWS        = 8
local DURATION    = 4     -- 60 frames at 12 fps; use 4 for 15 fps, 2 for 30 fps
local CYCLES      = 2     -- how many times to play before hiding
local SIZE        = 250   -- animation size in pixels

-- Container frame
local f = CreateFrame("Frame", "ShowThemGribbersFrame", UIParent)
f:SetSize(SIZE, SIZE)
f:SetPoint("CENTER", UIParent, "CENTER", 0, 200)
f:SetFrameStrata("HIGH")
f:Hide()

-- Texture holding the sprite sheet (no file extension)
local tex = f:CreateTexture(nil, "ARTWORK")
tex:SetAllPoints()
tex:SetTexture("Interface\\AddOns\\ShowThemGribbers\\media\\gribbers")

-- Flipbook animation (plays once per Play() call)
local ag = tex:CreateAnimationGroup()
ag:SetLooping("NONE")

local flip = ag:CreateAnimation("FlipBook")
flip:SetFlipBookRows(ROWS)
flip:SetFlipBookColumns(COLUMNS)
flip:SetFlipBookFrames(FRAME_COUNT)
flip:SetDuration(DURATION)

-- Count completed cycles; replay until we've done enough
local played = 1
ag:SetScript("OnFinished", function(self, requested)
    if requested then return end   -- stopped manually (mailbox closed)
    played = played + 1
    if played < CYCLES then
        self:Play()
    else
        f:Hide()
    end
end)

-- Show/hide with the mailbox
f:RegisterEvent("MAIL_SHOW")
f:RegisterEvent("MAIL_CLOSED")
f:SetScript("OnEvent", function(self, event)
    if event == "MAIL_SHOW" then
        played = 0
        self:Show()
        ag:Play()
    else
        ag:Stop()
        self:Hide()
    end
end)
