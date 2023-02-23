local Commands = loadstring(game:HttpGet('https://raw.githubusercontent.com/snipcola/roblox/main/controller-commands.lua'))()

-- Chat System
local System = {}

System.Config = getgenv().ChatConfig or {
    Prefix = '.'
}

-- Dependencies
local Players = game:GetService('Players')
local LocalPlayer = Players.LocalPlayer

-- Functions
function System.SetPrefix(Prefix)
    System.Config.Prefix = Prefix
end

function System.OnMessage (Message)
    local Prefix = string.sub(Message, 1, 1)

    if System.Config.Prefix ~= Prefix then
        return
    end

    local Words = Message:split(' ')
    local Name = Words[1]:sub(2)
    
    local Arguments = Words

    table.remove(Arguments, 1)

    local Command = Commands.FindHostCommand(Name)

    if Command == nil then
        Commands.ExecuteCommand(Name, Arguments)
    else
        coroutine.wrap(function ()
            Command.func(Arguments)
        end)()
    end
end

-- Add Chat Event
if Commands.IsHost() and not getgenv().CommandEventsHooked then
    LocalPlayer.Chatted:Connect(System.OnMessage)
    getgenv().CommandEventsHooked = true
end

-- Return
getgenv().ChatSystem = System
return System
