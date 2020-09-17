-- require the flatbuffers module
local flatbuffers = require("flatbuffers")
-- require the generated files from `flatc`.
local color = require("MyGame.Sample.Color")
local equipment = require("MyGame.Sample.Equipment")
local monster = require("MyGame.Sample.Monster")
local vec3 = require("MyGame.Sample.Vec3")
local weapon = require("MyGame.Sample.Weapon")

local readFile = io.open('monster.bin', 'rb')

local bufAsString =  readFile:read('*a')
readFile:close()

-- Convert the string representation into binary array Lua structure
local buf = flatbuffers.binaryArray.New(bufAsString)
-- Get an accessor to the root object insert the buffer
local mon = monster.GetRootAsMonster(buf, 0)

local hp = mon:Hp()
local mana = mon:Mana()
local name = mon:Name()

print(hp, mana, name)

local pos = mon:Pos()
local x = pos:X()
local y = pos:Y()
local z = pos:Z()

print(x, y, z)
