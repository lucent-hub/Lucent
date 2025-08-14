--[[
-- ╔╦╦╦╦╦╦╦╦╦╦╦╦╦╦╦╦╦╦╦╦╦╦╦╦╦╦╦╦╦╦╦╦╦╦╦╦╦╦╦╦╦╦╦╦╦╦╦╦╦╦╦╦╦╦╦╦╦╦╦╦╗
-- ╠╬╩╩╩╩╩╩╩╩╩╩╩╩╩╩╩╩╩╩╩╩╩╩╩╩╩╩╩╩╩╩╩╩╩╩╩╩╩╩╩╩╩╩╩╩╩╩╩╩╩╩╩╩╩╩╩╩╩╩╬╣
-- ╠╣.____     ____ ____________ ___________ __________________.         ╠╣
-- ╠╣|    |   |    |   \_   ___ \\_   _____/ \      \__    ___/.         ╠╣
-- ╠╣|    |   |    |   /    \  \/ |    __)_  /   |   \|    |             ╠╣
-- ╠╣|    |___|    |  /\     \____|        \/    |    \    |             ╠╣
-- ╠╣|_______ \______/  \______  /_______  /\____|__  /____|             ╠╣
-- ╠╣        \/                \/        \/         \/                   ╠╣
-- ╠╬╦╦╦╦╦╦╦╦╦╦╦╦╦╦╦╦╦╦╦╦╦╦╦╦╦╦╦╦╦╦╦╦╦╦╦╦╦╦╦╦╦╦╦╦╦╦╦╦╦╦╦╦╦╦╦╦╦╦╬╣
-- ╚╩╩╩╩╩╩╩╩╩╩╩╩╩╩╩╩╩╩╩╩╩╩╩╩╩╩╩╩╩╩╩╩╩╩╩╩╩╩╩╩╩╩╩╩╩╩╩╩╩╩╩╩╩╩╩╩╩╩╩╩╝
                   ꧁https://discord.gg/zvVVXb9sfW꧂
]]

-- helper w stuff yk
local P=game:GetService("Players")
local T=game:GetService("TweenService")

-- confger
local C={
    Colors={
        Primary=Color3.fromRGB(0,170,255),
        Secondary=Color3.fromRGB(50,200,255),
        Background=Color3.fromRGB(20,20,30),
        Text=Color3.fromRGB(245,245,245),
        Error=Color3.fromRGB(255,80,80),
        Success=Color3.fromRGB(80,255,80),
        Button=Color3.fromRGB(60,60,70)
    },
    Discord="https://discord.gg/SdTStha6p3",
    ValidKeys="STXR2020",
    KeyFile="LucentKey.txt",
    SupportedGames={
        [12355337193]={Name="Murderers VS Sheriffs DUELS",Exec=loadstring(game:HttpGet("https://raw.githubusercontent.com/tbao143/thaibao/main/TbaoHubMurdervssheriff"))},
        [2788229376]={Name="Dahood - some errors...",Exec=loadstring(game:HttpGet("https://raw.githubusercontent.com/lucent-hub/Lucent/refs/heads/main/Script/Da%20hood/Code.lua"))}
    },
    ParticleDensity=50,
    FadeDelay=5,
    UniversalHubID=1234567890 -- Place ID for universal hub
}

-- Key sys
local K={Attempts=0,MaxAttempts=3,Verified=false,SavedKeys={}}

local function L()
    if not isfile or not isfile(C.KeyFile) then return end
    local s,c=pcall(readfile,C.KeyFile)
    if s and c then
        for k in c:gmatch("[^\r\n]+") do
            if k~="" then table.insert(K.SavedKeys,k) end
        end
    end
end

local function S(k)
    if not writefile then return false end
    local s=pcall(function() writefile(C.KeyFile,k) end)
    return s
end

local function V(i)
    i=i:upper():gsub("%s+","")
    for _,k in pairs(K.SavedKeys) do if i==k then K.Verified=true return true end end
    if i==C.ValidKeys then K.Verified=true return true end
    K.Attempts=K.Attempts+1
    return false
end

-- GUI 
local function G()
    local p=P.LocalPlayer
    local g=Instance.new("ScreenGui",p:WaitForChild("PlayerGui"))
    g.Name="LucentLoader"
    
    local c=Instance.new("Frame",g)
    c.Size=UDim2.new(0,350,0,500)
    c.Position=UDim2.new(0.5,0,0.5,0)
    c.AnchorPoint=Vector2.new(0.5,0.5)
    c.BackgroundColor3=C.Colors.Background
    c.BackgroundTransparency=0.1
    
    local o=Instance.new("UIStroke",c)
    o.Color=C.Colors.Primary
    o.Thickness=2
    o.Transparency=0.5
    
    local u=Instance.new("UICorner",c)
    u.CornerRadius=UDim.new(0,12)
    
    local t=Instance.new("TextLabel",c)
    t.Size=UDim2.new(1,-20,0,40)
    t.Position=UDim2.new(0,10,0,10)
    t.BackgroundTransparency=1
    t.Text="LUCENT LOADER"
    t.TextColor3=C.Colors.Primary
    t.Font=Enum.Font.GothamBlack
    t.TextSize=24
    t.TextXAlignment=Enum.TextXAlignment.Left
    
    local k=Instance.new("TextBox",c)
    k.Size=UDim2.new(1,-40,0,40)
    k.Position=UDim2.new(0,20,0,70)
    k.BackgroundColor3=C.Colors.Button
    k.BackgroundTransparency=0.5
    k.PlaceholderText="Enter key from Discord"
    k.Text=""
    k.TextColor3=C.Colors.Text
    k.Font=Enum.Font.GothamMedium
    k.TextSize=14
    Instance.new("UICorner",k).CornerRadius=UDim.new(0,8)
    
    local s=Instance.new("TextLabel",c)
    s.Size=UDim2.new(1,-20,0,60)
    s.Position=UDim2.new(0,10,0,120)
    s.BackgroundTransparency=1
    s.Text="Get key from our Discord"
    s.TextColor3=C.Colors.Text
    s.Font=Enum.Font.GothamMedium
    s.TextSize=16
    s.TextWrapped=true
    
    local pc=Instance.new("Frame",c)
    pc.Size=UDim2.new(1,-40,0,8)
    pc.Position=UDim2.new(0,20,0,190)
    pc.BackgroundColor3=Color3.fromRGB(40,40,50)
    
    local pb=Instance.new("Frame",pc)
    pb.Size=UDim2.new(0,0,1,0)
    pb.BackgroundColor3=C.Colors.Primary
    Instance.new("UICorner",pb).CornerRadius=UDim.new(1,0)
    
    local vb=Instance.new("TextButton",c)
    vb.Size=UDim2.new(1,-40,0,40)
    vb.Position=UDim2.new(0,20,0,210)
    vb.BackgroundColor3=C.Colors.Primary
    vb.BackgroundTransparency=0.3
    vb.Text="VERIFY KEY"
    vb.TextColor3=C.Colors.Text
    vb.Font=Enum.Font.GothamBold
    vb.TextSize=14
    Instance.new("UICorner",vb).CornerRadius=UDim.new(0,8)
    
    local db=Instance.new("TextButton",c)
    db.Size=UDim2.new(1,-40,0,40)
    db.Position=UDim2.new(0,20,0,260)
    db.BackgroundColor3=Color3.fromRGB(88,101,242)
    db.Text="GET KEY FROM DISCORD"
    db.TextColor3=C.Colors.Text
    db.Font=Enum.Font.GothamBold
    db.TextSize=14
    Instance.new("UICorner",db).CornerRadius=UDim.new(0,8)
    
    local uhb=Instance.new("TextButton",c)
    uhb.Size=UDim2.new(1,-40,0,40)
    uhb.Position=UDim2.new(0,20,0,310)
    uhb.BackgroundColor3=Color3.fromRGB(255,150,50)
    uhb.Text="LAUNCH UNIVERSAL HUB"
    uhb.TextColor3=C.Colors.Text
    uhb.Font=Enum.Font.GothamBold
    uhb.TextSize=14
    uhb.Visible=false -- hidden by default
    Instance.new("UICorner",uhb).CornerRadius=UDim.new(0,8)
    
    return {Gui=g,Container=c,KeyInput=k,Status=s,ProgressBar=pb,VerifyBtn=vb,DiscordBtn=db,UniversalHubBtn=uhb}
end

-- Tween anim ykyk 
local function A(o,p,d)
    local tween=T:Create(o,TweenInfo.new(d or 0.5,Enum.EasingStyle.Quint),p)
    tween:Play()
    return tween
end

-- shitty ass loader
local function F(ui,cb)
    ui.Container.Size=UDim2.new(0,0,0,0)
    A(ui.Container,{Size=UDim2.new(0,350,0,500)})
    local steps={{"VERIFYING KEY...",0.4},{"CONNECTING...",0.3},{"LOADING ASSETS...",0.6},{"INITIALIZING...",0.5},{"LAUNCHING SCRIPT...",0.4}}
    for i,s in ipairs(steps) do
        ui.Status.Text=s[1]
        A(ui.ProgressBar,{Size=UDim2.new(i/#steps,0,1,0)},s[2])
        wait(s[2])
    end
    cb()
end

-- Loader
local function SL()
    L()
    local U=G()
    if #K.SavedKeys>0 then
        U.KeyInput.Text=K.SavedKeys[1]
        U.Status.Text="Key loaded from file"
    else
        U.KeyInput.Text=C.ValidKeys
        U.Status.Text="Get key from our Discord"
    end
    
    U.VerifyBtn.MouseButton1Click:Connect(function()
        if K.Attempts>=K.MaxAttempts then
            U.Status.Text="MAX ATTEMPTS REACHED\nJOIN OUR DISCORD FOR HELP"
            U.Status.TextColor3=C.Colors.Error
            return
        end
        if U.KeyInput.Text=="" then
            U.Status.Text="PLEASE ENTER A KEY"
            U.Status.TextColor3=C.Colors.Error
            return
        end
        if V(U.KeyInput.Text) then
            if S(U.KeyInput.Text) then
                F(U,function()
                    local gId=game.PlaceId
                    local gD=C.SupportedGames[gId]
                    if gD then
                        U.Status.Text=gD.Name.."\nLAUNCHED SUCCESSFULLY"
                        U.Status.TextColor3=C.Colors.Success
                        A(U.ProgressBar,{BackgroundColor3=C.Colors.Success})
                        pcall(gD.Exec)
                        wait(1.5)
                        A(U.Container,{Size=UDim2.new(0,0,0,0),Position=UDim2.new(0.5,0,0.5,0),BackgroundTransparency=1}).Completed:Wait()
                        U.Gui:Destroy()
                    else
                        U.Status.Text="GAME NOT SUPPORTED\nLAUNCH UNIVERSAL HUB?"
                        U.Status.TextColor3=C.Colors.Error
                        U.UniversalHubBtn.Visible=true
                    end
                end)
            else
                U.Status.Text="FAILED TO SAVE KEY\nTRY AGAIN"
                U.Status.TextColor3=C.Colors.Error
            end
        else
            U.Status.Text=string.format("INVALID KEY (%d/%d ATTEMPTS)",K.Attempts,K.MaxAttempts)
            U.Status.TextColor3=C.Colors.Error
        end
    end)
    
    U.DiscordBtn.MouseButton1Click:Connect(function()
        if setclipboard then
            setclipboard(C.Discord)
            U.Status.Text="DISCORD LINK COPIED!\nJOIN TO GET YOUR KEY"
            U.Status.TextColor3=C.Colors.Primary
        end
    end)
    
    U.UniversalHubBtn.MouseButton1Click:Connect(function()
        F(U,function()
            U.Status.Text="LAUNCHING UNIVERSAL HUB..."
            U.Status.TextColor3=C.Colors.Primary
            pcall(function()
                loadstring(game:HttpGet("https://raw.githubusercontent.com/lucent-hub/Lucent/main/Extra/UniversalHub.lua"))()
            end)
            wait(1)
            U.Gui:Destroy()
        end)
    end)
end

SL()
