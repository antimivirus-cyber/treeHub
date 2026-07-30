-- made by tree3
-- the best pvp hub, TREEHUB
-- its light, fast, good and SUPER DUPER ULTRA MEGA PRO MAX cool...
-- dont use without permission, look at the lisence

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")

local function StartTreeHub()
    local LocalPlayer = Players.LocalPlayer
    local Camera = workspace.CurrentCamera
    local Mouse = LocalPlayer:GetMouse()

    local configName = "treeHub_config.json"
    local defaultSettings = {
        Theme = "Tree",
        AimKey = "G",
        FlyKey = "K",
        UIKey = "P",
        UIAnimations = true,
        AimWallCheck = false,
        EspName = false,
        EspBody = false,
        HitboxState = false,
        HitboxSize = "10",
        WhitelistEnabled = false,
        WhitelistedPlayers = {}
    }
    
    local currentSettings = {}
    local function applyDefaultSettings()
        table.clear(currentSettings)
        for k, v in pairs(defaultSettings) do currentSettings[k] = v end
        currentSettings.WhitelistedPlayers = {}
    end
    applyDefaultSettings()

    local function saveSettings()
        pcall(function()
            if writefile then
                writefile(configName, HttpService:JSONEncode(currentSettings))
            end
        end)
    end

    local function loadSettings()
        pcall(function()
            if readfile then
                local data = readfile(configName)
                local parsed = HttpService:JSONDecode(data)
                if parsed then
                    for k, v in pairs(parsed) do
                        if k == "WhitelistedPlayers" then
                            currentSettings.WhitelistedPlayers = v or {}
                        else
                            currentSettings[k] = v
                        end
                    end
                end
            end
        end)
    end
    loadSettings()

    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "treeHubGui"
    ScreenGui.Parent = CoreGui
    ScreenGui.ResetOnSpawn = false
    ScreenGui.IgnoreGuiInset = true
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    local connections = {}
    local activeGradients = {}

    local Themes = {
        Tree = { MainBg = Color3.fromRGB(15, 25, 18), NavBg = Color3.fromRGB(10, 18, 12), Accent = Color3.fromRGB(40, 150, 75), ElementBg = Color3.fromRGB(22, 35, 25), Text = Color3.fromRGB(230, 255, 235), Danger = Color3.fromRGB(200, 60, 60), Warning = Color3.fromRGB(200, 150, 50) },
        Azure = { MainBg = Color3.fromRGB(5, 12, 25), NavBg = Color3.fromRGB(3, 8, 18), Accent = Color3.fromRGB(0, 150, 255), ElementBg = Color3.fromRGB(12, 20, 35), Text = Color3.fromRGB(230, 245, 255), Danger = Color3.fromRGB(255, 60, 60), Warning = Color3.fromRGB(255, 180, 50) },
        Crimson = { MainBg = Color3.fromRGB(25, 5, 5), NavBg = Color3.fromRGB(18, 3, 3), Accent = Color3.fromRGB(255, 30, 30), ElementBg = Color3.fromRGB(40, 10, 10), Text = Color3.fromRGB(255, 220, 220), Danger = Color3.fromRGB(200, 40, 40), Warning = Color3.fromRGB(255, 120, 40) },
        Static = { MainBg = Color3.fromRGB(10, 10, 10), NavBg = Color3.fromRGB(5, 5, 5), Accent = Color3.fromRGB(255, 255, 255), ElementBg = Color3.fromRGB(25, 25, 25), Text = Color3.fromRGB(255, 255, 255), Danger = Color3.fromRGB(180, 180, 180), Warning = Color3.fromRGB(200, 200, 200) },
        Frost = { MainBg = Color3.fromRGB(10, 25, 35), NavBg = Color3.fromRGB(5, 15, 20), Accent = Color3.fromRGB(0, 255, 255), ElementBg = Color3.fromRGB(15, 35, 45), Text = Color3.fromRGB(220, 255, 255), Danger = Color3.fromRGB(255, 80, 80), Warning = Color3.fromRGB(255, 200, 50) },
        Divine = { MainBg = Color3.fromRGB(25, 25, 20), NavBg = Color3.fromRGB(15, 15, 10), Accent = Color3.fromRGB(255, 215, 0), ElementBg = Color3.fromRGB(40, 40, 30), Text = Color3.fromRGB(255, 255, 220), Danger = Color3.fromRGB(255, 60, 60), Warning = Color3.fromRGB(255, 180, 0) },
        Dark = { MainBg = Color3.fromRGB(10, 10, 10), NavBg = Color3.fromRGB(5, 5, 5), Accent = Color3.fromRGB(150, 150, 150), ElementBg = Color3.fromRGB(20, 20, 20), Text = Color3.fromRGB(200, 200, 200), Danger = Color3.fromRGB(150, 40, 40), Warning = Color3.fromRGB(150, 150, 40) },
        Fenerbahce = { MainBg = Color3.fromRGB(0, 20, 60), NavBg = Color3.fromRGB(0, 10, 40), Accent = Color3.fromRGB(255, 220, 0), ElementBg = Color3.fromRGB(0, 30, 80), Text = Color3.fromRGB(255, 255, 255), Danger = Color3.fromRGB(200, 50, 50), Warning = Color3.fromRGB(255, 150, 0) },
        Galatasaray = { MainBg = Color3.fromRGB(80, 0, 0), NavBg = Color3.fromRGB(50, 0, 0), Accent = Color3.fromRGB(255, 150, 0), ElementBg = Color3.fromRGB(120, 20, 20), Text = Color3.fromRGB(255, 255, 255), Danger = Color3.fromRGB(200, 30, 30), Warning = Color3.fromRGB(255, 100, 0) },
        Poop = { MainBg = Color3.fromRGB(60, 40, 20), NavBg = Color3.fromRGB(40, 25, 10), Accent = Color3.fromRGB(120, 80, 40), ElementBg = Color3.fromRGB(80, 55, 30), Text = Color3.fromRGB(220, 200, 180), Danger = Color3.fromRGB(150, 50, 50), Warning = Color3.fromRGB(180, 140, 50) },
        Volcano = { MainBg = Color3.fromRGB(30, 10, 5), NavBg = Color3.fromRGB(20, 5, 0), Accent = Color3.fromRGB(255, 80, 0), ElementBg = Color3.fromRGB(60, 20, 10), Text = Color3.fromRGB(255, 200, 150), Danger = Color3.fromRGB(255, 30, 0), Warning = Color3.fromRGB(255, 120, 0) },
        Ghost = { MainBg = Color3.fromRGB(20, 30, 40), NavBg = Color3.fromRGB(10, 15, 20), Accent = Color3.fromRGB(100, 200, 255), ElementBg = Color3.fromRGB(30, 50, 60), Text = Color3.fromRGB(240, 255, 255), Danger = Color3.fromRGB(200, 100, 100), Warning = Color3.fromRGB(200, 200, 100) },
        Ink = { MainBg = Color3.fromRGB(5, 5, 5), NavBg = Color3.fromRGB(0, 0, 0), Accent = Color3.fromRGB(255, 255, 0), ElementBg = Color3.fromRGB(15, 15, 15), Text = Color3.fromRGB(255, 255, 200), Danger = Color3.fromRGB(255, 50, 50), Warning = Color3.fromRGB(255, 150, 0) },
        Turkey = { MainBg = Color3.fromRGB(227, 10, 23), NavBg = Color3.fromRGB(180, 0, 10), Accent = Color3.fromRGB(255, 255, 255), ElementBg = Color3.fromRGB(200, 15, 25), Text = Color3.fromRGB(255, 150, 150), Danger = Color3.fromRGB(255, 255, 255), Warning = Color3.fromRGB(220, 220, 220) },
        Rainbow = { Gradient = ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromRGB(255,140,140)), ColorSequenceKeypoint.new(0.2, Color3.fromRGB(255,230,140)), ColorSequenceKeypoint.new(0.4, Color3.fromRGB(140,255,160)), ColorSequenceKeypoint.new(0.6, Color3.fromRGB(140,230,255)), ColorSequenceKeypoint.new(0.8, Color3.fromRGB(200,140,255)), ColorSequenceKeypoint.new(1, Color3.fromRGB(255,140,230))}), MainBg = Color3.fromRGB(18, 18, 22), NavBg = Color3.fromRGB(12, 12, 16), Accent = Color3.fromRGB(220, 220, 255), ElementBg = Color3.fromRGB(25, 25, 32), Text = Color3.fromRGB(240, 240, 255), Danger = Color3.fromRGB(255, 80, 80), Warning = Color3.fromRGB(255, 180, 50) },
        Acid = { Gradient = ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromRGB(180,255,0)), ColorSequenceKeypoint.new(1, Color3.fromRGB(0,255,100))}), MainBg = Color3.fromRGB(15, 25, 10), NavBg = Color3.fromRGB(10, 18, 5), Accent = Color3.fromRGB(150, 255, 0), ElementBg = Color3.fromRGB(25, 35, 15), Text = Color3.fromRGB(230, 255, 200), Danger = Color3.fromRGB(255, 50, 50), Warning = Color3.fromRGB(255, 255, 0) },
        Celestial = { Gradient = ColorSequence.new({ColorSequenceKeypoint.new(0, Color3.fromRGB(100,50,255)), ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255,100,200)), ColorSequenceKeypoint.new(1, Color3.fromRGB(100,200,255))}), MainBg = Color3.fromRGB(15, 10, 25), NavBg = Color3.fromRGB(10, 5, 15), Accent = Color3.fromRGB(200, 150, 255), ElementBg = Color3.fromRGB(25, 20, 35), Text = Color3.fromRGB(250, 240, 255), Danger = Color3.fromRGB(255, 80, 100), Warning = Color3.fromRGB(255, 200, 100) }
    }

    local ThemeOrder = {"Tree", "Azure", "Crimson", "Static", "Frost", "Divine", "Dark", "Fenerbahce", "Galatasaray", "Poop", "Volcano", "Ghost", "Ink", "Turkey", "Rainbow", "Acid", "Celestial"}
    local currentThemeName = currentSettings.Theme
    if not Themes[currentThemeName] then currentThemeName = "Tree" end
    local currentThemeIndex = table.find(ThemeOrder, currentThemeName) or 1
    local Theme = Themes[currentThemeName]

    local themeObjects = {
        MainBg = {}, NavBg = {}, Accent = {}, ElementBg = {}, Text = {}, Danger = {}, Warning = {}, AccentText = {}, DangerText = {}
    }

    local function registerTheme(obj, role, prop)
        table.insert(themeObjects[role], {Object = obj, Property = prop})
        obj[prop] = Theme[role] or Theme.Accent
    end

    local function applyTheme(animate)
        Theme = Themes[currentThemeName]
        local isGhost = (currentThemeName == "Ghost")
        
        for _, grad in ipairs(activeGradients) do if grad then grad:Destroy() end end
        table.clear(activeGradients)

        for role, objects in pairs(themeObjects) do
            for _, item in ipairs(objects) do
                local color = Theme[role]
                if role == "AccentText" then color = Theme.Accent end
                if role == "DangerText" then color = Theme.Danger end
                
                if item.Object and item.Object.Parent then
                    if Theme.Gradient and (role == "MainBg" or role == "NavBg") and item.Object:IsA("GuiObject") then
                        local uiGradient = Instance.new("UIGradient")
                        uiGradient.Color = Theme.Gradient
                        uiGradient.Rotation = 0
                        uiGradient.Parent = item.Object
                        table.insert(activeGradients, uiGradient)
                    else
                        if animate and currentSettings.UIAnimations and item.Object:IsA("GuiObject") then
                            TweenService:Create(item.Object, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {[item.Property] = color}):Play()
                        else
                            item.Object[item.Property] = color
                        end
                    end

                    if item.Object:IsA("Frame") or item.Object:IsA("ScrollingFrame") then
                        if role == "MainBg" or role == "NavBg" or role == "ElementBg" then
                            item.Object.BackgroundTransparency = isGhost and 0.3 or 0
                        end
                    end
                end
            end
        end
    end

    table.insert(connections, RunService.RenderStepped:Connect(function(dt)
        if currentThemeName == "Rainbow" then
            for _, grad in ipairs(activeGradients) do
                if grad and grad.Parent then
                    grad.Rotation = 0
                    grad.Offset = Vector2.new((grad.Offset.X + (0.3 * dt)) % 2, 0)
                end
            end
        end
    end))

    local currentCategory = "Home"
    local uiVisible = false
    local isMinimized = false
    local waitingForKey = nil

    local tpSelectedPlayer = nil
    local tpCurrentMode = "Teleport"
    local activeTweenConnection = nil

    local aimbotEnabled = false
    local systemActive = true
    local aimType = "Mouse Lock"
    local aimCurrentMode = "Closest"
    local aimSelectedTarget = nil
    local wallCheckEnabled = currentSettings.AimWallCheck

    local espNameEnabled = currentSettings.EspName
    local espBodyEnabled = currentSettings.EspBody

    local flyEnabled = false
    local speedEnabled = false
    local jumpEnabled = false
    
    local originalSpeed = nil
    local originalJumpPower = nil
    local originalJumpHeight = nil
    local originalUseJumpPower = nil

    local hitboxEnabled = currentSettings.HitboxState
    local hitboxMode = "All Players"
    local hitboxSelectedPlayers = {}

    local autoKillEnabled = false
    local autoKillTarget = nil
    local autoKillTargetName = nil
    local autoKillConnection = nil
    local autoKillMode = "Tween"
    local autoKillTargetType = "Player"
    local autoKill50StudTweenEnabled = false

    local superMovementEnabled = false
    
    -- Blox Fruits M1 Hitbox Scaler
    local m1ScalerEnabled = false
    local originalM1Sizes = {}

    -- Fruit ESP Variables
    local fruitEspEnabled = false
    local fruitEspCache = {}
    local fruitTpEnabled = false
    local fruitTpMode = "Teleport"
    local fruitTpSpeed = "50"
    local fruitAutoTpEnabled = false
    local fruitAutoTpConnection = nil
    local fruitNames = {
        "rocket", "spin", "blade", "spring", "bomb", "smoke", "spike", "flame", "ice",
        "sand", "dark", "eagle", "diamond", "light", "rubber", "ghost", "magma", "quake",
        "buddha", "love", "creation", "spider", "sound", "phoenix", "portal", "lightning",
        "pain", "blizzard", "gravity", "mammoth", "t-rex", "dough", "shadow", "venom",
        "gas", "spirit", "tiger", "yeti", "kitsune", "control", "dragon"
    }

    -- Whitelist variables
    local whitelistEnabled = currentSettings.WhitelistEnabled or false
    local whitelistedPlayers = {}
    for _, name in ipairs(currentSettings.WhitelistedPlayers or {}) do
        whitelistedPlayers[name] = true
    end

    local function isPlayerWhitelisted(player)
        return whitelistedPlayers[player.Name] == true
    end

    local function isValidFruit(obj)
        if not obj:IsA("Tool") or not obj:FindFirstChild("Handle") then return false end
        local name = obj.Name:lower():gsub("[%-_ ]", "")
        for _, f in ipairs(fruitNames) do if name:find(f) then return true end end
        return name:find("fruit") ~= nil
    end

    local function clearFruitESP()
        for _, data in pairs(fruitEspCache) do pcall(function() data.Bill:Destroy() end) end
        fruitEspCache = {}
    end

    local function updateFruitESP()
        local char = LocalPlayer.Character
        local root = char and char:FindFirstChild("HumanoidRootPart")
        local seen = {}

        for _, obj in ipairs(workspace:GetChildren()) do
            if isValidFruit(obj) then
                seen[obj] = true
                if not fruitEspCache[obj] then
                    local b = Instance.new("BillboardGui")
                    b.Adornee = obj.Handle
                    b.Size = UDim2.new(0, 140, 0, 24)
                    b.StudsOffset = Vector3.new(0, 2, 0)
                    b.AlwaysOnTop = true
                    b.MaxDistance = math.huge
                    b.Parent = obj.Handle

                    local l = Instance.new("TextLabel", b)
                    l.Text = obj.Name; l.Size = UDim2.new(1,0,0.5,0); l.BackgroundTransparency = 1
                    l.TextColor3 = Color3.fromRGB(0,255,120); l.Font = Enum.Font.GothamBold
                    l.TextSize = 13; l.TextStrokeTransparency = 0.6

                    local d = Instance.new("TextLabel", b)
                    d.Size = UDim2.new(1,0,0.5,0); d.Position = UDim2.new(0,0,0.5,0)
                    d.BackgroundTransparency = 1; d.TextColor3 = Color3.fromRGB(200,255,200)
                    d.Font = Enum.Font.Gotham; d.TextSize = 10

                    fruitEspCache[obj] = {Bill = b, Dist = d, Fruit = obj}
                end
                if root and fruitEspCache[obj] then
                    local dist = math.floor((obj.Handle.Position - root.Position).Magnitude)
                    fruitEspCache[obj].Dist.Text = dist .. " studs"
                end
            end
        end

        for obj, data in pairs(fruitEspCache) do
            if not seen[obj] or not obj:FindFirstChild("Handle") then
                pcall(function() data.Bill:Destroy() end); fruitEspCache[obj] = nil
            end
        end
    end

    local function doFruitTp(mode, speed)
        local char = LocalPlayer.Character
        if not char then return end
        local myRoot = char:FindFirstChild("HumanoidRootPart")
        if not myRoot then return end

        local closestFruit = nil
        local closestDist = math.huge
        for obj, data in pairs(fruitEspCache) do
            if obj and obj:FindFirstChild("Handle") then
                local dist = (obj.Handle.Position - myRoot.Position).Magnitude
                if dist < closestDist then
                    closestDist = dist
                    closestFruit = obj
                end
            end
        end

        if not closestFruit or not closestFruit:FindFirstChild("Handle") then return end
        local targetPos = closestFruit.Handle.Position + Vector3.new(0, 3, 0)

        if fruitTpConnection then fruitTpConnection:Disconnect(); fruitTpConnection = nil end

        if mode == "Teleport" then
            myRoot.CFrame = CFrame.new(targetPos)
        elseif mode == "Tween" then
            local spd = tonumber(speed) or 50
            spd = math.clamp(spd, 1, 1000)
            myRoot.Anchored = true
            fruitTpConnection = RunService.Heartbeat:Connect(function(dt)
                if not myRoot or not myRoot.Parent then
                    if fruitTpConnection then fruitTpConnection:Disconnect(); fruitTpConnection = nil end
                    return
                end
                if not closestFruit or not closestFruit:FindFirstChild("Handle") then
                    myRoot.Anchored = false
                    if fruitTpConnection then fruitTpConnection:Disconnect(); fruitTpConnection = nil end
                    return
                end
                local pos = closestFruit.Handle.Position + Vector3.new(0, 3, 0)
                local dist = (pos - myRoot.Position).Magnitude
                if dist < 3 then
                    myRoot.Anchored = false
                    if fruitTpConnection then fruitTpConnection:Disconnect(); fruitTpConnection = nil end
                    return
                end
                local dir = (pos - myRoot.Position).Unit
                myRoot.CFrame = myRoot.CFrame + (dir * spd * dt)
            end)
        end
    end

    local function startAutoFruitTp()
        if fruitAutoTpConnection then fruitAutoTpConnection:Disconnect() end
        fruitAutoTpConnection = RunService.Heartbeat:Connect(function()
            if not fruitAutoTpEnabled then
                if fruitAutoTpConnection then fruitAutoTpConnection:Disconnect(); fruitAutoTpConnection = nil end
                return
            end
            if fruitTpConnection then return end
            local char = LocalPlayer.Character
            if not char then return end
            local myRoot = char:FindFirstChild("HumanoidRootPart")
            if not myRoot then return end

            local closestFruit = nil
            local closestDist = math.huge
            for obj, data in pairs(fruitEspCache) do
                if obj and obj:FindFirstChild("Handle") then
                    local dist = (obj.Handle.Position - myRoot.Position).Magnitude
                    if dist < closestDist then
                        closestDist = dist
                        closestFruit = obj
                    end
                end
            end

            if closestFruit and closestFruit:FindFirstChild("Handle") then
                local targetPos = closestFruit.Handle.Position + Vector3.new(0, 3, 0)
                if fruitTpMode == "Teleport" then
                    myRoot.CFrame = CFrame.new(targetPos)
                elseif fruitTpMode == "Tween" and not fruitTpConnection then
                    local spd = tonumber(fruitTpSpeed) or 50
                    spd = math.clamp(spd, 1, 1000)
                    myRoot.Anchored = true
                    fruitTpConnection = RunService.Heartbeat:Connect(function(dt)
                        if not myRoot or not myRoot.Parent then
                            if fruitTpConnection then fruitTpConnection:Disconnect(); fruitTpConnection = nil end
                            myRoot.Anchored = false
                            return
                        end
                        if not closestFruit or not closestFruit:FindFirstChild("Handle") then
                            myRoot.Anchored = false
                            if fruitTpConnection then fruitTpConnection:Disconnect(); fruitTpConnection = nil end
                            return
                        end
                        local pos = closestFruit.Handle.Position + Vector3.new(0, 3, 0)
                        local dist = (pos - myRoot.Position).Magnitude
                        if dist < 3 then
                            myRoot.Anchored = false
                            if fruitTpConnection then fruitTpConnection:Disconnect(); fruitTpConnection = nil end
                            return
                        end
                        local dir = (pos - myRoot.Position).Unit
                        myRoot.CFrame = myRoot.CFrame + (dir * spd * dt)
                    end)
                end
            end
        end)
    end

    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Size = UDim2.new(0, 580, 0, 450)
    MainFrame.Position = UDim2.new(0.5, -290, 0.5, -225)
    MainFrame.BorderSizePixel = 0
    MainFrame.Active = true
    MainFrame.Draggable = true
    MainFrame.Visible = false
    MainFrame.Parent = ScreenGui
    registerTheme(MainFrame, "MainBg", "BackgroundColor3")

    local mainScale = Instance.new("UIScale")
    mainScale.Scale = 1
    mainScale.Parent = MainFrame

    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 8)
    UICorner.Parent = MainFrame

    local UIStroke = Instance.new("UIStroke")
    UIStroke.Thickness = 2
    UIStroke.Parent = MainFrame
    registerTheme(UIStroke, "Accent", "Color")

    local TitleBar = Instance.new("Frame")
    TitleBar.Size = UDim2.new(1, 0, 0, 35)
    TitleBar.BorderSizePixel = 0
    TitleBar.Parent = MainFrame
    registerTheme(TitleBar, "NavBg", "BackgroundColor3")

    local TitleBarCorner = Instance.new("UICorner")
    TitleBarCorner.CornerRadius = UDim.new(0, 8)
    TitleBarCorner.Parent = TitleBar

    local TitleBarBottomFix = Instance.new("Frame")
    TitleBarBottomFix.Size = UDim2.new(1, 0, 0, 8)
    TitleBarBottomFix.Position = UDim2.new(0, 0, 1, -8)
    TitleBarBottomFix.BorderSizePixel = 0
    TitleBarBottomFix.Parent = TitleBar
    registerTheme(TitleBarBottomFix, "NavBg", "BackgroundColor3")

    local Logo = Instance.new("ImageLabel")
    Logo.Size = UDim2.new(0, 45, 0, 45)
    Logo.Position = UDim2.new(0, 2, 0, 2)
    Logo.BackgroundTransparency = 1
    Logo.Image = "rbxassetid://108429972282329"
    Logo.Parent = TitleBar

    local Title = Instance.new("TextLabel")
    Title.Text = "treeHub"
    Title.Size = UDim2.new(1, -100, 1, 0)
    Title.Position = UDim2.new(0, 45, 0, 0)
    Title.BackgroundTransparency = 1
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 16
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Parent = TitleBar
    registerTheme(Title, "Accent", "TextColor3")

    local CloseButton = Instance.new("TextButton")
    CloseButton.Text = "X"
    CloseButton.Size = UDim2.new(0, 26, 0, 26)
    CloseButton.Position = UDim2.new(1, -32, 0, 4)
    CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    CloseButton.Font = Enum.Font.GothamBold
    CloseButton.TextSize = 13
    CloseButton.Parent = TitleBar
    Instance.new("UICorner", CloseButton).CornerRadius = UDim.new(0, 6)
    registerTheme(CloseButton, "Danger", "BackgroundColor3")

    local MinButton = Instance.new("TextButton")
    MinButton.Text = "-"
    MinButton.Size = UDim2.new(0, 26, 0, 26)
    MinButton.Position = UDim2.new(1, -64, 0, 4)
    MinButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    MinButton.Font = Enum.Font.GothamBold
    MinButton.TextSize = 16
    MinButton.Parent = TitleBar
    Instance.new("UICorner", MinButton).CornerRadius = UDim.new(0, 6)
    registerTheme(MinButton, "Warning", "BackgroundColor3")

    local ContentArea = Instance.new("Frame")
    ContentArea.Size = UDim2.new(1, 0, 1, -35)
    ContentArea.Position = UDim2.new(0, 0, 0, 35)
    ContentArea.BackgroundTransparency = 1
    ContentArea.Parent = MainFrame

    local NavFrame = Instance.new("Frame")
    NavFrame.Size = UDim2.new(0, 140, 1, 0)
    NavFrame.BorderSizePixel = 0
    NavFrame.Parent = ContentArea
    registerTheme(NavFrame, "NavBg", "BackgroundColor3")

    local NavLayout = Instance.new("UIListLayout")
    NavLayout.Parent = NavFrame
    NavLayout.SortOrder = Enum.SortOrder.LayoutOrder
    NavLayout.Padding = UDim.new(0, 5)
    NavLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

    local NavPadding = Instance.new("UIPadding")
    NavPadding.Parent = NavFrame
    NavPadding.PaddingTop = UDim.new(0, 10)

    local PagesFrame = Instance.new("Frame")
    PagesFrame.Size = UDim2.new(1, -140, 1, 0)
    PagesFrame.Position = UDim2.new(0, 140, 0, 0)
    PagesFrame.BackgroundTransparency = 1
    PagesFrame.Parent = ContentArea

    local ConfirmFrame = Instance.new("Frame")
    ConfirmFrame.Size = UDim2.new(0, 300, 0, 150)
    ConfirmFrame.Position = UDim2.new(0.5, -150, 0.5, -75)
    ConfirmFrame.Visible = false
    ConfirmFrame.Parent = ScreenGui
    registerTheme(ConfirmFrame, "MainBg", "BackgroundColor3")
    Instance.new("UICorner", ConfirmFrame).CornerRadius = UDim.new(0, 8)
    
    local ConfirmStroke = Instance.new("UIStroke")
    ConfirmStroke.Thickness = 2
    ConfirmStroke.Parent = ConfirmFrame
    registerTheme(ConfirmStroke, "Accent", "Color")

    local ConfirmText = Instance.new("TextLabel")
    ConfirmText.Size = UDim2.new(1, 0, 0.6, 0)
    ConfirmText.BackgroundTransparency = 1
    ConfirmText.Text = "Close treeHub?"
    ConfirmText.Font = Enum.Font.GothamBold
    ConfirmText.TextSize = 16
    ConfirmText.Parent = ConfirmFrame
    registerTheme(ConfirmText, "Text", "TextColor3")

    local ConfirmYes = Instance.new("TextButton")
    ConfirmYes.Size = UDim2.new(0.35, 0, 0, 35)
    ConfirmYes.Position = UDim2.new(0.1, 0, 0.6, 0)
    ConfirmYes.Text = "Yes"
    ConfirmYes.Font = Enum.Font.GothamBold
    ConfirmYes.TextSize = 14
    ConfirmYes.TextColor3 = Color3.fromRGB(255, 255, 255)
    ConfirmYes.Parent = ConfirmFrame
    Instance.new("UICorner", ConfirmYes).CornerRadius = UDim.new(0, 6)
    registerTheme(ConfirmYes, "Accent", "BackgroundColor3")

    local ConfirmNo = Instance.new("TextButton")
    ConfirmNo.Size = UDim2.new(0.35, 0, 0, 35)
    ConfirmNo.Position = UDim2.new(0.55, 0, 0.6, 0)
    ConfirmNo.Text = "No"
    ConfirmNo.Font = Enum.Font.GothamBold
    ConfirmNo.TextSize = 14
    ConfirmNo.TextColor3 = Color3.fromRGB(255, 255, 255)
    ConfirmNo.Parent = ConfirmFrame
    Instance.new("UICorner", ConfirmNo).CornerRadius = UDim.new(0, 6)
    registerTheme(ConfirmNo, "Danger", "BackgroundColor3")

    local Pages = {}
    local TabButtons = {}

    local function createTab(id, text)
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(0.9, 0, 0, 35)
        btn.Font = Enum.Font.GothamBold
        btn.Text = text
        btn.TextSize = 13
        btn.Parent = NavFrame
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
        registerTheme(btn, "ElementBg", "BackgroundColor3")
        registerTheme(btn, "Text", "TextColor3")
        TabButtons[id] = btn

        local page = Instance.new("ScrollingFrame")
        page.Size = UDim2.new(1, 0, 1, 0)
        page.BackgroundTransparency = 1
        page.BorderSizePixel = 0
        page.ScrollBarThickness = 6
        page.Visible = false
        page.Parent = PagesFrame
        
        local layout = Instance.new("UIListLayout")
        layout.Parent = page
        layout.SortOrder = Enum.SortOrder.LayoutOrder
        layout.Padding = UDim.new(0, 10)
        layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
        
        local padding = Instance.new("UIPadding")
        padding.Parent = page
        padding.PaddingTop = UDim.new(0, 15)
        padding.PaddingBottom = UDim.new(0, 15)
        
        Pages[id] = page
        return page
    end

    local Page_Home = createTab("Home", "Home")
    local Page_BloxFruits = createTab("BloxFruits", "Blox Fruits")
    local Page_TPTween = createTab("TPTween", "TP & Tween")
    local Page_AimAssist = createTab("AimAssist", "Aim Assist")
    local Page_Esp = createTab("Esp", "ESP")
    local Page_Utility = createTab("Utility", "Utility")
    local Page_Hitbox = createTab("Hitbox", "Hitbox")
    local Page_AutoKill = createTab("AutoKill", "AutoKill")
    local Page_Settings = createTab("Settings", "Settings")

    local function createButton(parent, text, defaultThemeRoleBg, defaultThemeRoleText)
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(0.9, 0, 0, 35)
        btn.Font = Enum.Font.GothamBold
        btn.Text = text
        btn.TextSize = 13
        btn.Parent = parent
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
        registerTheme(btn, defaultThemeRoleBg or "ElementBg", "BackgroundColor3")
        registerTheme(btn, defaultThemeRoleText or "Text", "TextColor3")
        return btn
    end

    local function createInfoLabel(parent, text, bgRole, textRole)
        local lbl = Instance.new("TextLabel")
        lbl.Size = UDim2.new(0.9, 0, 0, 35)
        lbl.Font = Enum.Font.GothamBold
        lbl.Text = text
        lbl.TextSize = 13
        lbl.Parent = parent
        Instance.new("UICorner", lbl).CornerRadius = UDim.new(0, 6)
        registerTheme(lbl, bgRole or "ElementBg", "BackgroundColor3")
        registerTheme(lbl, textRole or "Text", "TextColor3")
        return lbl
    end

    local function createLabelAndBox(parent, labelText, defaultText)
        local frame = Instance.new("Frame")
        frame.Size = UDim2.new(0.9, 0, 0, 35)
        frame.BackgroundTransparency = 1
        frame.Parent = parent

        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(0.65, -5, 1, 0)
        label.BackgroundTransparency = 1
        label.Font = Enum.Font.Gotham
        label.TextSize = 13
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.Text = labelText
        label.Parent = frame
        registerTheme(label, "Text", "TextColor3")

        local box = Instance.new("TextBox")
        box.Size = UDim2.new(0.35, 0, 1, 0)
        box.Position = UDim2.new(0.65, 5, 0, 0)
        box.Font = Enum.Font.GothamBold
        box.TextSize = 13
        box.Text = defaultText
        box.Parent = frame
        Instance.new("UICorner", box).CornerRadius = UDim.new(0, 6)
        registerTheme(box, "ElementBg", "BackgroundColor3")
        registerTheme(box, "Text", "TextColor3")

        return box, frame
    end

    local function createListFrame(parent)
        local scroll = Instance.new("ScrollingFrame")
        scroll.Size = UDim2.new(0.9, 0, 0, 150)
        scroll.BorderSizePixel = 0
        scroll.ScrollBarThickness = 6
        scroll.Parent = parent
        Instance.new("UICorner", scroll).CornerRadius = UDim.new(0, 6)
        registerTheme(scroll, "NavBg", "BackgroundColor3")
        
        local layout = Instance.new("UIListLayout")
        layout.Parent = scroll
        layout.SortOrder = Enum.SortOrder.LayoutOrder
        layout.Padding = UDim.new(0, 4)
        layout.HorizontalAlignment = Enum.HorizontalAlignment.Center

        local pad = Instance.new("UIPadding")
        pad.Parent = scroll
        pad.PaddingTop = UDim.new(0, 5)
        pad.PaddingBottom = UDim.new(0, 5)

        return scroll
    end

    createInfoLabel(Page_Home, "Owner: tree3")
    createInfoLabel(Page_Home, "100% Safe", "ElementBg", "AccentText")
    
    -- SERVER HOP & REJOIN (FIXED FOR BLOX FRUITS SEAS & RESTRICTIONS)
    local ServerHopButton = createButton(Page_Home, "Server Hop", "Warning")
    table.insert(connections, ServerHopButton.MouseButton1Click:Connect(function()
        ServerHopButton.Text = "Searching Server..."
        task.spawn(function()
            local success = false
            while not success do
                pcall(function()
                    local req = (request or http_request or (syn and syn.request))
                    if req then
                        local res = req({Url = "https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100"})
                        if res and res.Body then
                            local body = HttpService:JSONDecode(res.Body)
                            if body and body.data then
                                for _, v in pairs(body.data) do
                                    if type(v) == "table" and v.playing < v.maxPlayers and v.id ~= game.JobId then
                                        ServerHopButton.Text = "Teleporting..."
                                        TeleportService:TeleportToPlaceInstance(game.PlaceId, v.id, LocalPlayer)
                                        task.wait(3)
                                    end
                                end
                            end
                        end
                    end
                end)
                ServerHopButton.Text = "Retrying Hop..."
                task.wait(2)
            end
        end)
    end))

    local RejoinButton = createButton(Page_Home, "Rejoin", "Accent")
    table.insert(connections, RejoinButton.MouseButton1Click:Connect(function()
        RejoinButton.Text = "Rejoining..."
        task.spawn(function()
            while true do
                pcall(function()
                    TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer)
                end)
                task.wait(2)
            end
        end)
    end))

    -- === BLOX FRUITS PAGE ===
    local M1ScalerButton = createButton(Page_BloxFruits, "M1 Hitbox Scaler: [ OFF ]", "ElementBg")
    local M1SizeBox, _ = createLabelAndBox(Page_BloxFruits, "M1 Hitbox Size:", "20")
    local M1TranspBox, _ = createLabelAndBox(Page_BloxFruits, "Transparency (0-1):", "0.7")

    local FruitEspButton = createButton(Page_BloxFruits, "Fruit ESP: [ OFF ]", "ElementBg")
    local FruitTpModeButton = createButton(Page_BloxFruits, "Fruit TP: Teleport")
    local FruitTpSpeedBox, FruitTpSpeedFrame = createLabelAndBox(Page_BloxFruits, "Tween Speed:", "50")
    local FruitTpButton = createButton(Page_BloxFruits, "TP to Fruit", "Accent")
    local FruitAutoTpButton = createButton(Page_BloxFruits, "Auto TP Fruit: [ OFF ]", "ElementBg")

    local BoatFlyButton = createButton(Page_BloxFruits, "Boat Fly: [ OFF ]")
    local BoatWSpeedBox, _ = createLabelAndBox(Page_BloxFruits, "W Speed (0.01-5):", "0.05")
    local BoatQESpeedBox, _ = createLabelAndBox(Page_BloxFruits, "Q/E Speed (1-50):", "5")
    createInfoLabel(Page_BloxFruits, "W = Forward | Q/E = Up/Down")
    
    FruitTpSpeedFrame.Visible = false

    -- M1 Hitbox Scaler logic
    table.insert(connections, M1ScalerButton.MouseButton1Click:Connect(function()
        m1ScalerEnabled = not m1ScalerEnabled
        M1ScalerButton.Text = m1ScalerEnabled and "M1 Hitbox Scaler: [ ON ]" or "M1 Hitbox Scaler: [ OFF ]"
        M1ScalerButton.BackgroundColor3 = m1ScalerEnabled and Theme.Accent or Theme.ElementBg
        
        if not m1ScalerEnabled then
            for part, data in pairs(originalM1Sizes) do
                if part and part.Parent then
                    part.Size = data.Size
                    part.Transparency = data.Transparency
                    part.CanCollide = data.CanCollide
                end
            end
            table.clear(originalM1Sizes)
        end
    end))

    table.insert(connections, RunService.Heartbeat:Connect(function()
        if m1ScalerEnabled then
            local char = LocalPlayer.Character
            local bp = LocalPlayer:FindFirstChildOfClass("Backpack")
            local sizeVal = tonumber(M1SizeBox.Text) or 20
            local transpVal = tonumber(M1TranspBox.Text) or 0.7
            transpVal = math.clamp(transpVal, 0, 1)

            local tools = {}
            if char then for _, v in ipairs(char:GetChildren()) do if v:IsA("Tool") then table.insert(tools, v) end end end
            if bp then for _, v in ipairs(bp:GetChildren()) do if v:IsA("Tool") then table.insert(tools, v) end end end

            for _, tool in ipairs(tools) do
                for _, part in ipairs(tool:GetDescendants()) do
                    if part:IsA("BasePart") then
                        if part.Name == "Handle" or part.Name == "Hitbox" or part.Name == "Part" or part.Name == "Blade" or part.Name == "RightHand" then
                            if not originalM1Sizes[part] then
                                originalM1Sizes[part] = {Size = part.Size, Transparency = part.Transparency, CanCollide = part.CanCollide}
                            end
                            part.Size = Vector3.new(sizeVal, sizeVal, sizeVal)
                            part.Transparency = transpVal
                            part.CanCollide = false
                        end
                    end
                end
            end
        end
    end))

    table.insert(connections, FruitEspButton.MouseButton1Click:Connect(function()
        fruitEspEnabled = not fruitEspEnabled
        FruitEspButton.Text = fruitEspEnabled and "Fruit ESP: [ ON ]" or "Fruit ESP: [ OFF ]"
        FruitEspButton.BackgroundColor3 = fruitEspEnabled and Theme.Accent or Theme.ElementBg
        
        if fruitEspEnabled then
            task.spawn(function()
                while fruitEspEnabled do
                    pcall(updateFruitESP)
                    task.wait(1)
                end
            end)
        else
            clearFruitESP()
        end
    end))

    table.insert(connections, FruitTpModeButton.MouseButton1Click:Connect(function()
        if fruitTpMode == "Teleport" then
            fruitTpMode = "Tween"
            FruitTpModeButton.Text = "Fruit TP: Tween"
            FruitTpSpeedFrame.Visible = true
        else
            fruitTpMode = "Teleport"
            FruitTpModeButton.Text = "Fruit TP: Teleport"
            FruitTpSpeedFrame.Visible = false
        end
    end))

    table.insert(connections, FruitTpButton.MouseButton1Click:Connect(function()
        doFruitTp(fruitTpMode, FruitTpSpeedBox.Text)
    end))

    table.insert(connections, FruitAutoTpButton.MouseButton1Click:Connect(function()
        fruitAutoTpEnabled = not fruitAutoTpEnabled
        FruitAutoTpButton.Text = fruitAutoTpEnabled and "Auto TP Fruit: [ ON ]" or "Auto TP Fruit: [ OFF ]"
        FruitAutoTpButton.BackgroundColor3 = fruitAutoTpEnabled and Theme.Accent or Theme.ElementBg
        if fruitAutoTpEnabled then
            startAutoFruitTp()
        else
            if fruitAutoTpConnection then fruitAutoTpConnection:Disconnect(); fruitAutoTpConnection = nil end
        end
    end))

    -- Boat Fly
    local boatOn = false
    local boatConn = nil
    local boatHeightOffset = 0
    local boatStartY = nil
    
    local function getBoat()
        local c = LocalPlayer.Character; if not c then return end
        local h = c:FindFirstChild("Humanoid"); if not h or not h.SeatPart then return end
        local m = h.SeatPart.Parent
        while m and m ~= workspace do if m:IsA("Model") and m ~= c then return m end; m = m.Parent end
        return h.SeatPart.Parent
    end
    
    local function getAllParts(boat)
        local parts = {}
        for _,p in ipairs(boat:GetDescendants()) do if p:IsA("BasePart") then table.insert(parts, p) end end
        return parts
    end
    
    local function disableBoatFly()
        boatOn = false
        BoatFlyButton.Text = "Boat Fly: [ OFF ]"
        BoatFlyButton.BackgroundColor3 = Theme.ElementBg
        if boatConn then boatConn:Disconnect(); boatConn = nil end
        local b = getBoat()
        if b then
            for _,p in ipairs(getAllParts(b)) do p.CanCollide = true end
        end
    end

    local function driveBoat()
        local boat = getBoat()
        if not boat then disableBoatFly() return end
        local parts = getAllParts(boat)
        if #parts == 0 then return end
        
        local cam = workspace.CurrentCamera
        local look = cam and cam.CFrame.LookVector or Vector3.new(0,0,-1)
        local fwd = Vector3.new(look.X, 0, look.Z)
        if fwd.Magnitude < 0.01 then fwd = Vector3.new(0,0,-1) else fwd = fwd.Unit end
        
        local spW = tonumber(BoatWSpeedBox.Text) or 0.05
        local spV = tonumber(BoatQESpeedBox.Text) or 5
        
        if UserInputService:IsKeyDown(Enum.KeyCode.Q) then
            boatHeightOffset = boatHeightOffset + spV * 0.1
        elseif UserInputService:IsKeyDown(Enum.KeyCode.E) then
            boatHeightOffset = boatHeightOffset - spV * 0.1
        end
        
        local moveVec = Vector3.zero
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then
            moveVec = fwd * spW
        end
        
        local targetY = (boatStartY or parts[1].Position.Y) + boatHeightOffset
        
        for _, part in ipairs(parts) do
            local newPos = part.Position + moveVec
            newPos = Vector3.new(newPos.X, targetY + (part.Position.Y - parts[1].Position.Y), newPos.Z)
            part.CFrame = CFrame.new(newPos) * (part.CFrame - part.Position)
            part.Velocity = Vector3.zero
            part.RotVelocity = Vector3.zero
        end
    end

    table.insert(connections, BoatFlyButton.MouseButton1Click:Connect(function()
        local boat = getBoat()
        if not boat then return end
        boatOn = not boatOn
        if boatOn then
            local parts = getAllParts(boat)
            if #parts > 0 then boatStartY = parts[1].Position.Y; boatHeightOffset = 0 end
            for _,p in ipairs(parts) do p.CanCollide = false end
            if boatConn then boatConn:Disconnect() end
            boatConn = RunService.Heartbeat:Connect(function() if boatOn then pcall(driveBoat) end end)
            BoatFlyButton.Text = "Boat Fly: [ ON ]"
            BoatFlyButton.BackgroundColor3 = Theme.Accent
        else
            disableBoatFly()
        end
    end))

    task.spawn(function()
        while task.wait(0.5) do
            if boatOn and not getBoat() then disableBoatFly() end
        end
    end)
    table.insert(connections, LocalPlayer.CharacterAdded:Connect(function() disableBoatFly() end))

    -- TP Tween Page
    local TpModeButton = createButton(Page_TPTween, "Mode: Teleport")
    local TpPlayerList = createListFrame(Page_TPTween)
    local TpSpeedBox, TpSpeedFrame = createLabelAndBox(Page_TPTween, "Tween Speed:", "50")
    TpSpeedFrame.Visible = false
    local TPButton = createButton(Page_TPTween, "TP to Player", "Accent")
    local UntweenButton = createButton(Page_TPTween, "Untween", "Danger")
    UntweenButton.Visible = false
    local TPToolButton = createButton(Page_TPTween, "Give TPTool", "Accent")
    
    local CoordFrame = Instance.new("Frame")
    CoordFrame.Size = UDim2.new(0.9, 0, 0, 35)
    CoordFrame.BackgroundTransparency = 1
    CoordFrame.Parent = Page_TPTween

    local function makeXYZBox(parent, name, pos)
        local box = Instance.new("TextBox")
        box.Size = UDim2.new(0.32, 0, 1, 0)
        box.Position = pos
        box.Font = Enum.Font.GothamBold
        box.TextSize = 13
        box.PlaceholderText = name
        box.Text = ""
        box.Parent = parent
        Instance.new("UICorner", box).CornerRadius = UDim.new(0, 6)
        registerTheme(box, "ElementBg", "BackgroundColor3")
        registerTheme(box, "Text", "TextColor3")
        return box
    end

    local XBox = makeXYZBox(CoordFrame, "X", UDim2.new(0, 0, 0, 0))
    local YBox = makeXYZBox(CoordFrame, "Y", UDim2.new(0.34, 0, 0, 0))
    local ZBox = makeXYZBox(CoordFrame, "Z", UDim2.new(0.68, 0, 0, 0))

    local GoCoordButton = createButton(Page_TPTween, "Go to Coordinate", "Warning")

    -- Aim Assist Page (UPDATED TO MOUSE LOCK)
    local AimActivateButton = createButton(Page_AimAssist, "System State: [ ACTIVATED ]", "Accent")
    local AimStatusButton = createButton(Page_AimAssist, "Lock Status: [ OFF ]", "ElementBg", "DangerText")
    AimStatusButton.AutoButtonColor = false
    local AimTypeButton = createButton(Page_AimAssist, "Type: Mouse Lock")
    local AimModeButton = createButton(Page_AimAssist, "Target Mode: Closest Player")
    local AimKeyButton = createButton(Page_AimAssist, "Toggle Key: [ " .. currentSettings.AimKey .. " ]")
    
    local AimWallCheckButton = createButton(Page_AimAssist, wallCheckEnabled and "Wall Check: [ ON ]" or "Wall Check: [ OFF ]", wallCheckEnabled and "Accent" or "ElementBg")
    local AimPlayerList = createListFrame(Page_AimAssist)
    AimPlayerList.Visible = false

    -- ESP Page
    local EspNameButton = createButton(Page_Esp, espNameEnabled and "Names ESP: [ ON ]" or "Names ESP: [ OFF ]", espNameEnabled and "Accent" or "ElementBg")
    local EspBodyButton = createButton(Page_Esp, espBodyEnabled and "Body ESP: [ ON ]" or "Body ESP: [ OFF ]", espBodyEnabled and "Accent" or "ElementBg")

    -- Utility Page
    local UtilFlyButton = createButton(Page_Utility, "Fly: [ OFF ]")
    local UtilFlyKeyButton = createButton(Page_Utility, "Fly Toggle Key: [ " .. currentSettings.FlyKey .. " ]")
    local UtilFlySpeedBox, _ = createLabelAndBox(Page_Utility, "Fly Speed:", "50")
    local UtilSpeedButton = createButton(Page_Utility, "Speed Hack: [ OFF ]")
    local UtilSpeedBox, _ = createLabelAndBox(Page_Utility, "Speed Value:", "100")
    local UtilJumpButton = createButton(Page_Utility, "Jump Hack: [ OFF ]")
    local UtilJumpBox, _ = createLabelAndBox(Page_Utility, "Jump Value:", "100")
    
    local SuperMoveButton = createButton(Page_Utility, "SuperMovement: [ OFF ]")
    local SuperXBox, _ = createLabelAndBox(Page_Utility, "XSpeed:", "50")
    local SuperYBox, _ = createLabelAndBox(Page_Utility, "YSpeed:", "50")

    -- Hitbox Page
    local HitboxToggleButton = createButton(Page_Hitbox, hitboxEnabled and "Hitbox: [ ON ]" or "Hitbox: [ OFF ]", hitboxEnabled and "Accent" or "ElementBg")
    local HitboxSizeBox, _ = createLabelAndBox(Page_Hitbox, "Hitbox Size:", currentSettings.HitboxSize)
    local HitboxModeButton = createButton(Page_Hitbox, "Mode: All Players")
    local HitboxPlayerList = createListFrame(Page_Hitbox)
    HitboxPlayerList.Visible = false

    -- AutoKill Page
    local AutoKillTypeButton = createButton(Page_AutoKill, "Target Type: Player")
    local AutoKillModeButton = createButton(Page_AutoKill, "Mode: Tween")
    local AutoKill50StudButton = createButton(Page_AutoKill, "Tween -> TP (50 Studs): [ OFF ]", "ElementBg")
    AutoKill50StudButton.Visible = false
    local AutoKillToggleButton = createButton(Page_AutoKill, "AutoKill: [ OFF ]", "ElementBg")
    local AutoKillSpeedBox, AutoKillSpeedFrame = createLabelAndBox(Page_AutoKill, "Tween Speed:", "50")
    local AutoKillHealthBox, _ = createLabelAndBox(Page_AutoKill, "Health Limit %:", "30")
    local AutoKillHeightBox, _ = createLabelAndBox(Page_AutoKill, "Safe Height:", "500")
    local AutoKillList = createListFrame(Page_AutoKill)

    -- Settings Page
    local ThemeButton = createButton(Page_Settings, "Theme: " .. currentThemeName)
    local AimUiKeyButton = createButton(Page_Settings, "Global UI Key: [ " .. currentSettings.UIKey .. " ]")
    local UiAnimButton = createButton(Page_Settings, "UI Animations: [ " .. (currentSettings.UIAnimations and "ON" or "OFF") .. " ]", currentSettings.UIAnimations and "Accent" or "ElementBg")
    local WhitelistToggle = createButton(Page_Settings, whitelistEnabled and "Whitelist: [ ON ]" or "Whitelist: [ OFF ]", whitelistEnabled and "Accent" or "ElementBg")
    local WhitelistPlayerList = createListFrame(Page_Settings)
    WhitelistPlayerList.Visible = whitelistEnabled
    local DeleteDataButton = createButton(Page_Settings, "Reset All Data", "Danger")

    local function switchTab(tabId)
        currentCategory = tabId
        for id, page in pairs(Pages) do
            page.Visible = (id == tabId)
        end
        for id, btn in pairs(TabButtons) do
            if id == tabId then
                btn.BackgroundColor3 = Theme.Accent
            else
                btn.BackgroundColor3 = Theme.ElementBg
            end
        end
    end

    for id, btn in pairs(TabButtons) do
        table.insert(connections, btn.MouseButton1Click:Connect(function()
            switchTab(id)
        end))
    end
    switchTab("Home")

    local function cleanupTween()
        if activeTweenConnection then
            activeTweenConnection:Disconnect()
            activeTweenConnection = nil
        end
        local char = LocalPlayer.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            char.HumanoidRootPart.Anchored = false
        end
    end

    local function cleanupAutoKill()
        if autoKillConnection then
            autoKillConnection:Disconnect()
            autoKillConnection = nil
        end
        local char = LocalPlayer.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            char.HumanoidRootPart.Anchored = false
        end
        autoKillEnabled = false
        AutoKillToggleButton.Text = "AutoKill: [ OFF ]"
        AutoKillToggleButton.BackgroundColor3 = Theme.ElementBg
    end
    
    local function toggleFlyState(forceOff)
        if forceOff and not flyEnabled then return end
        flyEnabled = not flyEnabled
        
        UtilFlyButton.Text = flyEnabled and "Fly: [ ON ]" or "Fly: [ OFF ]"
        UtilFlyButton.BackgroundColor3 = flyEnabled and Theme.Accent or Theme.ElementBg
        
        local char = LocalPlayer.Character
        if not char or not char:FindFirstChild("HumanoidRootPart") then 
            flyEnabled = false
            UtilFlyButton.Text = "Fly: [ OFF ]"
            UtilFlyButton.BackgroundColor3 = Theme.ElementBg
            return 
        end
        
        if flyEnabled then
            char.Humanoid.PlatformStand = true
        else
            char.Humanoid.PlatformStand = false
            char.HumanoidRootPart.Velocity = Vector3.zero
        end
    end

    table.insert(connections, SuperMoveButton.MouseButton1Click:Connect(function()
        superMovementEnabled = not superMovementEnabled
        SuperMoveButton.Text = superMovementEnabled and "SuperMovement: [ ON ]" or "SuperMovement: [ OFF ]"
        SuperMoveButton.BackgroundColor3 = superMovementEnabled and Theme.Accent or Theme.ElementBg
        
        local char = LocalPlayer.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            char.HumanoidRootPart.Anchored = superMovementEnabled
        end
    end))

    table.insert(connections, UtilFlyButton.MouseButton1Click:Connect(function()
        toggleFlyState()
    end))

    table.insert(connections, LocalPlayer.CharacterAdded:Connect(function(newChar)
        toggleFlyState(true)
        cleanupAutoKill()
        cleanupTween()
        originalSpeed = nil
        originalJumpPower = nil
        superMovementEnabled = false
        SuperMoveButton.Text = "SuperMovement: [ OFF ]"
        SuperMoveButton.BackgroundColor3 = Theme.ElementBg
    end))

    table.insert(connections, MinButton.MouseButton1Click:Connect(function()
        isMinimized = not isMinimized
        if isMinimized then
            ContentArea.Visible = false
            if currentSettings.UIAnimations then
                TweenService:Create(MainFrame, TweenInfo.new(0.3), {Size = UDim2.new(0, 580, 0, 35)}):Play()
            else
                MainFrame.Size = UDim2.new(0, 580, 0, 35)
            end
        else
            ContentArea.Visible = true
            if currentSettings.UIAnimations then
                TweenService:Create(MainFrame, TweenInfo.new(0.3), {Size = UDim2.new(0, 580, 0, 450)}):Play()
            else
                MainFrame.Size = UDim2.new(0, 580, 0, 450)
            end
        end
    end))

    table.insert(connections, CloseButton.MouseButton1Click:Connect(function()
        if currentSettings.UIAnimations then
            local t = TweenService:Create(mainScale, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In), {Scale = 0})
            t:Play()
            t.Completed:Wait()
        end
        ConfirmFrame.Visible = true
        MainFrame.Visible = false
        if currentSettings.UIAnimations then mainScale.Scale = 1 end
    end))

    table.insert(connections, ConfirmNo.MouseButton1Click:Connect(function()
        ConfirmFrame.Visible = false
        MainFrame.Visible = true
        if currentSettings.UIAnimations then
            mainScale.Scale = 0
            TweenService:Create(mainScale, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Scale = 1}):Play()
        end
    end))

    local function cleanEverything()
        for _, conn in ipairs(connections) do
            if conn then conn:Disconnect() end
        end
        cleanupTween()
        cleanupAutoKill()
        
        fruitEspEnabled = false
        fruitAutoTpEnabled = false
        if fruitAutoTpConnection then fruitAutoTpConnection:Disconnect() end
        if fruitTpConnection then fruitTpConnection:Disconnect() end
        clearFruitESP()
        
        local char = LocalPlayer.Character
        if char and char:FindFirstChild("Humanoid") then
            if originalSpeed then char.Humanoid.WalkSpeed = originalSpeed end
            if originalJumpPower then char.Humanoid.JumpPower = originalJumpPower end
            if originalJumpHeight then char.Humanoid.JumpHeight = originalJumpHeight end
            if originalUseJumpPower ~= nil then char.Humanoid.UseJumpPower = originalUseJumpPower end
            char.Humanoid.PlatformStand = false
            if char:FindFirstChild("HumanoidRootPart") then char.HumanoidRootPart.Anchored = false end
        end

        for _, player in pairs(Players:GetPlayers()) do
            if player.Character then
                local head = player.Character:FindFirstChild("Head")
                if head and head:FindFirstChild("treeHubNameEsp") then head.treeHubNameEsp:Destroy() end
                local highlight = player.Character:FindFirstChild("treeHubBodyEsp")
                if highlight then highlight:Destroy() end
                local hrp = player.Character:FindFirstChild("HumanoidRootPart")
                if hrp then
                    hrp.Size = Vector3.new(2, 2, 1)
                    hrp.Transparency = 1
                    hrp.CanCollide = true
                end
            end
        end
        ScreenGui:Destroy()
    end

    table.insert(connections, ConfirmYes.MouseButton1Click:Connect(function()
        cleanEverything()
    end))

    table.insert(connections, DeleteDataButton.MouseButton1Click:Connect(function()
        pcall(function()
            if isfile and isfile(configName) then
                delfile(configName)
            end
        end)
        applyDefaultSettings()
        cleanEverything()
        task.wait(0.2)
        StartTreeHub()
    end))

    -- Whitelist
    table.insert(connections, WhitelistToggle.MouseButton1Click:Connect(function()
        whitelistEnabled = not whitelistEnabled
        currentSettings.WhitelistEnabled = whitelistEnabled
        WhitelistToggle.Text = whitelistEnabled and "Whitelist: [ ON ]" or "Whitelist: [ OFF ]"
        WhitelistToggle.BackgroundColor3 = whitelistEnabled and Theme.Accent or Theme.ElementBg
        WhitelistPlayerList.Visible = whitelistEnabled
        if not whitelistEnabled then
            whitelistedPlayers = {}
            currentSettings.WhitelistedPlayers = {}
        end
        saveSettings()
        updateLists()
    end))

    table.insert(connections, UiAnimButton.MouseButton1Click:Connect(function()
        currentSettings.UIAnimations = not currentSettings.UIAnimations
        UiAnimButton.Text = "UI Animations: [ " .. (currentSettings.UIAnimations and "ON" or "OFF") .. " ]"
        UiAnimButton.BackgroundColor3 = currentSettings.UIAnimations and Theme.Accent or Theme.ElementBg
        saveSettings()
    end))

    table.insert(connections, ThemeButton.MouseButton1Click:Connect(function()
        currentThemeIndex = currentThemeIndex + 1
        if currentThemeIndex > #ThemeOrder then
            currentThemeIndex = 1
        end
        currentThemeName = ThemeOrder[currentThemeIndex]
        currentSettings.Theme = currentThemeName
        ThemeButton.Text = "Theme: " .. currentThemeName
        applyTheme(true)
        switchTab(currentCategory)
        saveSettings()
    end))

    table.insert(connections, HitboxSizeBox:GetPropertyChangedSignal("Text"):Connect(function()
        currentSettings.HitboxSize = HitboxSizeBox.Text
        saveSettings()
    end))

    -- OPTIMIZED NPC SCANNER (KASMA VE DONMA YAPMAZ)
    local function getNPCs()
        local npcNames = {}
        for _, obj in ipairs(workspace:GetChildren()) do
            if obj:IsA("Model") and obj:FindFirstChildOfClass("Humanoid") and obj:FindFirstChild("HumanoidRootPart") then
                if not Players:GetPlayerFromCharacter(obj) then
                    npcNames[obj.Name] = true
                end
            elseif obj:IsA("Folder") or obj:IsA("Model") then
                for _, child in ipairs(obj:GetChildren()) do
                    if child:IsA("Model") and child:FindFirstChildOfClass("Humanoid") and child:FindFirstChild("HumanoidRootPart") then
                        if not Players:GetPlayerFromCharacter(child) then
                            npcNames[child.Name] = true
                        end
                    end
                end
            end
        end
        local list = {}
        for k in pairs(npcNames) do table.insert(list, k) end
        table.sort(list)
        return list
    end

    local function updateLists()
        for _, child in ipairs(TpPlayerList:GetChildren()) do if child:IsA("TextButton") then child:Destroy() end end
        for _, child in ipairs(AimPlayerList:GetChildren()) do if child:IsA("TextButton") then child:Destroy() end end
        for _, child in ipairs(HitboxPlayerList:GetChildren()) do if child:IsA("TextButton") then child:Destroy() end end
        for _, child in ipairs(AutoKillList:GetChildren()) do if child:IsA("TextButton") then child:Destroy() end end
        for _, child in ipairs(WhitelistPlayerList:GetChildren()) do if child:IsA("TextButton") then child:Destroy() end end

        local tpCount, aimCount, hitCount, akCount, wlCount = 0, 0, 0, 0, 0

        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer then
                local tpBtn = Instance.new("TextButton")
                tpBtn.Size = UDim2.new(0.9, 0, 0, 28)
                tpBtn.BackgroundColor3 = (tpSelectedPlayer == player) and Theme.Accent or Theme.ElementBg
                tpBtn.Text = player.Name
                tpBtn.TextColor3 = Theme.Text
                tpBtn.Font = Enum.Font.Gotham
                tpBtn.TextSize = 13
                tpBtn.Parent = TpPlayerList
                Instance.new("UICorner", tpBtn).CornerRadius = UDim.new(0, 4)
                table.insert(connections, tpBtn.MouseButton1Click:Connect(function()
                    tpSelectedPlayer = player
                    updateLists()
                end))
                tpCount = tpCount + 1

                local aimBtn = Instance.new("TextButton")
                aimBtn.Size = UDim2.new(0.9, 0, 0, 28)
                aimBtn.BackgroundColor3 = (aimSelectedTarget == player) and Theme.Accent or Theme.ElementBg
                aimBtn.Text = player.Name
                aimBtn.TextColor3 = Theme.Text
                aimBtn.Font = Enum.Font.Gotham
                aimBtn.TextSize = 13
                aimBtn.Parent = AimPlayerList
                Instance.new("UICorner", aimBtn).CornerRadius = UDim.new(0, 4)
                table.insert(connections, aimBtn.MouseButton1Click:Connect(function()
                    aimSelectedTarget = player
                    updateLists()
                end))
                aimCount = aimCount + 1

                local hitBtn = Instance.new("TextButton")
                hitBtn.Size = UDim2.new(0.9, 0, 0, 28)
                hitBtn.BackgroundColor3 = hitboxSelectedPlayers[player.Name] and Theme.Accent or Theme.ElementBg
                hitBtn.Text = player.Name
                hitBtn.TextColor3 = Theme.Text
                hitBtn.Font = Enum.Font.Gotham
                hitBtn.TextSize = 13
                hitBtn.Parent = HitboxPlayerList
                Instance.new("UICorner", hitBtn).CornerRadius = UDim.new(0, 4)
                table.insert(connections, hitBtn.MouseButton1Click:Connect(function()
                    if hitboxSelectedPlayers[player.Name] then
                        hitboxSelectedPlayers[player.Name] = nil
                    else
                        hitboxSelectedPlayers[player.Name] = true
                    end
                    updateLists()
                end))
                hitCount = hitCount + 1

                if autoKillTargetType == "Player" then
                    local akBtn = Instance.new("TextButton")
                    akBtn.Size = UDim2.new(0.9, 0, 0, 28)
                    akBtn.BackgroundColor3 = (autoKillTarget == player) and Theme.Accent or Theme.ElementBg
                    akBtn.Text = player.Name
                    akBtn.TextColor3 = Theme.Text
                    akBtn.Font = Enum.Font.Gotham
                    akBtn.TextSize = 13
                    akBtn.Parent = AutoKillList
                    Instance.new("UICorner", akBtn).CornerRadius = UDim.new(0, 4)
                    table.insert(connections, akBtn.MouseButton1Click:Connect(function()
                        autoKillTarget = player
                        updateLists()
                    end))
                    akCount = akCount + 1
                end

                local wlBtn = Instance.new("TextButton")
                wlBtn.Size = UDim2.new(0.9, 0, 0, 28)
                wlBtn.BackgroundColor3 = whitelistedPlayers[player.Name] and Theme.Accent or Theme.ElementBg
                wlBtn.Text = player.Name
                wlBtn.TextColor3 = Theme.Text
                wlBtn.Font = Enum.Font.Gotham
                wlBtn.TextSize = 13
                wlBtn.Parent = WhitelistPlayerList
                Instance.new("UICorner", wlBtn).CornerRadius = UDim.new(0, 4)
                table.insert(connections, wlBtn.MouseButton1Click:Connect(function()
                    if whitelistedPlayers[player.Name] then
                        whitelistedPlayers[player.Name] = nil
                    else
                        whitelistedPlayers[player.Name] = true
                    end
                    local wlArray = {}
                    for name, _ in pairs(whitelistedPlayers) do
                        table.insert(wlArray, name)
                    end
                    currentSettings.WhitelistedPlayers = wlArray
                    saveSettings()
                    updateLists()
                end))
                wlCount = wlCount + 1
            end
        end

        if autoKillTargetType == "NPC" then
            local npcs = getNPCs()
            for _, npcName in ipairs(npcs) do
                local akBtn = Instance.new("TextButton")
                akBtn.Size = UDim2.new(0.9, 0, 0, 28)
                akBtn.BackgroundColor3 = (autoKillTargetName == npcName) and Theme.Accent or Theme.ElementBg
                akBtn.Text = npcName
                akBtn.TextColor3 = Theme.Text
                akBtn.Font = Enum.Font.Gotham
                akBtn.TextSize = 13
                akBtn.Parent = AutoKillList
                Instance.new("UICorner", akBtn).CornerRadius = UDim.new(0, 4)
                table.insert(connections, akBtn.MouseButton1Click:Connect(function()
                    autoKillTargetName = npcName
                    updateLists()
                end))
                akCount = akCount + 1
            end
        end

        TpPlayerList.CanvasSize = UDim2.new(0, 0, 0, (tpCount * 32) + 10)
        AimPlayerList.CanvasSize = UDim2.new(0, 0, 0, (aimCount * 32) + 10)
        HitboxPlayerList.CanvasSize = UDim2.new(0, 0, 0, (hitCount * 32) + 10)
        AutoKillList.CanvasSize = UDim2.new(0, 0, 0, (akCount * 32) + 10)
        WhitelistPlayerList.CanvasSize = UDim2.new(0, 0, 0, (wlCount * 32) + 10)
    end

    table.insert(connections, Players.PlayerAdded:Connect(updateLists))
    table.insert(connections, Players.PlayerRemoving:Connect(function(p)
        if whitelistedPlayers[p.Name] then
            whitelistedPlayers[p.Name] = nil
            local wlArray = {}
            for name, _ in pairs(whitelistedPlayers) do
                table.insert(wlArray, name)
            end
            currentSettings.WhitelistedPlayers = wlArray
            saveSettings()
        end
        updateLists()
    end))
    updateLists()

    table.insert(connections, TpModeButton.MouseButton1Click:Connect(function()
        if tpCurrentMode == "Teleport" then
            tpCurrentMode = "Tween"
            TpModeButton.Text = "Mode: Tween"
            TPButton.Text = "Tween to Player"
            TpSpeedFrame.Visible = true
            UntweenButton.Visible = true
        else
            tpCurrentMode = "Teleport"
            TpModeButton.Text = "Mode: Teleport"
            TPButton.Text = "TP to Player"
            TpSpeedFrame.Visible = false
            UntweenButton.Visible = false
        end
    end))

    table.insert(connections, UntweenButton.MouseButton1Click:Connect(cleanupTween))

    table.insert(connections, GoCoordButton.MouseButton1Click:Connect(function()
        local x = tonumber(XBox.Text)
        local y = tonumber(YBox.Text)
        local z = tonumber(ZBox.Text)
        if not (x and y and z) then return end
        
        local myChar = LocalPlayer.Character
        if not myChar then return end
        local myRoot = myChar:FindFirstChild("HumanoidRootPart")
        if not myRoot then return end

        local targetPos = Vector3.new(x, y, z)
        cleanupTween()

        if tpCurrentMode == "Teleport" then
            myRoot.CFrame = CFrame.new(targetPos)
        elseif tpCurrentMode == "Tween" then
            local speedInput = tonumber(TpSpeedBox.Text) or 50
            local speed = math.clamp(speedInput, 1, 1000)

            myRoot.Anchored = true

            activeTweenConnection = RunService.Heartbeat:Connect(function(dt)
                if not myChar or not myChar:FindFirstChild("Humanoid") or myChar.Humanoid.Health <= 0 then
                    cleanupTween()
                    return
                end
                
                local dist = (targetPos - myRoot.Position).Magnitude
                if dist < 3 then
                    cleanupTween()
                    return
                end

                local dir = (targetPos - myRoot.Position).Unit
                myRoot.CFrame = myRoot.CFrame + (dir * speed * dt)
            end)
        end
    end))

    table.insert(connections, TPButton.MouseButton1Click:Connect(function()
        if not tpSelectedPlayer or not tpSelectedPlayer.Character then return end
        local targetRoot = tpSelectedPlayer.Character:FindFirstChild("HumanoidRootPart")
        local myChar = LocalPlayer.Character
        if not myChar then return end
        local myRoot = myChar:FindFirstChild("HumanoidRootPart")

        if targetRoot and myRoot then
            cleanupTween()

            if tpCurrentMode == "Teleport" then
                myRoot.CFrame = targetRoot.CFrame
            elseif tpCurrentMode == "Tween" then
                local speedInput = tonumber(TpSpeedBox.Text) or 50
                local speed = math.clamp(speedInput, 1, 1000)

                myRoot.Anchored = true

                activeTweenConnection = RunService.Heartbeat:Connect(function(dt)
                    if not tpSelectedPlayer.Character or not tpSelectedPlayer.Character:FindFirstChild("Humanoid") or tpSelectedPlayer.Character.Humanoid.Health <= 0 then
                        cleanupTween()
                        return
                    end
                    
                    if not myChar or not myChar:FindFirstChild("Humanoid") or myChar.Humanoid.Health <= 0 then
                        cleanupTween()
                        return
                    end
                    
                    local currentTargetRoot = tpSelectedPlayer.Character:FindFirstChild("HumanoidRootPart")
                    if not currentTargetRoot or not myRoot or not myRoot.Parent then
                        cleanupTween()
                        return
                    end

                    local dist = (currentTargetRoot.Position - myRoot.Position).Magnitude
                    if dist < 3 then
                        cleanupTween()
                        return
                    end

                    local dir = (currentTargetRoot.Position - myRoot.Position).Unit
                    myRoot.CFrame = myRoot.CFrame + (dir * speed * dt)
                end)
            end
        end
    end))

    -- FIXED TP TOOL CREATION
    table.insert(connections, TPToolButton.MouseButton1Click:Connect(function()
        local backpack = LocalPlayer:FindFirstChildOfClass("Backpack") or LocalPlayer:WaitForChild("Backpack")
        if backpack then
            local existing = backpack:FindFirstChild("TPTool") or (LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("TPTool"))
            if existing then existing:Destroy() end

            local tool = Instance.new("Tool")
            tool.Name = "TPTool"
            tool.RequiresHandle = false
            tool.CanBeDropped = false
            tool.Parent = backpack
            
            table.insert(connections, tool.Activated:Connect(function()
                local char = LocalPlayer.Character
                if char and char:FindFirstChild("HumanoidRootPart") and Mouse.Hit then
                    char.HumanoidRootPart.CFrame = CFrame.new(Mouse.Hit.Position + Vector3.new(0, 3, 0))
                end
            end))
        end
    end))

    table.insert(connections, AutoKillTypeButton.MouseButton1Click:Connect(function()
        if autoKillTargetType == "Player" then
            autoKillTargetType = "NPC"
            AutoKillTypeButton.Text = "Target Type: NPC"
        else
            autoKillTargetType = "Player"
            AutoKillTypeButton.Text = "Target Type: Player"
        end
        autoKillTarget = nil
        autoKillTargetName = nil
        updateLists()
    end))

    table.insert(connections, AutoKillModeButton.MouseButton1Click:Connect(function()
        if autoKillMode == "Tween" then
            autoKillMode = "Tp"
            AutoKillModeButton.Text = "Mode: Tp"
            AutoKillSpeedFrame.Visible = false
            AutoKill50StudButton.Visible = true
        else
            autoKillMode = "Tween"
            AutoKillModeButton.Text = "Mode: Tween"
            AutoKillSpeedFrame.Visible = true
            AutoKill50StudButton.Visible = false
        end
    end))

    table.insert(connections, AutoKill50StudButton.MouseButton1Click:Connect(function()
        autoKill50StudTweenEnabled = not autoKill50StudTweenEnabled
        AutoKill50StudButton.Text = autoKill50StudTweenEnabled and "Tween -> TP (50 Studs): [ ON ]" or "Tween -> TP (50 Studs): [ OFF ]"
        AutoKill50StudButton.BackgroundColor3 = autoKill50StudTweenEnabled and Theme.Accent or Theme.ElementBg
    end))

    -- FIXED AUTOKILL TWEEN MOVEMENT (SABİT HIZ & HEDEFDE YAVAŞLAMA YOK)
    table.insert(connections, AutoKillToggleButton.MouseButton1Click:Connect(function()
        local canStart = false
        if autoKillTargetType == "Player" and autoKillTarget then canStart = true end
        if autoKillTargetType == "NPC" and autoKillTargetName then canStart = true end

        if not autoKillEnabled and canStart then
            autoKillEnabled = true
            AutoKillToggleButton.Text = "AutoKill: [ ON ]"
            AutoKillToggleButton.BackgroundColor3 = Theme.Accent
            
            local myChar = LocalPlayer.Character
            if not myChar then cleanupAutoKill() return end
            local myRoot = myChar:FindFirstChild("HumanoidRootPart")
            if not myRoot then cleanupAutoKill() return end

            autoKillConnection = RunService.Heartbeat:Connect(function(dt)
                myChar = LocalPlayer.Character
                if not myChar or not myChar:FindFirstChild("Humanoid") or myChar.Humanoid.Health <= 0 or not myChar:FindFirstChild("HumanoidRootPart") then
                    cleanupAutoKill()
                    return
                end
                
                myRoot = myChar:FindFirstChild("HumanoidRootPart")
                local myHum = myChar:FindFirstChild("Humanoid")
                local targetRoot = nil

                if autoKillTargetType == "Player" then
                    if not autoKillTarget or not autoKillTarget.Character or not autoKillTarget.Character:FindFirstChild("Humanoid") or autoKillTarget.Character.Humanoid.Health <= 0 then
                        cleanupAutoKill()
                        return
                    end
                    targetRoot = autoKillTarget.Character:FindFirstChild("HumanoidRootPart")
                elseif autoKillTargetType == "NPC" then
                    for _, obj in ipairs(workspace:GetDescendants()) do
                        if obj:IsA("Model") and obj.Name == autoKillTargetName then
                            local hum = obj:FindFirstChildOfClass("Humanoid")
                            local root = obj:FindFirstChild("HumanoidRootPart")
                            if hum and root and hum.Health > 0 and not Players:GetPlayerFromCharacter(obj) then
                                targetRoot = root
                                break
                            end
                        end
                    end
                    if not targetRoot then
                        cleanupAutoKill()
                        return
                    end
                end
                
                if not targetRoot then return end
                
                local healthLimit = (tonumber(AutoKillHealthBox.Text) or 30) / 100
                local heightLimit = tonumber(AutoKillHeightBox.Text) or 500
                
                if myHum.Health < (myHum.MaxHealth * healthLimit) then
                    myRoot.CFrame = CFrame.new(targetRoot.Position + Vector3.new(0, heightLimit, 0))
                else
                    local speedInput = tonumber(AutoKillSpeedBox.Text) or 50
                    local studsPerSec = speedInput * 1.8
                    local targetPos = targetRoot.Position + Vector3.new(0, 0, 2)
                    local currentPos = myRoot.Position
                    local diff = targetPos - currentPos
                    local dist = diff.Magnitude
                    
                    if autoKillMode == "Tween" or (autoKillMode == "Tp" and autoKill50StudTweenEnabled and dist > 50) then
                        myRoot.Anchored = false
                        if dist > 1 then
                            local moveStep = math.min(dist, studsPerSec * dt)
                            myRoot.CFrame = CFrame.new(currentPos + (diff.Unit * moveStep))
                        else
                            myRoot.CFrame = CFrame.new(targetPos)
                        end
                    elseif autoKillMode == "Tp" then
                        myRoot.Anchored = false
                        myRoot.CFrame = CFrame.new(targetPos)
                    end
                end
            end)
        else
            cleanupAutoKill()
        end
    end))

    table.insert(connections, AimActivateButton.MouseButton1Click:Connect(function()
        systemActive = not systemActive
        if systemActive then
            AimActivateButton.BackgroundColor3 = Theme.Accent
            AimActivateButton.Text = "System State: [ ACTIVATED ]"
        else
            AimActivateButton.BackgroundColor3 = Theme.Danger
            AimActivateButton.Text = "System State: [ DEACTIVATED ]"
            aimbotEnabled = false
            AimStatusButton.Text = "Lock Status: [ OFF ]"
            AimStatusButton.TextColor3 = Theme.Danger
        end
    end))

    table.insert(connections, AimTypeButton.MouseButton1Click:Connect(function()
        if aimType == "Camera Lock" then
            aimType = "Mouse Lock"
            AimTypeButton.Text = "Type: Mouse Lock"
        else
            aimType = "Camera Lock"
            AimTypeButton.Text = "Type: Camera Lock"
        end
    end))

    table.insert(connections, AimWallCheckButton.MouseButton1Click:Connect(function()
        wallCheckEnabled = not wallCheckEnabled
        currentSettings.AimWallCheck = wallCheckEnabled
        AimWallCheckButton.Text = wallCheckEnabled and "Wall Check: [ ON ]" or "Wall Check: [ OFF ]"
        AimWallCheckButton.BackgroundColor3 = wallCheckEnabled and Theme.Accent or Theme.ElementBg
        saveSettings()
    end))

    table.insert(connections, AimKeyButton.MouseButton1Click:Connect(function()
        waitingForKey = "AimToggle"
        AimKeyButton.Text = "Press key..."
    end))

    table.insert(connections, AimUiKeyButton.MouseButton1Click:Connect(function()
        waitingForKey = "UIToggle"
        AimUiKeyButton.Text = "Press key..."
    end))

    table.insert(connections, UtilFlyKeyButton.MouseButton1Click:Connect(function()
        waitingForKey = "FlyToggle"
        UtilFlyKeyButton.Text = "Press key..."
    end))

    table.insert(connections, AimModeButton.MouseButton1Click:Connect(function()
        if aimCurrentMode == "Closest" then
            aimCurrentMode = "ByName"
            AimModeButton.Text = "Target Mode: By Name"
            AimPlayerList.Visible = true
        else
            aimCurrentMode = "Closest"
            AimModeButton.Text = "Target Mode: Closest Player"
            AimPlayerList.Visible = false
        end
    end))

    table.insert(connections, EspNameButton.MouseButton1Click:Connect(function()
        espNameEnabled = not espNameEnabled
        currentSettings.EspName = espNameEnabled
        EspNameButton.Text = espNameEnabled and "Names ESP: [ ON ]" or "Names ESP: [ OFF ]"
        EspNameButton.BackgroundColor3 = espNameEnabled and Theme.Accent or Theme.ElementBg
        saveSettings()
    end))

    table.insert(connections, EspBodyButton.MouseButton1Click:Connect(function()
        espBodyEnabled = not espBodyEnabled
        currentSettings.EspBody = espBodyEnabled
        EspBodyButton.Text = espBodyEnabled and "Body ESP: [ ON ]" or "Body ESP: [ OFF ]"
        EspBodyButton.BackgroundColor3 = espBodyEnabled and Theme.Accent or Theme.ElementBg
        saveSettings()
    end))

    table.insert(connections, UtilSpeedButton.MouseButton1Click:Connect(function()
        speedEnabled = not speedEnabled
        UtilSpeedButton.Text = speedEnabled and "Speed Hack: [ ON ]" or "Speed Hack: [ OFF ]"
        UtilSpeedButton.BackgroundColor3 = speedEnabled and Theme.Accent or Theme.ElementBg
        
        local char = LocalPlayer.Character
        if char and char:FindFirstChild("Humanoid") then
            if speedEnabled then
                originalSpeed = char.Humanoid.WalkSpeed
            elseif originalSpeed then
                char.Humanoid.WalkSpeed = originalSpeed
                originalSpeed = nil
            end
        end
    end))

    table.insert(connections, UtilJumpButton.MouseButton1Click:Connect(function()
        jumpEnabled = not jumpEnabled
        UtilJumpButton.Text = jumpEnabled and "Jump Hack: [ ON ]" or "Jump Hack: [ OFF ]"
        UtilJumpButton.BackgroundColor3 = jumpEnabled and Theme.Accent or Theme.ElementBg
        
        local char = LocalPlayer.Character
        if char and char:FindFirstChild("Humanoid") then
            if jumpEnabled then
                originalJumpPower = char.Humanoid.JumpPower
                originalJumpHeight = char.Humanoid.JumpHeight
                originalUseJumpPower = char.Humanoid.UseJumpPower
            elseif originalJumpPower and originalJumpHeight and originalUseJumpPower ~= nil then
                char.Humanoid.JumpPower = originalJumpPower
                char.Humanoid.JumpHeight = originalJumpHeight
                char.Humanoid.UseJumpPower = originalUseJumpPower
                originalJumpPower = nil
                originalJumpHeight = nil
                originalUseJumpPower = nil
            end
        end
    end))

    table.insert(connections, HitboxToggleButton.MouseButton1Click:Connect(function()
        hitboxEnabled = not hitboxEnabled
        currentSettings.HitboxState = hitboxEnabled
        HitboxToggleButton.Text = hitboxEnabled and "Hitbox: [ ON ]" or "Hitbox: [ OFF ]"
        HitboxToggleButton.BackgroundColor3 = hitboxEnabled and Theme.Accent or Theme.ElementBg
        saveSettings()
    end))

    table.insert(connections, HitboxModeButton.MouseButton1Click:Connect(function()
        if hitboxMode == "All Players" then
            hitboxMode = "Selected Players"
            HitboxModeButton.Text = "Mode: Selected Players"
            HitboxPlayerList.Visible = true
        else
            hitboxMode = "All Players"
            HitboxModeButton.Text = "Mode: All Players"
            HitboxPlayerList.Visible = false
        end
    end))

    table.insert(connections, UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if UserInputService:GetFocusedTextBox() then return end

        if waitingForKey then
            if input.UserInputType == Enum.UserInputType.Keyboard then
                local keyName = input.KeyCode.Name
                if waitingForKey == "AimToggle" then
                    currentSettings.AimKey = keyName
                    AimKeyButton.Text = "Toggle Key: [ " .. keyName .. " ]"
                elseif waitingForKey == "UIToggle" then
                    currentSettings.UIKey = keyName
                    AimUiKeyButton.Text = "Global UI Key: [ " .. keyName .. " ]"
                elseif waitingForKey == "FlyToggle" then
                    currentSettings.FlyKey = keyName
                    UtilFlyKeyButton.Text = "Fly Toggle Key: [ " .. keyName .. " ]"
                end
                waitingForKey = nil
                saveSettings()
            end
            return
        end

        if not gameProcessed then
            local aimEnum = Enum.KeyCode[currentSettings.AimKey] or Enum.KeyCode.G
            local uiEnum = Enum.KeyCode[currentSettings.UIKey] or Enum.KeyCode.P
            local flyEnum = Enum.KeyCode[currentSettings.FlyKey] or Enum.KeyCode.K

            if input.KeyCode == uiEnum then
                uiVisible = not uiVisible
                if uiVisible then
                    MainFrame.Visible = true
                    if currentSettings.UIAnimations then
                        mainScale.Scale = 0
                        TweenService:Create(mainScale, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Scale = 1}):Play()
                    end
                else
                    if currentSettings.UIAnimations then
                        local t = TweenService:Create(mainScale, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In), {Scale = 0})
                        t:Play()
                        t.Completed:Connect(function() if not uiVisible then MainFrame.Visible = false end end)
                    else
                        MainFrame.Visible = false
                    end
                end
            elseif input.KeyCode == aimEnum and systemActive then
                aimbotEnabled = not aimbotEnabled
                if aimbotEnabled then
                    AimStatusButton.Text = "Lock Status: [ ON ]"
                    AimStatusButton.TextColor3 = Theme.Accent
                else
                    AimStatusButton.Text = "Lock Status: [ OFF ]"
                    AimStatusButton.TextColor3 = Theme.Danger
                end
            elseif input.KeyCode == flyEnum then
                toggleFlyState()
            end
        end
    end))

    local function getClosestAlivePlayer()
        local closestPlayer = nil
        local shortestDistance = math.huge
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Humanoid") and player.Character.Humanoid.Health > 0 then
                if whitelistEnabled and isPlayerWhitelisted(player) then continue end
                local hrp = player.Character:FindFirstChild("HumanoidRootPart")
                local myHrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                if hrp and myHrp then
                    local distance = (hrp.Position - myHrp.Position).Magnitude
                    if distance < shortestDistance then
                        closestPlayer = player
                        shortestDistance = distance
                    end
                end
            end
        end
        return closestPlayer
    end

    local function lockCameraOnTarget(target)
        if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
            local hrp = target.Character.HumanoidRootPart
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, hrp.Position + Vector3.new(0, hrp.Size.Y / 2, 0))
        end
    end

    -- MOUSE LOCK (ULTRA AKICI, SAĞ TIK PAUSE DESTEKLİ)
    table.insert(connections, RunService.RenderStepped:Connect(function(dt)
        local isRightClickHeld = UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2)

        if systemActive and aimbotEnabled and not isRightClickHeld then
            local target = nil
            if aimCurrentMode == "Closest" then
                target = getClosestAlivePlayer()
            elseif aimCurrentMode == "ByName" then
                if aimSelectedTarget and aimSelectedTarget.Character and aimSelectedTarget.Character:FindFirstChild("Humanoid") and aimSelectedTarget.Character.Humanoid.Health > 0 then
                    if not whitelistEnabled or not isPlayerWhitelisted(aimSelectedTarget) then
                        target = aimSelectedTarget
                    end
                end
            end

            if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
                local targetPart = target.Character.HumanoidRootPart
                local isVisible = true
                if wallCheckEnabled then
                    local rayParams = RaycastParams.new()
                    rayParams.FilterType = Enum.RaycastFilterType.Exclude
                    local ignoreList = {LocalPlayer.Character}
                    if target.Character then table.insert(ignoreList, target.Character) end
                    rayParams.FilterDescendantsInstances = ignoreList
                    local result = workspace:Raycast(Camera.CFrame.Position, targetPart.Position - Camera.CFrame.Position, rayParams)
                    if result then isVisible = false end
                end

                if isVisible then
                    if aimType == "Camera Lock" then
                        lockCameraOnTarget(target)
                    elseif aimType == "Mouse Lock" then
                        local screenPos, onScreen = Camera:WorldToViewportPoint(targetPart.Position)
                        if onScreen then
                            local mouseLoc = UserInputService:GetMouseLocation()
                            local dx = screenPos.X - mouseLoc.X
                            local dy = screenPos.Y - mouseLoc.Y
                            if mousemoverel then
                                mousemoverel(dx, dy)
                            end
                        else
                            lockCameraOnTarget(target)
                        end
                    end
                end
            end
        end

        local char = LocalPlayer.Character
        if char and char:FindFirstChild("Humanoid") and char:FindFirstChild("HumanoidRootPart") then
            local hum = char.Humanoid
            local hrp = char.HumanoidRootPart
            
            if speedEnabled then
                local sVal = tonumber(UtilSpeedBox.Text) or 100
                hum.WalkSpeed = sVal
                if hum.MoveDirection.Magnitude > 0 then
                    local extraSpeed = math.max(0, sVal - 16)
                    hrp.CFrame = hrp.CFrame + (hum.MoveDirection * (extraSpeed * dt))
                end
            end

            if superMovementEnabled then
                local xSpeed = tonumber(SuperXBox.Text) or 50
                local ySpeed = tonumber(SuperYBox.Text) or 50
                local camDir = Camera.CFrame.LookVector
                local rightVec = Camera.CFrame.RightVector
                
                local flatCamDir = Vector3.new(camDir.X, 0, camDir.Z)
                if flatCamDir.Magnitude > 0.01 then flatCamDir = flatCamDir.Unit else flatCamDir = Vector3.new(0,0,-1) end
                local flatRightVec = Vector3.new(rightVec.X, 0, rightVec.Z)
                if flatRightVec.Magnitude > 0.01 then flatRightVec = flatRightVec.Unit else flatRightVec = Vector3.new(1,0,0) end

                local xzMove = Vector3.new(0, 0, 0)
                if UserInputService:IsKeyDown(Enum.KeyCode.W) then xzMove = xzMove + flatCamDir end
                if UserInputService:IsKeyDown(Enum.KeyCode.S) then xzMove = xzMove - flatCamDir end
                if UserInputService:IsKeyDown(Enum.KeyCode.D) then xzMove = xzMove + flatRightVec end
                if UserInputService:IsKeyDown(Enum.KeyCode.A) then xzMove = xzMove - flatRightVec end
                
                if xzMove.Magnitude > 0 then xzMove = xzMove.Unit end

                local yMove = 0
                if UserInputService:IsKeyDown(Enum.KeyCode.Q) then yMove = yMove + 1 end
                if UserInputService:IsKeyDown(Enum.KeyCode.E) then yMove = yMove - 1 end

                hrp.Velocity = Vector3.zero
                hrp.CFrame = hrp.CFrame + (xzMove * xSpeed * dt) + (Vector3.new(0, yMove, 0) * ySpeed * dt)
            end
        end

        if flyEnabled and not superMovementEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            local hrp = LocalPlayer.Character.HumanoidRootPart
            local currentFlySpeed = tonumber(UtilFlySpeedBox.Text) or 50
            local camDir = Camera.CFrame.LookVector
            local rightVec = Camera.CFrame.RightVector
            local moveDir = Vector3.new(0, 0, 0)

            if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveDir = moveDir + camDir end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveDir = moveDir - camDir end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveDir = moveDir + rightVec end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveDir = moveDir - rightVec end
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then moveDir = moveDir + Vector3.new(0, 1, 0) end
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then moveDir = moveDir - Vector3.new(0, 1, 0) end

            if moveDir.Magnitude > 0 then
                moveDir = moveDir.Unit
            end

            hrp.Velocity = Vector3.zero
            hrp.CFrame = hrp.CFrame + (moveDir * currentFlySpeed * dt)
        end
    end))

    table.insert(connections, RunService.Heartbeat:Connect(function()
        local char = LocalPlayer.Character
        if char and char:FindFirstChild("Humanoid") then
            local hum = char.Humanoid
            if jumpEnabled then
                local jVal = tonumber(UtilJumpBox.Text) or 100
                hum.UseJumpPower = true
                hum.JumpPower = jVal
            end
        end

        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character then
                local hrp = player.Character:FindFirstChild("HumanoidRootPart")
                local head = player.Character:FindFirstChild("Head")

                if espNameEnabled then
                    if head then
                        local nameEsp = head:FindFirstChild("treeHubNameEsp")
                        if not nameEsp then
                            nameEsp = Instance.new("BillboardGui")
                            nameEsp.Name = "treeHubNameEsp"
                            nameEsp.Size = UDim2.new(0, 100, 0, 40)
                            nameEsp.StudsOffset = Vector3.new(0, 2, 0)
                            nameEsp.AlwaysOnTop = true
                            nameEsp.Parent = head

                            local text = Instance.new("TextLabel")
                            text.Size = UDim2.new(1, 0, 1, 0)
                            text.BackgroundTransparency = 1
                            text.Text = player.Name
                            text.TextColor3 = Color3.fromRGB(255, 255, 255)
                            text.TextStrokeTransparency = 0
                            text.Font = Enum.Font.GothamBold
                            text.TextSize = 12
                            text.Parent = nameEsp
                        end
                    end
                else
                    if head and head:FindFirstChild("treeHubNameEsp") then
                        head.treeHubNameEsp:Destroy()
                    end
                end

                if espBodyEnabled then
                    local highlight = player.Character:FindFirstChild("treeHubBodyEsp")
                    if not highlight then
                        highlight = Instance.new("Highlight")
                        highlight.Name = "treeHubBodyEsp"
                        highlight.FillColor = Theme.Danger
                        highlight.OutlineColor = Theme.Accent
                        highlight.FillTransparency = 0.5
                        highlight.OutlineTransparency = 0
                        highlight.Parent = player.Character
                    end
                else
                    local highlight = player.Character:FindFirstChild("treeHubBodyEsp")
                    if highlight then highlight:Destroy() end
                end

                if hrp then
                    local shouldModifyHitbox = false
                    if hitboxEnabled then
                        if hitboxMode == "All Players" then
                            shouldModifyHitbox = true
                        elseif hitboxMode == "Selected Players" and hitboxSelectedPlayers[player.Name] then
                            shouldModifyHitbox = true
                        end
                    end

                    if shouldModifyHitbox then
                        local targetSizeVal = tonumber(HitboxSizeBox.Text) or 10
                        hrp.Size = Vector3.new(targetSizeVal, targetSizeVal, targetSizeVal)
                        hrp.Transparency = 0.7
                        hrp.Color = Color3.fromRGB(255, 0, 0)
                        hrp.CanCollide = false
                    else
                        hrp.Size = Vector3.new(2, 2, 1)
                        hrp.Transparency = 1
                        hrp.CanCollide = true
                    end
                end
            end
        end
    end))

    applyTheme(false)

    -- INTRO SCREEN (BÜYÜTÜLMÜŞ LOGO VE YAZI)
    local function PlayIntroAndShowUI()
        if currentSettings.UIAnimations then
            local introFrame = Instance.new("Frame")
            introFrame.Size = UDim2.new(1, 0, 1, 0)
            introFrame.BackgroundColor3 = Color3.new(0, 0, 0)
            introFrame.BackgroundTransparency = 0
            introFrame.ZIndex = 1
            introFrame.Parent = ScreenGui
            
            local introContent = Instance.new("Frame")
            introContent.Size = UDim2.new(0, 360, 0, 200)
            introContent.Position = UDim2.new(0.5, -180, -0.4, 0)
            introContent.BackgroundTransparency = 1
            introContent.ZIndex = 2
            introContent.Parent = introFrame
            
            local introLogo = Instance.new("ImageLabel")
            introLogo.Size = UDim2.new(0, 120, 0, 120)
            introLogo.Position = UDim2.new(0.5, -60, 0, 0)
            introLogo.BackgroundTransparency = 1
            introLogo.ImageTransparency = 0
            introLogo.Image = "rbxassetid://108429972282329"
            introLogo.ZIndex = 2
            introLogo.Parent = introContent

            local introText = Instance.new("TextLabel")
            introText.Size = UDim2.new(1, 0, 0, 60)
            introText.Position = UDim2.new(0, 0, 0, 125)
            introText.BackgroundTransparency = 1
            introText.TextTransparency = 0
            introText.RichText = true
            introText.Text = "treeHub"
            introText.Font = Enum.Font.GothamBlack
            introText.TextSize = 50
            introText.TextColor3 = Color3.fromRGB(40, 150, 75)
            introText.ZIndex = 2
            introText.Parent = introContent

            local t2 = TweenService:Create(introContent, TweenInfo.new(1.2, Enum.EasingStyle.Bounce, Enum.EasingDirection.Out), {Position = UDim2.new(0.5, -180, 0.3, 0)})
            t2:Play()
            t2.Completed:Wait()
            
            task.wait(0.5)

            local t3 = TweenService:Create(introFrame, TweenInfo.new(0.5), {BackgroundTransparency = 1})
            local t4 = TweenService:Create(introText, TweenInfo.new(0.5), {TextTransparency = 1})
            local t5 = TweenService:Create(introLogo, TweenInfo.new(0.5), {ImageTransparency = 1})
            t3:Play()
            t4:Play()
            t5:Play()
            t3.Completed:Wait()
            
            introFrame:Destroy()

            uiVisible = true
            MainFrame.Visible = true
            mainScale.Scale = 0
            TweenService:Create(mainScale, TweenInfo.new(0.6, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Scale = 1}):Play()
        else
            uiVisible = true
            MainFrame.Visible = true
            mainScale.Scale = 1
        end
    end

    PlayIntroAndShowUI()
end

StartTreeHub()
