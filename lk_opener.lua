-- LK BATTLEGROUNDS — Auto Lucky Block Opener
-- Escolha tipo e quantidade. Delta Mobile compatible.

repeat task.wait() until game:IsLoaded() and game:GetService("Players").LocalPlayer

local lp = game:GetService("Players").LocalPlayer
local RS = game:GetService("ReplicatedStorage")

-- Remotes confirmados do jogo
local BLOCKS = {
    {name = "Lucky Block", remote = "SpawnLuckyBlock", color = Color3.fromRGB(255, 200, 50)},
    {name = "Super Block", remote = "SpawnSuperBlock", color = Color3.fromRGB(50, 200, 255)},
    {name = "Diamond Block", remote = "SpawnDiamondBlock", color = Color3.fromRGB(150, 220, 255)},
    {name = "Rainbow Block", remote = "SpawnRainbowBlock", color = Color3.fromRGB(255, 100, 200)},
    {name = "Galaxy Block", remote = "SpawnGalaxyBlock", color = Color3.fromRGB(100, 50, 200)},
}

-- Encontrar remotes que existem
for _, b in ipairs(BLOCKS) do
    b.inst = RS:FindFirstChild(b.remote)
    if b.inst then
        print("[LK] Remote encontrado: " .. b.remote)
    else
        print("[LK] Remote NAO encontrado: " .. b.remote)
    end
end

-- Config
local qty = 10
local delay = 0.1
local total = 0

-- GUI
pcall(function()
    local old = lp.PlayerGui:FindFirstChild("LKOpener")
    if old then old:Destroy() end
end)

local sg = Instance.new("ScreenGui")
sg.Name = "LKOpener"
sg.ResetOnSpawn = false
sg.Parent = lp:WaitForChild("PlayerGui")

-- Toggle button
local mBtn = Instance.new("TextButton")
mBtn.Size = UDim2.new(0, 48, 0, 48)
mBtn.Position = UDim2.new(0, 8, 0.2, 0)
mBtn.BackgroundColor3 = Color3.fromRGB(255, 180, 30)
mBtn.Text = "LK"
mBtn.TextColor3 = Color3.fromRGB(0, 0, 0)
mBtn.Font = Enum.Font.SourceSansBold
mBtn.TextSize = 16
mBtn.BorderSizePixel = 0
mBtn.ZIndex = 200
mBtn.Parent = sg

-- Panel
local panel = Instance.new("Frame")
panel.Name = "Panel"
panel.Size = UDim2.new(0.9, 0, 0.8, 0)
panel.Position = UDim2.new(0.05, 0, 0.1, 0)
panel.BackgroundColor3 = Color3.fromRGB(10, 10, 18)
panel.BorderSizePixel = 0
panel.Visible = false
panel.ZIndex = 50
panel.Parent = sg

-- Title
local tBar = Instance.new("TextLabel")
tBar.Size = UDim2.new(1, 0, 0, 34)
tBar.BackgroundColor3 = Color3.fromRGB(255, 180, 30)
tBar.Text = "  LK Block Opener"
tBar.TextColor3 = Color3.fromRGB(0, 0, 0)
tBar.Font = Enum.Font.SourceSansBold
tBar.TextSize = 14
tBar.TextXAlignment = Enum.TextXAlignment.Left
tBar.BorderSizePixel = 0
tBar.ZIndex = 51
tBar.Parent = panel

-- Close
local xBtn = Instance.new("TextButton")
xBtn.Size = UDim2.new(0, 34, 0, 34)
xBtn.Position = UDim2.new(1, -34, 0, 0)
xBtn.BackgroundTransparency = 1
xBtn.Text = "X"
xBtn.TextColor3 = Color3.fromRGB(100, 0, 0)
xBtn.Font = Enum.Font.SourceSansBold
xBtn.TextSize = 18
xBtn.ZIndex = 52
xBtn.Parent = panel

local isOpen = false
local function toggle()
    isOpen = not isOpen
    panel.Visible = isOpen
    mBtn.Text = isOpen and "X" or "LK"
    mBtn.BackgroundColor3 = isOpen and Color3.fromRGB(200, 50, 50) or Color3.fromRGB(255, 180, 30)
end
mBtn.MouseButton1Click:Connect(toggle)
xBtn.MouseButton1Click:Connect(toggle)

-- Content scroll
local content = Instance.new("ScrollingFrame")
content.Size = UDim2.new(1, -8, 1, -40)
content.Position = UDim2.new(0, 4, 0, 38)
content.BackgroundTransparency = 1
content.BorderSizePixel = 0
content.ScrollBarThickness = 3
content.CanvasSize = UDim2.new(0, 0, 0, 0)
content.AutomaticCanvasSize = Enum.AutomaticSize.Y
content.ZIndex = 51
content.Parent = panel
Instance.new("UIListLayout", content).Padding = UDim.new(0, 4)
local cp = Instance.new("UIPadding", content)
cp.PaddingLeft = UDim.new(0, 6)
cp.PaddingRight = UDim.new(0, 6)
cp.PaddingTop = UDim.new(0, 6)

-- Status label
local statusLbl = Instance.new("TextLabel")
statusLbl.Size = UDim2.new(1, 0, 0, 24)
statusLbl.BackgroundTransparency = 1
statusLbl.Text = "Total spawned: 0"
statusLbl.TextColor3 = Color3.fromRGB(255, 200, 100)
statusLbl.Font = Enum.Font.SourceSansBold
statusLbl.TextSize = 13
statusLbl.ZIndex = 52
statusLbl.Parent = content

-- Quantity control
local qFrame = Instance.new("Frame")
qFrame.Size = UDim2.new(1, 0, 0, 40)
qFrame.BackgroundColor3 = Color3.fromRGB(14, 14, 26)
qFrame.BorderSizePixel = 0
qFrame.ZIndex = 52
qFrame.Parent = content

local qLbl = Instance.new("TextLabel")
qLbl.Size = UDim2.new(0.4, 0, 1, 0)
qLbl.Position = UDim2.new(0, 8, 0, 0)
qLbl.BackgroundTransparency = 1
qLbl.Text = "Qty: " .. qty
qLbl.TextColor3 = Color3.fromRGB(200, 200, 220)
qLbl.Font = Enum.Font.SourceSansBold
qLbl.TextSize = 13
qLbl.TextXAlignment = Enum.TextXAlignment.Left
qLbl.ZIndex = 53
qLbl.Parent = qFrame

local function mkQBtn(txt, x, col, delta)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(0, 40, 0, 30)
    b.Position = UDim2.new(0, x, 0.5, -15)
    b.BackgroundColor3 = col
    b.Text = txt
    b.TextColor3 = Color3.new(1, 1, 1)
    b.Font = Enum.Font.SourceSansBold
    b.TextSize = 16
    b.BorderSizePixel = 0
    b.ZIndex = 53
    b.Parent = qFrame
    b.MouseButton1Click:Connect(function()
        qty = math.clamp(qty + delta, 1, 500)
        qLbl.Text = "Qty: " .. qty
    end)
end

mkQBtn("-10", 120, Color3.fromRGB(80, 20, 20), -10)
mkQBtn("-1", 164, Color3.fromRGB(60, 20, 20), -1)
mkQBtn("+1", 208, Color3.fromRGB(20, 60, 20), 1)
mkQBtn("+10", 252, Color3.fromRGB(20, 80, 20), 10)

-- Delay control
local dFrame = Instance.new("Frame")
dFrame.Size = UDim2.new(1, 0, 0, 34)
dFrame.BackgroundColor3 = Color3.fromRGB(14, 14, 26)
dFrame.BorderSizePixel = 0
dFrame.ZIndex = 52
dFrame.Parent = content

local dLbl = Instance.new("TextLabel")
dLbl.Size = UDim2.new(0.5, 0, 1, 0)
dLbl.Position = UDim2.new(0, 8, 0, 0)
dLbl.BackgroundTransparency = 1
dLbl.Text = "Delay: " .. delay .. "s"
dLbl.TextColor3 = Color3.fromRGB(160, 160, 180)
dLbl.Font = Enum.Font.SourceSans
dLbl.TextSize = 11
dLbl.TextXAlignment = Enum.TextXAlignment.Left
dLbl.ZIndex = 53
dLbl.Parent = dFrame

local function mkDBtn(txt, x, col, delta)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(0, 50, 0, 24)
    b.Position = UDim2.new(0, x, 0.5, -12)
    b.BackgroundColor3 = col
    b.Text = txt
    b.TextColor3 = Color3.new(1, 1, 1)
    b.Font = Enum.Font.SourceSansBold
    b.TextSize = 11
    b.BorderSizePixel = 0
    b.ZIndex = 53
    b.Parent = dFrame
    b.MouseButton1Click:Connect(function()
        delay = math.clamp(delay + delta, 0.01, 2)
        delay = math.floor(delay * 100) / 100
        dLbl.Text = "Delay: " .. delay .. "s"
    end)
end

mkDBtn("Faster", 160, Color3.fromRGB(20, 60, 20), -0.05)
mkDBtn("Slower", 214, Color3.fromRGB(60, 20, 20), 0.05)

-- Section label
local secLbl = Instance.new("TextLabel")
secLbl.Size = UDim2.new(1, 0, 0, 18)
secLbl.BackgroundTransparency = 1
secLbl.Text = "  SELECT BLOCK TYPE:"
secLbl.TextColor3 = Color3.fromRGB(255, 180, 30)
secLbl.Font = Enum.Font.SourceSansBold
secLbl.TextSize = 11
secLbl.TextXAlignment = Enum.TextXAlignment.Left
secLbl.ZIndex = 52
secLbl.Parent = content

-- Block buttons
for _, block in ipairs(BLOCKS) do
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(1, 0, 0, 44)
    b.BackgroundColor3 = Color3.fromRGB(18, 18, 32)
    b.Text = "  " .. block.name .. (block.inst and "" or " (NOT FOUND)")
    b.TextColor3 = block.inst and block.color or Color3.fromRGB(80, 80, 80)
    b.Font = Enum.Font.SourceSansBold
    b.TextSize = 14
    b.TextXAlignment = Enum.TextXAlignment.Left
    b.BorderSizePixel = 0
    b.ZIndex = 52
    b.Parent = content

    b.MouseButton1Click:Connect(function()
        if not block.inst then
            b.Text = "  " .. block.name .. " — NOT FOUND"
            return
        end
        b.Text = "  " .. block.name .. " — OPENING " .. qty .. "x..."
        b.BackgroundColor3 = Color3.fromRGB(40, 40, 20)

        task.spawn(function()
            local success = 0
            for i = 1, qty do
                local ok = pcall(function()
                    block.inst:FireServer()
                end)
                if ok then success = success + 1 end
                total = total + 1
                statusLbl.Text = "Total: " .. total .. " | Last: " .. block.name .. " " .. i .. "/" .. qty
                task.wait(delay)
            end
            b.Text = "  " .. block.name .. " — DONE! " .. success .. "/" .. qty
            b.BackgroundColor3 = Color3.fromRGB(20, 60, 20)
            task.delay(2, function()
                pcall(function()
                    b.Text = "  " .. block.name
                    b.BackgroundColor3 = Color3.fromRGB(18, 18, 32)
                end)
            end)
        end)
    end)
end

-- SPAM ALL button
local spamSec = Instance.new("TextLabel")
spamSec.Size = UDim2.new(1, 0, 0, 14)
spamSec.BackgroundTransparency = 1
spamSec.Text = ""
spamSec.ZIndex = 52
spamSec.Parent = content

local spamBtn = Instance.new("TextButton")
spamBtn.Size = UDim2.new(1, 0, 0, 48)
spamBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 20)
spamBtn.Text = "SPAM ALL BLOCKS x" .. qty
spamBtn.TextColor3 = Color3.new(1, 1, 1)
spamBtn.Font = Enum.Font.SourceSansBold
spamBtn.TextSize = 15
spamBtn.BorderSizePixel = 0
spamBtn.ZIndex = 52
spamBtn.Parent = content

spamBtn.MouseButton1Click:Connect(function()
    spamBtn.Text = "SPAMMING ALL..."
    spamBtn.BackgroundColor3 = Color3.fromRGB(150, 100, 20)

    task.spawn(function()
        for _, block in ipairs(BLOCKS) do
            if block.inst then
                for i = 1, qty do
                    pcall(function() block.inst:FireServer() end)
                    total = total + 1
                    statusLbl.Text = "Total: " .. total .. " | " .. block.name .. " " .. i .. "/" .. qty
                    task.wait(delay)
                end
            end
        end
        spamBtn.Text = "SPAM ALL BLOCKS x" .. qty
        spamBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 20)
    end)
end)

-- Auto-update spam button text when qty changes
task.spawn(function()
    local lastQty = qty
    while true do
        task.wait(0.5)
        if qty ~= lastQty then
            lastQty = qty
            pcall(function() spamBtn.Text = "SPAM ALL BLOCKS x" .. qty end)
        end
    end
end)

-- Open panel automatically
toggle()

print("[LK] Block Opener carregado!")
print("[LK] Toque LK para abrir menu")
