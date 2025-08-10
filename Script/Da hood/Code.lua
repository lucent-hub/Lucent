--[[
	Lucent Hub 
	Credits: dawn#9990 (original helper WWE), Dimag16
]]

local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/Seven7-lua/Roblox/refs/heads/main/Librarys/Orion/Orion.lua')))()
local Window = OrionLib:MakeWindow({Name = "Lucent Hub", HidePremium = false, SaveConfig = true, ConfigFolder = "LucentHubConfig"})

-- Notification
OrionLib:MakeNotification({
	Name = "Lucent Hub Loaded!",
	Content = "Welcome to Lucent Hub!",
	Image = "rbxassetid://4483345998",
	Time = 5
})

-- Main Tab
local MainTab = Window:MakeTab({
	Name = "Main",
	Icon = "rbxassetid://4483345998",
	PremiumOnly = false
})

-- Fly
MainTab:AddButton({
	Name = "Fly",
	Callback = function()
		local plr = game.Players.LocalPlayer
		local mouse = plr:GetMouse()
		localplayer = plr
	
		if workspace:FindFirstChild("Core") then
			workspace.Core:Destroy()
		end
	
		local Core = Instance.new("Part")
		Core.Name = "Core"
		Core.Size = Vector3.new(0.05, 0.05, 0.05)
	
		spawn(function()
			Core.Parent = workspace
			local Weld = Instance.new("Weld", Core)
			Weld.Part0 = Core
			Weld.Part1 = localplayer.Character.LowerTorso
			Weld.C0 = CFrame.new(0, 0, 0)
		end)
	
		workspace:WaitForChild("Core")
		local torso = workspace.Core
		flying = true
		local speed=7.5
		local keys={a=false,d=false,w=false,s=false}
		local e1
		local e2
	
		local function start()
			local pos = Instance.new("BodyPosition",torso)
			local gyro = Instance.new("BodyGyro",torso)
			pos.Name="EPIXPOS"
			pos.maxForce = Vector3.new(math.huge, math.huge, math.huge)
			pos.position = torso.Position
			gyro.maxTorque = Vector3.new(9e9, 9e9, 9e9)
			gyro.cframe = torso.CFrame
			repeat
				wait()
				localplayer.Character.Humanoid.PlatformStand=true
				local new=gyro.cframe - gyro.cframe.p + pos.position
				if not keys.w and not keys.s and not keys.a and not keys.d then
					speed=7.5
				end
				if keys.w then
					new = new + workspace.CurrentCamera.CoordinateFrame.lookVector * speed
					speed=speed+0
				end
				if keys.s then
					new = new - workspace.CurrentCamera.CoordinateFrame.lookVector * speed
					speed=speed+0
				end
				if keys.d then
					new = new * CFrame.new(speed,0,0)
					speed=speed+0
				end
				if keys.a then
					new = new * CFrame.new(-speed,0,0)
					speed=speed+0
				end
				if speed>3.2 then
					speed=7.5
				end
				pos.position=new.p
				if keys.w then
					gyro.cframe = workspace.CurrentCamera.CoordinateFrame*CFrame.Angles(-math.rad(speed*0),0,0)
				elseif keys.s then
					gyro.cframe = workspace.CurrentCamera.CoordinateFrame*CFrame.Angles(math.rad(speed*0),0,0)
				else
					gyro.cframe = workspace.CurrentCamera.CoordinateFrame
				end
			until flying == false
			if gyro then gyro:Destroy() end
			if pos then pos:Destroy() end
			flying=false
			localplayer.Character.Humanoid.PlatformStand=false
			speed=7.5
		end
	
		e1=mouse.KeyDown:connect(function(key)
			if not torso or not torso.Parent then flying=false e1:disconnect() e2:disconnect() return end
			if key=="w" then
				keys.w=true
			elseif key=="s" then
				keys.s=true
			elseif key=="a" then
				keys.a=true
			elseif key=="d" then
				keys.d=true
			elseif key=="x" then
				if flying==true then
					flying=false
				else
					flying=true
					start()
				end
			end
		end)
	
		e2=mouse.KeyUp:connect(function(key)
			if key=="w" then
				keys.w=false
			elseif key=="s" then
				keys.s=false
			elseif key=="a" then
				keys.a=false
			elseif key=="d" then
				keys.d=false
			end
		end)
		start()                                                                         
	end
})

-- Noclip
MainTab:AddToggle({
	Name = "Noclip",
	Default = false,
	Callback = function(Value)
		if Value then
			loadstring(game:HttpGet("https://raw.githubusercontent.com/LegoHacker1337/legohacks/main/PhysicsServiceOnClient.lua"))()
			setfflag("HumanoidParallelRemoveNoPhysics", "False")
			setfflag("HumanoidParallelRemoveNoPhysicsNoSimulate2", "False")
			game:GetService('RunService'):BindToRenderStep("crash", 0 , function()
				game.Players.LocalPlayer.Character.Humanoid:ChangeState(11)
			end)
		else
			game:GetService('RunService'):UnbindFromRenderStep("crash")
		end
	end    
})

-- Hide User
MainTab:AddButton({
	Name = "Hide User",
	Callback = function()
		if game.Players.LocalPlayer.Character:FindFirstChild("In-gameMask") then
			game.Players.LocalPlayer.Character:FindFirstChild("In-gameMask"):FindFirstChildWhichIsA("Model"):Destroy()
			game.Players.LocalPlayer.Character:FindFirstChild("In-gameMask"):FindFirstChild('Handle'):Destroy()
		end
	end
})

-- Korblox
MainTab:AddButton({
	Name = "Korblox",
	Callback = function()
		local ply = game.Players.LocalPlayer
		local chr = ply.Character
		chr.RightLowerLeg.MeshId = "902942093"
		chr.RightLowerLeg.Transparency = "1"
		chr.RightUpperLeg.MeshId = "http://www.roblox.com/asset/?id=902942096"
		chr.RightUpperLeg.TextureID = "http://roblox.com/asset/?id=902843398"
		chr.RightFoot.MeshId = "902942089"
		chr.RightFoot.Transparency = "1"
	end
})

-- Headless
MainTab:AddButton({
	Name = "Headless",
	Callback = function()
		game.Players.LocalPlayer.Character.Head.Transparency = 1
		game.Players.LocalPlayer.Character.Head.Transparency = 1
		for i,v in pairs(game.Players.LocalPlayer.Character.Head:GetChildren()) do
			if (v:IsA("Decal")) then
				v.Transparency = 1
			end
		end
	end
})

-- WalkSpeed
MainTab:AddSlider({
	Name = "Walkspeed (16 to become normal)",
	Min = 16,
	Max = 150,
	Default = 16,
	Color = Color3.fromRGB(255,255,255),
	Increment = 1,
	ValueName = "speed",
	Callback = function(Value)
		game.Players.LocalPlayer.Character:FindFirstChildWhichIsA('Humanoid').Name = 'SWAG MODE'
		game.Players.LocalPlayer.Character:FindFirstChildWhichIsA('Humanoid').WalkSpeed = Value
		if Value == 16 then
			game.Players.LocalPlayer.Character:FindFirstChildWhichIsA('Humanoid').Name = 'Humanoid'
			game.Players.LocalPlayer.Character:FindFirstChildWhichIsA('Humanoid').WalkSpeed = 16
		end
	end    
})

-- Trash Talk
MainTab:AddButton({
	Name = "Trash Talk",
	Callback = function()
		function dowait()
			wait(0.172)
		end
		local tbl_main = {"focus up son.", "All"}
		game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents.SayMessageRequest:FireServer(unpack(tbl_main))
		dowait()
		local tbl_main = {"run my hours.", "All"}
		game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents.SayMessageRequest:FireServer(unpack(tbl_main))
		dowait()
		local tbl_main = {"your so bad dont duck.", "All"}
		game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents.SayMessageRequest:FireServer(unpack(tbl_main))
		dowait()
		local tbl_main = {"lol airshotted so bad.", "All"}
		game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents.SayMessageRequest:FireServer(unpack(tbl_main))
		dowait()
		local tbl_main = {"ur bad kid run officials.", "All"}
		game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents.SayMessageRequest:FireServer(unpack(tbl_main))
	end
})

-- No Display Names
MainTab:AddButton({
	Name = "No Display Names",
	Callback = function()
		pcall(function()
			for i, v in pairs(game:GetService("Players"):GetPlayers()) do
				if v.Character then
					if v.Character:FindFirstChild("Humanoid") then
						v.Character:FindFirstChild("Humanoid").DisplayName = v.Name 
					end
				end
			end
		end)
	end
})

-- Rejoin
MainTab:AddButton({
	Name = "Rejoin",
	Callback = function()
		game:GetService('TeleportService'):TeleportToPlaceInstance(game.PlaceId, game.JobId, game.Players.LocalPlayer)
	end
})

-- Combat Tab
local CombatTab = Window:MakeTab({
	Name = "Combat",
	Icon = "rbxassetid://4483345998",
	PremiumOnly = false
})

-- Inf-Jump
CombatTab:AddButton({
	Name = "Inf-Jump",
	Callback = function()
		local player = game.Players.LocalPlayer
		local spacedown = false
		staminup = true
		game:GetService('UserInputService').InputBegan:Connect(function(key,b)
			if key.KeyCode == Enum.KeyCode.Space and not b then
				if staminup == true then
					spacedown = true
					while spacedown == true do
						wait()
						player.Character:FindFirstChildWhichIsA('Humanoid').JumpPower = 50
						player.Character:FindFirstChildWhichIsA('Humanoid').Jump = true
						player.Character:FindFirstChildWhichIsA('Humanoid').JumpPower = 50
					end
				end
			end
		end)
		game:GetService('UserInputService').InputEnded:Connect(function(key,b)
			if key.KeyCode == Enum.KeyCode.Space and not b then
				if staminup == true then
					spacedown = false
				end
			end
		end)
	end
})

-- Anti-Slow
CombatTab:AddToggle({
	Name = "Anti-Slow",
	Default = false,
	Callback = function(Value)
		if Value then
			game:GetService('RunService'):BindToRenderStep("Anti-Slow", 0 , function()
				if game.Players.LocalPlayer.Character.BodyEffects.Movement:FindFirstChild("NoWalkSpeed") then game.Players.LocalPlayer.Character.BodyEffects.Movement:FindFirstChild("NoWalkSpeed"):Destroy() end
				if game.Players.LocalPlayer.Character.BodyEffects.Movement:FindFirstChild("ReduceWalk") then game.Players.LocalPlayer.Character.BodyEffects.Movement:FindFirstChild("ReduceWalk"):Destroy() end
				if game.Players.LocalPlayer.Character.BodyEffects.Movement:FindFirstChild("NoJumping") then game.Players.LocalPlayer.Character.BodyEffects.Movement:FindFirstChild("NoJumping"):Destroy() end
				if game.Players.LocalPlayer.Character.BodyEffects.Reload.Value == true then game.Players.LocalPlayer.Character.BodyEffects.Reload.Value = false end
			end)
		else
			game:GetService('RunService'):UnbindFromRenderStep("Anti-Slow")
		end
	end
})

-- Reach
CombatTab:AddToggle({
	Name = "Reach",
	Default = false,
	Callback = function(Value)
		if Value then
			game:GetService('RunService'):BindToRenderStep("Reach", 0 , function()
				local success, err = pcall(function()
					if game.Players.LocalPlayer.Character.BodyEffects.Attacking.Value == true then
						for i,v in pairs(game:GetService('Players'):GetChildren()) do
							if (v.Character.HumanoidRootPart.Position - game.Players.LocalPlayer.Character.LeftHand.Position).Magnitude <= 50 then
								if game.Players.LocalPlayer.Character:FindFirstChildOfClass("Tool") then
									if game.Players.LocalPlayer.Character:FindFirstChildOfClass("Tool"):FindFirstChild('Handle') then
										firetouchinterest(game.Players.LocalPlayer.Character:FindFirstChildOfClass("Tool").Handle, v.Character.UpperTorso, 0)
									else
										firetouchinterest(game.Players.LocalPlayer.Character['RightHand'], v.Character.UpperTorso, 0)
										firetouchinterest(game.Players.LocalPlayer.Character['LeftHand'], v.Character.UpperTorso, 0)
										firetouchinterest(game.Players.LocalPlayer.Character['RightFoot'], v.Character.UpperTorso, 0)
										firetouchinterest(game.Players.LocalPlayer.Character['LeftFoot'], v.Character.UpperTorso, 0)
										firetouchinterest(game.Players.LocalPlayer.Character['RightLowerLeg'], v.Character.UpperTorso, 0)
										firetouchinterest(game.Players.LocalPlayer.Character['LeftLowerLeg'], v.Character.UpperTorso, 0)
									end
								end
							end
						end
					end
				end)
			end)
		else
			game:GetService('RunService'):UnbindFromRenderStep("Reach")
		end
	end
})

-- Auto-Stomp
CombatTab:AddToggle({
	Name = "Auto-Stomp",
	Default = false,
	Callback = function(Value)
		if Value then
			game:GetService('RunService'):BindToRenderStep("Auto-Stomp", 0 , function()
				game:GetService("ReplicatedStorage").MainEvent:FireServer("Stomp")
			end)
		else
			game:GetService('RunService'):UnbindFromRenderStep("Auto-Stomp")
		end
	end
})

-- Anti-Stomp
CombatTab:AddToggle({
	Name = "Anti-Stomp",
	Default = false,
	Callback = function(Value)
		if Value then
			game:GetService('RunService'):BindToRenderStep("Anti-Stomp", 0 , function()
				if game.Players.LocalPlayer.Character.Humanoid.Health <= 5 then
					for i,v in pairs(game.Players.LocalPlayer.Character:GetChildren()) do
						if v:IsA('MeshPart') or v:IsA('Part') then
							v:Destroy()
						end
					end
					for i,v in pairs(game.Players.LocalPlayer.Character:GetChildren()) do
						if v:IsA('Accessory') then
							v.Handle:Destroy()
						end
					end
				end
			end)
		else
			game:GetService('RunService'):UnbindFromRenderStep("Anti-Stomp")
		end
	end
})

-- Auto-Reload
CombatTab:AddToggle({
	Name = "Auto-Reload",
	Default = false,
	Callback = function(Value)
		if Value then
			game:GetService('RunService'):BindToRenderStep("Auto-Reload", 0 , function()
				if game:GetService("Players").LocalPlayer.Character:FindFirstChildWhichIsA("Tool") then
					if game:GetService("Players").LocalPlayer.Character:FindFirstChildWhichIsA("Tool"):FindFirstChild("Ammo") then
						if game:GetService("Players").LocalPlayer.Character:FindFirstChildWhichIsA("Tool"):FindFirstChild("Ammo").Value <= 0 then
							game:GetService("ReplicatedStorage").MainEvent:FireServer("Reload", game:GetService("Players").LocalPlayer.Character:FindFirstChildWhichIsA("Tool")) 
							wait(1)
						end
					end
				end
			end)
		else
			game:GetService('RunService'):UnbindFromRenderStep("Auto-Reload")
		end
	end
})

-- Inf-Armor
CombatTab:AddToggle({
	Name = "Inf-Armor (STILL IN DEV)",
	Default = false,
	Callback = function(Value)
		if Value then
			local Position = game.Players.LocalPlayer.Character.HumanoidRootPart.Position
			game:GetService('RunService'):BindToRenderStep("Inf-Armor", 0 , function()
				local LocalPlayer = game.Players.LocalPlayer
				if LocalPlayer.Character.BodyEffects.Armor.Value == 0 then
					function Buy()
						LocalPlayer.Character.HumanoidRootPart.CFrame = game.Workspace.Ignored.Shop["[Medium Armor] - $1000"].Head.CFrame + Vector3.new(0, 3, 0)
						if (LocalPlayer.Character.HumanoidRootPart.Position - game.Workspace.Ignored.Shop["[Medium Armor] - $1000"].Head.Position).Magnitude <= 50 then
							wait(.2)
							fireclickdetector(game.Workspace.Ignored.Shop["[Medium Armor] - $1000"].ClickDetector, 4)
							wait()
							LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(Position)
						end
						if LocalPlayer.Character.BodyEffects.Armor.Value <= 0 then
							LocalPlayer.Character.HumanoidRootPart.CFrame = game.Workspace.Ignored.Shop["[Medium Armor] - $1000"].Head.CFrame + Vector3.new(0, 3, 0)
							if (LocalPlayer.Character.HumanoidRootPart.Position - game.Workspace.Ignored.Shop["[Medium Armor] - $1000"].Head.Position).Magnitude <= 50 then
								wait(.2)
								fireclickdetector(game.Workspace.Ignored.Shop["[Medium Armor] - $1000"].ClickDetector, 4)
								wait()
								LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(Position)
							end
						end
					end
					Buy()
				end
			end)
		else
			game:GetService('RunService'):UnbindFromRenderStep("Inf-Armor")
		end
	end
})

-- No Recoil
CombatTab:AddButton({
	Name = "No Recoil",
	Callback = function()
		local player = game.Players.LocalPlayer
		for i,v in pairs(game:GetService('Workspace'):GetChildren()) do
			if v:IsA('Camera') then
				v:Destroy()
			end
		end
		local newcam = Instance.new('Camera')
		newcam.Parent = game:GetService('Workspace')
		newcam.Name = 'Camera'
		newcam.CameraType = 'Custom'
		newcam.CameraSubject = player.Character:FindFirstChildWhichIsA('Humanoid')
		newcam.HeadLocked = true
		newcam.HeadScale = 1 
	end
})

-- Hoodshark
CombatTab:AddButton({
	Name = "Hoodshark",
	Callback = function() 
		loadstring(game:HttpGet('http://bin.shortbin.eu:8080/raw/n2dTcDByxD'))()
	end
})

-- Teleports Tab
local TeleportsTab = Window:MakeTab({
	Name = "Teleports",
	Icon = "rbxassetid://4483345998",
	PremiumOnly = false
})

TeleportsTab:AddButton({
	Name = "Admin Base", 
	Callback = function()
		game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-797.15, -39.6189, -887.957)
	end
})

TeleportsTab:AddButton({
	Name = "Food Shop [Bank]", 
	Callback = function()
		game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-335.141, 23.7129, -298.029)
	end
})

TeleportsTab:AddButton({
	Name = "Food Shop [Uphill]", 
	Callback = function()
		game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(298.477, 49.3129, -615.231)
	end
})

TeleportsTab:AddButton({
	Name = "Food Shop [Taco]", 
	Callback = function()
		game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(583.96, 51.0917, -479.596)
	end
})

TeleportsTab:AddButton({
	Name = "Food Shop [Hamburger]", 
	Callback = function()
		game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-279.501, 22.6801, -803.887)
	end
})

TeleportsTab:AddButton({
	Name = "Gun Shop [Uphill]", 
	Callback = function()
		game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(481.925, 48.1008, -621.23)
	end
})

TeleportsTab:AddButton({
	Name = "Gun Shop [Armor]", 
	Callback = function()
		game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-580.27, 8.34504, -734.832)
	end
})

TeleportsTab:AddButton({
	Name = "Bank", 
	Callback = function()
		game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-438.689, 39.0127, -284.731)
	end
})

TeleportsTab:AddButton({
	Name = "Police Station", 
	Callback = function()
		game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-263.919, 21.8302, -112.858)
	end
})

TeleportsTab:AddButton({
	Name = "Fire Department", 
	Callback = function()
		game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-129.534, 27.842, -113.062)
	end
})

TeleportsTab:AddButton({
	Name = "Church", 
	Callback = function()
		game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(205.53, 21.7803, -80.2361)
	end
})

TeleportsTab:AddButton({
	Name = "Casino", 
	Callback = function()
		game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-904.457, 24.7803, -156.994)
	end
})

TeleportsTab:AddButton({
	Name = "School",
	Callback = function()
		game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-578, 22, 337)
	end
})

-- Aimlock Tab
local AimlockTab = Window:MakeTab({
	Name = "Aimlock",
	Icon = "rbxassetid://4483345998",
	PremiumOnly = false
})

AimlockTab:AddButton({
	Name = " Lock (q)",
	Callback = function()
		_G.KEY = "q"
		_G.PART = "LowerTorso"
		_G.PRED = 0.037
		_G.Frame = Vector3.new(0,0.53,0)
		_G.AIR = -0.5
		_G.SHIT = 0.1
		
		local CC = game:GetService "Workspace".CurrentCamera
		local Plr
		local enabled = false
		local accomidationfactor = nil
		local mouse = game.Players.LocalPlayer:GetMouse()
		local placemarker = Instance.new("Part", game.Workspace)
		local guimain = Instance.new("Folder", game.CoreGui)
		
		getgenv().makemarker = function(Parent, Adornee, Color, Size, Size2)
			local e = Instance.new("BillboardGui", Parent)
			e.Name = "PP"
			e.Adornee = Adornee
			e.Size = UDim2.new(Size, Size2, Size, Size2)
			e.AlwaysOnTop = true
			local a = Instance.new("Frame", e)
			a.Size = UDim2.new(4, 0, 4, 0)
			a.BackgroundTransparency = 0.1
			a.BackgroundColor3 = Color
			local g = Instance.new("UICorner", a)
			g.CornerRadius = UDim.new(50, 50)
			return (e)
		end
		
		local data = game.Players:GetPlayers()
		function noob(player)
			local character
			repeat
				wait()
			until player.Character
			local handler = makemarker(guimain, player.Character:WaitForChild(_G.PART), Color3.fromRGB(255, 255, 255), 0.0, 0)
			handler.Name = player.Name
			player.CharacterAdded:connect(
				function(Char)
					handler.Adornee = Char:WaitForChild(_G.PART)
				end
			)
		
			local TextLabel = Instance.new("TextLabel", handler)
			TextLabel.BackgroundTransparency = 1
			TextLabel.Position = UDim2.new(0, 0, 0, -50)
			TextLabel.Size = UDim2.new(0, 100, 0, 100)
			TextLabel.Font = Enum.Font.SourceSansSemibold
			TextLabel.TextSize = 14
			TextLabel.TextColor3 = Color3.new(1, 1, 1)
			TextLabel.TextStrokeTransparency = 0
			TextLabel.Text = "Name: " .. player.Name
			TextLabel.ZIndex = 10
		
			spawn(
				function()
					while wait() do
						if player.Character t
