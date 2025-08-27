--// Lucent Loader (Universal)
--// 2025-08-27

-- CONFIG
local C = {
    Colors = {
        Primary = Color3.fromRGB(0,170,255),
        Secondary = Color3.fromRGB(50,200,255),
        Background = Color3.fromRGB(20,20,30),
        Text = Color3.fromRGB(245,245,245),
        Error = Color3.fromRGB(255,80,80),
        Success = Color3.fromRGB(80,255,80),
        Button = Color3.fromRGB(60,60,70)
    },
    Discord = "https://discord.gg/94ZzwjX2UE",
    ValidKeys = "STXR2020",
    KeyFile = "LucentKey.txt",
    UniversalHubURL = "https://raw.githubusercontent.com/lucent-hub/Lucent/refs/heads/main/Extra/deepseek_lua_20250827_58ceaa.lua"
}

-- HELPER TABLE
local K = {Attempts=0, MaxAttempts=3, Verified=false, SavedKeys={}}

-- LOAD SAVED KEYS
local function LoadKeys()
    if not isfile or not isfile(C.KeyFile) then return end
    local s, c = pcall(readfile, C.KeyFile)
    if s and c then
        for k in c:gmatch("[^\r\n]+") do
            if k~="" then table.insert(K.SavedKeys,k) end
        end
    end
end

-- SAVE KEY
local function SaveKey(k)
    if not writefile then return false end
    local s = pcall(function() writefile(C.KeyFile, k) end)
    return s
end

-- VERIFY KEY
local function VerifyKey(i)
    i = i:upper():gsub("%s+","")
    for _,k in pairs(K.SavedKeys) do
        if i == k then K.Verified = true return true end
    end
    if i == C.ValidKeys then K.Verified = true return true end
    K.Attempts = K.Attempts + 1
    return false
end

-- CREATE GUI
local function CreateGUI()
    local P = game:GetService("Players")
    local player = P.LocalPlayer
    local g = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
    g.Name = "LucentLoader"

    local c = Instance.new("Frame", g)
    c.Size = UDim2.new(0,350,0,500)
    c.Position = UDim2.new(0.5,0,0.5,0)
    c.AnchorPoint = Vector2.new(0.5,0.5)
    c.BackgroundColor3 = C.Colors.Background
    c.BackgroundTransparency = 0.1
    Instance.new("UIStroke",c).Color = C.Colors.Primary
    Instance.new("UICorner",c).CornerRadius = UDim.new(0,12)

    local t = Instance.new("TextLabel",c)
    t.Size = UDim2.new(1,-20,0,40)
    t.Position = UDim2.new(0,10,0,10)
    t.BackgroundTransparency = 1
    t.Text = "LUCENT LOADER"
    t.TextColor3 = C.Colors.Primary
    t.Font = Enum.Font.GothamBlack
    t.TextSize = 24
    t.TextXAlignment = Enum.TextXAlignment.Left

    local k = Instance.new("TextBox",c)
    k.Size = UDim2.new(1,-40,0,40)
    k.Position = UDim2.new(0,20,0,70)
    k.BackgroundColor3 = C.Colors.Button
    k.BackgroundTransparency = 0.5
    k.PlaceholderText = "Enter key from Discord"
    k.TextColor3 = C.Colors.Text
    k.Font = Enum.Font.GothamMedium
    k.TextSize = 14
    Instance.new("UICorner",k).CornerRadius = UDim.new(0,8)

    local s = Instance.new("TextLabel",c)
    s.Size = UDim2.new(1,-20,0,60)
    s.Position = UDim2.new(0,10,0,120)
    s.BackgroundTransparency = 1
    s.Text = "Get key from our Discord"
    s.TextColor3 = C.Colors.Text
    s.Font = Enum.Font.GothamMedium
    s.TextSize = 16
    s.TextWrapped = true

    local pc = Instance.new("Frame",c)
    pc.Size = UDim2.new(1,-40,0,8)
    pc.Position = UDim2.new(0,20,0,190)
    pc.BackgroundColor3 = Color3.fromRGB(40,40,50)

    local pb = Instance.new("Frame",pc)
    pb.Size = UDim2.new(0,0,1,0)
    pb.BackgroundColor3 = C.Colors.Primary
    Instance.new("UICorner",pb).CornerRadius = UDim.new(1,0)

    local vb = Instance.new("TextButton",c)
    vb.Size = UDim2.new(1,-40,0,40)
    vb.Position = UDim2.new(0,20,0,210)
    vb.BackgroundColor3 = C.Colors.Primary
    vb.BackgroundTransparency = 0.3
    vb.Text = "VERIFY KEY"
    vb.TextColor3 = C.Colors.Text
    vb.Font = Enum.Font.GothamBold
    vb.TextSize = 14
    Instance.new("UICorner",vb).CornerRadius = UDim.new(0,8)

    local db = Instance.new("TextButton",c)
    db.Size = UDim2.new(1,-40,0,40)
    db.Position = UDim2.new(0,20,0,260)
    db.BackgroundColor3 = Color3.fromRGB(88,101,242)
    db.Text = "GET KEY FROM DISCORD"
    db.TextColor3 = C.Colors.Text
    db.Font = Enum.Font.GothamBold
    db.TextSize = 14
    Instance.new("UICorner",db).CornerRadius = UDim.new(0,8)

    return {Gui=g,Container=c,KeyInput=k,Status=s,ProgressBar=pb,VerifyBtn=vb,DiscordBtn=db}
end

-- TWEEN
local T = game:GetService("TweenService")
local function Tween(obj,props,duration)
    local t = T:Create(obj,TweenInfo.new(duration or 0.5,Enum.EasingStyle.Quint),props)
    t:Play()
    return t
end

-- LOADER ANIMATION
local function FakeLoad(ui,callback)
    ui.Container.Size = UDim2.new(0,0,0,0)
    Tween(ui.Container,{Size=UDim2.new(0,350,0,500)})
    local steps={{"VERIFYING KEY...",0.4},{"CONNECTING...",0.3},{"LOADING ASSETS...",0.6},{"INITIALIZING...",0.5},{"LAUNCHING HUB...",0.4}}
    for i,s in ipairs(steps) do
        ui.Status.Text = s[1]
        Tween(ui.ProgressBar,{Size=UDim2.new(i/#steps,0,1,0)},s[2])
        task.wait(s[2])
    end
    callback()
end

-- MAIN LOADER
local function StartLoader()
    LoadKeys()
    local UI = CreateGUI()
    if #K.SavedKeys > 0 then
        UI.KeyInput.Text = K.SavedKeys[1]
        UI.Status.Text = "Key loaded from file"
    else
        UI.KeyInput.Text = C.ValidKeys
        UI.Status.Text = "Get key from our Discord"
    end

    UI.VerifyBtn.MouseButton1Click:Connect(function()
        if K.Attempts>=K.MaxAttempts then
            UI.Status.Text = "MAX ATTEMPTS REACHED\nJOIN OUR DISCORD FOR HELP"
            UI.Status.TextColor3 = C.Colors.Error
            return
        end
        if UI.KeyInput.Text == "" then
            UI.Status.Text = "PLEASE ENTER A KEY"
            UI.Status.TextColor3 = C.Colors.Error
            return
        end
        if VerifyKey(UI.KeyInput.Text) then
            if SaveKey(UI.KeyInput.Text) then
                FakeLoad(UI,function()
                    UI.Status.Text = "SUCCESS!"
                    UI.Status.TextColor3 = C.Colors.Success
                    Tween(UI.ProgressBar,{BackgroundColor3=C.Colors.Success})
                    -- launch universal script in ANY game
                    pcall(function()
                        loadstring(game:HttpGet(C.UniversalHubURL))()
                    end)
                    task.wait(1.5)
                    Tween(UI.Container,{Size=UDim2.new(0,0,0,0),BackgroundTransparency=1},0.7).Completed:Wait()
                    UI.Gui:Destroy()
                end)
            else
                UI.Status.Text = "FAILED TO SAVE KEY\nTRY AGAIN"
                UI.Status.TextColor3 = C.Colors.Error
            end
        else
            UI.Status.Text = string.format("INVALID KEY (%d/%d ATTEMPTS)",K.Attempts,K.MaxAttempts)
            UI.Status.TextColor3 = C.Colors.Error
        end
    end)

    UI.DiscordBtn.MouseButton1Click:Connect(function()
        if setclipboard then
            setclipboard(C.Discord)
            UI.Status.Text = "DISCORD LINK COPIED!\nJOIN TO GET YOUR KEY"
            UI.Status.TextColor3 = C.Colors.Primary
        end
    end)
end

StartLoader()
