-- Darkwinde START: system.flush()
-- Telemeter
-- >> Distance can be between 1 and 100. 
-- >> Scripting Wiki for telemeter is wrong. For MaxDistance it is mentioned 20m
-- >> !!! Telemeter even works (hidden) behind honeycomb
-- system.print(telemeter.getDistance())
local environmentParameter = getEnvironmentParameter(environmentID)


-- Check if telemeter unit exists
if telemeter ~= nil then
    landing = telemeter.getDistance() > 0 and telemeter.getDistance() < environmentParameter["surfaceDistanceLanding"]
    surfaceLow = telemeter.getDistance() > 0 and telemeter.getDistance() <= environmentParameter["surfaceDistanceLow"]
end


-- Set general altitude stabilization according to the environment
if surfaceLow and unit.getSurfaceEngineAltitudeStabilization() ~= 0 and
       unit.getSurfaceEngineAltitudeStabilization() ~= environmentParameter["surfaceDistanceLow"] then
    unit.activateGroundEngineAltitudeStabilization(environmentParameter["surfaceDistanceLow"])
end
    

-- Start and landing condition to stay on surface
if lockBrake then
    brakeInput = 1
    
    if surfaceLow then
        unit.setEngineThrust("vertical thrust", 0) -- default tags are in lower case and space seperated
        unit.deactivateGroundEngineAltitudeStabilization()
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



-- In space it is not necessary to use engine stabilization / maneuver engine at high speed
if (environmentID == 2 and velocity_kmh > 5000) or not verticalEngines then
    unit.setEngineThrust("vertical thrust", 0)
    unit.deactivateGroundEngineAltitudeStabilization()
end



-- As we want the AGG to stabalize our altitude, we need to deactivate vertical engines
if antigrav ~= nil then
    local aggData = json.decode(antigrav.getData())
    -- But only in case we are within AGG field, outside happy maneuver
    if aggData.antiGPower > 0 then 
        unit.setEngineThrust("vertical thrust", 0)
        unit.deactivateGroundEngineAltitudeStabilization()
        
        -- Stop oscillate effect around target altitude
        if aggAltitudeTarget == aggData.baseAltitude and core.g() < 0.015 and velocity_kmh >= 1 then
            brakeInput = 1
        else
            
            -- Stop oscillate effect by short braking on high amplitude level
            -- Atmo brakes are not direcly at full force, therefor oscillate effect takes longer
            if aggAltitudeTarget ~= aggData.baseAltitude and core.g() < 0.015 and velocity_kmh > 15 then
                brakeInput = 1
            else
                brakeInput = 0
            end
        end  
    end
end
-- Darkwinde END: system.flush()