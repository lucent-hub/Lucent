local LucentHub = {}
LucentHub.__index = LucentHub

local Players = game:GetService("Players")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

function LucentHub.new(title, width, height)
    local self = setmetatable({}, LucentHub)
    self.screenGui = Instance.new("ScreenGui")
    self.screenGui.Name = title or "LucentHubGUI"
    self.screenGui.ResetOnSpawn = false
    self.screenGui.Parent = playerGui

    self.mainFrame = Instance.new("Frame")
    self.mainFrame.Size = UDim2.new(0, width or 500, 0, height or 320)
    self.mainFrame.Position = UDim2.new(0.5, -(width or 500)/2, 0.5, -(height or 320)/2)
    self.mainFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    self.mainFrame.Parent = self.screenGui
    Instance.new("UICorner", self.mainFrame).CornerRadius = UDim.new(0, 20)

    self:_createTitleBar(title or "Lucent Hub")
    self.mainTabButtons = {}
    self.tabPages = {}
    self.currentTab = nil
    self.currentPageIndex = 1
    self.scriptsPerPage = 6

    self.mainTabFrame = Instance.new("Frame")
    self.mainTabFrame.Size = UDim2.new(0, 120, 0, 220)
    self.mainTabFrame.Position = UDim2.new(0, 5, 0.5, -110)
    self.mainTabFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    self.mainTabFrame.Parent = self.mainFrame
    Instance.new("UICorner", self.mainTabFrame).CornerRadius = UDim.new(0, 12)

    self:_createPageNavigation()

    self.pagesContainer = Instance.new("Frame")
    self.pagesContainer.Size = UDim2.new(1, -140, 1, -110)
    self.pagesContainer.Position = UDim2.new(0, 130, 0, 50)
    self.pagesContainer.BackgroundTransparency = 1
    self.pagesContainer.Parent = self.mainFrame

    return self
end

function LucentHub:_createTitleBar(title)
    local titleFrame = Instance.new("Frame")
    titleFrame.Size = UDim2.new(1, 0, 0, 40)
    titleFrame.BackgroundTransparency = 1
    titleFrame.Parent = self.mainFrame

    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(0.8, 0, 1, 0)
    titleLabel.Position = UDim2.new(0, 10, 0, 0)
    titleLabel.Text = title
    titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    titleLabel.BackgroundTransparency = 1
    titleLabel.TextScaled = true
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Parent = titleFrame

    local closeButton = Instance.new("TextButton")
    closeButton.Size = UDim2.new(0.15, -10, 1, -5)
    closeButton.Position = UDim2.new(0.85, 0, 0, 5)
    closeButton.Text = "X"
    closeButton.TextScaled = true
    closeButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    closeButton.Parent = titleFrame
    Instance.new("UICorner", closeButton).CornerRadius = UDim.new(0, 8)
    closeButton.MouseButton1Click:Connect(function()
        self.screenGui.Enabled = false
    end)
end

function LucentHub:_createPageNavigation()
    local navFrame = Instance.new("Frame")
    navFrame.Size = UDim2.new(0, 160, 0, 40)
    navFrame.Position = UDim2.new(1, -170, 1, -50)
    navFrame.BackgroundTransparency = 1
    navFrame.Parent = self.mainFrame
    self.navFrame = navFrame

    self.prevPageBtn = Instance.new("TextButton")
    self.prevPageBtn.Size = UDim2.new(0, 40, 1, 0)
    self.prevPageBtn.Text = "<"
    self.prevPageBtn.TextScaled = true
    self.prevPageBtn.Font = Enum.Font.GothamBold
    self.prevPageBtn.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
    self.prevPageBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    self.prevPageBtn.Parent = navFrame
    Instance.new("UICorner", self.prevPageBtn).CornerRadius = UDim.new(0, 10)

    self.pageLabel = Instance.new("TextLabel")
    self.pageLabel.Size = UDim2.new(0, 80, 1, 0)
    self.pageLabel.Position = UDim2.new(0, 40, 0, 0)
    self.pageLabel.Text = "Page 1"
    self.pageLabel.TextScaled = true
    self.pageLabel.Font = Enum.Font.GothamBold
    self.pageLabel.BackgroundTransparency = 1
    self.pageLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    self.pageLabel.Parent = navFrame

    self.nextPageBtn = Instance.new("TextButton")
    self.nextPageBtn.Size = UDim2.new(0, 40, 1, 0)
    self.nextPageBtn.Position = UDim2.new(0, 120, 0, 0)
    self.nextPageBtn.Text = ">"
    self.nextPageBtn.TextScaled = true
    self.nextPageBtn.Font = Enum.Font.GothamBold
    self.nextPageBtn.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
    self.nextPageBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    self.nextPageBtn.Parent = navFrame
    Instance.new("UICorner", self.nextPageBtn).CornerRadius = UDim.new(0, 10)

    self.prevPageBtn.MouseButton1Click:Connect(function() self:ChangePage(-1) end)
    self.nextPageBtn.MouseButton1Click:Connect(function() self:ChangePage(1) end)
end

function LucentHub:ChangePage(delta)
    if not self.currentTab then return end
    local pages = self.tabPages[self.currentTab]
    if not pages then return end
    pages[self.currentPageIndex].Visible = false
    self.currentPageIndex = self.currentPageIndex + delta
    if self.currentPageIndex < 1 then self.currentPageIndex = #pages end
    if self.currentPageIndex > #pages then self.currentPageIndex = 1 end
    pages[self.currentPageIndex].Visible = true
    self.pageLabel.Text = "Page " .. self.currentPageIndex
end

function LucentHub:AddTab(tabName, scripts)
    local tabBtn = Instance.new("TextButton")
    tabBtn.Size = UDim2.new(1, -20, 0, 40)
    tabBtn.Position = UDim2.new(0, 10, 0, (#self.mainTabButtons * 50) + 10)
    tabBtn.Text = tabName
    tabBtn.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
    tabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    tabBtn.TextScaled = true
    tabBtn.Font = Enum.Font.GothamBold
    tabBtn.Parent = self.mainTabFrame
    Instance.new("UICorner", tabBtn).CornerRadius = UDim.new(0, 10)

    self.mainTabButtons[tabName] = tabBtn
    self.tabPages[tabName] = {}
    local totalPages = math.ceil(#scripts / self.scriptsPerPage)

    for p = 1, totalPages do
        local page = Instance.new("Frame")
        page.Size = UDim2.new(1, 0, 1, 0)
        page.BackgroundTransparency = 1
        page.Visible = false
        page.Parent = self.pagesContainer

        local startIdx = (p - 1) * self.scriptsPerPage + 1
        local endIdx = math.min(p * self.scriptsPerPage, #scripts)

        for i = startIdx, endIdx do
            local scriptData = scripts[i]
            local btn = Instance.new("TextButton")
            btn.Size = UDim2.new(0, 110, 0, 40)
            btn.Text = scriptData.Name
            btn.TextScaled = true
            btn.Font = Enum.Font.Gotham
            btn.TextColor3 = Color3.fromRGB(255, 255, 255)
            btn.BackgroundColor3 = Color3.fromRGB(100, 100, 200)
            btn.Parent = page
            Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)

            btn.MouseButton1Click:Connect(function()
                local func, err = loadstring(scriptData.Code)
                if func then func() else warn("Error:", err) end
            end)
        end

        for i, btn in ipairs(page:GetChildren()) do
            if btn:IsA("TextButton") then
                local row = math.floor((i - 1) / 3)
                local col = (i - 1) % 3
                btn.Position = UDim2.new(0, col * 120, 0, row * 50)
            end
        end

        table.insert(self.tabPages[tabName], page)
    end

    tabBtn.MouseButton1Click:Connect(function()
        self.currentTab = tabName
        self.currentPageIndex = 1
        self:HideAllPages()
        self.tabPages[tabName][self.currentPageIndex].Visible = true
        self.pageLabel.Text = "Page " .. self.currentPageIndex
    end)
end

function LucentHub:HideAllPages()
    for _, pages in pairs(self.tabPages) do
        for _, page in ipairs(pages) do
            page.Visible = false
        end
    end
end

function LucentHub:SelectFirstTab()
    local firstTab = next(self.mainTabButtons)
    if firstTab then
        self.currentTab = firstTab
        self.currentPageIndex = 1
        self:HideAllPages()
        self.tabPages[firstTab][self.currentPageIndex].Visible = true
        self.pageLabel.Text = "Page " .. self.currentPageIndex
    end
end

return LucentHub
