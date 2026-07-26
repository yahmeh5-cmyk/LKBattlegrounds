--[[
NEXUS LUCKY BLOCK ADMIN Â· v1.0

LocalScript para o SEU jogo Roblox.
Coloque em StarterPlayer > StarterPlayerScripts.

Usa somente estes remotes conhecidos, sempre com args vazio:
  ReplicatedStorage.SpawnLuckyBlock
  ReplicatedStorage.SpawnSuperBlock
  ReplicatedStorage.SpawnDiamondBlock
  ReplicatedStorage.SpawnRainbowBlock
  ReplicatedStorage.SpawnGalaxyBlock

A interface e responsiva, funciona em mouse e toque, tem botao flutuante,
quantidade, intervalo, fila e cancelamento.
]]

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

if not RunService:IsClient() then return end
local player = Players.LocalPlayer
local guiParent = player:WaitForChild("PlayerGui")

local remotes = {
    ["Lucky Block"] = ReplicatedStorage:WaitForChild("SpawnLuckyBlock"),
    ["Super Block"] = ReplicatedStorage:WaitForChild("SpawnSuperBlock"),
    ["Diamond Block"] = ReplicatedStorage:WaitForChild("SpawnDiamondBlock"),
    ["Rainbow Block"] = ReplicatedStorage:WaitForChild("SpawnRainbowBlock"),
    ["Galaxy Block"] = ReplicatedStorage:WaitForChild("SpawnGalaxyBlock"),
}

local colors = {
    bg = Color3.fromRGB(18, 18, 23), panel = Color3.fromRGB(28, 27, 34),
    card = Color3.fromRGB(42, 39, 50), raised = Color3.fromRGB(57, 52, 67),
    text = Color3.fromRGB(242, 239, 245), sub = Color3.fromRGB(165, 157, 173),
    dim = Color3.fromRGB(108, 101, 117), accent = Color3.fromRGB(244, 159, 99),
    good = Color3.fromRGB(114, 220, 170), bad = Color3.fromRGB(239, 101, 119),
}

local state = {
    open = true, selected = "Lucky Block", amount = 1, interval = 0.5,
    running = false, cancel = false,
}

local function make(class, props)
    local o = Instance.new(class)
    for k, v in pairs(props or {}) do o[k] = v end
    return o
end
local function round(o, n)
    make("UICorner", { CornerRadius = UDim.new(0, n or 8), Parent = o })
end
local function border(o, c)
    return make("UIStroke", { Color = c or colors.raised, Thickness = 1, Parent = o })
end
local function label(parent, value, props)
    local p = { Text = tostring(value), Font = Enum.Font.Gotham, TextSize = 12,
        TextColor3 = colors.text, BackgroundTransparency = 1,
        TextXAlignment = Enum.TextXAlignment.Left, TextYAlignment = Enum.TextYAlignment.Center,
        Parent = parent }
    for k, v in pairs(props or {}) do p[k] = v end
    return make("TextLabel", p)
end
local function button(parent, value, props)
    local p = { Text = tostring(value), Font = Enum.Font.GothamMedium, TextSize = 12,
        TextColor3 = colors.text, BackgroundColor3 = colors.raised,
        BorderSizePixel = 0, AutoButtonColor = false, Parent = parent }
    for k, v in pairs(props or {}) do p[k] = v end
    return make("TextButton", p)
end
local function tween(o, props)
    TweenService:Create(o, TweenInfo.new(.16, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), props):Play()
end

local gui = make("ScreenGui", { Name = "NexusLuckyBlockAdmin", ResetOnSpawn = false,
    IgnoreGuiInset = true, DisplayOrder = 1000, Parent = guiParent })

local window = make("Frame", { Name = "Window", Size = UDim2.fromOffset(390, 390),
    Position = UDim2.new(.5, -195, .5, -195), BackgroundColor3 = colors.bg,
    BorderSizePixel = 0, Parent = gui })
round(window, 14); border(window, Color3.fromRGB(74, 68, 82))
make("UISizeConstraint", { MinSize = Vector2.new(292, 340), MaxSize = Vector2.new(520, 560), Parent = window })

local header = make("Frame", { Size = UDim2.new(1, 0, 0, 58), BackgroundColor3 = colors.panel,
    BorderSizePixel = 0, Parent = window })
round(header, 14)
label(header, "NEXUS", { Position = UDim2.fromOffset(18, 10), Size = UDim2.fromOffset(160, 19),
    Font = Enum.Font.GothamBlack, TextSize = 16 })
label(header, "LUCKY BLOCK ADMIN", { Position = UDim2.fromOffset(18, 30), Size = UDim2.fromOffset(180, 12),
    Font = Enum.Font.Code, TextSize = 9, TextColor3 = colors.dim })
local close = button(header, "Ã—", { Size = UDim2.fromOffset(28, 28), Position = UDim2.new(1, -40, 0, 15),
    BackgroundColor3 = colors.card, TextColor3 = colors.bad, TextSize = 18 })
round(close, 7)

local body = make("ScrollingFrame", { Size = UDim2.new(1, -24, 1, -72), Position = UDim2.fromOffset(12, 66),
    BackgroundTransparency = 1, BorderSizePixel = 0, ScrollBarThickness = 4,
    ScrollBarImageColor3 = colors.raised, CanvasSize = UDim2.new(),
    AutomaticCanvasSize = Enum.AutomaticSize.Y, Parent = window })
make("UIListLayout", { Padding = UDim.new(0, 10), SortOrder = Enum.SortOrder.LayoutOrder, Parent = body })

local function card(title, height)
    local c = make("Frame", { Size = UDim2.new(1, 0, 0, height or 0),
        AutomaticSize = height and Enum.AutomaticSize.None or Enum.AutomaticSize.Y,
        BackgroundColor3 = colors.card, BorderSizePixel = 0, Parent = body })
    round(c, 10); border(c)
    make("UIPadding", { PaddingTop = UDim.new(0, 12), PaddingBottom = UDim.new(0, 12),
        PaddingLeft = UDim.new(0, 12), PaddingRight = UDim.new(0, 12), Parent = c })
    make("UIListLayout", { Padding = UDim.new(0, 8), SortOrder = Enum.SortOrder.LayoutOrder, Parent = c })
    label(c, string.upper(title), { Size = UDim2.new(1, 0, 0, 14), Font = Enum.Font.GothamBold,
        TextSize = 10, TextColor3 = colors.dim, LayoutOrder = 0 })
    return c
end

local selectCard = card("Tipo de lucky block")
local selectedText = label(selectCard, "Selecionada: Lucky Block", { Size = UDim2.new(1, 0, 0, 19),
    TextColor3 = colors.accent, Font = Enum.Font.GothamMedium, LayoutOrder = 1 })
local choices = make("Frame", { Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y,
    BackgroundTransparency = 1, LayoutOrder = 2, Parent = selectCard })
make("UIGridLayout", { CellSize = UDim2.new(.5, -4, 0, 32), CellPadding = UDim2.fromOffset(8, 8), Parent = choices })
for name in pairs(remotes) do
    local b = button(choices, name, { BackgroundColor3 = name == state.selected and colors.accent or colors.raised,
        TextColor3 = name == state.selected and colors.bg or colors.text })
    round(b, 7); border(b)
    b.MouseButton1Click:Connect(function()
        state.selected = name
        selectedText.Text = "Selecionada: " .. name
        for _, child in ipairs(choices:GetChildren()) do
            if child:IsA("TextButton") then child.BackgroundColor3 = child == b and colors.accent or colors.raised; child.TextColor3 = child == b and colors.bg or colors.text end
        end
    end)
end

local amountCard = card("Quantidade e intervalo")
local amountRow = make("Frame", { Size = UDim2.new(1, 0, 0, 36), BackgroundTransparency = 1, Parent = amountCard })
label(amountRow, "Quantidade", { Size = UDim2.new(.5, -8, 1, 0) })
local amountBox = make("TextBox", { Size = UDim2.new(.5, 0, 1, 0), Position = UDim2.new(.5, 0, 0, 0),
    BackgroundColor3 = colors.bg, BorderSizePixel = 0, Text = "1", PlaceholderText = "1",
    TextColor3 = colors.text, Font = Enum.Font.Code, TextSize = 13, ClearTextOnFocus = false,
    TextXAlignment = Enum.TextXAlignment.Center, Parent = amountRow })
round(amountBox, 7); border(amountBox)
local intervalRow = make("Frame", { Size = UDim2.new(1, 0, 0, 36), BackgroundTransparency = 1, Parent = amountCard })
label(intervalRow, "Intervalo (segundos)", { Size = UDim2.new(.5, -8, 1, 0) })
local intervalBox = make("TextBox", { Size = UDim2.new(.5, 0, 1, 0), Position = UDim2.new(.5, 0, 0, 0),
    BackgroundColor3 = colors.bg, BorderSizePixel = 0, Text = "0.5", PlaceholderText = "0.5",
    TextColor3 = colors.text, Font = Enum.Font.Code, TextSize = 13, ClearTextOnFocus = false,
    TextXAlignment = Enum.TextXAlignment.Center, Parent = intervalRow })
round(intervalBox, 7); border(intervalBox)

local actionCard = card("Acoes")
local progress = label(actionCard, "Pronto. Nenhuma block na fila.", { Size = UDim2.new(1, 0, 0, 18),
    TextSize = 10, TextColor3 = colors.sub, LayoutOrder = 1 })
local launch = button(actionCard, "Abrir / spawnar quantidade", { Size = UDim2.new(1, 0, 0, 38),
    BackgroundColor3 = colors.accent, TextColor3 = colors.bg, Font = Enum.Font.GothamBold, LayoutOrder = 2 })
round(launch, 8)
local cancel = button(actionCard, "Cancelar fila", { Size = UDim2.new(1, 0, 0, 30),
    BackgroundColor3 = Color3.fromRGB(65, 35, 43), TextColor3 = colors.bad, LayoutOrder = 3 })
round(cancel, 8)

local noteCard = card("Status")
label(noteCard, "Este menu usa somente os cinco Spawn remotes informados e dispara args vazio. A abertura e a entrega do item continuam sob controle do servidor.", {
    Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, TextSize = 10,
    TextColor3 = colors.sub, TextWrapped = true, TextYAlignment = Enum.TextYAlignment.Top })

local float = button(gui, "N", { Size = UDim2.fromOffset(50, 50), Position = UDim2.new(1, -66, .5, -25),
    BackgroundColor3 = colors.accent, TextColor3 = colors.bg, Font = Enum.Font.GothamBlack, TextSize = 21,
    Active = true, ZIndex = 20 })
round(float, 25); border(float, colors.text)
label(float, "NEXUS", { Position = UDim2.new(0, -12, 1, 3), Size = UDim2.fromOffset(74, 12),
    TextSize = 8, Font = Enum.Font.GothamBold, TextXAlignment = Enum.TextXAlignment.Center, ZIndex = 21 })

local function setOpen(v)
    state.open = v
    window.Visible = v
    float.Visible = not v
end
close.MouseButton1Click:Connect(function() setOpen(false) end)
float.MouseButton1Click:Connect(function() setOpen(true) end)

-- Arrastar janela por toque ou mouse
local drag, start, origin
header.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        drag = true; start = input.Position; origin = window.Position
    end
end)
UIS.InputChanged:Connect(function(input)
    if drag and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local d = input.Position - start
        window.Position = UDim2.new(origin.X.Scale, origin.X.Offset + d.X, origin.Y.Scale, origin.Y.Offset + d.Y)
    end
end)
UIS.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then drag = false end
end)

local function readNumber(box, fallback, min, max)
    local n = tonumber(box.Text) or fallback
    n = math.clamp(n, min, max)
    box.Text = tostring(n)
    return n
end

local function launchQueue()
    if state.running then return end
    state.amount = math.floor(readNumber(amountBox, 1, 1, 100))
    state.interval = readNumber(intervalBox, .5, .1, 30)
    state.running = true; state.cancel = false
    launch.Text = "Fila em andamento..."
    launch.BackgroundColor3 = colors.raised
    task.spawn(function()
        local remote = remotes[state.selected]
        for n = 1, state.amount do
            if state.cancel then break end
            if remote and remote:IsA("RemoteEvent") then
                -- fluxo confirmado pelo usuario: args vazio
                local ok, err = pcall(function() remote:FireServer(table.unpack({})) end)
                if not ok then progress.Text = "Erro no disparo: " .. tostring(err); break end
            end
            progress.Text = "Disparadas " .. n .. "/" .. state.amount .. " - " .. state.selected
            if n < state.amount then task.wait(state.interval) end
        end
        if state.cancel then progress.Text = "Fila cancelada." else progress.Text = "Concluido: " .. state.selected end
        state.running = false; launch.Text = "Abrir / spawnar quantidade"; launch.BackgroundColor3 = colors.accent
    end)
end
launch.MouseButton1Click:Connect(launchQueue)
cancel.MouseButton1Click:Connect(function() state.cancel = true end)
amountBox.FocusLost:Connect(function() readNumber(amountBox, 1, 1, 100) end)
intervalBox.FocusLost:Connect(function() readNumber(intervalBox, .5, .1, 30) end)

UIS.InputBegan:Connect(function(input, processed)
    if processed then return end
    if input.KeyCode == Enum.KeyCode.RightShift then setOpen(not state.open) end
end)

setOpen(true)
