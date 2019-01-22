local physics = require("physics")
-- запускаем физику
physics.start()
physics.setGravity(0, 0)

-- рисуем шар
local ball = display.newCircle( display.contentCenterX, display.contentCenterY - 100, 30)
ball.fill = {1, 0.7, 0}
-- добавляем физическое тело шару
physics.addBody(ball, "dynamic", {bounce = 1})
ball:setLinearVelocity(800, 800)
ball.isFixedRotation = true
-- рисуем платформу
local platform = display.newRect( display.contentCenterX, display.contentHeight - 120, 200, 30)
platform.fill = {0, 0.7, 0.5}
-- добавляем ей физическое тело
physics.addBody(platform, "kinematic")

-- создаем "рамки": 4 прямоугольника на краях экрана
local frameSize = 30
local frames = {
	right = display.newRect( display.contentWidth - frameSize / 2, display.contentCenterY, frameSize, display.contentHeight),
	left = display.newRect( frameSize / 2, display.contentCenterY, frameSize, display.contentHeight),
	top = display.newRect( display.contentCenterX, frameSize / 2, display.contentWidth, frameSize),
	bottom = display.newRect( display.contentCenterX, display.contentHeight - frameSize / 2, display.contentWidth, frameSize)
}
for k,v in pairs(frames) do
	physics.addBody(v, "kinematic")
end

local platformSpeed = 500
local dPressed, aPressed
function onKeyEvent(event)
	local vx = 0
	if event.keyName == "a" then
		aPressed = event.phase == "down"
	end
	if event.keyName == "d" then
		dPressed = event.phase == "down"
	end
	if dPressed then
		vx = vx + platformSpeed
	end
	if aPressed then
		vx = vx - platformSpeed
	end
	platform:setLinearVelocity(vx, 0)
end
Runtime:addEventListener("key", onKeyEvent)

function onBlockHit(self, event)
	if event.phase == "ended" then
		display.remove(self)
	end
end

local blockWidth = 62
local blockHeight = 30
local padding = 11
for i=1,10 do
	for j=1,5 do
		local block = display.newRect( i * (blockWidth + padding), 30 + j * (blockHeight + padding), blockWidth, blockHeight)
		block.fill = {0.6, 0, 0}
		physics.addBody(block, "static")
		block.collision = onBlockHit
		block:addEventListener("collision")
	end
end

function onBottomHit(self, event)
	if event.phase == "began" then
		ball:setLinearVelocity(0, 0)
	end
end
frames.bottom.collision = onBottomHit
frames.bottom:addEventListener("collision")










