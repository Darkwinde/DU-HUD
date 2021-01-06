-- Darkwinde START: system.actionStart(option 9)
-- >> Option 9 is by default ALT+9


if antigrav ~= nil and aggAltitudeTarget > 1000 then
    aggAltitudeTarget =  math.floor(aggAltitudeTarget / 100) * aggAltitudeChange - aggAltitudeChange
    antigrav.setBaseAltitude(math.floor(aggAltitudeTarget))
    
    if db_extension_agg ~= nil then 
        db_extension_agg.setIntValue("agg_target_altitude", aggAltitudeTarget) 
    end
end


-- Darkwinde END: system.actionStart(option 9)