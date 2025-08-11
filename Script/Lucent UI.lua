-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- UI & Logic Table
local BetterDropdown = {}
BetterDropdown.__index = BetterDropdown

function BetterDropdown.new()
	local self = setmetatable({}, BetterDropdown)

	self.HeadSize = 20
	self.Disabled = true
	self.Expanded = false

	-- Create GUI
	self.ScreenGui = Instance.new("ScreenGui", PlayerGui)
	self.ScreenGui.Name = "BetterDropdownGUI"
	self.ScreenGui.ResetOnSpawn = false

	self.MainFrame = Instance.new("Frame", self.ScreenGui)
	self.MainFrame.Size = UDim2.new(0, 200, 0, 54)
	self.MainFrame.Position = UDim2.new(0.35, 0, 0.35, 0)
	self.MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
	self.MainFrame.BorderSizePixel = 0
	self.MainFrame.Active = true
	self.MainFrame.ClipsDescendants = true
	Instance.new("UICorner", self.MainFrame).CornerRadius = UDim.new(0, 8)

	local icon = Instance.new("ImageLabel", self.MainFrame)
	icon.Size = UDim2.new(0, 20, 0, 20)
	icon.Position = UDim2.new(0, 8, 0, 8)
	icon.Image = "rbxassetid://102535316350486"
	icon.BackgroundTransparency = 1

	local title = Instance.new("TextLabel", self.MainFrame)
	title.Size = UDim2.new(1, -64, 0, 20)
	title.Position = UDim2.new(0, 34, 0, 8)
	title.Text = "Lucent Hub"
	title.TextColor3 = Color3.new(1, 1, 1)
	title.BackgroundTransparency = 1
	title.Font = Enum.Font.Gotham
	title.TextSize = 14
	title.TextXAlignment = Enum.TextXAlignment.Left

	local description = Instance.new("TextLabel", self.MainFrame)
	description.Size = UDim2.new(1, -20, 0, 16)
	description.Position = UDim2.new(0, 10, 0, 28)
	description.Text = "Murder vs sheriff"
	description.TextColor3 = Color3.fromRGB(160, 160, 160)
	description.BackgroundTransparency = 1
	description.Font = Enum.Font.Gotham
	description.TextSize = 12
	description.TextXAlignment = Enum.TextXAlignment.Left

	self.ToggleArrow = Instance.new("ImageButton", self.MainFrame)
	self.ToggleArrow.Size = UDim2.new(0, 20, 0, 20)
	self.ToggleArrow.Position = UDim2.new(1, -28, 0, 8)
	self.ToggleArrow.Image = "rbxassetid://10734950309"
	self.ToggleArrow.BackgroundTransparency = 1

	self.Dropdown = Instance.new("Frame", self.MainFrame)
	self.Dropdown.Position = UDim2.new(0, 0, 0, 54)
	self.Dropdown.Size = UDim2.new(1, 0, 0, 70)
	self.Dropdown.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
	self.Dropdown.ClipsDescendants = true
	Instance.new("UICorner", self.Dropdown).CornerRadius = UDim.new(0, 6)

	self.HeadSizeBox = Instance.new("TextBox", self.Dropdown)
	self.HeadSizeBox.PlaceholderText = "Size (e.g., 20)"
	self.HeadSizeBox.Text = tostring(self.HeadSize)
	self.HeadSizeBox.Size = UDim2.new(1, -10, 0, 28)
	self.HeadSizeBox.Position = UDim2.new(0, 5, 0, 6)
	self.HeadSizeBox.TextColor3 = Color3.new(1, 1, 1)
	self.HeadSizeBox.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
	self.HeadSizeBox.Font = Enum.Font.Gotham
	self.HeadSizeBox.TextSize = 14
	Instance.new("UICorner", self.HeadSizeBox).CornerRadius = UDim.new(0, 5)

	self.EnableToggle = Instance.new("TextButton", self.Dropdown)
	self.EnableToggle.Size = UDim2.new(1, -10, 0, 28)
	self.EnableToggle.Position = UDim2.new(0, 5, 0, 38)
	self.EnableToggle.Text = "Toggle ON"
	self.EnableToggle.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
	self.EnableToggle.TextColor3 = Color3.new(1, 1, 1)
	self.EnableToggle.Font = Enum.Font.Gotham
	self.EnableToggle.TextSize = 14
	Instance.new("UICorner", self.EnableToggle).CornerRadius = UDim.new(0, 5)

	-- Connections
	self:ConnectEvents()

	-- Drag
	self:Dragify(self.MainFrame)

	-- Start highlighting loop
	self:StartHighlightLoop()

	return self
end

function BetterDropdown:ConnectEvents()
	self.ToggleArrow.MouseButton1Click:Connect(function()
		self:ToggleDropdown()
	end)

	self.HeadSizeBox.FocusLost:Connect(function(enterPressed)
		local newSize = tonumber(self.HeadSizeBox.Text)
		if newSize then
			self:SetHeadSize(newSize)
		else
			self.HeadSizeBox.Text = tostring(self.HeadSize)
		end
	end)

	self.EnableToggle.MouseButton1Click:Connect(function()
		self.Disabled = not self.Disabled
		self.EnableToggle.Text = self.Disabled and "Toggle ON" or "Toggle OFF"
	end)
end

function BetterDropdown:ToggleDropdown()
	self.Expanded = not self.Expanded
	local tweenInfo = TweenInfo.new(0.25, Enum.EasingStyle.Sine, Enum.EasingDirection.Out)
	local newSize = self.Expanded and UDim2.new(0, 200, 0, 130) or UDim2.new(0, 200, 0, 54)
	TweenService:Create(self.MainFrame, tweenInfo, {Size = newSize}):Play()
end

function BetterDropdown:SetHeadSize(size)
	self.HeadSize = size
	self.HeadSizeBox.Text = tostring(size)
end

function BetterDropdown:Dragify(Frame)
	local dragToggle, dragInput, dragStart, startPos

	local function updateInput(input)
		local delta = input.Position - dragStart
		local pos = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X,
			startPos.Y.Scale, startPos.Y.Offset + delta.Y)
		TweenService:Create(Frame, TweenInfo.new(.25), {Position = pos}):Play()
	end

	Frame.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or
			input.UserInputType == Enum.UserInputType.Touch then
			dragToggle = true
			dragStart = input.Position
			startPos = Frame.Position

			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					dragToggle = false
				end
			end)
		end
	end)

	Frame.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement or
			input.UserInputType == Enum.UserInputType.Touch then
			dragInput = input
		end
	end)

	UserInputService.InputChanged:Connect(function(input)
		if input == dragInput and dragToggle then
			updateInput(input)
		end
	end)
end

function BetterDropdown:StartHighlightLoop()
	self.Connection = RunService.RenderStepped:Connect(function()
		if self.Disabled then
			for _, player in ipairs(Players:GetPlayers()) do
				if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Head") then
					local head = player.Character.Head
					pcall(function()
						head.Size = Vector3.new(self.HeadSize, self.HeadSize, self.HeadSize)
						head.Transparency = 1
						head.BrickColor = BrickColor.new("Really red")
						head.Material = Enum.Material.Neon
						head.CanCollide = false
						head.Massless = true

						local box = head:FindFirstChild("HighlightBox")
						if not box then
							box = Instance.new("BoxHandleAdornment")
							box.Name = "HighlightBox"
							box.Adornee = head
							box.Size = head.Size
							box.AlwaysOnTop = true
							box.ZIndex = 10
							box.Color3 = Color3.new(1, 0, 0)
							box.Transparency = 0.4
							box.Parent = head
						else
							box.Size = head.Size
						end
					end)
				end
			end
		else
			for _, player in ipairs(Players:GetPlayers()) do
				if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Head") then
					local box = player.Character.Head:FindFirstChild("HighlightBox")
					if box then box:Destroy() end
				end
			end
		end
	end)

	Players.PlayerAdded:Connect(function(p)
		p.CharacterAdded:Connect(function(char)
			char:WaitForChild("Head"):GetPropertyChangedSignal("Parent"):Connect(function()
				local box = char.Head:FindFirstChild("HighlightBox")
				if box then box:Destroy() end
			end)
		end)
	end)
end

-- Create UI and start
local uiInstance = BetterDropdown.new()

-- Optional: expose toggle functions in the executor global environment
_G.BetterDropdownUI = uiInstance
