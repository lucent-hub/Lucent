if not game:IsLoaded() then
    game.Loaded:Wait()
end

getgenv().TranslationCounter = nil
Translations = loadstring(game:HttpGet("https://raw.githubusercontent.com/Articles-Hub/ROBLOXScript/refs/heads/main/Translation/Translation.lua"))()
loadstring(game:HttpGet("https://pastebin.com/raw/3i5ai3SV"))()
repeat task.wait() until TranslationCounter
if game.CoreGui:FindFirstChild("Country") then
game.CoreGui:FindFirstChild("Country"):Destroy()
end
wait(0.3)
local Player = game.Players.LocalPlayer
game:GetService("UserInputService").JumpRequest:connect(function()
	if _G.InfiniteJump == true then
		game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
	end
end)
game.Players.LocalPlayer.Character:FindFirstChild("Humanoid"):GetPropertyChangedSignal("WalkSpeed"):Connect(function()
if _G.AutoSpeed == true then
	if game.Players.LocalPlayer.Character:FindFirstChild("Humanoid") then
		game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = _G.Speed or 50
	end
end
end)
function CheckWall(Target)
    local Direction = (Target.Position - game.Workspace.CurrentCamera.CFrame.Position).unit * (Target.Position - game.Workspace.CurrentCamera.CFrame.Position).Magnitude
    local RaycastParams = RaycastParams.new()
    RaycastParams.FilterDescendantsInstances = {game.Players.LocalPlayer.Character, game.Workspace.CurrentCamera}
    RaycastParams.FilterType = Enum.RaycastFilterType.Blacklist
    local Result = game.Workspace:Raycast(game.Workspace.CurrentCamera.CFrame.Position, Direction, RaycastParams)
    return Result == nil or Result.Instance:IsDescendantOf(Target)
end
function PartLagDe(g)
	for i, v in pairs(_G.PartLag) do
		if g.Name:find(v) then
			g:Destroy()
		end
	end
end
workspace.DescendantAdded:Connect(function(v)
	if _G.AntiLag == true then
		if v:IsA("ForceField") or v:IsA("Sparkles") or v:IsA("Smoke") or v:IsA("Fire") or v:IsA("Beam") then
			v:Destroy()
		end
		if v:IsA("BasePart") then
			v.Material = "Plastic"
			v.Reflectance = 0
			v.BackSurface = "SmoothNoOutlines"
			v.BottomSurface = "SmoothNoOutlines"
			v.FrontSurface = "SmoothNoOutlines"
			v.LeftSurface = "SmoothNoOutlines"
			v.RightSurface = "SmoothNoOutlines"
			v.TopSurface = "SmoothNoOutlines"
		elseif v:IsA("Decal") then
			v.Transparency = 1
		elseif v:IsA("ParticleEmitter") or v:IsA("Trail") then
			v.Lifetime = NumberRange.new(0)
		end
	end
end)

local Name = "Ink Game"
function Translation(Section, Text)
	if TranslationCounter == "English" then
		return Text
	end
	local lang = Translations[TranslationCounter]
	if lang and lang[Name] and lang[Name][Section] and lang[Name][Section][Text] then
		return lang[Name][Section][Text]
	else
		return Text
	end
end

---- Script ----

-- Makes the lib working
_Hawk = "ohhahtuhthttouttpwuttuaunbotwo"

-- Load Hawk library
local Hawk = loadstring(game:HttpGet("https://raw.githubusercontent.com/xwerta/HawkHUB/refs/heads/main/Roblox/UILibs/HawkLib.lua", true))()

-- Creating Window
local Window = Hawk:Window({
    ScriptName = "Lucent Hub - Ink Game",
    DestroyIfExists = true,
    Theme = "Dark"
})

-- Creating Close Button
Window:Close({
    visibility = true,
    Callback = function()
        Window:Destroy()
    end,
})

-- Creating Minimize Button
Window:Minimize({
    visibility = true,
    OpenButton = true,
    Callback = function()
    end,
})

-- Creating Tabs
local MainTab = Window:Tab("Main")
local GreenLightTab = Window:Tab("Green Light")
local DalgonaTab = Window:Tab("Dalgona")
local TugOfWarTab = Window:Tab("Tug of War")
local GlassBridgeTab = Window:Tab("Glass Bridge")
local MarblesTab = Window:Tab("Marbles")
local HopscotchTab = Window:Tab("Hopscotch")
local PlayerTab = Window:Tab("Player")
local ESPTab = Window:Tab("ESP")
local SettingsTab = Window:Tab("Settings")

-- Creating Notifications
local Notifications = Hawk:AddNotifications()

function Notification(Message, Time)
    if _G.ChooseNotify == "Obsidian" then
        Notifications:Notification("Lucent Hub", Message, "Notify", Time or 5)
    elseif _G.ChooseNotify == "Roblox" then
        game:GetService("StarterGui"):SetCore("SendNotification",{Title = "Lucent Hub",Text = Message,Icon = "rbxassetid://7733658504",Duration = Time or 5})
    end
    if _G.NotificationSound then
        local sound = Instance.new("Sound", workspace)
        sound.SoundId = "rbxassetid://4590662766"
        sound.Volume = _G.VolumeTime or 2
        sound.PlayOnRemove = true
        sound:Destroy()
    end
end

-- Green Light Tab Content
GreenLightTab:Section("Green Light, Red Light")

GreenLightTab:Button("Teleport to Finish", function()
    if workspace:FindFirstChild("RedLightGreenLight") and workspace.RedLightGreenLight:FindFirstChild("sand") and workspace.RedLightGreenLight.sand:FindFirstChild("crossedover") then
        local pos = workspace.RedLightGreenLight.sand.crossedover.Position + Vector3.new(0, 5, 0)
        Player.Character.HumanoidRootPart.CFrame = CFrame.new(pos, pos + Vector3.new(0, 0, -1))
    end
end)

GreenLightTab:Button("Help Player To End", function()
    if Loading then return end
    Loading = true
    for _, v in pairs(game.Players:GetPlayers()) do
        if v.Character:FindFirstChild("HumanoidRootPart") and v.Character.HumanoidRootPart:FindFirstChild("CarryPrompt") and v.Character.HumanoidRootPart.CarryPrompt.Enabled == true then
            if v.Character:FindFirstChild("SafeRedLightGreenLight") == nil then
                Player.Character.HumanoidRootPart.CFrame = v.Character.HumanoidRootPart.CFrame
                wait(0.3)
                repeat task.wait(0.1)
                    fireproximityprompt(v.Character.HumanoidRootPart:FindFirstChild("CarryPrompt"))
                until v.Character.HumanoidRootPart.CarryPrompt.Enabled == false
                wait(0.5)
                if workspace:FindFirstChild("RedLightGreenLight") and workspace.RedLightGreenLight:FindFirstChild("sand") and workspace.RedLightGreenLight.sand:FindFirstChild("crossedover") then
                    local pos = workspace.RedLightGreenLight.sand.crossedover.Position + Vector3.new(0, 5, 0)
                    Player.Character.HumanoidRootPart.CFrame = CFrame.new(pos, pos + Vector3.new(0, 0, -1))
                end
                wait(0.4)
                game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("ClickedButton"):FireServer({tryingtoleave = true})
                break
            end
        end
    end
    Loading = false
end)

local AutoHelpPlayerToggle = GreenLightTab:Toggle("Auto Help Player", false, function(Value)
    _G.AutoHelpPlayer = Value
    while _G.AutoHelpPlayer do
        for _, v in pairs(game.Players:GetPlayers()) do
            if v.Character:FindFirstChild("HumanoidRootPart") and v.Character.HumanoidRootPart:FindFirstChild("CarryPrompt") and v.Character.HumanoidRootPart.CarryPrompt.Enabled == true then
                if v.Character:FindFirstChild("SafeRedLightGreenLight") == nil then
                    Player.Character.HumanoidRootPart.CFrame = v.Character.HumanoidRootPart.CFrame
                    wait(0.3)
                    repeat task.wait(0.1)
                        fireproximityprompt(v.Character.HumanoidRootPart:FindFirstChild("CarryPrompt"))
                    until v.Character.HumanoidRootPart.CarryPrompt.Enabled == false
                    wait(0.5)
                    if workspace:FindFirstChild("RedLightGreenLight") then
                        Player.Character.HumanoidRootPart.CFrame = CFrame.new(-75, 1025, 143)
                    end
                    wait(0.4)
                    game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("ClickedButton"):FireServer({tryingtoleave = true})
                    break
                end
            end
        end
        task.wait()
    end
end)

GreenLightTab:Button("Troll Player", function()
    if Loading1 then return end
    Loading1 = true
    for _, v in pairs(game.Players:GetPlayers()) do
        if v.Character:FindFirstChild("HumanoidRootPart") and v.Character.HumanoidRootPart:FindFirstChild("CarryPrompt") and v.Character.HumanoidRootPart.CarryPrompt.Enabled == true then
            if v.Character:FindFirstChild("SafeRedLightGreenLight") == nil then
                Player.Character.HumanoidRootPart.CFrame = v.Character.HumanoidRootPart.CFrame
                wait(0.3)
                repeat task.wait(0.1)
                    fireproximityprompt(v.Character.HumanoidRootPart:FindFirstChild("CarryPrompt"))
                until v.Character.HumanoidRootPart.CarryPrompt.Enabled == false
                wait(0.5)
                if workspace:FindFirstChild("RedLightGreenLight") then
                    Player.Character.HumanoidRootPart.CFrame = CFrame.new(-84, 1023, -537)
                end
                wait(0.4)
                game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("ClickedButton"):FireServer({tryingtoleave = true})
                break
            end
        end
    end
    Loading1 = false
end)

local AutoTrollPlayerToggle = GreenLightTab:Toggle("Auto Troll Player", false, function(Value)
    _G.AutoTrollPlayer = Value
    while _G.AutoTrollPlayer do
        for _, v in pairs(game.Players:GetPlayers()) do
            if v.Character:FindFirstChild("HumanoidRootPart") and v.Character.HumanoidRootPart:FindFirstChild("CarryPrompt") and v.Character.HumanoidRootPart.CarryPrompt.Enabled == true then
                if v.Character:FindFirstChild("SafeRedLightGreenLight") == nil then
                    Player.Character.HumanoidRootPart.CFrame = v.Character.HumanoidRootPart.CFrame
                    wait(0.3)
                    repeat task.wait(0.1)
                        fireproximityprompt(v.Character.HumanoidRootPart:FindFirstChild("CarryPrompt"))
                    until v.Character.HumanoidRootPart.CarryPrompt.Enabled == false
                    wait(0.5)
                    if workspace:FindFirstChild("RedLightGreenLight") then
                        Player.Character.HumanoidRootPart.CFrame = CFrame.new(-84, 1023, -537)
                    end
                    wait(0.4)
                    game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("ClickedButton"):FireServer({tryingtoleave = true})
                    break
                end
            end
        end
        task.wait()
    end
end)

-- Dalgona Tab Content
DalgonaTab:Section("Dalgona")

DalgonaTab:Button("Complete Dalgona", function()
    local DalgonaClientModule = game.ReplicatedStorage.Modules.Games.DalgonaClient
    for i, v in pairs(getreg()) do
        if typeof(v) == "function" and islclosure(v) then
            if getfenv(v).script == DalgonaClientModule then
                if getinfo(v).nups == 73 then
                    setupvalue(v, 31, 9e9)
                end
            end
        end
    end
end)

-- Tug of War Tab Content
TugOfWarTab:Section("Tug of War")

local AutoTugOfWarToggle = TugOfWarTab:Toggle("Auto Tug of War", false, function(Value)
    _G.TugOfWar = Value
    while _G.TugOfWar do
        game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("TemporaryReachedBindable"):FireServer({GameQTE = true})
        task.wait()
    end
end)

TugOfWarTab:Section("Hide & Seek")

local EspDoorExitToggle = TugOfWarTab:Toggle("ESP Door Exit", false, function(Value)
    _G.DoorExit = Value
    if _G.DoorExit == false then
        if workspace:FindFirstChild("HideAndSeekMap") then
            for i, v in pairs(workspace:FindFirstChild("HideAndSeekMap"):GetChildren()) do
                if v.Name == "NEWFIXEDDOORS" then
                    for k, m in pairs(v:GetChildren()) do
                        if m.Name:find("Floor") and m:FindFirstChild("EXITDOORS") then
                            for _, a in pairs(m:FindFirstChild("EXITDOORS"):GetChildren()) do
                                if a:IsA("Model") and a:FindFirstChild("DoorRoot") then
                                    for _, z in pairs(a:FindFirstChild("DoorRoot"):GetChildren()) do
                                        if z.Name:find("Esp_") then
                                            z:Destroy()
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end
    while _G.DoorExit do
        if workspace:FindFirstChild("HideAndSeekMap") then
            for i, v in pairs(workspace:FindFirstChild("HideAndSeekMap"):GetChildren()) do
                if v.Name == "NEWFIXEDDOORS" then
                    for k, m in pairs(v:GetChildren()) do
                        if m.Name:find("Floor") and m:FindFirstChild("EXITDOORS") then
                            for _, a in pairs(m:FindFirstChild("EXITDOORS"):GetChildren()) do
                                if a:IsA("Model") and a:FindFirstChild("DoorRoot") then
                                    if a.DoorRoot:FindFirstChild("Esp_Highlight") then
                                        a.DoorRoot:FindFirstChild("Esp_Highlight").FillColor = Colorlight or Color3.fromRGB(255, 255, 255)
                                        a.DoorRoot:FindFirstChild("Esp_Highlight").OutlineColor = Colorlight or Color3.fromRGB(255, 255, 255)
                                    end
                                    if _G.EspHighlight == true and a.DoorRoot:FindFirstChild("Esp_Highlight") == nil then
                                        local Highlight = Instance.new("Highlight")
                                        Highlight.Name = "Esp_Highlight"
                                        Highlight.FillColor = Color3.fromRGB(255, 255, 255) 
                                        Highlight.OutlineColor = Color3.fromRGB(255, 255, 255) 
                                        Highlight.FillTransparency = 0.5
                                        Highlight.OutlineTransparency = 0
                                        Highlight.Adornee = a
                                        Highlight.Parent = a.DoorRoot
                                    elseif _G.EspHighlight == false and a.DoorRoot:FindFirstChild("Esp_Highlight") then
                                        a.DoorRoot:FindFirstChild("Esp_Highlight"):Destroy()
                                    end
                                    if a.DoorRoot:FindFirstChild("Esp_Gui") and a.DoorRoot["Esp_Gui"]:FindFirstChild("TextLabel") then
                                        a.DoorRoot["Esp_Gui"]:FindFirstChild("TextLabel").Text = 
                                                (_G.EspName == true and "Door Exit" or "")..
                                                (_G.EspDistance == true and "\nDistance ("..string.format("%.1f", (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - a.DoorRoot.Position).Magnitude).."m)" or "")
                                        a.DoorRoot["Esp_Gui"]:FindFirstChild("TextLabel").TextSize = _G.EspGuiTextSize or 15
                                        a.DoorRoot["Esp_Gui"]:FindFirstChild("TextLabel").TextColor3 = _G.EspGuiTextColor or Color3.new(255, 255, 255)
                                    end
                                    if _G.EspGui == true and a.DoorRoot:FindFirstChild("Esp_Gui") == nil then
                                        GuiPlayerEsp = Instance.new("BillboardGui", a.DoorRoot)
                                        GuiPlayerEsp.Adornee = a.DoorRoot
                                        GuiPlayerEsp.Name = "Esp_Gui"
                                        GuiPlayerEsp.Size = UDim2.new(0, 100, 0, 150)
                                        GuiPlayerEsp.AlwaysOnTop = true
                                        GuiPlayerEsp.StudsOffset = Vector3.new(0, 3, 0)
                                        GuiPlayerEspText = Instance.new("TextLabel", GuiPlayerEsp)
                                        GuiPlayerEspText.BackgroundTransparency = 1
                                        GuiPlayerEspText.Font = Enum.Font.Code
                                        GuiPlayerEspText.Size = UDim2.new(0, 100, 0, 100)
                                        GuiPlayerEspText.TextSize = 15
                                        GuiPlayerEspText.TextColor3 = Color3.new(0,0,0) 
                                        GuiPlayerEspText.TextStrokeTransparency = 0.5
                                        GuiPlayerEspText.Text = ""
                                        local UIStroke = Instance.new("UIStroke")
                                        UIStroke.Color = Color3.new(0, 0, 0)
                                        UIStroke.Thickness = 1.5
                                        UIStroke.Parent = GuiPlayerEspText
                                    elseif _G.EspGui == false and a.DoorRoot:FindFirstChild("Esp_Gui") then
                                        a.DoorRoot:FindFirstChild("Esp_Gui"):Destroy()
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
        task.wait()
    end
end)

local EspKeyToggle = TugOfWarTab:Toggle("ESP Key", false, function(Value)
    _G.DoorKey = Value
    if _G.DoorKey == false then
        for _, a in pairs(workspace.Effects:GetChildren()) do
            if a.Name:find("DroppedKey") and a:FindFirstChild("Handle") then
                for _, v in pairs(a:FindFirstChild("Handle"):GetChildren()) do
                    if v.Name:find("Esp_") then
                        v:Destroy()
                    end
                end
            end
        end
    end
    while _G.DoorKey do
        for _, a in pairs(workspace.Effects:GetChildren()) do
            if a.Name:find("DroppedKey") and a:FindFirstChild("Handle") then 
                if a.Handle:FindFirstChild("Esp_Highlight") then
                    a.Handle:FindFirstChild("Esp_Highlight").FillColor = Colorlight or Color3.fromRGB(255, 255, 255)
                    a.Handle:FindFirstChild("Esp_Highlight").OutlineColor = Colorlight or Color3.fromRGB(255, 255, 255)
                end
                if _G.EspHighlight == true and a.Handle:FindFirstChild("Esp_Highlight") == nil then
                    local Highlight = Instance.new("Highlight")
                    Highlight.Name = "Esp_Highlight"
                    Highlight.FillColor = Color3.fromRGB(255, 255, 255) 
                    Highlight.OutlineColor = Color3.fromRGB(255, 255, 255) 
                    Highlight.FillTransparency = 0.5
                    Highlight.OutlineTransparency = 0
                    Highlight.Adornee = a
                    Highlight.Parent = a.Handle
                elseif _G.EspHighlight == false and a.Handle:FindFirstChild("Esp_Highlight") then
                    a.Handle:FindFirstChild("Esp_Highlight"):Destroy()
                end
                if a.Handle:FindFirstChild("Esp_Gui") and a.Handle["Esp_Gui"]:FindFirstChild("TextLabel") then
                    a.Handle["Esp_Gui"]:FindFirstChild("TextLabel").Text = 
                            (_G.EspName == true and "Key" or "")..
                            (_G.EspDistance == true and "\nDistance ("..string.format("%.1f", (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - a.Handle.Position).Magnitude).."m)" or "")
                    a.Handle["Esp_Gui"]:FindFirstChild("TextLabel").TextSize = _G.EspGuiTextSize or 15
                    a.Handle["Esp_Gui"]:FindFirstChild("TextLabel").TextColor3 = _G.EspGuiTextColor or Color3.new(255, 255, 255)
                end
                if _G.EspGui == true and a.Handle:FindFirstChild("Esp_Gui") == nil then
                    GuiPlayerEsp = Instance.new("BillboardGui", a.Handle)
                    GuiPlayerEsp.Adornee = a.Handle
                    GuiPlayerEsp.Name = "Esp_Gui"
                    GuiPlayerEsp.Size = UDim2.new(0, 100, 0, 150)
                    GuiPlayerEsp.AlwaysOnTop = true
                    GuiPlayerEsp.StudsOffset = Vector3.new(0, 3, 0)
                    GuiPlayerEspText = Instance.new("TextLabel", GuiPlayerEsp)
                    GuiPlayerEspText.BackgroundTransparency = 1
                    GuiPlayerEspText.Font = Enum.Font.Code
                    GuiPlayerEspText.Size = UDim2.new(0, 100, 0, 100)
                    GuiPlayerEspText.TextSize = 15
                    GuiPlayerEspText.TextColor3 = Color3.new(0,0,0) 
                    GuiPlayerEspText.TextStrokeTransparency = 0.5
                    GuiPlayerEspText.Text = ""
                    local UIStroke = Instance.new("UIStroke")
                    UIStroke.Color = Color3.new(0, 0, 0)
                    UIStroke.Thickness = 1.5
                    UIStroke.Parent = GuiPlayerEspText
                elseif _G.EspGui == false and a.Handle:FindFirstChild("Esp_Gui") then
                    a.Handle:FindFirstChild("Esp_Gui"):Destroy()
                end
            end
        end
        task.wait()
    end
end)

local AutoTeleportHideToggle = TugOfWarTab:Toggle("Auto Teleport to Hider", false, function(Value)
    _G.AutoTeleportHide = Value
    while _G.AutoTeleportHide do
        for i, v in pairs(game.Players:GetChildren()) do
            if v ~= game.Players.LocalPlayer and v.Character and v.Character:FindFirstChild("Head") and v.Character:FindFirstChild("HumanoidRootPart") and v.Character:FindFirstChild("Humanoid") then
                if v:GetAttribute("IsHider") and v.Character.Humanoid.Health > 0 then
                    if v.Character:FindFirstChild("Humanoid") and v.Character.Humanoid.MoveDirection.Magnitude > 0 then
                        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = v.Character:FindFirstChild("HumanoidRootPart").CFrame * CFrame.new(0, 0, -7)
                    else
                        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = v.Character:FindFirstChild("HumanoidRootPart").CFrame
                    end
                    break
                end
            end
        end
        task.wait()
    end
end)

TugOfWarTab:Button("Teleport to Hider", function()
    for i, v in pairs(game.Players:GetChildren()) do
        if v ~= game.Players.LocalPlayer and v.Character and v.Character:FindFirstChild("Head") and v.Character:FindFirstChild("HumanoidRootPart") and v.Character:FindFirstChild("Humanoid") then
            if v:GetAttribute("IsHider") and v.Character.Humanoid.Health > 0 then
                game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = v.Character.HumanoidRootPart.CFrame
                break
            end
        end
    end
end)

TugOfWarTab:Button("Teleport to All Keys", function()
    local OldCFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame
    for _, a in pairs(workspace.Effects:GetChildren()) do
        if a.Name:find("DroppedKey") and a:FindFirstChild("Handle") then
            if game.Players.LocalPlayer.Character:FindFirstChild("Head") and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") and game.Players.LocalPlayer.Character:FindFirstChild("Humanoid") then
                if game.Players.LocalPlayer.Character.Humanoid.Health > 0 then
                    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = a.Handle.CFrame
                    task.wait(0.2)
                end
            end
        end
    end
    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = OldCFrame
end)

TugOfWarTab:Button("Teleport to All Doors", function()
    local OldCFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame
    if workspace:FindFirstChild("HideAndSeekMap") then
        for i, v in pairs(workspace:FindFirstChild("HideAndSeekMap"):GetChildren()) do
            if v.Name == "NEWFIXEDDOORS" then
                for k, m in pairs(v:GetChildren()) do
                    if m.Name:find("Floor") and m:FindFirstChild("EXITDOORS") then
                        for _, a in pairs(m:FindFirstChild("EXITDOORS"):GetChildren()) do
                            if a:IsA("Model") and a:FindFirstChild("DoorRoot") then
                                if game.Players.LocalPlayer.Character:FindFirstChild("Head") and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") and game.Players.LocalPlayer.Character:FindFirstChild("Humanoid") then
                                    if game.Players.LocalPlayer.Character.Humanoid.Health > 0 then
                                        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = a.DoorRoot.CFrame
                                        task.wait(0.2)
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end
    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = OldCFrame
end)

-- Glass Bridge Tab Content
GlassBridgeTab:Section("Glass Bridge")

GlassBridgeTab:Button("Teleport to End", function()
    if workspace:FindFirstChild("GlassBridge") then
        local End = workspace.GlassBridge:FindFirstChild("End")
        if End then
            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = End.CFrame * CFrame.new(0, 5, 0)
        end
    end
end)

GlassBridgeTab:Button("Teleport to Start", function()
    if workspace:FindFirstChild("GlassBridge") then
        local Start = workspace.GlassBridge:FindFirstChild("Start")
        if Start then
            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = Start.CFrame * CFrame.new(0, 5, 0)
        end
    end
end)

GlassBridgeTab:Button("Teleport to Safe Glass", function()
    if workspace:FindFirstChild("GlassBridge") then
        for i, v in pairs(workspace.GlassBridge:GetChildren()) do
            if v.Name:find("Glass") and v:FindFirstChild("TouchInterest") then
                game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = v.CFrame * CFrame.new(0, 5, 0)
                break
            end
        end
    end
end)

GlassBridgeTab:Toggle("Auto Glass Bridge", false, function(Value)
    _G.AutoGlassBridge = Value
    while _G.AutoGlassBridge do
        if workspace:FindFirstChild("GlassBridge") then
            for i, v in pairs(workspace.GlassBridge:GetChildren()) do
                if v.Name:find("Glass") and v:FindFirstChild("TouchInterest") then
                    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = v.CFrame * CFrame.new(0, 5, 0)
                    break
                end
            end
        end
        task.wait()
    end
end)

-- Marbles Tab Content
MarblesTab:Section("Marbles")

MarblesTab:Button("Win Marbles", function()
    if game.Players.LocalPlayer.PlayerGui:FindFirstChild("Marbles") and game.Players.LocalPlayer.PlayerGui.Marbles:FindFirstChild("Main") and game.Players.LocalPlayer.PlayerGui.Marbles.Main:FindFirstChild("Opponent") and game.Players.LocalPlayer.PlayerGui.Marbles.Main:FindFirstChild("Player") then
        game.Players.LocalPlayer.PlayerGui.Marbles.Main.Opponent.Text = "0"
        game.Players.LocalPlayer.PlayerGui.Marbles.Main.Player.Text = "10"
        game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Marbles"):FireServer({action = "Finished"})
    end
end)

MarblesTab:Toggle("Auto Win Marbles", false, function(Value)
    _G.AutoMarbles = Value
    while _G.AutoMarbles do
        if game.Players.LocalPlayer.PlayerGui:FindFirstChild("Marbles") and game.Players.LocalPlayer.PlayerGui.Marbles:FindFirstChild("Main") and game.Players.LocalPlayer.PlayerGui.Marbles.Main:FindFirstChild("Opponent") and game.Players.LocalPlayer.PlayerGui.Marbles.Main:FindFirstChild("Player") then
            game.Players.LocalPlayer.PlayerGui.Marbles.Main.Opponent.Text = "0"
            game.Players.LocalPlayer.PlayerGui.Marbles.Main.Player.Text = "10"
            game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Marbles"):FireServer({action = "Finished"})
        end
        task.wait()
    end
end)

-- Hopscotch Tab Content
HopscotchTab:Section("Hopscotch")

HopscotchTab:Button("Teleport to End", function()
    if workspace:FindFirstChild("Hopscotch") then
        local End = workspace.Hopscotch:FindFirstChild("End")
        if End then
            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = End.CFrame * CFrame.new(0, 5, 0)
        end
    end
end)

HopscotchTab:Button("Teleport to Start", function()
    if workspace:FindFirstChild("Hopscotch") then
        local Start = workspace.Hopscotch:FindFirstChild("Start")
        if Start then
            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = Start.CFrame * CFrame.new(0, 5, 0)
        end
    end
end)

HopscotchTab:Toggle("Auto Hopscotch", false, function(Value)
    _G.AutoHopscotch = Value
    while _G.AutoHopscotch do
        if workspace:FindFirstChild("Hopscotch") then
            for i, v in pairs(workspace.Hopscotch:GetChildren()) do
                if v.Name:find("Tile") and v:FindFirstChild("TouchInterest") then
                    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = v.CFrame * CFrame.new(0, 5, 0)
                    break
                end
            end
        end
        task.wait()
    end
end)

-- Player Tab Content
PlayerTab:Section("Movement")

local InfiniteJumpToggle = PlayerTab:Toggle("Infinite Jump", false, function(Value)
    _G.InfiniteJump = Value
end)

local AutoSpeedToggle = PlayerTab:Toggle("Auto Speed", false, function(Value)
    _G.AutoSpeed = Value
end)

local SpeedSlider = PlayerTab:Slider("Speed", 16, 100, function(Value)
    _G.Speed = Value
    if _G.AutoSpeed == true then
        if game.Players.LocalPlayer.Character:FindFirstChild("Humanoid") then
            game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = _G.Speed or 50
        end
    end
end)

PlayerTab:Section("Anti Lag")

local AntiLagToggle = PlayerTab:Toggle("Anti Lag", false, function(Value)
    _G.AntiLag = Value
end)

-- ESP Tab Content
ESPTab:Section("ESP Settings")

local EspHighlightToggle = ESPTab:Toggle("ESP Highlight", true, function(Value)
    _G.EspHighlight = Value
end)

local EspGuiToggle = ESPTab:Toggle("ESP Gui", true, function(Value)
    _G.EspGui = Value
end)

local EspNameToggle = ESPTab:Toggle("ESP Name", true, function(Value)
    _G.EspName = Value
end)

local EspDistanceToggle = ESPTab:Toggle("ESP Distance", true, function(Value)
    _G.EspDistance = Value
end)

local EspHealthToggle = ESPTab:Toggle("ESP Health", true, function(Value)
    _G.EspHealth = Value
end)

local EspGuiTextSizeSlider = ESPTab:Slider("ESP Gui Text Size", 10, 30, function(Value)
    _G.EspGuiTextSize = Value
end)

ESPTab:Section("Player ESP")

local EspPlayerHideToggle = ESPTab:Toggle("ESP Hiders", false, function(Value)
    _G.HidePlayer = Value
    if _G.HidePlayer == false then
        for i, v in pairs(game.Players:GetChildren()) do
            if v ~= game.Players.LocalPlayer and v.Character and v.Character:FindFirstChild("Head") and v.Character:FindFirstChild("HumanoidRootPart") and v.Character:FindFirstChild("Humanoid") then
                for i, n in pairs(v.Character:FindFirstChild("Head"):GetChildren()) do
                    if n.Name:find("Esp_") then
                        n:Destroy()
                    end
                end
            end
        end
    end
    while _G.HidePlayer do
        for i, v in pairs(game.Players:GetChildren()) do
            if v ~= game.Players.LocalPlayer and v.Character and v.Character:FindFirstChild("Head") and v.Character:FindFirstChild("HumanoidRootPart") and v.Character:FindFirstChild("Humanoid") then
                if not v:GetAttribute("IsHider") then
                    for i, n in pairs(v.Character:FindFirstChild("Head"):GetChildren()) do
                        if n.Name:find("Esp_") then
                            n:Destroy()
                        end
                    end
                end
                if v:GetAttribute("IsHider") then
                    if v.Character.Head:FindFirstChild("Esp_Highlight") then
                        v.Character.Head:FindFirstChild("Esp_Highlight").FillColor = Colorlight or Color3.fromRGB(255, 255, 255)
                        v.Character.Head:FindFirstChild("Esp_Highlight").OutlineColor = Colorlight or Color3.fromRGB(255, 255, 255)
                    end
                    if _G.EspHighlight == true and v.Character.Head:FindFirstChild("Esp_Highlight") == nil then
                        local Highlight = Instance.new("Highlight")
                        Highlight.Name = "Esp_Highlight"
                        Highlight.FillColor = Color3.fromRGB(255, 255, 255) 
                        Highlight.OutlineColor = Color3.fromRGB(255, 255, 255) 
                        Highlight.FillTransparency = 0.5
                        Highlight.OutlineTransparency = 0
                        Highlight.Adornee = v.Character
                        Highlight.Parent = v.Character.Head
                    elseif _G.EspHighlight == false and v.Character.Head:FindFirstChild("Esp_Highlight") then
                        v.Character.Head:FindFirstChild("Esp_Highlight"):Destroy()
                    end
                    if v.Character.Head:FindFirstChild("Esp_Gui") and v.Character.Head["Esp_Gui"]:FindFirstChild("TextLabel") then
                        v.Character.Head["Esp_Gui"]:FindFirstChild("TextLabel").Text = 
                                v.Name.." (Hide)"..
                                (_G.EspDistance == true and "\nDistance ("..string.format("%.1f", (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - v.HumanoidRootPart.Position).Magnitude).."m)" or "")..
                                (_G.EspHealth == true and "\nHealth ("..string.format("%.0f", v.Humanoid.Health)..")" or "")
                        v.Character.Head["Esp_Gui"]:FindFirstChild("TextLabel").TextSize = _G.EspGuiTextSize or 15
                        v.Character.Head["Esp_Gui"]:FindFirstChild("TextLabel").TextColor3 = _G.EspGuiTextColor or Color3.new(255, 255, 255)
                    end
                    if _G.EspGui == true and v.Character.Head:FindFirstChild("Esp_Gui") == nil then
                        GuiPlayerEsp = Instance.new("BillboardGui", v.Character.Head)
                        GuiPlayerEsp.Adornee = v.Character.Head
                        GuiPlayerEsp.Name = "Esp_Gui"
                        GuiPlayerEsp.Size = UDim2.new(0, 100, 0, 150)
                        GuiPlayerEsp.AlwaysOnTop = true
                        GuiPlayerEsp.StudsOffset = Vector3.new(0, 3, 0)
                        GuiPlayerEspText = Instance.new("TextLabel", GuiPlayerEsp)
                        GuiPlayerEspText.BackgroundTransparency = 1
                        GuiPlayerEspText.Font = Enum.Font.Code
                        GuiPlayerEspText.Size = UDim2.new(0, 100, 0, 100)
                        GuiPlayerEspText.TextSize = 15
                        GuiPlayerEspText.TextColor3 = Color3.new(0,0,0) 
                        GuiPlayerEspText.TextStrokeTransparency = 0.5
                        GuiPlayerEspText.Text = ""
                        local UIStroke = Instance.new("UIStroke")
                        UIStroke.Color = Color3.new(0, 0, 0)
                        UIStroke.Thickness = 1.5
                        UIStroke.Parent = GuiPlayerEspText
                    elseif _G.EspGui == false and v.Character.Head:FindFirstChild("Esp_Gui") then
                        v.Character.Head:FindFirstChild("Esp_Gui"):Destroy()
                    end
                end
            end
        end
        task.wait()
    end
end)

local EspPlayerSeekToggle = ESPTab:Toggle("ESP Seekers", false, function(Value)
    _G.SeekPlayer = Value
    if _G.SeekPlayer == false then
        for i, v in pairs(game.Players:GetChildren()) do
            if v ~= game.Players.LocalPlayer and v.Character and v.Character:FindFirstChild("Head") and v.Character:FindFirstChild("HumanoidRootPart") and v.Character:FindFirstChild("Humanoid") then
                for i, n in pairs(v.Character:FindFirstChild("Head"):GetChildren()) do
                    if n.Name:find("Esp_") then
                        n:Destroy()
                    end
                end
            end
        end
    end
    while _G.SeekPlayer do
        for i, v in pairs(game.Players:GetChildren()) do
            if v ~= game.Players.LocalPlayer and v.Character and v.Character:FindFirstChild("Head") and v.Character:FindFirstChild("HumanoidRootPart") and v.Character:FindFirstChild("Humanoid") then
                if not v:GetAttribute("IsHunter") then
                    for i, n in pairs(v.Character:FindFirstChild("Head"):GetChildren()) do
                        if n.Name:find("Esp_") then
                            n:Destroy()
                        end
                    end
                end
                if v:GetAttribute("IsHunter") then
                    if v.Character:FindFirstChild("Esp_Highlight1") then
                        v.Character:FindFirstChild("Esp_Highlight1").FillColor = Colorlight or Color3.fromRGB(255, 255, 255)
                        v.Character:FindFirstChild("Esp_Highlight1").OutlineColor = Colorlight or Color3.fromRGB(255, 255, 255)
                    end
                    if _G.EspHighlight == true and v.Character:FindFirstChild("Esp_Highlight1") == nil then
                        local Highlight = Instance.new("Highlight")
                        Highlight.Name = "Esp_Highlight1"
                        Highlight.FillColor = Color3.fromRGB(255, 255, 255) 
                        Highlight.OutlineColor = Color3.fromRGB(255, 255, 255) 
                        Highlight.FillTransparency = 0.5
                        Highlight.OutlineTransparency = 0
                        Highlight.Adornee = v.Character
                        Highlight.Parent = v.Character.Head
                    elseif _G.EspHighlight == false and v.Character:FindFirstChild("Esp_Highlight1") then
                        v.Character:FindFirstChild("Esp_Highlight1"):Destroy()
                    end
                    if v.Character.Head:FindFirstChild("Esp_Gui1") and v.Character.Head["Esp_Gui1"]:FindFirstChild("TextLabel") then
                        v.Character.Head["Esp_Gui1"]:FindFirstChild("TextLabel").Text = 
                                v.Name.." (Seek)"..
                                (_G.EspDistance == true and "\nDistance ("..string.format("%.1f", (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - v.HumanoidRootPart.Position).Magnitude).."m)" or "")
                        v.Character.Head["Esp_Gui1"]:FindFirstChild("TextLabel").TextSize = _G.EspGuiTextSize or 15
                        v.Character.Head["Esp_Gui1"]:FindFirstChild("TextLabel").TextColor3 = _G.EspGuiTextColor or Color3.new(255, 255, 255)
                    end
                    if _G.EspGui == true and v.Character.Head:FindFirstChild("Esp_Gui1") == nil then
                        local GuiPlayerEsp = Instance.new("BillboardGui", v.Character.Head)
                        GuiPlayerEsp.Adornee = v.Character.Head
                        GuiPlayerEsp.Name = "Esp_Gui1"
                        GuiPlayerEsp.Size = UDim2.new(0, 100, 0, 150)
                        GuiPlayerEsp.AlwaysOnTop = true
                        GuiPlayerEsp.StudsOffset = Vector3.new(0, 3, 0)
                        local GuiPlayerEspText = Instance.new("TextLabel", GuiPlayerEsp)
                        GuiPlayerEspText.BackgroundTransparency = 1
                        GuiPlayerEspText.Font = Enum.Font.Code
                        GuiPlayerEspText.Size = UDim2.new(0, 100, 0, 100)
                        GuiPlayerEspText.TextSize = 15
                        GuiPlayerEspText.TextColor3 = Color3.new(0,0,0) 
                        GuiPlayerEspText.TextStrokeTransparency = 0.5
                        GuiPlayerEspText.Text = ""
                        local UIStroke = Instance.new("UIStroke")
                        UIStroke.Color = Color3.new(0, 0, 0)
                        UIStroke.Thickness = 1.5
                        UIStroke.Parent = GuiPlayerEspText
                    elseif _G.EspGui == false and v.Character.Head:FindFirstChild("Esp_Gui1") then
                        v.Character.Head:FindFirstChild("Esp_Gui1"):Destroy()
                    end
                end
            end
        end
        task.wait()
    end
end)

-- Settings Tab Content
SettingsTab:Section("UI Settings")

SettingsTab:Button("Destroy UI", function()
    Window:Destroy()
end)

SettingsTab:Button("Hide UI", function()
    Hawk:ToggleUI()
end)

SettingsTab:KeyBind("UI Keybind", "RightShift", function()
    Hawk:ToggleUI()
end)

SettingsTab:Section("UI Theme")

SettingsTab:Dropdown("UI Theme", {"Pink", "White", "Dark"}, function(Value)
    Window:ChangeTheme(Value)
end)

SettingsTab:Section("Notification Settings")

local ChooseNotifyDropdown = SettingsTab:Dropdown("Choose Notification", {"Obsidian", "Roblox"}, function(Value)
    _G.ChooseNotify = Value
end)

local NotificationSoundToggle = SettingsTab:Toggle("Notification Sound", true, function(Value)
    _G.NotificationSound = Value
end)

local VolumeTimeSlider = SettingsTab:Slider("Volume Time", 1, 10, function(Value)
    _G.VolumeTime = Value
end)

SettingsTab:Section("UI Info")

SettingsTab:Paragraph("Lucent Hub", {
    "Created for Ink Game",
    "Version 1.0",
    "Built with Hawk Library"
})

-- Initial notification
Notifications:Notification("Lucent Hub", "UI Loaded Successfully!", "Notify", 5)
