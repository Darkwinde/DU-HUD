-- Darkwinde START: system.flush()


local obstacleLow = telemeter.getDistance() < 14 and telemeter.getDistance() > 0
local obstacleHover = telemeter.getDistance() >= 14 and telemeter.getDistance() > 0
local obstacleLanding = telemeter.getDistance() < 80 and telemeter.getDistance() > 0
-- >> Distance can be between 1 and 100. 
-- >> Scripting Wiki for telemeter is wrong. For MaxDistance it is mentioned 20m
-- >> !!! Telemeter even works (hidden) behind honeycomb
--system.print(telemeter.getDistance())


-- FEATURE START: brake
if lockBrake then 
    brakeInput = 1
    
    Nav.control.setEngineThrust("booster_engine", 0)    
    Nav.axisCommandManager:deactivateGroundEngineAltitudeStabilization()
    Nav.axisCommandManager:setTargetGroundAltitude(0)
end


if surfaceBrake then
     brakeInput = 1
end


if surfaceBrake and not obstacleLow then
    surfaceBrake = false
    brakeInput = 0
end


if not surfaceBrake and obstacleLow then
    surfaceBrake = true
    brakeInput = 1
end
-- FEATURE END: brake



-- FEATURE START: landingGear
if obstacleHover then
    Nav.axisCommandManager:deactivateGroundEngineAltitudeStabilization()
end

if obstacleLanding then
    Nav.control.extendLandingGears()
else
    Nav.control.retractLandingGears()
end
-- FEATURE END: landingGear




-- Darkwinde END: system.flush()