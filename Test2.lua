local player = game.Players.LocalPlayer
local players = game:GetService("Players")
local runService = game:GetService("RunService")

-- Create ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ESP_GUI_Mobile"
screenGui.ResetOnSpawn = false
screenGui.Parent = player:WaitForChild("PlayerGui")

-- Helper: add neon border lines (purple)
local function addNeonBorder(frame, thickness)
thickness = thickness or 2
local color = Color3.fromRGB(200, 0, 255)
local top = Instance.new("Frame")
top.Size = UDim2.new(1, 0, 0, thickness)
top.BackgroundColor3 = color
top.BorderSizePixel = 0
top.Parent = frame

```
local bottom = Instance.new("Frame")
bottom.Size = UDim2.new(1, 0, 0, thickness)
bottom.BackgroundColor3 = color
bottom.BorderSizePixel = 0
bottom.Position = UDim2.new(0, 0, 1, -thickness)
bottom.Parent = frame

local left = Instance.new("Frame")
left.Size = UDim2.new(0, thickness, 1, -thickness*2)
left.BackgroundColor3 = color
left.BorderSizePixel = 0
left.Position = UDim2.new(0, 0, 0, thickness)
left.Parent = frame

local right = Instance.new("Frame")
right.Size = UDim2.new(0, thickness, 1, -thickness*2)
right.BackgroundColor3 = color
right.BorderSizePixel = 0
right.Position = UDim2.new(1, -thickness, 0, thickness)
right.Parent = frame
```

end

-- Main menu (large – mobile‑scaled)
local mainMenu = Instance.new("Frame")
mainMenu.Size = UDim2.new(0, 280, 0, 200)   -- slightly smaller for mobile
mainMenu.Position = UDim2.new(0.5, -140, 0.5, -100)
mainMenu.BackgroundColor3 = Color3.new(0, 0, 0)
mainMenu.BackgroundTransparency = 0
mainMenu.BorderSizePixel = 0
mainMenu.ClipsDescendants = true
mainMenu.Active = true
mainMenu.Draggable = true
mainMenu.Parent = screenGui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 12)
corner.Parent = mainMenu
addNeonBorder(mainMenu, 2)

-- Minimize button (top right)
local minBtn = Instance.new("TextButton")
minBtn.Size = UDim2.new(0, 44, 0, 44)   -- mobile touch friendly
minBtn.Position = UDim2.new(1, -50, 0, 5)
minBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
minBtn.Text = "−"
minBtn.TextColor3 = Color3.new(1,1,1)
minBtn.Font = Enum.Font.SourceSansBold
minBtn.TextSize = 30
minBtn.BorderSizePixel = 0
minBtn.Parent = mainMenu

-- ESP button (center)
local espBtn = Instance.new("TextButton")
espBtn.Size = UDim2.new(0, 140, 0, 50)
espBtn.Position = UDim2.new(0.5, -70, 0.5, -25)
espBtn.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
espBtn.Text = "ESP"
espBtn.TextColor3 = Color3.new(1,1,1)
espBtn.Font = Enum.Font.SourceSansBold
espBtn.TextSize = 28
espBtn.BorderSizePixel = 0
espBtn.Parent = mainMenu

-- ESP menu (smaller)
local espMenu = Instance.new("Frame")
espMenu.Size = UDim2.new(0, 200, 0, 150)
espMenu.Position = UDim2.new(0.5, -100, 0.5, -75)
espMenu.BackgroundColor3 = Color3.new(0, 0, 0)
espMenu.BackgroundTransparency = 0
espMenu.BorderSizePixel = 0
espMenu.ClipsDescendants = true
espMenu.Active = true
espMenu.Draggable = true
espMenu.Visible = false
espMenu.Parent = screenGui

local espCorner = Instance.new("UICorner")
espCorner.CornerRadius = UDim.new(0, 12)
espCorner.Parent = espMenu
addNeonBorder(espMenu, 2)

-- Back button (top right)
local backBtn = Instance.new("TextButton")
backBtn.Size = UDim2.new(0, 44, 0, 44)
backBtn.Position = UDim2.new(1, -50, 0, 5)
backBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
backBtn.Text = "←"
backBtn.TextColor3 = Color3.new(1,1,1)
backBtn.Font = Enum.Font.SourceSansBold
backBtn.TextSize = 30
backBtn.BorderSizePixel = 0
backBtn.Parent = espMenu

-- Toggle ESP button (center)
local toggleEspBtn = Instance.new("TextButton")
toggleEspBtn.Size = UDim2.new(0, 140, 0, 50)
toggleEspBtn.Position = UDim2.new(0.5, -70, 0.5, -25)
toggleEspBtn.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
toggleEspBtn.Text = "Open ESP"
toggleEspBtn.TextColor3 = Color3.new(1,1,1)
toggleEspBtn.Font = Enum.Font.SourceSansBold
toggleEspBtn.TextSize = 22
toggleEspBtn.BorderSizePixel = 0
toggleEspBtn.Parent = espMenu

-- States
local espActive = false
local highlightedPlayers = {}
local isMinimized = false
local originalSize = mainMenu.Size

-- Highlight update function
local function updatePlayerHighlight(plr)
if espActive then
local char = plr.Character
if char then
local highlight = Instance.new("Highlight")
highlight.OutlineColor = Color3.new(1,1,1)
highlight.FillColor = Color3.fromRGB(180, 0, 255)
highlight.FillTransparency = 0.5
highlight.OutlineTransparency = 0
highlight.Parent = char
highlightedPlayers[plr] = highlight
end
else
local old = highlightedPlayers[plr]
if old then
old:Destroy()
highlightedPlayers[plr] = nil
end
end
end

local function applyToAll()
for _, plr in ipairs(players:GetPlayers()) do
if plr ~= player then
updatePlayerHighlight(plr)
end
end
end

local function toggleESP()
espActive = not espActive
toggleEspBtn.BackgroundColor3 = espActive and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(80, 80, 80)
toggleEspBtn.Text = espActive and "ESP ON" or "Open ESP"
applyToAll()
end

-- Button connections
espBtn.MouseButton1Click:Connect(function()
mainMenu.Visible = false
espMenu.Visible = true
end)

backBtn.MouseButton1Click:Connect(function()
espMenu.Visible = false
mainMenu.Visible = true
end)

toggleEspBtn.MouseButton1Click:Connect(toggleESP)

minBtn.MouseButton1Click:Connect(function()
isMinimized = not isMinimized
if isMinimized then
mainMenu.Size = UDim2.new(0, 100, 0, 50)
espBtn.Visible = false
minBtn.Text = "+"
else
mainMenu.Size = originalSize
espBtn.Visible = true
minBtn.Text = "−"
end
end)

-- Handle new players
local function onPlayerAdded(plr)
if plr ~= player then
local function onChar(char)
wait(0.2)
if espActive then updatePlayerHighlight(plr) end
end
plr.CharacterAdded:Connect(onChar)
if plr.Character then onChar(plr.Character) end
end
end

players.PlayerAdded:Connect(onPlayerAdded)
for _, plr in ipairs(players:GetPlayers()) do
if plr ~= player then
local function onChar(char)
wait(0.2)
if espActive then updatePlayerHighlight(plr) end
end
plr.CharacterAdded:Connect(onChar)
if plr.Character then onChar(plr.Character) end
end
end

print("Mobile ESP GUI loaded. Touch the buttons to control.")
