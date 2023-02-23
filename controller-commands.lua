local Controller = loadstring(game:HttpGet('https://raw.githubusercontent.com/snipcola/roblox/main/controller.lua'))()

-- Command System
local System = {}
local Config = getgenv().CommandsConfig or {}

-- Dependencies
local VirtualUser = game:GetService('VirtualUser')
local Players = game:GetService('Players')
local LocalPlayer = Players.LocalPlayer

-- Functions
local function Idled ()
    VirtualUser:CaptureController()
    VirtualUser:ClickButton2(Vector2.new())
 end

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

function System.CreateCommand (Name, Aliases, Function)
    if System.IsHost() then
        Controller.CreateCommand(Name, Function)

        for _, Alias in pairs(Aliases or {}) do
            Controller.CreateCommand(Alias, Function)
        end
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

-- Anti AFK
if Config.AntiAFK then
    LocalPlayer.Idled:Connect(Idled)
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
