-- RIVALS Fixed Cheat
-- Menu Key: P
-- Hold RMB = Aimbot
-- ESP works on load

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

-- ===================== CONFIG =====================
local Config = {
    ESP = {
        Enabled = true,
        Boxes = true,
        Names = true,
        Health = true,
        Distance = true,
        Tracers = false,
        TeamCheck = false, -- set false so it always shows
        MaxDistance = 1000,
        BoxColor = Color3.fromRGB(255, 40, 40),
        NameColor = Color3.fromRGB(255, 255, 255)
    },
    Aimbot = {
        Enabled = true,
        Key = Enum.UserInputType.MouseButton2,
        FOV = 150,
        Smoothness = 0.12,
        TeamCheck = false,
        TargetPart = "Head",
        Prediction = 0.15,
        ShowFOV = true
    },
    UnlockAll = {
        Enabled = true
    }
}

-- ===================== GUI MENU (P) =====================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "RivalsCheatMenu"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = game:GetService("CoreGui")

local Main = Instance.new("Frame")
Main.Name = "Main"
Main.Size = UDim2.new(0, 280, 0, 320)
Main.Position = UDim2.new(0.5, -140, 0.5, -160)
Main.BackgroundColor3 = Color3.fromRGB(18, 18, 22)
Main.BorderSizePixel = 0
Main.Visible = false
Main.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 8)
UICorner.Parent = Main

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 36)
Title.BackgroundColor3 = Color3.fromRGB(28, 28, 35)
Title.Text = "RIVALS CHEAT"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 16
Title.Parent = Main

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 8)
TitleCorner.Parent = Title

local function CreateToggle(name, y, default, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.9, 0, 0, 32)
    btn.Position = UDim2.new(0.05, 0, 0, y)
    btn.BackgroundColor3 = default and Color3.fromRGB(40, 160, 70) or Color3.fromRGB(50, 50, 60)
    btn.Text = name .. (default and "  [ON]" or "  [OFF]")
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 14
    btn.Parent = Main

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = btn

    local state = default
    btn.MouseButton1Click:Connect(function()
        state = not state
        btn.BackgroundColor3 = state and Color3.fromRGB(40, 160, 70) or Color3.fromRGB(50, 50, 60)
        btn.Text = name .. (state and "  [ON]" or "  [OFF]")
        callback(state)
    end)
    return btn
end

CreateToggle("ESP", 50, Config.ESP.Enabled, function(v) Config.ESP.Enabled = v end)
CreateToggle("Aimbot", 90, Config.Aimbot.Enabled, function(v) Config.Aimbot.Enabled = v end)
CreateToggle("Show FOV", 130, Config.Aimbot.ShowFOV, function(v) Config.Aimbot.ShowFOV = v end)
CreateToggle("Team Check", 170, Config.ESP.TeamCheck, function(v)
    Config.ESP.TeamCheck = v
    Config.Aimbot.TeamCheck = v
end)

local UnlockBtn = Instance.new("TextButton")
UnlockBtn.Size = UDim2.new(0.9, 0, 0, 36)
UnlockBtn.Position = UDim2.new(0.05, 0, 0, 220)
UnlockBtn.BackgroundColor3 = Color3.fromRGB(180, 50, 50)
UnlockBtn.Text = "FORCE UNLOCK ALL"
UnlockBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
UnlockBtn.Font = Enum.Font.GothamBold
UnlockBtn.TextSize = 14
UnlockBtn.Parent = Main
Instance.new("UICorner", UnlockBtn).CornerRadius = UDim.new(0, 6)

local Status = Instance.new("TextLabel")
Status.Size = UDim2.new(1, -20, 0, 40)
Status.Position = UDim2.new(0, 10, 0, 270)
Status.BackgroundTransparency = 1
Status.Text = "Menu: P | Hold RMB = Aimbot"
Status.TextColor3 = Color3.fromRGB(180, 180, 180)
Status.Font = Enum.Font.Gotham
Status.TextSize = 12
Status.TextWrapped = true
Status.Parent = Main

-- Toggle menu with P
UserInputService.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if input.KeyCode == Enum.KeyCode.P then
        Main.Visible = not Main.Visible
    end
end)

-- ===================== UNLOCK ALL (stronger) =====================
local function ForceUnlock()
    Status.Text = "Unlocking..."

    -- Method 1: Hook all ownership functions
    pcall(function()
        local modules = ReplicatedStorage:FindFirstChild("Modules")
        if modules then
            local ok, CosmeticLibrary = pcall(require, modules:FindFirstChild("CosmeticLibrary"))
            if ok and CosmeticLibrary then
                CosmeticLibrary.OwnsCosmetic = function() return true end
                CosmeticLibrary.OwnsCosmeticNormally = function() return true end
                CosmeticLibrary.OwnsCosmeticUniversally = function() return true end
                CosmeticLibrary.OwnsCosmeticForWeapon = function() return true end
            end

            local ok2, ItemLibrary = pcall(require, modules:FindFirstChild("ItemLibrary"))
            if ok2 and ItemLibrary then
                if ItemLibrary.OwnsWeapon then ItemLibrary.OwnsWeapon = function() return true end end
                if ItemLibrary.HasWeapon then ItemLibrary.HasWeapon = function() return true end end
                if ItemLibrary.IsUnlocked then ItemLibrary.IsUnlocked = function() return true end end
            end
        end
    end)

    -- Method 2: Hook DataController
    pcall(function()
        local controllers = LocalPlayer:FindFirstChild("PlayerScripts") and LocalPlayer.PlayerScripts:FindFirstChild("Controllers")
        if controllers then
            local ok, DataController = pcall(require, controllers:FindFirstChild("PlayerDataController"))
            if ok and DataController then
                local oldGet = DataController.Get
                DataController.Get = function(self, key)
                    local data = oldGet(self, key)
                    if key == "CosmeticInventory" or key == "WeaponInventory" or key == "UnlockedWeapons" or key == "FavoritedCosmetics" then
                        return setmetatable({}, {__index = function() return true end})
                    end
                    return data
                end
            end
        end
    end)

    -- Method 3: Force equip tools from StarterPack / Backpack
    pcall(function()
        local char = LocalPlayer.Character
        if char then
            for _, tool in ipairs(LocalPlayer.Backpack:GetChildren()) do
                if tool:IsA("Tool") then
                    tool.Parent = char
                end
            end
        end
    end)

    Status.Text = "Unlock forced (client). Check inventory."
    print("[RIVALS] Unlock All forced")
end

UnlockBtn.MouseButton1Click:Connect(ForceUnlock)
ForceUnlock() -- auto run on load
LocalPlayer.CharacterAdded:Connect(function()
    task.wait(1.5)
    ForceUnlock()
end)

-- ===================== ESP =====================
local ESPObjects = {}
local FOVCircle = Drawing.new("Circle")
FOVCircle.Thickness = 1.5
FOVCircle.NumSides = 64
FOVCircle.Radius = Config.Aimbot.FOV
FOVCircle.Filled = false
FOVCircle.Visible = false
FOVCircle.Color = Color3.fromRGB(255, 255, 255)
FOVCircle.Transparency = 0.6

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

UserInputService.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if input.UserInputType == Config.Aimbot.Key then
        Aiming = true
    end
end)
UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Config.Aimbot.Key then
        Aiming = false
    end
end)

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

print("[RIVALS] Loaded | Press P for menu | Hold RMB for aimbot")
Status.Text = "Loaded. Press P for menu."
