-- Darkwinde START: system.update()


-- FEATURE START: hudShowStatus
local hudShowBrakeStatus = ternary(lockBrake, '<div class="on">on</div>', '<div class="off">off</div>')
local hudShowAltitude = round(core.getAltitude()) .. 'm'
local hudShowLocalGravity = round(core.g(), 3) .. 'm/s²'
--local hudShowWorldGravity = round(core.getWorldGravity()) .. 'm/s²'
local velocity_X = round(core.getVelocity()[1])
local velocity_Y = round(core.getVelocity()[2])
local velocity_Z = round(core.getVelocity()[3])
local hudShowSpeed = round(core.getVelocity()[2] * 3.6) .. 'km/h'
local hudShowVelocity = 'x=' .. velocity_X .. ' / y=' .. velocity_Y .. ' / z=' .. velocity_Z .. 'm/s'
local hudShowTelemeterDistance =  round(telemeter.getDistance()) .. 'm'


local css = 
[[
    <style>
        .primary {
        font-size: 1rem;
        color: #B6DFED;
        }

        .zen {
        display: flex;
        flex-direction: column;
        }

        .controls-hud {
          display: flex;
          flex-direction: column;
          justify-content: space-around;
          background-color: #34495E50;
          border-color: #333333;
          border-radius: 12px;
          width: 20%;
          padding: 1% 1.5%;
          overflow: none;
        }

        .control-container {
          display: flex;
          justify-content: space-between;
          padding: 1%;
        }
        .on {
          background-color: red;
          margin-left: 10px;
          border-radius: 50%;
          width: 28px;
          height: 28px;
          border: 2px solid black;
          text-align: center;
        }

        .off {
          background-color: green;
          margin-left: 10px;
          border-radius: 50%;
          width: 28px;
          height: 28px;
          border: 2px solid black;
          text-align: center;
        }

    </style>
]]


local html = 
[[
	<div class="zen">
          <div class="controls-hud">
			<div class="primary control-container">
				<p class="primary">Handbrake status:</p>
				]] .. hudShowBrakeStatus .. [[
			</div>
			<div class="primary control-container">
				<p class="primary">Altitude: </p>
				]] .. hudShowAltitude .. [[
			</div>

			<div class="primary control-container">
				<p class="primary">Surface Distance: </p>
				]] .. hudShowTelemeterDistance .. [[
			</div>

			<div class="primary control-container">
				<p class="primary">Locale Gravity: </p>
				]] .. hudShowLocalGravity .. [[
			</div>
			<div class="primary control-container">
				<p class="primary">Velocity: </p>
				]] .. hudShowVelocity .. [[
			</div>
			<div class="primary control-container">
				<p class="primary">Front Speed: </p>
				]] .. hudShowSpeed .. [[
			</div>
		</div>
	</div>
]]




system.setScreen(css .. html)
system.showScreen(1)
-- FEATURE END: hudShowStatus


-- Darkwinde END: system.update()