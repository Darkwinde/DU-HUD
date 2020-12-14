-- Darkwinde START: system.update()
-- LandingGear
-- >> Not allowed to have them in flush() anymore
if landing and unit.isAnyLandingGearExtended() == 0 then
    unit.extendLandingGears()
elseif not landing and unit.isAnyLandingGearExtended() == 1 then
    unit.retractLandingGears()
end
-- Darkwinde END: system.update()