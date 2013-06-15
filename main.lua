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
deck:setSize(64, 1)

-- Make a prop with that grid and image set
prop = MOAIProp2D.new()
prop:setDeck(deck)
prop:setGrid(grid)
prop:setLoc(-screen.width/2, -screen.height/2)

-- Add it to the layer so it will be rendered
layer:insertProp(prop)
-- Change the color of cell 1,1 to the second item in the deck
grid:setTile(1, 1, 2)