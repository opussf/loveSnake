local socket=require("socket")

local now = {}
local hour, minute, second = 0, 0, 0
local width, height = 0, 0
local centerX, centerY = 0, 0
local fractalLoop = 1
local handLength = {["s"] = 100, ["m"] = 75, ["h"] = 50}
local use24 = false

function valueToCoords( myCenterX, myCenterY, value, scale, hourType )
    -- convert to rad ( based on 1-60 )
    if hourType and hourType == 12 or hourType == 24 then
        conversion = (2 * math.pi) / hourType
        value = value >= hourType and value-hourType or value
    else
        conversion = (2 * math.pi) / 60
    end
    newValue = (value * conversion) - math.pi/2
    return myCenterX,myCenterY, myCenterX+(math.cos( newValue ) * scale),myCenterY+(math.sin( newValue ) * scale)
end

function love.load()
    -- load function
    width, height = love.graphics.getDimensions()
    centerX = width/2
    centerY = height/2
end

function love.update( dt )
    print( dt )
    now = os.date( "*t" )
    ms = socket.gettime()
    second = now.sec + (ms - math.floor(ms))
    minute = now.min + second/60
    hour = now.hour + minute/60
end

function love.draw()
    love.graphics.print( string.format( "%i:%i.%i", hour, minute, second ), 10, 10 )
    love.graphics.circle( 'line', centerX, centerY, handLength.s )
    centers = {centerX, centerY}
    newCenters = {}
    for lcv = 0,fractalLoop-1 do
        for i = 1,#centers,2 do 
            cX = centers[i]
            cY = centers[i+1]
            --print( cX, cY, #centers )
            for _,v in ipairs({drawClock( cX, cY, second*lcv )}) do
                table.insert( newCenters, v )
                --print(i,v,second)
            end
        end
        centers = newCenters
    end
end

function drawClock( centerX, centerY, rotation )  -- seconds (1/60)
    secondCoords = {valueToCoords( centerX, centerY, second+rotation, handLength.s )}
    minuteCoords = {valueToCoords( centerX, centerY, minute+rotation, handLength.m )}
    hourCoords = {valueToCoords( centerX, centerY, hour+(rotation/5), handLength.h, use24 and 24 or 12 )}

    love.graphics.line( secondCoords )
    love.graphics.line( minuteCoords )
    love.graphics.line( hourCoords )
    return secondCoords[3], secondCoords[4], minuteCoords[3], minuteCoords[4], hourCoords[3], hourCoords[4] 
end