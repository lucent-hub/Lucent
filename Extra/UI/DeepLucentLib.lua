-- DeepLucentLib.lua
-- UI library styled to match your deepseek_lua_20250813_64d8da.lua single script,
-- with tabs/sections/components, minimize/reopen, notifications, and a key system overlay.
-- All in one file; return a module table.

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local PlayerGui = player:WaitForChild("PlayerGui")

-- Safe executor file helpers (no errors in Studio)
local function safe_isfile(path)
    local ok, res = pcall(function() return isfile and isfile(path) end)
    return ok and res or false
end
local function safe_readfile(path)
    local ok, res = pcall(function() return readfile and readfile(path) end)
    return ok and res or nil
end
local function safe_writefile(path, content)
    pcall(function() if writefile then writefile(path, content) end end)
end

local function mk(class, props, parent)
    local o = Instance.new(class)
    if props then for k,v in pairs(props) do o[k] = v end end
    if parent then o.Parent = parent end
    return o
end

local function uiCorner(parent, r) return mk("UICorner", {CornerRadius = UDim.new(0, r or 8)}, parent) end
local function uiStroke(parent, th, col, tr) return mk("UIStroke", {Thickness = th or 1, Color = col or Color3.fromRGB(255,255,255), Transparency = tr or 0.7}, parent) end
local function tween(o, ti, props) TweenService:Create(o, ti or TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), props):Play() end
local function isMobile() return UserInputService.TouchEnabled and not UserInputService.MouseEnabled end

-- =====================================
-- Notification Controller (stacked top)
-- =====================================
local Notifier = {}
Notifier.__index = Notifier
function Notifier.new(rootGui)
    local self = setmetatable({}, Notifier)
    self.Gui = rootGui
    self.Stack = {}
    self.Max = 3
    self.Time = 5
    return self
end
function Notifier:Send(title, message, color)
    color = color or Color3.fromRGB(0,170,255)
    local f = mk("Frame", {
        Size = UDim2.new(0, 420, 0, 70),
        Position = UDim2.new(0.5, 0, 0, -80),
        AnchorPoint = Vector2.new(0.5, 0),
        BackgroundColor3 = Color3.fromRGB(15,15,20),
        BackgroundTransparency = 0.1,
        ZIndex = 100,
        Parent = self.Gui
    })
    uiStroke(f, 2, color, 0.25); uiCorner(f, 8)
    local titleLabel = mk("TextLabel", {
        Size = UDim2.new(0.9, 0, 0, 25),
        Position = UDim2.new(0.05, 0, 0, 8),
        Text = string.upper(tostring(title or "NOTICE")),
        Font = Enum.Font.GothamBold,
        TextColor3 = color,
        TextSize = 18,
        TextXAlignment = Enum.TextXAlignment.Left,
        BackgroundTransparency = 1,
        ZIndex = 101,
        Parent = f
    })
    local messageLabel = mk("TextLabel", {
        Size = UDim2.new(0.9, 0, 0, 30),
        Position = UDim2.new(0.05, 0, 0, 34),
        Text = tostring(message or ""),
        Font = Enum.Font.GothamMedium,
        TextColor3 = Color3.fromRGB(255,255,255),
        TextWrapped = true,
        TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextYAlignment = Enum.TextYAlignment.Top,
        BackgroundTransparency = 1,
        ZIndex = 101,
        Parent = f
    })
    local y = 20 + (#self.Stack * 80)
    tween(f, TweenInfo.new(0.25), { Position = UDim2.new(0.5, 0, 0, y) })
    table.insert(self.Stack, f)

    task.delay(self.Time, function()
        if f and f.Parent then
            tween(f, TweenInfo.new(0.25), { Position = UDim2.new(0.5, 0, 0, -80) })
            task.delay(0.26, function() if f then f:Destroy() end end)
            for i, n in ipairs(self.Stack) do if n == f then table.remove(self.Stack, i) break end end
            for i, n in ipairs(self.Stack) do
                tween(n, TweenInfo.new(0.2), { Position = UDim2.new(0.5, 0, 0, 20 + ((i-1)*80)) })
            end
        end
    end)
    if #self.Stack > self.Max then
        local oldest = table.remove(self.Stack, 1)
        if oldest then tween(oldest, TweenInfo.new(0.2), { Position = UDim2.new(0.5,0,0,-80) }); task.delay(0.21, function() if oldest then oldest:Destroy() end end) end
        for i, n in ipairs(self.Stack) do
            tween(n, TweenInfo.new(0.2), { Position = UDim2.new(0.5, 0, 0, 20 + ((i-1)*80)) })
        end
    end
end

-- ===================
-- Window + Tabs + UI
-- ===================
local Lib = {}
Lib.__index = Lib

local Window = {}
Window.__index = Window

local Tab = {}
Tab.__index = Tab

local Section = {}
Section.__index = Section

function Lib:CreateWindow(title, version, opts)
    opts = opts or {}
    local selfWin = setmetatable({}, Window)

    local sg = mk("ScreenGui", {
        Name = "DeepLucentUI",
        ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        Parent = PlayerGui
    })
    selfWin.Gui = sg
    selfWin.Notifier = Notifier.new(sg)
    selfWin._tabs = {}
    selfWin._active = nil

    -- Main
    local main = mk("Frame", {
        Size = isMobile() and UDim2.new(0.95, 0, 0.9, 0) or UDim2.new(0, 720, 0, 480),
        Position = UDim2.new(0.5, 0, 0.5, 0),
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundColor3 = Color3.fromRGB(15,15,20),
        BackgroundTransparency = 0.05,
        ClipsDescendants = true,
        Parent = sg
    })
    uiCorner(main, 12); uiStroke(main, 2, Color3.fromRGB(0,170,255), 0.25)
    selfWin.Main = main

    -- Title Bar
    local titleBar = mk("Frame", { Size = UDim2.new(1,0,0,40), BackgroundTransparency = 1, Parent = main })
    local titleLabel = mk("TextLabel", {
        Size = UDim2.new(0.5,0,1,0), Position = UDim2.new(0,15,0,0),
        Text = string.upper(tostring(title or "LUCENT")), Font = Enum.Font.GothamBlack,
        TextColor3 = Color3.fromRGB(0,170,255), TextSize = 24, TextXAlignment = Enum.TextXAlignment.Left,
        BackgroundTransparency = 1, Parent = titleBar
    })
    local verLabel = mk("TextLabel", {
        Size = UDim2.new(0.3,0,1,0), Position = UDim2.new(0.5,0,0,0),
        Text = tostring(version or ""), Font = Enum.Font.GothamMedium,
        TextColor3 = Color3.fromRGB(120,120,120), TextSize = 14, TextXAlignment = Enum.TextXAlignment.Left,
        BackgroundTransparency = 1, Parent = titleBar
    })
    -- Close (acts as minimize for safety)
    local closeBtn = mk("TextButton", {
        Size = UDim2.new(0,30,0,30), Position = UDim2.new(1,-40,0.5,-15), AnchorPoint = Vector2.new(1,0.5),
        Text = "×", Font = Enum.Font.GothamBold, TextColor3 = Color3.fromRGB(255,255,255), TextSize = 24,
        BackgroundColor3 = Color3.fromRGB(255,60,60), BackgroundTransparency = 0.7, AutoButtonColor = false,
        ZIndex = 10, Parent = titleBar
    })
    uiCorner(closeBtn,6); local closeStroke = uiStroke(closeBtn,1,Color3.fromRGB(255,255,255),0.7)
    closeBtn.MouseEnter:Connect(function() tween(closeBtn, nil, {BackgroundTransparency = 0.3}); closeStroke.Transparency = 0.3 end)
    closeBtn.MouseLeave:Connect(function() tween(closeBtn, nil, {BackgroundTransparency = 0.7}); closeStroke.Transparency = 0.7 end)

    -- Minimize
    local minBtn = mk("TextButton", {
        Size = UDim2.new(0,40,0,40), Position = UDim2.new(1,-90,0,5),
        Text = "_", Font = Enum.Font.Impact, TextColor3 = Color3.fromRGB(255,255,255),
        BackgroundColor3 = Color3.fromRGB(88,101,242), BackgroundTransparency = 0.5, Parent = main
    })
    uiCorner(minBtn,8); local minStroke = uiStroke(minBtn,1,Color3.fromRGB(255,255,255),0.7)

    -- Reopen floating button
    local reopen = mk("TextButton", {
        Size = UDim2.new(0,60,0,60), Position = UDim2.new(0, 20, 0.9, 0), AnchorPoint = Vector2.new(0,0.5),
        Text = "OPEN", Font = Enum.Font.Impact, TextColor3 = Color3.fromRGB(255,255,255),
        BackgroundColor3 = Color3.fromRGB(0,170,255), BackgroundTransparency = 0.5, Visible = false, ZIndex = 10, Parent = sg
    })
    uiCorner(reopen,12); local reopenStroke = uiStroke(reopen,2,Color3.fromRGB(255,255,255),0.5)
    local scale = mk("UIScale", {Scale = 1}, reopen)
    local pulse1 = TweenService:Create(scale, TweenInfo.new(0.6, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut, -1, true), {Scale = 1.1})
    local pulse2 = TweenService:Create(scale, TweenInfo.new(0.6, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut, -1, true), {Scale = 0.9})

    local function minimize()
        selfWin.Main.Visible = false
        reopen.Visible = true
        pulse1:Play(); pulse2:Play()
        if opts.notifications ~= false then selfWin:Notify("UI","UI minimized", Color3.fromRGB(120,120,120)) end
    end
    local function restore()
        selfWin.Main.Visible = true
        reopen.Visible = false
        pulse1:Cancel(); pulse2:Cancel(); scale.Scale = 1
        if opts.notifications ~= false then selfWin:Notify("UI","UI restored", Color3.fromRGB(0,170,255)) end
    end

    minBtn.MouseButton1Click:Connect(minimize)
    closeBtn.MouseButton1Click:Connect(minimize)
    reopen.MouseButton1Click:Connect(restore)

    -- Invisible corner toggle tap area
    local cornerToggle = mk("TextButton", {
        Size = UDim2.new(0, isMobile() and 60 or 40, 0, isMobile() and 60 or 40),
        Position = UDim2.new(1, isMobile() and -70 or -50, 0, 50),
        BackgroundTransparency = 1,
        Text = "",
        ZIndex = 100,
        Parent = sg
    })
    cornerToggle.MouseButton1Click:Connect(function() if selfWin.Main.Visible then minimize() else restore() end end)

    -- Drag via title bar
    do
        local dragging, dragStart, startPos, dragInput
        titleBar.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = true; dragStart = input.Position; startPos = main.Position
            end
        end)
        titleBar.InputChanged:Connect(function(input) if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseMovement then dragInput = input end end)
        UserInputService.InputChanged:Connect(function(input)
            if input == dragInput and dragging then
                local delta = input.Position - dragStart
                main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
            end
        end)
        titleBar.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end end)
    end

    -- Tabs navbar
    local nav = mk("Frame", { Size = UDim2.new(1,0,0,50), Position = UDim2.new(0,0,0,40), BackgroundTransparency = 1, Parent = main })
    local activeLine = mk("Frame", { Size = UDim2.new(0,0,0,3), Position = UDim2.new(0,0,1,0), BackgroundColor3 = Color3.fromRGB(0,170,255), BorderSizePixel = 0, ZIndex = 2, Parent = nav })
    local navList = mk("UIListLayout", { FillDirection = Enum.FillDirection.Horizontal, HorizontalAlignment = Enum.HorizontalAlignment.Left, VerticalAlignment = Enum.VerticalAlignment.Center, SortOrder = Enum.SortOrder.LayoutOrder }, nav)

    -- Content area placeholder (tabs will own pages)
    local contentBottom = 90

    function selfWin:Notify(title, msg, color) selfWin.Notifier:Send(title, msg, color) end
    function selfWin:Toggle() if selfWin.Main.Visible then minimize() else restore() end end
    function selfWin:BindToggle(keyName)
        local kc = Enum.KeyCode[keyName] or Enum.KeyCode.RightControl
        UserInputService.InputBegan:Connect(function(input, gp)
            if gp then return end
            if input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode == kc then selfWin:Toggle() end
        end)
    end
    function selfWin:Destroy() selfWin.Gui:Destroy() end

    function selfWin:CreateTab(name)
        local tab = setmetatable({}, Tab)
        tab.Name = tostring(name or "TAB")
        tab.Window = selfWin

        local btn = mk("TextButton", { Size = UDim2.new(0, 1, 1, 0), BackgroundTransparency = 1, Text = tab.Name, Font = Enum.Font.GothamBlack, TextSize = isMobile() and 20 or 18, TextColor3 = Color3.fromRGB(120,120,120), Parent = nav })
        tab.Button = btn
        btn.MouseEnter:Connect(function() if selfWin._active ~= tab then tween(btn, nil, {TextColor3 = Color3.fromRGB(0,170,255)}) end end)
        btn.MouseLeave:Connect(function() if selfWin._active ~= tab then tween(btn, nil, {TextColor3 = Color3.fromRGB(120,120,120)}) end end)

        local page = mk("ScrollingFrame", { Size = UDim2.new(1,0,1,-contentBottom), Position = UDim2.new(0,0,0,contentBottom), BackgroundTransparency = 1, ScrollBarThickness = isMobile() and 10 or 6, ScrollBarImageColor3 = Color3.fromRGB(0,170,255), ScrollBarImageTransparency = 0.5, CanvasSize = UDim2.new(0,0,0,0), Visible = false, Parent = main })
        local layout = mk("UIListLayout", { FillDirection = Enum.FillDirection.Vertical, Padding = UDim.new(0,10), SortOrder = Enum.SortOrder.LayoutOrder }, page)
        local pad = mk("UIPadding", { PaddingLeft = UDim.new(0, 24), PaddingRight = UDim.new(0, 24), PaddingTop = UDim.new(0, 10) }, page)
        tab.Page = page

        local function updateCanvas()
            local total = 0
            for _, child in ipairs(page:GetChildren()) do if child:IsA("Frame") then total = total + child.AbsoluteSize.Y + 10 end end
            page.CanvasSize = UDim2.new(0,0,0, math.max(0, total + 20))
        end
        layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(updateCanvas)
        page.ChildAdded:Connect(updateCanvas); page.ChildRemoved:Connect(updateCanvas)

        function tab:_activate()
            if selfWin._active and selfWin._active ~= tab then
                selfWin._active.Button.TextColor3 = Color3.fromRGB(120,120,120)
                selfWin._active.Page.Visible = false
            end
            selfWin._active = tab
            tab.Button.TextColor3 = Color3.fromRGB(0,170,255)
            tab.Page.Visible = true
            local absPos, absSize = tab.Button.AbsolutePosition, tab.Button.AbsoluteSize
            tween(activeLine, TweenInfo.new(0.2), { Size = UDim2.new(0, absSize.X, 0, 3), Position = UDim2.new(0, absPos.X - nav.AbsolutePosition.X, 1, 0) })
        end
        btn.MouseButton1Click:Connect(function() tab:_activate() end)
        if not selfWin._active then tab:_activate() end

        function tab:CreateSection(title)
            local head = mk("TextLabel", { Size = UDim2.new(1,0,0,28), Text = tostring(title or ""), TextColor3 = Color3.fromRGB(0,170,255), Font = Enum.Font.GothamBold, TextSize = 18, TextXAlignment = Enum.TextXAlignment.Left, BackgroundTransparency = 1, Parent = page })
            local section = setmetatable({ Root = page }, Section)
            return section
        end

        return tab
    end

    -- Responsive scrollbar thickness
    local function updateScrollFrame()
        local mobile = isMobile()
        for _, child in ipairs(main:GetChildren()) do
            if child:IsA("ScrollingFrame") then child.ScrollBarThickness = mobile and 10 or 6 end
        end
    end
    UserInputService.LastInputTypeChanged:Connect(updateScrollFrame); updateScrollFrame()

    if opts.notifications ~= false then selfWin:Notify(title or "Lucent Hub", "Welcome "..(version or ""), Color3.fromRGB(0,170,255)) end
    return selfWin
end

-- Section component builders
function Section:AddButton(text, cb)
    local f = mk("Frame", { Size = UDim2.new(1,0,0,50), BackgroundTransparency = 1, Parent = self.Root })
    local b = mk("TextButton", { Size = UDim2.new(1,0,1,0), BackgroundColor3 = Color3.fromRGB(30,30,40), Text = tostring(text or "Button"), TextColor3 = Color3.fromRGB(255,255,255), Font = Enum.Font.GothamBold, TextSize = 16, AutoButtonColor = false, Parent = f })
    uiCorner(b,8); local s = uiStroke(b,1,Color3.fromRGB(0,170,255),0.7)
    b.MouseEnter:Connect(function() tween(b, nil, {BackgroundColor3 = Color3.fromRGB(40,40,50)}); s.Transparency = 0.3 end)
    b.MouseLeave:Connect(function() tween(b, nil, {BackgroundColor3 = Color3.fromRGB(30,30,40)}); s.Transparency = 0.7 end)
    b.MouseButton1Click:Connect(function() if cb then task.spawn(cb) end end)
    return b
end

function Section:AddToggle(text, default, cb)
    local f = mk("Frame", { Size = UDim2.new(1,0,0,50), BackgroundTransparency = 1, Parent = self.Root })
    local label = mk("TextLabel", { Size = UDim2.new(0.7,0,1,0), Text = tostring(text or "Toggle"), TextColor3 = Color3.fromRGB(255,255,255), Font = Enum.Font.GothamMedium, TextSize = 16, TextXAlignment = Enum.TextXAlignment.Left, BackgroundTransparency = 1, Parent = f })
    local outer = mk("TextButton", { Size = UDim2.new(0,60,0,30), Position = UDim2.new(1,-60,0.5,-15), BackgroundColor3 = (default and Color3.fromRGB(0,100,0)) or Color3.fromRGB(40,40,50), AutoButtonColor = false, Text = "", Parent = f })
    uiCorner(outer,15)
    local inner = mk("Frame", { Size = UDim2.new(0,26,0,26), Position = (default and UDim2.new(1,-28,0.5,-13)) or UDim2.new(0,2,0.5,-13), BackgroundColor3 = (default and Color3.fromRGB(0,255,0)) or Color3.fromRGB(255,255,255), Parent = outer })
    uiCorner(inner,13)
    local hit = mk("TextButton", { Size = UDim2.new(1,20,1,20), Position = UDim2.new(0,-10,0,-10), BackgroundTransparency = 1, Text = "", Parent = outer })
    local state = not not default
    local function update()
        if state then
            tween(inner, TweenInfo.new(0.2), { Position = UDim2.new(1,-28,0.5,-13), BackgroundColor3 = Color3.fromRGB(0,255,0) })
            tween(outer, TweenInfo.new(0.2), { BackgroundColor3 = Color3.fromRGB(0,100,0) })
        else
            tween(inner, TweenInfo.new(0.2), { Position = UDim2.new(0,2,0.5,-13), BackgroundColor3 = Color3.fromRGB(255,255,255) })
            tween(outer, TweenInfo.new(0.2), { BackgroundColor3 = Color3.fromRGB(40,40,50) })
        end
    end
    local function toggle() state = not state; update(); if cb then task.spawn(cb, state) end end
    hit.MouseButton1Click:Connect(toggle)
    outer.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.Touch then toggle() end end)

    local api = {}
    function api:Set(v) state = not not v; update(); if cb then task.spawn(cb, state) end end
    function api:Get() return state end
    return api
end

function Section:AddTextbox(placeholder, defaultText, cb)
    local sec = mk("TextLabel", { Size = UDim2.new(1,0,0,30), Text = tostring(placeholder or "TEXT INPUT"), TextColor3 = Color3.fromRGB(0,170,255), Font = Enum.Font.GothamBold, TextSize = 18, TextXAlignment = Enum.TextXAlignment.Left, BackgroundTransparency = 1, Parent = self.Root })
    local f = mk("Frame", { Size = UDim2.new(1,0,0,40), BackgroundTransparency = 1, Parent = self.Root })
    local b = mk("TextBox", { Size = UDim2.new(1,0,1,0), BackgroundColor3 = Color3.fromRGB(30,30,40), Text = tostring(defaultText or ""), PlaceholderText = tostring(placeholder or "Enter text"), TextColor3 = Color3.fromRGB(255,255,255), Font = Enum.Font.Gotham, TextSize = 16, ClearTextOnFocus = false, Parent = f })
    uiCorner(b,8); local s = uiStroke(b,1,Color3.fromRGB(0,170,255),0.7)
    b.Focused:Connect(function() tween(b,nil,{BackgroundColor3 = Color3.fromRGB(35,35,45)}); s.Transparency = 0.3 end)
    b.FocusLost:Connect(function(enter) tween(b,nil,{BackgroundColor3 = Color3.fromRGB(30,30,40)}); s.Transparency = 0.7; if enter and cb then task.spawn(cb, b.Text) end end)
    return b
end

function Section:AddSlider(text, min, max, default, cb)
    min, max = tonumber(min) or 0, tonumber(max) or 100
    local val = math.clamp(tonumber(default) or min, min, max)
    local head = mk("TextLabel", { Size = UDim2.new(1,0,0,20), Text = string.format("%s %d", tostring(text or "Slider"), math.floor(val)), TextColor3 = Color3.fromRGB(255,255,255), Font = Enum.Font.GothamBold, TextSize = 16, TextXAlignment = Enum.TextXAlignment.Left, BackgroundTransparency = 1, Parent = self.Root })
    local bar = mk("Frame", { Size = UDim2.new(1,0,0,10), BackgroundColor3 = Color3.fromRGB(40,40,50), Parent = self.Root }); uiCorner(bar,5)
    local fill = mk("Frame", { Size = UDim2.new((val-min)/(max-min), 0, 1, 0), BackgroundColor3 = Color3.fromRGB(0,170,255), Parent = bar }); uiCorner(fill,5)
    local hit = mk("TextButton", { Size = UDim2.new(1,0,0,30), Position = UDim2.new(0,0,0,-10), BackgroundTransparency = 1, Text = "", Parent = bar })
    local dragging = false
    local function setFromX(x)
        local pos = math.clamp((x - bar.AbsolutePosition.X)/bar.AbsoluteSize.X, 0, 1)
        fill.Size = UDim2.new(pos,0,1,0)
        val = math.floor(min + pos*(max-min) + 0.5)
        head.Text = string.format("%s %d", tostring(text or "Slider"), val)
        if cb then task.spawn(cb, val) end
    end
    hit.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = true; setFromX(input.Position.X) end
    end)
    hit.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = false end end)
    hit.InputChanged:Connect(function(input) if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then setFromX(input.Position.X) end end)
    local api = {}
    function api:Set(v) v = math.clamp(tonumber(v) or min, min, max); local pos=(v-min)/(max-min); fill.Size = UDim2.new(pos,0,1,0); val=v; head.Text = string.format("%s %d", tostring(text or "Slider"), val); if cb then task.spawn(cb, val) end end
    function api:Get() return val end
    return api
end

function Section:AddDropdown(text, options, default, cb)
    options = options or {}
    local f = mk("Frame", { Size = UDim2.new(1,0,0,50), BackgroundTransparency = 1, Parent = self.Root })
    local btn = mk("TextButton", { Size = UDim2.new(1,0,1,0), BackgroundColor3 = Color3.fromRGB(30,30,40), Text = string.format("%s ▼", tostring(default or (text or "Select"))), TextColor3 = Color3.fromRGB(255,255,255), Font = Enum.Font.GothamBold, TextSize = 16, AutoButtonColor = false, Parent = f })
    uiCorner(btn,8); local s = uiStroke(btn,1,Color3.fromRGB(0,170,255),0.7)
    btn.MouseEnter:Connect(function() tween(btn, nil, {BackgroundColor3 = Color3.fromRGB(40,40,50)}); s.Transparency = 0.3 end)
    btn.MouseLeave:Connect(function() tween(btn, nil, {BackgroundColor3 = Color3.fromRGB(30,30,40)}); s.Transparency = 0.7 end)

    -- Overlay dropdown so it's not clipped
    local overlay = mk("Frame", { Size = UDim2.new(0,0,0,0), Position = UDim2.new(0,0,0,0), BackgroundColor3 = Color3.fromRGB(20,20,30), Visible = false, ClipsDescendants = true, ZIndex = 50, Parent = self.Root.Parent.Parent }) -- ScreenGui via Window
    uiCorner(overlay,8)

    local function rebuild()
        overlay:ClearAllChildren()
        uiCorner(overlay,8)
        local y = 0
        for _, opt in ipairs(options) do
            local o = mk("TextButton", { Size = UDim2.new(1,-10,0,40), Position = UDim2.new(0,5,0,y), BackgroundColor3 = Color3.fromRGB(30,30,40), Text = tostring(opt), TextColor3 = Color3.fromRGB(255,255,255), Font = Enum.Font.GothamBold, TextSize = 16, ZIndex = 51, Parent = overlay })
            uiCorner(o,6); local os = uiStroke(o,1,Color3.fromRGB(0,170,255),0.7)
            o.MouseEnter:Connect(function() tween(o, nil, {BackgroundColor3 = Color3.fromRGB(40,40,50)}); os.Transparency = 0.3 end)
            o.MouseLeave:Connect(function() tween(o, nil, {BackgroundColor3 = Color3.fromRGB(30,30,40)}); os.Transparency = 0.7 end)
            o.MouseButton1Click:Connect(function() btn.Text = string.format("%s ▼", tostring(opt)); overlay.Visible = false; if cb then task.spawn(cb, opt) end end)
            y = y + 40
        end
    end
    rebuild()

    local open = false
    btn.MouseButton1Click:Connect(function()
        open = not open
        if open then
            local absPos, absSize = f.AbsolutePosition, f.AbsoluteSize
            overlay.Position = UDim2.new(0, absPos.X, 0, absPos.Y + absSize.Y + 5)
            overlay.Size = UDim2.new(0, absSize.X, 0, 0)
            overlay.Visible = true
            rebuild()
            tween(overlay, TweenInfo.new(0.2), { Size = UDim2.new(0, absSize.X, 0, #options * 40) })
        else
            tween(overlay, TweenInfo.new(0.2), { Size = UDim2.new(0, overlay.AbsoluteSize.X, 0, 0) })
            task.delay(0.21, function() overlay.Visible = false end)
        end
    end)

    local api = {}
    function api:SetOptions(list) options = list or {}; rebuild() end
    function api:Set(value) btn.Text = string.format("%s ▼", tostring(value)); if cb then task.spawn(cb, value) end end
    return api
end

function Section:AddKeybind(text, defaultKeyName, cb)
    local f = mk("Frame", { Size = UDim2.new(1,0,0,50), BackgroundTransparency = 1, Parent = self.Root })
    local b = mk("TextButton", { Size = UDim2.new(1,0,1,0), BackgroundColor3 = Color3.fromRGB(30,30,40), Text = string.format("%s (Current: %s)", tostring(text or "Keybind"), defaultKeyName or "E"), TextColor3 = Color3.fromRGB(255,255,255), Font = Enum.Font.GothamMedium, TextSize = 16, Parent = f })
    uiCorner(b,8); local s = uiStroke(b,1,Color3.fromRGB(0,170,255),0.7)
    b.MouseEnter:Connect(function() tween(b,nil,{BackgroundColor3 = Color3.fromRGB(40,40,50)}); s.Transparency = 0.3 end)
    b.MouseLeave:Connect(function() tween(b,nil,{BackgroundColor3 = Color3.fromRGB(30,30,40)}); s.Transparency = 0.7 end)

    local listening = false
    local current = Enum.KeyCode[defaultKeyName or "E"] or Enum.KeyCode.E

    b.MouseButton1Click:Connect(function()
        listening = true
        b.Text = "PRESS ANY KEY..."
        b.BackgroundColor3 = Color3.fromRGB(0,100,150)
    end)

    UserInputService.InputBegan:Connect(function(input, gp)
        if listening and not gp and input.UserInputType == Enum.UserInputType.Keyboard then
            current = input.KeyCode
            b.Text = string.format("%s (Current: %s)", tostring(text or "Keybind"), current.Name)
            b.BackgroundColor3 = Color3.fromRGB(30,30,40)
            listening = false
            if cb then task.spawn(cb, current) end
        end
    end)

    local api = {}
    function api:Get() return current end
    function api:Set(keyName) local kc = Enum.KeyCode[keyName]; if kc then current = kc; b.Text = string.format("%s (Current: %s)", tostring(text or "Keybind"), current.Name) end end
    return api
end

-- =========
-- Key Layer
-- =========
function Window:AttachKeySystem(config)
    config = config or {}
    local title = config.title or "Key System"
    local keyFile = config.keyFile or "Lucent_Key.txt"
    local check = type(config.check) == "function" and config.check or function() return true end
    local onSuccess = type(config.onSuccess) == "function" and config.onSuccess or function() end
    local onFailure = type(config.onFailure) == "function" and config.onFailure or function() end
    local saveByDefault = config.saveByDefault ~= false

    -- Gray overlay
    local overlay = mk("Frame", {Size = UDim2.new(1,0,1,0), BackgroundColor3 = Color3.fromRGB(0,0,0), BackgroundTransparency = 0.35, Parent = self.Gui, ZIndex = 200})
    -- Key panel
    local panel = mk("Frame", { Size = isMobile() and UDim2.new(0.9,0,0,220) or UDim2.new(0,420,0,220), Position = UDim2.new(0.5,0,0.5,0), AnchorPoint = Vector2.new(0.5,0.5), BackgroundColor3 = Color3.fromRGB(15,15,20), ZIndex = 201, Parent = overlay })
    uiCorner(panel,10); uiStroke(panel,2,Color3.fromRGB(0,170,255),0.25)
    mk("TextLabel", { Size = UDim2.new(1,0,0,36), Text = string.upper(title), Font = Enum.Font.GothamBlack, TextColor3 = Color3.fromRGB(0,170,255), TextSize = 20, BackgroundTransparency = 1, Parent = panel })

    local keyBox = mk("TextBox", { Size = UDim2.new(0.9,0,0,40), Position = UDim2.new(0.05,0,0,50), BackgroundColor3 = Color3.fromRGB(30,30,40), PlaceholderText = "Enter key", TextColor3 = Color3.fromRGB(255,255,255), Font = Enum.Font.Gotham, TextSize = 16, ClearTextOnFocus = false, Parent = panel })
    uiCorner(keyBox,8); uiStroke(keyBox,1,Color3.fromRGB(0,170,255),0.7)

    local saveToggle = mk("TextButton", { Size = UDim2.new(0,60,0,30), Position = UDim2.new(0.05,0,0,100), BackgroundColor3 = saveByDefault and Color3.fromRGB(0,100,0) or Color3.fromRGB(40,40,50), AutoButtonColor = false, Text = "", Parent = panel })
    uiCorner(saveToggle,15)
    local knob = mk("Frame", { Size = UDim2.new(0,26,0,26), Position = saveByDefault and UDim2.new(1,-28,0.5,-13) or UDim2.new(0,2,0.5,-13), BackgroundColor3 = saveByDefault and Color3.fromRGB(0,255,0) or Color3.fromRGB(255,255,255), Parent = saveToggle }); uiCorner(knob,13)
    local saveLbl = mk("TextLabel", { Size = UDim2.new(0,200,0,30), Position = UDim2.new(0, 75, 0, 100), Text = "Save key", TextColor3 = Color3.fromRGB(255,255,255), Font = Enum.Font.GothamMedium, TextSize = 16, BackgroundTransparency = 1, TextXAlignment = Enum.TextXAlignment.Left, Parent = panel })
    local saveState = saveByDefault

    local enterBtn = mk("TextButton", { Size = UDim2.new(0.9,0,0,40), Position = UDim2.new(0.05,0,0,150), BackgroundColor3 = Color3.fromRGB(88,101,242), Text = "ENTER", TextColor3 = Color3.fromRGB(255,255,255), Font = Enum.Font.GothamBold, TextSize = 18, Parent = panel })
    uiCorner(enterBtn,8); local enterStroke = uiStroke(enterBtn,1,Color3.fromRGB(255,255,255),0.5)

    -- Load saved key (autofill but DON'T auto-validate)
    if safe_isfile(keyFile) then
        local saved = safe_readfile(keyFile)
        if saved and #tostring(saved) > 0 then keyBox.Text = tostring(saved) end
    end

    local function setSave(v)
        saveState = not not v
        if saveState then
            tween(knob, TweenInfo.new(0.2), { Position = UDim2.new(1,-28,0.5,-13), BackgroundColor3 = Color3.fromRGB(0,255,0) })
            tween(saveToggle, TweenInfo.new(0.2), { BackgroundColor3 = Color3.fromRGB(0,100,0) })
        else
            tween(knob, TweenInfo.new(0.2), { Position = UDim2.new(0,2,0.5,-13), BackgroundColor3 = Color3.fromRGB(255,255,255) })
            tween(saveToggle, TweenInfo.new(0.2), { BackgroundColor3 = Color3.fromRGB(40,40,50) })
        end
    end
    saveToggle.MouseButton1Click:Connect(function() setSave(not saveState) end)

    local function tryEnter()
        local key = tostring(keyBox.Text or "")
        if #key == 0 then
            self:Notify("Key", "Please enter a key.", Color3.fromRGB(255, 120, 120))
            return
        end
        local ok = false
        local success, result = pcall(function() return check(key) end)
        ok = success and result
        if ok then
            if saveState then safe_writefile(keyFile, key) end
            tween(overlay, TweenInfo.new(0.2), { BackgroundTransparency = 1 })
            task.delay(0.21, function() overlay:Destroy() end)
            self:Notify("Key", "Key accepted!", Color3.fromRGB(0,255,0))
            onSuccess(key)
        else
            self:Notify("Key", "Invalid key.", Color3.fromRGB(255,120,120))
            onFailure()
        end
    end

    enterBtn.MouseButton1Click:Connect(tryEnter)
    keyBox.FocusLost:Connect(function(enter) if enter then tryEnter() end end) -- requires pressing Enter on keyboard
end

-- Expose constructor
function Lib.new() local o=setmetatable({}, Lib); return o end
function Lib:CreateWindow(...) return Lib.new():CreateWindow(...) end

return setmetatable({}, {__index = Lib})
