## About
Dual Universe minimalistic HUD for Atmospheric and Space navigation
<br/><br/>

## Credits
* Based on Dimencia and his HUD implementation with extraordinary features; like interplanetary autopilot, automatic landing, door automatation or fuel information. Check out his space: https://github.com/Dimencia/DU-Orbital-Hud
* Expugnator for his collaborative work on this HUD implementation to keep it simple and stupid for all Dual Universe planet crash drivers :)
<br/><br/>

## Features
* Handbrake (Option 1)
* Auto landing gear by telemeter trigger
* Low altitude stabilization with safe landing
* Button switch toggle for door and force field
* Space docking indicator / message
<br/><br/>

## Prerequisite
**Mandatory**
* Telemeter on the bottom side of the ship to measure the distance to the surface. 
<br/><br/>

**Optional**
* Button "Manual Switch" to control "Door" and "Forcefield" by a "Relay".
     1. "Manual Switch" is linked to the "Relay".
     1. The "Relay" is linked to the "Door" and "Force Field"
     1. Pushing the button the door opens / closes and the force field is been activated / deactivated
<br/><br/>

## Installation
1. Run auto configuration script 
    1. Right click on commander seat
    1. Select "Run default autoconfigure" > "(Pilot) Flying construct"
1. Ensure that "Telemeter" element is linked to the commander seat. In case you are using a "Manual Switch" to control a door and dorce field by a relay, then name it to "btnDoor" in the LUA editor
![Lua 1](/media/LuaEditor_1.png)
<br/><br/>

From this point on, you can choose between two ways...
<br/><br/>

**File by File** 
<br/>
Copy and past each LUA file content to the according section of your commander seat.
<br/><br/>

*"CTRL + L" on commander seat to open ingame editor*
<br/><br/>
Example for the file "library.start.lua":<br/>

1. Open the file and copy content to the clipboard
1. According to the filename "**library**.start.lua" select the category "library".
1. According to the filename "library.**start**.lua" we need an event filter of type "start" without parameter; so we are looking for "start()" as event filter name.
    1. To create a new filter press "+ ADD FILTER"
    1. To select event filter type, click on three dots on the left side of the draft event and select "start".
    1. The draft event changes to "start()" 
1. Click into the right field and past content from clipboard by pressing "CTRL+V".
1. Do the same process with every further "*.lua" file. Important to note, that you can define multiple filter targeting same event, e.g. the "start()". They will be processed all one by one; so do noty worry about :)
1. Then you finished, do not forget set press "APPLY" to confirm changes.
1. Take a seat and have a nice flight.
<br/><br/>
![Lua 1](/media/LuaEditor_2.png)
<br/>

![Lua 1](/media/LuaEditor_3.png)
<br/>

![Lua 1](/media/LuaEditor_4.png)
<br/><br/>

**Clipboard**
1. Open file "clipboard.conf".
1. Copy the whole content to your clipboard. Recommanded to use "raw" format.
1. Ingame, perform right click on commander seat and select "Advanced > Past Lua configuration from clipboard" 
<br/><br/>

## Remarks
1. Configuration parameters are not exposed (topic for upcoming release). To change default parameters, you have to open the ingame editor and go to "unit" > "start()".
<br/><br/>

## Usage
1. For take off or landing action near a surface, use hotkey "Option 1". Game control default for this is "ALT + 1"
1. After take off, low altitude stabilization (LAS) takes action. LAS means lifting ship to a certain level (atmosphere 15m, space 5m) and holding it by braks not to drift away. To get out of LAS gain an additional meter of lift (e.g. pressing space) and you are free to fly.
1. You can controll thrust as usual. As braks are active on LAS, you could perform a small kick start like: 
<br/>> Set thrust to 100%
<br/>> Wait until you start drifting forward
<br/>> Press space to gain an additional meter height.
1. If you like to dock on a space construct and you always think "Am I or Am I not docked?". The GUI will present you a huge green message that it is save to leave the seat.
1. If you are in LAS range, you can always press hotkey "Option 1" for a safe landing and turn your ship around.
1. If you are on free flight (no LAS), pressing hotkey "Option 1" will give you a permanent brake force (handbrake). By pressing again it will be release.
<br/><br/>

![Take Off](/media/TakeOff.png)
<br/><br/>

![Space Flight](/media/SpaceFlight.png)
<br/><br/>

![Spacedock](/media/Docking.png)
<br/><br/>

## Upcoming Features
* Orbital overlay to show apoapsis, periapsis, apogee, perigee, eccentricity for the nearest planet, using these libraries: https://gitlab.com/JayleBreak/dualuniverse/-/tree/master/DUflightfiles/autoconf/custom
<br/><br/>

## Known Issues
* Pressing "TAB" to call native game overlay with sidebar and after mouse click on the gray overlay will cause massive lags
    * Also reproducible with other HTML overlays. 
    Therefor looks like a general issue from the game / design mechanic.
    * Will try to figure out, if replacing relevant information gives better performance instead of re-building overlay all the time
