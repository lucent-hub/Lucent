local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local MarketplaceService = game:GetService("MarketplaceService")
local HttpService = game:GetService("HttpService")

-- Lucent Theme Configuration
local Config = {
    Colors = {
        Primary = Color3.fromRGB(0, 170, 255),  -- Lucent Blue
        Secondary = Color3.fromRGB(50, 200, 255),
        Background = Color3.fromRGB(20, 20, 30),
        Text = Color3.fromRGB(245, 245, 245),
        Error = Color3.fromRGB(255, 80, 80),
        Success = Color3.fromRGB(80, 255, 80),
        Button = Color3.fromRGB(60, 60, 70)
    },
    Discord = "https://discord.gg/SdTStha6p3",
    ValidKeys = "STXR2020", -- Keys will be loaded from Discord
    KeyFile = "LucentKey.txt",
    SupportedGames = {
        [2355337193] = { -- Murderers VS Sheriffs DUELS
            Name = "Murderers VS Sheriffs DUELS",
            Exec = function()
                loadstring(game:HttpGet("https://raw.githubusercontent.com/lucent-hub/Lucent/refs/heads/main/Script/Murder%20VS%20Sheriff/Code.lua"))()
            end
        },
    },
    SupportedGames = {
        [2788229376] = { -- DAHood
            Name = "Dahood - some errors...",
            Exec = function()
                loadstring(game:HttpGet("https://raw.githubusercontent.com/lucent-hub/Lucent/refs/heads/main/Script/Da%20hood/Code.lua"))()
            end
        },
    },
    ParticleDensity = 50,
    FadeDelay = 5,
    UniversalHubID = 1234567890
}

-- Key system with file checking
local KeySystem = {
    Attempts = 0,
    MaxAttempts = 3,
    Verified = false,
    SavedKeys = {}
}

-- Check for key file and load keys
local function LoadKeysFromFile()
    if not isfile or not isfile(Config.KeyFile) then return end
    
    local success, content = pcall(readfile, Config.KeyFile)
    if success and content then
        for key in content:gmatch("[^\r\n]+") do
            if key ~= "" then
                table.insert(KeySystem.SavedKeys, key)
            end
        end
    end
end

-- Save key to file
local function SaveKeyToFile(key)
    if not writefile then return false end
    local success = pcall(function()
        writefile(Config.KeyFile, key)
    end)
    return success
end

-- Validate key against saved keys
local function ValidateKey(input)
    input = input:upper():gsub("%s+", "")
    
    -- Check saved keys
    for _, key in pairs(KeySystem.SavedKeys) do
        if input == key then
            KeySystem.Verified = true
            return true
        end
    end
    
    KeySystem.Attempts = KeySystem.Attempts + 1
    return false
end

-- Create the UI
local function CreateLoader()
    local player = Players.LocalPlayer
    local gui = Instance.new("ScreenGui")
    gui.Name = "LucentLoader"
    gui.ResetOnSpawn = false
    gui.Parent = player:WaitForChild("PlayerGui")
    
    -- Main container
    local container = Instance.new("Frame")
    container.Size = UDim2.new(0, 350, 0, 450)
    container.Position = UDim2.new(0.5, 0, 0.5, 0)
    container.AnchorPoint = Vector2.new(0.5, 0.5)
    container.BackgroundColor3 = Config.Colors.Background
    container.BackgroundTransparency = 0.1
    container.Parent = gui
    
    -- Stylish outline
    local outline = Instance.new("UIStroke")
    outline.Color = Config.Colors.Primary
    outline.Thickness = 2
    outline.Transparency = 0.5
    outline.Parent = container
    
    -- Rounded corners
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 12)
    corner.Parent = container
    
    -- Title
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, -20, 0, 40)
    title.Position = UDim2.new(0, 10, 0, 10)
    title.BackgroundTransparency = 1
    title.Text = "LUCENT LOADER"
    title.TextColor3 = Config.Colors.Primary
    title.Font = Enum.Font.GothamBlack
    title.TextSize = 24
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Parent = container
    
    -- Key input box
    local keyInput = Instance.new("TextBox")
    keyInput.Size = UDim2.new(1, -40, 0, 40)
    keyInput.Position = UDim2.new(0, 20, 0, 70)
    keyInput.BackgroundColor3 = Config.Colors.Button
    keyInput.BackgroundTransparency = 0.5
    keyInput.PlaceholderText = "Enter key from Discord"
    keyInput.Text = ""
    keyInput.TextColor3 = Config.Colors.Text
    keyInput.Font = Enum.Font.GothamMedium
    keyInput.TextSize = 14
    keyInput.Parent = container
    
    -- Auto-fill if we have saved keys
    if #KeySystem.SavedKeys > 0 then
        keyInput.Text = KeySystem.SavedKeys[1]
    end
    
    local inputCorner = Instance.new("UICorner")
    inputCorner.CornerRadius = UDim.new(0, 8)
    inputCorner.Parent = keyInput
    
    -- Status label
    local status = Instance.new("TextLabel")
    status.Size = UDim2.new(1, -20, 0, 60)
    status.Position = UDim2.new(0, 10, 0, 120)
    status.BackgroundTransparency = 1
    status.Text = #KeySystem.SavedKeys > 0 and "Key loaded from file" or "Get key from our Discord"
    status.TextColor3 = Config.Colors.Text
    status.Font = Enum.Font.GothamMedium
    status.TextSize = 16
    status.TextWrapped = true
    status.Parent = container
    
    -- Progress bar
    local progressContainer = Instance.new("Frame")
    progressContainer.Size = UDim2.new(1, -40, 0, 8)
    progressContainer.Position = UDim2.new(0, 20, 0, 190)
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
    
    -- Verify button
    local verifyBtn = Instance.new("TextButton")
    verifyBtn.Size = UDim2.new(1, -40, 0, 40)
    verifyBtn.Position = UDim2.new(0, 20, 0, 210)
    verifyBtn.BackgroundColor3 = Config.Colors.Primary
    verifyBtn.BackgroundTransparency = 0.3
    verifyBtn.Text = "VERIFY KEY"
    verifyBtn.TextColor3 = Config.Colors.Text
    verifyBtn.Font = Enum.Font.GothamBold
    verifyBtn.TextSize = 14
    verifyBtn.Parent = container
    
    local verifyCorner = Instance.new("UICorner")
    verifyCorner.CornerRadius = UDim.new(0, 8)
    verifyCorner.Parent = verifyBtn
    
    -- Discord button
    local discordBtn = Instance.new("TextButton")
    discordBtn.Size = UDim2.new(1, -40, 0, 40)
    discordBtn.Position = UDim2.new(0, 20, 0, 260)
    discordBtn.BackgroundColor3 = Color3.fromRGB(88, 101, 242)
    discordBtn.Text = "GET KEY FROM DISCORD"
    discordBtn.TextColor3 = Config.Colors.Text
    discordBtn.Font = Enum.Font.GothamBold
    discordBtn.TextSize = 14
    discordBtn.Parent = container
    
    local discordCorner = Instance.new("UICorner")
    discordCorner.CornerRadius = UDim.new(0, 8)
    discordCorner.Parent = discordBtn
    
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
    local tween = TweenService:Create(object, TweenInfo.new(duration or 0.5, Enum.EasingStyle.Quint), properties)
    tween:Play()
    return tween
end

-- Loading sequence
local function LoadingSequence(ui, callback)
    -- Initial animation
    ui.Container.Size = UDim2.new(0, 0, 0, 0)
    Animate(ui.Container, {Size = UDim2.new(0, 350, 0, 450)})
    
    -- Loading steps
    local steps = {
        {"VERIFYING KEY...", 0.4},
        {"CONNECTING...", 0.3},
        {"LOADING ASSETS...", 0.6},
        {"INITIALIZING...", 0.5},
        {"LAUNCHING SCRIPT...", 0.4}
    }
    
    for i, step in ipairs(steps) do
        ui.Status.Text = step[1]
        Animate(ui.ProgressBar, {Size = UDim2.new(i/#steps, 0, 1, 0)}, step[2])
        Animate(ui.Status, {TextTransparency = 0.3}, 0.2)
        wait(0.2)
        Animate(ui.Status, {TextTransparency = 0}, 0.2)
        wait(step[2] - 0.4)
    end
    
    callback()
end

-- Main function
local function StartLoader()
    -- Load any saved keys first
    LoadKeysFromFile()
    
    local UI = CreateLoader()
    
    -- Auto-dimmer after 5 seconds
    coroutine.wrap(function()
        wait(Config.FadeDelay)
        if UI.Gui.Parent then
            Animate(UI.Container, {BackgroundTransparency = 0.5})
            Animate(UI.Container.UIStroke, {Transparency = 0.7})
        end
    end)()
    
    -- Verify button
    UI.VerifyBtn.MouseButton1Click:Connect(function()
        if KeySystem.Attempts >= KeySystem.MaxAttempts then
            UI.Status.Text = "MAX ATTEMPTS REACHED\nJOIN OUR DISCORD FOR HELP"
            UI.Status.TextColor3 = Config.Colors.Error
            return
        end
        
        if UI.KeyInput.Text == "" then
            UI.Status.Text = "PLEASE ENTER A KEY"
            UI.Status.TextColor3 = Config.Colors.Error
            return
        end
        
        if ValidateKey(UI.KeyInput.Text) then
            -- Save the valid key to file
            if SaveKeyToFile(UI.KeyInput.Text) then
                LoadingSequence(UI, function()
                    local gameId = game.PlaceId
                    local gameData = Config.SupportedGames[gameId]
                    
                    if gameData then
                        -- Game is supported
                        UI.Status.Text = gameData.Name.."\nLAUNCHED SUCCESSFULLY"
                        UI.Status.TextColor3 = Config.Colors.Success
                        Animate(UI.ProgressBar, {BackgroundColor3 = Config.Colors.Success})
                        
                        -- Execute game script
                        pcall(gameData.Exec)
                        
                        -- Close after delay with animation
                        wait(1.5)
                        Animate(UI.Container, {
                            Size = UDim2.new(0, 0, 0, 0),
                            Position = UDim2.new(0.5, 0, 0.5, 0),
                            BackgroundTransparency = 1
                        }).Completed:Wait()
                        UI.Gui:Destroy()
                    else
                        -- Game not supported
                        UI.Status.Text = "GAME NOT SUPPORTED\nJOIN TO REQUEST IT"
                        UI.Status.TextColor3 = Config.Colors.Error
                    end
                end)
            else
                UI.Status.Text = "FAILED TO SAVE KEY\nTRY AGAIN"
                UI.Status.TextColor3 = Config.Colors.Error
            end
        else
            UI.Status.Text = string.format("INVALID KEY (%d/%d ATTEMPTS)", KeySystem.Attempts, KeySystem.MaxAttempts)
            UI.Status.TextColor3 = Config.Colors.Error
            
            -- Shake animation
            local shake = {10, -8, 6, -4, 2, 0}
            for _, offset in ipairs(shake) do
                UI.KeyInput.Position = UDim2.new(0, 20 + offset, 0, 70)
                wait(0.05)
            end
        end
    end)
    
    -- Discord button
    UI.DiscordBtn.MouseButton1Click:Connect(function()
        if setclipboard then
            setclipboard(Config.Discord)
            UI.Status.Text = "DISCORD LINK COPIED!\nJOIN TO GET YOUR KEY"
            UI.Status.TextColor3 = Config.Colors.Primary
        end
    end)
end

-- Start the loader
StartLoader()
