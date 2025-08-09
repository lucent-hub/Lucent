local Players = game:GetService("Players")

local RunService = game:GetService("RunService")

local TweenService = game:GetService("TweenService")

local LocalPlayer = Players.LocalPlayer

local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

_G.HeadSize = 20

_G.Disabled = true

-- Create GUI

local screenGui = Instance.new("ScreenGui", PlayerGui)

screenGui.Name = "BetterDropdownGUI"

screenGui.ResetOnSpawn = false

local main = Instance.new("Frame", screenGui)

main.Size = UDim2.new(0, 200, 0, 54)

main.Position = UDim2.new(0.35, 0, 0.35, 0)

main.BackgroundColor3 = Color3.fromRGB(20, 20, 20)

main.BorderSizePixel = 0

main.Active = true

main.ClipsDescendants = true

Instance.new("UICorner", main).CornerRadius = UDim.new(0, 8)

local icon = Instance.new("ImageLabel", main)

icon.Size = UDim2.new(0, 20, 0, 20)

icon.Position = UDim2.new(0, 8, 0, 8)

icon.Image = "rbxassetid://102535316350486"

icon.BackgroundTransparency = 1

local title = Instance.new("TextLabel", main)

title.Size = UDim2.new(1, -64, 0, 20)

title.Position = UDim2.new(0, 34, 0, 8)

title.Text = "Lucent Hub"

title.TextColor3 = Color3.new(1, 1, 1)

title.BackgroundTransparency = 1

title.Font = Enum.Font.Gotham

title.TextSize = 14

title.TextXAlignment = Enum.TextXAlignment.Left

local description = Instance.new("TextLabel", main)

description.Size = UDim2.new(1, -20, 0, 16)

description.Position = UDim2.new(0, 10, 0, 28)

description.Text = "Murder vs sheriff"

description.TextColor3 = Color3.fromRGB(160, 160, 160)

description.BackgroundTransparency = 1

description.Font = Enum.Font.Gotham

description.TextSize = 12

description.TextXAlignment = Enum.TextXAlignment.Left

local toggleArrow = Instance.new("ImageButton", main)

toggleArrow.Size = UDim2.new(0, 20, 0, 20)

toggleArrow.Position = UDim2.new(1, -28, 0, 8)

toggleArrow.Image = "rbxassetid://10734950309"

toggleArrow.BackgroundTransparency = 1

-- Dropdown

local dropdown = Instance.new("Frame", main)

dropdown.Position = UDim2.new(0, 0, 0, 54)

dropdown.Size = UDim2.new(1, 0, 0, 70)

dropdown.BackgroundColor3 = Color3.fromRGB(30, 30, 30)

dropdown.ClipsDescendants = true

Instance.new("UICorner", dropdown).CornerRadius = UDim.new(0, 6)

local headSizeBox = Instance.new("TextBox", dropdown)

headSizeBox.PlaceholderText = "Size (e.g., 20)"

headSizeBox.Text = tostring(_G.HeadSize)

headSizeBox.Size = UDim2.new(1, -10, 0, 28)

headSizeBox.Position = UDim2.new(0, 5, 0, 6)

headSizeBox.TextColor3 = Color3.new(1, 1, 1)

headSizeBox.BackgroundColor3 = Color3.fromRGB(50, 50, 50)

headSizeBox.Font = Enum.Font.Gotham

headSizeBox.TextSize = 14

Instance.new("UICorner", headSizeBox).CornerRadius = UDim.new(0, 5)

local enableToggle = Instance.new("TextButton", dropdown)

enableToggle.Size = UDim2.new(1, -10, 0, 28)

enableToggle.Position = UDim2.new(0, 5, 0, 38)

enableToggle.Text = "Toggle ON"

enableToggle.BackgroundColor3 = Color3.fromRGB(70, 70, 70)

enableToggle.TextColor3 = Color3.new(1, 1, 1)

enableToggle.Font = Enum.Font.Gotham

enableToggle.TextSize = 14

Instance.new("UICorner", enableToggle).CornerRadius = UDim.new(0, 5)

-- Dragify Function

function dragify(Frame)

	local dragToggle, dragInput, dragStart, startPos	local function updateInput(input)

		local delta = input.Position - dragStart

		local pos = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)

		TweenService:Create(Frame, TweenInfo.new(.25), {Position = pos}):Play()

	end

	Frame.InputBegan:Connect(function(input)

		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then

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

		if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then

			dragInput = input

		end

	end)

	game:GetService("UserInputService").InputChanged:Connect(function(input)

		if input == dragInput and dragToggle then

			updateInput(input)

		end

	end)

end

dragify(main)

-- Dropdown toggle logic with TweenService

local expanded = false

local expandedSize = UDim2.new(0, 200, 0, 130)

local collapsedSize = UDim2.new(0, 200, 0, 54)

toggleArrow.MouseButton1Click:Connect(function()

	expanded = not expanded

	local tweenInfo = TweenInfo.new(0.25, Enum.EasingStyle.Sine, Enum.EasingDirection.Out)

	TweenService:Create(main, tweenInfo, {Size = expanded and expandedSize or collapsedSize}):Play()

end)

-- Input listener

headSizeBox.FocusLost:Connect(function()

	local newSize = tonumber(headSizeBox.Text)

	if newSize then _G.HeadSize = newSize end

end)

enableToggle.MouseButton1Click:Connect(function()

	_G.Disabled = not _G.Disabled

	enableToggle.Text = _G.Disabled and "Toggle ON" or "Toggle OFF"

end)

-- Hitbox highlighting

RunService.RenderStepped:Connect(function()

	if _G.Disabled then

		for _, player in ipairs(Players:GetPlayers()) do

			if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Head") then

				local head = player.Character.Head

				pcall(function()

					head.Size = Vector3.new(_G.HeadSize, _G.HeadSize, _G.HeadSize)

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
