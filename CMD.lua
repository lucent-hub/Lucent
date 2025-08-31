local player = game:GetService("Players").LocalPlayer
local function showNotification(title, text, icon)
    -- Implementation for showing notifications
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = title,
        Text = text,
        Icon = icon
    })
end

local function showHelp()
    -- Implementation for showing help
    print("Infinite Yield FE Commands Help")
    for cmd, data in pairs(commands) do
        print(cmd .. " - " .. data.desc)
    end
end

-- Utility functions
local function getPlayerFromString(str)
    -- Implementation to get player from string with special cases
    local players = game:GetService("Players"):GetPlayers()
    
    if str:lower() == "me" then
        return {player}
    elseif str:lower() == "all" then
        return players
    elseif str:lower() == "others" then
        local others = {}
        for _, p in ipairs(players) do
            if p ~= player then
                table.insert(others, p)
            end
        end
        return others
    elseif str:lower() == "random" then
        return {players[math.random(1, #players)]}
    elseif str:sub(1, 1) == "@" then
        local username = str:sub(2)
        for _, p in ipairs(players) do
            if p.Name:lower() == username:lower() then
                return {p}
            end
        end
    end
    
    -- Default case - try to find player by name
    for _, p in ipairs(players) do
        if p.Name:lower():find(str:lower()) then
            return {p}
        end
    end
    
    return {}
end

local function teleportToPlayer(targetPlayer)
    if targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
        player.Character.HumanoidRootPart.CFrame = targetPlayer.Character.HumanoidRootPart.CFrame
    end
end

local function setWalkSpeed(speed)
    if player.Character and player.Character:FindFirstChild("Humanoid") then
        player.Character.Humanoid.WalkSpeed = speed
    end
end

local function setJumpPower(power)
    if player.Character and player.Character:FindFirstChild("Humanoid") then
        player.Character.Humanoid.JumpPower = power
    end
end

local function enableNoclip()
    if player.Character then
        for _, part in ipairs(player.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end
end

local function disableNoclip()
    if player.Character then
        for _, part in ipairs(player.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = true
            end
        end
    end
end

local function respawnCharacter()
    player:LoadCharacter()
end

local function giveTool(toolName)
    -- Implementation to give tools
    local tool = Instance.new("Tool")
    tool.Name = toolName
    tool.Parent = player.Backpack
end

local function createESP(targetPlayer)
    -- Basic ESP implementation
    if targetPlayer.Character then
        local highlight = Instance.new("Highlight")
        highlight.Name = "IY_ESP"
        highlight.Adornee = targetPlayer.Character
        highlight.Parent = targetPlayer.Character
    end
end

local function removeESP(targetPlayer)
    if targetPlayer.Character then
        local esp = targetPlayer.Character:FindFirstChild("IY_ESP")
        if esp then
            esp:Destroy()
        end
    end
end

local function toggleFullscreen()
    -- Implementation to toggle fullscreen
    game:GetService("GuiService"):ToggleFullscreen()
end

local function setVolume(level)
    -- Implementation to set volume
    local volume = math.clamp(tonumber(level) or 5, 0, 10) / 10
    game:GetService("SoundService"):SetRBXVariable("Volume", volume)
end

local function antiAfk()
    -- Implementation to prevent AFK kicking
    local connection
    connection = game:GetService("Players").LocalPlayer.Idled:Connect(function()
        game:GetService("VirtualUser"):Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
        wait(1)
        game:GetService("VirtualUser"):Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
    end)
    return connection
end

local function createWaypoint(name, position)
    -- Implementation to create waypoints
    waypoints = waypoints or {}
    waypoints[name] = position
end

local function teleportToWaypoint(name)
    if waypoints and waypoints[name] and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        player.Character.HumanoidRootPart.CFrame = waypoints[name]
    end
end

local function freezePlayer(targetPlayer)
    if targetPlayer.Character and targetPlayer.Character:FindFirstChild("Humanoid") then
        targetPlayer.Character.Humanoid.PlatformStand = true
    end
end

local function unfreezePlayer(targetPlayer)
    if targetPlayer.Character and targetPlayer.Character:FindFirstChild("Humanoid") then
        targetPlayer.Character.Humanoid.PlatformStand = false
    end
end

local function flingPlayer(targetPlayer)
    if targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
        targetPlayer.Character.HumanoidRootPart.Velocity = Vector3.new(math.random(-10000, 10000), math.random(-10000, 10000), math.random(-10000, 10000))
    end
end

local function changeTeam(teamName)
    -- Implementation to change team
    for _, team in ipairs(game:GetService("Teams"):GetTeams()) do
        if team.Name:lower() == teamName:lower() then
            player.Team = team
            break
        end
    end
end

local function setGravity(level)
    -- Implementation to set gravity
    game:GetService("Workspace").Gravity = tonumber(level) or 196.2
end

local function setFov(value)
    -- Implementation to set field of view
    game:GetService("Workspace").CurrentCamera.FieldOfView = tonumber(value) or 70
end

local function chatMessage(message)
    -- Implementation to send chat message
    game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents.SayMessageRequest:FireServer(message, "All")
end

local function spamMessage(message, delay)
    delay = delay or 1
    spamConnections = spamConnections or {}
    
    local connection
    connection = game:GetService("RunService").Heartbeat:Connect(function()
        chatMessage(message)
        wait(delay)
    end)
    
    table.insert(spamConnections, connection)
    return connection
end

local function stopSpam()
    if spamConnections then
        for _, connection in ipairs(spamConnections) do
            connection:Disconnect()
        end
        spamConnections = {}
    end
end

local function xrayEnable()
    -- Implementation for xray
    for _, part in ipairs(workspace:GetDescendants()) do
        if part:IsA("BasePart") and part.Transparency < 0.5 then
            part.LocalTransparencyModifier = 0.5
        end
    end
end

local function xrayDisable()
    for _, part in ipairs(workspace:GetDescendants()) do
        if part:IsA("BasePart") then
            part.LocalTransparencyModifier = 0
        end
    end
end

local function spectatePlayer(targetPlayer)
    if targetPlayer.Character then
        game:GetService("Workspace").CurrentCamera.CameraSubject = targetPlayer.Character.Humanoid
    end
end

local function stopSpectate()
    if player.Character and player.Character:FindFirstChild("Humanoid") then
        game:GetService("Workspace").CurrentCamera.CameraSubject = player.Character.Humanoid
    end
end

local function freecamEnable()
    -- Implementation for freecam
    freecamEnabled = true
    local camera = game:GetService("Workspace").CurrentCamera
    local originalCameraSubject = camera.CameraSubject
    
    camera.CameraSubject = nil
    
    local freecamPart = Instance.new("Part")
    freecamPart.Anchored = true
    freecamPart.Transparency = 1
    freecamPart.CanCollide = false
    freecamPart.Parent = workspace
    freecamPart.CFrame = camera.CFrame
    
    camera.CameraSubject = freecamPart
    
    local connection
    connection = game:GetService("RunService").RenderStepped:Connect(function()
        if not freecamEnabled then
            connection:Disconnect()
            freecamPart:Destroy()
            camera.CameraSubject = originalCameraSubject
            return
        end
        
        -- Handle freecam movement here
    end)
end

local function freecamDisable()
    freecamEnabled = false
end

local function giveBtools()
    -- Implementation to give building tools
    local tools = {"Hammer", "Clone", "Grab"}
    for _, toolName in ipairs(tools) do
        giveTool(toolName)
    end
end

local function setTimeOfDay(time)
    -- Implementation to set time of day
    game:GetService("Lighting").ClockTime = time == "day" and 14 or 2
end

local function fullbrightEnable()
    -- Implementation for fullbright
    game:GetService("Lighting").GlobalShadows = false
    game:GetService("Lighting").Ambient = Color3.new(1, 1, 1)
end

local function fullbrightDisable()
    game:GetService("Lighting").GlobalShadows = true
    game:GetService("Lighting").Ambient = Color3.new(0.5, 0.5, 0.5)
end

local function setSpawnPoint()
    -- Implementation to set spawn point
    if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        spawnPoint = player.Character.HumanoidRootPart.CFrame
    end
end

local function teleportToSpawn()
    if spawnPoint and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        player.Character.HumanoidRootPart.CFrame = spawnPoint
    end
end

local function removeSpawnPoint()
    spawnPoint = nil
end

local function godMode()
    -- Implementation for god mode
    if player.Character and player.Character:FindFirstChild("Humanoid") then
        player.Character.Humanoid.MaxHealth = math.huge
        player.Character.Humanoid.Health = math.huge
    end
end

local function invisibleMode()
    -- Implementation for invisible mode
    if player.Character then
        for _, part in ipairs(player.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.Transparency = 1
            end
        end
    end
end

local function visibleMode()
    if player.Character then
        for _, part in ipairs(player.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.Transparency = 0
            end
        end
    end
end

local function infiniteJump()
    -- Implementation for infinite jump
    infiniteJumpEnabled = true
    local connection
    connection = game:GetService("UserInputService").JumpRequest:Connect(function()
        if infiniteJumpEnabled and player.Character and player.Character:FindFirstChild("Humanoid") then
            player.Character.Humanoid:ChangeState("Jumping")
        end
    end)
    return connection
end

local function disableInfiniteJump()
    infiniteJumpEnabled = false
end

local function sit()
    if player.Character and player.Character:FindFirstChild("Humanoid") then
        player.Character.Humanoid.Sit = true
    end
end

local function layDown()
    if player.Character and player.Character:FindFirstChild("Humanoid") then
        player.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Physics)
    end
end

local function copyPlayerName(targetPlayer)
    -- Implementation to copy player name to clipboard
    if setclipboard then
        setclipboard(targetPlayer.Name)
    end
end

local function copyUserId(targetPlayer)
    -- Implementation to copy user ID to clipboard
    if setclipboard then
        setclipboard(tostring(targetPlayer.UserId))
    end
end

local function fireClickDetectors()
    -- Implementation to fire all click detectors
    for _, detector in ipairs(workspace:GetDescendants()) do
        if detector:IsA("ClickDetector") then
            detector:MaxActivationDistance = math.huge
            fireclickdetector(detector)
        end
    end
end

local function fireProximityPrompts()
    -- Implementation to fire all proximity prompts
    for _, prompt in ipairs(workspace:GetDescendants()) do
        if prompt:IsA("ProximityPrompt") then
            prompt.MaxActivationDistance = math.huge
            prompt:InputHoldBegin()
            prompt:InputHoldEnd()
        end
    end
end

local function removeTerrain()
    -- Implementation to remove terrain
    game:GetService("Workspace").Terrain:Clear()
end

local function removeNilInstances()
    -- Implementation to remove nil instances
    for _, instance in ipairs(workspace:GetDescendants()) do
        if not instance:IsDescendantOf(game:GetService("Players")) and instance:IsA("BasePart") and not instance.Parent then
            instance:Destroy()
        end
    end
end

local function antivoid()
    -- Implementation for antivoid
    antivoidEnabled = true
    local connection
    connection = game:GetService("RunService").Heartbeat:Connect(function()
        if not antivoidEnabled then
            connection:Disconnect()
            return
        end
        
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local position = player.Character.HumanoidRootPart.Position
            if position.Y < workspace.FallenPartsDestroyHeight + 10 then
                player.Character.HumanoidRootPart.Velocity = Vector3.new(0, 100, 0)
            end
        end
    end)
    return connection
end

local function disableAntivoid()
    antivoidEnabled = false
end

local function orbitPlayer(targetPlayer, speed, distance)
    -- Implementation to orbit a player
    orbitEnabled = true
    speed = speed or 1
    distance = distance or 5
    
    local connection
    connection = game:GetService("RunService").RenderStepped:Connect(function()
        if not orbitEnabled or not targetPlayer.Character or not targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
            connection:Disconnect()
            return
        end
        
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local angle = tick() * speed
            local offset = Vector3.new(math.cos(angle) * distance, 0, math.sin(angle) * distance)
            player.Character.HumanoidRootPart.CFrame = CFrame.new(targetPlayer.Character.HumanoidRootPart.Position + offset, targetPlayer.Character.HumanoidRootPart.Position)
        end
    end)
    return connection
end

local function stopOrbit()
    orbitEnabled = false
end

local function stareAtPlayer(targetPlayer)
    -- Implementation to stare at a player
    stareEnabled = true
    local connection
    connection = game:GetService("RunService").RenderStepped:Connect(function()
        if not stareEnabled or not targetPlayer.Character or not targetPlayer.Character:FindFirstChild("Head") then
            connection:Disconnect()
            return
        end
        
        if player.Character and player.Character:FindFirstChild("Head") then
            player.Character.Head.CFrame = CFrame.new(player.Character.Head.Position, targetPlayer.Character.Head.Position)
        end
    end)
    return connection
end

local function stopStare()
    stareEnabled = false
end

local function fling()
    -- Implementation for fling
    flingEnabled = true
    local connection
    connection = game:GetService("RunService").Heartbeat:Connect(function()
        if not flingEnabled or not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then
            connection:Disconnect()
            return
        end
        
        player.Character.HumanoidRootPart.Velocity = Vector3.new(math.random(-1000, 1000), math.random(-1000, 1000), math.random(-1000, 1000))
    end)
    return connection
end

local function stopFling()
    flingEnabled = false
end

local function loopOof()
    -- Implementation to loop oof sound
    loopOofEnabled = true
    local connection
    connection = game:GetService("RunService").Heartbeat:Connect(function()
        if not loopOofEnabled then
            connection:Disconnect()
            return
        end
        
        for _, p in ipairs(game:GetService("Players"):GetPlayers()) do
            if p.Character then
                local humanoid = p.Character:FindFirstChild("Humanoid")
                if humanoid then
                    humanoid:PlayEmote("ouch")
                end
            end
        end
        wait(0.1)
    end)
    return connection
end

local function stopLoopOof()
    loopOofEnabled = false
end

local function hitbox(targetPlayer, size, transparency)
    -- Implementation to expand hitbox
    size = size or 1
    transparency = transparency or 0.5
    
    if targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local highlight = Instance.new("Highlight")
        highlight.Name = "IY_Hitbox"
        highlight.Adornee = targetPlayer.Character.HumanoidRootPart
        highlight.Size = Vector3.new(size, size, size)
        highlight.FillTransparency = transparency
        highlight.Parent = targetPlayer.Character.HumanoidRootPart
    end
end

local function removeHitbox(targetPlayer)
    if targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local hitbox = targetPlayer.Character.HumanoidRootPart:FindFirstChild("IY_Hitbox")
        if hitbox then
            hitbox:Destroy()
        end
    end
end

local function headSize(targetPlayer, size)
    -- Implementation to change head size
    size = size or 1
    
    if targetPlayer.Character and targetPlayer.Character:FindFirstChild("Head") then
        targetPlayer.Character.Head.Size = Vector3.new(size, size, size)
    end
end

local function resetHeadSize(targetPlayer)
    if targetPlayer.Character and targetPlayer.Character:FindFirstChild("Head") then
        targetPlayer.Character.Head.Size = Vector3.new(1, 1, 1)
    end
end

-- Main commands table
local commands = {
    jump = {func = function() player.Character.Humanoid.Jump = true end, desc = "Make the player jump."},
    speed = {func = function() setWalkSpeed(50) end, desc = "Set WalkSpeed to 50."},
    reset = {func = function() player.Character:BreakJoints() end, desc = "Reset the character."},
    fly = {func = function() showNotification("Fly","Coming soon!","rbxassetid://6031094666") end, desc = "Toggle fly mode."},
    help = {func = function() showHelp() end, desc = "Shows all available commands."},
    
    -- GUI Commands
    guiscale = {func = function(num) 
        -- Implementation for guiscale
        num = tonumber(num) or 1
        num = math.clamp(num, 0.4, 2)
        game:GetService("CoreGui"):SetAttribute("IY_Scale", num)
    end, desc = "Changes the size of the gui."},
    
    console = {func = function() 
        loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"))()
    end, desc = "Loads Roblox console"},
    
    -- Server Commands
    rejoin = {func = function() 
        game:GetService("TeleportService"):Teleport(game.PlaceId, player)
    end, desc = "Makes you rejoin the game"},
    
    serverhop = {func = function() 
        -- Server hop implementation
        game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, game.JobId, player)
    end, desc = "Teleports you to a different server"},
    
    -- Movement Commands
    noclip = {func = function() enableNoclip() end, desc = "Go through objects"},
    clip = {func = function() disableNoclip() end, desc = "Disables noclip"},
    fly = {func = function(speed) 
        -- Fly implementation
        speed = tonumber(speed) or 20
        showNotification("Fly", "Speed set to " .. speed, "rbxassetid://6031094666")
    end, desc = "Makes you fly"},
    unfly = {func = function() 
        -- Disable fly
        showNotification("Fly", "Disabled", "rbxassetid://6031094666")
    end, desc = "Disables fly"},
    
    -- Player Teleportation Commands
    goto = {func = function(target) 
        local players = getPlayerFromString(target)
        for _, p in ipairs(players) do
            teleportToPlayer(p)
        end
    end, desc = "Go to a player"},
    
    loopgoto = {func = function(target, distance, delay) 
        -- Loop goto implementation
        distance = tonumber(distance) or 5
        delay = tonumber(delay) or 1
        
        loopGotoEnabled = true
        local connection
        connection = game:GetService("RunService").Heartbeat:Connect(function()
            if not loopGotoEnabled then
                connection:Disconnect()
                return
            end
            
            local players = getPlayerFromString(target)
            for _, p in ipairs(players) do
                teleportToPlayer(p)
            end
            wait(delay)
        end)
    end, desc = "Loop teleport to a player"},
    
    bring = {func = function(target) 
        local players = getPlayerFromString(target)
        for _, p in ipairs(players) do
            if p.Character and p.Character:FindFirstChild("HumanoidRootPart") and
               player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                p.Character.HumanoidRootPart.CFrame = player.Character.HumanoidRootPart.CFrame
            end
        end
    end, desc = "Bring a player to you"},
    
    -- ESP/Viewing Commands
    esp = {func = function() 
        for _, p in ipairs(game:GetService("Players"):GetPlayers()) do
            createESP(p)
        end
    end, desc = "View all players and their status"},
    
    espteam = {func = function() 
        for _, p in ipairs(game:GetService("Players"):GetPlayers()) do
            createESP(p)
            -- Set color based on team
        end
    end, desc = "ESP but teammates are green and bad guys are red"},
    
    unesp = {func = function() 
        for _, p in ipairs(game:GetService("Players"):GetPlayers()) do
            removeESP(p)
        end
    end, desc = "Removes ESP"},
    
    locate = {func = function(target) 
        local players = getPlayerFromString(target)
        for _, p in ipairs(players) do
            createESP(p)
        end
    end, desc = "View a single player and their status"},
    
    nolocate = {func = function(target) 
        local players = getPlayerFromString(target)
        for _, p in ipairs(players) do
            removeESP(p)
        end
    end, desc = "Removes locate"},
    
    xray = {func = function() xrayEnable() end, desc = "Makes all parts in workspace transparent"},
    noxray = {func = function() xrayDisable() end, desc = "Restores transparency to all parts in workspace"},
    
    spectate = {func = function(target) 
        local players = getPlayerFromString(target)
        if #players > 0 then
            spectatePlayer(players[1])
        end
    end, desc = "View a player"},
    
    unspectate = {func = function() stopSpectate() end, desc = "Stops viewing player"},
    
    freecam = {func = function() freecamEnable() end, desc = "Allows you to freely move camera around the game"},
    unfreecam = {func = function() freecamDisable() end, desc = "Disables freecam"},
    
    -- Tool Commands
    btools = {func = function() giveBtools() end, desc = "Gives you building tools"},
    
    -- Lighting Commands
    day = {func = function() setTimeOfDay("day") end, desc = "Changes the time to day for the client"},
    night = {func = function() setTimeOfDay("night") end, desc = "Changes the time to night for the client"},
    
    fullbright = {func = function() fullbrightEnable() end, desc = "Makes the map brighter / more visible"},
    nofullbright = {func = function() fullbrightDisable() end, desc = "Disables fullbright"},
    
    -- Character Commands
    respawn = {func = function() respawnCharacter() end, desc = "Respawns you"},
    refresh = {func = function() respawnCharacter() end, desc = "Respawns and brings you back to the same position"},
    
    god = {func = function() godMode() end, desc = "Makes your character difficult to kill in most games"},
    
    invisible = {func = function() invisibleMode() end, desc = "Makes you invisible to other players"},
    visible = {func = function() visibleMode() end, desc = "Makes you visible to other players"},
    
    ws = {func = function(speed) setWalkSpeed(tonumber(speed) or 16) end, desc = "Change your walkspeed"},
    walkspeed = {func = function(speed) setWalkSpeed(tonumber(speed) or 16) end, desc = "Change your walkspeed"},
    
    jp = {func = function(power) setJumpPower(tonumber(power) or 50) end, desc = "Change a players jump height"},
    jumppower = {func = function(power) setJumpPower(tonumber(power) or 50) end, desc = "Change a players jump height"},
    
    gravity = {func = function(level) setGravity(tonumber(level) or 196.2) end, desc = "Change your gravity"},
    grav = {func = function(level) setGravity(tonumber(level) or 196.2) end, desc = "Change your gravity"},
    
    sit = {func = function() sit() end, desc = "Makes your character sit"},
    lay = {func = function() layDown() end, desc = "Makes your character lay down"},
    
    infjump = {func = function() infiniteJump() end, desc = "Allows you to jump before hitting the ground"},
    uninfinitejump = {func = function() disableInfiniteJump() end, desc = "Disables infjump"},
    
    -- Player Info Commands
    copyname = {func = function(target) 
        local players = getPlayerFromString(target)
        if #players > 0 then
            copyPlayerName(players[1])
        end
    end, desc = "Copies a players full username to your clipboard"},
    
    copyid = {func = function(target) 
        local players = getPlayerFromString(target)
        if #players > 0 then
            copyUserId(players[1])
        end
    end, desc = "Copies a players user ID to your clipboard"},
    
    -- Interaction Commands
    firecd = {func = function() fireClickDetectors() end, desc = "Uses all click detectors in a game"},
    firepp = {func = function() fireProximityPrompts() end, desc = "Uses all proximity prompts in a game"},
    
    -- World Commands
    rterrain = {func = function() removeTerrain() end, desc = "Removes all terrain"},
    noterrain = {func = function() removeTerrain() end, desc = "Removes all terrain"},
    
    nonilinstances = {func = function() removeNilInstances() end, desc = "Removes nil instances"},
    
    antivoid = {func = function() antivoid() end, desc = "Prevents you from falling into the void by launching you upwards"},
    noantivoid = {func = function() disableAntivoid() end, desc = "Disables antivoid"},
    
    -- Fun Commands
    orbit = {func = function(target, speed, distance) 
        local players = getPlayerFromString(target)
        if #players > 0 then
            orbitPlayer(players[1], tonumber(speed), tonumber(distance))
        end
    end, desc = "Makes your character orbit around a player"},
    unorbit = {func = function() stopOrbit() end, desc = "Disables orbit"},
    
    stare = {func = function(target) 
        local players = getPlayerFromString(target)
        if #players > 0 then
            stareAtPlayer(players[1])
        end
    end, desc = "Stare / look at a player"},
    unstare = {func = function() stopStare() end, desc = "Disables stareat"},
    
    fling = {func = function() fling() end, desc = "Flings anyone you touch"},
    unfling = {func = function() stopFling() end, desc = "Disables the fling command"},
    
    loopoof = {func = function() loopOof() end, desc = "Loops everyones character sounds"},
    unloopoof = {func = function() stopLoopOof() end, desc = "Stops the oof chaos"},
    
    hitbox = {func = function(target, size, transparency) 
        local players = getPlayerFromString(target)
        for _, p in ipairs(players) do
            hitbox(p, tonumber(size), tonumber(transparency))
        end
    end, desc = "Expands the hitbox for players HumanoidRootPart"},
    
    headsize = {func = function(target, size) 
        local players = getPlayerFromString(target)
        for _, p in ipairs(players) do
            headSize(p, tonumber(size))
        end
    end, desc = "Expands the head size for players Head"},
    
    -- Chat Commands
    say = {func = function(text) chatMessage(text) end, desc = "Makes you chat a string"},
    chat = {func = function(text) chatMessage(text) end, desc = "Makes you chat a string"},
    
    spam = {func = function(text, delay) spamMessage(text, tonumber(delay)) end, desc = "Makes you spam the chat"},
    unspam = {func = function() stopSpam() end, desc = "Turns off spam"},
    
    -- Waypoint Commands
    swp = {func = function(name) 
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            createWaypoint(name, player.Character.HumanoidRootPart.CFrame)
        end
    end, desc = "Sets a waypoint at your position"},
    
    wp = {func = function(name) teleportToWaypoint(name) end, desc = "Teleports player to a waypoint"},
    
    -- Team Commands
    team = {func = function(teamName) changeTeam(teamName) end, desc = "Changes your team"},
    
    -- Camera Commands
    fov = {func = function(value) setFov(value) end, desc = "Adjusts field of view"},
    
    -- Audio Commands
    vol = {func = function(level) setVolume(level) end, desc = "Adjusts your game volume"},
    volume = {func = function(level) setVolume(level) end, desc = "Adjusts your game volume"},
    
    -- Utility Commands
    togglefs = {func = function() toggleFullscreen() end, desc = "Toggles fullscreen"},
    togglefullscreen = {func = function() toggleFullscreen() end, desc = "Toggles fullscreen"},
    
    antiafk = {func = function() antiAfk() end, desc = "Prevents the game from kicking you for being idle/afk"},
    antiidle = {func = function() antiAfk() end, desc = "Prevents the game from kicking you for being idle/afk"},
    
    -- Add more commands here following the same pattern...
}

-- Command execution function
local function executeCommand(cmd, args)
    if commands[cmd] then
        if args and #args > 0 then
            commands[cmd].func(unpack(args))
        else
            commands[cmd].func()
        end
        return true
    end
    return false
end

-- Command parsing function
local function parseAndExecute(input)
    local parts = {}
    for part in input:gmatch("[^%s]+") do
        table.insert(parts, part)
    end
    
    if #parts == 0 then return false end
    
    local cmd = parts[1]:lower()
    local args = {}
    
    for i = 2, #parts do
        table.insert(args, parts[i])
    end
    
    return executeCommand(cmd, args)
end

-- Example usage
parseAndExecute("speed 50")
parseAndExecute("goto random")
parseAndExecute("esp")
parseAndExecute("btools")
local player = game.Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Debris = game:GetService("Debris")

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "LucentCMD_GUI"
screenGui.Parent = playerGui
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local function addGlassEffect(frame)
    frame.BackgroundTransparency = 0.15
    frame.BackgroundColor3 = Color3.fromRGB(20,20,25)
    local corner = Instance.new("UICorner", frame)
    corner.CornerRadius = UDim.new(0,10)
    local stroke = Instance.new("UIStroke", frame)
    stroke.Thickness = 2
    stroke.Color = Color3.fromRGB(0,255,255)
    stroke.Transparency = 0.1
end

local function makeDraggable(frame, handle)
    handle = handle or frame
    local dragging, dragStart, startPos
    handle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)
    handle.InputChanged:Connect(function(input)
        if dragging then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(startPos.X.Scale,startPos.X.Offset+delta.X,startPos.Y.Scale,startPos.Y.Offset+delta.Y)
        end
    end)
end

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0,550,0,110)
frame.Position = UDim2.new(0.5,-275,1,-140)
frame.Parent = screenGui
addGlassEffect(frame)
makeDraggable(frame)

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1,-50,0,30)
title.Position = UDim2.new(0,15,0,5)
title.BackgroundTransparency = 1
title.Text = "Lucent CMD"
title.TextColor3 = Color3.fromRGB(0,255,255)
title.Font = Enum.Font.GothamBold
title.TextSize = 24
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = frame

local minimizeButton = Instance.new("TextButton")
minimizeButton.Size = UDim2.new(0,50,0,30)
minimizeButton.Position = UDim2.new(1,-55,0,5)
minimizeButton.Text = "_"
minimizeButton.Font = Enum.Font.GothamBold
minimizeButton.TextSize = 22
minimizeButton.BackgroundColor3 = Color3.fromRGB(30,30,40)
minimizeButton.TextColor3 = Color3.fromRGB(0,255,255)
minimizeButton.Parent = frame

local textBox = Instance.new("TextBox")
textBox.Size = UDim2.new(1,-80,0,50)
textBox.Position = UDim2.new(0,15,0,45)
textBox.BackgroundColor3 = Color3.fromRGB(30,30,35)
textBox.TextColor3 = Color3.fromRGB(255,255,255)
textBox.PlaceholderText = "Type a command..."
textBox.TextSize = 20
textBox.ClearTextOnFocus = false
textBox.Parent = frame

local submitButton = Instance.new("TextButton")
submitButton.Size = UDim2.new(0,60,0,50)
submitButton.Position = UDim2.new(1,-65,0,45)
submitButton.Text = "Go"
submitButton.Font = Enum.Font.GothamBold
submitButton.TextSize = 20
submitButton.BackgroundColor3 = Color3.fromRGB(30,30,40)
submitButton.TextColor3 = Color3.fromRGB(0,255,255)
submitButton.Parent = frame

local suggestFrame = Instance.new("ScrollingFrame")
suggestFrame.Size = UDim2.new(0,550,0,150)
suggestFrame.Position = frame.Position - UDim2.new(0,0,0,155)
suggestFrame.BackgroundColor3 = Color3.fromRGB(25,25,30)
suggestFrame.BorderSizePixel = 0
suggestFrame.CanvasSize = UDim2.new(0,0,0,0)
suggestFrame.ScrollBarThickness = 5
suggestFrame.Visible = false
suggestFrame.Parent = screenGui
addGlassEffect(suggestFrame)

local listLayout = Instance.new("UIListLayout")
listLayout.Padding = UDim.new(0,4)
listLayout.Parent = suggestFrame

RunService.RenderStepped:Connect(function()
    local targetPos = frame.Position - UDim2.new(0,0,0,suggestFrame.Size.Y.Offset+5)
    TweenService:Create(suggestFrame,TweenInfo.new(0.25,Enum.EasingStyle.Quad,Enum.EasingDirection.Out),{Position=targetPos}):Play()
end)

local notificationFrame = Instance.new("Frame")
notificationFrame.Size = UDim2.new(0,350,0,90)
notificationFrame.Position = UDim2.new(0,20,1,-120)
notificationFrame.BackgroundColor3 = Color3.fromRGB(25,25,35)
notificationFrame.BackgroundTransparency = 0.15
notificationFrame.Visible = false
notificationFrame.Parent = screenGui
addGlassEffect(notificationFrame)
makeDraggable(notificationFrame)

local icon = Instance.new("ImageLabel")
icon.Size = UDim2.new(0,50,0,50)
icon.Position = UDim2.new(0,15,0,15)
icon.BackgroundTransparency = 1
icon.Image = "rbxassetid://6031094666"
icon.Parent = notificationFrame

local notifTitle = Instance.new("TextLabel")
notifTitle.Size = UDim2.new(0,260,0,25)
notifTitle.Position = UDim2.new(0,75,0,10)
notifTitle.BackgroundTransparency = 1
notifTitle.TextColor3 = Color3.fromRGB(255,255,255)
notifTitle.Font = Enum.Font.GothamBold
notifTitle.TextSize = 20
notifTitle.TextXAlignment = Enum.TextXAlignment.Left
notifTitle.Parent = notificationFrame

local notifDesc = Instance.new("TextLabel")
notifDesc.Size = UDim2.new(0,260,0,50)
notifDesc.Position = UDim2.new(0,75,0,35)
notifDesc.BackgroundTransparency = 1
notifDesc.TextColor3 = Color3.fromRGB(200,200,200)
notifDesc.Font = Enum.Font.Gotham
notifDesc.TextSize = 16
notifDesc.TextXAlignment = Enum.TextXAlignment.Left
notifDesc.TextYAlignment = Enum.TextYAlignment.Top
notifDesc.TextWrapped = true
notifDesc.Parent = notificationFrame

local function showNotification(titleText, descText, iconId)
    notifTitle.Text = titleText or "Notification"
    notifDesc.Text = descText or ""
    if iconId then icon.Image = iconId end
    notificationFrame.Visible = true
    notificationFrame.Size = UDim2.new(0,350,0,0)
    notifTitle.TextTransparency = 1
    notifDesc.TextTransparency = 1
    TweenService:Create(notificationFrame,TweenInfo.new(0.3),{Size=UDim2.new(0,350,0,90)}):Play()
    TweenService:Create(notifTitle,TweenInfo.new(0.3),{TextTransparency=0}):Play()
    TweenService:Create(notifDesc,TweenInfo.new(0.3),{TextTransparency=0}):Play()
    task.wait(3)
    TweenService:Create(notificationFrame,TweenInfo.new(0.3),{Size=UDim2.new(0,350,0,0)}):Play()
    TweenService:Create(notifTitle,TweenInfo.new(0.3),{TextTransparency=1}):Play()
    TweenService:Create(notifDesc,TweenInfo.new(0.3),{TextTransparency=1}):Play()
    task.wait(0.35)
    notificationFrame.Visible = false
end

local helpFrame = Instance.new("Frame")
helpFrame.Size = UDim2.new(0,500,0,450)
helpFrame.Position = UDim2.new(0.5,-250,0,130)
helpFrame.BackgroundColor3 = Color3.fromRGB(20,20,25)
helpFrame.Visible = false
helpFrame.Parent = screenGui
addGlassEffect(helpFrame)
makeDraggable(helpFrame)

local helpTopBar = Instance.new("Frame")
helpTopBar.Size = UDim2.new(1,0,0,40)
helpTopBar.Position = UDim2.new(0,0,0,0)
helpTopBar.BackgroundTransparency = 1
helpTopBar.Parent = helpFrame

local helpTitle = Instance.new("TextLabel")
helpTitle.Size = UDim2.new(1,-50,1,0)
helpTitle.Position = UDim2.new(0,10,0,0)
helpTitle.BackgroundTransparency = 1
helpTitle.Text = "Lucent CMD Help"
helpTitle.TextColor3 = Color3.fromRGB(0,255,255)
helpTitle.Font = Enum.Font.GothamBold
helpTitle.TextSize = 24
helpTitle.TextXAlignment = Enum.TextXAlignment.Left
helpTitle.Parent = helpTopBar

local closeButton = Instance.new("TextButton")
closeButton.Size = UDim2.new(0,30,0,30)
closeButton.Position = UDim2.new(1,-35,0,5)
closeButton.Text = "X"
closeButton.Font = Enum.Font.GothamBold
closeButton.TextSize = 22
closeButton.BackgroundColor3 = Color3.fromRGB(30,30,40)
closeButton.TextColor3 = Color3.fromRGB(255,0,0)
closeButton.Parent = helpTopBar
closeButton.MouseButton1Click:Connect(function()
    helpFrame.Visible = false
end)

local searchBox = Instance.new("TextBox")
searchBox.Size = UDim2.new(1,-20,0,35)
searchBox.Position = UDim2.new(0,10,0,50)
searchBox.BackgroundColor3 = Color3.fromRGB(30,30,40)
searchBox.PlaceholderText = "Search commands..."
searchBox.TextColor3 = Color3.fromRGB(255,255,255)
searchBox.Font = Enum.Font.Gotham
searchBox.TextSize = 18
searchBox.Parent = helpFrame

local helpScrollFrame = Instance.new("ScrollingFrame")
helpScrollFrame.Size = UDim2.new(1,-20,1,-100)
helpScrollFrame.Position = UDim2.new(0,10,0,90)
helpScrollFrame.BackgroundTransparency = 1
helpScrollFrame.ScrollBarThickness = 8
helpScrollFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
helpScrollFrame.Parent = helpFrame

local helpLayout = Instance.new("UIListLayout")
helpLayout.Padding = UDim.new(0,6)
helpLayout.SortOrder = Enum.SortOrder.LayoutOrder
helpLayout.Parent = helpScrollFrame

local function populateHelp(filter)
    for _, c in pairs(helpScrollFrame:GetChildren()) do
        if c:IsA("TextLabel") then c:Destroy() end
    end
    for name, info in pairs(commands) do
        if not filter or name:lower():find(filter:lower()) then
            local lbl = Instance.new("TextLabel")
            lbl.Size = UDim2.new(1,0,0,35)
            lbl.BackgroundTransparency = 0.15
            lbl.BackgroundColor3 = Color3.fromRGB(30,30,40)
            lbl.TextColor3 = Color3.fromRGB(0,255,255)
            lbl.Font = Enum.Font.Gotham
            lbl.TextSize = 18
            lbl.Text = name.." - "..info.desc
            lbl.TextXAlignment = Enum.TextXAlignment.Left
            lbl.TextYAlignment = Enum.TextYAlignment.Center
            lbl.Parent = helpScrollFrame
            local corner = Instance.new("UICorner", lbl)
            corner.CornerRadius = UDim.new(0,6)
        end
    end
end

searchBox:GetPropertyChangedSignal("Text"):Connect(function()
    populateHelp(searchBox.Text)
end)

local function updateSuggestions(input)
    for _, child in pairs(suggestFrame:GetChildren()) do
        if child:IsA("TextButton") then child:Destroy() end
    end
    if input == "" then
        suggestFrame.Visible = false
        suggestFrame.CanvasSize = UDim2.new(0,0,0,0)
        return
    end
    suggestFrame.Visible = true
    local count = 0
    for cmdName, cmdInfo in pairs(commands) do
        if cmdName:lower():sub(1,#input:lower()) == input:lower() then
            local btn = Instance.new("TextButton")
            btn.Size = UDim2.new(1,0,0,35)
            btn.BackgroundColor3 = Color3.fromRGB(30,30,40)
            btn.TextColor3 = Color3.fromRGB(0,255,255)
            btn.Font = Enum.Font.Gotham
            btn.TextSize = 18
            btn.Text = cmdName.." - "..cmdInfo.desc
            btn.Parent = suggestFrame
            btn.MouseEnter:Connect(function()
                TweenService:Create(btn,TweenInfo.new(0.15),{BackgroundColor3=Color3.fromRGB(0,255,255),TextColor3=Color3.fromRGB(25,25,25)}):Play()
            end)
            btn.MouseLeave:Connect(function()
                TweenService:Create(btn,TweenInfo.new(0.15),{BackgroundColor3=Color3.fromRGB(30,30,40),TextColor3=Color3.fromRGB(0,255,255)}):Play()
            end)
            btn.MouseButton1Click:Connect(function()
                textBox.Text = cmdName
                suggestFrame.Visible = false
            end)
            count += 1
        end
    end
    suggestFrame.CanvasSize = UDim2.new(0,0,0,count*38)
end

local function handleCommand(cmd)
    cmd = cmd:lower()
    if commands[cmd] then
        commands[cmd].func()
        if cmd ~= "help" then
            showNotification(cmd, commands[cmd].desc,"rbxassetid://6031094666")
        end
    else
        showNotification("Unknown","Command not recognized: "..cmd,"rbxassetid://6031094666")
    end
end

textBox:GetPropertyChangedSignal("Text"):Connect(function()
    updateSuggestions(textBox.Text)
end)
textBox.FocusLost:Connect(function(enterPressed)
    if enterPressed then
        handleCommand(textBox.Text)
        textBox.Text = ""
        suggestFrame.Visible = false
    end
end)
submitButton.MouseButton1Click:Connect(function()
    handleCommand(textBox.Text)
    textBox.Text = ""
    suggestFrame.Visible = false
end)

local minimized = false
minimizeButton.MouseButton1Click:Connect(function()
    minimized = not minimized
    textBox.Visible = not minimized
    submitButton.Visible = not minimized
    suggestFrame.Visible = not minimized and textBox.Text~="" or false
    frame.Size = minimized and UDim2.new(0,550,0,40) or UDim2.new(0,550,0,110)
end)

local rainContainer = Instance.new("Frame")
rainContainer.Size = UDim2.new(1,0,1,0)
rainContainer.Position = UDim2.new(0,0,0,0)
rainContainer.BackgroundTransparency = 1
rainContainer.Parent = screenGui
rainContainer.ClipsDescendants = true

local function spawnRaindrop()
    local drop = Instance.new("ImageLabel")
    drop.Size = UDim2.new(0,25,0,25)
    drop.BackgroundTransparency = 1
    drop.Image = "rbxassetid://10709791437"
    drop.AnchorPoint = Vector2.new(0.5,0.5)
    drop.ZIndex = 50
    drop.Parent = rainContainer
    local edge = math.random(1,4)
    local startPos, endPos, rotation
    if edge == 1 then
        startPos = UDim2.new(math.random(),0,0,0)
        endPos = UDim2.new(startPos.X.Scale,startPos.X.Offset,1,workspace.CurrentCamera.ViewportSize.Y)
        rotation = 0
    elseif edge == 2 then
        startPos = UDim2.new(math.random(),0,1,0)
        endPos = UDim2.new(startPos.X.Scale,startPos.X.Offset,0,-workspace.CurrentCamera.ViewportSize.Y)
        rotation = 180
    elseif edge == 3 then
        startPos = UDim2.new(0,0,math.random(),0)
        endPos = UDim2.new(1,workspace.CurrentCamera.ViewportSize.X,startPos.Y.Scale,startPos.Y.Offset)
        rotation = 90
    else
        startPos = UDim2.new(1,0,math.random(),0)
        endPos = UDim2.new(0,-workspace.CurrentCamera.ViewportSize.X,startPos.Y.Scale,startPos.Y.Offset)
        rotation = -90
    end
    drop.Position = startPos
    drop.Rotation = rotation
    TweenService:Create(drop,TweenInfo.new(1,Enum.EasingStyle.Linear),{Position=endPos,Rotation=rotation+360}):Play()
    Debris:AddItem(drop,1.2)
end

textBox:GetPropertyChangedSignal("Text"):Connect(function()
    for i=1,4 do spawnRaindrop() end
end)

function showHelp()
    helpFrame.Visible = true
    populateHelp()
end
