-- determine whether a coordinate is within the bound
function validCoordinate(grid,x,y)
	local w,h = grid:getSize()
	return x > 0 and y > 0
		and x <= w and y <= h
end

-- fill a rectangle area of a grid
function writeToGrid(grid,x,y,w,h)
	for i=x,x+w do
		for j=y,y+h do
			if validCoordinate(grid,i,j) then
				grid:setTile(i,j,0)
			end
		end
	end
end

-- radial outwards fade function
function fadeLinear(dx,dy,r)
	return 1-(dx*dx+dy*dy)^.5/r
end

-- create an attraction source
function setAttraction(grid,x,y,r,attract,fadefunction)
	fadefunction = fadefunction or fadeLinear
	for i=x-r,x+r do
		for j=y-r,y+r do
			if validCoordinate(grid,i,j) then
				delta = math.max(fadefunction(i-x,j-y,r)*attract,0)
				grid:setTile(i,j,delta + grid:getTile(i,j))
			end
		end
	end
end

local neighbours = {
	{-1,0},
	{1,0},
	{0,-1},
	{0,1},
	{-1,-1},
	{1,-1},
	{-1,1},
	{1,1}
}
-- get all neighbour grid that is within the bound (iterative function)
function getNeighbour(grid,x,y)
	return coroutine.wrap(function()
		for i,v in ipairs(neighbours) do
			local dx,dy = unpack(v)
			dx,dy = x+dx,y+dy
			if validCoordinate(grid,dx,dy) then
				coroutine.yield(dx,dy)
			end
		end
	end)
end

-- get wether the given grid is an obstacle
function isObstacle(grid,x,y)
	return grid:getTile(x,y) == 0
end

-- WIP
function getDirection(grid,x,y)
	local move = false
	local baseX,baseY = 0,0
	local currentAttraction = grid:getTile(x,y)
	for i,j in getNeighbour(grid,x,y) do
		local attraction = grid:getTile(i,j)
		if attraction > currentAttraction then
			move = true
			baseX = baseX + attraction
		end
	end
end
