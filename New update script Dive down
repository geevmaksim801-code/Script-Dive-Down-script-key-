-- [[ CONFIG ]]
local CorrectKey = "scriptkey"
local DiscordLink = "https://discord.gg/8qFNay2R"
local SavedBaseCoords = nil
local DivingActive = false 
local MoneyFarmActive = false
local DiveConnection = nil
local BaseRadius = 100 

-- [[ SERVICES ]]
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

-- [[ UI ROOT ]]
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "SigmaPrivate_v21"
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false

-- [[ KEY SYSTEM (Large Font) ]]
local KeyFrame = Instance.new("Frame")
KeyFrame.Size = UDim2.new(0, 420, 0, 240)
KeyFrame.Position = UDim2.new(0.5, -210, 0.5, -120)
KeyFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
KeyFrame.Parent = ScreenGui

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
KeyInput.TextSize = 18
KeyInput.Parent = KeyFrame

local EnterBtn = Instance.new("TextButton")
EnterBtn.Size = UDim2.new(0, 140, 0, 45)
EnterBtn.Position = UDim2.new(0.12, 0, 0.72, 0)
EnterBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 80)
EnterBtn.Text = "SUBMIT"
EnterBtn.Font = Enum.Font.GothamBold
EnterBtn.TextColor3 = Color3.new(1, 1, 1)
EnterBtn.Parent = KeyFrame

-- [[ MAIN MENU ]]
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 520, 0, 380)
MainFrame.Position = UDim2.new(0.3, 0, 0.25, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 15)
MainFrame.Visible = false
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local function CreateBtn(text, pos, color, sizeX)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, sizeX or 200, 0, 45)
    btn.Position = pos
    btn.BackgroundColor3 = color
    btn.Text = text
    btn.Font = Enum.Font.GothamBold
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.TextSize = 13
    btn.Parent = MainFrame
    local corner = Instance.new("UICorner")
    corner.Parent = btn
    return btn
end

local DiveBtn = CreateBtn("FAST DESCENT (-350)", UDim2.new(0.05, 0, 0.18, 0), Color3.fromRGB(0, 100, 200))
local MoneyBtn = CreateBtn("[BETA] MY MONEY ONLY: OFF", UDim2.new(0.05, 0, 0.34, 0), Color3.fromRGB(180, 150, 0))
local SaveBtn = CreateBtn("SAVE BASE POS", UDim2.new(0.05, 0, 0.50, 0), Color3.fromRGB(60, 60, 60))
local ReturnBtn = CreateBtn("RETURN TO BASE", UDim2.new(0.05, 0, 0.66, 0), Color3.fromRGB(150, 40, 40))

-- Avatar Image
local Avatar = Instance.new("ImageLabel")
Avatar.Size = UDim2.new(0, 70, 0, 70)
Avatar.Position = UDim2.new(0.5, 10, 0.15, 0)
Avatar.Image = "rbxassetid://13444002492"
Avatar.BackgroundTransparency = 1
Avatar.Parent = MainFrame

-- Update Log (Credits)
local LogFrame = Instance.new("ScrollingFrame")
LogFrame.Size = UDim2.new(0, 230, 0, 180)
LogFrame.Position = UDim2.new(0.5, 10, 0.35, 0)
LogFrame.BackgroundColor3 = Color3.new(0, 0, 0)
LogFrame.BackgroundTransparency = 0.5
LogFrame.Parent = MainFrame

local LogText = Instance.new("TextLabel")
LogText.Size = UDim2.new(1, -10, 1.5, 0)
LogText.Position = UDim2.new(0, 5, 0, 5)
LogText.Text = "CREDITS:\nScript by: Sigma\n\nUPDATES (v2.1):\n- [FIX] Farm ONLY MY money\n- Added Owner Verification\n- English Buttons Applied\n- Key UI Font Size Up\n- Super Speed Descent"
LogText.TextColor3 = Color3.new(1, 1, 1)
LogText.Font = Enum.Font.GothamMedium
LogText.TextSize = 11
LogText.TextWrapped = true
LogText.BackgroundTransparency = 1
LogText.Parent = LogFrame

-- [[ LOGIC ]]

EnterBtn.MouseButton1Click:Connect(function()
    if KeyInput.Text == CorrectKey then
        KeyFrame.Visible = false
        MainFrame.Visible = true
    end
end)

-- ФУНКЦИЯ СБОРА ТОЛЬКО СВОИХ ДЕНЕГ
MoneyBtn.MouseButton1Click:Connect(function()
    if MoneyFarmActive then
        MoneyFarmActive = false
        MoneyBtn.Text = "[BETA] MY MONEY ONLY: OFF"
        MoneyBtn.BackgroundColor3 = Color3.fromRGB(180, 150, 0)
    else
        if not SavedBaseCoords then
            MoneyBtn.Text = "SAVE BASE FIRST!"
            task.wait(1)
            MoneyBtn.Text = "[BETA] MY MONEY ONLY: OFF"
            return
        end
        
        MoneyFarmActive = true
        MoneyBtn.Text = "[BETA] MY MONEY ONLY: ON"
        MoneyBtn.BackgroundColor3 = Color3.fromRGB(0, 180, 50)
        
        task.spawn(function()
            while MoneyFarmActive do
                local char = LocalPlayer.Character
                local root = char and char:FindFirstChild("HumanoidRootPart")
                
                if root then
                    -- Ищем по всей игре, но проверяем принадлежность
                    for _, obj in pairs(workspace:GetDescendants()) do
                        if not MoneyFarmActive then break end
                        
                        -- Проверка: это монета + она на нашей территории или в нашей папке
                        if obj:IsA("BasePart") and (obj.Name:lower():find("money") or obj.Name:lower():find("coin")) then
                            
                            -- ПРОВЕРКА ВЛАДЕЛЬЦА (Самое важное!)
                            local isMine = false
                            if obj:FindFirstAncestor(LocalPlayer.Name) or (obj:FindFirstAncestor("Plots") and obj:FindFirstAncestor(LocalPlayer.Name)) then
                                isMine = true
                            end
                            
                            -- Если игра хранит владельца в атрибутах
                            if obj:GetAttribute("Owner") == LocalPlayer.Name or obj:GetAttribute("OwnerID") == LocalPlayer.UserId then
                                isMine = true
                            end

                            -- Если нашли именно свое - ТП
                            if isMine then
                                root.CFrame = obj.CFrame
                                task.wait(0.2)
                            end
                        end
                    end
                end
                task.wait(0.5)
            end
        end)
    end
end)

-- Fast Dive (-350)
DiveBtn.MouseButton1Click:Connect(function()
    if DivingActive then
        DivingActive = false
        DiveBtn.Text = "FAST DESCENT (-350)"
        if DiveConnection then DiveConnection:Disconnect() end
        for _, v in pairs(LocalPlayer.Character:GetDescendants()) do
            if v:IsA("BasePart") then v.CanCollide = true end
        end
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
    DivingActive = false
    if SavedBaseCoords then
        LocalPlayer.Character.HumanoidRootPart.CFrame = SavedBaseCoords
    end
end)

UserInputService.InputBegan:Connect(function(i, g)
    if not g and i.KeyCode == Enum.KeyCode.K then MainFrame.Visible = not MainFrame.Visible end
end)
