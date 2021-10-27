if _G.Farm then _G.Farm = false return end
_G.Farm = true

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local VirtualUser = game:GetService("VirtualUser")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Remotes = ReplicatedStorage:FindFirstChild("Remotes")
local FarmConnection
local FarmSettings = {
    FarmShapes = true,
    Upgrade = false,
}

LocalPlayer.Idled:Connect(function()
	VirtualUser:Button2Down(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
	task.wait(1)
	VirtualUser:Button2Up(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
end)

FarmConnection = game:GetService("RunService").RenderStepped:Connect(function()
    if not _G.Farm then
        FarmConnection:Disconnect()
    end
    
    if FarmSettings.FarmShapes then
        coroutine.wrap(function()
            local Shapes = workspace:FindFirstChild("CurrentShape")
            
            if Shapes then
                for _, Shape in pairs(Shapes:GetChildren()) do
                    if Shape:IsA("MeshPart") then
                        if Remotes and Remotes:FindFirstChild("Win") and Remotes:FindFirstChild("Award") then
                            Remotes.Win:FireServer(Shape.Name)
                            Remotes.Award:FireServer()
                        end
                    end
                end
            end
        end)()
    end
    
    if FarmSettings.Upgrade then
        coroutine.wrap(function()
            if Remotes:FindFirstChild("Upgrade") then
                Remotes.Upgrade:FireServer("Multiplier")
                Remotes.Upgrade:FireServer("Rate")
                Remotes.Upgrade:FireServer("Multiplier")
            end
            
            if Remotes:FindFirstChild("GetUpgrade") then
                Remotes.GetUpgrade:InvokeServer("Doll")
            end
        end)()
    end
end)
