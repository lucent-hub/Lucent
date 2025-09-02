--// Services
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

--// ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "SleekAimbotGUI"
screenGui.ResetOnSpawn = false
screenGui.IgnoreGuiInset = true
screenGui.Parent = playerGui

--// Dragging function
local function makeDraggable(frame)
    local dragging, dragInput, dragStart, startPos
    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
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

--// Main Frame
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0.35, 0, 0.55, 0)
mainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
mainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
mainFrame.BackgroundTransparency = 0.05
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui
makeDraggable(mainFrame)

local uicorner = Instance.new("UICorner")
uicorner.CornerRadius = UDim.new(0, 12)
uicorner.Parent = mainFrame

-- Title Bar
local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 40)
titleBar.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
titleBar.Parent = mainFrame

local barCorner = Instance.new("UICorner")
barCorner.CornerRadius = UDim.new(0, 12)
barCorner.Parent = titleBar

local title = Instance.new("TextLabel")
title.Size = UDim2.new(0.7, 0, 1, 0)
title.Position = UDim2.new(0, 10, 0, 0)
title.BackgroundTransparency = 1
title.Text = "LUCENT | aim"
title.Font = Enum.Font.GothamBold
title.TextSize = 20
title.TextColor3 = Color3.fromRGB(0, 255, 255)
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = titleBar

-- Buttons (Minimize & Close)
local function createTopBtn(symbol, pos, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 30, 0, 30)
    btn.Position = pos
    btn.AnchorPoint = Vector2.new(1, 0.5)
    btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    btn.Text = symbol
    btn.TextColor3 = Color3.fromRGB(0, 255, 255)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 20
    btn.Parent = titleBar

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = btn

    btn.MouseButton1Click:Connect(callback)

    return btn
end

local reopenBtn

-- Minimize Button
local minimizeBtn = createTopBtn("–", UDim2.new(0.9, 0, 0.5, 0), function()
    mainFrame.Visible = false

    reopenBtn = Instance.new("TextButton")
    reopenBtn.Size = UDim2.new(0, 60, 0, 30)
    reopenBtn.Position = UDim2.new(0, 20, 1, -50)
    reopenBtn.AnchorPoint = Vector2.new(0, 1)
    reopenBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    reopenBtn.Text = "Open"
    reopenBtn.TextColor3 = Color3.fromRGB(0, 255, 255)
    reopenBtn.Font = Enum.Font.GothamBold
    reopenBtn.TextSize = 18
    reopenBtn.Parent = screenGui

    local rcorner = Instance.new("UICorner")
    rcorner.CornerRadius = UDim.new(0, 8)
    rcorner.Parent = reopenBtn

    makeDraggable(reopenBtn)

    reopenBtn.MouseButton1Click:Connect(function()
        mainFrame.Visible = true
        reopenBtn:Destroy()
    end)
end)

-- Close Button
local closeBtn = createTopBtn("X", UDim2.new(1, -5, 0.5, 0), function()
    screenGui:Destroy()
end)

-- Toggle container
local toggleContainer = Instance.new("ScrollingFrame")
toggleContainer.Size = UDim2.new(1, -20, 1, -60)
toggleContainer.Position = UDim2.new(0, 10, 0, 50)
toggleContainer.BackgroundTransparency = 1
toggleContainer.ScrollBarThickness = 4
toggleContainer.CanvasSize = UDim2.new(0, 0, 0, 0)
toggleContainer.Parent = mainFrame

local uiList = Instance.new("UIListLayout")
uiList.Padding = UDim.new(0, 8)
uiList.FillDirection = Enum.FillDirection.Vertical
uiList.HorizontalAlignment = Enum.HorizontalAlignment.Center
uiList.SortOrder = Enum.SortOrder.LayoutOrder
uiList.Parent = toggleContainer

-- Toggles
local function createToggle(name, default, callback)
    local toggleFrame = Instance.new("Frame")
    toggleFrame.Size = UDim2.new(0.9, 0, 0, 40)
    toggleFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    toggleFrame.Parent = toggleContainer

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = toggleFrame

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.7, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = name
    label.Font = Enum.Font.GothamBold
    label.TextSize = 18
    label.TextColor3 = Color3.fromRGB(200, 200, 200)
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Position = UDim2.new(0, 10, 0, 0)
    label.Parent = toggleFrame

    local button = Instance.new("TextButton")
    button.Size = UDim2.new(0, 50, 0, 25)
    button.Position = UDim2.new(0.75, 0, 0.5, -12)
    button.BackgroundColor3 = default and Color3.fromRGB(0, 255, 255) or Color3.fromRGB(60, 60, 60)
    button.Text = ""
    button.Parent = toggleFrame

    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 8)
    btnCorner.Parent = button

    button.MouseButton1Click:Connect(function()
        default = not default
        button.BackgroundColor3 = default and Color3.fromRGB(0, 255, 255) or Color3.fromRGB(60, 60, 60)
        callback(default)
    end)
end

-- Slider
local function createSlider(name, min, max, default, callback)
    local sliderFrame = Instance.new("Frame")
    sliderFrame.Size = UDim2.new(0.9, 0, 0, 50)
    sliderFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    sliderFrame.Parent = toggleContainer

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = sliderFrame

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 0, 20)
    label.BackgroundTransparency = 1
    label.Text = name .. ": " .. default
    label.Font = Enum.Font.GothamBold
    label.TextSize = 16
    label.TextColor3 = Color3.fromRGB(200, 200, 200)
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Position = UDim2.new(0, 10, 0, 5)
    label.Parent = sliderFrame

    local bar = Instance.new("Frame")
    bar.Size = UDim2.new(0.8, 0, 0, 6)
    bar.Position = UDim2.new(0.1, 0, 0, 35)
    bar.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    bar.Parent = sliderFrame
    local barCorner = Instance.new("UICorner")
    barCorner.CornerRadius = UDim.new(1, 0)
    barCorner.Parent = bar

    local fill = Instance.new("Frame")
    fill.Size = UDim2.new((default-min)/(max-min), 0, 1, 0)
    fill.BackgroundColor3 = Color3.fromRGB(0, 255, 255)
    fill.Parent = bar
    local fillCorner = Instance.new("UICorner")
    fillCorner.CornerRadius = UDim.new(1, 0)
    fillCorner.Parent = fill

    local dragging = false
    bar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
        end
    end)
    bar.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local pos = math.clamp((input.Position.X - bar.AbsolutePosition.X)/bar.AbsoluteSize.X, 0, 1)
            fill.Size = UDim2.new(pos, 0, 1, 0)
            local val = math.floor(min + (max-min)*pos)
            label.Text = name .. ": " .. val
            callback(val)
        end
    end)
end

-- Dropdown
local function createDropdown(name, options, defaultIndex, callback)
    local dropFrame = Instance.new("Frame")
    dropFrame.Size = UDim2.new(0.9, 0, 0, 40)
    dropFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    dropFrame.ClipsDescendants = true
    dropFrame.Parent = toggleContainer

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = dropFrame

    local selectedOption = options[defaultIndex] or options[1]
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.7, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = name .. ": " .. selectedOption
    label.Font = Enum.Font.GothamBold
    label.TextSize = 16
    label.TextColor3 = Color3.fromRGB(200, 200, 200)
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Position = UDim2.new(0, 10, 0, 0)
    label.Parent = dropFrame

    local button = Instance.new("TextButton")
    button.Size = UDim2.new(0.25, 0, 0.7, 0)
    button.Position = UDim2.new(0.7, 0, 0.15, 0)
    button.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    button.Text = "▼"
    button.TextColor3 = Color3.fromRGB(0, 255, 255)
    button.Font = Enum.Font.GothamBold
    button.TextSize = 18
    button.Parent = dropFrame

    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 8)
    btnCorner.Parent = button

    local listOpen = false
    local listFrame

    local function closeDropdown()
        if listFrame then
            listFrame:Destroy()
            listFrame = nil
        end
        listOpen = false
        dropFrame.Size = UDim2.new(0.9, 0, 0, 40)
    end

    local function openDropdown()
        if listOpen then return end
        
        listOpen = true
        dropFrame.Size = UDim2.new(0.9, 0, 0, 40 + (#options * 30))
        
        listFrame = Instance.new("Frame")
        listFrame.Size = UDim2.new(1, 0, 0, #options * 30)
        listFrame.Position = UDim2.new(0, 0, 0, 40)
        listFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        listFrame.BorderSizePixel = 0
        listFrame.Parent = dropFrame
        
        local listLayout = Instance.new("UIListLayout")
        listLayout.Parent = listFrame
        
        for i, opt in ipairs(options) do
            local optBtn = Instance.new("TextButton")
            optBtn.Size = UDim2.new(1, 0, 0, 30)
            optBtn.Position = UDim2.new(0, 0, 0, (i-1)*30)
            optBtn.Text = opt
            optBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
            optBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
            optBtn.Font = Enum.Font.Gotham
            optBtn.TextSize = 16
            optBtn.BorderSizePixel = 0
            optBtn.Parent = listFrame
            
            optBtn.MouseButton1Click:Connect(function()
                selectedOption = opt
                label.Text = name .. ": " .. opt
                callback(opt)
                closeDropdown()
            end)
            
            optBtn.MouseEnter:Connect(function()
                optBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
            end)
            
            optBtn.MouseLeave:Connect(function()
                optBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
            end)
        end
    end

    button.MouseButton1Click:Connect(function()
        if listOpen then
            closeDropdown()
        else
            openDropdown()
        end
    end)

    return {
        Set = function(value)
            if table.find(options, value) then
                selectedOption = value
                label.Text = name .. ": " .. value
                callback(value)
            end
        end,
        Get = function()
            return selectedOption
        end
    }
end

uiList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    toggleContainer.CanvasSize = UDim2.new(0, 0, 0, uiList.AbsoluteContentSize.Y + 10)
end)

--// Aimbot Settings
local settings = {
    WallCheck = true,
    TeamCheck = true,
    FOVCircle = true,
    AimSmoothness = 5,
    TargetBone = "Head"
}

-- Toggles
createToggle("Wall Check", settings.WallCheck, function(val) settings.WallCheck = val end)
createToggle("Team Check", settings.TeamCheck, function(val) settings.TeamCheck = val end)
createToggle("FOV Circle", settings.FOVCircle, function(val) settings.FOVCircle = val end)

-- Slider
createSlider("Aim Smoothness", 1, 20, settings.AimSmoothness, function(val) settings.AimSmoothness = val end)

-- Dropdown
--// Aimbot toggle
local AimbotEnabled = false
createToggle("Enable Aimbot", AimbotEnabled, function(val)
    AimbotEnabled = val
end)

--// Get closest target
local function getClosestTarget()
    local closestPlayer = nil
    local shortestDistance = math.huge

    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= player then
            if settings.TeamCheck and plr.Team == player.Team then continue end
            local char = plr.Character
            if char then
                local bone = settings.TargetBone
                if bone == "Random" then
                    local bones = {"Head", "Torso"}
                    bone = bones[math.random(1, #bones)]
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

--// Aim at target (only if toggle is on)
local function aimAtTarget()
    if not AimbotEnabled then return end  -- Skip if disabled

    local target = getClosestTarget()
    if target and target.Character then
        local bone = settings.TargetBone
        if bone == "Random" then
            local bones = {"Head", "Torso"}
            bone = bones[math.random(1, #bones)]
        end
        local part = target.Character:FindFirstChild(bone)
        if part then
            local cam = workspace.CurrentCamera
            local dir = (part.Position - cam.CFrame.Position).Unit
            cam.CFrame = CFrame.new(cam.CFrame.Position, cam.CFrame.Position + dir * settings.AimSmoothness)
        end
    end
end

--// Main loop
game:GetService("RunService").RenderStepped:Connect(aimAtTarget)
