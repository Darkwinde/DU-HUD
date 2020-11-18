-- Darkwinde START: unit.stop()


-- FEATURE START: closeDoor

local environmentParameter = getEnvironmentParameter(environmentID)

if velocity <= environmentParameter["surfaceSpeedLow"] and 
   round(telemeter.getDistance()) <= environmentParameter["surfaceDistanceLow"] then 
    btnDoor.activate()
end



unit.stopTimer('HUD')


-- Darkwinde END: unit.start()