repeat task.wait() until game:IsLoaded()

local XLib = loadstring(game:HttpGet('https://raw.githubusercontent.com/snipcola/roblox-scripts/main/xlib.lua', true))()

local TeleportService = game:GetService('TeleportService')

local ReplicatedStorage = game:GetService('ReplicatedStorage')
local rEvents = ReplicatedStorage:WaitForChild('rEvents')

local HttpService = game:GetService('HttpService')

local Players = game:GetService('Players')
local Player = Players.LocalPlayer

local Client1 = Player.Name == Config.Client1
local Client2 = Player.Name == Config.Client2

local Events = {
    Trade = rEvents.tradingEvent
}

local EventVariables = {
    Trade = {
        Send = 'sendTradeRequest',
        Accept = 'requestAccepted',
        Item = 'offerItem',
        AcceptTrade = 'acceptTrade'
    }
}

if _G.Connected then
    XLib.CreateAlert({
        Title = 'Websocket Status',
        Description = 'Already Connected',
        Button1 = {
            Text = 'Dismiss',
            DestroyOnClick = true,
            Color = Color3.fromRGB(255, 0, 0)
        },
        Button2 = {
            Remove = true
        },
        RemoveIn = 5
    })
    return
end

local WebSocket = syn.websocket.connect('ws://localhost:' .. Config.WSPort .. '/')

_G.Connected = true

WebSocket.OnMessage:Connect(function(Message)
    if Message == 'close' then
        WebSocket:Close()
    elseif Client1 and Message == 'ready-1' then
        local TargetPlayer = Players:WaitForChild(Config.Client2)

        Events.Trade:FireServer(EventVariables.Trade.Send, TargetPlayer)

        task.wait(Config.Delay)
        WebSocket:Send('ready-2')
    elseif Client2 and Message == 'ready-2' then
        local TargetPlayer = Players:WaitForChild(Config.Client1)

        Events.Trade:FireServer(EventVariables.Trade.Accept, TargetPlayer)

        task.wait(Config.Delay)
        WebSocket:Send('pets-1')
    elseif Client1 and Message == 'pets-1' then
        local Games = game:HttpGet('https://games.roblox.com/v1/games/' .. game.PlaceId .. '/servers/Public?sortOrder=Asc&limit=' .. tostring(math.random(1) * (10 - 1) + 1) .. ')')
        local GamesJSON = HttpService:JSONDecode(Games)
        local Game = GamesJSON.data[math.random(#GamesJSON.data)]
        local PetsFolder = Player:WaitForChild('petsFolder')
        local Counter = 0

        for _, Folder in pairs(PetsFolder:GetChildren()) do
            for _, Pet in pairs(Folder:GetChildren()) do
                if Counter >= Config.Pet.Amount then
                    break
                elseif Pet.Name == Config.Pet.Name then
                    Counter += 1
                    Events.Trade:FireServer(EventVariables.Trade.Item, Pet)
                end
            end
        end

        Events.Trade:FireServer(EventVariables.Trade.AcceptTrade)
        TeleportService:TeleportToPlaceInstance(game.PlaceId, Game.id)

        WebSocket:Send('accept-2')
    elseif Client2 and Message == 'accept-2' then
        task.wait(Config.Delay)
        Events.Trade:FireServer(EventVariables.Trade.AcceptTrade)

        WebSocket:Send('close-all')
    elseif Debug then
        XLib.CreateAlert({
            Title = 'WebSocket Status',
            Description = 'Message received: ' .. Message,
            Button1 = {
                Remove = true
            },
            RemoveIn = 1
        })
    end
end)

WebSocket.OnClose:Connect(function()
    _G.Connected = false
    XLib.CreateAlert({
        Title = 'WebSocket Status',
        Description = 'Connection Closed',
        Button1 = {
            Remove = true
        },
        RemoveIn = 1
    })
end)

XLib.CreateAlert({
    Title = 'WebSocket Status',
    Description = 'Connection Initiated',
    Button1 = {
        Remove = true
    },
    RemoveIn = 1
})
