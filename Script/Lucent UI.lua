-- Lucent UI Library
local Lucent = {}
Lucent.__index = Lucent

-- Services
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")

-- Utility functions
local function dragify(frame)
    local dragToggle, dragInput, dragStart, startPos
    
    local function updateInput(input)
        local delta = input.Position - dragStart
        local pos = UDim2.new(
            startPos.X.Scale, 
            startPos.X.Offset + delta.X, 
            startPos.Y.Scale, 
            startPos.Y.Offset + delta.Y
        )
        TweenService:Create(frame, TweenInfo.new(0.25), {Position = pos}):Play()
    end
    
    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragToggle = true
            dragStart = input.Position
            startPos = frame.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragToggle = false
                end
            end)
        end
    end)
    
    frame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragToggle then
            updateInput(input)
        end
    end)
end

local function createCorner(parent, radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, radius or 8)
    corner.Parent = parent
    return corner
end

local function createStroke(parent)
    local stroke = Instance.new("UIStroke")
    stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    stroke.Color = Color3.fromRGB(60, 60, 60)
    stroke.Thickness = 1
    stroke.Parent = parent
    return stroke
end

-- Library initialization
function Lucent.new()
    local self = setmetatable({}, Lucent)
    self.windows = {}
    
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "LucentUI"
    screenGui.ResetOnSpawn = false
    screenGui.Parent = Players.LocalPlayer:WaitForChild("PlayerGui")
    
    self.screenGui = screenGui
    return self
end

-- Window creation
function Lucent:CreateWindow(title, description, iconId)
    local window = {
        tabs = {},
        container = nil,
        mainFrame = nil
    }
    
    -- Main window frame
    local main = Instance.new("Frame")
    main.Size = UDim2.new(0, 200, 0, 54)
    main.Position = UDim2.new(0.35, 0, 0.35, 0)
    main.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    main.BorderSizePixel = 0
    main.Active = true
    main.ClipsDescendants = true
    main.Parent = self.screenGui
    
    createCorner(main)
    createStroke(main)
    
    window.mainFrame = main
    
    -- Window icon
    if iconId then
        local icon = Instance.new("ImageLabel")
        icon.Size = UDim2.new(0, 20, 0, 20)
        icon.Position = UDim2.new(0, 8, 0, 8)
        icon.Image = "rbxassetid://"..iconId
        icon.BackgroundTransparency = 1
        icon.Parent = main
    end
    
    -- Window title
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1, iconId and -64 or -28, 0, 20)
    titleLabel.Position = UDim2.new(0, iconId and 34 or 10, 0, 8)
    titleLabel.Text = title or "Lucent Hub"
    titleLabel.TextColor3 = Color3.new(1, 1, 1)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Font = Enum.Font.Gotham
    titleLabel.TextSize = 14
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Parent = main
    
    -- Window description
    if description then
        local descLabel = Instance.new("TextLabel")
        descLabel.Size = UDim2.new(1, -20, 0, 16)
        descLabel.Position = UDim2.new(0, 10, 0, 28)
        descLabel.Text = description
        descLabel.TextColor3 = Color3.fromRGB(160, 160, 160)
        descLabel.BackgroundTransparency = 1
        descLabel.Font = Enum.Font.Gotham
        descLabel.TextSize = 12
        descLabel.TextXAlignment = Enum.TextXAlignment.Left
        descLabel.Parent = main
    end
    
    -- Toggle arrow
    local toggleArrow = Instance.new("ImageButton")
    toggleArrow.Size = UDim2.new(0, 20, 0, 20)
    toggleArrow.Position = UDim2.new(1, -28, 0, 8)
    toggleArrow.Image = "rbxassetid://10734950309"
    toggleArrow.BackgroundTransparency = 1
    toggleArrow.Parent = main
    
    -- Container for tabs and elements
    local container = Instance.new("Frame")
    container.Position = UDim2.new(0, 0, 0, 54)
    container.Size = UDim2.new(1, 0, 0, 0)
    container.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    container.ClipsDescendants = true
    container.Parent = main
    
    createCorner(container, 6)
    createStroke(container)
    
    window.container = container
    
    -- Toggle logic
    local expanded = false
    local expandedSize = UDim2.new(0, 200, 0, 130)
    local collapsedSize = UDim2.new(0, 200, 0, 54)
    
    toggleArrow.MouseButton1Click:Connect(function()
        expanded = not expanded
        local tweenInfo = TweenInfo.new(0.25, Enum.EasingStyle.Sine, Enum.EasingDirection.Out)
        TweenService:Create(main, tweenInfo, {
            Size = expanded and expandedSize or collapsedSize
        }):Play()
    end)
    
    -- Make window draggable
    dragify(main)
    
    -- Window methods
    function window:UpdateSize()
        local totalHeight = 0
        for _, element in pairs(container:GetChildren()) do
            if not element:IsA("UIListLayout") then
                totalHeight += element.Size.Y.Offset + 5
            end
        end
        expandedSize = UDim2.new(0, 200, 0, 54 + totalHeight + 10)
        container.Size = UDim2.new(1, 0, 0, totalHeight + 10)
    end
    
    function window:CreateTab(name)
        local tab = {
            name = name,
            elements = {},
            container = nil,
            button = nil
        }
        
        -- Tab button
        local tabButton = Instance.new("TextButton")
        tabButton.Size = UDim2.new(1, -10, 0, 28)
        tabButton.Position = UDim2.new(0, 5, 0, #window.tabs * 33 + 5)
        tabButton.Text = name
        tabButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        tabButton.TextColor3 = Color3.new(1, 1, 1)
        tabButton.Font = Enum.Font.Gotham
        tabButton.TextSize = 14
        tabButton.Parent = container
        
        createCorner(tabButton, 5)
        createStroke(tabButton)
        
        tab.button = tabButton
        
        -- Tab container (will be shown/hidden)
        local tabContainer = Instance.new("Frame")
        tabContainer.Size = UDim2.new(1, -10, 0, 0)
        tabContainer.Position = UDim2.new(0, 5, 0, tabButton.Position.Y.Offset + 33)
        tabContainer.BackgroundTransparency = 1
        tabContainer.Visible = false
        tabContainer.Parent = container
        
        local layout = Instance.new("UIListLayout")
        layout.Padding = UDim.new(0, 5)
        layout.Parent = tabContainer
        
        tab.container = tabContainer
        
        -- Tab methods
        function tab:Show()
            for _, otherTab in pairs(window.tabs) do
                otherTab.container.Visible = false
            end
            tabContainer.Visible = true
        end
        
        function tab:Hide()
            tabContainer.Visible = false
        end
        
        tabButton.MouseButton1Click:Connect(function()
            tab:Show()
        end)
        
        -- Show first tab by default
        if #window.tabs == 0 then
            tab:Show()
        end
        
        -- Add elements to tab
        function tab:CreateButton(text, callback)
            local button = Instance.new("TextButton")
            button.Size = UDim2.new(1, 0, 0, 28)
            button.Text = text
            button.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
            button.TextColor3 = Color3.new(1, 1, 1)
            button.Font = Enum.Font.Gotham
            button.TextSize = 14
            button.Parent = tabContainer
            
            createCorner(button, 5)
            createStroke(button)
            
            button.MouseButton1Click:Connect(function()
                if callback then callback() end
            end)
            
            window:UpdateSize()
            return button
        end
        
        function tab:CreateToggle(text, default, callback)
            local toggle = Instance.new("TextButton")
            toggle.Size = UDim2.new(1, 0, 0, 28)
            toggle.Text = default and text.." [ON]" or text.." [OFF]"
            toggle.BackgroundColor3 = default and Color3.fromRGB(70, 120, 70) or Color3.fromRGB(120, 70, 70)
            toggle.TextColor3 = Color3.new(1, 1, 1)
            toggle.Font = Enum.Font.Gotham
            toggle.TextSize = 14
            toggle.Parent = tabContainer
            
            createCorner(toggle, 5)
            createStroke(toggle)
            
            local state = default or false
            
            toggle.MouseButton1Click:Connect(function()
                state = not state
                toggle.Text = state and text.." [ON]" or text.." [OFF]"
                toggle.BackgroundColor3 = state and Color3.fromRGB(70, 120, 70) or Color3.fromRGB(120, 70, 70)
                if callback then callback(state) end
            end)
            
            window:UpdateSize()
            return toggle
        end
        
        function tab:CreateSlider(text, min, max, default, callback)
            local sliderFrame = Instance.new("Frame")
            sliderFrame.Size = UDim2.new(1, 0, 0, 40)
            sliderFrame.BackgroundTransparency = 1
            sliderFrame.Parent = tabContainer
            
            local label = Instance.new("TextLabel")
            label.Size = UDim2.new(1, 0, 0, 16)
            label.Text = text..": "..default
            label.TextColor3 = Color3.new(1, 1, 1)
            label.BackgroundTransparency = 1
            label.Font = Enum.Font.Gotham
            label.TextSize = 12
            label.TextXAlignment = Enum.TextXAlignment.Left
            label.Parent = sliderFrame
            
            local slider = Instance.new("Frame")
            slider.Size = UDim2.new(1, 0, 0, 4)
            slider.Position = UDim2.new(0, 0, 0, 20)
            slider.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
            slider.Parent = sliderFrame
            
            createCorner(slider, 2)
            
            local fill = Instance.new("Frame")
            fill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
            fill.BackgroundColor3 = Color3.fromRGB(100, 150, 255)
            fill.Parent = slider
            
            createCorner(fill, 2)
            
            local dragging = false
            local value = default
            
            local function updateValue(input)
                local relativeX = (input.Position.X - slider.AbsolutePosition.X) / slider.AbsoluteSize.X
                relativeX = math.clamp(relativeX, 0, 1)
                value = math.floor(min + (max - min) * relativeX)
                fill.Size = UDim2.new(relativeX, 0, 1, 0)
                label.Text = text..": "..value
                if callback then callback(value) end
            end
            
            slider.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = true
                    updateValue(input)
                end
            end)
            
            slider.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = false
                end
            end)
            
            UserInputService.InputChanged:Connect(function(input)
                if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                    updateValue(input)
                end
            end)
            
            window:UpdateSize()
            return sliderFrame
        end
        
        function tab:CreateDropdown(text, options, default, callback)
            local dropdownFrame = Instance.new("Frame")
            dropdownFrame.Size = UDim2.new(1, 0, 0, 28)
            dropdownFrame.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
            dropdownFrame.Parent = tabContainer
            
            createCorner(dropdownFrame, 5)
            createStroke(dropdownFrame)
            
            local label = Instance.new("TextLabel")
            label.Size = UDim2.new(0.7, 0, 1, 0)
            label.Text = text
            label.TextColor3 = Color3.new(1, 1, 1)
            label.BackgroundTransparency = 1
            label.Font = Enum.Font.Gotham
            label.TextSize = 14
            label.TextXAlignment = Enum.TextXAlignment.Left
            label.Parent = dropdownFrame
            
            local valueLabel = Instance.new("TextLabel")
            valueLabel.Size = UDim2.new(0.3, -5, 1, 0)
            valueLabel.Position = UDim2.new(0.7, 5, 0, 0)
            valueLabel.Text = options[default] or options[1]
            valueLabel.TextColor3 = Color3.new(1, 1, 1)
            valueLabel.BackgroundTransparency = 1
            valueLabel.Font = Enum.Font.Gotham
            valueLabel.TextSize = 14
            valueLabel.TextXAlignment = Enum.TextXAlignment.Right
            valueLabel.Parent = dropdownFrame
            
            local dropdownButton = Instance.new("TextButton")
            dropdownButton.Size = UDim2.new(1, 0, 1, 0)
            dropdownButton.Text = ""
            dropdownButton.BackgroundTransparency = 1
            dropdownButton.Parent = dropdownFrame
            
            local dropdownOptions = Instance.new("Frame")
            dropdownOptions.Size = UDim2.new(1, 0, 0, 0)
            dropdownOptions.Position = UDim2.new(0, 0, 1, 5)
            dropdownOptions.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
            dropdownOptions.Visible = false
            dropdownOptions.Parent = dropdownFrame
            
            createCorner(dropdownOptions, 5)
            createStroke(dropdownOptions)
            
            local optionsLayout = Instance.new("UIListLayout")
            optionsLayout.Parent = dropdownOptions
            
            for i, option in pairs(options) do
                local optionButton = Instance.new("TextButton")
                optionButton.Size = UDim2.new(1, 0, 0, 28)
                optionButton.Text = option
                optionButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
                optionButton.TextColor3 = Color3.new(1, 1, 1)
                optionButton.Font = Enum.Font.Gotham
                optionButton.TextSize = 14
                optionButton.Parent = dropdownOptions
                
                createCorner(optionButton, 5)
                createStroke(optionButton)
                
                optionButton.MouseButton1Click:Connect(function()
                    valueLabel.Text = option
                    dropdownOptions.Visible = false
                    if callback then callback(i, option) end
                end)
            end
            
            dropdownButton.MouseButton1Click:Connect(function()
                dropdownOptions.Visible = not dropdownOptions.Visible
                if dropdownOptions.Visible then
                    dropdownOptions.Size = UDim2.new(1, 0, 0, #options * 33)
                else
                    dropdownOptions.Size = UDim2.new(1, 0, 0, 0)
                end
            end)
            
            window:UpdateSize()
            return dropdownFrame
        end
        
        function tab:CreateLabel(text)
            local label = Instance.new("TextLabel")
            label.Size = UDim2.new(1, 0, 0, 20)
            label.Text = text
            label.TextColor3 = Color3.new(1, 1, 1)
            label.BackgroundTransparency = 1
            label.Font = Enum.Font.Gotham
            label.TextSize = 14
            label.TextXAlignment = Enum.TextXAlignment.Left
            label.Parent = tabContainer
            
            window:UpdateSize()
            return label
        end
        
        function tab:CreateTextBox(placeholder, default, callback)
            local textBox = Instance.new("TextBox")
            textBox.Size = UDim2.new(1, 0, 0, 28)
            textBox.PlaceholderText = placeholder
            textBox.Text = default or ""
            textBox.TextColor3 = Color3.new(1, 1, 1)
            textBox.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
            textBox.Font = Enum.Font.Gotham
            textBox.TextSize = 14
            textBox.Parent = tabContainer
            
            createCorner(textBox, 5)
            createStroke(textBox)
            
            textBox.FocusLost:Connect(function()
                if callback then callback(textBox.Text) end
            end)
            
            window:UpdateSize()
            return textBox
        end
        
        table.insert(window.tabs, tab)
        window:UpdateSize()
        return tab
    end
    
    table.insert(self.windows, window)
    return window
end

return Lucent
