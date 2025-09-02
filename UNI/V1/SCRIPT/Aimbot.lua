local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "SleekAimbotGUI"
screenGui.ResetOnSpawn = false
screenGui.IgnoreGuiInset = true
screenGui.Parent = playerGui

local function makeDraggable(frame)
    local dragging, dragInput, dragStart, startPos
    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)
    frame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X,
                startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0.35,0,0.55,0)
mainFrame.Position = UDim2.new(0.5,0,0.5,0)
mainFrame.AnchorPoint = Vector2.new(0.5,0.5)
mainFrame.BackgroundColor3 = Color3.fromRGB(25,25,25)
mainFrame.BackgroundTransparency = 0.05
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui
makeDraggable(mainFrame)

local uicorner = Instance.new("UICorner")
uicorner.CornerRadius = UDim.new(0,12)
uicorner.Parent = mainFrame

local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1,0,0,40)
titleBar.BackgroundColor3 = Color3.fromRGB(30,30,30)
titleBar.Parent = mainFrame

local barCorner = Instance.new("UICorner")
barCorner.CornerRadius = UDim.new(0,12)
barCorner.Parent = titleBar

local title = Instance.new("TextLabel")
title.Size = UDim2.new(0.7,0,1,0)
title.Position = UDim2.new(0,10,0,0)
title.BackgroundTransparency = 1
title.Text = "LUCENT | aim"
title.Font = Enum.Font.GothamBold
title.TextSize = 20
title.TextColor3 = Color3.fromRGB(0,255,255)
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = titleBar

local function createTopBtn(symbol,pos,callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0,30,0,30)
    btn.Position = pos
    btn.AnchorPoint = Vector2.new(1,0.5)
    btn.BackgroundColor3 = Color3.fromRGB(40,40,40)
    btn.Text = symbol
    btn.TextColor3 = Color3.fromRGB(0,255,255)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 20
    btn.Parent = titleBar
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0,8)
    corner.Parent = btn
    btn.MouseButton1Click:Connect(callback)
    return btn
end

local reopenBtn

createTopBtn("–", UDim2.new(0.9,0,0.5,0), function()
    mainFrame.Visible = false
    reopenBtn = Instance.new("TextButton")
    reopenBtn.Size = UDim2.new(0,60,0,30)
    reopenBtn.Position = UDim2.new(0,20,1,-50)
    reopenBtn.AnchorPoint = Vector2.new(0,1)
    reopenBtn.BackgroundColor3 = Color3.fromRGB(25,25,25)
    reopenBtn.Text = "Open"
    reopenBtn.TextColor3 = Color3.fromRGB(0,255,255)
    reopenBtn.Font = Enum.Font.GothamBold
    reopenBtn.TextSize = 18
    reopenBtn.Parent = screenGui
    local rcorner = Instance.new("UICorner")
    rcorner.CornerRadius = UDim.new(0,8)
    rcorner.Parent = reopenBtn
    makeDraggable(reopenBtn)
    reopenBtn.MouseButton1Click:Connect(function()
        mainFrame.Visible = true
        reopenBtn:Destroy()
    end)
end)

createTopBtn("X", UDim2.new(1,-5,0.5,0), function()
    screenGui:Destroy()
end)

local toggleContainer = Instance.new("ScrollingFrame")
toggleContainer.Size = UDim2.new(1,-20,1,-60)
toggleContainer.Position = UDim2.new(0,10,0,50)
toggleContainer.BackgroundTransparency = 1
toggleContainer.ScrollBarThickness = 4
toggleContainer.CanvasSize = UDim2.new(0,0,0,0)
toggleContainer.Parent = mainFrame

local uiList = Instance.new("UIListLayout")
uiList.Padding = UDim.new(0,8)
uiList.FillDirection = Enum.FillDirection.Vertical
uiList.HorizontalAlignment = Enum.HorizontalAlignment.Center
uiList.SortOrder = Enum.SortOrder.LayoutOrder
uiList.Parent = toggleContainer

uiList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    toggleContainer.CanvasSize = UDim2.new(0,0,0,uiList.AbsoluteContentSize.Y + 10)
end)

local settings = {WallCheck = true, TeamCheck = true, FOVCircle = true, AimSmoothness = 5, TargetBone = "Head"}
local AimbotEnabled = false

local function getClosestTarget()
    local closestPlayer
    local shortestDistance = math.huge
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= player then
            if settings.TeamCheck and plr.Team == player.Team then continue end
            local char = plr.Character
            if char then
                local bone = settings.TargetBone
                if bone == "Random" then
                    local bones = {"Head","Torso"}
                    bone = bones[math.random(1,#bones)]
                end
                local part = char:FindFirstChild(bone)
                if part then
                    local dist = (part.Position - workspace.CurrentCamera.CFrame.Position).Magnitude
                    if dist < shortestDistance then
                        closestPlayer = plr
                        shortestDistance = dist
                    end
                end
            end
        end
    end
    return closestPlayer
end

local function aimAtTarget()
    if not AimbotEnabled then return end
    local target = getClosestTarget()
    if target and target.Character then
        local bone = settings.TargetBone
        if bone == "Random" then
            local bones = {"Head","Torso"}
            bone = bones[math.random(1,#bones)]
        end
        local part = target.Character:FindFirstChild(bone)
        if part then
            local cam = workspace.CurrentCamera
            local dir = (part.Position - cam.CFrame.Position).Unit
            cam.CFrame = CFrame.new(cam.CFrame.Position, cam.CFrame.Position + dir*settings.AimSmoothness)
        end
    end
end

RunService.RenderStepped:Connect(aimAtTarget)

