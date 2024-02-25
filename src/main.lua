-- local socket=require("socket")

local width, height = 0, 0
local maxX, maxY = 0, 0
local snake = {{1,1}, {2,1}, {2,2}}
local snakeDirection = {1, 0}
local snakeSize = 10
local snakeSpeed = 1 -- size per second
local updateTime = 0

function love.load()
    -- load function
    width, height = love.graphics.getDimensions()
    maxX = width / snakeSize
    maxY = height / snakeSize
    start = os.time()
    print( maxX, maxY, start )
end

function love.update( dt )
    updateTime = updateTime + dt
    if updateTime > 1 then
        updateSnake()
        updateTime = 0
    end
    --print( dt )
    -- now = os.date( "*t" )
    -- ms = socket.gettime()
end

function love.draw()
    drawSnake()
end

function updateSnake()
    firstSegment = snake[#snake]
    newHead = {firstSegment[1] + snakeDirection[1], firstSegment[2] + snakeDirection[2]}
    snake[#snake+1] = newHead
    table.remove( snake, 1 )
end

function drawSnake( )
    for _, segment in pairs( snake ) do
        love.graphics.rectangle( "fill", segment[1]*snakeSize, segment[2]*snakeSize, snakeSize, snakeSize )
    end
end