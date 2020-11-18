-- Darkwinde START: library.start()

-- Generic Functions START

-- Return dumped information in a humal readable string
function dump(o)
	if type(o) == 'table' then
		local s = '{ '
		for k,v in pairs(o) do
			if type(k) ~= 'number' then 
				k = '"'..k..'"' 
			end
			s = s .. '['..k..'] = ' .. dump(v) .. ','
		end
		return s .. '} '
	else
		return tostring(o)
	end
end


-- If condition is TRUE return variable T else variable F
-- >> Used at feature: system.update() -> hudShowBrakeStatus
function ternary(cond, T, F)
	if cond then
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


-- Generic Functions END



-- Getter & Setter START

-- HTML header part for the HUD
function getHTMLHeader()
	return 
	[[
	<head>
	<style>
     body {margin: 0}
     .primary 
	{
		font-size: 1rem;
		color: #B6DFED;
	}
	.zen 
	{
		display: flex;
		flex-direction: column;
	}
	.controls-hud 
	{
		display: flex;
		flex-direction: column;
		justify-content: space-around;
		background-color: #34495E80;
		border-color: #333333;
		border-radius: 12px;
		width: 25%;
		padding: 1% 1.5%;
		overflow: none;
	}
	.control-container 
	{
		display: flex;
		justify-content: space-between;
		padding: 0.5%;
	}
	.category 
	{
		color: #ffffff;
          font-size: 1rem;
		text-align: center;
	}
	.spacer 
	{
		margin: 3px;
		border-top: 1px solid #ffffff;
	}
	.on 
	{
		background-color: red;
		margin-left: 10px;
		border-radius: 50%;
		width: 28px;
		height: 28px;
		border: 2px solid black;
		text-align: center;
	}
	.off 
	{
		background-color: green;
		margin-left: 10px;
		border-radius: 50%;
		width: 28px;
		height: 28px;
		border: 2px solid black;
		text-align: center;
	}
	.msg 
	{
		position: absolute;
		top: 50%;
		left: 50%;
		-moz-transform: translateX(-50%) translateY(-50%);
		-webkit-transform: translateX(-50%) translateY(-50%);
		transform: translateX(-50%) translateY(-50%);
		text-align: center;
	}
    .info {font-size: 1.8rem; color: #B6DFED;}
    .ok {font-size: 2.5rem; color: green;}
    .warning {font-size: 2.5rem; color: yellow;}
    .critical {font-size: 3.5rem; color: red;}
    .version
    {
		position: absolute;
		bottom: 0; 
          right: 0;
		width: 100%;
		height: 0.5rem;
		font-size: 0.55rem;
		text-align: right;
	}
	</style>
	</head>
	<body>
	]]
end


-- HTML footer part for the HUD
function getHTMLFooter()
    return  string.format([[<div class="version">%s %s</div></body>]], version, description)
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
    local returnvalue = {}
    
    if id ~= nil then -- ID based
        returnvalue["habitat"] = habitats[id]
        returnvalue["surfaceDistanceLow"] = surfaceDistanceLow[id]
        returnvalue["surfaceDistanceLanding"] = surfaceDistanceLanding[id]
        returnvalue["surfaceDistanceHigh"] = surfaceDistanceHigh[id]
        returnvalue["surfaceSpeedLow"] = surfaceSpeedLow[id]
    else
        if unit.getAtmosphereDensity() > 0.0 then -- Atmo
            returnvalue["habitat"] = habitats[1]
            returnvalue["surfaceDistanceLow"] = surfaceDistanceLow[1]
            returnvalue["surfaceDistanceLanding"] = surfaceDistanceLanding[1]
            returnvalue["surfaceDistanceHigh"] = surfaceDistanceHigh[1]
            returnvalue["surfaceSpeedLow"] = surfaceSpeedLow[1]
        elseif core.g() >= gravity then -- Spacedock
            returnvalue["habitat"] = habitats[3] 
            returnvalue["surfaceDistanceLow"] = surfaceDistanceLow[3]
            returnvalue["surfaceDistanceLanding"] = surfaceDistanceLanding[3]
            returnvalue["surfaceDistanceHigh"] = surfaceDistanceHigh[3]
            returnvalue["surfaceSpeedLow"] = surfaceSpeedLow[3]
        else -- Space
            returnvalue["habitat"] = habitats[2]
            returnvalue["surfaceDistanceLow"] = surfaceDistanceLow[2]
            returnvalue["surfaceDistanceLanding"] = surfaceDistanceLanding[2]
            returnvalue["surfaceDistanceHigh"] = surfaceDistanceHigh[2]
            returnvalue["surfaceSpeedLow"] = surfaceSpeedLow[2]
        end 
    end
    
    return returnvalue
end


function getBrakeDistance(endingSpeed)
    local returnvalue = {}
    local distance = 0;
    local time = 0;
    local c = 30000*1000/3600
    local c2 = c*c

    
    local initialSpeed = vec3(core.getVelocity()):len() -- m/s
    --local initialSpeed = 20000 / 3.6 -- m/s --> For Testing
    endingSpeed = endingSpeed / 3.6 -- m/s
    local restMass = round(core.getConstructMass()) -- kg
    local spaceBrake = json.decode(unit.getData()).maxBrake -- N
    local totA = -spaceBrake * (1-0)/restMass;

    
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
    local remainder = distance - 200000 * su;
    local suFrac = round(100 * remainder / 200000) / 100;
    local km = round(distance / 1000);


    returnvalue["min"] = min
    returnvalue["sec"] = sec
    returnvalue["su"] = su + suFrac
    returnvalue["km"] = km
    returnvalue["time"] = time
    returnvalue["distance"] = distance


    return returnvalue
end





-- Getter & Setter END




-- Darkwinde END: library.start()