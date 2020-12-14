-- Darkwinde START: unit.tick(HUD)


-- UPDATE GLOBALS START
up = vec3(core.getWorldVertical()) * -1
velocity = vec3(core.getWorldVelocity())
velocity_kmh = round(vec3(core.getVelocity()):len() * 3.6)
velocity_vertical =  round((velocity.x * up.x) + (velocity.y * up.y) + (velocity.z * up.z))

environment = getEnvironmentName()
environmentID = getEnvironmentID()

systemReference = PlanetRef()(Atlas())[0]
planet = systemReference:closestBody(core.getConstructWorldPos())
-- UPDATE GLOBALS END


local hudHTMLBody = {}
local hud_BrakeStatus = ternary(lockBrake, '<div class="on">on</div>', '<div class="off">off</div>')
local hud_Environment = ''
if environmentID == 3 then -- Spacedock
    hud_Environment = '<div style="color:#20b020; font-weight:bold;">' .. environment .. '</div>'

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


--local hud_MaxThrust = round(Nav:maxForceForward() / 1000) .. 'kN'
local hud_Throttle = ternary(Nav.axisCommandManager:getAxisCommandType(0) == 1, math.floor(unit.getThrottle() / 100) .. ' km/h', math.floor(unit.getThrottle()) .. '%')
local hud_FlightStyle = ternary(Nav.axisCommandManager:getAxisCommandType(0) == 1, 'cruise', 'travel')
-- Space core gravity is slightly above 10m/s², display adjustment required
local gravityAdjustment = ternary(environmentID == 3, 10, gravity) -- m/s²
local hud_LocalGravity = round((core.g() / gravityAdjustment), 2) .. 'g'
local hud_Altitude = round(core.getAltitude()) .. 'm'
local hud_SurfaceEstimation = ternary(planet.surface ~= -1, round(core.getAltitude() - planet.surface) .. 'm', '<div style="color:red; font-weight:bold;">Not In List</div>')
local hud_AtmosphereDensity = round(unit.getAtmosphereDensity() * 100) .. '%'
local hud_AirResistance = round(vec3(core.getWorldAirFrictionAcceleration()):len()) .. 'N'
local constructMass = core.getConstructMass() * (1 + payloadOverhead / 100) -- kg
local reqThrust = constructMass * core.g() -- N
local maxThrust = ternary(vtolPlane, Nav:maxForceUp(), Nav:maxForceForward()) -- N
local ratioThrust = round(maxThrust / reqThrust - 1, 2) -- >1: Space possible / =1: Flight possible / <1: Flight not possible
local maxMass = maxThrust / core.g() -- kg
local hud_RemainingPayloadLift = ternary(constructMass > maxMass, '<div style="color:red; font-weight:bold;">', '<div>') .. round((maxMass - constructMass) / 1000, 3) .. 't</div>'
local hud_TelemeterDistance = ternary(telemeter.getDistance() == 0, 'N/A', round(telemeter.getDistance()) .. 'm')


--local hud_Acceleration = round((vec3(core.getWorldAcceleration()):len() / gravity), 1) .. 'g'
local brakeDistanceSpeed0 = getBrakeDistance(0) -- km/h
local brakeDistanceSpeed2000 = getBrakeDistance(2000) -- km/h
local hud_Speed0 = brakeDistanceSpeed0["min"] .. "m:" .. brakeDistanceSpeed0["sec"] .. "s - " .. brakeDistanceSpeed0["su"] .. "su (" .. ternary(brakeDistanceSpeed0["km"] == 0, "0",  brakeDistanceSpeed0["km"]) .. "km)"
local hud_Speed2000 = brakeDistanceSpeed2000["min"] .. "m:" .. brakeDistanceSpeed2000["sec"] .. "s - " .. brakeDistanceSpeed2000["su"] .. "su (" ..  ternary(brakeDistanceSpeed2000["km"] == 0, "0", brakeDistanceSpeed2000["km"]) .. "km)"





hudHTMLBody[#hudHTMLBody + 1] = 
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
]]


hudHTMLBody[#hudHTMLBody + 1] =
[[
		<div class="spacer"></div>
		<div class="category">Speed...</div>
		<div class="primary control-container">
			<p class="primary">Speed: </p>
			]] .. velocity_kmh .. ' km/h' .. [[
		</div>
]]


-- Show only in atmosphere
hudHTMLBody[#hudHTMLBody + 1] = ternary(environmentID == 1,
[[
		<div class="primary control-container">
			<p class="primary">Vertical Velocity: </p>
			]] .. velocity_vertical .. ' m/s²' .. [[
		</div>
]]
, "")


hudHTMLBody[#hudHTMLBody + 1] =
[[
		<div class="spacer"></div>
		<div class="category">Braking...</div>
		<div class="primary control-container">
			<p class="primary">To full stop: </p>
			]] .. hud_Speed0 .. [[
		</div>
]]


-- Show only, if brake distance is higher
hudHTMLBody[#hudHTMLBody + 1] = ternary(brakeDistanceSpeed2000["time"] > 0, 
[[
		<div class="primary control-container">
			<p class="primary">To 2000 km/h: </p>
			]] .. hud_Speed2000 .. [[
		</div>
]]
, "")



hudHTMLBody[#hudHTMLBody + 1] = 
[[
		<div class="spacer"></div>
		<div class="category">Telemetric...</div>
          <div class="primary control-container">
			<p class="primary">Throttle:</p>
			]] .. hud_Throttle .. [[
		</div>
          <div class="primary control-container">
			<p class="primary">Flight Style:</p>
			]] .. hud_FlightStyle .. [[
		</div>
		<div class="primary control-container">
			<p class="primary">Locale Gravity: </p>
			]] .. hud_LocalGravity .. [[
		</div>
]]


-- Show only in atmosphere
hudHTMLBody[#hudHTMLBody + 1] = ternary(environmentID == 1, 
[[
    	<div class="primary control-container">
			<p class="primary">Sea Level: </p>
			]] .. hud_Altitude .. [[
		</div>
          <div class="primary control-container">
			<p class="primary">Estm. to surface: </p>
			]] .. hud_SurfaceEstimation .. [[
		</div>
    	 <div class="primary control-container">
			<p class="primary">Density: </p>
			]] .. hud_AtmosphereDensity .. [[
		</div>
          <div class="primary control-container">
			<p class="primary">Air Resistance: </p>
			]] .. hud_AirResistance .. [[
		</div>
    	 <div class="primary control-container">
			<p class="primary">Remaining Payload: </p>
			]] .. hud_RemainingPayloadLift .. [[
		</div>
]]
, "")


-- Show only near ground
hudHTMLBody[#hudHTMLBody + 1] = ternary(telemeter.getDistance() >= 0, 
[[
		<div class="primary control-container">
			<p class="primary">Obstacle Distance: </p>
			]] .. hud_TelemeterDistance .. [[
		</div>
]]
, "")



-- Show "complex" fuel tank information
if (myFuelTanks["atmospheric fuel tank"] ~= nil or myFuelTanks["space fuel tank"] ~= nil or myFuelTanks["rocket fuel tank"] ~= nil) then
	hudHTMLBody[#hudHTMLBody + 1] =
	[[
		<div class="spacer"></div>
		<div class="category">Fuel...</div>
	]]    
   
    local tmpHTMLFuelTanks = {["atmospheric fuel tank"]={},["space fuel tank"]={},["rocket fuel tank"]={}}
    for typ, tanks in pairs(myFuelTanks) do         
        for i, parameter in ipairs(tanks) do        
            local displayName = "N/A"
            local displayVolume = round(parameter["curvolume"] / parameter["maxvolume"] * 100)
            local displayVolumeLevel = round(parameter["curvolume"]) .. " / " .. round(parameter["maxvolume"]) .. "l"
            
            if typ == "atmospheric fuel tank" then
            	displayName = "Atmo " .. i
            elseif typ == "space fuel tank" then
            	displayName = "Space " .. i
            elseif typ == "rocket fuel tank" then
            	displayName = "Rocket " .. i
            end
    		 
            tmpHTMLFuelTanks[typ][#tmpHTMLFuelTanks[typ] + 1] = 
            [[
                <div class="primary control-container">
                    <p class="primary">]] .. displayName .. [[ </p>
                    ]] .. displayVolumeLevel .. "&nbsp;&nbsp;(" .. displayVolume .. "%)" .. [[  
                </div>
                <div class="primary2 control-container">
                    <p></p>
                    ]] .. parameter["constime"] .. [[
                </div>
            ]]
        end
    end
    
    -- Sort the unordered list: Atmo, Space, Rock
    hudHTMLBody[#hudHTMLBody + 1] = table.concat(tmpHTMLFuelTanks["atmospheric fuel tank"], "")
    hudHTMLBody[#hudHTMLBody + 1] = table.concat(tmpHTMLFuelTanks["space fuel tank"], "")
    hudHTMLBody[#hudHTMLBody + 1] = table.concat(tmpHTMLFuelTanks["rocket fuel tank"], "")
end




hudHTMLBody[#hudHTMLBody + 1] = 
[[  
	</div>
</div>
]]


local content = getHTMLHeader() .. orbitinterface() .. table.concat(hudHTMLBody, "")  .. [[<div class="msg">]] .. table.concat(hudHTMLMsg, "") .. [[</div>]] .. getHTMLFooter()
system.setScreen(content)
system.showScreen(1)






-- Darkwinde END: unit.tick(HUD)