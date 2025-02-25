-- LOVE2D Snake Game with Menu, Volume Control, and Keybindings Guide

function love.conf(t)
    t.window.title = "Snake Game"
    t.window.width = 600
    t.window.height = 600
    t.window.resizable = false
end

function love.load()
    -- Initialize game window
    love.window.setTitle("Snake Game")
    love.window.setMode(600, 600)
    
    -- Game variables
    cellSize = 20
    gridSize = 600 / cellSize
    direction = "right"
    nextDirection = "right"
    snake = {{x = 5, y = 5}}
    apple = {x = love.math.random(gridSize) - 1, y = love.math.random(gridSize) - 1}
    gameState = "menu"
    score = 0
    speed = 0.1
    timer = 0
    volume = 1.0  -- Default volume level
    
    -- Load music and set looping
    music = love.audio.newSource("music/music.mp3", "stream")
    music:setLooping(true)
    music:setVolume(volume)
    love.audio.play(music)
end

function love.update(dt)
    if gameState == "playing" then
        timer = timer + dt
        if timer >= speed then
            timer = 0
            moveSnake()
        end
    end
end

-- Handles snake movement and collision detection
function moveSnake()
    local head = snake[1]
    local newHead = {x = head.x, y = head.y}
    
    -- Change direction
    if nextDirection == "up" then newHead.y = newHead.y - 1 end
    if nextDirection == "down" then newHead.y = newHead.y + 1 end
    if nextDirection == "left" then newHead.x = newHead.x - 1 end
    if nextDirection == "right" then newHead.x = newHead.x + 1 end
    
    direction = nextDirection  -- Prevents reversing into itself
    
    -- Check for collisions with walls or itself
    if newHead.x < 0 or newHead.x >= gridSize or newHead.y < 0 or newHead.y >= gridSize or collidesWithSnake(newHead) then
        gameState = "gameover"
        return
    end
    
    -- Move snake forward
    table.insert(snake, 1, newHead)
    if newHead.x == apple.x and newHead.y == apple.y then
        score = score + 1
        apple.x = love.math.random(gridSize) - 1
        apple.y = love.math.random(gridSize) - 1
    else
        table.remove(snake)
    end
end

-- Checks if snake collides with itself
function collidesWithSnake(position)
    for _, segment in ipairs(snake) do
        if segment.x == position.x and segment.y == position.y then
            return true
        end
    end
    return false
end

function love.draw()
    if gameState == "menu" then
        drawMenu()
    elseif gameState == "playing" then
        drawGame()
    elseif gameState == "gameover" then
        drawGameOver()
    end
end

-- Draw main menu with volume control
function drawMenu()
    love.graphics.printf("Snake Game", 0, 150, 600, "center")
    love.graphics.printf("Press Enter to Start", 0, 200, 600, "center")
    love.graphics.printf("Press Esc to Exit", 0, 250, 600, "center")
    
    -- Display volume control
    love.graphics.printf("Volume: " .. math.floor(volume * 100) .. "%%", 0, 300, 600, "center")
    love.graphics.printf("Use Left/Right Arrows to Adjust", 0, 330, 600, "center")
    
    -- Display control guide
    love.graphics.printf("Controls:", 0, 400, 600, "center")
    love.graphics.printf("Arrow Keys - Move", 0, 430, 600, "center")
    love.graphics.printf("R - Restart (Game Over)", 0, 460, 600, "center")
    love.graphics.printf("Esc - Exit Game", 0, 490, 600, "center")
    
    -- Display made by YOUR NAME text
    love.graphics.printf("Made by ADevNamedDeLL", 10, 580, 600, "left")
end

-- Draw game objects
function drawGame()
    love.graphics.setColor(1, 0, 0)
    love.graphics.rectangle("fill", apple.x * cellSize, apple.y * cellSize, cellSize, cellSize)
    
    love.graphics.setColor(0, 1, 0)
    for _, segment in ipairs(snake) do
        love.graphics.rectangle("fill", segment.x * cellSize, segment.y * cellSize, cellSize, cellSize)
    end
    
    love.graphics.setColor(1, 1, 1)
    love.graphics.print("Score: " .. score, 10, 10)
    
    -- Display made by YOUR NAME text in game
    love.graphics.printf("Made by ADevNamedDeLL", 10, 580, 600, "left")
end

-- Draw game over screen
function drawGameOver()
    love.graphics.printf("Game Over", 0, 200, 600, "center")
    love.graphics.printf("Press R to Restart", 0, 250, 600, "center")
    love.graphics.printf("Press Esc to Exit", 0, 300, 600, "center")
    
    -- Display made by YOUR NAME text in game over screen
    love.graphics.printf("Made by ADevNamedDeLL", 10, 580, 600, "left")
end

function love.keypressed(key)
    if gameState == "menu" then
        if key == "return" then
            gameState = "playing"
        elseif key == "escape" then
            love.event.quit()
        elseif key == "left" then
            volume = math.max(0, volume - 0.1)
            music:setVolume(volume)
        elseif key == "right" then
            volume = math.min(1, volume + 0.1)
            music:setVolume(volume)
        end
    elseif gameState == "playing" then
        if key == "up" and direction ~= "down" then nextDirection = "up" end
        if key == "down" and direction ~= "up" then nextDirection = "down" end
        if key == "left" and direction ~= "right" then nextDirection = "left" end
        if key == "right" and direction ~= "left" then nextDirection = "right" end
    elseif gameState == "gameover" then
        if key == "r" then
            love.load()
            gameState = "playing"
        elseif key == "escape" then
            love.event.quit()
        end
    end
end
