--// Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local player = Players.LocalPlayer

--// GUI Setup
local screenGui = Instance.new("ScreenGui")
screenGui.Parent = player:WaitForChild("PlayerGui")
screenGui.Name = "FollowGUI"
screenGui.ResetOnSpawn = false

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 250, 0, 350)
frame.Position = UDim2.new(0, 20, 0.5, -175)
frame.BackgroundColor3 = Color3.fromRGB(10, 10, 20)
frame.BorderSizePixel = 0
frame.Parent = screenGui

-- Neon cyan border
local stroke = Instance.new("UIStroke", frame)
stroke.Thickness = 2.5
stroke.Color = Color3.fromRGB(0, 255, 255)
stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

local uiCorner = Instance.new("UICorner", frame)
uiCorner.CornerRadius = UDim.new(0, 12)

-- Title bar
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -50, 0, 40)
title.Position = UDim2.new(0, 0, 0, 0)
title.Text = "{ LUCENT HUB }"
title.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
title.TextColor3 = Color3.fromRGB(0, 255, 255)
title.TextScaled = true
title.Font = Enum.Font.GothamBold
title.Parent = frame

local titleStroke = Instance.new("UIStroke", title)
titleStroke.Thickness = 1.5
titleStroke.Color = Color3.fromRGB(0, 200, 255)

-- Minimize Button
local minButton = Instance.new("TextButton")
minButton.Size = UDim2.new(0, 30, 0, 30)
minButton.Position = UDim2.new(1, -40, 0, 5)
minButton.BackgroundColor3 = Color3.fromRGB(20,20,30)
minButton.Text = "-"
minButton.TextColor3 = Color3.fromRGB(0,255,255)
minButton.Font = Enum.Font.GothamBold
minButton.TextSize = 22
minButton.Parent = frame
local minCorner = Instance.new("UICorner", minButton)
minCorner.CornerRadius = UDim.new(0,6)

-- Follow All Button
local allButton = Instance.new("TextButton")
allButton.Size = UDim2.new(1, -20, 0, 35)
allButton.Position = UDim2.new(0, 10, 0, 50)
allButton.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
allButton.TextColor3 = Color3.fromRGB(0, 255, 255)
allButton.Text = "FOLLOW ALL"
allButton.Font = Enum.Font.GothamBold
allButton.TextScaled = true
allButton.Parent = frame
local allCorner = Instance.new("UICorner", allButton)
allCorner.CornerRadius = UDim.new(0,8)
local allStroke = Instance.new("UIStroke", allButton)
allStroke.Color = Color3.fromRGB(0,255,255)
allStroke.Thickness = 1.5

-- ScrollingFrame for players
local scrollingFrame = Instance.new("ScrollingFrame")
scrollingFrame.Size = UDim2.new(1, -20, 1, -110)
scrollingFrame.Position = UDim2.new(0, 10, 0, 95)
scrollingFrame.BackgroundColor3 = Color3.fromRGB(10,10,15)
scrollingFrame.CanvasSize = UDim2.new(0,0,0,0)
scrollingFrame.ScrollBarThickness = 6
scrollingFrame.Parent = frame

local scrollCorner = Instance.new("UICorner", scrollingFrame)
scrollCorner.CornerRadius = UDim.new(0,8)
local scrollStroke = Instance.new("UIStroke", scrollingFrame)
scrollStroke.Color = Color3.fromRGB(0,255,255)
scrollStroke.Thickness = 1

local listLayout = Instance.new("UIListLayout", scrollingFrame)
listLayout.Padding = UDim.new(0,6)

--// Follow Script Variables
local function getCharacter()
	local char = player.Character or player.CharacterAdded:Wait()
	local hrp = char:WaitForChild("HumanoidRootPart")
	return char, hrp
end

local followConnection
local selectedPlayer
local followAll = false
local t = 0

--// Fancy follow function
local function followTarget(targetPlayer)
	if followConnection then
		followConnection:Disconnect()
		local _, hrp = getCharacter()
		hrp.CFrame = hrp.CFrame
	end

	if not targetPlayer then return end
	selectedPlayer = targetPlayer
	t = 0

	followConnection = RunService.Heartbeat:Connect(function(dt)
		local char, hrp = getCharacter()
		if selectedPlayer and selectedPlayer.Character and selectedPlayer.Character:FindFirstChild("HumanoidRootPart") then
			local humanoid = selectedPlayer.Character:FindFirstChildOfClass("Humanoid")
			if humanoid and humanoid.Sit then
				if followAll then
					for _, p in pairs(Players:GetPlayers()) do
						if p ~= player and p.Character then
							local hum = p.Character:FindFirstChildOfClass("Humanoid")
							if hum and not hum.Sit then
								selectedPlayer = p
								t = 0
								return
							end
						end
					end
				else
					hrp.CFrame = hrp.CFrame
					followConnection:Disconnect()
				end
				return
			end

			t = t + dt
			local yOffset = math.sin(t * 2 * math.pi) * 3
			local zOffset = math.sin(t * 1.5 * math.pi) * 2
			local rotation = CFrame.Angles(0, math.rad(t*90), 0)
			local targetCFrame = selectedPlayer.Character.HumanoidRootPart.CFrame
			hrp.CFrame = targetCFrame * CFrame.new(0,3+yOffset,zOffset) * rotation
		elseif followAll then
			for _, p in pairs(Players:GetPlayers()) do
				if p ~= player and p.Character then
					local hum = p.Character:FindFirstChildOfClass("Humanoid")
					if hum and not hum.Sit then
						selectedPlayer = p
						t = 0
						return
					end
				end
			end
		end
	end)
end

--// Follow All Button
allButton.MouseButton1Click:Connect(function()
	followAll = true
	for _, p in pairs(Players:GetPlayers()) do
		if p ~= player and p.Character then
			local hum = p.Character:FindFirstChildOfClass("Humanoid")
			if hum and not hum.Sit then
				followTarget(p)
				break
			end
		end
	end
end)

--// Create Player Buttons
local function addPlayerButton(p)
	local button = Instance.new("TextButton")
	button.Size = UDim2.new(1, -5, 0, 30)
	button.BackgroundColor3 = Color3.fromRGB(20,20,30)
	button.TextColor3 = Color3.fromRGB(0,255,255)
	button.Font = Enum.Font.GothamBold
	button.Text = p.Name
	button.TextScaled = true
	button.Parent = scrollingFrame

	Instance.new("UICorner", button).CornerRadius = UDim.new(0,6)
	local btnStroke = Instance.new("UIStroke", button)
	btnStroke.Color = Color3.fromRGB(0,255,255)
	btnStroke.Thickness = 1

	button.MouseButton1Click:Connect(function()
		followAll = false
		followTarget(p)
	end)
	scrollingFrame.CanvasSize = UDim2.new(0,0,0, listLayout.AbsoluteContentSize.Y)
end

--// Remove button
local function removePlayerButton(p)
	for _, child in pairs(scrollingFrame:GetChildren()) do
		if child:IsA("TextButton") and child.Text == p.Name then
			child:Destroy()
		end
	end
	scrollingFrame.CanvasSize = UDim2.new(0,0,0, listLayout.AbsoluteContentSize.Y)
end

--// Populate
for _, p in pairs(Players:GetPlayers()) do
	if p ~= player then addPlayerButton(p) end
end

Players.PlayerAdded:Connect(addPlayerButton)
Players.PlayerRemoving:Connect(removePlayerButton)

--// Minimize Toggle (fixed)
local minimized = false
local oldSize = frame.Size
local oldBG = frame.BackgroundColor3
minButton.MouseButton1Click:Connect(function()
	if minimized then
		frame:TweenSize(oldSize,"Out","Quad",0.4,true)
		frame.BackgroundColor3 = oldBG
		minimized = false
	else
		oldSize = frame.Size
		frame:TweenSize(UDim2.new(0, oldSize.X.Offset, 0, 40),"Out","Quad",0.4,true)
		frame.BackgroundColor3 = Color3.fromRGB(0,0,0) -- hides background
		minimized = true
	end
end)

--// Draggable Title
local dragging = false
local dragInput, dragStart, startPos
local function update(input)
	local delta = input.Position - dragStart
	frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X,
		startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

title.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		dragging = true
		dragStart = input.Position
		startPos = frame.Position
		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then dragging = false end
		end)
	end
end)
title.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
		dragInput = input
	end
end)
UserInputService.InputChanged:Connect(function(input)
	if input == dragInput and dragging then update(input) end
end)

--// Reset Follow on Character Respawn
player.CharacterAdded:Connect(function(char)
	char:WaitForChild("HumanoidRootPart")
	if selectedPlayer then
		followTarget(selectedPlayer)
	elseif followAll then
		allButton:MouseButton1Click()
	end
end)
