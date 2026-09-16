-- RIVALS Mobile + PC Cheat
-- Mini Rimuru button (bottom right) → opens full menu with blur
-- Works on mobile touch + PC
-- Unlock All toggles lock/unlock state

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

local isMobile = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled

-- ===================== CONFIG =====================
local Config = {
    ESP = {
        Enabled = true,
        Boxes = true,
        Names = true,
        Health = true,
        Distance = true,
        TeamCheck = false,
        MaxDistance = 1000,
        BoxColor = Color3.fromRGB(255, 40, 40),
        NameColor = Color3.fromRGB(255, 255, 255)
    },
    Aimbot = {
        Enabled = true,
        FOV = isMobile and 180 or 150,
        Smoothness = isMobile and 0.18 or 0.12,
        TeamCheck = false,
        TargetPart = "Head",
        Prediction = 0.15,
        ShowFOV = true
    },
    UnlockAll = {
        Enabled = false -- starts locked, toggle in menu
    }
}

-- ===================== BLUR =====================
local Blur = Instance.new("BlurEffect")
Blur.Name = "RivalsMenuBlur"
Blur.Size = 0
Blur.Parent = Lighting

local function SetBlur(enabled)
    local goal = enabled and 24 or 0
    TweenService:Create(Blur, TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = goal}):Play()
end

-- ===================== GUI =====================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "RivalsMobileMenu"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.IgnoreGuiInset = true
ScreenGui.Parent = game:GetService("CoreGui")

-- Mini Rimuru button (always visible)
local MiniBtn = Instance.new("ImageButton")
MiniBtn.Name = "RimuruButton"
MiniBtn.Size = UDim2.new(0, 64, 0, 64)
MiniBtn.Position = UDim2.new(1, -80, 1, -90)
MiniBtn.BackgroundColor3 = Color3.fromRGB(30, 180, 160)
MiniBtn.BackgroundTransparency = 0.15
MiniBtn.Image = "rbxassetid://6356099463" -- Rimuru slime image
MiniBtn.ScaleType = Enum.ScaleType.Fit
MiniBtn.Parent = ScreenGui

local MiniCorner = Instance.new("UICorner")
MiniCorner.CornerRadius = UDim.new(1, 0)
MiniCorner.Parent = MiniBtn

local MiniStroke = Instance.new("UIStroke")
MiniStroke.Color = Color3.fromRGB(0, 255, 200)
MiniStroke.Thickness = 2
MiniStroke.Parent = MiniBtn

-- Full menu frame
local Main = Instance.new("Frame")
Main.Name = "Main"
Main.Size = UDim2.new(0, isMobile and 300 or 280, 0, 380)
Main.Position = UDim2.new(0.5, isMobile and -150 or -140, 0.5, -190)
Main.BackgroundColor3 = Color3.fromRGB(16, 16, 22)
Main.BorderSizePixel = 0
Main.Visible = false
Main.Parent = ScreenGui

Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 12)

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 42)
Title.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
Title.Text = "RIVALS  |  Rimuru"
Title.TextColor3 = Color3.fromRGB(0, 255, 200)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 18
Title.Parent = Main
Instance.new("UICorner", Title).CornerRadius = UDim.new(0, 12)

local function CreateToggle(name, y, default, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.9, 0, 0, 36)
    btn.Position = UDim2.new(0.05, 0, 0, y)
    btn.BackgroundColor3 = default and Color3.fromRGB(0, 160, 120) or Color3.fromRGB(45, 45, 55)
    btn.Text = name .. (default and "  [ON]" or "  [OFF]")
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 15
    btn.Parent = Main
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)

    local state = default
    btn.MouseButton1Click:Connect(function()
        state = not state
        btn.BackgroundColor3 = state and Color3.fromRGB(0, 160, 120) or Color3.fromRGB(45, 45, 55)
        btn.Text = name .. (state and "  [ON]" or "  [OFF]")
        callback(state)
    end)
    return btn
end

CreateToggle("ESP", 55, Config.ESP.Enabled, function(v) Config.ESP.Enabled = v end)
CreateToggle("Aimbot", 100, Config.Aimbot.Enabled, function(v) Config.Aimbot.Enabled = v end)
CreateToggle("Show FOV", 145, Config.Aimbot.ShowFOV, function(v) Config.Aimbot.ShowFOV = v end)
CreateToggle("Team Check", 190, Config.ESP.TeamCheck, function(v)
    Config.ESP.TeamCheck = v
    Config.Aimbot.TeamCheck = v
end)

-- Unlock toggle
local UnlockBtn = Instance.new("TextButton")
UnlockBtn.Size = UDim2.new(0.9, 0, 0, 40)
UnlockBtn.Position = UDim2.new(0.05, 0, 0, 245)
UnlockBtn.BackgroundColor3 = Color3.fromRGB(180, 40, 40)
UnlockBtn.Text = "UNLOCK ALL  [LOCKED]"
UnlockBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
UnlockBtn.Font = Enum.Font.GothamBold
UnlockBtn.TextSize = 15
UnlockBtn.Parent = Main
Instance.new("UICorner", UnlockBtn).CornerRadius = UDim.new(0, 8)

local Status = Instance.new("TextLabel")
Status.Size = UDim2.new(1, -20, 0, 50)
Status.Position = UDim2.new(0, 10, 0, 300)
Status.BackgroundTransparency = 1
Status.Text = isMobile and "Tap Rimuru to open/close\nAimbot: hold near enemy" or "Click Rimuru or press P\nHold RMB = Aimbot"
Status.TextColor3 = Color3.fromRGB(160, 160, 170)
Status.Font = Enum.Font.Gotham
Status.TextSize = 13
Status.TextWrapped = true
Status.Parent = Main

-- Open / close full menu
local menuOpen = false
local function ToggleMenu()
    menuOpen = not menuOpen
    Main.Visible = menuOpen
    SetBlur(menuOpen)
    if menuOpen then
        Main.Size = UDim2.new(0, isMobile and 300 or 280, 0, 0)
        TweenService:Create(Main, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
            Size = UDim2.new(0, isMobile and 300 or 280, 0, 380)
        }):Play()
    end
end

MiniBtn.MouseButton1Click:Connect(ToggleMenu)

-- PC key support
UserInputService.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if input.KeyCode == Enum.KeyCode.P then
        ToggleMenu()
    end
end)

-- ===================== UNLOCK ALL =====================
local unlocked = false

local function ApplyUnlock(state)
    unlocked = state
    Config.UnlockAll.Enabled = state

    if state then
        UnlockBtn.BackgroundColor3 = Color3.fromRGB(0, 160, 80)
        UnlockBtn.Text = "UNLOCK ALL  [UNLOCKED]"
        Status.Text = "Weapons unlocked (client)"
    else
        UnlockBtn.BackgroundColor3 = Color3.fromRGB(180, 40, 40)
        UnlockBtn.Text = "UNLOCK ALL  [LOCKED]"
        Status.Text = "Weapons locked again"
    end

    pcall(function()
        local modules = ReplicatedStorage:FindFirstChild("Modules")
        if modules then
            local ok, CosmeticLibrary = pcall(require, modules:FindFirstChild("CosmeticLibrary"))
            if ok and CosmeticLibrary then
                if state then
                    CosmeticLibrary.OwnsCosmetic = function() return true end
                    CosmeticLibrary.OwnsCosmeticNormally = function() return true end
                    CosmeticLibrary.OwnsCosmeticUniversally = function() return true end
                    CosmeticLibrary.OwnsCosmeticForWeapon = function() return true end
                end
            end

            local ok2, ItemLibrary = pcall(require, modules:FindFirstChild("ItemLibrary"))
            if ok2 and ItemLibrary then
                if state then
                    if ItemLibrary.OwnsWeapon then ItemLibrary.OwnsWeapon = function() return true end end
                    if ItemLibrary.HasWeapon then ItemLibrary.HasWeapon = function() return true end end
                    if ItemLibrary.IsUnlocked then ItemLibrary.IsUnlocked = function() return true end end
                end
            end
        end
    end)

    pcall(function()
        local controllers = LocalPlayer:FindFirstChild("PlayerScripts") and LocalPlayer.PlayerScripts:FindFirstChild("Controllers")
        if controllers then
            local ok, DataController = pcall(require, controllers:FindFirstChild("PlayerDataController"))
            if ok and DataController then
                local oldGet = DataController.Get
                DataController.Get = function(self, key)
                    local data = oldGet(self, key)
                    if state and (key == "CosmeticInventory" or key == "WeaponInventory" or key == "UnlockedWeapons" or key == "FavoritedCosmetics") then
                        return setmetatable({}, {__index = function() return true end})
                    end
                    return data
                end
            end
        end
    end)

    print("[RIVALS] Unlock state:", state)
end

UnlockBtn.MouseButton1Click:Connect(function()
    ApplyUnlock(not unlocked)
end)

-- Start locked
ApplyUnlock(false)

LocalPlayer.CharacterAdded:Connect(function()
    task.wait(1.5)
    if unlocked then ApplyUnlock(true) end
end)

-- ===================== ESP =====================
local ESPObjects = {}
local FOVCircle = Drawing.new("Circle")
FOVCircle.Thickness = 1.5
FOVCircle.NumSides = 64
FOVCircle.Radius = Config.Aimbot.FOV
FOVCircle.Filled = false
FOVCircle.Visible = false
FOVCircle.Color = Color3.fromRGB(0, 255, 200)
FOVCircle.Transparency = 0.55

local function IsAlive(plr)
    local char = plr.Character
    if not char then return false end
    local hum = char:FindFirstChildOfClass("Humanoid")
    return hum and hum.Health > 0
end

local function IsEnemy(plr)
    if not Config.ESP.TeamCheck then return true end
    if not LocalPlayer.Team then return true end
    return plr.Team ~= LocalPlayer.Team
end

local function W2S(pos)
    local v, on = Camera:WorldToViewportPoint(pos)
    return Vector2.new(v.X, v.Y), on, v.Z
end

local function CreateESP(plr)
    if ESPObjects[plr] then return end
    local box = Drawing.new("Square")
    box.Thickness = 1.5
    box.Filled = false
    box.Color = Config.ESP.BoxColor
    box.Visible = false

    local name = Drawing.new("Text")
    name.Size = 13
    name.Center = true
    name.Outline = true
    name.Color = Config.ESP.NameColor
    name.Visible = false

    local hp = Drawing.new("Line")
    hp.Thickness = 2
    hp.Visible = false

    ESPObjects[plr] = {Box = box, Name = name, HP = hp}
end

local function RemoveESP(plr)
    local o = ESPObjects[plr]
    if o then
        for _, v in pairs(o) do if v.Remove then v:Remove() end end
        ESPObjects[plr] = nil
    end
end

local function UpdateESP()
    for plr, o in pairs(ESPObjects) do
        if not plr.Parent or not IsAlive(plr) or not IsEnemy(plr) or not Config.ESP.Enabled then
            o.Box.Visible = false
            o.Name.Visible = false
            o.HP.Visible = false
            continue
        end

        local char = plr.Character
        local root = char:FindFirstChild("HumanoidRootPart")
        local head = char:FindFirstChild("Head")
        local hum = char:FindFirstChildOfClass("Humanoid")
        if not root or not head or not hum then
            o.Box.Visible = false
            o.Name.Visible = false
            o.HP.Visible = false
            continue
        end

        local dist = (root.Position - Camera.CFrame.Position).Magnitude
        if dist > Config.ESP.MaxDistance then
            o.Box.Visible = false
            o.Name.Visible = false
            o.HP.Visible = false
            continue
        end

        local headPos, on = W2S(head.Position + Vector3.new(0, 0.6, 0))
        local footPos = W2S(root.Position - Vector3.new(0, 3, 0))
        if not on then
            o.Box.Visible = false
            o.Name.Visible = false
            o.HP.Visible = false
            continue
        end

        local h = math.abs(headPos.Y - footPos.Y)
        local w = h * 0.55
        local pos = Vector2.new(headPos.X - w/2, headPos.Y)

        if Config.ESP.Boxes then
            o.Box.Size = Vector2.new(w, h)
            o.Box.Position = pos
            o.Box.Visible = true
        else
            o.Box.Visible = false
        end

        if Config.ESP.Names then
            local t = plr.Name
            if Config.ESP.Distance then t = t .. " [" .. math.floor(dist) .. "m]" end
            o.Name.Text = t
            o.Name.Position = Vector2.new(headPos.X, headPos.Y - 16)
            o.Name.Visible = true
        else
            o.Name.Visible = false
        end

        if Config.ESP.Health then
            local ratio = math.clamp(hum.Health / hum.MaxHealth, 0, 1)
            o.HP.From = Vector2.new(pos.X - 4, pos.Y + h)
            o.HP.To = Vector2.new(pos.X - 4, pos.Y + h - (h * ratio))
            o.HP.Color = Color3.fromRGB(255*(1-ratio), 255*ratio, 0)
            o.HP.Visible = true
        else
            o.HP.Visible = false
        end
    end
end

-- ===================== AIMBOT =====================
local Aiming = false

local function GetClosest()
    local closest, short = nil, Config.Aimbot.FOV
    local mouse = UserInputService:GetMouseLocation()
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and IsAlive(plr) and IsEnemy(plr) then
            local char = plr.Character
            local part = char and char:FindFirstChild(Config.Aimbot.TargetPart)
            if part then
                local sp, on = W2S(part.Position)
                if on then
                    local d = (sp - mouse).Magnitude
                    if d < short then
                        short = d
                        closest = plr
                    end
                end
            end
        end
    end
    return closest
end

local function DoAimbot()
    if not Config.Aimbot.Enabled or not Aiming then return end
    local target = GetClosest()
    if not target then return end
    local part = target.Character and target.Character:FindFirstChild(Config.Aimbot.TargetPart)
    if not part then return end

    local vel = part.AssemblyLinearVelocity or Vector3.zero
    local pred = part.Position + vel * Config.Aimbot.Prediction
    local screen = Camera:WorldToViewportPoint(pred)
    local mouse = UserInputService:GetMouseLocation()
    local delta = Vector2.new(screen.X - mouse.X, screen.Y - mouse.Y)
    mousemoverel(delta.X * Config.Aimbot.Smoothness, delta.Y * Config.Aimbot.Smoothness)
end

-- PC hold RMB
UserInputService.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if input.UserInputType == Enum.UserInputType.MouseButton2 then
        Aiming = true
    end
end)
UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton2 then
        Aiming = false
    end
end)

-- Mobile: hold anywhere on screen while aiming
if isMobile then
    UserInputService.TouchStarted:Connect(function(touch, gpe)
        if gpe then return end
        Aiming = true
    end)
    UserInputService.TouchEnded:Connect(function()
        Aiming = false
    end)
end

-- ===================== PLAYER TRACK =====================
Players.PlayerAdded:Connect(function(plr)
    CreateESP(plr)
    plr.CharacterAdded:Connect(function() task.wait(0.5) CreateESP(plr) end)
end)
Players.PlayerRemoving:Connect(RemoveESP)

for _, plr in ipairs(Players:GetPlayers()) do
    if plr ~= LocalPlayer then
        CreateESP(plr)
        plr.CharacterAdded:Connect(function() task.wait(0.5) CreateESP(plr) end)
    end
end

-- ===================== MAIN LOOP =====================
RunService.RenderStepped:Connect(function()
    UpdateESP()
    if Config.Aimbot.ShowFOV and Config.Aimbot.Enabled then
        FOVCircle.Position = UserInputService:GetMouseLocation()
        FOVCircle.Radius = Config.Aimbot.FOV
        FOVCircle.Visible = true
    else
        FOVCircle.Visible = false
    end
    DoAimbot()
end)

print("[RIVALS] Mobile + PC loaded | Tap/Click Rimuru button")
