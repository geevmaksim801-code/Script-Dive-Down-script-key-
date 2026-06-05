-- [[ SERVICES ]]
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

-- [[ UI ROOT ]]
local ScreenGui = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui"))
ScreenGui.Name = "LemonElite_v12_CleanStable"
ScreenGui.ResetOnSpawn = false

-- [[ MAIN FRAME ]]
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 350, 0, 490) -- Слегка уменьшил высоту, так как кнопок теперь 4
MainFrame.Position = UDim2.new(0.5, -175, 0.5, -245)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
MainFrame.BackgroundTransparency = 0.35 
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 22)

-- [[ ЭФФЕКТ: ШАРИКИ В САМОМ ВЕРХУ ]]
local BallContainer = Instance.new("Frame", MainFrame)
BallContainer.Size = UDim2.new(1, 0, 0, 15)
BallContainer.Position = UDim2.new(0, 0, 0.012, 0)
BallContainer.BackgroundTransparency = 1
BallContainer.ClipsDescendants = true

local function CreateMovingBall(delayTime)
    local ball = Instance.new("Frame", BallContainer)
    ball.Size = UDim2.new(0, 8, 0, 8)
    ball.BackgroundColor3 = Color3.fromRGB(255, 255, 0)
    ball.Position = UDim2.new(-0.1, 0, 0.5, -4)
    Instance.new("UICorner", ball).CornerRadius = UDim.new(1, 0)
    
    task.spawn(function()
        task.wait(delayTime)
        while true do
            ball.Position = UDim2.new(-0.1, 0, 0.5, -4)
            ball:TweenPosition(UDim2.new(1.1, 0, 0.5, -4), "Out", "Linear", 2.2)
            task.wait(2.2)
        end
    end)
end
for i = 1, 5 do CreateMovingBall(i * 0.5) end

-- [[ TITLE ]]
local Title = Instance.new("TextLabel", MainFrame)
Title.Size = UDim2.new(1, 0, 0, 45)
Title.Position = UDim2.new(0, 0, 0.04, 0)
Title.Text = "sell lemons [v1.2 dev]"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 20
Title.BackgroundTransparency = 1

-- [[ ПАЛОЧКА ПОД НАЗВАНИЕМ ]]
local Divider = Instance.new("Frame", MainFrame)
Divider.Size = UDim2.new(0.85, 0, 0, 2)
Divider.Position = UDim2.new(0.075, 0, 0, 58)
Divider.BackgroundColor3 = Color3.fromRGB(255, 255, 0)
Divider.BorderSizePixel = 0

-- [[ CONTAINER FOR STUFF ]]
local ContentFrame = Instance.new("Frame", MainFrame)
ContentFrame.Size = UDim2.new(1, 0, 1, -65)
ContentFrame.Position = UDim2.new(0, 0, 0, 65)
ContentFrame.BackgroundTransparency = 1

-- [[ UI BUTTON CREATOR ]]
local function CreateBtn(text, pos)
    local btn = Instance.new("TextButton", ContentFrame)
    btn.Size = UDim2.new(0, 290, 0, 38)
    btn.Position = pos
    btn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    btn.BackgroundTransparency = 0.88
    btn.Text = text
    btn.Font = Enum.Font.GothamMedium
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.TextSize = 13
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 10)
    return btn
end

-- [[ КНОПКИ (4 СТАБИЛЬНЫЕ ФУНКЦИИ) ]]
local NoclipBtn = CreateBtn("Noclip: OFF", UDim2.new(0.08, 0, 0.02, 0))
local JumpBtn = CreateBtn("Infinite Jump: OFF", UDim2.new(0.08, 0, 0.11, 0))
local SpeedBtn = CreateBtn("Loop Walkspeed: OFF", UDim2.new(0.08, 0, 0.20, 0))
local AutoBuyBtn = CreateBtn("Auto Buy Everything: OFF", UDim2.new(0.08, 0, 0.29, 0))

-- [[ ЖУРНАЛ ОБНОВЛЕНИЙ ]]
local LogFrame = Instance.new("Frame", ContentFrame)
LogFrame.Size = UDim2.new(0, 290, 0, 170)
LogFrame.Position = UDim2.new(0.08, 0, 0.45, 0)
LogFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
LogFrame.BackgroundTransparency = 0.3
Instance.new("UICorner", LogFrame).CornerRadius = UDim.new(0, 12)

local LogTitle = Instance.new("TextLabel", LogFrame)
LogTitle.Size = UDim2.new(1, 0, 0, 25)
LogTitle.Text = "— DEV CHANGE LOG v1.2 CLEAN —"
LogTitle.TextColor3 = Color3.fromRGB(255, 255, 0)
LogTitle.Font = Enum.Font.GothamBold
LogTitle.TextSize = 12
LogTitle.BackgroundTransparency = 1

local LogText = Instance.new("TextLabel", LogFrame)
LogText.Size = UDim2.new(0.9, 0, 0.8, 0)
LogText.Position = UDim2.new(0.05, 0, 0.18, 0)
LogText.Text = "* Removed unstable Click TP Tool modules\n" ..
               "* Restored full Developer Change Log window\n" ..
               "* Saved stable Infinite Jump thread\n" ..
               "* Saved Noclip logic (bypass walls effortlessly)\n" ..
               "* Speed hack remains locked at 60 WalkSpeed\n" ..
               "* Auto Buy Everything works completely lag-free"
LogText.TextColor3 = Color3.fromRGB(220, 220, 220)
LogText.Font = Enum.Font.Gotham
LogText.TextSize = 11
LogText.TextXAlignment = Enum.TextXAlignment.Left
LogText.TextYAlignment = Enum.TextYAlignment.Top
LogText.BackgroundTransparency = 1

-- [[ LOGIC VARIABLES ]]
local NoclipActive, JumpActive, SpeedActive, AutoBuyActive = false, false, false, false

-- [[ КНОПКИ УПРАВЛЕНИЯ ]]
NoclipBtn.MouseButton1Click:Connect(function()
    NoclipActive = not NoclipActive
    NoclipBtn.Text = NoclipActive and "Noclip: ACTIVE" or "Noclip: OFF"
    NoclipBtn.TextColor3 = NoclipActive and Color3.fromRGB(255, 255, 0) or Color3.new(1, 1, 1)
end)

JumpBtn.MouseButton1Click:Connect(function()
    JumpActive = not JumpActive
    JumpBtn.Text = JumpActive and "Infinite Jump: ACTIVE" or "Infinite Jump: OFF"
    JumpBtn.TextColor3 = JumpActive and Color3.fromRGB(255, 255, 0) or Color3.new(1, 1, 1)
end)

SpeedBtn.MouseButton1Click:Connect(function()
    SpeedActive = not SpeedActive
    SpeedBtn.Text = SpeedActive and "Loop Walkspeed: ACTIVE" or "Loop Walkspeed: OFF"
    SpeedBtn.TextColor3 = SpeedActive and Color3.fromRGB(255, 255, 0) or Color3.new(1, 1, 1)
end)

AutoBuyBtn.MouseButton1Click:Connect(function()
    AutoBuyActive = not AutoBuyActive
    AutoBuyBtn.Text = AutoBuyActive and "Auto Buy Everything: ACTIVE" or "Auto Buy Everything: OFF"
    AutoBuyBtn.TextColor3 = AutoBuyActive and Color3.fromRGB(255, 255, 0) or Color3.new(1, 1, 1)
end)

-- [[ БЕСКОНЕЧНЫЙ ПРЫЖОК ]]
UserInputService.JumpRequest:Connect(function()
    if JumpActive and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid:ChangeState("Jumping")
    end
end)

-- [[ ПОСТОЯННЫЕ ЦИКЛЫ ФИЗИКИ ]]
RunService.Stepped:Connect(function()
    if not LocalPlayer.Character then return end
    
    if SpeedActive and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.WalkSpeed = 60
    end

    if NoclipActive then
        for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") then part.CanCollide = false end
        end
    end
end)

-- [[ АВТО-ПОКУПКА ЗОН И КНОПОК ]]
task.spawn(function()
    while task.wait(0.5) do
        if AutoBuyActive and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            for _, object in pairs(workspace:GetDescendants()) do
                if not AutoBuyActive then break end
                if object:IsA("TouchTransmitter") and object.Parent then
                    local btn = object.Parent
                    local bName = btn.Name:lower()
                    if bName:find("buy") or bName:find("unlock") or bName:find("gate") or bName:find("button") then
                        firetouchinterest(LocalPlayer.Character.HumanoidRootPart, btn, 0)
                        firetouchinterest(LocalPlayer.Character.HumanoidRootPart, btn, 1)
                    end
                end
            end
        end
    end
end)
