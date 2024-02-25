-- local socket=require("socket")

local width, height = 0, 0
local maxX, maxY = 0, 0
local keys = {["down"] = {0,1}, ["right"] = {1,0}, ["up"] = {0,-1}, ["left"] = {-1,0} }
local field = {}
local fieldSize = 15
local snake = {{1,1}, {2,1}, {2,2}}
local snakeDirection = {1, 0}
local snakeSize = 10
local snakeSpeed = 0.17 -- seonds per size
local updateTime = 0

function love.load()
    -- load function
    width, height = love.graphics.getDimensions()
    maxX = width / snakeSize
    maxY = height / snakeSize
    start = os.time()
    print( maxX, maxY, start )
    initField( fieldSize )
end

function love.update( dt )
    updateTime = updateTime + dt
    if updateTime >= snakeSpeed then
        updateSnake()
        updateTime = 0
        if #field == 0 then
            fieldSize = fieldSize + math.floor(fieldSize / 2)
            snakeSpeed = snakeSpeed > 0.1 and snakeSpeed - 0.05 or snakeSpeed

            initField( fieldSize )
        end
        print( #field, snakeSpeed )
        for _, f in ipairs(field) do
            print( f[1], f[2] )
        end
    end
end

function love.draw()
    drawField()
    drawSnake()
end

function love.keypressed( key, scancode, isrepeat )
    -- print( key, scancode, isrepeat )
    if keys[key] then
        snakeDirection = keys[key]
    end
end

function initField( numOfDots )
    local dotCount = 0
    local x, y
    while dotCount < numOfDots do
        x, y = math.random(maxX-1), math.random(maxY-1)
        validPoint = true
        for _, segment in pairs( field ) do
            if segment[1] == x and segment[2] == y then
                validPoint = false
                break
            end
        end
        if validPoint then
            table.insert( field, {x, y} )
            dotCount = dotCount + 1
        end
    end
end

function updateSnake()
    firstSegment = snake[#snake]
    newHead = {firstSegment[1] + snakeDirection[1], firstSegment[2] + snakeDirection[2]}
    for _, segment in pairs( snake ) do
        if newHead[1] == segment[1] and newHead[2] == segment[2] then
            endGame()
        end
    end
    for _, dot in pairs( field ) do
        if newHead[1] == dot[1] and newHead[2] == dot[2] then
            lengthenSnake()
            table.remove( field, _ )
        end
    end
    snake[#snake+1] = newHead
    table.remove( snake, 1 )
end

function lengthenSnake()
    table.insert( snake, 1, snake[1] )
end

function drawSnake()
    love.graphics.setColor( 1, 1, 1, 1 )
    for _, segment in pairs( snake ) do
        love.graphics.rectangle( "fill", segment[1]*snakeSize, segment[2]*snakeSize, snakeSize, snakeSize )
    end
end

function drawField()
    love.graphics.setColor( 0, 1, 0, 1 )
    for _, segment in pairs( field ) do
        love.graphics.rectangle( "fill", segment[1]*snakeSize, segment[2]*snakeSize, snakeSize, snakeSize )
    end
end

function endGame()
    print( "GAME OVER!  Snake Size is: "..#snake )
end