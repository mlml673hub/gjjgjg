-- ╔════════════════════════════════════════════╗
-- ║     MLML673 HUB - COMBINED SCRIPT         ║
-- ║  Speed Booster + FPS Devour + AP Spammer  ║
-- ╚════════════════════════════════════════════╝

-- ========== SERVICES ==========
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TextChatService = game:GetService("TextChatService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local Backpack = LocalPlayer:WaitForChild("Backpack")
local UIS = UserInputService

-- ========== CLEANUP EXISTING UI ==========
local existingUI = PlayerGui:FindFirstChild("CombinedUI")
if existingUI then existingUI:Destroy() end

task.wait(1)

-- ========== GRAPHICS OPTIMIZATION (FPS DEVOUR) ==========
Lighting.GlobalShadows = false
Lighting.EnvironmentDiffuseScale = 0
Lighting.EnvironmentSpecularScale = 0

for _, postEffect in ipairs(Lighting:GetChildren()) do
    if postEffect:IsA("PostEffect") then
        postEffect.Enabled = false
    end
end

for _, particle in ipairs(workspace:GetDescendants()) do
    if particle:IsA("ParticleEmitter") then
        particle.Enabled = false
    end
end

-- ========== ACCESSORY REMOVAL ==========
local function RemoveAccessories(character)
    if not character then return end
    
    for _, accessory in ipairs(character:GetDescendants()) do
        if accessory:IsA("Accessory") then
            accessory:Destroy()
        end
    end
    
    local descendantConnection
    descendantConnection = character.DescendantAdded:Connect(function(child)
        if child:IsA("Accessory") then
            child:Destroy()
        end
    end)
    
    local heartbeatConnection
    heartbeatConnection = RunService.Heartbeat:Connect(function()
        if not character.Parent then
            heartbeatConnection:Disconnect()
            return
        end
        for _, item in ipairs(character:GetChildren()) do
            if item:IsA("Accessory") then
                item:Destroy()
            end
        end
    end)
end

-- Handle existing character and future spawns
if LocalPlayer.Character then
    RemoveAccessories(LocalPlayer.Character)
end
LocalPlayer.CharacterAdded:Connect(RemoveAccessories)

-- Remove accessories from all existing humanoids in workspace
for _, humanoid in ipairs(workspace:GetDescendants()) do
    if humanoid:IsA("Humanoid") then
        local parent = humanoid.Parent
        if parent then
            for _, accessory in ipairs(parent:GetChildren()) do
                if accessory:IsA("Accessory") then
                    accessory:Destroy()
                end
            end
            
            parent.ChildAdded:Connect(function(child)
                if child:IsA("Accessory") then
                    child:Destroy()
                end
            end)
        end
    end
end

-- Monitor for new humanoids
workspace.DescendantAdded:Connect(function(descendant)
    if descendant:IsA("Humanoid") then
        local parent = descendant.Parent
        if parent then
            for _, accessory in ipairs(parent:GetChildren()) do
                if accessory:IsA("Accessory") then
                    accessory:Destroy()
                end
            end
            
            parent.ChildAdded:Connect(function(child)
                if child:IsA("Accessory") then
                    child:Destroy()
                end
            end)
        end
    end
end)

-- ========== MAIN GUI ==========
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "CombinedUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = PlayerGui

-- ========== FPS DEVOUR FRAME ==========
local FPSFrame = Instance.new("Frame")
FPSFrame.Name = "FPSDevourFrame"
FPSFrame.Size = UDim2.new(0, 340, 0, 160)
FPSFrame.Position = UDim2.new(0.5, -170, 0.5, -80)
FPSFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
FPSFrame.BorderSizePixel = 0
FPSFrame.Active = true
FPSFrame.Draggable = true
FPSFrame.Parent = ScreenGui

local FPSCorner = Instance.new("UICorner", FPSFrame)
FPSCorner.CornerRadius = UDim.new(0, 18)

local FPSTitle = Instance.new("TextLabel")
FPSTitle.Parent = FPSFrame
FPSTitle.Size = UDim2.new(1, -20, 0, 40)
FPSTitle.Position = UDim2.new(0, 10, 0, 10)
FPSTitle.BackgroundTransparency = 1
FPSTitle.Text = "Tigy's FPS Devour"
FPSTitle.Font = Enum.Font.GothamBlack
FPSTitle.TextSize = 20
FPSTitle.TextXAlignment = Enum.TextXAlignment.Left
FPSTitle.TextColor3 = Color3.new(1, 1, 1)

local FPSButton = Instance.new("TextButton")
FPSButton.Parent = FPSFrame
FPSButton.Size = UDim2.new(1, -40, 0, 54)
FPSButton.Position = UDim2.new(0, 20, 0, 80)
FPSButton.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
FPSButton.Text = "FPS Devour (need auras)"
FPSButton.Font = Enum.Font.GothamBold
FPSButton.TextSize = 15
FPSButton.TextColor3 = Color3.new(1, 1, 1)
FPSButton.BorderSizePixel = 0
FPSButton.AutoButtonColor = true

local FPSButtonCorner = Instance.new("UICorner", FPSButton)
FPSButtonCorner.CornerRadius = UDim.new(0, 14)

FPSButton.MouseButton1Click:Connect(function()
    FPSButton.Text = "WORKING..."
    FPSButton.AutoButtonColor = false

    local Character = LocalPlayer.Character
    if not Character then return end
    
    local Humanoid = Character:FindFirstChildOfClass("Humanoid")
    if not Humanoid then return end
    
    local QuantumCloner = Backpack:FindFirstChild("Quantum Cloner")

    if QuantumCloner then
        Humanoid:EquipTool(QuantumCloner)
        task.wait()

        for _, Tool in ipairs(Backpack:GetChildren()) do
            if Tool:IsA("Tool") then
                Tool.Parent = Character
            end
        end

        task.wait()
        QuantumCloner:Activate()
        task.delay(0.5, function()
            FPSButton.Text = "FPS Devour (need auras)"
            FPSButton.AutoButtonColor = true
        end)
    end
end)

-- ========== SPEED BOOSTER FRAME ==========
local SpeedFrame = Instance.new("Frame", ScreenGui)
SpeedFrame.Name = "SpeedFrame"
SpeedFrame.Size = UDim2.fromOffset(80, 80)
SpeedFrame.Position = UDim2.fromScale(0.92, 0.45)
SpeedFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
SpeedFrame.BorderSizePixel = 0
Instance.new("UICorner", SpeedFrame).CornerRadius = UDim.new(0, 12)

local SpeedButton = Instance.new("TextButton", SpeedFrame)
SpeedButton.Name = "SpeedButton"
SpeedButton.Size = UDim2.fromOffset(70, 70)
SpeedButton.Position = UDim2.fromOffset(5, 5)
SpeedButton.Text = "SPD\n28.8"
SpeedButton.Font = Enum.Font.GothamBold
SpeedButton.TextSize = 14
SpeedButton.TextColor3 = Color3.new(1, 1, 1)
SpeedButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
SpeedButton.AutoButtonColor = false
SpeedButton.BorderSizePixel = 0
Instance.new("UICorner", SpeedButton).CornerRadius = UDim.new(0, 10)

-- Speed Booster Variables
getgenv().EDITFLEXX_SPEED = getgenv().EDITFLEXX_SPEED or 28.8
local SPEED = getgenv().EDITFLEXX_SPEED
local speedEnabled = false
local speedConn

local function getChar()
    local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    return char, char:WaitForChild("HumanoidRootPart"), char:WaitForChild("Humanoid")
end

local function startSpeed()
    if speedConn then return end
    speedConn = RunService.Heartbeat:Connect(function()
        local _, hrp, hum = getChar()
        local dir = hum.MoveDirection
        if dir.Magnitude > 0 then
            hrp.AssemblyLinearVelocity = Vector3.new(dir.X * SPEED, hrp.AssemblyLinearVelocity.Y, dir.Z * SPEED)
        end
    end)
end

local function stopSpeed()
    if speedConn then speedConn:Disconnect() speedConn = nil end
end

-- Speed Booster Dragging
local sdragging, sdragStart, sstartPos
SpeedFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        sdragging = true
        sdragStart = input.Position
        sstartPos = SpeedFrame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then sdragging = false end
        end)
    end
end)

UIS.InputChanged:Connect(function(input)
    if sdragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - sdragStart
        SpeedFrame.Position = UDim2.new(sstartPos.X.Scale, sstartPos.X.Offset + delta.X, sstartPos.Y.Scale, sstartPos.Y.Offset + delta.Y)
    end
end)

SpeedButton.Activated:Connect(function()
    speedEnabled = not speedEnabled
    if speedEnabled then
        startSpeed()
        SpeedButton.BackgroundColor3 = Color3.fromRGB(80, 160, 255)
    else
        stopSpeed()
        SpeedButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    end
end)

-- ========== AP SPAMMER FRAME ==========
local SpammerFrame = Instance.new("Frame")
SpammerFrame.Name = "APSpammerFrame"
SpammerFrame.Size = UDim2.fromOffset(180, 200)
SpammerFrame.Position = UDim2.fromScale(0.5, 0.25)
SpammerFrame.AnchorPoint = Vector2.new(0.5, 0.5)
SpammerFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
SpammerFrame.BorderSizePixel = 0
SpammerFrame.Parent = ScreenGui

local SpammerCorner = Instance.new("UICorner")
SpammerCorner.CornerRadius = UDim.new(0, 12)
SpammerCorner.Parent = SpammerFrame

-- Title Bar for Spammer
local TitleBar = Instance.new("Frame")
TitleBar.Size = UDim2.new(1, 0, 0, 28)
TitleBar.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
TitleBar.BorderSizePixel = 0
TitleBar.Parent = SpammerFrame

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 12)
TitleCorner.Parent = TitleBar

local TitleLabel = Instance.new("TextLabel")
TitleLabel.Size = UDim2.new(1, -28, 1, 0)
TitleLabel.Position = UDim2.new(0, 6, 0, 0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "MLML673 HUB ap spammer"
TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleLabel.TextScaled = true
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.Parent = TitleBar

-- Minimize Button
local MinimizeButton = Instance.new("TextButton")
MinimizeButton.Size = UDim2.new(0, 22, 0, 22)
MinimizeButton.Position = UDim2.new(1, -24, 0, 3)
MinimizeButton.Text = "-"
MinimizeButton.TextScaled = true
MinimizeButton.Font = Enum.Font.GothamBold
MinimizeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
MinimizeButton.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
MinimizeButton.Parent = TitleBar

local MinCorner = Instance.new("UICorner")
MinCorner.CornerRadius = UDim.new(0, 6)
MinCorner.Parent = MinimizeButton

-- Player List
local Scroll = Instance.new("ScrollingFrame")
Scroll.Position = UDim2.new(0, 0, 0, 32)
Scroll.Size = UDim2.new(1, 0, 1, -34)
Scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
Scroll.ScrollBarImageColor3 = Color3.fromRGB(40, 40, 40)
Scroll.BackgroundTransparency = 1
Scroll.Parent = SpammerFrame

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Padding = UDim.new(0, 4)
UIListLayout.Parent = Scroll

-- ========== ESP FRAME ==========
local ESPFrame = Instance.new("Frame")
ESPFrame.Name = "ESPFrame"
ESPFrame.Size = UDim2.new(0, 180, 0, 70)
ESPFrame.Position = UDim2.new(0, 20, 0, 140)
ESPFrame.BackgroundColor3 = Color3.new(0, 0, 0)
ESPFrame.BackgroundTransparency = 0.2
ESPFrame.BorderSizePixel = 0
ESPFrame.Parent = ScreenGui

local ESPCorner = Instance.new("UICorner", ESPFrame)
ESPCorner.CornerRadius = UDim.new(0, 8)

local ESPStroke = Instance.new("UIStroke", ESPFrame)
ESPStroke.Color = Color3.new(0, 1, 1)
ESPStroke.Thickness = 2
ESPStroke.Transparency = 0.3

-- ESP Title
local ESPTitle = Instance.new("TextLabel")
ESPTitle.Size = UDim2.new(1, -20, 0, 20)
ESPTitle.Position = UDim2.new(0, 10, 0, 5)
ESPTitle.BackgroundTransparency = 1
ESPTitle.Text = "ESP MLML673"
ESPTitle.TextColor3 = Color3.new(0, 1, 1)
ESPTitle.Font = Enum.Font.GothamBold
ESPTitle.TextSize = 14
ESPTitle.TextXAlignment = Enum.TextXAlignment.Left
ESPTitle.Parent = ESPFrame

-- ESP Toggle Button
local ESPToggleButton = Instance.new("TextButton")
ESPToggleButton.Name = "ESPToggle"
ESPToggleButton.Size = UDim2.new(0, 40, 0, 16)
ESPToggleButton.Position = UDim2.new(1, -50, 0, 8)
ESPToggleButton.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
ESPToggleButton.Text = ""
ESPToggleButton.AutoButtonColor = false
ESPToggleButton.Parent = ESPFrame

local ESPToggleCorner = Instance.new("UICorner", ESPToggleButton)
ESPToggleCorner.CornerRadius = UDim.new(0, 8)

-- ESP Toggle Background
local ESPToggleBackground = Instance.new("Frame", ESPToggleButton)
ESPToggleBackground.Size = UDim2.new(1, 0, 1, 0)
ESPToggleBackground.BackgroundColor3 = Color3.new(0.8, 0, 0)
ESPToggleBackground.BackgroundTransparency = 0.3
ESPToggleBackground.ZIndex = 0
Instance.new("UICorner", ESPToggleBackground).CornerRadius = UDim.new(0, 8)

-- ESP Toggle Knob
local ESPKnob = Instance.new("Frame", ESPToggleButton)
ESPKnob.Name = "ESPToggleKnob"
ESPKnob.Size = UDim2.new(0, 12, 0, 12)
ESPKnob.Position = UDim2.new(0, 2, 0.5, 0)
ESPKnob.AnchorPoint = Vector2.new(0, 0.5)
ESPKnob.BackgroundColor3 = Color3.new(1, 1, 1)
ESPKnob.ZIndex = 2
ESPKnob.Parent = ESPToggleButton

local ESPKnobCorner = Instance.new("UICorner", ESPKnob)
ESPKnobCorner.CornerRadius = UDim.new(0, 6)

-- ESP Status Label
local ESPStatusLabel = Instance.new("TextLabel")
ESPStatusLabel.Size = UDim2.new(0, 40, 0, 12)
ESPStatusLabel.Position = UDim2.new(1, -50, 0, 26)
ESPStatusLabel.BackgroundTransparency = 1
ESPStatusLabel.Text = "OFF"
ESPStatusLabel.TextColor3 = Color3.new(1, 0, 0)
ESPStatusLabel.Font = Enum.Font.GothamBold
ESPStatusLabel.TextSize = 10
ESPStatusLabel.TextXAlignment = Enum.TextXAlignment.Center
ESPStatusLabel.Parent = ESPFrame


-- ========== DRAGGING FUNCTIONALITY ==========
local draggingSpammer = false
local draggingBooster = false
local draggingESP = false
local draggingFPS = false
local dragStart, startPos

-- FPS dragging
FPSFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        draggingFPS = true
        dragStart = input.Position
        startPos = FPSFrame.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                draggingFPS = false
            end
        end)
    end
end)

-- Spammer dragging
TitleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        draggingSpammer = true
        dragStart = input.Position
        startPos = SpammerFrame.Position
    end
end)

-- Booster dragging
BoosterFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        draggingBooster = true
        dragStart = input.Position
        startPos = BoosterFrame.Position
        TweenService:Create(BoosterFrame, TweenInfo.new(0.1), { BackgroundTransparency = 0.3 }):Play()
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                draggingBooster = false
                TweenService:Create(BoosterFrame, TweenInfo.new(0.1), { BackgroundTransparency = 0.2 }):Play()
            end
        end)
    end
end)

-- ESP dragging
ESPFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        draggingESP = true
        dragStart = input.Position
        startPos = ESPFrame.Position
        TweenService:Create(ESPFrame, TweenInfo.new(0.1), { BackgroundTransparency = 0.3 }):Play()
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                draggingESP = false
                TweenService:Create(ESPFrame, TweenInfo.new(0.1), { BackgroundTransparency = 0.2 }):Play()
            end
        end)
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if draggingFPS and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStart
        FPSFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
    
    if draggingSpammer and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        SpammerFrame.Position = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
    end
    
    if draggingBooster and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStart
        BoosterFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
    
    if draggingESP and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStart
        ESPFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        draggingSpammer = false
        draggingBooster = false
        draggingESP = false
        draggingFPS = false
    end
end)

-- ========== MINIMIZE FUNCTIONALITY ==========
local minimized = false
local normalSize = SpammerFrame.Size

MinimizeButton.MouseButton1Click:Connect(function()
    minimized = not minimized
    
    if minimized then
        Scroll.Visible = false
        SpammerFrame.Size = UDim2.fromOffset(180, 28)
        MinimizeButton.Text = "+"
    else
        Scroll.Visible = true
        SpammerFrame.Size = normalSize
        MinimizeButton.Text = "-"
    end
end)

-- ========== SEND COMMANDS (AP SPAMMER) ==========
local function sendCommands(targetName)
    local channel = TextChatService.TextChannels:FindFirstChild("RBXGeneral")
    if not channel then return end
    
    local commands = {
        ";balloon " .. targetName,
        ";rocket " .. targetName,
        ";morph " .. targetName,
        ";jumpscare " .. targetName,
        ";jail " .. targetName
    }

    for _, cmd in ipairs(commands) do
        channel:SendAsync(cmd)
        task.wait(0.12)
    end
end

-- ========== PLAYER BUTTONS ==========
local function createPlayerButton(player)
    if player == LocalPlayer then return end
    
    local Button = Instance.new("TextButton")
    Button.Size = UDim2.new(1, -6, 0, 24)
    Button.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    Button.TextColor3 = Color3.fromRGB(255, 255, 255)
    Button.TextScaled = true
    Button.Font = Enum.Font.Gotham
    Button.Text = player.Name
    Button.Parent = Scroll
    
    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 6)
    Corner.Parent = Button
    
    Button.MouseButton1Click:Connect(function()
        sendCommands(player.Name)
    end)
end

-- ========== REFRESH PLAYER LIST ==========
local function refreshList()
    for _, child in pairs(Scroll:GetChildren()) do
        if child:IsA("TextButton") then
            child:Destroy()
        end
    end
    
    for _, player in pairs(Players:GetPlayers()) do
        createPlayerButton(player)
    end
    
    task.wait()
    Scroll.CanvasSize = UDim2.new(0, 0, 0, UIListLayout.AbsoluteContentSize.Y + 4)
end

Players.PlayerAdded:Connect(refreshList)
Players.PlayerRemoving:Connect(refreshList)

refreshList()

-- ========== BOOSTER STATE ==========
local BoosterEnabled = false
local SpeedValue = 22.5
local JumpValue = 35

local TweenInfoSmooth = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local TweenInfoBounce = TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out)

-- Toggle Logic
ToggleButton.MouseButton1Click:Connect(function()
    BoosterEnabled = not BoosterEnabled
    
    local targetColor = BoosterEnabled and Color3.new(0, 0.8, 0) or Color3.new(0.8, 0, 0)
    local targetPos = BoosterEnabled and UDim2.new(1, -14, 0.5, 0) or UDim2.new(0, 2, 0.5, 0)
    local statusText = BoosterEnabled and "ON" or "OFF"
    local statusColor = BoosterEnabled and Color3.new(0, 1, 0) or Color3.new(1, 0, 0)
    
    TweenService:Create(ToggleBackground, TweenInfoSmooth, { BackgroundColor3 = targetColor }):Play()
    TweenService:Create(Knob, TweenInfoBounce, { Position = targetPos }):Play()
    TweenService:Create(StatusLabel, TweenInfoSmooth, { TextColor3 = statusColor }):Play()
    
    TweenService:Create(Knob, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { Size = UDim2.new(0, 16, 0, 16) }):Play()
    task.wait(0.1)
    TweenService:Create(Knob, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { Size = UDim2.new(0, 12, 0, 12) }):Play()
    
    StatusLabel.Text = statusText
    
    if BoosterEnabled then
        TweenService:Create(Stroke, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { Thickness = 3 }):Play()
        task.wait(0.3)
        TweenService:Create(Stroke, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { Thickness = 2 }):Play()
    end
end)

-- Update values when typing
SpeedBox.FocusLost:Connect(function(enterPressed)
    if enterPressed then
        local num = tonumber(SpeedBox.Text)
        if num and num > 0 then
            SpeedValue = num
            TweenService:Create(SpeedBoxStroke, TweenInfo.new(0.2), { Color = Color3.new(0, 1, 0) }):Play()
            task.wait(0.2)
            TweenService:Create(SpeedBoxStroke, TweenInfo.new(0.2), { Color = Color3.new(1, 0, 0) }):Play()
        else
            SpeedBox.Text = tostring(SpeedValue)
        end
    end
end)

JumpBox.FocusLost:Connect(function(enterPressed)
    if enterPressed then
        local num = tonumber(JumpBox.Text)
        if num and num > 0 then
            JumpValue = num
            TweenService:Create(JumpBoxStroke, TweenInfo.new(0.2), { Color = Color3.new(0, 1, 0) }):Play()
            task.wait(0.2)
            TweenService:Create(JumpBoxStroke, TweenInfo.new(0.2), { Color = Color3.new(1, 0, 0) }):Play()
        else
            JumpBox.Text = tostring(JumpValue)
        end
    end
end)

-- ========== BOOSTER HEARTBEAT ==========
RunService.Heartbeat:Connect(function()
    if not BoosterEnabled then return end
    local character = LocalPlayer.Character
    if not character then return end
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    local rootPart = character:FindFirstChild("HumanoidRootPart")
    if not humanoid or not rootPart then return end
    
    if humanoid.MoveDirection.Magnitude > 0 then
        rootPart.Velocity = Vector3.new(
            humanoid.MoveDirection.X * SpeedValue,
            rootPart.Velocity.Y,
            humanoid.MoveDirection.Z * SpeedValue
        )
    end
    
    humanoid.UseJumpPower = true
    humanoid.JumpPower = JumpValue
end)

-- ========== BOOSTER FRAME EFFECTS ==========
BoosterFrame.MouseEnter:Connect(function()
    TweenService:Create(Stroke, TweenInfo.new(0.2), { Transparency = 0.1 }):Play()
end)

BoosterFrame.MouseLeave:Connect(function()
    TweenService:Create(Stroke, TweenInfo.new(0.2), { Transparency = 0.3 }):Play()
end)

-- ========== ESP SYSTEM ==========
local ESPEnabled = false
local ESPBoxes = {}

local function createESPBox(player)
    if player == LocalPlayer then return end
    if ESPBoxes[player] then return end
    
    local character = player.Character
    if not character then return end
    
    local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
    if not humanoidRootPart then return end
    
    -- Create highlight effect
    local highlight = Instance.new("Highlight")
    highlight.Parent = character
    highlight.FillColor = Color3.fromRGB(0, 255, 255)
    highlight.OutlineColor = Color3.fromRGB(0, 255, 255)
    highlight.FillTransparency = 0.3
    highlight.OutlineTransparency = 0
    
    -- Create name label
    local surfaceGui = Instance.new("SurfaceGui")
    surfaceGui.Parent = humanoidRootPart
    surfaceGui.Face = Enum.NormalId.Top
    surfaceGui.CanvasSize = Vector2.new(200, 50)
    
    local nameLabel = Instance.new("TextLabel")
    nameLabel.Size = UDim2.new(1, 0, 1, 0)
    nameLabel.BackgroundColor3 = Color3.new(0, 0, 0)
    nameLabel.BackgroundTransparency = 0.5
    nameLabel.Text = player.Name
    nameLabel.TextColor3 = Color3.fromRGB(0, 255, 255)
    nameLabel.TextScaled = true
    nameLabel.Font = Enum.Font.GothamBold
    nameLabel.Parent = surfaceGui
    
    ESPBoxes[player] = {
        highlight = highlight,
        surfaceGui = surfaceGui,
        nameLabel = nameLabel
    }
end

local function removeESPBox(player)
    if ESPBoxes[player] then
        if ESPBoxes[player].highlight then
            ESPBoxes[player].highlight:Destroy()
        end
        if ESPBoxes[player].surfaceGui then
            ESPBoxes[player].surfaceGui:Destroy()
        end
        ESPBoxes[player] = nil
    end
end

-- ESP Toggle
ESPToggleButton.MouseButton1Click:Connect(function()
    ESPEnabled = not ESPEnabled
    
    local targetColor = ESPEnabled and Color3.new(0, 0.8, 0) or Color3.new(0.8, 0, 0)
    local targetPos = ESPEnabled and UDim2.new(1, -14, 0.5, 0) or UDim2.new(0, 2, 0.5, 0)
    local statusText = ESPEnabled and "ON" or "OFF"
    local statusColor = ESPEnabled and Color3.new(0, 1, 0) or Color3.new(1, 0, 0)
    
    TweenService:Create(ESPToggleBackground, TweenInfoSmooth, { BackgroundColor3 = targetColor }):Play()
    TweenService:Create(ESPKnob, TweenInfoBounce, { Position = targetPos }):Play()
    TweenService:Create(ESPStatusLabel, TweenInfoSmooth, { TextColor3 = statusColor }):Play()
    
    TweenService:Create(ESPKnob, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { Size = UDim2.new(0, 16, 0, 16) }):Play()
    task.wait(0.1)
    TweenService:Create(ESPKnob, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { Size = UDim2.new(0, 12, 0, 12) }):Play()
    
    ESPStatusLabel.Text = statusText
    
    if ESPEnabled then
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer then
                createESPBox(player)
            end
        end
    else
        for player, _ in pairs(ESPBoxes) do
            removeESPBox(player)
        end
    end
end)

-- Add ESP to new players
Players.PlayerAdded:Connect(function(player)
    task.wait(0.5)
    if ESPEnabled then
        player.CharacterAdded:Connect(function()
            task.wait(0.1)
            createESPBox(player)
        end)
        createESPBox(player)
    end
end)

-- Remove ESP when player leaves
Players.PlayerRemoving:Connect(function(player)
    removeESPBox(player)
end)

-- ESP Frame effects
ESPFrame.MouseEnter:Connect(function()
    TweenService:Create(ESPStroke, TweenInfo.new(0.2), { Transparency = 0.1 }):Play()
end)

ESPFrame.MouseLeave:Connect(function()
    TweenService:Create(ESPStroke, TweenInfo.new(0.2), { Transparency = 0.3 }):Play()
end)

-- ========== PLOT TIMER ESP ==========
local BaseESPs = {}
local Plots = workspace:FindFirstChild("Plots")

if Plots then
    RunService.RenderStepped:Connect(function()
        for _, plot in ipairs(Plots:GetChildren()) do
            local purchases = plot:FindFirstChild("Purchases")
            local plotBlock = purchases and purchases:FindFirstChild("PlotBlock")
            local main = plotBlock and plotBlock:FindFirstChild("Main")

            local timerGui = main and main:FindFirstChild("BillboardGui")
            local timerText = timerGui and timerGui:FindFirstChild("RemainingTime")

            if main and timerText and timerText.Text ~= "" then
                if not BaseESPs[plot] then
                    local gui = Instance.new("BillboardGui")
                    gui.Size = UDim2.new(0, 140, 0, 35)
                    gui.StudsOffset = Vector3.new(0, 5, 0)
                    gui.AlwaysOnTop = true
                    gui.Adornee = main
                    gui.Parent = main

                    local text = Instance.new("TextLabel", gui)
                    text.Size = UDim2.fromScale(1, 1)
                    text.BackgroundTransparency = 1
                    text.TextScaled = true
                    text.Font = Enum.Font.GothamBlack
                    text.TextColor3 = Color3.new(1, 1, 1)
                    text.TextStrokeTransparency = 0
                    text.TextStrokeColor3 = Color3.new(0, 0, 0)

                    BaseESPs[plot] = gui
                end
                BaseESPs[plot].TextLabel.Text = timerText.Text
            elseif BaseESPs[plot] then
                BaseESPs[plot]:Destroy()
                BaseESPs[plot] = nil
            end
        end
    end)
end

print("✅ MLML673 HUB - Combined script loaded successfully!")
print("📦 Features: Speed Booster + FPS Devour + AP Spammer + ESP System")
