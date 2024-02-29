-- local socket=require("socket")
gameoverbanner = require "gameoverbanner"

local width, height = 0, 0
local maxX, maxY = 0, 0
local keys = {["down"] = {0,1}, ["right"] = {1,0}, ["up"] = {0,-1}, ["left"] = {-1,0} }
local field = {}
local initialFieldSize = 25
local fieldSize = initialFieldSize
local snake
local snakeDirection
local snakeSize = 10
local snakeSpeed = 0.12 -- seonds per size
local updateTime = 0
local isRunning = true
local highScore = 0
local highScoreFile = "highscore"

function love.load()
    -- load function
    width, height = love.graphics.getDimensions()
    maxX = width / snakeSize
    maxY = height / snakeSize
    start = os.time()
    print( maxX, maxY, start )
    math.randomseed( os.time() )
    initField( fieldSize )
    initSnake()
    loadHighscore()
end
function loadHighscore()  -- @todo: fix this...
    hs = love.filesystem.newFile( highScoreFile )
    hs:open('r')
    data,size = hs:read( 100 )
    hs:close()
    print( data, size )
    highScore = data and tonumber( data ) or 0
    print(highScore)
end
function love.update( dt )
    updateTime = updateTime + dt
    if isRunning then 
        if updateTime >= snakeSpeed then
            updateSnake()
            updateTime = 0
            if #field == 0 then
                fieldSize = fieldSize + math.floor(fieldSize / 2)
                snakeSpeed = snakeSpeed > 0.1 and snakeSpeed - 0.05 or snakeSpeed

                initField( fieldSize )
            end
            print( #field, snakeSpeed, #snake, highScore )
            for _, f in ipairs(field) do
                print( f[1], f[2] )
            end
        end
    end
end
function love.draw()
    drawField()
    drawSnake()
    if not isRunning then
        drawGameOver()
    end
end
function love.keypressed( key, scancode, isrepeat )
    -- print( key, scancode, isrepeat )
    if keys[key] then
        snakeDirection = keys[key]
    end
    if key == "space" and not isRunning then
        fieldSize = initialFieldSize
        initField( fieldSize )
        initSnake()
        isRunning = true
    end
end

function initField( numOfDots )
    local dotCount = 0
    local x, y
    field = {}
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
function initSnake()
    snake = {{1,1}, {2,1}, {2,2}}
    snakeDirection = keys.right
end

function updateSnake()
    firstSegment = snake[#snake]
    newHead = {firstSegment[1] + snakeDirection[1], firstSegment[2] + snakeDirection[2]}
    if ( newHead[1] > maxX or newHead[1] < 0 
            or newHead[2] > maxY or newHead[2] < 0 ) then
        endGame()
    end
    for _, segment in pairs( snake ) do
        if newHead[1] == segment[1] and newHead[2] == segment[2] then
            endGame()
        end
    end
    for _, dot in ipairs( field ) do
        if newHead[1] == dot[1] and newHead[2] == dot[2] then
            lengthenSnake( ( _ == #field and 10 or 1 ) )
            table.remove( field, _ )
        end
    end
    snake[#snake+1] = newHead
    table.remove( snake, 1 )
end

function lengthenSnake( addSegments )
    addSegments = addSegments or 1
    for lcv = 1,addSegments do
        table.insert( snake, 1, snake[1] )
    end
end

function drawSnake()
    love.graphics.setColor( 1, 1, 1, 1 )
    for _, segment in pairs( snake ) do
        love.graphics.rectangle( "fill", segment[1]*snakeSize, segment[2]*snakeSize, snakeSize, snakeSize )
    end
end

function drawField()
    love.graphics.setColor( 0, 1, 0, 1 )
    for _, segment in ipairs( field ) do
        if _ == #field then
            love.graphics.setColor( 1, 0, 0, 1 )
        end
        love.graphics.rectangle( "fill", segment[1]*snakeSize, segment[2]*snakeSize, snakeSize, snakeSize )
    end
end

function drawGameOver()
    love.graphics.setColor( 1, 0, 0, 1 )
    offsetX, offsetY = (maxX/2)-28, (maxY/2)-2
    for _, segment in ipairs( gameoverbanner ) do
        love.graphics.rectangle( "fill", (segment[1]+offsetX)*snakeSize,(segment[2]+offsetY)*snakeSize, 
                                snakeSize,snakeSize )
    end
    love.graphics.print( string.format( "Score: %i  HighScore: %i", #snake, highScore ), 10, 10 )
end

function endGame()
    print( "GAME OVER!  Snake Size is: "..#snake )
    isRunning = false
    highScore = math.max( highScore, #snake )
end

function love.quit()
    hs = love.filesystem.newFile( highScoreFile )
    hs:open('w')

    hs:write( highScore )

    hs:close()
end