local oldPackagePath = package.path
local newPath = string.gsub(arg[0], "lua2pb.lua", "?.lua")
if string.find(newPath, "/") then
    package.path = oldPackagePath .. ";" .. newPath
end

local pb = require("pb")
local protoc = require("protoc")

--- lua lua2pb PROTO_PATH LUATABLE_PATH MESSAGE_NAME OUTPUT_PATH

local function main()
    if arg[1] == "-h" or arg[1] == "--help" then
        print("lua lua2pb PROTO_PATH LUATABLE_PATH MESSAGE_NAME OUTPUT_PATH")
        return
    end

    if #arg ~= 4 then
        print("lua lua2pb PROTO_PATH LUATABLE_PATH MESSAGE_NAME OUTPUT_PATH")
        return
    end

    -----------
    --- Load pb
    -----------

    local pbDefineFile = io.open(arg[1], "r")
    local pbDefine = pbDefineFile:read("*a")
    pbDefineFile:close()

    protoc:load(pbDefine)

    ------------
    --- Load cfg
    ------------

    local cfgPath = arg[2]

    if string.sub(cfgPath, 1, 1) == "." then
        cfgPath = string.sub(cfgPath, 2)
    end

    if string.match(string.sub(cfgPath, 1, 1), "[/\\]") then
        cfgPath = string.sub(cfgPath, 2)
    end

    cfgPath = string.gsub(string.gsub(cfgPath, "[/\\]", "."), ".lua", "")

    local cfg = require(cfgPath)

    ----------------
    --- encode table
    ----------------
    local bytes = assert(pb.encode(arg[3], cfg), "encode failed")

    --------------------
    --- write bytes file
    --------------------
    local outputFile = io.open(arg[4], 'wb')
    outputFile:write(bytes)
    outputFile:close()
end

main()
