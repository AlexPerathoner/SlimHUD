# 1.5.3 - 
* Added blurred background effect;
* Fixed an issue that could cause the hud to be displayed below the menu bar or Dock in some circumstances;
* Changed the behavior of the hud to be displayed in a stationary position when Mission Control is activated;

Thanks to @zorth64 for implementing all these new fixes and features!

# 1.5.2 - Deep Sleep Hook
* Rehide System HUD after sleep / monitor changes / lid changes
* Fixed side grow in/out animation that would sometimes get stuck at half
* Fixed an issue that prevented internal monitor brightness retrieval after an external monitor was connected
* Fixed an issue that was preventing the huds from being shown when changing to a full screen application

# 1.5.1 - Background bar
* Better visibility of the bar by adding custom shadows

# 1.5.0 - New look
* Icons change depending on value
* Add multiple in-out animation styles
* New look for the settings window
* Add option to hide the menu bar icon

@kaydenanderson

# 1.4.2 - Improved non-continous checks
* Show system HUDs after SlimHUD quit
* Fix: HUDs didn't always appear when pressing keys 

# 1.4.1 - Fixes
* Add option to make inside bar flat or round
* Fix bug: icons not centered
* Fix bug: HUDs not resizable
* Fix bug: popovers memory leak in settings window

# 1.4.0 - Fixes
* Fix bug: hud too near to the screen edge
* Hiding MacOS' default HUD without modifying system configuration files.
* Fix bug: implemented new ways to retrieve brightness
* Fix bug: keyboard backlight hud working again
* Update to Sparkle 2
* Change in signing certificates: please update manually to the [latest release](https://github.com/AlexPerathoner/SlimHUD/releases/download/v1.4.0/SlimHUD.zip)!
* Disabling keyboard and display brightness bars until screen settings changes if it wasn't possible to retrieve their values

# 1.3.7 - Added support to macOS 10.13
* Added support to macOS 10.13
