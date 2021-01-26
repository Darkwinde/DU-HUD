-- Darkwinde START: unit.stop()

local environmentParameter = getEnvironmentParameter(environmentID)
if doorSwitch ~= nil and velocity_kmh <= environmentParameter["surfaceSpeedLow"] and telemeterExists and
    round(telemeter.getDistance()) <= environmentParameter["surfaceDistanceLow"] then 
    doorSwitch.activate()
end

unit.stopTimer('HUD')
-- Darkwinde END: unit.start()