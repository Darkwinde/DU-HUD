-- Darkwinde START: unit.tick(FUEL)

-- Update fuel tank list
for typ, tanks in pairs(myFuelTanks) do
    for i, parameter in ipairs(tanks) do
        -- Get element information
        local id = parameter["id"]
        local typ  = core.getElementTypeById(id):lower()
        local name  = core.getElementNameById(id):lower()
        local mass = core.getElementMassById(id)    
        local hp = core.getElementMaxHitPointsById(id)
        local emptyMass, curMass, maxVolume, curVolume, consVolume, consTime = 0, 0, 0, 0, 0, 0
        local curTime = system.getTime()
        -- Define fuel tank skills for later use by reference
        local fuelTankSkills = {["atmospheric fuel-tank"] = fthAtmo, ["space fuel-tank"] = fthSpace, ["rocket fuel-tank"] = fthRocket}

        
        -- Get fuel tank parameter
        local size = "XS" -- default size     
        if hp >= fuelTanks[typ]["L"]["hp"] then 
            size = "L"
        elseif hp >= fuelTanks[typ]["M"]["hp"] then 
            size = "M"
        elseif hp >= fuelTanks[typ]["S"]["hp"] then 
            size = "S"
        end

        
        -- Calculate tank mass
        emptyMass = round(fuelTanks[typ][size]["mass"])
        curMass = round(mass - emptyMass, 2)

        
        -- looks like a bug on fuel tanks mass reduction as container optimization also is impacting 
        ftoVolume = (1 - fto * (0.05)) * (1 - coo * (0.05))
        maxVolume = fuelTanks[typ][size]["volume"]
        curVolume = round(curMass / (fuel[typ] * ftoVolume), 2) 
        

        -- Calculate consumed fuel and remaining time until empty
        consVolume = parameter["curvolume"] - curVolume
        if consVolume > 0 then
            consTime = curVolume / (consVolume / (curTime - parameter["time"]))
        end

        
        local h = math.floor(consTime / 3600)
        local timeFrac1 = consTime - 3600 * h
        local min = math.floor(timeFrac1 / 60)
        local timeFrac2 = timeFrac1 - 60 * min
        local sec = round(timeFrac2)
        consTime = h .. "h:" ..min .. "m:" .. sec .. "s"


        -- Check and apply for fuel tank handling skills (Piloting)
        if fuelTankSkills[typ] ~= nil and fuelTankSkills[typ] > 0 then
            maxVolume = maxVolume * (1 + fuelTankSkills[typ] * 0.2)
        end

        -- Update fuel tank information
        parameter["curvolume"] = curVolume
        parameter["curmass"] = curMass
        parameter["consvolume"] = consVolume
        parameter["constime"] = consTime
        parameter["time"] = curTime
    end
end





-- Darkwinde END: unit.tick(FUEL)