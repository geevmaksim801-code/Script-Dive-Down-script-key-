-- [[ CONFIG ]]
local CorrectKey = "scriptkey"
local DiscordLink = "https://discord.gg/8qFNay2R"
local SavedBaseCoords = nil
local DivingActive = false 
local MoneyFarmActive = false
local DiveConnection = nil
local FarmRadius = 150 

-- [[ SERVICES ]]
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

-- [[ UI ROOT ]]
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "SigmaRedGlass_v29"
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false

-- [[ MAIN MENU (СОЗДАЕМ ЗАРАНЕЕ, НО СКРЫВАЕМ) ]]
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 520, 0, 380)
MainFrame.Position = UDim2.new(0.5, -260, 0.5, -190)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 0, 0)
MainFrame.BackgroundTransparency = 0.4 
MainFrame.BorderSizePixel = 3
MainFrame.BorderColor3 = Color3.fromRGB(255, 0, 0)
MainFrame.Visible = false
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui
Instance.new("UICorner", MainFrame)

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 50)
Title.Text = "DIVE DOWN PRIVATE 🚀"
Title.TextColor3 = Color3.fromRGB(255, 50, 50)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 22
Title.BackgroundTransparency = 1
Title.Parent = MainFrame

local function CreateBtn(text, pos, color)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 200, 0, 45)
    btn.Position = pos
    btn.BackgroundColor3 = color
    btn.Text = text
    btn.Font = Enum.Font.GothamBold
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.TextSize = 13
    btn.Parent = MainFrame
    Instance.new("UICorner", btn)
    return btn
end

local DiveBtn = CreateBtn("FAST DESCENT (-350)", UDim2.new(0.05, 0, 0.2, 0), Color3.fromRGB(150, 0, 0))
local MoneyBtn = CreateBtn("AUTO FARM (BASE): OFF", UDim2.new(0.05, 0, 0.36, 0), Color3.fromRGB(80, 0, 0))
local SaveBtn = CreateBtn("SAVE BASE POS", UDim2.new(0.05, 0, 0.52, 0), Color3.fromRGB(40, 40, 40))
local ReturnBtn = CreateBtn("RETURN TO BASE", UDim2.new(0.05, 0, 0.68, 0), Color3.fromRGB(200, 0, 0))

local Avatar = Instance.new("ImageLabel")
Avatar.Size = UDim2.new(0, 70, 0, 70)
Avatar.Position = UDim2.new(0.55, 10, 0.12, 0)
Avatar.Image = "rbxassetid://13444002492"
Avatar.BackgroundTransparency = 1
Avatar.Parent = MainFrame

local LogFrame = Instance.new("ScrollingFrame")
LogFrame.Size = UDim2.new(0, 210, 0, 240)
LogFrame.Position = UDim2.new(0.55, 5, 0.3, 0)
LogFrame.BackgroundColor3 = Color3.new(0, 0, 0)
LogFrame.BackgroundTransparency = 0.6
LogFrame.BorderSizePixel = 1
LogFrame.BorderColor3 = Color3.fromRGB(255, 0, 0)
LogFrame.Parent = MainFrame

local LogText = Instance.new("TextLabel")
LogText.Size = UDim2.new(1, -10, 1.5, 0)
LogText.Position = UDim2.new(0, 5, 0, 5)
LogText.Text = "CREDITS:\nBy: Sigma\n\nUPDATES (v2.9):\n- [FIXED] Key UI Auto-Close\n- [FIXED] Layering Issues\n- [NEW] Red Glass v2\n- Farm Radius: 150m\n- Toggle Key: K\n- Private Edition"
LogText.TextColor3 = Color3.fromRGB(255, 200, 200)
LogText.Font = Enum.Font.GothamMedium
LogText.TextSize = 12
LogText.TextWrapped = true
LogText.TextXAlignment = Enum.TextXAlignment.Left
LogText.TextYAlignment = Enum.TextYAlignment.Top
LogText.BackgroundTransparency = 1
LogText.Parent = LogFrame

-- [[ KEY SYSTEM (ИСПРАВЛЕНО ЗАКРЫТИЕ) ]]
local KeyFrame = Instance.new("Frame")
KeyFrame.Size = UDim2.new(0, 420, 0, 240)
KeyFrame.Position = UDim2.new(0.5, -210, 0.5, -120)
KeyFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
KeyFrame.BackgroundTransparency = 0.3
KeyFrame.BorderSizePixel = 2
KeyFrame.BorderColor3 = Color3.fromRGB(255, 0, 0)
KeyFrame.Parent = ScreenGui
Instance.new("UICorner", KeyFrame)

local KeyTitle = Instance.new("TextLabel")
KeyTitle.Size = UDim2.new(1, 0, 0, 50)
KeyTitle.Text = "DIVE DOWN | KEY SYSTEM"
KeyTitle.TextColor3 = Color3.new(1, 1, 1)
KeyTitle.Font = Enum.Font.GothamBold
KeyTitle.TextSize = 22
KeyTitle.BackgroundTransparency = 1
KeyTitle.Parent = KeyFrame

local KeyInput = Instance.new("TextBox")
KeyInput.Size = UDim2.new(0, 320, 0, 50)
KeyInput.Position = UDim2.new(0.5, -160, 0.4, 0)
KeyInput.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
KeyInput.Text = ""
KeyInput.PlaceholderText = "Enter Key..."
KeyInput.TextColor3 = Color3.new(1, 1, 1)
KeyInput.Font = Enum.Font.GothamBold
KeyInput.Parent = KeyFrame

local EnterBtn = Instance.new("TextButton")
EnterBtn.Size = UDim2.new(0, 140, 0, 45)
EnterBtn.Position = UDim2.new(0.12, 0, 0.72, 0)
EnterBtn.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
EnterBtn.Text = "SUBMIT"
EnterBtn.TextColor3 = Color3.new(1, 1, 1)
EnterBtn.Font = Enum.Font.GothamBold
EnterBtn.Parent = KeyFrame
Instance.new("UICorner", EnterBtn)

local GetKeyBtn = Instance.new("TextButton")
GetKeyBtn.Size = UDim2.new(0, 140, 0, 45)
GetKeyBtn.Position = UDim2.new(0.54, 0, 0.72, 0)
GetKeyBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
GetKeyBtn.Text = "GET KEY"
GetKeyBtn.TextColor3 = Color3.new(1, 1, 1)
GetKeyBtn.Font = Enum.Font.GothamBold
GetKeyBtn.Parent = KeyFrame
Instance.new("UICorner", GetKeyBtn)

-- [[ LOGIC ]]

EnterBtn.MouseButton1Click:Connect(function()
    if KeyInput.Text == CorrectKey then
        -- УСПЕШНЫЙ ВХОД
        KeyFrame:Destroy() -- ПОЛНОСТЬЮ УДАЛЯЕМ ОКНО ПАРОЛЯ
        MainFrame.Visible = true
    else
        EnterBtn.Text = "WRONG!"
        task.wait(1)
        EnterBtn.Text = "SUBMIT"
    end
end)

GetKeyBtn.MouseButton1Click:Connect(function()
    if setclipboard then setclipboard(DiscordLink); GetKeyBtn.Text = "COPIED!" task.wait(1) GetKeyBtn.Text = "GET KEY" end
end)

-- АВТОФАРМ
MoneyBtn.MouseButton1Click:Connect(function()
    if MoneyFarmActive then
        MoneyFarmActive = false
        MoneyBtn.Text = "AUTO FARM (BASE): OFF"
        MoneyBtn.BackgroundColor3 = Color3.fromRGB(80, 0, 0)
    else
        if not SavedBaseCoords then
            MoneyBtn.Text = "SAVE BASE FIRST!"
            task.wait(1.5)
            MoneyBtn.Text = "AUTO FARM (BASE): OFF"
            return
        end
        MoneyFarmActive = true
        MoneyBtn.Text = "AUTO FARM (BASE): ON"
        MoneyBtn.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
        
        task.spawn(function()
            while MoneyFarmActive do
                local char = LocalPlayer.Character
                local root = char and char:FindFirstChild("HumanoidRootPart")
                if root then
                    for _, obj in pairs(workspace:GetDescendants()) do
                        if not MoneyFarmActive then break end
                        if obj:IsA("BasePart") and (obj.Name:lower():find("money") or obj.Name:lower():find("coin") or obj.Name:lower():find("cash")) then
                            local distFromBase = (obj.Position - SavedBaseCoords.Position).Magnitude
                            if distFromBase <= FarmRadius then
                                root.CFrame = obj.CFrame
                                task.wait(0.1)
                            end
                        end
                    end
                end
                task.wait(0.3)
            end
        end)
    end
end)

-- БЫСТРЫЙ СПУСК
DiveBtn.MouseButton1Click:Connect(function()
    if DivingActive then
        DivingActive = false
        DiveBtn.Text = "FAST DESCENT (-350)"
        if DiveConnection then DiveConnection:Disconnect() end
    else
        DivingActive = true
        DiveBtn.Text = "STOP DESCENT"
        DiveConnection = RunService.Stepped:Connect(function()
            if not DivingActive then return end
            for _, v in pairs(LocalPlayer.Character:GetDescendants()) do
                if v:IsA("BasePart") then v.CanCollide = false end
            end
            LocalPlayer.Character.HumanoidRootPart.Velocity = Vector3.new(0, -350, 0)
        end)
    end
end)

SaveBtn.MouseButton1Click:Connect(function()
    local root = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if root then
        SavedBaseCoords = root.CFrame
        SaveBtn.Text = "BASE SAVED!"
        task.wait(1)
        SaveBtn.Text = "SAVE BASE POS"
    end
end)

ReturnBtn.MouseButton1Click:Connect(function()
    if SavedBaseCoords then LocalPlayer.Character.HumanoidRootPart.CFrame = SavedBaseCoords end
end)

-- ОТКРЫТИЕ НА K (ТОЛЬКО ПОСЛЕ ПАРОЛЯ)
UserInputService.InputBegan:Connect(function(i, g)
    if not g and i.KeyCode == Enum.KeyCode.K then
        if not ScreenGui:FindFirstChild("KeyFrame") then -- Если окно ключа уже удалено
            MainFrame.Visible = not MainFrame.Visible
        end
    end
end)
