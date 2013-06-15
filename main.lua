require 'library.system'

-- Open the window and create a viewport
screen = {
	width = 1024,
	height = 768,
}
gridsize = 16
local grid = require 'testcase1'
MOAISim.openWindow("Example", screen.width, screen.height)
viewport = MOAIViewport.new()
viewport:setSize(screen.width, screen.height)
viewport:setScale(screen.width, screen.height)

-- Create a layer
layer = MOAILayer2D.new()
layer:setViewport(viewport)
MOAISim.pushRenderPass(layer)

-- Load the image file
deck = MOAITileDeck2D.new()
deck:setTexture("moai.png")
deck:setSize(256, 1)

-- Make a prop with that grid and image set
prop = MOAIProp2D.new()
prop:setDeck(deck)
prop:setGrid(grid)
prop:setLoc(-screen.width/2, -screen.height/2)

-- Add it to the layer so it will be rendered
layer:insertProp(prop)

-- Create a new unit
unit = {
	prop = MOAIProp2D.new(),
	r = 0,
	speed = 32,
}

unitdeck = MOAIGfxQuad2D.new()
unitdeck:setTexture"testactor.png"
unitdeck:setRect(-32,-32,32,32)
unit.prop:setScl(gridsize/64)
unit.prop:setDeck(unitdeck)
layer:insertProp(unit.prop)

setUnitLocInGrid(grid,unit,40,5)

function update(dt)
	local x,y = unit.prop:getLoc()
	local tx,ty = worldToModel(grid,x,y)
	local wx,wy = modelToWorld(grid,tx,ty)
	unit.r = getDirection(grid,tx,ty)
	if unit.r == false then
		return
	end
	local vx,vy = math.cos(unit.r),math.sin(unit.r)
	x = x + vx * dt * unit.speed
	y = y + vy * dt * unit.speed
	unit.prop:setLoc(x,y)
	unit.prop:setRot(unit.r / math.pi * 180)
end

local prevElapsedTime = MOAISim.getDeviceTime()

local elapsedTime = 0

local thread = MOAICoroutine.new()

	thread:run(
		function()
			while (true) do
				local currElapsedTime = MOAISim.getDeviceTime()
				elapsedTime = currElapsedTime - prevElapsedTime
				prevElapsedTime = currElapsedTime
				update(elapsedTime)
				coroutine.yield()
		end
	end
)
