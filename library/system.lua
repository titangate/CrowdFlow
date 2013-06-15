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
	{-1,0,1},
	{1,0,1},
	{0,-1,1},
	{0,1,1},
	{-1,-1,1.414},
	{1,-1,1.414},
	{-1,1,1.414},
	{1,1,1.414}
}
-- get all neighbour grid that is within the bound (iterative function)
function getNeighbour(grid,x,y)
	return coroutine.wrap(function()
		for i,v in ipairs(neighbours) do
			local dx,dy,distance = unpack(v)
			nx,ny = x+dx,y+dy
			if validCoordinate(grid,nx,ny) then
				coroutine.yield(nx,ny,dx,dy,distance)
			end
		end
	end)
end

-- get wether the given grid is an obstacle
function isObstacle(grid,x,y)
	return grid:getTile(x,y) == 0
end

-- get the prefered direction to move in the next frame
function getDirection(grid,x,y)
	local move = false
	local baseX,baseY = 0,0
	local currentAttraction = grid:getTile(x,y)
	for i,j,dx,dy,distance in getNeighbour(grid,x,y) do
		local attraction = grid:getTile(i,j)
		if attraction > currentAttraction then
			move = true
			baseX = baseX + (attraction - currentAttraction) / distance * dx
			baseY = baseY + (attraction - currentAttraction) / distance * dy
		end
	end
	if not move then 
		return false -- prefer to stay stationary
	end
	return math.atan2(baseY,baseX)
end

function setUnitLocInGrid(grid,unit,x,y)
	local tx,ty = grid:getTileSize()
	unit.prop:setLoc(-screen.width/2 + x*tx + 0,-screen.height/2 + y*ty + 0)
end

function modelToWorld(grid,x,y)
	local tx,ty = grid:getTileSize()
	return -screen.width/2 + x*tx + 0,-screen.height/2 + y*ty + 0
end

function worldToModel(grid,x,y)
	local tx,ty = grid:getTileSize()
	local x,y = math.floor((screen.width/2 + x - 0)/tx),math.floor((screen.height/2 + y - 0)/ty)
	return x,y
end