-- Darkwinde START: unit.start()


-- Initiate Globals START
version = "v0.2"
description = " - Minimalistic HUD from Darkwinde & Expugnator"


gravity = 9.81 -- m/s²
velocity = vec3(core.getWorldVelocity()) -- m/s²
velocity_kmh = round(vec3(core.getVelocity()):len() * 3.6) -- m/s²


habitats = {'Atmosphere', 'Space', 'Spacedock'} -- Default environments
surfaceDistanceLow = {15, 5, 5}  -- m
surfaceDistanceLanding = {40, 20, 20} -- m
surfaceDistanceHigh = {80, 80, 80} -- m
surfaceSpeedLow = {1, 1, 1} -- m/s²
environment = getEnvironmentName() -- Initialize environment name
environmentID = getEnvironmentID() -- Initialize environment ID


ftoAtmo = 3 --export: Level of Atmospheric Fuel Tank Otimization
ftoSpace = 3 --export: Level of Space Fuel Tank Otimization
ftoRocket = 0 --export: Level of Rocket Fuel Tank Otimization
myFuelTanks = getFuelTanks() -- initialize fuel tanks


payloadOverhead = 10 --export: Percentage safe factor to keep enougth trust to get from planet
vtolPlane = false --export: Is your ship a vertical take-off and landing plane without gyroscope


btcAtmo = 3 --export: Level of Atmospheric Brake Thrust Control
bhAtmo = 0 --export: Level of Atmospheric Brake Handling
fehAtmo = 3 --export: Level of Atmospheric Flight Element Handling


firstStart = true -- Indicator to show correct HUD messages
lockBrake = true --export: Default handbrake active 
surfaceBrake = true -- Default handbrake near surface active
surfaceLow = true -- Default to initialize distance check near surface
landing = true -- Default to initialize distance check if landing


hudMsgTimer = 5 --export: Message display timer
hudHTMLMsg = {} -- Message variable
-- Initiate Globals END

-- Hide Default Panels START
unit.hide() -- Hide unit (commander seat) widget
core.hide() -- Hide core widget
_autoconf.hideCategoryPanels() -- Hide fuel tanks widget
-- Hide Default Panels END


-- Initiate Elements START
-- Check for element existence
local telemeterExists = false
doorSwitchSlotName = "btnDoor" --export: Slot name of button door switch
for slotname, slot in pairs(unit) do
    -- Mandatory: Telemeter
    if type(slot) == "table" and slot.getElementClass then
        if slot.getElementClass():lower():find("telemeter") and slotname == "telemeter" then
            telemeterExists = true
        end
    end
    
    -- Optional: Door Switch
    if slotname == doorSwitchSlotName then
        doorSwitch = slot
        doorSwitch.deactivate()
    end
end


-- Display HUD critical message and initialize telemeter object with distance method
if not telemeterExists then
    setHTMLMessage(hudHTMLMsg, "Telemeter missing!<br>Attach one to your flight seat!", "critical")

    telemeter = {}
    function telemeter.getDistance()
        return 0
    end
end


-- Check for high speed and unlock handbrake on sit down
if lockBrake and velocity_kmh > 50 then
    lockBrake = not lockBrake
end


-- Initiate Elements END

-- Initiate Timers START
unit.setTimer('HUD', 1.5)
unit.setTimer('FUEL', 5)
-- Initiate Timers END


-- Darkwinde END: unit.start()