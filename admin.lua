-- Loading & Configuration
getgenv().CommandsConfig = {
    Host = 'sniphost1',
    AntiAFK = true
}

loadstring(game:HttpGet('https://raw.githubusercontent.com/snipcola/roblox/main/controller-chat-commands.lua'))()

-- Systems
local Chat = getgenv().ChatSystem
local Commands = getgenv().Commands

Chat.SetPrefix('.');

-- Dependencies
RunService = game:GetService('RunService')
TeleportService = game:GetService('TeleportService')

ReplicatedStorage = game:GetService('ReplicatedStorage')
ChatSystemEvents = ReplicatedStorage.DefaultChatSystemChatEvents

Players = game:GetService('Players')
LocalPlayer = Players.LocalPlayer

-- Functions
function SendMessage (Message)
    ChatSystemEvents.SayMessageRequest:FireServer(Message, 'All')
end

function Teleport (Player)
    local Character = LocalPlayer.Character
    local Character2 = Player.Character

    if Character and Character2 and Character:FindFirstChild('HumanoidRootPart') and Character2:FindFirstChild('HumanoidRootPart') then
        Character.HumanoidRootPart.CFrame = Character2.HumanoidRootPart.CFrame * CFrame.new(0, 0, 2)
    end
end

function TeleportCFrame (CFrame)
    local Character = LocalPlayer.Character

    if Character and Character:FindFirstChild('HumanoidRootPart') then
        Character.HumanoidRootPart.CFrame = CFrame
    end
end

function PlayerChat (Text)
    Players:Chat(Text)
end

function EnablePerformance ()
    RunService:Set3dRenderingEnabled(false)
    RunService:SetRobloxGuiFocused(true)

    setfpscap(10)
end

function DisablePerformance ()
    RunService:Set3dRenderingEnabled(true)
    RunService:SetRobloxGuiFocused(false)

    setfpscap(360)
end

-- Host Commands
Commands.AddHostCommand('hostalive', { 'hosta' }, function ()
    SendMessage(string.format('%s is alive', LocalPlayer.Name))
end)

Commands.AddHostCommand('hostrejoin', { 'hostrj' }, function ()
    local PlaceId = game.PlaceId
    local JobId = game.JobId

    TeleportService:TeleportToPlaceInstance(PlaceId, JobId, LocalPlayer)
end)

-- Commands
Commands.CreateCommand('alive', { 'a' }, [[
    return function ()
        SendMessage(string.format('%s is alive', LocalPlayer.Name))
    end
]])

Commands.CreateCommand('message', { 'say' }, [[
    return function (Args)
        SendMessage(table.concat(Args, ' '))
    end
]])

Commands.CreateCommand('rejoin', { 'rj' }, [[
    return function ()
        local PlaceId = game.PlaceId
        local JobId = game.JobId

        TeleportService:TeleportToPlaceInstance(PlaceId, JobId, LocalPlayer)
    end
]])

Commands.CreateCommand('bring', {}, [[
    return function ()
        Teleport(Players:WaitForChild(getgenv().CommandsConfig.Host))
    end
]])

Commands.CreateCommand('air', {}, [[
    return function ()
        local Character = LocalPlayer.Character
        local RootPart = Character.HumanoidRootPart
        local Position = RootPart.Position

        TeleportCFrame(CFrame.new(Position.X, 50, Position.Z))
        task.wait(.1)
        RootPart.Anchored = true
    end
]])

Commands.CreateCommand('unair', {}, [[
    return function ()
        local Character = LocalPlayer.Character
        local RootPart = Character.HumanoidRootPart

        RootPart.Anchored = false
    end
]])

Commands.CreateCommand('emote', { 'e' }, [[
    return function (Args)
        local Emote = Args[1]

        PlayerChat(string.format('/e %s', Emote))
    end
]])

Commands.CreateCommand('performance', { 'perf' }, [[
    return function (Args)
        EnablePerformance()
    end
]])

Commands.CreateCommand('unperformance', { 'unperf' }, [[
    return function (Args)
        DisablePerformance()
    end
]])

Commands.CreateCommand('join', {}, string.format([[
    return function ()
        TeleportService:TeleportToPlaceInstance('%s', '%s', LocalPlayer)
    end
]], game.PlaceId, game.JobId))
