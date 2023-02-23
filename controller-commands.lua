local Controller = getgenv().Controller or loadstring(game:HttpGet("https://raw.githubusercontent.com/snipcola/roblox/main/controller.lua"))()

-- Command System
local System = {}
local Config = getgenv().CommandsConfig or {}

-- Dependencies
local Players = game:GetService('Players')
local LocalPlayer = Players.LocalPlayer

-- Functions
function System.IsHost ()
    return LocalPlayer.Name == Config.Host
end

function System.SessionExists ()
    local Session = Controller.FindSession()

    return Session.success or false
end

function System.GetCommands ()
    local Session = Controller.FindSession()

    return Session.commands or {}
end

function System.ExecuteCommand (Name, ...)
    if System.IsHost() then
        Controller.ExecuteCommand(Name, ...)
    end
end

function System.CreateCommand (Name, Function)
    if System.IsHost() then
        Controller.CreateCommand(Name, Function)
    end
end

function System.DeleteCommand (Name)
    if System.IsHost() then
        Controller.DeleteCommand(Name)
    end
end

function System.WaitForSession ()
    while not System.SessionExists() do
        task.wait(1)
    end
end

-- Create or Join Session
if System.IsHost() then
    Controller.CreateSession()
else
    System.WaitForSession()
    Controller.JoinSession()
end

-- Return
getgenv().Commands = System
return System
