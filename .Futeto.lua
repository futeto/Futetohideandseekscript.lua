local player = game.Players.LocalPlayer
local mouse = player:GetMouse()
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- ESP'yi takip için tablo
local activeESPs = {}

-- UI
local ScreenGui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
local mainFrame = Instance.new("Frame", ScreenGui)
mainFrame.Size = UDim2.new(0, 250, 0, 100)
mainFrame.Position = UDim2.new(0.1, 0, 0.1, 0)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Name = "FutEtoUI"

local title = Instance.new("TextLabel", mainFrame)
title.Size = UDim2.new(1, 0, 0, 20)
title.Text = "FutEto"
title.TextColor3 = Color3.new(1, 1, 1)
title.BackgroundTransparency = 1

-- X Butonu (UI + hile kapat)
local close = Instance.new("TextButton", mainFrame)
close.Text = "X"
close.Size = UDim2.new(0, 25, 0, 25)
close.Position = UDim2.new(1, -30, 0, 5)
close.MouseButton1Click:Connect(function()
    -- ESP'leri sil
    for _, esp in pairs(activeESPs) do
        if esp and esp.Parent then
            esp:Destroy()
        end
    end
    activeESPs = {}
    
    -- Infinite Yield kapatma (tabi çalıştıysa)
    local IY = game.CoreGui:FindFirstChild("InfiniteYield")
    if IY then IY:Destroy() end

    -- UI'yi sil
    ScreenGui:Destroy()
end)

-- - Butonu
local minimize = Instance.new("TextButton", mainFrame)
minimize.Text = "-"
minimize.Size = UDim2.new(0, 25, 0, 25)
minimize.Position = UDim2.new(1, -60, 0, 5)

local isMinimized = false
local miniBar

minimize.MouseButton1Click:Connect(function()
    if not isMinimized then
        mainFrame.Visible = false
        miniBar = Instance.new("TextButton", ScreenGui)
        miniBar.Size = UDim2.new(0, 100, 0, 30)
        miniBar.Position = UDim2.new(0.1, 0, 0.1, 0)
        miniBar.Text = "+"
        miniBar.BackgroundColor3 = Color3.fromRGB(30,30,30)
        miniBar.TextColor3 = Color3.new(1, 1, 1)

        miniBar.MouseButton1Click:Connect(function()
            mainFrame.Visible = true
            miniBar:Destroy()
            isMinimized = false
        end)

        local xMini = Instance.new("TextButton", miniBar)
        xMini.Text = "X"
        xMini.Size = UDim2.new(0, 25, 0, 25)
        xMini.Position = UDim2.new(1, -30, 0, 3)
        xMini.MouseButton1Click:Connect(function()
            ScreenGui:Destroy()
        end)

        isMinimized = true
    end
end)

-- ESP
local espBtn = Instance.new("TextButton", mainFrame)
espBtn.Text = "ESP Aç"
espBtn.Size = UDim2.new(0.8, 0, 0, 25)
espBtn.Position = UDim2.new(0.1, 0, 0.3, 0)

local espEnabled = false
espBtn.MouseButton1Click:Connect(function()
    espEnabled = not espEnabled
    espBtn.Text = espEnabled and "ESP Kapalı" or "ESP Aç"

    if not espEnabled then
        for _, esp in pairs(activeESPs) do
            if esp and esp.Parent then
                esp:Destroy()
            end
        end
        activeESPs = {}
        return
    end

    local function createESP(char)
        local highlight = Instance.new("Highlight")
        highlight.Name = "FutEtoESP"
        highlight.FillTransparency = 0.5
        highlight.OutlineTransparency = 1
        highlight.Adornee = char
        highlight.Parent = char
        table.insert(activeESPs, highlight)
        return highlight
    end

    local function rainbowEffect(esp)
        local hue = 0
        local conn
        conn = RunService.RenderStepped:Connect(function()
            if not espEnabled or not esp or not esp.Parent then
                conn:Disconnect()
                return
            end
            hue = hue + 0.01
            if hue > 1 then hue = 0 end
            esp.FillColor = Color3.fromHSV(hue, 1, 1)
        end)
    end

    for _, plr in pairs(game.Players:GetPlayers()) do
        if plr ~= player and plr.Character then
            local esp = createESP(plr.Character)
            rainbowEffect(esp)
        end
    end

    game.Players.PlayerAdded:Connect(function(plr)
        plr.CharacterAdded:Connect(function(char)
            if espEnabled then
                local esp = createESP(char)
                rainbowEffect(esp)
            end
        end)
    end)
end)

-- Hız Ayarı
local speed = 16
local speedBtn = Instance.new("TextButton", mainFrame)
speedBtn.Text = "Hız: " .. speed
speedBtn.Size = UDim2.new(0.8, 0, 0, 25)
speedBtn.Position = UDim2.new(0.1, 0, 0.6, 0)

local increaseBtn = Instance.new("TextButton", mainFrame)
increaseBtn.Text = ">"
increaseBtn.Size = UDim2.new(0, 25, 0, 25)
increaseBtn.Position = UDim2.new(0.9, -30, 0.6, 0)
increaseBtn.MouseButton1Click:Connect(function()
    speed = speed + 4
    if speed > 500 then speed = 16 end
    speedBtn.Text = "Hız: " .. speed
    if player.Character and player.Character:FindFirstChild("Humanoid") then
        player.Character.Humanoid.WalkSpeed = speed
    end
end)

local decreaseBtn = Instance.new("TextButton", mainFrame)
decreaseBtn.Text = "<"
decreaseBtn.Size = UDim2.new(0, 25, 0, 25)
decreaseBtn.Position = UDim2.new(0.9, -60, 0.6, 0)
decreaseBtn.MouseButton1Click:Connect(function()
    speed = speed - 4
    if speed < 16 then speed = 500 end
    speedBtn.Text = "Hız: " .. speed
    if player.Character and player.Character:FindFirstChild("Humanoid") then
        player.Character.Humanoid.WalkSpeed = speed
    end
end)

-- Sonsuz Yield
loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"))()

print("FutEto UI yüklendi")
