-- Command System
local System = {}
local Config = {
    Prefix = '.'
}

local Commands = {}
local Players = game:GetService('Players')

local LocalPlayer = Players.LocalPlayer

getgenv().WhitelistedPlayers = {
    LocalPlayer.Name
}

local function System.SetWhitelisted (Players)
    getgenv().WhitelistedPlayers = Players
end

local function System.SetPrefix (Prefix)
    Config.Prefix = Prefix
end

local function FindCommand (Name)
    for _, Command in pairs(getgenv().Commands) do
        if Command.name == Name then
            return Command
        elseif table.find(Command.aliases, Name) then
            return Command
        end
    end
end

local function System.AddCommand (name, aliases, func)
    local Command = {
        name = name,
        aliases = aliases,
        func = func
    }

    table.insert(Commands, Command)
end

-- Message System
local function IsWhitelisted (Player)
    local Name = Player.Name

    for _, WhitelistedPlayer in pairs(getgenv().WhitelistedPlayers) do
        if WhitelistedPlayer == Name then
            return true
        end
    end

    return false
end

local function OnMessage (Message)
    local Prefix = string.sub(Message, 1, 1)

    if Config.Prefix ~= Prefix then return end

    local Words = Message:split(' ')
    local Name = Words[1]:sub(2)

    local Command = FindCommand(Name)

    if Command == nil then return end

    local Arguments = Words

    table.remove(Arguments, 1)

    coroutine.wrap(function ()
        Command.func(Arguments)
    end)()
end

local function AddChatEvent (Player)
    if IsWhitelisted(Player) and not getgenv().CommandEventsHooked then
        Player.Chatted:Connect(OnMessage)
    end
end

-- Return
local function System.Initialize ()
    Players.PlayerAdded:Connect(AddChatEvent)

    for _, Player in pairs(Players:GetPlayers()) do
        AddChatEvent(Player)
    end

    getgenv().FollowingPlayer = false
    getgenv().CommandEventsHooked = true
    getgenv().Commands = Commands
end

return System
