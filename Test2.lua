local player = game.Players.LocalPlayer
local players = game:GetService("Players")
local playerGui = player:WaitForChild("PlayerGui")

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "SimpleESP"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 150, 0, 80)
frame.Position = UDim2.new(0.5, -75, 0.5, -40)
frame.BackgroundColor3 = Color3.new(0, 0, 0)
frame.BackgroundTransparency = 0
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true
frame.Parent = screenGui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 12)
corner.Parent = frame

local function addBorder(f)
local c = Color3.fromRGB(200, 0, 255)
local t = Instance.new("Frame")
t.Size = UDim2.new(1, 0, 0, 2)
t.BackgroundColor3 = c
t.BorderSizePixel = 0
t.Parent = f
local b = Instance.new("Frame")
b.Size = UDim2.new(1, 0, 0, 2)
b.BackgroundColor3 = c
b.BorderSizePixel = 0
b.Position = UDim2.new(0, 0, 1, -2)
b.Parent = f
local l = Instance.new("Frame")
l.Size = UDim2.new(0, 2, 1, -4)
l.BackgroundColor3 = c
l.BorderSizePixel = 0
l.Position = UDim2.new(0, 0, 0, 2)
l.Parent = f
local r = Instance.new("Frame")
r.Size = UDim2.new(0, 2, 1, -4)
r.BackgroundColor3 = c
r.BorderSizePixel = 0
r.Position = UDim2.new(1, -2, 0, 2)
r.Parent = f
end
addBorder(frame)

local label = Instance.new("TextLabel")
label.Size = UDim2.new(1, 0, 0, 30)
label.Position = UDim2.new(0, 0, 0, 5)
label.BackgroundTransparency = 1
label.Text = "ESP OFF"
label.TextColor3 = Color3.new(1, 1, 1)
label.Font = Enum.Font.SourceSansBold
label.TextSize = 18
label.Parent = frame

local toggleBtn = Instance.new("TextButton")
toggleBtn.Size = UDim2.new(0, 100, 0, 35)
toggleBtn.Position = UDim2.new(0.5, -50, 1, -40)
toggleBtn.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
toggleBtn.Text = "Toggle ESP"
toggleBtn.TextColor3 = Color3.new(1, 1, 1)
toggleBtn.Font = Enum.Font.SourceSansBold
toggleBtn.TextSize = 16
toggleBtn.BorderSizePixel = 0
toggleBtn.Parent = frame

local espActive = false
local highlights = {}

local function updatePlayer(plr)
if espActive then
local char = plr.Character
if char then
local h = Instance.new("Highlight")
h.OutlineColor = Color3.new(1, 1, 1)
h.FillColor = Color3.fromRGB(180, 0, 255)
h.FillTransparency = 0.4
h.OutlineTransparency = 0
h.Parent = char
highlights[plr] = h
end
else
local h = highlights[plr]
if h then
h:Destroy()
highlights[plr] = nil
end
end
end

local function refreshAll()
for _, plr in ipairs(players:GetPlayers()) do
if plr ~= player then
updatePlayer(plr)
end
end
end

local function toggleESP()
espActive = not espActive
label.Text = espActive and "ESP ON" or "ESP OFF"
toggleBtn.BackgroundColor3 = espActive and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(80, 80, 80)
refreshAll()
end

toggleBtn.MouseButton1Click:Connect(toggleESP)

local function onPlayerAdded(plr)
if plr == player then return end
local function onChar()
wait(0.2)
if espActive then updatePlayer(plr) end
end
plr.CharacterAdded:Connect(onChar)
if plr.Character then
wait(0.2)
if espActive then updatePlayer(plr) end
end
end

players.PlayerAdded:Connect(onPlayerAdded)

for _, plr in ipairs(players:GetPlayers()) do
if plr ~= player then
local function onChar()
wait(0.2)
if espActive then updatePlayer(plr) end
end
plr.CharacterAdded:Connect(onChar)
if plr.Character then
wait(0.2)
if espActive then updatePlayer(plr) end
end
end
end

print("Simple ESP loaded.")
