local Players = game:GetService("Players")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "AnimLoggerGUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

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

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 250, 0, 320)
mainFrame.Position = UDim2.new(0.5,0,0.5,0)
mainFrame.AnchorPoint = Vector2.new(0.5,0.5)
mainFrame.BackgroundColor3 = Color3.fromRGB(25,25,25)
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui
local uicorner = Instance.new("UICorner")
uicorner.CornerRadius = UDim.new(0,10)
uicorner.Parent = mainFrame
makeDraggable(mainFrame)

local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1,0,0,30)
titleBar.BackgroundColor3 = Color3.fromRGB(30,30,30)
titleBar.Parent = mainFrame
local tbCorner = Instance.new("UICorner")
tbCorner.CornerRadius = UDim.new(0,10)
tbCorner.Parent = titleBar

local title = Instance.new("TextLabel")
title.Size = UDim2.new(0.7,0,1,0)
title.Position = UDim2.new(0,10,0,0)
title.BackgroundTransparency = 1
title.Text = "Lucent | anim logger"
title.Font = Enum.Font.GothamBold
title.TextSize = 16
title.TextColor3 = Color3.fromRGB(0,255,255)
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = titleBar

local function createTopBtn(symbol, pos, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0,25,0,25)
    btn.Position = pos
    btn.AnchorPoint = Vector2.new(1,0.5)
    btn.BackgroundColor3 = Color3.fromRGB(40,40,40)
    btn.Text = symbol
    btn.TextColor3 = Color3.fromRGB(0,255,255)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 18
    btn.Parent = titleBar
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0,6)
    corner.Parent = btn
    btn.MouseButton1Click:Connect(callback)
    return btn
end

local reopenBtn
local minimizeBtn = createTopBtn("-", UDim2.new(0.9,0,0.5,0), function()
    mainFrame.Visible = false
    reopenBtn = Instance.new("TextButton")
    reopenBtn.Size = UDim2.new(0,80,0,30)
    reopenBtn.Position = UDim2.new(0,20,1,-40)
    reopenBtn.AnchorPoint = Vector2.new(0,1)
    reopenBtn.BackgroundColor3 = Color3.fromRGB(25,25,25)
    reopenBtn.Text = "Open Logger"
    reopenBtn.TextColor3 = Color3.fromRGB(0,255,255)
    reopenBtn.Font = Enum.Font.GothamBold
    reopenBtn.TextSize = 14
    reopenBtn.Parent = screenGui
    local rcorner = Instance.new("UICorner")
    rcorner.CornerRadius = UDim.new(0,6)
    rcorner.Parent = reopenBtn
    makeDraggable(reopenBtn)
    reopenBtn.MouseButton1Click:Connect(function()
        mainFrame.Visible = true
        reopenBtn:Destroy()
    end)
end)

local closeBtn = createTopBtn("X", UDim2.new(1, -5, 0.5, 0), function()
    screenGui:Destroy()
end)

local searchBox = Instance.new("TextBox")
searchBox.Size = UDim2.new(0.9,0,0,25)
searchBox.Position = UDim2.new(0.05,0,0,35)
searchBox.PlaceholderText = "Search animation..."
searchBox.BackgroundColor3 = Color3.fromRGB(40,40,40)
searchBox.TextColor3 = Color3.fromRGB(200,200,200)
searchBox.Font = Enum.Font.Gotham
searchBox.TextSize = 14
searchBox.ClearTextOnFocus = false
searchBox.Parent = mainFrame
local sbCorner = Instance.new("UICorner")
sbCorner.CornerRadius = UDim.new(0,6)
sbCorner.Parent = searchBox

local scroll = Instance.new("ScrollingFrame")
scroll.Size = UDim2.new(1,-20,1,-70)
scroll.Position = UDim2.new(0,10,0,65)
scroll.BackgroundTransparency = 1
scroll.ScrollBarThickness = 6
scroll.Parent = mainFrame

local listLayout = Instance.new("UIListLayout")
listLayout.Padding = UDim.new(0,4)
listLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
listLayout.SortOrder = Enum.SortOrder.LayoutOrder
listLayout.Parent = scroll

local logged = {}

local function addAnim(animName, animId)
    if logged[animId] then return end
    logged[animId] = true
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0.95,0,0,28)
    frame.BackgroundColor3 = Color3.fromRGB(50,50,50)
    frame.Parent = scroll
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0,6)
    corner.Parent = frame
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0.5,0,1,0)
    label.Position = UDim2.new(0,5,0,0)
    label.BackgroundTransparency = 1
    label.Text = animName
    label.TextColor3 = Color3.fromRGB(200,200,200)
    label.Font = Enum.Font.Gotham
    label.TextSize = 14
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame
    local copyBtn = Instance.new("TextButton")
    copyBtn.Size = UDim2.new(0.25,0,1,0)
    copyBtn.Position = UDim2.new(0.5,0,0,0)
    copyBtn.Text = "Copy ID"
    copyBtn.Font = Enum.Font.GothamBold
    copyBtn.TextSize = 14
    copyBtn.TextColor3 = Color3.fromRGB(0,255,255)
    copyBtn.BackgroundColor3 = Color3.fromRGB(35,35,35)
    copyBtn.Parent = frame
    local cbCorner = Instance.new("UICorner")
    cbCorner.CornerRadius = UDim.new(0,6)
    cbCorner.Parent = copyBtn
    copyBtn.MouseButton1Click:Connect(function()
        setclipboard(animId)
    end)
    local playBtn = Instance.new("TextButton")
    playBtn.Size = UDim2.new(0.25,0,1,0)
    playBtn.Position = UDim2.new(0.75,0,0,0)
    playBtn.Text = "Play"
    playBtn.Font = Enum.Font.GothamBold
    playBtn.TextSize = 14
    playBtn.TextColor3 = Color3.fromRGB(0,255,255)
    playBtn.BackgroundColor3 = Color3.fromRGB(35,35,35)
    playBtn.Parent = frame
    local pbCorner = Instance.new("UICorner")
    pbCorner.CornerRadius = UDim.new(0,6)
    pbCorner.Parent = playBtn
    playBtn.MouseButton1Click:Connect(function()
        local humanoid = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            local anim = Instance.new("Animation")
            anim.AnimationId = animId
            local track = humanoid:LoadAnimation(anim)
            track:Play()
        end
    end)
    scroll.CanvasSize = UDim2.new(0,0,0,listLayout.AbsoluteContentSize.Y + 10)
end

local function fetchPlayerAnims(p)
    local containers = {}
    if p.Character then table.insert(containers,p.Character) end
    table.insert(containers,workspace)
    table.insert(containers,game:GetService("ReplicatedStorage"))
    table.insert(containers,game:GetService("StarterPlayer"))
    for _,c in pairs(containers) do
        for _,obj in pairs(c:GetDescendants()) do
            if obj:IsA("Animation") then
                addAnim(obj.Name,obj.AnimationId)
            end
        end
    end
end

for _,p in pairs(Players:GetPlayers()) do
    fetchPlayerAnims(p)
end
Players.PlayerAdded:Connect(fetchPlayerAnims)

searchBox:GetPropertyChangedSignal("Text"):Connect(function()
    local text = searchBox.Text:lower()
    for _,child in pairs(scroll:GetChildren()) do
        if child:IsA("Frame") then
            local lbl = child:FindFirstChildOfClass("TextLabel")
            if lbl then
                child.Visible = lbl.Text:lower():find(text) ~= nil
            end
        end
    end
end)

print("[Animation Logger] Ready with Play Button!")
