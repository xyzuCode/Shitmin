local cloneref = cloneref or function(...) return end

Services = setmetatable({}, {
	__index = function(self, name)
		local success, cache = pcall(function()
			return cloneref(game:GetService(name))
		end)
		if success then
			rawset(self, name, cache)
			return cache
		end
	end
})

COREGUI = Services.CoreGui
Players = Services.Players

local gui = Instance.new("ScreenGui")
gui.Name = "chatSpy[Shitmin]"
gui.Parent = COREGUI

for v, vv in ipairs(COREGUI:GetChildren()) do
	if vv.Name == gui.Name and vv ~= gui then
		vv:Destroy()
	end
end

local windowFrame = Instance.new("Frame")
windowFrame.Size = UDim2.new(0.38, 0, 0, 210)
windowFrame.Position = UDim2.new(0, 30, 0, 30)
windowFrame.BackgroundColor3 = Color3.fromRGB(245, 245, 245)
windowFrame.BorderSizePixel = 0
windowFrame.Parent = gui

local windowCorner = Instance.new("UICorner")
windowCorner.CornerRadius = UDim.new(0, 10)
windowCorner.Parent = windowFrame

-- 3. Title Bar
local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 30)
titleBar.BackgroundColor3 = Color3.fromRGB(225, 223, 225)
titleBar.BorderSizePixel = 0
titleBar.Parent = windowFrame

local barCorner = Instance.new("UICorner")
barCorner.CornerRadius = UDim.new(0, 10)
barCorner.Parent = titleBar

-- Flatten the bottom corners of the title bar
local overlap = Instance.new("Frame")
overlap.Size = UDim2.new(1, 0, 0, 5)
overlap.Position = UDim2.new(0, 0, 1, -5)
overlap.BackgroundColor3 = titleBar.BackgroundColor3
overlap.BorderSizePixel = 0
overlap.Parent = titleBar

-- 4. THE TITLE TEXT
local windowTitle = Instance.new("TextLabel")
windowTitle.Name = "WindowTitle"
windowTitle.Size = UDim2.new(1, 0, 1, 0)
windowTitle.BackgroundTransparency = 1
windowTitle.Text = "Chat Spy" -- You can change this to your app name
windowTitle.TextColor3 = Color3.fromRGB(75, 75, 75) -- Subtle dark grey
windowTitle.Font = Enum.Font.GothamMedium -- Closest to San Francisco
windowTitle.TextSize = 13
windowTitle.Parent = titleBar

-- 5. Traffic Lights (The 3 Dots)
local buttonContainer = Instance.new("Frame")
buttonContainer.Size = UDim2.new(0, 60, 1, 0)
buttonContainer.Position = UDim2.new(0, 12, 0, 0)
buttonContainer.BackgroundTransparency = 1
buttonContainer.ZIndex = 2 -- Ensures dots are above the title text
buttonContainer.Parent = titleBar

local layout = Instance.new("UIListLayout")
layout.FillDirection = Enum.FillDirection.Horizontal
layout.Padding = UDim.new(0, 8)
layout.VerticalAlignment = Enum.VerticalAlignment.Center
layout.Parent = buttonContainer

local function createMacButton(color, callback)
	local btn = Instance.new("ImageButton")
	btn.Size = UDim2.new(0, 12, 0, 12)
	btn.BackgroundColor3 = color
	btn.BorderSizePixel = 0
	btn.Parent = buttonContainer
	
	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(1, 0)
	corner.Parent = btn
	callback = callback or nil
	btn.MouseButton1Click:connect(callback)
end

createMacButton(Color3.fromRGB(255, 96, 92), function() gui:Destroy() end)    -- Red
createMacButton(Color3.fromRGB(255, 189, 68))   -- Yellow
createMacButton(Color3.fromRGB(0, 202, 78))     -- Green


local ChatLogs = Instance.new("ScrollingFrame")
ChatLogs.Name = "ChatLogs"
ChatLogs.Size = UDim2.new(1, -20, 1, -titleBar.AbsoluteSize.Y -40)
ChatLogs.Position = UDim2.new(0, 10, 0, titleBar.AbsoluteSize.Y +10)
ChatLogs.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
ChatLogs.BorderColor3 = Color3.fromRGB(0, 0, 0)
ChatLogs.BorderSizePixel = 1
ChatLogs.ScrollBarThickness = 1
ChatLogs.ScrollingEnabled = true
ChatLogs.BackgroundTransparency = 1
ChatLogs.Parent = windowFrame

local chatlogs_corner = Instance.new("UICorner")
chatlogs_corner.Name = "chatlogs_corner"
chatlogs_corner.CornerRadius = UDim.new(0, 10)
chatlogs_corner.Parent = ChatLogs

local chatlogs_Stroke = Instance.new("UIStroke")
chatlogs_Stroke.Name = "chatlogs_corner"
chatlogs_Stroke.Color = Color3.fromRGB(75, 75, 75)
chatlogs_Stroke.Thickness = 1
chatlogs_Stroke.Parent = ChatLogs

	local lists = Instance.new("UIListLayout")
lists.Name = "lists"
lists.SortOrder = Enum.SortOrder.LayoutOrder
lists.Padding = UDim.new(0, 1)
lists.HorizontalAlignment = Enum.HorizontalAlignment.Left
lists.VerticalAlignment = Enum.VerticalAlignment.Top
lists.Parent = ChatLogs

lists:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
	ChatLogs.CanvasSize = UDim2.new(0, 0, 0, listLayout.AbsoluteContentSize.Y)
	ChatLogs.CanvasPosition = Vector2.new(0, ChatLogs.AbsoluteCanvasSize.Y)
end)


local btns = Instance.new("Frame")
btns.Name = "btns"
btns.Size = UDim2.new(1, 0, 0, titleBar.AbsoluteSize.Y)
btns.Position = UDim2.new(0, 0, 1, -titleBar.AbsoluteSize.Y)
btns.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
btns.BorderColor3 = Color3.fromRGB(0, 0, 0)
btns.BorderSizePixel = 0
btns.Active = true
btns.BackgroundTransparency = 1
btns.Draggable = true -- allows you to move the frame freely
btns.Parent = windowFrame


	local x_list = Instance.new("UIListLayout")
x_list.Name = "x_list"
x_list.FillDirection = "Horizontal"
x_list.SortOrder = Enum.SortOrder.LayoutOrder
x_list.Padding = UDim.new(0, 5)
x_list.HorizontalAlignment = Enum.HorizontalAlignment.Center
x_list.VerticalAlignment = Enum.VerticalAlignment.Center
x_list.Parent = btns


local tab_btn = Instance.new("TextButton")
tab_btn.Name = "tab_btn"
tab_btn.Size = UDim2.new(0, 0, 0, titleBar.AbsoluteSize.Y-10)
tab_btn.AutomaticSize = "X"
tab_btn.Position = UDim2.new(0, 0, 0, 0)
tab_btn.BackgroundColor3 = Color3.fromRGB(225, 223, 225)
tab_btn.BorderColor3 = Color3.fromRGB(0, 0, 0)
tab_btn.BorderSizePixel = 1
tab_btn.Text = "Clear"
tab_btn.BackgroundTransparency = 0
tab_btn.TextColor3 = Color3.fromRGB(75, 75, 75)
tab_btn.Font = Enum.Font.GothamMedium
tab_btn.Parent = btns
tab_btn.TextSize = 13

local btn_padding = Instance.new("UIPadding")
btn_padding.Name = "btn_padding"
btn_padding.PaddingLeft = UDim.new(0, 10)
btn_padding.PaddingRight = UDim.new(0, 10)
btn_padding.Parent = tab_btn

local btn_corner = Instance.new("UICorner")
btn_corner.Name = "btn_corner"
btn_corner.CornerRadius = UDim.new(0, 10)
btn_corner.Parent = tab_btn

local padding = Instance.new("UIPadding")
padding.Name = "padding"
padding.PaddingTop = UDim.new(0, 3)
padding.PaddingBottom = UDim.new(0, 3)
padding.PaddingLeft = UDim.new(0, 3)
padding.PaddingRight = UDim.new(0, 3)
padding.Parent =ChatLogs

local stored_logs = {}
function addLogs(text)
	local example = Instance.new("TextLabel")
	example.Active = false
	example.Size = UDim2.new(1, 0, 0, 20)
	example.BackgroundTransparency = 1
	example.TextColor3 = Color3.fromRGB(75, 75, 75)
	example.TextXAlignment = Enum.TextXAlignment.Left
	example.Font = Enum.Font.GothamMedium
	example.TextSize = 13
	example.Text = text
	example.AutomaticSize = Enum.AutomaticSize.Y
	example.TextWrapped = true
	example.Parent = ChatLogs
	
	table.insert(stored_logs, example)
end

for _, plr in ipairs(Players:GetPlayers()) do
	plr.Chatted:Connect(function(msg)
		addLogs("[" .. plr.Name .. "] " .. msg)
	end)
end

Players.PlayerAdded:Connect(function(plr)
	plr.Chatted:Connect(function(msg)
		addLogs("[" .. plr.Name .. "] " .. msg)
	end)
end)

tab_btn.MouseButton1Click:Connect(function()
	for _, label in pairs(stored_logs) do
		label:Destroy()
	end
	addLogs("[Chat Spy]: logs cleared")
	table.clear(stored_logs)
end)

local setDragging = loadstring(game:HttpGet(
	"https://raw.githubusercontent.com/xyzuCode/Shitmin/refs/heads/main/UI/setDragging.luau"
))()

setDragging(titleBar, windowFrame)
