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




-- Overload Functions START

-- Missing function in games "Navigator.lua"
function Navigator.maxForceUp(self)
    
	local axisCRefDirection = vec3(Nav.core.getConstructOrientationUp())
	local longitudinalEngineTags = 'thrust analog vertical'
	local maxKPAlongAxis = Nav.core.getMaxKinematicsParametersAlongAxis(longitudinalEngineTags, {axisCRefDirection:unpack()})

    if self.control.getAtmosphereDensity() == 0 then -- we are in space
		return maxKPAlongAxis[3]
    else
		return maxKPAlongAxis[1]
    end
end
function Navigator.maxForceDown(self)
    
	local axisCRefDirection = vec3(Nav.core.getConstructOrientationDown())
	local longitudinalEngineTags = 'thrust analog vertical'
	local maxKPAlongAxis = Nav.core.getMaxKinematicsParametersAlongAxis(longitudinalEngineTags, {axisCRefDirection:unpack()})
    
     if self.control.getAtmosphereDensity() == 0 then -- we are in space
		return maxKPAlongAxis[4]
     else
		return maxKPAlongAxis[2]
     end
end
-- Overload Functions END


-- Darkwinde END: library.start()