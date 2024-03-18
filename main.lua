-- Simple Asteroids Clone in Love2D Lua

local player = { x = 400, y = 300, angle = 0, speed = 0, maxSpeed = 400, radius = 10 }
local bullets = {}
local asteroids = {}
local asteroidSize = 3
local gameOver = false

function love.load()
    love.window.setTitle("Simple Asteroids Clone")
    love.window.setMode(800, 600)
    love.graphics.setBackgroundColor(0, 0, 0)

    -- Create asteroids
    local numAsteroids = love.math.random(3, 6) -- Random amount of asteroids between 3 and 6
    for i = 1, numAsteroids do
        local asteroid = {
            x = love.math.random(0, 800),
            y = love.math.random(0, 600),
            angle = love.math.random() * math.pi * 2,
            speed = love.math.random(50, 150),
            size = asteroidSize
        }
        table.insert(asteroids, asteroid)
    end
end

function love.update(dt)
    if not gameOver then
        -- Player movement
        if love.keyboard.isDown("up") then
            player.speed = player.speed + 100 * dt
        else
            player.speed = player.speed - 100 * dt
        end

        if love.keyboard.isDown("left") then
            player.angle = player.angle - 3 * dt
        elseif love.keyboard.isDown("right") then
            player.angle = player.angle + 3 * dt
        end

        -- Limit player speed
        player.speed = math.max(0, math.min(player.speed, player.maxSpeed))

        -- Update player position
        player.x = player.x + player.speed * math.cos(player.angle) * dt
        player.y = player.y + player.speed * math.sin(player.angle) * dt

        -- Wrap player around the screen
        if player.x < 0 then
            player.x = 800
        elseif player.x > 800 then
            player.x = 0
        end

        if player.y < 0 then
            player.y = 600
        elseif player.y > 600 then
            player.y = 0
        end

        -- Update bullets
        for i, bullet in ipairs(bullets) do
            bullet.x = bullet.x + bullet.speed * math.cos(bullet.angle) * dt
            bullet.y = bullet.y + bullet.speed * math.sin(bullet.angle) * dt

            -- Remove bullets when they go off-screen
            if bullet.x < 0 or bullet.x > 800 or bullet.y < 0 or bullet.y > 600 then
                table.remove(bullets, i)
            end

            -- Check for bullet-asteroid collision
            for j, asteroid in ipairs(asteroids) do
                if distance(bullet.x, bullet.y, asteroid.x, asteroid.y) < 20 * asteroid.size then
                    table.remove(bullets, i)
                    if asteroid.size > 1 then
                        local newAsteroid = {
                            x = asteroid.x,
                            y = asteroid.y,
                            angle = love.math.random() * math.pi * 2,
                            speed = love.math.random(50, 150),
                            size = asteroid.size - 1
                        }
                        table.insert(asteroids, newAsteroid)
                        table.insert(asteroids, newAsteroid)
                    end
                    table.remove(asteroids, j)
                    break
                end
            end
        end

        -- Update asteroids
        for i, asteroid in ipairs(asteroids) do
            asteroid.x = asteroid.x + asteroid.speed * math.cos(asteroid.angle) * dt
            asteroid.y = asteroid.y + asteroid.speed * math.sin(asteroid.angle) * dt

            -- Wrap asteroids around the screen
            if asteroid.x < 0 then
                asteroid.x = 800
            elseif asteroid.x > 800 then
                asteroid.x = 0
            end

            if asteroid.y < 0 then
                asteroid.y = 600
            elseif asteroid.y > 600 then
                asteroid.y = 0
            end

            -- Check for asteroid-player collision
            if distance(player.x, player.y, asteroid.x, asteroid.y) < player.radius + 20 * asteroid.size then
                gameOver = true
            end
        end
    end
end

function love.draw()
    -- Draw player
    love.graphics.setColor(255, 255, 255)
    love.graphics.circle("line", player.x, player.y, player.radius)

    -- Draw bullets
    for _, bullet in ipairs(bullets) do
        love.graphics.circle("fill", bullet.x, bullet.y, 3)
    end

    -- Draw asteroids
    for _, asteroid in ipairs(asteroids) do
        love.graphics.circle("line", asteroid.x, asteroid.y, 20 * asteroid.size)
    end

    -- Draw game over message if necessary
    if gameOver then
        love.graphics.setColor(255, 0, 0)
        love.graphics.print("Game Over", 350, 280)
    end
end

function love.keypressed(key)
    if key == "space" then
        -- Shoot bullet
        local bulletSpeed = 600
        local bullet = {
            x = player.x,
            y = player.y,
            angle = player.angle,
            speed = bulletSpeed
        }
        table.insert(bullets, bullet)
    end
end

-- Helper function to calculate distance between two points
function distance(x1, y1, x2, y2)
    return math.sqrt((x2 - x1)^2 + (y2 - y1)^2)
end
