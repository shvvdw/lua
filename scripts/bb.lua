--[[
    Buy the Script
    Ultra Premium Theme
    Compatible with Xeno
]]

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local GuiService = game:GetService("GuiService")
local StarterGui = game:GetService("StarterGui")

local player = Players.LocalPlayer
local DISCORD_URL = "https://discord.com/users/1150575750508974130"

local function getGuiParent()
	local success, result = pcall(function()
		return gethui and gethui() or game:GetService("CoreGui")
	end)
	if success and result then return result end
	return player:WaitForChild("PlayerGui")
end

pcall(function()
	local old = getGuiParent():FindFirstChild("ScriptEndedGui")
	if old then old:Destroy() end
end)

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ScriptEndedGui"
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.IgnoreGuiInset = true
screenGui.Parent = getGuiParent()

-- Main Frame
local main = Instance.new("Frame")
main.Name = "Main"
main.Size = UDim2.new(0, 0, 0, 0)
main.Position = UDim2.new(0.5, 0, 0.5, 0)
main.AnchorPoint = Vector2.new(0.5, 0.5)
main.BackgroundColor3 = Color3.fromRGB(10, 10, 16)
main.BorderSizePixel = 0
main.ClipsDescendants = true
main.Visible = false
main.Parent = screenGui

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 20)
mainCorner.Parent = main

local mainStroke = Instance.new("UIStroke")
mainStroke.Color = Color3.fromRGB(150, 100, 255)
mainStroke.Thickness = 1.8
mainStroke.Transparency = 0.35
mainStroke.Parent = main

local bgGrad = Instance.new("UIGradient")
bgGrad.Color = ColorSequence.new({
	ColorSequenceKeypoint.new(0.00, Color3.fromRGB(28, 18, 55)),
	ColorSequenceKeypoint.new(0.40, Color3.fromRGB(12, 10, 22)),
	ColorSequenceKeypoint.new(1.00, Color3.fromRGB(20, 12, 40))
})
bgGrad.Rotation = 145
bgGrad.Parent = main

-- Top neon bar
local topBar = Instance.new("Frame")
topBar.Size = UDim2.new(1, 0, 0, 4)
topBar.BackgroundColor3 = Color3.fromRGB(170, 110, 255)
topBar.BorderSizePixel = 0
topBar.Parent = main

local topBarGrad = Instance.new("UIGradient")
topBarGrad.Color = ColorSequence.new({
	ColorSequenceKeypoint.new(0, Color3.fromRGB(90, 40, 220)),
	ColorSequenceKeypoint.new(0.5, Color3.fromRGB(210, 140, 255)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(90, 40, 220))
})
topBarGrad.Parent = topBar

-- Soft glow
local outerGlow = Instance.new("ImageLabel")
outerGlow.Size = UDim2.new(1, 60, 1, 60)
outerGlow.Position = UDim2.new(0.5, 0, 0.5, 0)
outerGlow.AnchorPoint = Vector2.new(0.5, 0.5)
outerGlow.BackgroundTransparency = 1
outerGlow.Image = "rbxassetid://5028857084"
outerGlow.ImageColor3 = Color3.fromRGB(130, 70, 255)
outerGlow.ImageTransparency = 0.78
outerGlow.ZIndex = 0
outerGlow.Parent = main

-- Title
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -40, 0, 48)
title.Position = UDim2.new(0, 20, 0, 22)
title.BackgroundTransparency = 1
title.Text = "Buy the Script"
title.TextColor3 = Color3.fromRGB(250, 248, 255)
title.TextSize = 22
title.Font = Enum.Font.GothamBold
title.TextXAlignment = Enum.TextXAlignment.Center
title.Parent = main

local subtitle = Instance.new("TextLabel")
subtitle.Size = UDim2.new(1, -20, 0, 16)
subtitle.Position = UDim2.new(0, 10, 0, 68)
subtitle.BackgroundTransparency = 1
subtitle.Text = "Press  ESC  to close"
subtitle.TextColor3 = Color3.fromRGB(130, 125, 165)
subtitle.TextSize = 12
subtitle.Font = Enum.Font.Gotham
subtitle.TextXAlignment = Enum.TextXAlignment.Center
subtitle.Parent = main

-- Open link + notification
local function openDiscord()
	if setclipboard then
		pcall(function()
			setclipboard(DISCORD_URL)
		end)
	end

	pcall(function()
		GuiService:OpenBrowserWindow(DISCORD_URL)
	end)

	pcall(function()
		StarterGui:SetCore("SendNotification", {
			Title = "Link Copied ✓",
			Text = "Discord link copied to clipboard",
			Duration = 4
		})
	end)
end

-- Premium Button
local function createButton(name, text, color1, color2, posY)
	local btn = Instance.new("TextButton")
	btn.Name = name
	btn.Size = UDim2.new(0, 280, 0, 50)
	btn.Position = UDim2.new(0.5, -140, 0, posY)
	btn.BackgroundColor3 = color1
	btn.Text = text
	btn.TextColor3 = Color3.fromRGB(255, 255, 255)
	btn.TextSize = 15
	btn.Font = Enum.Font.GothamBold
	btn.AutoButtonColor = false
	btn.Parent = main

	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 12)
	corner.Parent = btn

	local stroke = Instance.new("UIStroke")
	stroke.Color = Color3.fromRGB(255, 255, 255)
	stroke.Thickness = 1.2
	stroke.Transparency = 0.82
	stroke.Parent = btn

	local grad = Instance.new("UIGradient")
	grad.Color = ColorSequence.new({
		ColorSequenceKeypoint.new(0, color1),
		ColorSequenceKeypoint.new(1, color2)
	})
	grad.Rotation = 90
	grad.Parent = btn

	btn.MouseEnter:Connect(function()
		TweenService:Create(btn, TweenInfo.new(0.2, Enum.EasingStyle.Quint), {
			Size = UDim2.new(0, 292, 0, 54)
		}):Play()
		TweenService:Create(stroke, TweenInfo.new(0.2), {Transparency = 0.35}):Play()
	end)

	btn.MouseLeave:Connect(function()
		TweenService:Create(btn, TweenInfo.new(0.2, Enum.EasingStyle.Quint), {
			Size = UDim2.new(0, 280, 0, 50)
		}):Play()
		TweenService:Create(stroke, TweenInfo.new(0.2), {Transparency = 0.82}):Play()
	end)

	btn.MouseButton1Click:Connect(function()
		TweenService:Create(btn, TweenInfo.new(0.07), {
			Size = UDim2.new(0, 270, 0, 47)
		}):Play()
		task.delay(0.07, function()
			TweenService:Create(btn, TweenInfo.new(0.15, Enum.EasingStyle.Back), {
				Size = UDim2.new(0, 292, 0, 54)
			}):Play()
		end)
		openDiscord()
	end)

	return btn
end

local buyBtn = createButton("BuyBtn", "BUY IT FROM HERE", 
	Color3.fromRGB(0, 210, 120), Color3.fromRGB(0, 140, 80), 105)

local discordBtn = createButton("DiscordBtn", "DISCORD", 
	Color3.fromRGB(100, 110, 255), Color3.fromRGB(60, 70, 200), 168)

-- Close Button
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 30, 0, 30)
closeBtn.Position = UDim2.new(1, -40, 0, 14)
closeBtn.BackgroundColor3 = Color3.fromRGB(210, 45, 70)
closeBtn.Text = "✕"
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.TextSize = 14
closeBtn.Font = Enum.Font.GothamBold
closeBtn.AutoButtonColor = false
closeBtn.Parent = main

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(1, 0)
closeCorner.Parent = closeBtn

closeBtn.MouseEnter:Connect(function()
	TweenService:Create(closeBtn, TweenInfo.new(0.15), {
		BackgroundColor3 = Color3.fromRGB(240, 65, 90),
		Size = UDim2.new(0, 32, 0, 32)
	}):Play()
end)
closeBtn.MouseLeave:Connect(function()
	TweenService:Create(closeBtn, TweenInfo.new(0.15), {
		BackgroundColor3 = Color3.fromRGB(210, 45, 70),
		Size = UDim2.new(0, 30, 0, 30)
	}):Play()
end)

-- Open / Close
local isOpen = false
local targetSize = UDim2.new(0, 360, 0, 265)

local function openGui()
	main.Visible = true
	main.Size = UDim2.new(0, 0, 0, 0)
	main.BackgroundTransparency = 0.4

	TweenService:Create(main, TweenInfo.new(0.45, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
		Size = targetSize,
		BackgroundTransparency = 0
	}):Play()

	TweenService:Create(mainStroke, TweenInfo.new(0.45), {
		Transparency = 0.25
	}):Play()

	isOpen = true
end

local function closeGui()
	local tw = TweenService:Create(main, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
		Size = UDim2.new(0, 0, 0, 0),
		BackgroundTransparency = 0.6
	})
	tw:Play()
	tw.Completed:Connect(function()
		main.Visible = false
	end)
	isOpen = false
end

closeBtn.MouseButton1Click:Connect(closeGui)

UserInputService.InputBegan:Connect(function(input, gp)
	if gp then return end
	if input.KeyCode == Enum.KeyCode.Escape then
		if isOpen then closeGui() else openGui() end
	end
end)

task.wait(0.3)
openGui()

print("✅ Buy the Script UI loaded")
