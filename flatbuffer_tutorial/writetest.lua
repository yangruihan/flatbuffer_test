-- require the flatbuffers module
local flatbuffers = require("flatbuffers")
-- require the generated files from `flatc`.
local color = require("MyGame.Sample.Color")
local equipment = require("MyGame.Sample.Equipment")
local monster = require("MyGame.Sample.Monster")
local vec3 = require("MyGame.Sample.Vec3")
local weapon = require("MyGame.Sample.Weapon")

-- get access to the builder, providing an array of size 1024
local builder = flatbuffers.Builder(1024)

local weaponOne = builder:CreateString("Sword")
local weaponTwo = builder:CreateString("Axe")

-- Create the first 'Weapon'
weapon.Start(builder)
weapon.AddName(builder, weaponOne)
weapon.AddDamage(builder, 3)
local sword = weapon.End(builder)

-- Create the second 'Weapon'
weapon.Start(builder)
weapon.AddName(builder, weaponTwo)
weapon.AddDamage(builder, 5)
local axe = weapon.End(builder)

-- Serialize a name for our mosnter, called 'orc'
local name = builder:CreateString("Orc")
-- Create a `vector` representing the inventory of the Orc. Each number
-- could correspond to an item that can be claimed after he is slain.
-- Note: Since we prepend the bytes, this loop iterates in reverse.
monster.StartInventoryVector(builder, 10)
for i=10,1,-1 do
    builder:PrependByte(i)
end
local inv = builder:EndVector(10)

-- Create a FlatBuffer vector and prepend the weapons.
-- Note: Since we prepend the data, prepend them in reverse order.
monster.StartWeaponsVector(builder, 2)
builder:PrependUOffsetTRelative(axe)
builder:PrependUOffsetTRelative(sword)
local weapons = builder:EndVector(2)

-- Create a FlatBuffer vector and prepend the path locations.
-- Note: Since we prepend the data, prepend them in reverse order.
monster.StartPathVector(builder, 2)
vec3.CreateVec3(builder, 1.0, 2.0, 3.0)
vec3.CreateVec3(builder, 4.0, 5.0, 6.0)
local path = builder:EndVector(2)

-- Create our monster by using Start() and End()
monster.Start(builder)
monster.AddPos(builder, vec3.CreateVec3(builder, 1.0, 2.0, 3.0))
monster.AddHp(builder, 300)
monster.AddName(builder, name)
monster.AddInventory(builder, inv)
monster.AddColor(builder, color.Red)
monster.AddWeapons(builder, weapons)
monster.AddEquippedType(builder, equipment.Weapon)
monster.AddEquipped(builder, axe)
monster.AddPath(builder, path)
local orc = monster.End(builder)

-- Call 'Finish()' to instruct the builder that this monster is complete.
builder:Finish(orc)

-- Get the flatbuffer as a string containing the binary data
local bufAsString = builder:Output()

local outputFile = io.open('monster.bytes', 'wb')
outputFile:write(bufAsString)
outputFile:close()