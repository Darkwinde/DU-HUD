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
    * Taking care, that space docks (static space cores) have different glabal gravity
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

