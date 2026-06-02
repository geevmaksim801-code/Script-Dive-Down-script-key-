-- [[ CONFIG ]]
local CorrectKey = "scriptkey"
local DiscordLink = "https://discord.gg/8qFNay2R"
local SavedBaseCoords = nil
local DivingActive = false 
local MoneyFarmActive = false
local DiveConnection = nil

-- [[ SERVICES ]]
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

-- [[ UI ROOT ]]
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "SigmaRelease_v24"
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false

-- [[ KEY SYSTEM ]]
local KeyFrame = Instance.new("Frame")
KeyFrame.Size = UDim2.new(0, 420, 0, 260)
KeyFrame.Position = UDim2.new(0.5, -210, 0.5, -130)
KeyFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
KeyFrame.BorderSizePixel = 0
KeyFrame.Active = true
KeyFrame.Draggable = true
KeyFrame.Parent = ScreenGui

local KeyCorner = Instance.new("UICorner")
KeyCorner.Parent = KeyFrame

local KeyTitle = Instance.new("TextLabel")
KeyTitle.Size = UDim2.new(1, 0, 0, 60)
KeyTitle.Text = "SIGMA | KEY SYSTEM"
KeyTitle.TextColor3 = Color3.new(1, 1, 1)
KeyTitle.Font = Enum.Font.GothamBold
KeyTitle.TextSize = 22
KeyTitle.BackgroundTransparency = 1
KeyTitle.Parent = KeyFrame

local KeyInput = Instance.new("TextBox")
KeyInput.Size = UDim2.new(0, 340, 0, 50)
KeyInput.Position = UDim2.new(0.5, -170, 0.35, 0)
KeyInput.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
KeyInput.Text = ""
KeyInput.PlaceholderText = "Enter Key Here..."
KeyInput.TextColor3 = Color3.new(1, 1, 1)
KeyInput.Font = Enum.Font.GothamBold
KeyInput.TextSize = 18
KeyInput.Parent = KeyFrame

local EnterBtn = Instance.new("TextButton")
EnterBtn.Size = UDim2.new(0, 150, 0, 45)
EnterBtn.Position = UDim2.new(0.1, 0, 0.7, 0)
EnterBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 80)
EnterBtn.Text = "SUBMIT"
EnterBtn.TextColor3 = Color3.new(1, 1, 1)
EnterBtn.Font = Enum.Font.GothamBold
EnterBtn.TextSize = 16
EnterBtn.Parent = KeyFrame

local GetKeyBtn = Instance.new("TextButton")
GetKeyBtn.Size = UDim2.new(0, 150, 0, 45)
GetKeyBtn.Position = UDim2.new(0.55, 0, 0.7, 0)
GetKeyBtn.BackgroundColor3 = Color3.fromRGB(88, 101, 242)
GetKeyBtn.Text = "GET KEY"
GetKeyBtn.TextColor3 = Color3.new(1, 1, 1)
GetKeyBtn.Font = Enum.Font.GothamBold
GetKeyBtn.TextSize = 16
GetKeyBtn.Parent = KeyFrame

-- [[ MAIN MENU ]]
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 500, 0, 350)
MainFrame.Position = UDim2.new(0.5, -250, 0.5, -175)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
MainFrame.Visible = false
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.Parent = MainFrame

local function CreateBtn(text, pos, color, sizeX)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, sizeX or 190, 0, 40)
    btn.Position = pos
    btn.BackgroundColor3 = color
    btn.Text = text
    btn.Font = Enum.Font.GothamBold
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.TextSize = 12
    btn.Parent = MainFrame
    local corner = Instance.new("UICorner")
    corner.Parent = btn
    return btn
end

local DiveBtn = CreateBtn("FAST DESCENT (-350)", UDim2.new(0.05, 0, 0.2, 0), Color3.fromRGB(0, 100, 200))
local MoneyBtn = CreateBtn("MY MONEY FARM: OFF", UDim2.new(0.05, 0, 0.35, 0), Color3.fromRGB(180, 150, 0))
local SaveBtn = CreateBtn("SAVE BASE POS", UDim2.new(0.05, 0, 0.5, 0), Color3.fromRGB(60, 60, 60))
local ReturnBtn = CreateBtn("RETURN TO BASE", UDim2.new(0.05, 0, 0.65, 0), Color3.fromRGB(150, 40, 40))

-- [[ LOGIC ]]

EnterBtn.MouseButton1Click:Connect(function()
    if KeyInput.Text == CorrectKey then
        KeyFrame.Visible = false
        MainFrame.Visible = true
    else
        EnterBtn.Text = "WRONG KEY"
        task.wait(1)
        EnterBtn.Text = "SUBMIT"
    end
end)

GetKeyBtn.MouseButton1Click:Connect(function()
    if setclipboard then
        setclipboard(DiscordLink)
        GetKeyBtn.Text = "LINK COPIED!"
        task.wait(1)
        GetKeyBtn.Text = "GET KEY"
    end
end)

-- Фарм только СВОИХ денег
MoneyBtn.MouseButton1Click:Connect(function()
    if MoneyFarmActive then
        MoneyFarmActive = false
        MoneyBtn.Text = "MY MONEY FARM: OFF"
        MoneyBtn.BackgroundColor3 = Color3.fromRGB(180, 150, 0)
    else
        if not SavedBaseCoords then
            MoneyBtn.Text = "SAVE BASE FIRST!"
            task.wait(1)
            MoneyBtn.Text = "MY MONEY FARM: OFF"
            return
        end
        MoneyFarmActive = true
        MoneyBtn.Text = "MY MONEY FARM: ON"
        MoneyBtn.BackgroundColor3 = Color3.fromRGB(0, 180, 80)
        
        task.spawn(function()
            while MoneyFarmActive do
                local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                if root then
                    for _, obj in pairs(workspace:GetDescendants()) do
                        if not MoneyFarmActive then break end
                        if obj:IsA("BasePart") and (obj.Name:lower():find("money") or obj.Name:lower():find("coin")) then
                            -- Проверяем, что деньги принадлежат нам (по имени папки или атрибуту)
                            if obj:FindFirstAncestor(LocalPlayer.Name) or obj:GetAttribute("Owner") == LocalPlayer.Name then
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

-- Быстрый спуск
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
    if SavedBaseCoords then
        LocalPlayer.Character.HumanoidRootPart.CFrame = SavedBaseCoords
    end
end)

-- Открытие на K
UserInputService.InputBegan:Connect(function(i, g)
    if not g and i.KeyCode == Enum.KeyCode.K then 
        if MainFrame.Visible or KeyFrame.Visible then
            MainFrame.Visible = false
            KeyFrame.Visible = false
        else
            MainFrame.Visible = true
        end
    end
end)
