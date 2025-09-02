local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local isTouch = UserInputService.TouchEnabled or (not UserInputService.MouseEnabled)

local MOBILE_UISCALE = 0.78
local DESKTOP_UISCALE = 1

local uiScaleValue = isTouch and MOBILE_UISCALE or DESKTOP_UISCALE

local function getHumanoid()
    local character = player.Character or player.CharacterAdded:Wait()
    return character:WaitForChild("Humanoid")
end

local humanoid = getHumanoid()
local animator = humanoid:FindFirstChild("Animator") or Instance.new("Animator", humanoid)
local currentAnimTrack

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "TS_AnimPlayer"
screenGui.ResetOnSpawn = false
screenGui.IgnoreGuiInset = true
screenGui.Parent = playerGui

local guiScale = Instance.new("UIScale")
guiScale.Scale = uiScaleValue
guiScale.Parent = screenGui

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

local function scaled(size)
    return math.max(12, math.floor(size * (1 + (uiScaleValue - 1))))
end

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0.35, 0, 0.55, 0)
mainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
mainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
mainFrame.BackgroundTransparency = 0.05
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui
makeDraggable(mainFrame)

if isTouch then
    mainFrame.Position = UDim2.new(0.5, 0, 0.45, 0)
end

local uicorner = Instance.new("UICorner")
uicorner.CornerRadius = UDim.new(0, 12)
uicorner.Parent = mainFrame

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
title.Text = "LUCENT"
title.Font = Enum.Font.GothamBold
title.TextSize = scaled(20)
title.TextColor3 = Color3.fromRGB(0, 255, 255)
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = titleBar

local function createTopBtn(symbol, pos, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 30, 0, 30)
    btn.Position = pos
    btn.AnchorPoint = Vector2.new(1, 0.5)
    btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    btn.Text = symbol
    btn.TextColor3 = Color3.fromRGB(0, 255, 255)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = scaled(20)
    btn.Parent = titleBar

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = btn

    btn.MouseButton1Click:Connect(callback)
    return btn
end

local reopenBtn

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
    reopenBtn.TextSize = scaled(18)
    reopenBtn.Parent = screenGui

    local rcorner = Instance.new("UICorner")
    rcorner.CornerRadius = UDim.new(0, 8)
    rcorner.Parent = reopenBtn

    makeDraggable(reopenBtn)

    if isTouch then
        reopenBtn.Position = UDim2.new(0, 10, 1, -70)
        reopenBtn.AnchorPoint = Vector2.new(0, 1)
    end

    reopenBtn.MouseButton1Click:Connect(function()
        mainFrame.Visible = true
        if reopenBtn and reopenBtn.Parent then reopenBtn:Destroy() end
    end)
end)

local closeBtn = createTopBtn("X", UDim2.new(1, -5, 0.5, 0), function()
    screenGui:Destroy()
end)

local toggleContainer = Instance.new("ScrollingFrame")
toggleContainer.Size = UDim2.new(1, -20, 1, -60)
toggleContainer.Position = UDim2.new(0, 10, 0, 50)
toggleContainer.BackgroundTransparency = 1
toggleContainer.ScrollBarThickness = 6
toggleContainer.CanvasSize = UDim2.new(0, 0, 0, 0)
toggleContainer.Parent = mainFrame

local uiList = Instance.new("UIListLayout")
uiList.Padding = UDim.new(0, 8)
uiList.FillDirection = Enum.FillDirection.Vertical
uiList.HorizontalAlignment = Enum.HorizontalAlignment.Center
uiList.SortOrder = Enum.SortOrder.LayoutOrder
uiList.Parent = toggleContainer

local function createToggle(name, default, callback)
    local toggleFrame = Instance.new("Frame")
    toggleFrame.Size = UDim2.new(0.9, 0, 0, isTouch and 48 or 40)
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
    label.TextSize = scaled(18)
    label.TextColor3 = Color3.fromRGB(200, 200, 200)
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Position = UDim2.new(0, 10, 0, 0)
    label.Parent = toggleFrame

    local button = Instance.new("TextButton")
    button.Size = UDim2.new(0, isTouch and 60 or 50, 0, isTouch and 30 or 25)
    button.Position = UDim2.new(0.75, 0, 0.5, -(isTouch and 15 or 12))
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

local function createSlider(name, min, max, default, callback)
    local sliderFrame = Instance.new("Frame")
    sliderFrame.Size = UDim2.new(0.9, 0, 0, isTouch and 58 or 50)
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
    label.TextSize = scaled(16)
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

local function createDropdown(name, options, defaultIndex, callback)
    local dropFrame = Instance.new("Frame")
    dropFrame.Size = UDim2.new(0.9, 0, 0, isTouch and 48 or 40)
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
    label.TextSize = scaled(16)
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
    button.TextSize = scaled(18)
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
        dropFrame.Size = UDim2.new(0.9, 0, 0, isTouch and 48 or 40)
    end

    local function openDropdown()
        if listOpen then return end
        
        listOpen = true
        dropFrame.Size = UDim2.new(0.9, 0, 0, (isTouch and 48 or 40) + (#options * 30))
        
        listFrame = Instance.new("Frame")
        listFrame.Size = UDim2.new(1, 0, 0, #options * 30)
        listFrame.Position = UDim2.new(0, 0, 0, isTouch and 48 or 40)
        listFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        listFrame.BorderSizePixel = 0
        listFrame.Parent = dropFrame
        
        local lcorner = Instance.new("UICorner")
        lcorner.CornerRadius = UDim.new(0, 0, 0, 10)
        lcorner.Parent = listFrame
        
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
            optBtn.TextSize = scaled(16)
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
    
    local connection
    connection = UserInputService.InputBegan:Connect(function(input)
        if listOpen and input.UserInputType == Enum.UserInputType.MouseButton1 then
            local mousePos = input.Position
            local dropAbsPos = dropFrame.AbsolutePosition
            local dropAbsSize = dropFrame.AbsoluteSize
            
            if mousePos.X < dropAbsPos.X or mousePos.X > dropAbsPos.X + dropAbsSize.X or
               mousePos.Y < dropAbsPos.Y or mousePos.Y > dropAbsPos.Y + dropAbsSize.Y then
                closeDropdown()
            end
        end
    end)
    
    dropFrame.Destroying:Connect(function()
        if connection then
            connection:Disconnect()
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

local inputBox = Instance.new("TextBox")
inputBox.Size = UDim2.new(0.9, 0, 0, isTouch and 44 or 40)
inputBox.PlaceholderText = "Enter Animation ID..."
inputBox.Text = ""
inputBox.Font = Enum.Font.GothamBold
inputBox.TextSize = scaled(16)
inputBox.TextColor3 = Color3.fromRGB(200, 200, 200)
inputBox.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
inputBox.Parent = toggleContainer
local inputCorner = Instance.new("UICorner")
inputCorner.CornerRadius = UDim.new(0, 10)
inputCorner.Parent = inputBox

local playBtn = Instance.new("TextButton")
playBtn.Size = UDim2.new(0.9, 0, 0, isTouch and 48 or 40)
playBtn.Text = "▶ Play Animation"
playBtn.Font = Enum.Font.GothamBold
playBtn.TextSize = scaled(18)
playBtn.TextColor3 = Color3.fromRGB(0, 255, 255)
playBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
playBtn.Parent = toggleContainer
local playCorner = Instance.new("UICorner")
playCorner.CornerRadius = UDim.new(0, 10)
playCorner.Parent = playBtn

local stopBtn = Instance.new("TextButton")
stopBtn.Size = UDim2.new(0.9, 0, 0, isTouch and 48 or 40)
stopBtn.Text = "⏹ Stop Animation"
stopBtn.Font = Enum.Font.GothamBold
stopBtn.TextSize = scaled(18)
stopBtn.TextColor3 = Color3.fromRGB(255, 80, 80)
stopBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
stopBtn.Parent = toggleContainer
local stopCorner = Instance.new("UICorner")
stopCorner.CornerRadius = UDim.new(0, 10)
stopCorner.Parent = stopBtn

local logLabel = Instance.new("TextLabel")
logLabel.Size = UDim2.new(0.9, 0, 0, 30)
logLabel.BackgroundTransparency = 1
logLabel.Text = "Played Animations:"
logLabel.Font = Enum.Font.GothamBold
logLabel.TextSize = scaled(16)
logLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
logLabel.TextXAlignment = Enum.TextXAlignment.Left
logLabel.Parent = toggleContainer

local logFrame = Instance.new("ScrollingFrame")
logFrame.Size = UDim2.new(0.9, 0, 0, isTouch and 140 or 120)
logFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
logFrame.ScrollBarThickness = 6
logFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
logFrame.Parent = toggleContainer
local logCorner = Instance.new("UICorner")
logCorner.CornerRadius = UDim.new(0, 10)
logCorner.Parent = logFrame

local logList = Instance.new("UIListLayout")
logList.Parent = logFrame

local function playAnim(id)
    if not id then return end
    if currentAnimTrack then
        pcall(function()
            currentAnimTrack:Stop()
            currentAnimTrack:Destroy()
        end)
        currentAnimTrack = nil
    end
    humanoid = getHumanoid()
    animator = humanoid:FindFirstChild("Animator") or Instance.new("Animator", humanoid)
    local anim = Instance.new("Animation")
    anim.AnimationId = "rbxassetid://" .. tostring(id)
    local ok, track = pcall(function() return animator:LoadAnimation(anim) end)
    if not ok or not track then
        local errLabel = Instance.new("TextLabel")
        errLabel.Size = UDim2.new(1, -5, 0, 24)
        errLabel.BackgroundTransparency = 1
        errLabel.Text = "Failed to load: " .. tostring(id)
        errLabel.Font = Enum.Font.Gotham
        errLabel.TextSize = scaled(14)
        errLabel.TextColor3 = Color3.fromRGB(255, 120, 120)
        errLabel.TextXAlignment = Enum.TextXAlignment.Left
        errLabel.Parent = logFrame
        logFrame.CanvasSize = UDim2.new(0, 0, 0, logList.AbsoluteContentSize.Y)
        return
    end
    currentAnimTrack = track
    currentAnimTrack:Play()
    local logItem = Instance.new("TextLabel")
    logItem.Size = UDim2.new(1, -5, 0, 24)
    logItem.BackgroundTransparency = 1
    logItem.Text = "Played: " .. tostring(id)
    logItem.Font = Enum.Font.Gotham
    logItem.TextSize = scaled(14)
    logItem.TextColor3 = Color3.fromRGB(180, 180, 180)
    logItem.TextXAlignment = Enum.TextXAlignment.Left
    logItem.Parent = logFrame
    logFrame.CanvasSize = UDim2.new(0, 0, 0, logList.AbsoluteContentSize.Y + 8)
end

local function stopCurrent()
    if currentAnimTrack then
        pcall(function()
            currentAnimTrack:Stop()
            currentAnimTrack:Destroy()
        end)
        currentAnimTrack = nil
        local stopLog = Instance.new("TextLabel")
        stopLog.Size = UDim2.new(1, -5, 0, 24)
        stopLog.BackgroundTransparency = 1
        stopLog.Text = "Stopped animation"
        stopLog.Font = Enum.Font.Gotham
        stopLog.TextSize = scaled(14)
        stopLog.TextColor3 = Color3.fromRGB(200, 200, 200)
        stopLog.TextXAlignment = Enum.TextXAlignment.Left
        stopLog.Parent = logFrame
        logFrame.CanvasSize = UDim2.new(0, 0, 0, logList.AbsoluteContentSize.Y + 8)
    end
end

playBtn.MouseButton1Click:Connect(function()
    local id = inputBox.Text:match("%d+")
    if id then
        playAnim(id)
    else
        if inputBox.Text ~= "" then playAnim(inputBox.Text) end
    end
end)

stopBtn.MouseButton1Click:Connect(function()
    stopCurrent()
end)

player.CharacterAdded:Connect(function(char)
    humanoid = char:WaitForChild("Humanoid")
    animator = humanoid:FindFirstChild("Animator") or Instance.new("Animator", humanoid)
end)

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.Return or input.KeyCode == Enum.KeyCode.KeypadEnter then
        if not isTouch then
            local id = inputBox.Text:match("%d+")
            if id then playAnim(id) end
        end
    end
end)

print("TS Animation Player loaded (mobile small:", tostring(isTouch), ")")
