
local grid = MOAIGrid.new()
grid:initRectGrid(screen.width/gridsize, screen.height/gridsize, gridsize, gridsize)
grid:fill(1)


setAttraction(grid,5,30,64,10)
writeToGrid(grid,1,1,20,10)
writeToGrid(grid,40,10,20,20)

return grid