-- Darkwinde START: unit.tick(HUD)


-- UPDATE GLOBALS START
velocity = vec3(core.getVelocity()):len()
velocity_kmh = round(velocity * 3.6)
velocity_vertical = round(core.getVelocity()[1])
environment = getEnvironmentName()
environmentID = getEnvironmentID()
-- UPDATE GLOBALS END



local hud_BrakeStatus = ternary(lockBrake, '<div class="on">on</div>', '<div class="off">off</div>')
local hud_Environment = ''
if environmentID == 3 then -- Spacedock
    hud_Environment = '<div style="color:green; font-weight:bold;">' .. environment .. '</div>'
    
    if not firstStart then
        setHTMLMessage(hudHTMLMsg, "You are docked!!!", "ok")
        firstStart = not firstStart
    end
else -- Atmo & Space
    hud_Environment = '<div>' .. environment .. '</div>'
    
    if firstStart then 
        firstStart = not firstStart
    end
end
local hud_Altitude = round(core.getAltitude()) .. 'm'
local hud_TelemeterDistance =  round(telemeter.getDistance()) .. 'm'
local hud_LocalGravity = round(core.g()/gravity, 1) .. 'g'



local brakeDistanceSpeed0 = getBrakeDistance(0) -- km/h
local brakeDistanceSpeed2000 = getBrakeDistance(2000) -- km/h

local hud_Speed0 = brakeDistanceSpeed0["min"] .. "m:" .. brakeDistanceSpeed0["sec"] .. "s - " .. brakeDistanceSpeed0["su"] .. "su (" .. brakeDistanceSpeed0["km"] .. "km)"
local hud_Speed2000 = brakeDistanceSpeed2000["min"] .. "m:" .. brakeDistanceSpeed2000["sec"] .. "s - " .. brakeDistanceSpeed2000["su"] .. "su (" .. brakeDistanceSpeed2000["km"] .. "km)"






local hudHTMLBody =
[[
	<div class="zen">
          <div class="controls-hud">
               <div class="category">Status...</div>
			<div class="primary control-container">
				<p class="primary">Handbrake:</p>
				]] .. hud_BrakeStatus .. [[
			</div>
			<div class="primary control-container">
				<p class="primary">Environment:</p>
				]] .. hud_Environment .. [[
			</div>


			<div class="spacer"></div>
               <div class="category">Telemetric...</div>
			<div class="primary control-container">
				<p class="primary">Surface Distance: </p>
				]] .. hud_TelemeterDistance .. [[
			</div>
]]
if environmentID == 1 then -- Atmo
    hudHTMLBody = hudHTMLBody .. 
[[
			<div class="primary control-container">
				<p class="primary">Sea Level: </p>
				]] .. hud_Altitude .. [[
			</div>
]]
end
hudHTMLBody = hudHTMLBody ..
[[
			<div class="primary control-container">
				<p class="primary">Locale Gravity: </p>
				]] .. hud_LocalGravity .. [[
			</div>


			<div class="spacer"></div>
               <div class="category">Speed...</div>
			<div class="primary control-container">
				<p class="primary">Vertical Velocity: </p>
				]] .. velocity_vertical .. ' m/s²' .. [[
			</div>
			<div class="primary control-container">
				<p class="primary">Speed: </p>
				]] .. velocity_kmh .. ' km/h' .. [[
			</div>

			<div class="spacer"></div>
			<div class="category">Braking...</div>
			<div class="primary control-container">
				<p class="primary">To full stop: </p>
				]] .. hud_Speed0 .. [[
			</div>
]]

if brakeDistanceSpeed2000["time"] > 0 then
    hudHTMLBody = hudHTMLBody .. 
[[
			<div class="primary control-container">
				<p class="primary">To 2000 km/h: </p>
				]] .. hud_Speed2000 .. [[
			</div>
]]
end

hudHTMLBody = hudHTMLBody .. 
[[  
		</div>
	</div>
]]



local content = getHTMLHeader() .. hudHTMLBody .. [[<div class="msg">]] .. table.concat(hudHTMLMsg, "") .. [[</div>]] .. getHTMLFooter()
system.setScreen(content)
system.showScreen(1)


-- Darkwinde END: unit.tick(HUD)