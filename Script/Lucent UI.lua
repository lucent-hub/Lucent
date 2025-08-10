local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

local Library = {}
Library.Tabs = {}

-- Helper: Create glassmorphic rounded frame with blur effect behind it
local function createGlassFrame(parent, size, position)
    local container = Instance.new("Frame")
    container.Size = size
    container.Position = position
    container.BackgroundTransparency = 1
    container.AnchorPoint = Vector2.new(0, 0)
    container.Parent = parent

    -- Blur background behind the frame for glass effect
    local blurBehind = Instance.new("ImageLabel")
    blurBehind.Size = UDim2.new(1, 40, 1, 40)
    blurBehind.Position = UDim2.new(0, -20, 0, -20)
    blurBehind.BackgroundTransparency = 1
    blurBehind.Image = "rbxassetid://12150868530" -- subtle noise texture for glass
    blurBehind.ImageColor3 = Color3.fromRGB(255, 255, 255)
    blurBehind.ImageTransparency = 0.85
    blurBehind.ScaleType = Enum.ScaleType.Tile
    blurBehind.TileSize = UDim2.new(0, 30, 0, 30)
    blurBehind.ZIndex = 1
    blurBehind.Parent = container

    local blurEffect = Instance.new("BlurEffect")
    blurEffect.Size = 15
    blurEffect.Parent = game:GetService("Lighting")

    -- Frame for glass panel
    local glass = Instance.new("Frame")
    glass.Size = UDim2.new(1, 0, 1, 0)
    glass.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    glass.BackgroundTransparency = 0.85
    glass.BorderSizePixel = 0
    glass.ZIndex = 2
    glass.Parent = container

    local uicorner = Instance.new("UICorner")
    uicorner.CornerRadius = UDim.new(0, 20)
    uicorner.Parent = glass

    -- Soft inner shadow (using UIStroke)
    local stroke = Instance.new("UIStroke")
    stroke.Thickness = 2
    stroke.Color = Color3.fromRGB(255, 255, 255)
    stroke.Transparency = 0.8
    stroke.Parent = glass

    return container, glass
end

-- Tween helper for smooth animations
local function tweenObject(obj, props, duration, style, direction)
    style = style or Enum.EasingStyle.Quad
    direction = direction or Enum.EasingDirection.Out
    local tweenInfo = TweenInfo.new(duration, style, direction)
    local tween = TweenService:Create(obj, tweenInfo, props)
    tween:Play()
    return tween
end

-- Glow effect helper (outer glow frame)
local function createGlow(parent, targetFrame)
    local glow = Instance.new("Frame")
    glow.Size = targetFrame.Size + UDim2.new(0, 40, 0, 40)
    glow.Position = targetFrame.Position - UDim2.new(0, 20, 0, 20)
    glow.BackgroundColor3 = Color3.fromRGB(0, 204, 255)
    glow.BackgroundTransparency = 0.9
    glow.ZIndex = targetFrame.ZIndex - 1
    glow.Parent = parent

    local uicorner = Instance.new("UICorner")
    uicorner.CornerRadius = UDim.new(1, 0)
    uicorner.Parent = glow

    -- Pulse tween animation for glow
    coroutine.wrap(function()
        while glow and glow.Parent do
            tweenObject(glow, {BackgroundTransparency = 0.7}, 1.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut).Completed:Wait()
            tweenObject(glow, {BackgroundTransparency = 0.9}, 1.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut).Completed:Wait()
        end
    end)()

    return glow
end

-- Create glowing button with hover and click animations
local function createButton(parent, size, position, text)
    local btn = Instance.new("TextButton")
    btn.Size = size
    btn.Position = position
    btn.BackgroundColor3 = Color3.fromRGB(15, 15, 30)
    btn.BorderSizePixel = 0
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(100, 230, 255)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 20
    btn.AutoButtonColor = false
    btn.ZIndex = 5
    btn.Parent = parent

    local uicorner = Instance.new("UICorner")
    uicorner.CornerRadius = UDim.new(0, 14)
    uicorner.Parent = btn

    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(0, 200, 255)
    stroke.Thickness = 2
    stroke.Parent = btn

    -- Glow frame inside button for neon effect
    local glow = Instance.new("Frame")
    glow.Size = UDim2.new(1, 0, 1, 0)
    glow.BackgroundColor3 = Color3.fromRGB(0, 255, 255)
    glow.BackgroundTransparency = 0.9
    glow.ZIndex = 4
    glow.Parent = btn

    local glowCorner = Instance.new("UICorner")
    glowCorner.CornerRadius = UDim.new(0, 14)
    glowCorner.Parent = glow

    -- Animations
    btn.MouseEnter:Connect(function()
        tweenObject(btn, {BackgroundColor3 = Color3.fromRGB(0, 50, 70)}, 0.3)
        tweenObject(glow, {BackgroundTransparency = 0.4}, 0.3)
        tweenObject(btn, {TextColor3 = Color3.fromRGB(0, 255, 255)}, 0.3)
    end)
    btn.MouseLeave:Connect(function()
        tweenObject(btn, {BackgroundColor3 = Color3.fromRGB(15, 15, 30)}, 0.3)
        tweenObject(glow, {BackgroundTransparency = 0.9}, 0.3)
        tweenObject(btn, {TextColor3 = Color3.fromRGB(100, 230, 255)}, 0.3)
    end)
    btn.MouseButton1Down:Connect(function()
        tweenObject(btn, {BackgroundColor3 = Color3.fromRGB(0, 100, 150)}, 0.1)
    end)
    btn.MouseButton1Up:Connect(function()
        tweenObject(btn, {BackgroundColor3 = Color3.fromRGB(0, 50, 70)}, 0.1)
    end)

    return btn
end

-- Create modern textbox with animations
local function createTextbox(parent, placeholder)
    local container = Instance.new("Frame")
    container.Size = UDim2.new(0, 280, 0, 44)
    container.BackgroundColor3 = Color3.fromRGB(25, 25, 40)
    container.BackgroundTransparency = 0.3
    container.BorderSizePixel = 0
    container.ZIndex = 10
    container.Parent = parent

    local uicorner = Instance.new("UICorner")
    uicorner.CornerRadius = UDim.new(0, 12)
    uicorner.Parent = container

    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(0, 190, 255)
    stroke.Thickness = 2
    stroke.Parent = container

    local textbox = Instance.new("TextBox")
    textbox.Size = UDim2.new(1, -20, 1, -10)
    textbox.Position = UDim2.new(0, 10, 0, 5)
    textbox.BackgroundTransparency = 1
    textbox.PlaceholderText = placeholder or "Type here..."
    textbox.TextColor3 = Color3.fromRGB(190, 240, 255)
    textbox.Font = Enum.Font.GothamSemibold
    textbox.TextSize = 20
    textbox.ClearTextOnFocus = false
    textbox.ZIndex = 11
    textbox.Parent = container

    -- Glow on focus
    textbox.Focused:Connect(function()
        tweenObject(stroke, {Color = Color3.fromRGB(0, 255, 255)}, 0.4)
    end)
    textbox.FocusLost:Connect(function(enterPressed)
        tweenObject(stroke, {Color = Color3.fromRGB(0, 190, 255)}, 0.4)
    end)

    return container, textbox
end

-- Dropdown with swag animation
local function createDropdown(parent, options, defaultText)
    local dropdown = Instance.new("Frame")
    dropdown.Size = UDim2.new(0, 200, 0, 38)
    dropdown.BackgroundColor3 = Color3.fromRGB(15, 15, 35)
    dropdown.BackgroundTransparency = 0.1
    dropdown.BorderSizePixel = 0
    dropdown.ZIndex = 10
    dropdown.Parent = parent

    local uicorner = Instance.new("UICorner")
    uicorner.CornerRadius = UDim.new(0, 14)
    uicorner.Parent = dropdown

    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(0, 200, 255)
    stroke.Thickness = 2
    stroke.Parent = dropdown

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -40, 1, 0)
    label.Position = UDim2.new(0, 20, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = defaultText or "Select an option"
    label.TextColor3 = Color3.fromRGB(180, 230, 255)
    label.Font = Enum.Font.GothamBold
    label.TextSize = 18
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.ZIndex = 11
    label.Parent = dropdown

    local arrow = Instance.new("TextLabel")
    arrow.Text = "▼"
    arrow.Size = UDim2.new(0, 20, 1, 0)
    arrow.Position = UDim2.new(1, -30, 0, 0)
    arrow.BackgroundTransparency = 1
    arrow.TextColor3 = Color3.fromRGB(100, 230, 255)
    arrow.Font = Enum.Font.GothamBold
    arrow.TextSize = 20
    arrow.ZIndex = 11
    arrow.Parent = dropdown

    local dropdownList = Instance.new("ScrollingFrame")
    dropdownList.Size = UDim2.new(1, 0, 0, 0)
    dropdownList.Position = UDim2.new(0, 0, 1, 5)
    dropdownList.BackgroundColor3 = Color3.fromRGB(10, 10, 20)
    dropdownList.BorderSizePixel = 0
    dropdownList.CanvasSize = UDim2.new(0, 0, 0, 0)
    dropdownList.ScrollBarThickness = 5
    dropdownList.Visible = false
    dropdownList.ZIndex = 11
    dropdownList.Parent = dropdown

    local listCorner = Instance.new("UICorner")
    listCorner.CornerRadius = UDim.new(0, 12)
    listCorner.Parent = dropdownList

    -- Populate dropdown options
    for i, option in ipairs(options) do
        local optionBtn = Instance.new("TextButton")
        optionBtn.Size = UDim2.new(1, -20, 0, 32)
        optionBtn.Position = UDim2.new(0, 10, 0, (i - 1) * 36)
        optionBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 40)
        optionBtn.BorderSizePixel = 0
        optionBtn.TextColor3 = Color3.fromRGB(180, 230, 255)
        optionBtn.Font = Enum.Font.GothamSemibold
        optionBtn.TextSize = 18
        optionBtn.Text = option
        optionBtn.ZIndex = 12
        optionBtn.Parent = dropdownList

        local optionCorner = Instance.new("UICorner")
        optionCorner.CornerRadius = UDim.new(0, 10)
        optionCorner.Parent = optionBtn

        optionBtn.MouseEnter:Connect(function()
            tweenObject(optionBtn, {BackgroundColor3 = Color3.fromRGB(0, 150, 200)}, 0.2)
        end)
        optionBtn.MouseLeave:Connect(function()
            tweenObject(optionBtn, {BackgroundColor3 = Color3.fromRGB(20, 20, 40)}, 0.2)
        end)

        optionBtn.MouseButton1Click:Connect(function()
            label.Text = option
            dropdownList.Visible = false
        end)
    end

    dropdownList.CanvasSize = UDim2.new(0, 0, 0, #options * 36)

    dropdown.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dropdownList.Visible = not dropdownList.Visible
            if dropdownList.Visible then
                tweenObject(dropdownList, {Size = UDim2.new(1, 0, 0, math.min(#options * 36, 180))}, 0.3)
            else
                tweenObject(dropdownList, {Size = UDim2.new(1, 0, 0, 0)}, 0.3)
            end
        end
    end)

    return dropdown, label
end

-- Main UI Creation
function Library:CreateUI()
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "SwagUI"
    screenGui.ResetOnSpawn = false
    screenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

    -- Main glass frame container + glass panel
    local container, mainFrame = createGlassFrame(screenGui, UDim2.new(0, 600, 0, 450), UDim2.new(0.5, -300, 0.5, -225))

    -- Neon glow behind main frame
    createGlow(screenGui, container)

    -- Left Tabs container with blur and shadow
    local tabsContainer = Instance.new("Frame")
    tabsContainer.Size = UDim2.new(0, 140, 1, 0)
    tabsContainer.BackgroundColor3 = Color3.fromRGB(20, 20, 40)
    tabsContainer.BackgroundTransparency = 0.1
    tabsContainer.Position = UDim2.new(0, 0, 0, 0)
    tabsContainer.ZIndex = 10
    tabsContainer.Parent = container

    local uicornerTabs = Instance.new("UICorner")
    uicornerTabs.CornerRadius = UDim.new(0, 20)
    uicornerTabs.Parent = tabsContainer

    local strokeTabs = Instance.new("UIStroke")
    strokeTabs.Color = Color3.fromRGB(0, 200, 255)
    strokeTabs.Thickness = 2
    strokeTabs.Parent = tabsContainer

    local tabsListLayout = Instance.new("UIListLayout")
    tabsListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    tabsListLayout.Padding = UDim.new(0, 16)
    tabsListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    tabsListLayout.Parent = tabsContainer

    -- Right content container
    local contentContainer = Instance.new("Frame")
    contentContainer.Size = UDim2.new(1, -160, 1, -40)
    contentContainer.Position = UDim2.new(0, 160, 0, 20)
    contentContainer.BackgroundTransparency = 1
    contentContainer.ZIndex = 15
    contentContainer.Parent = container

    local tabButtons = {}

    -- Add Tab function with animated switching
    function Library:AddTab(tabName)
        local tabButton = createButton(tabsContainer, UDim2.new(1, -40, 0, 44), UDim2.new(0, 0, 0, (#tabButtons) * 54 + 20), tabName)
        tabButton.TextColor3 = Color3.fromRGB(0, 190, 255)
        tabButton.BackgroundColor3 = Color3.fromRGB(10, 10, 30)

        local tabContent = Instance.new("Frame")
        tabContent.Size = UDim2.new(1, 0, 1, 0)
        tabContent.BackgroundTransparency = 1
        tabContent.Visible = false
        tabContent.ZIndex = 20
        tabContent.Parent = contentContainer

        -- Animated tab show/hide
        local function showTab()
            for _, btn in pairs(tabButtons) do
                tweenObject(btn, {BackgroundColor3 = Color3.fromRGB(10, 10, 30)}, 0.3)
                btn.TextColor3 = Color3.fromRGB(0, 190, 255)
            end
            for _, tab in pairs(Library.Tabs) do
                if tab.Content ~= tabContent then
                    tweenObject(tab.Content, {BackgroundTransparency = 1}, 0.3)
                    tab.Content.Visible = false
                end
            end

            tabContent.Visible = true
            tweenObject(tabContent, {BackgroundTransparency = 0}, 0.4)
            tweenObject(tabButton, {BackgroundColor3 = Color3.fromRGB(0, 190, 255)}, 0.3)
            tabButton.TextColor3 = Color3.fromRGB(25, 25, 35)
        end

        tabButton.MouseButton1Click:Connect(showTab)

        local tabData = {
            Button = tabButton,
            Content = tabContent,
            Elements = {}
        }
        table.insert(tabButtons, tabButton)
        table.insert(Library.Tabs, tabData)

        -- Auto-select first tab
        if #Library.Tabs == 1 then
            showTab()
        end

        -- Add Textbox with enter callback
        function tabData:AddTextbox(placeholder, onEnter)
            local container, textbox = createTextbox(self.Content, placeholder)
            container.Position = UDim2.new(0, 20, 0, (#self.Elements) * 60 + 20)
            container.Parent = self.Content

            textbox.FocusLost:Connect(function(enterPressed)
                if enterPressed and onEnter then
                    onEnter(textbox.Text)
                    textbox.Text = ""
                end
            end)

            table.insert(self.Elements, container)
            return textbox
        end

        -- Add Dropdown with options
        function tabData:AddDropdown(options, defaultText)
            local dropdown, label = createDropdown(self.Content, options, defaultText)
            dropdown.Position = UDim2.new(0, 20, 0, (#self.Elements) * 60 + 20)
            dropdown.Parent = self.Content

            table.insert(self.Elements, dropdown)
            return dropdown, label
        end

        return tabData
    end

    return Library
end

return Library
