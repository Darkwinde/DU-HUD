-- Darkwinde START: system.actionStart(option 1)
-- >> Option 1 is by default ALT+1

-- Take off script by releasing brake and setting altitude level
lockBrake = not lockBrake


if not lockBrake then
    local environmentParameter = getEnvironmentParameter(environmentID)
    
    
    Nav.control.setEngineThrust("vertical, thrust", 1) -- default tags are in lower case

    Nav.axisCommandManager:setTargetGroundAltitude(environmentParameter["surfaceDistanceLow"])
    Nav.axisCommandManager:activateGroundEngineAltitudeStabilization(environmentParameter["surfaceDistanceLow"])

    
    brakeInput = 0
 
    if firstStart then
        setHTMLMessage(hudHTMLMsg, "TAKE OFF \n Have a nice flight!")
    end
end




-- Darkwinde END: system.actionStart(option 1)