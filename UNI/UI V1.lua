local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "LucentHub"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 500, 0, 320)
mainFrame.Position = UDim2.new(0.5, -250, 0.5, -160)
mainFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
mainFrame.Parent = screenGui
Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 20)

-- Make main frame draggable
local dragging = false
local dragInput, dragStart, startPos

local function update(input)
    local delta = input.Position - dragStart
    mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

mainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = mainFrame.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

mainFrame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        update(input)
    end
end)

local titleFrame = Instance.new("Frame")
titleFrame.Size = UDim2.new(1, 0, 0, 40)
titleFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
titleFrame.Parent = mainFrame
Instance.new("UICorner", titleFrame).CornerRadius = UDim.new(0, 8)

local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(0.6, 0, 1, 0)
titleLabel.Position = UDim2.new(0, 10, 0, 0)
titleLabel.Text = "Lucent Hub"
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.BackgroundTransparency = 1
titleLabel.TextScaled = true
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.Parent = titleFrame

local closeButton = Instance.new("TextButton")
closeButton.Size = UDim2.new(0, 40, 0, 30)
closeButton.Position = UDim2.new(0.9, -45, 0.5, -15)
closeButton.Text = "X"
closeButton.TextScaled = true
closeButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeButton.Parent = titleFrame
Instance.new("UICorner", closeButton).CornerRadius = UDim.new(0, 8)

-- Reopen button positioned in the middle of the screen with cyan color
local reopenButton = Instance.new("TextButton")
reopenButton.Size = UDim2.new(0, 120, 0, 40)
reopenButton.Position = UDim2.new(0.5, -60, 0.5, -20)
reopenButton.BackgroundColor3 = Color3.fromRGB(0, 200, 200) -- Cyan
reopenButton.Text = "Open Hub"
reopenButton.TextScaled = true
reopenButton.TextColor3 = Color3.fromRGB(255, 255, 255)
reopenButton.Visible = false
reopenButton.Parent = screenGui
Instance.new("UICorner", reopenButton).CornerRadius = UDim.new(0, 10)

-- Make reopen button draggable
local reopenDragging = false
local reopenDragInput, reopenDragStart, reopenStartPos

local function updateReopen(input)
    local delta = input.Position - reopenDragStart
    reopenButton.Position = UDim2.new(reopenStartPos.X.Scale, reopenStartPos.X.Offset + delta.X, reopenStartPos.Y.Scale, reopenStartPos.Y.Offset + delta.Y)
end

reopenButton.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        reopenDragging = true
        reopenDragStart = input.Position
        reopenStartPos = reopenButton.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                reopenDragging = false
            end
        end)
    end
end)

reopenButton.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        reopenDragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == reopenDragInput and reopenDragging then
        updateReopen(input)
    end
end)

local tabFrame = Instance.new("Frame")
tabFrame.Size = UDim2.new(0, 120, 1, -50)
tabFrame.Position = UDim2.new(0, 5, 0, 45)
tabFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
tabFrame.Parent = mainFrame
Instance.new("UICorner", tabFrame).CornerRadius = UDim.new(0, 12)

local pagesContainer = Instance.new("Frame")
pagesContainer.Size = UDim2.new(1, -140, 1, -110)
pagesContainer.Position = UDim2.new(0, 130, 0, 50)
pagesContainer.BackgroundTransparency = 1
pagesContainer.ClipsDescendants = true
pagesContainer.Parent = mainFrame

local tabs = {
    Scripts = {
        {Name = "Fly Script", Code = "print('fly')"},
        {Name = "ESP Script", Code = "print('esp')"},
        {Name = "Speed Script", Code = "print('speed')"},
        {Name = "Jump Script", Code = "print('jump')"},
        {Name = "God Script", Code = "print('god')"},
        {Name = "Aim Script", Code = "print('aim')"},
        {Name = "Extra Script", Code = "print('extra')"},
    },
    Tools = {
        {Name = "Invisibility", Code = "print('invis')"},
        {Name = "Godmode", Code = "print('god')"},
        {Name = "Noclip", Code = "print('noclip')"},
    }
}

local tabButtons = {}
local tabPages = {}
local currentTab = nil
local currentPageIndex = 1
local scriptsPerPage = 6

local navFrame = Instance.new("Frame")
navFrame.Size = UDim2.new(0, 160, 0, 40)
navFrame.Position = UDim2.new(1, -170, 1, -50)
navFrame.BackgroundTransparency = 1
navFrame.Parent = mainFrame

local prevPageBtn = Instance.new("TextButton")
prevPageBtn.Size = UDim2.new(0, 40, 1, 0)
prevPageBtn.Text = "<"
prevPageBtn.TextScaled = true
prevPageBtn.Font = Enum.Font.GothamBold
prevPageBtn.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
prevPageBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
prevPageBtn.Parent = navFrame
Instance.new("UICorner", prevPageBtn).CornerRadius = UDim.new(0, 10)

local pageLabel = Instance.new("TextLabel")
pageLabel.Size = UDim2.new(0, 80, 1, 0)
pageLabel.Position = UDim2.new(0, 40, 0, 0)
pageLabel.Text = "Page 1"
pageLabel.TextScaled = true
pageLabel.Font = Enum.Font.GothamBold
pageLabel.BackgroundTransparency = 1
pageLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
pageLabel.Parent = navFrame

local nextPageBtn = Instance.new("TextButton")
nextPageBtn.Size = UDim2.new(0, 40, 1, 0)
nextPageBtn.Position = UDim2.new(0, 120, 0, 0)
nextPageBtn.Text = ">"
nextPageBtn.TextScaled = true
nextPageBtn.Font = Enum.Font.GothamBold
nextPageBtn.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
nextPageBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
nextPageBtn.Parent = navFrame
Instance.new("UICorner", nextPageBtn).CornerRadius = UDim.new(0, 10)

-- Tween functions
local function tweenIn(object)
    object.Visible = true
    object.Position = UDim2.new(0.5, 0, 1.5, 0)
    
    local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local tween = TweenService:Create(object, tweenInfo, {Position = UDim2.new(0.5, -250, 0.5, -160)})
    tween:Play()
end

local function tweenOut(object, callback)
    local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local tween = TweenService:Create(object, tweenInfo, {Position = UDim2.new(0.5, 0, 1.5, 0)})
    
    tween.Completed:Connect(function()
        object.Visible = false
        if callback then callback() end
    end)
    tween:Play()
end

-- Page transition animations
local function tweenPageIn(page)
    page.Visible = true
    page.Position = UDim2.new(1, 0, 0, 0)
    
    local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local tween = TweenService:Create(page, tweenInfo, {Position = UDim2.new(0, 0, 0, 0)})
    tween:Play()
end

local function tweenPageOut(page, callback)
    local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local tween = TweenService:Create(page, tweenInfo, {Position = UDim2.new(-1, 0, 0, 0)})
    
    tween.Completed:Connect(function()
        page.Visible = false
        if callback then callback() end
    end)
    tween:Play()
end

-- Tab button animations
local function tweenTabHighlight(button)
    local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local tween = TweenService:Create(button, tweenInfo, {BackgroundColor3 = Color3.fromRGB(0, 180, 180)}) -- Cyan highlight
    tween:Play()
end

local function tweenTabUnhighlight(button)
    local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local tween = TweenService:Create(button, tweenInfo, {BackgroundColor3 = Color3.fromRGB(80, 80, 80)})
    tween:Play()
end

local function hideAllPages()
    for _, pages in pairs(tabPages) do
        for _, page in ipairs(pages) do
            page.Visible = false
        end
    end
end

local function layoutPageButtons(page)
    local buttons = {}
    for _, child in ipairs(page:GetChildren()) do
        if child:IsA("TextButton") then
            table.insert(buttons, child)
        end
    end
    
    for i, btn in ipairs(buttons) do
        local row = math.floor((i - 1) / 3)
        local col = (i - 1) % 3
        btn.Position = UDim2.new(0, col * 120 + 10, 0, row * 50 + 10)
        btn.Size = UDim2.new(0, 110, 0, 40)
    end
end

local tabIndex = 0
for tabName, scripts in pairs(tabs) do
    local tabBtn = Instance.new("TextButton")
    tabBtn.Size = UDim2.new(1, -20, 0, 40)
    tabBtn.Position = UDim2.new(0, 10, 0, (tabIndex * 50) + 10)
    tabBtn.Text = tabName
    tabBtn.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
    tabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    tabBtn.TextScaled = true
    tabBtn.Font = Enum.Font.GothamBold
    tabBtn.Parent = tabFrame
    Instance.new("UICorner", tabBtn).CornerRadius = UDim.new(0, 10)
    
    tabButtons[tabName] = tabBtn

    tabPages[tabName] = {}
    local totalPages = math.ceil(#scripts / scriptsPerPage)

    for p = 1, totalPages do
        local page = Instance.new("Frame")
        page.Size = UDim2.new(1, 0, 1, 0)
        page.BackgroundTransparency = 1
        page.Visible = false
        page.Parent = pagesContainer

        local startIdx = (p - 1) * scriptsPerPage + 1
        local endIdx = math.min(p * scriptsPerPage, #scripts)

        for i = startIdx, endIdx do
            local scriptData = scripts[i]
            local btn = Instance.new("TextButton")
            btn.Size = UDim2.new(0, 110, 0, 40)
            btn.Text = scriptData.Name
            btn.TextScaled = true
            btn.Font = Enum.Font.Gotham
            btn.TextColor3 = Color3.fromRGB(255, 255, 255)
            btn.BackgroundColor3 = Color3.fromRGB(0, 180, 180) -- Cyan
            btn.Parent = page
            Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)

            -- Button hover animation
            btn.MouseEnter:Connect(function()
                local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
                local tween = TweenService:Create(btn, tweenInfo, {BackgroundColor3 = Color3.fromRGB(0, 220, 220)}) -- Lighter cyan
                tween:Play()
            end)
            
            btn.MouseLeave:Connect(function()
                local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
                local tween = TweenService:Create(btn, tweenInfo, {BackgroundColor3 = Color3.fromRGB(0, 180, 180)}) -- Cyan
                tween:Play()
            end)

            btn.MouseButton1Click:Connect(function()
                local func, err = loadstring(scriptData.Code)
                if func then func() else warn("Error:", err) end
            end)
        end

        layoutPageButtons(page)
        table.insert(tabPages[tabName], page)
    end

    tabBtn.MouseButton1Click:Connect(function()
        if currentTab == tabName then return end
        
        -- Reset all tab button colors with animation
        for name, btn in pairs(tabButtons) do
            if name ~= tabName then
                tweenTabUnhighlight(btn)
            end
        end
        
        -- Highlight current tab with animation
        tweenTabHighlight(tabBtn)
        
        -- Animate page transition
        if currentTab then
            local currentPage = tabPages[currentTab][currentPageIndex]
            tweenPageOut(currentPage, function()
                currentTab = tabName
                currentPageIndex = 1
                hideAllPages()
                pageLabel.Text = "Page " .. currentPageIndex
                tweenPageIn(tabPages[currentTab][currentPageIndex])
            end)
        else
            currentTab = tabName
            currentPageIndex = 1
            hideAllPages()
            pageLabel.Text = "Page " .. currentPageIndex
            tweenPageIn(tabPages[currentTab][currentPageIndex])
        end
    end)
    
    tabIndex = tabIndex + 1
end

prevPageBtn.MouseButton1Click:Connect(function()
    if not currentTab then return end
    
    local pages = tabPages[currentTab]
    if #pages <= 1 then return end
    
    local currentPage = pages[currentPageIndex]
    tweenPageOut(currentPage, function()
        currentPageIndex = currentPageIndex - 1
        if currentPageIndex < 1 then currentPageIndex = #pages end
        
        pageLabel.Text = "Page " .. currentPageIndex
        tweenPageIn(pages[currentPageIndex])
    end)
end)

nextPageBtn.MouseButton1Click:Connect(function()
    if not currentTab then return end
    
    local pages = tabPages[currentTab]
    if #pages <= 1 then return end
    
    local currentPage = pages[currentPageIndex]
    tweenPageOut(currentPage, function()
        currentPageIndex = currentPageIndex + 1
        if currentPageIndex > #pages then currentPageIndex = 1 end
        
        pageLabel.Text = "Page " .. currentPageIndex
        tweenPageIn(pages[currentPageIndex])
    end)
end)

closeButton.MouseButton1Click:Connect(function()
    tweenOut(mainFrame, function()
        reopenButton.Visible = true
    end)
end)

reopenButton.MouseButton1Click:Connect(function()
    reopenButton.Visible = false
    tweenIn(mainFrame)
end)

-- Auto select first tab
local firstTab = next(tabButtons)
if firstTab then
    tabButtons[firstTab]:MouseButton1Click()
end
