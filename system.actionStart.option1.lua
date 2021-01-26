-- Darkwinde START: system.actionStart(option 1)
-- >> Option 1 is by default ALT+1


-- Take off script by releasing brake and setting altitude level
lockBrake = not lockBrake


if not lockBrake then
    brakeInput = 0
    docked = false

    local environmentParameter = getEnvironmentParameter(environmentID)        
    unit.setEngineThrust("vertical thrust", 1) -- default tags are in lower case    
    unit.activateGroundEngineAltitudeStabilization(environmentParameter["surfaceDistanceLow"])

    if firstStart then
        setHTMLMessage(hudHTMLMsg, "TAKE OFF \n Have a nice flight!")
    end
end


-- Darkwinde END: system.actionStart(option 1)