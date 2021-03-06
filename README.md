## About
Dual Universe minimalistic HUD for Atmospheric and Space navigation
<br/><br/>

## Credits
* Inspired and based on Dimencia's HUD implementation with extraordinary features; like interplanetary autopilot, automatic landing, door automation or fuel information. Check out his space: https://github.com/Dimencia/DU-Orbital-Hud
* JayleBreak and his orbital maths/atlas: https://gitlab.com/JayleBreak/dualuniverse/-/tree/master/DUflightfiles/autoconf/custom
* Richard Warburton and the way to make number look nice by function call (http://richard.warburton.it)
* Expugnator for his collaborative work on this HUD implementation to keep it simple and stupid for all Dual Universe planet crash drivers :)
<br/><br/>

## Features
* Option 1 key bind (ALT + 1) 
    * Auto take off and landing near surface
    * Free flight activate / deactivate handbrake
* Option 2 key bind (ALT + 2) 
    * Toggle vertical engines on and off
    * HUD indicator on activation by "(v)" as part the "Flight Style"
* AGG Support
    * Turn on and off by game default key bind (ALT + G)
    * Increase target altitude by Option 8 key bind (ALT + 8)
    * Decrease target altitude by Option 9 key bind (ALT + 9)
    * Remark / Note
        * Vertical engines (up and / or down) will try to stabilize the ship and work against AGG.<br>
        Therefor, vertical engines are turned off (thrust level 0) during AGG is been activated. Longitudinal engines are untouched and operable.
        * To reduce ship oscillation around target altitude, brakes are forced for a short time
* Orbital overlay near planet
* Auto landing gear by telemeter trigger
* Low altitude stabilization for safe landing
* Button switch toggle for door and force field
* Space docking indicator / message
* Show estimated distance to surface
* Show estimated possible remaining payload based on current atmospheric environment and ship parameter
* Show vertical velocity
* No fuel tank connection to commander seat unit required
<br/><br/>

## Prerequisite
**Mandatory**
* Telemeter on the bottom side of the ship to measure the distance to the surface. 
<br/><br/>

**Optional**
* Button "Manual Switch" to control "Door" and "Force Field" by a "Relay".
     1. "Manual Switch" is linked to the "Relay".
     1. The "Relay" is linked to the "Door" and "Force Field"
     1. Pushing the "Manual Switch" the door opens / closes and the force field is been activated / deactivated
     1. "Manual Switch" is linked to the command seat and slot is named "btnDoor" in the LUA editor
* Fuel tank connection to commander seat unit
    * Fuel tanks (atmo, space and rocket) are gathered from core element information list. 
    * Therefor no direct link between commander seat and fuel tanks required. This saves slots for further purposes, like Anti Gravity Generator (AGG), data banks, manual switches or any other kind of extension.
    * Just modify the user variables "coo", "fto", "fthAtmo", "fthSpace" and "fthRocket" in unit.start() according to your skill level
<br/><br/>

## Installation
**Auto Configuration File** 
1. Download autoconf file: [/autoconf/minimalistic_hud_darkwinde_and_expugnator.conf](/autoconf/minimalistic_hud_darkwinde_and_expugnator.conf)
1. Place file to the custom LUA auto configuration directory.<br/>
Example game path: D:\Dual Universe\Game\data\lua\autoconf\custom
1. In case DU was already started before
    1. Right click on commander seat
    1. Select "Advanced" > "Update custom autoconf list"
1.Load scipt into commander seat
    1. Right click on commander seat
    1. Select "Advanced" > "Run custom autoconfigure" > "HUD from Darkwinde & Expugnator (vXX.YY.ZZ)"
![Autoconf](/media/Autoconf.png)
1. Confirm warning
1. Take a seat and have a nice flight.

<br/><br/>

**File by File** 
1. Run auto configuration script 
    1. Right click on commander seat
    1. Select "Run default autoconfigure" > "(Pilot) Flying construct"
1. Ensure that "Telemeter" element is linked to the commander seat. In case you are using a "Manual Switch" to control a door and force field by a relay, then name it to "btnDoor" in the LUA editor
![Lua 1](/media/LuaEditor_1.png)
<br/><br/>
<br/>
1. Copy and past each LUA file content to the according section of your commander seat. *"CTRL + L" on commander seat to open ingame editor*
<br/><br/>
Example for the file "library.start.lua":<br/>

1. Open the file and copy content to the clipboard
1. According to the filename "**library**.start_1.lua" select the category "library".
1. According to the filename "library.**start**_1.lua" we need an event filter of type "start" without parameter; so we are looking for "start()" as event filter name.
    1. To create a new filter press "+ ADD FILTER"
    1. To select event filter type, click on three dots on the left side of the draft event and select "start".
    1. The draft event changes to "start()" 
1. Click into the right field and past content from clipboard by pressing "CTRL+V".
1. Do the same process with every further "*.lua" file.    
    * Important to note, that you can define multiple filter targeting same event, e.g. the "start()". They will be processed all one by one; so do not worry about :)
    * If I have defined multiple filter targeting the same event, they are distinguished by a underscore plus counter. E.g.: library.start_**1**.lua and library.start_**2**.lua would mean you have two start() filter in library.
1. Then you finished, do not forget set press "APPLY" to confirm changes.
1. Take a seat and have a nice flight.

<br/><br/>
![Lua 1](/media/LuaEditor_2.png)
<br/>

![Lua 1](/media/LuaEditor_3.png)
<br/>

![Lua 1](/media/LuaEditor_4.png)
<br/><br/>


## Usage
1. For take off or landing action near a surface, use hotkey "Option 1". Game control default for this is "ALT + 1"
1. After take off, low altitude stabilization (LAS) takes action. LAS means lifting ship to a certain level (atmosphere 15m, space 5m) and holding it by brakes not to drift away. To get out of LAS gain an additional meter of lift (e.g. pressing space) and you are free to fly.
1. You can control thrust as usual. As brakes are active on LAS, you could perform a small kick start like: 
<br/>> Set thrust to 100%
<br/>> Wait until you start drifting forward
<br/>> Press space to gain an additional meter height.
1. If you like to dock on a space construct and you always think "Am I or Am I not docked?". The GUI will present you a huge green message that it is save to leave the seat.
1. If you are in LAS range, you can always press hotkey "Option 1" for a safe landing and turn your ship around.
1. If you are on free flight (no LAS), pressing hotkey "Option 1" will give you a permanent brake force (handbrake). By pressing again it will be release.
<br/><br/>

![Take Off](/media/TakeOff.png)
<br/><br/>

![Spacedock](/media/Docking.png)
<br/><br/>

![Space Flight](/media/SpaceFlight_1.png)
<br/><br/>

![Space Flight](/media/SpaceFlight_2.png)
<br/><br/>

![Space Flight](/media/SpaceFlight_3.png)
<br/><br/>

![Space Flight](/media/AtmoFlight_1.png)
<br/><br/>

![Space Flight](/media/AtmoFlight_2.png)
<br/><br/>

![Space Flight](/media/AtmoFlight_3.png)
<br/><br/>

## Upcoming Features
* Artificial Horizon / Gyro Horizon / Attitude Indicator
<br/><br/>

## Known Issues & Limitations
* Not tested with cockpits
