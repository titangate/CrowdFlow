
local grid = MOAIGrid.new()
grid:initRectGrid(screen.width/gridsize, screen.height/gridsize, gridsize, gridsize)
grid:fill(180)


setAttraction(grid,5,30,64,180)
--setAttraction(grid,60,30,32,180)
writeToGrid(grid,10,10,20,10)
writeToGrid(grid,40,10,20,25)

return grid