-- Rivals Trial Ended Message (for Xeno)

local Players = game:GetService("Players")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Remove old GUI if it already exists
if playerGui:FindFirstChild("TrialEndedGui") then
    playerGui.TrialEndedGui:Destroy()
end

-- Create ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "TrialEndedGui"
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.Parent = playerGui

-- Dark overlay
local overlay = Instance.new("Frame")
overlay.Size = UDim2.new(1, 0, 1, 0)
overlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
overlay.BackgroundTransparency = 0.45
overlay.BorderSizePixel = 0
overlay.Parent = screenGui

-- Main box
local messageBox = Instance.new("Frame")
messageBox.Size = UDim2.new(0, 440, 0, 240)
messageBox.Position = UDim2.new(0.5, -220, 0.5, -120)
messageBox.BackgroundColor3 = Color3.fromRGB(22, 22, 28)
messageBox.BorderSizePixel = 0
messageBox.Parent = screenGui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 14)
corner.Parent = messageBox

-- Title
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -20, 0, 45)
title.Position = UDim2.new(0, 10, 0, 12)
title.BackgroundTransparency = 1
title.Text = "Trial Ended"
title.TextColor3 = Color3.fromRGB(255, 70, 70)
title.TextSize = 26
title.Font = Enum.Font.GothamBold
title.Parent = messageBox

-- Message
local message = Instance.new("TextLabel")
message.Size = UDim2.new(1, -30, 0, 100)
message.Position = UDim2.new(0, 15, 0, 60)
message.BackgroundTransparency = 1
message.Text = "Rivals script trial ended\nplease Dm me discord: im1dn\nor buy it directly from\neldorado.gg/users/im1dn_store"
message.TextColor3 = Color3.fromRGB(235, 235, 235)
message.TextSize = 16
message.Font = Enum.Font.Gotham
message.TextWrapped = true
message.TextYAlignment = Enum.TextYAlignment.Top
message.Parent = messageBox

-- Exit button
local closeButton = Instance.new("TextButton")
closeButton.Size = UDim2.new(0, 150, 0, 42)
closeButton.Position = UDim2.new(0.5, -75, 1, -58)
closeButton.BackgroundColor3 = Color3.fromRGB(210, 45, 45)
closeButton.Text = "Exit"
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeButton.TextSize = 18
closeButton.Font = Enum.Font.GothamBold
closeButton.Parent = messageBox

local btnCorner = Instance.new("UICorner")
btnCorner.CornerRadius = UDim.new(0, 8)
btnCorner.Parent = closeButton

-- Close when clicked
closeButton.MouseButton1Click:Connect(function()
    screenGui:Destroy()
end)
