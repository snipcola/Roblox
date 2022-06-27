if getgenv().protect_instance then
    return getgenv().protect_instance, getgenv().unprotect_instance
end

getgenv().raw = loadstring(game:HttpGet("https://pastebin.com/raw/aVDqbsU2"))() -- raw library
getgenv().setrawproperty = loadstring(game:HttpGet("https://pastebin.com/raw/jYN3Hjhr"))() -- setrawproperty

do
    local randomString = ""
    for _ = 1,10 do
        randomString = randomString..string.char(math.random(97,122))
    end

    do
        local OldNewIndex
        OldNewIndex = hookmetamethod(game, "__newindex", newcclosure(function(...)
            if checkcaller() then
                local Args = {...}
                local Self = Args[1]
                if Self ~= nil and raw.get(Self, "GetAttribute")(Self, randomString) == randomString and string.sub(Args[2], 1, 6) == "Parent" then
                    return setrawproperty(...)
                end
            end
            return OldNewIndex(...)
        end))
    end

    getgenv().findthingy = function(Base, Self, ClassName, Recursive)
        for _,v in pairs(Recursive and Self:GetDescendants() or Self:GetChildren()) do
            if raw.get(Self, "GetAttribute")(Self, randomString) ~= randomString then
                if Base then
                    if raw.get(v, "IsA")(v, ClassName) then
                        return v
                    end
                elseif raw.get(v, "ClassName") == ClassName then
                    return v
                end
            end
        end
    end

    getgenv().protect_instance = function(Obj)
        assert(typeof(Obj) == "Instance", string.format("Invalid argument #1 (Instance expected, got %s)", typeof(Obj)))
        Obj:SetAttribute(randomString, randomString)
    end

    getgenv().unprotect_instance = function(Obj)
        assert(typeof(Obj) == "Instance", string.format("Invalid argument #1 (Instance expected, got %s)", typeof(Obj)))
        Obj:SetAttribute(randomString, nil)
    end

    if getgenv().cn then
        setreadonly(getgenv().cn, false)
    else
        getgenv().cn = {}
    end

    getgenv().cn.strip_meta = function(Old, Method, ...)
        local Args = {...}
        for i,v in pairs(Args) do
            local class = typeof(v)
            if class == "table" then
                for ii,vv in pairs(v) do
                    if typeof(vv) == "Instance" and raw.get(vv, "GetAttribute")(vv, randomString) == randomString then
                        if type(ii) == "number" then
                            table.remove(v, ii)
                        else
                            v[ii] = nil
                        end
                    end
                end
            elseif class == "Instance" and raw.get(v, "GetAttribute")(v, randomString) == randomString then
                local method = string.lower(Method)
                if string.sub(method, 1, 9) == "findfirst" or string.sub(method, 1, 7) == "waitfor" then
                    if string.sub(method, 1, 21) == "findfirstchildofclass" then
                        Args[i] = findthingy(true, unpack(Old))
                    elseif string.sub(method, 1, 22) == "findfirstchildwhichisa" then
                        Args[i] = findthingy(false, unpack(Old))
                    else
                        local old = raw.get(v, "Name")
                        setrawproperty(v, "Name", old.." ")
                        Args[i] = raw.get(Old[1], Method)(unpack(Old))
                        setrawproperty(v, "Name", old)
                    end
                else
                    Args[i] = nil
                end
            end
        end
        return unpack(Args)
    end

    setreadonly(getgenv().cn, true)
end

do
    local stripmeta = getgenv().cn.strip_meta

    do
        local OldNamecall
        OldNamecall = hookmetamethod(game, "__namecall", newcclosure(function(...)
            local Args = {...}
            if Args[1] ~= nil then
                return stripmeta(Args, getnamecallmethod(), OldNamecall(...))
            end
            return OldNamecall(...)
        end))
    end

    local OldIndex
    OldIndex = hookmetamethod(game, "__index", newcclosure(function(...)
        if not checkcaller() then
            local Args = {...}
            if Args[1] ~= nil then
                return stripmeta(Args, Args[2], OldIndex(...))
            end
        end
        return OldIndex(...)
    end))
end

return getgenv().protect_instance, getgenv().unprotect_instance
