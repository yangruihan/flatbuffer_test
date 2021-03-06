local indentSymbol = "    "

---@param t table
---@param s string
local function append(t, s)
    t[#t + 1] = s
end

---@param i number
local function isInteger(i)
    return math.ceil(i) == i
end

--- Determine with a Lua table can be treated as an array.
--- Explicitly returns "not an array" for very sparse arrays.
--- Returns:
--- -1   Not an array
--- 0    Empty table
--- >0   Highest index in the array
---@param table table
local function isArray(table)
    local max = 0
    local count = 0
    for k, v in pairs(table) do
        if type(k) == "number" then
            if k > max then
                max = k
            end
            count = count + 1
        else
            return -1
        end
    end
    if max > count * 2 then
        return -1
    end

    return max
end

---@param item any
---@param stable table
---@param indent number
local function handleItem(item, stable, indent)
    local sindent = string.rep(indentSymbol, indent)
    local sindent2 = sindent .. indentSymbol

    if type(item) == "number" then
        if isInteger(item) then
            append(stable, string.format("%d", item))
        else
            append(stable, string.format("%f", item))
        end
    elseif type(item) == "boolean" then
        append(stable, item and "true" or "false")

    elseif type(item) == "string" then
        append(stable, string.format('"%s"', item))

    elseif type(item) == "table" then
        local ret = isArray(item)

        --- array
        if ret > 0 then
            append(stable, string.format("\n%s[\n", sindent2))

            for _, item in ipairs(item) do
                append(stable, string.format("    %s", sindent2))
                handleItem(item, stable, indent + 1)
                append(stable, ",\n")
            end

            append(stable, string.format("%s]", sindent2))

        --- table
        elseif ret < 0 then
            append(stable, string.format("\n%s{\n", sindent2))

            for key, value in pairs(item) do
                append(stable, string.format("    %s%s: ", sindent2, key))
                handleItem(value, stable, indent + 1)
                append(stable, ",\n")
            end

            append(stable, string.format("%s}", sindent2))
        end
    end
end

local function main()
    if not arg[1] then
        error("Please input lua config path")
    end

    if not arg[2] then
        error("Please input output file path")
    end

    local cfgPath = arg[1]

    if string.sub(cfgPath, 1, 1) == "." then
        cfgPath = string.sub(cfgPath, 2)
    end

    if string.match(string.sub(cfgPath, 1, 1), "[/\\]") then
        cfgPath = string.sub(cfgPath, 2)
    end

    cfgPath = string.gsub(string.gsub(cfgPath, "[/\\]", "."), ".lua", "")

    local cfg = require(cfgPath)

    --- 遍历配置，生成对应的json配置
    local retStrTable = {"{Data:[\n"}
    for k, v in pairs(cfg) do
        handleItem(v, retStrTable, 0)
        append(retStrTable, ",\n")
    end

    append(retStrTable, "\n]}")
    local fileContent = table.concat(retStrTable, "")

    local outputPath = arg[2]

    local file = io.open(outputPath, "w")
    file:write(fileContent)
    file:close()
end

main()
