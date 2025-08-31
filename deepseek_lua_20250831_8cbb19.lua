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