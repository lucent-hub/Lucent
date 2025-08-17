repeat task.wait(0.25) until game:IsLoaded();
getgenv().Image = "rbxassetid://102535316350486"; -- put a asset id in here to make it work, default is mspaint logo
getgenv().ToggleUI = "LeftAlt" -- Make sure this matches with Fluent Minimize Keybind or it will not work

task.spawn(function()
    if not getgenv().LoadedMobileUI == true then getgenv().LoadedMobileUI = true
        local OpenUI = Instance.new("ScreenGui");
        local ImageButton = Instance.new("ImageButton");
        local UICorner = Instance.new("UICorner");
        OpenUI.Name = "OpenUI";
        OpenUI.Parent = game:GetService("CoreGui");
        OpenUI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling;
        ImageButton.Parent = OpenUI;
        ImageButton.BackgroundColor3 = Color3.fromRGB(105,105,105);
        ImageButton.BackgroundTransparency = 0.8
        ImageButton.Position = UDim2.new(0.9,0,0.1,0);
        ImageButton.Size = UDim2.new(0,50,0,50);
        ImageButton.Image = getgenv().Image;
        ImageButton.Draggable = true;
        ImageButton.Transparency = 1;
        UICorner.CornerRadius = UDim.new(0,200);
        UICorner.Parent = ImageButton;
        ImageButton.MouseButton1Click:Connect(function()
            game:GetService("VirtualInputManager"):SendKeyEvent(true,getgenv().ToggleUI,false,game);
        end)
    end
end)


-- switched the ui for something cleaner
-- small changes to auto generator (will now check if it actually started using it, also twice as fast literally)
-- added misc tab (Allow Jump, 	No Fog, Reset Character, Rejoin)
-- added inf jump (pretty shit lmao)
-- fixed kill all not stopping after being stuck on the same player for more than 15 seconds

local l = loadstring(game:HttpGet("https://raw.githubusercontent.com/laagginq/ui-libraries/main/dxhooknotify/src.lua", true))()
l:Notify("Wait up","wait this shyt finish",5)
                                    
_G.yeaican = false
if not _G.yeaican then
    if _G.ialreadyloadedit then
        print("bro, fuck no")
		return
    else
        _G.ialreadyloadedit = true
    end
end
writefile("banger.mp3", game:HttpGet("https://github.com/fuckg1thub/assets/raw/refs/heads/main/banger.mp3"))

local library = loadstring(game:HttpGet("https://raw.githubusercontent.com/fuckg1thub/Fluent-Inspired-UI/refs/heads/main/fiui.luau"))()
local window = library.Window("Lucent hub", "Forsaken", "rbxassetid://102535316350486", false, Color3.fromRGB(150, 63, 204))
local mainTab = window:Tab("Main", "rbxassetid://101966922795157")
local generatorsSection = mainTab:AddSection("Generators")
local killersSection = mainTab:AddSection("Killers")
local survivorsSection = mainTab:AddSection("Survivors")
local itemsSection = mainTab:AddSection("Items")

local generatorsDid = {}

local kasjdkasjda = true

generatorsSection.Toggle("Generators ESP", function(bool)
    _G.generators = bool
    task.spawn(function()
        while task.wait() do
            if _G.generators then
                pcall(function()
                    for i, v in pairs(workspace.Map.Ingame.Map:GetChildren()) do
                        if v.Name == "Generator" and not v:FindFirstChild("iskiddedfromneptz") then
                            local hl = Instance.new("Highlight", v)
                            hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                            hl.Name = "iskiddedfromneptz"
                            hl.FillColor = Color3.fromRGB(255, 255, 51)
                        elseif v:FindFirstChild("iskiddedfromneptz") and v.Name == "Generator" then
                            if v.Progress.Value >= 100 then
                                v.iskiddedfromneptz.FillColor = Color3.fromRGB(0, 255, 0)
                            end
                        end
                    end
                end)
            else
                pcall(function()
                    for i, v in pairs(workspace.Map.Ingame.Map:GetChildren()) do
                        if v.Name == "Generator" and v:FindFirstChild("iskiddedfromneptz") then
                            v.iskiddedfromneptz:Destroy()
                        end
                    end
                end)
                break
            end
        end
    end)
end)
generatorsSection.Toggle("Instant Generator", function(bool)
    _G.instantGenerator = bool
    task.spawn(function()
        while _G.instantGenerator and task.wait() do
            if workspace.Map.Ingame:FindFirstChild("Map") then
                pcall(function()
                    for i, v in pairs(workspace.Map.Ingame.Map:GetChildren()) do
                        if not generatorsDid[v] and v.Name == "Generator" then
                            generatorsDid[v] = true
                            local old; old = hookfunction(getsenv(v.Scripts.Client).toggleGeneratorState, function(a)
                                if not _G.instantGenerator then return old(a) end
                                if a ~= "enter" then return old("leave") end
                                local ou = v.Remotes.RF:InvokeServer("enter")
                                if ou ~= "fixing" then return end
                                for i = 1, 4 do
                                    if v.Progress.Value >= 100 then break end
                                    game.StarterGui:SetCore("SendNotification",
                                        { Title = "generator", Text = tostring(i), Duration = 9 })
                                    v.Remotes.RE:FireServer()
                                    task.wait(1.2)
                                end
                                return ""
                            end)
                        end
                    end
                end)
            end
        end
    end)
end)

killersSection.Toggle("Killer ESP", function(bool)
    _G.killers = bool
    task.spawn(function()
        while task.wait() do
            if _G.killers == true then
                for i, v in pairs(workspace.Players.Killers:GetChildren()) do
                    if not v:FindFirstChild("iskiddedfromneptz") then
                        local hl = Instance.new("Highlight", v)
                        hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                        hl.Name = "iskiddedfromneptz"
                    end
                end
            else
                for i, v in pairs(workspace.Players.Killers:GetChildren()) do
                    if v:FindFirstChild("iskiddedfromneptz") then
                        v.iskiddedfromneptz:Destroy()
                    end
                end
                break
            end
        end
    end)
end)
survivorsSection.Toggle("Survivors ESP", function(bool)
    _G.survivors = bool
    task.spawn(function()
        while task.wait() do
            if _G.survivors == true then
                for i, v in pairs(workspace.Players.Survivors:GetChildren()) do
                    if not v:FindFirstChild("iskiddedfromneptz") then
                        local hl = Instance.new("Highlight", v)
                        hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                        hl.Name = "iskiddedfromneptz"
                        hl.FillColor = Color3.fromRGB(0, 0, 255)
                    end
                end
            else
                for i, v in pairs(workspace.Players.Survivors:GetChildren()) do
                    if v:FindFirstChild("iskiddedfromneptz") then
                        v.iskiddedfromneptz:Destroy()
                    end
                end
                break
            end
        end
    end)
end)
itemsSection.Toggle("Items ESP", function(bool)
    _G.items = bool
    task.spawn(function()
        while task.wait() do
            if _G.items == true then
                pcall(function()
                    for i, v in pairs(workspace.Map.Ingame.Map:GetChildren()) do
                        if v:IsA("Tool") and not v:FindFirstChild("iskiddedfromneptz") then
                            local hl = Instance.new("Highlight", v)
                            hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                            hl.Name = "iskiddedfromneptz"
                            hl.FillColor = Color3.fromRGB(0, 255, 255)
                        end
                    end
                end)
            else
                pcall(function()
                    for i, v in pairs(workspace.Map.Ingame.Map:GetChildren()) do
                        if v:IsA("Tool") and v:FindFirstChild("iskiddedfromneptz") then
                            v.iskiddedfromneptz:Destroy()
                        end
                    end
                end)
                break
            end
        end
    end)
end)
local playerTab = window:Tab("Local Player", "rbxassetid://73140121358767")
playerTab:AddSection("Stamina").Button("Infinite Stamina", function()
    require(game:GetService("ReplicatedStorage").Systems.Character.Game.Sprinting).DefaultConfig.MaxStamina = 9999
    require(game:GetService("ReplicatedStorage").Systems.Character.Game.Sprinting).DefaultConfig.StaminaLoss = 0
    game.StarterGui:SetCore("SendNotification",
        { Title = "warning", Text = "this effect wont apply until next round, but you only have to press it once this entire session", Duration = 9 })
end)

local speedSection = playerTab:AddSection("Speed")
local yeahvariable = 0
speedSection.Slider("Speed (Bypass)", 16, 16, 100, function (s)
    yeahvariable = s
end)
speedSection.Toggle("Speed Toggle", function (s)
    _G.mhhmmm = s
    task.spawn(function ()
        local localPlayer = game:GetService("Players").LocalPlayer
        while task.wait() do
            if not _G.mhhmmm then break end
            local humanoid = localPlayer.Character and localPlayer.Character:FindFirstChild("Humanoid")
            if humanoid and humanoid.MoveDirection ~= Vector3.zero then
                localPlayer.Character:TranslateBy(humanoid.MoveDirection * (yeahvariable / 10) * game:GetService("RunService").RenderStepped:Wait() * 10)
            end
        end
    end)
end)
playerTab:AddSection("Noclip").Toggle("Enable Noclip [⚠️]", function (s)
    if s == true then
         game.StarterGui:SetCore("SendNotification",
        { Title = "KICK WARNING", Text = "you WILL get kicked if you are inside a wall for more than a second! only use for small shortcuts", Duration = 9 })
    end
    _G.nokia = s
    local cachey = {}
    task.spawn(function ()
        local localPlayer = game:GetService("Players").LocalPlayer
        while task.wait() do
            if not _G.nokia then
                for i, v in pairs(cachey) do
                    v.CanCollide = true
                end
                break
            end
            if localPlayer.Character then
                for i, v in pairs(localPlayer.Character:GetChildren()) do
                    if v:IsA("BasePart") then
                        cachey[v] = v
                        v.CanCollide = false
                    end
                end
            end
        end
    end)
end)
playerTab:AddSection("Infinite Jump").Toggle("Infinite Jump", function (s)
    if s == false then
        return _G.connection:Disconnect()
    end
    _G.connection = game:GetService("UserInputService").JumpRequest:Connect(function ()
        pcall(function ()
            game.Players.LocalPlayer.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
        end)
    end)
end)

local killerTab = window:Tab("Killer", "rbxassetid://83038806046146")
local killerSection = killerTab:AddSection("Killer")
killerSection.Toggle("Spectate Killer", function (state)
    if state then
        local killer = workspace.Players.Killers:GetChildren()[1]
        if killer then
            workspace.CurrentCamera.CameraSubject = killer
        end
    else
        pcall(function()
            workspace.CurrentCamera.CameraSubject = game.Players.LocalPlayer.Character
        end)
    end
end)
killerSection.Button("Teleport To Killer", function ()
    local killer = workspace.Players.Killers:GetChildren()[1]
    if killer then
        pcall(function ()
            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = killer.PrimaryPart.CFrame
        end)
    end
end)
killerSection.Button("Kill All [KILLER TEAM]", function()
    for i, v in pairs(workspace.Players.Survivors:GetChildren()) do
        local name = v:GetAttribute("Username")
        local plr = game.Players:FindFirstChild(name)
        if not plr then continue end
        local skipTimeout = tick()
        while tick() - skipTimeout <= 15 do
            if game.Players:FindFirstChild(name) == nil then break end
            if plr.Character == nil then break end
            if plr.Character:FindFirstChild("Humanoid") == nil then break end
            if plr.Character.Humanoid.Health <= 0 then break end
            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = plr.Character.HumanoidRootPart.CFrame
            game:GetService("ReplicatedStorage"):WaitForChild("Modules"):WaitForChild("Network"):WaitForChild("RemoteEvent"):FireServer("UseActorAbility",
                "Slash")
            task.wait()
        end
    end
end)

local teleportsTab = window:Tab("Teleport", "rbxassetid://100658585674886")
local generatorsSection = teleportsTab:AddSection("Generators")
for i = 1, 5 do
    generatorsSection.Button("TP to generator " .. i, function ()
        pcall(function ()
            local gens = {}
            for i, v in pairs(workspace.Map.Ingame.Map:GetChildren()) do
                if v.Name == "Generator" then
                    table.insert(gens, v)
                end
            end
            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = gens[i].PrimaryPart.CFrame + Vector3.new(0, 10, 0)
        end)
    end)
end
local miscTab = window:Tab("Misc", "rbxassetid://85291691462928")
local miscSection = miscTab:AddSection("Miscallenous")
miscSection.Toggle("Allow Jump [⚠️]", function (s)
    _G.mhhmmm2 = s
    if s then
         game.StarterGui:SetCore("SendNotification",
        { Title = "KICK WARNING", Text = "WARNING jumping repeatedly will KICK YOU because the game will think you are flying!", Duration = 9 })
    end
    task.spawn(function ()
        local localPlayer = game:GetService("Players").LocalPlayer
        while task.wait() do
            if not _G.mhhmmm2 then break end
            local humanoid = localPlayer.Character and localPlayer.Character:FindFirstChild("Humanoid")
            if humanoid then
                humanoid.JumpPower = 50
            end
        end
    end)
end)
miscSection.Button("No Fog", function ()
	for i,v in pairs(game.Lighting:GetDescendants()) do
        if not v:IsA("Atmosphere") then continue end
		v:Destroy()
	end
    game.Lighting.FogEnd = 999999
end)
miscSection.Button("Kill Yourself", function ()
    pcall(function ()
        game.Players.LocalPlayer.Character:BreakJoints()
    end)
end)
miscSection.Button("Rejoin", function ()
    pcall(function ()
        game:GetService("TeleportService"):Teleport(game.PlaceId, game.Players.localPlayer)
    end)
end)
miscSection.Button("play tuff musik 2025", function ()
    game.StarterGui:SetCore("SendNotification",
        { Title = "banger musik", Text = "u have activated super secrekt banger music feature ✅✅ only u hear it btw", Duration = 20 })
    local sound = Instance.new("Sound", workspace)
    sound.SoundId = getcustomasset("banger.mp3")
    sound.EmitterSize = 5000
    sound.Looped = true
    sound:Play()
end)
