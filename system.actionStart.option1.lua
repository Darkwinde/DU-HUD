-- Darkwinde START: system.actionStart(option 1)
-- >> Option 1 is by default ALT+1


-- FEATURE START: brake
lockBrake = not lockBrake
brakeInput = 0


if not lockBrake then 
    Nav.control.setEngineThrust("booster_engine", 1)
    
    Nav.axisCommandManager:setTargetGroundAltitude(15)
    Nav.axisCommandManager:activateGroundEngineAltitudeStabilization(15)

end


-- FEATURE END: brake

-- Darkwinde END: system.actionStart(option 1)