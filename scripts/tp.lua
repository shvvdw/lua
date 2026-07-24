-- LocalScript (محطوط فـ StarterPlayer -> StarterPlayerScripts)
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local VirtualInputManager = game:GetService("VirtualInputManager")

local player = Players.LocalPlayer
local camera = workspace.CurrentCamera
local playerGui = player:WaitForChild("PlayerGui")

local isStickyActive = false
local currentTarget = nil
local spinAngle = 0

-- الإعدادات
local TOGGLE_KEY = Enum.KeyCode.E
local SELF_SPIN_SPEED = 60 
local RAGE_WALKSPEED = 150 

print("[BOUZI MENU v7.6]: تم حذف نظام تبديل الأهداف.. الـ Aim Lock ثابت على ضحية واحدة دابا!")

------------------------------------
-- 1. إنشاء الـ UI ف الـ Top Left --
------------------------------------
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "BouziRageMenu"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

local menuFrame = Instance.new("Frame")
menuFrame.Size = UDim2.new(0, 240, 0, 130)
menuFrame.Position = UDim2.new(0, 20, 0, 20)
menuFrame.BackgroundColor3 = Color3.fromRGB(20, 0, 20)
menuFrame.Active = true
menuFrame.Draggable = true
menuFrame.Parent = screenGui

local frameCorner = Instance.new("UICorner")
frameCorner.CornerRadius = UDim.new(0, 10)
frameCorner.Parent = menuFrame

local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, 0, 0, 35)
titleLabel.Text = "BOUZI MENU v7.6"
titleLabel.TextColor3 = Color3.fromRGB(255, 0, 255)
titleLabel.TextSize = 16
titleLabel.Font = Enum.Font.GothamBold
titleLabel.BackgroundTransparency = 1
titleLabel.Parent = menuFrame

local stickyButton = Instance.new("TextButton")
stickyButton.Size = UDim2.new(0, 200, 0, 50)
stickyButton.Position = UDim2.new(0.5, -100, 0.5, 15)
stickyButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
stickyButton.Text = "RAGE BACKSTAB [E]: OFF"
stickyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
stickyButton.TextSize = 11
stickyButton.Font = Enum.Font.GothamBold
stickyButton.Parent = menuFrame

local btnCorner = Instance.new("UICorner")
btnCorner.CornerRadius = UDim.new(0, 8)
btnCorner.Parent = stickyButton

------------------------------------
-- 2. اللوجيك د الـ Aim والـ Speed (تثبيت كامل) --
------------------------------------
local function getClosestEnemy()
    local closestPlayer = nil
    local shortestDistance = math.huge
    local myChar = player.Character
    if not myChar or not myChar:FindFirstChild("HumanoidRootPart") then return nil end
    
    for _, otherPlayer in ipairs(Players:GetPlayers()) do
        if otherPlayer ~= player then
            
            -- فحص صارم للـ Teammates
            local isTeammate = false
            if player.Team and otherPlayer.Team then
                if player.Team == otherPlayer.Team or player.TeamColor == otherPlayer.TeamColor then
                    isTeammate = true
                end
            end
            
            if not isTeammate then
                if otherPlayer.Character and otherPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    local enemyHumanoid = otherPlayer.Character:FindFirstChild("Humanoid")
                    if enemyHumanoid and enemyHumanoid.Health > 0 then
                        local distance = (myChar.HumanoidRootPart.Position - otherPlayer.Character.HumanoidRootPart.Position).Magnitude
                        if distance < shortestDistance then
                            shortestDistance = distance
                            closestPlayer = otherPlayer
                        end
                    end
                end
            end
            
        end
    end
    return closestPlayer
end

RunService.RenderStepped:Connect(function(deltaTime)
    local myChar = player.Character
    local myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart")
    local myHumanoid = myChar and myChar:FindFirstChildOfClass("Humanoid")
    
    if isStickyActive and myRoot and myHumanoid then
        myHumanoid.AutoRotate = false
        myHumanoid.WalkSpeed = RAGE_WALKSPEED
        
        -- فحص هل الـ Target الحالي ما زال صالحاً (عايش، ماشي teammate، وما زال ف السيرفر)
        local currentTargetIsTeammate = false
        if currentTarget and player.Team and currentTarget.Team then
            if player.Team == currentTarget.Team or player.TeamColor == currentTarget.TeamColor then
                currentTargetIsTeammate = true
            end
        end
        
        -- دابا كنجيبو هدف جديد *فقط* إيلا ما كاين حتى هدف، أو الهدف مات، أو رجع Teammate
        if not currentTarget or currentTargetIsTeammate or not currentTarget.Character or not currentTarget.Character:FindFirstChild("HumanoidRootPart") 
           or (currentTarget.Character:FindFirstChild("Humanoid") and currentTarget.Character.Humanoid.Health <= 0) then
            
            currentTarget = getClosestEnemy()
        end
        
        if currentTarget and currentTarget.Character and currentTarget.Character:FindFirstChild("HumanoidRootPart") then
            local enemyRoot = currentTarget.Character.HumanoidRootPart
            local enemyHead = currentTarget.Character:FindFirstChild("Head") or enemyRoot
            
            -- 1. الالتصاق وراء الظهر
            local backPosition = enemyRoot.Position - (enemyRoot.CFrame.LookVector * 1.8)
            
            -- 2. الـ Self-Spin
            spinAngle = spinAngle + (SELF_SPIN_SPEED * deltaTime)
            myRoot.CFrame = CFrame.new(backPosition) * CFrame.Angles(0, spinAngle, 0)
            
            myRoot.AssemblyLinearVelocity = Vector3.new(0, myRoot.AssemblyLinearVelocity.Y, 0)
            
            -- 3. الـ Aim Lock المقفول على الرأس مباشرة
            local camPos = camera.CFrame.Position
            camera.CFrame = CFrame.new(camPos, enemyHead.Position)
            
            -- 4. سبامات الكيبورد والماوس
            VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Space, false, game)
            VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Space, false, game)
            
            VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Three, false, game)
            VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Three, false, game)
            
            VirtualInputManager:SendMouseButtonEvent(0, 0, 1, true, game, 0)
            
            local tool = myChar:FindFirstChildOfClass("Tool")
            if tool then
                tool:Activate()
            end
        end
    else
        if myHumanoid then
            myHumanoid.AutoRotate = true
            if myHumanoid.WalkSpeed == RAGE_WALKSPEED then
                myHumanoid.WalkSpeed = 16
            end
        end
    end
end)

------------------------------------
-- 3. نظام الـ Toggle --
------------------------------------
local function toggleRage()
    isStickyActive = not isStickyActive
    local myChar = player.Character
    local myHumanoid = myChar and myChar:FindFirstChildOfClass("Humanoid")
    
    if isStickyActive then
        stickyButton.Text = "RAGE BACKSTAB [E]: ON"
        stickyButton.BackgroundColor3 = Color3.fromRGB(170, 0, 255)
    else
        stickyButton.Text = "RAGE BACKSTAB [E]: OFF"
        stickyButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        VirtualInputManager:SendMouseButtonEvent(0, 0, 1, false, game, 0)
        if myHumanoid then 
            myHumanoid.AutoRotate = true 
            myHumanoid.WalkSpeed = 16
        end
        currentTarget = nil
    end
end

stickyButton.MouseButton1Click:Connect(toggleRage)

UserInputService.InputBegan:Connect(function(input, gameProcessedEvent)
    if gameProcessedEvent then return end
    if input.KeyCode == TOGGLE_KEY then
        toggleRage()
    end
end)
