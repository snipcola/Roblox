--! Configuration
local games = {
    [{ 2534724415, 7711635737 }] = {
        "https://gist.githubusercontent.com/snipcola/e0a412be43e361a57723d3db25f8e25a/raw/SNCO.lua",
        "https://gist.githubusercontent.com/snipcola/6c0edbca90a24a05b7eb033d40cf6bf7/raw/Open-Aimbot-Personal.lua",
        "https://gist.githubusercontent.com/snipcola/1fa1a5e64ce2ab22b4e022239a86aa1d/raw/Infinite-Yield.lua"
    },
    [2534724415] = {
        "https://raw.githubusercontent.com/snipcola/roblox/main/mod_cmd_exts.lua"
    }
}

--! Global
if not getgenv().SNCO_Scripts then
    getgenv().SNCO_Scripts = {}
end

--! Functions
local function execute(script)
    task.spawn(function ()
        local success, error = pcall(loadstring(script))

        if not success then
            warn("Failed loading script:", error)
        end
    end)
end

local function fetch(url)
    local response = request({ Url = url, Method = "GET" })
    return response.Success, response.Body
end

local function populate(urls)
    for _, url in ipairs(urls) do
        local success, script = fetch(url)
    
        if success then
            table.insert(getgenv().SNCO_Scripts, script)
        end
    end
end

local function initialize()
    repeat task.wait() until game:IsLoaded()

    for _, script in ipairs(getgenv().SNCO_Scripts) do
        execute(script)
    end
end

local function urls(id)
    local total = {}
    
    for game, urls in pairs(games) do
        if type(game) == "table" and table.find(game, id) or game == id then
            for _, url in ipairs(urls) do
                table.insert(total, url)
            end
        end
    end

    return total
end

--! Set-up
if #getgenv().SNCO_Scripts == 0 then
    populate(urls(game.PlaceId))
end

--! Initialize
initialize()
