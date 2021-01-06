-- Darkwinde START: unit.start()
-- Initiate Globals START
init()
-- Initiate Globals END



-- Initiate Personal Parameter START
coo = 4 --export: Level of Container Optimization (Mining & Inventory) - 5% mass put down reduction per level
fto = 3 --export: Level of Fuel Tank Optimization (Mining & Inventory) - 5% mass put down reduction per level
fthAtmo = 3 --export: Level of Atmospheric Fuel Tank Handling (Piloting) - 20% more volume put down increase per level 
fthSpace = 3 --export: Level of Space Fuel Tank Tank Handling (Piloting) - 20% more volume put down increase per level 
fthRocket = 0 --export: Level of Rocket Fuel Tank Tank Handling (Piloting) - 20% more volume put down increase per level

payloadOverhead = 25 --export: Percentage safe factor to keep enougth trust to get from planet
vtolPlane = false --export: Is your ship a vertical take-off and landing plane without gyroscope

btcAtmo = 3 --export: Level of Atmospheric Brake Thrust Control
bhAtmo = 0 --export: Level of Atmospheric Brake Handling
fehAtmo = 3 --export: Level of Atmospheric Flight Element Handling

aggAltitudeChange = 100 --export: AGG altitude increase / decrease level in meter

hudMsgTimer = 5 --export: Message display timer

doorSwitchSlotName = "btnDoor" --export: Slot name of button door switch
-- Initiate Personal Parameter END



-- Initiate Personal Setup START
setup()
-- Initiate Personal Setup END
-- Darkwinde END: unit.start()