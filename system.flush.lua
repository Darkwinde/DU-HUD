-- Darkwinde START: system.flush()
-- Telemeter
-- >> Distance can be between 1 and 100. 
-- >> Scripting Wiki for telemeter is wrong. For MaxDistance it is mentioned 20m
-- >> !!! Telemeter even works (hidden) behind honeycomb
-- system.print(telemeter.getDistance())

local landing = true
local surfaceLow = true
local environmentParameter = getEnvironmentParameter(environmentID)
landing = telemeter.getDistance() > 0 and telemeter.getDistance() < environmentParameter["surfaceDistanceLanding"]
surfaceLow = telemeter.getDistance() > 0 and telemeter.getDistance() <= environmentParameter["surfaceDistanceLow"]

 

-- Start and landing condition to park on surface
if lockBrake then
    brakeInput = 1
    
    if surfaceLow then
        Nav.control.setEngineThrust("vertical, thrust", 0) -- default tags are in lower case
        Nav.axisCommandManager:deactivateGroundEngineAltitudeStabilization()
        Nav.axisCommandManager:setTargetGroundAltitude(0)
    end
end



-- Use brake to stabalize near ground level
if surfaceBrake and surfaceLow then
    brakeInput = 1
elseif surfaceBrake and not surfaceLow then
    surfaceBrake = false
    brakeInput = 0
elseif not surfaceBrake and surfaceLow then
    surfaceBrake = true
    brakeInput = 1
end



-- Extend and retract landing gear
if landing then
    Nav.control.extendLandingGears()
else
    Nav.control.retractLandingGears()
end





-- Darkwinde END: system.flush()