-- Controller System
local System = {}

local Config = getgenv().ControllerConfig or {
    AutoConnect = true,
    URL = 'controller.snipcola.com',
    IPURL = 'https://ip.snipcola.com',
    Logs = false
}

-- Dependencies
local HTTPService = game:GetService('HttpService')

-- Functions
local function DestroyExistingConnection ()
    if getgenv().WebSocket then
        pcall(function()
            getgenv().WebSocket:Close()
            getgenv().WebSocket = nil
        end)
    end
end

DestroyExistingConnection()

local function MergeTables (Table1, Table2)
    local NewTable = {}

    for Index, Value in pairs(Table1) do
        NewTable[Index] = Value
    end

    for Index, Value in pairs(Table2) do
        NewTable[Index] = Value
    end

    return NewTable
end

function System.GetIPAddress ()
    local Response = syn.request({
        Url = Config.IPURL,
        Method = 'GET'
    })

    return Response.Body
end

function System.Connect ()
    DestroyExistingConnection()

    getgenv().WebSocket = syn.websocket.connect(string.format('wss://%s', Config.URL))

    if Config.Logs then
        print('[WS]: Connected!')
    end

    getgenv().WebSocket.OnMessage:Connect(function (Message)
        if Config.Logs then
            print(string.format('[WS]: %s', Message))
        end

        pcall(function()
            local json = HTTPService:JSONDecode(Message)

            if json.action == 'executeCommand' and json.func then
                loadstring(json.func)()(table.unpack(json.args or {}))
            end
        end)
    end)

    getgenv().WebSocket.OnClose:Connect(function ()
        if Config.Logs then
            print('[WS]: Disconnected!')
        end
    end)
end

function System.Disconnect ()
    if getgenv().WebSocket then
        getgenv().WebSocket:Close()
    end
end

local IP = System.GetIPAddress()

function System.SendAction (action, args)
    local Body = HTTPService:JSONEncode(MergeTables({
        ip = IP,
        action = action
    }, args or {}))

    if getgenv().WebSocket then
        getgenv().WebSocket:Send(Body)
    end
end

function System.CreateSession ()
    System.SendAction('createSession')
end

function System.JoinSession ()
    System.SendAction('joinSession')
end

function System.DeleteSession ()
    System.SendAction('deleteSession')
end

function System.FindSession ()
    local Response = syn.request({
        Url = string.format('https://%s/session/%s', Config.URL, IP),
        Method = 'GET'
    })

    local JSON = { success = false }

    pcall(function()
        JSON = HTTPService:JSONDecode(Response.Body)
    end)

    return JSON
end

function System.CreateCommand (Name, Function)
    System.SendAction('createCommand', {
        name = Name,
        func = Function
    })
end

function System.DeleteCommand (Name)
    System.SendAction('deleteCommand', {
        name = Name
    })
end

function System.ExecuteCommand (Name, ...)
    System.SendAction('executeCommand', {
        name = Name,
        args = table.pack(...)
    })
end

-- Auto Connect
if Config.AutoConnect then
    System.Connect()
end

-- Auto Create Session
if Config.AutoCreateSession then
    System.CreateSession()
end

-- Auto Join Session
if Config.AutoJoinSession then
    System.JoinSession()
end

-- Return
getgenv().Controller = System
return System
