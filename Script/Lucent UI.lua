-- Studio Fluent Roulette UI (Fixed)
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local MarketplaceService = game:GetService("MarketplaceService")
local HttpService = game:GetService("HttpService")

-- Modern Blue Theme Configuration
local Config = {
    Colors = {
        Primary = Color3.fromRGB(0, 120, 215),       -- Modern Blue
        Secondary = Color3.fromRGB(0, 90, 180),      -- Darker Blue
        Background = Color3.fromRGB(25, 25, 35),     -- Dark background
        Text = Color3.fromRGB(245, 245, 245),        -- White text
        Error = Color3.fromRGB(255, 80, 80),         -- Red for errors
        Success = Color3.fromRGB(100, 255, 100),     -- Green for success
        Button = Color3.fromRGB(40, 40, 50),         -- Button color
        Accent = Color3.fromRGB(0, 170, 255)        -- Bright blue accent
    },
    Discord = "https://discord.gg/example",
    ValidKeys = {"STXR2020"},
    ParticleDensity = 50,
    FadeDelay = 5,
    SupportedGames = {
        [12355337193] = {
            Name = "Murderers VS Sheriffs DUELS",
            Exec = function()
                loadstring(game:HttpGet("https://raw.githubusercontent.com/lucent-hub/Lucent/refs/heads/main/Script/Murder%20VS%20Sheriff/Code.lua"))()
            end
        },
        [2788229376] = {
            Name = "DaHood",
            Exec = function()
                loadstring(game:HttpGet("https://raw.githubusercontent.com/lucent-hub/Lucent/refs/heads/main/Script/Da%20hood/Code.lua"))()
            end
        }
    }
}

-- Key System
local KeySystem = {
    Attempts = 0,
    MaxAttempts = 4,
    Verified = false,
    SavedKeys = {}
}

-- UI Creation
local function CreateLoader()
    local player = Players.LocalPlayer
    local gui = Instance.new("ScreenGui")
    gui.Name = "ModernLoader"
    gui.ResetOnSpawn = false
    gui.Parent = player:WaitForChild("PlayerGui")
    
    -- Main container with modern styling
    local container = Instance.new("Frame")
    container.Size = UDim2.new(0, 400, 0, 500)
    container.Position = UDim2.new(0.5, 0, 0.5, 0)
    container.AnchorPoint = Vector2.new(0.5, 0.5)
    container.BackgroundColor3 = Config.Colors.Background
    container.BackgroundTransparency = 0.1
    container.Parent = gui
    
    -- Modern border effect
    local border = Instance.new("Frame")
    border.Size = UDim2.new(1, 6, 1, 6)
    border.Position = UDim2.new(0, -3, 0, -3)
    border.BackgroundColor3 = Config.Colors.Primary
    border.BackgroundTransparency = 0.8
    border.ZIndex = 0
    border.Parent = container
    
    -- Rounded corners
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 12)
    corner.Parent = container
    corner:Clone().Parent = border
    
    -- Title with gradient
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, -20, 0, 50)
    title.Position = UDim2.new(0, 10, 0, 15)
    title.BackgroundTransparency = 1
    title.Text = "MODERN LOADER"
    title.TextColor3 = Config.Colors.Text
    title.Font = Enum.Font.GothamBlack
    title.TextSize = 28
    title.TextXAlignment = Enum.TextXAlignment.Center
    title.Parent = container
    
    -- Key input with modern styling
    local keyInput = Instance.new("TextBox")
    keyInput.Size = UDim2.new(1, -40, 0, 45)
    keyInput.Position = UDim2.new(0, 20, 0, 85)
    keyInput.BackgroundColor3 = Config.Colors.Button
    keyInput.BackgroundTransparency = 0.7
    keyInput.PlaceholderText = "Enter your key..."
    keyInput.PlaceholderColor3 = Color3.fromRGB(150, 150, 150)
    keyInput.Text = ""
    keyInput.TextColor3 = Config.Colors.Text
    keyInput.Font = Enum.Font.GothamMedium
    keyInput.TextSize = 16
    keyInput.Parent = container
    
    local inputCorner = Instance.new("UICorner")
    inputCorner.CornerRadius = UDim.new(0, 8)
    inputCorner.Parent = keyInput
    
    -- Status label
    local status = Instance.new("TextLabel")
    status.Size = UDim2.new(1, -20, 0, 70)
    status.Position = UDim2.new(0, 10, 0, 145)
    status.BackgroundTransparency = 1
    status.Text = "Enter your key to continue"
    status.TextColor3 = Config.Colors.Text
    status.Font = Enum.Font.GothamMedium
    status.TextSize = 16
    status.TextWrapped = true
    status.TextYAlignment = Enum.TextYAlignment.Top
    status.Parent = container
    
    -- Modern progress bar
    local progressContainer = Instance.new("Frame")
    progressContainer.Size = UDim2.new(1, -40, 0, 6)
    progressContainer.Position = UDim2.new(0, 20, 0, 230)
    progressContainer.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    progressContainer.Parent = container
    
    local progressBar = Instance.new("Frame")
    progressBar.Size = UDim2.new(0, 0, 1, 0)
    progressBar.BackgroundColor3 = Config.Colors.Primary
    progressBar.Parent = progressContainer
    
    local progressCorner = Instance.new("UICorner")
    progressCorner.CornerRadius = UDim.new(1, 0)
    progressCorner.Parent = progressContainer
    progressCorner:Clone().Parent = progressBar
    
    -- Verify button with hover effects
    local verifyBtn = Instance.new("TextButton")
    verifyBtn.Size = UDim2.new(1, -40, 0, 45)
    verifyBtn.Position = UDim2.new(0, 20, 0, 260)
    verifyBtn.BackgroundColor3 = Config.Colors.Primary
    verifyBtn.BackgroundTransparency = 0.3
    verifyBtn.Text = "VERIFY KEY"
    verifyBtn.TextColor3 = Config.Colors.Text
    verifyBtn.Font = Enum.Font.GothamBold
    verifyBtn.TextSize = 16
    verifyBtn.Parent = container
    
    local verifyCorner = Instance.new("UICorner")
    verifyCorner.CornerRadius = UDim.new(0, 8)
    verifyCorner.Parent = verifyBtn
    
    -- Discord button
    local discordBtn = Instance.new("TextButton")
    discordBtn.Size = UDim2.new(1, -40, 0, 45)
    discordBtn.Position = UDim2.new(0, 20, 0, 320)
    discordBtn.BackgroundColor3 = Color3.fromRGB(88, 101, 242)
    discordBtn.BackgroundTransparency = 0.2
    discordBtn.Text = "GET KEY FROM DISCORD"
    discordBtn.TextColor3 = Config.Colors.Text
    discordBtn.Font = Enum.Font.GothamBold
    discordBtn.TextSize = 16
    discordBtn.Parent = container
    
    local discordCorner = Instance.new("UICorner")
    discordCorner.CornerRadius = UDim.new(0, 8)
    discordCorner.Parent = discordBtn
    
    -- Add hover effects
    for _, btn in pairs({verifyBtn, discordBtn}) do
        btn.MouseEnter:Connect(function()
            game:GetService("TweenService"):Create(
                btn,
                TweenInfo.new(0.2),
                {BackgroundTransparency = 0}
            ):Play()
        end)
        
        btn.MouseLeave:Connect(function()
            game:GetService("TweenService"):Create(
                btn,
                TweenInfo.new(0.2),
                {BackgroundTransparency = btn == discordBtn and 0.2 or 0.3}
            ):Play()
        end)
    end
    
    return {
        Gui = gui,
        Container = container,
        KeyInput = keyInput,
        Status = status,
        ProgressBar = progressBar,
        VerifyBtn = verifyBtn,
        DiscordBtn = discordBtn
    }
end

-- Animation functions
local function Animate(object, properties, duration)
    local tween = TweenService:Create(object, TweenInfo.new(duration or 0.3, Enum.EasingStyle.Quint), properties)
    tween:Play()
    return tween
end

-- Loading sequence with modern steps
local function LoadingSequence(ui, callback)
    ui.Container.Size = UDim2.new(0, 0, 0, 0)
    Animate(ui.Container, {Size = UDim2.new(0, 400, 0, 500)})
    
    local steps = {
        {"Initializing security...", 0.4},
        {"Verifying credentials...", 0.5},
        {"Loading modules...", 0.6},
        {"Checking game compatibility...", 0.5},
        {"Finalizing setup...", 0.4}
    }
    
    for i, step in ipairs(steps) do
        ui.Status.Text = step[1]
        Animate(ui.ProgressBar, {Size = UDim2.new(i/#steps, 0, 1, 0)}, step[2])
        wait(step[2])
    end
    
    callback()
end

-- Main function
local function StartLoader()
    local UI = CreateLoader()
    
    -- Auto-dimmer
    coroutine.wrap(function()
        wait(Config.FadeDelay)
        if UI.Gui.Parent then
            Animate(UI.Container, {BackgroundTransparency = 0.5})
        end
    end)()
    
    -- Verify button
    UI.VerifyBtn.MouseButton1Click:Connect(function()
        if KeySystem.Attempts >= KeySystem.MaxAttempts then
            UI.Status.Text = "Maximum attempts reached\nPlease join our Discord for support"
            UI.Status.TextColor3 = Config.Colors.Error
            return
        end
        
        if UI.KeyInput.Text == "" then
            UI.Status.Text = "Please enter a valid key"
            UI.Status.TextColor3 = Config.Colors.Error
            return
        end
        
        -- Simple validation for example
        if UI.KeyInput.Text:upper() == "STXR2020" then
            LoadingSequence(UI, function()
                local gameId = game.PlaceId
                local gameData = Config.SupportedGames[gameId]
                
                if gameData then
                    UI.Status.Text = gameData.Name.."\nSuccessfully loaded!"
                    UI.Status.TextColor3 = Config.Colors.Success
                    Animate(UI.ProgressBar, {BackgroundColor3 = Config.Colors.Success})
                    
                    -- Execute game script
                    pcall(gameData.Exec)
                    
                    -- Close UI
                    wait(1.5)
                    Animate(UI.Container, {
                        Size = UDim2.new(0, 0, 0, 0),
                        BackgroundTransparency = 1
                    }).Completed:Wait()
                    UI.Gui:Destroy()
                else
                    UI.Status.Text = "Game not supported yet\nJoin our Discord to request it"
                    UI.Status.TextColor3 = Config.Colors.Error
                end
            end)
        else
            KeySystem.Attempts = KeySystem.Attempts + 1
            UI.Status.Text = string.format("Invalid key (%d/%d attempts)", KeySystem.Attempts, KeySystem.MaxAttempts)
            UI.Status.TextColor3 = Config.Colors.Error
            
            -- Shake animation
            local shake = {5, -4, 3, -2, 1, 0}
            for _, offset in ipairs(shake) do
                UI.KeyInput.Position = UDim2.new(0, 20 + offset, 0, 85)
                wait(0.05)
            end
        end
    end)
    
    -- Discord button
    UI.DiscordBtn.MouseButton1Click:Connect(function()
        if setclipboard then
            setclipboard(Config.Discord)
            UI.Status.Text = "Discord link copied!\nJoin to get your key"
            UI.Status.TextColor3 = Config.Colors.Primary
        end
    end)
end

-- Start the loader
StartLoader()
