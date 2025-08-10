-- LucentUI.lua
-- Modern glassmorphic Roblox UI library with tabs, textbox, dropdown, button, animations

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local LucentUI = {}
LucentUI.__index = LucentUI

local function createRoundedFrame(parent, size, position, bgColor, transparency)
    local frame = Instance.new("Frame")
    frame.Size = size
    frame.Position = position or UDim2.new(0,0,0,0)
    frame.BackgroundColor3 = bgColor or Color3.fromRGB(30, 30, 40)
    frame.BackgroundTransparency = transparency or 0.3
    frame.BorderSizePixel = 0
    frame.Parent = parent

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 18)
    corner.Parent = frame

    return frame
end

local function tween(obj, props, time)
    time = time or 0.3
    local tweenInfo = TweenInfo.new(time, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local tw = TweenService:Create(obj, tweenInfo, props)
    tw:Play()
    return tw
end

local function createButton(parent, text)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 40)
    btn.BackgroundColor3 = Color3.fromRGB(10, 10, 30)
    btn.BorderSizePixel = 0
    btn.Text = text
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 20
    btn.TextColor3 = Color3.fromRGB(70, 200, 255)
    btn.AutoButtonColor = false
    btn.Parent = parent

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 12)
    corner.Parent = btn

    -- Hover Animations
    btn.MouseEnter:Connect(function()
        tween(btn, {BackgroundColor3 = Color3.fromRGB(20, 60, 100)}, 0.2)
        tween(btn, {TextColor3 = Color3.fromRGB(150, 255, 255)}, 0.2)
    end)
    btn.MouseLeave:Connect(function()
        tween(btn, {BackgroundColor3 = Color3.fromRGB(10, 10, 30)}, 0.2)
        tween(btn, {TextColor3 = Color3.fromRGB(70, 200, 255)}, 0.2)
    end)

    return btn
end

local function createTextbox(parent, placeholder)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 0, 40)
    frame.BackgroundColor3 = Color3.fromRGB(15, 15, 35)
    frame.BorderSizePixel = 0
    frame.Parent = parent

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 14)
    corner.Parent = frame

    local box = Instance.new("TextBox")
    box.Size = UDim2.new(1, -20, 1, -10)
    box.Position = UDim2.new(0, 10, 0, 5)
    box.BackgroundTransparency = 1
    box.PlaceholderText = placeholder or "Enter text..."
    box.TextColor3 = Color3.fromRGB(180, 230, 255)
    box.Font = Enum.Font.GothamSemibold
    box.TextSize = 18
    box.ClearTextOnFocus = false
    box.Parent = frame

    box.Focused:Connect(function()
        tween(frame, {BackgroundColor3 = Color3.fromRGB(30, 50, 90)}, 0.3)
    end)
    box.FocusLost:Connect(function()
        tween(frame, {BackgroundColor3 = Color3.fromRGB(15, 15, 35)}, 0.3)
    end)

    return frame, box
end

local function createDropdown(parent, options, default)
    local dropdown = Instance.new("Frame")
    dropdown.Size = UDim2.new(1, 0, 0, 40)
    dropdown.BackgroundColor3 = Color3.fromRGB(15, 15, 35)
    dropdown.BorderSizePixel = 0
    dropdown.Parent = parent

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 14)
    corner.Parent = dropdown

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -30, 1, 0)
    label.Position = UDim2.new(0, 10, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = default or "Select..."
    label.TextColor3 = Color3.fromRGB(180, 230, 255)
    label.Font = Enum.Font.GothamBold
    label.TextSize = 18
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = dropdown

    local arrow = Instance.new("TextLabel")
    arrow.Size = UDim2.new(0, 20, 1, 0)
    arrow.Position = UDim2.new(1, -25, 0, 0)
    arrow.BackgroundTransparency = 1
    arrow.Text = "▼"
    arrow.TextColor3 = Color3.fromRGB(100, 200, 255)
    arrow.Font = Enum.Font.GothamBold
    arrow.TextSize = 20
    arrow.Parent = dropdown

    local list = Instance.new("ScrollingFrame")
    list.Size = UDim2.new(1, 0, 0, 0)
    list.Position = UDim2.new(0, 0, 1, 5)
    list.BackgroundColor3 = Color3.fromRGB(20, 20, 40)
    list.BorderSizePixel = 0
    list.Visible = false
    list.ScrollBarThickness = 6
    list.Parent = dropdown

    local listCorner = Instance.new("UICorner")
    listCorner.CornerRadius = UDim.new(0, 14)
    listCorner.Parent = list

    for i, option in ipairs(options) do
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1, -20, 0, 30)
        btn.Position = UDim2.new(0, 10, 0, (i-1)*35)
        btn.BackgroundColor3 = Color3.fromRGB(30, 30, 60)
        btn.BorderSizePixel = 0
        btn.Text = option
        btn.TextColor3 = Color3.fromRGB(180, 230, 255)
        btn.Font = Enum.Font.GothamSemibold
        btn.TextSize = 16
        btn.Parent = list

        local btnCorner = Instance.new("UICorner")
        btnCorner.CornerRadius = UDim.new(0, 10)
        btnCorner.Parent = btn

        btn.MouseEnter:Connect(function()
            tween(btn, {BackgroundColor3 = Color3.fromRGB(60, 90, 130)}, 0.2)
        end)
        btn.MouseLeave:Connect(function()
            tween(btn, {BackgroundColor3 = Color3.fromRGB(30, 30, 60)}, 0.2)
        end)

        btn.MouseButton1Click:Connect(function()
            label.Text = btn.Text
            list.Visible = false
        end)
    end

    list.CanvasSize = UDim2.new(0, 0, 0, #options * 35)

    dropdown.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            list.Visible = not list.Visible
            if list.Visible then
                tween(list, {Size = UDim2.new(1, 0, 0, math.min(#options * 35, 140))}, 0.3)
            else
                tween(list, {Size = UDim2.new(1, 0, 0, 0)}, 0.3)
            end
        end
    end)

    return dropdown, label
end

function LucentUI.new()
    local self = setmetatable({}, LucentUI)

    local playerGui = game.Players.LocalPlayer:WaitForChild("PlayerGui")

    self.ScreenGui = Instance.new("ScreenGui")
    self.ScreenGui.Name = "LucentUI"
    self.ScreenGui.ResetOnSpawn = false
    self.ScreenGui.Parent = playerGui

    self.MainFrame = createRoundedFrame(self.ScreenGui, UDim2.new(0, 600, 0, 450), UDim2.new(0.5, -300, 0.5, -225), Color3.fromRGB(12, 12, 22), 0.5)

    self.TabsContainer = createRoundedFrame(self.MainFrame, UDim2.new(0, 140, 1, -40), UDim2.new(0, 10, 0, 20), Color3.fromRGB(20, 20, 40), 0.8)

    local UIStroke = Instance.new("UIStroke")
    UIStroke.Parent = self.TabsContainer
    UIStroke.Color = Color3.fromRGB(60, 150, 255)
    UIStroke.Thickness = 2

    self.ContentContainer = Instance.new("Frame")
    self.ContentContainer.Size = UDim2.new(1, -160, 1, -40)
    self.ContentContainer.Position = UDim2.new(0, 160, 0, 20)
    self.ContentContainer.BackgroundTransparency = 1
    self.ContentContainer.Parent = self.MainFrame

    self.Tabs = {}
    self.TabButtons = {}

    return self
end

function LucentUI:AddTab(name)
    local tabButton = createButton(self.TabsContainer, name)
    tabButton.Position = UDim2.new(0, 0, 0, (#self.TabButtons)*54 + 10)
    tabButton.Parent = self.TabsContainer

    local contentFrame = Instance.new("Frame")
    contentFrame.Size = UDim2.new(1, 0, 1, 0)
    contentFrame.BackgroundTransparency = 1
    contentFrame.Visible = false
    contentFrame.Parent = self.ContentContainer

    local function selectTab()
        for _, btn in pairs(self.TabButtons) do
            tween(btn, {BackgroundColor3 = Color3.fromRGB(10, 10, 30)}, 0.3)
            btn.TextColor3 = Color3.fromRGB(70, 200, 255)
        end

        for _, tab in pairs(self.Tabs) do
            tab.Content.Visible = false
        end

        tween(tabButton, {BackgroundColor3 = Color3.fromRGB(30, 70, 120)}, 0.3)
        tabButton.TextColor3 = Color3.fromRGB(220, 255, 255)

        contentFrame.Visible = true
    end

    tabButton.MouseButton1Click:Connect(selectTab)

    table.insert(self.TabButtons, tabButton)
    table.insert(self.Tabs, {Button = tabButton, Content = contentFrame, Elements = {}})

    if #self.Tabs == 1 then
        selectTab()
    end

    local tabData = self.Tabs[#self.Tabs]

    function tabData:AddTextbox(placeholder, callback)
        local container, textbox = createTextbox(tabData.Content, placeholder)
        container.Position = UDim2.new(0, 10, 0, (#tabData.Elements)*60 + 10)
        container.Parent = tabData.Content

        textbox.FocusLost:Connect(function(enterPressed)
            if enterPressed and callback then
                callback(textbox.Text)
                textbox.Text = ""
            end
        end)

        table.insert(tabData.Elements, container)
        return textbox
    end

    function tabData:AddDropdown(options, defaultText)
        local dropdown, label = createDropdown(tabData.Content, options, defaultText)
        dropdown.Position = UDim2.new(0, 10, 0, (#tabData.Elements)*60 + 10)
        dropdown.Parent = tabData.Content

        table.insert(tabData.Elements, dropdown)
        return dropdown, label
    end

    function tabData:AddButton(text, callback)
        local btn = createButton(tabData.Content, text)
        btn.Position = UDim2.new(0, 10, 0, (#tabData.Elements)*60 + 10)
        btn.Parent = tabData.Content

        btn.MouseButton1Click:Connect(function()
            if callback then callback() end
        end)

        table.insert(tabData.Elements, btn)
        return btn
    end

    return tabData
end

function LucentUI:Show()
    self.ScreenGui.Enabled = true
end

function LucentUI:Hide()
    self.ScreenGui.Enabled = false
end

return LucentUI
