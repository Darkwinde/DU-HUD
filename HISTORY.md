Version 0.3.1
* Autoconf file added to repro for easier use
* Bugfixes
    * Corrected Telemeter existence checks
    * If no Telemeter was connected to the commander seat, condition was preventing thrust control
    * Docking will no longer activate vertical engines and push ship away
* Optimizations
    * Changed space surface low default parameter from 5m to 1m
    * Changed way how vertical engine been deactivation (ALT+2)
    * AGG max speed and max gravity increased for faster altitude stabilization

---

Version 0.3
* AGG Support
    * Turn on and off by game default key bind (ALT + G)
    * Increase target altitude by Option 8 key bind (ALT + 8)
    * Decrease target altitude by Option 9 key bind (ALT + 9)
    * Remark / Note
        * Vertical engines (up and / or down) will try to stabilize the ship and work against AGG.<br>
        Therefor, vertical engines are turned off (thrust level 0) during AGG is been activated. Longitudinal engines are untouched and operable.
        * To reduce ship oscillation around target altitude, brakes are forced for a short time
* Bugfixes
    * Corrected vertical space engine deactivation form 2000km/h to 5000km/h
    * Docking will not work in cruise mode, therefor on docking message will switch over to travel mode now
    * Activate hand brake on docking
* Miscellaneous    
    * Cleanup of unit.start() event to reflect only configurable items
    * Default parameter initialization has been moved to a new init function called on start
    * Display numbers in a more readable way (powered by Richard Warburton)
    * Preparation for AGG screen extension
    * Experimental: Deactivate vertical engines by Option 2 key bind (ALT + 2)

---

Version 0.2.1
* Bugfixes
    * Corrected HUD refresh rate from 1.5s to 0.5s
    * Corrected Fuel Tank Optimization to Fuel Tank Handling (Piloting) as it was intended
    * Implementation of Fuel Tank Optimization (Mining & Inventory)
    * Taking into account that Container Optimization also impacting Fuel Tank mass reduction
    * Increased default payload overhead from 10% to 25%

---

Version 0.2
* Usage of Telemeter Unit is now mandatory
* Integration of Orbital Widget
* Integration of NQ standard flight telemetric:
    * Fuel Tanks
    * Acceleration
    * Thrust
    * Atmospheric Density
    * Air Resistance
    * Travel Mode
* New HUD information:
    * Show estimated distance to surface
    * Show estimated possible remaining payload based on current atmospheric environment and ship parameter
    * Show vertical velocity
* At high speed (>50km/h) sitting down to command chair will not activate handbrake
* At space reaching 2000km/h will deactivate vertical maneuver engines to safe fuel
* Show cruise mode in HUD
* Changes to the HUD placement and information
* Dynamic information change between space and atmospheric
* Bugfixes
    * Altitude stabilization was reset on environmental change (space <> atmospheric)
    * Taking care, that space docks (static space cores) have different global gravity values
    * Jumping time information for brake distance
    * Atmospheric brake workaround as not part of json.decode(unit.getData()).maxBrake 

---

Version 0.1
* Handbrake (Option 1)
* Auto landing gear by telemeter trigger
* Low altitude stabilization with safe landing
* Button switch toggle for door and force field
* Space docking indicator / message

---

