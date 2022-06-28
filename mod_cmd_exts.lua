local scriptContext = game:GetService('ScriptContext')

for _, script in pairs(getconnections(scriptContext.Error)) do
  script:Disable()
end

local replicatedStorage = game:GetService('ReplicatedStorage')
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
		UserInputServiceConnection,
		InfiniteStamina = false,
		gameVehicleLocations = {
			["Spawn"] = CFrame.new(-662.1253662109375, 23.474824905395508, 641.8193969726562)
		},
		gameLocations = {
			["Spawn"] = CFrame.new(-678.4291381835938, 23.974824905395508, 762.0128173828125),
			["Car Dealership"] = CFrame.new(-321.2814025878906, 23.974830627441406, 704.4762573242188),
			["Gas 1"] = CFrame.new(-1016.4197998046875, 23.474876403808594, 770.4301147460938),
			["Gas 2"] = CFrame.new(660.5532836914062, 3.4248907566070557, -1502.9072265625),
			["Gas 3"] = CFrame.new(2545.51123046875, -12.1521577835083, -1667.8369140625),
			["Bank Front"] = CFrame.new(-1001.3585815429688, 23.974824905395508, 430.1639099121094),
			["Bank Back"] = CFrame.new(-1122.354248046875, 23.674623489379883, 447.4416198730469),
			["Jewelery Store"] = CFrame.new(-465.13018798828125, 23.974824905395508, -421.19219970703125),
			["Gun Shop"]  = CFrame.new(-1225.400146484375, 24.46483612060547, -189.43653869628906),
			["Tool Store"] = CFrame.new(-433.69927978515625, 24.774852752685547, -710.2664794921875),
			["Mod Shop"] = CFrame.new(-724.5809326171875, 23.474824905395508, 186.442138671875),
			["Fire Department"] = CFrame.new(-1114.415283203125, 23.476028442382812, 118.9657974243164),
			["Hospital Front"] = CFrame.new(-142.38037109375, 23.751134872436523, -430.4136047363281),
			["Hospital Back"] = CFrame.new(-141.86207580566406, 23.474830627441406, -535.7492065429688),
			["Three Guys"] = CFrame.new(-343.96099853515625, 23.47467803955078, -171.7455596923828),
			["Liberty Cafe"] = CFrame.new(-683.9157104492188, 23.974830627441406, 503.2774658203125),
			["Parking 1"] = CFrame.new(-311.9945983886719, 24.174867630004883, 122.81948852539062),
			["Parking 2"] = CFrame.new(2717.137939453125, -12.153314590454102, -2266.29150390625),
			["News"] = CFrame.new(-343.531982421875, 23.974824905395508, 344.9596862792969),
			["Police Back"] = CFrame.new(651.2056884765625, 3.9404656887054443, -139.31932067871094),
			["Police Front"] = CFrame.new(796.5810546875, 3.9404661655426025, -78.71920776367188),
			["Sheriff 1"] = CFrame.new(1453.9732666015625, -11.668456077575684, -1963.669677734375),
			["Sheriff 2"] = CFrame.new(1538.0145263671875, -11.668490409851074, -1916.6688232421875),
			["DOT"] = CFrame.new(1275.442626953125, 3.4252281188964844, 168.31478881835938),
			["County Jail"] = CFrame.new(1341.18408203125, 3.92265248298645, -336.8629150390625),
			["Trailer Park"] = CFrame.new(1203.5413818359375, 3.334216356277466, -983.1029663085938),
			["Farms"] = CFrame.new(840.14111328125, 3.37484073638916, -1139.185791015625),
			["Housing Suburbs"] = CFrame.new(-491.2051696777344, -8.82550048828125, -1478.725830078125),
			["ATM 1"] = CFrame.new(-967.5352783203125, 23.96831703186035, 829.1295166015625),
			["ATM 2"] = CFrame.new(-1018.8355102539062, 24.101520538330078, 442.1720275878906),
			["ATM 3"] = CFrame.new(-486.49755859375, 23.974824905395508, 444.6559143066406),
			["ATM 4"] = CFrame.new(-372.1230163574219, 23.974824905395508, 151.59494018554688),
			["ATM 5"] = CFrame.new(-585.8339233398438, 23.87482452392578, -408.5081787109375),
			["ATM 6"] = CFrame.new(997.2130737304688, 3.9248406887054443, -25.608179092407227),
			["ATM 7"] = CFrame.new(1116.60498046875, 3.924849271774292, 371.0657653808594),
			["ATM 8"] = CFrame.new(720.2720947265625, 3.4248409271240234, -1565.1844482421875),
			["ATM 9"] = CFrame.new(2486.7001953125, -11.653159141540527, -1738.4417724609375),
			["ATM 10"] = CFrame.new(2613.243896484375, -11.653230667114258, -2100.08056640625),
			["ATM 11"] = CFrame.new(2564.28271484375, -11.653286933898926, -2237.84423828125)
		},
		gameTools = {
			["Baseball Bat"] = "Tool Store",
			["Hammer"] = "Tool Store",
			["Knife"] = "Tool Store",
			["RFID Disruptor"] = "Tool Store",
			["Lockpick"] = "Tool Store",
			["Drill"] = "Tool Store",
			["Flashlight"] = "Tool Store",
			["Scanner"] = "Tool Store",
			["Ammo Box"] = "Gun Shop"
		},
		moderateActions = {
			"Warning",
			"Kicked",
			"Banned",
			"Other"
		}
	}
elseif XAdminVariables.UserInputServiceConnection then
	XAdminVariables.UserInputServiceConnection:Disconnect()
	XAdminVariables.UserInputServiceConnection = nil
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
			ui.frame:TweenPosition(UDim2.new(0.5, 0, -0.5, 20), Enum.EasingDirection.InOut, Enum.EasingStyle.Quint, .25)
			task.wait(.25)
			ui.frame.Visible = false
		else
			ui.frame.Position = UDim2.new(0.5, 0, -0.5, 20)
			ui.frame.Visible = true
			ui.frame:TweenPosition(UDim2.new(0.5, 0, 0, 20), Enum.EasingDirection.InOut, Enum.EasingStyle.Quint, .25)
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
				break
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

local function teleportPlayer(player, cframe)
	local rootPart = getRootPart(player)
	
	if rootPart then
		for _ = 1, 5, 1 do
			rootPart.CFrame = cframe
			task.wait(.1)
		end
	end
end

local function teleportObject(object, cframe)
	for _ = 1, 5, 1 do
		object.CFrame = cframe
		task.wait(.1)
	end
end

ui.gui.Name = guiName
ui.gui.DisplayOrder = 9
ui.gui.ResetOnSpawn = false
ui.gui.Parent = coreGui

ui.frame.Name = randomString(100)
ui.frame.AnchorPoint = Vector2.new(0.5, 1)
ui.frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
ui.frame.Transparency = .6
ui.frame.Size = UDim2.new(0, 500, 0, 30)
ui.frame.Position = UDim2.new(0.5, 0, 0, 20)
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
ui.command.TextColor3 = Color3.fromRGB(255, 255, 255)
ui.command.PlaceholderColor3 = Color3.fromRGB(200, 200, 200)
ui.command.FocusLost:Connect(toggleGui)
ui.command:GetPropertyChangedSignal('Text'):Connect(function()
	local args = ui.command.Text:split(' ')
	local command = args[1] and findCommand(args[1])
	local targetPlayer = args[2] and findPlayer(args[2], players:GetPlayers())

	ui.placeholder.Text = ''
	
	if targetPlayer and args[2] ~= '' and not args[3] then ui.placeholder.Text = targetPlayer.Name:sub(args[2]:len() + 1):lower()
	elseif command and args[1] ~= '' and not args[2] then ui.placeholder.Text = command.name:sub(args[1]:len() + 1):lower() end
	
	if command then
		for i, possibleArgs in pairs(command.args) do
			for _, arg in pairs(possibleArgs) do
				if arg and args[i + 1] and args[i + 1] ~= '' and not args[i + 3] and startsWith(arg:lower(), args[i + 1]) then ui.placeholder.Text = arg:sub(args[i + 1]:len() + 1):lower() end
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

local locationIndexes = {}

for location, _ in pairs(XAdminVariables.gameLocations) do
	table.insert(locationIndexes, location)
end

addCommand('tol', {locationIndexes}, function(args)
	local locations = XAdminVariables.gameLocations
	local text = table.concat(args, " ")
		
	for location, cframe in pairs(locations) do
		if location:lower() == text:lower() then
			teleportPlayer(localPlayer, cframe)
			break
		end
	end
		
	for location, cframe in pairs(locations) do
		if startsWith(location:lower(), text:lower()) then
			teleportPlayer(localPlayer, cframe)
			break
		end
	end
end)

local toolsIndexes = {}

for tool, _ in pairs(XAdminVariables.gameTools) do
	table.insert(toolsIndexes, tool)
end

addCommand('gettool', {toolsIndexes}, function(args)
	local tools = XAdminVariables.gameTools
	local text = table.concat(args, " ")
	
	local function getTool(tool, location)
		local locationCFrame = XAdminVariables.gameLocations[location]
			
		if locationCFrame then
			local fe = replicatedStorage:FindFirstChild("FE")
				
			if fe then
				local rootPart = getRootPart(localPlayer)
				local buyGear = fe:FindFirstChild("BuyGear")
					
				if rootPart and buyGear then
					local originalCFrame = rootPart.CFrame
						
					teleportPlayer(localPlayer, locationCFrame)
						
					buyGear:InvokeServer(tool)
					task.wait(.2)
						
					teleportPlayer(localPlayer, originalCFrame)
				end
			end
		end
	end
		
	for tool, location in pairs(tools) do
		if tool:lower() == text:lower() then
			getTool(tool, location)
			break
		end
	end
		
	for tool, location in pairs(tools) do
		if startsWith(tool:lower(), text:lower()) then
			getTool(tool, location)
			break
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
	
	if vehicle and body then
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
						teleportPlayer(localPlayer, base.CFrame + Vector3.new(0, 10, 0) - Vector3.new(0, 0, 2))
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
	
	if vehicle and body then
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
							
						teleportPlayer(localPlayer, base.CFrame + Vector3.new(0, 10, 0) - Vector3.new(0, 0, 2))
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

addCommand('carto', {}, function(args)
	local players = game:GetService('Players')
  	local username = table.unpack(args)
	local targetPlayer = findPlayer(username, players:GetPlayers())
	local vehicle = getVehicle(localPlayer)

	if targetPlayer and vehicle then
		local rootPart = getRootPart(localPlayer)
		local humanoid = rootPart.Parent:FindFirstChild("Humanoid")

		if rootPart and humanoid then
			local isSitting = humanoid.Sit

			if not isSitting then
				sendNotification('To Car', 'Humanoid is not sitting, aborted')
			else
				local targetRootPart = getRootPart(targetPlayer)

				if targetRootPart then
					local teleportCFrame = targetRootPart.CFrame - Vector3.new(5, 0, 0)

					vehicle:SetPrimaryPartCFrame(teleportCFrame)
				end
			end
		end
	end
end)

addCommand('to', {}, function(args)
	local players = game:GetService('Players')
  	local username = table.unpack(args)
	local targetPlayer = findPlayer(username, players:GetPlayers())

	if targetPlayer then
		local targetRootPart = getRootPart(targetPlayer)
		
		if targetRootPart then
			local teleportCFrame = targetRootPart.CFrame - Vector3.new(1, 0, 0)
			
			teleportPlayer(localPlayer, teleportCFrame)
		end
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

XAdminVariables.UserInputServiceConnection = userInputService.InputBegan:Connect(function(input, onGui)
	if input.UserInputType == Enum.UserInputType.Keyboard then
		if input.KeyCode == Enum.KeyCode.Semicolon and not onGui then toggleGui()
		elseif ui.frame.Visible and input.KeyCode == Enum.KeyCode.Return then
			local text = ui.command.Text:split(' ')[1]
			
			if text ~= '' and text ~= nil then
				local command = findCommand(text)
				local args = ui.command.Text:sub(#command.name + 2):split(' ')

				toggleGui()
				executeCommand(command.name, args)
			end
		elseif input.KeyCode == Enum.KeyCode.N and not onGui then
			executeCommand('res')
		end
	end
end)
