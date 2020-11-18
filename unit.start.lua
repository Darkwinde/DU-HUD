-- Darkwinde START: unit.start()


-- Initiate Globals START
version = "v0.1"
description = " - Minimalistic HUD from Darkwinde & Expugnator"


gravity = 9.81 -- m/s²
velocity = 0 -- m/s²
velocity_kmh = 0 -- km/h


habitats = {'Atmosphere', 'Space', 'Spacedock'}
surfaceDistanceLow = {15, 5, 5}  -- m
surfaceDistanceLanding = {40, 20, 20} -- m
surfaceDistanceHigh = {80, 80, 80} -- m
surfaceSpeedLow = {1, 1, 1} -- m/s²
environment = getEnvironmentName()
environmentID = getEnvironmentID()


firstStart = true
lockBrake = true
surfaceBrake = true


hudMsgTimer = 5
hudHTMLMsg = {}
-- Initiate Globals END


-- Initiate Elements START
btnDoor.deactivate()
-- Initiate Elements END

-- Initiate Timers START
unit.setTimer('HUD', 0.5)
-- Initiate Timers END


-- Darkwinde END: unit.start()