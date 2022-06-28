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

if not XAdminVariables then
	getgenv().XAdminVariables = {
		InfiniteStamina = false,
		gameTools = {
			"Baseball Bat",
			"Hammer",
			"Knife",
			"RFID Disruptor",
			"Lockpick",
			"Drill",
			"Flashlight",
			"Scanner"
		},
		moderateActions = {
			"Warning",
			"Kicked",
			"Banned",
			"Other"
		}
	}
end

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

local function addCommand(name, args, func)
	commands[#commands + 1] = { name = name, args = args, func = func }
end

local function executeCommand(commandsString, msgArgs)	
	for _, command in pairs(commands) do
		for _, commandString in pairs(commandsString:split(' ')) do
			if commandString == command.name then
				coroutine.wrap(command.func)(msgArgs)
			end
		end
	end
end

local function findCommand(string)
	for _, command in pairs(commands) do
		if command.name:lower() == string:lower() then
			return command
		end
	end
	
	for _, command in pairs(commands) do
		if startsWith(command.name:lower(), string:lower()) then
			return command
		end
	end

	return false
end

local function getRootPart(player)
	local character = player.Character or player.CharacterAdded:Wait()
	local rootPart = character:FindFirstChild("HumanoidRootPart")
	
	return rootPart or nil
end

local function sendNotification(title, text, duration)
	starterGui:SetCore('SendNotification', {
		Title = title,
		Text = text,
		Duration = duration or 5
	})
end

local function getVehicle(player)
	local vehicles = workspace:FindFirstChild('Vehicles')
	
	if vehicles then
		for _, vehicle in pairs(vehicles:GetChildren()) do
			local controlValues = vehicle:FindFirstChild("Control_Values")
			
			if controlValues then
				local owner = controlValues:FindFirstChild("Owner")

				if owner and owner.Value == player.Name then
					return vehicle
				end
			end
		end
	end
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

addCommand('gettool', {XAdminVariables.gameTools}, function(args)
	local tools = XAdminVariables.gameTools
	local function getTool(tool)
		SendNotification('Tool', tool)
	end
		
	for _, tool in pairs(tools) do
		if tool == args[0] then
			getTool(tool)
		end
	end
		
	for _, tool in pairs(tools) do
		if startsWith(tool, args[0]) then
			getTool(tool)
		end
	end
end)

addCommand('res', {}, function()
	local rootPart = getRootPart(localPlayer)
		
	if rootPart then
		local humanoid = rootPart.Parent:FindFirstChild("Humanoid")
			
		if humanoid then
			humanoid.Health = 0
		end
	end
end)

addCommand('infstamina', {}, function()
	XAdminVariables.InfiniteStamina = true
		
	while task.wait() and XAdminVariables.InfiniteStamina do
		local playerGui = localPlayer:FindFirstChild("PlayerGui")
		
		if playerGui then
			local gameGui = playerGui:FindFirstChild("GameGui")
			
			if gameGui then
				local bottomLeft = gameGui:FindFirstChild("BottomLeft")
				
				if bottomLeft then
					local health = bottomLeft:FindFirstChild("Health")
					
					if health then
						local staminaLS = health:FindFirstChild("Stamina LS")
						
						if staminaLS then
							local stamina = staminaLS:FindFirstChild("Stamina")

							if stamina then
								stamina.Value = 100
							end
						end
					end
				end
			end
		end
	end
end)
	
addCommand('uninfstamina', {}, function()
	XAdminVariables.InfiniteStamina = false
end)

addCommand('tocar', {}, function()
	local vehicle = getVehicle(localPlayer)
	local body = vehicle:FindFirstChild("Body")
	
	if body then
		local base = body:FindFirstChild("Base")
		
		if base then
			local driverSeat = vehicle:FindFirstChild("DriverSeat")
			
			if driverSeat then
				local rootPart = getRootPart(localPlayer)
				local humanoid = rootPart.Parent:FindFirstChild("Humanoid")
				
				if rootPart and humanoid then
					local isSitting = humanoid.Sit

					if isSitting then
						sendNotification('To Car', 'Humanoid is sitting, aborted')
					else
						rootPart.CFrame = base.CFrame + Vector3.new(0, 10, 0) - Vector3.new(0, 0, 2)
						task.wait(.1)
						driverSeat:Sit(humanoid)
					end
				end
			end
		end
	end
end)

addCommand('bringcar', {}, function()
	local vehicle = getVehicle(localPlayer)
	local body = vehicle:FindFirstChild("Body")
	
	if body then
		local base = body:FindFirstChild("Base")
		
		if base then
			local driverSeat = vehicle:FindFirstChild("DriverSeat")
			
			if driverSeat then
				local rootPart = getRootPart(localPlayer)
				local humanoid = rootPart.Parent:FindFirstChild("Humanoid")
				
				if rootPart and humanoid then
					local isSitting = humanoid.Sit

					if isSitting then
						sendNotification('To Car', 'Humanoid is sitting, aborted')
					else
						local originalCFrame = rootPart.CFrame
							
						rootPart.CFrame = base.CFrame + Vector3.new(0, 10, 0) - Vector3.new(0, 0, 2)
						task.wait(.1)
						driverSeat:Sit(humanoid)
						task.wait(.2)
						vehicle:SetPrimaryPartCFrame(originalCFrame)
					end
				end
			end
		end
	end
end)

addCommand('to', {}, function(args)
	local players = game:GetService('Players')
  	local username = args[1]
	local targetPlayer = findPlayer(username, players:GetPlayers())

	if targetPlayer then
		local localRootPart = getRootPart(localPlayer)
		local targetRootPart = getRootPart(targetPlayer)
			
		localRootPart.CFrame = targetRootPart.CFrame
	end
end)

addCommand('m', {nil, XAdminVariables.moderateActions}, function(args)
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

addCommand('ci', {}, function()
    local req = game:HttpGet(config.host .. ':' .. config.port .. '/clockin')
    local res = httpService:JSONDecode(req)

    if res and res.success ~= nil then
      sendNotification('Moderation ' .. ((not res.success) and 'un' or '') .. 'successful', 'This moderation event has' .. ((not res.success) and ' not' or '') .. ' been completed.')
    end
end)

addCommand('co', {}, function()
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
			local args = ui.command.Text:sub(#command.name + 2):split(' ')
			
			toggleGui()
			executeCommand(command.name, args)
		end
	end
end)
