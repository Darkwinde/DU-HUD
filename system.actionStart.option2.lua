-- Darkwinde START: system.actionStart(option 2)
-- >> Option 1 is by default ALT+2


-- FEATURE START: trustControl
maxThrust = not maxThrust


if maxThrust then 
    Nav.axisCommandManager:deactivateGroundEngineAltitudeStabilization()
    Nav.axisCommandManager:updateCommandFromActionStart(axisCommandId.vertical, 1.0)   
else
    Nav.axisCommandManager:updateCommandFromActionStop(axisCommandId.vertical, -1.0)
    Nav.axisCommandManager:activateGroundEngineAltitudeStabilization(currentGroundAltitudeStabilization)
end

-- FEATURE END: trustControl



-- Darkwinde END: system.actionStart(option 2)