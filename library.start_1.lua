-- Darkwinde START: library.start()

-- Generic Initialization & Setup START

-- Default parameter initialization
function init()
    version = "v0.3.1"
    description = " - Minimalistic HUD from Darkwinde & Expugnator"
    gravity = 9.81 -- m/s²
    velocity = vec3(core.getWorldVelocity()) -- m/s²
    velocity_kmh = round(vec3(core.getVelocity()):len() * 3.6) -- m/s²


    habitats = {'Atmosphere', 'Space', 'Spacedock'} -- Default environments
    surfaceDistanceLow = {15, 1, 1}  -- m
    surfaceDistanceLanding = {40, 20, 20} -- m
    surfaceDistanceHigh = {80, 80, 80} -- m
    surfaceSpeedLow = {1, 1, 1} -- m/s²
    environment = getEnvironmentName() -- Initialize environment name
    environmentID = getEnvironmentID() -- Initialize environment ID


    firstStart = true -- Indicator to show correct HUD messages
    lockBrake = true -- Default handbrake active
    surfaceBrake = true -- Default handbrake near surface active
    surfaceLow = true -- Default to initialize distance check near surface
    landing = true -- Default to initialize distance check if landing
    docked = true -- Default docked mode
    verticalEngines = true -- Default vertical engines are deactivated on AGG use


    hudHTMLMsg = {} -- Message variable
end


-- On initiated parameter perform setup
function setup()
    -- Get fuel tanks
    myFuelTanks = getFuelTanks()



    -- Check for element existence
    telemeterExists = false
    for slotname, slot in pairs(unit) do
        
        if type(slot) == "table" and slot.getElementClass then
            -- Mandatory: Telemeter
            if slot.getElementClass():lower():find("telemeter") and slotname == "telemeter" then
                telemeterExists = true
            end

            -- Optional: DataBank
            if slot.getElementClass():lower():find("databank") and db_extension_agg == nil then
                -- Check for extension - AGG Screen
                if slot.hasKey("agg_target_altitude") == 1 then
                    db_extension_agg = slot
                end
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
    end


    -- Check for high speed and unlock handbrake on sit down
    if lockBrake and velocity_kmh > 50 then
        lockBrake = not lockBrake
    end
    
    -- Hide Default Panels START
    unit.hide() -- Hide unit (commander seat) widget
    core.hide() -- Hide core widget
    if _autoconf ~= nil then _autoconf.hideCategoryPanels() end -- Hide auto DU widget
    if antigrav ~= nil then -- Hide AGG widget and get target altitude
        if db_extension_agg ~= nil then
            aggAltitudeTarget = db_extension_agg.getIntValue("agg_target_altitude") 
        else
            aggAltitudeTarget = antigrav.getBaseAltitude()
        end
        antigrav.setBaseAltitude(aggAltitudeTarget)
        antigrav.hide()
    end   


    -- Start timer
    unit.setTimer('HUD', 0.5)
    unit.setTimer('FUEL', 5)
end

-- Generic Initialization & Setup END


-- Generic Functions START

-- Return dumped information in a human readable string
function dump(o)
    if type(o) == 'table' then
        local s = '{ '
        for k,v in pairs(o) do
            if type(k) ~= 'number' then 
                k = '"' .. k .. '"' 
            end
            s = s .. '[' .. k .. '] = ' .. dump(v) .. ','
        end
        return s .. '} '
    else
        return tostring(o)
    end
end


-- If condition is TRUE return variable T else variable F
-- >> Used at feature: system.update() -> hudShowBrakeStatus
function ternary(cond, T, F)
    if cond ~= nil and cond then
        return T
    else
        return F
    end
end



-- Round float number to certain digits
function round(num, numDecimalPlaces)
    local mult = 10 ^ (numDecimalPlaces or 0)
    if numDecimalPlaces ~= nil then
        return math.floor(num * mult + 0.5) / mult
    else
        return math.floor((num * mult + 0.5) / mult)
    end
end


-- Format numbers to look nice
-- credit http://richard.warburton.it
function format_number(n) 
    local left,num,right = string.match(n,'^([^%d]*%d)(%d*)(,-)$')
    return left..(num:reverse():gsub('(%d%d%d)','%1 '):reverse()) .. right
end

-- Generic Functions END



-- Getter & Setter START

-- HTML header part for the HUD
function getHTMLHeader()
    PrimaryR = 130
    PrimaryG = 224
    PrimaryB = 255
    rgb = [[rgb(]] .. math.floor(PrimaryR+0.5) .. "," .. math.floor(PrimaryG+0.5) .. "," .. math.floor(PrimaryB+0.5) .. [[)]]
    rgbdim = [[rgb(]] .. math.floor(PrimaryR *0.9 + 0.5) .. "," .. math.floor(PrimaryG * 0.9 + 0.5) .. "," .. math.floor(PrimaryB * 0.9 + 0.5) .. [[)]]

    local bright = rgb
    local dim = rgbdim
    local brightOrig = rgb
    local dimOrig = rgbdim

    
local header =
string.format([[
<head>
<style>
        body {margin:0}
        svg {position:absolute; top:0; left:0; font-family:Montserrat;} 
        .line {stroke-width:2px; fill:none}
        .linethick {stroke-width:3px; fill:none}
        .bright {fill:%s; stroke:%s}
        .pbright {fill:%s; stroke:%s}
        .dim {fill:%s; stroke:%s}
        .pdim {fill:%s; stroke:%s}
        .red {fill:red; stroke:red}
        .redout {fill:none; stroke:red}
        .op30 {opacity:0.3}
        .op10 {opacity:0.1}     
        .txtstart {text -anchor:start}
        .txtmid {text-anchor:middle}
        .txtend {text-anchor:end}
        .txtorb {font-size:12px}
        .txtorbbig {font-size:18px}

        .primary {font-size:0.8rem; color:#B6DFED;}
        .primary2 {font-size:0.65rem; color:#B6DFED;}
        .zen {display:flex; flex-direction:column;}
        .controls-hud {top:25%%; right:0.7%%; position:absolute; display:flex; flex-direction:column; 
                       width:16%%; padding:0.5%% 0.8%%; overflow:none; justify-content:space-around; 
                       background-color:#34495E80; border-color:#333333; border-radius:12px;}
        .control-container {display:flex; justify-content:space-between; padding:0.5%%; }
        .category {color:#ffffff; font-size:1rem; text-align:center; margin:0.4rem;}
        .spacer {margin-top:1rem; border-top:1px solid #ffffff;}
        .on_g {background-color:green; margin-left:10px; border-radius:50%%; width:22px; 
             height:22px; border:2px solid black; text-align:center;}
        .on_r {background-color:red; margin-left:10px; border-radius:50%%; width:22px; 
             height:22px; border:2px solid black; text-align:center;}
        .off {background-color:none; margin-left:10px; border-radius:50%%; width:22px; 
             height:22px; border:2px solid transparent; text-align:center;}
        .msg {position:absolute; top:50%%; left:50%%; 
              -moz-transform:translateX(-50%%) translateY(-50%%);
              -webkit-transform:translateX(-50%%) translateY(-50%%);
              transform:translateX(-50%%) translateY(-50%%); text-align:center;}
        .info {font-size:1.8rem; color:#B6DFED;}
        .ok {font-size:2.5rem; color:green;}
        .warning {font-size:2.5rem; color:yellow;}
        .critical {font-size:3.5rem; color:red;}
        .version {position:absolute; bottom:0; right:0; width:100%%; height:0.5rem; 
                  font-size:0.55rem; text-align:right;}
</style>
</head>
<body>
<svg height="100%%" width="100%%" viewBox="0 0 1920 1080">
]], bright, bright, brightOrig, brightOrig, dim, dim, dimOrig, dimOrig)
    
    
return header
end


-- HTML footer part for the HUD
function getHTMLFooter()
    return  string.format([[</svg><div class="version">%s %s</div></body>]], version, description)
end


-- HTML HUD message
function setHTMLMessage(hudHTMLMsg, msg, msgtype)    
    if msgtype == nil then
        msgtype = "info"
    end
    
    for str in string.gmatch(msg, "([^\n]+)") do
        hudHTMLMsg[#hudHTMLMsg + 1] = string.format([[<div class="%s">%s</div>]], msgtype, str)
    end
    
    unit.setTimer("HUDMsg", hudMsgTimer)
end  


-- Get current environment information returned as ID or name
function getEnvironmentID()
    if unit.getAtmosphereDensity() > 0.0 then -- Atmo
        return  1
    elseif core.g() >= gravity then -- Spacedock
        return 3
    else -- Space
        return 2
    end
end
function getEnvironmentName(id)  
    if id ~= nil then
        return habitats[id]
    end
    
    if unit.getAtmosphereDensity() > 0.0 then -- Atmo
        return  habitats[1]
    elseif core.g() >= gravity then -- Spacedock
       return habitats[3]
    else -- Space
        return habitats[2]
    end
end
function getEnvironmentParameter(id) 
    local returnValue = {}
    
    if id ~= nil then -- ID based
        returnValue["habitat"] = habitats[id]
        returnValue["surfaceDistanceLow"] = surfaceDistanceLow[id]
        returnValue["surfaceDistanceLanding"] = surfaceDistanceLanding[id]
        returnValue["surfaceDistanceHigh"] = surfaceDistanceHigh[id]
        returnValue["surfaceSpeedLow"] = surfaceSpeedLow[id]
    else
        if unit.getAtmosphereDensity() > 0.0 then -- Atmo
            returnValue["habitat"] = habitats[1]
            returnValue["surfaceDistanceLow"] = surfaceDistanceLow[1]
            returnValue["surfaceDistanceLanding"] = surfaceDistanceLanding[1]
            returnValue["surfaceDistanceHigh"] = surfaceDistanceHigh[1]
            returnValue["surfaceSpeedLow"] = surfaceSpeedLow[1]
        elseif core.g() >= gravity then -- Spacedock
            returnValue["habitat"] = habitats[3] 
            returnValue["surfaceDistanceLow"] = surfaceDistanceLow[3]
            returnValue["surfaceDistanceLanding"] = surfaceDistanceLanding[3]
            returnValue["surfaceDistanceHigh"] = surfaceDistanceHigh[3]
            returnValue["surfaceSpeedLow"] = surfaceSpeedLow[3]
        else -- Space
            returnValue["habitat"] = habitats[2]
            returnValue["surfaceDistanceLow"] = surfaceDistanceLow[2]
            returnValue["surfaceDistanceLanding"] = surfaceDistanceLanding[2]
            returnValue["surfaceDistanceHigh"] = surfaceDistanceHigh[2]
            returnValue["surfaceSpeedLow"] = surfaceSpeedLow[2]
        end 
    end

    return returnValue
end


function getBrakeDistance(endingSpeed)
    local returnValue = {}
    local distance = 0;
    local time = 0;
    local c = 30000*1000/3600
    local c2 = c*c

    
    local initialSpeed = vec3(core.getVelocity()):len() -- m/s
    --local initialSpeed = 20000 / 3.6 -- m/s --> For Testing
    endingSpeed = endingSpeed / 3.6 -- m/s
    local restMass = round(core.getConstructMass()) -- kg
    local maxBrake = json.decode(unit.getData()).maxBrake -- N
    if maxBrake == nil then -- check if in Atmo, as unit does not contain information. Bug?!?
        local airFriction = round(vec3(core.getWorldAirFrictionAcceleration()):len(), 5)
        maxBrake = airFriction + getMaxBrakeAtmo() -- N
    end
    local totA = -maxBrake * (1-0)/restMass;

    
    if initialSpeed > endingSpeed then
        local k1 = c * math.asin(initialSpeed / c)
        local k2 = c2 * math.cos(k1 / c) / totA
        time = (c * math.asin(endingSpeed / c) - k1) / totA
        distance = k2 - c2 * math.cos((totA * time + k1) / c) / totA
    end

    
    local min = math.floor(time / 60)   
    local timeFrac = time - 60 * min
    local sec = round(timeFrac)
    local su = math.floor(distance / 200000)
    local remainder = distance - 200000 * su
    local suFrac = round(100 * remainder / 200000) / 100
    local km = ternary(distance < 1000, round(distance / 1000, 3), round(distance / 1000))


    returnValue["min"] = string.format("%02d", min)
    returnValue["sec"] = string.format("%02d", sec)
    returnValue["su"] = su + suFrac
    returnValue["km"] = km
    returnValue["time"] = time
    returnValue["distance"] = distance


    return returnValue
end



atmoBrakes = {["S"] = {["thrust"]= 50000, ["mass"]= 55.55, ["hp"]= 50}, ["M"] = {["thrust"]= 500000, ["mass"]= 285.25, ["hp"]= 50}, ["L"] = {["thrust"]= 5000000, ["mass"]= 1500, ["hp"]= 767}}
function getMaxBrakeAtmo()
    local returnValue = 0
    
    -- Not realy cool, but works good as possible
    -- unit.getData() should be fixed by NQ
    -- Get atmospheric brake list from core
    for _, el in ipairs(core.getElementIdList()) do
        -- Get element information
        local typ  = core.getElementTypeById(el):lower()
        local name  = core.getElementNameById(el):lower()
        local mass = core.getElementMassById(el)    
        local hp = core.getElementMaxHitPointsById(el)
        
        
        if typ == "atmospheric airbrake" then
            -- Get brake parameter
            local size = "S" -- default size     
            if mass >= atmoBrakes["L"]["mass"] then 
                size = "L"
            elseif mass >= atmoBrakes["M"]["mass"] then 
                size = "M"
            end
            
            -- Apply atmospheric brake skills
            local atmosphericBrakeThrustControl = atmoBrakes[size]["thrust"] * btcAtmo * 0.1
            local atmosphericBrakeHandling = atmoBrakes[size]["thrust"] * bhAtmo * 0.1
            local atmosphericFlightElementhandling = 1 + fehAtmo * 0.02
            
            returnValue = returnValue + (atmoBrakes[size]["thrust"] + atmosphericBrakeThrustControl + atmosphericBrakeHandling) * atmosphericFlightElementhandling
        end
	end
    
    return returnValue
end







fuel = {["atmospheric fuel tank"] = 4, ["space fuel tank"] = 6, ["rocket fuel tank"] = 0.8}
fuelTanks = {["atmospheric fuel tank"] = {["XS"] = {["volume"]= 100, ["mass"]= 35.03, ["hp"]= 50}, ["S"] = {["volume"]= 400, ["mass"]= 182.67, ["hp"]= 163}, ["M"] = {["volume"]= 1600, ["mass"]= 988.67, ["hp"]= 1315}, ["L"] = {["volume"]= 12800, ["mass"]= 5480, ["hp"]= 10461}}, ["space fuel tank"] = {["S"] = {["volume"]= 400, ["mass"]= 182.67, ["hp"]= 187}, ["M"] = {["volume"]= 1600, ["mass"]= 988.67, ["hp"]= 1496}, ["L"] = {["volume"]= 12800, ["mass"]= 5480, ["hp"]= 15933}}, ["rocket fuel tank"] = {["XS"] = {["volume"]= 400, ["mass"]= 173.42, ["hp"]= 366}, ["S"] = {["volume"]= 800, ["mass"]= 886.72, ["hp"]= 736}, ["M"] = {["volume"]= 6400, ["mass"]= 4720, ["hp"]= 6231}, ["L"] = {["volume"]= 50000, ["mass"]= 25740, ["hp"]= 68824}}}
function getFuelTanks()
    local returnValue = {}
    
    -- Get fuel tank list from core
    for _, el in ipairs(core.getElementIdList()) do
        -- Get element information
        local typ  = core.getElementTypeById(el):lower()
        local name  = core.getElementNameById(el):lower()
        local mass = core.getElementMassById(el)    
        local hp = core.getElementMaxHitPointsById(el)
        local emptyMass, curMass, maxVolume, curVolume, consVolume, consTime = 0, 0, 0, 0, 0, "0h:0m:0s"
        local curTime = system.getTime()
        -- Define fuel tank handling skills for later use by reference
        local fuelTankSkills = {["atmospheric fuel tank"] = fthAtmo, ["space fuel tank"] = fthSpace, ["rocket fuel tank"] = fthRocket}

        -- Check if element is the one we are searching for (defined in the array)
        if fuelTanks[typ] ~= nil then
            -- Initialize array for later use
            if returnValue[typ] == nil then
                returnValue[typ] = {}
            end

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
            emptyMass = fuelTanks[typ][size]["mass"]
            curMass = mass - emptyMass
            
            
            -- looks like a bug on fuel tanks mass reduction as container optimization also is impacting 
            ftoVolume = (1 - fto * (0.05)) * (1 - coo * (0.05))
            maxVolume = fuelTanks[typ][size]["volume"]
            curVolume = round(curMass / (fuel[typ] * ftoVolume), 2) 
            
            
            -- Check and apply for fuel tank handling skills (Piloting)
            if fuelTankSkills[typ] > 0 and fuelTankSkills[typ] ~= nil then
                maxVolume = fuelTanks[typ][size]["volume"] * (1 + fuelTankSkills[typ] * 0.2)
            end
                      

            -- Add fuel tank information to my personal list
            returnValue[typ][#returnValue[typ] + 1] = {["id"]=el, ["name"]=name, ["maxvolume"]=maxVolume, ["curvolume"]=curVolume, ["emptymass"]=emptyMass, ["curmass"]=curMass, ["consvolume"]=consVolume, ["constime"]=consTime, ["time"]=curTime}
        end
    end
    
    return returnValue
end
-- Getter & Setter END



-- Appending Functions START
function Navigator.maxForceUp(self)
    local axisCRefDirection = vec3(self.core.getConstructOrientationUp())
    local verticalEngineTags = 'thrust analog vertical not_ground'
    local maxKPAlongAxis = self.core.getMaxKinematicsParametersAlongAxis(verticalEngineTags, {axisCRefDirection:unpack()})
    if self.control.getAtmosphereDensity() <= 0.1 then -- we can use space engines
        return maxKPAlongAxis[3]
    else
        return maxKPAlongAxis[1]
    end
end
-- Appending Functions END
-- Darkwinde END: library.start()