local SimpleBlueUI = {}

-- Load the library
function SimpleBlueUI:Load()
    local Library = {}
    local Theme = {
        Main = Color3.fromRGB(30, 136, 229), -- Primary blue
        Secondary = Color3.fromRGB(21, 101, 192), -- Darker blue
        Text = Color3.fromRGB(255, 255, 255), -- White text
        Background = Color3.fromRGB(45, 45, 45), -- Dark background
        Section = Color3.fromRGB(60, 60, 60) -- Section background
    }

    -- Create main window
    function Library:CreateWindow(title, subtitle, placeholderId)
        local ScreenGui = Instance.new("ScreenGui")
        ScreenGui.Name = "SimpleBlueUI_"..tostring(math.random(1, 10000))
        ScreenGui.Parent = game:GetService("CoreGui")
        
        local MainFrame = Instance.new("Frame")
        MainFrame.Name = "MainFrame"
        MainFrame.Size = UDim2.new(0, 500, 0, 400)
        MainFrame.Position = UDim2.new(0.5, -250, 0.5, -200)
        MainFrame.BackgroundColor3 = Theme.Background
        MainFrame.BorderSizePixel = 0
        MainFrame.Parent = ScreenGui
        
        -- Header
        local Header = Instance.new("Frame")
        Header.Name = "Header"
        Header.Size = UDim2.new(1, 0, 0, 40)
        Header.BackgroundColor3 = Theme.Main
        Header.BorderSizePixel = 0
        Header.Parent = MainFrame
        
        local Title = Instance.new("TextLabel")
        Title.Name = "Title"
        Title.Text = title
        Title.TextColor3 = Theme.Text
        Title.TextSize = 18
        Title.Font = Enum.Font.GothamBold
        Title.Position = UDim2.new(0, 10, 0, 0)
        Title.Size = UDim2.new(0, 200, 1, 0)
        Title.BackgroundTransparency = 1
        Title.TextXAlignment = Enum.TextXAlignment.Left
        Title.Parent = Header
        
        local Subtitle = Instance.new("TextLabel")
        Subtitle.Name = "Subtitle"
        Subtitle.Text = subtitle
        Subtitle.TextColor3 = Theme.Text
        Subtitle.TextTransparency = 0.3
        Subtitle.TextSize = 14
        Subtitle.Font = Enum.Font.Gotham
        Subtitle.Position = UDim2.new(0, 10, 0, 20)
        Subtitle.Size = UDim2.new(0, 200, 0, 20)
        Subtitle.BackgroundTransparency = 1
        Subtitle.TextXAlignment = Enum.TextXAlignment.Left
        Subtitle.Parent = Header
        
        -- Tab container
        local TabContainer = Instance.new("Frame")
        TabContainer.Name = "TabContainer"
        TabContainer.Size = UDim2.new(1, 0, 0, 30)
        TabContainer.Position = UDim2.new(0, 0, 0, 40)
        TabContainer.BackgroundColor3 = Theme.Secondary
        TabContainer.BorderSizePixel = 0
        TabContainer.Parent = MainFrame
        
        -- Content frame
        local ContentFrame = Instance.new("Frame")
        ContentFrame.Name = "ContentFrame"
        ContentFrame.Size = UDim2.new(1, -20, 1, -80)
        ContentFrame.Position = UDim2.new(0, 10, 0, 80)
        ContentFrame.BackgroundTransparency = 1
        ContentFrame.Parent = MainFrame
        
        local Tabs = {}
        
        -- Create tab function
        function Tabs:CreateTab(name)
            local TabButton = Instance.new("TextButton")
            TabButton.Name = name.."TabButton"
            TabButton.Text = name
            TabButton.TextColor3 = Theme.Text
            TabButton.TextSize = 14
            TabButton.Font = Enum.Font.Gotham
            TabButton.BackgroundColor3 = Theme.Secondary
            TabButton.BorderSizePixel = 0
            TabButton.Size = UDim2.new(0, 100, 1, 0)
            TabButton.Position = UDim2.new(0, (#Tabs-1)*100, 0, 0)
            TabButton.Parent = TabContainer
            
            local TabContent = Instance.new("ScrollingFrame")
            TabContent.Name = name.."TabContent"
            TabContent.Size = UDim2.new(1, 0, 1, 0)
            TabContent.Position = UDim2.new(0, 0, 0, 0)
            TabContent.BackgroundTransparency = 1
            TabContent.BackgroundColor3 = Theme.Section
            TabContent.ScrollBarThickness = 5
            TabContent.Visible = (#Tabs == 1)
            TabContent.Parent = ContentFrame
            
            TabButton.MouseButton1Click:Connect(function()
                for _, tab in pairs(ContentFrame:GetChildren()) do
                    if tab:IsA("ScrollingFrame") then
                        tab.Visible = false
                    end
                end
                TabContent.Visible = true
            end)
            
            local Elements = {}
            
            -- Create button function
            function Elements:CreateButton(text, callback)
                local Button = Instance.new("TextButton")
                Button.Name = text.."Button"
                Button.Text = text
                Button.TextColor3 = Theme.Text
                Button.TextSize = 14
                Button.Font = Enum.Font.Gotham
                Button.BackgroundColor3 = Theme.Main
                Button.BorderSizePixel = 0
                Button.Size = UDim2.new(1, -20, 0, 30)
                Button.Position = UDim2.new(0, 10, 0, #TabContent:GetChildren()*35 + 10)
                Button.Parent = TabContent
                
                Button.MouseButton1Click:Connect(callback)
                
                -- Update canvas size
                TabContent.CanvasSize = UDim2.new(0, 0, 0, #TabContent:GetChildren()*35 + 20)
            end
            
            -- Add more element creation functions here (sliders, toggles, etc.)
            
            return Elements
        end
        
        return Tabs
    end
    
    return Library
end

-- Example usage:
local UI = SimpleBlueUI:Load()
local window = UI:CreateWindow("Simple Blue UI", "Modern and Clean", "12345")
local tab = window:CreateTab("Main")
tab:CreateButton("Click Me", function()
    print("Button clicked!")
end)
