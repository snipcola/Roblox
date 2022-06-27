local scriptContext = game:GetService('ScriptContext')

for _, script in pairs(getconnections(scriptContext.Error)) do
  script:Disable()
end

local userInputService = game:GetService('UserInputService')
local players = game:GetService('Players')
local localPlayer = players.LocalPlayer
local coreGui = game:GetService('CoreGui')
local starterGui = game:GetService('StarterGui')
local httpService = game:GetService('HttpService')
local ui = {
	gui = Instance.new('ScreenGui'),
	frame = Instance.new('Frame'),
	corner = Instance.new('UICorner'),
	padding = Instance.new('UIPadding'),
	command = Instance.new('TextBox'),
	placeholder = Instance.new('TextLabel')
}
local commands = {}

if not config then
	getgenv().config = {
		host = 'http://localhost',
		port = '1530'
	}
end

if XAdminGuiName then
	local gui = coreGui:FindFirstChild(XAdminGuiName)

	if gui then
		gui:Destroy()
	end
end

local function randomString(length)
	local characters = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!@#$%^&*()_+-={}|[]`~'
	local characterTable = {}
	local string = ''

	math.randomseed(os.time())

	for character in characters:gmatch('.') do
		table.insert(characterTable, character)
	end

	for _ = 1, length do
		string = string .. characterTable[math.random(1, #characterTable)]
	end

	return string
end

local guiName = randomString(100)

getgenv().XAdminGuiName = guiName

local function toggleGui()
	pcall(function()
		if ui.frame.Visible then
			ui.frame.Position = UDim2.new(0.5, 0, 1, -20)
			ui.frame:TweenPosition(UDim2.new(0.5, 0, 1.5, -20), Enum.EasingDirection.InOut, Enum.EasingStyle.Quint, .25)
			task.wait(.25)
			ui.frame.Visible = false
		else
			ui.frame.Position = UDim2.new(0.5, 0, 1.5, -20)
			ui.frame.Visible = true
			ui.frame:TweenPosition(UDim2.new(0.5, 0, 1, -20), Enum.EasingDirection.InOut, Enum.EasingStyle.Quint, .25)
			ui.command:CaptureFocus()
			task.wait()
			ui.command.Text = ''
			ui.placeholder.Text = ''
		end
	end)
end

local function startsWith(string1, string2)
	return string1:sub(1, #string2) == string2
end

local function findPlayer(playerUsername, players)    
	for _, player in pairs(players) do
		if player ~= localPlayer then
			if player.Name:lower() == playerUsername:lower() then
				return player
			elseif player.DisplayName:lower() == playerUsername:lower() then
				return player
			elseif startsWith(player.Name:lower(), playerUsername:lower()) then
				return player
			elseif player ~= localPlayer and startsWith(player.DisplayName:lower(), playerUsername:lower()) then
				return player
			end
		end
	end

	return false
end

local function addCommand(name, alias, args, func)
	commands[#commands + 1] = { name = name, alias = alias, args = args, func = func }
end

local function executeCommand(commandsString, msgArgs)
	for _, command in pairs(commands) do
		for _, commandString in pairs(commandsString:split(' ')) do
			if commandString == command.name then
				command.func(msgArgs)
			else
				for _, alias in pairs(command.alias) do
					if commandString == alias then
						command.func(msgArgs)
					end
				end
			end
		end
	end
end

local function findCommand(string)
	for _, command in pairs(commands) do
		if startsWith(command.name:lower(), string:lower()) then
			return command
		end
	end

	return false
end

local function sendNotification(title, text, duration)
	starterGui:SetCore('SendNotification', {
		Title = title,
		Text = text,
		Duration = duration or 5
	})
end

ui.gui.Name = guiName
ui.gui.DisplayOrder = 9
ui.gui.ResetOnSpawn = false
ui.gui.Parent = coreGui

ui.frame.Name = randomString(100)
ui.frame.AnchorPoint = Vector2.new(0.5, 1)
ui.frame.BackgroundColor3 = Color3.fromRGB(242, 242, 242)
ui.frame.Size = UDim2.new(0, 500, 0, 30)
ui.frame.Position = UDim2.new(0.5, 0, 1, -20)
ui.frame.ClipsDescendants = true
ui.frame.Visible = false
ui.frame.Parent = ui.gui

ui.corner.Name = randomString(100)
ui.corner.CornerRadius = UDim.new(0, 10)
ui.corner.Parent = ui.frame

ui.padding.PaddingTop = UDim.new(0, 0)
ui.padding.PaddingBottom = UDim.new(0, 0)
ui.padding.PaddingLeft = UDim.new(0, 20)
ui.padding.PaddingRight = UDim.new(0, 20)
ui.padding.Parent = ui.frame

ui.command.Name = randomString(100)
ui.command.AnchorPoint = Vector2.new(0, 0.5)
ui.command.AutomaticSize = Enum.AutomaticSize.XY
ui.command.Position = UDim2.new(0, 0, 0.5, 0)
ui.command.BackgroundTransparency = 1
ui.command.BorderSizePixel = 0
ui.command.Size = UDim2.new(0, 0, 0, 0)
ui.command.Font = Enum.Font.Roboto
ui.command.PlaceholderText = 'Command Here...'
ui.command.Text = ''
ui.command.TextSize = 15
ui.command.TextXAlignment = Enum.TextXAlignment.Left
ui.command.Parent = ui.frame
ui.command.PlaceholderColor3 = Color3.fromRGB(128, 128, 128)
ui.command.FocusLost:Connect(toggleGui)
ui.command:GetPropertyChangedSignal('Text'):Connect(function()
	local args = ui.command.Text:split(' ')
	local command = args[1] and findCommand(args[1])
	local targetPlayer = args[2] and findPlayer(args[2], players:GetPlayers())

	ui.placeholder.Text = ''
	
	if targetPlayer and args[2] ~= '' and not args[3] then ui.placeholder.Text = targetPlayer.Name:sub(args[2]:len() + 1)
	elseif command and args[1] ~= '' and not args[2] then ui.placeholder.Text = command.name:sub(args[1]:len() + 1) end
	
	if command then
		for i, possibleArgs in pairs(command.args) do
			for _, arg in pairs(possibleArgs) do
				if arg and args[i + 1] and args[i + 1] ~= '' and not args[i + 3] and startsWith(arg:lower(), args[i + 1]) then ui.placeholder.Text = arg:sub(args[i + 1]:len() + 1) end
			end
		end
	end

	ui.placeholder.Position = UDim2.new(0, ui.command.TextBounds.X, 0.5, 0)
end)

ui.placeholder.Name = randomString(100)
ui.placeholder.Parent = ui.command
ui.placeholder.Font = Enum.Font.Roboto
ui.placeholder.TextSize = 15
ui.placeholder.TextXAlignment = Enum.TextXAlignment.Left
ui.placeholder.Position = UDim2.new(0, 0, 0.5, 0)
ui.placeholder.AnchorPoint = Vector2.new(0, 0.5)
ui.placeholder.Text = ''
ui.placeholder.TextColor3 = Color3.fromRGB(128, 128, 128)
ui.placeholder.BorderSizePixel = 0

addCommand('moderate', {'m'}, {nil, {"Warning", "Kicked", "Banned", "Other"}}, function(args)
	local players = game:GetService('Players')
  local username, action = table.unpack(args)
	local reason = table.concat(args, ' '):sub(#username + #action + 3)
	local targetPlayer = findPlayer(username, players:GetPlayers())

	if action and reason then
		local req = game:HttpGet(config.host .. ':' .. config.port .. '/moderate/' .. (targetPlayer and targetPlayer.Name or username) .. '/' .. action:gsub("^%l", string.upper) .. '/' .. httpService:UrlEncode(reason))
		local res = httpService:JSONDecode(req)

		if res and res.success ~= nil then
			sendNotification('Moderation ' .. ((not res.success) and 'un' or '') .. 'successful', 'This moderation event has' .. ((not res.success) and ' not' or '') .. ' been logged.')
		end
	end
end)

addCommand('clockin', {'ci'}, {}, function()
    local req = game:HttpGet(config.host .. ':' .. config.port .. '/clockin')
    local res = httpService:JSONDecode(req)

    if res and res.success ~= nil then
      sendNotification('Moderation ' .. ((not res.success) and 'un' or '') .. 'successful', 'This moderation event has' .. ((not res.success) and ' not' or '') .. ' been completed.')
    end
end)

addCommand('clockout', {'co'}, {}, function()
    local req = game:HttpGet(config.host .. ':' .. config.port .. '/clockout')
    local res = httpService:JSONDecode(req)

    if res and res.success ~= nil then
      sendNotification('Moderation ' .. ((not res.success) and 'un' or '') .. 'successful', 'This moderation event has' .. ((not res.success) and ' not' or '') .. ' been completed.')
    end
end)

userInputService.InputBegan:Connect(function(input, onGui)
	if input.UserInputType == Enum.UserInputType.Keyboard then
		if input.KeyCode == Enum.KeyCode.Semicolon and not onGui then toggleGui()
		elseif ui.frame.Visible and input.KeyCode == Enum.KeyCode.Return then
			local text = ui.command.Text:split(' ')[1]
			local command = findCommand(text)
			local args = ui.command.Text:sub(2 + #command.name):split(' ')
			
			toggleGui()
			executeCommand(command.name, args)
		end
	end
end)
