--// LucentHub UI Library
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local LucentHub = {}
LucentHub.Tabs = {}

function LucentHub:CreateHub(options)
    options = options or {}
    local hubTitle = options.Title or "Lucent Hub"
    local hubSize = options.Size or UDim2.new(0, 500, 0, 320)
    
    --// ScreenGui
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "LucentHub"
    screenGui.ResetOnSpawn = false
    screenGui.Parent = playerGui

    --// Main Frame
    local mainFrame = Instance.new("Frame")
    mainFrame.Size = hubSize
    mainFrame.Position = UDim2.new(0.5, -hubSize.X.Offset/2, 0.5, -hubSize.Y.Offset/2)
    mainFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    mainFrame.Parent = screenGui
    Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 20)

    --// Draggable
    local dragging, dragInput, dragStart, startPos
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

    --// Title Frame
    local titleFrame = Instance.new("Frame")
    titleFrame.Size = UDim2.new(1, 0, 0, 40)
    titleFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    titleFrame.Parent = mainFrame
    Instance.new("UICorner", titleFrame).CornerRadius = UDim.new(0, 8)

    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(0.6, 0, 1, 0)
    titleLabel.Position = UDim2.new(0, 10, 0, 0)
    titleLabel.Text = hubTitle
    titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    titleLabel.BackgroundTransparency = 1
    titleLabel.TextScaled = true
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Parent = titleFrame

    --// Close Button moved to top-left
    local closeButton = Instance.new("TextButton")
    closeButton.Size = UDim2.new(0, 40, 0, 30)
    closeButton.Position = UDim2.new(0, 10, 0.5, -15)
    closeButton.Text = "X"
    closeButton.TextScaled = true
    closeButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    closeButton.Parent = titleFrame
    Instance.new("UICorner", closeButton).CornerRadius = UDim.new(0, 8)

    --// Reopen Button
    local reopenButton = Instance.new("TextButton")
    reopenButton.Size = UDim2.new(0, 120, 0, 40)
    reopenButton.Position = UDim2.new(0.5, -60, 0.5, -20)
    reopenButton.BackgroundColor3 = Color3.fromRGB(0, 200, 200)
    reopenButton.Text = "Open Hub"
    reopenButton.TextScaled = true
    reopenButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    reopenButton.Visible = false
    reopenButton.Parent = screenGui
    Instance.new("UICorner", reopenButton).CornerRadius = UDim.new(0, 10)

    closeButton.MouseButton1Click:Connect(function()
        mainFrame.Visible = false
        reopenButton.Visible = true
    end)
    
    reopenButton.MouseButton1Click:Connect(function()
        reopenButton.Visible = false
        mainFrame.Visible = true
    end)

    --// Tab container
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

    --// Navigation buttons
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

    --// Add Tab
    function LucentHub:AddTab(tabName, scriptsList)
        self.Tabs[tabName] = {Scripts = scriptsList, Pages = {}}
        local tabBtn = Instance.new("TextButton")
        tabBtn.Size = UDim2.new(1, -20, 0, 40)
        tabBtn.Position = UDim2.new(0, 10, 0, (#tabFrame:GetChildren()-1)*50)
        tabBtn.Text = tabName
        tabBtn.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
        tabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        tabBtn.TextScaled = true
        tabBtn.Font = Enum.Font.GothamBold
        tabBtn.Parent = tabFrame
        Instance.new("UICorner", tabBtn).CornerRadius = UDim.new(0, 10)

        -- Create pages
        local scriptsPerPage = 6
        local totalPages = math.ceil(#scriptsList / scriptsPerPage)
        for p = 1, totalPages do
            local page = Instance.new("Frame")
            page.Size = UDim2.new(1, 0, 1, 0)
            page.BackgroundTransparency = 1
            page.Visible = false
            page.Parent = pagesContainer

            local startIdx = (p-1)*scriptsPerPage +1
            local endIdx = math.min(p*scriptsPerPage, #scriptsList)
            for i=startIdx,endIdx do
                local btn = Instance.new("TextButton")
                btn.Size = UDim2.new(0,110,0,40)
                btn.Position = UDim2.new(0, ((i-1)%3)*120+10, 0, math.floor((i-1)/3)*50+10)
                btn.Text = scriptsList[i].Name
                btn.Font = Enum.Font.Gotham
                btn.TextScaled = true
                btn.TextColor3 = Color3.fromRGB(255,255,255)
                btn.BackgroundColor3 = Color3.fromRGB(0,180,180)
                btn.Parent = page
                Instance.new("UICorner", btn).CornerRadius = UDim.new(0,8)

                btn.MouseButton1Click:Connect(function()
                    local func, err = loadstring(scriptsList[i].Code)
                    if func then func() else warn("Error:", err) end
                end)
            end

            table.insert(self.Tabs[tabName].Pages, page)
        end
    end

    return screenGui, mainFrame, pageLabel, prevPageBtn, nextPageBtn
end

return LucentHub
