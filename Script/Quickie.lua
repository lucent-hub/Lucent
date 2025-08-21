--// Services
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local hrp = character:WaitForChild("HumanoidRootPart")

--// Settings
local animId = 117663842940230
local tweenTime = 0.4 -- fast blink
local stayTime = 5
local savedPosition = nil
local dipStuds = 30 -- dip under position by 30 studs

--// GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "LucentInkGUI"
screenGui.Parent = player:WaitForChild("PlayerGui")

-- Main Frame
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 350, 0, 200)
mainFrame.Position = UDim2.new(0.5, -175, 0.5, -100)
mainFrame.BackgroundColor3 = Color3.fromRGB(25,25,25)
mainFrame.BorderSizePixel = 0
mainFrame.AnchorPoint = Vector2.new(0.5,0.5)
mainFrame.Parent = screenGui
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.ClipsDescendants = true

-- Shadow effect
local shadow = Instance.new("UIStroke")
shadow.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
shadow.Color = Color3.fromRGB(0, 255, 255)
shadow.Thickness = 2
shadow.Transparency = 0.5
shadow.Parent = mainFrame

-- Gradient
local gradient = Instance.new("UIGradient")
gradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(0,255,255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(255,0,255))
}
gradient.Rotation = 45
gradient.Parent = mainFrame

-- Title
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1,0,0,50)
title.BackgroundTransparency = 1
title.Text = "Lucent Ink"
title.TextColor3 = Color3.fromRGB(0, 255, 255)
title.Font = Enum.Font.GothamBold
title.TextSize = 28
title.Parent = mainFrame
title.TextStrokeTransparency = 0.7

-- Button creator
local function createButton(text, yPos)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.85,0,0,45)
    btn.Position = UDim2.new(0.075,0,0,yPos)
    btn.BackgroundColor3 = Color3.fromRGB(15,15,15)
    btn.BorderSizePixel = 0
    btn.TextColor3 = Color3.fromRGB(0,255,255)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 20
    btn.Text = text
    btn.AutoButtonColor = false
    btn.Parent = mainFrame

    -- Glow effect
    local glow = Instance.new("UIStroke")
    glow.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    glow.Color = Color3.fromRGB(0,255,255)
    glow.Thickness = 2
    glow.Transparency = 0.6
    glow.Parent = btn

    -- Hover animation
    btn.MouseEnter:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundColor3 = Color3.fromRGB(0,50,50)}):Play()
        TweenService:Create(glow, TweenInfo.new(0.2), {Transparency = 0}):Play()
    end)
    btn.MouseLeave:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundColor3 = Color3.fromRGB(15,15,15)}):Play()
        TweenService:Create(glow, TweenInfo.new(0.2), {Transparency = 0.6}):Play()
    end)

    return btn
end

-- Save Pos Button
local saveBtn = createButton("Save Pos", 60)

-- Start Animation Button
local startBtn = createButton("only w 120", 120)

--// Teleport function with 30 studs dip, fast blink
local function teleportWithTweenUndermap(targetPos)
    local originalPosition = hrp.Position
    local underY = originalPosition.Y - dipStuds

    local downPos = Vector3.new(originalPosition.X, underY, originalPosition.Z)
    TweenService:Create(hrp, TweenInfo.new(tweenTime, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {CFrame = CFrame.new(downPos)}):Play()
    task.wait(tweenTime)

    local upPos = Vector3.new(targetPos.X, targetPos.Y, targetPos.Z)
    TweenService:Create(hrp, TweenInfo.new(tweenTime, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {CFrame = CFrame.new(upPos)}):Play()
    task.wait(tweenTime)

    task.wait(stayTime)

    TweenService:Create(hrp, TweenInfo.new(tweenTime, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {CFrame = CFrame.new(downPos)}):Play()
    task.wait(tweenTime)

    TweenService:Create(hrp, TweenInfo.new(tweenTime, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {CFrame = CFrame.new(originalPosition)}):Play()
end

--// Animation detection (does nothing until you play anim)
humanoid.AnimationPlayed:Connect(function(track)
    if track.Animation.AnimationId == "rbxassetid://"..animId and savedPosition then
        teleportWithTweenUndermap(savedPosition)
    end
end)

--// Buttons logic
saveBtn.MouseButton1Click:Connect(function()
    savedPosition = hrp.Position
    saveBtn.Text = "Position Saved!"
    task.wait(1)
    saveBtn.Text = "Save Pos"
end)

startBtn.MouseButton1Click:Connect(function()
    -- only plays animation if you want, not automatic
end)
