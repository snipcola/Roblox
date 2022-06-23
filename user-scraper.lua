local teleportService = game:GetService("TeleportService")
local httpService = game:GetService("HttpService")
local players = game:GetService("Players")
local localPlayer = players.LocalPlayer
local jobIdsFileName = "jobIds.json"
local jsonFileName = "info.json"
local info = {}
local jobId = game.JobId
local placeId = game.PlaceId
local getInstancesUrl = "https://games.roblox.com/v1/games/" .. placeId .. '/servers/Public'

repeat task.wait() until game:IsLoaded()

local function encodeJson(tbl)
    return httpService:JSONEncode(tbl)
end

local function decodeJson(str)
    return httpService:JSONDecode(str)
end

local function httpGet(url)
    return decodeJson(syn.request({ Url = url }).Body)
end

local function getInstances(url)
    return httpGet(url).data
end

local function randItem(tbl)
    return tbl[math.random(1, #tbl)]
end

local function removeDuplicates(tbl)
    local ttbl = tbl
    local passed = {}
    
    for idx, itm in pairs(ttbl) do
        local val = itm.name
        
        if table.find(passed, val) then
            table.remove(ttbl, idx)
        else
            table.insert(passed, val)
        end
    end
    
    return ttbl
end

local function writeToJsonFile(fileName, tbl, remvDupes)
    local isFile = isfile(fileName)
    
    if not isFile then
        writefile(fileName, '[]')
    end
    
    local json = {}
    
    if readfile(fileName) == '' then
        appendfile(fileName, '[]')
    end
    
    local fileContents = readfile(fileName)
    
    if decodeJson(fileContents) then
        json = decodeJson(fileContents)
    end
    
    for _, itm in pairs(tbl) do
        table.insert(json, itm)
    end
    
    return writefile(fileName, encodeJson(remvDupes and removeDuplicates(json) or json))
end

local function savePlayerInfo(playersTbl, tbl)
    for _, player in pairs(playersTbl) do
    	if player ~= localPlayer then
    	    table.insert(tbl, {
        	    name = player.Name,
        	    displayName = player.DisplayName,
        	    age = player.AccountAge
        	})
    	end
    end
    
    writeToJsonFile(jsonFileName, tbl, true)
end

local function joinGame(plcId, guid)
    teleportService:TeleportToPlaceInstance(plcId, guid)
end

local function saveJobId(id)
    writeToJsonFile(jobIdsFileName, { id })
end

local function existsInJsonFile(fileName, val)
    local isFile = isfile(fileName)
    
    if not isFile then
        writefile(fileName, '[]')
    end
    
    local json = {}
    
    if readfile(fileName) == '' then
        appendfile(fileName, '[]')
    end
    
    local fileContents = readfile(fileName)
    
    if decodeJson(fileContents) then
        json = decodeJson(fileContents)
    end
    
    return table.find(json, value) and true or false
end

if not existsInJsonFile(jobIdsFileName, jobId) then
    savePlayerInfo(players:GetPlayers(), info)
    saveJobId(jobId)
end

while task.wait(5) do
    pcall(function()
        local instances = getInstances(getInstancesUrl)
        local nextInstance = randItem(instances)
        
        if not existsInJsonFile(jobIdsFileName, nextInstance.id) then
            joinGame(placeId, nextInstance.id)
        end
    end)
end
