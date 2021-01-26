-- Darkwinde START: system.actionStart(option 2)
-- >> Option 2 is by default ALT+2


-- Deactivate vertical stabilization on user request
verticalEngines = not verticalEngines

-- Change to travel mode, as cruise will prevent AGG to take ship down / up
if Nav.control.getControlMasterModeId() == 1 then
    Nav.control.cancelCurrentControlMasterMode()
end

-- Darkwinde END: system.actionStart(option 2)