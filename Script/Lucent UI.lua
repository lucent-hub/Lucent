-- LucentUI executor version - full polished, draggable (PC+mobile), minimize, scrollable, dropdown, icons

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local LucentUI = {}
LucentUI.__index = LucentUI

-- Utils

local function createRoundedFrame(parent, size, position, bgColor, transparency)
    local frame = Instance.new("Frame")
    frame.Size = size
    frame.Position = position or UDim2.new(0,0,0,0)
    frame.BackgroundColor3 = bgColor or Color3.fromRGB(15,40,85)
    frame.BackgroundTransparency = transparency or 0.4
    frame.BorderSizePixel = 0
    frame.Parent = parent

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0,16)
    corner.Parent = frame

    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(90,170,255)
    stroke.Thickness = 2
    stroke.Parent = frame

    return frame
end

local function tween(obj, props, time)
    local tweenInfo = TweenInfo.new(time or 0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local tw = TweenService:Create(obj, tweenInfo, props)
    tw:Play()
    return tw
end

local function makeDraggable(frame, dragArea)
    dragArea = dragArea or frame

    local dragging
    local dragInput
    local dragStart
    local startPos

    local UIS = UserInputService

    local function update(input)
        local delta = input.Position - dragStart
        frame.Position = UDim2.new(
            math.clamp(startPos.X.Scale, 0, 1),
            math.clamp(startPos.X.Offset + delta.X, 0, workspace.CurrentCamera.ViewportSize.X - frame.AbsoluteSize.X),
            math.clamp(startPos.Y.Scale, 0, 1),
            math.clamp(startPos.Y.Offset + delta.Y, 0, workspace.CurrentCamera.ViewportSize.Y - frame.AbsoluteSize.Y)
        )
    end

    dragArea.InputBegan:Connect(function(input)
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

    dragArea.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)

    UIS.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            update(input)
        end
    end)
end

local function createButton(parent, text, iconId)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 36)
    btn.BackgroundColor3 = Color3.fromRGB(20, 60, 120)
    btn.BorderSizePixel = 0
    btn.Text = text
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 18
    btn.TextColor3 = Color3.fromRGB(180, 230, 255)
    btn.AutoButtonColor = false
    btn.Parent = parent

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 12)
    corner.Parent = btn

    if iconId then
        local icon = Instance.new("ImageLabel")
        icon.Size = UDim2.new(0,24,0,24)
        icon.Position = UDim2.new(0,6,0.5,-12)
        icon.BackgroundTransparency = 1
        icon.Image = iconId
        icon.Parent = btn
        btn.TextXAlignment = Enum.TextXAlignment.Left
        btn.TextColor3 = Color3.fromRGB(210, 240, 255)
        btn.TextStrokeTransparency = 0.8
        btn.Text = "  " .. text
    end

    btn.MouseEnter:Connect(function()
        tween(btn, {BackgroundColor3 = Color3.fromRGB(40, 100, 180)}, 0.15)
        tween(btn, {TextColor3 = Color3.fromRGB(220, 255, 255)}, 0.15)
    end)
    btn.MouseLeave:Connect(function()
        tween(btn, {BackgroundColor3 = Color3.fromRGB(20, 60, 120)}, 0.15)
        tween(btn, {TextColor3 = Color3.fromRGB(180, 230, 255)}, 0.15)
    end)

    return btn
end

local function createTextbox(parent, placeholder)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 0, 36)
    frame.BackgroundColor3 = Color3.fromRGB(18, 45, 90)
    frame.BorderSizePixel = 0
    frame.Parent = parent

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 12)
    corner.Parent = frame

    local box = Instance.new("TextBox")
    box.Size = UDim2.new(1, -16, 1, -8)
    box.Position = UDim2.new(0, 8, 0, 4)
    box.BackgroundTransparency = 1
    box.PlaceholderText = placeholder or "Enter text..."
    box.TextColor3 = Color3.fromRGB(200, 240, 255)
    box.Font = Enum.Font.GothamSemibold
    box.TextSize = 16
    box.ClearTextOnFocus = false
    box.Parent = frame

    box.Focused:Connect(function()
        tween(frame, {BackgroundColor3 = Color3.fromRGB(40, 80, 140)}, 0.3)
    end)
    box.FocusLost:Connect(function()
        tween(frame, {BackgroundColor3 = Color3.fromRGB(18, 45, 90)}, 0.3)
    end)

    return frame, box
end

local function createDropdown(parent, options, default)
    local dropdown = Instance.new("Frame")
    dropdown.Size = UDim2.new(1, 0, 0, 36)
    dropdown.BackgroundColor3 = Color3.fromRGB(18, 45, 90)
    dropdown.BorderSizePixel = 0
    dropdown.ClipsDescendants = true
    dropdown.Parent = parent

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 12)
    corner.Parent = dropdown

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -30, 1, 0)
    label.Position = UDim2.new(0, 10, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = default or "Select..."
    label.TextColor3 = Color3.fromRGB(190, 230, 255)
    label.Font = Enum.Font.GothamBold
    label.TextSize = 16
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = dropdown

    local arrow = Instance.new("TextLabel")
    arrow.Size = UDim2.new(0, 20, 1, 0)
    arrow.Position = UDim2.new(1, -25, 0, 0)
    arrow.BackgroundTransparency = 1
    arrow.Text = "▼"
    arrow.TextColor3 = Color3.fromRGB(110, 210, 255)
    arrow.Font = Enum.Font.GothamBold
    arrow.TextSize = 18
    arrow.Parent = dropdown

    local list = Instance.new("ScrollingFrame")
    list.Size = UDim2.new(1, 0, 0, 0)
    list.Position = UDim2.new(0, 0, 1, 4)
    list.BackgroundColor3 = Color3.fromRGB(25, 60, 110)
    list.BorderSizePixel = 0
    list.Visible = false
    list.ScrollBarThickness = 5
    list.Parent = dropdown

    local listCorner = Instance.new("UICorner")
    listCorner.CornerRadius = UDim.new(0, 12)
    listCorner.Parent = list

    for i, option in ipairs(options) do
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1, -16, 0, 30)
        btn.Position = UDim2.new(0, 8, 0, (i-1)*32)
        btn.BackgroundColor3 = Color3.fromRGB(35, 75, 135)
        btn.BorderSizePixel = 0
        btn.Text = option
        btn.TextColor3 = Color3.fromRGB(190, 230, 255)
        btn.Font = Enum.Font.GothamSemibold
        btn.TextSize = 14
        btn.Parent = list

        local btnCorner = Instance.new("UICorner")
        btnCorner.CornerRadius = UDim.new(0, 10)
        btnCorner.Parent = btn

        btn.MouseEnter:Connect(function()
            tween(btn, {BackgroundColor3 = Color3.fromRGB(55, 110, 185)}, 0.2)
        end)
        btn.MouseLeave:Connect(function()
            tween(btn, {BackgroundColor3 = Color3.fromRGB(35, 75, 135)}, 0.2)
        end)

        btn.MouseButton1Click:Connect(function()
            label.Text = btn.Text
            list.Visible = false
            tween(list, {Size = UDim2.new(1, 0, 0, 0)}, 0.25)
        end)
    end

    list.CanvasSize = UDim2.new(0, 0, 0, #options * 32)

    dropdown.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            list.Visible = not list.Visible
            if list.Visible then
                tween(list, {Size = UDim2.new(1, 0, 0, math.min(#options * 32, 120))}, 0.25)
            else
                tween(list, {Size = UDim2.new(1, 0, 0, 0)}, 0.25)
            end
        end
    end)

    return dropdown, label
end

function LucentUI.new()
    local self = setmetatable({}, LucentUI)

    -- ScreenGui
    self.ScreenGui = Instance.new("ScreenGui")
    self.ScreenGui.Name = "LucentUI"
    self.ScreenGui.ResetOnSpawn = false
    self.ScreenGui.Parent = game:GetService("CoreGui")

    -- Main Frame
    self.MainFrame = createRoundedFrame(self.ScreenGui, UDim2.new(0, 380, 0, 460), UDim2.new(0.5, -190, 0.5, -230), Color3.fromRGB(15, 40, 85), 0.5)

    -- Title bar
    self.TitleBar = Instance.new("Frame")
    self.TitleBar.Size = UDim2.new(1, 0, 0, 44)
    self.TitleBar.BackgroundColor3 = Color3.fromRGB(25, 70, 140)
    self.TitleBar.BorderSizePixel = 0
    self.TitleBar.Parent = self.MainFrame

    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1, -50, 1, 0)
    titleLabel.Position = UDim2.new(0, 10, 0, 0)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = "Lucent UI"
    titleLabel.TextColor3 = Color3.fromRGB(220, 240, 255)
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextSize = 24
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Parent = self.TitleBar

    -- Minimize button
    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.new(0, 40, 1, 0)
    closeBtn.Position = UDim2.new(1, -44, 0, 0)
    closeBtn.BackgroundColor3 = Color3.fromRGB(180, 50, 50)
    closeBtn.BorderSizePixel = 0
    closeBtn.Text = "✕"
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    closeBtn.TextSize = 28
    closeBtn.Parent = self.TitleBar
    closeBtn.AutoButtonColor = false

    closeBtn.MouseEnter:Connect(function()
        tween(closeBtn, {BackgroundColor3 = Color3.fromRGB(230, 70, 70)}, 0.2)
    end)
    closeBtn.MouseLeave:Connect(function()
        tween(closeBtn, {BackgroundColor3 = Color3.fromRGB(180, 50, 50)}, 0.2)
    end)
    closeBtn.MouseButton1Click:Connect(function()
        self.ScreenGui.Enabled = not self.ScreenGui.Enabled
    end)

    -- Tabs container (left side)
    self.TabsContainer = createRoundedFrame(self.MainFrame, UDim2.new(0, 120, 1, -56), UDim2.new(0, 10, 0, 52), Color3.fromRGB(20, 45, 90), 0.85)

    local tabsStroke = Instance.new("UIStroke")
    tabsStroke.Parent = self.TabsContainer
    tabsStroke.Color = Color3.fromRGB(85, 160, 255)
    tabsStroke.Thickness = 2

    -- Content container (right side, scrollable)
    self.ContentContainer = Instance.new("ScrollingFrame")
    self.ContentContainer.Size = UDim2.new(1, -150, 1, -56)
    self.ContentContainer.Position = UDim2.new(0, 140, 0, 52)
    self.ContentContainer.BackgroundTransparency = 1
    self.ContentContainer.ScrollBarThickness = 6
    self.ContentContainer.VerticalScrollBarInset = Enum.ScrollBarInset.Always
    self.ContentContainer.CanvasSize = UDim2.new(0, 0, 0, 0)
    self.ContentContainer.Parent = self.MainFrame
    self.ContentContainer.AutomaticCanvasSize = Enum.AutomaticSize.Y

    self.Tabs = {}
    self.TabButtons = {}

    -- Make main frame draggable by title bar
    makeDraggable(self.MainFrame, self.TitleBar)

    return self
end

function LucentUI:AddTab(name, iconId)
    local tabButton = createButton(self.TabsContainer, name, iconId)
    tabButton.Size = UDim2.new(1, -10, 0, 44)
    tabButton.Position = UDim2.new(0, 5, 0, (#self.TabButtons)*54 + 10)
    tabButton.Parent = self.TabsContainer

    local contentFrame = Instance.new("Frame")
    contentFrame.Size = UDim2.new(1, -10, 0, 0)
    contentFrame.Position = UDim2.new(0, 10, 0, 10)
    contentFrame.BackgroundTransparency = 1
    contentFrame.Parent = self.ContentContainer

    local layout = Instance.new("UIListLayout")
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Padding = UDim.new(0, 14)
    layout.Parent = contentFrame

    local function updateCanvas()
        local contentSize = layout.AbsoluteContentSize
        contentFrame.Size = UDim2.new(1, -20, 0, contentSize.Y)
        self.ContentContainer.CanvasSize = UDim2.new(0, 0, 0, contentSize.Y + 20)
    end

    layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(updateCanvas)

    contentFrame.Visible = false

    local function selectTab()
        for _, btn in pairs(self.TabButtons) do
            tween(btn, {BackgroundColor3 = Color3.fromRGB(20, 60, 110)}, 0.3)
            btn.TextColor3 = Color3.fromRGB(180, 230, 255)
        end
        for _, tab in pairs(self.Tabs) do
            tab.Content.Visible = false
        end

        tween(tabButton, {BackgroundColor3 = Color3.fromRGB(40, 110, 200)}, 0.3)
        tabButton.TextColor3 = Color3.fromRGB(240, 255, 255)

        contentFrame.Visible = true
    end

    tabButton.MouseButton1Click:Connect(selectTab)

    table.insert(self.TabButtons, tabButton)
    table.insert(self.Tabs, {Button = tabButton, Content = contentFrame, Elements = {}, Layout = layout})

    if #self.Tabs == 1 then
        selectTab()
    end

    local tabData = self.Tabs[#self.Tabs]

    function tabData:AddTextbox(placeholder, callback)
        local container, textbox = createTextbox(tabData.Content, placeholder)
        container.LayoutOrder = #tabData.Elements + 1
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
        dropdown.LayoutOrder = #tabData.Elements + 1
        dropdown.Parent = tabData.Content

        table.insert(tabData.Elements, dropdown)
        return dropdown, label
    end

    function tabData:AddButton(text, callback, iconId)
        local btn = createButton(tabData.Content, text, iconId)
        btn.LayoutOrder = #tabData.Elements + 1
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

-- Return module
return LucentUI

--[[
Usage Example:

local LucentUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/your-repo/LucentUIExecutor.lua"))()

local ui = LucentUI.new()

local homeTab = ui:AddTab("Home", "rbxassetid://4483345998") -- example icon assetid
homeTab:AddTextbox("Enter your name...", function(text) print("Name:", text) end)
homeTab:AddDropdown({"Blue", "Green", "Red"}, "Pick a color")
homeTab:AddButton("Submit", function() print("Submitted!") end, "rbxassetid://6031094673") -- icon example

local settingsTab = ui:AddTab("Settings", "rbxassetid://6031094673")
settingsTab:AddButton("Reset", function() print("Reset pressed") end)

ui:Show()
]]
