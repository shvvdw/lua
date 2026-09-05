-- ==================================================================== --
-- 👑 im1dn HUB v5.5.5 - BETTER UI EDITION (ⵣ)                        --
-- ==================================================================== --
local Players = game:GetService("Players")
if not Players.LocalPlayer then
    Players:GetPropertyChangedSignal("LocalPlayer"):Wait()
end
local localPlayer = Players.LocalPlayer

local camera = workspace.CurrentCamera or workspace:WaitForChild("Camera")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

-- Configuration variables
_G.HardLockActive = false
_G.ESPActive = false
_G.VelocityJumpActive = false
_G.SpeedBoostActive = false 

local MaxLockDistance = 200 
local TargetPart = "Head"
local PredictFactor = 0.035
local UpwardForce = 80
local LockFOV = 150 

local RivalsDashPower = 140 
local RivalsDashDuration = 0.2 

local LockedTarget = nil

-- Colors
local Theme = {
    Background = Color3.fromRGB(18, 18, 22),
    Header = Color3.fromRGB(25, 25, 30),
    Accent = Color3.fromRGB(115, 63, 230),
    Button_Off = Color3.fromRGB(30, 30, 35),
    Button_On = Color3.fromRGB(115, 63, 230),
    Text_Light = Color3.fromRGB(240, 240, 245),
    Text_Dark = Color3.fromRGB(160, 160, 175)
}

-- ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "im1dnHubUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = (gethui and gethui()) or game:GetService("CoreGui") or localPlayer:WaitForChild("PlayerGui")

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 260, 0, 380)
MainFrame.Position = UDim2.new(0.05, 0, 0.2, 0)
MainFrame.BackgroundColor3 = Theme.Background
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 12)
UICorner.Parent = MainFrame

-- Header
local Header = Instance.new("Frame")
Header.Size = UDim2.new(1, 0, 0, 50)
Header.BackgroundColor3 = Theme.Header
Header.BorderSizePixel = 0
Header.Parent = MainFrame

local HeaderCorner = Instance.new("UICorner")
HeaderCorner.CornerRadius = UDim.new(0, 12)
HeaderCorner.Parent = Header

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -100, 1, 0)
Title.BackgroundTransparency = 1
Title.Text = "👑 im1dn HUB"
Title.TextColor3 = Theme.Text_Light
Title.TextSize = 16
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Position = UDim2.new(0, 20, 0, 0)
Title.Parent = Header

local Version = Instance.new("TextLabel")
Version.Size = UDim2.new(0, 60, 1, 0)
Version.Position = UDim2.new(1, -80, 0, 0)
Version.BackgroundTransparency = 1
Version.Text = "v5.5.5"
Version.TextColor3 = Theme.Text_Dark
Version.TextSize = 12
Version.Font = Enum.Font.Gotham
Version.Parent = Header

-- Minimize Button
local MinimizeBtn = Instance.new("TextButton")
MinimizeBtn.Size = UDim2.new(0, 30, 0, 30)
MinimizeBtn.Position = UDim2.new(1, -40, 0, 10)
MinimizeBtn.BackgroundTransparency = 1
MinimizeBtn.Text = "−"
MinimizeBtn.TextColor3 = Theme.Text_Light
MinimizeBtn.TextSize = 20
MinimizeBtn.Font = Enum.Font.GothamBold
MinimizeBtn.Parent = Header

-- Content Frame
local Content = Instance.new("Frame")
Content.Size = UDim2.new(1, 0, 1, -50)
Content.Position = UDim2.new(0, 0, 0, 50)
Content.BackgroundTransparency = 1
Content.Parent = MainFrame

local minimized = false
local originalSize = MainFrame.Size

MinimizeBtn.MouseButton1Click:Connect(function()
    minimized = not minimized
    if minimized then
        TweenService:Create(MainFrame, TweenInfo.new(0.35, Enum.EasingStyle.Quint), {Size = UDim2.new(0, 260, 0, 55)}):Play()
        Content.Visible = false
        MinimizeBtn.Text = "+"
    else
        TweenService:Create(MainFrame, TweenInfo.new(0.35, Enum.EasingStyle.Quint), {Size = originalSize}):Play()
        task.wait(0.2)
        Content.Visible = true
        MinimizeBtn.Text = "−"
    end
end)

-- Button styling function
local function createStyledButton(text, posY)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 220, 0, 45)
    btn.Position = UDim2.new(0, 20, 0, posY)
    btn.BackgroundColor3 = Theme.Button_Off
    btn.Text = text .. ": OFF"
    btn.TextColor3 = Theme.Text_Light
    btn.TextSize = 13
    btn.Font = Enum.Font.GothamSemibold
    btn.Parent = Content
   
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = btn
   
    return btn
end

-- Buttons
local LockBtn = createStyledButton("ANESHSHAD YUZZALN", 20)
local ESPBtn = createStyledButton("ENEMY ESP BOX", 75)
local JumpBtn = createStyledButton("VELOCITY JUMP", 130)
local SpeedBtn = createStyledButton("RIVALS DASH BOOST", 185)

-- Info Label
local InfoLabel = Instance.new("TextLabel")
InfoLabel.Size = UDim2.new(1, 0, 0, 30)
InfoLabel.Position = UDim2.new(0, 0, 1, -35)
InfoLabel.BackgroundTransparency = 1
InfoLabel.Text = "Right-Shift • Click buttons to toggle"
InfoLabel.TextColor3 = Theme.Text_Dark
InfoLabel.TextSize = 11
InfoLabel.Font = Enum.Font.Gotham
InfoLabel.Parent = MainFrame

-- Toggle Function
local function toggleButton(btn, varName, onText, offText)
    _G[varName] = not _G[varName]
    btn.BackgroundColor3 = _G[varName] and Theme.Button_On or Theme.Button_Off
    btn.Text = _G[varName] and onText or offText
end

LockBtn.MouseButton1Click:Connect(function()
    toggleButton(LockBtn, "HardLockActive", "ANESHSHAD YUZZALN: ON", "ANESHSHAD YUZZALN: OFF")
    if not _G.HardLockActive then LockedTarget = nil end
end)

ESPBtn.MouseButton1Click:Connect(function()
    toggleButton(ESPBtn, "ESPActive", "ENEMY ESP BOX: ON", "ENEMY ESP BOX: OFF")
end)

JumpBtn.MouseButton1Click:Connect(function()
    toggleButton(JumpBtn, "VelocityJumpActive", "VELOCITY JUMP: ON", "VELOCITY JUMP: OFF")
end)

SpeedBtn.MouseButton1Click:Connect(function()
    toggleButton(SpeedBtn, "SpeedBoostActive", "RIVALS DASH BOOST: ON", "RIVALS DASH BOOST: OFF")
end)

-- Right Shift Hide/Show
UserInputService.InputBegan:Connect(function(input, processed)
    if not processed and input.KeyCode == Enum.KeyCode.RightShift then
        MainFrame.Visible = not MainFrame.Visible
    end
end)

-- ==================== ORIGINAL LOGIC STARTS HERE ====================

-- Smart Team Check
local function isEnemy(player)
    if not player or player == localPlayer then return false end
    if localPlayer.Team ~= nil and player.Team ~= nil then
        local preRoundTeams = {["Lobby"] = true, ["Neutral"] = true, ["Spectator"] = true, ["Spectators"] = true, ["Intermission"] = true, ["Choosing"] = true}
        if preRoundTeams[localPlayer.Team.Name] or preRoundTeams[player.Team.Name] then return false end
        return localPlayer.Team ~= player.Team
    end
    return true
end

-- Target Validation
local function checkValidTarget(part)
    if part and part.Parent and localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local humanoid = part.Parent:FindFirstChildOfClass("Humanoid")
        local rootPart = localPlayer.Character.HumanoidRootPart
        if humanoid and humanoid.Health > 0 then
            local distance = (part.Position - rootPart.Position).Magnitude
            if distance <= MaxLockDistance then
                local _, onScreen = camera:WorldToViewportPoint(part.Position)
                if onScreen then
                    return true
                end
            end
        end
    end
    return false
end

local function getClosestPlayer()
    local closestPlayer = nil
    local shortestDistance = math.huge
    local myChar = localPlayer.Character
    local myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart")
    if not myRoot then return nil end

    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= localPlayer and player.Character and player.Character:FindFirstChild(TargetPart) then
            local targetObj = player.Character[TargetPart]
            local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
            if humanoid and humanoid.Health > 0 then
                local distFromMe = (targetObj.Position - myRoot.Position).Magnitude
                if distFromMe <= MaxLockDistance then
                    local pos, onScreen = camera:WorldToViewportPoint(targetObj.Position)
                    if onScreen then
                        local mousePos = localPlayer:GetMouse()
                        local mouseDist = (Vector2.new(pos.X, pos.Y) - Vector2.new(mousePos.X, mousePos.Y)).Magnitude
                        if mouseDist < shortestDistance then
                            shortestDistance = mouseDist
                            closestPlayer = targetObj
                        end
                    end
                end
            end
        end
    end
    return closestPlayer
end

-- Velocity Jump
UserInputService.InputBegan:Connect(function(input, processed)
    if not processed and input.KeyCode == Enum.KeyCode.Space and _G.VelocityJumpActive then
        local char = localPlayer.Character
        local rootPart = char and char:FindFirstChild("HumanoidRootPart")
        if rootPart then
            rootPart.Velocity = Vector3.new(rootPart.Velocity.X, UpwardForce, rootPart.Velocity.Z)
        end
    end
end)

-- Rivals Dash
local isDashing = false
UserInputService.InputBegan:Connect(function(input, processed)
    if not processed and input.KeyCode == Enum.KeyCode.LeftControl and _G.SpeedBoostActive and not isDashing then
        local char = localPlayer.Character
        local rootPart = char and char:FindFirstChild("HumanoidRootPart")
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if rootPart and hum then
            isDashing = true
            local attachment = Instance.new("Attachment", rootPart)
            local linearVelocity = Instance.new("LinearVelocity")
            linearVelocity.MaxForce = 999999
            linearVelocity.Attachment0 = attachment
            local moveDir = hum.MoveDirection
            if moveDir.Magnitude == 0 then
                moveDir = rootPart.CFrame.LookVector
            end
            linearVelocity.VectorVelocity = moveDir * RivalsDashPower
            linearVelocity.Parent = rootPart
            task.wait(RivalsDashDuration)
            linearVelocity:Destroy()
            attachment:Destroy()
            isDashing = false
        end
    end
end)

-- Aimbot Loop
RunService.RenderStepped:Connect(function()
    if _G.HardLockActive then
        if LockedTarget and checkValidTarget(LockedTarget) then
            local velocity = LockedTarget.Velocity or Vector3.new(0,0,0)
            local targetPos = LockedTarget.Position + (velocity * PredictFactor)
            camera.CFrame = CFrame.new(camera.CFrame.Position, targetPos)
        else
            LockedTarget = getClosestPlayer()
            if LockedTarget then
                local velocity = LockedTarget.Velocity or Vector3.new(0,0,0)
                local targetPos = LockedTarget.Position + (velocity * PredictFactor)
                camera.CFrame = CFrame.new(camera.CFrame.Position, targetPos)
            end
        end
    end
end)

-- ESP Loop
RunService.Heartbeat:Connect(function()
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= localPlayer and player.Character then
            local highlight = player.Character:FindFirstChild("im1dnESP")
            if _G.ESPActive and isEnemy(player) then
                if not highlight then
                    highlight = Instance.new("Highlight")
                    highlight.Name = "im1dnESP"
                    highlight.FillColor = Theme.Accent
                    highlight.FillTransparency = 0.5
                    highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
                    highlight.Parent = player.Character
                end
            else
                if highlight then highlight:Destroy() end
            end
        end
    end
end)

print("im1dn HUB Loaded Successfully!")
