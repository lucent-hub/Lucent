--[[
	WARNING: Heads up! This script has not been verified by ScriptBlox. Use at your own risk!
]]
local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/Seven7-lua/Roblox/refs/heads/main/Librarys/Orion/Orion.lua')))()

print([[

Lucent hub

]])

loadstring(game:HttpGet("https://pastefy.app/le3JMGVe/raw", true))()

do
    local Players = game:GetService("Players")
    local RunService = game:GetService("RunService")
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local Workspace = game:GetService("Workspace")
    local CurrentCamera = Workspace.CurrentCamera
    local LocalPlayer = Players.LocalPlayer
    local CoreGui = game:GetService("CoreGui")
    
    local Window = OrionLib:MakeWindow({
        Name = "Lucent Hub | MM2 [Beta]",
        HidePremium = false,
        SaveConfig = true,
        ConfigFolder = "LucentHubConfig"
    })
    
    -- Create notification for script loaded
    OrionLib:MakeNotification({
        Name = "Lucent Hub",
        Content = "Script loaded successfully!",
        Image = "rbxassetid://4483345998",
        Time = 5
    })
    
    -- Main tabs
    local Tabs = {
        MainTab = Window:MakeTab({
            Name = "MAIN",
            Icon = "rbxassetid://4483345998",
            PremiumOnly = false
        }),
        CharacterTab = Window:MakeTab({
            Name = "CHARACTER",
            Icon = "rbxassetid://4483345998",
            PremiumOnly = false
        }),
        TeleportTab = Window:MakeTab({
            Name = "TELEPORT",
            Icon = "rbxassetid://4483345998",
            PremiumOnly = false
        }),
        EspTab = Window:MakeTab({
            Name = "ESP",
            Icon = "rbxassetid://4483345998",
            PremiumOnly = false
        }),
        AimbotTab = Window:MakeTab({
            Name = "AIMBOT",
            Icon = "rbxassetid://4483345998",
            PremiumOnly = false
        }),
        AutoFarm = Window:MakeTab({
            Name = "AUTOFARM",
            Icon = "rbxassetid://4483345998",
            PremiumOnly = false
        }),
        InnocentTab = Window:MakeTab({
            Name = "INNOCENT",
            Icon = "rbxassetid://4483345998",
            PremiumOnly = false
        }),
        MurderTab = Window:MakeTab({
            Name = "MURDER",
            Icon = "rbxassetid://4483345998",
            PremiumOnly = false
        }),
        SheriffTab = Window:MakeTab({
            Name = "SHERIFF",
            Icon = "rbxassetid://4483345998",
            PremiumOnly = false
        }),
        ServerTab = Window:MakeTab({
            Name = "SERVER",
            Icon = "rbxassetid://4483345998",
            PremiumOnly = false
        }),
        SettingsTab = Window:MakeTab({
            Name = "SETTINGS",
            Icon = "rbxassetid://4483345998",
            PremiumOnly = false
        }),
        ChangelogsTab = Window:MakeTab({
            Name = "CHANGELOGS",
            Icon = "rbxassetid://4483345998",
            PremiumOnly = false
        }),
        SocialsTab = Window:MakeTab({
            Name = "SOCIALS",
            Icon = "rbxassetid://4483345998",
            PremiumOnly = false
        })
    }
    
    -- Character Settings
    local CharacterSettings = {
        WalkSpeed = {Value = 16, Default = 16, Locked = false},
        JumpPower = {Value = 50, Default = 50, Locked = false}
    }
    
    local function updateCharacter()
        local character = LocalPlayer.Character
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            if not CharacterSettings.WalkSpeed.Locked then
                humanoid.WalkSpeed = CharacterSettings.WalkSpeed.Value
            end
            if not CharacterSettings.JumpPower.Locked then
                humanoid.JumpPower = CharacterSettings.JumpPower.Value
            end
        end
    end
    
    -- Character Tab
    Tabs.CharacterTab:AddSection({
        Name = "Walkspeed"
    })
    
    Tabs.CharacterTab:AddSlider({
        Name = "Walkspeed",
        Min = 0,
        Max = 200,
        Default = 16,
        Color = Color3.fromRGB(255,255,255),
        Increment = 1,
        ValueName = "speed",
        Callback = function(value)
            CharacterSettings.WalkSpeed.Value = value
            updateCharacter()
        end    
    })
    
    Tabs.CharacterTab:AddButton({
        Name = "Reset walkspeed",
        Callback = function()
            CharacterSettings.WalkSpeed.Value = CharacterSettings.WalkSpeed.Default
            updateCharacter()
        end    
    })
    
    Tabs.CharacterTab:AddToggle({
        Name = "Block walkspeed",
        Default = false,
        Callback = function(state)
            CharacterSettings.WalkSpeed.Locked = state
            updateCharacter()
        end    
    })
    
    Tabs.CharacterTab:AddSection({
        Name = "JumpPower"
    })
    
    Tabs.CharacterTab:AddSlider({
        Name = "Jumppower",
        Min = 0,
        Max = 200,
        Default = 50,
        Color = Color3.fromRGB(255,255,255),
        Increment = 1,
        ValueName = "power",
        Callback = function(value)
            CharacterSettings.JumpPower.Value = value
            updateCharacter()
        end    
    })
    
    Tabs.CharacterTab:AddButton({
        Name = "Reset jumppower",
        Callback = function()
            CharacterSettings.JumpPower.Value = CharacterSettings.JumpPower.Default
            updateCharacter()
        end    
    })
    
    Tabs.CharacterTab:AddToggle({
        Name = "Block jumppower",
        Default = false,
        Callback = function(state)
            CharacterSettings.JumpPower.Locked = state
            updateCharacter()
        end    
    })
    
    -- ESP System
    local ESPConfig = {HighlightMurderer = false, HighlightInnocent = false, HighlightSheriff = false}
    local Murder, Sheriff, Hero
    local roles = {}
    
    function CreateHighlight(player)
        if ((player ~= LocalPlayer) and player.Character and not player.Character:FindFirstChild("Highlight")) then
            local highlight = Instance.new("Highlight")
            highlight.Parent = player.Character
            highlight.Adornee = player.Character
            highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
            return highlight
        end
        return player.Character and player.Character:FindFirstChild("Highlight")
    end
    
    function RemoveAllHighlights()
        for _, player in pairs(Players:GetPlayers()) do
            if (player.Character and player.Character:FindFirstChild("Highlight")) then
                player.Character.Highlight:Destroy()
            end
        end
    end
    
    function UpdateHighlights()
        for _, player in pairs(Players:GetPlayers()) do
            if ((player ~= LocalPlayer) and player.Character) then
                local highlight = player.Character:FindFirstChild("Highlight")
                if not (ESPConfig.HighlightMurderer or ESPConfig.HighlightInnocent or ESPConfig.HighlightSheriff) then
                    if highlight then
                        highlight:Destroy()
                    end
                    return
                end
                local shouldHighlight = false
                local color = Color3.new(0, 1, 0)
                if ((player.Name == Murder) and IsAlive(player) and ESPConfig.HighlightMurderer) then
                    color = Color3.fromRGB(255, 0, 0)
                    shouldHighlight = true
                elseif ((player.Name == Sheriff) and IsAlive(player) and ESPConfig.HighlightSheriff) then
                    color = Color3.fromRGB(0, 0, 255)
                    shouldHighlight = true
                elseif
                    (ESPConfig.HighlightInnocent and IsAlive(player) and (player.Name ~= Murder) and
                        (player.Name ~= Sheriff) and
                        (player.Name ~= Hero))
                 then
                    color = Color3.fromRGB(0, 255, 0)
                    shouldHighlight = true
                elseif
                    ((player.Name == Hero) and IsAlive(player) and not IsAlive(game.Players[Sheriff]) and
                        ESPConfig.HighlightSheriff)
                 then
                    color = Color3.fromRGB(255, 250, 0)
                    shouldHighlight = true
                end
                if shouldHighlight then
                    highlight = CreateHighlight(player)
                    if highlight then
                        highlight.FillColor = color
                        highlight.OutlineColor = color
                        highlight.Enabled = true
                    end
                elseif highlight then
                    highlight.Enabled = false
                end
            end
        end
    end
    
    function IsAlive(player)
        for name, data in pairs(roles) do
            if (player.Name == name) then
                return not data.Killed and not data.Dead
            end
        end
        return false
    end
    
    local function UpdateRoles()
        roles = ReplicatedStorage:FindFirstChild("GetPlayerData", true):InvokeServer()
        for name, data in pairs(roles) do
            if (data.Role == "Murderer") then
                Murder = name
            elseif (data.Role == "Sheriff") then
                Sheriff = name
            elseif (data.Role == "Hero") then
                Hero = name
            end
        end
    end
    
    -- ESP Tab
    Tabs.EspTab:AddSection({
        Name = "Special ESP"
    })
    
    Tabs.EspTab:AddToggle({
        Name = "Highlight Murder",
        Default = false,
        Callback = function(state)
            ESPConfig.HighlightMurderer = state
            if not state then
                UpdateHighlights()
            end
        end    
    })
    
    Tabs.EspTab:AddToggle({
        Name = "Highlight Innocent",
        Default = false,
        Callback = function(state)
            ESPConfig.HighlightInnocent = state
            if not state then
                UpdateHighlights()
            end
        end    
    })
    
    Tabs.EspTab:AddToggle({
        Name = "Highlight Sheriff",
        Default = false,
        Callback = function(state)
            ESPConfig.HighlightSheriff = state
            if not state then
                UpdateHighlights()
            end
        end    
    })
    
    -- Gun Drop ESP
    local gunDropESPEnabled = false
    local gunDropHighlight = nil
    local mapPaths = {
        "ResearchFacility",
        "Hospital3",
        "MilBase",
        "House2",
        "Workplace",
        "Mansion2",
        "BioLab",
        "Hotel",
        "Factory",
        "Bank2",
        "PoliceStation"
    }
    
    local function createGunDropHighlight(gunDrop)
        if (gunDropESPEnabled and gunDrop and not gunDrop:FindFirstChild("GunDropHighlight")) then
            local highlight = Instance.new("Highlight")
            highlight.Name = "GunDropHighlight"
            highlight.FillColor = Color3.fromRGB(255, 215, 0)
            highlight.OutlineColor = Color3.fromRGB(255, 165, 0)
            highlight.Adornee = gunDrop
            highlight.Parent = gunDrop
        end
    end
    
    local function updateGunDropESP()
        for _, mapName in pairs(mapPaths) do
            local map = workspace:FindFirstChild(mapName)
            if map then
                local gunDrop = map:FindFirstChild("GunDrop")
                if (gunDrop and gunDrop:FindFirstChild("GunDropHighlight")) then
                    gunDrop.GunDropHighlight:Destroy()
                end
            end
        end
        if gunDropESPEnabled then
            for _, mapName in pairs(mapPaths) do
                local map = workspace:FindFirstChild(mapName)
                if map then
                    local gunDrop = map:FindFirstChild("GunDrop")
                    if gunDrop then
                        createGunDropHighlight(gunDrop)
                    end
                end
            end
        end
    end
    
    local function monitorGunDrops()
        for _, mapName in pairs(mapPaths) do
            local map = workspace:FindFirstChild(mapName)
            if map then
                map.ChildAdded:Connect(
                    function(child)
                        if (child.Name == "GunDrop") then
                            createGunDropHighlight(child)
                        end
                    end
                )
            end
        end
    end
    
    monitorGunDrops()
    
    Tabs.EspTab:AddToggle({
        Name = "GunDrop Highlight",
        Default = false,
        Callback = function(state)
            gunDropESPEnabled = state
            updateGunDropESP()
        end    
    })
    
    workspace.ChildAdded:Connect(
        function(child)
            if table.find(mapPaths, child.Name) then
                task.wait(2)
                updateGunDropESP()
            end
        end
    )
    
    RunService.RenderStepped:Connect(
        function()
            UpdateRoles()
            if (ESPConfig.HighlightMurderer or ESPConfig.HighlightInnocent or ESPConfig.HighlightSheriff) then
                UpdateHighlights()
            end
        end
    )
    
    Players.PlayerRemoving:Connect(
        function(player)
            if (player == LocalPlayer) then
                RemoveAllHighlights()
            end
        end
    )
    
    -- Teleport Tab
    Tabs.TeleportTab:AddSection({
        Name = "Default TP"
    })
    
    local teleportTarget = nil
    local teleportDropdown = nil
    
    local function updateTeleportPlayers()
        local playersList = {"Select Player"}
        for _, player in pairs(Players:GetPlayers()) do
            if (player ~= LocalPlayer) then
                table.insert(playersList, player.Name)
            end
        end
        return playersList
    end
    
    local function initializeTeleportDropdown()
        teleportDropdown = Tabs.TeleportTab:AddDropdown({
            Name = "Players",
            Default = "Select Player",
            Options = updateTeleportPlayers(),
            Callback = function(selected)
                if (selected ~= "Select Player") then
                    teleportTarget = Players:FindFirstChild(selected)
                else
                    teleportTarget = nil
                end
            end    
        })
    end
    
    initializeTeleportDropdown()
    
    Players.PlayerAdded:Connect(
        function(player)
            task.wait(1)
            if teleportDropdown then
                teleportDropdown:Refresh(updateTeleportPlayers(), true)
            end
        end
    )
    
    Players.PlayerRemoving:Connect(
        function(player)
            if teleportDropdown then
                teleportDropdown:Refresh(updateTeleportPlayers(), true)
            end
        end
    )
    
    local function teleportToPlayer()
        if (teleportTarget and teleportTarget.Character) then
            local targetRoot = teleportTarget.Character:FindFirstChild("HumanoidRootPart")
            local localRoot = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if (targetRoot and localRoot) then
                localRoot.CFrame = targetRoot.CFrame
                OrionLib:MakeNotification({
                    Name = "Teleport",
                    Content = "Successfully teleported to " .. teleportTarget.Name,
                    Image = "rbxassetid://4483345998",
                    Time = 3
                })
            end
        else
            OrionLib:MakeNotification({
                Name = "Error",
                Content = "Target not found or unavailable",
                Image = "rbxassetid://4483345998",
                Time = 3
            })
        end
    end
    
    Tabs.TeleportTab:AddButton({
        Name = "Teleport to player",
        Callback = teleportToPlayer
    })
    
    Tabs.TeleportTab:AddButton({
        Name = "Update players list",
        Callback = function()
            teleportDropdown:Refresh(updateTeleportPlayers(), true)
        end    
    })
    
    Tabs.TeleportTab:AddSection({
        Name = "Special TP"
    })
    
    local function teleportToLobby()
        local lobby = workspace:FindFirstChild("Lobby")
        if not lobby then
            OrionLib:MakeNotification({
                Name = "Teleport",
                Content = "Lobby not found!",
                Image = "rbxassetid://4483345998",
                Time = 2
            })
            return
        end
        local spawnPoint = lobby:FindFirstChild("SpawnPoint") or lobby:FindFirstChildOfClass("SpawnLocation")
        if not spawnPoint then
            spawnPoint = lobby:FindFirstChildWhichIsA("BasePart") or lobby
        end
        if (LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")) then
            LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(spawnPoint.Position + Vector3.new(0, 3, 0))
            OrionLib:MakeNotification({
                Name = "Teleport",
                Content = "Teleported to Lobby!",
                Image = "rbxassetid://4483345998",
                Time = 2
            })
        end
    end
    
    Tabs.TeleportTab:AddButton({
        Name = "Teleport to Lobby",
        Callback = teleportToLobby
    })
    
    Tabs.TeleportTab:AddButton({
        Name = "Teleport to Sheriff",
        Callback = function()
            UpdateRoles()
            if Sheriff then
                local sheriffPlayer = Players:FindFirstChild(Sheriff)
                if (sheriffPlayer and sheriffPlayer.Character) then
                    local targetRoot = sheriffPlayer.Character:FindFirstChild("HumanoidRootPart")
                    local localRoot = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                    if (targetRoot and localRoot) then
                        localRoot.CFrame = targetRoot.CFrame
                        OrionLib:MakeNotification({
                            Name = "Teleport",
                            Content = "Successfully teleported to sheriff " .. Sheriff,
                            Image = "rbxassetid://4483345998",
                            Time = 3
                        })
                    end
                else
                    OrionLib:MakeNotification({
                        Name = "Error",
                        Content = "Sheriff not found or unavailable",
                        Image = "rbxassetid://4483345998",
                        Time = 3
                    })
                end
            else
                OrionLib:MakeNotification({
                    Name = "Error",
                    Content = "Sheriff not defined in current match",
                    Image = "rbxassetid://4483345998",
                    Time = 3
                })
            end
        end    
    })
    
    Tabs.TeleportTab:AddButton({
        Name = "Teleport to Murderer",
        Callback = function()
            UpdateRoles()
            if Murder then
                local murderPlayer = Players:FindFirstChild(Murder)
                if (murderPlayer and murderPlayer.Character) then
                    local targetRoot = murderPlayer.Character:FindFirstChild("HumanoidRootPart")
                    local localRoot = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                    if (targetRoot and localRoot) then
                        localRoot.CFrame = targetRoot.CFrame
                        OrionLib:MakeNotification({
                            Name = "Teleport",
                            Content = "Successfully teleported to murderer " .. Murder,
                            Image = "rbxassetid://4483345998",
                            Time = 3
                        })
                    end
                else
                    OrionLib:MakeNotification({
                        Name = "Error",
                        Content = "Murderer not found or unavailable",
                        Image = "rbxassetid://4483345998",
                        Time = 3
                    })
                end
            else
                OrionLib:MakeNotification({
                    Name = "Error",
                    Content = "Murderer not defined in current match",
                    Image = "rbxassetid://4483345998",
                    Time = 3
                })
            end
        end    
    })
    
    -- Aimbot Tab
    local roles = {}
    local Murder, Sheriff
    local isCameraLocked = false
    local isSpectating = false
    local lockedRole = nil
    local cameraConnection = nil
    local originalCameraType = Enum.CameraType.Custom
    local originalCameraSubject = nil
    
    Tabs.AimbotTab:AddSection({
        Name = "Default AimBot"
    })
    
    local RoleDropdown = Tabs.AimbotTab:AddDropdown({
        Name = "Target Role",
        Default = "None",
        Options = {"None", "Sheriff", "Murderer"},
        Callback = function(selected)
            lockedRole = ((selected ~= "None") and selected) or nil
        end    
    })
    
    Tabs.AimbotTab:AddToggle({
        Name = "Spectate Mode",
        Default = false,
        Callback = function(state)
            isSpectating = state
            if state then
                originalCameraType = CurrentCamera.CameraType
                originalCameraSubject = CurrentCamera.CameraSubject
                CurrentCamera.CameraType = Enum.CameraType.Scriptable
            else
                CurrentCamera.CameraType = originalCameraType
                CurrentCamera.CameraSubject = originalCameraSubject
            end
        end    
    })
    
    Tabs.AimbotTab:AddToggle({
        Name = "Lock Camera",
        Default = false,
        Callback = function(state)
            isCameraLocked = state
            if (not state and not isSpectating) then
                CurrentCamera.CameraType = originalCameraType
                CurrentCamera.CameraSubject = originalCameraSubject
            end
        end    
    })
    
    local function GetTargetPosition()
        if not lockedRole then
            return nil
        end
        local targetName = ((lockedRole == "Sheriff") and Sheriff) or Murder
        if not targetName then
            return nil
        end
        local player = Players:FindFirstChild(targetName)
        if (not player or not IsAlive(player)) then
            return nil
        end
        local character = player.Character
        if not character then
            return nil
        end
        local head = character:FindFirstChild("Head")
        return (head and head.Position) or nil
    end
    
    local function UpdateSpectate()
        if (not isSpectating or not lockedRole) then
            return
        end
        local targetPos = GetTargetPosition()
        if not targetPos then
            return
        end
        local offset = CFrame.new(0, 2, 8)
        local targetChar = Players:FindFirstChild(((lockedRole == "Sheriff") and Sheriff) or Murder).Character
        if targetChar then
            local root = targetChar:FindFirstChild("HumanoidRootPart")
            if root then
                CurrentCamera.CFrame = root.CFrame * offset
            end
        end
    end
    
    local function UpdateLockCamera()
        if (not isCameraLocked or not lockedRole) then
            return
        end
        local targetPos = GetTargetPosition()
        if not targetPos then
            return
        end
        local currentPos = CurrentCamera.CFrame.Position
        CurrentCamera.CFrame = CFrame.new(currentPos, targetPos)
    end
    
    local function Update()
        if isSpectating then
            UpdateSpectate()
        elseif isCameraLocked then
            UpdateLockCamera()
        end
    end
    
    local function AutoUpdate()
        while true do
            UpdateRoles()
            task.wait(3)
        end
    end
    
    coroutine.wrap(AutoUpdate)()
    cameraConnection = RunService.RenderStepped:Connect(Update)
    
    LocalPlayer.AncestryChanged:Connect(
        function()
            if (not LocalPlayer.Parent and cameraConnection) then
                cameraConnection:Disconnect()
                CurrentCamera.CameraType = originalCameraType
                CurrentCamera.CameraSubject = originalCameraSubject
            end
        end
    )
    
    UpdateRoles()
    
    Tabs.AimbotTab:AddSection({
        Name = "Silent Aimbot (On rework)"
    })
    
    -- AutoFarm System
    local AutoFarm = {
        Enabled = false,
        Mode = "Teleport",
        TeleportDelay = 0,
        MoveSpeed = 50,
        WalkSpeed = 32,
        Connection = nil,
        CoinCheckInterval = 0.5,
        CoinContainers = {
            "Factory",
            "Hospital3",
            "MilBase",
            "House2",
            "Workplace",
            "Mansion2",
            "BioLab",
            "Hotel",
            "Bank2",
            "PoliceStation",
            "ResearchFacility",
            "Lobby"
        }
    }
    
    local function findNearestCoin()
        local closestCoin = nil
        local shortestDistance = math.huge
        local character = LocalPlayer.Character
        local humanoidRootPart = character and character:FindFirstChild("HumanoidRootPart")
        if not humanoidRootPart then
            return nil
        end
        for _, containerName in ipairs(AutoFarm.CoinContainers) do
            local container = workspace:FindFirstChild(containerName)
            if container then
                local coinContainer =
                    ((containerName == "Lobby") and container) or container:FindFirstChild("CoinContainer")
                if coinContainer then
                    for _, coin in ipairs(coinContainer:GetChildren()) do
                        if coin:IsA("BasePart") then
                            local distance = (humanoidRootPart.Position - coin.Position).Magnitude
                            if (distance < shortestDistance) then
                                shortestDistance = distance
                                closestCoin = coin
                            end
                        end
                    end
                end
            end
        end
        return closestCoin
    end
    
    local function teleportToCoin(coin)
        if (not coin or not LocalPlayer.Character) then
            return
        end
        local humanoidRootPart = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if not humanoidRootPart then
            return
        end
        humanoidRootPart.CFrame = CFrame.new(coin.Position + Vector3.new(0, 3, 0))
        task.wait(AutoFarm.TeleportDelay)
    end
    
    local function smoothMoveToCoin(coin)
        if (not coin or not LocalPlayer.Character) then
            return
        end
        local humanoidRootPart = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if not humanoidRootPart then
            return
        end
        local startTime = tick()
        local startPos = humanoidRootPart.Position
        local endPos = coin.Position + Vector3.new(0, 3, 0)
        local distance = (startPos - endPos).Magnitude
        local duration = distance / AutoFarm.MoveSpeed
        while ((tick() - startTime) < duration) and AutoFarm.Enabled do
            if (not coin or not coin.Parent) then
                break
            end
            local progress = math.min((tick() - startTime) / duration, 1)
            humanoidRootPart.CFrame = CFrame.new(startPos:Lerp(endPos, progress))
            task.wait()
        end
    end
    
    local function walkToCoin(coin)
        if (not coin or not LocalPlayer.Character) then
            return
        end
        local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if not humanoid then
            return
        end
        humanoid.WalkSpeed = AutoFarm.WalkSpeed
        humanoid:MoveTo(coin.Position + Vector3.new(0, 0, 3))
        local startTime = tick()
        while AutoFarm.Enabled and (humanoid.MoveDirection.Magnitude > 0) and ((tick() - startTime) < 10) do
            task.wait(0.5)
        end
    end
    
    local function collectCoin(coin)
        if (not coin or not LocalPlayer.Character) then
            return
        end
        local humanoidRootPart = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if not humanoidRootPart then
            return
        end
        firetouchinterest(humanoidRootPart, coin, 0)
        firetouchinterest(humanoidRootPart, coin, 1)
    end
    
    local function farmLoop()
        while AutoFarm.Enabled do
            local coin = findNearestCoin()
            if coin then
                if (AutoFarm.Mode == "Teleport") then
                    teleportToCoin(coin)
                elseif (AutoFarm.Mode == "Smooth") then
                    smoothMoveToCoin(coin)
                else
                    walkToCoin(coin)
                end
                collectCoin(coin)
            else
                OrionLib:MakeNotification({
                    Name = "AutoFarm",
                    Content = "No coins found nearby!",
                    Image = "rbxassetid://4483345998",
                    Time = 2
                })
                task.wait(2)
            end
            task.wait(AutoFarm.CoinCheckInterval)
        end
    end
    
    -- AutoFarm Tab
    Tabs.AutoFarm:AddSection({
        Name = "Coin Farming"
    })
    
    Tabs.AutoFarm:AddDropdown({
        Name = "Movement Mode",
        Default = "Teleport",
        Options = {"Teleport", "Smooth", "Walk"},
        Callback = function(mode)
            AutoFarm.Mode = mode
            OrionLib:MakeNotification({
                Name = "AutoFarm",
                Content = "Mode set to: " .. mode,
                Image = "rbxassetid://4483345998",
                Time = 2
            })
        end    
    })
    
    Tabs.AutoFarm:AddSlider({
        Name = "Teleport Delay (sec)",
        Min = 0,
        Max = 1,
        Default = 0,
        Increment = 0.1,
        ValueName = "seconds",
        Callback = function(value)
            AutoFarm.TeleportDelay = value
        end    
    })
    
    Tabs.AutoFarm:AddSlider({
        Name = "Smooth Move Speed",
        Min = 20,
        Max = 200,
        Default = 50,
        Increment = 1,
        ValueName = "speed",
        Callback = function(value)
            AutoFarm.MoveSpeed = value
        end    
    })
    
    Tabs.AutoFarm:AddSlider({
        Name = "Walk Speed",
        Min = 16,
        Max = 100,
        Default = 32,
        Increment = 1,
        ValueName = "speed",
        Callback = function(value)
            AutoFarm.WalkSpeed = value
        end    
    })
    
    Tabs.AutoFarm:AddSlider({
        Name = "Check Interval (sec)",
        Min = 0.1,
        Max = 2,
        Default = 0.5,
        Increment = 0.1,
        ValueName = "seconds",
        Callback = function(value)
            AutoFarm.CoinCheckInterval = value
        end    
    })
    
    Tabs.AutoFarm:AddToggle({
        Name = "Enable AutoFarm",
        Default = false,
        Callback = function(state)
            AutoFarm.Enabled = state
            if state then
                AutoFarm.Connection = task.spawn(farmLoop)
                OrionLib:MakeNotification({
                    Name = "AutoFarm",
                    Content = "Started farming nearest coins!",
                    Image = "rbxassetid://4483345998",
                    Time = 2
                })
            else
                if AutoFarm.Connection then
                    task.cancel(AutoFarm.Connection)
                end
                OrionLib:MakeNotification({
                    Name = "AutoFarm",
                    Content = "Stopped farming coins",
                    Image = "rbxassetid://4483345998",
                    Time = 2
                })
            end
        end    
    })
    
    -- Innocent Tab
    local GunSystem = {
        AutoGrabEnabled = false,
        NotifyGunDrop = true,
        GunDropCheckInterval = 1,
        ActiveGunDrops = {},
        GunDropHighlights = {}
    }
    
    local function ScanForGunDrops()
        GunSystem.ActiveGunDrops = {}
        for _, mapName in ipairs(mapPaths) do
            local map = workspace:FindFirstChild(mapName)
            if map then
                local gunDrop = map:FindFirstChild("GunDrop")
                if gunDrop then
                    table.insert(GunSystem.ActiveGunDrops, gunDrop)
                end
            end
        end
        local rootGunDrop = workspace:FindFirstChild("GunDrop")
        if rootGunDrop then
            table.insert(GunSystem.ActiveGunDrops, rootGunDrop)
        end
    end
    
    local function EquipGun()
        if (LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Gun")) then
            return true
        end
        local gun = LocalPlayer.Backpack:FindFirstChild("Gun")
        if gun then
            gun.Parent = LocalPlayer.Character
            task.wait(0.1)
            return LocalPlayer.Character:FindFirstChild("Gun") ~= nil
        end
        return false
    end
    
    local function GrabGun(gunDrop)
        if not gunDrop then
            ScanForGunDrops()
            if (#GunSystem.ActiveGunDrops == 0) then
                OrionLib:MakeNotification({
                    Name = "Gun System",
                    Content = "No guns available on the map",
                    Image = "rbxassetid://4483345998",
                    Time = 3
                })
                return false
            end
            local nearestGun = nil
            local minDistance = math.huge
            local character = LocalPlayer.Character
            local humanoidRootPart = character and character:FindFirstChild("HumanoidRootPart")
            if humanoidRootPart then
                for _, drop in ipairs(GunSystem.ActiveGunDrops) do
                    local distance = (humanoidRootPart.Position - drop.Position).Magnitude
                    if (distance < minDistance) then
                        nearestGun = drop
                        minDistance = distance
                    end
                end
            end
            gunDrop = nearestGun
        end
        if (gunDrop and LocalPlayer.Character) then
            local humanoidRootPart = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if humanoidRootPart then
                humanoidRootPart.CFrame = gunDrop.CFrame
                task.wait(0.3)
                local prompt = gunDrop:FindFirstChildOfClass("ProximityPrompt")
                if prompt then
                    fireproximityprompt(prompt)
                    OrionLib:MakeNotification({
                        Name = "Gun System",
                        Content = "Successfully grabbed the gun!",
                        Image = "rbxassetid://4483345998",
                        Time = 3
                    })
                    return true
                end
            end
        end
        return false
    end
    
    local function AutoGrabGun()
        while GunSystem.AutoGrabEnabled do
            ScanForGunDrops()
            if ((#GunSystem.ActiveGunDrops > 0) and LocalPlayer.Character) then
                local humanoidRootPart = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                if humanoidRootPart then
                    local nearestGun = nil
                    local minDistance = math.huge
                    for _, gunDrop in ipairs(GunSystem.ActiveGunDrops) do
                        local distance = (humanoidRootPart.Position - gunDrop.Position).Magnitude
                        if (distance < minDistance) then
                            nearestGun = gunDrop
                            minDistance = distance
                        end
                    end
                    if nearestGun then
                        humanoidRootPart.CFrame = nearestGun.CFrame
                        task.wait(0.3)
                        local prompt = nearestGun:FindFirstChildOfClass("ProximityPrompt")
                        if prompt then
                            fireproximityprompt(prompt)
                            task.wait(1)
                        end
                    end
                end
            end
            task.wait(GunSystem.GunDropCheckInterval)
        end
    end
    
    local function GetMurderer()
        local roles = ReplicatedStorage:FindFirstChild("GetPlayerData"):InvokeServer()
        for playerName, data in pairs(roles) do
            if (data.Role == "Murderer") then
                return Players:FindFirstChild(playerName)
            end
        end
    end
    
    local function GrabAndShootMurderer()
        if not (LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Gun")) then
            if not GrabGun() then
                OrionLib:MakeNotification({
                    Name = "Gun System",
                    Content = "Failed to get gun!",
                    Image = "rbxassetid://4483345998",
                    Time = 3
                })
                return
            end
            task.wait(0.1)
        end
        if not EquipGun() then
            OrionLib:MakeNotification({
                Name = "Gun System",
                Content = "Failed to equip gun!",
                Image = "rbxassetid://4483345998",
                Time = 3
            })
            return
        end
        local roles = ReplicatedStorage:FindFirstChild("GetPlayerData", true):InvokeServer()
        local murderer = nil
        for name, data in pairs(roles) do
            if (data.Role == "Murderer") then
                murderer = Players:FindFirstChild(name)
                break
            end
        end
        if (not murderer or not murderer.Character) then
            OrionLib:MakeNotification({
                Name = "Gun System",
                Content = "Murderer not found!",
                Image = "rbxassetid://4483345998",
                Time = 3
            })
            return
        end
        local targetRoot = murderer.Character:FindFirstChild("HumanoidRootPart")
        local localRoot = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if (targetRoot and localRoot) then
            localRoot.CFrame = targetRoot.CFrame * CFrame.new(0, 0, -4)
            task.wait(0.1)
        end
        local gun = LocalPlayer.Character:FindFirstChild("Gun")
        if not gun then
            OrionLib:MakeNotification({
                Name = "Gun System",
                Content = "Gun not equipped!",
                Image = "rbxassetid://4483345998",
                Time = 3
            })
            return
        end
        local targetPart = murderer.Character:FindFirstChild("HumanoidRootPart")
        if not targetPart then
            return
        end
        local args = {[1] = 1, [2] = targetPart.Position, [3] = "AH2"}
        if (gun:FindFirstChild("KnifeLocal") and gun.KnifeLocal:FindFirstChild("CreateBeam")) then
            gun.KnifeLocal.CreateBeam.RemoteFunction:InvokeServer(unpack(args))
            OrionLib:MakeNotification({
                Name = "Gun System",
                Content = "Successfully shot the murderer!",
                Image = "rbxassetid://4483345998",
                Time = 3
            })
        end
    end
    
    local notifiedGunDrops = {}
    local mapGunDrops = {
        "ResearchFacility",
        "Hospital3",
        "MilBase",
        "House2",
        "Workplace",
        "Mansion2",
        "BioLab",
        "Hotel",
        "Factory",
        "Bank2",
        "PoliceStation"
    }
    
    local function checkForGunDrops()
        for _, mapName in ipairs(mapGunDrops) do
            local map = workspace:FindFirstChild(mapName)
            if map then
                local gunDrop = map:FindFirstChild("GunDrop")
                if (gunDrop and not notifiedGunDrops[gunDrop]) then
                    if GunSystem.NotifyGunDrop then
                        OrionLib:MakeNotification({
                            Name = "Gun Drop Spawned",
                            Content = "A gun has appeared on the map: " .. mapName,
                            Image = "rbxassetid://4483345998",
                            Time = 5
                        })
                    end
                    notifiedGunDrops[gunDrop] = true
                end
            end
        end
    end
    
    local function setupGunDropMonitoring()
        for _, mapName in ipairs(mapGunDrops) do
            local map = workspace:FindFirstChild(mapName)
            if map then
                if map:FindFirstChild("GunDrop") then
                    checkForGunDrops()
                end
                map.ChildAdded:Connect(
                    function(child)
                        if (child.Name == "GunDrop") then
                            task.wait(0.5)
                            checkForGunDrops()
                        end
                    end
                )
            end
        end
    end
    
    local function setupGunDropRemovalTracking()
        for _, mapName in ipairs(mapGunDrops) do
            local map = workspace:FindFirstChild(mapName)
            if map then
                map.ChildRemoved:Connect(
                    function(child)
                        if ((child.Name == "GunDrop") and notifiedGunDrops[child]) then
                            notifiedGunDrops[child] = nil
                        end
                    end
                )
            end
        end
    end
    
    setupGunDropMonitoring()
    setupGunDropRemovalTracking()
    
    workspace.ChildAdded:Connect(
        function(child)
            if table.find(mapGunDrops, child.Name) then
                task.wait(2)
                checkForGunDrops()
            end
        end
    )
    
    Tabs.InnocentTab:AddToggle({
        Name = "Notify GunDrop",
        Default = true,
        Callback = function(state)
            GunSystem.NotifyGunDrop = state
            if state then
                task.spawn(
                    function()
                        task.wait(1)
                        checkForGunDrops()
                    end
                )
            end
        end    
    })
    
    Tabs.InnocentTab:AddButton({
        Name = "Grab Gun",
        Callback = function()
            GrabGun()
        end    
    })
    
    Tabs.InnocentTab:AddToggle({
        Name = "Auto Grab Gun",
        Default = false,
        Callback = function(state)
            GunSystem.AutoGrabEnabled = state
            if state then
                coroutine.wrap(AutoGrabGun)()
                OrionLib:MakeNotification({
                    Name = "Gun System",
                    Content = "Auto Grab Gun enabled!",
                    Image = "rbxassetid://4483345998",
                    Time = 3
                })
            else
                OrionLib:MakeNotification({
                    Name = "Gun System",
                    Content = "Auto Grab Gun disabled",
                    Image = "rbxassetid://4483345998",
                    Time = 3
                })
            end
        end    
    })
    
    Tabs.InnocentTab:AddButton({
        Name = "Grab Gun & Shoot Murderer",
        Callback = function()
            GrabAndShootMurderer()
        end    
    })
    
    task.spawn(
        function()
            if not LocalPlayer.Character then
                LocalPlayer.CharacterAdded:Wait()
            end
            ScanForGunDrops()
            if GunSystem.AutoGrabEnabled then
                coroutine.wrap(AutoGrabGun)()
            end
        end
    )
    
    -- Murder Tab
    local killActive = false
    local attackDelay = 0.5
    local targetRoles = {"Sheriff", "Hero", "Innocent"}
    
    local function getPlayerRole(player)
        local roles = ReplicatedStorage:FindFirstChild("GetPlayerData", true):InvokeServer()
        if (roles and roles[player.Name]) then
            return roles[player.Name].Role
        end
        return nil
    end
    
    local function equipKnife()
        local character = LocalPlayer.Character
        if not character then
            return false
        end
        if character:FindFirstChild("Knife") then
            return true
        end
        local knife = LocalPlayer.Backpack:FindFirstChild("Knife")
        if knife then
            knife.Parent = character
            return true
        end
        return false
    end
    
    local function getNearestTarget()
        local targets = {}
        local roles = ReplicatedStorage:FindFirstChild("GetPlayerData", true):InvokeServer()
        local localRoot = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if not localRoot then
            return nil
        end
        for _, player in ipairs(Players:GetPlayers()) do
            if ((player ~= LocalPlayer) and player.Character) then
                local role = getPlayerRole(player)
                local humanoid = player.Character:FindFirstChild("Humanoid")
                local targetRoot = player.Character:FindFirstChild("HumanoidRootPart")
                if (role and humanoid and (humanoid.Health > 0) and targetRoot and table.find(targetRoles, role)) then
                    table.insert(
                        targets,
                        {Player = player, Distance = (localRoot.Position - targetRoot.Position).Magnitude}
                    )
                end
            end
        end
        table.sort(
            targets,
            function(a, b)
                return a.Distance < b.Distance
            end
        )
        return (targets[1] and targets[1].Player) or nil
    end
    
    local function attackTarget(target)
        if (not target or not target.Character) then
            return false
        end
        local humanoid = target.Character:FindFirstChild("Humanoid")
        if (not humanoid or (humanoid.Health <= 0)) then
            return false
        end
        if not equipKnife() then
            OrionLib:MakeNotification({
                Name = "Kill Targets",
                Content = "No knife found!",
                Image = "rbxassetid://4483345998",
                Time = 2
            })
            return false
        end
        local targetRoot = target.Character:FindFirstChild("HumanoidRootPart")
        local localRoot = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if (targetRoot and localRoot) then
            localRoot.CFrame =
                CFrame.new(
                targetRoot.Position + ((localRoot.Position - targetRoot.Position).Unit * 2),
                targetRoot.Position
            )
        end
        local knife = LocalPlayer.Character:FindFirstChild("Knife")
        if (knife and knife:FindFirstChild("Stab")) then
            for i = 1, 3 do
                knife.Stab:FireServer("Down")
            end
            return true
        end
        return false
    end
    
    local function killTargets()
        if killActive then
            return
        end
        killActive = true
        OrionLib:MakeNotification({
            Name = "Kill Targets",
            Content = "Starting attack on nearest targets...",
            Image = "rbxassetid://4483345998",
            Time = 2
        })
        local function attackSequence()
            while killActive do
                local target = getNearestTarget()
                if not target then
                    OrionLib:MakeNotification({
                        Name = "Kill Targets",
                        Content = "No valid targets found!",
                        Image = "rbxassetid://4483345998",
                        Time = 3
                    })
                    killActive = false
                    break
                end
                if attackTarget(target) then
                    OrionLib:MakeNotification({
                        Name = "Kill Targets",
                        Content = "Attacked " .. target.Name,
                        Image = "rbxassetid://4483345998",
                        Time = 1
                    })
                end
                task.wait(attackDelay)
            end
        end
        task.spawn(attackSequence)
    end
    
    local function stopKilling()
        killActive = false
        OrionLib:MakeNotification({
            Name = "Kill Targets",
            Content = "Attack sequence stopped",
            Image = "rbxassetid://4483345998",
            Time = 2
        })
    end
    
    Tabs.MurderTab:AddSection({
        Name = "Kill Functions"
    })
    
    Tabs.MurderTab:AddToggle({
        Name = "Kill All",
        Default = false,
        Callback = function(state)
            if state then
                killTargets()
            else
                stopKilling()
            end
        end    
    })
    
    Tabs.MurderTab:AddSlider({
        Name = "Attack Delay",
        Min = 0.1,
        Max = 2,
        Default = 0.5,
        Increment = 0.1,
        ValueName = "seconds",
        Callback = function(value)
            attackDelay = value
            OrionLib:MakeNotification({
                Name = "Kill Targets",
                Content = "Delay set to " .. value .. "s",
                Image = "rbxassetid://4483345998",
                Time = 2
            })
        end    
    })
    
    Tabs.MurderTab:AddButton({
        Name = "Equip Knife",
        Callback = function()
            if equipKnife() then
                OrionLib:MakeNotification({
                    Name = "Knife",
                    Content = "Knife equipped!",
                    Image = "rbxassetid://4483345998",
                    Time = 2
                })
            else
                OrionLib:MakeNotification({
                    Name = "Knife",
                    Content = "No knife found!",
                    Image = "rbxassetid://4483345998",
                    Time = 2
                })
            end
        end    
    })
    
    -- Sheriff Tab
    local shotButton = nil
    local shotButtonFrame = nil
    local shotButtonActive = false
    local shotType = "Default"
    local buttonSize = 50
    local isDragging = false
    
    local function CreateShotButton()
        if shotButton then
            return
        end
        local screenGui = game:GetService("CoreGui"):FindFirstChild("Orion_SheriffGui") or Instance.new("ScreenGui")
        screenGui.Name = "Orion_SheriffGui"
        screenGui.Parent = game:GetService("CoreGui")
        screenGui.ResetOnSpawn = false
        screenGui.DisplayOrder = 999
        screenGui.IgnoreGuiInset = true
        
        shotButtonFrame = Instance.new("Frame")
        shotButtonFrame.Name = "ShotButtonFrame"
        shotButtonFrame.Size = UDim2.new(0, buttonSize, 0, buttonSize)
        shotButtonFrame.Position = UDim2.new(1, -buttonSize - 20, 0.5, -buttonSize / 2)
        shotButtonFrame.AnchorPoint = Vector2.new(1, 0.5)
        shotButtonFrame.BackgroundTransparency = 1
        shotButtonFrame.ZIndex = 100
        
        shotButton = Instance.new("TextButton")
        shotButton.Name = "SheriffShotButton"
        shotButton.Size = UDim2.new(1, 0, 1, 0)
        shotButton.BackgroundColor3 = Color3.fromRGB(120, 120, 120)
        shotButton.BackgroundTransparency = 0.5
        shotButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        shotButton.Text = "SHOT"
        shotButton.TextSize = 14
        shotButton.Font = Enum.Font.GothamBold
        shotButton.BorderSizePixel = 0
        shotButton.ZIndex = 101
        shotButton.AutoButtonColor = false
        shotButton.TextScaled = true
        
        local stroke = Instance.new("UIStroke")
        stroke.Color = Color3.fromRGB(0, 40, 150)
        stroke.Thickness = 2
        stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        stroke.Transparency = 0.3
        stroke.Parent = shotButton
        
        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(0.3, 0)
        corner.Parent = shotButton
        
        local shadow = Instance.new("ImageLabel")
        shadow.Name = "Shadow"
        shadow.Size = UDim2.new(1, 10, 1, 10)
        shadow.Position = UDim2.new(0.5, 0, 0.5, 0)
        shadow.AnchorPoint = Vector2.new(0.5, 0.5)
        shadow.BackgroundTransparency = 1
        shadow.Image = "rbxassetid://1316045217"
        shadow.ImageColor3 = Color3.new(0, 0, 0)
        shadow.ImageTransparency = 0.85
        shadow.ScaleType = Enum.ScaleType.Slice
        shadow.SliceCenter = Rect.new(10, 10, 118, 118)
        shadow.ZIndex = 100
        shadow.Parent = shotButton
        
        local function animatePress()
            local tweenService = game:GetService("TweenService")
            local pressDown =
                tweenService:Create(
                shotButton,
                TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                {
                    Size = UDim2.new(0.9, 0, 0.9, 0),
                    BackgroundColor3 = Color3.fromRGB(70, 70, 70),
                    TextColor3 = Color3.fromRGB(200, 200, 255)
                }
            )
            local pressUp =
                tweenService:Create(
                shotButton,
                TweenInfo.new(0.2, Enum.EasingStyle.Elastic, Enum.EasingDirection.Out),
                {
                    Size = UDim2.new(1, 0, 1, 0),
                    BackgroundColor3 = Color3.fromRGB(100, 100, 100),
                    TextColor3 = Color3.fromRGB(255, 255, 255)
                }
            )
            pressDown:Play()
            pressDown.Completed:Wait()
            pressUp:Play()
        end
        
        shotButton.MouseButton1Click:Connect(
            function()
                animatePress()
                if
                    (not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("Humanoid") or
                        (LocalPlayer.Character.Humanoid.Health <= 0))
                 then
                    return
                end
                local success, roles =
                    pcall(
                    function()
                        return ReplicatedStorage:FindFirstChild("GetPlayerData", true):InvokeServer()
                    end
                )
                if (not success or not roles) then
                    return
                end
                local murderer = nil
                for name, data in pairs(roles) do
                    if (data.Role == "Murderer") then
                        murderer = Players:FindFirstChild(name)
                        break
                    end
                end
                if
                    (not murderer or not murderer.Character or not murderer.Character:FindFirstChild("Humanoid") or
                        (murderer.Character.Humanoid.Health <= 0))
                 then
                    return
                end
                local gun = LocalPlayer.Character:FindFirstChild("Gun") or LocalPlayer.Backpack:FindFirstChild("Gun")
                if ((shotType == "Default") and not gun) then
                    return
                end
                if (gun and not LocalPlayer.Character:FindFirstChild("Gun")) then
                    gun.Parent = LocalPlayer.Character
                end
                if (shotType == "Teleport") then
                    local targetRoot = murderer.Character:FindFirstChild("HumanoidRootPart")
                    local localRoot = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                    if (targetRoot and localRoot) then
                        localRoot.CFrame = targetRoot.CFrame * CFrame.new(0, 0, -4)
                    end
                end
                if (gun and not LocalPlayer.Character:FindFirstChild("Gun")) then
                    gun.Parent = LocalPlayer.Character
                end
                gun = LocalPlayer.Character:FindFirstChild("Gun")
                if (gun and gun:FindFirstChild("KnifeLocal")) then
                    local targetPart = murderer.Character:FindFirstChild("HumanoidRootPart")
                    if targetPart then
                        local args = {[1] = 10, [2] = targetPart.Position, [3] = "AH2"}
                        gun.KnifeLocal.CreateBeam.RemoteFunction:InvokeServer(unpack(args))
                    end
                end
            end
        )
        
        local dragInput
        local dragStart
        local startPos
        
        local function updateInput(input)
            local delta = input.Position - dragStart
            local newPos =
                UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
            local guiSize = game:GetService("CoreGui").AbsoluteSize
            newPos =
                UDim2.new(
                math.clamp(newPos.X.Scale, 0, 1),
                math.clamp(newPos.X.Offset, 0, guiSize.X - buttonSize),
                math.clamp(newPos.Y.Scale, 0, 1),
                math.clamp(newPos.Y.Offset, 0, guiSize.Y - buttonSize)
            )
            shotButtonFrame.Position = newPos
        end
        
        shotButton.InputBegan:Connect(
            function(input)
                if (input.UserInputType == Enum.UserInputType.MouseButton1) then
                    isDragging = true
                    dragStart = input.Position
                    startPos = shotButtonFrame.Position
                    animatePress()
                    input.Changed:Connect(
                        function()
                            if (input.UserInputState == Enum.UserInputState.End) then
                                isDragging = false
                            end
                        end
                    )
                end
            end
        )
        
        shotButton.InputChanged:Connect(
            function(input)
                if ((input.UserInputType == Enum.UserInputType.MouseMovement) and isDragging) then
                    updateInput(input)
                end
            end
        )
        
        shotButton.Parent = shotButtonFrame
        shotButtonFrame.Parent = screenGui
        shotButtonActive = true
        OrionLib:MakeNotification({
            Name = "Sheriff System",
            Content = "Shot button activated",
            Image = "rbxassetid://4483345998",
            Time = 3
        })
    end
    
    local function RemoveShotButton()
        if not shotButton then
            return
        end
        if shotButton then
            shotButton:Destroy()
            shotButton = nil
        end
        if shotButtonFrame then
            shotButtonFrame:Destroy()
            shotButtonFrame = nil
        end
        local screenGui = game:GetService("CoreGui"):FindFirstChild("Orion_SheriffGui")
        if screenGui then
            screenGui:Destroy()
        end
        shotButtonActive = false
        OrionLib:MakeNotification({
            Name = "Shot Button",
            Content = "Deactivated",
            Image = "rbxassetid://4483345998",
            Time = 3
        })
    end
    
    Tabs.SheriffTab:AddSection({
        Name = "Shot functions"
    })
    
    Tabs.SheriffTab:AddDropdown({
        Name = "Shot Type",
        Default = "Default",
        Options = {"Default", "Teleport"},
        Callback = function(selectedType)
            shotType = selectedType
            OrionLib:MakeNotification({
                Name = "Sheriff System",
                Content = "Shot Type: " .. selectedType,
                Image = "rbxassetid://4483345998",
                Time = 3
            })
        end    
    })
    
    Tabs.SheriffTab:AddButton({
        Name = "Shoot murderer",
        Callback = function()
            ShootMurderer()
        end    
    })
    
    Tabs.SheriffTab:AddSection({
        Name = "Shot Button"
    })
    
    Tabs.SheriffTab:AddButton({
        Name = "Toggle Shot Button",
        Callback = function()
            if shotButtonActive then
                RemoveShotButton()
            else
                CreateShotButton()
            end
        end    
    })
    
    Tabs.SheriffTab:AddSlider({
        Name = "Button Size",
        Min = 10,
        Max = 100,
        Default = 50,
        Increment = 1,
        ValueName = "size",
        Callback = function(size)
            buttonSize = size
            if shotButtonActive then
                local currentPos =
                    (shotButtonFrame and shotButtonFrame.Position) or
                    UDim2.new(1, -buttonSize - 20, 0.5, -buttonSize / 2)
                RemoveShotButton()
                CreateShotButton()
                if shotButtonFrame then
                    shotButtonFrame.Position = currentPos
                end
            end
            OrionLib:MakeNotification({
                Name = "Sheriff System",
                Content = "Size: " .. size,
                Image = "rbxassetid://4483345998",
                Time = 3
            })
        end    
    })
    
    local function ShootMurderer()
        if
            (not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("Humanoid") or
                (LocalPlayer.Character.Humanoid.Health <= 0))
         then
            return
        end
        local success, roles =
            pcall(
            function()
                return ReplicatedStorage:FindFirstChild("GetPlayerData", true):InvokeServer()
            end
        )
        if (not success or not roles) then
            return
        end
        local murderer = nil
        for name, data in pairs(roles) do
            if (data.Role == "Murderer") then
                murderer = Players:FindFirstChild(name)
                break
            end
        end
        if
            (not murderer or not murderer.Character or not murderer.Character:FindFirstChild("Humanoid") or
                (murderer.Character.Humanoid.Health <= 0))
         then
            return
        end
        local gun = LocalPlayer.Character:FindFirstChild("Gun") or LocalPlayer.Backpack:FindFirstChild("Gun")
        if ((shotType == "Default") and not gun) then
            return
        end
        if (gun and not LocalPlayer.Character:FindFirstChild("Gun")) then
            gun.Parent = LocalPlayer.Character
        end
        if (shotType == "Teleport") then
            local targetRoot = murderer.Character:FindFirstChild("HumanoidRootPart")
            local localRoot = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if (targetRoot and localRoot) then
                localRoot.CFrame = targetRoot.CFrame * CFrame.new(0, 0, -4)
            end
        end
        if (gun and not LocalPlayer.Character:FindFirstChild("Gun")) then
            gun.Parent = LocalPlayer.Character
        end
        gun = LocalPlayer.Character:FindFirstChild("Gun")
        if (gun and gun:FindFirstChild("KnifeLocal")) then
            local targetPart = murderer.Character:FindFirstChild("HumanoidRootPart")
            if targetPart then
                local args = {[1] = 1, [2] = targetPart.Position, [3] = "AH2"}
                gun.KnifeLocal.CreateBeam.RemoteFunction:InvokeServer(unpack(args))
            end
        end
    end
    
    -- Settings Tab
    local Settings = {
        Hitbox = {Enabled = false, Size = 5, Color = Color3.new(1, 0, 0), Adornments = {}, Connections = {}},
        Noclip = {Enabled = false, Connection = nil},
        AntiAFK = {Enabled = false, Connection = nil}
    }
    
    local function ToggleNoclip(state)
        if state then
            Settings.Noclip.Connection =
                RunService.Stepped:Connect(
                function()
                    local chr = LocalPlayer.Character
                    if chr then
                        for _, part in pairs(chr:GetDescendants()) do
                            if part:IsA("BasePart") then
                                part.CanCollide = false
                            end
                        end
                    end
                end
            )
        elseif Settings.Noclip.Connection then
            Settings.Noclip.Connection:Disconnect()
        end
    end
    
    local function UpdateHitboxes()
        for _, plr in pairs(Players:GetPlayers()) do
            if (plr ~= LocalPlayer) then
                local chr = plr.Character
                local box = Settings.Hitbox.Adornments[plr]
                if (chr and Settings.Hitbox.Enabled) then
                    local root = chr:FindFirstChild("HumanoidRootPart")
                    if root then
                        if not box then
                            box = Instance.new("BoxHandleAdornment")
                            box.Adornee = root
                            box.Size = Vector3.new(Settings.Hitbox.Size, Settings.Hitbox.Size, Settings.Hitbox.Size)
                            box.Color3 = Settings.Hitbox.Color
                            box.Transparency = 0.4
                            box.ZIndex = 10
                            box.Parent = root
                            Settings.Hitbox.Adornments[plr] = box
                        else
                            box.Size = Vector3.new(Settings.Hitbox.Size, Settings.Hitbox.Size, Settings.Hitbox.Size)
                            box.Color3 = Settings.Hitbox.Color
                        end
                    end
                elseif box then
                    box:Destroy()
                    Settings.Hitbox.Adornments[plr] = nil
                end
            end
        end
    end
    
    local function ToggleAntiAFK(state)
        if state then
            Settings.AntiAFK.Connection =
                RunService.Heartbeat:Connect(
                function()
                    pcall(
                        function()
                            local vu = game:GetService("VirtualUser")
                            vu:CaptureController()
                            vu:ClickButton2(Vector2.new())
                        end
                    )
                end
            )
        elseif Settings.AntiAFK.Connection then
            Settings.AntiAFK.Connection:Disconnect()
        end
    end
    
    Tabs.SettingsTab:AddSection({
        Name = "Hitboxes"
    })
    
    Tabs.SettingsTab:AddToggle({
        Name = "Hitboxes",
        Callback = function(state)
            Settings.Hitbox.Enabled = state
            if state then
                RunService.Heartbeat:Connect(UpdateHitboxes)
            else
                for _, box in pairs(Settings.Hitbox.Adornments) do
                    if box then
                        box:Destroy()
                    end
                end
                Settings.Hitbox.Adornments = {}
            end
        end    
    })
    
    Tabs.SettingsTab:AddSlider({
        Name = "Hitbox size",
        Min = 1,
        Max = 10,
        Default = 5,
        Increment = 1,
        ValueName = "size",
        Callback = function(val)
            Settings.Hitbox.Size = val
            UpdateHitboxes()
        end    
    })
    
    Tabs.SettingsTab:AddColorpicker({
        Name = "Hitbox color",
        Default = Color3.fromRGB(255, 0, 0),
        Callback = function(col)
            Settings.Hitbox.Color = col
            UpdateHitboxes()
        end	  
    })
    
    Tabs.SettingsTab:AddSection({
        Name = "Character Functions"
    })
    
    Tabs.SettingsTab:AddToggle({
        Name = "Anti-AFK",
        Callback = function(state)
            Settings.AntiAFK.Enabled = state
            ToggleAntiAFK(state)
        end    
    })
    
    Tabs.SettingsTab:AddToggle({
        Name = "NoClip",
        Callback = function(state)
            Settings.Noclip.Enabled = state
            ToggleNoclip(state)
        end    
    })
    
    Tabs.SettingsTab:AddSection({
        Name = "Auto Execute"
    })
    
    local AutoInject = {
        Enabled = false,
        ScriptURL = "https://raw.githubusercontent.com/Snowt-Team/KRT-HUB/refs/heads/main/MM2.txt"
    }
    
    Tabs.SettingsTab:AddToggle({
        Name = "Auto Inject on Rejoin/Hop",
        Default = false,
        Callback = function(state)
            AutoInject.Enabled = state
            if state then
                SetupAutoInject()
                OrionLib:MakeNotification({
                    Name = "Auto Inject",
                    Content = "Auto-inject enabled! Script will restart automatically.",
                    Time = 3
                })
            else
                OrionLib:MakeNotification({
                    Name = "Auto Inject",
                    Content = "Auto-inject disabled",
                    Time = 3
                })
            end
        end    
    })
    
    local function SetupAutoInject()
        if not AutoInject.Enabled then
            return
        end
        local TeleportService = game:GetService("TeleportService")
        local Players = game:GetService("Players")
        local LocalPlayer = Players.LocalPlayer
        
        spawn(
            function()
                wait(2)
                if AutoInject.Enabled then
                    pcall(
                        function()
                            loadstring(game:HttpGet(AutoInject.ScriptURL))()
                        end
                    )
                end
            end
        )
        
        LocalPlayer.OnTeleport:Connect(
            function(state)
                if ((state == Enum.TeleportState.Started) and AutoInject.Enabled) then
                    queue_on_teleport(
                        [[
                        wait(2)
                        loadstring(game:HttpGet("]] .. AutoInject.ScriptURL .. [["))()
                        ]]
                    )
                end
            end
        )
        
        game:GetService("Players").PlayerRemoving:Connect(
            function(player)
                if ((player == LocalPlayer) and AutoInject.Enabled) then
                    queue_on_teleport(
                        [[
                        wait(2)
                        loadstring(game:HttpGet("]] .. AutoInject.ScriptURL .. [["))()
                        ]]
                    )
                end
            end
        )
    end
    
    Tabs.SettingsTab:AddButton({
        Name = "Manual Re-Inject",
        Callback = function()
            pcall(
                function()
                    loadstring(game:HttpGet(AutoInject.ScriptURL))()
                    OrionLib:MakeNotification({
                        Name = "Manual Inject",
                        Content = "Script reloaded successfully!",
                        Time = 3
                    })
                end
            )
        end    
    })
    
    -- Socials Tab
    Tabs.SocialsTab:AddParagraph({
        Title = "SnowT",
        Content = "My socials"
    })
    
    Tabs.SocialsTab:AddButton({
        Name = "KRT Hub TG",
        Callback = function()
            if pcall(setclipboard, "https://t.me/KRT_client") then
                OrionLib:MakeNotification({
                    Name = "Copied!",
                    Content = "Link copied to clipboard.",
                    Time = 3
                })
            else
                OrionLib:MakeNotification({
                    Name = "Copy Error",
                    Content = "Failed to copy link. setclipboard function may not be available.",
                    Time = 5
                })
            end
        end    
    })
    
    Tabs.SocialsTab:AddParagraph({
        Title = "Kawasaki",
        Content = "Socials My Friend"
    })
    
    Tabs.SocialsTab:AddButton({
        Name = "TG Channel",
        Callback = function()
            if pcall(setclipboard, "https://t.me/+XFKScmKEPS41OWQ1") then
                OrionLib:MakeNotification({
                    Name = "Copied!",
                    Content = "Link copied to clipboard.",
                    Time = 3
                })
            else
                OrionLib:MakeNotification({
                    Name = "Copy Error",
                    Content = "Failed to copy link. setclipboard function may not be available.",
                    Time = 5
                })
            end
        end    
    })
    
    -- Changelogs Tab
    Tabs.ChangelogsTab:AddParagraph({
        Title = "Changelogs:",
        Content = [[
⚫Lucent Hub MM2 commands:

|• Silent Aimbot
|• All Sheriff Functions
|• Better shot
|• Fixed errors
|• Shot variants [default; teleport]
|• Faster shots
|• New shot button
|• Shot button settings
|• All Murder Functions
|• Fixed kill player
|• Kill all function
|• All Innocent Functions
|• Grab GunDrop
|• Auto Grab Gun Drop
|• Grab gun and shoot murder function
|• Fixed Notifications
|• Fixed Check GunDrop Function
|• Autofarm Money
|• Autofarm variables [Tp; smooth; walk]
|• Coin checker function
|• Autofarm settings
|• Tp to lobby function
]]
    })
    
    Tabs.ChangelogsTab:AddParagraph({
        Title = "Next:",
        Content = [[The next update is [v1.1]

In future we will be add:
• Autofarm rare eggs
• Fix bugs
• New esp functions [tracers; names; highlights and more!]
• Grab Gun Variables [Tp to gun; Gun tp to you]
]]
    })
    
    -- Server Tab
    local TeleportService = game:GetService("TeleportService")
    local HttpService = game:GetService("HttpService")
    
    Tabs.ServerTab:AddButton({
        Name = "Rejoin",
        Callback = function()
            local success, error =
                pcall(
                function()
                    TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, Players.LocalPlayer)
                end
            )
            if not success then
                warn("Rejoin error:", error)
            end
        end    
    })
    
    Tabs.ServerTab:AddButton({
        Name = "Server Hop",
        Callback = function()
            local placeId = game.PlaceId
            local currentJobId = game.JobId
            local function serverHop()
                local servers = {}
                local success, result =
                    pcall(
                    function()
                        return HttpService:JSONDecode(
                            HttpService:GetAsync(
                                "https://games.roblox.com/v1/games/" ..
                                    placeId .. "/servers/Public?sortOrder=Asc&limit=100"
                            )
                        )
                    end
                )
                if (success and result and result.data) then
                    for _, server in ipairs(result.data) do
                        if (server.id ~= currentJobId) then
                            table.insert(servers, server)
                        end
                    end
                    if (#servers > 0) then
                        TeleportService:TeleportToPlaceInstance(placeId, servers[math.random(#servers)].id)
                    else
                        TeleportService:Teleport(placeId)
                    end
                else
                    TeleportService:Teleport(placeId)
                end
            end
            pcall(serverHop)
        end    
    })
    
    Tabs.ServerTab:AddButton({
        Name = "Join to Lower Server",
        Callback = function()
            local placeId = game.PlaceId
            local currentJobId = game.JobId
            local function joinLowerServer()
                local servers = {}
                local success, result =
                    pcall(
                    function()
                        return HttpService:JSONDecode(
                            HttpService:GetAsync(
                                "https://games.roblox.com/v1/games/" ..
                                    placeId .. "/servers/Public?sortOrder=Asc&limit=100"
                            )
                        )
                    end
                )
                if (success and result and result.data) then
                    for _, server in ipairs(result.data) do
                        if ((server.id ~= currentJobId) and (server.playing < (server.maxPlayers or 30))) then
                            table.insert(servers, server)
                        end
                    end
                    table.sort(
                        servers,
                        function(a, b)
                            return a.playing < b.playing
                        end
                    )
                    if (#servers > 0) then
                        TeleportService:TeleportToPlaceInstance(placeId, servers[1].id)
                    else
                        TeleportService:Teleport(placeId)
                    end
                else
                    TeleportService:Teleport(placeId)
                end
            end
            pcall(joinLowerServer)
        end    
    })
    
    -- Create toggle UI button
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "Toggleui"
    ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
    ScreenGui.ResetOnSpawn = false
    
    local Toggle = Instance.new("TextButton")
    Toggle.Name = "Toggle"
    Toggle.Parent = ScreenGui
    Toggle.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    Toggle.BackgroundTransparency = 0.5
    Toggle.Position = UDim2.new(0, 0, 0.454706937, 0)
    Toggle.Size = UDim2.new(0, 50, 0, 50)
    Toggle.Draggable = true
    
    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0.2, 0)
    Corner.Parent = Toggle
    
    local Image = Instance.new("ImageLabel")
    Image.Name = "Icon"
    Image.Parent = Toggle
    Image.Size = UDim2.new(1, 0, 1, 0)
    Image.BackgroundTransparency = 1
    Image.Image = "rbxassetid://117239677500065" 
    
    local Corner2 = Instance.new("UICorner")
    Corner2.CornerRadius = UDim.new(0.2, 0)
    Corner2.Parent = Image
    
    Toggle.MouseButton1Click:Connect(function()
        OrionLib:ToggleUi()
    end)
    
    -- Initialize the UI
    OrionLib:Init()
end